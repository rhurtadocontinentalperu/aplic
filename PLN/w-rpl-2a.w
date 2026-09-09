&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
CREATE WIDGET-POOL.

&IF "{&NEW}" = "" &THEN 
    DEFINE INPUT  PARAMETER p-codrep AS CHARACTER.
    DEFINE INPUT  PARAMETER p-tipo   AS INTEGER.
    DEFINE INPUT  PARAMETER p-accion AS LOGICAL.
    DEFINE INPUT  PARAMETER p-nomrep AS CHARACTER.
    DEFINE OUTPUT PARAMETER p-OK     AS LOGICAL.
&ELSE 
    DEFINE VARIABLE p-codrep AS CHARACTER INITIAL "GENERAL".
    DEFINE VARIABLE p-tipo   AS INTEGER INITIAL 1.
    DEFINE VARIABLE p-accion AS LOGICAL INITIAL NO.
    DEFINE VARIABLE p-nomrep AS CHARACTER INITIAL "".
    DEFINE VARIABLE p-OK     AS LOGICAL INITIAL NO.
&ENDIF

/* Local Variable Definitions ---                                       */
{bin/s-global.i}
{pln/s-global.i}
DEFINE VARIABLE adm-brs-in-update AS LOGICAL NO-UNDO.
DEFINE VARIABLE ok-status     AS LOGICAL NO-UNDO.
DEFINE VARIABLE s-tpopln      AS LOGICAL.
DEFINE VARIABLE cmb-lista     AS CHARACTER.
DEFINE VARIABLE p-mes-1       AS INTEGER INITIAL 0.
DEFINE VARIABLE p-mes-2       AS INTEGER INITIAL 0.
DEFINE VARIABLE p-sem-1       AS INTEGER INITIAL 0.
DEFINE VARIABLE p-sem-2       AS INTEGER INITIAL 0.
DEFINE VARIABLE p-periodo     AS INTEGER.
DEFINE VARIABLE mes-actual    AS INTEGER.
DEFINE VARIABLE s-nroreg-tot  AS INTEGER NO-UNDO.
DEFINE VARIABLE s-nroreg-act  AS INTEGER NO-UNDO.
DEFINE VARIABLE FILL-IN-msj   AS CHARACTER FORMAT "X(256)":U 
    VIEW-AS FILL-IN SIZE 45.57 BY .81 NO-UNDO.

DEFINE FRAME F-mensaje
    FILL-IN-msj AT ROW 1.73 COL 2 NO-LABEL
    "Procesando para:" VIEW-AS TEXT
    SIZE 12.72 BY .5 AT ROW 1.15 COL 2
    SPACE(34.13) SKIP(1.19)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE FONT 4
    TITLE "Espere un momento por favor..." CENTERED.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_pl-flg-m

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-FLG-MES integral.PL-PERS ~
INTEGRAL.PL-FLG-SEM

/* Definitions for BROWSE br_pl-flg-m                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-m 
&Scoped-define QUERY-STRING-br_pl-flg-m FOR EACH integral.PL-FLG-MES ~
      WHERE integral.PL-FLG-MES.CodCia = s-CodCia ~
 AND integral.PL-FLG-MES.Periodo = s-Periodo ~
 AND integral.PL-FLG-MES.codpln = L-CODPLN-m ~
 AND integral.PL-FLG-MES.NroMes = L-NROMES ~
 /*AND integral.PL-FLG-MES.SitAct <> "Inactivo"*/ NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-MES ~
      WHERE integral.PL-PERS.patper BEGINS FILL-IN-PatPer NO-LOCK
&Scoped-define OPEN-QUERY-br_pl-flg-m OPEN QUERY br_pl-flg-m FOR EACH integral.PL-FLG-MES ~
      WHERE integral.PL-FLG-MES.CodCia = s-CodCia ~
 AND integral.PL-FLG-MES.Periodo = s-Periodo ~
 AND integral.PL-FLG-MES.codpln = L-CODPLN-m ~
 AND integral.PL-FLG-MES.NroMes = L-NROMES ~
 /*AND integral.PL-FLG-MES.SitAct <> "Inactivo"*/ NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-MES ~
      WHERE integral.PL-PERS.patper BEGINS FILL-IN-PatPer NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES ~
integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES
&Scoped-define SECOND-TABLE-IN-QUERY-br_pl-flg-m integral.PL-PERS


/* Definitions for BROWSE br_pl-flg-s                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-s 
&Scoped-define QUERY-STRING-br_pl-flg-s FOR EACH INTEGRAL.PL-FLG-SEM ~
      WHERE      PL-FLG-SEM.CodCia  = s-CodCia ~
 AND PL-FLG-SEM.Periodo = s-Periodo ~
 AND PL-FLG-SEM.codpln =  L-CODPLN ~
 AND PL-FLG-SEM.NroSem = L-NROSEM ~
 /*AND PL-FLG-SEM.SitAct <> "Inactivo"*/ NO-LOCK, ~
      EACH INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-SEM ~
      WHERE integral.PL-PERS.patper BEGINS FILL-IN-PatPer NO-LOCK
&Scoped-define OPEN-QUERY-br_pl-flg-s OPEN QUERY br_pl-flg-s FOR EACH INTEGRAL.PL-FLG-SEM ~
      WHERE      PL-FLG-SEM.CodCia  = s-CodCia ~
 AND PL-FLG-SEM.Periodo = s-Periodo ~
 AND PL-FLG-SEM.codpln =  L-CODPLN ~
 AND PL-FLG-SEM.NroSem = L-NROSEM ~
 /*AND PL-FLG-SEM.SitAct <> "Inactivo"*/ NO-LOCK, ~
      EACH INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-SEM ~
      WHERE integral.PL-PERS.patper BEGINS FILL-IN-PatPer NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-s INTEGRAL.PL-FLG-SEM ~
INTEGRAL.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-s INTEGRAL.PL-FLG-SEM
&Scoped-define SECOND-TABLE-IN-QUERY-br_pl-flg-s INTEGRAL.PL-PERS


/* Definitions for BROWSE br_pl-pers                                    */
&Scoped-define FIELDS-IN-QUERY-br_pl-pers integral.PL-PERS.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-pers 
&Scoped-define QUERY-STRING-br_pl-pers FOR EACH integral.PL-PERS ~
      WHERE integral.PL-PERS.patper BEGINS FILL-IN-PatPer NO-LOCK
&Scoped-define OPEN-QUERY-br_pl-pers OPEN QUERY br_pl-pers FOR EACH integral.PL-PERS ~
      WHERE integral.PL-PERS.patper BEGINS FILL-IN-PatPer NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_pl-pers integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-pers integral.PL-PERS


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-1 Btn-UP-4 Btn-UP-3 L-CODPLN-m ~
L-CODPLN Btn-DOWN-4 Btn-DOWN-3 TGL-uni Btn-UP-2 Btn-UP L-NroSem L-NroMes ~
Btn-DOWN Btn-DOWN-2 FILL-IN-PatPer R-seleccion COMBO-S B-aceptar ~
B-aceptar-2 
&Scoped-Define DISPLAYED-OBJECTS L-CODPLN-m L-CODPLN R-tpoper TGL-uni ~
L-NroSem L-NroMes FILL-IN-PatPer R-seleccion COMBO-S 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar AUTO-GO 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.54.

DEFINE BUTTON B-aceptar-2 
     IMAGE-UP FILE "img/b-cancel":U
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.54.

DEFINE BUTTON Btn-DOWN 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-DOWN-2 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-DOWN-3 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-DOWN-4 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP-2 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP-3 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP-4 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE VARIABLE COMBO-S AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20.43 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-PatPer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Filtrar por apellido paterno" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81 NO-UNDO.

DEFINE VARIABLE L-CODPLN AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Planilla" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE L-CODPLN-m AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Planilla" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE L-NroMes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE L-NroSem AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Semana" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE R-seleccion AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todo el personal", 1,
"Selectivo", 2,
"Por secci¢n", 3,
"Por proyecto", 4
     SIZE 14.14 BY 2.35 NO-UNDO.

DEFINE VARIABLE R-tpoper AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Semana", 1,
"Mes", 2
     SIZE 9.72 BY 1.58 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25.29 BY 2.08.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70.29 BY 11.77.

DEFINE VARIABLE TGL-uni AS LOGICAL INITIAL no 
     LABEL "Unificado" 
     VIEW-AS TOGGLE-BOX
     SIZE 9.14 BY .54 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_pl-flg-m FOR 
      integral.PL-FLG-MES, 
      integral.PL-PERS SCROLLING.

DEFINE QUERY br_pl-flg-s FOR 
      INTEGRAL.PL-FLG-SEM, 
      INTEGRAL.PL-PERS SCROLLING.

DEFINE QUERY br_pl-pers FOR 
      integral.PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_pl-flg-m
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-flg-m W-Win _STRUCTURED
  QUERY br_pl-flg-m NO-LOCK DISPLAY
      integral.PL-FLG-MES.codper FORMAT "X(6)":U
      integral.PL-PERS.patper FORMAT "X(40)":U
      integral.PL-PERS.matper FORMAT "X(40)":U
      integral.PL-PERS.nomper FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47 BY 6.73
         BGCOLOR 15 FGCOLOR 0 FONT 4.

DEFINE BROWSE br_pl-flg-s
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-flg-s W-Win _STRUCTURED
  QUERY br_pl-flg-s NO-LOCK DISPLAY
      integral.PL-FLG-SEM.codper FORMAT "X(6)":U
      integral.PL-PERS.patper FORMAT "X(40)":U
      integral.PL-PERS.matper FORMAT "X(40)":U
      integral.PL-PERS.nomper FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47 BY 6.73
         BGCOLOR 15 FGCOLOR 0 FONT 4.

DEFINE BROWSE br_pl-pers
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-pers W-Win _STRUCTURED
  QUERY br_pl-pers NO-LOCK DISPLAY
      integral.PL-PERS.codper FORMAT "X(6)":U
      integral.PL-PERS.patper FORMAT "X(40)":U
      integral.PL-PERS.matper FORMAT "X(40)":U
      integral.PL-PERS.nomper FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47 BY 6.73
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn-UP-4 AT ROW 1.31 COL 15.72
     Btn-UP-3 AT ROW 1.31 COL 15.72
     L-CODPLN-m AT ROW 1.54 COL 9.86 COLON-ALIGNED
     L-CODPLN AT ROW 1.54 COL 9.86 COLON-ALIGNED
     R-tpoper AT ROW 1.77 COL 50.72 NO-LABEL
     Btn-DOWN-4 AT ROW 1.92 COL 15.72
     Btn-DOWN-3 AT ROW 1.92 COL 15.72
     TGL-uni AT ROW 2.31 COL 39
     Btn-UP-2 AT ROW 2.5 COL 15.72
     Btn-UP AT ROW 2.54 COL 15.72
     L-NroSem AT ROW 2.77 COL 9.86 COLON-ALIGNED
     L-NroMes AT ROW 2.77 COL 9.86 COLON-ALIGNED
     Btn-DOWN AT ROW 3.12 COL 15.72
     Btn-DOWN-2 AT ROW 3.15 COL 15.72
     FILL-IN-PatPer AT ROW 4.5 COL 29 COLON-ALIGNED WIDGET-ID 2
     R-seleccion AT ROW 5.85 COL 6.43 NO-LABEL
     br_pl-flg-s AT ROW 5.85 COL 24
     br_pl-flg-m AT ROW 5.85 COL 24
     br_pl-pers AT ROW 5.92 COL 24.29
     COMBO-S AT ROW 8.38 COL 3 NO-LABEL
     B-aceptar AT ROW 9.42 COL 7.43
     B-aceptar-2 AT ROW 11.04 COL 7.29
     RECT-2 AT ROW 1.08 COL 1.72
     RECT-1 AT ROW 1.5 COL 37
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.14 BY 12.04
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Selector de Datos"
         HEIGHT             = 12.35
         WIDTH              = 72.14
         MAX-HEIGHT         = 12.35
         MAX-WIDTH          = 72.14
         VIRTUAL-HEIGHT     = 12.35
         VIRTUAL-WIDTH      = 72.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB br_pl-flg-s R-seleccion F-Main */
/* BROWSE-TAB br_pl-flg-m br_pl-flg-s F-Main */
/* BROWSE-TAB br_pl-pers br_pl-flg-m F-Main */
/* SETTINGS FOR BROWSE br_pl-flg-m IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       br_pl-flg-m:HIDDEN  IN FRAME F-Main                = TRUE
       br_pl-flg-m:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 1.

/* SETTINGS FOR BROWSE br_pl-flg-s IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       br_pl-flg-s:HIDDEN  IN FRAME F-Main                = TRUE
       br_pl-flg-s:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 1.

/* SETTINGS FOR BROWSE br_pl-pers IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       br_pl-pers:HIDDEN  IN FRAME F-Main                = TRUE
       br_pl-pers:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 1.

/* SETTINGS FOR COMBO-BOX COMBO-S IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR RADIO-SET R-tpoper IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-m
/* Query rebuild information for BROWSE br_pl-flg-m
     _TblList          = "integral.PL-FLG-MES,integral.PL-PERS OF integral.PL-FLG-MES"
     _Options          = "NO-LOCK"
     _Where[1]         = "integral.PL-FLG-MES.CodCia = s-CodCia
 AND integral.PL-FLG-MES.Periodo = s-Periodo
 AND integral.PL-FLG-MES.codpln = L-CODPLN-m
 AND integral.PL-FLG-MES.NroMes = L-NROMES
 /*AND integral.PL-FLG-MES.SitAct <> ""Inactivo""*/"
     _Where[2]         = "integral.PL-PERS.patper BEGINS FILL-IN-PatPer"
     _FldNameList[1]   = integral.PL-FLG-MES.codper
     _FldNameList[2]   = integral.PL-PERS.patper
     _FldNameList[3]   = integral.PL-PERS.matper
     _FldNameList[4]   = integral.PL-PERS.nomper
     _Query            is NOT OPENED
*/  /* BROWSE br_pl-flg-m */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-s
/* Query rebuild information for BROWSE br_pl-flg-s
     _TblList          = "INTEGRAL.PL-FLG-SEM,INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-SEM"
     _Options          = "NO-LOCK"
     _Where[1]         = "     PL-FLG-SEM.CodCia  = s-CodCia
 AND PL-FLG-SEM.Periodo = s-Periodo
 AND PL-FLG-SEM.codpln =  L-CODPLN
 AND PL-FLG-SEM.NroSem = L-NROSEM
 /*AND PL-FLG-SEM.SitAct <> ""Inactivo""*/"
     _Where[2]         = "integral.PL-PERS.patper BEGINS FILL-IN-PatPer"
     _FldNameList[1]   = integral.PL-FLG-SEM.codper
     _FldNameList[2]   = integral.PL-PERS.patper
     _FldNameList[3]   = integral.PL-PERS.matper
     _FldNameList[4]   = integral.PL-PERS.nomper
     _Query            is NOT OPENED
*/  /* BROWSE br_pl-flg-s */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-pers
/* Query rebuild information for BROWSE br_pl-pers
     _TblList          = "integral.PL-PERS"
     _Options          = "NO-LOCK"
     _Where[1]         = "integral.PL-PERS.patper BEGINS FILL-IN-PatPer"
     _FldNameList[1]   = integral.PL-PERS.codper
     _FldNameList[2]   = integral.PL-PERS.patper
     _FldNameList[3]   = integral.PL-PERS.matper
     _FldNameList[4]   = integral.PL-PERS.nomper
     _Query            is NOT OPENED
*/  /* BROWSE br_pl-pers */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Selector de Datos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Selector de Datos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar W-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN
        l-nromes
        l-nrosem
        COMBO-S
        L-CODPLN
        L-CODPLN-m
        R-seleccion
        R-tpoper
        TGL-uni.
    RUN procesa. 
    IF RETURN-VALUE <> "OK" THEN RETURN NO-APPLY.
    p-OK = YES.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-aceptar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar-2 W-Win
ON CHOOSE OF B-aceptar-2 IN FRAME F-Main /* Aceptar */
DO:
    p-OK = NO.
    APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN W-Win
ON CHOOSE OF Btn-DOWN IN FRAME F-Main
DO:
    IF INPUT FRAME F-Main l-nrosem - 1 >= 1 THEN DO:
        DISPLAY INPUT l-nrosem - 1 @ l-nrosem WITH FRAME F-Main.
        ASSIGN l-nrosem.
        {&OPEN-QUERY-br_pl-flg-s}                
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN-2 W-Win
ON CHOOSE OF Btn-DOWN-2 IN FRAME F-Main
DO:
    IF INPUT FRAME F-Main l-nromes - 1 >= 1 THEN DO:
        DISPLAY INPUT l-nromes - 1 @ l-nromes WITH FRAME F-Main.
        ASSIGN l-nromes.
        {&OPEN-QUERY-br_pl-flg-m}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN-3 W-Win
ON CHOOSE OF Btn-DOWN-3 IN FRAME F-Main
DO:
    IF AVAILABLE PL-PLAN THEN DO:
        FIND PREV PL-PLAN WHERE PL-PLAN.tippln = FALSE NO-ERROR.
        IF AVAILABLE PL-PLAN THEN l-codpln = PL-PLAN.CODPLN.
            DISPLAY l-codpln WITH FRAME F-Main.
    END.
    IF NOT AVAIL PL-PLAN THEN DO:
        FIND FIRST PL-PLAN WHERE PL-PLAN.TipPln = FALSE NO-ERROR.
        IF AVAILABLE PL-PLAN THEN l-codpln = PL-PLAN.CODPLN.
        DISPLAY l-codpln WITH FRAME F-Main.
    END.
    CASE p-tipo :
        WHEN 1 THEN {&OPEN-QUERY-br_pl-flg-s}
        WHEN 2 THEN {&OPEN-QUERY-br_pl-flg-m}
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN-4 W-Win
ON CHOOSE OF Btn-DOWN-4 IN FRAME F-Main
DO:
    IF AVAILABLE PL-PLAN THEN DO:
        FIND PREV PL-PLAN WHERE PL-PLAN.tippln = TRUE NO-ERROR.
        IF AVAILABLE PL-PLAN THEN l-codpln-m = PL-PLAN.CODPLN.
            DISPLAY l-codpln-m WITH FRAME F-Main.
    END.
    IF NOT AVAIL PL-PLAN THEN DO:
        FIND FIRST PL-PLAN WHERE PL-PLAN.TipPln = TRUE NO-ERROR.
        IF AVAILABLE PL-PLAN THEN l-codpln-m = PL-PLAN.CODPLN.
        DISPLAY l-codpln-m WITH FRAME F-Main.
    END.
    CASE p-tipo :
        WHEN 1 THEN {&OPEN-QUERY-br_pl-flg-s}
        WHEN 2 THEN {&OPEN-QUERY-br_pl-flg-m}
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP W-Win
ON CHOOSE OF Btn-UP IN FRAME F-Main
DO:
    IF INPUT FRAME F-Main l-nrosem + 1 <= 53 THEN DO:
        DISPLAY INPUT l-nrosem + 1 @ l-nrosem WITH FRAME F-Main.
        ASSIGN l-nrosem.
        {&OPEN-QUERY-br_pl-flg-s}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP-2 W-Win
ON CHOOSE OF Btn-UP-2 IN FRAME F-Main
DO:
    IF INPUT FRAME F-Main l-nromes + 1 <= 12 THEN DO:
        DISPLAY INPUT l-nromes + 1 @ l-nromes WITH FRAME F-Main.
        ASSIGN l-nromes.
        {&OPEN-QUERY-br_pl-flg-m}                
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP-3 W-Win
ON CHOOSE OF Btn-UP-3 IN FRAME F-Main
DO:
    IF AVAILABLE PL-PLAN THEN DO:
        FIND NEXT PL-PLAN WHERE PL-PLAN.TipPln = FALSE NO-ERROR.
        IF AVAILABLE PL-PLAN THEN l-codpln = PL-PLAN.CODPLN.
        DISPLAY l-codpln WITH FRAME F-Main.
    END.
    IF NOT AVAILABLE PL-PLAN THEN DO:
        FIND FIRST PL-PLAN WHERE PL-PLAN.TipPln = FALSE NO-ERROR.
        IF AVAILABLE PL-PLAN THEN l-codpln = PL-PLAN.CODPLN.
        DISPLAY l-codpln WITH FRAME F-Main.
    END.
    CASE p-tipo :
        WHEN 1 THEN {&OPEN-QUERY-br_pl-flg-s}
        WHEN 2 THEN {&OPEN-QUERY-br_pl-flg-m}
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP-4 W-Win
ON CHOOSE OF Btn-UP-4 IN FRAME F-Main
DO:
    IF AVAILABLE PL-PLAN THEN DO:
        FIND NEXT PL-PLAN WHERE PL-PLAN.TipPln = TRUE NO-ERROR.
        IF AVAILABLE PL-PLAN THEN l-codpln-m = PL-PLAN.CODPLN.
        DISPLAY l-codpln-m WITH FRAME F-Main.
    END.
    IF NOT AVAILABLE PL-PLAN THEN DO:
        FIND FIRST PL-PLAN WHERE PL-PLAN.TipPln = TRUE NO-ERROR.
        IF AVAILABLE PL-PLAN THEN l-codpln-m = PL-PLAN.CODPLN.
        DISPLAY l-codpln-m WITH FRAME F-Main.
    END.
    CASE p-tipo :
        WHEN 1 THEN {&OPEN-QUERY-br_pl-flg-s}
        WHEN 2 THEN {&OPEN-QUERY-br_pl-flg-m}
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-S
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-S W-Win
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


&Scoped-define SELF-NAME FILL-IN-PatPer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-PatPer W-Win
ON LEAVE OF FILL-IN-PatPer IN FRAME F-Main /* Filtrar por apellido paterno */
DO:
  ASSIGN {&self-name}.
  {&OPEN-QUERY-br_pl-flg-m}
  {&OPEN-QUERY-br_pl-flg-s}
  {&OPEN-QUERY-br_pl-pers}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-seleccion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-seleccion W-Win
ON VALUE-CHANGED OF R-seleccion IN FRAME F-Main
DO:
    CASE INPUT R-seleccion:
    WHEN 1 THEN
        ASSIGN
            Br_pl-flg-m:SENSITIVE = FALSE
            Br_pl-flg-s:SENSITIVE = FALSE
            Br_pl-pers:SENSITIVE  = FALSE
            COMBO-S:SENSITIVE     = FALSE.
    WHEN 2 THEN DO:
        CASE p-tipo :
            WHEN 1 THEN Br_pl-flg-s:SENSITIVE = TRUE.
            WHEN 2 THEN Br_pl-flg-m:SENSITIVE = TRUE.
            WHEN 3 THEN Br_pl-pers:SENSITIVE = TRUE.
        END CASE .
        COMBO-S:SENSITIVE = FALSE.
    END.
    WHEN 3 OR WHEN 4 THEN DO:
        ASSIGN
            COMBO-S:LIST-ITEMS    = ""
            Br_pl-flg-m:SENSITIVE = FALSE
            Br_pl-flg-s:SENSITIVE = FALSE
            Br_pl-pers:SENSITIVE  = FALSE
            COMBO-S:SENSITIVE     = TRUE.
        DISPLAY COMBO-S WITH FRAME F-Main.
    END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-tpoper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-tpoper W-Win
ON VALUE-CHANGED OF R-tpoper IN FRAME F-Main
DO:
    ASSIGN R-tpoper.
    RUN habilita( R-tpoper ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TGL-uni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TGL-uni W-Win
ON VALUE-CHANGED OF TGL-uni IN FRAME F-Main /* Unificado */
DO:
    ASSIGN TGL-uni.
    IF TGL-uni THEN DO:
        R-tpoper:SENSITIVE = TRUE.
        APPLY "VALUE-CHANGED" TO R-tpoper.
    END.
    ELSE DO:
        R-tpoper:SENSITIVE = FALSE.
        RUN habilita( p-tipo ).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_pl-flg-m
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-MENSUAL W-Win 
PROCEDURE ADD-MENSUAL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i AS INTEGER NO-UNDO.

    CASE R-seleccion:
    WHEN 1 THEN
        FOR EACH integral.PL-FLG-MES WHERE
            integral.PL-FLG-MES.codcia  = S-codcia AND
            integral.PL-FLG-MES.periodo = S-periodo AND
            integral.PL-FLG-MES.codpln  = L-codpln-m AND
            integral.PL-FLG-MES.nromes  = L-nromes:
            RUN pl-mensual.
        END.
    WHEN 2 THEN
        DO i = 1 TO br_pl-flg-m:NUM-SELECTED-ROWS IN FRAME F-Main:
            ASSIGN ok-status  = br_pl-flg-m:FETCH-SELECTED-ROW(i).
            IF ok-status THEN RUN pl-mensual.
        END.
    WHEN 3  THEN
        FOR EACH integral.PL-FLG-MES WHERE
            integral.PL-FLG-MES.codcia  = S-codcia AND
            integral.PL-FLG-MES.periodo = S-periodo AND
            integral.PL-FLG-MES.codpln  = L-codpln-m AND
            integral.PL-FLG-MES.nromes  = L-nromes AND
            integral.PL-FLG-MES.Seccion = Combo-s:
            RUN pl-mensual.
        END.
    WHEN 4 THEN
        FOR EACH integral.PL-FLG-MES WHERE
            integral.PL-FLG-MES.codcia   = S-codcia AND
            integral.PL-FLG-MES.periodo  = s-periodo AND
            integral.PL-FLG-MES.codpln   = L-codpln-m AND
            integral.PL-FLG-MES.nromes   = L-nromes AND
            integral.PL-FLG-MES.proyecto = Combo-s:
            RUN pl-mensual.
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-PFCIAS W-Win 
PROCEDURE ADD-PFCIAS :
/*
    Compa¤¡a
*/

    FIND integral.PF-CIAS WHERE integral.PF-CIAS.CodCia = S-CodCia NO-LOCK.
    CREATE DB-WORK.PF-CIAS.
    ASSIGN 
        db-work.PF-CIAS.CodCia  = integral.PF-CIAS.CodCia
        db-work.PF-CIAS.DirCia  = integral.PF-CIAS.DirCia
        db-work.PF-CIAS.NomCia  = integral.PF-CIAS.NomCia
        db-work.PF-CIAS.RegPat  = integral.PF-CIAS.RegPat
        db-work.PF-CIAS.RucCia  = integral.PF-CIAS.Ruccia
        db-work.PF-CIAS.TlflCia = integral.PF-CIAS.TlflCia.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-PL-AFP W-Win 
PROCEDURE ADD-PL-AFP :
/*
    AFP
*/

    FOR EACH integral.PL-AFPS NO-LOCK:
        CREATE DB-WORK.PL-AFPS.
        DB-WORK.PL-AFPS.codafp                  = integral.PL-AFPS.codafp.
        DB-WORK.PL-AFPS.Comision-Fija-AFP       = integral.PL-AFPS.Comision-Fija-AFP.
        DB-WORK.PL-AFPS.Comision-Porcentual-AFP = integral.PL-AFPS.Comision-Porcentual-AFP.
        DB-WORK.PL-AFPS.desafp                  = integral.PL-AFPS.desafp.
        DB-WORK.PL-AFPS.Fondo-AFP               = integral.PL-AFPS.Fondo-AFP.
        DB-WORK.PL-AFPS.Seguro-Invalidez-AFP    = integral.PL-AFPS.Seguro-Invalidez-AFP.
        DB-WORK.PL-AFPS.banco                   = integral.PL-AFPS.banco.
        DB-WORK.PL-AFPS.ctacte-afp              = integral.PL-AFPS.nroctacte-afp.
        DB-WORK.PL-AFPS.ctacte-fondo            = integral.PL-AFPS.nroctacte-fondo.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-PL-CFG W-Win 
PROCEDURE ADD-PL-CFG :
/*
    Configuración
*/

    DEFINE VARIABLE L-DesPln AS CHARACTER.

    CASE p-tipo:
    WHEN 1 THEN DO:
         L-desPln = PL-PLAN.DesPln.
         FIND PL-SEM WHERE
            PL-SEM.CODCIA = S-CODCIA AND
            PL-SEM.PERIODO = S-PERIODO NO-LOCK NO-ERROR.
    END.
    WHEN 2 THEN DO:
        L-desPln = PL-PLAN.DesPln.
    END.
    WHEN 3 THEN DO:
        L-CodPln = 0.
        L-DesPln = "".
    END.
    END CASE.   
    CREATE DB-WORK.PL-CFG.
    ASSIGN
        DB-WORK.PL-CFG.CodCia   = S-CodCia
        DB-WORK.PL-CFG.Periodo  = S-Periodo
        DB-WORK.PL-CFG.CodPln   = L-CodPln
        DB-WORK.PL-CFG.DesPln   = L-DesPln
        DB-WORK.PL-CFG.NROREG-TOT = s-nroreg-tot
        DB-WORK.PL-CFG.NROREG-ACT = s-nroreg-act.

    CASE p-tipo:
    WHEN 1 THEN DO:
        FIND PL-SEM WHERE
            PL-SEM.CODCIA  = S-CODCIA AND
            PL-SEM.PERIODO = S-PERIODO AND
            PL-SEM.NROSEM  = L-NROSEM NO-LOCK NO-ERROR.
        IF AVAILABLE PL-SEM THEN DO:
            DB-WORK.PL-CFG.NroMes      = PL-SEM.NroMes.
            DB-WORK.PL-CFG.NroSem      = PL-SEM.NroSem.
            DB-WORK.PL-CFG.Fecha-Desde = PL-SEM.FecIni.
            DB-WORK.PL-CFG.Fecha-Hasta = PL-SEM.FecFin.
        END.                
        /* PRIMERA SEMANA DEL MES */
        FIND FIRST integral.PL-SEM WHERE
            integral.PL-SEM.CodCia  = s-CodCia AND
            integral.PL-SEM.Periodo = s-Periodo AND
            integral.PL-SEM.NroMes  = DB-WORK.PL-CFG.NroMes NO-LOCK NO-ERROR.
        ASSIGN
            DB-WORK.PL-CFG.Fecha-Desde-1 = PL-SEM.FecIni
            DB-WORK.PL-CFG.NroSem-1      = PL-SEM.NroSem.
        /* ULTIMA SEMANA DEL MES */
        FIND LAST integral.PL-SEM WHERE
            integral.PL-SEM.CodCia  = s-CodCia AND
            integral.PL-SEM.Periodo = s-Periodo AND
            integral.PL-SEM.NroMes  = DB-WORK.PL-CFG.NroMes NO-LOCK NO-ERROR.
        ASSIGN
            DB-WORK.PL-CFG.Fecha-Hasta-1 = PL-SEM.FecFin
            DB-WORK.PL-CFG.NroSem-2      = PL-SEM.NroSem.
    END.
    WHEN 2 THEN DO:
        ASSIGN
            DB-WORK.PL-CFG.NroSem      = 0     
            DB-WORK.PL-CFG.NroMes      = L-NROMES 
            DB-WORK.PL-CFG.Fecha-Desde = DATE(L-NROMES, 1, S-PERIODO).
            IF L-NROMES = 12 THEN
                DB-WORK.PL-CFG.Fecha-Hasta =  DATE(12, 31, S-PERIODO).
            ELSE
                DB-WORK.PL-CFG.Fecha-Hasta =  DATE(L-NROMES + 1, 1 , S-PERIODO ) - 1.
    END.
    WHEN 3 THEN DO:

    END.
    END CASE.

    /* Nombre del Mes */

    RUN bin/_mes.p( DB-WORK.PL-CFG.NroMes, 2 , OUTPUT DB-WORK.PL-CFG.Nombre-Mes ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-SEMANAL W-Win 
PROCEDURE ADD-SEMANAL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i AS INTEGER NO-UNDO.

    CASE R-seleccion:
    WHEN 1 THEN 
        FOR EACH integral.PL-FLG-SEM WHERE
            integral.PL-FLG-SEM.codcia  = s-codcia AND
            integral.PL-FLG-SEM.periodo = s-periodo AND
            integral.PL-FLG-SEM.codpln  = l-codpln AND
            integral.PL-FLG-SEM.nrosem  = l-nrosem:
            RUN pl-semanal.
        END.
    WHEN 2 THEN 
        DO i = 1 TO br_pl-flg-s:NUM-SELECTED-ROWS IN FRAME F-Main:
            ASSIGN ok-status = br_pl-flg-s:FETCH-SELECTED-ROW(i).
            IF ok-status THEN RUN pl-semanal.
        END.
    WHEN 3 THEN
        FOR EACH integral.PL-FLG-SEM  WHERE
            integral.PL-FLG-SEM.codcia  = s-codcia AND
            integral.PL-FLG-SEM.periodo = s-periodo AND
            integral.PL-FLG-SEM.codpln  = l-codpln AND
            integral.PL-FLG-SEM.nrosem  = l-nrosem AND
            integral.PL-FLG-SEM.seccion = Combo-s:
            RUN pl-semanal.
        END.
    WHEN 4  THEN
        FOR EACH integral.PL-FLG-SEM WHERE
            integral.PL-FLG-SEM.codcia   = s-codcia AND
            integral.PL-FLG-SEM.periodo  = s-periodo AND
            integral.PL-FLG-SEM.codpln   = l-codpln AND
            integral.PL-FLG-SEM.nrosem   = l-nrosem AND
            integral.PL-FLG-SEM.proyecto = Combo-s:
            RUN pl-semanal.
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CREA-TEMP-DBWORK W-Win 
PROCEDURE CREA-TEMP-DBWORK :
DEFINE INPUT PARAMETER P-CODVAR AS INTEGER.
DEFINE INPUT PARAMETER P-VALCAL AS DECIMAL.

IF P-VALCAL = 0 THEN    RETURN.

IF P-CODVAR > 0 AND P-CODVAR < 51 THEN
   ASSIGN db-work.PL-PERS.V[P-CODVAR] = db-work.PL-PERS.V[P-CODVAR] + P-VALCAL
          db-work.PL-PERS.FLGEST      = TRUE.
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY L-CODPLN-m L-CODPLN R-tpoper TGL-uni L-NroSem L-NroMes FILL-IN-PatPer 
          R-seleccion COMBO-S 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 RECT-1 Btn-UP-4 Btn-UP-3 L-CODPLN-m L-CODPLN Btn-DOWN-4 
         Btn-DOWN-3 TGL-uni Btn-UP-2 Btn-UP L-NroSem L-NroMes Btn-DOWN 
         Btn-DOWN-2 FILL-IN-PatPer R-seleccion COMBO-S B-aceptar B-aceptar-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FECHAS_V W-Win 
PROCEDURE FECHAS_V :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER idx AS INTEGER.
    DEFINE VARIABLE meses-serv AS DECIMAL.
    DEFINE VARIABLE cstr       AS CHARACTER NO-UNDO.

    meses-serv = DB-WORK.PL-PERS.V[ idx ].

    IF meses-serv = 0 THEN RETURN.

    IF (meses-serv / 12) >= 1 THEN
        IF (meses-serv / 12) >= 2 THEN
            cstr = STRING(TRUNCATE(meses-serv / 12 , 0), ">>>9") + " A¤os ".
        ELSE cstr = "1 A¤o ".

    meses-serv = ((meses-serv / 12) - TRUNCATE(meses-serv / 12 , 0)) * 12.

    IF meses-serv >= 1 THEN
        IF meses-serv >= 2 THEN
            cstr = cstr + STRING(TRUNCATE(meses-serv, 0) , ">9") + " Meses ".
        ELSE cstr = cstr + "1 Mes ".

    meses-serv = INTEGER((meses-serv - TRUNCATE(meses-serv , 0)) * 30).

    IF meses-serv >= 1 THEN
        IF meses-serv >= 2 THEN
            cstr = cstr + STRING(meses-serv, ">9") + " Dias ".
        ELSE cstr = cstr + "1 Dia ".

    ASSIGN DB-WORK.PL-PERS.FECHA_V[ idx ] = cstr.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilita W-Win 
PROCEDURE habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER tipo AS INTEGER.

    DO WITH FRAME {&FRAME-NAME}:
        CASE tipo:
        WHEN 1 THEN DO:
            L-CODPLN:VISIBLE = TRUE.
            Btn-DOWN-3:VISIBLE = TRUE.
            Btn-DOWN-4:VISIBLE = FALSE.
            Btn-UP-3:VISIBLE = TRUE.
            Btn-UP-4:VISIBLE = FALSE.
            L-CODPLN-m:VISIBLE = FALSE.
            FIND FIRST PL-PLAN WHERE PL-PLAN.TipPln = FALSE NO-ERROR.
            IF AVAILABLE PL-PLAN THEN L-CODPLN = PL-PLAN.CODPLN.
            DISPLAY L-CODPLN WITH FRAME F-Main.
            L-NROSEM = s-nrosem.
            L-NROSEM:VISIBLE   = YES.
            DISPLAY L-NROSEM.
            L-NROMES:HIDDEN    = YES.
            Btn-DOWN:VISIBLE   = YES. 
            Btn-UP:VISIBLE     = YES.
            Btn-DOWN-2:VISIBLE = NO.
            Btn-UP-2:VISIBLE   = NO.
            br_pl-flg-s:SENSITIVE = YES.
            br_pl-flg-s:VISIBLE   = YES.
            br_pl-flg-m:SENSITIVE = NO.
            br_pl-flg-m:HIDDEN   = YES.
            {&OPEN-QUERY-br_pl-flg-s}
        END.
        WHEN 2 THEN DO:
            L-CODPLN:VISIBLE = FALSE.
            L-CODPLN-m:VISIBLE = TRUE.
            Btn-DOWN-3:VISIBLE = FALSE.
            Btn-DOWN-4:VISIBLE = TRUE.
            Btn-UP-3:VISIBLE = FALSE.
            Btn-UP-4:VISIBLE = TRUE.
            FIND FIRST PL-PLAN WHERE PL-PLAN.TipPln = TRUE NO-ERROR.
            IF AVAILABLE PL-PLAN THEN L-CODPLN-m = PL-PLAN.CODPLN.
            DISPLAY L-CODPLN-m WITH FRAME F-Main.
            L-NROSEM:HIDDEN   = YES.
            L-NROMES  = s-nromes.
            L-NROMES:VISIBLE  = YES.
            DISPLAY L-NROMES.
            Btn-DOWN:VISIBLE  = NO. 
            Btn-UP:VISIBLE    = NO.
            Btn-DOWN-2:VISIBLE = YES. 
            Btn-UP-2:VISIBLE   = YES.
            br_pl-flg-m:SENSITIVE = YES.
            br_pl-flg-m:VISIBLE   = YES.
            br_pl-flg-s:SENSITIVE = NO.
            br_pl-flg-s:HIDDEN   = YES.
            {&OPEN-QUERY-br_pl-flg-m}                 
        END.
        WHEN 3 THEN DO:
            L-NROSEM:HIDDEN      = YES.
            L-NROMES:HIDDEN      = YES.
            L-CODPLN:VISIBLE     = NO.
            Btn-DOWN:VISIBLE     = NO. 
            Btn-UP:VISIBLE       = NO.
            Btn-DOWN-2:VISIBLE   = NO. 
            Btn-UP-2:VISIBLE     = NO.
            Btn-DOWN-3:VISIBLE   = NO. 
            Btn-UP-3:VISIBLE     = NO.
            br_pl-pers:SENSITIVE = YES.
            br_pl-pers:VISIBLE   = YES.
            {&OPEN-QUERY-br_pl-pers}
        END.
        END CASE.
        APPLY "VALUE-CHANGED" TO R-seleccion.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPORTES_V W-Win 
PROCEDURE IMPORTES_V :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF DB-WORK.PL-PERS.V[1] <= 0 THEN RETURN.

    RUN bin/_numero.p(DB-WORK.PL-PERS.V[1], 2, 2, OUTPUT DB-WORK.PL-PERS.IMPORTE_V1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*
    Inicializando
*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    RUN habilita( p-tipo ).

    ASSIGN
        L-Nromes = S-Nromes
        L-NroSem = S-NroSem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PL-MENSUAL W-Win 
PROCEDURE PL-MENSUAL :
/*
    Planilla mensual
*/

    DEFINE VARIABLE x-nromes AS INTEGER.
    DEFINE VARIABLE x-valcal AS DECIMAL.
    
    /* CREANDO EL REGISTRO TEMPORAL DE PERSONAL */
    CREATE DB-WORK.PL-PERS.
    ASSIGN
        db-work.PL-PERS.codper       = integral.PL-FLG-MES.codper
        db-work.PL-PERS.codpln       = integral.PL-FLG-MES.codpln
        db-work.PL-PERS.cargos       = integral.PL-FLG-MES.cargos 
        db-work.PL-PERS.ccosto       = integral.PL-FLG-MES.ccosto 
        db-work.PL-PERS.Clase        = integral.PL-FLG-MES.Clase 
        db-work.PL-PERS.cnpago       = integral.PL-FLG-MES.cnpago 
        db-work.PL-PERS.nrodpt       = integral.PL-FLG-MES.nrodpt
        db-work.PL-PERS.codafp       = integral.PL-FLG-MES.codafp 
        db-work.PL-PERS.CodDiv       = integral.PL-FLG-MES.CodDiv 
        db-work.PL-PERS.Conyugue     = integral.PL-FLG-MES.Conyugue 
        db-work.PL-PERS.fecing       = integral.PL-FLG-MES.fecing 
        db-work.PL-PERS.finvac       = integral.PL-FLG-MES.finvac 
        db-work.PL-PERS.CTS          = integral.PL-FLG-MES.CTS 
        db-work.PL-PERS.nrodpt-cts   = integral.PL-FLG-MES.nrodpt-cts 
        db-work.PL-PERS.inivac       = integral.PL-FLG-MES.inivac 
        db-work.PL-PERS.Nro-de-Hijos = integral.PL-FLG-MES.Nro-de-Hijos 
        db-work.PL-PERS.nroafp       = integral.PL-FLG-MES.nroafp 
        db-work.PL-PERS.Proyecto     = integral.PL-FLG-MES.Proyecto 
        db-work.PL-PERS.seccion      = integral.PL-FLG-MES.seccion
        db-work.PL-PERS.SitAct       = integral.PL-FLG-MES.SitAct 
        db-work.PL-PERS.vcontr       = integral.PL-FLG-MES.vcontr.

    ASSIGN s-nroreg-tot = s-nroreg-tot + 1.
    IF db-work.PL-PERS.SitAct <> "Inactivo" THEN s-nroreg-act = s-nroreg-act + 1.

    FIND integral.PL-PROY WHERE
        integral.PL-PROY.PROYECTO = integral.PL-FLG-MES.PROYECTO NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-PROY THEN
        ASSIGN db-work.PL-PERS.RegPat = integral.PL-PROY.RegPat.

    FIND integral.PL-AFPS WHERE
        integral.PL-AFPS.CODAFP = integral.PL-FLG-MES.CODAFP NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-AFPS THEN
        ASSIGN db-work.PL-PERS.AFP = integral.PL-AFPS.DesAfp.

    FIND integral.PL-CTS WHERE
        integral.PL-CTS.CTS = integral.PL-FLG-MES.CTS NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-CTS THEN
        ASSIGN db-work.PL-PERS.MONEDA-CTS = integral.PL-CTS.MONEDA-CTS.

    FIND integral.PL-PERS WHERE
        integral.PL-PERS.codper = integral.PL-FLG-MES.codper NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-PERS THEN DO:
        db-work.PL-PERS.CodBar    = integral.PL-PERS.CodBar.
        db-work.PL-PERS.CodCia    = s-codcia.
        db-work.PL-PERS.ctipss    = integral.PL-PERS.ctipss.
        db-work.PL-PERS.dirper    = integral.PL-PERS.dirper.
        db-work.PL-PERS.distri    = integral.PL-PERS.distri.
        db-work.PL-PERS.ecivil    = integral.PL-PERS.ecivil.
        db-work.PL-PERS.fecnac    = integral.PL-PERS.fecnac.
        db-work.PL-PERS.lelect    = integral.PL-PERS.NroDocId.
        db-work.PL-PERS.lmilit    = integral.PL-PERS.lmilit.
        db-work.PL-PERS.localidad = integral.PL-PERS.localidad.
        db-work.PL-PERS.matper    = integral.PL-PERS.matper.
        db-work.PL-PERS.nacion    = integral.PL-PERS.nacion.
        db-work.PL-PERS.nomper    = integral.PL-PERS.nomper.
        db-work.PL-PERS.patper    = integral.PL-PERS.patper.
        db-work.PL-PERS.profesion = integral.PL-PERS.profesion.
        db-work.PL-PERS.provin    = integral.PL-PERS.provin.
        db-work.PL-PERS.sexper    = integral.PL-PERS.sexper.
        db-work.PL-PERS.telefo    = integral.PL-PERS.telefo.
        db-work.PL-PERS.titulo    = integral.PL-PERS.titulo.
        db-work.PL-PERS.TpoPer    = integral.PL-PERS.TpoPer.
    END.

    FILL-IN-msj = db-work.PL-PERS.codper + " " +
        db-work.PL-PERS.PATPER + " " +
        db-work.PL-PERS.MATPER + ", " +
        db-work.PL-PERS.NOMPER.

    DISPLAY FILL-IN-msj WITH FRAME F-mensaje.

    FOR EACH PL-VAR-RPT WHERE
        PL-VAR-RPT.CodRep = p-codrep AND
        PL-VAR-RPT.TpoRpt = 2 NO-LOCK:

        /* VARIABLES SEGUN CONFIGURACION */
        x-nromes = IF PL-VAR-RPT.NROMES = 0 THEN l-nromes ELSE PL-VAR-RPT.NROMES.

        IF x-nromes < 0 THEN x-nromes = l-nromes + x-nromes.

        IF PL-VAR-RPT.Periodo = 0 THEN p-periodo = s-periodo.
        ELSE
            IF PL-VAR-RPT.Periodo > 0 THEN p-periodo = PL-VAR-RPT.Periodo.
            ELSE p-periodo = s-periodo - PL-VAR-RPT.Periodo.

        ASSIGN
            p-mes-1 = x-nromes
            p-mes-2 = x-nromes.

        IF PL-VAR-RPT.Metodo = 3 THEN
            ASSIGN
                p-mes-1 = 1
                p-mes-2 = l-nromes.
                
        /* JALANDO DATOS */
        x-valcal = 0.
        FOR EACH integral.PL-MOV-MES WHERE
            integral.PL-MOV-MES.CODCIA  = s-codcia AND
            integral.PL-MOV-MES.PERIODO = p-periodo AND
            integral.PL-MOV-MES.codpln  = PL-FLG-MES.codpln AND
            integral.PL-MOV-MES.CODCAL  = PL-VAR-RPT.CodCal AND
            integral.PL-MOV-MES.codper  = PL-FLG-MES.codper AND
            integral.PL-MOV-MES.CODMOV  = PL-VAR-RPT.CodMov AND
            integral.PL-MOV-MES.NROMES  >= p-mes-1 AND
            integral.PL-MOV-MES.NROMES  <= p-mes-2 NO-LOCK:
            x-valcal = x-valcal + integral.PL-MOV-MES.VALCAL-MES.
        END.
        RUN CREA-TEMP-DBWORK ( PL-VAR-RPT.CodVAR, x-valcal ).
    END.
    RUN IMPORTES_V.
    RUN FECHAS_V( 2 ).
    RUN FECHAS_V( 3 ).
    RUN FECHAS_V( 4 ).
    RUN FECHAS_V( 5 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PL-SEMANAL W-Win 
PROCEDURE PL-SEMANAL :
/*
    Crea registros de semana
*/

    DEFINE VARIABLE x-nrosem AS INTEGER.
    DEFINE VARIABLE x-valcal AS DECIMAL.

    /* CREANDO EL REGISTRO TEMPORAL DE PERSONAL */
    FIND db-work.PL-PERS WHERE
        db-work.PL-PERS.codper = integral.PL-FLG-SEM.codper NO-LOCK NO-ERROR.
    IF AVAILABLE db-work.PL-PERS THEN RETURN.

    CREATE DB-WORK.PL-PERS.
    ASSIGN
        db-work.PL-PERS.codper       = integral.PL-FLG-SEM.codper
        db-work.PL-PERS.codpln       = integral.PL-FLG-SEM.codpln
        db-work.PL-PERS.cargos       = integral.PL-FLG-SEM.cargos 
        db-work.PL-PERS.ccosto       = integral.PL-FLG-SEM.ccosto 
        db-work.PL-PERS.Clase        = integral.PL-FLG-SEM.Clase 
        db-work.PL-PERS.cnpago       = integral.PL-FLG-SEM.cnpago 
        db-work.PL-PERS.nrodpt       = integral.PL-FLG-SEM.nrodpt
        db-work.PL-PERS.codafp       = integral.PL-FLG-SEM.codafp 
        db-work.PL-PERS.CodDiv       = integral.PL-FLG-SEM.CodDiv 
        db-work.PL-PERS.Conyugue     = integral.PL-FLG-SEM.Conyugue 
        db-work.PL-PERS.fecing       = integral.PL-FLG-SEM.fecing 
        db-work.PL-PERS.finvac       = integral.PL-FLG-SEM.finvac 
        db-work.PL-PERS.CTS          = integral.PL-FLG-SEM.CTS 
        db-work.PL-PERS.nrodpt-cts   = integral.PL-FLG-SEM.nrodpt-cts 
        db-work.PL-PERS.inivac       = integral.PL-FLG-SEM.inivac 
        db-work.PL-PERS.Nro-de-Hijos = integral.PL-FLG-SEM.Nro-de-Hijos 
        db-work.PL-PERS.nroafp       = integral.PL-FLG-SEM.nroafp 
        db-work.PL-PERS.Proyecto     = integral.PL-FLG-SEM.Proyecto 
        db-work.PL-PERS.seccion      = integral.PL-FLG-SEM.seccion
        db-work.PL-PERS.SitAct       = integral.PL-FLG-SEM.SitAct 
        db-work.PL-PERS.vcontr       = integral.PL-FLG-SEM.vcontr.

    ASSIGN s-nroreg-tot = s-nroreg-tot + 1.
    IF db-work.PL-PERS.SitAct <> "Inactivo" THEN s-nroreg-act = s-nroreg-act + 1.

    FIND integral.PL-PROY WHERE
        integral.PL-PROY.PROYECTO = integral.PL-FLG-SEM.proyecto NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-PROY THEN
        ASSIGN db-work.PL-PERS.RegPat = integral.PL-PROY.RegPat.

    FIND integral.PL-CTS WHERE
        integral.PL-CTS.CTS = integral.PL-FLG-SEM.CTS NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-CTS THEN
        ASSIGN db-work.PL-PERS.MONEDA-CTS = integral.PL-CTS.MONEDA-CTS.

    FIND integral.PL-AFPS WHERE
        integral.PL-AFPS.CODAFP = integral.PL-FLG-MES.CODAFP NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-AFPS THEN
        ASSIGN db-work.PL-PERS.AFP = integral.PL-AFPS.DesAfp.

    FIND integral.PL-PERS WHERE
        integral.PL-PERS.codper = integral.PL-FLG-SEM.codper NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-PERS THEN DO:
        db-work.PL-PERS.CodBar    = integral.PL-PERS.CodBar.
        db-work.PL-PERS.CodCia    = s-codcia.
        db-work.PL-PERS.ctipss    = integral.PL-PERS.ctipss.
        db-work.PL-PERS.dirper    = integral.PL-PERS.dirper.
        db-work.PL-PERS.distri    = integral.PL-PERS.distri.
        db-work.PL-PERS.ecivil    = integral.PL-PERS.ecivil.
        db-work.PL-PERS.fecnac    = integral.PL-PERS.fecnac.
        db-work.PL-PERS.lelect    = integral.PL-PERS.NroDocId.
        db-work.PL-PERS.lmilit    = integral.PL-PERS.lmilit.
        db-work.PL-PERS.localidad = integral.PL-PERS.localidad.
        db-work.PL-PERS.matper    = integral.PL-PERS.matper.
        db-work.PL-PERS.nacion    = integral.PL-PERS.nacion.
        db-work.PL-PERS.nomper    = integral.PL-PERS.nomper.
        db-work.PL-PERS.patper    = integral.PL-PERS.patper.
        db-work.PL-PERS.profesion = integral.PL-PERS.profesion.
        db-work.PL-PERS.provin    = integral.PL-PERS.provin.
        db-work.PL-PERS.sexper    = integral.PL-PERS.sexper.
        db-work.PL-PERS.telefo    = integral.PL-PERS.telefo.
        db-work.PL-PERS.titulo    = integral.PL-PERS.titulo.
        db-work.PL-PERS.TpoPer    = integral.PL-PERS.TpoPer.
    END.

    FILL-IN-msj = db-work.PL-PERS.codper + " " +
        db-work.PL-PERS.PATPER + " " +
        db-work.PL-PERS.MATPER + ", " +
        db-work.PL-PERS.NOMPER.

    DISPLAY FILL-IN-msj WITH FRAME F-mensaje.

    FOR EACH PL-VAR-RPT WHERE
        PL-VAR-RPT.CodRep = p-codrep AND
        PL-VAR-RPT.TpoRpt = 1:

        /* VARIABLES SEGUN CONFIGURACION */
        x-nrosem = IF PL-VAR-RPT.nrosem = 0 THEN L-nrosem ELSE PL-VAR-RPT.nrosem.

        IF PL-VAR-RPT.Periodo = 0 THEN p-periodo = s-periodo.
        ELSE
            IF PL-VAR-RPT.Periodo > 0 THEN p-periodo = PL-VAR-RPT.Periodo.
            ELSE p-periodo = s-periodo - PL-VAR-RPT.Periodo.

        ASSIGN
            p-sem-1 = x-nrosem
            p-sem-2 = x-nrosem.

        IF PL-VAR-RPT.Metodo = 3 THEN
            ASSIGN
                p-sem-1 = 1
                p-sem-2 = L-nrosem.

        /* BUSCAMOS LA SEMANA DE INICIO Y FIN DEL MES */
        IF PL-VAR-RPT.Metodo = 2 THEN DO:
            mes-actual = PL-VAR-RPT.nromes.
            IF mes-actual <= 0 THEN DO:
                FIND integral.PL-SEM WHERE
                    integral.PL-SEM.CodCia = s-codcia AND
                    integral.PL-SEM.Periodo = s-periodo AND
                    integral.PL-SEM.nrosem = L-nrosem NO-LOCK NO-ERROR.
                ASSIGN mes-actual = integral.PL-SEM.nromes + mes-actual.
            END.
            IF mes-actual < 1 THEN
                ASSIGN
                    p-periodo = ( p-periodo - 1 )
                    mes-actual = mes-actual + 12.

            /* PRIMERA SEMANA DEL MES */
            FIND FIRST integral.PL-SEM WHERE
                integral.PL-SEM.CodCia = s-codcia AND
                integral.PL-SEM.Periodo = s-periodo AND
                integral.PL-SEM.nromes = mes-actual
                NO-LOCK NO-ERROR.
            p-sem-1 = integral.PL-SEM.nrosem.

            /* ULTIMA SEMANA DEL MES */
            FIND LAST integral.PL-SEM WHERE
                integral.PL-SEM.CodCia = s-codcia AND
                integral.PL-SEM.Periodo = s-periodo AND
                integral.PL-SEM.nromes = mes-actual
                NO-LOCK NO-ERROR.
            p-sem-2 = integral.PL-SEM.nrosem.
        END.

        /* JALANDO DATOS */  
        x-valcal = 0.
        FOR EACH integral.PL-MOV-SEM WHERE
            integral.PL-MOV-SEM.CODCIA  = s-codcia AND
            integral.PL-MOV-SEM.PERIODO = p-periodo AND
            integral.PL-MOV-SEM.CODPLN  = PL-FLG-SEM.CodPLN AND
            integral.PL-MOV-SEM.CODCAL  = PL-VAR-RPT.CodCal AND
            integral.PL-MOV-SEM.codper  = PL-FLG-SEM.codper AND
            integral.PL-MOV-SEM.CODMOV  = PL-VAR-RPT.CodMov AND
            integral.PL-MOV-SEM.nrosem  >= p-sem-1 AND
            integral.PL-MOV-SEM.nrosem  <= p-sem-2:
            x-valcal = x-valcal + integral.PL-MOV-SEM.VALCAL-SEM.
        END.
        RUN CREA-TEMP-DBWORK ( PL-VAR-RPT.CodVAR, x-valcal ).
    END.
    RUN IMPORTES_V.
    RUN FECHAS_V( 2 ).
    RUN FECHAS_V( 3 ).
    RUN FECHAS_V( 4 ).
    RUN FECHAS_V( 5 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA W-Win 
PROCEDURE PROCESA :
/*
    Porcesa
*/
    IF TGL-uni = TRUE THEN DO:
        RUN add-semanal.
        RUN add-mensual.
    END.
    ELSE DO:
        CASE p-tipo:
            WHEN 1 THEN RUN add-semanal.
            WHEN 2 THEN RUN add-mensual.
        END CASE.
    END.

    FILL-IN-msj = "... Archivos de Configuraci¢n ...".
    DISPLAY FILL-IN-msj WITH FRAME F-mensaje.
    RUN add-pl-cfg.
    RUN add-pfcias.
    RUN add-pl-afp.
    HIDE FRAME F-mensaje.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-PERS"}
  {src/adm/template/snd-list.i "INTEGRAL.PL-FLG-SEM"}
  {src/adm/template/snd-list.i "integral.PL-FLG-MES"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

