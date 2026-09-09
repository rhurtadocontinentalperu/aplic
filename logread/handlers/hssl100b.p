&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{logread/handlers/loghdlr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


ASSIGN
  cLogType = "ssl100b"
  cTypeName = "SSL Log (10.0B)".

RUN addQuery("Default","by lineno").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-getDateFormatix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateFormatix Procedure 
PROCEDURE getDateFormatix :
/*------------------------------------------------------------------------------
  Purpose:     Returns the date format used in ssl* logs, as an 
               index into the date format array.
               Refer to logread/logdate.i for more information.
               
  Parameters:  ifmtix - index to appropriate date format in the date format array
  Notes:       This is part of the LogRead Handler API
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAM ifmtix AS INT NO-UNDO.
  /* This is a slight hack. The ssl format actually includes the time
   * inside the timestamp. Since we parse time and date separately, 
   * we have to extract the date portions of the timestamp, and put
   * them together in this format, in loadLogFile */
  ifmtix = 16.  /* MMM DD, YYYY */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenCols) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHiddenCols Procedure 
PROCEDURE getHiddenCols :
/*------------------------------------------------------------------------------
  Purpose:     Returns the list of hidden column names in the SSL log type.
               These are names that should not be displayed in the 
               Log Browse window.
  Parameters:  chidcol - CSV list of hidden column names
  Notes:       This is part of the LogRead Handler API.
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM chidcol AS CHAR NO-UNDO.
    chidcol = "rawtime".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMergeFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMergeFields Procedure 
PROCEDURE getMergeFields :
/*------------------------------------------------------------------------------
  Purpose:     Returns a CSV list of fields used for merging, 
               and a CSV list of fields that should not appear in a merge, 
               for the SSL log type.
               There MUST be 4 fields in the merge fields, and they MUST be 
               (in this order)
               - the field containing the log message date (as a date)
               - the field containing the log message time (as a decimal)
               - the field containing the log message text (character)
               - the field containing the log message time as a string               
  Parameters:  cmrgflds - list of merge field for this logtype
               cnomrgflds - list of non-merge fields
  Notes:       This is part of the LogRead Handler API
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM cmrgflds AS CHAR NO-UNDO.
    DEF OUTPUT PARAM cnomrgflds AS CHAR NO-UNDO.

    ASSIGN 
        cmrgflds = "logdate,rawtime,logmsg,logtime"
        cnomrgflds = "logtime".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-guessType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE guessType Procedure 
PROCEDURE guessType :
/*------------------------------------------------------------------------------
  Purpose:     Returns whether this log could be an SSL* log file, 
               based on the filename.
  Parameters:  cLogFile - [input] name of log file to load
               lHandled - [output] TRUE if name indicates this is an SLL log file
                          else FALSE.
  Notes:       This is part of the LogRead Handler API
------------------------------------------------------------------------------*/
    DEF INPUT PARAM cLogFile AS CHAR NO-UNDO.
    DEF OUTPUT PARAM lHandled AS LOG NO-UNDO.
  
    /* based on the filename passed in cLogFile, determine if this 
     * reader could handle this logtype.
     * set lHandled = TRUE if it can, otherwise FALSE. */
    lHandled = (IF cLogFile MATCHES "cert*client*.log*" OR 
                cLogFile MATCHES "cert*server*.log*" THEN YES ELSE NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadLogFile Procedure 
PROCEDURE loadLogFile :
/*------------------------------------------------------------------------------
  Purpose:     Loads the contents of SSL cert.*.log files.
  Parameters:  
    clogname - [input] file name of log
    iDateFmtix - [input] date format index used with this log type
    dTimeAdj - [input] seconds to adjust the log times by
    cSrcLang - [input] source language to use when decoding char date formats
    cCodepage - [input] codepage to use when reading the data
    cSrcMsgs - [input] Source promsgs file to use, for translating messages
    cTrgMsgs - [input] Target promsgs file to use, for translating messages
    dStartDate - [input] Start date for log messages. All messages before this date are not loaded.
    dStartTime - [input] Start time for log messages. All messages before this time on the start date are not loaded.
    dEndDate - [input] End date for log messages. All messages after this date are not loaded.
    dEndTime - [input] End time for log messages. All messages after this time on the end date are not loaded.
    htt      - [output] temp-table handle of loaded log file
    lLoaded  - [output] true if log loaded successfully, else false 
    irows    - [output] number of rows in the log.
    
  Notes:       This is part of the LogRead handler API
------------------------------------------------------------------------------*/

    DEF INPUT PARAM clogname AS CHAR NO-UNDO.
    DEF INPUT PARAM iDateFmtix AS INT NO-UNDO.
    DEF INPUT PARAM dTimeAdj AS DEC NO-UNDO.
    DEF INPUT PARAM cSrcLang AS CHAR NO-UNDO.
    DEF INPUT PARAM cCodePage AS CHAR NO-UNDO.
    DEF INPUT PARAM cSrcMsgs AS CHAR NO-UNDO.
    DEF INPUT PARAM cTrgMsgs AS CHAR NO-UNDO.
    DEF INPUT PARAM dStartDate AS DATE NO-UNDO.
    DEF INPUT PARAM dStartTime AS DEC NO-UNDO.
    DEF INPUT PARAM dEndDate AS DATE NO-UNDO.
    DEF INPUT PARAM dEndTime AS DATE NO-UNDO.
    DEF OUTPUT PARAM htt AS HANDLE No-UNDO.
    DEF OUTPUT PARAM lLoaded AS LOG INIT NO NO-UNDO.
    DEF OUTPUT PARAM irows AS INT INIT 0 NO-UNDO.

  DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cline AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ddate AS DATE       NO-UNDO.
  DEFINE VARIABLE cdate AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ctime AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dtime AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dtimelast AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cid AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cctx AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cbio AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ccomp AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE csubsys AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cmsg AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ctxt AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ipos AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iOK AS INTEGER    NO-UNDO.
  DEFINE VARIABLE imsgno AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cmsgtxt AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cproc AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE labort AS LOGICAL INIT FALSE  NO-UNDO.
  DEFINE VARIABLE lcancelled AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cincodepage AS CHAR NO-UNDO.

  CREATE TEMP-TABLE htt IN WIDGET-POOL "logpool".
  /* Create table definitions here
   * NOTE: DON'T USE PROGRESS KEYWORDS FOR COLUMNS!
   */
  htt:ADD-NEW-FIELD("lineno","int").
  htt:ADD-NEW-FIELD("logdate","date").
  htt:ADD-NEW-FIELD("logtime","char").
  htt:ADD-NEW-FIELD("rawtime","dec").
  htt:ADD-NEW-FIELD("cid","char").
  htt:ADD-NEW-FIELD("ctx","char").
  htt:ADD-NEW-FIELD("bio","char").
  htt:ADD-NEW-FIELD("comp","char").
  htt:ADD-NEW-FIELD("subsys","char").
  htt:ADD-NEW-FIELD("logmsg","char").

  /* Prepare the temp-table */
  htt:TEMP-TABLE-PREPARE("certlog").

  /* get the default buffer for this temp-table */
  hbuf = htt:DEFAULT-BUFFER-HANDLE.

  /* set default date format */
  IF iDateFmtIx = ? OR idatefmtix = 0 THEN
      RUN getDateFormatIx(OUTPUT idatefmtix).
  /* codepage */
  IF ccodepage <> ""  THEN
    RUN checkCPConversion IN hparent(ccodepage,OUTPUT cincodepage).
  ELSE
    cincodepage = SESSION:CHARSET.

  /* display the load progress window */
  RUN showProgressWindow IN hparent("Loading " + clogname, "").
  ASSIGN
      chist[1] = ?
      chist[2] = ?
      chist[3] = ?
      chist[4] = ?
      ihistidx = 0.
  
  /* read in from the log file, parsing each line, and populating the temp-table. */
  INPUT FROM VALUE(clogname) CONVERT SOURCE cincodepage NO-ECHO.
  LOADBLOCK:
  REPEAT :
    /* update the progress window on the screen, and check for cancel */
    IF (irows MOD 100  = 0) THEN
    DO:
        PROCESS EVENTS.
        RUN checkProgressCancelled IN hparent(OUTPUT lcancelled).
        IF lcancelled THEN
        DO:
            /* display dialog, asking if they want to abort, stop, or keep */
            IF (abortLoad(INPUT TRUE,INPUT irows,INPUT ?,OUTPUT labort)) THEN
                LEAVE LOADBLOCK.
        END.
        RUN updateProgressWindow IN hparent(INPUT "Loaded " + STRING(irows)).
    END.

    IMPORT UNFORMATTED cline.

    /* update history rows, with the whole row */
    ASSIGN 
        ihistidx = (IF ihistidx = 4 THEN 1 ELSE
                    (ihistidx + 1))
        chist[ihistidx] = cline.

    IF (cline = "") THEN NEXT LOADBLOCK.

    IF cline BEGINS "[" THEN
    DO:
        /* this is a line beginning with a date */
        ipos = INDEX(cline,"]").
        IF (ipos < 0) THEN
        DO:
            /* error, this should not happen */
            NEXT LOADBLOCK.
        END.
        ASSIGN 
            ctxt = SUBSTRING(cline,2,ipos - 2)
            cdate = ENTRY(2,ctxt," ") + " " + ENTRY(3,ctxt," ") + ", " + 
                ENTRY(5,ctxt," ")
            ctime = ENTRY(4,ctxt," ")
            cline = SUBSTRING(cline,ipos + 2).

        RUN getDateFromFormatix IN hparent(INPUT cdate,INPUT iDatefmtix, INPUT cSrcLang, OUTPUT ddate) NO-ERROR.
        /* check for error */
        IF ERROR-STATUS:ERROR THEN 
        DO:
            IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
        END.

        RUN getTimeFromString IN hparent(INPUT ctime,OUTPUT dtime) NO-ERROR.
        /* check for error */
        IF ERROR-STATUS:ERROR THEN 
        DO:
            IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
        END.

        RUN getTimeString IN hparent(INPUT dtime,INPUT true,OUTPUT ctime).

        RUN checkDateRange IN hparent(ddate,dtime,dStartDate,dStartTime,dEndDate,dEndTime,OUTPUT iOK).
        /* if before date range, skip to next line */
        IF iOK < 0 THEN NEXT LOADBLOCK.
        /* if after date range, exit loop and return */
        IF iOK > 0 THEN LEAVE LOADBLOCK.

        /* now check for "internal state operation" in the rest of the line
         * if this is not present, then we have the cid, cctx and cbio fields */
        IF NOT (cline BEGINS "INTERNAL STATE OPERATION") THEN
        DO:
            ASSIGN 
                ipos = INDEX(cline," ")
                cid = SUBSTRING(cline,1,ipos - 1)
                cline = SUBSTRING(cline,ipos + 1).
            ASSIGN 
                ipos = INDEX(cline," ")
                cctx = SUBSTRING(cline,1,ipos - 1)
                cline = SUBSTRING(cline,ipos + 1).
            ASSIGN 
                ipos = INDEX(cline," ")
                cbio = SUBSTRING(cline,1,ipos - 1)
                cline = trim(SUBSTRING(cline,ipos + 1)).
            ASSIGN 
                ipos = INDEX(cline," ")
                ccomp = SUBSTRING(cline,1,ipos - 1)
                cline = trim(SUBSTRING(cline,ipos + 1)).
        END.
        ELSE
            ASSIGN 
                cid = ""
                cctx = ""
                cbio = ""
                ccomp = "INTERNAL STATE OPERATION"
                cline = TRIM(SUBSTRING(cline,LENGTH(ccomp) + 1)).
        /* read the subsys then the message */
        ASSIGN 
            ipos = INDEX(cline," ")
            csubsys = SUBSTRING(cline,1,ipos - 1)
            cline = TRIM(SUBSTRING(cline,ipos + 1)).
    END.
    /* else this line is a data dump line. just inherit fields from previous record */
        
    hbuf:BUFFER-CREATE().
    /* increment the line number */
    irows = irows + 1.
    ASSIGN 
        hfld = hbuf:BUFFER-FIELD("lineno")
        hfld:BUFFER-VALUE = irows
        hfld:FORMAT = "ZZZZZZZZ9".
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("logdate")
        hfld:BUFFER-VALUE = ddate
        hfld:FORMAT = "99/99/9999".
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("rawtime")
        hfld:BUFFER-VALUE = dtime
        /* hfld:FORMAT = "" */ .
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("logtime")
        hfld:BUFFER-VALUE = ctime
        hfld:FORMAT = "x(255)".
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("cid")
        hfld:FORMAT = "x(255)"
        hfld:BUFFER-VALUE = cid.
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("ctx")
        hfld:FORMAT = "x(255)"
        hfld:BUFFER-VALUE = cctx.
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("bio")
        hfld:FORMAT = "x(255)"
        hfld:BUFFER-VALUE = cbio.
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("comp")
        hfld:FORMAT = "x(255)"
        hfld:BUFFER-VALUE = ccomp.
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("subsys")
        hfld:FORMAT = "x(255)"
        hfld:BUFFER-VALUE = csubsys.
    ASSIGN 
          hfld = hbuf:BUFFER-FIELD("logmsg")
            hfld:BUFFER-VALUE = cline
            hfld:FORMAT = "x(255)".
        hbuf:BUFFER-RELEASE().
  END.
  /* close the log file */
  INPUT CLOSE.
  
  /* check if load was aborted completely */
  IF labort = TRUE THEN
  DO:
      hbuf:EMPTY-TEMP-TABLE().
      DELETE OBJECT htt.
      lLoaded = NO.
  END.
  ELSE
      lLoaded = YES.

  /* hide the progress window */
  RUN hideProgressWindow IN hparent.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-util_ShowCurrentThread) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE util_ShowCurrentThread Procedure 
PROCEDURE util_ShowCurrentThread :
/*------------------------------------------------------------------------------
  Purpose:     Utility to identify all log messages from the same thread, 
               and display them in a separate Log Browse window.
  Parameters:  
      htt     - handle to table containing log messages
      hview   - handle to current Log Browse window 
      hparent - handle to the main LogRead window
  Notes:       This is a utility function for the LogRead Handler API
------------------------------------------------------------------------------*/
    DEF INPUT PARAM htt AS HANDLE NO-UNDO.
    DEF INPUT PARAM hview AS HANDLE NO-UNDO.
    DEF INPUT PARAM hparent AS HANDLE NO-UNDO.

    DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cqry AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.

    /* get the current buffer from hview */
    RUN getFileName IN hview(OUTPUT cFileName).
    RUN getCurrentBuffer IN hview(OUTPUT hbuf).
    IF VALID-HANDLE(hbuf) THEN
    DO:
        ASSIGN 
        hfld = hbuf:BUFFER-FIELD("cid")
        cqry = "cid = ~"" + hfld:BUFFER-VALUE + "~"".
        RUN openViewer IN hparent (cFileName,cqry,hview).
    END.
    ELSE
        MESSAGE "No message selected. Please select a row"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

