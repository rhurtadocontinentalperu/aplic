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

/* Local Variable Definitions ---                                       */
DEFINE BUFFER B-DOCU FOR CcbCDocu.

DEF SHARED VAR cl-CodCia AS INT.
DEF NEW SHARED VAR s-CodCli AS CHAR.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR s-CodCia AS INTEGER.
DEFINE SHARED VAR s-nomCia AS CHAR.
DEFINE  VAR X-MON  AS CHARACTER NO-UNDO.
DEFINE  VAR X-STAT AS CHARACTER NO-UNDO.
DEFINE  VAR F-FlgEst AS CHAR INITIAL 'P' NO-UNDO.
DEFINE  VAR S-DOCUMEN AS CHAR.
DEFINE VAR x-Dias AS INT.

DEF VAR s-task-no AS INT NO-UNDO.

DEF TEMP-TABLE T-REPORT LIKE W-REPORT.

DEFINE VARIABLE dImpLCred LIKE Gn-ClieL.ImpLC NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME x-Statbr_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES gn-clie
&Scoped-define FIRST-EXTERNAL-TABLE gn-clie


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-clie.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu FacDocum

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE x-Statbr_table                                */
&Scoped-define FIELDS-IN-QUERY-x-Statbr_table CcbCDocu.CodDoc ~
FacDocum.TpoDoc CcbCDocu.NroDoc CcbCDocu.FchDoc CcbCDocu.FchCbd ~
CcbCDocu.FchVto CcbCDocu.FchCan ~
f_DiasVto(ccbcdocu.coddoc, ccbcdocu.nrodoc, ccbcdocu.fchcan, ccbcdocu.fchvto,  ccbcdocu.flgest) @ x-Dias ~
f-Moneda(Ccbcdocu.codmon) @ X-MON CcbCDocu.ImpTot CcbCDocu.SdoAct ~
X-STAT @ X-STAT 
&Scoped-define ENABLED-FIELDS-IN-QUERY-x-Statbr_table 
&Scoped-define QUERY-STRING-x-Statbr_table FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = s-CodCia ~
  AND CcbCDocu.CodCli = gn-clie.CodCli ~
      AND CcbCDocu.CodCia = s-CodCia  ~
  AND (f-CodDoc = '' OR CcbCDocu.CodDoc = f-CodDoc) ~
  AND (f-FlgEst = '' OR CcbCDocu.FlgEst = f-FlgEst) ~
 AND ( x-FchDoc-1 = ? OR CcbCDocu.FchDoc >= x-FchDoc-1) ~
 AND ( x-FchDoc-2 = ? OR CcbCDocu.FchDoc <= x-FchDoc-2) NO-LOCK, ~
      FIRST FacDocum OF CcbCDocu ~
      WHERE FacDocum.TpoDoc = r-TpoDoc NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-x-Statbr_table OPEN QUERY x-Statbr_table FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = s-CodCia ~
  AND CcbCDocu.CodCli = gn-clie.CodCli ~
      AND CcbCDocu.CodCia = s-CodCia  ~
  AND (f-CodDoc = '' OR CcbCDocu.CodDoc = f-CodDoc) ~
  AND (f-FlgEst = '' OR CcbCDocu.FlgEst = f-FlgEst) ~
 AND ( x-FchDoc-1 = ? OR CcbCDocu.FchDoc >= x-FchDoc-1) ~
 AND ( x-FchDoc-2 = ? OR CcbCDocu.FchDoc <= x-FchDoc-2) NO-LOCK, ~
      FIRST FacDocum OF CcbCDocu ~
      WHERE FacDocum.TpoDoc = r-TpoDoc NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-x-Statbr_table CcbCDocu FacDocum
&Scoped-define FIRST-TABLE-IN-QUERY-x-Statbr_table CcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-x-Statbr_table FacDocum


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-59 RECT-11 RECT-9 RECT-60 ~
RECT-3 RECT-12 RECT-8 RECT-61 RECT-58 B-Imprimir BUTTON-2 b-Carta r-TpoDoc ~
b-Depositos BUTTON-8 F-Estado F-CodDoc BUTTON-1 BUTTON-9 x-FchDoc-1 ~
x-FchDoc-2 x-Statbr_table 
&Scoped-Define DISPLAYED-OBJECTS F-LinCre f-MonLC r-TpoDoc F-CreUsa ~
F-Estado F-CodDoc F-Credis x-FchDoc-1 x-FchDoc-2 FILL-IN-ImpTot-1 ~
FILL-IN-ImpTot-2 FILL-IN-SdoAct-1 FILL-IN-SdoAct-2 F-TVenSo F-TvenDo ~
F-TpoVSo F-TpoVDo F-TotSol F-TotDol F-TotS0 F-TotS15 F-TotS30 F-TotS45 ~
F-TotS60 F-TotD0 F-TotD15 F-TotD30 F-TotD45 F-TotD60 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-Moneda B-table-Win 
FUNCTION f-Moneda RETURNS CHARACTER
  ( INPUT pCodMon AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-Situacion B-table-Win 
FUNCTION f-Situacion RETURNS CHARACTER
  ( INPUT cFlgSit AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-Ubicacion B-table-Win 
FUNCTION f-Ubicacion RETURNS CHARACTER
  ( INPUT cFlgUbi AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSdoAct B-table-Win 
FUNCTION fSdoAct RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f_DiasVto B-table-Win 
FUNCTION f_DiasVto RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR,
  INPUT pNroDoc AS CHAR,
  INPUT pFchCan AS DATE,
  INPUT pFchVto AS DATE,
  INPUT pFlgEst AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON b-Carta 
     LABEL "Carta al cliente" 
     SIZE 15 BY .96.

DEFINE BUTTON b-Depositos 
     LABEL "Depósitos" 
     SIZE 15 BY .96.

DEFINE BUTTON B-Imprimir 
     IMAGE-UP FILE "img\print":U
     LABEL "Button 2" 
     SIZE 5.72 BY .96.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\auditor":U
     LABEL "Button 1" 
     SIZE 5.29 BY 1.46.

DEFINE BUTTON BUTTON-2 
     LABEL "Estado de Cuenta" 
     SIZE 15 BY .96.

DEFINE BUTTON BUTTON-8 
     LABEL "Pedidos Pendientes" 
     SIZE 15 BY .96.

DEFINE BUTTON BUTTON-9 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 9" 
     SIZE 5.72 BY 1.35.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(12)":U INITIAL "Pendiente" 
     LABEL "Condicion" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Pendiente","Cancelado","Anulado","Facturado","Por Aprobar","Castigado","Todos" 
     DROP-DOWN-LIST
     SIZE 12.72 BY 1 NO-UNDO.

DEFINE VARIABLE F-CodDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod.Documento" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .81 NO-UNDO.

DEFINE VARIABLE F-Credis AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Credito Dispon." 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .69
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE F-CreUsa AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Credito Usado" 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE F-LinCre AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Linea  Credito" 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-MonLC AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .69 NO-UNDO.

DEFINE VARIABLE F-TotD0 AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotD15 AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotD30 AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotD45 AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotD60 AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotDol AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "US$" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotS0 AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotS15 AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotS30 AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotS45 AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotS60 AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotSol AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TpoVDo AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "US$" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TpoVSo AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TvenDo AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "US$" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TVenSo AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot-1 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot-2 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "US$" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-SdoAct-1 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-SdoAct-2 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "US$" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE r-TpoDoc AS LOGICAL INITIAL yes 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cargo", yes,
"Abono", no
     SIZE 19.29 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 1.65.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.72 BY 2.23.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 103 BY 16.54.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 22.14 BY .96.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 32 BY .77
     BGCOLOR 1 .

DEFINE RECTANGLE RECT-59
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 32 BY .77
     BGCOLOR 1 .

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 1.15.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 1.15.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 1.65.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 1.69.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY x-Statbr_table FOR 
      CcbCDocu, 
      FacDocum SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE x-Statbr_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS x-Statbr_table B-table-Win _STRUCTURED
  QUERY x-Statbr_table NO-LOCK DISPLAY
      CcbCDocu.CodDoc COLUMN-LABEL "Doc." FORMAT "x(3)":U
      FacDocum.TpoDoc COLUMN-LABEL "Tipo Oper." FORMAT "Cargo/Abono":U
      CcbCDocu.NroDoc COLUMN-LABEL "Nro.!Documento  ." FORMAT "XXX-XXXXXXXXX":U
      CcbCDocu.FchDoc COLUMN-LABEL "Fecha de!Emision" FORMAT "99/99/99":U
      CcbCDocu.FchCbd COLUMN-LABEL "Fecha de!Recepción" FORMAT "99/99/9999":U
      CcbCDocu.FchVto COLUMN-LABEL "Fecha   !Vencimiento ." FORMAT "99/99/9999":U
      CcbCDocu.FchCan COLUMN-LABEL "Fecha de!Cancelacion" FORMAT "99/99/9999":U
      f_DiasVto(ccbcdocu.coddoc, ccbcdocu.nrodoc, ccbcdocu.fchcan, ccbcdocu.fchvto,  ccbcdocu.flgest) @ x-Dias COLUMN-LABEL "Dias" FORMAT "->>>>9":U
      f-Moneda(Ccbcdocu.codmon) @ X-MON COLUMN-LABEL "Mon" FORMAT "x(4)":U
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U
      CcbCDocu.SdoAct COLUMN-LABEL "Saldo Documento" FORMAT "->>,>>>,>>9.99":U
      X-STAT @ X-STAT COLUMN-LABEL "Estado" FORMAT "x(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 100 BY 6.58
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     B-Imprimir AT ROW 1.19 COL 59
     BUTTON-2 AT ROW 1.19 COL 66.86
     b-Carta AT ROW 1.19 COL 82
     F-LinCre AT ROW 1.31 COL 14.14 COLON-ALIGNED
     f-MonLC AT ROW 1.31 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     r-TpoDoc AT ROW 1.5 COL 37.29 NO-LABEL
     F-CreUsa AT ROW 2 COL 14.14 COLON-ALIGNED
     b-Depositos AT ROW 2.15 COL 66.86
     BUTTON-8 AT ROW 2.15 COL 82
     F-Estado AT ROW 2.54 COL 45.72
     F-CodDoc AT ROW 2.58 COL 28.14
     F-Credis AT ROW 2.65 COL 14.14 COLON-ALIGNED
     BUTTON-1 AT ROW 3.31 COL 85.29
     BUTTON-9 AT ROW 3.31 COL 91.29 WIDGET-ID 4
     x-FchDoc-1 AT ROW 3.62 COL 40.43 COLON-ALIGNED
     x-FchDoc-2 AT ROW 3.62 COL 58.43 COLON-ALIGNED
     x-Statbr_table AT ROW 4.85 COL 3
     FILL-IN-ImpTot-1 AT ROW 12.54 COL 32 COLON-ALIGNED
     FILL-IN-ImpTot-2 AT ROW 12.54 COL 48 COLON-ALIGNED
     FILL-IN-SdoAct-1 AT ROW 12.54 COL 64 COLON-ALIGNED
     FILL-IN-SdoAct-2 AT ROW 12.54 COL 80 COLON-ALIGNED
     F-TVenSo AT ROW 14.19 COL 8.43 COLON-ALIGNED
     F-TvenDo AT ROW 14.19 COL 23.14 COLON-ALIGNED
     F-TpoVSo AT ROW 14.19 COL 37.43 COLON-ALIGNED
     F-TpoVDo AT ROW 14.19 COL 52.14 COLON-ALIGNED
     F-TotSol AT ROW 14.19 COL 66.57 COLON-ALIGNED
     F-TotDol AT ROW 14.19 COL 81 COLON-ALIGNED
     F-TotS0 AT ROW 15.73 COL 24.57 COLON-ALIGNED NO-LABEL
     F-TotS15 AT ROW 15.73 COL 38.57 COLON-ALIGNED NO-LABEL
     F-TotS30 AT ROW 15.73 COL 52.57 COLON-ALIGNED NO-LABEL
     F-TotS45 AT ROW 15.73 COL 66.57 COLON-ALIGNED NO-LABEL
     F-TotS60 AT ROW 15.73 COL 80.57 COLON-ALIGNED NO-LABEL
     F-TotD0 AT ROW 16.46 COL 24.57 COLON-ALIGNED NO-LABEL
     F-TotD15 AT ROW 16.46 COL 38.57 COLON-ALIGNED NO-LABEL
     F-TotD30 AT ROW 16.46 COL 52.57 COLON-ALIGNED NO-LABEL
     F-TotD45 AT ROW 16.46 COL 66.57 COLON-ALIGNED NO-LABEL
     F-TotD60 AT ROW 16.46 COL 80.57 COLON-ALIGNED NO-LABEL
     "Total Pendiente" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 11.77 COL 71
          BGCOLOR 1 FGCOLOR 15 FONT 0
     "60 - + Dias" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 15.19 COL 82.72
          FONT 1
     "Total Vencidos" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 15.19 COL 8.72
          FONT 1
     "45-60 Dias" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 15.19 COL 68.72
          FONT 1
     "Soles" VIEW-AS TEXT
          SIZE 8 BY .69 AT ROW 15.69 COL 8.72
          FONT 1
     "Dolares" VIEW-AS TEXT
          SIZE 8 BY .69 AT ROW 16.42 COL 8.72
          FONT 1
     "Total Facturado" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 11.77 COL 38
          BGCOLOR 1 FGCOLOR 15 FONT 0
     "FILTRAR" VIEW-AS TEXT
          SIZE 7 BY .81 AT ROW 3.5 COL 77
          FONT 1
     "30-45 Dias" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 15.19 COL 54.72
          FONT 1
     "15-30 Dias" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 15.19 COL 40.72
          FONT 1
     "<<       Vencidos      >>" VIEW-AS TEXT
          SIZE 28.29 BY .5 AT ROW 13.62 COL 7.43
          BGCOLOR 1 FGCOLOR 15 FONT 0
     "<<     Total  Deuda   >>" VIEW-AS TEXT
          SIZE 28.29 BY .5 AT ROW 13.62 COL 65
          BGCOLOR 1 FGCOLOR 15 FONT 0
     "<<      x  Vencer     >>" VIEW-AS TEXT
          SIZE 28.29 BY .5 AT ROW 13.62 COL 36.29
          BGCOLOR 1 FGCOLOR 15 FONT 0
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "0 - 15 Dias" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 15.19 COL 26.72
          FONT 1
     RECT-10 AT ROW 13.5 COL 64.72
     RECT-59 AT ROW 11.58 COL 62
     RECT-11 AT ROW 15.12 COL 7
     RECT-9 AT ROW 13.5 COL 35.86
     RECT-60 AT ROW 12.35 COL 30
     RECT-3 AT ROW 1.38 COL 36
     RECT-12 AT ROW 1 COL 1
     RECT-8 AT ROW 13.5 COL 7
     RECT-61 AT ROW 12.35 COL 62
     RECT-58 AT ROW 11.58 COL 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.gn-clie
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
         HEIGHT             = 17
         WIDTH              = 105.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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
/* BROWSE-TAB x-Statbr_table x-FchDoc-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-CodDoc IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN F-Credis IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CreUsa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX F-Estado IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN F-LinCre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-MonLC IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotD0 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotD15 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotD30 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotD45 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotD60 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotDol IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotS0 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotS15 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotS30 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotS45 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotS60 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotSol IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TpoVDo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TpoVSo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TvenDo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TVenSo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-SdoAct-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-SdoAct-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE x-Statbr_table
/* Query rebuild information for BROWSE x-Statbr_table
     _TblList          = "INTEGRAL.CcbCDocu WHERE INTEGRAL.gn-clie ...,INTEGRAL.FacDocum OF INTEGRAL.CcbCDocu"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _JoinCode[1]      = "integral.CcbCDocu.CodCia = s-CodCia
  AND integral.CcbCDocu.CodCli = integral.gn-clie.CodCli"
     _Where[1]         = "CcbCDocu.CodCia = s-CodCia 
  AND (f-CodDoc = '' OR CcbCDocu.CodDoc = f-CodDoc)
  AND (f-FlgEst = '' OR CcbCDocu.FlgEst = f-FlgEst)
 AND ( x-FchDoc-1 = ? OR integral.CcbCDocu.FchDoc >= x-FchDoc-1)
 AND ( x-FchDoc-2 = ? OR integral.CcbCDocu.FchDoc <= x-FchDoc-2)"
     _Where[2]         = "integral.FacDocum.TpoDoc = r-TpoDoc"
     _FldNameList[1]   > integral.CcbCDocu.CodDoc
"CcbCDocu.CodDoc" "Doc." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.FacDocum.TpoDoc
"FacDocum.TpoDoc" "Tipo Oper." ? "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" "Nro.!Documento  ." "XXX-XXXXXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" "Fecha de!Emision" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.CcbCDocu.FchCbd
"CcbCDocu.FchCbd" "Fecha de!Recepción" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.CcbCDocu.FchVto
"CcbCDocu.FchVto" "Fecha   !Vencimiento ." ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.CcbCDocu.FchCan
"CcbCDocu.FchCan" "Fecha de!Cancelacion" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"f_DiasVto(ccbcdocu.coddoc, ccbcdocu.nrodoc, ccbcdocu.fchcan, ccbcdocu.fchvto,  ccbcdocu.flgest) @ x-Dias" "Dias" "->>>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"f-Moneda(Ccbcdocu.codmon) @ X-MON" "Mon" "x(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = integral.CcbCDocu.ImpTot
     _FldNameList[11]   > integral.CcbCDocu.SdoAct
"CcbCDocu.SdoAct" "Saldo Documento" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"X-STAT @ X-STAT" "Estado" "x(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE x-Statbr_table */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-Carta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-Carta B-table-Win
ON CHOOSE OF b-Carta IN FRAME F-Main /* Carta al cliente */
DO:
  RUN ccb/d-carta (ROWID(gn-clie)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-Depositos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-Depositos B-table-Win
ON CHOOSE OF b-Depositos IN FRAME F-Main /* Depósitos */
DO:
    IF NOT AVAILABLE gn-clie THEN RETURN NO-APPLY.
    RUN ccb/d-deposito-02 (ROWID(gn-clie)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Imprimir B-table-Win
ON CHOOSE OF B-Imprimir IN FRAME F-Main /* Button 2 */
DO:

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.   

    ASSIGN F-CodDoc r-TpoDoc.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.
        RUN Imprimir.
        PAGE .
        OUTPUT CLOSE.
    END.
    OUTPUT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN R-TpoDoc f-CodDoc .
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 B-table-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Estado de Cuenta */
DO:
  RUN ccb/d-estcta-02 (ROWID(gn-clie)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 B-table-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Pedidos Pendientes */
DO:
  s-CodCli = Gn-Clie.CodCli.
  RUN vta/d-pedcre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 B-table-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* Button 9 */
DO:
   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Excel.
   SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodDoc B-table-Win
ON LEAVE OF F-CodDoc IN FRAME F-Main /* Cod.Documento */
DO:
  ASSIGN R-TpoDoc f-CodDoc .
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Estado B-table-Win
ON LEAVE OF F-Estado IN FRAME F-Main /* Condicion */
DO:
  ASSIGN R-TpoDoc f-CodDoc .
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Estado B-table-Win
ON VALUE-CHANGED OF F-Estado IN FRAME F-Main /* Condicion */
DO:
  ASSIGN
     F-Estado.
  F-FlgEst = ENTRY(LOOKUP(F-Estado, F-Estado:LIST-ITEMS),"P,C,A,F,X,S,").
  /* Pendiente, Cancelado, Anulado, Facturado, Cerrado, Castigado, Todos */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME r-TpoDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-TpoDoc B-table-Win
ON LEAVE OF r-TpoDoc IN FRAME F-Main
DO:
  ASSIGN R-TpoDoc f-CodDoc .
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchDoc-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchDoc-1 B-table-Win
ON LEAVE OF x-FchDoc-1 IN FRAME F-Main /* Emitidos desde */
DO:
  IF x-FchDoc-1 <> INPUT x-FchDoc-1
  THEN DO:
    ASSIGN x-FchDoc-1.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchDoc-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchDoc-2 B-table-Win
ON LEAVE OF x-FchDoc-2 IN FRAME F-Main /* hasta */
DO:
  IF x-FchDoc-2 <> INPUT x-FchDoc-2
  THEN DO:
    ASSIGN x-FchDoc-2.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME x-Statbr_table
&Scoped-define SELF-NAME x-Statbr_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Statbr_table B-table-Win
ON LEFT-MOUSE-DBLCLICK OF x-Statbr_table IN FRAME F-Main
DO:
  /*RUN VTA\D-cmpbte.r(Ccbcdocu.NroDoc,CcbcDocu.CodDoc).*/
  RUN vta2/dcomprobantes (Ccbcdocu.NroDoc,CcbcDocu.CodDoc).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Statbr_table B-table-Win
ON ROW-ENTRY OF x-Statbr_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Statbr_table B-table-Win
ON ROW-LEAVE OF x-Statbr_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Statbr_table B-table-Win
ON VALUE-CHANGED OF x-Statbr_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
ON FIND OF Ccbcdocu 
DO:
/*   IF Ccbcdocu.CodMon = 1 THEN 
 *       ASSIGN X-Mon = "S/." .
 *    ELSE
 *          ASSIGN X-Mon = "US$" .*/
   CASE CcbCDocu.FlgEst:
        WHEN "P" THEN X-STAT = "Pendiente".      
        WHEN "C" THEN X-STAT = "Cancelado".
        WHEN "A" THEN X-STAT = "Anulado".
        WHEN "F" THEN X-STAT = "Facturado".
        WHEN "X" THEN X-STAT = "Por Aprobar".
        WHEN "E" THEN X-STAT = "Emitido".
        WHEN "S" THEN X-STAT = "Castigado".
        OTHERWISE X-STAT = ''.
   END.     
   IF CcbCDocu.CodDoc = "BD" THEN DO:
       CASE CcbCDocu.FlgEst:
           WHEN "E" THEN x-stat = "POR APROBAR".
           WHEN "P" THEN x-stat = "PENDIENTE".
           WHEN "A" THEN x-stat = "ANULADO".
           WHEN "C" THEN x-stat = "CANCELADO".
           WHEN "X" THEN x-stat = "CERRADO".
       END CASE.
   END.
END.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "gn-clie"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-clie"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-importes B-table-Win 
PROCEDURE Calcula-importes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR I-DIAS   AS INTEGER NO-UNDO.
DEFINE VAR w-cambio AS DEC NO-UNDO.
DEFINE FRAME F-Mensaje
    " Procesando informacion " SKIP
    " Espere un momento por favor..." SKIP
    WITH VIEW-AS DIALOG-BOX CENTERED OVERLAY WIDTH 40 TITLE 'Mensaje'.
    
ASSIGN F-TpoVDo = 0 
       F-TpoVSo = 0 
       F-TvenDo = 0 
       F-TVenSo = 0 
       F-TotD0  = 0 
       F-TotD15 = 0 
       F-TotD30 = 0 
       F-TotD45 = 0 
       F-TotD60 = 0 
       F-TotS0  = 0
       F-TotS15 = 0
       F-TotS30 = 0 
       F-TotS45 = 0
       F-TotS60 = 0
       FILL-IN-ImpTot-1 = 0
       FILL-IN-ImpTot-2 = 0
       FILL-IN-SdoAct-1 = 0
       FILL-IN-SdoAct-2 = 0.
     
FIND FIRST FacCfgGn NO-LOCK NO-ERROR.
      IF AVAILABLE FacCfgGn THEN 
            w-cambio = FacCfgGn.Tpocmb[1].
      ELSE  w-cambio = 0.     

VIEW FRAME F-Mensaje.
FOR EACH CcbCDocu USE-INDEX Llave06 NO-LOCK WHERE CcbCDocu.CodCia = s-CodCia
    AND CcbCDocu.CodCli = gn-clie.CodCli
    AND (f-FlgEst = "" OR CcbCDocu.FlgEst = f-FlgEst)
    AND (f-CodDoc = "" OR CcbCDocu.CodDoc = f-CodDoc)
    AND (x-FchDoc-1 = ? OR CcbCDocu.FchDoc >= x-FchDoc-1)
    AND (x-FchDoc-2 = ? OR CcbCDocu.FchDoc <= x-FchDoc-2),
    FIRST FacDocum OF CcbCDocu WHERE FacDocum.TpoDoc = r-TpoDoc NO-LOCK:
    CASE CcbCDocu.CodMon :           
         WHEN 1 THEN DO :
            IF LOOKUP(ccbcdocu.flgest, 'A,X') = 0
            THEN ASSIGN
                    FILL-IN-ImpTot-1 = FILL-IN-ImpTot-1 + ccbcdocu.imptot
                    FILL-IN-SdoAct-1 = FILL-IN-SdoAct-1 + ccbcdocu.sdoact.                
                /* por vencer */
                IF CcbCDocu.FchVto >= TODAY THEN F-TpoVSo = F-TpoVSo + CcbCDocu.SdoAct.
                /* Vencido */
                IF CcbCDocu.FchVto < TODAY THEN DO:
                   F-TVenSo = F-TVenSo + CcbCDocu.SdoAct. 
                   I-DIAS = TODAY - CcbCDocu.FchVto.
                   CASE (I-DIAS > 0):
                        WHEN YES AND I-DIAS <= 15 THEN 
                             F-TotS0  = F-TotS0 + CcbCDocu.SdoAct.
                        WHEN YES AND I-DIAS > 15 AND I-DIAS <= 30 THEN 
                             F-TotS15  = F-TotS15 + CcbCDocu.SdoAct.
                        WHEN YES AND I-DIAS > 30 AND I-DIAS <= 45 THEN 
                             F-TotS30  = F-TotS30 + CcbCDocu.SdoAct.
                        WHEN YES AND I-DIAS > 45 AND I-DIAS <= 60 THEN 
                             F-TotS45  = F-TotS45 + CcbCDocu.SdoAct.
                        WHEN YES AND I-DIAS > 60 THEN 
                             F-TotS60  = F-TotS60 + CcbCDocu.SdoAct.
                   END CASE.
                END.
           END.     
         WHEN 2 THEN DO :
            IF LOOKUP(ccbcdocu.flgest, 'A,X') = 0   /* Anulado Castigado */
            THEN ASSIGN
                    FILL-IN-ImpTot-2 = FILL-IN-ImpTot-2 + ccbcdocu.imptot
                    FILL-IN-SdoAct-2 = FILL-IN-SdoAct-2 + ccbcdocu.sdoact.                
                /* por vencer */
                IF CcbCDocu.FchVto >= TODAY THEN F-TpoVDo = F-TpoVDo + CcbCDocu.SdoAct.
                /* Vencido */
                IF CcbCDocu.FchVto < TODAY THEN DO:
                   F-TVenDo = F-TVenDo + CcbCDocu.SdoAct.   
                   I-DIAS = TODAY - CcbCDocu.FchVto.
                   CASE (I-DIAS > 0):
                        WHEN YES AND I-DIAS <= 15 THEN 
                             F-TotD0  = F-TotD0 + CcbCDocu.SdoAct.
                        WHEN YES AND I-DIAS > 15 AND I-DIAS <= 30 THEN 
                             F-TotD15  = F-TotD15 + CcbCDocu.SdoAct.
                        WHEN YES AND I-DIAS > 30 AND I-DIAS <= 45 THEN 
                             F-TotD30  = F-TotD30 + CcbCDocu.SdoAct.
                        WHEN YES AND I-DIAS > 45 AND I-DIAS <= 60 THEN 
                             F-TotD45  = F-TotD45 + CcbCDocu.SdoAct.
                        WHEN YES AND I-DIAS > 60 THEN 
                             F-TotD60  = F-TotD60 + CcbCDocu.SdoAct.
                   END CASE.
                END.
           END.
    END CASE .
END.
HIDE FRAME F-Mensaje.

/*CASE gn-clie.MonLC:  
 *      WHEN 1 THEN 
 *           F-CreUsa = ( F-TotDol * w-cambio ) + F-TotSol.
 *      WHEN 2 THEN 
 *           F-CreUsa = ( F-TotSol / w-cambio ) + F-TotDol.
 *      WHEN 0 THEN 
 *           F-CreUsa = ( F-TotSol / w-cambio ) + F-TotDol.
 * END CASE.           
 * 
 * F-CreDis = gn-clie.ImpLC - F-CreUsa.
 * F-LinCre = gn-clie.ImpLC.  */
DISPLAY F-TpoVDo F-TpoVSo F-TvenDo F-TVenSo F-TotDol F-TotSol F-TotD0  
        F-TotD15 F-TotD30 F-TotD45 F-TotD60 F-TotS0  F-TotS15 F-TotS30 
        F-TotS45 F-TotS60 /*F-CreUsa F-CreDis F-LinCre */
        FILL-IN-ImpTot-1 
        FILL-IN-ImpTot-2 
        FILL-IN-SdoAct-1 
        FILL-IN-SdoAct-2
        WITH FRAME {&FRAME-NAME}.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Linea-Credito B-table-Win 
PROCEDURE Calcula-Linea-Credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR w-cambio AS DEC NO-UNDO.
DEFINE VAR x-Signo  AS INT NO-UNDO.
DEFINE FRAME F-Mensaje
    " Procesando informacion " SKIP
    " Espere un momento por favor..." SKIP
    WITH VIEW-AS DIALOG-BOX CENTERED OVERLAY WIDTH 40 TITLE 'Mensaje'.
    
ASSIGN 
       F-TotDol = 0 
       F-TotSol = 0.
     
FIND FIRST FacCfgGn NO-LOCK NO-ERROR.
      IF AVAILABLE FacCfgGn THEN 
            w-cambio = FacCfgGn.Tpocmb[1].
      ELSE  w-cambio = 0.     

VIEW FRAME F-Mensaje.
FOR EACH CcbCDocu NO-LOCK WHERE CcbCDocu.CodCia = s-CodCia
        AND CcbCDocu.CodCli = gn-clie.CodCli
        AND CcbCDocu.FlgEst = 'P'
        AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,LET,CHQ,N/D,N/C,A/R,BD,A/C') > 0,
    FIRST FacDocum OF CcbCDocu NO-LOCK WHERE FacDocum.TpoDoc <> ?:
    /* DOCUMENTOS QUE NO DEBEN APARECER EN LA LINEA DE CREDITO */
    IF LOOKUP(Ccbcdocu.coddoc, 'A/R,BD,A/C') > 0 THEN NEXT.
    /* ******************************************************* */
    /* RHC 23.11.08 LETRAS ADELANTADAS */
/*     IF Ccbcdocu.coddoc = 'LET' AND Ccbcdocu.codref = 'CLA' THEN NEXT. */
    
    x-Signo = IF FacDocum.TpoDoc = YES THEN 1 ELSE -1.
    CASE CcbCDocu.CodMon :           
         WHEN 1 THEN DO :
                F-TotSol = F-TotSol + CcbCDocu.SdoAct * x-Signo.
           END.     
         WHEN 2 THEN DO :
                F-TotDol = F-TotDol + CcbCDocu.SdoAct * x-Signo.
           END.
    END CASE .
END.
/* POR PEDIDOS PENDIENTES DE ATENCION */
FOR EACH FacCPedi NO-LOCK WHERE FacCPedi.CodCia = S-CODCIA 
    AND FacCPedi.CodDoc = "PED" 
    AND FacCPedi.CodCli = gn-clie.CodCli 
    AND LOOKUP(FacCPedi.FlgEst, "G,X,P,W,WX,WL") > 0:
    FIND FIRST gn-convt WHERE gn-convt.codig = Faccpedi.FmaPgo NO-LOCK.
    IF gn-convt.tipvta = "1" THEN NEXT.     /* NO CONTADOS */
/*     AND LOOKUP(TRIM(Faccpedi.fmapgo), '001,002') = 0:   /* NO contraentrega ni anticipado */ */
    IF Faccpedi.codmon = 1
    THEN F-TotSol = F-TotSol + fSdoAct().
    ELSE F-TotDol = F-TotDol + fSdoAct().
END.
/* ********************************** */
/* POR ORDENES DE DESPACHO DE ATENCION */
FOR EACH FacCPedi NO-LOCK WHERE FacCPedi.CodCia = S-CODCIA 
    AND FacCPedi.CodDoc = "O/D" 
    AND FacCPedi.CodCli = gn-clie.CodCli 
    AND FacCPedi.FlgEst = "P":
    FIND FIRST gn-convt WHERE gn-convt.codig = Faccpedi.FmaPgo NO-LOCK.
    IF gn-convt.tipvta = "1" THEN NEXT.     /* NO CONTADOS */
/*     AND LOOKUP(TRIM(Faccpedi.fmapgo), '001,002') = 0:   /* NO contraentrega ni anticipado */ */
    IF Faccpedi.codmon = 1
    THEN F-TotSol = F-TotSol + fSdoAct().
    ELSE F-TotDol = F-TotDol + fSdoAct().
END.
/* ********************************** */

HIDE FRAME F-Mensaje.

DEF VAR dMonLC AS INT.

RUN ccb/p-implc (gn-clie.codcia, gn-clie.codcli, OUTPUT dMonLC, OUTPUT dImpLCred).

CASE dMonLC:  
     WHEN 1 THEN 
          F-CreUsa = ( F-TotDol * w-cambio ) + F-TotSol.
     WHEN 2 THEN 
          F-CreUsa = ( F-TotSol / w-cambio ) + F-TotDol.
     WHEN 0 THEN 
          F-CreUsa = ( F-TotSol / w-cambio ) + F-TotDol.
END CASE.           

F-CreDis = dImpLCred - F-CreUsa.
F-LinCre = dImpLCred.  
f-MonLC = IF dMonLc = 1 THEN 'S/.' ELSE IF dMonLC = 2 THEN 'US$' ELSE ''.
DISPLAY F-CreUsa F-CreDis F-LinCre f-MonLC WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
ASSIGN
    chWorkSheet:Range("A1"):Value = CAPS(s-nomcia) + " - CONSULTA DE CUENTAS CORRIENTES"
    chWorkSheet:Range("A2"):Value = gn-clie.codcli + " " + gn-clie.nomcli
    chWorkSheet:Range("A3"):Value = "Doc."
    chWorkSheet:Range("B3"):Value = "Tipo Oper."
    chWorkSheet:Range("C3"):Value = "Nro. Documento"
    chWorkSheet:Columns("C"):NumberFormat = "@"
    chWorkSheet:Range("D3"):Value = "Fecha de Emisión"
    chWorkSheet:Columns("D"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Range("E3"):Value = "Fecha de Recepción"
    chWorkSheet:Columns("E"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Range("F3"):Value = "Fecha Vencimiento"
    chWorkSheet:Columns("F"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Columns("D"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Range("G3"):Value = "Fecha de Cancelación"
    chWorkSheet:Columns("G"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Range("H3"):Value = "Días"
    chWorkSheet:Range("I3"):Value = "Mon"
    chWorkSheet:Range("J3"):Value = "Importe Total"
    chWorkSheet:Range("K3"):Value = "Saldo Documento"
    chWorkSheet:Range("L3"):Value = "Estado"
    chWorkSheet:Range("M3"):Value = "# Unico"
    chWorkSheet:Range("N3"):Value = "Ubicación"
    chWorkSheet:Range("O3"):Value = "Situación"
    .


ASSIGN
    t-Row = 3.
GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE Ccbcdocu:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.CodDoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF FacDocum.TpoDoc THEN 'Cargo' ELSE 'Abono').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.NroDoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchDoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchCbd.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchVto.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchCan.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = f_DiasVto(ccbcdocu.coddoc, ccbcdocu.nrodoc, ccbcdocu.fchcan, ccbcdocu.fchvto,  ccbcdocu.flgest).
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = f-Moneda(Ccbcdocu.codmon).
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.ImpTot.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.SdoAct.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = x-Stat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF Ccbcdocu.coddoc = 'LET' THEN Ccbcdocu.nrosal ELSE '').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF Ccbcdocu.coddoc = 'LET' THEN f-Ubicacion(Ccbcdocu.flgubi) ELSE '').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF Ccbcdocu.coddoc = 'LET' THEN f-Situacion(Ccbcdocu.flgsit) ELSE '').
    GET NEXT {&browse-name}.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir B-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-tpodoc AS CHAR NO-UNDO.
DEFINE VAR x-moneda AS CHAR NO-UNDO.
DEFINE VAR x-codmon AS CHAR NO-UNDO.
DEFINE VAR x-clfcli AS CHAR NO-UNDO.
DEFINE VAR i-nroitm AS INTE NO-UNDO.
DEFINE VAR x-flgest AS CHAR NO-UNDO.
DEFINE VAR x-glosa  AS CHAR NO-UNDO.
DEFINE VAR x-impor1 AS DECI NO-UNDO.
DEFINE VAR x-impor2 AS DECI NO-UNDO.
DEFINE VAR x-impor3 AS DECI NO-UNDO.
DEFINE VAR x-impor4 AS DECI NO-UNDO.
DEFINE VAR x-impor5 AS DECI NO-UNDO.
DEFINE VAR F-IMPORTE AS DECIMAL EXTENT 2 NO-UNDO.

IF gn-clie.MonLC = 1 THEN x-Moneda = "S/.".
ELSE x-Moneda = "US$".

IF r-tpodoc = Yes THEN
   x-tpodoc = 'CARGO'.
ELSE 
   x-tpodoc = 'ABONO'.

/* Línea Crédito Campaña */
dImpLCred = 0.
lEnCampan = FALSE.
FOR EACH Gn-ClieL WHERE
    Gn-ClieL.CodCia = gn-clie.codcia AND
    Gn-ClieL.CodCli = gn-clie.codcli AND
    Gn-ClieL.FchIni >= TODAY AND
    Gn-ClieL.FchFin <= TODAY NO-LOCK:
    dImpLCred = dImpLCred + Gn-ClieL.ImpLC.
    lEnCampan = TRUE.
END.
/* Línea Crédito Normal */
IF NOT lEnCampan THEN dImpLCred = gn-clie.ImpLC.

DEFINE FRAME F-HdrConsulta
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" 
    "Fecha  : " AT 90 TODAY SKIP(1)
    {&PRN6A} + "ESTADO DE CUENTA CORRIENTE POR CLIENTE" + {&PRN6B} + {&PRND} AT 45 FORMAT "X(45)" SKIP(1)
    "Cliente       : " gn-clie.codcli SPACE(2) gn-clie.nomcli FORMAT "x(40)" 
    "Vcto.Linea    : " AT 75 gn-clie.FchVlc AT 95 SKIP
    "Direccion     : " gn-clie.dircli FORMAT "x(50)"  SKIP
    "R.U.C.        : " gn-clie.ruc FORMAT "x(50)" {&PRN6A} + "Clasificacion : " AT 75 FORMAT "X(18)" x-clfcli + {&PRN6B} + {&PRND} FORMAT "X(25)" AT 95 SKIP(1)
    {&PRN6A} + "   Moneda          : " AT 1 FORMAT "X(22)" x-moneda + {&PRN6B} + {&PRND} FORMAT "X(15)" SKIP
    {&PRN6A} + "  Linea de Credito : " AT 1 FORMAT "X(22)" STRING(dImpLCred,"->,>>>,>>9.99") + {&PRN6B} + {&PRND} FORMAT "X(15)" SKIP  
    {&PRN6A} + "     Credito Usado : " AT 1 FORMAT "X(22)" STRING(F-CreUsa,"->,>>>,>>9.99") + {&PRN6B} + {&PRND} FORMAT "X(15)" 
    "Tipo Documento: " AT 50 x-TpoDoc FORMAT "x(10)" SKIP
    {&PRN6A} + "Credito Disponible : " AT 1 FORMAT "X(22)" STRING(F-Credis,"->,>>>,>>9.99") + {&PRN6B} + {&PRND} FORMAT "X(15)" 
    "Cod.Documento : " AT 50 F-CodDoc FORMAT "X(10)" "Condicion     : " AT 82 F-FlgEst FORMAT "X(10)" SKIP    
    "---------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "                                    FECHA DE    FECHA DE     FECHA DE                   IMPORTE                                              " SKIP
    "ITEM DOC. TIPO  DIVISION   NUMERO    EMISION   VENCIMIENTO   CANCELACION DIAS MON.      T O T A L    SALDO  S/.     SALDO US$.  ESTADO UBIC. " SKIP
    "---------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 210. 
  
DEFINE FRAME F-DetaCon
    I-NroItm       AT 1   FORMAT ">>9" 
    B-DOCU.coddoc  AT 6   FORMAT "X(3)"
    X-TPODOC       AT 11  FORMAT "X(5)"
    B-DOCU.coddiv  AT 18  FORMAT "XX-XXX"
    B-DOCU.nrodoc  AT 26  FORMAT "X(9)"
    B-DOCU.fchdoc  AT 37   
    B-DOCU.fchvto  AT 49
    B-DOCU.fchcan  AT 62
    x-dias         AT 73  FORMAT "->>9"
    X-CODMON       AT 80  FORMAT "X(4)" 
    B-DOCU.ImpTot  AT 84  FORMAT ">>>>,>>9.99" 
    F-IMPORTE[1]   AT 99  FORMAT "(>>>>,>>9.99)" 
    F-IMPORTE[2]   AT 115 FORMAT "(>>>>,>>9.99)" 
    X-FLGEST       AT 129 FORMAT "X(4)"
    B-DOCU.FlgUbi  AT 135 FORMAT "X(5)"
    /*B-DOCU.FlgSit  AT 139 FORMAT "X(5)"*/
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 210 STREAM-IO DOWN. 

DEFINE FRAME F-FdrConsulta
    HEADER
    SPACE(1) SKIP
    SPACE(3) '! TOTAL FACTURADO S/ ! TOTAL FACTURADO U$ ! TOTAL PENDIENTE S/ ! TOTAL PENDIENTE U$ !' SKIP
    SPACE(3) '!' 
            FILL-IN-ImpTot-1 FORMAT '->>>>,>>9.99' '      !'
            FILL-IN-ImpTot-2 FORMAT '->>>>,>>9.99' '      !'
            FILL-IN-SdoAct-1 FORMAT '->>>>,>>9.99' '      !'
            FILL-IN-SdoAct-2 FORMAT '->>>>,>>9.99' '      !' SKIP(1)
    SPACE(3) '!  TOTAL VENCIDOS    !    0-15 Dias !   15-30 Dias !   30-45 Dias !   45-60 Dias !   60- + Dias !' SKIP
    SPACE(3) FILL('-',97) FORMAT 'X(97)' SKIP
    SPACE(3) '!     SOLES          !' 
        F-TotS0  FORMAT '->>>>,>>9.99' '!'
        F-TotS15 FORMAT '->>>>,>>9.99' '!'
        F-TotS30 FORMAT '->>>>,>>9.99' '!'
        F-TotS45 FORMAT '->>>>,>>9.99' '!'
        F-TotS60 FORMAT '->>>>,>>9.99' 
        '!' AT 100 SKIP
    SPACE(3) '!    DOLARES         !' 
        F-TotD0  FORMAT '->>>>,>>9.99' '!'
        F-TotD15 FORMAT '->>>>,>>9.99' '!'
        F-TotD30 FORMAT '->>>>,>>9.99' '!'
        F-TotD45 FORMAT '->>>>,>>9.99' '!'
        F-TotD60 FORMAT '->>>>,>>9.99' 
        '!' AT 100 SKIP        
    SPACE(3) FILL('-',97) FORMAT 'X(97)' SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 200. 

/*ML3* 17/11/07 ***
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.
* ***/

I-NroItm = 0.
FOR EACH B-Docu WHERE B-Docu.CodCia = s-CodCia 
    AND B-Docu.codcli = Gn-clie.codcli 
    AND B-Docu.CodDoc BEGINS f-CodDoc 
    AND B-Docu.FlgEst BEGINS f-FlgEst 
    AND (x-FchDoc-1 = ? OR B-Docu.FchDoc >= x-FchDoc-1)
    AND (x-FchDoc-2 = ? OR B-Docu.FchDoc <= x-FchDoc-2) NO-LOCK,
    FIRST FacDocum OF B-DOCU
          WHERE FacDocum.TpoDoc = r-TpoDoc NO-LOCK 
          BREAK BY B-Docu.CodCia
                BY B-Docu.CodDoc
                BY B-Docu.FchVto :
    VIEW FRAME F-HdrConsulta.
    VIEW FRAME F-FdrConsulta.
    IF FIRST-OF(B-Docu.CodDoc) THEN DO:
       DISPLAY 
       {&PRN6A} + CAPS(FacDocum.NomDoc) + {&PRN6B} + {&PRND} AT 5 FORMAT "X(50)" 
       {&PRN6B} + {&PRN3} + " " SKIP(1) .
    END.
    IF B-DOCU.CodMon = 1 THEN
       ASSIGN x-CODMON = "S/."
       F-IMPORTE[1] = B-DOCU.SdoAct * (IF Facdocum.tpodoc THEN  1 ELSE -1)
       F-IMPORTE[2] = 0.
    ELSE 
       ASSIGN x-CODMON = "US$"
       F-IMPORTE[2] = B-DOCU.SdoAct * (IF Facdocum.tpodoc THEN  1 ELSE -1)
       F-IMPORTE[1] = 0.
    CASE B-DOCU.Flgest:
         WHEN 'P' THEN x-flgest = 'PEND'.
         WHEN 'C' THEN x-flgest = 'CANC'.
         WHEN 'A' THEN x-flgest = 'ANUL'.
         WHEN 'F' THEN x-flgest = 'FACT'.
         WHEN 'X' THEN x-flgest = 'CAST'.
         WHEN 'E' THEN x-flgest = 'EMIT'.
         OTHERWISE x-flgest = ''.
    END CASE.  
    I-NroItm = I-NroItm + 1.
    DISPLAY
         I-NroItm 
         B-Docu.coddoc
         x-tpodoc 
         B-Docu.coddiv
         B-Docu.nrodoc
         B-Docu.fchdoc
         B-Docu.FchVto
         B-DOCU.fchcan 
         f_DiasVto(B-Docu.coddoc, B-Docu.nrodoc, B-Docu.fchcan, B-Docu.fchvto, B-Docu.flgest)@ x-Dias
         x-CODMON
         B-Docu.ImpTot 
         F-IMPORTE[1] WHEN F-IMPORTE[1] <> 0
         F-IMPORTE[2] WHEN F-IMPORTE[2] <> 0
         x-FlgEst 
         B-Docu.FlgUbi 
         WITH FRAME F-DetaCon.
         ACCUMULATE F-IMPORTE[1]  (TOTAL BY B-Docu.codcia).
         ACCUMULATE F-IMPORTE[2]  (TOTAL BY B-Docu.codcia).
         ACCUMULATE B-DOCU.imptot (SUB-TOTAL BY B-Docu.CodDoc).
         ACCUMULATE F-IMPORTE[1]  (SUB-TOTAL BY B-Docu.CodDoc).
         ACCUMULATE F-IMPORTE[2]  (SUB-TOTAL BY B-Docu.CodDoc).
         IF LAST-OF(B-Docu.CodDoc) THEN DO:
            UNDERLINE     
                      F-IMPORTE[1]
                      F-IMPORTE[2] WITH FRAME F-Detacon.
            DISPLAY 
                "  TOTAL >>"   @ B-Docu.FchVto
                ACCUM SUB-TOTAL BY (B-Docu.CodDoc) F-IMPORTE[1] @ F-IMPORTE[1]
                ACCUM SUB-TOTAL BY (B-Docu.CodDoc) F-IMPORTE[2] @ F-IMPORTE[2]
                WITH FRAME F-Detacon. 
            DOWN WITH FRAME F-Detacon.
            I-NroItm = 0.
         END.
       
         IF LAST-OF(B-Docu.codcia) THEN DO:
            UNDERLINE    
                      F-IMPORTE[1]
                      F-IMPORTE[2] WITH FRAME F-Detacon.
            DISPLAY 
                "    TOTAL "     @ B-DOCU.FchDoc
                "GENERAL >>"     @ B-DOCU.FchVto
                ACCUM TOTAL BY (B-Docu.codcia) F-IMPORTE[1] @ F-IMPORTE[1]
                ACCUM TOTAL BY (B-Docu.codcia) F-IMPORTE[2] @ F-IMPORTE[2]
                WITH FRAME F-Detacon.
            DOWN WITH FRAME F-Detacon.
            PAGE.
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
  RUN Calcula-Importes.
  RUN Calcula-Linea-Credito.

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
         WHEN "" THEN DO :
             Input-var-1 = "".
        END.     
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
        WHEN "f-CodDoc" THEN DO :
             Input-var-1 = IF r-TpoDoc = yes THEN "CARGO" ELSE "".
        END.
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
  {src/adm/template/snd-list.i "gn-clie"}
  {src/adm/template/snd-list.i "CcbCDocu"}
  {src/adm/template/snd-list.i "FacDocum"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-Moneda B-table-Win 
FUNCTION f-Moneda RETURNS CHARACTER
  ( INPUT pCodMon AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE pCodMon:
    WHEN 1 THEN RETURN 'S/.'.
    WHEN 2 THEN RETURN 'US$'.
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-Situacion B-table-Win 
FUNCTION f-Situacion RETURNS CHARACTER
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-Ubicacion B-table-Win 
FUNCTION f-Ubicacion RETURNS CHARACTER
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSdoAct B-table-Win 
FUNCTION fSdoAct RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR f-Total  AS DEC NO-UNDO.
DEF VAR x-ImpLin AS DEC NO-UNDO.

    f-Total = 0.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK:
        x-ImpLin = (FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.ImpLin / FacDPedi.CanPed.
        IF x-ImpLin > 0 THEN f-Total = f-Total + x-ImpLin.
    END.             
    RETURN f-Total.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f_DiasVto B-table-Win 
FUNCTION f_DiasVto RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR,
  INPUT pNroDoc AS CHAR,
  INPUT pFchCan AS DATE,
  INPUT pFchVto AS DATE,
  INPUT pFlgEst AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  ccbdcaja.fchdoc
------------------------------------------------------------------------------*/
/*  IF pfchcan = ? THEN RETURN (today - pfchvto).
 *   IF pfchcan <> ? THEN RETURN (pfchcan - pfchvto).
 * 
 *   DEF VAR x-Dias AS INT INIT 0.
 *   
 *   IF pflgest = 'C' or pflgest = 'P' THEN RETURN x-Dias.
 *   FOR EACH ccbdcaja WHERE ccbdcaja.codcia = s-codcia
 *         AND ccbdcaja.codref = pcoddoc
 *         AND ccbdcaja.nroref = pnrodoc BY ccbdcaja.fchdoc:
 *     
 *     x-Dias = ccbcdocu.fchvto - ccbdcaja.fchdoc.
 *   END.        
 *   RETURN x-Dias.*/
  
  /* RHC 06.01.06 */
  IF pFlgEst <> 'C' THEN RETURN 0.
  IF pFchCan <> ? THEN RETURN (pFchCan - pFchVto).
  DEF VAR x-Dias AS INT INIT 0.
  FOR EACH Ccbdcaja NO-LOCK WHERE Ccbdcaja.codcia = s-codcia
        AND Ccbdcaja.codref = pCodDoc
        AND Ccbdcaja.nroref = pNroDoc BY Ccbdcaja.fchdoc:
    x-Dias = Ccbdcaja.fchdoc - pfchvto.
  END.
  RETURN x-Dias.
          
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

