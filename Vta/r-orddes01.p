&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
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
DEFINE SHARED VARIABLE s-codcia AS INTEGER.
DEFINE SHARED VARIABLE s-codalm AS CHARACTER.
DEFINE SHARED VARIABLE s-nomcia AS CHARACTER.
DEFINE SHARED VARIABLE s-coddiv AS CHARACTER.

DEFINE VARIABLE x-CodDoc AS CHARACTER NO-UNDO INITIAL "O/D".

DEFINE TEMP-TABLE ttod_det NO-UNDO
    FIELDS ttod_nroped LIKE FacCPedi.NroPed COLUMN-LABEL "Número!Pedido"
    FIELDS ttod_codubi LIKE Almmmate.codubi COLUMN-LABEL "Ubicación"
    FIELDS ttod_codmat LIKE FacDPedi.codmat COLUMN-LABEL "Código!Artículo"
    FIELDS ttod_desmat LIKE Almmmatg.desmat
    FIELDS ttod_desmar LIKE Almmmatg.Desmar COLUMN-LABEL "Marca"
    FIELDS ttod_undvta LIKE FacDPedi.undvta
    FIELDS ttod_canped LIKE FacDPedi.CanPed
    INDEX idx01 IS PRIMARY ttod_codubi ttod_codmat
    INDEX idx02 ttod_codmat ttod_nroped.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHARACTER FORMAT "X(40)" NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
        SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEFINE VARIABLE cTitle AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDesAlm AS CHARACTER NO-UNDO.

cDesAlm = "ALMACEN: ".
FOR almacen FIELDS
    (almacen.codcia almacen.codalm Almacen.Descripcion) WHERE
    almacen.codcia = s-CodCia AND
    almacen.codalm = s-Codalm NO-LOCK:
    cDesAlm = cDesAlm + " " + Almacen.Descripcion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-od

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi

/* Definitions for BROWSE BROWSE-od                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-od FacCPedi.NroPed FacCPedi.CodCli ~
FacCPedi.NomCli FacCPedi.FchPed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-od 
&Scoped-define QUERY-STRING-BROWSE-od FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCia = S-CODCIA ~
 AND FacCPedi.CodDiv = s-CodDiv ~
 AND FacCPedi.CodDoc = x-CodDoc ~
 AND FacCPedi.CodAlm = s-CodAlm ~
 AND FacCPedi.FlgEst = "P" ~
 AND FacCPedi.FlgSit = "" ~
 AND FacCPedi.FchPed >= FILL-IN-fecha ~
 AND FacCPedi.FchPed <= FILL-IN-fecha-2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-od OPEN QUERY BROWSE-od FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCia = S-CODCIA ~
 AND FacCPedi.CodDiv = s-CodDiv ~
 AND FacCPedi.CodDoc = x-CodDoc ~
 AND FacCPedi.CodAlm = s-CodAlm ~
 AND FacCPedi.FlgEst = "P" ~
 AND FacCPedi.FlgSit = "" ~
 AND FacCPedi.FchPed >= FILL-IN-fecha ~
 AND FacCPedi.FchPed <= FILL-IN-fecha-2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-od FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-od FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-od}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-fecha FILL-IN-fecha-2 RADIO-SET-sort ~
BROWSE-od BUTTON-ok BUTTON-cancel BUTTON-excel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-fecha FILL-IN-fecha-2 ~
RADIO-SET-sort 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 15 BY 1.54 TOOLTIP "Cancelar".

DEFINE BUTTON BUTTON-excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 15 BY 1.5 TOOLTIP "Salida a archivo".

DEFINE BUTTON BUTTON-ok 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Aceptar" 
     SIZE 15 BY 1.54 TOOLTIP "Aceptar".

DEFINE VARIABLE FILL-IN-fecha AS DATE FORMAT "99/99/99":U 
     LABEL "Desde Fecha Pedido" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-sort AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Nro Pedido", 1,
"Nombre", 2
     SIZE 26 BY .54 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-od FOR 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-od
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-od W-Win _STRUCTURED
  QUERY BROWSE-od NO-LOCK DISPLAY
      FacCPedi.NroPed FORMAT "X(11)":U
      FacCPedi.CodCli COLUMN-LABEL "Cliente" FORMAT "x(14)":U
      FacCPedi.NomCli FORMAT "x(50)":U
      FacCPedi.FchPed COLUMN-LABEL "Fecha!Pedido" FORMAT "99/99/9999":U
            WIDTH 4.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 68 BY 15.62
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-fecha AT ROW 1.54 COL 16 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-fecha-2 AT ROW 1.54 COL 40 COLON-ALIGNED WIDGET-ID 24
     RADIO-SET-sort AT ROW 2.62 COL 18 NO-LABEL WIDGET-ID 16
     BROWSE-od AT ROW 3.96 COL 3 WIDGET-ID 100
     BUTTON-ok AT ROW 20.12 COL 24
     BUTTON-cancel AT ROW 20.12 COL 40
     BUTTON-excel AT ROW 20.12 COL 56
     "Ordenar por:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 2.62 COL 9 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 21.5
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reporte Consolidado O/D Pendientes"
         HEIGHT             = 21.5
         WIDTH              = 71.86
         MAX-HEIGHT         = 21.5
         MAX-WIDTH          = 71.86
         VIRTUAL-HEIGHT     = 21.5
         VIRTUAL-WIDTH      = 71.86
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
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-od RADIO-SET-sort F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-od
/* Query rebuild information for BROWSE BROWSE-od
     _TblList          = "INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "FacCPedi.CodCia = S-CODCIA
 AND FacCPedi.CodDiv = s-CodDiv
 AND FacCPedi.CodDoc = x-CodDoc
 AND FacCPedi.CodAlm = s-CodAlm
 AND FacCPedi.FlgEst = ""P""
 AND FacCPedi.FlgSit = """"
 AND FacCPedi.FchPed >= FILL-IN-fecha
 AND FacCPedi.FchPed <= FILL-IN-fecha-2"
     _FldNameList[1]   > INTEGRAL.FacCPedi.NroPed
"NroPed" ? "X(11)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.CodCli
"CodCli" "Cliente" "x(14)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.FacCPedi.NomCli
     _FldNameList[4]   > INTEGRAL.FacCPedi.FchPed
"FchPed" "Fecha!Pedido" ? "date" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-od */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Consolidado O/D Pendientes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Consolidado O/D Pendientes */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-cancel W-Win
ON CHOOSE OF BUTTON-cancel IN FRAME F-Main /* Cancelar */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-excel W-Win
ON CHOOSE OF BUTTON-excel IN FRAME F-Main /* Excel */
DO:
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-ok W-Win
ON CHOOSE OF BUTTON-ok IN FRAME F-Main /* Aceptar */
DO:
    RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-fecha W-Win
ON LEAVE OF FILL-IN-fecha IN FRAME F-Main /* Desde Fecha Pedido */
DO:
    RUN proc_open_query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-fecha-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-fecha-2 W-Win
ON LEAVE OF FILL-IN-fecha-2 IN FRAME F-Main /* Hasta */
DO:
    RUN proc_open_query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-sort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-sort W-Win
ON VALUE-CHANGED OF RADIO-SET-sort IN FRAME F-Main
DO:
    RUN proc_open_query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-od
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iInd AS INTEGER NO-UNDO.
    DEFINE VARIABLE lStatusReg AS LOGICAL NO-UNDO.

    FOR EACH ttod_det:
        DELETE ttod_det.
    END.

    IF BROWSE-od:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
        MESSAGE "Debe Seleccionar por lo menos un registro"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    DO iInd = 1 TO BROWSE-od:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        ASSIGN lStatusReg = BROWSE-od:FETCH-SELECTED-ROW(iInd).
        IF lStatusReg THEN DO:
            FOR EACH FacDPedi NO-LOCK WHERE
                FacDPedi.CodCia = FacCPedi.CodCia AND
                FacDPedi.CodDoc = FacCPedi.CodDoc AND
                FacDPedi.NroPed = FacCPedi.NroPed,
                FIRST almmmatg OF FacDPedi NO-LOCK,
                FIRST Almmmate WHERE
                    almmmate.codcia = facdpedi.codcia AND
                    almmmate.codmat = facdpedi.codmat AND
                    almmmate.codalm = facdpedi.almdes NO-LOCK:
                CREATE ttod_det.
                ASSIGN
                    ttod_nroped = FacCPedi.NroPed
                    ttod_codubi = Almmmate.codubi
                    ttod_codmat = FacDPedi.codmat
                    ttod_desmat = Almmmatg.desmat
                    ttod_desmar = Almmmatg.Desmar
                    ttod_undvta = FacDPedi.undvta
                    ttod_canped = FacDPedi.CanPed.
                DISPLAY
                    FacDPedi.codmat @ Fi-Mensaje
                    LABEL "  Cargando Código" FORMAT "X(13)"
                    WITH FRAME F-Proceso.
            END.
        END.
    END.
    ASSIGN lStatusReg = BROWSE-od:DESELECT-ROWS().

    HIDE FRAME F-PROCESO.

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
  DISPLAY FILL-IN-fecha FILL-IN-fecha-2 RADIO-SET-sort 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-fecha FILL-IN-fecha-2 RADIO-SET-sort BROWSE-od BUTTON-ok 
         BUTTON-cancel BUTTON-excel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    RUN carga-temporal.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:ADD().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    /* set the column names for the Worksheet */
    cTitle = "REPORTE CONSOLIDADO DE ORDENES DE DESPACHO - " + cDesAlm.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = cTitle.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "UBICACION".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "ARTICULO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "DESCRIPCION".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "MARCA".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "UND".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "CANTIDAD".

    chWorkSheet:COLUMNS("A"):NumberFormat = "@".
    chWorkSheet:COLUMNS("B"):NumberFormat = "@".
    chWorkSheet:COLUMNS("C"):ColumnWidth = 40.
    chWorkSheet:Range("A1:F2"):Font:Bold = TRUE.

    FOR EACH ttod_det NO-LOCK
        BREAK BY ttod_codubi BY ttod_codmat:
        ACCUMULATE ttod_canped (SUB-TOTAL BY ttod_codmat).
        IF LAST-OF(ttod_codmat) THEN DO:
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):VALUE = ttod_codubi.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):VALUE = ttod_codmat.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):VALUE = ttod_desmat.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):VALUE = ttod_desmar.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):VALUE = ttod_undvta.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):VALUE = ttod_canped.
            DISPLAY
                ttod_codubi @ FI-MENSAJE LABEL "  Procesando Ubicación" FORMAT "X(12)"
                WITH FRAME F-PROCESO.

        END.
    END.


    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    HIDE FRAME F-PROCESO.
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

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

    cTitle = "REPORTE CONSOLIDADO DE ORDENES DE DESPACHO - " + cDesAlm.

    DEFINE FRAME F-REPORTE
        ttod_codubi
        ttod_codmat
        ttod_desmat
        ttod_desmar
        ttod_undvta
        ttod_canped
        WITH WIDTH 250 NO-BOX STREAM-IO DOWN.

    DEFINE FRAME F-REPORTE-2
        ttod_codmat
        ttod_desmat
        ttod_desmar
        ttod_undvta
        ttod_nroped
        ttod_canped
        WITH WIDTH 250 NO-BOX STREAM-IO DOWN.

    DEFINE FRAME F-HEADER       
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + cTitle FORMAT 'x(100)'
        {&PRN3} + {&PRN6B} + "Pagina : " AT 120 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + "Fecha : " AT 100 STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)"
        {&PRN4} + "Hora  : " AT 120 STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    VIEW STREAM REPORT FRAME F-HEADER.

    FOR EACH ttod_det NO-LOCK
        BREAK BY ttod_codubi BY ttod_codmat:
        ACCUMULATE ttod_canped (SUB-TOTAL BY ttod_codmat).
        IF LAST-OF(ttod_codmat) THEN DO:
            DISPLAY STREAM REPORT
                ttod_codubi
                ttod_codmat
                ttod_desmat
                ttod_desmar
                ttod_undvta
                ACCUM SUB-TOTAL BY ttod_codmat ttod_canped @ ttod_canped
                WITH FRAME F-REPORTE.
        END.
    END.

    cTitle = "REPORTE ORDENES DE DESPACHO POR ARTICULO - " + cDesAlm.
    PAGE STREAM report.
    FOR EACH ttod_det NO-LOCK
        BREAK BY ttod_codmat BY ttod_nroped:
        DISPLAY STREAM REPORT
            ttod_codmat WHEN FIRST-OF(ttod_codmat)
            ttod_desmat WHEN FIRST-OF(ttod_codmat)
            ttod_desmar WHEN FIRST-OF(ttod_codmat)
            ttod_undvta WHEN FIRST-OF(ttod_codmat)
            ttod_nroped
            ttod_canped
            WITH FRAME F-REPORTE-2.
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

    RUN Carga-Temporal.

    FIND FIRST ttod_det NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttod_det THEN DO:
        MESSAGE
            "No hay registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

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
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
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
    FILL-IN-fecha = TODAY.
    FILL-IN-fecha-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_open_query W-Win 
PROCEDURE proc_open_query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN RADIO-SET-sort FILL-IN-fecha FILL-IN-fecha-2.
    END.

    CASE RADIO-SET-sort:
        WHEN 1 THEN DO:
            {&OPEN-QUERY-{&BROWSE-NAME}}
        END.
        WHEN 2 THEN DO:
            OPEN QUERY BROWSE-od FOR EACH FacCPedi 
                WHERE FacCPedi.CodCia = S-CODCIA
                AND FacCPedi.CodDiv = s-CodDiv
                AND FacCPedi.CodDoc = x-CodDoc
                AND FacCPedi.CodAlm = s-CodAlm
                AND FacCPedi.FlgEst = "P"
                AND FacCPedi.FlgSit = ""
                AND FacCPedi.FchPed >= FILL-IN-fecha
                AND FacCPedi.FchPed <= FILL-IN-fecha-2
                NO-LOCK BY FacCPedi.NomCli INDEXED-REPOSITION.
        END.
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
  {src/adm/template/snd-list.i "FacCPedi"}

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

