
/**
 * office-html-2-dotp.p -
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

{slib/sliberr.i}

define input param pcHtmlFile as char no-undo.
define input param pcCompFile as char no-undo.

define var cOptions     as char no-undo.
define var cError       as char no-undo.
define var cErrorMsg    as char no-undo.
define var cStackTrace  as char no-undo.

if pcCompFile = ? then
   pcCompFile = "". /*** e4gl-gen.p excepts blank output file and uses the input file with a .p extension. ? are not exceptable */



{slib/err_try}:

    cOptions = "office-html".

    run e4gl-gen.p (
        input           pcHtmlFile,
        input-output    cOptions,
        input-output    pcCompFile ) {slib/err_no-error}.

    compile value( pcCompFile ) {slib/err_no-error}.

{slib/err_catch cError cErrorMsg cStackTrace}:

    message
        replace( cErrorMsg, chr(1), "~n" )
        skip
        cStackTrace
    view-as alert-box.

{slib/err_end}.
