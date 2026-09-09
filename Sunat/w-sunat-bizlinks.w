&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-Comprobantes NO-UNDO LIKE FELogComprobantes
       field sactualizar as char init ''
       field fchdoc as date
       field sestado as char
       field imptot as dec
       .
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



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
DEFINE INPUT PARAMETER pTipoDocumentos AS CHAR.

/*
    pTipoDocumentos : C = Documentos de contingencia
                      E = Documentos Electronicos
                      X|dd|mm|aaaa = Documentos Electronicos (Excepcion 2020 - )
                      <> C : Documentos electronicos
*/

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE NEW SHARED VAR s-coddiv AS CHAR.

DEFINE SHARED VAR hSocket AS HANDLE NO-UNDO.
DEFINE SHARED VAR hWebService AS HANDLE NO-UNDO.
DEFINE SHARED VAR hPortType AS HANDLE NO-UNDO.
DEFINE VAR hProc AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-excel
    FIELD   tt-coddiv   AS CHAR     FORMAT 'x(6)'       COLUMN-LABEL "Division"
    FIELD   tt-coddoc   AS CHAR     FORMAT 'x(4)'       COLUMN-LABEL "Tipo Doc."
    FIELD   tt-nrodoc   AS CHAR     FORMAT 'x(15)'      COLUMN-LABEL "Nro.Doc"
    FIELD   tt-estado   AS CHAR     FORMAT 'x(5)'       COLUMN-LABEL "Estado"
    FIELD   tt-fchdoc   AS DATE                         COLUMN-LABEL "F.Emision"
    FIELD   tt-codcli   AS CHAR     FORMAT 'x(11)'      COLUMN-LABEL "Cod.Cliente"
    FIELD   tt-nomcli   AS CHAR     FORMAT 'x(80)'      COLUMN-LABEL "Nombre del Cliente"
    FIELD   tt-ruc      AS CHAR     FORMAT 'x(11)'      COLUMN-LABEL "R.U.C."
    FIELD   tt-mone     AS CHAR     FORMAT 'x(10)'      COLUMN-LABEL "Moneda"
    FIELD   tt-impte    AS DEC      FORMAT '->>,>>>,>>9.99'     COLUMN-LABEL "Importe"
    FIELD   tt-tcmb     AS DEC      FORMAT '->>,>>9.9999'       COLUMN-LABEL "Tipo Cambio"
    FIELD   tt-flgppll  AS INT      FORMAT '>99'        COLUMN-LABEL "Flag PPLL"
    FIELD   tt-ppll     AS CHAR     FORMAT 'x(150)'     COLUMN-LABEL "Mensaje PPLL"
    FIELD   tt-flgsunat AS INT      FORMAT '>99'        COLUMN-LABEL "SUNAT / 1=Aceptado"
    FIELD   tt-sunat    AS CHAR     FORMAT 'x(150)'     COLUMN-LABEL "Mensaje SUNAT".

DEFINE VAR x-dobleclick AS LOG INIT NO.


DEFINE VAR x-es-contingencia AS LOG INIT NO.
IF pTipoDocumentos = 'C' THEN x-es-contingencia = YES.

/* SORT */
define var x-sort-direccion as char init "".
define var x-sort-column as char init "".
define var x-sort-command as char init "".

DEFINE VAR x-sort-acumulativo AS LOG INIT NO.
DEFINE VAR x-sort-color-reset AS LOG INIT YES.

DEFINE TEMP-TABLE t-w-report LIKE w-report.

/* Para verificar el servidor del proveedor electronico */
DEFINE BUFFER z-factabla FOR factabla.

DEFINE STREAM report-txt.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-Comprobantes

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 T-Comprobantes.FlagPPLL ~
T-Comprobantes.CodDiv T-Comprobantes.libre_c11 T-Comprobantes.CodDoc ~
T-Comprobantes.NroDoc sestado @ sestado fchdoc @ fchdoc imptot @ imptot ~
T-Comprobantes.libre_c10 T-Comprobantes.LogDate T-Comprobantes.LogEstado ~
T-Comprobantes.libre_c05 T-Comprobantes.libre_c06 T-Comprobantes.libre_c01 ~
T-Comprobantes.libre_c02 T-Comprobantes.libre_c03 T-Comprobantes.libre_c04 ~
T-Comprobantes.libre_c09 T-Comprobantes.libre_c07 T-Comprobantes.libre_c08 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH T-Comprobantes NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH T-Comprobantes NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 T-Comprobantes
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 T-Comprobantes


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-cuales RADIO-SET-sunat TOGGLE-bz ~
RADIO-SET-origen BUTTON-27 EDITOR-msg BUTTON-21 BUTTON-22 BUTTON-Division ~
txtDesde txtHasta ChkFac ChkBol ChkN_C ChkN_D BUTTON-19 txtEmpieze BROWSE-4 ~
BUTTON-24 rdFiltro BUTTON-28 BUTTON-29 BUTTON-30 BUTTON-31 BUTTON-32 ~
txtDivVenta 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-prov-electronico RADIO-SET-cuales ~
FILL-IN-tipo RADIO-SET-sunat TOGGLE-bz RADIO-SET-origen EDITOR-msg x-CodDiv ~
txtDesde txtHasta ChkFac ChkBol ChkN_C ChkN_D txtEmpieze rdFiltro ~
txtDivVenta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-19 
     LABEL "Buscar" 
     SIZE 15.14 BY .92.

DEFINE BUTTON BUTTON-20 
     LABEL "Generar solo XML" 
     SIZE 18 BY .96.

DEFINE BUTTON BUTTON-21 
     LABEL "Corregir nombres" 
     SIZE 17 BY 1.04.

DEFINE BUTTON BUTTON-22 
     LABEL "Re-enviar documentos seleccionados a BIZLINKS" 
     SIZE 37 BY .96.

DEFINE BUTTON BUTTON-24 
     LABEL "Relanzar documentos" 
     SIZE 20 BY 1.04.

DEFINE BUTTON BUTTON-25 
     LABEL "Obtener el CDR de SUNAT" 
     SIZE 21 BY 1.04.

DEFINE BUTTON BUTTON-27 
     LABEL "Refrescar fila actual" 
     SIZE 24 BY 1.12.

DEFINE BUTTON BUTTON-28 
     LABEL "Refrescar toda la pantalla" 
     SIZE 24 BY 1.12.

DEFINE BUTTON BUTTON-29 
     LABEL "Enviar a Bizlinks Test - Arimetica" 
     SIZE 23.86 BY .96.

DEFINE BUTTON BUTTON-30 
     LABEL "Generar XML - Arimetica" 
     SIZE 18 BY .96.

DEFINE BUTTON BUTTON-31 
     LABEL "BIZLINKS pruebas SIN ARIMETICA" 
     SIZE 26 BY .96.

DEFINE BUTTON BUTTON-32 
     LABEL "BIZLINKS pruebas CON ARIMETICA" 
     SIZE 26 BY .96.

DEFINE BUTTON BUTTON-Division 
     LABEL "..." 
     SIZE 4 BY .77 TOOLTIP "Selecciona Divisiones".

DEFINE BUTTON BUTTON-TXT 
     LABEL "Enviar a TXT registros" 
     SIZE 19.29 BY .96.

DEFINE VARIABLE EDITOR-msg AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 52.43 BY 2.31
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE x-CodDiv AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 62 BY 2.88
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-prov-electronico AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor Electronico" 
     VIEW-AS FILL-IN 
     SIZE 57.43 BY .81
     FGCOLOR 9 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .92
     FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidas Desde" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .81 NO-UNDO.

DEFINE VARIABLE txtDivVenta AS CHARACTER FORMAT "X(8)":U 
     LABEL "Division venta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE txtEmpieze AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nro. empiezen en" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY .81 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-cuales AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Solo Anulados", 2,
"Solo Validos", 3
     SIZE 40 BY .96 NO-UNDO.

DEFINE VARIABLE RADIO-SET-origen AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Tiendas Mayoristas", 2,
"Utilex", 3,
"CDs", 4
     SIZE 48 BY .77 NO-UNDO.

DEFINE VARIABLE RADIO-SET-sunat AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos los estado ", 1,
"AC_03 : Aceptado por Sunat", 2,
"RC_05 : Rechazado por Sunat", 3,
"ED_06 : Enviando a SUNAT", 4,
"PE_09 : Pendiente de envio en resumen", 5,
"PE_02 : Esperando respuesta de Sunat", 6,
"ERROR : Error de envio", 7
     SIZE 35 BY 4.73 NO-UNDO.

DEFINE VARIABLE rdFiltro AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", 1,
"Enviados a PSE/OSE", 2,
"No enviados a PSE/OSE", 3,
"Enviados sin respuesta", 4
     SIZE 24 BY 3.19 NO-UNDO.

DEFINE VARIABLE chbReprocesa AS LOGICAL INITIAL no 
     LABEL "Reprocesar los OK" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .77 NO-UNDO.

DEFINE VARIABLE ChkBol AS LOGICAL INITIAL yes 
     LABEL "Boletas" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE ChkFac AS LOGICAL INITIAL yes 
     LABEL "Facturas" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE ChkN_C AS LOGICAL INITIAL no 
     LABEL "Nota Credito" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.57 BY .77 NO-UNDO.

DEFINE VARIABLE ChkN_D AS LOGICAL INITIAL no 
     LABEL "Nota Debito" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.57 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-bz AS LOGICAL INITIAL no 
     LABEL "Solo Bizlinks" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      T-Comprobantes SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      T-Comprobantes.FlagPPLL COLUMN-LABEL "Item" FORMAT ">>>,>>9":U
            WIDTH 6.43
      T-Comprobantes.CodDiv FORMAT "x(5)":U WIDTH 5.57 LABEL-BGCOLOR 8
      T-Comprobantes.libre_c11 COLUMN-LABEL "Divi!Venta" FORMAT "x(8)":U
            WIDTH 6.29
      T-Comprobantes.CodDoc FORMAT "x(3)":U
      T-Comprobantes.NroDoc FORMAT "X(12)":U WIDTH 10.14
      sestado @ sestado COLUMN-LABEL "Estado" FORMAT "x(3)":U
      fchdoc @ fchdoc COLUMN-LABEL "Emitido" FORMAT "99/99/9999":U
            WIDTH 9.14
      imptot @ imptot COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
            WIDTH 9.14
      T-Comprobantes.libre_c10 COLUMN-LABEL "Tipo de Venta" FORMAT "x(15)":U
            WIDTH 19.57
      T-Comprobantes.LogDate FORMAT "99/99/9999 HH:MM:SS.SSS":U
      T-Comprobantes.LogEstado COLUMN-LABEL "PSE / OSE" FORMAT "x(60)":U
            WIDTH 15.43
      T-Comprobantes.libre_c05 COLUMN-LABEL "Nro. ENVIO" FORMAT "x(13)":U
            WIDTH 11.29
      T-Comprobantes.libre_c06 COLUMN-LABEL "Nro BAJA" FORMAT "x(13)":U
            WIDTH 11.29
      T-Comprobantes.libre_c01 COLUMN-LABEL "Estado BZLNKS" FORMAT "x(15)":U
      T-Comprobantes.libre_c02 COLUMN-LABEL "Estado SUNAT" FORMAT "x(15)":U
      T-Comprobantes.libre_c03 COLUMN-LABEL "Estado Documento" FORMAT "x(50)":U
            WIDTH 34.43
      T-Comprobantes.libre_c04 COLUMN-LABEL "Resultado de envio" FORMAT "x(200)":U
            WIDTH 68.14
      T-Comprobantes.libre_c09 COLUMN-LABEL "R.U.C." FORMAT "x(12)":U
      T-Comprobantes.libre_c07 COLUMN-LABEL "D.N.I" FORMAT "x(8)":U
            WIDTH 10
      T-Comprobantes.libre_c08 COLUMN-LABEL "Cliente" FORMAT "x(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 191 BY 18.27
         FONT 4 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-TXT AT ROW 24.35 COL 120.14 WIDGET-ID 178
     FILL-IN-prov-electronico AT ROW 5.04 COL 59 COLON-ALIGNED WIDGET-ID 176
     RADIO-SET-cuales AT ROW 4.96 COL 2 NO-LABEL WIDGET-ID 170
     FILL-IN-tipo AT ROW 1.04 COL 16.43 COLON-ALIGNED NO-LABEL WIDGET-ID 166
     RADIO-SET-sunat AT ROW 1.08 COL 155.29 NO-LABEL WIDGET-ID 158
     TOGGLE-bz AT ROW 4.73 COL 140 WIDGET-ID 156
     RADIO-SET-origen AT ROW 4 COL 72.29 NO-LABEL WIDGET-ID 150
     BUTTON-27 AT ROW 25.42 COL 112.72 WIDGET-ID 146
     EDITOR-msg AT ROW 24.46 COL 141 NO-LABEL WIDGET-ID 138
     chbReprocesa AT ROW 25.62 COL 2 WIDGET-ID 134
     BUTTON-21 AT ROW 24.35 COL 26.14 WIDGET-ID 114
     BUTTON-22 AT ROW 25.54 COL 49.43 WIDGET-ID 116
     x-CodDiv AT ROW 2 COL 2 NO-LABEL WIDGET-ID 92
     BUTTON-Division AT ROW 2.08 COL 64.86 WIDGET-ID 78
     txtDesde AT ROW 1.12 COL 86.43 COLON-ALIGNED WIDGET-ID 98
     txtHasta AT ROW 1.12 COL 105.43 COLON-ALIGNED WIDGET-ID 100
     ChkFac AT ROW 2.08 COL 75.14 WIDGET-ID 102
     ChkBol AT ROW 2.08 COL 86.43 WIDGET-ID 104
     ChkN_C AT ROW 2.08 COL 98.72 WIDGET-ID 106
     ChkN_D AT ROW 2.08 COL 112.29 WIDGET-ID 108
     BUTTON-19 AT ROW 4.77 COL 123.29 WIDGET-ID 86
     BUTTON-20 AT ROW 24.42 COL 5.86 WIDGET-ID 88
     txtEmpieze AT ROW 3 COL 101.57 COLON-ALIGNED WIDGET-ID 110
     BROWSE-4 AT ROW 6 COL 2 WIDGET-ID 200
     BUTTON-24 AT ROW 24.35 COL 44.43 WIDGET-ID 124
     BUTTON-25 AT ROW 25.42 COL 137 WIDGET-ID 132
     rdFiltro AT ROW 1.08 COL 128.29 NO-LABEL WIDGET-ID 118
     BUTTON-28 AT ROW 25.46 COL 87.86 WIDGET-ID 148
     BUTTON-29 AT ROW 25.54 COL 24.14 WIDGET-ID 168
     BUTTON-30 AT ROW 25.54 COL 5 WIDGET-ID 174
     BUTTON-31 AT ROW 24.42 COL 65.43 WIDGET-ID 180
     BUTTON-32 AT ROW 24.42 COL 92.72 WIDGET-ID 182
     txtDivVenta AT ROW 3.04 COL 75 COLON-ALIGNED WIDGET-ID 186
     "División emision:" VIEW-AS TEXT
          SIZE 12.57 BY .5 AT ROW 1.31 COL 2.43 WIDGET-ID 94
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.14 ROW 1
         SIZE 193.29 BY 26
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-Comprobantes T "NEW SHARED" NO-UNDO INTEGRAL FELogComprobantes
      ADDITIONAL-FIELDS:
          field sactualizar as char init ''
          field fchdoc as date
          field sestado as char
          field imptot as dec
          
      END-FIELDS.
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "SUNAT - DOCUMENTOS EMITIDOS"
         HEIGHT             = 26
         WIDTH              = 193.29
         MAX-HEIGHT         = 39.12
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 39.12
         VIRTUAL-WIDTH      = 274.29
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
/* BROWSE-TAB BROWSE-4 txtEmpieze F-Main */
ASSIGN 
       BROWSE-4:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR BUTTON BUTTON-20 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-20:HIDDEN IN FRAME F-Main           = TRUE.

ASSIGN 
       BUTTON-21:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-25 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-25:HIDDEN IN FRAME F-Main           = TRUE.

ASSIGN 
       BUTTON-30:HIDDEN IN FRAME F-Main           = TRUE.

ASSIGN 
       BUTTON-31:HIDDEN IN FRAME F-Main           = TRUE.

ASSIGN 
       BUTTON-32:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-TXT IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-TXT:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX chbReprocesa IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       chbReprocesa:HIDDEN IN FRAME F-Main           = TRUE.

ASSIGN 
       EDITOR-msg:AUTO-INDENT IN FRAME F-Main      = TRUE
       EDITOR-msg:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-prov-electronico IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tipo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR x-CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.T-Comprobantes"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-Comprobantes.FlagPPLL
"FlagPPLL" "Item" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-Comprobantes.CodDiv
"CodDiv" ? ? "character" ? ? ? 8 ? ? no ? no no "5.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-Comprobantes.libre_c11
"libre_c11" "Divi!Venta" "x(8)" "character" ? ? ? ? ? ? no ? no no "6.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.T-Comprobantes.CodDoc
     _FldNameList[5]   > Temp-Tables.T-Comprobantes.NroDoc
"NroDoc" ? "X(12)" "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"sestado @ sestado" "Estado" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fchdoc @ fchdoc" "Emitido" "99/99/9999" ? ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"imptot @ imptot" "Importe" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-Comprobantes.libre_c10
"libre_c10" "Tipo de Venta" "x(15)" "character" ? ? ? ? ? ? no ? no no "19.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = Temp-Tables.T-Comprobantes.LogDate
     _FldNameList[11]   > Temp-Tables.T-Comprobantes.LogEstado
"LogEstado" "PSE / OSE" "x(60)" "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-Comprobantes.libre_c05
"libre_c05" "Nro. ENVIO" "x(13)" "character" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.T-Comprobantes.libre_c06
"libre_c06" "Nro BAJA" "x(13)" "character" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.T-Comprobantes.libre_c01
"libre_c01" "Estado BZLNKS" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.T-Comprobantes.libre_c02
"libre_c02" "Estado SUNAT" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.T-Comprobantes.libre_c03
"libre_c03" "Estado Documento" ? "character" ? ? ? ? ? ? no ? no no "34.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.T-Comprobantes.libre_c04
"libre_c04" "Resultado de envio" "x(200)" "character" ? ? ? ? ? ? no ? no no "68.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.T-Comprobantes.libre_c09
"libre_c09" "R.U.C." "x(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.T-Comprobantes.libre_c07
"libre_c07" "D.N.I" "x(8)" "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.T-Comprobantes.libre_c08
"libre_c08" "Cliente" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* SUNAT - DOCUMENTOS EMITIDOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* SUNAT - DOCUMENTOS EMITIDOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON LEFT-MOUSE-DBLCLICK OF BROWSE-4 IN FRAME F-Main
DO:
  IF NOT AVAILABLE T-Comprobantes THEN RETURN.
  /*RUN sunat\d-verifica-sunat ( INPUT ROWID(T-Comprobantes) ).*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-4 IN FRAME F-Main
DO:

    IF NOT AVAILABLE T-Comprobantes THEN RETURN.

    DEFINE VAR x-coddiv AS CHAR.
    DEFINE VAR x-coddoc AS CHAR.
    DEFINE VAR x-nrodoc AS CHAR.
    DEFINE VAR x-contingencia AS CHAR INIT "".

    IF t-comprobantes.sestado <> "A" THEN DO:
                
        IF T-Comprobantes.LogEstado = "ENVIADO A PPL" OR 
                        (T-Comprobantes.LogEstado = "ENVIADO A BIZLINKS" AND (t-comprobantes.libre_c01 <> "MISSING" AND t-comprobantes.libre_c01 <> "ERROR"))
                                                                              THEN DO:
            MESSAGE "Documento ya fue enviado al PSE/OSE" VIEW-AS ALERT-BOX INFORMATION.
        END.
        ELSE DO:

            IF t-comprobantes.libre_c01 = "ERROR" THEN DO:
                IF CAPS(USERID("DICTDB")) = "ADMIN" OR CAPS(USERID("DICTDB")) = "MASTER" THEN DO:
                    /* Anular en FELOGCOMPROBANTES */
                    FIND FIRST felogcomprobantes WHERE felogcomprobantes.codcia = s-codcia AND
                                                    felogcomprobantes.coddoc = T-Comprobantes.coddoc AND
                                                    felogcomprobantes.nrodoc = T-Comprobantes.nrodoc EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAILABLE felogcomprobantes THEN DO:
                        ASSIGN felogcomprobantes.coddoc = TRIM(T-Comprobantes.coddoc) + "XX".
                    END.
                END.
            END.

            MESSAGE 'Seguro de generar archivo de (' + T-Comprobantes.coddoc + ' ' + T-Comprobantes.nrodoc + ')?' VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.

            IF rpta = YES THEN DO:

                DEFINE VAR x-retval AS CHAR NO-UNDO.

                IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
                x-dobleclick = YES.
                /* RUN generar-file-txt. */

                x-coddiv = T-Comprobantes.coddiv.
                x-coddoc = T-Comprobantes.coddoc.
                x-nrodoc = T-Comprobantes.nrodoc.

                s-coddiv = x-coddiv.

                x-contingencia = pTipoDocumentos.
                IF x-es-contingencia = YES THEN x-contingencia = "CONTINGENCIA".
                
                RUN sunat\progress-to-bz-arimetica.r( INPUT x-CodDiv,
                                                INPUT x-CodDoc,
                                                INPUT x-NroDoc,
                                                INPUT-OUTPUT TABLE T-FELogErrores,
                                                OUTPUT x-retval,
                                                INPUT-OUTPUT x-contingencia).                
                
                x-dobleclick = NO.
                ASSIGN T-Comprobantes.libre_c04 = x-retval.

                IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                                

                RUN estado-documento.

                BROWSE-4:REFRESH() IN FRAME {&FRAME-NAME}.

            END.
        END.
    END.
    ELSE DO:
        MESSAGE "Documento esta anulado." VIEW-AS ALERT-BOX INFORMATION.
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON RIGHT-MOUSE-DBLCLICK OF BROWSE-4 IN FRAME F-Main
DO:
  IF NOT AVAILABLE T-Comprobantes THEN RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON START-SEARCH OF BROWSE-4 IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    DEFINE VAR n_cols_browse AS INT NO-UNDO.
    DEFINE VAR n_celda AS WIDGET-HANDLE NO-UNDO.

    hSortColumn = BROWSE BROWSE-4:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).

    IF lColumName = 'acubon' THEN DO:
        MESSAGE "Columna imposible de Ordenar".
        RETURN NO-APPLY.
    END.

    IF lColumName = 'x-subzona' THEN lColumName = 'csubzona'.
    IF lColumName = 'x-zona' THEN lColumName = 'czona'.

    x-sort-command = "BY " + lColumName.

    IF x-sort-acumulativo = NO THEN DO:
        IF CAPS(x-sort-command) = CAPS(x-sort-column) THEN DO:
            x-sort-command = "BY " + lColumName + " DESC".
        END.
        ELSE DO:
            x-sort-command = "BY " + lColumName + " DESC".
            IF CAPS(x-sort-command) = CAPS(x-sort-column) THEN DO:
                x-sort-command = "BY " + lColumName.
            END.
            ELSE x-sort-command = "BY " + lColumName.
        END.
        x-sort-column = x-sort-command.

        x-sort-color-reset = YES.
    END.
    ELSE DO:
        x-sort-command = "BY " + lColumName + " DESC".

        IF INDEX(x-sort-column,x-sort-command) > 0 THEN DO:
            x-sort-column = REPLACE(x-sort-column,x-sort-command,"BY " + lColumName).
        END.
        ELSE DO:
            x-sort-command = "BY " + lColumName.
            IF INDEX(x-sort-column,x-sort-command) > 0 THEN DO:
                x-sort-column = REPLACE(x-sort-column,x-sort-command,"BY " + lColumName + " DESC").
            END.
            ELSE DO:
                x-sort-column = x-sort-column + " " + x-sort-command.
            END.
        END.
        x-sort-command = x-sort-column.
    END.
    
    /*EACH Temp-Tables.T-Comprobantes NO-LOCK INDEXED-REPOSITION*/

    hQueryHandle = BROWSE BROWSE-4:QUERY.
    hQueryHandle:QUERY-CLOSE().
    /* *--- Este valor debe ser el QUERY que esta definido en el BROWSE. */   
    hQueryHandle:QUERY-PREPARE("FOR EACH T-Comprobantes NO-LOCK " + x-sort-command).
    hQueryHandle:QUERY-OPEN().
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON VALUE-CHANGED OF BROWSE-4 IN FRAME F-Main
DO:
  editor-msg:SCREEN-VALUE = t-comprobantes.libre_c04.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-19
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-19 W-Win
ON CHOOSE OF BUTTON-19 IN FRAME F-Main /* Buscar */
DO:
  ASSIGN  x-CodDiv txtDesde txtHasta rdFiltro /*RADIO-SET-quienes*/ /*rbReferencia*/.
  ASSIGN chkFac ChkBol ChkN_C chkN_D txtEmpieze radio-set-origen toggle-bz radio-set-sunat.
  ASSIGN radio-set-cuales txtDivVenta.

  RUN servidor-proveedor-electronico.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').
  {&OPEN-QUERY-{&BROWSE-NAME}}
  MESSAGE "Proceso Terminado" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-20 W-Win
ON CHOOSE OF BUTTON-20 IN FRAME F-Main /* Generar solo XML */
DO:
    /*  RUN Actualizar-Base.*/

    IF AVAILABLE T-Comprobantes THEN DO:
        DEFINE VAR x-retval AS CHAR NO-UNDO.
        DEFINE VAR x-coddoc AS CHAR NO-UNDO.
        DEFINE VAR x-nrodoc AS CHAR NO-UNDO.
        DEFINE VAR x-coddiv AS CHAR NO-UNDO INIT "".
        DEFINE VAR x-contingencia AS CHAR.

        x-coddiv = T-Comprobantes.coddiv.
        x-coddoc = T-Comprobantes.coddoc.
        x-nrodoc = T-Comprobantes.nrodoc.

        x-contingencia = "XML".
        IF x-es-contingencia = YES THEN x-contingencia = "XMLCONTINGENCIA".

        IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.

        RUN sunat\progress-to-bz.r( INPUT x-CodDiv,
                                        INPUT x-CodDoc,
                                        INPUT x-NroDoc,
                                        INPUT-OUTPUT TABLE T-FELogErrores,
                                        OUTPUT x-retval,
                                        INPUT-OUTPUT x-contingencia ).

        IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                                

        MESSAGE x-retval.

        /*
        RUN sunat\facturacion-electronica-bz.r( INPUT x-CodDoc,
                                        INPUT x-NroDoc,
                                        INPUT x-CodDiv,
                                        OUTPUT x-retval ).

        MESSAGE x-retval.
        */

    END.
END.

/*
                DEFINE VAR x-retval AS CHAR NO-UNDO.

                IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
                x-dobleclick = YES.
                /* RUN generar-file-txt. */

                RUN sunat\progress-to-bz.r( INPUT T-Comprobantes.CodDiv,
                                                INPUT T-Comprobantes.CodDoc,
                                                INPUT T-Comprobantes.NroDoc,
                                                INPUT-OUTPUT TABLE T-FELogErrores,
                                                OUTPUT x-retval).                

                x-dobleclick = NO.
                ASSIGN T-Comprobantes.libre_c04 = x-retval.

                IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                                

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-21
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-21 W-Win
ON CHOOSE OF BUTTON-21 IN FRAME F-Main /* Corregir nombres */
DO:
    /*
    ASSIGN chbReprocesa.
  RUN estado-sunat.
  */
RUN corregir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-22
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-22 W-Win
ON CHOOSE OF BUTTON-22 IN FRAME F-Main /* Re-enviar documentos seleccionados a BIZLINKS */
DO:
  /*
  RUN ue-enviar-a-ppl.
  */
  IF AVAILABLE T-Comprobantes THEN DO:
      RUN ue-enviar-a-bizlinks.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-24
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-24 W-Win
ON CHOOSE OF BUTTON-24 IN FRAME F-Main /* Relanzar documentos */
DO:

  RUN relanzar-documentos.

  APPLY 'CHOOSE':U TO button-24 IN FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-25
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-25 W-Win
ON CHOOSE OF BUTTON-25 IN FRAME F-Main /* Obtener el CDR de SUNAT */
DO:
  RUN ue-cdr-sunat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-27
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-27 W-Win
ON CHOOSE OF BUTTON-27 IN FRAME F-Main /* Refrescar fila actual */
DO:

    IF AVAILABLE T-Comprobantes THEN DO:
        RUN estado-documento.

        /*{&open-query-browse-4}           */
        BROWSE-4:REFRESH() IN FRAME {&FRAME-NAME}.

    END.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-28
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-28 W-Win
ON CHOOSE OF BUTTON-28 IN FRAME F-Main /* Refrescar toda la pantalla */
DO:

    IF AVAILABLE T-Comprobantes THEN DO:
        SESSION:SET-WAIT-STATE("GENERAL").

        FOR EACH T-Comprobantes :
            RUN estado-documento.
        END.

        BROWSE-4:REFRESH() IN FRAME {&FRAME-NAME}.

        SESSION:SET-WAIT-STATE("").
    END.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-29
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-29 W-Win
ON CHOOSE OF BUTTON-29 IN FRAME F-Main /* Enviar a Bizlinks Test - Arimetica */
DO:
    IF CAPS(USERID("DICTDB")) = "ADMIN" OR CAPS(USERID("DICTDB")) = "MASTER" THEN DO:

        RUN ue-enviar-a-bizlinks-test.
        /*
        IF AVAILABLE T-Comprobantes THEN DO:
            DEFINE VAR x-retval AS CHAR NO-UNDO.
            DEFINE VAR x-coddoc AS CHAR NO-UNDO.
            DEFINE VAR x-nrodoc AS CHAR NO-UNDO.
            DEFINE VAR x-coddiv AS CHAR NO-UNDO INIT "".
            DEFINE VAR x-contingencia AS CHAR.

            x-coddiv = T-Comprobantes.coddiv.
            x-coddoc = T-Comprobantes.coddoc.
            x-nrodoc = T-Comprobantes.nrodoc.

            x-contingencia = "XMLTEST".
            IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
            RUN sunat\progress-to-bz-arimetica.r( INPUT x-CodDiv,
                                            INPUT x-CodDoc,
                                            INPUT x-NroDoc,
                                            INPUT-OUTPUT TABLE T-FELogErrores,
                                            OUTPUT x-retval,
                                            INPUT-OUTPUT x-contingencia ).

            IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                                
            MESSAGE x-retval.
        END.
        */
    END.
  
END.

/*
DEFINE INPUT PARAMETER pTipoDocmto AS CHAR.
DEFINE INPUT PARAMETER pNroDocmto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pReturn AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pOtros AS CHAR NO-UNDO.

*/

/*
                DEFINE VAR x-retval AS CHAR NO-UNDO.

                IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
                x-dobleclick = YES.
                /* RUN generar-file-txt. */

                RUN sunat\progress-to-bz.r( INPUT T-Comprobantes.CodDiv,
                                                INPUT T-Comprobantes.CodDoc,
                                                INPUT T-Comprobantes.NroDoc,
                                                INPUT-OUTPUT TABLE T-FELogErrores,
                                                OUTPUT x-retval).                

                x-dobleclick = NO.
                ASSIGN T-Comprobantes.libre_c04 = x-retval.

                IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                                

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-30
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-30 W-Win
ON CHOOSE OF BUTTON-30 IN FRAME F-Main /* Generar XML - Arimetica */
DO:
    /*  RUN Actualizar-Base.*/
    IF CAPS(USERID("DICTDB")) = "ADMIN" OR CAPS(USERID("DICTDB")) = "MASTER" THEN DO:
        IF AVAILABLE T-Comprobantes THEN DO:
            DEFINE VAR x-retval AS CHAR NO-UNDO.
            DEFINE VAR x-coddoc AS CHAR NO-UNDO.
            DEFINE VAR x-nrodoc AS CHAR NO-UNDO.
            DEFINE VAR x-coddiv AS CHAR NO-UNDO INIT "".
            DEFINE VAR x-contingencia AS CHAR.
            DEFINE VAR cOldUser AS CHAR.
    
            x-coddiv = T-Comprobantes.coddiv.
            x-coddoc = T-Comprobantes.coddoc.
            x-nrodoc = T-Comprobantes.nrodoc.
    
            x-contingencia = "XML".
            IF x-es-contingencia = YES THEN x-contingencia = "XMLCONTINGENCIA".
            cOldUser = USERID("DICTDB").
    
            IF USERID("DICTDB") = 'ADMIN' OR USERID("DICTDB") = "MASTER" THEN s-user-id = 'PRUEBASX'.
    
            RUN sunat/facturacion-electronica-bz-arimetica.r(INPUT x-CodDoc , 
                                                    INPUT x-NroDoc , 
                                                    INPUT x-CodDiv ,  
                                                    OUTPUT x-RetVal,
                                                    INPUT-OUTPUT x-contingencia).        
            /*
            RUN sunat\progress-to-bz-v2.r( INPUT x-CodDiv,
                                            INPUT x-CodDoc,
                                            INPUT x-NroDoc,
                                            INPUT-OUTPUT TABLE T-FELogErrores,
                                            OUTPUT x-retval,
                                            INPUT-OUTPUT x-contingencia ).
            */
            IF s-user-id = 'PRUEBASX' THEN s-user-id = cOldUser.
    
            MESSAGE x-retval.
    
            /*
            RUN sunat\facturacion-electronica-bz.r( INPUT x-CodDoc,
                                            INPUT x-NroDoc,
                                            INPUT x-CodDiv,
                                            OUTPUT x-retval ).
    
            MESSAGE x-retval.
            */
    
        END.
    END.
    ELSE DO:
        MESSAGE "Solo valido para usuario ADMIN / MASTER" VIEW-AS ALERT-BOX INFORMATION.
    END.

END.

/*
                DEFINE VAR x-retval AS CHAR NO-UNDO.

                IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
                x-dobleclick = YES.
                /* RUN generar-file-txt. */

                RUN sunat\progress-to-bz.r( INPUT T-Comprobantes.CodDiv,
                                                INPUT T-Comprobantes.CodDoc,
                                                INPUT T-Comprobantes.NroDoc,
                                                INPUT-OUTPUT TABLE T-FELogErrores,
                                                OUTPUT x-retval).                

                x-dobleclick = NO.
                ASSIGN T-Comprobantes.libre_c04 = x-retval.

                IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                                

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-31
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-31 W-Win
ON CHOOSE OF BUTTON-31 IN FRAME F-Main /* BIZLINKS pruebas SIN ARIMETICA */
DO:
  IF CAPS(USERID("DICTDB")) = "ADMIN" OR CAPS(USERID("DICTDB")) = "MASTER" THEN DO:
      IF AVAILABLE T-Comprobantes THEN DO:
          DEFINE VAR x-retval AS CHAR NO-UNDO.
          DEFINE VAR x-coddoc AS CHAR NO-UNDO.
          DEFINE VAR x-nrodoc AS CHAR NO-UNDO.
          DEFINE VAR x-coddiv AS CHAR NO-UNDO INIT "".
          DEFINE VAR x-contingencia AS CHAR.

          x-coddiv = T-Comprobantes.coddiv.
          x-coddoc = T-Comprobantes.coddoc.
          x-nrodoc = T-Comprobantes.nrodoc.

          x-contingencia = "XMLTEST".
          IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
          MESSAGE "SIN ARIMETICA!".              
                   
          RUN sunat\progress-to-bz.r( INPUT x-CodDiv,                    
                                          INPUT x-CodDoc,
                                          INPUT x-NroDoc,
                                          INPUT-OUTPUT TABLE T-FELogErrores,
                                          OUTPUT x-retval,
                                          INPUT-OUTPUT x-contingencia ).

          IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                                
          MESSAGE x-retval.
      END.

  END.
  ELSE DO:
      MESSAGE "Solo valido para usuario ADMIN / MASTER" VIEW-AS ALERT-BOX INFORMATION.
  END.

END.

/*
                DEFINE VAR x-retval AS CHAR NO-UNDO.

                IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
                x-dobleclick = YES.
                /* RUN generar-file-txt. */

                RUN sunat\progress-to-bz.r( INPUT T-Comprobantes.CodDiv,
                                                INPUT T-Comprobantes.CodDoc,
                                                INPUT T-Comprobantes.NroDoc,
                                                INPUT-OUTPUT TABLE T-FELogErrores,
                                                OUTPUT x-retval).                

                x-dobleclick = NO.
                ASSIGN T-Comprobantes.libre_c04 = x-retval.

                IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                                

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-32
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-32 W-Win
ON CHOOSE OF BUTTON-32 IN FRAME F-Main /* BIZLINKS pruebas CON ARIMETICA */
DO:
  IF CAPS(USERID("DICTDB")) = "ADMIN" OR CAPS(USERID("DICTDB")) = "MASTER" THEN DO:
      IF AVAILABLE T-Comprobantes THEN DO:
          DEFINE VAR x-retval AS CHAR NO-UNDO.
          DEFINE VAR x-coddoc AS CHAR NO-UNDO.
          DEFINE VAR x-nrodoc AS CHAR NO-UNDO.
          DEFINE VAR x-coddiv AS CHAR NO-UNDO INIT "".
          DEFINE VAR x-contingencia AS CHAR.

          x-coddiv = T-Comprobantes.coddiv.
          x-coddoc = T-Comprobantes.coddoc.
          x-nrodoc = T-Comprobantes.nrodoc.

          x-contingencia = "XMLTEST".
          IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
          MESSAGE "PRUEBAS CON ARIMETICA!".                                 
          RUN sunat\progress-to-bz-arimetica.r( INPUT x-CodDiv,                    
                                          INPUT x-CodDoc,
                                          INPUT x-NroDoc,
                                          INPUT-OUTPUT TABLE T-FELogErrores,
                                          OUTPUT x-retval,
                                          INPUT-OUTPUT x-contingencia ).

          IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                                
          MESSAGE x-retval.
      END.

  END.
  ELSE DO:
      MESSAGE "Solo valido para usuario ADMIN / MASTER" VIEW-AS ALERT-BOX INFORMATION.
  END.

END.

/*
                DEFINE VAR x-retval AS CHAR NO-UNDO.

                IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
                x-dobleclick = YES.
                /* RUN generar-file-txt. */

                RUN sunat\progress-to-bz.r( INPUT T-Comprobantes.CodDiv,
                                                INPUT T-Comprobantes.CodDoc,
                                                INPUT T-Comprobantes.NroDoc,
                                                INPUT-OUTPUT TABLE T-FELogErrores,
                                                OUTPUT x-retval).                

                x-dobleclick = NO.
                ASSIGN T-Comprobantes.libre_c04 = x-retval.

                IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                                

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Division W-Win
ON CHOOSE OF BUTTON-Division IN FRAME F-Main /* ... */
DO:
    ASSIGN x-CodDiv.
    RUN gn/d-filtro-divisiones (INPUT-OUTPUT x-CodDiv, "SELECCIONE LAS DIVISIONES").
    DISPLAY x-CodDiv WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-TXT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-TXT W-Win
ON CHOOSE OF BUTTON-TXT IN FRAME F-Main /* Enviar a TXT registros */
DO:
  RUN generar-archivo-texto.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualizar-Base W-Win 
PROCEDURE Actualizar-Base :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Seguro de realizar proceso?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH T-Comprobantes WHERE t-comprobantes.sactualizar = 'SUNAT',
    FIRST FELogComprobantes WHERE FELogComprobantes.CodCia = T-Comprobantes.CodCia
    AND FELogComprobantes.Coddiv = T-Comprobantes.Coddiv
    AND FELogComprobantes.CodDoc = T-Comprobantes.CodDoc
    AND FELogComprobantes.NroDoc = T-Comprobantes.NroDoc:
    ASSIGN
        FELogComprobantes.FlagEstado = T-Comprobantes.FlagEstado
        FELogComprobantes.EstadoSunat = T-Comprobantes.EstadoSunat
        FELogComprobantes.FlagSunat = T-Comprobantes.FlagSunat.
END.
EMPTY TEMP-TABLE T-Comprobantes.
{&OPEN-QUERY-{&BROWSE-NAME}}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

/* Cargamos Temporal con la base de datos */
DEF VAR k AS INT NO-UNDO.
DEF VAR Desde AS DATE NO-UNDO.
DEF VAR Hasta AS DATE NO-UNDO.

DEFINE VAR lDocumentos AS CHAR NO-UNDO INIT "".
DEF VAR lSecDoc AS INT NO-UNDO.
DEFINE VAR lCodDocto AS CHAR.
DEFINE VAR lFecha AS DATE.
DEFINE VAR lSerie AS INT.
DEFINE VAR lRef AS CHAR.
DEFINE VAR x-estado-bizlinks AS CHAR.
DEFINE VAR x-estado-sunat AS CHAR.

DEFINE VAR iConteo AS INT.

IF ChkFac = YES THEN lDocumentos = "FAC".
IF ChkBol = YES THEN DO:
    IF lDocumentos <> "" THEN lDocumentos = lDocumentos + ",".
    lDocumentos = lDocumentos + "BOL".
END.
IF Chkn_c = YES THEN DO:
    IF lDocumentos <> "" THEN lDocumentos = lDocumentos + ",".
    lDocumentos = lDocumentos + "N/C".
END.
IF Chkn_d = YES THEN DO:
    IF lDocumentos <> "" THEN lDocumentos = lDocumentos + ",".
    lDocumentos = lDocumentos + "N/D".
END.    

/*  */
EMPTY TEMP-TABLE T-Comprobantes.

SESSION:SET-WAIT-STATE('GENERAL').

DO lFecha = txtDesde TO txtHasta:
    DO k = 1 TO NUM-ENTRIES(x-CodDiv):
        FIND gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = ENTRY(k,x-CodDiv)
            NO-LOCK.

        IF NOT AVAILABLE gn-divi THEN NEXT.
        IF radio-set-origen <> 1 THEN DO:
            /* CDs */
            IF radio-set-origen = 4 AND gn-divi.campo-log[5] = NO THEN NEXT.
            /* Minoristas */
            IF radio-set-origen = 3 AND gn-divi.canalventa <> 'MIN' THEN NEXT.
            /* Lo demas en tienda */
            /*IF radio-set-origen = 2 AND gn-divi.canalventa <> 'TDA' THEN NEXT.*/
        END.

        DO lSecDoc = 1 TO NUM-ENTRIES(lDocumentos):
            lCodDocto = ENTRY(lSecDoc,lDocumentos).
            FOR EACH Ccbcdocu NO-LOCK USE-INDEX llave10 WHERE CcbCDocu.CodCia = s-codcia
                AND CcbCDocu.CodDiv = ENTRY(k,x-CodDiv)
                AND CcbCDocu.FchDoc = lFecha
                AND CcbCDocu.CodDoc = lCodDocto
                AND (txtEmpieze = "" OR CcbCDocu.NroDoc BEGINS txtEmpieze ):

                IF txtDivVenta > "" THEN DO:
                    IF CcbCDocu.divori <> txtDivVenta THEN NEXT.
                END.
                
                IF radio-set-cuales <> 1 THEN DO:
                    IF radio-set-cuales = 2 AND CcbCDocu.flgest <> 'A' THEN NEXT.
                    IF radio-set-cuales = 3 AND CcbCDocu.flgest = 'A' THEN NEXT.
                END.
                
                IF Ccbcdocu.FchDoc < GN-DIVI.Libre_f01 THEN NEXT.

                lSerie = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3)) NO-ERROR.
                FIND FIRST faccorre USE-INDEX llave02 WHERE faccorre.codcia = s-codcia AND
                                faccorre.coddiv = ccbcdocu.coddiv AND 
                                faccorre.coddoc = ccbcdocu.coddoc AND
                                faccorre.nroser = lSerie NO-LOCK NO-ERROR.

                FIND FIRST FELogComprobantes WHERE FELogComprobantes.CodCia = CcbCDocu.CodCia
                    AND FELogComprobantes.CodDiv = CcbCDocu.Coddiv
                    AND FELogComprobantes.CodDoc = CcbCDocu.CodDoc
                    AND FELogComprobantes.NroDoc = CcbCDocu.NroDoc
                    NO-LOCK NO-ERROR.

                IF x-es-contingencia = YES THEN DO:
                    IF AVAILABLE faccorre THEN DO:
                        /*IF faccorre.id_pos = 'MANUAL' AND NOT AVAILABLE FELogComprobantes THEN NEXT.*/
                        IF faccorre.id_pos <> 'MANUAL' THEN NEXT.
                    END.
                END.
                IF x-es-contingencia = NO THEN DO:
                    IF AVAILABLE faccorre THEN DO:
                        IF faccorre.id_pos = 'MANUAL' THEN NEXT.
                    END.

                    IF toggle-bz = TRUE THEN DO:
                        IF AVAILABLE FELogComprobantes THEN DO:
                            IF FELogComprobantes.id_pos <> "BIZLINKS" THEN NEXT.
                        END.
                    END.
                END.

                lRef = 'SI'.

                IF rdFiltro <> 1 THEN DO:
                    /* Enviado */
                    IF rdFiltro = 2 AND NOT AVAILABLE FELogComprobantes THEN NEXT.
                    IF rdFiltro = 3 AND AVAILABLE FELogComprobantes THEN NEXT.
                    IF rdFiltro = 4 AND NOT AVAILABLE FELogComprobantes THEN NEXT.
                END.
                /*
                IF RADIO-SET-quienes <> 1 THEN DO:
                    lRef = 'NO'.
                    IF RADIO-SET-quienes = 2 THEN DO:
                        IF CcbCDocu.impdto > 0 AND CcbCDocu.impdto2 = 0 THEN lRef = 'SI'.
                    END.                         
                    IF RADIO-SET-quienes = 3 THEN DO:
                        IF CcbCDocu.impdto2 > 0 AND CcbCDocu.impdto = 0 THEN lRef = 'SI'.
                    END.
                    IF RADIO-SET-quienes = 4 THEN DO:
                        IF CcbCDocu.impdto2 > 0 AND CcbCDocu.impdto > 0 THEN lRef = 'SI'.
                    END.
                    IF RADIO-SET-quienes = 5 THEN DO:
                        IF (CcbCDocu.impdto2 > 0 OR CcbCDocu.impdto > 0) THEN lRef = 'SI'.
                    END.
                    IF RADIO-SET-quienes = 6 THEN DO:
                        IF CcbCDocu.impexo > 0 THEN lRef = 'SI'.
                    END.
                    IF RADIO-SET-quienes = 7 THEN DO:
                        IF CcbCDocu.fmapgo = "899" THEN lRef = 'SI'.
                    END.
                END.
                */
                IF lRef = 'NO' THEN NEXT.

                /*
                    MESSAGE CcbCDocu.CodDoc SKIP
                        CcbCDocu.NroDoc.

                IF AVAILABLE felogcomprobantes THEN DO:
                    MESSAGE FELogComprobantes.CodDoc SKIP
                        FELogComprobantes.NroDoc.
                END.
                */

                iConteo = iConteo + 1.

                CREATE T-Comprobantes.
                ASSIGN
                    T-Comprobantes.CodCia = CcbCDocu.CodCia
                    T-Comprobantes.CodDiv = CcbCDocu.CodDiv
                    T-Comprobantes.CodDoc = CcbCDocu.CodDoc
                    T-Comprobantes.NroDoc = CcbCDocu.NroDoc
                    T-Comprobantes.LogEstado = "NO ENVIADO"
                    t-comprobantes.sactualizar = 'X'
                    t-comprobantes.fchdoc = CcbCDocu.FchDoc
                    t-comprobantes.sestado = CcbCDocu.flgest
                    t-comprobantes.imptot = ccbcdocu.imptot                                                             
                    t-comprobantes.logdate = IF (AVAILABLE FELogComprobantes) THEN FELogComprobantes.logdate ELSE ?
                    t-comprobantes.libre_c05 = IF (AVAILABLE FELogComprobantes) THEN FELogComprobantes.libre_c01 ELSE ""
                    t-comprobantes.libre_c06 = IF (AVAILABLE FELogComprobantes) THEN FELogComprobantes.libre_c02 ELSE ""
                    t-comprobantes.libre_c07 = CcbCDocu.codant
                    t-comprobantes.libre_c08 = CcbCDocu.nomcli
                    t-comprobantes.libre_c09 = CcbCDocu.ruccli
                    t-comprobantes.libre_c14 = CcbCDocu.codref
                    t-comprobantes.libre_c10 = CcbCDocu.fmapgo + " : NO EXISTE"
                    t-comprobantes.libre_c11 = CcbCDocu.divori
                    t-comprobantes.FlagPPLL = iConteo
                    .

                FIND FIRST gn-convt WHERE gn-convt.codig = CcbCDocu.fmapgo NO-LOCK NO-ERROR.
                IF AVAILABLE gn-convt THEN DO:
                    ASSIGN t-comprobantes.libre_c10 = CcbCDocu.fmapgo + " : TIPO ERRADO".
                    IF gn-convt.tipvta = '1' OR gn-convt.tipvta = '2' THEN DO:
                        ASSIGN t-comprobantes.libre_c10 = CcbCDocu.fmapgo + " : CONTADO".
                        IF gn-convt.tipvta = '2' THEN DO:
                            ASSIGN t-comprobantes.libre_c10 = CcbCDocu.fmapgo + " : CREDITO".
                        END.
                    END.
                END.

                RUN estado-documento.

                /* Sin respuesta */
                IF rdFiltro = 4 THEN DO:
                    IF NOT (TRUE <> (T-Comprobantes.libre_c01 > "")) THEN DO:
                        DELETE T-Comprobantes.
                        NEXT.
                    END.
                END.
                

                IF radio-set-sunat <> 1 THEN DO:
                    IF radio-set-sunat = 2 THEN DO:
                        IF T-Comprobantes.libre_c02 <> "AC_03" THEN DELETE T-Comprobantes.
                    END.                        
                    IF radio-set-sunat = 3 THEN DO:
                        IF T-Comprobantes.libre_c02 <> "RC_05" THEN DELETE T-Comprobantes.
                    END.                        
                    IF radio-set-sunat = 4 THEN DO:
                        IF T-Comprobantes.libre_c02 <> "ED_06" THEN DELETE T-Comprobantes.
                    END.                        
                    IF radio-set-sunat = 5 THEN DO:
                        IF T-Comprobantes.libre_c02 <> "PE_09" THEN DELETE T-Comprobantes.
                    END.                        
                    IF radio-set-sunat = 6 THEN DO:
                        IF T-Comprobantes.libre_c02 <> "PE_02" THEN DELETE T-Comprobantes.
                    END.                        
                    IF radio-set-sunat = 7 THEN DO:
                        IF T-Comprobantes.libre_c01 <> "ERROR" THEN DELETE T-Comprobantes.
                    END.                        
                END.
            END.
        END.
    END.
END.

/* 
    Excepcion envio con Fecha de emision 08/01/2020, 
    por tema de certificado digital
*/
IF ENTRY(1,pTipoDocumentos,"|") = 'X' THEN DO:
    FOR EACH t-comprobantes :
        IF t-comprobantes.libre_c02 <> "RC_05" THEN DO:
            DELETE t-comprobantes.
        END.
    END.
END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.


/*
    x-servidor-ip = "".
    x-servidor-puerto = "".

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE corregir W-Win 
PROCEDURE corregir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE t-w-report.

DEFINE VAR x-totregs AS INT.
DEFINE VAR x-sec AS INT.

SESSION:SET-WAIT-STATE("GENERAL").

DO WITH FRAME {&FRAME-NAME}:

    x-totregs = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO x-sec = 1 TO x-totregs :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(x-sec) THEN DO:
            CREATE t-w-report.
            ASSIGN t-w-report.campo-c[1] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Coddoc
                    t-w-report.campo-c[2] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc
                    t-w-report.campo-c[3] = STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.fchdoc,"99/99/9999")
                    t-w-report.campo-c[5] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c08
                    t-w-report.campo-c[10] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c14
                    .
    
            /*
                cFami = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codfam.
                X-codfam = x-codfam + cComa + cFami.
                cComa = ",".
                */
        END.
    END.
END.

SESSION:SET-WAIT-STATE("").

RUN sunat/d-corregir-razon-social.p(INPUT TABLE t-w-report).


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
  DISPLAY FILL-IN-prov-electronico RADIO-SET-cuales FILL-IN-tipo RADIO-SET-sunat 
          TOGGLE-bz RADIO-SET-origen EDITOR-msg x-CodDiv txtDesde txtHasta 
          ChkFac ChkBol ChkN_C ChkN_D txtEmpieze rdFiltro txtDivVenta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-SET-cuales RADIO-SET-sunat TOGGLE-bz RADIO-SET-origen BUTTON-27 
         EDITOR-msg BUTTON-21 BUTTON-22 BUTTON-Division txtDesde txtHasta 
         ChkFac ChkBol ChkN_C ChkN_D BUTTON-19 txtEmpieze BROWSE-4 BUTTON-24 
         rdFiltro BUTTON-28 BUTTON-29 BUTTON-30 BUTTON-31 BUTTON-32 txtDivVenta 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE envio-a-ppl W-Win 
PROCEDURE envio-a-ppl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR pMensaje AS CHAR.

IF AVAILABLE T-Comprobantes THEN DO:
    IF t-comprobantes.codhash = ? OR t-comprobantes.codhash = "" THEN DO:
        IF t-comprobantes.sactualizar = 'X' THEN DO:
            /* Solo aquellos que no esten en FELOGCOMPROBANTES */
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                        ccbcdocu.coddiv = t-comprobantes.coddiv AND
                                        ccbcdocu.coddoc = t-comprobantes.coddoc AND
                                        ccbcdocu.nrodoc = t-comprobantes.nrodoc AND
                                        ccbcdocu.flgest <> "A" NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN DO:
                
                RUN sunat\progress-to-ppll-v3( INPUT Ccbcdocu.coddiv,
                                               INPUT Ccbcdocu.coddoc,
                                               INPUT Ccbcdocu.nrodoc,
                                               INPUT-OUTPUT TABLE T-FELogErrores,
                                               OUTPUT pMensaje ).
            END.
            ELSE DO:
                pMensaje = "El comprobante no existe o esta ANULADO".
            END.
        END.
        ELSE DO:
            /* 
                El comprobante existe en FELOGCOMPROBANTES sin HASH
                hay que reenviarlo con el mismo IDpos y IPpos
            */
        END.
    END.
    ELSE DO:
        pMensaje = "El comprobante ya tiene HASH".
    END.
END.
ELSE DO:
    pMensaje = "No existe comprobante".
END.
IF x-dobleclick = YES THEN DO:
    MESSAGE pMensaje.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE estado-documento W-Win 
PROCEDURE estado-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-estado-bizlinks AS CHAR INIT "".
DEFINE VAR x-estado-sunat AS CHAR INIT "".
DEFINE VAR x-abreviado AS CHAR INIT "".
DEFINE VAR x-detallado AS CHAR INIT "".
DEFINE VAR x-estado-doc AS CHAR INIT "".

FIND FIRST FELogComprobantes WHERE FELogComprobantes.CodCia = T-Comprobantes.CodCia
    AND FELogComprobantes.CodDiv = T-Comprobantes.Coddiv
    AND FELogComprobantes.CodDoc = T-Comprobantes.CodDoc
    AND FELogComprobantes.NroDoc = T-Comprobantes.NroDoc NO-LOCK NO-ERROR.

IF AVAILABLE FELogComprobantes THEN DO:    
    /*
    MESSAGE T-Comprobantes.CodDoc SKIP
            T-Comprobantes.NroDoc.
    */
    ASSIGN T-Comprobantes.LogEstado = "ENVIADO A PPL"
        T-Comprobantes.id_pos = FELogComprobantes.id_pos
        .    
    IF T-Comprobantes.id_pos = "BIZLINKS" THEN DO:
        ASSIGN T-Comprobantes.LogEstado = "ENVIADO A BIZLINKS"
                t-comprobantes.logdate = FELogComprobantes.logdate
            .  

        x-estado-bizlinks = "".
        x-estado-sunat = "".
        
        RUN gn/p-estado-documento-electronico.r(INPUT T-Comprobantes.CodDoc,
                            INPUT T-Comprobantes.NroDoc,
                            INPUT T-Comprobantes.CodDiv,
                            OUTPUT x-estado-bizlinks,
                            OUTPUT x-estado-sunat,
                            OUTPUT x-estado-doc).
        
        ASSIGN T-Comprobantes.libre_c01 = ENTRY(1,x-estado-bizlinks,"|")
                T-Comprobantes.libre_c02 = ENTRY(1,x-estado-sunat,"|")
                T-Comprobantes.libre_c03 = x-estado-doc
                T-Comprobantes.libre_c15 = ENTRY(2,x-estado-bizlinks,"|").

        
        IF NUM-ENTRIES(x-estado-bizlinks,"|") > 1 THEN DO:
            ASSIGN T-Comprobantes.libre_c04 = ENTRY(2,x-estado-bizlinks,"|").
        END.

        /*
        RUN gn/p-estados-bizlinks-sunat(INPUT x-estado-bizlinks,
                                        INPUT x-estado-sunat,
                                        OUTPUT x-abreviado,
                                        OUTPUT x-detallado).

        IF ENTRY(1,x-estado-bizlinks,"|") = 'SIGNED' THEN DO:
            /*T-Comprobantes.libre_c03 = "FIRMADO".*/
            ASSIGN /*T-Comprobantes.libre_c03 = x-abreviado*/
                    T-Comprobantes.libre_c15 = x-detallado.                
        END.
        */
    END.                        
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE estado-sunat W-Win 
PROCEDURE estado-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Levantamos las rutinas a memoria */
DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR cRetVal AS CHAR.
DEFINE VAR lPreFijoDocmnto AS CHAR.
DEFINE VAR cTipoDocmnto AS CHAR.
DEFINE VAR lNroDocmnto AS CHAR.

MESSAGE 'Seguro de realizar proceso?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

SESSION:SET-WAIT-STATE('GENERAL').
RUN sunat\facturacion-electronica.p PERSISTENT SET hProc.

/*
IF ERROR-STATUS:ERROR = YES THEN DO:
    pCodError = "ERROR en las librerias de la Facturación Electrónica" + CHR(10) +
        "Salir del Sistema, volver a entrar y repetir el proceso".
    RETURN "ADM-ERROR".
END.

cRetVal = "".
RUN pget-estado-doc-eserver IN hProc (INPUT cTipoDocmnto, INPUT lNroDocmnto, OUTPUT cRetVal).

cTipoDocmnto = DYNAMIC-FUNCTION('fget-tipo-documento':U IN hProc, INPUT t-comprobantes.coddoc) .  

*/


RUN pcrea-obj-xml IN hProc.

FOR EACH T-Comprobantes 
    WHERE T-Comprobantes.estadosunat = 0 OR T-Comprobantes.estadosunat > 1
            OR (chbReprocesa = YES AND T-Comprobantes.estadosunat = 1) :
    /*
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
        "SUNAT: " + T-Comprobantes.coddiv + ' '  +
        T-Comprobantes.coddoc + ' ' + T-Comprobantes.nrodoc.
    */
    cRetVal = "".
    RUN pestado-documento-sunat IN hProc 
        (INPUT T-Comprobantes.coddoc, 
         INPUT T-Comprobantes.nrodoc, 
         INPUT T-Comprobantes.coddiv,
         OUTPUT cRetVal).

    IF cRetVal <> "" THEN DO:
        ASSIGN T-Comprobantes.flagsunat = 1
                T-Comprobantes.estadosunat = DEC(ENTRY(1,cretval,"|"))
                T-Comprobantes.flagestado = ENTRY(1,cretval,"|") + " - " + ENTRY(2,cretval,"|").
        ASSIGN t-comprobantes.sactualizar = 'SUNAT'.
    END.

END.

RUN pelimina-obj-xml IN hProc.


DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-archivo-texto W-Win 
PROCEDURE generar-archivo-texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-archivo AS CHAR.
DEFINE VAR x-rpta AS LOG.
DEFINE VAR x-fmto-sunat AS CHAR FORMAT 'x(20)'.
DEFINE VAR x-prefijo-sunat AS CHAR.
DEFINE VAR x-coddoc-sunat AS CHAR.

DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */

x-Archivo = 'RegistrosDelBrowse'.
SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.

IF x-rpta = NO OR x-Archivo = '' THEN RETURN.

RUN gn\master-library.r PERSISTENT SET hProc.

/* Procedimientos */
/*RUN pconecto-epos IN hProc (INPUT lDivision, INPUT lTerminalCaja, OUTPUT cRetVal).    */

SESSION:SET-WAIT-STATE("GENERAL").

OUTPUT STREAM REPORT-txt TO VALUE(x-Archivo).

PUT STREAM REPORT-txt
  "Division|" 
  "CodDoc|"
  "NroDoc|"  
  "Emision|"
    "Importe|"
    "Envio|"
    "Stat.BizLinks|"
    "Stat.Sunat|"
    "Stat.Documento|"
    "FormatoSunat|"
    "CodDocSunat|"
    "R.U.C.|"
    "D.N.I.|"
    "Cliente" SKIP.
FOR EACH t-comprobantes:

    /* Funciones */
    x-prefijo-sunat = DYNAMIC-FUNCTION('fget-prefijo-de-la-serie':U IN hProc, 
                                       INPUT t-comprobantes.coddoc, 
                                       INPUT t-comprobantes.nrodoc, 
                                       INPUT "") .  

    x-fmto-sunat = x-prefijo-sunat + SUBSTRING(t-comprobantes.nrodoc,1,3) + 
                "-" + SUBSTRING(t-comprobantes.nrodoc,4).

    x-coddoc-sunat = "-99".

    CASE t-comprobantes.coddoc:
        WHEN 'FAC' THEN DO:
            x-coddoc-sunat = "01".
        END.
        WHEN 'BOL' OR WHEN 'TCK' THEN DO:
            x-coddoc-sunat = "03".
        END.            
        WHEN 'N/D' THEN do:
            x-coddoc-sunat = "08".
        END.            
        WHEN 'N/C' THEN DO:
            x-coddoc-sunat = "07".
        END.
    END.


    PUT STREAM REPORT-txt
        t-comprobantes.coddiv "|"
        t-comprobantes.coddoc "|"
        t-comprobantes.nrodoc FORMAT 'X(15)' "|"
        t-comprobantes.fchdoc "|"
        t-comprobantes.imptot "|"
        t-comprobantes.logdate "|"
        trim(t-comprobantes.libre_c01) "|"
        trim(t-comprobantes.libre_c02) "|"
        trim(t-comprobantes.libre_c03) FORMAT 'x(25)' "|"
        x-fmto-sunat "|"
        x-coddoc-sunat "|"
        trim(t-comprobantes.libre_c09) FORMAT 'x(15)' "|"
        trim(t-comprobantes.libre_c07) FORMAT 'x(10)' "|"
        trim(t-comprobantes.libre_c08) FORMAT 'x(100)' SKIP
        .
END.

DELETE PROCEDURE hProc.                 /* Release Libreria */

OUTPUT STREAM REPORT-txt CLOSE.

SESSION:SET-WAIT-STATE("").

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-file-txt W-Win 
PROCEDURE generar-file-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-mensaje AS CHAR.
/*
IF AVAILABLE T-Comprobantes THEN DO:
            /* Solo aquellos que no esten en FELOGCOMPROBANTES */
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                ccbcdocu.coddiv = t-comprobantes.coddiv AND
                                ccbcdocu.coddoc = t-comprobantes.coddoc AND
                                ccbcdocu.nrodoc = t-comprobantes.nrodoc AND
                                ccbcdocu.flgest <> "A" NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:
        
        RUN sunat\facturacion-electronicav2.p PERSISTENT SET hProc NO-ERROR.

        IF ERROR-STATUS:ERROR = YES THEN DO:
            MESSAGE "ERROR en las librerias de la Facturación Electrónica" + CHR(10) +
                "Salir del Sistema, volver a entrar y repetir el proceso".
            RETURN "ADM-ERROR".
        END.

        RUN generar-file-contingencia IN hProc ( INPUT Ccbcdocu.coddoc,
                                       INPUT Ccbcdocu.nrodoc,
                                       INPUT Ccbcdocu.coddiv,
                                       INPUT fill-in-mensaje,
                                       OUTPUT x-mensaje ).

        DELETE PROCEDURE hProc.

        IF x-mensaje = 'OK' THEN DO:
            MESSAGE "Generacion OK" VIEW-AS ALERT-BOX INFORMATION.
        END.
        ELSE DO:
            MESSAGE "Hubo ERROR : " + x-mensaje VIEW-AS ALERT-BOX ERROR.
        END.
    END.
    ELSE DO:
        x-mensaje = "El comprobante no existe o esta ANULADO".
    END.
END.
*/

END PROCEDURE.

/*
DEFINE INPUT PARAMETER pTipoDocmto AS CHAR.
DEFINE INPUT PARAMETER pNroDocmto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE INPUT PARAMETER pRutaContingencia AS CHAR.
DEFINE OUTPUT PARAMETER pReturn AS CHAR NO-UNDO.

*/

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

  ASSIGN txtDesde = TODAY - 2
        txtHasta = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  fill-in-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "DOCUMENTOS ELECTRONICOS".
  IF x-es-contingencia = YES THEN DO:
      fill-in-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "DOCUMENTOS DE CONTINGENCIA".
  END.

  RUN servidor-proveedor-electronico.

  button-30:VISIBLE = NO.
  button-31:VISIBLE = NO.
  button-32:VISIBLE = NO.
  button-29:VISIBLE = NO.

  IF USERID("DICTDB") = 'ADMIN' OR USERID("DICTDB") = "MASTER" THEN DO:
      button-30:VISIBLE = YES.
      button-31:VISIBLE = YES.
      button-32:VISIBLE = YES.
      button-29:VISIBLE = YES.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE relanzar-documentos W-Win 
PROCEDURE relanzar-documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE t-w-report.

DEFINE VAR x-totregs AS INT.
DEFINE VAR x-sec AS INT.

SESSION:SET-WAIT-STATE("GENERAL").

DO WITH FRAME {&FRAME-NAME}:

    x-totregs = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO x-sec = 1 TO x-totregs :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(x-sec) THEN DO:
            CREATE t-w-report.
            ASSIGN t-w-report.campo-c[1] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Coddoc
                    t-w-report.campo-c[2] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc
                    t-w-report.campo-c[3] = STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.fchdoc,"99/99/9999")
                    t-w-report.campo-c[4] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.logestado
                    t-w-report.campo-c[5] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c01
                    t-w-report.campo-c[6] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c02
                    t-w-report.campo-c[7] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c03
                    t-w-report.campo-c[8] = "" /*{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c03*/
                    t-w-report.campo-c[9] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c08
                    t-w-report.campo-c[10] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c14
                    .
    
            /*
                cFami = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codfam.
                X-codfam = x-codfam + cComa + cFami.
                cComa = ",".
                */
        END.
    END.
END.

SESSION:SET-WAIT-STATE("").

RUN sunat/d-relanzar-documentos(INPUT TABLE t-w-report).


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
  {src/adm/template/snd-list.i "T-Comprobantes"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE servidor-proveedor-electronico W-Win 
PROCEDURE servidor-proveedor-electronico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-servidor-ip AS CHAR.
DEFINE VAR x-servidor-puerto AS CHAR.

x-servidor-ip = "".
x-servidor-puerto = "".

/* Servidor Webservice BIZLINKS */
/*
FIND FIRST z-factabla WHERE z-factabla.codcia = s-codcia AND 
                            z-factabla.tabla = "CONFIG-FE-BIZLINKS" AND
                            z-factabla.codigo = gn-div.coddiv NO-LOCK NO-ERROR.

IF AVAILABLE z-factabla THEN DO:
    /* De la division */
    x-servidor-ip = TRIM(z-factabla.campo-c[1]).
    x-servidor-puerto = TRIM(z-factabla.campo-c[2]).
END.
*/
FIND FIRST z-factabla WHERE z-factabla.codcia = s-codcia AND 
                            z-factabla.tabla = "CONFIG-FE-BIZLINKS" AND
                            z-factabla.codigo = "TODOS" NO-LOCK NO-ERROR.
IF AVAILABLE z-factabla THEN DO:
    IF TRUE <> (x-servidor-ip > "") THEN DO:
        /*  */
        x-servidor-ip = TRIM(z-factabla.campo-c[1]).
        x-servidor-puerto = TRIM(z-factabla.campo-c[2]).
    END.
END.

fill-in-prov-electronico:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Servidor " + x-servidor-ip + "  Puerto :" + x-servidor-puerto.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cdr-sunat W-Win 
PROCEDURE ue-cdr-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


MESSAGE 'Seguro de GENERAR el CDR de la SUNAT?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

DEFINE VAR lDirectorio AS CHAR. 
    
SYSTEM-DIALOG GET-DIR lDirectorio  
   RETURN-TO-START-DIR 
   TITLE 'Elija el directorio'.

IF lDirectorio = "" OR lDirectorio = ? THEN RETURN.

lDirectorio = lDirectorio + "\".

DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR cRetVal AS CHAR.
DEFINE VAR lRowSele AS INT.
DEFINE VAR lRowSeleTot AS INT.

SESSION:SET-WAIT-STATE('GENERAL').
RUN sunat\facturacion-electronica.p PERSISTENT SET hProc.

/*
IF ERROR-STATUS:ERROR = YES THEN DO:
    pCodError = "ERROR en las librerias de la Facturación Electrónica" + CHR(10) +
        "Salir del Sistema, volver a entrar y repetir el proceso".
    RETURN "ADM-ERROR".
END.

*/

RUN pcrea-obj-xml IN hProc.

/*FOR EACH T-Comprobantes WHERE T-Comprobantes.estadosunat = 0 OR T-Comprobantes.estadosunat = 3:  /* Paper Less OK */*/
DO WITH FRAME {&FRAME-NAME}.
    lRowSeleTot = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO lRowSele = 1 TO lRowSeleTot:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(lRowSele) THEN DO:
            cRetVal = "".
            
            RUN pobtener-cdr-sunat IN hProc 
                (INPUT T-Comprobantes.coddoc, 
                 INPUT T-Comprobantes.nrodoc, 
                 INPUT T-Comprobantes.coddiv,
                 INPUT lDirectorio,
                 OUTPUT cRetVal).
            /*
            IF cRetVal <> "" THEN DO:
                ASSIGN T-Comprobantes.flagsunat = 1
                        T-Comprobantes.estadosunat = DEC(ENTRY(1,cretval,"|"))
                        T-Comprobantes.flagestado = ENTRY(1,cretval,"|") + " - " + ENTRY(2,cretval,"|").
                ASSIGN t-comprobantes.sactualizar = 'SUNAT'.
            END.
            */
        END.
    END.
END.
/*END.*/

RUN pelimina-obj-xml IN hProc.


DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

{&OPEN-QUERY-{&BROWSE-NAME}}



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-confirmar-documento W-Win 
PROCEDURE ue-confirmar-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFIN VAR lRetVal AS CHAR NO-UNDO.
DEFINE VAR iFlagPPLL AS INT.
DEFINE VAR iEstadoPPLL AS INT.
DEFINE VAR hProc AS HANDLE NO-UNDO.

MESSAGE 'Seguro de realizar el proceso de CONFIRMACION de documento?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.
        
SESSION:SET-WAIT-STATE('GENERAL').

/* Levantamos las rutinas a memoria */
RUN sunat\facturacion-electronica.p PERSISTENT SET hProc NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    MESSAGE "ERROR en las librerias de la Facturación Electrónica" + CHR(10) +
        "Salir del Sistema, volver a entrar y repetir el proceso".
    RETURN "ADM-ERROR".
END.

IF VALID-HANDLE(hSocket) THEN DELETE OBJECT hSocket.
CREATE SOCKET hSocket.

FOR EACH T-Comprobantes :
    IF t-comprobantes.codhash <> ? AND t-comprobantes.codhash <> "" THEN DO:
        IF t-comprobantes.FlagPPLL = 2 THEN DO:
            iFlagPPLL = t-comprobantes.FlagPPLL.
            lRetVal = "".
            
            RUN pconfirmar-documento-preanulado IN hProc (INPUT t-comprobantes.CodDoc,
                                               INPUT t-comprobantes.NroDoc,
                                               INPUT t-comprobantes.CodDiv,
                                               OUTPUT lRetVal).
            MESSAGE t-comprobantes.CodDoc t-comprobantes.NroDoc lRetVal.
            /* Si los 3 primeros digitos del cRetVal = "000" */
            IF SUBSTRING(lRetVal,1,3) = "000" THEN DO:
                iEstadoPPLL = INTEGER(ENTRY(1,lRetVal,'|')) NO-ERROR.
                FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = s-codcia AND
                            FELogComprobantes.coddiv = t-comprobantes.coddiv AND
                            FELogComprobantes.coddoc = t-comprobantes.coddoc AND 
                            FELogComprobantes.nrodoc = t-comprobantes.nrodoc NO-ERROR.
                IF AVAILABLE FELogComprobantes THEN DO:
                    ASSIGN FELogComprobantes.FlagPPLL   = (IF SUBSTRING(lRetVal,1,3) = "000" THEN 1 ELSE iFlagPPLL)
                            FELogComprobantes.EstadoPPLL = iEstadoPPLL.
                END.
                RELEASE FELogComprobantes.
                ASSIGN t-Comprobantes.FlagPPLL   = (IF SUBSTRING(lRetVal,1,3) = "000" THEN 1 ELSE iFlagPPLL)
                        t-Comprobantes.EstadoPPLL = iEstadoPPLL.

            END.
        END.
    END.
END.
SESSION:SET-WAIT-STATE('').

FIND FIRST T-Comprobantes NO-ERROR.

/*
EMPTY TEMP-TABLE T-Comprobantes.
{&OPEN-QUERY-{&BROWSE-NAME}}
*/
END PROCEDURE.

/*
    cRetVal = "".
    RUN pconfirmar-documento IN hProc (INPUT B-CDOCU.CodDoc,
                                       INPUT B-CDOCU.NroDoc,
                                       INPUT B-CDOCU.CodDiv,
                                       OUTPUT cRetVal).
    /* Si los 3 primeros digitos del cRetVal = "000" */
    IF SUBSTRING(cRetVal,1,3) <> "000" THEN DO:
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-enviar-a-bizlinks W-Win 
PROCEDURE ue-enviar-a-bizlinks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-cuantos AS INT.

x-cuantos = BROWSE-4:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}.

IF x-cuantos > 20 THEN DO:
    MESSAGE "Solo debe seleccionar 20 documentos por vez" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

DEFINE VAR lRetVal AS CHAR NO-UNDO.
DEFINE VAR xpMensaje AS CHAR NO-UNDO.
DEFINE VAR RowSeleTot AS INT.
DEFINE VAR lRowSele AS INT.

MESSAGE 'Seguro de realizar el proceso de envio a BIZLINKS ?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.
        
SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR x-codhash AS CHAR.
DEFINE VAR x-logestado AS CHAR.
DEFINE VAR x-estado AS CHAR.
DEFINE VAR x-bizlinks AS CHAR.

DEFINE VAR x-coddiv AS CHAR.
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-contingencia AS CHAR INIT "".

DO WITH FRAME {&FRAME-NAME}:
    RowSeleTot = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO lRowSele = 1 TO RowSeleTot :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(lRowSele) THEN DO:
            x-codhash = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codhash.
            x-estado = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.sestado.
            x-logestado = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.logEstado.
            x-bizlinks = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c01.
            IF x-codhash = ? OR x-codhash = "" THEN DO:
                IF x-LogEstado = "ENVIADO A PPL" OR 
                                (x-LogEstado = "ENVIADO A BIZLINKS" AND x-bizlinks <> "MISSING") THEN DO:
                    ASSIGN T-Comprobantes.libre_c04 = "Documento ya fue enviado al PSE/OSE".
                END.
                ELSE DO:
                    DEFINE VAR x-retval AS CHAR NO-UNDO.

                    IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
                    x-dobleclick = YES.

                    x-coddiv = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddiv.
                    x-coddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddoc.
                    x-nrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

                    IF x-es-contingencia = YES THEN x-contingencia = "CONTINGENCIA".                    

                    RUN sunat\progress-to-bz-arimetica.r( INPUT x-CodDiv,
                                                    INPUT x-CodDoc,
                                                    INPUT x-NroDoc,
                                                    INPUT-OUTPUT TABLE T-FELogErrores,
                                                    OUTPUT x-retval,
                                                    INPUT-OUTPUT x-contingencia ).
                    x-dobleclick = NO.
                    ASSIGN T-Comprobantes.libre_c04 = x-retval.

                    IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                

                    RUN estado-documento.

                END.
            END.
        END.
    END.
END.

/*
FOR EACH T-Comprobantes :
    IF t-comprobantes.codhash = ? OR t-comprobantes.codhash = "" THEN DO:
        IF t-comprobantes.sestado <> "A" THEN DO:
            IF T-Comprobantes.LogEstado = "ENVIADO A PPL" OR 
                            (T-Comprobantes.LogEstado = "ENVIADO A BIZLINKS" AND t-comprobantes.libre_c01 <> "MISSING") THEN DO:
                /*MESSAGE "Documento ya fue enviado al PSE/OSE" VIEW-AS ALERT-BOX INFORMATION.*/
                ASSIGN T-Comprobantes.libre_c04 = "Documento ya fue enviado al PSE/OSE".
            END.
            ELSE DO:

                DEFINE VAR x-retval AS CHAR NO-UNDO.

                IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
                x-dobleclick = YES.
                /* RUN generar-file-txt. */

                RUN sunat\progress-to-bz.r( INPUT T-Comprobantes.CodDiv,
                                                INPUT T-Comprobantes.CodDoc,
                                                INPUT T-Comprobantes.NroDoc,
                                                INPUT-OUTPUT TABLE T-FELogErrores,
                                                OUTPUT x-retval ).
                x-dobleclick = NO.
                ASSIGN T-Comprobantes.libre_c04 = x-retval.

                IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                

                RUN estado-documento.
         
            END.
        END.
        ELSE DO:
            /* 
                El comprobante existe en FELOGCOMPROBANTES sin HASH
                hay que reenviarlo con el mismo IDpos y IPpos
            */
        END.
    END.
END.
*/

BROWSE-4:REFRESH() IN FRAME {&FRAME-NAME}.

SESSION:SET-WAIT-STATE('').

/*
SESSION:SET-WAIT-STATE('').
EMPTY TEMP-TABLE T-Comprobantes.
{&OPEN-QUERY-{&BROWSE-NAME}}
*/


END PROCEDURE.

/*
    IF t-comprobantes.sestado <> "A" THEN DO:
        
        IF T-Comprobantes.LogEstado = "ENVIADO A PPL" OR 
                        (T-Comprobantes.LogEstado = "ENVIADO A BIZLINKS" AND t-comprobantes.libre_c01 <> "MISSING") THEN DO:
            MESSAGE "Documento ya fue enviado al PSE/OSE" VIEW-AS ALERT-BOX INFORMATION.
        END.
        ELSE DO:
            MESSAGE 'Seguro de generar archivo de (' + T-Comprobantes.coddoc + ' ' + T-Comprobantes.nrodoc + ')?' VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.

            IF rpta = YES THEN DO:

                DEFINE VAR x-retval AS CHAR NO-UNDO.

                IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
                x-dobleclick = YES.
                /* RUN generar-file-txt. */

                RUN sunat\progress-to-bz.r( INPUT T-Comprobantes.CodDiv,
                                                INPUT T-Comprobantes.CodDoc,
                                                INPUT T-Comprobantes.NroDoc,
                                                INPUT-OUTPUT TABLE T-FELogErrores,
                                                OUTPUT x-retval ).
                x-dobleclick = NO.
                IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                

                MESSAGE x-retval.

                RUN estado-documento.

                /*{&open-query-browse-4}           */
                BROWSE-4:REFRESH() IN FRAME {&FRAME-NAME}.

            END.
        END.
    END.
    ELSE DO:
        MESSAGE "Documento esta anulado." VIEW-AS ALERT-BOX INFORMATION.
    END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-enviar-a-bizlinks-test W-Win 
PROCEDURE ue-enviar-a-bizlinks-test :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-cuantos AS INT.

x-cuantos = BROWSE-4:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}.

IF x-cuantos > 20 THEN DO:
    MESSAGE "Solo debe seleccionar 20 documentos por vez" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

DEFINE VAR lRetVal AS CHAR NO-UNDO.
DEFINE VAR xpMensaje AS CHAR NO-UNDO.
DEFINE VAR RowSeleTot AS INT.
DEFINE VAR lRowSele AS INT.
DEFINE VAR cOldUsuario AS CHAR NO-UNDO.

MESSAGE 'Seguro de realizar el proceso de envio a BIZLINKS TEST ?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.
        
SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR x-codhash AS CHAR.
DEFINE VAR x-logestado AS CHAR.
DEFINE VAR x-estado AS CHAR.
DEFINE VAR x-bizlinks AS CHAR.

DEFINE VAR x-coddiv AS CHAR.
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-contingencia AS CHAR INIT "".

DO WITH FRAME {&FRAME-NAME}:
    RowSeleTot = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO lRowSele = 1 TO RowSeleTot :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(lRowSele) THEN DO:

            x-codhash = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codhash.
            x-estado = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.sestado.
            x-logestado = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.logEstado.
            x-bizlinks = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c01.
            /*
            IF x-codhash = ? OR x-codhash = "" THEN DO:
                IF x-LogEstado = "ENVIADO A PPL" OR 
                                (x-LogEstado = "ENVIADO A BIZLINKS" AND x-bizlinks <> "MISSING") THEN DO:
                    ASSIGN T-Comprobantes.libre_c04 = "Documento ya fue enviado al PSE/OSE".
                END.
                ELSE DO:
            */
            IF CAPS(USERID("DICTDB")) = "ADMIN" OR CAPS(USERID("DICTDB")) = "MASTER" THEN DO:
            
                    DEFINE VAR x-retval AS CHAR NO-UNDO.

                    cOldUsuario = s-user-id.

                    IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
                    x-dobleclick = YES.

                    x-coddiv = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddiv.
                    x-coddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddoc.
                    x-nrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

                    IF x-es-contingencia = YES THEN x-contingencia = "CONTINGENCIA".                    
                    x-contingencia = "XMLTEST".

                    RUN sunat\progress-to-bz-arimetica.r( INPUT x-CodDiv,
                                                    INPUT x-CodDoc,
                                                    INPUT x-NroDoc,
                                                    INPUT-OUTPUT TABLE T-FELogErrores,
                                                    OUTPUT x-retval,
                                                    INPUT-OUTPUT x-contingencia ).
                    x-dobleclick = NO.
                    /*ASSIGN T-Comprobantes.libre_c04 = x-retval.*/

                    IF s-user-id = 'PRUEBASX' THEN s-user-id = cOldUsuario.

                    RUN estado-documento.
            END.
        END.
    END.
END.

BROWSE-4:REFRESH() IN FRAME {&FRAME-NAME}.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.


/*
FOR EACH T-Comprobantes :
    IF t-comprobantes.codhash = ? OR t-comprobantes.codhash = "" THEN DO:
        IF t-comprobantes.sestado <> "A" THEN DO:
            IF T-Comprobantes.LogEstado = "ENVIADO A PPL" OR 
                            (T-Comprobantes.LogEstado = "ENVIADO A BIZLINKS" AND t-comprobantes.libre_c01 <> "MISSING") THEN DO:
                /*MESSAGE "Documento ya fue enviado al PSE/OSE" VIEW-AS ALERT-BOX INFORMATION.*/
                ASSIGN T-Comprobantes.libre_c04 = "Documento ya fue enviado al PSE/OSE".
            END.
            ELSE DO:

                DEFINE VAR x-retval AS CHAR NO-UNDO.

                IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
                x-dobleclick = YES.
                /* RUN generar-file-txt. */

                RUN sunat\progress-to-bz.r( INPUT T-Comprobantes.CodDiv,
                                                INPUT T-Comprobantes.CodDoc,
                                                INPUT T-Comprobantes.NroDoc,
                                                INPUT-OUTPUT TABLE T-FELogErrores,
                                                OUTPUT x-retval ).
                x-dobleclick = NO.
                ASSIGN T-Comprobantes.libre_c04 = x-retval.

                IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                

                RUN estado-documento.
         
            END.
        END.
        ELSE DO:
            /* 
                El comprobante existe en FELOGCOMPROBANTES sin HASH
                hay que reenviarlo con el mismo IDpos y IPpos
            */
        END.
    END.
END.
*/

/*
SESSION:SET-WAIT-STATE('').
EMPTY TEMP-TABLE T-Comprobantes.
{&OPEN-QUERY-{&BROWSE-NAME}}
*/


/*
    IF t-comprobantes.sestado <> "A" THEN DO:
        
        IF T-Comprobantes.LogEstado = "ENVIADO A PPL" OR 
                        (T-Comprobantes.LogEstado = "ENVIADO A BIZLINKS" AND t-comprobantes.libre_c01 <> "MISSING") THEN DO:
            MESSAGE "Documento ya fue enviado al PSE/OSE" VIEW-AS ALERT-BOX INFORMATION.
        END.
        ELSE DO:
            MESSAGE 'Seguro de generar archivo de (' + T-Comprobantes.coddoc + ' ' + T-Comprobantes.nrodoc + ')?' VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.

            IF rpta = YES THEN DO:

                DEFINE VAR x-retval AS CHAR NO-UNDO.

                IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBASX'.
                x-dobleclick = YES.
                /* RUN generar-file-txt. */

                RUN sunat\progress-to-bz.r( INPUT T-Comprobantes.CodDiv,
                                                INPUT T-Comprobantes.CodDoc,
                                                INPUT T-Comprobantes.NroDoc,
                                                INPUT-OUTPUT TABLE T-FELogErrores,
                                                OUTPUT x-retval ).
                x-dobleclick = NO.
                IF s-user-id = 'PRUEBASX' THEN s-user-id = 'ADMIN'.                

                MESSAGE x-retval.

                RUN estado-documento.

                /*{&open-query-browse-4}           */
                BROWSE-4:REFRESH() IN FRAME {&FRAME-NAME}.

            END.
        END.
    END.
    ELSE DO:
        MESSAGE "Documento esta anulado." VIEW-AS ALERT-BOX INFORMATION.
    END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-enviar-a-ppl W-Win 
PROCEDURE ue-enviar-a-ppl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/      

DEFINE VAR lRetVal AS CHAR NO-UNDO.
DEFINE VAR pMensaje AS CHAR NO-UNDO.
DEFINE VAR lRowSeleTot AS INT.
DEFINE VAR lRowSele AS INT.

MESSAGE 'Seguro de realizar el proceso de envio a SUNAT?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.
        
SESSION:SET-WAIT-STATE('GENERAL').
/*
DO WITH FRAME {&FRAME-NAME}.
    lRowSeleTot = BROWSE-4:NUM-SELECTED-ROWS.
    DO lRowSele = 1 TO lRowSeleTot:
        IF BROWSE-4:FETCH-SELECTED-ROW(lRowSele) THEN DO:
            IF t-comprobantes.codhash = ? OR t-comprobantes.codhash = "" THEN DO:

                FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                            ccbcdocu.coddiv = t-comprobantes.coddiv AND
                                            ccbcdocu.coddoc = t-comprobantes.coddoc AND
                                            ccbcdocu.nrodoc = t-comprobantes.nrodoc
                                            NO-LOCK NO-ERROR.

                MESSAGE Ccbcdocu.nrodoc VIEW-AS ALERT-BOX QUESTION
                        BUTTONS YES-NO UPDATE rpta2 AS LOG.
                IF rpta2 = YES THEN DO:
                    RUN sunat\progress-to-ppll-v3( INPUT Ccbcdocu.coddiv,
                                                   INPUT Ccbcdocu.coddoc,
                                                   INPUT Ccbcdocu.nrodoc,
                                                   INPUT-OUTPUT TABLE T-FELogErrores,
                                                   OUTPUT pMensaje ).
                END.
            END.
        END.
    END.
END.
*/


FOR EACH T-Comprobantes :
    IF t-comprobantes.codhash = ? OR t-comprobantes.codhash = "" THEN DO:
        IF t-comprobantes.sactualizar = 'X' THEN DO:

            RUN envio-a-ppl.
            /*
            /* Solo aquellos que no esten en FELOGCOMPROBANTES */
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                        ccbcdocu.coddiv = t-comprobantes.coddiv AND
                                        ccbcdocu.coddoc = t-comprobantes.coddoc AND
                                        ccbcdocu.nrodoc = t-comprobantes.nrodoc
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN DO:
                lRetVal = "".
/*                 RUN sunat/progress-to-ppll-v21(ROWID(ccbcdocu), INPUT-OUTPUT TABLE T-FELogErrores, OUTPUT lRetVal). */
                RUN sunat\progress-to-ppll-v3( INPUT Ccbcdocu.coddiv,
                                               INPUT Ccbcdocu.coddoc,
                                               INPUT Ccbcdocu.nrodoc,
                                               INPUT-OUTPUT TABLE T-FELogErrores,
                                               OUTPUT pMensaje ).
                /*MESSAGE lRetVal.*/
            END.
            */
        END.
        ELSE DO:
            /* 
                El comprobante existe en FELOGCOMPROBANTES sin HASH
                hay que reenviarlo con el mismo IDpos y IPpos
            */
        END.
    END.
END.


SESSION:SET-WAIT-STATE('').
EMPTY TEMP-TABLE T-Comprobantes.
{&OPEN-QUERY-{&BROWSE-NAME}}


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

MESSAGE 'Seguro de GENERAR el EXCEL?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

DEFINE VAR x-Archivo    AS CHAR.

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


DEFINE BUFFER b-ccdoc FOR ccbcdocu.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH t-comprobantes :
    FIND FIRST b-ccdoc WHERE    b-ccdoc.codcia = s-codcia AND
                                b-ccdoc.coddiv = t-comprobantes.coddiv AND 
                                b-ccdoc.coddoc = t-comprobantes.coddoc AND 
                                b-ccdoc.nrodoc = t-comprobantes.nrodoc NO-LOCK NO-ERROR.

    CREATE tt-excel.
    ASSIGN  tt-coddiv   = t-comprobantes.coddiv
            tt-coddoc   = t-comprobantes.coddoc
            tt-nrodoc   = t-comprobantes.nrodoc
            tt-fchdoc   = IF(AVAILABLE b-ccdoc) THEN b-ccdoc.fchdoc ELSE ?
            tt-codcli   = IF(AVAILABLE b-ccdoc) THEN b-ccdoc.codcli ELSE ""
            tt-nomcli   = IF(AVAILABLE b-ccdoc) THEN b-ccdoc.nomcli ELSE ""
            tt-ruc      = IF(AVAILABLE b-ccdoc) THEN b-ccdoc.ruc ELSE ""
            tt-impte    = IF(AVAILABLE b-ccdoc) THEN b-ccdoc.imptot ELSE 0
            tt-tcmb     = IF(AVAILABLE b-ccdoc) THEN b-ccdoc.tpocmb ELSE 0
            tt-flgppll  = t-comprobantes.flagppll
            tt-ppll     = t-comprobantes.logestado
            tt-flgsunat = t-comprobantes.estadosunat
            tt-sunat    = t-comprobantes.flagestado
            tt-estado   = t-comprobantes.sestado.
    IF AVAILABLE b-ccdoc THEN DO:
        ASSIGN tt-mone  = IF b-ccdoc.codmon = 2 THEN "USD" ELSE "SOLES".
    END.
            
END.

RELEASE b-ccdoc.

SESSION:SET-WAIT-STATE('').

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = x-Archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-excel:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

