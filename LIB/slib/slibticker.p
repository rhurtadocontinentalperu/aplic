
/**
 * slibticker.p 
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

define var hSocket  as handle no-undo.
define var cLastMsg as char no-undo.



{slib/err_try}:

    create socket hSocket.
    hSocket:set-read-response-procedure( "readProc" ) {slib/err_no-error}.

    hSocket:connect( "-H {&tick_xServerHost} -S {&tick_xServerPort}" )
        {slib/err_no-error}.


    
    cLastMsg = ?.
    
    wait-for "read-response" of hSocket pause 10.
    
    if cLastMsg <> "I am Ticker" then
        {slib/err_throw "'tick_server_connect_failed'"}.

{slib/err_catch}:

    if valid-handle( hSocket ) and hSocket:connected( ) then
        hSocket:disconnect( ) no-error.

    delete object hSocket.

{slib/err_end}.



procedure readProc:

    define var pBuffer  as memptr no-undo.
    define var cMsg     as char no-undo.
    define var iLen     as int no-undo.

    cLastMsg = ?.
    
    iLen = hSocket:get-bytes-available( ).  

    if iLen > 0 then do:

        {slib/err_try}:
        
            set-size( pBuffer ) = iLen.

            hSocket:read( pBuffer, 1, iLen ).
            
            cLastMsg = get-string( pBuffer, 1, iLen ).
               
        {slib/err_finally}:

            set-size( pBuffer ) = 0.          
            
        {slib/err_end}.
    
    end. /* iLen > 0 */  

    if cLastMsg = "Tick" then publish "Tick".

end procedure. /* readProc */

