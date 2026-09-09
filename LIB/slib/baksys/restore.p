
/**
 * restore.p -
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



&global xIncOverlap             1
&global xArchiveLkTimeout       82800   /* 23 * 60 * 60 */
&global xRestoreLkTimeout       82800   /* 23 * 60 * 60 */
&global xArchiveWaitTimeout     900     /* 15 * 60 */
&global xShutdownWaitTimeout    900     /* 15 * 60 */

&if "{&opsys}" begins "win" &then

    &global xCmdBusy            'call proutil "%pdbname%" -C busy'
    &global xCmdDel             'call prodel "%pdbname%" < "%inputfile%"'
    &global xCmdRestore         'call prorest "%pdbname%" "%bakfile%" -verbose < "%inputfile%"' 
    &global xCmdRollFrwd        'call rfutil "%pdbname%" -C roll forward -a "%bakfile%"'
    &global xCmdRollFrwdTime    'call rfutil "%pdbname%" -C roll forward endtime "%endtime%" -a "%bakfile%"'
    &global xCmdValidateDb      'call pro -b -p "slib\baksys\validate-db.p" -param "%outputfile%" -db "%pdbname%"'
    &global xCmdStList          'call prostrct list "%pdbname%"'

&else

    &global xCmdBusy            'proutil "%pdbname%" -C busy'
    &global xCmdDel             'prodel "%pdbname%" < "%inputfile%"'
    &global xCmdRestore         'prorest "%pdbname%" "%bakfile%" -verbose < "%inputfile%"' 
    &global xCmdRollFrwd        'rfutil "%pdbname%" -C roll forward -a "%bakfile%"'
    &global xCmdRollFrwdTime    'rfutil "%pdbname%" -C roll forward endtime "%endtime%" -a "%bakfile%"'
    &global xCmdValidateDb      'pro -b -p "slib/baksys/validate-db.p" -param "%outputfile%" -db "%pdbname%"'
    &global xCmdStList          'prostrct list "%pdbname%"'

&endif



define temp-table ttDb no-undo

    field iDbNum            as int
    field cLDbName          as char
    field cPDbName          as char
    field cPort             as char
    field lKeepSt           as log

    field cArchiveRootDir   as char
    field cArchiveDir       as char
    field cArchiveFullBak   as char
    field cArchiveLastInc   as char

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
    field cBakType          as char 
    field iIbSeq            as int

    field tDate             as date
    field iTime             as int

    index cFullPath is primary unique 
          cFullPath.

define temp-table ttStArea no-undo

    field cAreaType         as char
    field cAreaName         as char
    field iAreaNum          as int
    field iAreaRpm          as int
&if {&pro_xProversion} >= "10" &then
    field iAreaBpc          as int
&endif

    field iExtentCnt        as int

    field lClosed           as log

    index TypeNum is primary unique
          cAreaType
          iAreaNum

    index cAreaName is unique
          cAreaName.

define temp-table ttStExtent no-undo

    field cAreaType         as char
    field iAreaNum          as int

    field iExtentNum        as int
    field cExtentPath       as char
    field cExtentType       as char
    field iExtentSize       as int

    index AreaExtent is primary unique
          cAreaType
          iAreaNum
          iExtentNum.

define var cDbSetName           as char no-undo.
define var cDbSetArchiveRootDir as char no-undo.
define var tRestDate            as date no-undo.
define var iRestTime            as int no-undo.
define var cRestTime            as char no-undo.
define var lDisableRollAi       as log no-undo.
define var cLogFile             as char no-undo.

define var cMailHub             as char no-undo.
define var cMailFrom            as char no-undo.
define var cMailTo              as char no-undo.

define var lError               as log no-undo.



run preinitializeProc.

run setBusy.

{slib/err_try}:

    run initializeProc.

    run log_writeMessage( "stLog", " - " ).
    run log_writeMessage( "stLog", "Set " + cDbSetName + " restore started." ).

    for each ttDb:

        {slib/err_try}:

            run log_writeMessage( "stLog", "Database " + ttDb.cLDbName + " restore started." ).

            run restoreFull ( buffer ttDb ).
            run restoreIncs ( buffer ttDb ).
            run rollFrwdAi  ( buffer ttDb ).
            run validateDb  ( buffer ttDb ).

            run log_writeMessage( "stLog", "Database " + ttDb.cLDbName + " restore completed successfully." ).

        {slib/err_end}.

    end. /* each ttDb */

    if lError then do:

        run log_writeMessage( "stLog", "** Set " + cDbSetName + " restore completed with errors (" +
            date_Date2Str( today, 0, 0, "www mmm d, yyyy" ) + ")." ).

        {slib/err_throw "'error'"}.

    end. /* lError */

    else do:

        run log_writeMessage( "stLog", "Set " + cDbSetName + " restore completed successfully (" +
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

    define var cDisableRollAi   as char no-undo.
    define var cPathList        as char no-undo.
    define var iTimeZone        as int no-undo.

    {slib/err_try}:

        assign
           lError               = no

           cDbSetArchiveRootDir = trim( os-getenv( "ARCHIVE_ROOT_DIR" ) ).

        if cDbSetArchiveRootDir = "" then cDbSetArchiveRootDir = ?.

        if cDbSetArchiveRootDir = ? then
            {slib/err_throw "'os_envvar_is_empty'" "'ARCHIVE_ROOT_DIR'"}.

        if not os_isDirExists( cDbSetArchiveRootDir ) then
            {slib/err_throw "'dir_not_found'" "cDbSetArchiveRootDir"}.

        cLogFile = os_normalizePath( cDbSetArchiveRootDir + "/restore.lg" ).

        run log_openLogFile ( "stLog", cLogFile, ? ).
        run log_directErrors( "stLog" ).



        assign
           cDbSetName           = trim( os-getenv( "DB_SET_NAME" ) )
           cRestTime            = trim( os-getenv( "REST_TIME" ) )
           cDisableRollAi       = trim( os-getenv( "DISABLE_ROLL_AI" ) )

           cMailHub             = trim( os-getenv( "MAIL_HUB" ) )
           cMailTo              = trim( os-getenv( "MAIL_TO" ) )
           cMailFrom            = trim( os-getenv( "MAIL_FROM" ) ).

        if cDbSetName           = "" then cDbSetName = ?.
        if cRestTime            = "" then cRestTime = ?.
        if cDisableRollAi       = "" then cDisableRollAi = ?.

        if cMailHub             = "" then cMailHub = ?.
        if cMailTo              = "" then cMailTo = ?.
        if cMailFrom            = "" then cMailFrom = ?.

        if cDisableRollAi = ? then
           cDisableRollAi = "no".

        if cMailHub = ? then
           cMailHub = "localhost:25".

        if cMailFrom = ? then
           cMailFrom = "backup@alonblich.com".

        if cDbSetName = ? then
            {slib/err_throw "'os_envvar_is_empty'" "'DB_SET_NAME'"}.



        if cRestTime = ? then do:

            run os_findFile(
                input   cDbSetArchiveRootDir,
                input   "bak-....-..-..t..-..-..-full-aimage*~~.zip,"
                      + "bak-....-..-..t..-..-..-inc...-aimage*~~.zip",
                output  cPathList ).

            if cPathList = ? then

                 cRestTime = "LAST".
            else cRestTime = "PREV".

        end. /* cRestTime = ? */

        assign
            tRestDate = ?
            iRestTime = ?.

        if  cRestTime <> "LAST"
        and cRestTime <> "PREV"
        and cRestTime <> ? then do:

            run date_Str2Date(
                input   cRestTime,
                input   "yyyy-mm-dd~~thh-ii-ss",
                output  tRestDate,
                output  iRestTime,
                output  iTimeZone ).

            if tRestDate = ?
            or iRestTime = ? then
                {slib/err_throw "'error'" "'Invalid REST_TIME date value. Date sample 1979-05-18t00-00-00'"}.

            assign
                iRestTime = iRestTime / 1000
                cRestTime = date_Date2Str( tRestDate, iRestTime * 1000, 0, "yyyy-mm-dd~~thh-ii-ss" ).

                /* date_Str2Date would except 1979/05/18t00:00:00 and 1979-05-18-00-00-00. this normalizes the string value. */

        end. /* cRestTime <> ? */

        lDisableRollAi = no.

        if cDisableRollAi = "1"
        or cDisableRollAi = "yes"
        or cDisableRollAi = "true" then

           lDisableRollAi = yes.

        if lDisableRollAi then
            run log_writeMessage( "stLog", "WARNING: Roll aimage is disabled." ).

        run preinitializeDb.

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* preinitializeProc */

procedure preinitializeDb:

    define buffer ttDb          for ttDb.
    define buffer ttArchiveDir  for ttArchiveDir.
    define buffer ttArchiveZip  for ttArchiveZip.

    define var iDbNum   as int no-undo.
    define var cDbName  as char no-undo.
    define var cDbValue as char no-undo.
    define var lDbFound as log no-undo.

    define var cLDbName as char no-undo.
    define var cPDbName as char no-undo.
    define var cPort    as char no-undo.
    define var cKeepSt  as char no-undo.
    define var lKeepSt  as log no-undo.

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

            assign
               lKeepSt = no
               cKeepSt = trim( os-getenv( "KEEP_ST" + string( iDbNum, "99" ) ) ).

            if cKeepSt = "1"
            or cKeepSt = "yes"
            or cKeepSt = "true" then
               lKeepSt = yes.



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

                if not os_isDirExists( os_getSubPath( cPDbName, "dir", "dir" ) ) then
                     run os_createDir( os_getSubPath( cPDbName, "dir", "dir" ) ).



                create ttDb.
                assign
                    ttDb.iDbNum                 = iDbNum
                    ttDb.cLDbName               = cLDbName
                    ttDb.cPDbName               = cPDbName
                    ttDb.cPort                  = cPort
                    ttDb.lKeepSt                = lKeepSt

                    ttDb.cArchiveRootDir        = ?
                    ttDb.cArchiveDir            = ?
                    ttDb.cArchiveFullBak        = ?
                    ttDb.cArchiveLastInc        = ?.

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
    define buffer os_ttFile for os_ttFile.

    {slib/err_try}:

        run initializeDb.



        run os_fillFile(
            input   pro_cTempFullDir,
            input   "bak-full.bak"
                 + ",bak-inc.bak"
                 + ",bak.st"
                 + ",aimage*.ai",
            output  table os_ttFile ).

        for each os_ttFile:

            os-delete value( os_ttFile.cFullPath ).

        end. /* each os_ttFile */

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* initializeProc */

procedure initializeDb:

    define buffer ttDb          for ttDb.
    define buffer ttArchiveDir  for ttArchiveDir.
    define buffer ttArchiveZip  for ttArchiveZip.

    define var cArchiveRootDir  as char no-undo.
    define var cArchiveDir      as char no-undo.
    define var cArchiveFullBak  as char no-undo.
    define var cArchiveLastInc  as char no-undo.

    define var cStFile          as char no-undo.
    define var cBakStFile       as char no-undo.
    define var iStart           as int no-undo.
    define var iEnd             as int no-undo.

    define var tDate            as date no-undo.
    define var iTime            as int no-undo.
    define var lMsg             as log no-undo.
    define var i                as int no-undo.

    {slib/err_try}:

        for each ttDb:

            {slib/err_try}:

                 if os_isFileExists( ttDb.cPDbName ) then do:

                    assign
                        tDate   = today
                        iTime   = time
                        lMsg    = no.

                    repeat:

                        &if "{&opsys}" begins "win" &then
    
                            run win_batch(
                                input 'proenv ~n'
                                    + replace( {&xCmdBusy}, "%pdbname%", ttDb.cPDbName ),
                                input 'silent,wait' ).
    
                            if win_iErrorLevel = 0 then 
                                leave.
    
                        &else
                        
                            run unix_shell(
                                input 'proenv ~n'
                                    + replace( {&xCmdBusy}, "%pdbname%", ttDb.cPDbName ),
                                input 'silent,wait' ).
                        
                            if unix_iExitCode = 0 then
                                leave.
    
                        &endif

                        if not lMsg then do:

                            run log_writeMessage( "stLog", "Restore waiting for database " + ttDb.cLDbName + " to shutdown." ).
                            lMsg = yes.

                        end. /* not lMsg */

                        if date_getTimeInterval( today, time, tDate, iTime ) > {&xShutdownWaitTimeout} then
                            {slib/err_throw "'error'" "'Restore timed out waiting for database ' + ttDb.cLDbName + ' to shutdown.'"}.

                        pause 60.

                    end. /* repeat */

                end. /* os_isFileExists( cPDbName ) */



                cArchiveRootDir = os_normalizePath( cDbSetArchiveRootDir + "/" + ttDb.cLDbName ).

                if not os_isDirExists( cArchiveRootDir ) then
                    {slib/err_throw "'dir_not_found'" "cArchiveRootDir"}.

                assign
                    cArchiveDir     = ?
                    cArchiveFullBak = ?
                    cArchiveLastInc = ?.

                run fillArchiveDir( cArchiveRootDir ).

                if cRestTime = "PREV" then do:
        
                    i = 0.

                    _loop:

                    for each ttArchiveDir

                        by ttArchiveDir.cFullPath desc:

                        cArchiveDir = ttArchiveDir.cFullPath.

                        run fillArchiveZip( ttArchiveDir.cFullPath ).

                        find first ttArchiveZip
                             where ttArchiveZip.cBakType = "full"
                             no-error.

                        if avail ttArchiveZip then do:

                            cArchiveFullBak = ttArchiveZip.cFullPath.

                            for each  ttArchiveZip
                                where ttArchiveZip.cBakType = "full"
                                   or ttArchiveZip.cBakType = "inc"

                                by ttArchiveZip.cFullPath desc:

                                cArchiveLastInc = ttArchiveZip.cFullPath.

                                i = i + 1.

                                if i = 2 then
                                    leave _loop.

                            end. /* each ttArchiveZip */

                        end. /* avail ttArchiveZip */

                    end. /* each ttArchiveDir */
       
                end. /* else */

                else do:
                
                    _loop:

                    for each ttArchiveDir

                        by ttArchiveDir.cFullPath desc:

                        cArchiveDir = ttArchiveDir.cFullPath.

                        run fillArchiveZip( ttArchiveDir.cFullPath ).

                        find first ttArchiveZip
                             where ttArchiveZip.cBakType = "full"
                             no-error.

                        if avail ttArchiveZip then do:

                            cArchiveFullBak = ttArchiveZip.cFullPath.

                            for each  ttArchiveZip
                              where ( ttArchiveZip.cBakType = "full"
                                   or ttArchiveZip.cBakType = "inc" )

                                and ( cRestTime = "LAST"
                                   or ttArchiveZip.tDate < tRestDate
                                   or ttArchiveZip.tDate = tRestDate and ttArchiveZip.iTime <= iRestTime )

                                by ttArchiveZip.cFullPath desc:

                                cArchiveLastInc = ttArchiveZip.cFullPath.

                                leave _loop.

                            end. /* each ttArchiveZip */

                        end. /* avail ttArchiveZip */

                    end. /* each ttArchiveDir */

                end. /* cRestTime <> ? */
        
                if cArchiveDir      = ?
                or cArchiveFullBak  = ?
                or cArchiveLastInc  = ? then
                    {slib/err_throw "'error'" "'Archive backup not found.'"}.



                assign
                    cStFile     = os_getSubPath( ttDb.cPDbName, "dir", "file" ) + ".st"
                    cBakStFile  = os_normalizePath( pro_cTempFullDir + "/bak.st" ).

                if ttDb.lKeepSt then do:
        
                    if not os_isFileExists( cStFile ) then do:
                    
                        if os_isFileExists( ttDb.cPDbName ) then do:
        
                            &if "{&opsys}" begins "win" &then
        
                                run win_batch(
                                    input 'proenv ~n'
                                        + 'cd /d "' + os_getSubPath( ttDb.cPDbName, "dir", "dir" ) + '" ~n'
                                        + replace( {&xCmdStList}, "%pdbname%", os_getSubPath( ttDb.cPDbName, "file", "file" ) ),
                                    input 'wait' ).
        
                            &else
        
                                run unix_shell(
                                    input 'proenv ~n'
                                        + 'cd "' + os_getSubPath( ttDb.cPDbName, "dir", "dir" ) + '" ~n'
                                        + replace( {&xCmdStList}, "%pdbname%", os_getSubPath( ttDb.cPDbName, "file", "file" ) ),
                                    input 'wait' ).
        
                            &endif
        
                            if not os_isFileExists( cStFile ) then
                                ttDb.lKeepSt = no.
        
                        end. /* if os_isFileExists( cPDbName ) */
        
                        else ttDb.lKeepSt = no.
        
                    end. /* not os_isFiledExists */
        
                end. /* lKeepSt */
        
                if not ttDb.lKeepSt then do:
        
                    {slib/err_try}:
        
                        run zip_extractConsole(
                            input cArchiveLastInc,
                            input "bak.st",
                            input pro_cTempFullDir ).

                        run fillStFile( cBakStFile ).

                        for each  ttStArea
                            where ttStArea.cAreaType = "a"
                            use-index TypeNum:
        
                            for each  ttStExtent
                                where ttStExtent.cAreaType  = ttStArea.cAreaType
                                  and ttStExtent.iAreaNum   = ttStArea.iAreaNum
                                use-index AreaExtent:
        
                                delete ttStExtent.
        
                            end. /* each ttStExtent */
        
                            delete ttStArea.
        
                        end. /* each ttStArea */
        
                        for each ttStExtent:
                            assign ttStExtent.cExtentPath = ".".
                        end.
        
                        run saveStFile( cStFile ).
        
                    {slib/err_catch}:
        
                        {slib/err_throw last}.
        
                    {slib/err_finally}:
        
                        os-delete value( cBakStFile ).
        
                    {slib/err_end}.
        
                end. /* if not lKeepSt */



                assign
                    ttDb.cArchiveRootDir    = cArchiveRootDir
                    ttDb.cArchiveDir        = cArchiveDir
                    ttDb.cArchiveFullBak    = cArchiveFullBak
                    ttDb.cArchiveLastInc    = cArchiveLastInc.

            {slib/err_catch}:

                run log_writeMessage( "stLog", "Restore of database " + ttDb.cLDbName + " cancelled." ).

                delete ttDb.

                lError = yes.

            {slib/err_end}.
    
        end. /* each ttDb */

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* initializeDb */

procedure closeProc.

    run log_closeLogFile( "stLog" ).

    run os_deleteTempFiles( cDbSetArchiveRootDir, ? ).
    run os_deleteTempFiles( ?, ? ).

end procedure. /* closeProc */



procedure restoreFull:

    define param buffer pbDb for ttDb.

    define var cStFile      as char no-undo.
    define var cBakFile     as char no-undo.
    define var cInputFile   as char no-undo.

    define var cFile        as char no-undo.
    define var lOk          as log no-undo.

    {slib/err_try}:

        assign
            cStFile     = os_getSubPath( cPDbName, "dir", "file" ) + ".st"
            cBakFile    = os_normalizePath( pro_cTempFullDir + "/bak-full.bak" )
            cInputFile  = os_getTempFile( "", ".inp" ).

        run zip_extractConsole(
            input pbDb.cArchiveFullBak,
            input "bak-full.bak",
            input pro_cTempFullDir ).




        output to value( cInputFile ).

            put unformatted
                "y" skip.

        output close. /* cInputFile */

        lOk = no.

        if os_isFileExists( pbDb.cPDbName ) then

            run compareStFile(
                buffer  pbDb,
                input   cStFile,
                output  lOk ).

        if not lOk then do:

            if os_isFileExists( pbDb.cPDbName ) then do:

                {slib/err_try}:
    
                    &if "{&opsys}" begins "win" &then
        
                        run win_batch(
                            input 'proenv ~n'
                                + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                                + replace( replace( {&xCmdDel}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%inputfile%", cInputFile ),
                            input 'wait' ).
        
                        if win_iErrorLevel <> 0 then
                            {slib/err_throw "'error'" "'Database delete failed.'"}.
        
                    &else
    
                        run unix_shell(
                            input 'proenv ~n'
                                + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                                + replace( replace( {&xCmdDel}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%inputfile%", cInputFile ),
                            input 'wait' ).
    
                        if unix_iExitCode <> 0 then
                            {slib/err_throw "'error'" "'Database delete failed.'"}.
        
                    &endif
    
                    if os_isFileExists( pbDb.cPDbName ) then
                        {slib/err_throw "'error'" "'Database delete failed.'"}.

                {slib/err_end}.

            end. /* if os_isFileExists( cPDbName ) */

            run fillStFile( cStFile ).

            for each ttStExtent:

                if os_isFileExists( ttStExtent.cExtentPath ) then do:
                   os-delete value( ttStExtent.cExtentPath ) {slib/err_os-error}.
                end.

            end. /* each ttExtent */

            cFile = os_getSubPath( pbDb.cPDbName, "dir", "file" ).

            if os_isFileExists( cFile + ".db" ) then do:
               os-delete value( cFile + ".db" ) {slib/err_os-error}.
            end.

            if os_isFileExists( cFile + ".lk" ) then do:
               os-delete value( cFile + ".lk" ) {slib/err_os-error}.
            end.

            if os_isFileExists( cFile + ".lg" ) then do:
               os-delete value( cFile + ".lg" ) {slib/err_os-error}.
            end.

        end. /* not lOk */



        run log_writeMessage( "stLog", "Full backup restore started." ).

        output to value( cInputFile ).

            put unformatted
                "y" skip
                "y" skip
                "y" skip.

        output close. /* cInputFile */

        &if "{&opsys}" begins "win" &then

            run win_batch(
                input 'proenv ~n'
                    + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                    + replace ( replace( replace( {&xCmdRestore}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%bakfile%", cBakFile ), "%inputfile%", cInputFile ),
                input 'wait' ).

            if win_iErrorLevel <> 0 then
                {slib/err_throw "'error'" "'Full backup restore failed.'"}.

        &else

            run unix_shell(
                input 'proenv ~n'
                    + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                    + replace ( replace( replace( {&xCmdRestore}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%bakfile%", cBakFile ), "%inputfile%", cInputFile ),
                input 'wait' ).

            if unix_iExitCode <> 0 then
                {slib/err_throw "'error'" "'Full backup restore failed.'"}.

        &endif

        if not os_isFileExists( pbDb.cPDbName ) then
            {slib/err_throw "'error'" "'Full backup restore failed.'"}.

        run log_writeMessage( "stLog", "Full backup restore completed successfully." ).

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_finally}:

        os-delete value( cBakFile ).
        os-delete value( cInputFile ).

    {slib/err_end}.

end procedure. /* restoreFull */

procedure restoreIncs:

    define param buffer pbDb for ttDb.

    define buffer ttArchiveZip for ttArchiveZip.

    define var cBakFile     as char no-undo.
    define var cInputFile   as char no-undo.
    define var iLastIbSeq   as int no-undo.

    {slib/err_try}:

        assign
            cBakFile    = os_normalizePath( pro_cTempFullDir +  "/bak-inc.bak" )
            cInputFile  = os_getTempFile( "", ".inp" ).

        output to value( cInputFile ).

            put unformatted
                "y" skip
                "y" skip
                "y" skip.

        output close.



        iLastIbSeq = 0.

        run fillArchiveZip( pbDb.cArchiveDir ).

        for each  ttArchiveZip
            where ttArchiveZip.cBakType     = "inc"
              and ttArchiveZip.cFullPath   <= pbDb.cArchiveLastInc
            use-index cFullPath:

            if ttArchiveZip.iIbSeq - iLastIbSeq > {&xIncOverlap} + 1 then
                {slib/err_throw "'error'" "'Missing incremental backup.'"}.

            iLastIbSeq = ttArchiveZip.iIbSeq.

            run zip_extractConsole(
                input ttArchiveZip.cFullPath,
                input "bak-inc.bak",
                input pro_cTempFullDir ).



            run log_writeMessage( "stLog", "Incremental backup restore started." ).
 
            &if "{&opsys}" begins "win" &then

                run win_batch(
                    input 'proenv ~n'
                        + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                        + replace( replace( replace( {&xCmdRestore}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%bakfile%", cBakFile ), "%inputfile%", cInputFile ),
                    input 'wait' ).
    
                if win_iErrorLevel <> 0 then
                    {slib/err_throw "'error'" "'Incremental backup restore failed.'"}.

            &else

                run unix_shell(
                    input 'proenv ~n'
                        + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                        + replace( replace( replace( {&xCmdRestore}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%bakfile%", cBakFile ), "%inputfile%", cInputFile ),
                    input 'wait' ).

                if unix_iExitCode <> 0 then
                    {slib/err_throw "'error'" "'Incremental backup restore failed.'"}.

            &endif

            run log_writeMessage( "stLog", "Incremental backup restore completed successfully." ).

        end. /* each tArchiveZip */

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_finally}:

        os-delete value( cBakFile ).
        os-delete value( cInputFile ).

    {slib/err_end}.

end procedure. /* restoreIncs */

procedure rollFrwdAi:

    define param buffer pbDb    for ttDb.

    define buffer os_ttFile     for os_ttFile.
    define buffer zip_ttFile    for zip_ttFile.

    define var cEndTime     as char no-undo.
    define var tEndDate     as date no-undo.
    define var iEndTime     as int no-undo.

    define var iSeqno       as int no-undo.    
    define var iSeqnoMin    as int no-undo.    
    define var iSeqnoMax    as int no-undo.    
    define var iSeqnoLast   as int no-undo.

    define var cFileName    as char no-undo.
    define var cFullPath    as char no-undo.

    if lDisableRollAi then
        return.

    run os_fillFile(
        input   pbDb.cArchiveDir,
        input   os_getSubPath( pbDb.cArchiveLastInc, "file", "file" ) + "-aimage*~~.zip",
        output  table os_ttFile ).

    if not can-find( first os_ttFile ) then
        return.

    {slib/err_try}:

        assign
            iSeqnoMin   = ?
            iSeqnoMax   = ?
            iSeqnoLast  = ?.

        _loop:

        for each os_ttFile

            by os_ttFile.cFileName:

            assign
                cFileName = os_getSubPath( os_ttFile.cFileName, "file", "file" )
                cFileName = substr( cFileName, length( cFileName ) - 11 /* - length( "aimage999999" ) + 1 */, 12 ) + ".ai"
                cFullPath = os_normalizePath( pro_cTempFullDir + "/" + cFileName ).

            run zip_list(
                input   os_ttFile.cFullPath,
                input   cFileName,
                output  table zip_ttFile ).

            find first zip_ttFile no-error.
            if not avail zip_ttFile then
                {slib/err_throw "'error'" "'Archive file ' + os_ttFile.cFileName + ' is invalid.'"}.

            if  ( tRestDate <> ? or iRestTime <> ? )

            and ( zip_ttFile.tDate > tRestDate
               or zip_ttFile.tDate = tRestDate and zip_ttFile.iTime > iRestTime ) then

                leave _loop.



            assign
               iSeqno = ?
               iSeqno = int( substr( os_getSubPath( cFileName, "file", "file" ), 7 /* length( "aimage" ) + 1 */, 6 ) ).

            if iSeqno = ? then
                {slib/err_throw "'error'" "'Archive file ' + os_ttFile.cFileName + ' is invalid.'"}.

            if  iSeqnoLast <> ?
            and iSeqno - iSeqnoLast > 1 then
                {slib/err_throw "'error'" "'Aimage extent ' + string( iSeqnoLast + 1 ) + ' missing.'"}.

            iSeqnoLast = iSeqno.



            {slib/err_try}:

                os-delete value( cFullPath ).

                run zip_extractConsole(
                    input   os_ttFile.cFullPath,
                    input   cFileName,
                    input   pro_cTempFullDir ).
    
                if not os_isFileExists( cFullPath ) then
                    {slib/err_throw "'error'" "'Unzip failed.'"}.
    
                &if "{&opsys}" begins "win" &then
    
                    run win_batch(
                        input 'proenv ~n'
                            + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                            + replace( replace( {&xCmdRollFrwd}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%bakfile%", cFullPath ),
                        input 'wait' ).
        
                    if win_iErrorLevel <> 0 then
                        {slib/err_throw "'error'" "'Aimage ' + string( iSeqno ) + ' roll forward failed.'"}.
        
                &else
        
                    run unix_shell(
                        input 'proenv ~n'
                            + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                            + replace( replace( {&xCmdRollFrwd}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%bakfile%", cFullPath ),
                        input 'wait' ).
    
                    if unix_iExitCode <> 0 then
                        {slib/err_throw "'error'" "'Aimage ' + string( iSeqno ) + ' roll forward failed.'"}.
    
                &endif
            
            {slib/err_catch}:

                {slib/err_throw last}.

            {slib/err_finally}:

                os-delete value( cFullPath ).

            {slib/err_end}.



            assign
               tEndDate = zip_ttFile.tDate
               iEndTime = zip_ttFile.iTime.

            if iSeqnoMin = ? then
               iSeqnoMin = iSeqno.
            
            if iSeqnoMax = ? then
                iSeqnoMax = iSeqno.
            else iSeqnoMax = max( iSeqnoMax, iSeqno ).

        end. /* each os_ttFile */
        
        run log_writeMessage( "stLog", "Aimage " + string( iSeqnoMin ) 
            + ( if iSeqnoMax <> iSeqnoMin then " to " + string( iSeqnoMax ) else "" )
            + " roll forward completed successfully." ).



        if  ( tEndDate <> ? or iEndTime <> ? )

        and ( tEndDate < tRestDate
           or tEndDate = tRestDate and iEndTime < iRestTime ) then do:

            find first os_ttFile
                 where os_ttFile.cFileName = os_getSubPath( pbDb.cArchiveLastInc, "file", "file" ) + "-aimage" + string( iSeqnoLast + 1, "999999" ) + ".zip"
                 no-error.

            if avail os_ttFile then 

            _block:

            do:

                assign
                    cFileName = os_getSubPath( os_ttFile.cFileName, "file", "file" )
                    cFileName = substr( cFileName, length( cFileName ) - 11 /* - length( "aimage999999" ) + 1 */, 12 ) + ".ai"
                    cFullPath = os_normalizePath( pro_cTempFullDir + "/" + cFileName ).
    
                run zip_list(
                    input   os_ttFile.cFullPath,
                    input   cFileName,
                    output  table zip_ttFile ).
    
                find first zip_ttFile no-error.
                if not avail zip_ttFile then
                    {slib/err_throw "'error'" "'Archive file ' + os_ttFile.cFileName + ' is invalid.'"}.
    
                if  ( tRestDate <> ? or iRestTime <> ? )
    
                and ( zip_ttFile.tDate < tRestDate
                   or zip_ttFile.tDate = tRestDate and zip_ttFile.iTime < iRestTime ) then
    
                    leave _block.


    
                assign
                   iSeqno = ?
                   iSeqno = int( substr( os_getSubPath( cFileName, "file", "file" ), 7 /* length( "aimage" ) + 1 */, 6 ) ).
    
                if iSeqno = ? then
                    {slib/err_throw "'error'" "'Archive file ' + os_ttFile.cFileName + ' is invalid.'"}.



                {slib/err_try}:

                    os-delete value( cFullPath ).
    
                    run zip_extractConsole(
                        input   os_ttFile.cFullPath,
                        input   cFileName,
                        input   pro_cTempFullDir ).
        
                    if not os_isFileExists( cFullPath ) then
                        {slib/err_throw "'error'" "'Unzip failed.'"}.
    
                    cEndTime = date_Date2Str( tRestDate, iRestTime * 1000, 0, "yyyy:mm:dd:hh:ii:ss" ).
    
                    &if "{&opsys}" begins "win" &then
                    
                        run win_batch(
                            input 'proenv ~n'
                                + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                                + replace( replace( replace( {&xCmdRollFrwdTime}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%endtime%", cEndTime ), "%bakfile%", cFullPath ),
                            input 'wait' ).
        
                        if win_iErrorLevel <> 0 then
                            {slib/err_throw "'error'" "'Aimage ' + string( iSeqno ) + ' roll forward failed.'"}.
    
                    &else
    
                        run unix_shell(
                            input 'proenv ~n'
                                + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                                + replace( replace( replace( {&xCmdRollFrwdTime}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%endtime%", cEndTime ), "%bakfile%", cFullPath ),
                            input 'wait' ).
    
                        if unix_iExitCode <> 0 then
                            {slib/err_throw "'error'" "'Aimage ' + string( iSeqno ) + ' roll forward failed.'"}.
    
                    &endif
            
                {slib/err_catch}:
    
                    {slib/err_throw last}.
    
                {slib/err_finally}:
    
                    os-delete value( cFullPath ).
    
                {slib/err_end}.
    


                assign
                    tEndDate = zip_ttFile.tDate
                    iEndTime = zip_ttFile.iTime.

                run log_writeMessage( "stLog", "Aimage " + string( iSeqno ) + " roll forward until " + string( tEndDate ) + " " + string( iEndTime, "hh:mm:ss" ) + " completed successfully." ).
                    
            end. /* avail os_ttFile */

        end. /* tEndTime */

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* rollFrwdAi */

procedure validateDb:

    define param buffer pbDb for ttDb.

    define var cFileName    as char no-undo.
    define var lOk          as log no-undo.

    {slib/err_try}:

        cFileName = pro_getRunFile( "slib/baksys/validate-db.p" ).
        if cFileName matches "*~~.r" then os-delete value( cFileName ).

        cFileName = os_getTempFile( ?, ".out" ).

        &if "{&opsys}" begins "win" &then

            run win_batch(
                input 'proenv ~n'
                    + replace( replace( {&xCmdValidateDb}, "%pdbname%", pbDb.cPDbName ), "%outputfile%", cFileName ),
                input 'silent,wait' ).

        &else
        
            run unix_shell(
                input 'proenv ~n'
                    + replace( replace( {&xCmdValidateDb}, "%pdbname%", pbDb.cPDbName ), "%outputfile%", cFileName ),
                input 'silent,wait' ).

        &endif

        lOk = no.

        if os_isFileExists( cFileName ) then do:

            input from value( cFileName ).
            import lOk.
            input close.

        end. /* os_isFileExists( cFileName ) */

        if not lOk then
            {slib/err_throw "'error'" "'Database ' + pbDb.cLDbName + ' validation failed.'"}.

        run log_writeMessage( "stLog", "Database " + pbDb.cLDbName + " validated successfully." ).

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_finally}:

        os-delete value( cFileName ).

    {slib/err_end}.

end procedure. /* validateDb */



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

    define var cFileName    as char no-undo.
    define var cFullPath    as char no-undo.
    define var cAttrList    as char no-undo.

    define var cBakType     as char no-undo.
    define var iIbSeq       as int no-undo.

    define var tDate        as date no-undo.
    define var iTime        as int no-undo.
    define var iTimeZone    as int no-undo.

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
                    
                iTime = iTime / 1000.



                create ttArchiveZip.
                assign
                    ttArchiveZip.cFullPath  = cFullPath
                    ttArchiveZip.cFileName  = cFileName
                    ttArchiveZip.cBakType   = cBakType
                    ttArchiveZip.iIbSeq     = iIbSeq

                    ttArchiveZip.tDate      = tDate
                    ttArchiveZip.iTime      = iTime.

            end. /* cFileName matches "bak-" */
    
        end. /* repeat */
    
        input close.

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* fillArchiveZip */



procedure fillStFile:

    define input param pcStFile as char no-undo.

    define var cDatabaseDir     as char no-undo.
    define var cDatabaseFile    as char no-undo.
    define var cTempFile        as char no-undo.
    define var cLine            as char no-undo.

    define var cAreaType        as char no-undo.
    define var cAreaName        as char no-undo.
    define var iAreaNum         as int no-undo.
    define var iAreaRpm         as int no-undo.
&if {&pro_xProversion} >= "10" &then
    define var iAreaBpc         as int no-undo.
&endif

    define var cExtentPath      as char no-undo.
    define var cExtentType      as char no-undo.
    define var iExtentSize      as int no-undo.

    define var str              as char no-undo.
    define var i                as int no-undo.

    empty temp-table ttStArea.
    empty temp-table ttStExtent.

    {slib/err_try}:

        cTempFile = os_getFullPath( pcStFile ).
        if cTempFile = ? then

            {slib/err_throw "'file_not_found'" pcStFile}.

        pcStFile = cTempFile.

        assign
            cDatabaseDir    = os_getSubPath( pcStFile, "dir", "dir" )
            cDatabaseFile   = os_getSubPath( pcStFile, "file", "file" ).



        cTempFile = os_getTempFile( ?, ".st" ).

        run pro_appendEoln(
            input pcStFile,
            input cTempFile ).

        input from value( cTempFile ).
    
        repeat:

            cLine = "".

            import unformatted cLine.
            cLine = trim( cLine ).

            if cLine = ""
            or cLine begins "#" then
                next.



            assign
                cAreaType       = ?
                cAreaName       = ?
                iAreaNum        = ?
                iAreaRpm        = ?
            &if {&pro_xProversion} >= "10" &then
                iAreaBpc        = ?
            &endif

                cExtentPath     = ?
                cExtentType     = ?
                iExtentSize     = ?.

            assign
                cAreaType               = entry( 1, cLine, " " )
                entry( 1, cLine, " " )  = ""
                cLine                   = left-trim( cLine ).

            if not ( cAreaType = "a"
                  or cAreaType = "b"
                  or cAreaType = "d"
                  or cAreaType = "t" ) then
                {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.



            if cAreaType = "d" then do:

                assign
                    cAreaName   = "Schema Area"
                    iAreaNum    = 6
                    iAreaRpm    = ?
                &if {&pro_xProversion} >= "10" &then
                    iAreaBpc    = 1
                &endif.

                if cLine matches '"*":*' then do:

                    i = index( cLine, '":', 2 ).

                    if i = 0 then
                        {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

                    assign
                        cAreaName               = substr( cLine, 2, i - 2 )
                        substr( cLine, 1, i )   = "".

                    if cLine begins ":" then do:

                    &if {&pro_xProversion} >= "10" &then
                                      i = index( cLine, ",", 2 ).
                        if i = 0 then i = index( cLine, ";", 2 ).
                        if i = 0 then i = index( cLine, " ", 2 ).
                    &else
                                      i = index( cLine, ",", 2 ).
                        if i = 0 then i = index( cLine, " ", 2 ).
                    &endif

                        if i = 0 then
                            {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

                        assign
                           iAreaNum                     = ?
                           iAreaNum                     = int( substr( cLine, 2, i - 2 ) )
                           substr( cLine, 1, i - 1 )    = "" no-error.

                        if iAreaNum = ? then
                            {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

                    end. /* cLine begins ":" */

                    if cLine begins "," then do:

                    &if {&pro_xProversion} >= "10" &then
                                      i = index( cLine, ";", 2 ).
                        if i = 0 then i = index( cLine, " ", 2 ).
                    &else
                                      i = index( cLine, " ", 2 ).
                    &endif

                        if i = 0 then
                            {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

                        assign
                           iAreaRpm                     = ?
                           iAreaRpm                     = int( substr( cLine, 2, i - 2 ) )
                           substr( cLine, 1, i - 1 )    = "" no-error.

                        if iAreaRpm = ? then
                            {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

                        if not ( iAreaRpm = 1
                              or iAreaRpm = 2
                              or iAreaRpm = 4
                              or iAreaRpm = 8
                              or iAreaRpm = 16
                              or iAreaRpm = 32
                              or iAreaRpm = 64
                              or iAreaRpm = 128
                              or iAreaRpm = 256 ) then
                            {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

                    end. /* cLine begins "," */

                &if {&pro_xProversion} >= "10" &then

                    if cLine begins ";" then do:

                        i = index( cLine, " ", 2 ).

                        if i = 0 then
                            {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

                        assign
                           iAreaBpc                     = ?
                           iAreaBpc                     = int( substr( cLine, 2, i - 2 ) )
                           substr( cLine, 1, i - 1 )    = "" no-error.

                        if not ( iAreaBpc = 1
                              or iAreaBpc = 8
                              or iAreaBpc = 64
                              or iAreaBpc = 512 ) then
                            {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

                    end. /* cLine begins ";" */

                &endif /* proversion >= "10" */

                    if not ( cLine <> "" and substr( cLine, 1, 1 ) = " " ) then
                        {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

                    cLine = left-trim( cLine ).

                end. /* matches '"*":' */

            end. /* cAreaType = "d" */



            find first ttStArea
                 where ttStArea.cAreaType   = cAreaType
                   and ttStArea.iAreaNum    = iAreaNum
                 use-index TypeNum
                 no-error.

            if not avail ttStArea then do:

                if  cAreaType = "d"
                and can-find(
                    first ttStArea
                    where ttStArea.cAreaName = cAreaName ) then
                    {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

                for each ttStArea
                    where ttStArea.lClose = no:
                    assign ttStArea.lClose = yes.
                end.

                create ttStArea.
                assign
                    ttStArea.cAreaType  = cAreaType
                    ttStArea.cAreaName  = cAreaName
                    ttStArea.iAreaNum   = iAreaNum
                    ttStArea.iAreaRpm   = iAreaRpm
                &if {&pro_xProversion} >= "10" &then
                    ttStArea.iAreaBpc   = iAreaBpc
                &endif

                    ttStArea.iExtentCnt = 0

                    ttStArea.lClosed    = no.

            end. /* not avail ttStArea */

            else do:

                if ttStArea.lClose then
                    {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

                if ttStArea.cAreaName <> cAreaName
                or ttStArea.iAreaRpm  <> iAreaRpm
            &if {&pro_xProversion} >= "10" &then
                or ttStArea.iAreaBpc  <> iAreaBpc
            &endif then
                    {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

            end. /* else */

            assign
                ttStArea.iExtentCnt = ttStArea.iExtentCnt + 1.



            if cLine = "" then
                {slib/err_throw "'error'" "'Invalid ST file ' + pcStFile + '.'"}.

            if cLine begins '!"' then do:

                i = index( cLine, '"', 3 ).

                if i = 0 then
                    {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

                assign
                    cExtentPath             = os_normalizePath( substr( cLine, 3, i - 3 ) )
                    substr( cLine, 1, i )   = ""
                    cLine                   = left-trim( cLine ).

            end. /* cLine begins '!"' */

            else do:

                assign
                    cExtentPath             = os_normalizePath( entry( 1, cLine, " " ) )
                    entry( 1, cLine, " " )  = ""
                    cLine                   = left-trim( cLine ).

            end. /* else */

            if cExtentPath = "." then
               cExtentPath = cDatabaseDir + cDatabaseFile 

                    +  ( if ttStArea.cAreaType = "d" and ttStArea.iAreaNum <> 6 then "_" + string( ttStArea.iAreaNum ) else "" )
                    + "." + ttStArea.cAreaType + string( ttStArea.iExtentCnt ).

            else
            if os_getSubPath( cExtentPath, "dir", "dir" ) = os_normalizePath( "./" ) then
                cExtentPath = cDatabaseDir + os_getSubPath( cExtentPath, "file", "ext" ).

            else
            if os_isRelativePath( cExtentPath ) then
                cExtentPath = os_normalizePath( cDatabaseDir + cExtentPath ).



            if cLine <> "" then do:

                assign
                    cExtentType             = entry( 1, cLine, " " )
                    entry( 1, cLine, " " )  = ""
                    cLine                   = left-trim( cLine ).

                if not ( cExtentType = "f"
                      or cExtentType = "v" ) then
                    {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

            end. /* cLine <> "" */

            else do:

                assign
                    cExtentType = "v".

            end. /* else */



            if cExtentType = "f" and cLine = "" then
                {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

            if cLine <> "" then do:

                assign
                   iExtentSize              = ?
                   iExtentSize              = int( entry( 1, cLine, " " ) )
                   entry( 1, cLine, " " )   = ""
                   cLine                    = left-trim( cLine ) no-error.

                if iExtentSize = ? then
                    {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

            end. /* cExtentType = "f" */

            if ttStArea.cAreaType = "t" and cExtentType = "v" then
                {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

            if cLine <> "" then
                {slib/err_throw "'error'" "'Invalid .ST file ' + pcStFile + '.'"}.

            create ttStExtent.
            assign
                ttStExtent.cAreaType    = ttStArea.cAreaType
                ttStExtent.iAreaNum     = ttStArea.iAreaNum

                ttStExtent.iExtentNum   = ttStArea.iExtentCnt
                ttStExtent.cExtentPath  = cExtentPath
                ttStExtent.cExtentType  = cExtentType
                ttStExtent.iExtentSize  = iExtentSize.

        end. /* repeat */

        for each ttStArea
            where ttStArea.lClose = no:
            assign ttStArea.lClose = yes.
        end.

        input close. /* cTempFile */

    {slib/err_catch}:

        empty temp-table ttStArea.
        empty temp-table ttStExtent.

        {slib/err_throw last}.

    {slib/err_finally}:

        os-delete value( cTempFile ).

    {slib/err_end}.

end procedure. /* fillStFile */

procedure saveStFile:

    define input param pcStFile as char no-undo.

    pcStFile = os_normalizePath( pcStFile ).

    if os_isRelativePath( pcStFile ) then
        pcStFile = os_normalizePath( pro_cWorkDir + "/" + pcStFile ).



    output to value( pcStFile ).

    for each ttStArea

        by ( if ttStArea.cAreaType = "b" then 1 else
           ( if ttStArea.cAreaType = "t" then 2 else
           ( if ttStArea.cAreaType = "d" then 3 else
           ( if ttStArea.cAreaType = "a" then 4 else 999 ) ) ) ):

        if ttStArea.cAreaType <> "a" then
            put unformatted "#" skip.

        for each  ttStExtent
            where ttStExtent.cAreaType  = ttStArea.cAreaType
              and ttStExtent.iAreaNum   = ttStArea.iAreaNum
            use-index AreaExtent:

            if ttStArea.cAreaType = "a" then
                put unformatted "#" skip.

            put unformatted ttStArea.cAreaType.

            if ttStArea.cAreaType = "d" then do:

                put unformatted " ".
                put unformatted
                     '"' ttStArea.cAreaName '":' + string( ttStArea.iAreaNum )
                    ( if ttStArea.iAreaRpm <> ? then ',' + string( ttStArea.iAreaRpm ) else '' )
                &if {&pro_xProversion} >= "10" &then
                    ( if ttStArea.iAreaBpc <> ? then ';' + string( ttStArea.iAreaBpc ) else '' )
                &endif .

            end. /* cAreaType = "d" */

            put unformatted " ".

            if index( ttStExtent.cExtentPath, " " ) > 0
            then put unformatted '!"' ttStExtent.cExtentPath '"'.
            else put unformatted      ttStExtent.cExtentPath.

            if ttStExtent.cExtentType = "f" then do:

                put unformatted " ".
                put unformatted ttStExtent.cExtentType " " string( ttStExtent.iExtentSize ).

            end. /* cExtentType = "f" */

            put unformatted skip.

        end. /* each ttStExtent */

    end. /* each ttStArea */

    output close. /* pcStFile */

end procedure. /* saveStFile */

procedure compareStFile:

    define param    buffer pbDb     for ttDb.
    define input    param  pcStFile as char no-undo.
    define output   param  plOk     as log no-undo.

    define var hAreaQuery           as handle no-undo.
    define var hAreaBuff            as handle no-undo.
    define var hAreaTypeFld         as handle no-undo.
    define var hAreaNameFld         as handle no-undo.
    define var hAreaNumberFld       as handle no-undo.
    define var hAreaRecBitsFld      as handle no-undo.
    define var hAreaClusterSizeFld  as handle no-undo.
    define var hAreaExtentsFld      as handle no-undo.

    define var hExtentQuery         as handle no-undo.
    define var hExtentBuff          as handle no-undo.
    define var hExtentNumberFld     as handle no-undo.
    define var hExtentPathFld       as handle no-undo.
    define var hExtentTypeFld       as handle no-undo.
    define var hExtentSizeFld       as handle no-undo.

    define var cOutFile             as char no-undo.
    define var lOk                  as log no-undo.
    define var i                    as int no-undo.
    define var j                    as int no-undo.

    create widget-pool.

    plOk = no.

    {slib/err_try}:

        cOutFile = os_getTempFile( ?, ".out" ).

        &if "{&opsys}" begins "win" &then

            run win_batch(
                input 'proenv ~n'
                    + replace( replace( {&xCmdValidateDb}, "%pdbname%", pbDb.cPDbName ), "%outputfile%", cOutFile ),
                input 'silent,wait' ).

        &else
        
            run unix_shell(
                input 'proenv ~n'
                    + replace( replace( {&xCmdValidateDb}, "%pdbname%", pbDb.cPDbName ), "%outputfile%", cOutFile ),
                input 'silent,wait' ).

        &endif

        lOk = no.

        if os_isFileExists( cOutFile ) then do:

            input from value( cOutFile ).
            import lOk.
            input close.

        end. /* os_isFileExists( cOutFile ) */

        if not lOk then
            {slib/err_throw "'error'"}.
        
        

        connect value( "-db " + pbDb.cPDbName + " -ld " + pbDb.cLDbName + " -1" ) {slib/err_no-error-flag}.

        create query  hAreaQuery.
        create buffer hAreaBuff for table pbDb.cLDbName + "._Area".

        assign
            hAreaTypeFld        = hAreaBuff:buffer-field( "_Area-Type" )
            hAreaNameFld        = hAreaBuff:buffer-field( "_Area-Name" )
            hAreaNumberFld      = hAreaBuff:buffer-field( "_Area-Number" )
            hAreaRecBitsFld     = hAreaBuff:buffer-field( "_Area-Recbits" )
        &if {&pro_xProversion} >= "10" &then
            hAreaClusterSizeFld = hAreaBuff:buffer-field( "_Area-ClusterSize" )
        &endif
            hAreaExtentsFld     = hAreaBuff:buffer-field( "_Area-Extents" ).

        hAreaQuery:set-buffers( hAreaBuff ).
        hAreaQuery:query-prepare(

              "for each  _Area ~n"
            + "    where _Area._Area-Type = 3 ~n"
            + "       or _Area._Area-Type = 4 ~n"
            + "       or _Area._Area-Type = 6 and _Area._Area-Number >= 6 ~n"
            + "       or _Area._Area-Type = 7 ~n"
            + "    use-index _Area-Number ~n"
            + "    no-lock" ).

        create query  hExtentQuery.
        create buffer hExtentBuff for table pbDb.cLDbName + "._AreaExtent".

        assign
            hExtentNumberFld    = hExtentBuff:buffer-field( "_Extent-Number" )
            hExtentPathFld      = hExtentBuff:buffer-field( "_Extent-Path" )
            hExtentTypeFld      = hExtentBuff:buffer-field( "_Extent-Type" )
            hExtentSizeFld      = hExtentBuff:buffer-field( "_Extent-Size" ).

        hExtentQuery:set-buffers( hExtentBuff ).
        hExtentQuery:query-prepare(

              'for each  _AreaExtent ~n'
            + '    where _AreaExtent._Area-Number = dynamic-function( "pro_getBufferFieldValue", "' + string( hAreaNumberFld ) + '" ) ~n'
            + '    use-index _AreaExtent-Area ~n'
            + '    no-lock.' ).



        run fillStFile( pcStFile ).

        i = 0.
        for each ttStArea:
            i = i + 1.
        end.

        hAreaQuery:query-open( ).

        j = 0.
        repeat while hAreaQuery:get-next( ).
            j = j + 1.
        end.

        hAreaQuery:query-close( ).

        if i <> j then
            {slib/err_return}.



        hAreaQuery:query-open( ).

        repeat while hAreaQuery:get-next( ).

            find first ttStArea
                 where ttStArea.cAreaType   = 

                    ( if hAreaTypeFld:buffer-value = 3 then "b" else 
                    ( if hAreaTypeFld:buffer-value = 4 then "t" else
                    ( if hAreaTypeFld:buffer-value = 6 then "d" else
                    ( if hAreaTypeFld:buffer-value = 7 then "a" else ? ) ) ) )

                   and ttStArea.iAreaNum    =
                   
                    ( if hAreaTypeFld:buffer-value = 6 then hAreaNumberFld:buffer-value else ? )

                 use-index TypeNum
                 no-error.

            if not avail ttStArea then
                {slib/err_return}.

            if ttStArea.cAreaType = "d" then do:

                if ttStArea.iAreaRpm <> exp( 2, hAreaRecBitsFld:buffer-value ) then
                    {slib/err_return}.

            &if {&pro_xProversion} >= "10" &then
                if ttStArea.iAreaBpc <> hAreaClusterSizeFld:buffer-value then
                    {slib/err_return}.
            &endif

            end. /* cAreaType = "d" */

            if ttStArea.iExtentCnt <> hAreaExtentsFld:buffer-value then
                {slib/err_return}.



            hExtentQuery:query-open( ).

            repeat while hExtentQuery:get-next( ):

                find first ttStExtent
                     where ttStExtent.cAreaType     = ttStArea.cAreaType
                       and ttStExtent.iAreaNum      = ttStArea.iAreaNum
                       and ttStExtent.iExtentNum    = hExtentNumberFld:buffer-value
                     use-index AreaExtent
                     no-error.

                if not avail ttStExtent then
                    {slib/err_return}.

                if ttStExtent.cExtentType <>

                ( if ttStArea.cAreaType = "b" then ( if hExtentTypeFld:buffer-value = 38 then "f" else "v" ) else
                ( if ttStArea.cAreaType = "t" then ( if hExtentTypeFld:buffer-value = 39 then "f" else "v" ) else
                ( if ttStArea.cAreaType = "d" then ( if hExtentTypeFld:buffer-value = 37 then "f" else "v" ) else
                ( if ttStArea.cAreaType = "a" then ( if hExtentTypeFld:buffer-value = 36 then "f" else "v" ) else ? ) ) ) ) then

                    {slib/err_return}.

                if  ttStExtent.cExtentType = "f"
                and ttStExtent.iExtentSize <> hExtentSizeFld:buffer-value then 
                    {slib/err_return}.

            end. /* repeat */

            hExtentQuery:query-close( ).

        end. /* repeat */

        hAreaQuery:query-close( ).

        plOk = yes.

    {slib/err_finally}:

        os-delete value( cOutFile ).

        disconnect value( pbDb.cLDbName ) no-error.
        
    {slib/err_end}.

end procedure. /* compareStFile */



procedure setBusy:

    define var cArchiveLkFile   as char no-undo.
    define var lArchiveLkFile   as log no-undo.
    define var cRestoreLkFile   as char no-undo.
    define var lMsg             as log no-undo.

    {slib/err_try}:

        assign
            cArchiveLkFile  = os_normalizePath( cDbSetArchiveRootDir + "/archive.lk" )
            cRestoreLkFile  = os_normalizePath( cDbSetArchiveRootDir + "/restore.lk" ).

        file-info:file-name = cRestoreLkFile.

        if  file-info:full-pathname <> ?
        and date_getTimeInterval( today, time, file-info:file-mod-date, file-info:file-mod-time ) > {&xRestoreLkTimeout} then

            os-delete value( cRestoreLkFile ).

        file-info:file-name = cArchiveLkFile.

        if  file-info:full-pathname <> ?
        and date_getTimeInterval( today, time, file-info:file-mod-date, file-info:file-mod-time ) > {&xArchiveLkTimeout} then

            os-delete value( cArchiveLkFile ).



        etime( yes ).

        lMsg = no.

        repeat:
        
            assign
                lArchiveLkFile = os_isFileExists( cArchiveLkFile ).

            if not lArchiveLkFile then
                leave.

            if not lMsg then do:

                run log_writeMessage( "stLog", "Restore waiting for archive to complete." ).
                lMsg = yes.

            end. /* not lMsg */

            if lArchiveLkFile and etime( no ) > {&xArchiveWaitTimeout} * 1000 then
                {slib/err_throw "'error'" "'Restore timed out waiting for archive to complete.'"}.

            pause 5.

        end. /* repeat */

        if os_isFileExists( cRestoreLkFile ) then
            {slib/err_throw "'error'" "'Restore is already running.'"}.

        output to value( cRestoreLkFile ).
        output close.

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* setBusy */

procedure setAvail:

    os-delete value( os_normalizePath( cDbSetArchiveRootDir + "/restore.lk" ) ).

end procedure. /* setAvail */



procedure sendErrorReport:

    define buffer ttDb for ttDb.

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
        cLogFileList            = os_normalizePath( cDbSetArchiveRootDir + "/restore.lg" )

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



    for each ttDb:

        cLogFile = os_getSubPath( ttDb.cPDbName, "dir", "file" ) + ".lg".

        if os_isFileExists( cLogFile ) then do:

            cTempFile = os_getTempFile( ?, ".lg" ).

            run os_tail(
                input cLogFile,
                input cTempFile,
                input 100 ).

            assign
                cAttachmentLocalList = cAttachmentLocalList
                    + ( if cAttachmentLocalList <> "" then "," else "" )
                    + cTempFile

                cAttachmentList = cAttachmentList
                    + ( if cAttachmentList <> "" then "," else "" )
                    + os_getSubPath( cLogFile, "file", "ext" ) + ":type=text/plain:charset=US-ASCII:filetype=ASCII".

        end. /* os_isFileExists( cLogFile ) */

    end. /* each ttDb */



    run slib/smtpmail.p (
        input   cMailHub,                               /* Mail Hub */
        input   cMailTo,                                /* Mail To */
        input   cMailFrom,                              /* Mail From */
        input   "",                                     /* CC comma separated */
        input   cAttachmentList,                        /* Attachments comma separated */
        input   cAttachmentLocalList,                   /* Attachment local files comma separated */
        input   "RESTORE ENCOUNTERED ERRORS",           /* Subject */
        input   "Restore process encountered errors.~n"
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
