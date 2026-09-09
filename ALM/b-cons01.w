&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.

DEF VAR s-TipMov AS CHAR INIT 'I' NO-UNDO.
DEF VAR s-CodDoc AS CHAR INIT 'D/F' NO-UNDO.
DEF VAR s-CodMov AS INT NO-UNDO.

FIND FacDocum WHERE CodCia = s-codcia
    AND CodDoc = s-coddoc
    NO-LOCK NO-ERROR.
IF AVAILABLE FacDocum THEN s-CodMov = FacDocum.CodMov.

DEF VAR x-NroDoc LIKE Ccbcdocu.nrodoc NO-UNDO.
DEF VAR x-FchDoc LIKE Ccbcdocu.fchdoc NO-UNDO.
DEF VAR x-IMpTot LIKE Ccbcdocu.imptot NO-UNDO.
DEF VAR x-Moneda AS CHAR FORMAT 'x(3)' NO-UNDO.

&SCOPED-DEFINE CONDICION Almcmov.CodCia = s-codcia ~
 AND Almcmov.CodAlm = x-codalm ~
 AND Almcmov.TipMov = s-tipmov ~
 AND Almcmov.CodMov = s-codmov ~
 AND Almcmov.FlgEst = x-flgest ~
 AND Almcmov.FchDoc >= x-fchdoc-1 ~
 AND Almcmov.FchDoc <= x-fchdoc-2

&SCOPED-DEFINE FILTRO1 (Almcmov.nomref BEGINS FILL-IN-filtro) AND {&CONDICION}
&SCOPED-DEFINE FILTRO2 INDEX ( Almcmov.nomref , FILL-IN-filtro ) <> 0 AND {&CONDICION}

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.
DEFINE STREAM str-rpt.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almcmov

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almcmov.CodAlm Almcmov.NroRf2 ~
Almcmov.NroDoc Almcmov.FchDoc Almcmov.CodCli Almcmov.NomRef ~
fNroDoc() @ x-NroDoc fFChDoc() @ x-FchDoc fMoneda() @ x-Moneda ~
fImpTot() @ x-IMpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almcmov WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table Almcmov
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almcmov


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table Btn_Excel x-FlgEst x-CodAlm ~
CMB-filtro x-FchDoc-1 FILL-IN-filtro x-FchDoc-2 
&Scoped-Define DISPLAYED-OBJECTS x-FlgEst x-CodAlm CMB-filtro x-FchDoc-1 ~
FILL-IN-filtro x-FchDoc-2 

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
Nombres que inicien con|y||INTEGRAL.Almcmov.NomRef
Nombres que contengan|y||INTEGRAL.Almcmov.NomRef
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "Nombres que inicien con,Nombres que contengan",
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFchDoc B-table-Win 
FUNCTION fFchDoc RETURNS DATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImpTot B-table-Win 
FUNCTION fImpTot RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMoneda B-table-Win 
FUNCTION fMoneda RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroDoc B-table-Win 
FUNCTION fNroDoc RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U NO-FOCUS
     LABEL "Generar Archivo" 
     SIZE 9 BY 1.5 TOOLTIP "Genera archivo texto"
     BGCOLOR 8 .

DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Clientes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Nombres que inicien con","Nombres que contengan" 
     SIZE 19 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FlgEst AS CHARACTER INITIAL "P" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pendiente", "P",
"Cerrada", "C",
"Anulada", "A"
     SIZE 28 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almcmov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almcmov.CodAlm
      Almcmov.NroRf2 COLUMN-LABEL "Devolucion"
      Almcmov.NroDoc COLUMN-LABEL "No. Ingreso"
      Almcmov.FchDoc COLUMN-LABEL "Fecha!de Devolucion"
      Almcmov.CodCli COLUMN-LABEL "<<<Cliente>>>"
      Almcmov.NomRef FORMAT "x(35)"
      fNroDoc() @ x-NroDoc COLUMN-LABEL "Nota de Credito" FORMAT "x(10)"
      fFChDoc() @ x-FchDoc COLUMN-LABEL "Fecha de !Nota de Credito"
      fMoneda() @ x-Moneda COLUMN-LABEL "Mon"
      fImpTot() @ x-IMpTot COLUMN-LABEL "Importe Total"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 111 BY 11.12
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 4.08 COL 1
     Btn_Excel AT ROW 2.35 COL 75
     x-FlgEst AT ROW 1.19 COL 10 NO-LABEL
     x-CodAlm AT ROW 2.15 COL 8 COLON-ALIGNED
     CMB-filtro AT ROW 3.12 COL 8 COLON-ALIGNED
     x-FchDoc-1 AT ROW 2.15 COL 28 COLON-ALIGNED
     FILL-IN-filtro AT ROW 3.12 COL 28 COLON-ALIGNED NO-LABEL
     x-FchDoc-2 AT ROW 2.15 COL 45 COLON-ALIGNED
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.19 COL 4
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 14.31
         WIDTH              = 111.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table TEXT-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Almcmov"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   = INTEGRAL.Almcmov.CodAlm
     _FldNameList[2]   > INTEGRAL.Almcmov.NroRf2
"Almcmov.NroRf2" "Devolucion" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > INTEGRAL.Almcmov.NroDoc
"Almcmov.NroDoc" "No. Ingreso" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[4]   > INTEGRAL.Almcmov.FchDoc
"Almcmov.FchDoc" "Fecha!de Devolucion" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[5]   > INTEGRAL.Almcmov.CodCli
"Almcmov.CodCli" "<<<Cliente>>>" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[6]   > INTEGRAL.Almcmov.NomRef
"Almcmov.NomRef" ? "x(35)" "character" ? ? ? ? ? ? no ?
     _FldNameList[7]   > "_<CALC>"
"fNroDoc() @ x-NroDoc" "Nota de Credito" "x(10)" ? ? ? ? ? ? ? no ?
     _FldNameList[8]   > "_<CALC>"
"fFChDoc() @ x-FchDoc" "Fecha de !Nota de Credito" ? ? ? ? ? ? ? ? no ?
     _FldNameList[9]   > "_<CALC>"
"fMoneda() @ x-Moneda" "Mon" ? ? ? ? ? ? ? ? no ?
     _FldNameList[10]   > "_<CALC>"
"fImpTot() @ x-IMpTot" "Importe Total" ? ? ? ? ? ? ? ? no ?
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
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


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel B-table-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Generar Archivo */
DO:

    DEFINE VARIABLE cFilename AS CHARACTER NO-UNDO.
    DEFINE VARIABLE OKpressed AS LOGICAL INITIAL TRUE.

    cFilename = "M:\DEVOLUCION.txt".

    SYSTEM-DIALOG GET-FILE cFilename
        TITLE      "Seleccione Archivo..."
        FILTERS    "Texto (*.txt)"   "*.txt",
                   "Todos (*.*)"     "*.*"
        MUST-EXIST
        SAVE-AS
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = TRUE THEN DO:
        RUN Genera-Txt(cFilename).
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-filtro B-table-Win
ON VALUE-CHANGED OF CMB-filtro IN FRAME F-Main /* Clientes */
DO:
/*    IF CMB-filtro = CMB-filtro:SCREEN-VALUE 
 *         AND FILL-IN-filtro = FILL-IN-filtro:SCREEN-VALUE THEN RETURN.*/
        
    ASSIGN
        FILL-IN-filtro
        CMB-filtro.
    CASE CMB-filtro:
         WHEN 'Todos':U THEN DO:
              RUN set-attribute-list('Key-Name=?').
         END.
         WHEN 'Nombres que contengan':U THEN DO:
              IF FILL-IN-filtro <> "" 
              THEN RUN set-attribute-list('Key-Name=' + CMB-filtro).
              ELSE RUN set-attribute-list('Key-Name=?').
         END.
         OTHERWISE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    END CASE.
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro B-table-Win
ON LEAVE OF FILL-IN-filtro IN FRAME F-Main
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodAlm B-table-Win
ON VALUE-CHANGED OF x-CodAlm IN FRAME F-Main /* Almacen */
DO:
  IF x-CodAlm <> SELF:SCREEN-VALUE
  THEN DO:
    ASSIGN {&SELF-NAME}.
    APPLY "VALUE-CHANGED" TO CMB-filtro.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchDoc-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchDoc-1 B-table-Win
ON LEAVE OF x-FchDoc-1 IN FRAME F-Main /* Desde */
DO:
  IF x-FChDoc-1 <> INPUT x-FchDoc-1 THEN DO:
    ASSIGN {&SELF-NAME}.
    APPLY "VALUE-CHANGED" TO CMB-filtro.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchDoc-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchDoc-2 B-table-Win
ON LEAVE OF x-FchDoc-2 IN FRAME F-Main /* Hasta */
DO:
  IF x-FChDoc-2 <> INPUT x-FchDoc-2 THEN DO:
    ASSIGN {&SELF-NAME}.
    APPLY "VALUE-CHANGED" TO CMB-filtro.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FlgEst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FlgEst B-table-Win
ON VALUE-CHANGED OF x-FlgEst IN FRAME F-Main
DO:
  IF x-FlgEst <> SELF:SCREEN-VALUE
  THEN DO:
    ASSIGN {&SELF-NAME}.
    APPLY "VALUE-CHANGED" TO CMB-filtro.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win adm/support/_adm-opn.p
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
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Txt B-table-Win 
PROCEDURE Genera-Txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_file AS CHARACTER.

    IF para_file = "" THEN RETURN.

    OUTPUT STREAM str-rpt TO VALUE(para_file).
    FOR EACH Almcmov WHERE
        {&KEY-PHRASE} AND
        {&CONDICION} NO-LOCK:
        DISPLAY STREAM str-rpt
            Almcmov.CodAlm
            Almcmov.NroRf2 COLUMN-LABEL "Devolucion"
            Almcmov.NroDoc COLUMN-LABEL "No. Ingreso"
            Almcmov.FchDoc COLUMN-LABEL "Fecha!de Devolucion"
            Almcmov.CodCli COLUMN-LABEL "<<<Cliente>>>"
            Almcmov.NomRef FORMAT "x(35)"
            fNroDoc() @ x-NroDoc COLUMN-LABEL "Nota de Credito" FORMAT "x(10)"
            fFChDoc() @ x-FchDoc COLUMN-LABEL "Fecha de !Nota de Credito"
            fMoneda() @ x-Moneda COLUMN-LABEL "Mon"
            fImpTot() @ x-IMpTot COLUMN-LABEL "Importe Total"
            WITH STREAM-IO WIDTH 300.

        DISPLAY
            "   Devolucón: " + Almcmov.NroRf2 @ FI-MENSAJE
            WITH FRAME F-PROCESO.
    END.
    OUTPUT STREAM str-rpt CLOSE.
    HIDE FRAME F-PROCESO.
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

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
    x-CodAlm = s-codalm
    x-FchDoc-1 = TODAY - DAY(TODAY) + 1
    x-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia:
        x-CodAlm:ADD-LAST(Almacen.codalm).
    END.
    DISPLAY x-CodAlm x-FchDoc-1 x-FChDoc-2.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win adm/support/_key-snd.p
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Almcmov"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFchDoc B-table-Win 
FUNCTION fFchDoc RETURNS DATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF x-FlgEst = 'P' THEN RETURN ?.   /* Function return value. */
  FIND FIRST Ccbcdocu USE-INDEX Llave07 WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = 'N/C'
    AND Ccbcdocu.codref = Almcmov.codref
    AND Ccbcdocu.nroref = Almcmov.nrorf1
    AND Ccbcdocu.codalm = ALmcmov.codalm
    AND Ccbcdocu.flgest <> 'A'
    AND Ccbcdocu.nroped = STRING(Almcmov.nrodoc,"999999")
    NO-LOCK NO-ERROR.
  IF AVAILABLE Ccbcdocu THEN RETURN Ccbcdocu.fchdoc.
  ELSE RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImpTot B-table-Win 
FUNCTION fImpTot RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR x-ImpTot AS DEC NO-UNDO.
  FOR EACH Almdmov OF Almcmov:
    x-Imptot = x-Imptot + Almdmov.implin.
  END.
  RETURN x-ImpTot.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMoneda B-table-Win 
FUNCTION fMoneda RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF Almcmov.codmon = 1 THEN RETURN 'S/.'.
  IF ALmcmov.codmon = 2 THEN RETURN 'US$'.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroDoc B-table-Win 
FUNCTION fNroDoc RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF x-FlgEst = 'P' THEN RETURN "".   /* Function return value. */
  FIND FIRST Ccbcdocu USE-INDEX Llave07 WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = 'N/C'
    AND Ccbcdocu.codref = Almcmov.codref
    AND Ccbcdocu.nroref = Almcmov.nrorf1
    AND Ccbcdocu.codalm = ALmcmov.codalm
    AND Ccbcdocu.flgest <> 'A'
    AND Ccbcdocu.nroped = STRING(Almcmov.nrodoc,"999999")
    NO-LOCK NO-ERROR.
  IF AVAILABLE Ccbcdocu THEN RETURN Ccbcdocu.nrodoc.
  ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


