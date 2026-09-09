
/**
 * svnhook.p -
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

{slib/sliberr.i}

{slib/slibpro.i}



define temp-table ttBuffer no-undo

    field iBufferId as int
    field cFullPath as char

    index iBufferId is primary unique 
          iBufferId.

define var cUserName as char no-undo.



function getWcInfo      returns char private ( pcFullPath as char, pcField as char ) forward.
function getWcStatus    returns char private ( pcFullPath as char ) forward.
function getWcProp      returns char private ( pcFullPath as char, pcPropName as char ) forward.
function escapePropVal  returns char private ( pcPropVal as char ) forward.



on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* close */

procedure initializeProc:

    &if "{&opsys}" begins "win" &then
        
        cUserName = win_getUserName();
        
    &else
        
        cUserName = unix_whoami().
        
    &endif

end procedure. /* initializeProc */



procedure svn_openFile:

    define input param piBufferId as int no-undo.
    define input param pcFileName as char no-undo.

    define buffer ttBuffer for ttBuffer.

    pcFileName = os_getFullPath( pcFileName ).
    if pcFileName = ? then return.

    find first ttBuffer
         where ttBuffer.iBufferId = piBufferId
         use-index iBufferId
         no-error.

    if not avail ttBuffer then do:

        create ttBuffer.
        assign
            ttBuffer.iBufferId  = piBufferId
            ttBuffer.cFullPath  = pcFileName.

    end. /* not avail */

end procedure. /* svn_openFile */

procedure svn_closeFile:

    define input param piBufferId as int no-undo.

    define buffer ttBuffer for ttBuffer.

    find first ttBuffer
         where ttBuffer.iBufferId = piBufferId
         use-index iBufferId
         no-error.

    if avail ttBuffer then
      delete ttBuffer.

end procedure. /* svn_closeFile */

procedure svn_beforeSaveFile:

    define input    param piBufferId    as int no-undo.
    define input    param pcFileName    as char no-undo.
    define output   param plOk          as log no-undo.

    define buffer ttBuffer for ttBuffer.

    pcFileName = os_normalizePath( pcFileName ).

    if os_isRelativePath( pcFileName ) then
       pcFileName = os_normalizePath( pro_cWorkDir + "/" + pcFileName ).



    plOk = yes.
    
    if getWcInfo( os_getSubPath( pcFileName, "dir", "dir" ), "url" ) matches "*trunk*" then do:

        find first ttBuffer
             where ttBuffer.iBufferId = piBufferId
             use-index iBufferId
             no-error.

        /* if new file or not saved from branch */

        if not avail ttBuffer
        or not getWcInfo( os_getSubPath( ttBuffer.cFullPath, "dir", "dir" ), "url" ) matches "*branch*" then do:

            do on stop undo, leave:
                message "You can only save files to trunk from a branch" view-as alert-box.
            end.

            plOk = no.

        end. /* not cFullPath begins cTestDir */

    end. /* begins cProdDir */

end procedure. /* svn_beforeSaveFile */

procedure svn_saveFile:

    define input param piBufferId as int no-undo.
    define input param pcFileName as char no-undo.

    define buffer ttBuffer for ttBuffer.

    define var cSourceDirUrl    as char no-undo.
    define var cSourceStatus    as char no-undo.
    define var cTargetDirUrl    as char no-undo.
    define var cTargetStatus    as char no-undo.

    define var cStatus          as char no-undo.
    define var cDesc            as char no-undo.

    define var cTempFile        as char no-undo.
    define var cFile            as char no-undo.
    define var cDir             as char no-undo.
    define var cExt             as char no-undo.

    define var cError           as char no-undo.
    define var cErrorMsg        as char no-undo.
    define var cStackTrace      as char no-undo.

    pcFileName = os_getFullPath( pcFileName ).
    if pcFileName = ? then return.

    find first ttBuffer
         where ttBuffer.iBufferId = piBufferId
         use-index iBufferId
         no-error.

    /* new file (not opened) and saved for the first time */

    if not avail ttBuffer then do:

        create ttBuffer.
        assign
            ttBuffer.iBufferId = piBufferId
            ttBuffer.cFullPath = ?.

    end. /* not avail */



    {slib/err_try}:

        assign
            cSourceDirUrl = ?
            cSourceStatus = ?.
    
        if ttBuffer.cFullPath <> ? then
        assign        
            cSourceDirUrl = getWcInfo( os_getSubPath( ttBuffer.cFullPath, "dir", "dir" ), "url" )
            cSourceStatus = getWcStatus( ttBuffer.cFullPath ).
    
        assign
            cTargetDirUrl = getWcInfo( os_getSubPath( pcFileName, "dir", "dir" ), "url" )
            cTargetStatus = getWcStatus( pcFileName ).
    
        if  cSourceDirUrl matches "*branch*"
        and cTargetDirUrl matches "*trunk*" then do:
    
            if  cSourceStatus <> "?"
            and cTargetStatus <> "?" then do:
    
                cDesc = getWcProp( ttBuffer.cFullPath, "change-desc" ).
                if cDesc = ? then do:
    
                    run updateDesc( output cDesc ).
                    run setWcProp( ttBuffer.cFullPath, "change-desc", cDesc ).
    
                end. /* cDesc = ? */
    
                os-copy value( pcFileName ) value( ttBuffer.cFullPath ).
                run commitWc( ttBuffer.cFullPath, cDesc ).

				/***
                run revertWc( pcFileName ).
    
                {slib/err_try}:

                    run mergeUrlWc( getWcInfo( ttBuffer.cFullPath, "url" ), pcFileName ).
                    run setWcProp( pcFileName, "change-desc", cDesc ).

                {slib/err_catch}:
    
                    run deleteWc( pcFileName ).
    
                    run copyWc( ttBuffer.cFullPath, pcFileName ).
                    run setWcProp( pcFileName, "change-desc", cDesc ).
    
                {slib/err_end}.
    
                run commitWc( pcFileName, cDesc ).
				***/
				
				run setWcProp( pcFileName, "change-desc", cDesc ).
                run commitWc( pcFileName, cDesc ).
    
            end. /* cSourceStatus <> "?" and cTargetStatus = "?" */
    
            else
            if cSourceStatus <> "?" then do:
            
                cDesc = getWcProp( ttBuffer.cFullPath, "change-desc" ).
                if cDesc = ? then do:
        
                    run updateDesc( output cDesc ).
                    run setWcProp( ttBuffer.cFullPath, "change-desc", cDesc ).
        
                end. /* cDesc = ? */
        
                os-copy value( pcFileName ) value( ttBuffer.cFullPath ).
                run commitWc( ttBuffer.cFullPath, cDesc ).
        
                os-delete value( pcFileName ).
        
                run copyWc( ttBuffer.cFullPath, pcFileName ).
                run setWcProp( pcFileName, "change-desc", cDesc ).
        
                run commitWc( pcFileName, cDesc ).
    
            end. /* cSourceStatus <> "?" */
    
            else
            if cTargetStatus <> "?" then do:
    
                run updateDesc( output cDesc ).
                
                run setWcProp( pcFileName, "change-desc", cDesc ).
                run commitWc( pcFileName, cDesc ).
            
            end. /* cTargetStatus <> "?" */
            
            else do:
    
                run updateDesc( output cDesc ).
    
                run addWc( pcFileName ).
                run setWcProp( pcFileName, "change-desc", cDesc ).
    
                run commitWc( pcFileName, cDesc ).
    
            end. /* else */
    
            /*** ssb only ***/
    
            run os_breakPath(
                input   pcFileName,
                output  cDir,
                output  cFile,
                output  cExt ).
    
            if cDir = "/p/ssb/prog/"
            or cDir = "/p/ssb/prog/ccssrc/" then do:
    
                case cDir:
                    when "/p/ssb/prog/"         then cDir = "/p/ssb/prog/ccssrc/".
                    when "/p/ssb/prog/ccssrc/"  then cDir = "/p/ssb/prog/".
                end case.
    
                cFile = cDir + cFile + cExt.
    
                cStatus = getWcStatus( cFile ).
                if cStatus <> ? then do:
                
                    if cStatus <> "?" then do:

                        run deleteWc( cFile ).
                        run commitWc( cFile, cDesc ).

                    end. /* cStatus <> "?" */

                    else os-delete value( cFile ).

                end. /* cStatus <> ? */
    
                run copyWc( pcFileName, cFile ).
                run setWcProp( pcFileName, "change-desc", cDesc ).
    
                run commitWc( cFile, cDesc ).
    
            end. /* cDir = "/p/ssb/prog/" */
    
            /*** ssb only ***/
    
        end. /* branch to trunk */
    
    
    
        else
        if  cSourceDirUrl matches "*trunk*"
        and cTargetDirUrl matches "*branch*" then do:
    
            run updateDesc( output cDesc ).
    
            if cSourceStatus <> "?" then do:
    
                cTempFile = os_getTempFile( "", os_getSubPath( pcFileName, "ext", "ext" ) ).
                os-copy value( pcFileName ) value( cTempFile ).

                if cTargetStatus <> ? then do:
                
                    if cTargetStatus <> "?" then do:

                        run deleteWc( pcFileName ).
                        run commitWc( pcFileName, cDesc ).
            
                    end. /* cTargetStatus <> "?" */

                    else os-delete value( pcFileName ).
                    
                end. /* cTargetStatus <> ? */

                run copyWc( ttBuffer.cFullPath, pcFileName ).   
                run setWcProp( pcFileName, "change-desc", cDesc ).
    
                os-copy value( cTempFile ) value( pcFileName ).
                os-delete value( cTempFile ).
    
                run commitWc( pcFileName, cDesc ).

            end. /* cSourceStatus <> "?" */
    
            else do:
    
                cTempFile = os_getTempFile( "", os_getSubPath( pcFileName, "ext", "ext" ) ).
                os-copy value( pcFileName ) value( cTempFile ).
    
                if cTargetStatus <> ? then do:
    
                    if cTargetStatus <> "?" then do:

                        run deleteWc( pcFileName ).
                        run commitWc( pcFileName, cDesc ).
                
                    end. /* cTargetStatus <> "?" */

                    else os-delete value( pcFileName ).
                    
                end. /* cTargetStatus <> ? */
    
                os-copy value( cTempFile ) value( pcFileName ).
                os-delete value( cTempFile ).
    
                run addWc( pcFileName ).   
                run setWcProp( pcFileName, "change-desc", cDesc ).
    
                run commitWc( pcFileName, cDesc ).
    
            end. /* else */
    
        end. /* trunk to branch */
    
    
    
        else
        if cTargetDirUrl <> ? then do:
    
            if  ttBuffer.cFullPath <> ?
            and ttBuffer.cFullPath <> pcFileName 
            
            and cSourceStatus <> "?" then do:
    
                cDesc = getWcProp( ttBuffer.cFullPath, "change-desc" ).
                if cDesc = ? then run updateDesc( output cDesc ).
    
                cTempFile = os_getTempFile( "", os_getSubPath( pcFileName, "ext", "ext" ) ).
                os-copy value( pcFileName ) value( cTempFile ).
    
                if cTargetStatus <> ? then do:
    
                    if cTargetStatus <> "?" then do:

                        run deleteWc( pcFileName ).
                        run commitWc( pcFileName, cDesc ).

                    end. /* cTargetStatus <> "?" */

                    else os-delete value( pcFileName ).
                    
                end. /* cTargetStatus <> ? */
    
                run copyWc( ttBuffer.cFullPath, pcFileName ).   
                run setWcProp( pcFileName, "change-desc", cDesc ).
    
                os-copy value( cTempFile ) value( pcFileName ).
                os-delete value( cTempFile ).
    
                run commitWc( pcFileName, cDesc ).
    
            end. /* ttBuffer <> pcFileName */
    
            else
            if cTargetStatus <> "?" then do:
    
                cDesc = getWcProp( ttBuffer.cFullPath, "change-desc" ).
                if cDesc = ? then do:
    
                    run updateDesc( output cDesc ).
                    run setWcProp( pcFileName, "change-desc", cDesc ).
    
                end. /* cDesc = ? */
    
                run commitWc( pcFileName, cDesc ).
    
            end. /* cTargetStatus <> "?" */
    
            else do:
    
                run updateDesc( output cDesc ).
    
                run addWc( pcFileName ).        
                run setWcProp( pcFileName, "change-desc", cDesc ).
    
                run commitWc( pcFileName, cDesc ).
    
            end. /* else */
    
        end. /* else */

    {slib/err_catch cError cErrorMsg cStackTrace}:

        message
            cErrorMsg
            skip(1)
            cStackTrace
        view-as alert-box.

    {slib/err_end}.
        
    if ttBuffer.cFullPath <> pcFileName then
       ttBuffer.cFullPath =  pcFileName.

end procedure. /* svn_saveFile */



function getWcInfo returns char private ( pcFullPath as char, pcField as char ): 

    define var cTempFile    as char no-undo.
    define var retval       as char no-undo.
    define var str          as char no-undo.
    define var i            as int no-undo.

    cTempFile = os_getTempFile( "", ".out" ).

    &if "{&opsys}" begins "win" &then

        run win_batch(
            input 'svn info "' + pcFullPath  + '" > "' + cTempFile + '"',
            input 'silent,wait' ).

    &else
        
        run unix_shell(
            input 'svn info "' + pcFullPath + '" > "' + cTempFile + '"',
            input 'silent,wait' ).

    &endif

    retval = ?.

    if search( cTempFile ) <> ? then do:

        input from value( cTempFile ).
        
        repeat:

            str = ?.

            import unformatted str.
            if str = ? then next.

            i = index( str, ":" ).
            if i = 0 then next.
            
            if trim( substr( str, 1, i - 1 ) ) = pcField then do:

                retval = trim( substr( str, i + 1 ) ).
                leave.

            end. /* substr = pcField */
            
        end. /* repeat */

        input close.

    end. /* search <> ? */
    
    os-delete value( cTempFile ).
    
    return retval.

end function. /* getWcInfo */

function getWcStatus returns char private ( pcFullPath as char ): 

    define var cTempFile    as char no-undo.
    define var retval       as char no-undo.
    define var str          as char no-undo.

    cTempFile = os_getTempFile( "", ".out" ).

    &if "{&opsys}" begins "win" &then

        run win_batch(
            input 'svn status "' + pcFullPath  + '" -v > "' + cTempFile + '"',
            input 'silent,wait' ).

    &else
        
        run unix_shell(
            input 'svn status "' + pcFullPath + '" -v > "' + cTempFile + '"',
            input 'silent,wait' ).

    &endif

    retval = ?.

    if search( cTempFile ) <> ? then do:

        str = "".
        
        input from value( cTempFile ).
        
        do on endkey undo, leave:
            import unformatted str.
        end.

        input close.
        
        if str = "" then
             retval = ?.
        else retval = substr( str, 1, 8 ).

    end. /* search <> ? */
    
    os-delete value( cTempFile ).
    
    return retval.

end function. /* getWcStatus */

function getWcProp returns char private ( pcFullPath as char, pcPropName as char ): 

    define var cTempFile    as char no-undo.
    define var retval       as char no-undo.

    cTempFile = os_getTempFile( "", ".out" ).

    &if "{&opsys}" begins "win" &then

        run win_batch(
            input 'svn propget "' + pcPropName + '" "' + pcFullPath  + '" > "' + cTempFile + '"',
            input 'silent,wait' ).

    &else
        
        run unix_shell(
            input 'svn propget "' + pcPropName + '" "' + pcFullPath  + '" > "' + cTempFile + '"',
            input 'silent,wait' ).

    &endif

    retval = ?.

    if search( cTempFile ) <> ? then do:

        input from value( cTempFile ).
        
        do on endkey undo, leave:
            import unformatted retval.
        end.

        input close.

        /* if there is no property the retval = null.

           if the property is set (even if it's blank) it will not be null. */

    end. /* search <> ? */

    os-delete value( cTempFile ).

    return retval.

end function. /* getWcProp */

function escapeProp returns char private ( pcProp as char ):

    define var retval   as char no-undo.
    define var str      as char no-undo.
    define var i        as int no-undo.
    define var j        as int no-undo.

    if pcProp = ? then
       pcProp = "".

    assign
        retval  = ""
        j       = length( pcProp ).

    do i = 1 to j:

        str = substr( pcProp, i, 1 ).

        if str = '~\' then
            retval = retval + '~\~\'.

        else
        if str = '"' then
            retval = retval + '~\"'.

        else
        if asc( str ) > 31 then /* printable characters */
            retval = retval + str.

    end. /* do i */

    return retval.

end function. /* escapeProp */



procedure commitWc private:

    define input param pcFullPath   as char no-undo.
    define input param pcDesc       as char no-undo.

    define var cCmd as char no-undo.

    &if "{&opsys}" begins "win" &then

        cCmd = 'svn commit "' + pcFullPath + '" -m "' + escapeProp( pcDesc ) + '" --username "' + cUserName + '"'.

        run win_batch(
            input cCmd,
            input 'silent,wait' ).

        if win_iErrorLevel <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( win_iErrorLevel )"}.

    &else

        cCmd = 'svn commit "' + pcFullPath + '" -m "' + escapeProp( pcDesc ) + '" --username "' + cUserName + '"'.

        run unix_shell(
            input cCmd,
            input 'silent,wait' ).

        if unix_iExitCode <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( unix_iExitCode )"}.

    &endif

end procedure. /* commitWc */

procedure revertWc private:

    define input param pcFullPath as char no-undo.

    define var cCmd as char no-undo.

    &if "{&opsys}" begins "win" &then

        cCmd = 'svn revert "' + pcFullPath + '" --username "' + cUserName + '"'.

        run win_batch(
            input cCmd,
            input 'silent,wait' ).

        if win_iErrorLevel <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( win_iErrorLevel )"}.

    &else

        cCmd = 'svn revert "' + pcFullPath + '" --username "' + cUserName + '"'.

        run unix_shell(
            input cCmd,
            input 'silent,wait' ).

        if unix_iExitCode <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( unix_iExitCode )"}.

    &endif

end procedure. /* revertWc */

procedure addWc private:

    define input param pcFullPath as char no-undo.

    define var cCmd as char no-undo.

    &if "{&opsys}" begins "win" &then

        cCmd = 'svn add "' + pcFullPath + '" --username "' + cUserName + '"'.

        run win_batch(
            input cCmd,
            input 'silent,wait' ).

        if win_iErrorLevel <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( win_iErrorLevel )"}.

    &else

        cCmd = 'svn add "' + pcFullPath + '" --username "' + cUserName + '"'.

        run unix_shell(
            input cCmd,
            input 'silent,wait' ).

        if unix_iExitCode <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( unix_iExitCode )"}.

    &endif

end procedure. /* addWc */

procedure copyWc private:

    define input param pcSource as char no-undo.
    define input param pcTarget as char no-undo.

    define var cCmd as char no-undo.

    &if "{&opsys}" begins "win" &then

        cCmd = 'svn copy "' + pcSource + '" "' + pcTarget + '" --username "' + cUserName + '"'.

        run win_batch(
            input cCmd,
            input 'silent,wait' ).

        if win_iErrorLevel <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( win_iErrorLevel )"}.

    &else

        cCmd = 'svn copy "' + pcSource + '" "' + pcTarget + '" --username "' + cUserName + '"'.

        run unix_shell(
            input cCmd,
            input 'silent,wait' ).

        if unix_iExitCode <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( unix_iExitCode )"}.

    &endif

end procedure. /* copyWc */

procedure mergeUrlWc private:

    define input param pcUrl        as char no-undo.
    define input param pcFullPath   as char no-undo.

    define var cCmd as char no-undo.

    &if "{&opsys}" begins "win" &then

        cCmd = 'svn merge --reintegrate "' + pcUrl + '" "' + pcFullPath + '" --accept theirs-full --username "' + cUserName + '"'.

        run win_batch(
            input cCmd,
            input 'silent,wait' ).

        if win_iErrorLevel <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( win_iErrorLevel )"}.

    &else

        cCmd = 'svn merge --reintegrate "' + pcUrl + '" "' + pcFullPath + '" --accept theirs-full --username "' + cUserName + '"'.

        run unix_shell(
            input cCmd,
            input 'silent,wait' ).

        if unix_iExitCode <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( unix_iExitCode )"}.

    &endif

end procedure. /* mergeUrlWc */

procedure deleteWc private:

    define input param pcFullPath as char no-undo.

    define var cCmd as char no-undo.

    &if "{&opsys}" begins "win" &then

        cCmd = 'svn delete "' + pcFullPath + '" --force --username "' + cUserName + '"'.

        run win_batch(
            input cCmd,
            input 'silent,wait' ).

        if win_iErrorLevel <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( win_iErrorLevel )"}.

    &else

        cCmd = 'svn delete "' + pcFullPath + '" --force --username "' + cUserName + '"'.

        run unix_shell(
            input cCmd,
            input 'silent,wait' ).

        if unix_iExitCode <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( unix_iExitCode )"}.

    &endif

end procedure. /* deleteWc */

procedure setWcProp private:

    define input param pcFullPath as char no-undo.
    define input param pcPropName as char no-undo.
    define input param pcPropVal  as char no-undo.

    define var cCmd as char no-undo.

    &if "{&opsys}" begins "win" &then

        cCmd = 'svn propset "' + pcPropName + '" "' + escapeProp( pcPropVal ) + '" "' + pcFullPath + '" --username "' + cUserName + '"'.

        run win_batch(
            input cCmd,
            input 'silent,wait' ).

        if win_iErrorLevel <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( win_iErrorLevel )"}.

    &else

        cCmd = 'svn propset "' + pcPropName + '" "' + escapeProp( pcPropVal ) + '" "' + pcFullPath + '" --username "' + cUserName + '"'.

        run unix_shell(
            input cCmd,
            input 'silent,wait' ).

        if unix_iExitCode <> 0 then
            {slib/err_throw "'os_util_error'" cCmd "string( unix_iExitCode )"}.

    &endif

end procedure. /* setWcProp */



procedure updateDesc private:

    define output param pcDesc as char no-undo.

    define button btnOk label "OK".
 
    &if "{&window-system}" = "tty" &then
    
        form
            space(1)
            "Description"
            skip
        
            space(1)
            pcDesc  view-as editor scrollbar-vertical size 50 by 10
                    no-label help "Press F1 to complete."
            
            space(1)
            skip
            btnOk
        with frame frmDesc title "Subversion" centered view-as dialog-box.

        assign
            frame frmDesc:parent    = current-window
            frame frmDesc:column    = ( current-window:width-chars  - frame frmDesc:width-chars ) / 2 + 1
            frame frmDesc:row       = ( current-window:height-chars - frame frmDesc:height-chars ) / 2 + 1

            btnOk:column            = ( frame frmDesc:width-chars - btnOk:width-chars ) / 2 + 1.

    &else

        form
            skip(.5)
            space(3) 
            "Description"
            skip

            space(3)
            pcDesc  view-as editor size 50 by 10 max-chars 100
                    no-label help "Press F1 to complete."
                    
            space(3)
            skip(.5)

            btnOk
            skip(.5)
        with frame frmDesc font 5 three-d title "Subversion" view-as dialog-box.

        assign
            frame frmDesc:parent    = current-window
            frame frmDesc:x         = ( session:work-area-width-pixels  - frame frmDesc:width-pixels ) / 2 + 1  - current-window:x
            frame frmDesc:y         = ( session:work-area-height-pixels - frame frmDesc:height-pixels ) / 2 + 1 - current-window:y

            btnOk:x                 = ( frmDesc:width-pixels - btnOk:width-pixels ) / 2 + 1.

    &endif

    on "end-error" of frame frmDesc anywhere do:

        return no-apply.

    end. /* end-error */

    on "return" of pcDesc in frame frmDesc do:
    
        return no-apply.
        
    end. /* return */



    pcDesc = "".

    do on stop undo, retry:

        update 
            pcDesc
            btnOk go-on( "choose" )
        with frame frmDesc.

    end. /* on stop undo, leave */

end procedure. /* updateDesc */
