
/**
 * exportfile.p -
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

{src/web/method/wrap-cgi.i}

{slib/crud/global.i}

{slib/slibos.i}

{slib/sliberr.i}

define shared var pcInputParam  as longchar no-undo.
define shared var pcOutputParam as longchar no-undo.

define var cError       as char no-undo.
define var cErrorMsg    as char no-undo.
define var ptr          as memptr no-undo.



if gcCrudRequestId = ? then
    return.

find first crud_export_file
     where crud_export_file.session_id = gcCrudSessionId
       and crud_export_file.request_id = gcCrudRequestId
     exclusive-lock no-error.

{slib/err_try}:

    if not avail crud_export_file then
        {slib/err_throw "'error'" "'Export file ' + gcCrudRequestId + ' not found.'"}.

    if crud_export_file.export_file = "" or crud_export_file.export_file = ? then
        {slib/err_throw "'error'" "'Export file is blank.'"}.

    file-info:file-name = crud_export_file.export_file.
    if file-info:full-pathname = ? then
        {slib/err_throw "'file_not_found'" crud_export_file.export_file}.

    set-size( ptr ) = file-info:file-size {slib/err_no-error}.

    input from value( file-info:full-pathname ) binary no-convert.
    import ptr {slib/err_no-error}.
    input close.

    run OutputHttpHeader in web-utilities-hdl (
        "Content-Disposition", "attachment; filename=~"attachment."
            + os_getSubPath( crud_export_file.export_file, "ext", "ext" ) + "~"" ).

    output-content-type( "application/x-download" ).

    {&out-long} ptr.

    os-delete value( crud_export_file.export_file ).
    delete crud_export_file.

{slib/err_catch cError cErrorMsg}:

    run OutputHttpHeader in web-utilities-hdl (
        "content-disposition", "attachment; filename=~"error.txt~"" ).

    output-content-type( "application/x-download" ).

    {&out} "** " + cError + " " + cErrorMsg.

{slib/err_finally}:

    set-size( ptr ) = 0.

{slib/err_end}.

