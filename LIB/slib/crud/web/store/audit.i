
/**
 * audit.i -
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

    &batched = yes

    &fields = "
        field service_name      like crud_audit.service_name
        field audit_datetime    like crud_audit.audit_datetime
        field audit_operation   like crud_audit.audit_operation
        field username          like crud_audit.username
        field full_name         like crud_user.full_name
        field office            like crud_user.office
        field phones            like crud_user.phones
        field trans_id          like crud_audit.trans_id
        field ip_address        like crud_audit.ip_address
        field esign             like crud_audit.esign
        field changed_fields    like crud_audit.changed_fields
        field before_change     like crud_audit.before_change
        field after_change      like crud_audit.after_change"}
