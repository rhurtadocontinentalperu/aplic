
/**
 * slibmem.p -
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

{slib/slibmemprop.i}

{slib/sliberr.i}



on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* close */

procedure initializeProc:

end procedure. /* initializeProc */



procedure mem_copyFile2Ptr:

    define input    param pcFileName    as char no-undo.
    define output   param ptr           as memptr no-undo.

    file-info:file-name = pcFileName.
    if file-info:full-pathname = ? then

        {slib/err_throw "'file_not_found'" pcFileName}.



    &if {&pro_xProversion} >= "10" &then

        {slib/err_try}:

            set-size( ptr ) = file-info:file-size.

            copy-lob file file-info:full-pathname to ptr no-convert {slib/err_no-error}.

        {slib/err_catch}:

            set-size( ptr ) = 0.

            {slib/err_throw last}.

        {slib/err_end}.

    &else

        set-size( ptr ) = file-info:file-size.

        input from value( file-info:full-pathname ) binary no-convert.
        import ptr.
        input close.

    &endif /* proversion >= 10 */

end procedure. /* mem_copyFile2Ptr */

procedure mem_copyPtr2File:

    define input param ptr          as memptr no-undo.
    define input param pcFileName   as char no-undo.

    &if {&pro_xProversion} >= "10" &then

        copy-lob ptr to file pcFileName no-convert {slib/err_no-error}.
 
    &else

        output to value( pcFileName ) binary no-convert.
        export ptr.
        output close.

    &endif /* proversion >= 10 */

end procedure. /* mem_copyPtr2File */
