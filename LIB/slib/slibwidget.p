
/**
 * slibwidget.p -
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



function getWidget              returns widget private  ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char ) forward.
function getWidgetRecurr        returns widget private  ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char ) forward.

function getWidgetList          returns char private    ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char ) forward.
function getWidgetListRecurr    returns char private    ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char ) forward.



on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* on close */

procedure initializeProc:

end procedure. /* initializeProc */



function widget_getWidget returns widget ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char ):

    return getWidget(
        input pwhContainer,
        input pcType,
        input pcName,
        input pcLabel ).

end function. /* widget_getWidget */

function widget_getWidgetList returns char ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char ):

    return getWidgetList(
        input pwhContainer,
        input pcType,
        input pcName,
        input pcLabel ).

end function. /* getWidgetList */



function getWidget returns widget private ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char ):

    if pwhContainer = ? then
       pwhContainer = current-window.

    if pcType = "" then
       pcType = ?.

    if pcName = "" then
       pcName = ?.

    if pcLabel = "" then
       pcLabel = ?.

    return getWidgetRecurr(
        input pwhContainer,
        input pcType,
        input pcName,
        input pcLabel ).

end function. /* getWidget */

function getWidgetRecurr returns widget private ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char ):

    define var whChild  as widget no-undo.
    define var wdgh     as widget no-undo.

    whChild = pwhContainer:first-child.

    repeat while valid-handle( whChild ):

        if  ( pcType = ?
           or can-query( whChild, "type" )
          and can-do( pcType, whChild:type ) )

        and ( pcName = ?
           or can-query( whChild, "name" )
          and can-do( pcName, whChild:name ) )

        and ( pcLabel = ?
           or can-query( whChild, "label" )
          and can-do( pcLabel, whChild:label ) ) then

            return whChild.

        if whChild:type = "window"
        or whChild:type = "frame"
        or whChild:type = "field-group" then do:

            wdgh = getWidgetRecurr( whChild, pcType, pcName, pcLabel ).

            if wdgh <> ? then return wdgh.

        end. /* type = "window" */

        whChild = whChild:next-sibling.

    end. /* repeat */

    return ?.

end function. /* getWidgetRecurr */



function getWidgetList returns char private ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char ):

    if pwhContainer = ? then
       pwhContainer = current-window.

    if pcType = "" then
       pcType = ?.

    if pcName = "" then
       pcName = ?.

    if pcLabel = "" then
       pcLabel = ?.

    return getWidgetListRecurr(
        input pwhContainer,
        input pcType,
        input pcName,
        input pcLabel ).

end function. /* getWidgetList */

function getWidgetListRecurr returns char private ( pwhContainer as widget, pcType as char, pcName as char, pcLabel as char ):

    define var whChild  as widget no-undo.

    define var RetVal   as char no-undo.
    define var str      as char no-undo.

    RetVal = "".

    whChild = pwhContainer:first-child.

    repeat while valid-handle( whChild ):

        if  ( pcType = ?
           or can-query( whChild, "type" )
          and can-do( pcType, whChild:type ) )

        and ( pcName = ?
           or can-query( whChild, "name" )
          and can-do( pcName, whChild:name ) )

        and ( pcLabel = ?
           or can-query( whChild, "label" )
          and can-do( pcLabel, whChild:label ) ) then

            RetVal = RetVal
                + ( if RetVal <> "" then "," else "" )
                + string( whChild ).

        if whChild:type = "window"
        or whChild:type = "frame"
        or whChild:type = "field-group" then do:

            str = getWidgetListRecurr( whChild, pcType, pcName, pcLabel ).

            if str <> "" then

                RetVal = RetVal
                    + ( if RetVal <> "" then "," else "" )
                    + str.

        end. /* type = "window" */

        whChild = whChild:next-sibling.

    end. /* repeat */

    return RetVal.

end function. /* getWidgetListRecurr */
