&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME    Frm-Instala
&Scoped-define FRAME-NAME     Frm-Instala
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Frm-Instala 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 11/09/95 - 11:45 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE CHK-DATA AS CHARACTER.
DEFINE VARIABLE ENCRIPTA AS CHARACTER.
DEFINE VARIABLE TEMP     AS CHARACTER.
DEFINE VARIABLE I        AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  Frm-Instala

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for DIALOG-BOX Frm-Instala                               */
&Scoped-define FIELDS-IN-QUERY-Frm-Instala 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Frm-Instala 

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 10 BY 1.

DEFINE BUTTON B-Cancelar AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE VARIABLE x-Compannia AS CHARACTER FORMAT "X(40)":U 
     LABEL "Compa¤ia" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE x-control AS CHARACTER FORMAT "X(5)":U 
     LABEL "No Control" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE X-CONTROL2 AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE X-CONTROL3 AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE X-NroSerie AS CHARACTER FORMAT "X(9)":U 
     LABEL "No Serie" 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1 NO-UNDO.

DEFINE RECTANGLE R-instala
     EDGE-PIXELS 6 GRAPHIC-EDGE  
     SIZE 70 BY 6
     BGCOLOR 8 .

DEFINE RECTANGLE R-instala2
     EDGE-PIXELS 6 GRAPHIC-EDGE  
     SIZE 70 BY 2.5
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Frm-Instala
     x-Compannia AT ROW 2 COL 16 COLON-ALIGNED
     X-NroSerie AT ROW 3.5 COL 16 COLON-ALIGNED
     x-control AT ROW 5 COL 16 COLON-ALIGNED
     X-CONTROL2 AT ROW 5 COL 29 COLON-ALIGNED NO-LABEL
     X-CONTROL3 AT ROW 5 COL 42 COLON-ALIGNED NO-LABEL
     B-aceptar AT ROW 8 COL 18
     B-Cancelar AT ROW 8 COL 45
     R-instala AT ROW 1.5 COL 1
     R-instala2 AT ROW 7 COL 1
     SPACE(0.00) SKIP(0.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         TITLE "Instalaci¢n".

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME Frm-Instala:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar Frm-Instala
ON CHOOSE OF B-aceptar IN FRAME Frm-Instala /* Aceptar */
DO:
    ASSIGN x-Compannia
           X-NroSerie
           X-CONTROL
           X-CONTROL2
           X-CONTROL3.
    
    /* Verificando los datos integresados */
    X-CONTROL = X-CONTROL + X-CONTROL2 + X-CONTROL3.
    CHK-DATA = ENCODE( ENCODE( LC(x-Compannia) ) + ENCODE( LC(X-NroSerie) ) ).
    CHK-DATA = CAPS( CHK-DATA ).

    IF NOT CHK-DATA BEGINS X-CONTROL OR X-CONTROL = ""
    THEN DO:
        MESSAGE "Tarjeta de Registro mal Ingresada." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    /* Nro. de Serie Bueno */
    RUN series.p ( X-NroSerie, OUTPUT Temp).
    IF Temp = "BAD"
    THEN DO:
        MESSAGE "Invalido No. de Serie" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    /* GRABANDO CONFIGURACION */         
    OUTPUT TO integral.CFG NO-MAP NO-CONVERT.
    PUT UNFORMATTED x-Compannia SKIP.
    PUT UNFORMATTED X-NroSerie SKIP.
    PUT UNFORMATTED X-CONTROL SKIP.
    OUTPUT CLOSE.          

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancelar Frm-Instala
ON CHOOSE OF B-Cancelar IN FRAME Frm-Instala /* Cancelar */
DO:
    QUIT.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Compannia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Compannia Frm-Instala
ON ANY-PRINTABLE OF x-Compannia IN FRAME Frm-Instala /* Compa¤ia */
DO:
    APPLY CAPS( CHR( LASTKEY) ) TO SELF.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-control
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-control Frm-Instala
ON ANY-PRINTABLE OF x-control IN FRAME Frm-Instala /* No Control */
DO:
    APPLY CAPS( CHR( LASTKEY) ) TO SELF.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-control Frm-Instala
ON LEAVE OF x-control IN FRAME Frm-Instala /* No Control */
DO:
    IF LENGTH( SELF:SCREEN-VALUE )<> 5
    THEN RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-CONTROL2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-CONTROL2 Frm-Instala
ON LEAVE OF X-CONTROL2 IN FRAME Frm-Instala
DO:
    IF LENGTH( SELF:SCREEN-VALUE )<> 5
    THEN RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-CONTROL3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-CONTROL3 Frm-Instala
ON LEAVE OF X-CONTROL3 IN FRAME Frm-Instala
DO:
    IF LENGTH( SELF:SCREEN-VALUE )<> 5
    THEN RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-NroSerie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-NroSerie Frm-Instala
ON ANY-PRINTABLE OF X-NroSerie IN FRAME Frm-Instala /* No Serie */
DO:
    APPLY CAPS( CHR( LASTKEY) ) TO SELF.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Frm-Instala 


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
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Frm-Instala _DEFAULT-DISABLE
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
  HIDE FRAME Frm-Instala.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Frm-Instala _DEFAULT-ENABLE
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
  DISPLAY x-Compannia X-NroSerie x-control X-CONTROL2 X-CONTROL3 
      WITH FRAME Frm-Instala.
  ENABLE R-instala x-Compannia X-NroSerie x-control X-CONTROL2 X-CONTROL3 
         R-instala2 B-aceptar B-Cancelar 
      WITH FRAME Frm-Instala.
  {&OPEN-BROWSERS-IN-QUERY-Frm-Instala}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
