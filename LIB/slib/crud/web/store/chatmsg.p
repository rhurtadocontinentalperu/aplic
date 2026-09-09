
/**
 * chatmsg.p -
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

{store/chatmsg.i}

{slib/crud/store.i}

{slib/slibdate.i}

{slib/slibstr.i}



define query qry

    for crud_chat_msg scrolling.

function openQuery returns handle:

    define var cWhere as char no-undo.

    if lookup( "admin", gcCrudUserRoles ) = 0 then do:

        if not can-find(
            first crud_chat_user
            where crud_chat_user.chat_id    = param_values.chat_id
              and crud_chat_user.username   = gcCrudUsername ) then
            {slib/err_throw "'access_denied'"}.

    end. /* lookup( "admin" ) = 0 */

    query qry:query-prepare(
        "for each  crud_chat_msg " +
            "where crud_chat_msg.chat_id = " + string( param_values.chat_id ) + " " +
            "use-index id_datetime_username " +
            "exclusive-lock " +

            "indexed-reposition" ) {slib/err_no-error}.

    query qry:query-open().

    return query qry:handle.

end function. /* openQuery */

function bufferCopy returns log ( buffer data for data ):

    assign
        data.msg_datetime   = crud_chat_msg.msg_datetime
        data.msg_username   = crud_chat_msg.msg_username
        data.msg_text       = crud_chat_msg.msg_text.

end function. /* bufferCopy */



procedure endTrans:

    define var i as int no-undo.
    define var t as datetime-tz no-undo.

    assign
        i = 0
        t = ?.

    for each  change
        where change.change_type = "c"
           or change.change_type = "u":

        if t = ?
        then t = change.msg_datetime.
        else t = max( t, change.msg_datetime ).

        i = i + 1.

    end. /* for each change */

    find first crud_user
         where crud_user.username = gcCrudUsername
         exclusive-lock no-error.

    find first crud_chat_user
         where crud_chat_user.chat_id   = param_values.chat_id
           and crud_chat_user.username  = crud_user.username
         use-index chat_id_username
         exclusive-lock no-error.

        if avail crud_user then
    assign
        crud_user.unseen_cnt        = crud_user.unseen_cnt - crud_chat_user.unseen_cnt.

        if avail crud_chat_user then
    assign
        crud_chat_user.last_hit     = t
        crud_chat_user.last_seen    = param_values.last_seen
        crud_chat_user.unseen_cnt   = 0.

    for each  crud_chat_user
        where crud_chat_user.chat_id    = param_values.chat_id
          and crud_chat_user.username  <> gcCrudUsername
        use-index chat_id_username
        exclusive-lock,

        first crud_user
        where crud_user.username = crud_chat_user.username
        exclusive-lock:

        assign
            crud_chat_user.last_hit     = t
            crud_chat_user.unseen_cnt   = crud_chat_user.unseen_cnt + i.

        assign
            crud_user.unseen_cnt        = crud_user.unseen_cnt + i.

    end. /* for each crud_chat_user */

end procedure. /* endTrans */

procedure createRecord:

    define param buffer change for change.

    create crud_chat_msg.
    assign
        crud_chat_msg.chat_id       = param_values.chat_id
        crud_chat_msg.msg_datetime  = change.msg_datetime
        crud_chat_msg.msg_username  = change.msg_username
        crud_chat_msg.msg_text      = change.msg_text
            {slib/err_no-error}.

end procedure. /* createRecord */

procedure updateRecord:

    define param buffer change for change.

    assign
        crud_chat_msg.msg_text = change.msg_text
            {slib/err_no-error}.

end procedure. /* updateRecord */

procedure deleteRecord:

    define param buffer change for change.

end procedure. /* deleteRecord */



procedure openChat:

    define var cFullNames   as char no-undo.
    define var cLastSeen    as char no-undo.

    define var i            as int no-undo.
    define var j            as int no-undo.

    do transaction:

        assign
            param_values.usernames =
                str_sortEntries( lc( param_values.usernames ), no, "," ).

        find first crud_chat
             where crud_chat.usernames = param_values.usernames
             use-index usernames
             no-lock no-error.

        if not avail crud_chat then do:

            create crud_chat.
            assign
                crud_chat.chat_id   = next-value( chat_id )
                crud_chat.usernames = param_values.usernames.

            j = num-entries( crud_chat.usernames ).
            do i = 1 to j:

                create crud_chat_user.
                assign
                    crud_chat_user.chat_id      = crud_chat.chat_id
                    crud_chat_user.username     = entry( i, crud_chat.usernames )
                    crud_chat_user.last_seen    = ?
                    crud_chat_user.last_hit     = ?
                    crud_chat_user.unseen_cnt   = 0.

            end. /* 1 to j */

        end. /* not avail crud_chat */

        j = num-entries( param_values.usernames ).
        do i = 1 to j:

            find first crud_user
                 where crud_user.username = entry( i, param_values.usernames )
                 no-lock no-error.

            find first crud_chat_user
                 where crud_chat_user.chat_id   = crud_chat.chat_id
                   and crud_chat_user.username  = crud_user.username
                 no-lock no-error.

            assign
                cFullNames = cFullNames
                    + ( if cFullNames <> "" then chr(1) else "" )
                    + crud_user.full_name

                cLastSeen = cLastSeen
                    + ( if cFullNames <> "" then "," else "" ) /* cLastSeen might be empty */
                    + ( if crud_chat_user.last_seen <> ?
                        then date_datetimeTz2str( crud_chat_user.last_seen, "yyyy-mm-dd~~Thh:mm:ss.fff" )
                        else "" ).

        end. /* 1 to j */

        find first crud_chat_user
             where crud_chat_user.chat_id   = crud_chat.chat_id
               and crud_chat_user.username  = gcCrudUsername
             no-lock no-error.

        assign
            param_values.chat_id            = crud_chat.chat_id
            param_values.usernames          = crud_chat.usernames
            param_values.full_names         = cFullNames
            param_values.users_last_seen    = cLastSeen
            param_values.unseen_cnt         = crud_chat_user.unseen_cnt.

    end. /* trans */

    run processEnd.

end procedure. /* openChat */

procedure leaveChat:

    define var cnt  as int no-undo.
    define var i    as int no-undo.

    do transaction:

        find first crud_chat_user
             where crud_chat_user.chat_id   = param_values.chat_id
               and crud_chat_user.username  = gcCrudUsername
             use-index chat_id_username
             exclusive-lock no-error.

        if avail crud_chat_user then
        assign
            crud_chat_user.last_seen = param_values.last_seen.

        find last  crud_chat_msg
             where crud_chat_msg.chat_id = param_values.chat_id
             use-index id_datetime_username
             no-lock no-error.

        repeat while avail crud_chat_msg
            and crud_chat_msg.msg_username <> crud_user.username
            and crud_chat_msg.msg_datetime  > crud_chat_user.last_seen:

            cnt = cnt + 1.

            find prev  crud_chat_msg
                 where crud_chat_msg.chat_id = param_values.chat_id
                 use-index id_datetime_username
                 no-lock no-error.

        end. /* repeat */

        if cnt <> crud_chat_user.unseen_cnt then do:

            assign
                crud_chat_user.unseen_cnt = cnt.

            find first crud_user
                 where crud_user.username = gcCrudUsername
                 exclusive-lock no-error.

            cnt = 0.

            for each  crud_chat_user
                where crud_chat_user.username = crud_user.username
                  and crud_chat_user.unseen_cnt > 0
                use-index username_unseen_cnt
                no-lock:

                cnt = cnt + crud_chat_user.unseen_cnt.

            end. /* for each crud_chat_user */

            if cnt <> crud_user.unseen_cnt then
            assign
                crud_user.unseen_cnt = cnt.

        end. /* cnt <> unseen_cnt */

    end. /* trans */

end procedure. /* leaveChat */

procedure fetchSessions:

    define var cUsernames   like crud_chat.usernames no-undo.
    define var cSessionIds  like crud_session.session_id no-undo.

    define var i            as int no-undo.
    define var j            as int no-undo.

    find first crud_chat
         where crud_chat.chat_id = param_values.chat_id
         use-index chat_id
         no-lock no-error.

    j = num-entries( crud_chat.usernames ).
    do i = 1 to j:

        for each  crud_session
            where crud_session.username = entry( i, crud_chat.usernames )
              and crud_session.is_online
            no-lock:

            assign
                cUsernames = cUsernames
                    + ( if cUsernames <> "" then "," else "" )
                    + crud_session.username

                cSessionIds = cSessionIds
                    + ( if cSessionIds <> "" then "," else "" )
                    + crud_session.session_id.
            
        end. /* for each crud_session */

    end. /* 1 to j */

    cSessionIds = str_sortEntries( cSessionIds, no, "," ).

    assign
        param_values.session_ids        = cSessionIds
        param_values.session_usernames  = cUsernames.

end procedure. /* fetchSessions */

