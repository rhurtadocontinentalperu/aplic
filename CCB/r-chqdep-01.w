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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.

/* Variables compartidas */
DEFINE NEW SHARED VAR s-pagina-final AS INTEGER.
DEFINE NEW SHARED VAR s-pagina-inicial AS INTEGER.
DEFINE NEW SHARED VAR s-salida-impresion AS INTEGER.
DEFINE NEW SHARED VAR s-printer-name AS CHAR.
DEFINE NEW SHARED VAR s-print-file AS CHAR.
DEFINE NEW SHARED VAR s-nro-copias AS INTEGER.
DEFINE NEW SHARED VAR s-orientacion AS INTEGER.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Fecha FILL-IN-Fecha-2 BTN_Ok ~
BTN_Exit RECT-1 RECT-2 BTN_Excel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha FILL-IN-Fecha-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BTN_Excel AUTO-GO 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Imprimir" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BTN_Exit AUTO-END-KEY DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Salir" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BTN_Ok AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Imprimir" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE FILL-IN-Fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 2.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 2.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-Fecha AT ROW 2.15 COL 12 COLON-ALIGNED
     FILL-IN-Fecha-2 AT ROW 2.15 COL 30 COLON-ALIGNED
     BTN_Ok AT ROW 4.27 COL 3
     BTN_Exit AT ROW 4.27 COL 19
     BTN_Excel AT ROW 4.27 COL 35 WIDGET-ID 2
     " Fecha de Vencimiento" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 1.19 COL 4
     RECT-1 AT ROW 1.38 COL 2
     RECT-2 AT ROW 3.88 COL 2
     SPACE(0.85) SKIP(0.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte Cheques por Depositar".


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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte Cheques por Depositar */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BTN_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BTN_Excel D-Dialog
ON CHOOSE OF BTN_Excel IN FRAME D-Dialog /* Imprimir */
DO:
    ASSIGN
            FILL-IN-Fecha
            FILL-IN-Fecha-2.
    IF FILL-IN-Fecha = ? THEN FILL-IN-Fecha = TODAY.
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BTN_Ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BTN_Ok D-Dialog
ON CHOOSE OF BTN_Ok IN FRAME D-Dialog /* Imprimir */
DO:
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
  DISPLAY FILL-IN-Fecha FILL-IN-Fecha-2 
      WITH FRAME D-Dialog.
  ENABLE FILL-IN-Fecha FILL-IN-Fecha-2 BTN_Ok BTN_Exit RECT-1 RECT-2 BTN_Excel 
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
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
ASSIGN
    chWorkSheet:Range("A1"):Value = CAPS(s-nomcia) + " - REPORTE DE CHEQUES POR DEPOSITAR" 
    chWorkSheet:Range("A2"):Value = "DEL " + STRING(FILL-IN-Fecha,"99/99/9999") + " AL " + STRING(FILL-IN-Fecha-2,"99/99/9999")
    chWorkSheet:Range("A3"):Value = "Div."
    chWorkSheet:Range("B3"):Value = "Doc."
    chWorkSheet:Range("C3"):Value = "Cheque"
    chWorkSheet:Range("D3"):Value = "Banco"
    chWorkSheet:Range("E3"):Value = "Cliente"
    chWorkSheet:Range("F3"):Value = "Nombre / Rasón Social"
    chWorkSheet:Range("G3"):Value = "Fecha Doc."
    chWorkSheet:Range("H3"):Value = "Vencimiento"
    chWorkSheet:Range("I3"):Value = "Mon"
    chWorkSheet:Range("J3"):Value = "Importe"
    chWorkSheet:Range("K3"):Value = "Saldo"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Columns("C"):NumberFormat = "@"
    chWorkSheet:Columns("D"):NumberFormat = "@"
    chWorkSheet:Columns("E"):NumberFormat = "@"
    chWorkSheet:Columns("G"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Columns("H"):NumberFormat = "dd/mm/yyyy"
    .
ASSIGN
    t-Row = 3.
FOR EACH Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-CodCia
    AND CcbCDocu.FlgEst = 'P'
    AND CcbCDocu.FchVto >= FILL-IN-Fecha
    AND CcbCDocu.FchVto <= FILL-IN-Fecha-2
    AND CcbCDocu.CodDoc = 'CHC',
    EACH Ccbccaja NO-LOCK WHERE Ccbccaja.codcia = Ccbcdocu.codcia
    AND Ccbccaja.coddoc = Ccbcdocu.codref
    AND Ccbccaja.nrodoc = Ccbcdocu.nroref:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.CodDiv.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.CodDoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.NroDoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbccaja.CodBco[2] + Ccbccaja.CodBco[3].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.CodCli.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbcdocu.NomCli.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchDoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchVto.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF CcbCDocu.CodMon = 1 THEN 'S/.' ELSE 'US$').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.ImpTot.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.SdoAct.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.





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

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            FILL-IN-Fecha
            FILL-IN-Fecha-2.
    END.

    IF FILL-IN-Fecha = ? THEN FILL-IN-Fecha = TODAY.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl"
        RB-REPORT-NAME = "CHEQUES POR DEPOSITAR"
        RB-INCLUDE-RECORDS = "O"
        RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia
        RB-FILTER =
            "CcbCDocu.CodCia = " + STRING(s-CodCia) +
            " AND CcbCDocu.CodDiv >= ''" +
            " AND CcbCDocu.FlgEst = 'P'" +
            " AND CcbCDocu.FchVto >= " +
                STRING(MONTH(FILL-IN-Fecha)) + "/" +
                STRING(DAY(FILL-IN-Fecha)) + "/" +
                STRING(YEAR(FILL-IN-Fecha)) +
            " AND CcbCDocu.FchVto <= " +
                STRING(MONTH(FILL-IN-Fecha-2)) + "/" +
                STRING(DAY(FILL-IN-Fecha-2)) + "/" +
                STRING(YEAR(FILL-IN-Fecha-2)) +
            " AND CcbCDocu.CodDoc = 'CHC'".

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

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
  ASSIGN
    FILL-IN-Fecha = TODAY
    FILL-IN-Fecha-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

