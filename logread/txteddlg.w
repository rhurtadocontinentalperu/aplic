&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: logread/txteddlg.w

  Description: Utility routine for displaying text in a dialog, within 
               a scrolling editor widget, so that user can cut and
               paste the text.

  Parameters:
      ctext - [IN] Text to be displayed. Lines are separated by CHR(10)
      irows - [IN] Number of rows to set the window to. Can be ?
      icols - [IN] Number of columns to set the window to. Can be ?
      ctitle - [IN] Title of the window.

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

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

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cEdit bOK 
&Scoped-Define DISPLAYED-OBJECTS cEdit 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bOK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE cEdit AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 64 BY 9.76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     cEdit AT ROW 1 COL 1 NO-LABEL
     bOK AT ROW 11 COL 26
     SPACE(24.13) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Editor Dialog"
         DEFAULT-BUTTON bOK.


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
       cEdit:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Editor Dialog */
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

/* if either rows or columns are not unknown, then use these dimensions.
 * Otherwise, guess dimensions from the text passed */
IF (irows <> ? OR icols <> ?) THEN
    RUN resizeWindow(irows,icols).
ELSE
    RUN resizeWindowForText(cText).

cEdit = cText.

FRAME dialog-frame:TITLE = ctitle.

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
  DISPLAY cEdit 
      WITH FRAME Dialog-Frame.
  ENABLE cEdit bOK 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWindow Dialog-Frame 
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
  
  DO /* WITH FRAME Dialog-frame */ :
      IF (iprow <> ?) THEN
      DO:
          ASSIGN 
              dspchc = FRAME dialog-frame:HEIGHT-PIXELS - bOK:Y
              dspchp = FRAME dialog-frame:HEIGHT-PIXELS - (cedit:HEIGHT-PIXELS + cedit:X)
              .
          ASSIGN 
              cEdit:HEIGHT-CHARS = iprow
              FRAME Dialog-frame:HEIGHT-PIXELS = cedit:HEIGHT-PIXELS + dspchp
              bOK:Y = FRAME dialog-frame:HEIGHT-PIXELS - dspchc 
              .
      END.
      IF (ipcol <> ?) THEN
      DO:
          ASSIGN 
              cedit:WIDTH-CHARS = ipcol
              FRAME dialog-frame:WIDTH-CHARS = ipcol
              FRAME dialog-frame:WIDTH-PIXELS = cEdit:WIDTH-PIXELS +
                  (FRAME dialog-frame:BORDER-LEFT-PIXELS + 
                   FRAME dialog-frame:BORDER-RIGHT-PIXELS)
              bok:COLUMN = (FRAME dialog-frame:WIDTH-CHARS - bok:WIDTH-CHARS) / 2.
      END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWindowForText Dialog-Frame 
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
      dwincol = FRAME dialog-frame:WIDTH-CHARS
      dwinrow = FRAME dialog-frame:HEIGHT-CHARS.

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

