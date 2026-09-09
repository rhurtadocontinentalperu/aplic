
/**
 * watchdog.p -
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

{slib/utils/watchdogprop.i}

{slib/slibos.i}

{slib/slibunix.i}

{slib/slibpro.i}



define temp-table ttSession no-undo

    field iPid              as int
    field cUsername         as char
    field dLastIoDbAccess   as dec
    field tLastUpdateDate   as date
    field iLastUpdateTime   as int

    index PidUsername is primary unique
          iPid
          cUsername.



run loadSessions.

run updateIdleTime.

run killIdleSessions.

run saveSessions.



procedure killIdleSessions private:

    define buffer ttSession for ttSession.

    for each  ttSession
        where {slib/date_intervaltime
            today 
            time
            ttSession.tLastUpdateDate
            ttSession.iLastUpdateTime} > {&watchdog_xIdleTimeout}:
                
        run killSession( buffer ttSession ).
                  
    end. /* for each ttSession */                 

end procedure. /* killIdleSessions */

procedure killSession private:

    define param buffer pbSession for ttSession.

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
            string( pbSession.iPid ) ) ).
        
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
                
                input "wait" ).
 
        end. /* get-next */

        hQuery:query-close( ).

        delete object hQuery.
        delete object hBuffer.

    end. /* do iDb */



    run unix_shell(
        input substitute( "ps -p &1", string( pbSession.iPid ) ), 
        input "silent,wait" ).

    if unix_iExitCode = 0 then do:
    
        pause 2.
    
        run unix_shell(
            input substitute( "ps -p &1", string( pbSession.iPid ) ), 
            input "silent,wait" ).
    
        if unix_iExitCode = 0 then do:

            run unix_shell(
                input substitute( "kill -1 &1", string( pbSession.iPid ) ), 
                input "silent,wait" ).
    
            pause 2.
    
            run unix_shell(
                input substitute( "ps -p &1", string( pbSession.iPid ) ), 
                input "silent,wait" ).
        
            if unix_iExitCode = 0 then do:
        
                run unix_shell(
                    input substitute( "kill -9 &1", string( pbSession.iPid ) ), 
                    input "silent,wait" ).
    
            end. /* exitcode 0 */
            
        end. /* exitcode 0 */

    end. /* exitcode 0 */
    
    delete pbSession.

end procedure. /* killSession */

procedure updateIdleTime private:

    define buffer ttSession for ttSession.

    for each  ttSession

        where not can-find(
            first {&watchdog_xMainDatabase}._connect
            where {&watchdog_xMainDatabase}._connect._connect-pid   = ttSession.iPid
              and {&watchdog_xMainDatabase}._connect._connect-name  = ttSession.cUsername ):

            /* both name and pid are used incase the pid is recycled and not promised to be unique. */
            
        delete ttSession.

    end. /* for each ttSession */

    for each  {&watchdog_xMainDatabase}._connect
        where lookup( {&watchdog_xMainDatabase}._connect._connect-type, "self,remc,btch" ) > 0
            and {&watchdog_xMainDatabase}._connect._connect-name <> "root"
            and lookup( {&watchdog_xMainDatabase}._connect._connect-name, {&watchdog_xExcludeUsers} ) = 0
        no-lock,
    
        each  {&watchdog_xMainDatabase}._userio
        where {&watchdog_xMainDatabase}._userio._userio-usr = {&watchdog_xMainDatabase}._connect._connect-usr
        no-lock:

        find first ttSession
             where ttSession.iPid       = {&watchdog_xMainDatabase}._connect._connect-pid
               and ttSession.cUsername  = {&watchdog_xMainDatabase}._connect._connect-name
             no-error.
         
        if not avail ttSession then do:
    
            create ttSession.
            assign
                 ttSession.iPid             = {&watchdog_xMainDatabase}._connect._connect-pid
                 ttSession.cUsername        = {&watchdog_xMainDatabase}._connect._connect-name
                 ttSession.dLastIoDbAccess  = 0.0.

        end. /* not avail ttSession */
    
        if ttSession.dLastIoDbAccess <> {&watchdog_xMainDatabase}._userio._userio-dbaccess then
        assign
            ttSession.dLastIoDbAccess   = {&watchdog_xMainDatabase}._userio._userio-dbaccess
            ttSession.tLastUpdateDate   = today
            ttSession.iLastUpdateTime   = time.
        
    end. /* each _connect */

end procedure. /* updateIdleTime */

procedure loadSessions private:

    define buffer ttSession for ttSession.

    define var cFileName as char no-undo.

    empty temp-table ttSession.

    cFileName = os_normalizePath( pro_cWorkDir + "/watchdog.d" ).
    if not os_isFileExists( cFileName ) then

        return.

    input from value( cFileName ).

    repeat:

        create ttSession.
        import ttSession.

    end. /* repeat */

    if avail ttSession then
      delete ttSession.

    input close. /* cFileName */

end procedure. /* loadSessions */

procedure saveSessions private:

    define buffer ttSession for ttSession.

    define var cFileName as char no-undo.

    cFileName = os_normalizePath( pro_cWorkDir + "/watchdog.d" ).

    output to value( cFileName ).

    for each ttSession:
        export ttSession.
    end.

    output close. /* cFileName */

end procedure. /* saveSessions */

