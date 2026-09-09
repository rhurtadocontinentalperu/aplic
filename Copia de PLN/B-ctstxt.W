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

DEFINE NEW SHARED VARIABLE VAL-VAR AS DECIMAL EXTENT 20.
DEFINE VARIABLE x-valcalI AS DECIMAL NO-UNDO FORMAT ">,>>>,>>9.99".
DEFINE VARIABLE x-valcalE AS DECIMAL NO-UNDO FORMAT ">,>>>,>>9.99".
DEFINE VARIABLE x-valcalA AS DECIMAL NO-UNDO FORMAT ">,>>>,>>9.99".
DEFINE VARIABLE CMB-lista AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-linea   AS CHARACTER FORMAT "x(64)" NO-UNDO.
DEFINE VARIABLE x-mes     AS CHARACTER NO-UNDO.
DEFINE VARIABLE stat-reg  AS LOGICAL NO-UNDO.
DEFINE VARIABLE x-con-reg AS INTEGER NO-UNDO.

DEF BUFFER B-MES FOR pl-mov-mes.

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

DEFINE WORK-TABLE tmp-bole
    FIELD t-nro    AS INTEGER
    FIELD t-codrem AS INTEGER
    FIELD t-refrem AS CHARACTER
    FIELD t-desrem AS CHARACTER
    FIELD t-imprem AS DECIMAL
    FIELD t-coddes AS INTEGER
    FIELD t-desdes AS CHARACTER
    FIELD t-impdes AS DECIMAL
    FIELD t-codApo AS INTEGER
    FIELD t-desApo AS CHARACTER
    FIELD t-impApo AS DECIMAL.

DEFINE TEMP-TABLE Tempo LIKE PL-MOV-MES
    FIELD Moneda-Cts LIKE Pl-Cts.Moneda
    FIELD Ult6Sueldos AS DEC.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
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
&Scoped-define QUERY-STRING-br_pl-flg-m FOR EACH integral.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES ~
 NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-MES NO-LOCK ~
    BY integral.PL-FLG-MES.codper
&Scoped-define OPEN-QUERY-br_pl-flg-m OPEN QUERY br_pl-flg-m FOR EACH integral.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES ~
 NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-MES NO-LOCK ~
    BY integral.PL-FLG-MES.codper.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES ~
integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES
&Scoped-define SECOND-TABLE-IN-QUERY-br_pl-flg-m integral.PL-PERS


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_pl-flg-m}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn-UP RECT-2 FILL-IN-NRO-MES br_pl-flg-m ~
Btn-DOWN R-seleccion COMBO-S COMBO-canal B-aceptar FILL-IN-msg F-tc 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Copias FILL-IN-NRO-MES R-seleccion ~
COMBO-S COMBO-canal TGL-pantalla FILL-IN-msg F-tc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.5.

DEFINE BUTTON Btn-DOWN 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE VARIABLE COMBO-canal AS CHARACTER FORMAT "X(256)":U INITIAL "BANCO DE CREDITO" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "BANCO DE CREDITO","BIF" 
     DROP-DOWN-LIST
     SIZE 20 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE COMBO-S AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20.43 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE F-tc AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "T/C" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-Copias AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Copias" 
     VIEW-AS FILL-IN 
     SIZE 3.29 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-msg AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mensaje" 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .81
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
     SIZE 14.14 BY 2.08 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.72 BY 10.23.

DEFINE VARIABLE TGL-pantalla AS LOGICAL INITIAL no 
     LABEL "Salida a Pantalla" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.57 BY .5 NO-UNDO.

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
      integral.PL-FLG-MES.codper FORMAT "X(6)":U COLUMN-FONT 4 LABEL-FONT 4
      integral.PL-PERS.patper FORMAT "X(40)":U COLUMN-FONT 4 LABEL-FONT 4
      integral.PL-PERS.matper FORMAT "X(40)":U COLUMN-FONT 4 LABEL-FONT 4
      integral.PL-PERS.nomper FORMAT "X(40)":U COLUMN-FONT 4 LABEL-FONT 4
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47.14 BY 7.92
         BGCOLOR 15 FGCOLOR 0 FONT 6.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn-UP AT ROW 1.08 COL 9.29
     FILL-IN-Copias AT ROW 1.23 COL 16.57 COLON-ALIGNED
     FILL-IN-NRO-MES AT ROW 1.27 COL 3.86 COLON-ALIGNED
     br_pl-flg-m AT ROW 1.31 COL 22.43
     Btn-DOWN AT ROW 1.69 COL 9.29
     R-seleccion AT ROW 2.38 COL 5.57 NO-LABEL
     COMBO-S AT ROW 4.54 COL 1.57 NO-LABEL
     COMBO-canal AT ROW 5.35 COL 1.86 NO-LABEL WIDGET-ID 2
     TGL-pantalla AT ROW 6.31 COL 4.86
     B-aceptar AT ROW 6.88 COL 6.43
     FILL-IN-msg AT ROW 9.46 COL 27 COLON-ALIGNED
     F-tc AT ROW 10.23 COL 5 COLON-ALIGNED
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.72 BY 10.42
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
         HEIGHT             = 10.42
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
   FRAME-NAME                                                           */
/* BROWSE-TAB br_pl-flg-m FILL-IN-NRO-MES F-Main */
ASSIGN 
       br_pl-flg-m:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 1.

/* SETTINGS FOR COMBO-BOX COMBO-canal IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX COMBO-S IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-Copias IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-Copias:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX TGL-pantalla IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       TGL-pantalla:HIDDEN IN FRAME F-Main           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-m
/* Query rebuild information for BROWSE br_pl-flg-m
     _TblList          = "integral.PL-FLG-MES,integral.PL-PERS OF integral.PL-FLG-MES"
     _Options          = "NO-LOCK"
     _OrdList          = "integral.PL-FLG-MES.codper|yes"
     _Where[1]         = "PL-FLG-MES.CodCia = s-CodCia
 AND PL-FLG-MES.Periodo = s-Periodo
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES
"
     _FldNameList[1]   > integral.PL-FLG-MES.codper
"PL-FLG-MES.codper" ? ? "character" ? ? 4 ? ? 4 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.PL-PERS.patper
"PL-PERS.patper" ? ? "character" ? ? 4 ? ? 4 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.PL-PERS.matper
"PL-PERS.matper" ? ? "character" ? ? 4 ? ? 4 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.PL-PERS.nomper
"PL-PERS.nomper" ? ? "character" ? ? 4 ? ? 4 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br_pl-flg-m */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar B-table-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN F-tc FILL-IN-NRO-MES R-seleccion COMBO-S FILL-IN-Copias FILL-IN-msg COMBO-canal.
    IF FILL-IN-Copias = 0 THEN FILL-IN-Copias = 1.
    IF f-Tc <= 0 THEN DO:
        MESSAGE 'Ingrese en tipo de cambio' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
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
DEF VAR k AS INT NO-UNDO.
DEF VAR i-Month AS INT NO-UNDO.
DEF VAR i-Year AS INT NO-UNDO.

IF PL-FLG-MES.SitAct = "Inactivo" THEN RETURN. /* Si no esta Activo */

IF NOT CAN-FIND(FIRST PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia        AND
    PL-MOV-MES.Periodo = s-Periodo       AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln  AND
    PL-MOV-MES.CodCal  = PL-CALC.CodCal  AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer) THEN RETURN. /* Si no tiene c lculo */

DISPLAY PL-FLG-MES.CodPer @ FILL-IN-Codigo WITH FRAME F-Msg.


/* Cargamos el temporal con los ingresos */

FOR EACH PL-MOV-MES WHERE
        PL-MOV-MES.CodCia  = s-CodCia AND
        PL-MOV-MES.Periodo = s-Periodo AND
        PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
        PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
        PL-MOV-MES.CodCal  = PL-CALC.CodCal AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        PL-MOV-MES.CodMov  = 403  NO-LOCK :
    IF PL-MOV-MES.ValCal-Mes <> 0 AND
        TRIM(PL-FLG-Mes.cts) BEGINS COMBO-canal AND  /*RDP - Banco*/
        PL-FLG-Mes.Nrodpt-cts <> ""  THEN DO:
        CREATE Tempo.
        BUFFER-COPY PL-MOV-MES TO Tempo
            ASSIGN Tempo.Moneda-Cts = 1.
        FIND PL-CTS OF PL-FLG-MES NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CTS THEN Tempo.Moneda-Cts = PL-CTS.Moneda-Cts.
        /* Ultimas 6 remuneraciones */
        ASSIGN
            i-Month = PL-FLG-MES.NroMes
            i-Year  = PL-FLG-MES.Periodo.
        DO k = 1 TO 6:
            FIND B-MES WHERE B-MES.codcia = s-codcia
                AND B-MES.nromes = i-Month
                AND B-MES.periodo = i-Year
                AND B-MES.CodPln  = PL-PLAN.CodPln 
                AND B-MES.codcal = 001      /* Sueldos */
                AND B-MES.codmov = 401      /* Total Ingresos */
                AND B-MES.codper = PL-FLG-MES.codper
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-MES THEN LEAVE.
            IF AVAILABLE B-MES THEN Tempo.Ult6Sueldos = Tempo.Ult6Sueldos + B-MES.valcal-mes.
            FOR EACH B-MES NO-LOCK WHERE B-MES.codcia = s-codcia
                AND B-MES.nromes = i-Month
                AND B-MES.periodo = i-Year
                AND B-MES.CodPln  = PL-PLAN.CodPln 
                AND B-MES.codcal = 001      /* Sueldos */
                AND B-MES.codper = PL-FLG-MES.codper
                AND (B-MES.codmov = 508 OR B-MES.codmov = 509 OR B-MES.codmov = 510):   /* Descuentos */
                Tempo.Ult6Sueldos = Tempo.Ult6Sueldos - B-MES.valcal-mes.
            END.
            i-Month = i-Month - 1.
            IF i-Month <= 0 
                THEN ASSIGN
                        i-Month = 12
                        i-Year = i-Year - 1.
        END.
    END.
END.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_boleta B-table-Win 
PROCEDURE imp_boleta :
/*------------------------------------------------------------------------------
    Impresi¢n de boleta de pago.
------------------------------------------------------------------------------*/
/*MLR* 17/12/07 ***
MESSAGE "El Archivo de texto a generar se salvara en el directorio " SKIP
        "C:\temp\cts.txt , verifique al culminar dicha informacion" 
        VIEW-AS ALERT-BOX INFORMATION.
* ***/

DEFINE VARIABLE cFile-Name AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAux-File1 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAux-File2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

SYSTEM-DIALOG GET-FILE
    cFile-Name
    TITLE      "Archivos..." 
    FILTERS    "Texto (*.txt)"   "*.txt",
               "Todos (*.*)"     "*.*"
    USE-FILENAME
    UPDATE OKpressed.

IF NOT OKpressed THEN RETURN.

FOR EACH Tempo:
    DELETE Tempo.
END.

DEFINE VAR I AS INTEGER.

CASE R-seleccion:
WHEN 1 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Secci¢n".
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        DISPLAY PL-FLG-MES.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
        RUN busca_datos.
        GET NEXT br_pl-flg-m.
    END.
END.
WHEN 2 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Secci¢n".
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
    ASSIGN FILL-IN-Seccion:LABEL = "Secci¢n".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        IF PL-FLG-MES.Seccion = COMBO-S THEN RUN busca_datos.
        GET NEXT br_pl-flg-m.
    END.
END.
WHEN 4 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Proyecto".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        IF PL-FLG-MES.Proyecto = COMBO-S THEN RUN busca_datos.
        GET NEXT br_pl-flg-m.
    END.
END.

END CASE.

/* dos archivos, uno en soles y el otro en dolares */
IF INDEX(cFile-Name,".") > 0 THEN DO:
    cAux-File1 = ENTRY(1,cFile-Name,".") + "_" + COMBO-canal + "_Soles.txt".
    cAux-File2 = ENTRY(1,cFile-Name,".") + "_" + COMBO-canal + "_Dolares.txt".
END.
ELSE DO:
    cAux-File1 = cFile-Name + "_" + COMBO-canal + "_Soles.txt".
    cAux-File2 = cFile-Name + "_" + COMBO-canal + "_Dolares.txt".
END.

/*MLR* 17/12/07 ***
RUN procesa (1, "c:\temp\cts-soles.txt").
RUN procesa (2, "c:\temp\cts-dolares.txt").
* ***/

/****Formato Banco****/
CASE COMBO-canal:
    WHEN "BIF" THEN DO:
        RUN procesa_bif (1, cAux-File1).
        RUN procesa_bif (2, cAux-File2).
    END.        
    WHEN "BANCO DE CREDITO" THEN DO:
        RUN procesa (1, cAux-File1).
        RUN procesa (2, cAux-File2).
    END.       
END CASE.





HIDE FRAME F-Msg.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa B-table-Win 
PROCEDURE Procesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodMon AS INT.
DEF INPUT PARAMETER pDocSal AS CHAR.

define var y as integer init 0.
define var x-tot as deci init 0.
define var x-tipo as deci init 0.
define var x-factor as deci init 0.
define var i as integer .
define var x-des as char.

define var x-in as integer.
define var x-de as integer.
define var x-nom as char format "x(40)".
define var x as char format "x(1000)".
define var x-cta as char format "x(14)".
define var x-dir as char format "x(40)".

x-factor = 0.0833.
x-factor = 1.
x-tipo   = F-tc .
IF pCodMon = 1 
THEN x-tipo = 1.
ELSE x-tipo = f-Tc.

/*output to "c:\temp\cts.txt".*/
output to VALUE(pDocSal).

x-dir = "RENE DESCARTES MZ C LT 1 URB. STA RAQUEL 2DA ETAPA ATE".
x-nom = "CONTINENTAL S.A.".

y = 0 .
x-tot = 0.
for each tempo where tempo.moneda-cts = pCodMon:
    find pl-pers where pl-pers.codper = tempo.codper no-lock no-error.
    find pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  and
                          pl-flg-mes.periodo = tempo.periodo and
                          pl-flg-mes.nromes  = tempo.nromes  and
                          pl-flg-mes.codper  = tempo.codper  no-lock no-error.
    if available pl-flg-mes and nrodpt-Cts <> "" then do: 
        x-in = 0.
        x-in = ROUND((tempo.valcal-mes * x-factor ) / x-tipo , 2) * 100.
        x-tot = x-tot + x-in.
        y  = y + 1.
    end.
end.

/*x-tot = x-tot * 100.*/
x = "".
  x  =    "2" +
          "              " + 
          (IF pCodMon = 1 THEN "MN" ELSE "ME") +
          "      " +
          "20100038146" +
          "00000000000" +
          "      " +
          string(x-tot,"999999999999999") +
          string(y,"99999")  + 
          "          " +
          "R" +
          "1" +
          " " +
          string(x-nom,"x(40)") + 
          string(x-dir,"x(40)") + 
          "                  " +          
          "      " +
          "           " +                        
          "@" .
  /*DISPLAY x  WITH no-labels WIDTH 320.*/
PUT UNFORMATTED X SKIP.


for each tempo where tempo.moneda-cts = pCodMon:
    find pl-pers where pl-pers.codper = tempo.codper no-lock no-error.
    find pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  and
                          pl-flg-mes.periodo = tempo.periodo and
                          pl-flg-mes.nromes  = tempo.nromes  and
                          pl-flg-mes.codper  = tempo.codper  no-lock no-error.
    if available pl-flg-mes and nrodpt-Cts <> "" then do: 
      x-in = 0.
      x-in = ROUND((tempo.valcal-mes * x-factor ) / x-tipo, 2) * 100.  
      x-des = "".
      do I = 1 to length(left-trim(PL-PERS.nomper)):
         if substr(left-trim(PL-PERS.nomper),i,1) = " " then do:
            x-des = substr(left-trim(PL-PERS.nomper),1,i - 1).
            leave.
         end.
      end.
      if x-des = "" then  x-des = trim(PL-PERS.nomper).
    
      x-nom =   trim(PL-PERS.patper) + " " + trim(PL-PERS.matper) + " " + x-des .  
      x-cta = substring(trim(PL-FLG-MES.nrodpt-cts),1,3) + 
                substring(trim(PL-FLG-MES.nrodpt-cts),5,8) +
                substring(trim(PL-FLG-MES.nrodpt-cts),14,1) +
                substring(trim(PL-FLG-MES.nrodpt-cts),16).
      
      x  =    "3" +
              "              " + 
              (IF pCodMon = 1 THEN "MN" ELSE "ME") +
              "      " +
              "20100038146" +
              STRING(x-cta,"x(14)") +
              "   " +
              string(x-in,"999999999999999") +
              "00000" + 
              "          " +
              "R" +
              "1" +
              " " +
              string(x-nom,"x(40)") + 
              string(x-dir,"x(40)") + 
              string(YEAR(PL-PERS.fecnac)) + string(MONTH(PL-PERS.fecnac),"99") + string(DAY(PL-PERS.fecnac),"99") +          
              string(PL-PERS.NroDocId,"x(9)") +
              "1" +                        
              "      " + 
              "            " +
              "MN" +
              STRING(Tempo.Ult6Sueldos * 100 , "999999999999999").
      /*DISPLAY x  WITH no-labels WIDTH 320.*/
        PUT UNFORMATTED X SKIP.
    END.  
END.  

output close.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa_bif B-table-Win 
PROCEDURE procesa_bif :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMon AS INT.
DEF INPUT PARAMETER pDocSal AS CHAR.
  
DEFINE VARIABLE iCount AS INTEGER FORMAT "9999999" NO-UNDO.
DEFINE VARIABLE cTpoDoc AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cTpoPln AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cCodBco AS CHARACTER FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE iTpoMon AS INTEGER FORMAT "9" NO-UNDO.
DEFINE VARIABLE cMonto AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE cNroCta AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE iMotivo AS INTEGER FORMAT "9" NO-UNDO.

DEFINE VAR x-tipo       AS DECI INIT 0.
DEFINE VAR x-factor     AS DECI INIT 0.

/* iMotivo
    0=Para Pago CTS.
    4=Pagos de Haberes de Cuarta Categoría
    5=Pagos de Haberes de Quinta Categoría
    8=Otros Haberes Gravados
    9=Otros Haberes Exonerados
*/

CASE PL-CALC.CodCal:
    WHEN 6 THEN DO:
        cTpoPln = "C".
        iMotivo = 0.
    END.
    OTHERWISE DO:
        cTpoPln = "H".
        iMotivo = 5.
    END.
END CASE.

cCodBco = "038".    /* Código BIF */
iTpoMon = 1.      /* 1=Soles, 2=Dólares */

x-factor = 0.0833.
x-factor = 1.
x-tipo   = F-tc .
IF pCodMon = 1 THEN x-tipo = 1.
ELSE x-tipo = f-Tc.

OUTPUT TO VALUE(pDocSal).
FOR EACH tempo WHERE tempo.moneda-cts = pCodMon NO-LOCK:
    FIND pl-pers WHERE pl-pers.codper = tempo.codper NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN NEXT.
    FIND FIRST pl-flg-mes WHERE pl-flg-mes.codcia = tempo.codcia
        AND pl-flg-mes.periodo = tempo.periodo
        AND pl-flg-mes.codpln = tempo.codpln
        AND pl-flg-mes.nromes = tempo.nromes
        AND pl-flg-mes.codper = tempo.codper NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-flg-mes THEN NEXT.
    IF pl-flg-mes.nrodpt-cts = "" THEN NEXT.

    iCount = iCount + 1.
    CASE pl-pers.TpoDocId:
        WHEN "01" THEN cTpodoc = "1".
        WHEN "04" THEN cTpodoc = "3".
        OTHERWISE cTpodoc = "1".
    END CASE.
    cMonto = STRING(ROUND((tempo.valcal-mes * x-factor ) / x-tipo, 2) * 100,"99999999999999").  
    cNroCta = FILL(" ", 20 - LENGTH(pl-flg-mes.nrodpt-cts)) + pl-flg-mes.nrodpt-cts.

    PUT
        iCount
        cTpodoc
        pl-pers.NroDocId FORMAT "x(11)"
        CAPS(pl-pers.patper) FORMAT "x(20)"
        CAPS(pl-pers.matper) FORMAT "x(20)"
        CAPS(pl-pers.nomper) FORMAT "x(44)"
        FILL(" ",60) FORMAT "x(60)"
        FILL(" ",10) FORMAT "x(10)"
        cTpoPln
        cCodBco
        cNroCta
        iTpoMon
        cMonto
        iMotivo
        SKIP.

END.  

 OUTPUT CLOSE. 

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

