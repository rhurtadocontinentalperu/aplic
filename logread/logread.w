&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: logread/logread.w

  Description: Main program for the LogRead utility

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

CREATE WIDGET-POOL "logpool".

/* ***************************  Definitions  ************************** */

/* internal temp-tables */
DEF TEMP-TABLE ttinternal NO-UNDO
    RCODE-INFORMATION
    FIELD htt AS HANDLE
    FIELD ttname AS CHAR FORMAT "x(20)"
    FIELD lexposed AS LOG.

/* Log browser window table */
{logread/logview.i}

/* loaded log files table */
{logread/logfile.i}

/* log types/handlers table */
{logread/logtype.i "NEW" }

/* psuedo-type queries table */
DEF TEMP-TABLE ttpqry NO-UNDO
    FIELD logtype AS CHAR 
    FIELD qryid AS CHAR
    FIELD qrytxt AS CHAR.

/* logtype instance attributes */
DEF TEMP-TABLE tthdlrattr NO-UNDO
    FIELD hhdlr AS HANDLE
    FIELD logtype AS CHAR
    FIELD attrname AS CHAR
    FIELD attrval AS CHAR.

/* merged log files table */
{logread/logmrg.i}

/* date handling */
{logread/logdate.i}

/* promsgs handling */
{logread/logmsgs.i}

/* Global Variables */
{logread/logglob.i "NEW" }

/* codepage conversions */
{logread/logcp.i}

/* help */
{logread/loghelp.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hlogqry AS HANDLE     NO-UNDO.
DEFINE VARIABLE hlogbr AS HANDLE     NO-UNDO.
DEFINE VARIABLE hrdrqry AS HANDLE     NO-UNDO.
DEFINE VARIABLE hrdrbr AS HANDLE     NO-UNDO.
DEFINE VARIABLE hanlqry AS HANDLE     NO-UNDO.
DEFINE VARIABLE hanlbr AS HANDLE     NO-UNDO.
DEFINE VARIABLE hstatwin AS HANDLE     NO-UNDO.
DEFINE VARIABLE hstattxt AS HANDLE     NO-UNDO.
DEFINE VARIABLE hstatfrm AS HANDLE     NO-UNDO.
DEFINE VARIABLE lStatusSeen AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ilogseq AS INTEGER    INIT 1 NO-UNDO.
DEFINE VARIABLE imrgseq AS INTEGER    INIT 1 NO-UNDO.
DEFINE VARIABLE ifiltseq AS INTEGER    INIT 1 NO-UNDO.
DEFINE VARIABLE cVersion AS CHARACTER  INIT "1.1" NO-UNDO.
DEFINE VARIABLE cLogRead AS CHARACTER  INIT "LogRead" NO-UNDO.
DEFINE VARIABLE cCopyright AS CHARACTER  INIT "" NO-UNDO.  /* Copyright information removed for PSDN */
DEFINE VARIABLE hhdlrmenu AS HANDLE     NO-UNDO.
DEFINE VARIABLE hwinmenu AS HANDLE     NO-UNDO.
DEFINE VARIABLE hmainmenu AS HANDLE     NO-UNDO.
DEFINE VARIABLE hmrgmenu AS HANDLE     NO-UNDO.
DEFINE VARIABLE hclosemenu AS HANDLE     NO-UNDO.
DEFINE VARIABLE hpropmenu AS HANDLE     NO-UNDO.
DEFINE VARIABLE cSrcMsgs AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTrgMsgs AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCodepage AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSrcLang AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hprogwin AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bMerge 
     IMAGE-UP FILE "logread/image/merge.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Merge logs".

DEFINE BUTTON bOpen 
     IMAGE-UP FILE "logread/image/open.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Open Log".

DEFINE BUTTON bProp 
     IMAGE-UP FILE "logread/image/props.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Properties".

DEFINE BUTTON bRun 
     IMAGE-UP FILE "logread/image/run.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Run Utility".

DEFINE RECTANGLE rToolbar
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81.8 BY 1.43.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     "Logs Loaded:" VIEW-AS TEXT
          SIZE 22 BY .62 AT ROW 1.24 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.57
         SIZE 81.8 BY 10.33.

DEFINE FRAME fToolbar
     bMerge AT ROW 1.14 COL 11.6
     bRun AT ROW 1.14 COL 16.6
     bOpen AT ROW 1.14 COL 1.6
     bProp AT ROW 1.14 COL 6.6
     rToolbar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.8 BY 1.57.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "LogRead"
         HEIGHT             = 11.86
         WIDTH              = 81.8
         MAX-HEIGHT         = 45.62
         MAX-WIDTH          = 256
         VIRTUAL-HEIGHT     = 45.62
         VIRTUAL-WIDTH      = 256
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* SETTINGS FOR FRAME fToolbar
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* LogRead */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* LogRead */
DO:
  /* This event will close the window and terminate the procedure.  */
        APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fToolbar
&Scoped-define SELF-NAME bMerge
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bMerge C-Win
ON CHOOSE OF bMerge IN FRAME fToolbar
DO:
  RUN beginMerge.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bOpen C-Win
ON CHOOSE OF bOpen IN FRAME fToolbar
DO:
  RUN OpenLog.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bProp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bProp C-Win
ON CHOOSE OF bProp IN FRAME fToolbar
DO:
  RUN showBrowseLogProperties.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bRun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bRun C-Win
ON CHOOSE OF bRun IN FRAME fToolbar
DO:
  RUN runUtility.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* set the global handle */
ghlogutils = THIS-PROCEDURE.

RUN loadInternalTTs.
RUN initialiseMenu.
RUN initialiseHandlers.
RUN initialiseDateFormats.
RUN createBrowsers.

RUN enable_UI.
RUN enableToolbar.


/* set the status bar to something... anything */
STATUS DEFAULT " ".
STATUS INPUT " ".

WAIT-FOR CLOSE OF THIS-PROCEDURE.

RUN closeProcedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aboutMessage C-Win 
PROCEDURE aboutMessage :
/*------------------------------------------------------------------------------
  Purpose:     Displays the About dialog, from the Help->About menu
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  MESSAGE cLogRead "Version" cVersion skip(1)
      cCopyright
      VIEW-AS ALERT-BOX INFORMATION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addInternalTT C-Win 
PROCEDURE addInternalTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM htt AS HANDLE NO-UNDO.
  DEF INPUT PARAM cname AS CHAR NO-UNDO.

  FIND FIRST ttinternal NO-LOCK WHERE
      ttinternal.ttname = cname NO-ERROR.
  IF NOT AVAILABLE ttinternal THEN
  DO:
      CREATE ttinternal.
      ASSIGN
          ttinternal.ttname = cname
          ttinternal.htt = htt
          ttinternal.lexposed = FALSE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addPseudoType C-Win 
PROCEDURE addPseudoType :
/*------------------------------------------------------------------------------
  Purpose:     Adds a pseudo-type handler to the list of handlers
  Parameters:  
    clogtype   - [IN] name of logtype
    ctypename  - [IN] description of logtype
    chidcols   - [IN] CSV list of hidden columns
    cmrgflds   - [IN] CSV list of merge fields
    cnomrgflds - [IN] CSV list of fields that are not included in a merge
  Notes:       A pseudo-type allows a handler or utility program to define 
               a handler on the fly, without having to write a handler 
               program. The main use of this is just so that the Log Browse
               Window (which requires a handler) can be used to view a 
               temp-table in a browse, such as the output from a 
               utility procedure. 
               The MERGE log type is actually implemented this way.
------------------------------------------------------------------------------*/
   DEF INPUT PARAM clogtype AS CHAR NO-UNDO.
   DEF INPUT PARAM ctypename AS CHAR NO-UNDO.
   DEF INPUT PARAM chidcols AS CHAR NO-UNDO.
   DEF INPUT PARAM cmrgflds AS CHAR NO-UNDO.
   DEF INPUT PARAM cnomrgflds AS CHAR NO-UNDO.

   DEFINE VARIABLE idx AS INTEGER    NO-UNDO.
   DEFINE VARIABLE hmenuitem AS HANDLE     NO-UNDO.

   /* fail if this logtype is already taken */
   FIND FIRST ttlogtype NO-LOCK WHERE
       ttlogtype.logtype = clogtype NO-ERROR.
   IF AVAILABLE ttlogtype THEN RETURN.
   FIND LAST ttlogtype NO-ERROR.
   IF NOT AVAILABLE ttlogtype THEN 
       idx = 0.
   ELSE
       idx = ttlogtype.loadix + 1.

   CREATE ttlogtype.
   ASSIGN 
       ttlogtype.loadix = idx
       ttlogtype.hdlrprog = "PSEUDO"
       ttlogtype.logtype = clogtype
       ttlogtype.typename = ctypename
       ttlogtype.hproc = ?
       ttlogtype.utilfunc = ""
       ttlogtype.utilqry = ""
       ttlogtype.chidcols = chidcols
       ttlogtype.cmrgflds = cmrgflds
       ttlogtype.cnomrgflds = cnomrgflds
       .

   /* add a menu option to the handler menu */
   CREATE MENU-ITEM hmenuitem
       ASSIGN 
       PARENT = hhdlrmenu
       LABEL = clogtype
       TRIGGERS:
         ON CHOOSE
             PERSISTENT RUN showHandlerInfo(INPUT clogtype).
       END TRIGGERS.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addPseudoTypeQuery C-Win 
PROCEDURE addPseudoTypeQuery :
/*------------------------------------------------------------------------------
  Purpose:     Adds a standard query for a pseudo-type.
  Parameters:  
    clogtype - [IN] log type to add the query to 
    cqryid   - [IN] id of the query to add
    cqrytxt  - [IN] 4GL query text of the query to add
  Notes:       This provides a way to add a query to the list of queries 
               for a pseudo-type, displayed under the Queries menu in the
               Log Browse Window.
------------------------------------------------------------------------------*/
   DEF INPUT PARAM clogtype AS CHAR NO-UNDO.
   DEF INPUT PARAM cqryid AS CHAR NO-UNDO.
   DEF INPUT PARAM cqrytxt AS CHAR NO-UNDO.

   /* make sure the logtype is available and a pseudo logtype */
   FIND FIRST ttlogtype EXCLUSIVE-LOCK WHERE
       ttlogtype.logtype = clogtype AND
       ttlogtype.hdlrprog = "PSEUDO" NO-ERROR.
   IF NOT AVAILABLE ttlogtype THEN RETURN.
   /* make sure this qryid does not for this logtype */
   FIND FIRST ttpqry NO-LOCK WHERE
       ttpqry.logtype = ttlogtype.logtype AND
       ttpqry.qryid = cqryid NO-ERROR.
   IF AVAILABLE ttpqry THEN RETURN.
   CREATE ttpqry.
   ASSIGN 
       ttpqry.logtype = clogtype
       ttpqry.qryid = cqryid
       ttpqry.qrytxt = cqrytxt.
   /* add to ttlogtype.utilqry */
   ASSIGN 
       ttlogtype.utilqry = ttlogtype.utilqry + 
           (IF ttlogtype.utilqry <> "" AND ttlogtype.utilqry <> ? THEN
               "," ELSE "") + cqryid.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addTT C-Win 
PROCEDURE addTT :
/*------------------------------------------------------------------------------
  Purpose:     Adds a new log file temp-table into LogRead
  Parameters:  
    cFileName - [IN] name of the log file contained in this temp-table
    cLogType  - [IN] log type of this log file
    htt       - [IN] handle to the temp-table
    irows     - [IN] number of rows in the temp-table
    cdesc     - [IN] description of the log file (not really used)
    
  Notes:       This automatically opens a new Log Browse Window for the log file
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cFileName AS CHAR NO-UNDO.
  DEF INPUT PARAM cLogType AS CHAR NO-UNDO.
  DEF INPUT PARAM /* TABLE-HANDLE */ htt AS HANDLE.
  DEF INPUT PARAM irows AS INT NO-UNDO.
  DEF INPUT PARAM cdesc AS CHAR NO-UNDO.

  FIND FIRST ttlogtype NO-LOCK
      WHERE ttlogtype.logtype = cLogType NO-ERROR.
  IF NOT AVAILABLE ttlogtype THEN
  DO:
      /* we need a default reader */
      FIND FIRST ttlogtype NO-LOCK WHERE
          ttlogtype.logtype = "Unknown" NO-ERROR.
      IF NOT AVAILABLE ttlogtype THEN
          RETURN.
  END.
  CREATE ttlog.
  ASSIGN 
    ttlog.logid = ilogseq
    ttlog.logfile = cFileName
    ttlog.logtype = ttlogtype.logtype /* cLogType */
    ttlog.htt = htt
    ttlog.irows = irows
    ttlog.cdesc = cdesc
    ilogseq = ilogseq + 1
    .
  /* now open a new viewer for it */
  RUN openViewer(cFileName,"true",?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjustLogTimes C-Win 
PROCEDURE adjustLogTimes :
/*------------------------------------------------------------------------------
  Purpose:     Adjusts the timestamps in a log file by the given amount
  Parameters:  
    htt       - [IN] temp-table containing log file data
    ilogorder - [IN] if the log is a merge log, indicate which file in the 
                merge is being adjusted. ? for non-merge files
    cmrgflds  - [IN] the CSV list of merge fields of this log type. 
                This is so we can identify which fields contains the 
                date and time. According to the LogRead Handler API, the 
                merge fields returned here MUST be:
                  datefieldname,rawtimefieldname,msgfieldname,texttimefieldname
    dtimeadj  - [IN] number of seconds to adjust the time by
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM htt AS HANDLE NO-UNDO.
  DEF INPUT PARAM ilogorder AS INT NO-UNDO.
  DEF INPUT PARAM cmrgflds AS CHAR NO-UNDO.
  DEF INPUT PARAM dtimeadj AS DEC NO-UNDO.

  DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
  DEFINE VARIABLE htimefld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hdatefld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hlogtimefld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ctimefld AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cdatefld AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE clogtimefld AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dtime AS DEC    NO-UNDO.
  DEFINE VARIABLE ddate AS DATE       NO-UNDO.
  DEFINE VARIABLE ctime AS CHARACTER  NO-UNDO.

  
  hbuf = htt:DEFAULT-BUFFER-HANDLE.

  /* get the time and date field names */
  ASSIGN 
      ctimefld = ENTRY(2,cmrgflds)
      cdatefld = ENTRY(1,cmrgflds)
      clogtimefld = ENTRY(4,cmrgflds).
  htimefld = hbuf:BUFFER-FIELD(ctimefld).
  hdatefld = hbuf:BUFFER-FIELD(cdatefld).
  hlogtimefld = hbuf:BUFFER-FIELD(clogtimefld).

  /* simple query to run through all rows of temp table */
  CREATE QUERY hqry.
  hqry:SET-BUFFERS(hbuf).
  IF ilogorder = ? THEN
  DO:
      /* adjust all times in current log */
      hqry:QUERY-PREPARE("for each " + hbuf:NAME + " exclusive-lock" ).
  END.
  ELSE
  DO:
      /* assume this is a merge log, and we only want to adjust file ilogorder */
      hqry:QUERY-PREPARE("for each " + hbuf:NAME + " exclusive-lock " + 
                         "where logid = " + STRING(ilogorder) ).
  END.
  hqry:QUERY-OPEN().

  REPEAT TRANSACTION:
      hqry:GET-NEXT().
      IF hqry:QUERY-OFF-END THEN LEAVE.
      ASSIGN 
          htimefld = hbuf:BUFFER-FIELD(ctimefld)
          hdatefld = hbuf:BUFFER-FIELD(cdatefld)
          hlogtimefld = hbuf:BUFFER-FIELD(clogtimefld)

      /* get the time and date */
      dtime = htimefld:BUFFER-VALUE.
      ddate = hdatefld:BUFFER-VALUE.

      dtime = dtime + dtimeadj.
      /* if we wrapped the time, adjust the date */
      IF (dtime < 0) THEN
      DO WHILE (dtime < 0):
          /* went backwards */
          ASSIGN 
              ddate = ddate - 1
              dtime = dtime + 86400.
      END.
      ELSE IF (dtime >= 86400) THEN
      DO WHILE (dtime >= 86400):
          /* went forwards */
          ASSIGN 
              ddate = ddate + 1
              dtime = dtime - 86400.
      END.
      /* write back to the temp table */
      htimefld:BUFFER-VALUE = dtime.
      hdatefld:BUFFER-VALUE = ddate.
      RUN getTimeString(dtime,INPUT true, OUTPUT ctime).
      hlogtimefld:BUFFER-VALUE = ctime.
  END.
  hqry:QUERY-CLOSE().
  DELETE OBJECT hqry.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beginMerge C-Win 
PROCEDURE beginMerge :
/*------------------------------------------------------------------------------
  Purpose:     Performs a merge of multiple log filed
  Parameters:  <none>
  Notes:       The files currently selected in the Main Window's browse are
               the files that are merged.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE imrgid AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ifld AS INTEGER    NO-UNDO.
  DEFINE VARIABLE htt AS HANDLE     NO-UNDO.
  DEFINE VARIABLE htt2 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hbuf2 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE icolid AS INTEGER    INIT 3 NO-UNDO.
  DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cmrgname AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cpairs AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dtime AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE ddate AS DATE    NO-UNDO.
  DEFINE VARIABLE ctime AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE clinefmt AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ilinediv AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE itmp AS INTEGER    NO-UNDO.
  DEFINE VARIABLE irows AS INTEGER INIT 0   NO-UNDO.
  DEFINE VARIABLE dtimeadj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE imrgctr AS INTEGER INIT 1 NO-UNDO.
  DEFINE VARIABLE lfrommrg AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttmrg FOR ttmrg.

  /* if there are < 2 logs selected, no need to merge */
  IF hlogbr:NUM-SELECTED-ROWS < 2 THEN RETURN.

   /* get the merge name first 
    * - use the global sequence, not the logid sequence */
   cmrgname = "MERG" + STRING(giseq,"9999").

   /* validate that the name is unique */
   DO WHILE TRUE:
       RUN logread/newlog.w (INPUT-OUTPUT cmrgname,"New Merge Log",OUTPUT lOK).
       IF (NOT lOK) THEN
           RETURN.
       FIND FIRST ttlog NO-LOCK WHERE
           ttlog.logfile = cmrgname NO-ERROR.
       IF AVAILABLE ttlog THEN
          MESSAGE "Log named" cmrgname "already exists!" SKIP
              "Please choose a different name"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
       ELSE LEAVE.
   END.

   /* get a new mrgid */
   ASSIGN
       imrgid = ilogseq
       ilogseq = ilogseq + 1
       giseq = giseq + 1.

   /* create a ttlog for the merge */
   CREATE ttlog.
   ASSIGN 
       ttlog.logid = imrgid
       ttlog.logfile = cmrgname
       ttlog.logtype = "MERGE"
       ttlog.cdesc = ttlog.logfile
       .
   RELEASE ttlog.

   /* for each logfile selected in the browse, create a ttmrg */
   DO ictr = 1 TO hlogbr:NUM-SELECTED-ROWS:
       IF hlogbr:FETCH-SELECTED-ROW(ictr) THEN
       DO:
           IF ttlog.logtype = "MERGE" THEN
           DO:
               /* copy each bttmrg from the old merge to the new merge */
               FOR EACH bttmrg WHERE
                   bttmrg.mrgid = ttlog.logid:
                   CREATE ttmrg.
                   BUFFER-COPY bttmrg EXCEPT mrgid logorder TO ttmrg .
                   ASSIGN
                       ttmrg.mrgid = imrgid
                       ttmrg.logorder = imrgctr
                       imrgctr = imrgctr + 1
                       ttmrg.ccommon = ""
                       ttmrg.cprivate = ""
                       ttmrg.mrgfrom = ttlog.logid /* merged from this merge */
                       ttmrg.mrgfromord = bttmrg.logorder /* log order in this merge */
                       .
               END.  /* for each bttmrg */
           END. /* if ttlog.logtype = "MERGE" */
           ELSE
           DO:
               /* create new ttmrg in the new merge for this log */
               CREATE ttmrg.
               ASSIGN 
                   ttmrg.mrgid = imrgid
                   ttmrg.logorder = imrgctr
                   imrgctr = imrgctr + 1
                   ttmrg.mrgfrom = 0
                   ttmrg.mrgfromord = 0
                   ttmrg.ccommon = ""
                   ttmrg.cprivate = ""
                   .
               BUFFER-COPY ttlog TO ttmrg.
               FIND FIRST ttlogtype NO-LOCK WHERE
                   ttlogtype.logtype = ttlog.logtype NO-ERROR.
               IF AVAILABLE ttlogtype THEN
               DO:
                   ASSIGN
                       ttmrg.cmrgflds = ttlogtype.cmrgflds
                       ttmrg.cnomrgflds = ttlogtype.cnomrgflds.
               END.
           END.  /* if ttlg.logtype <> "MERGE" */
       END.  /* if hlogbr:FETCH-SELECTED-ROW(ictr) */
   END.  /* do ictr = 1 to num-selected rows */

   /* at this point, call the merge files dialog. */
   /* empty the ttmrg2 temp table */
   EMPTY TEMP-TABLE ttmrg2 NO-ERROR.
   /* copy the ttmrg to ttmrg2 */
   FOR EACH ttmrg NO-LOCK WHERE
       ttmrg.mrgid = imrgid BY ttmrg.logorder:
       CREATE ttmrg2.
       BUFFER-COPY ttmrg TO ttmrg2.
   END.
   /* run merge files dialog */
   RUN logread/mrgfiles.w(INPUT cmrgname,true,INPUT-OUTPUT TABLE ttmrg2,OUTPUT lOK).

   /* if user cancelled the merge */
   IF NOT lOK THEN
   DO:
       /* delete all ttmrg records for this merge */
       FOR EACH ttmrg EXCLUSIVE-LOCK WHERE
           ttmrg.mrgid = imrgid:
           DELETE ttmrg.
       END.
       /* empty ttmrg2 */
       EMPTY TEMP-TABLE ttmrg2.
       /* remove the ttlog */
       FIND FIRST ttlog EXCLUSIVE-LOCK WHERE
           ttlog.logid = imrgid NO-ERROR.
       IF AVAILABLE ttlog THEN DELETE ttlog.
       RETURN.
   END.  /* if not lOK */
   
   /* user pressed OK, complete the merge */

   /**** CREATE MERGE COLUMNS ****/

   /* add 5 merge columns initially: file-line, date, raw time and display time, message */
   CREATE ttmrgcol.
   ASSIGN 
       ttmrgcol.mrgid = imrgid
       ttmrgcol.colname = "file-line"
       ttmrgcol.colid = 1
       ttmrgcol.coltype = "char"
       ttmrgcol.colformat = "x(12)"
       .
   CREATE ttmrgcol.
   ASSIGN 
       ttmrgcol.mrgid = imrgid
       ttmrgcol.colname = "logdate"
       ttmrgcol.colid = 2
       ttmrgcol.coltype = "date"
       ttmrgcol.colformat = "99/99/9999"
       .
   CREATE ttmrgcol.
   ASSIGN 
       ttmrgcol.mrgid = imrgid
       ttmrgcol.colname = "rawlogtime"
       ttmrgcol.colid = 3
       ttmrgcol.coltype = "dec"
       ttmrgcol.colformat = ">>>>9.999999"
       .
   CREATE ttmrgcol.
   ASSIGN 
       ttmrgcol.mrgid = imrgid
       ttmrgcol.colname = "logtime"
       ttmrgcol.colid = 4
       ttmrgcol.coltype = "char"
       ttmrgcol.colformat = "X(12)"
       .   
   CREATE ttmrgcol.
   ASSIGN 
       ttmrgcol.mrgid = imrgid
       ttmrgcol.colname = "logmsg"
       ttmrgcol.colid = 5
       ttmrgcol.coltype = "char"
       ttmrgcol.colformat = "x(255)"
       .
   CREATE ttmrgcol.
   ASSIGN 
       ttmrgcol.mrgid = imrgid
       ttmrgcol.colname = "logid"
       ttmrgcol.colid = 6
       ttmrgcol.coltype = "int"
       ttmrgcol.colformat = "zzzz9"
       .

   icolid = 7.

   /* add merge columns from logs */
   FOR EACH ttmrg NO-LOCK WHERE
       ttmrg.mrgid = imrgid
       BY mrgid BY logorder:

       FIND FIRST ttlog NO-LOCK WHERE
           ttlog.logid = ttmrg.logid NO-ERROR.
       IF NOT AVAILABLE ttlog THEN 
       DO:
           /* we should get into here only if the user is merging an existing merge, 
            * and has unloaded a log that participated in the merge.
            * Use the schema handle from the log type, if it is available.
            */
           FIND FIRST ttlogtype NO-LOCK WHERE
               ttlogtype.logtype = ttmrg.logtype NO-ERROR.
           /* if can't get log type, skip this log */
           IF NOT AVAILABLE ttlogtype THEN NEXT.
           /* if the schema handle is not valid, skip this log */
           IF NOT VALID-HANDLE(ttlogtype.hschema) THEN NEXT.
           htt = ttlogtype.hschema.
       END.
       ELSE
           ASSIGN htt = ttlog.htt.
       hbuf = htt:DEFAULT-BUFFER-HANDLE.
       /* for each field in the buffer, add a ttmrgcol record */
       DO ifld = 1 TO hbuf:NUM-FIELDS:
           hfld = hbuf:BUFFER-FIELD(ifld).
           /* if this is in the list of fields not to merge, skip it */
           IF LOOKUP(hfld:NAME,ttmrg.cnomrgflds) > 0 THEN NEXT.
           /* if this is the date, time or message, we already have it */
           IF LOOKUP(hfld:NAME,ttmrg.cmrgflds) > 0 THEN NEXT.
           /* see if we already have this field */
           FIND FIRST ttmrgcol EXCLUSIVE-LOCK WHERE
               ttmrgcol.mrgid = imrgid AND 
               ttmrgcol.colname = hfld:NAME NO-ERROR.
           IF NOT AVAILABLE ttmrgcol THEN
           DO:
               /* we don't have a field of this name, so add it */
               CREATE ttmrgcol.
               ASSIGN 
                   ttmrgcol.mrgid = imrgid
                   ttmrgcol.colname = hfld:NAME
                   ttmrgcol.colid = icolid
                   icolid = icolid + 1
                   ttmrgcol.coltype = hfld:DATA-TYPE
                   ttmrgcol.colformat = hfld:FORMAT
                   .
           END.
           ttmrgcol.collogids = 
               (IF ttmrgcol.collogids = "" THEN "" ELSE ",") + 
               string(ttmrg.logid).
       END.  /* do ifld = 1 to hbuf:num-fields */
   END.  /* for each ttmrg */

   /* ttmrgcol now has a list of cols. need to identify which ones are common */
   FOR EACH ttmrgcol NO-LOCK WHERE
       ttmrgcol.mrgid = imrgid:
       IF NUM-ENTRIES(ttmrgcol.collogids) > 1 THEN
       DO ictr = 1 TO NUM-ENTRIES(ttmrgcol.collogids,","):
           FIND FIRST ttmrg WHERE
               ttmrg.mrgid = imrgid AND
               ttmrg.logid = INT(ENTRY(ictr,ttmrgcol.collogids,","))
               NO-ERROR.
           IF AVAILABLE ttmrg THEN
               ttmrg.ccommon = 
                 (IF ttmrg.ccommon = "" THEN "" ELSE ",") + 
                 ttmrgcol.colname.               
       END.
       ELSE IF NUM-ENTRIES(ttmrgcol.collogids,",") = 1 THEN
       DO:
           FIND FIRST ttmrg WHERE
               ttmrg.mrgid = imrgid AND
               ttmrg.logid = INT(ttmrgcol.collogids)
               NO-ERROR.
           IF AVAILABLE ttmrg THEN
               ttmrg.cprivate = 
                 (IF ttmrg.cprivate = "" THEN "" ELSE ",") + 
                 ttmrgcol.colname.               
       END.
   END.

   /**** CREATE TEMP TABLE FROM MERGE COLUMNS ****/

   /* create the temp table now */
   FIND FIRST ttlog EXCLUSIVE-LOCK WHERE
       ttlog.logid = imrgid NO-ERROR.
   IF NOT AVAILABLE ttlog THEN RETURN.
   CREATE TEMP-TABLE htt IN WIDGET-POOL "logpool".

   /* each identified column */
   FOR EACH ttmrgcol NO-LOCK WHERE
       ttmrgcol.mrgid = imrgid
       BY mrgid BY colid:
       htt:ADD-NEW-FIELD(ttmrgcol.colname, ttmrgcol.coltype,0,ttmrgcol.colformat).
   END.

   htt:TEMP-TABLE-PREPARE("merge").
   hbuf = htt:DEFAULT-BUFFER-HANDLE.

   /**** LOAD RECORDS INTO MERGE TABLE ****/
   FOR EACH ttmrg EXCLUSIVE-LOCK WHERE
       ttmrg.mrgid = imrgid:

       FIND FIRST ttlog NO-LOCK WHERE
           ttlog.logid = ttmrg.logid NO-ERROR.
       /* if ttlog is not available, original log had been removed
        * from memory, so we will need to populate this log's
        * records from the merge. */
       IF (NOT AVAILABLE ttlog) THEN
       DO:
           lfrommrg = TRUE.
           FIND FIRST ttlog NO-LOCK WHERE
               ttlog.logid = ttmrg.mrgfrom NO-ERROR.
           IF NOT AVAILABLE ttlog THEN 
           DO:
               /* major error, the existing merge no longer exists */
               MESSAGE "Can't find ttlog.logid" ttmrg.mrgfrom
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
               NEXT.
           END.
           ELSE
               MESSAGE "Found ttlog.logid" ttmrg.mrgfrom ttmrg.mrgfromord
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
       END.
       ELSE
           lfrommrg = FALSE.

       FIND FIRST ttmrg2 NO-LOCK WHERE
           ttmrg.mrgid = ttmrg2.mrgid AND
           ttmrg.logorder = ttmrg2.logorder NO-ERROR.
       ASSIGN 
           dtimeadj = (IF AVAILABLE ttmrg2 THEN 
               ttmrg2.itimeadj - ttmrg.itimeadj
               ELSE 0)
           ttmrg.itimeadj = dtimeadj.
       ASSIGN 
           htt2 = ttlog.htt
           hbuf2 = htt2:DEFAULT-BUFFER-HANDLE.
       /* create the buffer-copy pairs list for the mrgflds.
        * if we have to get the log records from the previous merge, 
        * then no need to put in pairs for buffer-copy, as the fields
        * will be the same in new merge and existing merge */
       IF (lfrommrg) THEN
           cpairs = "".
       ELSE
       cpairs = (IF ENTRY(1,ttmrg.cmrgflds,",") <> "logdate" THEN
                "logdate," + ENTRY(1,ttmrg.cmrgflds,",") + "," ELSE "") + 
               (IF ENTRY(2,ttmrg.cmrgflds,",") <> "rawlogtime" THEN
                "rawlogtime," + ENTRY(2,ttmrg.cmrgflds,",") /* + "," */ ELSE "") + 
               (IF ENTRY(3,ttmrg.cmrgflds,",") <> "logmsg" THEN
                "logmsg," + ENTRY(3,ttmrg.cmrgflds,",") ELSE "").
                                                                   
       /* create the file-line line format */
       clinefmt = fill("9",LENGTH(STRING(ttmrg.irows))).
       
       /* create a query to traverse the log file */
       CREATE QUERY hqry.
       hqry:SET-BUFFERS(hbuf2).
       IF lfrommrg THEN
       DO:
           /* query to get one log from within the previous merge */
           hqry:QUERY-PREPARE("for each " + hbuf2:NAME + 
                              " where logid = " + STRING(ttmrg.mrgfromord)).
           MESSAGE hqry:PREPARE-STRING
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
       END.
       ELSE
           /* query to get all records from this log */
           hqry:QUERY-PREPARE("for each " + hbuf2:NAME).
       hqry:QUERY-OPEN().
       ictr = 1.
       REPEAT ON ERROR UNDO,LEAVE:
           hqry:GET-NEXT().
           IF hqry:QUERY-OFF-END THEN LEAVE.
           /* copy the log record into the merge log */
           hbuf:BUFFER-CREATE().
           hbuf:BUFFER-COPY(hbuf2,ttmrg.cnomrgflds + ",file-line",cpairs) NO-ERROR.
           IF ERROR-STATUS:ERROR THEN
           DO itmp = 1 TO error-status:NUM-MESSAGES:

               MESSAGE 
                   hbuf2:NAME
                   ERROR-STATUS:GET-NUMBER(itmp)
                   ERROR-STATUS:GET-MESSAGE(itmp)
                   VIEW-AS ALERT-BOX.
           END.
           /* logid */
           hfld = hbuf:BUFFER-FIELD("logid").
           hfld:BUFFER-VALUE = ttmrg.logorder.

           /* set the time field - take into account any adjustments */
           ASSIGN
           hfld = hbuf:BUFFER-FIELD("rawlogtime")
           dtime = hfld:BUFFER-VALUE.
           IF (dtimeadj <> 0) THEN
           DO:
               ASSIGN 
               hfld = hbuf:BUFFER-FIELD("logdate")
               ddate = hfld:BUFFER-VALUE.
               RUN adjustTime(INPUT-OUTPUT ddate,INPUT-OUTPUT dtime, INPUT dtimeadj).
               hfld:BUFFER-VALUE = ddate.
               hfld = hbuf:BUFFER-FIELD("rawlogtime").
               hfld:BUFFER-VALUE = dtime.
           END.

           RUN getTimeString(dtime,INPUT true,OUTPUT ctime).
           hfld = hbuf:BUFFER-FIELD("logtime").
           hfld:BUFFER-VALUE = ctime.

           /* add the file-line field */
           hfld = hbuf:BUFFER-FIELD("file-line").
           hfld:BUFFER-VALUE = string(ttmrg.logorder,"zz9") + "." +
               STRING(ictr,clinefmt) .
           ictr = ictr + 1.
           irows = irows + 1.
       END.
       hqry:QUERY-CLOSE().
       DELETE OBJECT hqry.
   END.

   /* save the temp-table into the ttlog record */
   FIND FIRST ttlog EXCLUSIVE-LOCK WHERE
       ttlog.logid = imrgid NO-ERROR.
   IF AVAILABLE ttlog THEN
       ASSIGN 
           ttlog.htt = htt
           ttlog.irows = irows.
   
   /* open a browser on this */
   RUN openViewer(cmrgname,"by logdate by logtime by file-line",?).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkProgressCancelled C-Win 
PROCEDURE checkProgressCancelled :
/*------------------------------------------------------------------------------
  Purpose:     Checks if the progress window was cancelled
  Parameters:  OUTPUT lcancelled
               - true if user pressed Cancel on the progress window
               - false otherwise
  Notes:       progress window must have been created by showProgressWindow.
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAM lcancelled AS LOG INIT NO NO-UNDO.

  IF NOT VALID-HANDLE(hprogwin) THEN RETURN.

  RUN getCancelled IN hprogwin (OUTPUT lcancelled).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closeLog C-Win 
PROCEDURE closeLog :
/*------------------------------------------------------------------------------
  Purpose:     Closes a log file, removing the temp-table from memory, and 
               closing any Log Browse windows viewing the temp-table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hproc AS HANDLE     NO-UNDO.
  
  hlogqry:GET-CURRENT.

  IF NOT AVAILABLE ttlog THEN RETURN.

  /* verify closing log */
  MESSAGE "Unload log file" ttlog.logfile "?"
      VIEW-AS ALERT-BOX QUESTION
      BUTTONS OK-CANCEL
      UPDATE lOK AS LOGICAL.
  IF NOT lOK THEN RETURN.

  /* close all viewers */
  FOR EACH ttview NO-LOCK WHERE
      ttview.logfile = ttlog.logfile:
      APPLY "close":U TO ttview.hproc.
  END.

  RUN deleteTT(ttlog.logfile).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closeProcedure C-Win 
PROCEDURE closeProcedure :
/*------------------------------------------------------------------------------
  Purpose:     Performs cleanup when ending logread. Deletes all temp-tables,
               closes all Log Browse windows, and unloads handlers.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* remove all viewers */
  FOR EACH ttview NO-LOCK:
      APPLY "CLOSE":U TO ttview.hproc.
  END.
  
  /* remove all logs */
  FOR EACH ttlog NO-LOCK:
      RUN deleteTT(ttlog.logfile).
  END.
  
  /* remove all handlers */
  FOR EACH ttlogtype:      
      IF ttlogtype.hproc <> ? THEN
          DELETE PROCEDURE ttlogtype.hproc.
      DELETE ttlogtype.
  END.

  DELETE WIDGET-POOL "logpool" NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowsers C-Win 
PROCEDURE createBrowsers PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Creates the browser in the LogRead main window.
  Parameters:  <none>
  Notes:       Using a dynamic browse, because I didn't like the AppBuilder's 
               way of developing browse objects with temp-tables. I saw no 
               need to connect to a database of temp-tables for this, especially
               when I first started, as the temp-tables changed a lot.
               Maybe in future, someone can convince me it is the "right" 
               thing to do.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hcol AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iwidth AS INTEGER    NO-UNDO.

  CREATE QUERY hlogqry.
  hlogqry:SET-BUFFERS("ttlog").
  hlogqry:QUERY-PREPARE("for each ttlog no-lock").
  hlogqry:QUERY-OPEN.

  CREATE BROWSE hlogbr
      ASSIGN 
      FRAME = FRAME {&FRAME-NAME}:HANDLE
      COL = 1.00
      ROW = 2.00 
      WIDTH = FRAME {&FRAME-NAME}:WIDTH
      HEIGHT = FRAME {&FRAME-NAME}:HEIGHT - 1.0
      QUERY = hlogqry
      SENSITIVE = TRUE
      READ-ONLY = FALSE
      SEPARATORS = TRUE
      COLUMN-RESIZABLE = TRUE
      COLUMN-MOVABLE = FALSE
      EXPANDABLE = FALSE
      ROW-MARKERS = FALSE
      MULTIPLE = TRUE
      TRIGGERS:
        ON value-changed
            PERSISTENT RUN enableToolbar.
        ON DEFAULT-ACTION
            PERSISTENT RUN displayLogBrowse.
      END TRIGGERS
      .

  hlogbr:ADD-COLUMNS-FROM("ttlog","logid,htt,cdesc,idatefmtix,cdatefmt,itimeadj,ccodepage,csrclang,csrcmsgs,ctrgmsgs,dStartDate,dStartTime,dEndDate,dEndTime").

  ASSIGN 
      hcol = hlogbr:GET-BROWSE-COLUMN(1)
      hcol:WIDTH-CHARS = 49
      .
  ASSIGN 
      hcol = hlogbr:GET-BROWSE-COLUMN(2)
      hcol:WIDTH-CHARS = 15
      .
  ASSIGN 
      hcol = hlogbr:GET-BROWSE-COLUMN(3)
      hcol:LABEL = "# Rows"
      hcol:WIDTH-CHARS = 11.5
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createStatusWindow C-Win 
PROCEDURE createStatusWindow :
/*------------------------------------------------------------------------------
  Purpose:     Display a Status window, to let the user know what is going on
  Parameters:  <none>
  Notes:       DEPRECATED. Not used in LogRead
------------------------------------------------------------------------------*/

  CREATE WINDOW hstatwin
      ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 10
         WIDTH              = 60
         MAX-HEIGHT         = 10
         MAX-WIDTH          = 60
         VIRTUAL-HEIGHT     = 10
         VIRTUAL-WIDTH      = 60
         RESIZE             = NO
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         TOP-ONLY           = YES
         MESSAGE-AREA       = no
         SENSITIVE          = yes
      TRIGGERS:
        ON WINDOW-CLOSE
        DO:
            MESSAGE "closing" VIEW-AS ALERT-BOX.
            hstatwin:VISIBLE = FALSE.
            RETURN.
        END.
        ON ENTRY
        DO:
            MESSAGE "entry hstatwin" VIEW-AS ALERT-BOX.
            lStatusSeen = TRUE.
            RETURN.
        END.
      END TRIGGERS.

  CREATE FRAME hstatfrm
      ASSIGN 
    WIDTH = hstatwin:WIDTH
    HEIGHT = hstatwin:HEIGHT
    DOWN = 1
    BOX = NO
      PARENT = hstatwin
    OVERLAY = TRUE
    THREE-D = TRUE
      VISIBLE = YES
    .

  CREATE EDITOR hstattxt
      ASSIGN 
        HEIGHT = 9
        WIDTH = 58
        FRAME = hstatfrm
        X = 0.5
        Y = 0.5
        READ-ONLY = YES
        SCROLLBAR-HORIZONTAL = YES
        SCROLLBAR-VERTICAL = YES
        SELECTABLE = FALSE
        SENSITIVE = YES
      VISIBLE = YES
      TRIGGERS:
        ON ENTRY
        DO:
            MESSAGE "entry hstattxt" VIEW-AS ALERT-BOX.
          lStatusSeen = TRUE.
          RETURN.
        END.
      END TRIGGERS.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteTT C-Win 
PROCEDURE deleteTT :
/*------------------------------------------------------------------------------
  Purpose:     Deletes a log file temp-table from memory, when closing the log
  Parameters:  
    cLogFile - [IN] name of the log file to close
  Notes:       All log browse windows viewing this temp-table must be closed 
               before calling this procedure.
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cLogFile AS CHAR NO-UNDO.
  
  DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
  
  FIND FIRST ttlog WHERE
      ttlog.logfile = cLogFile NO-ERROR.
  IF AVAILABLE ttlog THEN
  DO:
      /* if not an internal temp-table, delete */
      IF ttlog.logtype <> "internal" THEN
      DO:
          /* delete the temp table */
          hbuf = ttlog.htt:DEFAULT-BUFFER-HANDLE.
          hbuf:EMPTY-TEMP-TABLE().
          DELETE OBJECT ttlog.htt.
      END.
      ELSE
      DO:
          /* just unexpose internal tt */
          FIND FIRST ttinternal EXCLUSIVE-LOCK WHERE
              ttinternal.ttname = cLogFile NO-ERROR.
          IF AVAILABLE ttinternal THEN
              ttinternal.lexposed = FALSE.
      END.
      DELETE ttlog.
      /* refresh the main window browser */
      RUN refreshLogBrowse.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteViewer C-Win 
PROCEDURE deleteViewer :
/*------------------------------------------------------------------------------
  Purpose:     Closes a log browse window
  Parameters:  
    hproc   - [IN] procedure handle of Log Browse window
    ctitle  - [IN] title of the Log Browse Window
  Notes:       Removes the filename from the window menu as well, based on 
               the title of the window (there may be multiple Log Browse
               windows on the same log, so we must get the right one).
------------------------------------------------------------------------------*/
  DEF INPUT PARAM hproc AS HANDLE NO-UNDO.
  DEF INPUT PARAM ctitle AS CHAR NO-UNDO.

  DEFINE VARIABLE cLogFile AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE htmpmnu AS HANDLE     NO-UNDO.

  /* delete this viewer */
  FIND FIRST ttview WHERE
      ttview.hproc = hproc NO-ERROR.
  IF AVAILABLE ttview THEN
  DO:
      cLogFile = ttview.logfile.
      DELETE PROCEDURE hproc.
      DELETE ttview.
      /* remove from windows menu */
      htmpmnu = hwinmenu:FIRST-CHILD.
      DO WHILE (valid-handle(htmpmnu)):
          IF htmpmnu:LABEL = ctitle THEN
          DO:
              /* htmpmnu:PARENT = ?. */
              DELETE OBJECT htmpmnu.
              LEAVE.
          END.
          htmpmnu = htmpmnu:NEXT-SIBLING.
      END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayHelp C-Win 
PROCEDURE displayHelp :
/*------------------------------------------------------------------------------
  Purpose:     Displays the help file for LogRead   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {&LOGREADHELP} {&LogRead_main_window}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayLogBrowse C-Win 
PROCEDURE displayLogBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Displays a log browse window. 
  Parameters:  
    hproc - [IN] handle of an existing Log Browse Window.
  Notes:       This is the trigger procedure for double-clicking on a row
               in the Main window's browse. If a Log Browse window already 
               exists for the log file, bring it to the top. If not, then 
               create a new Log Browse Window for it.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hproc AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cqry AS CHARACTER  NO-UNDO.

  hlogqry:GET-CURRENT.

  IF NOT AVAILABLE ttlog THEN RETURN.
  FIND FIRST ttview NO-LOCK WHERE
      ttview.logid = ttlog.logid NO-ERROR.
  IF NOT AVAILABLE ttview THEN 
  DO:
      RUN openViewer(ttlog.logfile,?,?).
  END.
  ELSE
  DO:
      hproc = ttview.hproc.
      RUN makeVisible IN hproc (TRUE) NO-ERROR.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableToolbar C-Win 
PROCEDURE enableToolbar :
/*------------------------------------------------------------------------------
  Purpose:     Enables the button on the toolbar and menu, based on the current 
               selections in the Main window's bowser.
  Parameters:  <none>
  Notes:       If 0 files are selected, only the log open button is enabled.
               If 1 file is selected, the log open and properties buttons 
               are enabled.
               if >1 files are selected, the log open and merge buttons 
               are enabled.
------------------------------------------------------------------------------*/
  /* DEF INPUT PARAM lselected AS LOG NO-UNDO. */
  DEFINE VARIABLE isel AS INTEGER    NO-UNDO.
  isel = hlogbr:NUM-SELECTED-ROWS.
  DO WITH FRAME fToolbar:
      ASSIGN bProp:SENSITIVE = (IF isel = 1 THEN TRUE ELSE FALSE)
          bMerge:SENSITIVE = (IF isel > 1 THEN TRUE ELSE FALSE).
  END.
  ASSIGN
          hclosemenu:SENSITIVE = (IF isel = 1 THEN TRUE ELSE FALSE)
          hpropmenu:SENSITIVE = (IF isel = 1 THEN TRUE ELSE FALSE)
          hmrgmenu:SENSITIVE = (IF isel > 1 THEN TRUE ELSE FALSE).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE bMerge rToolbar bRun bOpen bProp 
      WITH FRAME fToolbar IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fToolbar}
  VIEW FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitLogRead C-Win 
PROCEDURE exitLogRead :
/*------------------------------------------------------------------------------
  Purpose:     Closes LogRead.
  Parameters:  <none>
  Notes:       Trigger procedure for the File->Exit menu option
------------------------------------------------------------------------------*/
  APPLY "close":U TO THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exposeInternalTT C-Win 
PROCEDURE exposeInternalTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cname AS CHAR NO-UNDO.
  DEF OUTPUT PARAM htt AS HANDLE NO-UNDO.

  FIND FIRST ttinternal EXCLUSIVE-LOCK WHERE
      ttinternal.ttname = cname NO-ERROR.
  IF NOT AVAILABLE ttinternal THEN 
      RETURN.
  htt = ttinternal.htt.
  IF ttinternal.lexposed THEN 
      RETURN.

  /* add a handler for "internal" */
  RUN addPseudoType("Internal","Internal","","","").

  RUN addTT(ttinternal.ttname,"Internal", ttinternal.htt ,1,ttinternal.ttname).
  ttinternal.lexposed = TRUE.
  RUN refreshLogBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHandlerAttribute C-Win 
PROCEDURE getHandlerAttribute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM hhdlr AS HANDLE NO-UNDO.
  DEF INPUT PARAM clogtype AS CHAR NO-UNDO.
  DEF INPUT PARAM cattrname AS CHAR NO-UNDO.
  DEF OUTPUT PARAM cattrval AS CHAR INIT ? NO-UNDO.

  IF NOT VALID-HANDLE(hhdlr) AND (clogtype = ? OR clogtype = "") THEN RETURN.

  /* find ttlogtype by handle */
  IF VALID-HANDLE(hhdlr) THEN
      /* find the logtype for this handler */
      FIND FIRST tthdlrattr NO-LOCK WHERE 
          tthdlrattr.hhdlr = hhdlr AND 
          tthdlrattr.attrname = cattrname NO-ERROR.
  ELSE
      FIND FIRST tthdlrattr NO-LOCK WHERE
          tthdlrattr.logtype = clogtype AND 
          tthdlrattr.attrname = cattrname NO-ERROR.
  IF AVAILABLE tthdlrattr THEN
      ASSIGN cattrval = tthdlrattr.attrval.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHandlerInfo C-Win 
PROCEDURE getHandlerInfo :
/*------------------------------------------------------------------------------
  Purpose:     Returns information about a log type handler
  Parameters:  
    cLogType  - [IN] name of log type to get handler information about
    hrdrproc  - [IN] procedure handle of handler
    cFileName - [IN] name of log file, for pseudo-type handlers
    hlogbuf   - [OUT] buffer handler of handler information
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cLogType AS CHAR NO-UNDO.    /* name of log type */
  DEF INPUT PARAM hrdrproc AS HANDLE NO-UNDO.  /* proc handler of handler */
  DEF INPUT PARAM cFileName AS CHAR NO-UNDO.   /* name of file, for pseudo handlers */
  DEF OUTPUT PARAM hlogbuf AS HANDLE NO-UNDO.  /* buffer of ttlogtype */

  IF (cLogType <> ? AND cLogType <> "") THEN
      FIND FIRST ttlogtype NO-LOCK WHERE
          ttlogtype.logtype = cLogType NO-ERROR.
  ELSE IF valid-handle(hrdrproc) THEN
      FIND FIRST ttlogtype NO-LOCK WHERE
          ttlogtype.hproc = hrdrproc NO-ERROR.
  ELSE IF cFileName <> "" AND cFilename <> ? THEN
  DO:
      /* only really for pseudo handlers */
      FIND FIRST ttlog NO-LOCK WHERE
          ttlog.logfile = cFileName NO-ERROR.
      IF AVAILABLE ttlog THEN
          FIND FIRST ttlogtype NO-LOCK WHERE
            ttlogtype.logtype = ttlog.logtype NO-ERROR.
  END.
  IF AVAILABLE ttlogtype THEN
      hlogbuf = BUFFER ttlogtype:HANDLE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInternalTT C-Win 
PROCEDURE getInternalTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cname AS CHAR NO-UNDO.
  DEF OUTPUT PARAM htt AS HANDLE NO-UNDO.

  FIND FIRST ttinternal NO-LOCK WHERE
      ttinternal.ttname = cname NO-ERROR.
  IF AVAILABLE ttinternal THEN
      htt = ttinternal.htt.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLoadedLogHandle C-Win 
PROCEDURE getLoadedLogHandle :
/*------------------------------------------------------------------------------
  Purpose:     Returns the information about a loaded log file
  Parameters:  
    clogname  - [IN] name of log file being queried
    clogtype  - [OUT] log type of log file
    hrdrproc  - [OUT] procedure handle of this log file's log type handler
    htt       - [OUT] handle of temp-table containing log file  
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM clogname AS CHAR NO-UNDO.
  DEF OUTPUT PARAM clogtype AS CHAR NO-UNDO.
  DEF OUTPUT PARAM hrdrproc AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM htt AS HANDLE NO-UNDO.

  FIND FIRST ttlog NO-LOCK WHERE
      ttlog.logfile = clogname NO-ERROR.
  IF AVAILABLE ttlog THEN
  DO:
      FIND FIRST ttlogtype NO-LOCK WHERE
          ttlogtype.logtype = ttlog.logtype NO-ERROR.
      ASSIGN 
      clogtype = ttlog.logtype
      hrdrproc = (IF AVAILABLE ttlogtype THEN ttlogtype.hproc ELSE ?)
      htt = ttlog.htt.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogInfo C-Win 
PROCEDURE getLogInfo :
/*------------------------------------------------------------------------------
  Purpose:     Returns information about a log file
  Parameters:  
    cFileName - [IN] name of log file to get information for
    hlogtt    - [IN] handle of temp-table containing log info
    hlogbuf   - [OUT] handle to buffer containing ttlog record
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cFileName AS CHAR NO-UNDO.
  DEF INPUT PARAM hlogtt AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM hlogbuf AS HANDLE NO-UNDO.

  IF (cFileName <> ? AND cFileName <> "") THEN
      FIND FIRST ttlog NO-LOCK WHERE
          ttlog.logfile = cFileName NO-ERROR.
  ELSE IF valid-handle(hlogtt) THEN
      FIND FIRST ttlog NO-LOCK WHERE
          ttlog.htt = hlogtt NO-ERROR.
  IF AVAILABLE ttlog THEN
      hlogbuf = BUFFER ttlog:HANDLE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogNames C-Win 
PROCEDURE getLogNames :
/*------------------------------------------------------------------------------
  Purpose:     Returns teh names of all loaded logs with the given log type
  Parameters:  
    clogtypes - [IN] log type to get files for
    clogname - [OUT] CSV list of log files that have the given log type.
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM clogtypes AS CHAR NO-UNDO.
  DEF OUTPUT PARAM clognames AS CHAR NO-UNDO.

  FOR EACH ttlog NO-LOCK:
      IF (CAN-DO(ttlog.logtype,clogtypes) OR
          (clogtypes = "" OR clogtypes = ?)) THEN
          clognames = clognames + (IF clognames = "" THEN "" ELSE ",") + 
                      ttlog.logfile.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogTypes C-Win 
PROCEDURE getLogTypes :
/*------------------------------------------------------------------------------
  Purpose:     Returns a list of log types
  Parameters:  
    ctypes - [IN] if "PSEUDO", returns a list of pseudo log types
                  if "HANDLERS", returns list of log types with handlers
                  otherwise, returns a list of all log types
    lpairs - [IN] whether to create the list for LIST-ITEM-PAIRS
    clogtypes - [OUT] CSV list of log types
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM ctypes AS CHAR NO-UNDO.
  DEF INPUT PARAM lpairs AS LOG NO-UNDO.
  DEF OUTPUT PARAM clogtypes AS CHAR NO-UNDO.

  IF ctypes = "PSEUDO" THEN
      FOR EACH ttlogtype NO-LOCK WHERE
          ttlogtype.hdlrprog = "PSEUDO" :
          clogtypes = clogtypes + (IF clogtypes = "" THEN "" ELSE ",") + 
            (IF lpairs THEN ttlogtype.typename + "," ELSE "" ) + 
              ttlogtype.logtype.
      END.
  ELSE IF ctypes = "HANDLERS" THEN
      FOR EACH ttlogtype NO-LOCK WHERE
          ttlogtype.hdlrprog <> "PSEUDO" :
          clogtypes = clogtypes + (IF clogtypes = "" THEN "" ELSE ",") + 
              (IF lpairs THEN ttlogtype.typename + "," ELSE "" ) + 
            ttlogtype.logtype.
      END.
  ELSE
      FOR EACH ttlogtype NO-LOCK:
         clogtypes = clogtypes + (IF clogtypes = "" THEN "" ELSE ",") + 
             (IF lpairs THEN ttlogtype.typename + "," ELSE "" ) + 
             ttlogtype.logtype.
      END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPseudoTypeQuery C-Win 
PROCEDURE getPseudoTypeQuery :
/*------------------------------------------------------------------------------
  Purpose:     Returns the requested query of a pseudo log type
  Parameters:  
    cqryid    - [IN] name of query to return ("" or ? returns list of qryids)
    cFileName - [IN] name of log file, to determine the appropriate pseudo logtype
    qrytxt    - [OUT] 4GL query text
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cqryid AS CHAR NO-UNDO.
  DEF INPUT PARAM cFileName AS CHAR NO-UNDO.
  DEF OUTPUT PARAM cqrytxt AS CHAR INIT "" NO-UNDO.

  /* find the logtype for the filename */
  FIND FIRST ttlog WHERE
      ttlog.logfile = cFileName NO-ERROR.
  IF NOT AVAILABLE ttlog THEN RETURN.

  /* find the ttlogtype for this ttlog */
  FIND FIRST ttlogtype NO-LOCK WHERE
      ttlogtype.logtype = ttlog.logtype NO-ERROR.
  IF NOT AVAILABLE ttlogtype THEN 
      FIND FIRST ttlogtype NO-LOCK WHERE
          ttlogtype.loadix = 999 NO-ERROR.
  IF NOT AVAILABLE ttlogtype THEN RETURN.

  IF cqryid = "" OR cqryid = ? THEN
  DO:
      FOR EACH ttpqry NO-LOCK WHERE
          ttpqry.logtype = ttlogtype.logtype:
          cqrytxt = cqrytxt + (IF cqrytxt = "" THEN "" ELSE ",") + 
              ttpqry.qryid.
      END.
  END.
  ELSE
  DO:
      FIND FIRST ttpqry NO-LOCK WHERE
          ttpqry.logtype = ttlogtype.logtype AND
          ttpqry.qryid = cqryid NO-ERROR.
      IF AVAILABLE ttpqry THEN
          cqrytxt = ttpqry.qrytxt.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideProgressWindow C-Win 
PROCEDURE hideProgressWindow :
/*------------------------------------------------------------------------------
  Purpose:     Hide the progress window
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT VALID-HANDLE(hprogwin) THEN RETURN.

  DELETE PROCEDURE hprogwin.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialiseHandlers C-Win 
PROCEDURE initialiseHandlers :
/*------------------------------------------------------------------------------
  Purpose:     Loads the log type handlers
  Parameters:  <none>
  Notes:       Looks through the current directory for any handlers, then 
               through the LogRead install directory.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cdir AS CHARACTER  NO-UNDO.

  /* read through ./handlers, if it exists */
  FILE-INFO:FILE-NAME = "./handlers" NO-ERROR.
  IF (index(FILE-INFO:FILE-TYPE,"D") > 0) THEN
    RUN loadHandlersFromDir("./handlers").

  /* read through logread/handlers */
  IF SEARCH("logread/logread.w") MATCHES "*<<*" OR 
      SEARCH("logread/logread.r") MATCHES "*<<*" THEN
  DO:
      /* load from proc lib */
      RUN loadHandlersFromList.
  END.
  ELSE
  DO:
      /* load from files */
      IF SEARCH("logread/logread.w") <> ? THEN
          FILE-INFO:FILE-NAME = "logread/logread.w".
      ELSE IF SEARCH("logread/logread.r") <> ? THEN
          FILE-INFO:FILE-NAME = "logread/logread.r".
      ELSE
      DO:
          /* something wrong, can't find logread.w. error?, leave */
          RETURN.
      END.
      cdir = substring(FILE-INFO:FULL-PATHNAME,1,LENGTH(FILE-INFO:FULL-PATHNAME) - LENGTH("logread.w")).
      cdir = cdir + "/handlers".
      RUN loadHandlersFromDir(cdir).
  END.

  /* add the merge pseudo handler */
  RUN addPseudoType("MERGE","Merge","rawlogtime,logid","logdate,rawlogtime,logmsg,logtime","").
  RUN addPseudoTypeQuery("MERGE","Default","by logdate by logtime by file-line").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialiseMenu C-Win 
PROCEDURE initialiseMenu :
/*------------------------------------------------------------------------------
  Purpose:     Initialises the menu for the LogRead main window
  Parameters:  
  Notes:       Using a dynamic menu for the whole menubar, as there are
               dynamic menus we have to turn on and off.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE htmpmenu AS HANDLE     NO-UNDO.
  DEFINE VARIABLE htmpitem AS HANDLE     NO-UNDO.

  CREATE MENU hmainmenu.
  /* file menu */
  CREATE SUB-MENU htmpmenu
      ASSIGN 
      PARENT = hmainmenu
      LABEL = "&File".
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      LABEL = "&Load Log..."
      TRIGGERS:
      ON choose
          PERSISTENT RUN openLog.
      END TRIGGERS.
  CREATE MENU-ITEM hmrgmenu
      ASSIGN
      PARENT = htmpmenu
      LABEL = "&Merge..."
      TRIGGERS:
      ON choose
          PERSISTENT RUN beginMerge.
      END TRIGGERS.
  CREATE MENU-ITEM hclosemenu
      ASSIGN
      PARENT = htmpmenu
      LABEL = "&Unload Log"
      TRIGGERS:
      ON choose
          PERSISTENT RUN closeLog.
      END TRIGGERS.
      
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      SUBTYPE = "RULE" .
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      LABEL = "&Run Utility..."
      TRIGGERS:
      ON choose
          PERSISTENT RUN runUtility.
      END TRIGGERS.
  CREATE MENU-ITEM hpropmenu
      ASSIGN
      PARENT = htmpmenu
      LABEL = "Properties"
      TRIGGERS:
      ON choose
          PERSISTENT RUN showBrowseLogProperties.
      END TRIGGERS.
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      SUBTYPE = "RULE".
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      LABEL = "&Exit"
      TRIGGERS:
      ON choose
          PERSISTENT RUN exitLogRead.
      END TRIGGERS.

  /* Handlers menu */
  CREATE SUB-MENU hhdlrmenu
      ASSIGN 
      PARENT = hmainmenu
      LABEL = "Ha&ndler".

  /* Windows menu */
  CREATE SUB-MENU hwinmenu
      ASSIGN 
      PARENT = hmainmenu
      LABEL = "&Window".

  /* Help menu */
  CREATE SUB-MENU htmpmenu
      ASSIGN
      PARENT = hmainmenu
      LABEL = "&Help".
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      LABEL = "Help"
      TRIGGERS:
      ON CHOOSE
          PERSISTENT RUN DisplayHelp.
      END TRIGGERS.
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      LABEL = "About..."
      TRIGGERS:
      ON choose
          PERSISTENT RUN AboutMessage.
      END TRIGGERS.

  c-win:MENUBAR = hmainmenu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadHandler C-Win 
PROCEDURE loadHandler :
/*------------------------------------------------------------------------------
  Purpose:     Loads an individual log type handler.
  Parameters:  
    crdrprog - [IN] the pathname of the log type handler
  Notes:       Handler must conform to the LogRead Handler API
------------------------------------------------------------------------------*/
    DEF INPUT PARAM crdrprog AS CHAR NO-UNDO.
    DEFINE VARIABLE hproc AS HANDLE     NO-UNDO.
    DEFINE VARIABLE clogtype AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE ctypename AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE irdrid AS INTEGER    NO-UNDO.
    DEFINE VARIABLE hmenuitem AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cproc AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iproc AS INTEGER    NO-UNDO.

    IF SEARCH(crdrprog) = ? THEN RETURN.
    /* run the program persistently, 
     * save the handle and the output to ttlogtype */
    RUN value(crdrprog) PERSISTENT SET hproc (INPUT this-procedure,OUTPUT clogtype, OUTPUT ctypename) NO-ERROR.
    IF NOT VALID-HANDLE(hproc) THEN
    DO: 
        RETURN.
    END.
    /* check there is not another handler loaded with the sale logtype name */
    FIND FIRST ttlogtype NO-LOCK WHERE
        ttlogtype.logtype = clogtype NO-ERROR.
    IF AVAILABLE ttlogtype THEN
    DO:
        DELETE PROCEDURE hproc.
        RETURN.
    END.
    /* check it has a loadLogFile procedure */
    IF NOT CAN-DO(hproc:INTERNAL-ENTRIES,"loadLogFile") THEN
    DO:
        DELETE PROCEDURE hproc.
        RETURN.
    END.

    /* if reader type is not "UNKNOWN", add it to the end of the list */
    IF clogtype <> "UNKNOWN" THEN
    DO:
        FIND LAST ttlogtype NO-LOCK WHERE
            ttlogtype.loadix < 999 NO-ERROR.
        IF AVAILABLE ttlogtype THEN
            irdrid = ttlogtype.loadix + 1.
        ELSE
            irdrid = 0.
    END.
    ELSE 
        irdrid = 999.
    CREATE ttlogtype.
    ASSIGN 
        ttlogtype.loadix = irdrid
        ttlogtype.hdlrprog = crdrprog
        ttlogtype.logtype = clogtype
        ttlogtype.typename = ctypename
        ttlogtype.hproc = hproc.
    /* now get utility functions and queries */
    IF CAN-DO(hproc:INTERNAL-ENTRIES,"getQuery") THEN
        RUN getQuery IN hproc ("",OUTPUT ttlogtype.utilqry).
    IF CAN-DO(hproc:INTERNAL-ENTRIES,"guessType") THEN
        ttlogtype.guesstype = TRUE.
    DO iproc = 1 TO NUM-ENTRIES(hproc:INTERNAL-ENTRIES):
        cproc = ENTRY(iproc,hproc:INTERNAL-ENTRIES).
        IF cproc BEGINS "util_" THEN
            ttlogtype.utilfunc = ttlogtype.utilfunc + 
                (IF ttlogtype.utilfunc = "" THEN "" ELSE ",") + 
                SUBSTRING(cproc,6).
    END.
    IF CAN-DO(hproc:INTERNAL-ENTRIES,"getMergeFields") THEN
        RUN getMergeFields IN hproc (OUTPUT ttlogtype.cmrgflds,OUTPUT ttlogtype.cnomrgflds).

    IF CAN-DO(hproc:INTERNAL-ENTRIES,"getHiddenCols") THEN
        RUN getHiddenCols IN hproc (OUTPUT ttlogtype.chidcols).

    /* add to show-handlers menu */
    CREATE MENU-ITEM hmenuitem
        ASSIGN 
        PARENT = hhdlrmenu
        LABEL = clogtype
        TRIGGERS:
          ON CHOOSE
              PERSISTENT RUN showHandlerInfo(INPUT clogtype).
        END TRIGGERS.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadHandlersFromDir C-Win 
PROCEDURE loadHandlersFromDir :
/*------------------------------------------------------------------------------
  Purpose:     Loads all log handlers in a given directory.
  Parameters:  
    cdir - [IN] directory to search for handlers
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cdir AS CHAR NO-UNDO.

  DEFINE VARIABLE cFileName AS CHARACTER  FORMAT "x(20)" NO-UNDO.
  DEFINE VARIABLE cFilePath AS CHARACTER FORMAT "x(255)" NO-UNDO.
  DEFINE VARIABLE cAttrs AS CHARACTER  FORMAT "x(20)" NO-UNDO.

  /* first, check for handlers.ini */
  FILE-INFO:FILE-NAME = cdir + "handlers.ini".
  IF index(FILE-INFO:FILE-TYPE,"F") > 0 THEN
  DO:
      RUN loadHandlersFromIni(INPUT cdir,INPUT FILE-INFO:FILE-NAME).
      RETURN.
  END.
  /* else, just load each file as we find it sequentially in the directory */
  INPUT FROM OS-DIR(cdir) no-echo.
  REPEAT:
      IMPORT cFileName cFilePath cAttrs.
      IF cFileName MATCHES "*.p" OR 
          cFileName MATCHES "*.w" OR
          cFileName MATCHES "*.r" THEN
      DO:
          RUN loadHandler(INPUT cFilePath).
      END.
  END.
  INPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadHandlersFromIni C-Win 
PROCEDURE loadHandlersFromIni :
/*------------------------------------------------------------------------------
  Purpose:     Loads all log type handlers identified in an ini file
  Parameters:  
    cdir    - [IN] directory to search for handlers listed in INI file
    cinifile - [IN] ini file to read for handler names
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cdir AS CHAR NO-UNDO.
  DEF INPUT PARAM cinifile AS CHAR NO-UNDO.
  
  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.

  INPUT FROM VALUE(cinifile) NO-ECHO.
  REPEAT:
      IMPORT UNFORMATTED cFileName.
      FILE-INFO:FILE-NAME = cdir + cFileName.
      IF (cFileName MATCHES "*.p" OR 
          cFileName MATCHES "*.w" OR
          cFileName MATCHES "*.r") AND
          index(FILE-INFO:FILE-TYPE,"F") > 0 THEN
      DO:
          RUN loadHandler(cFileName).
      END.
  END.
  INPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadHandlersFromList C-Win 
PROCEDURE loadHandlersFromList :
/*------------------------------------------------------------------------------
  Purpose:     Loads handlers from a hard-coded list
  Parameters:  <none>
  Notes:       This is to provide for running LogRead from a proc lib, 
               where we can't go looking through the list of available
               handlers.
------------------------------------------------------------------------------*/

    RUN loadHandler("logread/handlers/hadmsvr.r").
    RUN loadHandler("logread/handlers/haia100a.r").
    RUN loadHandler("logread/handlers/haia100b.r").
    RUN loadHandler("logread/handlers/hassrv91c.r").
    RUN loadHandler("logread/handlers/hassrv91d.r").
    RUN loadHandler("logread/handlers/hcli100a.r").
    RUN loadHandler("logread/handlers/hdb.r").
    RUN loadHandler("logread/handlers/hmsgr.r").
    RUN loadHandler("logread/handlers/hns100a.r").
    RUN loadHandler("logread/handlers/hns100b.r").
    RUN loadHandler("logread/handlers/hssl100b.r").
    RUN loadHandler("logread/handlers/htemplate.r").
    RUN loadHandler("logread/handlers/hubbrk100a.r").
    RUN loadHandler("logread/handlers/hubbrk100b.r").
    RUN loadHandler("logread/handlers/hwsa.r").
    RUN loadHandler("logread/handlers/hwssrv100a.r").
    RUN loadHandler("logread/handlers/hwssrv91d.r").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadInternalTTs C-Win 
PROCEDURE loadInternalTTs :
/*------------------------------------------------------------------------------
  Purpose:     Loads the internal TTs as logs so they can be browsed
  Parameters:  <none>
  Notes:       This is for internal diagnostics only. This must be 
               called by a utility program. Undocumented.
------------------------------------------------------------------------------*/

  RUN addInternalTT(TEMP-TABLE ttinternal:HANDLE,"ttinternal").
  RUN addInternalTT(TEMP-TABLE ttlog:HANDLE, "ttlog").
  RUN addInternalTT(TEMP-TABLE ttview:HANDLE,"ttview").
  RUN addInternalTT(TEMP-TABLE ttlogtype:HANDLE,"ttlogtype").
  RUN addInternalTT(TEMP-TABLE ttpqry:HANDLE,"ttpqry").
  RUN addInternalTT(TEMP-TABLE ttmerge:HANDLE,"ttmerge").
  RUN addInternalTT(TEMP-TABLE ttmrg:HANDLE,"ttmrg").
  RUN addInternalTT(TEMP-TABLE ttmrgcol:HANDLE,"ttmrgcol").
  RUN addInternalTT(TEMP-TABLE ttmrg2:HANDLE,"ttmrg2").
  RUN addInternalTT(TEMP-TABLE ttdatefmt:HANDLE,"ttdatefmt").
  RUN addInternalTT(TEMP-TABLE ttlang:HANDLE,"ttlang").
  RUN addInternalTT(TEMP-TABLE ttpromsgs:HANDLE,"ttpromsgs").
  RUN addInternalTT(TEMP-TABLE ttmsgs:HANDLE,"ttmsgs").
  RUN addInternalTT(TEMP-TABLE ttmsgpart:HANDLE,"ttmsgpart").
  RUN addInternalTT(TEMP-TABLE tthdlrattr:HANDLE,"tthdlrattr").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openLog C-Win 
PROCEDURE openLog :
/*------------------------------------------------------------------------------
  Purpose:     Loads a new log file into memory.
  Parameters:  <none>
  Notes:       Allows customer to select log file and load criteria, loads the 
               log through the log handler, and brings up a Log Browse window
               for the log.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLogName AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLogType AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iDateFmtix AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cDateFmt AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dTimeAdj AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dStartDate AS DATE       NO-UNDO.
    DEFINE VARIABLE dStartTime AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dEndDate AS DATE    NO-UNDO.
    DEFINE VARIABLE dEndTime AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE lOpenBrowse AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE hproc AS HANDLE     NO-UNDO.
    DEFINE VARIABLE htt AS HANDLE     NO-UNDO.
    DEFINE VARIABLE lLoaded AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE irows AS INTEGER    NO-UNDO.
    DEFINE VARIABLE hschema AS HANDLE     NO-UNDO.
    DEFINE VARIABLE icnt AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lload AS LOGICAL INIT TRUE   NO-UNDO.

    DO WHILE lload:

    /* open a dialog to get the filename and logtype */
    RUN logread/logopen.w ( /* INPUT TABLE ttlogtype, */
                            INPUT-OUTPUT cFileName,
                            INPUT-OUTPUT cLogType,
                            INPUT-OUTPUT iDateFmtix,
                            INPUT-OUTPUT dTimeAdj,
                            INPUT-OUTPUT cSrcLang,
                            INPUT-OUTPUT cCodePage,
                            INPUT-OUTPUT cSrcMsgs,
                            INPUT-OUTPUT cTrgMsgs,
                            INPUT-OUTPUT dStartDate,
                            INPUT-OUTPUT dStartTime,
                            INPUT-OUTPUT dEndDate,
                            input-output dEndTime,
                            INPUT TRUE,
                            /* INPUT THIS-PROCEDURE, */
                            OUTPUT lOpenBrowse).

    /* if open */
    IF cFileName <> "" THEN
    DO:
        /* first, open the log */
        FIND FIRST ttlogtype NO-LOCK
            WHERE ttlogtype.logtype = cLogType NO-ERROR.
        IF NOT AVAILABLE ttlogtype THEN 
        DO:
            MESSAGE "No Log Type" VIEW-AS ALERT-BOX.
            PAUSE 2 NO-MESSAGE.
            RETURN.
        END.

        /* check for duplicate logname */
        FOR EACH ttlog NO-LOCK WHERE
            ttlog.cdesc = cfilename:
            icnt = icnt + 1.
        END.
        IF icnt = 0 THEN
            cLogName = cFileName.
        ELSE
            /* append () to the end of duplicate filenames */
            cLogName = cFileName + "(" + STRING(icnt) + ")".

        /* load the log */
        RUN loadLogFile IN ttlogtype.hproc
            (INPUT cFileName, 
             INPUT iDateFmtix,
             INPUT dTimeAdj,
             INPUT cSrcLang,
             INPUT cCodePage,
             INPUT cSrcMsgs,
             INPUT cTrgMsgs,
             INPUT dStartDate,
             INPUT dStartTime,
             INPUT dEndDate,
             INPUT dEndTime,
             OUTPUT /* TABLE-HANDLE */ htt, 
             OUTPUT lLoaded, 
             OUTPUT irows).
        
        IF (lLoaded) THEN
        DO:
            /* create the ttlog to hold the temp table */
            CREATE ttlog.
            ASSIGN 
                ttlog.logid = ilogseq
                ttlog.logfile = cLogName
                ttlog.logtype = cLogType
                ttlog.htt = htt
                ttlog.irows = irows
                ttlog.cdesc = cFileName
                ttlog.idatefmtix = idatefmtix
                ttlog.ccodepage = ccodepage
                /* ttlog.cdatefmt =  */
                ttlog.itimeadj = dtimeadj
                ttlog.csrclang = csrclang
                ttlog.csrcmsgs = csrcmsgs
                ttlog.ctrgmsgs = ctrgmsgs
                ttlog.dStartDate = dStartDate
                ttlog.dStartTime = dStartTime
                ttlog.dEndDate = dEndDate
                ttlog.dEndTime = dEndTime
                ilogseq = ilogseq + 1
                lload = FALSE  /* stop the Open Log dialog re-appearing */
                .
            /* get the date format */
            RUN getDateFormat(idatefmtix,OUTPUT cdatefmt).
            ttlog.cdatefmt = cdatefmt.

            /* adjust the times in the log */
            IF (dtimeadj <> 0) THEN
                RUN adjustLogTimes(htt,?,  
                                   ttlogtype.cmrgflds,dtimeadj).

            /* if the log type's schema is not set, set it now */
            IF NOT valid-handle(ttlogtype.hschema) THEN
            DO TRANSACTION:
                FIND CURRENT ttlogtype EXCLUSIVE-LOCK.
                CREATE TEMP-TABLE hschema IN WIDGET-POOL "logpool".
                hschema:CREATE-LIKE(htt:DEFAULT-BUFFER-HANDLE).
                hschema:TEMP-TABLE-PREPARE(htt:DEFAULT-BUFFER-HANDLE:NAME).
                ttlogtype.hschema = hschema.
                RELEASE ttlogtype.
            END. /* if not valid-handle(ttlogtype.hschema) */

            /* release the log */
            RELEASE ttlog.

            /* re-open the hlogqry */
            RUN refreshLogBrowse.

            /* now open a new viewer for it */
            IF (lOpenBrowse) THEN
              RUN openViewer(cLogName,"true",?).
        END.
        ELSE 
            MESSAGE "Failed to open log " cFileName VIEW-AS ALERT-BOX.
    END. /* if cfilename <> "" */
    ELSE
        lload = FALSE. /* stop the Open Log dialog re-appearing */
    
    END.  /* do while lload */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openViewer C-Win 
PROCEDURE openViewer :
/*------------------------------------------------------------------------------
  Purpose:     Brings up a Log Browse Window for a log file.
  Parameters:  
    cFileName - [IN] log file name to display
    cInitQry  - [IN] initial query to use when opening the log
    hCopyWin  - [IN] existing log browse window to copy window and browse 
                size from
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM cFileName AS CHAR NO-UNDO.
    DEF INPUT PARAM cInitQry AS CHAR NO-UNDO.
    DEF INPUT PARAM hCopyWin AS HANDLE NO-UNDO.

    DEFINE VARIABLE htt AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hproc AS HANDLE     NO-UNDO.
    DEFINE VARIABLE iseq AS INTEGER    INIT 1 NO-UNDO.
    DEFINE VARIABLE ctitle AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE htmpmenu AS HANDLE     NO-UNDO.

    FIND FIRST ttlog WHERE
        ttlog.logfile = cFileName NO-ERROR.
    IF AVAILABLE ttlog THEN
    DO:
        /* find the ttlogtype for this ttlog */
        FIND FIRST ttlogtype NO-LOCK WHERE
            ttlogtype.logtype = ttlog.logtype NO-ERROR.
        IF AVAILABLE ttlogtype THEN hproc = ttlogtype.hproc.
        ELSE
        DO:
            /* could not find, viewer, use unknown */
            FIND FIRST ttlogtype NO-LOCK WHERE
                ttlogtype.loadix = 999 NO-ERROR.
            IF AVAILABLE ttlogtype THEN hproc = ttlogtype.hproc.
        END.
        htt = ttlog.htt.
        FIND LAST ttview NO-LOCK WHERE
            ttview.logfile = cFileName NO-ERROR.
        IF AVAILABLE ttview THEN
        DO:
            ASSIGN 
                iseq = ttview.logseq + 1
                cTitle = cFileName + " - " + STRING(iseq).
                .
        END.
        ELSE 
            cTitle = cFileName.
        CREATE ttview.
        ASSIGN 
            ttview.logfile = cFileName
            ttview.logid = ttlog.logid
            ttview.logseq = iseq
            ttview.logtitle = cTitle.
        
        RUN logread/logbr2.w PERSISTENT SET ttview.hproc
            (INPUT ttlog.htt, 
             INPUT cFileName, 
             INPUT cTitle,
             INPUT cInitQry,
             INPUT ttlog.irows, 
             INPUT hproc,
             INPUT hCopyWin).
             
        IF NOT VALID-HANDLE(ttview.hproc) THEN
        DO:
            DELETE ttview.
            MESSAGE "failed to run browser" VIEW-AS ALERT-BOX.
        END.
        ELSE
        DO:
            /* add to Windows menu ? */
            CREATE MENU-ITEM htmpmenu
                ASSIGN 
                PARENT = hwinmenu
                LABEL = cTitle
                TRIGGERS:
                  ON CHOOSE 
                      PERSISTENT RUN showLogWindow(cTitle).
            END TRIGGERS.

            /* refresh the browe */
            RUN refreshLogBrowse.
        END.
    END.
    ELSE
        MESSAGE "File " cFileName " not loaded" VIEW-AS ALERT-BOX.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshLogBrowse C-Win 
PROCEDURE refreshLogBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Re-opens the query for the Main window's browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  hlogqry:QUERY-OPEN.
  /* refresh the toolbar and menu options as well */
  RUN enableToolbar.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runUtility C-Win 
PROCEDURE runUtility :
/*------------------------------------------------------------------------------
  Purpose:     Runs a utility program
  Parameters:  <none>
  Notes:       Allows user to select utility program, then executes it.
               Utility program must conform to the LogRead Utility API.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cutilname AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cerr AS CHARACTER  NO-UNDO.

  RUN logread/runudlg.w(OUTPUT cutilname,?,OUTPUT lOK).

  IF NOT lOK THEN RETURN.

  RUN value(cutilname) (INPUT ?, INPUT ?,INPUT ghlogutils) NO-ERROR.
  /* check for error status */
  IF ERROR-STATUS:ERROR THEN
  DO:
      DO ictr = 1 TO ERROR-STATUS:NUM-MESSAGES:
          cerr = cerr + ERROR-STATUS:GET-MESSAGE(ictr) + CHR(10).
      END.
      MESSAGE "Error(s) running procedure" cutilname ":" SKIP
          cerr VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setBrowseColWidth C-Win 
PROCEDURE setBrowseColWidth :
/*------------------------------------------------------------------------------
  Purpose:     Sets the column widths and formats for the Main window's browse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hcol AS HANDLE     NO-UNDO.

  IF VALID-HANDLE(hlogbr) THEN
  DO:
      ASSIGN 
          hcol = hlogbr:GET-BROWSE-COLUMN(1)
          hcol:BUFFER-FIELD:FORMAT = "X(255)".
      ASSIGN 
          hcol = hlogbr:GET-BROWSE-COLUMN(2)
          hcol:FORMAT = "X(255)".
      ASSIGN 
          hcol = hlogbr:GET-BROWSE-COLUMN(3)
          hcol:FORMAT = "X(255)".
          .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setHandlerAttribute C-Win 
PROCEDURE setHandlerAttribute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM hhdlr AS HANDLE NO-UNDO.
  DEF INPUT PARAM clogtype AS CHAR NO-UNDO.
  DEF INPUT PARAM cattrname AS CHAR NO-UNDO.
  DEF INPUT PARAM cattrval AS CHAR NO-UNDO.

  IF NOT VALID-HANDLE(hhdlr) AND (clogtype = ? OR clogtype = "") THEN RETURN.

  /* find ttlogtype by handle */
  IF VALID-HANDLE(hhdlr) THEN
      /* find the logtype for this handler */
      FIND FIRST ttlogtype NO-LOCK WHERE 
          ttlogtype.hproc = hhdlr NO-ERROR.
  ELSE
      FIND FIRST ttlogtype NO-LOCK WHERE
          ttlogtype.logtype = clogtype NO-ERROR.
  IF NOT AVAILABLE ttlogtype THEN RETURN.
  FIND FIRST tthdlrattr EXCLUSIVE-LOCK WHERE
      tthdlrattr.hhdlr = ttlogtype.hproc AND
      tthdlrattr.logtype = ttlogtype.logtype AND
      tthdlrattr.attrname = cattrname NO-ERROR.
  IF NOT AVAILABLE tthdlrattr THEN
  DO:
      CREATE tthdlrattr.
      ASSIGN 
          tthdlrattr.hhdlr = ttlogtype.hproc
          tthdlrattr.logtype = ttlogtype.logtype
          tthdlrattr.attrname = cattrname.
  END.
  ASSIGN tthdlrattr.attrval = cattrval.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPseudoTypeSchema C-Win 
PROCEDURE setPseudoTypeSchema :
/*------------------------------------------------------------------------------
  Purpose:     Setsthe schema for a pseudo log type.
  Parameters:  
    clogtype  - [IN] the log type to set the schema for
    hSchema   - [IN] temp-table containing the schema (fields) of the log type
  Notes:       Allows utilities to define extra field information for
               pseudo log types they create.
------------------------------------------------------------------------------*/
   DEF INPUT PARAM clogtype AS CHAR NO-UNDO.
   DEF INPUT PARAM hschema AS HANDLE NO-UNDO.

   /* should also check that htt is a temp-table handle */
   FIND FIRST ttlogtype EXCLUSIVE-LOCK WHERE
       ttlogtype.logtype = clogtype NO-ERROR.
   IF NOT AVAILABLE ttlogtype THEN RETURN.
   ttlogtype.hschema = hschema.
   RELEASE ttlogtype.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showBrowseLogProperties C-Win 
PROCEDURE showBrowseLogProperties PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Displays the properties of the selected log file in the Main 
               window's browse.
  Parameters:  <none>
  Notes:       Calls showLogPropDlg to display the log.
------------------------------------------------------------------------------*/
    
  /* find the log from the browse */
  hlogqry:GET-CURRENT.

  RUN showLogPropDlg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showHandlerInfo C-Win 
PROCEDURE showHandlerInfo :
/*------------------------------------------------------------------------------
  Purpose:     Displays a dialog showing information about a handler
  Parameters:  
    clogtype - [IN] log type to query
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM clogtype AS CHAR NO-UNDO.

    DEFINE VARIABLE cinfo AS CHARACTER  NO-UNDO.

    FIND FIRST ttlogtype NO-LOCK WHERE
        ttlogtype.logtype = clogtype NO-ERROR.
    IF NOT AVAILABLE ttlogtype THEN
    DO:
        MESSAGE "Handler info for Log Type" clogtype "not found"
            VIEW-AS ALERT-BOX.
        RETURN.
    END.
    cInfo = "Log Type: " + clogtype + CHR(10) + 
        "Description: " + ttlogtype.typename + CHR(10) + 
        "Program: " + ttlogtype.hdlrprog + CHR(10) + 
        "Queries: " + ttlogtype.utilqry + CHR(10) + 
        "Utilities: " + ttlogtype.utilfunc + CHR(10) + 
        "Merge Fields: " + ttlogtype.cmrgflds + CHR(10) + 
        "Non-merged Fields: " + ttlogtype.cnomrgflds + CHR(10) + 
        "Hidden Columns: " + ttlogtype.chidcols + CHR(10).
    MESSAGE cinfo VIEW-AS ALERT-BOX TITLE "Properties of " + clogtype + " Handler".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showLogPropDlg C-Win 
PROCEDURE showLogPropDlg PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Displays the log properties dialog for a given log file
  Parameters:  <none>
  Notes:       For a merge log, display the list of files in the merge window.
               For a normal log, displays the properties in the properties window.
               This is a private routine that does the work of displaying
               the properties. It is called from the global API call 
               showLogProperties(clogname) and from the local procedure 
               showBrowseLogProperties.
               This routine requires that the calling procedures have the
               appropriate record in the ttlog buffer.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLogType AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iDateFmtix AS INTEGER    NO-UNDO.
    DEFINE VARIABLE dTimeAdj AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cSrcLang AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSrcMsgs AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTrgMsgs AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lOpenBrowse AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.

  /* find the log type handler for this */
  FIND FIRST ttlogtype NO-LOCK WHERE
      ttlogtype.logtype = ttlog.logtype NO-ERROR.

  /* if a merge, display merge files window */
  IF ttlog.logtype = "MERGE" THEN
  DO:
      /* NOTE: not checking here if the ttlogtype exists or not.
       * It should be available, as we created it programatically. */

      /* populate the ttmrg2 table */
      EMPTY TEMP-TABLE ttmrg2.
      FOR EACH ttmrg NO-LOCK WHERE
          ttmrg.mrgid = ttlog.logid:
          CREATE ttmrg2.
          BUFFER-COPY ttmrg TO ttmrg2.
      END.
      /* call mrgfiles.w */
      RUN logread/mrgfiles.w(INPUT ttlog.logfile,
                             FALSE,
                             INPUT-OUTPUT TABLE ttmrg2,
                             OUTPUT lOK).
      IF lOK THEN
      /* if any adjustment values changed, adjust times in logs */
      FOR EACH ttmrg2 EXCLUSIVE-LOCK:
          FIND FIRST ttmrg EXCLUSIVE-LOCK WHERE
              ttmrg.mrgid = ttmrg2.mrgid AND
              ttmrg.logid = ttmrg2.logid NO-ERROR.
          /* if adjustment amounts are different */
          IF ttmrg2.itimeadj <> ttmrg.itimeadj THEN
          DO:
              /* adjust the time by the difference */
              RUN adjustLogTimes(ttlog.htt,
                                 ttmrg.logorder,
                                 /* hproc?, */
                                 ttlogtype.cmrgflds /* ttmrg.cmrgflds */ ,
                                 ttmrg2.itimeadj - ttmrg.itimeadj).
              /* save the adjustment into ttmrg */
              ttmrg.itimeadj = ttmrg2.itimeadj.
          END.
      END.
      /* empty ttmrg2 */
      EMPTY TEMP-TABLE ttmrg2.
  END.  /* if ttlog.logtype = "MERGE" */
  /* else if a log from a file with a real handler, display log properties */
  ELSE IF AVAILABLE ttlogtype AND ttlogtype.hdlrprog <> "PSEUDO" THEN  
  DO:
      ASSIGN 
          cFileName = ttlog.logfile
          cLogType = ttlog.logtype
          idatefmtix = ttlog.idatefmtix
          dtimeadj = ttlog.itimeadj
          cSrcLang = ttlog.csrclang
          cSrcMsgs = ttlog.csrcmsgs
          cTrgMsgs = ttlog.ctrgmsgs.

    RUN logread/logopen.w ( /* INPUT TABLE ttlogtype,  */
                           INPUT-OUTPUT cFileName,
                            INPUT-OUTPUT cLogType,
                            INPUT-OUTPUT ttlog.idatefmtix,
                            INPUT-OUTPUT dtimeadj,
                            INPUT-OUTPUT ttlog.csrclang,
                            INPUT-OUTPUT ttlog.ccodepage,
                            INPUT-OUTPUT ttlog.csrcmsgs,
                            INPUT-OUTPUT ttlog.ctrgmsgs,
                            INPUT-OUTPUT ttlog.dStartDate,
                            INPUT-OUTPUT ttlog.dStartTime,
                            INPUT-OUTPUT ttlog.dEndDate,
                            INPUT-OUTPUT ttlog.dEndTime,
                            INPUT FALSE,
                            /* INPUT THIS-PROCEDURE, */
                            OUTPUT lOpenBrowse).
      /* if the adjustment time changed, adjust all times in log */
    IF ttlog.itimeadj <> dtimeadj THEN
    DO:
        FIND FIRST ttlogtype NO-LOCK WHERE
            ttlogtype.logtype = ttlog.logtype NO-ERROR.
        IF NOT AVAILABLE ttlogtype THEN
        DO:
            /* error, should not happen */
            RETURN.
        END.
        /* adjust the time by the difference */
        RUN adjustLogTimes(ttlog.htt,
                           ?,
                           ttlogtype.cmrgflds,
                           dtimeadj - ttlog.itimeadj).
        /* save the adjustment into ttlog */
        DO TRANSACTION:
          hlogqry:GET-CURRENT(EXCLUSIVE-LOCK).
          ttlog.itimeadj = dtimeadj.
          RELEASE ttlog.
        END.
    END.

  END. /* if ttlog.logtype <> "merge" */
  ELSE
  DO:
      /* logtype is a pseudo log type, or else is not a valid log type.
       * if this is the case, display what info we have about the log
       * in an alert-box.
       */
      MESSAGE 
          "Log Name    :" ttlog.logfile SKIP
          "Log Type    :" ttlog.logtype 
          (IF AVAILABLE ttlogtype AND ttlogtype.hdlrprog = "PSEUDO" THEN 
              "PSEUDO" ELSE "") SKIP
          "Rows        :" ttlog.irows   SKIP
          "Description :" ttlog.cdesc  
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showLogProperties C-Win 
PROCEDURE showLogProperties :
/*------------------------------------------------------------------------------
  Purpose:     Displays the properties of the log file with name clogfile.
  Parameters:  
    clogfile - [IN] the name of the log file to display
  Notes:       This is part of the LogRead API. It calls showLogPropDlg to
               do the work.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER clogname AS CHAR NO-UNDO.

    FIND FIRST ttlog NO-LOCK WHERE
        ttlog.logfile = clogname NO-ERROR.
    IF AVAILABLE ttlog THEN
        RUN showLogPropDlg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showLogWindow C-Win 
PROCEDURE showLogWindow :
/*------------------------------------------------------------------------------
  Purpose:     Makes a Log Browse window visible.
  Parameters:  
    clogtitle - [IN] title of the log
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM clogTitle AS CHAR NO-UNDO.

  FIND FIRST ttview NO-LOCK WHERE
      ttview.logtitle = clogtitle NO-ERROR.
  IF NOT AVAILABLE ttview THEN
  DO:
      /* this is the trigger procedure for the Window menu.
       * This should always find a ttview
       */
  END.
  ELSE
      RUN makeVisible IN ttview.hproc(TRUE).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showProgressWindow C-Win 
PROCEDURE showProgressWindow :
/*------------------------------------------------------------------------------
  Purpose:     Displays the progress window (progwin.w)
  Parameters:  ctitle - the title of the progress window 
               cmsg - initial message to display in the progress window
  Notes:       This is a rough implementation of a non-modal dialog, 
               typically used for display the progress of loading a log.
               Allows the user to press the cancel button to abort the load.
------------------------------------------------------------------------------*/

  DEF INPUT PARAM ctitle AS CHAR NO-UNDO.
  DEF INPUT PARAM cmsg AS CHAR NO-UNDO.

  /* don't re-display progress window if already running */
  IF VALID-HANDLE(hprogwin) THEN RETURN.

  RUN logread/progwin.w PERSISTENT SET hprogwin(ctitle,cmsg).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unloadHandler C-Win 
PROCEDURE unloadHandler :
/*------------------------------------------------------------------------------
  Purpose:     Unloads an individual log type handler.
  Parameters:  
    clogtype - [IN] the pathname of the log type handler
    cerrmsg  - [OUT] any errors causing unload to fail
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM clogtype AS CHAR NO-UNDO.
    DEF OUTPUT PARAM cerrmsg AS CHAR INIT "" NO-UNDO.

    DEFINE VARIABLE hmnuitem AS HANDLE     NO-UNDO.

    /* make sure this is a valid handler */
    FIND FIRST ttlogtype EXCLUSIVE-LOCK WHERE
        ttlogtype.logtype = clogtype NO-ERROR.
    IF NOT AVAILABLE ttlogtype THEN
    DO:
        cerrmsg = "Log type " + clogtype + " is invalid or not loaded".
        RETURN.
    END.

    /* make sure there are no logs using this handler at the moment */
    FIND FIRST ttlog NO-LOCK WHERE
        ttlog.logtype =clogtype NO-ERROR.
    IF AVAILABLE ttlog THEN
    DO:
        cerrmsg = "Log Type Handler " + clogtype + " is in use".
        RETURN.
    END.

    /* ttlogtype is available, no logs using it. Delete it. */

    /* if a real handler, delete the procedure */
    IF VALID-HANDLE(ttlogtype.hproc) THEN
    DO:
        DELETE PROCEDURE ttlogtype.hproc NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
        DO:
            cerrmsg = "Error unloading handler: " + ERROR-STATUS:GET-MESSAGE(1).
            RETURN.
        END.
    END.
    ELSE
    DO:
        /* this is a pseudo-type.*/
        /* Don't delete the MERGE type */
        IF clogtype = "MERGE" THEN
        DO:
            cerrmsg = "Delete the MERGE log type is not allowed".
            RETURN.
        END.

        /* delete any queries for the log type */
        FOR EACH ttpqry EXCLUSIVE-LOCK WHERE
            ttpqry.logtype = clogtype:
            DELETE ttpqry.
        END.
    END.

    /* now delete the logtype */
    DELETE ttlogtype.

    /* remove it from the Handlers menu - walk the widget tree */
    hmnuitem = hhdlrmenu:FIRST-CHILD.
    DO WHILE (VALID-HANDLE(hmnuitem)) :
        IF hmnuitem:LABEL = clogType THEN
        DO:
            DELETE OBJECT hmnuitem.
            LEAVE.
        END.
        hmnuitem = hmnuitem:NEXT-SIBLING.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateProgressWindow C-Win 
PROCEDURE updateProgressWindow :
/*------------------------------------------------------------------------------
  Purpose:     Updates the progress window.
  Parameters:  cmsg - message to display
  Notes:       The progress window must have been created first, with 
               ShowProgressWindow
------------------------------------------------------------------------------*/

  DEF INPUT PARAM cmsg AS CHAR NO-UNDO.

  IF NOT VALID-HANDLE(hprogwin) THEN RETURN.

  RUN updateMessage IN hprogwin(INPUT cmsg).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

