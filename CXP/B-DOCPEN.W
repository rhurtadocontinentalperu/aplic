&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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

/* Local Variable Definitions ---                  */
{CBD/CBGLOBAL.I}

DEFINE TEMP-TABLE DMOV NO-UNDO LIKE cb-dmov.
DEFINE TEMP-TABLE DMOV-2 NO-UNDO LIKE cb-dmov.

DEFINE VARIABLE I-ORDEN AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA  AS CHAR.
DEFINE BUFFER DETALLE FOR cb-dmov.

DEFINE VAR x-ImpMn1  AS DECIMAL.
DEFINE VAR x-ImpMn2  AS DECIMAL.
DEFINE VAR x-dol LIKE DMOV.ImpMn2.
DEFINE VAR x-sol LIKE DMOV.ImpMn1.
/*DEFINE VAR pv-codcia AS INT.
 * 
 * FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
 * IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.*/

DEFINE STREAM report.


DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(50)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
     WITH CENTERED OVERLAY KEEP-TAB-ORDER 
          SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
          BGCOLOR 15 FGCOLOR 0 
          TITLE "Procesando ..." FONT 7.

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
&Scoped-define INTERNAL-TABLES DMOV

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DMOV.CodAux DMOV.Coddoc DMOV.Nrodoc DMOV.CodBco DMOV.NroRef DMOV.Fchvto DMOV.Fchvto + 8 @ DMOV.Fchdoc DMOV.GloDoc DMOV.TpoMov DMOV.ImpMn1 DMOV.ImpMn2 DMOV.TpoCmb DMOV.NroAst DMOV.CodOpe   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DMOV.CodBco ~
 DMOV.NroRef   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DMOV
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DMOV
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table IF I-ORDEN = 1 THEN OPEN QUERY {&SELF-NAME} FOR EACH DMOV NO-LOCK    BY DMOV.CodCia     BY DMOV.Fchvto      BY DMOV.Codaux       BY DMOV.Coddoc        BY DMOV.Nrodoc     INDEXED-REPOSITION. ELSE OPEN QUERY {&SELF-NAME} FOR EACH DMOV NO-LOCK    BY DMOV.CodCia     BY DMOV.Codaux      BY DMOV.Fchvto       BY DMOV.Coddoc        BY DMOV.Nrodoc     INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table DMOV
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DMOV


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-17 X-CodDiv D-FchDes D-FchHas ~
x-Codmon d-FchEmi-1 d-FchEmi-2 x-codaux C-doc x-NroDoc F-ExcDoc F-CjaChi ~
br_table 
&Scoped-Define DISPLAYED-OBJECTS X-CodDiv D-FchDes D-FchHas x-Codbco ~
x-Codmon d-FchEmi-1 d-FchEmi-2 x-codaux C-doc x-NroDoc F-ExcDoc F-CjaChi ~
F-ImpMn1 F-ImpMn2 

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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE C-doc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod. Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE D-FchDes AS DATE FORMAT "99/99/9999":U 
     LABEL "Vencimiento del" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE d-FchEmi-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE d-FchEmi-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE D-FchHas AS DATE FORMAT "99/99/9999":U 
     LABEL "al" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE F-CjaChi AS CHARACTER FORMAT "X(8)":U 
     LABEL "Caja Chica" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-ExcDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Menos Doc." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE F-ImpMn1 AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .69 NO-UNDO.

DEFINE VARIABLE F-ImpMn2 AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "US$" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .69 NO-UNDO.

DEFINE VARIABLE x-codaux AS CHARACTER FORMAT "X(8)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-Codbco AS CHARACTER FORMAT "X(256)":U 
     LABEL "Banco" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE X-CodDiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "Divisi¢n" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-NroDoc AS CHARACTER FORMAT "X(10)":U 
     LABEL "Nro. Documento" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-Codmon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 13.57 BY .85 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 1.73.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 4.04.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DMOV SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      DMOV.CodAux COLUMN-LABEL "Proveedor"
      DMOV.Coddoc 
      DMOV.Nrodoc FORMAT "X(15)"
      DMOV.CodBco COLUMN-LABEL "Cod.!Bco." FORMAT "X(3)"
      DMOV.NroRef COLUMN-LABEL "Doc.Asignado!por Banco" FORMAT "X(10)"
      DMOV.Fchvto COLUMN-LABEL "Fecha Vncmto"
      DMOV.Fchvto + 8 @ DMOV.Fchdoc COLUMN-LABEL " Octavo Dia " FORMAT "99/99/9999"
      DMOV.GloDoc FORMAT "X(25)"
      DMOV.TpoMov 
      DMOV.ImpMn1 
      DMOV.ImpMn2 
      DMOV.TpoCmb 
      DMOV.NroAst COLUMN-LABEL "Vaucher"
      DMOV.CodOpe COLUMN-LABEL "Libro"
    ENABLE
        DMOV.CodBco
        DMOV.NroRef
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 85.72 BY 10.38
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     X-CodDiv AT ROW 1.27 COL 9 COLON-ALIGNED
     D-FchDes AT ROW 1.27 COL 34.14 COLON-ALIGNED
     D-FchHas AT ROW 1.27 COL 50 COLON-ALIGNED
     x-Codbco AT ROW 1.27 COL 75.72 COLON-ALIGNED
     x-Codmon AT ROW 1.96 COL 71.29 NO-LABEL
     d-FchEmi-1 AT ROW 2.08 COL 34 COLON-ALIGNED
     d-FchEmi-2 AT ROW 2.08 COL 50 COLON-ALIGNED
     x-codaux AT ROW 2.88 COL 9 COLON-ALIGNED
     C-doc AT ROW 2.88 COL 34 COLON-ALIGNED
     x-NroDoc AT ROW 2.88 COL 55 COLON-ALIGNED
     F-ExcDoc AT ROW 3.96 COL 9 COLON-ALIGNED
     F-CjaChi AT ROW 3.96 COL 34 COLON-ALIGNED
     F-ImpMn1 AT ROW 3.96 COL 50 COLON-ALIGNED
     F-ImpMn2 AT ROW 3.96 COL 68 COLON-ALIGNED
     br_table AT ROW 4.77 COL 1
     "TOTAL" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 4.08 COL 42
     RECT-3 AT ROW 1 COL 1
     RECT-17 AT ROW 1.15 COL 70.57
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
         HEIGHT             = 14.15
         WIDTH              = 86.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
/* BROWSE-TAB br_table F-ImpMn2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpMn1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpMn2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Codbco IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
IF I-ORDEN = 1 THEN
OPEN QUERY {&SELF-NAME} FOR EACH DMOV NO-LOCK
   BY DMOV.CodCia
    BY DMOV.Fchvto
     BY DMOV.Codaux
      BY DMOV.Coddoc
       BY DMOV.Nrodoc
    INDEXED-REPOSITION.
ELSE
OPEN QUERY {&SELF-NAME} FOR EACH DMOV NO-LOCK
   BY DMOV.CodCia
    BY DMOV.Codaux
     BY DMOV.Fchvto
      BY DMOV.Coddoc
       BY DMOV.Nrodoc
    INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
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
  RUN cxp/d-detdoc.r ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CodCta,
                      {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CodAux,
                      {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CodDoc,
                      {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroDoc).
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


&Scoped-define SELF-NAME C-doc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-doc B-table-Win
ON VALUE-CHANGED OF C-doc IN FRAME F-Main /* Cod. Documento */
DO:
  ASSIGN c-doc.
  IF c-doc = 'LP' THEN DO:
     x-Codbco:SENSITIVE = Yes.
/*MLR* *
     x-Codmon:SENSITIVE = Yes.
* */
     END.
  ELSE DO:
     x-Codbco:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
     x-Codbco:SENSITIVE = No.
/*MLR* *
     x-Codmon:SENSITIVE = No.
* */
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-codaux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codaux B-table-Win
ON LEAVE OF x-codaux IN FRAME F-Main /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
     FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND
          gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-prov THEN DO:
     MESSAGE "Codigo de proveedor no registrado" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON LEAVE OF DMOV.CodBco IN BROWSE {&BROWSE-NAME}
DO:
  DMOV.CodBco:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SELF:SCREEN-VALUE.
  ASSIGN DMOV.Codbco.
END.
/* ***************************  Main Block  *************************** */

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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asignar-Banco B-table-Win 
PROCEDURE Asignar-Banco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DMOV : 
      FIND LAST DETALLE WHERE 
           DETALLE.CODCIA  = S-CODCIA    AND 
           DETALLE.PERIODO = S-PERIODO   AND 
           DETALLE.CODOPE  = DMOV.CODOPE AND 
           DETALLE.CODCTA  = DMOV.CODCTA AND 
           DETALLE.CodAux  = DMOV.codaux AND 
           DETALLE.CODDOC  = DMOV.CODDOC AND 
           DETALLE.NroDoc  = DMOV.NroDoc 
           EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE DETALLE THEN DO:
         ASSIGN DETALLE.CODBCO = DMOV.CODBCO
                DETALLE.NROREF = DMOV.NROREF.
      END.
      RELEASE DETALLE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Caja-Chica B-table-Win 
PROCEDURE Caja-Chica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   ASSIGN C-doc x-codaux X-CodDiv x-NroDoc D-FchDes D-FchHas F-ExcDoc F-CjaChi.
   IF C-doc = "Todos" THEN C-doc = "".
END.

DEFINE VARIABLE I-NroReg AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE X-IMPORT AS DECIMAL EXTENT 2 INIT 0  NO-UNDO.

/* BLANQUEMOS TEMPORAL */
FOR EACH DMOV:
    DELETE DMOV.
END.
F-ImpMn1 = 0.
F-ImpMn2 = 0.
/* CARGAMOS LOS SALDOS POR DOCUMENTO */
FOR EACH Cp-tpro NO-LOCK  WHERE Cp-tpro.CODCIA = CB-CODCIA AND
         Cp-tpro.CodDoc BEGINS C-doc AND
         LOOKUP(Cp-tpro.CodDoc,F-ExcDoc) = 0 AND
         Cp-tpro.CORRELATIVO = YES AND
         Cp-tpro.CodCta BEGINS "102":
    FOR EACH DETALLE NO-LOCK WHERE DETALLE.CODCIA  = S-CODCIA  AND
             DETALLE.PERIODO = S-PERIODO      AND
             DETALLE.CODOPE  = CP-TPRO.CODOPE AND
             DETALLE.CODCTA  = CP-TPRO.CODCTA AND
             DETALLE.CodAux BEGINS F-CjaChi   AND
             DETALLE.CODDOC  = CP-TPRO.CODDOC AND
             DETALLE.NroDoc BEGINS x-NroDoc   AND
             DETALLE.FCHVTO >= D-FchDes       AND
             DETALLE.FCHVTO <= D-FchHas       
             BREAK BY DETALLE.CODDO BY DETALLE.NRODOC :
        FI-MENSAJE = "Proveedor : " + DETALLE.CodAux + " Doc. : " + DETALLE.CodDoc +
                     " No. : " + DETALLE.NroDoc.
        DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.
        X-IMPORT[1] = 0.
        X-IMPORT[2] = 0.
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia = DETALLE.CODCIA AND
                 cb-dmov.Periodo = DETALLE.PERIODO AND
                 cb-dmov.Codcta  = DETALLE.CODCTA  AND
                 cb-dmov.Codaux  = DETALLE.codaux  AND
                 cb-dmov.CodDoc  = DETALLE.CodDoc  AND
                 cb-dmov.NroDoc  = DETALLE.NroDoc:
            IF cb-dmov.TpoMov THEN 
               ASSIGN X-IMPORT[1] = X-IMPORT[1] - cb-dmov.ImpMn1 
                      X-IMPORT[2] = X-IMPORT[2] - cb-dmov.ImpMn2.
            ELSE
               ASSIGN X-IMPORT[1] = X-IMPORT[1] + cb-dmov.ImpMn1 
                      X-IMPORT[2] = X-IMPORT[2] + cb-dmov.ImpMn2.
        END.
        IF (DETALLE.CodMon = 1 AND ROUND(ABSOLUTE(X-IMPORT[1]),2) > 0) OR
           (DETALLE.CodMon = 2 AND ROUND(ABSOLUTE(X-IMPORT[2]),2) > 0) THEN DO:
        /*IF ABSOLUTE(X-IMPORT[1]) > 0 OR ABSOLUTE(X-IMPORT[2]) > 0 THEN DO:*/
           CREATE DMOV.
           ASSIGN DMOV.CODCIA = S-CODCIA
                  DMOV.NroAst = DETALLE.NroAst
                  DMOV.CodOpe = DETALLE.CodOpe
                  DMOV.cco    = DETALLE.cco   
                  DMOV.Clfaux = DETALLE.Clfaux
                  DMOV.CndCmp = DETALLE.CndCmp
                  DMOV.Codaux = DETALLE.Codaux
                  DMOV.Codcta = DETALLE.Codcta
                  DMOV.CodDiv = DETALLE.CodDiv
                  DMOV.Coddoc = DETALLE.Coddoc
                  DMOV.Codmon = DETALLE.Codmon
                  DMOV.Codref = DETALLE.Codref
                  DMOV.DisCCo = DETALLE.DisCCo
                  DMOV.Fchdoc = DETALLE.Fchdoc
                  DMOV.Fchvto = DETALLE.Fchvto
                  DMOV.flgact = DETALLE.flgact
                  DMOV.Glodoc = DETALLE.Glodoc
                  DMOV.ImpMn1 = ROUND(ABSOLUTE(X-IMPORT[1]),2)
                  DMOV.ImpMn2 = ROUND(ABSOLUTE(X-IMPORT[2]),2)
                  DMOV.Nrodoc = DETALLE.Nrodoc
                  DMOV.Nroref = DETALLE.NroRef
                  DMOV.Nroruc = DETALLE.Nroruc
                  DMOV.OrdCmp = DETALLE.OrdCmp
                  DMOV.tm     = DETALLE.tm
                  DMOV.Tpocmb = DETALLE.Tpocmb
                  DMOV.TpoMov = NOT DETALLE.TpoMov
                  DMOV.CodBco = DETALLE.CodBco.
           IF DMOV.TpoMov THEN DO:
              IF DMOV.ImpMn2 <> 0 THEN F-ImpMn2 = F-ImpMn2 - DMOV.ImpMn2.                     
              ELSE F-ImpMn1 = F-ImpMn1 - DMOV.ImpMn1.           
           END.                 
           ELSE DO:
              IF DMOV.ImpMn2 <> 0 THEN F-ImpMn2 = F-ImpMn2 + DMOV.ImpMn2.
              ELSE F-ImpMn1 = F-ImpMn1 + DMOV.ImpMn1.
           END.   
        END.
    END.
END.
HIDE FRAME F-PROCESO.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

DISPLAY F-ImpMn1 F-ImpMn2 WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Caja-Chica-Backup B-table-Win 
PROCEDURE Caja-Chica-Backup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   ASSIGN C-doc x-codaux X-CodDiv x-NroDoc D-FchDes D-FchHas F-ExcDoc F-CjaChi.
   IF C-doc = "Todos" THEN C-doc = "".
END.

DEFINE VARIABLE I-NroReg AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE X-IMPORT AS DECIMAL EXTENT 2 INIT 0  NO-UNDO.

/* BLANQUEMOS TEMPORAL */
FOR EACH DMOV:
    DELETE DMOV.
END.
F-ImpMn1 = 0.
F-ImpMn2 = 0.
/* CARGAMOS LOS SALDOS POR DOCUMENTO */
FOR EACH Cp-tpro NO-LOCK  WHERE Cp-tpro.CODCIA = CB-CODCIA AND
         Cp-tpro.CodDoc BEGINS C-doc AND
         LOOKUP(Cp-tpro.CodDoc,F-ExcDoc) = 0 AND
         Cp-tpro.CORRELATIVO = YES AND
         Cp-tpro.CodCta BEGINS "102":
    FOR EACH DETALLE NO-LOCK WHERE DETALLE.CODCIA  = S-CODCIA  AND
             DETALLE.PERIODO = S-PERIODO      AND
             DETALLE.CODOPE  = CP-TPRO.CODOPE AND
             DETALLE.CODCTA  = CP-TPRO.CODCTA AND
             DETALLE.CodAux BEGINS F-CjaChi   AND
             DETALLE.CODDOC  = CP-TPRO.CODDOC AND
             DETALLE.NroDoc BEGINS x-NroDoc   AND
             DETALLE.FCHVTO >= D-FchDes       AND
             DETALLE.FCHVTO <= D-FchHas       
             BREAK BY DETALLE.CODDO BY DETALLE.NRODOC :
        FI-MENSAJE = "Proveedor : " + DETALLE.CodAux + " Doc. : " + DETALLE.CodDoc +
                     " No. : " + DETALLE.NroDoc.
        DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.
        X-IMPORT[1] = 0.
        X-IMPORT[2] = 0.
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia = DETALLE.CODCIA AND
                 cb-dmov.Periodo = DETALLE.PERIODO AND
                 cb-dmov.Codcta  = DETALLE.CODCTA  AND
                 cb-dmov.Codaux  = DETALLE.codaux  AND
                 cb-dmov.CodDoc  = DETALLE.CodDoc  AND
                 cb-dmov.NroDoc  = DETALLE.NroDoc:
            IF cb-dmov.TpoMov THEN 
               ASSIGN X-IMPORT[1] = X-IMPORT[1] - cb-dmov.ImpMn1 
                      X-IMPORT[2] = X-IMPORT[2] - cb-dmov.ImpMn2.
            ELSE
               ASSIGN X-IMPORT[1] = X-IMPORT[1] + cb-dmov.ImpMn1 
                      X-IMPORT[2] = X-IMPORT[2] + cb-dmov.ImpMn2.
        END.
        IF (DETALLE.CodMon = 1 AND ROUND(ABSOLUTE(X-IMPORT[1]),2) > 0) OR
           (DETALLE.CodMon = 2 AND ROUND(ABSOLUTE(X-IMPORT[2]),2) > 0) THEN DO:
        /*IF ABSOLUTE(X-IMPORT[1]) > 0 OR ABSOLUTE(X-IMPORT[2]) > 0 THEN DO:*/
           CREATE DMOV.
           ASSIGN DMOV.CODCIA = S-CODCIA
                  DMOV.NroAst = DETALLE.NroAst
                  DMOV.CodOpe = DETALLE.CodOpe
                  DMOV.cco    = DETALLE.cco   
                  DMOV.Clfaux = DETALLE.Clfaux
                  DMOV.CndCmp = DETALLE.CndCmp
                  DMOV.Codaux = DETALLE.Codaux
                  DMOV.Codcta = DETALLE.Codcta
                  DMOV.CodDiv = DETALLE.CodDiv
                  DMOV.Coddoc = DETALLE.Coddoc
                  DMOV.Codmon = DETALLE.Codmon
                  DMOV.Codref = DETALLE.Codref
                  DMOV.DisCCo = DETALLE.DisCCo
                  DMOV.Fchdoc = DETALLE.Fchdoc
                  DMOV.Fchvto = DETALLE.Fchvto
                  DMOV.flgact = DETALLE.flgact
                  DMOV.Glodoc = DETALLE.Glodoc
                  DMOV.ImpMn1 = ROUND(ABSOLUTE(X-IMPORT[1]),2)
                  DMOV.ImpMn2 = ROUND(ABSOLUTE(X-IMPORT[2]),2)
                  DMOV.Nrodoc = DETALLE.Nrodoc
                  DMOV.Nroref = DETALLE.NroRef
                  DMOV.Nroruc = DETALLE.Nroruc
                  DMOV.OrdCmp = DETALLE.OrdCmp
                  DMOV.tm     = DETALLE.tm
                  DMOV.Tpocmb = DETALLE.Tpocmb
                  DMOV.TpoMov = NOT DETALLE.TpoMov
                  DMOV.CodBco = DETALLE.CodBco.
           IF DMOV.TpoMov THEN
              ASSIGN F-ImpMn1 = F-ImpMn1 - DMOV.ImpMn1
                     F-ImpMn2 = F-ImpMn2 - DMOV.ImpMn2.
           ELSE
              ASSIGN F-ImpMn1 = F-ImpMn1 + DMOV.ImpMn1
                     F-ImpMn2 = F-ImpMn2 + DMOV.ImpMn2.
        END.
    END.
END.
HIDE FRAME F-PROCESO.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

DISPLAY F-ImpMn1 F-ImpMn2 WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cambia-Orden B-table-Win 
PROCEDURE Cambia-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
I-ORDEN = IF I-ORDEN = 1 THEN 2 ELSE 1.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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

DEFINE VARIABLE dImpMn1 AS DECIMAL NO-UNDO.
DEFINE VARIABLE dImpMn2 AS DECIMAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
   ASSIGN 
    C-doc x-codaux X-CodDiv x-NroDoc D-FchDes D-FchHas 
    F-ExcDoc x-codbco x-Codmon
    d-FchEmi-1 d-FchEmi-2.
   IF C-doc = "Todos" THEN C-doc = "".
END.

DEFINE VARIABLE I-NroReg AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE X-IMPORT AS DECIMAL EXTENT 2 INIT 0  NO-UNDO.

/* BLANQUEMOS TEMPORAL */
DO TRANSACTION:
    FOR EACH DMOV:
        DELETE DMOV.
    END.
    FOR EACH DMOV-2:
        DELETE DMOV-2.
    END.
END.
F-ImpMn1 = 0.
F-ImpMn2 = 0.

/* RHC PARCHE: Corregimos las fechas de vencimiento */
DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    FOR EACH Cp-tpro NO-LOCK  WHERE Cp-tpro.CODCIA = CB-CODCIA AND
             Cp-tpro.CodDoc BEGINS C-doc AND
             LOOKUP(Cp-tpro.CodDoc,F-ExcDoc) = 0 AND
             Cp-tpro.CORRELATIVO = YES:
        IF Cp-tpro.CodCta BEGINS "102" THEN NEXT.
        IF Cp-tpro.CodCta BEGINS "4691" THEN NEXT.
        FOR EACH DETALLE WHERE DETALLE.CODCIA  = S-CODCIA  AND
                 DETALLE.PERIODO = S-PERIODO      AND
                 DETALLE.CODOPE  = CP-TPRO.CODOPE AND
                 DETALLE.CODCTA  = CP-TPRO.CODCTA AND
                 DETALLE.CodAux BEGINS x-codaux   AND
                 DETALLE.CODDOC  = CP-TPRO.CODDOC AND
                 DETALLE.NroDoc BEGINS x-NroDoc   AND
                 DETALLE.FCHVTO = ?               AND
                 DETALLE.TPOITM NE "N"            AND
                 DETALLE.CODDIV BEGINS x-CodDiv   AND
                 DETALLE.Codbco BEGINS x-codbco:
            FI-MENSAJE = "Proveedor : " + DETALLE.CodAux + " Doc. : " + DETALLE.CodDoc +
                         " No. : " + DETALLE.NroDoc.
            DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.
            DETALLE.FchVto = DETALLE.FchDoc.
        END.
    END.
END.

/* AHORA SI CARGAMOS LOS SALDOS POR DOCUMENTO */
DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    FOR EACH Cp-tpro NO-LOCK  WHERE Cp-tpro.CODCIA = CB-CODCIA AND
             Cp-tpro.CodDoc BEGINS C-doc AND
             LOOKUP(Cp-tpro.CodDoc,F-ExcDoc) = 0 AND
             Cp-tpro.CORRELATIVO = YES:
        IF Cp-tpro.CodCta BEGINS "102" THEN NEXT.
        IF Cp-tpro.CodCta BEGINS "4691" THEN NEXT.
        FOR EACH DETALLE NO-LOCK WHERE DETALLE.CODCIA  = S-CODCIA  AND
                 DETALLE.PERIODO = S-PERIODO      AND
                 DETALLE.CODOPE  = CP-TPRO.CODOPE AND
                 DETALLE.CODCTA  = CP-TPRO.CODCTA AND
                 DETALLE.CodAux BEGINS x-codaux   AND
                 DETALLE.CODDOC  = CP-TPRO.CODDOC AND
                 DETALLE.NroDoc BEGINS x-NroDoc   AND
                 DETALLE.FCHVTO >= D-FchDes       AND
                 DETALLE.FCHVTO <= D-FchHas       AND
                 DETALLE.FCHDOC >= d-FchEmi-1     AND
                 DETALLE.FCHDOC <= d-FchEmi-2     AND
                 DETALLE.TPOITM NE "N"            AND
                 DETALLE.CODDIV BEGINS x-CodDiv   AND
                 DETALLE.Codbco BEGINS x-codbco
                 BREAK BY DETALLE.CODDOC BY DETALLE.NRODOC :
            FI-MENSAJE = "Proveedor : " + DETALLE.CodAux + " Doc. : " + DETALLE.CodDoc +
                         " No. : " + DETALLE.NroDoc.
            DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.
            X-IMPORT[1] = 0.
            X-IMPORT[2] = 0.
            FOR EACH cb-dmov NO-LOCK WHERE
                cb-dmov.CodCia = DETALLE.CODCIA AND
                cb-dmov.Periodo = DETALLE.PERIODO AND
                cb-dmov.Codcta  = DETALLE.CODCTA  AND
                cb-dmov.Codaux  = DETALLE.codaux  AND
                cb-dmov.CodDoc  = DETALLE.CodDoc  AND
                cb-dmov.NroDoc  = DETALLE.NroDoc:
    /*Super parche MLR* ***
                IF cb-dmov.TpoMov THEN 
                    ASSIGN
                        X-IMPORT[1] = X-IMPORT[1] - cb-dmov.ImpMn1 
                        X-IMPORT[2] = X-IMPORT[2] - cb-dmov.ImpMn2.
                ELSE
                    ASSIGN
                        X-IMPORT[1] = X-IMPORT[1] + cb-dmov.ImpMn1 
                        X-IMPORT[2] = X-IMPORT[2] + cb-dmov.ImpMn2.
    * ***/

                IF NOT cb-dmov.tpomov THEN 
                    CASE x-codmon:
                        WHEN 1 THEN X-IMPORT[1] = X-IMPORT[1] - cb-dmov.ImpMn1.
                        WHEN 2 THEN X-IMPORT[2] = X-IMPORT[2] - cb-dmov.ImpMn2.
                    END CASE.
                ELSE 
                    CASE x-codmon:
                        WHEN 1 THEN X-IMPORT[1] = X-IMPORT[1] + cb-dmov.ImpMn1.
                        WHEN 2 THEN X-IMPORT[2] = X-IMPORT[2] + cb-dmov.ImpMn2.
                    END CASE.

            END.
            IF X-IMPORT[1] = 0 AND X-IMPORT[2] = 0 THEN NEXT.
    /*Super parche MLR* ***
            ASSIGN
                X-IMPORT[1] = DETALLE.ImpMn1 
                X-IMPORT[2] = DETALLE.ImpMn2.
    * ***/

            IF x-codmon = 1 THEN ASSIGN dImpMn1 = DETALLE.ImpMn1.
            ELSE ASSIGN dImpMn1 = DETALLE.ImpMn2.

            /* SOLO PASAN LAS 422 ACREEDORA */
            IF DETALLE.Codcta BEGINS "422" AND 
               NOT ( X-IMPORT[1] < 0 OR X-IMPORT[2] < 0 ) THEN NEXT.

            IF (DETALLE.CodMon = 1 AND ROUND(ABSOLUTE(X-IMPORT[1]),2) > 0) OR
               (DETALLE.CodMon = 2 AND ROUND(ABSOLUTE(X-IMPORT[2]),2) > 0) THEN DO:
            /*IF ABSOLUTE(X-IMPORT[1]) > 0 OR ABSOLUTE(X-IMPORT[2]) > 0 THEN DO:*/
               IF c-doc = 'LP' AND x-codmon <> 3 THEN
                  IF x-codmon <> DETALLE.CodMon THEN NEXT.

               CREATE DMOV.
               ASSIGN DMOV.CODCIA = S-CODCIA
                      DMOV.NroAst = DETALLE.NroAst
                      DMOV.CodOpe = DETALLE.CodOpe
                      DMOV.cco    = DETALLE.cco   
                      DMOV.Clfaux = DETALLE.Clfaux
                      DMOV.CndCmp = DETALLE.CndCmp
                      DMOV.Codaux = DETALLE.Codaux
                      DMOV.Codcta = DETALLE.Codcta
                      DMOV.CodDiv = DETALLE.CodDiv
                      DMOV.Coddoc = DETALLE.Coddoc
                      DMOV.Codmon = DETALLE.Codmon
                      DMOV.Codref = DETALLE.Codref
                      DMOV.DisCCo = DETALLE.DisCCo
                      DMOV.Fchdoc = DETALLE.Fchdoc
                      DMOV.Fchvto = DETALLE.Fchvto
                      DMOV.flgact = DETALLE.flgact
                      DMOV.Glodoc = DETALLE.Glodoc
                      DMOV.ImpMn1 = ROUND(ABSOLUTE(X-IMPORT[1]),2)
                      DMOV.ImpMn2 = ROUND(ABSOLUTE(X-IMPORT[2]),2)
                      DMOV.Nrodoc = DETALLE.Nrodoc
                      DMOV.Nroref = DETALLE.NroRef
                      DMOV.Nroruc = DETALLE.Nroruc
                      DMOV.OrdCmp = DETALLE.OrdCmp
                      DMOV.tm     = DETALLE.tm
                      DMOV.Tpocmb = DETALLE.Tpocmb
                      DMOV.TpoMov = IF DETALLE.Codcta BEGINS "422" THEN DETALLE.TpoMov ELSE NOT DETALLE.TpoMov
                      DMOV.CodBco = DETALLE.CodBco.

               IF DMOV.TpoMov THEN DO:
                  IF DMOV.ImpMn2 <> 0 THEN F-ImpMn2 = F-ImpMn2 - DMOV.ImpMn2.                     
                  ELSE F-ImpMn1 = F-ImpMn1 - DMOV.ImpMn1.           
               END.                 
               ELSE DO:
                  IF DMOV.ImpMn2 <> 0 THEN F-ImpMn2 = F-ImpMn2 + DMOV.ImpMn2.
                  ELSE F-ImpMn1 = F-ImpMn1 + DMOV.ImpMn1.
               END.   
                /* RHC 24.08.06 CALCULAMOS EL VENCIMIENTO PROYECTADO */
                CREATE DMOV-2.
                BUFFER-COPY DMOV TO DMOV-2.
                FIND GN-PROV WHERE GN-PROV.codcia = pv-codcia
                    AND GN-PROV.codpro = DMOV-2.CodAux NO-LOCK NO-ERROR.
                IF AVAILABLE GN-PROV AND GN-PROV.PrioridadPago <> '' THEN DO:
                    FIND FacTabla WHERE FacTabla.codcia = s-codcia
                        AND FacTabla.Tabla = 'PP'
                        AND FacTabla.Codigo = GN-PROV.PrioridadPago
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE FacTabla 
                    THEN CASE DMOV-2.CodDoc:
                            WHEN '01' THEN DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[1].
                            WHEN '37' THEN DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[2].
                            OTHERWISE DMOV-2.FchVto = DMOV-2.FchVto + FacTabla.Valor[1].
                        END CASE.
                END.
                /* ************************************************* */
            END.
        END.
    END.
END.
HIDE FRAME F-PROCESO.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

DISPLAY F-ImpMn1 F-ImpMn2 WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Backup B-table-Win 
PROCEDURE Carga-Temporal-Backup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   ASSIGN C-doc x-codaux X-CodDiv x-NroDoc D-FchDes D-FchHas F-ExcDoc x-codbco x-Codmon.
   IF C-doc = "Todos" THEN C-doc = "".
END.

DEFINE VARIABLE I-NroReg AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE X-IMPORT AS DECIMAL EXTENT 2 INIT 0  NO-UNDO.

/* BLANQUEMOS TEMPORAL */
FOR EACH DMOV:
    DELETE DMOV.
END.
F-ImpMn1 = 0.
F-ImpMn2 = 0.
/* CARGAMOS LOS SALDOS POR DOCUMENTO */
FOR EACH Cp-tpro NO-LOCK  WHERE Cp-tpro.CODCIA = CB-CODCIA AND
         Cp-tpro.CodDoc BEGINS C-doc AND
         LOOKUP(Cp-tpro.CodDoc,F-ExcDoc) = 0 AND
         Cp-tpro.CORRELATIVO = YES AND
         NOT Cp-tpro.CodCta BEGINS "102":
    FOR EACH DETALLE NO-LOCK WHERE DETALLE.CODCIA  = S-CODCIA  AND
             DETALLE.PERIODO = S-PERIODO      AND
             DETALLE.CODOPE  = CP-TPRO.CODOPE AND
             DETALLE.CODCTA  = CP-TPRO.CODCTA AND
             DETALLE.CodAux BEGINS x-codaux   AND
             DETALLE.CODDOC  = CP-TPRO.CODDOC AND
             DETALLE.NroDoc BEGINS x-NroDoc   AND
             DETALLE.FCHVTO >= D-FchDes       AND
             DETALLE.FCHVTO <= D-FchHas       AND
             DETALLE.TPOITM NE "N"            AND
             DETALLE.CODDIV BEGINS x-CodDiv   AND
             DETALLE.Codbco BEGINS x-codbco
             BREAK BY DETALLE.CODDO BY DETALLE.NRODOC :
        FI-MENSAJE = "Proveedor : " + DETALLE.CodAux + " Doc. : " + DETALLE.CodDoc +
                     " No. : " + DETALLE.NroDoc.
        DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.
        X-IMPORT[1] = 0.
        X-IMPORT[2] = 0.
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia = DETALLE.CODCIA AND
                 cb-dmov.Periodo = DETALLE.PERIODO AND
                 cb-dmov.Codcta  = DETALLE.CODCTA  AND
                 cb-dmov.Codaux  = DETALLE.codaux  AND
                 cb-dmov.CodDoc  = DETALLE.CodDoc  AND
                 cb-dmov.NroDoc  = DETALLE.NroDoc:
            IF cb-dmov.TpoMov THEN 
               ASSIGN X-IMPORT[1] = X-IMPORT[1] - cb-dmov.ImpMn1 
                      X-IMPORT[2] = X-IMPORT[2] - cb-dmov.ImpMn2.
            ELSE
               ASSIGN X-IMPORT[1] = X-IMPORT[1] + cb-dmov.ImpMn1 
                      X-IMPORT[2] = X-IMPORT[2] + cb-dmov.ImpMn2.
        END.

        /* SOLO PASAN LAS 422 ACREEDORA */
        IF DETALLE.Codcta BEGINS "422" AND 
           NOT ( X-IMPORT[1] < 0 OR X-IMPORT[2] < 0 ) THEN NEXT.

        IF (DETALLE.CodMon = 1 AND ROUND(ABSOLUTE(X-IMPORT[1]),2) > 0) OR
           (DETALLE.CodMon = 2 AND ROUND(ABSOLUTE(X-IMPORT[2]),2) > 0) THEN DO:
        /*IF ABSOLUTE(X-IMPORT[1]) > 0 OR ABSOLUTE(X-IMPORT[2]) > 0 THEN DO:*/
           IF c-doc = 'LP' AND x-codmon <> 3 THEN
              IF x-codmon <> DETALLE.CodMon THEN NEXT.

           CREATE DMOV.
           ASSIGN DMOV.CODCIA = S-CODCIA
                  DMOV.NroAst = DETALLE.NroAst
                  DMOV.CodOpe = DETALLE.CodOpe
                  DMOV.cco    = DETALLE.cco   
                  DMOV.Clfaux = DETALLE.Clfaux
                  DMOV.CndCmp = DETALLE.CndCmp
                  DMOV.Codaux = DETALLE.Codaux
                  DMOV.Codcta = DETALLE.Codcta
                  DMOV.CodDiv = DETALLE.CodDiv
                  DMOV.Coddoc = DETALLE.Coddoc
                  DMOV.Codmon = DETALLE.Codmon
                  DMOV.Codref = DETALLE.Codref
                  DMOV.DisCCo = DETALLE.DisCCo
                  DMOV.Fchdoc = DETALLE.Fchdoc
                  DMOV.Fchvto = DETALLE.Fchvto
                  DMOV.flgact = DETALLE.flgact
                  DMOV.Glodoc = DETALLE.Glodoc
                  DMOV.ImpMn1 = ROUND(ABSOLUTE(X-IMPORT[1]),2)
                  DMOV.ImpMn2 = ROUND(ABSOLUTE(X-IMPORT[2]),2)
                  DMOV.Nrodoc = DETALLE.Nrodoc
                  DMOV.Nroref = DETALLE.NroRef
                  DMOV.Nroruc = DETALLE.Nroruc
                  DMOV.OrdCmp = DETALLE.OrdCmp
                  DMOV.tm     = DETALLE.tm
                  DMOV.Tpocmb = DETALLE.Tpocmb
                  DMOV.TpoMov = IF DETALLE.Codcta BEGINS "422" THEN DETALLE.TpoMov ELSE NOT DETALLE.TpoMov
                  DMOV.CodBco = DETALLE.CodBco.
           IF DMOV.TpoMov THEN 
              ASSIGN F-ImpMn1 = F-ImpMn1 - DMOV.ImpMn1
                     F-ImpMn2 = F-ImpMn2 - DMOV.ImpMn2.                     
           ELSE
              ASSIGN F-ImpMn1 = F-ImpMn1 + DMOV.ImpMn1
                     F-ImpMn2 = F-ImpMn2 + DMOV.ImpMn2.
        END.
    END.
END.
HIDE FRAME F-PROCESO.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

DISPLAY F-ImpMn1 F-ImpMn2 WITH FRAME {&FRAME-NAME}.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel B-table-Win 
PROCEDURE Genera-Excel :
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

DEF VAR x-Column AS INT INIT 74 NO-UNDO.
DEF VAR x-Range  AS CHAR NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Range("C1"):Font:Bold = TRUE.
chWorkSheet:Range("C1"):Value = "FACTURAS POR PAGAR AL " + STRING(D-FCHHAS,"99/99/9999").

chWorkSheet:Range("A4:J4"):Font:Bold = TRUE.
chWorkSheet:Range("A4"):Value = "CODIGO".
chWorkSheet:Range("B4"):Value = "PROVEEDOR".
chWorkSheet:Range("C4"):Value = "COD.DOC".
chWorkSheet:Range("D4"):Value = "NUMERO".
chWorkSheet:Range("E4"):Value = "EMISION".
chWorkSheet:Range("F4"):Value = "VENCIMIENTO".
chWorkSheet:Range("G4"):Value = "SOLES".
chWorkSheet:Range("H4"):Value = "DOLARES".
chWorkSheet:Range("I4"):Value = "VCTO. PROYECTADO".

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */
iColumn = 4.

 FOR EACH DMOV ,
    FIRST DMOV-2 WHERE DMOV-2.CodCia = DMOV.CodCia
        AND DMOV-2.CodDoc = DMOV.CodDoc
        AND DMOV-2.NroDoc = DMOV.NroDoc
        AND DMOV-2.CodAux = DMOV.CodAux
        AND DMOV-2.CodCta = DMOV.CodCta
     BREAK BY DMOV.CodCia
            BY DMOV.Codaux
             BY DMOV.Fchvto
              BY DMOV.Coddoc:

     x-dol = DMOV.ImpMn2.
     x-sol = DMOV.ImpMn1.
     IF x-dol <> 0 THEN x-sol = 0.
     
     IF DMOV.TpoMov THEN 
       ASSIGN X-sol = x-sol * (-1)
              X-dol = x-dol * (-1).
     
     iColumn = iColumn + 1.
     cColumn = STRING(iColumn).
     cRange = "A" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + DMOV.CodAux.
     FIND Gn-Prov WHERE Gn-Prov.codcia = pv-codcia
        AND Gn-Prov.codpro = DMOV.CodAux
        NO-LOCK NO-ERROR.
     IF AVAILABLE Gn-Prov THEN DO:
         cRange = "B" + cColumn.
         chWorkSheet:Range(cRange):Value = Gn-Prov.NomPro.
     END.
     cRange = "C" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + STRING(DMOV.Coddoc,"99").
     cRange = "D" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + DMOV.nrodoc.
     cRange = "E" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV.Fchdoc.
     cRange = "F" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV.FchVto.
     cRange = "G" + cColumn.
     chWorkSheet:Range(cRange):Value = X-SOL.
     cRange = "H" + cColumn.
     chWorkSheet:Range(cRange):Value = X-DOL.
     cRange = "I" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV-2.FchVto.

    FI-MENSAJE = "    Documento Nro: " + DMOV.nrodoc.
    DISPLAY Fi-Mensaje WITH FRAME F-Proceso.

    /* RHC 09.08.06 En caso de LETRAS (37) */
    IF DMOV.CodDoc = '37' THEN DO:
        x-Column = 75.
        x-Range = ''.
        FOR EACH Cb-dmov NO-LOCK WHERE Cb-dmov.codcia = DMOV.codcia
                AND Cb-dmov.codope = DMOV.codope
                AND Cb-dmov.nroast = DMOV.nroast
                AND Cb-dmov.periodo = s-periodo
                AND Cb-dmov.coddoc = '01':
            IF x-Column > 90
            THEN ASSIGN
                    x-Column = 65
                    x-Range  = 'A'.
                    
            cRange = TRIM(x-Range) + TRIM(CHR(x-Column)) + cColumn.
            chWorkSheet:Range(cRange):Value = Cb-dmov.nrodoc.
            x-Column = x-Column + 1.
        END.
    END.
    /* *********************************** */
 end.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

HIDE FRAME F-Proceso NO-PAUSE.

MESSAGE 'Proceso Terminado con Éxito' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/*
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

DEF VAR x-Column AS INT INIT 74 NO-UNDO.
DEF VAR x-Range  AS CHAR NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Range("C1"):Font:Bold = TRUE.
chWorkSheet:Range("C1"):Value = "FACTURAS POR PAGAR AL " + STRING(D-FCHHAS,"99/99/9999").

chWorkSheet:Range("A4:J4"):Font:Bold = TRUE.
chWorkSheet:Range("A4"):Value = "FECHA".
chWorkSheet:Range("B4"):Value = "PROVEEDOR".
chWorkSheet:Range("C4"):Value = "RUCPROVEEDOR".
chWorkSheet:Range("D4"):Value = "COD.DOC".
chWorkSheet:Range("E4"):Value = "NUMERO".
chWorkSheet:Range("F4"):Value = "C.COSTO".
chWorkSheet:Range("G4"):Value = "VCTO".
chWorkSheet:Range("H4"):Value = "SOLES".
chWorkSheet:Range("I4"):Value = "DOLARES".
chWorkSheet:Range("J4"):Value = "VCTO. PROYECTADO".

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */
iColumn = 4.

 FOR EACH DMOV ,
    FIRST DMOV-2 WHERE DMOV-2.CodCia = DMOV.CodCia
        AND DMOV-2.CodDoc = DMOV.CodDoc
        AND DMOV-2.NroDoc = DMOV.NroDoc
        AND DMOV-2.CodAux = DMOV.CodAux
        AND DMOV-2.CodCta = DMOV.CodCta
     BREAK BY DMOV.CodCia
            BY DMOV.Codaux
             BY DMOV.Fchvto
              BY DMOV.Coddoc:

     x-dol = DMOV.ImpMn2.
     x-sol = DMOV.ImpMn1.
     IF x-dol <> 0 THEN x-sol = 0.
     
     IF DMOV.TpoMov THEN 
       ASSIGN X-sol = x-sol * (-1)
              X-dol = x-dol * (-1).
     
     iColumn = iColumn + 1.
     cColumn = STRING(iColumn).
     cRange = "A" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV.Fchdoc.
     cRange = "B" + cColumn.
     chWorkSheet:Range(cRange):Value = ENTRY(1,DMOV.Glodoc,"-").
     cRange = "C" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + DMOV.NRORUC.
     cRange = "D" + cColumn.
     chWorkSheet:Range(cRange):Value = STRING(DMOV.Coddoc,"99").
     cRange = "E" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + DMOV.nrodoc.
     cRange = "F" + cColumn.
     chWorkSheet:Range(cRange):Value = IF NUM-ENTRIES(DMOV.Glodoc,"-") > 1 THEN ENTRY(2,DMOV.Glodoc,"-") ELSE "".
     cRange = "G" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV.FchVto.
     cRange = "H" + cColumn.
     chWorkSheet:Range(cRange):Value = X-SOL.
     cRange = "I" + cColumn.
     chWorkSheet:Range(cRange):Value = X-DOL.
     cRange = "J" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV-2.FchVto.
     
    /* RHC 09.08.06 En caso de LETRAS (37) */
    IF DMOV.CodDoc = '37' THEN DO:
        x-Column = 75.
        x-Range = ''.
        FOR EACH Cb-dmov NO-LOCK WHERE Cb-dmov.codcia = DMOV.codcia
                AND Cb-dmov.codope = DMOV.codope
                AND Cb-dmov.nroast = DMOV.nroast
                AND Cb-dmov.periodo = s-periodo
                AND Cb-dmov.coddoc = '01':
            IF x-Column > 90
            THEN ASSIGN
                    x-Column = 65
                    x-Range  = 'A'.
                    
            cRange = TRIM(x-Range) + TRIM(CHR(x-Column)) + cColumn.
            chWorkSheet:Range(cRange):Value = Cb-dmov.nrodoc.
            x-Column = x-Column + 1.
        END.
    END.
    /* *********************************** */
 end.

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime B-table-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF I-ORDEN = 1 THEN RUN Imprime-por-Vencimiento.
ELSE RUN Imprime-por-Proveedor.   
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-por-Proveedor B-table-Win 
PROCEDURE Imprime-por-Proveedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 DEFINE FRAME f-cab
        DMOV.CodAux COLUMN-LABEL "Codigo"
        DMOV.GloDoc COLUMN-LABEL "Nombre o Razon Social"
        DMOV.coddoc COLUMN-LABEL "Cod.!Doc."
        DMOV.nrodoc COLUMN-LABEL "Numero!Documento"
        DMOV.fchvto COLUMN-LABEL " Fecha!Vencimiento" FORMAT "99/99/9999"
        DMOV.Fchdoc COLUMN-LABEL "Octavo Dia" FORMAT "99/99/9999" 
        x-dol 
        x-sol 
        DMOV.NroAst COLUMN-LABEL "Voucher" FORMAT "X(7)"
        DMOV.CodOpe COLUMN-LABEL "Libro"
        HEADER
        S-NOMCIA
        "DOCUMENTOS PENDIENTES" TO 75
        "FECHA : " TO 123 TODAY TO 133  SKIP
        "VENCIMIENTOS DEL : " D-FchDes " AL " D-FchHas
        "PAGINA : " TO 123 PAGE-NUMBER(report) FORMAT "ZZ9" TO 133 SKIP(2)
        "----------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                        Cod. Numero      Fecha                                                              " SKIP
        "Codigo   Nombre o Razon Social          Doc. Documento  Vencimient Octavo Dia    Importe(US$)    Importe(S/.)  Voucher Libro" SKIP
        "----------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

/* OUTPUT STREAM report TO C:\TMP\PRUEBA.PRN PAGED PAGE-SIZE 62. */
 OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. 
 PUT STREAM report CONTROL  {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3} .
 FOR EACH DMOV 
     BREAK BY DMOV.CodCia
            BY DMOV.Codaux
             BY DMOV.Fchvto
              BY DMOV.Coddoc:

     x-dol = DMOV.ImpMn2.
     x-sol = DMOV.ImpMn1.
     IF x-dol <> 0 THEN x-sol = 0.

     DISPLAY STREAM report 
             DMOV.CodAux
             DMOV.GloDoc
             DMOV.coddoc
             DMOV.nrodoc
             DMOV.fchvto
             DMOV.fchvto + 8 @ DMOV.FchDoc
             x-dol
             x-sol
             DMOV.NroAst 
             DMOV.CodOpe WITH FRAME F-Cab.
     x-ImpMn1 = IF DMOV.TpoMov THEN - x-sol ELSE x-sol.
     x-ImpMn2 = IF DMOV.TpoMov THEN - x-dol ELSE x-dol.
     ACCUMULATE x-ImpMn1 (TOTAL BY DMOV.codcia).
     ACCUMULATE x-ImpMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE x-ImpMn1 (SUB-TOTAL BY DMOV.CodAux).
     ACCUMULATE x-ImpMn2 (SUB-TOTAL BY DMOV.CodAux).
     IF LAST-OF(DMOV.CodAux) THEN DO:
        UNDERLINE STREAM report DMOV.GloDoc
                                x-dol
                                x-sol
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  ("TOTAL PROV. " + DMOV.CodAux) @ DMOV.GloDoc
                       ACCUM SUB-TOTAL BY (DMOV.CodAux) x-ImpMn2 @ x-dol
                       ACCUM SUB-TOTAL BY (DMOV.CodAux) x-ImpMn1 @ x-sol
                       WITH FRAME F-Cab.
        UNDERLINE STREAM report DMOV.GloDoc
                                x-dol
                                x-sol
                                WITH FRAME f-cab.
     END.
     IF LAST-OF(DMOV.CodCia) THEN DO:
        UNDERLINE STREAM report DMOV.GloDoc
                                x-dol
                                x-sol
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  "TOTAL GENERAL " @ DMOV.GloDoc
                       ACCUM TOTAL BY (DMOV.CodCia) x-ImpMn2 @ x-dol
                       ACCUM TOTAL BY (DMOV.CodCia) x-ImpMn1 @ x-sol
                       WITH FRAME F-Cab.
     END.
 END.
 PAGE STREAM report.
 OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-por-Proveedor-Backup B-table-Win 
PROCEDURE Imprime-por-Proveedor-Backup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
 DEFINE VAR x-ImpMn1  AS DECIMAL.
 DEFINE VAR x-ImpMn2  AS DECIMAL.
 DEFINE FRAME f-cab
        DMOV.CodAux COLUMN-LABEL "Codigo"
        DMOV.GloDoc COLUMN-LABEL "Nombre o Razon Social"
        DMOV.coddoc COLUMN-LABEL "Cod.!Doc."
        DMOV.nrodoc COLUMN-LABEL "Numero!Documento"
        DMOV.fchvto COLUMN-LABEL " Fecha!Vencimiento" FORMAT "99/99/9999"
        DMOV.Fchdoc COLUMN-LABEL "Octavo Dia" FORMAT "99/99/9999" 
        DMOV.ImpMn2 
        DMOV.ImpMn1 
        DMOV.TpoCmb 
        DMOV.NroAst COLUMN-LABEL "Voucher" FORMAT "X(7)"
        DMOV.CodOpe COLUMN-LABEL "Libro"
        HEADER
        S-NOMCIA
        "DOCUMENTOS PENDIENTES" TO 75
        "FECHA : " TO 123 TODAY TO 133  SKIP
        "VENCIMIENTOS DEL : " D-FchDes " AL " D-FchHas
        "PAGINA : " TO 123 PAGE-NUMBER(report) FORMAT "ZZ9" TO 133 SKIP(2)
        "-------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                        Cod. Numero      Fecha                                                                       " SKIP
        "Codigo   Nombre o Razon Social          Doc. Documento  Vencimient Octavo Dia    Importe(US$)    Importe(S/.)  T/Cambio Voucher Libro" SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

/* OUTPUT STREAM report TO C:\TMP\PRUEBA.PRN PAGED PAGE-SIZE 62. */
 OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. 
 PUT STREAM report CONTROL  {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3} .
 FOR EACH DMOV 
     BREAK BY DMOV.CodCia
            BY DMOV.Codaux
             BY DMOV.Fchvto
              BY DMOV.Coddoc:
     DISPLAY STREAM report 
             DMOV.CodAux
             DMOV.GloDoc
             DMOV.coddoc
             DMOV.nrodoc
             DMOV.fchvto
             DMOV.fchvto + 8 @ DMOV.FchDoc
             DMOV.ImpMn1 
             DMOV.ImpMn2 
             DMOV.TpoCmb 
             DMOV.NroAst 
             DMOV.CodOpe WITH FRAME F-Cab.
     x-ImpMn1 = IF DMOV.TpoMov THEN - DMOV.ImpMn1 ELSE DMOV.ImpMn1.
     x-ImpMn2 = IF DMOV.TpoMov THEN - DMOV.ImpMn2 ELSE DMOV.ImpMn2.
     ACCUMULATE x-ImpMn1 (TOTAL BY DMOV.codcia).
     ACCUMULATE x-ImpMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE x-ImpMn1 (SUB-TOTAL BY DMOV.CodAux).
     ACCUMULATE x-ImpMn2 (SUB-TOTAL BY DMOV.CodAux).
     IF LAST-OF(DMOV.CodAux) THEN DO:
        UNDERLINE STREAM report DMOV.GloDoc
                                DMOV.ImpMn1
                                DMOV.ImpMn2
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  ("TOTAL PROV. " + DMOV.CodAux) @ DMOV.GloDoc
                       ACCUM SUB-TOTAL BY (DMOV.CodAux) x-ImpMn1 @ DMOV.ImpMn1
                       ACCUM SUB-TOTAL BY (DMOV.CodAux) x-ImpMn2 @ DMOV.ImpMn2
                       WITH FRAME F-Cab.
        UNDERLINE STREAM report DMOV.GloDoc
                                DMOV.ImpMn1
                                DMOV.ImpMn2
                                WITH FRAME f-cab.
     END.
     IF LAST-OF(DMOV.CodCia) THEN DO:
        UNDERLINE STREAM report DMOV.GloDoc
                                DMOV.ImpMn1
                                DMOV.ImpMn2
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  "TOTAL GENERAL " @ DMOV.GloDoc
                       ACCUM TOTAL BY (DMOV.CodCia) x-ImpMn1 @ DMOV.ImpMn1
                       ACCUM TOTAL BY (DMOV.CodCia) x-ImpMn2 @ DMOV.ImpMn2
                       WITH FRAME F-Cab.
     END.
 END.
 PAGE STREAM report.
 OUTPUT STREAM report CLOSE.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-por-Vencimiento B-table-Win 
PROCEDURE Imprime-por-Vencimiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE FRAME f-cab
        DMOV.CodAux COLUMN-LABEL "Codigo"
        DMOV.GloDoc COLUMN-LABEL "Nombre o Razon Social"
        DMOV.coddoc COLUMN-LABEL "Cod.!Doc."
        DMOV.nrodoc COLUMN-LABEL "Numero!Documento"
        DMOV.fchvto COLUMN-LABEL " Fecha!Vencimiento" FORMAT "99/99/9999"
        DMOV.Fchdoc COLUMN-LABEL "Octavo Dia" FORMAT "99/99/9999" 
        x-dol 
        x-sol 
        DMOV.NroAst COLUMN-LABEL "Voucher" FORMAT "X(7)"
        DMOV.CodOpe COLUMN-LABEL "Libro"
        HEADER
        S-NOMCIA
        "DOCUMENTOS PENDIENTES" TO 75
        "FECHA : " TO 123 TODAY TO 133  SKIP
        "VENCIMIENTOS DEL : " D-FchDes " AL " D-FchHas
        "PAGINA : " TO 123 PAGE-NUMBER(report) FORMAT "ZZ9" TO 133 SKIP(2)
        "----------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                        Cod. Numero      Fecha                                                              " SKIP
        "Codigo   Nombre o Razon Social          Doc. Documento  Vencimient Octavo Dia    Importe(US$)    Importe(S/.)  Voucher Libro" SKIP
        "----------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

/* OUTPUT STREAM report TO C:\TMP\PRUEBA.PRN PAGED PAGE-SIZE 62. */
 OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. 
 PUT STREAM report CONTROL  {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3} .
 FOR EACH DMOV 
     BREAK BY DMOV.CodCia
            BY DMOV.Fchvto
             BY DMOV.Codaux
              BY DMOV.Coddoc:

     x-dol = DMOV.ImpMn2.
     x-sol = DMOV.ImpMn1.
     IF x-dol <> 0 THEN x-sol = 0.

     DISPLAY STREAM report 
             DMOV.CodAux
             DMOV.GloDoc
             DMOV.coddoc
             DMOV.nrodoc
             DMOV.fchvto
             DMOV.fchvto + 8 @ DMOV.FchDoc
             x-dol 
             x-sol 
             DMOV.NroAst 
             DMOV.CodOpe WITH FRAME F-Cab.
     x-ImpMn1 = IF DMOV.TpoMov THEN - x-sol ELSE x-sol.
     x-ImpMn2 = IF DMOV.TpoMov THEN - x-dol ELSE x-dol.
     ACCUMULATE x-ImpMn1 (TOTAL BY DMOV.codcia).
     ACCUMULATE x-ImpMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE x-ImpMn1 (SUB-TOTAL BY DMOV.FchVto).
     ACCUMULATE x-ImpMn2 (SUB-TOTAL BY DMOV.FchVto).
     IF LAST-OF(DMOV.FchVto) THEN DO:
        UNDERLINE STREAM report DMOV.GloDoc
                                x-dol
                                x-sol
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  ("TOTAL DEL " + STRING(DMOV.FchVto)) @ DMOV.GloDoc
                       ACCUM SUB-TOTAL BY (DMOV.FchVto) x-ImpMn2 @ x-dol
                       ACCUM SUB-TOTAL BY (DMOV.FchVto) x-ImpMn1 @ x-sol
                       WITH FRAME F-Cab.
        UNDERLINE STREAM report DMOV.GloDoc
                                x-dol
                                x-sol
                                WITH FRAME f-cab.
     END.
     IF LAST-OF(DMOV.CodCia) THEN DO:
        UNDERLINE STREAM report DMOV.GloDoc
                                x-dol
                                x-sol
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  "TOTAL GENERAL " @ DMOV.GloDoc
                       ACCUM TOTAL BY (DMOV.CodCia) x-ImpMn2 @ x-dol
                       ACCUM TOTAL BY (DMOV.CodCia) x-ImpMn1 @ x-sol
                       WITH FRAME F-Cab.
     END.
 END.
 PAGE STREAM report.
 OUTPUT STREAM report CLOSE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-por-Vencimiento-Backup B-table-Win 
PROCEDURE Imprime-por-Vencimiento-Backup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-ImpMn1  AS DECIMAL.
DEFINE VAR x-ImpMn2  AS DECIMAL.
 DEFINE FRAME f-cab
        DMOV.CodAux COLUMN-LABEL "Codigo"
        DMOV.GloDoc COLUMN-LABEL "Nombre o Razon Social"
        DMOV.coddoc COLUMN-LABEL "Cod.!Doc."
        DMOV.nrodoc COLUMN-LABEL "Numero!Documento"
        DMOV.fchvto COLUMN-LABEL " Fecha!Vencimiento" FORMAT "99/99/9999"
        DMOV.Fchdoc COLUMN-LABEL "Octavo Dia" FORMAT "99/99/9999" 
        DMOV.ImpMn2 
        DMOV.ImpMn1 
        DMOV.TpoCmb 
        DMOV.NroAst COLUMN-LABEL "Voucher" FORMAT "X(7)"
        DMOV.CodOpe COLUMN-LABEL "Libro"
        HEADER
        S-NOMCIA
        "DOCUMENTOS PENDIENTES" TO 75
        "FECHA : " TO 123 TODAY TO 133  SKIP
        "VENCIMIENTOS DEL : " D-FchDes " AL " D-FchHas
        "PAGINA : " TO 123 PAGE-NUMBER(report) FORMAT "ZZ9" TO 133 SKIP(2)
        "-------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                        Cod. Numero      Fecha                                                                       " SKIP
        "Codigo   Nombre o Razon Social          Doc. Documento  Vencimient Octavo Dia    Importe(US$)    Importe(S/.)  T/Cambio Voucher Libro" SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

/* OUTPUT STREAM report TO C:\TMP\PRUEBA.PRN PAGED PAGE-SIZE 62. */
 OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. 
 PUT STREAM report CONTROL  {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3} .
 FOR EACH DMOV 
     BREAK BY DMOV.CodCia
            BY DMOV.Fchvto
             BY DMOV.Codaux
              BY DMOV.Coddoc:
     DISPLAY STREAM report 
             DMOV.CodAux
             DMOV.GloDoc
             DMOV.coddoc
             DMOV.nrodoc
             DMOV.fchvto
             DMOV.fchvto + 8 @ DMOV.FchDoc
             DMOV.ImpMn1 
             DMOV.ImpMn2 
             DMOV.TpoCmb 
             DMOV.NroAst 
             DMOV.CodOpe WITH FRAME F-Cab.
     x-ImpMn1 = IF DMOV.TpoMov THEN - DMOV.ImpMn1 ELSE DMOV.ImpMn1.
     x-ImpMn2 = IF DMOV.TpoMov THEN - DMOV.ImpMn2 ELSE DMOV.ImpMn2.
     ACCUMULATE x-ImpMn1 (TOTAL BY DMOV.codcia).
     ACCUMULATE x-ImpMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE x-ImpMn1 (SUB-TOTAL BY DMOV.FchVto).
     ACCUMULATE x-ImpMn2 (SUB-TOTAL BY DMOV.FchVto).
     IF LAST-OF(DMOV.FchVto) THEN DO:
        UNDERLINE STREAM report DMOV.GloDoc
                                DMOV.ImpMn1
                                DMOV.ImpMn2
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  ("TOTAL DEL " + STRING(DMOV.FchVto)) @ DMOV.GloDoc
                       ACCUM SUB-TOTAL BY (DMOV.FchVto) x-ImpMn1 @ DMOV.ImpMn1
                       ACCUM SUB-TOTAL BY (DMOV.FchVto) x-ImpMn2 @ DMOV.ImpMn2
                       WITH FRAME F-Cab.
        UNDERLINE STREAM report DMOV.GloDoc
                                DMOV.ImpMn1
                                DMOV.ImpMn2
                                WITH FRAME f-cab.
     END.
     IF LAST-OF(DMOV.CodCia) THEN DO:
        UNDERLINE STREAM report DMOV.GloDoc
                                DMOV.ImpMn1
                                DMOV.ImpMn2
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  "TOTAL GENERAL " @ DMOV.GloDoc
                       ACCUM TOTAL BY (DMOV.CodCia) x-ImpMn1 @ DMOV.ImpMn1
                       ACCUM TOTAL BY (DMOV.CodCia) x-ImpMn2 @ DMOV.ImpMn2
                       WITH FRAME F-Cab.
     END.
 END.
 PAGE STREAM report.
 OUTPUT STREAM report CLOSE.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME} :
     DEF VAR L-DOCS AS CHAR INIT "Todos".
     FOR EACH CP-TPRO NO-LOCK  WHERE CP-TPRO.CODCIA = CB-CODCIA  AND
               CP-TPRO.CORRELATIVO = YES BREAK BY CP-TPRO.CODDOC:
         IF FIRST-OF(CP-TPRO.CODDOC) THEN DO:
             ASSIGN L-DOCS = L-DOCS + "," + CP-TPRO.CODDOC .
         END.
     END.
     IF L-DOCS <> "" THEN DO:
        C-DOC:LIST-ITEMS = L-DOCS.
        C-DOC = ENTRY(1,L-DOCS).
     END.
     D-FchDes = TODAY - DAY(TODAY) + 1.
     D-FchHas = TODAY.
     d-FchEmi-1 = DATE(01,01,YEAR(TODAY)).
     d-FchEmi-2 = TODAY.
     FIND FIRST GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA NO-LOCK NO-ERROR.
     IF AVAILABLE GN-DIVI THEN X-CodDiv =GN-DIVI.CodDiv.
     DISPLAY X-CodDiv C-doc D-FchDes D-FchHas d-FchEmi-1 d-FchEmi-2.
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
        WHEN "x-ClfAux" THEN ASSIGN input-var-1 = "01".
        WHEN "CodBco"   THEN ASSIGN input-var-1 = "04".
        WHEN "F-CjaChi" THEN ASSIGN input-var-1 = "CCH".
        /*
            ASSIGN
                input-var-1 = ""
                input-var-2 = ""
                input-var-3 = "".
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
  {src/adm/template/snd-list.i "DMOV"}

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

