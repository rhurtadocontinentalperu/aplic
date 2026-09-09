&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME W-detalle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-detalle 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 09/16/95 -  3:11 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE {&NEW} SHARED VARIABLE s-codcia       AS INTEGER INITIAL 1.
DEFINE VARIABLE cb-codcia                   AS INTEGER INITIAL 0.
DEFINE {&NEW} SHARED VARIABLE s-NroMes AS INTEGER FORMAT "99" INITIAL 02.
DEFINE {&NEW} SHARED VARIABLE s-periodo AS INTEGER FORMAT "9999" INITIAL 1995.
DEFINE               VARIABLE RECID-stack AS RECID.
/*
FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.

/* Buscamos las configuraciones del Sistema Contable */
FIND cb-cfga WHERE cb-cfga.CodCia = cb-codcia
               AND cb-cfga.CodCfg = 1 NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga
THEN DO:
    BELL.
    MESSAGE "NO SE HA CONFIGURADO EL SISTEMA CONTABLE"
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
*/
/* Definimos variables para la consistencia de cuentas */
DEFINE VARIABLE RECID-tmp   AS RECID NO-UNDO.
DEFINE VARIABLE pto         AS LOGICAL.
pto      = SESSION:SET-WAIT-STATE("").

/*   C A M B I O S   E N    L O S   P R E - P R O C E S A D O R E S */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME W-detalle

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 b-acepta X-Codope X-Nrodoc ~
B-Cancelar 
&Scoped-Define DISPLAYED-OBJECTS X-Codope X-Nrodoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-acepta AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Aceptar" 
     SIZE 11.86 BY 1.35.

DEFINE BUTTON B-Cancelar AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 11.86 BY 1.35.

DEFINE VARIABLE X-Codope AS CHARACTER FORMAT "X(3)":U 
     LABEL "Código de Operación" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE X-Nrodoc AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Numero Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 32 BY 3.62
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 32 BY 1.85
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME W-detalle
     b-acepta AT ROW 4.85 COL 2.43
     X-Codope AT ROW 1.88 COL 15.43 COLON-ALIGNED
     X-Nrodoc AT ROW 2.77 COL 15.43 COLON-ALIGNED
     B-Cancelar AT ROW 4.85 COL 19.57
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 4.54 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Correlativos".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX W-detalle
                                                                        */
ASSIGN 
       FRAME W-detalle:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-acepta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-acepta W-detalle
ON CHOOSE OF b-acepta IN FRAME W-detalle /* Aceptar */
DO:
    IF X-Codope:SCREEN-VALUE IN FRAME W-Detalle  = ""  
    THEN DO:
        MESSAGE "Código de Operación es Dato Obligatorio." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO X-Codope IN FRAME W-Detalle.
        RETURN NO-APPLY.
    END.    
    ASSIGN  integral.cb-corr.NRODOC = INPUT FRAME W-Detalle X-Nrodoc.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-Codope
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-Codope W-detalle
ON F8 OF X-Codope IN FRAME W-detalle /* Código de Operación */
DO:
    RUN cbd/q-oper.w (cb-codcia , OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        FIND integral.cb-oper WHERE RECID( integral.cb-oper ) = RECID-stack
              NO-LOCK  NO-ERROR.
        IF AVAIL integral.cb-oper THEN DO:
             X-Codope:SCREEN-VALUE IN FRAME W-Detalle = integral.cb-oper.Codope.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-Codope W-detalle
ON LEAVE OF X-Codope IN FRAME W-detalle /* Código de Operación */
DO: 
    IF X-Codope:SCREEN-VALUE = "" 
    THEN DO:
        APPLY "ENTRY" TO X-codope IN FRAME W-Detalle.
        RETURN NO-APPLY.    
    END.
    FIND cb-corr WHERE 
         cb-corr.CodCia = s-codcia AND 
         cb-corr.Coddoc = "ASTO"     AND 
         cb-corr.Llave  = STRING ( s-periodo,"9999" ) + 
                                 STRING ( s-NroMes, "99" ) + 
                                 x-Codope:SCREEN-VALUE IN FRAME W-Detalle 
         EXCLUSIVE-LOCK NO-ERROR.
    
    IF NOT AVAIL cb-corr THEN DO:
            CREATE cb-corr.
            ASSIGN cb-corr.CodCia = s-codcia 
                   cb-corr.Coddoc = "ASTO"  
                   cb-corr.Llave  = STRING ( s-periodo,"9999" ) + 
                                    STRING ( s-NroMes, "99" ) + 
                                    X-Codope:SCREEN-VALUE IN FRAME W-Detalle.
    END.
    
    IF AVAIL cb-corr THEN DO:
       DISPLAY cb-corr.Nrodoc @  x-Nrodoc WITH FRAME W-Detalle.
    END.        
                                                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-Codope W-detalle
ON MOUSE-SELECT-DBLCLICK OF X-Codope IN FRAME W-detalle /* Código de Operación */
DO:
    APPLY "F8" TO X-Codope.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-detalle 


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
  APPLY "ENTRY" TO X-Codope IN FRAME {&FRAME-NAME}.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-detalle _DEFAULT-DISABLE
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
  HIDE FRAME W-detalle.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-detalle _DEFAULT-ENABLE
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
  DISPLAY X-Codope X-Nrodoc 
      WITH FRAME W-detalle.
  ENABLE RECT-1 RECT-2 b-acepta X-Codope X-Nrodoc B-Cancelar 
      WITH FRAME W-detalle.
  {&OPEN-BROWSERS-IN-QUERY-W-detalle}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


