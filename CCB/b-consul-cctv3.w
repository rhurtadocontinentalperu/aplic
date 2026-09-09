&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR CcbCDocu.



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
DEFINE  VAR F-FlgEst AS CHAR INITIAL 'P|J' NO-UNDO.
DEFINE  VAR S-DOCUMEN AS CHAR.
DEFINE VAR x-Dias AS INT.

/* Ic 17Abr2015 */
DEFINE VAR x-sit AS CHAR.
DEFINE VAR x-ubi AS CHAR.
DEFINE VAR x-cta AS CHAR.  /* banco */
DEFINE VAR x-codunico AS CHAR.
DEFINE VAR x-nrocanje AS CHAR.
/* Ic 17Abr2015 */

DEF VAR s-task-no AS INT NO-UNDO.

DEF TEMP-TABLE T-REPORT LIKE W-REPORT.

DEFINE VARIABLE dImpLCred LIKE Gn-ClieL.ImpLC NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

DEF VAR x-ImpTot AS DEC NO-UNDO.
DEF VAR x-SdoAct AS DEC NO-UNDO.

&SCOPED-DEFINE Condicion (f-CodDoc = '' OR CcbCDocu.CodDoc = f-CodDoc) ~
AND (f-FlgEst = '' OR LOOKUP(CcbCDocu.FlgEst, f-FlgEst, '|') > 0) ~
AND ( x-FchDoc-1 = ? OR integral.CcbCDocu.FchDoc >= x-FchDoc-1) ~
AND ( x-FchDoc-2 = ? OR integral.CcbCDocu.FchDoc <= x-FchDoc-2)

/* Ic - 27Ene2016, sra. gina condor a veces no aparece la referencia G/R */
DEFINE VAR x-tipo-doc AS CHAR.
DEFINE VAR x-nro-doc AS CHAR.
DEFINE VAR x-nro-gr AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
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
&Scoped-define FIELDS-IN-QUERY-x-Statbr_table fEstado() @ X-STAT ~
CcbCDocu.DivOri CcbCDocu.FchDoc CcbCDocu.CodDoc CcbCDocu.NroDoc ~
f-get-guiaremision(ccbcdocu.coddiv,ccbcdocu.coddoc,ccbcdocu.nrodoc) @ x-nro-doc ~
CcbCDocu.FchCbd CcbCDocu.FchVto CcbCDocu.FchCan CcbCDocu.FchUbi ~
f_DiasVto(ccbcdocu.coddoc, ccbcdocu.nrodoc, ccbcdocu.fchcan, ccbcdocu.fchvto,  ccbcdocu.flgest) @ x-Dias ~
f-Moneda(Ccbcdocu.codmon) @ X-MON ~
(IF FacDocum.TpoDoc = YES THEN 1 ELSE -1) * CcbCDocu.ImpTot @ x-ImpTot ~
(IF FacDocum.TpoDoc = YES THEN 1 ELSE -1) * CcbCDocu.SdoAct @ x-SdoAct ~
CcbCDocu.FmaPgo f-situacion(Ccbcdocu.flgsit) @ x-sit ~
f-ubicacion(Ccbcdocu.flgubi) @ x-ubi CcbCDocu.NroSal CcbCDocu.CodCta ~
f-canje(Ccbcdocu.coddoc, Ccbcdocu.nrodoc) @ x-nrocanje 
&Scoped-define ENABLED-FIELDS-IN-QUERY-x-Statbr_table 
&Scoped-define QUERY-STRING-x-Statbr_table FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = s-CodCia ~
  AND CcbCDocu.CodCli = gn-clie.CodCli ~
      AND {&Condicion} NO-LOCK, ~
      FIRST FacDocum OF CcbCDocu ~
      WHERE ( ( r-TpoDoc = ? AND FacDocum.TpoDoc <> ? ) ~
 OR (r-TpoDoc <> ? AND FacDocum.TpoDoc = r-TpoDoc) ) NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-x-Statbr_table OPEN QUERY x-Statbr_table FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = s-CodCia ~
  AND CcbCDocu.CodCli = gn-clie.CodCli ~
      AND {&Condicion} NO-LOCK, ~
      FIRST FacDocum OF CcbCDocu ~
      WHERE ( ( r-TpoDoc = ? AND FacDocum.TpoDoc <> ? ) ~
 OR (r-TpoDoc <> ? AND FacDocum.TpoDoc = r-TpoDoc) ) NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-x-Statbr_table CcbCDocu FacDocum
&Scoped-define FIRST-TABLE-IN-QUERY-x-Statbr_table CcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-x-Statbr_table FacDocum


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-59 RECT-11 RECT-9 RECT-60 ~
RECT-8 RECT-61 RECT-58 RECT-66 F-Estado r-TpoDoc F-CodDoc x-FchDoc-1 ~
x-FchDoc-2 x-Statbr_table b-Carta BUTTON-8 BUTTON-2 b-Depositos BUTTON-9 ~
B-Imprimir 
&Scoped-Define DISPLAYED-OBJECTS F-Estado r-TpoDoc F-CodDoc x-FchDoc-1 ~
x-FchDoc-2 FILL-IN-ImpTot-1 FILL-IN-ImpTot-2 FILL-IN-SdoAct-1 ~
FILL-IN-SdoAct-2 F-TVenSo F-TvenDo F-TpoVSo F-TpoVDo F-TotSol F-TotDol ~
F-TotS0 F-TotS15 F-TotS30 F-TotS45 F-TotS60 F-TotD0 F-TotD15 F-TotD30 ~
F-TotD45 F-TotD60 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-canje B-table-Win 
FUNCTION f-canje RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-get-guiaremision B-table-Win 
FUNCTION f-get-guiaremision RETURNS CHARACTER
  ( INPUT pCodDiv AS CHAR, INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(20)":U INITIAL "Pendiente" 
     LABEL "Condicion" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Pendiente","Cancelado","Anulado","Facturado","Por Aprobar","Castigado","Cobranza Dudosa","Todos" 
     DROP-DOWN-LIST
     SIZE 19 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-CodDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod.Documento" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .81 NO-UNDO.

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
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE r-TpoDoc AS LOGICAL INITIAL yes 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cargo", yes,
"Abono", no,
"Ambos", ?
     SIZE 23 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 1.65.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.72 BY 2.23.

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

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 105 BY 3.08.

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
      fEstado() @ X-STAT COLUMN-LABEL "Estado" FORMAT "x(15)":U
            WIDTH 13.43
      CcbCDocu.DivOri COLUMN-LABEL "Division!Origen" FORMAT "x(5)":U
            WIDTH 6.72
      CcbCDocu.FchDoc COLUMN-LABEL "Fecha de!Emision" FORMAT "99/99/99":U
      CcbCDocu.CodDoc COLUMN-LABEL "Doc." FORMAT "x(3)":U
      CcbCDocu.NroDoc COLUMN-LABEL "Nro.!Documento  ." FORMAT "x(12)":U
            WIDTH 11.14
      f-get-guiaremision(ccbcdocu.coddiv,ccbcdocu.coddoc,ccbcdocu.nrodoc) @ x-nro-doc COLUMN-LABEL "Doc. Referencia" FORMAT "x(20)":U
      CcbCDocu.FchCbd COLUMN-LABEL "Fecha de!Recepción" FORMAT "99/99/9999":U
      CcbCDocu.FchVto COLUMN-LABEL "Fecha   !Vencimiento ." FORMAT "99/99/9999":U
      CcbCDocu.FchCan COLUMN-LABEL "Fecha de!Cancelacion" FORMAT "99/99/9999":U
      CcbCDocu.FchUbi COLUMN-LABEL "Fecha Ubic./!Depósito" FORMAT "99/99/9999":U
      f_DiasVto(ccbcdocu.coddoc, ccbcdocu.nrodoc, ccbcdocu.fchcan, ccbcdocu.fchvto,  ccbcdocu.flgest) @ x-Dias COLUMN-LABEL "Dias" FORMAT "->>>>9":U
      f-Moneda(Ccbcdocu.codmon) @ X-MON COLUMN-LABEL "Mon" FORMAT "x(4)":U
      (IF FacDocum.TpoDoc = YES THEN 1 ELSE -1) * CcbCDocu.ImpTot @ x-ImpTot COLUMN-LABEL "Importe Total" FORMAT "->>,>>>,>>9.99":U
      (IF FacDocum.TpoDoc = YES THEN 1 ELSE -1) * CcbCDocu.SdoAct @ x-SdoAct COLUMN-LABEL "Saldo Documento" FORMAT "->>,>>>,>>9.99":U
      CcbCDocu.FmaPgo COLUMN-LABEL "Cond!venta" FORMAT "X(8)":U
            WIDTH 6
      f-situacion(Ccbcdocu.flgsit) @ x-sit COLUMN-LABEL "Situacion" FORMAT "x(15)":U
            WIDTH 9.72
      f-ubicacion(Ccbcdocu.flgubi) @ x-ubi COLUMN-LABEL "Ubicacion." FORMAT "x(15)":U
      CcbCDocu.NroSal COLUMN-LABEL "Codigo!Unico" FORMAT "X(15)":U
            WIDTH 12
      CcbCDocu.CodCta COLUMN-LABEL "Banco" FORMAT "X(10)":U WIDTH 12
      f-canje(Ccbcdocu.coddoc, Ccbcdocu.nrodoc) @ x-nrocanje COLUMN-LABEL "Nro Canje" FORMAT "x(15)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 104.86 BY 9
         FONT 4
         TITLE "COMPROBANTES" ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Estado AT ROW 1.27 COL 10.43
     r-TpoDoc AT ROW 1.27 COL 39 NO-LABEL
     F-CodDoc AT ROW 2.15 COL 6.14
     x-FchDoc-1 AT ROW 2.92 COL 16 COLON-ALIGNED
     x-FchDoc-2 AT ROW 2.92 COL 37 COLON-ALIGNED
     x-Statbr_table AT ROW 4.08 COL 1
     b-Carta AT ROW 13.31 COL 90
     FILL-IN-ImpTot-1 AT ROW 14.08 COL 27 COLON-ALIGNED
     FILL-IN-ImpTot-2 AT ROW 14.08 COL 43 COLON-ALIGNED
     FILL-IN-SdoAct-1 AT ROW 14.08 COL 59 COLON-ALIGNED
     FILL-IN-SdoAct-2 AT ROW 14.08 COL 75 COLON-ALIGNED
     BUTTON-8 AT ROW 14.27 COL 90
     BUTTON-2 AT ROW 15.46 COL 90
     F-TVenSo AT ROW 15.73 COL 3.43 COLON-ALIGNED
     F-TvenDo AT ROW 15.73 COL 18.14 COLON-ALIGNED
     F-TpoVSo AT ROW 15.73 COL 32.43 COLON-ALIGNED
     F-TpoVDo AT ROW 15.73 COL 47.14 COLON-ALIGNED
     F-TotSol AT ROW 15.73 COL 61.57 COLON-ALIGNED
     F-TotDol AT ROW 15.73 COL 76 COLON-ALIGNED
     b-Depositos AT ROW 16.42 COL 90
     F-TotS0 AT ROW 17.27 COL 19.57 COLON-ALIGNED NO-LABEL
     F-TotS15 AT ROW 17.27 COL 33.57 COLON-ALIGNED NO-LABEL
     F-TotS30 AT ROW 17.27 COL 47.57 COLON-ALIGNED NO-LABEL
     F-TotS45 AT ROW 17.27 COL 61.57 COLON-ALIGNED NO-LABEL
     F-TotS60 AT ROW 17.27 COL 75.57 COLON-ALIGNED NO-LABEL
     BUTTON-9 AT ROW 17.92 COL 99 WIDGET-ID 4
     F-TotD0 AT ROW 18 COL 19.57 COLON-ALIGNED NO-LABEL
     F-TotD15 AT ROW 18 COL 33.57 COLON-ALIGNED NO-LABEL
     F-TotD30 AT ROW 18 COL 47.57 COLON-ALIGNED NO-LABEL
     F-TotD45 AT ROW 18 COL 61.57 COLON-ALIGNED NO-LABEL
     F-TotD60 AT ROW 18 COL 75.57 COLON-ALIGNED NO-LABEL
     B-Imprimir AT ROW 18.15 COL 90.72
     "<<      x  Vencer     >>" VIEW-AS TEXT
          SIZE 28.29 BY .5 AT ROW 15.15 COL 31.29
          BGCOLOR 1 FGCOLOR 15 FONT 0
     "45-60 Dias" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 16.73 COL 63.72
          FONT 1
     "15-30 Dias" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 16.73 COL 35.72
          FONT 1
     "Soles" VIEW-AS TEXT
          SIZE 8 BY .69 AT ROW 17.23 COL 3.72
          FONT 1
     "Total Facturado" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 13.31 COL 33
          BGCOLOR 1 FGCOLOR 15 FONT 0
     "Total Vencidos" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 16.73 COL 3.72
          FONT 1
     "<<     Total  Deuda   >>" VIEW-AS TEXT
          SIZE 28.29 BY .5 AT ROW 15.15 COL 60
          BGCOLOR 1 FGCOLOR 15 FONT 0
     "Dolares" VIEW-AS TEXT
          SIZE 8 BY .69 AT ROW 17.96 COL 3.72
          FONT 1
     "30-45 Dias" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 16.73 COL 49.72
          FONT 1
     "Total Pendiente" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 13.31 COL 66
          BGCOLOR 1 FGCOLOR 15 FONT 0
     "0 - 15 Dias" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 16.73 COL 21.72
          FONT 1
     "Tipo de documento (Vacio = Todos)" VIEW-AS TEXT
          SIZE 35 BY .5 AT ROW 2.35 COL 23 WIDGET-ID 32
          FGCOLOR 4 FONT 6
     "<<       Vencidos      >>" VIEW-AS TEXT
          SIZE 28.29 BY .5 AT ROW 15.15 COL 2.43
          BGCOLOR 1 FGCOLOR 15 FONT 0
     "60 - + Dias" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 16.73 COL 77.72
          FONT 1
     RECT-10 AT ROW 15.04 COL 59.72
     RECT-59 AT ROW 13.12 COL 57
     RECT-11 AT ROW 16.65 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     RECT-9 AT ROW 15.04 COL 30.86
     RECT-60 AT ROW 13.88 COL 25
     RECT-8 AT ROW 15.04 COL 2
     RECT-61 AT ROW 13.88 COL 57
     RECT-58 AT ROW 13.12 COL 25
     RECT-66 AT ROW 1 COL 1 WIDGET-ID 54
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
   Temp-Tables and Buffers:
      TABLE: B-CDocu B "?" ? INTEGRAL CcbCDocu
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
         HEIGHT             = 18.92
         WIDTH              = 110.86.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB x-Statbr_table x-FchDoc-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-CodDoc IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX F-Estado IN FRAME F-Main
   ALIGN-L                                                              */
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
     _Where[1]         = "{&Condicion}"
     _Where[2]         = "( ( r-TpoDoc = ? AND FacDocum.TpoDoc <> ? )
 OR (r-TpoDoc <> ? AND FacDocum.TpoDoc = r-TpoDoc) )"
     _FldNameList[1]   > "_<CALC>"
"fEstado() @ X-STAT" "Estado" "x(15)" ? ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.CcbCDocu.DivOri
"CcbCDocu.DivOri" "Division!Origen" ? "character" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" "Fecha de!Emision" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.CcbCDocu.CodDoc
"CcbCDocu.CodDoc" "Doc." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" "Nro.!Documento  ." "x(12)" "character" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"f-get-guiaremision(ccbcdocu.coddiv,ccbcdocu.coddoc,ccbcdocu.nrodoc) @ x-nro-doc" "Doc. Referencia" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.CcbCDocu.FchCbd
"CcbCDocu.FchCbd" "Fecha de!Recepción" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > integral.CcbCDocu.FchVto
"CcbCDocu.FchVto" "Fecha   !Vencimiento ." ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > integral.CcbCDocu.FchCan
"CcbCDocu.FchCan" "Fecha de!Cancelacion" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > integral.CcbCDocu.FchUbi
"CcbCDocu.FchUbi" "Fecha Ubic./!Depósito" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"f_DiasVto(ccbcdocu.coddoc, ccbcdocu.nrodoc, ccbcdocu.fchcan, ccbcdocu.fchvto,  ccbcdocu.flgest) @ x-Dias" "Dias" "->>>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"f-Moneda(Ccbcdocu.codmon) @ X-MON" "Mon" "x(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"(IF FacDocum.TpoDoc = YES THEN 1 ELSE -1) * CcbCDocu.ImpTot @ x-ImpTot" "Importe Total" "->>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"(IF FacDocum.TpoDoc = YES THEN 1 ELSE -1) * CcbCDocu.SdoAct @ x-SdoAct" "Saldo Documento" "->>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > integral.CcbCDocu.FmaPgo
"CcbCDocu.FmaPgo" "Cond!venta" ? "character" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"f-situacion(Ccbcdocu.flgsit) @ x-sit" "Situacion" "x(15)" ? ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"f-ubicacion(Ccbcdocu.flgubi) @ x-ubi" "Ubicacion." "x(15)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > integral.CcbCDocu.NroSal
"CcbCDocu.NroSal" "Codigo!Unico" "X(15)" "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > integral.CcbCDocu.CodCta
"CcbCDocu.CodCta" "Banco" ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"f-canje(Ccbcdocu.coddoc, Ccbcdocu.nrodoc) @ x-nrocanje" "Nro Canje" "x(15)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  IF {&self-name} <> SELF:SCREEN-VALUE THEN DO:
      ASSIGN {&self-name}.
      RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Estado B-table-Win
ON VALUE-CHANGED OF F-Estado IN FRAME F-Main /* Condicion */
DO:
  ASSIGN
     F-Estado.
  F-FlgEst = ENTRY(LOOKUP(F-Estado, F-Estado:LIST-ITEMS),"P|J,C,A,F,X,S,J,").
  /* Pendiente, Cancelado, Anulado, Facturado, Cerrado, Castigado, Cobranza Dudosa, Todos */
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME r-TpoDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-TpoDoc B-table-Win
ON VALUE-CHANGED OF r-TpoDoc IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
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
ON LEAVE OF x-FchDoc-2 IN FRAME F-Main /* Hasta */
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
ON LEFT-MOUSE-DBLCLICK OF x-Statbr_table IN FRAME F-Main /* COMPROBANTES */
DO:
  /*RUN VTA\D-cmpbte.r(Ccbcdocu.NroDoc,CcbcDocu.CodDoc).*/
  RUN vta2/dcomprobantes (Ccbcdocu.NroDoc,CcbcDocu.CodDoc).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Statbr_table B-table-Win
ON ROW-ENTRY OF x-Statbr_table IN FRAME F-Main /* COMPROBANTES */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Statbr_table B-table-Win
ON ROW-LEAVE OF x-Statbr_table IN FRAME F-Main /* COMPROBANTES */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Statbr_table B-table-Win
ON VALUE-CHANGED OF x-Statbr_table IN FRAME F-Main /* COMPROBANTES */
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
/* ON FIND OF Ccbcdocu                              */
/* DO:                                              */
/*    CASE CcbCDocu.FlgEst:                         */
/*         WHEN "P" THEN X-STAT = "Pendiente".      */
/*         WHEN "C" THEN X-STAT = "Cancelado".      */
/*         WHEN "A" THEN X-STAT = "Anulado".        */
/*         WHEN "F" THEN X-STAT = "Facturado".      */
/*         WHEN "X" THEN X-STAT = "Por Aprobar".    */
/*         WHEN "E" THEN X-STAT = "Emitido".        */
/*         WHEN "S" THEN X-STAT = "Castigado".      */
/*         OTHERWISE X-STAT = ''.                   */
/*    END.                                          */
/*    IF CcbCDocu.CodDoc = "BD" THEN DO:            */
/*        CASE CcbCDocu.FlgEst:                     */
/*            WHEN "E" THEN x-stat = "POR APROBAR". */
/*            WHEN "P" THEN x-stat = "PENDIENTE".   */
/*            WHEN "A" THEN x-stat = "ANULADO".     */
/*            WHEN "C" THEN x-stat = "CANCELADO".   */
/*            WHEN "X" THEN x-stat = "CERRADO".     */
/*        END CASE.                                 */
/*    END.                                          */
/* END.                                             */

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
DEFINE VAR x-Factor AS INT NO-UNDO.
DEFINE VAR x-SdoAct AS DEC NO-UNDO.
DEFINE VAR x-ImpTot AS DEC NO-UNDO.
    
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

SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH CcbCDocu NO-LOCK WHERE CcbCDocu.CodCia = s-CodCia
    AND CcbCDocu.CodCli = gn-clie.CodCli
    AND {&Condicion},
    FIRST FacDocum OF CcbCDocu NO-LOCK WHERE 
    ( ( r-TpoDoc = ? AND FacDocum.TpoDoc <> ? )
      OR (r-TpoDoc <> ? AND FacDocum.TpoDoc = r-TpoDoc) ) :
    x-Factor = (IF FacDocum.TpoDoc = YES THEN 1 ELSE -1).
    x-ImpTot = Ccbcdocu.ImpTot * x-Factor.
    x-SdoAct = Ccbcdocu.SdoAct * x-Factor.
    CASE CcbCDocu.CodMon :           
         WHEN 1 THEN DO :
            IF LOOKUP(ccbcdocu.flgest, 'A,X') = 0
            THEN ASSIGN
                    FILL-IN-ImpTot-1 = FILL-IN-ImpTot-1 + x-ImpTot
                    FILL-IN-SdoAct-1 = FILL-IN-SdoAct-1 + x-SdoAct.                
                /* por vencer */
                IF CcbCDocu.FchVto >= TODAY THEN F-TpoVSo = F-TpoVSo + x-SdoAct.
                /* Vencido */
                IF CcbCDocu.FchVto < TODAY THEN DO:
                   F-TVenSo = F-TVenSo + x-SdoAct. 
                   I-DIAS = TODAY - CcbCDocu.FchVto.
                   CASE (I-DIAS > 0):
                        WHEN YES AND I-DIAS <= 15 THEN 
                             F-TotS0  = F-TotS0 + x-SdoAct.
                        WHEN YES AND I-DIAS > 15 AND I-DIAS <= 30 THEN 
                             F-TotS15  = F-TotS15 + x-SdoAct.
                        WHEN YES AND I-DIAS > 30 AND I-DIAS <= 45 THEN 
                             F-TotS30  = F-TotS30 + x-SdoAct.
                        WHEN YES AND I-DIAS > 45 AND I-DIAS <= 60 THEN 
                             F-TotS45  = F-TotS45 + x-SdoAct.
                        WHEN YES AND I-DIAS > 60 THEN 
                             F-TotS60  = F-TotS60 + x-SdoAct.
                   END CASE.
                END.
           END.     
         WHEN 2 THEN DO :
            IF LOOKUP(ccbcdocu.flgest, 'A,X') = 0   /* Anulado Castigado */
            THEN ASSIGN
                    FILL-IN-ImpTot-2 = FILL-IN-ImpTot-2 + x-ImpTot
                    FILL-IN-SdoAct-2 = FILL-IN-SdoAct-2 + x-SdoAct.                
                /* por vencer */
                IF CcbCDocu.FchVto >= TODAY THEN F-TpoVDo = F-TpoVDo + x-SdoAct.
                /* Vencido */
                IF CcbCDocu.FchVto < TODAY THEN DO:
                   F-TVenDo = F-TVenDo + x-SdoAct.   
                   I-DIAS = TODAY - CcbCDocu.FchVto.
                   CASE (I-DIAS > 0):
                        WHEN YES AND I-DIAS <= 15 THEN 
                             F-TotD0  = F-TotD0 + x-SdoAct.
                        WHEN YES AND I-DIAS > 15 AND I-DIAS <= 30 THEN 
                             F-TotD15  = F-TotD15 + x-SdoAct.
                        WHEN YES AND I-DIAS > 30 AND I-DIAS <= 45 THEN 
                             F-TotD30  = F-TotD30 + x-SdoAct.
                        WHEN YES AND I-DIAS > 45 AND I-DIAS <= 60 THEN 
                             F-TotD45  = F-TotD45 + x-SdoAct.
                        WHEN YES AND I-DIAS > 60 THEN 
                             F-TotD60  = F-TotD60 + x-SdoAct.
                   END CASE.
                END.
           END.
    END CASE .
END.
SESSION:SET-WAIT-STATE('').
DISPLAY 
    F-TpoVDo
    F-TpoVSo
    F-TvenDo
    F-TVenSo
    F-TotD0 
    F-TotD15
    F-TotD30
    F-TotD45
    F-TotD60
    F-TotS0 
    F-TotS15
    F-TotS30
    F-TotS45
    F-TotS60
    FILL-IN-ImpTot-1
    FILL-IN-ImpTot-2
    FILL-IN-SdoAct-1
    FILL-IN-SdoAct-2
    WITH FRAME {&FRAME-NAME}.

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
    chWorkSheet:Range("B3"):Value = "Nro. Documento"
    chWorkSheet:Columns("B"):NumberFormat = "@"

    chWorkSheet:Range("C3"):Value = "Referencia"

    chWorkSheet:Range("D3"):Value = "Fecha de Emisión"
    chWorkSheet:Columns("D"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Range("E3"):Value = "Fecha Vencimiento"
    chWorkSheet:Columns("E"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Range("F3"):Value = "Mon"
    chWorkSheet:Range("G3"):Value = "Importe Total"
    chWorkSheet:Range("H3"):Value = "Saldo Documento"
    chWorkSheet:Range("I3"):Value = "Estado"
    chWorkSheet:Range("J3"):Value = "Situación"
    chWorkSheet:Range("K3"):Value = "Ubicación"
    chWorkSheet:Range("L3"):Value = "# Unico"
    chWorkSheet:Range("M3"):Value = "Tipo Oper."
    chWorkSheet:Range("N3"):Value = "Fecha de Recepción"
    chWorkSheet:Columns("N"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Range("O3"):Value = "Fecha de Cancelación"
    chWorkSheet:Columns("O"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Range("P3"):Value = "Días"
    chWorkSheet:Range("Q3"):Value = "Total Fotocopias"
    chWorkSheet:Range("R3"):Value = "Cond Venta"
    chWorkSheet:Columns("R"):NumberFormat = "@"
    chWorkSheet:Range("S3"):Value = "Division Origen"
    chWorkSheet:Columns("S"):NumberFormat = "@"
    chWorkSheet:Range("T3"):Value = "Concepto"
    chWorkSheet:Range("U3"):Value = "Observaciones"

    .

DEF VAR lde_ImpFoto AS DEC NO-UNDO.
ASSIGN
    t-Row = 3.
GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE Ccbcdocu:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1
        lde_ImpFoto = 0.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.CodDoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.NroDoc.
    ASSIGN
        t-Column = t-Column + 1
        /* Ic - 27Abr2018, chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.CodRef + ' ' + CcbCDocu.NroRef.*/
        chWorkSheet:Cells(t-Row, t-Column):VALUE = f-get-guiaremision(INPUT CcbCDocu.Coddiv, 
                                                                      INPUT CcbCDocu.Coddoc,
                                                                      INPUT CcbCDocu.Nrodoc).
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchDoc NO-ERROR.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchVto NO-ERROR.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = f-Moneda(Ccbcdocu.codmon).
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF FacDocum.TpoDoc = YES THEN 1 ELSE -1) * CcbCDocu.ImpTot.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF FacDocum.TpoDoc = YES THEN 1 ELSE -1) * CcbCDocu.SdoAct.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = fEstado().
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF Ccbcdocu.coddoc = 'LET' THEN f-Situacion(Ccbcdocu.flgsit) ELSE '').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF Ccbcdocu.coddoc = 'LET' THEN f-Ubicacion(Ccbcdocu.flgubi) ELSE '').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF Ccbcdocu.coddoc = 'LET' THEN Ccbcdocu.nrosal ELSE '').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF FacDocum.TpoDoc THEN 'Cargo' ELSE 'Abono').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchCbd NO-ERROR.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchCan NO-ERROR.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = f_DiasVto(ccbcdocu.coddoc, ccbcdocu.nrodoc, ccbcdocu.fchcan, ccbcdocu.fchvto,  ccbcdocu.flgest)
        NO-ERROR.
    FOR EACH ccbddocu OF ccbcdocu NO-LOCK, FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = Ccbddocu.codcia
        AND Almmmatg.codmat = Ccbddocu.codmat
        AND Almmmatg.codfam = '011':
        lde_ImpFoto = lde_ImpFoto + Ccbddocu.ImpLin.
    END.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = lde_ImpFoto NO-ERROR.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbcdocu.fmapgo.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbcdocu.divori.
    /* RHC 25/07/18 Jessica Barreda */
    ASSIGN
        t-Column = t-Column + 1.
    IF LOOKUP(Ccbcdocu.coddoc, 'N/C,N/D') > 0 THEN DO:
        FIND CcbTabla WHERE CcbTabla.CodCia = Ccbcdocu.codcia AND
            CcbTabla.Tabla = Ccbcdocu.coddoc AND 
            CcbTabla.Codigo = CcbCDocu.CodCta
            NO-LOCK NO-ERROR.
        IF AVAILABLE CcbTabla THEN chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbTabla.Nombre.
    END.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.Glosa.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-copia B-table-Win 
PROCEDURE Excel-copia :
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
    chWorkSheet:Range("L3"):Value = "Total Fotocopias"
    chWorkSheet:Range("M3"):Value = "Estado"
    chWorkSheet:Range("N3"):Value = "# Unico"
    chWorkSheet:Range("O3"):Value = "Ubicación"
    chWorkSheet:Range("P3"):Value = "Situación"
    chWorkSheet:Range("Q3"):Value = "Cond Venta"
    chWorkSheet:Columns("Q"):NumberFormat = "@"
    .

DEF VAR lde_ImpFoto AS DEC NO-UNDO.
ASSIGN
    t-Row = 3.
GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE Ccbcdocu:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1
        lde_ImpFoto = 0.
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
        t-Column = t-Column + 1.
    ASSIGN
       chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchDoc NO-ERROR.
    ASSIGN
        t-Column = t-Column + 1.
    ASSIGN
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchCbd NO-ERROR.
    ASSIGN
        t-Column = t-Column + 1.
    ASSIGN
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchVto NO-ERROR.
    ASSIGN
        t-Column = t-Column + 1.
    ASSIGN
        chWorkSheet:Cells(t-Row, t-Column):VALUE = CcbCDocu.FchCan NO-ERROR.
    ASSIGN
        t-Column = t-Column + 1.
    ASSIGN
        chWorkSheet:Cells(t-Row, t-Column):VALUE = f_DiasVto(ccbcdocu.coddoc, ccbcdocu.nrodoc, ccbcdocu.fchcan, ccbcdocu.fchvto,  ccbcdocu.flgest)
        NO-ERROR.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = f-Moneda(Ccbcdocu.codmon).
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF FacDocum.TpoDoc = YES THEN 1 ELSE -1) * CcbCDocu.ImpTot.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF FacDocum.TpoDoc = YES THEN 1 ELSE -1) * CcbCDocu.SdoAct.

    FOR EACH ccbddocu OF ccbcdocu NO-LOCK, FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = Ccbddocu.codcia
        AND Almmmatg.codmat = Ccbddocu.codmat
        AND Almmmatg.codfam = '011':
        lde_ImpFoto = lde_ImpFoto + Ccbddocu.ImpLin.
    END.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = lde_ImpFoto NO-ERROR.

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
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Ccbcdocu.fmapgo.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-canje B-table-Win 
FUNCTION f-canje RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lNroCanje AS CHAR.
DEFINE VAR lDocumtos AS CHAR.

lNroCanje = "".
lDocumtos = "FAC,N/C,BOL,N/D,TCK".

IF lookup(pCodDoc,lDocumtos) > 0 THEN DO:
    FIND FIRST ccbdcaja WHERE ccbdcaja.codcia = s-codcia AND 
            ccbdcaja.codref = pCodDoc AND ccbdcaja.nroref = pNroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE ccbdcaja THEN DO:
        lNroCanje = ccbdcaja.coddoc + " " + ccbdcaja.nrodoc.
    END.
    ELSE DO:
          FOR EACH ccbcmvto NO-LOCK WHERE ccbcmvto.codcia = s-codcia
              AND ccbcmvto.coddoc = 'CJE'
              AND ccbcmvto.codcli = ccbcdocu.codcli
              AND ccbcmvto.flgest <> 'A'
              AND ccbcmvto.fchdoc >= ccbcdocu.fchdoc:
              FIND FIRST ccbdmvto WHERE ccbdmvto.codcia = ccbcmvto.codcia
                  AND ccbdmvto.coddiv = ccbcmvto.coddiv
                  AND ccbdmvto.coddoc = ccbcmvto.coddoc
                  AND ccbdmvto.nrodoc = ccbcmvto.nrodoc
                  AND ccbdmvto.tporef = "O"
                  AND ccbdmvto.codref = ccbcdocu.coddoc
                  AND ccbdmvto.nroref = ccbcdocu.nrodoc
                  NO-LOCK NO-ERROR.
              IF AVAILABLE Ccbdmvto THEN DO:
                  lNroCanje = ccbdmvto.coddoc + " " + ccbdmvto.nrodoc.
              END.
          END.
    END.
END.

RETURN lNroCanje.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-get-guiaremision B-table-Win 
FUNCTION f-get-guiaremision RETURNS CHARACTER
  ( INPUT pCodDiv AS CHAR, INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :

  DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
  DEFINE BUFFER GUIAS FOR ccbcdocu.

  x-nro-gr = "". 
  FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                                b-ccbcdocu.coddiv = pCodDiv AND 
                                b-ccbcdocu.coddoc = pCodDoc AND
                                b-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
  IF AVAILABLE b-ccbcdocu THEN DO:
      IF TRUE <> (b-ccbcdocu.nroref > "") THEN DO:
            xLoop:
            FOR EACH GUIAS WHERE GUIAS.codcia = s-codcia AND 
                                    GUIAS.coddoc = 'G/R' AND 
                                    GUIAS.codref = pCodDoc AND
                                    GUIAS.nroref = pNroDoc NO-LOCK:
                x-nro-gr = TRIM(GUIAS.coddoc) + " - " + TRIM(GUIAS.nrodoc).
                LEAVE xLoop.
            END.
      END.
      ELSE DO:
             x-nro-gr = TRIM(b-ccbcdocu.codref) + " - " + TRIM(b-ccbcdocu.nroref).
      END.
  END.  
  
  RETURN x-nro-gr.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

IF ccbcdocu.coddoc = 'LET' THEN DO:
    CASE cflgsit:
      WHEN 'T' THEN RETURN 'Transito'.
      WHEN 'C' THEN RETURN 'Cobranza Libre'.
      WHEN 'G' THEN RETURN 'Cobranza Garantia'.
      WHEN 'D' THEN RETURN 'Descuento'.
      WHEN 'P' THEN RETURN 'Protestada'.
    END CASE.

END.
ELSE cflgsit = "".

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
IF ccbcdocu.coddoc = 'LET' THEN DO:
    CASE cflgubi:
      WHEN 'C' THEN RETURN 'Cartera'.
      WHEN 'B' THEN RETURN 'Banco'.
    END CASE.

END.
ELSE cflgubi = "".

RETURN cflgubi.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pEstado AS CHAR.

RUN gn/fFlgEstCCBv2 (ccbcdocu.coddoc,
                     ccbcdocu.flgest,
                     OUTPUT pEstado).
RETURN pEstado.

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

