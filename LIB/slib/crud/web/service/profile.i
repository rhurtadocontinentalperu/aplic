
/**
 * profile.i -
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

    field username          like crud_user.username init ?
    field timezone_offset   as int                  init ?.

define dataset {&prefix}input_param serialize-name "inputParam"

    for {&prefix}input_header.



define temp-table {&prefix}output_header no-undo serialize-name "outputHeader"

    field user_roles            like crud_user.user_roles               serialize-name "userRoles"
    field full_name             like crud_user.full_name                serialize-name "fullName"
    field user_locale           like crud_user.user_locale              serialize-name "locale"
    field session_lock_timeout  like crud_app.session_lock_timeout              serialize-name "sessionLockTimeout".

define temp-table {&prefix}login_history no-undo serialize-name "loginHistory"

    field row_seq           as int                                  serialize-name "rowSeq"
    field ip_address        like crud_login_history.ip_address      serialize-name "ipAddress"
    field user_agent        like crud_login_history.user_agent      serialize-name "userAgent"
    field start_time        like crud_login_history.start_time      serialize-name "startTime"
    field last_hit          like crud_login_history.last_hit        serialize-name "lastHit"
    field my_login          as log                                  serialize-name "myLogin"
    field is_active         as log                                  serialize-name "isActive"

        index row_seq is primary
                  row_seq.

define temp-table {&prefix}menu no-undo serialize-name "menu"

    field menu_id           like crud_menu.menu_id                  serialize-name "menuId"
    field item_id           like crud_menu.item_id                  serialize-name "itemId"
    field sort_order        like crud_menu.sort_order               serialize-name "sortOrder"
    field item_type         like crud_menu.item_type                serialize-name "itemType"
    field icon_cls          like crud_menu.icon_cls                 serialize-name "iconCls"
    field item_label        like crud_menu.item_label               serialize-name "itemLabel"
    field item_window       like crud_menu.item_window              serialize-name "itemWindow".

define temp-table {&prefix}shortcut no-undo serialize-name "shortcuts"

    field sort_order        like crud_menu.sort_order               serialize-name "sortOrder"
    field item_type         like crud_menu.item_type                serialize-name "itemType"
    field icon_cls          like crud_menu.icon_cls                 serialize-name "iconCls"
    field item_label        like crud_menu.item_label               serialize-name "itemLabel"
    field item_window       like crud_menu.item_window              serialize-name "itemWindow".

define dataset {&prefix}output_param serialize-name "outputParam"

    for {&prefix}output_header, {&prefix}menu, {&prefix}shortcut, {&prefix}login_history.
