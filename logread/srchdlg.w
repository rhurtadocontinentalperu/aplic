&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: logread/srchdlg.w

  Description: Provides the Searh Dialog for the Log Browse Window

  Parameters:
    hproc - [IN] handle to the log browse window that called this dialog
    htt   - [IN] handle to temp-table of the log file.

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

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEF INPUT PARAM hproc AS HANDLE NO-UNDO.  /* log browse handle */
DEF INPUT PARAM htt AS HANDLE NO-UNDO.    /* log tt handle */

/* help context ids */
{logread/loghelp.i}

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE clastqry AS CHARACTER  NO-UNDO.

{logread/qryval.i TRUE }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cFlds cqry lDir bNext bValidate bCancel 
&Scoped-Define DISPLAYED-OBJECTS cFlds cqry lDir 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bCancel 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON bNext 
     LABEL "Find Next" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON bValidate 
     LABEL "Validate" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cFlds AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 63 BY 5 NO-UNDO.

DEFINE VARIABLE cqry AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 63 BY 4.29 NO-UNDO.

DEFINE VARIABLE lDir AS LOGICAL 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Up", yes,
"Down", no
     SIZE 24 BY 1.1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     cFlds AT ROW 1.95 COL 2 NO-LABEL
     cqry AT ROW 7.91 COL 2 NO-LABEL
     lDir AT ROW 12.24 COL 15 NO-LABEL
     bNext AT ROW 13.62 COL 2
     bValidate AT ROW 13.62 COL 18
     bCancel AT ROW 13.62 COL 50
     "Search Criteria (4GL Syntax):" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 7.19 COL 2
     "Direction:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 12.48 COL 3
     "Columns:" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 1.24 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 64.8 BY 13.86
         DEFAULT-BUTTON bNext.


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
         TITLE              = "Search"
         HEIGHT             = 13.86
         WIDTH              = 64.8
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
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
ASSIGN 
       cFlds:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Search */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Search */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DEFAULT-FRAME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DEFAULT-FRAME C-Win
ON HELP OF FRAME DEFAULT-FRAME
DO:
  {&LOGREADHELP} {&Search_dialog_box}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bCancel C-Win
ON CHOOSE OF bCancel IN FRAME DEFAULT-FRAME /* Cancel */
DO:
    /* hide the search window */
    RUN showWindow(FALSE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bNext C-Win
ON CHOOSE OF bNext IN FRAME DEFAULT-FRAME /* Find Next */
DO:
    DEFINE VARIABLE lqOK AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cerrtxt AS CHARACTER  NO-UNDO.
    
    ASSIGN cqry ldir.
    cqry = cleanQuery(cqry).

    /* validation only if query has changed */
    IF cqry <> clastqry THEN
    DO:
        RUN validateQuery(INPUT htt, INPUT cqry,OUTPUT lqOK, OUTPUT cerrtxt).
        IF NOT lqOK THEN
        DO:
            MESSAGE cerrtxt VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        clastqry = cqry.
    END.

    RUN searchNext IN hproc(cqry,ldir).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bValidate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bValidate C-Win
ON CHOOSE OF bValidate IN FRAME DEFAULT-FRAME /* Validate */
DO:
    DEFINE VARIABLE lqOK AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cerrtxt AS CHARACTER  NO-UNDO.

ASSIGN cqry.

RUN validateQuery(INPUT htt, INPUT cqry,OUTPUT lqOK, OUTPUT cerrtxt).

IF NOT lqOK THEN
    MESSAGE cerrtxt VIEW-AS ALERT-BOX ERROR.
ELSE
    MESSAGE "Syntax is correct" VIEW-AS ALERT-BOX.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

RUN populateFldList.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  APPLY 'entry':U TO cqry IN FRAME {&FRAME-NAME}.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  DISPLAY cFlds cqry lDir 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE cFlds cqry lDir bNext bValidate bCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateFldList C-Win 
PROCEDURE populateFldList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
DEFINE VARIABLE ifld  AS INTEGER    NO-UNDO.

  hbuf = htt:DEFAULT-BUFFER-HANDLE.
  DO ifld = 1 TO hbuf:NUM-FIELDS:
      ASSIGN 
          hfld = hbuf:BUFFER-FIELD(ifld)
          cFlds = cFlds + hfld:NAME + " (" + 
                  hfld:DATA-TYPE + ")~n".
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showWindow C-Win 
PROCEDURE showWindow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM lShow AS LOGICAL NO-UNDO.

    IF (lShow) THEN
    DO:
        /* restore the window */
        c-win:VISIBLE = TRUE.
        /* bring to the top */
        c-win:MOVE-TO-TOP().
    END.
    ELSE
        /* hide the window */
        c-win:VISIBLE = FALSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

