
/**
 * agent.i -
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
    &updateable = yes

    &fields = "
        field agent_pid             like crud_agent.agent_pid
        field session_id            like crud_agent.session_id
        field username              like crud_session.username
        field full_name             like crud_user.full_name
        field office                like crud_user.office
        field phones                like crud_user.phones
        field request_id            like crud_agent.request_id
        field service_name          like crud_agent.service_name
        field time_out              like crud_agent.time_out
        field input_param           like crud_agent.input_param
        field last_hit              like crud_agent.last_hit
        field request_cnt           like crud_agent.request_cnt
        field request_total_time    like crud_agent.request_total_time
        field agent_start_time      like crud_agent.agent_start_time
        field idle_pcnt             as dec
        field my_agent              as log
        field is_busy               as log"}

