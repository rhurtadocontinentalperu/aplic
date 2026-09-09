&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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

DEFINE VARIABLE CMB-seccion AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-linea     AS CHARACTER FORMAT "x(80)" NO-UNDO.
DEFINE VARIABLE x-fecha     AS CHARACTER NO-UNDO.
DEFINE VARIABLE stat-reg    AS LOGICAL NO-UNDO.
DEFINE VARIABLE x-valcalI   AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-valcalE   AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-valcalA   AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-con-reg   AS INTEGER NO-UNDO.
DEFINE VARIABLE i           AS INTEGER NO-UNDO.
DEFINE VARIABLE x-dis-mon   AS INTEGER EXTENT 5 NO-UNDO.
DEFINE VARIABLE x-acu-mon   AS INTEGER EXTENT 5 NO-UNDO.

DEFINE BUTTON Btn_OK IMAGE-UP FILE "img/print-2" SIZE 5.43 BY 1.46 BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-Codigo AS CHARACTER FORMAT "X(6)":U 
    LABEL "Personal" VIEW-AS FILL-IN SIZE 7.57 BY .81 BGCOLOR 15 FGCOLOR 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-seccion AS CHARACTER FORMAT "X(60)":U 
    LABEL "Secci¢n" VIEW-AS FILL-IN SIZE 26.14 BY .81 BGCOLOR 15 FGCOLOR 9 NO-UNDO.

DEFINE RECTANGLE RECT-1
    EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL SIZE 37.29 BY 3.88 BGCOLOR 8 FGCOLOR 0 .

DEFINE FRAME D-Dialog
    FILL-IN-seccion AT ROW 2.88 COL 8.72 COLON-ALIGNED
    FILL-IN-Codigo AT ROW 3.73 COL 8.72 COLON-ALIGNED
    Btn_OK AT ROW 1.27 COL 30.72
    RECT-1 AT ROW 1 COL 1
    "Espere un momento por favor ..." VIEW-AS TEXT
    SIZE 26.57 BY .5 AT ROW 1.31 COL 2.29
    "Procesando consistencia para:" VIEW-AS TEXT
    SIZE 23.57 BY .5 AT ROW 2 COL 2.29
    SPACE(12.42) SKIP(2.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
    FONT 6 TITLE "Procesando..." CENTERED.

DEFINE BUFFER b-PL-MOV-MES FOR PL-MOV-MES. /* BUFFER para busquedas de referencias */

DEFINE STREAM strm-boleta. /* STREAM para el reporte */

DEFINE TEMP-TABLE tmp-bole
    FIELD t-CodPer  AS CHARACTER
    FIELD t-Linea   AS INTEGER
    FIELD t-Dato    AS CHARACTER FORMAT "x(137)"
    INDEX i-codper IS PRIMARY t-CodPer t-linea ASCENDING.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

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
&Scoped-define INTERNAL-TABLES integral.PL-FLG-MES integral.PL-PERS

/* Definitions for BROWSE br_pl-flg-m                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-m 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_pl-flg-m
&Scoped-define OPEN-QUERY-br_pl-flg-m OPEN QUERY br_pl-flg-m FOR EACH integral.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES ~
 AND PL-FLG-MES.SitAct <> "Inactivo" NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-MES NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES ~
integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_pl-flg-m}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS R-seleccion COMBO-1 B-aceptar ~
FILL-IN-NRO-MES br_pl-flg-m 
&Scoped-Define DISPLAYED-OBJECTS R-seleccion COMBO-1 FILL-IN-NRO-MES 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for VBX Containers                            */
DEFINE VARIABLE hc_PSSpin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.54.

DEFINE VARIABLE COMBO-1 AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 18.14 BY 1
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
"Una Secci¢n", 3
     SIZE 14.29 BY 1.65 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_pl-flg-m FOR 
      integral.PL-FLG-MES, 
      integral.PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_pl-flg-m
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-flg-m B-table-Win _STRUCTURED
  QUERY br_pl-flg-m NO-LOCK DISPLAY
      integral.PL-FLG-MES.codper
      integral.PL-PERS.patper
      integral.PL-PERS.matper
      integral.PL-PERS.nomper
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47.14 BY 6.73
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     R-seleccion AT ROW 2.08 COL 3.86 NO-LABEL
     COMBO-1 AT ROW 3.73 COL 1.43 NO-LABEL
     B-aceptar AT ROW 4.77 COL 5
     FILL-IN-NRO-MES AT ROW 1.08 COL 7 COLON-ALIGNED
     br_pl-flg-m AT ROW 1.12 COL 20.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 66.86 BY 6.85
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 6.85
         WIDTH              = 66.86.
                                                                        */
&ANALYZE-RESUME

/* **********************  Create VBX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&WINDOW-SYSTEM}" = "MS-WINDOWS":U &THEN

/* VBX BINARY:FILENAME is: G:\integral\APLIC\PLN\B-CONS-S.wbx */

CREATE CONTROL-CONTAINER hc_PSSpin ASSIGN
       FRAME        = FRAME F-Main:HANDLE
       NAME         = "hc_PSSpin":U
       HIDDEN       = no
       SENSITIVE    = yes
       ROW          = 1.04
       COLUMN       = 13.14
       HEIGHT       = .96
       BGCOLOR      = 7
       WIDTH        = 3 .
/* hc_PSSpin VBXINFO:CREATE-CONTROL from: psspin.vbx type: PSSpin */

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
ASSIGN 
       br_pl-flg-m:NUM-LOCKED-COLUMNS IN FRAME F-Main = 1.

/* SETTINGS FOR COMBO-BOX COMBO-1 IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-m
/* Query rebuild information for BROWSE br_pl-flg-m
     _TblList          = "integral.PL-FLG-MES,integral.PL-PERS OF integral.PL-FLG-MES"
     _Options          = "NO-LOCK"
     _Where[1]         = "PL-FLG-MES.CodCia = s-CodCia
 AND PL-FLG-MES.Periodo = s-Periodo
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES
 AND PL-FLG-MES.SitAct <> ""Inactivo"""
     _FldNameList[1]   = integral.PL-FLG-MES.codper
     _FldNameList[2]   = integral.PL-PERS.patper
     _FldNameList[3]   = integral.PL-PERS.matper
     _FldNameList[4]   = integral.PL-PERS.nomper
     _Query            is OPENED
*/  /* BROWSE br_pl-flg-m */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar B-table-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN FILL-IN-NRO-MES COMBO-1 R-seleccion.
    RUN imp_boleta.
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


&Scoped-define SELF-NAME COMBO-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-1 B-table-Win
ON ENTRY OF COMBO-1 IN FRAME F-Main
DO:
    ASSIGN i = 0.
    FOR EACH integral.PL-SECC NO-LOCK:
        IF i = 0 THEN ASSIGN CMB-Seccion = COMBO-1.
        ELSE ASSIGN CMB-Seccion = CMB-Seccion + "," + integral.PL-SECC.seccio.
        ASSIGN i = i + 1.
    END.
    COMBO-1:LIST-ITEMS IN FRAME F-Main = CMB-Seccion.
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


&Scoped-define SELF-NAME hc_PSSpin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hc_PSSpin B-table-Win
PROCEDURE hc_PSSpin.SPINDOWN .
IF INPUT FRAME F-Main FILL-IN-NRO-MES - 1 >= 1 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-MES - 1 @ FILL-IN-NRO-MES WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-MES.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hc_PSSpin B-table-Win
PROCEDURE hc_PSSpin.SPINUP .
IF INPUT FRAME F-Main FILL-IN-NRO-MES + 1 <= 54 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-MES + 1 @ FILL-IN-NRO-MES WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-MES.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

END PROCEDURE.

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
            COMBO-1:SENSITIVE  = FALSE.
    WHEN 2 THEN
        ASSIGN
            Br_pl-flg-m:SENSITIVE = TRUE
            COMBO-1:SENSITIVE  = FALSE.
    WHEN 3 THEN
        ASSIGN
            Br_pl-flg-m:SENSITIVE = FALSE
            COMBO-1:SENSITIVE  = TRUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acumula_conceptos B-table-Win 
PROCEDURE acumula_conceptos :
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca_datos B-table-Win 
PROCEDURE busca_datos :
/*------------------------------------------------------------------------------
    Busca datos
------------------------------------------------------------------------------*/
DEFINE VARIABLE x-dato AS CHARACTER FORMAT "x(137)".
DEFINE VARIABLE x-importe AS DECIMAL.

DISPLAY PL-FLG-MES.CodPer @ FILL-IN-Codigo WITH FRAME D-Dialog.

CREATE tmp-bole.
ASSIGN tmp-bole.t-CodPer = PL-FLG-MES.CodPer
       tmp-bole.t-Linea  = 1.

x-dato = "! " + PL-FLG-MES.CodPer + " ! ".
FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-MES.CodPer NO-LOCK NO-ERROR.
IF AVAILABLE PL-PERS THEN
    ASSIGN
        x-dato = x-dato + STRING(PL-PERS.PatPer + " " +
            PL-PERS.MatPer + " " + PL-PERS.NomPer,"x(40)").
ELSE x-dato = x-dato + FILL(" ",40).          

ASSIGN x-dato = x-dato + 
        " ! CARGO               : " + STRING(PL-FLG-MES.cargo, "x(20)").

ASSIGN x-dato = x-dato + 
        " ! HABER BASICO        : ".

FIND PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia AND
    PL-MOV-MES.Periodo = s-Periodo AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-MES.CodCal  = 0 AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
    PL-MOV-MES.CodMov  = 1 NO-LOCK NO-ERROR.
IF AVAILABLE PL-MOV-MES THEN
    ASSIGN
        x-dato = x-dato + STRING(PL-MOV-MES.ValCal-Mes,"ZZZ,ZZ9.99")
        x-importe = x-importe + PL-MOV-MES.ValCal-Mes.
ELSE x-dato = x-dato + FILL(" ",10).

ASSIGN tmp-bole.t-dato = x-dato.

x-dato = "!      ! ".
x-dato = x-dato + "TIPO DE REMUNERACION  :  SUELDO         ".
ASSIGN x-dato = x-dato + " ! FECHA DE NACIMIENTO : ".
IF AVAILABLE PL-PERS THEN ASSIGN 
        x-dato = x-dato + STRING(integral.PL-PERS.fecnac).
ELSE x-dato = x-dato + FILL(" ",8).
ASSIGN x-dato = x-dato + FILL(" ",12).
       
ASSIGN x-dato = x-dato + 
    " ! BONIFICAC. AL CARGO : ".
FIND PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia AND
    PL-MOV-MES.Periodo = s-Periodo AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-MES.CodCal  = 0 AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
    PL-MOV-MES.CodMov  = 3 NO-LOCK NO-ERROR.
IF AVAILABLE PL-MOV-MES THEN
    ASSIGN
        x-dato = x-dato + STRING(PL-MOV-MES.ValCal-Mes,"ZZZ,ZZ9.99")
        x-importe = x-importe + PL-MOV-MES.ValCal-Mes.
ELSE x-dato = x-dato + FILL(" ",10).        

CREATE tmp-bole.
ASSIGN tmp-bole.t-CodPer = PL-FLG-MES.CodPer
       tmp-bole.t-Linea  = 2
       tmp-bole.t-dato   = x-dato.        

x-dato = "!      ! ".
x-dato = x-dato + "LIB.ELECTORAL         : ".
IF AVAILABLE PL-PERS THEN ASSIGN
    x-dato = x-dato + STRING(integral.PL-PERS.lelect, "99999999").
ELSE x-dato = x-dato + FILL(" ",8).    
x-dato = x-dato + FILL(" ",8).

ASSIGN x-dato = x-dato + " ! FECHA DE INGRESO    : ".
ASSIGN x-dato = x-dato + STRING(PL-FLG-MES.fecing).
ASSIGN x-dato = x-dato + FILL(" ",12).

ASSIGN x-dato = x-dato + 
    " ! BONIF/SUPLEMENTARIA : " + FILL(" ",10).        

CREATE tmp-bole.
ASSIGN tmp-bole.t-CodPer = PL-FLG-MES.CodPer
       tmp-bole.t-Linea = 3
       tmp-bole.t-dato = x-dato.        

x-dato = "!      ! ".
x-dato = x-dato + "LIB.TRIBUTARIA        : ".
x-dato = x-dato + FILL(" ",16).

ASSIGN x-dato = x-dato + " ! FECHA DE CESE       : ".
IF PL-FLG-MES.VCONTR <> ? THEN 
     x-dato = x-dato + (STRING(PL-FLG-MES.VCONTR)).
ELSE x-dato = x-dato + FILL(" ",8).
ASSIGN x-dato = x-dato + FILL(" ",12).

ASSIGN x-dato = x-dato + 
    " ! BONIF/ALIMENTACION  : ".

FIND PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia AND
    PL-MOV-MES.Periodo = s-Periodo AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-MES.CodCal  = 1 AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
    PL-MOV-MES.CodMov  = 5 NO-LOCK NO-ERROR.
IF AVAILABLE PL-MOV-MES THEN
    ASSIGN
        x-dato = x-dato + STRING(PL-MOV-MES.ValCal-Mes,"ZZZ,ZZ9.99")
        x-importe = x-importe + PL-MOV-MES.ValCal-Mes.
ELSE x-dato = x-dato + FILL(" ",10).        

CREATE tmp-bole.
ASSIGN tmp-bole.t-CodPer = PL-FLG-MES.CodPer
       tmp-bole.t-Linea = 4
       tmp-bole.t-dato = x-dato.        
       
x-dato = "!      ! ".
x-dato = x-dato + "CARNE  S.S.P.         : ".
x-dato = x-dato + STRING(PL-PERS.ctipss, "x(15)") + FILL(" ",1).

ASSIGN x-dato = x-dato + " ! ESTADO CIVIL        : ".
IF integral.PL-FLG-MES.Conyugue = NO THEN x-dato = x-dato + "SOLTERO/A ".
ELSE x-dato = x-dato + "CASADO/A  ".
ASSIGN x-dato = x-dato + FILL(" ",10).

ASSIGN x-dato = x-dato + 
    " ! BONIF/MOVILIDAD     : ".
FIND PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia AND
    PL-MOV-MES.Periodo = s-Periodo AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-MES.CodCal  = 1 AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
    PL-MOV-MES.CodMov  = 7 NO-LOCK NO-ERROR.
IF AVAILABLE PL-MOV-MES THEN
    ASSIGN
        x-dato = x-dato + STRING(PL-MOV-MES.ValCal-Mes,"ZZZ,ZZ9.99")
        x-importe = x-importe + PL-MOV-MES.ValCal-Mes.
ELSE x-dato = x-dato + FILL(" ",10).        

CREATE tmp-bole.
ASSIGN tmp-bole.t-CodPer = PL-FLG-MES.CodPer
       tmp-bole.t-linea = 5
       tmp-bole.t-dato = x-dato.               
       

x-dato = "!      ! ".
x-dato = x-dato + "DIRECCION             : ".
IF AVAILABLE PL-PERS THEN ASSIGN
    x-dato = x-dato + STRING(integral.PL-PERS.dirper, "x(15)") + FILL(" ",1).
ELSE x-dato = x-dato + FILL(" ",16).   

ASSIGN x-dato = x-dato + " ! NUMERO DE HIJOS     : ".
ASSIGN x-dato = x-dato + STRING(integral.PL-FLG-MES.Nro-de-Hijos,"99"). 
ASSIGN x-dato = x-dato + FILL(" ",18).

ASSIGN x-dato = x-dato + 
    " ! ASIS.X HIJO         : ".

FIND PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia AND
    PL-MOV-MES.Periodo = s-Periodo AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-MES.CodCal  = 1 AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
    PL-MOV-MES.CodMov  = 11 NO-LOCK NO-ERROR.
IF AVAILABLE PL-MOV-MES THEN
    ASSIGN
        x-dato = x-dato + STRING(PL-MOV-MES.ValCal-Mes,"ZZZ,ZZ9.99")
        x-importe = x-importe + PL-MOV-MES.ValCal-Mes.
ELSE x-dato = x-dato + FILL(" ",10).        

CREATE tmp-bole.
ASSIGN tmp-bole.t-CodPer = PL-FLG-MES.CodPer
       tmp-bole.t-linea = 6
       tmp-bole.t-dato = x-dato.               
       
x-dato = "!      ! ".
x-dato = x-dato + "DISTRITO              : ".
IF AVAILABLE PL-PERS THEN ASSIGN
    x-dato = x-dato + STRING(integral.PL-PERS.distri, "x(15)") + FILL(" ",1).
ELSE x-dato = x-dato + FILL(" ",16).   
x-dato = x-dato + FILL(" ",45).   

ASSIGN x-dato = x-dato + 
    " ! BONIF.X TPO.SERV    : ".    

FIND PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia AND
    PL-MOV-MES.Periodo = s-Periodo AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-MES.CodCal  = 1 AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
    PL-MOV-MES.CodMov  = 9 NO-LOCK NO-ERROR.
IF AVAILABLE PL-MOV-MES THEN
    ASSIGN
        x-dato = x-dato + STRING(PL-MOV-MES.ValCal-Mes,"ZZZ,ZZ9.99")
        x-importe = x-importe + PL-MOV-MES.ValCal-Mes.    
ELSE DO:
    FIND PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia AND
    PL-MOV-MES.Periodo = s-Periodo AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-MES.CodCal  = 1 AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
    PL-MOV-MES.CodMov  = 10 NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-MES THEN
        ASSIGN x-dato = x-dato + STRING(PL-MOV-MES.ValCal-Mes,"ZZZ,ZZ9.99")
               x-importe = x-importe + PL-MOV-MES.ValCal-Mes.        
    ELSE ASSIGN x-dato = x-dato + FILL(" ",10).        
END.

CREATE tmp-bole.
ASSIGN tmp-bole.t-CodPer = PL-FLG-MES.CodPer
       tmp-bole.t-linea = 7
       tmp-bole.t-dato = x-dato.                      
       
x-dato = "!      ! ".
x-dato = x-dato + FILL(" ",40).   
x-dato = x-dato + FILL(" ",45).

ASSIGN x-dato = x-dato + 
    " ! BONIF/QUINQUENIO    : ".    
FIND PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia AND
    PL-MOV-MES.Periodo = s-Periodo AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-MES.CodCal  = 1 AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
    PL-MOV-MES.CodMov  = 8 NO-LOCK NO-ERROR.
IF AVAILABLE PL-MOV-MES THEN
    ASSIGN
        x-dato = x-dato + STRING(PL-MOV-MES.ValCal-Mes,"ZZZ,ZZ9.99")
        x-importe = x-importe + PL-MOV-MES.ValCal-Mes.
ELSE x-dato = x-dato + FILL(" ",10).        

CREATE tmp-bole.
ASSIGN tmp-bole.t-CodPer = PL-FLG-MES.CodPer
       tmp-bole.t-linea = 8
       tmp-bole.t-dato = x-dato.                             

x-dato = "!      ! ".
x-dato = x-dato + FILL(" ",40).   
x-dato = x-dato + FILL(" ",45).

ASSIGN x-dato = x-dato + 
    " ! INCREMENT AFP 10.23 : ".    
FIND PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia AND
    PL-MOV-MES.Periodo = s-Periodo AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-MES.CodCal  = 1 AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
    PL-MOV-MES.CodMov  = 13 NO-LOCK NO-ERROR.
IF AVAILABLE PL-MOV-MES THEN
    ASSIGN
        x-dato = x-dato + STRING(PL-MOV-MES.ValCal-Mes,"ZZZ,ZZ9.99")
        x-importe = x-importe + PL-MOV-MES.ValCal-Mes.
ELSE x-dato = x-dato + FILL(" ",10).        

CREATE tmp-bole.
ASSIGN tmp-bole.t-CodPer = PL-FLG-MES.CodPer
       tmp-bole.t-linea = 9
       tmp-bole.t-dato = x-dato.                             
       
x-dato = "!      ! ".
x-dato = x-dato + FILL(" ",40).   
x-dato = x-dato + FILL(" ",45).

ASSIGN x-dato = x-dato + 
    " ! INCREMENTO  AFP  3% : ".    
FIND PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia AND
    PL-MOV-MES.Periodo = s-Periodo AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-MES.CodCal  = 1 AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
    PL-MOV-MES.CodMov  = 14 NO-LOCK NO-ERROR.
IF AVAILABLE PL-MOV-MES THEN
    ASSIGN
        x-dato = x-dato + STRING(PL-MOV-MES.ValCal-Mes,"ZZZ,ZZ9.99")
        x-importe = x-importe + PL-MOV-MES.ValCal-Mes.
ELSE x-dato = x-dato + FILL(" ",10).        

CREATE tmp-bole.
ASSIGN tmp-bole.t-CodPer = PL-FLG-MES.CodPer
       tmp-bole.t-linea = 10
       tmp-bole.t-dato = x-dato.                                    
       
x-dato = "!      ! ".
x-dato = x-dato + FILL(" ",40).   
x-dato = x-dato + FILL(" ",45).

ASSIGN x-dato = x-dato + 
    " ! PROM.BRUTO MENSUAL  : ".    
x-dato = x-dato + STRING(x-importe,"ZZZ,ZZ9.99").    

CREATE tmp-bole.
ASSIGN tmp-bole.t-CodPer = PL-FLG-MES.CodPer
       tmp-bole.t-linea = 11
       tmp-bole.t-dato = x-dato.                                    
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load B-table-Win _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the VBX controls    
  Parameters:  <none>
  Notes:       Here we load and make visible the VBX controls
               in the interface.                             
------------------------------------------------------------------------------*/

&IF "{&WINDOW-SYSTEM}" = "MS-WINDOWS":U &THEN
DEFINE VARIABLE UIB_S   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE VBXFILE AS CHARACTER NO-UNDO.

VBXFILE = SEARCH( "G:\integral\APLIC\PLN\B-CONS-S.wbx":U ).

IF VBXFILE <> ? THEN
  ASSIGN
    UIB_S = hc_PSSpin:LOAD-CONTROL( VBXFILE )
  .
ELSE MESSAGE "The file, G:\integral\APLIC\PLN\B-CONS-S.wbx, could not be found." skip
             "The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE distribuye-mon B-table-Win 
PROCEDURE distribuye-mon :
/*------------------------------------------------------------------------------
    Distribuci¢n de monedas.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER x-total   AS INTEGER.
DEFINE OUTPUT PARAMETER x-moneda1 AS INTEGER. /* Monedas de 1 Sol */
DEFINE OUTPUT PARAMETER x-moneda2 AS INTEGER. /* Monedas de 5 Soles */
DEFINE OUTPUT PARAMETER x-moneda3 AS INTEGER. /* Billetes de 10 Soles */
DEFINE OUTPUT PARAMETER x-moneda4 AS INTEGER. /* Billetes de 50 Soles */
DEFINE OUTPUT PARAMETER x-moneda5 AS INTEGER. /* Billetes de 100 Soles */

CASE LENGTH(STRING(x-total)):
WHEN 1 THEN
    ASSIGN x-moneda1 = x-total.
WHEN 2 THEN
    ASSIGN
        x-moneda3 = TRUNCATE(x-total / 10,0) 
        x-moneda1 = x-total MODULO 10.
WHEN 3 OR WHEN 4 OR WHEN 5 THEN
    ASSIGN
        x-moneda5 = TRUNCATE(x-total / 100,0)
        x-moneda1 = x-total MODULO 100
        x-moneda3 = TRUNCATE(x-moneda1 / 10,0)
        x-moneda1 = x-moneda1 MODULO 10.
END CASE.

IF x-moneda1 >= 5 THEN
    ASSIGN
        x-moneda2 = 1
        x-moneda1 = x-moneda1 - 5.
        
IF x-moneda3 >= 5 THEN
    ASSIGN
        x-moneda4 = 1
        x-moneda3 = x-moneda3 - 5.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fecha_pago B-table-Win 
PROCEDURE fecha_pago :
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_boleta B-table-Win 
PROCEDURE imp_boleta :
/*------------------------------------------------------------------------------
    Impresi¢n de consistencia de boleta de pago.
------------------------------------------------------------------------------*/

IF NOT CAN-FIND(FIRST PL-FLG-MES WHERE /* Si no tiene por lo menos una persona */
    PL-FLG-MES.CodCia  = s-CodCia AND
    PL-FLG-MES.Periodo = s-Periodo AND
    PL-FLG-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-FLG-MES.CodPln  = PL-PLAN.CodPln ) THEN DO:
    BELL.
    MESSAGE "No se encuentra personal asignado al mes" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FIND PF-CIAS WHERE PF-CIAS.CodCia = s-CodCia NO-LOCK.

DEFINE VARIABLE x-pagina AS INTEGER FORMAT "ZZZ9" NO-UNDO.
DEFINE VARIABLE x-titulo AS CHARACTER FORMAT "x(30)" NO-UNDO.

DEFINE FRAME f-cab
    t-dato
    HEADER
    PF-CIAS.NomCia x-titulo AT 55 "FECHA :" TO 130 TODAY TO 140 SKIP
    "OFICINA DE RELACIONES INDUSTRIALES"
    "DIRECTORIO EMPLEADOS - MES #" TO 76 s-NroMes FORMAT "99"
    "-" s-periodo FORMAT "9,999"
    "P gina : " TO 130 x-pagina TO 140
    SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 150 NO-LABEL NO-UNDERLINE.

CASE R-seleccion:
WHEN 1 THEN DO:
    FOR EACH PL-FLG-MES WHERE
        PL-FLG-MES.CodCia  = s-CodCia AND
        PL-FLG-MES.Periodo = s-Periodo AND
        PL-FLG-MES.NroMes  = FILL-IN-NRO-MES AND
        PL-FLG-MES.CodPln  = PL-PLAN.CodPln NO-LOCK:
        DISPLAY PL-FLG-MES.seccion @ FILL-IN-Seccion WITH FRAME D-Dialog.
        RUN busca_datos.
    END.
END.
WHEN 2 THEN DO:
    DO i = 1 TO br_pl-flg-m:NUM-SELECTED-ROWS IN FRAME F-Main:
        ASSIGN stat-reg  = br_pl-flg-m:FETCH-SELECTED-ROW(i).
        IF stat-reg THEN DO:
            DISPLAY PL-FLG-MES.seccion @ FILL-IN-Seccion WITH FRAME D-Dialog.
        RUN busca_datos.
        END.
    END.
    ASSIGN stat-reg = br_pl-flg-m:DESELECT-ROWS().
END.
WHEN 3 THEN DO:
    DISPLAY COMBO-1 @ FILL-IN-Seccion WITH FRAME D-Dialog.
    FOR EACH PL-FLG-MES NO-LOCK WHERE
        PL-FLG-MES.CodCia  = s-CodCia AND
        PL-FLG-MES.Periodo = s-Periodo AND
        PL-FLG-MES.NroMes  = FILL-IN-NRO-MES AND
        PL-FLG-MES.CodPln  = PL-PLAN.CodPln AND
        PL-FLG-MES.Seccion = COMBO-1:
        RUN busca_datos.
    END.
END.

END CASE.

HIDE FRAME D-Dialog.

IF NOT CAN-FIND(FIRST tmp-bole) THEN RETURN.

OUTPUT STREAM strm-boleta TO PRINTER PAGED PAGE-SIZE 66.

/* Seteo de impresi¢n (Impresora EPSON) */
PUT STREAM strm-boleta CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66).
PUT STREAM strm-boleta CONTROL "~033x" NULL "~017~033P".

ASSIGN
    x-con-reg = 1
    x-pagina  = 1.

FOR EACH tmp-bole BREAK BY tmp-bole.t-CodPer:
    IF FIRST-OF(tmp-bole.t-CodPer) THEN
        IF x-con-reg >= 6 THEN DO:
            ASSIGN
                x-con-reg = 1
                x-pagina  = x-pagina + 1.
            PAGE STREAM strm-boleta.
        END.
    DISPLAY STREAM strm-boleta 
        tmp-bole.t-dato
        WITH FRAME f-cab.
    IF LAST-OF(tmp-bole.t-CodPer) THEN DO:
        ASSIGN x-con-reg = x-con-reg + 1.
        PUT STREAM strm-boleta FILL("-", 140) FORMAT "x(140)" SKIP.
    END.
END.

PAGE STREAM strm-boleta.

PUT STREAM strm-boleta "" SKIP(6).

OUTPUT STREAM strm-boleta CLOSE.

FOR EACH tmp-bole:
    DELETE tmp-bole.
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
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
  {src/adm/template/snd-list.i "integral.PL-FLG-MES"}
  {src/adm/template/snd-list.i "integral.PL-PERS"}

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


