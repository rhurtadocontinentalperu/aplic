&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 Character
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
&Scoped-Define ENABLED-OBJECTS RECT-1 EDITOR-1 RECT-2 B-acepta C-1 C-2 ~
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
     LABEL "&Aceptar" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY 1 &ENDIF.

DEFINE BUTTON B-Cancel AUTO-END-KEY 
     LABEL "&Cancelar" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY 1 &ENDIF.

DEFINE VARIABLE C-1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Del Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE C-2 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Al Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 62 BY 6
     &ELSE SIZE 62 BY 6 &ENDIF NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 6 GRAPHIC-EDGE  
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 66 BY 9
     &ELSE SIZE 66 BY 9 &ENDIF.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 6 GRAPHIC-EDGE  
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 66 BY 3
     &ELSE SIZE 66 BY 3 &ENDIF.

DEFINE VARIABLE T-BORRA AS LOGICAL INITIAL no 
     LABEL "Borrar Acumulado Anterior" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 16 BY 1
     &ELSE SIZE 16 BY 1 &ENDIF NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     EDITOR-1
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 3
          &ELSE AT ROW 4 COL 3 &ENDIF NO-LABEL
     B-acepta
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 11 COL 17
          &ELSE AT ROW 11 COL 17 &ENDIF
     C-1
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 2 COL 26 COLON-ALIGNED
          &ELSE AT ROW 2 COL 26 COLON-ALIGNED &ENDIF
     C-2
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 26 COLON-ALIGNED
          &ELSE AT ROW 3 COL 26 COLON-ALIGNED &ENDIF
     B-Cancel
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 11 COL 43
          &ELSE AT ROW 11 COL 43 &ENDIF
     T-BORRA
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 2 COL 46
          &ELSE AT ROW 2 COL 46 &ENDIF
     RECT-1
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 1
          &ELSE AT ROW 1 COL 1 &ENDIF
     RECT-2
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 10 COL 1
          &ELSE AT ROW 10 COL 1 &ENDIF
     SPACE(0.42) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
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

FIND cb-acmd WHERE cb-acmd.CodCia      = P-CODCIA
                   AND cb-acmd.Periodo = P-PERIODO
                   AND cb-acmd.CodCta  = P-CodCta
                   AND cb-acmd.CodDiv  = P-CodDiv
                   NO-ERROR.
IF NOT AVAILABLE cb-acmd
    THEN DO: 
        CREATE cb-acmd.
        ASSIGN cb-acmd.CodCia  = P-CODCIA
               cb-acmd.Periodo = P-periodo
               cb-acmd.CodDiv  = P-CodDiv
               cb-acmd.CodCta  = p-CodCta.
END.
IF P-DEBE1 = 0 AND P-DEBE2 = 0 AND P-HABER1 = 0 AND P-HABER2 = 0
   THEN RETURN.
ASSIGN   cb-acmd.DbeMn1[ P-NROMES + 1 ]  =  P-DEBE1
         cb-acmd.DbeMn2[ P-NROMES + 1 ]  =  P-DEBE2
         cb-acmd.HbeMn1[ P-NROMES + 1 ]  =  P-HABER1
         cb-acmd.HbeMn2[ P-NROMES + 1 ]  =  P-HABER2.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acum-2 DIALOG-1 
PROCEDURE acum-2 :
DEFINE INPUT PARAMETER p-codcia    AS INTEGER.
DEFINE INPUT PARAMETER p-periodo   AS INTEGER.
DEFINE INPUT PARAMETER P-nromes    AS INTEGER.
DEFINE INPUT PARAMETER p-codcta    AS CHAR.
DEFINE INPUT PARAMETER P-DEBE1     AS DECIMAL.
DEFINE INPUT PARAMETER P-DEBE2     AS DECIMAL.
DEFINE INPUT PARAMETER P-HABER1    AS DECIMAL.
DEFINE INPUT PARAMETER P-HABER2    AS DECIMAL.
DEFINE VARIABLE I AS INTEGER.
DEFINE VARIABLE x-codcta AS CHAR.

FIND FIRST cb-acmd WHERE cb-acmd.CodCia      = P-CODCIA
                         AND cb-acmd.Periodo = P-PERIODO
                         AND cb-acmd.CodCta  = P-CodCta
                         AND cb-acmd.CodDiv  = ""
                         NO-ERROR.
IF NOT AVAILABLE cb-acmd
    THEN DO: 
        CREATE cb-acmd.
        ASSIGN cb-acmd.CodCia  = P-CODCIA
               cb-acmd.Periodo = P-periodo
               cb-acmd.CodCta  = p-CodCta.
END.

IF P-DEBE1 = 0 AND P-DEBE2 = 0 AND P-HABER1 = 0 AND P-HABER2 = 0
   THEN RETURN.
   
ASSIGN   cb-acmd.DbeMn1[ P-NROMES + 1 ]  =  P-DEBE1
         cb-acmd.DbeMn2[ P-NROMES + 1 ]  =  P-DEBE2
         cb-acmd.HbeMn1[ P-NROMES + 1 ]  =  P-HABER1
         cb-acmd.HbeMn2[ P-NROMES + 1 ]  =  P-HABER2.

X-CODCTA = P-CODCTA.

REPEAT i = NUM-ENTRIES( cb-niveles ) TO 1 BY -1  :
    IF LENGTH( x-codcta ) > INTEGER( ENTRY( i, cb-niveles) )
    THEN DO:
        x-codcta = SUBSTR(x-CodCta, 1, INTEGER(ENTRY(i, cb-niveles))).
        FIND FIRST cb-acmd WHERE cb-acmd.CodCia      = P-CODCIA
                                 AND cb-acmd.Periodo = P-PERIODO
                                 AND cb-acmd.CodCta  = x-CodCta
                                 AND cb-acmd.CodDiv  = ""
                                 NO-ERROR.
        IF NOT AVAILABLE cb-acmd
           THEN DO: 
                CREATE cb-acmd.
                ASSIGN cb-acmd.CodCia  = P-CODCIA
                       cb-acmd.Periodo = P-periodo
                       cb-acmd.CodCta  = x-CodCta.
           END.
         ASSIGN  cb-acmd.DbeMn1[ P-NROMES + 1 ]  =  cb-acmd.DbeMn1[ P-NROMES + 1 ] +
                                                     P-DEBE1
                 cb-acmd.DbeMn2[ P-NROMES + 1 ]  =  cb-acmd.DbeMn2[ P-NROMES + 1 ] +
                                                     P-DEBE2
                 cb-acmd.HbeMn1[ P-NROMES + 1 ]  =  cb-acmd.HbeMn1[ P-NROMES + 1 ] +
                                                     P-HABER1
                 cb-acmd.HbeMn2[ P-NROMES + 1 ]   = cb-acmd.HbeMn2[ P-NROMES + 1 ] +
                                                     P-HABER2.
    END. /* FIN DEL IF */
    
END. /* FIN DEL REPEAT */

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
DELETE FROM cb-acmd  WHERE   ( cb-acmd.CodCia  = s-codcia
                         AND  cb-acmd.Periodo = s-periodo 
                         ).
  
ELSE
FOR EACH cb-acmd
     WHERE cb-acmd.CodCia  = s-codcia
      AND  cb-acmd.Periodo = s-periodo :
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
FOR EACH cb-dmov
      WHERE cb-dmov.CodCia  = s-codcia AND
            cb-dmov.Periodo = s-periodo    AND
            cb-dmov.nromes  = K        
            BREAK
            BY cb-dmov.codcta
            BY cb-dmov.coddiv :
   IF FIRST-OF( cb-dmov.codcta ) THEN DO:
        mensaje2 = "Cuenta : " + cb-dmov.codcta.
        DISPLAY mensaje2 WITH FRAME f-data.
        C-DEBE1  =  0.
        C-DEBE2  =  0.
        C-HABER1 =  0.
        C-HABER2 =  0.
   END.
   IF FIRST-OF( cb-dmov.coddiv ) THEN DO:
        mensaje3 = "Divisi¢n : " + cb-dmov.coddiv.
        DISPLAY mensaje3 WITH FRAME f-data.
        D-DEBE1  =  0.
        D-DEBE2  =  0.
        D-HABER1 =  0.
        D-HABER2 =  0.
   END.
   IF cb-dmov.TPOMOV THEN DO:
      D-HABER1 = D-HABER1 + cb-dmov.IMPMN1.
      D-HABER2 = D-HABER2 + cb-dmov.IMPMN2.
      C-HABER1 = C-HABER1 + cb-dmov.IMPMN1.
      C-HABER2 = C-HABER2 + cb-dmov.IMPMN2.
   END.
   ELSE DO:
      D-DEBE1  = D-DEBE1 + cb-dmov.IMPMN1.
      D-DEBE2  = D-DEBE2 + cb-dmov.IMPMN2.
      C-DEBE1  = C-DEBE1 + cb-dmov.IMPMN1.
      C-DEBE2  = C-DEBE2 + cb-dmov.IMPMN2.
   END.
   IF LAST-OF( cb-dmov.coddiv ) THEN DO:
      IF cb-dmov.CODDIV <> "" THEN 
      RUN ACUM-1 ( cb-dmov.codcia,
                   cb-dmov.periodo,
                   cb-dmov.nromes,
                   cb-dmov.codcta,
                   cb-dmov.coddiv,
                   d-debe1,
                   d-debe2,
                   d-haber1,
                   d-haber2 ). 
   END.
   IF LAST-OF( cb-dmov.codcta ) THEN DO:
      RUN ACUM-2 ( cb-dmov.codcia,
                   cb-dmov.periodo,
                   cb-dmov.nromes,
                   cb-dmov.codcta,
                   c-debe1,
                   c-debe2,
                   c-haber1,
                   c-haber2 ). 
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
  ENABLE RECT-1 EDITOR-1 RECT-2 B-acepta C-1 C-2 B-Cancel T-BORRA 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mensual DIALOG-1 
PROCEDURE mensual :
/* Borrando Movimientos anteriores */
x-status = SESSION:SET-WAIT-STATE("GENERAL").
SESSION:IMMEDIATE-DISPLAY = NO.
STATUS INPUT OFF.
PAUSE 0.
DISPLAY "Borrando movimientos Anteriores" @ pinta-mes  WITH FRAME f-data.
FOR EACH integral.cb-acmd
     WHERE integral.cb-acmd.CodCia  = s-codcia
      AND  integral.cb-acmd.Periodo = s-periodo :
    ASSIGN integral.cb-acmd.DbeMn1[ s-NroMes + 1 ] = 0     
           integral.cb-acmd.HbeMn1[ s-NroMes + 1 ] = 0
           integral.cb-acmd.DbeMn2[ s-NroMes + 1 ] = 0     
           integral.cb-acmd.HbeMn2[ s-NroMes + 1 ] = 0.
     
END.
RUN bin/_mes.p ( INPUT s-NroMes , 3,  OUTPUT pinta-mes ).
pinta-mes = pinta-mes + ", " + STRING( s-periodo , "9999" ).
DISPLAY pinta-mes WITH FRAME f-data.
    
/* actualizando acumulados */
FOR EACH integral.cb-dmov
      WHERE integral.cb-dmov.CodCia  = s-codcia
        AND integral.cb-dmov.Periodo = s-periodo
        AND integral.cb-dmov.NroMes  = s-NroMes :
    RUN cbd/cb-acmd.p ( RECID( integral.cb-dmov ), YES, NO).
END.
x-status = SESSION:SET-WAIT-STATE("").
HIDE FRAME f-data.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


