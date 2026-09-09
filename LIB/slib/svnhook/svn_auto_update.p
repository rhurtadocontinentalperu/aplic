
/**
 * svn_auto_update.p -
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
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Contact information
 *  Email: alonblich@gmail.com
 *  Phone: +263-77-7600818
 */

{slib/slibos.i}

&if "{&opsys}" begins "win" &then

    {slib/slibwin.i}

&else

    {slib/slibunix.i}

&endif

{slib/slibpro.i}

{slib/sliberr.i}



define temp-table ttChange no-undo

    field cFileName as char
    field cStatus   as char
    
    index cFileName is primary unique
          cFileName.

define var cDirList     as char no-undo.
define var cDir         as char no-undo.
define var iDirNum      as int no-undo.
define var iDirCnt      as int no-undo.

define var cError       as char no-undo.
define var cErrorMsg    as char no-undo.
define var cStackTrace  as char no-undo.


{slib/err_try}:

    cDirList = session:param.

    iDirCnt = num-entries( cDirList ).
    do iDirNum = 1 to iDirCnt:

        cDir = entry( iDirNum, cDirList ).

        if os_isRelativePath( cDir ) then
            cDir = os_normalizePath( pro_cWorkDir + "/" + cDir ).

        if not os_isDirExists( cDir ) then
            next.
    
        run fillChange( cDir ).

        run commitChange.

        run cleanup( cDir ).

    end. /* do iDir */

{slib/err_catch cError cErrorMsg cStackTrace}:

    message
        replace( cErrorMsg, chr(1), "~n" )
        skip(1)
        cStackTrace
    view-as alert-box.

{slib/err_end}.



procedure fillChange:

    define input param pcDir as char no-undo.

    define buffer ttChange for ttChange.

    define var cFileName    as char no-undo.
    define var cRevision    as char no-undo.
    define var cStatus      as char no-undo.

    define var cTempFile    as char no-undo.
    define var str          as char no-undo.

    empty temp-table ttChange.

    {slib/err_try}:

        cTempFile = os_getTempFile( "", ".out" ).
    
        &if "{&opsys}" begins "win" &then

            run win_batch(
                input 'svn status "' + pcDir + '" -u > "' + cTempFile + '"',
                input 'silent,wait' ).

        &else

            run unix_shell(
                input 'svn status "' + pcDir + '" -u > "' + cTempFile + '"',
                input 'silent,wait' ).

        &endif

        input from value( cTempFile ).
        
        repeat:

            str = ?.

            import unformatted str.

            if str = ""
            or str = ? then
                next.

            if left-trim( str ) begins ">" then
                next.

            if str begins "Status against revision:" then
                leave.

            assign
                cStatus     = substr( str, 1, 8 )
                cRevision   = substr( str, 10, 9 )
                cFileName   = substr( str, 22 ).

            if substr( cStatus, 1, 1 ) = "?" then do:

                file-info:file-name = cFileName.
                if index( file-info:file-type, "d" ) > 0 then do:
                
                    if search( os_normalizePath( cFileName + "/.svn" ) ) <> ?
                        then next.

                end. /* index( "d" ) > 0 */
                
            end. /* substr = "?" */
                
            create ttChange.
            assign
                ttChange.cFileName  = cFileName
                ttChange.cStatus    = cStatus.

        end. /* repeat */

        input close.

    {slib/err_catch}:

        {slib/err_throw last}.
    
    {slib/err_finally}:
    
        os-delete value( cTempFile ).

    {slib/err_end}.

end procedure. /* fillChange */

procedure commitChange:

    define buffer ttChange for ttChange.

    &if "{&opsys}" = "unix" &then
    
    define var cUser    as char no-undo.
    define var cGroup   as char no-undo.
    define var iPerm    as int no-undo.
    
    &endif /* opsys = "unix" */
    
    for each ttChange:
    
        &if "{&opsys}" = "unix" &then

        {slib/err_try}:
        
            run unix_getFilePerm(
                input   ttChange.cFileName,
                output  cUser,
                output  cGroup,
                output  iPerm ).
    
        {slib/err_end}.
        
        &endif /* opsys = "unix" */
    
    
    
        if substr( ttChange.cStatus, 1, 1 ) = "M" then do:
        
            &if "{&opsys}" begins "win" &then

                run win_batch(
                    input 'svn commit "' + ttChange.cFileName + '"'
                        + ' -m "auto update"',
                    input 'silent,wait' ).

            &else

                run unix_shell(
                    input 'svn commit "' + ttChange.cFileName + '"'
                        + ' -m "auto update"',
                    input 'silent,wait' ).

            &endif

        end. /* substr = "m" */

        else
        if substr( ttChange.cStatus, 1, 1 ) = "?" then do:
        
            &if "{&opsys}" begins "win" &then

                run win_batch(
                    input 'svn add "' + ttChange.cFileName + '" ~n'
                        + 'svn commit "' + ttChange.cFileName + '"'
                        + ' -m "auto update"',
                    input 'silent,wait' ).

            &else

                run unix_shell(
                    input 'svn add "' + ttChange.cFileName + '" ~n'
                        + 'svn commit "' + ttChange.cFileName + '"'
                        + ' -m "auto update"',
                     input 'silent,wait' ).

            &endif

        end. /* substr = "?" */

        else
        if substr( ttChange.cStatus, 1, 1 ) = "!" then do:
        
            &if "{&opsys}" begins "win" &then

                run win_batch(
                    input 'svn delete "' + ttChange.cFileName + '"'
                        + ' --force ~n'
                        + 'svn commit "' + ttChange.cFileName + '"'
                        + ' -m "auto update"',
                    input 'silent,wait' ).

            &else

                run unix_shell(
                    input 'svn delete "' + ttChange.cFileName + '"'
                        + ' --force ~n'
                        + 'svn commit "' + ttChange.cFileName + '"'
                        + ' -m "auto update"',
                    input 'silent,wait' ).

            &endif

        end. /* substr = "!" */



        &if "{&opsys}" = "unix" &then

        {slib/err_try}:
        
            run unix_setFilePerm(
                input ttChange.cFileName,
                input cUser,
                input cGroup,
                input iPerm ).
    
        {slib/err_end}.
        
        &endif /* opsys = "unix" */

    end. /* for each ttChange */

end procedure. /* commitChange */

procedure cleanup:

    define input param pcDir as char no-undo.

    {slib/err_try}:

        &if "{&opsys}" begins "win" &then

            run win_batch(
                input 'svn cleanup "' + pcDir + '"',
                input 'silent,wait' ).

        &else

            run unix_shell(
                input 'svn cleanup "' + pcDir + '"',
                input 'silent,wait' ).

        &endif

    {slib/err_catch}:

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* cleanup */

