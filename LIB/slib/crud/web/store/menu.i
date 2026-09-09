
/**
 * menu.i -
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

    &updateable = yes

    &fields = "
        field menu_id               like crud_menu.menu_id
        field item_id               like crud_menu.item_id
        field sort_order            like crud_menu.sort_order
        field item_type             like crud_menu.item_type
        field icon_cls              like crud_menu.icon_cls
        field item_label            like crud_menu.item_label
        field item_window           like crud_menu.item_window
        field item_roles            like crud_menu.item_roles
        field item_exclude_roles    like crud_menu.item_exclude_roles"

    &params = "
        field username              like crud_user.username"}

