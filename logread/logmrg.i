/* logread/logmrg.i
 * temp tables to support merge files 
 */

/* defines a merge */
DEF TEMP-TABLE ttmerge NO-UNDO
    FIELD mrgname AS CHAR
    FIELD hview AS HANDLE.  /* handle to logbr.p viewing this merge */

/* tables within a merge */
DEF TEMP-TABLE ttmrg NO-UNDO
    RCODE-INFORMATION
    FIELD mrgid AS INT FORMAT "zzz9" COLUMN-LABEL "Mrg ID"
    FIELD logorder AS INT FORMAT "zz9" COLUMN-LABEL "Log #"
    FIELD logid AS INT FORMAT "zzz9" COLUMN-LABEL "Log ID"
    FIELD mrgfrom AS INT FORMAT "zzz9" COLUMN-LABEL "Merge From"
    FIELD mrgfromord AS INT FORMAT "zz9" COLUMN-LABEL "Merge From Ord"
    FIELD logfile AS CHAR FORMAT "x(255)" COLUMN-LABEL "Log Name"
    /* FIELD htt AS HANDLE /* unneeded */ */
    FIELD logtype AS CHAR FORMAT "x(255)" COLUMN-LABEL "Log Type"
    FIELD irows AS INT FORMAT "zzzzzzzz9" COLUMN-LABEL "#Rows"
    FIELD cdesc AS CHAR FORMAT "x(255)" COLUMN-LABEL "Description"
    FIELD idatefmtix AS INT FORMAT "999" 
    FIELD cdatefmt AS CHAR FORMAT "X(17)" COLUMN-LABEL "Date!Format"
    FIELD ctimeadj AS CHAR FORMAT "XXX:XX:XX.XXX" COLUMN-LABEL "Time!Adjust"
    FIELD itimeadj AS DEC FORMAT "-zzz,zz9.999" COLUMN-LABEL "Time!Adjust(s)"
    FIELD ccodepage AS CHAR FORMAT "x(40)" COLUMN-LABEL "Code Page"
    FIELD csrclang AS CHAR FORMAT "X(20)" COLUMN-LABEL "Source!Language"
    FIELD csrcmsgs AS CHAR FORMAT "X(40)" COLUMN-LABEL "Source!Promsgs"
    FIELD ctrgmsgs AS CHAR FORMAT "X(40)" COLUMN-LABEL "Target!Promsgs"
    FIELD dStartDate AS DATE FORMAT "99/99/9999" COLUMN-LABEL "Start!Date"
    FIELD dStartTime AS DEC FORMAT "99999" COLUMN-LABEL "Start!Time"
    FIELD dEndDate AS DATE FORMAT "99/99/9999" COLUMN-LABEL "Start!Date"
    FIELD dEndTime AS DEC FORMAT "99999" COLUMN-LABEL "Start!Time"
    FIELD cmrgflds AS CHAR  /* CSV list of date, time, and msg text */
    FIELD cnomrgflds AS CHAR /* CSV list of fields not to merge */
    FIELD ccommon AS CHAR  /* CSV list of common fields */
    FIELD cprivate AS CHAR  /* CSV of private fields */
    INDEX idordix IS UNIQUE mrgid logorder
    .

/* columns in a merge */
DEF TEMP-TABLE ttmrgcol NO-UNDO
    FIELD mrgid AS INT
    FIELD colid AS INT
    FIELD colname AS CHAR
    FIELD coltype AS CHAR
    FIELD colformat AS CHAR
    FIELD collogids AS CHAR
    INDEX mrgname IS UNIQUE mrgid colname
    INDEX mrgcol IS UNIQUE mrgid colid
    .

DEF TEMP-TABLE ttmrg2 NO-UNDO LIKE ttmrg
    RCODE-INFORMATION.
  
