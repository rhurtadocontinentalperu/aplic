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
DEFINE VARIABLE x-desde   AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-mes     AS CHARACTER NO-UNDO.
DEFINE VARIABLE stat-reg  AS LOGICAL NO-UNDO.
DEFINE VARIABLE x-con-reg AS INTEGER NO-UNDO.

DEFINE BUTTON Btn_OK IMAGE-UP FILE "img/plobrbol"
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

DEFINE BUFFER b-PL-MOV-SEM FOR PL-MOV-SEM. /* BUFFER para busquedas de referencias */

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
&Scoped-define BROWSE-NAME br_pl-flg-s

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-PLAN integral.PL-CALC
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-PLAN


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-PLAN, integral.PL-CALC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-FLG-SEM integral.PL-PERS

/* Definitions for BROWSE br_pl-flg-s                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-s 
&Scoped-define QUERY-STRING-br_pl-flg-s FOR EACH integral.PL-FLG-SEM ~
      WHERE PL-FLG-SEM.CodCia = s-CodCia ~
 AND PL-FLG-SEM.Periodo = s-Periodo ~
 AND PL-FLG-SEM.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-SEM.NroSem = FILL-IN-NRO-SEM ~
 NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-SEM NO-LOCK ~
    BY integral.PL-FLG-SEM.Proyecto ~
       BY integral.PL-FLG-SEM.seccion ~
        BY integral.PL-PERS.patper ~
         BY integral.PL-PERS.matper ~
          BY integral.PL-PERS.nomper
&Scoped-define OPEN-QUERY-br_pl-flg-s OPEN QUERY br_pl-flg-s FOR EACH integral.PL-FLG-SEM ~
      WHERE PL-FLG-SEM.CodCia = s-CodCia ~
 AND PL-FLG-SEM.Periodo = s-Periodo ~
 AND PL-FLG-SEM.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-SEM.NroSem = FILL-IN-NRO-SEM ~
 NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-SEM NO-LOCK ~
    BY integral.PL-FLG-SEM.Proyecto ~
       BY integral.PL-FLG-SEM.seccion ~
        BY integral.PL-PERS.patper ~
         BY integral.PL-PERS.matper ~
          BY integral.PL-PERS.nomper.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM ~
integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM
&Scoped-define SECOND-TABLE-IN-QUERY-br_pl-flg-s integral.PL-PERS


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_pl-flg-s}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn-UP RECT-21 FILL-IN-Copias ~
FILL-IN-NRO-SEM br_pl-flg-s Btn-DOWN R-seleccion COMBO-S TGL-pantalla ~
B-aceptar FILL-IN-msg 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Copias FILL-IN-NRO-SEM R-seleccion ~
COMBO-S TGL-pantalla FILL-IN-msg 

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
     SIZE 19.72 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Copias AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Copias" 
     VIEW-AS FILL-IN 
     SIZE 3.29 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-msg AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mensaje" 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NRO-SEM AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Sem" 
     VIEW-AS FILL-IN 
     SIZE 3.29 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE R-seleccion AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todo el personal", 1,
"Selectivo", 2,
"Por sección", 3,
"Por proyecto", 4
     SIZE 14.29 BY 2.23 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.57 BY 9.5.

DEFINE VARIABLE TGL-pantalla AS LOGICAL INITIAL no 
     LABEL "Salida a Pantalla" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.57 BY .5 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_pl-flg-s FOR 
      integral.PL-FLG-SEM, 
      integral.PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_pl-flg-s
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-flg-s B-table-Win _STRUCTURED
  QUERY br_pl-flg-s NO-LOCK DISPLAY
      integral.PL-FLG-SEM.codper FORMAT "X(6)":U
      integral.PL-PERS.patper FORMAT "X(40)":U
      integral.PL-PERS.matper FORMAT "X(40)":U
      integral.PL-PERS.nomper FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 47.14 BY 7.92
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn-UP AT ROW 1.12 COL 9.29
     FILL-IN-Copias AT ROW 1.23 COL 16.57 COLON-ALIGNED
     FILL-IN-NRO-SEM AT ROW 1.35 COL 3.86 COLON-ALIGNED
     br_pl-flg-s AT ROW 1.46 COL 22.29
     Btn-DOWN AT ROW 1.69 COL 9.29
     R-seleccion AT ROW 2.35 COL 4.14 NO-LABEL
     COMBO-S AT ROW 4.62 COL 1.57 NO-LABEL
     TGL-pantalla AT ROW 5.62 COL 4.86
     B-aceptar AT ROW 6.23 COL 6.14
     FILL-IN-msg AT ROW 9.46 COL 7.57 COLON-ALIGNED
     RECT-21 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.57 BY 9.5
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
   FRAME-NAME                                                           */
/* BROWSE-TAB br_pl-flg-s FILL-IN-NRO-SEM F-Main */
ASSIGN 
       br_pl-flg-s:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 1.

/* SETTINGS FOR COMBO-BOX COMBO-S IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-s
/* Query rebuild information for BROWSE br_pl-flg-s
     _TblList          = "integral.PL-FLG-SEM,integral.PL-PERS OF integral.PL-FLG-SEM"
     _Options          = "NO-LOCK"
     _OrdList          = "integral.PL-FLG-SEM.Proyecto|yes,integral.PL-FLG-SEM.seccion|yes,integral.PL-PERS.patper|yes,integral.PL-PERS.matper|yes,integral.PL-PERS.nomper|yes"
     _Where[1]         = "PL-FLG-SEM.CodCia = s-CodCia
 AND PL-FLG-SEM.Periodo = s-Periodo
 AND PL-FLG-SEM.codpln = PL-PLAN.CodPln
 AND PL-FLG-SEM.NroSem = FILL-IN-NRO-SEM
"
     _FldNameList[1]   = integral.PL-FLG-SEM.codper
     _FldNameList[2]   = integral.PL-PERS.patper
     _FldNameList[3]   = integral.PL-PERS.matper
     _FldNameList[4]   = integral.PL-PERS.nomper
     _Query            is OPENED
*/  /* BROWSE br_pl-flg-s */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar B-table-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN FILL-IN-NRO-SEM COMBO-S R-seleccion FILL-IN-msg FILL-IN-Copias.
    IF FILL-IN-Copias = 0 THEN FILL-IN-Copias = 1.
    RUN imp_boleta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_pl-flg-s
&Scoped-define SELF-NAME br_pl-flg-s
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-s B-table-Win
ON ROW-ENTRY OF br_pl-flg-s IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-s B-table-Win
ON ROW-LEAVE OF br_pl-flg-s IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-s B-table-Win
ON VALUE-CHANGED OF br_pl-flg-s IN FRAME F-Main
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
  IF INPUT FRAME F-Main FILL-IN-NRO-SEM - 1 >= 1 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-SEM - 1 @ FILL-IN-NRO-SEM WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-SEM.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP B-table-Win
ON CHOOSE OF Btn-UP IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-SEM + 1 <= 53 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-SEM + 1 @ FILL-IN-NRO-SEM WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-SEM.
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


&Scoped-define SELF-NAME FILL-IN-NRO-SEM
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NRO-SEM B-table-Win
ON LEAVE OF FILL-IN-NRO-SEM IN FRAME F-Main /* Sem */
DO:
    IF INPUT FILL-IN-NRO-SEM > 54 OR INPUT FILL-IN-NRO-SEM = 0 THEN DO:
        BELL.
        MESSAGE "Rango de semanas es de 1 a 54"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-NRO-SEM.
        RETURN NO-APPLY.
    END.
    IF INPUT FILL-IN-NRO-SEM = FILL-IN-NRO-SEM THEN RETURN.
    ASSIGN FILL-IN-NRO-SEM.
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
            Br_pl-flg-s:SENSITIVE = FALSE
            COMBO-S:SENSITIVE     = FALSE.
    WHEN 2 THEN
        ASSIGN
            Br_pl-flg-s:SENSITIVE = TRUE
            COMBO-S:SENSITIVE     = FALSE.
    WHEN 3 OR WHEN 4 THEN DO:
        ASSIGN
            COMBO-S:LIST-ITEMS    = ""
            Br_pl-flg-s:SENSITIVE = FALSE
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

ASSIGN FILL-IN-NRO-SEM = s-NroSem.

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
DEFINE VARIABLE x-ruccia  AS CHAR INIT "20100038146" FORMAT "X(11)".
DEFINE VARIABLE x-dirdiv  AS CHAR.
DEFINE VARIABLE x-desdiv  AS CHAR.

FOR EACH tmp-bole:
    DELETE tmp-bole.
END.

IF PL-FLG-SEM.SitAct = "Inactivo" THEN RETURN. /* Si no esta Activo */

IF NOT CAN-FIND(FIRST PL-MOV-SEM WHERE
    PL-MOV-SEM.CodCia  = s-CodCia        AND
    PL-MOV-SEM.Periodo = s-Periodo       AND
    PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
    PL-MOV-SEM.CodPln  = PL-PLAN.CodPln  AND
    PL-MOV-SEM.CodCal  = PL-CALC.CodCal  AND
    PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer) THEN RETURN. /* Si no tiene c lculo */

DISPLAY PL-FLG-SEM.CodPer @ FILL-IN-Codigo WITH FRAME F-Msg.

x-con-reg = 0.
x-valcalI = 0.
x-valcalE = 0.
x-valcalA = 0.

/* Cargamos el temporal con los Ingresos */
FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.CodPln = PL-PLAN.CodPln AND
    PL-BOLE.CodCal = PL-CALC.CodCal AND
    PL-BOLE.TpoBol = "Remuneraciones" BY PL-BOLE.nroitm:
    FIND PL-MOV-SEM WHERE
        PL-MOV-SEM.CodCia  = s-CodCia AND
        PL-MOV-SEM.Periodo = s-Periodo AND
        PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
        PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
        PL-MOV-SEM.CodCal  = PL-BOLE.CodCal AND
        PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
        PL-MOV-SEM.CodMov  = PL-BOLE.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-SEM AND PL-MOV-SEM.ValCal-Sem <> 0 THEN DO:
        CREATE tmp-bole.
        x-con-reg = x-con-reg + 1.
        t-nro = x-con-reg.
        t-codrem = PL-MOV-SEM.CodMov.
        t-imprem = PL-MOV-SEM.ValCal-Sem.
        FIND PL-CONC WHERE PL-CONC.CodMov = PL-MOV-SEM.CodMov NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN t-desrem = PL-CONC.DesMov.
        /* Para buscar referencia */
        IF PL-BOLE.CodRef <> 0 THEN DO:
            FIND b-PL-MOV-SEM WHERE
                b-PL-MOV-SEM.CodCia  = s-CodCia AND
                b-PL-MOV-SEM.Periodo = s-Periodo AND
                b-PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
                b-PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
                b-PL-MOV-SEM.CodCal  = PL-BOLE.CodCal-Ref AND
                b-PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
                b-PL-MOV-SEM.CodMov  = PL-BOLE.CodRef NO-LOCK NO-ERROR.
            IF AVAILABLE b-PL-MOV-SEM THEN
                t-refrem = STRING(b-PL-MOV-SEM.ValCal-Sem,"Z99.99").
        END.
        x-valcalI = x-valcalI + PL-MOV-SEM.ValCal-Sem.
    END.
END.

x-con-reg = 0.
/* Cargamos el temporal con los Descuentos */
FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.CodPln = PL-PLAN.CodPln AND
    PL-BOLE.CodCal = PL-CALC.CodCal AND
    PL-BOLE.TpoBol = "Descuentos" BY PL-BOLE.nroitm:
    FIND PL-MOV-SEM WHERE
        PL-MOV-SEM.CodCia  = s-CodCia AND
        PL-MOV-SEM.Periodo = s-Periodo AND
        PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
        PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
        PL-MOV-SEM.CodCal  = PL-BOLE.CodCal AND
        PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
        PL-MOV-SEM.CodMov  = PL-BOLE.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-SEM AND PL-MOV-SEM.ValCal-Sem <> 0 THEN DO:
        x-con-reg = x-con-reg + 1.
        FIND FIRST tmp-bole WHERE t-nro = x-con-reg NO-ERROR.
        IF NOT AVAILABLE tmp-bole THEN DO:
            CREATE tmp-bole.
            t-nro = x-con-reg.
        END.
        t-coddes = PL-MOV-SEM.CodMov.
        t-impdes = PL-MOV-SEM.ValCal-Sem.
        FIND PL-CONC WHERE PL-CONC.CodMov = PL-MOV-SEM.CodMov NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN t-desdes = PL-CONC.DesMov.
        x-valcalE = x-valcalE + PL-MOV-SEM.ValCal-Sem.
    END.
END.

x-con-reg = 0.
/* Cargamos el temporal con los Aportes */
FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.CodPln = PL-PLAN.CodPln AND
    PL-BOLE.CodCal = PL-CALC.CodCal AND
    PL-BOLE.TpoBol = "Aportes" BY PL-BOLE.nroitm:
    FIND PL-MOV-SEM WHERE
        PL-MOV-SEM.CodCia  = s-CodCia AND
        PL-MOV-SEM.Periodo = s-Periodo AND
        PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
        PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
        PL-MOV-SEM.CodCal  = PL-BOLE.CodCal AND
        PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
        PL-MOV-SEM.CodMov  = PL-BOLE.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-SEM AND PL-MOV-SEM.ValCal-Sem <> 0 THEN DO:
        x-con-reg = x-con-reg + 1.
        FIND FIRST tmp-bole WHERE t-nro = x-con-reg NO-ERROR.
        IF NOT AVAILABLE tmp-bole THEN DO:
            CREATE tmp-bole.
            t-nro = x-con-reg.
        END.
        t-codApo = PL-MOV-SEM.CodMov.
        t-impApo = PL-MOV-SEM.ValCal-Sem.
        FIND PL-CONC WHERE PL-CONC.CodMov = PL-MOV-SEM.CodMov NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN t-desApo = PL-CONC.DesMov.
        x-valcalA = x-valcalA + PL-MOV-SEM.ValCal-Sem.
    END.
END.

RUN PLN/P-CALC-S.R(
   PL-FLG-SEM.Codcia,
   PL-FLG-SEM.Periodo,
   PL-FLG-SEM.NroSem,
   PL-FLG-SEM.codpln,
   1,
   PL-FLG-SEM.codper,
   "^105(0);^106(0);^107(0);^109(0);^110(0);^151(0);^154(0);^100(1);^219(0);^501(0);^502(0);^504(0);^301(1);^303(1);^304(1);^503(0)" ).

FOR EACH PL-CFG-CTE-SEM WHERE
    PL-CFG-CTE-SEM.CodCia = PL-FLG-SEM.Codcia AND
    PL-CFG-CTE-SEM.Periodo = PL-FLG-SEM.Periodo AND
    PL-CFG-CTE-SEM.NroSem = PL-FLG-SEM.NroSem AND
    PL-CFG-CTE-SEM.CodPer = PL-FLG-SEM.codper AND
    PL-CFG-CTE-SEM.Sdo-Cte-Sem > 0 NO-LOCK:
    saldo = saldo + PL-CFG-CTE-SEM.Sdo-Cte-Sem.
END.

DO ii = 1 TO FILL-IN-Copias:
    PUT STREAM strm-boleta SKIP(1).
    PUT STREAM strm-boleta CONTROL CHR(18) CHR(27) CHR(69).
    PUT STREAM strm-boleta S-NomCia SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70) CHR(27) CHR(77).

    FIND GN-DIVI WHERE GN-DIVI.CodCia = s-codcia AND
         GN-DIVI.CodDiv =  PL-FLG-SEM.CodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE GN-DIVI THEN
       ASSIGN x-desdiv = GN-DIVI.DesDiv
              x-dirdiv = TRIM(GN-DIVI.DirDiv).
    x-linea = TRIM(PL-FLG-SEM.CodDiv) + " " + TRIM(x-desdiv).

    PUT STREAM strm-boleta "R.U.C. : " x-RucCia   "DIVISION:" AT 60 
                           " " x-linea FORMAT "X(30)" SKIP.
/*    PUT STREAM strm-boleta "R.PATRONAL : "  SKIP.*/
    PUT STREAM strm-boleta S-DirCia SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(80) CHR(27) CHR(69).
    CASE PL-CALC.CodCal:
       WHEN 003 THEN x-linea = "BOLETA DE VACACIONES OBREROS MES DE " + x-mes.
       WHEN 004 THEN x-linea = "BOLETA DE GRATIFICACION OBREROS MES DE " + x-mes.
       OTHERWISE x-linea = "BOLETA DE PAGO OBREROS MES DE " + x-mes.
    END CASE.
       
    PUT STREAM strm-boleta x-linea AT 20 SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70) CHR(15).
    IF PL-FLG-SEM.sitact <> "Vacaciones" THEN 
       PUT STREAM strm-boleta x-desde FORMAT "X(100)" SKIP.
    x-linea = FILL("-",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    IF AVAILABLE PL-PERS THEN
        x-linea = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
    ELSE x-linea = "".
    
    F-ValCal = val-var[1] + val-var[6]. /*+ val-var[2] + val-var[3] + val-var[4] + val-var[5] + 
               val-var[6] + val-var[7]. */
    IF PL-FLG-SEM.sitact = "Vacaciones" THEN val-var[8] = 30.
    PUT STREAM strm-boleta "Codigo    : " PL-FLG-SEM.codper " " x-linea FORMAT "X(40)"
                           "Basico  : " AT 73 "S/. " F-ValCal
                           "Dias Laborados : " AT 105 val-var[8] FORMAT "Z9.99" SKIP.
    
    FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND
         cb-auxi.Clfaux = "CCO" AND
         cb-auxi.Codaux = PL-FLG-SEM.ccosto NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi THEN
       FIND cb-auxi WHERE cb-auxi.CodCia = S-CODCIA AND
            cb-auxi.Clfaux = "CCO" AND
            cb-auxi.Codaux = PL-FLG-SEM.ccosto NO-LOCK NO-ERROR.
    IF AVAILABLE cb-auxi THEN x-linea = cb-auxi.Nomaux.
    ELSE x-linea = PL-FLG-SEM.ccosto.
    PUT STREAM strm-boleta "C.Costo   : " x-linea FORMAT "X(15)"  
                           "Ocupacion    : " AT 38 PL-FLG-SEM.cargos FORMAT "x(15)".
    FIND PL-AFPS OF PL-FLG-SEM NO-LOCK NO-ERROR.
    IF AVAILABLE PL-AFPS THEN  x-linea = PL-AFPS.desafp.
    ELSE x-linea = "".
    /* RHC 5-2-04 
    PUT STREAM strm-boleta "IPSS    : " AT 73 PL-PERS.ctipss
                           "AFP            : " AT 105 x-linea FORMAT "X(15)"  SKIP.
    */                           
    PUT STREAM strm-boleta "DNI     : " AT 73 PL-PERS.NroDocId
                           "AFP            : " AT 105 x-linea FORMAT "X(15)"  SKIP.
                           
    PUT STREAM strm-boleta "F.Ingreso : " PL-FLG-SEM.fecing
                           "F.Vacaciones : " AT 38 PL-FLG-SEM.inivac
                           "F.Cese  : " AT 73 PL-FLG-SEM.vcontr
                           "CUSPP AFP      : " AT 105 PL-FLG-SEM.nroafp SKIP.
    /* RHC 5-2-04 */
    PUT STREAM strm-boleta "Domicilio : " PL-PERS.DirPer FORMAT 'x(40)'
                           "Seccion : "   AT 73 PL-FLG-SEM.seccion SKIP.
    PUT STREAM strm-boleta "Horas lab.: " AT 73 (val-var[8] * 8) FORMAT ">>9.99" SKIP.

    x-linea = FILL("-",136).
    PUT STREAM strm-boleta x-linea FORMAT "X(136)" SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(69).
    PUT STREAM strm-boleta "REMUNERACION" "DESCUENTOS" AT 46 "APORTACIONES" AT 91 SKIP.
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
    x-linea = STRING(x-valcalI - x-valcalE,">,>>>,>>9.99").
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(69).
    PUT STREAM strm-boleta "NETO A PAGAR : " x-linea SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70).
    
    linea-msg[1] = PL-FLG-SEM.Clase.
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
    IF val-var[16] > 0 THEN DO:
        IF linea-msg[3] <> "" THEN linea-msg[3] = linea-msg[3] + ", ".
        linea-msg[3] = linea-msg[3] + "Lic.Sin Goce de Haber " + STRING(val-var[16], "99").
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
    PUT STREAM strm-boleta "           EMPLEADOR          " AT 46
                           "           TRABAJADOR         " AT 91 SKIP.
    PUT STREAM strm-boleta "Fecha Boleta : " TODAY    x-linea AT 91 FORMAT "X(30)".
    
    PAGE STREAM strm-boleta.
END.  /* FIN DE NRO. DE COPIAS */

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

FIND integral.PL-SEM WHERE
    integral.PL-SEM.CodCia = s-CodCia AND
    integral.PL-SEM.Periodo = s-Periodo AND
    integral.PL-SEM.NroSem = FILL-IN-NRO-SEM NO-LOCK NO-ERROR.
IF AVAILABLE integral.PL-SEM THEN
    ASSIGN
        x-desde = "Semana : " + STRING(FILL-IN-NRO-SEM,"99") + " del " +
        SUBSTRING(STRING(PL-SEM.FecIni),1,5) + " al " +
        SUBSTRING(STRING(PL-SEM.FecFin),1,5)
        i = PL-SEM.nromes.
ELSE
    ASSIGN
        x-desde = ""
        i = s-nromes.

RUN bin/_mes.r( i, 3 , OUTPUT x-mes ).

x-mes = x-mes + " del " + STRING(s-periodo,"9,999").

CASE R-seleccion:
WHEN 1 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Secci¢n".
    GET FIRST br_pl-flg-s.
    DO WHILE AVAILABLE(PL-FLG-SEM):
        DISPLAY PL-FLG-SEM.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
        RUN busca_datos.
        GET NEXT br_pl-flg-s.
    END.
END.
WHEN 2 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Secci¢n".
    DO i = 1 TO br_pl-flg-s:NUM-SELECTED-ROWS IN FRAME F-Main:
        ASSIGN stat-reg = br_pl-flg-s:FETCH-SELECTED-ROW(i).
        IF stat-reg THEN DO:
            DISPLAY PL-FLG-SEM.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
            RUN busca_datos.
        END.
    END.
    ASSIGN stat-reg = br_pl-flg-s:DESELECT-ROWS().
END.
WHEN 3 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Secci¢n".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    GET FIRST br_pl-flg-s.
    DO WHILE AVAILABLE(PL-FLG-SEM):
        IF PL-FLG-SEM.Seccion = COMBO-S THEN RUN busca_datos.
        GET NEXT br_pl-flg-s.
    END.
END.
WHEN 4 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Proyecto".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    GET FIRST br_pl-flg-s.
    DO WHILE AVAILABLE(PL-FLG-SEM):
        IF PL-FLG-SEM.Proyecto = COMBO-S THEN RUN busca_datos.
        GET NEXT br_pl-flg-s.
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

    DISPLAY FILL-IN-NRO-SEM WITH FRAME F-Main.

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
  {src/adm/template/snd-list.i "integral.PL-FLG-SEM"}
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

