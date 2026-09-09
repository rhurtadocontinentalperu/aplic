&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{cbd/cbglobal.i}

DEF SHARED VAR s-codcia AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK COMBO-BOX-Periodo COMBO-BOX-Cco ~
RADIO-SET-Moneda Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-Cco ~
RADIO-SET-Moneda 

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

DEFINE VARIABLE COMBO-BOX-Cco AS CHARACTER FORMAT "X(256)":U 
     LABEL "Centro de Costo" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS " "
     SIZE 39 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Moneda AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 16 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_OK AT ROW 4.65 COL 8
     COMBO-BOX-Periodo AT ROW 1.38 COL 13 COLON-ALIGNED
     COMBO-BOX-Cco AT ROW 2.35 COL 13 COLON-ALIGNED
     RADIO-SET-Moneda AT ROW 3.31 COL 15 NO-LABEL
     Btn_Cancel AT ROW 4.65 COL 25
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.31 COL 9
     SPACE(50.13) SKIP(3.22)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "GASTOS POR CENTRO DE COSTO ANUAL"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* GASTOS POR CENTRO DE COSTO ANUAL */
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
  ASSIGN COMBO-BOX-Cco COMBO-BOX-Periodo RADIO-SET-Moneda.
  RUN Excel.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-Periodo COMBO-BOX-Cco RADIO-SET-Moneda 
      WITH FRAME D-Dialog.
  ENABLE Btn_OK COMBO-BOX-Periodo COMBO-BOX-Cco RADIO-SET-Moneda Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel D-Dialog 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER.
DEFINE VARIABLE lCount                  AS LOGICAL.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.

DEFINE VARIABLE x-ImpMn1                AS DEC NO-UNDO.
DEFINE VARIABLE x-ImpMn2                AS DEC NO-UNDO.
DEFINE VARIABLE x-TotMn1                AS DEC NO-UNDO.
DEFINE VARIABLE x-TotMn2                AS DEC NO-UNDO.
DEFINE VARIABLE x-Meses                 AS CHAR NO-UNDO.
DEFINE VARIABLE i-Mes                   AS INT NO-UNDO.
DEFINE VARIABLE x-Cco                   AS CHAR NO-UNDO.

x-Cco = TRIM(SUBSTRING(COMBO-BOX-Cco,1,5)).

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 10.
chWorkSheet:Columns("B"):ColumnWidth = 50.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 10.
chWorkSheet:Columns("E"):ColumnWidth = 10.
chWorkSheet:Columns("F"):ColumnWidth = 10.
chWorkSheet:Columns("G"):ColumnWidth = 10.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 10.
chWorkSheet:Columns("J"):ColumnWidth = 10.
chWorkSheet:Columns("K"):ColumnWidth = 10.
chWorkSheet:Columns("L"):ColumnWidth = 10.
chWorkSheet:Columns("M"):ColumnWidth = 10.
chWorkSheet:Columns("N"):ColumnWidth = 10.

chWorkSheet:Range("B1"):Value = "GASTOS POR CENTRO DE COSTO ANUAL - " + 
                            IF RADIO-SET-Moneda = 1 THEN 'NUEVOS SOLES' ELSE 'DOLARES AMERICANOS'.
chWorkSheet:Range("B2"):Value = "CENTRO DE COSTO: " + COMBO-BOX-Cco.
chWorkSheet:Range("B3"):Value = "PERIODO " + STRING(COMBO-BOX-Periodo, '9999').

chWorkSheet:Range("A4"):Value = "Cuenta".
chWorkSheet:Range("B4"):Value = "Descripcion".
chWorkSheet:Range("C4"):Value = "ENERO".
chWorkSheet:Range("D4"):Value = "FEBRERO".
chWorkSheet:Range("E4"):Value = "MARZO".
chWorkSheet:Range("F4"):Value = "ABRIL".
chWorkSheet:Range("G4"):Value = "MAYO".
chWorkSheet:Range("H4"):Value = "JUNIO".
chWorkSheet:Range("I4"):Value = "JULIO".
chWorkSheet:Range("J4"):Value = "AGOSTO".
chWorkSheet:Range("K4"):Value = "SETIEMBRE".
chWorkSheet:Range("L4"):Value = "OCTUBRE".
chWorkSheet:Range("M4"):Value = "NOVIEMBRE".
chWorkSheet:Range("N4"):Value = "DICIEMBRE".

FOR EACH CB-CTAS NO-LOCK WHERE CB-CTAS.codcia = cb-codcia
        AND cb-ctas.codcta BEGINS '9'
        AND LENGTH(TRIM(cb-ctas.codcta)) = cb-maxnivel:
    /* veamos si hay importes que imprimir */
    ASSIGN
        x-TotMn1 = 0
        x-TotMn2 = 0.
    FOR EACH CB-DMOV NO-LOCK WHERE cb-dmov.codcia = s-codcia
            AND cb-dmov.periodo = COMBO-BOX-Periodo
            AND cb-dmov.codcta  = cb-ctas.codcta
            AND cb-dmov.nromes  >= 01
            AND cb-dmov.nromes  <= 12
            AND cb-dmov.cco     = x-Cco:
        IF cb-dmov.TpoMov = NO
        THEN ASSIGN
                x-TotMn1 = x-TotMn1 + cb-dmov.impmn1
                x-TotMn2 = x-TotMn2 + cb-dmov.impmn2.
        ELSE ASSIGN
                x-TotMn1 = x-TotMn1 - cb-dmov.impmn1
                x-TotMn2 = x-TotMn2 - cb-dmov.impmn2.
    END.
    IF RADIO-SET-Moneda = 1 AND x-TotMn1 = 0 THEN NEXT.
    IF RADIO-SET-Moneda = 2 AND x-TotMn2 = 0 THEN NEXT.
    /* *********************************** */
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + cb-ctas.codcta.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = cb-ctas.nomcta.
    iCount = ASC("C").
    lCount = NO.
    /* ACUMULAMOS POR CUENTA Y POR CENTRO DE COSTOS */
    DO i-Mes = 1 TO 12:
        IF lCount = NO
        THEN cRange = CHR(iCount) + cColumn.
        ELSE cRange = "A" + CHR(iCount) + cColumn.
        ASSIGN  
            x-ImpMn1 = 0
            x-ImpMn2 = 0.
        FOR EACH CB-DMOV NO-LOCK WHERE cb-dmov.codcia = s-codcia
                AND cb-dmov.periodo = COMBO-BOX-Periodo
                AND cb-dmov.nromes  = i-Mes
                AND cb-dmov.codcta  = cb-ctas.codcta
                AND cb-dmov.cco     = x-Cco:
            IF cb-dmov.TpoMov = NO
            THEN ASSIGN
                    x-ImpMn1 = x-ImpMn1 + cb-dmov.impmn1
                    x-ImpMn2 = x-ImpMn2 + cb-dmov.impmn2.
            ELSE ASSIGN
                    x-ImpMn1 = x-ImpMn1 - cb-dmov.impmn1
                    x-ImpMn2 = x-ImpMn2 - cb-dmov.impmn2.
        END.
        IF RADIO-SET-Moneda = 1
        THEN chWorkSheet:Range(cRange):Value = x-ImpMn1.
        ELSE chWorkSheet:Range(cRange):Value = x-ImpMn2.
        iCount = iCount + 1.
        IF iCount > 90 
        THEN ASSIGN
                iCount = ASC("A")
                lCount = YES.
    END.
END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
  DEF VAR x-Periodos AS CHAR INIT '' NO-UNDO.
  FOR EACH CB-PERI NO-LOCK WHERE cb-peri.codcia = s-codcia 
        BREAK BY cb-peri.codcia:
    IF FIRST-OF(cb-peri.codcia)
    THEN x-Periodos = STRING(cb-peri.periodo, '9999').
    ELSE x-Periodos = x-Periodos + ',' + STRING(cb-peri.periodo, '9999').
  END.

  DEF VAR x-Cco AS CHAR INIT '' NO-UNDO.
  FOR EACH CB-AUXI NO-LOCK WHERE cb-auxi.codcia = cb-codcia 
        AND cb-auxi.clfaux = 'CCO'
        BREAK BY cb-auxi.codcia:
    IF FIRST-OF(cb-auxi.codcia)
    THEN x-Cco = STRING(cb-auxi.codaux, 'x(5)') + cb-auxi.nomaux.
    ELSE x-Cco = x-Cco + ',' + STRING(cb-auxi.codaux, 'x(5)') + cb-auxi.nomaux.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    COMBO-BOX-Periodo:LIST-ITEMS = x-Periodos.
    COMBO-BOX-Periodo:SCREEN-VALUE = STRING(s-Periodo, '9999').
    COMBO-BOX-Cco:LIST-ITEMS = x-Cco.
    COMBO-BOX-Cco:SCREEN-VALUE = COMBO-BOX-Cco:ENTRY(2).
  END.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
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


