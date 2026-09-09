&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-Clientes NO-UNDO LIKE VtaTabla.
DEFINE TEMP-TABLE T-Distritos NO-UNDO LIKE VtaTabla.
DEFINE TEMP-TABLE T-Zonas NO-UNDO LIKE VtaTabla.



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
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-Zona AS CHAR NO-UNDO.
DEF VAR x-CodDepto AS CHAR NO-UNDO.
DEF VAR x-CodProvi AS CHAR NO-UNDO.
DEF VAR x-CodDistr AS CHAR NO-UNDO.

DEF BUFFER BT-Zonas FOR T-Zonas.
DEF BUFFER BT-Distritos FOR T-Distritos.
DEF BUFFER BT-Clientes FOR T-Clientes.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-11

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-Zonas FacTabla T-Distritos TabDistr ~
T-Clientes gn-clie

/* Definitions for BROWSE BROWSE-11                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-11 T-Zonas.Llave_c1 FacTabla.Nombre ~
T-Zonas.Valor[1] T-Zonas.Valor[2] T-Zonas.Valor[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-11 
&Scoped-define QUERY-STRING-BROWSE-11 FOR EACH T-Zonas NO-LOCK, ~
      EACH FacTabla WHERE FacTabla.CodCia = T-Zonas.CodCia ~
  AND FacTabla.Codigo = T-Zonas.Llave_c1 ~
      AND FacTabla.Tabla = "ZN" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-11 OPEN QUERY BROWSE-11 FOR EACH T-Zonas NO-LOCK, ~
      EACH FacTabla WHERE FacTabla.CodCia = T-Zonas.CodCia ~
  AND FacTabla.Codigo = T-Zonas.Llave_c1 ~
      AND FacTabla.Tabla = "ZN" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-11 T-Zonas FacTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-11 T-Zonas
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-11 FacTabla


/* Definitions for BROWSE BROWSE-12                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-12 T-Distritos.Llave_c4 ~
TabDistr.NomDistr T-Distritos.Valor[1] T-Distritos.Valor[2] ~
T-Distritos.Valor[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-12 
&Scoped-define QUERY-STRING-BROWSE-12 FOR EACH T-Distritos ~
      WHERE T-Distritos.Llave_c1 = x-Zona NO-LOCK, ~
      EACH TabDistr WHERE TabDistr.CodDepto = T-Distritos.Llave_c2 ~
  AND TabDistr.CodProvi = T-Distritos.Llave_c3 ~
  AND TabDistr.CodDistr = T-Distritos.LLave_c4 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-12 OPEN QUERY BROWSE-12 FOR EACH T-Distritos ~
      WHERE T-Distritos.Llave_c1 = x-Zona NO-LOCK, ~
      EACH TabDistr WHERE TabDistr.CodDepto = T-Distritos.Llave_c2 ~
  AND TabDistr.CodProvi = T-Distritos.Llave_c3 ~
  AND TabDistr.CodDistr = T-Distritos.LLave_c4 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-12 T-Distritos TabDistr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-12 T-Distritos
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-12 TabDistr


/* Definitions for BROWSE BROWSE-13                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-13 T-Clientes.Llave_c5 gn-clie.NomCli ~
T-Clientes.Valor[1] T-Clientes.Valor[2] T-Clientes.Valor[3] ~
T-Clientes.Libre_c01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-13 T-Clientes.Libre_c01 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-13 T-Clientes
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-13 T-Clientes
&Scoped-define QUERY-STRING-BROWSE-13 FOR EACH T-Clientes ~
      WHERE T-Clientes.Llave_c1 = x-Zona ~
AND T-Clientes.Llave_c2 = x-CodDepto ~
AND T-Clientes.Llave_c3 = x-CodProvi ~
AND T-Clientes.Llave_c4 = x-CodDistr NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = T-Clientes.Llave_c5 ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-13 OPEN QUERY BROWSE-13 FOR EACH T-Clientes ~
      WHERE T-Clientes.Llave_c1 = x-Zona ~
AND T-Clientes.Llave_c2 = x-CodDepto ~
AND T-Clientes.Llave_c3 = x-CodProvi ~
AND T-Clientes.Llave_c4 = x-CodDistr NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = T-Clientes.Llave_c5 ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-13 T-Clientes gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-13 T-Clientes
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-13 gn-clie


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-11}~
    ~{&OPEN-QUERY-BROWSE-12}~
    ~{&OPEN-QUERY-BROWSE-13}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 BROWSE-11 BUTTON-2 ~
BROWSE-12 BROWSE-13 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-11 FILL-IN-12 FILL-IN-13 ~
FILL-IN-21 FILL-IN-22 FILL-IN-23 FILL-IN-Mensaje FILL-IN-31 FILL-IN-32 ~
FILL-IN-33 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     LABEL "Button 2" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-11 AS DECIMAL FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-12 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-13 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-21 AS DECIMAL FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-22 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-23 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-31 AS DECIMAL FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-32 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-33 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 1.15.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 1.15.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 115 BY 1.15.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-11 FOR 
      T-Zonas, 
      FacTabla SCROLLING.

DEFINE QUERY BROWSE-12 FOR 
      T-Distritos, 
      TabDistr SCROLLING.

DEFINE QUERY BROWSE-13 FOR 
      T-Clientes, 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-11 W-Win _STRUCTURED
  QUERY BROWSE-11 NO-LOCK DISPLAY
      T-Zonas.Llave_c1 COLUMN-LABEL "Zona" FORMAT "x(8)":U WIDTH 8.43
      FacTabla.Nombre COLUMN-LABEL "Descripción" FORMAT "x(20)":U
            WIDTH 20.43
      T-Zonas.Valor[1] COLUMN-LABEL "# de O/D" FORMAT ">>>,>>9":U
      T-Zonas.Valor[2] COLUMN-LABEL "Importe S/." FORMAT ">>>,>>9.99":U
      T-Zonas.Valor[3] COLUMN-LABEL "Peso Kg." FORMAT ">>>,>>9.99":U
            WIDTH 7.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 59 BY 4.5
         FONT 4 ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-12 W-Win _STRUCTURED
  QUERY BROWSE-12 NO-LOCK DISPLAY
      T-Distritos.Llave_c4 COLUMN-LABEL "Distrito" FORMAT "x(8)":U
            WIDTH 8.43
      TabDistr.NomDistr FORMAT "X(30)":U WIDTH 29.86
      T-Distritos.Valor[1] COLUMN-LABEL "# O/D" FORMAT ">>>,>>9":U
      T-Distritos.Valor[2] COLUMN-LABEL "Importe S/." FORMAT ">>>,>>9.99":U
      T-Distritos.Valor[3] COLUMN-LABEL "Peso Kg." FORMAT ">>>,>>9.99":U
            WIDTH 8.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 68 BY 4.5
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-13 W-Win _STRUCTURED
  QUERY BROWSE-13 NO-LOCK DISPLAY
      T-Clientes.Llave_c5 COLUMN-LABEL "Cliente" FORMAT "x(15)":U
            WIDTH 15.43
      gn-clie.NomCli COLUMN-LABEL "Nombre  o Razón Social" FORMAT "x(60)":U
            WIDTH 59.86
      T-Clientes.Valor[1] COLUMN-LABEL "# O/D" FORMAT ">>>,>>9":U
      T-Clientes.Valor[2] COLUMN-LABEL "Importe S/." FORMAT ">>>,>>9.99":U
      T-Clientes.Valor[3] COLUMN-LABEL "Peso Kg." FORMAT ">>>,>>9.99":U
            WIDTH 8.72
      T-Clientes.Libre_c01 COLUMN-LABEL "Selección" FORMAT "x(15)":U
            WIDTH 9.29 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Despachar","Si",
                                      "No despachar","No"
                      DROP-DOWN-LIST 
  ENABLE
      T-Clientes.Libre_c01
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 115 BY 4.5
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-11 AT ROW 1.19 COL 3 WIDGET-ID 200
     BUTTON-2 AT ROW 1.96 COL 82 WIDGET-ID 2
     FILL-IN-11 AT ROW 6 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     FILL-IN-12 AT ROW 6 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN-13 AT ROW 6 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BROWSE-12 AT ROW 7.35 COL 3 WIDGET-ID 300
     FILL-IN-21 AT ROW 12.15 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-22 AT ROW 12.15 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-23 AT ROW 12.15 COL 58 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     BROWSE-13 AT ROW 13.5 COL 3 WIDGET-ID 400
     FILL-IN-Mensaje AT ROW 18.31 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     FILL-IN-31 AT ROW 18.31 COL 78 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-32 AT ROW 18.31 COL 85 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FILL-IN-33 AT ROW 18.31 COL 95 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     RECT-1 AT ROW 5.81 COL 3 WIDGET-ID 10
     RECT-2 AT ROW 11.96 COL 3 WIDGET-ID 18
     RECT-3 AT ROW 18.12 COL 3 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 121.86 BY 18.65
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-Clientes T "?" NO-UNDO INTEGRAL VtaTabla
      TABLE: T-Distritos T "?" NO-UNDO INTEGRAL VtaTabla
      TABLE: T-Zonas T "?" NO-UNDO INTEGRAL VtaTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 18.65
         WIDTH              = 121.86
         MAX-HEIGHT         = 18.65
         MAX-WIDTH          = 126.29
         VIRTUAL-HEIGHT     = 18.65
         VIRTUAL-WIDTH      = 126.29
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
/* BROWSE-TAB BROWSE-11 RECT-3 F-Main */
/* BROWSE-TAB BROWSE-12 FILL-IN-13 F-Main */
/* BROWSE-TAB BROWSE-13 FILL-IN-23 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-11 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-12 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-13 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-21 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-22 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-23 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-31 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-32 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-33 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-11
/* Query rebuild information for BROWSE BROWSE-11
     _TblList          = "Temp-Tables.T-Zonas,INTEGRAL.FacTabla WHERE Temp-Tables.T-Zonas ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _JoinCode[2]      = "INTEGRAL.FacTabla.CodCia = Temp-Tables.T-Zonas.CodCia
  AND INTEGRAL.FacTabla.Codigo = Temp-Tables.T-Zonas.Llave_c1"
     _Where[2]         = "INTEGRAL.FacTabla.Tabla = ""ZN"""
     _FldNameList[1]   > Temp-Tables.T-Zonas.Llave_c1
"T-Zonas.Llave_c1" "Zona" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacTabla.Nombre
"FacTabla.Nombre" "Descripción" "x(20)" "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-Zonas.Valor[1]
"T-Zonas.Valor[1]" "# de O/D" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-Zonas.Valor[2]
"T-Zonas.Valor[2]" "Importe S/." ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-Zonas.Valor[3]
"T-Zonas.Valor[3]" "Peso Kg." ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-11 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-12
/* Query rebuild information for BROWSE BROWSE-12
     _TblList          = "Temp-Tables.T-Distritos,INTEGRAL.TabDistr WHERE Temp-Tables.T-Distritos ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.T-Distritos.Llave_c1 = x-Zona"
     _JoinCode[2]      = "INTEGRAL.TabDistr.CodDepto = Temp-Tables.T-Distritos.Llave_c2
  AND INTEGRAL.TabDistr.CodProvi = Temp-Tables.T-Distritos.Llave_c3
  AND INTEGRAL.TabDistr.CodDistr = Temp-Tables.T-Distritos.LLave_c4"
     _FldNameList[1]   > Temp-Tables.T-Distritos.Llave_c4
"T-Distritos.Llave_c4" "Distrito" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.TabDistr.NomDistr
"TabDistr.NomDistr" ? ? "character" ? ? ? ? ? ? no ? no no "29.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-Distritos.Valor[1]
"T-Distritos.Valor[1]" "# O/D" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-Distritos.Valor[2]
"T-Distritos.Valor[2]" "Importe S/." ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-Distritos.Valor[3]
"T-Distritos.Valor[3]" "Peso Kg." ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-12 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-13
/* Query rebuild information for BROWSE BROWSE-13
     _TblList          = "Temp-Tables.T-Clientes,INTEGRAL.gn-clie WHERE Temp-Tables.T-Clientes ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.T-Clientes.Llave_c1 = x-Zona
AND Temp-Tables.T-Clientes.Llave_c2 = x-CodDepto
AND Temp-Tables.T-Clientes.Llave_c3 = x-CodProvi
AND Temp-Tables.T-Clientes.Llave_c4 = x-CodDistr"
     _JoinCode[2]      = "INTEGRAL.gn-clie.CodCli = Temp-Tables.T-Clientes.Llave_c5"
     _Where[2]         = "INTEGRAL.gn-clie.CodCia = cl-codcia"
     _FldNameList[1]   > Temp-Tables.T-Clientes.Llave_c5
"T-Clientes.Llave_c5" "Cliente" "x(15)" "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" "Nombre  o Razón Social" "x(60)" "character" ? ? ? ? ? ? no ? no no "59.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-Clientes.Valor[1]
"T-Clientes.Valor[1]" "# O/D" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-Clientes.Valor[2]
"T-Clientes.Valor[2]" "Importe S/." ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-Clientes.Valor[3]
"T-Clientes.Valor[3]" "Peso Kg." ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-Clientes.Libre_c01
"T-Clientes.Libre_c01" "Selección" "x(15)" "character" ? ? ? ? ? ? yes ? no no "9.29" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Despachar,Si,No despachar,No" 5 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-13 */
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


&Scoped-define BROWSE-NAME BROWSE-11
&Scoped-define SELF-NAME BROWSE-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-11 W-Win
ON VALUE-CHANGED OF BROWSE-11 IN FRAME F-Main
DO:
  ASSIGN
      x-Zona = ''
      x-CodDepto = ''
      x-CodProvi = ''
      x-CodDistr = ''.

  x-Zona = T-Zonas.Llave_c1.
  FIND FIRST BT-Distritos WHERE BT-Distritos.Llave_c1 = x-Zona NO-LOCK NO-ERROR.
  IF AVAILABLE BT-Distritos THEN
      ASSIGN
      x-CodDepto = BT-Distritos.Llave_c2
      x-CodProvi = BT-Distritos.Llave_c3
      x-CodDistr = BT-Distritos.Llave_c4.
  {&OPEN-QUERY-BROWSE-12}
  {&OPEN-QUERY-BROWSE-13}
  RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-12
&Scoped-define SELF-NAME BROWSE-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-12 W-Win
ON VALUE-CHANGED OF BROWSE-12 IN FRAME F-Main
DO:
  ASSIGN
      x-CodDepto = T-Distritos.Llave_c2
      x-CodProvi = T-Distritos.Llave_c3
      x-CodDistr = T-Distritos.Llave_c4.
  {&OPEN-QUERY-BROWSE-13}
  RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
   RUN Carga-Temporales.
   ASSIGN
       x-Zona = ''
       x-CodDepto = ''
       x-CodProvi = ''
       x-CodDistr = ''.
   FIND FIRST BT-Zonas NO-LOCK NO-ERROR.
   IF AVAILABLE BT-Zonas THEN x-Zona = BT-Zonas.Llave_c1.
   FIND FIRST BT-Distritos WHERE BT-Distritos.Llave_c1 = x-Zona NO-LOCK NO-ERROR.
   IF AVAILABLE BT-Distritos THEN
       ASSIGN
       x-CodDepto = BT-Distritos.Llave_c2
       x-CodProvi = BT-Distritos.Llave_c3
       x-CodDistr = BT-Distritos.Llave_c4.

   {&OPEN-QUERY-BROWSE-11}
   {&OPEN-QUERY-BROWSE-12}
   {&OPEN-QUERY-BROWSE-13}

   RUN Totales.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-11
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
ON 'VALUE-CHANGED':U OF T-Clientes.Libre_c01
DO:
    APPLY 'TAB':U.
    RUN Totales.
END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporales W-Win 
PROCEDURE Carga-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-Zonas.

DEF VAR pHojRut   AS CHAR NO-UNDO.
DEF VAR pFlgEst-1 AS CHAR NO-UNDO.
DEF VAR pFlgEst-2 AS CHAR NO-UNDO.
DEF VAR pFchDoc   AS DATE NO-UNDO.
DEF VAR x-Factor  AS INTE NO-UNDO.

FOR EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia
    AND faccpedi.coddoc = 'O/D'
    AND LOOKUP(faccpedi.flgest, 'P,C') > 0
    AND faccpedi.divdes = s-coddiv
    AND faccpedi.fchped >= TODAY - 15
    AND flgsit = 'C':
    x-Factor = 1.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        "*** PROCESANDO >>> " + faccpedi.coddoc + ' ' + faccpedi.nroped + ' ' +
        STRING(faccpedi.fchped).

    FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddoc = 'G/R'
        AND ccbcdocu.coddiv = s-coddiv
        AND ccbcdocu.codcli = faccpedi.codcli
        AND ccbcdocu.fchdoc >= faccpedi.fchped
        AND ccbcdocu.flgest <> 'A'
        AND ccbcdocu.libre_c01 = faccpedi.coddoc
        AND ccbcdocu.libre_c02 = faccpedi.nroped,
        FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = ccbcdocu.codcli,
        FIRST TabDepto NO-LOCK WHERE TabDepto.CodDepto = gn-clie.CodDept,
        FIRST TabDistr NO-LOCK WHERE TabDistr.CodDepto = gn-clie.CodDept
        AND TabDistr.CodProvi = gn-clie.CodProv
        AND TabDistr.CodDistr =  gn-clie.CodDist,
        FIRST FacTabla WHERE integral.FacTabla.CodCia = s-codcia
        AND integral.FacTabla.Tabla = "ZN"
        AND FacTabla.Codigo = TabDepto.Zona:
        pFlgEst-1 = ''.
        RUN dist/p-rut002 ( "G/R",
                            Ccbcdocu.coddoc,
                            Ccbcdocu.nrodoc,
                            "",
                            "",
                            "",
                            0,
                            0,
                            OUTPUT pHojRut,
                            OUTPUT pFlgEst-1,     /* de Di-RutaC */
                            OUTPUT pFlgEst-2,     /* de Di-RutaG */
                            OUTPUT pFchDoc).
        IF pFlgEst-1 <> '' THEN NEXT.
        /* CONTROL POR ZONAS */
        FIND T-Zonas WHERE T-Zonas.CodCia = s-codcia
            AND T-Zonas.Tabla = "ZONAS"
            AND T-Zonas.Llave_c1 = TabDepto.Zona
            NO-ERROR.
        IF NOT AVAILABLE T-Zonas THEN CREATE T-Zonas.
        ASSIGN
            T-Zonas.CodCia = s-codcia
            T-Zonas.Tabla = "ZONAS"
            T-Zonas.Llave_c1 = TabDepto.Zona
            T-Zonas.Valor[1] = T-Zonas.Valor[1] + x-Factor
            T-Zonas.Valor[2] = T-Zonas.Valor[2] + x-Factor * (IF Faccpedi.codmon = 1 THEN Faccpedi.imptot ELSE Faccpedi.imptot * Faccpedi.tpocmb)
            T-Zonas.Valor[3] = T-Zonas.Valor[3] + Faccpedi.Libre_d02 * x-Factor.
        /* CONTROL POR DISTRITOS */
        FIND T-Distritos WHERE T-Distritos.CodCia = s-codcia
            AND T-Distritos.Tabla = 'DISTRITOS'
            AND T-Distritos.Llave_c1 = TabDepto.Zona
            AND T-Distritos.Llave_c2 = TabDistr.CodDepto
            AND T-Distritos.LLave_c3 = TabDistr.CodProvi
            AND T-Distritos.Llave_c4 = TabDistr.CodDistr
            NO-ERROR.
        IF NOT AVAILABLE T-Distritos THEN CREATE T-Distritos.
        ASSIGN
            T-Distritos.CodCia = s-codcia
            T-Distritos.Tabla = 'DISTRITOS'
            T-Distritos.Llave_c1 = TabDepto.Zona
            T-Distritos.Llave_c2 = TabDistr.CodDepto
            T-Distritos.LLave_c3 = TabDistr.CodProvi
            T-Distritos.Llave_c4 = TabDistr.CodDistr
            T-Distritos.Valor[1] = T-Distritos.Valor[1] + x-Factor
            T-Distritos.Valor[2] = T-Distritos.Valor[2] + x-Factor * (IF Faccpedi.codmon = 1 THEN Faccpedi.imptot ELSE Faccpedi.imptot * Faccpedi.tpocmb)
            T-Distritos.Valor[3] = T-Distritos.Valor[3] + Faccpedi.Libre_d02 * x-Factor.
        /* CONTROL POR CLIENTES */
        FIND T-Clientes WHERE T-Clientes.CodCia = s-codcia
            AND T-Clientes.Tabla = 'CLIENTES'
            AND T-Clientes.Llave_c1 = TabDepto.Zona
            AND T-Clientes.Llave_c2 = TabDistr.CodDepto
            AND T-Clientes.LLave_c3 = TabDistr.CodProvi
            AND T-Clientes.Llave_c4 = TabDistr.CodDistr
            AND T-Clientes.Llave_c5 = gn-clie.codcli
            NO-ERROR.
        IF NOT AVAILABLE T-Clientes THEN CREATE T-Clientes.
        ASSIGN
            T-Clientes.CodCia = s-codcia
            T-Clientes.Tabla = 'CLIENTES'
            T-Clientes.Llave_c1 = TabDepto.Zona
            T-Clientes.Llave_c2 = TabDistr.CodDepto
            T-Clientes.LLave_c3 = TabDistr.CodProvi
            T-Clientes.Llave_c4 = TabDistr.CodDistr
            T-Clientes.Llave_c5 = gn-clie.codcli
            T-Clientes.Valor[1] = T-Clientes.Valor[1] + x-Factor
            T-Clientes.Valor[2] = T-Clientes.Valor[2] + x-Factor * (IF Faccpedi.codmon = 1 THEN Faccpedi.imptot ELSE Faccpedi.imptot * Faccpedi.tpocmb)
            T-Clientes.Valor[3] = T-Clientes.Valor[3] + Faccpedi.Libre_d02 * x-Factor
            T-Clientes.Libre_c01 = 'Si'.
        x-Factor = 0.
    END.
END.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "*** PROCESANDO TERMINADO ***".
PAUSE 2.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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
  DISPLAY FILL-IN-11 FILL-IN-12 FILL-IN-13 FILL-IN-21 FILL-IN-22 FILL-IN-23 
          FILL-IN-Mensaje FILL-IN-31 FILL-IN-32 FILL-IN-33 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 RECT-3 BROWSE-11 BUTTON-2 BROWSE-12 BROWSE-13 
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
  {src/adm/template/snd-list.i "T-Clientes"}
  {src/adm/template/snd-list.i "gn-clie"}
  {src/adm/template/snd-list.i "T-Distritos"}
  {src/adm/template/snd-list.i "TabDistr"}
  {src/adm/template/snd-list.i "T-Zonas"}
  {src/adm/template/snd-list.i "FacTabla"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales W-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    FILL-IN-11 = 0
    FILL-IN-12 = 0
    FILL-IN-13 = 0
    FILL-IN-21 = 0
    FILL-IN-22 = 0
    FILL-IN-23 = 0
    FILL-IN-31 = 0
    FILL-IN-32 = 0
    FILL-IN-33 = 0.
FOR EACH BT-Zonas:
    ASSIGN
        FILL-IN-11 = FILL-IN-11 + BT-Zonas.Valor[1]
        FILL-IN-12 = FILL-IN-12 + BT-Zonas.Valor[2]
        FILL-IN-13 = FILL-IN-13 + BT-Zonas.Valor[3].
END.

FOR EACH BT-Distritos WHERE BT-Distritos.Llave_c1 = x-Zona:
    ASSIGN
        FILL-IN-21 = FILL-IN-21 + BT-Distritos.Valor[1]
        FILL-IN-22 = FILL-IN-22 + BT-Distritos.Valor[2]
        FILL-IN-23 = FILL-IN-23 + BT-Distritos.Valor[3].
END.

FOR EACH BT-Clientes WHERE BT-Clientes.Llave_c1 = x-Zona
    AND BT-Clientes.Llave_c2 = x-CodDepto
    AND BT-Clientes.Llave_c3 = x-CodProvi
    AND BT-Clientes.Llave_c4 = x-CodDistr:
    ASSIGN
        FILL-IN-31 = FILL-IN-31 + (IF T-Clientes.Libre_c01 = "Si" THEN BT-Clientes.Valor[1] ELSE 0)
        FILL-IN-32 = FILL-IN-32 + (IF T-Clientes.Libre_c01 = "Si" THEN BT-Clientes.Valor[2] ELSE 0)
        FILL-IN-33 = FILL-IN-33 + (IF T-Clientes.Libre_c01 = "Si" THEN BT-Clientes.Valor[3] ELSE 0).
END.
DISPLAY 
    FILL-IN-11 FILL-IN-12 FILL-IN-13 FILL-IN-21 FILL-IN-22 FILL-IN-23 FILL-IN-31 FILL-IN-32 FILL-IN-33
    WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

