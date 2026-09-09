
/**
 * sliblog.p - log library main procedure
 *
 * the sliblog library writes a standard formatted log file that is separate from the client
 * run-time log files. it was not designed for working with log files that need to be shared by 
 * multiple processes and because it truncates and does not switch log files for performance 
 * sensitive operations. if one or both of these features are required use the 4gl log-manager.
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



&if "{&opsys}" begins "win" &then

    {slib/slibwin.i}

&endif

{slib/slibos.i}

{slib/slibstr.i}

{slib/slibdate.i}

{slib/slibpro.i}

{slib/sliberr.i}



define temp-table ttLogFile no-undo

    field iLogFileId        as int
    field cFullPath         as char
    field iSizeThreshold    as int init 10485760
    field tLastMsgDate      as date

    index iLogFileId is primary unique
          iLogFileId

    index cFullPath is unique
          cFullPath.

define temp-table ttStream no-undo

    field cStream       as char
    field iLogFileId    as int

    index cStream is primary unique
          cStream

    index iLogFileId
          iLogFileId.

define var iLogFileIdSeq    as int no-undo.

define var cErrStream       as char no-undo.



on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* on close */

procedure initializeProc:

    assign
        iLogFileIdSeq   = 0

        cErrStream      = ?.

end procedure. /* initializeProc */



procedure log_openLogFile:

    define input param pcStream     as char no-undo.
    define input param pcFullPath   as char no-undo.
    define input param piThreshold  as int no-undo.

    define buffer ttStream  for ttStream.
    define buffer ttLogFile for ttLogFile.

    define var cDir         as char no-undo.
    define var cFile        as char no-undo.
    define var cExt         as char no-undo.
    define var tFileModDate as date no-undo.

    if piThreshold <= 0 then
       piThreshold = ?.

    if piThreshold = ? then
       piThreshold = 3000000.



    run os_breakPath(
        input   pcFullPath,
        output  cDir,
        output  cFile,
        output  cExt ).

    if os_isRelativePath( cDir ) then
        cDir = os_normalizePath( pro_cWorkDir + "/" + cDir ).

    pcFullPath = cDir + cFile + cExt. /* breakPath also normalizes the path */

    if not os_isDirExists( cDir ) then
        {slib/err_throw "'dir_not_found'" cDir}.



    file-info:file-name = pcFullPath.
    if file-info:full-pathname <> ? then do:

        tFileModDate = file-info:file-mod-date.

        if index( file-info:file-type, "w" ) = 0 then
            {slib/err_throw "'file_not_writeable'" pcFullPath}.

        &if "{&opsys}" begins "win" &then

        if win_isFileLocked( pcFullPath ) then
            {slib/err_throw "'file_is_locked'" pcFullPath}.

        &endif

    end. /* full-pathname <> ? */



    find first ttLogFile
         where ttLogFile.cFullPath = pcFullPath
         no-error.

    if not avail ttLogFile then do:

        iLogFileIdSeq = iLogFileIdSeq + 1.

        create ttLogFile.
        assign
            ttLogFile.iLogFileId    = iLogFileIdSeq
            ttLogFile.cFullPath     = pcFullPath
            ttLogFile.tLastMsgDate  = tFileModDate.

    end. /* not avail */

    ttLogFile.iSizeThreshold = piThreshold.



    find first ttStream
         where ttStream.cStream = pcStream
         no-error.

    if not avail ttStream then do:

        create ttStream.
        assign ttStream.cStream = pcStream.

    end. /* not avail */

    ttStream.iLogFileId = ttLogFile.iLogFileId.

end procedure. /* log_openLogFile */

/* this procedure like other cleanup operations does not throw exceptions */

procedure log_closeLogFile:

    define input param pcStream as char no-undo.

    define buffer ttLogFile for ttLogFile.
    define buffer ttStream  for ttStream.

    find first ttStream
         where ttStream.cStream = pcStream
         no-error.    

    if not avail ttStream then
        return.

    find first ttLogFile
         where ttLogFile.iLogFileId = ttStream.iLogFileId
         no-error.

    if not avail ttLogFile then
        return.



    if cErrStream = ttStream.cStream then
        run log_closeDirectErrors.

    delete ttStream.

    if not can-find(
        first ttStream
        where ttStream.iLogFileId = ttLogFile.iLogFileId ) then

        delete ttLogFile.

end procedure. /* log_closeLogFile */

procedure log_writeMessage:

    define input param pcStream     as char no-undo.
    define input param pcMessage    as char no-undo.

    define buffer ttStream  for ttStream.
    define buffer ttLogFile for ttLogFile.

    define var tToday   as date no-undo.
    define var iMTime   as int no-undo.

    define var i        as int no-undo.
    define var j        as int no-undo.

    find first ttStream
         where ttStream.cStream = pcStream
         no-error.    

    if not avail ttStream then do:
    
        message pcMessage.
        return.

    end. /* not avail ttStream */

    find first ttLogFile
         where ttLogFile.iLogFileId = ttStream.iLogFileId
         no-error.

    if not avail ttLogFile then do:
    
        message pcMessage.
        return.

    end. /* not avail ttLogFile */

    /***
    &if "{&opsys}" begins "win" &then

    if win_isFileLocked( ttLogFile.cFullPath ) then do:
    
        message pcMessage.
        return.

    end. /* not avail ttLogFile */

    &endif
    ***/



    output to value( ttLogFile.cFullPath ) append.

    assign
        tToday  = today
        iMTime  = time * 1000.

    if ttLogFile.tLastMsgDate <> tToday then do:

        put unformatted
            skip(1)
            right-trim( str_alignCenter( date_Date2Str( tToday, iMTime, 0, "www mmm d hh:ii:ss yyyy" ), 80, ? ) ) skip.

        ttLogFile.tLastMsgDate = tToday.

    end. /* tLastMsgDate <> tToday */

    j = num-entries( pcMessage, "~n" ). do i = 1 to j:

        put unformatted
            date_date2str( ?, iMTime, 0, "hh:ii:ss" ) space(1)
            entry( i, pcMessage, "~n" ) skip.

    end. /* 1 to j */

    output close.

    run truncLogFile( buffer ttLogFile ).

end procedure. /* log_output */

procedure truncLogFile private:

    define param buffer ttLogFile for ttLogFile.

    define var cFileName    as char no-undo.
    define var iSeek        as int no-undo.
    define var cDate        as char no-undo.
    define var str          as char no-undo.

    file-info:file-name = ttLogFile.cFullPath.

    if file-info:file-size <= ttLogFile.iSizeThreshold then return.



    assign
        iSeek     = file-info:file-size - int( ttLogFile.iSizeThreshold / 2 ).

        cFileName = ttLogFile.cFullPath + ".tmp".

    do while search( cFileName ) <> ?:

        cFileName = ttLogFile.cFullPath + ".tmp" + "." + string( random( 0, 99999 ), "99999" ).

    end. /* do while */



    input from value( ttLogFile.cFullPath ).

    repeat:

        import unformatted str.

        if str begins "        " /* spaces inplace of hh:mm:ss */ then
            cDate = str.

        else
        if seek( input ) > iSeek and str <> "" then
            leave.

    end. /* repeat */



    output to value( cFileName ).

    put unformatted 
        skip(1) 
        cDate skip
        str skip.

    repeat:

        import unformatted str.
        put unformatted str skip.

    end. /* repeat */

    input close.
    output close.

    os-delete value( ttLogFile.cFullPath ).
    os-rename value( cFileName ) value( ttLogFile.cFullPath ).

end procedure. /* truncLogFile */



procedure log_directErrors:

    define input param pcStream as char no-undo.

    define buffer ttStream for ttStream.

    if not can-find(
        first ttStream
        where ttStream.cStream = pcStream ) then

        return.

    if pcStream = ? then

        run log_closeDirectErrors.

    else do:

        run err_directErrors(
            input this-procedure,
            input pcStream ).

        cErrStream = pcStream.

    end. /* else */

end procedure. /* log_directErrors */

procedure log_directError:

    define input param pcStream     as char no-undo.
    define input param pcErrorMsg   as char no-undo.

    define var str  as char no-undo.
    define var i    as int no-undo.
    define var j    as int no-undo.

    pcErrorMsg = replace( pcErrorMsg, chr(1), "~n" ).

    j = num-entries( pcErrorMsg, "~n" ).

    do i = 1 to j:

        str = entry( i, pcErrorMsg, "~n" ).

        if not str begins "** " then

            entry( i, pcErrorMsg, "~n" ) = "** " + str.

    end. /* 1 to j */

    run log_writeMessage(
        input pcStream,
        input pcErrorMsg ).

end procedure. /* log_directError */

procedure log_closeDirectErrors:

    run err_closeDirectErrors.

    cErrStream = ?.

end procedure. /* log_closeDirectErrors */



/* old routines mostly kept for backward compatibility */

procedure log_outputTo:

    define input param pcStream     as char no-undo.
    define input param pcFullPath   as char no-undo.
    define input param piThreshold  as int no-undo.

    run log_openLogFile(
        input pcStream,
        input pcFullPath,
        input piThreshold ).

end procedure. /* log_outputTo */

procedure log_output:

    define input param pcStream     as char no-undo.
    define input param pcMessage    as char no-undo.

    {slib/err_try}:

        run log_writeMessage(
            input pcStream,
            input pcMessage ).

    {slib/err_end}.

end procedure. /* log_output */

procedure log_outputClose:

    define input param pcStream as char no-undo.

    run log_closeLogFile( pcStream ).

end procedure. /* log_outputClose */
