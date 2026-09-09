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
DEFINE  {&NEW} SHARED VARIABLE s-user-id AS CHARACTER INITIAL "USER0".
DEFINE VARIABLE VECES AS INTEGER INITIAL 0.
DEFINE VARIABLE pto            AS LOGICAL.


FIND _USER WHERE _USER._USERID = s-user-id.

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
DEFINE BUTTON b-aceptar AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 10.86 BY 1.08.

DEFINE BUTTON b-ayuda 
     LABEL "A&yuda" 
     SIZE 10.86 BY 1.08.

DEFINE BUTTON b-cancelar AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10.86 BY 1.08.

DEFINE VARIABLE X-oldpass AS CHARACTER FORMAT "X(15)":U 
     LABEL "Clave Actual" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE x-password AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nueva Clave" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 59.86 BY 2
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 59.86 BY 5.5
     BGCOLOR 8 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME W-INGRESO
     X-oldpass AT ROW 2.5 COL 24 COLON-ALIGNED BLANK 
     x-password AT ROW 4.5 COL 24 COLON-ALIGNED BLANK 
     b-aceptar AT ROW 7 COL 9
     b-cancelar AT ROW 7 COL 27
     b-ayuda AT ROW 7 COL 46
     RECT-9 AT ROW 1 COL 1
     RECT-2 AT ROW 6.5 COL 1
     SPACE(0.13) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         TITLE "Cambiar Clave de Acceso".

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME W-INGRESO:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-aceptar W-INGRESO
ON CHOOSE OF b-aceptar IN FRAME W-INGRESO /* Aceptar */
DO:
    ASSIGN x-Password.
    _User._Password = ENCODE(CAPS(x-Password)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-oldpass
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-oldpass W-INGRESO
ON LEAVE OF X-oldpass IN FRAME W-INGRESO /* Clave Actual */
DO:
    ASSIGN x-oldpass = CAPS( INPUT x-oldpass ). 
    
    IF X-oldpass:SCREEN-VALUE = ""   
    THEN DO:
    VECES = VECES + 1.
    IF VECES >= 3 THEN QUIT.
        BELL.
        MESSAGE "Debe Ingresar Clave Actual" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO X-oldpass.
        RETURN NO-APPLY.   
    END.
   
   IF SETUSERID(s-user-id, x-oldpass, "DICTDB") <> TRUE
     THEN DO:
        BELL.
        MESSAGE "El Password no es Correcto - Reingrese" VIEW-AS ALERT-BOX ERROR.
        VECES = VECES + 1.
        IF VECES >=3 THEN QUIT.
        APPLY "ENTRY" TO X-oldpass.
        RETURN NO-APPLY.   
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-password
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-password W-INGRESO
ON GO OF x-password IN FRAME W-INGRESO /* Nueva Clave */
DO:
    APPLY "CHOOSE" TO b-aceptar.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-password W-INGRESO
ON LEAVE OF x-password IN FRAME W-INGRESO /* Nueva Clave */
DO:
    IF X-password:SCREEN-VALUE = ""
    THEN DO:
        BELL.
        MESSAGE "Debe Ingresar Nueva Clave para Registrarla...!" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO x-password.    
        RETURN NO-APPLY.  
    END.
        
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

pto     = SESSION:SET-WAIT-STATE("").

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
  DISPLAY X-oldpass x-password 
      WITH FRAME W-INGRESO.
  ENABLE RECT-9 X-oldpass x-password RECT-2 b-aceptar b-cancelar b-ayuda 
      WITH FRAME W-INGRESO.
  {&OPEN-BROWSERS-IN-QUERY-W-INGRESO}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
