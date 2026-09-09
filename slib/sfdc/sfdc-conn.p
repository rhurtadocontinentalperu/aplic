
/**
 * sfdc-conn.i -
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
 *  Mobile phone: +972-54-218-8086
 *
 */

{libsfdc.i}

{liberr.i}

define input param pcUsername as char no-undo.
define input param pcPassword as char no-undo.
define input param pcToken    as char no-undo.



{LoginResponseDS.i}

define var hWebService  as handle no-undo.
define var hPortType    as handle no-undo.
define var hSOAPHeader  as handle no-undo.

define var cSessionID   as char no-undo.
define var cUserID      as char no-undo.
define var iBatchSize   as int no-undo.
define var lUpdateMRU   as log no-undo.
define var iTimeDiff    as int no-undo.



on "close" of this-procedure do:

    delete procedure hPortType no-error.
    hWebService:disconnect( ) no-error.

    delete object hWebService no-error.
    delete object hSOAPHeader no-error.

end. /* close of this-procedure */

run initializeProc.

procedure initializeProc private:

    {slib/err_try}:
        
        run sfdc_login(
            input   pcUsername,
            input   pcPassword,
            input   pcToken,
            output  hWebService,
            output  hPortType,
            output  dataset dsLoginResponse by-reference ).
        
        find first ttLoginResponse no-error.
        find first ttLoginResponse_UserInfo no-error.

        if not ( avail ttLoginResponse
             and avail ttLoginResponse_UserInfo ) then 

            {slib/err_throw "'sfdc_conn_failed'"}.

        assign
            cSessionID  = ttLoginResponse.tsessionID
            cUserID     = ttLoginResponse.tuserID
            iBatchSize  = ?
            lUpdateMRU  = ?.

        hPortType:set-callback-procedure( "request-header", "requestHandler", this-procedure ).
     /* hPortType:set-callback-procedure( "response-header", "responseHandler", this-procedure ). */

    {slib/err_catch}:
        
        apply "close" to this-procedure.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* initializeProc */

procedure requestHandler:

    define output   param phSOAPHeader  as handle no-undo.
    define input    param pcNamespace   as char no-undo.
    define input    param pcLocalName   as char no-undo.
    define output   param plDelete      as log no-undo.

    assign
        phSOAPHeader    = hSOAPHeader
        plDelete        = yes.

end procedure. /* requestHandler */

procedure responseHandler:

    define input param phSOAPHeader as handle no-undo.
    define input param pcNamespace  as char no-undo.
    define input param pcLocalName  as char no-undo.

    delete object phSOAPHeader no-error.

end procedure. /* responseHandler */



procedure sfdc_setSOAPHeader:

    define input param phSOAPHeader as handle no-undo.

    if valid-handle( hSOAPHeader ) then
       delete object hSOAPHeader no-error.

    hSOAPHeader = phSOAPHeader.

end procedure. /* sfdc_setSOAPHeader */

procedure sfdc_setBatchSize:

    define input param piBatchSize as int no-undo.

    iBatchSize = piBatchSize.

end procedure. /* sfdc_setBatchSize */

procedure sfdc_setUpdateMRU:

    define input param plUpdateMRU as log no-undo.

    lUpdateMRU = plUpdateMRU.

end procedure. /* sfdc_setBatchSize */

function sfdc_getWebService returns handle:

    return hWebService.

end function. /* sfdc_getWebService */

function sfdc_getPortType returns handle:

    return hPortType.

end function. /* sfdc_getPortType */

function sfdc_getSOAPHeader returns handle:

    return hSOAPHeader.

end function. /* sfdc_getSOAPHeader */

function sfdc_getSessionID returns char:

    return cSessionID.

end function. /* sfdc_getSessionID */

function sfdc_getUserID returns char:

    return cUserID.

end function. /* sfdc_getUserID */

function sfdc_getBatchSize returns int:

    return iBatchSize.

end function. /* sfdc_getBatchSize */

function sfdc_getUpdateMRU returns log:

    return lUpdateMRU.

end function. /* sfdc_getBatchSize */
