&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MATE NO-UNDO LIKE Almmmate.
DEFINE TEMP-TABLE T-MATE-2 NO-UNDO LIKE Almmmate.



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
DEF SHARED VAR s-user-id AS CHAR.

DEFINE VARIABLE chExcelApplication  AS COM-HANDLE.
DEFINE VARIABLE chWorkbook          AS COM-HANDLE.
DEFINE VARIABLE chWorksheet         AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.

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
&Scoped-define INTERNAL-TABLES T-MATE Almmmatg Almmmate T-MATE-2

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 T-MATE.CodAlm T-MATE.codmat ~
T-MATE.VCtMn1 T-MATE.VCtMn2 T-MATE.StkMax Almmmatg.UndStk Almmmatg.DesMat ~
Almmmatg.DesMar 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH T-MATE NO-LOCK, ~
      FIRST Almmmatg OF T-MATE NO-LOCK, ~
      FIRST Almmmate OF T-MATE NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH T-MATE NO-LOCK, ~
      FIRST Almmmatg OF T-MATE NO-LOCK, ~
      FIRST Almmmate OF T-MATE NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 T-MATE Almmmatg Almmmate
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 T-MATE
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-5 Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-5 Almmmate


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 T-MATE-2.CodAlm T-MATE-2.codmat ~
T-MATE-2.StkMin T-MATE-2.StkMax T-MATE-2.StkAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH T-MATE-2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH T-MATE-2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 T-MATE-2
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 T-MATE-2


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-26 RECT-27 BUTTON-1 BUTTON-2 BROWSE-5 ~
TOGGLE-Campana TOGGLE-NoCampana TOGGLE-Empaque BROWSE-7 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje TOGGLE-Campana ~
TOGGLE-NoCampana TOGGLE-Empaque 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "CAPTURAR EXCEL" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "ACTUALIZAR BASE DE DATOS" 
     SIZE 25 BY 1.12.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 119 BY 5.77
     BGCOLOR 15 .

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY 3.27.

DEFINE VARIABLE TOGGLE-Campana AS LOGICAL INITIAL yes 
     LABEL "CAMPAÑA" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Empaque AS LOGICAL INITIAL yes 
     LABEL "EMPAQUE" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-NoCampana AS LOGICAL INITIAL yes 
     LABEL "NO CAMPAÑA" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      T-MATE, 
      Almmmatg, 
      Almmmate SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      T-MATE-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      T-MATE.CodAlm FORMAT "x(5)":U
      T-MATE.codmat COLUMN-LABEL "Artículo" FORMAT "X(6)":U WIDTH 6.43
      T-MATE.VCtMn1 COLUMN-LABEL "CAMPAÑA" FORMAT "ZZZ,ZZZ,ZZ9.99":U
      T-MATE.VCtMn2 COLUMN-LABEL "NO CAMPAÑA" FORMAT "ZZZ,ZZZ,ZZ9.99":U
      T-MATE.StkMax COLUMN-LABEL "Empaque" FORMAT "Z,ZZZ,ZZZ,ZZ9.99":U
      Almmmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(6)":U WIDTH 7.43
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 44.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U WIDTH 21.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 119 BY 16.92
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 W-Win _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      T-MATE-2.CodAlm COLUMN-LABEL "ALMACEN" FORMAT "x(5)":U WIDTH 14.43
      T-MATE-2.codmat COLUMN-LABEL "ARTICULO" FORMAT "X(6)":U WIDTH 12.43
      T-MATE-2.StkMin COLUMN-LABEL "CAMPAÑA" FORMAT "Z,ZZZ,ZZ9.99":U
            WIDTH 12.43
      T-MATE-2.StkMax COLUMN-LABEL "NO CAMPAÑA" FORMAT "Z,ZZZ,ZZZ,ZZ9.99":U
            WIDTH 13.43
      T-MATE-2.StkAct COLUMN-LABEL "EMPAQUE" FORMAT "Z,ZZZ,ZZZ,ZZ9.99":U
            WIDTH 13.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 72 BY 4.5
         FONT 4
         TITLE "  COLUM A | COLUMNA B   | COLUMNA C  | COLUMNA D   |   COLUMNA E" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.19 COL 2 WIDGET-ID 2
     BUTTON-2 AT ROW 1.19 COL 27 WIDGET-ID 4
     FILL-IN-Mensaje AT ROW 1.38 COL 82 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     BROWSE-5 AT ROW 2.73 COL 2 WIDGET-ID 200
     TOGGLE-Campana AT ROW 3.5 COL 125 WIDGET-ID 46
     TOGGLE-NoCampana AT ROW 4.27 COL 125 WIDGET-ID 48
     TOGGLE-Empaque AT ROW 5.04 COL 125 WIDGET-ID 50
     BROWSE-7 AT ROW 20.62 COL 7 WIDGET-ID 300
     "FORMATO PLANTILLA EXCEL" VIEW-AS TEXT
          SIZE 23 BY .5 AT ROW 19.85 COL 4 WIDGET-ID 36
          BGCOLOR 1 FGCOLOR 15 
     "Actualizar campos:" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 2.73 COL 124 WIDGET-ID 52
          BGCOLOR 9 FGCOLOR 15 
     RECT-26 AT ROW 19.85 COL 2 WIDGET-ID 34
     RECT-27 AT ROW 2.92 COL 123 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 142.86 BY 24.85
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-MATE T "?" NO-UNDO INTEGRAL Almmmate
      TABLE: T-MATE-2 T "?" NO-UNDO INTEGRAL Almmmate
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "IMPORTAR REPOSICION CAMPAÑA Y NO CAMPAÑA"
         HEIGHT             = 24.85
         WIDTH              = 142.86
         MAX-HEIGHT         = 25.15
         MAX-WIDTH          = 142.86
         VIRTUAL-HEIGHT     = 25.15
         VIRTUAL-WIDTH      = 142.86
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
/* BROWSE-TAB BROWSE-5 FILL-IN-Mensaje F-Main */
/* BROWSE-TAB BROWSE-7 TOGGLE-Empaque F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.T-MATE,INTEGRAL.Almmmatg OF Temp-Tables.T-MATE,INTEGRAL.Almmmate OF Temp-Tables.T-MATE"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST"
     _FldNameList[1]   = Temp-Tables.T-MATE.CodAlm
     _FldNameList[2]   > Temp-Tables.T-MATE.codmat
"T-MATE.codmat" "Artículo" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-MATE.VCtMn1
"T-MATE.VCtMn1" "CAMPAÑA" "ZZZ,ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-MATE.VCtMn2
"T-MATE.VCtMn2" "NO CAMPAÑA" "ZZZ,ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-MATE.StkMax
"T-MATE.StkMax" "Empaque" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almmmatg.UndStk
"Almmmatg.UndStk" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "44.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no "21.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.T-MATE-2"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-MATE-2.CodAlm
"T-MATE-2.CodAlm" "ALMACEN" ? "character" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-MATE-2.codmat
"T-MATE-2.codmat" "ARTICULO" ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-MATE-2.StkMin
"T-MATE-2.StkMin" "CAMPAÑA" ? "decimal" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-MATE-2.StkMax
"T-MATE-2.StkMax" "NO CAMPAÑA" ? "decimal" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-MATE-2.StkAct
"T-MATE-2.StkAct" "EMPAQUE" "Z,ZZZ,ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no "13.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPORTAR REPOSICION CAMPAÑA Y NO CAMPAÑA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR REPOSICION CAMPAÑA Y NO CAMPAÑA */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* CAPTURAR EXCEL */
DO:

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal.
    SESSION:SET-WAIT-STATE('').
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

    MESSAGE 'Carga Completa' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* ACTUALIZAR BASE DE DATOS */
DO:
    /*ASSIGN TOGGLE-1.*/
    ASSIGN TOGGLE-Campana TOGGLE-Empaque TOGGLE-NoCampana.
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Grabar-Valores.
    SESSION:SET-WAIT-STATE('').
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.
DEFINE VARIABLE x-LineaProceso AS INT NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.


CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
ASSIGN
    t-Column = 0
    t-Row = 0. 

cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
/* VERIFICAMOS LAS CABECERAS */
ASSIGN
    t-Row    = t-Row + 1.
t-column = t-column + 1.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR LOOKUP(cValue, "ALMACEN,ALMACÉN,Almacén") = 0 THEN DO:
    MESSAGE 'A1 Formato del archivo Excel errado' cValue VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
t-column = t-column + 1.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR LOOKUP(cValue, "ARTICULO,ARTÍCULO,Artículo") = 0 THEN DO:
    MESSAGE 'B1 Formato del archivo Excel errado' cValue VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* CARGAMOS EL TEMPORAL */
EMPTY TEMP-TABLE T-MATE.
ASSIGN
    x-LineaProceso = 1
    t-Column = 0
    t-Row = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Procesando registro: " +
        STRING(x-LineaProceso, '>>>,>>9').
    x-LineaProceso = x-LineaProceso + 1.
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    /* CODALM */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    iValue = 0.
    ASSIGN
        iValue = INTEGER(cValue) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        /* Puede que sea un caracter */
    END.
    ELSE DO:
        /* Puede ser un número entero */
        IF iValue < 100 THEN cValue = STRING(iValue, '99').
        ELSE cValue = STRING(iValue, '999').
    END.
    FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = cValue NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN NEXT.
    /* CODMAT */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN 
        cValue = STRING(INTEGER(cValue), '999999') NO-ERROR.
    IF ERROR-STATUS:ERROR THEN NEXT.
    FIND Almmmate WHERE Almmmate.codcia = Almacen.codcia
        AND Almmmate.codalm = Almacen.codalm
        AND Almmmate.codmat = cValue NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN NEXT.
    /* CONSISTENCIA DE DUPLICIDAD */
    FIND T-MATE WHERE T-MATE.codalm = Almacen.codalm
        AND T-MATE.codmat = cValue
        NO-LOCK NO-ERROR.
    IF AVAILABLE T-MATE THEN NEXT.
    CREATE T-MATE.
    BUFFER-COPY Almmmate TO T-MATE NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, NEXT.
    /* CAMPAÑA */
    t-Column = t-Column + 1.
    ASSIGN
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE NO-ERROR.
    ASSIGN
        T-MATE.VCtMn1 = DECIMAL(cValue) NO-ERROR.
    /* NO CAMPAÑA */
    t-Column = t-Column + 1.
    ASSIGN
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE NO-ERROR.
    ASSIGN
        T-MATE.VCtMn2 = DECIMAL(cValue) NO-ERROR.
    /* EMPAQUE */
    t-Column = t-Column + 1.
    ASSIGN
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE NO-ERROR.
    ASSIGN
        T-MATE.StkMax = DECIMAL(cValue) NO-ERROR.
END.
{&OPEN-QUERY-{&BROWSE-NAME}}

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
  DISPLAY FILL-IN-Mensaje TOGGLE-Campana TOGGLE-NoCampana TOGGLE-Empaque 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-26 RECT-27 BUTTON-1 BUTTON-2 BROWSE-5 TOGGLE-Campana 
         TOGGLE-NoCampana TOGGLE-Empaque BROWSE-7 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Valores W-Win 
PROCEDURE Grabar-Valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Procedemos a grabar los valores?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

/* ************************************* */
/* ***** RHC 30/11/2015 NO REPLICA ***** */
DISABLE TRIGGERS FOR LOAD OF Almmmate.
/* ************************************* */
/* ************************************* */

DEF BUFFER B-MATE FOR Almmmate.

FOR EACH T-MATE BREAK BY T-MATE.CodAlm ON ERROR UNDO, NEXT ON STOP UNDO, NEXT:
    FIND Almmmate OF T-MATE EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
        MESSAGE 'Artículo' T-MATE.codmat 'no registrado en el almacén' T-MATE.codalm
            VIEW-AS ALERT-BOX WARNING.
        NEXT.
    END.
    /* 1ro borramos todo */
/*     IF FIRST-OF(T-MATE.CodAlm) THEN DO:                                           */
/*         FOR EACH B-MATE WHERE B-MATE.codcia = T-MATE.codcia                       */
/*             AND B-MATE.codalm = T-MATE.codalm                                     */
/*             AND (B-MATE.VCtMn1 <> 0 OR B-MATE.VCtMn2 <> 0 OR B-MATE.StkMax <> 0): */
/*             IF TOGGLE-Campana   = YES THEN B-MATE.VCtMn1 = 0.                     */
/*             IF TOGGLE-NoCampana = YES THEN B-MATE.VCtMn2 = 0.                     */
/*             IF TOGGLE-Empaque   = YES THEN B-MATE.StkMax = 0.                     */
/*         END.                                                                      */
/*     END.                                                                          */
    /* 2do actualizamos */
    IF TOGGLE-Campana   = YES THEN Almmmate.VCtMn1 = T-MATE.VCtMn1.
    IF TOGGLE-NoCampana = YES THEN Almmmate.VCtMn2 = T-MATE.VCtMn2.
    IF TOGGLE-Empaque   = YES THEN Almmmate.StkMax = T-MATE.StkMax.
    ASSIGN
        Almmmate.Libre_c05 = s-user-id
        Almmmate.Libre_f02 = TODAY.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmate.codalm + " " + Almmmate.codmat.
    /* LOG DE CONTROL */
    CREATE Logmmate.  
    BUFFER-COPY
        Almmmate TO Logmmate
        ASSIGN
        logmmate.LogTexto = s-user-id
        logmmate.LogDate = DATETIME(TODAY, MTIME)
        logmmate.LogFlag = "P"
        logmmate.LogEvento = "STOCKMINIMO".
END.
EMPTY TEMP-TABLE T-MATE.
RELEASE Logmmate.

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
  {src/adm/template/snd-list.i "T-MATE-2"}
  {src/adm/template/snd-list.i "T-MATE"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "Almmmate"}

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

