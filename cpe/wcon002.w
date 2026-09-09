&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE CPEDI LIKE FacCPedi.



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

DEF VAR x-Estado AS CHAR.
DEF VAR x-Tiempo AS CHAR.
DEF VAR x-Prioridad AS CHAR.

DEF TEMP-TABLE tDetalle
    FIELD CodArea LIKE CpeTraSed.CodArea
    FIELD CodPer LIKE CpeTraSed.CodPer
    FIELD Fecha AS DATETIME
    FIELD Estado LIKE CpeTrkTar.Estado.

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
&Scoped-define INTERNAL-TABLES CpeTraSed PL-PERS CpeTareas CPEDI

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 x-Estado @ x-Estado ~
CpeTraSed.CodPer fNomPer(cpetrased.CodPer) @ PL-PERS.nomper ~
CpeTraSed.CodArea CpeTraSed.FechaReg CpeTareas.NroOD CpeTareas.NroTarea ~
CpeTareas.FchInicio fTiempo() @ x-Tiempo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH CpeTraSed ~
      WHERE CpeTraSed.CodCia = s-codcia ~
 AND CpeTraSed.CodDiv = s-coddiv ~
 AND CpeTraSed.FlgEst = "P" NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.codper = CpeTraSed.CodPer NO-LOCK, ~
      LAST CpeTareas WHERE CpeTareas.CodCia = CpeTraSed.CodCia ~
  AND CpeTareas.CodDiv = CpeTraSed.CodDiv ~
  AND CpeTareas.CodPer = CpeTraSed.CodPer ~
      AND CpeTareas.FlgEst = "P" OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH CpeTraSed ~
      WHERE CpeTraSed.CodCia = s-codcia ~
 AND CpeTraSed.CodDiv = s-coddiv ~
 AND CpeTraSed.FlgEst = "P" NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.codper = CpeTraSed.CodPer NO-LOCK, ~
      LAST CpeTareas WHERE CpeTareas.CodCia = CpeTraSed.CodCia ~
  AND CpeTareas.CodDiv = CpeTraSed.CodDiv ~
  AND CpeTareas.CodPer = CpeTraSed.CodPer ~
      AND CpeTareas.FlgEst = "P" OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 CpeTraSed PL-PERS CpeTareas
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 CpeTraSed
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 PL-PERS
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 CpeTareas


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 fPrioridad() @ x-Prioridad ~
CPEDI.Libre_c02 CPEDI.Libre_c03 CPEDI.NroPed CPEDI.FchPed CPEDI.Hora ~
CPEDI.NomCli CPEDI.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH CPEDI ~
      WHERE ( COMBO-BOX-Situacion = 'Todos' OR CPEDI.Libre_c02 = COMBO-BOX-Situacion ) ~
 AND ( COMBO-BOX-Ubicacion = 'Todos' OR CPEDI.Libre_c03 = COMBO-BOX-Ubicacion ) NO-LOCK ~
    BY CPEDI.Libre_d01 ~
       BY CPEDI.FchPed ~
        BY CPEDI.Hora
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH CPEDI ~
      WHERE ( COMBO-BOX-Situacion = 'Todos' OR CPEDI.Libre_c02 = COMBO-BOX-Situacion ) ~
 AND ( COMBO-BOX-Ubicacion = 'Todos' OR CPEDI.Libre_c03 = COMBO-BOX-Ubicacion ) NO-LOCK ~
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
&Scoped-Define ENABLED-OBJECTS BUTTON-4 COMBO-BOX-Situacion ~
COMBO-BOX-Ubicacion FILL-IN-NroPed BUTTON-3 BROWSE-7 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Situacion COMBO-BOX-Ubicacion ~
FILL-IN-NroPed 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

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
       MENU-ITEM m_Asignar_Tarea LABEL "Asignar Tarea" 
       MENU-ITEM m_Reasignar_Tarea LABEL "Reasignar Tarea"
       MENU-ITEM m_Cierre_de_Tarea LABEL "Cierre de Tarea".

DEFINE MENU POPUP-MENU-BROWSE-7 
       MENU-ITEM m_Prioridad_Alta LABEL "Prioridad Alta"
       MENU-ITEM m_Prioridad_Normal LABEL "Prioridad Normal"
       MENU-ITEM m_Prioridad_Baja LABEL "Prioridad Baja".


/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "ACTUALIZAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/search.ico":U
     LABEL "Button 4" 
     SIZE 6 BY 1.35.

DEFINE VARIABLE COMBO-BOX-Situacion AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtrar por Situación" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Todos","Asignado","No Asignado" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Ubicacion AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtrar por Ubicación" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "Todos","Almacén","Distribución","Entrega" 
     DROP-DOWN-LIST
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(9)":U 
     LABEL "O/D" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      CpeTraSed, 
      PL-PERS, 
      CpeTareas SCROLLING.

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
      CpeTraSed.CodArea FORMAT "x(8)":U
      CpeTraSed.FechaReg COLUMN-LABEL "Fecha-Hora de Registro" FORMAT "99/99/9999 HH:MM:SS":U
            WIDTH 19
      CpeTareas.NroOD COLUMN-LABEL "Numero O/D" FORMAT "x(9)":U
      CpeTareas.NroTarea COLUMN-LABEL "Tarea" FORMAT ">>>>>>>>9":U
      CpeTareas.FchInicio COLUMN-LABEL "Fecha Inicio" FORMAT "99/99/9999 HH:MM:SS":U
            WIDTH 16.86
      fTiempo() @ x-Tiempo COLUMN-LABEL "Tiempo trascurrido" FORMAT "x(20)":U
            WIDTH 32.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 139 BY 11.31
         FONT 4
         TITLE "PERSONAL ASIGNADO A LA SEDE" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 wWin _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      fPrioridad() @ x-Prioridad COLUMN-LABEL "Prioridad" FORMAT "x(10)":U
            WIDTH 9.43
      CPEDI.Libre_c02 COLUMN-LABEL "Situación" FORMAT "x(15)":U
      CPEDI.Libre_c03 COLUMN-LABEL "Ubicación" FORMAT "x(15)":U
      CPEDI.NroPed COLUMN-LABEL "Orden de Despacho" FORMAT "X(9)":U
      CPEDI.FchPed COLUMN-LABEL "Fecha de emisión" FORMAT "99/99/9999":U
      CPEDI.Hora FORMAT "X(5)":U WIDTH 4.72
      CPEDI.NomCli COLUMN-LABEL "Cliente" FORMAT "x(50)":U WIDTH 47.72
      CPEDI.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 14.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 139 BY 9.42
         FONT 4
         TITLE "ORDENES DE DESPACHO POR ATENDER" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-4 AT ROW 1 COL 83 WIDGET-ID 12
     COMBO-BOX-Situacion AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX-Ubicacion AT ROW 1.27 COL 49 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-NroPed AT ROW 1.27 COL 69 COLON-ALIGNED WIDGET-ID 10
     BUTTON-3 AT ROW 1.27 COL 126 WIDGET-ID 4
     BROWSE-7 AT ROW 2.62 COL 2 WIDGET-ID 300
     BROWSE-2 AT ROW 12.31 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 145.43 BY 22.69
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: CPEDI T "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 22.69
         WIDTH              = 145.43
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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
/* BROWSE-TAB BROWSE-7 BUTTON-3 fMain */
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
     _TblList          = "INTEGRAL.CpeTraSed,INTEGRAL.PL-PERS WHERE INTEGRAL.CpeTraSed ...,INTEGRAL.CpeTareas WHERE INTEGRAL.CpeTraSed ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ",, LAST OUTER"
     _Where[1]         = "INTEGRAL.CpeTraSed.CodCia = s-codcia
 AND INTEGRAL.CpeTraSed.CodDiv = s-coddiv
 AND INTEGRAL.CpeTraSed.FlgEst = ""P"""
     _JoinCode[2]      = "INTEGRAL.PL-PERS.codper = INTEGRAL.CpeTraSed.CodPer"
     _JoinCode[3]      = "INTEGRAL.CpeTareas.CodCia = INTEGRAL.CpeTraSed.CodCia
  AND INTEGRAL.CpeTareas.CodDiv = INTEGRAL.CpeTraSed.CodDiv
  AND INTEGRAL.CpeTareas.CodPer = INTEGRAL.CpeTraSed.CodPer"
     _Where[3]         = "INTEGRAL.CpeTareas.FlgEst = ""P"""
     _FldNameList[1]   > "_<CALC>"
"x-Estado @ x-Estado" "Estado" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CpeTraSed.CodPer
"CpeTraSed.CodPer" ? ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fNomPer(cpetrased.CodPer) @ PL-PERS.nomper" "Nombre" "x(40)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.CpeTraSed.CodArea
     _FldNameList[5]   > INTEGRAL.CpeTraSed.FechaReg
"CpeTraSed.FechaReg" "Fecha-Hora de Registro" "99/99/9999 HH:MM:SS" "datetime" ? ? ? ? ? ? no ? no no "19" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CpeTareas.NroOD
"CpeTareas.NroOD" "Numero O/D" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CpeTareas.NroTarea
"CpeTareas.NroTarea" "Tarea" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CpeTareas.FchInicio
"CpeTareas.FchInicio" "Fecha Inicio" ? "datetime" ? ? ? ? ? ? no ? no no "16.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fTiempo() @ x-Tiempo" "Tiempo trascurrido" "x(20)" ? ? ? ? ? ? ? no ? no no "32.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.CPEDI"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.CPEDI.Libre_d01|yes,Temp-Tables.CPEDI.FchPed|yes,Temp-Tables.CPEDI.Hora|yes"
     _Where[1]         = "( COMBO-BOX-Situacion = 'Todos' OR Temp-Tables.CPEDI.Libre_c02 = COMBO-BOX-Situacion )
 AND ( COMBO-BOX-Ubicacion = 'Todos' OR Temp-Tables.CPEDI.Libre_c03 = COMBO-BOX-Ubicacion )"
     _FldNameList[1]   > "_<CALC>"
"fPrioridad() @ x-Prioridad" "Prioridad" "x(10)" ? ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.CPEDI.Libre_c02
"CPEDI.Libre_c02" "Situación" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.CPEDI.Libre_c03
"CPEDI.Libre_c03" "Ubicación" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.CPEDI.NroPed
"CPEDI.NroPed" "Orden de Despacho" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.CPEDI.FchPed
"CPEDI.FchPed" "Fecha de emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.CPEDI.Hora
"CPEDI.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.CPEDI.NomCli
"CPEDI.NomCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "47.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.CPEDI.ImpTot
"CPEDI.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "14.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME fMain:HANDLE
       ROW             = 1
       COLUMN          = 112
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 2
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      CtrlFrame:MOVE-AFTER(BUTTON-4:HANDLE IN FRAME fMain).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* <insert SmartWindow title> */
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


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 wWin
ON CHOOSE OF BUTTON-4 IN FRAME fMain /* Button 4 */
DO:
  IF FILL-IN-NroPed:SCREEN-VALUE = '' THEN RETURN NO-APPLY.
  GET FIRST BROWSE-7.
  REPEAT WHILE AVAILABLE CPEDI:
      IF CPEDI.NroPed = FILL-IN-NroPed:SCREEN-VALUE THEN DO:
          REPOSITION BROWSE-7 TO ROWID ROWID(CPEDI).
          LEAVE.
      END.
      GET NEXT BROWSE-7.
  END.
  FILL-IN-NroPed:SCREEN-VALUE = ''.
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


&Scoped-define SELF-NAME m_Asignar_Tarea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Asignar_Tarea wWin
ON CHOOSE OF MENU-ITEM m_Asignar_Tarea /* Asignar Tarea */
DO:
  IF NOT AVAILABLE CpeTraSed THEN RETURN.
  IF CpeTraSed.FlgTarea <> 'L' THEN DO:
      MESSAGE 'El trabajador YA tiene una tarea asignada' VIEW-AS ALERT-BOX ERROR.
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
    FIND CURRENT CpeTareas EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE CpeTareas THEN DO:
        ASSIGN
            CpeTareas.FchFin = DATETIME(TODAY, MTIME)
            CpeTareas.FlgEst = 'C'.
        FIND CURRENT CpeTraSed EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE CpeTraSed THEN FlgTarea = 'L'.       /* Libre */
    END.
    /* Tracking de Tareas */
    CREATE CpeTrkTar.
    BUFFER-COPY CpeTareas TO CpeTrkTar.
    ASSIGN
        CpeTrkTar.Estado = 'Tarea Cerrada'
        CpeTrkTar.Fecha = DATETIME(TODAY, MTIME)
        CpeTrkTar.Usuario = s-user-id.

    IF AVAILABLE(CpeTareas) THEN RELEASE CpeTareas.
    IF AVAILABLE(CpeTraSed) THEN RELEASE CpeTraSed.
    IF AVAILABLE(CpeTrkTar) THEN RELEASE CpeTrkTar.

    RUN Abrir-Browsers.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Prioridad_Alta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Prioridad_Alta wWin
ON CHOOSE OF MENU-ITEM m_Prioridad_Alta /* Prioridad Alta */
DO:
  FIND CURRENT CPEDI EXCLUSIVE-LOCK.
  CPEDI.Libre_d01 = 1.
  FIND Faccpedi OF CPEDI EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE Faccpedi THEN Faccpedi.Libre_d01 = 1.
  RELEASE Faccpedi.
  RUN Abrir-Browsers.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Prioridad_Baja
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Prioridad_Baja wWin
ON CHOOSE OF MENU-ITEM m_Prioridad_Baja /* Prioridad Baja */
DO:
    FIND CURRENT CPEDI EXCLUSIVE-LOCK.
    CPEDI.Libre_d01 = 3.
    FIND Faccpedi OF CPEDI EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE Faccpedi THEN Faccpedi.Libre_d01 = 3.
    RELEASE Faccpedi.
    RUN Abrir-Browsers.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Prioridad_Normal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Prioridad_Normal wWin
ON CHOOSE OF MENU-ITEM m_Prioridad_Normal /* Prioridad Normal */
DO:
    FIND CURRENT CPEDI EXCLUSIVE-LOCK.
    CPEDI.Libre_d01 = 2.
    FIND Faccpedi OF CPEDI EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE Faccpedi THEN Faccpedi.Libre_d01 = 2.
    RELEASE Faccpedi.
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

    RUN cpe/gMotReaTar (ROWID(CpeTareas)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ordenes wWin 
PROCEDURE Carga-Ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE CPEDI.

FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddoc = 'O/D'
    AND Faccpedi.divdes = s-coddiv
    AND Faccpedi.flgest = 'P'
    BY Faccpedi.FchPed BY Faccpedi.Hora:
    CREATE CPEDI.
    BUFFER-COPY Faccpedi TO CPEDI.
    /* Cargamos las ZONAS de los productos */
    ASSIGN
        CPEDI.Libre_c01 = ''.
    FOR EACH facdpedi OF faccpedi NO-LOCK,
        FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = Facdpedi.codcia
        AND Almmmate.codalm = Facdpedi.almdes
        AND Almmmate.codmat = Facdpedi.codmat,
        FIRST Almtubic OF Almmmate NO-LOCK
        BREAK BY Facdpedi.almdes BY Almtubic.codzona:
        IF FIRST-OF(Facdpedi.AlmDes) OR FIRST-OF(Almtubic.codzona) 
            THEN IF CPEDI.Libre_c01 = ''
                THEN CPEDI.Libre_c01 = TRIM(Facdpedi.almdes) + ',' + TRIM(Almtubic.codzona).
                ELSE CPEDI.Libre_c01 = CPEDI.Libre_c01 + '|'  + TRIM(Facdpedi.almdes) + ',' + TRIM(Almtubic.codzona).
    END.
    /* Determinamos la prioridad */
    IF CPEDI.Libre_d01 = 0 THEN CPEDI.Libre_d01 = 2.  /* Normal */
    /* Determinamos Situación */
    FIND LAST CpeTareas WHERE CpeTareas.CodCia = s-codcia
        AND CpeTareas.CodDiv = s-coddiv
        AND CpeTareas.FlgEst = 'P'
        AND CpeTareas.NroOD = Faccpedi.NroPed
        NO-LOCK NO-ERROR.
    IF AVAILABLE CpeTareas THEN CPEDI.Libre_c02 = 'Asignado'. ELSE CPEDI.Libre_c02 = 'No Asignado'. 
    /* Determinamos Ubicación */
    EMPTY TEMP-TABLE tDetalle.
    FOR EACH CpeTrkTar NO-LOCK WHERE CpeTrkTar.CodCia = s-codcia
        AND CpeTrkTar.CodDiv = s-coddiv
        AND CpeTrkTar.NroOD = Faccpedi.NroPed,
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
    END.
    ELSE DO:
        FIND LAST tDetalle WHERE tDetalle.Estado = 'Tarea Cerrada' NO-ERROR.
        IF AVAILABLE tDetalle THEN DO:
            /* Tiene una tarea asignada */
            IF tDetalle.CodArea = 'DIS' THEN CPEDI.Libre_c03 = 'Entrega'.
            IF tDetalle.CodArea = 'ALM' THEN CPEDI.Libre_c03 = 'Distribución'.
        END.
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

OCXFile = SEARCH( "wcon002.wrx":U ).
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
ELSE MESSAGE "wcon002.wrx":U SKIP(1)
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
  DISPLAY COMBO-BOX-Situacion COMBO-BOX-Ubicacion FILL-IN-NroPed 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BUTTON-4 COMBO-BOX-Situacion COMBO-BOX-Ubicacion FILL-IN-NroPed 
         BUTTON-3 BROWSE-7 BROWSE-2 
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

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

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

