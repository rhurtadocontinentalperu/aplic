
/**
 * svn_import_checkout.p -
 *
 * (c) Copyright 2009 ABC Alon Blich Consulting Tech, Ltd.
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
 *  Phone: +972-54-218-8086
 */

{libos.i}

&if "{&opsys}" begins "win" &then

    {libwin.i}

&else

    {libunix.i}

&endif

{libdate.i}

{liberr.i}

{libpro.i}



function isSrcExists returns log

    ( pcDir as char ) forward.



/* parameters */

&global xProjectUrl 'file:///c:/svntest/lib'
&global xProjectDir 'c:\lib'
&global xExcludeDir ''



define temp-table ttDir no-undo

    field cDir      as char
    field cDirBak   as char
    field cDirSrc   as char
    field cDirUrl   as char

    index cDir is primary unique
          cDir.

define var cProjectBakDir   as char no-undo.
define var cProjectSrcDir   as char no-undo.

define var cError           as char no-undo.
define var cErrorMsg        as char no-undo.



{slib/err_try}:

    run fillDir.

    run backupDir.

    run checkBackup.



    run copySource.
    
    run importDir.

    run checkoutDir.

{slib/err_catch cError cErrorMsg}:

    message replace( cErrorMsg, chr(1), "~n" ) view-as alert-box.

{slib/err_end}.



procedure fillDir:
    
    define var str as char no-undo.

    empty temp-table ttDir.

    run fillDirRecurr( {&xProjectDir} ).



    str = "".

    for each ttDir:

        str = str
            + ( if str <> "" then "~n" else "" )
            + ttDir.cDir.

    end. /* each ttDir */
    
    message
        str
    view-as alert-box info buttons yes-no-cancel
        title "Confirm" update lConfirm as log.

    if lConfirm = no or lConfirm = ? /* ? = cancel */ then
        {slib/err_stop}.

end procedure. /* fillDir */

procedure fillDirRecurr:
     
    define input param pcDir as char no-undo.

    define var cFileName as char no-undo.
    define var cFullPath as char no-undo.
    define var cAttrList as char no-undo.

    if isSrcExists( pcDir ) then do:

        if not can-find(
            first ttDir
            where ttDir.cDir = pcDir ) then do:

            create ttDir.
            assign ttDir.cDir = pcDir.

        end. /* not can-find */

    end. /* isSrcExists */



    input from os-dir( pcDir ).

    repeat:

        import
            cFileName
            cFullPath
            cAttrList.
    
        if cFileName = "."
        or cFileName = ".." then
            next.

        if cFileName = ".svn" then
            next.

        if can-do( {&xExcludeDir}, cFileName ) then
            next.

        if index( cAttrList, "d" ) > 0 then
            run fillDirRecurr( cFullPath ).
    
    end. /* repeat */

    input close. /* os-dir */

end procedure. /* fillDirRecurr */

function isSrcExists returns log ( pcDir as char ):

    define var cFileName as char no-undo.
    define var cFullPath as char no-undo.
    define var cAttrList as char no-undo.

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
            next.

        if can-do( "*~~.p,*~~.w,*~~.i,*~~.htm*,*~~.ini,*~~.pf,*~~.cls", cFileName ) then
            return yes.
    
    end. /* repeat */

    input close. /* os-dir */

    return no.

end function. /* isSrcExists */



procedure backupDir:
    
    define var cFileName as char no-undo.
    define var cFullPath as char no-undo.
    define var cAttrList as char no-undo.

    cProjectBakDir = os_getNextFile( {&xProjectDir} + "/bak-" + date_date2str( today, 0, 0, "yyyy-mm-dd" ) ).

    run os_createDir( cProjectBakDir ).

    for each ttDir:

        ttDir.cDirBak = replace( ttDir.cDir, {&xProjectDir}, cProjectBakDir ).

        run os_createDir( ttDir.cDirBak ).



        input from os-dir( ttDir.cDir ).

        repeat:
        
            import
                cFileName
                cFullPath
                cAttrList.
        
            if cFileName = "."
            or cFileName = ".." then
                next.

            if index( cAttrList, "d" ) > 0 then
                next.

            if not can-do( "*~~.p,*~~.w,*~~.i,*~~.htm*,*~~.r,*~~.ini,*~~.pf,*~~.cls", cFileName ) then 
                next.

            os-copy value( cFullPath ) value( ttDir.cDirBak ).
        
        end. /* repeat */

        input close. /* os-dir */
        
    end. /* each ttDir */

end procedure. /* backupDir */

procedure checkBackup:

    define var cFileName as char no-undo.
    define var cFullPath as char no-undo.
    define var cAttrList as char no-undo.

    for each ttDir:

        input from os-dir( ttDir.cDir ).

        repeat:
        
            import
                cFileName
                cFullPath
                cAttrList.
        
            if cFileName = "."
            or cFileName = ".." then
                next.

            if index( cAttrList, "d" ) > 0 then
                next.

            if not can-do( "*~~.p,*~~.w,*~~.i,*~~.htm*,*~~.r,*~~.ini,*~~.pf,*~~.cls", cFileName ) then 
                next.

            if not os_isFileExists( ttDir.cDirBak + "/" + cFileName ) then
                {slib/err_throw "'error'" "cFullPath + ' has not been backed up.'"}.

        end. /* repeat */

        input close. /* os-dir */
        
    end. /* each ttDir */

end procedure. /* checkBackup */



procedure copySource:
 
    define var cFileName as char no-undo.
    define var cFullPath as char no-undo.
    define var cAttrList as char no-undo.

    cProjectSrcDir = os_getNextFile( {&xProjectDir} + "/src" ).

    run os_createDir( cProjectSrcDir ).

    for each ttDir:

        ttDir.cDirSrc = replace( ttDir.cDir, {&xProjectDir}, cProjectSrcDir ).

        run os_createDir( ttDir.cDirSrc ).



        input from os-dir( ttDir.cDir ).

        repeat:
        
            import
                cFileName
                cFullPath
                cAttrList.
        
            if cFileName = "."
            or cFileName = ".." then
                next.

            if index( cAttrList, "d" ) > 0 then
                next.

            if not can-do( "*~~.p,*~~.w,*~~.i,*~~.htm*,*~~.ini,*~~.pf,*~~.cls", cFileName ) then 
                next.

            os-copy value( cFullPath ) value( ttDir.cDirSrc ).
        
        end. /* repeat */

        input close. /* os-dir */
        
    end. /* each ttDir */

end procedure. /* copySource */

procedure importDir:

    define var str as char no-undo.

    for each ttDir:

        assign
            str = replace( ttDir.cDir, {&xProjectDir}, {&xProjectUrl} )
            str = replace( str, "~\", "/" )
            str = trim( str, "/" ).

        ttDir.cDirUrl = str.



        &if "{&opsys}" begins "win" &then

            str = 'svn import "' + ttDir.cDirSrc + '" "' + ttDir.cDirUrl + '" -m ""'.

            run win_batch( 
                input str,
                input 'silent,wait' ).  

            if win_iErrorLevel <> 0 then
                {slib/err_throw "'error'" "str + ' failed with Exit Code ' + string( win_iErrorLevel )"}.

        &else

            str = 'svn import "' + ttDir.cDirSrc + '" "' + ttDir.cDirUrl + '" -m ""'.

            run unix_shell(
                input str,
                input 'silent,wait' ).

            if unix_iExitCode <> 0 then
                {slib/err_throw "'error'" "str + ' failed with Exit Code ' + string( unix_iExitCode )"}.
        
        &endif

    end. /* each ttDir */

end procedure. /* importDir */

procedure checkoutDir:

    define var cFileName    as char no-undo.
    define var cFullPath    as char no-undo.
    define var cAttrList    as char no-undo.
    define var str          as char no-undo.

    for each ttDir:

        input from os-dir( ttDir.cDir ).

        repeat:
        
            import
                cFileName
                cFullPath
                cAttrList.
        
            if cFileName = "."
            or cFileName = ".." then
                next.

            if index( cAttrList, "d" ) > 0 then do:
            
                if  cFileName =  ".svn"  
                and os_isDirExists( cFullPath ) then do:
                    
                    run os_deleteDir( cFullPath ).

                    if os_isDirExists( cFullPath ) then
                        {slib/err_throw "'dir_delete_failed'" cFullPath}. 
                
                end. /* cFileName =  ".svn" */

                else next.
                          
            end. /* index( cAttrList, "d" ) */ 
            
            if not can-do( "*~~.p,*~~.w,*~~.i,*~~.htm*", cFileName ) then 
                next.

            os-delete value( cFullPath ).

        end. /* repeat */

        input close. /* os-dir */



        &if "{&opsys}" begins "win" &then
        
            str = 'svn checkout "' + ttDir.cDirUrl + '" "' + ttDir.cDir + '" -N'.

            run win_batch( 
                input str,
                input 'silent,wait' ).

            if win_iErrorLevel <> 0 then
                {slib/err_throw "'error'" "str + ' failed with Exit Code ' + string( win_iErrorLevel )"}.
        
        &else

            str = 'svn checkout "' + ttDir.cDirUrl + '" "' + ttDir.cDir + '" -N'.

            run unix_shell(
                input str,
                input 'silent,wait' ).            

            if unix_iExitCode <> 0 then
                {slib/err_throw "'error'" "str + ' failed with Exit Code ' + string( unix_iExitCode )"}.

        &endif

    end. /* each ttDir */

    os-delete value( cProjectSrcDir ) recursive.

end procedure /* checkoutDir */
