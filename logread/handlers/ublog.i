&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

RUN addQuery("Default","by lineno").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateFormatix Include 
PROCEDURE getDateFormatix :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAM ifmtix AS INT NO-UNDO.
  ifmtix = 16. /* "MMM DD, YYYY" */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHiddenCols Include 
PROCEDURE getHiddenCols :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM chidcol AS CHAR NO-UNDO.
    chidcol = "rawtime".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMergeFields Include 
PROCEDURE getMergeFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
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
  Purpose:     
  Parameters:  <none>
  Notes:       
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
    /* if the first record does not have date field, initialise it */
    DEFINE VARIABLE cstamp AS CHARACTER  INIT "Jan 1, 1970 00:00:00:000" NO-UNDO .
    DEFINE VARIABLE claststamp AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dlastdate AS DATE INIT 01/01/1970 NO-UNDO.
    DEFINE VARIABLE dlasttime AS DECIMAL INIT 0.0   NO-UNDO.
    DEFINE VARIABLE ddate AS DATE       NO-UNDO.
    DEFINE VARIABLE ctid AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cpid AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cdate AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dtime AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE ctime AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE rfirstrow AS ROWID  NO-UNDO.
    DEFINE VARIABLE lfirstrow AS LOGICAL INIT NO NO-UNDO.
    DEFINE VARIABLE lundated AS LOGICAL INIT NO  NO-UNDO.
    DEFINE VARIABLE cdateformat AS CHARACTER INIT "" NO-UNDO.
    DEFINE VARIABLE iOK AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cnewmsg AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE labort AS LOGICAL INIT FALSE  NO-UNDO.
    DEFINE VARIABLE lcancelled AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cincodepage AS CHARACTER  NO-UNDO.
    
    CREATE TEMP-TABLE htt IN WIDGET-POOL "logpool".
    htt:ADD-NEW-FIELD("lineno","int").
    htt:ADD-NEW-FIELD("logdate","date").
    htt:ADD-NEW-FIELD("logtime","char").
    htt:ADD-NEW-FIELD("rawtime","dec").
    htt:ADD-NEW-FIELD("tid","char").
    htt:ADD-NEW-FIELD("pid","char").
    htt:ADD-NEW-FIELD("logmsg","char").
    htt:TEMP-TABLE-PREPARE("{&tablename}").
    
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
                IF abortLoad(INPUT TRUE,INPUT irows,INPUT ?,OUTPUT labort) THEN
                    LEAVE LOADBLOCK.
            END.
            RUN updateProgressWindow IN hparent(INPUT "Loaded " + STRING(irows)).
        END.

        IMPORT UNFORMATTED cline.
        IF LENGTH(cline) = 0 THEN NEXT.

        /* update history rows, with the whole row */
        ASSIGN 
            ihistidx = (IF ihistidx = 4 THEN 1 ELSE
                        (ihistidx + 1))
            chist[ihistidx] = cline.

        /* ID of thread that logged this message */
        ipos = INDEX(cline,">").
        IF (ipos > 0) THEN
        DO:
            ctid = SUBSTRING(cline,1,ipos - 1).
            cline = SUBSTRING(cline,ipos + 1).            
        END.
        /* date and time */
        IF cline BEGINS "(" THEN
        DO:
            ipos = INDEX(cline,")").
            claststamp = cstamp.
            cstamp = SUBSTRING(cline,2,ipos - 2).
            cline = SUBSTRING(cline,ipos + 2).
            
            ctime = ENTRY(NUM-ENTRIES(cstamp," ":U),cstamp," ":U).
            cdate = SUBSTRING(cstamp,1,LENGTH(cstamp) - LENGTH(ctime)).
            /* check if this is not a date format, but some weird logging */
            IF (ctime <> "" AND cdate <> "") THEN
            DO:
                RUN getTimeFromString IN hparent(ctime,OUTPUT dtime) NO-ERROR.
                /* check for error */
                IF ERROR-STATUS:ERROR THEN 
                DO:
                    IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
                END.

                RUN getDateFromFormatix IN hparent(INPUT cdate,INPUT iDatefmtix, INPUT cSrcLang, OUTPUT ddate) NO-ERROR.
                /* check for error */
                IF ERROR-STATUS:ERROR THEN 
                DO:
                    IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
                END.

                RUN getTimeString IN hparent(INPUT dtime,INPUT true, OUTPUT ctime) NO-ERROR.
                IF (ddate = ?) THEN
                    ASSIGN 
                    ddate = dlastdate
                    dtime = dlasttime.
                ELSE
                    ASSIGN 
                        dlasttime = dtime
                        dlastdate = ddate.
                /* if there was a "=====" row, set the date on it */
                IF (lundated) THEN
                DO TRANSACTION:
                    /* find the row */
                    hbuf:FIND-BY-ROWID(rfirstrow,EXCLUSIVE-LOCK).
                    /* check if it is in the date range */
                    RUN checkDateRange IN hparent(ddate,dtime,dStartDate,dStartTime,dEndDate,dEndTime,OUTPUT iOK).
                    /* if not in date range, delete */
                    IF iok <> 0 THEN
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
                        hbuf:BUFFER-RELEASE.
                    END.
                    ASSIGN
                      lundated = FALSE.
                END.

            END.  /* if not (ctime = "" or cdate = "") */
            ELSE
                /* this is not a date */
                ASSIGN
                    ddate = dlastdate
                    dtime = dlasttime.
        END.

        IF cline BEGINS "========" THEN
            lfirstrow = TRUE.
        
        /* date and time check */
        RUN checkDateRange IN hparent(ddate,dtime,dStartDate,dStartTime,dEndDate,dEndTime,OUTPUT iOK).
        /* if before date range, skip to next line */
        IF iOK < 0 THEN NEXT.
        /* if after date range, exit loop and return */
        IF iOK > 0 THEN LEAVE.
            
        /* pid */
        cline = TRIM(cline).
        IF cline BEGINS "[" THEN
        DO:
            ipos2 = INDEX(cline,"]").
            cpid = SUBSTRING(cline,2,ipos2 - 2).

            cline = trim(SUBSTRING(cline,ipos2 + 2)).
        END.

        /* rest of message */
        IF (csrcmsgs <> "" AND ctrgmsgs <> "") THEN
            RUN translatePromsg IN hparent(cline,csrcmsgs,ctrgmsgs,OUTPUT cnewmsg) NO-ERROR.
        ELSE
            cnewmsg = cline.
        IF ERROR-STATUS:ERROR THEN
        DO:
            IF abortLoad(INPUT FALSE,INPUT irows,INPUT RETURN-VALUE,OUTPUT labort) THEN LEAVE LOADBLOCK. ELSE NEXT LOADBLOCK.
        END.

        /* create record after all error checking */
        hbuf:BUFFER-CREATE().
        /* increment the line number */
        irows = irows + 1.

        ASSIGN 
            hfld = hbuf:BUFFER-FIELD("logtime")
            hfld:BUFFER-VALUE = ctime
            hfld:FORMAT = "x(255)" NO-ERROR.
        ASSIGN 
            hfld = hbuf:BUFFER-FIELD("rawtime")
            hfld:BUFFER-VALUE = dtime
            hfld:FORMAT = "zzzzz9.999" NO-ERROR.
        ASSIGN
            hfld = hbuf:BUFFER-FIELD("logdate")
            hfld:BUFFER-VALUE = ddate
            hfld:FORMAT = "99/99/9999" NO-ERROR.
        ASSIGN
            hfld = hbuf:BUFFER-FIELD("tid")
            hfld:BUFFER-VALUE = ctid
            hfld:FORMAT = "x(255)" NO-ERROR.
        ASSIGN 
        hfld = hbuf:BUFFER-FIELD("pid")
        hfld:BUFFER-VALUE = cpid
        hfld:FORMAT = "x(255)" NO-ERROR.
        ASSIGN
        hfld = hbuf:BUFFER-FIELD("logmsg")
        hfld:BUFFER-VALUE = cnewmsg
        hfld:FORMAT = "x(255)".
        ASSIGN 
        hfld = hbuf:BUFFER-FIELD("lineno")
        hfld:BUFFER-VALUE = irows
        hfld:FORMAT = "zzzzzzz9".

        IF lfirstrow THEN
            ASSIGN 
                rfirstrow = hbuf:ROWID
                lfirstrow = FALSE
                lundated = TRUE.
        hbuf:BUFFER-RELEASE.        
       
    END.
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
  Purpose:     
  Parameters:  <none>
  Notes:       
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
        hfld = hbuf:BUFFER-FIELD("tid")
        cqry = "tid = ~"" + hfld:BUFFER-VALUE + "~" by lineno".
        RUN openViewer IN hparent (cFileName,cqry,hview).
    END.
    ELSE
        MESSAGE "No message selected. Please select a row"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

