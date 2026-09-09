
/**
 * slibqad.p -
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

{mfdeclre.i}

{slib/slibqadfrwd.i forward}

{slib/slibqadprop.i}

{slib/slibos.i}

/***
{slib/slibwidget.i}
***/

{slib/slibmath.i}



on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* close */

procedure initializeProc:

end procedure. /* initializeProc */



procedure qad_doCim:

    define input    param pcProgram as char no-undo.
    define input    param pcCimFile as char no-undo.
    define input    param pcLogFile as char no-undo.
    define input    param plDelete  as log no-undo.
    define output   param pcError   as char no-undo.
    define output   param pcWarning as char no-undo.

    define var batchlast    as log no-undo.
    define var str          as char no-undo.
    define var i            as int no-undo.

    if pcLogFile = ? then
       pcLogFile = os_getTempFile( "", ".log" ).

    input from value( pcCimFile ).
    output to value( pcLogFile ).

        assign
            batchlast   = batchrun
            batchrun    = yes.

        do on quit undo, leave
           on stop undo, leave
           on error undo, leave
           on endkey undo, leave:

            {gprun.i pcProgram}

        end. /* on quit */

        assign
            batchrun = batchlast.

    output close.
    input close.
    
    

    assign
        pcError     = ""
        pcWarning   = "".
    
    input from value( pcLogFile ).
    
    repeat:

        import unformatted str.
      
        if str begins "ERROR" then do:

            repeat while index( str, "  " ) > 0:
                str = replace( str, "  ", " " ).
            end.

            pcError = pcError
               + ( if pcError <> "" then "~n" else "" )
               + str.

        end. /* begins "error" */
    
        else
        if str matches "~~*~~* *~~. (*)" then do:

            i = r-index( str, "(" ).

            if math_isInt( substr( str, i + 1, length( str ) - i - 1 ) ) then

            pcError = pcError
               + ( if pcError <> "" then "~n" else "" )
               + str.

        end. /* str matches */

        else
        if str begins "WARNING" then do:

            repeat while index( str, "  " ) > 0:
                str = replace( str, "  ", " " ).
            end.

            pcWarning = pcWarning 
                 + ( if pcWarning <> "" then "~n" else "" )
                 + str.

        end. /* str begins "error" */

    end. /* repeat */

    input close.        

    if pcError <> "" then
       pcError = entry( 1, pcError, "~n" ).

    if pcError = "" then
       pcError = ?.

    if pcWarning = "" then
       pcWarning = ?.

    if plDelete then do:

        os-delete value( pcCimFile ).
        os-delete value( pcLogFile ). 

    end. /* plDelFiles */

end procedure. /* qad_doCim */



/***
procedure qad_loadDefaults:

    define buffer usrw_wkfl for usrw_wkfl.

    define var hContainerWidget as widget no-undo.
    define var cContainerType   as char no-undo.
    define var cContainerName   as char no-undo.

    define var cFieldWidgetList as char no-undo.
    define var cFieldNameList   as char no-undo.
    define var cFieldValueList  as char no-undo.

    define var wdgh             as widget no-undo.
    define var str              as char no-undo.
    define var i                as int no-undo.
    define var j                as int no-undo.

    find first usrw_wkfl
         where usrw_key1    = "screen-defaults"
           and usrw_key2    = program-name(2) + "," + global_userid

        &if {&xEb} = yes &then
           and usrw_domain  = global_domain
        &endif

         no-lock no-error.

    if not avail usrw_wkfl then
        return.

    assign
        cContainerType  = usrw_charfld[1]
        cContainerName  = usrw_charfld[2]
        cFieldNameList  = usrw_charfld[3]
        cFieldValueList = usrw_charfld[4].



    if cContainerName = ? then

        hContainerWidget = current-window.

    else do:

        hContainerWidget = widget_getWidget( current-window, cContainerType, cContainerName, ? ).

        if hContainerWidget = ? then
            return.

    end. /* container <> ? */



    cFieldWidgetList = widget_getWidgetList( hContainerWidget, "!window,!frame,!field-group,!text,!literal,*", cFieldNameList, ? ).

    do i = 1 to num-entries( cFieldWidgetList ):

        wdgh = widget-handle( entry( i, cFieldWidgetList ) ).

        j = lookup( wdgh:name, cFieldNameList ).
        if j = 0 then next.

        str = entry( j, cFieldValueList, chr(1) ).

        if str = chr(3) then
           str = ?.

        wdgh:screen-value = str no-error.

    end. /* 1 to num-entries */

end procedure. /* qad_loadDefaults */

procedure qad_saveDefaults:

    define input param phContainer      as widget no-undo. /* default frame a */
    define input param pcFieldNameList  as char no-undo.

    define buffer usrw_wkfl for usrw_wkfl.

    define var hContainerWidget as widget no-undo.
    define var cContainerType   as char no-undo.
    define var cContainerName   as char no-undo.

    define var cFieldWidgetList as char no-undo.
    define var cFieldNameList   as char no-undo.
    define var cFieldValueList  as char no-undo.

    define var wdgh             as widget no-undo.
    define var str              as char no-undo.
    define var i                as int no-undo.

    if phContainer = ? then
       phContainer = widget_getWidget( current-window, "frame", "a", ? ).

    if pcFieldNameList = "" then
       pcFieldNameList = ?.



    if valid-handle( phContainer ) then
    assign
        hContainerWidget    = phContainer
        cContainerType      = phContainer:type
        cContainerName      = phContainer:name.

    else
    assign
        hContainerWidget    = current-window
        cContainerType      = ?
        cContainerName      = ?.

    assign
        cFieldWidgetList    = widget_getWidgetList( hContainerWidget, "!window,!frame,!field-group,!text,!literal,*", pcFieldNameList, ? )
        cFieldNameList      = ?
        cFieldValueList     = ?.

    do i = 1 to num-entries( cFieldWidgetList ):

        wdgh = widget-handle( entry( i, cFieldWidgetList ) ).

        str = wdgh:screen-value.

        if str = ? then
           str = chr(3).

        if cFieldNameList = ? then
        assign
            cFieldNameList  = wdgh:name
            cFieldValueList = str.

        else
        assign
            cFieldNameList  = cFieldNameList    + "," + wdgh:name
            cFieldValueList = cFieldValueList   + chr(1) + str.

    end. /* 1 to num-entries */



    disable triggers for load of usrw_wkfl.
    disable triggers for dump of usrw_wkfl.

    do transaction:

        find first usrw_wkfl
             where usrw_key1    = "screen-defaults"
               and usrw_key2    = program-name(2) + "," + global_userid

            &if {&xEb} = yes &then
               and usrw_domain  = global_domain
            &endif

             exclusive-lock no-error.

        if not avail usrw_wkfl then do:

            create usrw_wkfl.
            assign

            &if {&xEb} = yes &then
                usrw_domain = global_domain
            &endif

                usrw_key1   = "screen-defaults"
                usrw_key2   = program-name(2) + "," + global_userid.

        end. /* not avail usrw_wkfl */

        assign
            usrw_charfld[1] = cContainerType
            usrw_charfld[2] = cContainerName
            usrw_charfld[3] = cFieldNameList
            usrw_charfld[4] = cFieldValueList.

    end. /* trans */

end procedure. /* qad_saveDefaults */
***/



function qad_isMutexExists returns log ( pcMutex as char ):

    define buffer usrw_wkfl for usrw_wkfl.

    define var iUserId  as int no-undo.
    define var iPid     as int no-undo.

&if {&xEb} = yes &then
    define var cMfgUser as char no-undo.
&endif

    disable triggers for load of usrw_wkfl.
    disable triggers for dump of usrw_wkfl.

    do transaction:

        find first usrw_wkfl
             where usrw_key1    = pcMutex
               and usrw_key2    = ""

            &if {&xEb} = yes &then
               and usrw_domain  = global_domain
            &endif

             exclusive-lock no-wait no-error.

        if avail usrw_wkfl then do:

            assign

            &if {&xEb} = yes &then
                cMfgUser    = usrw_charfld[1]
            &endif

                iUserId     = usrw_decfld[1]
                iPid        = usrw_decfld[2].

            if  not can-find(
                first _connect
                where _connect._connect-usr = iUserId
                  and _connect._connect-pid = iPid )

        &if {&xEb} = yes &then
             or cMfgUser <> ?
            and not can-find(
                first sess_mstr
                where sess_mfguser = cMfgUser )
        &endif

             or can-find(
                first _myconnection
                where _myconnection._myconn-userid  = iUserId
                  and _myconnection._myconn-pid     = iPid )

        &if {&xEb} = yes &then
            and ( cMfgUser = ?
               or cMfgUser = mfguser ) 
        &endif

                then delete usrw_wkfl.

        end. /* avail usrw_wkfl */

    end. /* trans */



    if can-find(
        first usrw_wkfl
        where usrw_key1     = pcMutex
          and usrw_key2     = ""

        &if {&xEb} = yes &then
          and usrw_domain   = global_domain
        &endif 

            ) then

        return yes.

    return no.

end function. /* qad_isMutexExists */

procedure qad_createMutex:

    define input param pcMutex as char no-undo.

    define buffer usrw_wkfl for usrw_wkfl.

    define var iUserId  as int no-undo.
    define var iPid     as int no-undo.

&if {&xEb} = yes &then
    define var cMfgUser as char no-undo.
&endif

    disable triggers for load of usrw_wkfl.
    disable triggers for dump of usrw_wkfl.

    do transaction:

        find first _myconnection no-lock no-error.

        assign
            iUserId = _myconnection._myconn-userid
            iPid    = _myconnection._myconn-pid.

    &if {&xEb} = yes &then
        cMfgUser = ?.

        find first sess_mstr
             where sess_mfguser = mfguser
             no-lock no-error.

        if avail sess_mstr then

            cMfgUser = sess_mfguser.
    &endif



        find first usrw_wkfl
             where usrw_key1    = pcMutex
               and usrw_key2    = ""

            &if {&xEb} = yes &then
               and usrw_domain  = global_domain
            &endif

             exclusive-lock no-error.

        if not avail usrw_wkfl then do:

            create usrw_wkfl.
            assign

            &if {&xEb} = yes &then
                usrw_domain = global_domain
            &endif

                usrw_key1   = pcMutex
                usrw_key2   = "".

        end. /* not avail usrw_wkfl */

        assign

        &if {&xEb} = yes &then
            usrw_charfld[1] = cMfgUser
        &endif

            usrw_decfld[1]  = iUserId
            usrw_decfld[2]  = iPid.

    end. /* trans */

end procedure. /* qad_createMutex */

procedure qad_deleteMutex:

    define input param pcMutex as char no-undo.

    define buffer usrw_wkfl for usrw_wkfl.

    disable triggers for load of usrw_wkfl.
    disable triggers for dump of usrw_wkfl.

    do transaction:

        find first usrw_wkfl
             where usrw_key1    = pcMutex
               and usrw_key2    = ""

            &if {&xEb} = yes &then
               and usrw_domain  = global_domain
            &endif

             exclusive-lock no-error.

        if avail usrw_wkfl then

            delete usrw_wkfl.

    end. /* trans */

end procedure. /* qad_deleteMutex */
