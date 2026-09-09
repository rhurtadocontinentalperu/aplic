&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : logread/handlers/enhlog.i
    Purpose     : Provides functions for handlers that handle log files
                  using the Enhanced Logging format.

    Syntax      : {logread/handlers/enhlog.i 
                      &tablename = "<tablename>" /* name of temp-table */
                      &logtype = "<logtype>"     /* log type */
                      &logdesc = "<logdesc>"     /* log type description */
                  }

    Description : This include files contains handler functionality for 
                  all logs that conform to the enhanced logging format, 
                  gradually introduced into Progress since 9.1D.

    Author(s)   : 
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

ASSIGN
  cLogType = "{&logtype}"
  cTypeName = "{&logdesc}" .

RUN addQuery("Default","by lineno").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateFormatix Include 
PROCEDURE getDateFormatix :
/*------------------------------------------------------------------------------
  Purpose:     For all handlers supporting the enhanced logging format, 
               returns the index of the date format in the date format array.
               Refer to logread/logdate.i for more information.
               
  Parameters:  ifmtix - index to appropriate date format in the date format array
  Notes:       This is part of the LogRead Handler API
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAM ifmtix AS INT NO-UNDO.
  ifmtix = 2.  /* YY/MM/DD */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHiddenCols Include 
PROCEDURE getHiddenCols :
/*------------------------------------------------------------------------------
  Purpose:     For handlers supporting the enhanced logging format, returns the
               list of hidden column names. These are names that should not 
               be displayed in the Log Browse window.
  Parameters:  chidcol - CSV list of hidden column names
  Notes:       This is part of the LogRead Handler API.
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM chidcol AS CHAR NO-UNDO.
    chidcol = "rawtime".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMergeFields Include 
PROCEDURE getMergeFields :
/*------------------------------------------------------------------------------
  Purpose:     For handlers supporting the enhanced logging format, returns
               a CSV list of fields used for merging, and a CSV list of fields
               that should not appear in a merge.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadLogFile Include 
PROCEDURE loadLogFile :
/*------------------------------------------------------------------------------
  Purpose:     Loads the contents of log files for handlers that handle the 
               enhances logging format.
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
    DEF INPUT PARAM cCodepage AS CHAR NO-UNDO.
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
    DEFINE VARIABLE cmsg AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cnewmsg AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cdate AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE ctime AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE rfirstrow AS ROWID  NO-UNDO.
    DEFINE VARIABLE lfirstrow AS LOGICAL INIT NO NO-UNDO.
    DEFINE VARIABLE lundated AS LOGICAL INIT NO  NO-UNDO.
    DEFINE VARIABLE ddate AS DATE       NO-UNDO.
    DEFINE VARIABLE dtime AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE iOK AS INTEGER    NO-UNDO.
    DEFINE VARIABLE ipos1 AS INTEGER    NO-UNDO.
    DEFINE VARIABLE ipos2 AS INTEGER    NO-UNDO.
    DEFINE VARIABLE ccomp AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE csubsys AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lline AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cpid AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE ctid AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE clevel AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE clogmsg AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE labort AS LOGICAL INIT FALSE  NO-UNDO.
    DEFINE VARIABLE lcancelled AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cincodepage AS CHARACTER  NO-UNDO.
    
    CREATE TEMP-TABLE htt IN WIDGET-POOL "logpool".
    htt:ADD-NEW-FIELD("lineno","int").
    htt:ADD-NEW-FIELD("logdate","date").  
    htt:ADD-NEW-FIELD("logtime","char",0,"x(15)").  /* display time */
    htt:ADD-NEW-FIELD("rawtime","dec",0,"zzzz9.999").   /* real time */
    htt:ADD-NEW-FIELD("pid","char").
    htt:ADD-NEW-FIELD("tid","char").
    htt:ADD-NEW-FIELD("level","char").
    htt:ADD-NEW-FIELD("comp","char",0,"x(20)").
    htt:ADD-NEW-FIELD("subsys","char",0,"x(20)").
    htt:ADD-NEW-FIELD("logmsg","char",0,"x(256)").
    htt:TEMP-TABLE-PREPARE( "{&tablename}" ).
    
    hbuf = htt:DEFAULT-BUFFER-HANDLE.

    /* set default date format */
    IF iDateFmtix = 0 OR iDateFmtix = ? THEN
        RUN getDateFormatix(OUTPUT iDateFmtix).
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
        /* java logs have a line of "=" separating sessions. 
         * These have no date, and will screw up our formatting,
         * so we will just ignore them. */
        lline = (cline BEGINS "========").  

        /* update history rows, with the whole row */
        ASSIGN 
            ihistidx = (IF ihistidx = 4 THEN 1 ELSE
                        (ihistidx + 1))
            chist[ihistidx] = cline.

        /* check the date first */
        IF NOT lline THEN
        DO:
            ASSIGN 
                cdate = SUBSTRING(cline,2,8)
                ctime = SUBSTRING(cline,11,12).
            
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
            IF iOK < 0 THEN NEXT LOADBLOCK.
            /* if after date range, exit loop and return */
            IF iOK > 0 THEN LEAVE LOADBLOCK.
        END.
        ELSE
            lundated = TRUE.

        /* update history rows, with the whole row */
        ASSIGN 
            chist[ihistidx] = cline
            ihistidx = (IF ihistidx = 4 THEN 1 ELSE
                        (ihistidx + 1)).
        
        RUN getTimeString IN hparent(INPUT dtime,INPUT true,OUTPUT ctime).
        
        IF ERROR-STATUS:ERROR THEN
        DO:
            IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
        END.

        IF (NOT lline) THEN
        DO:
            ASSIGN 
                cpid = SUBSTRING(cline,30,8) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                IF abortLoad(INPUT FALSE,INPUT irows,INPUT ?,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
            END.

            /* TID is not always 8 chars long for logs written by java.
             * In AIA, for example, it has the thread name from the JSE.
             * Instead, search for the first space char, followed by a number.
             * There may be > 1 space until the number, depending on the component. */
            ipos1 = INDEX(cline," ",39) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                IF abortLoad(INPUT FALSE,INPUT irows,INPUT ?,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
            END.

            TIDBLOCK:
            DO WHILE (TRUE):
                IF (ipos1 > 0) THEN
                DO:
                    /* absorb any spaces */
                    ipos2 = ipos1 + 1.
                    DO WHILE (SUBSTRING(cline,ipos2,1) = " "):
                        ipos2 = ipos2 + 1.
                    END.
                    /* ipos2 now points to a non-space char */
                    ipos1 = ipos2 - 1.  
                    ASSIGN ipos2 = INT(SUBSTRING(cline,ipos1 + 1,1)) NO-ERROR.
                    /* check for error, to see if this is numeric or not */
                    IF NOT ERROR-STATUS:ERROR THEN
                    DO:
                        /* no error, ipos1 is the end of the TID string */
                        ASSIGN 
                            ctid = SUBSTRING(cline,39,ipos1 - 39)
                            ipos1 = ipos1 + 1 NO-ERROR.
                        IF ERROR-STATUS:ERROR THEN
                        DO:
                            IF abortLoad(INPUT FALSE,INPUT irows,INPUT ?,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
                        END.

                        LEAVE TIDBLOCK.
                    END.
                END.
                ELSE
                DO:
                    /* didn't find a space in the rest of the line.
                     * Wing it, assume the TID is just 8 chars long */
                    ASSIGN
                        ctid = SUBSTRING(cline,39,8)
                        ipos1 = 48 NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN
                    DO:
                        IF abortLoad(INPUT FALSE,INPUT irows,INPUT ?,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
                    END.

                    LEAVE TIDBLOCK.
                END.
                ipos1 = INDEX(cline," ",ipos1 + 1) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                DO:
                    IF abortLoad(INPUT FALSE,INPUT irows,INPUT ?,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
                END.

            END. /* TIDBLOCK */
            /* remove up to ipos1 now */
            cline = SUBSTRING(cline,ipos1).
    
            /* logginglevel is always 1 digit */
            ASSIGN clevel = SUBSTRING(cline,1,1).

            IF ERROR-STATUS:ERROR THEN
            DO:
                IF abortLoad(INPUT FALSE,INPUT irows,INPUT ?,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
            END.

            /* comp and subsys are space-separated */
            cline = SUBSTRING(cline,3).
            /* find first two spaces */
            ipos1 = INDEX(cline," ").
            ipos2 = INDEX(cline," ",ipos1 + 1).
            IF ipos2 = ipos1 + 1 THEN
            DO:
                /* comp ends with a space... webspeed messenger */
                ASSIGN 
                    ccomp = SUBSTRING(cline,1,ipos2 - 1)
                    cline = SUBSTRING(cline,ipos2 + 1) NO-ERROR.
            END.
            ELSE
            DO:
                /* single space b/w comp and subsys */
                ASSIGN
                    ccomp = SUBSTRING(cline,1,ipos1 - 1)
                    cline = SUBSTRING(cline,ipos1 + 1) NO-ERROR.
            END.
            IF ERROR-STATUS:ERROR THEN
            DO:
                IF abortLoad(INPUT FALSE,INPUT irows,INPUT ?,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
            END.

            /* subsys */
            ASSIGN 
                ipos1 = INDEX(cline," ")
                csubsys = SUBSTRING(cline,1,ipos1 - 1)
                cline = SUBSTRING(cline,ipos1 + 1) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                IF abortLoad(INPUT FALSE,INPUT irows,INPUT ?,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
            END.
    
            /* cmsg = SUBSTRING(cline,63). */
            cmsg = cline.
            /* only translate if ends in a promsg () */
            IF cSrcMsgs <> "" AND cTrgMsgs <> "" THEN
                RUN translatePromsg IN hparent(cmsg,cSrcMsgs,cTrgMsgs,OUTPUT cnewmsg) NO-ERROR.
            ELSE
                cnewmsg = cmsg.
            IF ERROR-STATUS:ERROR THEN
            DO:
                IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
            END.

        END.  /* if not lline */

        /* create record now that all parsing is done */
        hbuf:BUFFER-CREATE().
        /* increment the line number */
        irows = irows + 1.
        ASSIGN 
            hfld = hbuf:BUFFER-FIELD("logdate")
            hfld:BUFFER-VALUE = ddate
            hfld:FORMAT = "99/99/9999" NO-ERROR.
        ASSIGN
            hfld = hbuf:BUFFER-FIELD("rawtime")
            hfld:BUFFER-VALUE = dtime
            hfld:FORMAT = "-zzzzzz9.99" NO-ERROR.
        ASSIGN 
            hfld = hbuf:BUFFER-FIELD("logtime")
            hfld:BUFFER-VALUE = ctime.
            hfld:FORMAT = "X(15)" NO-ERROR.
        IF (lline) THEN
        DO:
            ASSIGN 
                hfld = hbuf:BUFFER-FIELD("logmsg")
                hfld:BUFFER-VALUE = cline
                hfld:FORMAT = "x(255)" NO-ERROR.
            rfirstrow = hbuf:ROWID.
        END.
        ELSE
        DO:
            ASSIGN
                hfld = hbuf:BUFFER-FIELD("pid")
                hfld:BUFFER-VALUE = cpid
                hfld:FORMAT = "x(15)" NO-ERROR.
            ASSIGN
                hfld = hbuf:BUFFER-FIELD("tid")
                hfld:BUFFER-VALUE = ctid
                hfld:FORMAT = "x(15)" NO-ERROR.
            ASSIGN
                hfld = hbuf:BUFFER-FIELD("level")
                hfld:BUFFER-VALUE = clevel
                hfld:FORMAT = "x(10)" NO-ERROR.
            ASSIGN 
                hfld = hbuf:BUFFER-FIELD("comp")
                hfld:BUFFER-VALUE = ccomp
                hfld:FORMAT = "x(50)" NO-ERROR.
            ASSIGN
                hfld = hbuf:BUFFER-FIELD("subsys")
                hfld:BUFFER-VALUE = csubsys
                hfld:FORMAT = "x(50)" no-error.
            ASSIGN 
                hfld = hbuf:BUFFER-FIELD("logmsg")
                hfld:BUFFER-VALUE = cnewmsg
                hfld:FORMAT = "x(255)" NO-ERROR.
        END.

        ASSIGN
            hfld = hbuf:BUFFER-FIELD(1)
            hfld:BUFFER-VALUE = irows
            hfld:FORMAT = "zzzzzzz9".

        /* if there are errors, determine what to do */
        hbuf:BUFFER-RELEASE().

        /* now, if undated and not lline, add this date to rfirstrow */
        IF (lundated AND NOT lline) THEN
        DO TRANSACTION:
            lundated = FALSE.
            hbuf:FIND-BY-ROWID(rfirstrow,EXCLUSIVE-LOCK).
            /* check the date range */
            RUN checkDateRange IN hparent(ddate,dtime,dStartDate,dStartTime,dEndDate,dEndTime,OUTPUT iOK).
            IF (iOK <> 0) THEN
                hbuf:BUFFER-DELETE().
            ELSE
            DO:
                /* else update the date */
                ASSIGN
                    hfld = hbuf:BUFFER-FIELD("rawtime")
                    hfld:BUFFER-VALUE = dtime.
                ASSIGN
                    hfld = hbuf:BUFFER-FIELD("logtime")
                    hfld:BUFFER-VALUE = ctime.
                ASSIGN 
                    hfld = hbuf:BUFFER-FIELD("logdate")
                    hfld:BUFFER-VALUE = ddate.
                ASSIGN
                    hfld = hbuf:BUFFER-FIELD("pid")
                    hfld:BUFFER-VALUE = cpid.
                ASSIGN 
                    hfld = hbuf:BUFFER-FIELD("tid")
                    hfld:BUFFER-VALUE = ctid.
                hbuf:BUFFER-RELEASE.
            END.
        END.

    END.  /* LOADBLOCK */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE util_ShowCurrentThread Include 
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
    DEF INPUT PARAM /* TABLE-HANDLE */ htt AS HANDLE NO-UNDO.
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
        hfld = hbuf:BUFFER-FIELD("pid")
        cqry = "pid = ~"" + hfld:BUFFER-VALUE + "~" and "
            hfld = hbuf:BUFFER-FIELD("tid")
            cqry = cqry + "tid = ~"" + hfld:BUFFER-VALUE + "~"".
        RUN openViewer IN hparent (cFileName,cqry,hview).
    END.
    ELSE
        MESSAGE "No message selected. Please select a row"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

