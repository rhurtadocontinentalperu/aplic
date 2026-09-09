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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-CodFam AS CHAR INIT 'Todas' NO-UNDO.
DEF VAR x-SubFam AS CHAR INIT 'Todas' NO-UNDO.

&SCOPED-DEFINE Condicion ( Almmmatg.codcia = s-codcia ~
AND Almmmatg.tpoart <> "D" ~
AND LOOKUP(Almmmatg.codfam,  x-codfam) > 0 ~
AND (x-SubFam = 'Todas' OR Almmmatg.subfam = x-subfam) ~
AND (x-CodPro = '' OR Almmmatg.codpr1 = x-codpro) ~
AND (x-DesMar = '' OR Almmmatg.desmar BEGINS x-desmar) )

/*    AND (x-CodFam = 'Todas' OR Almmmatg.codfam = x-codfam) ~*/

    /* Buscamos lineas autorizadas */
    DEF SHARED VAR s-user-id AS CHAR.

    FIND FIRST Vtatabla WHERE codcia = s-codcia
        AND tabla = "LP"
        AND llave_c1 = s-user-id
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtatabla THEN DO:
        MESSAGE 'NO tiene líneas autorizadas' VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.

    x-CodFam = ''.
    FOR EACH Vtatabla NO-LOCK WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = "LP"
        AND Vtatabla.llave_c1 = s-user-id,
        FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
        AND Almtfami.codfam = Vtatabla.llave_c2:
        IF x-CodFam = '' THEN x-CodFam = Almtfami.codfam.
        x-CodFam = x-CodFam + ',' + Almtfami.codfam.
    END.

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
&Scoped-define INTERNAL-TABLES Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 Almmmatg.codmat Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.codfam Almmmatg.subfam 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Almmmatg ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Almmmatg ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 COMBO-BOX-CodFam RADIO-SET-1 ~
COMBO-BOX-SubFam x-CodPro x-DesMar BUTTON-1 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Division COMBO-BOX-CodFam ~
RADIO-SET-1 COMBO-BOX-SubFam x-CodPro FILL-IN-NomPro x-DesMar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "GENERAR PLANTILLA EN EXCEL" 
     SIZE 31 BY 1.12.

DEFINE VARIABLE COMBO-BOX-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Línea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 59 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Sub-línea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 59 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 78 BY 1
     BGCOLOR 11 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-DesMar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Lista Mayorista - Continental", 1,
"Lista Minorista - Utilex", 2,
"Lista Mayorista - por División", 3,
"Lista Contrato Marco", 4,
"Lista de Terceros", 5
     SIZE 22 BY 3.85 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 107.43 BY 1.35
     BGCOLOR 11 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      Almmmatg.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 6.43
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 50.86
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
      Almmmatg.codfam COLUMN-LABEL "Línea" FORMAT "X(3)":U WIDTH 7.43
      Almmmatg.subfam COLUMN-LABEL "Sub-Línea" FORMAT "X(3)":U
            WIDTH 13.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 105 BY 12.5
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Division AT ROW 1.19 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     COMBO-BOX-CodFam AT ROW 2.54 COL 13 COLON-ALIGNED WIDGET-ID 8
     RADIO-SET-1 AT ROW 2.54 COL 79 NO-LABEL WIDGET-ID 24
     COMBO-BOX-SubFam AT ROW 3.5 COL 13 COLON-ALIGNED WIDGET-ID 10
     x-CodPro AT ROW 4.46 COL 13 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-NomPro AT ROW 4.46 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     x-DesMar AT ROW 5.42 COL 13 COLON-ALIGNED WIDGET-ID 16
     BUTTON-1 AT ROW 5.42 COL 45 WIDGET-ID 18
     BROWSE-2 AT ROW 6.77 COL 2 WIDGET-ID 200
     RECT-1 AT ROW 1 COL 1 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 107.43 BY 18.62
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
         TITLE              = "PREPARAR PLANTILLA DE PRECIOS"
         HEIGHT             = 18.62
         WIDTH              = 107.43
         MAX-HEIGHT         = 19
         MAX-WIDTH          = 111.14
         VIRTUAL-HEIGHT     = 19
         VIRTUAL-WIDTH      = 111.14
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
/* BROWSE-TAB BROWSE-2 BUTTON-1 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.Almmmatg.codmat
"Almmmatg.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "50.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.codfam
"Almmmatg.codfam" "Línea" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.subfam
"Almmmatg.subfam" "Sub-Línea" ? "character" ? ? ? ? ? ? no ? no no "13.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PREPARAR PLANTILLA DE PRECIOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PREPARAR PLANTILLA DE PRECIOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* GENERAR PLANTILLA EN EXCEL */
DO:
    ASSIGN
         RADIO-SET-1.
/*     IF RADIO-SET-1 > 3 THEN DO:                                      */
/*         MESSAGE 'Bloqueado temporalmente' VIEW-AS ALERT-BOX WARNING. */
/*         RETURN NO-APPLY.                                             */
/*     END.                                                             */
    SESSION:SET-WAIT-STATE('GENERAL').
    CASE RADIO-SET-1:
        WHEN 1 THEN RUN Excel.
        WHEN 2 THEN RUN Excel-2.
        WHEN 3 THEN RUN Excel-3.
        WHEN 4 THEN RUN Excel-4.
        WHEN 5 THEN RUN Excel-5.
    END CASE.
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodFam W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodFam IN FRAME F-Main /* Línea */
DO:
  COMBO-BOX-SubFam:DELETE(COMBO-BOX-SubFam:LIST-ITEMS).
  COMBO-BOX-SubFam:ADD-LAST('Todas').
  COMBO-BOX-SubFam:SCREEN-VALUE = 'Todas'.
  IF SELF:SCREEN-VALUE <> 'Todas' THEN DO:
      FOR EACH almsfami NO-LOCK WHERE almsfami.codcia = s-codcia
          AND almsfami.codfam = ENTRY(1, SELF:SCREEN-VALUE, ' - '):
          COMBO-BOX-SubFam:ADD-LAST(AlmSFami.subfam + ' - ' + AlmSFami.dessub).
      END.
  END.
  ASSIGN
      x-CodFam = SELF:SCREEN-VALUE
      x-SubFam = COMBO-BOX-SubFam:SCREEN-VALUE.
  IF x-CodFam <> 'Todas' THEN x-CodFam = ENTRY(1, SELF:SCREEN-VALUE, ' - ').
  IF x-CodFam = 'Todas' THEN DO:
      x-CodFam = ''.
      FOR EACH Vtatabla NO-LOCK WHERE Vtatabla.codcia = s-codcia
          AND Vtatabla.tabla = "LP"
          AND Vtatabla.llave_c1 = s-user-id,
          FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
          AND Almtfami.codfam = Vtatabla.llave_c2:
          IF x-CodFam = '' THEN x-CodFam = Almtfami.codfam.
          x-CodFam = x-CodFam + ',' + Almtfami.codfam.
      END.

  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-SubFam W-Win
ON VALUE-CHANGED OF COMBO-BOX-SubFam IN FRAME F-Main /* Sub-línea */
DO:
    ASSIGN
        x-SubFam = COMBO-BOX-SubFam:SCREEN-VALUE.
    IF x-SubFam <> 'Todas' THEN x-SubFam = ENTRY(1, SELF:SCREEN-VALUE, ' - ').
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro W-Win
ON LEAVE OF x-CodPro IN FRAME F-Main /* Proveedor */
DO:
  ASSIGN {&self-name}.
  FIND gn-prov WHERE gn-prov.codcia = pv-codcia
      AND gn-prov.codpro = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN FILL-IN-NomPro:SCREEN-VALUE = gn-prov.NomPro.
  {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-DesMar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-DesMar W-Win
ON LEAVE OF x-DesMar IN FRAME F-Main /* Marca */
DO:
    ASSIGN {&self-name}.
    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
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
  DISPLAY FILL-IN-Division COMBO-BOX-CodFam RADIO-SET-1 COMBO-BOX-SubFam 
          x-CodPro FILL-IN-NomPro x-DesMar 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 COMBO-BOX-CodFam RADIO-SET-1 COMBO-BOX-SubFam x-CodPro x-DesMar 
         BUTTON-1 BROWSE-2 
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

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
DEF VAR x-CtoTot LIKE Almmmatg.ctotot NO-UNDO.
DEF VAR x-PreVta LIKE Almmmatg.prevta NO-UNDO.
DEF VAR x-PreOfi LIKE Almmmatg.preofi NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = "CONTINENTAL - PRECIOS"
    chWorkSheet:Range("A2"):Value = "CODIGO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "DESCRIPCION"
    chWorkSheet:Range("C2"):Value = "LINEA"
    chWorkSheet:Columns("C"):NumberFormat = "@"
    chWorkSheet:Range("D2"):Value = "SUBLINEA"
    chWorkSheet:Columns("D"):NumberFormat = "@"
    chWorkSheet:Range("E2"):Value = "MONEDA"
    chWorkSheet:Range("F2"):Value = "TC"
    chWorkSheet:Range("G2"):Value = "COSTO S/."
    chWorkSheet:Range("H2"):Value = "PRECIO LISTA S/."
    chWorkSheet:Range("I2"):Value = "MARGEN A"
    chWorkSheet:Range("J2"):Value = "PRECIO A S/."
    chWorkSheet:Range("K2"):Value = "UNIDAD A"
    chWorkSheet:Range("L2"):Value = "MARGEN B"
    chWorkSheet:Range("M2"):Value = "PRECIO B S/."
    chWorkSheet:Range("N2"):Value = "UNIDAD B"
    chWorkSheet:Range("O2"):Value = "MARGEN C"
    chWorkSheet:Range("P2"):Value = "PRECIO C S/."
    chWorkSheet:Range("Q2"):Value = "UNIDAD C"
    chWorkSheet:Range("R2"):Value = "MARGEN OFICINA"
    chWorkSheet:Range("S2"):Value = "PRECIO OFICINA S/."
    chWorkSheet:Range("T2"):Value = "UNIDAD OFICINA"
    chWorkSheet:Range("U2"):Value = "LISTA"
    chWorkSheet:Range("V2"):Value = "A"
    chWorkSheet:Range("W2"):Value = "B"
    chWorkSheet:Range("X2"):Value = "C"
    chWorkSheet:Range("Y2"):Value = "MARCA"
    chWorkSheet:Range("Z2"):Value = "CLASIFICACION"
    chWorkSheet:Range("AA2"):Value = "PROVEEDOR"
    chWorkSheet:Range("AB2"):VALUE = "FLETE".
/* RHC 15/08/2015 Solo para el caso de Chiclayo */
IF s-CodDiv = '00065' THEN
    ASSIGN chWorkSheet:Range("A1"):Value = "CONTINENTAL - PRECIOS" +
    " - PRECIOS AFECTADOS POR EL FACTOR DE FLETE. NO USAR".
DEF VAR F-FACTOR AS DEC.
DEF VAR F-PREBAS AS DEC.
DEF VAR F-PREVTA AS DEC.
DEF VAR F-DSCTOS AS DEC.
DEF VAR Y-DSCTOS AS DEC.
DEF VAR X-TIPDTO AS CHAR.
DEF VAR f-FleteUnitario AS DEC.
DEF VAR f-MrgUti-A LIKE Almmmatg.mrguti-a NO-UNDO.
DEF VAR f-MrgUti-B LIKE Almmmatg.mrguti-b NO-UNDO.
DEF VAR f-MrgUti-C LIKE Almmmatg.mrguti-c NO-UNDO.
DEF VAR MrgMin AS DEC NO-UNDO.
DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR fmot AS DEC NO-UNDO.
DEF VAR MrgOfi AS DEC NO-UNDO.
/* ******************************************** */
ASSIGN
    t-Row = 2.
FOR EACH Almmmatg NO-LOCK WHERE {&Condicion}, FIRST Almtfami OF Almmmatg NO-LOCK,
    FIRST Almsfami OF Almmmatg NO-LOCK
    BY Almmmatg.CodFam BY Almmmatg.SubFam BY Almmmatg.DesMar BY Almmmatg.CodMat:
    /* RHC 15/08/2015 Solo para Chiclayo determinamos el factor del flete */
    ASSIGN
        f-FleteUnitario = 0
        f-MrgUti-A = Almmmatg.mrguti-a
        f-MrgUti-B = Almmmatg.mrguti-b
        f-MrgUti-C = Almmmatg.mrguti-c
        MrgOfi     = Almmmatg.DEC__01.
    IF s-CodDiv = '00065' THEN DO:
        RUN vta2/PrecioMayorista-Cont-v2 (
                                          s-CodCia,
                                          s-CodDiv,
                                          '11111111111',
                                          1,
                                          Almmmatg.TpoCmb,
                                          OUTPUT f-Factor,
                                          Almmmatg.codmat,
                                          'SINDESCUENTOS',
                                          Almmmatg.CHR__01,
                                          1,
                                          4,
                                          '65',
                                          OUTPUT f-PreBas,
                                          OUTPUT f-PreVta,
                                          OUTPUT f-Dsctos,
                                          OUTPUT y-Dsctos,
                                          OUTPUT x-TipDto,
                                          OUTPUT f-FleteUnitario).
        IF RETURN-VALUE = 'ADM-ERROR' THEN f-FleteUnitario = 0.
    END.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = Almmmatg.codpr1
        NO-LOCK NO-ERROR.
    ASSIGN
        x-CtoTot = Almmmatg.ctotot
        x-PreOfi = Almmmatg.preofi
        x-PreVta[1] = Almmmatg.prevta[1]
        x-PreVta[2] = Almmmatg.prevta[2]
        x-PreVta[3] = Almmmatg.prevta[3]
        x-PreVta[4] = Almmmatg.prevta[4].
    IF Almmmatg.monvta = 2 THEN
        ASSIGN
        x-CtoTot = x-CtoTot * Almmmatg.tpocmb
        x-PreOfi = x-PreOfi * Almmmatg.tpocmb
        x-PreVta[1] = x-PreVta[1] * Almmmatg.tpocmb
        x-PreVta[2] = x-PreVta[2] * Almmmatg.tpocmb
        x-PreVta[3] = x-PreVta[3] * Almmmatg.tpocmb
        x-PreVta[4] = x-PreVta[4] * Almmmatg.tpocmb.
    /* *********************************************************************************** */
    /* ********************************* Margen de utilidad ****************************** */
    /* *********************************************************************************** */
    IF s-CodDiv = '00065' THEN DO:
        ASSIGN
            x-PreOfi    = x-PreOfi    + f-FleteUnitario
            x-PreVta[1] = x-PreVta[1] + f-FleteUnitario.
        IF Almmmatg.UndA <> "" THEN DO:
            FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                AND  Almtconv.Codalter = Almmmatg.UndA
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtconv THEN DO:
                F-FACTOR = Almtconv.Equival.
                x-PreVta[2] = x-PreVta[2] + f-FleteUnitario * f-Factor.
                F-MrgUti-A = ROUND(((((x-PreVta[2] / F-FACTOR) / x-CtoTot) - 1) * 100), 6).
            END.
        END.
        IF Almmmatg.UndB <> "" THEN DO:
            FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                AND  Almtconv.Codalter = Almmmatg.UndB
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtconv THEN DO:
                F-FACTOR = Almtconv.Equival.
                x-PreVta[3] = x-PreVta[3] + f-FleteUnitario * f-Factor.
                F-MrgUti-B = ROUND(((((x-PreVta[3] / F-FACTOR) / x-CtoTot) - 1) * 100), 6).
            END.
        END.
        IF Almmmatg.UndC <> "" THEN DO:
            FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                AND  Almtconv.Codalter = Almmmatg.UndC
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtconv THEN DO:
                F-FACTOR = Almtconv.Equival.
                x-PreVta[4] = x-PreVta[4] + f-FleteUnitario * f-Factor.
                F-MrgUti-C = ROUND(((((x-PreVta[4] / F-FACTOR) / x-CtoTot) - 1) * 100), 6).
            END.
        END.
        MrgMin = 5000.
        MaxCat = 4.
        MaxVta = 3.
        CASE Almmmatg.Chr__02 :
            WHEN "T" THEN DO:        
                /*  TERCEROS  */
                IF F-MrgUti-A < MrgMin AND F-MrgUti-A <> 0 THEN MrgMin = F-MrgUti-A.
                IF F-MrgUti-B < MrgMin AND F-MrgUti-B <> 0 THEN MrgMin = F-MrgUti-B.
                IF F-MrgUti-C < MrgMin AND F-MrgUti-C <> 0 THEN MrgMin = F-MrgUti-C.
                fmot = (1 + MrgMin / 100) / ((1 - MaxCat / 100) * (1 - MaxVta / 100)).
                MrgOfi = ROUND((fmot - 1) * 100, 6).
            END.
            WHEN "P" THEN DO:
                /* PROPIOS */
               MrgOfi = ((x-Prevta[1] / x-Ctotot) - 1 ) * 100. 

            END. 
        END CASE.    
    END.
    /* *********************************************************************************** */
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.codmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.desmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.codfam + ' ' +  Almtfami.desfam.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.subfam + ' ' +  AlmSFami.dessub.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF Almmmatg.monvta = 1 THEN 'S/.' ELSE 'US$').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.tpocmb.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-ctotot.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-prevta[1].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = f-mrguti-a.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-prevta[2].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.unda.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = f-mrguti-b.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-prevta[3].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.undb.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = f-mrguti-c.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-prevta[4].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.undc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = MrgOfi.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreOfi.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CHR__01.
    ASSIGN
        t-Column = t-Column + 5
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.DesMar.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.TipArt.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.CodPr1 + 
        (IF AVAILABLE gn-prov THEN ' ' + gn-prov.NomPro ELSE '').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = f-FleteUnitario.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-2 W-Win 
PROCEDURE Excel-2 :
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

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
DEF VAR x-PreOfi LIKE VtaListaMinGn.PreOfi NO-UNDO.
DEF VAR x-CtoTot LIKE Almmmatg.CtoTot NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = "UTILEX - PRECIOS"
    chWorkSheet:Range("A2"):Value = "CODIGO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "DESCRIPCION"
    chWorkSheet:Range("C2"):Value = "LINEA"
    chWorkSheet:Columns("C"):NumberFormat = "@"
    chWorkSheet:Range("D2"):Value = "SUBLINEA"
    chWorkSheet:Columns("D"):NumberFormat = "@"
    chWorkSheet:Range("E2"):Value = "MONEDA"
    chWorkSheet:Range("F2"):Value = "TC"
    chWorkSheet:Range("G2"):Value = "COSTO S/."
    chWorkSheet:Range("H2"):Value = "PRECIO UTILEX S/."
    chWorkSheet:Range("I2"):Value = "UNIDAD"
    chWorkSheet:Range("J2"):Value = "MARGEN UTILEX %".
ASSIGN
    t-Row = 2.
FOR EACH Almmmatg NO-LOCK WHERE {&Condicion}, FIRST Almtfami OF Almmmatg NO-LOCK,
    FIRST Almsfami OF Almmmatg NO-LOCK
    BY Almmmatg.CodFam BY Almmmatg.SubFam BY Almmmatg.DesMar BY Almmmatg.CodMat:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.codmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.desmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.codfam + ' ' + Almtfami.desfam.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.subfam + ' ' + AlmSFami.dessub.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF Almmmatg.monvta = 1 THEN 'S/.' ELSE 'US$').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.tpocmb.
    /* COSTO UNITARIO */
    ASSIGN
        x-CtoTot = Almmmatg.CtoTot
        f-Factor = 1.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = VtaListaMinGn.Chr__01
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
    x-CtoTot = x-Ctotot * f-Factor.
    IF Almmmatg.monvta = 2 THEN x-CtoTot = x-CtoTot * Almmmatg.tpocmb.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-CtoTot.
    /* PRECIO UNITARIO */
    FIND FIRST Vtalistamingn OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE VtaListaMinGn THEN DO:
        x-PreOfi = VtaListaMinGn.PreOfi.
        IF Almmmatg.MonVta = 2 THEN x-PreOfi = x-PreOfi * Almmmatg.TpoCmb.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreOfi.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Vtalistamingn.CHR__01
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Vtalistamingn.dec__01.

    END.
    ELSE DO:
        x-PreOfi = 0.
        IF Almmmatg.MonVta = 2 THEN x-PreOfi = x-PreOfi * Almmmatg.TpoCmb.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreOfi.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.CHR__01.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-3 W-Win 
PROCEDURE Excel-3 :
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

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
DEF VAR x-PreOfi LIKE VtaListaMay.PreOfi NO-UNDO.
DEF VAR x-MejorPrecio LIKE VtaListaMay.PreOfi NO-UNDO.
DEF VAR x-MejorUnidad AS CHAR NO-UNDO.
DEF VAR x-CtoTot LIKE Almmmatg.CtoTot NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = s-coddiv + " - PRECIOS"
    chWorkSheet:Range("A2"):Value = "CODIGO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "DESCRIPCION"
    chWorkSheet:Range("C2"):Value = "LINEA"
    chWorkSheet:Columns("C"):NumberFormat = "@"
    chWorkSheet:Range("D2"):Value = "SUBLINEA"
    chWorkSheet:Columns("D"):NumberFormat = "@"
    chWorkSheet:Range("E2"):Value = "MONEDA"
    chWorkSheet:Range("F2"):Value = "TC"
    chWorkSheet:Range("G2"):Value = "COSTO S/."
    chWorkSheet:Range("H2"):Value = "PRECIO OFICINA S/."
    chWorkSheet:Range("I2"):Value = "UNIDAD".
    chWorkSheet:Range("J2"):Value = "MEJOR PRECIO S/.".
    chWorkSheet:Range("K2"):Value = "UNIDAD".
ASSIGN
    t-Row = 2.
FOR EACH Almmmatg NO-LOCK WHERE {&Condicion}, FIRST Almtfami OF Almmmatg NO-LOCK,
    Almsfami OF Almmmatg NO-LOCK:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.codmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.desmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.codfam + ' ' + Almtfami.desfam.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.subfam + ' ' +  AlmSFami.dessub.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF Almmmatg.monvta = 1 THEN 'S/.' ELSE 'US$').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.tpocmb.
    /* COSTO UNITARIO */
    ASSIGN
        x-CtoTot = Almmmatg.CtoTot
        f-Factor = 1.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = VtaListaMay.Chr__01
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
    x-CtoTot = x-Ctotot * f-Factor.
    IF Almmmatg.monvta = 2 THEN x-CtoTot = x-CtoTot * Almmmatg.tpocmb.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-CtoTot.
    /* PRECIO UNITARIO */
    FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.coddiv = s-coddiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaListaMay THEN DO:
        x-PreOfi = VtaListaMay.preofi.
        IF Almmmatg.monvta = 2 THEN x-PreOfi = x-PreOfi * Almmmatg.tpocmb.
        RUN lib/RedondearMas (x-PreOfi, 4, OUTPUT x-PreOfi).
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreOfi.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaListaMay.CHR__01.
    END.
    ELSE DO:
        x-PreOfi = 0.
        IF Almmmatg.monvta = 2 THEN x-PreOfi = x-PreOfi * Almmmatg.tpocmb.
        RUN lib/RedondearMas (x-PreOfi, 4, OUTPUT x-PreOfi).
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreOfi.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.CHR__01.
    END.
    /* MEJOR PRECIO */
    IF Almmmatg.PreVta[2] > 0 THEN DO:
        IF Almmmatg.monvta = 2 THEN x-MejorPrecio = Almmmatg.PreVta[2] * Almmmatg.tpocmb.
        ELSE x-MejorPrecio = Almmmatg.PreVta[2].
             x-MejorUnidad = Almmmatg.UndA.
    END.
    IF Almmmatg.PreVta[3] > 0 THEN DO:
        IF Almmmatg.monvta = 2 THEN x-MejorPrecio = Almmmatg.PreVta[3] * Almmmatg.tpocmb.
        ELSE x-MejorPrecio = Almmmatg.PreVta[3].
             x-MejorUnidad = Almmmatg.UndB.
    END.
    IF Almmmatg.PreVta[4] > 0 THEN DO:
        IF Almmmatg.monvta = 2 THEN x-MejorPrecio = Almmmatg.PreVta[4] * Almmmatg.tpocmb.
        ELSE x-MejorPrecio = Almmmatg.PreVta[4].
             x-MejorUnidad = Almmmatg.UndC.
    END.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-MejorPrecio.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-MejorUnidad.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-4 W-Win 
PROCEDURE Excel-4 :
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

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
DEF VAR x-PreOfi LIKE Almmmatp.PreOfi NO-UNDO.
DEF VAR x-CtoTot LIKE Almmmatg.CtoTot NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR x-UndVta AS CHAR NO-UNDO.
DEF VAR x-MonVta AS CHAR NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = "CONTRATO MARCO - PRECIOS"
    chWorkSheet:Range("A2"):Value = "CODIGO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "DESCRIPCION"
    chWorkSheet:Range("C2"):Value = "LINEA"
    chWorkSheet:Columns("C"):NumberFormat = "@"
    chWorkSheet:Range("D2"):Value = "SUBLINEA"
    chWorkSheet:Columns("D"):NumberFormat = "@"
    chWorkSheet:Range("E2"):Value = "MONEDA VENTA"
    chWorkSheet:Range("F2"):Value = "UNIDAD"
    chWorkSheet:Range("G2"):Value = "PRECIO VENTA S/."
    chWorkSheet:Range("H2"):Value = "MONEDA COSTO"
    chWorkSheet:Range("I2"):Value = "TC"
    chWorkSheet:Range("J2"):Value = "COSTO MARCO S/.".
ASSIGN
    t-Row = 2.
FOR EACH Almmmatg NO-LOCK WHERE {&Condicion}, FIRST Almtfami OF Almmmatg NO-LOCK, Almsfami OF Almmmatg NO-LOCK:
    FIND FIRST Almmmatp OF Almmmatg NO-LOCK NO-ERROR.
    ASSIGN
        x-CtoTot = 0
        x-PreOfi = 0
        f-Factor = 1
        x-UndVta = Almmmatg.UndBas
        x-MonVta = 'S/.'.
    /* PRECIO UNITARIO */
    FIND FIRST Almmmatp OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatp THEN DO:
        x-PreOfi = Almmmatp.PreOfi.
        x-CtoTot = Almmmatp.CtoTot.
        x-UndVta = Almmmatp.CHR__01.
        x-MonVta = (IF Almmmatp.MonVta = 1 THEN 'S/.' ELSE 'US$').
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = Almmmatp.Chr__01
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
        x-CtoTot = x-Ctotot * f-Factor.
        IF Almmmatg.MonVta = 2 
            THEN ASSIGN 
            x-CtoTot = x-CtoTot * Almmmatg.TpoCmb.
        IF Almmmatp.MonVta = 2 
            THEN ASSIGN
            x-PreOfi = x-PreOfi * Almmmatg.TpoCmb.
    END.
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.codmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.desmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.codfam + ' ' + Almtfami.desfam.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.subfam + ' ' + AlmSFami.dessub.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-MonVta.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-UndVta.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreOfi.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF Almmmatg.MonVta = 1 THEN 'S/.' ELSE 'US$').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.tpocmb.
    /* COSTO UNITARIO */
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-CtoTot.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-5 W-Win 
PROCEDURE Excel-5 :
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

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
DEF VAR x-PreOfi LIKE ListaTerceros.PreOfi NO-UNDO.
DEF VAR x-CtoTot LIKE Almmmatg.CtoTot NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR k AS INT NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = "CONTINENTAL - PRECIOS TERCEROS"
    chWorkSheet:Range("A2"):Value = "CODIGO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "DESCRIPCION"
    chWorkSheet:Range("C2"):Value = "LINEA"
    chWorkSheet:Columns("C"):NumberFormat = "@"
    chWorkSheet:Range("D2"):Value = "SUBLINEA"
    chWorkSheet:Columns("D"):NumberFormat = "@"
    chWorkSheet:Range("E2"):Value = "MONEDA"
    chWorkSheet:Range("F2"):Value = "TC"
    chWorkSheet:Range("G2"):Value = "COSTO S/."
    chWorkSheet:Range("H2"):Value = "PRECIO LISTA #1 S/."
    chWorkSheet:Range("I2"):Value = "PRECIO LISTA #2 S/."
    chWorkSheet:Range("J2"):Value = "PRECIO LISTA #3 S/."
    chWorkSheet:Range("K2"):Value = "UNIDAD".
    chWorkSheet:Range("L2"):Value = "MARCA".
ASSIGN
    t-Row = 2.
FOR EACH Almmmatg NO-LOCK WHERE {&Condicion}, FIRST Almtfami OF Almmmatg NO-LOCK, FIRST Almsfami OF Almmmatg NO-LOCK:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.codmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.desmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.codfam + ' ' + Almtfami.desfam.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.subfam + ' ' +  AlmSFami.dessub.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF Almmmatg.monvta = 1 THEN 'S/.' ELSE 'US$').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.tpocmb.
    /* COSTO UNITARIO */
    ASSIGN
        x-CtoTot = Almmmatg.CtoTot
        f-Factor = 1.
/*     FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas */
/*         AND Almtconv.Codalter = ListaTerceros.Chr__01       */
/*         NO-LOCK NO-ERROR.                                   */
/*     IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival. */
    x-CtoTot = x-Ctotot * f-Factor.
    IF Almmmatg.monvta = 2 THEN x-CtoTot = x-CtoTot * Almmmatg.tpocmb.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-CtoTot.
    /* PRECIO UNITARIO */
    FIND FIRST ListaTerceros OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE ListaTerceros THEN DO:
        DO k = 1 TO 3:
            x-PreOfi[k] = ListaTerceros.preofi[k].
            IF Almmmatg.monvta = 2 THEN x-PreOfi[k] = x-PreOfi[k] * Almmmatg.tpocmb.
            RUN lib/RedondearMas (x-PreOfi[k], 4, OUTPUT x-PreOfi[k]).
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreOfi[k].
        END.
    END.
    ELSE DO:
        DO k = 1 TO 3:
            x-PreOfi[k] = 0.
            IF Almmmatg.monvta = 2 THEN x-PreOfi[k] = x-PreOfi[k] * Almmmatg.tpocmb.
            RUN lib/RedondearMas (x-PreOfi[k], 4, OUTPUT x-PreOfi[k]).
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreOfi[k].
        END.
    END.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.UndStk.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.DesMar.
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
      FIND gn-divi WHERE gn-divi.codcia = s-codcia
          AND gn-divi.coddiv = s-coddiv
          NO-LOCK.
      FILL-IN-Division = "DIVISIÓN: " + gn-divi.coddiv + " " + GN-DIVI.DesDiv.
      FOR EACH Vtatabla NO-LOCK WHERE Vtatabla.codcia = s-codcia
          AND Vtatabla.tabla = "LP"
          AND Vtatabla.llave_c1 = s-user-id,
          FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
          AND Almtfami.codfam = Vtatabla.llave_c2:
          COMBO-BOX-CodFam:ADD-LAST( Almtfami.codfam + ' - ' + Almtfami.desfam).
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "Almmmatg"}

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

