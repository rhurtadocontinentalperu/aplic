
/**
 * blocklist.p -
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

{store/blocklist.i}

{slib/crud/store.i}



define query qry

    for crud_block_list scrolling.

function openQuery returns handle:

    define var cWhere as char no-undo.

    run andCondition( "ip_address", "crud_block_list.ip_address",   input-output cWhere ).
    run andCondition( "last_hit",   "crud_block_list.last_hit",     input-output cWhere ).

    cWhere = cWhere + ( if cWhere <> "" then " and " else "" )
        + "crud_block_list.last_hit > datetime-tz('"
        + string( add-interval( now, -1 * gbCrudApp.block_timeout, "minutes" ) )
        + "')".

    query qry:query-prepare(
        "for each crud_block_list " +
            "where " + cWhere + " " +
            ( if input_header.active_index <> ""
              then "use-index " + input_header.active_index 
              else "" ) + " " +

            "exclusive-lock " +

            "indexed-reposition" ) {slib/err_no-error}.

    query qry:query-open().

    return query qry:handle.

end function. /* openQuery */

function bufferCopy returns log ( buffer data for data ):

    assign
        data.ip_address = crud_block_list.ip_address
        data.try_cnt    = crud_block_list.try_cnt
        data.ip_blocked = crud_block_list.ip_blocked
        data.last_hit   = crud_block_list.last_hit.

end function. /* bufferCopy */



procedure deleteRecord:

    define param buffer change for change.

    delete crud_block_list.

end procedure. /* deleteRecord */



procedure deleteAll:

    do transaction:

        for each crud_block_list exclusive-lock:
            delete crud_block_list.
        end.

    end. /* trans */

    run processOpenQuery.

    run msg(
        input "success",
        input "update_successful",
        input ?,
        input ? ).

end procedure. /* deleteAll */

