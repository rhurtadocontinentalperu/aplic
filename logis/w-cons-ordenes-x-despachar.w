&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-report-clientes NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE t-report-od NO-UNDO LIKE w-report.



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

DEFINE VAR x-cliente AS CHAR.

define var x-sort-column-current as char.

DEFINE TEMP-TABLE t-filer
    FIELD   cgr AS  CHAR    FORMAT 'x(8)'
    FIELD   ngr AS  CHAR    FORMAT 'x(15)'
INDEX idx01 cgr ngr.

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
&Scoped-define INTERNAL-TABLES t-report-clientes t-report-od

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-report-clientes.Llave-C ~
t-report-clientes.Campo-C[1] t-report-clientes.Campo-I[1] ~
t-report-clientes.Campo-I[2] t-report-clientes.Campo-F[1] ~
t-report-clientes.Campo-F[2] t-report-clientes.Campo-F[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-report-clientes NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-report-clientes NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-report-clientes
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-report-clientes


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 t-report-od.Campo-C[1] ~
t-report-od.Campo-C[2] t-report-od.Campo-C[3] t-report-od.Campo-D[1] ~
t-report-od.Campo-I[1] t-report-od.Campo-F[1] t-report-od.Campo-F[2] ~
t-report-od.Campo-C[4] t-report-od.Campo-F[3] t-report-od.Campo-C[5] ~
t-report-od.Campo-C[6] t-report-od.Campo-C[7] t-report-od.Campo-C[8] ~
t-report-od.Campo-C[9] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH t-report-od ~
      WHERE t-report-od.Llave-C = x-cliente NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH t-report-od ~
      WHERE t-report-od.Llave-C = x-cliente NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 t-report-od
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 t-report-od


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-dias-atras BUTTON-1 BROWSE-2 ~
BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-tiempo FILL-IN-dias-atras 

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
     SIZE 12.14 BY 1.12.

DEFINE VARIABLE FILL-IN-dias-atras AS INTEGER FORMAT ">9":U INITIAL 3 
     LABEL "Dias hacia atras" 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-tiempo AS CHARACTER FORMAT "X(50)":U 
     LABEL "Tiempo" 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81
     FGCOLOR 9 FONT 4 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-report-clientes SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      t-report-od SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-report-clientes.Llave-C COLUMN-LABEL "Codigo!Cliente" FORMAT "x(15)":U
            WIDTH 9.43
      t-report-clientes.Campo-C[1] COLUMN-LABEL "Nombre del Cliente" FORMAT "X(80)":U
            WIDTH 38.43
      t-report-clientes.Campo-I[1] COLUMN-LABEL "Cant!ODs" FORMAT "->>>,>>>,>>9":U
            WIDTH 7.43
      t-report-clientes.Campo-I[2] COLUMN-LABEL "Items" FORMAT "->>>,>>>,>>9":U
            WIDTH 8.43
      t-report-clientes.Campo-F[1] COLUMN-LABEL "Peso" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 9.43
      t-report-clientes.Campo-F[2] COLUMN-LABEL "Volumen" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 5.86
      t-report-clientes.Campo-F[3] COLUMN-LABEL "Importe S/" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 8.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 94.43 BY 12.42
         FONT 4 ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      t-report-od.Campo-C[1] COLUMN-LABEL "Div!Dspcho" FORMAT "X(8)":U
      t-report-od.Campo-C[2] COLUMN-LABEL "Cod!Doc" FORMAT "X(5)":U
      t-report-od.Campo-C[3] COLUMN-LABEL "Nro!Doc" FORMAT "X(9)":U
            WIDTH 10.14
      t-report-od.Campo-D[1] COLUMN-LABEL "Femision" FORMAT "99/99/9999":U
      t-report-od.Campo-I[1] COLUMN-LABEL "Items" FORMAT "->>>,>>>,>>9":U
      t-report-od.Campo-F[1] COLUMN-LABEL "Peso" FORMAT "->>>,>>>,>>9.99":U
      t-report-od.Campo-F[2] COLUMN-LABEL "Volumen" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 9.29
      t-report-od.Campo-C[4] COLUMN-LABEL "Div!Venta" FORMAT "X(8)":U
            WIDTH 6.43
      t-report-od.Campo-F[3] COLUMN-LABEL "Importe" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 10.29
      t-report-od.Campo-C[5] COLUMN-LABEL "Mone" FORMAT "X(5)":U
            WIDTH 6.43
      t-report-od.Campo-C[6] COLUMN-LABEL "PHR" FORMAT "X(12)":U
            WIDTH 10.14
      t-report-od.Campo-C[7] COLUMN-LABEL "H/R" FORMAT "X(8)":U
            WIDTH 9.72
      t-report-od.Campo-C[8] COLUMN-LABEL "Estado!O/D" FORMAT "X(15)":U
            WIDTH 17.14
      t-report-od.Campo-C[9] COLUMN-LABEL "Estado!H/R" FORMAT "X(15)":U
            WIDTH 12.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 140.14 BY 8.38
         FONT 4 ROW-HEIGHT-CHARS .42 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-tiempo AT ROW 1.38 COL 17 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-dias-atras AT ROW 1.38 COL 73.57 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 1.38 COL 81 WIDGET-ID 4
     BROWSE-2 AT ROW 2.62 COL 1.57 WIDGET-ID 200
     BROWSE-3 AT ROW 15.08 COL 1.86 WIDGET-ID 300
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 141.57 BY 22.62
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-report-clientes T "?" NO-UNDO INTEGRAL w-report
      TABLE: t-report-od T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Ordenes de despacho pendientes"
         HEIGHT             = 22.62
         WIDTH              = 141.57
         MAX-HEIGHT         = 22.62
         MAX-WIDTH          = 141.57
         VIRTUAL-HEIGHT     = 22.62
         VIRTUAL-WIDTH      = 141.57
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
/* BROWSE-TAB BROWSE-2 BUTTON-1 F-Main */
/* BROWSE-TAB BROWSE-3 BROWSE-2 F-Main */
ASSIGN 
       BROWSE-2:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-tiempo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-report-clientes"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.t-report-clientes.Llave-C
"Llave-C" "Codigo!Cliente" "x(15)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-report-clientes.Campo-C[1]
"Campo-C[1]" "Nombre del Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "38.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-report-clientes.Campo-I[1]
"Campo-I[1]" "Cant!ODs" ? "integer" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-report-clientes.Campo-I[2]
"Campo-I[2]" "Items" ? "integer" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-report-clientes.Campo-F[1]
"Campo-F[1]" "Peso" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-report-clientes.Campo-F[2]
"Campo-F[2]" "Volumen" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "5.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-report-clientes.Campo-F[3]
"Campo-F[3]" "Importe S/" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.t-report-od"
     _Options          = "NO-LOCK"
     _Where[1]         = "t-report-od.Llave-C = x-cliente"
     _FldNameList[1]   > Temp-Tables.t-report-od.Campo-C[1]
"Campo-C[1]" "Div!Dspcho" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-report-od.Campo-C[2]
"Campo-C[2]" "Cod!Doc" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-report-od.Campo-C[3]
"Campo-C[3]" "Nro!Doc" "X(9)" "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-report-od.Campo-D[1]
"Campo-D[1]" "Femision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-report-od.Campo-I[1]
"Campo-I[1]" "Items" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-report-od.Campo-F[1]
"Campo-F[1]" "Peso" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-report-od.Campo-F[2]
"Campo-F[2]" "Volumen" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-report-od.Campo-C[4]
"Campo-C[4]" "Div!Venta" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.t-report-od.Campo-F[3]
"Campo-F[3]" "Importe" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.t-report-od.Campo-C[5]
"Campo-C[5]" "Mone" "X(5)" "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.t-report-od.Campo-C[6]
"Campo-C[6]" "PHR" "X(12)" "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.t-report-od.Campo-C[7]
"Campo-C[7]" "H/R" ? "character" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.t-report-od.Campo-C[8]
"Campo-C[8]" "Estado!O/D" "X(15)" "character" ? ? ? ? ? ? no ? no no "17.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.t-report-od.Campo-C[9]
"Campo-C[9]" "Estado!H/R" "X(15)" "character" ? ? ? ? ? ? no ? no no "12.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ordenes de despacho pendientes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ordenes de despacho pendientes */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON START-SEARCH OF BROWSE-2 IN FRAME F-Main
DO:
    DEFINE VAR x-sql AS CHAR.

    x-sql = "FOR EACH t-report-clientes NO-LOCK ".

    {gn/sort-browse.i &ThisBrowse="browse-2" &ThisSQL = x-SQL}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main
DO:

    x-cliente = "".

  IF AVAILABLE t-report-clientes THEN x-cliente = t-report-clientes.llave-c.

  {&open-query-browse-3}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Refrescar */
DO:
  RUN refrescar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY FILL-IN-tiempo FILL-IN-dias-atras 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-dias-atras BUTTON-1 BROWSE-2 BROWSE-3 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar W-Win 
PROCEDURE refrescar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE("GENERAL").

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-dias-atras.
END.

DEFINE VAR x-desde AS DATE.
DEFINE VAR x-pendiente-despacho AS LOG.

x-desde = TODAY - fill-in-dias-atras.
x-cliente = "".

EMPTY TEMP-TABLE t-report-clientes.
EMPTY TEMP-TABLE t-report-OD.

DEFINE VAR x-tiempo AS CHAR.
DEFINE VAR x-phr AS CHAR.
DEFINE VAR x-hr AS CHAR.
DEFINE VAR x-est-od AS CHAR.
DEFINE VAR x-est-hr AS CHAR.


x-tiempo = STRING(NOW,"99/99/9999 HH:MM:SS").
DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR pEstado AS CHAR NO-UNDO.
RUN tra/tra-librerias PERSISTENT SET hProc.

FOR EACH gn-divi  WHERE gn-divi.codcia = s-codcia NO-LOCK:
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                faccpedi.divdes = gn-divi.coddiv AND
                                faccpedi.coddoc = 'O/D' AND 
                                faccpedi.flgest <> 'A' AND
                                faccpedi.fchped >= x-desde
                                 NO-LOCK NO-ERROR.
    /* No existen */
    IF NOT AVAILABLE faccpedi THEN NEXT.

    EMPTY TEMP-TABLE t-filer.

    FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND
                            faccpedi.divdes = gn-divi.coddiv AND
                            faccpedi.coddoc = 'O/D' AND 
                            faccpedi.flgest <> 'A' AND 
                            faccpedi.fchped >= x-desde NO-LOCK :

        x-pendiente-despacho = YES.
        x-phr = "".
        x-hr = "".
        x-est-od = "".
        x-est-hr = "".

        x-est-od = Faccpedi.FlgEst.
        IF (Faccpedi.FlgEst = "P") THEN x-est-od = 'POR CHEQUEAR'.
        IF (Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "T") THEN x-est-od = 'APROBADO'.
        IF (Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "TG") THEN x-est-od = 'EN ALMACEN'.
        IF (Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "PI") THEN x-est-od = 'PICKEADO'.
        IF (Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "PC") THEN x-est-od = 'CHEQUEADO'.
        IF (Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "C") THEN x-est-od = 'POR FACTURAR'.
        IF (Faccpedi.FlgEst = "C" AND Faccpedi.FlgSit = "C") THEN x-est-od = 'DOCUMENTADO'.
        IF (Faccpedi.FlgEst = "A") THEN x-est-od = 'ANULADO'.

        /* Si la O/D tiene PHR verificar que no sea diferente de A y C */
        FIND FIRST di-rutaD WHERE di-rutaD.codcia = s-codcia AND 
                                di-rutaD.coddoc = 'PHR' AND 
                                di-rutaD.codref = faccpedi.coddoc AND       /* O/D */
                                di-rutaD.nroref = faccpedi.nroped NO-LOCK NO-ERROR.
        IF AVAILABLE di-rutaD THEN DO:
            /* Tiene PHR */
            FIND FIRST di-rutaC OF di-rutaD WHERE LOOKUP(di-rutaC.flgest,"A,C") > 0 NO-LOCK NO-ERROR.
            /* PHR esta Anulado o Cerrado */
            IF AVAILABLE di-rutaC THEN NEXT.

            x-phr = di-rutaD.nrodoc.
        END.

        FIND FIRST logtrkdocs WHERE logtrkdocs.codcia = s-codcia AND
                                    logtrkdocs.clave = "TRCKPED" AND
                                    logtrkdocs.coddiv = gn-divi.coddiv AND 
                                    logtrkdocs.coddoc = 'O/D' AND 
                                    logtrkdocs.nrodoc = faccpedi.nroped AND
                                    logtrkdocs.codigo = 'HR_DIS' NO-LOCK NO-ERROR.
        IF AVAILABLE logtrkdocs THEN DO:
            /* Ls O/D tiene hoja de RUTA */
            /* Si el pedido de la O/D tiene G/R, para luego ver si la H/R esta pendiente */
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                        ccbcdocu.codped = faccpedi.codref AND   /* PED */
                                        ccbcdocu.nroped = faccpedi.nroref AND
                                        ccbcdocu.coddoc = 'G/R' AND 
                                        ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN DO:
                /* Las G/R */
                FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                            ccbcdocu.codped = faccpedi.codref AND   /* PED */
                                            ccbcdocu.nroped = faccpedi.nroref AND
                                            ccbcdocu.coddoc = 'G/R'/* AND 
                                            ccbcdocu.flgest <> 'A'*/ NO-LOCK:
                    IF ccbcdocu.flgest = 'A' THEN NEXT.
                    IF NOT (ccbcdocu.libre_c01 = 'O/D' AND ccbcdocu.libre_c02 = faccpedi.nroped)  THEN NEXT.
                    CREATE t-filer.
                        ASSIGN t-filer.cgr = ccbcdocu.coddoc
                                t-filer.ngr = ccbcdocu.nrodoc.
                END.

                /* HOJA DE RUTA */            
                x-pendiente-despacho = NO.
                GUIAS_REMISION:
                FOR EACH t-filer NO-LOCK:
                    FIND FIRST di-rutaD WHERE di-rutaD.codcia = s-codcia AND di-rutaD.coddoc = 'H/R' AND 
                                            di-rutaD.codref = t-filer.cgr AND   /* G/R */
                                            di-rutaD.nroref = t-filer.ngr AND 
                                            di-rutaD.flgest <> 'C' NO-LOCK NO-ERROR.                    
                    IF AVAILABLE di-rutaD THEN DO:
                        x-hr = di-rutaD.nrodoc.
                        /* Aun tiene pendientes de despacho */
                        x-pendiente-despacho = YES.
                        x-hr = di-rutaD.nrodoc.

                        FIND FIRST di-rutaC OF di-rutaD  NO-LOCK NO-ERROR.
                        RUN Flag-Estado IN hProc (DI-RutaC.FlgEst, OUTPUT pEstado).            

                        x-est-hr = pEstado.

                        LEAVE GUIAS_REMISION.
                    END.
                END.
            END.
        END.
        IF x-pendiente-despacho = NO THEN NEXT.
        
        /* Clientes */
        FIND FIRST t-report-clientes WHERE t-report-clientes.task-no = 0 AND 
                                            t-report-clientes.llave-c = faccpedi.codcli EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE t-report-clientes THEN DO:
            CREATE t-report-clientes.
                ASSIGN t-report-clientes.task-no = 0
                        t-report-clientes.llave-c = faccpedi.codcli.
                        t-report-clientes.campo-c[1] = faccpedi.nomcli.
        END.        

        ASSIGN t-report-clientes.campo-i[1] = t-report-clientes.campo-i[1] + 1
                t-report-clientes.campo-i[2] = t-report-clientes.campo-i[2] + faccpedi.items
                t-report-clientes.campo-f[1] = t-report-clientes.campo-f[1] + faccpedi.peso
                t-report-clientes.campo-f[2] = t-report-clientes.campo-f[2] + faccpedi.volumen.

        IF faccpedi.codmon = 2 THEN DO:
            /**/
            t-report-clientes.campo-f[3] = t-report-clientes.campo-f[3] + (faccpedi.imptot * faccpedi.tpocmb).
        END.
        ELSE DO:
            t-report-clientes.campo-f[3] = t-report-clientes.campo-f[3] + (faccpedi.imptot * 1).
        END.
            
        /* O/D */
        CREATE t-report-OD.
            ASSIGN  t-report-od.llave-c = faccpedi.codcli
                    t-report-od.campo-c[1] = faccpedi.divdes
                    t-report-od.campo-c[2] = faccpedi.coddoc
                    t-report-od.campo-c[3] = faccpedi.nroped
                    t-report-od.campo-d[1] = faccpedi.fchped
                    t-report-od.campo-i[1] = faccpedi.items
                    t-report-od.campo-f[1] = faccpedi.peso
                    t-report-od.campo-f[2] = faccpedi.volumen
                    t-report-od.campo-c[4] = faccpedi.coddiv
                    t-report-od.campo-f[3] = faccpedi.imptot
                    t-report-od.campo-c[5] = IF (faccpedi.codmon = 2) THEN "US$" ELSE "S/"
                    t-report-od.campo-c[6] = x-phr
                    t-report-od.campo-c[7] = x-hr
                    t-report-od.campo-c[8] = x-est-od
                    t-report-od.campo-c[9] = x-est-hr

                        .
    END.
END.

SESSION:SET-WAIT-STATE("").
DELETE PROCEDURE hProc.

x-tiempo = x-tiempo + " - " + STRING(NOW,"99/99/9999 HH:MM:SS").

ASSIGN fill-in-tiempo:SCREEN-VALUE = x-tiempo.

x-cliente = "".
{&open-query-browse-2}
GET FIRST BROWSE-2.
IF AVAILABLE t-report-clientes THEN DO:
    x-cliente = t-report-clientes.llave-c.
END.

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
  {src/adm/template/snd-list.i "t-report-od"}
  {src/adm/template/snd-list.i "t-report-clientes"}

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

