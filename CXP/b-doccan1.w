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

DEFINE TEMP-TABLE DMOV LIKE cb-dmov
       FIELD FchCja LIKE cb-cmov.FchAst
       FIELD OpeCja LIKE cb-cmov.CodOpe
       FIELD AstCja LIKE cb-cmov.NroAst
       FIELD NroChq LIKE cb-cmov.NroChq
       FIELD DbeMn1 LIKE cb-cmov.DbeMn1
       FIELD DbeMn2 LIKE cb-cmov.DbeMn2
       FIELD HbeMn1 LIKE cb-cmov.HbeMn1
       FIELD HbeMn2 LIKE cb-cmov.HbeMn2.

DEFINE VARIABLE I-ORDEN AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA  AS CHAR.
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
&Scoped-define FIELDS-IN-QUERY-br_table DMOV.CodAux DMOV.Coddoc DMOV.Nrodoc DMOV.CodBco DMOV.Fchvto DMOV.Fchvto + 8 @ DMOV.Fchdoc DMOV.GloDoc DMOV.TpoMov DMOV.ImpMn1 DMOV.ImpMn2 /* DMOV.DbeMn1 DMOV.HbeMn1 DMOV.DbeMn2 DMOV.HbeMn2 */ DMOV.TpoCmb DMOV.Nroref DMOV.NroAst DMOV.CodOpe DMOV.NroChq DMOV.AstCja DMOV.OpeCja DMOV.FchCja   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table IF I-ORDEN = 1 THEN OPEN QUERY {&SELF-NAME} FOR EACH DMOV NO-LOCK    BY DMOV.CodCia     BY DMOV.Fchvto      BY DMOV.Codaux       BY DMOV.Coddoc        BY DMOV.Nrodoc     INDEXED-REPOSITION. ELSE OPEN QUERY {&SELF-NAME} FOR EACH DMOV NO-LOCK    BY DMOV.CodCia     BY DMOV.Codaux      BY DMOV.Fchvto       BY DMOV.Coddoc        BY DMOV.Nrodoc     INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table DMOV
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DMOV


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 FILL-IN-coddiv COMBO-coddoc ~
FILL-IN-NroDoc FILL-IN-codaux FILL-IN-FchCan-1 FILL-IN-FchCan-2 br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-coddiv COMBO-coddoc FILL-IN-NroDoc ~
FILL-IN-codaux FILL-IN-FchCan-1 FILL-IN-FchCan-2 F-ImpMn1 F-ImpMn2 

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
DEFINE VARIABLE COMBO-coddoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 8.86 BY 1 NO-UNDO.

DEFINE VARIABLE F-ImpMn1 AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Total S/." 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .81
     BGCOLOR 1 FGCOLOR 11  NO-UNDO.

DEFINE VARIABLE F-ImpMn2 AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "US$" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .81
     BGCOLOR 1 FGCOLOR 11  NO-UNDO.

DEFINE VARIABLE FILL-IN-codaux AS CHARACTER FORMAT "X(8)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-coddiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchCan-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Canceladas desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchCan-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "X(10)":U 
     LABEL "Nro. Documento" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 2.5.

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
      DMOV.Fchvto COLUMN-LABEL "Fecha Vncmto"
      DMOV.Fchvto + 8 @ DMOV.Fchdoc COLUMN-LABEL " Fecha.Ult.!Mov. " FORMAT "99/99/9999"
      DMOV.GloDoc FORMAT "X(25)"
      DMOV.TpoMov
      DMOV.ImpMn1 FORMAT "(>>>,>>>,>>9.99)" 
      DMOV.ImpMn2 FORMAT "(>>>,>>>,>>9.99)" 
      /* 
      DMOV.DbeMn1
      DMOV.HbeMn1
      DMOV.DbeMn2
      DMOV.HbeMn2
      */
      DMOV.TpoCmb 
      DMOV.Nroref COLUMN-LABEL "                  Nro.!Banco       Cheque" FORMAT 'X(20)'
      DMOV.NroAst COLUMN-LABEL "Voucher!Provis."
      DMOV.CodOpe COLUMN-LABEL "Libro!Prov."
      DMOV.NroChq COLUMN-LABEL "Cheque"
      DMOV.AstCja COLUMN-LABEL "Voucher!Cancela"
      DMOV.OpeCja COLUMN-LABEL "Libro!Cancela"
      DMOV.FchCja COLUMN-LABEL "Fecha!Cancelacion"  FORMAT '99/99/99'
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 85.72 BY 11.08
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-coddiv AT ROW 1.38 COL 9 COLON-ALIGNED
     COMBO-coddoc AT ROW 1.38 COL 33 COLON-ALIGNED
     FILL-IN-NroDoc AT ROW 1.38 COL 57 COLON-ALIGNED
     FILL-IN-codaux AT ROW 2.35 COL 9 COLON-ALIGNED
     FILL-IN-FchCan-1 AT ROW 2.35 COL 33 COLON-ALIGNED
     FILL-IN-FchCan-2 AT ROW 2.35 COL 57 COLON-ALIGNED
     br_table AT ROW 3.5 COL 1
     F-ImpMn1 AT ROW 14.65 COL 53 COLON-ALIGNED
     F-ImpMn2 AT ROW 14.65 COL 70 COLON-ALIGNED
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
         HEIGHT             = 14.69
         WIDTH              = 86.29.
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
/* BROWSE-TAB br_table FILL-IN-FchCan-2 F-Main */
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


&Scoped-define SELF-NAME COMBO-coddoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-coddoc B-table-Win
ON VALUE-CHANGED OF COMBO-coddoc IN FRAME F-Main /* Documento */
DO:
    ASSIGN COMBO-coddoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codaux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codaux B-table-Win
ON LEAVE OF FILL-IN-codaux IN FRAME F-Main /* Proveedor */
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

DEFINE VARIABLE cCodDoc AS CHARACTER NO-UNDO.
DEFINE VARIABLE I-NroReg AS INTEGER          INIT 0 NO-UNDO.
DEFINE VARIABLE X-IMPORT AS DECIMAL EXTENT 2 INIT 0 NO-UNDO.
DEFINE VARIABLE X-DBE    AS DECIMAL EXTENT 2 INIT 0 NO-UNDO.
DEFINE VARIABLE X-HBE    AS DECIMAL EXTENT 2 INIT 0 NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
   ASSIGN COMBO-coddoc FILL-IN-codaux FILL-IN-NroDoc.
   IF COMBO-coddoc = "Todos" THEN cCoddoc = "".
END.

/* BLANQUEMOS TEMPORAL */
FOR EACH DMOV:
    DELETE DMOV.
END.

F-ImpMn1 = 0.
F-ImpMn2 = 0.
/*
/* CARGAMOS LOS SALDOS POR DOCUMENTO */
FOR EACH Cp-tpro NO-LOCK  WHERE Cp-tpro.CODCIA = CB-CODCIA AND
         Cp-tpro.CodDoc BEGINS cCoddoc AND
         LOOKUP(Cp-tpro.CodDoc,F-ExcDoc) = 0 AND
         Cp-tpro.CORRELATIVO = YES AND
         Cp-tpro.CodCta BEGINS "102":
    FOR EACH DETALLE NO-LOCK WHERE DETALLE.CODCIA  = S-CODCIA  AND
             DETALLE.PERIODO = S-PERIODO      AND
             DETALLE.CODOPE  = CP-TPRO.CODOPE AND
             DETALLE.CODCTA  = CP-TPRO.CODCTA AND
             DETALLE.CodAux BEGINS F-CjaChi   AND
             DETALLE.CODDOC  = CP-TPRO.CODDOC AND
             DETALLE.NroDoc BEGINS FILL-IN-NroDoc   AND
             DETALLE.FCHVTO >= D-FchDes       AND
             DETALLE.FCHVTO <= D-FchHas       
             BREAK BY DETALLE.CODDO BY DETALLE.NRODOC :
        FI-MENSAJE = "Proveedor : " + DETALLE.CodAux + " Doc. : " + DETALLE.CodDoc +
                     " No. : " + DETALLE.NroDoc.
        DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.
        X-IMPORT[1] = 0.
        X-IMPORT[2] = 0.
        X-DBE[1] = 0.
        X-HBE[1] = 0.
        X-DBE[2] = 0.
        X-HBE[2] = 0.
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia = DETALLE.CODCIA AND
                 cb-dmov.Periodo = DETALLE.PERIODO AND
                 cb-dmov.Codcta  = DETALLE.CODCTA  AND
                 cb-dmov.Codaux  = DETALLE.codaux  AND
                 cb-dmov.CodDoc  = DETALLE.CodDoc  AND
                 cb-dmov.NroDoc  = DETALLE.NroDoc:
            IF cb-dmov.TpoMov THEN 
               ASSIGN X-IMPORT[1] = X-IMPORT[1] - cb-dmov.ImpMn1 
                      X-IMPORT[2] = X-IMPORT[2] - cb-dmov.ImpMn2
                      X-HBE[1]    = X-HBE[1]    + cb-dmov.ImpMn1
                      X-HBE[2]    = X-HBE[2]    + cb-dmov.ImpMn2.
            ELSE
               ASSIGN X-IMPORT[1] = X-IMPORT[1] + cb-dmov.ImpMn1 
                      X-IMPORT[2] = X-IMPORT[2] + cb-dmov.ImpMn2
                      X-DBE[1]    = X-DBE[1]    + cb-dmov.ImpMn1
                      X-DBE[2]    = X-DBE[2]    + cb-dmov.ImpMn2.
        END.
        IF (DETALLE.CodMon = 1 AND ROUND(ABSOLUTE(X-IMPORT[1]),2) = 0) OR
           (DETALLE.CodMon = 2 AND ROUND(ABSOLUTE(X-IMPORT[2]),2) = 0) THEN DO:
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
                  DMOV.DbeMn1 = X-DBE[1]
                  DMOV.DbeMn2 = X-DBE[2]
                  DMOV.HbeMn1 = X-HBE[1]
                  DMOV.HbeMn2 = X-HBE[2]
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

*/

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

DEFINE VARIABLE cCodDoc AS CHARACTER NO-UNDO.
DEFINE VARIABLE I-NroReg AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE X-IMPORT AS DECIMAL EXTENT 2 INIT 0  NO-UNDO.
DEFINE VARIABLE X-DBE    AS DECIMAL EXTENT 2 INIT 0  NO-UNDO.
DEFINE VARIABLE X-HBE    AS DECIMAL EXTENT 2 INIT 0  NO-UNDO.
DEFINE VARIABLE X-nrochq AS CHAR    NO-UNDO.
DEFINE VARIABLE X-codbco AS CHAR    NO-UNDO.
DEFINE VARIABLE X-codope AS CHAR    NO-UNDO.
DEFINE VARIABLE X-AstCja AS CHAR    NO-UNDO.
DEFINE VARIABLE X-OpeCja AS CHAR    NO-UNDO.
DEFINE VARIABLE X-FchCja AS DATE    NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FILL-IN-coddiv
        COMBO-coddoc
        FILL-IN-codaux
        FILL-IN-NroDoc
        FILL-IN-FchCan-1
        FILL-IN-FchCan-2.
    IF COMBO-coddoc = "Todos" THEN cCoddoc = "".
END.

/* BLANQUEMOS TEMPORAL */
FOR EACH DMOV:
    DELETE DMOV.
END.
F-ImpMn1 = 0.
F-ImpMn2 = 0.

FOR EACH cb-dmov NO-LOCK WHERE
    cb-dmov.codcia = s-codcia AND
    cb-dmov.periodo = s-periodo AND
    cb-dmov.nromes >= MONTH(FILL-IN-FchCan-1) AND
    cb-dmov.nromes <= MONTH(FILL-IN-FchCan-2) AND
    cb-dmov.codope = "002" AND
    cb-dmov.codaux BEGINS FILL-IN-codaux AND
    cb-dmov.coddoc BEGINS cCodDoc AND
    cb-dmov.nrodoc BEGINS FILL-IN-NroDoc AND
    (cb-dmov.codcta BEGINS "421" OR
    cb-dmov.codcta BEGINS "422" OR
    cb-dmov.codcta BEGINS "423" OR
    cb-dmov.codcta BEGINS "469"),
    FIRST cb-cmov NO-LOCK WHERE cb-cmov.Codcia = cb-dmov.codcia AND
    cb-cmov.Periodo = cb-dmov.periodo AND
    cb-cmov.Codope = cb-dmov.codope AND
    cb-cmov.nroast = cb-dmov.nroast AND
    cb-cmov.FchAst >= FILL-IN-FchCan-1 AND
    cb-cmov.FchAst <= FILL-IN-FchCan-2:

    CREATE DMOV.
    ASSIGN
        DMOV.CODCIA = S-CODCIA
        DMOV.cco    = cb-dmov.cco   
        DMOV.Clfaux = cb-dmov.Clfaux
        DMOV.CndCmp = cb-dmov.CndCmp
        DMOV.Codaux = cb-dmov.Codaux
        DMOV.Codcta = cb-dmov.Codcta
        DMOV.CodDiv = cb-dmov.CodDiv
        DMOV.Coddoc = cb-dmov.Coddoc
        DMOV.Codmon = cb-dmov.Codmon
        DMOV.Codref = cb-dmov.Codref
        DMOV.DisCCo = cb-dmov.DisCCo
        DMOV.Fchdoc = cb-dmov.Fchdoc
        DMOV.flgact = cb-dmov.flgact
        DMOV.Glodoc = cb-dmov.Glodoc
        DMOV.ImpMn1 = cb-dmov.ImpMn1 * IF cb-dmov.TpoMov THEN 1 ELSE -1
        DMOV.ImpMn2 = cb-dmov.ImpMn2 * IF cb-dmov.TpoMov THEN 1 ELSE -1
        DMOV.Nrodoc = cb-dmov.Nrodoc
        DMOV.Nroref = cb-cmov.Ctacja + ' ' + cb-cmov.Nrochq
        DMOV.NroChq = cb-cmov.Nrochq
        DMOV.AstCja = cb-cmov.NroAst
        DMOV.OpeCja = cb-cmov.CodOpe
        DMOV.FchCja = cb-cmov.FchAst
        DMOV.Nroruc = cb-dmov.Nroruc
        DMOV.OrdCmp = cb-dmov.OrdCmp
        DMOV.tm     = cb-dmov.tm
        DMOV.Tpocmb = cb-dmov.Tpocmb
        DMOV.TpoMov = NOT cb-dmov.TpoMov
        DMOV.CodBco = cb-dmov.CodBco.
    IF DMOV.TpoMov THEN
        ASSIGN
            F-ImpMn1 = F-ImpMn1 - DMOV.ImpMn1
            F-ImpMn2 = F-ImpMn2 - DMOV.ImpMn2.
    ELSE
        ASSIGN
            F-ImpMn1 = F-ImpMn1 + DMOV.ImpMn1
            F-ImpMn2 = F-ImpMn2 + DMOV.ImpMn2.

    FI-MENSAJE =
        "Proveedor: " +
        cb-dmov.CodAux +
        " Documento: " +
        cb-dmov.CodDoc +
        " Nro : " + cb-dmov.NroDoc.
    DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.

    /* Busca Provision */
    FOR EACH detalle NO-LOCK WHERE
        detalle.CodCia = cb-dmov.CODCIA AND
        detalle.Periodo = cb-dmov.PERIODO AND
        detalle.Codcta  = cb-dmov.codcta AND
        detalle.Codaux  = cb-dmov.codaux  AND
        detalle.CodDoc  = cb-dmov.CodDoc  AND
        detalle.NroDoc  = cb-dmov.NroDoc:
        IF detalle.codope <> cb-dmov.codope THEN DO:
            DMOV.NroAst = detalle.NroAst.
            DMOV.CodOpe = detalle.CodOpe.
            DMOV.Fchvto = detalle.Fchvto.
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

DEFINE VAR x-dol LIKE DMOV.ImpMn2.
DEFINE VAR x-sol LIKE DMOV.ImpMn1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Range("C1"):Font:Bold = TRUE.
chWorkSheet:Range("C1"):Value =
    "FACTURAS CANCELADAS DEL " + STRING(FILL-IN-FchCan-1,"99/99/99") +
    " AL " + STRING(FILL-IN-FchCan-2,"99/99/99").

chWorkSheet:Range("A4:R4"):Font:Bold = TRUE.
chWorkSheet:Range("A4"):Value = "CODIGO".
chWorkSheet:Range("B4"):Value = "PROVEEDOR".
chWorkSheet:Range("C4"):Value = "COD.DOC".
chWorkSheet:Range("D4"):Value = "NUMERO".
chWorkSheet:Range("E4"):Value = "EMISION".
chWorkSheet:Range("F4"):Value = "VENCIMIENTO".
chWorkSheet:Range("G4"):Value = "DETALLE".
chWorkSheet:Range("H4"):Value = "MOV".
chWorkSheet:Range("I4"):Value = "SOLES".
chWorkSheet:Range("J4"):Value = "DOLARES".
chWorkSheet:Range("K4"):Value = "T.CAMBIO".
chWorkSheet:Range("L4"):Value = "REFERENCIA".
chWorkSheet:Range("M4"):Value = "PROVISION".
chWorkSheet:Range("N4"):Value = "LIBRO".
chWorkSheet:Range("O4"):Value = "CHEQUE".
chWorkSheet:Range("P4"):Value = "CANCELACION".
chWorkSheet:Range("Q4"):Value = "LIBRO".
chWorkSheet:Range("R4"):Value = "FECHA".

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */
iColumn = 4.

 FOR EACH DMOV 
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
     chWorkSheet:Range(cRange):Value = DMOV.GloDoc.
     cRange = "H" + cColumn.
     chWorkSheet:Range(cRange):Value = (IF DMOV.TpoMov = YES THEN 'H' ELSE 'D').
     cRange = "I" + cColumn.
     chWorkSheet:Range(cRange):Value = X-SOL.
     cRange = "J" + cColumn.
     chWorkSheet:Range(cRange):Value = X-DOL.
     cRange = "K" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV.TpoCmb.
     cRange = "L" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV.NroRef.
     cRange = "M" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + DMOV.NroAst.
     cRange = "N" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + DMOV.CodOpe.
     cRange = "O" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + DMOV.NroChq.
     cRange = "P" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + DMOV.AstCja.
     cRange = "Q" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + DMOV.opeCja.
     cRange = "R" + cColumn.
     chWorkSheet:Range(cRange):Value = DMOV.FchCja.

    FI-MENSAJE =
        "Proveedor: " +
        DMOV.CodAux +
        " Documento: " +
        DMOV.CodDoc +
        " Nro : " + DMOV.NroDoc.
    DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.
     
 end.

HIDE FRAME F-PROCESO.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

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
IF I-ORDEN = 1 
THEN RUN Imprime-por-Vencimiento.
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
        DMOV.ImpMn1 FORMAT "(>>>,>>>,>>9.99)" 
        DMOV.ImpMn2 FORMAT "(>>>,>>>,>>9.99)" 
        /* 
        DMOV.DbeMn1 
        DMOV.HbeMn1 
        DMOV.DbeMn2 
        DMOV.HbeMn2 
        */
        DMOV.TpoCmb 
        DMOV.AstCja COLUMN-LABEL "Voucher" 
        DMOV.OpeCja COLUMN-LABEL "Libro" 
        DMOV.NroChq COLUMN-LABEL "Cheque" 
        HEADER
        S-NOMCIA
        "DOCUMENTOS CANCELADOS" TO 75
        "FECHA : " TO 123 TODAY TO 133  SKIP
        "CANCELADOS DEL : " FILL-IN-FchCan-1 " AL " FILL-IN-FchCan-2
        "PAGINA : " TO 123 PAGE-NUMBER(report) FORMAT "ZZ9" TO 133 SKIP(2)
        "---------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                        Cod. Numero      Fecha                                                                               " SKIP
        "Codigo   Nombre o Razon Social          Doc. Documento  Vencimient      Importe(US$)     Importe(S/.)  T/Cambio Voucher Libro Cheque         " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.
 /* OUTPUT STREAM report TO C:\TMP\PRUEBA.PRN PAGED PAGE-SIZE 62. */
 
 OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62.
 PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" {&Prn0} {&Prn5A} CHR(66) {&Prn3}.
 PUT STREAM report CONTROL "~033x" NULL "~017~033P" {&Prn0} {&Prn5A} CHR(66) {&Prn3}.
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
             DMOV.ImpMn1
             DMOV.ImpMn2
             /*
             DMOV.DbeMn1
             DMOV.HbeMn1
             DMOV.DbeMn2
             DMOV.HbeMn2
             */
             DMOV.TpoCmb 
             DMOV.AstCja 
             DMOV.OpeCja 
             DMOV.NroChq 
             WITH FRAME F-Cab.
     ACCUMULATE DMOV.ImpMn1 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.ImpMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.ImpMn1 (SUB-TOTAL BY DMOV.codAux).
     ACCUMULATE DMOV.ImpMn2 (SUB-TOTAL BY DMOV.codAux).
     /*
     ACCUMULATE DMOV.DbeMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.DbeMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.HbeMn1 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.HbeMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.DbeMn1 (SUB-TOTAL BY DMOV.CodAux).
     ACCUMULATE DMOV.DbeMn2 (SUB-TOTAL BY DMOV.CodAux).
     ACCUMULATE DMOV.HbeMn1 (SUB-TOTAL BY DMOV.CodAux).
     ACCUMULATE DMOV.HbeMn2 (SUB-TOTAL BY DMOV.CodAux).
     */
     IF LAST-OF(DMOV.CodAux) THEN DO:
        UNDERLINE STREAM report DMOV.GloDoc
                                DMOV.ImpMn1
                                DMOV.ImpMn2
                                /*
                                DMOV.DbeMn1
                                DMOV.HbeMn1
                                DMOV.DbeMn2
                                DMOV.HbeMn2
                                */
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  ("TOTAL PROV. " + DMOV.CodAux) @ DMOV.GloDoc
                       ACCUM SUB-TOTAL BY (DMOV.CodAux) DMOV.ImpMn1 @ DMOV.ImpMn1
                       ACCUM SUB-TOTAL BY (DMOV.CodAux) DMOV.ImpMn2 @ DMOV.ImpMn2
                       /*
                       ACCUM SUB-TOTAL BY (DMOV.CodAux) DMOV.DbeMn1 @ DMOV.DbeMn1
                       ACCUM SUB-TOTAL BY (DMOV.CodAux) DMOV.HbeMn1 @ DMOV.HbeMn1
                       ACCUM SUB-TOTAL BY (DMOV.CodAux) DMOV.DbeMn2 @ DMOV.DbeMn2
                       ACCUM SUB-TOTAL BY (DMOV.CodAux) DMOV.HbeMn2 @ DMOV.HbeMn2
                       */
                       WITH FRAME F-Cab.
        UNDERLINE STREAM report DMOV.GloDoc
                                DMOV.ImpMn1
                                DMOV.ImpMn2
                                /*
                                DMOV.DbeMn1
                                DMOV.HbeMn1
                                DMOV.DbeMn2
                                DMOV.HbeMn2
                                */
                                WITH FRAME f-cab.
     END.
     IF LAST-OF(DMOV.CodCia) THEN DO:
        UNDERLINE STREAM report DMOV.GloDoc
                                DMOV.ImpMn1
                                DMOV.ImpMn2
                                /*
                                DMOV.DbeMn1
                                DMOV.HbeMn1
                                DMOV.DbeMn2
                                DMOV.HbeMn2
                                */
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  "TOTAL GENERAL " @ DMOV.GloDoc
                       ACCUM TOTAL BY (DMOV.CodCia) DMOV.ImpMn1 @ DMOV.ImpMn1
                       ACCUM TOTAL BY (DMOV.CodCia) DMOV.ImpMn2 @ DMOV.ImpMn2
                       /*
                       ACCUM TOTAL BY (DMOV.CodCia) DMOV.DbeMn1 @ DMOV.DbeMn1
                       ACCUM TOTAL BY (DMOV.CodCia) DMOV.HbeMn1 @ DMOV.HbeMn1
                       ACCUM TOTAL BY (DMOV.CodCia) DMOV.DbeMn2 @ DMOV.DbeMn2
                       ACCUM TOTAL BY (DMOV.CodCia) DMOV.HbeMn2 @ DMOV.HbeMn2
                       */
                       WITH FRAME F-Cab.
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
 DEF VAR x-Moneda AS CHAR FORMAT 'x(3)'.
 DEF VAR x-Import AS DEC FORMAT "(>>>,>>>,>>9.99)".
 DEF VAR x-ImpMn1 AS DEC FORMAT "(>>>,>>>,>>9.99)".
 DEF VAR x-ImpMn2 AS DEC FORMAT "(>>>,>>>,>>9.99)".
 
 DEFINE FRAME f-cab
        DMOV.CodAux COLUMN-LABEL "Codigo"
        DMOV.GloDoc COLUMN-LABEL "Nombre o Razon Social"
        DMOV.coddoc COLUMN-LABEL "Cod!Doc"
        DMOV.nrodoc COLUMN-LABEL "Numero!Documento"
        DMOV.fchvto COLUMN-LABEL " Fecha!Vencimiento" FORMAT "99/99/9999"
        x-Moneda
        x-Import        
        DMOV.FchCja FORMAT '99/99/9999'
        DMOV.OpeCja COLUMN-LABEL "Libro" 
        DMOV.AstCja COLUMN-LABEL "Voucher" 
        DMOV.NroChq COLUMN-LABEL "Cheque" 
        HEADER
        S-NOMCIA FORMAT 'x(50)'
        "DOCUMENTOS CANCELADOS" TO 75
        "FECHA : " TO 123 TODAY TO 133  SKIP
        "CANCELADOS DEL : " FILL-IN-FchCan-1 " AL " FILL-IN-FchCan-2
        "PAGINA : " TO 123 PAGE-NUMBER(report) FORMAT "ZZ9" TO 133 SKIP(2)
        "-----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                        Cod. Numero      Fecha                                                                           " SKIP
        "Codigo   Nombre o Razon Social          Doc. Documento  Vencimient    Mon       Importe      Fecha  Libro Voucher Cheque                 " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*       12345678901 123456789012345678901234567890 1234 1234567890 99/99/9999 123 (>>>,>>>,>>9.99) 99/99/9999 123 123456 12345678 */
         WITH WIDTH 165 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

 OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. 
 PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" {&Prn0} {&Prn5A} CHR(66) {&Prn3}.
 PUT STREAM report CONTROL "~033x" NULL "~017~033P" {&Prn0} {&Prn5A} CHR(66) {&Prn3}.
 FOR EACH DMOV 
     BREAK BY DMOV.CodCia
            BY DMOV.Fchvto
             BY DMOV.Codaux
              BY DMOV.Coddoc:
    IF DMOV.CodMon = 1
    THEN ASSIGN
            x-Moneda = 'S/.'
            x-Import = DMOV.ImpMn1.
    ELSE ASSIGN
            x-Moneda = 'US$'
            x-Import = DMOV.ImpMn2.
     DISPLAY STREAM report 
             DMOV.CodAux
             DMOV.GloDoc
             DMOV.coddoc
             DMOV.nrodoc
             DMOV.fchvto
             x-Moneda
             x-Import
             DMOV.FchCja
             DMOV.OpeCja 
             DMOV.AstCja 
             DMOV.NroChq 
             WITH FRAME F-Cab.
     ACCUMULATE DMOV.ImpMn1 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.ImpMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.ImpMn1 (SUB-TOTAL BY DMOV.FchVto).
     ACCUMULATE DMOV.ImpMn2 (SUB-TOTAL BY DMOV.FchVto).
     IF LAST-OF(DMOV.FchVto) THEN DO:
        ASSIGN
            x-ImpMn1 = ACCUM SUB-TOTAL BY (DMOV.FchVto) DMOV.ImpMn1 
            x-ImpMn2 = ACCUM SUB-TOTAL BY (DMOV.FchVto) DMOV.ImpMn2.
        UNDERLINE STREAM report DMOV.GloDoc
                                x-Import
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  ("TOTAL DEL " + STRING(DMOV.FchVto)) @ DMOV.GloDoc
                        'S/.' @ x-Moneda
                        x-ImpMn1 @ x-Import
                       WITH FRAME F-Cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  
                       'US$' @ x-Moneda
                       x-ImpMn2 @ x-Import
                       WITH FRAME F-Cab.
        UNDERLINE STREAM report DMOV.GloDoc
                                x-Import
                                WITH FRAME f-cab.
     END.
     IF LAST-OF(DMOV.CodCia) THEN DO:
        ASSIGN
            x-ImpMn1 = ACCUM TOTAL BY (DMOV.FchVto) DMOV.ImpMn1 
            x-ImpMn2 = ACCUM TOTAL BY (DMOV.FchVto) DMOV.ImpMn2.
        UNDERLINE STREAM report DMOV.GloDoc
                                x-Import
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  "TOTAL GENERAL " @ DMOV.GloDoc
                        'S/.' @ x-Moneda
                        x-ImpMn1 @ x-Import
                       WITH FRAME F-Cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  
                       'US$' @ x-Moneda
                       x-ImpMn2 @ x-Import
                       WITH FRAME F-Cab.
     END.
 END.
 PAGE STREAM report.
 OUTPUT STREAM report CLOSE.
 
END PROCEDURE.
/*
 DEFINE FRAME f-cab
        DMOV.CodAux COLUMN-LABEL "Codigo"
        DMOV.GloDoc COLUMN-LABEL "Nombre o Razon Social"
        DMOV.coddoc COLUMN-LABEL "Cod!Doc"
        DMOV.nrodoc COLUMN-LABEL "Numero!Documento"
        DMOV.fchvto COLUMN-LABEL " Fecha!Vencimiento" FORMAT "99/99/9999"
        DMOV.ImpMn1 FORMAT "(>>>,>>>,>>9.99)" 
        DMOV.ImpMn2 FORMAT "(>>>,>>>,>>9.99)" 
        /*
        DMOV.DbeMn1 
        DMOV.HbeMn1
        DMOV.DbeMn2
        DMOV.HbeMn2
        DMOV.TpoCmb 
        */
        DMOV.TpoCmb 
        DMOV.AstCja COLUMN-LABEL "Voucher" 
        DMOV.OpeCja COLUMN-LABEL "Libro" 
        DMOV.NroChq COLUMN-LABEL "Cheque" 
        HEADER
        S-NOMCIA
        "DOCUMENTOS CANCELADOS" TO 75
        "FECHA : " TO 123 TODAY TO 133  SKIP
        "VENCIMIENTOS DEL : " D-FchDes " AL " D-FchHas
        "PAGINA : " TO 123 PAGE-NUMBER(report) FORMAT "ZZ9" TO 133 SKIP(2)
        "---------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                        Cod. Numero      Fecha                                                                               " SKIP
        "Codigo   Nombre o Razon Social          Doc. Documento  Vencimient      Importe(US$)     Importe(S/.)  T/Cambio Voucher Libro Cheque         " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

/* OUTPUT STREAM report TO C:\TMP\PRUEBA.PRN PAGED PAGE-SIZE 62. */
 OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. 
 PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66) .
 PUT STREAM report CONTROL "~033x" NULL "~017~033P".
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
             DMOV.ImpMn1
             DMOV.ImpMn2
             DMOV.TpoCmb 
             DMOV.AstCja 
             DMOV.OpeCja 
             DMOV.NroChq 
             WITH FRAME F-Cab.
     ACCUMULATE DMOV.ImpMn1 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.ImpMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.ImpMn1 (SUB-TOTAL BY DMOV.FchVto).
     ACCUMULATE DMOV.ImpMn2 (SUB-TOTAL BY DMOV.FchVto).
     /*
     ACCUMULATE DMOV.DbeMn1 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.DbeMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.HbeMn1 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.HbeMn2 (TOTAL BY DMOV.codcia).
     ACCUMULATE DMOV.DbeMn1 (SUB-TOTAL BY DMOV.FchVto).
     ACCUMULATE DMOV.DbeMn2 (SUB-TOTAL BY DMOV.FchVto).
     ACCUMULATE DMOV.HbeMn1 (SUB-TOTAL BY DMOV.FchVto).
     ACCUMULATE DMOV.HbeMn2 (SUB-TOTAL BY DMOV.FchVto).
     */
     IF LAST-OF(DMOV.FchVto) THEN DO:
        UNDERLINE STREAM report DMOV.GloDoc
                                DMOV.ImpMn1
                                DMOV.ImpMn2
                                /*
                                DMOV.DbeMn1
                                DMOV.HbeMn1
                                DMOV.DbeMn2
                                DMOV.HbeMn2
                                */
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  ("TOTAL DEL " + STRING(DMOV.FchVto)) @ DMOV.GloDoc
                       ACCUM SUB-TOTAL BY (DMOV.FchVto) DMOV.ImpMn1 @ DMOV.ImpMn1
                       ACCUM SUB-TOTAL BY (DMOV.FchVto) DMOV.ImpMn2 @ DMOV.ImpMn2
                       /*
                       ACCUM SUB-TOTAL BY (DMOV.FchVto) DMOV.DbeMn1 @ DMOV.DbeMn1
                       ACCUM SUB-TOTAL BY (DMOV.FchVto) DMOV.HbeMn1 @ DMOV.HbeMn1
                       ACCUM SUB-TOTAL BY (DMOV.FchVto) DMOV.DbeMn2 @ DMOV.DbeMn2
                       ACCUM SUB-TOTAL BY (DMOV.FchVto) DMOV.HbeMn2 @ DMOV.HbeMn2
                       */
                       WITH FRAME F-Cab.
        UNDERLINE STREAM report DMOV.GloDoc
                                DMOV.ImpMn1
                                DMOV.ImpMn2
                                /*
                                DMOV.DbeMn1
                                DMOV.HbeMn1
                                DMOV.DbeMn2
                                DMOV.HbeMn2
                                */
                                WITH FRAME f-cab.
     END.
     IF LAST-OF(DMOV.CodCia) THEN DO:
        UNDERLINE STREAM report DMOV.GloDoc
                                DMOV.ImpMn1
                                DMOV.ImpMn2
                                /*
                                DMOV.DbeMn1
                                DMOV.HbeMn1
                                DMOV.DbeMn2
                                DMOV.HbeMn2
                                */
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        DISPLAY STREAM report  "TOTAL GENERAL " @ DMOV.GloDoc
                       ACCUM TOTAL BY (DMOV.CodCia) DMOV.ImpMn1 @ DMOV.ImpMn1
                       ACCUM TOTAL BY (DMOV.CodCia) DMOV.ImpMn2 @ DMOV.ImpMn2
                       /*
                       ACCUM TOTAL BY (DMOV.CodCia) DMOV.DbeMn1 @ DMOV.DbeMn1
                       ACCUM TOTAL BY (DMOV.CodCia) DMOV.HbeMn1 @ DMOV.HbeMn1
                       ACCUM TOTAL BY (DMOV.CodCia) DMOV.DbeMn2 @ DMOV.DbeMn2
                       ACCUM TOTAL BY (DMOV.CodCia) DMOV.HbeMn2 @ DMOV.HbeMn2
                       */
                       WITH FRAME F-Cab.
     END.
 END.
 PAGE STREAM report.
 OUTPUT STREAM report CLOSE.
*/

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
    DEFINE VARIABLE l-docs AS CHARACTER INITIAL "Todos" NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

    DO WITH FRAME {&FRAME-NAME}:
        FOR EACH CP-TPRO NO-LOCK WHERE
            CP-TPRO.CODCIA = CB-CODCIA AND
            CP-TPRO.CORRELATIVO = YES BREAK BY CP-TPRO.CODDOC:
            IF FIRST-OF(CP-TPRO.CODDOC) THEN DO:
                ASSIGN l-docs = l-docs + "," + CP-TPRO.CODDOC .
            END.
        END.
        COMBO-coddoc:LIST-ITEMS = l-docs.
        COMBO-coddoc = ENTRY(1,l-docs).
        FILL-IN-FchCan-1 = TODAY - DAY(TODAY) + 1.
        FILL-IN-FchCan-2 = TODAY.
        FIND FIRST GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA NO-LOCK NO-ERROR.
        IF AVAILABLE GN-DIVI THEN FILL-IN-CodDiv = GN-DIVI.CodDiv.
        DISPLAY FILL-IN-CodDiv COMBO-coddoc FILL-IN-FchCan-1 FILL-IN-FchCan-2.
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

