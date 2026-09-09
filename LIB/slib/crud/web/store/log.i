
/**
 * log.i -
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

    &batched = yes

    &fields = "
        field username      like crud_log.username
        field full_name     like crud_user.full_name
        field office        like crud_user.office
        field phones        like crud_user.phones
        field start_time    like crud_log.start_time
        field end_time      like crud_log.end_time
        field ip_address    like crud_log.ip_address
        field user_agent    like crud_log.user_agent
        field service_name  like crud_log.service_name
        field input_param   like crud_log.input_param"}
