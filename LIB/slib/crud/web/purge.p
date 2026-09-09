
/**
 * purge.p -
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

{slib/crud/global.i}

{slib/slibos.i}

{slib/sliberr.i}



define temp-table ttPid no-undo

    field iPid as int
    index iPid is primary unique
          iPid.

define buffer bAgent for crud_agent.

define var cSessionId   like crud_session.session_id no-undo.
define var cError       as char no-undo.
define var cErrorMsg    as char no-undo.
define var t            as datetime-tz no-undo.
define var i            as int no-undo.

etime( yes ).

t = add-interval( now, -1 * gbCrudApp.session_timeout, "minutes" ).

_trans:

repeat transaction:

    i = 0.

    for each  crud_session
        where crud_session.last_hit <= t
        exclusive-lock:

        if  crud_session.is_online
        and crud_session.last_hit > datetime-tz( 01, 01, 1970, 00, 00, 00, 0 ) then do:

            assign
                crud_session.last_hit = now.

            i = i + 1.

        end. /* is_online */

        else do:

            cSessionId = crud_session.session_id.

            delete crud_session.
            i = i + 1.

            for each  crud_state_field
                where crud_state_field.session_id = cSessionId
                exclusive-lock:

                delete crud_state_field.
                i = i + 1.

            end. /* for each crud_state_field */

            for each  crud_state_table
                where crud_state_table.session_id = cSessionId
                exclusive-lock:

                delete crud_state_table.
                i = i + 1.

            end. /* for each crud_state_table */

            for each  crud_export_file
                where crud_export_file.session_id = cSessionId
                exclusive-lock:

                if crud_export_file.export_file <> "" and crud_export_file.export_file <> ? then
                    os-delete value( crud_export_file.export_file ).

                delete crud_export_file.
                i = i + 1.

            end. /* for each crud_export_file */

        end. /* else */

        if etime( no ) >= 1000 then return. if i >= 100 then next _trans.

    end. /* for each crud_session */

    leave _trans.

end. /* repeat */



t = add-interval( now, -1 * gbCrudApp.block_timeout, "minutes" ).

_trans:

repeat transaction:

    i = 0.

    for each  crud_block_list
        where crud_block_list.last_hit <= t
        exclusive-lock:

        delete crud_block_list.
        i = i + 1. if etime( no ) >= 1000 then return. if i >= 100 then next _trans.

    end. /* for each crud_block_list */

    leave _trans.

end. /* repeat */



for each  _connect
    where _connect._connect-type = "self"
    no-lock:

    create ttPid.
    assign ttPid.iPid = _connect._connect-pid.

end. /* for each _connect */

_trans:

repeat transaction:

    i = 0.

    for each  crud_agent
        where crud_agent.agent_pid <> gcCrudAgentPid

          and not can-find(
            first ttPid
            where ttPid.iPid = crud_agent.agent_pid )

        no-lock:

        find bAgent
            where rowid( bAgent ) = rowid( crud_agent )
            exclusive-lock no-error.

        if avail bAgent then
          delete bAgent.

        i = i + 1. if etime( no ) >= 1000 then return. if i >= 100 then next _trans.

    end. /* for each crud_agent */

    leave _trans.

end. /* repeat */



t = now.

_trans:

repeat transaction:

    i = 0.

    for each  crud_agent
        where crud_agent.agent_pid <> gcCrudAgentPid
        and ( crud_agent.time_out <= t - 6000
          and crud_agent.time_out <> ?

           or crud_agent.session_id <> ?
          and not can-find(
                first crud_session
                where crud_session.session_id = crud_agent.session_id ) )
          and now - crud_agent.last_hit >= 6000
        no-lock:

        {slib/err_try}:

            run os_kill( crud_agent.agent_pid ).

            find bAgent
                where rowid( bAgent ) = rowid( crud_agent )
                exclusive-lock no-error.

            if avail bAgent then
              delete bAgent.

        {slib/err_catch cError cErrorMsg}:

            message cError cErrorMsg.

        {slib/err_end}.

        i = i + 1. if etime( no ) >= 1000 then return. if i >= 100 then next _trans.

    end. /* for each crud_agent */

    leave _trans.

end. /* repeat */
