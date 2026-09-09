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

DEFINE VARIABLE CMB-lista AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-linea   AS CHARACTER FORMAT "x(80)" NO-UNDO.
DEFINE VARIABLE x-fecha   AS CHARACTER NO-UNDO.
DEFINE VARIABLE stat-reg  AS LOGICAL NO-UNDO.
DEFINE VARIABLE x-valcalI AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-valcalE AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-impIng  AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-impEgr  AS DECIMAL NO-UNDO.
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

DEFINE STREAM strm-boleta. /* STREAM para el reporte */

DEFINE TEMP-TABLE tmp-bole
    FIELD t-codcia AS INTEGER
    FIELD t-CodPer AS CHARACTER
    FIELD t-NomPer AS CHARACTER
    FIELD t-TpoPer AS CHARACTER
    FIELD t-ImpIng AS DECIMAL
    FIELD t-ImpEgr AS DECIMAL
    FIELD t-FchIng AS DATE
    INDEX i-codper IS PRIMARY t-CodPer ASCENDING.


DEFINE VARIABLE x-pagina  AS INTEGER FORMAT "ZZZ9" NO-UNDO.
DEFINE VARIABLE x-orden   AS INTEGER NO-UNDO.
DEFINE VARIABLE x-total   AS INTEGER NO-UNDO.
DEFINE VARIABLE x-Neto    AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-Imptot  AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-titulo  AS CHARACTER FORMAT "x(28)" NO-UNDO.
DEFINE VARIABLE p-archivo AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-mes     AS INTEGER.
DEFINE VARIABLE x-ano     AS INTEGER.

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
 /*AND PL-FLG-MES.SitAct <> "Inactivo"*/ NO-LOCK, ~
      EACH INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-MES NO-LOCK ~
    BY INTEGRAL.PL-FLG-MES.seccion ~
       BY INTEGRAL.PL-PERS.patper ~
        BY INTEGRAL.PL-PERS.matper ~
         BY INTEGRAL.PL-PERS.nomper
&Scoped-define OPEN-QUERY-br_pl-flg-m OPEN QUERY br_pl-flg-m FOR EACH INTEGRAL.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES ~
 /*AND PL-FLG-MES.SitAct <> "Inactivo"*/ NO-LOCK, ~
      EACH INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-MES NO-LOCK ~
    BY INTEGRAL.PL-FLG-MES.seccion ~
       BY INTEGRAL.PL-PERS.patper ~
        BY INTEGRAL.PL-PERS.matper ~
         BY INTEGRAL.PL-PERS.nomper.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-m INTEGRAL.PL-FLG-MES ~
INTEGRAL.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-m INTEGRAL.PL-FLG-MES
&Scoped-define SECOND-TABLE-IN-QUERY-br_pl-flg-m INTEGRAL.PL-PERS


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_pl-flg-m}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-24 Btn-UP br_pl-flg-m FILL-IN-NRO-MES ~
Btn-DOWN R-seleccion COMBO-S TGL-pantalla TGL-Excel B-aceptar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NRO-MES R-seleccion COMBO-S ~
TGL-pantalla TGL-Excel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "&Aceptar" 
     SIZE 10 BY 1.54.

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

DEFINE VARIABLE FILL-IN-NRO-MES AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE R-seleccion AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todo el personal", 1,
"Selectivo", 2,
"Por sección", 3,
"Por proyecto", 4
     SIZE 14.14 BY 2.08 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.72 BY 8.54.

DEFINE VARIABLE TGL-Excel AS LOGICAL INITIAL no 
     LABEL "Excel" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .77 NO-UNDO.

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
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47.14 BY 7.92
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn-UP AT ROW 1.12 COL 14.43
     br_pl-flg-m AT ROW 1.31 COL 22.43
     FILL-IN-NRO-MES AT ROW 1.35 COL 8.57 COLON-ALIGNED
     Btn-DOWN AT ROW 1.73 COL 14.43
     R-seleccion AT ROW 2.38 COL 5.29 NO-LABEL
     COMBO-S AT ROW 4.5 COL 1.72 NO-LABEL
     TGL-pantalla AT ROW 5.62 COL 5
     TGL-Excel AT ROW 6.19 COL 5
     B-aceptar AT ROW 7.35 COL 2
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
         HEIGHT             = 8.54
         WIDTH              = 69.72.
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
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.PL-FLG-MES.seccion|yes,INTEGRAL.PL-PERS.patper|yes,INTEGRAL.PL-PERS.matper|yes,INTEGRAL.PL-PERS.nomper|yes"
     _Where[1]         = "PL-FLG-MES.CodCia = s-CodCia
 AND PL-FLG-MES.Periodo = s-Periodo
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES
 /*AND PL-FLG-MES.SitAct <> ""Inactivo""*/"
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
    ASSIGN FILL-IN-NRO-MES COMBO-S R-seleccion TGL-Excel.
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
ASSIGN
    t-CodPer = PL-FLG-MES.CodPer
    t-TpoPer = PL-FLG-MES.seccion.

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
    t-FchIng = PL-FLG-MES.FecIng
    t-ImpIng = x-valcalI
    t-ImpEgr = x-valcalE
    x-ImpIng = x-ImpIng + x-valcalI
    x-ImpEgr = x-ImpEgr + x-valcalE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
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
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* encabezado */
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = PF-CIAS.NomCia.
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = 'CALCULO : ' + PL-CALC.descal.
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "PLANILLA EMPLEADOS - MES #" + STRING(FILL-IN-NRO-MES, "99") + "-" + STRING(S-Periodo, "9999").

t-column = t-column + 2.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = 'Orden'.
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = 'Codigo'.
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = 'Apellidos y nombre'.
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = 'Fecha de Ingreso'.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = 'Haberes'.
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'Descuentos'.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = 'Importe Neto'.

/* set the column names for the Worksheet */
x-total  = 0.
FOR EACH tmp-bole NO-LOCK BREAK BY t-codcia BY t-tpoper BY t-nomper:
    IF FIRST-OF( t-tpoper ) THEN DO:
        x-orden   = 0.
        x-impEgr  = 0.
        x-impIng  = 0.
        x-Imptot  = 0.
    END.
    ASSIGN
        x-Neto   = tmp-bole.t-ImpIng - tmp-bole.t-ImpEgr
        x-Imptot = x-Imptot + x-Neto
        x-impEgr = x-impEgr + tmp-bole.t-ImpEgr
        x-impIng = x-impIng + tmp-bole.t-ImpIng
        x-orden  = x-orden + 1.
        x-total  = x-total + 1.
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = x-orden.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-bole.t-CodPer.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-bole.t-NomPer.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-bole.t-FchIng.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-bole.t-ImpIng.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-bole.t-ImpEgr.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = x-Neto.
    ACCUMULATE tmp-bole.t-imping (TOTAL).
    ACCUMULATE tmp-bole.t-impegr (TOTAL).
    ACCUMULATE x-neto            (TOTAL).
        
    IF LAST-OF( t-tpoper ) THEN DO:
        t-column = t-column + 2.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = x-orden.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = " <--- TOTAL PERSONAL  ".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = t-tpoper.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = x-impIng.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = x-impEgr.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = x-ImpTot.
        t-column = t-column + 1.
    END.
    IF LAST-OF (t-codcia) THEN DO:
        t-column = t-column + 2.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = x-total.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = " <---  TOTAL GENERAL".
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL tmp-bole.t-imping.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL tmp-bole.t-impegr.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = x-neto.
        t-column = t-column + 1.
    END.

END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.




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

/*DEFINE VARIABLE x-pagina  AS INTEGER FORMAT "ZZZ9" NO-UNDO.
 * DEFINE VARIABLE x-orden   AS INTEGER NO-UNDO.
 * DEFINE VARIABLE x-total   AS INTEGER NO-UNDO.
 * DEFINE VARIABLE x-Neto    AS DECIMAL NO-UNDO.
 * DEFINE VARIABLE x-Imptot  AS DECIMAL NO-UNDO.
 * DEFINE VARIABLE x-titulo  AS CHARACTER FORMAT "x(28)" NO-UNDO.
 * DEFINE VARIABLE p-archivo AS CHARACTER NO-UNDO.
 * DEFINE VARIABLE x-mes     AS INTEGER.
 * DEFINE VARIABLE x-ano     AS INTEGER.
 * */
CASE PL-CALC.CodCal:
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
END.
END CASE.
x-titulo = " REPORTE DE IMPORTES " .
DEFINE FRAME f-cab
    x-orden  COLUMN-LABEL "Orden" FORMAT "ZZZ9"
    t-CodPer COLUMN-LABEL "C¢digo" FORMAT "x(6)"
    t-NomPer COLUMN-LABEL "Apellidos y nombre" FORMAT "x(50)"
    t-FchIng COLUMN-LABEL "Fecha de Ingreso" FORMAT '99/99/9999'
    t-ImpIng COLUMN-LABEL "Haberes" FORMAT "ZZ,ZZZ,ZZ9.99"
    t-ImpEgr COLUMN-LABEL "Descuentos" FORMAT "ZZ,ZZZ,ZZ9.99"
    x-Neto   COLUMN-LABEL "Importe Neto" FORMAT "ZZ,ZZZ,ZZ9.99"
    HEADER
    PF-CIAS.NomCia FORMAT "x(40)" x-titulo AT 45
    "FECHA :" TO 100 TODAY TO 110 FORMAT '99/99/9999'SKIP
    'CALCULO : ' PL-CALC.descal FORMAT '!(20)'
    TRIM(PL-PLAN.DesPln) FORMAT "X(30)" AT 45     
    "Pagina :" TO 100 x-pagina TO 110 SKIP
     " MES #"  AT 45 FILL-IN-NRO-MES FORMAT "99" "-" S-Periodo FORMAT "9,999" SKIP   
    WITH DOWN NO-BOX STREAM-IO WIDTH 133.

ASSIGN
    x-acu-mon = 0
    x-impIng  = 0
    x-impEgr  = 0.

CASE R-seleccion:
WHEN 1 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Secci¢n".
    FOR EACH PL-FLG-MES WHERE
        PL-FLG-MES.CodCia  = s-CodCia AND
        PL-FLG-MES.Periodo = s-Periodo AND
        PL-FLG-MES.NroMes  = FILL-IN-NRO-MES AND
        PL-FLG-MES.CodPln  = PL-PLAN.CodPln NO-LOCK:
        /*IF PL-FLG-MES.SitAct = "Inactivo" THEN NEXT.*/
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
        /*IF PL-FLG-MES.SitAct = "Inactivo" THEN NEXT.*/
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
        /*IF PL-FLG-MES.SitAct = "Inactivo" THEN NEXT.*/
        RUN busca_datos.
    END.
END.

END CASE.

HIDE FRAME F-Msg.

IF NOT CAN-FIND(FIRST tmp-bole) THEN RETURN.

IF INPUT TGL-pantalla = TRUE OR TGL-Excel = YES THEN DO:
    P-archivo = SESSION:TEMP-DIRECTORY +
          STRING(NEXT-VALUE(sec-arc,integral),"99999999") + ".scr".
    OUTPUT STREAM strm-boleta TO VALUE ( P-archivo ) PAGED PAGE-SIZE 66.
END.
ELSE DO:
    OUTPUT STREAM strm-boleta TO PRINTER PAGED PAGE-SIZE 66.
    /* Seteo de impresi¢n (Impresora EPSON) */
    PUT STREAM strm-boleta CONTROL "~033@~0335~033F~033P~033x~001~033C" CHR(66).
    PUT STREAM strm-boleta CONTROL "~033x" NULL "~017~033P".
END.
x-pagina = 1.
x-total  = 0.
DO WITH FRAME f-cab:
    FOR EACH tmp-bole NO-LOCK BREAK BY t-codcia BY t-tpoper BY t-nomper:
        IF FIRST-OF( t-tpoper ) THEN DO:
            x-orden   = 0.
            x-impEgr  = 0.
            x-impIng  = 0.
            x-Imptot  = 0.
        END.
        ASSIGN
            x-Neto   = tmp-bole.t-ImpIng - tmp-bole.t-ImpEgr
            x-Imptot = x-Imptot + x-Neto
            x-impEgr = x-impEgr + tmp-bole.t-ImpEgr
            x-impIng = x-impIng + tmp-bole.t-ImpIng
            x-orden  = x-orden + 1.
            x-total  = x-total + 1.
        DISPLAY STREAM strm-boleta
            x-orden
            tmp-bole.t-CodPer
            tmp-bole.t-NomPer
            tmp-bole.t-ImpIng
            tmp-bole.t-ImpEgr
            tmp-bole.t-FchIng
            x-Neto
            WITH FRAME f-cab.
        DOWN STREAM strm-boleta 1 WITH FRAME f-cab.
        IF LINE-COUNTER( strm-boleta ) > 62 THEN DO:
            ASSIGN x-pagina = x-pagina + 1.
            PAGE STREAM strm-boleta.
        END.
        ACCUMULATE tmp-bole.t-imping (TOTAL).
        ACCUMULATE tmp-bole.t-impegr (TOTAL).
        ACCUMULATE x-neto            (TOTAL).
        
        IF LAST-OF( t-tpoper ) THEN DO:
            PUT STREAM strm-boleta
                "-----"
                /*FILL(" ",59) FORMAT "x(59)"*/
                FILL(" ",76) FORMAT "x(76)"
                "------------- "
                "------------- "
                "-------------" SKIP.
            IF LINE-COUNTER( strm-boleta ) > 62 THEN DO:
                ASSIGN x-pagina = x-pagina + 1.
                PAGE STREAM strm-boleta.
            END.
    
            PUT STREAM strm-boleta
                x-orden FORMAT "ZZZZ9"
                " <--- TOTAL PERSONAL  "
                /*t-tpoper FORMAT "x(37)"*/
                t-tpoper FORMAT "x(54)"
                x-impIng FORMAT "ZZ,ZZZ,ZZ9.99" " "
                x-impEgr FORMAT "ZZ,ZZZ,ZZ9.99" " "
                x-ImpTot FORMAT "ZZ,ZZZ,ZZ9.99" SKIP.

            PUT STREAM strm-boleta
                "-----" FILL(" ",76) FORMAT "x(76)"
                "------------- "
                "------------- "
                "-------------" SKIP.
            IF LINE-COUNTER( strm-boleta ) > 62 THEN DO:
                ASSIGN x-pagina = x-pagina + 1.
                PAGE STREAM strm-boleta.
            END.
        END.
        IF LAST-OF (t-codcia) THEN DO:

           PUT STREAM strm-boleta
               "-----"
               FILL(" ",76) FORMAT "x(76)"
               "------------- "
               "------------- "
               "-------------" SKIP.

            IF LINE-COUNTER( strm-boleta ) > 62 THEN DO:
                ASSIGN x-pagina = x-pagina + 1.
                PAGE STREAM strm-boleta.
            END.
            PUT STREAM strm-boleta
                x-total FORMAT "ZZZZ9"
               ' <---  TOTAL GENERAL'   
                /*FILL(" ",39) FORMAT "x(39)"*/
                FILL(" ",56) FORMAT "x(56)"
                ACCUM TOTAL tmp-bole.t-imping FORMAT "ZZ,ZZZ,ZZ9.99" " "
                ACCUM TOTAL tmp-bole.t-impegr FORMAT "ZZ,ZZZ,ZZ9.99" " "
                ACCUM TOTAL x-neto FORMAT "ZZ,ZZZ,ZZ9.99" SKIP.
                
             PUT STREAM strm-boleta
                 "-----"
                 FILL(" ",76) FORMAT "x(76)"
                 "------------- "
                 "------------- "
                 "-------------" SKIP.
           
           PAGE STREAM strm-boleta.
        END.
    END.
END.

/*
PUT STREAM strm-boleta "DISTRIBUCION GENERAL DE MONEDAS" SKIP.
PUT STREAM strm-boleta "-------------------------------" SKIP.
PUT STREAM strm-boleta "Monedas de 1 Sol      : " x-acu-mon[1] FORMAT "ZZ,ZZ9" SKIP.
PUT STREAM strm-boleta "Monedas de 5 Soles    : " x-acu-mon[2] FORMAT "ZZ,ZZ9" SKIP.
PUT STREAM strm-boleta "Billetes de 10 Soles  : " x-acu-mon[3] FORMAT "ZZ,ZZ9" SKIP.
PUT STREAM strm-boleta "Billetes de 50 Soles  : " x-acu-mon[4] FORMAT "ZZ,ZZ9" SKIP.
PUT STREAM strm-boleta "Billetes de 100 Soles : " x-acu-mon[5] FORMAT "ZZ,ZZ9" SKIP.
*/

OUTPUT STREAM strm-boleta CLOSE.

IF TGL-Excel = YES THEN RUN Excel.

FOR EACH tmp-bole:
    DELETE tmp-bole.
END.

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

    DISPLAY FILL-IN-NRO-MES WITH FRAME F-Main.

    APPLY "VALUE-CHANGED" TO R-seleccion IN FRAME F-Main.

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

