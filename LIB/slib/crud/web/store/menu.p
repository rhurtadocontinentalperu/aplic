
/**
 * menu.p -
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

{store/menu.i}

{slib/crud/store.i}

{slib/slibstr.i}



define query qry

    for crud_menu scrolling.

function openQuery returns handle:

    define var cWhere as char no-undo.

    run andCondition( "menu_id",    "crud_menu.menu_id",    input-output cWhere ).
    run andCondition( "sort_order", "crud_menu.sort_order", input-output cWhere ).
    run andCondition( "item_id",    "crud_menu.item_id",    input-output cWhere ).

    if hasCondition( "item_label" ) then do:

        if index( param_values.item_label, "*" ) <> 0 then
            cWhere = cWhere
                + ( if cWhere <> "" then " and " else "" )
                + "crud_menu.item_label matches " + safeChar( param_values.item_label ).

        else
            run andCondition( "item_label", "crud_menu.item_label", input-output cWhere ).

    end. /* hasCondition( "item_label" ) */

    query qry:query-prepare(
        "for each crud_menu " +
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
        data.menu_id            = crud_menu.menu_id
        data.item_id            = crud_menu.item_id
        data.sort_order         = crud_menu.sort_order
        data.item_type          = crud_menu.item_type
        data.icon_cls           = crud_menu.icon_cls
        data.item_label         = crud_menu.item_label.

    if crud_menu.item_type <> "m" then
    assign
        data.item_window        = crud_menu.item_window
        data.item_roles         = crud_menu.item_roles
        data.item_exclude_roles = crud_menu.item_exclude_roles.

    else
    assign
        data.item_window        = ""
        data.item_roles         = ""
        data.item_exclude_roles = "".

end function. /* bufferCopy */



function normalizeRoles returns char ( pcRoles as char ):

    define var cRetVal          as char no-undo.
    define var cInvalidRoles    as char no-undo.

    define var str  as char no-undo.
    define var len  as int no-undo.
    define var i    as int no-undo.

    assign
        cRetVal         = ""
        cInvalidRoles   = ""

    len = num-entries( pcRoles ).
    do i = 1 to len:

        str = lc( trim( entry( i, pcRoles ) ) ).

        if  str <> "all"
        and not can-find(
            first crud_role
            where crud_role.role_id = str ) then

            cInvalidRoles = cInvalidRoles
                + ( if cInvalidRoles <> "" then "," else "" )
                + str.

        cRetVal = cRetVal
            + ( if cRetVal <> "" then "," else "" )
            + str.

    end. /* 1 to len */

    if cInvalidRoles <> "" then
        {slib/err_throw "'role_not_found'" cInvalidRoles}.

    return cRetVal.

end function. /* normalizeRoles */

procedure createRecord:

    define param buffer change for change.

    define var cWindow          as char no-undo.
    define var cRoles           as char no-undo.
    define var cExcludeRoles    as char no-undo.

    if change.item_type <> "m" then
    assign
        cWindow         = change.item_window
        cRoles          = normalizeRoles( change.item_roles )
        cExcludeRoles   = normalizeRoles( change.item_exclude_roles ).

    else
    assign
        cWindow         = ""
        cRoles          = ""
        cExcludeRoles   = "".

    create crud_menu.
    assign
        crud_menu.menu_id               = change.menu_id
        crud_menu.item_id               = change.item_id
        crud_menu.sort_order            = change.sort_order
        crud_menu.item_type             = change.item_type
        crud_menu.item_label            = change.item_label
        crud_menu.item_window           = cWindow
        crud_menu.item_roles            = cRoles
        crud_menu.item_exclude_roles    = cExcludeRoles
            {slib/err_no-error}.

end procedure. /* createRecord */

procedure updateRecord:

    define param buffer change for change.

    define var cWindow          as char no-undo.
    define var cRoles           as char no-undo.
    define var cExcludeRoles    as char no-undo.

    if change.item_type <> "m" then
    assign
        cWindow         = change.item_window
        cRoles          = normalizeRoles( change.item_roles )
        cExcludeRoles   = normalizeRoles( change.item_exclude_roles ).

    else
    assign
        cWindow         = ""
        cRoles          = ""
        cExcludeRoles   = "".

    create crud_menu.
    assign
        crud_menu.menu_id               = change.menu_id
        crud_menu.item_id               = change.item_id
        crud_menu.sort_order            = change.sort_order
        crud_menu.item_type             = change.item_type
        crud_menu.item_label            = change.item_label
        crud_menu.item_window           = cWindow
        crud_menu.item_roles            = cRoles
        crud_menu.item_exclude_roles    = cExcludeRoles
            {slib/err_no-error}.

end procedure. /* updateRecord */

procedure deleteRecord:

    define param buffer change for change.

    delete crud_menu.

end procedure. /* deleteRecord */



procedure fillShortcuts:

    for each  crud_menu
        where crud_menu.menu_id = -1
        no-lock:

        if    ( crud_menu.item_roles = ""
             or str_lookupList( gcCrudUserRoles, crud_menu.item_roles ) )
        and not str_lookupList( gcCrudUserRoles, crud_menu.item_exclude_roles ) then do:

            create data.
            bufferCopy( buffer data ).

        end. /* str_lookup( user_roles, item_roles ) */

    end. /* for each crud_menu */

end procedure. /* fillShortcuts */

procedure fillMenu:

    define var ok as log no-undo.

    run drillMenu( 0, output ok ).

end procedure. /* fillMenu */

procedure drillMenu:

    define input    param piMenuId  like crud_menu.menu_id no-undo.
    define output   param plFound   as log no-undo.

    define buffer bMenu for crud_menu.

    define var ok as log no-undo.

    plFound = no.

    for each  bMenu
        where bMenu.menu_id = piMenuId
        no-lock:

        if bMenu.item_type = "m" then do:

            run drillMenu(
                input   bMenu.item_id,
                output  ok ).

            if ok then do:

                find crud_menu
                     where rowid( crud_menu ) = rowid( bMenu )
                     no-lock no-error.

                create data.
                bufferCopy( buffer data ).

                plFound = yes.

            end. /* ok */

        end. /* item_type = "m" */

        else
        if    ( bMenu.item_roles = ""
             or str_lookupList( gcCrudUserRoles, bMenu.item_roles ) )
        and not str_lookupList( gcCrudUserRoles, bMenu.item_exclude_roles ) then do:

            find crud_menu
                 where rowid( crud_menu ) = rowid( bMenu )
                 no-lock no-error.

            create data.
            bufferCopy( buffer data ).

            plFound = yes.

        end. /* str_lookup( user_roles, item_roles ) */

    end. /* for each crud_menu */

end procedure. /* drillMenu */

