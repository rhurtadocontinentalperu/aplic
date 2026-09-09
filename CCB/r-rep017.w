&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

DEF VAR s-task-no AS INT NO-UNDO.
DEF SHARED VAR cl-codcia AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK FILL-IN-TpoCmb Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-TpoCmb 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-TpoCmb AS DECIMAL FORMAT ">>>,>>9.9999":U INITIAL 0 
     LABEL "Tipo de Cambio" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_OK AT ROW 1.5 COL 52
     FILL-IN-TpoCmb AT ROW 2.35 COL 21 COLON-ALIGNED
     Btn_Cancel AT ROW 2.69 COL 52
     SPACE(1.13) SKIP(1.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "INFORME GERENCIAL CUENTAS POR COBRAR"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* INFORME GERENCIAL CUENTAS POR COBRAR */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN
    FILL-IN-TpoCmb.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal D-Dialog 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  FOR EACH w-report WHERE w-report.task-no = s-task-no:
      DELETE w-report.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Llave-C AS CHAR NO-UNDO.
  DEF VAR x-Llave   AS CHAR NO-UNDO.
  DEF VAR x-Dias    AS INTE NO-UNDO.
  DEF VAR x-Signo   AS INTE NO-UNDO.
  
  REPEAT:
    s-task-no = RANDOM(1,999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN LEAVE.
  END.
  
  FOR EACH CcbCDocu NO-LOCK WHERE CcbCDocu.codcia = s-codcia
        AND LOOKUP(CcbCDocu.coddoc, 'FAC,BOL,N/C,N/D,CHQ,LET,A/R,BD') > 0
        AND CcbCDocu.flgest = 'P',
        FIRST Gn-clie NO-LOCK WHERE Gn-clie.codcia = cl-codcia
            AND Gn-clie.codcli = Ccbcdocu.codcli,
        FIRST Gn-divi OF Ccbcdocu NO-LOCK,
        FIRST Facdocum OF Ccbcdocu NO-LOCK:
    DISPLAY
        Ccbcdocu.coddoc Ccbcdocu.nrodoc SKIP
        WITH FRAME f-Mensaje TITLE 'Procesando Informacion' VIEW-AS DIALOG-BOX
            CENTERED OVERLAY NO-LABELS.
    x-Signo = IF Facdocum.TpoDoc = NO THEN -1 ELSE 1.
    IF Ccbcdocu.coddiv = '00000' THEN DO:       /* ATE */
        x-Llave-c = 'Ate'.
        CASE Gn-clie.canal:
            WHEN '0001'                THEN x-Llave = 'Empresas Estatales'.
            WHEN '0002' OR WHEN '0003' THEN x-Llave = 'Empresas Privadas'.
            WHEN '0005' OR WHEN '0007' THEN x-Llave = 'Provincia'.
            WHEN '0008'                THEN x-Llave = 'Supermercado'.
            OTHERWISE x-Llave = '* Otros Ate'.
        END CASE.
    END.
    IF Ccbcdocu.coddiv <> '00000' THEN DO:      /* TIENDAS */
        x-Llave-c = 'Lima'.
        CASE Gn-divi.coddiv:
            WHEN '00001' OR WHEN '00002' OR WHEN '00003' OR WHEN '00014'
                OR WHEN '00015' THEN x-Llave = GN-DIVI.DesDiv.
            OTHERWISE x-LLave = '* Otros Lima'.
        END CASE.
    END.
    FIND w-report WHERE w-report.task-no = s-task-no
        AND w-report.llave-c = x-Llave-c
        AND w-report.campo-c[1] = x-Llave
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-c = x-llave-c
        w-report.campo-c[1] = x-llave.
    /* Dias de Vencimiento */
    x-Dias = TODAY - Ccbcdocu.fchvto.
    IF x-Dias < 0 THEN DO:      /* POR VENCER */
        IF Ccbcdocu.codmon = 1
        THEN w-report.campo-f[1] = w-report.campo-f[1] + Ccbcdocu.sdoact * x-Signo.
        ELSE w-report.campo-f[2] = w-report.campo-f[2] + Ccbcdocu.sdoact * x-Signo.
        NEXT.
    END.
    /* VENCIDAS */
    IF x-Dias <= 30 THEN DO:
        IF Ccbcdocu.codmon = 1
        THEN w-report.campo-f[3] = w-report.campo-f[3] + Ccbcdocu.sdoact * x-Signo.
        ELSE w-report.campo-f[4] = w-report.campo-f[4] + Ccbcdocu.sdoact * x-Signo.
    END.
    IF x-Dias > 30 AND x-Dias <= 90 THEN DO:
        IF Ccbcdocu.codmon = 1
        THEN w-report.campo-f[5] = w-report.campo-f[5] + Ccbcdocu.sdoact * x-Signo.
        ELSE w-report.campo-f[6] = w-report.campo-f[6] + Ccbcdocu.sdoact * x-Signo.
    END.
    IF x-Dias > 90 AND x-Dias <= 180 THEN DO:
        IF Ccbcdocu.codmon = 1
        THEN w-report.campo-f[7] = w-report.campo-f[7] + Ccbcdocu.sdoact * x-Signo.
        ELSE w-report.campo-f[8] = w-report.campo-f[8] + Ccbcdocu.sdoact * x-Signo.
    END.
    IF x-Dias > 180 AND x-Dias <= 360 THEN DO:
        IF Ccbcdocu.codmon = 1
        THEN w-report.campo-f[9] = w-report.campo-f[9] + Ccbcdocu.sdoact * x-Signo.
        ELSE w-report.campo-f[10] = w-report.campo-f[10] + Ccbcdocu.sdoact * x-Signo.
    END.
    IF x-Dias > 360 THEN DO:
        IF Ccbcdocu.codmon = 1
        THEN w-report.campo-f[11] = w-report.campo-f[11] + Ccbcdocu.sdoact * x-Signo.
        ELSE w-report.campo-f[12] = w-report.campo-f[12] + Ccbcdocu.sdoact * x-Signo.
    END.
    IF Ccbcdocu.codmon = 1
    THEN w-report.campo-f[13] = w-report.campo-f[13] + Ccbcdocu.sdoact * x-Signo.
    ELSE w-report.campo-f[14] = w-report.campo-f[14] + Ccbcdocu.sdoact * x-Signo.
  END.        
  HIDE FRAME f-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-TpoCmb 
      WITH FRAME D-Dialog.
  ENABLE Btn_OK FILL-IN-TpoCmb Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir D-Dialog 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */


  RUN Carga-Temporal.
  FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
  IF NOT AVAILABLE w-report THEN DO:
        MESSAGE 'No hay registros a imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
  END.

  GET-KEY-VALUE SECTION 'Startup' KEY 'Base' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'.
  RB-REPORT-NAME = 'Resumen Gerencial'.
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~ns-tpocmb = " + STRING(FILL-IN-TpoCmb).
  RUN lib/_Imprime2 ( RB-REPORT-LIBRARY,
                        RB-REPORT-NAME,
                        RB-INCLUDE-RECORDS,
                        RB-FILTER,
                        RB-OTHER-PARAMETERS).

  RUN Borra-Temporal.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND LAST Gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-tcmb THEN FILL-IN-TpoCmb = gn-tcmb.venta.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

