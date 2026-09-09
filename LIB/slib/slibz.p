
/**
 * slibz.p -
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



&if "{&opsys}" = "unix" &then

    &global zlib /usr/lib64/libz.so.1

&else

    &global zlib C:\Progress\WRK\OpenEdge110\slib\bin\zlib1.dll

&endif /* opsys = "unix" */

{slib/slibzprop.i}

{slib/slibmem.i}

{slib/sliberr.i}



on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* on close */

procedure initializeProc:

end procedure. /* initializeProc */



procedure z_compressFile:

    define input param pcSourceFile as char no-undo.
    define input param pcTargetFile as char no-undo.

    define var pSourcePtr as memptr no-undo.
    define var pTargetPtr as memptr no-undo.

    {slib/err_try}:

        run mem_copyFile2Ptr( pcSourceFile, output pSourcePtr ).

        run z_compressPtr( pSourcePtr, output pTargetPtr ).

        run mem_copyPtr2File( pTargetPtr, pcTargetFile ).

    {slib/err_catch}:

        {slib/err_throw last}.

    {slib/err_finally}:

        set-size( pSourcePtr ) = 0.
        set-size( pTargetPtr ) = 0.

    {slib/err_end}.

end procedure. /* z_compressFile */

procedure z_compressPtr:

    define input    param ppSourcePtr as memptr no-undo.
    define output   param ppTargetPtr as memptr no-undo.

    define var iSourceSize  as {&mem_xPointerSize} no-undo.
    define var iTargetSize  as {&mem_xPointerSize} no-undo.

    define var ptr          as memptr no-undo.
    define var retval       as int no-undo.

    {slib/err_try}:

        iSourceSize = get-size( ppSourcePtr ).
        iTargetSize = ( iSourceSize * 1.01 ) + 12.
        set-size( ptr ) = iTargetSize.

        run compress(
            input           ptr,
            input-output    iTargetSize,
            input           ppSourcePtr,
            input           iSourceSize,
            output          retval ). run CompressUncompressNoError( retval ).

        set-size( ppTargetPtr ) = iTargetSize.
        ppTargetPtr = get-bytes( ptr, 1, iTargetSize ).

    {slib/err_catch}:

        set-size( ppTargetPtr ) = 0.

        {slib/err_throw last}.

    {slib/err_finally}:

        set-size( ptr ) = 0.

    {slib/err_end}.

end procedure. /* z_compressPtr */

procedure compress external "{&zlib}" cdecl:

    define input        param ppTargetPtr   as memptr.
    define input-output param piTargetSize  as long.
    define input        param ppSourcePtr   as memptr.
    define input        param piSourceSize  as long.
    define return       param retval        as long.

end procedure.



procedure z_uncompressFile:

    define input param pcSourceFile as char no-undo.
    define input param pcTargetFile as char no-undo.
    define input param piTargetSize as {&mem_xPointerSize} no-undo.

    define var pSourcePtr as memptr no-undo.
    define var pTargetPtr as memptr no-undo.

    {slib/err_try}:

        run mem_copyFile2Ptr( pcSourceFile, output pSourcePtr ).

        run z_uncompressPtr( pSourcePtr, output pTargetPtr, piTargetSize ).

        run mem_copyPtr2File( pTargetPtr, pcTargetFile ).

    {slib/err_catch}:

        {slib/err_throw last}.

    {slib/err_finally}:

        set-size( pSourcePtr ) = 0.
        set-size( pTargetPtr ) = 0.

    {slib/err_end}.

end procedure. /* z_uncompressFile */

procedure z_uncompressPtr:

    define input    param ppSourcePtr   as memptr no-undo.
    define output   param ppTargetPtr   as memptr no-undo.
    define input    param piTargetSize  as {&mem_xPointerSize} no-undo.    

    define var iSourceSize  as {&mem_xPointerSize} no-undo.
    define var iTargetSize  as {&mem_xPointerSize} no-undo.

    define var ptr          as memptr no-undo.
    define var retval       as int no-undo.

    {slib/err_try}:

        iSourceSize = get-size( ppSourcePtr ).
        iTargetSize = ( if piTargetSize <> ? then piTargetSize else iSourceSize * 100 ).
        set-size( ptr ) = iTargetSize.

        run uncompress(
            input           ptr,
            input-output    iTargetSize,
            input           ppSourcePtr,
            input           iSourceSize,
            output          retval ). run CompressUncompressNoError( retval ).

        set-size( ppTargetPtr ) = iTargetSize.
        ppTargetPtr = get-bytes( ptr, 1, iTargetSize ).

    {slib/err_catch}:

        set-size( ppTargetPtr ) = 0.

        {slib/err_throw last}.

    {slib/err_finally}:

        set-size( ptr ) = 0.

    {slib/err_end}.

end procedure. /* z_uncompressPtr */

procedure uncompress external "{&zlib}" cdecl:

    define input        param ppTargetPtr   as memptr.
    define input-output param piTargetSize  as long.
    define input        param ppSourcePtr   as memptr.
    define input        param piSourceSize  as long.
    define return       param retval        as long.

end procedure.

procedure CompressUncompressNoError private:

    define input param retval as int no-undo.

    case retval:

        when {&Z_ERRNO}         then {slib/err_throw "'Z_ERRNO'"}.
        when {&Z_STREAM_ERROR}  then {slib/err_throw "'Z_STREAM_ERROR'"}.
        when {&Z_DATA_ERROR}    then {slib/err_throw "'Z_DATA_ERROR'"}.
        when {&Z_MEM_ERROR}     then {slib/err_throw "'Z_MEM_ERROR'"}.
        when {&Z_BUF_ERROR}     then {slib/err_throw "'Z_BUF_ERROR'"}.
        when {&Z_VERSION_ERROR} then {slib/err_throw "'Z_VERSION_ERROR'"}.

    end case. /* retval */

end procedure. /* CompressUncompressNoError */
