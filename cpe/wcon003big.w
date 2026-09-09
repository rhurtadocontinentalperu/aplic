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
fNomPer(cpetrased.CodPer) @ PL-PERS.nomper CpeTraSed.CodArea ~
fGlosa() @ x-Glosa CpeTareas.CodAlm CpeTareas.CodZona CpeTareas.FchInicio ~
fTiempo() @ x-Tiempo 
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
SUBSTRING(CPEDI.Libre_c03,1,3) @ CPEDI.Libre_c03 CPEDI.Libre_c04 ~
CPEDI.Libre_c05 SUBSTRING(CodDoc,3,1) @ CodDoc CPEDI.NroPed CPEDI.FchPed ~
CPEDI.Hora CPEDI.CodRef CPEDI.NroRef CPEDI.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH CPEDI NO-LOCK ~
    BY CPEDI.Libre_d01 ~
       BY CPEDI.FchPed ~
        BY CPEDI.Hora
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH CPEDI NO-LOCK ~
    BY CPEDI.Libre_d01 ~
       BY CPEDI.FchPed ~
        BY CPEDI.Hora.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 CPEDI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 CPEDI


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-7}

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

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
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
      x-Estado @ x-Estado COLUMN-LABEL "E" FORMAT "x(3)":U WIDTH 2.43
      fNomPer(cpetrased.CodPer) @ PL-PERS.nomper COLUMN-LABEL "Nombre" FORMAT "x(40)":U
            WIDTH 26.14
      CpeTraSed.CodArea FORMAT "x(3)":U WIDTH 6.72
      fGlosa() @ x-Glosa COLUMN-LABEL "Observaciones" FORMAT "x(25)":U
            WIDTH 20.43
      CpeTareas.CodAlm COLUMN-LABEL "Alm." FORMAT "x(3)":U WIDTH 6.43
      CpeTareas.CodZona COLUMN-LABEL "Zona" FORMAT "x(5)":U WIDTH 6.43
      CpeTareas.FchInicio COLUMN-LABEL "Inicio" FORMAT "99/99/99 HH:MM":U
            WIDTH 14.43
      fTiempo() @ x-Tiempo COLUMN-LABEL "Tiempo trascurrido" FORMAT "x(20)":U
            WIDTH 22.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE NO-SCROLLBAR-VERTICAL SIZE 113 BY 11.04
         FONT 9 ROW-HEIGHT-CHARS .81 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 wWin _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      fPrioridad() @ x-Prioridad COLUMN-LABEL "P" FORMAT "x(1)":U
            WIDTH 2.43
      SUBSTRING(CPEDI.Libre_c03,1,3) @ CPEDI.Libre_c03 COLUMN-LABEL "Ubic." FORMAT "x(3)":U
            WIDTH 6.43
      CPEDI.Libre_c04 COLUMN-LABEL "Zona" FORMAT "x(5)":U WIDTH 6.43
      CPEDI.Libre_c05 COLUMN-LABEL "Personal" FORMAT "x(35)":U
            WIDTH 17.43
      SUBSTRING(CodDoc,3,1) @ CodDoc COLUMN-LABEL "C" FORMAT "x(1)":U
      CPEDI.NroPed COLUMN-LABEL "O/ Despacho" FORMAT "X(9)":U WIDTH 14.43
      CPEDI.FchPed COLUMN-LABEL "Emisión" FORMAT "99/99/99":U WIDTH 10.43
      CPEDI.Hora FORMAT "X(5)":U WIDTH 6.43
      CPEDI.CodRef COLUMN-LABEL "Ref." FORMAT "x(3)":U WIDTH 5.43
      CPEDI.NroRef COLUMN-LABEL "Pedido" FORMAT "X(9)":U WIDTH 13.43
      CPEDI.NomCli COLUMN-LABEL "Cliente" FORMAT "x(40)":U WIDTH 17.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS MULTIPLE NO-SCROLLBAR-VERTICAL SIZE 113 BY 8.88
         FONT 9 ROW-HEIGHT-CHARS .73 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BROWSE-7 AT ROW 1 COL 1 WIDGET-ID 300
     BROWSE-2 AT ROW 10.15 COL 1 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 113.14 BY 20.23
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
         TITLE              = ""
         HEIGHT             = 20.23
         WIDTH              = 113.14
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
/* BROWSE-TAB BROWSE-7 1 fMain */
/* BROWSE-TAB BROWSE-2 BROWSE-7 fMain */
/* SETTINGS FOR BROWSE BROWSE-2 IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BROWSE BROWSE-7 IN FRAME fMain
   NO-ENABLE                                                            */
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
"x-Estado @ x-Estado" "E" "x(3)" ? ? ? ? ? ? ? no ? no no "2.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fNomPer(cpetrased.CodPer) @ PL-PERS.nomper" "Nombre" "x(40)" ? ? ? ? ? ? ? no ? no no "26.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CpeTraSed.CodArea
"CpeTraSed.CodArea" ? "x(3)" "character" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fGlosa() @ x-Glosa" "Observaciones" "x(25)" ? ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CpeTareas.CodAlm
"CpeTareas.CodAlm" "Alm." ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CpeTareas.CodZona
"CpeTareas.CodZona" "Zona" "x(5)" "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CpeTareas.FchInicio
"CpeTareas.FchInicio" "Inicio" "99/99/99 HH:MM" "datetime" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fTiempo() @ x-Tiempo" "Tiempo trascurrido" "x(20)" ? ? ? ? ? ? ? no ? no no "22.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.CPEDI"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.CPEDI.Libre_d01|yes,Temp-Tables.CPEDI.FchPed|yes,Temp-Tables.CPEDI.Hora|yes"
     _FldNameList[1]   > "_<CALC>"
"fPrioridad() @ x-Prioridad" "P" "x(1)" ? ? ? ? ? ? ? no ? no no "2.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"SUBSTRING(CPEDI.Libre_c03,1,3) @ CPEDI.Libre_c03" "Ubic." "x(3)" ? ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.CPEDI.Libre_c04
"Libre_c04" "Zona" "x(5)" "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.CPEDI.Libre_c05
"Libre_c05" "Personal" "x(35)" "character" ? ? ? ? ? ? no ? no no "17.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"SUBSTRING(CodDoc,3,1) @ CodDoc" "C" "x(1)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.CPEDI.NroPed
"NroPed" "O/ Despacho" ? "character" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.CPEDI.FchPed
"FchPed" "Emisión" "99/99/99" "date" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.CPEDI.Hora
"Hora" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.CPEDI.CodRef
"CodRef" "Ref." ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.CPEDI.NroRef
"NroRef" "Pedido" ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.CPEDI.NomCli
"NomCli" "Cliente" "x(40)" "character" ? ? ? ? ? ? no ? no no "17.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME fMain:HANDLE
       ROW             = 1.27
       COLUMN          = 98
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 2
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      CtrlFrame:MOVE-AFTER(BROWSE-7:HANDLE IN FRAME fMain).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin
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
ON ROW-DISPLAY OF BROWSE-2 IN FRAME fMain
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


RUN Carga-Ordenes-Detalle ('O/D').
RUN Carga-Ordenes-Detalle ('O/M').

/* DEF VAR x-Zonas AS CHAR.                                                                              */
/* DEF VAR k AS INT.                                                                                     */
/*                                                                                                       */
/* FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia                                            */
/*     AND Faccpedi.coddoc = 'O/D'                                                                       */
/*     AND Faccpedi.divdes = s-coddiv                                                                    */
/*     AND ( Faccpedi.flgest = 'P' OR                                                                    */
/*           ( Faccpedi.flgest = 'C' AND Faccpedi.fchped = TODAY ) )                                     */
/*     BY Faccpedi.FchPed BY Faccpedi.Hora:                                                              */
/*     /* Cargamos las ZONAS de los productos */                                                         */
/*     ASSIGN                                                                                            */
/*         x-Zonas = ''.                                                                                 */
/*     FOR EACH facdpedi OF faccpedi NO-LOCK,                                                            */
/*         FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = Facdpedi.codcia                                */
/*         AND Almmmate.codalm = Facdpedi.almdes                                                         */
/*         AND Almmmate.codmat = Facdpedi.codmat,                                                        */
/*         FIRST Almtubic OF Almmmate NO-LOCK                                                            */
/*         BREAK BY Facdpedi.almdes BY Almtubic.codzona:                                                 */
/*         IF FIRST-OF(Facdpedi.AlmDes) OR FIRST-OF(Almtubic.codzona)                                    */
/*             THEN IF x-Zonas = ''                                                                      */
/*                 THEN x-Zonas = TRIM(Facdpedi.almdes) + ',' + TRIM(Almtubic.codzona).                  */
/*                 ELSE x-Zonas = x-Zonas + '|'  + TRIM(Facdpedi.almdes) + ',' + TRIM(Almtubic.codzona). */
/*     END.                                                                                              */
/*     DO k = 1 TO NUM-ENTRIES(x-Zonas, '|'):                                                            */
/*         CREATE CPEDI.                                                                                 */
/*         BUFFER-COPY Faccpedi TO CPEDI.                                                                */
/*         /* Determinamos la prioridad */                                                               */
/*         IF CPEDI.Libre_d01 = 0 THEN CPEDI.Libre_d01 = 2.  /* Normal */                                */
/*         /* Almacén, División y # de Items */                                                          */
/*         ASSIGN                                                                                        */
/*             CPEDI.CodAlm = ENTRY(1, ENTRY(k, x-Zonas, '|'))                                           */
/*             CPEDI.Libre_c04 = ENTRY(2, ENTRY(k, x-Zonas, '|')).                                       */
/*         ASSIGN                                                                                        */
/*             CPEDI.Libre_d02 = 0                                                                       */
/*             CPEDI.ImpTot = 0.                                                                         */
/*         FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.almdes = CPEDI.CodAlm:                   */
/*             CPEDI.Libre_d02 = CPEDI.Libre_d02 + 1.                                                    */
/*             CPEDI.ImpTot = CPEDI.ImpTot + Facdpedi.ImpLin.                                            */
/*         END.                                                                                          */
/*         /* Determinamos Situación */                                                                  */
/*         FIND LAST CpeTareas WHERE CpeTareas.CodCia = s-codcia                                         */
/*             AND CpeTareas.CodDiv = s-coddiv                                                           */
/*             AND CpeTareas.FlgEst = 'P'                                                                */
/*             AND CpeTareas.NroOD = Faccpedi.NroPed                                                     */
/*             AND CpeTareas.CodAlm = CPEDI.CodAlm                                                       */
/*             AND CpeTareas.CodZona = CPEDI.Libre_c04                                                   */
/*             NO-LOCK NO-ERROR.                                                                         */
/*         IF AVAILABLE CpeTareas                                                                        */
/*         THEN ASSIGN                                                                                   */
/*                 CPEDI.Libre_c02 = 'Asignado'                                                          */
/*                 CPEDI.Libre_c05 = fNomPer(CpeTareas.CodPer).                                          */
/*         ELSE ASSIGN                                                                                   */
/*                 CPEDI.Libre_c02 = 'No Asignado'                                                       */
/*                 CPEDI.Libre_c05 = ''.                                                                 */
/*         /* Determinamos Ubicación */                                                                  */
/*         EMPTY TEMP-TABLE tDetalle.                                                                    */
/*         FOR EACH CpeTrkTar NO-LOCK WHERE CpeTrkTar.CodCia = s-codcia                                  */
/*             AND CpeTrkTar.CodDiv = s-coddiv                                                           */
/*             AND CpeTrkTar.NroOD = Faccpedi.NroPed                                                     */
/*             AND CpeTrkTar.CodAlm = CPEDI.CodAlm                                                       */
/*             AND CpeTrkTar.CodZona = CPEDI.Libre_c04,                                                  */
/*             FIRST CpeTraSed NO-LOCK WHERE CpeTraSed.CodCia = s-codcia                                 */
/*             AND CpeTraSed.CodDiv = s-coddiv                                                           */
/*             AND CpeTraSed.CodPer = CpeTrkTar.CodPer                                                   */
/*             AND CpeTraSed.FlgEst = 'P'                                                                */
/*             BY CpeTrkTar.Fecha:                                                                       */
/*             FIND tDetalle WHERE tDetalle.codper = cpetrktar.codper NO-ERROR.                          */
/*             IF NOT AVAILABLE tDetalle THEN CREATE tDetalle.                                           */
/*             ASSIGN                                                                                    */
/*                 tDetalle.CodArea = CpeTraSed.CodArea                                                  */
/*                 tDetalle.CodPer = CpeTraSed.CodPer                                                    */
/*                 tDetalle.Fecha = CpeTrkTar.Fecha                                                      */
/*                 tDetalle.Estado = CpeTrkTar.Estado.                                                   */
/*         END.                                                                                          */
/*         CPEDI.Libre_c03 = 'Almacén'.                                                                  */
/*         FIND LAST tDetalle WHERE tDetalle.Estado = 'Tarea Asignada' NO-ERROR.                         */
/*         IF AVAILABLE tDetalle THEN DO:                                                                */
/*             /* Tiene una tarea asignada */                                                            */
/*             IF tDetalle.CodArea = 'DIS' THEN CPEDI.Libre_c03 = 'Distribución'.                        */
/*             IF tDetalle.CodArea = 'ALM' THEN CPEDI.Libre_c03 = 'Almacén'.                             */
/*         END.                                                                                          */
/*         ELSE DO:                                                                                      */
/*             FIND LAST tDetalle WHERE tDetalle.Estado = 'Tarea Cerrada' NO-ERROR.                      */
/*             IF AVAILABLE tDetalle THEN DO:                                                            */
/*                 /* Tiene una tarea asignada */                                                        */
/*                 IF tDetalle.CodArea = 'DIS' THEN CPEDI.Libre_c03 = 'Entrega'.                         */
/*                 IF tDetalle.CodArea = 'ALM' THEN CPEDI.Libre_c03 = 'Distribución'.                    */
/*             END.                                                                                      */
/*         END.                                                                                          */
/*     END.                                                                                              */
/* END.                                                                                                  */

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

DEF VAR x-Zonas AS CHAR.
DEF VAR k AS INT.

FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddoc = pCodDoc 
    AND Faccpedi.divdes = s-coddiv
    /*AND ( Faccpedi.flgest = 'P' OR ( Faccpedi.flgest = 'C' AND Faccpedi.fchped >= (TODAY - 2) ) )*/
    AND ( Faccpedi.flgest = 'C' AND Faccpedi.fchped >= (TODAY - 2) )
    AND Faccpedi.FlgSit <> "C":
    /*BY Faccpedi.FchPed BY Faccpedi.Hora*/
    /* Cargamos las ZONAS de los productos */
    ASSIGN
        x-Zonas = ''.
    FOR EACH facdpedi OF faccpedi NO-LOCK,
        FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = Facdpedi.codcia
        AND Almmmate.codalm = Facdpedi.almdes
        AND Almmmate.codmat = Facdpedi.codmat,
        FIRST Almtubic OF Almmmate NO-LOCK
        BREAK BY Facdpedi.almdes BY Almtubic.codzona:
        IF FIRST-OF(Facdpedi.AlmDes) OR FIRST-OF(Almtubic.codzona) 
            THEN IF x-Zonas = ''
                THEN x-Zonas = TRIM(Facdpedi.almdes) + ',' + TRIM(Almtubic.codzona).
                ELSE x-Zonas = x-Zonas + '|'  + TRIM(Facdpedi.almdes) + ',' + TRIM(Almtubic.codzona).
    END.
    DO k = 1 TO NUM-ENTRIES(x-Zonas, '|'):
        CREATE CPEDI.
        BUFFER-COPY Faccpedi TO CPEDI.
        /* Determinamos la prioridad */
        IF CPEDI.Libre_d01 = 0 THEN CPEDI.Libre_d01 = 2.  /* Normal */
        /* Almacén, División y # de Items */
        ASSIGN
            CPEDI.CodAlm = ENTRY(1, ENTRY(k, x-Zonas, '|'))
            CPEDI.Libre_c04 = ENTRY(2, ENTRY(k, x-Zonas, '|')).
        ASSIGN
            CPEDI.Libre_d02 = 0
            CPEDI.ImpTot = 0.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.almdes = CPEDI.CodAlm,
            FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = Facdpedi.codcia
            AND Almmmate.codalm = Facdpedi.almdes
            AND Almmmate.codmat = Facdpedi.codmat,
            FIRST Almtubic OF Almmmate NO-LOCK WHERE Almtubic.CodZona = CPEDI.Libre_c04:
            CPEDI.Libre_d02 = CPEDI.Libre_d02 + 1.
            CPEDI.ImpTot = CPEDI.ImpTot + Facdpedi.ImpLin.
        END.
        /* Determinamos Situación */
        FIND LAST CpeTareas WHERE CpeTareas.CodCia = s-codcia
            AND CpeTareas.CodDiv = s-coddiv
            AND CpeTareas.FlgEst = 'P'
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

OCXFile = SEARCH( "wcon003big.wrx":U ).
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
ELSE MESSAGE "wcon003big.wrx":U SKIP(1)
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
  VIEW FRAME fMain IN WINDOW wWin.
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

  IF CPEDI.Libre_d01 = 1 THEN RETURN 'A'.
  IF CPEDI.Libre_d01 = 2 THEN RETURN 'N'.
  IF CPEDI.Libre_d01 = 3 THEN RETURN 'B'.
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

