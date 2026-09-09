
/**
 * login.p -
 *
 * (c) Copyright ABC Alon Blich Consulting Tech, Ltd.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 *  Contact information
 *  Email: alonblich@gmail.com
 *  Phone: +263-77-7600818
 */

{src/web/method/wrap-cgi.i}

{slib/crud/global.i}

{store/user.i}

{slib/sliberr.i}

define buffer crud_user             for crud_user.
define buffer crud_session          for crud_session.
define buffer crud_block_list       for crud_block_list.
define buffer crud_login_history    for crud_login_history.

define new shared var pcInputParam  as longchar no-undo.
define new shared var pcOutputParam as longchar no-undo.

define var pcUserName       as char no-undo.
define var pcPassword       as char no-undo.
define var pcNewPassword    as char no-undo.
define var pcSessionId      as char no-undo.
define var piExpiryDays     as int no-undo.

define var pcErrorCode      as char no-undo.
define var pcErrorMsg       as char no-undo.
define var pcErrorParams    as char no-undo.
define var pcStackTrace     as char no-undo.

define var ok               as log no-undo.
define var t                as datetime-tz no-undo.
define var i                as int no-undo.

assign
    pcErrorCode     = ?
    pcErrorMsg      = ?
    pcErrorParams   = ?
    pcStackTrace    = ?.

{slib/err_try}:

    run readRequest.

    if      not ( ( gbCrudApp.fixed_ip_address = ""
         or can-do( gbCrudApp.fixed_ip_address, gcCrudIpAddress ) )
    and not can-do( gbCrudApp.exclude_ip_address, gcCrudIpAddress ) ) then

        {slib/err_throw "'access_denied'"}.

    t = add-interval( now, -1 * gbCrudApp.block_timeout, "minutes" ).

    if can-find(
        first crud_block_list
        where crud_block_list.ip_address = gcCrudIpAddress
          and crud_block_list.last_hit  >= t
          and crud_block_list.ip_blocked ) then

        {slib/err_throw "'ip_blocked'"}.

    do transaction:

        if  pcUserName      <> ?
        and pcPassword      <> ?
        and pcNewPassword    = ?
        and pcSessionId      = ? then
            run login.

        else
        if  pcUserName      <> ?
        and pcPassword      <> ?
        and pcNewPassword   <> ?
        and pcSessionId      = ? then do:

            find first crud_user
                 where crud_user.username = pcUsername
                 no-lock no-error.

            if avail crud_user and crud_user.change_password then
                run changeTempPassword.
            else
                run changeOldPassword.

        end. /* change password */

        else
        if  pcUserName      <> ?
        and pcPassword      <> ?
        and pcNewPassword    = ?
        and pcSessionId     <> ? then
            run eSign.

        else
        if  pcUserName       = ?
        and pcPassword       = ?
        and pcNewPassword    = ?
        and pcSessionId     <> ? then
            run logout.

        if return-value <> "" then
            pcErrorCode = return-value.

    end. /* _trans */

    if pcErrorCode <> ? then do:

        if pcErrorCode = "ip_blocked" then
           pcErrorCode = "access_denied".

        else
        if pcErrorCode <> "access_blocked" then
            run blocktrycnt.p.

        {slib/err_throw pcErrorCode}.

    end. /* pcErrorCode <> ? */

{slib/err_catch pcErrorCode pcErrorMsg pcErrorParams pcStackTrace}:

{slib/err_end}.

run writeResponse.



procedure login:

    run checkPassword.
    if return-value <> "" then
        return return-value.

    repeat:

        pcSessionId = encode(
            string( base64-encode( generate-uuid ) ) +
            string( random( 0, 999999 ) ) ).

        if not can-find(
            first crud_session
            where crud_session.session_id = pcSessionId
            use-index session_id ) then
                leave.

    end. /* repeat */

    find first crud_user
         where crud_user.username = pcUserName
         no-lock no-error.

    if avail crud_user then do:

        if gbCrudApp.block_access then do:

            if lookup( "admin", crud_user.user_roles ) = 0 then
                return "access_blocked".

        end. /* block_access */

        if      not ( ( crud_user.fixed_ip_address = ""
             or can-do( crud_user.fixed_ip_address, gcCrudIpAddress ) )
        and not can-do( crud_user.exclude_ip_address, gcCrudIpAddress ) ) then
            return "ip_blocked".

    end. /* avail crud_user */

    create crud_session.
    assign
        crud_session.session_id = pcSessionId
        crud_session.username   = pcUserName
        crud_session.ip_address = gcCrudIpAddress
        crud_session.user_agent = gcCrudUserAgent
        crud_session.last_hit   = now
        crud_session.start_time = now
        crud_session.is_busy    = no
        crud_session.is_online  = no.

    find last  crud_login_history
         where crud_login_history.username      = crud_session.username
           and crud_login_history.ip_address    = crud_session.ip_address
         use-index user_ip_start
         no-lock no-error.

    if not avail crud_login_history
    or now - crud_login_history.start_time > 28800000 /* 8 hours */ then do:

        create crud_login_history.
        assign
            crud_login_history.username             = crud_session.username
            crud_login_history.ip_address           = crud_session.ip_address
            crud_login_history.user_agent           = crud_session.user_agent
            crud_login_history.start_time           = now
            crud_login_history.last_hit             = now
            crud_login_history.request_cnt          = 0
            crud_login_history.request_total_time   = 0.

    end. /* not avail */

    for each  crud_login_history
        where crud_login_history.username = crud_session.username
        use-index user_ip_start
        exclusive-lock

        break
        by crud_login_history.username
        by date( crud_login_history.start_time ) descend:

        if first-of( date( crud_login_history.start_time ) ) then
          accumulate date( crud_login_history.start_time ) ( count by crud_login_history.username ).

        if ( accum count by crud_login_history.username ( date( crud_login_history.start_time ) ) ) > gbCrudApp.login_history_days then
            delete crud_login_history.

    end. /* for each crud_login_history */

    run unblock.
    if return-value <> "" then
        return return-value.

end procedure. /* login */

procedure changeOldPassword:

    run changepPassword.
    if return-value <> "" then
        return return-value.

    run unblock.
    if return-value <> "" then
        return return-value.

end procedure. /* changeOldPassword */

procedure changeTempPassword:

    run changePassword.
    if return-value <> "" then
        return return-value.

    pcPassword = pcNewPassword.

    run login.
    if return-value <> "" then
        return return-value.

    run unblock.
    if return-value <> "" then
        return return-value.

end procedure. /* changeTempPassword */

procedure eSign:

    run fetchSession.
    if return-value <> "" then
        return return-value.

    else
    if pcUserName <> crud_session.username then
        return "wrong_username_password".

    run checkPassword.
    if return-value <> "" then
        return return-value.

end procedure. /* eSign */

procedure logout:

    find first crud_session
         where crud_session.session_id = pcSessionId
         use-index session_id
         exclusive-lock no-error.

    if crud_session.ip_address <> gcCrudIpAddress
    or crud_session.user_agent <> gcCrudUserAgent then
        return "session_ip_mismatch".

    if avail crud_session then
    assign
        crud_session.last_hit   = datetime-tz( 01, 01, 1970, 00, 00, 00, 0 )
        crud_session.is_online  = no.

    run purge.p.

end procedure. /* logout */



procedure checkPassword:

    create input_header.
    assign input_header.service_operation = "checkpassword".

    create param_values.
    assign
        param_values.username   = pcUserName
        param_values.password   = pcPassword.

    run store/user.p (
        ( dataset input_param:handle ),
        ( dataset output_param:handle ) ).

    find first output_header no-error.
    if output_header.error_code <> ? then
        return output_header.error_code.

    find first output_param_values no-error.

    piExpiryDays = output_param_values.expiry_days.

end procedure. /* checkPassword */

procedure changePassword:

    create input_header.
    assign input_header.service_operation = "changepassword".

    create param_values.
    assign
        param_values.username       = pcUserName
        param_values.password       = pcPassword
        param_values.new_password   = pcNewPassword.

    run store/user.p (
        ( dataset input_param:handle ),
        ( dataset output_param:handle ) ).

    find first output_header no-error.
    if output_header.error_code <> ? then
        return output_header.error_code.

end procedure. /* changePassword */

procedure fetchSession:

    define var t as datetime-tz no-undo.

    t = add-interval( now, -1 * gbCrudApp.session_timeout, "minutes" ).

    find first crud_session
         where crud_session.session_id = pcSessionId
           and ( crud_session.last_hit > t
              or crud_session.is_online )

         use-index session_id
         exclusive-lock no-error.

    if not avail crud_session then
        return "session_expired".

    else
    if crud_session.ip_address <> gcCrudIpAddress
    or crud_session.user_agent <> gcCrudUserAgent then
        return "session_ip_mismatch".

    assign
        crud_session.last_hit = now.

end procedure. /* fetchSession */

procedure unblock:

    find first crud_block_list
         where crud_block_list.ip_address = gcCrudIpAddress
         exclusive-lock no-error.

    if avail crud_block_list then
      delete crud_block_list.

end procedure. /* unblock */



procedure readRequest:

    assign
        pcUserName      = ?
        pcPassword      = ?
        pcNewPassword   = ?
        pcSessionId     = ?
        piExpiryDays    = ?.

    if web-context:is-json then do:

        define var jParser as Progress.Json.ObjectModel.ObjectModelParser no-undo.
        define var jObject as Progress.Json.ObjectModel.JsonObject no-undo.

        jParser = new Progress.Json.ObjectModel.ObjectModelParser().

        jObject = cast( jParser:Parse( web-context:form-long-input ), Progress.Json.ObjectModel.JsonObject ).
        jObject = jObject:GetJsonObject( "request" ).

        if jObject:Has( "username" ) then
            pcUserName = jObject:GetCharacter( "username" ).

        if jObject:Has( "password" ) then
            pcPassword = jObject:GetCharacter( "password" ).

        if jObject:Has( "newPassword" ) then
            pcNewPassword = jObject:GetCharacter( "newPassword" ).

        if jObject:Has( "sessionId" ) then
            pcSessionId = jObject:GetCharacter( "sessionId" ).

        delete object jParser.

    end. /* is-json */

    else do:

        assign
            pcUserName      = get-field( "username" )
            pcPassword      = get-field( "password" )
            pcNewPassword   = get-field( "newPassword" )
            pcSessionId     = get-field( "sessionId" ).

    end. /* else */

    if pcUserName = "" then
       pcUserName = ?.

    if pcPassword = "" then
       pcPassword = ?.

    if pcNewPassword = "" then
       pcNewPassword = ?.

    if pcSessionId = "" then
       pcSessionId = ?.

    catch e as Progress.Lang.ProError:

        {slib/err_throw "'invalid_request'"}.

    end catch.

end procedure. /* readRequest */

procedure writeResponse:

    define var jWrapper     as Progress.Json.ObjectModel.JsonObject no-undo.
    define var jResponse    as Progress.Json.ObjectModel.JsonObject no-undo.

    jResponse = new Progress.Json.ObjectModel.JsonObject().

    if pcSessionId <> ? then
        jResponse:Add( "sessionId", pcSessionId ).

    if piExpiryDays <> ? then
        jResponse:Add( "expiryDays", piExpiryDays ).

    if pcErrorCode <> ? then
        jResponse:Add( "errorCode", pcErrorCode ).

    if pcErrorMsg <> ? then
        jResponse:Add( "errorMsg", pcErrorMsg ).

    if pcErrorParams <> ? then
        jResponse:Add( "errorParams", pcErrorParams ).

    if pcStackTrace <> ? then
        jResponse:Add( "stackTrace", pcStackTrace ).

    jWrapper = new Progress.Json.ObjectModel.JsonObject().
    jWrapper:Add( "response", jResponse ).

    output-content-type( "application/json" ).
    jWrapper:WriteStream( "WEBSTREAM" ).

    delete object jWrapper.

end procedure. /* writeResponse */
