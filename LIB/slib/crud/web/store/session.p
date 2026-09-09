
/**
 * session.p -
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

{store/session.i}

{slib/crud/store.i}



define query qry

    for crud_session scrolling.

function openQuery returns handle:

    define var cWhere as char no-undo.

    run andCondition( "username",   "crud_session.username",    input-output cWhere ).
    run andCondition( "session_id", "crud_session.session_id",  input-output cWhere ).
    run andCondition( "last_hit",   "crud_session.last_hit",    input-output cWhere ).
    run andCondition( "start_time", "crud_session.start_time",  input-output cWhere ).
    run andCondition( "ip_address", "crud_session.ip_address",  input-output cWhere ).

    cWhere = cWhere + ( if cWhere <> "" then " and " else "" )
        + "( crud_session.last_hit > datetime-tz('"
        + string( add-interval( now, -1 * gbCrudApp.session_timeout, "minutes" ) ) + "')"
        + " or crud_session.is_online )"
        + " and crud_session.last_hit <> datetime-tz( 01, 01, 1970, 00, 00, 00, 0 )".

    query qry:query-prepare(
        "for each crud_session " +
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
         where crud_user.username = crud_session.username
         no-lock no-error.

    assign
        data.session_id = crud_session.session_id
        data.username   = crud_session.username
        data.ip_address = crud_session.ip_address
        data.user_agent = crud_session.user_agent
        data.last_hit   = crud_session.last_hit
        data.start_time = crud_session.start_time
        data.is_busy    = crud_session.is_busy
        data.is_online  = crud_session.is_online
        data.my_session = ( crud_session.session_id = gcCrudSessionId ).

    if avail crud_user then
    assign
        data.full_name  = crud_user.full_name
        data.office     = crud_user.office
        data.phones     = crud_user.phones.

end function. /* bufferCopy */



procedure deleteRecord:

    define param buffer change for change.

    assign
        crud_session.last_hit = datetime-tz( 01, 01, 1970, 00, 00, 00, 0 ).

    run purge.p.

end procedure. /* deleteRecord */



procedure deleteAll:

    do transaction:

        for each  crud_session
            where crud_session.session_id <> gcCrudSessionId
            exclusive-lock:

            assign
                crud_session.last_hit = datetime-tz( 01, 01, 1970, 00, 00, 00, 0 ).

        end. /* for each crud_session */

        run purge.p.

    end. /* trans */

    run processOpenQuery.

    run msg(
        input "success",
        input "update_successful",
        input ?,
        input ? ).

end procedure. /* deleteAll */
