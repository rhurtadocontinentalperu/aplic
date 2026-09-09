&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : logread/handlers/htemplate.p
    Purpose     : Provide a template for writing new handlers.

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

/* CHANGE THESE TO REFLECT INFORMATION ABOUT YOUR HANDLER.
 * cLogType MUST be unique, or else this handler won't load. */
 
ASSIGN
  cLogType = "template"
  cTypeName = "Template".

/* Set up default query
  RUN addQuery("Default","by lineno"). */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-getDateFormatix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateFormatix Procedure 
PROCEDURE getDateFormatix :
/*------------------------------------------------------------------------------
  Purpose:     Returns the date format used in the log, as an 
               index into the date format array.
               Refer to logread/logdate.i for more information.
               
  Parameters:  ifmtix - index to appropriate date format in the date format array
  Notes:       This is part of the LogRead Handler API
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAM ifmtix AS INT NO-UNDO.

  /* NOTE: in the case where the time and date are mixed into the one 
   * timestamp, it is necessary to programmatically separate them.
   * e.g. Fri Jul 23 16:28 2004
   * When separating the date, put it into a known format from the 
   * date format array
   * e.g. Jul 23, 2004 (Matches format 16 from date format array) */

  ifmtix = 16.  /* MMM DD, YYYY */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenCols) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHiddenCols Procedure 
PROCEDURE getHiddenCols :
/*------------------------------------------------------------------------------
  Purpose:     Returns the list of hidden column names in this log type.
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
               for this log type.
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
  Purpose:     Returns whether this log could be handled by this handler, 
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
    /* lHandled = (IF cLogFile MATCHES "*.log" THEN YES ELSE NO). */
    lHandled = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadLogFile Procedure 
PROCEDURE loadLogFile :
/*------------------------------------------------------------------------------
  Purpose:     Loads the contents of the log file.
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
    
  Notes:       This is part of the LogRead handler API.
               The following code contains a framework to use to maintain the
               behaviour of LogRead, when loading a new log file. The uncommented
               code should be left as-is. The commented code shows where to
               write specific handling for loading the log file, along with 
               some code samples.               
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
    DEF OUTPUT PARAM htt AS HANDLE NO-UNDO.
    DEF OUTPUT PARAM lLoaded AS LOG INIT NO NO-UNDO.
    DEF OUTPUT PARAM irows AS INT INIT 1 NO-UNDO.

    DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cline AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lAbort AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lCancelled AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cincodepage AS CHAR NO-UNDO.

  /* CREATE THE DYNAMIC TEMP-TABLE
  CREATE TEMP-TABLE htt IN WIDGET-POOL "logpool".
  
  /* Create table definitions here
   * NOTE: DON'T USE PROGRESS KEYWORDS FOR COLUMNS!
   */
  htt:ADD-NEW-FIELD("lineno","int").
  htt:ADD-NEW-FIELD("logdate","date").
  htt:ADD-NEW-FIELD("logtime","char").
  htt:ADD-NEW-FIELD("rawtime","dec").
  htt:ADD-NEW-FIELD("logmsg","char").

  /* Prepare the temp-table */
  htt:TEMP-TABLE-PREPARE("templog").

  /* get the default buffer for this temp-table */
  hbuf = htt:DEFAULT-BUFFER-HANDLE.
  END OF CREATE DYNAMIC TEMP-TABLE */

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

    /* Read the next line of text from the file */
    IMPORT UNFORMATTED cline.

    /* update history rows, with the whole row */
    ASSIGN 
        ihistidx = (IF ihistidx = 4 THEN 1 ELSE
                    (ihistidx + 1))
        chist[ihistidx] = cline.

    /* DATE AND TIME HANDLING
     * Extract the date and time from the line first, so that any 
     * date range restriction can be acted upon */
    /*
    ASSIGN 
        ctxt = SUBSTRING(cline,2,25)
        cdate = ENTRY(2,ctxt," ") + " " + ENTRY(3,ctxt," ") + ", " + 
            ENTRY(5,ctxt," ")
        ctime = ENTRY(4,ctxt," ")
        cline = SUBSTRING(cline,26).

    /* convert the date from the string format to a date format */
    RUN getDateFromFormatix IN hparent(INPUT cdate,INPUT iDatefmtix, INPUT cSrcLang, OUTPUT ddate) NO-ERROR.
    /* check for error in conversion */
    IF ERROR-STATUS:ERROR THEN 
    DO:
        IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
    END.

    /* get the date as a decimal from the string */
    RUN getTimeFromString IN hparent(INPUT ctime,OUTPUT dtime) NO-ERROR.

    /* check for error */
        IF ERROR-STATUS:ERROR THEN 
        DO:
            IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
        END.

        RUN getTimeString IN hparent(INPUT dtime,INPUT true,OUTPUT ctime).
    * END OF DATE AND TIME PARSING */

    /* PERFORM DATE RANGE CHECKING
        RUN checkDateRange IN hparent(ddate,dtime,dStartDate,dStartTime,dEndDate,dEndTime,OUTPUT iOK).
        /* if before date range, skip to next line */
        IF iOK < 0 THEN NEXT LOADBLOCK.
        /* if after date range, exit loop and return */
        IF iOK > 0 THEN LEAVE LOADBLOCK.
    * END OF DATE RANGE CHECKING */

    /* LOAD LINE CONTENTS INTO LOCAL VARS
     * When loading, check for any validation or parsing errors, 
     * and display errors to the user to take action on, using:
     *  IF ERROR-STATUS:ERROR THEN 
     *  DO:
     *      IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
     *  END.
     * END OF LOAD LINE CONTENTS */


    /* CREATE NEW RECORD FROM LOCAL VARS
    /* create the buffer */
    hbuf:BUFFER-CREATE().
    /* assign the fields */
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
          hfld = hbuf:BUFFER-FIELD("logmsg")
            hfld:BUFFER-VALUE = cline
            hfld:FORMAT = "x(255)"
        /* count the rows so we can set MAX-DATA-GUESS in the browse */
        irows = irows + 1.
        /* release the buffer */
        hbuf:BUFFER-RELEASE().
     * END CREATE NEW RECORD */

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

&IF DEFINED(EXCLUDE-util_TemplateUtility) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE util_TemplateUtility Procedure 
PROCEDURE util_TemplateUtility :
/*------------------------------------------------------------------------------
  Purpose:     Template utility function, to demonstrate functionality
  Parameters:  
      htt     - handle to table containing log messages
      hview   - handle to current Log Browse window 
      hparent - handle to the main LogRead window
  Notes:       This is a utility function for the LogRead Handler API
------------------------------------------------------------------------------*/
    DEF INPUT PARAM htt AS HANDLE NO-UNDO.
    DEF INPUT PARAM hview AS HANDLE NO-UNDO.
    DEF INPUT PARAM hparent AS HANDLE NO-UNDO.

    /* To open a new Log Browse window on the log file,    
     * and change the query so that it displays a subset of 
     * records (in this case, all records where the field
     * "tid" matches the "tid" field of the current record 
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
        hfld = hbuf:BUFFER-FIELD("tid")
        cqry = "tid = ~"" + hfld:BUFFER-VALUE + "~"".
        RUN openViewer IN hparent (cFileName,cqry,hview).
    END.
    */

    /* A utility procedure may summarise information in the current log.
     * Output can be displayed in 2 ways:
     * - in a dialog/window with a text editor, to allow the user to copy
     * - as another log, in the log browse window.
     * 
     * To display in a dialog:
     *   RUN logread/txteddlg.w(
     *       INPUT cText, (text to display in window)
     *       INPUT irows, (height of window, in rows)
     *       INPUT icols, (width of window, in columns)
     *       INPUT ctitle) ( title of window).
     * 
     * To display in a window:
     *   RUN logread/txtedwin.w PERSISTENT (
     *       INPUT cText, (text to display in window)
     *       INPUT irows, (height of window, in rows)
     *       INPUT icols, (width of window, in columns)
     *       INPUT ctitle) ( title of window).
     * E.g. RUN logread/txtedwin.w PERSISTENT (
     *          "Error occurred at line 15",2,30,"Results").
     * 
     * To display as a new log:
     * - create the results in a new dynamic temp-table
     * - add a log type for this (if one does not already exist).
     *   You can add a "pseudo" log type :
     *     RUN addPseudoType IN hparent(
     *         INPUT clogtype,  (identifier of logtype)
     *         INPUT ctypename, (description of the log type)
     *         INPUT chidcols,  (hidden columns in the log type)
     *         INPUT cmrgflds,  (CSV list of merge fields. See comment in getMergeFields)
     *         INPUT cnomrgflds) (CSV list of non-merge fields. See comment in getMergeFields)
     * - add the log to LogRead's list of logs, using addTT().
     *     RUN addTT IN hparent(
     *         INPUT cfilename, (identifier of log)
     *         INPUT clogtype,  (logtype added using addPseudoType())
     *         INPUT htt,       (handle to temp-table containing results)
     *         INPUT irows,     (number of rows in temp-table)
     *         INPUT cdesc)     (description of the log)
     */
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

