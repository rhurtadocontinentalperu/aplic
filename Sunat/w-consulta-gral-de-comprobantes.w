&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEF INPUT PARAMETER pParam AS CHAR.
/* Sintaxis: TTTTTTT,LOG
    Donde:
        Tipo de Reporte: TTTTTTT = 'ORIGEN' o 'EMISION'
        Puede seleccionar una o mas divisiones: LOG = YES o NO
*/        
IF NUM-ENTRIES(pParam) <> 2 THEN RETURN ERROR.

DEF VAR x-TipoReporte AS CHAR NO-UNDO.
DEF VAR x-Acceso-Total AS LOG NO-UNDO.

ASSIGN
    x-TipoReporte = ENTRY(1,pParam)
    x-Acceso-Total = LOGICAL(ENTRY(2,pParam))
    NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN RETURN ERROR.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-CodCia AS INTE.
DEF SHARED VAR s-CodDiv AS CHAR.

DEF VAR x-CodDiv AS CHAR NO-UNDO.
DEF VAR x-DivOri AS CHAR NO-UNDO.
DEF VAR x-CodDoc AS CHAR NO-UNDO.
DEF VAR x-Documentos AS CHAR NO-UNDO.
DEF VAR x-Est AS CHAR NO-UNDO.
DEF VAR x-Mon AS CHAR NO-UNDO.

x-Documentos = ''.
FOR EACH FacDocum NO-LOCK WHERE FacDocum.CodCia = s-CodCia AND FacDocum.TpoDoc <> ?:
    x-Documentos = x-Documentos + (IF TRUE <> (x-Documentos > '') THEN '' ELSE ',') + FacDocum.CodDoc.
END.
x-CodDoc = x-Documentos.

CASE x-TipoReporte:
    WHEN 'ORIGEN'  THEN x-DivOri = s-CodDiv.
    WHEN 'EMISION' THEN x-CodDiv = s-CodDiv.
END CASE.

&SCOPED-DEFINE Condicion ( ~
                           CcbCDocu.CodCia = s-CodCia AND ~
                           ( TRUE <> (x-CodDiv > '') OR LOOKUP(CcbCDocu.CodDiv, x-CodDiv) > 0) AND ~
                           ( TRUE <> (x-DivOri > '') OR LOOKUP(CcbCDocu.DivOri, EDITOR_Divisiones) > 0) AND ~
                           LOOKUP(CcbCDocu.CodDoc, x-CodDoc) > 0 AND ~
                           CcbCDocu.FchDoc >= FILL-IN_FchDoc-1 AND ~
                           CcbCDocu.FchDoc <= FILL-IN_FchDoc-2 AND ~
                           (COMBO-BOX_Estado = 'Todos' OR CcbCDocu.FlgEst = COMBO-BOX_Estado) AND ~
                           (COMBO-BOX_FmaPgo = 'Todos' OR CcbCDocu.FmaPgo = COMBO-BOX_FmaPgo) AND ~
                           ( TRUE <> (FILL-IN_CodCli > '') OR CcbCDocu.CodCli = FILL-IN_CodCli) AND ~
                           ( TRUE <> (FILL-IN_NomCli > '') OR INDEX(CcbCDocu.NomCli, FILL-IN_NomCli) > 0)  ~
                           )

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 fEstado() @ X-EST CcbCDocu.FchDoc ~
CcbCDocu.CodDiv CcbCDocu.DivOri CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.FmaPgo CcbCDocu.CodVen ~
CcbCDocu.FchCan (IF CcbCDocu.CodMon = 1 THEN 'S/.' ELSE 'US$') @ x-Mon ~
CcbCDocu.ImpTot CcbCDocu.SdoAct CcbCDocu.NroSal 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH CcbCDocu ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH CcbCDocu ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 CcbCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON_Filtrar FILL-IN_FchDoc-1 ~
FILL-IN_FchDoc-2 COMBO-BOX_CodDoc COMBO-BOX_Estado COMBO-BOX_FmaPgo ~
FILL-IN_CodCli FILL-IN_NomCli BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 ~
EDITOR_Divisiones COMBO-BOX_CodDoc COMBO-BOX_Estado COMBO-BOX_FmaPgo ~
FILL-IN_CodCli FILL-IN_NomCli 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado W-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Division 
     LABEL "..." 
     SIZE 4 BY .77 TOOLTIP "Selecciona Divisiones".

DEFINE BUTTON BUTTON_Filtrar 
     LABEL "APLICAR FILTRO" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX_CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Comprobante" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_Estado AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Estado" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos",
                     "Pendientes","P",
                     "Cancelados","C",
                     "Anulados","A"
     DROP-DOWN-LIST
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_FmaPgo AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Condición de Venta" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 30 BY .81 NO-UNDO.

DEFINE VARIABLE EDITOR_Divisiones AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 74 BY 4.85 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCli AS CHARACTER FORMAT "x(15)":U 
     LABEL "Código del Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre del Cliente" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 189 BY 5.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      fEstado() @ X-EST COLUMN-LABEL "Estado" FORMAT "x(15)":U
      CcbCDocu.FchDoc COLUMN-LABEL "Fecha!Emisión" FORMAT "99/99/9999":U
      CcbCDocu.CodDiv COLUMN-LABEL "División" FORMAT "x(5)":U WIDTH 5.72
      CcbCDocu.DivOri FORMAT "x(5)":U
      CcbCDocu.CodDoc COLUMN-LABEL "Tipo" FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(12)":U WIDTH 9.72
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 12
      CcbCDocu.NomCli FORMAT "x(100)":U WIDTH 78.14
      CcbCDocu.FmaPgo COLUMN-LABEL "Condicion!de venta" FORMAT "X(8)":U
      CcbCDocu.CodVen FORMAT "x(10)":U
      CcbCDocu.FchCan FORMAT "99/99/9999":U
      (IF CcbCDocu.CodMon = 1 THEN 'S/.' ELSE 'US$') @ x-Mon COLUMN-LABEL "Mon." FORMAT "x(4)":U
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U
      CcbCDocu.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->>,>>>,>>9.99":U
      CcbCDocu.NroSal COLUMN-LABEL "Numero Unico" FORMAT "X(15)":U
            WIDTH 15
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 189 BY 17.23
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON_Filtrar AT ROW 1.54 COL 174 WIDGET-ID 94
     FILL-IN_FchDoc-1 AT ROW 1.81 COL 109 COLON-ALIGNED WIDGET-ID 84
     FILL-IN_FchDoc-2 AT ROW 1.81 COL 129 COLON-ALIGNED WIDGET-ID 86
     EDITOR_Divisiones AT ROW 2.08 COL 6 NO-LABEL WIDGET-ID 78
     BUTTON-Division AT ROW 2.08 COL 81 WIDGET-ID 76
     COMBO-BOX_CodDoc AT ROW 2.88 COL 109 COLON-ALIGNED WIDGET-ID 88
     COMBO-BOX_Estado AT ROW 3.96 COL 109 COLON-ALIGNED WIDGET-ID 90
     COMBO-BOX_FmaPgo AT ROW 5.04 COL 109 COLON-ALIGNED WIDGET-ID 92
     FILL-IN_CodCli AT ROW 6.12 COL 109 COLON-ALIGNED WIDGET-ID 100
     FILL-IN_NomCli AT ROW 6.12 COL 137 COLON-ALIGNED WIDGET-ID 102
     BROWSE-2 AT ROW 7.46 COL 2 WIDGET-ID 200
     "FILTROS" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1 COL 3 WIDGET-ID 96
          BGCOLOR 1 FGCOLOR 15 
     "Seleccione una o más divisiones:" VIEW-AS TEXT
          SIZE 23 BY .5 AT ROW 1.54 COL 6 WIDGET-ID 82
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 98
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 26.15
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 26.15
         WIDTH              = 191.29
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
/* BROWSE-TAB BROWSE-2 FILL-IN_NomCli F-Main */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR BUTTON BUTTON-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR EDITOR_Divisiones IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.CcbCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > "_<CALC>"
"fEstado() @ X-EST" "Estado" "x(15)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbCDocu.FchDoc
"FchDoc" "Fecha!Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCDocu.CodDiv
"CodDiv" "División" ? "character" ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.CcbCDocu.DivOri
     _FldNameList[5]   > INTEGRAL.CcbCDocu.CodDoc
"CodDoc" "Tipo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCDocu.NroDoc
"NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CcbCDocu.CodCli
"CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbCDocu.NomCli
"NomCli" ? "x(100)" "character" ? ? ? ? ? ? no ? no no "78.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.CcbCDocu.FmaPgo
"FmaPgo" "Condicion!de venta" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = INTEGRAL.CcbCDocu.CodVen
     _FldNameList[11]   = INTEGRAL.CcbCDocu.FchCan
     _FldNameList[12]   > "_<CALC>"
"(IF CcbCDocu.CodMon = 1 THEN 'S/.' ELSE 'US$') @ x-Mon" "Mon." "x(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   = INTEGRAL.CcbCDocu.ImpTot
     _FldNameList[14]   > INTEGRAL.CcbCDocu.SdoAct
"SdoAct" "Saldo Actual" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.CcbCDocu.NroSal
"NroSal" "Numero Unico" "X(15)" "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON LEFT-MOUSE-DBLCLICK OF BROWSE-2 IN FRAME F-Main
DO:
    RUN sunat/d-consulta-comprobantes (Ccbcdocu.NroDoc,CcbcDocu.CodDoc).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON RIGHT-MOUSE-CLICK OF BROWSE-2 IN FRAME F-Main
DO:
    RUN VTA\D-cmpbt1.r(
        Ccbcdocu.CodDoc,
        CcbcDocu.NroDoc,
        CcbcDocu.NroPed,
        CcbcDocu.SdoAct,
        Ccbcdocu.Imptot,
        CcbcDocu.NroRef
        ).
/*     ASSIGN x-CodDiv.                           */
/*                                                */
/*     IF CAN-FIND(FIRST CCBDMOV WHERE            */
/*         CCBDMOV.codcia = s-codcia AND          */
/*         CCBDMOV.coddiv = x-CodDiv AND          */
/*         CCBDMOV.coddoc = Ccbcdocu.CodDoc AND   */
/*         CCBDMOV.nrodoc = Ccbcdocu.NroDoc) THEN */
/*         RUN VTA\D-cmpbt2.r(                    */
/*             Ccbcdocu.CodDoc,                   */
/*             CcbcDocu.NroDoc,                   */
/*             CcbcDocu.NroPed,                   */
/*             CcbcDocu.SdoAct,                   */
/*             Ccbcdocu.Imptot,                   */
/*             CcbcDocu.NroRef,                   */
/*             x-CodDiv                           */
/*             ).                                 */
/*     ELSE                                       */
/*         RUN VTA\D-cmpbt1.r(                    */
/*             Ccbcdocu.CodDoc,                   */
/*             CcbcDocu.NroDoc,                   */
/*             CcbcDocu.NroPed,                   */
/*             CcbcDocu.SdoAct,                   */
/*             Ccbcdocu.Imptot,                   */
/*             CcbcDocu.NroRef                    */
/*             ).                                 */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Division W-Win
ON CHOOSE OF BUTTON-Division IN FRAME F-Main /* ... */
DO:
    ASSIGN EDITOR_Divisiones.
    RUN gn/d-filtro-divisiones (INPUT-OUTPUT EDITOR_Divisiones, "SELECCIONE LAS DIVISIONES").
    DISPLAY EDITOR_Divisiones WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Filtrar W-Win
ON CHOOSE OF BUTTON_Filtrar IN FRAME F-Main /* APLICAR FILTRO */
DO:
  ASSIGN COMBO-BOX_CodDoc COMBO-BOX_Estado COMBO-BOX_FmaPgo EDITOR_Divisiones FILL-IN_CodCli FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 FILL-IN_NomCli.
  IF COMBO-BOX_CodDoc = 'Todos' 
  THEN x-CodDoc = x-Documentos.
  ELSE x-CodDoc = COMBO-BOX_CodDoc.
  x-DivOri = ''.
  x-CodDiv = ''.
  CASE x-TipoReporte:
      WHEN 'ORIGEN'  THEN x-DivOri = EDITOR_Divisiones.
      WHEN 'EMISION' THEN x-CodDiv = EDITOR_Divisiones.
  END CASE.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

CASE x-TipoReporte:
    WHEN 'ORIGEN'  THEN {&WINDOW-NAME}:TITLE = 'CONSULTA DE COMPROBANTES POR PUNTO DE ORIGEN'.
    WHEN 'EMISION' THEN {&WINDOW-NAME}:TITLE = 'CONSULTA DE COMPROBANTES POR PUNTO DE EMISION'.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  DISPLAY FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 EDITOR_Divisiones COMBO-BOX_CodDoc 
          COMBO-BOX_Estado COMBO-BOX_FmaPgo FILL-IN_CodCli FILL-IN_NomCli 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 BUTTON_Filtrar FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 
         COMBO-BOX_CodDoc COMBO-BOX_Estado COMBO-BOX_FmaPgo FILL-IN_CodCli 
         FILL-IN_NomCli BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  VIEW FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable W-Win 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      IF x-Acceso-Total = YES 
          THEN BUTTON-Division:SENSITIVE = YES.
      ELSE BUTTON-Division:SENSITIVE = NO.
  END.

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
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FILL-IN_FchDoc-1 = TODAY.
  FILL-IN_FchDoc-2 = TODAY.
  EDITOR_Divisiones = s-CodDiv.

  FOR EACH FacDocum NO-LOCK WHERE FacDocum.CodCia = s-CodCia
      AND FacDocum.TpoDoc <> ?:
      COMBO-BOX_CodDoc:ADD-LAST(FacDocum.CodDoc + " - " + FacDocum.NomDoc, FacDocum.CodDoc) IN FRAME {&FRAME-NAME}.
  END.
  FOR EACH gn-ConVt NO-LOCK WHERE gn-ConVt.Estado <> "I" WITH FRAME {&FRAME-NAME}:
      COMBO-BOX_FmaPgo:ADD-LAST(gn-ConVt.Codig + " - " + gn-ConVt.Nombr, gn-ConVt.Codig).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "CcbCDocu"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado W-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pEstado AS CHAR.

RUN gn/fFlgEstCCBv2 (ccbcdocu.coddoc,
                     ccbcdocu.flgest,
                     OUTPUT pEstado).
RETURN pEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

