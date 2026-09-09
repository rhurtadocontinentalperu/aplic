
/**
 * dump.p -
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

{slib/slibos.i}

define var cDir as char no-undo.

cDir = trim( session:param ).

if cDir = "" then
   cDir = ?.
   
if cDir = ? then
    return.

if not os_isDirExists( cDir ) then
    return.       

        

for each _file
    where not _hidden
    no-lock:

    run slib/utils/dump1.p _file._file-name cDir.

end. /* each _file */

hide message no-pause.
message "Dump completed.".

quit.

