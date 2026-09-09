&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CcbCDocu NO-UNDO LIKE CcbCDocu.



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

DEFINE SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */

DEFINE VAR x-divi-ori AS CHAR.

DEFINE VAR x-fecha-ini AS DATE.
DEFINE VAR x-fecha-fin AS DATE.
DEFINE VAR x-fecha-entrega-ini AS DATE.
DEFINE VAR x-fecha-entrega-fin AS DATE.
DEFINE VAR x-solo-pendientes AS LOG INIT YES.
DEFINE VAR x-tabla AS CHAR.
DEFINE VAR x-es-query AS LOG INIT YES.

DEFINE VAR x-col-fentrega AS DATE.
DEFINE VAR x-col-lugent AS CHAR.

x-divi-ori = '00101'.

x-fecha-ini = TODAY - 5.
x-fecha-fin = TODAY.
x-fecha-entrega-ini = TODAY - 5.
x-fecha-entrega-fin = TODAY + 5.
x-tabla = "COURIER-URBANO".

DEFINE TEMP-TABLE ttPacking
    FIELD   tcodsegui   AS  CHAR    FORMAT 'x(25)'   COLUMN-LABEL "Codigo Seguimiento"
    FIELD   tdocref     AS  CHAR    FORMAT 'x(25)'  COLUMN-LABEL "Doc. Referencia"
    FIELD   tcodadic    AS  CHAR    FORMAT 'x(25)'  COLUMN-LABEL "Codigo adicional"
    FIELD   tcontenido  AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Contenido"
    FIELD   tpeso       AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Peso"
    FIELD   tpiezas     AS  INT     FORMAT '>>>,>>9'    COLUMN-LABEL "Piezas"
    FIELD   tcodcli     AS  CHAR    FORMAT 'x(12)'  COLUMN-LABEL "Codigo cliente"
    FIELD   tnomcli     AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Nombre destinatario"
    FIELD   tempresa    AS  CHAR    FORMAT 'x(3)'   COLUMN-LABEL "Empresa/Centro de negocio"
    FIELD   tdireccion  AS  CHAR    FORMAT 'x(150)' COLUMN-LABEL "Direccion"
    FIELD   tdirrefe    AS  CHAR    FORMAT 'x(150)' COLUMN-LABEL "Referencia direccion"
    FIELD   tdistrito   AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Distrito"
    FIELD   tprovincia  AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Provincia"
    FIELD   tdepto      AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Departamento"
    FIELD   tubigeo     AS  CHAR    FORMAT 'x(10)'  COLUMN-LABEL "Ubigeo"
    FIELD   ttelefono   AS  CHAR    FORMAT 'x(15)'  COLUMN-LABEL "Telefono"
    .

DEFINE TEMP-TABLE ttScharff
    FIELD   tcodclie        AS  CHAR    FORMAT 'x(15)'   COLUMN-LABEL "Codigo Cliente"
    FIELD   tpaquete        AS  INT    FORMAT '>,>>>,>>9'  COLUMN-LABEL "Paquete" INIT 0
    FIELD   tnroguia        AS  CHAR    FORMAT 'x(25)'  COLUMN-LABEL "Nro de guia"
    FIELD   tfechaguia      AS  DATE    COLUMN-LABEL "Fecha Guia"
    FIELD   tciudad         AS  CHAR     FORMAT 'x(100)'    COLUMN-LABEL "Ciudad"
    FIELD   tdepartamento   AS  CHAR     FORMAT 'x(100)'    COLUMN-LABEL "Departamento"
    FIELD   tdistrito       AS  CHAR    FORMAT 'x(100)'  COLUMN-LABEL "Distrito"
    FIELD   tdireccion      AS  CHAR    FORMAT 'x(150)' COLUMN-LABEL "Direccion"
    FIELD   tciudad1        AS  CHAR     FORMAT 'x(100)'    COLUMN-LABEL "Ciudad entrega"
    FIELD   tdepartamento1  AS  CHAR     FORMAT 'x(100)'    COLUMN-LABEL "Departamento entrega"
    FIELD   tdistrito1      AS  CHAR    FORMAT 'x(100)'  COLUMN-LABEL "Distrito entrega"
    FIELD   tdireccion1     AS  CHAR    FORMAT 'x(150)' COLUMN-LABEL "Direccion entrega"
    FIELD   treferencia1     AS  CHAR    FORMAT 'x(150)' COLUMN-LABEL "Referencia"
    FIELD   tdnicli         AS  CHAR    FORMAT 'x(12)'  COLUMN-LABEL "DNI Cliente"
    FIELD   tnomcli         AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Nombre Cliente"
    /*FIELD   tcontacto         AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Personal de contacto"*/
    FIELD   tcelular        AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Celular"
    FIELD   temailcli       AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Email cliente"
    FIELD   tproducto       AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Producto"
    FIELD   tqtyproductos   AS  INT     FORMAT '>>>,>>9'    COLUMN-LABEL "Cantidad de Productos"
    FIELD   tpeso           AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Peso Paquete (kg.)" INIT 0
    FIELD   tlargo          AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Largo Paquete (cm)" INIT 0
    FIELD   tancho          AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Ancho Paquete (cm)" INIT 0
    FIELD   talto           AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Alto Paquete (cm)" INIT 0
    FIELD   tvalorventa     AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Valor del producto (antes de iVA)" INIT 0
    FIELD   tvolumen        AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Volumen" INIT 0
    .

DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER x-gn-divi FOR gn-divi.
DEFINE BUFFER x-tabdistr FOR tabdistr.
DEFINE BUFFER x-tabprov FOR tabprov.
DEFINE BUFFER x-tabdepto FOR tabdepto.

/* En definitions */
define var x-sort-column-current as char.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-20

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-CcbCDocu FacCPedi

/* Definitions for BROWSE BROWSE-20                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-20 T-CcbCDocu.CodDoc ~
T-CcbCDocu.NroDoc T-CcbCDocu.FchDoc ~
get-fentrega(T-CcbCDocu.codped, T-ccbcdocu.nroped) @ x-col-fentrega ~
T-CcbCDocu.CodCli T-CcbCDocu.NomCli T-CcbCDocu.Libre_c01 ~
T-CcbCDocu.Libre_c02 T-CcbCDocu.ImpTot ~
lugar-entrega(t-CcbCDocu.codped, t-ccbcdocu.nroped) @ x-col-lugent ~
T-CcbCDocu.CodDiv T-CcbCDocu.CodPed T-CcbCDocu.NroPed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-20 
&Scoped-define QUERY-STRING-BROWSE-20 FOR EACH T-CcbCDocu NO-LOCK, ~
      FIRST FacCPedi WHERE TRUE /* Join to T-CcbCDocu incomplete */ NO-LOCK ~
    BY FacCPedi.FchEnt INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-20 OPEN QUERY BROWSE-20 FOR EACH T-CcbCDocu NO-LOCK, ~
      FIRST FacCPedi WHERE TRUE /* Join to T-CcbCDocu incomplete */ NO-LOCK ~
    BY FacCPedi.FchEnt INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-20 T-CcbCDocu FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-20 T-CcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-20 FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-20}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-aquien FILL-IN-divi-ori ~
FILL-IN-desde FILL-IN-hasta FILL-IN-entrega-desde FILL-IN-entrega-hasta ~
TOGGLE-pendientes FILL-IN-divi-despacho FILL-IN-OD FILL-IN-nomcli ~
RADIO-SET-cliente BUTTON-refrescar BROWSE-20 BUTTON-generar 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-aquien FILL-IN-divi-ori ~
FILL-IN-desde FILL-IN-hasta FILL-IN-entrega-desde FILL-IN-entrega-hasta ~
TOGGLE-pendientes FILL-IN-divi-despacho FILL-IN-OD FILL-IN-nomcli ~
RADIO-SET-cliente FILL-IN-nomdivi FILL-IN-nomdespacho FILL-IN-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-fentrega W-Win 
FUNCTION get-fentrega RETURNS DATE
  ( INPUT pCodPed AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-nomdivi W-Win 
FUNCTION get-nomdivi RETURNS CHARACTER
  ( INPUT pCodDiv AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lugar-entrega W-Win 
FUNCTION lugar-entrega RETURNS CHARACTER
  ( INPUT pCodPed AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-generar 
     LABEL "Generar Packing" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-refrescar 
     LABEL "Refrescar" 
     SIZE 13 BY 1.08.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(100)":U INITIAL "Use CTRL + Click para seleccionar los comprobantes que se van incluir en el PackingList" 
     VIEW-AS FILL-IN 
     SIZE 62 BY .81
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-divi-despacho AS CHARACTER FORMAT "X(6)":U 
     LABEL "Division de despacho" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-divi-ori AS CHARACTER FORMAT "X(6)":U INITIAL "00001" 
     LABEL "Division de venta" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-entrega-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Cuyas fechas para entregar sean Desde" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-entrega-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-nomcli AS CHARACTER FORMAT "X(80)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 45.43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-nomdespacho AS CHARACTER FORMAT "X(100)":U INITIAL "< Todas las divisiones de DESPACHO >" 
     VIEW-AS FILL-IN 
     SIZE 52 BY .81
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-nomdivi AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .81
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-OD AS CHARACTER FORMAT "X(15)":U 
     LABEL "O/D" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-aquien AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Urbano", 1,
"Scharff", 2
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-cliente AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Que empieze", 2,
"Que contenga", 3
     SIZE 34 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-pendientes AS LOGICAL INITIAL yes 
     LABEL "Solo pendientes de enviar" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-20 FOR 
      T-CcbCDocu, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-20 W-Win _STRUCTURED
  QUERY BROWSE-20 NO-LOCK DISPLAY
      T-CcbCDocu.CodDoc COLUMN-LABEL "Cod!Cmpte" FORMAT "x(5)":U
      T-CcbCDocu.NroDoc COLUMN-LABEL "Numero!Cmpte" FORMAT "X(15)":U
            WIDTH 10.43
      T-CcbCDocu.FchDoc COLUMN-LABEL "Fecha!Emision" FORMAT "99/99/9999":U
            WIDTH 8.43
      get-fentrega(T-CcbCDocu.codped, T-ccbcdocu.nroped) @ x-col-fentrega COLUMN-LABEL "Fecha!Entrega" FORMAT "99/99/9999":U
            WIDTH 7.43
      T-CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 12.43
      T-CcbCDocu.NomCli FORMAT "x(50)":U WIDTH 32.43
      T-CcbCDocu.Libre_c01 COLUMN-LABEL "Cod!Orden" FORMAT "x(5)":U
            WIDTH 4.43
      T-CcbCDocu.Libre_c02 COLUMN-LABEL "Nro!Orden" FORMAT "x(12)":U
            WIDTH 9.43
      T-CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 9.43
      lugar-entrega(t-CcbCDocu.codped, t-ccbcdocu.nroped) @ x-col-lugent COLUMN-LABEL "Lugar de entrega" FORMAT "x(120)":U
            WIDTH 24.43
      T-CcbCDocu.CodDiv COLUMN-LABEL "Division!Despacho" FORMAT "x(6)":U
            WIDTH 7.43
      T-CcbCDocu.CodPed COLUMN-LABEL "Cod!Ped" FORMAT "x(5)":U
      T-CcbCDocu.NroPed COLUMN-LABEL "Nro!Pedido" FORMAT "X(12)":U
            WIDTH 1.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS MULTIPLE SIZE 148.14 BY 17.5
         FONT 4
         TITLE "Comprobantes" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-aquien AT ROW 23.12 COL 107.57 NO-LABEL WIDGET-ID 38
     FILL-IN-divi-ori AT ROW 1.19 COL 12.72 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-desde AT ROW 1.15 COL 31.14 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-hasta AT ROW 1.15 COL 48 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-entrega-desde AT ROW 2.12 COL 31.14 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-entrega-hasta AT ROW 2.12 COL 48 COLON-ALIGNED WIDGET-ID 18
     TOGGLE-pendientes AT ROW 2.27 COL 63.43 WIDGET-ID 36
     FILL-IN-divi-despacho AT ROW 3.42 COL 15.86 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-OD AT ROW 3.35 COL 28.43 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-nomcli AT ROW 3.31 COL 48.57 COLON-ALIGNED WIDGET-ID 34
     RADIO-SET-cliente AT ROW 3.35 COL 96.43 NO-LABEL WIDGET-ID 30
     BUTTON-refrescar AT ROW 1.08 COL 63 WIDGET-ID 8
     BROWSE-20 AT ROW 5.23 COL 1.86 WIDGET-ID 300
     FILL-IN-nomdivi AT ROW 1.19 COL 82.57 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-nomdespacho AT ROW 4.27 COL 16 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     BUTTON-generar AT ROW 22.92 COL 134 WIDGET-ID 10
     FILL-IN-1 AT ROW 23.12 COL 13 COLON-ALIGNED NO-LABEL WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 151.14 BY 23.38
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-CcbCDocu T "?" NO-UNDO INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Packing List - Courier"
         HEIGHT             = 23.38
         WIDTH              = 151.14
         MAX-HEIGHT         = 27.23
         MAX-WIDTH          = 186.29
         VIRTUAL-HEIGHT     = 27.23
         VIRTUAL-WIDTH      = 186.29
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
/* BROWSE-TAB BROWSE-20 BUTTON-refrescar F-Main */
ASSIGN 
       BROWSE-20:PRIVATE-DATA IN FRAME F-Main           = 
                "get-fentrega(T-CcbCDocu.codped, T-ccbcdocu.nroped) @ x-col-fentrega"
       BROWSE-20:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-nomdespacho IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-nomdivi IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-20
/* Query rebuild information for BROWSE BROWSE-20
     _TblList          = "Temp-Tables.T-CcbCDocu,INTEGRAL.FacCPedi WHERE Temp-Tables.T-CcbCDocu ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _OrdList          = "INTEGRAL.FacCPedi.FchEnt|yes"
     _FldNameList[1]   > Temp-Tables.T-CcbCDocu.CodDoc
"T-CcbCDocu.CodDoc" "Cod!Cmpte" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-CcbCDocu.NroDoc
"T-CcbCDocu.NroDoc" "Numero!Cmpte" "X(15)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-CcbCDocu.FchDoc
"T-CcbCDocu.FchDoc" "Fecha!Emision" ? "date" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"get-fentrega(T-CcbCDocu.codped, T-ccbcdocu.nroped) @ x-col-fentrega" "Fecha!Entrega" "99/99/9999" ? ? ? ? ? ? ? no "Ayudaaaaaaaaaaaaa" no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-CcbCDocu.CodCli
"T-CcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-CcbCDocu.NomCli
"T-CcbCDocu.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "32.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-CcbCDocu.Libre_c01
"T-CcbCDocu.Libre_c01" "Cod!Orden" "x(5)" "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-CcbCDocu.Libre_c02
"T-CcbCDocu.Libre_c02" "Nro!Orden" "x(12)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-CcbCDocu.ImpTot
"T-CcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"lugar-entrega(t-CcbCDocu.codped, t-ccbcdocu.nroped) @ x-col-lugent" "Lugar de entrega" "x(120)" ? ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-CcbCDocu.CodDiv
"T-CcbCDocu.CodDiv" "Division!Despacho" "x(6)" "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-CcbCDocu.CodPed
"T-CcbCDocu.CodPed" "Cod!Ped" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.T-CcbCDocu.NroPed
"T-CcbCDocu.NroPed" "Nro!Pedido" ? "character" ? ? ? ? ? ? no ? no no "1.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-20 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Packing List - Courier */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Packing List - Courier */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-20
&Scoped-define SELF-NAME BROWSE-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-20 W-Win
ON START-SEARCH OF BROWSE-20 IN FRAME F-Main /* Comprobantes */
DO:
    DEFINE VAR x-sql AS CHAR.

    x-sql = "FOR EACH T-CcbCDocu NO-LOCK, FIRST INTEGRAL.FacCPedi WHERE TRUE NO-LOCK".

    {gn/sort-browse.i &ThisBrowse="browse-20" &ThisSQL = x-SQL}

END.

/*
EACH Temp-Tables.T-CcbCDocu NO-LOCK,
      FIRST INTEGRAL.FacCPedi WHERE TRUE /* Join to Temp-Tables.T-CcbCDocu incomplete */ NO-LOCK
    BY FacCPedi.FchEnt INDEXED-REPOSITION
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-20 W-Win
ON VALUE-CHANGED OF BROWSE-20 IN FRAME F-Main /* Comprobantes */
DO:
    DEFINE VAR x-coddoc AS CHAR.
    DEFINE VAR x-nrodoc AS CHAR.


  IF AVAILABLE ccbcdocu THEN DO:
      x-coddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddoc.
      x-nrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                  vtatabla.tabla = x-tabla AND
                                  vtatabla.llave_c1 = x-coddoc AND
                                  vtatabla.llave_c2 = x-nrodoc
                                  NO-LOCK NO-ERROR.
      IF AVAILABLE vtatabla THEN DO:
          MESSAGE 'Comprobante ' + x-coddoc + ' ' + x-nrodoc + ' ya fue enviado' SKIP
                  'Desea reenviarlo?' VIEW-AS ALERT-BOX QUESTION
                  BUTTONS YES-NO UPDATE rpta AS LOG.
          IF rpta = NO THEN DO:
            browse-20:DESELECT-FOCUSED-ROW().
            RETURN NO-APPLY.
          END.
               
          
      END.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-generar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-generar W-Win
ON CHOOSE OF BUTTON-generar IN FRAME F-Main /* Generar Packing */
DO:
    ASSIGN radio-set-aquien.

    x-tabla = "COURIER-URBANO".
    IF radio-set-aquien = 2 THEN x-tabla = "COURIER-SCHARFF".

  RUN procesar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-refrescar W-Win
ON CHOOSE OF BUTTON-refrescar IN FRAME F-Main /* Refrescar */
DO:
  ASSIGN fill-in-divi-ori fill-in-desde fill-in-hasta fill-in-entrega-desde fill-in-entrega-hasta.
  ASSIGN fill-in-divi-despacho fill-in-OD radio-set-cliente fill-in-nomcli toggle-pendientes.
  
  IF TRUE <> (fill-in-divi-ori > "") THEN DO:
      MESSAGE "Ingrese la division de venta" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  IF fill-in-desde = ? OR fill-in-hasta = ? THEN DO:
      MESSAGE "Ingrese rango de fechas emision que sean correctas"
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  IF fill-in-desde > fill-in-hasta THEN DO:
      MESSAGE "Ingrese rango de fechas emision que sean correctas(*)"
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  IF fill-in-entrega-desde = ? OR fill-in-entrega-hasta = ? THEN DO:
      MESSAGE "Ingrese rango de fechas entregas que sean correctas"
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  IF fill-in-entrega-desde > fill-in-entrega-hasta THEN DO:
      MESSAGE "Ingrese rango de fechas emision que sean correctas(**)"
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  IF NOT (TRUE <> (fill-in-divi-despacho > "")) THEN DO:
      FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                                gn-divi.coddiv = fill-in-divi-despacho NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-divi THEN DO:
          MESSAGE "Division de DESPACHO no existe"
              VIEW-AS ALERT-BOX INFORMATION.
      END.

  END.

  FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                            gn-divi.coddiv = fill-in-divi-ori NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-divi THEN DO:
      MESSAGE "Division de ventas no existe"
          VIEW-AS ALERT-BOX INFORMATION.
  END.

  x-divi-ori = fill-in-divi-ori.
  x-fecha-ini = fill-in-desde.
  x-fecha-fin = fill-in-hasta.
  x-fecha-entrega-ini = fill-in-entrega-desde.
  x-fecha-entrega-fin = fill-in-entrega-hasta.
  x-solo-pendientes = toggle-pendientes.
  
  SESSION:SET-WAIT-STATE("GENERAL").
  RUN carga-temporal.
  {&open-query-browse-20}
  SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-divi-despacho
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-divi-despacho W-Win
ON LEAVE OF FILL-IN-divi-despacho IN FRAME F-Main /* Division de despacho */
DO:
  FILL-in-nomdespacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = get-nomdivi(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-divi-ori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-divi-ori W-Win
ON LEAVE OF FILL-IN-divi-ori IN FRAME F-Main /* Division de venta */
DO:
  FILL-in-nomdivi:SCREEN-VALUE IN FRAME {&FRAME-NAME} = get-nomdivi(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/*
ON FIND OF ccbcdocu DO:
        
    IF x-es-query = YES THEN DO:
        IF x-solo-pendientes = YES THEN DO:
            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                        vtatabla.tabla = x-tabla AND
                                        vtatabla.llave_c1 = ccbcdocu.coddoc AND
                                        vtatabla.llave_c2 = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
            IF AVAILABLE vtatabla THEN DO:
                RETURN ERROR.
            END.
        END.
    END.

    RETURN.
END.
*/

DEF VAR celda_br AS WIDGET-HANDLE EXTENT 150 NO-UNDO.
 DEF VAR cual_celda AS WIDGET-HANDLE NO-UNDO.
 DEF VAR n_cols_browse AS INT NO-UNDO.
 DEF VAR col_act AS INT NO-UNDO.
 DEF VAR t_col_br AS INT NO-UNDO INITIAL 11.            /* Color del background de la celda ( 2 : Verde)*/
 DEF VAR vg_col_eti_b AS INT NO-UNDO INITIAL 28.        /* Color del la letra de la celda (15 : Blanco) */      

ON ROW-DISPLAY OF browse-20
DO:
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = x-tabla AND
                                vtatabla.llave_c1 = ccbcdocu.coddoc AND
                                vtatabla.llave_c2 = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        cual_celda = celda_br[2].
        /*
        cual_celda:BGCOLOR = 12.
        cual_celda:FGCOLOR = 15.
        */
    END.

    /*
  IF CURRENT-RESULT-ROW("browse-20") / 2 <> INT (CURRENT-RESULT-ROW("browse-1") / 2) THEN RETURN.
  o asi
  IF table.field <> 'XYZ' THEN return.

  DO col_act = 1 TO n_cols_browse.
      
     cual_celda = celda_br[col_act].
     cual_celda:BGCOLOR = t_col_br.
  END.
  */
END.

DO n_cols_browse = 1 TO browse-20:NUM-COLUMNS.
   celda_br[n_cols_browse] = browse-20:GET-BROWSE-COLUMN(n_cols_browse).
   cual_celda = celda_br[n_cols_browse].
     
   IF vg_col_eti_b <> 0 THEN cual_celda:LABEL-BGCOLOR = vg_col_eti_b.
   /*IF n_cols_browse = 15 THEN LEAVE.*/
END.

n_cols_browse = browse-20:NUM-COLUMNS.
/* IF n_cols_browse > 15 THEN n_cols_browse = 15. */

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

EMPTY TEMP-TABLE T-ccbcdocu.   
DEFINE VAR x-nomcli AS CHAR.
                                                        
FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia and
                        ccbcdocu.divori = x-divi-ori and
                        (ccbcdocu.fchdoc >= x-fecha-ini and ccbcdocu.fchdoc <= x-fecha-fin) and
                        CAN-DO("FAC,BOL",ccbcdocu.coddoc) and
                        ccbcdocu.flgest <> "A" NO-LOCK,
          FIRST INTEGRAL.FacCPedi WHERE FacCPedi.CodCia = ccbcdocu.codcia and
                                        faccpedi.coddoc = ccbcdocu.codped and
                                        faccpedi.nroped = ccbcdocu.nroped and
                                        (faccpedi.fchent >= x-fecha-entrega-ini and 
                                         faccpedi.fchent <= x-fecha-entrega-fin) NO-LOCK:
    IF x-solo-pendientes = YES THEN DO:
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                    vtatabla.tabla = x-tabla AND
                                    vtatabla.llave_c1 = ccbcdocu.coddoc AND
                                    vtatabla.llave_c2 = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
        IF AVAILABLE vtatabla THEN DO:
            NEXT.
        END.
    END.

    IF NOT (TRUE <> (fill-in-divi-despacho > "")) THEN DO:
        IF ccbcdocu.coddiv <> fill-in-divi-despacho THEN NEXT.
    END.
    IF NOT (TRUE <> (fill-in-OD > "")) THEN DO:
        IF NOT (ccbcdocu.libre_c02 BEGINS fill-in-OD) THEN NEXT.
    END.
    IF radio-set-cliente > 1 AND NOT (TRUE <> (fill-in-nomcli > "")) THEN DO:
        x-nomcli = TRIM(fill-in-nomcli).
        CASE radio-set-cliente:
            WHEN 2 THEN DO:
                IF NOT (ccbcdocu.nomcli BEGINS x-nomcli) THEN NEXT.
            END.
            WHEN 3 THEN DO:
                x-nomcli = "*" + x-nomcli + "*".
                IF NOT (ccbcdocu.nomcli MATCHES x-nomcli) THEN NEXT.
            END.
        END CASE.
    END.

    CREATE T-ccbcdocu.
    BUFFER-COPY ccbcdocu TO T-ccbcdocu.

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
  DISPLAY RADIO-SET-aquien FILL-IN-divi-ori FILL-IN-desde FILL-IN-hasta 
          FILL-IN-entrega-desde FILL-IN-entrega-hasta TOGGLE-pendientes 
          FILL-IN-divi-despacho FILL-IN-OD FILL-IN-nomcli RADIO-SET-cliente 
          FILL-IN-nomdivi FILL-IN-nomdespacho FILL-IN-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-SET-aquien FILL-IN-divi-ori FILL-IN-desde FILL-IN-hasta 
         FILL-IN-entrega-desde FILL-IN-entrega-hasta TOGGLE-pendientes 
         FILL-IN-divi-despacho FILL-IN-OD FILL-IN-nomcli RADIO-SET-cliente 
         BUTTON-refrescar BROWSE-20 BUTTON-generar 
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

  fill-in-divi-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-divi-ori.
  fill-in-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-fecha-ini,"99/99/9999").
  fill-in-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-fecha-fin,"99/99/9999").
  fill-in-entrega-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-fecha-entrega-ini,"99/99/9999").
  fill-in-entrega-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-fecha-entrega-fin,"99/99/9999").

  FILL-in-nomdivi:SCREEN-VALUE IN FRAME {&FRAME-NAME} = get-nomdivi(fill-in-divi-ori:SCREEN-VALUE).

  RUN refrescar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lugar-de-entrega W-Win 
PROCEDURE lugar-de-entrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodPed AS CHAR. /* PED,O/D, OTR */
DEFINE INPUT PARAMETER pNroPed AS CHAR.
DEFINE OUTPUT PARAMETER pLugEnt AS CHAR.
DEFINE OUTPUT PARAMETER pUbigeo AS CHAR.
DEFINE OUTPUT PARAMETER pRefer AS CHAR.

pLugEnt = lugar-entrega(pCodPed, pNroped).
pUbigeo = "||".
pRefer = "".

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                    x-faccpedi.coddoc = pCodPed AND
                    x-faccpedi.nroped = pNroped NO-LOCK NO-ERROR.
IF AVAILABLE x-faccpedi THEN DO:
    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
        gn-clie.codcli = x-Faccpedi.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:       
        FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Sede = x-Faccpedi.Ubigeo[1]
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clied THEN DO:
            pRefer = TRIM(gn-clieD.referencias).
            pUbigeo = TRIM(gn-clied.coddept) + "|" + TRIM(gn-clied.codprov) + "|" + TRIM(gn-clied.coddist).
        END.            
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE peso-piezas W-Win 
PROCEDURE peso-piezas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodOrden AS CHAR.
DEFINE INPUT PARAMETER pNroOrden AS CHAR.
DEFINE OUTPUT PARAMETER pPeso AS DEC.
DEFINE OUTPUT PARAMETER pPiezas AS INT.

pPeso = 0.
pPiezas = 0.
FOR EACH ControlOD WHERE ControlOD.codcia = s-codcia AND
                        ControlOD.coddoc = pCodOrden AND
                        ControlOD.nrodoc = pNroOrden NO-LOCK:
    pPeso = pPeso + ControlOD.pesart.
    pPiezas = pPiezas + 1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar W-Win 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ttPacking.

DEFINE VAR x-cont AS INT.
DEFINE VAR x-totregs AS INT.
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-total-regs AS INT.

DEFINE VAR x-duplicados AS INT.

SESSION:SET-WAIT-STATE("GENERAL").

DO WITH FRAME {&FRAME-NAME}:
    x-totregs = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO x-Cont = 1 TO x-totregs :        
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(x-cont) THEN DO:
            x-coddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddoc.
            x-nrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                        vtatabla.tabla = x-tabla AND
                                        vtatabla.llave_c1 = x-coddoc AND
                                        vtatabla.llave_c2 = x-nrodoc
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE vtatabla THEN DO:
                x-duplicados = x-duplicados + 1.
            END.

            x-total-regs = x-total-regs + 1.

        END.
    END.
END.

SESSION:SET-WAIT-STATE("").

IF x-duplicados > 0 THEN DO:
        MESSAGE 'Hay ' + STRING(x-duplicados) + ' comprobante(s) que se esta enviando mas de una vez' SKIP
            'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN.

END.

MESSAGE 'Se van a enviar ' + STRING(x-total-regs) + ' comprobante(s) para el reparto' SKIP
    'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta2 AS LOG.
IF rpta2 = NO THEN RETURN.

/* ------------ */
DEFINE VAR lDirectorio AS CHAR.

lDirectorio = "".

SYSTEM-DIALOG GET-DIR lDirectorio  
   RETURN-TO-START-DIR 
   TITLE 'Directorio Files'.
IF lDirectorio = "" THEN DO :
    MESSAGE "Proceso cancelado" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

SESSION:SET-WAIT-STATE("GENERAL").

IF radio-set-aquien = 1 THEN DO:
    RUN procesar-urbano.
END.
ELSE DO:
    RUN procesar-scharff.
END.

SESSION:SET-WAIT-STATE("").

DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR x-tiempo AS CHAR.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

x-tiempo = STRING(TODAY,"99/99/9999") + "-" + STRING(TIME,"HH:MM:SS").
x-tiempo = REPLACE(x-tiempo,"/","").
x-tiempo = REPLACE(x-tiempo,":","").

IF radio-set-aquien = 1 THEN DO:
    c-xls-file = lDirectorio + "\Urbano-" + x-tiempo + ".xlsx".

    run pi-crea-archivo-csv IN hProc (input  buffer ttPacking:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer ttPacking:handle,
                            input  c-csv-file,
                            output c-xls-file) .
END.
ELSE DO:
    c-xls-file = lDirectorio + "\Scharff-" + x-tiempo + ".xlsx".

    run pi-crea-archivo-csv IN hProc (input  buffer ttScharff:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer ttScharff:handle,
                            input  c-csv-file,
                            output c-xls-file) .
END.

DELETE PROCEDURE hProc.

MESSAGE "Se creo y grabo el archivo en " SKIP
        c-xls-file VIEW-AS ALERT-BOX INFORMATION.

SESSION:SET-WAIT-STATE("GENERAL").
RUN carga-temporal.
{&open-query-browse-20}
SESSION:SET-WAIT-STATE("").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-scharff W-Win 
PROCEDURE procesar-scharff :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-peso AS DEC.
DEFINE VAR x-volumen AS DEC.
DEFINE VAR x-piezas AS INT.
DEFINE VAR x-codorden AS CHAR.
DEFINE VAR x-nroorden AS CHAR.
DEFINE VAR x-codcli AS CHAR.
DEFINE VAR x-lugent AS CHAR.
DEFINE VAR x-ubigeo AS CHAR.
DEFINE VAR x-refer AS CHAR.
DEFINE VAR x-dpto AS CHAR.
DEFINE VAR x-prov AS CHAR.
DEFINE VAR x-dist AS CHAR.

DEFINE VAR x-dni AS CHAR.

DEFINE VAR x-cont AS INT.
DEFINE VAR x-totregs AS INT.
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-total-regs AS INT.

DEFINE VAR x-telf AS CHAR.
DEFINE VAR x-referencia AS CHAR.

DEFINE VAR x-codconti AS CHAR INIT "NO EXISTE".

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = "SCHARFF" AND 
                            factabla.codigo = "COD.CLIE" NO-LOCK NO-ERROR.
IF AVAILABLE factabla THEN DO:
    x-codconti = factabla.campo-c[1].
END.

DISABLE TRIGGERS FOR LOAD OF vtatabla.

DO WITH FRAME {&FRAME-NAME}:
    /*DO iCont = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:*/
    x-totregs = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO x-Cont = 1 TO x-totregs :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(x-cont) THEN DO:

            x-peso = 0.
            x-piezas = 0.
            x-codorden = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c01.
            x-nroorden = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c02.
            x-codcli = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codcli.
            x-coddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddoc.
            x-nrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

            RUN peso-piezas(INPUT x-codorden, INPUT x-nroorden,
                            OUTPUT x-peso, OUTPUT x-piezas).

            /* Volumen */
            x-volumen = 0.
            FOR EACH ccbddocu WHERE ccbddocu.codcia = s-codcia AND
                                        ccbddocu.coddoc = x-coddoc AND
                                        ccbddocu.nrodoc = X-nrodoc NO-LOCK:
                FIND FIRST almmmatg OF ccbddoc NO-LOCK NO-ERROR.
                IF AVAILABLE almmmatg THEN DO:
                    x-volumen = x-volumen + ((almmmatg.libre_d02 / 1000000) * ccbddocu.candes).
                END.
            END.

            /* Con datos del pedido */
            RUN lugar-de-entrega(INPUT {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codped,
                                 INPUT {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nroped,
                                 OUTPUT x-lugent, OUTPUT x-ubigeo, OUTPUT x-refer).

            x-dpto = ENTRY(1,x-ubigeo,"|").
            x-prov = ENTRY(2,x-ubigeo,"|").
            x-dist = ENTRY(3,x-ubigeo,"|").

            FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                                    gn-clie.codcli = x-codcli NO-LOCK NO-ERROR.
            FIND FIRST tabdistr WHERE tabdistr.coddepto = x-dpto AND
                                    tabdistr.codprov = x-prov AND
                                    tabdistr.coddistr = x-dist NO-LOCK NO-ERROR.
            FIND FIRST tabprov WHERE tabprov.coddepto = x-dpto AND
                                    tabprov.codprov = x-prov  NO-LOCK NO-ERROR.
            FIND FIRST tabdepto WHERE tabdepto.coddepto = x-dpto NO-LOCK NO-ERROR.

            x-dni = "".
            x-telf = "".
            x-referencia = "".
            FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddoc = x-codorden AND
                                x-faccpedi.nroped = x-nroorden NO-LOCK NO-ERROR.
            IF AVAILABLE x-faccpedi THEN DO:
                x-dni = x-faccpedi.dnicli.
                x-telf = x-faccpedi.TelephoneContactReceptor.
                x-referencia = x-faccpedi.ReferenceAddress.
            END.
            IF TRUE <> (x-dni > "") THEN DO:
                x-dni = IF(AVAILABLE gn-clie) THEN gn-clie.dni ELSE "".
            END.
            IF TRUE <> (x-telf > "") THEN DO:
                x-telf = IF(AVAILABLE gn-clie) THEN gn-clie.telfnos[1] ELSE "".
            END.
            IF TRUE <> (x-referencia > "") THEN x-referencia = x-refer.

            /* Direccion de despacho */
            FIND FIRST x-gn-divi WHERE x-gn-divi.codcia = s-codcia AND
                                  x-gn-divi.coddiv = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddiv  NO-LOCK NO-ERROR.
            IF AVAILABLE x-gn-divi THEN DO:
                FIND FIRST x-tabdistr WHERE x-tabdistr.coddepto = x-gn-divi.campo-char[3] AND
                                        x-tabdistr.codprov = x-gn-divi.campo-char[4] AND
                                        x-tabdistr.coddistr = x-gn-divi.campo-char[5] NO-LOCK NO-ERROR.
                FIND FIRST x-tabprov WHERE x-tabprov.coddepto = x-gn-divi.campo-char[3] AND
                                        x-tabprov.codprov = x-gn-divi.campo-char[4]  NO-LOCK NO-ERROR.
                FIND FIRST x-tabdepto WHERE x-tabdepto.coddepto = x-gn-divi.campo-char[3] NO-LOCK NO-ERROR.                
            END.
            ELSE DO:
                /* Forzar que no existan */
                FIND FIRST x-tabdistr WHERE x-tabdistr.coddepto = "x-gn-divi.campo-char[3]" AND
                                        x-tabdistr.codprov = "x-gn-divi.campo-char[4]" AND
                                        x-tabdistr.coddistr = "x-gn-divi.campo-char[5]" NO-LOCK NO-ERROR.
                FIND FIRST x-tabprov WHERE x-tabprov.coddepto = "x-gn-divi.campo-char[3]" AND
                                        x-tabprov.codprov = "x-gn-divi.campo-char[4]"  NO-LOCK NO-ERROR.
                FIND FIRST x-tabdepto WHERE x-tabdepto.coddepto = "x-gn-divi.campo-char[3]" NO-LOCK NO-ERROR.                
            END.     

            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                        vtatabla.tabla = x-tabla AND
                                        vtatabla.llave_c1 = x-coddoc AND
                                        vtatabla.llave_c2 = x-nrodoc
                                        EXCLUSIVE-LOCK NO-ERROR.
            IF NOT LOCKED vtatabla THEN DO:
                
                IF NOT AVAILABLE vtatabla THEN DO:
                    CREATE vtatabla.
                    ASSIGN vtatabla.codcia = s-codcia 
                            vtatabla.tabla = x-tabla
                            vtatabla.llave_c1 = x-coddoc
                            vtatabla.llave_c2 = x-nrodoc.
                END.
                ASSIGN vtatabla.libre_c01 = USERID("DICTDB")
                    vtatabla.libre_c02 = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS").            
                
                CREATE ttScharff.
                    ASSIGN  ttScharff.tcodclie = x-codconti
                            ttScharff.tpaquete = x-piezas
                            ttScharff.tnroguia = x-nroorden
                            ttScharff.tfechaguia = TODAY
                            ttScharff.tciudad = IF(AVAILABLE x-tabprov) THEN x-tabprov.nomprov ELSE ""
                            ttScharff.tdepartamento = IF(AVAILABLE x-tabdepto) THEN x-tabdepto.nomdepto ELSE ""
                            ttScharff.tdistrito = IF(AVAILABLE x-tabdistr) THEN x-tabdistr.nomdistr ELSE ""
                            ttScharff.tdireccion = IF(AVAILABLE x-gn-divi) THEN x-gn-divi.dirdiv ELSE ""
                            ttScharff.tciudad1 = IF(AVAILABLE tabprov) THEN tabprov.nomprov ELSE ""
                            ttScharff.tdepartamento1 = IF(AVAILABLE tabdepto) THEN tabdepto.nomdepto ELSE ""
                            ttScharff.tdistrito1 = IF(AVAILABLE tabdistr) THEN tabdistr.nomdistr ELSE ""
                            ttScharff.tdireccion1 = x-lugent
                            ttScharff.treferencia1 = x-referencia
                            ttScharff.tdnicli = x-dni
                            ttScharff.tnomcli = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nomcli
                            /*ttScharff.tcontacto = ""*/
                            ttScharff.tcelular = x-telf
                            ttScharff.temailcli = ""
                            ttScharff.tproducto = "Utiles de Oficina"
                            ttScharff.tqtyproductos = 0
                            ttScharff.tpeso = x-peso
                            ttScharff.tlargo = 0
                            ttScharff.tancho = 0
                            ttScharff.talto = 0
                            ttScharff.tvalorventa = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.impvta
                            ttScharff.tvolumen = x-volumen
                .                            
            END.
        END.
    END.
END.

RELEASE vtatabla NO-ERROR.

END PROCEDURE.

/*
DEFINE TEMP-TABLE ttScratff
    FIELD   tcodclie        AS  CHAR    FORMAT 'x(15)'   COLUMN-LABEL "Codigo Cliente"
    FIELD   tpaquete        AS  INT    FORMAT '>,>>>,>>9'  COLUMN-LABEL "Paquete" INIT 0
    FIELD   tnroguia        AS  CHAR    FORMAT 'x(25)'  COLUMN-LABEL "Nro de guia"
    FIELD   tfechaguia      AS  DATE    COLUMN-LABEL "Fecha Guia"
    FIELD   tciudad         AS  CHAR     FORMAT 'x(100)'    COLUMN-LABEL "Ciudad"
    FIELD   tdepartamento   AS  CHAR     FORMAT 'x(100)'    COLUMN-LABEL "Departamento"
    FIELD   tdistrito       AS  CHAR    FORMAT 'x(100)'  COLUMN-LABEL "Distrito"
    FIELD   tdireccion      AS  CHAR    FORMAT 'x(150)' COLUMN-LABEL "Direccion"
    FIELD   tciudad1        AS  CHAR     FORMAT 'x(100)'    COLUMN-LABEL "Ciudad entrega"
    FIELD   tdepartamento1  AS  CHAR     FORMAT 'x(100)'    COLUMN-LABEL "Departamento entrega"
    FIELD   tdistrito1      AS  CHAR    FORMAT 'x(100)'  COLUMN-LABEL "Distrito entrega"
    FIELD   tdireccion1     AS  CHAR    FORMAT 'x(150)' COLUMN-LABEL "Direccion entrega"
    FIELD   tdnicli         AS  CHAR    FORMAT 'x(12)'  COLUMN-LABEL "DNI Cliente"
    FIELD   tnomcli         AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Nombre Cliente"
    FIELD   tcelular        AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Celular"
    FIELD   temailcli       AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Email cliente"
    FIELD   tproducto       AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Producto"
    FIELD   tqtyproductos   AS  INT     FORMAT '>>>,>>9'    COLUMN-LABEL "Cantidad de Productos"
    FIELD   tpeso           AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Peso Paquete (kg.)" INIT 0
    FIELD   tlargo          AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Largo Paquete (cm)" INIT 0
    FIELD   tancho          AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Ancho Paquete (cm)" INIT 0
    FIELD   talto           AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Alto Paquete (cm)" INIT 0
    FIELD   tvalorventa     AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Valor del producto (antes de iVA)" INIT 0
    FIELD   tvolumen        AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Volumen" INIT 0
    .

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-urbano W-Win 
PROCEDURE procesar-urbano :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-peso AS DEC.
DEFINE VAR x-piezas AS INT.
DEFINE VAR x-codorden AS CHAR.
DEFINE VAR x-nroorden AS CHAR.
DEFINE VAR x-codcli AS CHAR.
DEFINE VAR x-lugent AS CHAR.
DEFINE VAR x-ubigeo AS CHAR.
DEFINE VAR x-refer AS CHAR.
DEFINE VAR x-dpto AS CHAR.
DEFINE VAR x-prov AS CHAR.
DEFINE VAR x-dist AS CHAR.

DEFINE VAR x-cont AS INT.
DEFINE VAR x-totregs AS INT.
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-total-regs AS INT.

DISABLE TRIGGERS FOR LOAD OF vtatabla.

DO WITH FRAME {&FRAME-NAME}:
    /*DO iCont = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:*/
    x-totregs = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO x-Cont = 1 TO x-totregs :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(x-cont) THEN DO:

            x-peso = 0.
            x-piezas = 0.
            x-codorden = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c01.
            x-nroorden = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c02.
            x-codcli = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codcli.

            RUN peso-piezas(INPUT x-codorden, INPUT x-nroorden,
                            OUTPUT x-peso, OUTPUT x-piezas).

            /* Con datos del pedido */
            RUN lugar-de-entrega(INPUT {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codped,
                                 INPUT {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nroped,
                                 OUTPUT x-lugent, OUTPUT x-ubigeo, OUTPUT x-refer).

            x-dpto = ENTRY(1,x-ubigeo,"|").
            x-prov = ENTRY(2,x-ubigeo,"|").
            x-dist = ENTRY(3,x-ubigeo,"|").

            FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                                    gn-clie.codcli = x-codcli NO-LOCK NO-ERROR.
            FIND FIRST tabdistr WHERE tabdistr.coddepto = x-dpto AND
                                    tabdistr.codprov = x-prov AND
                                    tabdistr.coddistr = x-dist NO-LOCK NO-ERROR.
            FIND FIRST tabprov WHERE tabprov.coddepto = x-dpto AND
                                    tabprov.codprov = x-prov  NO-LOCK NO-ERROR.
            FIND FIRST tabdepto WHERE tabdepto.coddepto = x-dpto NO-LOCK NO-ERROR.

            x-coddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddoc.
            x-nrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                        vtatabla.tabla = x-tabla AND
                                        vtatabla.llave_c1 = x-coddoc AND
                                        vtatabla.llave_c2 = x-nrodoc
                                        EXCLUSIVE-LOCK NO-ERROR.
            IF NOT LOCKED vtatabla THEN DO:
                IF NOT AVAILABLE vtatabla THEN DO:
                    CREATE vtatabla.
                    ASSIGN vtatabla.codcia = s-codcia 
                            vtatabla.tabla = x-tabla
                            vtatabla.llave_c1 = x-coddoc
                            vtatabla.llave_c2 = x-nrodoc.
                END.
                ASSIGN vtatabla.libre_c01 = USERID("DICTDB")
                    vtatabla.libre_c02 = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS").            

                CREATE ttPacking.
                    ASSIGN tcodsegui    = x-coddoc + "-" + x-nrodoc
                    tdocref     = x-coddoc + "-" + x-nrodoc
                    tcodadic    = ""
                    tcontenido  = "UTILES DE OFICINA"
                    tpeso       = x-peso
                    tpiezas     = x-piezas
                    tcodcli     = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codcli
                    tnomcli     = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nomcli
                    tempresa    = ""   /*IF (gn-clie.libre_c01 = 'J') THEN "SI" ELSE "NO"*/
                    tdireccion  = x-lugent
                    tdirrefe    = x-refer
                    tdistrito   = IF(AVAILABLE tabdistr) THEN tabdistr.nomdistr ELSE ""
                    tprovincia  = IF(AVAILABLE tabprov) THEN tabprov.nomprov ELSE ""
                    tdepto      = IF(AVAILABLE tabdepto) THEN tabdepto.nomdepto ELSE ""
                    tubigeo     = REPLACE(x-ubigeo,"|","")
                    ttelefono   = gn-clie.telfnos[1]
            .
            END.
        END.
    END.
END.

RELEASE vtatabla NO-ERROR.

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
  {&open-query-browse-20}
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
  {src/adm/template/snd-list.i "T-CcbCDocu"}
  {src/adm/template/snd-list.i "FacCPedi"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-fentrega W-Win 
FUNCTION get-fentrega RETURNS DATE
  ( INPUT pCodPed AS CHAR, INPUT pNroPed AS CHAR ) :

    DEFINE VAR x-retval AS DATE INIT ?.

    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.coddoc = pCodPed AND
                            x-faccpedi.nroped = pNroped NO-LOCK NO-ERROR.

    IF AVAILABLE x-faccpedi THEN DO:
        x-retval = x-faccpedi.fchent.
    END.

  RETURN x-retval.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-nomdivi W-Win 
FUNCTION get-nomdivi RETURNS CHARACTER
  ( INPUT pCodDiv AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VAR x-retval AS CHAR.


  FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                        gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.

  IF AVAILABLE gn-divi THEN DO:
      x-retval = TRIM(gn-divi.desdiv).
  END.
  ELSE DO:
      x-retval = "** Division no existe **".
      IF TRUE <> (pCodDiv > "") THEN DO:
         x-retval = "< Todas las divisiones de DESPACHO >".
      END.      
  END.     
  

  RETURN x-retval.    /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lugar-entrega W-Win 
FUNCTION lugar-entrega RETURNS CHARACTER
  ( INPUT pCodPed AS CHAR, INPUT pNroPed AS CHAR ) :

    DEFINE VAR x-retval AS CHAR INIT "".

    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.coddoc = pCodPed AND
                            x-faccpedi.nroped = pNroped NO-LOCK NO-ERROR.

    IF AVAILABLE x-faccpedi THEN DO:
    
        FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
            gn-clie.codcli = x-Faccpedi.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            x-retval = "".  /*gn-clie.dircli.*/
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Sede = x-Faccpedi.Ubigeo[1]
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN x-retval = Gn-ClieD.DirCli.
        END.
    END.

  RETURN x-retval.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

