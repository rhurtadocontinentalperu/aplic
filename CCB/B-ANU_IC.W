&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-CODDIV AS CHAR.
DEFINE SHARED VARIABLE S-CODTER AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.

DEFINE NEW SHARED VARIABLE input-var-1 AS CHARACTER.
DEFINE NEW SHARED VARIABLE input-var-2 AS CHARACTER.
DEFINE NEW SHARED VARIABLE input-var-3 AS CHARACTER.
DEFINE NEW SHARED VARIABLE output-var-1 AS ROWID.
DEFINE NEW SHARED VARIABLE output-var-2 AS CHARACTER.
DEFINE NEW SHARED VARIABLE output-var-3 AS CHARACTER.

/* Definición de variables locales */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VARIABLE whpadre     AS WIDGET-HANDLE.
DEFINE VARIABLE wh          AS WIDGET-HANDLE.
DEFINE VARIABLE curr-record AS RECID.
DEFINE VARIABLE C-Mon       AS CHARACTER NO-UNDO.
DEFINE BUFFER   b-ccbccaja FOR ccbccaja.
DEFINE BUFFER   b-ccbdcaja FOR ccbdcaja.
DEFINE BUFFER   B-CcbCDocu FOR CcbCDocu.
DEFINE VARIABLE RPTA        AS CHARACTER NO-UNDO.
DEFINE VARIABLE L-TIENE-NC AS LOGICAL INIT NO.

/* Preprocesadores para condiciones */

&Scoped-define Condicion ccbccaja.codcia = s-codcia ~
AND ( ccbccaja.tipo = "CABO" OR ccbccaja.tipo = "CAFA") ~
AND ccbccaja.coddiv = s-coddiv AND ccbccaja.coddoc = "I/C" ~
AND CcbCCaja.FchDoc >= f-desde AND CcbCCaja.FchDoc <= f-hasta ~
AND ccbccaja.flgest <> "A" AND ccbccaja.flgcie <> "C" ~
AND ccbccaja.codcaja = s-codter 

&SCOPED-DEFINE CODIGO integral.CcbCCaja.NroDoc

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 ( integral.CcbCCaja.NomCli BEGINS FILL-IN-filtro )
&SCOPED-DEFINE FILTRO2 ( INDEX ( integral.CcbCCaja.NomCli , FILL-IN-filtro ) <> 0 )

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

DEFINE BUFFER B-Faccpedm FOR Faccpedm.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartLookup

&Scoped-define ADM-SUPPORTED-LINKS                                                   Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCCaja CcbDCaja

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCCaja.NroDoc CcbCCaja.FchDoc ~
CcbCCaja.NomCli CcbDCaja.CodRef CcbDCaja.NroRef C-Mon @ C-Mon ~
CcbDCaja.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCCaja WHERE ~{&KEY-PHRASE} ~
      AND {&condicion} ~
 NO-LOCK, ~
      FIRST CcbDCaja OF CcbCCaja NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CcbCCaja CcbDCaja
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCCaja


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 CMB-filtro f-desde f-hasta ~
FILL-IN-codigo FILL-IN-filtro br_table 
&Scoped-Define DISPLAYED-OBJECTS CMB-filtro f-desde f-hasta w-divi ~
FILL-IN-codigo FILL-IN-filtro 

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
Nombres que inicien con|y||integral.CcbCCaja.NomCli
Nombres que contengan|y||integral.CcbCCaja.NomCli
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" L-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
Código|y||integral.CcbCCaja.CodCia|yes,integral.CcbCCaja.CodDoc|yes,integral.CcbCCaja.NroDoc|yes
Descripción|||integral.CcbCCaja.CodCia|yes,integral.CcbCCaja.NomCli|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "Código,Descripción",
     Sort-Case = Código':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES></FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Nombres que inicien con" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     SIZE 25.57 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.29 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE w-divi AS CHARACTER FORMAT "XX-XXX":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 9.19.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCCaja, 
      CcbDCaja SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table L-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCCaja.NroDoc COLUMN-LABEL "Numero I/C" FORMAT "XXX-XXXXXXXX"
      CcbCCaja.FchDoc COLUMN-LABEL "Fecha de I/C"
      CcbCCaja.NomCli COLUMN-LABEL "Nombre de Cliente" FORMAT "X(40)"
      CcbDCaja.CodRef COLUMN-LABEL "Doc" FORMAT "x(4)"
      CcbDCaja.NroRef FORMAT "XXX-XXXXXXXX"
      C-Mon @ C-Mon COLUMN-LABEL "Mon" FORMAT "X(4)"
      CcbDCaja.ImpTot
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 78.29 BY 6.62
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CMB-filtro AT ROW 2.19 COL 1.86 NO-LABEL
     f-desde AT ROW 1.23 COL 49.14 COLON-ALIGNED
     f-hasta AT ROW 1.23 COL 65.86 COLON-ALIGNED
     w-divi AT ROW 1.15 COL 6.43 COLON-ALIGNED
     FILL-IN-codigo AT ROW 1.23 COL 25.72 COLON-ALIGNED NO-LABEL
     FILL-IN-filtro AT ROW 2.23 COL 27.72 NO-LABEL
     br_table AT ROW 3.31 COL 1.86
     RECT-1 AT ROW 1 COL 1
     "Buscar x" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.35 COL 19
          FONT 6
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW L-table-Win ASSIGN
         HEIGHT             = 9.19
         WIDTH              = 80.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW L-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
/* BROWSE-TAB br_table FILL-IN-filtro F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN w-divi IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.CcbCCaja,integral.CcbDCaja OF integral.CcbCCaja"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&condicion}
"
     _FldNameList[1]   > integral.CcbCCaja.NroDoc
"CcbCCaja.NroDoc" "Numero I/C" "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.CcbCCaja.FchDoc
"CcbCCaja.FchDoc" "Fecha de I/C" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.CcbCCaja.NomCli
"CcbCCaja.NomCli" "Nombre de Cliente" "X(40)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > integral.CcbDCaja.CodRef
"CcbDCaja.CodRef" "Doc" "x(4)" "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   > integral.CcbDCaja.NroRef
"CcbDCaja.NroRef" ? "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ?
     _FldNameList[6]   > "_<CALC>"
"C-Mon @ C-Mon" "Mon" "X(4)" ? ? ? ? ? ? ? no ?
     _FldNameList[7]   = integral.CcbDCaja.ImpTot
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB L-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

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


&Scoped-define SELF-NAME CMB-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-filtro L-table-Win
ON VALUE-CHANGED OF CMB-filtro IN FRAME F-Main
DO:
    IF CMB-filtro = CMB-filtro:SCREEN-VALUE AND
        FILL-IN-filtro = FILL-IN-filtro:SCREEN-VALUE THEN RETURN.
    ASSIGN
        FILL-IN-filtro
        CMB-filtro.
    IF CMB-filtro = "Todos" THEN RUN set-attribute-list('Key-Name=?').
    ELSE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-desde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-desde L-table-Win
ON LEAVE OF f-desde IN FRAME F-Main /* Desde */
DO:
  IF f-desde = INPUT f-desde THEN RETURN.
  ASSIGN f-desde.
  RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-hasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-hasta L-table-Win
ON LEAVE OF f-hasta IN FRAME F-Main /* Hasta */
DO:
  IF f-hasta = INPUT f-hasta THEN RETURN.
  ASSIGN f-hasta.
  RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codigo L-table-Win
ON LEAVE OF FILL-IN-codigo IN FRAME F-Main
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
            RETURN NO-APPLY.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK L-table-Win 


ASSIGN f-desde = TODAY
       f-hasta = TODAY.
ON FIND OF CcbDCaja  
DO:
   C-Mon = "S/.".
   IF CcbDCaja.CodMon = 2 THEN C-Mon = "US$".
END.
w-divi = S-CodDiv.
/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases L-table-Win adm/support/_adm-opn.p
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
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Código':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCCaja.CodCia BY CcbCCaja.CodDoc BY CcbCCaja.NroDoc
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripción':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCCaja.CodCia BY CcbCCaja.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que inicien con */
    WHEN 'Nombres que contengan':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro2} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Código':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCCaja.CodCia BY CcbCCaja.CodDoc BY CcbCCaja.NroDoc
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripción':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCCaja.CodCia BY CcbCCaja.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que contengan */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Código':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCCaja.CodCia BY CcbCCaja.CodDoc BY CcbCCaja.NroDoc
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripción':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCCaja.CodCia BY CcbCCaja.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available L-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anulacion-del-Recibo L-table-Win 
PROCEDURE Anulacion-del-Recibo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  RUN ALM/D-CLAVE.R(FacCfgGn.Cla_Venta,OUTPUT RPTA). 
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
  L-TIENE-NC = NO.
  /* actualizamos la cuenta corriente */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
     FOR EACH ccbdcaja OF ccbccaja EXCLUSIVE-LOCK:
         FIND ccbcdocu WHERE 
              ccbcdocu.codcia = s-codcia AND
              ccbcdocu.coddoc = ccbdcaja.codref AND
              ccbcdocu.nrodoc = ccbdcaja.nroref EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE ccbcdocu THEN DO:
            FIND FIRST  B-CcbCDocu WHERE 
                        B-CcbCDocu.codcia = CcbCDocu.codcia AND
                        B-CcbCDocu.CodRef = CcbCDocu.CodDoc AND
                        B-CcbCDocu.NroRef = CcbCDocu.NroDoc NO-LOCK NO-ERROR.
             IF AVAILABLE B-CcbCDocu THEN DO:
                MESSAGE "Factura registra Notas de Credito " SKIP
                        "No. : " B-CcbCDocu.NroDoc VIEW-AS ALERT-BOX ERROR.
                L-TIENE-NC = YES.
                LEAVE.
             END.
             ASSIGN CCbCDocu.SdoAct = CCbCDocu.SdoAct + CCbdCaja.ImpTot.
                   CCbcDocu.flgest = "P".
             IF CcbCCaja.Voucher[6] <> "" THEN DO:
               FIND b-ccbdcaja WHERE  
                    b-CcbDCaja.CodCia = CcbDCaja.CodCia     AND
                    b-CcbDCaja.CodDoc = 'N/C'               AND
                    b-CcbDCaja.NroDoc = CcbCCaja.Voucher[6] AND
                    b-CcbDCaja.CodRef = CcbDCaja.CodRef     AND
                    b-CcbDCaja.NroRef = CcbDCaja.NroRef NO-LOCK NO-ERROR.
               IF AVAILABLE b-CcbDCaja THEN 
                  ASSIGN CCbCDocu.SdoAct = CCbCDocu.SdoAct + b-CCbdCaja.ImpTot.
            END.
         END.
         RELEASE CCbcDocu.
         IF CcbCCaja.Voucher[6] <> "" THEN DO:
            RUN Restaura-Nota-Credito.
         END.
         DELETE ccbdcaja.
     END.
     IF NOT L-TIENE-NC THEN DO:
        RUN Restaura-Boleta-Deposito.
        FIND b-ccbccaja WHERE ROWID(b-ccbccaja) = ROWID(ccbccaja) EXCLUSIVE-LOCK.
        ASSIGN b-ccbccaja.flgest = "A".
        RELEASE b-ccbccaja.
     END.
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anulacion-por-Reimpresion L-table-Win 
PROCEDURE Anulacion-por-Reimpresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  RUN ALM/D-CLAVE.R(FacCfgGn.Cla_Venta,OUTPUT RPTA). 
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
  L-TIENE-NC = NO.
  /* actualizamos la cuenta corriente */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
     FOR EACH ccbdcaja OF ccbccaja EXCLUSIVE-LOCK:
         FIND ccbcdocu WHERE 
              ccbcdocu.codcia = s-codcia AND
              ccbcdocu.coddoc = ccbdcaja.codref AND
              ccbcdocu.nrodoc = ccbdcaja.nroref EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE ccbcdocu THEN DO:
            FIND FIRST  B-CcbCDocu WHERE 
                        B-CcbCDocu.codcia = CcbCDocu.codcia AND
                        B-CcbCDocu.CodRef = CcbCDocu.CodDoc AND
                        B-CcbCDocu.NroRef = CcbCDocu.NroDoc NO-LOCK NO-ERROR.
             IF AVAILABLE B-CcbCDocu THEN DO:
                MESSAGE "Factura registra Notas de Credito " SKIP
                        "No. : " B-CcbCDocu.NroDoc VIEW-AS ALERT-BOX ERROR.
                L-TIENE-NC = YES.
                LEAVE.
             END.
             
            /****   Add by C.Q. 17/03/2000  
                    Imprime un Documento similar a la O/D Indicando
                    el motivo de Anulación  ****/
             FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
             IF AVAIL CcbDdocu THEN
                RUN ccb/r-motanu (ROWID(ccbcdocu), CcbDDocu.AlmDes, "Anulación por Reimpresión").
             RELEASE CcbDdocu.
             /**********************************/

/*            FIND Faccpedm WHERE 
 *                  Faccpedm.CodCia = ccbcdocu.codcia AND
 *                  Faccpedm.CodDiv = ccbcdocu.codDiv AND
 *                  Faccpedm.CodDoc = ccbcdocu.codPed AND
 *                  Faccpedm.NroPed = ccbcdocu.NroPed EXCLUSIVE-LOCK NO-ERROR.
 *             IF AVAILABLE Faccpedm THEN Faccpedm.FlgEst = "P".
 *             /****   Add by C.Q. 09/03/2000  ****/
 * /*            FOR EACH FacDpedm OF Faccpedm EXCLUSIVE-LOCK:
 *  *                 Facdpedm.FlgEst = "P".
 *  *             END.*/
 *             /***********************************/
 *             RELEASE Faccpedm.*/

            RUN Crea-pedido.    /****   Add by C.Q. 13/03/2000  ****/
            
            RUN VTA/DES_ALM.p(ROWID(ccbcdocu)).
            FOR EACH ccbDdocu OF ccbcdocu EXCLUSIVE-LOCK:
                DELETE ccbDdocu.
            END.
            ASSIGN ccbcdocu.sdoact = 0 
                   ccbcdocu.flgest = "A" 
                   CcbCDocu.FchAnu = TODAY 
                   CcbCDocu.UsuAnu = S-USER-ID 
                   ccbcdocu.codPed = "" 
                   ccbcdocu.NroPed = "". 
         END.
         RELEASE ccbcdocu.
         IF CcbCCaja.Voucher[6] <> "" THEN DO:
            RUN Restaura-Nota-Credito.
         END.
         DELETE ccbdcaja.
     END.
     IF NOT L-TIENE-NC THEN DO:
        RUN Restaura-Boleta-Deposito.
        FIND b-ccbccaja WHERE ROWID(b-ccbccaja) = ROWID(ccbccaja) EXCLUSIVE-LOCK.
        ASSIGN b-ccbccaja.flgest = "A".
        RELEASE b-ccbccaja.
     END.
  END.
  
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anulacion-Total L-table-Win 
PROCEDURE Anulacion-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN alm/p-ciealm (ccbccaja.fchdoc).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  RUN ALM/D-CLAVE.R(FacCfgGn.Cla_Venta,OUTPUT RPTA). 
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".

  L-TIENE-NC = NO.
  /* actualizamos la cuenta corriente */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
     FOR EACH ccbdcaja OF ccbccaja EXCLUSIVE-LOCK :
         FIND ccbcdocu WHERE 
              ccbcdocu.codcia = s-codcia AND
              ccbcdocu.coddoc = ccbdcaja.codref AND
              ccbcdocu.nrodoc = ccbdcaja.nroref EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE ccbcdocu THEN DO:
            FIND FIRST  B-CcbCDocu WHERE 
                        B-CcbCDocu.codcia = CcbCDocu.codcia AND
                        B-CcbCDocu.CodRef = CcbCDocu.CodDoc AND
                        B-CcbCDocu.NroRef = CcbCDocu.NroDoc NO-LOCK NO-ERROR.
             IF AVAILABLE B-CcbCDocu THEN DO:
                MESSAGE "Factura registra Notas de Credito " SKIP
                        "No. : " B-CcbCDocu.NroDoc VIEW-AS ALERT-BOX ERROR.
                L-TIENE-NC = YES.
                LEAVE.
             END.
            /****   Add by C.Q. 17/03/2000  
                    Imprime un Documento similar a la O/D Indicando
                    el motivo de Anulación  ****/
             FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
             IF AVAIL CcbDdocu THEN
                RUN ccb/r-motanu (ROWID(ccbcdocu), CcbDDocu.AlmDes, "Anulación Total").
             RELEASE CcbDdocu.
             /**********************************/
            FIND Faccpedm WHERE 
                 Faccpedm.CodCia = ccbcdocu.codcia AND
                 Faccpedm.CodDiv = ccbcdocu.codDiv AND
                 Faccpedm.CodDoc = ccbcdocu.codPed AND
                 Faccpedm.NroPed = ccbcdocu.NroPed EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE Faccpedm THEN Faccpedm.FlgEst = "A".
            /****   Add by C.Q. 09/03/2000  *****/
/*            FOR EACH FacDpedm OF Faccpedm EXCLUSIVE-LOCK:
 *                 Facdpedm.FlgEst = "A".
 *             END.*/
            /************************************/
            RELEASE Faccpedm.
            RUN VTA/DES_ALM.p(ROWID(ccbcdocu)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            FOR EACH ccbDdocu OF ccbcdocu:
                DELETE ccbDdocu.
            END.
            ASSIGN ccbcdocu.sdoact = 0
                   ccbcdocu.flgest = "A"
                   CcbCDocu.FchAnu = TODAY
                   CcbCDocu.UsuAnu = S-USER-ID
                   ccbcdocu.codPed = ""
                   ccbcdocu.NroPed = "".
         END.
         IF CcbCCaja.Voucher[6] <> "" THEN DO:
            RUN Restaura-Nota-Credito.
         END.
         DELETE ccbdcaja.
     END.
     IF NOT L-TIENE-NC THEN DO:
        RUN Restaura-Boleta-Deposito.
        FIND b-ccbccaja WHERE ROWID(b-ccbccaja) = ROWID(ccbccaja) EXCLUSIVE-LOCK.
        ASSIGN b-ccbccaja.flgest = "A".
        RELEASE b-ccbccaja.
     END.
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
        output-var-2 = STRING( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc, "XXX-XXXXXX" )
        output-var-3 = gn-clie.nomcli.

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-pedido L-table-Win 
PROCEDURE Crea-pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
         
         DEF VAR NROI AS INT.
         DEF VAR x-user as char.
         
         FIND Faccpedm WHERE 
              Faccpedm.CodCia = ccbcdocu.codcia AND
              Faccpedm.CodDiv = ccbcdocu.codDiv AND
              Faccpedm.CodDoc = ccbcdocu.codPed AND
              Faccpedm.NroPed = ccbcdocu.NroPed EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE Faccpedm THEN x-user = Faccpedm.Usuario.
         ELSE x-user = CcbCDocu.usuario.

         RELEASE Faccpedm.
         
         CREATE B-Faccpedm.
         FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA
                        AND  FacCorre.CodDoc = CcbCDocu.CodPed
                        AND  FacCorre.CodDiv = S-CODDIV
                       EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE FacCorre THEN 
             ASSIGN 
                 B-Faccpedm.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
                 FacCorre.Correlativo = FacCorre.Correlativo + 1.
   
         RELEASE FacCorre.
         
         ASSIGN B-Faccpedm.CodCia = S-CODCIA
                B-Faccpedm.CodDoc = CcbCDocu.CodPed /*"P/M"*/
                B-Faccpedm.codalm = CcbCDocu.CodAlm
                B-Faccpedm.FchPed = TODAY
                B-Faccpedm.PorIgv = CcbCDocu.PorIgv
                B-Faccpedm.TpoCmb = CcbCDocu.TpoCmb
                
                B-Faccpedm.CodDiv = CcbCDocu.CodDiv
                B-Faccpedm.CodVen = CcbCDocu.CodVen
                B-Faccpedm.TipVta = "1" 
                B-Faccpedm.Hora = STRING(TIME,"HH:MM")
                B-Faccpedm.Cmpbnte = CcbCDocu.CodDoc
                B-Faccpedm.Usuario = x-User
                B-Faccpedm.FlgEst = "S"
                
                B-Faccpedm.Codcli = CcbCDocu.CodCli
                B-Faccpedm.RucCli = CcbCDocu.RucCli   
                B-Faccpedm.Nomcli = CcbCDocu.NomCli  
                B-Faccpedm.DirCli = CcbCDocu.DirCli   
                B-Faccpedm.codmon = CcbCDocu.CodMon  
                
                B-Faccpedm.impbrt = CcbCDocu.ImpBrt
                B-Faccpedm.impdto = CcbCDocu.ImpDto
                B-Faccpedm.impexo = CcbCDocu.ImpExo
                B-Faccpedm.impigv = CcbCDocu.ImpIgv
                B-Faccpedm.impisc = CcbCDocu.ImpIsc
                B-Faccpedm.imptot = CcbCDocu.ImpTot
                B-Faccpedm.impvta = CcbCDocu.ImpVta
                B-Faccpedm.FmaPgo = CcbCDocu.FmaPgo
                B-Faccpedm.PorDto = CcbCDocu.PorDto
                B-Faccpedm.Glosa  = CcbCDocu.Glosa
                
                /* POR AHORA GRABAMOS EL TIPO DE ENTREGA */
                B-Faccpedm.CodTrans = CcbCDocu.CodAge
                B-Faccpedm.DocDesp  = IF CcbCDocu.FlgSit = "G" THEN "GUIA" ELSE ""
                B-Faccpedm.DocDesp  = IF CcbCDocu.FlgCon = "G" THEN "GUIA" ELSE ""
                .
 
         /* actualizamos el detalle */
         NROi = 1.     /****   Add by C.Q. 13/02/2000  ****/
         FOR EACH CcbDdocu NO-LOCK OF CcbCdocu:
             CREATE Facdpedm.
             ASSIGN facdpedm.CodCia = B-Faccpedm.CodCia
                    facdpedm.coddoc = B-Faccpedm.coddoc
                    facdpedm.NroPed = B-Faccpedm.NroPed
                    Facdpedm.FlgEst = B-Faccpedm.FlgEst
                    Facdpedm.Hora   = B-Faccpedm.Hora
                    FacDPedm.FchPed = B-Faccpedm.FchPed
                    facdpedm.NroItm = NROi
             
                    Facdpedm.codmat = CcbDDocu.codmat
                    Facdpedm.factor = CcbDDocu.Factor
                    Facdpedm.impdto = CcbDDocu.ImpDto
                    Facdpedm.impigv = CcbDDocu.ImpIgv
                    Facdpedm.impisc = CcbDDocu.ImpIsc
                    Facdpedm.implin = CcbDDocu.ImpLin
                    Facdpedm.aftigv = CcbDDocu.AftIgv
                    Facdpedm.aftisc = CcbDDocu.AftIsc
                    Facdpedm.canped = CcbDDocu.CanDes
                    Facdpedm.pordto = CcbDDocu.PorDto
                    Facdpedm.prebas = CcbDDocu.PreBas
                    Facdpedm.preuni = CcbDDocu.PreUni
                    Facdpedm.prevta[1] = CcbDDocu.PreVta[1]
                    Facdpedm.prevta[2] = CcbDDocu.PreVta[2]
                    Facdpedm.prevta[3] = CcbDDocu.PreVta[3]
                    Facdpedm.undvta = CcbDDocu.UndVta
                    Facdpedm.AlmDes = CcbDDocu.AlmDes.
             NROi = NROi + 1.
         END.

         RELEASE B-Faccpedm.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI L-table-Win _DEFAULT-DISABLE
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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN
        output-var-1 = ?
        output-var-2 = ?
        output-var-3 = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Restaura-Boleta-Deposito L-table-Win 
PROCEDURE Restaura-Boleta-Deposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF CcbCCaja.Voucher[5] <> "" AND (CcbCCaja.ImpNac[5] + CcbCCaja.ImpUsa[5]) > 0 THEN DO:
       FIND ccbboldep WHERE 
            ccbboldep.CodCia = CcbCCaja.CodCia AND  
            ccbboldep.CodDoc = "BD" AND  
            ccbboldep.CodCli = CcbCCaja.CodCli AND  
            ccbboldep.nrodoc = CcbCCaja.Voucher[5] 
            EXCLUSIVE-LOCK NO-ERROR.
       IF AVAIL ccbboldep THEN DO:
          IF CcbBolDep.CodMon = 1 THEN
             ASSIGN CcbBolDep.SdoAct = CcbBolDep.SdoAct + (CcbCCaja.ImpNac[5] + 
                                       (CcbCCaja.ImpUsa[5] * CcbCCaja.TpoCmb)).
          ELSE
             ASSIGN CcbBolDep.SdoAct = CcbBolDep.SdoAct + (CcbCCaja.ImpUsa[5] + 
                                       (CcbCCaja.ImpNac[5] / CcbCCaja.TpoCmb)).
          IF CcbBolDep.SdoAct > 0 THEN CcbBolDep.FlgEst = "P".
       END.
       RELEASE ccbboldep.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Restaura-Nota-Credito L-table-Win 
PROCEDURE Restaura-Nota-Credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF CcbCCaja.Voucher[6] <> "" THEN DO:
       FIND b-ccbdcaja WHERE  
                 b-CcbDCaja.CodCia = CcbDCaja.CodCia     AND
                 b-CcbDCaja.CodDoc = 'N/C'               AND
                 b-CcbDCaja.NroDoc = CcbCCaja.Voucher[6] AND
                 b-CcbDCaja.CodRef = CcbDCaja.CodRef     AND
                 b-CcbDCaja.NroRef = CcbDCaja.NroRef 
                 EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE b-CcbDCaja THEN DO:
          FIND ccbcdocu WHERE 
               ccbcdocu.codcia = b-CcbDCaja.CodCia AND
               ccbcdocu.coddoc = b-CcbDCaja.CodDoc AND
               ccbcdocu.nrodoc = b-CcbDCaja.NroDoc 
               EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE ccbcdocu THEN 
             ASSIGN ccbcdocu.sdoact = ccbcdocu.sdoact + b-CcbDCaja.ImpTot
                    ccbcdocu.flgest = "P".
          RELEASE ccbcdocu.
          DELETE b-CcbDCaja.
       END.
       RELEASE b-CcbDCaja.
    END.
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key L-table-Win adm/support/_key-snd.p
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records L-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCCaja"}
  {src/adm/template/snd-list.i "CcbDCaja"}

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


