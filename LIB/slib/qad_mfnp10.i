
/**
 * qad_mfnp10.i -
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



&scoped xTable      {1}
&scoped xField      {2}
&scoped xWhere      {3}
&scoped xIndex      {4}
&scoped xWidget     {5}
&scoped xFrame      {6}

&if "{&xFrame}" = "" &then

    &undefine xFrame
    &scoped xFrame a
    
&endif /* frame = "" */
    


on "cursor-up" of {&xWidget} in frame {&xFrame} do:

    do with frame {&xFrame}:

        find last  {&xTable}
             where {&xTable}.{&xField} < {&xWidget}:input-value
               and {&xWhere}
             use-index {&xIndex}
             no-lock no-error.

        if not avail {&xTable} then do:

            find first {&xTable}
                 where {&xWhere}
                 use-index {&xIndex}
                 no-lock no-error.

            apply "start-search" to {&xWidget}.

            {pxmsg.i &msgnum=21 &errorlevel=2}

        end. /* not avail */



        if avail {&xTable} then do:

            {&xWidget}:screen-value = string( {&xTable}.{&xField} ).
            if focus = {&xWidget}:handle then {&xWidget}:set-selection( 1 , -1 ).

            apply "value-changed" to {&xWidget}.
            apply "scroll-notify" to {&xWidget}.

        end. /* avail */

        return no-apply.

    end. /* with frame */

end. /* cursor-up */

on "cursor-down" of {&xWidget} in frame {&xFrame} do:

    do with frame {&xFrame}:

        find first {&xTable}
             where {&xTable}.{&xField} > {&xWidget}:input-value
               and {&xWhere}
             use-index {&xIndex}
             no-lock no-error.

        if not avail {&xTable} then do:

            find last  {&xTable}
                 where {&xWhere}
                 use-index {&xIndex}
                 no-lock no-error.

            apply "end-search" to {&xWidget}.

            {pxmsg.i &msgnum=20 &errorlevel=2}
 
        end. /* not avail */


        
        if avail {&xTable} then do:

            {&xWidget}:screen-value = string( {&xTable}.{&xField} ).
            if focus = {&xWidget}:handle then {&xWidget}:set-selection( 1 , -1 ).

            apply "value-changed" to {&xWidget}.
            apply "scroll-notify" to {&xWidget}.

        end. /* avail */
        
        return no-apply.

    end. /* with frame */

end. /* cursor-down */
