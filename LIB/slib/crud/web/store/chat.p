
/**
 * chat.p -
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

{store/chat.i}

{slib/crud/store.i}



define query qry

    for crud_chat_user, crud_chat scrolling.

function openQuery returns handle:

    query qry:query-prepare(
        "for each  crud_chat_user " +
            "where crud_chat_user.username = " + safeChar( gcCrudUsername ) + " " +
            /* "and crud_chat_user.last_hit <> ? " + */
            "use-index username_last_hit " +
            "no-lock, " +

            "first crud_chat " +
            "where crud_chat.chat_id = crud_chat_user.chat_id " +
            "no-lock " +

            "indexed-reposition" ) {slib/err_no-error}.

    query qry:query-open().

    return query qry:handle.

end function. /* openQuery */

function bufferCopy returns log ( buffer data for data ):

    define var cFullNames   as char no-undo.
    define var cLastMsg     as char no-undo.

    define var lBusy        as log no-undo.
    define var lOnline      as log no-undo.
    define var lUserBusy    as log no-undo.
    define var lUserOnline  as log no-undo.

    define var str          as char no-undo.
    define var i            as int no-undo.
    define var j            as int no-undo.

    assign
        lBusy   = yes
        lOnline = no.

    j = num-entries( crud_chat.usernames ).
    do i = 1 to j:

        str = entry( i, crud_chat.usernames ).
        if str <> gcCrudUsername then do:

            find first crud_user
                 where crud_user.username = str
                 no-lock no-error.

            assign
                cFullNames = cFullNames
                    + ( if cFullNames <> "" then "," else "" )
                    + crud_user.full_name

                lUserOnline = can-find(
                    first crud_session
                    where crud_session.username = crud_user.username
                      and crud_session.is_online )

                lUserBusy = lUserOnline and can-find(
                    first crud_session
                    where crud_session.username = crud_user.username
                      and crud_session.is_online
                      and crud_session.is_busy ).

            if lUserOnline then
               lOnline = yes.

            if lUserOnline and not lUserBusy then
               lBusy = no.

        end. /* str <> gcCrudUsername */

    end. /* 1 to j */

    if lBusy and not lOnline then
       lBusy = no.

    find last  crud_chat_msg
         where crud_chat_msg.chat_id = crud_chat.chat_id
         use-index id_datetime_username
         no-lock no-error.

    if avail crud_chat_msg then
        cLastMsg = crud_chat_msg.msg_text.

    assign
        data.chat_id            = crud_chat.chat_id
        data.usernames          = crud_chat.usernames
        data.full_names         = cFullNames
        data.last_hit           = /* crud_chat_user.last_hit */ now
        data.last_msg_text      = cLastMsg
        data.chat_unseen_cnt    = crud_chat_user.unseen_cnt
        data.is_busy            = lBusy
        data.is_online          = lOnline.

end function. /* bufferCopy */



procedure openChats:

    find first crud_user
         where crud_user.username = gcCrudUsername
         no-lock no-error.

    if avail crud_user then
    assign
        param_values.unseen_cnt = crud_user.unseen_cnt.

    run processOpenQuery.

end procedure. /* openChats */
