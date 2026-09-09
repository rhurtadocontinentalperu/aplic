
/** 
 * svnhook.i -
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
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Contact information
 *  Email: alonblich@gmail.com
 *  Phone: +263-77-7600818
 */



&if defined( xSvnHook ) = 0 &then

    {slib/start-slib.i "'slib/svnhook/svnhook.p'"}

    case p_event:

        when "open"         then run svn_openFile       ( p_context, p_other ).
        when "close"        then run svn_closeFile      ( p_context ).
        when "before-save"  then run svn_beforeSaveFile ( p_context, p_other, output p_ok ).
        when "save"         then run svn_saveFile       ( p_context, p_other ).

    end case. /* p_event */

    &global xSvnHook define

&endif /* defined = 0 */
