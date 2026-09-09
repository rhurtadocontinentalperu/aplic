
/**
 * slibwebprop.i -
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



&global web_xLoginPage          'login.html'
&global web_xHomePage           'index.html'
&global web_xPageExpiredPage    'page-expired.html'
&global web_xAccessDeniedPage   'access-denied.html'

&global web_xTimeout            180 /* in minutes */



define new global shared var web_cStateType         as char no-undo.
define new global shared var web_cUserId            as char no-undo.

define new global shared var web_cSessionStateId    as char no-undo.
define new global shared var web_lSessionFirstHit   as log no-undo.

define new global shared var web_cProgramStateId    as char no-undo.
define new global shared var web_lProgramFirstHit   as log no-undo.



define new global shared temp-table web_ttField no-undo

    field cStateType        as char
    field cFieldName        as char
    field cFieldValue       as char
    field lFieldModified    as log

    index StateField is primary unique
          cStateType
          cFieldName.
