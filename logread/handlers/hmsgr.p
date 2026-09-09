&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : logread/handlers/hmsgr.p
    Purpose     : Log Type Handler for Messenger log files

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

/* include enhanced logging */
{logread/handlers/enhlog.i 
    &tablename = "msgrlog" 
    &logtype = "msgr"
    &logdesc = "Msgr Log File"
}

DEFINE VARIABLE icolseq AS INTEGER    NO-UNDO.

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
RUN addQuery("MsgrFailQuery","comp = ~"cgi~" by tid by pid by lineno").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addCollLogType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addCollLogType Procedure 
PROCEDURE addCollLogType PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Adds a pseudo log type for the output of util_CollateRequests
  Parameters:  
    hparent - [IN] handle to the LogRead main window
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM hparent AS HANDLE NO-UNDO.

    DEFINE VARIABLE clogtypes AS CHARACTER  NO-UNDO.

    RUN getLogTypes IN hparent(INPUT "",INPUT false, OUTPUT clogtypes).
    IF NOT CAN-DO("collmsgr",clogtypes) THEN
    DO:
        RUN addPseudoType IN hparent(INPUT "collmsgr",INPUT "Collated Messenger","rawstarttime,rawendtime","","").
        RUN addPseudoTypeQuery IN hparent(INPUT "collmsgr",INPUT "StartTime",INPUT "true by logdate by starttime").
        RUN addPseudoTypeQuery IN hparent(INPUT "collmsgr",INPUT "EndTime",INPUT "true by logdate by endtime").
        RUN addPseudoTypeQuery IN hparent(INPUT "collmsgr",INPUT "CGIIP",INPUT "msgr = ~"CGIIP~"").
        RUN addPseudoTypeQuery IN hparent(INPUT "collmsgr",INPUT "WSISA",INPUT "msgr = ~"WSISA~"").
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-guessType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE guessType Procedure 
PROCEDURE guessType :
/*------------------------------------------------------------------------------
  Purpose:     Returns whether this log could be a Messenger log file, 
               based on the filename.
  Parameters:  cLogFile - [input] name of log file to load
               lHandled - [output] TRUE if name indicates this is a
                          Messenger log file, else FALSE.
  Notes:       This is part of the LogRead Handler API
------------------------------------------------------------------------------*/
    DEF INPUT PARAM cLogFile AS CHAR NO-UNDO.
    DEF OUTPUT PARAM lHandled AS LOG NO-UNDO.
    lHandled = (IF cLogFile = "msgr.log" THEN YES ELSE NO).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-util_CollateRequests) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE util_CollateRequests Procedure 
PROCEDURE util_CollateRequests :
/*------------------------------------------------------------------------------
  Purpose:     Utility to summarise all the separate log messages in the 
               messenger log as individual requests. Displays the output as
               a new log, with pseudo log type of collmsgr.
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
    DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cqry AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cOldLog AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE htt2 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hbuf2 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hfld2 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE irows AS INTEGER    NO-UNDO.
    DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.

    DEFINE VARIABLE msgr AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE ldate AS DATE  NO-UNDO.
    DEFINE VARIABLE starttime AS DEC  NO-UNDO.
    DEFINE VARIABLE endtime AS DEC  NO-UNDO.
    DEFINE VARIABLE ctime AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE pid AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE tid AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE method AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE uri AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE qrystr AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE agentport AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE comment AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cstate AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lnohdr AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE itime1 AS DEC    NO-UNDO.
    DEFINE VARIABLE itime2 AS DEC    NO-UNDO.
    DEFINE VARIABLE ireqbyte AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iresbyte AS INTEGER    NO-UNDO.
    DEFINE VARIABLE leop AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE ipos1 AS INTEGER    NO-UNDO.
    DEFINE VARIABLE ipos2 AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lendhdr AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE crcvagt AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE crcvhex AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cbrk AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE chttphdr AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE ccookie AS CHARACTER  NO-UNDO.


    /* sequential name for the new temp-table */
    ASSIGN 
        cFileName = "MSGR" + string(icolseq,"9999")
        icolseq = icolseq + 1.

    /* add a new logtype */
    RUN addCollLogType(hparent).

    /* create a new temp table */
    CREATE TEMP-TABLE htt2 IN WIDGET-POOL "logpool".
    htt2:ADD-NEW-FIELD("logdate","date").
    htt2:ADD-NEW-FIELD("rawstarttime","dec").
    htt2:add-new-field("rawendtime","dec").
    htt2:ADD-NEW-FIELD("starttime","char").
    htt2:ADD-NEW-FIELD("endtime","char").
    htt2:ADD-NEW-FIELD("rsecs","dec").
    htt2:ADD-NEW-FIELD("msgr","char").
    htt2:ADD-NEW-FIELD("pid","char").
    htt2:ADD-NEW-FIELD("tid","char").
    htt2:ADD-NEW-FIELD("method","char").
    htt2:ADD-NEW-FIELD("uri","char").
    htt2:ADD-NEW-FIELD("qrystr","char").
    htt2:ADD-NEW-FIELD("wseu","char").
    htt2:ADD-NEW-FIELD("agentport","char").
    htt2:ADD-NEW-FIELD("httphdr","char").
    htt2:ADD-NEW-FIELD("cookies","char").
    htt2:ADD-NEW-FIELD("rq-bytes","int").
    htt2:ADD-NEW-FIELD("rs-bytes","int").
    htt2:ADD-NEW-FIELD("comment","char").
    htt2:TEMP-TABLE-PREPARE(cFileName).

    hbuf2 = htt2:DEFAULT-BUFFER-HANDLE.

    hbuf = htt:DEFAULT-BUFFER-HANDLE.
    CREATE QUERY hqry.
    hqry:SET-BUFFERS(hbuf).
    hqry:QUERY-PREPARE("for each " + hbuf:NAME + " by tid by pid by lineno").
    hqry:QUERY-OPEN.

    REPEAT:
        hqry:GET-NEXT().
        IF hqry:QUERY-OFF-END THEN LEAVE.

        IF (hbuf:BUFFER-FIELD("subsys"):BUFFER-VALUE = "term-rq" AND msgr = "CGIIP") OR
            (hbuf:BUFFER-FIELD("subsys"):BUFFER-VALUE = "dsc-bkr" AND msgr = "WSISA") THEN
            ASSIGN endtime = hbuf:BUFFER-FIELD("rawtime"):BUFFER-VALUE.

        /* end of old or start of new request */
        IF (hbuf:BUFFER-FIELD("pid"):BUFFER-VALUE <> pid OR hbuf:BUFFER-FIELD("tid"):BUFFER-VALUE <> tid) OR
            (hbuf:BUFFER-FIELD("subsys"):BUFFER-VALUE = "init-rq" AND msgr <> "") OR 
            (hbuf:BUFFER-FIELD("subsys"):BUFFER-VALUE = "term-rq") OR 
            (hbuf:buffer-field("subsys"):BUFFER-VALUE = "dsc-bkr" AND msgr <> "CGIIP") or
            (hbuf:buffer-field("subsys"):BUFFER-VALUE = "XMT-BKR" AND hbuf:buffer-field("logmsg"):BUFFER-VALUE BEGINS "Port Request: " AND msgr <> "CGIIP") THEN
        DO:
            /* save out request */
            IF msgr <> "" THEN
            DO:
                /* check if there was no header */
                IF lnohdr THEN
                    comment = comment + "No HTTP header. ".
                IF NOT leop THEN
                    comment = comment + "No EOP Msg. ".
                /* calculate the time */
                IF (starttime <> ? AND endtime <> ?) THEN
                DO:
                    ASSIGN 
                        itime1 = starttime
                        itime2 = endtime.
                END.
                /* look for wseu */
                ipos1 = INDEX(cbrk,"WSEU=").
                IF (ipos1 > 0) THEN
                    cbrk = SUBSTRING(cbrk,ipos1 + 5).
                ELSE
                    cbrk = "".
                /* http headers, 1st 48 bytes are header */
                chttphdr = SUBSTRING(crcvagt,48).
                /* look for cookies */
                ipos1 = INDEX(crcvagt,"Content-type").
                ipos2 = INDEX(chttphdr,"Set-Cookie").
                IF (ipos2 > 0) THEN
                    ccookie = SUBSTRING(chttphdr,ipos2).
                ELSE
                    ccookie = "".

            hbuf2:BUFFER-CREATE().
            ASSIGN 
                hbuf2:BUFFER-FIELD("msgr"):BUFFER-VALUE = msgr
                hbuf2:BUFFER-FIELD("logdate"):BUFFER-VALUE = ldate
                hbuf2:BUFFER-FIELD("rawstarttime"):BUFFER-VALUE = starttime
                hbuf2:BUFFER-FIELD("rawendtime"):BUFFER-VALUE = endtime
                hbuf2:BUFFER-FIELD("rsecs"):BUFFER-VALUE = (itime2 - itime1)
                hbuf2:BUFFER-FIELD("pid"):BUFFER-VALUE = pid
                hbuf2:BUFFER-FIELD("tid"):BUFFER-VALUE = tid
                hbuf2:BUFFER-FIELD("method"):BUFFER-VALUE = 
                  (IF method = "POST" AND ireqbyte = 41 THEN "GET" ELSE method)
                hbuf2:BUFFER-FIELD("uri"):BUFFER-VALUE = uri
                hbuf2:BUFFER-FIELD("qrystr"):BUFFER-VALUE = qrystr
                hbuf2:BUFFER-FIELD("agentport"):BUFFER-VALUE = agentport
                hbuf2:BUFFER-FIELD("rq-bytes"):BUFFER-VALUE = ireqbyte - 41
                hbuf2:BUFFER-FIELD("rs-bytes"):BUFFER-VALUE = iresbyte
                hbuf2:BUFFER-FIELD("comment"):BUFFER-VALUE = comment
                hbuf2:BUFFER-FIELD("wseu"):BUFFER-VALUE = cbrk
                hbuf2:BUFFER-FIELD("httphdr"):BUFFER-VALUE = chttphdr
                hbuf2:BUFFER-FIELD("cookies"):BUFFER-VALUE = ccookie
                irows = irows + 1
                .
              /* set the character times */
              RUN getTimeString IN hparent(starttime, true, OUTPUT ctime).
              hbuf2:BUFFER-FIELD("starttime"):BUFFER-VALUE = ctime.
              RUN getTimeString IN hparent(endtime, true, OUTPUT ctime).
              hbuf2:BUFFER-FIELD("endtime"):BUFFER-VALUE = ctime.

              DO ictr = 1 TO hbuf2:NUM-FIELDS:
                  IF hbuf2:BUFFER-FIELD(ictr):DATA-TYPE BEGINS "CHAR" THEN
                     ASSIGN hbuf2:BUFFER-FIELD(ictr):FORMAT = "X(255)".
              END.
            END.
            /* blank out the fields */
                ASSIGN msgr = ""
                    starttime = ?
                    crcvagt = ""
                    crcvhex = ""
                    cbrk = ""
                    ldate = ?
                    pid = ""
                    tid = ""
                    method = "POST"
                    uri = ""
                    qrystr = ""
                    agentport = ""
                    comment = ""
                    lnohdr = TRUE
                    lendhdr = FALSE
                    itime1 = 0
                    itime2 = 0
                    iresbyte = 0
                    ireqbyte = 0
                    leop = FALSE.
                    .
        END.
        IF (hbuf:BUFFER-FIELD("subsys"):BUFFER-VALUE = "init-rq") THEN
        DO:
            /* start of cgiip msgr */
            ASSIGN 
                msgr = "CGIIP"
                starttime = hbuf:BUFFER-FIELD("rawtime"):BUFFER-VALUE
                ldate = hbuf:BUFFER-FIELD("logdate"):BUFFER-VALUE
                pid = hbuf:BUFFER-FIELD("pid"):BUFFER-VALUE
                tid = hbuf:BUFFER-FIELD("tid"):BUFFER-VALUE
                .
        END.
        ELSE IF (hbuf:buffer-field("subsys"):BUFFER-VALUE = "XMT-BKR" AND 
                 hbuf:buffer-field("logmsg"):BUFFER-VALUE BEGINS "Port Request: " 
                 AND msgr <> "CGIIP") THEN
        DO:
            ASSIGN 
                msgr = "WSISA" /* assume wsisa for the moment */
                starttime = hbuf:BUFFER-FIELD("rawtime"):BUFFER-VALUE
                ldate = hbuf:BUFFER-FIELD("logdate"):BUFFER-VALUE
                pid = hbuf:BUFFER-FIELD("pid"):BUFFER-VALUE
                tid = hbuf:BUFFER-FIELD("tid"):BUFFER-VALUE
                .
        END.
        IF hbuf:BUFFER-FIELD("comp"):BUFFER-VALUE = "ENV" AND 
            hbuf:buffer-field("logmsg"):BUFFER-VALUE BEGINS "PATH_INFO=" THEN
            uri = SUBSTRING(hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE,12).
        IF hbuf:BUFFER-FIELD("comp"):BUFFER-VALUE = "ENV" AND 
            hbuf:buffer-field("logmsg"):BUFFER-VALUE BEGINS "QUERY_STRING=" THEN
            ASSIGN 
                method = "GET"
                qrystr = SUBSTRING(hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE,15).
        IF cstate <> "" AND NOT hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE BEGINS "000" THEN
            cstate = "".
        IF hbuf:BUFFER-FIELD("subsys"):BUFFER-VALUE = "RCV-BKR" AND 
            hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE BEGINS "Port Response Buffer:" THEN
            cstate = "Port Response Buffer:".
        IF hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE BEGINS "00" THEN
        DO:
            IF cstate BEGINS "Port Response Buffer:" THEN
                agentport = substring(hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE,8,6).
            ELSE IF cstate BEGINS "Agnt Response Buffer:" THEN
            DO:
                IF hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE MATCHES "*Content-type*" OR
                    hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE MATCHES "*Set-Cookie*" THEN
                    lnohdr = FALSE.
                IF hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE BEGINS "000000:WeBsPeEdEoP" THEN
                    ASSIGN iresbyte = iresbyte - 11 /* remove the eop from the sent bytes */
                    leop = TRUE.
            END.
        END.
        IF hbuf:BUFFER-FIELD("subsys"):BUFFER-VALUE = "RCV-AGT" and
            hbuf:buffer-field("logmsg"):BUFFER-VALUE BEGINS "Agnt Response Buffer:" THEN
            ASSIGN 
            cstate = "Agnt Response Buffer:"
            iresbyte = iresbyte + INT(SUBSTRING(hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE,28))
            NO-ERROR.
        IF hbuf:BUFFER-FIELD("subsys"):BUFFER-VALUE = "RCV-AGT" AND
            hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE BEGINS "WebSpeed Agent Error:" THEN
            comment = comment + hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE + " ".
        IF hbuf:BUFFER-FIELD("subsys"):BUFFER-VALUE = "XMT-AGT" and
            hbuf:buffer-field("logmsg"):BUFFER-VALUE BEGINS "Form Input Request:" THEN
            ASSIGN 
            ireqbyte = ireqbyte + INT(SUBSTRING(hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE,35))
            NO-ERROR.
        IF hbuf:BUFFER-FIELD("subsys"):BUFFER-VALUE = "RCV-AGT" AND
            hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE BEGINS "00" AND lendhdr = FALSE THEN
        DO:
            /* we don't want to accumulate the entire response here, 
             * as it could be large, and we don't want to blow 32K.
             * instead, look for 0D 0A 0D 0A in crcvagt, 
             * and stop recording after this */
            ASSIGN 
                crcvagt = crcvagt + SUBSTRING(hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE,8,16) 
                crcvhex = crcvhex + SUBSTRING(hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE,25)
                NO-ERROR.
            ipos1 = INDEX(crcvhex,"0D 0A 0D 0A").
            IF ipos1 > 0 THEN
                lendhdr = TRUE.
        END.
        IF hbuf:BUFFER-FIELD("subsys"):BUFFER-VALUE = "XMT-BKR" AND 
            hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE BEGINS "0000" THEN
            cbrk = cbrk + SUBSTRING(hbuf:BUFFER-FIELD("lmsg"):BUFFER-VALUE,8,16) NO-ERROR.

    END.

    DELETE OBJECT hqry.

    RUN getFileName IN hview (OUTPUT cOldLog).

    /* add this new tt to the list, and open a viewer for it */
    RUN addTT IN hparent (INPUT cFileName,"collmsgr",INPUT htt2,irows,"Collated Messenger Requests from " + cOldLog).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-util_SearchForCgiipMsgrFail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE util_SearchForCgiipMsgrFail Procedure 
PROCEDURE util_SearchForCgiipMsgrFail :
/*------------------------------------------------------------------------------
  Purpose:     Utility to search through the log messages looking for CGIIP 
               requests that failed to complete. This determination is based on 
               whether there is a message with comp="cgi"/lmsg begins "Start",
               with no following message comp="cgi"/lmsg begins "End".
  Parameters:  
      htt     - handle to table containing log messages
      hview   - handle to current Log Browse window 
      hparent - handle to the main LogRead window
  Notes:       This is a utility function for the LogRead Handler API
------------------------------------------------------------------------------*/
    DEF INPUT PARAM htt AS HANDLE NO-UNDO.
    DEF INPUT PARAM hview AS HANDLE NO-UNDO.
    DEF INPUT PARAM hparent AS HANDLE NO-UNDO.
    
    DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
    DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cqry AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cstr AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cstart AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cend AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE pid AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE tid AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cresult AS CHARACTER INIT "" NO-UNDO.
    
    CREATE QUERY hqry.
    hbuf = htt:DEFAULT-BUFFER-HANDLE.
    hqry:SET-BUFFERS(hbuf).
    cqry = "for each " + hbuf:NAME + " where " + 
           "comp = ~"cgi~" by tid by pid by lineno".
    hqry:QUERY-PREPARE(cqry).
    hqry:QUERY-OPEN.
    REPEAT:
      hqry:GET-NEXT().
      IF hqry:QUERY-OFF-END THEN LEAVE.
      
      IF hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE BEGINS "Start " THEN
      DO:
          ASSIGN pid = hbuf:BUFFER-FIELD("pid"):BUFFER-VALUE
              tid = hbuf:BUFFER-FIELD("tid"):BUFFER-VALUE.
          hqry:GET-NEXT().
      
          IF hqry:QUERY-OFF-END OR 
              (pid <> hbuf:buffer-field("pid"):BUFFER-VALUE OR 
              tid <> hbuf:buffer-field("tid"):BUFFER-VALUE OR 
              NOT (hbuf:BUFFER-FIELD("logmsg"):BUFFER-VALUE BEGINS "End")) THEN
          DO:
              hqry:GET-PREV().
              cstr = "".
              DO ictr = 1 TO hbuf:NUM-FIELDS:
                  
                  cstr = cstr + hbuf:BUFFER-FIELD(ictr):BUFFER-VALUE + " ".
              END.
              cresult = cresult + (IF cresult = "" THEN "" ELSE CHR(10)) + 
                  cstr.
              
          END.
      END.
    END.  /* REPEAT */
    DELETE OBJECT hqry.
    IF cresult <> "" THEN
        RUN logread/txtedwin.w PERSISTENT (cresult,?,?,"Possible incomplete CGIIP requests").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

