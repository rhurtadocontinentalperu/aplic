
/**
 * recentlogin.p -
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

{store/recentlogin.i}

{slib/crud/store.i}

define temp-table ttLogin

    field cUsername     like crud_login_history.username
    field cIpAddress    like crud_login_history.ip_address

    index UserIp is primary unique
          cUsername
          cIpAddress.



procedure fillData:

    define var dLoad    as dec no-undo.
    define var t1       as datetime-tz no-undo.
    define var t2       as datetime-tz no-undo.

    assign
        t1 = add-interval( now, -12, "hours" )
        t2 = add-interval( now, -1 * gbCrudApp.session_timeout, "minutes" ).

    for each  crud_login_history
        where crud_login_history.last_hit >= t1
        no-lock

        by crud_login_history.last_hit descend:

        if can-find(
            first ttLogin
            where ttLogin.cUsername     = crud_login_history.username
              and ttLogin.cIpAddress    = crud_login_history.ip_address ) then
            next.

        else do:

            create ttLogin.
            assign
                ttLogin.cUsername   = crud_login_history.username
                ttLogin.cIpAddress  = crud_login_history.ip_address.

        end. /* else */

        find first crud_user
             where crud_user.username = crud_login_history.username
             no-lock no-error.

        create data.
        assign
            data.username           = crud_login_history.username
            data.ip_address         = crud_login_history.ip_address
            data.start_time         = crud_login_history.start_time
            data.last_hit           = crud_login_history.last_hit
            data.request_cnt        = crud_login_history.request_cnt
            data.request_total_time = crud_login_history.request_total_time
            data.load_pcnt          = 0
            data.my_login           = can-find(
                first crud_session
                where crud_session.session_id   = gcCrudSessionId
                  and crud_session.username     = crud_login_history.username
                  and crud_session.ip_address   = crud_login_history.ip_address
                  and crud_session.last_hit     > t2
                use-index session_id )

            data.is_online          = can-find(
                first crud_session
                where crud_session.ip_address   = crud_login_history.ip_address
                  and crud_session.username     = crud_login_history.username
                  and crud_session.last_hit     > t2
                  and crud_session.is_online
                use-index ip_username ).

        if avail crud_user then
        assign
            data.full_name          = crud_user.full_name
            data.office             = crud_user.office
            data.phones             = crud_user.phones.

        dLoad = dLoad + data.request_total_time.

    end. /* for each crud_login_history */

    if dLoad <> 0 then

    for each data:

        if data.request_total_time = 0 then
        assign
            data.load_pcnt = 0.

        else
        assign
            data.load_pcnt = data.request_total_time / dLoad * 100.

    end. /* for each data */

end procedure. /* fillData */

