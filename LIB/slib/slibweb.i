
/**
 * slibweb.i -
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



&if defined( xSLibWeb ) = 0 &then

    {slib/start-slib.i "'slib/slibweb.p'"}

    {slib/slibwebprop.i}

    {slib/slibwebfrwd.i "in super"}



    &if "{1}" = "program" &then

        if web_cProgramStateId = ? then

            run web_upgradeState.

    &endif /* program */

    &global xSLibWeb defined

&endif /* defined = 0 */
