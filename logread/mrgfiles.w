&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: logread/mrgfiles.w

  Description: Provides control for merging log files

  Parameters:
      cimrgname - [IN] name of the merge
      lnew      - [IN] whether this is a new or existing merge
      ttmrg     - [IN-OUT] temp-table containing merged log files
      lOK       - [OUT] whether the merge worked successfully or not

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{logread\logmrg.i}

/* Parameters Definitions ---                                           */
DEF INPUT PARAM cimrgname AS CHAR NO-UNDO.
DEF INPUT PARAM lnew AS LOG NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR ttmrg.
DEF OUTPUT PARAM lOK AS LOG INIT FALSE NO-UNDO.

/* help context ids */
{logread/loghelp.i}

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.
DEFINE VARIABLE hbr  AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK bProperties Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS cMrgName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bProperties 
     LABEL "Properties" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE cMrgName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Merge Name" 
      VIEW-AS TEXT 
     SIZE 37 BY .62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 11 COL 22
     bProperties AT ROW 11 COL 38
     Btn_Cancel AT ROW 11 COL 54
     Btn_Help AT ROW 11 COL 70
     cMrgName AT ROW 1.48 COL 13 COLON-ALIGNED
     SPACE(52.99) SKIP(10.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Merge Logs"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cMrgName IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Merge Logs */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bProperties
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bProperties Dialog-Frame
ON CHOOSE OF bProperties IN FRAME Dialog-Frame /* Properties */
DO:
    RUN showLogProperties.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {&LOGREADHELP} {&Merge_Logs_dialog_box} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
  /* validation? */
    lOK = TRUE.
    APPLY 'GO':U TO FRAME Dialog-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* create the browse dynamically */
RUN createBrowse.

ASSIGN cMrgName = cimrgname + "   (" + 
                  (IF lnew THEN "New" ELSE "Existing") + " Merge)".

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowse Dialog-Frame 
PROCEDURE createBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Creates the browse dynamically.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hcol AS HANDLE     NO-UNDO.

  CREATE QUERY hqry.
  hqry:SET-BUFFERS("ttmrg").
  hqry:QUERY-PREPARE("for each ttmrg no-lock").
  hqry:QUERY-OPEN.

  CREATE BROWSE hbr
      ASSIGN 
      FRAME = FRAME Dialog-Frame:HANDLE
      WIDTH-PIXELS  = FRAME Dialog-frame:WIDTH-PIXELS - 
               (FRAME dialog-frame:BORDER-LEFT-PIXELS + FRAME dialog-frame:BORDER-RIGHT-PIXELS)
      HEIGHT = 7.88
      COL = 1
      ROW = 2.57
      QUERY = hqry
      SENSITIVE = TRUE
      READ-ONLY = TRUE
      SEPARATORS = TRUE
      column-resizable = TRUE
      COLUMN-MOVABLE = FALSE
      EXPANDABLE = TRUE
      ROW-MARKERS = FALSE
      TRIGGERS:
        ON DEFAULT-ACTION
            PERSISTENT RUN showLogProperties IN THIS-PROCEDURE.
      END TRIGGERS
      .

  hbr:ADD-COLUMNS-FROM("ttmrg","mrgid,logid,mrgfrom,mrgfromord,htt,cdesc,idatefmtix,cdatefmt,ctimeadj,ccodepage,csrclang,csrcmsgs,ctrgmsgs,dstartdate,dstarttime,denddate,dendtime,cmrgflds,cnomrgflds,ccommon,cprivate").
  /* logfile name */
  ASSIGN 
      hcol = hbr:GET-BROWSE-COLUMN(2)
      hcol:WIDTH-CHARS = 50.
  /* logtype */
  ASSIGN 
      hcol = hbr:GET-BROWSE-COLUMN(3)
      hcol:WIDTH-CHARS = 15.
  hbr:VISIBLE = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY cMrgName 
      WITH FRAME Dialog-Frame.
  ENABLE Btn_OK bProperties Btn_Cancel Btn_Help 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showLogProperties Dialog-Frame 
PROCEDURE showLogProperties :
/*------------------------------------------------------------------------------
  Purpose:     Displays the properties for an individual log, that is 
               participating in this merge.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lopenbrowse AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE dtimeadj AS DECIMAL    NO-UNDO.

    /* find the currently selected row */
    hqry:GET-CURRENT.
    dtimeadj = ttmrg.itimeadj.

    /* open the log properties window */
    RUN logread/logopen.w ( /* INPUT TABLE ttlogtype, */
                            INPUT-OUTPUT ttmrg.logfile,
                            INPUT-OUTPUT ttmrg.logtype,
                            INPUT-OUTPUT ttmrg.idatefmtix,
                            INPUT-OUTPUT dtimeadj,
                            INPUT-OUTPUT ttmrg.csrclang,
                            INPUT-OUTPUT ttmrg.ccodepage,
                            INPUT-OUTPUT ttmrg.csrcmsgs,
                            INPUT-OUTPUT ttmrg.ctrgmsgs,
                            INPUT-OUTPUT ttmrg.dStartDate,
                            INPUT-OUTPUT ttmrg.dStartTime,
                            INPUT-OUTPUT ttmrg.dEndDate,
                            INPUT-OUTPUT ttmrg.dEndTime,
                            INPUT FALSE,
                            /* INPUT THIS-PROCEDURE, */
                            OUTPUT lOpenBrowse).
    /* update the ttmrg record */
    IF dtimeadj <> ttmrg.itimeadj THEN
    DO TRANSACTION:
        hqry:GET-CURRENT(EXCLUSIVE-LOCK).
        ttmrg.itimeadj = dtimeadj.
        RELEASE ttmrg.
    END.
    /* refresh the browse */
    hbr:REFRESH().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

