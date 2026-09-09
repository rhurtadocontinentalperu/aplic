&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR cb-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.

DEF VAR s-task-no AS INT  NO-UNDO.
DEF VAR cDivi     AS CHAR NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print1" SIZE 5 BY 1.5.

DEFINE FRAME F-Mensaje
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16
          FONT 8
     "por favor..." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19
          FONT 8
     "F10 = Cancela Reporte" VIEW-AS TEXT
          SIZE 21 BY 1 AT ROW 3.5 COL 12
          FONT 8          
    SPACE(10.28) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 TITLE "Imprimiendo...".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tg-linea tg-dudosa FILL-IN-codcli ~
FILL-IN-codcli-1 FILL-IN-fecha FILL-IN-fecha-1 BUTTON-1 RADIO-SET-codmon ~
BUTTON-print BUTTON-exit BUTTON-print-2 RECT-3 
&Scoped-Define DISPLAYED-OBJECTS x-mensaje tg-linea tg-dudosa ~
FILL-IN-codcli FILL-IN-codcli-1 FILL-IN-fecha FILL-IN-fecha-1 ~
RADIO-SET-codmon x-CodDiv 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-exit DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Salir" 
     SIZE 8 BY 1.92 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-print 
     IMAGE-UP FILE "img\print1":U
     LABEL "&Imprimir" 
     SIZE 8 BY 1.92 TOOLTIP "Imprimir".

DEFINE BUTTON BUTTON-print-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "&Imprimir" 
     SIZE 8 BY 1.92 TOOLTIP "Imprimir".

DEFINE VARIABLE x-CodDiv AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 62 BY 2.58 NO-UNDO.

DEFINE VARIABLE FILL-IN-codcli AS CHARACTER FORMAT "x(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-codcli-1 AS CHARACTER FORMAT "x(11)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fecha AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fecha-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59.14 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-codmon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Nuevos Soles", 1,
"Dólares", 2,
"Ambos",3
     SIZE 13 BY 1.73 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY .15.

DEFINE VARIABLE tg-dudosa AS LOGICAL INITIAL no 
     LABEL "Incluir Documentos Cobranza Dudosa" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .77 NO-UNDO.

DEFINE VARIABLE tg-linea AS LOGICAL INITIAL yes 
     LABEL "Línea de Crédito" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-mensaje AT ROW 12.73 COL 2.86 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     tg-linea AT ROW 7.88 COL 31 WIDGET-ID 4
     tg-dudosa AT ROW 8.85 COL 31 WIDGET-ID 2
     FILL-IN-codcli AT ROW 1.62 COL 13 COLON-ALIGNED
     FILL-IN-codcli-1 AT ROW 1.62 COL 34 COLON-ALIGNED
     FILL-IN-fecha AT ROW 2.42 COL 13 COLON-ALIGNED
     FILL-IN-fecha-1 AT ROW 2.42 COL 34 COLON-ALIGNED
     BUTTON-1 AT ROW 4.08 COL 66
     RADIO-SET-codmon AT ROW 8.12 COL 15 NO-LABEL
     BUTTON-print AT ROW 10.42 COL 41
     BUTTON-exit AT ROW 10.42 COL 50
     BUTTON-print-2 AT ROW 10.42 COL 31.86 WIDGET-ID 6
     x-CodDiv AT ROW 4.04 COL 3.57 NO-LABEL WIDGET-ID 92
     "Documentos en:" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 8.5 COL 3
     "Division(es)" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.42 COL 4 WIDGET-ID 94
     RECT-3 AT ROW 10.04 COL 1.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70.29 BY 13.54
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
         TITLE              = "Reporte Documentos por Cobrar"
         HEIGHT             = 13.54
         WIDTH              = 70.29
         MAX-HEIGHT         = 13.54
         MAX-WIDTH          = 76.29
         VIRTUAL-HEIGHT     = 13.54
         VIRTUAL-WIDTH      = 76.29
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR EDITOR x-CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Documentos por Cobrar */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Documentos por Cobrar */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
/*
    DEF VAR x-Divisiones AS CHAR.
    x-Divisiones = FILL-IN-Division:SCREEN-VALUE.
    RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
    FILL-IN-Division:SCREEN-VALUE = x-Divisiones.
    cDivi = x-Divisiones.
*/
    ASSIGN x-CodDiv.
    RUN gn/d-filtro-divisiones (INPUT-OUTPUT x-CodDiv, "SELECCIONE LAS DIVISIONES").
    cDivi = x-CodDiv.
    DISPLAY x-CodDiv WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-exit W-Win
ON CHOOSE OF BUTTON-exit IN FRAME F-Main /* Salir */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-print W-Win
ON CHOOSE OF BUTTON-print IN FRAME F-Main /* Imprimir */
DO:
    RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-print-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-print-2 W-Win
ON CHOOSE OF BUTTON-print-2 IN FRAME F-Main /* Imprimir */
DO:

    DEF VAR s-titulo AS CHAR NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            FILL-IN-codcli
            FILL-IN-codcli-1
            FILL-IN-fecha
            FILL-IN-fecha-1
            /*FILL-IN-Division*/
            X-CodDiv
            RADIO-SET-codmon
            tg-dudosa
            tg-linea.
        IF FILL-IN-codcli-1 = "" THEN FILL-IN-codcli-1 = FILL("Z", 11).
        IF FILL-IN-fecha = ? THEN FILL-IN-fecha = 01/01/1970.
        IF FILL-IN-fecha-1 = ? THEN FILL-IN-fecha-1 = 12/31/3999.
        s-titulo = "DOCUMENTOS EN " +
            (IF RADIO-SET-codmon = 1 THEN "NUEVOS SOLES" ELSE "DÓLARES") +
            " POR COBRAR".
    END.

    IF tg-linea THEN RUN Excel2.
    ELSE RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY x-mensaje tg-linea tg-dudosa FILL-IN-codcli FILL-IN-codcli-1 
          FILL-IN-fecha FILL-IN-fecha-1 RADIO-SET-codmon x-CodDiv 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE tg-linea tg-dudosa FILL-IN-codcli FILL-IN-codcli-1 FILL-IN-fecha 
         FILL-IN-fecha-1 BUTTON-1 RADIO-SET-codmon BUTTON-print BUTTON-exit 
         BUTTON-print-2 RECT-3 
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

    DEFINE VARIABLE dTotal             AS DECIMAL NO-UNDO EXTENT 4.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    RUN proc_carga-temporal ('P').
    IF tg-dudosa THEN RUN proc_carga-temporal ('J').
    dTotal = 0.

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "DETALLE DOCUMENTOS POR COBRAR" .

    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Codigo".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cliente".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod Doc".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Número".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Emision".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Entrega".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Vencimiento".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe $".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo $".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe S/.".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo S/.".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Vencido en Cartera".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Vencido en Banco".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Por Vencer en Cartera".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Por Vencer en Banco".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "Seguimiento".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Letra".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "Banco".

    FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no 
        AND w-report.Llave-C = s-user-id 
        BREAK BY w-report.Campo-C[1] :

        DISPLAY " Excel - Coddoc( " + w-report.Campo-C[3] + "), NroDoc : (" + w-report.Campo-C[4] + ")"
            @ x-mensaje WITH FRAME {&FRAME-NAME}.

        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + w-report.Campo-C[1].
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[2].
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[3].
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + w-report.Campo-C[4].
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-D[1].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-D[2] NO-ERROR.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-D[3].
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[2].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[3].
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[4].
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[5].
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[6].
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[7].
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[8].
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[9].
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[5].
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[6].
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[7].

        dTotal[1] = w-report.Campo-F[6] + dTotal[1].
        dTotal[2] = w-report.Campo-F[7] + dTotal[2].
        dTotal[3] = w-report.Campo-F[8] + dTotal[3].
        dTotal[4] = w-report.Campo-F[9] + dTotal[4].

        IF LAST(w-report.Campo-C[1] ) THEN DO:
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = "TOTAL GENERAL".
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[1].
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[2].
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[3].
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[4].
        END.

    END.

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

  FOR EACH integral.w-report WHERE
      integral.w-report.task-no = s-task-no AND
      integral.w-report.Llave-C = s-user-id:
      DELETE integral.w-report.
  END.

  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel2 W-Win 
PROCEDURE Excel2 :
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

    DEFINE VARIABLE dTotal             AS DECIMAL NO-UNDO EXTENT 4.

    /* create a new Excel Application object */ 
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    RUN proc_carga-temporal ('P').
    IF tg-dudosa THEN RUN proc_carga-temporal ('J').
    dTotal = 0.

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "DETALLE DOCUMENTOS POR COBRAR" .

    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Codigo".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cliente".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod Doc".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Número".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Emision".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Entrega".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Vencimiento".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe $".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo $".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe S/.".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo S/.".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Linea de Credito".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Vencido en Cartera".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Vencido en Banco".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Por Vencer en Cartera".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "Por Vencer en Banco".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "Seguimiento".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Letra".
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = "Banco".

    FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no 
        AND w-report.Llave-C = s-user-id 
        BREAK BY w-report.Campo-C[1] :
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + w-report.Campo-C[1].
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[2].
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[3].
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + w-report.Campo-C[4].
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-D[1].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-D[2] NO-ERROR.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-D[3].
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[2].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[3].
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[4].
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[5].
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[1].
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[6].
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[7].
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[8].
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[9].
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[5].
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[6].
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[7].

        dTotal[1] = w-report.Campo-F[6] + dTotal[1].
        dTotal[2] = w-report.Campo-F[7] + dTotal[2].
        dTotal[3] = w-report.Campo-F[8] + dTotal[3].
        dTotal[4] = w-report.Campo-F[9] + dTotal[4].

        IF LAST(w-report.Campo-C[1] ) THEN DO:
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = "TOTAL GENERAL".
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[1].
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[2].
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[3].
            cRange = "P" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[4].
        END.
    END.

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

  FOR EACH integral.w-report WHERE
      integral.w-report.task-no = s-task-no AND
      integral.w-report.Llave-C = s-user-id:
      DELETE integral.w-report.
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

    DEF VAR s-titulo AS CHAR NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            FILL-IN-codcli
            FILL-IN-codcli-1
            FILL-IN-fecha
            FILL-IN-fecha-1
            /*FILL-IN-Division*/
            X-CodDiv
            RADIO-SET-codmon
            tg-dudosa
            tg-linea.
        IF FILL-IN-codcli-1 = "" THEN FILL-IN-codcli-1 = "ZZZZZZZZ".
        IF FILL-IN-fecha = ? THEN FILL-IN-fecha = 01/01/1970.
        IF FILL-IN-fecha-1 = ? THEN FILL-IN-fecha-1 = 12/31/3999.
        s-titulo = "DOCUMENTOS EN " +
            (IF RADIO-SET-codmon = 1 THEN "NUEVOS SOLES" ELSE "DÓLARES") +
            " POR COBRAR".
    END.

    RUN proc_carga-temporal ('P').
    IF tg-dudosa THEN RUN proc_carga-temporal ('J').
    HIDE FRAME f-mensaje NO-PAUSE.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl".
    IF tg-linea THEN
        ASSIGN RB-REPORT-NAME = "Documentos por Cobrar".
    ELSE ASSIGN RB-REPORT-NAME = "Documentos por Cobrar_2".
    ASSIGN
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            "w-report.task-no = " + STRING(s-task-no) + 
            " AND w-report.Llave-C = '" + s-user-id + "'"
        RB-OTHER-PARAMETERS =
            "s-nomcia = " + s-nomcia +
            "~ns-titulo = " + s-titulo +
            "~ns-subtit = DEL " + STRING(FILL-IN-fecha) +
            " AL " + STRING(FILL-IN-fecha-1).

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

    FOR EACH integral.w-report WHERE
        integral.w-report.task-no = s-task-no AND
        integral.w-report.Llave-C = s-user-id:
        DELETE integral.w-report.
    END.

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
  FILL-IN-fecha = DATE(MONTH(TODAY),1,YEAR(TODAY)).
  FILL-IN-fecha-1 = TODAY.
  cDivi = X-CodDiv.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_carga-temporal W-Win 
PROCEDURE proc_carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER cFlgEst AS CHAR.

DEFINE VARIABLE cNomcli AS CHARACTER NO-UNDO.
DEFINE VARIABLE dImpLC AS DECIMAL NO-UNDO.
DEFINE VARIABLE iAge_period AS INTEGER NO-UNDO.
DEFINE VARIABLE iAge_days AS INTEGER EXTENT 5 INITIAL [15, 30, 45, 60, 90].
DEFINE VARIABLE iInd AS INTEGER NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

DEFINE VARIABLE FSdoAct LIKE integral.CcbCDocu.sdoact NO-UNDO.
DEFINE VARIABLE FImpTot LIKE integral.CcbCDocu.imptot NO-UNDO.
/*DEFINE VARIABLE cFlgEst AS CHARACTER   NO-UNDO.*/
/*IF tg-dudosa THEN cFlgEst = 'P,J'. ELSE cFlgEst = 'P'.*/

IF s-task-no = 0 THEN REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST integral.w-report WHERE
                    integral.w-report.task-no = s-task-no AND
                    integral.w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
END.

FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
    AND LOOKUP(gn-divi.coddiv, cDivi) > 0:
    FOR EACH integral.CcbCDocu USE-INDEX Llave02 NO-LOCK WHERE
        integral.CcbCDocu.codcia = s-codcia AND
        integral.CcbCDocu.coddiv = gn-divi.coddiv AND 
        integral.CcbCDocu.flgest = cFlgEst:
        IF NOT (integral.CcbCDocu.codcli >= FILL-IN-codcli AND
        integral.CcbCDocu.codcli <= FILL-IN-codcli-1) THEN NEXT.
        IF NOT (integral.CcbCDocu.fchdoc >= FILL-IN-fecha AND
        integral.CcbCDocu.fchdoc <= FILL-IN-fecha-1) THEN NEXT.
        IF RADIO-SET-codmon <> 3 AND NOT integral.CcbCDocu.codmon = RADIO-SET-codmon THEN NEXT.
        IF NOT LOOKUP(integral.CcbCDocu.coddoc,"FAC,BOL,N/C,N/D,LET,A/R,BD") > 0 THEN NEXT.
        ASSIGN
            cNomcli = ""
            dImpLC = 0
            lEnCampan = FALSE.
        FIND integral.gn-clie WHERE
            integral.gn-clie.CodCia = cl-codcia AND
            integral.gn-clie.CodCli = integral.CcbCDocu.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE integral.gn-clie THEN DO:
            /* Línea Crédito Campaña */
            FOR EACH integral.gn-clieL WHERE
                integral.gn-clieL.CodCia = integral.gn-clie.codcia AND
                integral.gn-clieL.CodCli = integral.gn-clie.codcli AND
                TODAY >= integral.gn-clieL.FchIni AND
                TODAY <= integral.gn-clieL.FchFin NO-LOCK:
                dImpLC = dImpLC + integral.gn-clieL.ImpLC.
                lEnCampan = TRUE.
            END.
            /* Línea Crédito Normal */
            IF NOT lEnCampan THEN dImpLC = integral.gn-clie.ImpLC.
            cNomcli = integral.gn-clie.nomcli.
        END.
        DISPLAY "   Cargando información para: " + integral.CcbCDocu.codcli
            @ x-mensaje WITH FRAME {&FRAME-NAME}.

        FSdoAct = integral.CcbCDocu.sdoact.
        FImpTot = integral.CcbCDocu.imptot.

        IF lookup(integral.CcbCDocu.coddoc, "N/C,A/R,BD") > 0 THEN DO:
            FSdoAct = FSdoAct * -1.
            FImpTot = FImpTot * -1.
        END.

        CREATE integral.w-report.
        ASSIGN
            integral.w-report.Task-No = s-task-no                         /* ID Tarea */
            integral.w-report.Llave-C = s-user-id                         /* ID Usuario */
            integral.w-report.Campo-C[1] = integral.CcbCDocu.codcli       /* Cliente */
            integral.w-report.Campo-C[2] = cNomcli                        /* Nombre  */
            integral.w-report.Campo-C[3] = integral.CcbCDocu.coddoc       /* Código Documento */
            integral.w-report.Campo-C[4] = integral.CcbCDocu.nrodoc       /* Número Documento */        
            integral.w-report.Campo-D[1] = integral.CcbCDocu.fchdoc       /* Fecha Emisión */
            integral.w-report.Campo-D[2] = integral.CcbCDocu.fchvto       /* Fecha Vencimiento */
            integral.w-report.Campo-D[3] = integral.CcbCDocu.fchcbd.      /* Fecha Recepción */
        /*Incluir lïnea de crédito*/
        IF tg-linea THEN
            ASSIGN integral.w-report.Campo-F[1] = dImpLC.        /* Línea de Crédito */
        IF integral.CcbCDocu.codmon = 2 THEN DO:
            integral.w-report.Campo-F[2] = FImpTot.              /* Importe Dólares */
            integral.w-report.Campo-F[3] = FSdoAct.              /* Saldo Dólares */
        END.
        ELSE DO:
            integral.w-report.Campo-F[4] = FImpTot.              /* Importe Soles */
            integral.w-report.Campo-F[5] = FSdoAct.              /* Saldo Soles */
        END.

        IF integral.CcbCDocu.coddoc = "LET" THEN DO:
            CASE integral.CcbCDocu.flgsit:
                WHEN "C" THEN integral.w-report.Campo-C[5] = "COBRANZA LIBRE".
                WHEN "D" THEN integral.w-report.Campo-C[5] = "DESCUENTO".
                WHEN "G" THEN integral.w-report.Campo-C[5] = "GARANTIA".
                WHEN "P" THEN integral.w-report.Campo-C[5] = "PROTESTADA".
            END CASE.
            /* Documentos en Banco */
            IF integral.CcbCDocu.flgubi = "B" THEN DO:
                integral.w-report.Campo-C[6] = integral.CcbCDocu.nrosal.      /* Letra en Banco */
                IF integral.CcbCDocu.CodCta <> "" THEN DO:
                    FIND FIRST integral.cb-ctas WHERE
                        integral.cb-ctas.CodCia = cb-codcia AND
                        integral.cb-ctas.Codcta = integral.CcbCDocu.CodCta
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE integral.cb-ctas THEN DO:
                        FIND integral.cb-tabl WHERE
                            integral.cb-tabl.Tabla  = "04" AND
                            integral.cb-tabl.Codigo = integral.cb-ctas.codbco
                        NO-LOCK NO-ERROR.
                        IF AVAILABLE integral.cb-tabl THEN
                        integral.w-report.Campo-C[7] = integral.cb-tabl.Nombre.   /* Banco */
                    END.
                END.
            END.
        END.

        /* Documentos Vencidos */
        IF integral.CcbCDocu.fchvto < TODAY THEN DO:
            IF integral.CcbCDocu.coddoc = "LET" THEN DO:
                IF integral.CcbCDocu.flgubi = "C" THEN
                    integral.w-report.Campo-F[6] = FSdoAct.      /* Vencido Cartera */
                ELSE
                    integral.w-report.Campo-F[7] = FSdoAct.      /* Vencido Banco */
            END.
            ELSE integral.w-report.Campo-F[6] = FSdoAct.         /* Vencido Cartera */
        END.
        /* Documentos por Vencer */
        ELSE DO:
            IF integral.CcbCDocu.coddoc = "LET" THEN DO:
                IF integral.CcbCDocu.flgubi = "C" THEN
                    integral.w-report.Campo-F[8] = FSdoAct.      /* Por Vencer Cartera */
                ELSE
                    integral.w-report.Campo-F[9] = FSdoAct.      /* Por Vencer Banco */
            END.
            ELSE integral.w-report.Campo-F[8] = FSdoAct.         /* Por Vencer Cartera */
        END.

    END.
END.

DISPLAY "Carga temporal finalizada..." @ x-mensaje WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

