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

DEFINE TEMP-TABLE Tempo 
       FIELD Codcia AS INTEGER 
       FIELD CodPer AS CHAR FORMAT "x(6)"
       FIELD NomPer AS CHAR FORMAT "x(35)"
       FIELD CCosto AS CHAR FORMAT "x(6)"
       FIELD NomCos AS CHAR FORMAT "x(35)"
       FIELD TpoBol AS CHAR FORMAT "x(15)"
       FIELD CodMov AS INTEGER FORMAT "999"
       FIELD ValCal AS DECI EXTENT 50.
       

DEFINE  VAr I AS INTEGER.

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
&Scoped-define EXTERNAL-TABLES INTEGRAL.PL-PLAN integral.PL-CALC
&Scoped-define FIRST-EXTERNAL-TABLE INTEGRAL.PL-PLAN


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR INTEGRAL.PL-PLAN, integral.PL-CALC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-FLG-MES integral.PL-PERS

/* Definitions for BROWSE br_pl-flg-m                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-m 
&Scoped-define QUERY-STRING-br_pl-flg-m FOR EACH integral.PL-FLG-MES WHERE TRUE /* Join to integral.PL-CALC incomplete */ ~
      AND PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES ~
 NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-MES NO-LOCK ~
    BY integral.PL-PERS.patper ~
       BY integral.PL-PERS.matper ~
        BY integral.PL-PERS.nomper
&Scoped-define OPEN-QUERY-br_pl-flg-m OPEN QUERY br_pl-flg-m FOR EACH integral.PL-FLG-MES WHERE TRUE /* Join to integral.PL-CALC incomplete */ ~
      AND PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES ~
 NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-MES NO-LOCK ~
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
&Scoped-Define ENABLED-OBJECTS RECT-2 Btn-UP FILL-IN-NRO-MES br_pl-flg-m ~
Btn-DOWN R-seleccion COMBO-S B-aceptar FILL-IN-msg 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NRO-MES R-seleccion COMBO-S ~
FILL-IN-msg 

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
     FILL-IN-NRO-MES AT ROW 1.27 COL 3.86 COLON-ALIGNED
     br_pl-flg-m AT ROW 1.31 COL 22.43
     Btn-DOWN AT ROW 1.69 COL 9.29
     R-seleccion AT ROW 2.38 COL 5.57 NO-LABEL
     COMBO-S AT ROW 4.54 COL 1.57 NO-LABEL
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
   External Tables: INTEGRAL.PL-PLAN,integral.PL-CALC
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
     _TblList          = "integral.PL-FLG-MES Where integral.PL-CALC ...,integral.PL-PERS OF integral.PL-FLG-MES"
     _Options          = "NO-LOCK"
     _OrdList          = "integral.PL-PERS.patper|yes,integral.PL-PERS.matper|yes,integral.PL-PERS.nomper|yes"
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
    ASSIGN 
        FILL-IN-NRO-MES 
        R-seleccion 
        COMBO-S         
        FILL-IN-msg.   
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
  {src/adm/template/row-list.i "INTEGRAL.PL-PLAN"}
  {src/adm/template/row-list.i "integral.PL-CALC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "INTEGRAL.PL-PLAN"}
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-nomper as char .
DISPLAY PL-FLG-MES.CodPer @ FILL-IN-Codigo WITH FRAME F-Msg.

/* Cargamos el temporal con los ingresos */
    FOR EACH PL-MOV-MES WHERE
        PL-MOV-MES.CodCia  =  s-CodCia AND
        PL-MOV-MES.Periodo =  s-Periodo AND
        PL-MOV-MES.NroMes  >= 1 AND
        PL-MOV-MES.NroMes  <= FILL-IN-NRO-MES AND
        PL-MOV-MES.CodPln  =  PL-PLAN.codpln AND
        PL-MOV-MES.CodCal  =  001 AND
        PL-MOV-MES.CodPer  =  PL-FLG-MES.CodPer :
        FIND Tempo WHERE Tempo.CodPer = PL-MOV-MES.CodPer NO-ERROR.
        x-nomper = "".
        IF NOT AVAILABLE Tempo THEN DO:                 
            FIND pl-pers where pl-pers.codper = pl-mov-mes.codper NO-LOCK NO-ERROR.
            IF AVAIL pl-pers THEN x-nomper = TRIM(pl-pers.patper) + " " + TRIM(pl-pers.matper) + " " + TRIM(pl-pers.nomper).
            FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND 
                cb-auxi.CLFAUX = "CCO" AND 
                cb-auxi.CodAUX = pl-flg-mes.ccosto NO-LOCK NO-ERROR.
            CREATE tempo.
            ASSIGN
                Tempo.Codcia = S-CODCIA
                Tempo.CodPer = PL-MOV-MES.CodPer                       
                Tempo.Codmov = Pl-MOV-MES.CodMov 
                Tempo.ccosto = pl-flg-mes.ccosto
                tempo.nomper = x-nomper 
                tempo.nomcos = cb-auxi.nomaux.
        END.
        CASE PL-MOV-MES.CodMov :
            WHEN 100 THEN Tempo.ValCal[1] =  Tempo.ValCal[1] + PL-MOV-MES.ValCal-Mes.
            WHEN 101 THEN Tempo.ValCal[2] =  Tempo.ValCal[2] + PL-MOV-MES.ValCal-Mes.
            WHEN 103 THEN Tempo.ValCal[3] =  Tempo.ValCal[3] + PL-MOV-MES.ValCal-Mes.
            WHEN 106 THEN Tempo.ValCal[4] =  Tempo.ValCal[4] + PL-MOV-MES.ValCal-Mes.
            WHEN 104 THEN Tempo.ValCal[5] =  Tempo.ValCal[5] + PL-MOV-MES.ValCal-Mes.
            WHEN 119 THEN Tempo.ValCal[6] =  Tempo.ValCal[6] + PL-MOV-MES.ValCal-Mes.
            WHEN 125 THEN Tempo.ValCal[7] =  Tempo.ValCal[7] + PL-MOV-MES.ValCal-Mes.
            WHEN 126 THEN Tempo.ValCal[8] =  Tempo.ValCal[8] + PL-MOV-MES.ValCal-Mes.
            WHEN 127 THEN Tempo.ValCal[9] =  Tempo.ValCal[9] + PL-MOV-MES.ValCal-Mes.
            WHEN 131 THEN Tempo.ValCal[10] =  Tempo.ValCal[10] + PL-MOV-MES.ValCal-Mes.
            WHEN 134 THEN Tempo.ValCal[11] =  Tempo.ValCal[11] + PL-MOV-MES.ValCal-Mes.
            WHEN 136 THEN Tempo.ValCal[12] =  Tempo.ValCal[12] + PL-MOV-MES.ValCal-Mes.
            WHEN 138 THEN Tempo.ValCal[13] =  Tempo.ValCal[13] + PL-MOV-MES.ValCal-Mes.
            WHEN 209 THEN Tempo.ValCal[14] =  Tempo.ValCal[14] + PL-MOV-MES.ValCal-Mes.
            WHEN 401 THEN Tempo.ValCal[15] =  Tempo.ValCal[15] + PL-MOV-MES.ValCal-Mes.
            WHEN 111 THEN Tempo.ValCal[16] =  Tempo.ValCal[16] + PL-MOV-MES.ValCal-Mes.
            WHEN 117 THEN Tempo.ValCal[17] =  Tempo.ValCal[17] + PL-MOV-MES.ValCal-Mes.
            WHEN 612 THEN Tempo.ValCal[18] =  Tempo.ValCal[18] + PL-MOV-MES.ValCal-Mes.
        END.
    END.
    x-con-reg = 0.

/*Calculando para Planilla*/

/* Cargamos el temporal con los ingresos */
    FOR EACH PL-MOV-MES WHERE
        PL-MOV-MES.CodCia  =  s-CodCia AND
        PL-MOV-MES.Periodo =  s-Periodo AND
        PL-MOV-MES.NroMes  >= 1 AND
        PL-MOV-MES.NroMes  <= FILL-IN-NRO-MES AND
        PL-MOV-MES.CodPln  =  PL-PLAN.codpln AND
        PL-MOV-MES.CodCal  =  005 AND
        PL-MOV-MES.CodPer  =  PL-FLG-MES.CodPer :
        FIND Tempo WHERE Tempo.CodPer = PL-MOV-MES.CodPer NO-ERROR.
        x-nomper = "".
        IF NOT AVAILABLE Tempo THEN DO:
            FIND pl-pers WHERE pl-pers.codper = pl-mov-mes.codper NO-LOCK NO-ERROR.
            IF AVAIL pl-pers THEN x-nomper = TRIM(pl-pers.patper) + " " + TRIM(pl-pers.matper) + " " + TRIM(pl-pers.nomper).
            FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND 
                cb-auxi.CLFAUX = "CCO" AND 
                cb-auxi.CodAUX = pl-flg-mes.ccosto NO-LOCK NO-ERROR.
            CREATE tempo.
            ASSIGN
                Tempo.Codcia = S-CODCIA
                Tempo.CodPer = PL-MOV-MES.CodPer                       
                Tempo.Codmov = Pl-MOV-MES.CodMov 
                Tempo.ccosto = pl-flg-mes.ccosto
                tempo.nomper = x-nomper 
                tempo.nomcos = cb-auxi.nomaux.
        END.
        CASE PL-MOV-MES.CodMov :
            WHEN 100 THEN Tempo.ValCal[21] =  Tempo.ValCal[21] + PL-MOV-MES.ValCal-Mes.
            WHEN 101 THEN Tempo.ValCal[22] =  Tempo.ValCal[22] + PL-MOV-MES.ValCal-Mes.
            WHEN 103 THEN Tempo.ValCal[23] =  Tempo.ValCal[23] + PL-MOV-MES.ValCal-Mes.
            WHEN 106 THEN Tempo.ValCal[24] =  Tempo.ValCal[24] + PL-MOV-MES.ValCal-Mes.
            WHEN 104 THEN Tempo.ValCal[25] =  Tempo.ValCal[25] + PL-MOV-MES.ValCal-Mes.
            WHEN 119 THEN Tempo.ValCal[26] =  Tempo.ValCal[26] + PL-MOV-MES.ValCal-Mes.
            WHEN 125 THEN Tempo.ValCal[27] =  Tempo.ValCal[27] + PL-MOV-MES.ValCal-Mes.
            WHEN 126 THEN Tempo.ValCal[28] =  Tempo.ValCal[28] + PL-MOV-MES.ValCal-Mes.
            WHEN 127 THEN Tempo.ValCal[29] =  Tempo.ValCal[29] + PL-MOV-MES.ValCal-Mes.
            WHEN 131 THEN Tempo.ValCal[30] =  Tempo.ValCal[30] + PL-MOV-MES.ValCal-Mes.
            WHEN 134 THEN Tempo.ValCal[31] =  Tempo.ValCal[31] + PL-MOV-MES.ValCal-Mes.
            WHEN 136 THEN Tempo.ValCal[32] =  Tempo.ValCal[32] + PL-MOV-MES.ValCal-Mes.
            WHEN 138 THEN Tempo.ValCal[33] =  Tempo.ValCal[33] + PL-MOV-MES.ValCal-Mes.
            WHEN 209 THEN Tempo.ValCal[34] =  Tempo.ValCal[34] + PL-MOV-MES.ValCal-Mes.
            WHEN 401 THEN Tempo.ValCal[35] =  Tempo.ValCal[35] + PL-MOV-MES.ValCal-Mes.
        END.
    END.
    x-con-reg = 0.
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
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

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
chWorkSheet:Range(cRange):Value = s-NomCia.
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = 'CALCULO : ' + PL-CALC.descal.
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "R E P O R T E   D E   R E M U N E R A C I O N E S " + STRING(S-PERIODO,"9999") + " AL MES " + STRING(FILL-IN-NRO-MES,"9999").

t-column = t-column + 2.
cColumn = STRING(t-Column).
chWorkSheet:Range("C4"):Value = 'Dias'.
chWorkSheet:Range("E4"):Value = 'Asignacion'.
chWorkSheet:Range("G4"):Value = 'Refrig.'.
chWorkSheet:Range("H4"):Value = 'Reembolso'.
chWorkSheet:Range("I4"):Value = 'H O R A S    E X T R A S'.
chWorkSheet:Range("L4"):Value = 'Bonifica.'.
chWorkSheet:Range("M4"):Value = 'Bonifica.'.
chWorkSheet:Range("O4"):Value = 'Asignacion'.
chWorkSheet:Range("Q4"):Value = 'Prestaciones'.
chWorkSheet:Range("R4"):Value = 'Alimentacion'.
chWorkSheet:Range("S4"):Value = 'Gratificacion'.
/*Liquidaciones*/
chWorkSheet:Range("V4"):Value = 'Dias'.
chWorkSheet:Range("X4"):Value = 'Asignacion'.
chWorkSheet:Range("Z4"):Value = 'Refrig.'.
chWorkSheet:Range("AA4"):Value = 'Reembolso'.
chWorkSheet:Range("AB4"):Value = 'H O R A S    E X T R A S'.
chWorkSheet:Range("AE4"):Value = 'Bonifica'.
chWorkSheet:Range("AF4"):Value = 'Bonifica'.
chWorkSheet:Range("AH4"):Value = 'Bonifica'.
chWorkSheet:Range("A5"):Value = 'Codigo'.
chWorkSheet:Range("B5"):Value = 'Nombre'.
chWorkSheet:Range("C5"):Value = 'Laborados'.
chWorkSheet:Range("D5"):Value = 'Basico'.
chWorkSheet:Range("E5"):Value = 'Familiar'.
chWorkSheet:Range("F5"):Value = 'Vacaciones'.
chWorkSheet:Range("G5"):Value = 'Movilidad'.
chWorkSheet:Range("H5"):Value = 'Subsidio'.
chWorkSheet:Range("I5"):Value = '25%'.
chWorkSheet:Range("J5"):Value = '100%'.
chWorkSheet:Range("K5"):Value = '35%'.
chWorkSheet:Range("L5"):Value = 'Incentivo'.
chWorkSheet:Range("M5"):Value = 'Especial'.
chWorkSheet:Range("N5"):Value = 'Reintegro'.
chWorkSheet:Range("O5"):Value = 'Extraordin'.
chWorkSheet:Range("P5"):Value = 'Comision'.
chWorkSheet:Range("Q5"):Value = 'Alimentarias'.
chWorkSheet:Range("R5"):Value = 'Principal'.
chWorkSheet:Range("S5"):Value = 'Extraordinaria'.
chWorkSheet:Range("T5"):Value = 'Otros'.
chWorkSheet:Range("U5"):Value = 'Total Sueldos'.
/*Liquidaciones*/
chWorkSheet:Range("V5"):Value = 'Laborados'.
chWorkSheet:Range("W5"):Value = 'Basico'.
chWorkSheet:Range("X5"):Value = 'Familiar'.
chWorkSheet:Range("Y5"):Value = 'Vacaciones'.
chWorkSheet:Range("Z5"):Value = 'Movilidad'.
chWorkSheet:Range("AA5"):Value = 'Subsidio'.
chWorkSheet:Range("AB5"):Value = '25%'.
chWorkSheet:Range("AC5"):Value = '100%'.
chWorkSheet:Range("AD5"):Value = '35%'.
chWorkSheet:Range("AE5"):Value = 'Incentivo'.
chWorkSheet:Range("AF5"):Value = 'Especial'.
chWorkSheet:Range("AG5"):Value = 'Reintegro'.
chWorkSheet:Range("AH5"):Value = 'Extraordin'.
chWorkSheet:Range("AI5"):Value = 'Comision'.
chWorkSheet:Range("AJ5"):Value = 'Otros'.
chWorkSheet:Range("AK5"):Value = 'Total Liquidaciones'.
FOR EACH tempo BREAK BY tempo.codcia BY tempo.ccosto BY tempo.Codper:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    {pln/i-rpremu2-detalle.i}
    ACCUM tempo.ValCal[1] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[2] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[3] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[4] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[5] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[6] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[7] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[8] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[9] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[10] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[11] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[12] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[13] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[14] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[15] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[16] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[17] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[18] ( SUB-TOTAL BY tempo.ccosto).
       /*Liquidaciones*/
       ACCUM tempo.ValCal[21] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[22] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[23] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[24] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[25] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[26] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[27] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[28] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[29] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[30] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[31] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[32] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[33] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[34] ( SUB-TOTAL BY tempo.ccosto).
       ACCUM tempo.ValCal[35] ( SUB-TOTAL BY tempo.ccosto).

       ACCUM tempo.ValCal[1] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[2] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[3] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[4] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[5] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[6] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[7] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[8] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[9] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[10] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[11] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[12] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[13] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[14] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[15] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[16] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[17] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[18] ( TOTAL BY tempo.codcia).
       /*Liquidaciones*/
       ACCUM tempo.ValCal[21] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[22] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[23] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[24] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[25] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[26] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[27] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[28] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[29] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[30] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[31] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[32] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[33] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[34] ( TOTAL BY tempo.codcia).
       ACCUM tempo.ValCal[35] ( TOTAL BY tempo.codcia).
    IF LAST-OF(tempo.ccosto) THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tempo.ccosto.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = tempo.nomcos.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[1].
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[2].
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[3].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[4].
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[5].
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[6].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[7].
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[8].
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[9].
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[10].
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[11].
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[12].
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[13].
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[14].
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[16].
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[17].
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[18].
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[15].
        /*Liquidaciones*/
        cRange = "V" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[21].
        cRange = "W" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[22].
        cRange = "X" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[23].
        cRange = "Y" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[24].
        cRange = "Z" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[25].
        cRange = "AA" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[26].
        cRange = "AB" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[27].
        cRange = "AC" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[28].
        cRange = "AD" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[29].
        cRange = "AE" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[30].
        cRange = "AF" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[31].
        cRange = "AG" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[32].
        cRange = "AH" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[33].
        cRange = "AI" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[34].
        cRange = "AJ" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Tempo.ccosto tempo.ValCal[35].
        t-column = t-column + 1.
    END.
    IF LAST-OF(tempo.codcia) THEN DO:            
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "Total Compañia ------------> ".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[1].
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[2].
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[3].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[4].
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[5].
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[6].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[7].
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[8].
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[9].
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[10].
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[11].
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[12].
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[13].
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[14].
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[16].
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[17].
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[18].
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[15].
        /*Liquidaciones*/
        cRange = "V" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[21].
        cRange = "W" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[22].
        cRange = "X" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[23].
        cRange = "Y" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[24].
        cRange = "Z" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[25].
        cRange = "AA" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[26].
        cRange = "AB" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[27].
        cRange = "AC" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[28].
        cRange = "AD" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[29].
        cRange = "AE" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[30].
        cRange = "AF" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[31].
        cRange = "AG" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[32].
        cRange = "AH" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[33].
        cRange = "AI" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[34].
        cRange = "AJ" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Tempo.codcia tempo.ValCal[35].
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
/*------------------------------------------------------------------------------
    Impresi¢n de boleta de pago.
------------------------------------------------------------------------------*/
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
HIDE FRAME F-Msg.

RUN Excel.

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
  {src/adm/template/snd-list.i "INTEGRAL.PL-PLAN"}
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

