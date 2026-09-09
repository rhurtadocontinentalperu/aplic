
/**
 * keybhe.p -
 *
 * named after the keybhe.com executable that was used in dos for entering Hebrew. keybhe.com 
 * actually doesn't work with the progress client and isn't unix/linux anyhow so i wrote my own.
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

{slib/slibbidi.i}

define var cVisScreenValue  as char no-undo.
define var iVisCursorOffset as int no-undo.

define var cLogScreenValue  as char no-undo.
define var iLogCursorOffset as int no-undo.
define var iLogLength       as int no-undo.

define var lastWidget       as widget no-undo.
define var cHebrewMode      as char no-undo. /* ?/""/heb */
define var lInsertMode      as log no-undo.



function convHeb returns char private

    ( pcCh as char ) forward.



on close of this-procedure do:

    delete procedure this-procedure.

end. /* close of this-procedure */

procedure initializeProc:

    lastWidget = ?.

end procedure. /* initializeProc */



procedure keybhe_onAnyPrintable:

    define var ch as char no-undo.

    run onEntry.

    if cHebrewMode = ? then

        apply last-event:function.

    else do:

        run mapVis2Log.

        if cHebrewMode = "heb" then 
             ch = convHeb( last-event:function ).
        else ch = last-event:function.

        if lInsertMode then
        assign
            substr( cLogScreenValue, iLogCursorOffset, 0 )  = ch
            substr( cLogScreenValue, iLogLength + 1, 1 )    = "".

        else
        assign
            substr( cLogScreenValue, iLogCursorOffset, 1 )  = ch.

        if iLogCursorOffset < iLogLength then
           iLogCursorOffset = iLogCursorOffset + 1.

        run mapLog2Vis.

    end. /* else */

    run onLeave.

end procedure. /* keybhe_onAnyPrintable */

procedure keybhe_onBackspace:

    run onEntry.

    if cHebrewMode = ? then

        apply last-event:function.

    else do:

        run mapVis2Log.

        if iLogCursorOffset > 1 then

        assign
            iLogCursorOffset = iLogCursorOffset - 1

            substr( cLogScreenValue, iLogCursorOffset, 1 ) = ""

            cLogScreenValue = cLogScreenValue + " ".

        run mapLog2Vis.

    end. /* else */

    run onLeave.

end procedure. /* keybhe_onBackspace */

procedure keybhe_onDelete:

    run onEntry.

    if cHebrewMode = ? then

        apply last-event:function.

    else do:

        run mapVis2Log.

        assign
            substr( cLogScreenValue, iLogCursorOffset, 1 ) = ""

            cLogScreenValue = cLogScreenValue + " ".

        run mapLog2Vis.

    end. /* else */

    run onLeave.

end procedure. /* keybhe_onBackspace */



procedure keybhe_onHome:

    run onEntry.

    if cHebrewMode = ? then

        apply last-event:function.

    else do:

        run mapVis2Log.

        iLogCursorOffset = 1.

        run mapLog2Vis.

    end. /* else */

    run onLeave.

end procedure. /* keybhe_onHome */

procedure keybhe_onEnd:

    define var i as int no-undo.

    run onEntry.

    if cHebrewMode = ? then

        apply last-event:function.

    else do:

        run mapVis2Log.

        i = iLogLength.

        do while i >= 1 and substr( cLogScreenValue, i, 1 ) = " ":

            i = i - 1.

        end. /* do while */

        iLogCursorOffset = i + 1.

        if iLogCursorOffset > iLogLength then
           iLogCursorOffset = iLogLength.

        run mapLog2Vis.

    end. /* else */

    run onLeave.

end procedure. /* keybhe_onEnd */



procedure keybhe_onHebrewMode:

    run onEntry.

    if cHebrewMode = "" or cHebrewMode = ? then
        cHebrewMode = "heb".
    else cHebrewMode = "".

    run onLeave.

end procedure. /* keybhe_onHebrewMode */

procedure keybhe_onInsertMode:

    run onEntry.

    lInsertMode = not lInsertMode.

    run onLeave.

end procedure. /* keybhe_onInsertMode */



procedure mapVis2Log private:

    /* for the bidi function to calculate the cursor position it has to be inside the string.
       so the logical screen-value includes the visual screen-value entire used and unused space, anywhere cursor might be.
       the delete, backspace, any-printable etc. events maintain this space and make sure it's length stays the same. */

    if lastWidget       <> self:handle
    or cVisScreenValue  <> self:screen-value
    or iVisCursorOffset <> self:cursor-offset then do:

        assign
            cVisScreenValue     = right-trim( self:screen-value ).

        if self:cursor-offset > length( cVisScreenValue ) then
        assign
            cLogScreenValue     = bidi_VisRtl2Log( cVisScreenValue )
            iLogCursorOffset    = self:cursor-offset.

        else
        assign
            cLogScreenValue     = bidi_VisRtl2LogCur(

                input   cVisScreenValue,
                input   self:cursor-offset, 
                output  iLogCursorOffset ).

        assign
            cLogScreenValue     = cLogScreenValue + fill( " ", iLogLength - length( cLogScreenValue ) ).

    end. /* cVisScreenValue <> self:screen-value */

end procedure. /* mapVis2Log */

procedure mapLog2Vis private:

    assign
        cLogScreenValue     = right-trim( cLogScreenValue ).

    if iLogCursorOffset > length( cLogScreenValue ) then
    assign
        cVisScreenValue     = bidi_Log2VisRtl( cLogScreenValue )
        iVisCursorOffset    = iLogCursorOffset.

    else
    assign
        cVisScreenValue     = bidi_Log2VisRtlCur(

            input   cLogScreenValue,
            input   iLogCursorOffset,
            output  iVisCursorOffset ).

    assign
        cVisScreenValue     = cVisScreenValue + fill( " ", iLogLength - length( cVisScreenValue ) )

        self:screen-value   = cVisScreenValue
        self:cursor-offset  = iVisCursorOffset.

end procedure. /* mapLog2Vis */



procedure onEntry private:

    /* the frm frame isn't visible and only used to calculated an format expression actual length */

    define var str as char no-undo.

    form
        str view-as fill-in size 10 by 1
    with frame frm.

    if lastWidget <> self then

    do with frame frm:

        assign
            str:format          = self:format
            str:screen-value    = fill( "x", 256 )
            iLogLength          = max( length( str:screen-value ), str:width )

            cHebrewMode         = ?
            lInsertMode         = no.

    end. /* lastWidget <> self */

end procedure. /* onEntry */

procedure onLeave private:

    lastWidget = self.

end procedure. /* onLeave */



function convHeb returns char private ( pcCh as char ):

    if session:cpinternal = "iso8859-8" then do:

        case pcCh:

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
            return pcCh.

        end case.

    end. /* is8859-8 */

    else
    if session:cpinternal = "ibm862" then do:

        case pcCh:

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
            return pcCh.

        end case.

    end. /* ibm862 */

    else
    return pcCh.

end function. /* convHeb */

