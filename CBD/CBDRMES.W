&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
RUN bin/_mes.p ( INPUT s-NroMes , 3,  OUTPUT pinta-mes ).
pinta-mes = pinta-mes + ", " + STRING( s-periodo , "9999" ).
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
          
IF NOT cb-peri.MesCie[ s-NroMes + 1 ] 
THEN DO:
    BELL.
    MESSAGE "Mes aun no Cerrado ....." VIEW-AS ALERT-BOX ERROR.
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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 EDITOR-1 B-acepta B-Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 EDITOR-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-acepta AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 11 BY 1.08.

DEFINE BUTTON B-Cancel AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 11 BY 1.08.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 63 BY 5.5
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY 1.5
     FONT 11 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 6 GRAPHIC-EDGE  
     SIZE 66 BY 8.96.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 6 GRAPHIC-EDGE  
     SIZE 65.86 BY 2.69
     BGCOLOR 8 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     FILL-IN-1 AT ROW 2 COL 3 COLON-ALIGNED NO-LABEL
     EDITOR-1 AT ROW 4 COL 2 NO-LABEL
     B-acepta AT ROW 11 COL 18
     B-Cancel AT ROW 11 COL 43
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 10 COL 1.14
     SPACE(0.13) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 
         TITLE "Reapertura de Mes".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
                                                                        */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME DIALOG-1        = TRUE
       EDITOR-1:PRIVATE-DATA IN FRAME DIALOG-1     = 
                "Esta opci¢n permite revertir el proceso de cierre de mes.
Ejecutada esta opci¢n nuevamente los usuarios podran modificar, anular, crear los registros contables. Es importante mantener los meses cerrados para evitar alteraciones a los balances una vez ya aprobados. Ejecute este proceso solo en el caso de haber cometido el error de cerrar el mes sin concluir todas las transacciones del mes.".

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-acepta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-acepta DIALOG-1
ON CHOOSE OF B-acepta IN FRAME DIALOG-1 /* Aceptar */
DO:
  ASSIGN cb-peri.MesCie[ s-NroMes + 1 ] = no. 
    /* Borramos Aplicacion de Gastos por CCo */
    RUN cbd/p-cccdg (s-codcia, s-periodo, s-nromes, FALSE).
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
  FILL-IN-1:SCREEN-VALUE = pinta-mes.
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
  DISPLAY FILL-IN-1 EDITOR-1 
      WITH FRAME DIALOG-1.
  ENABLE RECT-1 RECT-2 EDITOR-1 B-acepta B-Cancel 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


