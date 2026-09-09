
/**
 * backup.p -
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

{slib/sliblog.i}

{slib/slibos.i}

&if "{&opsys}" begins "win" &then

    {slib/slibwin.i}

&else

    {slib/slibunix.i}

&endif

{slib/slibdate.i}

{slib/slibmath.i}

{slib/slibstr.i}

{slib/slibpro.i}

{slib/sliberr.i}



&global xIncOverlap         1

&global xBackupLkTimeout    82800   /* 23 * 60 * 60 */
&global xAimageLkTimeout    3600    /* 60 * 60 */
&global xAimageWaitTimeout  900     /* 15 * 60 */
&global xArchiveLkTimeout   82800   /* 23 * 60 * 60 */
&global xArchiveWaitTimeout 900     /* 15 * 60 */

&if "{&opsys}" begins "win" &then

    &global xCmdFullBackupOnline    '_mprshut "%pdbname%" -C backup online "%bakfile%" %enableai% -com -red 5 -Bp 100 -verbose'
    &global xCmdIncBackupOnline     '_mprshut "%pdbname%" -C backup online incremental "%bakfile%" -io %ioverlap% -com -red 5 -Bp 100 -verbose' 
    &global xCmdFullBackupOffline   '_dbutil probkup "%pdbname%" "%bakfile%" -com -red 5 -Bp 100 -verbose'
    &global xCmdIncBackupOffline    '_dbutil probkup "%pdbname%" incremental "%bakfile%" -io %ioverlap% -com -red 5 -Bp 100 -verbose'
    &global xCmdAiExtract           'call rfutil "%pdbname%" -C aimage extract -a "%aifile%" -o "%bakfile%"'
    &global xCmdAiEmpty             'call rfutil "%pdbname%" -C aimage extent empty "%aifile%"'
    &global xCmdAiList              'call rfutil "%pdbname%" -C aimage extent list > "%logfile%"'
    &global xCmdStList              'call prostrct list "%pdbname%"'

&else

    &global xCmdFullBackupOnline    '_mprshut "%pdbname%" -C backup online "%bakfile%" %enableai% -com -red 5 -Bp 100 -verbose'
    &global xCmdIncBackupOnline     '_mprshut "%pdbname%" -C backup online incremental "%bakfile%" -io %ioverlap% -com -red 5 -Bp 100 -verbose' 
    &global xCmdFullBackupOffline   '_dbutil probkup "%pdbname%" "%bakfile%" -com -red 5 -Bp 100 -verbose'
    &global xCmdIncBackupOffline    '_dbutil probkup "%pdbname%" incremental "%bakfile%" -io %ioverlap% -com -red 5 -Bp 100 -verbose'
    &global xCmdAiExtract           'rfutil "%pdbname%" -C aimage extract -a "%aifile%" -o "%bakfile%"'
    &global xCmdAiEmpty             'rfutil "%pdbname%" -C aimage extent empty "%aifile%"'
    &global xCmdAiList              'rfutil "%pdbname%" -C aimage extent list > "%logfile%"'
    &global xCmdStList              'prostrct list "%pdbname%"'

&endif



define temp-table ttDb no-undo

    field iDbNum        as int
    field cLDbName      as char
    field cPDbName      as char
    field cPort         as char
    field dSize         as dec
    field lOffline      as log
    field lAiEnabled    as log
    field lAiExists     as log
    field tLastBakDate  as date
    field iLastBakTime  as int
    field lLastBakFail  as log
    field lFullBak      as log
    field iIbSeq        as int

    field cBakRootDir   as char
    field cLastBakDir   as char
    field cCurrBakDir   as char

    field cBusyFullPath as char
    field iBusySeqno    as int

    index iDbNum is primary unique
          iDbNum

    index cLDbName is unique
          cLDbName.

define temp-table ttAi no-undo

    field cFileName     as char
    field cFullPath     as char 
    field cStatus       as char 
    field iSeqno        as int
    field iExt          as int

    index iExt is primary unique 
          iExt.

define temp-table ttBakDat no-undo

    field tDate         as date
    field iTime         as int
    field cType         as char
    field iIbSeq        as int
    
    index DateTime is primary unique
          tDate
          iTime.

define temp-table ttBakDir no-undo

    field cFullPath     as char
    field cDir          as char
    field cType         as char

    index cFullPath is primary unique
          cFullPath.

define var cDbSetName       as char no-undo.
define var cDbSetBakRootDir as char no-undo.
define var iBakFullDay      as int no-undo.
define var iWeekDay         as int no-undo.
define var lEnableAi        as log no-undo.
define var cLogFile         as char no-undo.

define var cMailHub         as char no-undo.
define var cMailFrom        as char no-undo.
define var cMailTo          as char no-undo.

define var lError           as log no-undo.



run preinitializeProc.

run setBusy.

{slib/err_try}:

    run initializeProc.

    run log_writeMessage( "stLog", " - " ).
    run log_writeMessage( "stLog", "Set " + cDbSetName + " backup started." ).

    for each ttDb:

        {slib/err_try}:

            run log_writeMessage( "stLog", "Database " + ttDb.cLDbName + " backup started." ).

            run backupFullAi    ( buffer ttDb ).
            run backupDb        ( buffer ttDb ).
            run backupBusyAi    ( buffer ttDb ).

            run log_writeMessage( "stLog", "Database " + ttDb.cLDbName + " backup completed successfully." ).

        {slib/err_end}.

    end. /* each ttDb */

    if lError then do:

        run log_writeMessage( "stLog", "** Set " + cDbSetName + " backup completed with errors (" +
            date_Date2Str( today, 0, 0, "www mmm d, yyyy" ) + ")." ).

        {slib/err_throw "'error'"}.

    end. /* lError */

    else do:

        run log_writeMessage( "stLog", "Set " + cDbSetName + " backup completed successfully (" +
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

    define var cBakFullDay as char no-undo.
    define var cEnableAi   as char no-undo.

    {slib/err_try}:

        assign
           lError           = no

           cDbSetBakRootDir = trim( os-getenv( "BAK_ROOT_DIR" ) ).

        if cDbSetBakRootDir = "" then cDbSetBakRootDir = ?.

        if cDbSetBakRootDir = ? then
            {slib/err_throw "'os_envvar_is_empty'" "'BAK_ROOT_DIR'"}.

        if not os_isDirExists( cDbSetBakRootDir ) then
             run os_createDir( cDbSetBakRootDir ).

        cLogFile = os_normalizePath( cDbSetBakRootDir + "/backup.lg" ).

        run log_openLogFile ( "stLog", cLogFile, ? ).
        run log_directErrors( "stLog" ).



        assign
           cDbSetName       = trim( os-getenv( "DB_SET_NAME" ) )
           cBakFullDay      = trim( os-getenv( "BAK_FULL_DAY" ) )
           cEnableAi        = trim( os-getenv( "ENABLEAI" ) )

           cMailHub         = trim( os-getenv( "MAIL_HUB" ) )
           cMailTo          = trim( os-getenv( "MAIL_TO" ) )
           cMailFrom        = trim( os-getenv( "MAIL_FROM" ) ).

        if cDbSetName       = "" then cDbSetName = ?.
        if cBakFullDay      = "" then cBakFullDay = ?.

        if cMailHub         = "" then cMailHub = ?.
        if cMailTo          = "" then cMailTo = ?.
        if cMailFrom        = "" then cMailFrom = ?.

        assign
           iBakFullDay = ?
           iBakFullDay = int( cBakFullDay ) no-error.

        /* note that an IbakFullDay that is not 1-7 is sometimes used
           to force an incremental backup */

        if iBakFullDay = ? then
           iBakFullDay = 7.

        if cEnableAi = "1"
        or cEnableAi = "yes"
        or cEnableAi = "true" then
           lEnableAi = yes.
        else
           lEnableAi = no.

        if cMailHub = ? then
           cMailHub = "localhost:25".

        if cMailFrom = ? then
           cMailFrom = "backup@alonblich.com".

        if cDbSetName = ? then
            {slib/err_throw "'os_envvar_is_empty'" "'DB_SET_NAME'"}.

        iWeekDay = weekday( today ).



        run preinitializeDb.

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* preinitializeProc */

procedure preinitializeDb:

    define buffer ttDb      for ttDb.
    define buffer ttBakDir  for ttBakDir.

    define var iDbNum       as int no-undo.
    define var cDbName      as char no-undo.
    define var cDbValue     as char no-undo.
    define var lDbFound     as log no-undo.

    define var cLDbName     as char no-undo.
    define var cPDbName     as char no-undo.
    define var cPort        as char no-undo.

    define var cBakRootDir  as char no-undo.
    define var cLastBakDir  as char no-undo.

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
        
                if not os_isFileExists( cPDbName ) then
                    {slib/err_throw "'error'" "'Database ' + cPDbName + ' does not exist.'"}.
        
                if can-find( first ttDb where ttDb.cLDbName = cLDbName ) then
                    {slib/err_throw "'error'" "'Logical database ' + cLDbName + ' already exists. Add a comma to the physical database name to specify a different logical database name.'"}.



                cBakRootDir = os_normalizePath( cDbSetBakRootDir + "/" + cLDbName ).
        
                if not os_isDirExists( cBakRootDir ) then
                     run os_createDir( cBakRootDir ).
        
                run fillBakDir( cBakRootDir ).

                cLastBakDir = ?.

                find last ttBakDir
                     use-index cFullPath
                     no-error.

                if avail ttBakDir then

                    cLastBakDir = ttBakDir.cFullPath.



                create ttDb.
                assign
                    ttDb.iDbNum         = iDbNum
                    ttDb.cLDbName       = cLDbName
                    ttDb.cPDbName       = cPDbName
                    ttDb.cPort          = cPort
                    ttDb.dSize          = dSize
                    ttDb.lOffline       = ?
                    ttDb.lAiEnabled     = ?
                    ttDb.lAiExists      = ?
                    ttDb.tLastBakDate   = ?
                    ttDb.iLastBakTime   = ?
                    ttDb.lLastBakFail   = ?
                    ttDb.lFullBak       = no
                    ttDb.iIbSeq         = 0

                    ttDb.cBakRootDir    = cBakRootDir
                    ttDb.cLastBakDir    = cLastBakDir
                    ttDb.cCurrBakDir    = ?

                    ttDb.cBusyFullPath  = ?
                    ttDb.iBusySeqno     = ?.

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

    define var dTotSize     as dec no-undo.
    define var dTotalSpace  as dec no-undo.
    define var dFreeSpace   as dec no-undo.
    define var dUsedSpace   as dec no-undo.

    {slib/err_try}:

        run initializeDb.



        for each  ttDb
            where ttDb.cLastBakDir <> ?:

            run os_fillFile(
                input   ttDb.cLastBakDir,
                input   "p.....tmp.bak",
                output  table os_ttFile ).

            if can-find( first os_ttFile ) then do:
    
                run os_deleteDir( ttDb.cLastBakDir ).
    
                run fillBakDir( ttDb.cBakRootDir ).

                find last  ttBakDir
                     where ttBakDir.cFullPath < ttDb.cLastBakDir
                     use-index cFullPath
                     no-error.

                assign
                    ttDb.cLastBakDir = ( if avail ttBakDir then ttBakDir.cFullPath else ? ).
    
            end. /* can-find */

        end. /* each ttDb */



        dTotSize = 0.

        for each ttDb:
            dTotSize = dTotSize + ttDb.dSize.
        end.

        dTotSize = 1.2 * dTotSize.

        run os_getDiskFreeSpace(
            input   cDbSetBakRootDir,
            output  dTotalSpace,
            output  dFreeSpace,
            output  dUsedSpace ).

        if dFreeSpace < dTotSize then
            {slib/err_throw "'os_insufficient_disk_space'" cDbSetBakRootDir "trim( string( dTotSize, '>>>,>>>,>>>,>>>,>>>,>>9' ) )" }.

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* initializeProc */

procedure initializeDb:

    define buffer ttDb for ttDb.

    define var dSize            as dec no-undo.
    define var lOffline         as log no-undo.
    define var lAiEnabled       as log no-undo.
    define var lAiExists        as log no-undo.
    define var tLastBakDate     as date no-undo.
    define var iLastBakTime     as int no-undo.
    define var lLastBakFail     as log no-undo.

    define var hQuery           as handle no-undo.
    define var hDbStatusBuff    as handle no-undo.
    define var hAreaBuff        as handle no-undo.
    define var hAreaStatusBuff  as handle no-undo.
    define var hAreaExtentBuff  as handle no-undo.
    define var hLoggingBuff     as handle no-undo.

    define var hFbDate          as handle no-undo.
    define var hIbDate          as handle no-undo.
    define var hHiwaterFld      as handle no-undo.
    define var hBlocksizeFld    as handle no-undo.
    define var hExtentpathFld   as handle no-undo.
    define var hAreaType        as handle no-undo.
    define var hAiGenNumFld     as handle no-undo.

    define var tDate            as date no-undo.
    define var iMTime           as int no-undo.
    define var iTimeZone        as int no-undo.

    define var cFileName        as char no-undo.
    define var cFullPath        as char no-undo.
    define var cAttrList        as char no-undo.
    define var dFileSize        as dec no-undo.
    define var i                as int no-undo.

    create widget-pool.

    {slib/err_try}:

        for each ttDb:

            {slib/err_try}:

                assign
                    lOffLine        = no
                    lLastBakFail    = no.

                if os_isFileExists( os_getSubPath( ttDb.cPDbName, "dir", "file" ) + ".lk" ) then do:

                    connect value( '-db "' + ttDb.cPDbName + '" -ld "' + ttDb.cLDbName + '"' + ( if ttDb.cPort <> ? then ' -S ' + ttDb.cPort else '' ) ) no-error.

                    do i = 1 to error-status:num-messages:

                        case error-status:get-number(i):

                            when 1423 then do:

                                {slib/err_throw "'db_conn_failed_single_user'" "'Database ' + ttDb.cPDbName + ' is in single-user mode. Unable to connect.'"}.
                            
                            end. /* when 1443 */
                        
                            when 1553 then do:

                                lLastBakFail = yes.
                                leave.

                            end. /* when 1553 */
                        
                        end case. /* error-status */

                    end. /* 1 to num-messages */

                    if error-status:error then
                        {slib/err_throw-error-status}.

                end. /* os_isFileExist( ".lk" ) */

                else do:

                    connect value( '-db "' + ttDb.cPDbName + '" -ld "' + ttDb.cLDbName + '" -RO' ) no-error.

                    do i = 1 to error-status:num-messages:

                        if error-status:get-number(i) = 1553 then do:

                            lLastBakFail = yes.
                            leave.

                        end. /* get-number( ) = 1553 */

                    end. /* 1 to num-messages */

                    if error-status:error then
                        {slib/err_throw-error-status}.

                    lOffline = yes.

                end. /* else */

                if not connected( ttDb.cLDbName ) then
                    {slib/err_throw "'db_conn_failed'" ttDb.cPDbName}.



                create buffer hAreaBuff         for table cLDbName + "._Area".
                create buffer hAreaStatusBuff   for table cLDbName + "._AreaStatus".
                create buffer hAreaExtentBuff   for table cLDbName + "._AreaExtent".
                create buffer hLoggingBuff      for table cLDbName + "._Logging".
                create buffer hDbStatusBuff     for table cLDbName + "._DbStatus".

                assign
                    hBlockSizeFld   =       hAreaBuff:buffer-field( "_Area-blocksize" )
                    hHiWaterFld     = hAreaStatusBuff:buffer-field( "_AreaStatus-Hiwater" )
                    hExtentPathFld  = hAreaExtentBuff:buffer-field( "_Extent-path" )
                    hAreaType       =       hAreaBuff:buffer-field( "_Area-type")
                    hAiGenNumFld    =    hLoggingBuff:buffer-field( "_Logging-AiGenNum" )
                    hFbDate         =   hDbStatusBuff:buffer-field( "_DbStatus-fbDate" )
                    hIbDate         =   hDbStatusBuff:buffer-field( "_DbStatus-ibDate" ) {slib/err_no-error}.



                create query hQuery.

                hQuery:set-buffers( hAreaBuff, hAreaStatusBuff ).
                hQuery:query-prepare(

                      "for each  " + ttDb.cLDbName + "._Area ~n"
                    + "    no-lock, ~n"

                    + "    first " + ttDb.cLDbName + "._AreaStatus ~n" 
                    + "    where " + ttDb.cLDbName + "._AreaStatus._AreaStatus-Areanum = " + ttDb.cLDbName + "._Area._Area-number ~n"
                    + "    no-lock ~n" ) {slib/err_no-error}.

                hQuery:query-open( ) {slib/err_no-error}.
        
                assign
                    dSize     = 0
                    lAiExists = no.

                repeat while hQuery:get-next( ):
        
                    if    hHiWaterFld:buffer-value <> ? 
                    and hBlockSizeFld:buffer-value <> ? then
        
                        dSize = dSize + hHiWaterFld:buffer-value * hBlockSizeFld:buffer-value.
                   
                    if hAreaType:buffer-value = 7 then

                        lAiExists = yes.        

                end. /* hQuery:get-next( ) */
        
                hQuery:query-close( ).

        

                create query hQuery.

                hQuery:set-buffers( hAreaBuff, hAreaStatusBuff, hAreaExtentBuff ).
                hQuery:query-prepare(

                      "for each  " + ttDb.cLDbName + "._Area ~n"
                    + "    no-lock, ~n"

                    + "    first " + ttDb.cLDbName + "._AreaStatus ~n" 
                    + "    where " + ttDb.cLDbName + "._AreaStatus._AreaStatus-Areanum = " + ttDb.cLDbName + "._Area._Area-number ~n"
                    + "    no-lock, ~n"

                    + "    each  " + ttDb.cLDbName + "._AreaExtent ~n"
                    + "    where " + ttDb.cLDbName + "._AreaExtent._Area-number = " + ttDb.cLDbName + "._Area._Area-number ~n"
                    + "    no-lock" ) {slib/err_no-error}.

                hQuery:query-open( ) {slib/err_no-error}.
        
                repeat while hQuery:get-next( ):
                
                    if   hHiWaterFld:buffer-value = ? 
                    or hBlockSizeFld:buffer-value = ? then do:

                        file-info:file-name = hExtentPathFld:buffer-value. /* incase the database and extents are relative path e.g. ".\sports2000.db" */
                        if file-info:full-pathname <> ? then do:
                            
                            dFileSize = os_getBigFileSize( file-info:full-pathname ).
                            if dFileSize <> ? then

                                dSize = dSize + dFileSize.

                        end. /* os_isFileExists */
        
                    end. /* Hiwater = ? or Blocksize = ? */
        
                end. /* hQuery:get-next( ) */
        
                hQuery:query-close.
        


                lAiEnabled = no.

                hLoggingBuff:find-first( "", no-lock ).

                if  hLoggingBuff:avail
                and hAiGenNumFld:buffer-value <> 0 then

                    lAiEnabled = yes.



                assign
                    tLastBakDate = ?
                    iLastBakTime = ?.

                if not lLastBakFail then do:

                    hDbStatusBuff:find-first( "", no-lock ).

                    if hFbDate:buffer-value <> "" and hFbDate:buffer-value <> ? then do:

                        run date_Str2Date( str_trimMultipleSpace( hFbDate:buffer-value ), "www mmm d hh:ii:ss yyyy", output tDate, output iMTime, output iTimeZone ).
                        if tDate <> ? and iMTime <> ? then do:

                            assign
                                tLastBakDate = tDate
                                iLastBakTime = iMTime / 1000.

                            if hIbDate:buffer-value <> "" and hIbDate:buffer-value <> ? then do:

                                run date_Str2Date( str_trimMultipleSpace( hIbDate:buffer-value ), "www mmm d hh:ii:ss yyyy", output tDate, output iMTime, output iTimeZone ).
                                if tDate <> ? and iMTime <> ? then do:

                                    if tDate > tLastBakDate
                                    or tDate = tLastBakDate and iMTime / 1000 > iLastBakTime then

                                    assign
                                        tLastBakDate = tDate
                                        iLastBakTime = iMTime / 1000.

                                end. /* tDate <> ? */

                            end. /* ibDate <> ? */

                        end. /* tDate <> ? */

                    end. /* fbdate <> ? */

                end. /* not lLastBakFail */



                assign
                    ttDb.dSize          = dSize
                    ttDb.lOffline       = lOffline
                    ttDb.lAiEnabled     = lAiEnabled
                    ttDb.lAiExists      = lAiExists
                    ttDb.tLastBakDate   = tLastBakDate
                    ttDb.iLastBakTime   = iLastBakTime
                    ttDb.lLastBakFail   = lLastBakFail.

            {slib/err_catch}:

                run log_writeMessage( "stLog", "Backup of database " + ttDb.cLDbName + " cancelled." ).

                delete ttDb.

                lError = yes.

            {slib/err_finally}:

                disconnect value( ttDb.cLDbName ) no-error.

            {slib/err_end}.
    
        end. /* each ttDb */

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* initializeDb */

procedure closeProc:

    run log_closeLogFile( "stLog" ).

    run os_deleteTempFiles( cDbSetBakRootDir, ? ).
    run os_deleteTempFiles( ?, ? ).

end procedure. /* closeProc */



procedure backupDb:

    define param buffer pbDb for ttDb.

    define buffer ttAi      for ttAi.
    define buffer ttBakDat  for ttBakDat.

    define var cBakTempFile as char no-undo.
    define var cBakFile     as char no-undo.

    define var cSrcStFile   as char no-undo.
    define var cTrgStFile   as char no-undo.
    define var cEnableAi    as char no-undo.

    define var cCmd         as char no-undo.
    define var i            as int no-undo.

    {slib/err_try}:

        run fillBakDat( buffer pbDb ).

        if pbDb.lLastBakFail then
        
            pbDb.lFullBak = yes.

        else
        if not can-find(
            first ttBakDat
            where ttBakDat.cType = "full" ) then

            pbDb.lFullBak = yes.

        else
        if iWeekDay = iBakFullDay
        
        and not can-find(
            first ttBakDat
            where ttBakDat.cType = "full"
              and ttBakDat.tDate = today ) then

            pbDb.lFullBak = yes.

        else
        if iWeekDay <> iBakFullDay
        
        and not can-find(
            first ttBakDat
            where ttBakDat.cType = "full"
              and ttBakDat.tDate > today - 10 ) then

            pbDb.lFullBak = yes.
        
        else do:
        
            find last ttBakDat
                 use-index DateTime
                 no-error.

            if    avail ttBakDat
            and ( ttBakDat.tDate <> pbDb.tLastBakDate
               or ttBakDat.iTime <> pbDb.iLastBakTime ) then

            pbDb.lFullBak = yes.

        end. /* else */



        if not pbDb.lFullBak then do:

            find last  ttBakDat
                 where ttBakDat.cType = "inc"
                 use-index DateTime
                 no-error.

            if avail ttBakDat then
                 pbDb.iIbSeq = ttBakDat.iIbSeq + 1.
            else pbDb.iIbSeq = 1.

        end. /* not pbDb.lFullBak */



        pbDb.cCurrBakDir = os_normalizePath(

              pbDb.cBakRootDir + "/bak-" + date_Date2Str( today, time * 1000, 0, "yyyy-mm-dd~~thh-ii-ss" ) 
            + "-" + ( if pbDb.lFullBak then "full" else "inc" + string( pbDb.iIbSeq, "999" ) ) ).

        run os_createDir( pbDb.cCurrBakDir ).

        if pbDb.lAiEnabled then do:

            run verifyEmptyAi   ( buffer pbDb ).
            run fillAi          ( buffer pbDb ).
    
            find first ttAi
                 where ttAi.cStatus = "busy"
                 no-error.

            if avail ttAi then
            assign
                pbDb.cBusyFullPath  = ttAi.cFullPath
                pbDb.iBusySeqno     = ttAi.iSeqno.

        end. /* lAiEnabled */



        &if "{&opsys}" begins "win" &then

            run win_batch(
                input 'proenv ~n'
                    + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                    + replace( {&xCmdStList}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ),
                input 'wait' ).

            if win_iErrorLevel <> 0 then
                {slib/err_throw "'error'" "'Unable to create database .st file.'"}.

        &else

            run unix_shell(
                input 'proenv ~n'
                    + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                    + replace( {&xCmdStList}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ),
                input 'wait' ).
            
            if unix_iExitCode <> 0 then
                {slib/err_throw "'error'" "'Unable to create database .st file.'"}.

        &endif

        assign
            cSrcStFile = os_getSubPath( pbDb.cPDbName, "dir", "file" ) + ".st"
            cTrgStFile = os_normalizePath( pbDb.cCurrBakDir + "/bak.st" ).

        if not os_isFileExists( cSrcStFile ) then
            {slib/err_throw "'error'" "'Unable to create database .st file.'"}.

        os-copy value( cSrcStFile ) value( cTrgStFile ).

        if not os_isFileExists( cTrgStFile ) then
            {slib/err_throw "'file_copy_failed'" cSrcStFile cTrgStFile}.

        

        run log_writeMessage( "stLog", ( if pbDb.lFullBak then "Full" else "Incremental" ) + ( if pbDb.lOffline then " offline" else " online" ) + " backup started." ).

        assign
            cBakTempFile    = os_normalizePath( pbDb.cCurrBakDir + "/" 
                + os_getSubPath( os_getTempFile( "", ".bak" ), "file", "ext" ) )

            cBakFile        = os_normalizePath( pbDb.cCurrBakDir + "/bak-"
                + ( if pbDb.lFullBak then "full" else "inc" ) + ".bak" ).

        os-delete value( cBakTempFile ).
        os-delete value( cBakFile ).

        if pbDb.lOffline then do:

            if pbDb.lFullBak then 
                 cCmd = {&xCmdFullBackupOffline}.
            else cCmd = {&xCmdIncBackupOffline}.

        end. /* lOffline */

        else do:

            if pbDb.lFullBak then
                 cCmd = {&xCmdFullBackupOnline}.
            else cCmd = {&xCmdIncBackupOnline}.

        end. /* else */

        if  lEnableAi
        and not pbDb.lOffline
        and pbDb.lFullBak
        and pbDb.lAiExists
        and not pbDb.lAiEnabled then
            cEnableAi = "enableai".
        else
            cEnableAi = "".

        {slib/err_try}:
        
        &if "{&opsys}" begins "win" &then

            run win_batch(
                input 'proenv ~n'
                    + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                    + replace( replace( replace( replace( cCmd, "%ioverlap%", "{&xIncOverlap}" ), "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%bakfile%", cBakTempFile ), "%enableai%", cEnableAi),
                input 'wait' ).

            if win_iErrorLevel <> 0 then
                {slib/err_throw "'error'" "'probkup ' + pbDb.cLDbName + ' returned exitcode ' + string( win_iErrorLevel ) + '.'"}.
                    
        &else

            run unix_shell(
                input 'proenv ~n'
                    + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                    + replace( replace( replace( replace( cCmd, "%ioverlap%", "{&xIncOverlap}" ), "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%bakfile%", cBakTempFile ), "%enableai%", cEnableAi),
                input 'wait' ).
            
            if unix_iExitCode <> 0 then
                {slib/err_throw "'error'" "'probkup ' + pbDb.cLDbName + ' returned exitcode ' + string( unix_iExitCode ) + '.'"}.

        &endif

        {slib/err_catch}:

            lError = yes.

        {slib/err_end}.

        if not os_isFileExists( cBakTempFile ) then
            {slib/err_throw "'error'" "'Backup of database ' + pbDb.cLDbName + ' failed (file ' + cBakTempFile + ' not found).'"}.

        os-rename value( cBakTempFile ) value( cBakFile ).

        if not os_isFileExists( cBakFile ) then
            {slib/err_throw "'file_rename_failed'" cBakTempFile cBakFile}.

        run log_writeMessage( "stLog", ( if pbDb.lFullBak then "Full" else "Incremental" ) + ( if pbDb.lOffline then " offline" else " online" ) + " backup completed successfully." ).



        run saveBakDat( buffer pbDb ).

    {slib/err_catch}:

        if pbDb.cCurrBakDir <> ? and os_isDirExists( pbDb.cCurrBakDir ) then
            run os_deleteDir( pbDb.cCurrBakDir ).

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.
       
end procedure. /* backupDb */

procedure backupFullAi:

    define param buffer pbDb for ttDb.

    define buffer ttAi for ttAi.

    define var cBakTempFile as char no-undo.
    define var cBakFile     as char no-undo.

    if not pbDb.lAiEnabled then
        return.
    
    {slib/err_try}:

        run fillAi( buffer pbDb ).
        
        for each  ttAi
            where ttAi.cStatus = "full":
            
            if pbDb.cLastBakDir <> ? then do:

                assign
                    cBakTempFile    = os_normalizePath( pbDb.cLastBakDir + "/"
                        + os_getSubPath( os_getTempFile( "", ".ai" ), "file", "ext" ) )

                    cBakFile        = os_normalizePath( pbDb.cLastBakDir + "/aimage" 
                        + string( ttAi.iSeqno, "999999" ) + ".ai" ).

                os-delete value( cBakTempFile ).
                os-delete value( cBakFile ).

                if pro_CFullProversion >= "09.1D09" then do:

                    &if "{&opsys}" begins "win" &then
            
                        run win_batch(
                            input 'proenv ~n'
                                + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                                + replace( replace( replace( {&xCmdAiExtract}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%aifile%" , ttAi.cFullPath ), "%bakfile%", cBakTempFile ),
                            input 'wait' ).
            
                        if win_iErrorLevel <> 0 then 
                            {slib/err_throw "'error'" "'Unable to extract aimage ' + string( ttAi.iSeqno ) + '.'"}.
    
                    &else
            
                        run unix_shell(
                            input 'proenv ~n'
                                + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                                + replace( replace( replace( {&xCmdAiExtract}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%aifile%" , ttAi.cFullPath ), "%bakfile%", cBakTempFile ),
                            input 'wait' ).
            
                        if unix_iExitCode <> 0 then 
                            {slib/err_throw "'error'" "'Unable to extract aimage ' + string( ttAi.iSeqno ) + '.'"}.
            
                    &endif

                end. /* pro_cFullProversion >= "09.1D09" */
                
                else do:
                
                    os-copy value(  ttAi.cFullPath ) value( cBakTempFile ).
                
                end. /* else */
                
                if not os_isFileExists( cBakTempFile ) then
                    {slib/err_throw "'error'" "'Unable to extract aimage ' + string( ttAi.iSeqno ) + '.'"}.

                os-rename value( cBakTempFile ) value( cBakFile ).

                if not os_isFileExists( cBakFile ) then
                    {slib/err_throw "'file_rename_failed'" cBakTempFile cBakFile}.

                run log_writeMessage( "stLog", "Aimage " + string( ttAi.iSeqno ) + " backup completed successfully." ).

            end. /* cLastBakDir <> ? */
    
    
    
            &if "{&opsys}" begins "win" &then
    
                run win_batch(
                    input 'proenv ~n'
                        + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                        + replace( replace( {&xCmdAiEmpty}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%aifile%", ttAi.cFullPath ),
                    input 'silent,wait' ).
    
                if win_iErrorLevel <> 0 then
                    {slib/err_throw "'error'" "'Unable to empty aimage ' + string( ttAi.iSeqno ) + '.'"}.
    
            &else
            
                run unix_shell(
                    input 'proenv ~n'
                        + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                        + replace( replace( {&xCmdAiEmpty}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%aifile%", ttAi.cFullPath ),
                    input 'silent,wait' ).
                    
                if unix_iExitCode <> 0 then
                    {slib/err_throw "'error'" "'Unable to empty aimage ' + string( ttAi.iSeqno ) + '.'"}.
    
            &endif
    
        end. /* each ttAi */

    {slib/err_catch}:
        
        lError = yes.

    {slib/err_end}.

end procedure. /* backupFullAi */

procedure backupBusyAi:

    define param buffer pbDb for ttDb.

    define buffer ttAi for ttAi.

    define var cBakTempFile as char no-undo.
    define var cBakFile     as char no-undo.
    
    if not pbDb.lAiEnabled then
        return.

    {slib/err_try}:

        if pbDb.cLastBakDir <> ? then do:

            assign
                cBakTempFile    = os_normalizePath( pbDb.cLastBakDir + "/"
                    + os_getSubPath( os_getTempFile( "", ".ai" ), "file", "file" ) )

                cBakFile        = os_normalizePath( pbDb.cLastBakDir
                    + "/aimage" + string( pbDb.iBusySeqno, "999999" ) + ".ai" ).

            os-delete value( cBakTempFile ).
            os-delete value( cBakFile ).
    
            if pro_cFullProversion >= "09.1D09" then do:
    
                &if "{&opsys}" begins "win" &then
            
                    run win_batch(
                        input 'proenv ~n'
                            + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                            + replace( replace( replace( {&xCmdAiExtract}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%aifile%" , pbDb.cBusyFullPath ), "%bakfile%", cBakTempFile ),
                        input 'silent,wait' ).
            
                    if win_iErrorLevel <> 0 then
                        {slib/err_throw "'error'" "'Unable to extract aimage ' + string( pbDb.iBusySeqno ) + '.'"}.
            
                &else
            
                    run unix_shell(
                        input 'proenv ~n'
                            + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                            + replace( replace( replace( {&xCmdAiExtract}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%aifile%" , pbDb.cBusyFullPath ), "%bakfile%", cBakTempFile ),
                        input 'silent,wait' ).
            
                    if unix_iExitCode <> 0 then
                        {slib/err_throw "'error'" "'Unable to extract aimage ' + string( pbDb.iBusySeqno ) + '.'"}.
            
                &endif
            
            end. /* pro_cFullProversion >= "09.1D09" */
            
            else do:
            
                os-copy value( pbDb.cBusyFullPath ) value( cBakTempFile ).
            
            end. /* else */
            
            if not os_isFileExists( cBakTempFile ) then
                {slib/err_throw "'error'" "'Unable to extract aimage ' + string( pbDb.iBusySeqno ) + '.'"}.
    
            os-rename value( cBakTempFile ) value( cBakFile ).

            if not os_isFileExists( cBakFile ) then
                {slib/err_throw "'file_rename_failed'" cBakTempFile cBakFile}.

            run log_writeMessage( "stLog", "Aimage " + string( pbDb.iBusySeqno ) + " backup completed successfully." ).

        end. /* cLastBakDir <> ? */



        &if "{&opsys}" begins "win" &then

            run win_batch(
                input 'proenv ~n'
                    + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                    + replace( replace( {&xCmdAiEmpty}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%aifile%", pbDb.cBusyFullPath ),
                input 'silent,wait' ).

            if win_iErrorLevel <> 0 then
                {slib/err_throw "'error'" "'Unable to empty aimage ' + string( pbDb.iBusySeqno ) + '.'"}.
    
        &else
    
            run unix_shell(
                input 'proenv ~n'
                    + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                    + replace( replace( {&xCmdAiEmpty}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%aifile%", pbDb.cBusyFullPath ),
                input 'silent,wait' ).
        
            if unix_iExitCode <> 0 then
                {slib/err_throw "'error'" "'Unable to empty aimage ' + string( pbDb.iBusySeqno ) + '.'"}.

        &endif

    {slib/err_catch}:

        lError = yes.

    {slib/err_end}.

end procedure. /* backupBusyAi */

procedure verifyEmptyAi:

    define param buffer pbDb for ttDb.

    define buffer ttAi for ttAi.

    define var lEmptyAi     as log no-undo.
    define var i            as int no-undo.

    {slib/err_try}:

        run fillAi( buffer pbDb ).
     
        lEmptyAi = yes.
    
        find first ttAi
             where ttAi.cStatus = "busy"
             use-index iExt
             no-error. 
    
        if avail ttAi then do:

            _loop:

            do i = 1 to 2:
    
                find next ttAi
                     use-index iExt
                     no-error.
        
                if not avail ttAi then
    
                find first ttAi
                     use-index iExt
                     no-error.
    
                if ttAi.cStatus <> "empty" then do:
    
                    lEmptyAi = no.
                    leave _loop.
    
                end. /* cStatus <> "empty" */
    
            end. /* 1 to 2 */
    
        end. /* not avail */
    
    
    
        if not lEmptyAi then do:
    
            for each  ttAi
                where ttAi.cStatus = "full":
                    
                &if "{&opsys}" begins "win" &then
    
                    run win_batch(
                        input 'proenv ~n'
                            + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                            + replace( replace( {&xCmdAiEmpty}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%aifile%", ttAi.cFullPath ),
                        input 'silent,wait' ).
        
                    if win_iErrorLevel <> 0 then
                        {slib/err_throw "'error'" "'Unable to empty aimage ' + string( ttAi.iSeqno ) + '.'"}.
                        
                &else
                
                    run unix_shell(
                        input 'proenv ~n'
                            + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                            + replace( replace( {&xCmdAiEmpty}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%aifile%", ttAi.cFullPath ),
                        input 'silent,wait' ).
        
                    if unix_iExitCode <> 0 then
                        {slib/err_throw "'error'" "'Unable to empty aimage ' + string( ttAi.iSeqno ) + '.'"}.
                    
                &endif
        
                run log_writeMessage( "stLog", "Warning: Aimage " + string( ttAi.iSeqno ) + " had to be emptied without saving to clear space." ).
    
            end. /* each ttAi */
    
        end. /* not lEmptyAi */

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* verifyEmptyAi */



procedure fillBakDat:
    
    define param buffer pbDb for ttDb.

    define buffer ttBakDat for ttBakDat.

    define var cDatFile as char no-undo.
    define var tDate    as date no-undo.
    define var iTime    as int no-undo.
    define var cType    as char no-undo.
    define var iIbSeq   as int no-undo.

    {slib/err_try}:
        
        empty temp-table ttBakDat.
    
        cDatFile = os_normalizePath( pbDb.cBakRootDir + "/backup.d" ).
        
        if os_isFileExists( cDatFile ) then do:
    
            input from value( cDatFile ).
            
                repeat:

                    import delimiter ","
                        tDate
                        iTime
                        cType
                        iIbSeq.

                    if tDate = ? or iTime = ? then
                        {slib/err_throw "'error'"}.
    
                    if cType <> "full" and cType <> "inc" then
                        {slib/err_throw "'error'"}.

                    create ttBakDat.
                    assign
                        ttBakDat.tDate  = tDate
                        ttBakDat.iTime  = iTime
                        ttBakDat.cType  = cType
                        ttBakDat.iIbSeq = iIbSeq.

                end. /* repeat */
                
            input close.
    
        end. /* os_isFileExists */

    {slib/err_catch}:

        empty temp-table ttBakDat.

        os-delete value( cDatFile ).

    {slib/err_end}.

end procedure. /* fillBakDat */

procedure saveBakDat:
    
    define param buffer pbDb for ttDb.

    define buffer ttBakDat for ttBakDat.

    define var tLastBakDate     as date no-undo.
    define var iLastBakTime     as int no-undo.

    define var hDbStatusBuff    as handle no-undo.
    define var hFbDate          as handle no-undo.
    define var hIbDate          as handle no-undo.

    define var cDatFile         as char no-undo.
    define var tDate            as date no-undo.
    define var iMTime           as int no-undo.
    define var iTimeZone        as int no-undo.

    create widget-pool.

    {slib/err_try}:

        if not pbDb.lOffLine then do:

            connect value( '-db "' + pbDb.cPDbName + '" -ld "' + pbDb.cLDbName + '"' + ( if pbDb.cPort <> ? then ' -S ' + pbDb.cPort else '' ) ) {slib/err_no-error-flag}.

        end. /* not lOffLine */

        else do:

            connect value( '-db "' + pbDb.cPDbName + '" -ld "' + pbDb.cLDbName + '" -RO' ) {slib/err_no-error-flag}.

        end. /* else */

        if not connected( pbDb.cLDbName ) then

            {slib/err_throw "'db_conn_failed'" pbDb.cPDbName}.



        create buffer hDbStatusBuff for table pbDb.cLDbName + "._DbStatus".
    
        assign
            hFbDate = hDbStatusBuff:buffer-field( "_DbStatus-fbDate" )
            hIbDate = hDbStatusBuff:buffer-field( "_DbStatus-ibDate" ) {slib/err_no-error}.
        
        assign
            tLastBakDate = ?
            iLastBakTime = ?.
    
        hDbStatusBuff:find-first( "", no-lock ).

        if pbDb.lFullBak then do:
        
            if hFbDate:buffer-value <> "" and hFbDate:buffer-value <> ? then do:
    
                run date_Str2Date( str_trimMultipleSpace( hFbDate:buffer-value ), "www mmm d hh:ii:ss yyyy", output tDate, output iMTime, output  iTimeZone ).
                if tDate <> ? and iMTime <> ? then
    
                assign
                    tLastBakDate = tDate
                    iLastBakTime = iMTime / 1000.
    
            end. /* fbdate <> ? */
    
        end. /* lFullBak */
        
        else do:
        
            if hIbDate:buffer-value <> "" and hIbDate:buffer-value <> ? then do:
    
                run date_Str2Date( str_trimMultipleSpace( hIbDate:buffer-value ), "www mmm d hh:ii:ss yyyy", output tDate, output iMTime, output  iTimeZone ).
                if tDate <> ? and iMTime <> ? then

                assign
                    tLastBakDate = tDate
                    iLastBakTime = iMTime / 1000.
    
            end. /* ibdate <> ? */
    
        end. /* else */



        if pbDb.lFullBak then

            empty temp-table ttBakDat.

        create ttBakDat.
        assign
            ttBakDat.tDate  = tLastBakDate
            ttBakDat.iTime  = iLastBakTime
            ttBakDat.cType  = ( if pbDb.lFullBak then "full" else "inc" )
            ttBakDat.iIbSeq = pbDb.iIbSeq.



        cDatFile = os_normalizePath( pbDb.cBakRootDir + "/backup.d" ).

        output to value( cDatFile ).

            for each ttBakDat

                by ttBakDat.tDate
                by ttBakDat.iTime:

                export delimiter ","

                    ttBakDat.tDate
                    ttBakDat.iTime
                    ttBakDat.cType
                    ttBakDat.iIbSeq.

            end. /* each ttBakDat */

        output close. 

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_finally}:

        disconnect value( pbDb.cLDbName ) no-error.

    {slib/err_end}.

end procedure. /* saveBakDat */



procedure fillAi:
    
    define param buffer pbDb for ttDb.

    define buffer ttAi for ttAi.

    define var cTempFile    as char no-undo.
    define var cFullPath    as char no-undo.
    define var cFileName    as char no-undo.
    define var cStatus      as char no-undo.
    define var iSeqno       as int no-undo.
    define var iExt         as int no-undo.
    define var str          as char no-undo.

    {slib/err_try}:

        empty temp-table ttAi.
    
        cTempFile = os_getTempFile( "", ".out" ).
    
        &if "{&opsys}" begins "win" &then
    
            run win_batch(
                input 'proenv ~n'
                    + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                    + replace( replace( {&xCmdAiList}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%logfile%", cTempFile ),
                input 'silent,wait' ).
    
        &else
    
            run unix_shell(
                input 'proenv ~n'
                    + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                    + replace( replace( {&xCmdAiList}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%logfile%", cTempFile ),
                input 'silent,wait' ).
    
        &endif
    
    
    
        input from value( cTempFile ).
    
            assign
                cFullPath   = ?
                cStatus     = ?
                iSeqno      = ?
                iExt        = ?.
        
            repeat:
    
                import unformatted str.   
                str = trim( str ).
    
                if str begins "Extent:" and math_isInt( trim( substr( str, 8 ) ) ) then
                    iExt = int( trim( substr( str, 8 ) ) ).
    
                if str begins "Status:" then
                    cStatus = trim( substr( str, 8 ) ).
                
                if str begins "Path:" then
                    cFullPath = trim( substr( str, 6 ) ).
    
                if str begins "Seqno:" and math_isInt( trim( substr( str, 7 ) ) ) then
                    iSeqno = int( trim( substr( str, 7 ) ) ).
    
                if  cFullPath   <> ?
                and cStatus     <> ?
                and iSeqno      <> ?
                and iExt        <> ? then do:
                
                    cFileName = os_getSubPath( cFullPath, "file", "ext" ).
    
                    create ttAi.
                    assign
                        ttAi.cFullPath  = cFullPath
                        ttAi.cFileName  = cFileName
                        ttAi.cStatus    = cStatus
                        ttAi.iSeqno     = iSeqno
                        ttAi.iExt       = iExt.
    
                    assign
                        cFullPath       = ?
                        cStatus         = ?
                        iSeqno          = ?
                        iExt            = ?.
    
                end. /* <> ? */
    
            end. /* repeat */
    
        input close. /* cTempFile */
    
    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_finally}:

        os-delete value( cTempFile ).
    
    {slib/err_end}.

end procedure. /* fillAi */



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

    define var cBackupLkFile    as char no-undo.
    define var cAimageLkFile    as char no-undo.
    define var lAimageLkFile    as log no-undo.
    define var cArchiveLkFile   as char no-undo.
    define var lArchiveLkFile   as log no-undo.    
    define var lMsg             as log no-undo.

    {slib/err_try}:

        assign
            cBackupLkFile   = os_normalizePath( cDbSetBakRootDir + "/backup.lk" )
            cAimageLkFile   = os_normalizePath( cDbSetBakRootDir + "/backup-aimage.lk" )
            cArchiveLkFile  = os_normalizePath( cDbSetBakRootDir + "/archive.lk" ).

        file-info:file-name = cBackupLkFile.

        if  file-info:full-pathname <> ?
        and date_getTimeInterval( today, time, file-info:file-mod-date, file-info:file-mod-time ) > {&xBackupLkTimeout} then

             os-delete value( cBackupLkFile ).

        file-info:file-name = cAimageLkFile.

        if  file-info:full-pathname <> ?
        and date_getTimeInterval( today, time, file-info:file-mod-date, file-info:file-mod-time ) > {&xAimageLkTimeout} then

             os-delete value( cAimageLkFile ).

        file-info:file-name = cArchiveLkFile.

        if  file-info:full-pathname <> ?
        and date_getTimeInterval( today, time, file-info:file-mod-date, file-info:file-mod-time ) > {&xArchiveLkTimeout} then

             os-delete value( cArchiveLkFile ).



        etime( yes ).
        
        lMsg = no.
        
        repeat:
        
            assign
                lAimageLkFile   = os_isFileExists( cAimageLkFile )
                lArchiveLkFile  = os_isFileExists( cArchiveLkFile ).
            
            if  not lAimageLkFile
            and not lArchiveLkFile then
                leave.

            if not lMsg then do:
            
                run log_writeMessage( "stLog", "Backup waiting for aimage backup or archive to complete." ).
                lMsg = yes.

            end. /* not lMsg */

            if lAimageLkFile and etime( no ) > {&xAimageWaitTimeout} * 1000 then
                {slib/err_throw "'error'" "'Backup timed out waiting for aimage backup to complete.'"}.

            if lArchiveLkFile and etime( no ) > {&xArchiveWaitTimeout} * 1000 then
                {slib/err_throw "'error'" "'Backup timed out waiting for archive to complete.'"}.

            pause 5.

        end. /* repeat */

        if os_isFileExists( cBackupLkFile ) then
            {slib/err_throw "'error'" "'Backup is already running.'"}.

        output to value( cBackupLkFile ).
        output close.

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* setBusy */

procedure setAvail:

    os-delete value( os_normalizePath( cDbSetBakRootDir + "/backup.lk" ) ).

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
        cLogFileList            = os_normalizePath( cDbSetBakRootDir + "/backup.lg" )
                          + "," + os_normalizePath( cDbSetBakRootDir + "/backup-aimage.lg" )

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
        input   "BACKUP ENCOUNTERED ERRORS",            /* Subject */
        input   "Backup process encountered errors.~n"
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
