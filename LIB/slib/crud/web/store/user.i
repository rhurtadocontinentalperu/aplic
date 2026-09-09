
/**
 * user.i -
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
    &audit = yes

    &fields = "
        field username              like crud_user.username
        field password              like crud_user.password
        field password_expiry       like crud_user.password_expiry
        field change_password       like crud_user.change_password
        field never_expires         like crud_user.never_expires
        field first_name            like crud_user.first_name
        field last_name             like crud_user.last_name
        field full_name             like crud_user.full_name
        field birth_date            like crud_user.birth_date
        field user_locale           like crud_user.user_locale
        field user_roles            like crud_user.user_roles
        field listing_roles         like crud_user.listing_roles
        field office                like crud_user.office
        field address               like crud_user.address
        field country               like crud_user.country
        field state                 like crud_user.state
        field work_phone            like crud_user.work_phone
        field mobile_phone          like crud_user.mobile_phone
        field home_phone            like crud_user.home_phone
        field phones                like crud_user.phones
        field email_address         like crud_user.email_address
        field comments              like crud_user.comments
        field failed_logins         like crud_user.failed_logins
        field account_locked        like crud_user.account_locked
        field activate_log          like crud_user.activate_log
        field fixed_ip_address      like crud_user.fixed_ip_address
        field exclude_ip_address    like crud_user.exclude_ip_address
        field export_to_excel       like crud_user.export_to_excel
        field last_login            like crud_login_history.start_time
        field is_expired            as log
        field is_busy               as log
        field is_online             as log"

    &params = "
        field new_password          like crud_user.password
        field expiry_days           as int"}

