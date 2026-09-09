
/**
 * slibzip7.p -
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

{slib/slibzip7frwd.i "forward"}

{slib/slibzip7prop.i}

&if "{&opsys}" begins "win" &then

    {slib/slibwin.i}

&else

    {slib/slibunix.i}

&endif

{slib/slibos.i}

{slib/slibdate.i}

{slib/slibpro.i}

{slib/sliberr.i}



define temp-table ttFile

    like zip7_ttFile.

define var cUtilZip as char no-undo.



on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* on close */

procedure initializeProc:

    define input    param pcNoError as char no-undo.
    define output   param plOk      as log no-undo.

    define var cFileName as char no-undo.

    plOk = no.



    assign
        cUtilZip = os_normalizePath( {&zip7_xUtilZip} ).

    if os_isRelativePath( cUtilZip ) then do:

        cFileName = os_getFullPath( cUtilZip ).

        if cFileName <> ? then
            cUtilZip = cFileName.

    end. /* os_isRelativePath */



    if not os_isFileExists( cUtilZip ) then do:

        if pcNoError = "no-error" then do:

            apply "close" to this-procedure.
            return.

        end. /* no-error */

        else do:

            &if "{&opsys}" begins "win" &then

                message
                    'ZIP Util "' + cUtilZip + '" not found.'
                    skip(1)
                    'You may need to install the ZIP util first.'
                    skip(1)
                    'Look at the Standard Libraries BIN dir for instructions.'
                view-as alert-box.

            &else

                message
                    'Util Zip "' + cUtilZip + '" not found.'
                view-as alert-box.

            &endif

            quit.

        end. /* else */

    end. /* not os_isFileExists */



    plOk = yes.

end procedure. /* initializeProc */



procedure zip7_add:

    define input param pcArchive        as char no-undo.
    define input param pcFiles          as char no-undo.
    define input param pcInputDir       as char no-undo.
    define input param pcArchiveType    as char no-undo.
    define input param pcParam          as char no-undo.

    run zip7_addAdvanced(
        input pcArchive,
        input pcFiles,
        input pcInputDir,
        input pcArchiveType,
        input pcParam,
        input "silent,wait" ).

end procedure. /* zip7_add */

procedure zip7_addConsole:

    define input param pcArchive        as char no-undo.
    define input param pcFiles          as char no-undo.
    define input param pcInputDir       as char no-undo.
    define input param pcArchiveType    as char no-undo.
    define input param pcParam          as char no-undo.

    run zip7_addAdvanced(
        input pcArchive,
        input pcFiles,
        input pcInputDir,
        input pcArchiveType,
        input pcParam,
        input "wait" ).

end procedure. /* zip7_addConsole */

procedure zip7_addAdvanced:

    define input param pcArchive        as char no-undo.
    define input param pcFiles          as char no-undo. /* relative input dir */
    define input param pcInputDir       as char no-undo.
    define input param pcArchiveType    as char no-undo.
    define input param pcParam          as char no-undo.
    define input param pcOptions        as char no-undo.

    define var cFiles   as char no-undo.
    define var cCmd     as char no-undo.

    define var str      as char no-undo.
    define var i        as int no-undo.

    assign
        pcArchive   = os_normalizePath( pcArchive )
        pcInputDir  = os_normalizePath( pcInputDir ).

    cFiles = "".

    do i = 1 to num-entries( pcFiles, "|" ):

        str = zip7_normalizePath( entry( i, pcFiles, "|" ) ).

        if str <> "" then

        cFiles = cFiles 
            + ( if cFiles <> "" then "|" else "" )
            + str.

    end. /* 1 to num-entries */

    pcFiles = cFiles.

    if pcFiles = "" then
       pcFiles = ?.

    if pcFiles = ? then
       pcFiles = "*".

    if pcInputDir = "" then
       pcInputDir = ?.

    if pcInputDir = ? then
       pcInputDir = pro_cWorkDir.

    if pcArchiveType = "" then
       pcArchiveType = ?.

    if pcArchiveType = ? then
       pcArchiveType = "zip".

    if os_isRelativePath( pcInputDir ) then
       pcInputDir = os_normalizePath( pro_cWorkDir + "/" + pcInputDir ).

    if os_isRelativePath( pcArchive ) then
       pcArchive = os_normalizePath( pro_cWorkDir + "/" + pcArchive ).

    if not os_isDirExists( pcInputDir ) then
        {slib/err_throw "'dir_not_found'" pcInputDir}.


    
    cFiles = "".

    do i = 1 to num-entries( pcFiles, "|" ):

        str = entry( i, pcFiles, "|" ).

        cFiles = cFiles 
            + ( if cFiles <> "" then " " else "" )
            + ( if index( str, ' ' ) > 0 then '"' + str + '"' else str ).

    end. /* 1 to num-entries */

    cCmd = replace( replace( replace( replace( replace( {&zip7_xCmdAdd},

        "%zip%",        cUtilZip ),
        "%archive%",    '"' + pcArchive + '"' ), 
        "%files%",      cFiles ),
        "%type%",       pcArchiveType ),
        "%param%",      pcParam ).

    &if "{&opsys}" begins "win" &then

        if win_isUncPath( pcInputDir ) then

        run win_batch(
            input 'pushd "' + pcInputDir + '"~n'
                + cCmd,

            input pcOptions ).

        else

        run win_batch(
            input 'cd /d "' + pcInputDir + '"~n'
                + cCmd,

            input pcOptions ).

        if win_iErrorLevel <> 0 then
            {slib/err_throw "'zip7_util_error'" cCmd "'Exit Code ' + string( win_iErrorLevel )"}.
          
    &else

        run unix_shell( 
            input 'ulimit -f unlimited ~n'
                + 'cd "' + pcInputDir + '"~n'
                + cCmd,

            input pcOptions ).

        if unix_iExitCode <> 0 then
            {slib/err_throw "'zip7_util_error'" cCmd "'Exit Code ' + string( unix_iExitCode )"}.

    &endif

end procedure. /* zip7_addAdvanced */



procedure zip7_del:

    define input param pcArchive        as char no-undo.
    define input param pcFiles          as char no-undo.
    define input param pcArchiveType    as char no-undo.

    define var cFiles   as char no-undo.
    define var cCmd     as char no-undo.

    define var str      as char no-undo.
    define var i        as int no-undo.

    pcArchive = os_normalizePath( pcArchive ).

    cFiles = "".

    do i = 1 to num-entries( pcFiles, "|" ):

        str = zip7_normalizePath( entry( i, pcFiles, "|" ) ).

        if str <> "" then

        cFiles = cFiles 
            + ( if cFiles <> "" then "|" else "" )
            + str.

    end. /* 1 to num-entries */

    pcFiles = cFiles.

    if pcFiles = "" then
       pcFiles = ?.

    if pcFiles = ? then
       pcFiles = "*".

    if pcArchiveType = "" then
       pcArchiveType = ?.

    if pcArchiveType = ? then
       pcArchiveType = "zip".

    if os_isRelativePath( pcArchive ) then
        pcArchive = os_normalizePath( pro_cWorkDir + "/" + pcArchive ).

    if not os_isFileExists( pcArchive ) then
        {slib/err_throw "'zip7_archive_not_exists'" pcArchive}.



    cFiles = "".

    do i = 1 to num-entries( pcFiles, "|" ):

        cFiles = cFiles 
            + ( if cFiles <> "" then " " else "" )
            + '"' + entry( i, pcFiles, "|" ) + '"'.

    end. /* 1 to num-entries */

    cCmd = replace( replace( replace( replace( {&zip7_xCmdDel},

        "%zip%",        cUtilZip ),
        "%archive%",    '"' + pcArchive + '"' ), 
        "%files%",      cFiles ),
        "%type%",       pcArchiveType ).

    &if "{&opsys}" begins "win" &then

        run win_batch( 
            input cCmd,
            input "silent,wait" ).

        if win_iErrorLevel <> 0 then
            {slib/err_throw "'zip7_util_error'" cCmd "'Exit Code ' + string( win_iErrorLevel )"}.
          
    &else

        run unix_shell( 
            input "ulimit -f unlimited ~n"
                + cCmd,
            input "silent,wait" ).

        if unix_iExitCode <> 0 then
            {slib/err_throw "'zip7_util_error'" cCmd "'Exit Code ' + string( unix_iExitCode )"}.

    &endif

end procedure. /* zip7_del */

procedure zip7_extract:

    define input param pcArchive        as char no-undo.    
    define input param pcFiles          as char no-undo. /* the files in the archive */
    define input param pcOutDir         as char no-undo.
    define input param pcArchiveType    as char no-undo.

    run zip7_extractAdvanced(
        input pcArchive,
        input pcFiles,
        input pcOutDir,
        input pcArchiveType,
        input "silent,wait" ).

end procedure. /* zip7_extract */

procedure zip7_extractConsole:

    define input param pcArchive        as char no-undo.    
    define input param pcFiles          as char no-undo. /* the files in the archive */
    define input param pcOutDir         as char no-undo.
    define input param pcArchiveType    as char no-undo.

    run zip7_extractAdvanced(
        input pcArchive,
        input pcFiles,
        input pcOutDir,
        input pcArchiveType,
        input "wait" ).

end procedure. /* zip7_extractConsole */

procedure zip7_extractAdvanced:

    define input param pcArchive        as char no-undo.    
    define input param pcFiles          as char no-undo. /* the files in the archive */
    define input param pcOutDir         as char no-undo.
    define input param pcArchiveType    as char no-undo.
    define input param pcOptions        as char no-undo.

    define var cFiles   as char no-undo.
    define var cCmd     as char no-undo.

    define var str      as char no-undo.
    define var i        as int no-undo.

    assign
        pcArchive   = os_normalizePath( pcArchive )
        pcOutDir    = os_normalizePath( pcOutDir ).

    cFiles = "".

    do i = 1 to num-entries( pcFiles, "|" ):

        str = zip7_normalizePath( entry( i, pcFiles, "|" ) ).

        if str <> "" then

        cFiles = cFiles 
            + ( if cFiles <> "" then "|" else "" )
            + str.

    end. /* 1 to num-entries */

    pcFiles = cFiles.

    if pcFiles = "" then
       pcFiles = ?.

    if pcFiles = ? then
       pcFiles = "*".

    if pcOutDir = "" then
       pcOutDir = ?.

    if pcOutDir = ? then
       pcOutDir = pro_cWorkDir.

    if pcArchiveType = "" then
       pcArchiveType = ?.

    if pcArchiveType = ? then
       pcArchiveType = "zip".

    if os_isRelativePath( pcOutDir ) then
       pcOutDir = os_normalizePath( pro_cWorkDir + "/" + pcOutDir ).

    if os_isRelativePath( pcArchive ) then
       pcArchive = os_normalizePath( pro_cWorkDir + "/" + pcArchive ).



    if not os_isFileExists( pcArchive ) then
        {slib/err_throw "'zip7_archive_not_exists'" pcArchive}.

    if not os_isDirExists( pcOutDir ) then do:

        run os_createDir( pcOutDir ).

        if not os_isDirExists( pcOutDir ) then
            {slib/err_throw "'dir_create_failed'" pcOutDir}.

    end. /* not dirExists */



    cFiles = "".

    do i = 1 to num-entries( pcFiles, "|" ):

        cFiles = cFiles 
            + ( if cFiles <> "" then " " else "" )
            + '"' + entry( i, pcFiles, "|" ) + '"'.

    end. /* 1 to num-entries */

    cCmd = replace( replace( replace( replace( replace( {&zip7_xCmdExtract},

        "%zip%",        cUtilZip ),
        "%archive%",    '"' + pcArchive + '"' ),
        "%outdir%",     '"' + pcOutDir + '"' ),
        "%files%",      cFiles ),
        "%type%",       pcArchiveType ).

    &if "{&opsys}" begins "win" &then

        run win_batch(
            input cCmd,
            input pcOptions ).

        if win_iErrorLevel <> 0 then
            {slib/err_throw "'zip7_util_error'" cCmd "'Exit Code ' + string( win_iErrorLevel )"}.

    &else

        run unix_shell( 
            input "ulimit -f unlimited ~n"
                + cCmd,
            input pcOptions ).

        if unix_iExitCode <> 0 then
            {slib/err_throw "'zip7_util_error'" cCmd "'Exit Code ' + string( unix_iExitCode )"}.

    &endif

end procedure. /* zip7_extractAdvanced */

procedure zip7_list:

    define input    param pcArchive     as char no-undo.
    define input    param pcFiles       as char no-undo.
    define input    param pcArchiveType as char no-undo.
    define output   param table for zip7_ttFile.

    define var cLength      as char no-undo.
    define var cDate        as char no-undo.
    define var cTime        as char no-undo.
    define var cName        as char no-undo.

    define var tDate        as date no-undo.
    define var iMTime       as int no-undo.
    define var iTimeZone    as int no-undo.

    define var cTempFile    as char no-undo.
    define var cFiles       as char no-undo.
    define var cCmd         as char no-undo.

    define var str          as char no-undo.
    define var i            as int no-undo.

    empty temp-table zip7_ttFile.

    pcArchive = os_normalizePath( pcArchive ).

    cFiles = "".

    do i = 1 to num-entries( pcFiles, "|" ):

        str = zip7_normalizePath( entry( i, pcFiles, "|" ) ).

        if str <> "" then

        cFiles = cFiles 
            + ( if cFiles <> "" then "|" else "" )
            + str.

    end. /* 1 to num-entries */

    pcFiles = cFiles.

    if pcFiles = "" then
       pcFiles = ?.

    if pcFiles = ? then
       pcFiles = "*".

    if pcArchiveType = "" then
       pcArchiveType = ?.

    if pcArchiveType = ? then
       pcArchiveType = "zip".

    if os_isRelativePath( pcArchive ) then
       pcArchive = os_normalizePath( pro_cWorkDir + "/" + pcArchive ).

    if not os_isFileExists( pcArchive ) then
        {slib/err_throw "'zip7_archive_not_exists'" pcArchive}.



    cFiles = "".

    do i = 1 to num-entries( pcFiles, "|" ):

        cFiles = cFiles 
            + ( if cFiles <> "" then " " else "" )
            + '"' + entry( i, pcFiles, "|" ) + '"'.

    end. /* 1 to num-entries */

    assign
        cTempFile   = os_getTempFile( "", ".out" )

        cCmd        = replace( replace( replace( replace( {&zip7_xCmdList},

            "%zip%",        cUtilZip ),
            "%archive%",    '"' + pcArchive + '"' ),
            "%files%",      cFiles ),
            "%type%",       pcArchiveType )

        cCmd        = cCmd + ' > "' + cTempFile + '"'.

    &if "{&opsys}" begins "win" &then

        run win_batch(
            input cCmd,
            input "wait,silent" ).

    &elseif "{&opsys}" begins "unix" &then

        run unix_shell( 
            input "ulimit -f unlimited ~n"
                + cCmd,
            input "wait,silent" ).

    &endif



    if os_isFileExists( cTempFile ) then do:

        input from value( cTempFile ).

        _main:

        repeat:

            do on endkey undo, leave _main:
                import unformatted str.
            end.

            if str begins "-----" then

            repeat:

                do on endkey undo, leave _main:
                    import unformatted str.
                end.

                if str begins "-----" then
                    undo, leave _main.

                assign
                    str                     = trim( str )

                    cDate                   = trim( entry( 1, str, " " ) )
                    entry( 1, str, " " )    = ""
                    str                     = trim( str )

                    cTime                   = trim( entry( 1, str, " " ) )
                    entry( 1, str, " " )    = ""
                    str                     = trim( str )

                    entry( 1, str, " " )    = ""
                    str                     = trim( str )

                    cLength                 = trim( entry( 1, str, " " ) )
                    entry( 1, str, " " )    = ""
                    str                     = trim( str )

                    entry( 1, str, " " )    = ""
                    str                     = trim( str )

                    cName                   = zip7_normalizePath( trim( str ) ).

                run date_Str2Date(
                    input   cDate + " " + cTime,
                    input   "yyyy-mm-dd hh:ii:ss",
                    output  tDate,
                    output  iMTime,
                    output  iTimeZone ).

                if can-do( pcFiles, cName ) then do:

                    create zip7_ttFile.
                    assign
                        zip7_ttFile.cPath   = zip7_normalizePath( cName )
                        zip7_ttFile.tDate   = tDate
                        zip7_ttFile.iTime   = iMTime / 1000
                        zip7_ttFile.dLength = dec( cLength ).

                end. /* can-do */

            end. /* repeat */

        end. /* repeat */

        input close. /* cTempFile */

        os-delete value( cTempFile ).

    end. /* fileexists */

end procedure. /* zip7_list */



/*
note that shelling out is a relatively time expensive operation and it may take 
as much time to check if a file exists as extracting it from the archive. 
*/

function zip7_isFileExists returns log ( pcArchive as char, pcFiles as char, pcArchiveType as char ):

    empty temp-table ttFile.

    run zip7_list(
        input   pcArchive,
        input   pcFiles,
        input   pcArchiveType,
        output  table ttFile ).

    if can-find( first ttFile ) then
        return yes.

    return no.

end function. /* zip7_isFileExists */

function zip7_normalizePath returns char ( pcPath as char ):

    pcPath = replace( trim( pcPath ), "~\", "/" ).

    do while index( pcPath, "//" ) <> 0:
        pcPath = replace( pcPath, "//", "/" ).
    end.

    if substr( pcPath, 1, 1 ) = "/" then
       substr( pcPath, 1, 1 ) = "".

    return pcPath.

end function. /* zip7_normalizePath */
