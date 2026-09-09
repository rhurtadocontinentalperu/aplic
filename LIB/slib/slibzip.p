
/**
 * slibzip.p -
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

{slib/slibzipprop.i}

{slib/slibzipfrwd.i "forward"}

{slib/slibinfozip.i}

{slib/slibzip7.i no-error}



on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* on close */

procedure initializeProc:

end procedure. /* initializeProc */



procedure zip_add:

    define input param pcArchive    as char no-undo.
    define input param pcFiles      as char no-undo.
    define input param pcInputDir   as char no-undo.

    if  zip7_lRunning then
    run zip7_add(
        input pcArchive,
        input pcFiles,
        input pcInputDir,
        input "zip",
        input "" ).

    else
    run infozip_add(
        input pcArchive,
        input pcFiles,
        input pcInputDir ).

end procedure. /* zip_add */

procedure zip_addConsole:

    define input param pcArchive    as char no-undo.
    define input param pcFiles      as char no-undo.
    define input param pcInputDir   as char no-undo.

    if  zip7_lRunning then
    run zip7_addConsole(
        input pcArchive,
        input pcFiles,
        input pcInputDir,
        input "zip",
        input "" ).

    else
    run infozip_addConsole(
        input pcArchive,
        input pcFiles,
        input pcInputDir ).

end procedure. /* zip_addConsole */

procedure zip_addAdvanced:

    define input param pcArchive    as char no-undo.
    define input param pcFiles      as char no-undo. /* relative input dir */
    define input param pcInputDir   as char no-undo.
    define input param pcOptions    as char no-undo.

    if  zip7_lRunning then
    run zip7_addAdvanced(
        input pcArchive,
        input pcFiles,
        input pcInputDir,
        input "zip",
        input "",
        input pcOptions ).

    else
    run infozip_addAdvanced(
        input pcArchive,
        input pcFiles,
        input pcInputDir,
        input pcOptions ).

end procedure. /* zip_addAdvanced */

procedure zip_del:

    define input param pcArchive    as char no-undo.
    define input param pcFiles      as char no-undo.

    if  zip7_lRunning then
    run zip7_del(
        input pcArchive,
        input pcFiles,
        input "zip" ).

    else
    run infozip_del(
        input pcArchive,
        input pcFiles ).

end procedure. /* zip_del */

procedure zip_extract:

    define input param pcArchive    as char no-undo.    
    define input param pcFiles      as char no-undo. /* the files in the archive */
    define input param pcOutDir     as char no-undo.

    if  zip7_lRunning then
    run zip7_extract(
        input pcArchive,
        input pcFiles,
        input pcOutDir,
        input "zip" ).

    else
    run infozip_extract(
        input pcArchive,
        input pcFiles,
        input pcOutDir ).

end procedure. /* zip_extract */

procedure zip_extractConsole:

    define input param pcArchive    as char no-undo.    
    define input param pcFiles      as char no-undo. /* the files in the archive */
    define input param pcOutDir     as char no-undo.

    if  zip7_lRunning then
    run zip7_extractConsole(
        input pcArchive,
        input pcFiles,
        input pcOutDir,
        input "zip" ).

    else
    run infozip_extractConsole(
        input pcArchive,
        input pcFiles,
        input pcOutDir ).

end procedure. /* zip_extractConsole */

procedure zip_extractAdvanced:

    define input param pcArchive    as char no-undo.    
    define input param pcFiles      as char no-undo. /* the files in the archive */
    define input param pcOutDir     as char no-undo.
    define input param pcOptions    as char no-undo.

    if  zip7_lRunning then
    run zip7_extractAdvanced(
        input pcArchive,
        input pcFiles,
        input pcOutDir,
        input "zip",
        input pcOptions ).

    else
    run infozip_extractAdvanced(
        input pcArchive,
        input pcFiles,
        input pcOutDir,
        input pcOptions ).

end procedure. /* zip_extractAdvanced */

procedure zip_list:

    define input    param pcArchive    as char no-undo.
    define input    param pcFiles      as char no-undo.
    define output   param table for zip_ttFile.

    if  zip7_lRunning then
    run zip7_list(
        input   pcArchive,
        input   pcFiles,
        input   "zip",
        output  table zip_ttFile ).

    else
    run infozip_list(
        input   pcArchive,
        input   pcFiles,
        output  table zip_ttFile ).

end procedure. /* zip_list */



/*
note that shelling out is a relatively time expensive operation and it may take 
as much time to check if a file exists as extracting it from the archive. 
*/

function zip_isFileExists returns log ( pcArchive as char, pcFiles as char ):

    if zip7_lRunning then
         return    zip7_isFileExists( pcArchive, pcFiles, "zip" ).
    else return infozip_isFileExists( pcArchive, pcFiles ).

end function. /* zip_isFileExists */

function zip_normalizePath returns char ( pcPath as char ):

    if zip7_lRunning then
         return    zip7_normalizePath( pcPath ).
    else return infozip_normalizePath( pcPath ).

end function. /* zip_normalizePath */

