&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF INPUT PARAMETER htt AS HANDLE NO-UNDO.
DEF INPUT PARAMETER hproc AS HANDLE NO-UNDO.
DEF INPUT PARAMETER ghlogutils AS HANDLE NO-UNDO.

/* include definition for shared temp table ttlogtype */
{logread/logtype.i }

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hbr AS HANDLE     NO-UNDO.
DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bLoad bPseudo bPsQuery bProperties bUnload ~
bCancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bCancel 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bLoad 
     LABEL "Load Handler" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bProperties 
     LABEL "Handler Info" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bPseudo 
     LABEL "Add Pseudo" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bPsQuery 
     LABEL "Add Query" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bUnload 
     LABEL "Unload" 
     SIZE 15 BY 1.14.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     bLoad AT ROW 10.52 COL 2
     bPseudo AT ROW 10.52 COL 18
     bPsQuery AT ROW 10.52 COL 34
     bProperties AT ROW 10.52 COL 50
     bUnload AT ROW 10.52 COL 66
     bCancel AT ROW 10.52 COL 82
     "Handlers:" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 1.24 COL 2
     SPACE(85.19) SKIP(9.89)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Handler Control Utility".


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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Handler Control Utility */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bCancel Dialog-Frame
ON CHOOSE OF bCancel IN FRAME Dialog-Frame /* Cancel */
DO:
  APPLY 'GO' TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bLoad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bLoad Dialog-Frame
ON CHOOSE OF bLoad IN FRAME Dialog-Frame /* Load Handler */
DO:
  RUN loadHandler.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bProperties
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bProperties Dialog-Frame
ON CHOOSE OF bProperties IN FRAME Dialog-Frame /* Handler Info */
DO:
  RUN showHandlerProperties.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bPseudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bPseudo Dialog-Frame
ON CHOOSE OF bPseudo IN FRAME Dialog-Frame /* Add Pseudo */
DO:
  DEFINE VARIABLE clogtype AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ctypename AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE chidcols AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cmrgflds AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cnomrgflds AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.

  RUN logread/utils/hdlrctl-as.w
      (OUTPUT clogtype,
       output ctypename,
       OUTPUT chidcols,
       OUTPUT cmrgflds,
       OUTPUT cnomrgflds,
       OUTPUT lOK).

  IF (NOT lOK) THEN
      RETURN.

  RUN addPseudoType IN ghlogutils (clogtype, ctypename,chidcols,cmrgflds,cnomrgflds).

  /* refresh the browse */
  hqry:QUERY-OPEN().

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bPsQuery
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bPsQuery Dialog-Frame
ON CHOOSE OF bPsQuery IN FRAME Dialog-Frame /* Add Query */
DO:
    DEFINE VARIABLE cqryid AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cqrytxt AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lok AS LOGICAL    NO-UNDO.

    hqry:GET-CURRENT().

    RUN logread/utils/hdlrctl-asq.w(
        INPUT ttlogtype.logtype,
        OUTPUT cqryid,
        OUTPUT cqrytxt,
        OUTPUT lOK).
    IF NOT lOK THEN
        RETURN.
    RUN addPseudoTypeQuery IN ghlogutils(ttlogtype.logtype,cqryid,cqrytxt).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bUnload
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bUnload Dialog-Frame
ON CHOOSE OF bUnload IN FRAME Dialog-Frame /* Unload */
DO:
  RUN unloadHandler.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

RUN createBrowser.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowser Dialog-Frame 
PROCEDURE createBrowser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hcol AS HANDLE     NO-UNDO.

  CREATE QUERY hqry.
  hqry:SET-BUFFERS("ttlogtype").
  hqry:QUERY-PREPARE("for each ttlogtype no-lock").
  hqry:QUERY-OPEN.

  CREATE BROWSE hbr ASSIGN 
      FRAME = FRAME {&FRAME-NAME}:HANDLE
      COL = 1.0
      ROW = 1.95
      WIDTH = 96
      HEIGHT = 8.33
      QUERY = hqry
      SENSITIVE = TRUE
      READ-ONLY = FALSE
      SEPARATORS = TRUE
      COLUMN-RESIZABLE = TRUE
      COLUMN-MOVABLE = FALSE
      EXPANDABLE = FALSE
      ROW-MARKERS = FALSE
      MULTIPLE = FALSE
      TRIGGERS:
        ON value-changed
            PERSISTENT RUN enableButtons.
        ON DEFAULT-ACTION
            PERSISTENT RUN showHandlerProperties.
      END TRIGGERS
      .

  /* hbr:ADD-COLUMNS-FROM("ttlogtype","hproc,hschema,utilfunc,utilqry,guesstype,chidcols,cmrgflds,cnomrgflds"). */
  hbr:ADD-LIKE-COLUMN("ttlogtype.loadix").
  hbr:ADD-LIKE-COLUMN("ttlogtype.logtype").
  hbr:ADD-LIKE-COLUMN("ttlogtype.typename").
  hbr:ADD-LIKE-COLUMN("ttlogtype.hdlrprog").

  ASSIGN 
      hcol = hbr:GET-BROWSE-COLUMN(4)
      hcol:WIDTH-CHARS = 49
      .
  /*
  ASSIGN 
      hcol = hlogbr:GET-BROWSE-COLUMN(2)
      hcol:WIDTH-CHARS = 15
      .
  ASSIGN 
      hcol = hlogbr:GET-BROWSE-COLUMN(3)
      hcol:LABEL = "# Rows"
      hcol:WIDTH-CHARS = 11.5
      .
  */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableButtons Dialog-Frame 
PROCEDURE enableButtons :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE isel AS INTEGER    NO-UNDO.
   DEFINE VARIABLE lsel AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lpseudo AS LOGICAL INIT NO NO-UNDO.
   DEFINE VARIABLE lmerge AS LOGICAL INIT NO NO-UNDO.


   /* indicate selected if number of selected rows is 1 */
   lsel = (IF hbr:NUM-SELECTED-ROWS = 1 THEN TRUE ELSE FALSE).

   /* if there is 1 selected row, and the row is a pseudo type,
    * allow adding queries */
   IF (lsel) THEN
   DO:
       hqry:GET-CURRENT.

       IF NOT VALID-HANDLE(ttlogtype.hproc) THEN
           lpseudo = TRUE.

       /* if the merge handler, disallow anything */
       IF (ttlogtype.logtype = "MERGE") THEN
           ASSIGN 
               lmerge = TRUE
               lpseudo = FALSE.
   END.

   DO WITH FRAME {&FRAME-NAME}:
       ASSIGN 
           bLoad:SENSITIVE = TRUE
           bPseudo:SENSITIVE = TRUE
           bPsQuery:SENSITIVE = lpseudo
           bProperties:SENSITIVE = lsel
           /* unload only if selected AND NOT THE MERGE log type */
           bUnload:SENSITIVE = 
               (IF lsel AND NOT lmerge THEN TRUE ELSE FALSE)
           bCancel:SENSITIVE = TRUE.
   END.
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
  ENABLE bLoad bPseudo bPsQuery bProperties bUnload bCancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadHandler Dialog-Frame 
PROCEDURE loadHandler :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chdlrprog AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cerr AS CHARACTER  NO-UNDO.

  RUN logread/runudlg.w(OUTPUT chdlrprog,"Load Custom Handler",OUTPUT lOK).

  IF NOT lOK THEN RETURN.

  /* no error checking here. Just run loadHandler, and see what happens */
  RUN loadHandler IN ghlogutils(chdlrprog) NO-ERROR.

  /* refresh the browse */
  hqry:QUERY-OPEN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showHandlerProperties Dialog-Frame 
PROCEDURE showHandlerProperties :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  hqry:GET-CURRENT.

  RUN showHandlerInfo IN ghlogutils(ttlogtype.logtype).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unloadHandler Dialog-Frame 
PROCEDURE unloadHandler :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cerrmsg AS CHARACTER  NO-UNDO.

  hqry:GET-CURRENT.

  RUN unloadHandler IN ghlogutils(ttlogtype.logtype, OUTPUT cerrmsg).

  IF cerrmsg <> "" THEN
      MESSAGE cerrmsg
          VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Unload failed".

  /* refresh the browse */
  hqry:QUERY-OPEN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

