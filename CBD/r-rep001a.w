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
{cbd/cbglobal.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 COMBO-BOX-Periodo ~
COMBO-BOX-Periodo-2 COMBO-BOX-Mes COMBO-BOX-Mes-2 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-Periodo-2 ~
COMBO-BOX-Mes COMBO-BOX-Mes-2 

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

DEFINE VARIABLE COMBO-BOX-Mes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SETIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mes-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SETIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo-2 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26 BY 2.15.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26 BY 2.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX-Periodo AT ROW 2.35 COL 10.72 COLON-ALIGNED
     COMBO-BOX-Periodo-2 AT ROW 2.35 COL 40 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-Mes AT ROW 3.31 COL 10.72 COLON-ALIGNED
     COMBO-BOX-Mes-2 AT ROW 3.31 COL 40 COLON-ALIGNED WIDGET-ID 4
     Btn_OK AT ROW 5.46 COL 33.43
     Btn_Cancel AT ROW 5.5 COL 50.43
     "Desde" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.65 COL 6 WIDGET-ID 10
          FGCOLOR 9 FONT 6
     "Hasta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.65 COL 34.43 WIDGET-ID 12
          FGCOLOR 9 FONT 6
     RECT-1 AT ROW 2.15 COL 5.72 WIDGET-ID 6
     RECT-2 AT ROW 2.15 COL 34.29 WIDGET-ID 8
     SPACE(4.84) SKIP(2.73)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "GASTOS POR CENTRO DE COSTO MENSUAL"
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* GASTOS POR CENTRO DE COSTO MENSUAL */
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
  
  ASSIGN COMBO-BOX-Mes COMBO-BOX-Periodo COMBO-BOX-Mes-2 COMBO-BOX-Periodo-2.

  DEFINE VAR lYearDesde AS INT.
  DEFINE VAR lYearHasta AS INT.
  DEFINE VAR lMesDesde AS INT.
  DEFINE VAR lMesHasta AS INT.

  lYearDesde  = COMBO-BOX-Periodo.
  lYearHasta  = COMBO-BOX-Periodo-2.
  lMesDesde   = LOOKUP(COMBO-BOX-Mes, COMBO-BOX-MES:LIST-ITEMS IN FRAME {&FRAME-NAME}).
  lMesHasta   = LOOKUP(COMBO-BOX-Mes, COMBO-BOX-MES-2:LIST-ITEMS IN FRAME {&FRAME-NAME}).

  IF lYearDesde > lYearHasta THEN DO:
      MESSAGE 'AÑO estan errados' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF lYearDesde = lYearHasta AND lMesDesde > lMesHasta THEN DO:
        MESSAGE 'MES estan errados' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
  END.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Excel.
  SESSION:SET-WAIT-STATE('').

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
  DISPLAY COMBO-BOX-Periodo COMBO-BOX-Periodo-2 COMBO-BOX-Mes COMBO-BOX-Mes-2 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 RECT-2 COMBO-BOX-Periodo COMBO-BOX-Periodo-2 COMBO-BOX-Mes 
         COMBO-BOX-Mes-2 Btn_OK Btn_Cancel 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

DEFINE VARIABLE x-ImpMn1                     AS DEC NO-UNDO.
DEFINE VARIABLE x-ImpMn2                     AS DEC NO-UNDO.
DEFINE VARIABLE x-TotMn1                     AS DEC NO-UNDO.
DEFINE VARIABLE x-TotMn2                     AS DEC NO-UNDO.

DEFINE VAR lYearDesde AS INT.
DEFINE VAR lYearHasta AS INT.
DEFINE VAR lMesDesde AS INT.
DEFINE VAR lMesHasta AS INT.
DEFINE VAR lMesIni AS INT.
DEFINE VAR lMesFin AS INT.
DEFINE VAR lMes AS INT.
DEFINE VAR lYear AS INT.
DEFINE VAR lCta3Dig AS CHAR.
DEFINE VAR lFecha AS DATE.
DEFINE VAR lTcambio AS DEC.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Range("A1"):Value = "AÑO".
chWorkSheet:Range("B1"):Value = "MES".
chWorkSheet:Range("C1"):Value = "CTA4DIG".
chWorkSheet:Range("D1"):Value = "CUENTA".
chWorkSheet:Range("E1"):Value = "CENTRO DE COSTO".
chWorkSheet:Range("F1"):Value = "CCOSTO 8DIG".
chWorkSheet:Range("G1"):Value = "S/.".
chWorkSheet:Range("H1"):Value = "US$".
chWorkSheet:Range("I1"):Value = "Tipo Cambio".

chWorkSheet:Columns("C"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".
chWorkSheet:Columns("E"):NumberFormat = "@".
chWorkSheet:Columns("F"):NumberFormat = "@".
/*chWorkSheet:Columns("I"):NumberFormat = "dd/mm/yyyy".*/

lYearDesde  = COMBO-BOX-Periodo.
lYearHasta  = COMBO-BOX-Periodo-2.
lMesDesde   = LOOKUP(COMBO-BOX-Mes, COMBO-BOX-MES:LIST-ITEMS IN FRAME {&FRAME-NAME}).
lMesHasta   = LOOKUP(COMBO-BOX-Mes-2, COMBO-BOX-MES-2:LIST-ITEMS IN FRAME {&FRAME-NAME}).

DEF BUFFER B-CB-CTAS FOR CB-CTAS.

REPEAT lYear = lYearDesde TO lYearHasta :
    lMesIni = IF (lYear = lYearDesde) THEN lMesDesde ELSE 1.
    lMesFin = IF (lYear = lYearHasta) THEN lMesHasta ELSE 12.

    REPEAT lMes = lMesIni TO lMesFin :

        FOR EACH CB-CTAS NO-LOCK WHERE CB-CTAS.codcia = cb-codcia
            AND cb-ctas.codcta BEGINS '9'
            AND LENGTH(TRIM(cb-ctas.codcta)) = cb-maxnivel:
            /* RHC 09/12/2013 ACUMULAMOS TODO, TENGA O NO CENTRO DE COSTO */
            FOR EACH CB-DMOV NO-LOCK WHERE cb-dmov.codcia = s-codcia
                AND cb-dmov.periodo = lYear 
                AND cb-dmov.nromes  = lMes 
                AND cb-dmov.codcta  = cb-ctas.codcta
                BREAK BY cb-dmov.cco:
                IF FIRST-OF(cb-dmov.cco) THEN DO:
                    ASSIGN  
                        x-ImpMn1 = 0
                        x-ImpMn2 = 0.
                END.
                IF cb-dmov.TpoMov = NO
                    THEN ASSIGN
                    x-ImpMn1 = x-ImpMn1 + cb-dmov.impmn1
                    x-ImpMn2 = x-ImpMn2 + cb-dmov.impmn2.
                ELSE ASSIGN
                    x-ImpMn1 = x-ImpMn1 - cb-dmov.impmn1
                    x-ImpMn2 = x-ImpMn2 - cb-dmov.impmn2.
                IF LAST-OF(cb-dmov.cco) AND NOT (x-ImpMn1 = 0 AND x-ImpMn2 = 0) THEN DO:
                    FIND CB-AUXI WHERE cb-auxi.codcia = cb-codcia
                        AND cb-auxi.clfaux = 'CCO'
                        AND cb-auxi.codaux = cb-dmov.cco
                        NO-LOCK NO-ERROR.
                    RUN um-ultimo-dia-mes (INPUT lYear, INPUT lMes, OUTPUT lFecha).
                    lTcambio = 0.
                    FIND LAST Gn-tccja WHERE Gn-tccja.fecha <= lFecha NO-LOCK NO-ERROR.
                    IF AVAILABLE Gn-tccja THEN lTcambio = Gn-tccja.venta.
                    lCta3Dig = substring(cb-ctas.codcta,1,3).
                    FIND FIRST b-cb-ctas WHERE b-CB-CTAS.codcia = cb-codcia 
                        AND b-CB-CTAS.codcta = lCta3Dig
                        NO-LOCK NO-ERROR.
                    t-column = t-column + 1.
                    cColumn = STRING(t-Column).
                    cRange = "A" + cColumn.
                    chWorkSheet:Range(cRange):Value = lYear.
                    cRange = "B" + cColumn.
                    chWorkSheet:Range(cRange):Value = lMes.
                    cRange = "C" + cColumn.
                    chWorkSheet:Range(cRange):Value = SUBSTRING(cb-ctas.codcta,1,3) + 
                        IF (AVAILABLE b-cb-ctas) THEN " - " + b-cb-ctas.nomcta ELSE "".
                    cRange = "D" + cColumn.
                    chWorkSheet:Range(cRange):Value = cb-ctas.codcta + ' - ' + cb-ctas.nomcta.
                    cColumn = STRING(t-Column).
                    cRange = "E" + cColumn.
                    chWorkSheet:Range(cRange):Value = (IF AVAILABLE cb-auxi THEN cb-auxi.codaux + ' - ' + cb-auxi.nomaux ELSE '').
                    cRange = "F" + cColumn.
                    chWorkSheet:Range(cRange):Value = (IF AVAILABLE cb-auxi THEN cb-auxi.libre_c01 ELSE '').
                    cRange = "G" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-ImpMn1.
                    cRange = "H" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-ImpMn2.
                    cRange = "I" + cColumn.
                    chWorkSheet:Range(cRange):Value = lTCambio.
                END.
            END.
            /* ACUMULAMOS POR CUENTA Y POR CENTRO DE COSTOS */
/*             FOR EACH CB-AUXI NO-LOCK WHERE cb-auxi.codcia = cb-codcia                                                     */
/*                 AND cb-auxi.clfaux = 'CCO'                                                                                */
/*                 AND cb-auxi.codaux <> '':                                                                                 */
/*                                                                                                                           */
/*                 ASSIGN                                                                                                    */
/*                     x-ImpMn1 = 0                                                                                          */
/*                     x-ImpMn2 = 0.                                                                                         */
/*                                                                                                                           */
/*                 FOR EACH CB-DMOV NO-LOCK WHERE cb-dmov.codcia = s-codcia                                                  */
/*                     AND cb-dmov.periodo = lYear /*COMBO-BOX-Periodo*/                                                     */
/*                     AND cb-dmov.nromes  = lMes /*LOOKUP(COMBO-BOX-Mes, COMBO-BOX-MES:LIST-ITEMS IN FRAME {&FRAME-NAME})*/ */
/*                     AND cb-dmov.codcta  = cb-ctas.codcta                                                                  */
/*                     AND cb-dmov.cco     = cb-auxi.codaux:                                                                 */
/*                                                                                                                           */
/*                     IF cb-dmov.TpoMov = NO                                                                                */
/*                         THEN ASSIGN                                                                                       */
/*                         x-ImpMn1 = x-ImpMn1 + cb-dmov.impmn1                                                              */
/*                         x-ImpMn2 = x-ImpMn2 + cb-dmov.impmn2.                                                             */
/*                     ELSE ASSIGN                                                                                           */
/*                         x-ImpMn1 = x-ImpMn1 - cb-dmov.impmn1                                                              */
/*                         x-ImpMn2 = x-ImpMn2 - cb-dmov.impmn2.                                                             */
/*                 END.                                                                                                      */
/*                 IF x-ImpMn1 = 0 AND x-ImpMn2 = 0 THEN NEXT.                                                               */
/*                                                                                                                           */
/*                 RUN um-ultimo-dia-mes (INPUT lYear, INPUT lMes, OUTPUT lFecha).                                           */
/*                                                                                                                           */
/*                 lTcambio = 0.                                                                                             */
/*                 FIND LAST Gn-tccja WHERE Gn-tccja.fecha <= lFecha NO-LOCK NO-ERROR.                                       */
/*                 IF AVAILABLE Gn-tccja THEN lTcambio = Gn-tccja.venta.                                                     */
/*                                                                                                                           */
/*                 lCta3Dig = substring(cb-ctas.codcta,1,3).                                                                 */
/*                 FIND FIRST b-cb-ctas WHERE b-CB-CTAS.codcia = cb-codcia AND b-CB-CTAS.codcta = lCta3Dig                   */
/*                     NO-LOCK NO-ERROR.                                                                                     */
/*                                                                                                                           */
/*                 t-column = t-column + 1.                                                                                  */
/*                 cColumn = STRING(t-Column).                                                                               */
/*                 cRange = "A" + cColumn.                                                                                   */
/*                 chWorkSheet:Range(cRange):Value = lYear.                                                                  */
/*                 cRange = "B" + cColumn.                                                                                   */
/*                 chWorkSheet:Range(cRange):Value = lMes.                                                                   */
/*                 cRange = "C" + cColumn.                                                                                   */
/*                 chWorkSheet:Range(cRange):Value = "'" + substring(cb-ctas.codcta,1,3) +                                   */
/*                     IF (AVAILABLE b-cb-ctas) THEN " - " + b-cb-ctas.nomcta ELSE "".                                       */
/*                 cRange = "D" + cColumn.                                                                                   */
/*                 chWorkSheet:Range(cRange):Value = cb-ctas.codcta + ' - ' + cb-ctas.nomcta.                                */
/*                 cColumn = STRING(t-Column).                                                                               */
/*                 cRange = "E" + cColumn.                                                                                   */
/*                 chWorkSheet:Range(cRange):Value = cb-auxi.codaux + ' - ' + cb-auxi.nomaux.                                */
/*                 cRange = "F" + cColumn.                                                                                   */
/*                 chWorkSheet:Range(cRange):Value = "'" + cb-auxi.libre_c01.                                                */
/*                 cRange = "G" + cColumn.                                                                                   */
/*                 chWorkSheet:Range(cRange):Value = x-ImpMn1.                                                               */
/*                 cRange = "H" + cColumn.                                                                                   */
/*                 chWorkSheet:Range(cRange):Value = x-ImpMn2.                                                               */
/*                 cRange = "I" + cColumn.                                                                                   */
/*                 chWorkSheet:Range(cRange):Value = lTCambio.                                                               */
/*             END.                                                                                                          */
        END.
    END.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    COMBO-BOX-Periodo:LIST-ITEMS = x-Periodos.
    COMBO-BOX-Periodo:SCREEN-VALUE = STRING(s-Periodo, '9999').
    COMBO-BOX-Mes:SCREEN-VALUE = COMBO-BOX-Mes:ENTRY(s-nromes).

    COMBO-BOX-Periodo-2:LIST-ITEMS = x-Periodos.
    COMBO-BOX-Periodo-2:SCREEN-VALUE = STRING(s-Periodo, '9999').
    COMBO-BOX-Mes-2:SCREEN-VALUE = COMBO-BOX-Mes-2:ENTRY(s-nromes).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-ultimo-dia-mes D-Dialog 
PROCEDURE um-ultimo-dia-mes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-Year AS INT NO-UNDO.
DEFINE INPUT PARAMETER p-Mes AS INT NO-UNDO.
DEFINE OUTPUT PARAMETER p-Fecha AS DATE NO-UNDO.

DEFINE VAR lYear AS INT.
DEFINE VAR lMes AS INT.
DEFINE VAR lFecha AS DATE.

lYear = p-year.
lMes = p-mes.

IF lMes = 12 THEN DO:
    lYear = lYear + 1.
    lMes = 1.
END.
ELSE DO:
    lMes = lMes + 1.
END.

lFecha = DATE(lMes,1,lYear).
lFecha = lFecha - 1.

p-Fecha = lFecha.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

