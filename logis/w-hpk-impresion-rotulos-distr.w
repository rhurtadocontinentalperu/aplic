&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ChkTareas NO-UNDO LIKE ChkTareas
       field tcoddoc as char
       field tnrodoc as char
       field tnro-phr as char
       field tcliente as char
       field tsku as int
       field tbultos as int
       field tcrossdocking as char
       field tchequeador as char.
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-codalm AS CHAR.

DEFINE VAR x-cantidad-sku-col AS INT.
DEFINE VAR x-cantidad-bultos-col AS INT.
DEFINE VAR x-tiempo-observado-col AS CHAR.
DEFINE VAR x-nom-chequeador-col AS CHAR.
DEFINE VAR x-cliente-col AS CHAR.
DEFINE VAR x-es-crossdocking-col AS CHAR.

DEFINE VAR x-codped AS CHAR.
DEFINE VAR x-nroped AS CHAR.

DEFINE TEMP-TABLE ttOrdenes
    FIELDS  tcoddoc     AS  CHAR    FORMAT  'x(5)'
    FIELDS  tnrodoc     AS  CHAR    FORMAT  'x(15)'
    FIELDS  tcoddiv     AS  CHAR    FORMAT  'x(10)'
.

DEFINE TEMP-TABLE rr-w-report LIKE w-report.

DEF STREAM REPORTE.

DEFINE VAR s-task-no AS INT.
DEF VAR cCodEAN AS CHARACTER.
DEF VAR iInt AS INT NO-UNDO.

DEFINE VAR x-phr-esta-cerrada AS LOG.

DEFINE VAR x-col-codorden AS CHAR.
DEFINE VAR x-col-nroorden AS CHAR.
DEFINE VAR x-col-nro-phr AS CHAR.
DEFINE VAR x-col-bultos AS INT INIT 0.
DEFINE VAR x-col-chequeador AS CHAR INIT "".

DEFINE BUFFER x-ControlOD FOR ControlOD.
DEFINE BUFFER x-vtaddocu FOR vtaddocu.
DEFINE BUFFER x-vtacdocu FOR vtacdocu.
DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER x-facdpedi FOR facdpedi.
DEFINE BUFFER x-chkcontrol FOR ChkCOntrol.
DEFINE BUFFER x-almddocu FOR almddocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-14

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ChkTareas VtaCDocu tt-ChkTareas tt-w-report

/* Definitions for BROWSE BROWSE-14                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-14 ChkTareas.CodDoc ChkTareas.NroPed ~
tt-chktareas.tnro-phr @ x-col-nro-phr tt-chktareas.tcoddoc @ x-col-codorden ~
tt-chkTareas.tnrodoc @  x-col-nroorden ~
tt-ChkTareas.tcliente @ x-cliente-col tt-chktareas.tbultos @ x-col-bultos ~
tt-chktareas.tcrossdocking @ x-es-crossdocking-col ChkTareas.Embalaje ~
ChkTareas.Mesa tt-chktareas.tchequeador @ x-col-chequeador ~
tiempo-observado(chktareas.fechafin, chktareas.horafin) @ x-tiempo-observado-col 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-14 
&Scoped-define QUERY-STRING-BROWSE-14 FOR EACH ChkTareas ~
      WHERE ChkTareas.codcia = s-codcia and ~
(fill-in-hpk = "" or chktareas.nroped = fill-in-hpk) and  ~
(ChkTareas.fechafin >= fill-in-desde and ChkTareas.fechafin <= fill-in-hasta) and ~
(ChkTareas.FlgEst = 'T' or ChkTareas.FlgEst = 'C') NO-LOCK, ~
      FIRST VtaCDocu WHERE VtaCDocu.CodCia =  ChkTareas.CodCia AND ~
 VtaCDocu.CodPed  = ChkTareas.CodDoc   AND ~
 VtaCDocu.NroPed =  ChkTareas.NroPed ~
      AND (fill-in-codtrab = "" or entry(1,vtacdocu.libre_c04,"|") = fill-in-codtrab) NO-LOCK, ~
      FIRST tt-ChkTareas WHERE tt-ChkTareas.CodCia  =  ChkTareas.CodCia  ~
  AND  tt-ChkTareas.CodDoc  = ChkTareas.CodDoc ~
  AND  tt-ChkTareas.NroPed = ChkTareas.NroPed OUTER-JOIN NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-14 OPEN QUERY BROWSE-14 FOR EACH ChkTareas ~
      WHERE ChkTareas.codcia = s-codcia and ~
(fill-in-hpk = "" or chktareas.nroped = fill-in-hpk) and  ~
(ChkTareas.fechafin >= fill-in-desde and ChkTareas.fechafin <= fill-in-hasta) and ~
(ChkTareas.FlgEst = 'T' or ChkTareas.FlgEst = 'C') NO-LOCK, ~
      FIRST VtaCDocu WHERE VtaCDocu.CodCia =  ChkTareas.CodCia AND ~
 VtaCDocu.CodPed  = ChkTareas.CodDoc   AND ~
 VtaCDocu.NroPed =  ChkTareas.NroPed ~
      AND (fill-in-codtrab = "" or entry(1,vtacdocu.libre_c04,"|") = fill-in-codtrab) NO-LOCK, ~
      FIRST tt-ChkTareas WHERE tt-ChkTareas.CodCia  =  ChkTareas.CodCia  ~
  AND  tt-ChkTareas.CodDoc  = ChkTareas.CodDoc ~
  AND  tt-ChkTareas.NroPed = ChkTareas.NroPed OUTER-JOIN NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-14 ChkTareas VtaCDocu tt-ChkTareas
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-14 ChkTareas
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-14 VtaCDocu
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-14 tt-ChkTareas


/* Definitions for BROWSE BROWSE-16                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-16 tt-w-report.Campo-L[1] ~
tt-w-report.Campo-C[1] tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] ~
tt-w-report.Campo-C[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-16 tt-w-report.Campo-L[1] 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-16 tt-w-report
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-16 tt-w-report
&Scoped-define QUERY-STRING-BROWSE-16 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-16 OPEN QUERY BROWSE-16 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-16 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-16 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-14}~
    ~{&OPEN-QUERY-BROWSE-16}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-14 FILL-IN-codtrab FILL-IN-copias ~
BUTTON-6 BUTTON-5 FILL-IN-desde FILL-IN-hasta BUTTON-1 BUTTON-2 BUTTON-3 ~
BROWSE-16 FILL-IN-phr FILL-IN-hpk 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codtrab FILL-IN-copias ~
FILL-IN-desde FILL-IN-hasta FILL-IN-phr FILL-IN-hpk 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cantidad-bultos W-Win 
FUNCTION cantidad-bultos RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cantidad-sku W-Win 
FUNCTION cantidad-sku RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNrodoc AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD chequeador W-Win 
FUNCTION chequeador RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cliente W-Win 
FUNCTION cliente RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDOc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD es-crossdocking W-Win 
FUNCTION es-crossdocking RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso-orden W-Win 
FUNCTION fPeso-orden RETURNS DECIMAL
  ( INPUT pCodOrden AS CHAR, INPUT pNroOrden AS CHAR, INPUT pCodHPK AS CHAR, INPUT pNroPHK AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-datos-adicionales W-Win 
FUNCTION get-datos-adicionales RETURNS CHARACTER
  ( INPUT pCodDOc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tiempo-observado W-Win 
FUNCTION tiempo-observado RETURNS CHARACTER
  ( INPUT pFecha AS DATE, INPUT pHora AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Marcar todos" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Desmarcar todo" 
     SIZE 16 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "Refrescar" 
     SIZE 12.72 BY .96.

DEFINE BUTTON BUTTON-4 
     LABEL "Imprimir Rotulos en la ZEBRA" 
     SIZE 31 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "Imprimir Rotulo MASTER" 
     SIZE 27.43 BY 1.12.

DEFINE BUTTON BUTTON-6 
     LABEL "Packing List" 
     SIZE 20.29 BY 1.12.

DEFINE VARIABLE FILL-IN-codtrab AS CHARACTER FORMAT "x(6)":U 
     LABEL "Cod.Trab" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-copias AS INTEGER FORMAT ">>9":U INITIAL 1 
     LABEL "Copias" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .77
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-hpk AS CHARACTER FORMAT "X(12)":U 
     LABEL "HPK" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-phr AS CHARACTER FORMAT "X(12)":U 
     LABEL "PHR" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-14 FOR 
      ChkTareas, 
      VtaCDocu, 
      tt-ChkTareas SCROLLING.

DEFINE QUERY BROWSE-16 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-14 W-Win _STRUCTURED
  QUERY BROWSE-14 NO-LOCK DISPLAY
      ChkTareas.CodDoc COLUMN-LABEL "Cod." FORMAT "x(3)":U WIDTH 3.43
            LABEL-FONT 0
      ChkTareas.NroPed COLUMN-LABEL "Nro.Orden" FORMAT "X(12)":U
            WIDTH 10.43 LABEL-FONT 0
      tt-chktareas.tnro-phr @ x-col-nro-phr COLUMN-LABEL "Nro. PHR." FORMAT "x(15)":U
            WIDTH 9.43 COLUMN-BGCOLOR 11
      tt-chktareas.tcoddoc @ x-col-codorden COLUMN-LABEL "Cod.Doc"
      tt-chkTareas.tnrodoc @  x-col-nroorden COLUMN-LABEL "Orden" FORMAT "x(12)":U
      tt-ChkTareas.tcliente @ x-cliente-col COLUMN-LABEL "Nombre Cliente" FORMAT "x(50)":U
            WIDTH 39.43
      tt-chktareas.tbultos @ x-col-bultos COLUMN-LABEL "Bultos"
            WIDTH 6.43
      tt-chktareas.tcrossdocking @ x-es-crossdocking-col COLUMN-LABEL "CrossDocking" FORMAT "x(5)":U
      ChkTareas.Embalaje COLUMN-LABEL "Embalado" FORMAT "SI/NO":U
            WIDTH 9.57
      ChkTareas.Mesa FORMAT "x(8)":U WIDTH 9.29
      tt-chktareas.tchequeador @ x-col-chequeador COLUMN-LABEL "Chequeador" FORMAT "x(40)":U
            WIDTH 20
      tiempo-observado(chktareas.fechafin, chktareas.horafin) @ x-tiempo-observado-col COLUMN-LABEL "Hora Terminado" FORMAT "x(25)":U
            WIDTH 16.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 146 BY 13.35
         FONT 4
         TITLE "Bandeja de ordenes terminadas - Impresion de Rotulos" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-16 W-Win _STRUCTURED
  QUERY BROWSE-16 NO-LOCK DISPLAY
      tt-w-report.Campo-L[1] COLUMN-LABEL "" FORMAT "Si/No":U WIDTH 4.43
            COLUMN-FONT 0 VIEW-AS TOGGLE-BOX
      tt-w-report.Campo-C[1] COLUMN-LABEL "Cod." FORMAT "X(4)":U
            WIDTH 5 COLUMN-FONT 0
      tt-w-report.Campo-C[2] COLUMN-LABEL "Orden" FORMAT "X(11)":U
            COLUMN-FONT 0
      tt-w-report.Campo-C[3] COLUMN-LABEL "Cod.Bulto" FORMAT "X(20)":U
            WIDTH 22.86 COLUMN-FONT 0
      tt-w-report.Campo-C[4] COLUMN-LABEL "Cliente" FORMAT "X(50)":U
            WIDTH 43.14
  ENABLE
      tt-w-report.Campo-L[1]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 92 BY 10.23
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-14 AT ROW 2.15 COL 2 WIDGET-ID 200
     FILL-IN-codtrab AT ROW 1.12 COL 11.29 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-copias AT ROW 22.58 COL 129.86 COLON-ALIGNED WIDGET-ID 28
     BUTTON-6 AT ROW 15.65 COL 126.72 WIDGET-ID 26
     BUTTON-5 AT ROW 22.54 COL 96 WIDGET-ID 24
     BUTTON-4 AT ROW 24.08 COL 96 WIDGET-ID 20
     FILL-IN-desde AT ROW 1.08 COL 101 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-hasta AT ROW 1.08 COL 121 COLON-ALIGNED WIDGET-ID 14
     BUTTON-1 AT ROW 17.15 COL 96 WIDGET-ID 8
     BUTTON-2 AT ROW 18.58 COL 96 WIDGET-ID 10
     BUTTON-3 AT ROW 1.08 COL 136 WIDGET-ID 16
     BROWSE-16 AT ROW 15.58 COL 2 WIDGET-ID 300
     FILL-IN-phr AT ROW 1.15 COL 33 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-hpk AT ROW 1.15 COL 54 COLON-ALIGNED WIDGET-ID 34
     "Considera documentos HPK" VIEW-AS TEXT
          SIZE 36 BY .96 AT ROW 20.42 COL 111 WIDGET-ID 6
          BGCOLOR 15 FGCOLOR 4 FONT 9
     "Ordenes terminadas" VIEW-AS TEXT
          SIZE 20.57 BY .62 AT ROW 1.31 COL 74 WIDGET-ID 18
          FGCOLOR 9 FONT 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 149.14 BY 24.92
         FONT 0 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ChkTareas T "?" NO-UNDO INTEGRAL ChkTareas
      ADDITIONAL-FIELDS:
          field tcoddoc as char
          field tnrodoc as char
          field tnro-phr as char
          field tcliente as char
          field tsku as int
          field tbultos as int
          field tcrossdocking as char
          field tchequeador as char
      END-FIELDS.
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Gestion de Ordenes terminadas - Impresion de Rotulos"
         HEIGHT             = 25.15
         WIDTH              = 150.14
         MAX-HEIGHT         = 27.04
         MAX-WIDTH          = 173.86
         VIRTUAL-HEIGHT     = 27.04
         VIRTUAL-WIDTH      = 173.86
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-14 1 F-Main */
/* BROWSE-TAB BROWSE-16 BUTTON-3 F-Main */
/* SETTINGS FOR BUTTON BUTTON-4 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-4:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-14
/* Query rebuild information for BROWSE BROWSE-14
     _TblList          = "INTEGRAL.ChkTareas,INTEGRAL.VtaCDocu WHERE INTEGRAL.ChkTareas ...,Temp-Tables.tt-ChkTareas WHERE INTEGRAL.ChkTareas ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST, FIRST OUTER"
     _Where[1]         = "ChkTareas.codcia = s-codcia and
(fill-in-hpk = """" or chktareas.nroped = fill-in-hpk) and 
(ChkTareas.fechafin >= fill-in-desde and ChkTareas.fechafin <= fill-in-hasta) and
(ChkTareas.FlgEst = 'T' or ChkTareas.FlgEst = 'C')"
     _JoinCode[2]      = "INTEGRAL.VtaCDocu.CodCia =  ChkTareas.CodCia AND
 INTEGRAL.VtaCDocu.CodPed  = ChkTareas.CodDoc   AND
 INTEGRAL.VtaCDocu.NroPed =  ChkTareas.NroPed"
     _Where[2]         = "(fill-in-codtrab = """" or entry(1,vtacdocu.libre_c04,""|"") = fill-in-codtrab)"
     _JoinCode[3]      = "Temp-Tables.tt-ChkTareas.CodCia  =  INTEGRAL.ChkTareas.CodCia 
  AND  Temp-Tables.tt-ChkTareas.CodDoc  = INTEGRAL.ChkTareas.CodDoc
  AND  Temp-Tables.tt-ChkTareas.NroPed = INTEGRAL.ChkTareas.NroPed"
     _FldNameList[1]   > INTEGRAL.ChkTareas.CodDoc
"ChkTareas.CodDoc" "Cod." ? "character" ? ? ? ? ? 0 no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.ChkTareas.NroPed
"ChkTareas.NroPed" "Nro.Orden" ? "character" ? ? ? ? ? 0 no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"tt-chktareas.tnro-phr @ x-col-nro-phr" "Nro. PHR." "x(15)" ? 11 ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"tt-chktareas.tcoddoc @ x-col-codorden" "Cod.Doc" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"tt-chkTareas.tnrodoc @  x-col-nroorden" "Orden" "x(12)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"tt-ChkTareas.tcliente @ x-cliente-col" "Nombre Cliente" "x(50)" ? ? ? ? ? ? ? no ? no no "39.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"tt-chktareas.tbultos @ x-col-bultos" "Bultos" ? ? ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"tt-chktareas.tcrossdocking @ x-es-crossdocking-col" "CrossDocking" "x(5)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.ChkTareas.Embalaje
"ChkTareas.Embalaje" "Embalado" ? "logical" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.ChkTareas.Mesa
"ChkTareas.Mesa" ? ? "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"tt-chktareas.tchequeador @ x-col-chequeador" "Chequeador" "x(40)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"tiempo-observado(chktareas.fechafin, chktareas.horafin) @ x-tiempo-observado-col" "Hora Terminado" "x(25)" ? ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-14 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-16
/* Query rebuild information for BROWSE BROWSE-16
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-L[1]
"tt-w-report.Campo-L[1]" "" ? "logical" ? ? 0 ? ? ? yes ? no no "4.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Cod." "X(4)" "character" ? ? 0 ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Orden" "X(11)" "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Cod.Bulto" "X(20)" "character" ? ? 0 ? ? ? no ? no no "22.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Cliente" "X(50)" "character" ? ? ? ? ? ? no ? no no "43.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-16 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Gestion de Ordenes terminadas - Impresion de Rotulos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Gestion de Ordenes terminadas - Impresion de Rotulos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-14
&Scoped-define SELF-NAME BROWSE-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 W-Win
ON ENTRY OF BROWSE-14 IN FRAME F-Main /* Bandeja de ordenes terminadas - Impresion de Rotulos */
DO:
    x-codped = "".
    x-nroped = "".
    /*browse-15:TITLE = "".*/
    IF AVAILABLE chktareas THEN DO:
          x-codped = chktareas.coddoc.
          x-nroped = chktareas.nroped.          
    END.

    RUN rotulos-de-las-ordenes(INPUT x-codped, INPUT x-nroped).

    {&open-query-browse-16}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-14 IN FRAME F-Main /* Bandeja de ordenes terminadas - Impresion de Rotulos */
DO:
    /*
  IF AVAILABLE chktareas THEN DO:
        MESSAGE "Pasar La Orden " + chktareas.coddoc + " " + chktareas.nroped  + " a Distribucion ?" VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
    
    RUN terminar-orden.

  END.
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 W-Win
ON VALUE-CHANGED OF BROWSE-14 IN FRAME F-Main /* Bandeja de ordenes terminadas - Impresion de Rotulos */
DO:
  x-codped = "".
  x-nroped = "".

  IF AVAILABLE chktareas THEN DO:
        x-codped = chktareas.coddoc.
        x-nroped = chktareas.nroped.
  END.
  
  RUN rotulos-de-las-ordenes(INPUT x-codped, INPUT x-nroped).

  {&open-query-browse-16}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Marcar todos */
DO:
  FOR EACH tt-w-report :
      ASSIGN tt-w-report.campo-l[1] = YES.
  END.

  {&open-query-browse-16}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Desmarcar todo */
DO:
    FOR EACH tt-w-report :
        ASSIGN tt-w-report.campo-l[1] = NO.
    END.
  
    {&open-query-browse-16}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Refrescar */
DO:

    ASSIGN fill-in-codtrab fill-in-phr fill-in-hpk.

  RUN refrescar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Imprimir Rotulos en la ZEBRA */
DO:

  RUN carga-info-rotulo.
  RUN imprime-rotulo-zebra.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Imprimir Rotulo MASTER */
DO:
  RUN imprime-rotulo-master.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Packing List */
DO:
  IF AVAILABLE chktareas THEN DO:
      RUN packing-list(INPUT chktareas.coddoc, INPUT chktareas.nroped).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON ROW-DISPLAY OF browse-14
DO:
    
    
END.

/* RETRIEVEEEEEEEE */
ON FIND OF chktareas
DO:

    DEFINE VAR x-nro-phr AS CHAR.

    x-nro-phr = fill-in-phr:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    IF NOT (TRUE <> (x-nro-phr > "")) THEN DO:
        FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                    x-vtacdocu.codped = chktareas.CodDOc AND
                                    x-vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
        IF NOT AVAILABLE x-vtacdocu OR x-vtacdocu.nroori <> x-nro-phr THEN DO:
            RETURN ERROR.
        END.
    END.




    DEFINE VAR x-dni AS CHAR.
    DEFINE VAR x-origen AS CHAR.
    DEFINE VAR x-retval AS CHAR.
    DEFINE VAR x-coddoc-nrodoc AS CHAR.    

    RUN ordenes-involucrados(INPUT chktareas.CodDOc, INPUT chktareas.nroped).

    /*CREATE tt-chktareas.*/
    FIND FIRST tt-chktareas WHERE tt-chktareas.codcia = chktareas.codcia AND
                                    tt-chktareas.coddoc = chktareas.coddoc AND
                                    tt-chktareas.nroped = chktareas.nroped NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-chktareas THEN DO:
        CREATE tt-chktareas.
        BUFFER-COPY chktareas TO tt-chktareas.

        IF chktareas.CodDOc = 'HPK' THEN DO:

            FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                            x-vtacdocu.codped = chktareas.CodDOc AND
                                            x-vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
            IF AVAILABLE x-vtacdocu THEN DO:
                ASSIGN tt-chktareas.tcoddoc = x-vtacdocu.codref
                        tt-chktareas.tnrodoc = x-vtacdocu.nroref
                        tt-chktareas.tnro-phr = x-vtacdocu.nroori.
            END.
        END.

        /* Bultos */    
        x-col-bultos = 0.
        /*
        FOR EACH ttOrdenes :
            FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND
                                        ccbcbult.coddoc = ttOrdenes.tCodDoc AND
                                        ccbcbult.nrodoc = ttOrdenes.tnroDoc NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcbult THEN DO:
                x-col-bultos = x-col-bultos + ccbcbult.bultos.
            END.
        END.
        */
    
        x-coddoc-nrodoc = chktareas.CodDOc + "-" + chktareas.nroped.
    
        FOR EACH ttOrdenes :
            FOR EACH x-ControlOD WHERE x-ControlOD.codcia = s-codcia AND 
                                        x-ControlOD.coddoc = ttOrdenes.tCodDoc AND
                                        x-ControlOD.nrodoc = ttOrdenes.tnroDoc AND
                                        x-controlOD.nroetq BEGINS x-coddoc-nrodoc NO-LOCK:
                x-col-bultos =  x-col-bultos + 1.
                /*
                x-es-valido = YES.
                IF x-es-valido = YES THEN x-retval = x-retval + 1.
                */
            END.
        END.
    
        ASSIGN tt-chktareas.tbultos = x-col-bultos.
    
        /* Chequeador */
        x-col-chequeador = "".
        x-retval = "".
    
        IF chktareas.CodDOc = 'HPK' THEN DO:
            
            FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                            x-vtacdocu.codped = chktareas.CodDOc AND
                                            x-vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
            IF AVAILABLE x-vtacdocu THEN DO:
                IF NOT (TRUE <> (x-vtacdocu.libre_c04 > "")) THEN DO:
                    x-dni = ENTRY(1,x-vtacdocu.libre_c04,"|").
                    RUN logis/p-busca-por-dni.r(INPUT x-dni, OUTPUT x-retval, OUTPUT x-origen).
                END.            
            END.
        END.
        ELSE DO:        
            FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                                            x-faccpedi.coddoc = chktareas.CodDOc AND 
                                            x-faccpedi.nroped = chktareas.nroped NO-LOCK NO-ERROR.
            IF AVAILABLE x-faccpedi THEN DO:
                IF NOT (TRUE <> (x-faccpedi.usrchq > "")) THEN DO:
                    x-dni = x-faccpedi.usrchq.
                    RUN logis/p-busca-por-dni.r(INPUT x-dni, OUTPUT x-retval, OUTPUT x-origen).
                END.            
            END.
        END.
    
        IF x-retval = "" THEN DO:
            /* buscarlo si existe en la maestra de personal */
            FIND FIRST pl-pers WHERE  pl-pers.codper = x-dni NO-LOCK NO-ERROR.
            IF  AVAILABLE pl-pers THEN DO:
                x-retval = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
            END.
        END.
        
        x-col-chequeador = x-retval.
        ASSIGN tt-chktareas.tchequeador = x-col-chequeador.
    
        /* Es CrossDocking */
        x-es-crossdocking-col = "NO".
    
        FIND FIRST x-ChkControl WHERE x-ChkControl.codcia = s-codcia AND 
                                    x-ChkControl.coddiv = s-coddiv AND 
                                    x-ChkControl.coddoc = chktareas.Coddoc AND 
                                    x-ChkControl.nroped = chktareas.nroped NO-LOCK NO-ERROR.
        IF AVAILABLE x-ChkControl THEN DO:
          IF x-ChkControl.crossdocking THEN x-es-crossdocking-col = 'SI'.
        END.
    
         ASSIGN tt-chktareas.tcrossdocking = x-es-crossdocking-col.
    
        /* Cliente */
         x-cliente-col = "".
    
         IF chktareas.CodDoc = 'HPK' THEN DO:
    
             FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                             x-vtacdocu.codped = chktareas.CodDOc AND
                                             x-vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
             IF AVAILABL x-vtacdocu THEN x-cliente-col = x-vtacdocu.nomcli.
         END.
         ELSE DO:
    
    
             FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                         x-faccpedi.coddoc = chktareas.Coddoc AND
                                         x-faccpedi.nroped = chktareas.nroped NO-LOCK NO-ERROR.
             IF AVAILABL x-faccpedi THEN x-cliente-col = x-faccpedi.nomcli.
         END.
    
         ASSIGN tt-chktareas.tcliente = x-cliente-col.
    END.

    RETURN.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-info-rotulo W-Win 
PROCEDURE carga-info-rotulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-coddoc-nrodoc AS CHAR.

IF NOT AVAILABLE chktareas THEN DO:
  RETURN.
END.

x-coddoc-nrodoc = chktareas.coddoc + "-" + chktareas.nroped.

DEFINE VAR dPeso        AS DECIMAL   NO-UNDO.
DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
DEFINE VAR cDir         AS CHARACTER NO-UNDO.
DEFINE VAR cSede        AS CHARACTER NO-UNDO.
DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.

DEFINE VAR lCodRef AS CHAR.
DEFINE VAR lNroRef AS CHAR.
DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.

DEFINE VAR lCodRef2 AS CHAR.
DEFINE VAR lNroRef2 AS CHAR.

DEFINE VAR x-almfinal AS CHAR.
DEFINE VAR x-cliente-final AS CHAR.
DEFINE VAR x-cliente-intermedio AS CHAR.
DEFINE VAR x-direccion-final AS CHAR.
DEFINE VAR x-direccion-intermedio AS CHAR.
DEFINE VAR lFiler1 AS CHAR.

DEFINE BUFFER x-almacen FOR almacen.
DEFINE BUFFER x-pedido FOR faccpedi.
DEFINE BUFFER x-cotizacion FOR faccpedi.
DEFINE BUFFER hpk-vtacdocu FOR vtacdocu.

EMPTY TEMP-TABLE rr-w-report.

DEFINE VAR i-nro AS INT.

DEFINE VAR x-total-bultos-orden AS INT.

SESSION:SET-WAIT-STATE("GENERAL").

/*  */
FIND FIRST hpk-vtacdocu WHERE hpk-vtacdocu.codcia = s-codcia AND
                                    hpk-vtacdocu.codped = chktareas.coddoc AND
                                    hpk-vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.

/* Total bultos  */
/*x-total-bultos-orden = cantidad-bultos(chktareas.coddoc, chktareas.nroped).*/

DEFINE VAR x-es-correcto AS LOG.

FOR EACH tt-w-report WHERE tt-w-report.campo-l[1] = YES 
            BREAK BY tt-w-report.campo-c[1] BY tt-w-report.campo-c[2]:

    IF FIRST-OF(tt-w-report.campo-c[1]) OR FIRST-OF(tt-w-report.campo-c[2]) THEN DO:
        
        x-total-bultos-orden = 0.
        i-nro = 0.
        
        FOR EACH controlOD WHERE controlOD.codcia = s-codcia AND
                                    controlOD.coddoc = tt-w-report.campo-c[1] AND
                                    controlOD.nrodoc = tt-w-report.campo-c[2] NO-LOCK:
            x-es-correcto = YES.
            IF chktareas.coddoc = 'HPK' THEN DO:
                x-es-correcto = NO. 
                IF controlOD.nroetq BEGINS x-coddoc-nrodoc THEN x-es-correcto = YES.
            END.
            IF x-es-correcto = YES THEN x-total-bultos-orden = x-total-bultos-orden + 1.
        END.
        IF x-total-bultos-orden = 0 THEN NEXT.
    END.

    /* Ubico la orden */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddoc = tt-w-report.campo-c[1]
        AND faccpedi.nroped = tt-w-report.campo-c[2]
        NO-LOCK NO-ERROR.

    /*IF NOT AVAILABLE tt-w-report THEN NEXT.*/
    IF NOT AVAILABLE faccpedi THEN NEXT.

    cNomCHq = "".
    lCodDoc = "".
    lNroDoc = "".
    dPeso = 0.      /**ControlOD.PesArt.*/
    lCodRef2 = tt-w-report.campo-c[1].
    lNroRef2 = tt-w-report.campo-c[2].

    x-cliente-final = faccpedi.nomcli.
    x-direccion-final = faccpedi.dircli.
    x-cliente-intermedio = "".
    x-direccion-intermedio = "".

    /* CrossDocking almacen FINAL */
    x-almfinal = "".
    IF faccpedi.crossdocking = YES THEN DO:
        lCodRef2 = faccpedi.codref.
        lNroRef2 = faccpedi.nroref.
        lCodDoc = "(" + faccpedi.coddoc.
        lNroDoc = faccpedi.nroped + ")".

        x-cliente-intermedio = faccpedi.codcli + " " + faccpedi.nomcli.
        x-direccion-intermedio = faccpedi.dircli.

        IF faccpedi.codref = 'R/A' THEN DO:
            FIND FIRST x-almacen WHERE x-almacen.codcia = s-codcia AND 
                                        x-almacen.codalm = faccpedi.almacenxD
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE x-almacen THEN x-cliente-final = TRIM(x-almacen.descripcion).
            IF AVAILABLE x-almacen THEN x-direccion-final = TRIM(x-almacen.diralm).
        END.
    END.

    /* Ic - 02Dic2016, si es OTR verificar si no proviene de una PED (pedido) */
    /* Si viene de un PED, los datos del cliente deben salir del PEDIDO */
    /* Crossdocking */
    IF faccpedi.coddoc = 'OTR' AND faccpedi.codref = 'PED' THEN DO:
        lCodDoc = "(" + tt-w-report.campo-c[1].
        lNroDoc = tt-w-report.campo-c[2] + ")".
        lCodRef = faccpedi.codref.
        lNroRef = faccpedi.nroref.
        RELEASE faccpedi.

        FIND faccpedi WHERE faccpedi.codcia = s-codcia
            AND faccpedi.coddoc = lCodRef
            AND faccpedi.nroped = lNroRef
            NO-LOCK NO-ERROR.
        IF NOT AVAIL faccpedi THEN DO:
            MESSAGE "Pedido de Referencia de la OTR no existe" lCodRef lNroRef
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "ADM-ERROR".
        END.
        x-cliente-final = "".
        IF faccpedi.CodDoc = 'OTR' THEN x-cliente-final = faccpedi.codcli + " ".
        x-cliente-final = x-cliente-final + faccpedi.nomcli.
        x-direccion-final = faccpedi.dircli.
    END.
    /* Ic - 02Dic2016 - FIN */
    /* Datos Sede de Venta */
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.  /*faccpedi.coddiv*/
    IF AVAIL gn-divi THEN 
        ASSIGN 
            cDir = INTEGRAL.GN-DIVI.DirDiv
            cSede = GN-DIVI.CodDiv + " " + INTEGRAL.GN-DIVI.DesDiv.
    FIND Almacen WHERE Almacen.codcia = s-codcia
        AND Almacen.codalm = s-CodAlm
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN cDir = Almacen.DirAlm.

    /**/
    lFiler1 = tt-w-report.campo-c[3].
    IF Chktareas.coddoc = 'HPK' THEN DO:
        lFiler1 = REPLACE(lFiler1,"-","").
        lFiler1 = REPLACE(lFiler1," ","").
    END.

    dPEso = fPeso-orden(INPUT tt-w-report.campo-c[1], INPUT tt-w-report.campo-c[2], 
                    INPUT chktareas.coddoc, INPUT chktareas.nroped).

    lCodDoc = Chequeador(INPUT chktareas.coddoc, INPUT chktareas.nroped).

    CREATE rr-w-report.
    ASSIGN         
        i-nro             = i-nro + 1
        rr-w-report.Llave-C  = "01" + faccpedi.nroped
        rr-w-report.Campo-C[1] = faccpedi.ruc
        rr-w-report.Campo-C[2] = x-cliente-final   
        rr-w-report.Campo-C[3] = x-direccion-final  
        rr-w-report.Campo-C[4] = cNomChq
        rr-w-report.Campo-D[1] = faccpedi.fchped
        rr-w-report.Campo-C[5] = STRING(x-total-bultos-orden)
        rr-w-report.Campo-F[1] = dPeso     /* Peso */
        rr-w-report.Campo-C[7] = lCodRef2 + "-" + lNroRef2 /*faccpedi.nroped*/
        rr-w-report.Campo-I[1] = i-nro
        rr-w-report.Campo-C[8] = cDir
        rr-w-report.Campo-C[9] = cSede
        rr-w-report.Campo-C[10] = lFiler1   /*tt-w-report.campo-c[3] /* ControlOD.NroEtq*/*/
        rr-w-report.Campo-D[2] = faccpedi.fchent
        rr-w-report.campo-c[11] = TRIM(lCodDoc + " " + lNroDoc)
        rr-w-report.campo-c[12] = x-cliente-intermedio
        rr-w-report.campo-c[13] = ""    /*STRING(pNroBulto)+ "-" + pGraficoRotulo + "-" + STRING(i-nro,"999")*/
        rr-w-report.campo-c[14] = ""
        rr-w-report.campo-c[19] = tt-w-report.campo-c[1]    /* O/D */
        rr-w-report.campo-c[20] = tt-w-report.campo-c[2]    /* Nro */
        .
    
    IF chktareas.coddoc = 'HPK' THEN DO:
        IF faccpedi.crossdocking = NO THEN DO:
            IF AVAILABLE hpk-vtacdocu THEN rr-w-report.campo-c[14] = hpk-vtacdocu.codori + " " + hpk-vtacdocu.nroori.
        END.       
    END.
    
    /* Ic - 15Feb2018, jalar la Nro de Orden de Iversa, ListaExpree */
    IF s-coddiv = '00506' THEN DO:
        /* Busco el Pedido */
        FIND FIRST x-pedido WHERE x-pedido.codcia = s-codcia AND 
                                    x-pedido.coddoc = faccpedi.codref AND 
                                    x-pedido.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE x-pedido THEN DO:
            /* Busco la Cotizacion */
            FIND FIRST x-cotizacion WHERE x-cotizacion.codcia = s-codcia AND 
                                        x-cotizacion.coddoc = x-pedido.codref AND 
                                        x-cotizacion.nroped = x-pedido.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE x-cotizacion THEN DO:
                ASSIGN w-report.campo-c[12] = "PEDIDO WEB :" + TRIM(x-cotizacion.nroref)
                        rr-w-report.campo-c[14] = "".
            END.
        END.
    END.

END.

SESSION:SET-WAIT-STATE("").

END PROCEDURE.


/*
DEFINE VAR dPeso        AS DECIMAL   NO-UNDO.
DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
DEFINE VAR cDir         AS CHARACTER NO-UNDO.
DEFINE VAR cSede        AS CHARACTER NO-UNDO.
DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.

DEFINE VAR lCodRef AS CHAR.
DEFINE VAR lNroRef AS CHAR.
DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.

DEFINE VAR lCodRef2 AS CHAR.
DEFINE VAR lNroRef2 AS CHAR.

DEFINE VAR x-almfinal AS CHAR.
DEFINE VAR x-cliente-final AS CHAR.
DEFINE VAR x-cliente-intermedio AS CHAR.
DEFINE VAR x-direccion-final AS CHAR.
DEFINE VAR x-direccion-intermedio AS CHAR.

DEFINE BUFFER x-almacen FOR almacen.
DEFINE BUFFER x-pedido FOR faccpedi.
DEFINE BUFFER x-cotizacion FOR faccpedi.
DEFINE BUFFER hpk-vtacdocu FOR vtacdocu.

DEFINE VAR i-nro AS INT.

IF ppCodDoc = 'HPK' THEN DO:
    FIND FIRST hpk-vtacdocu WHERE hpk-vtacdocu.codcia = s-codcia AND
                                    hpk-vtacdocu.codped = ppCodDOc AND 
                                    hpk-vtacdocu.nroped = ppNroDoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE hpk-vtacdocu THEN DO:
        MESSAGE "Imposible encontrar la HPK".
        RETURN.        
    END.
    pCoddoc = hpk-vtacdocu.codref.  /* O/D */
    pNroDoc = hpk-vtacdocu.nroref.
END.

/* Ubico la orden */
FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia
    AND faccpedi.coddoc = pCodDoc
    AND faccpedi.nroped = pNroDoc
    NO-LOCK NO-ERROR.

IF NOT AVAILABLE faccpedi THEN DO:
    MESSAGE "Imposible encontrar la Orden".
    RETURN.
END.

cNomCHq = "".
lCodDoc = "".
lNroDoc = "".
dPeso = 0.      /**ControlOD.PesArt.*/
lCodRef2 = pCoddoc.
lNroRef2 = pNroDoc.

x-cliente-final = faccpedi.nomcli.
x-direccion-final = faccpedi.dircli.
x-cliente-intermedio = "".
x-direccion-intermedio = "".

/* CrossDocking almacen FINAL */
x-almfinal = "".
IF faccpedi.crossdocking = YES THEN DO:
    lCodRef2 = faccpedi.codref.
    lNroRef2 = faccpedi.nroref.
    lCodDoc = "(" + faccpedi.coddoc.
    lNroDoc = faccpedi.nroped + ")".

    x-cliente-intermedio = faccpedi.codcli + " " + faccpedi.nomcli.
    x-direccion-intermedio = faccpedi.dircli.

    IF faccpedi.codref = 'R/A' THEN DO:
        FIND FIRST x-almacen WHERE x-almacen.codcia = s-codcia AND 
                                    x-almacen.codalm = faccpedi.almacenxD
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE x-almacen THEN x-cliente-final = TRIM(x-almacen.descripcion). /*x-almfinal = TRIM(x-almacen.descripcion).*/
        IF AVAILABLE x-almacen THEN x-direccion-final = TRIM(x-almacen.diralm). /*x-almfinal = TRIM(x-almacen.descripcion).*/
    END.
END.
/* Ic - 02Dic2016, si es OTR verificar si no proviene de una PED (pedido) */
/* Si viene de un PED, los datos del cliente deben salir del PEDIDO */
/* Crossdocking */
IF faccpedi.coddoc = 'OTR' AND faccpedi.codref = 'PED' THEN DO:
    lCodDoc = "(" + pCoddoc.
    lNroDoc = pNrodoc + ")".
    lCodRef = faccpedi.codref.
    lNroRef = faccpedi.nroref.
    RELEASE faccpedi.

    FIND faccpedi WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddoc = lCodRef
        AND faccpedi.nroped = lNroRef
        NO-LOCK NO-ERROR.
    IF NOT AVAIL faccpedi THEN DO:
        MESSAGE "Pedido de Referencia de la OTR no existe" lCodRef lNroRef
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "ADM-ERROR".
    END.
    x-cliente-final = "".
    IF CcbCBult.CodDoc = 'OTR' THEN x-cliente-final = faccpedi.codcli + " ".
    x-cliente-final = x-cliente-final + faccpedi.nomcli.
    x-direccion-final = faccpedi.dircli.
END.
/* Ic - 02Dic2016 - FIN */

/* Datos Sede de Venta */
FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
IF AVAIL gn-divi THEN 
    ASSIGN 
        cDir = INTEGRAL.GN-DIVI.DirDiv
        cSede = GN-DIVI.CodDiv + " " + INTEGRAL.GN-DIVI.DesDiv.
FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = s-CodAlm
    NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN cDir = Almacen.DirAlm.

EMPTY TEMP-TABLE rr-w-report.
i-nro = 0.

/* Rotulos marcados */
FOR EACH tt-w-report WHERE tt-w-report.campo-l[1] = YES :

    /* Peso total del bulto */
    dPeso = peso-total-bulto(tt-w-report.campo-c[1]).

    CREATE rr-w-report.
    ASSIGN         
        i-nro             = i-nro + 1
        rr-w-report.Llave-C  = "01" + faccpedi.nroped
        rr-w-report.Campo-C[1] = faccpedi.ruc
        rr-w-report.Campo-C[2] = x-cliente-final   
        rr-w-report.Campo-C[3] = x-direccion-final  
        rr-w-report.Campo-C[4] = cNomChq
        rr-w-report.Campo-D[1] = faccpedi.fchped
        rr-w-report.Campo-C[5] = '0'    /*STRING(Ccbcbult.bultos,'9999')*/
        rr-w-report.Campo-F[1] = dPeso
        rr-w-report.Campo-C[7] = lCodRef2 + "-" + lNroRef2 /*faccpedi.nroped*/
        rr-w-report.Campo-I[1] = i-nro
        rr-w-report.Campo-C[8] = cDir
        rr-w-report.Campo-C[9] = cSede
        rr-w-report.Campo-C[10] = tt-w-report.campo-c[1] /* ControlOD.NroEtq*/
        rr-w-report.Campo-D[2] = faccpedi.fchent
        rr-w-report.campo-c[11] = TRIM(lCodDoc + " " + lNroDoc)
        rr-w-report.campo-c[12] = x-cliente-intermedio
        rr-w-report.campo-c[13] = STRING(pNroBulto)+ "-" + pGraficoRotulo + "-" + STRING(i-nro,"999")
        rr-w-report.campo-c[14] = ""
        .       
    IF ppCodDoc = 'HPK' THEN DO:
        IF faccpedi.crossdocking = NO THEN DO:
            rr-w-report.campo-c[14] = hpk-vtacdocu.codori + " " + hpk-vtacdocu.nroori.
        END.       
    END.

    /* Ic - 15Feb2018, jalar la Nro de Orden de Iversa, ListaExpree */
    IF s-coddiv = '00506' THEN DO:
        /* Busco el Pedido */
        FIND FIRST x-pedido WHERE x-pedido.codcia = s-codcia AND 
                                    x-pedido.coddoc = faccpedi.codref AND 
                                    x-pedido.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE x-pedido THEN DO:
            /* Busco la Cotizacion */
            FIND FIRST x-cotizacion WHERE x-cotizacion.codcia = s-codcia AND 
                                        x-cotizacion.coddoc = x-pedido.codref AND 
                                        x-cotizacion.nroped = x-pedido.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE x-cotizacion THEN DO:
                ASSIGN w-report.campo-c[12] = "PEDIDO WEB :" + TRIM(x-cotizacion.nroref)
                        rr-w-report.campo-c[14] = "".
            END.
        END.
    END.
END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-packing-od W-Win 
PROCEDURE carga-packing-od :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-coddoc-nrodoc AS CHAR.

IF NOT AVAILABLE chktareas THEN DO:
  RETURN.
END.

x-coddoc-nrodoc = chktareas.coddoc + "-" + chktareas.nroped.

cCodEAN = "".

DEFINE VAR x-es-correcto AS LOG.
/*
MESSAGE CcbCBult.codDoc SKIP
        CcbCBult.NroDoc SKIP
        s-CodDiv.
*/
FOR EACH Vtaddocu NO-LOCK WHERE VtaDDocu.CodCia =  CcbCBult.CodCia
    AND VtaDDocu.CodDiv = s-CodDiv
    AND VtaDDocu.CodPed = CcbCBult.CodDoc
    AND VtaDDocu.NroPed = CcbCBult.NroDoc
    /*FIRST Almmmatg OF Vtaddocu NO-LOCK*/
    BREAK BY VtaDDocu.Libre_c01 BY VtaDDocu.NroItm:
    /*
    MESSAGE VtaDDocu.Libre_c01 SKIP
            x-coddoc-nrodoc.
    */
    FIND FIRST almmmatg OF vtaddocu NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almmmatg THEN DO:
        /*
        MESSAGE vtaddocu.codmat SKIP
            "NO HAY".
            */
        NEXT.
    END.

    x-es-correcto = YES.
    IF chktareas.coddoc = 'HPK' THEN DO:
        x-es-correcto = NO. 
        IF VtaDDocu.Libre_c01 BEGINS x-coddoc-nrodoc THEN x-es-correcto = YES.
    END.
    IF x-es-correcto = NO THEN NEXT.

    IF FIRST-OF(VtaDDocu.Libre_c01) THEN iInt = iInt + 1.     

    RUN Vta\R-CalCodEAN.p (INPUT Almmmatg.CodBrr, OUTPUT cCodEan).
    CREATE w-report.
    ASSIGN
        w-report.Task-No    = s-task-no 
        w-report.Llave-I    = iInt
        w-report.Campo-C[1] = CcbCBult.OrdCmp
        w-report.Campo-C[5] = CcbCBult.CodDoc
        w-report.Campo-C[6] = CcbCBult.NroDoc
        w-report.Campo-C[7] = Vtaddocu.CodMat
        w-report.Campo-C[8] = Almmmatg.DesMat
        w-report.Campo-C[9] = cCodEan        
        w-report.Campo-C[10] = Almmmatg.CodBrr 
        w-report.Campo-C[11] = VtaDDocu.Libre_c01
        /* Ic - 22Set2015 */
        w-report.Campo-C[25] = trim(CcbCBult.codcli) + " " + CcbCBult.nomcli
        /* Ic - 22Set2015 */
        w-report.Campo-I[1] = iInt
        w-report.Campo-I[2] = CcbCBult.Bultos
        w-report.Campo-F[2] = VtaDDocu.CanPed
        w-report.Campo-F[3] = VtaDDocu.PesMat
        w-report.Campo-I[3] = VtaDDocu.CanPed
        w-report.Campo-I[4] = s-codcia.
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
  DISPLAY FILL-IN-codtrab FILL-IN-copias FILL-IN-desde FILL-IN-hasta FILL-IN-phr 
          FILL-IN-hpk 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-14 FILL-IN-codtrab FILL-IN-copias BUTTON-6 BUTTON-5 
         FILL-IN-desde FILL-IN-hasta BUTTON-1 BUTTON-2 BUTTON-3 BROWSE-16 
         FILL-IN-phr FILL-IN-hpk 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-rotulo-master W-Win 
PROCEDURE imprime-rotulo-master :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE chktareas THEN RETURN.

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-filer AS CHAR.

x-phr-esta-cerrada = YES.

/*

Validacion quedo desactivada x Max Ramos, 23/01/2019 : 11:35am

IF chktareas.coddoc = 'HPK' THEN DO:
    DEFINE VAR x-cod-phr AS CHAR.
    DEFINE VAR x-nro-phr AS CHAR.
    DEFINE VAR x-retval AS CHAR INIT "OK".

    FIND FIRST vtacdocu WHERE vtacdocu.codcia = s-codcia AND 
                                vtacdocu.codped = chktareas.coddoc AND
                                vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
    IF AVAILABLE vtacdocu THEN DO:
        RUN verificar-hpr-cerrada(INPUT vtacdocu.codori, INPUT vtacdocu.nroori, OUTPUT x-retval).
    END.
    IF x-retval <> "OK" THEN DO:
        
        MESSAGE "La PHR no esta cerrada, imposible imprimir rotulo MASTER" VIEW-AS ALERT-BOX INFORMATION.
        RETURN.
        /*
        MESSAGE "La PHR no esta cerrada, imposible imprimir rotulo MASTER" SKIP
                'Continuamos con la impresion ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta2 AS LOG.
        IF rpta2 = NO THEN RETURN NO-APPLY.
        */
        x-phr-esta-cerrada = NO.
    END.
END.
*/

IF chktareas.coddoc = 'HPK' THEN DO:
    
    FIND FIRST vtacdocu WHERE vtacdocu.codcia = s-codcia AND
                                vtacdocu.codped = chktareas.coddoc AND
                                vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
    IF AVAILABLE vtacdocu THEN DO:
        x-coddoc = vtacdocu.codref.
        x-nrodoc = vtacdocu.nroref.     /* O/D */
        x-phr-esta-cerrada = YES.

        FOR EACH vtacdocu WHERE vtacdocu.codcia = s-codcia AND
                                    vtacdocu.codped = 'HPK' AND
                                    vtacdocu.codref = x-coddoc AND
                                    vtacdocu.nroref = x-nrodoc AND
                                    vtacdocu.flgest <> "A" NO-LOCK:
            IF LOOKUP(vtacdocu.flgsit, 'PC,C') = 0 THEN DO:
                x-phr-esta-cerrada = NO.
                x-filer = vtacdocu.nroped.
            END.
                
        END.
        /* Tío CheChar, aún siguen los problema 8-(  */
        IF x-phr-esta-cerrada = NO THEN DO:
            MESSAGE "La " + x-coddoc + "-" + x-nrodoc + " aun tiene la " 
                    "HPK " + x-filer + " pendiente por Chequear"
                VIEW-AS ALERT-BOX INFORMATION.
            RETURN.
        END.
    END.
END.

EMPTY TEMP-TABLE rr-w-report.

DEFINE BUFFER x-faccpedi FOR faccpedi.

FOR EACH rr-w-report NO-LOCK WHERE rr-w-report.campo-l[1] = YES
    BREAK BY rr-w-report.campo-c[19] BY rr-w-report.campo-c[20]:
    IF FIRST-OF(rr-w-report.campo-c[19]) OR FIRST-OF(rr-w-report.campo-c[20]) THEN DO:
        /* Verificar si las Ordenes estan Cierre Chequeo o pase a distribucion */
        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                        x-faccpedi.coddoc = rr-w-report.campo-c[19] AND
                                        x-faccpedi.nroped = rr-w-report.campo-c[20] AND
                                        (x-faccpedi.flgsit = 'PC' OR x-faccpedi.flgsit = 'C')
                                        NO-LOCK NO-ERROR.
        IF AVAILABLE x-faccpedi THEN DO:
            CREATE ttOrdenes.
                ASSIGN ttOrdenes.tcoddoc = rr-w-report.campo-c[19]
                        ttOrdenes.tnrodoc = rr-w-report.campo-c[20].
        END.
    END.
END.

FIND FIRST ttOrdenes NO-ERROR.
IF AVAILABLE ttOrdenes THEN DO:

    DEFINE VAR rpta AS LOG.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.
END.
ELSE DO:
    MESSAGE "Seleccione las Ordenes a Imprimir, por favor" VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

/* Copias */
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-copias.
END.
DEFINE VAR x-copia AS INT.

REPEAT x-copia = 1 TO fill-in-copias :
    FOR EACH ttOrdenes:
          /* Imprimir Rotulo Master */
          RUN dist/p-imprime-rotulo-master.r(INPUT -1,
                                             INPUT "",
                                             INPUT ttOrdenes.tCoddoc,
                                              INPUT ttOrdenes.tnrodoc).
    END.
END.


END PROCEDURE.
/*
DEFINE TEMP-TABLE ttOrdenes
    FIELDS  tcoddoc     AS  CHAR    FORMAT  'x(5)'
    FIELDS  tnrodoc     AS  CHAR    FORMAT  'x(15)'
.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-rotulo-zebra W-Win 
PROCEDURE imprime-rotulo-zebra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST rr-w-report NO-LOCK NO-ERROR.
IF NOT AVAILABLE rr-w-report THEN DO:
    RETURN.
END.

DEFINE VAR lDireccion1 AS CHAR.
DEFINE VAR lDireccion2 AS CHAR.
DEFINE VAR lDirPart1 AS CHAR.
DEFINE VAR lDirPart2 AS CHAR.
DEFINE VAR lbarra AS CHAR.
DEFINE VAR lSede AS CHAR.
DEFINE VAR lRuc AS CHAR.
DEFINE VAR lpedido AS CHAR.
DEFINE VAR lCliente AS CHAR.
DEFINE VAR lChequeador AS CHAR.
DEFINE VAR lFecha AS DATE.
DEFINE VAR lFechaEnt AS DATE.
DEFINE VAR lEtiqueta AS CHAR.
DEFINE VAR lpeso AS DEC.
DEFINE VAR lBultos AS CHAR.
DEFINE VAR lFiler AS CHAR.
DEFINE VAR lRefOtr AS CHAR.
DEFINE VAR x-almfinal AS CHAR.

DEFINE VAR rpta AS LOG.

DEFINE VAR x-Bulto AS CHAR.


SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

OUTPUT STREAM REPORTE TO PRINTER.

/* ---------------------------------------- */

/*
DEFINE VAR x-file-zpl AS CHAR.

x-file-zpl = SESSION:TEMP-DIRECTORY + REPLACE("HPK","/","") + "-" + "PRUEBA" + ".txt".

OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
*/

FOR EACH rr-w-report WHERE NO-LOCK BREAK BY rr-w-report.campo-c[19] BY rr-w-report.campo-c[20]:

    /* Los valores */
    lDireccion1 = rr-w-report.campo-c[8].
    lSede = rr-w-report.campo-c[9].
    lRuc = rr-w-report.campo-c[1].
    lPedido = rr-w-report.campo-c[7].
    lCliente = rr-w-report.campo-c[2].
    lDireccion2 = rr-w-report.campo-c[3].
    lChequeador = rr-w-report.campo-c[4].
    lFecha = rr-w-report.campo-d[1].
    lFechaEnt = rr-w-report.campo-d[2].
    lEtiqueta = rr-w-report.campo-c[10].
    lPeso = rr-w-report.campo-f[1].
    lBultos = STRING(rr-w-report.campo-i[1]) + " / " + rr-w-report.campo-c[5].   /*TRIM(rr-w-report.campo-c[13])*/
    lBarra = STRING(rr-w-report.llave-c,"99999999999") + STRING(rr-w-report.campo-i[1],"9999").    
    lRefOtr = TRIM(rr-w-report.campo-c[11]).

    /* Ic - 10Set2018, realmente es el destino Intermedio */
    x-almfinal = TRIM(rr-w-report.campo-c[12]).
    IF s-coddiv <> '00506' THEN DO:
        IF x-almfinal <> "" THEN x-almfinal = "D.INTERMEDIO:" + x-almfinal.
    END.    
    IF rr-w-report.campo-c[14] <> "" THEN DO:
        /* Se imprime el HPR */
        x-almfinal = rr-w-report.campo-c[14].
    END.

    lDireccion2 = TRIM(lDireccion2) + FILL(" ",90).
    lDirPart1 = SUBSTRING(lDireccion2,1,45).
    lDirPart2 = SUBSTRING(lDireccion2,46).

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.

    PUT STREAM REPORTE "^FO025,20" SKIP.
    PUT STREAM REPORTE "^ADN,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "CONTINENTAL S.A.C." SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO035,020" SKIP.
    PUT STREAM REPORTE "^AVN,0,0" SKIP.
    PUT STREAM REPORTE "^FDBULTO : " + rr-w-report.campo-c[1] FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */

    PUT STREAM REPORTE "^FO020,050" SKIP.
    PUT STREAM REPORTE "^AVN,0,0" SKIP.
    PUT STREAM REPORTE "^FD".
    /*PUT STREAM REPORTE "BULTO : " + lBultos FORMAT 'x(67)' SKIP.*/
    PUT STREAM REPORTE lEtiqueta FORMAT 'x(67)' SKIP.    
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO035,130" SKIP.  /*080*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Direccion:" + lDireccion1 FORMAT 'x(67)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,160" SKIP. /*110*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Sede :" + lSede FORMAT 'x(60)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO690,030^BY2" SKIP. 
    PUT STREAM REPORTE "^B3R,N,80,N" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lBarra FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS".

    PUT STREAM REPORTE "^FO035,190" SKIP. /*150*/
    PUT STREAM REPORTE "^A0N,60,45" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Nro. " + lPedido FORMAT 'x(40)' SKIP.
    PUT STREAM REPORTE "^FS".
    /*
    PUT STREAM REPORTE "^FO400,200" SKIP.  /*150*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "RUC:" + lRuc FORMAT 'x(16)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO035,250" SKIP.  /*200*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "DESTINO" FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,280" SKIP. /*230*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lCliente FORMAT 'x(70)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,320" SKIP.  /*270*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.  
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart1 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,350" SKIP.   /*320*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart2 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO035,350" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Chequeador :" + lChequeador FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO035,400" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Fecha :" + STRING(lFecha,"99/99/9999") FORMAT 'x(18)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO290,400" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Etiqueta :" + lEtiqueta FORMAT 'x(28)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO035,450" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "BULTOS : " + lbultos FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO370,450" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "PESO :" + STRING(lPeso,"ZZ,ZZZ,ZZ9.99") FORMAT 'x(19)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,500" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Entrega :" + STRING(lFechaEnt,"99/99/9999") FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
 
    PUT STREAM REPORTE "^FO280,500" SKIP.
    PUT STREAM REPORTE "^A0N,40,20" SKIP.
    PUT STREAM REPORTE "^FDChequeador : " + lChequeador FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO350,500" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lRefOtr FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,550" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE x-almfinal FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^XZ" SKIP.

END.

OUTPUT STREAM REPORTE CLOSE.


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
  DO WITH FRAME {&FRAME-NAME}:
      fill-in-desde:SCREEN-VALUE = STRING(TODAY - 7,"99/99/9999").
      fill-in-hasta:SCREEN-VALUE = STRING(TODAY,"99/99/9999").
  END.

  RUN refrescar.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ordenes-involucrados W-Win 
PROCEDURE ordenes-involucrados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR x-llave AS CHAR.

SESSION:SET-WAIT-STATE("GENERAL").

EMPTY TEMP-TABLE ttOrdenes.

IF pCodDoc = 'HPK' THEN DO:
    
    FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                    x-vtacdocu.codped = pCodDOc AND
                                    x-vtacdocu.nroped = pNroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE x-vtacdocu THEN DO:
        IF x-vtacdocu.codter = 'ACUMULATIVO' THEN DO:
            
            x-llave = pCodDoc + "," + pNroDOc.
            FOR EACH x-almddocu WHERE x-almddocu.codcia = s-codcia AND 
                                        x-almddocu.codllave = x-llave NO-LOCK
                                        BREAK BY coddoc BY nrodoc.
                IF FIRST-OF(x-almddocu.coddoc) OR FIRST-OF(x-almddocu.nrodoc) THEN DO:
                    CREATE ttOrdenes.
                        ASSIGN tcoddoc = x-almddocu.coddoc
                                tnrodoc = x-almddocu.nrodoc.
                END.
            END.
        END.
        ELSE DO:
            CREATE ttOrdenes.
                ASSIGN tcoddoc = x-vtacdocu.codref
                        tnrodoc = x-vtacdocu.nroref.
        END.
    END.
END.
ELSE DO:
    CREATE ttOrdenes.
        ASSIGN tcoddoc = pCodDoc
                tnrodoc = pNroDoc.
END.

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packing-list W-Win 
PROCEDURE packing-list :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR x-llave AS CHAR.

DEF VAR pTipo AS INT NO-UNDO.
RUN dist/d-tipo-packinglist (OUTPUT pTipo).
IF pTipo = 0 THEN RETURN.

SESSION:SET-WAIT-STATE("GENERAL").

RUN ordenes-involucrados(INPUT pCodDOc, INPUT pNroDoc).

/**/
EMPTY TEMP-TABLE tt-w-report.

DEFINE VARIABLE iInt      AS INTEGER          NO-UNDO.
DEFINE VARIABLE L-Ubica   AS LOGICAL INIT YES NO-UNDO.        

REPEAT WHILE L-Ubica:
       s-task-no = RANDOM(900000,999999).
       FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
       IF NOT AVAILABLE w-report THEN L-Ubica = NO.
END.

IF s-task-no = 0 THEN DO:
    CORRELATIVO:
    REPEAT:
        s-task-no = RANDOM(1,999999).
        FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN LEAVE CORRELATIVO.
    END.
END.


iInt = 0.

FOR EACH ttOrdenes :
    FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND
                                ccbcbult.coddoc = ttOrdenes.tcoddoc AND
                                ccbcbult.nrodoc = ttOrdenes.tnrodoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbCBult THEN NEXT.

    IF CcbCBult.CodDoc = "O/D" OR CcbCBult.CodDoc = "OTR" OR CcbCBult.CodDoc = "O/M" THEN DO:
        RUN Carga-Packing-OD.
    END.

END.

SESSION:SET-WAIT-STATE("").

/* Code placed here will execute PRIOR to standard behavior. */
DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'dist/rbdist.prl'.
CASE pTipo:
    WHEN 1 THEN RB-REPORT-NAME = 'Packing List sin EAN'.
    WHEN 2 THEN RB-REPORT-NAME = 'Packing List'.
END CASE.
RB-INCLUDE-RECORDS = 'O'.

RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).


END PROCEDURE.

/*
    IF NOT AVAILABLE CcbCBult THEN RETURN.
    DEFINE VARIABLE iInt      AS INTEGER          NO-UNDO.
    DEFINE VARIABLE L-Ubica   AS LOGICAL INIT YES NO-UNDO.        

    REPEAT WHILE L-Ubica:
           s-task-no = RANDOM(900000,999999).
           FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
           IF NOT AVAILABLE w-report THEN L-Ubica = NO.
    END.

    CASE CcbCBult.CodDoc:
        WHEN "O/D" OR WHEN "OTR" OR WHEN "O/M" THEN DO:
            DEF VAR pTipo AS INT NO-UNDO.
            RUN dist/d-tipo-packinglist (OUTPUT pTipo).
            IF pTipo = 0 THEN RETURN.
            RUN Carga-Packing-OD.
            /* Code placed here will execute PRIOR to standard behavior. */
            DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
            DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
            DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
            DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
            DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

            GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
            RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'dist/rbdist.prl'.
            CASE pTipo:
                WHEN 1 THEN RB-REPORT-NAME = 'Packing List sin EAN'.
                WHEN 2 THEN RB-REPORT-NAME = 'Packing List'.
            END CASE.
            RB-INCLUDE-RECORDS = 'O'.

            RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
            RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                               RB-REPORT-NAME,
                               RB-INCLUDE-RECORDS,
                               RB-FILTER,
                               RB-OTHER-PARAMETERS).

        END.
        OTHERWISE DO:
        END.
    END CASE.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar W-Win 
PROCEDURE refrescar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-desde fill-in-hasta.
END.

{&open-query-browse-14}

x-codped = "".
x-nroped = "".

IF AVAILABLE chktareas THEN DO:
      x-codped = chktareas.coddoc.
      x-nroped = chktareas.nroped.
END.

RUN rotulos-de-las-ordenes(INPUT x-codped, INPUT x-nroped).

{&open-query-browse-16}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rotulos-de-las-ordenes W-Win 
PROCEDURE rotulos-de-las-ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR x-llave AS CHAR.
DEFINE VAR x-coddoc-nrodoc AS CHAR.
DEFINE VAR x-es-valido AS LOG.

SESSION:SET-WAIT-STATE("GENERAL").

RUN ordenes-involucrados(INPUT pCodDOc, INPUT pNroDoc).

/**/
EMPTY TEMP-TABLE tt-w-report.
x-coddoc-nrodoc = pCodDoc + "-" + pNroDoc.

FOR EACH ttOrdenes :
    FOR EACH controlOD WHERE controlOD.codcia = s-codcia AND
                                controlOD.coddoc = ttOrdenes.tcoddoc AND
                                controlOD.nrodoc =ttOrdenes.tnrodoc NO-LOCK:
        x-es-valido = YES.
        IF pCodDoc = 'HPK' THEN DO:
            x-es-valido = NO.
            IF controlOD.nroetq BEGINS x-coddoc-nrodoc THEN DO:
                x-es-valido = YES.
            END.
        END.
        IF x-es-valido = YES THEN DO:
            CREATE tt-w-report.
                ASSIGN tt-w-report.campo-c[1] = controlOD.coddoc
                        tt-w-report.campo-c[2] = controlOD.nrodoc
                        tt-w-report.campo-c[3] = controlOD.nroetq
                        tt-w-report.campo-c[4] = controlOD.nomcli
                        tt-w-report.campo-f[1] = controlOD.pesart
                .
        END.
    END.
END.

SESSION:SET-WAIT-STATE("").

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
  {src/adm/template/snd-list.i "tt-w-report"}
  {src/adm/template/snd-list.i "ChkTareas"}
  {src/adm/template/snd-list.i "VtaCDocu"}
  {src/adm/template/snd-list.i "tt-ChkTareas"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE terminar-orden W-Win 
PROCEDURE terminar-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-procesoOk AS CHAR NO-UNDO.

x-procesoOk = 'Inicio'.

DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-vtacdocu FOR vtacdocu.
DEFINE BUFFER b-chktareas FOR chktareas.

GRABAR_REGISTROS:
DO TRANSACTION ON ERROR UNDO, LEAVE:
    /* Ordenes */
    x-procesoOk = "Actualizar la orden como Pase a Districion (C)". 
    FOR EACH ttOrdenes :
        FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                                        b-faccpedi.coddoc = ttOrdenes.tcoddoc AND
                                        b-faccpedi.nroped = ttOrdenes.tnrodoc EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b-faccpedi THEN DO:
            x-procesoOk = "Error al actualizar la ORDEN como pase a Distribucion".
            UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
        END.
        ASSIGN b-faccpedi.flgsit = 'C'.
    END.

  DO:
    IF chktareas.coddoc = 'HPK' THEN DO:
        x-procesoOk = "Actualizar la orden como Cierre de Chequeo (PC)". 
        FIND FIRST b-vtacdocu WHERE b-vtacdocu.codcia = s-codcia AND 
                                        b-vtacdocu.codped = chktareas.coddoc AND
                                        b-vtacdocu.nroped = chktareas.nroped EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b-vtacdocu THEN DO:
            x-procesoOk = "Error al actualizar la ORDEN como Cierre de Chequeo".
            UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
        END.
        ASSIGN b-vtacdocu.flgsit = 'PC'.

    END.

    /* Tarea Observacion */
    x-procesoOk = "Ponemos la tarea como Pase a Distribucion".
    FIND FIRST b-chktareas WHERE b-chktareas.codcia = chktareas.codcia AND
                                b-chktareas.coddiv = chktareas.coddiv AND 
                                b-chktareas.coddoc = chktareas.coddoc AND
                                b-chktareas.nroped = chktareas.nroped AND
                                b-chktareas.mesa = chktareas.mesa EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE b-chktareas THEN DO:
        x-procesoOk = "Error al actualizar la tarea como Pase a Distribucion".
        UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
    END.
    ASSIGN b-chktareas.flgest = 'C' 
        b-chktareas.fechafin = TODAY
        b-chktareas.horafin = STRING(TIME,"HH:MM:SS")
        b-chktareas.usuariofin = s-user-id NO-ERROR
    .
                                
    x-procesoOk = "OK".

  END.

END. /* TRANSACTION block */

RELEASE b-faccpedi.
RELEASE b-vtacdocu.
RELEASE b-chktareas.

IF x-procesoOk = "OK" THEN DO:
    {&open-query-browse-14}

    x-codped = "".
    x-nroped = "".
    IF AVAILABLE chktareas THEN DO:
          x-codped = chktareas.coddoc.
          x-nroped = chktareas.nroped.
    END.

    RUN recopilar-ordenes(INPUT x-nroped, INPUT x-nroped).

END.
ELSE DO:
    MESSAGE x-procesoOk.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificar-hpr-cerrada W-Win 
PROCEDURE verificar-hpr-cerrada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcod-hpr AS CHAR.
DEFINE INPUT PARAMETER pnro-hpr AS CHAR.
DEFINE OUTPUT PARAMETER pCerrado AS CHAR.

pCerrado = "OK".
DEFINE BUFFER x-vtacdocu FOR vtacdocu.

FOR EACH x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND 
                            x-vtacdocu.codped = 'HPK' AND
                            x-vtacdocu.codori = pcod-hpr AND
                            x-vtacdocu.nroori = pnro-hpr NO-LOCK:
    IF x-vtacdocu.flgsit <> 'PC' THEN pCerrado = 'NO'.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cantidad-bultos W-Win 
FUNCTION cantidad-bultos RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR x-retval AS INT INIT 0.
    DEFINE VAR x-coddoc-nrodoc AS CHAR.
    DEFINE VAR x-es-valido AS LOG.

    x-coddoc-nrodoc = pCodDoc + "-" + pNroDoc.
    
    /*
    FOR EACH x-ControlOD WHERE x-ControlOD.codcia = s-codcia AND 
                                x-controlOD.nroetq BEGINS x-coddoc-nrodoc NO-LOCK:
        
        x-es-valido = YES.
        /*
        IF pCodDoc = 'HPK' THEN DO:
            x-es-valido = NO.
            IF x-controlOD.nroetq BEGINS x-coddoc-nrodoc THEN DO:
                x-es-valido = YES.
            END.
        END.
        */
        IF x-es-valido = YES THEN x-retval = x-retval + 1.
        
    END.
    */

    /*RUN ordenes-involucrados(INPUT pCodDOc, INPUT pNroDoc).*/
    
    FOR EACH ttOrdenes :
        FOR EACH x-ControlOD WHERE x-ControlOD.codcia = s-codcia AND 
                                    x-ControlOD.coddoc = ttOrdenes.tCodDoc AND
                                    x-ControlOD.nrodoc = ttOrdenes.tnroDoc AND
                                    x-controlOD.nroetq BEGINS x-coddoc-nrodoc NO-LOCK:
            
            x-es-valido = YES.
            /*
            IF pCodDoc = 'HPK' THEN DO:
                x-es-valido = NO.
                IF x-controlOD.nroetq BEGINS x-coddoc-nrodoc THEN DO:
                    x-es-valido = YES.
                END.
            END.
            */
            IF x-es-valido = YES THEN x-retval = x-retval + 1.
            
        END.
    END.
    
    RETURN x-retval.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cantidad-sku W-Win 
FUNCTION cantidad-sku RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNrodoc AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS INT INIT 0.

    x-col-codorden = "".
    x-col-nroorden = "".
    x-col-nro-phr = "".

   /* RUN ordenes-involucrados(INPUT pCodDOc, INPUT pNroDoc).*/

  IF pCodDoc = 'HPK' THEN DO:

      FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                    x-vtacdocu.codped = pCodDoc AND 
                                    x-vtacdocu.nroped = pNroDoc NO-LOCK NO-ERROR.
                                    
      IF AVAILABLE x-vtacdocu THEN DO:
          x-col-codorden = x-vtacdocu.codref.
          x-col-nroorden = x-vtacdocu.nroref.
          x-col-nro-phr = x-vtacdocu.nroori.
      END.
      /*
      FOR EACH x-vtaddocu WHERE x-vtaddocu.codcia = s-codcia AND
                                    x-vtaddocu.codped = pCodDoc AND
                                    x-vtaddocu.nroped = pNrodoc NO-LOCK:
            x-retval = x-retval + 1.

      END.
      */
  END.
  ELSE DO:
      DEFINE BUFFER x-facdpedi FOR facdpedi.
        /*
      FOR EACH x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                                    x-facdpedi.coddoc = pCodDoc AND
                                    x-facdpedi.nroped = pNrodoc NO-LOCK:
            x-retval = x-retval + 1.

      END.
      */
  END.

  RETURN x-retval.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION chequeador W-Win 
FUNCTION chequeador RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

/*RUN ordenes-involucrados(INPUT pCodDOc, INPUT pNroped).*/

FIND FIRST ttOrdenes NO-ERROR.
DEFINE VAR x-retval AS CHAR INIT "".
DEFINE VAR x-dni AS CHAR INIT "".
DEFINE VAR x-origen AS CHAR INIT "".

/*IF AVAILABLE ttOrdenes THEN DO:    */

    

    IF pCodDoc = 'HPK' THEN DO:
        
        FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                        x-vtacdocu.codped = pCodDOc AND
                                        x-vtacdocu.nroped = pNroPEd NO-LOCK NO-ERROR.
        IF AVAILABLE x-vtacdocu THEN DO:
            IF NOT (TRUE <> (x-vtacdocu.libre_c04 > "")) THEN DO:
                x-dni = ENTRY(1,x-vtacdocu.libre_c04,"|").
                RUN logis/p-busca-por-dni.r(INPUT x-dni, OUTPUT x-retval, OUTPUT x-origen).
            END.            
        END.
    END.
    ELSE DO:        
        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                                        x-faccpedi.coddoc = ttOrdenes.tcoddoc AND 
                                        x-faccpedi.nroped = ttOrdenes.tnrodoc NO-LOCK NO-ERROR.
        IF AVAILABLE x-faccpedi THEN DO:
            IF NOT (TRUE <> (x-faccpedi.usrchq > "")) THEN DO:
                x-dni = x-faccpedi.usrchq.
                RUN logis/p-busca-por-dni.r(INPUT x-dni, OUTPUT x-retval, OUTPUT x-origen).
            END.            
        END.
    END.

    IF x-retval = "" THEN DO:
        /* buscarlo si existe en la maestra de personal */
        FIND FIRST pl-pers WHERE  pl-pers.codper = x-dni NO-LOCK NO-ERROR.
        IF  AVAILABLE pl-pers THEN DO:
            x-retval = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
        END.
    END.
/*END.*/

RETURN x-retval.

END FUNCTION.

/*
DEF INPUT PARAMETER pDNI AS CHAR.
DEF OUTPUT PARAMETER pNombre AS CHAR.
DEF OUTPUT PARAMETER pOrigen AS CHAR.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cliente W-Win 
FUNCTION cliente RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDOc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR x-retval AS CHAR.

IF pCodDoc = 'HPK' THEN DO:

    FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                    x-vtacdocu.codped = pCodDOc AND
                                    x-vtacdocu.nroped = pNrodoc NO-LOCK NO-ERROR.
    IF AVAILABL x-vtacdocu THEN x-retval = x-vtacdocu.nomcli.
END.
ELSE DO:

    
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddoc = pCoddoc AND
                                x-faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
    IF AVAILABL x-faccpedi THEN x-retval = x-faccpedi.nomcli.
END.

RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION es-crossdocking W-Win 
FUNCTION es-crossdocking RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS CHAR INIT "NO".

  FIND FIRST x-ChkControl WHERE x-ChkControl.codcia = s-codcia AND 
                              x-ChkControl.coddiv = s-coddiv AND 
                              x-ChkControl.coddoc = pCoddoc AND 
                              x-ChkControl.nroped = pNrodoc NO-LOCK NO-ERROR.
  IF AVAILABLE x-ChkControl THEN DO:
    IF x-ChkControl.crossdocking THEN x-retval = 'SI'.
  END.


  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso-orden W-Win 
FUNCTION fPeso-orden RETURNS DECIMAL
  ( INPUT pCodOrden AS CHAR, INPUT pNroOrden AS CHAR, INPUT pCodHPK AS CHAR, INPUT pNroPHK AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS DEC INIT 0.
  DEFINE VAR x-bulto AS CHAR INIT "".

  FOR EACH x-vtaddocu WHERE x-vtaddocu.codcia = s-codcia AND
                            x-vtaddocu.codped = pCodOrden AND
                            x-vtaddocu.nroped = pNroOrden AND
                            x-vtaddocu.libre_c01 BEGINS x-bulto NO-LOCK:
      x-retval = x-retval + (x-vtaddocu.pesmat * x-vtaddocu.canped).
  END.

  RETURN x-retval.
/*
                    vtaddocu.pesmat = almmmatg.pesmat
                    vtaddocu.codmat = tt-articulos-pickeados.campo-c[1]
                    vtaddocu.canped = tt-articulos-pickeados.campo-f[3]                    
                    vtaddocu.factor = tt-articulos-pickeados.campo-f[2]
                    vtaddocu.libre_c01 = tt-articulos-pickeados.campo-c[5]       /* El bulto */

*/

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-datos-adicionales W-Win 
FUNCTION get-datos-adicionales RETURNS CHARACTER
  ( INPUT pCodDOc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tiempo-observado W-Win 
FUNCTION tiempo-observado RETURNS CHARACTER
  ( INPUT pFecha AS DATE, INPUT pHora AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-tiempo AS CHAR.

    x-Tiempo = STRING(pFecha,"99/99/9999") + " " + pHora.
    /*
    RUN lib/_time-passed ( DATETIME(STRING(pFecha,"99/99/9999") + ' ' + pHora),
                             DATETIME(STRING(TODAY,"99/99/9999") + ' ' + STRING(TIME,"HH:MM:SS")), OUTPUT x-Tiempo).
    */
    

    RETURN x-tiempo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

