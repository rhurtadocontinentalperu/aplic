&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tw-report NO-UNDO LIKE w-report.



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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN RETURN.

DEF TEMP-TABLE Detalle
    FIELD FchMov AS DATE FORMAT '99/99/9999' LABEL 'Fecha'
    FIELD CodAlm AS CHAR FORMAT 'x(8)' LABEL 'Almacen'
    FIELD DesAlm AS CHAR FORMAT 'x(50)' LABEL 'Descripcion'
    FIELD NroSer AS INTE FORMAT '999' LABEL 'Serie'
    FIELD NroDoc AS INTE FORMAT '999999999' LABEL 'Correlativo'
    FIELD CodCli AS CHAR FORMAT 'x(15)' LABEL 'Cliente'
    FIELD NomCli AS CHAR FORMAT 'x(80)' LABEL 'Nombre'
    FIELD EstadoPI AS CHAR FORMAT 'x(15)' LABEL 'Estado PI'
    FIELD ImportePI AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'Importe PI'
    FIELD FchDoc AS DATE FORMAT '99/99/9999' LABEL 'Fecha NC'
    FIELD NroSerNC AS INTE FORMAT '999' LABEL 'Serie NC'
    FIELD NroDocNC AS INTE FORMAT '999999999' LABEL 'Correlativo NC'
    FIELD CodMon AS CHAR FORMAT 'x(8)' LABEL 'Moneda NC'
    FIELD ImpTot AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'Importe NC'
    FIELD EstadoNC AS CHAR FORMAT 'x(15)' LABEL 'Estado NC'
    FIELD Observ AS CHAR FORMAT 'x(60)' LABEL 'Observaciones'
    FIELD Motivo AS CHAR FORMAT 'x(60)' LABEL 'Motivo'
    FIELD Usuario AS CHAR FORMAT 'x(15)' LABEL 'Usuario'
    .

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
&Scoped-define INTERNAL-TABLES tw-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tw-report.Campo-D[1] ~
tw-report.Campo-C[1] tw-report.Campo-C[2] tw-report.Campo-I[1] ~
tw-report.Campo-I[2] tw-report.Campo-C[3] tw-report.Campo-C[4] ~
tw-report.Campo-C[5] tw-report.Campo-F[1] tw-report.Campo-D[2] ~
tw-report.Campo-C[6] tw-report.Campo-C[7] tw-report.Campo-C[8] ~
tw-report.Campo-C[9] tw-report.Campo-F[2] tw-report.Campo-C[10] ~
tw-report.Campo-C[11] tw-report.Campo-C[12] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tw-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tw-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tw-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tw-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-66 RECT-67 RECT-68 RECT-69 BUTTON-3 ~
SELECT_CodMov FILL-IN_FchDoc-1 BUTTON-1 FILL-IN_FchDoc-2 BUTTON-Texto ~
BUTTON-2 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS EDITOR_Divisiones SELECT_CodMov ~
FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 EDITOR_Almacenes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "PROCESAR" 
     SIZE 20 BY 1.38
     FONT 9.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 2" 
     SIZE 5 BY 1.08.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 3" 
     SIZE 5 BY 1.08.

DEFINE BUTTON BUTTON-Texto 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 3" 
     SIZE 8 BY 1.62 TOOLTIP "Exportar a texto".

DEFINE VARIABLE EDITOR_Almacenes AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 44 BY 1.62 NO-UNDO.

DEFINE VARIABLE EDITOR_Divisiones AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 44 BY 2.15 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52 BY 3.23.

DEFINE RECTANGLE RECT-67
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46 BY 5.38.

DEFINE RECTANGLE RECT-68
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30 BY 5.38.

DEFINE RECTANGLE RECT-69
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52 BY 2.15.

DEFINE VARIABLE SELECT_CodMov AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     LIST-ITEM-PAIRS "uno","1" 
     SIZE 40 BY 2.69 TOOLTIP "Permite multiple selección" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tw-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tw-report.Campo-D[1] COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
      tw-report.Campo-C[1] COLUMN-LABEL "Almacen" FORMAT "X(8)":U
      tw-report.Campo-C[2] COLUMN-LABEL "Descripción" FORMAT "X(40)":U
      tw-report.Campo-I[1] COLUMN-LABEL "Serie" FORMAT "999":U
      tw-report.Campo-I[2] COLUMN-LABEL "Correlativo" FORMAT "999999999":U
      tw-report.Campo-C[3] COLUMN-LABEL "Cliente" FORMAT "X(15)":U
      tw-report.Campo-C[4] COLUMN-LABEL "Nombre" FORMAT "X(60)":U
      tw-report.Campo-C[5] COLUMN-LABEL "Estado del PI" FORMAT "X(15)":U
      tw-report.Campo-F[1] COLUMN-LABEL "Importe PI" FORMAT "->>>,>>>,>>9.99":U
      tw-report.Campo-D[2] COLUMN-LABEL "Fecha NC" FORMAT "99/99/9999":U
      tw-report.Campo-C[6] COLUMN-LABEL "Serie NC" FORMAT "X(3)":U
      tw-report.Campo-C[7] COLUMN-LABEL "Correlativo NC" FORMAT "X(15)":U
      tw-report.Campo-C[8] COLUMN-LABEL "Moneda NC" FORMAT "X(10)":U
      tw-report.Campo-C[9] COLUMN-LABEL "Estado NC" FORMAT "X(15)":U
      tw-report.Campo-F[2] COLUMN-LABEL "Importe NC" FORMAT "->>>,>>>,>>9.99":U
      tw-report.Campo-C[10] COLUMN-LABEL "Observacion" FORMAT "X(40)":U
      tw-report.Campo-C[11] COLUMN-LABEL "Motivo" FORMAT "X(40)":U
      tw-report.Campo-C[12] COLUMN-LABEL "Usuario" FORMAT "X(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 187 BY 18.58
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-3 AT ROW 1.81 COL 4 WIDGET-ID 38
     EDITOR_Divisiones AT ROW 2.08 COL 10 NO-LABEL WIDGET-ID 36
     SELECT_CodMov AT ROW 2.08 COL 57 NO-LABEL WIDGET-ID 4
     FILL-IN_FchDoc-1 AT ROW 2.08 COL 107 COLON-ALIGNED WIDGET-ID 8
     BUTTON-1 AT ROW 2.08 COL 161 WIDGET-ID 14
     FILL-IN_FchDoc-2 AT ROW 3.15 COL 107 COLON-ALIGNED WIDGET-ID 10
     BUTTON-Texto AT ROW 3.69 COL 167 WIDGET-ID 26
     BUTTON-2 AT ROW 5.04 COL 4 WIDGET-ID 28
     EDITOR_Almacenes AT ROW 5.04 COL 10 NO-LABEL WIDGET-ID 32
     BROWSE-2 AT ROW 7.19 COL 3 WIDGET-ID 200
     "Selecione uno o más movimientos:" VIEW-AS TEXT
          SIZE 24 BY .5 AT ROW 1.27 COL 57 WIDGET-ID 6
          BGCOLOR 9 FGCOLOR 15 
     "Selecione uno o varios almacenes:" VIEW-AS TEXT
          SIZE 24 BY .5 AT ROW 4.5 COL 4 WIDGET-ID 30
          BGCOLOR 9 FGCOLOR 15 
     "Selecione el rango de fechas:" VIEW-AS TEXT
          SIZE 21 BY .5 AT ROW 1.27 COL 103 WIDGET-ID 12
          BGCOLOR 9 FGCOLOR 15 
     "Selecione una o más divisiones:" VIEW-AS TEXT
          SIZE 24 BY .5 AT ROW 1.27 COL 4 WIDGET-ID 18
          BGCOLOR 9 FGCOLOR 15 
     RECT-66 AT ROW 1.54 COL 3 WIDGET-ID 20
     RECT-67 AT ROW 1.54 COL 55 WIDGET-ID 22
     RECT-68 AT ROW 1.54 COL 101 WIDGET-ID 24
     RECT-69 AT ROW 4.77 COL 3 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 190.29 BY 26.15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tw-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DETALLADO PARTES DE INGRESO"
         HEIGHT             = 26.15
         WIDTH              = 190.29
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 195.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 195.29
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
/* BROWSE-TAB BROWSE-2 EDITOR_Almacenes F-Main */
ASSIGN 
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 5.

/* SETTINGS FOR EDITOR EDITOR_Almacenes IN FRAME F-Main
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
     _TblList          = "Temp-Tables.tw-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tw-report.Campo-D[1]
"tw-report.Campo-D[1]" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tw-report.Campo-C[1]
"tw-report.Campo-C[1]" "Almacen" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tw-report.Campo-C[2]
"tw-report.Campo-C[2]" "Descripción" "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tw-report.Campo-I[1]
"tw-report.Campo-I[1]" "Serie" "999" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tw-report.Campo-I[2]
"tw-report.Campo-I[2]" "Correlativo" "999999999" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tw-report.Campo-C[3]
"tw-report.Campo-C[3]" "Cliente" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tw-report.Campo-C[4]
"tw-report.Campo-C[4]" "Nombre" "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tw-report.Campo-C[5]
"tw-report.Campo-C[5]" "Estado del PI" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tw-report.Campo-F[1]
"tw-report.Campo-F[1]" "Importe PI" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tw-report.Campo-D[2]
"tw-report.Campo-D[2]" "Fecha NC" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tw-report.Campo-C[6]
"tw-report.Campo-C[6]" "Serie NC" "X(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tw-report.Campo-C[7]
"tw-report.Campo-C[7]" "Correlativo NC" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tw-report.Campo-C[8]
"tw-report.Campo-C[8]" "Moneda NC" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tw-report.Campo-C[9]
"tw-report.Campo-C[9]" "Estado NC" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.tw-report.Campo-F[2]
"tw-report.Campo-F[2]" "Importe NC" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.tw-report.Campo-C[10]
"tw-report.Campo-C[10]" "Observacion" "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.tw-report.Campo-C[11]
"tw-report.Campo-C[11]" "Motivo" "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.tw-report.Campo-C[12]
"tw-report.Campo-C[12]" "Usuario" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DETALLADO PARTES DE INGRESO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DETALLADO PARTES DE INGRESO */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* PROCESAR */
DO:
  ASSIGN FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 SELECT_CodMov EDITOR_Divisiones.
  ASSIGN EDITOR_Almacenes.
  IF TRUE <> (SELECT_CodMov > '') THEN DO:
      MESSAGE 'Seleccione al menos un movimiento' VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO SELECT_CodMov.
      RETURN NO-APPLY.
  END.
  IF FILL-IN_FchDoc-1 = ? OR FILL-IN_FchDoc-2 = ? THEN DO:
      MESSAGE 'Ingrese correctamente el rango de fechas' VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO FILL-IN_FchDoc-1.
      RETURN NO-APPLY.
  END.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  DEF VAR pAlmacenes AS CHAR NO-UNDO.
  RUN alm/d-almacenes-por-div.w (INPUT EDITOR_Divisiones:SCREEN-VALUE,
                                 OUTPUT pAlmacenes).
  IF pAlmacenes > '' THEN EDITOR_Almacenes:SCREEN-VALUE = pAlmacenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  DEF VAR pDivisiones AS CHAR NO-UNDO.
  pDivisiones = EDITOR_Divisiones:SCREEN-VALUE.
  RUN gn/d-filtro-divisiones.w (INPUT-OUTPUT pDivisiones, INPUT "").
  EDITOR_Divisiones:SCREEN-VALUE = pDivisiones.
  EDITOR_Almacenes:SCREEN-VALUE = ''.
  FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia 
      AND LOOKUP(almacen.coddiv, pDivisiones) > 0
      AND almacen.campo-c[9] <> "I":
      EDITOR_Almacenes:SCREEN-VALUE = EDITOR_Almacenes:SCREEN-VALUE + 
          (IF TRUE <> (EDITOR_Almacenes:SCREEN-VALUE > '') THEN '' ELSE ',') +
          almacen.codalm.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Texto W-Win
ON CHOOSE OF BUTTON-Texto IN FRAME F-Main /* Button 3 */
DO:
  RUN Texto.
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

DEF VAR iCodMov AS INTE NO-UNDO.
DEF VAR iItem AS INTE NO-UNDO.
DEF VAR cEstado AS CHAR NO-UNDO.

EMPTY TEMP-TABLE tw-report.

DO iItem = 1 TO NUM-ENTRIES(SELECT_CodMov,":"):
    FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia 
            AND LOOKUP(almacen.coddiv, EDITOR_Divisiones) > 0
            AND LOOKUP(almacen.codalm, EDITOR_Almacenes) > 0,
        EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia 
            AND almcmov.codalm = almacen.codalm 
            AND almcmov.tipmov = "I"
            AND almcmov.codmov = INTEGER(ENTRY(iItem,SELECT_CodMov,":"))
            AND almcmov.fchdoc >= FILL-IN_FchDoc-1
            AND almcmov.fchdoc <= FILL-IN_FchDoc-2:
        CREATE tw-report.
        tw-report.Campo-D[1] = almcmov.fchdoc.
        tw-report.Campo-C[1] = almcmov.codalm.
        tw-report.Campo-C[2] = Almacen.Descripcion.
        tw-report.Campo-I[1] = almcmov.nroser.
        tw-report.Campo-I[2] = almcmov.nrodoc.
        tw-report.Campo-C[3] = almcmov.codcli.
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = almcmov.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN tw-report.Campo-C[4] = gn-clie.nomcli.
        tw-report.Campo-C[5] = "EMITIDA".
        CASE almcmov.flgest:
            WHEN 'A' THEN tw-report.Campo-C[5] = 'ANULADA'.
            WHEN 'P' THEN tw-report.Campo-C[5] = 'PENDIENTE'.
            WHEN 'C' THEN tw-report.Campo-C[5] = 'CERRADA'.
        END CASE.
        /* Importe de PI */
        FOR EACH almdmov OF almcmov NO-LOCK:
            tw-report.Campo-F[1] = tw-report.Campo-F[1] + almdmov.implin.
        END.
        /* Buscamos la N/C */
        FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia
            AND ccbcdocu.coddoc = "N/C"
            AND ccbcdocu.codref = almcmov.codref
            AND ccbcdocu.nroref = almcmov.nroref
            AND ccbcdocu.nroped = STRING(almcmov.nrodoc)
            AND ccbcdocu.codalm = almcmov.codalm
            AND ccbcdocu.flgest <> "A"
            NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN DO:
            ASSIGN 
                tw-report.Campo-D[2] = ccbcdocu.fchdoc
                tw-report.Campo-C[6] = SUBSTRING(ccbcdocu.nrodoc,1,3)
                tw-report.Campo-C[7] = SUBSTRING(ccbcdocu.nrodoc,4).
            ASSIGN
                tw-report.Campo-C[8] = (IF ccbcdocu.codmon = 1 THEN "SOLES" ELSE "DOLARES")
                tw-report.Campo-F[2] = ccbcdocu.imptot.
            RUN gn/fFlgEstCCB (Ccbcdocu.flgest, OUTPUT cEstado).
            tw-report.Campo-C[9] = cEstado.
        END.
        tw-report.Campo-C[10] = almcmov.observ.
        /* Motivo */
        FIND FacTabla WHERE FacTabla.CodCia = Almcmov.codcia
            AND FacTabla.Tabla = 'REPOMOTIVO'
            AND FacTabla.Codigo = Almcmov.Libre_c05
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN tw-report.Campo-C[11] = FacTabla.Nombre.
        tw-report.Campo-C[12] = Almcmov.usuario.
    END.
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
  DISPLAY EDITOR_Divisiones SELECT_CodMov FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 
          EDITOR_Almacenes 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-66 RECT-67 RECT-68 RECT-69 BUTTON-3 SELECT_CodMov 
         FILL-IN_FchDoc-1 BUTTON-1 FILL-IN_FchDoc-2 BUTTON-Texto BUTTON-2 
         BROWSE-2 
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
  DO WITH FRAME {&FRAME-NAME}:
      EDITOR_Divisiones = s-coddiv.

      SELECT_CodMov:DELETE(1).
      SELECT_CodMov:DELIMITER = ":".
      FOR EACH almtmovm NO-LOCK WHERE almtmovm.codcia = s-codcia 
          AND almtmovm.tipmov = 'I' 
          AND almtmovm.pidcli = YES:
          SELECT_CodMov:ADD-LAST( STRING(Almtmovm.Codmov,'99') + " - " +  Almtmovm.desmov , STRING(Almtmovm.Codmov,'99')).
      END.
      FILL-IN_FchDoc-2 = TODAY.
      FILL-IN_FchDoc-1 = ADD-INTERVAL(TODAY, -1 , 'month').

      EDITOR_Almacenes = "".
      FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia 
          AND almacen.coddiv = s-coddiv
          AND almacen.campo-c[9] <> "I":
          EDITOR_Almacenes = EDITOR_Almacenes + 
              (IF TRUE <> (EDITOR_Almacenes > '') THEN '' ELSE ',') +
              almacen.codalm.
      END.
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
  {src/adm/template/snd-list.i "tw-report"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    /* Cargamos la informacion al temporal */
    SESSION:SET-WAIT-STATE('GENERAL').

    EMPTY TEMP-TABLE Detalle.
    FOR EACH tw-report NO-LOCK:
        CREATE Detalle.
        ASSIGN
            Detalle.fchmov = tw-report.Campo-D[1]
            Detalle.codalm = tw-report.Campo-C[1]
            Detalle.desalm = tw-report.Campo-C[2]
            Detalle.nroser = tw-report.Campo-I[1]
            Detalle.nrodoc = tw-report.Campo-I[2]
            Detalle.codcli = tw-report.Campo-C[3]
            Detalle.nomcli = tw-report.Campo-C[4]
            Detalle.estadopi = tw-report.Campo-C[5]
            Detalle.importePI = tw-report.Campo-F[1]
            Detalle.fchdoc = tw-report.Campo-D[2]
            Detalle.nrosernc = INTEGER(tw-report.Campo-C[6])
            Detalle.nrodocnc = INTEGER(tw-report.Campo-C[7])
            Detalle.codmon = tw-report.Campo-C[8]
            Detalle.imptot = tw-report.Campo-F[2]
            Detalle.estadonc = tw-report.Campo-C[9]
            Detalle.observ = tw-report.Campo-C[10]
            Detalle.motivo = tw-report.Campo-C[11]
            Detalle.usuario = tw-report.Campo-C[12]
            .

    END.
    /* Programas que generan el Excel */
    cArchivo = LC(pArchivo).
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    SESSION:SET-WAIT-STATE('').
    MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

