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
       FIELD CodPer AS CHAR FORMAT "x(6)"
       FIELD TpoBol AS CHAR FORMAT "x(15)"
       FIELD CodMov AS INTEGER FORMAT "999"
       FIELD ValCal AS DECI EXTENT 13.
       

DEFINE  VAr I AS INTEGER.

DEF VAR Word AS COM-HANDLE.

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
&Scoped-Define ENABLED-OBJECTS RECT-2 COMBO-BOX-1 COMBO-BOX-2 ~
FILL-IN-NOMBRE Btn-UP FILL-IN-Copias FILL-IN-NRO-MES br_pl-flg-m Btn-DOWN ~
R-seleccion COMBO-S B-aceptar f-fecini F-Fecfin FILL-IN-msg 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-1 COMBO-BOX-2 FILL-IN-NOMBRE ~
FILL-IN-Copias FILL-IN-NRO-MES R-seleccion COMBO-S TGL-pantalla f-fecini ~
F-Fecfin FILL-IN-msg 

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

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "C¢digos" 
     LABEL "Mostrar ordenado por" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Códigos","Nombres" 
     DROP-DOWN-LIST
     SIZE 10.57 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Nombres que inicie con" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Nombres que inicie con","Nombres que contenga" 
     DROP-DOWN-LIST
     SIZE 20.43 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE COMBO-S AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20.43 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE F-Fecfin AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-fecini AS DATE FORMAT "99/99/9999":U 
     LABEL "Periodo de" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Copias AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Copias" 
     VIEW-AS FILL-IN 
     SIZE 3.29 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-msg AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mensaje" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NOMBRE AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .81
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

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
     SIZE 69.72 BY 11.54.

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
     COMBO-BOX-1 AT ROW 1.19 COL 7.57
     COMBO-BOX-2 AT ROW 2.12 COL 2 NO-LABEL
     FILL-IN-NOMBRE AT ROW 2.15 COL 22.86 NO-LABEL
     Btn-UP AT ROW 3.12 COL 9.72
     FILL-IN-Copias AT ROW 3.27 COL 17 COLON-ALIGNED
     FILL-IN-NRO-MES AT ROW 3.31 COL 4.29 COLON-ALIGNED
     br_pl-flg-m AT ROW 3.35 COL 22.86
     Btn-DOWN AT ROW 3.73 COL 9.72
     R-seleccion AT ROW 4.42 COL 6 NO-LABEL
     COMBO-S AT ROW 6.58 COL 2 NO-LABEL
     TGL-pantalla AT ROW 7.58 COL 5.29
     B-aceptar AT ROW 8.19 COL 7
     f-fecini AT ROW 11.58 COL 26 COLON-ALIGNED
     F-Fecfin AT ROW 11.58 COL 39 COLON-ALIGNED
     FILL-IN-msg AT ROW 11.58 COL 56 COLON-ALIGNED
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.72 BY 11.65
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
         HEIGHT             = 11.65
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

/* SETTINGS FOR COMBO-BOX COMBO-BOX-1 IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-2 IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX COMBO-S IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-NOMBRE IN FRAME F-Main
   ALIGN-L                                                              */
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
    ASSIGN f-fecini f-fecfin FILL-IN-NRO-MES R-seleccion COMBO-S FILL-IN-Copias FILL-IN-msg.
    IF FILL-IN-Copias = 0 THEN FILL-IN-Copias = 1.
    RUN genera-contrato.

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


&Scoped-define SELF-NAME COMBO-BOX-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-1 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-1 IN FRAME F-Main /* Mostrar ordenado por */
DO:
    IF INPUT COMBO-BOX-1 <> COMBO-BOX-1
    THEN RUN OPEN-QUERY.
    ASSIGN COMBO-BOX-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-2 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-2 IN FRAME F-Main
DO:
    IF INPUT COMBO-BOX-2 <> COMBO-BOX-2
    THEN IF FILL-IN-NOMBRE:SCREEN-VALUE <> "" THEN RUN OPEN-QUERY.
    ASSIGN COMBO-BOX-2.
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


&Scoped-define SELF-NAME FILL-IN-NOMBRE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NOMBRE B-table-Win
ON LEAVE OF FILL-IN-NOMBRE IN FRAME F-Main
DO:
    IF INPUT FILL-IN-NOMBRE <> FILL-IN-NOMBRE
    THEN RUN OPEN-QUERY.
    ASSIGN FILL-IN-NOMBRE.
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE contrato B-table-Win 
PROCEDURE contrato PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cNomPlantilla AS CHAR NO-UNDO.
DEF VAR cPlantilla AS CHAR NO-UNDO.

/* Buscamos la plantilla dentro de los programas */
ASSIGN
    cNomPlantilla = "contrato_conti2012.dot"
    cPlantilla = SEARCH("\\inf250\contratos\" + cNomPlantilla).
IF cPlantilla = ? THEN DO:
    MESSAGE 'No se encontró la plantilla' cNomPlantilla 'en la carpeta \\inf250\contratos'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

DEF VAR x-Anos AS DEC.
DEF VAR x-Meses AS DEC.
DEF VAR x-Dias AS DEC.

RUN pln/p-tserv (f-fecini, f-fecfin + 1, OUTPUT x-Anos, OUTPUT x-Meses, OUTPUT x-Dias).

DO:

DEF VAR x_archivo AS CHAR.
DEF VAR x_edad AS INTEGER.
DEF VAR x_codmov AS INTEGER INIT 101.
DEF VAR x-enletras AS CHAR.
DEF VAR x_codmon AS INTEGER INIT 1.
DEF VAR x-fecini AS DATE INIT 01/01/2003.
DEF VAR x-fecfin AS DATE INIT 12/31/2003.
DEF VAR x_vigcon AS CHAR .
DEF VAR x_fecini AS CHAR .
DEF VAR x_fecfin AS CHAR .
DEF VAR x_fecemi AS CHAR .
DEF VAR x_sueper AS CHAR .
DEf VAR x_secper AS CHAR .
DEF VAR x-distrito AS CHAR.

DEF VAR I AS INTEGER.

x-fecini = f-fecini.
x-fecfin = f-fecfin.

DEF VAR x_meses AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".

CREATE "Word.Application" Word.
/*Word:Visible = True.*/

/*
FIND Pl-pers WHERE Pl-Pers.Codper = "000128"
     NO-LOCK NO-ERROR.

FIND LAST PL-flg-mes WHERE pl-flg-mes.codcia = s-codcia AND
                           pl-flg-mes.codper = pl-pers.codper
                           NO-LOCK NO-ERROR.
*/

FIND Pl-pers WHERE Pl-Pers.Codper = pl-flg-mes.codper
     NO-LOCK NO-ERROR.
                           
FIND LAST pl-mov-mes WHERE pl-mov-mes.codcia = s-codcia AND
                           pl-mov-mes.codper = pl-pers.codper AND
                           pl-mov-mes.Codcal = 00 AND
                           pl-mov-mes.CodMov = x_codmov
                           NO-LOCK No-ERROR.
                            
IF NOT AVAILABLE pl-mov-mes THEN DO:
   MESSAGE "Codigo de Personal " + pl-flg-mes.codper SKIP
           "no tiene conceptos asignados ....verifique "
           VIEW-AS ALERT-BOX .
           RETURN.
END.

IF PL-FLG-MES.ccosto = "" THEN DO:
    MESSAGE "Centro de Costo no Registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
    
FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia
                AND cb-auxi.CLFAUX = "CCO"
                AND cb-auxi.CodAUX = PL-FLG-MES.ccosto
                NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-auxi THEN
   FIND cb-auxi WHERE cb-auxi.CodCia = s-codcia
                AND cb-auxi.CLFAUX = "CCO"
                AND cb-auxi.CodAUX = PL-FLG-MES.ccosto
                NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-auxi
THEN DO:
    MESSAGE "Centro de Costo no Registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.


RUN bin/_numero(pl-mov-mes.valcal, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF x_codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/*x_fecini = STRING(DAY(pl-flg-mes.fecing)) + " de " + ENTRY(MONTH(pl-flg-mes.fecing),x_meses) + " del " + STRING(YEAR(pl-flg-mes.fecing)).*/

x_edad = INTEGER((TODAY - pl-pers.FecNac) / 365).
x_fecini = STRING(DAY(x-fecini)) + " de " + ENTRY(MONTH(x-fecini),x_meses) + " del " + STRING(YEAR(x-fecini)).
x_fecfin = STRING(DAY(x-fecfin)) + " de " + ENTRY(MONTH(x-fecfin),x_meses) + " del " + STRING(YEAR(x-fecfin)).
x_fecemi = STRING(DAY(x-fecini)) + " dias del mes de " + ENTRY(MONTH(x-fecini),x_meses) + " del " + STRING(YEAR(x-fecini)).
x_vigcon = STRING((ROUND(((x-fecfin - x-fecini) / 30) ,0) + 1) ,"99") + "meses". 
x_sueper = STRING(Pl-mov-mes.valcal,">>>>9.99") + "(" + x-enletras + ")".
x_secper = cb-auxi.Nomaux.

/* RHC 04.08.04 */
x_VigCon = ''.
IF x-Anos > 0
THEN x_VigCon = STRING(x-Anos, '99') + ' año(s) '.
IF x-Meses > 0
THEN x_VigCon = x_VigCon + STRING(x-Meses, '99') + ' mes(es) '.
IF x-Dias > 0
THEN x_VigCon = x_VigCon + STRING(x-Dias, '99') + ' dia(s) '.

DEF VAR x-ubigeo AS CHAR NO-UNDO.
DEF VAR x-tipovia AS CHAR NO-UNDO.
DEF VAR x-cargos AS CHAR FORMAT 'x(50)' NO-UNDO.

/***Informacion de Ubigeo
FIND TabDepto WHERE
    TabDepto.CodDepto = SUBSTRING(PL-PERS.ubigeo,1,2)
    NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN x-ubigeo = TabDepto.NomDepto.
***/

/* Provincia */
FIND TabProvi WHERE
    TabProvi.CodDepto = SUBSTRING(PL-PERS.ubigeo,1,2) AND
    TabProvi.CodProvi = SUBSTRING(PL-PERS.ubigeo,3,2)
    NO-LOCK NO-ERROR.
IF AVAILABLE TabProvi THEN x-ubigeo = TabProvi.NomProvi.    


/*Tipo Via*/
FIND FIRST PL-TABLA WHERE
    pl-tabla.codcia = 0 AND
    pl-tabla.tabla = '05' AND
    pl-tabla.codigo = pl-pers.tipovia NO-LOCK NO-ERROR.
IF AVAIL pl-tabla THEN x-tipovia = PL-TABLA.Nombre.
ELSE x-tipovia = "".

/* Distrito */
FIND TabDistr WHERE
    TabDistr.CodDepto = SUBSTRING(PL-PERS.ubigeo,1,2) AND
    TabDistr.CodProvi = SUBSTRING(PL-PERS.ubigeo,3,2) AND
    TabDistr.CodDistr = SUBSTRING(PL-PERS.ubigeo,5,2) NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabDistr THEN x-distrito = "".
ELSE x-distrito = TabDistr.NomDistr.

/* Cargos */
x-Cargos = Pl-flg-mes.cargos.

/*Word:Documents:Add("contrato_conti2012").*/
/*Word:Documents:Add("contrato_conti01a").*/
Word:Documents:Add(cPlantilla).

RUN Remplazo(INPUT "CODPER", INPUT (pl-pers.codper), INPUT 0).
RUN Remplazo(INPUT "NOMPER", INPUT (trim(pl-pers.nomper) + " " + trim(pl-pers.patper) + " " + trim(pl-pers.matper)), INPUT 1).     
RUN Remplazo(INPUT "DIRPER", INPUT (trim(x-TipoVia) + " " + trim(pl-pers.dirper) + " " + trim(x-distrito) + "-" + trim(x-ubigeo) ), INPUT 0).
RUN Remplazo(INPUT "DNIPER", INPUT (pl-pers.NroDocId), INPUT 0).
/*RUN Remplazo(INPUT "EDAPER", INPUT (x_edad), INPUT 0).*/
RUN Remplazo(INPUT "CARPER01", INPUT TRIM(x-Cargos), INPUT 0).
/*RUN Remplazo(INPUT "CARPER02" ,INPUT (Pl-flg-mes.cargos), INPUT 0).*/
/*RUN Remplazo(INPUT "CODPER", INPUT (pl-pers.codper), INPUT 0).*/
RUN Remplazo(INPUT "SUEPER" ,INPUT (x_sueper), INPUT 0).
RUN Remplazo(INPUT "FECINI" ,INPUT (x_fecini), INPUT 0).
RUN Remplazo(INPUT "FECFIN" ,INPUT (x_fecfin), INPUT 0).
RUN Remplazo(INPUT "FECEMI" ,INPUT (x_fecemi), INPUT 0).
RUN Remplazo(INPUT "VIGCON" ,INPUT (x_vigcon), INPUT 0).
RUN Remplazo(INPUT "SECC" ,INPUT pl-flg-mes.seccion, INPUT 0). 

/*
Word:Selection:Goto(1).
Word:ActiveDocument:CheckSpelling().
*/

/* DO I = 1 TO FILL-IN-Copias:        */
/*    Word:ActiveDocument:PrintOut(). */
/* END.                               */

x_archivo = "contratoCONTI" + pl-pers.codper.
Word:ChangeFileOpenDirectory("\\inf250\contratos").
Word:ActiveDocument:SaveAs(x_archivo).
Word:Quit().

RELEASE OBJECT Word NO-ERROR.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE contrato_1 B-table-Win 
PROCEDURE contrato_1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Anos AS DEC.
DEF VAR x-Meses AS DEC.
DEF VAR x-Dias AS DEC.

RUN pln/p-tserv (f-fecini, f-fecfin + 1, OUTPUT x-Anos, OUTPUT x-Meses, OUTPUT x-Dias).

DO:

DEF VAR x_archivo AS CHAR.
DEF VAR x_edad AS INTEGER.
DEF VAR x_codmov AS INTEGER INIT 101.
DEF VAR x-enletras AS CHAR.
DEF VAR x_codmon AS INTEGER INIT 1.
DEF VAR x-fecini AS DATE INIT 01/01/2003.
DEF VAR x-fecfin AS DATE INIT 12/31/2003.
DEF VAR x_vigcon AS CHAR .
DEF VAR x_fecini AS CHAR .
DEF VAR x_fecfin AS CHAR .
DEF VAR x_fecemi AS CHAR .
DEF VAR x_sueper AS CHAR .
DEf VAR x_secper AS CHAR .
DEF VAR x-distrito AS CHAR.

DEF VAR I AS INTEGER.

x-fecini = f-fecini.
x-fecfin = f-fecfin.

DEF VAR x_meses AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".

CREATE "Word.Application" Word.
/*Word:Visible = True.*/

/*
FIND Pl-pers WHERE Pl-Pers.Codper = "000128"
     NO-LOCK NO-ERROR.

FIND LAST PL-flg-mes WHERE pl-flg-mes.codcia = s-codcia AND
                           pl-flg-mes.codper = pl-pers.codper
                           NO-LOCK NO-ERROR.
*/

FIND Pl-pers WHERE Pl-Pers.Codper = pl-flg-mes.codper
     NO-LOCK NO-ERROR.
                           
FIND LAST pl-mov-mes WHERE pl-mov-mes.codcia = s-codcia AND
                           pl-mov-mes.codper = pl-pers.codper AND
                           pl-mov-mes.Codcal = 00 AND
                           pl-mov-mes.CodMov = x_codmov
                           NO-LOCK No-ERROR.
                            
IF NOT AVAILABLE pl-mov-mes THEN DO:
   MESSAGE "Codigo de Personal " + pl-flg-mes.codper SKIP
           "no tiene conceptos asignados ....verifique "
           VIEW-AS ALERT-BOX .
           RETURN.
END.

IF PL-FLG-MES.ccosto = "" THEN DO:
    MESSAGE "Centro de Costo no Registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
    
FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia
                AND cb-auxi.CLFAUX = "CCO"
                AND cb-auxi.CodAUX = PL-FLG-MES.ccosto
                NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-auxi THEN
   FIND cb-auxi WHERE cb-auxi.CodCia = s-codcia
                AND cb-auxi.CLFAUX = "CCO"
                AND cb-auxi.CodAUX = PL-FLG-MES.ccosto
                NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-auxi
THEN DO:
    MESSAGE "Centro de Costo no Registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.


RUN bin/_numero(pl-mov-mes.valcal, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF x_codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/*x_fecini = STRING(DAY(pl-flg-mes.fecing)) + " de " + ENTRY(MONTH(pl-flg-mes.fecing),x_meses) + " del " + STRING(YEAR(pl-flg-mes.fecing)).*/

x_edad = INTEGER((TODAY - pl-pers.FecNac) / 365).
x_fecini = STRING(DAY(x-fecini)) + " de " + ENTRY(MONTH(x-fecini),x_meses) + " del " + STRING(YEAR(x-fecini)).
x_fecfin = STRING(DAY(x-fecfin)) + " de " + ENTRY(MONTH(x-fecfin),x_meses) + " del " + STRING(YEAR(x-fecfin)).
x_fecemi = STRING(DAY(x-fecini)) + " dias del mes de " + ENTRY(MONTH(x-fecini),x_meses) + " del " + STRING(YEAR(x-fecini)).
x_vigcon = STRING((ROUND(((x-fecfin - x-fecini) / 30) ,0) + 1) ,"99") + "meses". 
x_sueper = STRING(Pl-mov-mes.valcal) + "(" + x-enletras + ")".
x_secper = cb-auxi.Nomaux.

/* RHC 04.08.04 */
x_VigCon = ''.
IF x-Anos > 0
THEN x_VigCon = STRING(x-Anos, '99') + ' año(s) '.
IF x-Meses > 0
THEN x_VigCon = x_VigCon + STRING(x-Meses, '99') + ' mes(es) '.
IF x-Dias > 0
THEN x_VigCon = x_VigCon + STRING(x-Dias, '99') + ' dia(s) '.

DEF VAR x-ubigeo AS CHAR NO-UNDO.
DEF VAR x-tipovia AS CHAR NO-UNDO.

/***Informacion de Ubigeo
FIND TabDepto WHERE
    TabDepto.CodDepto = SUBSTRING(PL-PERS.ubigeo,1,2)
    NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN x-ubigeo = TabDepto.NomDepto.
***/

/* Provincia */
FIND TabProvi WHERE
    TabProvi.CodDepto = SUBSTRING(PL-PERS.ubigeo,1,2) AND
    TabProvi.CodProvi = SUBSTRING(PL-PERS.ubigeo,3,2)
    NO-LOCK NO-ERROR.
IF AVAILABLE TabProvi THEN x-ubigeo = TabProvi.NomProvi.    


/*Tipo Via*/
FIND FIRST PL-TABLA WHERE
    pl-tabla.codcia = 0 AND
    pl-tabla.tabla = '05' AND
    pl-tabla.codigo = pl-pers.tipovia NO-LOCK NO-ERROR.
IF AVAIL pl-tabla THEN x-tipovia = PL-TABLA.Nombre.
ELSE x-tipovia = "".

/* Distrito */
FIND TabDistr WHERE
    TabDistr.CodDepto = SUBSTRING(PL-PERS.ubigeo,1,2) AND
    TabDistr.CodProvi = SUBSTRING(PL-PERS.ubigeo,3,2) AND
    TabDistr.CodDistr = SUBSTRING(PL-PERS.ubigeo,5,2) NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabDistr THEN x-distrito = "".
ELSE x-distrito = TabDistr.NomDistr.

Word:Documents:Add("contrato_conti01").

RUN Remplazo(INPUT "CODPERS", INPUT (pl-pers.codper), INPUT 0).
RUN Remplazo(INPUT "NOMPER", INPUT (trim(pl-pers.nomper) + " " + trim(pl-pers.patper) + " " + trim(pl-pers.matper)), INPUT 1).     
/**RUN Remplazo(INPUT "SEXPER", INPUT (pl-pers.sexper), INPUT 0).**/
RUN Remplazo(INPUT "DIRPER", INPUT (trim(x-TipoVia) + " " + trim(pl-pers.dirper) + " " + trim(x-distrito) + "-" + trim(x-ubigeo) ), INPUT 0).
RUN Remplazo(INPUT "DNIPER", INPUT (pl-pers.NroDocId), INPUT 0).
RUN Remplazo(INPUT "EDAPER", INPUT (x_edad), INPUT 0).
RUN Remplazo(INPUT "CARPER01" ,INPUT (Pl-flg-mes.cargos), INPUT 0).
RUN Remplazo(INPUT "CARPER02" ,INPUT (Pl-flg-mes.cargos), INPUT 0).
/**
RUN Remplazo(INPUT "SECPER01" ,INPUT (x_secper), INPUT 0).
RUN Remplazo(INPUT "SECPER02" ,INPUT (x_secper), INPUT 0).
RUN Remplazo(INPUT "SECPER03" ,INPUT (x_secper), INPUT 0).
**/
RUN Remplazo(INPUT "CODPER", INPUT (pl-pers.codper), INPUT 0).
RUN Remplazo(INPUT "SUEPER" ,INPUT (x_sueper), INPUT 0).
RUN Remplazo(INPUT "FECINI" ,INPUT (x_fecini), INPUT 0).
RUN Remplazo(INPUT "FECFIN" ,INPUT (x_fecfin), INPUT 0).
RUN Remplazo(INPUT "FECEMI" ,INPUT (x_fecemi), INPUT 0).
RUN Remplazo(INPUT "VIGCON" ,INPUT (x_vigcon), INPUT 0).
RUN Remplazo(INPUT "SECC" ,INPUT (SUBSTRING(pl-flg-mes.seccion,6)), INPUT 0). 

/*
Word:Selection:Goto(1).
Word:ActiveDocument:CheckSpelling().
*/

/* DO I = 1 TO FILL-IN-Copias:        */
/*    Word:ActiveDocument:PrintOut(). */
/* END.                               */

x_archivo = "contratoCONTI" + pl-pers.codper.
Word:ChangeFileOpenDirectory("\\inf250\contratos").
Word:ActiveDocument:SaveAs(x_archivo).
Word:Quit().

RELEASE OBJECT Word NO-ERROR.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genera-contrato B-table-Win 
PROCEDURE genera-contrato :
/*------------------------------------------------------------------------------
    Impresi¢n de boleta de pago.
------------------------------------------------------------------------------*/
DEFINE VARIABLE p-archivo AS CHARACTER.

/* Direccionamiento del STREAM */


DEFINE VAR I AS INTEGER.

CASE R-seleccion:
WHEN 1 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Secci¢n".
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        DISPLAY PL-FLG-MES.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
        RUN contrato.
        GET NEXT br_pl-flg-m.
    END.
END.
WHEN 2 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Secci¢n".
    DO i = 1 TO br_pl-flg-m:NUM-SELECTED-ROWS IN FRAME F-Main:
        ASSIGN stat-reg  = br_pl-flg-m:FETCH-SELECTED-ROW(i).
        IF stat-reg THEN DO:
            DISPLAY PL-FLG-MES.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
            RUN contrato.
        END.
    END.
    ASSIGN stat-reg = br_pl-flg-m:DESELECT-ROWS().
END.
WHEN 3 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Secci¢n".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        IF PL-FLG-MES.Seccion = COMBO-S THEN RUN contrato.
        GET NEXT br_pl-flg-m.
    END.
END.
WHEN 4 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Proyecto".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        IF PL-FLG-MES.Proyecto = COMBO-S THEN RUN contrato.
        GET NEXT br_pl-flg-m.
    END.
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
    F-Fecini = TODAY.
    F-Fecfin = TODAY.
    
    DISPLAY F-fecini F-fecfin FILL-IN-NRO-MES WITH FRAME F-Main.

    APPLY "VALUE-CHANGED" TO R-seleccion IN FRAME F-Main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OPEN-QUERY B-table-Win 
PROCEDURE OPEN-QUERY :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:    
        CASE COMBO-BOX-1:SCREEN-VALUE:
            WHEN COMBO-BOX-1:ENTRY(1) THEN RUN OPEN-QUERY-CODIGO.
            WHEN COMBO-BOX-1:ENTRY(2) THEN RUN OPEN-QUERY-NOMBRE.
        END CASE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OPEN-QUERY-CODIGO B-table-Win 
PROCEDURE OPEN-QUERY-CODIGO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

    IF FILL-IN-NOMBRE:SCREEN-VALUE = "" THEN
        OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-MES WHERE
            PL-FLG-MES.CodCia = s-CodCia AND
            PL-FLG-MES.Periodo = s-Periodo AND
            PL-FLG-MES.codpln = PL-PLAN.CodPln AND
            PL-FLG-MES.NroMes = FILL-IN-NRO-MES NO-LOCK,
            EACH PL-PERS OF PL-FLG-MES NO-LOCK
            BY PL-FLG-MES.codper.
    ELSE
        IF COMBO-BOX-2:SCREEN-VALUE = COMBO-BOX-2:ENTRY(1) THEN
            OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-MES WHERE
                PL-FLG-MES.CodCia = s-CodCia AND
                PL-FLG-MES.Periodo = s-Periodo AND
                PL-FLG-MES.codpln = PL-PLAN.CodPln AND
                PL-FLG-MES.NroMes = FILL-IN-NRO-MES NO-LOCK,
                EACH PL-PERS OF PL-FLG-MES NO-LOCK WHERE
                    PL-PERS.patper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE OR
                    PL-PERS.matper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE OR
                    PL-PERS.nomper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE
                BY PL-FLG-MES.codper.
        ELSE
            OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-MES WHERE
                PL-FLG-MES.CodCia = s-CodCia AND
                PL-FLG-MES.Periodo = s-Periodo AND
                PL-FLG-MES.codpln = PL-PLAN.CodPln AND
                PL-FLG-MES.NroMes = FILL-IN-NRO-MES NO-LOCK,
                EACH PL-PERS OF PL-FLG-MES NO-LOCK WHERE
                    INDEX( PL-PERS.patper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0 OR
                    INDEX( PL-PERS.matper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0 OR
                    INDEX( PL-PERS.nomper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0
                BY PL-FLG-MES.codper.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OPEN-QUERY-NOMBRE B-table-Win 
PROCEDURE OPEN-QUERY-NOMBRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

    IF FILL-IN-NOMBRE:SCREEN-VALUE = "" THEN
        OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-MES WHERE
            PL-FLG-MES.CodCia = s-CodCia AND
            PL-FLG-MES.Periodo = s-Periodo AND
            PL-FLG-MES.codpln = PL-PLAN.CodPln AND
            PL-FLG-MES.NroMes = FILL-IN-NRO-MES NO-LOCK,
            EACH PL-PERS OF PL-FLG-MES NO-LOCK
            BY PL-PERS.patper
            BY PL-PERS.matper
            BY PL-PERS.nomper.
    ELSE
        IF COMBO-BOX-2:SCREEN-VALUE = COMBO-BOX-2:ENTRY(1) THEN
            OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-MES WHERE
                PL-FLG-MES.CodCia = s-CodCia AND
                PL-FLG-MES.Periodo = s-Periodo AND
                PL-FLG-MES.codpln = PL-PLAN.CodPln AND
                PL-FLG-MES.NroMes = FILL-IN-NRO-MES NO-LOCK,
                EACH PL-PERS OF PL-FLG-MES NO-LOCK WHERE
                    PL-PERS.patper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE OR
                    PL-PERS.matper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE OR
                    PL-PERS.nomper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE
                BY PL-PERS.patper
                BY PL-PERS.matper
                BY PL-PERS.nomper.
        ELSE
            OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-MES WHERE
                PL-FLG-MES.CodCia = s-CodCia AND
                PL-FLG-MES.Periodo = s-Periodo AND
                PL-FLG-MES.codpln = PL-PLAN.CodPln AND
                PL-FLG-MES.NroMes = FILL-IN-NRO-MES NO-LOCK,
                EACH PL-PERS OF PL-FLG-MES NO-LOCK WHERE
                    INDEX( PL-PERS.patper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0 OR
                    INDEX( PL-PERS.matper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0 OR
                    INDEX( PL-PERS.nomper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0
                BY PL-PERS.patper
                BY PL-PERS.matper
                BY PL-PERS.nomper.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Remplazo B-table-Win 
PROCEDURE Remplazo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER campo AS CHARACTER.
DEFINE INPUT PARAMETER registro AS CHARACTER.
DEFINE INPUT PARAMETER mayuscula AS LOGICAL.
DEFINE VAR cBuffer AS CHARACTER.

Word:Selection:Goto(-1 BY-VARIANT-POINTER,,,campo BY-VARIANT-POINTER).
Word:Selection:Select().
IF mayuscula = TRUE THEN cBuffer = CAPS(registro).
ELSE cBuffer = registro.
Word:Selection:Typetext(cBuffer).

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

