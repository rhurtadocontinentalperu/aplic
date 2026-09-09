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

DEFINE TEMP-TABLE Tempo NO-UNDO LIKE PL-MOV-MES.

DEFINE VARIABLE cFile-Name AS CHARACTER NO-UNDO.

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
&Scoped-define INTERNAL-TABLES INTEGRAL.PL-FLG-MES INTEGRAL.PL-PERS

/* Definitions for BROWSE br_pl-flg-m                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-m 
&Scoped-define QUERY-STRING-br_pl-flg-m FOR EACH INTEGRAL.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES NO-LOCK, ~
      EACH INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-MES NO-LOCK ~
    BY INTEGRAL.PL-FLG-MES.codper
&Scoped-define OPEN-QUERY-br_pl-flg-m OPEN QUERY br_pl-flg-m FOR EACH INTEGRAL.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES NO-LOCK, ~
      EACH INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-MES NO-LOCK ~
    BY INTEGRAL.PL-FLG-MES.codper.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-m INTEGRAL.PL-FLG-MES ~
INTEGRAL.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-m INTEGRAL.PL-FLG-MES
&Scoped-define SECOND-TABLE-IN-QUERY-br_pl-flg-m INTEGRAL.PL-PERS


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_pl-flg-m}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 Btn-UP FILL-IN-NRO-MES br_pl-flg-m ~
Btn-DOWN R-seleccion COMBO-S COMBO-canal B-aceptar FILL-IN-msg 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NRO-MES R-seleccion COMBO-S ~
COMBO-canal FILL-IN-msg 

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

DEFINE VARIABLE COMBO-canal AS CHARACTER FORMAT "X(256)":U INITIAL "BANCO DE CREDITO" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "BANCO DE CREDITO","BIF" 
     DROP-DOWN-LIST
     SIZE 20 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE COMBO-S AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

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
     SIZE 69.72 BY 9.5.

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
     FILL-IN-NRO-MES AT ROW 1.27 COL 3.86 COLON-ALIGNED
     br_pl-flg-m AT ROW 1.31 COL 22.43
     Btn-DOWN AT ROW 1.69 COL 9.29
     R-seleccion AT ROW 2.38 COL 5.57 NO-LABEL
     COMBO-S AT ROW 4.54 COL 2 NO-LABEL
     COMBO-canal AT ROW 5.31 COL 2 NO-LABEL WIDGET-ID 2
     B-aceptar AT ROW 6.15 COL 6.57
     FILL-IN-msg AT ROW 9.46 COL 27 COLON-ALIGNED
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

/* SETTINGS FOR COMBO-BOX COMBO-canal IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX COMBO-S IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-m
/* Query rebuild information for BROWSE br_pl-flg-m
     _TblList          = "INTEGRAL.PL-FLG-MES,INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-MES"
     _Options          = "NO-LOCK"
     _OrdList          = "INTEGRAL.PL-FLG-MES.codper|yes"
     _Where[1]         = "PL-FLG-MES.CodCia = s-CodCia
 AND PL-FLG-MES.Periodo = s-Periodo
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES"
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
    ASSIGN FILL-IN-NRO-MES R-seleccion COMBO-S FILL-IN-msg COMBO-canal.

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
/*        PL-MOV-MES.CodMov  = 411  NO-LOCK :*/
        PL-MOV-MES.CodMov  = 403  NO-LOCK :
    IF PL-MOV-MES.ValCal-Mes <> 0 AND
/*ML01* ***
/*MLR*/ TRIM(PL-FLG-Mes.cnpago) = "BANCO DE CREDITO" AND
*ML01* ***/
/*ML01*/ TRIM(PL-FLG-Mes.cnpago) = COMBO-canal AND
        PL-FLG-Mes.Nrodpt <> ""  THEN DO:
       CREATE Tempo.
       RAW-TRANSFER PL-MOV-MES TO Tempo.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cAux-File1 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAux-File2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

FOR EACH Tempo:
    DELETE Tempo.
END.

DEFINE VAR I AS INTEGER.

CASE R-seleccion:
WHEN 1 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Sección".
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        DISPLAY PL-FLG-MES.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
        RUN busca_datos.
        GET NEXT br_pl-flg-m.
    END.
END.
WHEN 2 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Sección".
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
    ASSIGN FILL-IN-Seccion:LABEL = "Sección".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        IF PL-FLG-MES.Seccion = substring(COMBO-S,1,25) THEN RUN busca_datos.
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

CASE COMBO-canal:
    WHEN "BIF" THEN
        RUN Excel_bif.
    WHEN "BANCO DE CREDITO" THEN
        RUN Excel_bcp.
END CASE.

HIDE FRAME F-Msg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel_bcp B-table-Win 
PROCEDURE Excel_bcp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define var x-cargo as char format "x(20)".
define var y as integer init 0.
define var x-tot as deci init 0.
define var x-tipo as deci init 0.
define var x-factor as deci init 0.
define var i as integer .
define var x-des as char.
define var x-chek as deci .

define var x-in as integer.
define var x-de as integer.
define var x-nom as char format "x(40)".
define var x as char format "x(200)".
define var x-cta as char format "x(11)".
define var x-dir as char format "x(40)".

IF INDEX(cFile-Name,".") = 0 THEN DO:
    cFile-Name = cFile-Name + ".txt".
END.

/*MLR* 17/12/07 ***
output to "c:\temp\sueldos.txt".
* ***/
DEF VAR x-Archivo AS CHAR NO-UNDO.


x-dir = "RENE DESCARTES MZ C LT 1 URB. STA RAQUEL 2DA ETAPA ATE".
x-nom = "CONTINENTAL S.A.".
x-cargo = "19101179051005      ".

y = 0 .
x-tot = 0.
x-chek = 0.
for each tempo:
    find pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  
        and pl-flg-mes.periodo = tempo.periodo 
        and pl-flg-mes.nromes  = tempo.nromes  
        and pl-flg-mes.codper  = tempo.codper  no-lock no-error.
    if available pl-flg-mes and (cnpago = "EFECTIVO" or cnpago = "") THEN NEXT .
    if available pl-flg-mes and nrodpt <> "" then do: 
        x-in = 0.
        x-in = (tempo.valcal-mes  ) .
        x-tot = x-tot + x-in.
        x-chek = x-chek + DECI(substring(nrodpt,5,8)).
        y  = y + 1.
    end.  
end.

x-chek = x-chek + DECI(substring(x-cargo,4,8)).
x-tot = x-tot * 100.
x = "".

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".
OUTPUT TO VALUE(x-Archivo).

for each tempo :
    find pl-pers where pl-pers.codper = tempo.codper no-lock no-error.
    find first pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  and
                      pl-flg-mes.periodo = tempo.periodo and
                      pl-flg-mes.nromes  = tempo.nromes  and
                      pl-flg-mes.codper  = tempo.codper  no-lock no-error.
    if available pl-flg-mes and (cnpago = "EFECTIVO" or cnpago = "") THEN NEXT .
    if available pl-flg-mes and nrodpt <> "" then do: 
        x-in = 0.
        x-in = (tempo.valcal-mes ) * 100.  
        x-des = "".
        do I = 1 to length(left-trim(PL-PERS.nomper)):
            if substr(left-trim(PL-PERS.nomper),i,1) = " " then do:
                x-des = substr(left-trim(PL-PERS.nomper),1,i - 1).
                leave.
        end.
    end.
    if x-des = "" then  x-des = trim(PL-PERS.nomper).

    x-nom =   trim(PL-PERS.patper) + " " + trim(PL-PERS.matper) + " " + x-des .  
    x-cta = substring(PL-FLG-MES.nrodpt,1,3) + substring(PL-FLG-MES.nrodpt,5,8) + substring(PL-FLG-MES.nrodpt,14,1) + substring(PL-FLG-MES.nrodpt,16,2).
  
    x  =  " " + 
          "2" + 
          "A" + 
          STRING(x-cta,"x(20)") + 
          string(x-nom,"x(40)") + 
          "S/" + '|' +
          string(x-in,"ZZZZZZZZZZZZZZZ") + '|' +
          "PAGO DE HABERES                         " + 
          "0" + 
          "DNI" + 
          string(PL-PERS.NroDocId,"x(9)") + 
          "   0" + '|'.
    x = REPLACE ( x, '|', CHR(9) ).
    PUT x SKIP.
  end.  
end.  
output close.

/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'BCP', YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel_bif B-table-Win 
PROCEDURE Excel_bif :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE iCount AS INTEGER FORMAT "9999999" NO-UNDO.
DEFINE VARIABLE cTpoDoc AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cTpoPln AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cCodBco AS CHARACTER FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE iTpoMon AS INTEGER FORMAT "9" NO-UNDO.
DEFINE VARIABLE cMonto AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE cNroCta AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE iMotivo AS INTEGER FORMAT "9" NO-UNDO.


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

OUTPUT TO VALUE(cFile-Name).

FOR EACH tempo NO-LOCK:

    FOR pl-pers
        FIELDS (pl-pers.codper pl-pers.patper pl-pers.matper pl-pers.nomper
            pl-pers.TpoDocId pl-pers.NroDocId)
        WHERE pl-pers.codper = tempo.codper NO-LOCK:
    END.
    IF NOT AVAILABLE pl-pers THEN NEXT.

    FOR FIRST pl-flg-mes
        FIELDS (pl-flg-mes.codcia pl-flg-mes.periodo pl-flg-mes.nromes
            pl-flg-mes.codpln pl-flg-mes.codper pl-flg-mes.nrodpt)
        WHERE pl-flg-mes.codcia = tempo.codcia
        AND pl-flg-mes.periodo = tempo.periodo
        AND pl-flg-mes.codpln = tempo.codpln
        AND pl-flg-mes.nromes = tempo.nromes
        AND pl-flg-mes.codper = tempo.codper NO-LOCK:
    END.

    IF NOT AVAILABLE pl-flg-mes THEN NEXT.

    IF pl-flg-mes.nrodpt = "" THEN NEXT.

    iCount = iCount + 1.

    CASE pl-pers.TpoDocId:
        WHEN "01" THEN cTpodoc = "1".
        WHEN "04" THEN cTpodoc = "3".
        OTHERWISE cTpodoc = "1".
    END CASE.

    cMonto = STRING((tempo.valcal-mes * 100),"99999999999999").
    cNroCta = FILL(" ", 20 - LENGTH(pl-flg-mes.nrodpt)) + pl-flg-mes.nrodpt.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_boleta B-table-Win 
PROCEDURE imp_boleta :
/*------------------------------------------------------------------------------
    Impresión de boleta de pago.
------------------------------------------------------------------------------*/

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
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Sección".
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        DISPLAY PL-FLG-MES.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
        RUN busca_datos.
        GET NEXT br_pl-flg-m.
    END.
END.
WHEN 2 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Sección".
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
    ASSIGN FILL-IN-Seccion:LABEL = "Sección".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        IF PL-FLG-MES.Seccion = substring(COMBO-S,1,25) THEN RUN busca_datos.
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

CASE COMBO-canal:
    WHEN "BIF" THEN
        RUN procesa_bif.
    WHEN "BANCO DE CREDITO" THEN
        RUN procesa_bcp.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa_bcp B-table-Win 
PROCEDURE Procesa_bcp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var x-cargo as char format "x(20)".
define var y as integer init 0.
define var x-tot as deci init 0.
define var x-tipo as deci init 0.
define var x-factor as deci init 0.
define var i as integer .
define var x-des as char.
define var x-chek as deci .

define var x-in as integer.
define var x-de as integer.
define var x-nom as char format "x(40)".
define var x as char format "x(200)".
define var x-cta as char format "x(11)".
define var x-dir as char format "x(40)".

IF INDEX(cFile-Name,".") = 0 THEN DO:
    cFile-Name = cFile-Name + ".txt".
END.

/*MLR* 17/12/07 ***
output to "c:\temp\sueldos.txt".
* ***/

OUTPUT TO VALUE(cFile-Name).

x-dir = "RENE DESCARTES MZ C LT 1 URB. STA RAQUEL 2DA ETAPA ATE".
x-nom = "CONTINENTAL S.A.".
x-cargo = "19101179051005      ".

y = 0 .
x-tot = 0.
x-chek = 0.
for each tempo:
    find pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  
        and pl-flg-mes.periodo = tempo.periodo 
        and pl-flg-mes.nromes  = tempo.nromes  
        and pl-flg-mes.codper  = tempo.codper  no-lock no-error.
    if available pl-flg-mes and (cnpago = "EFECTIVO" or cnpago = "") THEN NEXT .
    if available pl-flg-mes and nrodpt <> "" then do: 
        x-in = 0.
        x-in = (tempo.valcal-mes  ) .
        x-tot = x-tot + x-in.
        x-chek = x-chek + DECI(substring(nrodpt,5,8)).
        y  = y + 1.
    end.  
end.

x-chek = x-chek + DECI(substring(x-cargo,4,8)).
x-tot = x-tot * 100.
x = "".
  x  =    "#" +
          "1" + 
          "H" +
          "C" +
          STRING(x-cargo,"x(20)") +          
          "S/" +
          string(x-tot,"999999999999999") +
          string(DAY(TODAY),"99")  + string(MONTH(TODAY),"99") + string(YEAR(TODAY),"9999") +
          "PAGO DE HABERES     " +
          string(x-chek,"999999999999999") + 
          STRING(y,"999999") +
          "1" +
          "               " + 
          "0".
  DISPLAY x  WITH no-labels WIDTH 300.


for each tempo :
    find pl-pers where pl-pers.codper = tempo.codper no-lock no-error.
    find first pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  and
                      pl-flg-mes.periodo = tempo.periodo and
                      pl-flg-mes.nromes  = tempo.nromes  and
                      pl-flg-mes.codper  = tempo.codper  no-lock no-error.
    if available pl-flg-mes and (cnpago = "EFECTIVO" or cnpago = "") THEN NEXT .
    if available pl-flg-mes and nrodpt <> "" then do: 
        x-in = 0.
        x-in = (tempo.valcal-mes ) * 100.  
        x-des = "".
        do I = 1 to length(left-trim(PL-PERS.nomper)):
            if substr(left-trim(PL-PERS.nomper),i,1) = " " then do:
                x-des = substr(left-trim(PL-PERS.nomper),1,i - 1).
                leave.
        end.
    end.
    if x-des = "" then  x-des = trim(PL-PERS.nomper).

    x-nom =   trim(PL-PERS.patper) + " " + trim(PL-PERS.matper) + " " + x-des .  
    x-cta = substring(PL-FLG-MES.nrodpt,1,3) + substring(PL-FLG-MES.nrodpt,5,8) + substring(PL-FLG-MES.nrodpt,14,1) + substring(PL-FLG-MES.nrodpt,16,2).
  
    x  =  " " +
          "2" + 
          "A" +
          STRING(x-cta,"x(20)") +
          string(x-nom,"x(40)") + 
          "S/" + 
          string(x-in,"999999999999999") +
          "PAGO DE HABERES                         " +
          "0" + 
          "DNI" +
          string(PL-PERS.NroDocId,"x(9)") +
          "   1" .
    DISPLAY x  WITH no-labels WIDTH 300.
  end.  
end.  

output close.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa_bif B-table-Win 
PROCEDURE Procesa_bif :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE iCount AS INTEGER FORMAT "9999999" NO-UNDO.
DEFINE VARIABLE cTpoDoc AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cTpoPln AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cCodBco AS CHARACTER FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE iTpoMon AS INTEGER FORMAT "9" NO-UNDO.
DEFINE VARIABLE cMonto AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE cNroCta AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE iMotivo AS INTEGER FORMAT "9" NO-UNDO.

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

OUTPUT TO VALUE(cFile-Name).

FOR EACH tempo NO-LOCK:

    FOR pl-pers
        FIELDS (pl-pers.codper pl-pers.patper pl-pers.matper pl-pers.nomper
            pl-pers.TpoDocId pl-pers.NroDocId)
        WHERE pl-pers.codper = tempo.codper NO-LOCK:
    END.
    IF NOT AVAILABLE pl-pers THEN NEXT.

    FOR FIRST pl-flg-mes
        FIELDS (pl-flg-mes.codcia pl-flg-mes.periodo pl-flg-mes.nromes
            pl-flg-mes.codpln pl-flg-mes.codper pl-flg-mes.nrodpt)
        WHERE pl-flg-mes.codcia = tempo.codcia
        AND pl-flg-mes.periodo = tempo.periodo
        AND pl-flg-mes.codpln = tempo.codpln
        AND pl-flg-mes.nromes = tempo.nromes
        AND pl-flg-mes.codper = tempo.codper NO-LOCK:
    END.

    IF NOT AVAILABLE pl-flg-mes THEN NEXT.

    IF pl-flg-mes.nrodpt = "" THEN NEXT.

    iCount = iCount + 1.

    CASE pl-pers.TpoDocId:
        WHEN "01" THEN cTpodoc = "1".
        WHEN "04" THEN cTpodoc = "3".
        OTHERWISE cTpodoc = "1".
    END CASE.

    cMonto = STRING((tempo.valcal-mes * 100),"99999999999999").
    cNroCta = FILL(" ", 20 - LENGTH(pl-flg-mes.nrodpt)) + pl-flg-mes.nrodpt.

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

