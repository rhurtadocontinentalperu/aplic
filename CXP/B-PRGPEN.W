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

DEFINE TEMP-TABLE DMOV LIKE cb-dmov.

DEFINE VARIABLE I-ORDEN AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA  AS CHAR.
DEFINE SHARED VARIABLE x-flag AS LOGICAL.

DEFINE BUFFER DETALLE FOR cb-dmov.

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
     WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
          SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
          BGCOLOR 15 FGCOLOR 0 
          TITLE "Procesando ..." FONT 7.

DEFINE VAR x-titulo  AS CHAR.

IF x-flag THEN x-titulo = 'PROGRAMACIONES CANCELADAS'.
ELSE x-titulo = 'PROGRAMACIONES PENDIENTES'.

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
&Scoped-define FIELDS-IN-QUERY-br_table DMOV.CodAux DMOV.Coddoc DMOV.Nrodoc DMOV.CodBco DMOV.Fchdoc DMOV.Fchvto DMOV.GloDoc DMOV.TpoMov DMOV.ImpMn1 DMOV.ImpMn2 DMOV.TpoCmb DMOV.Codref DMOV.Nroref DMOV.NroAst DMOV.CodOpe   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table IF I-ORDEN = 1 THEN OPEN QUERY {&SELF-NAME} FOR EACH DMOV NO-LOCK    BY DMOV.CodCia     BY DMOV.Fchvto      BY DMOV.Codaux       BY DMOV.Coddoc        BY DMOV.Nrodoc     INDEXED-REPOSITION. ELSE OPEN QUERY {&SELF-NAME} FOR EACH DMOV NO-LOCK    BY DMOV.CodCia     BY DMOV.Codaux      BY DMOV.Fchvto       BY DMOV.Coddoc        BY DMOV.Nrodoc     INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table DMOV
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DMOV


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS F-CjaChi X-CodDiv D-FchDes D-FchHas x-codaux ~
C-doc x-NroDoc F-ExcDoc br_table RECT-3 
&Scoped-Define DISPLAYED-OBJECTS F-CjaChi X-CodDiv D-FchDes D-FchHas ~
x-codaux C-doc x-NroDoc F-ExcDoc F-ImpMn1 F-ImpMn2 

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

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 2.92.

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
      DMOV.Fchdoc COLUMN-LABEL "Fecha!Prog/Pago " FORMAT "99/99/9999"
      DMOV.Fchvto COLUMN-LABEL "Fecha Vncmto"
      DMOV.GloDoc FORMAT "X(25)"
      DMOV.TpoMov 
      DMOV.ImpMn1 
      DMOV.ImpMn2 
      DMOV.TpoCmb 
      DMOV.Codref COLUMN-LABEL "Nro.Rol" FORMAT 'X(6)'
      DMOV.Nroref COLUMN-LABEL "Cheque" FORMAT 'X(10)'
      DMOV.NroAst COLUMN-LABEL "Vaucher"
      DMOV.CodOpe COLUMN-LABEL "Libro"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 85.72 BY 10.54
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CjaChi AT ROW 2.92 COL 30.14 COLON-ALIGNED
     X-CodDiv AT ROW 1.27 COL 9 COLON-ALIGNED
     D-FchDes AT ROW 1.27 COL 38 COLON-ALIGNED
     D-FchHas AT ROW 1.27 COL 68 COLON-ALIGNED
     x-codaux AT ROW 2 COL 9 COLON-ALIGNED
     C-doc AT ROW 2 COL 38 COLON-ALIGNED
     x-NroDoc AT ROW 2 COL 68 COLON-ALIGNED
     F-ExcDoc AT ROW 2.92 COL 9 COLON-ALIGNED
     F-ImpMn1 AT ROW 2.92 COL 49.86 COLON-ALIGNED
     F-ImpMn2 AT ROW 2.92 COL 68 COLON-ALIGNED
     br_table AT ROW 3.96 COL 1
     "TOTAL" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 3.04 COL 41.43
     RECT-3 AT ROW 1 COL 1
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
         HEIGHT             = 13.5
         WIDTH              = 85.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table F-ImpMn2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpMn1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpMn2 IN FRAME F-Main
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
FOR EACH cp-drol NO-LOCK  WHERE cp-drol.CodCia = s-CodCia AND 
    (cp-drol.FchVto >= D-FchDes AND cp-drol.FchVto <= D-FchHas ) AND
    cp-drol.FlgPgo = x-flag AND 
    cp-drol.CodDoc BEGINS C-Doc AND
    cp-drol.codaux BEGINS x-codaux AND 
    cp-drol.nrodoc BEGINS x-nrodoc AND
    cp-drol.coddiv BEGINS x-coddiv AND
    cp-drol.codcta BEGINS '102' BREAK BY cp-drol.NroRol:
    FI-MENSAJE = "Proveedor : " + DETALLE.CodAux + " Doc. : " + DETALLE.CodDoc +
                 " No. : " + DETALLE.NroDoc.
    DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.
     CREATE DMOV.
     ASSIGN DMOV.CODCIA = S-CODCIA
            DMOV.NroAst = cp-drol.NroAst
            DMOV.CodOpe = cp-drol.CodOpe
            DMOV.cco    = cp-drol.cco   
            DMOV.Clfaux = cp-drol.Clfaux
            DMOV.Codaux = cp-drol.Codaux
            DMOV.Codcta = cp-drol.Codcta
            DMOV.CodDiv = cp-drol.CodDiv
            DMOV.Coddoc = cp-drol.Coddoc
            DMOV.Codmon = cp-drol.Codmon
            DMOV.Fchdoc = cp-drol.Fchdoc
            DMOV.Fchvto = cp-drol.Fchvto
            DMOV.ImpMn1 = cp-drol.Sdomn1
            DMOV.ImpMn2 = cp-drol.Sdomn2
            DMOV.Nrodoc = cp-drol.Nrodoc
            DMOV.Glodoc = cp-drol.glosa
            DMOV.Tpocmb = IF cp-drol.Sdomn2 > 0 THEN ROUND(cp-drol.Sdomn1 / cp-drol.Sdomn2, 2) ELSE cp-drol.tpocmb
            DMOV.TpoMov = IF cp-drol.Codcta BEGINS "422" THEN cp-drol.TpoMov ELSE NOT cp-drol.TpoMov
            DMOV.CodBco = cp-drol.CodBco
            DMOV.Codref = STRING(cp-drol.nrorol, '999999').
     IF DMOV.TpoMov THEN
        ASSIGN F-ImpMn1 = F-ImpMn1 - DMOV.ImpMn1
               F-ImpMn2 = F-ImpMn2 - DMOV.ImpMn2.
     ELSE
        ASSIGN F-ImpMn1 = F-ImpMn1 + DMOV.ImpMn1
               F-ImpMn2 = F-ImpMn2 + DMOV.ImpMn2.
     FIND cp-crol WHERE cp-crol.CodCia = s-codcia AND 
          cp-crol.Periodo = cp-drol.Periodo AND 
          cp-crol.Nromes = cp-drol.nromes AND
          cp-crol.Nrorol = cp-drol.nrorol NO-LOCK NO-ERROR.
     IF AVAILABLE cp-crol THEN 
        ASSIGN
           DMOV.Nroref = cp-crol.NroChq.

     IF x-flag THEN 
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia = S-CODCIA AND
                cb-dmov.Periodo = S-PERIODO AND
                cb-dmov.Codcta  = cp-drol.Codcta  AND
                cb-dmov.Codaux  = cp-drol.CodAux  AND
                cb-dmov.CodDoc  = cp-drol.Coddoc  AND
                cb-dmov.NroDoc  = cp-drol.Nrodoc :
           FIND cb-cmov WHERE cb-cmov.Codcia = cb-dmov.codcia AND
                cb-cmov.Periodo = cb-dmov.Periodo AND
                cb-cmov.Nromes  = cb-dmov.Nromes AND
                cb-cmov.Codope  = cb-dmov.Codope AND
                cb-cmov.Nroast  = cb-dmov.Nroast NO-LOCK NO-ERROR.
           IF AVAILABLE cb-cmov AND cb-cmov.Nrochq <> "" THEN 
              ASSIGN
                 DMOV.NroREF = cb-cmov.Nrochq
                 DMOV.FchDoc = cb-cmov.Fchast
                 DMOV.Codope = cb-cmov.Codope
                 DMOV.NroAst = cb-cmov.nroast.
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
DO WITH FRAME {&FRAME-NAME}:
   ASSIGN C-doc x-codaux X-CodDiv x-NroDoc D-FchDes D-FchHas F-ExcDoc.
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
FOR EACH cp-drol NO-LOCK  WHERE cp-drol.CodCia = s-CodCia AND 
    (cp-drol.FchVto >= D-FchDes AND cp-drol.FchVto <= D-FchHas ) AND
    cp-drol.FlgPgo = x-flag AND 
    cp-drol.CodDoc BEGINS C-Doc AND
    cp-drol.codaux BEGINS x-codaux AND 
    cp-drol.nrodoc BEGINS x-nrodoc AND
    cp-drol.coddiv BEGINS x-coddiv BREAK BY cp-drol.NroRol:

    FI-MENSAJE = "Proveedor : " + cp-drol.CodAux + " Doc. : " + cp-drol.CodDoc +
                 " No. : " + cp-drol.NroDoc.
    DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.
     CREATE DMOV.
     ASSIGN DMOV.CODCIA = S-CODCIA
            DMOV.NroAst = cp-drol.NroAst
            DMOV.CodOpe = cp-drol.CodOpe
            DMOV.cco    = cp-drol.cco   
            DMOV.Clfaux = cp-drol.Clfaux
            DMOV.Codaux = cp-drol.Codaux
            DMOV.Codcta = cp-drol.Codcta
            DMOV.CodDiv = cp-drol.CodDiv
            DMOV.Coddoc = cp-drol.Coddoc
            DMOV.Codmon = cp-drol.Codmon
            DMOV.Fchdoc = cp-drol.Fchdoc
            DMOV.Fchvto = cp-drol.Fchvto
            DMOV.ImpMn1 = cp-drol.Sdomn1
            DMOV.ImpMn2 = cp-drol.Sdomn2
            DMOV.Nrodoc = cp-drol.Nrodoc
            DMOV.Glodoc = cp-drol.glosa
            DMOV.Tpocmb = IF cp-drol.Sdomn2 > 0 THEN ROUND(cp-drol.Sdomn1 / cp-drol.Sdomn2, 2) ELSE cp-drol.tpocmb
            DMOV.TpoMov = IF cp-drol.Codcta BEGINS "422" THEN cp-drol.TpoMov ELSE NOT cp-drol.TpoMov
            DMOV.CodBco = cp-drol.CodBco
            DMOV.Codref = STRING(cp-drol.nrorol, '999999').
     IF DMOV.TpoMov THEN
        ASSIGN F-ImpMn1 = F-ImpMn1 - DMOV.ImpMn1
               F-ImpMn2 = F-ImpMn2 - DMOV.ImpMn2.
     ELSE
        ASSIGN F-ImpMn1 = F-ImpMn1 + DMOV.ImpMn1
               F-ImpMn2 = F-ImpMn2 + DMOV.ImpMn2.
     FIND cp-crol WHERE cp-crol.CodCia = s-codcia AND 
          cp-crol.Periodo = cp-drol.Periodo AND 
          cp-crol.Nromes = cp-drol.nromes AND
          cp-crol.Nrorol = cp-drol.nrorol NO-LOCK NO-ERROR.
     IF AVAILABLE cp-crol THEN DO:
        ASSIGN
           DMOV.Nroref = cp-crol.NroChq.
        /* Cargamos la fecha de generada la programacion */
        IF cp-crol.Fecha <> ? THEN
           ASSIGN 
              DMOV.Fchdoc = cp-crol.Fecha.
     END.

     
     IF x-flag THEN 
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia = S-CODCIA AND
                cb-dmov.Periodo = S-PERIODO AND
                cb-dmov.Codcta  = cp-drol.Codcta  AND
                cb-dmov.Codaux  = cp-drol.CodAux  AND
                cb-dmov.CodDoc  = cp-drol.Coddoc  AND
                cb-dmov.NroDoc  = cp-drol.Nrodoc :
           FIND cb-cmov WHERE cb-cmov.Codcia = cb-dmov.codcia AND
                cb-cmov.Periodo = cb-dmov.Periodo AND
                cb-cmov.Nromes  = cb-dmov.Nromes AND
                cb-cmov.Codope  = cb-dmov.Codope AND
                cb-cmov.Nroast  = cb-dmov.Nroast NO-LOCK NO-ERROR.
           IF AVAILABLE cb-cmov AND cb-cmov.Nrochq <> "" THEN 
              ASSIGN
                 DMOV.NroREF = cb-cmov.Nrochq
                 DMOV.FchDoc = cb-cmov.Fchast
                 DMOV.Codope = cb-cmov.Codope
                 DMOV.NroAst = cb-cmov.nroast.
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
 DEFINE VAR x-ImpMn1  AS DECIMAL.
 DEFINE VAR x-ImpMn2  AS DECIMAL.
 DEFINE VAR x-codmon  AS CHAR.
 DEFINE VAR x-f       AS CHAR FORMAT 'X' NO-UNDO.
 
 DEFINE FRAME f-cab
        DMOV.CodAux COLUMN-LABEL "Codigo"
        DMOV.GloDoc COLUMN-LABEL "Nombre o Razon Social"
        DMOV.coddoc COLUMN-LABEL "Cod.!Doc."
        DMOV.nrodoc COLUMN-LABEL "Numero!Documento"
        DMOV.codbco COLUMN-LABEL "Cod!Bco" FORMAT 'X(3)'
        DMOV.Fchdoc COLUMN-LABEL " Fecha!Programacion" FORMAT "99/99/9999"
        DMOV.Fchvto COLUMN-LABEL " Fecha!Vencimiento" FORMAT "99/99/9999" 
        x-Codmon  COLUMN-LABEL "Cod!Mon" FORMAT 'X(3)'
        DMOV.ImpMn2 
        DMOV.ImpMn1 
        DMOV.TpoCmb  FORMAT ">9.99"
        x-f
        DMOV.Codref COLUMN-LABEL "Nro!Rol" FORMAT "X(6)"
        DMOV.Nroref COLUMN-LABEL " Cheque " FORMAT 'X(10)'
        DMOV.Codope 
        DMOV.NroAst
        HEADER
        S-NOMCIA
        x-titulo TO 90 FORMAT 'X(30)'
        "FECHA : " TO 143 TODAY TO 153  SKIP
        "VENCIMIENTOS DEL : " D-FchDes " AL " D-FchHas
        "PAGINA : " TO 143 PAGE-NUMBER(report) FORMAT "ZZ9" TO 153 SKIP(2)
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                        Cod. Numero     Cod  Fecha       Fecha        Cod                                           Nro             Cod Nro.   " SKIP
        "Codigo   Nombre o Razon Social          Doc. Documento  Bco Prog/ Pago   Vencto       Mon  Importe(US$)    Importe(S/.)   T/Cambio  Rol  Cheque     Ope Asient" SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

 OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. 
 PUT STREAM report CONTROL  {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3} .
 FOR EACH DMOV 
     BREAK BY DMOV.CodCia
             BY DMOV.CodAux
              BY DMOV.Codref:
     x-codmon = IF DMOV.codmon =  1 THEN 'S/.' ELSE 'US$'.              
     IF DMOV.Tpomov THEN x-f = '*'.
     ELSE x-f = ''.
     DISPLAY STREAM report 
             DMOV.CodAux
             DMOV.GloDoc
             DMOV.coddoc
             DMOV.nrodoc
             DMOV.codbco
             DMOV.fchdoc
             DMOV.fchvto 
             x-codmon
             DMOV.ImpMn1 
             DMOV.ImpMn2 
             DMOV.TpoCmb 
             x-f
             DMOV.Codref 
             DMOV.Nroref 
             DMOV.Codope
             DMOV.Nroast WITH FRAME F-Cab.
     x-ImpMn1 = IF DMOV.TpoMov THEN - DMOV.ImpMn1 ELSE DMOV.ImpMn1.
     x-ImpMn2 = IF DMOV.TpoMov THEN - DMOV.ImpMn2 ELSE DMOV.ImpMn2.
     ACCUMULATE x-ImpMn1 (TOTAL BY DMOV.codcia).
     ACCUMULATE x-ImpMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE x-ImpMn1 (SUB-TOTAL BY DMOV.CodAux).
     ACCUMULATE x-ImpMn2 (SUB-TOTAL BY DMOV.CodAux).
     IF LAST-OF(DMOV.Codaux) THEN DO:
        UNDERLINE STREAM report DMOV.ImpMn1
                                DMOV.ImpMn2
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  "TOTAL  "  @ DMOV.Fchvto
                       ACCUM SUB-TOTAL BY (DMOV.Codaux) x-ImpMn1 @ DMOV.ImpMn1
                       ACCUM SUB-TOTAL BY (DMOV.Codaux) x-ImpMn2 @ DMOV.ImpMn2
                       WITH FRAME F-Cab.
        DOWN STREAM report 2 WITH  FRAME f-cab.                        
     END.
     IF LAST-OF(DMOV.CodCia) THEN DO:
        UNDERLINE STREAM report DMOV.ImpMn1
                                DMOV.ImpMn2
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  "TOTAL GENERAL " @ DMOV.Fchvto
                       ACCUM TOTAL BY (DMOV.CodCia) x-ImpMn1 @ DMOV.ImpMn1
                       ACCUM TOTAL BY (DMOV.CodCia) x-ImpMn2 @ DMOV.ImpMn2
                       WITH FRAME F-Cab.
        UNDERLINE STREAM report DMOV.ImpMn1
                                DMOV.ImpMn2
                                WITH FRAME f-cab.
     END.
 END.
 PAGE STREAM report.
 OUTPUT STREAM report CLOSE.

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
DEFINE VAR x-ImpMn1  AS DECIMAL NO-UNDO.
DEFINE VAR x-ImpMn2  AS DECIMAL NO-UNDO.
DEFINE VAR x-codmon  AS CHAR NO-UNDO.
DEFINE VAR x-f       AS CHAR FORMAT 'X' NO-UNDO.

 DEFINE FRAME f-cab
        DMOV.CodAux COLUMN-LABEL "Codigo"
        DMOV.GloDoc COLUMN-LABEL "Nombre o Razon Social"
        DMOV.coddoc COLUMN-LABEL "Cod.!Doc."
        DMOV.nrodoc COLUMN-LABEL "Numero!Documento"
        DMOV.codbco COLUMN-LABEL "Cod!Bco" FORMAT 'X(3)'
        DMOV.Fchdoc COLUMN-LABEL " Fecha!Programacion" FORMAT "99/99/9999"
        DMOV.Fchvto COLUMN-LABEL " Fecha!Vencimiento" FORMAT "99/99/9999" 
        x-Codmon  COLUMN-LABEL "Cod!Mon" FORMAT 'X(3)'
        DMOV.ImpMn2 
        DMOV.ImpMn1 
        DMOV.TpoCmb FORMAT '>9.99'
        x-f
        DMOV.Codref COLUMN-LABEL "Nro!Rol" FORMAT "X(6)"
        DMOV.Nroref COLUMN-LABEL " Cheque " FORMAT 'X(10)'
        DMOV.Codope 
        DMOV.NroAst
        HEADER
        S-NOMCIA
        x-titulo TO 90 FORMAT 'X(30)'
        "FECHA : " TO 143 TODAY TO 153  SKIP
        "VENCIMIENTOS DEL : " D-FchDes " AL " D-FchHas
        "PAGINA : " TO 143 PAGE-NUMBER(report) FORMAT "ZZ9" TO 153 SKIP(2)
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                        Cod. Numero     Cod  Fecha       Fecha        Cod                                           Nro             Cod Nro.   " SKIP
        "Codigo   Nombre o Razon Social          Doc. Documento  Bco Prog/ Pago   Vencto       Mon  Importe(US$)    Importe(S/.)   T/Cambio  Rol  Cheque     Ope Asient" SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

/* OUTPUT STREAM report TO C:\TMP\PRUEBA.PRN PAGED PAGE-SIZE 62. */
 OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. 
 PUT STREAM report CONTROL  {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3} .
 FOR EACH DMOV 
     BREAK BY DMOV.CodCia
             BY DMOV.Fchvto
              BY DMOV.Codref:
     x-codmon = IF DMOV.codmon =  1 THEN 'S/.' ELSE 'US$'.              
     IF DMOV.Tpomov THEN x-f = '*'.
     ELSE x-f = ''.
     DISPLAY STREAM report 
             DMOV.CodAux
             DMOV.GloDoc
             DMOV.coddoc
             DMOV.nrodoc
             DMOV.codbco
             DMOV.fchdoc
             DMOV.fchvto 
             x-codmon
             DMOV.ImpMn1 
             DMOV.ImpMn2 
             DMOV.TpoCmb 
             x-f
             DMOV.Codref 
             DMOV.Nroref 
             DMOV.Codope
             DMOV.Nroast WITH FRAME F-Cab.
     x-ImpMn1 = IF DMOV.TpoMov THEN - DMOV.ImpMn1 ELSE DMOV.ImpMn1.
     x-ImpMn2 = IF DMOV.TpoMov THEN - DMOV.ImpMn2 ELSE DMOV.ImpMn2.
     ACCUMULATE x-ImpMn1 (TOTAL BY DMOV.codcia).
     ACCUMULATE x-ImpMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE x-ImpMn1 (SUB-TOTAL BY DMOV.FchVto).
     ACCUMULATE x-ImpMn2 (SUB-TOTAL BY DMOV.FchVto).
     IF LAST-OF(DMOV.Fchvto) THEN DO:
        UNDERLINE STREAM report DMOV.ImpMn1
                                DMOV.ImpMn2
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  "  TOTAL  "  @ DMOV.Fchvto
                       ACCUM SUB-TOTAL BY (DMOV.Fchvto) x-ImpMn1 @ DMOV.ImpMn1
                       ACCUM SUB-TOTAL BY (DMOV.Fchvto) x-ImpMn2 @ DMOV.ImpMn2
                       WITH FRAME F-Cab.
        DOWN STREAM report 2 WITH  FRAME f-cab.                        
     END.
     IF LAST-OF(DMOV.CodCia) THEN DO:
        UNDERLINE STREAM report DMOV.ImpMn1
                                DMOV.ImpMn2
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  "TOTAL GENERAL " @ DMOV.Fchvto
                       ACCUM TOTAL BY (DMOV.CodCia) x-ImpMn1 @ DMOV.ImpMn1
                       ACCUM TOTAL BY (DMOV.CodCia) x-ImpMn2 @ DMOV.ImpMn2
                       WITH FRAME F-Cab.
        UNDERLINE STREAM report DMOV.ImpMn1
                                DMOV.ImpMn2
                                WITH FRAME f-cab.
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
     FIND FIRST GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA NO-LOCK NO-ERROR.
     IF AVAILABLE GN-DIVI THEN X-CodDiv =GN-DIVI.CodDiv.
     DISPLAY X-CodDiv C-doc D-FchDes D-FchHas.
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

