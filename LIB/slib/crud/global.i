
/**
 * global.i -
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

&if defined( xCrudGlobal ) = 0 &then

    define {1} shared buffer gbCrudApp for crud_app.

    define {1} shared var gcCrudAgentPid     as int no-undo.
    define {1} shared var gcCrudIpAddress    as char no-undo.
    define {1} shared var gcCrudUserAgent    as char no-undo.
    define {1} shared var gcCrudServiceName  as char no-undo.
    define {1} shared var gcCrudUsername     as char no-undo.
    define {1} shared var gcCrudUserRoles    as char no-undo.
    define {1} shared var gcCrudSessionId    as char no-undo.
    define {1} shared var gcCrudRequestId    as char no-undo.

    &global xCrudGlobal defined

&endif /* defined = 0 */
