&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : logread/handlers/hdb.p
    Purpose     : Log Type Handler for Database log files

    Syntax      :

    Description :

    Author(s)   : 
    Created     :
    Notes       : Conforms to the LogRead Handler API
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* basic log handler info */
{logread/handlers/loghdlr.i}

/* global for finding user numberin 5512 message */
DEFINE VARIABLE iusrix AS INTEGER EXTENT 3 NO-UNDO.

/* temp table of records without dates */
DEF TEMP-TABLE ttundated NO-UNDO
    FIELD ilineno AS INT
    FIELD rrowid AS ROWID
    FIELD dtime AS DEC
    INDEX rev ilineno.


ASSIGN
  cLogType = "db101a"
  cTypeName = "Database Log 10.1A+".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-findMsgUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findMsgUser Procedure 
FUNCTION findMsgUser RETURNS CHARACTER
  ( cmsgtxt AS CHAR,imsgno AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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

RUN addQuery("Default","by lineno").
RUN addQuery("Sessions","(logmsg matches ~"*(451)*~") or " + 
                            "(logmsg matches ~"*(333)*~") or " + 
                            "(logmsg matches ~"*(334)*~") " + 
                            "by logdate by logtime").
RUN addQuery("UserByTime","by usr by logdate by logtime").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-getDateFormatix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateFormatix Procedure 
PROCEDURE getDateFormatix :
/*------------------------------------------------------------------------------
  Purpose:     Returns the date format used in database logs, as an 
               index into the date format array.
               Refer to logread/logdate.i for more information.
               
  Parameters:  ifmtix - index to appropriate date format in the date format array
  Notes:       This is part of the LogRead Handler API
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAM ifmtix AS INT NO-UNDO.
  
  ifmtix = 1.  /* YYYY/MM/DD */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenCols) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHiddenCols Procedure 
PROCEDURE getHiddenCols :
/*------------------------------------------------------------------------------
  Purpose:     Returns the list of hidden column names in the database log type.
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
               for the database log type.
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
  Purpose:     Returns whether this log could be a database log file, 
               based on the filename.
  Parameters:  cLogFile - [input] name of log file to load
               lHandled - [output] TRUE if name indicates this is a db log file
                          else FALSE.
  Notes:       This is part of the LogRead Handler API
------------------------------------------------------------------------------*/
    DEF INPUT PARAM cLogFile AS CHAR NO-UNDO.
    DEF OUTPUT PARAM lHandled AS LOG NO-UNDO.
  
    /* based on the filename passed in cLogFile, determine if this 
     * reader could handle this logtype.
     * set lHandled = TRUE if it can, otherwise FALSE. */
    lHandled = (IF cLogFile MATCHES "*.lg" THEN YES ELSE NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadLogFile Procedure 
PROCEDURE loadLogFile :
/*------------------------------------------------------------------------------
  Purpose:     Loads the contents of database log files.
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
    DEF INPUT PARAM dEndTime AS DEC NO-UNDO.
    DEF OUTPUT PARAM htt AS HANDLE NO-UNDO.
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
  DEFINE VARIABLE ipos AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ipos2 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ctmp AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lfathom AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE l6686 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lnewline AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lnomessage AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cmsgtmp AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rincomplete AS ROWID      NO-UNDO.
  DEFINE VARIABLE iOK AS INTEGER    NO-UNDO.
  DEFINE VARIABLE imsgno AS INTEGER    NO-UNDO.
  DEFINE VARIABLE clogmsg AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cpid AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ctid AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rlastrow AS ROWID      NO-UNDO.
  DEFINE VARIABLE cusr AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cproc AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lnewdate AS LOGICAL INIT FALSE  NO-UNDO.
  DEFINE VARIABLE dnewdate AS DATE    NO-UNDO.
  DEFINE VARIABLE dnewtime AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE labort AS LOGICAL INIT FALSE  NO-UNDO.
  DEFINE VARIABLE lcancelled AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cincodepage AS CHAR  NO-UNDO.
  DEFINE VARIABLE csev AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cmsgno AS CHARACTER  NO-UNDO.

  CREATE TEMP-TABLE htt IN WIDGET-POOL "logpool".
  /* Create table definitions here
   * NOTE: DON'T USE PROGRESS KEYWORDS FOR COLUMNS!
   */
  htt:ADD-NEW-FIELD("lineno","int").
  htt:ADD-NEW-FIELD("logdate","date").
  htt:ADD-NEW-FIELD("logtime","char").
  htt:ADD-NEW-FIELD("rawtime","dec").
  htt:ADD-NEW-FIELD("pid","char").
  htt:ADD-NEW-FIELD("tid","char").
  htt:ADD-NEW-FIELD("sev","char").
  htt:ADD-NEW-FIELD("proc","char").
  htt:ADD-NEW-FIELD("usr","char").
  htt:ADD-NEW-FIELD("msgno","int").
  htt:ADD-NEW-FIELD("logmsg","char").

  /* Prepare the temp-table */
  htt:TEMP-TABLE-PREPARE("dblog").

  /* get the default buffer for this temp-table */
  hbuf = htt:DEFAULT-BUFFER-HANDLE.

  EMPTY TEMP-TABLE ttundated.

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
  
  /* reset iusrix for each log file */
  ASSIGN 
      iusrix[1] = -1
      iusrix[2] = -1
      iusrix[3] = -1.

  DEBUGGER:SET-BREAK().

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
        chist[ihistidx] = cline
        lfathom = FALSE
        .

    /* we can safely skip the date line now, it is in each message */
    IF cline BEGINS "                " THEN NEXT.

    /* skip any blank lines */
    IF cline = "" THEN NEXT.

    /* look for weird fathom bookmark line */
    IF (cline BEGINS "(" AND cline MATCHES "*Fathom_Bookmark*" ) THEN
    DO:
        /* (Thu Jun 10 18:12:12 CDT 2004)Fathom_Bookmark */
        ipos = INDEX(cline,")").
        IF (ipos > 0) THEN
        DO:
            ASSIGN 
                lfathom = TRUE
                ctmp  = SUBSTRING(cline,2,ipos - 2)
                cdate = ENTRY(2,ctmp," ") + " " + ENTRY(3,ctmp," ") + ", " +
                        ENTRY(6,ctmp," ")
                ctime = ENTRY(4,ctmp," ")
                cusr = ""
                cproc = "FATHOM"
                clogmsg = "Fathom_Bookmark".
            RUN getTimeFromString IN hparent(INPUT ctime,OUTPUT dtime) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
            END.
            RUN getDateFromFormatix IN hparent(INPUT cdate, INPUT idatefmtix, INPUT cSrcLang,OUTPUT ddate) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
            END.
            RUN getTimeString IN hparent(INPUT dtime,INPUT true,OUTPUT ctime).
        END.
    END.
    ELSE IF (cline BEGINS "[") THEN
    DO:
        /* this is the expected format */
        ASSIGN 
            cdate = SUBSTRING(cline,2,10)
            ctime = SUBSTRING(cline,13,12).

        RUN getDateFromFormatix IN hparent(INPUT cdate,INPUT iDatefmtix, INPUT cSrcLang, OUTPUT ddate) NO-ERROR.
        /* check for error */
        IF ERROR-STATUS:ERROR THEN 
        DO:
            IF abortLoad(INPUT FALSE,INPUT irows,INPUT return-value,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
        END.
        
        RUN getTimeFromString IN hparent(INPUT ctime,OUTPUT dtime) NO-ERROR.
        /* check for error */
        IF ERROR-STATUS:ERROR THEN 
        DO:
            IF abortLoad(INPUT FALSE,INPUT irows,INPUT return-value,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
        END.

        RUN checkDateRange IN hparent(ddate,dtime,dStartDate,dStartTime,dEndDate,dEndTime,OUTPUT iOK).
        /* if before date range, skip to next line */
        IF ddate <> ? AND iOK < 0 THEN NEXT LOADBLOCK.
        /* if after date range, exit loop and return */
        IF ddate <> ? AND iOK > 0 THEN LEAVE LOADBLOCK.

        /* extract fields from the line */
        ASSIGN
            cpid = SUBSTRING(cline,32,12)
            ctid = SUBSTRING(cline,45,7)
            csev = SUBSTRING(cline,53,1)
            cproc = SUBSTRING(cline,55,9)
            cmsgno = SUBSTRING(cline,66,7)
            clogmsg = SUBSTRING(cline,74)
            .

        /* look for a promsg number. */
        RUN GetPromsgNum IN hparent(cmsgno,OUTPUT imsgno).

    END.  /* normal log line */
    ELSE
    DO:
        /* unexpected format */
        /* just treat it as if this has the same date etc. as the previous message
         * but make a new record for it. */
        clogmsg = cline.
    END.

    IF (NOT lfathom) THEN
    DO:
    
        /* the promsg message, translate if necessary */
        IF imsgno > 0 AND csrcmsgs <> "" AND ctrgmsgs <> "" THEN
        DO:
            /* The 10.1A db log format removes the message number from the 
             * end of the message. In order to perform translations, we need
             * to move it back to the end of the message. */
            clogmsg = clogmsg + "(" + STRING(imsgno) + ")".
            RUN translatePromsg IN hparent (clogmsg,csrcmsgs,ctrgmsgs,OUTPUT clogmsg).
        END.

    
        /* Detect who the user is that caused this message, if the server logged it */
        /* if this message is "sent on behalf (5512)",
         * then update rlastrow, and set the usr field to the user number */
        IF imsgno = 5512 THEN
        DO TRANSACTION:
            /* find the user from the message */
            cusr = findMsgUser(clogmsg,5512).
            /* update the usr field on the last row */
            hbuf:FIND-BY-ROWID(rlastrow,EXCLUSIVE-LOCK).
            IF hbuf:AVAILABLE THEN
            DO:
                ASSIGN 
                    hfld = hbuf:BUFFER-FIELD("usr")
                    hfld:BUFFER-VALUE = cusr.
                hbuf:BUFFER-RELEASE().
            END.
        END.
        ELSE IF imsgno = 742 THEN /* if this is a remote login message */
            cusr = findMsgUser(clogmsg,742).
        ELSE IF imsgno = 739 THEN /* if this is a remote logout message */
            cusr = findMsgUser(clogmsg,739).
        ELSE 
            cusr = cproc.
    END.  /* if not lfathom */
     

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
        hfld = hbuf:BUFFER-FIELD("proc")
        hfld:FORMAT = "x(255)"
        hfld:BUFFER-VALUE = cproc.
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("usr")
        hfld:FORMAT = "x(255)"
        hfld:BUFFER-VALUE = cusr.
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("pid")
        hfld:FORMAT = "x(15)"
        hfld:BUFFER-VALUE = cpid.
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("tid")
        hfld:FORMAT = "x(10)"
        hfld:BUFFER-VALUE = ctid.
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("sev")
        hfld:FORMAT = "x(3)"
        hfld:BUFFER-VALUE = csev.
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("msgno")
        hfld:FORMAT = "zzzzzz"
        hfld:BUFFER-VALUE = imsgno.
    ASSIGN 
          hfld = hbuf:BUFFER-FIELD("logmsg")
            hfld:BUFFER-VALUE = clogmsg
            hfld:FORMAT = "x(255)".
    
    /* remember this buffer's rowid */
    rlastrow = hbuf:ROWID.

    hbuf:BUFFER-RELEASE().

  END.  /* LOADBLOCK */
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

&IF DEFINED(EXCLUDE-util_ShowCurrentServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE util_ShowCurrentServer Procedure 
PROCEDURE util_ShowCurrentServer :
/*------------------------------------------------------------------------------
  Purpose:     Utility to identify all log messages from the same server (proc), 
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
        hfld = hbuf:BUFFER-FIELD("proc")
        cqry = "proc = ~"" + hfld:BUFFER-VALUE + "~" by lineno".
        RUN openViewer IN hparent (cFileName,cqry,hview).
    END.
    ELSE
        MESSAGE "No message selected. Please select a row"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-util_ShowCurrentUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE util_ShowCurrentUser Procedure 
PROCEDURE util_ShowCurrentUser :
/*------------------------------------------------------------------------------
  Purpose:     Utility to identify all log messages from the same user, 
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
        hfld = hbuf:BUFFER-FIELD("usr")
        cqry = "usr = ~"" + hfld:BUFFER-VALUE + "~" by lineno".
        RUN openViewer IN hparent (cFileName,cqry,hview).
    END.
    ELSE
        MESSAGE "No message selected. Please select a row"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-findMsgUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findMsgUser Procedure 
FUNCTION findMsgUser RETURNS CHARACTER
  ( cmsgtxt AS CHAR,imsgno AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  Extract the user number from a (5512), (742) or (739) message
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE ctoken AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE icnt AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iusr AS INTEGER INIT ? NO-UNDO.
  DEFINE VARIABLE imsgix AS INTEGER    NO-UNDO.

  /* This is a hack. The only number in the message is the user number.
   * Search through the space-delimited message for the first number.
   * This is the user number. 
   * To speed this process up, record which entry in the message the number
   * is, so we can extract this entry immediately on subsequent messages. */
  imsgix = (IF imsgno = 5512 THEN 1 ELSE
            (IF imsgno = 742 THEN 2 ELSE 
             (IF imsgno = 739 THEN 3 ELSE 0))).
  IF imsgix = 0 THEN RETURN "".

  IF iusrix[imsgix] = -1 THEN
  DO:
      FINDLOOP:
      DO icnt = 1 TO NUM-ENTRIES(cmsgtxt," "):
          ctoken = ENTRY(icnt,cmsgtxt," ").
          IF ctoken = "" THEN NEXT FINDLOOP.
          ASSIGN 
              iusr = INT(ctoken) NO-ERROR.
          IF NOT ERROR-STATUS:ERROR THEN
          DO:
              iusrix[imsgix] = icnt.
              LEAVE FINDLOOP.
          END.
      END.
  END.
  ELSE
      ASSIGN iusr = INT(ENTRY(iusrix[imsgix],cmsgtxt," ")) NO-ERROR.
   IF (iusr <> ?) THEN
       RETURN "Usr" + STRING(iusr,"zzzzz9").

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

