
/**
 * chatmsg.i -
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

{slib/crud/define-store.i

    &batched    = yes
    &updateable = yes

    &fields = "
        field msg_datetime      like crud_chat_msg.msg_datetime
        field msg_username      like crud_chat_msg.msg_username
        field msg_text          like crud_chat_msg.msg_text"

    &params = "
        field chat_id           like crud_chat.chat_id
        field usernames         like crud_chat.usernames
        field full_names        as char
        field session_ids       as char
        field session_usernames as char
        field users_last_seen   as char
        field last_seen         like crud_chat_user.last_seen
        field unseen_cnt        like crud_chat_user.unseen_cnt"}
