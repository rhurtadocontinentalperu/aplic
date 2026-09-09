
/**
 * log.p -
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

{store/log.i}

{slib/crud/store.i}



define query qry

    for crud_log scrolling.

function openQuery returns handle:

    define var cWhere as char no-undo.

    run andCondition( "username",   "crud_log.username",    input-output cWhere ).
    run andCondition( "start_time", "crud_log.start_time",  input-output cWhere ).

    query qry:query-prepare(
        "for each crud_log " +
            "where " + cWhere + " " +
            ( if input_header.active_index <> ""
              then "use-index " + input_header.active_index
              else "" ) + " " +

            "exclusive-lock " +

            "indexed-reposition" ) {slib/err_no-error}.

    query qry:query-open().

    return query qry:handle.

end function. /* openQuery */

function bufferCopy returns log ( buffer data for data ):

    find first crud_user
         where crud_user.username = crud_log.username
         no-lock no-error.

    assign
        data.username       = crud_log.username
        data.start_time     = crud_log.start_time
        data.end_time       = crud_log.end_time
        data.ip_address     = crud_log.ip_address
        data.user_agent     = crud_log.user_agent
        data.service_name   = crud_log.service_name
        data.input_param    = crud_log.input_param.

    if avail crud_user then
    assign
        data.full_name      = crud_user.full_name
        data.office         = crud_user.office
        data.phones         = crud_user.phones.

end function. /* bufferCopy */



procedure deleteAll:

    define var i as int no-undo.

    _trans:

    repeat transaction:

        i = 0.

        for each  crud_log
            where crud_log.username = param_values.username
            exclusive-lock:

            delete crud_log.
            i = i + 1. if i > 100 then next _trans.

        end. /* for each crud_session */

        leave _trans.

    end. /* repeat */

    run processOpenQuery.

    run msg(
        input "success",
        input "update_successful",
        input ?,
        input ? ).

end procedure. /* deleteAll */
