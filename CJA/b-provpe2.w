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

DEFINE SHARED TEMP-TABLE RMOV LIKE cb-dmov.
DEFINE TEMP-TABLE DMOV LIKE cb-dmov.

DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
/*ML01* 23/Jun/2008 ***/
DEFINE SHARED VARIABLE fFchAst AS DATE NO-UNDO.

DEFINE BUFFER DETALLE FOR cb-dmov.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(50)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 7
     SKIP     
     WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
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
&Scoped-define FIELDS-IN-QUERY-br_table DMOV.Coddoc DMOV.Nrodoc DMOV.Fchvto DMOV.GloDoc DMOV.TpoMov DMOV.ImpMn1 DMOV.ImpMn2 DMOV.CodCta   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH DMOV       NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH DMOV       NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table DMOV
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DMOV


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-5 FILL-IN-prorrateo X-CodDiv x-ClfAux ~
x-codaux C-doc x-NroDoc D-FchDes D-FchHas br_table RECT-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-prorrateo FILL-IN-fchast X-CodDiv ~
x-ClfAux x-codaux C-doc x-NroDoc D-FchDes D-FchHas 

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
DEFINE BUTTON BUTTON-5 
     LABEL "Prorratear" 
     SIZE 10.57 BY .69.

DEFINE VARIABLE C-doc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod. Doc." 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 9.14 BY 1 NO-UNDO.

DEFINE VARIABLE D-FchDes AS DATE FORMAT "99/99/99":U 
     LABEL "Desde Vcto" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69 NO-UNDO.

DEFINE VARIABLE D-FchHas AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta Vcto" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-fchast AS DATE FORMAT "99/99/99":U 
     LABEL "Provisión" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-prorrateo AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Monto a Prorratear" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .69 NO-UNDO.

DEFINE VARIABLE x-ClfAux AS CHARACTER FORMAT "X(256)":U 
     LABEL "Clf. Aux." 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .69 NO-UNDO.

DEFINE VARIABLE x-codaux AS CHARACTER FORMAT "X(11)":U 
     LABEL "Auxiliar" 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE X-CodDiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-NroDoc AS CHARACTER FORMAT "X(10)":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.43 BY 3.23.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DMOV SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      DMOV.Coddoc
      DMOV.Nrodoc FORMAT "x(20)"
      DMOV.Fchvto COLUMN-LABEL "Fecha Vncmto"
      DMOV.GloDoc
      DMOV.TpoMov
      DMOV.ImpMn1
      DMOV.ImpMn2
      DMOV.CodCta
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 79.43 BY 11.04
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-5 AT ROW 3.15 COL 65.43 WIDGET-ID 4
     FILL-IN-prorrateo AT ROW 3.15 COL 50 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-fchast AT ROW 2.35 COL 50 COLON-ALIGNED
     X-CodDiv AT ROW 1.54 COL 8 COLON-ALIGNED
     x-ClfAux AT ROW 1.54 COL 27 COLON-ALIGNED
     x-codaux AT ROW 1.54 COL 42 COLON-ALIGNED
     C-doc AT ROW 2.35 COL 8 COLON-ALIGNED
     x-NroDoc AT ROW 2.35 COL 27 COLON-ALIGNED
     D-FchDes AT ROW 1.38 COL 69 COLON-ALIGNED
     D-FchHas AT ROW 2.15 COL 69 COLON-ALIGNED
     br_table AT ROW 4.23 COL 1
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
         HEIGHT             = 14.96
         WIDTH              = 79.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table D-FchHas F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-fchast IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH DMOV
      NO-LOCK INDEXED-REPOSITION.
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


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 B-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Prorratear */
DO:

    ASSIGN FILL-IN-prorrateo.
    RUN proc_prorratea.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-doc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-doc B-table-Win
ON RETURN OF C-doc IN FRAME F-Main /* Cod. Doc. */
DO:
    APPLY 'TAB':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-doc B-table-Win
ON VALUE-CHANGED OF C-doc IN FRAME F-Main /* Cod. Doc. */
DO:
  ASSIGN c-doc.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-ClfAux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-ClfAux B-table-Win
ON LEAVE OF x-ClfAux IN FRAME F-Main /* Clf. Aux. */
DO:
  ASSIGN x-ClfAux.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-ClfAux B-table-Win
ON MOUSE-SELECT-DBLCLICK OF x-ClfAux IN FRAME F-Main /* Clf. Aux. */
OR "F8" OF x-clfaux 
DO:
  input-var-1 = "01".
  output-var-1 = ?.
  output-var-2 = "".
  RUN cbd\C-Tablas("Clasificacion de Auxiliares").
  IF output-var-1 NE ?  THEN
     DISPLAY output-var-2 @ x-clfaux WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-codaux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codaux B-table-Win
ON LEAVE OF x-codaux IN FRAME F-Main /* Auxiliar */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  ASSIGN x-ClfAux.
  CASE x-ClfAux:
       WHEN "@PV" THEN DO:
            FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
                 gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-prov THEN
               FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA AND
                    gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-prov THEN DO:
               MESSAGE "Codigo de proveedor no registrado" VIEW-AS ALERT-BOX ERROR.
               RETURN NO-APPLY.
            END.
       END.
       WHEN "@CL" THEN DO:
            FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
                 gn-clie.CodCli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-clie THEN
               FIND gn-clie WHERE gn-clie.CodCia = S-CODCIA AND
                    gn-clie.CodCli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-clie THEN DO:
               MESSAGE "Codigo de Cliente no registrado" VIEW-AS ALERT-BOX ERROR.
               RETURN NO-APPLY.
            END.
       END.
       WHEN "@CT"  THEN DO:
            FIND CB-CTAS WHERE CB-CTAS.CodCia = cb-codcia AND
                 CB-CTAS.CodCta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE CB-CTAS THEN 
               FIND CB-CTAS WHERE CB-CTAS.CodCia = S-CODCIA AND
                    CB-CTAS.CodCta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE CB-CTAS THEN DO:
               MESSAGE "Codigo de auxiliar no registrado" VIEW-AS ALERT-BOX ERROR.
               RETURN NO-APPLY.
            END.
       END.  
       OTHERWISE DO:
            FIND cb-auxi WHERE cb-auxi.CodCia = 0 AND
                 cb-auxi.ClfAux = x-ClfAux AND
                 cb-auxi.CodAux = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE cb-auxi THEN
               FIND cb-auxi WHERE cb-auxi.CodCia = S-CODCIA AND
                    cb-auxi.ClfAux = x-ClfAux AND
                    cb-auxi.CodAux = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE CB-AUXI THEN DO:
               MESSAGE "Codigo de auxiliar no registrado" VIEW-AS ALERT-BOX ERROR.
               RETURN NO-APPLY.
            END.
       END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codaux B-table-Win
ON MOUSE-SELECT-DBLCLICK OF x-codaux IN FRAME F-Main /* Auxiliar */
OR "F8" OF x-codaux 
DO:
  output-var-1 = ?.
  output-var-2 = "".
  CASE x-ClfAux:
       WHEN "@PV" THEN DO:
            RUN CBD\C-PROVEE("Maestro de Proveedores").
       END.
       WHEN "@CL" THEN DO:
            RUN CBD\C-CLIENT("Maestro de Clientes").
       END.
       OTHERWISE DO:
            input-var-1 = x-ClfAux.
            RUN CBD\C-AUXIL("Maestro de Auxiliares").
       END.
  END CASE.
  IF output-var-1 NE ?  THEN
     DISPLAY output-var-2 @ x-codaux WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-CodDiv B-table-Win
ON MOUSE-SELECT-DBLCLICK OF X-CodDiv IN FRAME F-Main /* División */
OR "F8" OF x-coddiv 
DO:
  output-var-1 = ?.
  output-var-2 = "".
  RUN cbd\C-Divis("Divisiones").
  IF output-var-1 NE ?  THEN
     DISPLAY output-var-2 @ x-coddiv WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Documentos B-table-Win 
PROCEDURE Asigna-Documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE I AS INTEGER NO-UNDO.
IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
   MESSAGE "No existen registros seleccionados" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
DO I = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
   IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(I) THEN DO:
      FIND RMOV WHERE RMOV.CodDoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CodDoc
           AND RMOV.NroDoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroDoc
           NO-LOCK NO-ERROR.
      IF NOT AVAILABLE RMOV THEN DO:
         DISPLAY STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroDoc,"999999") @ Fi-Mensaje LABEL "Codigo de Documento " FORMAT "X(10)" WITH FRAME F-Proceso.
         CREATE RMOV.
         ASSIGN RMOV.cco    = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.cco   
                RMOV.Clfaux = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Clfaux
                RMOV.CndCmp = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CndCmp
                RMOV.Codaux = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codaux
                RMOV.Codcta = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codcta
                RMOV.CodDiv = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CodDiv
                RMOV.Coddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Coddoc
                RMOV.Codmon = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codmon
                RMOV.Codref = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codref
                RMOV.CtaAut = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CtaAut
                RMOV.CtrCta = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CtrCta
                RMOV.DisCCo = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.DisCCo
                RMOV.Fchdoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Fchdoc
                RMOV.Fchvto = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Fchvto
                RMOV.flgact = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.flgact
                RMOV.Glodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Glodoc
                RMOV.ImpMn1 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.ImpMn1
                RMOV.ImpMn2 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.ImpMn2
                RMOV.Nrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Nrodoc
                RMOV.Nroref = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroRef
                RMOV.Nroruc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Nroruc
                RMOV.OrdCmp = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.OrdCmp
                RMOV.Tpocmb = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Tpocmb
                RMOV.TpoMov = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.TpoMov
/*ML01*/        RMOV.CodCia = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CodCia
/*ML01*/        RMOV.Periodo = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Periodo
/*ML01*/        RMOV.NroMes = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroMes
/*ML01*/        RMOV.TpoMov = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.TpoMov
                RMOV.TpoItm = "P".
      END.
   END.
END.
HIDE FRAME F-Proceso.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /*ML02*/ Captura documentos de Canje de Letras
------------------------------------------------------------------------------*/

DEFINE VARIABLE lCorrelativo AS LOGICAL NO-UNDO.
DEFINE VARIABLE cDesAux AS CHARACTER NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
   ASSIGN C-doc x-ClfAux x-codaux X-CodDiv x-NroDoc D-FchDes D-FchHas.
   IF C-doc = "Todos" THEN C-doc = "".
END.

DEFINE VARIABLE I-NroReg AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE X-IMPORT AS DECIMAL EXTENT 2 INIT 0  NO-UNDO.
DEFINE VARIABLE X-MONCTA AS INTEGER NO-UNDO.

/* BLANQUEMOS TEMPORAL */
FOR EACH DMOV:
    DELETE DMOV.
END.

CASE x-ClfAux:
    WHEN "@PV" THEN DO:
        lCorrelativo = TRUE.
        cDesAux = "Proveedor: ".
    END.
    WHEN "@CL" THEN DO:
        lCorrelativo = FALSE.
        cDesAux = "Cliente: ".
    END.
    OTHERWISE DO:
        lCorrelativo = ?.
        cDesAux = "".
    END.
END CASE.

/* CARGAMOS LOS SALDOS POR DOCUMENTO */
FOR EACH DETALLE NO-LOCK WHERE
    DETALLE.CODCIA = S-CODCIA AND
    DETALLE.PERIODO = S-PERIODO AND
    DETALLE.NROMES <= S-NROMES AND
    DETALLE.CODOPE = "061" AND            /* Canje de Letras */
    DETALLE.CODCTA BEGINS "4" AND
    DETALLE.CodAux BEGINS x-codaux AND
    DETALLE.CODDOC BEGINS C-doc AND
    DETALLE.FCHVTO >= D-FchDes AND
    DETALLE.FCHVTO <= D-FchHas AND
    DETALLE.NroDoc BEGINS x-NroDoc,
    FIRST cb-cmov WHERE
        cb-cmov.codcia = detalle.codcia AND
        cb-cmov.periodo = detalle.periodo AND
        cb-cmov.nromes = detalle.nromes AND
        cb-cmov.codope = detalle.codope AND
        cb-cmov.nroast = detalle.nroast AND
        cb-cmov.fchast <= FILL-IN-fchast NO-LOCK
    BREAK BY DETALLE.CODCIA BY DETALLE.Periodo 
        BY DETALLE.CODCTA BY DETALLE.CODAUX
        BY DETALLE.CODDOC BY DETALLE.NRODOC
        BY DETALLE.NROMES BY DETALLE.FCHDOC:  
    IF DETALLE.TPOITM = "N" THEN NEXT.
    FI-MENSAJE =
        cDesAux + DETALLE.CodAux + " Doc. : " + DETALLE.CodDoc + " No. : " + DETALLE.NroDoc.
    DISPLAY FI-MENSAJE FORMAT "X(45)"  WITH FRAME F-PROCESO.
    IF DETALLE.Chr_02 <> "RET" THEN NEXT.  /* Marcado como retención */
    FIND cb-ctas WHERE
        cb-ctas.CodCia = CB-CODCIA AND
        cb-ctas.Codcta = DETALLE.CodCta NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas AND cb-ctas.Codmon <> 3 THEN X-MONCTA = cb-ctas.Codmon.
    ELSE X-MONCTA = DETALLE.CodMon.
    X-IMPORT[1] = 0.
    X-IMPORT[2] = 0.
    FOR EACH cb-dmov NO-LOCK WHERE
        cb-dmov.CodCia  = S-CODCIA        AND
        cb-dmov.Periodo = S-PERIODO       AND
        cb-dmov.Codcta  = DETALLE.CODCTA  AND
        cb-dmov.Codaux  = DETALLE.codaux  AND
        cb-dmov.CodDoc  = DETALLE.CodDoc  AND
        cb-dmov.NroDoc  = DETALLE.NroDoc:
        IF cb-dmov.TpoMov THEN 
            ASSIGN
                X-IMPORT[1] = X-IMPORT[1] - cb-dmov.ImpMn1 
                X-IMPORT[2] = X-IMPORT[2] - cb-dmov.ImpMn2.
        ELSE
            ASSIGN
                X-IMPORT[1] = X-IMPORT[1] + cb-dmov.ImpMn1
                X-IMPORT[2] = X-IMPORT[2] + cb-dmov.ImpMn2.
    END.
    IF (X-MONCTA = 1 AND ABSOLUTE(X-IMPORT[1]) > 0) OR
        (X-MONCTA = 2 AND ABSOLUTE(X-IMPORT[2]) > 0) THEN DO:
        CREATE DMOV.
        ASSIGN
            DMOV.CODCIA = S-CODCIA
            DMOV.NroAst = DETALLE.NroAst
            DMOV.CodOpe = DETALLE.CodOpe
            DMOV.Periodo = DETALLE.Periodo
            DMOV.NroMes = DETALLE.NroMes
            DMOV.cco    = DETALLE.cco   
            DMOV.Clfaux = DETALLE.Clfaux
            DMOV.CndCmp = DETALLE.CndCmp
            DMOV.Codaux = DETALLE.Codaux
            DMOV.Codcta = DETALLE.Codcta
            DMOV.CodDiv = DETALLE.CodDiv
            DMOV.Coddoc = DETALLE.Coddoc
            DMOV.Codmon = X-MONCTA
            DMOV.Codref = DETALLE.Codref
            DMOV.DisCCo = DETALLE.DisCCo
            DMOV.Fchdoc = DETALLE.Fchdoc
            DMOV.Fchvto = DETALLE.Fchvto
            DMOV.flgact = DETALLE.flgact
            DMOV.Glodoc = DETALLE.Glodoc
            DMOV.ImpMn1 = ABSOLUTE(X-IMPORT[1])
            DMOV.ImpMn2 = ABSOLUTE(X-IMPORT[2])
            DMOV.Nrodoc = DETALLE.Nrodoc
            DMOV.Nroref = (DETALLE.CodOpe + "-" + DETALLE.NroAst)
            DMOV.Nroruc = DETALLE.Nroruc
            DMOV.OrdCmp = DETALLE.OrdCmp
            DMOV.tm     = DETALLE.tm
            DMOV.Tpocmb = DETALLE.Tpocmb
            DMOV.TpoMov = NOT DETALLE.TpoMov
            DMOV.CodBco = DETALLE.CodBco
            DMOV.Dec_04 = DMOV.ImpMn1
            DMOV.Dec_05 = DMOV.ImpMn2.
        IF DETALLE.Codcta BEGINS "422" THEN 
            DMOV.TpoMov = NOT ( X-IMPORT[1] < 0 OR X-IMPORT[2] < 0 ).
    END.
END.

HIDE FRAME F-PROCESO.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME} :
     DEF VAR L-DOCS AS CHAR INIT "Todos".
     FOR EACH CP-TPRO NO-LOCK  WHERE CP-TPRO.CODCIA = CB-CODCIA  AND
               CP-TPRO.CORRELATIVO = YES BREAK BY CP-TPRO.CODDOC:
         IF FIRST-OF(CP-TPRO.CODDOC) THEN DO:
             ASSIGN L-DOCS = L-DOCS + "," + CP-TPRO.CODDOC.
         END.
     END.
     IF L-DOCS <> "" THEN DO:
        C-DOC:LIST-ITEMS = L-DOCS.
        C-DOC = "01".
     END.
     D-FchDes = TODAY - DAY(TODAY) + 1.
     D-FchHas = TODAY.
/*ML01*/ FILL-IN-fchast = fFchAst.
     x-ClfAux = "@PV".
     DISPLAY X-CodDiv C-doc x-ClfAux D-FchDes D-FchHas FILL-IN-fchast.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_prorratea B-table-Win 
PROCEDURE proc_prorratea :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dAccumImp AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dPercent AS DECIMAL NO-UNDO.
    DEFINE VARIABLE lRpta AS LOGICAL NO-UNDO.

    DEFINE BUFFER b_DMOV FOR DMOV.

    FOR EACH b_DMOV:
        IF FILL-IN-prorrateo = 0 THEN DO:
            IF b_DMOV.ImpMn1 <> b_DMOV.Dec_04 THEN
                b_DMOV.ImpMn1 = b_DMOV.Dec_04.
            IF b_DMOV.ImpMn2 <> b_DMOV.Dec_05 THEN
                b_DMOV.ImpMn2 = b_DMOV.Dec_05.
        END.
        ELSE dAccumImp = dAccumImp + b_DMOV.ImpMn1.
    END.

    IF FILL-IN-prorrateo <> 0 THEN FOR EACH b_DMOV:
        dPercent = b_DMOV.ImpMn1 / dAccumImp.
        b_DMOV.ImpMn1 = dPercent * FILL-IN-prorrateo.
        b_DMOV.ImpMn2 = dPercent * FILL-IN-prorrateo.
    END.

    DO WITH FRAME {&FRAME-NAME}:
        lRpta = br_table:REFRESH().
    END.

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

