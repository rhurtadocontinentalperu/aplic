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

DEFINE VARIABLE CMB-lista AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-linea   AS CHARACTER FORMAT "x(80)" NO-UNDO.
DEFINE VARIABLE x-fecha   AS CHARACTER NO-UNDO.
DEFINE VARIABLE stat-reg  AS LOGICAL NO-UNDO.
DEFINE VARIABLE x-valcalI AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-valcalE AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-valcalA AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-con-reg AS INTEGER NO-UNDO.
DEFINE VARIABLE i         AS INTEGER NO-UNDO.
DEFINE VARIABLE x-dis-mon AS INTEGER EXTENT 5 NO-UNDO.
DEFINE VARIABLE x-acu-mon AS INTEGER EXTENT 5 NO-UNDO.

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

DEFINE BUFFER b-PL-MOV-MES FOR PL-MOV-MES. /* BUFFER para busquedas de referencias */

DEFINE STREAM strm-boleta. /* STREAM para el reporte */

DEFINE TEMP-TABLE tmp-bole
    FIELD t-CodPer AS CHARACTER
    FIELD t-NomPer AS CHARACTER
    FIELD t-ImpIng AS DECIMAL
    FIELD t-ImpEgr AS DECIMAL
    INDEX i-codper IS PRIMARY t-CodPer ASCENDING.

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
&Scoped-define EXTERNAL-TABLES integral.PL-PLAN
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-PLAN


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-PLAN.
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
&Scoped-Define ENABLED-OBJECTS RECT-24 R-seleccion COMBO-S FILL-IN-NRO-MES ~
B-aceptar Btn-UP Btn-DOWN br_pl-flg-m 
&Scoped-Define DISPLAYED-OBJECTS R-seleccion COMBO-S FILL-IN-NRO-MES 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.54.

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
     LIST-ITEMS "","" 
     SIZE 20.43 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

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
"Por secci¢n", 3,
"Por proyecto", 4
     SIZE 14.14 BY 2.08 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 69.72 BY 8.54.

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
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47.14 BY 7.92
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     R-seleccion AT ROW 2.46 COL 5.57 NO-LABEL
     COMBO-S AT ROW 4.69 COL 1.72 NO-LABEL
     FILL-IN-NRO-MES AT ROW 1.31 COL 8.43 COLON-ALIGNED
     B-aceptar AT ROW 5.92 COL 6.43
     Btn-UP AT ROW 1.12 COL 14.43
     Btn-DOWN AT ROW 1.73 COL 14.43
     br_pl-flg-m AT ROW 1.31 COL 22.43
     RECT-24 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.72 BY 8.54
         BGCOLOR 8 FGCOLOR 0 FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.PL-PLAN
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
         HEIGHT             = 8.54
         WIDTH              = 69.72.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
ASSIGN 
       br_pl-flg-m:NUM-LOCKED-COLUMNS IN FRAME F-Main = 1.

/* SETTINGS FOR COMBO-BOX COMBO-S IN FRAME F-Main
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
    ASSIGN FILL-IN-NRO-MES COMBO-S R-seleccion.
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

ASSIGN FILL-IN-NRO-MES = s-NroMes.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-PLAN"}

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

IF NOT CAN-FIND(FIRST PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia AND
    PL-MOV-MES.Periodo = s-Periodo AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-MES.CodCal  = PL-CALC.CodCal AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer) THEN RETURN. /* Si no tiene c lculo */

DISPLAY PL-FLG-MES.CodPer @ FILL-IN-Codigo WITH FRAME F-Msg.

CREATE tmp-bole.
ASSIGN t-CodPer = PL-FLG-MES.CodPer.

FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-MES.CodPer NO-LOCK NO-ERROR.
IF AVAILABLE PL-PERS THEN
    ASSIGN
        t-NomPer = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.

/* Para ingresos */
ASSIGN
    x-valcalE = 0
    x-valcalI = 0.

FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.CodPln = PL-PLAN.CodPln AND
    PL-BOLE.CodCal = PL-CALC.CodCal AND
    PL-BOLE.TpoBol = "Remuneraciones" BY PL-BOLE.nroitm:
    FIND PL-MOV-MES WHERE
        PL-MOV-MES.CodCia  = s-CodCia AND
        PL-MOV-MES.Periodo = s-Periodo AND
        PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
        PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
        PL-MOV-MES.CodCal  = PL-BOLE.CodCal AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        PL-MOV-MES.CodMov  = PL-BOLE.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-MES AND PL-MOV-MES.ValCal-Mes <> 0 THEN DO:
        ASSIGN x-valcalI = x-valcalI + PL-MOV-MES.ValCal-Mes.
    END.
END.

/* Para egresos */
FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.CodPln = PL-PLAN.CodPln AND
    PL-BOLE.CodCal = PL-CALC.CodCal AND
    PL-BOLE.TpoBol = "Descuentos" BY PL-BOLE.nroitm:
    FIND PL-MOV-MES WHERE
        PL-MOV-MES.CodCia  = s-CodCia AND
        PL-MOV-MES.Periodo = s-Periodo AND
        PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
        PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
        PL-MOV-MES.CodCal  = PL-BOLE.CodCal AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        PL-MOV-MES.CodMov  = PL-BOLE.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-MES AND PL-MOV-MES.ValCal-Mes <> 0 THEN DO:
        ASSIGN x-valcalE = x-valcalE + PL-MOV-MES.ValCal-Mes.
    END.
END.

ASSIGN
    t-ImpIng = x-valcalI
    t-ImpEgr = x-valcalE.

RUN distribuye-mon(
    INTEGER(ABS(x-valcalI - x-valcalE)),
    OUTPUT x-dis-mon[1],
    OUTPUT x-dis-mon[2],
    OUTPUT x-dis-mon[3],
    OUTPUT x-dis-mon[4],
    OUTPUT x-dis-mon[5]
    ).
    
ASSIGN
    x-acu-mon[1] = x-acu-mon[1] + x-dis-mon[1]
    x-acu-mon[2] = x-acu-mon[2] + x-dis-mon[2]
    x-acu-mon[3] = x-acu-mon[3] + x-dis-mon[3]
    x-acu-mon[4] = x-acu-mon[4] + x-dis-mon[4]
    x-acu-mon[5] = x-acu-mon[5] + x-dis-mon[5].

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_boleta B-table-Win 
PROCEDURE imp_boleta :
IF NOT CAN-FIND(FIRST PL-MOV-MES WHERE /* Si no tiene c lculo */
    PL-MOV-MES.CodCia  = s-CodCia AND
    PL-MOV-MES.Periodo = s-Periodo AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-MES.CodCal  = PL-CALC.CodCal ) THEN DO:
    BELL.
    MESSAGE "No se efectu¢ ning£n c lculo" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FIND PF-CIAS WHERE PF-CIAS.CodCia = s-CodCia NO-LOCK.

DEFINE VARIABLE x-pagina AS INTEGER FORMAT "ZZZ9" NO-UNDO.
DEFINE VARIABLE x-orden  AS INTEGER NO-UNDO.
DEFINE VARIABLE x-Neto   AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-Imptot AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-titulo AS CHARACTER FORMAT "x(28)" NO-UNDO.
DEFINE VARIABLE x-mes    AS INTEGER.
DEFINE VARIABLE x-ano    AS INTEGER.

CASE PL-CALC.CodCal:
WHEN 2 THEN ASSIGN x-titulo = "   ADELANTO DE QUINCENA".
WHEN 3 THEN DO:
    IF FILL-IN-NRO-MES = 12 THEN
        ASSIGN
            x-mes = 1
            x-ano = s-Periodo + 1.
    ELSE
        ASSIGN
            x-mes = FILL-IN-NRO-MES + 1
            x-ano = s-Periodo.
    RUN bin/_mes.r( x-Mes, 1 , OUTPUT x-titulo ).
    ASSIGN
        x-titulo = "VACACIONES " + x-titulo + " - " +
        STRING( x-ano, "9,999").
END.
WHEN 4 THEN ASSIGN x-titulo = "     GRATIFICACIONES".
END CASE.

DEFINE FRAME f-cab
    x-orden  COLUMN-LABEL "Orden" FORMAT "ZZZ9"
    t-CodPer COLUMN-LABEL "C¢digo" FORMAT "x(6)"
    t-NomPer COLUMN-LABEL "Apellidos y nombre" FORMAT "x(50)"
    t-ImpIng COLUMN-LABEL "Haberes" FORMAT "ZZ,ZZZ,ZZ9.99"
    t-ImpEgr COLUMN-LABEL "Decuentos" FORMAT "ZZ,ZZZ,ZZ9.99"
    x-Neto   COLUMN-LABEL "Importe Neto" FORMAT "ZZ,ZZZ,ZZ9.99"
    HEADER
    PF-CIAS.NomCia FORMAT "x(40)" x-titulo AT 45
    "FECHA :" TO 100 TODAY TO 110 SKIP
    "OFICINA DE RELACIONES INDUSTRIALES"
    "PLANILLA EMPLEADOS - MES #" TO 64 FILL-IN-NRO-MES FORMAT "99"
    "-" S-Periodo FORMAT "9,999"
    "P gina :" TO 100 x-pagina TO 110
    SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 110.

ASSIGN x-acu-mon = 0.

CASE R-seleccion:
WHEN 1 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Secci¢n".
    FOR EACH PL-FLG-MES WHERE
        PL-FLG-MES.CodCia  = s-CodCia AND
        PL-FLG-MES.Periodo = s-Periodo AND
        PL-FLG-MES.NroMes  = FILL-IN-NRO-MES AND
        PL-FLG-MES.CodPln  = PL-PLAN.CodPln NO-LOCK:
        IF PL-FLG-MES.SitAct = "Inactivo" THEN NEXT.
        DISPLAY PL-FLG-MES.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
        RUN busca_datos.
    END.
END.
WHEN 2 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Secci¢n".
    DO i = 1 TO br_pl-flg-m:NUM-SELECTED-ROWS IN FRAME F-Main:
        ASSIGN stat-reg  = br_pl-flg-m:FETCH-SELECTED-ROW(i).
        IF stat-reg THEN DO:
            DISPLAY PL-FLG-MES.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
            RUN busca_datos.
        END.
    END.
    ASSIGN stat-reg = br_pl-flg-m:DESELECT-ROWS().
END.
WHEN 3 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Secci¢n".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    FOR EACH PL-FLG-MES NO-LOCK WHERE
        PL-FLG-MES.CodCia  = s-CodCia AND
        PL-FLG-MES.Periodo = s-Periodo AND
        PL-FLG-MES.NroMes  = FILL-IN-NRO-MES AND
        PL-FLG-MES.CodPln  = PL-PLAN.CodPln AND
        PL-FLG-MES.Seccion = COMBO-S:
        IF PL-FLG-MES.SitAct = "Inactivo" THEN NEXT.
        RUN busca_datos.
    END.
END.
WHEN 4 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Proyecto".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    FOR EACH PL-FLG-MES NO-LOCK WHERE
        PL-FLG-MES.CodCia   = s-CodCia AND
        PL-FLG-MES.Periodo  = s-Periodo AND
        PL-FLG-MES.NroMes   = FILL-IN-NRO-MES AND
        PL-FLG-MES.CodPln   = PL-PLAN.CodPln AND
        PL-FLG-MES.Proyecto = COMBO-S:
        IF PL-FLG-MES.SitAct = "Inactivo" THEN NEXT.
        RUN busca_datos.
    END.
END.

END CASE.

HIDE FRAME F-Msg.

IF NOT CAN-FIND(FIRST tmp-bole) THEN RETURN.

OUTPUT STREAM strm-boleta TO PRINTER PAGED PAGE-SIZE 66.

/* Seteo de impresi¢n (Impresora EPSON) */
PUT STREAM strm-boleta CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66).
PUT STREAM strm-boleta CONTROL "~033x" NULL "~017~033P".

ASSIGN
    x-con-reg = 1
    x-pagina  = 1
    x-orden   = 0.

FOR EACH tmp-bole NO-LOCK:
    ASSIGN
        x-Neto   = tmp-bole.t-ImpIng - tmp-bole.t-ImpEgr
        x-Imptot = x-Imptot + x-Neto
        x-orden  = x-orden + 1.
    DISPLAY STREAM strm-boleta
        x-orden
        tmp-bole.t-CodPer
        tmp-bole.t-NomPer
        tmp-bole.t-ImpIng
        tmp-bole.t-ImpEgr
        x-Neto
        WITH FRAME f-cab.
    IF LINE-COUNTER( strm-boleta ) > 62 THEN DO:
        ASSIGN x-pagina = x-pagina + 1.
        PAGE STREAM strm-boleta.
    END.
END.

PUT STREAM strm-boleta
    "-----" FILL(" ",87) FORMAT "x(87)" "-------------" SKIP.

PUT STREAM strm-boleta
    x-orden FORMAT "ZZZZ9" " <--- TOTAL PERSONAL"
    FILL(" ",57) FORMAT "x(57)" "IMPORTE : "
    x-ImpTot FORMAT "ZZ,ZZZ,ZZ9.99" SKIP.

PUT STREAM strm-boleta
    "=====" FILL(" ",87) FORMAT "x(87)" "=============" SKIP(1).

PUT STREAM strm-boleta "DISTRIBUCION GENERAL DE MONEDAS" SKIP.
PUT STREAM strm-boleta "-------------------------------" SKIP.
PUT STREAM strm-boleta "Monedas de 1 Sol      : " x-acu-mon[1] FORMAT "ZZ,ZZ9" SKIP.
PUT STREAM strm-boleta "Monedas de 5 Soles    : " x-acu-mon[2] FORMAT "ZZ,ZZ9" SKIP.
PUT STREAM strm-boleta "Billetes de 10 Soles  : " x-acu-mon[3] FORMAT "ZZ,ZZ9" SKIP.
PUT STREAM strm-boleta "Billetes de 50 Soles  : " x-acu-mon[4] FORMAT "ZZ,ZZ9" SKIP.
PUT STREAM strm-boleta "Billetes de 100 Soles : " x-acu-mon[5] FORMAT "ZZ,ZZ9" SKIP.


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


