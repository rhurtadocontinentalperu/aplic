
/**
 * backup-aimage.p -
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

{slib/slibpro.i}

{slib/sliberr.i}



&global xBackupLkTimeout    82800   /* 23 * 60 * 60 */
&global xAimageLkTimeout    3600    /* 60 * 60 */

&if "{&opsys}" begins "win" &then

    &global xCmdAiExtract   'call rfutil "%pdbname%" -C aimage extract -a "%aifile%" -o "%bakfile%"'
    &global xCmdAiEmpty     'call rfutil "%pdbname%" -C aimage extent empty "%aifile%"'
    &global xCmdAiNew       'call rfutil "%pdbname%" -C aimage new'
    &global xCmdAiList      'call rfutil "%pdbname%" -C aimage extent list > "%logfile%"'

&else

    &global xCmdAiExtract   'rfutil "%pdbname%" -C aimage extract -a "%aifile%" -o "%bakfile%"'
    &global xCmdAiEmpty     'rfutil "%pdbname%" -C aimage extent empty "%aifile%"'
    &global xCmdAiNew       'rfutil "%pdbname%" -C aimage new'
    &global xCmdAiList      'rfutil "%pdbname%" -C aimage extent list > "%logfile%"'

&endif



define temp-table ttDb no-undo

    field iDbNum        as int
    field cLDbName      as char
    field cPDbName      as char
    field cPort         as char

    field cBakRootDir   as char
    field cCurrBakDir   as char

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

define temp-table ttBakDir no-undo

    field cFullPath     as char
    field cDir          as char
    field cType         as char

    index cFullPath is primary unique
          cFullPath.

define var cDbSetName       as char no-undo.
define var cDbSetBakRootDir as char no-undo.
define var cLogFile         as char no-undo.

define var lError           as log no-undo.



run preinitializeProc.

run setBusy.

{slib/err_try}:

    run initializeProc.

    run log_writeMessage( "stLog", " - " ).
    run log_writeMessage( "stLog", "Set " + cDbSetName + " aimage backup started." ).

    for each ttDb:

        {slib/err_try}:

            run log_writeMessage( "stLog", "Database " + ttDb.cLDbName + " aimage backup started." ).

            run backupFullAi( buffer ttDb ).
            run backupBusyAi( buffer ttDb ).

            run log_writeMessage( "stLog", "Database " + ttDb.cLDbName + " aimage backup completed successfully." ).

        {slib/err_end}.

    end. /* each ttDb */

    if lError then do:

        run log_writeMessage( "stLog", "Set " + cDbSetName + " aimage backup completed with errors (" +
            date_Date2Str( today, 0, 0, "www mmm d, yyyy" ) + ")." ).

        {slib/err_throw "'error'"}.

    end. /* lError */

    else do:

        run log_writeMessage( "stLog", "Set " + cDbSetName + " aimage backup completed successfully (" +
            date_Date2Str( today, 0, 0, "www mmm d, yyyy" ) + ")." ).

    end. /* else */

{slib/err_finally}:

    run closeProc.
    
    run setAvail.

{slib/err_end}.

quit.



procedure preinitializeProc:

    define buffer ttDb for ttDb.

    {slib/err_try}:

        assign
           lError           = no

           cDbSetBakRootDir = trim( os-getenv( "BAK_ROOT_DIR" ) ).

        if cDbSetBakRootDir = "" then cDbSetBakRootDir = ?.

        if cDbSetBakRootDir = ? then
            {slib/err_throw "'os_envvar_is_empty'" "'BAK_ROOT_DIR'"}.

        if not os_isDirExists( cDbSetBakRootDir ) then
             run os_createDir( cDbSetBakRootDir ).

        cLogFile = os_normalizePath( cDbSetBakRootDir + "/backup-aimage.lg" ).

        run log_openLogFile ( "stLog", cLogFile, ? ).
        run log_directErrors( "stLog" ).



        assign
           cDbSetName       = trim( os-getenv( "DB_SET_NAME" ) ).

        if cDbSetName       = "" then cDbSetName = ?.

        if cDbSetName = ? then
            {slib/err_throw "'os_envvar_is_empty'" "'DB_SET_NAME'"}.



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
    define var cCurrBakDir  as char no-undo.

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
                    {slib/err_throw "'error'" "'Backup directory ' + cBakRootDir + ' does not exist.'}.
        
                run fillBakDir( cBakRootDir ).

                cCurrBakDir = ?.

                find last ttBakDir
                     use-index cFullPath
                     no-error.

                if avail ttBakDir then

                    cCurrBakDir = ttBakDir.cFullPath.



                create ttDb.
                assign
                    ttDb.iDbNum         = iDbNum
                    ttDb.cLDbName       = cLDbName
                    ttDb.cPDbName       = cPDbName
                    ttDb.cPort          = cPort

                    ttDb.cBakRootDir    = cBakRootDir
                    ttDb.cCurrBakDir    = cCurrBakDir.

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

    {slib/err_try}:
    
        run initializeDb.

    

        for each  ttDb
            where ttDb.cCurrBakDir <> ?:

            run os_fillFile(
                input   ttDb.cCurrBakDir,
                input   "p.....tmp.bak",
                output  table os_ttFile ).

            if can-find( first os_ttFile ) then do:
    
                run os_deleteDir( ttDb.cCurrBakDir ).
    
                run fillBakDir( ttDb.cBakRootDir ).

                find last  ttBakDir
                     where ttBakDir.cFullPath < ttDb.cCurrBakDir
                     use-index cFullPath
                     no-error.

                assign
                    ttDb.cCurrBakDir = ( if avail ttBakDir then ttBakDir.cFullPath else ? ).
    
            end. /* can-find */

        end. /* each ttDb */

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* initializeProc */

procedure initializeDb:

    define buffer ttDb for ttDb.

    define var lAiEnabled       as log no-undo.

    define var cBakRootDir      as char no-undo.
    define var cCurrBakDir      as char no-undo.

    define var hLoggingBuff     as handle no-undo.
    define var hAiGenNumFld     as handle no-undo.

    create widget-pool.

    {slib/err_try}:

        for each ttDb:

            {slib/err_try}:

                connect value( '-db "' + cPDbName + '" -ld "' + ttDb.cLDbName + '"' + ( if ttDb.cPort <> ? then ' -S ' + ttDb.cPort else '' ) ) no-error.

                if    error-status:num-messages     > 0
                and ( error-status:get-number(1)    = 1423
                   or error-status:get-number(1)    = 1432 ) then

                    connect value( '-db "' + ttDb.cPDbName + '" -ld "' + ttDb.cLDbName + '" -RO' ) no-error.
                
                if not connected( ttDb.cLDbName ) then
                    {slib/err_throw "'db_conn_failed'" ttDb.cPDbName}.



                create buffer hLoggingBuff for table cLDbName + "._Logging".
                hAiGenNumFld = hLoggingBuff:buffer-field( "_Logging-AiGenNum" ) {slib/err_no-error}.

                lAiEnabled = no.

                hLoggingBuff:find-first( "", no-lock ).

                if  hLoggingBuff:available
                and hAiGenNumFld:buffer-value <> 0 then

                    lAiEnabled = yes.

                if not lAiEnabled then
                    {slib/err_throw "'error'" "'Aimaging not enabled for database ' + ttDb.cPDbName}.

            {slib/err_catch}:

                run log_writeMessage( "stLog", "Aimage backup of database " + ttDb.cLDbName + " cancelled." ).

                delete ttDb.

                lError = yes.

            {slib/err_finally}:

                disconnect value( cLDbName ) no-error.
            
            {slib/err_end}.
    
        end. /* do iDbNum */

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



procedure backupFullAi:

    define param buffer pbDb for ttDb.

    define buffer ttAi for ttAi.

    define var cBakTempFile as char no-undo.
    define var cBakFile     as char no-undo.
    
    {slib/err_try}:

        run fillAi( buffer pbDb ).
        
        for each  ttAi
            where ttAi.cStatus = "full":

            if pbDb.cCurrBakDir <> ? then do:
            
                assign
                    cBakTempFile    = os_normalizePath( pbDb.cCurrBakDir + "/"
                        + os_getSubPath( os_getTempFile( "", ".ai" ), "file", "ext" ) )
    
                    cBakFile        = os_normalizePath( pbDb.cCurrBakDir + "/aimage" 
                        + string( ttAi.iSeqno, "999999" ) + ".ai" ).
    
                os-delete value( cBakTempFile ).
                os-delete value( cBakFile ).
    
                if pro_cFullProversion >= "09.1D09" then do:
    
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
                
                    os-copy value( ttAi.cFullPath ) value( cBakTempFile ).
                
                end. /* else */
                
                if not os_isFileExists( cBakTempFile ) then
                    {slib/err_throw "'error'" "'Unable to extract aimage ' + string( ttAi.iSeqno ) + '.'"}.
    
                os-rename value( cBakTempFile ) value( cBakFile ).
    
                if not os_isFileExists( cBakFile ) then
                    {slib/err_throw "'file_rename_failed'" cBakTempFile cBakFile}.
    
                run log_writeMessage( "stLog", "Aimage " + string( ttAi.iSeqno ) + " backup completed successfully." ).

            end. /* pbDb.cCurrBakDir <> ? */
    
    
    
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
    
    {slib/err_try}:

        run verifyEmptyAi   ( buffer pbDb ).
        run fillAi          ( buffer pbDb ).

        find first ttAi
             where ttAi.cStatus = "busy"
             no-error.

        if available ttAi then do:

            &if "{&opsys}" begins "win" &then
    
                run win_batch(
                    input 'proenv ~n'
                        + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                        + replace( {&xCmdAiNew}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ),
                    input 'silent,wait' ).
    
                if win_iErrorLevel <> 0 then
                    {slib/err_throw "'error'" "'Move to new aimage extent ' + string( ttAi.iSeqno ) + ' failed.'"}.
    
            &else
    
                run unix_shell(
                    input 'proenv ~n'
                        + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                        + replace( {&xCmdAiNew}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ),
                    input 'silent,wait' ).
    
                if unix_iExitCode <> 0 then
                    {slib/err_throw "'error'" "'Move to new aimage extent ' + string( ttAi.iSeqno ) + ' failed.'"}.
    
            &endif



            if pbDb.cCurrBakDir <> ? then do:

                assign
                    cBakTempFile    = os_normalizePath( pbDb.cCurrBakDir + "/"
                        + os_getSubPath( os_getTempFile( "", ".ai" ), "file", "file" ) )
        
                    cBakFile        = os_normalizePath( pbDb.cCurrBakDir
                        + "/aimage" + string( ttAi.iSeqno, "999999" ) + ".ai" ).
        
                os-delete value( cBakTempFile ).
                os-delete value( cBakFile ).
        
                if pro_cFullProversion >= "09.1D09" then do:
        
                    &if "{&opsys}" begins "win" &then
                
                        run win_batch(
                            input 'proenv ~n'
                                + 'cd /d "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                                + replace( replace( replace( {&xCmdAiExtract}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%aifile%" , ttAi.cFullPath ), "%bakfile%", cBakTempFile ),
                            input 'silent,wait' ).
                
                        if win_iErrorLevel <> 0 then
                            {slib/err_throw "'error'" "'Unable to extract aimage ' + string( ttAi.iSeqno ) + '.'"}.
                
                    &else
                
                        run unix_shell(
                            input 'proenv ~n'
                                + 'cd "' + os_getSubPath( pbDb.cPDbName, "dir", "dir" ) + '" ~n'
                                + replace( replace( replace( {&xCmdAiExtract}, "%pdbname%", os_getSubPath( pbDb.cPDbName, "file", "file" ) ), "%aifile%" , ttAi.cFullPath ), "%bakfile%", cBakTempFile ),
                            input 'silent,wait' ).
                
                        if unix_iExitCode <> 0 then
                            {slib/err_throw "'error'" "'Unable to extract aimage ' + string( ttAi.iSeqno ) + '.'"}.
                
                    &endif
                
                end. /* pro_cFullProversion >= "09.1D09" */
                
                else do:
                
                    os-copy value( ttAi.cFullPath ) value( cBakTempFile ).
                
                end. /* else */

                if not os_isFileExists( cBakTempFile ) then
                    {slib/err_throw "'error'" "'Unable to extract aimage ' + string( ttAi.iSeqno ) + '.'"}.
        
                os-rename value( cBakTempFile ) value( cBakFile ).
        
                if not os_isFileExists( cBakFile ) then
                    {slib/err_throw "'file_rename_failed'" cBakTempFile cBakFile}.
        
                run log_writeMessage( "stLog", "Aimage " + string( ttAi.iSeqno ) + " backup completed successfully." ).

            end. /* pbDb.cCurrBakDir <> ? */
    
    
    
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

        end. /* avail ttAi */

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

    define var cBackupLkFile as char no-undo.
    define var cAimageLkFile as char no-undo.

    {slib/err_try}:

        assign
            cBackupLkFile   = os_normalizePath( cDbSetBakRootDir + "/backup.lk" )
            cAimageLkFile   = os_normalizePath( cDbSetBakRootDir + "/backup-aimage.lk" ).

        file-info:file-name = cBackupLkFile.

        if  file-info:full-pathname <> ?
        and date_getTimeInterval( today, time, file-info:file-mod-date, file-info:file-mod-time ) > {&xBackupLkTimeout} then

             os-delete value( cBackupLkFile ).

        file-info:file-name = cAimageLkFile.

        if  file-info:full-pathname <> ?
        and date_getTimeInterval( today, time, file-info:file-mod-date, file-info:file-mod-time ) > {&xAimageLkTimeout} then

             os-delete value( cAimageLkFile ).



        if os_isFileExists( cBackupLkFile ) then
            {slib/err_throw "'error'" "'Backup is running. Backup aimage aborted'"}.

        if os_isFileExists( cAimageLkFile ) then
            {slib/err_throw "'error'" "'Backup aimage is already running.'"}.

        output to value( cAimageLkFile ).
        output close.

    {slib/err_catch}:

        lError = yes.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* setBusy */

procedure setAvail:

    os-delete value( os_normalizePath( cDbSetBakRootDir + "/backup-aimage.lk" ) ).

end procedure. /* setAvail */
