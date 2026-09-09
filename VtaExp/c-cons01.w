&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

DEF VAR x-NomPer AS CHAR FORMAT 'x(20)' NO-UNDO.
DEF VAR x-Estado AS CHAR FORMAT 'x(10)' NO-UNDO.
DEF VAR x-Situacion AS CHAR FORMAT 'x(10)' NO-UNDO.
DEF VAR x-NroItems AS INT NO-UNDO.


DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'PED' NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi PL-PERS almtabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 FacCPedi.FchPed FacCPedi.NroPed ~
FacCPedi.NomCli almtabla.Nombre _NomPer() @ x-NomPer FacCPedi.FchChq ~
FacCPedi.HorChq _Estado() @ x-Estado _Situacion() @ x-Situacion ~
_NroItems() @ x-NroItems 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.CodDoc = s-coddoc ~
 AND FacCPedi.CodDiv = s-coddiv ~
AND FacCPedi.CodAlm = s-codalm ~
 AND FacCPedi.FchPed >= x-FchPed-1 ~
 AND FacCPedi.FchPed <= x-FchPed-2 ~
 AND (x-NomCli = '' OR INDEX(FacCPedi.NomCli, x-NomCli) > 0) ~
 AND (x-FlgEst = "" OR FacCPedi.FlgEst BEGINS x-FlgEst) ~
 AND (x-FlgSit = "" OR FacCPedi.FlgSit BEGINS x-FlgSit) ~
 AND (x-FchChq = ? OR FacCPedi.FchChq = x-FchChq) ~
 AND (x-UsrChq = "" OR FacCPedi.UsrChq BEGINS x-UsrChq) NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.CodCia = FacCPedi.CodCia ~
  AND PL-PERS.codper = FacCPedi.UsrChq OUTER-JOIN NO-LOCK, ~
      EACH almtabla WHERE almtabla.Codigo = FacCPedi.CodPos ~
      AND almtabla.Tabla = "CP" OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.CodDoc = s-coddoc ~
 AND FacCPedi.CodDiv = s-coddiv ~
AND FacCPedi.CodAlm = s-codalm ~
 AND FacCPedi.FchPed >= x-FchPed-1 ~
 AND FacCPedi.FchPed <= x-FchPed-2 ~
 AND (x-NomCli = '' OR INDEX(FacCPedi.NomCli, x-NomCli) > 0) ~
 AND (x-FlgEst = "" OR FacCPedi.FlgEst BEGINS x-FlgEst) ~
 AND (x-FlgSit = "" OR FacCPedi.FlgSit BEGINS x-FlgSit) ~
 AND (x-FchChq = ? OR FacCPedi.FchChq = x-FchChq) ~
 AND (x-UsrChq = "" OR FacCPedi.UsrChq BEGINS x-UsrChq) NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.CodCia = FacCPedi.CodCia ~
  AND PL-PERS.codper = FacCPedi.UsrChq OUTER-JOIN NO-LOCK, ~
      EACH almtabla WHERE almtabla.Codigo = FacCPedi.CodPos ~
      AND almtabla.Tabla = "CP" OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 FacCPedi PL-PERS almtabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 PL-PERS
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 almtabla


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-FchPed-1 x-FchPed-2 Btn_Excel x-NomCli ~
x-FlgEst x-FlgSit x-FchChq Btn_Done x-UsrChq BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS x-FchPed-1 x-FchPed-2 x-NomCli x-FlgEst ~
x-FlgSit x-FchChq x-UsrChq x-NomChq 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _Estado wWin 
FUNCTION _Estado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _NomPer wWin 
FUNCTION _NomPer RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _NroItems wWin 
FUNCTION _NroItems RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _Situacion wWin 
FUNCTION _Situacion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 11 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 11 BY 1.54 TOOLTIP "Salida a Excel".

DEFINE VARIABLE x-FchChq AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha de Chequeo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchPed-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Emitidos desde el" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchPed-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta el" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomChq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombres que contengan" 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE x-UsrChq AS CHARACTER FORMAT "X(6)":U 
     LABEL "Chequeador" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-FlgEst AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", "",
"Atendido", "C",
"Pendiente", "P",
"Anulado", "A",
"Facturado", "F",
"No Aprobado", "X"
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE x-FlgSit AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", " ",
"Por Chequear", "X",
"Chequeado", "P"
     SIZE 33 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      FacCPedi, 
      PL-PERS, 
      almtabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      FacCPedi.FchPed COLUMN-LABEL "Fecha" FORMAT "99/99/99":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(9)":U WIDTH 8
      FacCPedi.NomCli FORMAT "x(30)":U WIDTH 30
      almtabla.Nombre COLUMN-LABEL "Postal" FORMAT "x(25)":U
      _NomPer() @ x-NomPer COLUMN-LABEL "Chequeador" FORMAT "x(30)":U
            WIDTH 20
      FacCPedi.FchChq COLUMN-LABEL "Fecha" FORMAT "99/99/99":U
      FacCPedi.HorChq COLUMN-LABEL "Hora" FORMAT "x(5)":U WIDTH 5
      _Estado() @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(10)":U
            WIDTH 10
      _Situacion() @ x-Situacion COLUMN-LABEL "Situacion" FORMAT "x(15)":U
            WIDTH 15
      _NroItems() @ x-NroItems COLUMN-LABEL "Nro. Items" FORMAT ">>>,>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 134 BY 14.27
         FONT 4 ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     x-FchPed-1 AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
     x-FchPed-2 AT ROW 1.27 COL 39 COLON-ALIGNED WIDGET-ID 4
     Btn_Excel AT ROW 1.81 COL 90 WIDGET-ID 32
     x-NomCli AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 6
     x-FlgEst AT ROW 2.88 COL 21 NO-LABEL WIDGET-ID 14
     x-FlgSit AT ROW 3.69 COL 21 NO-LABEL WIDGET-ID 10
     x-FchChq AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 26
     Btn_Done AT ROW 4.5 COL 90 WIDGET-ID 34
     x-UsrChq AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 28
     x-NomChq AT ROW 5.31 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     BROWSE-2 AT ROW 6.38 COL 2 WIDGET-ID 200
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.15 COL 15 WIDGET-ID 22
     "Situacion:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.96 COL 13 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 141 BY 20.23
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSULTA DE PEDIDOS"
         HEIGHT             = 20
         WIDTH              = 135.86
         MAX-HEIGHT         = 32.81
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.81
         VIRTUAL-WIDTH      = 205.72
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 x-NomChq fMain */
/* SETTINGS FOR FILL-IN x-NomChq IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.PL-PERS WHERE INTEGRAL.FacCPedi ...,INTEGRAL.almtabla WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", OUTER, OUTER"
     _Where[1]         = "FacCPedi.CodCia = s-codcia
 AND FacCPedi.CodDoc = s-coddoc
 AND FacCPedi.CodDiv = s-coddiv
AND FacCPedi.CodAlm = s-codalm
 AND FacCPedi.FchPed >= x-FchPed-1
 AND FacCPedi.FchPed <= x-FchPed-2
 AND (x-NomCli = '' OR INDEX(FacCPedi.NomCli, x-NomCli) > 0)
 AND (x-FlgEst = """" OR FacCPedi.FlgEst BEGINS x-FlgEst)
 AND (x-FlgSit = """" OR FacCPedi.FlgSit BEGINS x-FlgSit)
 AND (x-FchChq = ? OR FacCPedi.FchChq = x-FchChq)
 AND (x-UsrChq = """" OR FacCPedi.UsrChq BEGINS x-UsrChq)"
     _JoinCode[2]      = "PL-PERS.CodCia = FacCPedi.CodCia
  AND PL-PERS.codper = FacCPedi.UsrChq"
     _JoinCode[3]      = "almtabla.Codigo = FacCPedi.CodPos"
     _Where[3]         = "almtabla.Tabla = ""CP"""
     _FldNameList[1]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" ? "x(30)" "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.almtabla.Nombre
"almtabla.Nombre" "Postal" "x(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"_NomPer() @ x-NomPer" "Chequeador" "x(30)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.FchChq
"FacCPedi.FchChq" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.HorChq
"FacCPedi.HorChq" "Hora" "x(5)" "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"_Estado() @ x-Estado" "Estado" "x(10)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"_Situacion() @ x-Situacion" "Situacion" "x(15)" ? ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"_NroItems() @ x-NroItems" "Nro. Items" ">>>,>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* CONSULTA DE PEDIDOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* CONSULTA DE PEDIDOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done wWin
ON CHOOSE OF Btn_Done IN FRAME fMain /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel wWin
ON CHOOSE OF Btn_Excel IN FRAME fMain /* Excel */
DO:
    RUN Asigna-Variables.
    RUN Excel. /*RUN Imprime.*/
    RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchChq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchChq wWin
ON LEAVE OF x-FchChq IN FRAME fMain /* Fecha de Chequeo */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchPed-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchPed-1 wWin
ON LEAVE OF x-FchPed-1 IN FRAME fMain /* Emitidos desde el */
DO:
  ASSIGN {&self-name}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchPed-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchPed-2 wWin
ON LEAVE OF x-FchPed-2 IN FRAME fMain /* hasta el */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FlgEst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FlgEst wWin
ON VALUE-CHANGED OF x-FlgEst IN FRAME fMain
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FlgSit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FlgSit wWin
ON VALUE-CHANGED OF x-FlgSit IN FRAME fMain
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NomCli wWin
ON LEAVE OF x-NomCli IN FRAME fMain /* Nombres que contengan */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-UsrChq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-UsrChq wWin
ON LEAVE OF x-UsrChq IN FRAME fMain /* Chequeador */
DO:
    x-NomChq:SCREEN-VALUE = ''.
    ASSIGN {&self-name}.
    FIND pl-pers WHERE pl-pers.codcia = s-codcia
        AND pl-pers.codper = x-usrchq
        NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN x-NomChq:SCReen-value = TRIM(pl-pers.patper) + ' ' +
                                                        TRIM(pl-pers.matper) + ', ' +
                                                        pl-pers.nomper.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-UsrChq wWin
ON LEFT-MOUSE-DBLCLICK OF x-UsrChq IN FRAME fMain /* Chequeador */
OR f8 OF x-UsrChq
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN pln/c-plnper.
    IF output-var-1 <> ? 
    THEN ASSIGN
              SELF:SCREEN-VALUE = output-var-2
              x-NomChq:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables wWin 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN x-FchPed-1 x-FchPed-2 x-NomCli x-FlgEst x-FlgSit x-FchChq x-UsrChq.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY x-FchPed-1 x-FchPed-2 x-NomCli x-FlgEst x-FlgSit x-FchChq x-UsrChq 
          x-NomChq 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE x-FchPed-1 x-FchPed-2 Btn_Excel x-NomCli x-FlgEst x-FlgSit x-FchChq 
         Btn_Done x-UsrChq BROWSE-2 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel wWin 
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

DEFINE BUFFER b-FacCPedi FOR FacCPedi.
DEFINE BUFFER b-AlmTabla FOR AlmTabla.
DEFINE BUFFER b-FacDPedi FOR FacDPedi.
DEFINE BUFFER b-PL-PERS FOR PL-PERS.

DEF VAR f-NomPer AS CHAR NO-UNDO.
DEF VAR f-NomPos AS CHAR NO-UNDO.
DEF VAR f-Estado AS CHAR NO-UNDO.
DEF VAR f-Situacion AS CHAR NO-UNDO.
DEF VAR fNroItems AS INT NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:COLUMNS("A"):ColumnWidth = 10.
chWorkSheet:COLUMNS("B"):ColumnWidth = 10.
chWorkSheet:COLUMNS("C"):ColumnWidth = 40.
chWorkSheet:COLUMNS("D"):ColumnWidth = 30.
chWorkSheet:COLUMNS("E"):ColumnWidth = 40.
chWorkSheet:COLUMNS("F"):ColumnWidth = 12.
chWorkSheet:COLUMNS("G"):ColumnWidth = 6.
chWorkSheet:COLUMNS("H"):ColumnWidth = 15.
chWorkSheet:COLUMNS("I"):ColumnWidth = 15.
chWorkSheet:COLUMNS("J"):ColumnWidth = 4.

chWorkSheet:Range("A1: J2"):FONT:Bold = TRUE.
chWorkSheet:Range("A1"):VALUE =
    "CONSULTA DE PEDIDOS" +
    " DEL " + STRING(x-FchPed-1) + " AL " + STRING(x-FchPed-2).
chWorkSheet:Range("A2"):VALUE = "Fch Pedido".
chWorkSheet:Range("B2"):VALUE = "Número".
chWorkSheet:Range("C2"):VALUE = "Nombre Cliente".
chWorkSheet:Range("D2"):VALUE = "Postal".
chWorkSheet:Range("E2"):VALUE = "Chequeador".
chWorkSheet:Range("F2"):VALUE = "Fch Chequeo".
chWorkSheet:Range("G2"):VALUE = "Hora".
chWorkSheet:Range("H2"):VALUE = "Estado".
chWorkSheet:Range("I2"):VALUE = "Situación".
chWorkSheet:Range("J2"):VALUE = "Nro Items".

chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:COLUMNS("G"):NumberFormat = "@".
chWorkSheet:COLUMNS("J"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).

loopREP:
FOR EACH b-FacCPedi WHERE b-FacCPedi.CodCia = s-codcia
    AND b-FacCPedi.CodDoc = s-coddoc
    AND b-FacCPedi.CodDiv = s-coddiv
    AND b-FacCPedi.FchPed >= x-FchPed-1
    AND b-FacCPedi.FchPed <= x-FchPed-2
    AND (x-NomCli = '' OR INDEX(b-FacCPedi.NomCli, x-NomCli) > 0)
    AND b-FacCPedi.FlgEst BEGINS x-FlgEst
    AND b-FacCPedi.FlgSit BEGINS x-FlgSit
    AND (x-FchChq = ? OR b-FacCPedi.FchChq = x-FchChq)
    AND b-FacCPedi.UsrChq BEGINS x-UsrChq NO-LOCK: 
    fNroItems = 0.
    FOR EACH b-facdpedi OF b-faccpedi NO-LOCK:
            fNroItems = fNroItems + 1.
    END.

    FIND b-PL-PERS WHERE b-PL-PERS.codper = b-FacCPedi.UsrChq NO-LOCK NO-ERROR.
    IF AVAILABLE b-PL-PERS THEN DO:
        f-NomPer = TRIM(b-Pl-pers.patper) + ' ' + TRIM(b-Pl-pers.matper) + ' ' + b-Pl-pers.nomper.
    END.
    ELSE f-NomPer = "".   

    FIND b-almtabla WHERE
        b-almtabla.Codigo = b-FacCPedi.CodPos AND
        b-almtabla.Tabla = "CP" NO-LOCK NO-ERROR.
    IF AVAILABLE b-almtabla THEN DO:
        f-NomPos = TRIM(b-AlmTabla.Nombre).
    END.
    ELSE f-NomPos = "". 

        CASE b-FaccPedi.FlgEst:
            WHEN "A" THEN f-Estado = "ANULADO".
            WHEN "C" THEN f-Estado = "ATENDIDO".
            WHEN "G" THEN f-Estado = "GENERADO".
            WHEN "P" THEN f-Estado = "PENDIENTE".
            WHEN "V" THEN f-Estado = "VENCIDO".
            WHEN "F" THEN f-Estado = "FACTURADO".
            WHEN "X" THEN f-Estado = "NO APROBADO".
            WHEN "R" THEN f-Estado = "RECHAZADO".
        END CASE.
        IF b-FaccPedi.FchVen < TODAY AND b-FacCPedi.FlgEst = 'P'
        THEN f-Estado = "VENCIDO".
        CASE b-FaccPedi.FlgSit:
            WHEN "X" THEN f-Situacion = "POR CHEQUEAR".
            WHEN "P" THEN f-Situacion = "CHEQUEADO".
            WHEN ""  THEN f-Situacion = "".
        END CASE.

        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = b-FacCPedi.FchPed.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = b-FacCPedi.NroPed.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = b-FacCPedi.NomCli.
        cRange = "D" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = f-NomPos.                      
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = f-NomPer. 
        cRange = "F" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = b-FacCPedi.FchChq. 
        cRange = "G" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = b-FacCPedi.HorChq.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = f-Estado.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = f-Situacion.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = fNroItems.

        DISPLAY b-FacCPedi.NroPed @ Fi-Mensaje LABEL "Número de Pedido"
                FORMAT "X(9)" 
                WITH FRAME F-Proceso.
        READKEY PAUSE 0.
        IF LASTKEY = KEYCODE("F10") THEN LEAVE loopREP.
END.

HIDE FRAME F-Proceso NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables wWin 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN x-FchPed-1 x-FchPed-2 x-NomCli x-FlgEst x-FlgSit x-FchChq x-UsrChq.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDataObjects wWin 
PROCEDURE initializeDataObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER plDeep AS LOGICAL NO-UNDO.

  x-FChPed-1 = TODAY.
  x-FChPed-2 = TODAY.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT plDeep).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-parametros wWin 
PROCEDURE Procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-parametros wWin 
PROCEDURE Recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _Estado wWin 
FUNCTION _Estado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR f-Estado AS CHAR NO-UNDO.

  CASE FaccPedi.FlgEst:
      WHEN "A" THEN f-Estado = "ANULADO".
      WHEN "C" THEN f-Estado = "ATENDIDO".
      WHEN "G" THEN f-Estado = "GENERADO".
      WHEN "P" THEN f-Estado = "PENDIENTE".
      WHEN "V" THEN f-Estado = "VENCIDO".
      WHEN "F" THEN f-Estado = "FACTURADO".
      WHEN "X" THEN f-Estado = "NO APROBADO".
      WHEN "R" THEN f-Estado = "RECHAZADO".
   END CASE.
   IF FaccPedi.FchVen < TODAY AND FacCPedi.FlgEst = 'P'
   THEN f-Estado = "VENCIDO".

  RETURN f-Estado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _NomPer wWin 
FUNCTION _NomPer RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR f-NomPer AS CHAR NO-UNDO.

  f-NomPer = TRIM(Pl-pers.patper) + ' ' + TRIM(Pl-pers.matper) + ', ' + Pl-pers.nomper.
  RETURN f-NomPer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _NroItems wWin 
FUNCTION _NroItems RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR fNroItems AS INT NO-UNDO.

  FOR EACH facdpedi OF faccpedi NO-LOCK:
      fNroItems = fNroItems + 1.
  END.

  RETURN fNroItems.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _Situacion wWin 
FUNCTION _Situacion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR f-Situacion AS CHAR NO-UNDO.

  CASE FaccPedi.FlgSit:
    WHEN "X" THEN f-Situacion = "POR CHEQUEAR".
    WHEN "P" THEN f-Situacion = "CHEQUEADO".
    WHEN ""  THEN f-Situacion = "".
  END CASE.
  RETURN f-Situacion.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

