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

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

DEFINE VARIABLE cPeriodo AS CHARACTER NO-UNDO.

RUN cbd/cb-m000 (OUTPUT cPeriodo).
IF cPeriodo = '' THEN DO:
    MESSAGE
        'NO existen periodos configurados para esta compañia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

DEFINE TEMP-TABLE wrk_report NO-UNDO
    FIELDS wrk_codper  LIKE pl-pers.codper
    FIELDS wrk_docide  AS CHAR FORMAT 'x(20)' COLUMN-LABEL 'Doc Id.'
    FIELDS wrk_patper  LIKE pl-pers.patper
    FIELDS wrk_matper  LIKE pl-pers.matper
    FIELDS wrk_nomper  LIKE pl-pers.nomper
    FIELDS wrk_fecing  LIKE pl-flg-mes.fecing
        COLUMN-LABEL "Ingreso" FORMAT "99/99/99"
    FIELDS wrk_cargo   LIKE pl-flg-mes.cargos
    FIELDS wrk_seccion LIKE pl-flg-mes.seccion
    FIELDS wrk_ccosto  AS CHAR COLUMN-LABEL "CC" FORMAT "X(15)" 
    FIELDS wrk_clase   LIKE pl-flg-mes.Clase
    FIELDS wrk_basico  AS DECIMAL COLUMN-LABEL "Sueldo!Básico"
    INDEX IDX01 AS PRIMARY wrk_codper.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 COMBO-BOX-Periodo BUTTON-2 ~
COMBO-BOX-Mes COMBO-BOX-Mes-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-Mes ~
COMBO-BOX-Mes-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 1" 
     SIZE 15 BY 1.54 TOOLTIP "Aceptar".

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.54 TOOLTIP "Cancelar".

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\excel":U
     LABEL "Button 3" 
     SIZE 15 BY 1.5 TOOLTIP "Salida a archivo".

DEFINE VARIABLE COMBO-BOX-Mes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mes-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "A" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.38 COL 50
     COMBO-BOX-Periodo AT ROW 2.35 COL 7 COLON-ALIGNED
     BUTTON-2 AT ROW 3.12 COL 50
     COMBO-BOX-Mes AT ROW 3.31 COL 7 COLON-ALIGNED
     COMBO-BOX-Mes-2 AT ROW 3.31 COL 29 COLON-ALIGNED
     BUTTON-3 AT ROW 4.85 COL 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 6.12
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
         TITLE              = "Reporte de Empleados por Rango de Meses"
         HEIGHT             = 6.12
         WIDTH              = 71.86
         MAX-HEIGHT         = 6.12
         MAX-WIDTH          = 71.86
         VIRTUAL-HEIGHT     = 6.12
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Empleados por Rango de Meses */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Empleados por Rango de Meses */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN COMBO-BOX-Periodo COMBO-BOX-Mes COMBO-BOX-Mes-2.
    RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN COMBO-BOX-Periodo COMBO-BOX-Mes COMBO-BOX-Mes-2.
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
    
    DEFINE VARIABLE cDesCCo AS CHARACTER   NO-UNDO.
    EMPTY TEMP-TABLE wrk_report.

    FOR EACH pl-pers NO-LOCK,
        LAST pl-flg-mes WHERE
        pl-flg-mes.codcia = s-CodCia AND
        pl-flg-mes.periodo = COMBO-BOX-Periodo AND
        pl-flg-mes.codpln = 01 AND
        pl-flg-mes.nromes >= LOOKUP(COMBO-BOX-Mes,
            COMBO-BOX-Mes:LIST-ITEMS IN FRAME {&FRAME-NAME}) AND
        pl-flg-mes.nromes <= LOOKUP(COMBO-BOX-Mes,
            COMBO-BOX-Mes:LIST-ITEMS) AND
        pl-flg-mes.codper = pl-pers.codper NO-LOCK:

        cDesCco = pl-flg-mes.CCosto. 
        FIND cb-auxi WHERE cb-auxi.CodCia = 0
            AND cb-auxi.CLFAUX = "CCO"
            AND cb-auxi.CodAUX = pl-flg-mes.CCosto NO-LOCK NO-ERROR.
        IF AVAIL cb-auxi THEN cDesCCo = cb-auxi.CodAUX + "-" + cb-auxi.Nomaux.
        ELSE DO:
            FIND cb-auxi WHERE cb-auxi.CodCia = s-codcia
                AND cb-auxi.CLFAUX = "CCO"
                AND cb-auxi.CodAUX = pl-flg-mes.CCosto NO-LOCK NO-ERROR.
            IF AVAILABLE cb-auxi THEN cDesCCo = cb-auxi.CodAUX + "-" + cb-auxi.Nomaux.
        END.
            
        FIND FIRST wrk_report WHERE
            wrk_codper = pl-flg-mes.CodPer
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE wrk_report THEN DO:
            CREATE wrk_report.
            ASSIGN
                wrk_codper  = pl-flg-mes.CodPer
                wrk_patper  = pl-pers.patper
                wrk_matper  = pl-pers.matper
                wrk_nomper  = pl-pers.nomper
                wrk_fecing  = pl-flg-mes.fecing
                wrk_cargo   = pl-flg-mes.cargos
                wrk_seccion = pl-flg-mes.seccion
                wrk_ccosto  = cDesCco
                wrk_clase   = pl-flg-mes.Clase.
            ASSIGN
                wrk_docide = pl-pers.nrodocid.
            CASE pl-pers.TpoDocId:
                WHEN '01' THEN wrk_docide = 'DNI ' + pl-pers.nrodocid.
                WHEN '04' THEN wrk_docide = 'CE  ' + pl-pers.nrodocid.
                WHEN '06' THEN wrk_docide = 'RUC ' + pl-pers.nrodocid.
                WHEN '07' THEN wrk_docide = 'PAS ' + pl-pers.nrodocid.
                WHEN '11' THEN wrk_docide = 'PNA ' + pl-pers.nrodocid.
            END CASE.
            FIND PL-MOV-MES OF PL-FLG-MES WHERE
                PL-MOV-MES.codcal = 0 AND
                PL-MOV-MES.CodMov = 101 NO-LOCK NO-ERROR.
            IF AVAILABLE PL-MOV-MES THEN
                wrk_basico = PL-MOV-MES.valcal-mes.
            DISPLAY
                pl-flg-mes.codper @ Fi-Mensaje
                LABEL "  Cargando Código" FORMAT "X(13)"
                WITH FRAME F-Proceso.
        END.
    END.
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
  DISPLAY COMBO-BOX-Periodo COMBO-BOX-Mes COMBO-BOX-Mes-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 COMBO-BOX-Periodo BUTTON-2 COMBO-BOX-Mes COMBO-BOX-Mes-2 
         BUTTON-3 
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
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value =
        "REPORTE DE EMPLEADOS DE " +
        CAPS(COMBO-BOX-Mes) + " A " +
        CAPS(COMBO-BOX-Mes-2) + " DE " +
        STRING(COMBO-BOX-Periodo,"9999").
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "CÓDIGO".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "APELLIDO PATERNO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "APELLIDO MATERNO".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "NOMBRE(S)".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "FECHA INGRESO".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "CARGO".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "SECCIÓN".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "CC".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "CLASE".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "SUELDO BÁSICO".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC ID.".

    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("H"):NumberFormat = "@".
    chWorkSheet:Columns("K"):NumberFormat = "@".
    chWorkSheet:Columns("B"):ColumnWidth = 30.
    chWorkSheet:Columns("C"):ColumnWidth = 30.
    chWorkSheet:Columns("D"):ColumnWidth = 30.
    chWorkSheet:Columns("F"):ColumnWidth = 30.
    chWorkSheet:Columns("G"):ColumnWidth = 30.
    chWorkSheet:Columns("I"):ColumnWidth = 30.
    chWorkSheet:Columns("K"):ColumnWidth = 30.
    chWorkSheet:Range("A1:K2"):Font:Bold = TRUE.

    FOR EACH wrk_report NO-LOCK:
        
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_codper.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_patper.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_matper.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_nomper.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_fecing.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_cargo.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_seccion.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_ccosto.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_clase.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_basico.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_docide.
        DISPLAY
            wrk_codper @ FI-MENSAJE LABEL "  Procesando Empleado" FORMAT "X(12)"
            WITH FRAME F-PROCESO.

    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

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

    DEFINE VARIABLE cTitle AS CHARACTER NO-UNDO.

    cTitle =
        "REPORTE DE EMPLEADOS " + " DE " +
        CAPS(COMBO-BOX-Mes) + " A " +
        CAPS(COMBO-BOX-Mes-2) + " DE " +
        STRING(COMBO-BOX-Periodo,"9999").

    DEFINE FRAME F-REPORTE
        wrk_codper
        wrk_patper
        wrk_matper
        wrk_nomper
        wrk_fecing
        wrk_cargo
        wrk_seccion
        wrk_ccosto
        wrk_clase
        wrk_basico
        WITH WIDTH 250 NO-BOX STREAM-IO DOWN.

    DEFINE FRAME F-HEADER       
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + cTitle AT 80 FORMAT 'x(58)'
        {&PRN3} + {&PRN6B} + "Pagina : " AT 200 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + "Fecha : " AT 200 STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)"
        "Hora  : " AT 200 STRING(TIME,"HH:MM:SS") SKIP
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    FOR EACH wrk_report NO-LOCK:
        VIEW STREAM REPORT FRAME F-HEADER.
        DISPLAY STREAM REPORT
            wrk_codper
            wrk_patper
            wrk_matper
            wrk_nomper
            wrk_fecing
            wrk_cargo
            wrk_seccion
            wrk_ccosto
            wrk_clase
            wrk_basico
            WITH FRAME F-REPORTE.
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

    FIND FIRST wrk_report NO-LOCK NO-ERROR.
    IF NOT AVAILABLE wrk_report THEN DO:
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
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            COMBO-BOX-Periodo:LIST-ITEMS = cPeriodo
            COMBO-BOX-Periodo = s-periodo
            COMBO-BOX-Mes = ENTRY(1,COMBO-BOX-Mes:LIST-ITEMS)
            COMBO-BOX-Mes-2 = ENTRY(MONTH(TODAY),COMBO-BOX-Mes-2:LIST-ITEMS).
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

