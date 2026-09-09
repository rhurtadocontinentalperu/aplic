&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS L-table-Win 
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

/* Definicion de variables compartidas */
DEFINE NEW SHARED VARIABLE input-var-1 AS CHARACTER.
DEFINE NEW SHARED VARIABLE input-var-2 AS CHARACTER.
DEFINE NEW SHARED VARIABLE input-var-3 AS CHARACTER.
DEFINE NEW SHARED VARIABLE output-var-1 AS ROWID.
DEFINE NEW SHARED VARIABLE output-var-2 AS CHARACTER.
DEFINE NEW SHARED VARIABLE output-var-3 AS CHARACTER.

/* Definición de variables locales */
DEFINE VARIABLE whpadre AS WIDGET-HANDLE.
DEFINE VARIABLE wh      AS WIDGET-HANDLE.
DEFINE VARIABLE curr-record AS RECID.
DEFINE VARIABLE f-cmpbte AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR INIT "".
DEFINE VARIABLE X-EST    AS CHAR INIT "".
DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV AS CHAR.

DEFINE VAR ss-CodDiv LIKE s-CodDiv.     /* ARTIFICIO */
DEFINE VAR F-ESTADO AS CHAR INIT 'P,C,A'.
DEFINE VAR F-CONDI  AS CHAR.
DEFINE VAR x-codven AS CHAR.

/* Solo para letras */
DEF VAR x-Banco AS CHAR NO-UNDO.
DEF VAR x-Ubicacion AS CHAR NO-UNDO.
DEF VAR x-Situacion AS CHAR NO-UNDO.

/* Preprocesadores para condiciones */
/*&SCOPED-DEFINE CONDICION ( CcbcDocu.CodCia = S-CODCIA ~
 *                            AND CcbCDocu.CodDiv = x-CODDIV  ~
 *                            AND (CcbcDocu.FchDoc >= f-desde AND CcbCdocu.FchDoc <= f-hasta ) ~
 *                            AND (CcbcDocu.CodDoc = "BOL" OR CcbcDocu.CodDoc = "FAC") ~
 *                            AND CcbcDocu.CodDoc BEGINS C-CMPBTE ~
 *                            AND CcbcDocu.FlgEst BEGINS F-ESTADO ~
 *                            AND CcbcDocu.NroDoc BEGINS c-Serie  ~
 *                            AND CcbcDocu.FmaPgo BEGINS F-CONDI AND CcbCdocu.CodVen BEGINS x-codven )*/

&SCOPED-DEFINE CONDICION ( CcbcDocu.CodCia = S-CODCIA ~
                           AND CcbCDocu.DivOri = x-CODDIV  ~
                           AND (CcbcDocu.FchDoc >= f-desde AND CcbCdocu.FchDoc <= f-hasta ) ~
                           AND (x-FchVto-1 = ? OR CcbCDocu.FchVto >= x-FchVto-1) ~
                           AND (x-FchVTo-2 = ? OR CcbCDocu.FchVto <= x-FchVto-2) ~
                           AND LOOKUP(TRIM(CcbcDocu.CodDoc), "BOL,FAC,N/C,N/D,CHQ,CHC,LET,TCK") > 0 ~
                           AND CcbcDocu.CodDoc BEGINS C-CMPBTE ~
                           AND LOOKUP(TRIM(CcbcDocu.FlgEst), F-ESTADO) > 0 ~
                           AND CcbcDocu.NroDoc BEGINS c-Serie ~
                           AND CcbCDocu.CodCli BEGINS FILL-IN-CodCli ~
                           AND CcbcDocu.FmaPgo BEGINS F-CONDI AND CcbCdocu.CodVen BEGINS x-codven ) ~
                           AND (x-CndCre = 'T' OR CcbCDocu.CndCre = x-CndCre) ~
                           AND (xcodmod = 3 OR ccbcdocu.codmon = xcodmod)
                                      
                           
&SCOPED-DEFINE CODIGO CcbcDocu.NroDoc
/* Preprocesadores para cada campo filtro */

&SCOPED-DEFINE FILTRO1 ( CcbcDocu.Nomcli BEGINS FILL-IN-filtro )
&SCOPED-DEFINE FILTRO2 ( INDEX ( CcbcDocu.Nomcli , FILL-IN-filtro ) <> 0 )


DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY .88
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 10 BY .88
     BGCOLOR 8 .

DEFINE VARIABLE CMB-condicion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-buscar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Buscar" 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-chr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-date AS DATE FORMAT "99/99/9999":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-dec AS DECIMAL FORMAT "->>>>>9,99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-int AS INTEGER FORMAT "->>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 55.14 BY 1.35.

DEFINE FRAME Dialog-Frame
     FILL-IN-buscar AT ROW 1.23 COL 6.14 COLON-ALIGNED
     CMB-condicion AT ROW 1.19 COL 21 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 2.62 COL 34.29
     FILL-IN-chr AT ROW 1.23 COL 34.43 COLON-ALIGNED NO-LABEL
     FILL-IN-date AT ROW 1.23 COL 34.43 COLON-ALIGNED NO-LABEL
     FILL-IN-int AT ROW 1.23 COL 34.43 COLON-ALIGNED NO-LABEL
     FILL-IN-dec AT ROW 1.23 COL 34.43 COLON-ALIGNED NO-LABEL
     Btn_Cancel AT ROW 2.62 COL 44.86
     RECT-2 AT ROW 1 COL 1
     SPACE(0.00) SKIP(1.41)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         FONT 4 TITLE "Condiciones de Búsqueda"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel CENTERED.

DEFINE VARIABLE X_TOT_IS AS DECI INIT 0.
DEFINE VARIABLE X_TOT_SS AS DECI INIT 0.
DEFINE VARIABLE X_TOT_ID AS DECI INIT 0.
DEFINE VARIABLE X_TOT_SD AS DECI INIT 0.
DEFINE BUFFER B-CDOCU FOR CcbCdocu.

/* RHC 15-03-04 SOLO PARA LA IMPRESION */
DEF TEMP-TABLE t-ccbcdocu LIKE ccbcdocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartLookup
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.NroOrd CcbCDocu.NomCli CcbCDocu.FmaPgo CcbCDocu.CodVen ~
CcbCDocu.FchDoc CcbCDocu.FchVto X-MON @ X-MON CcbCDocu.ImpTot ~
CcbCDocu.SdoAct CcbCDocu.PorDto fEstado() @ X-EST ~
fUbicacion() @ x-Ubicacion fBanco() @ x-Banco fSituacion() @ x-Situacion ~
CcbCDocu.NroSal 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-55 FILL-IN-codigo BUTTON-4 ~
B-Imprimir FILL-IN-CodCli CMB-filtro FILL-IN-filtro C-CMPBTE c-Serie ~
F-FMAPGO COMBO-BOX-5 f-desde f-hasta xcodmod f-codven x-FchVto-1 x-FchVto-2 ~
br_table BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codigo FILL-IN-CodCli CMB-filtro ~
FILL-IN-filtro C-CMPBTE x-CndCre x-CodDiv c-Serie F-FMAPGO F-CndVta ~
COMBO-BOX-5 f-desde f-hasta xcodmod f-codven F-nomven x-FchVto-1 x-FchVto-2 ~
f-totsol f-totdol f-sdosol f-sdodol 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" L-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
Nombres que Inicien con|y||integral.CcbCDocu.NomCli
Nombres que Contengan|y||integral.CcbCDocu.NomCli
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "Nombres que Inicien con,Nombres que Contengan",
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" L-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS></SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ,
     Sort-Case = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES></FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBanco L-table-Win 
FUNCTION fBanco RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado L-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado-1 L-table-Win 
FUNCTION fEstado-1 RETURNS CHARACTER
  ( INPUT pFlgEst AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSituacion L-table-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fUbicacion L-table-Win 
FUNCTION fUbicacion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Imprimir 
     IMAGE-UP FILE "img\print":U
     LABEL "Button 2" 
     SIZE 5 BY 1.19.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\auditor":U
     LABEL "Button 1" 
     SIZE 5.29 BY 1.46.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img\excel":U
     LABEL "Button 4" 
     SIZE 5 BY 1.35 TOOLTIP "Migrar a Excel".

DEFINE VARIABLE C-CMPBTE AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Cmpbte." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","Fac","Bol","N/C","N/D","CHQ","CHC","LET","TCK" 
     DROP-DOWN-LIST
     SIZE 9.43 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 21.29 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-5 AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Estado" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Pendiente","Cancelado","Anulado","Total Neto" 
     DROP-DOWN-LIST
     SIZE 11.57 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE c-Serie AS CHARACTER FORMAT "X(256)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .69 NO-UNDO.

DEFINE VARIABLE f-codven AS CHARACTER FORMAT "X(3)":U 
     LABEL "Vend" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-FMAPGO AS CHARACTER FORMAT "XXX":U 
     LABEL "Cnd.Vta" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .69 NO-UNDO.

DEFINE VARIABLE f-sdodol AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-sdosol AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-totdol AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-totsol AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "Código" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-FchVto-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Vencidos desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-FchVto-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-CndCre AS CHARACTER INITIAL "T" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", "T",
"Por Devolucion", "D",
"Otros", "N"
     SIZE 31 BY .77 NO-UNDO.

DEFINE VARIABLE xcodmod AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2,
"Todos", 3
     SIZE 22 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 141 BY 18.08.

DEFINE RECTANGLE RECT-55
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.86 BY 2.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table L-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCDocu.CodDoc COLUMN-LABEL "Tipo" FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "x(12)":U WIDTH 10.86
      CcbCDocu.NroOrd COLUMN-LABEL "# Pedido!Cliente" FORMAT "x(20)":U
      CcbCDocu.NomCli FORMAT "x(40)":U
      CcbCDocu.FmaPgo COLUMN-LABEL "Cnd.!Venta" FORMAT "XXX":U
      CcbCDocu.CodVen COLUMN-LABEL "Ven." FORMAT "x(5)":U
      CcbCDocu.FchDoc COLUMN-LABEL "     Fecha    !    Emision" FORMAT "99/99/9999":U
      CcbCDocu.FchVto FORMAT "99/99/9999":U
      X-MON @ X-MON COLUMN-LABEL "Mon." FORMAT "XXXX":U
      CcbCDocu.ImpTot FORMAT "->>>,>>9.99":U
      CcbCDocu.SdoAct COLUMN-LABEL "Saldo" FORMAT "->>>,>>9.99":U
      CcbCDocu.PorDto FORMAT ">>9.99":U
      fEstado() @ X-EST COLUMN-LABEL "Estado" FORMAT "XXX":U
      fUbicacion() @ x-Ubicacion COLUMN-LABEL "Ubicación" FORMAT "x(10)":U
      fBanco() @ x-Banco COLUMN-LABEL "Banco" FORMAT "x(15)":U
      fSituacion() @ x-Situacion COLUMN-LABEL "Situación" FORMAT "x(15)":U
      CcbCDocu.NroSal COLUMN-LABEL "Numero Unico" FORMAT "X(15)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 140 BY 9.12
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-codigo AT ROW 1.19 COL 17 COLON-ALIGNED
     BUTTON-4 AT ROW 1.19 COL 96
     B-Imprimir AT ROW 1.19 COL 102
     FILL-IN-CodCli AT ROW 2.15 COL 17 COLON-ALIGNED
     CMB-filtro AT ROW 2.15 COL 30 NO-LABEL
     FILL-IN-filtro AT ROW 2.15 COL 52 NO-LABEL
     C-CMPBTE AT ROW 3.12 COL 17 COLON-ALIGNED
     x-CndCre AT ROW 3.12 COL 31 NO-LABEL
     x-CodDiv AT ROW 4.08 COL 17 COLON-ALIGNED
     c-Serie AT ROW 4.08 COL 34 COLON-ALIGNED
     F-FMAPGO AT ROW 4.08 COL 55 COLON-ALIGNED
     F-CndVta AT ROW 4.08 COL 62.14 COLON-ALIGNED NO-LABEL
     COMBO-BOX-5 AT ROW 5.04 COL 17 COLON-ALIGNED
     f-desde AT ROW 5.04 COL 55 COLON-ALIGNED
     f-hasta AT ROW 5.04 COL 72 COLON-ALIGNED
     xcodmod AT ROW 5.42 COL 85 NO-LABEL
     f-codven AT ROW 6 COL 17 COLON-ALIGNED
     F-nomven AT ROW 6 COL 23 COLON-ALIGNED NO-LABEL
     x-FchVto-1 AT ROW 6 COL 55 COLON-ALIGNED
     x-FchVto-2 AT ROW 6 COL 72 COLON-ALIGNED
     br_table AT ROW 7.15 COL 1
     BUTTON-1 AT ROW 17.08 COL 100
     f-totsol AT ROW 17.15 COL 82 RIGHT-ALIGNED NO-LABEL
     f-totdol AT ROW 17.15 COL 84 NO-LABEL
     f-sdosol AT ROW 17.92 COL 68 NO-LABEL
     f-sdodol AT ROW 17.92 COL 84 NO-LABEL
     "Importe Total" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 17.15 COL 58
     "Filtrar x" VIEW-AS TEXT
          SIZE 6.72 BY .65 AT ROW 3.31 COL 2
          FONT 6
     "Saldo Total" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 17.92 COL 58
     "(*)  Doble Click - Visualiza Detalle" VIEW-AS TEXT
          SIZE 29 BY .73 AT ROW 17.85 COL 1.43
          FONT 6
     "Documentos en US$/" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 16.58 COL 84
     "Documentos en S/." VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 16.58 COL 68
     "(*)  Click Derecho - Visualiza Pagos" VIEW-AS TEXT
          SIZE 29 BY .73 AT ROW 17.19 COL 1.29
          FONT 6
     "Buscar x" VIEW-AS TEXT
          SIZE 7.86 BY .62 AT ROW 1.38 COL 5
          FONT 6
     RECT-1 AT ROW 1 COL 1
     RECT-55 AT ROW 16.38 COL 57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartLookup
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: External-Tables
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
  CREATE WINDOW L-table-Win ASSIGN
         HEIGHT             = 18.73
         WIDTH              = 142.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB L-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW L-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table x-FchVto-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nomven IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-sdodol IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN f-sdosol IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN f-totdol IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN f-totsol IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR RADIO-SET x-CndCre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX x-CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.CcbCDocu"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > integral.CcbCDocu.CodDoc
"CodDoc" "Tipo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.CcbCDocu.NroDoc
"NroDoc" ? "x(12)" "character" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.CcbCDocu.NroOrd
"NroOrd" "# Pedido!Cliente" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.CcbCDocu.NomCli
"NomCli" ? "x(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.CcbCDocu.FmaPgo
"FmaPgo" "Cnd.!Venta" "XXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.CcbCDocu.CodVen
"CodVen" "Ven." "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.CcbCDocu.FchDoc
"FchDoc" "     Fecha    !    Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = integral.CcbCDocu.FchVto
     _FldNameList[9]   > "_<CALC>"
"X-MON @ X-MON" "Mon." "XXXX" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > integral.CcbCDocu.ImpTot
"ImpTot" ? "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > integral.CcbCDocu.SdoAct
"SdoAct" "Saldo" "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   = integral.CcbCDocu.PorDto
     _FldNameList[13]   > "_<CALC>"
"fEstado() @ X-EST" "Estado" "XXX" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"fUbicacion() @ x-Ubicacion" "Ubicación" "x(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"fBanco() @ x-Banco" "Banco" "x(15)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"fSituacion() @ x-Situacion" "Situación" "x(15)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > integral.CcbCDocu.NroSal
"NroSal" "Numero Unico" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

&Scoped-define SELF-NAME B-Imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Imprimir L-table-Win
ON CHOOSE OF B-Imprimir IN FRAME F-Main /* Button 2 */
DO:
   ASSIGN xcodmod.
   /*RUN bin/_prnctr.p.*/
   RUN lib/Imprimir2.
   IF s-salida-impresion = 0 THEN RETURN.
   
   /* Captura parametros de impresion */
   /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
   
/*   RUN aderb/_prlist.p(
 *        OUTPUT s-printer-list,
 *        OUTPUT s-port-list,
 *        OUTPUT s-printer-count).
 *    s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
 *    s-port-name = REPLACE(S-PORT-NAME, ":", "").*/

   IF s-salida-impresion = 1 THEN 
      s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
   
  RUN Imprimir.
  
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file). 
  END CASE.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON ANY-PRINTABLE OF br_table IN FRAME F-Main
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
   ss-CodDiv = s-CodDiv.
   s-CodDiv = x-CodDiv.
   /*RUN VTA\D-cmpbte.r(Ccbcdocu.NroDoc,CcbcDocu.CodDoc).*/
   RUN Vta2/dcomprobantes (Ccbcdocu.NroDoc,CcbcDocu.CodDoc).
   s-CodDiv = ss-CodDiv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON RIGHT-MOUSE-CLICK OF br_table IN FRAME F-Main
DO:

    IF CAN-FIND(FIRST CCBDMOV WHERE
        CCBDMOV.codcia = s-codcia AND
        CCBDMOV.coddiv = s-coddiv AND
        CCBDMOV.coddoc = Ccbcdocu.CodDoc AND
        CCBDMOV.nrodoc = Ccbcdocu.NroDoc) THEN
        RUN VTA\D-cmpbt2.r(
            Ccbcdocu.CodDoc,
            CcbcDocu.NroDoc,
            CcbcDocu.NroPed,
            CcbcDocu.SdoAct,
            Ccbcdocu.Imptot,
            CcbcDocu.NroRef
            ).
    ELSE
        RUN VTA\D-cmpbt1.r(
            Ccbcdocu.CodDoc,
            CcbcDocu.NroDoc,
            CcbcDocu.NroPed,
            CcbcDocu.SdoAct,
            Ccbcdocu.Imptot,
            CcbcDocu.NroRef
            ).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
    RETURN NO-APPLY.
    /* This code displays initial values for newly added or copied rows. */
    {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON START-SEARCH OF br_table IN FRAME F-Main
DO:

    ASSIGN
        wh = br_table:CURRENT-COLUMN
        FILL-IN-chr:VISIBLE IN FRAME Dialog-Frame = FALSE
        FILL-IN-date:VISIBLE = FALSE
        FILL-IN-int:VISIBLE = FALSE
        FILL-IN-dec:VISIBLE = FALSE
        FILL-IN-buscar = wh:LABEL
        CMB-condicion:LIST-ITEMS = "".

    CASE wh:DATA-TYPE:
        WHEN "CHARACTER" THEN DO:
            ASSIGN
                FILL-IN-chr:VISIBLE = TRUE
                CMB-condicion:LIST-ITEMS = "=,Inicie con,Que contenga".
            IF LOOKUP(CMB-condicion, CMB-condicion:LIST-ITEMS) = 0 THEN
                ASSIGN CMB-condicion = CMB-condicion:ENTRY(1).
            DISPLAY FILL-IN-buscar WITH FRAME Dialog-Frame.
            UPDATE
                CMB-condicion
                FILL-IN-chr
                Btn_OK
                Btn_Cancel
                WITH FRAME Dialog-Frame.
        END.
        WHEN "INTEGER" THEN DO:
            ASSIGN
                FILL-IN-int:VISIBLE = TRUE
                CMB-condicion:LIST-ITEMS = "=,>,<,>=,<=".
            IF LOOKUP(CMB-condicion, CMB-condicion:LIST-ITEMS) = 0 THEN
                ASSIGN CMB-condicion = CMB-condicion:ENTRY(1).
            DISPLAY FILL-IN-buscar WITH FRAME Dialog-Frame.
            UPDATE
                CMB-condicion
                FILL-IN-int
                Btn_OK
                Btn_Cancel
                WITH FRAME Dialog-Frame.
        END.
        WHEN "DECIMAL" THEN DO:
            ASSIGN
                FILL-IN-dec:VISIBLE = TRUE
                CMB-condicion:LIST-ITEMS = "=,>,<,>=,<=".
            IF LOOKUP(CMB-condicion, CMB-condicion:LIST-ITEMS) = 0 THEN
                ASSIGN CMB-condicion = CMB-condicion:ENTRY(1).
            DISPLAY FILL-IN-buscar WITH FRAME Dialog-Frame.
            UPDATE
                CMB-condicion
                FILL-IN-dec
                Btn_OK
                Btn_Cancel
                WITH FRAME Dialog-Frame.
        END.
        WHEN "DATE" THEN DO:
            ASSIGN
                FILL-IN-date:VISIBLE = TRUE
                CMB-condicion:LIST-ITEMS = "=,>,<,>=,<=".
            IF LOOKUP(CMB-condicion, CMB-condicion:LIST-ITEMS) = 0 THEN
                ASSIGN CMB-condicion = CMB-condicion:ENTRY(1).
            DISPLAY FILL-IN-buscar WITH FRAME Dialog-Frame.
            UPDATE
                CMB-condicion
                FILL-IN-date
                Btn_OK
                Btn_Cancel
                WITH FRAME Dialog-Frame.
        END.
    END CASE.

    RUN busqueda-secuencial.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 L-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
 RUN Calcula-Importe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 L-table-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  ASSIGN xcodmod.
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-CMPBTE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-CMPBTE L-table-Win
ON VALUE-CHANGED OF C-CMPBTE IN FRAME F-Main /* Tipo Cmpbte. */
DO:
/*  CASE C-CMPBTE:SCREEN-VALUE:
 *        WHEN "Boleta"  THEN 
 *           ASSIGN 
 *              F-CMPBTE = "BOL".
 *        WHEN "Factura" THEN 
 *           ASSIGN 
 *              F-CMPBTE = "FAC".
 *        OTHERWISE
 *           ASSIGN 
 *              F-CMPBTE = "".
 *   END. */
  IF SELF:SCREEN-VALUE = 'N/C'
  THEN ASSIGN
            x-CndCre:SENSITIVE = YES.
  ELSE ASSIGN
            x-CndCre:SENSITIVE = NO
            x-CndCre = 'T'.
  DISPLAY x-CndCre WITH FRAME {&FRAME-NAME}. 
                    
  APPLY "VALUE-CHANGED" TO CMB-filtro.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-Serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-Serie L-table-Win
ON LEAVE OF c-Serie IN FRAME F-Main /* Serie */
DO:
  ASSIGN c-Serie.
  APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-filtro L-table-Win
ON VALUE-CHANGED OF CMB-filtro IN FRAME F-Main
DO:
    IF CMB-filtro = CMB-filtro:SCREEN-VALUE AND
       FILL-IN-filtro = FILL-IN-filtro:SCREEN-VALUE AND 
       C-CMPBTE = C-CMPBTE:SCREEN-VALUE AND
       x-CndCre = x-CndCre:SCREEN-VALUE
       THEN RETURN.
    ASSIGN
       FILL-IN-filtro
       CMB-filtro
       C-CMPBTE
       x-CndCre.
    IF CMB-filtro = "Todos" THEN DO:
       IF C-CMPBTE <> "" THEN RUN set-attribute-list('Key-Name=Nombres que inicien con').
       ELSE RUN set-attribute-list('Key-Name=?').
    END.
    
    ELSE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-5 L-table-Win
ON VALUE-CHANGED OF COMBO-BOX-5 IN FRAME F-Main /* Estado */
DO:
  ASSIGN COMBO-BOX-5.
  CASE COMBO-BOX-5:
       WHEN "Pendiente" THEN 
          ASSIGN F-ESTADO = "P".
       WHEN "Cancelado" THEN 
          ASSIGN F-ESTADO = "C".          
       WHEN "Anulado" THEN 
          ASSIGN F-ESTADO = "A".
       WHEN "Total Neto" THEN 
          ASSIGN F-ESTADO = "P,C".
       OTHERWISE
          ASSIGN F-ESTADO = "P,C,A".        
  END.        
  APPLY "VALUE-CHANGED" TO CMB-filtro.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-codven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-codven L-table-Win
ON LEAVE OF f-codven IN FRAME F-Main /* Vend */
DO:
   x-codven = SELF:SCREEN-VALUE.
   
   IF SELF:SCREEN-VALUE <> "" THEN DO:
      F-nomven:SCREEN-VALUE = "".
      x-codven = SELF:SCREEN-VALUE.
      FIND gn-ven WHERE 
           gn-ven.Codven = SELF:SCREEN-VALUE 
           NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven THEN DO:
         F-nomven:SCREEN-VALUE = gn-ven.nomven.
      END.
   END.
   ELSE F-nomven:SCREEN-VALUE = "".

  APPLY "VALUE-CHANGED" TO CMB-filtro.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-codven L-table-Win
ON MOUSE-SELECT-DBLCLICK OF f-codven IN FRAME F-Main /* Vend */
DO:
  RUN lkup\c-vende.r("Maestro de Vendedores").
  IF output-var-2 = ? THEN output-var-2 = "".
  F-codven:SCREEN-VALUE = output-var-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-desde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-desde L-table-Win
ON LEAVE OF f-desde IN FRAME F-Main /* Emitidos desde */
DO:
  ASSIGN f-desde.
  APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-FMAPGO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-FMAPGO L-table-Win
ON LEAVE OF F-FMAPGO IN FRAME F-Main /* Cnd.Vta */
DO:
   F-CONDI = F-FMAPGO:SCREEN-VALUE.
   
   IF F-FMAPGO:SCREEN-VALUE <> "" THEN DO:
      F-CndVta:SCREEN-VALUE = "".
      F-CONDI = F-FMAPGO:SCREEN-VALUE.
      FIND gn-convt WHERE 
           gn-convt.Codig = F-FMAPGO:SCREEN-VALUE 
           NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN DO:
         F-CNDVTA:SCREEN-VALUE = gn-convt.Nombr.
      END.
   END.
   ELSE F-CndVta:SCREEN-VALUE = "".

  APPLY "VALUE-CHANGED" TO CMB-filtro.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-FMAPGO L-table-Win
ON MOUSE-SELECT-DBLCLICK OF F-FMAPGO IN FRAME F-Main /* Cnd.Vta */
DO:
  RUN lkup\c-condvt.r("CONDICIONES DE VENTA").
  IF output-var-2 = ? THEN output-var-2 = "".
  F-FMAPGO:SCREEN-VALUE = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-hasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-hasta L-table-Win
ON LEAVE OF f-hasta IN FRAME F-Main /* Hasta */
DO:
  ASSIGN f-hasta.
  APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli L-table-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
  ASSIGN {&SELF-NAME}.

  DEFINE VAR lFiltro AS LOG.
  lFiltro = YES.
  IF FILL-IN-CodCli <> "" THEN DO:
      FIND FIRST gn-clie WHERE gn-clie.codcia = 1 AND 
                                gn-clie.codcli = FILL-IN-CodCli NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clie THEN DO:
          IF gn-clie.libre_l02 = YES THEN DO:
              lfiltro = NO.
          END.
      END.
  END.
  IF lFiltro = YES THEN DO:
      APPLY "VALUE-CHANGED" TO CMB-filtro.
  END.
  ELSE DO:
      MESSAGE "Use la aplicacion OPENORANGE para consultar informacion de este Cliente".
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli L-table-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
  ASSIGN
    input-var-1 = ''
    input-var-2 = ''
    input-var-3 = ''
    output-var-1 = ?
    output-var-2 = ''
    output-var-3 = ''.
  RUN lkup/c-client ('Maestro de Clientes').
  IF output-var-1 <> ?
  THEN DO:
    ASSIGN SELF:SCREEN-VALUE = output-var-2.
    RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codigo L-table-Win
ON LEAVE OF FILL-IN-codigo IN FRAME F-Main /* Código */
DO:
    IF INPUT FILL-IN-codigo = "" THEN RETURN.
    &IF "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}" &THEN
        FIND FIRST {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
            {&CONDICION} AND
            ( {&CODIGO} = INPUT FILL-IN-codigo )
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            BELL.
            MESSAGE "Registro no encontrado" VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = "".
            RETURN.
        END.
        REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE
                "Registro no se encuentra en el filtro actual" SKIP
                "       Deshacer la actual selección ?       "
                VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO TITLE "Pregunta"
                UPDATE answ AS LOGICAL.
            IF answ THEN DO:
                ASSIGN
                    FILL-IN-filtro:SCREEN-VALUE = ""
                    CMB-filtro:SCREEN-VALUE = CMB-filtro:ENTRY(1).
                APPLY "VALUE-CHANGED" TO CMB-filtro.
                RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
                REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
            END.
        END.
        ASSIGN SELF:SCREEN-VALUE = "".
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro L-table-Win
ON LEAVE OF FILL-IN-filtro IN FRAME F-Main
OR "RETURN":U OF FILL-IN-filtro
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CndCre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CndCre L-table-Win
ON VALUE-CHANGED OF x-CndCre IN FRAME F-Main
DO:
  /*ASSIGN x-CndCre.*/
  APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodDiv L-table-Win
ON VALUE-CHANGED OF x-CodDiv IN FRAME F-Main /* Division */
DO:
  ASSIGN x-CodDiv.
  APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchVto-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchVto-1 L-table-Win
ON LEAVE OF x-FchVto-1 IN FRAME F-Main /* Vencidos desde */
DO:
  ASSIGN {&SELF-NAME}.
  APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchVto-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchVto-2 L-table-Win
ON LEAVE OF x-FchVto-2 IN FRAME F-Main /* Hasta */
DO:
  ASSIGN {&SELF-NAME}.
  APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME xcodmod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL xcodmod L-table-Win
ON VALUE-CHANGED OF xcodmod IN FRAME F-Main
DO:
  ASSIGN {&SELF-NAME}.
  APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK L-table-Win 


/* ***************************  Main Block  *************************** */
ASSIGN f-desde = TODAY
       f-hasta = TODAY.
       xcodmod.
       
ON FIND OF Ccbcdocu
DO:

    IF CcbcDocu.CodMon = 1 THEN
        ASSIGN
            X-MON = "S/." .
    ELSE
        ASSIGN
            X-MON = "US$" .
            
    IF CcbCDocu.FlgEst = "P" THEN
        ASSIGN
            X-EST = "PEN" .
    ELSE
       IF CcbCDocu.FlgEst = "C" THEN
          ASSIGN
              X-EST = "CAN" .    
       ELSE       
          IF CcbcDocu.FlgEst = "A" THEN
             ASSIGN
                 X-EST = "ANU" .            
END.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases L-table-Win  adm/support/_adm-opn.p
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
    WHEN 'Nombres que Inicien con':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro1} )
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Nombres que Inicien con */
    WHEN 'Nombres que Contengan':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro2} )
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Nombres que Contengan */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available L-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busqueda-secuencial L-table-Win 
PROCEDURE busqueda-secuencial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF DEFINED (FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) > 0 &THEN

DEFINE VARIABLE pto AS LOGICAL NO-UNDO.
pto = SESSION:SET-WAIT-STATE("GENERAL").

ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).

lazo:
DO WHILE AVAILABLE({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) ON STOP UNDO, LEAVE lazo:

    GET NEXT {&BROWSE-NAME}.

    IF QUERY-OFF-END("{&BROWSE-NAME}") THEN GET FIRST {&BROWSE-NAME}.

    REPOSITION br_table TO ROWID ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).

    IF RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = curr-record THEN LEAVE lazo.

    CASE wh:DATA-TYPE:
    WHEN "INTEGER" THEN DO:
        CASE CMB-condicion:
        WHEN "=" THEN
            IF INTEGER(wh:SCREEN-VALUE) = FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">" THEN
            IF INTEGER(wh:SCREEN-VALUE) > FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">=" THEN
            IF INTEGER(wh:SCREEN-VALUE) >= FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<" THEN
            IF INTEGER(wh:SCREEN-VALUE) <  FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<=" THEN
            IF INTEGER(wh:SCREEN-VALUE) <= FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        END CASE.
    END.
    WHEN "DECIMAL" THEN DO:
        CASE CMB-condicion:
        WHEN "=" THEN
            IF DECIMAL(wh:SCREEN-VALUE) = FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">" THEN
            IF DECIMAL(wh:SCREEN-VALUE) > FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">=" THEN
            IF DECIMAL(wh:SCREEN-VALUE) >= FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<" THEN
            IF DECIMAL(wh:SCREEN-VALUE) <  FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<=" THEN
            IF DECIMAL(wh:SCREEN-VALUE) <= FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        END CASE.
    END.
    WHEN "DATE" THEN DO:
        CASE CMB-condicion:
        WHEN "=" THEN
            IF DATE(wh:SCREEN-VALUE) = FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">" THEN
            IF DATE(wh:SCREEN-VALUE) > FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">=" THEN
            IF DATE(wh:SCREEN-VALUE) >= FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<" THEN
            IF DATE(wh:SCREEN-VALUE) <  FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<=" THEN
            IF DATE(wh:SCREEN-VALUE) <= FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        END CASE.
    END.
    WHEN "CHARACTER" THEN
        CASE CMB-condicion:
        WHEN "=" THEN
            IF wh:SCREEN-VALUE = FILL-IN-chr THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "Inicie con" THEN
            IF wh:SCREEN-VALUE BEGINS FILL-IN-chr THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "Que contenga" THEN
            IF INDEX(wh:SCREEN-VALUE, FILL-IN-chr) > 0 THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        END CASE.
    OTHERWISE LEAVE lazo.
    END CASE.
END.

pto = SESSION:SET-WAIT-STATE("").

REPOSITION {&BROWSE-NAME} TO RECID curr-record.

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Importe L-table-Win 
PROCEDURE Calcula-Importe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Factor AS INT INIT 1 NO-UNDO.
    X_TOT_IS = 0.
    X_TOT_SS = 0.
    X_TOT_ID = 0.
    X_TOT_SD = 0.

 GET FIRST {&BROWSE-NAME}.
 DO WHILE AVAILABLE(Ccbcdocu):
    x-Factor = 1.
    FIND FacDocum OF CcbCDocu NO-LOCK NO-ERROR.
    IF AVAILABLE FacDocum
    THEN x-Factor = IF FacDocum.TpoDoc = NO THEN -1 ELSE 1.
    IF ccbcdocu.flgest = 'A' THEN x-Factor = 0.     /* ANULADOS */
    IF Ccbcdocu.CodMon = 1 THEN
        ASSIGN
            X_TOT_IS = X_TOT_IS + ccbcdocu.ImpTot * x-Factor
            X_TOT_SS = X_TOT_SS + ccbcdocu.Sdoact * x-Factor.
    ELSE
        ASSIGN
            X_TOT_ID = X_TOT_ID + ccbcdocu.ImpTot * x-Factor
            X_TOT_SD = X_TOT_SD + ccbcdocu.Sdoact * x-Factor.

    GET NEXT {&BROWSE-NAME}.
 END.
 
 DO WITH FRAME {&FRAME-NAME}:
       DISPLAY X_TOT_IS @ f-totsol
               X_TOT_ID @ f-totdol
               X_TOT_SS @ f-sdosol
               X_TOT_SD @ f-sdodol.
    
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE captura-datos L-table-Win 
PROCEDURE captura-datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF DEFINED (FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) > 0 &THEN

IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
    ASSIGN
        output-var-1 = ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} )
        output-var-2 = STRING( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroDoc, "999-999999" )
        output-var-3 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nomcli.

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI L-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel L-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE t-ccbcdocu.
       
  GET FIRST {&BROWSE-NAME}.
  REPEAT WHILE AVAILABLE ccbcdocu:
    CREATE t-ccbcdocu.
    BUFFER-COPY ccbcdocu TO t-ccbcdocu.
    GET NEXT {&BROWSE-NAME}.
  END.
  FIND FIRST t-ccbcdocu NO-LOCK NO-ERROR.
  IF NOT AVAILABLE t-ccbcdocu THEN RETURN ERROR.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 3.
chWorkSheet:Columns("B"):ColumnWidth = 9.
chWorkSheet:Columns("C"):ColumnWidth = 15.
chWorkSheet:Columns("D"):ColumnWidth = 40.
chWorkSheet:Columns("E"):ColumnWidth = 10.
chWorkSheet:Columns("F"):ColumnWidth = 10.
chWorkSheet:Columns("G"):ColumnWidth = 10.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 20.
chWorkSheet:Columns("J"):ColumnWidth = 20.
chWorkSheet:Columns("K"):ColumnWidth = 20.
chWorkSheet:Columns("L"):ColumnWidth = 20.

chWorkSheet:Range("A2"):Value = "Doc".
chWorkSheet:Range("B2"):Value = "Numero".
chWorkSheet:Range("C2"):Value = "Pedido Cliente".
chWorkSheet:Range("D2"):Value = "Cliente".
chWorkSheet:Range("E2"):Value = "Cond. Vta.".
chWorkSheet:Range("F2"):Value = "Vendedor".
chWorkSheet:Range("G2"):Value = "Emision".
chWorkSheet:Range("H2"):Value = "Vencimiento".
CASE xcodmod:
    WHEN 1 THEN DO:
        chWorkSheet:Range("I2"):Value = "Importe S/.".
        chWorkSheet:Range("J2"):Value = "Saldo S/.".
        chWorkSheet:Range("K2"):Value = "Estado".
    END.
    WHEN 2 THEN DO:
        chWorkSheet:Range("I2"):Value = "Importe US$".
        chWorkSheet:Range("J2"):Value = "Saldo US$".
        chWorkSheet:Range("K2"):Value = "Estado".
    END.
    WHEN 3 THEN DO:
        chWorkSheet:Range("I2"):Value = "Importe S/.".
        chWorkSheet:Range("J2"):Value = "Saldo S/.".
        chWorkSheet:Range("K2"):Value = "Importe US$".
        chWorkSheet:Range("L2"):Value = "Saldo US$".
        chWorkSheet:Range("M2"):Value = "Estado".
    END.
END.

FOR EACH t-ccbcdocu:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = t-ccbcdocu.coddoc.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + t-ccbcdocu.nrodoc.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + t-ccbcdocu.nroord.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = t-ccbcdocu.nomcli.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + t-ccbcdocu.fmapgo.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + t-ccbcdocu.codven.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = t-ccbcdocu.fchdoc.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = t-ccbcdocu.fchvto.
    CASE xcodmod:
        WHEN 1 OR WHEN 2 THEN DO:
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = t-ccbcdocu.imptot.
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = t-ccbcdocu.sdoact.
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = fEstado-1(t-ccbcdocu.flgest).
        END.
        WHEN 3 THEN DO:
            IF t-ccbcdocu.codmon = 1 THEN DO:
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Value = t-ccbcdocu.imptot.
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = t-ccbcdocu.sdoact.
            END.
            IF t-ccbcdocu.codmon = 2 THEN DO:
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = t-ccbcdocu.imptot.
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = t-ccbcdocu.sdoact.
            END.
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = fEstado-1(t-ccbcdocu.flgest).
        END.
    END CASE.
END.

MESSAGE "Proceso Terminado" VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato L-table-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-Factor AS INT NO-UNDO.
   
DEFINE FRAME F-HdrConsulta
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" 
    "Fecha  : " AT 90 TODAY SKIP(1)
    {&PRN6A} + "CONSULTA DE COMPROBANTES" + {&PRN6B} + {&PRND} AT 45 FORMAT "X(45)" SKIP(1)
    "Desde         : " STRING(F-Desde,"99/99/9999") FORMAT "x(40)" SKIP
    "Hasta         : " STRING(F-Hasta,"99/99/9999") FORMAT "x(40)" SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP
    "                                                     COND. COD. FECHA DE  FECHA DE                                             " SKIP
    "DOC.NUMERO   NOMBRE O RAZON SOCIAL                   VENTA VEN. EMISION   VENCMTO.   MONEDA      IMPORTE         SALDO  ESTADO " SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP
/*   1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
     123 123456789 1234567890123456789012345678901234567890 123 123 99/99/9999 99/99/9999 12345 >>>,>>9.99 >>>,>>9.99
*/     
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
DEFINE FRAME F-FdrConsulta
    HEADER    
    SPACE(3) '!  TOTALES           !    SOLES     !   DOLARES  ! ' SKIP
    SPACE(3) FILL('-',50) FORMAT 'X(50)' SKIP
    SPACE(3) '!  IMPORTES        !' 
        X_tot_is FORMAT '->>>>,>>9.99' '!'
        X_TOT_ID FORMAT '->>>>,>>9.99' '!' SKIP
    SPACE(3) '!  SALDOS            !' 
        X_TOT_SS FORMAT '->>>>,>>9.99' '!'
        x_TOT_SD FORMAT '->>>>,>>9.99' '!'SKIP        
    SPACE(3) FILL('-',50) FORMAT 'X(50)' SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 200. 

/* NUEVA RUTINA */
  DEFINE FRAME F-DetaCon
    t-Ccbcdocu.Coddoc 
    t-Ccbcdocu.nrodoc 
    t-Ccbcdocu.nomcli FORMAT "X(40)" 
    t-Ccbcdocu.fmapgo FORMAT "X(3)"
    t-Ccbcdocu.CodVen FORMAT "X(3)"
    t-Ccbcdocu.FchDoc FORMAT '99/99/9999'
    t-Ccbcdocu.FchVto FORMAT '99/99/9999'
    X-MON           FORMAT "X(5)"
    t-Ccbcdocu.Imptot
    t-Ccbcdocu.Sdoact
    X-EST
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 
  FOR EACH t-ccbcdocu:
    DELETE T-ccbcdocu.
  END.
       
  GET FIRST {&BROWSE-NAME}.
  
  REPEAT WHILE AVAILABLE ccbcdocu:
    CREATE t-ccbcdocu.
    BUFFER-COPY ccbcdocu TO t-ccbcdocu.
/*    IF t-ccbcdocu.coddoc = 'N/C' 
 *     THEN ASSIGN
 *             t-ccbcdocu.imptot = t-ccbcdocu.imptot * -1
 *             t-ccbcdocu.sdoact = t-ccbcdocu.sdoact * -1.*/
    GET NEXT {&BROWSE-NAME}.
  END.
  
   CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO PRINTER             PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.
  
    X_TOT_IS = 0.
    X_TOT_SS = 0.
    X_TOT_ID = 0.
    X_TOT_SD = 0.
  
  FOR EACH t-ccbcdocu BREAK BY t-ccbcdocu.codcia BY t-ccbcdocu.fchdoc:
    
    x-Factor = 1.
    FIND FacDocum OF t-CcbCDocu NO-LOCK NO-ERROR.
    IF AVAILABLE FacDocum
    THEN x-Factor = IF FacDocum.TpoDoc = NO THEN -1 ELSE 1.

    IF t-ccbcdocu.flgest <> 'A'     /* NO ANULADOS */
    THEN DO:
        IF t-ccbcdocu.CodMon = 1 THEN
            ASSIGN
                X_TOT_IS = X_TOT_IS + t-ccbcdocu.ImpTot * x-Factor
                X_TOT_SS = X_TOT_SS + t-ccbcdocu.Sdoact * x-Factor.
        ELSE
            ASSIGN
                X_TOT_ID = X_TOT_ID + t-ccbcdocu.ImpTot * x-Factor
                X_TOT_SD = X_TOT_SD + t-ccbcdocu.Sdoact * x-Factor.
    END.
             
          
    IF t-CcbcDocu.CodMon = 1 THEN
        ASSIGN
            X-MON = "S/.".
    ELSE
        ASSIGN
            X-MON = "US$".
                    
    IF t-CcbCDocu.FlgEst = "P" THEN
        ASSIGN
            X-EST = "PEN" .
    ELSE
       IF t-CcbCDocu.FlgEst = "C" THEN
          ASSIGN
              X-EST = "CAN" .    
       ELSE       
          IF t-CcbcDocu.FlgEst = "A" THEN
             ASSIGN
                 X-EST = "ANU" .            

    VIEW FRAME F-HdrConsulta.
   DISPLAY 
    t-Ccbcdocu.Coddoc 
    t-Ccbcdocu.nrodoc 
    t-Ccbcdocu.nomcli 
    t-Ccbcdocu.fmapgo
    t-Ccbcdocu.CodVen
    t-Ccbcdocu.FchDoc
    t-Ccbcdocu.FchVto
    X-MON
    t-Ccbcdocu.Imptot
    t-Ccbcdocu.Sdoact
    X-EST
    WITH FRAME F-Detacon.
    IF LAST-OF(t-Ccbcdocu.codcia) THEN DO:
        UNDERLINE    
        t-Ccbcdocu.ImpTot
        t-CcbCdocu.SdoAct
        WITH FRAME F-Detacon.
        DISPLAY 
            "   Importe Soles "     @ t-Ccbcdocu.FchVto
            x_tot_is @ t-Ccbcdocu.Imptot
            WITH FRAME F-Detacon.
        DOWN WITH FRAME F-Detacon.
        DISPLAY 
            "   Importe Dolares "     @ t-Ccbcdocu.FchVto
            x_tot_id @ t-Ccbcdocu.Imptot
            WITH FRAME F-Detacon.
        DOWN WITH FRAME F-Detacon.
        DISPLAY 
            "   Saldo Soles "     @ t-Ccbcdocu.FchVto
            x_tot_ss @ t-Ccbcdocu.Imptot
            WITH FRAME F-Detacon.
        DOWN WITH FRAME F-Detacon.
        DISPLAY 
            "   Saldo Dolares "     @ t-Ccbcdocu.FchVto
            x_tot_sd @ t-Ccbcdocu.Imptot
            WITH FRAME F-Detacon.
        DOWN WITH FRAME F-Detacon.
    END.
  END.
  

OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 L-table-Win 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-Factor AS INT NO-UNDO.
   
DEFINE FRAME F-HdrConsulta
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" 
    "Fecha  : " AT 90 TODAY SKIP(1)
    {&PRN6A} + "CONSULTA DE COMPROBANTES" + {&PRN6B} + {&PRND} AT 45 FORMAT "X(45)" SKIP(1)
    "Desde         : " STRING(F-Desde,"99/99/9999") FORMAT "x(40)" SKIP
    "Hasta         : " STRING(F-Hasta,"99/99/9999") FORMAT "x(40)" SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP
    "                                                     COND. COD. FECHA DE  FECHA DE                                             " SKIP
    "DOC.NUMERO   NOMBRE O RAZON SOCIAL                   VENTA VEN. EMISION   VENCMTO.   MONEDA      IMPORTE         SALDO  ESTADO " SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP
/*   1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
     123 123456789 1234567890123456789012345678901234567890 123 123 99/99/9999 99/99/9999 12345 >>>,>>9.99 >>>,>>9.99
*/     
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
DEFINE FRAME F-FdrConsulta
    HEADER    
    SPACE(3) '!  TOTALES           !    SOLES     !   DOLARES  ! ' SKIP
    SPACE(3) FILL('-',50) FORMAT 'X(50)' SKIP
    SPACE(3) '!  IMPORTES        !' 
        X_tot_is FORMAT '->>>>,>>9.99' '!'
        X_TOT_ID FORMAT '->>>>,>>9.99' '!' SKIP
    SPACE(3) '!  SALDOS            !' 
        X_TOT_SS FORMAT '->>>>,>>9.99' '!'
        x_TOT_SD FORMAT '->>>>,>>9.99' '!'SKIP        
    SPACE(3) FILL('-',50) FORMAT 'X(50)' SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 200. 

 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO PRINTER             PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.

    X_TOT_IS = 0.
    X_TOT_SS = 0.
    X_TOT_ID = 0.
    X_TOT_SD = 0.

/* NUEVA RUTINA */
  DEFINE FRAME F-DetaCon
    t-Ccbcdocu.Coddoc 
    t-Ccbcdocu.nrodoc 
    t-Ccbcdocu.nomcli FORMAT "X(40)" 
    t-Ccbcdocu.fmapgo FORMAT "X(3)"
    t-Ccbcdocu.CodVen FORMAT "X(3)"
    t-Ccbcdocu.FchDoc FORMAT '99/99/9999'
    t-Ccbcdocu.FchVto FORMAT '99/99/9999'
    X-MON           FORMAT "X(5)"
    t-Ccbcdocu.Imptot
    t-Ccbcdocu.Sdoact
    X-EST
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 
   
  
  FOR EACH t-ccbcdocu:
    DELETE T-ccbcdocu.
  END.
       
  GET FIRST {&BROWSE-NAME}.
  
  REPEAT WHILE AVAILABLE ccbcdocu:
    CREATE t-ccbcdocu.
    BUFFER-COPY ccbcdocu TO t-ccbcdocu.
/*    IF t-ccbcdocu.coddoc = 'N/C' 
 *     THEN ASSIGN
 *             t-ccbcdocu.imptot = t-ccbcdocu.imptot * -1
 *             t-ccbcdocu.sdoact = t-ccbcdocu.sdoact * -1.*/
    GET NEXT {&BROWSE-NAME}.
  END.
  FOR EACH t-ccbcdocu where t-ccbcdocu.codmon = 1 BREAK BY t-ccbcdocu.codcia BY t-ccbcdocu.fchdoc:
    
    x-Factor = 1.
    FIND FacDocum OF t-CcbCDocu NO-LOCK NO-ERROR.
    IF AVAILABLE FacDocum
    THEN x-Factor = IF FacDocum.TpoDoc = NO THEN -1 ELSE 1.

    IF t-ccbcdocu.flgest <> 'A'     /* NO ANULADOS */
    THEN DO:
        IF t-ccbcdocu.CodMon = 1 THEN
            ASSIGN
                X_TOT_IS = X_TOT_IS + t-ccbcdocu.ImpTot * x-Factor
                X_TOT_SS = X_TOT_SS + t-ccbcdocu.Sdoact * x-Factor.
        /*ELSE
            ASSIGN
                X_TOT_ID = X_TOT_ID + t-ccbcdocu.ImpTot * x-Factor
                X_TOT_SD = X_TOT_SD + t-ccbcdocu.Sdoact * x-Factor.*/
    END.
         
     
    IF t-CcbcDocu.CodMon = 1 THEN
        ASSIGN
            X-MON = "S/.".
    /*ELSE
        ASSIGN
            X-MON = "US$".*/
                    
    IF t-CcbCDocu.FlgEst = "P" THEN
        ASSIGN
            X-EST = "PEN" .
    ELSE
       IF t-CcbCDocu.FlgEst = "C" THEN
          ASSIGN
              X-EST = "CAN" .    
       ELSE       
          IF t-CcbcDocu.FlgEst = "A" THEN
             ASSIGN
                 X-EST = "ANU" .            

    VIEW FRAME F-HdrConsulta.
   DISPLAY 
    t-Ccbcdocu.Coddoc 
    t-Ccbcdocu.nrodoc 
    t-Ccbcdocu.nomcli 
    t-Ccbcdocu.fmapgo
    t-Ccbcdocu.CodVen
    t-Ccbcdocu.FchDoc
    t-Ccbcdocu.FchVto
    X-MON
    t-Ccbcdocu.Imptot
    t-Ccbcdocu.Sdoact
    X-EST
    WITH FRAME F-Detacon.
    
    IF LAST-OF(t-Ccbcdocu.codcia) THEN DO:
        UNDERLINE    
        t-Ccbcdocu.ImpTot
        t-CcbCdocu.SdoAct
        WITH FRAME F-Detacon.
        DISPLAY 
            "   Importe Soles "     @ t-Ccbcdocu.FchVto
            x_tot_is @ t-Ccbcdocu.Imptot
            WITH FRAME F-Detacon.
        DOWN WITH FRAME F-Detacon.
        DISPLAY 
            "   Importe Dolares "     @ t-Ccbcdocu.FchVto
            x_tot_id @ t-Ccbcdocu.Imptot
            WITH FRAME F-Detacon.
        DOWN WITH FRAME F-Detacon.
        DISPLAY 
            "   Saldo Soles "     @ t-Ccbcdocu.FchVto
            x_tot_ss @ t-Ccbcdocu.Imptot
            WITH FRAME F-Detacon.
        DOWN WITH FRAME F-Detacon.
        DISPLAY 
            "   Saldo Dolares "     @ t-Ccbcdocu.FchVto
            x_tot_sd @ t-Ccbcdocu.Imptot
            WITH FRAME F-Detacon.
        DOWN WITH FRAME F-Detacon.
    END.
  END.
  
OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 L-table-Win 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-Factor AS INT NO-UNDO.
   
DEFINE FRAME F-HdrConsulta
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" 
    "Fecha  : " AT 90 TODAY SKIP(1)
    {&PRN6A} + "CONSULTA DE COMPROBANTES" + {&PRN6B} + {&PRND} AT 45 FORMAT "X(45)" SKIP(1)
    "Desde         : " STRING(F-Desde,"99/99/9999") FORMAT "x(40)" SKIP
    "Hasta         : " STRING(F-Hasta,"99/99/9999") FORMAT "x(40)" SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP
    "                                                     COND. COD. FECHA DE  FECHA DE                                             " SKIP
    "DOC.NUMERO   NOMBRE O RAZON SOCIAL                   VENTA VEN. EMISION   VENCMTO.   MONEDA      IMPORTE         SALDO  ESTADO " SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP
/*   1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
     123 123456789 1234567890123456789012345678901234567890 123 123 99/99/9999 99/99/9999 12345 >>>,>>9.99 >>>,>>9.99
*/     
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
DEFINE FRAME F-FdrConsulta
    HEADER    
    SPACE(3) '!  TOTALES           !    SOLES     !   DOLARES  ! ' SKIP
    SPACE(3) FILL('-',50) FORMAT 'X(50)' SKIP
    SPACE(3) '!  IMPORTES        !' 
        X_tot_is FORMAT '->>>>,>>9.99' '!'
        X_TOT_ID FORMAT '->>>>,>>9.99' '!' SKIP
    SPACE(3) '!  SALDOS            !' 
        X_TOT_SS FORMAT '->>>>,>>9.99' '!'
        x_TOT_SD FORMAT '->>>>,>>9.99' '!'SKIP        
    SPACE(3) FILL('-',50) FORMAT 'X(50)' SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 200. 

 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO PRINTER             PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.

    X_TOT_IS = 0.
    X_TOT_SS = 0.
    X_TOT_ID = 0.
    X_TOT_SD = 0.

/* NUEVA RUTINA */
  DEFINE FRAME F-DetaCon
    t-Ccbcdocu.Coddoc 
    t-Ccbcdocu.nrodoc 
    t-Ccbcdocu.nomcli FORMAT "X(40)" 
    t-Ccbcdocu.fmapgo FORMAT "X(3)"
    t-Ccbcdocu.CodVen FORMAT "X(3)"
    t-Ccbcdocu.FchDoc FORMAT '99/99/9999'
    t-Ccbcdocu.FchVto FORMAT '99/99/9999'
    X-MON           FORMAT "X(5)"
    t-Ccbcdocu.Imptot
    t-Ccbcdocu.Sdoact
    X-EST
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 
   
  
  FOR EACH t-ccbcdocu:
    DELETE T-ccbcdocu.
  END.
       
  GET FIRST {&BROWSE-NAME}.
  
  REPEAT WHILE AVAILABLE ccbcdocu:
    CREATE t-ccbcdocu.
    BUFFER-COPY ccbcdocu TO t-ccbcdocu.
/*    IF t-ccbcdocu.coddoc = 'N/C' 
 *     THEN ASSIGN
 *             t-ccbcdocu.imptot = t-ccbcdocu.imptot * -1
 *             t-ccbcdocu.sdoact = t-ccbcdocu.sdoact * -1.*/
    GET NEXT {&BROWSE-NAME}.
  END.
  FOR EACH t-ccbcdocu where t-ccbcdocu.codmon = 2 BREAK BY t-ccbcdocu.codcia BY t-ccbcdocu.fchdoc:
    
    x-Factor = 1.
    FIND FacDocum OF t-CcbCDocu NO-LOCK NO-ERROR.
    IF AVAILABLE FacDocum
    THEN x-Factor = IF FacDocum.TpoDoc = NO THEN -1 ELSE 1.

    IF t-ccbcdocu.flgest <> 'A'     /* NO ANULADOS */
    THEN DO:
        IF t-ccbcdocu.CodMon = 2 THEN
            /*ASSIGN
                X_TOT_IS = X_TOT_IS + t-ccbcdocu.ImpTot * x-Factor
                X_TOT_SS = X_TOT_SS + t-ccbcdocu.Sdoact * x-Factor.
        ELSE*/
            ASSIGN
                X_TOT_ID = X_TOT_ID + t-ccbcdocu.ImpTot * x-Factor
                X_TOT_SD = X_TOT_SD + t-ccbcdocu.Sdoact * x-Factor.
    END.
         
     
    IF t-CcbcDocu.CodMon = 2 THEN
        /*ASSIGN
            X-MON = "S/.".
    ELSE*/
        ASSIGN
            X-MON = "US$".
                    
    IF t-CcbCDocu.FlgEst = "P" THEN
        ASSIGN
            X-EST = "PEN" .
    ELSE
       IF t-CcbCDocu.FlgEst = "C" THEN
          ASSIGN
              X-EST = "CAN" .    
       ELSE       
          IF t-CcbcDocu.FlgEst = "A" THEN
             ASSIGN
                 X-EST = "ANU" .            

    VIEW FRAME F-HdrConsulta.
   DISPLAY 
    t-Ccbcdocu.Coddoc 
    t-Ccbcdocu.nrodoc 
    t-Ccbcdocu.nomcli 
    t-Ccbcdocu.fmapgo
    t-Ccbcdocu.CodVen
    t-Ccbcdocu.FchDoc
    t-Ccbcdocu.FchVto
    X-MON
    t-Ccbcdocu.Imptot
    t-Ccbcdocu.Sdoact
    X-EST
    WITH FRAME F-Detacon.
    
    IF LAST-OF(t-Ccbcdocu.codcia) THEN DO:
        UNDERLINE    
        t-Ccbcdocu.ImpTot
        t-CcbCdocu.SdoAct
        WITH FRAME F-Detacon.
        DISPLAY 
            "   Importe Soles "     @ t-Ccbcdocu.FchVto
            x_tot_is @ t-Ccbcdocu.Imptot
            WITH FRAME F-Detacon.
        DOWN WITH FRAME F-Detacon.
        DISPLAY 
            "   Importe Dolares "     @ t-Ccbcdocu.FchVto
            x_tot_id @ t-Ccbcdocu.Imptot
            WITH FRAME F-Detacon.
        DOWN WITH FRAME F-Detacon.
        DISPLAY 
            "   Saldo Soles "     @ t-Ccbcdocu.FchVto
            x_tot_ss @ t-Ccbcdocu.Imptot
            WITH FRAME F-Detacon.
        DOWN WITH FRAME F-Detacon.
        DISPLAY 
            "   Saldo Dolares "     @ t-Ccbcdocu.FchVto
            x_tot_sd @ t-Ccbcdocu.Imptot
            WITH FRAME F-Detacon.
        DOWN WITH FRAME F-Detacon.
    END.
  END.
  
OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir L-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF xcodmod = 1 THEN RUN Formato1.
IF xcodmod = 2 THEN RUN Formato2.
IF xcodmod = 3 THEN RUN Formato.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize L-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    RUN get-attribute ('Keys-Accepted').

    IF RETURN-VALUE <> "" AND RETURN-VALUE <> ? THEN
        ASSIGN
            CMB-filtro:LIST-ITEMS IN FRAME {&FRAME-NAME} =
            CMB-filtro:LIST-ITEMS + "," + RETURN-VALUE.
    
    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
        x-CodDiv:ADD-LAST(gn-divi.coddiv).
    END.
    x-CodDiv = s-CodDiv.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN
        output-var-1 = ?
        output-var-2 = ?
        output-var-3 = ?.
    RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query-cases L-table-Win 
PROCEDURE local-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query-cases':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key L-table-Win  adm/support/_key-snd.p
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records L-table-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed L-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toma-handle L-table-Win 
PROCEDURE toma-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-handle AS WIDGET-HANDLE.
    
    ASSIGN whpadre = p-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBanco L-table-Win 
FUNCTION fBanco RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pValor AS CHAR NO-UNDO.

  IF Ccbcdocu.coddoc <> "LET" THEN RETURN "".   /* Function return value. */

  RUN vta2/p-estado-letras ("Banco", Ccbcdocu.codcta, OUTPUT pValor).
  RETURN pValor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado L-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    IF CcbCDocu.FlgEst = "P" THEN
        ASSIGN
            X-EST = "PEN" .
    ELSE
       IF CcbCDocu.FlgEst = "C" THEN
          ASSIGN
              X-EST = "CAN" .    
       ELSE       
          IF CcbcDocu.FlgEst = "A" THEN
             ASSIGN
                 X-EST = "ANU" .            
  CASE Ccbcdocu.flgest:
    WHEN 'P' THEN RETURN 'PEN'.
    WHEN 'C' THEN RETURN 'CAN'.
    WHEN 'A' THEN RETURN 'ANU'.
    OTHERWISE RETURN '???'.
  END CASE.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado-1 L-table-Win 
FUNCTION fEstado-1 RETURNS CHARACTER
  ( INPUT pFlgEst AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE pflgest:
    WHEN 'P' THEN RETURN 'PEN'.
    WHEN 'C' THEN RETURN 'CAN'.
    WHEN 'A' THEN RETURN 'ANU'.
    OTHERWISE RETURN '???'.
  END CASE.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSituacion L-table-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pValor AS CHAR NO-UNDO.

  IF Ccbcdocu.coddoc <> "LET" THEN RETURN "".   /* Function return value. */

  RUN vta2/p-estado-letras ("Situacion", Ccbcdocu.flgsit, OUTPUT pValor).
  RETURN pValor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fUbicacion L-table-Win 
FUNCTION fUbicacion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pValor AS CHAR NO-UNDO.

  IF Ccbcdocu.coddoc <> "LET" THEN RETURN "".   /* Function return value. */

  RUN vta2/p-estado-letras ("Ubicacion", Ccbcdocu.flgubi, OUTPUT pValor).
  RETURN pValor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

