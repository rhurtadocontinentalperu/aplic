&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-DOC NO-UNDO LIKE FacDocum.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEF VAR cEstado AS CHAR NO-UNDO.
DEF VAR x-estado AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-DOC

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 T-DOC.CodDoc T-DOC.NomDoc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH T-DOC NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH T-DOC NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 T-DOC
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 T-DOC


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodDiv FILL-IN-CodCli ~
FILL-IN-Desde FILL-IN-Hasta BROWSE-1 r-selec t-cobrdudo BUTTON-4 BUTTON-5 ~
BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDiv FILL-IN-NomDiv ~
FILL-IN-CodCli FILL-IN-NomCli FILL-IN-Desde FILL-IN-Hasta r-selec ~
t-cobrdudo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 9.14 BY 1.54.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 4" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 5" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division ORIGEN" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Desde AS DATE FORMAT "99/99/99":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Hasta AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE r-selec AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Seleccionar Todo", 1,
"Deseleccionar Todo", 2
     SIZE 17 BY 1.38 NO-UNDO.

DEFINE VARIABLE t-cobrdudo AS LOGICAL INITIAL yes 
     LABEL "Incluir Cobranza Dudosa" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      T-DOC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      T-DOC.CodDoc FORMAT "x(5)":U
      T-DOC.NomDoc FORMAT "X(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS MULTIPLE SIZE 50 BY 12.88
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodDiv AT ROW 1.38 COL 12 COLON-ALIGNED
     FILL-IN-NomDiv AT ROW 1.38 COL 23 COLON-ALIGNED NO-LABEL
     FILL-IN-CodCli AT ROW 2.35 COL 12 COLON-ALIGNED
     FILL-IN-NomCli AT ROW 2.35 COL 25 COLON-ALIGNED NO-LABEL
     FILL-IN-Desde AT ROW 3.31 COL 12 COLON-ALIGNED
     FILL-IN-Hasta AT ROW 3.31 COL 27 COLON-ALIGNED
     BROWSE-1 AT ROW 4.46 COL 14
     r-selec AT ROW 4.5 COL 65 NO-LABEL WIDGET-ID 2
     t-cobrdudo AT ROW 6.12 COL 65 WIDGET-ID 8
     BUTTON-4 AT ROW 18.31 COL 5
     BUTTON-5 AT ROW 18.31 COL 22
     BUTTON-2 AT ROW 18.31 COL 38.86 WIDGET-ID 6
     "Documento:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 4.46 COL 5
     "Seleccione un o mas documentos con un clic" VIEW-AS TEXT
          SIZE 32 BY .5 AT ROW 17.35 COL 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85 BY 19.15
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DOC T "?" NO-UNDO INTEGRAL FacDocum
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "DOCUMENTOS PENDIENTES POR CLIENTE"
         HEIGHT             = 19.15
         WIDTH              = 85
         MAX-HEIGHT         = 19.15
         MAX-WIDTH          = 85
         VIRTUAL-HEIGHT     = 19.15
         VIRTUAL-WIDTH      = 85
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB BROWSE-1 FILL-IN-Hasta F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomDiv IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.T-DOC"
     _FldNameList[1]   > Temp-Tables.T-DOC.CodDoc
"T-DOC.CodDoc" ? "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-DOC.NomDoc
"T-DOC.NomDoc" ? "X(50)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* DOCUMENTOS PENDIENTES POR CLIENTE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* DOCUMENTOS PENDIENTES POR CLIENTE */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN 
    COMBO-BOX-CodDiv FILL-IN-CodCli FILL-IN-Desde 
    FILL-IN-Hasta FILL-IN-NomCli FILL-IN-NomDiv t-cobrdudo.
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:  
  ASSIGN 
    COMBO-BOX-CodDiv FILL-IN-CodCli FILL-IN-Desde 
    FILL-IN-Hasta FILL-IN-NomCli FILL-IN-NomDiv t-cobrdudo.
/*  IF FILL-IN-NomCli = '' 
 *   THEN DO:
 *     MESSAGE 'Ingrese el codigo del cliente' VIEW-AS ALERT-BOX ERROR.
 *     APPLY 'ENTRY':U TO FILL-IN-CodCli.
 *     RETURN NO-APPLY.
 *   END.*/
  IF FILL-IN-CodCli <> ''
  THEN DO:
    FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = FILL-IN-CodCli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE GN-CLIE
    THEN DO:
        MESSAGE 'Cliente no registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN-CodCli.
        RETURN NO-APPLY.
    END.
  END.
  
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0
  THEN DO:
    MESSAGE 'Debe seleccionar al menos un documento' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO {&BROWSE-NAME}.
    RETURN NO-APPLY.
  END.
  IF FILL-IN-Desde = ? OR FILL-IN-Hasta = ?
  THEN DO:
    MESSAGE 'Debe ingresar ambas fechas' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO FILL-IN-Desde.
    RETURN NO-APPLY.
  END.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodDiv W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodDiv IN FRAME F-Main /* Division ORIGEN */
DO:
  FILL-IN-NomDiv:SCREEN-VALUE = ''.
  FIND GN-DIVI WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE GN-DIVI
  THEN FILL-IN-NomDiv:SCREEN-VALUE = gn-divi.desdiv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
  FILL-IN-NomCli:SCREEN-VALUE = ''.
  FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CLIE THEN FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME r-selec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-selec W-Win
ON VALUE-CHANGED OF r-selec IN FRAME F-Main
DO:
    DEFINE VARIABLE i AS INTEGER NO-UNDO.
    ASSIGN r-selec.    
    CASE r-selec:
        WHEN 1 THEN 
            {&BROWSE-NAME}:SELECT-ALL().
        WHEN 2 THEN 
            {&BROWSE-NAME}:DESELECT-ROWS().
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-CodDiv FILL-IN-NomDiv FILL-IN-CodCli FILL-IN-NomCli 
          FILL-IN-Desde FILL-IN-Hasta r-selec t-cobrdudo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-CodDiv FILL-IN-CodCli FILL-IN-Desde FILL-IN-Hasta BROWSE-1 
         r-selec t-cobrdudo BUTTON-4 BUTTON-5 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose: Salida a Excel 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    DEFINE VARIABLE x-CodDiv AS CHAR.
    DEFINE VARIABLE x-CodDoc AS CHAR.
    DEFINE VARIABLE i AS INTEGER.
    DEFINE VARIABLE x-Moneda AS CHARACTER.
    DEFINE VARIABLE x-SaldoMn AS DECIMAL.
    DEFINE VARIABLE x-SaldoMe AS DECIMAL.
    DEFINE VARIABLE x-credito AS DECIMAL NO-UNDO.    

    x-CodDiv = COMBO-BOX-CodDiv:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    IF x-CodDiv = 'Todas'
        THEN x-CodDiv = COMBO-BOX-CodDiv:LIST-ITEMS IN FRAME {&FRAME-NAME}.

    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
            IF i = 1 THEN x-CodDoc = T-DOC.coddoc.
            ELSE x-CodDoc = x-CodDoc + ',' + T-DOC.coddoc.
        END.
    END.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "REPORTE DE DOCUMENTOS PENDIENTES POR CLIENTE".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "DIVISIÓN(es): ".

    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = x-CodDiv.

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOCUMENTO(s): ".
    
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = x-CodDoc.

    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cliente".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nombre o Razón Social".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Division".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Doc".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Número".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Emisión".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Vencimiento".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Dias Retraso".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Línea Crédito".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Vend".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Mon".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo S/.".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo $".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "Condición".
    iCount = iCount + 1.

    IF t-cobrdudo THEN cEstado = "P,J". ELSE cEstado = "P".

    FOR EACH CcbCDocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.codcli BEGINS FILL-IN-CodCli
        AND LOOKUP(TRIM(ccbcdocu.coddoc), x-CodDoc) > 0
        /*AND LOOKUP(TRIM(ccbcdocu.coddiv), x-CodDiv) > 0*/
        AND LOOKUP(TRIM(ccbcdocu.DivOri), x-CodDiv) > 0
        AND ccbcdocu.fchdoc >= FILL-IN-Desde
        AND ccbcdocu.fchdoc <= FILL-IN-Hasta
        AND LOOKUP(ccbcdocu.flgest,cEstado) > 0
        BREAK BY ccbcdocu.codcli:

        IF ccbcdocu.flgest = "P" THEN x-estado = "P".
        ELSE x-estado = "CD".

        IF ccbcdocu.codmon = 1 THEN 
            ASSIGN
                x-Moneda = 'S/'
                x-SaldoMn = ccbcdocu.sdoact
                x-SaldoMe = 0.
        ELSE ASSIGN
            x-Moneda = 'US$'
            x-SaldoMe = ccbcdocu.sdoact
            x-SaldoMn = 0.
        ACCUMULATE x-SaldoMe (TOTAL BY ccbcdocu.codcli).
        ACCUMULATE x-SaldoMn (TOTAL BY ccbcdocu.codcli).

        FIND FIRST gn-clie WHERE gn-clie.CodCia = ccbcdocu.codcia
            AND gn-clie.CodCli = ccbcdocu.codcli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN x-credito = gn-clie.ImpLC. ELSE x-credito = 0. 
        
        FIND FIRST facdocum 
            WHERE facdocum.codcia = ccbcdocu.codcia
            AND facdocum.coddoc = ccbcdocu.coddoc NO-LOCK NO-ERROR.
        IF AVAILABLE facdocum AND facdocum.tpodoc = NO THEN
            ASSIGN
                x-SaldoMe = - 1 * x-SaldoMe
                x-SaldoMn = - 1 * x-SaldoMn.

        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.codcli.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.nomcli.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.coddiv.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.coddoc.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.nrodoc.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.fchdoc.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.FchVto.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = (ccbcdocu.FchVto - ccbcdocu.fchdoc) * -1.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = x-credito.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = TODAY.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.codven.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = x-Moneda.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.imptot.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = x-SaldoMn.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = x-SaldoMe.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = x-estado.
        iCount = iCount + 1.
  END.

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-CodDiv AS CHAR.
  DEF VAR x-CodDoc AS CHAR.
  DEF VAR i AS INTE.
  
  IF COMBO-BOX-CodDiv = 'Todas'
  THEN x-CodDiv = COMBO-BOX-CodDiv:LIST-ITEMS IN FRAME {&FRAME-NAME}.
  ELSE x-CodDiv = COMBO-BOX-CodDiv.
  DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i)
    THEN DO:
        IF i = 1 
        THEN x-CodDoc = T-DOC.coddoc.
        ELSE x-CodDoc = x-CodDoc + ',' + T-DOC.coddoc.
    END.
  END.

  DEF VAR x-Moneda AS CHAR.
  DEF VAR x-SaldoMn AS DEC.
  DEF VAR x-SaldoMe AS DEC.
  
  DEFINE FRAME F-Cab
    ccbcdocu.codcli COLUMN-LABEL 'Cliente'
    ccbcdocu.nomcli COLUMN-LABEL 'Nombre o Razon Social'
    ccbcdocu.coddiv COLUMN-LABEL 'Division'
    ccbcdocu.coddoc COLUMN-LABEL 'Doc'
    ccbcdocu.nrodoc COLUMN-LABEL 'Numero'
    ccbcdocu.fchdoc COLUMN-LABEL 'Emision'
    ccbcdocu.codven COLUMN-LABEL 'Vend'
    x-Moneda        COLUMN-LABEL 'Mon'
    ccbcdocu.imptot COLUMN-LABEL 'Total'
    x-SaldoMn       COLUMN-LABEL 'Saldo S/.' FORMAT '->,>>>,>>9.99'
    x-SaldoMe       COLUMN-LABEL 'Saldo US$' FORMAT '->,>>>,>>9.99' 
    x-estado        COLUMN-LABEL 'Condición'  
    SKIP
    HEADER
        S-NOMCIA FORMAT "X(50)" SKIP
        "REPORTE DE DOCUMENTOS PENDIENTES POR CLIENTE" AT 30
        "Pag.  : " AT 120 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Fecha : " AT 120 STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        "Hora  : " AT 120 STRING(TIME,"HH:MM:SS") SKIP
        "EMITIDOS DESDE EL" FILL-IN-Desde "HASTA EL" FILL-IN-Hasta SKIP
        "DIVISION(es):" ENTRY(1, x-CodDiv) SKIP
        "DOCUMENTO(s):" x-CodDoc SKIP
    WITH WIDTH 180 NO-BOX STREAM-IO DOWN.        

  IF t-cobrdudo THEN cEstado = "P,J". 
  ELSE cEstado = "P".

  FOR EACH CcbCDocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.codcli BEGINS FILL-IN-CodCli
        AND LOOKUP(TRIM(ccbcdocu.coddoc), x-CodDoc) > 0
        /*AND LOOKUP(TRIM(ccbcdocu.coddiv), x-CodDiv) > 0*/
        AND LOOKUP(TRIM(ccbcdocu.DivOri), x-CodDiv) > 0
        AND ccbcdocu.fchdoc >= FILL-IN-Desde
        AND ccbcdocu.fchdoc <= FILL-IN-Hasta
        AND LOOKUP(ccbcdocu.flgest,cEstado) > 0
        BREAK BY ccbcdocu.codcli:

    IF ccbcdocu.flgest = "P" THEN x-estado = "P".
    ELSE x-estado = "CD".

    IF ccbcdocu.codmon = 1
    THEN ASSIGN
            x-Moneda = 'S/'
            x-SaldoMn = ccbcdocu.sdoact
            x-SaldoMe = 0.
    ELSE ASSIGN
            x-Moneda = 'US$'
            x-SaldoMe = ccbcdocu.sdoact
            x-SaldoMn = 0.
    ACCUMULATE x-SaldoMe (TOTAL BY ccbcdocu.codcli).
    ACCUMULATE x-SaldoMn (TOTAL BY ccbcdocu.codcli).
    DISPLAY STREAM REPORT
        ccbcdocu.codcli WHEN FIRST-OF(ccbcdocu.codcli)
        ccbcdocu.nomcli WHEN FIRST-OF(ccbcdocu.codcli)
        ccbcdocu.coddiv
        ccbcdocu.coddoc 
        ccbcdocu.nrodoc 
        ccbcdocu.fchdoc 
        ccbcdocu.codven 
        x-Moneda        
        ccbcdocu.imptot
        x-SaldoMn       
        x-SaldoMe       
        x-estado
        WITH FRAME F-Cab.        
    IF LAST-OF(ccbcdocu.codcli)
    THEN DO:
        UNDERLINE STREAM REPORT
            ccbcdocu.codcli 
            ccbcdocu.nomcli 
            ccbcdocu.coddiv
            ccbcdocu.coddoc 
            ccbcdocu.nrodoc 
            ccbcdocu.fchdoc 
            ccbcdocu.codven 
            x-Moneda        
            ccbcdocu.imptot
            x-SaldoMn       
            x-SaldoMe       
            WITH FRAME F-Cab.        
        DISPLAY STREAM REPORT
            ACCUM TOTAL BY ccbcdocu.codcli x-SaldoMn @ x-SaldoMn
            ACCUM TOTAL BY ccbcdocu.codcli x-SaldoMe @ x-SaldoMe
            WITH FRAME F-Cab.
        DOWN STREAM REPORT 1 WITH FRAME F-Cab.
    END.
  END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
    /* cargamos las divisiones */
    FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
        COMBO-BOX-CodDiv:ADD-LAST(gn-divi.coddiv).
    END.
    /* cargamos los documentos */
    FOR EACH FacDocum WHERE facdocum.codcia = s-codcia
            AND facdocum.tpodoc <> ? NO-LOCK:
        CREATE T-DOC.
        BUFFER-COPY FacDocum TO T-DOC.
    END.
    RUN bin/_dateif (MONTH(TODAY), YEAR(TODAY), OUTPUT FILL-IN-Desde, OUTPUT FILL-IN-Hasta).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
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
        WHEN "" THEN .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-DOC"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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

