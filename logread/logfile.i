/* logread/logfile.i
 * definition of log file temp-table.
 * Stores information about each log file loaded 
 */
DEF TEMP-TABLE ttlog NO-UNDO
    RCODE-INFORMATION
    FIELD logid AS INT FORMAT "zzz9" COLUMN-LABEL "Log ID"
    FIELD logfile AS CHAR FORMAT "x(255)" COLUMN-LABEL "Log Name"
    FIELD htt AS HANDLE
    FIELD logtype AS CHAR FORMAT "x(255)" COLUMN-LABEL "Log Type"
    FIELD irows AS INT FORMAT "zzzzzzzz9" COLUMN-LABEL "#Rows"
    FIELD cdesc AS CHAR FORMAT "x(255)" COLUMN-LABEL "Description"
    FIELD idatefmtix AS INT FORMAT "999" 
    FIELD cdatefmt AS CHAR FORMAT "X(20)" COLUMN-LABEL "Date!Format"
    FIELD itimeadj AS DEC FORMAT "-zzz,zz9.999" COLUMN-LABEL "Time!Adjust(s)"
    FIELD ccodepage AS CHAR FORMAT "x(40)" COLUMN-LABEL "Code Page"
    FIELD csrclang AS CHAR FORMAT "X(20)" COLUMN-LABEL "Source!Language"
    FIELD csrcmsgs AS CHAR FORMAT "X(40)" COLUMN-LABEL "Source!PROMSGS"
    FIELD ctrgmsgs AS CHAR FORMAT "X(40)" COLUMN-LABEL "Target!PROMSGS"
    FIELD dStartDate AS DATE FORMAT "99/99/9999" /* COLUMN-LABEL "Start!Date" */
    FIELD dStartTime AS DEC FORMAT "99999" /* COLUMN-LABEL "Start!Time" */
    FIELD dEndDate AS DATE FORMAT "99/99/9999" /* COLUMN-LABEL "End!Date" */
    FIELD dEndTime AS DEC FORMAT "99999" /* COLUMN-LABEL "End!Time" */
    INDEX fileix IS PRIMARY logfile
    INDEX idix IS UNIQUE logid
    INDEX typeix logtype 
    .
