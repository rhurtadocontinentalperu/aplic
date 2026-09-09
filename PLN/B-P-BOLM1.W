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
    BY integral.PL-FLG-MES.Proyecto ~
       BY integral.PL-FLG-MES.seccion ~
        BY integral.PL-PERS.patper ~
         BY integral.PL-PERS.matper ~
          BY integral.PL-PERS.nomper
&Scoped-define OPEN-QUERY-br_pl-flg-m OPEN QUERY br_pl-flg-m FOR EACH integral.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES ~
 NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-MES NO-LOCK ~
    BY integral.PL-FLG-MES.Proyecto ~
       BY integral.PL-FLG-MES.seccion ~
        BY integral.PL-PERS.patper ~
         BY integral.PL-PERS.matper ~
          BY integral.PL-PERS.nomper.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES ~
integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES
&Scoped-define SECOND-TABLE-IN-QUERY-br_pl-flg-m integral.PL-PERS


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_pl-flg-m}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn-UP RECT-2 FILL-IN-Copias FILL-IN-NRO-MES ~
br_pl-flg-m Btn-DOWN R-seleccion COMBO-S TGL-pantalla B-aceptar FILL-IN-msg ~
TGL-CTS 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Copias FILL-IN-NRO-MES R-seleccion ~
COMBO-S TGL-pantalla FILL-IN-msg TGL-CTS 

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
     DROP-DOWN-LIST
     SIZE 20.43 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

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
"Por secci¢n", 3,
"Por proyecto", 4
     SIZE 14.14 BY 2.08 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.72 BY 9.5.

DEFINE VARIABLE TGL-CTS AS LOGICAL INITIAL no 
     LABEL "Solo Constancia CTS" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.14 BY .77 NO-UNDO.

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
     TGL-pantalla AT ROW 5.54 COL 4.86
     B-aceptar AT ROW 6.15 COL 6.57
     FILL-IN-msg AT ROW 9.46 COL 27 COLON-ALIGNED
     TGL-CTS AT ROW 9.5 COL 3.72
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.72 BY 9.5
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
         HEIGHT             = 9.5
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

/* SETTINGS FOR COMBO-BOX COMBO-S IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-m
/* Query rebuild information for BROWSE br_pl-flg-m
     _TblList          = "integral.PL-FLG-MES,integral.PL-PERS OF integral.PL-FLG-MES"
     _Options          = "NO-LOCK"
     _OrdList          = "integral.PL-FLG-MES.Proyecto|yes,integral.PL-FLG-MES.seccion|yes,integral.PL-PERS.patper|yes,integral.PL-PERS.matper|yes,integral.PL-PERS.nomper|yes"
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
    ASSIGN FILL-IN-NRO-MES R-seleccion COMBO-S FILL-IN-Copias FILL-IN-msg.
    IF FILL-IN-Copias = 0 THEN FILL-IN-Copias = 1.
    /*RUN imp_boleta.*/

    /******MAGM******07/06/2001**********/
    IF INPUT TGL-CTS = TRUE /*AND PL-CALC.CodCal = 001*/ THEN DO:
       RUN imp_cts .
    END.
    ELSE RUN imp_boleta.
    /************************************/
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
DEFINE VARIABLE saldo     AS DECIMAL.
DEFINE VARIABLE F-ValCal  AS DECIMAL.
DEFINE VARIABLE linea-msg AS CHARACTER EXTENT 3.
DEFINE VARIABLE j         AS INTEGER.
DEFINE VARIABLE ii        AS INTEGER.
DEFINE VARIABLE x-dirdiv  AS CHAR.
DEFINE VARIABLE x-desdiv  AS CHAR.
DEFINE VARIABLE x-dirper  AS CHAR.
DEFINE VARIABLE x-LEper   AS CHAR.
DEFINE VARIABLE X-RUC     AS CHAR INIT "20100038146" format "X(11)".
FOR EACH tmp-bole:
    DELETE tmp-bole.
END.

IF PL-FLG-MES.SitAct = "Inactivo" THEN RETURN. /* Si no esta Activo */

IF NOT CAN-FIND(FIRST PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia        AND
    PL-MOV-MES.Periodo = s-Periodo       AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln  AND
    PL-MOV-MES.CodCal  = PL-CALC.CodCal  AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer) THEN RETURN. /* Si no tiene c lculo */

DISPLAY PL-FLG-MES.CodPer @ FILL-IN-Codigo WITH FRAME F-Msg.

x-con-reg = 0.
x-valcalI = 0.
x-valcalE = 0.
x-valcalA = 0.

/* Cargamos el temporal con los ingresos */
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
        CREATE tmp-bole.
        x-con-reg = x-con-reg + 1.
        t-nro = x-con-reg.
        t-codrem = PL-MOV-MES.CodMov.
        t-imprem = PL-MOV-MES.ValCal-Mes.
        FIND PL-CONC WHERE PL-CONC.CodMov = PL-MOV-MES.CodMov NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN t-desrem = PL-CONC.DesMov.
        /* Para buscar referencia */
        IF PL-BOLE.CodRef <> 0 THEN DO:
            FIND b-PL-MOV-MES WHERE
                b-PL-MOV-MES.CodCia  = s-CodCia AND
                b-PL-MOV-MES.Periodo = s-Periodo AND
                b-PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
                b-PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
                b-PL-MOV-MES.CodCal  = PL-BOLE.CodCal-Ref AND
                b-PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
                b-PL-MOV-MES.CodMov  = PL-BOLE.CodRef NO-LOCK NO-ERROR.
            IF AVAILABLE b-PL-MOV-MES THEN
                t-refrem = STRING(b-PL-MOV-MES.ValCal-Mes,"Z99.99").
        END.
        x-valcalI = x-valcalI + PL-MOV-MES.ValCal-Mes.
    END.
END.

x-con-reg = 0.
/* Cargamos el temporal con los Descuentos */
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
        x-con-reg = x-con-reg + 1.
        FIND FIRST tmp-bole WHERE t-nro = x-con-reg NO-ERROR.
        IF NOT AVAILABLE tmp-bole THEN DO:
            CREATE tmp-bole.
            t-nro = x-con-reg.
        END.
        t-coddes = PL-MOV-MES.CodMov.
        t-impdes = PL-MOV-MES.ValCal-Mes.
        FIND PL-CONC WHERE PL-CONC.CodMov = PL-MOV-MES.CodMov NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN t-desdes = PL-CONC.DesMov.
        x-valcalE = x-valcalE + PL-MOV-MES.ValCal-Mes.
    END.
END.

x-con-reg = 0.
/* Cargamos el temporal con los Aportes */
FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.CodPln = PL-PLAN.CodPln AND
    PL-BOLE.CodCal = PL-CALC.CodCal AND
    PL-BOLE.TpoBol = "Aportes" BY PL-BOLE.nroitm:
    FIND PL-MOV-MES WHERE
        PL-MOV-MES.CodCia  = s-CodCia AND
        PL-MOV-MES.Periodo = s-Periodo AND
        PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
        PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
        PL-MOV-MES.CodCal  = PL-BOLE.CodCal AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        PL-MOV-MES.CodMov  = PL-BOLE.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-MES AND PL-MOV-MES.ValCal-Mes <> 0 THEN DO:
        x-con-reg = x-con-reg + 1.
        FIND FIRST tmp-bole WHERE t-nro = x-con-reg NO-ERROR.
        IF NOT AVAILABLE tmp-bole THEN DO:
            CREATE tmp-bole.
            t-nro = x-con-reg.
        END.
        t-codApo = PL-MOV-MES.CodMov.
        t-impApo = PL-MOV-MES.ValCal-Mes.
        FIND PL-CONC WHERE PL-CONC.CodMov = PL-MOV-MES.CodMov NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN t-desApo = PL-CONC.DesMov.
        x-valcalA = x-valcalA + PL-MOV-MES.ValCal-Mes.
    END.
END.

RUN PLN/P-CALC-M.R(
   PL-FLG-MES.Codcia,
   PL-FLG-MES.Periodo,
   PL-FLG-MES.NroMes,
   PL-FLG-MES.codpln,
   1,
   PL-FLG-MES.codper,
   "^101(0);^102(0);^104(0);^105(0);^107(0);^140(0);^141(0);^100(1);^219(0);^501(0);
   ^502(0);^504(0);^301(1);^303(1);^010(0);^011(1);^503(0)" ).

FOR EACH PL-CFG-CTE-MES WHERE
    PL-CFG-CTE-MES.CodCia = PL-FLG-MES.Codcia AND
    PL-CFG-CTE-MES.Periodo = PL-FLG-MES.Periodo AND
    PL-CFG-CTE-MES.NroMes = PL-FLG-MES.NroMes AND
    PL-CFG-CTE-MES.CodPer = PL-FLG-MES.codper AND
    PL-CFG-CTE-MES.Sdo-Cte-Mes > 0 NO-LOCK:
    saldo = saldo + PL-CFG-CTE-MES.Sdo-Cte-Mes.
END.

FIND GN-DIVI WHERE GN-DIVI.CodCia = s-codcia AND
     GN-DIVI.CodDiv =  PL-FLG-MES.CodDiv NO-LOCK NO-ERROR.
IF AVAILABLE GN-DIVI THEN
   ASSIGN x-desdiv = GN-DIVI.DesDiv
          x-dirdiv = GN-DIVI.DirDiv.
x-linea = TRIM(PL-FLG-MES.CodDiv) + " " + TRIM(x-desdiv).
FIND gn-cias WHERE gn-cias.codcia  = s-codcia NO-LOCK NO-ERROR.
DO ii = 1 TO FILL-IN-Copias:
    FIND GN-DIVI WHERE GN-DIVI.CodCia = s-codcia AND
         GN-DIVI.CodDiv =  PL-FLG-MES.CodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE GN-DIVI THEN
       ASSIGN x-desdiv = GN-DIVI.DesDiv
              x-dirdiv = TRIM(GN-DIVI.DirDiv).
    x-linea = TRIM(PL-FLG-MES.CodDiv) + " " + TRIM(x-desdiv).
    PUT STREAM strm-boleta SKIP(1).
    PUT STREAM strm-boleta CONTROL CHR(18) CHR(27) CHR(69).
    PUT STREAM strm-boleta S-NomCia SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70) CHR(27) CHR(77).
/*    PUT STREAM strm-boleta "R.U.C. : " S-RucCia   "DIVISION :" AT 70 */
    PUT STREAM strm-boleta "R.U.C. : " X-Ruc   "DIVISION :" AT 60 
                           " " x-linea FORMAT "X(30)" SKIP.
    PUT STREAM strm-boleta "R.PATRONAL : " ( X-RUC + "0000000") FORMAT "X(18)"
                           /*x-dirdiv AT 70 FORMAT "X(30)"*/ SKIP.
    PUT STREAM strm-boleta S-DirCia  ' Telefono : ' GN-CIAS.TlflCia  SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(80) CHR(27) CHR(69).
    CASE PL-CALC.CodCal:
       WHEN 003 THEN x-linea = "BOLETA DE VACACIONES EMPLEADOS MES DE " + x-mes.
       WHEN 004 THEN x-linea = "BOLETA DE GRATIFICACION EMPLEADOS MES DE " + x-mes.
       OTHERWISE x-linea = "BOLETA DE PAGO EMPLEADOS MES DE " + x-mes.
    END CASE.
    PUT STREAM strm-boleta x-linea AT 20 SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70) CHR(15).
    x-linea = FILL("-",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    IF AVAILABLE PL-PERS THEN DO:
        x-linea = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
        x-dirper = TRIM(PL-PERS.dirper) + " " + TRIM(PL-PERS.distri).
        x-LEper  = PL-PERS.NroDocId.
        END.
    ELSE x-linea = "".
    F-ValCal = val-var[1].  
    IF val-var[15] = 1 THEN 
       F-Valcal = val-var[1] * val-var[16].
    PUT STREAM strm-boleta "Codigo    : " PL-FLG-MES.codper " " x-linea FORMAT "X(40)"
                           "Basico  : " AT 73 "S/. " F-ValCal
                           "Dias Laborados : " AT 105 val-var[8] FORMAT "Z9.99" SKIP.
    FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND
         cb-auxi.Clfaux = "CCO" AND
         cb-auxi.Codaux = PL-FLG-MES.ccosto NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi THEN
       FIND cb-auxi WHERE cb-auxi.CodCia = S-CODCIA AND
            cb-auxi.Clfaux = "CCO" AND
            cb-auxi.Codaux = PL-FLG-MES.ccosto NO-LOCK NO-ERROR.
    IF AVAILABLE cb-auxi THEN x-linea = cb-auxi.Nomaux.
    ELSE x-linea = PL-FLG-MES.ccosto.
    PUT STREAM strm-boleta "C.Costo   : " x-linea FORMAT "X(15)"  
                           "Ocupacion    : " AT 38 PL-FLG-MES.cargos FORMAT "x(15)".
    FIND PL-AFPS OF PL-FLG-MES NO-LOCK NO-ERROR.
    IF AVAILABLE PL-AFPS THEN  x-linea = PL-AFPS.desafp.
    ELSE x-linea = "".
    PUT STREAM strm-boleta "IPSS    : " AT 73 PL-PERS.ctipss
                           "AFP            : " AT 105 x-linea FORMAT "X(15)"  SKIP.
    PUT STREAM strm-boleta "F.Ingreso : " PL-FLG-MES.fecing
                           "F.Vac. : " AT 38 PL-FLG-MES.inivac " Al " PL-FLG-MES.finvac
                           "F.Cese  : " AT 73 PL-FLG-MES.vcontr
                           "CUSPP AFP      : " AT 105 PL-FLG-MES.nroafp SKIP.
    
    PUT STREAM strm-boleta "Domicilio : " x-dirper FORMAT "X(40)" 
                           "Sección : " AT 73 PL-FLG-MES.seccion  SKIP.
    PUT STREAM strm-boleta "L.E./DNI  : " x-LEper  FORMAT "X(40)" /*SKIP*/.
    PUT STREAM strm-boleta "Horas lab.: " AT 73 (val-var[8] * 8) FORMAT ">>9.99" SKIP.
    x-linea = FILL("-",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(69).
    PUT STREAM strm-boleta "REMUNERACION" "DESCUENTOS" AT 46 "APORTACIONES DEL EMPLEADOR" AT 91 SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70).
    
    x-con-reg = 0.
    
    FOR EACH tmp-bole NO-LOCK BREAK BY t-nro:
        x-con-reg = x-con-reg + 1.
        IF t-codrem > 0 THEN
           linea-msg[1] = STRING(t-codrem,"999") + " " + STRING(t-desrem,"x(21)") +
                          STRING(t-refrem,"x(5)") + " " + STRING(t-imprem,">,>>>,>>9.99").
        ELSE linea-msg[1] = FILL(" ",45).
        IF t-coddes > 0 THEN
           linea-msg[2] = STRING(t-coddes,"999") + " " + STRING(t-desdes,"x(26)") + 
                          " " + STRING(t-impdes,">,>>>,>>9.99").
        ElSE linea-msg[2] = FILL(" ",45).
        IF t-codApo > 0 THEN
           linea-msg[3] = STRING(t-codApo,"999") + " " + STRING(t-desApo,"x(26)") + 
                          " " + STRING(t-impApo,">,>>>,>>9.99").
        ElSE linea-msg[3] = FILL(" ",45).
        PUT STREAM strm-boleta linea-msg[1] FORMAT "X(43)" 
                               linea-msg[2] AT 46 FORMAT "X(43)"
                               linea-msg[3] AT 91 FORMAT "X(43)"SKIP.
    END.
    x-linea = FILL("-",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    PUT STREAM strm-boleta "Total Remuneracion :           "        x-valcalI
                           "Total Descuentos   :           " AT 46  x-valcalE
                           "Total Aportaciones :           " AT 91 x-valcalA SKIP.
    x-linea = FILL("=",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    x-linea = STRING(x-valcalI - x-valcalE,">,>>>,>>9.99") .
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(69).
    IF PL-FLG-MES.cnpago <> "EFECTIVO" THEN DO:
       x-linea = x-linea + "                  CON ABONO EN LA CUENTA DE AHORROS No " + SUBSTRING(PL-FLG-MES.nrodpt,1,20) + " DEL " + PL-FLG-MES.cnpago.
       PUT STREAM strm-boleta "NETO A PAGAR :   S/. " x-linea FORMAT 'X(110)' .
       END.
    ELSE
       PUT STREAM strm-boleta "NETO A PAGAR :   S/. " x-linea SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70).
    
    linea-msg[1] = PL-FLG-MES.Clase.
    linea-msg[2] = FILL-IN-msg.
    linea-msg[3] = "". 
    IF val-var[9] > 0 THEN linea-msg[3] = "Tardanza " + STRING(val-var[9] / 0.5, "99").
    IF val-var[10] > 0 THEN DO:
        IF linea-msg[3] <> "" THEN linea-msg[3] = linea-msg[3] + ", ".
        linea-msg[3] = linea-msg[3] + "Falta Justificada " + STRING(val-var[10], "99").
    END.
    IF val-var[11] > 0 THEN DO:
        IF linea-msg[3] <> "" THEN linea-msg[3] = linea-msg[3] + ", ".
        linea-msg[3] = linea-msg[3] + "Falta Injustificada " + STRING(val-var[11], "99").
    END.
    IF val-var[12] > 0 THEN DO:
        IF linea-msg[3] <> "" THEN linea-msg[3] = linea-msg[3] + ", ".
        linea-msg[3] = linea-msg[3] + "Suspenci¢n " + STRING(val-var[12], "99").
    END.
    IF val-var[17] > 0 THEN DO:
        IF linea-msg[3] <> "" THEN linea-msg[3] = linea-msg[3] + ", ".
        linea-msg[3] = linea-msg[3] + "Lic.Sin Goce de Haber " + STRING(val-var[17], "99").
    END.

    /* Ordenamos los mensajes */
    IF linea-msg[3] = "" THEN DO:
        IF linea-msg[2] = "" THEN DO:
            linea-msg[2] = linea-msg[1].
            linea-msg[1] = "".
        END.
        linea-msg[3] = linea-msg[2].
        linea-msg[2] = linea-msg[1].
        linea-msg[1] = "".
    END.
    ELSE DO:
        IF linea-msg[2] = "" THEN DO:
            linea-msg[2] = linea-msg[1].
            linea-msg[1] = "".
        END.
    END.
    
    DO j = 1 TO 3:
        x-linea = linea-msg[j].
        PUT STREAM strm-boleta x-linea SKIP.
    END.
    
    IF AVAILABLE PL-PERS THEN
        x-linea = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
    ELSE x-linea = "".
    
    
    IF (PAGE-SIZE(strm-boleta) - LINE-COUNTER(strm-boleta) - 5) > 0 THEN DO:
       DO j = 1 TO (PAGE-SIZE(strm-boleta) - LINE-COUNTER(strm-boleta) - 5):
           PUT STREAM strm-boleta " " SKIP.
       END.
    END.
    
    PUT STREAM strm-boleta "------------------------------" AT 46
                           "------------------------------" AT 91 SKIP.
/*    PUT STREAM strm-boleta "Fecha Boleta : " TODAY FORMAT "99/99/9999".*/
    PUT STREAM strm-boleta "           EMPLEADOR          " AT 46
                           "           EMPLEADO           " AT 91 SKIP.
    
    PAGE STREAM strm-boleta.
END.  /* NRO DE COPIAS */    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca_datos_cts B-table-Win 
PROCEDURE busca_datos_cts :
/*------------------------------------------------------------------------------
    Busca datos
------------------------------------------------------------------------------*/
DEFINE VARIABLE saldo     AS DECIMAL.
DEFINE VARIABLE F-ValCal  AS DECIMAL.
DEFINE VARIABLE linea-msg AS CHARACTER EXTENT 3.
DEFINE VARIABLE j         AS INTEGER.
DEFINE VARIABLE ii        AS INTEGER.
DEFINE VARIABLE x-dirdiv  AS CHAR.
DEFINE VARIABLE x-desdiv  AS CHAR.
DEFINE VARIABLE x-dirper  AS CHAR.
DEFINE VARIABLE x-LEper   AS CHAR.
DEFINE VARIABLE X-RUC     AS CHAR INIT "20100038146" format "X(11)".
FOR EACH tmp-bole:
    DELETE tmp-bole.
END.

IF PL-FLG-MES.SitAct = "Inactivo" THEN RETURN. /* Si no esta Activo */

IF NOT CAN-FIND(FIRST PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia        AND
    PL-MOV-MES.Periodo = s-Periodo       AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln  AND
    PL-MOV-MES.CodCal  = PL-CALC.CodCal  AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer) THEN RETURN. /* Si no tiene c lculo */

DISPLAY PL-FLG-MES.CodPer @ FILL-IN-Codigo WITH FRAME F-Msg.

x-con-reg = 0.
x-valcalI = 0.
x-valcalE = 0.
x-valcalA = 0.

/* Cargamos el temporal con los ingresos */
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
        CREATE tmp-bole.
        x-con-reg = x-con-reg + 1.
        t-nro = x-con-reg.
        t-codrem = PL-MOV-MES.CodMov.
        t-imprem = PL-MOV-MES.ValCal-Mes.
        FIND PL-CONC WHERE PL-CONC.CodMov = PL-MOV-MES.CodMov NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN t-desrem = PL-CONC.DesMov.
        /* Para buscar referencia */
        IF PL-BOLE.CodRef <> 0 THEN DO:
            FIND b-PL-MOV-MES WHERE
                b-PL-MOV-MES.CodCia  = s-CodCia AND
                b-PL-MOV-MES.Periodo = s-Periodo AND
                b-PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
                b-PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
                b-PL-MOV-MES.CodCal  = PL-BOLE.CodCal-Ref AND
                b-PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
                b-PL-MOV-MES.CodMov  = PL-BOLE.CodRef NO-LOCK NO-ERROR.
            IF AVAILABLE b-PL-MOV-MES THEN
                t-refrem = STRING(b-PL-MOV-MES.ValCal-Mes,"Z99.99").
        END.
        x-valcalI = x-valcalI + PL-MOV-MES.ValCal-Mes.
    END.
END.

x-con-reg = 1.
/* Cargamos el temporal con Cts */
IF x-valcalI <> 0 THEN DO:
   x-valcalE = x-valcalE + ( 0.0833 * x-valcalI ).
   FIND FIRST tmp-bole WHERE t-nro = x-con-reg NO-ERROR.
   IF NOT AVAILABLE tmp-bole THEN DO:
      CREATE tmp-bole.
      t-nro = x-con-reg.
   END.
   t-coddes = 999.
   t-desdes = "COMPENSACION POR TIEMPO DE SERVICIO 8.33%".
   t-impdes = x-valcalE .
END.


RUN PLN/P-CALC-M.R(
   PL-FLG-MES.Codcia,
   PL-FLG-MES.Periodo,
   PL-FLG-MES.NroMes,
   PL-FLG-MES.codpln,
   1,
   PL-FLG-MES.codper,
   "^101(0);^102(0);^104(0);^105(0);^107(0);^140(0);^141(0);^100(1);^219(0);^501(0);
   ^502(0);^504(0);^301(1);^303(1);^010(0);^011(1)" ).

FOR EACH PL-CFG-CTE-MES WHERE
    PL-CFG-CTE-MES.CodCia = PL-FLG-MES.Codcia AND
    PL-CFG-CTE-MES.Periodo = PL-FLG-MES.Periodo AND
    PL-CFG-CTE-MES.NroMes = PL-FLG-MES.NroMes AND
    PL-CFG-CTE-MES.CodPer = PL-FLG-MES.codper AND
    PL-CFG-CTE-MES.Sdo-Cte-Mes > 0 NO-LOCK:
    saldo = saldo + PL-CFG-CTE-MES.Sdo-Cte-Mes.
END.

FIND GN-DIVI WHERE GN-DIVI.CodCia = s-codcia AND
     GN-DIVI.CodDiv =  PL-FLG-MES.CodDiv NO-LOCK NO-ERROR.
IF AVAILABLE GN-DIVI THEN
   ASSIGN x-desdiv = GN-DIVI.DesDiv
          x-dirdiv = GN-DIVI.DirDiv.
x-linea = TRIM(PL-FLG-MES.CodDiv) + " " + TRIM(x-desdiv).
FIND gn-cias WHERE gn-cias.codcia  = s-codcia NO-LOCK NO-ERROR.
DO ii = 1 TO FILL-IN-Copias:
    FIND GN-DIVI WHERE GN-DIVI.CodCia = s-codcia AND
         GN-DIVI.CodDiv =  PL-FLG-MES.CodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE GN-DIVI THEN
       ASSIGN x-desdiv = GN-DIVI.DesDiv
              x-dirdiv = TRIM(GN-DIVI.DirDiv).
    x-linea = TRIM(PL-FLG-MES.CodDiv) + " " + TRIM(x-desdiv).
    PUT STREAM strm-boleta SKIP(1).
    PUT STREAM strm-boleta CONTROL CHR(18) CHR(27) CHR(69).
    PUT STREAM strm-boleta S-NomCia SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70) CHR(27) CHR(77).
/*    PUT STREAM strm-boleta "R.U.C. : " S-RucCia   "DIVISION :" AT 70 */
    PUT STREAM strm-boleta "R.U.C. : " X-Ruc   "DIVISION :" AT 70 
                           " " x-linea FORMAT "X(30)" SKIP.
    PUT STREAM strm-boleta "R.PATRONAL : " ( X-RUC + "0000000") FORMAT "X(18)"
                           x-dirdiv AT 70 FORMAT "X(30)" SKIP.
    PUT STREAM strm-boleta S-DirCia  ' Telefono : ' GN-CIAS.TlflCia  SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(80) CHR(27) CHR(69).
    x-linea = "CONSTANCIA DE DEPOSITO DE C.T.S. DEL MES DE " +  x-mes.
    PUT STREAM strm-boleta x-linea AT 20 SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70) CHR(15).
    x-linea = FILL("-",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    IF AVAILABLE PL-PERS THEN DO:
        x-linea = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
        x-dirper = TRIM(PL-PERS.dirper) + " " + TRIM(PL-PERS.distri).
        x-LEper  = PL-PERS.NroDocId.
        END.
    ELSE x-linea = "".
    F-ValCal = val-var[1].  
    IF val-var[15] = 1 THEN 
       F-Valcal = val-var[1] * val-var[16].
    PUT STREAM strm-boleta "Codigo    : " PL-FLG-MES.codper " " x-linea FORMAT "X(40)"
                           "Basico  : " AT 73 "S/. " F-ValCal
                           "Dias Laborados : " AT 105 val-var[8] FORMAT "Z9.99" SKIP.
    FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND
         cb-auxi.Clfaux = "CCO" AND
         cb-auxi.Codaux = PL-FLG-MES.ccosto NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi THEN
       FIND cb-auxi WHERE cb-auxi.CodCia = S-CODCIA AND
            cb-auxi.Clfaux = "CCO" AND
            cb-auxi.Codaux = PL-FLG-MES.ccosto NO-LOCK NO-ERROR.
    IF AVAILABLE cb-auxi THEN x-linea = cb-auxi.Nomaux.
    ELSE x-linea = PL-FLG-MES.ccosto.
    PUT STREAM strm-boleta "C.Costo   : " x-linea FORMAT "X(15)"  
                           "Ocupacion    : " AT 38 PL-FLG-MES.cargos FORMAT "x(15)".
    FIND PL-AFPS OF PL-FLG-MES NO-LOCK NO-ERROR.
    IF AVAILABLE PL-AFPS THEN  x-linea = PL-AFPS.desafp.
    ELSE x-linea = "".
    PUT STREAM strm-boleta "IPSS    : " AT 73 PL-PERS.ctipss
                           "AFP            : " AT 105 x-linea FORMAT "X(15)"  SKIP.
    PUT STREAM strm-boleta "F.Ingreso : " PL-FLG-MES.fecing
                           "F.Vacaciones : " AT 38 PL-FLG-MES.inivac
                           "F.Cese  : " AT 73 PL-FLG-MES.vcontr
                           "CUSPP AFP      : " AT 105 PL-FLG-MES.nroafp SKIP.
    
    PUT STREAM strm-boleta "Domicilio : " x-dirper FORMAT "X(40)" 
                           "Sección : " AT 73 PL-FLG-MES.seccion  SKIP.
    PUT STREAM strm-boleta "L.E./DNI  : " x-LEper  FORMAT "X(40)" SKIP.
    x-linea = FILL("-",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(69).
    PUT STREAM strm-boleta "REMUNERACION" "LIQUIDACION" AT 60 SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70).
    
    x-con-reg = 0.
    
    FOR EACH tmp-bole NO-LOCK BREAK BY t-nro:
        x-con-reg = x-con-reg + 1.
        IF t-codrem > 0 THEN
           linea-msg[1] = STRING(t-codrem,"999") + " " + STRING(t-desrem,"x(21)") +
                          STRING(t-refrem,"x(5)") + " " + STRING(t-imprem,">,>>>,>>9.99").
        ELSE linea-msg[1] = FILL(" ",45).
        IF t-coddes > 0 THEN
           linea-msg[2] = STRING(t-coddes,"999") + " " + STRING(t-desdes,"x(46)") + 
                          " " + STRING(t-impdes,">,>>>,>>9.99").
        ElSE linea-msg[2] = FILL(" ",45).
        PUT STREAM strm-boleta linea-msg[1] FORMAT "X(43)" 
                               linea-msg[2] AT 60 FORMAT "X(63)"SKIP.
    END.
    x-linea = FILL("-",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    PUT STREAM strm-boleta "Total Remuneracion :           "        x-valcalI
                           "Total Liquidacion  :                     " AT 60  x-valcalE SKIP.
    x-linea = FILL("=",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    x-linea = STRING(x-valcalE,">,>>>,>>9.99") .
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(69).
    
       x-linea = x-linea + "                  CON ABONO EN LA CUENTA DE C.T.S. No " + SUBSTRING(PL-FLG-MES.nrodpt-cts,1,20) + " DEL " + PL-FLG-MES.cts.       
       PUT STREAM strm-boleta "NETO A PAGAR :   S/. " x-linea FORMAT 'X(110)' SKIP .
    
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70).
    
    linea-msg[1] = PL-FLG-MES.Clase.
    linea-msg[2] = FILL-IN-msg.
    linea-msg[3] = "". 
    IF val-var[9] > 0 THEN linea-msg[3] = "Tardanza " + STRING(val-var[9] / 0.5, "99").
    IF val-var[10] > 0 THEN DO:
        IF linea-msg[3] <> "" THEN linea-msg[3] = linea-msg[3] + ", ".
        linea-msg[3] = linea-msg[3] + "Falta Justificada " + STRING(val-var[10], "99").
    END.
    IF val-var[11] > 0 THEN DO:
        IF linea-msg[3] <> "" THEN linea-msg[3] = linea-msg[3] + ", ".
        linea-msg[3] = linea-msg[3] + "Falta Injustificada " + STRING(val-var[11], "99").
    END.
    IF val-var[12] > 0 THEN DO:
        IF linea-msg[3] <> "" THEN linea-msg[3] = linea-msg[3] + ", ".
        linea-msg[3] = linea-msg[3] + "Suspenci¢n " + STRING(val-var[12], "99").
    END.
    /* Ordenamos los mensajes */
    IF linea-msg[3] = "" THEN DO:
        IF linea-msg[2] = "" THEN DO:
            linea-msg[2] = linea-msg[1].
            linea-msg[1] = "".
        END.
        linea-msg[3] = linea-msg[2].
        linea-msg[2] = linea-msg[1].
        linea-msg[1] = "".
    END.
    ELSE DO:
        IF linea-msg[2] = "" THEN DO:
            linea-msg[2] = linea-msg[1].
            linea-msg[1] = "".
        END.
    END.
    
    DO j = 1 TO 3:
        x-linea = linea-msg[j].
        PUT STREAM strm-boleta x-linea SKIP.
    END.
    
    IF AVAILABLE PL-PERS THEN
        x-linea = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
    ELSE x-linea = "".
    
    
    IF (PAGE-SIZE(strm-boleta) - LINE-COUNTER(strm-boleta) - 5) > 0 THEN DO:
       DO j = 1 TO (PAGE-SIZE(strm-boleta) - LINE-COUNTER(strm-boleta) - 5):
           PUT STREAM strm-boleta " " SKIP.
       END.
    END.
    
    PUT STREAM strm-boleta "------------------------------" AT 46
                           "------------------------------" AT 91 SKIP.
/*    PUT STREAM strm-boleta "Fecha Boleta : " TODAY FORMAT "99/99/9999".*/
    PUT STREAM strm-boleta "           EMPLEADOR          " AT 46
                           "           EMPLEADO           " AT 91 SKIP.
    
    PAGE STREAM strm-boleta.
END.  /* NRO DE COPIAS */    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca_datos_cts2 B-table-Win 
PROCEDURE busca_datos_cts2 :
/*------------------------------------------------------------------------------
    Busca datos
------------------------------------------------------------------------------*/
DEFINE VARIABLE saldo     AS DECIMAL.
DEFINE VARIABLE F-ValCal  AS DECIMAL.
DEFINE VARIABLE linea-msg AS CHARACTER EXTENT 3.
DEFINE VARIABLE j         AS INTEGER.
DEFINE VARIABLE ii        AS INTEGER.
DEFINE VARIABLE x-dirdiv  AS CHAR.
DEFINE VARIABLE x-desdiv  AS CHAR.
DEFINE VARIABLE x-dirper  AS CHAR.
DEFINE VARIABLE x-LEper   AS CHAR.
DEFINE VARIABLE X-RUC     AS CHAR INIT "20100038146" format "X(11)".
FOR EACH tmp-bole:
    DELETE tmp-bole.
END.

IF PL-FLG-MES.SitAct = "Inactivo" THEN RETURN. /* Si no esta Activo */

IF NOT CAN-FIND(FIRST PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia        AND
    PL-MOV-MES.Periodo = s-Periodo       AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln  AND
    PL-MOV-MES.CodCal  = PL-CALC.CodCal  AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer) THEN RETURN. /* Si no tiene c lculo */

DISPLAY PL-FLG-MES.CodPer @ FILL-IN-Codigo WITH FRAME F-Msg.

x-con-reg = 0.
x-valcalI = 0.
x-valcalE = 0.
x-valcalA = 0.

/* Cargamos el temporal con los ingresos */
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
        CREATE tmp-bole.
        x-con-reg = x-con-reg + 1.
        t-nro = x-con-reg.
        t-codrem = PL-MOV-MES.CodMov.
        t-imprem = PL-MOV-MES.ValCal-Mes.
        FIND PL-CONC WHERE PL-CONC.CodMov = PL-MOV-MES.CodMov NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN t-desrem = PL-CONC.DesMov.
        /* Para buscar referencia */
        IF PL-BOLE.CodRef <> 0 THEN DO:
            FIND b-PL-MOV-MES WHERE
                b-PL-MOV-MES.CodCia  = s-CodCia AND
                b-PL-MOV-MES.Periodo = s-Periodo AND
                b-PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
                b-PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
                b-PL-MOV-MES.CodCal  = PL-BOLE.CodCal-Ref AND
                b-PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
                b-PL-MOV-MES.CodMov  = PL-BOLE.CodRef NO-LOCK NO-ERROR.
            IF AVAILABLE b-PL-MOV-MES THEN
                t-refrem = STRING(b-PL-MOV-MES.ValCal-Mes,"Z99.99").
        END.
        x-valcalI = x-valcalI + PL-MOV-MES.ValCal-Mes.
    END.
END.


x-con-reg = 1.
/* Cargamos el temporal con Cts */
IF x-valcalI <> 0 THEN DO:
   x-valcalE = x-valcalE + ( 0.0833 * x-valcalI ).
   FIND FIRST tmp-bole WHERE t-nro = x-con-reg NO-ERROR.
   IF NOT AVAILABLE tmp-bole THEN DO:
      CREATE tmp-bole.
      t-nro = x-con-reg.
   END.
   t-coddes = 999.
   t-desdes = "COMPENSACION POR TIEMPO DE SERVICIO 8.33%".
   t-impdes = x-valcalE .
END.

RUN PLN/P-CALC-M.R(
   PL-FLG-MES.Codcia,
   PL-FLG-MES.Periodo,
   PL-FLG-MES.NroMes,
   PL-FLG-MES.codpln,
   1,
   PL-FLG-MES.codper,
   "^101(0);^102(0);^104(0);^105(0);^107(0);^140(0);^141(0);^100(1);^219(0);^501(0);
   ^502(0);^504(0);^301(1);^303(1);^010(0);^011(1)" ).

FOR EACH PL-CFG-CTE-MES WHERE
    PL-CFG-CTE-MES.CodCia = PL-FLG-MES.Codcia AND
    PL-CFG-CTE-MES.Periodo = PL-FLG-MES.Periodo AND
    PL-CFG-CTE-MES.NroMes = PL-FLG-MES.NroMes AND
    PL-CFG-CTE-MES.CodPer = PL-FLG-MES.codper AND
    PL-CFG-CTE-MES.Sdo-Cte-Mes > 0 NO-LOCK:
    saldo = saldo + PL-CFG-CTE-MES.Sdo-Cte-Mes.
END.

FIND GN-DIVI WHERE GN-DIVI.CodCia = s-codcia AND
     GN-DIVI.CodDiv =  PL-FLG-MES.CodDiv NO-LOCK NO-ERROR.
IF AVAILABLE GN-DIVI THEN
   ASSIGN x-desdiv = GN-DIVI.DesDiv
          x-dirdiv = GN-DIVI.DirDiv.
x-linea = TRIM(PL-FLG-MES.CodDiv) + " " + TRIM(x-desdiv).
FIND gn-cias WHERE gn-cias.codcia  = s-codcia NO-LOCK NO-ERROR.
DO ii = 1 TO FILL-IN-Copias:
    FIND GN-DIVI WHERE GN-DIVI.CodCia = s-codcia AND
         GN-DIVI.CodDiv =  PL-FLG-MES.CodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE GN-DIVI THEN
       ASSIGN x-desdiv = GN-DIVI.DesDiv
              x-dirdiv = TRIM(GN-DIVI.DirDiv).
    x-linea = TRIM(PL-FLG-MES.CodDiv) + " " + TRIM(x-desdiv).
    PUT STREAM strm-boleta SKIP(1).
    PUT STREAM strm-boleta CONTROL CHR(18) CHR(27) CHR(69).
    PUT STREAM strm-boleta S-NomCia SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70) CHR(27) CHR(77).
    PUT STREAM strm-boleta "R.U.C. : " X-Ruc   "DIVISION :" AT 70 
                           " " x-linea FORMAT "X(30)" SKIP.
    PUT STREAM strm-boleta "R.PATRONAL : " ( X-RUC + "0000000") FORMAT "X(18)"
                           x-dirdiv AT 70 FORMAT "X(30)" SKIP.
    PUT STREAM strm-boleta S-DirCia  ' Telefono : ' GN-CIAS.TlflCia  SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(80) CHR(27) CHR(69).
    IF PL-CALC.CodCal = 001 THEN x-linea = "CONSTANCIA DE DEPOSITO DE C.T.S. DEL MES DE " + x-mes.
    IF PL-CALC.CodCal = 004 THEN x-linea = "CONSTANCIA DE DEPOSITO DE C.T.S. GRATIFICACION DEL MES DE " + x-mes.
    PUT STREAM strm-boleta x-linea AT 20 SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70) CHR(15).
/*
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(80) CHR(27) CHR(69).
    x-linea = "Decreto Legislativo No 650".
    PUT STREAM strm-boleta x-linea AT 35 SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70) CHR(15).
*/
    
    x-linea = FILL("-",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    IF AVAILABLE PL-PERS THEN DO:
        x-linea = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
        x-dirper = TRIM(PL-PERS.dirper) + " " + TRIM(PL-PERS.distri).
        x-LEper  = PL-PERS.NroDocId.
        END.
    ELSE x-linea = "".
    F-ValCal = val-var[1].  
    IF val-var[15] = 1 THEN 
       F-Valcal = val-var[1] * val-var[16].
    PUT STREAM strm-boleta "Codigo    : " PL-FLG-MES.codper " " x-linea FORMAT "X(40)"
                           "Basico  : " AT 73 "S/. " F-ValCal
                           "Dias Laborados : " AT 105 val-var[8] FORMAT "Z9.99" SKIP.
    FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND
         cb-auxi.Clfaux = "CCO" AND
         cb-auxi.Codaux = PL-FLG-MES.ccosto NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi THEN
       FIND cb-auxi WHERE cb-auxi.CodCia = S-CODCIA AND
            cb-auxi.Clfaux = "CCO" AND
            cb-auxi.Codaux = PL-FLG-MES.ccosto NO-LOCK NO-ERROR.
    IF AVAILABLE cb-auxi THEN x-linea = cb-auxi.Nomaux.
    ELSE x-linea = PL-FLG-MES.ccosto.
    PUT STREAM strm-boleta "C.Costo   : " x-linea FORMAT "X(15)"  
                           "Ocupacion    : " AT 38 PL-FLG-MES.cargos FORMAT "x(15)".
    FIND PL-AFPS OF PL-FLG-MES NO-LOCK NO-ERROR.
    IF AVAILABLE PL-AFPS THEN  x-linea = PL-AFPS.desafp.
    ELSE x-linea = "".
    PUT STREAM strm-boleta "IPSS    : " AT 73 PL-PERS.ctipss
                           "AFP            : " AT 105 x-linea FORMAT "X(15)"  SKIP.
    PUT STREAM strm-boleta "F.Ingreso : " PL-FLG-MES.fecing
                           "F.Vacaciones : " AT 38 PL-FLG-MES.inivac
                           "F.Cese  : " AT 73 PL-FLG-MES.vcontr
                           "CUSPP AFP      : " AT 105 PL-FLG-MES.nroafp SKIP.
    
    PUT STREAM strm-boleta "Domicilio : " x-dirper FORMAT "X(40)" 
                           "Sección : " AT 73 PL-FLG-MES.seccion  SKIP.
    PUT STREAM strm-boleta "L.E./DNI  : " x-LEper  FORMAT "X(40)" SKIP.
    x-linea = FILL("-",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(69).
    PUT STREAM strm-boleta "REMUNERACION" "LIQUIDACION" AT 60 SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70).
    
    x-con-reg = 0.
    
    FOR EACH tmp-bole NO-LOCK BREAK BY t-nro:
        x-con-reg = x-con-reg + 1.
        IF t-codrem > 0 THEN
           linea-msg[1] = STRING(t-codrem,"999") + " " + STRING(t-desrem,"x(21)") +
                          STRING(t-refrem,"x(5)") + " " + STRING(t-imprem,">,>>>,>>9.99").
        ELSE linea-msg[1] = FILL(" ",45).
        IF t-coddes > 0 THEN
           linea-msg[2] = STRING(t-coddes,"999") + " " + STRING(t-desdes,"x(21)") +
                          " " + STRING(t-impdes,">,>>>,>>9.99").
        ELSE linea-msg[2] = FILL(" ",45).
        PUT STREAM strm-boleta linea-msg[1] FORMAT "X(43)" 
                               linea-msg[2] AT 60 FORMAT "X(43)" SKIP.
    END.
    x-linea = FILL("-",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    PUT STREAM strm-boleta "Total Remuneracion :           "        x-valcalI
                           "Total Liquidacion  :           " AT 60  x-valcalE SKIP.
    x-linea = FILL("=",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    x-linea = STRING(x-valcalE,">,>>>,>>9.99") .
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(69).
    IF PL-FLG-MES.cnpago <> "EFECTIVO" THEN DO:
       x-linea = x-linea + "                  CON ABONO EN LA CUENTA DE C.T.S  No " + SUBSTRING(PL-FLG-MES.nrodpt-cts,1,20) + " DEL " + PL-FLG-MES.cts.
       PUT STREAM strm-boleta "NETO A PAGAR :   S/. " x-linea FORMAT 'X(110)' .
       END.
    ELSE
       PUT STREAM strm-boleta "NETO A PAGAR :   S/. " x-linea SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70).
    
    linea-msg[1] = PL-FLG-MES.Clase.
    linea-msg[2] = FILL-IN-msg.
    linea-msg[3] = "". 
    IF val-var[9] > 0 THEN linea-msg[3] = "Tardanza " + STRING(val-var[9] / 0.5, "99").
    IF val-var[10] > 0 THEN DO:
        IF linea-msg[3] <> "" THEN linea-msg[3] = linea-msg[3] + ", ".
        linea-msg[3] = linea-msg[3] + "Falta Justificada " + STRING(val-var[10], "99").
    END.
    IF val-var[11] > 0 THEN DO:
        IF linea-msg[3] <> "" THEN linea-msg[3] = linea-msg[3] + ", ".
        linea-msg[3] = linea-msg[3] + "Falta Injustificada " + STRING(val-var[11], "99").
    END.
    IF val-var[12] > 0 THEN DO:
        IF linea-msg[3] <> "" THEN linea-msg[3] = linea-msg[3] + ", ".
        linea-msg[3] = linea-msg[3] + "Suspenci¢n " + STRING(val-var[12], "99").
    END.
    /* Ordenamos los mensajes */
    IF linea-msg[3] = "" THEN DO:
        IF linea-msg[2] = "" THEN DO:
            linea-msg[2] = linea-msg[1].
            linea-msg[1] = "".
        END.
        linea-msg[3] = linea-msg[2].
        linea-msg[2] = linea-msg[1].
        linea-msg[1] = "".
    END.
    ELSE DO:
        IF linea-msg[2] = "" THEN DO:
            linea-msg[2] = linea-msg[1].
            linea-msg[1] = "".
        END.
    END.
    
    DO j = 1 TO 3:
        x-linea = linea-msg[j].
        PUT STREAM strm-boleta x-linea SKIP.
    END.
    
    IF AVAILABLE PL-PERS THEN
        x-linea = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
    ELSE x-linea = "".
    
    
    IF (PAGE-SIZE(strm-boleta) - LINE-COUNTER(strm-boleta) - 5) > 0 THEN DO:
       DO j = 1 TO (PAGE-SIZE(strm-boleta) - LINE-COUNTER(strm-boleta) - 5):
           PUT STREAM strm-boleta " " SKIP.
       END.
    END.
    
    PUT STREAM strm-boleta "------------------------------" AT 46
                           "------------------------------" AT 91 SKIP.
/*    PUT STREAM strm-boleta "Fecha Boleta : " TODAY FORMAT "99/99/9999".*/
    PUT STREAM strm-boleta "           EMPLEADOR          " AT 46
                           "           EMPLEADO           " AT 91 SKIP.
    
    PAGE STREAM strm-boleta.
END.  /* NRO DE COPIAS */    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_boleta B-table-Win 
PROCEDURE imp_boleta :
/*------------------------------------------------------------------------------
    Impresi¢n de boleta de pago.
------------------------------------------------------------------------------*/
DEFINE VARIABLE p-archivo AS CHARACTER.

/* Direccionamiento del STREAM */

IF INPUT FRAME {&FRAME-NAME} TGL-pantalla = TRUE THEN DO:
    P-archivo = SESSION:TEMP-DIRECTORY +
          STRING(NEXT-VALUE(sec-arc,integral),"99999999") + ".scr".
    OUTPUT STREAM strm-boleta TO VALUE ( P-archivo ) PAGED PAGE-SIZE 33.
END.
ELSE DO:
    OUTPUT STREAM strm-boleta TO PRINTER PAGED PAGE-SIZE 33.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(67) CHR(33) CHR(27) CHR(80). /* LETRA NORMAL */
END.

DEFINE VARIABLE i AS INTEGER.

RUN bin/_mes.r( FILL-IN-NRO-MES , 3 , OUTPUT x-mes ).

x-mes = x-mes + " de " + STRING(s-periodo,"9,999").

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

HIDE FRAME F-Msg.

OUTPUT STREAM strm-boleta CLOSE.

IF INPUT TGL-pantalla = TRUE THEN DO:
    RUN bin/_vcat.p ( P-archivo ). 
    OS-DELETE VALUE ( P-archivo ). 
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_cts B-table-Win 
PROCEDURE imp_cts :
/*------------------------------------------------------------------------------
    Impresi¢n de CTS.
------------------------------------------------------------------------------*/
DEFINE VARIABLE p-archivo AS CHARACTER.

/* Direccionamiento del STREAM */

IF INPUT FRAME {&FRAME-NAME} TGL-pantalla = TRUE THEN DO:
    P-archivo = SESSION:TEMP-DIRECTORY +
          STRING(NEXT-VALUE(sec-arc,integral),"99999999") + ".scr".
    OUTPUT STREAM strm-boleta TO VALUE ( P-archivo ) PAGED PAGE-SIZE 33.
END.
ELSE DO:
    OUTPUT STREAM strm-boleta TO PRINTER PAGED PAGE-SIZE 33.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(67) CHR(33) CHR(27) CHR(80). /* LETRA NORMAL */
END.

DEFINE VARIABLE i AS INTEGER.

RUN bin/_mes.r( FILL-IN-NRO-MES , 3 , OUTPUT x-mes ).

x-mes = x-mes + " de " + STRING(s-periodo,"9,999").

CASE R-seleccion:
WHEN 1 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Secci¢n".
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        DISPLAY PL-FLG-MES.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
        RUN busca_datos_cts.
        GET NEXT br_pl-flg-m.
    END.
END.
WHEN 2 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Secci¢n".
    DO i = 1 TO br_pl-flg-m:NUM-SELECTED-ROWS IN FRAME F-Main:
        ASSIGN stat-reg  = br_pl-flg-m:FETCH-SELECTED-ROW(i).
        IF stat-reg THEN DO:
            DISPLAY PL-FLG-MES.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
            RUN busca_datos_cts.
        END.
    END.
    ASSIGN stat-reg = br_pl-flg-m:DESELECT-ROWS().
END.
WHEN 3 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Secci¢n".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        IF PL-FLG-MES.Seccion = COMBO-S THEN RUN busca_datos_cts.
        GET NEXT br_pl-flg-m.
    END.
END.
WHEN 4 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Proyecto".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        IF PL-FLG-MES.Proyecto = COMBO-S THEN RUN busca_datos_cts.
        GET NEXT br_pl-flg-m.
    END.
END.

END CASE.

HIDE FRAME F-Msg.

OUTPUT STREAM strm-boleta CLOSE.

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

