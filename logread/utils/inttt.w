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
DEF INPUT PARAM htt AS HANDLE NO-UNDO.
DEF INPUT PARAM hview AS HANDLE NO-UNDO.
DEF INPUT PARAM ghlogutils AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE httlogs AS HANDLE     NO-UNDO.
DEFINE VARIABLE hbr AS HANDLE     NO-UNDO.
DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.
DEFINE VARIABLE hframe AS HANDLE     NO-UNDO.
DEFINE VARIABLE hwin AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_Cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_Cancel AT ROW 11 COL 24
     SPACE(26.13) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Internal Temp-Tables"
         CANCEL-BUTTON Btn_Cancel.


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
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Internal Temp-Tables */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

RUN buildUI.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildUI Dialog-Frame 
PROCEDURE buildUI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ifld AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hcol AS HANDLE     NO-UNDO.

  ASSIGN 
      hframe = FRAME {&FRAME-NAME}:HANDLE.

  /* get ttinternal */
  RUN getInternalTT IN ghlogutils("ttinternal",OUTPUT httlogs).

  hbuf = httlogs:DEFAULT-BUFFER-HANDLE.

  /* create the query */
  CREATE QUERY hqry.
  hqry:SET-BUFFERS(hbuf).
  hqry:QUERY-PREPARE("for each " + hbuf:NAME + " no-lock").
  hqry:QUERY-OPEN.

  /* create the browse */
  CREATE BROWSE hbr
      ASSIGN 
      FRAME = hframe
      COL = 1.00
      ROW = 1.00 
      WIDTH-PIXELS = hframe:WIDTH-PIXELS - (hframe:BORDER-LEFT-PIXELS + hframe:BORDER-RIGHT-PIXELS)
      HEIGHT-CHARS = 9.5
      QUERY = hqry
      VISIBLE = FALSE
      SENSITIVE = TRUE
      READ-ONLY = FALSE
      SEPARATORS = TRUE
      COLUMN-RESIZABLE = TRUE
      COLUMN-MOVABLE = FALSE
      EXPANDABLE = FALSE
      ROW-MARKERS = FALSE
      MULTIPLE = TRUE
      TRIGGERS:
        ON DEFAULT-ACTION
            PERSISTENT RUN exposeTT IN THIS-PROCEDURE.
      END TRIGGERS
      .
    DO ifld = 1 TO hbuf:NUM-FIELDS:
        hcol = hbr:ADD-LIKE-COLUMN(hbuf:BUFFER-FIELD(ifld),ifld).
    END.

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
  ENABLE Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exposeTT Dialog-Frame 
PROCEDURE exposeTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE irow AS INTEGER    NO-UNDO.
  DEFINE VARIABLE htt AS HANDLE     NO-UNDO.
  DO irow = 1 TO hbr:NUM-SELECTED-ROWS:
      hbr:FETCH-SELECTED-ROW(irow).
      RUN exposeInternalTT IN ghlogutils(hbuf:BUFFER-FIELD("ttname"):BUFFER-VALUE,OUTPUT htt).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

