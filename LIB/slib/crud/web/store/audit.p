
/**
 * audit.p -
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

{store/audit.i}

{slib/crud/store.i}



define query qry

    for crud_audit scrolling.

function openQuery returns handle:

    define var cWhere as char no-undo.

    run andCondition( "service_name",   "crud_audit.service_namt",      input-output cWhere ).
    run andCondition( "username",       "crud_audit.username",          input-output cWhere ).
    run andCondition( "audit_datetime", "crud_audit.audit_datetime",    input-output cWhere ).

    query qry:query-prepare(
        "for each crud_audit " +
            "where " + cWhere + " " +
            ( if input_header.active_index <> ""
              then "use-index " + input_header.active_index
              else "" ) + " " +

            "no-lock " +

            "indexed-reposition" ) {slib/err_no-error}.

    query qry:query-open().

    return query qry:handle.

end function. /* openQuery */

function bufferCopy returns log ( buffer data for data ):

    find first crud_user
         where crud_user.username = crud_audit.username
         no-lock no-error.

    assign
        data.service_name       = crud_audit.service_name
        data.audit_datetime     = crud_audit.audit_datetime
        data.audit_operation    = crud_audit.audit_operation
        data.username           = crud_audit.username
        data.ip_address         = crud_audit.ip_address
        data.esign              = crud_audit.esign
        data.changed_fields     = crud_audit.changed_fields
        data.before_change      = crud_audit.before_change
        data.after_change       = crud_audit.after_change.

    if avail crud_user then
    assign
        data.full_name          = crud_user.full_name
        data.office             = crud_user.office
        data.phones             = crud_user.phones.

end function. /* bufferCopy */
