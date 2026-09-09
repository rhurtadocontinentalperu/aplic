&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-TAREAS FOR CpeTareas.
DEFINE TEMP-TABLE CPEDI LIKE FacCPedi
       INDEX Llave01 AS PRIMARY CodCia NroPed.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-codalm AS CHAR.

DEF VAR x-Estado AS CHAR.
DEF VAR x-Tiempo AS CHAR.
DEF VAR x-Prioridad AS CHAR.
DEF VAR x-Glosa AS CHAR.

DEF TEMP-TABLE tDetalle
    FIELD CodArea LIKE CpeTraSed.CodArea
    FIELD CodPer LIKE CpeTraSed.CodPer
    FIELD Fecha AS DATETIME
    FIELD Estado LIKE CpeTrkTar.Estado.

DEF VAR pOk AS LOG.

DEF BUFFER BCPEDI FOR CPEDI.

&SCOPED-DEFINE Condicion ( RADIO-SET-CodDoc = 'Todos' OR CPEDI.CodDoc = RADIO-SET-CodDoc ) ~
AND ( COMBO-BOX-Situacion = 'Todos' OR CPEDI.Libre_c02 = COMBO-BOX-Situacion ) ~
AND ( COMBO-BOX-Ubicacion = 'Todos' OR CPEDI.Libre_c03 = COMBO-BOX-Ubicacion ) ~
AND ( CPEDI.FchPed >= FILL-IN-Fecha-1 AND CPEDI.FchPed <= FILL-IN-Fecha-2 )

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
&Scoped-define INTERNAL-TABLES CpeTraSed PL-PERS CpeTareas VtaTabla CPEDI

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 x-Estado @ x-Estado ~
CpeTraSed.CodPer fNomPer(cpetrased.CodPer) @ PL-PERS.nomper ~
CpeTraSed.CodArea CpeTraSed.FechaReg CpeTareas.NroTarea fGlosa() @ x-Glosa ~
CpeTareas.CodAlm CpeTareas.CodZona CpeTareas.FchInicio fTiempo() @ x-Tiempo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH CpeTraSed ~
      WHERE CpeTraSed.CodCia = s-codcia ~
 AND CpeTraSed.CodDiv = s-coddiv ~
 AND CpeTraSed.FlgEst = "P" NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.codper = CpeTraSed.CodPer NO-LOCK, ~
      LAST CpeTareas WHERE CpeTareas.CodCia = CpeTraSed.CodCia ~
  AND CpeTareas.CodDiv = CpeTraSed.CodDiv ~
  AND CpeTareas.CodPer = CpeTraSed.CodPer ~
      AND CpeTareas.FlgEst = "P" OUTER-JOIN NO-LOCK, ~
      EACH VtaTabla WHERE VtaTabla.CodCia = CpeTareas.CodCia ~
  AND VtaTabla.Llave_c1 = CpeTareas.TpoTarea ~
      AND VtaTabla.Tabla = "CPETAREA" OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH CpeTraSed ~
      WHERE CpeTraSed.CodCia = s-codcia ~
 AND CpeTraSed.CodDiv = s-coddiv ~
 AND CpeTraSed.FlgEst = "P" NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.codper = CpeTraSed.CodPer NO-LOCK, ~
      LAST CpeTareas WHERE CpeTareas.CodCia = CpeTraSed.CodCia ~
  AND CpeTareas.CodDiv = CpeTraSed.CodDiv ~
  AND CpeTareas.CodPer = CpeTraSed.CodPer ~
      AND CpeTareas.FlgEst = "P" OUTER-JOIN NO-LOCK, ~
      EACH VtaTabla WHERE VtaTabla.CodCia = CpeTareas.CodCia ~
  AND VtaTabla.Llave_c1 = CpeTareas.TpoTarea ~
      AND VtaTabla.Tabla = "CPETAREA" OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 CpeTraSed PL-PERS CpeTareas ~
VtaTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 CpeTraSed
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 PL-PERS
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 CpeTareas
&Scoped-define FOURTH-TABLE-IN-QUERY-BROWSE-2 VtaTabla


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 fPrioridad() @ x-Prioridad ~
CPEDI.Libre_c03 CPEDI.CodAlm CPEDI.Libre_c04 CPEDI.Libre_c05 CPEDI.CodDoc ~
CPEDI.NroPed CPEDI.FchPed CPEDI.Hora CPEDI.CodRef CPEDI.NroRef CPEDI.NomCli ~
CPEDI.Libre_d02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH CPEDI ~
      WHERE {&Condicion} NO-LOCK ~
    BY CPEDI.Libre_d01 ~
       BY CPEDI.FchPed ~
        BY CPEDI.Hora
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH CPEDI ~
      WHERE {&Condicion} NO-LOCK ~
    BY CPEDI.Libre_d01 ~
       BY CPEDI.FchPed ~
        BY CPEDI.Hora.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 CPEDI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 CPEDI


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-CodDoc BUTTON-3 BUTTON-Excel ~
COMBO-BOX-Situacion COMBO-BOX-Ubicacion FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
BROWSE-7 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-CodDoc COMBO-BOX-Situacion ~
COMBO-BOX-Ubicacion FILL-IN-Fecha-1 FILL-IN-Fecha-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fGlosa wWin 
FUNCTION fGlosa RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomPer wWin 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPrioridad wWin 
FUNCTION fPrioridad RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTiempo wWin 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-BROWSE-2 
       MENU-ITEM m_Asignar_Tarea2 LABEL "Asignar Tarea" 
       MENU-ITEM m_Reasignar_Tarea LABEL "Reasignar Tarea"
       MENU-ITEM m_Cierre_de_Tarea LABEL "Cierre de Tarea".

DEFINE MENU POPUP-MENU-BROWSE-7 
       MENU-ITEM m_Asignar_Tarea LABEL "Asignar Tarea" 
       MENU-ITEM m_Asignar_Prioridad LABEL "Asignar Prioridad".


/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "ACTUALIZAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Excel 
     LABEL "Llevar a Excel" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Situacion AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtrar por Situación" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Todos","Asignado","No Asignado" 
     DROP-DOWN-LIST
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Ubicacion AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtrar por Ubicación" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Almacén","Chequeo","Distribución","Entrega" 
     DROP-DOWN-LIST
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Filtrar por Fechas" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-CodDoc AS CHARACTER INITIAL "Todos" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", "Todos",
"O/Despacho", "O/D",
"O/Mostrador", "O/M",
"OTRansferencia", "OTR"
     SIZE 62 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      CpeTraSed, 
      PL-PERS, 
      CpeTareas, 
      VtaTabla SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      CPEDI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      x-Estado @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(3)":U
      CpeTraSed.CodPer FORMAT "X(6)":U WIDTH 5.43
      fNomPer(cpetrased.CodPer) @ PL-PERS.nomper COLUMN-LABEL "Nombre" FORMAT "x(40)":U
            WIDTH 26.14
      CpeTraSed.CodArea FORMAT "x(8)":U
      CpeTraSed.FechaReg COLUMN-LABEL "Fecha-Hora de Registro" FORMAT "99/99/9999 HH:MM:SS":U
            WIDTH 19
      CpeTareas.NroTarea COLUMN-LABEL "Tarea" FORMAT ">>>>>>>>9":U
            WIDTH 5.14
      fGlosa() @ x-Glosa COLUMN-LABEL "Observaciones" FORMAT "x(25)":U
            WIDTH 22.43
      CpeTareas.CodAlm FORMAT "x(3)":U WIDTH 7.14
      CpeTareas.CodZona COLUMN-LABEL "Zona" FORMAT "x(5)":U WIDTH 4.72
      CpeTareas.FchInicio COLUMN-LABEL "Fecha Inicio" FORMAT "99/99/9999 HH:MM:SS":U
            WIDTH 16.86
      fTiempo() @ x-Tiempo COLUMN-LABEL "Tiempo trascurrido" FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 142 BY 11.31
         FONT 4
         TITLE "PERSONAL ASIGNADO A LA SEDE" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 wWin _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      fPrioridad() @ x-Prioridad COLUMN-LABEL "Prioridad" FORMAT "x(10)":U
            WIDTH 7.43
      CPEDI.Libre_c03 COLUMN-LABEL "Ubicación" FORMAT "x(12)":U
      CPEDI.CodAlm FORMAT "x(3)":U
      CPEDI.Libre_c04 COLUMN-LABEL "Zona" FORMAT "x(5)":U WIDTH 4.86
      CPEDI.Libre_c05 COLUMN-LABEL "Personal asignado" FORMAT "x(35)":U
            WIDTH 22.72
      CPEDI.CodDoc COLUMN-LABEL "Cod." FORMAT "x(3)":U
      CPEDI.NroPed COLUMN-LABEL "O/ Despacho" FORMAT "X(9)":U
      CPEDI.FchPed COLUMN-LABEL "Fecha de emisión" FORMAT "99/99/9999":U
      CPEDI.Hora FORMAT "X(5)":U WIDTH 4.72
      CPEDI.CodRef COLUMN-LABEL "Ref." FORMAT "x(3)":U
      CPEDI.NroRef COLUMN-LABEL "Pedido" FORMAT "X(9)":U WIDTH 10.29
      CPEDI.NomCli COLUMN-LABEL "Cliente" FORMAT "x(40)":U WIDTH 27.86
      CPEDI.Libre_d02 COLUMN-LABEL "Items" FORMAT ">>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 142 BY 9.42
         FONT 4
         TITLE "ORDENES DE DESPACHO POR ATENDER" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     RADIO-SET-CodDoc AT ROW 1.19 COL 16 NO-LABEL WIDGET-ID 18
     BUTTON-3 AT ROW 1.19 COL 114 WIDGET-ID 4
     BUTTON-Excel AT ROW 1.23 COL 99 WIDGET-ID 16
     COMBO-BOX-Situacion AT ROW 2.15 COL 14 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX-Ubicacion AT ROW 2.15 COL 44 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-Fecha-1 AT ROW 2.15 COL 71 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-Fecha-2 AT ROW 2.15 COL 82 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     BROWSE-7 AT ROW 3.31 COL 2 WIDGET-ID 300
     BROWSE-2 AT ROW 13 COL 2 WIDGET-ID 200
     "Filtrar por:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 1.38 COL 8 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 147.72 BY 24.73
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: B-TAREAS B "?" ? INTEGRAL CpeTareas
      TABLE: CPEDI T "?" ? INTEGRAL FacCPedi
      ADDITIONAL-FIELDS:
          INDEX Llave01 AS PRIMARY CodCia NroPed
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "PANTALLA DE CONTROL"
         HEIGHT             = 23.58
         WIDTH              = 144.14
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 161.43
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 161.43
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

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-7 FILL-IN-Fecha-2 fMain */
/* BROWSE-TAB BROWSE-2 BROWSE-7 fMain */
ASSIGN 
       BROWSE-2:POPUP-MENU IN FRAME fMain             = MENU POPUP-MENU-BROWSE-2:HANDLE.

ASSIGN 
       BROWSE-7:POPUP-MENU IN FRAME fMain             = MENU POPUP-MENU-BROWSE-7:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.CpeTraSed,INTEGRAL.PL-PERS WHERE INTEGRAL.CpeTraSed ...,INTEGRAL.CpeTareas WHERE INTEGRAL.CpeTraSed ...,INTEGRAL.VtaTabla WHERE INTEGRAL.CpeTareas ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ",, LAST OUTER, OUTER"
     _Where[1]         = "INTEGRAL.CpeTraSed.CodCia = s-codcia
 AND INTEGRAL.CpeTraSed.CodDiv = s-coddiv
 AND INTEGRAL.CpeTraSed.FlgEst = ""P"""
     _JoinCode[2]      = "INTEGRAL.PL-PERS.codper = INTEGRAL.CpeTraSed.CodPer"
     _JoinCode[3]      = "INTEGRAL.CpeTareas.CodCia = INTEGRAL.CpeTraSed.CodCia
  AND INTEGRAL.CpeTareas.CodDiv = INTEGRAL.CpeTraSed.CodDiv
  AND INTEGRAL.CpeTareas.CodPer = INTEGRAL.CpeTraSed.CodPer"
     _Where[3]         = "INTEGRAL.CpeTareas.FlgEst = ""P"""
     _JoinCode[4]      = "INTEGRAL.VtaTabla.CodCia = INTEGRAL.CpeTareas.CodCia
  AND INTEGRAL.VtaTabla.Llave_c1 = INTEGRAL.CpeTareas.TpoTarea"
     _Where[4]         = "INTEGRAL.VtaTabla.Tabla = ""CPETAREA"""
     _FldNameList[1]   > "_<CALC>"
"x-Estado @ x-Estado" "Estado" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CpeTraSed.CodPer
"CpeTraSed.CodPer" ? ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fNomPer(cpetrased.CodPer) @ PL-PERS.nomper" "Nombre" "x(40)" ? ? ? ? ? ? ? no ? no no "26.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.CpeTraSed.CodArea
     _FldNameList[5]   > INTEGRAL.CpeTraSed.FechaReg
"CpeTraSed.FechaReg" "Fecha-Hora de Registro" "99/99/9999 HH:MM:SS" "datetime" ? ? ? ? ? ? no ? no no "19" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CpeTareas.NroTarea
"CpeTareas.NroTarea" "Tarea" ? "integer" ? ? ? ? ? ? no ? no no "5.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fGlosa() @ x-Glosa" "Observaciones" "x(25)" ? ? ? ? ? ? ? no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CpeTareas.CodAlm
"CpeTareas.CodAlm" ? ? "character" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.CpeTareas.CodZona
"CpeTareas.CodZona" "Zona" "x(5)" "character" ? ? ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.CpeTareas.FchInicio
"CpeTareas.FchInicio" "Fecha Inicio" ? "datetime" ? ? ? ? ? ? no ? no no "16.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"fTiempo() @ x-Tiempo" "Tiempo trascurrido" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.CPEDI"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.CPEDI.Libre_d01|yes,Temp-Tables.CPEDI.FchPed|yes,Temp-Tables.CPEDI.Hora|yes"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > "_<CALC>"
"fPrioridad() @ x-Prioridad" "Prioridad" "x(10)" ? ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.CPEDI.Libre_c03
"CPEDI.Libre_c03" "Ubicación" "x(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.CPEDI.CodAlm
     _FldNameList[4]   > Temp-Tables.CPEDI.Libre_c04
"CPEDI.Libre_c04" "Zona" "x(5)" "character" ? ? ? ? ? ? no ? no no "4.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.CPEDI.Libre_c05
"CPEDI.Libre_c05" "Personal asignado" "x(35)" "character" ? ? ? ? ? ? no ? no no "22.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.CPEDI.CodDoc
"CPEDI.CodDoc" "Cod." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.CPEDI.NroPed
"CPEDI.NroPed" "O/ Despacho" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.CPEDI.FchPed
"CPEDI.FchPed" "Fecha de emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.CPEDI.Hora
"CPEDI.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.CPEDI.CodRef
"CPEDI.CodRef" "Ref." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.CPEDI.NroRef
"CPEDI.NroRef" "Pedido" ? "character" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.CPEDI.NomCli
"CPEDI.NomCli" "Cliente" "x(40)" "character" ? ? ? ? ? ? no ? no no "27.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.CPEDI.Libre_d02
"CPEDI.Libre_d02" "Items" ">>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME fMain:HANDLE
       ROW             = 1.19
       COLUMN          = 130
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 2
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      CtrlFrame:MOVE-AFTER(BUTTON-3:HANDLE IN FRAME fMain).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* PANTALLA DE CONTROL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* PANTALLA DE CONTROL */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 wWin
ON ROW-DISPLAY OF BROWSE-2 IN FRAME fMain /* PERSONAL ASIGNADO A LA SEDE */
DO:
    CASE CpeTraSed.FlgTarea:
        WHEN 'O' THEN DO:
            x-estado:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
        END.
        WHEN 'L' THEN DO:
            x-estado:BGCOLOR IN BROWSE {&BROWSE-NAME} = 2.
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 wWin
ON CHOOSE OF BUTTON-3 IN FRAME fMain /* ACTUALIZAR */
DO:
  RUN Abrir-Browsers.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel wWin
ON CHOOSE OF BUTTON-Excel IN FRAME fMain /* Llevar a Excel */
DO:
  RUN ToExcel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Situacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Situacion wWin
ON VALUE-CHANGED OF COMBO-BOX-Situacion IN FRAME fMain /* Filtrar por Situación */
DO:
  ASSIGN {&self-name}.
  RUN Abrir-Browsers.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Ubicacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Ubicacion wWin
ON VALUE-CHANGED OF COMBO-BOX-Ubicacion IN FRAME fMain /* Filtrar por Ubicación */
DO:
  ASSIGN {&self-name}.
  RUN Abrir-Browsers.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame wWin OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

  RUN Abrir-Browsers.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha-1 wWin
ON LEAVE OF FILL-IN-Fecha-1 IN FRAME fMain /* Filtrar por Fechas */
DO:
    ASSIGN {&self-name}.
    RUN Abrir-Browsers.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha-2 wWin
ON LEAVE OF FILL-IN-Fecha-2 IN FRAME fMain /* Hasta */
DO:
    ASSIGN {&self-name}.
    RUN Abrir-Browsers.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Asignar_Prioridad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Asignar_Prioridad wWin
ON CHOOSE OF MENU-ITEM m_Asignar_Prioridad /* Asignar Prioridad */
DO:
  DEF VAR xPrioridad AS CHAR.
  DEF VAR pCodDoc AS CHAR.
  DEF VAR pNroPed AS CHAR.
  DEF VAR i AS INT.

  DO WITH FRAME {&FRAME-NAME}:
      DO  i = 1 TO BROWSE-7:NUM-SELECTED-ROWS:
          IF BROWSE-7:FETCH-SELECTED-ROW(i) THEN DO:
              IF pCodDoc <> '' AND LOOKUP(CPEDI.CodDoc, pCodDoc, '|') = 0 THEN DO:
                  MESSAGE 'Debe seleccionar el mismo pedido' SKIP
                      'Usted ha seleccionado el pedido' CPEDI.coddoc CPEDI.nroped
                      VIEW-AS ALERT-BOX WARNING.
                  RETURN NO-APPLY.
              END.
              IF pNroPed <> '' AND LOOKUP(CPEDI.NroPed, pNroPed, '|') = 0 THEN DO:
                  MESSAGE 'Debe seleccionar el mismo pedido' SKIP
                      'Usted ha seleccionado el pedido' CPEDI.coddoc CPEDI.nroped
                      VIEW-AS ALERT-BOX WARNING.
                  RETURN NO-APPLY.
              END.
              ASSIGN
                  pCodDoc = ( IF pCodDoc = '' THEN TRIM(CPEDI.CodDoc) ELSE pCodDoc + '|' + TRIM(CPEDI.CodDoc) )
                  pNroPed = ( IF pNroPed = '' THEN TRIM(CPEDI.NroPed) ELSE pNroPed + '|' + TRIM(CPEDI.NroPed) ).
          END.
      END.
  END.

  RUN cpe/gprioridad ( OUTPUT xPrioridad ).
  IF xPrioridad = "ADM-ERROR" THEN RETURN NO-APPLY.
  DO WITH FRAME {&FRAME-NAME} TRANSACTION ON ERROR UNDO, RETURN NO-APPLY ON STOP UNDO, RETURN NO-APPLY:
      DO  i = 1 TO BROWSE-7:NUM-SELECTED-ROWS:
          IF BROWSE-7:FETCH-SELECTED-ROW(i) THEN DO:
              FIND CURRENT CPEDI EXCLUSIVE-LOCK NO-ERROR.
              CPEDI.Libre_d01 = LOOKUP(xPrioridad, 'Alta,Normal,Baja').       
              FIND Faccpedi OF CPEDI EXCLUSIVE-LOCK NO-ERROR.                 
              IF AVAILABLE Faccpedi THEN Faccpedi.Libre_d01 = CPEDI.Libre_d01.
              RELEASE Faccpedi.                     
              FIND Almcmov WHERE Almcmov.codcia = s-codcia
                  AND Almcmov.codalm = CPEDI.codalm
                  AND Almcmov.tipmov = 'S'
                  AND Almcmov.codmov = 03
                  AND Almcmov.nroser = INTEGER(SUBSTRING(CPEDI.nroped,1,3))
                  AND Almcmov.nrodoc = INTEGER(SUBSTRING(CPEDI.nroped,4))
                  EXCLUSIVE-LOCK NO-ERROR.
              IF AVAILABLE Almcmov THEN Almcmov.Libre_d01 = CPEDI.Libre_d01.
              RELEASE Almcmov.
          END.
      END.
  END.
  RUN Abrir-Browsers.

/*   xPrioridad = fPrioridad().                                           */
/*   RUN cpe/gprioridad ( INPUT-OUTPUT xPrioridad ).                      */
/*   IF xPrioridad <> fPrioridad() THEN DO:                               */
/*       FIND CURRENT CPEDI EXCLUSIVE-LOCK.                               */
/*       CPEDI.Libre_d01 = LOOKUP(xPrioridad, 'Alta,Normal,Baja').        */
/*       FIND Faccpedi OF CPEDI EXCLUSIVE-LOCK NO-ERROR.                  */
/*       IF AVAILABLE Faccpedi THEN Faccpedi.Libre_d01 = CPEDI.Libre_d01. */
/*       RELEASE Faccpedi.                                                */
/*       RUN Abrir-Browsers.                                              */
/*   END.                                                                 */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Asignar_Tarea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Asignar_Tarea wWin
ON CHOOSE OF MENU-ITEM m_Asignar_Tarea /* Asignar Tarea */
DO:
  DEF VAR i AS INT.
  DEF VAR pCodDoc AS CHAR.
  DEF VAR pNroPed AS CHAR.
  DEF VAR pCodAlm AS CHAR.
  DEF VAR pZona AS CHAR.
  DEF VAR pUbicacion AS CHAR.
  
  /* Consistencia */
  ASSIGN
      pCodDoc = ''
      pNroPed = ''
      pCodAlm = ''
      pZona = ''
      pUbicacion = ''.

  /* Limitaciones :
    - Deben de ser el mismo pedido
    - Deben de ser del mismo almacén
    - Deben estar en la misma ubicacion de tarea
  */

  DO WITH FRAME {&FRAME-NAME}:
      DO  i = 1 TO BROWSE-7:NUM-SELECTED-ROWS:
          IF BROWSE-7:FETCH-SELECTED-ROW(i) THEN DO:
              IF CPEDI.Libre_c02 <> 'No Asignado' THEN DO:
                  MESSAGE 'Debe seleccionar un pedido NO ASIGNADO' SKIP
                      'Usted ha seleccionado el pedido' CPEDI.coddoc CPEDI.nroped
                      VIEW-AS ALERT-BOX WARNING.
                  RETURN 'ADM-ERROR'.
              END.
              IF pCodDoc <> '' AND LOOKUP(CPEDI.CodDoc, pCodDoc, '|') = 0 THEN DO:
                  MESSAGE 'Debe seleccionar el mismo pedido' SKIP
                      'Usted ha seleccionado el pedido' CPEDI.coddoc CPEDI.nroped
                      VIEW-AS ALERT-BOX WARNING.
                  RETURN 'ADM-ERROR'.
              END.
              IF pNroPed <> '' AND LOOKUP(CPEDI.NroPed, pNroPed, '|') = 0 THEN DO:
                  MESSAGE 'Debe seleccionar el mismo pedido' SKIP
                      'Usted ha seleccionado el pedido' CPEDI.coddoc CPEDI.nroped
                      VIEW-AS ALERT-BOX WARNING.
                  RETURN 'ADM-ERROR'.
              END.
              IF pCodAlm <> '' AND LOOKUP(CPEDI.CodAlm, pCodAlm, '|') = 0 THEN DO:
                  MESSAGE 'Debe seleccionar el mismo almacén' SKIP
                      'Usted ha seleccionado el pedido' CPEDI.coddoc CPEDI.nroped CPEDI.codalm
                      VIEW-AS ALERT-BOX WARNING.
                  RETURN 'ADM-ERROR'.
              END.
              IF pUbicacion <> '' AND LOOKUP(TRIM(CPEDI.Libre_c03), pUbicacion, '|') = 0 THEN DO:
                  MESSAGE 'Debe seleccionar el mismo pedido y la misma ubicación actual' SKIP
                      'Usted ha seleccionado el pedido' CPEDI.coddoc CPEDI.nroped TRIM(CPEDI.Libre_c03)
                      VIEW-AS ALERT-BOX WARNING.
                  RETURN 'ADM-ERROR'.
              END.
              ASSIGN
                  pCodDoc = ( IF pCodDoc = '' THEN TRIM(CPEDI.CodDoc) ELSE pCodDoc + '|' + TRIM(CPEDI.CodDoc) )
                  pNroPed = ( IF pNroPed = '' THEN TRIM(CPEDI.NroPed) ELSE pNroPed + '|' + TRIM(CPEDI.NroPed) )
                  pCodAlm = ( IF pCodAlm = '' THEN TRIM(CPEDI.CodAlm) ELSE pCodAlm + '|' + TRIM(CPEDI.CodAlm) )
                  pZona = ( IF pZona = '' THEN TRIM(CPEDI.Libre_c04) ELSE pZona + '|' + TRIM(CPEDI.Libre_c04) )
                  pUbicacion = ( IF pUbicacion = '' THEN TRIM(CPEDI.Libre_c03) ELSE pUbicacion + '|' + TRIM(CPEDI.Libre_c03) ).
          END.
      END.
  END.
/*   IF AVAILABLE CPEDI AND CPEDI.Libre_c02 = 'No Asignado'                                                                */
/*       THEN RUN cpe/gasgtarxod (CPEDI.CodDoc, CPEDI.NroPed, CPEDI.CodAlm, CPEDI.Libre_c04, CPEDI.Libre_c03, OUTPUT pOk). */
  IF pCodDoc <> '' THEN RUN cpe/gasgtarxod (pCodDoc,
                                            pNroPed,
                                            pCodAlm,
                                            pZona, 
                                            pUbicacion, 
                                            OUTPUT pOk).
  IF pOk = YES THEN RUN Abrir-Browsers.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Asignar_Tarea2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Asignar_Tarea2 wWin
ON CHOOSE OF MENU-ITEM m_Asignar_Tarea2 /* Asignar Tarea */
DO:
    IF NOT AVAILABLE CpeTraSed THEN RETURN.
    IF CpeTraSed.FlgTarea <> 'L' THEN DO:
        MESSAGE 'El trabajador tiene una tarea asignada' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    RUN cpe/gAsigTarea (CpeTraSed.CodPer).
    RUN Abrir-Browsers.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cierre_de_Tarea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cierre_de_Tarea wWin
ON CHOOSE OF MENU-ITEM m_Cierre_de_Tarea /* Cierre de Tarea */
DO:
    IF NOT AVAILABLE CpeTraSed THEN RETURN.
    IF CpeTraSed.FlgTarea <> 'O' THEN DO:
        MESSAGE 'El trabajador NO tiene una tarea asignada' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    MESSAGE 'Confirme el cierre de la tarea' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
/*     FIND CURRENT CpeTareas EXCLUSIVE-LOCK NO-ERROR.                   */
/*     IF AVAILABLE CpeTareas THEN DO:                                   */
/*         ASSIGN                                                        */
/*             CpeTareas.FchFin = DATETIME(TODAY, MTIME)                 */
/*             CpeTareas.FlgEst = 'C'.                                   */
/*         FIND CURRENT CpeTraSed EXCLUSIVE-LOCK NO-ERROR.               */
/*         IF AVAILABLE CpeTraSed THEN FlgTarea = 'L'.       /* Libre */ */
/*     END.                                                              */
    FIND CURRENT CpeTraSed EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE CpeTraSed THEN DO:
        CpeTraSed.FlgTarea = 'L'.
        FOR EACH CpeTareas WHERE CpeTareas.codcia = CpeTraSed.codcia
            AND CpeTareas.coddiv = CpeTraSed.coddiv
            AND CpeTareas.codper = CpeTraSed.codper
            AND CpeTareas.flgest = "P":
            ASSIGN                                       
                CpeTareas.FchFin = DATETIME(TODAY, MTIME)
                CpeTareas.FlgEst = 'C'.                  
            CREATE CpeTrkTar.
            BUFFER-COPY CpeTareas TO CpeTrkTar.
            ASSIGN
                CpeTrkTar.Estado = 'Tarea Cerrada'
                CpeTrkTar.Fecha = DATETIME(TODAY, MTIME)
                CpeTrkTar.Usuario = s-user-id.
        END.
    END.
    /* Tracking de Tareas */
/*     CREATE CpeTrkTar.                            */
/*     BUFFER-COPY CpeTareas TO CpeTrkTar.          */
/*     ASSIGN                                       */
/*         CpeTrkTar.Estado = 'Tarea Cerrada'       */
/*         CpeTrkTar.Fecha = DATETIME(TODAY, MTIME) */
/*         CpeTrkTar.Usuario = s-user-id.           */

    IF AVAILABLE(CpeTareas) THEN RELEASE CpeTareas.
    IF AVAILABLE(CpeTraSed) THEN RELEASE CpeTraSed.
    IF AVAILABLE(CpeTrkTar) THEN RELEASE CpeTrkTar.

    RUN Abrir-Browsers.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Reasignar_Tarea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Reasignar_Tarea wWin
ON CHOOSE OF MENU-ITEM m_Reasignar_Tarea /* Reasignar Tarea */
DO:
    IF NOT AVAILABLE CpeTraSed THEN RETURN.
    IF CpeTraSed.FlgTarea <> 'O' THEN DO:
        MESSAGE 'El trabajador NO tiene una tarea asignada' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    /*RUN cpe/gMotReaTar (ROWID(CpeTareas)).*/
    RUN cpe/gMotReaTar-01 (ROWID(CpeTraSed)).
    RUN Abrir-Browsers.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-CodDoc wWin
ON VALUE-CHANGED OF RADIO-SET-CodDoc IN FRAME fMain
DO:
    ASSIGN {&self-name}.
    RUN Abrir-Browsers.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Abrir-Browsers wWin 
PROCEDURE Abrir-Browsers :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Carga-Ordenes.
{&OPEN-QUERY-{&BROWSE-NAME}}
{&OPEN-QUERY-BROWSE-7}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Guias-Detalle wWin 
PROCEDURE Carga-Guias-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDoc AS CHAR.

DEF VAR t-Zonas AS CHAR.
DEF VAR k AS INT.

FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
    AND Almacen.coddiv = s-coddiv,
    EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia
    AND Almcmov.codalm = Almacen.codalm
    AND Almcmov.tipmov = 'S'
    AND Almcmov.codmov = 03
    AND Almcmov.flgest <> 'A'
    AND Almcmov.libre_c02 <> "C"
    AND Almcmov.flgsit = "T":   /* Transferido pero no recepcionado */
    FOR EACH Almdmov OF Almcmov NO-LOCK,
        FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = Almdmov.codcia
        AND Almmmate.codalm = Almdmov.codalm
        AND Almmmate.codmat = Almdmov.codmat,
        FIRST Almtubic OF Almmmate NO-LOCK
        BREAK BY Almdmov.CodAlm BY Almtubic.CodZona:
        IF FIRST-OF(Almdmov.CodAlm) OR FIRST-OF(Almtubic.CodZona) THEN DO:
            t-Zonas = TRIM(Almdmov.codalm) + ',' + TRIM(Almtubic.codzona).
            CREATE CPEDI.
            BUFFER-COPY Almcmov 
                EXCEPT Almcmov.codref
                TO CPEDI
                ASSIGN
                CPEDI.CodDoc = "G/R"
                CPEDI.NroPed = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '999999')
                CPEDI.Hora = Almcmov.HraDoc
                CPEDI.NomCli = Almcmov.nomref.
            /* Determinamos la prioridad */
            IF CPEDI.Libre_d01 = 0 OR CPEDI.Libre_d01 > 3
                THEN CPEDI.Libre_d01 = 2.  /* Normal */
            /* Almacén, División y # de Items */
            ASSIGN
                CPEDI.CodAlm = ENTRY(1, t-Zonas)
                CPEDI.Libre_c04 = ENTRY(2, t-Zonas).
            ASSIGN
                CPEDI.Libre_d02 = 0
                CPEDI.ImpTot = 0.
            /* Determinamos Situación */
            FIND LAST CpeTareas WHERE CpeTareas.CodCia = s-codcia
                AND CpeTareas.CodDiv = s-coddiv
                AND CpeTareas.FlgEst = 'P'
                AND CpeTareas.CodOD = "G/R"
                AND CpeTareas.NroOD = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '999999')
                AND CpeTareas.CodAlm = CPEDI.CodAlm
                AND CpeTareas.CodZona = CPEDI.Libre_c04
                NO-LOCK NO-ERROR.
            IF AVAILABLE CpeTareas 
            THEN ASSIGN 
                    CPEDI.Libre_c02 = 'Asignado'
                    CPEDI.Libre_c05 = fNomPer(CpeTareas.CodPer).
            ELSE ASSIGN
                    CPEDI.Libre_c02 = 'No Asignado'
                    CPEDI.Libre_c05 = ''.
            /* Determinamos Ubicación */
            EMPTY TEMP-TABLE tDetalle.
            FOR EACH CpeTrkTar NO-LOCK WHERE CpeTrkTar.CodCia = s-codcia
                AND CpeTrkTar.CodDiv = s-coddiv
                AND CpeTrkTar.CodOD = "G/R"
                AND CpeTrkTar.NroOD = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '999999')
                AND CpeTrkTar.CodAlm = CPEDI.CodAlm
                AND CpeTrkTar.CodZona = CPEDI.Libre_c04,
                FIRST CpeTraSed NO-LOCK WHERE CpeTraSed.CodCia = s-codcia
                    AND CpeTraSed.CodDiv = s-coddiv 
                    AND CpeTraSed.CodPer = CpeTrkTar.CodPer
                    AND CpeTraSed.FlgEst = 'P'
                BY CpeTrkTar.Fecha:
                FIND tDetalle WHERE tDetalle.codper = cpetrktar.codper NO-ERROR.
                IF NOT AVAILABLE tDetalle THEN CREATE tDetalle.
                ASSIGN
                    tDetalle.CodArea = CpeTraSed.CodArea
                    tDetalle.CodPer = CpeTraSed.CodPer
                    tDetalle.Fecha = CpeTrkTar.Fecha
                    tDetalle.Estado = CpeTrkTar.Estado.
            END.
            CPEDI.Libre_c03 = 'Almacén'.
            FIND LAST tDetalle WHERE tDetalle.Estado = 'Tarea Asignada' NO-ERROR.
            IF AVAILABLE tDetalle THEN DO:
                /* Tiene una tarea asignada */
                IF tDetalle.CodArea = 'DIS' THEN CPEDI.Libre_c03 = 'Distribución'.
                IF tDetalle.CodArea = 'ALM' THEN CPEDI.Libre_c03 = 'Almacén'.
                IF tDetalle.CodArea = 'CHE' THEN CPEDI.Libre_c03 = 'Chequeo'.
            END.
            ELSE DO:
                FIND LAST tDetalle WHERE tDetalle.Estado = 'Tarea Cerrada' NO-ERROR.
                IF AVAILABLE tDetalle THEN DO:
                    /* Tiene una tarea asignada */
                    IF tDetalle.CodArea = 'DIS' THEN CPEDI.Libre_c03 = 'Entrega'.
                    IF tDetalle.CodArea = 'CHE' THEN CPEDI.Libre_c03 = 'Distribución'.
                    IF tDetalle.CodArea = 'ALM' THEN CPEDI.Libre_c03 = 'Chequeo'.
                END.
            END.
        END.
        IF AVAILABLE CPEDI THEN ASSIGN
        CPEDI.Libre_d02 = CPEDI.Libre_d02 + 1
        CPEDI.ImpTot = CPEDI.ImpTot + Almdmov.ImpLin.
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ordenes wWin 
PROCEDURE Carga-Ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE CPEDI.

SESSION:SET-WAIT-STATE('GENERAL').
RUN Carga-Ordenes-Detalle ('O/D').
RUN Carga-Ordenes-Detalle ('O/M').
RUN Carga-Ordenes-Detalle ('OTR').
RUN Carga-Guias-Detalle ('G/R').
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ordenes-Detalle wWin 
PROCEDURE Carga-Ordenes-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDoc AS CHAR.

DEF VAR t-Zonas AS CHAR.
DEF VAR k AS INT.

FOR EACH Faccpedi USE-INDEX Llave08 NO-LOCK WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddoc = pCodDoc 
    AND Faccpedi.divdes = s-coddiv
    AND Faccpedi.FlgEst = "P"
    AND Faccpedi.FlgSit = "T":
    /*AND Faccpedi.FlgSit = "P":*/
    FOR EACH facdpedi OF faccpedi NO-LOCK,
        FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = Facdpedi.codcia
        AND Almmmate.codalm = Facdpedi.almdes
        AND Almmmate.codmat = Facdpedi.codmat,
        FIRST Almtubic OF Almmmate NO-LOCK
        BREAK BY Facdpedi.AlmDes BY Almtubic.CodZona:
        IF FIRST-OF(Facdpedi.AlmDes) OR FIRST-OF(Almtubic.CodZona) THEN DO:
            t-Zonas = TRIM(Facdpedi.almdes) + ',' + TRIM(Almtubic.codzona).
            CREATE CPEDI.
            BUFFER-COPY Faccpedi TO CPEDI.
            /* Determinamos la prioridad */
            IF CPEDI.Libre_d01 = 0 OR CPEDI.Libre_d01 > 3
                THEN CPEDI.Libre_d01 = 2.  /* Normal */
            /* Almacén, División y # de Items */
            ASSIGN
                CPEDI.CodAlm = ENTRY(1, t-Zonas)
                CPEDI.Libre_c04 = ENTRY(2, t-Zonas).
            ASSIGN
                CPEDI.Libre_d02 = 0
                CPEDI.ImpTot = 0.
            /* Determinamos Situación */
            FIND LAST CpeTareas WHERE CpeTareas.CodCia = s-codcia
                AND CpeTareas.CodDiv = s-coddiv
                AND CpeTareas.FlgEst = 'P'
                AND CpeTareas.CodOD = Faccpedi.CodDoc
                AND CpeTareas.NroOD = Faccpedi.NroPed
                AND CpeTareas.CodAlm = CPEDI.CodAlm
                AND CpeTareas.CodZona = CPEDI.Libre_c04
                NO-LOCK NO-ERROR.
            IF AVAILABLE CpeTareas 
            THEN ASSIGN 
                    CPEDI.Libre_c02 = 'Asignado'
                    CPEDI.Libre_c05 = fNomPer(CpeTareas.CodPer).
            ELSE ASSIGN
                    CPEDI.Libre_c02 = 'No Asignado'
                    CPEDI.Libre_c05 = ''.
            /* Determinamos Ubicación */
            EMPTY TEMP-TABLE tDetalle.
            FOR EACH CpeTrkTar NO-LOCK WHERE CpeTrkTar.CodCia = s-codcia
                AND CpeTrkTar.CodDiv = s-coddiv
                AND CpeTrkTar.CodOD = Faccpedi.CodDoc
                AND CpeTrkTar.NroOD = Faccpedi.NroPed
                AND CpeTrkTar.CodAlm = CPEDI.CodAlm
                AND CpeTrkTar.CodZona = CPEDI.Libre_c04,
                FIRST CpeTraSed NO-LOCK WHERE CpeTraSed.CodCia = s-codcia
                    AND CpeTraSed.CodDiv = s-coddiv 
                    AND CpeTraSed.CodPer = CpeTrkTar.CodPer
                    AND CpeTraSed.FlgEst = 'P'
                BY CpeTrkTar.Fecha:
                FIND tDetalle WHERE tDetalle.codper = cpetrktar.codper NO-ERROR.
                IF NOT AVAILABLE tDetalle THEN CREATE tDetalle.
                ASSIGN
                    tDetalle.CodArea = CpeTraSed.CodArea
                    tDetalle.CodPer = CpeTraSed.CodPer
                    tDetalle.Fecha = CpeTrkTar.Fecha
                    tDetalle.Estado = CpeTrkTar.Estado.
            END.
            CPEDI.Libre_c03 = 'Almacén'.
            FIND LAST tDetalle WHERE tDetalle.Estado = 'Tarea Asignada' NO-ERROR.
            IF AVAILABLE tDetalle THEN DO:
                /* Tiene una tarea asignada */
                IF tDetalle.CodArea = 'DIS' THEN CPEDI.Libre_c03 = 'Distribución'.
                IF tDetalle.CodArea = 'ALM' THEN CPEDI.Libre_c03 = 'Almacén'.
                IF tDetalle.CodArea = 'CHE' THEN CPEDI.Libre_c03 = 'Chequeo'.
            END.
            ELSE DO:
                FIND LAST tDetalle WHERE tDetalle.Estado = 'Tarea Cerrada' NO-ERROR.
                IF AVAILABLE tDetalle THEN DO:
                    /* Tiene una tarea asignada */
                    IF tDetalle.CodArea = 'DIS' THEN CPEDI.Libre_c03 = 'Entrega'.
                    IF tDetalle.CodArea = 'CHE' THEN CPEDI.Libre_c03 = 'Distribución'.
                    IF tDetalle.CodArea = 'ALM' THEN CPEDI.Libre_c03 = 'Chequeo'.
                END.
            END.
        END.
        IF AVAILABLE CPEDI THEN ASSIGN
        CPEDI.Libre_d02 = CPEDI.Libre_d02 + 1
        CPEDI.ImpTot = CPEDI.ImpTot + Facdpedi.ImpLin.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load wWin  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "w-control-tareas-v2.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "w-control-tareas-v2.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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
  DISPLAY RADIO-SET-CodDoc COMBO-BOX-Situacion COMBO-BOX-Ubicacion 
          FILL-IN-Fecha-1 FILL-IN-Fecha-2 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RADIO-SET-CodDoc BUTTON-3 BUTTON-Excel COMBO-BOX-Situacion 
         COMBO-BOX-Ubicacion FILL-IN-Fecha-1 FILL-IN-Fecha-2 BROWSE-7 BROWSE-2 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Carga-Ordenes.
  ASSIGN
      FILL-IN-Fecha-1 = TODAY - 7 FILL-IN-Fecha-2 = TODAY.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ToExcel wWin 
PROCEDURE ToExcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

    DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

    DEFINE VARIABLE iCount                  AS INTEGER init 1.
    DEFINE VARIABLE iIndex                  AS INTEGER.
    DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
    DEFINE VARIABLE cColumn                 AS CHARACTER.
    DEFINE VARIABLE cRange                  AS CHARACTER.
    DEFINE VARIABLE x-signo                 AS DECI.
    DEFINE VARIABLE lLinea                  AS INT.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    iColumn = 1.

    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = 'UBICACION'.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = 'ALMACEN'.
    cRange = "c" + cColumn.
    chWorkSheet:Range(cRange):Value = 'ZONA'.
    cRange = "e" + cColumn.
    chWorkSheet:Range(cRange):Value = 'PERS. ASIGNADO'.
    cRange = "f" + cColumn.
    chWorkSheet:Range(cRange):Value = 'COD'.
    cRange = "g" + cColumn.
    chWorkSheet:Range(cRange):Value = 'O/DESPACHO'.
    cRange = "h" + cColumn.
    chWorkSheet:Range(cRange):Value = 'FEC.EMISION'.
    cRange = "i" + cColumn.
    chWorkSheet:Range(cRange):Value = 'HORA'.
    cRange = "j" + cColumn.
    chWorkSheet:Range(cRange):Value = 'REF'.
    cRange = "k" + cColumn.
    chWorkSheet:Range(cRange):Value = 'PEDIDO'.
    cRange = "l" + cColumn.
    chWorkSheet:Range(cRange):Value = 'CLIENTE'.
    cRange = "m" + cColumn.
    chWorkSheet:Range(cRange):Value = 'ITEMS'.
    cRange = "n" + cColumn.
    chWorkSheet:Range(cRange):Value = 'IMP. TOTAL'.
    FOR EACH BCPEDI:
             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).
             cRange = "A" + cColumn.
         chWorkSheet:Range(cRange):Value = BCPEDI.libre_c03.
             cRange = "B" + cColumn.
         chWorkSheet:Range(cRange):Value = BCPEDI.codalm.
             cRange = "c" + cColumn.
         chWorkSheet:Range(cRange):Value = BCPEDI.libre_c04.
             cRange = "e" + cColumn.
         chWorkSheet:Range(cRange):Value = BCPEDI.libre_c05.
             cRange = "f" + cColumn.
         chWorkSheet:Range(cRange):Value = BCPEDI.coddoc.
             cRange = "g" + cColumn.
         chWorkSheet:Range(cRange):Value = BCPEDI.nroped.
             cRange = "h" + cColumn.
         chWorkSheet:Range(cRange):Value = BCPEDI.fchped.
             cRange = "i" + cColumn.
         chWorkSheet:Range(cRange):Value = BCPEDI.hora.
             cRange = "j" + cColumn.
         chWorkSheet:Range(cRange):Value = BCPEDI.codref.
             cRange = "k" + cColumn.
         chWorkSheet:Range(cRange):Value = BCPEDI.nroref.
             cRange = "l" + cColumn.
         chWorkSheet:Range(cRange):Value = BCPEDI.nomcli.
             cRange = "m" + cColumn.
         chWorkSheet:Range(cRange):Value = BCPEDI.libre_d02.
             cRange = "n" + cColumn.
         chWorkSheet:Range(cRange):Value = BCPEDI.imptot.
    END.

    /*chWorkSheet:SaveAs("c:\ciman\OD_x_ATENDER.xls").*/
        chExcelApplication:DisplayAlerts = False.
   /*     chExcelApplication:Quit().*/

    /* release com-handles */
    RELEASE OBJECT chExcelApplication NO-ERROR.      
    RELEASE OBJECT chWorkbook NO-ERROR.
    RELEASE OBJECT chWorksheet NO-ERROR.
    RELEASE OBJECT chWorksheetRange NO-ERROR. 

    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fGlosa wWin 
FUNCTION fGlosa RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF AVAILABLE VtaTabla AND AVAILABLE CpeTareas THEN DO:
    IF VtaTabla.Libre_c01 = 'Si' THEN RETURN (CpeTareas.CodOD + ' ' + CpeTareas.NroOD).
    ELSE RETURN (VtaTabla.Llave_c2).
END.
RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNomPer wWin 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND pl-pers WHERE pl-pers.codper = pCodPer NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers 
      THEN RETURN TRIM(pl-pers.patper) + ' ' + TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
    ELSE RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPrioridad wWin 
FUNCTION fPrioridad RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF CPEDI.Libre_d01 = 1 THEN RETURN 'Alta'.
  IF CPEDI.Libre_d01 = 2 THEN RETURN 'Normal'.
  IF CPEDI.Libre_d01 = 3 THEN RETURN 'Baja'.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTiempo wWin 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF AVAILABLE CpeTareas 
  THEN RUN lib/_time-passed (CpeTareas.FchInicio, DATETIME(TODAY, MTIME), OUTPUT x-Tiempo).
  ELSE x-Tiempo = "".   /* Function return value. */
  RETURN x-Tiempo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

