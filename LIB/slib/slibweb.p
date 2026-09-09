
/**
 * slibweb.p -
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

{slib/slibwebfrwd.i "forward"}

{slib/slibwebprop.i}

{slib/sliberr.i}

{slib/slibpro.i}

{src/web/method/cgidefs.i}
{src/web/method/admweb.i}




function isLoginRequired    returns log private     ( pcAppProgram as char ) forward.
function isAccessDenied     returns log private     ( pcAppProgram as char ) forward.

function getStateField      returns char private    ( pcStateType as char, pcFieldName as char ) forward.
function setStateField      returns log private     ( pcStateType as char, pcFieldName as char, pcFieldValue as char ) forward.

function nextStateId        returns char private forward.
function isTimeout          returns log private     ( ptDate as date, piTime as int ) forward.



define var cDbConnList as char no-undo.

on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* on close */

procedure initializeProc:

    define var i as int no-undo.

    cDbConnList = "".    

    do i = 1 to num-dbs:

        cDbConnList = cDbConnList
            + ( if cDbConnList <> "" then "," else "" )
            + ldbname(i).

    end. /* 1 to num-dbs */

end procedure. /* initializeProc */



procedure web_request:

    define var cError       as char no-undo.
    define var cErrorMsg    as char no-undo.
    define var cStackTrace  as char no-undo.
    
    define var i            as int no-undo.

    {slib/err_try}:

        do i = 1 to num-entries( cDbConnList ):

            if not connected( entry( i, cDbConnList ) ) then

                {slib/err_throw "'db_disconnect'" "entry( i, cDbConnList )"}.

        end. /* 1 to num-entries */



        run fetchState.

        run runWebObject( AppProgram ).

        run saveState.

    {slib/err_catch cError cErrorMsg cStackTrace}:

        run writeMessage( replace( cErrorMsg, chr(1), "~n" ) + "~nStack Trace:~n" + cStackTrace ).

        if cError = "'db_disconnect'" then

            {slib/err_quit}. /* force agent restart */

    {slib/err_end}.

end procedure. /* web_request */

procedure web_redirect:

    define input param pcUrl    as char no-undo.
    define input param pcType   as char no-undo.

    if pcType = ? then
       pcType = "302".

    case pcType:

        when "301" or 
        when "302" then do:

            output-http-header( "Status", ( if pcType = "301" then "301 Moved Permanently" else "302 Redirect" ) ).
            output-http-header( "Location", pcUrl ).
            output-http-header( "", "" ).

        end. /* 3xx */

        when "meta" then do:

            output-content-type( "text/html" ).

            {&out} '<html>' skip.
            {&out} '<head>' skip.
            {&out} '<meta http-equiv="Refresh" content="0;url=' html-encode( pcUrl ) '" />' skip.
            {&out} '</head>' skip.
            {&out} '<body>' skip.
            {&out} '</body>' skip.
            {&out} '</html>' skip.

        end. /* meta */

    end case. /* pcType */

end procedure. /* web_redirect */

procedure writeMessage private:

    define input param pcMsg as char no-undo.

    define var i as int no-undo.

    do i = 1 to num-entries( pcMsg, "~n" ):

        &if {&pro_xProversion} >= "10.1a" &then

            log-manager:write-message( entry( i, pcMsg, "~n" ) ).

        &else

            message entry( i, pcMsg, "~n" ).

        &endif

    end. /* 1 to num-entries */

end procedure. /* writeMessage */



procedure fetchState private:

    define buffer state_obj     for state_obj.
    define buffer state_field   for state_field.

    define var cProgramStateId  as char no-undo.
    define var cSessionStateId  as char no-undo.

    define var cError           as char no-undo.

    run cleanState.

    {slib/err_try}:

        empty temp-table web_ttField.

        assign
            web_cStateType          = "session"
            web_cUserId             = "guest"

            web_cSessionStateId     = ?
            web_lSessionFirstHit    = no

            web_cProgramStateId     = ?
            web_lProgramFirstHit    = no.

        assign
           cSessionStateId = get-cookie( "ssid" )
           cProgramStateId = get-field( "sid" ).



        if cSessionStateId = "" then
        run createSessionState.

        else do:

            find first state_obj
                 where state_obj.state_id = cSessionStateId
                 no-error.

            if not avail state_obj
            or isTimeout(
                    state_obj.last_hit_date,
                    state_obj.last_hit_time ) then

                {slib/err_throw "'web_session_timeout'"}.

            assign
                web_cStateType          = "session"
                web_cUserId             = state_obj.user_id

                web_cSessionStateId     = state_obj.state_id
                web_lSessionFirstHit    = no

                web_cProgramStateId     = ?
                web_lProgramFirstHit    = no.

            for each  state_field
                where state_field.state_id = state_obj.state_id:

                create web_ttField.
                assign
                    web_ttField.cStateType        = "session"
                    web_ttField.cFieldName        = state_field.field_name
                    web_ttField.cFieldValue       = state_field.field_value
                    web_ttField.lFieldModified    = no.

            end. /* state_field */



            if cProgramStateId <> "" then do:

                find first state_obj
                     where state_obj.state_id = cProgramStateId
                     no-error.

                if not avail state_obj
                or isTimeout(
                        state_obj.last_hit_date,
                        state_obj.last_hit_time ) then

                    {slib/err_throw "'web_program_timeout'"}.

                assign
                    web_cStateType          = "program"

                    web_cProgramStateId     = state_obj.state_id
                    web_lProgramFirstHit    = no
.

                for each  state_field
                    where state_field.state_id = state_obj.state_id:

                    create web_ttField.
                    assign
                        web_ttField.cStateType        = "program"
                        web_ttField.cFieldName        = state_field.field_name
                        web_ttField.cFieldValue       = state_field.field_value
                        web_ttField.lFieldModified    = no.

                end. /* state_field */

            end. /* cProgramStateId <> "" */

        end. /* else */

    {slib/err_catch cError}:

        case cError:

            when "web_session_timeout" then do:

                run createSessionState.

                run web_redirect( {&web_xLoginPage}, "meta" ).

                {slib/err_throw last}.

            end. /* web_session_timeout */

            when "web_program_timeout" then do:

                run web_redirect( {&web_xPageExpiredPage}, "302" ).

                {slib/err_throw last}.

            end. /* web_program_timeout */
            
        end case. /* cError */

    {slib/err_end}.

end procedure. /* fetchState */

procedure saveState private:

    define buffer state_obj     for state_obj.
    define buffer state_field   for state_field.

    define var cStateId as char no-undo.

    do transaction:

        find first state_obj
             where state_obj.state_id = web_cSessionStateId
             exclusive-lock no-error.

        if avail state_obj then
        assign
            state_obj.user_id       = web_cUserId 
                when web_cUserId <> state_obj.user_id

            state_obj.last_hit_date = today
            state_obj.last_hit_time = time.


        if web_cProgramStateId <> ? then do:

            find first state_obj
                 where state_obj.state_id = web_cProgramStateId
                 exclusive-lock no-error.

            if avail state_obj then
            assign
                state_obj.last_hit_date = today
                state_obj.last_hit_time = time.

        end. /* cProgramStateId <> ? */



        for each  web_ttField
            where web_ttField.lFieldModified:

            if web_ttField.cStateType = "session" then
                 cStateId = web_cSessionStateId.
            else cStateId = web_cProgramStateId.

            find first state_field
                 where state_field.state_id      = cStateId
                   and state_field.field_name    = web_ttField.cFieldName
                 exclusive-lock no-error.

            if not avail state_field then do:

                create state_field.
                assign
                    state_field.state_id    = cStateId
                    state_field.field_name  = web_ttField.cFieldName.

            end. /* not avail */

            if state_field.field_value <> web_ttField.cFieldValue then
               state_field.field_value  = web_ttField.cFieldValue.

        end. /* each ttField */

    end. /* trans */

end procedure. /* saveState */

procedure cleanState private:

    define buffer state_obj     for state_obj.
    define buffer state_field   for state_field.
    define buffer state_table   for state_table.

    define var tDate    as date no-undo.
    define var iTime    as int no-undo.
    define var i        as int no-undo.

    assign
       tDate = today
       iTime = time - {&web_xTimeout} * 60.

    if iTime < 0 then 

        assign
            tDate = tDate - 1 - ( abs( iTime ) - abs( iTime ) mod 86400 ) / 86400
            iTime = 86400 - abs( iTime ) mod 86400.



    /* delete stale state objects in 100x transactions for speed and efficiency */

    &if {&pro_xProversion} <= "09.1c" &then

        define var iLastTime as int no-undo. iLastTime = time.

        _delete:

        repeat while time = iLastTime transaction:

    &else

        etime( yes ).

        _delete:

        repeat while etime < 500 transaction:

    &endif

        i = 0.

        for each  state_obj
            where state_obj.last_hit_date < tDate
            exclusive-lock:

            for each  state_field
                where state_field.state_id = state_obj.state_id
                exclusive-lock:

                delete state_field.

                i = i + 1. if i >= 100 then next _delete.

            end. /* each state_field */

            for each  state_table
                where state_table.state_id = state_obj.state_id
                exclusive-lock:

                delete state_table.

                i = i + 1. if i >= 100 then next _delete.

            end. /* each state_tt */

            delete state_obj.

            i = i + 1. if i >= 100 then next _delete.

        end. /* repeat */

        for each  state_obj
            where state_obj.last_hit_date = tDate
              and state_obj.last_hit_time < iTime
            exclusive-lock:

            for each  state_field
                where state_field.state_id = state_obj.state_id
                exclusive-lock:

                delete state_field.

                i = i + 1. if i >= 100 then next _delete.

            end. /* each state_field */

            for each  state_table
                where state_table.state_id = state_obj.state_id
                exclusive-lock:

                delete state_table.

                i = i + 1. if i >= 100 then next _delete.

            end. /* each state_tt */

            delete state_obj.

            i = i + 1. if i >= 100 then next _delete.

        end. /* repeat */

        leave _delete.

    end. /* repeat */

end procedure. /* cleanState */

function isTimeout return log private ( ptLastHitDate as date, piLastHitTime as int ):

    define var tDate    as date no-undo.
    define var iTime    as int no-undo.

    assign
       tDate = today
       iTime = time - {&web_xTimeout} * 60.

    if iTime < 0 then 

        assign
            tDate = tDate - 1 - ( abs( iTime ) - abs( iTime ) mod 86400 ) / 86400
            iTime = 86400 - abs( iTime ) mod 86400.

    if  ptLastHitDate < tDate 
     or ptLastHitDate = tDate
    and piLastHitTime < iTime then

         return yes.
    else return no.

end function. /* isTimeout */



procedure runWebObject private:

    define input param pcAppProgram as char no-undo.

    define var cError       as char no-undo.
    define var cErrorMsg    as char no-undo.
    define var cStackTrace  as char no-undo.
    define var i            as int no-undo.

    {slib/err_try}:

        if isLoginRequired( pcAppProgram ) then
            {slib/err_throw "'web_login_required'" AppProgram}.

        if isAccessDenied( pcAppProgram ) then
            {slib/err_throw "'web_access_denied'" AppProgram remote_host}.

        {slib/err_try}:

            run run-web-object  in web-utilities-hdl ( AppProgram ) no-error.
            run end-request     in web-utilities-hdl no-error.

        {slib/err_catch cError cErrorMsg cStackTrace}:

            run writeMessage( replace( cErrorMsg, chr(1), "~n" ) + "~nStack Trace:~n" + cStackTrace ).

        {slib/err_end}.

    {slib/err_catch cError}:

        case cError:

            when "web_login_required" then do:

                run web_redirect( {&web_xLoginPage} + "?referrer=" + url-encode( AppProgram, "query" ), "302" ).

                {slib/err_throw last}.

            end. /* web_login_required */

            when "web_access_denied" then do:

                run web_redirect( {&web_xAccessDeniedPage} + "?referrer=" + url-encode( AppProgram, "query" ), "302" ).

                {slib/err_throw last}.

            end. /* web_access_Denied */

        end case. /* cError */
            
    {slib/err_end}.

end procedure. /* runWebObject */

function isLoginRequired returns log private ( pcAppProgram as char ):

    if pro_getRunFile( pcAppProgram ) = pro_getRunFile( {&web_xLoginPage} ) then

         return no.

    if  session:param = "develop"
    and can-do( "workshop,workshop~~.*,webtools/*", pcAppProgram ) then

         return no.

    if web_cUserId = "guest" then

         return yes.
    else return no.

end function. /* isLoginRequired */

function isAccessDenied returns log private ( pcAppProgram as char ):

    if pro_getRunFile( pcAppProgram ) = 
       pro_getRunFile( {&web_xAccessDeniedPage} ) then

        return no.

    if  not session:param = "develop"
    and can-do( "workshop,workshop~~.*,webtools/*", pcAppProgram ) then

        return yes.

    return no. /* debug *** yes */

end function. /* isAccessDenied */



procedure web_upgradeState:

    if web_cProgramStateId = ? then

        run createProgramState.

end procedure. /* web_upgradeState */

procedure createSessionState private:

    define buffer state_obj for state_obj.

    define var cStateId as char no-undo.

    cStateId = nextStateId( ).

    create state_obj.
    assign
        state_obj.state_type    = "session"
        state_obj.state_id      = cStateId
        state_obj.user_id       = "guest"
        state_obj.session_id    = cStateId

        state_obj.last_hit_date = today
        state_obj.last_hit_time = time.

    assign
        web_cStateType          = state_obj.state_type
        web_cUserId             = state_obj.user_id

        web_cSessionStateId     = state_obj.state_id
        web_lSessionFirstHit    = yes

        web_cProgramStateId     = ?
        web_lProgramFirstHit    = no.

    set-cookie( "ssid", state_obj.state_id, today + 3, time, ?, ?, ? ).

end procedure. /* createSessionState */

procedure createProgramState private:

    define buffer state_obj for state_obj.

    define var cStateId as char no-undo.

    cStateId = nextStateId( ).

    create state_obj.
    assign
        state_obj.state_type    = "program"
        state_obj.state_id      = cStateId
        state_obj.user_id       = ?
        state_obj.session_id    = web_cSessionStateId

        state_obj.last_hit_date = today
        state_obj.last_hit_time = time.

    assign
        web_cStateType          = state_obj.state_type

        web_cProgramStateId     = state_obj.state_id
        web_lProgramFirstHit    = yes.

end procedure. /* createProgramState */

function nextStateId returns char private:

    define var cStateId     as char no-undo.
    define var i            as int no-undo.

    i = next-value( state_id ).

    repeat:

        cStateId = encode( 
            string( i ) +
            string( random( 1, 999999 ) ) ).

        if not can-find(
            first state_obj
            where state_obj.state_id = cStateId ) then leave.

    end. /* repeat */

    return cStateId.

end function. /* nextStateId */



function web_getSessionField returns char ( pcFieldName as char ):

    return getStateField(
        input "session",
        input pcFieldName ).

end function. /* web_getSessionField */

function web_setSessionField returns log ( pcFieldName as char, pcFieldValue as char ):

    return setStateField(
        input "session",
        input pcFieldName,
        input pcFieldValue ).

end function. /* web_setSessionField */

function web_getProgramField returns char ( pcFieldName as char ):

    return getStateField(
        input "program",
        input pcFieldName ).

end function. /* web_getProgramField */

function web_setProgramField returns log ( pcFieldName as char, pcFieldValue as char ):

    return setStateField(
        input "program",
        input pcFieldName,
        input pcFieldValue ).

end function. /* web_setProgramField */

function getStateField returns char private ( pcStateType as char, pcFieldName as char ):

    define buffer web_ttField for web_ttField.

    define var str as char no-undo.

    if pcFieldName = ? then do:

        str = "".

        for each  web_ttField
            where web_ttField.cStateType = pcStateType:

            str = str
                + ( if str <> "" then "," else "" ) 
                + web_ttField.cFieldName.

        end. /* each web_ttField */

        return str.

    end. /* pcFieldName = ? */

    else do:

        find first web_ttField
             where web_ttField.cStateType   = pcStateType
               and web_ttField.cFieldName   = pcFieldName
             no-error.

        if avail web_ttField then 
             return web_ttField.cFieldValue.
        else return ?.

    end. /* else */

end function. /* getStateField */

function setStateField returns log private ( pcStateType as char, pcFieldName as char, pcFieldValue as char ):

    define buffer web_ttField for web_ttField.

    find first web_ttField
         where web_ttField.cStateType   = pcStateType
           and web_ttField.cFieldName   = pcFieldName
         no-error.

    if not avail web_ttField then do:

        create web_ttField.
        assign
            web_ttField.cStateType  = pcStateType
            web_ttField.cFieldName  = pcFieldName.

    end. /* not avail web_ttField */

    assign
        web_ttField.cFieldValue     = pcFieldValue
        web_ttField.lFieldModified  = yes.

    return yes.

end function. /* setStateField */



function web_setUserId returns log ( pcUserId as char, pcPassword as char ):

    if  pcUserId    = ?
    and pcPassword  = ? then

    assign
        pcUserId    = "guest"
        pcPassword  = "guest".



    web_cUserId = pcUserId.

    return yes.

end function. /* web_setUserId */
