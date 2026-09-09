&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

{bin/s-global.i}

{pln/s-global.i}

DEFINE VARIABLE CMB-lista  AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-nombre   AS CHARACTER FORMAT "x(50)" NO-UNDO.
DEFINE VARIABLE x-concepto AS CHARACTER FORMAT "x(50)" NO-UNDO.
DEFINE VARIABLE x-mes      AS CHARACTER FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE stat-reg   AS LOGICAL NO-UNDO.
DEFINE VARIABLE i          AS INTEGER NO-UNDO.
DEFINE VARIABLE x-calculo  AS INTEGER NO-UNDO.

DEFINE BUTTON Btn_OK IMAGE-UP FILE "img/plemrbol"
    LABEL "OK" SIZE 6.43 BY 1.58 BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-Codigo AS CHARACTER FORMAT "X(256)":U 
    LABEL "Personal" VIEW-AS FILL-IN SIZE 6.72 BY .81 BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-Seccion AS CHARACTER FORMAT "X(256)":U 
    LABEL "Proyecto" VIEW-AS FILL-IN SIZE 28 BY .81 BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-20 EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL SIZE 37.14 BY 3.08.

DEFINE FRAME F-msg
    FILL-IN-Codigo AT ROW 2.08 COL 6.72 COLON-ALIGNED
    FILL-IN-Seccion AT ROW 2.96 COL 6.72 COLON-ALIGNED
    Btn_OK AT ROW 1.23 COL 30.29
    RECT-20 AT ROW 1 COL 1
    "Espere un momento por favor ..." VIEW-AS TEXT
    SIZE 22.57 BY .62 AT ROW 1.31 COL 4.43
    SPACE(11.13) SKIP(2.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    FONT 4 TITLE "Procesando..." CENTERED.

DEFINE STREAM strm-concep. /* STREAM para el reporte */

DEFINE FRAME F-Concepto
    PL-FLG-MES.CodPer     COLUMN-LABEL "C¢digo"
    x-nombre              COLUMN-LABEL "Apellidos y Nombres"
    PL-MOV-MES.ValCal-Mes COLUMN-LABEL "Valor" FORMAT "-ZZZ,ZZZ,ZZ9.99"
    HEADER
    s-NomCia "Fecha :" TO 70 TODAY TO 80
    s-DirCia FORMAT "x(49)" x-mes TO 80 SKIP(1)
    x-concepto SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 80.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_pl-flg-m

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-PLAN integral.PL-CALC
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-PLAN


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-PLAN, integral.PL-CALC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES INTEGRAL.PL-FLG-MES INTEGRAL.PL-PERS

/* Definitions for BROWSE br_pl-flg-m                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-m 
&Scoped-define QUERY-STRING-br_pl-flg-m FOR EACH INTEGRAL.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES ~
 NO-LOCK, ~
      EACH INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-MES NO-LOCK
&Scoped-define OPEN-QUERY-br_pl-flg-m OPEN QUERY br_pl-flg-m FOR EACH INTEGRAL.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES ~
 NO-LOCK, ~
      EACH INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-MES NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-m INTEGRAL.PL-FLG-MES ~
INTEGRAL.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-m INTEGRAL.PL-FLG-MES
&Scoped-define SECOND-TABLE-IN-QUERY-br_pl-flg-m INTEGRAL.PL-PERS


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_pl-flg-m}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-27 Btn-UP br_pl-flg-m FILL-IN-NRO-MES ~
Btn-DOWN TGL-calculo FILL-IN-Concepto R-seleccion COMBO-S TGL-pantalla ~
TGL-Excel B-aceptar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NRO-MES TGL-calculo ~
FILL-IN-Concepto R-seleccion COMBO-S TGL-pantalla TGL-Excel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.46.

DEFINE BUTTON Btn-DOWN 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE VARIABLE COMBO-S AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20.43 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-Concepto AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Concepto" 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NRO-MES AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE R-seleccion AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todo el personal", 1,
"Selectivo", 2,
"Por sección", 3,
"Por proyecto", 4
     SIZE 14.14 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.14 BY 9.69.

DEFINE VARIABLE TGL-calculo AS LOGICAL INITIAL no 
     LABEL "Cálculo Manual" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.57 BY .77 NO-UNDO.

DEFINE VARIABLE TGL-Excel AS LOGICAL INITIAL no 
     LABEL "Salida a Excel" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.57 BY .5 NO-UNDO.

DEFINE VARIABLE TGL-pantalla AS LOGICAL INITIAL no 
     LABEL "Salida a Pantalla" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.57 BY .5 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_pl-flg-m FOR 
      INTEGRAL.PL-FLG-MES, 
      INTEGRAL.PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_pl-flg-m
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-flg-m B-table-Win _STRUCTURED
  QUERY br_pl-flg-m NO-LOCK DISPLAY
      integral.PL-FLG-MES.codper FORMAT "X(6)":U
      integral.PL-PERS.patper FORMAT "X(40)":U
      integral.PL-PERS.matper FORMAT "X(40)":U
      integral.PL-PERS.nomper FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 46 BY 9.19
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn-UP AT ROW 1.15 COL 14.14
     br_pl-flg-m AT ROW 1.23 COL 23.14
     FILL-IN-NRO-MES AT ROW 1.38 COL 8.43 COLON-ALIGNED
     Btn-DOWN AT ROW 1.77 COL 14.14
     TGL-calculo AT ROW 2.46 COL 5.86
     FILL-IN-Concepto AT ROW 3.23 COL 11.14 COLON-ALIGNED
     R-seleccion AT ROW 4.23 COL 5.14 NO-LABEL
     COMBO-S AT ROW 6.38 COL 1.86 NO-LABEL
     TGL-pantalla AT ROW 7.35 COL 4.29
     TGL-Excel AT ROW 8.04 COL 4.29 WIDGET-ID 2
     B-aceptar AT ROW 8.81 COL 5.43
     RECT-27 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.57 BY 9.85
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.PL-PLAN,integral.PL-CALC
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 9.85
         WIDTH              = 69.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* BROWSE-TAB br_pl-flg-m Btn-UP F-Main */
ASSIGN 
       br_pl-flg-m:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 1.

/* SETTINGS FOR COMBO-BOX COMBO-S IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-m
/* Query rebuild information for BROWSE br_pl-flg-m
     _TblList          = "INTEGRAL.PL-FLG-MES,INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-MES"
     _Options          = "NO-LOCK"
     _Where[1]         = "PL-FLG-MES.CodCia = s-CodCia
 AND PL-FLG-MES.Periodo = s-Periodo
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES
"
     _FldNameList[1]   = integral.PL-FLG-MES.codper
     _FldNameList[2]   = integral.PL-PERS.patper
     _FldNameList[3]   = integral.PL-PERS.matper
     _FldNameList[4]   = integral.PL-PERS.nomper
     _Query            is OPENED
*/  /* BROWSE br_pl-flg-m */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar B-table-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN
        COMBO-S
        FILL-IN-Concepto
        FILL-IN-NRO-MES
        R-seleccion
        TGL-calculo
        TGL-pantalla
        TGL-Excel.

    IF TGL-calculo = TRUE THEN x-calculo = 0.
    ELSE x-calculo = PL-CALC.codcal.

    IF NOT CAN-FIND( FIRST PL-MOV-MES WHERE
        PL-MOV-MES.codcia = s-codcia AND
        PL-MOV-MES.periodo = s-periodo AND
        PL-MOV-MES.nromes = FILL-IN-NRO-MES AND
        PL-MOV-MES.codpln = PL-PLAN.codpln AND
        PL-MOV-MES.codcal = x-calculo AND
        PL-MOV-MES.codmov = FILL-IN-Concepto ) THEN DO:
        BELL.
        MESSAGE "C¢digo de concepto no registra c lculo"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-Concepto.
        RETURN NO-APPLY.
    END.
    IF TGL-Excel THEN RUN Excel.
    ELSE RUN imp_concepto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_pl-flg-m
&Scoped-define SELF-NAME br_pl-flg-m
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-m B-table-Win
ON ROW-ENTRY OF br_pl-flg-m IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-m B-table-Win
ON ROW-LEAVE OF br_pl-flg-m IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-m B-table-Win
ON VALUE-CHANGED OF br_pl-flg-m IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN B-table-Win
ON CHOOSE OF Btn-DOWN IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-MES - 1 >= 1 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-MES - 1 @ FILL-IN-NRO-MES WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-MES.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP B-table-Win
ON CHOOSE OF Btn-UP IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-MES + 1 <= 12 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-MES + 1 @ FILL-IN-NRO-MES WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-MES.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-S
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-S B-table-Win
ON ENTRY OF COMBO-S IN FRAME F-Main
DO:
    ASSIGN CMB-Lista = "".
    CASE INPUT R-seleccion:
    WHEN 3 THEN DO:
        FOR EACH integral.PL-SECC NO-LOCK:
            ASSIGN CMB-Lista = CMB-Lista + "," + integral.PL-SECC.seccion.
        END.
    END.
    WHEN 4 THEN DO:
        FOR EACH integral.PL-PROY NO-LOCK:
            ASSIGN CMB-Lista = CMB-Lista + "," + integral.PL-PROY.proyecto.
        END.
    END.
    END CASE.
    COMBO-S:LIST-ITEMS IN FRAME F-Main = CMB-Lista.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Concepto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Concepto B-table-Win
ON MOUSE-SELECT-DBLCLICK OF FILL-IN-Concepto IN FRAME F-Main /* Concepto */
OR "F8" OF FILL-IN-Concepto 
DO:
   DEF VAR Reg-act5 AS ROWID.
   RUN PLN/H-CONC.w (OUTPUT reg-act5).
   IF reg-act5 <> ? THEN DO:
        FIND PL-CONC WHERE ROWID(PL-CONC) = reg-act5 NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN SELF:SCREEN-VALUE = STRING(PL-CONC.codmov).
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NRO-MES
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NRO-MES B-table-Win
ON LEAVE OF FILL-IN-NRO-MES IN FRAME F-Main /* Mes */
DO:
    IF INPUT FILL-IN-NRO-MES > 12 OR INPUT FILL-IN-NRO-MES = 0 THEN DO:
        BELL.
        MESSAGE "Rango de mes es de 1 a 12"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-NRO-MES.
        RETURN NO-APPLY.
    END.
    IF INPUT FILL-IN-NRO-MES = FILL-IN-NRO-MES THEN RETURN.
    ASSIGN FILL-IN-NRO-MES.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-seleccion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-seleccion B-table-Win
ON VALUE-CHANGED OF R-seleccion IN FRAME F-Main
DO:
    CASE INPUT R-seleccion:
    WHEN 1 THEN
        ASSIGN
            Br_pl-flg-m:SENSITIVE = FALSE
            COMBO-S:SENSITIVE     = FALSE.
    WHEN 2 THEN
        ASSIGN
            Br_pl-flg-m:SENSITIVE = TRUE
            COMBO-S:SENSITIVE     = FALSE.
    WHEN 3 OR WHEN 4 THEN DO:
        ASSIGN
            COMBO-S:LIST-ITEMS    = ""
            Br_pl-flg-m:SENSITIVE = FALSE
            COMBO-S:SENSITIVE     = TRUE.
        DISPLAY COMBO-S WITH FRAME F-Main.
    END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "integral.PL-PLAN"}
  {src/adm/template/row-list.i "integral.PL-CALC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-PLAN"}
  {src/adm/template/row-find.i "integral.PL-CALC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 5 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCountReg          AS INTEGER NO-UNDO.
    DEFINE VARIABLE x-ImpCon AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99" NO-UNDO.    

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).


    FIND PL-CONC WHERE PL-CONC.codmov = FILL-IN-Concepto NO-LOCK NO-ERROR.
    IF AVAILABLE PL-CONC THEN x-concepto = STRING(PL-CONC.codmov,"999") + " " + PL-CONC.DesMov.
    ELSE x-concepto = "CONCEPTO NO REGISTRADO".

    RUN bin/_mes.r( FILL-IN-NRO-MES, 1 , OUTPUT x-mes ).

    x-mes = "MES DE " + x-mes + " DE " + STRING(s-periodo,"9999").

    x-mes = FILL(" ", 30 - LENGTH( x-mes ) ) + x-mes.

    /* set the column names for the Worksheet */
    chWorkSheet:Range("B1"):Value = s-NomCia.
    chWorkSheet:Range("A2"):Value = s-DirCia.
    chWorkSheet:Range("C2"):Value = "Fecha: " + STRING(TODAY).
    chWorkSheet:Range("A3"):Value = x-concepto.
    chWorkSheet:Range("C3"):Value = x-mes.


    chWorkSheet:Range("A5"):Value = "Codigo".
    chWorkSheet:Range("B5"):Value = "Nombres y Apellidos".
    chWorkSheet:Range("C5"):Value = "Valor".

    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Range("A1:P5"):Font:Bold = TRUE.

    CASE R-seleccion:
    WHEN 1 THEN DO:
        ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Proyecto".
        GET FIRST br_pl-flg-m.
        DO WHILE AVAILABLE(PL-FLG-MES):
            DISPLAY
                PL-FLG-MES.proyecto @ FILL-IN-Seccion
                PL-FLG-MES.CodPer @ FILL-IN-Codigo
                WITH FRAME F-Msg.
            IF AVAILABLE PL-PERS THEN
                x-nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
            ELSE x-nombre = "".
            FIND PL-MOV-MES WHERE
                PL-MOV-MES.CodCia  = s-CodCia AND
                PL-MOV-MES.Periodo = s-Periodo AND
                PL-MOV-MES.NroMes  = PL-FLG-MES.nromes AND
                PL-MOV-MES.CodPln  = PL-FLG-MES.codpln AND
                PL-MOV-MES.CodCal  = x-calculo AND
                PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
                PL-MOV-MES.CodMov  = FILL-IN-Concepto NO-LOCK NO-ERROR.
            IF AVAILABLE PL-MOV-MES AND PL-MOV-MES.ValCal-Mes <> 0 THEN DO:
                iCount = iCount + 1.
                cColumn = STRING(iCount).
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = PL-FLG-MES.CodPer.
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = x-nombre.
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = PL-MOV-MES.ValCal-Mes.
                IF PL-MOV-MES.ValCal-Mes <> ? THEN
                    ASSIGN x-ImpCon = x-ImpCon + PL-MOV-MES.ValCal-Mes.
            END.
            GET NEXT br_pl-flg-m.
        END.
    END.
    WHEN 2 THEN DO:
        ASSIGN FILL-IN-Seccion:LABEL = "Proyecto".
        DO i = 1 TO br_pl-flg-m:NUM-SELECTED-ROWS IN FRAME F-Main:
            ASSIGN stat-reg  = br_pl-flg-m:FETCH-SELECTED-ROW(i).
            IF stat-reg THEN DO:
                DISPLAY
                    PL-FLG-MES.proyecto @ FILL-IN-Seccion
                    PL-FLG-MES.CodPer @ FILL-IN-Codigo
                    WITH FRAME F-Msg.
                IF AVAILABLE PL-PERS THEN
                    x-nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
                ELSE x-nombre = "".
                FIND PL-MOV-MES WHERE
                    PL-MOV-MES.CodCia  = s-CodCia AND
                    PL-MOV-MES.Periodo = s-Periodo AND
                    PL-MOV-MES.NroMes  = PL-FLG-MES.nromes AND
                    PL-MOV-MES.CodPln  = PL-FLG-MES.codpln AND
                    PL-MOV-MES.CodCal  = x-calculo AND
                    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
                    PL-MOV-MES.CodMov  = FILL-IN-Concepto NO-LOCK NO-ERROR.
                IF AVAILABLE PL-MOV-MES AND PL-MOV-MES.ValCal-Mes <> 0 THEN DO:
                    iCount = iCount + 1.
                    cColumn = STRING(iCount).
                    cRange = "A" + cColumn.
                    chWorkSheet:Range(cRange):Value = PL-FLG-MES.CodPer.
                    cRange = "B" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-nombre.
                    cRange = "C" + cColumn.
                    chWorkSheet:Range(cRange):Value = PL-MOV-MES.ValCal-Mes.
                    IF PL-MOV-MES.ValCal-Mes <> ? THEN
                       ASSIGN x-ImpCon = x-ImpCon + PL-MOV-MES.ValCal-Mes.
                END.
            END.
        END.
        ASSIGN stat-reg = br_pl-flg-m:DESELECT-ROWS().
    END.
    WHEN 3 THEN DO:
        ASSIGN FILL-IN-Seccion:LABEL = "Seccion".
        DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
        GET FIRST br_pl-flg-m.
        DO WHILE AVAILABLE(PL-FLG-MES):
            IF PL-FLG-MES.Seccion = COMBO-S THEN DO:
                DISPLAY PL-FLG-MES.CodPer @ FILL-IN-Codigo WITH FRAME F-Msg.
                IF AVAILABLE PL-PERS THEN
                    x-nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
                ELSE x-nombre = "".
                FIND PL-MOV-MES WHERE
                    PL-MOV-MES.CodCia  = s-CodCia AND
                    PL-MOV-MES.Periodo = s-Periodo AND
                    PL-MOV-MES.NroMes  = PL-FLG-MES.nromes AND
                    PL-MOV-MES.CodPln  = PL-FLG-MES.codpln AND
                    PL-MOV-MES.CodCal  = x-calculo AND
                    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
                    PL-MOV-MES.CodMov  = FILL-IN-Concepto NO-LOCK NO-ERROR.
                IF AVAILABLE PL-MOV-MES AND PL-MOV-MES.ValCal-Mes <> 0 THEN DO:
                    DISPLAY STREAM strm-concep
                        iCount = iCount + 1.
                        cColumn = STRING(iCount).
                        cRange = "A" + cColumn.
                        chWorkSheet:Range(cRange):Value = PL-FLG-MES.CodPer.
                        cRange = "B" + cColumn.
                        chWorkSheet:Range(cRange):Value = x-nombre.
                        cRange = "C" + cColumn.
                        chWorkSheet:Range(cRange):Value = PL-MOV-MES.ValCal-Mes.
                    IF PL-MOV-MES.ValCal-Mes <> ? THEN
                       ASSIGN x-ImpCon = x-ImpCon + PL-MOV-MES.ValCal-Mes.
                END.
            END.
            GET NEXT br_pl-flg-m.
        END.
    END.
    WHEN 4 THEN DO:
        ASSIGN FILL-IN-Seccion:LABEL = "Proyecto".
        DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
        GET FIRST br_pl-flg-m.
        DO WHILE AVAILABLE(PL-FLG-MES):
            IF PL-FLG-MES.Proyecto = COMBO-S THEN DO:
                DISPLAY PL-FLG-MES.CodPer @ FILL-IN-Codigo WITH FRAME F-Msg.
                IF AVAILABLE PL-PERS THEN
                    x-nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
                ELSE x-nombre = "".
                FIND PL-MOV-MES WHERE
                    PL-MOV-MES.CodCia  = s-CodCia AND
                    PL-MOV-MES.Periodo = s-Periodo AND
                    PL-MOV-MES.NroMes  = PL-FLG-MES.nromes AND
                    PL-MOV-MES.CodPln  = PL-FLG-MES.codpln AND
                    PL-MOV-MES.CodCal  = x-calculo AND
                    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
                    PL-MOV-MES.CodMov  = FILL-IN-Concepto NO-LOCK NO-ERROR.
                IF AVAILABLE PL-MOV-MES AND PL-MOV-MES.ValCal-Mes <> 0 THEN DO:
                    iCount = iCount + 1.
                    cColumn = STRING(iCount).
                    cRange = "A" + cColumn.
                    chWorkSheet:Range(cRange):Value = PL-FLG-MES.CodPer.
                    cRange = "B" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-nombre.
                    cRange = "C" + cColumn.
                    chWorkSheet:Range(cRange):Value = PL-MOV-MES.ValCal-Mes.
                END.
            END.
            GET NEXT br_pl-flg-m.
        END.
    END.

    END CASE.

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe TOTAL : ".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = x-ImpCon.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    HIDE FRAME F-Msg.
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_concepto B-table-Win 
PROCEDURE imp_concepto :
/*------------------------------------------------------------------------------
    Impresi¢n de conceptos.
------------------------------------------------------------------------------*/

DEFINE VARIABLE p-archivo AS CHARACTER.
DEFINE VARIABLE x-ImpCon AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99" NO-UNDO.

IF TGL-pantalla = TRUE THEN DO:
    P-archivo = SESSION:TEMP-DIRECTORY +
          STRING(NEXT-VALUE(sec-arc,integral),"99999999") + ".scr".
    OUTPUT STREAM strm-concep TO VALUE ( P-archivo ) PAGED PAGE-SIZE 60.
END.
ELSE DO:
    OUTPUT STREAM strm-concep TO PRINTER PAGED PAGE-SIZE 60.
    PUT STREAM strm-concep CONTROL CHR(60).
END.

FIND PL-CONC WHERE PL-CONC.codmov = FILL-IN-Concepto NO-LOCK NO-ERROR.
IF AVAILABLE PL-CONC THEN x-concepto = STRING(PL-CONC.codmov,"999") + " " + PL-CONC.DesMov.
ELSE x-concepto = "CONCEPTO NO REGISTRADO".

RUN bin/_mes.r( FILL-IN-NRO-MES, 1 , OUTPUT x-mes ).

x-mes = "MES DE " + x-mes + " DE " + STRING(s-periodo,"9999").

x-mes = FILL(" ", 30 - LENGTH( x-mes ) ) + x-mes.

CASE R-seleccion:
WHEN 1 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Proyecto".
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        DISPLAY
            PL-FLG-MES.proyecto @ FILL-IN-Seccion
            PL-FLG-MES.CodPer @ FILL-IN-Codigo
            WITH FRAME F-Msg.
        IF AVAILABLE PL-PERS THEN
            x-nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
        ELSE x-nombre = "".
        FIND PL-MOV-MES WHERE
            PL-MOV-MES.CodCia  = s-CodCia AND
            PL-MOV-MES.Periodo = s-Periodo AND
            PL-MOV-MES.NroMes  = PL-FLG-MES.nromes AND
            PL-MOV-MES.CodPln  = PL-FLG-MES.codpln AND
            PL-MOV-MES.CodCal  = x-calculo AND
            PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
            PL-MOV-MES.CodMov  = FILL-IN-Concepto NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES AND PL-MOV-MES.ValCal-Mes <> 0 THEN DO:
            DISPLAY STREAM strm-concep
                PL-FLG-MES.CodPer
                x-nombre
                PL-MOV-MES.ValCal-Mes
                WITH FRAME F-Concepto.
            DOWN STREAM strm-concep 1 WITH FRAME F-Concepto.
            IF PL-MOV-MES.ValCal-Mes <> ? THEN
                ASSIGN x-ImpCon = x-ImpCon + PL-MOV-MES.ValCal-Mes.
        END.
        GET NEXT br_pl-flg-m.
    END.
END.
WHEN 2 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Proyecto".
    DO i = 1 TO br_pl-flg-m:NUM-SELECTED-ROWS IN FRAME F-Main:
        ASSIGN stat-reg  = br_pl-flg-m:FETCH-SELECTED-ROW(i).
        IF stat-reg THEN DO:
            DISPLAY
                PL-FLG-MES.proyecto @ FILL-IN-Seccion
                PL-FLG-MES.CodPer @ FILL-IN-Codigo
                WITH FRAME F-Msg.
            IF AVAILABLE PL-PERS THEN
                x-nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
            ELSE x-nombre = "".
            FIND PL-MOV-MES WHERE
                PL-MOV-MES.CodCia  = s-CodCia AND
                PL-MOV-MES.Periodo = s-Periodo AND
                PL-MOV-MES.NroMes  = PL-FLG-MES.nromes AND
                PL-MOV-MES.CodPln  = PL-FLG-MES.codpln AND
                PL-MOV-MES.CodCal  = x-calculo AND
                PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
                PL-MOV-MES.CodMov  = FILL-IN-Concepto NO-LOCK NO-ERROR.
            IF AVAILABLE PL-MOV-MES AND PL-MOV-MES.ValCal-Mes <> 0 THEN DO:
                DISPLAY STREAM strm-concep
                    PL-FLG-MES.CodPer
                    x-nombre
                    PL-MOV-MES.ValCal-Mes
                    WITH FRAME F-Concepto.
                DOWN STREAM strm-concep 1 WITH FRAME F-Concepto.
                IF PL-MOV-MES.ValCal-Mes <> ? THEN
                   ASSIGN x-ImpCon = x-ImpCon + PL-MOV-MES.ValCal-Mes.
            END.
        END.
    END.
    ASSIGN stat-reg = br_pl-flg-m:DESELECT-ROWS().
END.
WHEN 3 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Secci¢n".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        IF PL-FLG-MES.Seccion = COMBO-S THEN DO:
            DISPLAY PL-FLG-MES.CodPer @ FILL-IN-Codigo WITH FRAME F-Msg.
            IF AVAILABLE PL-PERS THEN
                x-nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
            ELSE x-nombre = "".
            FIND PL-MOV-MES WHERE
                PL-MOV-MES.CodCia  = s-CodCia AND
                PL-MOV-MES.Periodo = s-Periodo AND
                PL-MOV-MES.NroMes  = PL-FLG-MES.nromes AND
                PL-MOV-MES.CodPln  = PL-FLG-MES.codpln AND
                PL-MOV-MES.CodCal  = x-calculo AND
                PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
                PL-MOV-MES.CodMov  = FILL-IN-Concepto NO-LOCK NO-ERROR.
            IF AVAILABLE PL-MOV-MES AND PL-MOV-MES.ValCal-Mes <> 0 THEN DO:
                DISPLAY STREAM strm-concep
                    PL-FLG-MES.CodPer
                    x-nombre
                    PL-MOV-MES.ValCal-Mes
                    WITH FRAME F-Concepto.
                DOWN STREAM strm-concep 1 WITH FRAME F-Concepto.
                IF PL-MOV-MES.ValCal-Mes <> ? THEN
                   ASSIGN x-ImpCon = x-ImpCon + PL-MOV-MES.ValCal-Mes.
            END.
        END.
        GET NEXT br_pl-flg-m.
    END.
END.
WHEN 4 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Proyecto".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        IF PL-FLG-MES.Proyecto = COMBO-S THEN DO:
            DISPLAY PL-FLG-MES.CodPer @ FILL-IN-Codigo WITH FRAME F-Msg.
            IF AVAILABLE PL-PERS THEN
                x-nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
            ELSE x-nombre = "".
            FIND PL-MOV-MES WHERE
                PL-MOV-MES.CodCia  = s-CodCia AND
                PL-MOV-MES.Periodo = s-Periodo AND
                PL-MOV-MES.NroMes  = PL-FLG-MES.nromes AND
                PL-MOV-MES.CodPln  = PL-FLG-MES.codpln AND
                PL-MOV-MES.CodCal  = x-calculo AND
                PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
                PL-MOV-MES.CodMov  = FILL-IN-Concepto NO-LOCK NO-ERROR.
            IF AVAILABLE PL-MOV-MES AND PL-MOV-MES.ValCal-Mes <> 0 THEN DO:
                DISPLAY STREAM strm-concep
                    PL-FLG-MES.CodPer
                    x-nombre
                    PL-MOV-MES.ValCal-Mes
                    WITH FRAME F-Concepto.
                DOWN STREAM strm-concep 1 WITH FRAME F-Concepto.
            END.
        END.
        GET NEXT br_pl-flg-m.
    END.
END.

END CASE.

PUT STREAM strm-concep "------------" AT 62 SKIP.
PUT STREAM strm-concep "Importe TOTAL : " TO 61 x-ImpCon AT 62 SKIP.

HIDE FRAME F-Msg.

OUTPUT STREAM strm-concep CLOSE.

IF INPUT TGL-pantalla = TRUE THEN DO:
    RUN bin/_vcat.p ( P-archivo ). 
    OS-DELETE VALUE ( P-archivo ). 
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN FILL-IN-NRO-MES = s-NroMes.
    DISPLAY FILL-IN-NRO-MES WITH FRAME F-Main.
    APPLY "VALUE-CHANGED" TO R-seleccion IN FRAME F-Main.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-PLAN"}
  {src/adm/template/snd-list.i "integral.PL-CALC"}
  {src/adm/template/snd-list.i "INTEGRAL.PL-FLG-MES"}
  {src/adm/template/snd-list.i "INTEGRAL.PL-PERS"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

