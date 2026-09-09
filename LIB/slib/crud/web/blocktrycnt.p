
/**
 * blocktrycnt.p -
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

{slib/crud/global.i}

{slib/sliberr.i}



do transaction:

    find first crud_block_list
         where crud_block_list.ip_address = gcCrudIpAddress
         exclusive-lock no-error.

    if locked crud_block_list then
        return.

    if not avail crud_block_list then do:

        create crud_block_list.
        assign crud_block_list.ip_address = gcCrudIpAddress.

    end. /* not avail crud_block_list */

    assign
        crud_block_list.try_cnt     = crud_block_list.try_cnt + 1
        crud_block_list.ip_blocked  = crud_block_list.try_cnt >= gbCrudApp.block_try_cnt
        crud_block_list.last_hit    = now.

    if  crud_block_list.ip_blocked
    and gcCrudSessionId <> ? then do:

        find first crud_session
             where crud_session.session_id = gcCrudSessionId
             exclusive-lock no-error.

        if avail crud_session then
        assign
            crud_session.last_hit = datetime-tz( 01, 01, 1970, 00, 00, 00, 0 ).

    end. /* gcCrudSessionId <> ? */

end. /* trans */
