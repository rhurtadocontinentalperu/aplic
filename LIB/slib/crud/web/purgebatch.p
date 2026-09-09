
/**
 * purgebatch.p -
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

define var t as datetime-tz no-undo.

find first crud_app no-lock.

if crud_app.log_history_days <> 0 then do:

    t = add-interval( now, -1 * crud_app.log_history_days, "days" ).

    for each crud_user
        no-lock,

        each  crud_log
        where crud_log.start_time <= t
        exclusive-lock

        transaction:

        delete crud_log.

    end. /* for each crud_log */

end. /* crud_app.log_history_days <> 0 */



if crud_app.chat_history_days <> 0 then do:

    find first crud_chat no-lock no-error.

    repeat while avail crud_chat:

        t = add-interval( now, -1 * crud_app.chat_history_days, "days" ).

        for each  crud_chat_user
            where crud_chat_user.chat_id = crud_chat.chat_id
              and crud_chat_user.last_seen <> ?
            no-lock:

            t = min( t, crud_chat_user.last_seen ).

        end. /* for each crud_chat_user */

        for each  crud_chat_msg
            where crud_chat_msg.chat_id = crud_chat.chat_id
              and crud_chat_msg.msg_datetime <= t
            exclusive-lock

            transaction:

            delete crud_chat_msg.

        end. /* for each crud_log */

        if not can-find(
            first crud_chat_msg
            where crud_chat_msg.chat_id = crud_chat.chat_id ) then

        do transaction:

            for each  crud_chat_user
                where crud_chat_user.chat_id = crud_chat.chat_id
                exclusive-lock:

                delete crud_chat_user.

            end. /* for each crud_chat_user */

            find current crud_chat exclusive-lock no-error.
            if avail crud_chat then delete crud_chat.

        end. /* not can-find( crud_chat_msg ) */

        find next crud_chat no-lock no-error.

    end. /* repeat */

end. /* crud_app.chat_history_days <> 0 */



/*
if crud_app.alert_history_days <> 0 then do:

    t = add-interval( now, -1 * crud_app.alert_history_days, "days" ).

    for each  crud_alert
        where crud_alert.alert_time <= t
        exclusive-lock

        transaction:

        delete crud_alert.

    end. /* for each crud_log */

end. /* crud_app.alert_history_days <> 0 */
*/
