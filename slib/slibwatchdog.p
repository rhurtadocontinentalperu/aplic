
/**
 * slibwatchdog.p -
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
 *  Phone: +972-54-218-8086
 */

{slib/slibwatchdogprop.i}

{slib/slibos.i}

{slib/slibunix.i}



on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* close */

procedure intializeProc:

end procedure. /* initializeProc */



/* usrw_key1        - "idle_time"       */
/* usrw_key2        - "pid,username"    */
/* usrw_decfld[1]   - pid               */
/* usrw_charfld[1]  - username          */
/* usrw_decfld[2]   - io db access      */
/* usrw_datefld[1]  - update date       */
/* usrw_decfld[3]   - update time       */

procedure watchdog_updateIdleTime:

    define buffer usrw_wkfl for usrw_wkfl.

    define var cKey2    as char no-undo.

    for each  usrw_wkfl
        where usrw_key1 = "idle_time"
      
          and not can-find(
            first qaddb._connect
            where qaddb._connect._connect-pid   = usrw_decfld[1]
              and qaddb._connect._connect-name  = usrw_charfld[1] )

            /* both name and pid are used incase the pid is recycled and not 
               promised to be unique. */
        
        exclusive-lock

        transaction:
    
        delete usrw_wkfl.

    end. /* each usrw_wkfl */

    for each  qaddb._connect
        where qaddb._connect._connect-usr <> ?
          and qaddb._connect._connect-name <> "root"

          and not can-find(
            first code_mstr
            where code_fldname  = "kill_exclude_users"
              and lookup( qaddb._connect._connect-name, code_value ) > 0 )
      
        no-lock,
    
        each  qaddb._userio
        where qaddb._userio._userio-usr = qaddb._connect._connect-usr
        no-lock
        
        transaction:
    
        cKey2 = string( qaddb._connect._connect-pid ) 
                + "," + qaddb._connect._connect-name.
       
        find first usrw_wkfl
             where usrw_key1 = "idle_time"
               and usrw_key2 = cKey2
             exclusive-lock no-error.
         
        if not avail usrw_wkfl then do:
    
            create usrw_wkfl.
            assign
                usrw_key1       = "idle_time"
                usrw_key2       = cKey2
                usrw_decfld[1]  = qaddb._connect._connect-pid
                usrw_charfld[1] = qaddb._connect._connect-name
                usrw_decfld[2]  = 0.
    
        end. /* not avail usrw_wkfl */
    
        if usrw_decfld[2] <> qaddb._userio._userio-dbaccess then
        assign
            usrw_decfld[2]  = qaddb._userio._userio-dbaccess
            usrw_datefld[1] = today
            usrw_decfld[3]  = time.
        
    end. /* each _connect */

end procedure. /* watchdog_updateIdleTime */

procedure watchdog_killIdleUsers:

    define buffer watchdog_ttSession for watchdog_ttSession.

    run watchdog_fillSession( output table watchdog_ttSession ).
     
    for each  watchdog_ttSession
        where {slib/date_intervaltime
            today 
            time
            watchdog_ttSession.tLastUpdateDate
            watchdog_ttSession.iLastUpdateTime} > {&watchdog_xIdleTimeout}:
                
        run watchdog_killUser( watchdog_ttSession.iPid ).
                  
    end. /* each watchdog_ttSession */                 

end procedure. /* watchdog_killIdleUsers */

procedure watchdog_killUser:

    define input param piPid as int no-undo.

    define var hQuery   as handle no-undo.
    define var hBuffer  as handle no-undo.
    define var hField   as handle no-undo.

    define var cLDbName as char no-undo.
    define var cPDbName as char no-undo.
    define var iDb      as int no-undo.
    define var iUsr     as int no-undo.
     
    create widget-pool.
    
    do iDb = 1 to num-dbs:
    
        assign
            cLDbName = ldbname( iDb )
            cPDbName = pdbname( iDb ).

        create query  hQuery.
        create buffer hBuffer for table cLDbName + "._connect".
       
        hField = hBuffer:buffer-field( "_connect-usr" ).

        hQuery:set-buffers( hBuffer ).
        hQuery:query-prepare( substitute( 

            "for each  &1._connect ~n" +
            "    where &1._connect._connect-pid = &2 ~n" +
            "    no-lock", 

            cLDbName,
            string( piPid ) ) ).
        
        hQuery:query-open( ).

        do while hQuery:get-next( ):

            iUsr = hField:buffer-value.
            
            run unix_shell(

                input substitute( 
                      "proenv~n" +
                      "cd &3~n" +
                      "proshut &2 -C disconnect &1",
                    
                      string( iUsr ),
                      os_getSubPath( cPDbName, "file", "file" ),
                      os_getSubPath( cPDbName, "dir", "dir" ) ), 
                
                input "silent,wait" ).
 
        end. /* get-next */

        hQuery:query-close( ).

        delete object hQuery.
        delete object hBuffer.

    end. /* do iDb */



    run unix_shell(
        input substitute( "ps -p &1", string( piPid ) ), 
        input "silent,wait" ).

    if unix_iExitCode = 0 then do:
    
        pause 2.
    
        run unix_shell(
            input substitute( "ps -p &1", string( piPid ) ), 
            input "silent,wait" ).
    
        if unix_iExitCode = 0 then do:

            run unix_shell(
                input substitute( "kill -1 &1", string( piPid ) ), 
                input "silent,wait" ).
    
            pause 2.
    
            run unix_shell(
                input substitute( "ps -p &1", string( piPid ) ), 
                input "silent,wait" ).
        
            if unix_iExitCode = 0 then do:
        
                run unix_shell(
                    input substitute( "kill -9 &1", string( piPid ) ), 
                    input "silent,wait" ).
    
            end. /* exitcode 0 */
            
        end. /* exitcode 0 */

    end. /* exitcode 0 */

end procedure. /* watchdog_killUser */



procedure watchdog_fillSession:

    define output param table for watchdog_ttSession.

    empty temp-table watchdog_ttSession.
    
    run watchdog_updateIdleTime.
    
    for each  usrw_wkfl
        where usrw_key1 = "idle_time"
        no-lock:
        
        find first watchdog_ttSession
             where watchdog_ttSession.iPid      = int( usrw_decfld[1] )
               and watchdog_ttSession.cUsername = usrw_charfld[1]
             no-error.
             
        if not avail watchdog_ttSession then do:
        
            create watchdog_ttSession.
            assign
                watchdog_ttSession.iPid              = int( usrw_decfld[1] )
                watchdog_ttSession.cUsername         = usrw_charfld[1]
                watchdog_ttSession.tLastUpdateDate   = usrw_datefld[1]
                watchdog_ttSession.iLastUpdateTime   = usrw_decfld[3].
        
        end. /* not avail ttSession */
        
        if  usrw_datefld[1] > watchdog_ttSession.tLastUpdateDate
        or  usrw_datefld[1] = watchdog_ttSession.tLastUpdateDate
        and usrw_decfld[3]  > watchdog_ttSession.iLastUpdateTime then
        
        assign
            watchdog_ttSession.tLastUpdateDate      = usrw_datefld[1]
            watchdog_ttSession.iLastUpdateTime      = usrw_decfld[3].
        
    end. /* usrw_wkfl */

end procedure. /* watchdog_fillSession */

