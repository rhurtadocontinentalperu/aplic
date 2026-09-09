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

/* Local Variable Definitions ---                                       */

DEFINE INPUT PARAMETER pOrigen AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
/*DEFINE SHARED VAR s-coddiv AS CHAR.*/

&SCOPED-DEFINE Condicion VtaDTickets.CodPro = COMBO-BOX-Proveedor ~
 AND DATE(VtaDTickets.Fecha) >= FILL-IN-Fecha-1 ~
 AND DATE(VtaDTickets.Fecha) <= FILL-IN-Fecha-2 ~
 AND (COMBO-BOX-Division = 'Todas' OR VtaDTickets.CodDiv = COMBO-BOX-Division)

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
&Scoped-define INTERNAL-TABLES VtaDTickets CcbDCaja CcbCDocu

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 VtaDTickets.Producto ~
VtaDTickets.NroTck VtaDTickets.Valor VtaDTickets.Usuario VtaDTickets.CodDiv ~
VtaDTickets.CodRef VtaDTickets.NroRef VtaDTickets.Fecha CcbDCaja.CodRef ~
CcbDCaja.NroRef CcbCDocu.CodCli CcbCDocu.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH VtaDTickets ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST CcbDCaja WHERE CcbDCaja.CodCia = VtaDTickets.CodCia ~
  AND CcbDCaja.CodDiv = VtaDTickets.CodDiv ~
  AND CcbDCaja.CodDoc = VtaDTickets.CodRef ~
  AND CcbDCaja.NroDoc = VtaDTickets.NroRef OUTER-JOIN NO-LOCK, ~
      FIRST CcbCDocu WHERE CcbCDocu.CodCia = CcbDCaja.CodCia ~
  AND CcbCDocu.CodDoc = CcbDCaja.CodRef ~
  AND CcbCDocu.NroDoc = CcbDCaja.NroRef OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH VtaDTickets ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST CcbDCaja WHERE CcbDCaja.CodCia = VtaDTickets.CodCia ~
  AND CcbDCaja.CodDiv = VtaDTickets.CodDiv ~
  AND CcbDCaja.CodDoc = VtaDTickets.CodRef ~
  AND CcbDCaja.NroDoc = VtaDTickets.NroRef OUTER-JOIN NO-LOCK, ~
      FIRST CcbCDocu WHERE CcbCDocu.CodCia = CcbDCaja.CodCia ~
  AND CcbCDocu.CodDoc = CcbDCaja.CodRef ~
  AND CcbCDocu.NroDoc = CcbDCaja.NroRef OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 VtaDTickets CcbDCaja CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 VtaDTickets
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 CcbDCaja
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 CcbCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Proveedor BUTTON-1 BUTTON-2 ~
BtnDone COMBO-BOX-Division FILL-IN-Fecha-1 FILL-IN-Fecha-2 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Proveedor COMBO-BOX-Division ~
FILL-IN-Fecha-1 FILL-IN-Fecha-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "APLICAR FILTRO" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 7 BY 1.54.

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Proveedor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      VtaDTickets, 
      CcbDCaja, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      VtaDTickets.Producto FORMAT "x(8)":U
      VtaDTickets.NroTck COLUMN-LABEL "Numero de Vale" FORMAT "x(12)":U
      VtaDTickets.Valor FORMAT "->>,>>9.99":U
      VtaDTickets.Usuario COLUMN-LABEL "Cajero" FORMAT "x(8)":U
      VtaDTickets.CodDiv COLUMN-LABEL "División" FORMAT "x(5)":U
      VtaDTickets.CodRef COLUMN-LABEL "Doc Caja" FORMAT "x(13)":U
      VtaDTickets.NroRef COLUMN-LABEL "Número" FORMAT "x(12)":U
      VtaDTickets.Fecha COLUMN-LABEL "Fecha de consumo" FORMAT "99/99/9999 HH:MM:SS":U
            WIDTH 17.57
      CcbDCaja.CodRef COLUMN-LABEL "Doc Venta" FORMAT "x(3)":U
            WIDTH 8.14
      CcbDCaja.NroRef FORMAT "X(12)":U WIDTH 9.43
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 11.14
      CcbCDocu.NomCli FORMAT "x(50)":U WIDTH 31
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 140 BY 13.85
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Proveedor AT ROW 1.19 COL 13 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 1.19 COL 78 WIDGET-ID 8
     BUTTON-2 AT ROW 1.19 COL 126 WIDGET-ID 10
     BtnDone AT ROW 1.19 COL 133 WIDGET-ID 14
     COMBO-BOX-Division AT ROW 2.15 COL 13 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Fecha-1 AT ROW 3.12 COL 13 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Fecha-2 AT ROW 4.08 COL 13 COLON-ALIGNED WIDGET-ID 6
     BROWSE-2 AT ROW 5.23 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 142 BY 18.46
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
         TITLE              = "REPORTE DE VALES DE CONSUMO"
         HEIGHT             = 18.46
         WIDTH              = 142
         MAX-HEIGHT         = 18.46
         MAX-WIDTH          = 143.29
         VIRTUAL-HEIGHT     = 18.46
         VIRTUAL-WIDTH      = 143.29
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
/* BROWSE-TAB BROWSE-2 FILL-IN-Fecha-2 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.VtaDTickets,INTEGRAL.CcbDCaja WHERE INTEGRAL.VtaDTickets ...,INTEGRAL.CcbCDocu WHERE INTEGRAL.CcbDCaja ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER, FIRST OUTER"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "CcbDCaja.CodCia = VtaDTickets.CodCia
  AND CcbDCaja.CodDiv = VtaDTickets.CodDiv
  AND CcbDCaja.CodDoc = VtaDTickets.CodRef
  AND CcbDCaja.NroDoc = VtaDTickets.NroRef"
     _JoinCode[3]      = "CcbCDocu.CodCia = CcbDCaja.CodCia
  AND CcbCDocu.CodDoc = CcbDCaja.CodRef
  AND CcbCDocu.NroDoc = CcbDCaja.NroRef"
     _FldNameList[1]   = INTEGRAL.VtaDTickets.Producto
     _FldNameList[2]   > INTEGRAL.VtaDTickets.NroTck
"VtaDTickets.NroTck" "Numero de Vale" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.VtaDTickets.Valor
     _FldNameList[4]   > INTEGRAL.VtaDTickets.Usuario
"VtaDTickets.Usuario" "Cajero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaDTickets.CodDiv
"VtaDTickets.CodDiv" "División" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.VtaDTickets.CodRef
"VtaDTickets.CodRef" "Doc Caja" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.VtaDTickets.NroRef
"VtaDTickets.NroRef" "Número" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.VtaDTickets.Fecha
"VtaDTickets.Fecha" "Fecha de consumo" ? "datetime" ? ? ? ? ? ? no ? no no "17.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.CcbDCaja.CodRef
"CcbDCaja.CodRef" "Doc Venta" ? "character" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.CcbDCaja.NroRef
"CcbDCaja.NroRef" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.CcbCDocu.CodCli
"CcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "31" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE VALES DE CONSUMO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE VALES DE CONSUMO */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* APLICAR FILTRO */
DO:

  ASSIGN COMBO-BOX-Proveedor FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-Division.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Excel.
   SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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
  DISPLAY COMBO-BOX-Proveedor COMBO-BOX-Division FILL-IN-Fecha-1 FILL-IN-Fecha-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Proveedor BUTTON-1 BUTTON-2 BtnDone COMBO-BOX-Division 
         FILL-IN-Fecha-1 FILL-IN-Fecha-2 BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
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
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

FIND gn-prov WHERE gn-prov.codcia = pv-codcia
    AND gn-prov.codpro = COMBO-BOX-Proveedor NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-prov THEN RETURN.

IF COMBO-BOX-Division <> 'Todas' THEN DO:
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = COMBO-BOX-Division
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN RETURN.
END.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
ASSIGN
    chWorkSheet:Range("A1"):Value = s-NomCia
    chWorkSheet:Range("A2"):Value = "PROVEEDOR: " + gn-prov.NomPro
    chWorkSheet:Range("A3"):Value = "DIVISION: " + (IF COMBO-BOX-Division ='Todas' THEN 'Todas' ELSE GN-DIVI.DesDiv)
    chWorkSheet:Range("A4"):Value = "DESDE: " + STRING(FILL-IN-Fecha-1)
    chWorkSheet:Range("A5"):Value = "DESDE: " + STRING(FILL-IN-Fecha-2)
    chWorkSheet:Range("A6"):Value = "Producto"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B6"):Value = "Numero de Vale"
    chWorkSheet:Columns("B"):NumberFormat = "@"
    chWorkSheet:Range("C6"):Value = "Importe"
    chWorkSheet:Range("D6"):Value = "Cajero"
    chWorkSheet:Range("E6"):Value = "Division"
    chWorkSheet:Columns("E"):NumberFormat = "@"
    chWorkSheet:Range("F6"):Value = "Doc de Caja"
    chWorkSheet:Range("G6"):Value = "Fecha de Consumo"
    chWorkSheet:Range("H6"):Value = "Doc de Venta"
    chWorkSheet:Range("I6"):Value = "Cliente".

ASSIGN
    t-Row = 6.
FOR EACH VtaDTickets WHERE {&Condicion} NO-LOCK:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.Producto.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.NroTck.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.Valor.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.Usuario.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.CodDiv.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.CodRef + ' ' + VtaDTickets.NroRef.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.Fecha.
    FIND FIRST CcbDCaja WHERE CcbDCaja.CodCia = VtaDTickets.CodCia
        AND CcbDCaja.CodDiv = VtaDTickets.CodDiv
        AND CcbDCaja.CodDoc = VtaDTickets.CodRef
        AND CcbDCaja.NroDoc = VtaDTickets.NroRef
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbdcaja THEN DO:
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbdcaja.CodRef + ' ' + Ccbdcaja.NroRef.
        FIND Ccbcdocu WHERE Ccbcdocu.codcia = Ccbdcaja.codcia
            AND Ccbcdocu.coddoc = Ccbdcaja.codref
            AND Ccbcdocu.nrodoc = Ccbdcaja.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbcdocu THEN DO:
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbcdocu.codcli + ' ' + Ccbcdocu.nomcli.
        END.
    END.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Proveedor:DELETE(1).
      FOR EACH Vtactickets NO-LOCK WHERE Vtactickets.codcia = s-codcia,
          FIRST gn-prov NO-LOCK WHERE gn-prov.codcia = pv-codcia
          AND gn-prov.codpro = Vtactickets.codpro
          BREAK BY Vtactickets.codpro:
          IF FIRST-OF(Vtactickets.codpro) THEN
          COMBO-BOX-Proveedor:ADD-LAST(gn-prov.CodPro + ' ' + gn-prov.NomPro, gn-prov.CodPro).
      END.
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
          COMBO-BOX-Division:ADD-LAST(gn-divi.coddiv + ' ' + GN-DIVI.DesDiv, gn-divi.coddiv).
      END.

/*       IF pOrigen = '*' THEN DO:                                                                   */
/*           FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:                               */
/*               COMBO-BOX-Division:ADD-LAST(gn-divi.coddiv + ' ' + GN-DIVI.DesDiv, gn-divi.coddiv). */
/*           END.                                                                                    */
/*       END.                                                                                        */
/*       ELSE DO:                                                                                    */
/*           COMBO-BOX-Division:DELETE(1).                                                           */
/*           FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND                                  */
/*                                     gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.                   */
/*           IF AVAILABLE gn-divi THEN DO:                                                           */
/*               COMBO-BOX-Division:ADD-LAST(gn-divi.coddiv + ' ' + GN-DIVI.DesDiv, gn-divi.coddiv). */
/*           END.                                                                                    */
/*                                                                                                   */
/*       END.                                                                                        */

      ASSIGN
          FILL-IN-Fecha-1 = TODAY - DAY(TODAY) + 1
          FILL-IN-Fecha-2 = TODAY.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      IF pOrigen <> '*' THEN DO:
          ASSIGN COMBO-BOX-Division = gn-divi.coddiv.
          COMBO-BOX-Division:SCREEN-VALUE = gn-divi.coddiv.
          DISABLE COMBO-BOX-Division.    
      END.
  END.

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
  {src/adm/template/snd-list.i "VtaDTickets"}
  {src/adm/template/snd-list.i "CcbDCaja"}
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

