&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE PTOSDESPACHO NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE TORDENES NO-UNDO LIKE w-report.



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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE VAR x-coddoc AS CHAR INIT "PIR".

DEFINE BUFFER x-gn-divi FOR gn-divi.

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
&Scoped-define INTERNAL-TABLES TORDENES PTOSDESPACHO

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 TORDENES.Campo-C[1] ~
TORDENES.Campo-C[2] TORDENES.Campo-D[1] TORDENES.Campo-D[2] ~
TORDENES.Campo-C[10] TORDENES.Campo-C[5] TORDENES.Campo-C[9] ~
TORDENES.Campo-C[4] TORDENES.Campo-C[7] TORDENES.Campo-C[8] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH TORDENES ~
      WHERE TORDENES.campo-c[30] = "" NO-LOCK ~
    BY TORDENES.Campo-C[5] ~
       BY TORDENES.Campo-C[10] ~
        BY TORDENES.Campo-C[1] ~
         BY TORDENES.Campo-C[2]
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH TORDENES ~
      WHERE TORDENES.campo-c[30] = "" NO-LOCK ~
    BY TORDENES.Campo-C[5] ~
       BY TORDENES.Campo-C[10] ~
        BY TORDENES.Campo-C[1] ~
         BY TORDENES.Campo-C[2].
&Scoped-define TABLES-IN-QUERY-BROWSE-2 TORDENES
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 TORDENES


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 TORDENES.Campo-C[1] ~
TORDENES.Campo-C[2] TORDENES.Campo-D[1] TORDENES.Campo-D[2] ~
TORDENES.Campo-C[10] TORDENES.Campo-C[5] TORDENES.Campo-C[9] ~
TORDENES.Campo-C[4] TORDENES.Campo-C[7] TORDENES.Campo-C[8] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH TORDENES ~
      WHERE TORDENES.campo-c[30] = "X" NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH TORDENES ~
      WHERE TORDENES.campo-c[30] = "X" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 TORDENES
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 TORDENES


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 PTOSDESPACHO.Campo-L[1] ~
PTOSDESPACHO.Llave-C PTOSDESPACHO.Campo-C[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 PTOSDESPACHO.Campo-L[1] 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-5 PTOSDESPACHO
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-5 PTOSDESPACHO
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH PTOSDESPACHO NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH PTOSDESPACHO NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 PTOSDESPACHO
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 PTOSDESPACHO


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-dias BUTTON-1 BROWSE-5 BROWSE-2 ~
BROWSE-3 BUTTON-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-dias FILL-IN-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Refrescar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL ">>>" 
     SIZE 10 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "<<<" 
     SIZE 10 BY 1.12.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(100)":U INITIAL "ORDENES CONSIDERADOS PARA GENERAR - PIR" 
      VIEW-AS TEXT 
     SIZE 44 BY .62
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-dias AS INTEGER FORMAT ">>9":U INITIAL 5 
     LABEL "Indique dias atras" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      TORDENES SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      TORDENES SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      PTOSDESPACHO SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      TORDENES.Campo-C[1] COLUMN-LABEL "Cod!Doc" FORMAT "X(5)":U
      TORDENES.Campo-C[2] COLUMN-LABEL "Nro!Doc" FORMAT "X(10)":U
            WIDTH 9.29
      TORDENES.Campo-D[1] COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      TORDENES.Campo-D[2] COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
            WIDTH 8.57
      TORDENES.Campo-C[10] COLUMN-LABEL "Distrito de entrega" FORMAT "X(40)":U
            WIDTH 24.43
      TORDENES.Campo-C[5] COLUMN-LABEL "Division!Despacho" FORMAT "X(50)":U
            WIDTH 25.72
      TORDENES.Campo-C[9] COLUMN-LABEL "Direccion del Cliente" FORMAT "X(80)":U
            WIDTH 34.14
      TORDENES.Campo-C[4] COLUMN-LABEL "Division!Venta" FORMAT "X(50)":U
            WIDTH 21.14
      TORDENES.Campo-C[7] COLUMN-LABEL "Cod.Cli" FORMAT "X(13)":U
            WIDTH 10.43
      TORDENES.Campo-C[8] COLUMN-LABEL "Nombre del Cliente" FORMAT "X(80)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 85 BY 17.23
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      TORDENES.Campo-C[1] COLUMN-LABEL "Cod!Doc" FORMAT "X(5)":U
      TORDENES.Campo-C[2] COLUMN-LABEL "Nro!Doc" FORMAT "X(10)":U
            WIDTH 9.29
      TORDENES.Campo-D[1] COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      TORDENES.Campo-D[2] COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
            WIDTH 8.57
      TORDENES.Campo-C[10] COLUMN-LABEL "Distrito de entrega" FORMAT "X(40)":U
            WIDTH 24.43
      TORDENES.Campo-C[5] COLUMN-LABEL "Division!Despacho" FORMAT "X(50)":U
            WIDTH 25.72
      TORDENES.Campo-C[9] COLUMN-LABEL "Direccion del Cliente" FORMAT "X(80)":U
            WIDTH 34.14
      TORDENES.Campo-C[4] COLUMN-LABEL "Division!Venta" FORMAT "X(50)":U
            WIDTH 21.14
      TORDENES.Campo-C[7] COLUMN-LABEL "Cod.Cli" FORMAT "X(13)":U
            WIDTH 10.43
      TORDENES.Campo-C[8] COLUMN-LABEL "Nombre del Cliente" FORMAT "X(80)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 84.29 BY 13.69
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      PTOSDESPACHO.Campo-L[1] COLUMN-LABEL "" FORMAT "Si/No":U
            WIDTH 4.43 VIEW-AS TOGGLE-BOX
      PTOSDESPACHO.Llave-C COLUMN-LABEL "Cod.Divi" FORMAT "x(8)":U
      PTOSDESPACHO.Campo-C[1] COLUMN-LABEL "Division Despacho" FORMAT "X(60)":U
            WIDTH 23.14
  ENABLE
      PTOSDESPACHO.Campo-L[1]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 40 BY 4.5
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-dias AT ROW 1.12 COL 15.86 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 1.12 COL 40 WIDGET-ID 4
     BROWSE-5 AT ROW 1.19 COL 90 WIDGET-ID 400
     BROWSE-2 AT ROW 3.12 COL 2 WIDGET-ID 200
     BROWSE-3 AT ROW 6.73 COL 99.43 WIDGET-ID 300
     BUTTON-2 AT ROW 8.31 COL 88 WIDGET-ID 6
     BUTTON-3 AT ROW 9.81 COL 88 WIDGET-ID 8
     FILL-IN-3 AT ROW 6.08 COL 97.86 COLON-ALIGNED NO-LABEL WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 183.72 BY 19.73
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Temp-Tables and Buffers:
      TABLE: PTOSDESPACHO T "?" NO-UNDO INTEGRAL w-report
      TABLE: TORDENES T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Planificador de Rutas"
         HEIGHT             = 19.73
         WIDTH              = 183.72
         MAX-HEIGHT         = 19.73
         MAX-WIDTH          = 194.29
         VIRTUAL-HEIGHT     = 19.73
         VIRTUAL-WIDTH      = 194.29
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
/* BROWSE-TAB BROWSE-5 BUTTON-1 F-Main */
/* BROWSE-TAB BROWSE-2 BROWSE-5 F-Main */
/* BROWSE-TAB BROWSE-3 BROWSE-2 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.TORDENES"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.TORDENES.Campo-C[5]|yes,Temp-Tables.TORDENES.Campo-C[10]|yes,Temp-Tables.TORDENES.Campo-C[1]|yes,Temp-Tables.TORDENES.Campo-C[2]|yes"
     _Where[1]         = "TORDENES.campo-c[30] = """""
     _FldNameList[1]   > Temp-Tables.TORDENES.Campo-C[1]
"TORDENES.Campo-C[1]" "Cod!Doc" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.TORDENES.Campo-C[2]
"TORDENES.Campo-C[2]" "Nro!Doc" "X(10)" "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.TORDENES.Campo-D[1]
"TORDENES.Campo-D[1]" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.TORDENES.Campo-D[2]
"TORDENES.Campo-D[2]" "Entrega" ? "date" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.TORDENES.Campo-C[10]
"TORDENES.Campo-C[10]" "Distrito de entrega" "X(40)" "character" ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.TORDENES.Campo-C[5]
"TORDENES.Campo-C[5]" "Division!Despacho" "X(50)" "character" ? ? ? ? ? ? no ? no no "25.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.TORDENES.Campo-C[9]
"TORDENES.Campo-C[9]" "Direccion del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "34.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.TORDENES.Campo-C[4]
"TORDENES.Campo-C[4]" "Division!Venta" "X(50)" "character" ? ? ? ? ? ? no ? no no "21.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.TORDENES.Campo-C[7]
"TORDENES.Campo-C[7]" "Cod.Cli" "X(13)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.TORDENES.Campo-C[8]
"TORDENES.Campo-C[8]" "Nombre del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.TORDENES"
     _Options          = "NO-LOCK"
     _Where[1]         = "TORDENES.campo-c[30] = ""X"""
     _FldNameList[1]   > Temp-Tables.TORDENES.Campo-C[1]
"TORDENES.Campo-C[1]" "Cod!Doc" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.TORDENES.Campo-C[2]
"TORDENES.Campo-C[2]" "Nro!Doc" "X(10)" "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.TORDENES.Campo-D[1]
"TORDENES.Campo-D[1]" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.TORDENES.Campo-D[2]
"TORDENES.Campo-D[2]" "Entrega" ? "date" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.TORDENES.Campo-C[10]
"TORDENES.Campo-C[10]" "Distrito de entrega" "X(40)" "character" ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.TORDENES.Campo-C[5]
"TORDENES.Campo-C[5]" "Division!Despacho" "X(50)" "character" ? ? ? ? ? ? no ? no no "25.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.TORDENES.Campo-C[9]
"TORDENES.Campo-C[9]" "Direccion del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "34.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.TORDENES.Campo-C[4]
"TORDENES.Campo-C[4]" "Division!Venta" "X(50)" "character" ? ? ? ? ? ? no ? no no "21.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.TORDENES.Campo-C[7]
"TORDENES.Campo-C[7]" "Cod.Cli" "X(13)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.TORDENES.Campo-C[8]
"TORDENES.Campo-C[8]" "Nombre del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.PTOSDESPACHO"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.PTOSDESPACHO.Campo-L[1]
"Campo-L[1]" "" ? "logical" ? ? ? ? ? ? yes ? no no "4.43" yes no no "U" "" "" "TOGGLE-BOX" "?" ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.PTOSDESPACHO.Llave-C
"Llave-C" "Cod.Divi" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.PTOSDESPACHO.Campo-C[1]
"Campo-C[1]" "Division Despacho" "X(60)" "character" ? ? ? ? ? ? no ? no no "23.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Planificador de Rutas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Planificador de Rutas */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Refrescar */
DO:
  ASSIGN fill-in-dias.

  IF fill-in-dias > 15 THEN DO:
      MESSAGE "Como maximo 15 dias".
      RETURN NO-APPLY.
  END.

  RUN carga-temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* >>> */
DO:
  RUN mover-registros(INPUT ">>>").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* <<< */
DO:
  RUN mover-registros(INPUT "<<<").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON mouse-select-down OF BROWSE {&BROWSE-NAME} ANYWHERE DO:
    DEFINE VARIABLE hColumn AS HANDLE NO-UNDO.

    ASSIGN
    hColumn = SELF:HANDLE.
    IF VALID-HANDLE(hColumn) AND hColumn:TYPE = "FILL-IN" THEN DO:
        hColumn:MOVABLE = TRUE.
        MESSAGE hColumn:LABEL.
    END.

END.

ON ENTRY OF BROWSE {&BROWSE-NAME} ANYWHERE DO:

    DEFINE VARIABLE hColumn AS HANDLE NO-UNDO.
    DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.

    ASSIGN
    hColumn = SELF:HANDLE.
    IF VALID-HANDLE(hColumn) AND hColumn:TYPE = "FILL-IN" THEN DO:
        hColumn:MOVABLE = TRUE.
        
    END.


    /*
    ASSIGN
        hColumn = SELF:HANDLE
        iCounter = 1.
    IF VALID-HANDLE(hColumn) AND hColumn:TYPE = "FILL-IN" THEN
        DO WHILE hColumn <> {&BROWSE-NAME}:FIRST-COLUMN :
            ASSIGN
                iCounter = iCounter + 1
                hColumn = hColumn:PREV-COLUMN.
        END.
        MESSAGE "Current column is column number: " iCounter of " {&BROWSE-NAME}:NUM-COLUMNS 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        */
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal W-Win 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE TORDENES.
EMPTY TEMP-TABLE PTOSDESPACHO.

DEFINE VAR x-ordenes AS CHAR INIT "O/D,OTR".
DEFINE VAR x-orden AS CHAR .
DEFINE VAR x-conteo AS INT.

DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pLongitud AS DEC NO-UNDO.
DEF VAR pLatitud AS DEC NO-UNDO.
DEF VAR pCuadrante AS CHAR NO-UNDO.
DEFINE VAR x-fecha-desde AS DATE.

SESSION:SET-WAIT-STATE("GENERAL").

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-dias.
END.

DEFINE VAR x1 AS DATETIME.
DEFINE VAR x2 AS DATETIME.

x1 = NOW.

x-fecha-desde = TODAY - fill-in-dias.

FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia AND
                        gn-divi.campo-log[1] = NO AND           /* Que NO este INACTIVO */
                        gn-divi.campo-log[5] = YES NO-LOCK:     /* Que sea CD */

    REPEAT x-conteo = 1 TO NUM-ENTRIES(x-ordenes,","):

        x-orden = ENTRY(x-conteo,x-ordenes,",").

        /* Las O/D y OTR */
        /*REPEAT PRESELECT EACH faccpedi WHERE faccpedi.codcia = s-codcia AND*/
        FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND
                                faccpedi.divdes = gn-divi.coddiv AND
                                faccpedi.coddoc = x-orden AND    
                                /*CAN-DO(x-ordenes,faccpedi.coddoc) AND*/
                                faccpedi.flgest <> 'A' AND 
                                faccpedi.fchped >= x-fecha-desde AND 
                                faccpedi.cliente_recoge = NO NO-LOCK:

                /*find next faccpedi.*/

                FIND FIRST di-rutaD WHERE di-rutaD.codcia = s-codcia AND
                                        di-rutaD.coddoc = x-coddoc AND
                                        di-rutaD.codref = faccpedi.coddoc AND
                                        di-rutaD.nroref = faccpedi.nroped NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaD THEN DO:
                    FIND FIRST di-rutaC OF di-rutaD NO-LOCK WHERE di-rutaC.flgest <> 'A' NO-ERROR.

                    IF AVAILABLE di-rutaC THEN DO:
                        NEXT.
                    END.
                END.
                    

            CREATE TORDENES.
                ASSIGN  TORDENES.campo-c[1] = faccpedi.coddoc
                        TORDENES.campo-c[2] = faccpedi.nroped
                        TORDENES.campo-d[1] = faccpedi.fchped
                        TORDENES.campo-d[2] = faccpedi.fchent
                        TORDENES.campo-c[9] = faccpedi.dircli
                        TORDENES.campo-c[7] = faccpedi.codcli
                        TORDENES.campo-c[8] = faccpedi.nomcli
                        TORDENES.campo-c[5] = ""
                        TORDENES.campo-c[6] = faccpedi.divdes
                        TORDENES.campo-c[3] = faccpedi.coddiv
                        TORDENES.campo-c[4] = ""
                        TORDENES.campo-c[10] = ""
                        TORDENES.campo-c[30] = ""
                    .
                FIND FIRST x-gn-divi WHERE x-gn-divi.codcia = s-codcia AND
                                            x-gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
                IF AVAILABLE x-gn-divi THEN DO:
                    ASSIGN TORDENES.campo-c[4] = x-gn-divi.desdiv.

                END.
                    

                FIND FIRST x-gn-divi WHERE x-gn-divi.codcia = s-codcia AND
                                            x-gn-divi.coddiv = faccpedi.divdes NO-LOCK NO-ERROR.
                
                IF AVAILABLE x-gn-divi THEN DO:
                    ASSIGN TORDENES.campo-c[5] = x-gn-divi.desdiv.

                    FIND FIRST PTOSDESPACHO WHERE PTOSDESPACHO.task-no = 99 AND
                                                    PTOSDESPACHO.llave-c = faccpedi.divdes EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE PTOSDESPACHO THEN DO:
                        CREATE PTOSDESPACHO.
                            ASSIGN PTOSDESPACHO.task-no = 99
                                    PTOSDESPACHO.llave-c = faccpedi.divdes
                                    PTOSDESPACHO.campo-c[1] = x-gn-divi.desdiv
                                    PTOSDESPACHO.campo-l[1] = YES.

                    END.
                END.


          RUN logis/p-datos-sede-auxiliar (
              FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
              FacCPedi.Ubigeo[3],   /* Auxiliar */
              FacCPedi.Ubigeo[1],   /* Sede */
              OUTPUT pUbigeo,
              OUTPUT pLongitud,
              OUTPUT pLatitud
              ).
          FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2)
              AND TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2)
              AND TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2)
              NO-LOCK NO-ERROR.
            IF AVAILABLE TabDistr THEN DO:
                ASSIGN TORDENES.campo-c[10] = TabDistr.NomDistr.
            END.
        
        END.   
    END.
END.

{&open-query-browse-2}
{&open-query-browse-5}

SESSION:SET-WAIT-STATE("").

x2 = NOW.

MESSAGE x1 SKIP
        x2.

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
  DISPLAY FILL-IN-dias FILL-IN-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-dias BUTTON-1 BROWSE-5 BROWSE-2 BROWSE-3 BUTTON-2 BUTTON-3 
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
  RUN carga-temporal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mover-registros W-Win 
PROCEDURE mover-registros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pDireccion AS CHAR NO-UNDO.

DEFINE VAR x-origen AS HANDLE.
DEFINE VAR x-destino AS HANDLE.
DEFINE VAR x-tot AS INT.
DEFINE VAR x-sec AS INT.
DEFINE VAR x-value AS CHAR INIT "".

DO WITH FRAME {&FRAME-NAME}:
    IF pDireccion = ">>>" THEN DO:
        x-origen = browse-2:HANDLE.
        x-destino = browse-3:HANDLE.
        x-value = "X".
    END.
    ELSE DO:
        x-origen = browse-3:HANDLE.
        x-destino = browse-2:HANDLE.
    END.    
    x-tot = x-origen:NUM-SELECTED-ROWS.

    DO x-sec = 1 TO x-tot :
        IF x-origen:FETCH-SELECTED-ROW(x-sec) THEN DO:
            ASSIGN {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[30] = x-value.
        END.
    END.

END.

{&open-query-browse-2}
{&open-query-browse-3}

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
  {src/adm/template/snd-list.i "TORDENES"}
  {src/adm/template/snd-list.i "PTOSDESPACHO"}

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

