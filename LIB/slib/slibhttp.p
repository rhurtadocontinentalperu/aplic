
/**
 * slibhttp.p -
 *
 * note that the library uses http 1.0
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

{slib/slibhttpfrwd.i "forward"}

{slib/slibhttpprop.i}

{slib/slibmath.i}

{slib/sliberr.i}



define temp-table ttPacket no-undo

    field rData     as raw
    field iSize     as int
    field iStart    as int

    index iStart is primary unique
          iStart.

define var iBytesReceived as int no-undo.



on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* on close */

procedure initializeProc:

end procedure. /* initializeProc */



procedure http_get:

    define input    param pcUrl             as char no-undo.
    define input    param piTimeout         as int no-undo.
    define input    param pcReqHeaderLines  as char no-undo.

    define output   param pcResStatusLine   as char no-undo.
    define output   param pcResHeaderLines  as char no-undo.
    define output   param ppResBody         as memptr no-undo.

    define var ptr as memptr no-undo.
    set-size( ptr ) = 0.

    run http_transaction(
        input   pcUrl,
        input   piTimeout,

        input   "GET",
        input   pcReqHeaderLines,
        input   ptr,

        output  pcResStatusLine,
        output  pcResHeaderLines,
        output  ppResBody ).

end procedure. /* http_get */

procedure http_post:

    define input    param pcUrl             as char no-undo.
    define input    param piTimeout         as int no-undo.

    define input    param pcReqHeaderLines  as char no-undo.
    define input    param ppReqBody         as memptr no-undo.

    define output   param pcResStatusLine   as char no-undo.
    define output   param pcResHeaderLines  as char no-undo.
    define output   param ppResBody         as memptr no-undo.

    run http_transaction(
        input   pcUrl,
        input   piTimeout,

        input   "POST",
        input   pcReqHeaderLines,
        input   ppReqBody,

        output  pcResStatusLine,
        output  pcResHeaderLines,
        output  ppResBody ).

end procedure. /* http_post */

procedure http_transaction:

    define input    param pcUrl             as char no-undo.
    define input    param piTimeout         as int no-undo.

    define input    param pcReqMethod       as char no-undo.
    define input    param pcReqHeaderLines  as char no-undo.
    define input    param ppReqBody         as memptr no-undo.

    define output   param pcResStatusLine   as char no-undo.
    define output   param pcResHeaderLines  as char no-undo.
    define output   param ppResBody         as memptr no-undo.

    define var cReqHeader   as char no-undo.
    define var pReqHeader   as memptr no-undo.

    define var hSocket      as handle no-undo.
    define var cProtocol    as char no-undo.
    define var cHost        as char no-undo.
    define var cPort        as char no-undo.
    define var cPath        as char no-undo.
    define var cQueryString as char no-undo.

    define var tDate        as date no-undo.
    define var iTime        as int no-undo.

    if piTimeout = ? then
       piTimeout = 45.

    if pcReqHeaderLines = ? then
       pcReqHeaderLines = "".

    if get-size( ppReqBody ) > 0 then
       pcReqHeaderLines = pcReqHeaderLines
            + ( if pcReqHeaderLines <> "" then "~n" else "" )
            + "Content-Type: application/x-www-form-urlencoded~n"
            + "Content-Length: " + string( get-size( ppReqBody ) ).

    if substr( pcReqHeaderLines, max( length( pcReqHeaderLines ), 1 ), 1 ) = "~n" then
       substr( pcReqHeaderLines, max( length( pcReqHeaderLines ), 1 ), 1 ) = "".

    assign
        pcReqHeaderLines    = replace( pcReqHeaderLines, "~n", "~r~n" )
        pcReqHeaderLines    = replace( pcReqHeaderLines, "~r~n~r~n", "" )

        pcResStatusLine     = ?
        pcResHeaderLines    = ?.



    {slib/err_try}:

        run http_breakUrl(
            input   pcUrl,
            output  cProtocol,
            output  cHost,
            output  cPort,
            output  cPath,
            output  cQueryString ).

        create socket hSocket.

        hSocket:connect( "-H " + cHost + " -S " + cPort + ( if cProtocol = "https" then " -ssl -nohostverify" else "" ) ) {&err_no-error}.
        hSocket:set-read-response-procedure( "readResponse", this-procedure ).

        empty temp-table ttPacket.

        iBytesReceived = 0.



        cReqHeader =

              caps( trim( pcReqMethod ) ) + " " + cPath + cQueryString + " HTTP/1.0~r~n"
            + "Host: " + cHost + "~r~n"
            + ( if pcReqHeaderLines <> "" then
                   pcReqHeaderLines + "~r~n" 
                else "" )
            + "~r~n".

        set-size( pReqHeader ) = length( cReqHeader ) + 1.
        put-string( pReqHeader, 1 ) = cReqHeader.

        hSocket:write( pReqHeader, 1, length( cReqHeader ) ) {&err_no-error}.
        set-size( pReqHeader ) = 0.

        if get-size( ppReqBody ) > 0 then
        hSocket:write( ppReqBody, 1, get-size( ppReqBody ) ) {&err_no-error}.



        assign
            tDate = today
            iTime = time.

        repeat while hSocket:connected( ) and ( ( today - tDate ) * 86400 + time ) - iTime <= piTimeout:

            wait-for read-response of hSocket pause 1.

        end. /* repeat */

        if hSocket:connected( ) and not can-find( first ttPacket ) then
            {slib/err_throw "'http_operation_timedout'"}.

        run compileResponse(
            output pcResStatusLine,
            output pcResHeaderLines,
            output ppResBody ).

    {slib/err_catch}:

        {slib/err_throw last}.

    {slib/err_finally}:

        hSocket:disconnect( ) no-error.
        delete object hSocket no-error.

        set-size( pReqHeader ) = 0.

    {slib/err_end}.

end procedure. /* http_transaction */

procedure readResponse private:

    define buffer ttPacket for ttPacket.

    define var ptr  as memptr no-undo.
    define var i    as int no-undo.

    if not self:connected( ) then
        return.

    i = min( self:get-bytes-available( ), 16384 ).

    if i = 0 then return.



    set-size( ptr ) = i.
    self:read( ptr, 1, i ).

    create ttPacket.
    assign
        ttPacket.rData  = ptr
        ttPacket.iSize  = i
        ttPacket.iStart = iBytesReceived + 1.

    iBytesReceived = iBytesReceived + i.

    set-size( ptr ) = 0.

end procedure. /* readResponse */

procedure compileResponse private:

    define output param pcStatusLine    as char no-undo.
    define output param pcHeaderLines   as char no-undo.
    define output param ppBody          as memptr no-undo.

    define buffer ttPacket for ttPacket.

    define var str  as char no-undo.
    define var i    as int no-undo.
    define var j    as int no-undo.

    {slib/err_try}:

        str = "".

        find first ttPacket use-index iStart no-error.

        repeat while avail ttPacket:

            str = str + get-string( ttPacket.rData, 1, min( ttPacket.iSize, 3072 - length( str ) ) ).

            if length( str ) >= min( 3072, iBytesReceived ) then 
                leave.

            find next ttPacket use-index iStart no-error.

        end. /* repeat */

        if not str begins "http" then
            {slib/err_throw "'http_invalid_reponse'" "substr( str, 1, 256 )"}.



        i = index( str, "~n~r~n" ).
        if i <> 0 then i = i + 2.

        if i = 0 then do:

            i = index( str, "~n~n" ).
            if i <> 0 then i = i + 1.

        end. /* i = 0 */

        if i = 0 then
            {slib/err_throw "'http_invalid_reponse'" "substr( str, 1, 256 )"}.



        assign
            str             = replace( substr( str, 1, i ), "~r~n", "~n" )
            substr( str, length( str ) - 1, 2 ) = ""

            pcStatusLine    = entry( 1, str, "~n" )
            substr( str, 1, length( pcStatusLine ) + 1 ) = ""

            pcHeaderLines   = str.



        if i < iBytesReceived then do:

            set-size( ppBody ) = iBytesReceived - i.

            if not avail ttPacket
            or not ttPacket.iStart <= i + 1 then

                find last ttPacket
                    where ttPacket.iStart <= i + 1
                    use-index iStart
                    no-error.

            i = i - ttPacket.iStart + 1.

            put-bytes( ppBody, 1 ) = get-bytes( ttPacket.rData, i + 1, ttPacket.iSize - i ).



            j = ttPacket.iSize - i + 1.

            repeat:

                find next ttPacket use-index iStart no-error.

                if not avail ttPacket then
                    leave.

                put-bytes( ppBody, j ) = get-bytes( ttPacket.rData, 1, ttPacket.iSize ).

                j = j + ttPacket.iSize.

            end. /* repeat */

        end. /* i < iBytesReceived */

    {slib/err_catch}:

        set-size( ppBody ) = 0.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* compileResponse */



procedure http_breakUrl: /* http_breakUrl also supports file:// urls */

    define input    param pcUrl         as char no-undo.
    define output   param pcProtocol    as char no-undo.
    define output   param pcHost        as char no-undo.
    define output   param pcPort        as char no-undo.
    define output   param pcPath        as char no-undo.
    define output   param pcQueryString as char no-undo.

    define var str  as char no-undo.
    define var i    as int no-undo.

    assign
        pcProtocol      = ""
        pcHost          = ""
        pcPort          = ""
        pcPath          = ""
        pcQueryString   = "".

    str = pcUrl.

    if str begins "file://" then do:

        assign
            pcProtocol = "file"
            substr( str, 1, 7 ) = "".

        if str = "" then
            {slib/err_throw "'http_invalid_url'" pcUrl}.

        assign
            pcHost = entry( 1, str, "/" )
            substr( str, 1, length( pcHost ) + 1 ) = "".

        i = num-entries( pcHost, ":" ). 

        if i = 2 then
        assign
            pcPort = entry( 2, pcHost, ":" )
            pcHost = entry( 1, pcHost, ":" ).

        else
        if i > 2 then
            {slib/err_throw "'http_invalid_url'" pcUrl}.



        if str <> "" then
        assign
            pcPath = str
            substr( str, 1, length( pcPath ) ) = "".

        if  substr( pcPath, 1, 1 ) >= "a"
        and substr( pcPath, 1, 1 ) <= "z"
        and substr( pcPath, 2, 1 ) = "|" then

        assign
            substr( pcPath, 1, 1 ) = caps( substr( pcPath, 1, 1 ) )
            substr( pcPath, 2, 1 ) = ":".

    end. /* file */



    else do:

        assign
            pcProtocol  = "http"
            pcPort      = "".

        if str begins "http://" then
        assign
            pcProtocol = "http"
            substr( str, 1, 7 ) = "".

        else
        if str begins "https://" then
        assign
            pcProtocol = "https"
            substr( str, 1, 8 ) = "".



        if str = "" then
            {slib/err_throw "'http_invalid_url'" pcUrl}.

        assign
            pcHost = entry( 1, str, "/" )
            substr( str, 1, length( pcHost ) ) = "".

        i = num-entries( pcHost, ":" ). 

        if i = 2 then
        assign
            pcPort = entry( 2, pcHost, ":" )
            pcHost = entry( 1, pcHost, ":" ).

        else
        if i > 2 then
            {slib/err_throw "'http_invalid_url'" pcUrl}.

        if pcHost = "" then
            {slib/err_throw "'http_invalid_url'" pcUrl}.

        if pcPort = "" then
           pcPort = ( if pcProtocol = "http" then "80" else "443").



        if str <> "" then
        assign
            pcPath = entry( 1, str, "?" )
            substr( str, 1, length( pcPath ) ) = "".

        if str <> "" then
        assign
            pcQueryString = str
            substr( str, 1, length( pcQueryString ) ) = "".

    end. /* else */

end procedure. /* http_breakUrl */



/* basically the same as webspeed url-encode but can be used without webspeed */

function http_encodeUrl returns char ( pcValue as char, pcEncodeType as char ):

    define var cEncodeList  as char no-undo.

    define var retval       as char no-undo.
    define var len          as int no-undo.
    define var ch           as int no-undo.
    define var i            as int no-undo.

    if pcValue = ? or length( pcValue ) = 0 then
        return "".

    if pcEncodeType = ? or pcEncodeType = "" then
       pcEncodeType = "default".

    case pcEncodeType:

        when "post"     then cEncodeList = http_cEncodeQuery.
        when "query"    then cEncodeList = http_cEncodeQuery.
        when "cookie"   then cEncodeList = http_cEncodeCookie.
        when "default"  then cEncodeList = http_cEncodeDefault.

        otherwise
        cEncodeList = http_cEncodeDefault + pcEncodeType.

    end case. /* pcEncodeType */



    assign
        retval  = ""
        len     = length( pcValue ).
        
    do i = 1 to len:

        ch = asc( substr( pcValue, i, 1, "raw"), "1252", "1252" ).

        if pcEncodeType = "post" and ch = 32 then
        retval = retval + "+".

        else
        if ch <= 31 or ch >= 127 or index( cEncodeList, chr(ch) ) > 0 then
        retval = retval + "%" + math_Int2Hex(ch).

        else
        retval = retval + chr(ch).

    end. /* 1 to len */

    return retval.

end function. /* http_encodeUrl */
