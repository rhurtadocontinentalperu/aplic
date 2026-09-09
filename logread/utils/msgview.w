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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS imsgno cmsg csrcmsgs bSrcBrowse ctrgmsgs ~
bTrgBrowse cmsgtxt Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS imsgno cmsg csrcmsgs ctrgmsgs cmsgtxt 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bSrcBrowse 
     IMAGE-UP FILE "logread/image/open.bmp":U
     LABEL "" 
     SIZE 5.2 BY 1.05.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON bTrgBrowse 
     IMAGE-UP FILE "logread/image/open.bmp":U
     LABEL "" 
     SIZE 5.2 BY 1.05.

DEFINE VARIABLE cmsg AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 63 BY 3.57 NO-UNDO.

DEFINE VARIABLE cmsgtxt AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 81 BY 5.71 NO-UNDO.

DEFINE VARIABLE csrcmsgs AS CHARACTER FORMAT "X(256)":U 
     LABEL "Source Promsgs" 
     VIEW-AS FILL-IN 
     SIZE 58 BY 1 NO-UNDO.

DEFINE VARIABLE ctrgmsgs AS CHARACTER FORMAT "X(256)":U 
     LABEL "Target Promsgs" 
     VIEW-AS FILL-IN 
     SIZE 58 BY 1 NO-UNDO.

DEFINE VARIABLE imsgno AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Promsg Num" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     imsgno AT ROW 1.24 COL 17 COLON-ALIGNED
     cmsg AT ROW 2.43 COL 19 NO-LABEL
     csrcmsgs AT ROW 6.29 COL 17 COLON-ALIGNED
     bSrcBrowse AT ROW 6.33 COL 77
     ctrgmsgs AT ROW 7.43 COL 17 COLON-ALIGNED
     bTrgBrowse AT ROW 7.43 COL 77
     cmsgtxt AT ROW 8.86 COL 1 NO-LABEL
     Btn_OK AT ROW 14.81 COL 27
     Btn_Cancel AT ROW 14.81 COL 43
     "Promsg Text:" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 2.43 COL 6
     SPACE(63.79) SKIP(12.90)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Promsg Viewer"
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
       cmsgtxt:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Promsg Viewer */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    DEFINE VARIABLE cfile AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lok AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cmsgtmp AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE csrctxt AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE ctrgtxt AS CHARACTER  NO-UNDO.

  ASSIGN
      imsgno
      cmsg
      csrcmsgs
      ctrgmsgs.

  /* validation */
  IF (csrcmsgs <> "") THEN
  DO:
      RUN checkPromsgsFile IN ghlogutils(csrcmsgs,OUTPUT lok).
      IF NOT lok THEN
      DO:
          MESSAGE csrcmsgs "is not a valid promsgs file"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          RETURN.
      END.
  END.

  IF (ctrgmsgs <> "") THEN
  DO:
      RUN checkPromsgsFile IN ghlogutils(ctrgmsgs,OUTPUT lok).
      IF NOT lok THEN
      DO:
          MESSAGE ctrgmsgs "is not a valid promsgs file"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          RETURN.
      END.
  END.
  
  /* if there is no cmsg text, then just display messages in from promsgs file */
  IF (cmsg = "") AND imsgno > 0 THEN
  DO:
      cfile = IF csrcmsgs = "" THEN SEARCH(PROMSGS) ELSE csrcmsgs.
      RUN getPromsgText IN ghlogutils(INPUT cfile,INPUT imsgno,OUTPUT csrctxt).
      cfile = IF ctrgmsgs = "" THEN SEARCH(PROMSGS) ELSE ctrgmsgs.
      RUN getPromsgText IN ghlogutils(INPUT cfile,INPUT imsgno,OUTPUT ctrgtxt).
  END.
  ELSE 
  DO:
      /* ignore any message number, and convert text */
      /* always resolve promsgs */
      ASSIGN 
          csrcmsgs = IF csrcmsgs = "" THEN SEARCH(PROMSGS) ELSE csrcmsgs
          ctrgmsgs = IF ctrgmsgs = "" THEN SEARCH(PROMSGS) ELSE ctrgmsgs
          csrctxt = cmsg.

      RUN getPromsgNum IN ghlogutils(INPUT cmsg,OUTPUT imsgno).
      IF csrcmsgs = ctrgmsgs THEN
          ctrgtxt = cmsg.
      ELSE
      DO:
          RUN translatePromsg IN ghlogutils(INPUT csrctxt,INPUT csrcmsgs, INPUT ctrgmsgs,OUTPUT ctrgtxt).
      END.
      DISPLAY 
          imsgno
          csrcmsgs
          ctrgmsgs
          WITH FRAME {&FRAME-NAME}.
  END.

  cmsgtxt = "Source Message: " + csrctxt + CHR(10) + 
            "Target Message: " + ctrgtxt + CHR(10).

  DISPLAY cmsgtxt WITH FRAME {&FRAME-NAME}.

  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


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
  DISPLAY imsgno cmsg csrcmsgs ctrgmsgs cmsgtxt 
      WITH FRAME Dialog-Frame.
  ENABLE imsgno cmsg csrcmsgs bSrcBrowse ctrgmsgs bTrgBrowse cmsgtxt Btn_OK 
         Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

