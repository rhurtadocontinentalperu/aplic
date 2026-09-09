
/**
 * cancelrequest.i -
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

define temp-table {&prefix}input_header no-undo serialize-name "inputHeader"

    field session_id    like crud_agent.session_id serialize-name "sessionId"
    field request_id    like crud_agent.request_id serialize-name "requestId".

define dataset {&prefix}input_param serialize-name "inputParam"

    for {&prefix}input_header.
    
define temp-table {&prefix}foo no-undo

    field bar as char.

define dataset {&prefix}output_param serialize-name "outputParam"

    for foo.
