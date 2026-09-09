/**
 * chmod.p -
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

{slib/slibunix.i}



define var cChown       as char no-undo.
define var cFileChmod   as char no-undo.
define var cDirChmod    as char no-undo.
define var cDirList     as char no-undo.

define var str          as char no-undo.
define var i            as int no-undo.
define var j            as int no-undo.

assign
   cChown       = os-getenv( "CHOWN" )
   cFileChmod   = os-getenv( "FILE_CHMOD" )
   cDirChmod    = os-getenv( "DIR_CHMOD" )
   cDirList     = os-getenv( "DIR_LIST" ).

if cChown       = "" then cChown = ?.
if cFileChmod   = "" then cFileChmod = ?.
if cDirChmod    = "" then cDirChmod = ?.
if cDirList     = "" then cDirList = ?.

if cFileChmod = ? and cDirChmod = ? then
    return.

if cDirList = ? then
    return.
    
    

j = num-entries( cDirList ).

do i = 1 to j:

    str = entry( i, cDirList ).

    if not os_isDirExists( str ) then
        next.

    run drill( str ).

end. /* do iDir */



procedure drill:

    define input param pcDir as char no-undo.

    define var cFileName    as char no-undo.
    define var cFullPath    as char no-undo.
    define var cAttrList    as char no-undo.

    if cChown <> ? then
    run unix_shell(
        input 'chown ' + cChown + ' "' + pcDir + '"',
        input 'silent,wait' ).
    
    if cDirChmod <> ? then
    run unix_shell(
        input 'chmod ' + cDirChmod + ' "' + pcDir + '"',
        input 'silent,wait' ).



    if cChown <> ? then
    run unix_shell(
        input 'chown ' + cChown + ' "' 
            + os_normalizePath( pcDir + '/*' ) + '"',
            
        input 'silent,wait' ).

    if cFileChmod <> ? then
    run unix_shell(
        input 'chmod ' + cFileChmod + ' "' 
            + os_normalizePath( pcDir + '/*' ) + '"',
            
        input 'silent,wait' ). 


    
    input from os-dir( pcDir ).

    repeat:
    
        import
           cFileName
           cFullPath
           cAttrList.
            
        if cFileName = "."
        or cFileName = ".." then
            next.
    
        if index( cAttrList, "d" ) > 0 then
            run drill( cFullPath ).

    end. /* repeat */

    input close. /* os-dir */

end procedure. /* drill */

