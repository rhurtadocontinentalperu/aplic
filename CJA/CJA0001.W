&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME W-INGRESO
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
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER.
DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER.
DEFINE VARIABLE pto AS LOGICAL.

RUN NIVELES.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME W-INGRESO

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-9 RECT-2 IMAGE-8 b-aceptar b-cancelar ~
s-periodo s-NroMes b-ayuda 
&Scoped-Define DISPLAYED-OBJECTS s-periodo s-NroMes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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

DEFINE {&NEW} SHARED VARIABLE s-NroMes AS INTEGER FORMAT "99":U INITIAL ? 
     LABEL "Mes Proceso" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1.

DEFINE {&NEW} SHARED VARIABLE s-periodo AS INTEGER FORMAT "9999":U INITIAL ? 
     LABEL "A¤o Proceso" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1.

DEFINE IMAGE IMAGE-8
     FILENAME "IMG/cjabco"
     SIZE 19 BY 6.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 59.86 BY 2
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 59.86 BY 7
     BGCOLOR 8 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME W-INGRESO
     b-aceptar AT ROW 8.5 COL 8
     b-cancelar AT ROW 8.5 COL 27
     s-periodo AT ROW 2.5 COL 43 COLON-ALIGNED
     s-NroMes AT ROW 5 COL 43 COLON-ALIGNED
     b-ayuda AT ROW 8.5 COL 45
     RECT-9 AT ROW 1 COL 1
     RECT-2 AT ROW 8 COL 1
     IMAGE-8 AT ROW 1.5 COL 7
     SPACE(34.99) SKIP(2.50)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Caja y Bancos".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME W-INGRESO:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN s-NroMes IN FRAME W-INGRESO
   SHARED                                                               */
/* SETTINGS FOR FILL-IN s-periodo IN FRAME W-INGRESO
   SHARED                                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-aceptar W-INGRESO
ON CHOOSE OF b-aceptar IN FRAME W-INGRESO /* Aceptar */
DO:
    ASSIGN s-periodo s-NroMes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s-periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s-periodo W-INGRESO
ON LEAVE OF s-periodo IN FRAME W-INGRESO /* A¤o Proceso */
DO:

    FIND cb-peri WHERE cb-peri.Periodo = INPUT s-periodo
                    AND cb-peri.CodCia = s-codcia NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-peri
    THEN DO:
        MESSAGE "A¤o contable no Registrado"  VIEW-AS ALERT-BOX ERROR.
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
FIND LAST cb-peri WHERE cb-peri.CodCia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-peri
THEN DO:
    MESSAGE "No Existen A¤os Contables Registrados" VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
/*
s-periodo = cb-peri.Periodo.
s-NroMes = cb-peri.mescbd.
*/
s-periodo = YEAR ( TODAY ).
s-NroMes = MONTH (TODAY ).
DISPLAY s-periodo s-NroMes WITH FRAME W-ingreso.

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
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME W-INGRESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-INGRESO _DEFAULT-ENABLE
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
  DISPLAY s-periodo s-NroMes 
      WITH FRAME W-INGRESO.
  ENABLE RECT-9 RECT-2 IMAGE-8 b-aceptar b-cancelar s-periodo s-NroMes b-ayuda 
      WITH FRAME W-INGRESO.
  {&OPEN-BROWSERS-IN-QUERY-W-INGRESO}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NIVELES W-INGRESO 
PROCEDURE NIVELES :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VARIABLE y-CodCia            AS INTEGER INITIAL 0.

    FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
    IF NOT Empresas.Campo-CodCbd THEN y-CodCia = s-codcia.

    DEFI VARI x-CodCta LIKE cb-ctas.CodCta.
    DEFI VARI j AS INTEGER.
    DEFI VARI nivel AS INTEGER INITIAL 0.

    FIND FIRST cb-cfga WHERE cb-cfga.CodCia = y-CodCia AND cb-cfga.CodCfg = 1
        NO-LOCK  NO-ERROR.
    IF NOT AVAILABLE cb-cfga THEN DO TRANSACTION:
        CREATE cb-cfga.
        ASSIGN cb-cfga.CodCia = y-CodCia
               cb-cfga.CodCfg = 1
               cb-cfga.DetCfg = "XX.X.XX".
        FIND FIRST cb-cfga WHERE cb-cfga.CodCia = y-CodCia AND cb-cfga.CodCfg = 1
            NO-LOCK.
    END. 
    cb-niveles = "".
    REPEAT j = 1 TO NUM-ENTRIES(cb-cfga.DetCfg, "."):
        nivel = nivel + LENGTH( ENTRY( j, cb-cfga.detCfg, ".") ).
        IF cb-niveles <> "" THEN cb-niveles = cb-niveles + ",".
        cb-niveles = cb-niveles + STRING( nivel, "9").
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


