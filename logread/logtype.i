/* logread/logtype.i
 * Temp-table containing list of loaded log type handlers
 */
DEF {1} SHARED TEMP-TABLE ttlogtype NO-UNDO
    RCODE-INFORMATION
    FIELD loadix AS INT FORMAT "zzz9" COLUMN-LABEL "ID"
    FIELD hdlrprog AS CHAR FORMAT "X(255)" COLUMN-LABEL "Handler Program"
    FIELD logtype AS CHAR FORMAT "X(15)" COLUMN-LABEL "Log Type"
    FIELD typename AS CHAR FORMAT "X(40)" COLUMN-LABEL "Description"
    FIELD hproc AS HANDLE
    FIELD hschema AS HANDLE
    FIELD utilfunc AS CHAR
    FIELD utilqry AS CHAR
    FIELD guesstype AS LOG
    FIELD chidcols AS CHAR
    FIELD cmrgflds AS CHAR
    FIELD cnomrgflds AS CHAR
    INDEX idix IS PRIMARY loadix 
    INDEX fileix hdlrprog loadix
    INDEX typeix logtype loadix
    .
