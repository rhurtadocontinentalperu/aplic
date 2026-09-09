&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: logread/coldlg.w

  Description: Displays the Column dialog, to allow users to select the 
               columns to display or hide in the Log Browse Window

  Parameters:
    hbr    - [IN] handle of the Log Browse Window's browse widget
    ctitle - [IN] title of the window

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* help ids */
{logread/loghelp.i}

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER hbuf AS HANDLE     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER ccols AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER ctitle AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */
CREATE WIDGET-POOL "toggles".

DEFINE VARIABLE hfirsttog AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bOK bCancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON bOK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     bOK AT ROW 11 COL 5
     bCancel AT ROW 11 COL 21
     SPACE(4.79) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "<insert dialog title>"
         DEFAULT-BUTTON bOK CANCEL-BUTTON bCancel.


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
ON HELP OF FRAME Dialog-Frame /* <insert dialog title> */
DO:
  {&LOGREADHELP} {&Columns_dialog_box} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* <insert dialog title> */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bOK Dialog-Frame
ON CHOOSE OF bOK IN FRAME Dialog-Frame /* OK */
DO:
    DEFINE VARIABLE icnt AS INTEGER    NO-UNDO.
    DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
    DEFINE VARIABLE htog AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cnewcols AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lfirst AS LOGICAL INIT YES   NO-UNDO.

    htog = hfirsttog.

    /* walk through widgets from htog
     * this assumes that the widgets are added as siblings of hfirsttog,
     * and they are added to the chain of siblings after hfirsttog */
    DO WHILE (VALID-HANDLE(htog)):
        IF (htog:TYPE = "TOGGLE-BOX") THEN
        DO:
            IF htog:CHECKED THEN
                ASSIGN 
                    cnewcols = cnewcols + (IF NOT lfirst THEN "," ELSE "") + 
                               htog:NAME
                    lfirst = FALSE.
        END.
        htog = htog:NEXT-SIBLING.
    END.

    ccols = cnewcols.

    APPLY "GO" TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

RUN createColToggles.
FRAME Dialog-Frame:TITLE = cTitle.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.
DELETE WIDGET-POOL "toggles".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createColToggles Dialog-Frame 
PROCEDURE createColToggles :
/*------------------------------------------------------------------------------
  Purpose:     Create dynamic toggle-box widgets for each column, in columns
               of 10 columns each.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE icnt AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE irow AS INTEGER    NO-UNDO.
  DEFINE VARIABLE icol AS INTEGER    NO-UNDO.
  DEFINE VARIABLE icolwidth AS INTEGER    NO-UNDO.
  DEFINE VARIABLE htog AS HANDLE     NO-UNDO.

  ASSIGN 
      irow = 0
      icol = 2
      icolwidth = 0.
  DO icnt = 1 TO hbuf:NUM-FIELDS:
      hfld = hbuf:BUFFER-FIELD(icnt).
      irow = irow + 1.
      IF (irow > 10) THEN
          ASSIGN 
              irow = 1
              icol = icol + icolwidth.
      CREATE TOGGLE-BOX htog IN WIDGET-POOL "toggles"
          ASSIGN 
            FRAME = FRAME Dialog-Frame:HANDLE
            NAME = hfld:NAME
            LABEL = hfld:NAME
            CHECKED = CAN-DO(ccols,hfld:NAME)
            SENSITIVE = TRUE
            ROW = irow
            COLUMN = icol.
      ASSIGN 
          icolwidth = (IF icolwidth < htog:WIDTH-CHARS THEN htog:WIDTH-CHARS ELSE icolwidth).
      IF (icnt = 1) THEN
          hfirsttog = htog.
  END.

  /* have to change the size of the Frame as well? */
  icol = icol + icolwidth + 2.
  IF (icol > FRAME Dialog-frame:WIDTH-CHARS) THEN
      ASSIGN 
        FRAME dialog-frame:WIDTH-CHARS = icol.

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
  ENABLE bOK bCancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

