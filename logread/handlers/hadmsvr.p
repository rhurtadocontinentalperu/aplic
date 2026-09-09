&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : logread/handlers/hadmsvr.p
    Purpose     : Log Type Handler for AdminServer log files

    Syntax      :

    Description :

    Author(s)   : 
    Created     :
    Notes       : Conforms to the LogRead Handler API
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{logread/handlers/loghdlr.i}

DEFINE VARIABLE itimeidx AS INTEGER    NO-UNDO.

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
  cLogType = "admserv"
  cTypeName = "AdminServer Log".

RUN addQuery("Default","by lineno").
RUN addQuery("SessionStart","level = ~"~" and subsys = ~"~" and logmsg begins ~"=== Start ~"").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-getDateFormatix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateFormatix Procedure 
PROCEDURE getDateFormatix :
/*------------------------------------------------------------------------------
  Purpose:     Returns the date format used in AdminServer logs, as an 
               index into the date format array.
               Refer to logread/logdate.i for more information.
               
  Parameters:  ifmtix - index to appropriate date format in the date format array
  Notes:       This is part of the LogRead Handler API
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAM ifmtix AS INT NO-UNDO.

  /* system date format */
  IF SESSION:DATE-FORMAT = "dmy" THEN
      ifmtix = 5.
  ELSE 
      ifmtix = 9.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenCols) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHiddenCols Procedure 
PROCEDURE getHiddenCols :
/*------------------------------------------------------------------------------
  Purpose:     Returns the list of hidden column names in the AdminServer log type.
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
               for the AdminServer log type.
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
        cnomrgflds = "logtime,lineno".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTimeFromString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTimeFromString Procedure 
PROCEDURE getTimeFromString :
/*------------------------------------------------------------------------------
  Purpose:     Return the string representation of a time as a decimal
  Parameters:  
    ctime - [IN] string representation of a time
    dtime - [OUT] parsed time
  Notes:       This provides a different parser to that in logread/logdate.i
               The AdminServer uses the locale format to display times, 
               which means you can end up with dates in the following formats:
               HH:MM:SS AM   HH:MM:SS PM (American, Spanish, etc)
               HH:MM:SS
               HH.MM.SS
               HH:MM:SS.PD   HH:MM:SS.MD  - Albanian(sq)
               
------------------------------------------------------------------------------*/
  DEF INPUT PARAM ctime AS CHAR NO-UNDO.
  DEF OUTPUT PARAM dtime AS DEC NO-UNDO.

  DEFINE VARIABLE chour AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cmin AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE csec AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cam AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cdelim AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lam AS LOGICAL INIT YES NO-UNDO.

  /* if we don't have the time index set, 
   * then figure out what time index this format is */
  IF (itimeidx = 0) THEN
  DO:
    /* find the delimiter used, either : or . */
      IF INDEX(ctime,":") > 0 THEN
      DO:
          /* : is used as delimiter */
          IF INDEX(ctime,"AM") > 0 OR INDEX(ctime,"PM") > 0 THEN
              /* this is US format, HH:MM:SS AM */
              itimeidx = 1.
          ELSE IF INDEX(ctime,".PD") > 0 OR INDEX(ctime,".MD") > 0 THEN
              /* this is albanian time format */
              itimeidx = 4.
          ELSE
              /* this is 24-hour HH:MM:SS time */
              itimeidx = 2.
      END.
      ELSE IF INDEX(ctime,".") > 0 THEN
      DO:
          /* . is used as delimiter */
          ASSIGN 
              itimeidx = 3.  /* HH.MM.SS */
      END.
  END.

  IF itimeidx = 1 OR itimeidx = 2 OR itimeidx = 4 THEN
      cdelim = ":":U.
  ELSE IF itimeidx = 3 THEN
      cdelim = ".":U.
  
  /* get the digits of the time */
  ASSIGN 
      chour = ENTRY(1,ctime,cdelim)
      cmin = ENTRY(2,ctime,cdelim)
      csec = ENTRY(3,ctime,cdelim).

  /* if this is US or Albanian time, check for AM/PM or PD/MD in csec */
  IF itimeidx = 1 THEN
      ASSIGN 
      cam = ENTRY(2,csec," ":U)
      csec = ENTRY(1,csec," ":U)
      lam = (IF cam = "AM":U THEN TRUE ELSE FALSE).
  ELSE IF itimeidx = 4 THEN
      ASSIGN 
      cam = ENTRY(2,csec,".":U)
      csec = ENTRY(1,csec,".":U)
      lam = (IF cam = "PD":U THEN TRUE ELSE FALSE) .

  ASSIGN 
      dtime = (INT(chour) + (IF lam THEN 0 ELSE 12)) * 3600 + 
              INT(cmin) * 60 + 
              INT(csec)
      NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-guessType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE guessType Procedure 
PROCEDURE guessType :
/*------------------------------------------------------------------------------
  Purpose:     Returns whether this log could be an AdminServer log file, 
               based on the filename.
  Parameters:  cLogFile - [input] name of log file to load
               lHandled - [output] TRUE if name indicates this is an
                          AdminServer log file, else FALSE.
  Notes:       This is part of the LogRead Handler API
------------------------------------------------------------------------------*/
    DEF INPUT PARAM cLogFile AS CHAR NO-UNDO.
    DEF OUTPUT PARAM lHandled AS LOG NO-UNDO.
    lHandled = (IF cLogFile = "admserv.log" THEN YES ELSE NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadLogFile Procedure 
PROCEDURE loadLogFile :
/*------------------------------------------------------------------------------
  Purpose:     Loads the contents of AdminServer log files.
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
    DEF OUTPUT PARAM htt AS HANDLE NO-UNDO.
    DEF OUTPUT PARAM lLoaded AS LOG INIT NO NO-UNDO.
    DEF OUTPUT PARAM irows AS INT INIT 0 NO-UNDO.
  
  DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cline AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ipos AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ipos2 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cdatetime AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ctime AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cdate AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dtime AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE ddate AS DATE       NO-UNDO.
  DEFINE VARIABLE iOK AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cnewmsg AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE llevel AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE clevel AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE csubsys AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE labort AS LOGICAL INIT FALSE  NO-UNDO.
  DEFINE VARIABLE lcancelled AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cincodepage AS CHAR NO-UNDO.

  CREATE TEMP-TABLE htt IN WIDGET-POOL "logpool".
  htt:ADD-NEW-FIELD("lineno","int").
  htt:ADD-NEW-FIELD("logdate","date").
  htt:ADD-NEW-FIELD("logtime","char").
  htt:ADD-NEW-FIELD("rawtime","dec").
  htt:ADD-NEW-FIELD("level","char").
  htt:ADD-NEW-FIELD("subsys","char").
  htt:ADD-NEW-FIELD("logmsg","char").

  /* Prepare the temp-table */
  htt:TEMP-TABLE-PREPARE("admsrv").

  /* get the default buffer for this temp-table */
  hbuf = htt:DEFAULT-BUFFER-HANDLE.

  IF iDateFmtix = 0 OR iDateFmtix = ? THEN
      RUN getDateFormatix(OUTPUT iDateFmtix).
  /* codepage */
  IF ccodepage <> ""  THEN
    RUN checkCPConversion IN hparent(ccodepage,OUTPUT cincodepage).
  ELSE
    cincodepage = SESSION:CHARSET.

  /* reset the time index */
  itimeidx = 0.
  
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

    IF NOT cline BEGINS "[" THEN NEXT.

    llevel = FALSE.

    /* date time */
    ASSIGN 
      ipos = INDEX(cline,"]")
      cdatetime = SUBSTRING(cline,2,ipos - 2).

    ASSIGN 
        ipos = INDEX(cdatetime," ":U)
        cdate = SUBSTRING(cdatetime,1,ipos - 1)
        ctime = SUBSTRING(cdatetime,ipos + 1).

    RUN getDateFromFormatix IN hparent(INPUT cdate,INPUT iDatefmtix, INPUT cSrcLang, OUTPUT ddate) NO-ERROR.
    /* check for error */
    IF ERROR-STATUS:ERROR THEN 
    DO:
        IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
    END.

    /* This is using a local routine, not that defined in logdate.i */
    RUN getTimeFromString(INPUT ctime,OUTPUT dtime) NO-ERROR.
    /* check for error */
    IF ERROR-STATUS:ERROR THEN 
    DO:
        IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
    END.

    RUN checkDateRange IN hparent(ddate,dtime,dStartDate,dStartTime,dEndDate,dEndTime,OUTPUT iOK).

    RUN getTimeString IN hparent(INPUT dtime,INPUT true,OUTPUT ctime).

    /* if before date range, skip to next line */
    IF iOK < 0 THEN NEXT.
    /* if after date range, exit loop and return */
    IF iOK > 0 THEN LEAVE.
    
    /* move after the time */
    cline = SUBSTRING(cline,LENGTH(cdatetime) + 3).
    /* look for error level and subsys */
    IF cline BEGINS " [" THEN
    DO:
        ASSIGN
            llevel = TRUE
            ipos = INDEX(cline,"]").
            clevel = SUBSTRING(cline,3,ipos - 3).
        ASSIGN 
            ipos = INDEX(cline,"[",ipos).
            ipos2 = INDEX(cline,"]",ipos).
            csubsys = SUBSTRING(cline,ipos + 1,ipos2 - ipos - 1).
            /* move to the end of the subsys, and extra whitespace */
        cline = SUBSTRING(cline,ipos + 22).
        cline = SUBSTRING(cline,3).
    END.
    /* rest of message */
    IF (csrcmsgs <> "" AND ctrgmsgs <> "") THEN
        RUN translatePromsg IN hparent(cline,csrcmsgs,ctrgmsgs,OUTPUT cnewmsg).
    ELSE
        cnewmsg = cline.

    hbuf:BUFFER-CREATE().
    /* increment the line number */
    irows = irows + 1.
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("lineno")
        hfld:BUFFER-VALUE = irows
        hfld:FORMAT = "zzzzzzz9".
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("logdate")
        hfld:BUFFER-VALUE = ddate
        hfld:FORMAT = "99/99/9999".
    ASSIGN
        hfld = hbuf:BUFFER-FIELD("rawtime")
        hfld:BUFFER-VALUE = dtime
        hfld:FORMAT = "zzzz9.999".
    ASSIGN 
        hfld = hbuf:BUFFER-FIELD("logtime")
        hfld:BUFFER-VALUE = ctime
        hfld:FORMAT = "x(255)".
    IF (llevel) THEN
    DO:
        ASSIGN 
            hfld = hbuf:BUFFER-FIELD("level")
            hfld:BUFFER-VALUE = clevel
            hfld:FORMAT = "X(255)".
        ASSIGN
            hfld = hbuf:BUFFER-FIELD("subsys")
            hfld:BUFFER-VALUE = csubsys
            hfld:FORMAT = "X(255)".
    END.
    ASSIGN 
        hfld = hbuf:BUFFER-FIELD("logmsg")
        hfld:BUFFER-VALUE = cnewmsg
        hfld:FORMAT = "X(255)".
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

