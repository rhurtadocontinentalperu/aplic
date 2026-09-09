&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-CPEDI LIKE FacCPedi.
DEFINE TEMP-TABLE t-interfase NO-UNDO LIKE b2c-interfase.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-file-excel AS CHAR.

DEFINE VAR x-cuales AS INT INIT 1.

&SCOPED-DEFINE CONDICION ( ~
            (x-cuales = 1 ) OR  ~
            (x-cuales = 2 AND t-interfase.libre_char[15] = "PRE-CONCILIAR") OR ~
            (x-cuales = 3 AND t-interfase.libre_char[15] = ""))

DEFINE VAR x-diferencias-color AS LOG.

/*
DEFINE VAR x-tabla AS CHAR.
DEFINE VAR x-codigo AS CHAR.
DEFINE VAR x-rango AS INT INIT 0.

x-tabla = "NIUBIZ-CONFIG".
x-codigo = "ABONO-VS-VENTAS".

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                          factabla.tabla = x-tabla AND
                          factabla.codigo = x-codigo EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE factabla THEN DO:
    x-rango = factabla.valor[1].
END.
*/

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
&Scoped-define INTERNAL-TABLES T-INTERFASE T-CPEDI

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 T-CPEDI.ordcmp T-CPEDI.Libre_c01 ~
T-CPEDI.Libre_c02 T-CPEDI.Libre_f01 T-CPEDI.Libre_d01 T-CPEDI.NomCli ~
T-INTERFASE.comision-calculada T-INTERFASE.porcentaje-comision ~
T-INTERFASE.Tipo_Tarjeta T-INTERFASE.origen-tarjeta ~
T-INTERFASE.modalidad-tarjeta T-INTERFASE.impte-transaccion ~
T-INTERFASE.Comision-enviada T-INTERFASE.comision-gravable ~
T-INTERFASE.impte-igv T-INTERFASE.Neto_Abonar T-INTERFASE.Fecha_Abono ~
T-INTERFASE.Fecha_de_Proceso T-INTERFASE.Estado T-INTERFASE.Id_Unico ~
T-CPEDI.NroPed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH T-INTERFASE ~
      WHERE {&CONDICION} NO-LOCK, ~
      FIRST T-CPEDI WHERE T-INTERFASE.CodCia = T-CPEDI.CodCia ~
  AND T-INTERFASE.Pedido_Cliente = T-CPEDI.ordcmp OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH T-INTERFASE ~
      WHERE {&CONDICION} NO-LOCK, ~
      FIRST T-CPEDI WHERE T-INTERFASE.CodCia = T-CPEDI.CodCia ~
  AND T-INTERFASE.Pedido_Cliente = T-CPEDI.ordcmp OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 T-INTERFASE T-CPEDI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 T-INTERFASE
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 T-CPEDI


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-34 RECT-35 BUTTON-Procesar ~
BUTTON-Aprobar BUTTON-filtrar BUTTON-buscar RADIO-SET-cuales FILL-IN-pedido ~
BUTTON-6 BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 RADIO-SET-cuales FILL-IN-pedido ~
FILL-IN-2 FILL-IN-calculada FILL-IN-enviada 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-6 
     LABEL "Elejir el Excel para Pre-Conciliar" 
     SIZE 22.72 BY 1.12.

DEFINE BUTTON BUTTON-Aprobar 
     LABEL "GRABAR PRE-CONCILIACION" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-buscar 
     LABEL "Buscar" 
     SIZE 8 BY .96.

DEFINE BUTTON BUTTON-filtrar 
     LABEL "Filtrar" 
     SIZE 9 BY 1.15.

DEFINE BUTTON BUTTON-Procesar 
     LABEL "MOSTRAR PENDIENTES POR PRE-CONCILIAR" 
     SIZE 35 BY 1.12.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U INITIAL "   PRE-CONCILIACION NIUBIZ" 
     VIEW-AS FILL-IN 
     SIZE 44.57 BY 1.04
     BGCOLOR 9 FGCOLOR 15 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U INITIAL "   Data del Excel" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 10  NO-UNDO.

DEFINE VARIABLE FILL-IN-calculada AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Total de COMISION CALCULADA" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-enviada AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Total de COMISION ENVIADA" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81
     BGCOLOR 10 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-pedido AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Pedido Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-cuales AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Para Pre-conciliar", 2,
"Aun sin Pre-conciliar", 3
     SIZE 42 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 1.38.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33.29 BY 1.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      T-INTERFASE, 
      T-CPEDI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      T-CPEDI.ordcmp COLUMN-LABEL "Pedido!del Cliente" FORMAT "X(12)":U
            WIDTH 9.43
      T-CPEDI.Libre_c01 COLUMN-LABEL "Doc.!Cmpte" FORMAT "x(3)":U
            WIDTH 4.57
      T-CPEDI.Libre_c02 COLUMN-LABEL "Número!Cmpte" FORMAT "x(12)":U
            WIDTH 11.29
      T-CPEDI.Libre_f01 COLUMN-LABEL "Fecha!Cmpte" FORMAT "99/99/9999":U
      T-CPEDI.Libre_d01 COLUMN-LABEL "Importe!Cmpte" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 8.72
      T-CPEDI.NomCli FORMAT "x(40)":U WIDTH 27.43
      T-INTERFASE.comision-calculada COLUMN-LABEL "Comision!Calculada" FORMAT "->>,>>>,>>9.99":U
            WIDTH 11.43
      T-INTERFASE.porcentaje-comision COLUMN-LABEL "%Comision!Calculado" FORMAT "->>,>>9.99":U
            WIDTH 8.43
      T-INTERFASE.Tipo_Tarjeta COLUMN-LABEL "Marca!Tarjeta" FORMAT "x(15)":U
            WIDTH 9.43
      T-INTERFASE.origen-tarjeta COLUMN-LABEL "Origen!Tarjeta" FORMAT "x(25)":U
            WIDTH 11.43
      T-INTERFASE.modalidad-tarjeta COLUMN-LABEL "Tipo!Tarjeta" FORMAT "x(15)":U
            WIDTH 8.43
      T-INTERFASE.impte-transaccion COLUMN-LABEL "Impte!Transaccion" FORMAT "->>,>>>,>>9.99":U
            WIDTH 9.43
      T-INTERFASE.Comision-enviada COLUMN-LABEL "Comision!Niubiz" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 8.43
      T-INTERFASE.comision-gravable COLUMN-LABEL "Comision!Gravable" FORMAT "->>,>>>,>>9.99":U
            WIDTH 8.43
      T-INTERFASE.impte-igv COLUMN-LABEL "IGV!Comision" FORMAT "->,>>>,>>9.99":U
            WIDTH 8.43
      T-INTERFASE.Neto_Abonar COLUMN-LABEL "Neto!Abonado" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 9.43
      T-INTERFASE.Fecha_Abono COLUMN-LABEL "Fecha!Abono" FORMAT "99/99/9999":U
      T-INTERFASE.Fecha_de_Proceso COLUMN-LABEL "Fecha Pedido!Cliente" FORMAT "99/99/9999":U
            WIDTH 11.43
      T-INTERFASE.Estado FORMAT "x(15)":U
      T-INTERFASE.Id_Unico FORMAT "x(20)":U
      T-CPEDI.NroPed COLUMN-LABEL "Cotización" FORMAT "X(12)":U
            WIDTH 44.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 189 BY 18.27
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-1 AT ROW 1.04 COL 116.43 NO-LABEL WIDGET-ID 24
     BUTTON-Procesar AT ROW 1.58 COL 3 WIDGET-ID 4
     BUTTON-Aprobar AT ROW 1.58 COL 48 WIDGET-ID 6
     BUTTON-filtrar AT ROW 2.23 COL 129 WIDGET-ID 16
     BUTTON-buscar AT ROW 2.35 COL 173.72 WIDGET-ID 18
     RADIO-SET-cuales AT ROW 2.42 COL 86 NO-LABEL WIDGET-ID 10
     FILL-IN-pedido AT ROW 2.42 COL 159.14 COLON-ALIGNED WIDGET-ID 14
     BUTTON-6 AT ROW 2.85 COL 4.29 WIDGET-ID 26
     FILL-IN-2 AT ROW 3.12 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     BROWSE-3 AT ROW 4.27 COL 1.86 WIDGET-ID 300
     FILL-IN-calculada AT ROW 22.73 COL 69 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-enviada AT ROW 22.73 COL 128 COLON-ALIGNED WIDGET-ID 32
     RECT-34 AT ROW 2.15 COL 85 WIDGET-ID 20
     RECT-35 AT ROW 2.19 COL 149.72 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 190 BY 23.27
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-CPEDI T "?" ? INTEGRAL FacCPedi
      TABLE: t-interfase T "?" NO-UNDO INTEGRAL b2c-interfase
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PRE-CONCILIACION NIUBIZ"
         HEIGHT             = 23.27
         WIDTH              = 190
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
/* BROWSE-TAB BROWSE-3 FILL-IN-2 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-calculada IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-enviada IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.T-INTERFASE,Temp-Tables.T-CPEDI WHERE Temp-Tables.T-INTERFASE ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER"
     _Where[1]         = "{&CONDICION}"
     _JoinCode[2]      = "Temp-Tables.T-INTERFASE.CodCia = Temp-Tables.T-CPEDI.CodCia
  AND Temp-Tables.T-INTERFASE.Pedido_Cliente = Temp-Tables.T-CPEDI.ordcmp"
     _FldNameList[1]   > Temp-Tables.T-CPEDI.ordcmp
"T-CPEDI.ordcmp" "Pedido!del Cliente" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-CPEDI.Libre_c01
"T-CPEDI.Libre_c01" "Doc.!Cmpte" "x(3)" "character" ? ? ? ? ? ? no ? no no "4.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-CPEDI.Libre_c02
"T-CPEDI.Libre_c02" "Número!Cmpte" "x(12)" "character" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-CPEDI.Libre_f01
"T-CPEDI.Libre_f01" "Fecha!Cmpte" "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-CPEDI.Libre_d01
"T-CPEDI.Libre_d01" "Importe!Cmpte" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-CPEDI.NomCli
"T-CPEDI.NomCli" ? "x(40)" "character" ? ? ? ? ? ? no ? no no "27.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-INTERFASE.comision-calculada
"T-INTERFASE.comision-calculada" "Comision!Calculada" ? "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-INTERFASE.porcentaje-comision
"T-INTERFASE.porcentaje-comision" "%Comision!Calculado" "->>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-INTERFASE.Tipo_Tarjeta
"T-INTERFASE.Tipo_Tarjeta" "Marca!Tarjeta" "x(15)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-INTERFASE.origen-tarjeta
"T-INTERFASE.origen-tarjeta" "Origen!Tarjeta" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-INTERFASE.modalidad-tarjeta
"T-INTERFASE.modalidad-tarjeta" "Tipo!Tarjeta" "x(15)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-INTERFASE.impte-transaccion
"T-INTERFASE.impte-transaccion" "Impte!Transaccion" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.T-INTERFASE.Comision-enviada
"T-INTERFASE.Comision-enviada" "Comision!Niubiz" ? "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.T-INTERFASE.comision-gravable
"T-INTERFASE.comision-gravable" "Comision!Gravable" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.T-INTERFASE.impte-igv
"T-INTERFASE.impte-igv" "IGV!Comision" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.T-INTERFASE.Neto_Abonar
"T-INTERFASE.Neto_Abonar" "Neto!Abonado" ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.T-INTERFASE.Fecha_Abono
"T-INTERFASE.Fecha_Abono" "Fecha!Abono" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.T-INTERFASE.Fecha_de_Proceso
"T-INTERFASE.Fecha_de_Proceso" "Fecha Pedido!Cliente" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   = Temp-Tables.T-INTERFASE.Estado
     _FldNameList[20]   = Temp-Tables.T-INTERFASE.Id_Unico
     _FldNameList[21]   > Temp-Tables.T-CPEDI.NroPed
"T-CPEDI.NroPed" "Cotización" ? "character" ? ? ? ? ? ? no ? no no "44.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PRE-CONCILIACION NIUBIZ */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PRE-CONCILIACION NIUBIZ */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Elejir el Excel para Pre-Conciliar */
DO:
    DEF VAR lNuevoFile AS LOG NO-UNDO.
    DEF VAR lFIleXls   AS CHAR NO-UNDO.
    DEF VAR x-Archivo  AS CHAR NO-UNDO.

    DEFINE VAR OKpressed AS LOG.

    SYSTEM-DIALOG GET-FILE x-Archivo
        FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx"
        MUST-EXIST
        TITLE "Seleccione archivo..."
        UPDATE OKpressed.   

    IF OKpressed = NO THEN RETURN NO-APPLY.
    lFileXls = x-Archivo.
    lNuevoFile = NO.

    x-file-excel = lFileXls.

    RUN excel-liquidacion.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Aprobar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Aprobar W-Win
ON CHOOSE OF BUTTON-Aprobar IN FRAME F-Main /* GRABAR PRE-CONCILIACION */
DO:
  MESSAGE 'Seguro de Proceder a GRABAR la PRE-CONCILIACION?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  DEF VAR pMensaje AS CHAR NO-UNDO.
  RUN Aprobar (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  EMPTY TEMP-TABLE T-CPEDI.
  EMPTY TEMP-TABLE T-interfase.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-buscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-buscar W-Win
ON CHOOSE OF BUTTON-buscar IN FRAME F-Main /* Buscar */
DO:
  ASSIGN fill-in-pedido.

  DEFINE VAR x-rowid AS ROWID.
  DEFINE VAR x-nropedido AS CHAR.
  DEFINE VAR x-old-rowid AS ROWID.

  IF AVAILABLE t-interfase THEN x-old-rowid = ROWID(t-interfase).

  IF fill-in-pedido > 0 THEN DO:
      x-nropedido = STRING(fill-in-pedido).
      FIND FIRST t-interfase WHERE t-interfase.pedido_cliente = x-nropedido NO-LOCK NO-ERROR.
      IF NOT AVAILABLE t-interfase THEN DO:
        RETURN NO-APPLY.        
      END.
      /**/
      x-rowid = ROWID(t-interfase).
      FIND FIRST {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
            ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = x-rowid
            NO-LOCK NO-ERROR.
      IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
          REPOSITION {&BROWSE-NAME}  TO ROWID x-rowid NO-ERROR.
          IF ERROR-STATUS:ERROR THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID x-old-rowid NO-ERROR.
            MESSAGE "El pedido que esta buscando no se encuentra en el GRID" SKIP
                "Asegurarse que el filtro se por todos"
                VIEW-AS ALERT-BOX INFORMATION.
          END.
      END.

  END.

END.

/*
        FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = VtaDList.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            NO-LOCK NO-ERROR.

        IF NOT CAN-FIND(FIRST customer WHERE customer.code = ordhdr.customer) THEN

        FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
        IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
        END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-filtrar W-Win
ON CHOOSE OF BUTTON-filtrar IN FRAME F-Main /* Filtrar */
DO:
  ASSIGN radio-set-cuales.

  x-cuales = radio-set-cuales.

  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Procesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Procesar W-Win
ON CHOOSE OF BUTTON-Procesar IN FRAME F-Main /* MOSTRAR PENDIENTES POR PRE-CONCILIAR */
DO:
  /*ASSIGN FILL-IN-FchDoc FILL-IN-FchDoc-2.*/
  RUN Carga-Temporal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

DEF VAR celda_br AS WIDGET-HANDLE EXTENT 150 NO-UNDO.
 DEF VAR cual_celda AS WIDGET-HANDLE NO-UNDO.
 DEF VAR n_cols_browse AS INT NO-UNDO.
 DEF VAR col_act AS INT NO-UNDO.
 DEF VAR t_col_br AS INT NO-UNDO INITIAL 11.		/* Color del background de la celda ( 2 : Verde)*/
 DEF VAR vg_col_eti_b AS INT NO-UNDO INITIAL 28.	/* Color del la letra de la celda (15 : Blanco) */	

ON ROW-DISPLAY OF browse-3
DO:
    IF x-diferencias-color = YES THEN DO:

        IF t-interfase.libre_char[15] <> "" THEN DO:
            IF t-interfase.comision-enviada = t-interfase.comision-calculada THEN RETURN.
            DO col_act = 1 TO n_cols_browse.

               cual_celda = celda_br[col_act].
               cual_celda:BGCOLOR = 4.
               cual_celda:FGCOLOR = 15.
            END.           
        END.
    END.
END.

DO n_cols_browse = 1 TO browse-3:NUM-COLUMNS.
    celda_br[n_cols_browse] = browse-3:GET-BROWSE-COLUMN(n_cols_browse).
    cual_celda = celda_br[n_cols_browse].

    IF vg_col_eti_b <> 0 THEN cual_celda:LABEL-BGCOLOR = vg_col_eti_b.
    /*IF n_cols_browse = 15 THEN LEAVE.*/
END.      

n_cols_browse = browse-3:NUM-COLUMNS.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar W-Win 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-NroOrd AS CHAR NO-UNDO.

SESSION:SET-WAIT-STATE("GENERAL").

/* Aprobación */
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH t-interfase WHERE t-interfase.libre_char[15] = "PRE-CONCILIAR" :
        /* Buscamos su par */
        FIND FIRST b2c-interfase WHERE b2c-interfase.CodCia = s-CodCia AND
            b2c-interfase.pedido_cliente = t-interfase.pedido_cliente NO-LOCK NO-ERROR.
        IF AVAILABLE b2c-interfase THEN DO:
            {lib/lock-genericov3.i ~
                &Tabla="b2c-interfase" ~
                &Alcance="FIRST" ~
                &Condicion="b2c-interfase.CodCia = s-CodCia AND ~
                b2c-interfase.pedido_cliente = t-interfase.pedido_cliente" ~
                &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
                &Accion="RETRY" ~
                &Mensaje="NO" ~
                &txtMensaje="pMensaje" ~
                &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'"}
            ASSIGN
                b2c-interfase.origen-tarjeta = t-interfase.origen-tarjeta
                b2c-interfase.modalidad-tarjeta = t-interfase.modalidad-tarjeta
                b2c-interfase.impte-transaccion = t-interfase.impte-transaccion
                b2c-interfase.comision-enviada = t-interfase.comision-enviada
                b2c-interfase.comision-gravable = t-interfase.comision-gravable
                b2c-interfase.impte-igv = t-interfase.impte-igv
                b2c-interfase.neto_abonar = t-interfase.neto_abonar
                b2c-interfase.fecha_abono = t-interfase.fecha_abono
                b2c-interfase.comision-calculada = t-interfase.comision-calculada
                b2c-interfase.porcentaje-comision = t-interfase.porcentaje-comision
                b2c-interfase.Fchpreconciliacion = TODAY
                b2c-interfase.Horpreconciliacion = STRING(TIME, 'HH:MM:SS')
                b2c-interfase.FlgEst = "PC"
                b2c-interfase.Usrpreconciliacion = s-User-Id.

            /**/
            DELETE t-interfase.
        END.
    END.
    /*
    EMPTY TEMP-TABLE T-CPEDI.
    EMPTY TEMP-TABLE T_pago_efectivo.
    */
    {&OPEN-QUERY-BROWSE-3}
END.

RELEASE pago_efectivo NO-ERROR.

SESSION:SET-WAIT-STATE("").

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculo-comision W-Win 
PROCEDURE calculo-comision :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pImporte AS DEC.
DEFINE INPUT PARAMETER pOrigenTarjeta AS CHAR.
DEFINE INPUT PARAMETER pTipoTarjeta AS CHAR.
DEFINE OUTPUT PARAMETER pComisionCalculada AS DEC.
DEFINE OUTPUT PARAMETER pPorcentajeComision AS DEC.

/* Escalas */

IF pOrigenTarjeta = "NACIONAL" THEN DO:
    IF (pImporte >= 0.00 AND pImporte <= 99.99) THEN DO:
        IF LOOKUP(pTipoTarjeta,"débito,debito") > 0 THEN pPorcentajeComision = 2.99.
        IF LOOKUP(pTipoTarjeta,"crédito,credito") > 0 THEN pPorcentajeComision = 3.99.        
    END.
    IF (pImporte >= 100.00 AND pImporte <= 249.99) THEN DO:
        IF LOOKUP(pTipoTarjeta,"débito,debito") > 0 THEN pPorcentajeComision = 2.99.
        IF LOOKUP(pTipoTarjeta,"crédito,credito") > 0 THEN pPorcentajeComision = 3.75.        
    END.
    IF (pImporte >= 250.00 AND pImporte <= 499.99) THEN DO:
        IF LOOKUP(pTipoTarjeta,"débito,debito") > 0 THEN pPorcentajeComision = 2.75.
        IF LOOKUP(pTipoTarjeta,"crédito,credito") > 0 THEN pPorcentajeComision = 3.25.        
    END.
    IF (pImporte >= 500.00 AND pImporte <= 999.99) THEN DO:
        IF LOOKUP(pTipoTarjeta,"débito,debito") > 0 THEN pPorcentajeComision = 2.0.
        IF LOOKUP(pTipoTarjeta,"crédito,credito") > 0 THEN pPorcentajeComision = 2.50.        
    END.
    IF (pImporte >= 1000.00 AND pImporte <= 2999.99) THEN DO:
        IF LOOKUP(pTipoTarjeta,"débito,debito") > 0 THEN pPorcentajeComision = 1.50.
        IF LOOKUP(pTipoTarjeta,"crédito,credito") > 0 THEN pPorcentajeComision = 2.0.        
    END.
    IF pImporte >= 3000.00  THEN DO:
        IF LOOKUP(pTipoTarjeta,"débito,debito") > 0 THEN pPorcentajeComision = 1.25.
        IF LOOKUP(pTipoTarjeta,"crédito,credito") > 0 THEN pPorcentajeComision = 1.75.        
    END.
END.
ELSE DO:
    IF (pImporte >= 0.00 AND pImporte <= 99.99) THEN DO:
        pPorcentajeComision = 3.99.
    END.
    IF (pImporte >= 100.00 AND pImporte <= 249.99) THEN DO:
        pPorcentajeComision = 3.99.
    END.
    IF (pImporte >= 250.00 AND pImporte <= 499.99) THEN DO:
        pPorcentajeComision = 3.99.
    END.
    IF (pImporte >= 500.00 AND pImporte <= 999.99) THEN DO:
        pPorcentajeComision = 3.75.
    END.
    IF (pImporte >= 1000.00 AND pImporte <= 2999.99) THEN DO:
        pPorcentajeComision = 3.75.
    END.
    IF pImporte >= 3000.00  THEN DO:
        pPorcentajeComision = 3.50.
    END.
END.

pComisionCalculada = ROUND(pImporte * (pPorcentajeComision / 100),2).

END PROCEDURE.

/*
Buenas tardes, Estimado Hiroshi

Tal como nos comunicamos, respidiendo a tu primera pregunta, las 
comisiones que se mantienen bajo el código de comercio electronico,
son las siguientes donde la tasa escalonada depende del monto que 
se realice y no del tipo de tarjeta.

Importe     Importe             % Com.          % Com.
Desde       Hasta               Débito. Nac.    Crédito. Nac.
                         
0.01        99.99               2.99            3.99
100.00      249.99              2.99            3.75
250.00      499.99              2.75            3.25
500.00      999.99              2.00            2.50
1,000.00    2,999.99            1.50            2.00
3,000.00    99,999,999.99       1.25            1.75
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE T-CPEDI.
EMPTY TEMP-TABLE T-interfase.

DEF VAR x-NroOrd AS CHAR NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH b2c-interfase WHERE b2c-interfase.codcia = s-codcia AND
                                b2c-interfase.flgest = 'C' AND
                                (TRUE <> (b2c-interfase.usrpreconciliacion > "")) NO-LOCK:
    /* Buscamos el comprobante FAC/BOL */
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                ccbcdocu.coddoc = b2c-interfase.libre_char[3] AND
                                ccbcdocu.nrodoc = b2c-interfase.libre_char[4] AND 
                                Ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbcdocu THEN NEXT.

    /* El PEDIDO */
    FIND FIRST PEDIDO WHERE PEDIDO.codcia = s-codcia AND
                                PEDIDO.coddoc = ccbcdocu.codped AND
                                PEDIDO.nroped = ccbcdocu.nroped NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PEDIDO THEN NEXT.

    /* La COTIZACION */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                faccpedi.coddoc = PEDIDO.codref AND
                                faccpedi.nroped = PEDIDO.nroref NO-LOCK NO-ERROR.
    IF NOT AVAILABLE faccpedi THEN NEXT.

    /**/
    CREATE T-CPEDI.
    BUFFER-COPY Faccpedi TO T-CPEDI.
    /* Agregamos dato de facturación */
    ASSIGN
        T-CPEDI.Libre_c01 = Ccbcdocu.coddoc
        T-CPEDI.Libre_c02 = Ccbcdocu.nrodoc
        T-CPEDI.Libre_c03 = ""
        T-CPEDI.Libre_f01 = Ccbcdocu.fchdoc
        T-CPEDI.Libre_d01 = Ccbcdocu.imptot.

    CREATE t-interfase.
    BUFFER-COPY b2c-interfase TO t-interfase.
        ASSIGN /*t_pago_efectivo.libre_char[1] = ""
                t_pago_efectivo.libre_dec[1] = 0.00
                t_pago_efectivo.libre_dec[2] = 0.00*/
                t-interfase.libre_char[15] = ""             /* Solo para marcar que se va grabar como preconciliado */
                t-interfase.libre_dec[15] = Ccbcdocu.imptot.    /* Se usara en el calculo de la comision */

    ASSIGN
        T-CPEDI.OrdCmp = Faccpedi.OrdCmp.

END.

x-diferencias-color = NO.

/*
/* Los que esten VALIDADOS y aun no esten LIQUIDADOS */
FOR EACH pago_efectivo WHERE pago_efectivo.codcia = s-codcia AND
                                pago_efectivo.FlgEst = "C"  AND
                                (TRUE <> (pago_efectivo.usrpreconciliacion > "")) NO-LOCK :
    
    /* Buscamos el comprobante FAC/BOL */
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                ccbcdocu.coddoc = pago_efectivo.libre_char[3] AND
                                ccbcdocu.nrodoc = pago_efectivo.libre_char[4] AND 
                                Ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbcdocu THEN NEXT.

    /* El PEDIDO */
    FIND FIRST PEDIDO WHERE PEDIDO.codcia = s-codcia AND
                                PEDIDO.coddoc = ccbcdocu.codped AND
                                PEDIDO.nroped = ccbcdocu.nroped NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PEDIDO THEN NEXT.

    /* La COTIZACION */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                faccpedi.coddoc = PEDIDO.codref AND
                                faccpedi.nroped = PEDIDO.nroref NO-LOCK NO-ERROR.
    IF NOT AVAILABLE faccpedi THEN NEXT.
    
    /**/
    CREATE T-CPEDI.
    BUFFER-COPY Faccpedi TO T-CPEDI.
    /* Agregamos dato de facturación */
    ASSIGN
        T-CPEDI.Libre_c01 = Ccbcdocu.coddoc
        T-CPEDI.Libre_c02 = Ccbcdocu.nrodoc
        T-CPEDI.Libre_c03 = ""
        T-CPEDI.Libre_f01 = Ccbcdocu.fchdoc
        T-CPEDI.Libre_d01 = Ccbcdocu.imptot.

    CREATE t_pago_efectivo.
    BUFFER-COPY pago_efectivo TO t_pago_efectivo.
        ASSIGN t_pago_efectivo.libre_char[1] = ""
                t_pago_efectivo.libre_dec[1] = 0.00
                t_pago_efectivo.libre_dec[2] = 0.00
                t_pago_efectivo.libre_char[20] = ""             /* Solo para marcar que se va marcar para grabar como preconciliado */
                t_pago_efectivo.libre_dec[20] = Ccbcdocu.imptot.    /* Se usara en el calculo de la comision */

    ASSIGN
        T-CPEDI.OrdCmp = Faccpedi.OrdCmp.


END.
*/

{&open-query-browse-3}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-old W-Win 
PROCEDURE Carga-Temporal-old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-CPEDI.
EMPTY TEMP-TABLE T-interfase.

DEF VAR x-NroOrd AS CHAR NO-UNDO.
/*
SESSION:SET-WAIT-STATE('GENERAL').

/* Cotizaciones Facturadas */
FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND
    Faccpedi.coddoc = 'COT' AND
    Faccpedi.coddiv = s-coddiv AND
    Faccpedi.fchped >= FILL-IN-FchDoc AND
    Faccpedi.fchped <= FILL-IN-FchDoc-2 AND
    Faccpedi.flgest <> 'A',
    FIRST PEDIDO NO-LOCK WHERE PEDIDO.codcia = s-codcia AND
    PEDIDO.coddoc = 'PED' AND
    PEDIDO.coddiv = s-coddiv AND
    PEDIDO.codref = Faccpedi.coddoc AND
    PEDIDO.nroref = Faccpedi.nroped AND
    PEDIDO.flgest <> 'A',
    FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
    Ccbcdocu.codped = PEDIDO.coddoc AND
    Ccbcdocu.nroped = PEDIDO.nroped AND
    Ccbcdocu.flgest <> 'A' AND
    LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0:
    CREATE T-CPEDI.
    BUFFER-COPY Faccpedi TO T-CPEDI.
    /* Agregamos dato de facturación */
    ASSIGN
        T-CPEDI.Libre_c01 = Ccbcdocu.coddoc
        T-CPEDI.Libre_c02 = Ccbcdocu.nrodoc
        T-CPEDI.Libre_c03 = "NO ABONADO"
        T-CPEDI.Libre_f01 = Ccbcdocu.fchdoc
        T-CPEDI.Libre_d01 = Ccbcdocu.imptot.
    /* Agregamos datos de Niubiz */
    x-NroOrd = Faccpedi.OrdCmp.
    ASSIGN
        x-NroOrd = STRING(INTEGER(x-NroOrd), '99999999')
        NO-ERROR.


    FIND FIRST pago_efectivo WHERE pago_efectivo.CodCia = s-codcia AND
        pago_efectivo.orden_comercio = x-NroOrd
        NO-LOCK NO-ERROR.
    IF AVAILABLE pago_efectivo THEN DO:
        /* IC - 13Jul2020 NO debe tomarse los YA esta validado */
        IF pago_efectivo.FlgEst = "C" THEN DO:
            DELETE T-CPEDI.
            NEXT.
        END.
        /* NO repetido */
        /*IF CAN-FIND(FIRST t_pago_efectivo OF pago_efectivo NO-LOCK) THEN NEXT.*/

        FIND FIRST pago_efectivo WHERE pago_efectivo.codcia = s-codcia AND
                                        pago_efectivo.orden_comercio = x-NroOrd
                                        NO-LOCK NO-ERROR.
        IF AVAILABLE pago_efectivo THEN NEXT.

        CREATE t_pago_efectivo.
        BUFFER-COPY pago_efectivo TO t_pago_efectivo.
        ASSIGN
            T-CPEDI.OrdCmp = x-NroOrd
            T-CPEDI.Libre_c03 = "ABONADO".
    END.
END.

SESSION:SET-WAIT-STATE('').
*/

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
  DISPLAY FILL-IN-1 RADIO-SET-cuales FILL-IN-pedido FILL-IN-2 FILL-IN-calculada 
          FILL-IN-enviada 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-34 RECT-35 BUTTON-Procesar BUTTON-Aprobar BUTTON-filtrar 
         BUTTON-buscar RADIO-SET-cuales FILL-IN-pedido BUTTON-6 BROWSE-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE excel-liquidacion W-Win 
PROCEDURE excel-liquidacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR x-porigv AS DEC.

    /* IGV */
    FIND FIRST facCfgGn WHERE facCfgGn.codcia = s-codcia NO-LOCK NO-ERROR.
    IF NOT AVAILABLE facCfgGn THEN DO:
        MESSAGE "No se pudo ubicar el % de IGV en la tabla FacCfgGn"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN.
    END.

    x-porigv = FacCfgGn.porigv.

    DEFINE VARIABLE lFileXls                 AS CHARACTER.
    DEFINE VARIABLE lNuevoFile               AS LOG.

    DEFINE VAR xCaso AS CHAR.
    DEFINE VAR lLinea AS INT.
    DEFINE VAR dValor AS DEC.
    DEFINE VAR cValor AS CHAR.
    DEFINE VAR fValor AS DATE.
    DEFINE VAR iValor AS INT.

        lFileXls = x-file-excel.                /* Nombre el archivo a abrir o crear, vacio solo para nuevos */
        lNuevoFile = NO.                            /* Si va crear un nuevo archivo o abrir */

        {lib\excel-open-file.i}

    lMensajeAlTerminar = NO. /*  */
    lCerrarAlTerminar = YES.     /* Si permanece abierto el Excel luego de concluir el proceso */

    /*
    /* Open an Excel document  */
    chExcel:Workbooks:Open("c:\temp\test1.xlsx"). 
    chExcel:visible = true.
    
    /* Sets the number of sheets that will be   automatically inserted into new workbooks */
    chExcel:SheetsInNewWorkbook = 5.
    
    /* Add a new workbook */
    chWorkbook = chExcel:Workbooks:Add().
    
    /* Add a new worksheet as the last sheet */
    chWorksheet = chWorkbook:Worksheets(5).
    chWorkbook:Worksheets:add(, chWorksheet).
    RELEASE OBJECT chWorksheet.
    
    /* Select a worksheet */
    chWorkbook:Worksheets(2):Activate.
    chWorksheet = chWorkbook:Worksheets(2).
    
    /* Rename the worksheet */
    chWorkSheet:NAME = "test".
    */

    /* Adiciono  */
   /* 
        chWorkbook = chExcelApplication:Workbooks:Add().               
   */

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /*
        /* NUEVO */
        chWorkbook = chExcelApplication:Workbooks:Add().
        chWorkSheet = chExcelApplication:Sheets:Item(1).
    */

    iColumn = 1.
    lLinea = 19.

    DEFINE VAR x-registros AS INT.
    DEFINE VAR x-registros-validos AS INT.

    DEFINE VAR x-imp-comision AS DEC.
    DEFINE VAR x-factor-comision AS DEC.
    DEFINE VAR x-comision-calculada AS DEC.
    DEFINE VAR x-total-calculado AS DEC.
    DEFINE VAR x-total-enviada AS DEC.

    DEFINE VAR x-origen-tarjeta AS CHAR.
    DEFINE VAR x-tipo-tarjeta AS CHAR.

    SESSION:SET-WAIT-STATE("GENERAL").

    cColumn = STRING(lLinea).
    REPEAT lLinea = 4 TO 65000 :
        cColumn = STRING(lLinea).

        cRange = "B" + cColumn.
        xCaso = chWorkSheet:Range(cRange):TEXT.

        IF xCaso = "" OR xCaso = ? THEN LEAVE.    /* FIN DE DATOS */

        x-registros = x-registros + 1.

        /* PEDIDO */
        cRange = "Z" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        cValor = STRING(INTEGER(cValor)).

        FIND FIRST t-interfase WHERE t-interfase.codcia = s-codcia AND
                                            t-interfase.pedido_cliente = cValor NO-LOCK NO-ERROR.

        IF NOT AVAILABLE t-interfase THEN NEXT.

        /* TIPO OPERACION  */
        cRange = "G" + cColumn.
        cValor = CAPS(TRIM(chWorkSheet:Range(cRange):TEXT)).        
        IF cValor <> "VENTA" THEN NEXT.

        /* ORIGEN DE TARJETA  */
        cRange = "J" + cColumn.
        cValor = CAPS(TRIM(chWorkSheet:Range(cRange):TEXT)).        
        IF LOOKUP(cValor,"NACIONAL,INTERNACIONAL") = 0 THEN NEXT.
        x-origen-tarjeta = cValor.
        
        /* TIPO TARJETA  */
        cRange = "K" + cColumn.
        cValor = LC(TRIM(chWorkSheet:Range(cRange):TEXT)).        
        IF LOOKUP(cValor,"crédito,débito,credito,debito") = 0 THEN NEXT.
        x-tipo-tarjeta = cValor. 

        /* Registro Valido */
        x-registros-validos = x-registros-validos + 1.

        ASSIGN t-interfase.origen-tarjeta = x-origen-tarjeta
                t-interfase.modalidad-tarjeta = x-tipo-tarjeta.

        /* Importe Transaccion */
        cRange = "N" + cColumn.
        cValor = TRIM(chWorkSheet:Range(cRange):TEXT).
        cValor = REPLACE(cValor,",","").
        cValor = REPLACE(cValor,"S/","").
        
        dValor = DECIMAL(cValor).
        ASSIGN t-interfase.impte-transaccion = dvalor.

        /* Comision Total */
        cRange = "P" + cColumn.
        cValor = TRIM(chWorkSheet:Range(cRange):TEXT).
        cValor = REPLACE(cValor,",","").
        cValor = REPLACE(cValor,"S/","").
        
        dValor = DECIMAL(cValor).
        ASSIGN t-interfase.comision-enviada = dvalor.

        /* Comision Gravable */
        cRange = "Q" + cColumn.
        cValor = TRIM(chWorkSheet:Range(cRange):TEXT).
        cValor = REPLACE(cValor,",","").
        cValor = REPLACE(cValor,"S/","").
        
        dValor = DECIMAL(cValor).
        ASSIGN t-interfase.comision-gravable = dvalor.

        /* Importe IGV */
        cRange = "R" + cColumn.
        cValor = TRIM(chWorkSheet:Range(cRange):TEXT) NO-ERROR.
        cValor = REPLACE(cValor,",","").
        cValor = REPLACE(cValor,"S/","").

        dValor = DECIMAL(cValor).
        ASSIGN t-interfase.impte-igv = dvalor.

        /* Neto Abonar */
        cRange = "S" + cColumn.
        cValor = TRIM(chWorkSheet:Range(cRange):TEXT).
        cValor = REPLACE(cValor,",","").
        cValor = REPLACE(cValor,"S/","").
        
        dValor = DECIMAL(cValor).
        ASSIGN t-interfase.neto_abonar = dvalor.

        /* Fecha Abono */
        cRange = "U" + cColumn.
        cValor = TRIM(chWorkSheet:Range(cRange):TEXT).
        
        fValor = DATE(cValor).
        ASSIGN t-interfase.fecha_abono = fvalor.

        x-factor-comision = 0.
        x-comision-calculada = 0.

        RUN calculo-comision(INPUT t-interfase.libre_dec[15], INPUT x-origen-tarjeta, 
                                INPUT x-tipo-tarjeta, OUTPUT x-comision-calculada,
                                OUTPUT x-factor-comision).

        x-total-calculado = x-total-calculado + x-comision-calculada.        
        x-total-enviada = x-total-enviada + t-interfase.comision-enviada.

        ASSIGN t-interfase.libre_char[15] = "PRE-CONCILIAR"
                t-interfase.comision-calculada = x-comision-calculada
                t-interfase.porcentaje-comision = x-factor-comision.

        x-diferencias-color = YES.
        

    END.    
    {&open-query-browse-3}


    fill-in-enviada:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-total-enviada,"->,>>>,>>9.99").
    fill-in-calculada:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-total-calculado,"->,>>>,>>9.99").

    SESSION:SET-WAIT-STATE("").

        {lib\excel-close-file.i}


    MESSAGE "Se cargaron " + STRING(x-registros-validos) + " registros" SKIP 
            "del total de " + STRING(x-registros) + " que tiene el Excel"
            VIEW-AS ALERT-BOX INFORMATION.


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
  /*
  FILL-IN-FchDoc = TODAY - DAY(TODAY) + 1.
  FILL-IN-FchDoc-2 = fill-in-fchdoc + x-rango.
  */
  
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
  {src/adm/template/snd-list.i "T-INTERFASE"}
  {src/adm/template/snd-list.i "T-CPEDI"}

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

