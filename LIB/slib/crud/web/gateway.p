
/**
 * gateway.p -
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

{slib/slibos.i}

{slib/slibunix.i}

{slib/slibstr.i}

{slib/sliberr.i}

{slib/slibpro.i}

define              var pcSessionId     as char no-undo.
define              var pcRequestId     as char no-undo.
define              var pcServiceName   as char no-undo.
define              var piTimeout       as int no-undo.
define new shared   var pcInputParam    as longchar no-undo.
define new shared   var pcOutputParam   as longchar no-undo.

define              var pcErrorCode     as char no-undo.
define              var pcErrorMsg      as char no-undo.
define              var pcErrorParams   as char no-undo.
define              var pcStackTrace    as char no-undo.

define var cFileName    as char no-undo.
define var t            as datetime-tz no-undo.
define var i            as int no-undo.
define var j            as int no-undo.

assign
    pcErrorCode     = ?
    pcErrorMsg      = ?
    pcErrorParams   = ?
    pcStackTrace    = ?.

{slib/err_try}:

    run readRequest.

    _trans:

    do transaction:

        t = add-interval( now, -1 * gbCrudApp.session_timeout, "minutes" ).

        find first crud_session
             where crud_session.session_id = pcSessionId
               and ( crud_session.last_hit > t
                  or crud_session.is_online )

             use-index session_id
             exclusive-lock no-error.

        if not avail crud_session then do:
            pcErrorCode = "session_expired".
            leave _trans.
        end.

        else
        if crud_session.ip_address <> gcCrudIpAddress
        or crud_session.user_agent <> gcCrudUserAgent then do:
            pcErrorCode = "session_ip_mismatch".
            leave _trans.
        end.

        find first crud_user
             where crud_user.username = crud_session.username
             no-lock no-error.

        if avail crud_user then do:

            j = num-entries( crud_user.user_roles ).
            do i = 1 to j:

                find first crud_role
                     where crud_role.role_id = entry( i, crud_user.user_roles )
                     no-lock no-error.

                if avail crud_role

                and not ( ( crud_role.role_services = ""
                         or can-do( crud_role.role_services,            pcServiceName ) )
                    and not can-do( crud_role.role_exclude_services,    pcServiceName ) ) then do:

                    pcErrorCode = "access_denied".
                    leave _trans.

                end. /* avail rud_role */

            end. /* 1 to j */

        end. /* avail crud_user */

        assign
            crud_session.last_hit = now.

        find first crud_agent
             where crud_agent.agent_pid = gcCrudAgentPid
             exclusive-lock no-error.

        if not avail crud_agent then do:

            create crud_agent.
            assign
                crud_agent.agent_pid            = gcCrudAgentPid
                crud_agent.request_cnt          = 0
                crud_agent.request_total_time   = 0.0.

        end. /* not avail crud_agent */

        assign
            crud_agent.session_id   = pcSessionId
            crud_agent.request_id   = pcRequestId
            crud_agent.service_name = pcServiceName
            crud_agent.time_out     = now + piTimeout
            crud_agent.input_param  = pcInputParam.

        find last  crud_login_history
             where crud_login_history.username      = crud_session.username
               and crud_login_history.ip_address    = crud_session.ip_address
             use-index user_ip_start
             exclusive-lock no-error.

        if avail crud_login_history then
        assign
            crud_login_history.last_hit     = now
            crud_login_history.request_cnt  = crud_login_history.request_cnt + 1.

        find first crud_block_list
             where crud_block_list.ip_address = gcCrudIpAddress
             exclusive-lock no-error.

        if avail crud_block_list then
          delete crud_block_list.

        assign
            gcCrudServiceName   = pcServiceName
            gcCrudUsername      = crud_session.username
            gcCrudUserRoles     = ( if avail crud_user then crud_user.user_roles else "guest" )
            gcCrudSessionId     = pcSessionId
            gcCrudRequestId     = pcRequestId.

    end. /* transaction */

    if pcErrorCode <> ? then do:

        if pcErrorCode = "ip_blocked" then
           pcErrorCode = "access_denied".

        else
            run blocktrycnt.p.

        {slib/err_throw pcErrorCode}.

    end. /* pcErrorCode <> ? */



    cFileName = pro_getRunFile( pcServiceName + ".p" ).
    if cFileName = ? then
        {slib/err_throw "'file_not_found'" "pcServiceName + '.p'"}.

    _try:

    do:

        do on quit undo, leave
           on stop undo, leave
           on error undo, leave
           on endkey undo, leave:

            run value( cFileName ) ( ?, ? ) no-error.
            if error-status:num-messages > 0 then
                leave.

            leave _try.

        end. /* on quit */

        run err_NoError( return-value ).

    end. /* _try */

{slib/err_catch pcErrorCode pcErrorMsg pcErrorParams pcStackTrace}:

{slib/err_finally}:

    do transaction:

        if  avail crud_user
        and crud_user.activate_log then do:

            create crud_log.
            assign
                crud_log.username       = crud_session.username
                crud_log.start_time     = crud_agent.last_hit
                crud_log.end_time       = now
                crud_log.ip_address     = crud_session.ip_address
                crud_log.user_agent     = crud_session.user_agent
                crud_log.service_name   = crud_agent.service_name
                crud_log.input_param    = crud_agent.input_param.

        end. /* crud_user.active_log */

        find current crud_login_history exclusive-lock no-error.
        if avail crud_login_history then
        assign
            crud_login_history.request_total_time = crud_login_history.request_total_time
                + ( now - crud_login_history.last_hit + 1 ).

    end. /* transaction */

{slib/err_end}.

run writeResponse.



procedure readRequest:

    define var cFile    as char no-undo.
    define var cDir     as char no-undo.
    define var cExt     as char no-undo.
    define var i        as int no-undo.

    assign
        pcSessionId     = ?
        pcRequestId     = ?
        pcServiceName   = ?
        piTimeout       = ?
        pcInputParam    = ""
        pcOutputParam   = "".

    if web-context:is-json then do:

        define var jParser as Progress.Json.ObjectModel.ObjectModelParser no-undo.
        define var jObject as Progress.Json.ObjectModel.JsonObject no-undo.

        jParser = new Progress.Json.ObjectModel.ObjectModelParser().

        jObject = cast( jParser:Parse( web-context:form-long-input ), Progress.Json.ObjectModel.JsonObject ).
        jObject = jObject:GetJsonObject( "request" ).

        if jObject:Has( "sessionId" ) then
            pcSessionId = jObject:GetCharacter( "sessionId" ).

        if jObject:Has( "requestId" ) then
            pcRequestId = jObject:GetCharacter( "requestId" ).

        if jObject:Has( "timeout" ) then
            piTimeout = jObject:GetInteger( "timeout" ).

        if jObject:Has( "serviceName" ) then
            pcServiceName = jObject:GetCharacter( "serviceName" ).

        if jObject:Has( "inputParam" ) then
            pcInputParam = jObject:GetLongchar( "inputParam" ).

        delete object jParser.

    end. /* is-json */

    else do:

        assign
            pcSessionId     = get-field     ( "sessionId" )
            pcRequestId     = get-field     ( "requestId" )
            pcServiceName   = get-field     ( "serviceName" )
            pcInputParam    = get-long-value( "inputParam" ).

        assign
            piTimeout       = int( get-field( "timeout" ) ) no-error.

    end. /* else */

    if pcSessionId = "" then
       pcSessionId = ?.

    if pcRequestId = "" then
       pcRequestId = ?.

    if pcServiceName = "" then
       pcServiceName = ?.

    if piTimeout <= 0 then
       piTimeout = ?.

    if pcInputParam = "" then
       pcInputParam = ?.

    if pcRequestId = ? then
       pcRequestId = string( now - datetime( 01, 01, 1970, 00, 00, 00 ) ).

    if pcServiceName <> ? then do:

        run unix_breakPath(
            input   pcServiceName,
            output  cDir,
            output  cFile,
            output  cExt ).

        i = num-entries( cDir, "/" ).
        if i >= 2 then
            cDir = entry( i - 1, cDir, "/" ) + "/".
        else
            cDir = "".

        pcServiceName = cDir + cFile.

    end. /* pcServiceName <> ? */

    catch e as Progress.Lang.ProError:

        {slib/err_throw "'invalid_request'"}.

    end catch.

end procedure. /* readRequest */

procedure writeResponse:

    define var jWrapper     as Progress.Json.ObjectModel.JsonObject no-undo.
    define var jResponse    as Progress.Json.ObjectModel.JsonObject no-undo.

    if output-content-type <> ? and output-content-type <> "" then
        return.

    jResponse = new Progress.Json.ObjectModel.JsonObject().

    if pcOutputParam <> ? and pcOutputParam <> "" then
        jResponse:Add( "outputParam", pcOutputParam ).

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

    delete object jResponse.

end procedure. /* writeResponse */
