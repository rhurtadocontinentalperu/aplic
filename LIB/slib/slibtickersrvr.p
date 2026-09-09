
/**
 * slibtickersrvr.p 
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

{slib/slibtickerprop.i}

{slib/sliberr.i}



define temp-table ttClient no-undo

    field hClient as handle.
        
define var hServer as handle no-undo.



{slib/err_try}:

    create server-socket hServer.

    hServer:set-connect-procedure( "connProc" ) {slib/err_no-error}.
    hServer:enable-connections( "-S {&tick_xServerPort}" ) {slib/err_no-error}.

    repeat:

        for each ttClient:

            if not valid-handle( ttClient.hClient ) 
            or not ttClient.hClient:connected( ) then do:
            
                delete object ttClient.hClient.  
                delete ttClient.
 
            end. /* not connected */  
            
        end. /* each ttClient */

        for each ttClient:

            run writeSocket( ttClient.hClient, "Tick" ).

        end. /* each ttClient */  



        etime( yes ).

        repeat while etime( no ) / 1000 < {&tick_xInterval}:

            wait-for "connect" of hServer pause 1.
        
        end.  /* repeat */

    end. /* repeat */ 

{slib/err_finally}:

    hServer:disable-connections( ) no-error.
    delete object hServer.

    for each ttClient:

        ttClient.hClient:disconnect( ) no-error.
        delete object ttClient.hClient.

        delete ttClient.

    end. /* each ttClient */

{slib/err_end}.

quit.



procedure connProc:

    define input param phSocket as handle no-undo.

    if not valid-handle( phSocket ) then
        return.

    create ttClient.
    assign ttClient.hClient = phSocket.               

    run writeSocket( phSocket, "I am Ticker" ).

end procedure. /* connProc */

procedure writeSocket:

    define input param phSocket as handle no-undo.
    define input param pcMsg    as char no-undo.
        
    define var pBuffer  as memptr no-undo.
    define var iLen     as int no-undo.  
    define var lOK      as logi no-undo.

    if not valid-handle( phSocket ) then 
        return error.



    iLen = length( pcMsg ).
    
    set-size( pBuffer ) = iLen.
  
    {slib/err_try}:
    
        put-string( pBuffer, 1, iLen ) = pcMsg {slib/err_no-error}.

        phSocket:write( pBuffer, 1, iLen ) {slib/err_no-error}.

    {slib/err_finally}:
        
        set-size( pBuffer ) = 0.
    
    {slib/err_end}.

end procedure. /* writeSocket */
