&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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

/* Local Variable Definitions ---                                       */

DEFINE NEW SHARED VAR ltxtDesde AS DATE.
DEFINE NEW SHARED VAR ltxtHasta AS DATE.
DEFINE NEW SHARED VAR lChequeados AS LOGICAL.
DEFINE NEW SHARED VAR pSoloImpresos AS LOGICAL.
DEFINE NEW SHARED VAR s-CodDoc AS CHAR INIT 'O/D'.
DEFINE NEW SHARED VAR pOrdenCompra AS CHAR INIT ''.  /* Supermercados Peruanos */
DEFINE NEW SHARED VAR s-busqueda AS CHAR.
DEFINE NEW SHARED VAR s-nro-orden AS CHAR.
DEFINE NEW SHARED VAR i-tipo-busqueda AS INT.
DEFINE NEW SHARED VAR i-dias AS INT.

DEFINE NEW SHARED VAR x-pendientes-impresion AS INT.
DEFINE NEW SHARED VAR x-pickeado AS INT.

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW SHARED VARIABLE lMsgRetorno  AS CHAR.

DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcia AS INT.

ltxtDesde = DATE(STRING(TODAY - 5,"99/99/9999")).
ltxtHasta = DATE(STRING(TODAY,"99/99/9999")).
s-CodDoc = "".
s-nro-orden = "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] ~
tt-w-report.Campo-C[5] tt-w-report.Campo-C[6] tt-w-report.Campo-C[7] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-dias rdsMostrar rdsPickeado ~
BUTTON-16 ChkboxSort RADIO-SET-CodDoc txtDesde txtHasta txtOrdenCompra ~
rsSectores txtOrden BUTTON-13 txtCliente cboCanal cboZona cboSubZona ~
BtnExcel RADIO-SET-1 BUTTON-14 BROWSE-5 BUTTON-15 BtnDone BUTTON-17 RECT-1 ~
RECT-2 RECT-4 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-dias rdsMostrar rdsPickeado ~
ChkboxSort RADIO-SET-CodDoc txtDesde txtHasta txtOrdenCompra rsSectores ~
txtOrden txtCliente cboCanal cboZona cboSubZona RADIO-SET-1 txtSectores ~
txtSectoresImprimir txtLeyenda txtArtSinPeso 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-dimprime-od AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-picking-ordenes-todos AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BtnExcel 
     LABEL "EXCEL" 
     SIZE 14 BY 1.12.

DEFINE BUTTON BUTTON-13 
     LABEL "CARGAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-14 
     LABEL "TXT Cabecera Detalle" 
     SIZE 21 BY 1.15.

DEFINE BUTTON BUTTON-15 
     LABEL "Imprimir ORDEN." 
     SIZE 17.86 BY 1.12.

DEFINE BUTTON BUTTON-16 
     LABEL "Filtrar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-17 
     LABEL "Imprimir ORDEN seleccionadas" 
     SIZE 29 BY 1.12.

DEFINE VARIABLE cboCanal AS CHARACTER FORMAT "X(100)":U 
     LABEL "Canal" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE cboSubZona AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-Zona" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE cboZona AS CHARACTER FORMAT "X(100)":U 
     LABEL "Zona" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-dias AS INTEGER FORMAT ">>,>>9":U INITIAL 15 
     LABEL "de los ultimos" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .81 NO-UNDO.

DEFINE VARIABLE txtArtSinPeso AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 97 BY 1
     FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCliente AS CHARACTER FORMAT "X(60)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE txtLeyenda AS CHARACTER FORMAT "X(150)":U 
     VIEW-AS FILL-IN 
     SIZE 109.86 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 10 NO-UNDO.

DEFINE VARIABLE txtOrden AS CHARACTER FORMAT "X(12)":U 
     LABEL "No. Orden" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .81 NO-UNDO.

DEFINE VARIABLE txtOrdenCompra AS CHARACTER FORMAT "X(15)":U 
     LABEL "O/C Sup.Mercados Peruanos" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .81 NO-UNDO.

DEFINE VARIABLE txtSectores AS CHARACTER FORMAT "X(25)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY 1.27
     BGCOLOR 15 FGCOLOR 12 FONT 8 NO-UNDO.

DEFINE VARIABLE txtSectoresImprimir AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.57 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Solo Cabeceras", 1,
"Cabecera y Detalle", 2
     SIZE 16 BY 1.15
     FONT 4 NO-UNDO.

DEFINE VARIABLE RADIO-SET-CodDoc AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Orden de Despacho (O/D)", "O/D",
"Orden de Mostrador (O/M)", "O/M",
"Orden de Transferencia (OTR)", "OTR",
"Todos", "Todos"
     SIZE 91 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE rdsMostrar AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pendientes Impresion", 1,
"Impresos", 2,
"Todos", 3
     SIZE 38 BY .77 NO-UNDO.

DEFINE VARIABLE rdsPickeado AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "x Pickear", 1,
"Pickeado", 2,
"Todos", 3
     SIZE 12 BY 2.15 NO-UNDO.

DEFINE VARIABLE rsSectores AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ambos", 1,
"x Asignar", 2,
"Todos asigandos", 3
     SIZE 38 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 1.62.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 1.04.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 120 BY 3.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 153 BY 1.08.

DEFINE VARIABLE ChkboxSort AS LOGICAL INITIAL no 
     LABEL "Sort acumulativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Sec!Tor" FORMAT "X(3)":U
            WIDTH 5
      tt-w-report.Campo-C[2] COLUMN-LABEL "User!Sacado" FORMAT "X(10)":U
            WIDTH 9.43
      tt-w-report.Campo-C[3] COLUMN-LABEL "Fec/Hora!Sacado" FORMAT "X(15)":U
            WIDTH 14.72
      tt-w-report.Campo-C[4] COLUMN-LABEL "Fec/Hora!Recep." FORMAT "X(15)":U
      tt-w-report.Campo-C[5] COLUMN-LABEL "Zona!Pickeo" FORMAT "X(4)":U
      tt-w-report.Campo-C[6] COLUMN-LABEL "User!Asigna" FORMAT "X(10)":U
      tt-w-report.Campo-C[7] COLUMN-LABEL "User!Recepc." FORMAT "X(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 40.86 BY 7.69
         FONT 4 ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-dias AT ROW 2.88 COL 96.43 COLON-ALIGNED WIDGET-ID 110
     rdsMostrar AT ROW 2.58 COL 47 NO-LABEL WIDGET-ID 100
     rdsPickeado AT ROW 2.35 COL 108 NO-LABEL WIDGET-ID 104
     BUTTON-16 AT ROW 4.77 COL 140 WIDGET-ID 96
     ChkboxSort AT ROW 4.04 COL 127 WIDGET-ID 98
     RADIO-SET-CodDoc AT ROW 1.5 COL 12.86 NO-LABEL WIDGET-ID 36
     txtDesde AT ROW 2.38 COL 9 COLON-ALIGNED WIDGET-ID 16
     txtHasta AT ROW 2.35 COL 29 COLON-ALIGNED WIDGET-ID 20
     txtOrdenCompra AT ROW 3.15 COL 29 COLON-ALIGNED WIDGET-ID 48
     rsSectores AT ROW 3.77 COL 47 NO-LABEL WIDGET-ID 66
     txtOrden AT ROW 3.81 COL 93.29 COLON-ALIGNED WIDGET-ID 74
     BUTTON-13 AT ROW 1.27 COL 106 WIDGET-ID 4
     txtCliente AT ROW 4.88 COL 8 COLON-ALIGNED WIDGET-ID 76
     cboCanal AT ROW 4.88 COL 49.29 COLON-ALIGNED WIDGET-ID 86
     cboZona AT ROW 4.85 COL 78.29 COLON-ALIGNED WIDGET-ID 88
     cboSubZona AT ROW 4.81 COL 111 COLON-ALIGNED WIDGET-ID 90
     BtnExcel AT ROW 2.54 COL 123 WIDGET-ID 34
     RADIO-SET-1 AT ROW 2.54 COL 138 NO-LABEL WIDGET-ID 28
     BUTTON-14 AT ROW 1.08 COL 130 WIDGET-ID 52
     BROWSE-5 AT ROW 15.04 COL 114.14 WIDGET-ID 200
     txtSectores AT ROW 23.92 COL 112.43 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     txtSectoresImprimir AT ROW 26.08 COL 113 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     txtLeyenda AT ROW 25.5 COL 2 NO-LABEL WIDGET-ID 64
     BUTTON-15 AT ROW 27.38 COL 129.29 WIDGET-ID 62
     BtnDone AT ROW 26.92 COL 148 WIDGET-ID 10
     txtArtSinPeso AT ROW 27.46 COL 2 NO-LABEL WIDGET-ID 24
     BUTTON-17 AT ROW 27.42 COL 100 WIDGET-ID 108
     "  Filtros de Carga" VIEW-AS TEXT
          SIZE 19 BY .62 AT ROW 1 COL 3.57 WIDGET-ID 82
          FGCOLOR 9 FONT 0
     "Sectores de la ORDEN" VIEW-AS TEXT
          SIZE 28.72 BY .77 AT ROW 23.08 COL 116.29 WIDGET-ID 60
          FGCOLOR 9 FONT 9
     "Filtrar por:" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 1.65 COL 3.72 WIDGET-ID 40
     "Lista de Articulos que NO tienen PESO en la O/D" VIEW-AS TEXT
          SIZE 43.14 BY .62 AT ROW 26.85 COL 2 WIDGET-ID 26
          BGCOLOR 15 FGCOLOR 9 FONT 6
     "Sectores a IMPRIMIR" VIEW-AS TEXT
          SIZE 28.72 BY .81 AT ROW 25.27 COL 116.29 WIDGET-ID 56
          FGCOLOR 4 FONT 9
     "  Sectores" VIEW-AS TEXT
          SIZE 9.57 BY .62 AT ROW 3.27 COL 46.72 WIDGET-ID 72
          FGCOLOR 4 FONT 6
     "  Filtros de impresion" VIEW-AS TEXT
          SIZE 25 BY .62 AT ROW 4.23 COL 3 WIDGET-ID 94
          FGCOLOR 9 FONT 0
     "Emitidos" VIEW-AS TEXT
          SIZE 6.86 BY .5 AT ROW 2.46 COL 89.86 WIDGET-ID 112
     "dias" VIEW-AS TEXT
          SIZE 3.57 BY .5 AT ROW 3.04 COL 102.14 WIDGET-ID 114
     RECT-1 AT ROW 2.31 COL 122 WIDGET-ID 32
     RECT-2 AT ROW 3.65 COL 46.29 WIDGET-ID 70
     RECT-4 AT ROW 1.27 COL 2 WIDGET-ID 84
     RECT-5 AT ROW 4.77 COL 2 WIDGET-ID 92
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 154.57 BY 27.69
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONTROL DE IMPRESION DE ORDENES PARA PICKING"
         HEIGHT             = 27.69
         WIDTH              = 154.57
         MAX-HEIGHT         = 28.35
         MAX-WIDTH          = 159.43
         VIRTUAL-HEIGHT     = 28.35
         VIRTUAL-WIDTH      = 159.43
         MAX-BUTTON         = no
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-5 BUTTON-14 F-Main */
/* SETTINGS FOR FILL-IN txtArtSinPeso IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txtLeyenda IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txtSectores IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtSectoresImprimir IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Sec!Tor" "X(3)" "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "User!Sacado" "X(10)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Fec/Hora!Sacado" "X(15)" "character" ? ? ? ? ? ? no ? no no "14.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Fec/Hora!Recep." "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "Zona!Pickeo" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[6]
"tt-w-report.Campo-C[6]" "User!Asigna" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[7]
"tt-w-report.Campo-C[7]" "User!Recepc." "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME F-Main:HANDLE
       ROW             = 21.19
       COLUMN          = 139
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 2
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      RUN adjust-tab-order IN adm-broker-hdl ( h_b-dimprime-od , CtrlFrame , 'BEFORE':U ).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONTROL DE IMPRESION DE ORDENES PARA PICKING */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONTROL DE IMPRESION DE ORDENES PARA PICKING */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnExcel W-Win
ON CHOOSE OF BtnExcel IN FRAME F-Main /* EXCEL */
DO:
  ASSIGN RADIO-SET-1.     
  CASE RADIO-SET-1:
      WHEN 1 THEN RUN envia-excel IN h_b-picking-ordenes-todos.
      WHEN 2 THEN RUN envia-excel-detalle IN h_b-picking-ordenes-todos.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* CARGAR */
DO:
    ASSIGN txtDesde txtHasta txtOrdenCompra rsSectores txtOrden 
        RADIO-SET-Coddoc rdsMostrar rdsPickeado fill-in-dias.

    ltxtDesde = txtDesde.
    ltxtHasta = txtHasta.    
    pOrdenCompra = TRIM(txtOrdenCompra).
    i-tipo-busqueda = rsSectores.
    s-nro-orden = txtOrden.
    s-CodDoc = RADIO-SET-Coddoc.
    x-pendientes-impresion = rdsMostrar.
    x-pickeado = rdsPickeado.
    i-dias = fill-in-dias.

    RUN carga-combos("RESET-ALL","","").

    RUN dispatch IN h_b-picking-ordenes-todos ('open-query':U).
    RUN Procesa-Handle IN lh_handle ('Enable-Buttons').

    RUN muestra-totales IN h_b-picking-ordenes-todos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-14 W-Win
ON CHOOSE OF BUTTON-14 IN FRAME F-Main /* TXT Cabecera Detalle */
DO:
    RUN ue-envia-txt-detalle IN h_b-picking-ordenes-todos.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 W-Win
ON CHOOSE OF BUTTON-15 IN FRAME F-Main /* Imprimir ORDEN. */
DO:
    ASSIGN txtSectoresImprimir txtSectores.

    RUN ue-imprimir-subordenes IN h_b-picking-ordenes-todos(INPUT txtSectoresImprimir, INPUT txtSectores, INPUT 1).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-16 W-Win
ON CHOOSE OF BUTTON-16 IN FRAME F-Main /* Filtrar */
DO:

  ASSIGN txtCliente cboCanal cboZona cboSubzona.

  RUN filtar-datos IN h_b-picking-ordenes-todos(txtCliente, cboCanal, cboZona, cboSubZona).
  RUN muestra-totales IN h_b-picking-ordenes-todos.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-17
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-17 W-Win
ON CHOOSE OF BUTTON-17 IN FRAME F-Main /* Imprimir ORDEN seleccionadas */
DO:
    ASSIGN txtSectoresImprimir txtSectores.

    RUN imprimir-ordenes-masa IN h_b-picking-ordenes-todos.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cboZona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cboZona W-Win
ON VALUE-CHANGED OF cboZona IN FRAME F-Main /* Zona */
DO:
    ASSIGN {&SELF-name}.

    RUN carga-combos("RESET-SUBZONA","","").

    DEFINE VAR x-zona AS CHAR.

    x-zona = cboZona.

  IF x-zona <> 'Todos' THEN DO:
      FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia
          AND VtaDTabla.Tabla = "SZGHR"
          AND VtaDTabla.Llave = x-zona
          AND VtaDTabla.LlaveDetalle = "C":

          RUN carga-combos("SUBZONA",VtaDTabla.tipo, VtaDTabla.Libre_c02).
          
      END.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ChkboxSort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ChkboxSort W-Win
ON VALUE-CHANGED OF ChkboxSort IN FRAME F-Main /* Sort acumulativo */
DO:
  
    ASSIGN {&SELF-name}.

    RUN SORT-acumulativo IN h_b-picking-ordenes-todos(INPUT ChkBoxSort).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame W-Win OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

     RUN dispatch IN h_b-picking-ordenes-todos ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-CodDoc W-Win
ON VALUE-CHANGED OF RADIO-SET-CodDoc IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  s-CodDoc = {&self-name}.
  /*RUN dispatch IN h_b-picking-ordenes-todos ('open-query':U).*/
  CASE s-CodDoc:
      WHEN "O/D" OR WHEN "O/M" THEN DO:
      END.
      WHEN "OTR" THEN DO:
      END.
  END CASE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/b-listado-picking-ordenes-todos-suborden-v2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = FchPed':U ,
             OUTPUT h_b-picking-ordenes-todos ).
       RUN set-position IN h_b-picking-ordenes-todos ( 5.85 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-picking-ordenes-todos ( 9.15 , 153.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/b-dimprime-od-v2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-dimprime-od ).
       RUN set-position IN h_b-dimprime-od ( 15.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-dimprime-od ( 10.58 , 111.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-dimprime-od. */
       RUN add-link IN adm-broker-hdl ( h_b-picking-ordenes-todos , 'Record':U , h_b-dimprime-od ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-picking-ordenes-todos ,
             rdsMostrar:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-dimprime-od ,
             BROWSE-5:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-combos W-Win 
PROCEDURE carga-combos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodCombo AS CHAR.
DEFINE INPUT PARAMETER pCodData AS CHAR.
DEFINE INPUT PARAMETER pDesData AS CHAR.

DEFINE VAR x-indx AS INT.

DO WITH FRAME {&FRAME-NAME}.
    IF pCodCombo = 'RESET-ALL' OR pCodCombo = 'RESET-CANAL' THEN DO:
        REPEAT WHILE CboCanal:NUM-ITEMS > 0:
          CboCanal:DELETE(1).
        END.
        cboCanal:ADD-LAST('Todos','Todos').
        cboCanal:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.
    END.
    IF pCodCombo = 'RESET-ALL' OR pCodCombo = 'RESET-ZONA' THEN DO:
        REPEAT WHILE CboZona:NUM-ITEMS > 0:
          cboZona:DELETE(1).
        END.
        cboZona:ADD-LAST('Todos','Todos').
        cboZona:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.
    END.
    IF pCodCombo = 'RESET-ALL' OR pCodCombo = 'RESET-SUBZONA' THEN DO:
        REPEAT WHILE cboSubZona:NUM-ITEMS > 0:
          cboSubZona:DELETE(1).
        END.
        cboSubZona:ADD-LAST('Todos','Todos').
        cboSubZona:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.
    END.
END.

IF pCodCombo = 'CANAL' THEN DO:
    x-indx = cboCanal:LOOKUP(pCodData).
    IF x-indx <= 0 THEN cboCanal:ADD-LAST(pDesData, pCodData).
END.
IF pCodCombo = 'ZONA' THEN DO:
    x-indx = cboZona:LOOKUP(pCodData).
    IF x-indx <= 0 THEN cboZona:ADD-LAST(pDesData, pCodData).
END.
IF pCodCombo = 'SUBZONA' THEN DO:
    x-indx = cboSubZona:LOOKUP(pCodData).
    IF x-indx <= 0 THEN cboSubZona:ADD-LAST(pDesData, pCodData).
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load W-Win  _CONTROL-LOAD
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

OCXFile = SEARCH( "w-listado-picking-ordenes-subordenes-v2.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "w-listado-picking-ordenes-subordenes-v2.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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
  DISPLAY FILL-IN-dias rdsMostrar rdsPickeado ChkboxSort RADIO-SET-CodDoc 
          txtDesde txtHasta txtOrdenCompra rsSectores txtOrden txtCliente 
          cboCanal cboZona cboSubZona RADIO-SET-1 txtSectores 
          txtSectoresImprimir txtLeyenda txtArtSinPeso 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-dias rdsMostrar rdsPickeado BUTTON-16 ChkboxSort 
         RADIO-SET-CodDoc txtDesde txtHasta txtOrdenCompra rsSectores txtOrden 
         BUTTON-13 txtCliente cboCanal cboZona cboSubZona BtnExcel RADIO-SET-1 
         BUTTON-14 BROWSE-5 BUTTON-15 BtnDone BUTTON-17 RECT-1 RECT-2 RECT-4 
         RECT-5 
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
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      txtDesde:SCREEN-VALUE IN FRAME {&frame-name} = STRING(TODAY - 15,"99/99/9999").
      txtHasta:SCREEN-VALUE IN FRAME {&frame-name} = STRING(TODAY + 15,"99/99/9999").

      IF s-coddiv = '00065' THEN DO:
          s-CodDoc = 'O/M'.
          RADIO-SET-CodDoc:SCREEN-VALUE = 'O/M'.
      END.

      REPEAT WHILE CboCanal:NUM-ITEMS > 0:
        CboCanal:DELETE(1).
      END.
      REPEAT WHILE CboZona:NUM-ITEMS > 0:
        cboZona:DELETE(1).
      END.
      REPEAT WHILE cboSubZona:NUM-ITEMS > 0:
        cboSubZona:DELETE(1).
      END.

    CboCanal:ADD-LAST('Todos','Todos').
    CboZona:ADD-LAST('Todos','Todos').
    CboSubZona:ADD-LAST('Todos','Todos').

    CboCanal:SCREEN-VALUE = 'Todos'.
    CboZona:SCREEN-VALUE = 'Todos'.
    CboSubZona:SCREEN-VALUE = 'Todos'.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pParametro AS CHAR.

CASE pParametro:
    WHEN "Disable-Buttons" THEN DO WITH FRAME {&FRAME-NAME}:
         /*BUTTON-Alfabeticamente:SENSITIVE = NO.*/
         BtnExcel:SENSITIVE = NO.
    END.
    WHEN "Enable-Buttons" THEN DO WITH FRAME {&FRAME-NAME}:
         /*BUTTON-Alfabeticamente:SENSITIVE = YES.*/
         BtnExcel:SENSITIVE = YES.
    END.
    WHEN 'ue-pinta-referencia' THEN DO:
        txtArtSinPeso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
        txtArtSinPeso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lMsgRetorno.

            END.
END CASE.
IF pParametro="Enable-Buttons" THEN DO:
    txtArtSinPeso:SCREEN-VALUE = lMsgRetorno.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
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
  {src/adm/template/snd-list.i "tt-w-report"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-guia-hruta W-Win 
PROCEDURE ue-guia-hruta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-CodDoc AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER p-NroDoc AS CHAR    NO-UNDO.

EMPTY TEMP-TABLE tt-w-report.

DEFINE BUFFER i-faccpedi FOR faccpedi.
DEFINE BUFFER i-ccbcdocu FOR ccbcdocu.

SESSION:SET-WAIT-STATE('GENERAL').

/*FIND FIRST i-faccpedi WHERE ROWID(i-faccpedi) = p-RowId NO-LOCK NO-ERROR.*/
FIND FIRST i-faccpedi WHERE i-faccpedi.codcia = s-codcia AND 
                            i-faccpedi.coddoc = p-CodDoc AND
                             i-faccpedi.nroped = p-NroDoc NO-LOCK NO-ERROR.
IF AVAILABLE i-faccpedi THEN DO:
    /* Guias de la orden de despacho */
    IF i-faccpedi.coddoc = 'O/D' THEN DO:
        FOR EACH i-ccbcdocu USE-INDEX llave15 WHERE i-ccbcdocu.codcia = s-codcia AND 
                                i-ccbcdocu.codped = i-faccpedi.codref AND 
                                i-ccbcdocu.nroped = i-faccpedi.nroref AND 
                                i-ccbcdocu.flgest <> 'A' NO-LOCK :
            IF i-ccbcdocu.coddoc = 'G/R' AND 
                i-ccbcdocu.libre_c01 = i-faccpedi.coddoc AND 
                i-ccbcdocu.libre_c02 = i-faccpedi.nroped THEN DO:
                CREATE tt-w-report.
                    ASSIGN tt-w-report.campo-c[1] = i-ccbcdocu.coddoc
                            tt-w-report.campo-c[2] = i-ccbcdocu.nrodoc.
                /* Hoja de Ruta */
                FIND FIRST di-rutaD USE-INDEX llave02 WHERE di-rutaD.codcia = s-codcia AND 
                                            di-rutaD.coddoc = 'H/R' AND 
                                            di-rutaD.codref = i-ccbcdocu.coddoc AND 
                                            di-rutaD.nroref = i-ccbcdocu.nrodoc NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaD THEN DO:
                    /*FIND FIRST di-RutaC OF di-rutaD NO-LOCK.*/
                    tt-w-report.campo-c[3] = di-rutaD.nrodoc.
                END.
            END.
        END.
    END.

    /* Guias de Transferencias */
    IF i-faccpedi.coddoc = 'OTR' THEN DO:
        FOR EACH almcmov WHERE almcmov.codcia = s-codcia AND 
                                almcmov.codref = 'OTR' AND 
                                almcmov.nroref = i-faccpedi.nroped AND
                                almcmov.flgest <> 'A' NO-LOCK :
            CREATE tt-w-report.
                ASSIGN tt-w-report.campo-c[1] = 'G/R'
                        tt-w-report.campo-c[2] = STRING(almcmov.nroser,"999") + 
                                                STRING(almcmov.nrodoc,"999999").

            FIND FIRST di-rutaG WHERE DI-RutaG.codcia  = almcmov.codcia  AND                 
                                di-rutaG.codalm = almcmov.codalm  AND
                                di-rutaG.tipmov = almcmov.tipmov AND
                                di-rutaG.codmov = almcmov.codmov AND                                
                                di-rutaG.serref = almcmov.nroser AND
                                di-rutaG.nroref = almcmov.nrodoc NO-LOCK NO-ERROR.
            IF AVAILABLE di-rutaG THEN DO:
                tt-w-report.campo-c[3] = di-rutaG.nrodoc.
            END.

        END.
    END.

END.

RELEASE i-faccpedi.
RELEASE i-ccbcdocu.
{&OPEN-QUERY-BROWSE-5}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-muestra-subordenes W-Win 
PROCEDURE ue-muestra-subordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR lSectores AS CHAR.
DEFINE VAR nSectores AS INT INIT 0.
DEFINE VAR nSectoresImp AS INT  INIT 0.
DEFINE VAR nSectoresAsig AS INT  INIT 0.
DEFINE VAR nSectoresReto AS INT  INIT 0.
DEFINE VAR nSectoresSinAsig AS INT  INIT 0.

txtSectores:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
txtSectoresImprimir:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
txtleyenda:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

EMPTY TEMP-TABLE tt-w-report.

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR x-nroped AS CHAR.

x-nroped = pNroDoc + "-".

lSectores = "".
FOR EACH VtaCDocu WHERE VtaCDocu.codcia = s-codcia AND 
                        VtaCDocu.CodPed = pCodDoc AND
                        VtaCDocu.nroped BEGINS x-nroped NO-LOCK:
    lSectores = lSectores + IF(lSectores <> "") THEN "," ELSE "".
    lSectores = lSectores + ENTRY(2,VtaCDocu.nroped,"-").
    nSectores = nSectores + 1.
    IF NOT (TRUE <> (VtaCDocu.UsrImpOD > ""))   THEN DO:
        nSectoresImp = nSectoresImp + 1.
    END.
    IF NOT (TRUE <> (VtaCDocu.UsrSac > ""))   THEN DO:
        nSectoresAsig = nSectoresAsig + 1.
    END.
    IF NOT (TRUE <> (VtaCDocu.UsrSacRecep > ""))   THEN DO:
        nSectoresReto = nSectoresReto + 1.
    END.

    /**/
    CREATE tt-w-report.
        ASSIGN  tt-w-report.campo-c[1] = ENTRY(2,VtaCDocu.nroped,"-")
                tt-w-report.campo-c[2] = VtaCDocu.UsrSac
                tt-w-report.campo-c[3] = STRING(VtaCDocu.fecsac,"99/99/9999") + " " + VtaCDocu.horsac
                tt-w-report.campo-c[4] = IF(NUM-ENTRIES(VtaCDocu.libre_c03)>1) THEN ENTRY(2,VtaCDocu.libre_c03) ELSE ""
                tt-w-report.campo-c[5] = VtaCDocu.ZonaPickeo
                tt-w-report.campo-c[6] = VtaCDocu.UsrSacAsign
                tt-w-report.campo-c[7] = VtaCDocu.UsrSacRecep.
END.
nSectoresSinAsig = nSectores - nSectoresAsig.

txtSectores:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lSectores.
txtSectoresImprimir:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lSectores.
txtleyenda:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(nSectores) + " Sector(es), " +
                    STRING(nSectoresImp) + " Impreso(s), " + 
                    STRING(nSectoresAsig) + " Asignado(s), " + 
                    STRING(nSectoresReto) + " Retornado(s), " + 
                    STRING(nSectoresSinAsig) + " NO asignados".

{&OPEN-QUERY-BROWSE-5}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-pinta-referencia W-Win 
PROCEDURE ue-pinta-referencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodRef AS CHAR.
DEFINE INPUT PARAMETER pNroRef AS CHAR.
/*
txtCodRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}= pCodRef.
txtNroRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}= pNroRef.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

