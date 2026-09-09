
/**
 * role.p -
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

{store/role.i}

{slib/crud/store.i}

{slib/slibstr.i}



define query qry

    for crud_role scrolling.

function openQuery returns handle:

    define var cWhere as char no-undo.

    run andCondition( "role_id", "crud_role.role_id", input-output cWhere ).

    query qry:query-prepare(
        "for each crud_role " +
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
        data.role_id                = crud_role.role_id
        data.role_desc              = crud_role.role_desc
        data.role_services          = crud_role.role_services
        data.role_exclude_services  = crud_role.role_exclude_services.

end function. /* bufferCopy */



procedure createRecord:

    define param buffer change for change.

    create crud_role.
    assign
        crud_role.role_id               = lc( change.role_id )
        crud_role.role_desc             = change.role_desc
        crud_role.role_services         = lc( str_removeSpaces( change.role_services ) )
        crud_role.role_exclude_services = lc( str_removeSpaces( change.role_exclude_services ) )
            {slib/err_no-error}.

end procedure. /* createRecord */

procedure updateRecord:

    define param buffer change for change.

    assign
        crud_role.role_desc             = change.role_desc
        crud_role.role_services         = lc( str_removeSpaces( change.role_services ) )
        crud_role.role_exclude_services = lc( str_removeSpaces( change.role_exclude_services ) )
            {slib/err_no-error}.

end procedure. /* updateRecord */

procedure deleteRecord:

    define param buffer change for change.

    if can-find(
        first crud_user
        where lookup( change.role_id, crud_user.user_roles ) > 0 ) then

        {slib/err_throw "'role_in_use'"}.

    delete crud_role.

end procedure. /* deleteRecord */

