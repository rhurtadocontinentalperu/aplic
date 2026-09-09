&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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
DEF INPUT PARAM ctext AS CHAR NO-UNDO.
DEF INPUT PARAM irows AS INT NO-UNDO.
DEF INPUT PARAM icols AS INT NO-UNDO.
DEF INPUT PARAM ctitle AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cEdit bOK 
&Scoped-Define DISPLAYED-OBJECTS cEdit 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bOK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE cEdit AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 64 BY 9.76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     cEdit AT ROW 1 COL 1 NO-LABEL
     bOK AT ROW 11 COL 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 64.2 BY 11.24.


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
         TITLE              = "Editor Window"
         HEIGHT             = 11.24
         WIDTH              = 64.2
         MAX-HEIGHT         = 80
         MAX-WIDTH          = 320
         VIRTUAL-HEIGHT     = 80
         VIRTUAL-WIDTH      = 320
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
       cEdit:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Editor Window */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Editor Window */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bOK C-Win
ON CHOOSE OF bOK IN FRAME DEFAULT-FRAME /* OK */
DO:
  APPLY 'CLOSE':U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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

/* if either rows or columns are not unknown, then use these dimensions.
 * Otherwise, guess dimensions from the text passed */
IF (irows <> ? OR icols <> ?) THEN
    RUN resizeWindow(irows,icols).
ELSE
    RUN resizeWindowForText(cText).

ASSIGN
    cEdit = cText
    C-Win:TITLE = ctitle.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
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
  DISPLAY cEdit 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE cEdit bOK 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWindow C-Win 
PROCEDURE resizeWindow :
/*------------------------------------------------------------------------------
  Purpose:     Resize the windows based on the passed row and column sizes
  Parameters:  
    iprow - [IN] number of rows to set the editor to. May be ?
    ipcol - [IN] number of cols to set the editor to. May be ?
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM iprow AS DEC NO-UNDO.
  DEF INPUT PARAM ipcol AS DEC NO-UNDO.

  DEFINE VARIABLE dbutpy AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dbutcy AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dspchc AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dspchp AS DECIMAL    NO-UNDO.

  /* if both rows and col are ?, then just return */
  IF iprow = ? AND ipcol = ? THEN RETURN.

  /* if the dimensions are too small, don't resize */
  IF (iprow < 1) OR (ipcol < 20) THEN RETURN.
  
  /* if the dimensions are too big, limit them */
  IF (ipcol > 300) THEN
      ipcol = 300.
  
  DO /* WITH FRAME default-frame */ :
      IF (iprow <> ?) THEN
      DO:
          ASSIGN 
              dspchc = FRAME default-frame:HEIGHT-PIXELS - bOK:Y
              dspchp = FRAME default-frame:HEIGHT-PIXELS - (cedit:HEIGHT-PIXELS + cedit:X)
              .
          ASSIGN 
              cEdit:HEIGHT-CHARS = iprow
              FRAME default-frame:HEIGHT-PIXELS = cedit:HEIGHT-PIXELS + dspchp
              bOK:Y = FRAME default-frame:HEIGHT-PIXELS - dspchc /* bok:HEIGHT-CHARS */
              c-win:HEIGHT-PIXELS = FRAME default-frame:HEIGHT-PIXELS.
      END.
      IF (ipcol <> ?) THEN
      DO:
          ASSIGN 
              cedit:WIDTH-CHARS = ipcol
              FRAME default-frame:WIDTH-CHARS = ipcol
              FRAME default-frame:WIDTH-PIXELS = cEdit:WIDTH-PIXELS +
                  (FRAME default-frame:BORDER-LEFT-PIXELS + 
                   FRAME default-frame:BORDER-RIGHT-PIXELS)
              bok:COLUMN = (FRAME default-frame:WIDTH-CHARS - bok:WIDTH-CHARS) / 2
              c-win:WIDTH-PIXELS = FRAME default-frame:WIDTH-PIXELS.
      END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWindowForText C-Win 
PROCEDURE resizeWindowForText :
/*------------------------------------------------------------------------------
  Purpose:     Resize the window based on the number of lines and max chars per 
               line in the text. Lines end with CHR(10).
  Parameters:  cptext - [IN] Text to display
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cptext AS CHAR NO-UNDO.

  DEFINE VARIABLE irow AS INTEGER    NO-UNDO.
  DEFINE VARIABLE icol AS INTEGER    NO-UNDO.
  DEFINE VARIABLE icnt AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cline AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dwincol AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dwinrow AS DECIMAL    NO-UNDO.

  IF (cptext = ?) THEN RETURN.

  ASSIGN 
      dwincol = FRAME default-frame:WIDTH-CHARS
      dwinrow = FRAME default-frame:HEIGHT-CHARS.

  irow = NUM-ENTRIES(cptext,CHR(10)).
  DO icnt = 1 TO irow:
      cline = ENTRY(icnt,cptext,CHR(10)).
      IF (LENGTH(cline) > icol) THEN
          icol = LENGTH(cline).
  END.

  RUN resizeWindow(
          (IF irow < dwinrow THEN ? ELSE irow),
          (IF icol < dwincol THEN ? ELSE icol)).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

