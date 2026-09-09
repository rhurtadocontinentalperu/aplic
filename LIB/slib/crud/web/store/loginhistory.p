
/**
 * loginhistory.p -
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

{store/loginhistory.i}

{slib/crud/store.i}



define query qry

    for crud_login_history scrolling.

function openQuery returns handle:

    define var cWhere as char no-undo.

    run andCondition( "username",   "crud_login_history.username",      input-output cWhere ).
    run andCondition( "ip_address", "crud_login_history.ip_address",    input-output cWhere ).
    run andCondition( "start_time", "crud_login_history.start_time",    input-output cWhere ).

    query qry:query-prepare(
        "for each crud_login_history " +
            "where " + cWhere + " " +
            ( if input_header.active_index <> ""
              then "use-index " + input_header.active_index
              else "" ) + " " +

            "no-lock " +

            "indexed-reposition" ) {slib/err_no-error}.

    query qry:query-open().

    return query qry:handle.

end function. /* openQuery */

function bufferCopy returns log ( buffer data for data ):

    define buffer bHistory for crud_login_history.

    define var lLast    as log no-undo.
    define var t        as datetime-tz no-undo.

    if not can-find(
        first bHistory
        where bHistory.username     = crud_login_history.username
          and bHistory.ip_address   = crud_login_history.ip_address
          and bHistory.start_time   > crud_login_history.start_time
        use-index user_ip_start )

    then lLast = yes.
    else lLast = no.

    t = add-interval( now, -1 * gbCrudApp.session_timeout, "minutes" ).

    find first crud_user
         where crud_user.username = crud_login_history.username
         no-lock no-error.

    assign
        data.username           = crud_login_history.username
        data.ip_address         = crud_login_history.ip_address
        data.user_agent         = crud_login_history.user_agent
        data.start_time         = crud_login_history.start_time
        data.last_hit           = crud_login_history.last_hit
        data.request_cnt        = crud_login_history.request_cnt
        data.request_total_time = crud_login_history.request_total_time
        data.my_login           = lLast and can-find(
            first crud_session
            where crud_session.session_id   = gcCrudSessionId
              and crud_session.username     = crud_login_history.username
              and crud_session.ip_address   = crud_login_history.ip_address
              and crud_session.last_hit     > t
            use-index session_id )

        data.is_online          = lLast and can-find(
            first crud_session
            where crud_session.ip_address   = crud_login_history.ip_address
              and crud_session.username     = crud_login_history.username
              and crud_session.last_hit     > t
              and crud_session.is_online
            use-index ip_username ).

    if avail crud_user then
    assign
        data.full_name          = crud_user.full_name
        data.office             = crud_user.office
        data.phones             = crud_user.phones.

end function. /* bufferCopy */

