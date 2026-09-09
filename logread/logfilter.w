&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: logread/logfilter.w

  Description: The Log Filter dialog, allowing users to select and sort 
               records within a log file temp-table, using 4GL query syntax.

  Parameters:
    cWhere - [IN-OUT] query text
    htt    - [IN] log file temp-table
    hproc  - [IN] handle of the log type handler
    cfilename - [IN] name of log
    lOK    - [OUT] returns TRUE if the user clicked OK, and the query was valid.

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF INPUT-OUTPUT PARAM cWhere AS CHAR NO-UNDO.
DEF INPUT PARAMETER htt AS HANDLE NO-UNDO.
DEF INPUT PARAM hproc AS HANDLE NO-UNDO.  /* handler proc */
DEF INPUT PARAM cFileName AS CHAR NO-UNDO.  
DEF OUTPUT PARAM lOK AS LOG INIT NO NO-UNDO.

/* globals */
{logread/logglob.i}

/* help context ids */
{logread/loghelp.i}

/* Local Variable Definitions ---                                       */
{logread/qryval.i FALSE }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cFlds cqry Btn_OK bValidate bDefault ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS cFlds cqry 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bDefault 
     LABEL "Default" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
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
     SIZE 63 BY 5.48 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     cFlds AT ROW 1.95 COL 2 NO-LABEL
     cqry AT ROW 7.91 COL 2 NO-LABEL
     Btn_OK AT ROW 13.62 COL 2
     bValidate AT ROW 13.62 COL 18
     bDefault AT ROW 13.62 COL 34
     Btn_Cancel AT ROW 13.62 COL 50
     "Columns:" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 1.24 COL 2
     "Query Text (4GL Syntax):" VIEW-AS TEXT
          SIZE 26 BY .62 AT ROW 7.19 COL 2
     SPACE(37.79) SKIP(7.04)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Log Filter"
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

ASSIGN 
       cFlds:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON HELP OF FRAME Dialog-Frame /* Log Filter */
DO:
  {&LOGREADHELP} {&Log_Filter_dialog_box} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Log Filter */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bDefault
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bDefault Dialog-Frame
ON CHOOSE OF bDefault IN FRAME Dialog-Frame /* Default */
DO:
  /* cqry:SCREEN-VALUE = "". */
    DEFINE VARIABLE cdefqry AS CHARACTER INIT ? NO-UNDO.
    /* in case of a pseudo-type, hproc is invalid, so check for that */
    IF VALID-HANDLE(hproc) THEN
    DO:
        /* this is a handler. Get the default query from the handler */
        IF CAN-DO(hproc:INTERNAL-ENTRIES,"getQuery") THEN
            RUN getQuery IN hproc("Default",OUTPUT cdefqry).
        ELSE
            cdefqry = "".
    END.
    ELSE 
    DO:
        /* this is a pseudo-type. Find the default filter of the pseudo-type */
        RUN getPseudoTypeQuery IN ghlogutils("Default",cFileName,OUTPUT cdefqry).
    END.
    IF cdefqry <> ? THEN
        cqry:SCREEN-VALUE = cdefqry.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    DEFINE VARIABLE lqOK AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cerrtxt AS CHARACTER  NO-UNDO.

  ASSIGN cqry.

  RUN validateQuery(INPUT htt, INPUT cqry,OUTPUT lqOK, OUTPUT cerrtxt).
  IF NOT lqOK THEN
  DO:
      MESSAGE cerrtxt VIEW-AS ALERT-BOX ERROR.
      lOK = FALSE.
      RETURN NO-APPLY.
  END.

    ASSIGN 
        cWhere = cleanQuery(cqry).
        lOK = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bValidate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bValidate Dialog-Frame
ON CHOOSE OF bValidate IN FRAME Dialog-Frame /* Validate */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

cQry = cWhere.
RUN populateFldList.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  APPLY 'entry':U TO cqry.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  DISPLAY cFlds cqry 
      WITH FRAME Dialog-Frame.
  ENABLE cFlds cqry Btn_OK bValidate bDefault Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateFldList Dialog-Frame 
PROCEDURE populateFldList :
/*------------------------------------------------------------------------------
  Purpose:     Display the list of fields from the table in the Columns editor
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

