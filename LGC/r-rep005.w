&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-COCmp NO-UNDO LIKE LG-COCmp.



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

DEF VAR x-Moneda AS CHAR FORMAT 'x(3)' NO-UNDO.

&SCOPED-DEFINE Condicion1 ( lg-cocmp.codcia = s-codcia ~
AND ( FILL-IN-CodPro = "" OR lg-cocmp.codpro = FILL-IN-CodPro) ~
AND lg-cocmp.flgsit <> "A" ~
AND ( lg-cocmp.fchdoc >= FILL-IN-FchDoc-1 AND lg-cocmp.fchdoc <= FILL-IN-FchDoc-2 ) ) 

&SCOPED-DEFINE Condicion2 ( ( FILL-IN-CodMat = "" OR lg-docmp.codmat = FILL-IN-CodMat) )

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
&Scoped-define INTERNAL-TABLES T-COCmp LG-DOCmp Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 LG-DOCmp.Codmat Almmmatg.DesMat ~
LG-DOCmp.UndCmp T-COCmp.NroDoc T-COCmp.CodPro T-COCmp.NomPro T-COCmp.Fchdoc ~
LG-DOCmp.CanPedi ~
IF (T-Cocmp.Codmon = 1) THEN ('S/.') ELSE ('US$') @ x-Moneda ~
LG-DOCmp.PreUni 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-COCmp NO-LOCK, ~
      EACH LG-DOCmp OF T-COCmp ~
      WHERE {&condicion2} NO-LOCK, ~
      FIRST Almmmatg OF LG-DOCmp NO-LOCK ~
    BY T-COCmp.Fchdoc DESCENDING
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-COCmp NO-LOCK, ~
      EACH LG-DOCmp OF T-COCmp ~
      WHERE {&condicion2} NO-LOCK, ~
      FIRST Almmmatg OF LG-DOCmp NO-LOCK ~
    BY T-COCmp.Fchdoc DESCENDING.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-COCmp LG-DOCmp Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-COCmp
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 LG-DOCmp
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-2 FILL-IN-CodPro FILL-IN-CodMat ~
FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 BUTTON-1 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-DesMat FILL-IN-CodPro ~
FILL-IN-NomPro FILL-IN-CodMat FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "FILTRAR" 
     SIZE 15 BY 1.35.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 5 BY 1.35.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-COCmp, 
      LG-DOCmp, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      LG-DOCmp.Codmat FORMAT "x(8)":U
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 45.14
      LG-DOCmp.UndCmp COLUMN-LABEL "Unidad" FORMAT "X(3)":U
      T-COCmp.NroDoc COLUMN-LABEL "O/C" FORMAT "999999":U
      T-COCmp.CodPro COLUMN-LABEL "Proveedor" FORMAT "x(11)":U
      T-COCmp.NomPro FORMAT "X(40)":U WIDTH 27.14
      T-COCmp.Fchdoc COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
      LG-DOCmp.CanPedi COLUMN-LABEL "Cantidad" FORMAT "Z,ZZZ,ZZ9.99":U
      IF (T-Cocmp.Codmon = 1) THEN ('S/.') ELSE ('US$') @ x-Moneda COLUMN-LABEL "Mnd"
      LG-DOCmp.PreUni COLUMN-LABEL "Costo Unitario" FORMAT ">>>,>>9.9999":U
            WIDTH 6.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 134 BY 12.5
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 2.92 COL 64 WIDGET-ID 16
     FILL-IN-DesMat AT ROW 2.15 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-CodPro AT ROW 1.19 COL 10 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-NomPro AT ROW 1.19 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     FILL-IN-CodMat AT ROW 2.15 COL 10 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-FchDoc-1 AT ROW 3.12 COL 10 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-FchDoc-2 AT ROW 3.12 COL 29 COLON-ALIGNED WIDGET-ID 10
     BUTTON-1 AT ROW 2.92 COL 49 WIDGET-ID 12
     BROWSE-2 AT ROW 4.46 COL 3 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 138 BY 17
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-COCmp T "?" NO-UNDO INTEGRAL LG-COCmp
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PRECIOS POR ORDEN DE COMPRA"
         HEIGHT             = 17
         WIDTH              = 138
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 138
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 138
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
/* BROWSE-TAB BROWSE-2 BUTTON-1 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat IN FRAME F-Main
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
     _TblList          = "Temp-Tables.T-COCmp,INTEGRAL.LG-DOCmp OF Temp-Tables.T-COCmp,INTEGRAL.Almmmatg OF INTEGRAL.LG-DOCmp"
     _Options          = "NO-LOCK"
     _TblOptList       = ",, FIRST"
     _OrdList          = "Temp-Tables.T-COCmp.Fchdoc|no"
     _Where[2]         = "{&condicion2}"
     _FldNameList[1]   = INTEGRAL.LG-DOCmp.Codmat
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"INTEGRAL.Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "45.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.LG-DOCmp.UndCmp
"INTEGRAL.LG-DOCmp.UndCmp" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-COCmp.NroDoc
"Temp-Tables.T-COCmp.NroDoc" "O/C" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-COCmp.CodPro
"Temp-Tables.T-COCmp.CodPro" "Proveedor" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-COCmp.NomPro
"Temp-Tables.T-COCmp.NomPro" ? ? "character" ? ? ? ? ? ? no ? no no "27.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-COCmp.Fchdoc
"Temp-Tables.T-COCmp.Fchdoc" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.LG-DOCmp.CanPedi
"INTEGRAL.LG-DOCmp.CanPedi" "Cantidad" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"IF (T-Cocmp.Codmon = 1) THEN ('S/.') ELSE ('US$') @ x-Moneda" "Mnd" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.LG-DOCmp.PreUni
"INTEGRAL.LG-DOCmp.PreUni" "Costo Unitario" ? "decimal" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PRECIOS POR ORDEN DE COMPRA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PRECIOS POR ORDEN DE COMPRA */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* FILTRAR */
DO:
  ASSIGN
      FILL-IN-CodMat FILL-IN-CodPro FILL-IN-FchDoc-1 FILL-IN-FchDoc-2.
/*   IF FILL-IN-CodPro = '' THEN DO:                             */
/*       MESSAGE 'Ingrese el proveedor' VIEW-AS ALERT-BOX ERROR. */
/*       APPLY 'entry' TO FILL-IN-CodPro.                        */
/*       RETURN NO-APPLY.                                        */
/*   END.                                                        */
  IF FILL-IN-FchDoc-1 = ? OR FILL-IN-FchDoc-2 = ? THEN DO:
      MESSAGE 'Ingrese las fechas correctamente' VIEW-AS ALERT-BOX ERROR.
      APPLY 'entry' TO FILL-IN-FchDoc-1.
      RETURN NO-APPLY.
  END.
  RUN Carga-Temporal.
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


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat W-Win
ON LEAVE OF FILL-IN-CodMat IN FRAME F-Main /* Artículo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, NO).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    ASSIGN {&self-name}.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = pCodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN  FILL-IN-DesMat:SCREEN-VALUE = Almmmatg.desmat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro W-Win
ON LEAVE OF FILL-IN-CodPro IN FRAME F-Main /* Proveedor */
DO:
  ASSIGN {&self-name}.
  FIND gn-prov WHERE gn-prov.codcia = pv-codcia
      AND gn-prov.codpro = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN  FILL-IN-NomPro:SCREEN-VALUE = gn-prov.NomPro.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE t-cocmp.

SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH lg-cocmp NO-LOCK WHERE {&condicion1}:
    CREATE t-cocmp.
    BUFFER-COPY lg-cocmp TO t-cocmp.
END.
SESSION:SET-WAIT-STATE('').
FIND FIRST t-cocmp WHERE CAN-FIND(FIRST lg-docmp OF t-cocmp WHERE {&condicion2} NO-LOCK)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE t-cocmp THEN DO:
    MESSAGE 'NO hay registros a mostrar' VIEW-AS ALERT-BOX WARNING.
END.

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
  DISPLAY FILL-IN-DesMat FILL-IN-CodPro FILL-IN-NomPro FILL-IN-CodMat 
          FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-2 FILL-IN-CodPro FILL-IN-CodMat FILL-IN-FchDoc-1 
         FILL-IN-FchDoc-2 BUTTON-1 BROWSE-2 
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
chWorkSheet:Range("A1"):Value = "CODIGO".
chWorkSheet:Range("B1"):Value = "DESCRIPCION".
chWorkSheet:Range("C1"):Value = "UNIDAD".
chWorkSheet:Range("D1"):Value = "O/C".
chWorkSheet:Range("E1"):Value = "PROVEEDOR".
chWorkSheet:Range("F1"):Value = "NOMBRE".
chWorkSheet:Range("G1"):Value = "FECHA".
chWorkSheet:Range("H1"):Value = "CANTIDAD".
chWorkSheet:Range("I1"):Value = "MONEDA".
chWorkSheet:Range("J1"):Value = "COSTO UNITARIO".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("D"):NumberFormat = "@".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".
chWorkSheet:COLUMNS("G"):NumberFormat = "dd/MM/yyyy".

GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE T-COCMP:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = lg-docmp.codmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = almmmatg.desmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = lg-docmp.undcmp.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-COCMP.nrodoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-COCMP.codpro.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-COCMP.nompro.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = T-COCMP.fchdoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = lg-docmp.canpedi.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF T-COCMP.codmon = 1 THEN 'S/.' ELSE 'US$').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = lg-docmp.preuni.
    GET NEXT {&browse-name}.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

{&OPEN-QUERY-{&BROWSE-NAME}}

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
  ASSIGN
      FILL-IN-FchDoc-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-FchDoc-2 = TODAY.

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
  {src/adm/template/snd-list.i "T-COCmp"}
  {src/adm/template/snd-list.i "LG-DOCmp"}
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

