&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : logread/handlers/enhcli.i
    Purpose     : Provide functionality for investigating DYNOBJECTS
                  within 4GL client logs (GUI and char clients, 
                  WebSpeed agents, AppServer servers)

    Syntax      : {logread/handlers/enhcli.i}

    Description :

    Author(s)   : 
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE idynseq AS INTEGER    NO-UNDO.

/* temp table for counting creates and deletes */
DEF TEMP-TABLE ttdynobj NO-UNDO
    FIELD cobjtype AS CHAR
    FIELD icreates AS INT
    FIELD ideletes AS INT
    INDEX objix IS UNIQUE cobjtype
    .

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDynObjectLeak Include 
PROCEDURE findDynObjectLeak :
/*------------------------------------------------------------------------------
  Purpose:     Locates dynamic objects that have been created but not deleted
  Parameters:  
    hitt    - [in] handle to temp-table of dynamic object messages    
    cmsgs   - [out] text list of objects not deleted.
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM hitt AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM cmsgs AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.
  DEFINE VARIABLE clasthdl AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE chndl AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cobjtype AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cact AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hebuf AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rebuf AS ROWID      NO-UNDO.

  /* create a query to sort the messages by handle */
  hbuf = hitt:DEFAULT-BUFFER-HANDLE.
  CREATE BUFFER hebuf FOR TABLE hitt:DEFAULT-BUFFER-HANDLE. /* buffer for looking up errors */
  CREATE QUERY hqry.
  hqry:SET-BUFFERS(hbuf).
  hqry:QUERY-PREPARE("for each " + hitt:NAME + 
                     " where (act = ~"CREATED~") or (act = ~"DELETED~") " + 
                     " by tid by hndl by lineno").

  /* empty ttdynobj */
  EMPTY TEMP-TABLE ttdynobj.

  /* loop through the query. If there is no "DELETE", then there is 
   * a memory leak */
  hqry:QUERY-OPEN().
  REPEAT:
      hqry:GET-NEXT().
      IF (hqry:QUERY-OFF-END) THEN LEAVE.
      /* get the action */
      ASSIGN 
          hfld = hbuf:BUFFER-FIELD("act")
          cact = hfld:BUFFER-VALUE.
      ASSIGN 
          hfld = hbuf:BUFFER-FIELD("hndl")
          chndl = hfld:BUFFER-VALUE.
      ASSIGN 
          hfld = hbuf:BUFFER-FIELD("objtype")
          cobjtype = hfld:BUFFER-VALUE.
      /* update ttdynobj temp-table stats */
      FIND FIRST ttdynobj WHERE
          ttdynobj.cobjtype = cobjtype NO-ERROR.
      IF NOT AVAILABLE ttdynobj THEN
      DO:
          CREATE ttdynobj.
          ASSIGN ttdynobj.cobjtype = cobjtype.
      END.
      ASSIGN 
          ttdynobj.icreates = ttdynobj.icreates + 
            (IF cact = "CREATED" THEN 1 ELSE 0)
          ttdynobj.ideletes = ttdynobj.ideletes + 
            (IF cact = "DELETED" THEN 1 ELSE 0).

      /* if the current action is DELETED, and the clasthdl = chndl, 
       * then object has been deleted. */
      IF (cact = "DELETED" AND chndl = clasthdl) THEN
      DO:
          ASSIGN 
              clasthdl = ""
              rebuf = ?.
          NEXT.
      END.
      /* if the current action is CREATED and the clasthdl is "", 
       * this is a new object */
      IF (cact = "CREATED" AND clasthdl = "") THEN
      DO:
          ASSIGN 
              clasthdl = chndl
              rebuf = hbuf:ROWID.
          NEXT.
      END.
      /* at this point, something is wrong:
       * we either have a handle that was not CREATED (not a problem?), 
       * or we have a handle this was not DELETED (big problem). */
          /* find the buffer of the previous CREATE command, rebuf */
      IF cact = "CREATED" THEN
          hebuf:FIND-BY-ROWID(rebuf).
      ELSE
          hebuf:FIND-BY-ROWID(hbuf:ROWID).

          IF (hebuf:AVAILABLE) THEN
          DO:
              /* add this to the list of messages */
              ASSIGN 
                  hfld = hebuf:BUFFER-FIELD("lineno")
                  cmsgs = cmsgs + "[Line#:" + STRING(hfld:BUFFER-VALUE) + "] ".
              ASSIGN 
                  hfld = hebuf:BUFFER-FIELD("objtype")
                  cmsgs = cmsgs + hfld:BUFFER-VALUE.
              ASSIGN 
                  hfld = hebuf:BUFFER-FIELD("hndl")
                  cmsgs = cmsgs + " (handle: " + hfld:BUFFER-VALUE + ") ".
              ASSIGN 
                  hfld = hebuf:BUFFER-FIELD("hndl")
                  cmsgs = cmsgs + "created in ".
              ASSIGN 
                  hfld = hebuf:BUFFER-FIELD("procname")
                  cmsgs = cmsgs + hfld:BUFFER-VALUE + " Line: ".
              ASSIGN 
                  hfld = hebuf:BUFFER-FIELD("procline")
                  cmsgs = cmsgs + STRING(hfld:BUFFER-VALUE).
              ASSIGN 
                  cmsgs = cmsgs + 
                      (IF cact = "CREATED" THEN " not deleted"
                          ELSE " deleted without create") + CHR(10).
              ASSIGN 
                  clasthdl = (IF cact = "DELETED" THEN "" ELSE chndl)
                  rebuf = (IF cact = "DELETED" THEN ? ELSE hbuf:ROWID).
          END.  /* hebuf:available */
  END.
  hqry:QUERY-CLOSE().
  DELETE OBJECT hqry.
  DELETE OBJECT hebuf.

  IF cmsgs = "" THEN
      cmsgs = "No undeleted DynObjects identified" + CHR(10).

  cmsgs = cmsgs + CHR(10) + "SUMMARY DYNOBJECT STATISTICS" + CHR(10).

  /* summary of object creates and deletes */
  FOR EACH ttdynobj:
      cmsgs = cmsgs + 
          ttdynobj.cobjtype + 
          " - Creates: " + STRING(ttdynobj.icreates) + 
          " Deletes: " + STRING(ttdynobj.ideletes) + CHR(10).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDynObjectTT Include 
PROCEDURE GetDynObjectTT PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Returns a TT of the dynamic object logging in this log.
               This is so we can break this message down further than 
               just the normal enhanced logging
  Parameters:  
    hitt   - [IN] handle to temp table to parse
    hott   - [OUT] handle to newly created temp-table
    iorows - [OUT] number of rows in the new temp-table
  Notes:       creates the temp table for use either in a separate
               Log Browse window, or for further analysis of the DynObjects.
               It is the caller's reponsibility to free this temp-table.
------------------------------------------------------------------------------*/

  DEF INPUT PARAM hitt AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM hott AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM iorows AS INT NO-UNDO.

  DEFINE VARIABLE hibuf AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hobuf AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cmsgtxt AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cact AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cobjtype AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE chndl AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cprocname AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iprocline AS INTEGER NO-UNDO.
  DEFINE VARIABLE cobjinfo AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ipos AS INTEGER    NO-UNDO.

  /* create the new temp-table */
  hibuf = hitt:DEFAULT-BUFFER-HANDLE.
  CREATE TEMP-TABLE hott IN WIDGET-POOL "logpool".
  hott:CREATE-LIKE(hibuf).
  hott:ADD-NEW-FIELD("act","char").
  hott:ADD-NEW-FIELD("objtype","char").
  hott:ADD-NEW-FIELD("hndl","char").
  hott:ADD-NEW-FIELD("procname","char").
  hott:ADD-NEW-FIELD("procline","int").
  hott:ADD-NEW-FIELD("objinfo","char").
  hott:TEMP-TABLE-PREPARE("dynobj").
  hobuf = hott:DEFAULT-BUFFER-HANDLE.

  /* create the query on all the DYNOBJECTS messages */
  CREATE QUERY hqry.
  hqry:SET-BUFFERS(hibuf).
  hqry:QUERY-PREPARE("for each " + hibuf:NAME + 
                     " where subsys = ~"DYNOBJECTS~" " + 
                     "by lineno").
  hqry:QUERY-OPEN().
  iorows = 0.
  REPEAT:
      hqry:GET-NEXT().
      IF (hqry:QUERY-OFF-END) THEN LEAVE.

      /* parse the logmsg */
      ASSIGN
      hfld = hibuf:BUFFER-FIELD("logmsg")
      cmsgtxt = hfld:BUFFER-VALUE.

      /* action */
      cact = TRIM(SUBSTRING(cmsgtxt,1,14)).

      /* objtype */
      cobjtype = TRIM(SUBSTRING(cmsgtxt,16,17)).

      /* handle */
      ipos = INDEX(cmsgtxt,"Handle:").
      IF ipos > 0 THEN
          ASSIGN 
          chndl = SUBSTRING(cmsgtxt,ipos + 7)
          chndl = ENTRY(1,chndl," ").

      /* procedure name and line number */
      ipos = INDEX(cmsgtxt,"(").
      IF ipos > 0 THEN
      DO:
          ASSIGN 
          cprocname = SUBSTRING(cmsgtxt,ipos + 1)
          ipos = INDEX(cprocname,")")
          cprocname = SUBSTRING(cprocname,1,ipos - 1) NO-ERROR.
          ASSIGN 
              ipos = INDEX(cprocname,"Line ")
              iprocline = INT(SUBSTRING(cprocname,ipos + 5))
              cprocname = TRIM(SUBSTRING(cprocname,1,ipos - 1)) NO-ERROR.
      END.
      ELSE
          ASSIGN 
              cprocname = ""
              iprocline = 0.

      /* treat the rest of the message as garbage text */
      ipos = INDEX(cmsgtxt,")").
      IF ipos > 0 THEN
          cobjinfo = TRIM(SUBSTRING(cmsgtxt,ipos + 2)).
      ELSE
          cobjinfo = "".

      /* create the new buffer */
      hobuf:BUFFER-CREATE.
      /* copy field from old buffer */
      hobuf:BUFFER-COPY(hibuf).
      /* set new field values */
      ASSIGN 
          iorows = iorows + 1
          hfld = hobuf:BUFFER-FIELD("act")
          hfld:BUFFER-VALUE = cact
          hfld:FORMAT = "x(15)".
      ASSIGN 
          hfld = hobuf:BUFFER-FIELD("objtype")
          hfld:BUFFER-VALUE = cobjtype
          hfld:FORMAT = "x(17)".
      ASSIGN 
          hfld = hobuf:BUFFER-FIELD("hndl")
          hfld:BUFFER-VALUE = chndl
          hfld:FORMAT = "x(10)".
      ASSIGN 
          hfld = hobuf:BUFFER-FIELD("procname")
          hfld:BUFFER-VALUE = cprocname
          hfld:FORMAT = "x(255)".
      ASSIGN 
          hfld = hobuf:BUFFER-FIELD("procline")
          hfld:BUFFER-VALUE = iprocline
          hfld:FORMAT = "zzzzzz9".
      ASSIGN 
          hfld = hobuf:BUFFER-FIELD("objinfo")
          hfld:BUFFER-VALUE = cobjinfo
          hfld:FORMAT = "x(255)".
      hobuf:BUFFER-RELEASE().

  END.

  hqry:QUERY-CLOSE().
  DELETE OBJECT hqry.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE util_FindDynObjectLeak Include 
PROCEDURE util_FindDynObjectLeak :
/*------------------------------------------------------------------------------
  Purpose:     Locates a dynamic object leaks, objects created but not deleted.
  Parameters:  
      htt     - handle to table containing log messages
      hview   - handle to current Log Browse window 
      hparent - handle to the main LogRead window
  Notes:       This is a utility function for the LogRead Handler API
------------------------------------------------------------------------------*/
    DEF INPUT PARAM htt AS HANDLE NO-UNDO.
    DEF INPUT PARAM hview AS HANDLE NO-UNDO.
    DEF INPUT PARAM hparent AS HANDLE NO-UNDO.

    DEFINE VARIABLE hdtt AS HANDLE     NO-UNDO.
    DEFINE VARIABLE idrows AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cmsgs AS CHARACTER  NO-UNDO.

    /* first, create a new temp-table of the dynamic object messages */
    RUN GetDynObjectTT(INPUT htt, OUTPUT hdtt, OUTPUT idrows) NO-ERROR.

    IF (VALID-HANDLE(hdtt)) THEN
    DO:
        RUN findDynObjectLeak(INPUT hdtt, OUTPUT cmsgs) NO-ERROR.
        IF cmsgs = "" THEN
            cmsgs = "No dynamic object leaks found".
        RUN logread/txtedwin.w PERSISTENT (cmsgs,?,?,"Dynamic Object Leaks").
        /* delete our temp-table */
        DELETE OBJECT hdtt.
    END.
    ELSE
        MESSAGE "Unable to extract DYNOBJECTS info from log"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE util_ShowDynObjects Include 
PROCEDURE util_ShowDynObjects :
/*------------------------------------------------------------------------------
  Purpose:     Utility to identify all DYNOBJECT messages in a client log,
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

    DEFINE VARIABLE hott AS HANDLE     NO-UNDO.
    DEFINE VARIABLE iorows AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.

    /* get the temp table */
    RUN getDynObjectTT(INPUT htt, OUTPUT hott, OUTPUT iorows).

    /* add a pseudo-type handler */
    RUN addPseudoType IN hparent ("dynobj",  /* logtype */
                                  "DynObjects",  /* log type description */
                                  "rawtime,level,comp,subsys,logmsg", /* hidden fields */
                                  "logdate,rawtime,logmsg,logtime",   /* merge fields */
                                  "logtime").    /* non-merge fields */
    RUN addPseudoTypeQuery IN hparent ("dynobj","CreateAndDelete","(act = ~"CREATED~") or (act = ~"DELETED~") by tid by hndl by lineno").

    /* get the current buffer from hview */
    RUN getFileName IN hview(OUTPUT cFileName).
    
    idynseq = idynseq + 1.

    /* add the temp table */
    RUN addTT IN hparent("DYNOBJ" + STRING(idynseq,"99"),"dynobj",INPUT /* TABLE-HANDLE */ hott,iorows,"DynObjects from " + cFileName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

