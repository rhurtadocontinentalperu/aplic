&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME    W-INGRESO
&Scoped-define FRAME-NAME     W-INGRESO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-INGRESO 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 07/07/94 -  5:08 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE veces       AS INTEGER NO-UNDO.
DEFINE VARIABLE x-user-name LIKE integral._user._user-name.
DEFINE VARIABLE pto AS LOGICAL.
pto = SESSION:SET-WAIT-STATE("").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  W-INGRESO

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for DIALOG-BOX W-INGRESO                                 */
&Scoped-define FIELDS-IN-QUERY-W-INGRESO 
&Scoped-define ENABLED-FIELDS-IN-QUERY-W-INGRESO 

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-acepta AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 10.86 BY 1.08.

DEFINE BUTTON b-ayuda 
     LABEL "A&yuda" 
     SIZE 10.86 BY 1.08.

DEFINE BUTTON b-cancelar AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10.86 BY 1.08.

DEFINE VARIABLE x-password AS CHARACTER FORMAT "X(16)":U INITIAL ? 
     LABEL "Clave" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE s-user-id AS CHARACTER FORMAT "X(16)":U INITIAL ? 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1.

DEFINE IMAGE IMAGE-1
     FILENAME "IMG/logo-5"
     SIZE 17 BY 5.5.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 59.86 BY 2
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 60 BY 6.5
     BGCOLOR 8 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME W-INGRESO
     s-user-id AT ROW 2.5 COL 32 COLON-ALIGNED
     x-password AT ROW 5 COL 32 COLON-ALIGNED BLANK 
     b-acepta AT ROW 8 COL 8
     b-cancelar AT ROW 8 COL 27
     b-ayuda AT ROW 8 COL 45
     RECT-2 AT ROW 1 COL 1
     IMAGE-1 AT ROW 1.5 COL 5
     RECT-1 AT ROW 7.5 COL 1.14
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         TITLE "Sistema integral Valmiesa".

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME W-INGRESO:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN s-user-id IN FRAME W-INGRESO
   SHARED                                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-acepta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-acepta W-INGRESO
ON CHOOSE OF b-acepta IN FRAME W-INGRESO /* Aceptar */
DO:
    ASSIGN x-password = CAPS( INPUT x-password )
        s-user-id = CAPS( INPUT s-user-id ).
    FIND _User WHERE _userid = s-user-id NO-LOCK NO-ERROR.
    IF NOT AVAILABLE _User
    THEN IF ( s-user-id = "MASTER" )
        THEN DO:
            CREATE _user.
                ASSIGN _user._userid    = s-user-id
                       _user._password  = ENCODE( x-password )
                       _user._user-name = "Administrador del Sistema".
        END.
        ELSE DO:
            BELL.
            MESSAGE "Ingreso Incorrecto..." VIEW-AS ALERT-BOX ERROR.
            IF veces > 1
                THEN QUIT.
                veces = veces + 1.
                APPLY "ENTRY" TO s-user-id.
                RETURN NO-APPLY.
            END.    
    ELSE DO:
        IF SETUSERID(s-user-id, x-password, "DICTDB") <> TRUE
        THEN DO:
            BELL.
            MESSAGE "Ingreso Incorrecto..." VIEW-AS ALERT-BOX ERROR.
            IF veces > 1 THEN QUIT.
            veces = veces + 1.
            APPLY "ENTRY" TO s-user-id.
            RETURN NO-APPLY.
        END.
        x-user-name = _user._user-name.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-ayuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-ayuda W-INGRESO
ON CHOOSE OF b-ayuda IN FRAME W-INGRESO /* Ayuda */
DO:
  RUN adecomm/_adehelp.p("comm", "CONTEXT", 49194, ?).   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cancelar W-INGRESO
ON CHOOSE OF b-cancelar IN FRAME W-INGRESO /* Cancelar */
DO:
    QUIT.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-password
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-password W-INGRESO
ON RETURN OF x-password IN FRAME W-INGRESO /* Clave */
DO:
    APPLY "CHOOSE" TO b-acepta.
    RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-INGRESO 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
    s-user-id:SCREEN-VALUE = "".
    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-INGRESO _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Hide all frames. */
  HIDE FRAME W-INGRESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-INGRESO _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */
  DISPLAY s-user-id x-password 
      WITH FRAME W-INGRESO.
  ENABLE RECT-2 IMAGE-1 s-user-id x-password RECT-1 b-acepta b-cancelar b-ayuda 
      WITH FRAME W-INGRESO.
  {&OPEN-BROWSERS-IN-QUERY-W-INGRESO}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
