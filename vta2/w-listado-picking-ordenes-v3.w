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

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW SHARED VARIABLE lMsgRetorno  AS CHAR.


DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcia AS INT.

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
tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RADIO-SET-CodDoc BtnDone ~
BUTTON-14 txtDesde txtHasta ChkChequeo BUTTON-13 RADIO-SET-1 BtnExcel ~
txtOrdenCompra chbxImpresos BROWSE-5 BUTTON-PorZona BUTTON-Alfabeticamente 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-CodDoc txtDesde txtHasta ~
ChkChequeo RADIO-SET-1 txtOrdenCompra chbxImpresos txtcodref txtNroRef ~
txtArtSinPeso 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

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
     LABEL "CARGAR BD" 
     SIZE 28 BY 1.38
     BGCOLOR 14 FGCOLOR 0 FONT 8.

DEFINE BUTTON BUTTON-14 
     LABEL "TXT Cabecera Detalle" 
     SIZE 21 BY 1.15.

DEFINE BUTTON BUTTON-Alfabeticamente 
     LABEL "IMPRIMIR ALFABETICAMENTE" 
     SIZE 29 BY 1.12.

DEFINE BUTTON BUTTON-PorZona 
     LABEL "IMPRIMIR POR ZONA" 
     SIZE 22 BY 1.12.

DEFINE VARIABLE txtArtSinPeso AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 97 BY 1
     FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE txtcodref AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1
     FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtNroRef AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     FGCOLOR 9 FONT 10 NO-UNDO.

DEFINE VARIABLE txtOrdenCompra AS CHARACTER FORMAT "X(15)":U 
     LABEL "O/C Sup.Mercados Peruanos" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 NO-UNDO.

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
     SIZE 102 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 3.77.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112 BY 3.77.

DEFINE VARIABLE chbxImpresos AS LOGICAL INITIAL no 
     LABEL "Mostrar solo IMPRESOS" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.72 BY .77 NO-UNDO.

DEFINE VARIABLE ChkChequeo AS LOGICAL INITIAL yes 
     LABEL "Mostrar solo PENDIENTES" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.29 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "T.Doc." FORMAT "X(5)":U
            WIDTH 5
      tt-w-report.Campo-C[2] COLUMN-LABEL "Nro. Docto" FORMAT "X(15)":U
            WIDTH 9.43
      tt-w-report.Campo-C[3] COLUMN-LABEL "H.Ruta" FORMAT "X(15)":U
            WIDTH 11.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 30.57 BY 7.96 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-CodDoc AT ROW 1.19 COL 11 NO-LABEL WIDGET-ID 36
     BtnDone AT ROW 1.27 COL 137 WIDGET-ID 10
     BUTTON-14 AT ROW 1.81 COL 114 WIDGET-ID 52
     txtDesde AT ROW 2.5 COL 6.57 COLON-ALIGNED WIDGET-ID 16
     txtHasta AT ROW 2.5 COL 28 COLON-ALIGNED WIDGET-ID 20
     ChkChequeo AT ROW 2.88 COL 51 WIDGET-ID 22
     BUTTON-13 AT ROW 2.88 COL 83 WIDGET-ID 4
     RADIO-SET-1 AT ROW 3.12 COL 129 NO-LABEL WIDGET-ID 28
     BtnExcel AT ROW 3.15 COL 114 WIDGET-ID 34
     txtOrdenCompra AT ROW 3.58 COL 28 COLON-ALIGNED WIDGET-ID 48
     chbxImpresos AT ROW 3.77 COL 51 WIDGET-ID 50
     BROWSE-5 AT ROW 12.46 COL 114.14 WIDGET-ID 200
     txtcodref AT ROW 20.81 COL 123.57 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     txtNroRef AT ROW 20.81 COL 129.86 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     BUTTON-PorZona AT ROW 24.65 COL 3 WIDGET-ID 6
     BUTTON-Alfabeticamente AT ROW 24.65 COL 25 WIDGET-ID 8
     txtArtSinPeso AT ROW 25.81 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     "Referencia :" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 21.04 COL 114 WIDGET-ID 42
          BGCOLOR 15 FGCOLOR 0 FONT 10
     "Lista de Articulos que NO tienen PESO en la O/D" VIEW-AS TEXT
          SIZE 43.14 BY .62 AT ROW 24.81 COL 57 WIDGET-ID 26
          BGCOLOR 15 FGCOLOR 9 FONT 6
     "Filtrar por:" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 1.38 COL 2 WIDGET-ID 40
     RECT-1 AT ROW 1 COL 113 WIDGET-ID 32
     RECT-2 AT ROW 1 COL 1 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 145.29 BY 26.04 WIDGET-ID 100.


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
         HEIGHT             = 26.04
         WIDTH              = 145.29
         MAX-HEIGHT         = 27.38
         MAX-WIDTH          = 159.43
         VIRTUAL-HEIGHT     = 27.38
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-5 chbxImpresos F-Main */
/* SETTINGS FOR FILL-IN txtArtSinPeso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtcodref IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNroRef IN FRAME F-Main
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
"tt-w-report.Campo-C[1]" "T.Doc." "X(5)" "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Nro. Docto" "X(15)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "H.Ruta" "X(15)" "character" ? ? ? ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



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
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* CARGAR BD */
DO:
    ASSIGN txtDesde txtHasta chkchequeo txtOrdenCompra chbxImpresos.
    ltxtDesde = txtDesde.
    ltxtHasta = txtHasta.
    lChequeados = chkchequeo.
    pOrdenCompra = TRIM(txtOrdenCompra).
    pSoloImpresos = chbxImpresos.

    RUN dispatch IN h_b-picking-ordenes-todos ('open-query':U).
    RUN Procesa-Handle IN lh_handle ('Enable-Buttons').
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


&Scoped-define SELF-NAME BUTTON-Alfabeticamente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Alfabeticamente W-Win
ON CHOOSE OF BUTTON-Alfabeticamente IN FRAME F-Main /* IMPRIMIR ALFABETICAMENTE */
DO:
  RUN Imprimir-Alfabeticamente IN h_b-picking-ordenes-todos.
/*   CASE s-CodDoc:                                                                                                */
/*       WHEN 'O/D' OR WHEN 'O/M' THEN RUN Imprimir-Formato-OD IN h_b-picking-ordenes-todos ( INPUT "ALFABETICO"). */
/*       WHEN 'OTR' THEN RUN Imprimir-Formato-OTR IN h_b-picking-ordenes-todos ( INPUT "ALFABETICO").              */
/*   END CASE.                                                                                                     */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-PorZona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-PorZona W-Win
ON CHOOSE OF BUTTON-PorZona IN FRAME F-Main /* IMPRIMIR POR ZONA */
DO:
  RUN Imprimir-por-Zona IN h_b-picking-ordenes-todos.  
/*     CASE s-CodDoc:                                                                                          */
/*         WHEN 'O/D' OR WHEN 'O/M' THEN RUN Imprimir-Formato-OD IN h_b-picking-ordenes-todos ( INPUT "ZONA"). */
/*         WHEN 'OTR' THEN RUN Imprimir-Formato-OTR IN h_b-picking-ordenes-todos ( INPUT "ZONA").              */
/*     END CASE.                                                                                               */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-CodDoc W-Win
ON VALUE-CHANGED OF RADIO-SET-CodDoc IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  s-CodDoc = {&self-name}.
/*   RUN dispatch IN h_b-picking-ordenes-todos ('open-query':U). */
/*   CASE s-CodDoc:                                              */
/*       WHEN "O/D" OR WHEN "O/M" THEN DO:                       */
/*       END.                                                    */
/*       WHEN "OTR" THEN DO:                                     */
/*       END.                                                    */
/*   END CASE.                                                   */
  
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
             INPUT  'vta2/b-listado-picking-ordenes-todos-v3.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = FchPed':U ,
             OUTPUT h_b-picking-ordenes-todos ).
       RUN set-position IN h_b-picking-ordenes-todos ( 4.65 , 1.86 ) NO-ERROR.
       RUN set-size IN h_b-picking-ordenes-todos ( 7.50 , 144.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/b-dimprime-od.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-dimprime-od ).
       RUN set-position IN h_b-dimprime-od ( 12.38 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-dimprime-od ( 11.92 , 111.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-dimprime-od. */
       RUN add-link IN adm-broker-hdl ( h_b-picking-ordenes-todos , 'Record':U , h_b-dimprime-od ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-picking-ordenes-todos ,
             chbxImpresos:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-dimprime-od ,
             h_b-picking-ordenes-todos , 'AFTER':U ).
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
  DISPLAY RADIO-SET-CodDoc txtDesde txtHasta ChkChequeo RADIO-SET-1 
          txtOrdenCompra chbxImpresos txtcodref txtNroRef txtArtSinPeso 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 RADIO-SET-CodDoc BtnDone BUTTON-14 txtDesde txtHasta 
         ChkChequeo BUTTON-13 RADIO-SET-1 BtnExcel txtOrdenCompra chbxImpresos 
         BROWSE-5 BUTTON-PorZona BUTTON-Alfabeticamente 
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
  txtDesde:SCREEN-VALUE IN FRAME {&frame-name} = STRING(TODAY - 15,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&frame-name} = STRING(TODAY,"99/99/9999").
  IF s-coddiv = '00065' THEN DO:
      s-CodDoc = 'O/M'.
      RADIO-SET-CodDoc:SCREEN-VALUE = 'O/M'.
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
         BUTTON-Alfabeticamente:SENSITIVE = NO.
         BtnExcel:SENSITIVE = NO.
    END.
    WHEN "Enable-Buttons" THEN DO WITH FRAME {&FRAME-NAME}:
         BUTTON-Alfabeticamente:SENSITIVE = YES.
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

FIND FIRST i-faccpedi WHERE i-faccpedi.codcia = s-codcia AND 
    i-faccpedi.coddoc = p-CodDoc AND
    i-faccpedi.nroped = p-NroDoc NO-LOCK NO-ERROR NO-WAIT.
IF AVAILABLE i-faccpedi THEN DO:
    /* Guias de la orden de despacho */
    CASE i-faccpedi.coddoc:
        WHEN "O/D" THEN DO:
            FOR EACH i-ccbcdocu /*USE-INDEX llave15*/ WHERE i-ccbcdocu.codcia = s-codcia AND 
                    i-ccbcdocu.codped = i-faccpedi.codref AND 
                    i-ccbcdocu.nroped = i-faccpedi.nroref AND 
                    i-ccbcdocu.flgest <> 'A' NO-LOCK :
                IF i-ccbcdocu.coddoc = 'G/R' AND 
                    i-ccbcdocu.libre_c01 = i-faccpedi.coddoc AND 
                    i-ccbcdocu.libre_c02 = i-faccpedi.nroped THEN DO:
                    CREATE tt-w-report.
                    ASSIGN 
                        tt-w-report.campo-c[1] = i-ccbcdocu.coddoc
                        tt-w-report.campo-c[2] = i-ccbcdocu.nrodoc.
                    /* Hoja de Ruta */
                    FIND FIRST di-rutaD USE-INDEX llave02 WHERE di-rutaD.codcia = s-codcia AND 
                        di-rutaD.coddoc = 'H/R' AND 
                        di-rutaD.codref = i-ccbcdocu.coddoc AND 
                        di-rutaD.nroref = i-ccbcdocu.nrodoc NO-LOCK NO-ERROR.
                    IF AVAILABLE di-rutaD THEN DO:
                        tt-w-report.campo-c[3] = di-rutaD.nrodoc.
                    END.
                END.
            END.
        END.
        WHEN "OTR" THEN DO:
            FOR EACH almcmov WHERE almcmov.codcia = s-codcia AND 
                    almcmov.codref = 'OTR' AND 
                    almcmov.nroref = i-faccpedi.nroped AND
                    almcmov.flgest <> 'A' NO-LOCK :
                CREATE tt-w-report.
                ASSIGN 
                    tt-w-report.campo-c[1] = 'G/R'
                    tt-w-report.campo-c[2] = STRING(almcmov.nroser,"999") + 
                                            STRING(almcmov.nrodoc,"999999").
                FIND FIRST di-rutaG WHERE DI-RutaG.codcia  = almcmov.codcia  AND                 
                    di-rutaG.codalm = almcmov.codalm  AND
                    di-rutaG.tipmov = almcmov.tipmov AND
                    di-rutaG.codmov = almcmov.codmov AND                                
                    di-rutaG.serref = almcmov.nroser AND
                    di-rutaG.nroref = almcmov.nrodoc NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaG THEN tt-w-report.campo-c[3] = di-rutaG.nrodoc.
            END.
        END.
    END CASE.
END.
SESSION:SET-WAIT-STATE('').

{&OPEN-QUERY-BROWSE-5}


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

txtCodRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}= pCodRef.
txtNroRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}= pNroRef.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

