
/**
 * session.i -
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

    &roles = "admin"

    &updateable = yes

    &fields = "
        field session_id    like crud_session.session_id
        field username      like crud_user.username
        field full_name     like crud_user.full_name
        field office        like crud_user.office
        field phones        like crud_user.phones
        field ip_address    like crud_session.ip_address
        field user_agent    like crud_session.user_agent
        field last_hit      like crud_session.last_hit
        field start_time    like crud_session.start_time
        field is_busy       like crud_session.is_busy
        field is_online     like crud_session.is_online
        field my_session    as log"}

