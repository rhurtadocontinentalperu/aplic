
/**
 * hebtrans.p -
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

{slib/hebtransfrwd.i "forward"}


define var hWidgetLast      as widget no-undo.
define var cWidgetVal       as char no-undo.
define var iWidgetCur       as int no-undo.
define var iWidgetLen       as int no-undo.

define var cHebrewMode      as char no-undo. /* ""/heb */
define var cHebrewModeOld   as char no-undo.



function convHeb returns char private

    ( pcCh as char ) forward.



on close of this-procedure do:

    delete procedure this-procedure.

end. /* close of this-procedure */

procedure initializeProc:

    assign
        hWidgetLast     = ?
        iWidgetLen      = ?
        cWidgetVal      = ?
        iWidgetCur      = ?

        cHebrewMode     = ""
        cHebrewModeOld  = "".

end procedure. /* initializeProc */



function hebtrans_onAnyPrintable returns log:

    if cHebrewMode = "heb" then do:

        run onEntry.
    
        if cHebrewMode = "heb" then do:

            assign
                cWidgetVal                              = self:screen-value
                iWidgetCur                              = self:cursor-offset

                substr( cWidgetVal, iWidgetCur, 0 )     = 

                    convHeb( last-event:function )

                substr( cWidgetVal, iWidgetLen + 1, 1 ) = ""

                self:screen-value                       = cWidgetVal
                self:cursor-offset                      = iWidgetCur.

            return yes.
            
        end. /* cHebrewMode = "heb" */

    end. /* cHebrewMode = "heb" */
    
    return no.

end function. /* hebtrans_onAnyPrintable */

procedure hebtrans_onHebrewMode:

    run onEntry.

    if cHebrewMode = "" then
        cHebrewMode = "heb".
    else cHebrewMode = "".

end procedure. /* hebtrans_onHebrewMode */



procedure onEntry private:

    define var str as char no-undo.

    form
        str view-as fill-in size 10 by 1
    with frame frm.

    do with frame frm:

        if hWidgetLast <> self then

        assign
            str:format          = self:format
            str:screen-value    = fill( "x", 256 )

            hWidgetLast         = self
            iWidgetLen          = max( length( str:screen-value ), str:width )
            cWidgetVal          = self:screen-value
            iWidgetCur          = self:cursor-offset

            cHebrewMode         = "".

        if cWidgetVal <> self:screen-value
        or iWidgetCur <> self:cursor-offset then
        
        assign
            cWidgetVal          = self:screen-value
            iWidgetCur          = self:cursor-offset
        
            cHebrewMode         = "".            

    end. /* with frame */

end procedure. /* onEntry */



function convHeb returns char private ( pcCh as char ):

    define var cCh as char no-undo case-sensitive.
    
    cCh = pcCh.

    if session:cpinternal = "iso8859-8" then do:

        case cCh:

            when "`" then return ";".
            when "q" then return "/".
            when "w" then return "'".
            when "e" then return "˜".
            when "r" then return "¯".
            when "t" then return "‡".
            when "y" then return "Ë".
            when "u" then return "Â".
            when "i" then return "Ô".
            when "o" then return "Ì".
            when "p" then return "Ù".
            when "a" then return "˘".
            when "s" then return "„".
            when "d" then return "‚".
            when "f" then return "Î".
            when "g" then return "Ú".
            when "h" then return "È".
            when "j" then return "Á".
            when "k" then return "Ï".
            when "l" then return "Í".
            when ";" then return "Û".
            when "'" then return ",".
            when "z" then return "Ê".
            when "x" then return "Ò".
            when "c" then return "·".
            when "v" then return "‰".
            when "b" then return "".
            when "n" then return "Ó".
            when "m" then return "ˆ".
            when "," then return "˙".
            when "." then return "ı".
            when "/" then return ".".

            otherwise
            return cCh.

        end case.

    end. /* is8859-8 */

    else
    if session:cpinternal = "ibm862" then do:

        case cCh:

            when "`" then return ";".
            when "q" then return "/".
            when "w" then return "'".
            when "e" then return "ó".
            when "r" then return "ò".
            when "t" then return "Ä".
            when "y" then return "ß".
            when "u" then return "Ï".
            when "i" then return "è".
            when "o" then return "∞".
            when "p" then return "¬".
            when "a" then return "ô".
            when "s" then return "É".
            when "d" then return "Í".
            when "f" then return "ã".
            when "g" then return "¿".
            when "h" then return "â".
            when "j" then return "°".
            when "k" then return "∂".
            when "l" then return "õ".
            when ";" then return "¡".
            when "'" then return ",".
            when "z" then return "˙".
            when "x" then return "ë".
            when "c" then return "Å".
            when "v" then return "Ó".
            when "b" then return "Ø".
            when "n" then return "†".
            when "m" then return "ñ".
            when "," then return "°".
            when "." then return "≥".
            when "/" then return ".".

            otherwise
            return cCh.

        end case.

    end. /* ibm862 */

    else
    return cCh.

end function. /* convHeb */
