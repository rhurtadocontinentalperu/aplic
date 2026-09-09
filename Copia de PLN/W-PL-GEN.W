&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
CREATE WIDGET-POOL.



&IF "{&NEW}" = "" &THEN 
    DEFINE INPUT  PARAMETER P-CODREP AS CHAR.
    DEFINE INPUT  PARAMETER P-ACCION AS INTEGER.
    DEFINE INPUT  PARAMETER P-TIPO   AS INTEGER.
&ELSE 
    DEFINE VAR  P-CODREP AS CHAR    INIT "XXXXXXXX".
    DEFINE VAR  P-ACCION AS INTEGER INIT 1.
    DEFINE VAR  P-TIPO   AS INTEGER INIT 2.
&ENDIF 





/* Local Variable Definitions ---                                       */

def var cmb-lista as char.
def  SHARED VAR s-periodo as integer.
def  SHARED VAR s-nromes  as integer.
def  SHARED VAR s-nrosem  as integer.

{bin/s-global.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_pl-flg-m

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-FLG-MES integral.PL-PERS ~
integral.PL-FLG-SEM

/* Definitions for BROWSE br_pl-flg-m                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-m 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_pl-flg-m
&Scoped-define OPEN-QUERY-br_pl-flg-m OPEN QUERY br_pl-flg-m FOR EACH integral.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = L-CODPLN ~
 AND PL-FLG-MES.NroMes = L-NROMES ~
 AND PL-FLG-MES.SitAct <> "Inactivo" NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-MES NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES ~
integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES


/* Definitions for BROWSE br_pl-flg-s                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-s 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_pl-flg-s
&Scoped-define OPEN-QUERY-br_pl-flg-s OPEN QUERY br_pl-flg-s FOR EACH integral.PL-FLG-SEM ~
      WHERE      PL-FLG-MES.CodCia  = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln =  L-CODPLN ~
 AND PL-FLG-MES.NroMes = L-NROSEM ~
 AND PL-FLG-MES.SitAct <> "Inactivo" NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-SEM NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM ~
integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM


/* Definitions for BROWSE br_pl-pers                                    */
&Scoped-define FIELDS-IN-QUERY-br_pl-pers integral.PL-PERS.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-pers 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_pl-pers
&Scoped-define OPEN-QUERY-br_pl-pers OPEN QUERY br_pl-pers FOR EACH integral.PL-PERS NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_pl-pers integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-pers integral.PL-PERS


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS R-seleccion COMBO-S B-aceptar S-CodDiv ~
L-CODPLN L-NroSem L-NroMes Btn-UP-3 Btn-DOWN-3 Btn-UP Btn-UP-2 Btn-DOWN ~
Btn-DOWN-2 B-aceptar-2 
&Scoped-Define DISPLAYED-OBJECTS R-seleccion COMBO-S S-CodDiv L-CODPLN ~
L-NroSem L-NroMes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar 
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

DEFINE VARIABLE COMBO-S AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 20.43 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE L-CODPLN AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Planilla" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81 NO-UNDO.

DEFINE VARIABLE L-NroMes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .81 NO-UNDO.

DEFINE VARIABLE L-NroSem AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Semana" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .81 NO-UNDO.

DEFINE VARIABLE S-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Divisi¢n" 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .81 NO-UNDO.

DEFINE VARIABLE R-seleccion AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todo el personal", 1,
"Selectivo", 2,
"Por secci¢n", 3,
"Por proyecto", 4
     SIZE 14.14 BY 2.31 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_pl-flg-m FOR 
      integral.PL-FLG-MES, 
      integral.PL-PERS SCROLLING.

DEFINE QUERY br_pl-flg-s FOR 
      integral.PL-FLG-SEM, 
      integral.PL-PERS SCROLLING.

DEFINE QUERY br_pl-pers FOR 
      integral.PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_pl-flg-m
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-flg-m W-Win _STRUCTURED
  QUERY br_pl-flg-m NO-LOCK DISPLAY
      integral.PL-FLG-MES.codper
      integral.PL-PERS.patper
      integral.PL-PERS.matper
      integral.PL-PERS.nomper
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47 BY 6.73
         BGCOLOR 15 FGCOLOR 0 FONT 4.

DEFINE BROWSE br_pl-flg-s
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-flg-s W-Win _STRUCTURED
  QUERY br_pl-flg-s NO-LOCK DISPLAY
      integral.PL-FLG-SEM.codper
      integral.PL-PERS.patper
      integral.PL-PERS.matper
      integral.PL-PERS.nomper
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47 BY 6.73
         BGCOLOR 15 FGCOLOR 0 FONT 4.

DEFINE BROWSE br_pl-pers
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-pers W-Win _STRUCTURED
  QUERY br_pl-pers NO-LOCK DISPLAY
      integral.PL-PERS.codper
      integral.PL-PERS.patper
      integral.PL-PERS.matper
      integral.PL-PERS.nomper
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47 BY 6.73
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     R-seleccion AT ROW 4.73 COL 5 NO-LABEL
     COMBO-S AT ROW 7.08 COL 1.72 NO-LABEL
     B-aceptar AT ROW 8.08 COL 5.86
     S-CodDiv AT ROW 1.04 COL 8.14 COLON-ALIGNED
     L-CODPLN AT ROW 2.15 COL 12.14 COLON-ALIGNED
     L-NroSem AT ROW 3.42 COL 12.14 COLON-ALIGNED
     L-NroMes AT ROW 3.42 COL 12.14 COLON-ALIGNED
     Btn-UP-3 AT ROW 1.92 COL 18
     Btn-DOWN-3 AT ROW 2.54 COL 18
     Btn-UP AT ROW 3.15 COL 17.86
     Btn-UP-2 AT ROW 3.15 COL 18
     Btn-DOWN AT ROW 3.77 COL 17.86
     Btn-DOWN-2 AT ROW 3.77 COL 18
     br_pl-flg-s AT ROW 1.31 COL 22.86
     br_pl-pers AT ROW 1.31 COL 22.86
     br_pl-flg-m AT ROW 1.31 COL 22.86
     B-aceptar-2 AT ROW 8.08 COL 52.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
         FONT 4.

 

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
         TITLE              = "Generador de Reportes"
         HEIGHT             = 8.58
         WIDTH              = 69.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
/* SETTINGS FOR BROWSE br_pl-flg-m IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       br_pl-flg-m:HIDDEN  IN FRAME F-Main            = TRUE
       br_pl-flg-m:NUM-LOCKED-COLUMNS IN FRAME F-Main = 1.

/* SETTINGS FOR BROWSE br_pl-flg-s IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       br_pl-flg-s:HIDDEN  IN FRAME F-Main            = TRUE
       br_pl-flg-s:NUM-LOCKED-COLUMNS IN FRAME F-Main = 1.

/* SETTINGS FOR BROWSE br_pl-pers IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       br_pl-pers:HIDDEN  IN FRAME F-Main            = TRUE
       br_pl-pers:NUM-LOCKED-COLUMNS IN FRAME F-Main = 1.

/* SETTINGS FOR COMBO-BOX COMBO-S IN FRAME F-Main
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-m
/* Query rebuild information for BROWSE br_pl-flg-m
     _TblList          = "integral.PL-FLG-MES,integral.PL-PERS OF integral.PL-FLG-MES"
     _Options          = "NO-LOCK"
     _Where[1]         = "PL-FLG-MES.CodCia = s-CodCia
 AND PL-FLG-MES.Periodo = s-Periodo
 AND PL-FLG-MES.codpln = L-CODPLN
 AND PL-FLG-MES.NroMes = L-NROMES
 AND PL-FLG-MES.SitAct <> ""Inactivo"""
     _FldNameList[1]   = integral.PL-FLG-MES.codper
     _FldNameList[2]   = integral.PL-PERS.patper
     _FldNameList[3]   = integral.PL-PERS.matper
     _FldNameList[4]   = integral.PL-PERS.nomper
     _Query            is NOT OPENED
*/  /* BROWSE br_pl-flg-m */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-s
/* Query rebuild information for BROWSE br_pl-flg-s
     _TblList          = "integral.PL-FLG-SEM,integral.PL-PERS OF integral.PL-FLG-SEM"
     _Options          = "NO-LOCK"
     _Where[1]         = "     PL-FLG-MES.CodCia  = s-CodCia
 AND PL-FLG-MES.Periodo = s-Periodo
 AND PL-FLG-MES.codpln =  L-CODPLN
 AND PL-FLG-MES.NroMes = L-NROSEM
 AND PL-FLG-MES.SitAct <> ""Inactivo"""
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
     _FldNameList[1]   = integral.PL-PERS.codper
     _FldNameList[2]   = integral.PL-PERS.patper
     _FldNameList[3]   = integral.PL-PERS.matper
     _FldNameList[4]   = integral.PL-PERS.nomper
     _Query            is NOT OPENED
*/  /* BROWSE br_pl-pers */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Generador de Reportes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generador de Reportes */
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
    ASSIGN R-seleccion COMBO-S.
    RUN proc_calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_pl-flg-m
&Scoped-define SELF-NAME br_pl-flg-m
&Scoped-define BROWSE-NAME br_pl-flg-s
&Scoped-define SELF-NAME br_pl-flg-s
&Scoped-define BROWSE-NAME br_pl-pers
&Scoped-define SELF-NAME br_pl-pers
&Scoped-define SELF-NAME Btn-DOWN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN W-Win
ON CHOOSE OF Btn-DOWN IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main L-NROSEM - 1 >= 1 THEN DO:
    DISPLAY INPUT L-NROSEM - 1 @ L-NROSEM WITH FRAME F-Main.
    ASSIGN L-NROSEM.
    {&OPEN-QUERY-br_pl-flg-s}                
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN-2 W-Win
ON CHOOSE OF Btn-DOWN-2 IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main L-NROMES - 1 >= 1 THEN DO:
    DISPLAY INPUT L-NROMES - 1 @ L-NROMES WITH FRAME F-Main.
    ASSIGN L-NROMES.
    {&OPEN-QUERY-br_pl-flg-m}                
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN-3 W-Win
ON CHOOSE OF Btn-DOWN-3 IN FRAME F-Main
DO:
  IF AVAIL PL-PLAN THEN DO:
     FIND PREV PL-PLAN.
     DISPLAY PL-PLAN.CODPLN @ L-CODPLN WITH FRAME F-Main.
     ASSIGN L-CODPLN.
  END.  
  ELSE DO:
     FIND FIRST PL-PLAN.
     DISPLAY PL-PLAN.CODPLN @ L-CODPLN WITH FRAME F-Main.
     ASSIGN L-CODPLN.
  END.
  CASE P-TIPO :
       WHEN 1 THEN     {&OPEN-QUERY-br_pl-flg-s}  
       WHEN 2 THEN     {&OPEN-QUERY-br_pl-flg-m}  
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP W-Win
ON CHOOSE OF Btn-UP IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main L-NROSEM + 1 <= 53 THEN DO:
    DISPLAY INPUT L-NROSEM + 1 @ L-NROSEM WITH FRAME F-Main.
    ASSIGN L-NROSEM.
    {&OPEN-QUERY-br_pl-flg-s}                
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP-2 W-Win
ON CHOOSE OF Btn-UP-2 IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main L-NROMES + 1 <= 53 THEN DO:
    DISPLAY INPUT L-NROMES + 1 @ L-NROMES WITH FRAME F-Main.
    ASSIGN L-NROMES.
    {&OPEN-QUERY-br_pl-flg-m}                
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP-3 W-Win
ON CHOOSE OF Btn-UP-3 IN FRAME F-Main
DO:

  IF AVAIL PL-PLAN THEN DO:
     FIND NEXT PL-PLAN.
     DISPLAY PL-PLAN.CODPLN @ L-CODPLN WITH FRAME F-Main.
     ASSIGN L-CODPLN.
  END.  
  ELSE DO:
     FIND FIRST PL-PLAN.
     DISPLAY PL-PLAN.CODPLN @ L-CODPLN WITH FRAME F-Main.
     ASSIGN L-CODPLN.
  END.
  CASE P-TIPO :
       WHEN 1 THEN     {&OPEN-QUERY-br_pl-flg-s}  
       WHEN 2 THEN     {&OPEN-QUERY-br_pl-flg-m}  
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
            CASE P-TIPO :
               WHEN 1 THEN Br_pl-flg-s:SENSITIVE = TRUE.
               WHEN 2 THEN Br_pl-flg-m:SENSITIVE = TRUE.
               WHEN 3 THEN Br_pl-pers:SENSITIVE = TRUE.
            END CASE .
            COMBO-S:SENSITIVE     = FALSE.
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


&Scoped-define SELF-NAME S-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S-CodDiv W-Win
ON F8 OF S-CodDiv IN FRAME F-Main /* Divisi¢n */
OR "MOUSE-SELECT-DBLCLICK":U OF S-CODDIV DO:
   DO WITH FRAME {&FRAME-NAME} :
      DEF VAR X-ROWID AS ROWID.
      X-ROWID = ?.
      RUN ADM/H-DIVI01.W(S-CODCIA, OUTPUT X-ROWID).
      IF X-ROWID <> ? THEN DO:
         FIND GN-DIVI WHERE ROWID(GN-DIVI) = X-ROWID NO-LOCK NO-ERROR.
         SELF:SCREEN-VALUE = GN-DIVI.CODDIV.
      END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY R-seleccion COMBO-S S-CodDiv L-CODPLN L-NroSem L-NroMes 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE R-seleccion COMBO-S B-aceptar S-CodDiv L-CODPLN L-NroSem L-NroMes 
         Btn-UP-3 Btn-DOWN-3 Btn-UP Btn-UP-2 Btn-DOWN Btn-DOWN-2 B-aceptar-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  FIND FIRST PL-PLAN NO-LOCK NO-ERROR.
  IF AVAIL PL-PLAN THEN L-CODPLN = PL-PLAN.CODPLN.
  
  DO WITH FRAME {&FRAME-NAME} :
  DISPLAY L-CODPLN.
  CASE P-TIPO :
       WHEN 1 THEN DO:
              L-NROSEM = S-NROSEM.
              L-NROSEM:VISIBLE   = YES.
              DISPLAY L-NROSEM.
              
              L-NROMES:HIDDEN    = YES.
              
              Btn-DOWN:VISIBLE   = YES. 
              Btn-UP:VISIBLE     = YES.
              Btn-DOWN-2:VISIBLE = NO. 
              Btn-UP-2:VISIBLE   = NO.
              br_pl-flg-s:SENSITIVE = YES.
              br_pl-flg-s:VISIBLE   = YES.
              {&OPEN-QUERY-br_pl-flg-s}              
       END.
       WHEN 2 THEN DO:
              L-NROSEM:HIDDEN   = YES.
              L-NROMES  = S-NROMES.
              L-NROMES:VISIBLE  = YES.
              DISPLAY L-NROMES.
              Btn-DOWN:VISIBLE  = NO. 
              Btn-UP:VISIBLE    = NO.
              Btn-DOWN-2:VISIBLE = YES. 
              Btn-UP-2:VISIBLE   = YES.
              br_pl-flg-m:SENSITIVE = YES.
              br_pl-flg-m:VISIBLE   = YES.
              {&OPEN-QUERY-br_pl-flg-m}                 
           
       END.
       WHEN 3 THEN DO:
              L-NROSEM:HIDDEN   = YES.
              L-NROMES:HIDDEN    = YES.
              L-CODPLN:VISIBLE  = NO.
              Btn-DOWN:VISIBLE  = NO. 
              Btn-UP:VISIBLE    = NO.
              Btn-DOWN-2:VISIBLE = NO. 
              Btn-UP-2:VISIBLE   = NO.
              Btn-DOWN-3:VISIBLE = NO. 
              Btn-UP-3:VISIBLE   = NO.

           
              
              br_pl-pers:SENSITIVE = YES.
              br_pl-pers:VISIBLE   = YES.
              {&OPEN-QUERY-br_pl-pers}                 

             
       END.
       
       
       
  END CASE.
  END.
  ASSIGN L-Nromes = S-Nromes
         L-NroSem = S-NroSem.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-FLG-SEM"}
  {src/adm/template/snd-list.i "integral.PL-PERS"}
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


