&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tt-w-report2 NO-UNDO LIKE w-report.



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
DEF VAR x-Cargos AS CHAR INIT 'A/R,A/C,LET,BOL,CHQ,FAC,TCK,N/D,N/C' NO-UNDO.

/*DEF VAR x-Cargos AS CHAR INIT 'LET,BOL,CHQ,FAC,TCK,N/D,N/C,DCO' NO-UNDO.*/

DEFINE SHARED VAR s-codcia AS INT.

DEFINE TEMP-TABLE tt-w-reportX LIKE w-report.

DEFINE TEMP-TABLE ttEECTA
    FIELDS  tCodDoc     AS  CHAR    FORMAT  'x(30)'     COLUMN-LABEL "DOC."
    FIELDS  tNroDoc     AS  CHAR    FORMAT  'x(15)'     COLUMN-LABEL "Nro.Documento"
    FIELDS  treferencia AS  CHAR    COLUMN-LABEL "Referencia"
    FIELDS  tfchemi     AS  DATE    COLUMN-LABEL "Fecha de Emision"
    FIELDS  tfchvcto    AS  DATE    COLUMN-LABEL "Fecha de Vencimiento"
    FIELDS  tmone       AS  CHAR    FORMAT  'x(5)'      COLUMN-LABEL "Moneda"
    FIELDS  tImpCanj    AS  DEC     COLUMN-LABEL "Importe Canjeado"
    FIELDS  tImpTot     AS  DEC     COLUMN-LABEL "Importe Total"
    FIELDS  tSaldo      AS  DEC     COLUMN-LABEL "Saldo"
    FIELDS  tdocapli    AS  CHAR    FORMAT 'x(30)'      COLUMN-LABEL "Docmnto - APLICACIONES"
    FIELDS  timpapli    AS  DEC     COLUMN-LABEL "Impte - APLICADO"
    FIELDS  testado     AS  CHAR    FORMAT 'x(25)'      COLUMN-LABEL "Estado"
    FIELDS  tSituacion  AS  CHAR    FORMAT 'x(25)'      COLUMN-LABEL "Situacion"
    FIELDS  tubica      AS  CHAR    FORMAT 'x(25)'      COLUMN-LABEL "Ubicacion"
    FIELDS  tcoddiv     AS  CHAR    FORMAT 'x(8)'       COLUMN-LABEL "Division Origen"
    .

DEFINE TEMP-TABLE ttAbonos
    FIELDS  tCodDoc     AS  CHAR
    FIELDS  tnroDoc     AS  CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report tt-w-report2

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-w-report.Campo-D[1] ~
tt-w-report.Campo-C[1] tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] ~
tt-w-report.Campo-C[4] tt-w-report.Campo-C[5] tt-w-report.Campo-C[6] ~
tt-w-report.Campo-C[7] tt-w-report.Campo-D[2] tt-w-report.Campo-F[1] ~
tt-w-report.Campo-F[2] tt-w-report.Campo-D[3] tt-w-report.Campo-C[8] ~
tt-w-report.Campo-F[3] tt-w-report.Campo-F[4] tt-w-report.Campo-C[13] ~
tt-w-report.Campo-C[9] tt-w-report.Campo-C[10] tt-w-report.Campo-C[12] ~
tt-w-report.Campo-C[11] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-w-report NO-LOCK ~
    BY tt-w-report.Campo-F[30] INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH tt-w-report NO-LOCK ~
    BY tt-w-report.Campo-F[30] INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-w-report


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 tt-w-report2.Campo-C[1] ~
tt-w-report2.Campo-F[1] tt-w-report2.Campo-F[2] tt-w-report2.Campo-F[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-w-report2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tt-w-report2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-w-report2
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-w-report2


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtCodCli FILL-IN-2 BUTTON-1 rsReporte ~
BROWSE-3 BROWSE-5 BtnExcel 
&Scoped-Define DISPLAYED-OBJECTS txtCodCli FILL-IN-2 rsReporte txtDesde ~
txtHasta txtDeuda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSituacion W-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( INPUT cFlgSit AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fUbicacion W-Win 
FUNCTION fUbicacion RETURNS CHARACTER
  ( INPUT cFlgUbi AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnExcel 
     LABEL "Excel" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-1 
     LABEL "Consultar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 NO-UNDO.

DEFINE VARIABLE txtCodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDeuda AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "DEUDA" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1.73
     BGCOLOR 15 FGCOLOR 9 FONT 8 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE rsReporte AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pendientes", 1,
"Liquidacion", 2
     SIZE 30 BY .96 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tt-w-report SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      tt-w-report2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      tt-w-report.Campo-D[1] COLUMN-LABEL "F.Emision" FORMAT "99/99/9999":U
            WIDTH 8.86
      tt-w-report.Campo-C[1] COLUMN-LABEL "Documento" FORMAT "X(15)":U
            WIDTH 19.14
      tt-w-report.Campo-C[2] COLUMN-LABEL "Numero" FORMAT "X(15)":U
            WIDTH 11.57
      tt-w-report.Campo-C[3] COLUMN-LABEL "Referencia" FORMAT "X(15)":U
      tt-w-report.Campo-C[4] COLUMN-LABEL "Cond!Vta" FORMAT "X(4)":U
      tt-w-report.Campo-C[5] COLUMN-LABEL "Divi!Origen" FORMAT "X(6)":U
      tt-w-report.Campo-C[6] COLUMN-LABEL "Glosa" FORMAT "X(40)":U
      tt-w-report.Campo-C[7] COLUMN-LABEL "Moneda" FORMAT "X(3)":U
      tt-w-report.Campo-D[2] COLUMN-LABEL "Vencmto" FORMAT "99/99/9999":U
      tt-w-report.Campo-F[1] COLUMN-LABEL "Tipo!Cambio" FORMAT "->>,>>9.9999":U
            WIDTH 6.86
      tt-w-report.Campo-F[2] COLUMN-LABEL "Importe" FORMAT "->>>,>>>,>>9.99":U
      tt-w-report.Campo-D[3] COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
            COLUMN-BGCOLOR 10
      tt-w-report.Campo-C[8] COLUMN-LABEL "Documento" FORMAT "X(15)":U
            WIDTH 15.72 COLUMN-BGCOLOR 10
      tt-w-report.Campo-F[3] COLUMN-LABEL "Importe" FORMAT "->,>>>,>>9.99":U
            COLUMN-BGCOLOR 10
      tt-w-report.Campo-F[4] COLUMN-LABEL "Saldo" FORMAT "->,>>>,>>9.99":U
      tt-w-report.Campo-C[13] COLUMN-LABEL "Nro!Unico" FORMAT "X(15)":U
      tt-w-report.Campo-C[9] COLUMN-LABEL "Situacion" FORMAT "X(12)":U
      tt-w-report.Campo-C[10] COLUMN-LABEL "Ubicacion" FORMAT "X(10)":U
      tt-w-report.Campo-C[12] COLUMN-LABEL "Banco" FORMAT "X(35)":U
            WIDTH 38.86
      tt-w-report.Campo-C[11] COLUMN-LABEL "Estado" FORMAT "X(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 142.43 BY 21.27 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tt-w-report2.Campo-C[1] COLUMN-LABEL "Documento" FORMAT "X(20)":U
      tt-w-report2.Campo-F[1] COLUMN-LABEL "Importe Soles" FORMAT "->>>,>>>,>>9.99":U
      tt-w-report2.Campo-F[2] COLUMN-LABEL "Importe Dolares" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 14.57
      tt-w-report2.Campo-F[3] COLUMN-LABEL "Total Soles" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 20.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 73.14 BY 4.5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtCodCli AT ROW 1.58 COL 15 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-2 AT ROW 1.58 COL 32.43 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     BUTTON-1 AT ROW 2.15 COL 119 WIDGET-ID 14
     rsReporte AT ROW 2.81 COL 17.43 NO-LABEL WIDGET-ID 8
     txtDesde AT ROW 2.81 COL 56.72 COLON-ALIGNED WIDGET-ID 6
     txtHasta AT ROW 2.81 COL 79.72 COLON-ALIGNED WIDGET-ID 12
     BROWSE-3 AT ROW 4.73 COL 1.57 WIDGET-ID 200
     BROWSE-5 AT ROW 26.15 COL 1.86 WIDGET-ID 300
     txtDeuda AT ROW 27.54 COL 121 RIGHT-ALIGNED WIDGET-ID 18
     BtnExcel AT ROW 28.12 COL 127 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 145.43 BY 30.23 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
      TABLE: tt-w-report2 T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Estados de Cuenta"
         HEIGHT             = 30.23
         WIDTH              = 145.43
         MAX-HEIGHT         = 30.23
         MAX-WIDTH          = 145.43
         VIRTUAL-HEIGHT     = 30.23
         VIRTUAL-WIDTH      = 145.43
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
/* BROWSE-TAB BROWSE-3 txtHasta F-Main */
/* BROWSE-TAB BROWSE-5 BROWSE-3 F-Main */
/* SETTINGS FOR FILL-IN txtDesde IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDeuda IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtHasta IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-w-report.Campo-F[30]|yes"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-D[1]
"tt-w-report.Campo-D[1]" "F.Emision" ? "date" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Documento" "X(15)" "character" ? ? ? ? ? ? no ? no no "19.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Numero" "X(15)" "character" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Referencia" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Cond!Vta" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "Divi!Origen" "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[6]
"tt-w-report.Campo-C[6]" "Glosa" "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-C[7]
"tt-w-report.Campo-C[7]" "Moneda" "X(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-w-report.Campo-D[2]
"tt-w-report.Campo-D[2]" "Vencmto" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-w-report.Campo-F[1]
"tt-w-report.Campo-F[1]" "Tipo!Cambio" "->>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-w-report.Campo-F[2]
"tt-w-report.Campo-F[2]" "Importe" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-w-report.Campo-D[3]
"tt-w-report.Campo-D[3]" "Fecha" ? "date" 10 ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt-w-report.Campo-C[8]
"tt-w-report.Campo-C[8]" "Documento" "X(15)" "character" 10 ? ? ? ? ? no ? no no "15.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tt-w-report.Campo-F[3]
"tt-w-report.Campo-F[3]" "Importe" "->,>>>,>>9.99" "decimal" 10 ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.tt-w-report.Campo-F[4]
"tt-w-report.Campo-F[4]" "Saldo" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.tt-w-report.Campo-C[13]
"tt-w-report.Campo-C[13]" "Nro!Unico" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.tt-w-report.Campo-C[9]
"tt-w-report.Campo-C[9]" "Situacion" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.tt-w-report.Campo-C[10]
"tt-w-report.Campo-C[10]" "Ubicacion" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.tt-w-report.Campo-C[12]
"tt-w-report.Campo-C[12]" "Banco" "X(35)" "character" ? ? ? ? ? ? no ? no no "38.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.tt-w-report.Campo-C[11]
"tt-w-report.Campo-C[11]" "Estado" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tt-w-report2"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report2.Campo-C[1]
"tt-w-report2.Campo-C[1]" "Documento" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report2.Campo-F[1]
"tt-w-report2.Campo-F[1]" "Importe Soles" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report2.Campo-F[2]
"tt-w-report2.Campo-F[2]" "Importe Dolares" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "14.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report2.Campo-F[3]
"tt-w-report2.Campo-F[3]" "Total Soles" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "20.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Estados de Cuenta */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Estados de Cuenta */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnExcel W-Win
ON CHOOSE OF BtnExcel IN FRAME F-Main /* Excel */
DO:
  RUN ue-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Consultar */
DO:
  ASSIGN txtCodCli rsReporte txtDesde txtHasta.

  IF rsReporte = 2 THEN DO:
      IF txtDesde > txtHasta THEN DO:
          MESSAGE "Rango de Fechas errados".
          RETURN NO-APPLY.
      END.
  END.

  DEFINE VAR x-cli AS CHAR.

    FILL-IN-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    
    x-cli = txtCodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    
    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                                gn-clie.codcli = x-cli NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE gn-clie THEN DO:
       MESSAGE "Cliente NO EXISTE".
        RETURN NO-APPLY.
    END.

   FILL-IN-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-clie.nomcli.

  EMPTY TEMP-TABLE tt-w-report.
  EMPTY TEMP-TABLE tt-w-report2.

  txtDeuda:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

  IF rsReporte = 1 THEN DO:
      RUN pendientes.
  END.
  ELSE DO:
      RUN liquidaciones.
  END.
  

  {&OPEN-QUERY-BROWSE-3}
  {&OPEN-QUERY-BROWSE-5}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsReporte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsReporte W-Win
ON VALUE-CHANGED OF rsReporte IN FRAME F-Main
DO:

    DEFINE VAR x-tipo AS CHAR.

    x-tipo = rsReporte:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    DO WITH FRAME {&FRAME-NAME} :
        DISABLE txtDesde .
        DISABLE txtHasta.

        IF x-tipo = '2'  THEN DO:
            txtHasta:SCREEN-VALUE = STRING(TODAY,"99/99/9999").
            txtDesde:SCREEN-VALUE = STRING(TODAY - 60,"99/99/9999").

            ENABLE txtDesde.
            ENABLE txtHasta.
        END.
        ELSE DO:
            txtHasta:SCREEN-VALUE = STRING(TODAY,"99/99/9999").
            txtDesde:SCREEN-VALUE = "01/01/2010".
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodCli W-Win
ON LEAVE OF txtCodCli IN FRAME F-Main /* Cliente */
DO:
    DEFINE VAR x-cli AS CHAR.

    FILL-IN-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    x-cli = txtCodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                                gn-clie.codcli = x-cli NO-LOCK NO-ERROR.

    IF AVAILABLE gn-clie THEN DO:
        FILL-IN-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-clie.nomcli.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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
  DISPLAY txtCodCli FILL-IN-2 rsReporte txtDesde txtHasta txtDeuda 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtCodCli FILL-IN-2 BUTTON-1 rsReporte BROWSE-3 BROWSE-5 BtnExcel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE liquidaciones W-Win 
PROCEDURE liquidaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Factor AS INT NO-UNDO.

/**/
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.

EMPTY TEMP-TABLE tt-w-reportX.
EMPTY TEMP-TABLE ttAbonos.

DEFINE VAR x-orden AS DEC INIT 0.
DEFINE VAR x-filer AS DEC INIT 0.
DEFINE VAR x-deuda AS DEC.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH ccbcdocu NO-LOCK USE-INDEX llave06 WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.codcli = txtCodCli
    AND LOOKUP(ccbcdocu.coddoc, x-Cargos) > 0
    AND ccbcdocu.fchdoc >= txtDesde
    AND ccbcdocu.fchdoc <= txtHasta
    AND LOOKUP(ccbcdocu.flgest, 'A,X') = 0 :

    /* Facturas x anticipos no, */
    IF ccbcdocu.coddoc = 'FAC' AND ccbcdocu.tpofac = 'A' THEN NEXT.

    FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND 
                                x-ccbcdocu.codref = ccbcdocu.coddoc AND 
                                x-ccbcdocu.nroref = ccbcdocu.nrodoc AND 
                                x-ccbcdocu.coddoc = 'G/R' NO-LOCK NO-ERROR.

    FIND FIRST Facdocum OF ccbcdocu NO-LOCK NO-ERROR.

    x-Factor = IF(ccbcdocu.coddoc = 'N/C') THEN -1 ELSE  1.
    CREATE tt-w-report.
    ASSIGN
        tt-w-report.Campo-D[1] = ccbcdocu.fchdoc
        tt-w-report.Campo-C[1] = IF(AVAILABLE facdocum) THEN facdocum.nomdoc ELSE ccbcdocu.coddoc
        tt-w-report.Campo-C[2] = ccbcdocu.nrodoc
        tt-w-report.Campo-C[3] = if(AVAILABLE x-ccbcdocu) THEN x-ccbcdocu.coddoc + "-" + x-ccbcdocu.nrodoc 
                                ELSE ccbcdocu.codref + "-" + ccbcdocu.nroref
        tt-w-report.Campo-C[4] = ccbcdocu.fmapgo
        tt-w-report.Campo-C[5] = ccbcdocu.divori
        tt-w-report.Campo-C[6] = ccbcdocu.glosa
        tt-w-report.Campo-C[7] = IF(ccbcdocu.codmon = 2) THEN '$' ELSE 'S/'
        tt-w-report.Campo-D[2] = ccbcdocu.fchvto
        tt-w-report.Campo-F[1] = ccbcdocu.tpocmb
        tt-w-report.Campo-F[2] = ccbcdocu.imptot /** IF(ccbcdocu.codmon = 2) THEN ccbcdocu.tpocmb ELSE 1*/
        tt-w-report.Campo-F[4] = ccbcdocu.sdoact
        tt-w-report.Campo-C[10] = ""
        tt-w-report.Campo-C[9] = ""
        tt-w-report.Campo-F[29] = 0.

        /*  */
        ASSIGN 
            tt-w-report.Campo-C[27] = ccbcdocu.codcli
            tt-w-report.Campo-C[28] = ccbcdocu.coddiv
            tt-w-report.Campo-C[29] = ccbcdocu.coddoc
            tt-w-report.Campo-C[30] = ccbcdocu.nrodoc
            tt-w-report.campo-F[30] = x-orden.

        x-orden = x-orden + 10.

    IF ccbcdocu.coddoc = "LET" THEN DO:
        FIND FIRST cb-ctas WHERE cb-ctas.codcia = 0 AND 
                                    cb-ctas.codcta = ccbcdocu.codcta
                                    NO-LOCK NO-ERROR.
        ASSIGN tt-w-report.Campo-C[10] = fUbicacion( ccbcdocu.flgubi ).
        ASSIGN tt-w-report.Campo-C[9] = fSituacion( ccbcdocu.flgsit ).
        ASSIGN tt-w-report.Campo-C[13] = ccbcdocu.nrosal
                tt-w-report.Campo-C[12] = ccbcdocu.codcta + " " + IF(AVAILABLE cb-ctas) THEN cb-ctas.nomcta ELSE "".
    END.

    txtDeuda:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-deuda,"->>>,>>>,>>9.99").

END.

/* Cancelaciones  */
FOR EACH tt-w-report :
    x-filer = 0.
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = s-codcia AND 
                                ccbdcaja.codref = tt-w-report.Campo-C[29] AND
                                ccbdcaja.nroref = tt-w-report.Campo-C[30] NO-LOCK:


        
        IF x-filer = 0 THEN DO:
            ASSIGN tt-w-report.Campo-D[3] = ccbdcaja.fchdoc
                    tt-w-report.Campo-C[8] = ccbdcaja.coddoc + "-" + ccbdcaja.nrodoc
                    tt-w-report.Campo-F[3] = ccbdcaja.imptot.
        END.
        ELSE DO:
            CREATE tt-w-reportX.
                tt-w-reportX.campo-F[30] = tt-w-report.campo-F[30] + (x-filer / 10).
            ASSIGN tt-w-reportX.Campo-D[3] = ccbdcaja.fchdoc
                    tt-w-reportX.Campo-C[8] = ccbdcaja.coddoc + "-" + ccbdcaja.nrodoc
                    tt-w-reportX.Campo-F[3] = ccbdcaja.imptot.

            /**/
            ASSIGN tt-w-reportX.Campo-C[29] = tt-w-report.Campo-C[29]
                    tt-w-reportX.Campo-C[30] = tt-w-report.Campo-C[30]
                    tt-w-reportX.Campo-F[29] = 0.


        END.
        x-filer = x-filer + 1.
        /*  */
        FIND FIRST ttAbonos WHERE ttAbonos.tcoddoc = ccbdcaja.coddoc AND
                                    ttAbonos.tnrodoc = ccbdcaja.nrodoc NO-ERROR.
        IF NOT AVAILABLE ttAbonos THEN DO:
            CREATE ttAbonos.
                ASSIGN ttAbonos.tcoddoc = ccbdcaja.coddoc
                        ttAbonos.tnrodoc = ccbdcaja.nrodoc.
        END.
        
        /*
        FOR EACH ccbdmov WHERE ccbdmov.codcia = s-codcia AND 
                                ccbdmov.codref = ccbdcaja.coddoc AND 
                                ccbdmov.nroref = ccbdcaja.nrodoc NO-LOCK:
            IF x-filer = 0 THEN DO:
                ASSIGN tt-w-report.Campo-D[3] = ccbdmov.fchdoc
                        tt-w-report.Campo-C[8] = ccbdmov.coddoc + "-" + ccbdmov.nrodoc
                        tt-w-report.Campo-F[3] = ccbdmov.imptot.
            END.
            ELSE DO:
                CREATE tt-w-reportX.
                    tt-w-reportX.campo-F[30] = tt-w-report.campo-F[30] + (x-filer / 10).
                ASSIGN tt-w-reportX.Campo-D[3] = ccbdmov.fchdoc
                        tt-w-reportX.Campo-C[8] = ccbdmov.coddoc + "-" + ccbdcaja.nrodoc
                        tt-w-reportX.Campo-F[3] = ccbdmov.imptot.

                /**/
                ASSIGN tt-w-reportX.Campo-C[29] = tt-w-report.Campo-C[29]
                        tt-w-reportX.Campo-C[30] = tt-w-report.Campo-C[30]
                        tt-w-reportX.Campo-F[29] = 0.


            END.
            x-filer = x-filer + 1.
            /*  */
            FIND FIRST ttAbonos WHERE ttAbonos.tcoddoc = ccbdmov.coddoc AND
                                        ttAbonos.tnrodoc = ccbdmov.nrodoc NO-ERROR.
            IF NOT AVAILABLE ttAbonos THEN DO:
                CREATE ttAbonos.
                    ASSIGN ttAbonos.tcoddoc = ccbdmov.coddoc
                            ttAbonos.tnrodoc = ccbdmov.nrodoc.
            END.
        END.
        IF x-filer = 0 THEN DO:
            ASSIGN tt-w-report.Campo-D[3] = ccbdcaja.fchdoc
                    tt-w-report.Campo-C[8] = ccbdcaja.coddoc + "-" + ccbdcaja.nrodoc
                    tt-w-report.Campo-F[3] = ccbdcaja.imptot.
        END.
        ELSE DO:
            CREATE tt-w-reportX.
                tt-w-reportX.campo-F[30] = tt-w-report.campo-F[30] + (x-filer / 10).
            ASSIGN tt-w-reportX.Campo-D[3] = ccbdcaja.fchdoc
                    tt-w-reportX.Campo-C[8] = ccbdcaja.coddoc + "-" + ccbdcaja.nrodoc
                    tt-w-reportX.Campo-F[3] = ccbdcaja.imptot.

            /**/
            ASSIGN tt-w-reportX.Campo-C[29] = tt-w-report.Campo-C[29]
                    tt-w-reportX.Campo-C[30] = tt-w-report.Campo-C[30]
                    tt-w-reportX.Campo-F[29] = 0.


        END.
        x-filer = x-filer + 1.
        /*  */
        FIND FIRST ttAbonos WHERE ttAbonos.tcoddoc = ccbdcaja.coddoc AND
                                    ttAbonos.tnrodoc = ccbdcaja.nrodoc NO-ERROR.
        IF NOT AVAILABLE ttAbonos THEN DO:
            CREATE ttAbonos.
                ASSIGN ttAbonos.tcoddoc = ccbdcaja.coddoc
                        ttAbonos.tnrodoc = ccbdcaja.nrodoc.
        END.
        */
    END.
END.

/* Aplicaciones */
FOR EACH tt-w-report WHERE tt-w-report.Campo-C[29] = 'N/C' OR tt-w-report.Campo-C[29] = 'A/C' :
    x-filer = 0.
    FOR EACH ccbdmov WHERE ccbdmov.codcia = s-codcia AND 
                            /*ccbdmov.coddiv = tt-w-report.Campo-C[28] AND */
                            ccbdmov.coddoc = tt-w-report.Campo-C[29] AND
                            ccbdmov.nrodoc = tt-w-report.Campo-C[30] NO-LOCK:
        IF x-filer = 0 THEN DO:
            ASSIGN tt-w-report.Campo-D[3] = ccbdmov.fchdoc
                    tt-w-report.Campo-C[8] = ccbdmov.codref + "-" + ccbdmov.nroref
                    tt-w-report.Campo-F[3] = ccbdmov.imptot.
        END.
        ELSE DO:
            CREATE tt-w-reportX.
                tt-w-reportX.campo-F[30] = tt-w-report.campo-F[30] + (x-filer / 10).
            ASSIGN tt-w-reportX.Campo-D[3] = ccbdmov.fchdoc
                    tt-w-reportX.Campo-C[8] = ccbdmov.codref + "-" + ccbdmov.nroref
                    tt-w-reportX.Campo-F[3] = ccbdmov.imptot
                    tt-w-reportX.Campo-F[29] = 0.

        END.
        x-filer = x-filer + 1.
        /*  */
        FIND FIRST ttAbonos WHERE ttAbonos.tcoddoc = ccbdmov.codref AND
                                    ttAbonos.tnrodoc = ccbdmov.nroref NO-ERROR.
        IF NOT AVAILABLE ttAbonos THEN DO:
            CREATE ttAbonos.
                ASSIGN ttAbonos.tcoddoc = ccbdmov.codref
                        ttAbonos.tnrodoc = ccbdmov.nroref.
        END.


        /* Documentos a los que se aplico */
        /*
        FOR EACH ccbccaja WHERE ccbccaja.codcia = s-codcia AND 
                                    ccbccaja.coddoc = ccbdmov.codref AND 
                                    ccbccaja.nrodoc = ccbdmov.nroref NO-LOCK:
            FOR EACH ccbdcaja OF ccbccaja WHERE ccbdcaja.codcli = tt-w-report.Campo-C[27] NO-LOCK:
                IF x-filer = 0 THEN DO:
                    ASSIGN tt-w-report.Campo-D[3] = ccbccaja.fchdoc
                            tt-w-report.Campo-C[8] = ccbdcaja.codref + " - " + ccbdcaja.nroref
                            tt-w-report.Campo-F[3] = ccbdcaja.imptot.
                END.
                ELSE DO:
                    CREATE tt-w-reportX.
                        tt-w-reportX.campo-F[30] = tt-w-report.campo-F[30] + (x-filer / 10).
                    ASSIGN tt-w-reportX.Campo-D[3] = ccbdcaja.fchdoc
                            tt-w-reportX.Campo-C[8] = ccbdcaja.codref + " - " + ccbdcaja.nroref
                            tt-w-reportX.Campo-F[3] = ccbdcaja.imptot.

                END.
                x-filer = x-filer + 1.
            END.
        END.
        */
    END.
END.

FOR EACH tt-w-reportX:
    CREATE tt-w-report.
    BUFFER-COPY tt-w-reportX TO tt-w-report.
END.

/* Canjes CJE */
DEFINE VAR x-dcmnto AS CHAR.
DEFINE VAR x-orden2 AS INT.
DEFINE VAR x-blanco AS LOG.

DEFINE BUFFER xy-tt-w-report FOR tt-w-report.

FOR EACH ttAbonos WHERE ttAbonos.tcoddoc = 'CJE':
    /* */
    x-dcmnto = ttAbonos.tcoddoc + "-" + ttAbonos.tnrodoc.
    x-blanco = NO.
    
    FOR EACH tt-w-report WHERE (/*ttAbonos.tcoddoc = 'CJE' AND */(tt-w-report.Campo-C[8] = x-dcmnto OR 
                                    tt-w-report.Campo-C[3] = x-dcmnto)) .

        x-orden2 = INTEGER(tt-w-report.campo-F[30]).
        FIND FIRST xy-tt-w-report WHERE xy-tt-w-report.campo-F[30] = x-orden2 NO-ERROR.

        /* Marco como leido */
        ASSIGN tt-w-report.campo-F[29] = 1.
       
        CREATE ttEECTA.
            ASSIGN  ttEECTA.tCodDoc = xy-tt-w-report.Campo-C[29]
                    ttEECTA.tNroDoc = xy-tt-w-report.Campo-C[30]
                    ttEECTA.treferencia = xy-tt-w-report.Campo-C[3]
                    ttEECTA.tfchemi = xy-tt-w-report.Campo-D[3]
                    ttEECTA.tfchvcto = xy-tt-w-report.Campo-D[2]
                    ttEECTA.tmone = xy-tt-w-report.Campo-C[7]
                    ttEECTA.tImpCanj = xy-tt-w-report.Campo-F[3]
                    ttEECTA.tImpTot = xy-tt-w-report.Campo-F[2]
                    ttEECTA.tSaldo = xy-tt-w-report.Campo-F[4]
                    ttEECTA.tdocapli = xy-tt-w-report.Campo-C[13]
                    ttEECTA.timpapli = 0
                    ttEECTA.testado = xy-tt-w-report.Campo-C[11]
                    ttEECTA.tSituacion = xy-tt-w-report.Campo-C[9]
                    ttEECTA.tubica = xy-tt-w-report.Campo-C[10]
                    .
        x-blanco = YES.

        IF tt-w-report.Campo-C[8] = x-dcmnto THEN ttEECTA.tImpCanj = tt-w-report.Campo-F[3].
                    
        
    END.

    IF x-blanco = YES THEN CREATE ttEECTA.

END.

/* Aplicaciones A/C y A/R */
FOR EACH ttAbonos WHERE ttAbonos.tcoddoc = 'A/C' OR ttAbonos.tcoddoc = 'A/R' :
    /* */
    x-dcmnto = ttAbonos.tcoddoc + "-" + ttAbonos.tnrodoc.
    x-blanco = NO.

    FOR EACH tt-w-report WHERE (x-dcmnto = tt-w-report.Campo-C[29] + "-" + tt-w-report.Campo-C[30]) OR 
                                (tt-w-report.Campo-C[8] = x-dcmnto ) NO-LOCK.
       
        CREATE ttEECTA.
            ASSIGN  ttEECTA.tCodDoc = tt-w-report.Campo-C[29]
                    ttEECTA.tNroDoc = tt-w-report.Campo-C[30]
                    ttEECTA.treferencia = tt-w-report.Campo-C[3]
                    ttEECTA.tfchemi = tt-w-report.Campo-D[3]
                    ttEECTA.tfchvcto = tt-w-report.Campo-D[2]
                    ttEECTA.tmone = tt-w-report.Campo-C[7]
                    ttEECTA.tImpCanj = tt-w-report.Campo-F[3]
                    ttEECTA.tImpTot = tt-w-report.Campo-F[2]
                    ttEECTA.tSaldo = tt-w-report.Campo-F[4]
                    ttEECTA.tdocapli = tt-w-report.Campo-C[13]
                    ttEECTA.timpapli = 0
                    ttEECTA.testado = tt-w-report.Campo-C[11]
                    ttEECTA.tSituacion = tt-w-report.Campo-C[9]
                    ttEECTA.tubica = tt-w-report.Campo-C[10]
                    .
        x-blanco = YES.
    
        IF tt-w-report.Campo-C[8] = x-dcmnto THEN ttEECTA.tImpCanj = tt-w-report.Campo-F[3].                           
    END.

    IF x-blanco = YES THEN CREATE ttEECTA.

END.

 x-blanco = NO.
/**/
FOR EACH tt-w-report WHERE tt-w-report.campo-F[29] = 0 AND LOOKUP(tt-w-report.Campo-C[29],"FAC,BOL,LET,A/C") > 0.

    IF x-blanco = NO THEN CREATE ttEECTA.
   
    CREATE ttEECTA.
        ASSIGN  ttEECTA.tCodDoc = tt-w-report.Campo-C[29]
                ttEECTA.tNroDoc = tt-w-report.Campo-C[30]
                ttEECTA.treferencia = tt-w-report.Campo-C[3]
                ttEECTA.tfchemi = tt-w-report.Campo-D[3]
                ttEECTA.tfchvcto = tt-w-report.Campo-D[2]
                ttEECTA.tmone = tt-w-report.Campo-C[7]
                ttEECTA.tImpCanj = tt-w-report.Campo-F[3]
                ttEECTA.tImpTot = tt-w-report.Campo-F[2]
                ttEECTA.tSaldo = tt-w-report.Campo-F[4]
                ttEECTA.tdocapli = tt-w-report.Campo-C[13]
                ttEECTA.timpapli = 0
                ttEECTA.testado = tt-w-report.Campo-C[11]
                ttEECTA.tSituacion = tt-w-report.Campo-C[9]
                ttEECTA.tubica = tt-w-report.Campo-C[10]
                .
         x-blanco = YES.
END.


DEFINE VAR x-docs AS CHAR INIT "".
DEFINE VAR x-impdocs AS DEC INIT 0.

/* Aplicaciones */
FOR EACH ttEECTA :
    x-docs = "".
    x-impdocs = 0.
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = s-codcia AND
                            ccbdcaja.codref = ttEECTA.tcoddoc AND
                            ccbdcaja.nroref = ttEECTA.tnrodoc NO-LOCK:
        IF ccbdcaja.coddoc = 'N/B' THEN x-docs = ccbdcaja.coddoc + "-" + ccbdcaja.nrodoc.
        IF ccbdcaja.coddoc = 'N/B' THEN x-impdocs = ccbdcaja.imptot.
        FOR EACH ccbdmov WHERE ccbdmov.codcia = s-codcia AND 
                                ccbdmov.codref = ccbdcaja.coddoc AND
                                ccbdmov.nroref = ccbdcaja.nrodoc NO-LOCK:
            IF x-docs <> "" THEN x-docs = x-docs + ",".
            x-docs = x-docs + ccbdmov.coddoc + "-" + ccbdmov.nrodoc.
            x-impdocs = x-impdocs + ccbdmov.imptot.
        END.
    END.
    IF x-docs <> "" THEN ttEECTA.tdocapli = x-docs.
    IF x-docs <> "" THEN ttEECTA.timpapli = x-impdocs.
    /*ASSIGN ttEECTA.timpapli = x-impdocs.*/
END.

SESSION:SET-WAIT-STATE('').


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
  /*txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 60,"99/99/9999").*/
  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "01/01/2010".
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available W-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .


  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pendientes W-Win 
PROCEDURE pendientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Factor AS INT NO-UNDO.

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.

DEFINE VAR x-deuda AS DEC.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH ccbcdocu NO-LOCK USE-INDEX llave06 WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.codcli = txtCodCli
    AND LOOKUP(ccbcdocu.coddoc, x-Cargos) > 0
    AND ccbcdocu.fchdoc >= 01/01/2010
    AND ccbcdocu.fchdoc <= txtHasta
    AND LOOKUP(ccbcdocu.flgest, 'A,X') = 0
    AND ccbcdocu.sdoact > 0:

    IF ccbcdocu.flgest = "C" AND ccbcdocu.fchcan < txtHasta THEN NEXT.

    FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND 
                                x-ccbcdocu.codref = ccbcdocu.coddoc AND 
                                x-ccbcdocu.nroref = ccbcdocu.nrodoc AND 
                                x-ccbcdocu.coddoc = 'G/R' NO-LOCK NO-ERROR.

    FIND FIRST Facdocum OF ccbcdocu NO-LOCK NO-ERROR.

    x-Factor = IF(ccbcdocu.coddoc = 'N/C') THEN -1 ELSE  1.
    CREATE tt-w-report.
    ASSIGN
        tt-w-report.Campo-D[1] = ccbcdocu.fchdoc
        tt-w-report.Campo-C[1] = IF(AVAILABLE facdocum) THEN facdocum.nomdoc ELSE ccbcdocu.coddoc
        tt-w-report.Campo-C[2] = ccbcdocu.nrodoc
        tt-w-report.Campo-C[3] = if(AVAILABLE x-ccbcdocu) THEN x-ccbcdocu.coddoc + "-" + x-ccbcdocu.nrodoc 
                                ELSE ccbcdocu.codref + "-" + ccbcdocu.nroref
        tt-w-report.Campo-C[4] = ccbcdocu.fmapgo
        tt-w-report.Campo-C[5] = ccbcdocu.divori
        tt-w-report.Campo-C[6] = ccbcdocu.glosa
        tt-w-report.Campo-C[7] = IF(ccbcdocu.codmon = 2) THEN '$' ELSE 'S/'
        tt-w-report.Campo-D[2] = ccbcdocu.fchvto
        tt-w-report.Campo-F[1] = ccbcdocu.tpocmb
        tt-w-report.Campo-F[2] = ccbcdocu.imptot /** IF(ccbcdocu.codmon = 2) THEN ccbcdocu.tpocmb ELSE 1*/
        tt-w-report.Campo-F[4] = ccbcdocu.sdoact
        tt-w-report.Campo-C[10] = ""
        tt-w-report.Campo-C[9] = "".

    IF ccbcdocu.coddoc = "LET" THEN DO:
        FIND FIRST cb-ctas WHERE cb-ctas.codcia = 0 AND 
                                    cb-ctas.codcta = ccbcdocu.codcta
                                    NO-LOCK NO-ERROR.
        ASSIGN tt-w-report.Campo-C[10] = fUbicacion( ccbcdocu.flgubi ).
        ASSIGN tt-w-report.Campo-C[9] = fSituacion( ccbcdocu.flgsit ).
        ASSIGN tt-w-report.Campo-C[13] = ccbcdocu.nrosal
                tt-w-report.Campo-C[12] = ccbcdocu.codcta + " " + IF(AVAILABLE cb-ctas) THEN cb-ctas.nomcta ELSE "".
    END.

      
    FIND FIRST tt-w-report2 WHERE tt-w-report2.campo-c[1] = tt-w-report.Campo-C[1] NO-ERROR.
    IF NOT AVAILABLE tt-w-report2 THEN DO:
        CREATE tt-w-report2.
            ASSIGN tt-w-report2.campo-c[1] = tt-w-report.Campo-C[1]
                    tt-w-report2.Campo-F[1] = 0
                    tt-w-report2.Campo-F[2] = 0
                    tt-w-report2.Campo-F[3] = 0.
    END.
    IF ccbcdocu.codmon = 2 THEN DO:
        ASSIGN tt-w-report2.Campo-F[2] = tt-w-report2.Campo-F[2] + ccbcdocu.sdoact
                tt-w-report2.Campo-F[3] = tt-w-report2.Campo-F[3] + (ccbcdocu.sdoact * ccbcdocu.tpocmb).
            x-deuda = x-deuda + ((ccbcdocu.sdoact * ccbcdocu.tpocmb) * x-factor).
    END.
    ELSE DO:
        ASSIGN tt-w-report2.Campo-F[1] = tt-w-report2.Campo-F[1] + ccbcdocu.sdoact
                tt-w-report2.Campo-F[3] = tt-w-report2.Campo-F[3] + ccbcdocu.sdoact.
        x-deuda = x-deuda + (ccbcdocu.sdoact * x-factor).
    END.

    txtDeuda:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-deuda,"->>>,>>>,>>9.99").

    /*
    ASSIGN 
        w-report.Campo-F[1] = ccbcdocu.imptot * x-Factor
        w-report.Campo-F[2] = ccbcdocu.imptot * x-Factor.
    /* Actualizamos los saldos a una fecha */
    FOR EACH ccbdcaja NO-LOCK WHERE ccbdcaja.codcia = s-codcia
        AND ccbdcaja.codref = w-report.Campo-C[3]
        AND ccbdcaja.nroref = w-report.Campo-C[4]
        AND ccbdcaja.fchdoc <= txtHasta
        BY ccbdcaja.fchdoc:
        w-report.Campo-F[2] = w-report.Campo-F[2] - ccbdcaja.imptot.
        w-report.Campo-D[3] = ccbdcaja.fchdoc.
        /* CASO MUY ESPECIAL */
        IF ccbdcaja.coddoc = "A/C" AND ccbdcaja.nrodoc BEGINS "*" THEN DO:
            w-report.Campo-F[2] = w-report.Campo-F[2] - (ccbdcaja.imptot * x-Factor).
        END.
    END.
    IF w-report.Campo-F[2] <= 0 /*AND w-report.Campo-D[3] < pFechaD*/ THEN DELETE w-report.
    */
END.

SESSION:SET-WAIT-STATE('').

/* ************************************************************************ */
/* ************* 2ro Los Movimientos al Haber (Abonos) ******************** */
/* ************************************************************************ */

/*
FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.codcli = pCodCli
    AND LOOKUP(ccbcdocu.coddoc, x-Abonos) > 0
    AND ccbcdocu.fchdoc >= 01/01/2010
    AND ccbcdocu.fchdoc <= pFechaH
    AND LOOKUP(ccbcdocu.flgest, 'A,X') = 0:
    IF ccbcdocu.flgest = "C" AND ccbcdocu.fchcan < pFechaD THEN NEXT.
    x-Factor = -1.
    CREATE w-report.
    ASSIGN
        w-report.Task-No = pTask-No
        w-report.Llave-C = pLLave-C
        w-report.Campo-C[1] = "Haber"
        w-report.Campo-C[2] = ccbcdocu.coddiv
        w-report.Campo-C[3] = ccbcdocu.coddoc
        w-report.Campo-C[4] = ccbcdocu.nrodoc
        w-report.Campo-D[1] = ccbcdocu.fchdoc
        w-report.Campo-D[2] = ccbcdocu.fchvto
        w-report.Campo-I[1] = ccbcdocu.codmon.
    ASSIGN 
        w-report.Campo-F[1] = ccbcdocu.imptot * x-Factor
        w-report.Campo-F[2] = ccbcdocu.imptot * x-Factor.
    FOR EACH CCBDMOV NO-LOCK WHERE CCBDMOV.CodCia = s-CodCia
        AND CCBDMOV.CodDoc = w-report.Campo-C[3]
        AND CCBDMOV.NroDoc = w-report.Campo-C[4] 
        AND CCBDMOV.FchMov <= pFechaH
        BY CCBDMOV.FchMov:
        w-report.Campo-F[2] = w-report.Campo-F[2] - (ccbdmov.imptot * x-Factor).
        w-report.Campo-D[3] = CCBDMOV.FchMov.
    END.
    IF w-report.Campo-F[2] >= 0 /*AND w-report.Campo-D[3] < pFechaD*/ THEN DELETE w-report.
END.
*/

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
  {src/adm/template/snd-list.i "tt-w-report2"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel W-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-archivo AS CHAR.                       
DEFINE VAR rpta AS LOG.
                       
SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = x-Archivo.

run pi-crea-archivo-csv IN hProc (input  buffer ttEECTA:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttEECTA:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSituacion W-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( INPUT cFlgSit AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE cflgsit:
    WHEN 'T' THEN RETURN 'Transito'.
    WHEN 'C' THEN RETURN 'Cobranza Libre'.
    WHEN 'G' THEN RETURN 'Cobranza Garantia'.
    WHEN 'D' THEN RETURN 'Descuento'.
    WHEN 'P' THEN RETURN 'Protestada'.
  END CASE.
  RETURN cflgsit.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fUbicacion W-Win 
FUNCTION fUbicacion RETURNS CHARACTER
  ( INPUT cFlgUbi AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE cflgubi:
    WHEN 'C' THEN RETURN 'Cartera'.
    WHEN 'B' THEN RETURN 'Banco'.
  END CASE.
  RETURN cflgubi.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

