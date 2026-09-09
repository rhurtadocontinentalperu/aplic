
/**
 * profile.p -
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

&global prefix user_
{store/user.i}
&undef prefix

&global prefix hist_
{store/loginhistory.i}
&undef prefix

&global prefix menu_
{store/menu.i}
&undef prefix

{service/profile.i}

{slib/crud/service.i}



procedure processRequest:

    define var iOffset  as int no-undo.
    define var i        as int no-undo.

    find first input_header no-error.

    if not avail input_header then
        create input_header.

    if input_header.username = ? then
       input_header.username = gcCrudUsername.

    if input_header.timezone_offset = ? then
       input_header.timezone_offset = timezone( now ).

    create user_input_header.
    assign
        user_input_header.service_operation = "openquery"
        user_input_header.active_index      = "username".

    create user_param_values.
    assign user_param_values.username = input_header.username.

    create user_param_list.
    assign user_param_list.param_name = "username".

    run store/user.p (
        ( dataset user_input_param:handle ),
        ( dataset user_output_param:handle ) ).

    find first user_data no-error.
    if not avail user_data then do:

        create user_data.
        assign
            user_data.username      = "guest"
            user_data.user_roles    = "guest"
            user_data.full_name     = "Guest"
            user_data.user_locale   = "US".

    end. /* not avail user_data */

    create output_header.
    buffer-copy user_data to output_header
        assign
            session_lock_timeout = gbCrudApp.session_lock_timeout.

    if gbCrudApp.show_login_history
    or lookup( "admin", gcCrudUserRoles ) > 0 then do:

        create hist_input_header.
        assign
            hist_input_header.service_operation = "openquery"
            hist_input_header.active_index      = "user_ip_start".

        create hist_param_values.
        assign hist_param_values.username = gcCrudUsername.

        create hist_param_list.
        assign hist_param_list.param_name = "username".

        run store/loginhistory.p (
            ( dataset hist_input_param:handle ),
            ( dataset hist_output_param:handle ) ).

        iOffset = ( input_header.timezone_offset - timezone( now ) ) * 60000.

        &scoped date date( hist_data.start_time + iOffset )

        for each hist_data

            break
            by {&date} descend:

            if first-of( {&date} ) then
              accumulate {&date} ( count ).

            if ( accum count ( {&date} ) ) > 3 then
                delete hist_data.

        end. /* for each hist_data */

        temp-table login_history:copy-temp-table( temp-table hist_data:handle, no, no, yes ).

        i = 0.

        for each login_history

            by date( login_history.start_time + iOffset )
            by login_history.ip_address:

            assign
                login_history.row_seq = i.

            i = i + 1.

        end. /* for each login_history */

    end. /* show_login_history */

    create menu_input_header.
    assign menu_input_header.service_operation = "fillmenu".

    run store/menu.p (
        ( dataset menu_input_param:handle ),
        ( dataset menu_output_param:handle ) ).

    temp-table menu:copy-temp-table( temp-table menu_data:handle, no, no, yes ).

    create menu_input_header.
    assign menu_input_header.service_operation = "fillshortcuts".

    run store/menu.p (
        ( dataset menu_input_param:handle ),
        ( dataset menu_output_param:handle ) ).

    temp-table shortcut:copy-temp-table( temp-table menu_data:handle, no, no, yes ).

end procedure. /* processRequest */

