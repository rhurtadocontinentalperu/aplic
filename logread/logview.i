/* logread/logview.i
 * Definition of log view temp-table
 * List of views of opened log files
 */
DEF TEMP-TABLE ttview NO-UNDO
    RCODE-INFORMATION
    FIELD hproc AS HANDLE
    FIELD logfile AS CHAR FORMAT "x(40)" COLUMN-LABEL "Log File"
    FIELD logseq AS INT FORMAT "zzz9" COLUMN-LABEL "Seq"
    FIELD logid AS INT FORMAT "zzz9" COLUMN-LABEL "Log ID"
    FIELD logtitle AS CHAR FORMAT "x(40)" COLUMN-LABEL "Title"
.
