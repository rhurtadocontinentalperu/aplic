&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

/* Local Variable Definitions ---                                       */

DEF VAR x-Estado AS CHAR FORMAT 'x(10)' NO-UNDO.
DEF VAR x-IngCaja AS CHAR FORMAT 'x(20)' NO-UNDO.
DEF VAR x-Moneda AS CHAR FORMAT 'x(3)' NO-UNDO.

&SCOPED-DEFINE CONDICION CcbCDocu.codcia = s-codcia AND ~
CcbCDocu.coddoc = 'BD' AND CcbCDocu.flgest BEGINS CMB-Estado ~
AND (Cmb-Division = 'Todas' OR CcbCDocu.coddiv = Cmb-Division) ~
AND CcbCDocu.FchAte >= x-fchdoc-1 AND CcbCDocu.FchAte <= x-fchdoc-2 ~
AND CcbCDocu.codmon = x-codmon ~
AND CcbCDocu.FlgAte BEGINS FILL-IN-FlgAte

/*AND (FILL-IN-Importe = 0 OR CcbCDocu.imptot = FILL-IN-Importe)*/

&SCOPED-DEFINE FILTRO1 ( CcbCDocu.NomCli BEGINS FILL-IN-filtro )
&SCOPED-DEFINE FILTRO2 ( INDEX ( CcbCDocu.NomCli , FILL-IN-filtro ) <> 0 )
&SCOPED-DEFINE FILTRO3 ( CcbCDocu.ImpTot = FILL-IN-Importe )
&SCOPED-DEFINE FILTRO4 ( CcbCDocu.ImpTot > FILL-IN-Importe )
&SCOPED-DEFINE FILTRO5 ( CcbCDocu.ImpTot < FILL-IN-Importe )

DEF FRAME F-Mensaje
    "Procesando Informacion, un momento por favor..."
    WITH CENTERED OVERLAY NO-LABELS VIEW-AS DIALOG-BOX.

DEF TEMP-TABLE T-BDEPO LIKE CcbCDocu
    FIELD Estado LIKE x-Estado
    FIELD IngCaja LIKE x-IngCaja
    FIELD Moneda LIKE x-Moneda.
    
DEFINE FRAME F-REPORTE
     CcbcDocu.nrodoc COLUMN-LABEL "Numero"
     CcbcDocu.nroref COLUMN-LABEL "Deposito"
     CcbcDocu.nomcli COLUMN-LABEL "Cliente" FORMAT "X(44)"
     CcbcDocu.coddiv COLUMN-LABEL "Division"
     CcbcDocu.fchdoc COLUMN-LABEL "Emision" FORMAT "99/99/99"
     /*T-BDEPO.estado COLUMN-LABEL "Estado"
 *      T-BDEPO.FlgAte COLUMN-LABEL "Banco"   FORMAT "x(5)"
 *      T-BDEPO.moneda COLUMN-LABEL "Moneda" FORMAT "x(3)"
 *      T-BDEPO.imptot COLUMN-LABEL "Importe" FORMAT "->>>,>>9.99"
 *      T-BDEPO.sdoact COLUMN-LABEL "Saldo"   FORMAT "->>>,>>9.99"
 *      T-BDEPO.ingcaja COLUMN-LABEL "Ingreso a Caja"
 *      T-BDEPO.FchAte COLUMN-LABEL "Deposito" FORMAT "99/99/99"*/
     WITH WIDTH 200 NO-BOX STREAM-IO DOWN.

    DEFINE BUFFER b-CDocu FOR CcbCDocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCDocu.NroDoc CcbCDocu.usuario ~
CcbCDocu.FlgUbi CcbCDocu.FchUbi fEstado(CcbCDocu.FlgEst) @ x-Estado ~
CcbCDocu.NroRef CcbCDocu.NomCli CcbCDocu.CodDiv CcbCDocu.FchDoc ~
CcbCDocu.FchAte CcbCDocu.FlgAte CcbCDocu.ImpTot ~
fMoneda(CcbCDocu.CodMon) @ x-Moneda CcbCDocu.SdoAct ~
IF CcbCDocu.imptot <> CcbCDocu.sdoact THEN fINgCaja(CcbCDocu.NroDoc, CcbCDocu.CodDiv) ELSE '' @ x-IngCaja 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-40 RECT-39 BUTTON-10 CMB-Filtro ~
FILL-IN-Filtro FILL-IN-NroDoc Cmb-Division x-CodMon x-Texto FILL-IN-FlgAte ~
CMB-Estado FILL-IN-Importe x-FchDoc-1 x-FchDoc-2 br_table 
&Scoped-Define DISPLAYED-OBJECTS CMB-Filtro FILL-IN-Filtro FILL-IN-NroDoc ~
Cmb-Division FILL-IN-Division x-CodMon FILL-IN-FlgAte CMB-Estado ~
FILL-IN-Importe x-FchDoc-1 x-FchDoc-2 x-Totales x-Saldos 

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
Nombres que inicien con|y||INTEGRAL.CcbCDocu.NomCli
Nombres que contengan|y||INTEGRAL.CcbCDocu.NomCli
Importes iguales a|y||INTEGRAL.CcbCDocu.ImpTot
Importes mayores a|y||INTEGRAL.CcbCDocu.ImpTot
Importes menores a|y||INTEGRAL.CcbCDocu.ImpTot
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "Nombres que inicien con,Nombres que contengan,Importes iguales a,Importes mayores a,Importes menores a",
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT cEstado AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fIngCaja B-table-Win 
FUNCTION fIngCaja RETURNS CHARACTER
  ( INPUT cNroDoc AS CHAR, INPUT cCodDiv AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMoneda B-table-Win 
FUNCTION fMoneda RETURNS CHARACTER
  ( INPUT Parm1 AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-10 
     IMAGE-UP FILE "img\print1":U
     LABEL "Button 10" 
     SIZE 6 BY 1.54.

DEFINE BUTTON x-Texto 
     LABEL "Texto" 
     SIZE 8 BY 1.35.

DEFINE VARIABLE Cmb-Division AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE CMB-Filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtrar por" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FlgAte AS CHARACTER FORMAT "X(3)":U 
     LABEL "Banco" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "x(9)":U 
     LABEL "Buscar Numero" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Depositadas desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-Saldos AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "T. Saldo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE x-Totales AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE CMB-Estado AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Emitida", "E",
"Pendiente", "P",
"Cancelada", "C",
"Anulada", "A",
"Cerrada", "X",
"Todos", ""
     SIZE 64 BY .77 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 12 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 4.62.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46 BY 4.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCDocu.NroDoc COLUMN-LABEL "<<Numero>>" FORMAT "X(9)":U
      CcbCDocu.usuario COLUMN-LABEL "Solicitante" FORMAT "x(10)":U
      CcbCDocu.FlgUbi COLUMN-LABEL "Autorizó" FORMAT "x(10)":U
      CcbCDocu.FchUbi COLUMN-LABEL "Fecha!Autorizacion" FORMAT "99/99/99":U
      fEstado(CcbCDocu.FlgEst) @ x-Estado COLUMN-LABEL "<<Estado>>"
      CcbCDocu.NroRef COLUMN-LABEL "<Deposito>" FORMAT "X(9)":U
      CcbCDocu.NomCli COLUMN-LABEL "Cliente" FORMAT "x(40)":U
      CcbCDocu.CodDiv COLUMN-LABEL "Division" FORMAT "XXXXX":U
      CcbCDocu.FchDoc COLUMN-LABEL "<Emision>" FORMAT "99/99/99":U
      CcbCDocu.FchAte COLUMN-LABEL "<Deposito>" FORMAT "99/99/99":U
      CcbCDocu.FlgAte COLUMN-LABEL "Banco" FORMAT "x(5)":U
      CcbCDocu.ImpTot COLUMN-LABEL "<<<Importe>>>" FORMAT "->>>,>>9.99":U
      fMoneda(CcbCDocu.CodMon) @ x-Moneda COLUMN-LABEL "Mon"
      CcbCDocu.SdoAct COLUMN-LABEL "<<<Saldo>>>" FORMAT "->>>,>>9.99":U
      IF CcbCDocu.imptot <> CcbCDocu.sdoact THEN fINgCaja(CcbCDocu.NroDoc, CcbCDocu.CodDiv) ELSE '' @ x-IngCaja COLUMN-LABEL "<<<Ingreso a Caja>>>"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 120 BY 15
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-10 AT ROW 1.19 COL 113
     CMB-Filtro AT ROW 1.38 COL 7 COLON-ALIGNED
     FILL-IN-Filtro AT ROW 1.38 COL 29 COLON-ALIGNED NO-LABEL
     FILL-IN-NroDoc AT ROW 1.38 COL 86 COLON-ALIGNED
     Cmb-Division AT ROW 2.35 COL 7 COLON-ALIGNED
     FILL-IN-Division AT ROW 2.35 COL 29 COLON-ALIGNED NO-LABEL
     x-CodMon AT ROW 2.35 COL 88 NO-LABEL
     x-Texto AT ROW 2.92 COL 111
     FILL-IN-FlgAte AT ROW 3.31 COL 86 COLON-ALIGNED
     CMB-Estado AT ROW 3.5 COL 9 NO-LABEL
     FILL-IN-Importe AT ROW 4.46 COL 7 COLON-ALIGNED
     x-FchDoc-1 AT ROW 4.46 COL 33 COLON-ALIGNED
     x-FchDoc-2 AT ROW 4.46 COL 52 COLON-ALIGNED
     x-Totales AT ROW 4.46 COL 86 COLON-ALIGNED
     x-Saldos AT ROW 4.46 COL 105 COLON-ALIGNED
     br_table AT ROW 5.81 COL 1
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 2.54 COL 81
     "Estado:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 3.5 COL 3
     RECT-40 AT ROW 1 COL 75
     RECT-39 AT ROW 1 COL 1
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
         HEIGHT             = 20
         WIDTH              = 121.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table x-Saldos F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3.

/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Saldos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Totales IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.CcbCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" "<<Numero>>" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbCDocu.usuario
"CcbCDocu.usuario" "Solicitante" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCDocu.FlgUbi
"CcbCDocu.FlgUbi" "Autorizó" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCDocu.FchUbi
"CcbCDocu.FchUbi" "Fecha!Autorizacion" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fEstado(CcbCDocu.FlgEst) @ x-Estado" "<<Estado>>" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCDocu.NroRef
"CcbCDocu.NroRef" "<Deposito>" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" "Cliente" "x(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbCDocu.CodDiv
"CcbCDocu.CodDiv" "Division" "XXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" "<Emision>" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.CcbCDocu.FchAte
"CcbCDocu.FchAte" "<Deposito>" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.CcbCDocu.FlgAte
"CcbCDocu.FlgAte" "Banco" "x(5)" "character" ? ? ? ? ? ? no "Código de banco" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" "<<<Importe>>>" "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fMoneda(CcbCDocu.CodMon) @ x-Moneda" "Mon" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.CcbCDocu.SdoAct
"CcbCDocu.SdoAct" "<<<Saldo>>>" "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"IF CcbCDocu.imptot <> CcbCDocu.sdoact THEN fINgCaja(CcbCDocu.NroDoc, CcbCDocu.CodDiv) ELSE '' @ x-IngCaja" "<<<Ingreso a Caja>>>" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 B-table-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* Button 10 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('imprime':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Cmb-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Cmb-Division B-table-Win
ON VALUE-CHANGED OF Cmb-Division IN FRAME F-Main /* Division */
DO:
  IF CMB-Estado = SELF:SCREEN-VALUE THEN RETURN.
  FILL-IN-Division:SCREEN-VALUE = ''.
  FIND Gn-Divi WHERE Gn-Divi.codcia = s-codcia
    AND Gn-Divi.coddiv = SELF:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-Divi THEN FILL-IN-Division:SCREEN-VALUE = GN-DIVI.DesDiv.
  APPLY "VALUE-CHANGED" TO CMB-Filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-Estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-Estado B-table-Win
ON VALUE-CHANGED OF CMB-Estado IN FRAME F-Main
DO:
  IF CMB-Estado = SELF:SCREEN-VALUE THEN RETURN.
  APPLY "VALUE-CHANGED" TO CMB-Filtro.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-Filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-Filtro B-table-Win
ON VALUE-CHANGED OF CMB-Filtro IN FRAME F-Main /* Filtrar por */
DO:

    ASSIGN
        FILL-IN-filtro
        CMB-filtro
        CMB-Estado
        CMB-Division
        FILL-IN-Importe
        x-FchDoc-1
        x-FchDoc-2
        x-Codmon
        FILL-IN-FlgAte.
    IF CMB-filtro = "Todos" THEN RUN set-attribute-list('Key-Name=?').
    ELSE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    VIEW FRAME F-Mensaje.
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    HIDE FRAME F-Mensaje.
    RUN Carga-Temporal.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Filtro B-table-Win
ON LEAVE OF FILL-IN-Filtro IN FRAME F-Main
DO:
  APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FlgAte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FlgAte B-table-Win
ON LEAVE OF FILL-IN-FlgAte IN FRAME F-Main /* Banco */
DO:
    IF FILL-IN-FlgAte = INPUT {&SELF-NAME} THEN RETURN.
    APPLY "VALUE-CHANGED" TO CMB-Filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FlgAte B-table-Win
ON MOUSE-SELECT-DBLCLICK OF FILL-IN-FlgAte IN FRAME F-Main /* Banco */
DO:
    DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
    ASSIGN
        input-var-1 = "04"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-Tablas.r("").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND cb-tabl WHERE ROWID(cb-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY 
                cb-tabl.Codigo @ FILL-IN-FlgAte 
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Importe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Importe B-table-Win
ON LEAVE OF FILL-IN-Importe IN FRAME F-Main /* Importe */
DO:
  IF FILL-IN-Importe  = INPUT {&SELF-NAME} THEN RETURN.
  APPLY "VALUE-CHANGED" TO CMB-Filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroDoc B-table-Win
ON LEAVE OF FILL-IN-NroDoc IN FRAME F-Main /* Buscar Numero */
DO:
  IF INPUT FILL-IN-NroDoc = "" THEN RETURN.
  FIND FIRST CcbCDocu WHERE {&CONDICION} 
    AND CcbCDocu.nrodoc = INPUT FILL-IN-NroDoc
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbCDocu
  THEN DO:
    MESSAGE 'No se encontró las Boleta de Deposito'
        VIEW-AS ALERT-BOX WARNING.
    SELF:SCREEN-VALUE = ''.
    RETURN NO-APPLY.
  END.    
  VIEW FRAME F-Mensaje.
  REPOSITION {&BROWSE-NAME} TO ROWID ROWID(CcbCDocu)
    NO-ERROR.
  HIDE FRAME F-Mensaje.
  SELF:SCREEN-VALUE = ''.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodMon B-table-Win
ON VALUE-CHANGED OF x-CodMon IN FRAME F-Main
DO:
  IF x-CodMon = INPUT {&SELF-NAME} THEN RETURN.
  APPLY "VALUE-CHANGED" TO CMB-Filtro.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchDoc-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchDoc-1 B-table-Win
ON LEAVE OF x-FchDoc-1 IN FRAME F-Main /* Depositadas desde */
DO:
  
  IF x-FchDoc-1  = INPUT {&SELF-NAME} THEN RETURN.
  APPLY "VALUE-CHANGED" TO CMB-Filtro.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchDoc-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchDoc-2 B-table-Win
ON LEAVE OF x-FchDoc-2 IN FRAME F-Main /* Hasta */
DO:
  IF x-FchDoc-2  = INPUT {&SELF-NAME} THEN RETURN.
  APPLY "VALUE-CHANGED" TO CMB-Filtro.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Texto B-table-Win
ON CHOOSE OF x-Texto IN FRAME F-Main /* Texto */
DO:
  RUN proc_texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.

  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'Nombres que inicien con':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro1} )
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Nombres que inicien con */
    WHEN 'Nombres que contengan':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro2} )
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Nombres que contengan */
    WHEN 'Importes iguales a':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro3} )
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Importes iguales a */
    WHEN 'Importes mayores a':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro4} )
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Importes mayores a */
    WHEN 'Importes menores a':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro5} )
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Importes menores a */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    MESSAGE 'borrando temporal'.
    FOR EACH T-BDEPO:
        DELETE T-BDEPO.
    END.
    MESSAGE 'cargando temporal'.
    FOR EACH b-CDocu WHERE {&KEY-PHRASE} AND {&CONDICION} NO-LOCK:
        CREATE T-BDEPO.
        BUFFER-COPY b-CDocu TO T-BDEPO.
        ASSIGN
            T-BDEPO.Estado = fEstado(b-CDocu.flgest)   
            T-BDEPO.Moneda = fMOneda(b-CDocu.codmon).
        IF b-CDocu.imptot <> b-CDocu.sdoact 
        THEN T-BDEPO.IngCaja = fINgCaja(b-CDocu.NroDoc, b-CDocu.CodDiv).
    END.

    HIDE FRAME f-Mensaje.
    MESSAGE 'acumulando saldos'.
    x-Totales = 0.
    x-Saldos = 0.
    FOR EACH T-BDEPO NO-LOCK:
        x-Totales = x-Totales + T-BDEPO.imptot.
        x-Saldos = x-Saldos + T-BDEPO.sdoact.
    END.
    DISPLAY
        x-Totales
        x-Saldos
        WITH FRAME {&FRAME-NAME}.
   
END PROCEDURE.

/*
    FOR EACH T-BDEPO:
        DELETE T-BDEPO.
    END.

    FOR EACH b-CDocu WHERE {&KEY-PHRASE} AND
        b-CDocu.codcia = s-codcia AND
        b-CDocu.coddoc = 'BD' AND
        b-CDocu.flgest BEGINS CMB-Estado AND
        (Cmb-Division = 'Todas' OR b-CDocu.coddiv = Cmb-Division) AND
        b-CDocu.FchAte >= x-fchdoc-1 AND b-CDocu.FchAte <= x-fchdoc-2 AND
        b-CDocu.codmon = x-codmon AND
        b-CDocu.FlgAte BEGINS FILL-IN-FlgAte NO-LOCK:
        CREATE T-BDEPO.
        BUFFER-COPY b-CDocu TO T-BDEPO.
        ASSIGN
            T-BDEPO.Estado = fEstado(b-CDocu.flgest)   
            T-BDEPO.Moneda = fMOneda(b-CDocu.codmon).
        IF b-CDocu.imptot <> b-CDocu.sdoact 
        THEN T-BDEPO.IngCaja = fINgCaja(b-CDocu.NroDoc, b-CDocu.CodDiv).
    END.

    HIDE FRAME f-Mensaje.

    x-Totales = 0.
    x-Saldos = 0.
    FOR EACH T-BDEPO BREAK BY T-BDEPO.codcia:
        ACCUMULATE T-BDEPO.imptot (TOTAL).
        ACCUMULATE T-BDEPO.SdoAct (TOTAL).
    END.
    DISPLAY
        ACCUM TOTAL T-BDEPO.imptot @ x-Totales
        ACCUM TOTAL T-BDEPO.SdoAct @ x-Saldos
        WITH FRAME {&FRAME-NAME}.
*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato B-table-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-NomCli LIKE gn-clie.nomcli.
  DEF VAR x-Saldo  AS DEC.
  DEF VAR x-Quiebre AS LOG.
  
  DEFINE FRAME F-DETALLE
    T-BDEPO.nrodoc COLUMN-LABEL "Numero"
    T-BDEPO.nroref COLUMN-LABEL "Deposito"
    T-BDEPO.nomcli COLUMN-LABEL "Cliente" FORMAT "X(44)"
    T-BDEPO.coddiv COLUMN-LABEL "Division"
    T-BDEPO.fchdoc COLUMN-LABEL "Emision" FORMAT "99/99/99"
    T-BDEPO.estado COLUMN-LABEL "Estado"
    T-BDEPO.FlgAte COLUMN-LABEL "Banco"   FORMAT "x(5)"
    T-BDEPO.moneda COLUMN-LABEL "Moneda" FORMAT "x(3)"
    T-BDEPO.imptot COLUMN-LABEL "Importe" FORMAT "->>>,>>9.99"
    T-BDEPO.sdoact COLUMN-LABEL "Saldo"   FORMAT "->>>,>>9.99"
    T-BDEPO.ingcaja COLUMN-LABEL "Ingreso a Caja"
    T-BDEPO.FchAte COLUMN-LABEL "Deposito" FORMAT "99/99/99"
    WITH WIDTH 200 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    S-NOMCIA FORMAT "X(45)"
    "REPORTE DE BOLETAS DE DEPOSITO" AT 70
    "Pag.  : " TO 150 PAGE-NUMBER(REPORT) TO 160 FORMAT ">>>9" SKIP
    "Fecha : " TO 150 TODAY TO 160 SKIP
    "Moneda: " (IF x-CodMon = 1 THEN 'Expresado en Nuevos Soles' ELSE 'Expresado en Dólares Americanos') FORMAT 'x(35)' SKIP
    WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  FOR EACH T-BDEPO BREAK BY T-BDEPO.codcia BY T-BDEPO.codcli:
    VIEW STREAM REPORT FRAME F-HEADER.
    DISPLAY STREAM REPORT
        T-BDEPO.nrodoc 
        T-BDEPO.nroref 
        T-BDEPO.nomcli 
        T-BDEPO.coddiv 
        T-BDEPO.fchdoc 
        T-BDEPO.estado
        T-BDEPO.FlgAte
        T-BDEPO.moneda
        T-BDEPO.imptot 
        T-BDEPO.sdoact 
        T-BDEPO.ingcaja
        T-BDEPO.FchAte
        WITH FRAME F-DETALLE.
    ACCUMULATE T-BDEPO.imptot (SUB-TOTAL BY T-BDEPO.codcli).
    ACCUMULATE T-BDEPO.imptot (TOTAL).
    ACCUMULATE T-BDEPO.sdoact (SUB-TOTAL BY T-BDEPO.codcli).
    ACCUMULATE T-BDEPO.sdoact (TOTAL).
/*MLR* 11/07/2008 ***
    IF LAST-OF(T-BDEPO.codcli) THEN DO:
        UNDERLINE STREAM REPORT
            T-BDEPO.imptot
            T-BDEPO.sdoact
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            'TOTAL POR CLIENTE' @ T-BDEPO.nomcli
            ACCUM SUB-TOTAL BY T-BDEPO.codcli T-BDEPO.imptot @ T-BDEPO.imptot
            ACCUM SUB-TOTAL BY T-BDEPO.codcli T-BDEPO.sdoact @ T-BDEPO.sdoact
            WITH FRAME F-DETALLE.
        DOWN STREAM REPORT 2 WITH FRAME F-DETALLE.
    END.
*** */
    IF LAST-OF(T-BDEPO.codcia) THEN DO:
        UNDERLINE STREAM REPORT
            T-BDEPO.imptot
            T-BDEPO.sdoact
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            'TOTAL GENERAL' @ T-BDEPO.nomcli
            ACCUM TOTAL T-BDEPO.imptot @ T-BDEPO.imptot
            ACCUM TOTAL T-BDEPO.sdoact @ T-BDEPO.sdoact
            WITH FRAME F-DETALLE.
    END.
  END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-RepTex B-table-Win 
PROCEDURE Formato-RepTex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-NomCli LIKE gn-clie.nomcli.
  DEF VAR x-Saldo  AS DEC.
  DEF VAR x-Quiebre AS LOG.
  
  DEFINE FRAME F-DETALLE
    T-BDEPO.nrodoc COLUMN-LABEL "Numero"
    T-BDEPO.nroref COLUMN-LABEL "Deposito"
    T-BDEPO.nomcli COLUMN-LABEL "Cliente" FORMAT "X(44)"
    T-BDEPO.coddiv COLUMN-LABEL "Division"
    T-BDEPO.fchdoc COLUMN-LABEL "Emision" FORMAT "99/99/99"
    T-BDEPO.estado COLUMN-LABEL "Estado"
    T-BDEPO.FlgAte COLUMN-LABEL "Banco"   FORMAT "x(5)"
    T-BDEPO.moneda COLUMN-LABEL "Moneda" FORMAT "x(3)"
    T-BDEPO.imptot COLUMN-LABEL "Importe" FORMAT "->>>,>>9.99"
    T-BDEPO.sdoact COLUMN-LABEL "Saldo"   FORMAT "->>>,>>9.99"
    T-BDEPO.ingcaja COLUMN-LABEL "Ingreso a Caja"
    T-BDEPO.FchAte COLUMN-LABEL "Deposito" FORMAT "99/99/99"
    HEADER
    "REPORTE DE BOLETAS DE DEPOSITO" AT 70
    "Fecha : " TO 150 TODAY TO 160 SKIP(2)
    WITH STREAM-IO NO-BOX DOWN WIDTH 200 . 

  FOR EACH T-BDEPO BREAK BY T-BDEPO.codcia BY T-BDEPO.codcli:
    DISPLAY STREAM REPORT
        T-BDEPO.nrodoc 
        T-BDEPO.nroref 
        T-BDEPO.nomcli 
        T-BDEPO.coddiv 
        T-BDEPO.fchdoc 
        T-BDEPO.estado
        T-BDEPO.FlgAte
        T-BDEPO.moneda
        T-BDEPO.imptot 
        T-BDEPO.sdoact 
        T-BDEPO.ingcaja
        T-BDEPO.FchAte
        WITH FRAME F-DETALLE.
    VIEW FRAME f-Mensaje.
    ACCUMULATE T-BDEPO.imptot (SUB-TOTAL BY T-BDEPO.codcli).
    ACCUMULATE T-BDEPO.imptot (TOTAL).
    ACCUMULATE T-BDEPO.sdoact (SUB-TOTAL BY T-BDEPO.codcli).
    ACCUMULATE T-BDEPO.sdoact (TOTAL).
    
/*MLR* 11/07/2008 ***
    IF LAST-OF(T-BDEPO.codcli) THEN DO:
        UNDERLINE STREAM REPORT
            T-BDEPO.imptot
            T-BDEPO.sdoact
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            'TOTAL POR CLIENTE' @ T-BDEPO.nomcli
            ACCUM SUB-TOTAL BY T-BDEPO.codcli T-BDEPO.imptot @ T-BDEPO.imptot
            ACCUM SUB-TOTAL BY T-BDEPO.codcli T-BDEPO.sdoact @ T-BDEPO.sdoact
            WITH FRAME F-DETALLE.
        DOWN STREAM REPORT 2 WITH FRAME F-DETALLE.
    END.
*** */
    IF LAST-OF(T-BDEPO.codcia) THEN DO:
        UNDERLINE STREAM REPORT
            T-BDEPO.imptot
            T-BDEPO.sdoact
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            'TOTAL GENERAL' @ T-BDEPO.nomcli
            ACCUM TOTAL T-BDEPO.imptot @ T-BDEPO.imptot
            ACCUM TOTAL T-BDEPO.sdoact @ T-BDEPO.sdoact
            WITH FRAME F-DETALLE.
    END.
  END.  


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.   

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT .
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT STREAM REPORT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
    x-FchDoc-1 = TODAY
    x-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    RUN get-attribute ('Keys-Accepted').
    IF RETURN-VALUE <> "" AND RETURN-VALUE <> ? 
    THEN ASSIGN
            CMB-filtro:LIST-ITEMS = CMB-filtro:LIST-ITEMS + "," + RETURN-VALUE
            CMB-FIltro:SCREEN-VALUE = 'Todos'.

    FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.codcia = s-codcia:
        Cmb-Division:ADD-LAST(Gn-Divi.coddiv).
    END.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_texto B-table-Win 
PROCEDURE proc_texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cArchivo AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lRpta    AS LOGICAL NO-UNDO.
  
 cArchivo = 'Boleta de Deposito.txt'.
   SYSTEM-DIALOG GET-FILE cArchivo
     FILTERS 'Texto' '*.txt'
     ASK-OVERWRITE
     CREATE-TEST-FILE
     DEFAULT-EXTENSION '.txt'
     INITIAL-DIR 'M:\'
     RETURN-TO-START-DIR 
     USE-FILENAME
     SAVE-AS
     UPDATE lRpta.
 IF lRpta = NO THEN RETURN.
 
 RUN Carga-Temporal.
 


 OUTPUT STREAM REPORT TO VALUE (cArchivo).
    RUN Formato-RepTex.
    MESSAGE "Proceso Terminado" VIEW-AS ALERT-BOX INFORMATION.
 OUTPUT STREAM REPORT CLOSE.
 
  HIDE FRAME f-Mensaje.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "CcbCDocu"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT cEstado AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE cEstado:
    WHEN "E" THEN RETURN "Emitido".
    WHEN "P" THEN RETURN "Pendiente".
    WHEN "A" THEN RETURN "Anulado".
    WHEN "C" THEN RETURN "Cancelado".
    WHEN "X" THEN RETURN "Cerrado".
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fIngCaja B-table-Win 
FUNCTION fIngCaja RETURNS CHARACTER
  ( INPUT cNroDoc AS CHAR, INPUT cCodDiv AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND LAST CcbCCaja WHERE ccbccaja.codcia = s-codcia
    AND ccbccaja.coddiv = cCodDiv
    AND ccbccaja.coddoc = 'I/C'
    AND ccbccaja.voucher[5] = cNroDoc
    AND ccbccaja.flgest <> 'A' NO-LOCK NO-ERROR.
  IF AVAILABLE ccbccaja 
  THEN RETURN STRING(ccbccaja.nrodoc, 'XXX-XXXXXX') + ' ' + STRING(ccbccaja.fchdoc, '99/99/99').
  /* BUSCAMOS EN OTRA DIVISION */
/*  FIND LAST CcbCCaja WHERE ccbccaja.codcia = s-codcia
 *     AND ccbccaja.coddoc = 'I/C'
 *     AND ccbccaja.voucher[5] = cNroDoc
 *     AND ccbccaja.flgest <> 'A' NO-LOCK NO-ERROR.
 *   IF AVAILABLE ccbccaja 
 *   THEN RETURN STRING(ccbccaja.nrodoc, 'XXX-XXXXXX') + ' ' + STRING(ccbccaja.fchdoc, '99/99/99').*/
  
  /*RETURN "".   Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMoneda B-table-Win 
FUNCTION fMoneda RETURNS CHARACTER
  ( INPUT Parm1 AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE Parm1:
    WHEN 1 THEN RETURN 'S/.'.
    WHEN 2 THEN RETURN 'US$'.
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

