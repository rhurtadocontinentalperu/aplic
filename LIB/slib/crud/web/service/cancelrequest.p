
/**
 * cancelagent.p -
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

&global prefix agent_
{store/agent.i}
&undef prefix

{service/cancelrequest.i}

{slib/crud/service.i}

{slib/sliberr.i}



procedure processRequest:

    find first input_header no-error.

    if not ( input_header.session_id = gcCrudSessionId
          or lookup( "admin", gcCrudUserRoles ) > 0 ) then

        {slib/err_throw "'access_denied'"}.

    create agent_input_header.
    assign agent_input_header.service_operation = "cancelagent".

    create agent_param_values.
    assign
        agent_param_values.session_id = input_header.session_id
        agent_param_values.request_id = input_header.request_id.

    create agent_param_list.
    assign agent_param_list.param_name = "session_id".

    create agent_param_list.
    assign agent_param_list.param_name = "request_id".

    run store/agent.p (
        ( dataset agent_input_param:handle ),
        ( dataset agent_output_param:handle ) ).

end procedure. /* processRequest */
