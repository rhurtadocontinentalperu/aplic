
/**
 * agent.p -
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

{store/agent.i}

{slib/crud/store.i}

{slib/slibos.i}

{slib/sliberr.i}



define query qry

    for crud_agent scrolling.

function openQuery returns handle:

    define var cWhere as char no-undo.

    run andCondition( "agent_pid", "crud_agent.agent_pid", input-output cWhere ).

    query qry:query-prepare(
        "for each crud_agent " +
            "where " + cWhere + " " +
            "use-index agent_pid " +
            "exclusive-lock " +

            "indexed-reposition" ) {slib/err_no-error}.

    query qry:query-open().

    return query qry:handle.

end function. /* openQuery */

function bufferCopy returns log ( buffer data for data ):

    define var cUserName    as char no-undo.
    define var cFullName    as char no-undo.
    define var cOffice      as char no-undo.
    define var cPhones      as char no-undo.

    assign
        cUserName   = ""
        cFullName   = ""
        cPhones     = "".

    if crud_agent.session_id <> ? then do:

        find first crud_session
             where crud_session.session_id = crud_agent.session_id
             no-lock no-error.

        if avail crud_session then do:

            cUserName = crud_session.username.

            find first crud_user
                 where crud_user.username = crud_session.username
                 no-lock no-error.

            if avail crud_user then do:

                assign
                    cFullName   = crud_user.full_name
                    cOffice     = crud_user.office.

                if  crud_user.work_phone <> ""
                and crud_user.work_phone <> ? then
                    cPhones = cPhones
                        + ( if cPhones <> "" then ", " else "" )
                        + crud_user.work_phone.

                if  crud_user.mobile_phone <> ""
                and crud_user.mobile_phone <> ? then
                    cPhones = cPhones
                        + ( if cPhones <> "" then ", " else "" )
                        + crud_user.mobile_phone.

                if  crud_user.home_phone <> ""
                and crud_user.home_phone <> ? then
                    cPhones = cPhones
                        + ( if cPhones <> "" then ", " else "" )
                        + crud_user.home_phone.

            end. /* avail crud_user */

        end. /* avail crud_session */

    end. /* session_id <> ? */

    assign
        data.agent_pid          = crud_agent.agent_pid
        data.session_id         = crud_agent.session_id
        data.username           = cUserName
        data.full_name          = cFullName
        data.office             = cOffice
        data.phones             = cPhones
        data.request_id         = crud_agent.request_id
        data.service_name       = crud_agent.service_name
        data.last_hit           = crud_agent.last_hit
        data.time_out           = crud_agent.time_out
        data.input_param        = crud_agent.input_param
        data.request_cnt        = crud_agent.request_cnt
        data.request_total_time = crud_agent.request_total_time
        data.agent_start_time   = crud_agent.agent_start_time
        data.idle_pcnt          = min( 99.99,
           ( now - crud_agent.agent_start_time
                 - crud_agent.request_total_time ) /

           ( now - crud_agent.agent_start_time )
                * 100 )

        data.my_agent           = ( crud_agent.agent_pid = gcCrudAgentPid )
        data.is_busy            = ( crud_agent.last_hit <> ? ).

end function. /* bufferCopy */



procedure deleteRecord:

    define param buffer change for change.

    if crud_agent.agent_pid = gcCrudAgentPid then
        {slib/err_throw "'error'" "'Cannot kill own agent.'"}.

    run os_kill( crud_agent.agent_pid ).
    delete crud_agent.

end procedure. /* deleteRecord */



procedure deleteAll:

    do transaction:

        for each  crud_agent
            where crud_agent.agent_pid <> gcCrudAgentPid
            exclusive-lock:

            run os_kill( crud_agent.agent_pid ).
            delete crud_agent.

        end. /* for each crud_agent */

    end. /* trans */

    run processOpenQuery.

    run msg(
        input "success",
        input "update_successful",
        input ?,
        input ? ).

end procedure. /* killAll */

/*
used from service/cancelrequest.p

not intended to be used from the store.

put in the store to put all agent operations in one place.
*/

procedure cancelRequest:

    do transaction:

        find first crud_agent
             where crud_agent.session_id = param_values.session_id
               and crud_agent.request_id = param_values.request_id
             exclusive-lock no-error.

        if not avail crud_agent then
            {slib/err_throw "'error'" "'Request ' + param_values.request_id + ', session ' + param_values.session_id + ' not found.'"}.

        if crud_agent.agent_pid = gcCrudAgentPid then
            {slib/err_throw "'error'" "'Cannot kill own agent.'"}.

        run os_kill( crud_agent.agent_pid ).
        delete crud_agent.

    end. /* trans */

end procedure. /* cancelRequest */
