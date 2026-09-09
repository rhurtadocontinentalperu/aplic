
/**
 * archive-aimage.p -
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

{slib/slibzip.i}

{slib/slibxml.i}

{slib/sliblog.i}

{slib/slibos.i}

&if "{&opsys}" begins "win" &then

    {slib/slibwin.i}

&else

    {slib/slibunix.i}

&endif

{slib/slibdate.i}

{slib/slibmath.i}

{slib/slibpro.i}

{slib/sliberr.i}



&global xArchiveLkTimeout       82800   /* 23 * 60 * 60 */
&global xArchiveAimageLkTimeout 3600    /* 60 * 60 */



define temp-table ttDb no-undo

    field iDbNum            as int
    field cLDbName          as char
    field cPDbName          as char
    field cPort             as char

    field cBakRootDir       as char
    field cArchiveRootDir   as char

    index iDbNum is primary unique
          iDbNum

    index cLDbName is unique
          cLDbName.

define temp-table ttArchiveDir no-undo

    field cFullPath         as char
    field cDir              as char

    index cFullPath is primary unique
          cFullPath.

define temp-table ttArchiveZip no-undo

    field cFullPath         as char
    field cFileName         as char
    field cAimageFullPath   as char
    field cAimageFileName   as char
    field cBakType          as char 
    field iIbSeq            as int

    field tDate             as date
    field iTime             as int
    field dFileSize         as dec

    index cFullPath is primary unique 
          cFullPath.

define temp-table ttBakDir no-undo

    field cFullPath         as char
    field cDir              as char
    field cType             as char

    index cFullPath is primary unique
          cFullPath.

define var cDbSetName           as char no-undo.
define var cDbSetBakRootDir     as char no-undo.
define var cDbSetArchiveRootDir as char no-undo.
define var iNumVersions         as int no-undo.
define var cLogFile             as char no-undo.

define var cMailHub             as char no-undo.
define var cMailFrom            as char no-undo.
define var cMailTo              as char no-undo.

define var lFoundBak            as log no-undo.
define var lError               as log no-undo.



run preinitializeProc.

run setBusy.

{slib/err_try}:

    run initializeProc.

    if not lFoundBak then

        {slib/err_quit}.



    run log_writeMessage( "stLog", " - " ).
    run log_writeMessage( "stLog", "Set " + cDbSetName + " archive started." ).

    for each ttDb:

        {slib/err_try}:

            run log_writeMessage( "stLog", "Database " + ttDb.cLDbName + " archive started." ).
    
            run updateArchive( buffer ttDb ).
    
            run log_writeMessage( "stLog", "Database " + ttDb.cLDbName + " archive completed successfully." ).

        {slib/err_end}.

    end. /* each ttDb */

    if lError then do:

        run log_writeMessage( "stLog", "Set " + cDbSetName + " archive completed with errors (" +
            date_Date2Str( today, 0, 0, "www mmm d, yyyy" ) + ")." ).

        {slib/err_throw "'error'"}.

    end. /* lError */

    else do:

        run log_writeMessage( "stLog", "Set " + cDbSetName + " archive completed successfully (" +
            date_Date2Str( today, 0, 0, "www mmm d, yyyy" ) + ")." ).

    end. /* else */

{slib/err_catch}:

    run sendErrorReport.

{slib/err_finally}:

    run closeProc.
    
    run setAvail.

{slib/err_end}.

quit.



procedure preinitializeProc:

    define buffer ttDb for ttDb.

    define var cNumVersions as char no-undo.

    {slib/err_try}:

        assign
           lError               = no

           cDbSetArchiveRootDir = trim( os-getenv( "ARCHIVE_ROOT_DIR" ) ).

        if cDbSetArchiveRootDir = "" then cDbSetArchiveRootDir = ?.

        if cDbSetArchiveRootDir = ? then
            {slib/err_throw "'os_envvar_is_empty'" "'ARCHIVE_ROOT_DIR'"}.

        if not os_isDirExists( cDbSetArchiveRootDir ) then
             run os_createDir( cDbSetArchiveRootDir ).

        cLogFile = os_normalizePath( cDbSetArchiveRootDir + "/archive-aimage.lg" ).

        run log_openLogFile ( "stLog", cLogFile, ? ).
        run log_directErrors( "stLog" ).



        assign
           lFoundBak            = no

           cDbSetName           = trim( os-getenv( "DB_SET_NAME" ) )
           cDbSetBakRootDir     = trim( os-getenv( "BAK_ROOT_DIR" ) )
           cNumVersions         = trim( os-getenv( "ARCHIVE_VERSIONS" ) )

           cMailHub             = trim( os-getenv( "MAIL_HUB" ) )
           cMailTo              = trim( os-getenv( "MAIL_TO" ) )
           cMailFrom            = trim( os-getenv( "MAIL_FROM" ) ).

        if cDbSetName           = "" then cDbSetName = ?.
        if cDbSetBakRootDir     = "" then cDbSetBakRootDir = ?.
        if cNumVersions         = "" then cNumVersions = ?.

        if cMailHub             = "" then cMailHub = ?.
        if cMailTo              = "" then cMailTo = ?.
        if cMailFrom            = "" then cMailFrom = ?.

        if cMailHub = ? then
           cMailHub = "localhost:25".

        if cMailFrom = ? then
           cMailFrom = "backup@alonblich.com".

        if cDbSetName = ? then
            {slib/err_throw "'os_envvar_is_empty'" "'DB_SET_NAME'"}.

        if cDbSetBakRootDir = ? then
            {slib/err_throw "'os_envvar_is_empty'" "'BAK_ROOT_DIR'"}.

        if cNumVersions = ? then
            {slib/err_throw "'os_envvar_is_empty'" "'ARCHIVE_VERSIONS'"}.

        if not math_isInt( cNumVersions ) then
            {slib/err_throw "'error'" "'ARCHIVE_VERSIONS is not a number'"}.

        if not os_isDirExists( cDbSetBakRootDir ) then
            {slib/err_throw "'dir_not_found'" "cDbSetBakRootDir"}.

        iNumVersions = int( cNumVersions ).



        run preinitializeDb.

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* preinitializeProc */

procedure preinitializeDb:

    define buffer ttDb for ttDb.

    define var iDbNum           as int no-undo.
    define var cDbName          as char no-undo.
    define var cDbValue         as char no-undo.
    define var lDbFound         as log no-undo.

    define var cLDbName         as char no-undo.
    define var cPDbName         as char no-undo.
    define var cPort            as char no-undo.

    define var cBakRootDir      as char no-undo.
    define var cArchiveRootDir  as char no-undo.

    empty temp-table ttDb.

    {slib/err_try}:

        lDbFound = no.

        do iDbNum = 1 to 99:

            assign
               cDbName  = "DB" + string( iDbNum, "99" )
               cDbValue = trim( os-getenv( cDbName ) ).

            if cDbValue = ? then do:

                assign
                   cDbName  = "DB" + string( iDbNum )
                   cDbValue = trim( os-getenv( cDbName ) ).

            end. /* cDbValue = ? */

            if cDbValue = ? then
                next.

            lDbFound = yes.



            {slib/err_try}:

                case num-entries( cDbValue ):

                    when 1 then
                    assign
                        cPDbName    = trim( cDbValue )
                        cLDbName    = os_getSubPath( cPDbName, "file", "file" )
                        cPort       = ?.

                    when 2 then
                    assign
                        cPDbName    = trim( entry( 1, cDbValue ) )
                        cLDbName    = trim( entry( 2, cDbValue ) )
                        cPort       = ?.

                    when 3 then
                    assign
                        cPDbName    = trim( entry( 1, cDbValue ) )
                        cLDbName    = trim( entry( 2, cDbValue ) )
                        cPort       = trim( entry( 3, cDbValue ) ).

                    otherwise
                    {slib/err_throw "'error'" "'Environment Variable ' + cDbName + ' value ' + cDbValue + ' is invalid. Syntax <PDBName>[,<LDBName>[,<Port>]]'"}.

                end case. /* num-entries( ) */
        
                if not cPDbName matches "*.db" then
                    cPDbName = cPDbName + ".db".

                if can-find( first ttDb where ttDb.cLDbName = cLDbName ) then
                    {slib/err_throw "'error'" "'Logical database ' + cLDbName + ' already exists. Add a comma to the physical database name to specify a different logical database name.'"}.

                assign
                    cBakRootDir     = os_normalizePath( cDbSetBakRootDir + "/" + cLDbName )
                    cArchiveRootDir = os_normalizePath( cDbSetArchiveRootDir + "/" + cLDbName ).

                if not os_isDirExists( cBakRootDir ) then
                    {slib/err_throw "'dir_not_found'" "cBakRootDir"}.

                if not os_isDirExists( cArchiveRootDir ) then
                     run os_createDir( cArchiveRootDir ).



                create ttDb.
                assign
                    ttDb.iDbNum             = iDbNum
                    ttDb.cLDbName           = cLDbName
                    ttDb.cPDbName           = cPDbName
                    ttDb.cPort              = cPort

                    ttDb.cBakRootDir        = cBakRootDir
                    ttDb.cArchiveRootDir    = cArchiveRootDir.

            {slib/err_catch}:

                lError = yes.

            {slib/err_end}.
    
        end. /* do iDbNum */

        if not lDbFound then
            {slib/err_throw "'os_envvar_is_empty'" "'DB<n>'"}.

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* preinitializeDb */

procedure initializeProc:

    define buffer ttDb      for ttDb.
    define buffer ttBakDir  for ttBakDir.
    define buffer os_ttFile for os_ttFile.

    define var cPathList    as char no-undo.
    define var lOk          as log no-undo.
    define var i            as int no-undo.
    define var j            as int no-undo.

    {slib/err_try}:

        for each ttDb:

            run fillArchiveDir( ttDb.cArchiveRootDir ).

            find last ttArchiveDir
                 use-index cFullPath
                 no-error.

            if avail ttArchiveDir then do:
            
                run os_fillFile(
                    input   ttArchiveDir.cFullPath,
                    input   "p.....tmp.zip",
                    output  table os_ttFile ).

                for each os_ttFile:

                    os-delete value( os_ttFile.cFullPath ).

                end. /* each os_ttFile */

                if  os_isDirExists( ttArchiveDir.cFullPath )
                and os_isEmptyDir( ttArchiveDir.cFullPath ) then

                    run os_deleteDir( ttArchiveDir.cFullPath ).

            end. /* avail ttArchiveDir */



            run fillBakDir( ttDb.cBakRootDir ).

            find last ttBakDir
                 use-index cFullPath
                 no-error.

            if avail ttBakDir then do:

                run os_fillFile(
                    input   ttBakDir.cFullPath,
                    input   "p.....tmp.bak",
                    output  table os_ttFile ).

                if can-find( first os_ttFile ) then

                    run os_deleteDir( ttBakDir.cFullPath ).

            end. /* avail ttBakDir */

        end. /* each ttDb */



        for each ttDb:

            run fillBakDir( ttDb.cBakRootDir ).

            find last ttBakDir
                 use-index cFullPath
                 no-error.

            if avail ttBakDir then do:

                run os_fillFile(
                    input   ttBakDir.cFullPath,
                    input   "p.....tmp.bak",
                    output  table os_ttFile ).

                if can-find( first os_ttFile ) then

                    run os_deleteDir( ttBakDir.cFullPath ).

            end. /* avail ttBakDir */

        end. /* each ttDb */



        run os_findFile(
            input   cDbSetBakRootDir,
            input   "aimage*.ai",
            output  cPathList ).

        if cPathList <> ? then

            lFoundBak = yes.

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* initializeProc */

procedure closeProc:

    run log_closeLogFile( "stLog" ).

    run os_deleteTempFiles( cDbSetArchiveRootDir, ? ).
    run os_deleteTempFiles( cDbSetBakRootDir, ? ).
    run os_deleteTempFiles( ?, ? ).

end procedure. /* closeProc */



procedure updateArchive:

    define param buffer pbDb for ttDb.

    define buffer ttBakDir      for ttBakDir.
    define buffer ttArchiveDir  for ttArchiveDir.
    define buffer os_ttFile     for os_ttFile.

    define var cArchiveDir      as char no-undo.

    define var cZipFile         as char no-undo.
    define var cZipTempFile     as char no-undo.
    define var cFiles           as char no-undo.

    {slib/err_try}:

        run fillBakDir      ( pbDb.cBakRootDir ).
        run fillArchiveDir  ( pbDb.cArchiveRootDir ).

        find last ttArchiveDir
             use-index cFullPath
             no-error.

        if avail ttArchiveDir then

        for each  ttBakDir
            where ttBakDir.cDir < ttArchiveDir.cDir:

            run os_deleteDir( ttBakDir.cFullPath ).

            delete ttBakDir.

        end. /* each ttBakDir */



        for each ttBakDir

            break
            by ttBakDir.cFullPath:

            run os_fillFile(
                input   ttBakDir.cFullPath,
                input   "bak-full.bak"
                     + ",bak-inc.bak"
                     + ",bak.st"
                     + ",aimage*.ai",
                output  table os_ttFile ).

            if can-find(
                first os_ttFile
                where os_ttFile.cFileName = "bak-full.bak"
                   or os_ttFile.cFileName = "bak-inc.bak"
                   or os_ttFIle.cFileName = "bak.st" ) then
            
                leave.



            if ttBakDir.cType = "full" then do:

                cArchiveDir = os_normalizePath( pbDb.cArchiveRootDir + "/" + ttBakDir.cDir ).

                if not os_isDirExists( cArchiveDir ) then do:

                    run os_createDir( cArchiveDir ).

                    run fillArchiveDir( pbDb.cArchiveRootDir ).

                end. /* not os_isDirExists */

            end. /* cType = "full" */

            else do:

                find last ttArchiveDir
                     use-index cFullPath
                     no-error.

                if not avail ttArchiveDir then
                    {slib/err_throw "'error'" "'Cannot find last full backup archive directory.'"}.

                cArchiveDir = ttArchiveDir.cFullPath.

            end. /* else */



            if can-find( first os_ttFile ) then do:

                run log_writeMessage( "stLog", "Aimage backup archive started." ).

                for each  os_ttFile
                    where os_ttFile.cFileName matches "aimage*~~.ai":
                
                    assign
                        cZipFile        = os_normalizePath( cArchiveDir + "/" + ttBakDir.cDir + "-"
                                        + os_getSubPath( os_ttFile.cFileName, "file", "file" ) + ".zip" )

                        cZipTempFile    = os_getSubPath( cZipFile, "dir", "dir" ) 
                                        + os_getSubPath( os_getTempFile( "", ".zip" ), "file", "ext" ).

                    os-delete value( cZipTempFile ).
                    os-delete value( cZipFile ).

                    run zip_addConsole(
                        input cZipTempFile,
                        input os_ttFile.cFileName,
                        input ttBakDir.cFullPath ).

                    if not os_isFileExists( cZipTempFile ) then
                        {slib/err_throw "'error'" "'Zip failed.'"}.
    
                    os-rename value( cZipTempFile ) value( cZipFile ).
    
                    if not os_isFileExists( cZipFile ) then
                        {slib/err_throw "'file_rename_failed'" cZipTempFile cZipFile}.
                
                end. /* for each os_ttFile */

                run log_writeMessage( "stLog", "Aimage backup archive completed successfully." ).



                pause 5.

                for each os_ttFile:

                    os-delete value( os_ttFile.cFullPath ).

                end. /* each os_ttFile */

            end. /* can-find( first os_ttFile ) */

            if not last( ttBakDir.cFullPath ) then do:

                if  os_isDirExists( ttBakDir.cFullPath )
                and os_isEmptyDir( ttBakDir.cFullPath ) then

                    run os_deleteDir( ttBakDir.cFullPath ).

            end. /* not last */

        end. /* each ttBakDir */

    {slib/err_catch}:

        run fillArchiveDir( pbDb.cArchiveRootDir ).

        find last ttArchiveDir
             use-index cFullPath
             no-error.

        if avail ttArchiveDir then do:
        
            run os_fillFile(
                input   ttArchiveDir.cFullPath,
                input   "p.....tmp.zip",
                output  table os_ttFile ).

            for each os_ttFile:

                os-delete value( os_ttFile.cFullPath ).

            end. /* each os_ttFile */

            if  os_isDirExists( ttArchiveDir.cFullPath )
            and os_isEmptyDir( ttArchiveDir.cFullPath ) then

                run os_deleteDir( ttArchiveDir.cFullPath ).

        end. /* avail ttArchiveDir */



        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* updateArchive */



procedure fillArchiveDir:

    define input param pcArchiveRootDir as char no-undo.

    define buffer ttArchiveDir for ttArchiveDir.

    define var cFileName    as char no-undo.
    define var cFullPath    as char no-undo.
    define var cAttrList    as char no-undo.

    empty temp-table ttArchiveDir.

    {slib/err_try}:

        input from os-dir( pcArchiveRootDir ).

        repeat:

            import
                cFileName
                cFullPath
                cAttrList.

            if index( "d", cAttrList ) > 0

            and ( cFileName matches "bak-....-..-..t..-..-..-full"
               or cFileName matches "bak-....-..-..t..-..-..-inc..." ) then do:

                create ttArchiveDir.
                assign
                    ttArchiveDir.cFullPath  = cFullPath
                    ttArchiveDir.cDir       = cFileName.

            end. /* index( "d" ) > 0 */
    
        end. /* repeat */
        
        input close.
    
    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* fillArchiveDir */

procedure fillArchiveZip:

    define input param pcArchiveDir as char no-undo.

    define buffer ttArchiveZip for ttArchiveZip.

    define var cFileName        as char no-undo.
    define var cFullPath        as char no-undo.
    define var cAttrList        as char no-undo.
    define var cAimageFileName  as char no-undo.
    define var cAimageFullPath  as char no-undo.

    define var cBakType         as char no-undo.
    define var iIbSeq           as int no-undo.

    define var tDate            as date no-undo.
    define var iTime            as int no-undo.
    define var iTimeZone        as int no-undo.
    define var dFileSize        as dec no-undo.

    empty temp-table ttArchiveZip.

    {slib/err_try}:

        input from os-dir( pcArchiveDir ).

        _loop:
    
        repeat:
        
            import
                cFileName
                cFullPath
                cAttrList.
    
            if cFileName matches "bak-....-..-..t..-..-..-full~~.zip"
            or cFileName matches "bak-....-..-..t..-..-..-inc...~~.zip" then do:

                assign
                    cAimageFileName = os_getSubPath( cFileName, "dir", "file" ) + "-aimage.zip"
                    cAimageFullPath = os_getSubPath( cFullPath, "dir", "file" ) + "-aimage.zip".

                if not os_isFileExists( cAimageFullPath ) then
                assign
                    cAimageFileName = ?
                    cAimageFullPath = ?.



                if cFileName matches "*-full*" then
                assign
                    cBakType    = "full"
                    iIbSeq      = 0.

                else
                if cFileName matches "*-inc*" then
                assign
                    cBakType    = "inc"
                    iIbSeq      = int( substr( cFileName, length( cFileName ) - 7 + 1, 3 ) ).



                run date_Str2Date(
                    input   substr( cFileName, 5 /* "bak-" + 1 */, 19 /* "yyyy-mm-ddthh-ii-ss" */ ),
                    input   "yyyy-mm-dd~~thh-ii-ss",
                    output  tDate,
                    output  iTime,
                    output  iTimeZone ).

                if tDate = ?
                or iTime = ? then
                    next _loop.



                dFileSize = os_getBigFileSize( cFullPath ).

                create ttArchiveZip.
                assign
                    ttArchiveZip.cFullPath          = cFullPath
                    ttArchiveZip.cFileName          = cFileName
                    ttArchiveZip.cAimageFullPath    = cAimageFullPath
                    ttArchiveZip.cAimageFileName    = cAimageFileName
                    ttArchiveZip.cBakType           = cBakType
                    ttArchiveZip.iIbSeq             = iIbSeq

                    ttArchiveZip.tDate              = tDate
                    ttArchiveZip.iTime              = iTime
                    ttArchiveZip.dFileSize          = dFileSize.

            end. /* cFileName matches "bak-" */
    
        end. /* repeat */
    
        input close.

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* fillArchiveZip */

procedure fillBakDir:

    define input param pcBakRootDir as char no-undo.

    define buffer ttBakDir for ttBakDir.

    define var cBakType     as char no-undo.
    define var cFileName    as char no-undo.
    define var cFullPath    as char no-undo.
    define var cAttrList    as char no-undo.

    empty temp-table ttBakDir.
    
    {slib/err_try}:

        input from os-dir( pcBakRootDir ).

        repeat:
        
            import
                cFileName
                cFullPath
                cAttrList.
            
            if index( "d", cAttrList ) > 0

            and ( cFileName matches "bak-....-..-..t..-..-..-full"
               or cFileName matches "bak-....-..-..t..-..-..-inc..." ) then do:

                if cFileName matches "*-full*" then
                   cBakType = "full".

                else
                if cFileName matches "*-inc*" then
                   cBakType = "inc".

                create ttBakDir.
                assign
                    ttBakDir.cFullPath  = cFullPath
                    ttBakDir.cDir       = cFileName
                    ttBakDir.cType      = cBakType.

            end. /* index( "d" ) > 0 */

        end. /* repeat */

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* fillBakDir */



procedure setBusy:

    define var cArchiveLkFile       as char no-undo.
    define var cArchiveAimageLkFile as char no-undo.

    {slib/err_try}:

        assign
            cArchiveLkFile          = os_normalizePath( cDbSetArchiveRootDir    + "/archive.lk" )
            cArchiveAimageLkFile    = os_normalizePath( cDbSetArchiveRootDir    + "/archive-aimage.lk" ).

        file-info:file-name = cArchiveLkFile.

        if  file-info:full-pathname <> ?
        and date_getTimeInterval( today, time, file-info:file-mod-date, file-info:file-mod-time ) > {&xArchiveLkTimeout} then

            os-delete value( cArchiveLkFile ).

        file-info:file-name = cArchiveAimageLkFile.

        if  file-info:full-pathname <> ?
        and date_getTimeInterval( today, time, file-info:file-mod-date, file-info:file-mod-time ) > {&xArchiveAimageLkTimeout} then

            os-delete value( cArchiveAimageLkFile ).



        if os_isFileExists( cArchiveLkFile ) then
            {slib/err_throw "'error'" "'Archive is running. Archive aimage aborted'"}.

        if os_isFileExists( cArchiveAimageLkFile ) then
            {slib/err_throw "'error'" "'Archive aimage is already running.'"}.

        output to value( cArchiveAimageLkFile ).
        output close.

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* setBusy */

procedure setAvail:

    os-delete value( os_normalizePath( cDbSetArchiveRootDir + "/archive-aimage.lk" ) ).

end procedure. /* setAvail */



procedure sendErrorReport:

    define var cAttachmentLocalList as char no-undo.
    define var cAttachmentList      as char no-undo.

    define var cLogFileList         as char no-undo.
    define var cLogFile             as char no-undo.

    define var cTempFile            as char no-undo.
    define var cMsg                 as char no-undo.
    define var lOk                  as log no-undo.
    define var i                    as int no-undo.
    define var j                    as int no-undo.

    if cMailTo = ? then
        return.

    assign
        cLogFileList            = os_normalizePath( cDbSetArchiveRootDir + "/archive.lg" )
                          + "," + os_normalizePath( cDbSetArchiveRootDir + "/archive-aimage.lg" )

        cAttachmentLocalList    = ""
        cAttachmentList         = "".

    j = num-entries( cLogFileList ).

    do i = 1 to j:
    
        cLogFile = entry( i, cLogFileList ).
        
        if os_isFileExists( cLogFile ) then do:
        
            cTempFile = os_getTempFile( ?, ".lg" ).

            run os_tail(
                input cLogFile,
                input cTempFile,
                input 100 ).
    
            assign
                cAttachmentLocalList    = cAttachmentLocalList
                    + ( if cAttachmentLocalList <> "" then "," else "" )
                    + cTempFile
    
                cAttachmentList         = cAttachmentList
                    + ( if cAttachmentList <> "" then "," else "" )
                    + os_getSubPath( cLogFile, "file", "ext" ) + ":type=text/plain:charset=US-ASCII:filetype=ASCII".

        end. /* os_isFileExists */

    end. /* 1 to j */



    run slib/smtpmail.p (
        input   cMailHub,                               /* Mail Hub */
        input   cMailTo,                                /* Mail To */
        input   cMailFrom,                              /* Mail From */
        input   "",                                     /* CC comma separated */
        input   cAttachmentList,                        /* Attachments comma separated */
        input   cAttachmentLocalList,                   /* Attachment local files comma separated */
        input   "ARCHIVE ENCOUNTERED ERRORS",           /* Subject */
        input   "Archive process encountered errors.~n"
              + "~n"
              + "Please see attached log file trail.",  /* Body */
        input   "type=text/plain:charset=US-ASCII",     /* Mime header */
        input   "text",                                 /* Body type */
        input   1,                                      /* Priority */
        input   no,                                     /* Auth */
        input   "",                                     /* Auth type */
        input   "",                                     /* User */
        input   "",                                     /* Pass */
        output  lOK,
        output  cMsg ).

    j = num-entries( cAttachmentLocalList ).

    do i = 1 to j:

        os-delete value( entry( i, cAttachmentLocalList ) ).

    end. /* 1 to j */

end procedure. /* sendErrorReport */
