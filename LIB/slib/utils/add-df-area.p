
/**
 * add-df-area.p -
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

&global xDfFileOld '/p/hist/history.df'
&global xDfFileNew '/p/hist/history.df.v10'



define var str as char no-undo.

input from value( {&xDfFileOld} ).
output to value( {&xDfFileNew} ).

repeat:

    str = ''.
    import unformatted str.
    
    if str begins '  AREA "Schema Area"' then
    next.

    if str = '' then
    put unformatted skip(1).
    
    else
    put unformatted str skip.

    if str begins 'ADD TABLE' then
    put unformatted '  AREA "Table Area"' skip.
    
    else
    if str begins 'ADD INDEX' then
    put unformatted '  AREA "Index Area"' skip.

end. /* repeat */

output close.
input close.

