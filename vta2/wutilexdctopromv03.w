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

    /*AND (x-CodFam = 'Todas' OR Almmmatg.codfam = x-codfam) ~*/

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
&Scoped-Define ENABLED-OBJECTS RECT-2 RADIO-SET-1 COMBO-BOX-CodFam ~
COMBO-BOX-SubFam x-CodPro x-DesMar BUTTON-1 RADIO-SET-2 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Division RADIO-SET-1 ~
COMBO-BOX-CodFam COMBO-BOX-SubFam x-CodPro FILL-IN-NomPro x-DesMar ~
RADIO-SET-2 

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
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 59 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Sub-línea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
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
"Lista Contrato Marco", 4
     SIZE 24 BY 3.46 NO-UNDO.

DEFINE VARIABLE RADIO-SET-2 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Porcentajes", 1,
"Importes", 2
     SIZE 22 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
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
     FILL-IN-Division AT ROW 1.19 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     RADIO-SET-1 AT ROW 2.35 COL 79 NO-LABEL WIDGET-ID 24
     COMBO-BOX-CodFam AT ROW 2.54 COL 13 COLON-ALIGNED WIDGET-ID 8
     COMBO-BOX-SubFam AT ROW 3.5 COL 13 COLON-ALIGNED WIDGET-ID 10
     x-CodPro AT ROW 4.46 COL 13 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-NomPro AT ROW 4.46 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     x-DesMar AT ROW 5.42 COL 13 COLON-ALIGNED WIDGET-ID 16
     BUTTON-1 AT ROW 5.42 COL 28 WIDGET-ID 18
     RADIO-SET-2 AT ROW 5.81 COL 79 NO-LABEL WIDGET-ID 32
     BROWSE-2 AT ROW 6.77 COL 2 WIDGET-ID 200
     "Valores en:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6 COL 70 WIDGET-ID 36
     RECT-2 AT ROW 1 COL 1 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 107.43 BY 18.46
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
         TITLE              = "PREPARAR PLANTILLA DESCUENTOS PROMOCIONALES"
         HEIGHT             = 18.46
         WIDTH              = 107.43
         MAX-HEIGHT         = 19.08
         MAX-WIDTH          = 111.14
         VIRTUAL-HEIGHT     = 19.08
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
/* BROWSE-TAB BROWSE-2 RADIO-SET-2 F-Main */
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
ON END-ERROR OF W-Win /* PREPARAR PLANTILLA DESCUENTOS PROMOCIONALES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PREPARAR PLANTILLA DESCUENTOS PROMOCIONALES */
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
        RADIO-SET-1 RADIO-SET-2.
/*     IF RADIO-SET-1 > 3 THEN DO:                                      */
/*         MESSAGE 'Bloqueado temporalmente' VIEW-AS ALERT-BOX WARNING. */
/*         RETURN NO-APPLY.                                             */
/*     END.                                                             */

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Excel.
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
  DISPLAY FILL-IN-Division RADIO-SET-1 COMBO-BOX-CodFam COMBO-BOX-SubFam 
          x-CodPro FILL-IN-NomPro x-DesMar RADIO-SET-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 RADIO-SET-1 COMBO-BOX-CodFam COMBO-BOX-SubFam x-CodPro x-DesMar 
         BUTTON-1 RADIO-SET-2 BROWSE-2 
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
DEF VAR f-Divisiones AS CHAR NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.


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
    chWorkSheet:Range("A1"):Value = "DESCUENTOS PROMOCIONALES"
    chWorkSheet:Range("A2"):Value = "CODIGO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "DESCRIPCION"
    chWorkSheet:Range("C2"):Value = "LINEA"
    chWorkSheet:Columns("C"):NumberFormat = "@"
    chWorkSheet:Range("D2"):Value = "MONEDA"
    chWorkSheet:Range("E2"):Value = "TC"
    chWorkSheet:Range("F2"):Value = "COSTO UNITARIO S/."
    chWorkSheet:Range("G2"):Value = "PRECIO LISTA S/."
    chWorkSheet:Range("H2:AZ2"):NumberFormat = "@".
CASE RADIO-SET-1:
    WHEN 1 THEN chWorkSheet:Range("A1"):Value = "CONTINENTAL - DESCUENTOS PROMOCIONALES".
    WHEN 2 THEN chWorkSheet:Range("A1"):Value = "UTILEX - DESCUENTOS PROMOCIONALES".
    WHEN 3 THEN chWorkSheet:Range("A1"):Value = s-coddiv + " - DESCUENTOS PROMOCIONALES".
    WHEN 4 THEN chWorkSheet:Range("A1"):Value = "CONTRATO MARCO - DESCUENTOS PROMOCIONALES".
    WHEN 5 THEN chWorkSheet:Range("A1"):Value = "PROVINCIAS - DESCUENTOS PROMOCIONALES DE TERCEROS".
    WHEN 6 THEN chWorkSheet:Range("A1"):Value = "PROVINCIAS - DESCUENTOS PROMOCIONALES PROPIOS".
END CASE.
/* PROVINCIAS TERCEROS SIEMPRE VA A SER IMPORTES */
IF RADIO-SET-1 = 5 THEN RADIO-SET-2 = 2.
/* ********************************************* */
CASE RADIO-SET-2:
    WHEN 1 THEN chWorkSheet:Range("A1"):VALUE = chWorkSheet:Range("A1"):VALUE + " - PORCENTAJES".
    WHEN 2 THEN chWorkSheet:Range("A1"):VALUE = chWorkSheet:Range("A1"):VALUE + " - IMPORTES".
END CASE.

cRange = "H".
ASSIGN
    chWorkSheet:Range(cRange + "2"):Value = "DESDE"
    chWorkSheet:Columns(cRange):NumberFormat = "dd/MM/yyyy"
    cRange = CHR(ASC(cRange) + 1)
    chWorkSheet:Range(cRange + "2"):Value = "HASTA"
    chWorkSheet:Columns(cRange):NumberFormat = "dd/MM/yyyy"
    cRange = CHR(ASC(cRange) + 1).
/* Sedes */
CASE RADIO-SET-1:
    WHEN 1 THEN DO: 
        FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
            AND LOOKUP(GN-DIVI.CanalVenta, 'TDA,HOR,INS') > 0
            AND GN-DIVI.Campo-Log[1] = NO:      /* ¿INACTIVO? */
            f-Divisiones = f-Divisiones + (IF TRUE <> (f-Divisiones > "") THEN '' ELSE ',') + gn-divi.coddiv.
        END.
    END.
    WHEN 2 THEN DO:
        FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
            AND LOOKUP(GN-DIVI.CanalVenta, 'MIN') > 0
            AND GN-DIVI.Campo-Log[1] = NO:      /* ¿INACTIVO? */
            f-Divisiones = f-Divisiones + (IF TRUE <> (f-Divisiones > "") THEN '' ELSE ',') + gn-divi.coddiv.
        END.
    END.
    WHEN 3 THEN f-Divisiones = s-coddiv.
    WHEN 4 THEN f-Divisiones = "00024".
    WHEN 5 THEN f-Divisiones = "00018,00018".
    WHEN 6 THEN f-Divisiones = "00018".
END CASE.

ASSIGN
    t-Row = 2
    t-Column = 9.
DO k = 1 TO NUM-ENTRIES(f-Divisiones):
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = ENTRY(k, f-Divisiones)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN NEXT.
    t-Column = t-Column + 1.
    chWorkSheet:Cells(1, t-Column):VALUE = GN-DIVI.DesDiv.
    chWorkSheet:Cells(2, t-Column):VALUE = GN-DIVI.CodDiv.
    IF RADIO-SET-1 = 5 AND k = 1 THEN chWorkSheet:Range(cRange + "2"):Value = "A".
    IF RADIO-SET-1 = 5 AND k = 2 THEN chWorkSheet:Range(cRange + "2"):Value = "B".
    cRange = CHR(ASC(cRange) + 1).
END.

ASSIGN
    t-Row = 2.
FOR EACH Almmmatg NO-LOCK WHERE {&Condicion}:
    FIND Vtalistamingn OF Almmmatg NO-LOCK NO-ERROR.
    FIND Almmmatp OF Almmmatg NO-LOCK NO-ERROR.
    FIND VtaListaMay OF Almmmatg WHERE VtaListaMay.coddiv = s-coddiv NO-LOCK NO-ERROR.
    IF RADIO-SET-1 = 2 AND NOT AVAILABLE Vtalistamingn  THEN NEXT.
    IF RADIO-SET-1 = 3 AND NOT AVAILABLE VtaListaMay    THEN NEXT.
    IF RADIO-SET-1 = 4 AND NOT AVAILABLE Almmmatp       THEN NEXT.
    IF RADIO-SET-1 = 5 AND Almmmatg.CHR__02 <> "T"      THEN NEXT.
    IF RADIO-SET-1 = 6 AND Almmmatg.CHR__02 <> "P"      THEN NEXT.
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
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.codfam.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF Almmmatg.monvta = 1 THEN 'S/.' ELSE 'US$').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.tpocmb.
    CASE RADIO-SET-1:
        WHEN 1 THEN DO:
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.ctotot * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.prevta[1] * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1)
                x-PreOfi = chWorkSheet:Cells(t-Row, t-Column):VALUE.
            ASSIGN
                t-Column = t-Column + 2.
            DO k = 1 TO NUM-ENTRIES(f-Divisiones):
                ASSIGN
                    t-Column = t-Column + 1.
                FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
                    AND VtaTabla.Tabla = "DTOPROLIMA"
                    AND VtaTabla.Llave_c1 = Almmmatg.codmat
                    AND VtaTabla.Llave_c2 = ENTRY(k, f-Divisiones)
                    NO-LOCK NO-ERROR.
                IF AVAILABLE VtaTabla THEN DO:
                    ASSIGN
                        chWorkSheet:Cells(t-Row, 8):VALUE = VtaTabla.Rango_Fecha[1] 
                        chWorkSheet:Cells(t-Row, 9):VALUE = VtaTabla.Rango_Fecha[2] 
                        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF RADIO-SET-2 = 1 THEN VtaTabla.Valor[1] 
                            ELSE ROUND(x-PreOfi * ( 1 - ( VtaTabla.Valor[1] / 100 ) ),4) )
                        NO-ERROR.
                END.
            END.
        END.
        WHEN 2 THEN DO:
            /* COSTO UNITARIO */
            x-CtoTot = Almmmatg.CtoTot.
            f-Factor = 1.
            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                AND Almtconv.Codalter = VtaListaMinGn.Chr__01
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
            x-CtoTot = x-Ctotot * f-Factor  * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = x-CtoTot.
            /* PRECIO UNITARIO */
            x-PreOfi = VtaListaMinGn.PreOfi  * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreOfi.
            ASSIGN
                t-Column = t-Column + 2.
            DO k = 1 TO NUM-ENTRIES(f-Divisiones):
                ASSIGN
                    t-Column = t-Column + 1.
                FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
                    AND VtaTabla.Tabla = "DTOPROUTILEX"
                    AND VtaTabla.Llave_c1 = Almmmatg.codmat
                    AND VtaTabla.Llave_c2 = ENTRY(k, f-Divisiones)
                    NO-LOCK NO-ERROR.
                IF AVAILABLE VtaTabla THEN DO:
                    ASSIGN
                        chWorkSheet:Cells(t-Row, 8):VALUE = VtaTabla.Rango_Fecha[1] 
                        chWorkSheet:Cells(t-Row, 9):VALUE = VtaTabla.Rango_Fecha[2] 
                        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF RADIO-SET-2 = 1 THEN VtaTabla.Valor[1] 
                            ELSE ROUND(x-PreOfi * ( 1 - ( VtaTabla.Valor[1] / 100 ) ),4) )
                        NO-ERROR.
                END.
            END.
        END.
        WHEN 3 THEN DO:
            /* COSTO UNITARIO */
            x-CtoTot = Almmmatg.CtoTot.
            f-Factor = 1.
            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                AND Almtconv.Codalter = VtaListaMay.Chr__01
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
            x-CtoTot = x-Ctotot * f-Factor  * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = x-CtoTot.
            /* PRECIO UNITARIO */
            x-PreOfi = VtaListaMay.PreOfi  * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreOfi.
            ASSIGN
                t-Column = t-Column + 3.
            ASSIGN
                chWorkSheet:Cells(t-Row, 8):VALUE = VtaListaMay.PromFchD
                chWorkSheet:Cells(t-Row, 9):VALUE = VtaListaMay.PromFchH
                NO-ERROR.
            IF VtaListaMay.PromFchD <> ? THEN
                chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF RADIO-SET-2 = 1 THEN VtaListaMay.PromDto
                    ELSE ROUND(x-PreOfi * ( 1 - ( VtaListaMay.PromDto / 100 ) ),4) ).
        END.
        WHEN 4 THEN DO:
            /* COSTO UNITARIO */
            x-CtoTot = Almmmatg.CtoTotMarco.
            f-Factor = 1.
            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                AND Almtconv.Codalter = Almmmatp.Chr__01
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
            x-CtoTot = x-Ctotot * f-Factor  * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = x-CtoTot.
            /* PRECIO UNITARIO */
            x-PreOfi = Almmmatp.PreOfi.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreOfi.
            ASSIGN
                t-Column = t-Column + 2.
            DO k = 1 TO NUM-ENTRIES(f-Divisiones):
                ASSIGN
                    t-Column = t-Column + 1.
                DO j = 1 TO 10:
                    IF Almmmatp.PromDivi[j] = ENTRY(k, f-Divisiones) THEN DO:
                        ASSIGN
                            chWorkSheet:Cells(t-Row, 8):VALUE = Almmmatp.PromFchD[j] 
                            chWorkSheet:Cells(t-Row, 9):VALUE = Almmmatp.PromFchH[j] 
                            chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF RADIO-SET-2 = 1 THEN Almmmatp.PromDto[j]
                                ELSE ROUND(x-PreOfi * ( 1 - ( Almmmatp.PromDto[j] / 100 ) ),4) )
                            NO-ERROR.
                        LEAVE.
                    END.
                END.
            END.
        END.
        WHEN 5 THEN DO:     /* PROVINCIAS: PRODUCTOS DE TERCEROS */
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.ctotot * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.prevta[1] * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1)
                x-PreOfi = chWorkSheet:Cells(t-Row, t-Column):VALUE.
            ASSIGN
                t-Column = t-Column + 2.
            IF Almmmatg.PromMinDivi[1] = "00018" THEN DO:
                ASSIGN
                    t-Column = t-Column + 1
                    x-PreOfi = Almmmatg.PromMinDto[1]  * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
                ASSIGN
                    chWorkSheet:Cells(t-Row, 8):VALUE = Almmmatg.PromMinFchD[1] 
                    chWorkSheet:Cells(t-Row, 9):VALUE = Almmmatg.PromMinFchH[1] 
                    chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreOfi
                    NO-ERROR.
                ASSIGN
                    t-Column = t-Column + 1
                    x-PreOfi = Almmmatg.PromMinDto[2]  * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
                ASSIGN
                    chWorkSheet:Cells(t-Row, t-Column):VALUE = x-PreOfi
                    NO-ERROR.
            END.
        END.
        WHEN 6 THEN DO:
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.ctotot * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.prevta[1] * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1)
                x-PreOfi = chWorkSheet:Cells(t-Row, t-Column):VALUE.
            ASSIGN
                t-Column = t-Column + 2.
            IF Almmmatg.PromMinDivi[1] = "00018" THEN DO:
                ASSIGN
                    t-Column = t-Column + 1.
                ASSIGN
                    chWorkSheet:Cells(t-Row, 8):VALUE = Almmmatg.PromMinFchD[1] 
                    chWorkSheet:Cells(t-Row, 9):VALUE = Almmmatg.PromMinFchH[1] 
                    chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF RADIO-SET-2 = 1 THEN Almmmatg.PromMinDto[1] 
                        ELSE ROUND(x-PreOfi * ( 1 - ( Almmmatg.PromMinDto[1] / 100 ) ),4) )
                    NO-ERROR.
            END.
        END.
    END CASE.
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
      FOR EACH Vtatabla NO-LOCK WHERE codcia = s-codcia
          AND tabla = "LP"
          AND llave_c1 = s-user-id,
          FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
          AND Almtfami.codfam = Vtatabla.llave_c2:
          COMBO-BOX-CodFam:ADD-LAST( Almtfami.codfam + ' - ' + Almtfami.desfam).
      END.
      FIND gn-divi WHERE gn-divi.codcia = s-codcia
          AND gn-divi.coddiv = s-coddiv
          NO-LOCK.
      FILL-IN-Division = "DIVISIÓN: " + gn-divi.coddiv + " " + GN-DIVI.DesDiv.
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

