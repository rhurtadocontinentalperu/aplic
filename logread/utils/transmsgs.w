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

/* return now if htt is not valid */
IF NOT VALID-HANDLE(htt) THEN
DO :
    MESSAGE "You must call this utility from the Log Browse window"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cSrcMsgs bSrcBrowse cTrgMsgs bTrgBrowse ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS cSrcMsgs cTrgMsgs 

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
     SIZE 5 BY 1.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON bTrgBrowse 
     IMAGE-UP FILE "logread/image/open.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE VARIABLE cSrcMsgs AS CHARACTER FORMAT "X(256)":U 
     LABEL "Source Promsgs" 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE cTrgMsgs AS CHARACTER FORMAT "X(256)":U 
     LABEL "Target Promsgs" 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     cSrcMsgs AT ROW 1.24 COL 17 COLON-ALIGNED
     bSrcBrowse AT ROW 1.24 COL 76
     cTrgMsgs AT ROW 2.43 COL 17 COLON-ALIGNED
     bTrgBrowse AT ROW 2.43 COL 76
     Btn_OK AT ROW 3.62 COL 26
     Btn_Cancel AT ROW 3.62 COL 42
     SPACE(24.99) SKIP(0.09)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Translate Promsgs"
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Translate Promsgs */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bSrcBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bSrcBrowse Dialog-Frame
ON CHOOSE OF bSrcBrowse IN FRAME Dialog-Frame
DO:
    DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.
  SYSTEM-DIALOG GET-FILE cFile
      MUST-EXIST
      TITLE "Source Promsgs Browse"
      UPDATE lOK.
  IF lOK THEN
  DO:
      ASSIGN 
      cSrcMsgs = cFile
      cSrcMsgs:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cFile.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.

    ASSIGN csrcmsgs ctrgmsgs.
    /* check if csrcmsgs is valid */
    RUN checkPromsgsFile IN ghlogutils(csrcmsgs,OUTPUT lOK).
    IF NOT lOK THEN
    DO:
        MESSAGE "Source Promsgs file '" + csrcmsgs + "' does not exist, or is not a valid promsgs file"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN NO-APPLY.
    END.
    /* check if ctrgmsgs is valid */
    RUN checkPromsgsFile IN ghlogutils(ctrgmsgs,OUTPUT lOK).
    IF NOT lOK THEN
    DO:
        MESSAGE "Target Promsgs file '" + ctrgmsgs + "' does not exist, or is not a valid promsgs file"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN NO-APPLY.
    END.
    /* run translation */
    RUN translateMessages.
    APPLY "go":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bTrgBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bTrgBrowse Dialog-Frame
ON CHOOSE OF bTrgBrowse IN FRAME Dialog-Frame
DO:
    DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.
  SYSTEM-DIALOG GET-FILE cFile
      MUST-EXIST
      TITLE "Target Promsgs Browse"
      UPDATE lOK.
  IF lOK THEN
  DO:
      ASSIGN 
      cTrgMsgs = cFile
      cTrgMsgs:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cFile.
  END.
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
  DISPLAY cSrcMsgs cTrgMsgs 
      WITH FRAME Dialog-Frame.
  ENABLE cSrcMsgs bSrcBrowse cTrgMsgs bTrgBrowse Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE translateMessages Dialog-Frame 
PROCEDURE translateMessages :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hfld AS HANDLE    NO-UNDO.
    DEFINE VARIABLE cmsg AS CHAR NO-UNDO.
    DEFINE VARIABLE cnewmsg AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE imsgno AS INTEGER    NO-UNDO.
    DEFINE VARIABLE irows AS INTEGER    NO-UNDO.
    
    hbuf = htt:DEFAULT-BUFFER-HANDLE.
    CREATE QUERY hqry.
    hqry:SET-BUFFERS(hbuf).
    
    hqry:QUERY-PREPARE("for each " + hbuf:NAME + " exclusive-lock").
    
    hqry:QUERY-OPEN().
    
    REPEAT:
      DO TRANSACTION:
        hqry:GET-NEXT().
        IF hqry:QUERY-OFF-END THEN LEAVE.
        hfld = hbuf:BUFFER-FIELD("logmsg").
        cmsg = hfld:BUFFER-VALUE().
        /* check if this message has a promsg number */
        RUN getPromsgNum IN ghlogutils(INPUT cmsg,OUTPUT imsgno).
        IF imsgno <= 0 THEN NEXT.
        /* translate a promsg from one language to another */
        RUN translatePromsg IN ghlogutils(
            INPUT cmsg,        /* text of promsg, including number */
            INPUT csrcmsgs,  /* path of promsgs file of original promsg language */
            INPUT ctrgmsgs,  /* path of promsgs file to translate to */
            OUTPUT cnewmsg). /* text of translated message */
        IF cmsg <> cnewmsg THEN
        DO:
            hfld:BUFFER-VALUE = cnewmsg.
            irows = irows + 1.
        END.        
        hbuf:BUFFER-RELEASE().
      END.
    END.
    hqry:QUERY-CLOSE().
    DELETE OBJECT hqry.
    MESSAGE "Translated" irows "messages." SKIP
        "Please refresh your query to see translated messages"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

