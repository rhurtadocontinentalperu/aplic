
/**
 * wsserver.p
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

{slib/slibstr.i}

{slib/sliberr.i}



define temp-table ttSocket no-undo

    field hSocket       as handle
    field cBuffer       as char     init ""

    field cSessionId    as char     init ?
    field cUsername     as char     init ?
    field cRoles        as char     init ?

    index hSocket is primary unique
          hSocket

    index cSessionId
          cSessionId

    index cUsername
          cUsername.

define var hServer      as handle no-undo.

define var cError       as char no-undo.
define var cErrorMsg    as char no-undo.

function escapeStr  returns char    ( pcStr as char ) forward.
function xor8       returns int     ( piValue1 as int, piValue2 as int ) forward.



pause 0 before-hide.

{slib/err_try}:

    hide message no-pause.
    message string( time, "hh:mm:ss" ) "Creating server socket.".

    create server-socket hServer.

    hServer:set-connect-procedure( "connProc", this-procedure ) {slib/err_no-error}.
    hServer:enable-connections( session:parameter ) {slib/err_no-error}.

    hide message no-pause.
    message string( time, "hh:mm:ss" ) "Enabled connections on" session:parameter + ".".

{slib/err_catch cError cErrorMsg}:

    hide message no-pause.
    message string( time, "hh:mm:ss" ) cErrorMsg.

    delete object hServer.

    {slib/err_return}.

{slib/err_end}.



{slib/err_try}:

    for each crud_session exclusive-lock transaction:

        assign
            crud_session.is_online = no.

    end. /* for each crud_session */

    repeat:

        wait-for close of this-procedure pause 300.

        for each ttSocket:

            if not valid-handle( ttSocket.hSocket )
            or not ttSocket.hSocket:connected() then

                run deleteSocket( buffer ttSocket ).

            else
            if  ttSocket.cSessionId <> ?
            and not can-find(
                first crud_session
                where crud_session.session_id = ttSocket.cSessionId ) then do:

                run writeWsClose( buffer ttSocket ).
                run deleteSocket( buffer ttSocket ).

            end. /* not can-find */

        end. /* each ttSocket */

    end. /* repeat */

{slib/err_finally}:

    for each crud_session exclusive-lock transaction:

        assign
            crud_session.is_online = no.

    end. /* for each crud_session */

    for each ttSocket:

        run deleteSocket( buffer ttSocket ).

    end. /* each ttSocket */

    hServer:disable-connections() no-error.
    delete object hServer.

    hide message no-pause.
    message "Disabled connections.".

{slib/err_end}.

quit.



procedure connProc:

    define input param phSocket as handle no-undo.

    define buffer ttSocket for ttSocket.

    if not valid-handle( phSocket ) then
        return.

    {slib/err_try}:

        create ttSocket.
        assign ttSocket.hSocket = phSocket.

        phSocket:set-read-response-procedure( "readSocket", this-procedure ) {slib/err_no-error}.
        phSocket:set-socket-option( "SO-RCVTIMEO", "3" ) {slib/err_no-error}.

    {slib/err_catch}:

        run deleteSocket( buffer ttSocket ).

    {slib/err_end}.

end procedure. /* connProc */



procedure readSocket:

    define buffer ttSocket for ttSocket.

    define var cError       as char no-undo.
    define var cErrorMsg    as char no-undo.

    find first ttSocket
         where ttSocket.hSocket = self
         no-error.

    if not avail ttSocket then do:

        self:disconnect() no-error.
        delete object self no-error.

        return.

    end. /* not avail ttSocket */

    if not ttSocket.hSocket:connected() then do:

        hide message no-pause.
        message string( time, "hh:mm:ss" ) "** WebSocket disconnected.".

        run deleteSocket( buffer ttSocket ).
        return.

    end. /* not connected */



    {slib/err_try}:

        ttSocket.hSocket:sensitive = no.

        if ttSocket.cSessionId = ?
        then run readHttp( buffer ttSocket ).
        else run readWs  ( buffer ttSocket ).

        if avail ttSocket then /* possibly ws close message */
        ttSocket.hSocket:sensitive = yes.

    {slib/err_catch cError cErrorMsg}:

        hide message no-pause.
        message string( time, "hh:mm:ss" ) cErrorMsg.

        run deleteSocket( buffer ttSocket ).

    {slib/err_end}.

end procedure. /* readSocket */

procedure readHttp:

    define param buffer pbSocket for ttSocket.

    define buffer crud_session  for crud_session.
    define buffer crud_user     for crud_user.

    define var cSessionId   as char no-undo init ?.
    define var cKey         as char no-undo init ?.

    define var ptr          as memptr no-undo.
    define var str          as char no-undo.
    define var len          as int no-undo.
    define var i            as int no-undo.
    define var j            as int no-undo.

    {slib/err_try}:

        len                     = pbSocket.hSocket:get-bytes-available() {slib/err_no-error}.
        set-size( ptr )         = len.
        set-byte-order( ptr )   = big-endian.

        pbSocket.hSocket:read( ptr, 1, len, read-available ) {slib/err_no-error}.
        pbSocket.cBuffer = pbSocket.cBuffer + get-string( ptr, 1, len ).

    {slib/err_catch}:

        {slib/err_throw last}.

    {slib/err_finally}:

        set-size( ptr ) = 0.

    {slib/err_end}.

    if index( pbSocket.cBuffer, "~r~n~r~n" ) = 0 then
        return.



    {slib/err_try}:

        if not pbSocket.cBuffer begins "GET " then
            {slib/err_throw "'404'"}.

        cSessionId = entry( 2, entry( 1, pbSocket.cBuffer, "~r~n" ), " " ).
        if cSessionId begins "/" then substr( cSessionId, 1, 1 ) = "".

        len = num-entries( pbSocket.cBuffer, "~r~n" ).
        do i = 2 to len:

            str = entry( i, pbSocket.cBuffer, "~r~n" ).
            if str = "" then leave.

            j = index( str, ":" ).
            if j = 0 then next.

            if trim( substr( str, 1, j - 1 ) ) = "Sec-WebSocket-Key" then do:

                cKey = trim( substr( str, j + 1 ) ).
                leave.

            end. /* sec-websocket-key */

        end. /* 1 to j */

        if cKey = ? then
            {slib/err_throw "'404'"}.

    {slib/err_catch}:

        run writeSocket(
            buffer pbSocket,
            "HTTP/1.1 404 Not Found~r~n" +
            "Content-Type: text/html~r~n" +
            "Content-Length: 100~r~n" +
            "~r~n" +
            "<html>" +
            "<head><title>Not Found</title></head>" +
            "<body><p>Object requested was not found.</p></body>" +
            "<html>" ).

        {slib/err_throw last}.

    {slib/err_end}.



    do transaction:

        find first crud_session
             where crud_session.session_id  = cSessionId
               and crud_session.ip_address  = pbSocket.hSocket:remote-host
               and crud_session.last_hit   <> datetime-tz( 01, 01, 1970, 00, 00, 00, 0 )
             use-index session_id
             exclusive-lock {slib/err_no-error}.

        assign
            crud_session.is_online = yes.

        find first crud_user
             where crud_user.username = crud_session.username
             no-lock {slib/err_no-error}.

        assign
            pbSocket.cBuffer    = ""
            pbSocket.cSessionId = cSessionId
            pbSocket.cUsername  = crud_user.username
            pbSocket.cRoles     = crud_user.user_roles.

        hide message no-pause.
        message string( time, "hh:mm:ss" ) "Connected" pbSocket.cUsername pbSocket.cSessionId.

    end. /* trans */



    cKey = string( base64-encode( sha1-digest( cKey + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11" ) ) ).

    run writeSocket(
        buffer pbSocket,
        "HTTP/1.1 101 Switching Protocols~r~n" +
        "Upgrade: websocket~r~n" +
        "Connection: Upgrade~r~n" +
        "Sec-WebSocket-Accept: " + cKey + "~r~n" +
        "~r~n" ).

end procedure. /* readHttp */

procedure readWs:

    define param buffer pbSocket for ttSocket.

    define var lFin         as log no-undo.
    define var lRsv1        as log no-undo.
    define var lRsv2        as log no-undo.
    define var lRsv3        as log no-undo.
    define var iOpCode      as int no-undo.
    define var lMask        as log no-undo.
    define var iPayLen      as int64 no-undo.
    define var iMaskKey     as int extent 4 no-undo.

    define var cErrorCode   as char no-undo.
    define var cErrorMsg    as char no-undo.
    define var cErrorParams as char no-undo.
    define var cStackTrace  as char no-undo.

    define var ptr          as memptr no-undo.
    define var ptr2         as memptr no-undo.
    define var len          as int no-undo.
    define var i            as int no-undo.
    define var j            as int no-undo.

    {slib/err_try}:

        {slib/err_try}:

            set-size( ptr )         = 2.
            set-byte-order( ptr )   = big-endian.
            pbSocket.hSocket:read( ptr, 1, 2, read-exact-num ) {slib/err_no-error}.

            i = get-short( ptr, 1 ).

            assign
                lFin    = ( get-bits( i, 16, 1 ) = 1 )
                lRsv1   = ( get-bits( i, 15, 1 ) = 1 )
                lRsv2   = ( get-bits( i, 14, 1 ) = 1 )
                lRsv3   = ( get-bits( i, 13, 1 ) = 1 )
                iOpCode =   get-bits( i, 9, 4 )
                lMask   = ( get-bits( i, 8, 1 ) = 1 )
                iPayLen =   get-bits( i, 1, 7 ).

            if iPayLen = 126 then do:

                set-size( ptr )         = 0.
                set-size( ptr )         = 2.
                set-byte-order( ptr )   = big-endian.

                pbSocket.hSocket:read( ptr, 1, 2, read-exact-num ) {slib/err_no-error}.
                iPayLen = get-short( ptr, 1 ).

            end. /* iPayLen = 126 */

            else
            if iPayLen = 127 then do:

                set-size( ptr )         = 0.
                set-size( ptr )         = 8.
                set-byte-order( ptr )   = big-endian.

                pbSocket.hSocket:read( ptr, 1, 8, read-exact-num ) {slib/err_no-error}.
                iPayLen = get-int64( ptr, 1 ).

            end. /* iPayLen = 126 */

            if lMask then do:

                set-size( ptr )         = 0.
                set-size( ptr )         = 4.
                set-byte-order( ptr )   = big-endian.

                pbSocket.hSocket:read( ptr, 1, 4, read-exact-num ) {slib/err_no-error}.

                iMaskKey[1] = get-byte( ptr, 1 ).
                iMaskKey[2] = get-byte( ptr, 2 ).
                iMaskKey[3] = get-byte( ptr, 3 ).
                iMaskKey[4] = get-byte( ptr, 4 ).

            end. /* lMask */

            if iPayLen > 0 then do:

                set-size( ptr )         = 0.
                set-size( ptr )         = iPayLen.
                set-byte-order( ptr )   = big-endian.

                pbSocket.hSocket:read( ptr, 1, iPayLen, read-exact-num ) {slib/err_no-error}.

                if lMask then do:

                    set-size( ptr2 )        = iPayLen.
                    set-byte-order( ptr2 )  = big-endian.

                    do i = 1 to iPayLen:
                        put-byte( ptr2, i ) = xor8( get-byte( ptr, i ), iMaskKey[ ( i - 1 ) mod 4 + 1 ] ).
                    end.

                    pbSocket.cBuffer = pbSocket.cBuffer + get-string( ptr2, 1, iPayLen ).

                end. /* lMask */

                else
                    pbSocket.cBuffer = pbSocket.cBuffer + get-string( ptr, 1, iPayLen ).

            end. /* iPayLen > 0 */

        {slib/err_catch}:

            {slib/err_throw last}.

        {slib/err_finally}:

            set-size( ptr ) = 0.
            set-size( ptr2 ) = 0.

        {slib/err_end}.

        if not lFin then
            return.

        case iOpCode:

            when 8 then do:

                run writeWsClose( buffer pbSocket ).
                run deleteSocket( buffer pbSocket ).

                return.

            end. /* when 8 */

            when 9 then
                run writeWsPong( buffer pbSocket ).

            when 10 then.
                /* pong. ignore */

            otherwise
                run readJson( buffer pbSocket ).

        end case. /* iOpCode */

        assign
            pbSocket.cBuffer = "".

    {slib/err_catch cErrorCode cErrorMsg cErrorParams cStackTrace}:

        run writeWs(
            buffer pbSocket,
            '~{' +
                '"errorCode": "'    + escapeStr( cErrorCode ) + '", ' +
                '"errorParams": "'  + escapeStr( cErrorParams ) + '", ' +
                '"errorMsg": "'     + escapeStr( cErrorMsg ) + '"' +
            '~}').

        run writeWsClose( buffer pbSocket ).

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* readWs */

procedure readJson:

    define param buffer pbSocket for ttSocket.

    define var cSessionId       as char no-undo init ?.
    define var cUsername        as char no-undo init ?.
    define var cExcludeUsername as char no-undo init ?.
    define var cRoles           as char no-undo init ?.
    define var cExcludeRoles    as char no-undo init ?.

    define var iLen             as int no-undo.
    define var iPayLen          as int no-undo.
    define var iMaskKey         as int extent 4 no-undo.

    define var ptr              as memptr no-undo.
    define var ch               as int no-undo.
    define var i                as int no-undo.
    define var j                as int no-undo.

    {slib/err_try}:

        define var jParser as Progress.Json.ObjectModel.ObjectModelParser no-undo.
        define var jObject as Progress.Json.ObjectModel.JsonObject no-undo.

        jParser = new Progress.Json.ObjectModel.ObjectModelParser() {slib/err_no-error}.
        jObject = cast( jParser:Parse( pbSocket.cBuffer ), Progress.Json.ObjectModel.JsonObject ) {slib/err_no-error}.

        if jObject:Has( "sessionId" ) then do:
            cSessionId = jObject:GetCharacter( "sessionId" ) {slib/err_no-error}.
        end.

        if jObject:Has( "username" ) then do:
            cUsername = jObject:GetCharacter( "username" ) {slib/err_no-error}.
        end.

        if jObject:Has( "excludeUsername" ) then do:
            cExcludeUsername = jObject:GetCharacter( "excludeUsername" ) {slib/err_no-error}.
        end.

        if jObject:Has( "roles" ) then do:
            cRoles = jObject:GetCharacter( "roles" ) {slib/err_no-error}.
        end.

        if jObject:Has( "excludeRoles" ) then do:
            cExcludeRoles = jObject:GetCharacter( "excludeRoles" ) {slib/err_no-error}.
        end.

        if cSessionId = "" then
           cSessionId = ?.

        if cUsername = "" then
           cUsername = ?.

        if cExcludeUsername = "" then
           cExcludeUsername = ?.

        if cRoles = "" then
           cRoles = ?.

        if cExcludeRoles = "" then
           cExcludeRoles = ?.

    {slib/err_catch}:

        {slib/err_throw last}.

    {slib/err_finally}:

        delete object jParser no-error.

    {slib/err_end}.



    if not can-find(
        first crud_session
        where crud_session.session_id = pbSocket.cSessionId
          and crud_session.last_hit <> datetime-tz( 01, 01, 1970, 00, 00, 00, 0 )
        use-index session_id ) then
        {slib/err_throw "'session_expired'"}.

    assign
        /*
        iMaskKey[1] = random( 0, 255 )
        iMaskKey[2] = random( 0, 255 )
        iMaskKey[3] = random( 0, 255 )
        iMaskKey[4] = random( 0, 255 )
        */

        iPayLen     = length( pbSocket.cBuffer )
        iLen        =
            2 +                                         /* header */
            ( if iPayLen <= 125 then 0 else             /* ext payload len */
            ( if iPayLen <= 65535 then 2 else 8 ) ) +
            4 +                                         /* mask */
            iPayLen.                                    /* payload */

    set-size( ptr )         = iLen.
    set-byte-order( ptr )   = big-endian.

    i = 0.
    put-bits( i, 1, 1 )     = 1.
    put-bits( i, 2, 1 )     = 0.
    put-bits( i, 3, 1 )     = 0.
    put-bits( i, 4, 1 )     = 0.
    put-bits( i, 5, 4 )     = 1.
    put-bits( i, 9, 1 )     = 0.
    put-bits( i, 10, 7 )    =
        ( if iPayLen <= 125 then iPayLen else
        ( if iPayLen <= 65535 then 126 else 127 ) ).

    put-short( ptr, 1 ) = i.
    j = 3.

    if iPayLen <= 125 then.

    else
    if iPayLen <= 65535 then do:
        put-short( ptr, 3 ) = iPayLen.
        j = j + 2.
    end.

    else do:
        put-int64( ptr, 3 ) = iPayLen.
        j = j + 8.
    end.

    /*
    do i = 1 to 4:

        put-byte( ptr, j ) = iMaskKey[i].
        j = j + 1.

    end. /* 1 to 4 */
    */

    do i = 1 to iPayLen:

        ch = asc( substr( pbSocket.cBuffer, i, 1 ) ).
        put-byte( ptr, j ) = ch. /* xor8( ch, iMaskKey[ ( i - 1 ) mod 4 + 1 ] ). */

        j = j + 1.

    end. /* 1 to iPayLen */

    if cSessionId <> ? then do:

        find first ttSocket
             where ttSocket.cSessionId = cSessionId
             no-error.

        if avail ttSocket then do:

            if  valid-handle( ttSocket.hSocket )
            and ttSocket.hSocket:connected() then do:

                ttSocket.hSocket:write( ptr, 1, iLen ) no-error.
                if error-status:num-messages > 0 then
                    run deleteSocket( buffer ttSocket ).

            end. /* valid-handle */

            else
                run deleteSocket( buffer ttSocket ).

        end. /* avail ttSocket */

    end. /* cSessionId <> ? */

    else
    if cUsername <> ? then do:

        j = num-entries( cUsername ).
        do i = 1 to j:

            for each  ttSocket
                where ttSocket.cUsername = entry( i, cUsername )
                  and rowid( ttSocket ) <> rowid( pbSocket )

                  and ( cRoles = ""
                     or str_lookupList( ttSocket.cRoles, cRoles ) )
                and not str_lookupList( ttSocket.cRoles, cExcludeRoles )
                use-index cUsername:

                if  valid-handle( ttSocket.hSocket )
                and ttSocket.hSocket:connected() then do:

                    ttSocket.hSocket:write( ptr, 1, iLen ) no-error.
                    if error-status:num-messages > 0 then
                        run deleteSocket( buffer ttSocket ).

                end. /* valid-handle */

                else
                    run deleteSocket( buffer ttSocket ).

            end. /* for each ttSocket */

        end. /* 1 to j */

    end. /* cUsername <> ? */

    else do:

        for each  ttSocket
            where rowid( ttSocket ) <> rowid( pbSocket )

              and ( cUsername = ""
                 or lookup( ttSocket.cUsername, cUsername ) > 0 )
            and not lookup( ttSocket.cUsername, cExcludeUsername ) > 0

              and ( cRoles = ""
                 or str_lookupList( ttSocket.cRoles, cRoles ) )
            and not str_lookupList( ttSocket.cRoles, cExcludeRoles )
            use-index cUsername:

            if  valid-handle( ttSocket.hSocket )
            and ttSocket.hSocket:connected() then do:

                ttSocket.hSocket:write( ptr, 1, iLen ) no-error.
                if error-status:num-messages > 0 then
                    run deleteSocket( buffer ttSocket ).

            end. /* valid-handle */

            else
                run deleteSocket( buffer ttSocket ).

        end. /* for each ttSocket */

    end. /* else */

end procedure. /* readJson */



procedure writeSocket:

    define param buffer pbSocket for ttSocket.
    define input param pcStr as char no-undo.

    define var ptr  as memptr no-undo.
    define var len  as int no-undo.

    {slib/err_try}:

        len                     = length( pcStr ).
        set-size( ptr )         = len.
        set-byte-order( ptr )   = big-endian.

        put-string( ptr, 1, len ) = pcStr {slib/err_no-error}.
        pbSocket.hSocket:write( ptr, 1, len ) {slib/err_no-error}.

    {slib/err_catch}:

        {slib/err_throw last}.

    {slib/err_finally}:

        set-size( ptr ) = 0.

    {slib/err_end}.

end procedure. /* writeSocket */

procedure writeWsClose:

    define param buffer pbSocket for ttSocket.

    define var ptr  as memptr no-undo.
    define var len  as int no-undo.
    define var i    as int no-undo.

    {slib/err_try}:

        len                     = 2.
        set-size( ptr )         = len.
        set-byte-order( ptr )   = big-endian.

        i = 0.
        put-bits( i, 1, 1 )     = 1.
        put-bits( i, 2, 1 )     = 0.
        put-bits( i, 3, 1 )     = 0.
        put-bits( i, 4, 1 )     = 0.
        put-bits( i, 5, 4 )     = 8.
        put-bits( i, 9, 1 )     = 0.
        put-bits( i, 10, 7 )    = 0.

        put-short( ptr, 1 ) = i.
        pbSocket.hSocket:write( ptr, 1, len ) {slib/err_no-error}.

    {slib/err_catch}:

        {slib/err_throw last}.

    {slib/err_finally}:

        set-size( ptr ) = 0.

    {slib/err_end}.

end procedure. /* writeWsClose */

procedure writeWsPong:

    define param buffer pbSocket for ttSocket.

    run writeWs(
        buffer pbSocket,
        pbSocket.cBuffer ).

end procedure. /* writeWsPong */

procedure writeWs:

    define param buffer pbSocket for ttSocket.
    define input param pcStr as char no-undo.

    define var iLen     as int no-undo.
    define var iPayLen  as int no-undo.
    define var iMaskKey as int extent 4 no-undo.

    define var ptr      as memptr no-undo.
    define var ch       as int no-undo.
    define var i        as int no-undo.
    define var j        as int no-undo.

    {slib/err_try}:

        assign
            /*
            iMaskKey[1] = random( 0, 255 )
            iMaskKey[2] = random( 0, 255 )
            iMaskKey[3] = random( 0, 255 )
            iMaskKey[4] = random( 0, 255 )
            */

            iPayLen     = length( pcStr )
            iLen        =
                2 +                                         /* header */
                ( if iPayLen <= 125 then 0 else             /* ext payload len */
                ( if iPayLen <= 65535 then 2 else 8 ) ) +
                4 +                                         /* mask */
                iPayLen.                                    /* payload */

        set-size( ptr )         = iLen.
        set-byte-order( ptr )   = big-endian.

        i = 0.
        put-bits( i, 1, 1 )     = 1.
        put-bits( i, 2, 1 )     = 0.
        put-bits( i, 3, 1 )     = 0.
        put-bits( i, 4, 1 )     = 0.
        put-bits( i, 5, 4 )     = 10.
        put-bits( i, 9, 1 )     = 0.
        put-bits( i, 10, 7 )    =
            ( if iPayLen <= 125 then iPayLen else
            ( if iPayLen <= 65535 then 126 else 127 ) ).

        put-short( ptr, 1 ) = i.
        j = 3.

        if iPayLen <= 125 then.

        else
        if iPayLen <= 65535 then do:
            put-short( ptr, 3 ) = iPayLen.
            j = j + 2.
        end.

        else do:
            put-int64( ptr, 3 ) = iPayLen.
            j = j + 8.
        end.

        /*
        do i = 1 to 4:

            put-byte( ptr, j ) = iMaskKey[i].
            j = j + 1.

        end. /* 1 to 4 */
        */

        do i = 1 to iPayLen:

            ch = asc( substr( pcStr, i, 1 ) ).
            put-byte( ptr, j ) = ch. /* xor8( ch, iMaskKey[ ( i - 1 ) mod 4 + 1 ] ). */

            j = j + 1.

        end. /* 1 to iPayLen */

        pbSocket.hSocket:write( ptr, 1, iLen ) {slib/err_no-error}.

    {slib/err_catch}:

        {slib/err_throw last}.

    {slib/err_finally}:

        set-size( ptr ) = 0.

    {slib/err_end}.

end procedure. /* writeWs */



procedure deleteSocket:

    define param buffer pbSocket for ttSocket.

    define buffer crud_session for crud_session.

    if not avail pbSocket then
        return.

    if valid-handle( pbSocket.hSocket ) then do:

        pbSocket.hSocket:disconnect() no-error.
        delete object pbSocket.hSocket no-error.

    end. /* valid-handle */

    if pbSocket.cSessionId <> ? then
    do transaction:

        find first crud_session
             where crud_session.session_id = pbSocket.cSessionId
             exclusive-lock no-error.

        if avail crud_session then
        assign
            crud_session.is_online = no.

    end. /* cSessionId <> ? */

    hide message no-pause.
    message string( time, "hh:mm:ss" ) "Disconnected" pbSocket.cUsername pbSocket.cSessionId.

    delete pbSocket.

end procedure. /* deleteSocket */



function escapeStr returns char ( pcStr as char ):

    define var iLen as int no-undo.
    define var iPos as int no-undo.
    define var str  as char no-undo.
    define var ch   as char no-undo.

    assign
        iLen    = length( pcStr )
        iPos    = 1
        str     = "".

    do while iPos <= iLen:

        ch = substr( pcStr, iPos, 1 ).

        case ch:
            when "~b" then
            assign
                str     = str + '~\b'
                iPos    = iPos + 1.

            when "~f" then
            assign
                str     = str + '~\f'
                iPos    = iPos + 1.

            when "~r" then
            assign
                str     = str + '~\r'
                iPos    = iPos + 1.

            when "~n" then
            assign
                str     = str + '~\n'
                iPos    = iPos + 1.

            when "~t" then
            assign
                str     = str + '~\t'
                iPos    = iPos + 1.

            when "~000" then
            assign
                str     = str + '~\0'
                iPos    = iPos + 1.

            when '"' then
            assign
                str     = str + '~\"'
                iPos    = iPos + 1.

            when '~\' then do:

                if iPos = iLen then
                assign
                    iPos    = iPos + 1.

                else
                assign
                    str     = str + '~\~\~\' + substr( pcStr, iPos + 1, 1 )
                    iPos    = iPos + 2.

            end. /* when '~\' */

            otherwise do:

                assign
                    str     = str + ch
                    iPos    = iPos + 1.

            end. /* otherwise */

        end case. /* ch */

    end. /* while iPos <= iLen */

    return str.

end function. /* escapeStr */

function xor8 returns int ( piValue1 as int, piValue2 as int ):

    define var retval   as int no-undo.
    define var i        as int no-undo.

    do i = 1 to 8:

        case get-bits( piValue1, i, 1 ):

            when 0 then
            case get-bits( piValue2, i, 1 ):
                when 0 then put-bits( retval, i, 1 ) = 0.
                when 1 then put-bits( retval, i, 1 ) = 1.
            end case.

            when 1 then
            case get-bits( piValue2, i, 1 ):
                when 0 then put-bits( retval, i, 1 ) = 1.
                when 1 then put-bits( retval, i, 1 ) = 0.
            end case.

        end case.

        /*
        put-bits( retval, i, 1 ) =

            ( if ( get-bits( piValue1, i, 1 ) = 1
                or get-bits( piValue2, i, 1 ) = 1 )

              and not ( get-bits( piValue1, i, 1 ) = 1
                    and get-bits( piValue2, i, 1 ) = 1 )

                then 1 else 0 ).
        */

    end. /* 1 to 8 */

    return retval.

end function. /* xor8 */
