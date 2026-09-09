&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-FacCPedi NO-UNDO LIKE FacCPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
DEFINE VAR X-MON AS CHARACTER NO-UNDO.
DEFINE VAR X-VTA AS CHARACTER NO-UNDO.
DEFINE VAR X-STA AS CHARACTER NO-UNDO.
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.

DEFINE VAR S-CODDOC AS CHAR INIT "O/D".
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE VAR R-COTI AS RECID.
DEFINE VAR F-ESTADO AS CHAR INIT "P,C,A".   /* Valores por defecto */

DEFINE VAR x-Items AS INT NO-UNDO.
DEFINE VAR x-Peso  AS DEC NO-UNDO.
DEFINE VAR x-Linea10 AS DEC NO-UNDO.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.


DEF TEMP-TABLE Detalle NO-UNDO
    FIELD coddiv    AS CHAR     FORMAT 'x(8)'       LABEL 'Division'
    FIELD nomdiv    AS CHAR     FORMAT 'x(50)'      LABEL 'Descripcion'
    FIELD coddoc    AS CHAR     FORMAT 'x(5)'       LABEL 'Codigo'
    FIELD nroped    AS CHAR     FORMAT 'x(15)'      LABEL '# Orden'
    FIELD codcli    AS CHAR     FORMAT 'x(15)'      LABEL 'Cliente'
    FIELD nomcli    AS CHAR     FORMAT 'x(100)'     LABEL 'Nombre'
    FIELD ordcmp    AS CHAR     FORMAT 'x(30)'      LABEL '#Orden Compra'
    FIELD codven    AS CHAR     FORMAT 'x(8)'       LABEL 'Vendedor'
    FIELD nomven    AS CHAR     FORMAT 'x(50)'      LABEL 'Nombre'
    FIELD fchped    AS DATE     FORMAT '99/99/9999' LABEL 'Fecha Emision'
    FIELD codalm    AS CHAR     FORMAT 'x(8)'       LABEL 'Almacen'
    FIELD fchent    AS DATE     FORMAT '99/99/9999' LABEL 'Fecha Entrega'
    FIELD tipvta    AS CHAR     FORMAT 'x(8)'       LABEL 'Tipo Venta'
    FIELD imptot    AS DECI     FORMAT '>>>,>>>,>>9.99' LABEL 'Importe Total'
    FIELD moneda    AS CHAR     FORMAT 'x(5)'       LABEL 'Moneda'
    FIELD estado    AS CHAR     FORMAT 'x(15)'       LABEL 'Estado'
    FIELD items     AS INT      FORMAT '>>>9'       LABEL '# de items'
    FIELD peso      AS DECI     FORMAT '>>>,>>9.99' LABEL 'Peso en kg'
    FIELD volumen   AS DECI     FORMAT '>>>,>>9.99' LABEL 'Volumen en m3'
    FIELD Departamento AS CHAR  FORMAT 'x(30)'      LABEL 'Departamento'
    FIELD Provincia    AS CHAR  FORMAT 'x(30)'      LABEL 'Provincia'
    FIELD Distrito     AS CHAR  FORMAT 'x(30)'      LABEL 'Distrito'
    FIELD ClienteRecoge AS CHAR FORMAT 'x(20)'      LABEL 'Cliente Recoge'
    .


DEF NEW SHARED VAR s-tpoped AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-FacCPedi FacCPedi gn-clie gn-ConVt gn-ven

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table t-FacCPedi.CodDiv FacCPedi.CodDoc ~
FacCPedi.NroPed FacCPedi.NroRef FacCPedi.CodCli FacCPedi.NomCli ~
FacCPedi.ordcmp FacCPedi.CodVen gn-ven.NomVen FacCPedi.FchPed ~
FacCPedi.CodAlm FacCPedi.FchEnt X-VTA @ X-VTA FacCPedi.ImpTot X-MON @ X-MON ~
t-FacCPedi.FlgEst fItems() @ x-Items FacCPedi.Peso FacCPedi.Volumen ~
t-FacCPedi.Cliente_Recoge 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH t-FacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = t-FacCPedi.CodCia ~
  AND FacCPedi.CodDoc = t-FacCPedi.CodDoc ~
  AND FacCPedi.NroPed = t-FacCPedi.NroPed NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = t-FacCPedi.CodCli ~
      AND gn-clie.CodCia = cl-codcia OUTER-JOIN NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = t-FacCPedi.FmaPgo OUTER-JOIN NO-LOCK, ~
      FIRST gn-ven OF t-FacCPedi OUTER-JOIN NO-LOCK ~
    BY t-FacCPedi.CodDoc ~
       BY t-FacCPedi.NroPed INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-FacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = t-FacCPedi.CodCia ~
  AND FacCPedi.CodDoc = t-FacCPedi.CodDoc ~
  AND FacCPedi.NroPed = t-FacCPedi.NroPed NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = t-FacCPedi.CodCli ~
      AND gn-clie.CodCia = cl-codcia OUTER-JOIN NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = t-FacCPedi.FmaPgo OUTER-JOIN NO-LOCK, ~
      FIRST gn-ven OF t-FacCPedi OUTER-JOIN NO-LOCK ~
    BY t-FacCPedi.CodDoc ~
       BY t-FacCPedi.NroPed INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table t-FacCPedi FacCPedi gn-clie ~
gn-ConVt gn-ven
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define THIRD-TABLE-IN-QUERY-br_table gn-clie
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table gn-ConVt
&Scoped-define FIFTH-TABLE-IN-QUERY-br_table gn-ven


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-23 RECT-24 BUTTON-19 BUTTON-Filtrar ~
btnExcel COMBO-BOX_CodDoc txtFchPed-1 txtFchPed-2 COMBO-BOX-3 wclient ~
wcotiza COMBO-BOX-5 txtAlm br_table 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-Divisiones COMBO-BOX_CodDoc ~
txtFchPed-1 txtFchPed-2 COMBO-BOX-3 wclient wcotiza COMBO-BOX-5 txtAlm 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fItems B-table-Win 
FUNCTION fItems RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnExcel 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "TEXTO" 
     SIZE 10 BY 2.15 TOOLTIP "Exportar a TEXTO"
     FONT 6.

DEFINE BUTTON BUTTON-19 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 19" 
     SIZE 5 BY 1.08.

DEFINE BUTTON BUTTON-Filtrar 
     LABEL "APLICAR FILTROS" 
     SIZE 35 BY 1.62
     FONT 8.

DEFINE VARIABLE COMBO-BOX-3 AS CHARACTER FORMAT "X(256)":U INITIAL "Despacho" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Despacho","Cliente" 
     DROP-DOWN-LIST
     SIZE 13.43 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-5 AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Condición" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Pendiente","Facturado","Atendido","Anulado" 
     DROP-DOWN-LIST
     SIZE 15 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE COMBO-BOX_CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "O/D" 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "O/D","O/M","AMBOS" 
     DROP-DOWN-LIST
     SIZE 11 BY 1
     FONT 6 NO-UNDO.

DEFINE VARIABLE EDITOR-Divisiones AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 80 BY 2.15 NO-UNDO.

DEFINE VARIABLE txtAlm AS CHARACTER FORMAT "X(5)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txtFchPed-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "EMITIDOS DESDE" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE txtFchPed-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "HASTA" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE wclient AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE wcotiza AS CHARACTER FORMAT "x(15)":U 
     LABEL "Orden #" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 171 BY 7.27.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 7.27.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-FacCPedi, 
      FacCPedi, 
      gn-clie
    FIELDS(), 
      gn-ConVt
    FIELDS(), 
      gn-ven
    FIELDS(gn-ven.NomVen) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      t-FacCPedi.CodDiv FORMAT "x(5)":U
      FacCPedi.CodDoc FORMAT "x(5)":U
      FacCPedi.NroPed COLUMN-LABEL "Despacho" FORMAT "x(15)":U
      FacCPedi.NroRef COLUMN-LABEL "Pedido" FORMAT "x(15)":U
      FacCPedi.CodCli FORMAT "x(15)":U
      FacCPedi.NomCli FORMAT "x(80)":U WIDTH 39.57
      FacCPedi.ordcmp FORMAT "X(12)":U WIDTH 11.14
      FacCPedi.CodVen COLUMN-LABEL "Vend." FORMAT "XXXX":U
      gn-ven.NomVen FORMAT "X(40)":U WIDTH 28.43
      FacCPedi.FchPed COLUMN-LABEL "    Fecha    !   Emisión" FORMAT "99/99/9999":U
      FacCPedi.CodAlm FORMAT "x(3)":U
      FacCPedi.FchEnt FORMAT "99/99/9999":U
      X-VTA @ X-VTA COLUMN-LABEL "Tip. !Vta." FORMAT "XXXX":U
      FacCPedi.ImpTot FORMAT "->>,>>>,>>9.99":U
      X-MON @ X-MON COLUMN-LABEL "Mon." FORMAT "x(4)":U
      t-FacCPedi.FlgEst FORMAT "X(15)":U
      fItems() @ x-Items COLUMN-LABEL "#!Items" FORMAT ">>>9":U
            WIDTH 5.14
      FacCPedi.Peso COLUMN-LABEL "Peso!kg" FORMAT "->>,>>9.9999":U
            WIDTH 9.43
      FacCPedi.Volumen COLUMN-LABEL "Volumen!m3" FORMAT "->>,>>9.9999":U
      t-FacCPedi.Cliente_Recoge FORMAT "SI/NO":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 191 BY 15.42
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR-Divisiones AT ROW 1.27 COL 20 HELP
          "Ingrese las divisiones sepradas por comas (,)" NO-LABEL WIDGET-ID 14
     BUTTON-19 AT ROW 1.27 COL 100 WIDGET-ID 18
     BUTTON-Filtrar AT ROW 1.27 COL 106 WIDGET-ID 20
     btnExcel AT ROW 3.42 COL 177 WIDGET-ID 4
     COMBO-BOX_CodDoc AT ROW 3.69 COL 18 COLON-ALIGNED WIDGET-ID 30
     txtFchPed-1 AT ROW 4.77 COL 18 COLON-ALIGNED WIDGET-ID 24
     txtFchPed-2 AT ROW 4.77 COL 37 COLON-ALIGNED WIDGET-ID 26
     COMBO-BOX-3 AT ROW 5.85 COL 20.29 NO-LABEL
     wclient AT ROW 5.85 COL 38 COLON-ALIGNED
     wcotiza AT ROW 5.85 COL 38 COLON-ALIGNED
     COMBO-BOX-5 AT ROW 5.85 COL 79 COLON-ALIGNED
     txtAlm AT ROW 6.92 COL 18 COLON-ALIGNED WIDGET-ID 12
     br_table AT ROW 8.27 COL 1
     "Divisiones" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 1.27 COL 5 WIDGET-ID 16
          FONT 6
     "Buscar x" VIEW-AS TEXT
          SIZE 7.86 BY .5 AT ROW 6.08 COL 12
          FONT 6
     "(*) Doble Click - Visualiza Detalle" VIEW-AS TEXT
          SIZE 27 BY .5 AT ROW 23.96 COL 3.14 WIDGET-ID 2
          FONT 6
     RECT-23 AT ROW 1 COL 1 WIDGET-ID 22
     RECT-24 AT ROW 1 COL 172 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: t-FacCPedi T "?" NO-UNDO INTEGRAL FacCPedi
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 24.27
         WIDTH              = 192.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table txtAlm F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-3 IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR EDITOR EDITOR-Divisiones IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.t-FacCPedi,INTEGRAL.FacCPedi WHERE Temp-Tables.t-FacCPedi ...,INTEGRAL.gn-clie WHERE Temp-Tables.t-FacCPedi ...,INTEGRAL.gn-ConVt WHERE Temp-Tables.t-FacCPedi ...,INTEGRAL.gn-ven OF Temp-Tables.t-FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE"
     _TblOptList       = ", FIRST, FIRST OUTER USED, FIRST OUTER USED, FIRST OUTER USED"
     _OrdList          = "Temp-Tables.t-FacCPedi.CodDoc|yes,Temp-Tables.t-FacCPedi.NroPed|yes"
     _JoinCode[2]      = "INTEGRAL.FacCPedi.CodCia = Temp-Tables.t-FacCPedi.CodCia
  AND INTEGRAL.FacCPedi.CodDoc = Temp-Tables.t-FacCPedi.CodDoc
  AND INTEGRAL.FacCPedi.NroPed = Temp-Tables.t-FacCPedi.NroPed"
     _JoinCode[3]      = "INTEGRAL.gn-clie.CodCli = Temp-Tables.t-FacCPedi.CodCli"
     _Where[3]         = "INTEGRAL.gn-clie.CodCia = cl-codcia"
     _JoinCode[4]      = "INTEGRAL.gn-ConVt.Codig = Temp-Tables.t-FacCPedi.FmaPgo"
     _FldNameList[1]   = Temp-Tables.t-FacCPedi.CodDiv
     _FldNameList[2]   > INTEGRAL.FacCPedi.CodDoc
"FacCPedi.CodDoc" ? "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.FacCPedi.NroPed
"FacCPedi.NroPed" "Despacho" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.FacCPedi.NroRef
"FacCPedi.NroRef" "Pedido" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" ? "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.FacCPedi.NomCli
"FacCPedi.NomCli" ? "x(80)" "character" ? ? ? ? ? ? no ? no no "39.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.ordcmp
"FacCPedi.ordcmp" ? ? "character" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > integral.FacCPedi.CodVen
"FacCPedi.CodVen" "Vend." "XXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.gn-ven.NomVen
"gn-ven.NomVen" ? ? "character" ? ? ? ? ? ? no ? no no "28.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > integral.FacCPedi.FchPed
"FacCPedi.FchPed" "    Fecha    !   Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = INTEGRAL.FacCPedi.CodAlm
     _FldNameList[12]   = INTEGRAL.FacCPedi.FchEnt
     _FldNameList[13]   > "_<CALC>"
"X-VTA @ X-VTA" "Tip. !Vta." "XXXX" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   = integral.FacCPedi.ImpTot
     _FldNameList[15]   > "_<CALC>"
"X-MON @ X-MON" "Mon." "x(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.t-FacCPedi.FlgEst
"t-FacCPedi.FlgEst" ? "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"fItems() @ x-Items" "#!Items" ">>>9" ? ? ? ? ? ? ? no ? no no "5.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > INTEGRAL.FacCPedi.Peso
"FacCPedi.Peso" "Peso!kg" ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > INTEGRAL.FacCPedi.Volumen
"FacCPedi.Volumen" "Volumen!m3" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.t-FacCPedi.Cliente_Recoge
"t-FacCPedi.Cliente_Recoge" ? "SI/NO" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
/*  RUN vta\d-peddet.r(Faccpedi.nroped,gn-clie.nomcli).
    RUN vta\d-peddet.r(Faccpedi.nroped,Faccpedi.nomcli,"COT").*/
  
    RUN vta\D-ordpen.r(Faccpedi.nroped,"O/D").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExcel B-table-Win
ON CHOOSE OF btnExcel IN FRAME F-Main /* TEXTO */
DO:
  SESSION:SET-WAIT-STATE('GENERAL').
  /*RUN ToExcel.*/
  RUN ToTexto.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-19
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-19 B-table-Win
ON CHOOSE OF BUTTON-19 IN FRAME F-Main /* Button 19 */
DO:
  DEF VAR pDivisiones AS CHAR NO-UNDO.

  RUN gn/d-selecciona-divisiones.w (OUTPUT pDivisiones).
  IF pDivisiones > '' THEN EDITOR-Divisiones:SCREEN-VALUE = pDivisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar B-table-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* APLICAR FILTROS */
DO:
  ASSIGN {&DISPLAYED-OBJECTS}.
  IF TRUE <> (EDITOR-Divisiones > '') THEN DO:
      MESSAGE 'Debe seleccionar al menos una división' VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO EDITOR-Divisiones.
      RETURN NO-APPLY.
  END.
  IF COMBO-BOX-3 = "Despacho" THEN wclient = "".
  ELSE wcotiza = "".
  RUN Carga-Temporal.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-3 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-3 IN FRAME F-Main
DO:
  wcotiza:visible = yes.
  wclient:visible = yes.
  ASSIGN COMBO-BOX-3.
  CASE COMBO-BOX-3:
       WHEN "Cliente" THEN
            wcotiza:visible = not wcotiza:visible.
       WHEN "Despacho" THEN
            wclient:visible = not wclient:visible.
  end case.         
  ASSIGN COMBO-BOX-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-5 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-5 IN FRAME F-Main /* Condición */
DO:
  ASSIGN COMBO-BOX-5.
  CASE COMBO-BOX-5:
      WHEN "Pendiente" THEN ASSIGN F-ESTADO = "P".
      WHEN "Facturado" THEN ASSIGN F-ESTADO = "C".          
      WHEN "Atendido"  THEN ASSIGN F-ESTADO = "P".          
      WHEN "Anulado" THEN ASSIGN F-ESTADO = "A".
      OTHERWISE ASSIGN F-ESTADO = "P,C,A".
  END.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
ON FIND OF FACCPEDI  
DO:
    IF FacCPedi.CodMon = 1 THEN
        ASSIGN
            X-MON = "S/." .
    ELSE
        ASSIGN
            X-MON = "US$" .
            
/*  IF Faccpedi.tipvta = "1" THEN
        ASSIGN
            X-VTA = "Factura".
    ELSE
        ASSIGN
            X-VTA = "Letra".   */

    IF Faccpedi.FmaPgo = "000" THEN
        ASSIGN
            X-VTA = "CT".
    ELSE
        ASSIGN
            X-VTA = "CR".  
                         
    IF FacCPedi.FlgEst = "P" THEN
        ASSIGN
            X-STA = "PEN".
    ELSE
        IF FacCpedi.FlgEst = "C" THEN
           ASSIGN 
              X-STA = "ATE".
        ELSE        
           ASSIGN
              X-STA = "ANU".                           

END.


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE abrir-query B-table-Win 
PROCEDURE abrir-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reporte B-table-Win 
PROCEDURE Carga-Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


EMPTY TEMP-TABLE Detalle.

FOR EACH t-Faccpedi NO-LOCK, FIRST Faccpedi OF t-Faccpedi NO-LOCK:
    CREATE Detalle.
    BUFFER-COPY t-Faccpedi TO Detalle.
    FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = t-Faccpedi.coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN Detalle.nomdiv = gn-divi.desdiv.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = t-Faccpedi.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN Detalle.nomcli = gn-clie.nomcli.
    FIND gn-ven WHERE gn-ven.codcia = s-codcia AND gn-ven.codven = t-Faccpedi.codven NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN Detalle.nomven = gn-ven.nomven.
    Detalle.tipvta = X-VTA.
    /*Detalle.estado = X-STA.*/
    Detalle.estado = t-Faccpedi.flgest.
    Detalle.moneda = X-MON.

    IF t-FacCPedi.Cliente_Recoge = YES THEN Detalle.ClienteRecoge = "SI".
    ELSE Detalle.ClienteRecoge = "NO".
/*     IF t-FacCPedi.CodDoc = "O/M" THEN Detalle.ClienteRecoge = "SI".       */

    /* UBIGEO */
    CASE t-Faccpedi.Ubigeo[2]:
        WHEN "@CL" THEN DO:
            FIND Gn-ClieD WHERE Gn-ClieD.CodCia = cl-codcia AND
                Gn-ClieD.CodCli = t-Faccpedi.codcli AND
                Gn-ClieD.Sede = t-Faccpedi.Ubigeo[1]
                NO-LOCK NO-ERROR.
            IF AVAILABLE Gn-ClieD THEN DO:
                FIND TabDistr WHERE TabDistr.CodDepto = Gn-ClieD.CodDept AND
                    TabDistr.CodProvi = Gn-ClieD.CodProv AND
                    TabDistr.CodDistr = Gn-ClieD.CodDist
                    NO-LOCK NO-ERROR.
                IF AVAILABLE TabDistr THEN Detalle.Distrito = TabDistr.NomDistr.
                FIND TabProvi WHERE TabProvi.CodDepto = Gn-ClieD.CodDept AND
                    TabProvi.CodProvi = Gn-ClieD.CodProv
                    NO-LOCK NO-ERROR.
                IF AVAILABLE TabProvi THEN Detalle.Provincia = TabProvi.NomProvi.

                FIND TabDepto WHERE TabDepto.CodDepto = Gn-ClieD.CodDept NO-LOCK NO-ERROR.
                IF AVAILABLE TabDepto THEN Detalle.Departamento = TabDepto.NomDepto.
            END.
        END.
        WHEN "@PV" THEN DO:
            FIND Gn-ProvD WHERE Gn-ProvD.CodCia = pv-codcia AND
                Gn-ProvD.CodPro = t-Faccpedi.Ubigeo[3] AND
                Gn-ProvD.Sede = t-Faccpedi.Ubigeo[1]
                NO-LOCK NO-ERROR.
            IF AVAILABLE Gn-ProvD THEN DO:
                FIND TabDistr WHERE TabDistr.CodDepto = Gn-ProvD.CodDept AND
                    TabDistr.CodProvi = Gn-ProvD.CodProv AND
                    TabDistr.CodDistr = Gn-ProvD.CodDist
                    NO-LOCK NO-ERROR.
                IF AVAILABLE TabDistr THEN Detalle.Distrito = TabDistr.NomDistr.
                FIND TabProvi WHERE TabProvi.CodDepto = Gn-ProvD.CodDept AND
                    TabProvi.CodProvi = Gn-ProvD.CodProv
                    NO-LOCK NO-ERROR.
                IF AVAILABLE TabProvi THEN Detalle.Provincia = TabProvi.NomProvi.

                FIND TabDepto WHERE TabDepto.CodDepto = Gn-ProvD.CodDept NO-LOCK NO-ERROR.
                IF AVAILABLE TabDepto THEN Detalle.Departamento = TabDepto.NomDepto.
            END.
        END.
        WHEN "@ALM" THEN DO:
            FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = t-Faccpedi.Ubigeo[2] NO-LOCK NO-ERROR.
            IF AVAILABLE Almacen THEN DO:
                FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = Almacen.coddiv NO-LOCK NO-ERROR.
                IF AVAILABLE gn-divi THEN DO:
                    FIND TabDistr WHERE TabDistr.CodDepto = gn-divi.campo-char[3] AND
                        TabDistr.CodProvi = gn-divi.campo-char[4] AND
                        TabDistr.CodDistr = gn-divi.campo-char[5]
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE TabDistr THEN Detalle.Distrito = TabDistr.NomDistr.
                    FIND TabProvi WHERE TabProvi.CodDepto = gn-divi.campo-char[3] AND
                        TabProvi.CodProvi = gn-divi.campo-char[4]
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE TabProvi THEN Detalle.Provincia = TabProvi.NomProvi.

                    FIND TabDepto WHERE TabDepto.CodDepto = gn-divi.campo-char[3] NO-LOCK NO-ERROR.
                    IF AVAILABLE TabDepto THEN Detalle.Departamento = TabDepto.NomDepto.
                END.
            END.
        END.
    END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE t-Faccpedi.

DEF VAR cCodDiv AS CHAR NO-UNDO.
DEF VAR cCodDoc AS CHAR NO-UNDO.

DEF VAR k AS INTE NO-UNDO.
DEF VAR j AS INTE NO-UNDO.

CASE COMBO-BOX_CodDoc:
    WHEN "O/D" OR WHEN "O/M" THEN cCodDoc = COMBO-BOX_CodDoc.
    WHEN "AMBOS" THEN cCodDoc = "O/D,O/M".
END CASE.

SESSION:SET-WAIT-STATE('GENERAL').
DO k = 1 TO NUM-ENTRIES(EDITOR-Divisiones):
    cCodDiv = ENTRY(k, EDITOR-Divisiones).
    DO j = 1 TO NUM-ENTRIES(cCodDoc):
        s-CodDoc = ENTRY(j,cCodDoc).
        CASE TRUE:
            WHEN wcotiza > '' THEN DO:
                FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND
                    Faccpedi.coddiv = cCodDiv AND
                    Faccpedi.coddoc = s-coddoc AND
                    Faccpedi.nroped = wcotiza:
                    CREATE t-Faccpedi.
                    BUFFER-COPY Faccpedi TO t-Faccpedi.
                END.
            END.
            WHEN wclient > '' THEN DO:
                FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND
                    Faccpedi.codcli = wclient AND
                    Faccpedi.coddoc = s-coddoc AND
                    Faccpedi.fchped >= txtFchPed-1 AND
                    Faccpedi.fchped <= txtFchPed-2 AND
                    Faccpedi.coddiv = cCodDiv:
                    IF txtAlm > '' AND NOT Faccpedi.codalm = txtAlm THEN NEXT.
                    IF COMBO-BOX-5 <> "Todos" 
                        THEN IF LOOKUP(TRIM(Faccpedi.flgest), F-ESTADO) = 0 THEN NEXT.
                    CREATE t-Faccpedi.
                    BUFFER-COPY Faccpedi TO t-Faccpedi.
                END.
            END.
            WHEN txtAlm > '' THEN DO:
                FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND
                    Faccpedi.codalm = txtAlm AND
                    Faccpedi.coddoc = s-coddoc AND
                    Faccpedi.fchped >= txtFchPed-1 AND
                    Faccpedi.fchped <= txtFchPed-2 AND
                    Faccpedi.coddiv = cCodDiv:
                    IF COMBO-BOX-5 <> "Todos" 
                        THEN IF LOOKUP(TRIM(Faccpedi.flgest), F-ESTADO) = 0 THEN NEXT.
                    CREATE t-Faccpedi.
                    BUFFER-COPY Faccpedi TO t-Faccpedi.
                END.
            END.
            OTHERWISE DO:
                FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND
                    Faccpedi.coddiv = cCodDiv AND
                    Faccpedi.coddoc = s-coddoc AND
                    Faccpedi.fchped >= txtFchPed-1 AND
                    Faccpedi.fchped <= txtFchPed-2:
                    IF COMBO-BOX-5 <> "Todos" 
                        THEN IF LOOKUP(TRIM(Faccpedi.flgest), F-ESTADO) = 0 THEN NEXT.
                    CREATE t-Faccpedi.
                    BUFFER-COPY Faccpedi TO t-Faccpedi.
                END.
            END.
        END CASE.
    END.
END.
/* 24/04/2025 Carla Tenazoa: Cambios en la forma que se considera CONDICION */
/*
  CASE COMBO-BOX-5:
      WHEN "Pendiente" THEN ASSIGN F-ESTADO = "P".
      WHEN "Facturado" THEN ASSIGN F-ESTADO = "C".          
      WHEN "Atendido"  THEN ASSIGN F-ESTADO = "P".          
      WHEN "Anulado" THEN ASSIGN F-ESTADO = "A".
      OTHERWISE ASSIGN F-ESTADO = "P,C,A".
  END.        
*/

DEF VAR RegistroValido AS LOG NO-UNDO.
DEF VAR cNomCli AS CHAR NO-UNDO.
/* Pedido en Picking o Checking */
/* Pedido con H/R */
RLOOP:
FOR EACH t-Faccpedi EXCLUSIVE-LOCK:
    RUN lib/limpiar-texto-contains (INPUT t-Faccpedi.nomcli,
                                     INPUT "",
                                     OUTPUT cNomCli).
    ASSIGN t-Faccpedi.nomcli = cNomCli.

    /* Fijo para O/M */
    IF t-FacCPedi.CodDoc = "O/M" THEN t-FacCPedi.Cliente_Recoge = YES.
    /* *************************************************** */
    /* Los ANULADOS y FACTURADOS no necesitan verificación */
    /* *************************************************** */
    IF t-Faccpedi.flgest = "A" THEN DO:
        t-Faccpedi.flgest = "ANULADO".
        NEXT.
    END.
    IF t-Faccpedi.flgest = "C" THEN DO:
        t-Faccpedi.flgest = "FACTURADO".
        NEXT.
    END.
    /* *************************************************** */

    /* *************************************************** */
    /* Solo queda Flgest = "P" y solo Pendiente o Atendido */
    /* *************************************************** */
    t-Faccpedi.flgest = "PENDIENTE".    /* Por defecto */

    RegistroValido = NO.
    /* Primero si está con H/R */
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia 
        AND Ccbcdocu.codped = t-Faccpedi.codref     /* PED */
        AND Ccbcdocu.nroped = t-Faccpedi.nroref
        AND Ccbcdocu.coddoc = "G/R" 
        AND Ccbcdocu.libre_c01 = t-Faccpedi.coddoc  /* O/D */
        AND Ccbcdocu.libre_c02 = t-Faccpedi.nroped
        AND Ccbcdocu.flgest <> "A":
        FIND FIRST di-rutad WHERE di-rutad.codcia = s-codcia 
            AND di-rutad.coddoc = "H/R"
            AND di-rutad.codref = Ccbcdocu.coddoc
            AND di-rutad.nroref = Ccbcdocu.nrodoc
            AND CAN-FIND(FIRST di-rutac WHERE DI-RutaC.CodCia = di-rutad.codcia
                      AND DI-RutaC.CodDiv = di-rutad.coddiv
                      AND DI-RutaC.CodDoc = di-rutad.coddoc 
                      AND DI-RutaC.NroDoc = di-rutad.nrodoc
                      AND DI-RutaC.flgest BEGINS "C" NO-LOCK)       /* Solo H/R Cerrada */
            NO-LOCK NO-ERROR.
        IF AVAILABLE di-rutad THEN DO:
            RegistroValido = YES.
            t-Faccpedi.flgest = "ATENDIDO".
            LEAVE.  /* Salimos del FOR EACH Ccbcdocu ... */
        END.
    END.
    CASE COMBO-BOX-5:
        WHEN "Atendido" THEN DO:
            /* Si es solo atendido entonces se elimina el que no cumple */
            IF RegistroValido = NO THEN DO:
                DELETE t-Faccpedi.
                NEXT RLOOP.   /* Siguiente registro del FOR EACH Ccbcdocu... */
            END.
        END.
        WHEN "Pendiente" THEN DO:
            /* Si es solo pendiente entonces se elimina el que no cumple */
            IF RegistroValido = YES THEN DO:
                DELETE t-Faccpedi.
                NEXT RLOOP.   /* Siguiente registro del FOR EACH Ccbcdocu... */
            END.
            /* Si el pedido ya pasó por Picking o Checking */
            IF NOT (t-Faccpedi.FlgSit BEGINS 'P' OR t-Faccpedi.FlgSit BEGINS 'C') THEN DO:
                DELETE t-Faccpedi.
                NEXT RLOOP.   /* Siguiente registro del FOR EACH Ccbcdocu... */
            END.
        END.
        WHEN "Todos" THEN .
        OTHERWISE DO:
            /* Solo PENDIENTE o ATENDIDO se chequea */
            IF RegistroValido = NO THEN DO:
                /* Si el pedido ya pasó por Picking o Checking */
                IF NOT (t-Faccpedi.FlgSit BEGINS 'P' OR t-Faccpedi.FlgSit BEGINS 'C') THEN DO:
                    DELETE t-Faccpedi.
                    NEXT RLOOP.   /* Siguiente registro del FOR EACH Ccbcdocu... */
                END.
            END.
        END.
    END CASE.
END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN 
      txtFchPed-1 = ADD-INTERVAL(TODAY, -1, "year")
      txtFchPed-2 = TODAY
      .
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  wclient:visible IN FRAME F-MAIN = not wclient:visible .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "t-FacCPedi"}
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "gn-clie"}
  {src/adm/template/snd-list.i "gn-ConVt"}
  {src/adm/template/snd-list.i "gn-ven"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ToExcel B-table-Win 
PROCEDURE ToExcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iCount                  AS INTEGER init 1.
        DEFINE VARIABLE iIndex                  AS INTEGER.
        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.
        DEFINE VARIABLE x-signo                 AS DECI.

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

        /* set the column names for the Worksheet */

        chWorkSheet:Range("A1:Z1"):Font:Bold = TRUE.
        chWorkSheet:Range("A1"):Value = "Despacho".
        chWorkSheet:Range("B1"):Value = "Pedido".
        chWorkSheet:Range("C1"):Value = "Nombre".
        chWorkSheet:Range("D1"):Value = "Vendedor".
        chWorkSheet:Range("E1"):Value = "F.Emision".
        chWorkSheet:Range("F1"):Value = "Tipo Vta".
        chWorkSheet:Range("G1"):Value = "Importe Total".
        chWorkSheet:Range("H1"):Value = "Moneda".
        chWorkSheet:Range("I1"):Value = "Estado".
        chWorkSheet:Range("J1"):Value = "Dias".
        chWorkSheet:Range("K1"):Value = "Almacen".
        chWorkSheet:Range("L1"):Value = "F.Entrega".
        chWorkSheet:Range("M1"):Value = "Orden Compra".

    /* */
    iColumn = 1.
    GET FIRST {&BROWSE-NAME}.
    DO  WHILE AVAILABLE faccpedi:

             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).

             cRange = "A" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + faccpedi.nroped.
             cRange = "B" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + faccpedi.nroref.
             cRange = "C" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + faccpedi.nomcli.
             cRange = "D" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + faccpedi.codven.
             cRange = "E" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.fchped.
             cRange = "F" + cColumn.
             chWorkSheet:Range(cRange):Value = IF Faccpedi.FmaPgo = "000" THEN 'CT' ELSE 'CR'.
             cRange = "G" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.imptot.
             cRange = "H" + cColumn.
             chWorkSheet:Range(cRange):Value = IF FacCPedi.CodMon = 1 THEN 'S/.' ELSE "US$".
             cRange = "I" + cColumn.
             chWorkSheet:Range(cRange):Value = IF FacCPedi.FlgEst = "P" THEN ' PE' ELSE IF FacCpedi.FlgEst = "C" THEN 'ATE' ELSE 'ANU'.
             cRange = "J" + cColumn.
             chWorkSheet:Range(cRange):Value = TODAY - faccpedi.fchped.
             cRange = "K" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + faccpedi.codalm.
             cRange = "L" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.fchent.
             cRange = "M" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.ordcmp.


        GET NEXT {&BROWSE-NAME}.
    END.

        /* release com-handles */
    chExcelApplication:Visible = TRUE.

        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 

        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ToTexto B-table-Win 
PROCEDURE ToTexto :
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
    RUN Carga-Reporte.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Consistenciar la modificacion de la fila
  Parameters:  Retornar "ADM-ERROR" en caso de bloquear la modificacion
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fItems B-table-Win 
FUNCTION fItems RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Items AS INT NO-UNDO INIT 0.

  FOR EACH facdpedi OF faccpedi NO-LOCK:
      x-Items = x-Items + 1.
  END.
  RETURN x-Items.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Peso AS DEC NO-UNDO.


  FOR EACH Facdpedi OF faccpedi NO-LOCK, 
      FIRST Almmmatg OF Facdpedi NO-LOCK:
  END.

  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

