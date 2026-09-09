&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 08/18/95 -  5:02 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE s-periodo    AS INTEGER INITIAL 1995.
DEFINE {&NEW} SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 2.
&IF NOT "{&NEW}" = "" &THEN
    DEFINE NEW GLOBAL SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,5".
&ENDIF
DEFINE VARIABLE x-status  AS LOGICAL.
DEFINE VARIABLE pinta-mes AS CHARACTER FORMAT "X(16)".
DEFINE VARIABLE pinta-ano AS CHARACTER FORMAT "X(5)".
RUN bin/_mes.p ( INPUT s-NroMes , 3,  OUTPUT pinta-mes ).
pinta-mes = pinta-mes.
pinta-ano = string(s-periodo,"9,999").
RUN bin/_centrar.p ( INPUT pinta-mes, 16, OUTPUT pinta-mes).

FIND cb-peri WHERE CodCia = s-codcia
               AND Periodo = s-periodo NO-ERROR.
IF NOT AVAILABLE cb-peri
THEN DO:
     BELL.
     MESSAGE "Invalido Periodo seleccionado." skip
             "Ingrese nuevamente al sistema" VIEW-AS ALERT-BOX ERROR.
     RETURN.
END.
          
IF cb-peri.MesPre[ s-NroMes + 1 ] 
THEN DO:
    BELL.
    MESSAGE " MES YA TIENE PRE-CIERRE " VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 EDITOR-1 B-acepta B-Cancel B-Ayuda 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 FILL-IN-1 FILL-IN-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-acepta AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Aceptar" 
     SIZE 12.43 BY 1.54.

DEFINE BUTTON B-Ayuda 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "&Ayuda" 
     SIZE 12.43 BY 1.54.

DEFINE BUTTON B-Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 12.43 BY 1.54.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 40.57 BY 5.5
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Año" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 17.29 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 55.29 BY 7.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     EDITOR-1 AT ROW 1.15 COL 1.72 NO-LABEL
     FILL-IN-1 AT ROW 7.15 COL 3.43
     FILL-IN-2 AT ROW 7.15 COL 19.86
     B-acepta AT ROW 1.27 COL 43
     B-Cancel AT ROW 2.85 COL 43
     B-Ayuda AT ROW 4.42 COL 43
     RECT-1 AT ROW 1 COL 1
     SPACE(0.00) SKIP(0.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 
         TITLE "Pre-Cierre del Mes".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
   Default                                                              */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME DIALOG-1        = TRUE
       EDITOR-1:PRIVATE-DATA IN FRAME DIALOG-1     = 
                "Esta opci¢n permite realizar el Pre-Cierre del mes.Una vez ejecutada la opci¢n los usuarios de nivel Digitador, Operador no podran Crear, Modificar, Anular ningun registro contable en los asientos tipos.Verifique que todas sus transaciones hayan sido ingresadas antes de ejecutar el siguiente proceso.".

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME DIALOG-1
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME DIALOG-1
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-acepta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-acepta DIALOG-1
ON CHOOSE OF B-acepta IN FRAME DIALOG-1 /* Aceptar */
DO:
    ASSIGN cb-peri.MesPre[ s-NroMes + 1 ] = yes. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EDITOR-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EDITOR-1 DIALOG-1
ON ENTRY OF EDITOR-1 IN FRAME DIALOG-1
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


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
  EDITOR-1:SCREEN-VALUE = EDITOR-1:PRIVATE-DATA.
  FILL-IN-1:SCREEN-VALUE = pinta-ano.
  FILL-IN-2:SCREEN-VALUE = pinta-mes.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
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
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 _DEFAULT-ENABLE
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
  DISPLAY EDITOR-1 FILL-IN-1 FILL-IN-2 
      WITH FRAME DIALOG-1.
  ENABLE RECT-1 EDITOR-1 B-acepta B-Cancel B-Ayuda 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


