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
DEFINE NEW GLOBAL SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.
DEFINE NEW GLOBAL SHARED VARIABLE s-periodo    AS INTEGER INITIAL 1996.
DEFINE NEW GLOBAL SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 1. 
DEFINE VARIABLE I        AS INTEGER.
DEFINE NEW GLOBAL SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,5".

DEFINE VARIABLE x-status  AS LOGICAL.
DEFINE VARIABLE pinta-mes AS CHARACTER FORMAT "X(30)".
DEFINE VARIABLE Mensaje2  AS CHARACTER FORMAT "X(30)".
DEFINE VARIABLE Mensaje3  AS CHARACTER FORMAT "X(30)".

DEFINE FRAME f-data
        pinta-mes SKIP
        mensaje2  skip
        mensaje3  skip
        WITH VIEW-AS DIALOG-BOX TITLE "REGENERANDO" NO-LABEL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 EDITOR-1 RECT-2 C-1 B-acepta C-2 ~
B-Cancel T-BORRA 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 C-1 C-2 T-BORRA 

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
     SIZE 13.14 BY 1.38.

DEFINE BUTTON B-Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 13.14 BY 1.38.

DEFINE VARIABLE C-1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Del Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     SIZE 8 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-2 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Al Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     SIZE 8 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 62 BY 6
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 66.29 BY 8.31.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 66.29 BY 2.69
     BGCOLOR 8 FGCOLOR 0 .

DEFINE VARIABLE T-BORRA AS LOGICAL INITIAL no 
     LABEL "Borrar Acumulado Anterior" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.86 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     EDITOR-1 AT ROW 2.65 COL 2.86 NO-LABEL
     C-1 AT ROW 1.5 COL 11.72 COLON-ALIGNED
     B-acepta AT ROW 9.88 COL 14.86
     C-2 AT ROW 1.5 COL 27.29 COLON-ALIGNED
     B-Cancel AT ROW 9.88 COL 38
     T-BORRA AT ROW 1.5 COL 41.14
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 9.27 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Regeneraci¢n de Saldos".


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
                                                                        */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME DIALOG-1        = TRUE
       EDITOR-1:PRIVATE-DATA IN FRAME DIALOG-1     = 
                "Esta opci¢n permite acumular los importes contables para la emisiones de los balances, estados de gesti¢n, anexos y consultas del sistema contable. Solo ser  necesario realizarlo cuando por un error en el sistema estos importes quedaron desbalanceados. Este proceso requiere un uso exclusivo sobre los datos en los meses a procesar, por tanto mientras se ejecute este procedimiento no se prodra realizar niguna tarea sobre el sistema contable.".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-acepta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-acepta DIALOG-1
ON CHOOSE OF B-acepta IN FRAME DIALOG-1 /* Aceptar */
DO:
      
    ASSIGN C-1 C-2 t-borra.
    IF C-1 > C-2 THEN DO:
       MESSAGE "Rango de meses no valido"
       VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    RUN anual.
    
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
ASSIGN C-1 = 0
       C-2 = 13.
       
MAIN-BLOCK:
DO:
  RUN enable_UI.
  EDITOR-1:SCREEN-VALUE = EDITOR-1:PRIVATE-DATA.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acum-1 DIALOG-1 
PROCEDURE acum-1 :
DEFINE INPUT PARAMETER p-codcia    AS INTEGER.
DEFINE INPUT PARAMETER p-periodo   AS INTEGER.
DEFINE INPUT PARAMETER P-nromes    AS INTEGER.
DEFINE INPUT PARAMETER p-codcta    AS CHAR.
DEFINE INPUT PARAMETER P-CodDiv    AS CHAR.
DEFINE INPUT PARAMETER P-DEBE1     AS DECIMAL.
DEFINE INPUT PARAMETER P-DEBE2     AS DECIMAL.
DEFINE INPUT PARAMETER P-HABER1    AS DECIMAL.
DEFINE INPUT PARAMETER P-HABER2    AS DECIMAL.

FIND cb-acmd WHERE cb-acmd.CodCia  = P-CODCIA  AND 
                   cb-acmd.Periodo = P-PERIODO AND 
                   cb-acmd.CodCta  = P-CodCta  AND 
                   cb-acmd.CodDiv  = P-CodDiv NO-ERROR.
IF NOT AVAILABLE cb-acmd THEN DO: 
   CREATE cb-acmd.
   ASSIGN cb-acmd.CodCia  = P-CODCIA
          cb-acmd.Periodo = P-periodo
          cb-acmd.CodDiv  = P-CodDiv
          cb-acmd.CodCta  = p-CodCta.
END.
IF P-DEBE1 = 0 AND P-DEBE2 = 0 AND P-HABER1 = 0 AND P-HABER2 = 0 THEN RETURN.
ASSIGN cb-acmd.DbeMn1[ P-NROMES + 1 ]  =  P-DEBE1
       cb-acmd.DbeMn2[ P-NROMES + 1 ]  =  P-DEBE2
       cb-acmd.HbeMn1[ P-NROMES + 1 ]  =  P-HABER1
       cb-acmd.HbeMn2[ P-NROMES + 1 ]  =  P-HABER2.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anual DIALOG-1 
PROCEDURE anual :
DEFINE VAR D-DEBE1  AS DECIMAL.
DEFINE VAR D-DEBE2  AS DECIMAL.
DEFINE VAR D-HABER1 AS DECIMAL.
DEFINE VAR D-HABER2 AS DECIMAL.

DEFINE VAR C-DEBE1  AS DECIMAL.
DEFINE VAR C-DEBE2  AS DECIMAL.
DEFINE VAR C-HABER1 AS DECIMAL.
DEFINE VAR C-HABER2 AS DECIMAL.
DEFINE VAR K AS INTEGER.

x-status = SESSION:SET-WAIT-STATE("GENERAL").
STATUS INPUT OFF.
PAUSE 0 BEFORE-HIDE.
x-status = SESSION:IMMEDIATE-DISPLAY.
DISPLAY "Borrando movimientos Anteriores" @ pinta-mes  WITH FRAME f-data.

IF C-1 = 0 AND C-2 = 13 AND T-BORRA THEN 
   DELETE FROM cb-acmd WHERE ( cb-acmd.CodCia  = s-codcia AND  
                               cb-acmd.Periodo = s-periodo ).  
ELSE
FOR EACH cb-acmd WHERE cb-acmd.CodCia = s-codcia AND  
                       cb-acmd.Periodo = s-periodo :
    DO I = C-1 TO C-2 :      
       ASSIGN cb-acmd.DbeMn1[ I + 1 ]  = 0     
              cb-acmd.HbeMn1[ I + 1 ]  = 0
              cb-acmd.DbeMn2[ I + 1 ]  = 0     
              cb-acmd.HbeMn2[ I + 1 ]  = 0.
   END.      
END.           
   
/* actualizando acumulados */
DISPLAY "Procesando Informaci¢n" @ pinta-mes  WITH FRAME f-data.
DO K = C-1 TO C-2 :
   RUN bin/_mes.p ( INPUT K , 3,  OUTPUT pinta-mes ).
   pinta-mes = pinta-mes + ", " + STRING( s-periodo , "9999" ).
   DISPLAY pinta-mes WITH FRAME f-data.
   
    FOR EACH cb-dmov WHERE cb-dmov.CodCia = s-codcia AND
                           cb-dmov.Periodo = s-periodo    AND
                           cb-dmov.nromes  = K        
                           BREAK BY cb-dmov.codcta + cb-dmov.coddiv :
       IF FIRST-OF( cb-dmov.codcta + cb-dmov.coddiv ) THEN DO:
          mensaje2 = "Cuenta : " + cb-dmov.codcta.
          mensaje3 = "División : " + cb-dmov.coddiv.
          DISPLAY mensaje2 mensaje3 WITH FRAME f-data.
          C-DEBE1  =  0.
          C-DEBE2  =  0.
          C-HABER1 =  0.
          C-HABER2 =  0.
       END.
       IF cb-dmov.TPOMOV THEN DO:
          C-HABER1 = C-HABER1 + cb-dmov.IMPMN1.
          C-HABER2 = C-HABER2 + cb-dmov.IMPMN2.
       END.
       ELSE DO:
          C-DEBE1  = C-DEBE1 + cb-dmov.IMPMN1.
          C-DEBE2  = C-DEBE2 + cb-dmov.IMPMN2.
       END.
       IF LAST-OF( cb-dmov.codcta + cb-dmov.coddiv ) THEN DO:
          RUN ACUM-1 ( cb-dmov.codcia,
                       cb-dmov.periodo,
                       cb-dmov.nromes,
                       cb-dmov.codcta,
                       cb-dmov.coddiv,
                       C-DEBE1,
                       C-DEBE2,
                       C-HABER1,
                       C-HABER2 ). 
       END.
    END.

END. /* FIN DEL DO */

HIDE FRAME f-data.
x-status = SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY EDITOR-1 C-1 C-2 T-BORRA 
      WITH FRAME DIALOG-1.
  ENABLE RECT-1 EDITOR-1 RECT-2 C-1 B-acepta C-2 B-Cancel T-BORRA 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


