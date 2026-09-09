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
DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA AS CHARACTER.
DEFINE SHARED VARIABLE S-CODDIV AS CHAR.
DEFINE SHARED VARIABLE input-var-1 AS CHARACTER.
DEFINE SHARED VARIABLE input-var-2 AS CHARACTER.
DEFINE SHARED VARIABLE input-var-3 AS CHARACTER.
DEFINE SHARED VARIABLE output-var-1 AS ROWID.
DEFINE SHARED VARIABLE output-var-2 AS CHARACTER.
DEFINE SHARED VARIABLE output-var-3 AS CHARACTER.

/* Definición de variables locales */
DEFINE VARIABLE whpadre AS WIDGET-HANDLE.
DEFINE VARIABLE wh      AS WIDGET-HANDLE.
DEFINE VARIABLE curr-record AS RECID.
DEFINE VARIABLE X-STA   AS CHAR.

/* Preprocesadores para condiciones */
&SCOPED-DEFINE CONDICION ( integral.CcbCCaja.CodCia = S-CODCIA AND ~
                           integral.CcbCCaja.CodDiv = S-CODDIV AND ~
                           integral.CcbCCaja.CodDoc = "I/C" AND ~
                           integral.CcbCCaja.FchDoc >= f-desde AND ~
                           integral.CcbCCaja.FchDoc <= f-hasta )
                           
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
&Scoped-define INTERNAL-TABLES CcbCCaja

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCCaja.CodDoc CcbCCaja.NroDoc ~
CcbCCaja.FchDoc CcbCCaja.CodCli CcbCCaja.NomCli CcbCCaja.VueNac ~
CcbCCaja.VueUsa X-STA @ X-STA CcbCCaja.Tipo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCCaja WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} USE-INDEX LLAVE07 NO-LOCK ~
    BY CcbCCaja.NroDoc INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCCaja WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} USE-INDEX LLAVE07 NO-LOCK ~
    BY CcbCCaja.NroDoc INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table CcbCCaja
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCCaja


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-CODIGO f-desde f-hasta CMB-filtro ~
FILL-IN-filtro br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CODIGO f-desde f-hasta CMB-filtro ~
FILL-IN-filtro 

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
Nombres que Inicien con|y||integral.CcbCCaja.NomCli
Nombres que Contengan|y||integral.CcbCCaja.NomCli
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
<SORTBY-OPTIONS>
Codigo|y||integral.CcbCCaja.CodCia|yes,integral.CcbCCaja.NroDoc|no
Descripcion|||integral.CcbCCaja.CodCia|yes,integral.CcbCCaja.NomCli|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "Codigo,Descripcion",
     Sort-Case = Codigo':U).

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
DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 21.14 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CODIGO AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCCaja SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table L-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCCaja.CodDoc COLUMN-LABEL "Cod" FORMAT "x(4)":U
      CcbCCaja.NroDoc FORMAT "XXX-XXXXXXXX":U
      CcbCCaja.FchDoc COLUMN-LABEL "Fecha  Emision" FORMAT "99/99/9999":U
      CcbCCaja.CodCli COLUMN-LABEL "  Codigo" FORMAT "x(10)":U
      CcbCCaja.NomCli COLUMN-LABEL "Cliente" FORMAT "X(43)":U
      CcbCCaja.VueNac COLUMN-LABEL "Vuelto S/." FORMAT "->>,>>9.99":U
      CcbCCaja.VueUsa COLUMN-LABEL "Vuelto US$." FORMAT "->>,>>9.99":U
      X-STA @ X-STA COLUMN-LABEL "Estado" FORMAT "XXXX":U
      CcbCCaja.Tipo COLUMN-LABEL "Tipo" FORMAT "x(14)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 98.72 BY 7.96
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CODIGO AT ROW 1.15 COL 3 COLON-ALIGNED NO-LABEL
     f-desde AT ROW 1.19 COL 62.57 COLON-ALIGNED
     f-hasta AT ROW 1.19 COL 77.72 COLON-ALIGNED
     CMB-filtro AT ROW 1.12 COL 16.14 NO-LABEL
     FILL-IN-filtro AT ROW 1.15 COL 37.57 NO-LABEL
     br_table AT ROW 2.12 COL 1.29
     "No." VIEW-AS TEXT
          SIZE 3.14 BY .5 AT ROW 1.31 COL 1.72
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW L-table-Win ASSIGN
         HEIGHT             = 9.15
         WIDTH              = 99.86.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table FILL-IN-filtro F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.CcbCCaja"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE"
     _OrdList          = "INTEGRAL.CcbCCaja.NroDoc|yes"
     _Where[1]         = "{&CONDICION} USE-INDEX LLAVE07"
     _FldNameList[1]   > integral.CcbCCaja.CodDoc
"CcbCCaja.CodDoc" "Cod" "x(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.CcbCCaja.NroDoc
"CcbCCaja.NroDoc" ? "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.CcbCCaja.FchDoc
"CcbCCaja.FchDoc" "Fecha  Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.CcbCCaja.CodCli
"CcbCCaja.CodCli" "  Codigo" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.CcbCCaja.NomCli
"CcbCCaja.NomCli" "Cliente" "X(43)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.CcbCCaja.VueNac
"CcbCCaja.VueNac" "Vuelto S/." ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.CcbCCaja.VueUsa
"CcbCCaja.VueUsa" "Vuelto US$." ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"X-STA @ X-STA" "Estado" "XXXX" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > integral.CcbCCaja.Tipo
"CcbCCaja.Tipo" "Tipo" "x(14)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
        F-DESDE
        F-HASTA
        FILL-IN-filtro
        CMB-filtro.
    
    IF CMB-filtro = "Todos" THEN RUN set-attribute-list('Key-Name=?').
    ELSE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    RUN dispatch IN THIS-PROCEDURE('row-changed':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-desde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-desde L-table-Win
ON LEAVE OF f-desde IN FRAME F-Main /* Desde */
DO:
   APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-hasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-hasta L-table-Win
ON LEAVE OF f-hasta IN FRAME F-Main /* Hasta */
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CODIGO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CODIGO L-table-Win
ON LEAVE OF FILL-IN-CODIGO IN FRAME F-Main
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
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK L-table-Win 


ASSIGN f-desde = TODAY
       f-hasta = TODAY.
ON FIND OF CcbCcaja  
DO:
    IF CcbCcaja.FlgEst = "P" THEN ASSIGN X-STA = "PEN".
    IF CcbCcaja.FlgEst = "C" THEN ASSIGN X-STA = "CAN".
    IF CcbCcaja.FlgEst = "A" THEN ASSIGN X-STA = "ANU".

END.

/* ***************************  Main Block  *************************** */

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
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCCaja.CodCia BY CcbCCaja.NroDoc DESCENDING
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCCaja.CodCia BY CcbCCaja.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que Inicien con */
    WHEN 'Nombres que Contengan':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro2} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCCaja.CodCia BY CcbCCaja.NroDoc DESCENDING
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCCaja.CodCia BY CcbCCaja.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que Contengan */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY CcbCCaja.CodCia BY CcbCCaja.NroDoc DESCENDING
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato L-table-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-TotNac AS DEC NO-UNDO.
    DEF VAR x-TotUsa AS DEC NO-UNDO.

    DEFINE FRAME F-REPORTE
    CcbCCaja.coddoc COLUMN-LABEL 'Cod'
    CcbCCaja.nrodoc FORMAT 'XXX-XXXXXXXXX' COLUMN-LABEL 'Numero'
    CcbCCaja.fchdoc FORMAT '99/99/9999' COLUMN-LABEL 'Fecha de!Emision'
    CcbCCaja.codcli COLUMN-LABEL 'Cliente'
    CcbCCaja.nomcli FORMAT 'x(40)' COLUMN-LABEL 'Nombre'
    x-totnac        FORMAT '->>>,>>9.99' COLUMN-LABEL 'Total S/.'
    x-totusa        FORMAT '->>>,>>9.99' COLUMN-LABEL 'Total US$'
    CcbCCaja.vuenac FORMAT '->>>,>>9.99' COLUMN-LABEL 'Vuelto S/.'
    CcbCCaja.vueusa FORMAT '->>>,>>9.99' COLUMN-LABEL 'Vuelto US$'
    x-sta COLUMN-LABEL 'Estado'
    CcbCCaja.tipo   COLUMN-LABEL 'Tipo'
  WITH WIDTH 250 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
      HEADER
      S-NOMCIA FORMAT "X(50)" AT 1 SKIP
      "INGRESOS A CAJA" AT 60
      "Pagina :" TO 128 PAGE-NUMBER(REPORT) TO 140 FORMAT "ZZZZZ9" SKIP
      "Fecha :" TO 128 TODAY TO 140 FORMAT "99/99/9999" SKIP
      "Hora :" TO 128 STRING(TIME,"HH:MM") TO 140 SKIP
      "DIVISION:" s-coddiv "DESDE EL" f-desde "HASTA EL" f-hasta SKIP
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  FOR EACH integral.CcbCCaja WHERE {&CONDICION} NO-LOCK:
        VIEW STREAM REPORT FRAME F-HEADER.
    ASSIGN
        x-totnac = CcbCCaja.ImpNac[1] + CcbCCaja.ImpNac[2] + 
                    CcbCCaja.ImpNac[3] + CcbCCaja.ImpNac[4] + 
                    CcbCCaja.ImpNac[5] + CcbCCaja.ImpNac[6] + 
                    CcbCCaja.ImpNac[7] + CcbCCaja.ImpNac[8] + 
                    CcbCCaja.ImpNac[9] + CcbCCaja.ImpNac[10]
        x-totusa = CcbCCaja.ImpUsa[1] + CcbCCaja.ImpUsa[2] + 
                    CcbCCaja.ImpUsa[3] + CcbCCaja.ImpUsa[4] + 
                    CcbCCaja.ImpUsa[5] + CcbCCaja.ImpUsa[6] + 
                    CcbCCaja.ImpUsa[7] + CcbCCaja.ImpUsa[8] + 
                    CcbCCaja.ImpUsa[9] + CcbCCaja.ImpUsa[10].

    IF CcbCCaja.FlgEst = "P" THEN ASSIGN X-STA = "PEN".
    IF CcbCCaja.FlgEst = "C" THEN ASSIGN X-STA = "CAN".
    IF CcbCCaja.FlgEst = "A" THEN ASSIGN X-STA = "ANU".

    DISPLAY STREAM REPORT 
        CcbCCaja.coddoc 
        CcbCCaja.nrodoc 
        CcbCCaja.fchdoc 
        CcbCCaja.codcli 
        CcbCCaja.nomcli 
        x-totnac
        x-totusa
        CcbCCaja.vuenac 
        CcbCCaja.vueusa 
        x-sta @ x-sta
        CcbCCaja.tipo
        WITH FRAME F-REPORTE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 L-table-Win 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-TotNac AS DEC NO-UNDO.
  DEF VAR x-TotUsa AS DEC NO-UNDO.

  DEFINE FRAME F-REPORTE
    ccbccaja.coddoc COLUMN-LABEL 'Cod'
    ccbccaja.nrodoc FORMAT 'XXX-XXXXXXXXX' COLUMN-LABEL 'Numero'
    ccbccaja.fchdoc FORMAT '99/99/9999' COLUMN-LABEL 'Fecha de!Emision'
    ccbccaja.codcli COLUMN-LABEL 'Cliente'
    ccbccaja.nomcli FORMAT 'x(40)' COLUMN-LABEL 'Nombre'
    x-totnac        FORMAT '->>>,>>9.99' COLUMN-LABEL 'Total S/.'
    x-totusa        FORMAT '->>>,>>9.99' COLUMN-LABEL 'Total US$'
    ccbccaja.vuenac FORMAT '->>>,>>9.99' COLUMN-LABEL 'Vuelto S/.'
    ccbccaja.vueusa FORMAT '->>>,>>9.99' COLUMN-LABEL 'Vuelto US$'
    x-sta COLUMN-LABEL 'Estado'
    ccbccaja.tipo   COLUMN-LABEL 'Tipo'
  WITH WIDTH 250 NO-BOX STREAM-IO DOWN. 
                
  DEFINE FRAME F-HEADER
      HEADER
      S-NOMCIA FORMAT "X(50)" AT 1 SKIP
      "INGRESOS A CAJA" AT 60
      "Pagina :" TO 128 PAGE-NUMBER(REPORT) TO 140 FORMAT "ZZZZZ9" SKIP
      "Fecha :" TO 128 TODAY TO 140 FORMAT "99/99/9999" SKIP
      "Hora :" TO 128 STRING(TIME,"HH:MM") TO 140 SKIP
      "DIVISION:" s-coddiv "DESDE EL" f-desde "HASTA EL" f-hasta SKIP
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
       
  FOR EACH integral.CcbCCaja WHERE {&CONDICION} AND {&Filtro1}
        USE-INDEX LLAVE07 NO-LOCK:
    VIEW STREAM REPORT FRAME F-HEADER.
    ASSIGN
        x-totnac = CcbCCaja.ImpNac[1] + CcbCCaja.ImpNac[2] + 
                    CcbCCaja.ImpNac[3] + CcbCCaja.ImpNac[4] + 
                    CcbCCaja.ImpNac[5] + CcbCCaja.ImpNac[6] + 
                    CcbCCaja.ImpNac[7] + CcbCCaja.ImpNac[8] + 
                    CcbCCaja.ImpNac[9] + CcbCCaja.ImpNac[10]
        x-totusa = CcbCCaja.ImpUsa[1] + CcbCCaja.ImpUsa[2] + 
                    CcbCCaja.ImpUsa[3] + CcbCCaja.ImpUsa[4] + 
                    CcbCCaja.ImpUsa[5] + CcbCCaja.ImpUsa[6] + 
                    CcbCCaja.ImpUsa[7] + CcbCCaja.ImpUsa[8] + 
                    CcbCCaja.ImpUsa[9] + CcbCCaja.ImpUsa[10].

    IF CcbCCaja.FlgEst = "P" THEN ASSIGN X-STA = "PEN".
    IF CcbCCaja.FlgEst = "C" THEN ASSIGN X-STA = "CAN".
    IF CcbCCaja.FlgEst = "A" THEN ASSIGN X-STA = "ANU".

    DISPLAY STREAM REPORT 
        ccbccaja.coddoc 
        ccbccaja.nrodoc 
        ccbccaja.fchdoc 
        ccbccaja.codcli 
        ccbccaja.nomcli 
        x-totnac
        x-totusa
        ccbccaja.vuenac 
        ccbccaja.vueusa 
        x-sta @ x-sta
        ccbccaja.tipo
        WITH FRAME F-REPORTE.
  END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-2 L-table-Win 
PROCEDURE Formato-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-TotNac AS DEC NO-UNDO.
  DEF VAR x-TotUsa AS DEC NO-UNDO.

  DEFINE FRAME F-REPORTE
    ccbccaja.coddoc COLUMN-LABEL 'Cod'
    ccbccaja.nrodoc FORMAT 'XXX-XXXXXXXXX' COLUMN-LABEL 'Numero'
    ccbccaja.fchdoc FORMAT '99/99/9999' COLUMN-LABEL 'Fecha de!Emision'
    ccbccaja.codcli COLUMN-LABEL 'Cliente'
    ccbccaja.nomcli FORMAT 'x(40)' COLUMN-LABEL 'Nombre'
    x-totnac        FORMAT '->>>,>>9.99' COLUMN-LABEL 'Total S/.'
    x-totusa        FORMAT '->>>,>>9.99' COLUMN-LABEL 'Total US$'
    ccbccaja.vuenac FORMAT '->>>,>>9.99' COLUMN-LABEL 'Vuelto S/.'
    ccbccaja.vueusa FORMAT '->>>,>>9.99' COLUMN-LABEL 'Vuelto US$'
    x-sta COLUMN-LABEL 'Estado'
    ccbccaja.tipo   COLUMN-LABEL 'Tipo'
  WITH WIDTH 250 NO-BOX STREAM-IO DOWN. 
                
  DEFINE FRAME F-HEADER
      HEADER
      S-NOMCIA FORMAT "X(50)" AT 1 SKIP
      "INGRESOS A CAJA" AT 60
      "Pagina :" TO 128 PAGE-NUMBER(REPORT) TO 140 FORMAT "ZZZZZ9" SKIP
      "Fecha :" TO 128 TODAY TO 140 FORMAT "99/99/9999" SKIP
      "Hora :" TO 128 STRING(TIME,"HH:MM") TO 140 SKIP
      "DIVISION:" s-coddiv "DESDE EL" f-desde "HASTA EL" f-hasta SKIP
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
       
  FOR EACH integral.CcbCCaja WHERE {&CONDICION} AND {&Filtro2}
        USE-INDEX LLAVE07 NO-LOCK:
    VIEW STREAM REPORT FRAME F-HEADER.
    ASSIGN
        x-totnac = CcbCCaja.ImpNac[1] + CcbCCaja.ImpNac[2] + 
                    CcbCCaja.ImpNac[3] + CcbCCaja.ImpNac[4] + 
                    CcbCCaja.ImpNac[5] + CcbCCaja.ImpNac[6] + 
                    CcbCCaja.ImpNac[7] + CcbCCaja.ImpNac[8] + 
                    CcbCCaja.ImpNac[9] + CcbCCaja.ImpNac[10]
        x-totusa = CcbCCaja.ImpUsa[1] + CcbCCaja.ImpUsa[2] + 
                    CcbCCaja.ImpUsa[3] + CcbCCaja.ImpUsa[4] + 
                    CcbCCaja.ImpUsa[5] + CcbCCaja.ImpUsa[6] + 
                    CcbCCaja.ImpUsa[7] + CcbCCaja.ImpUsa[8] + 
                    CcbCCaja.ImpUsa[9] + CcbCCaja.ImpUsa[10].

    IF CcbCCaja.FlgEst = "P" THEN ASSIGN X-STA = "PEN".
    IF CcbCCaja.FlgEst = "C" THEN ASSIGN X-STA = "CAN".
    IF CcbCCaja.FlgEst = "A" THEN ASSIGN X-STA = "ANU".

    DISPLAY STREAM REPORT 
        ccbccaja.coddoc 
        ccbccaja.nrodoc 
        ccbccaja.fchdoc 
        ccbccaja.codcli 
        ccbccaja.nomcli 
        x-totnac
        x-totusa
        ccbccaja.vuenac 
        ccbccaja.vueusa 
        x-sta @ x-sta 
        ccbccaja.tipo
        WITH FRAME F-REPORTE.
  END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir L-table-Win 
PROCEDURE imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-OK AS LOG INIT FALSE.

  SYSTEM-DIALOG PRINTER-SETUP
    NUM-COPIES s-nro-copias UPDATE x-OK.
  IF x-OK = NO THEN RETURN.

  OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'Nombres que Inicien con':U THEN DO:
       RUN Formato-1.
    END. /* Nombres que Inicien con */
    WHEN 'Nombres que Contengan':U THEN DO:
       RUN Formato-2.
    END. /* Nombres que Contengan */
    OTHERWISE RUN Formato.
  END CASE.
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_texto L-table-Win 
PROCEDURE proc_texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dTotNac AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dTotUsa AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cArchivo AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lRpta AS LOGICAL NO-UNDO.

    cArchivo = 'IngresosACaja.txt'.
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

    OUTPUT STREAM REPORT TO VALUE(cArchivo).
    PUT STREAM REPORT UNFORMATTED
        'Cod|'
        'Número|'
        'Emisión|'
        'Cliente|'
        'Nombre|'
        'Total S/.|'
        'Total US$|'
        'Vuelto S/.|'
        'Vuelto US$|'
        'Estado|'
        'Tipo|'
        'Efectivo S/.|'
        'Efectivo US$|'
        'Cheque día S/.|'
        'Cheque día US$"|'
        'Banco|'
        'Voucher|'
        'Vencimiento|'
        'Cheque Diferido S/.|'
        'Cheque Diferido US$|'
        'Banco|'
        'Voucher|'
        'Vencimiento|'
        'T. Crédito S/.|'
        'T. Crédito US$|'
        'Banco|'
        'Voucher|'
        'Boleta Dep S/.|'
        'Boleta Dep US$|'
        'Banco|'
        'Voucher|'
        'N/C S/.|'
        'N/C US$|'
        'Voucher|'
        'Anticipos S/.|'
        'Anticipos US$|'
        'Voucher|'
        'Comisiones S/.|'
        'Comisiones US$|'
        'Banco|'
        'Voucher|'
        'Retenciones S/.|'
        'Retenciones US$|'
        'Vales S/.|'
        'Vales US$|'
        'Doc|'
        'Número|'
        'Emisión|'
        'Moneda|'
        'Importe|'
        SKIP.

    FOR EACH CcbCCaja WHERE
        {&CONDICION} AND {&Filtro1}
        USE-INDEX LLAVE07 NO-LOCK:
        ASSIGN
            dtotnac =
                CcbCCaja.ImpNac[1] + CcbCCaja.ImpNac[2] + 
                CcbCCaja.ImpNac[3] + CcbCCaja.ImpNac[4] + 
                CcbCCaja.ImpNac[5] + CcbCCaja.ImpNac[6] + 
                CcbCCaja.ImpNac[7] + CcbCCaja.ImpNac[8] + 
                CcbCCaja.ImpNac[9] + CcbCCaja.ImpNac[10]
            dtotusa =
                CcbCCaja.ImpUsa[1] + CcbCCaja.ImpUsa[2] + 
                CcbCCaja.ImpUsa[3] + CcbCCaja.ImpUsa[4] + 
                CcbCCaja.ImpUsa[5] + CcbCCaja.ImpUsa[6] + 
                CcbCCaja.ImpUsa[7] + CcbCCaja.ImpUsa[8] + 
                CcbCCaja.ImpUsa[9] + CcbCCaja.ImpUsa[10].

        IF CcbCCaja.FlgEst = "P" THEN ASSIGN X-STA = "PEN".
        IF CcbCCaja.FlgEst = "C" THEN ASSIGN X-STA = "CAN".
        IF CcbCCaja.FlgEst = "A" THEN ASSIGN X-STA = "ANU".

        PUT STREAM REPORT UNFORMATTED
            ccbccaja.coddoc '|'
            ccbccaja.nrodoc '|' 
            ccbccaja.fchdoc '|'
            ccbccaja.codcli '|'
            ccbccaja.nomcli '|'
            dtotnac '|'
            dtotusa '|'
            ccbccaja.vuenac '|'
            ccbccaja.vueusa '|'
            x-sta '|'
            ccbccaja.tipo '|'
            CcbCCaja.ImpNac[1] '|'
            CcbCCaja.ImpUsa[1] '|'
            CcbCCaja.ImpNac[2] '|'
            CcbCCaja.ImpUsa[2] '|'
            CcbCCaja.CodBco[2] '|'
            CcbCCaja.Voucher[2] '|'
            CcbCCaja.FchVto[2] '|'
            CcbCCaja.ImpNac[3] '|'
            CcbCCaja.ImpUsa[3] '|'
            CcbCCaja.CodBco[3] '|'
            CcbCCaja.Voucher[3] '|'
            CcbCCaja.FchVto[3] '|'
            CcbCCaja.ImpNac[4] '|'
            CcbCCaja.ImpUsa[4] '|'
            CcbCCaja.CodBco[4] '|'
            CcbCCaja.Voucher[4] '|'
            CcbCCaja.ImpNac[5] '|'
            CcbCCaja.ImpUsa[5] '|'
            CcbCCaja.CodBco[5] '|'
            CcbCCaja.Voucher[5] '|'
            CcbCCaja.ImpNac[6] '|'
            CcbCCaja.ImpUsa[6] '|'
            CcbCCaja.Voucher[6] '|'
            CcbCCaja.ImpNac[7] '|'
            CcbCCaja.ImpUsa[7] '|'
            CcbCCaja.Voucher[7] '|'
            CcbCCaja.ImpNac[8] '|'
            CcbCCaja.ImpUsa[8] '|'
            CcbCCaja.CodBco[8] '|'
            CcbCCaja.Voucher[8] '|'
            CcbCCaja.ImpNac[9] '|'
            CcbCCaja.ImpUsa[9] '|'
            CcbCCaja.ImpNac[10] '|'
            CcbCCaja.ImpUsa[10] '|'.
        IF CAN-FIND (FIRST CcbDCaja WHERE
            CcbDCaja.CodCia = CcbCCaja.CodCia AND
            CcbDCaja.CodDoc = CcbCCaja.CodDoc AND
            CcbDCaja.NroDoc = CcbCCaja.NroDoc) THEN DO:
            lRpta = TRUE.
            /* Detalle de documentos */
            FOR EACH CcbDCaja WHERE
                CcbDCaja.CodCia = CcbCCaja.CodCia AND
                CcbDCaja.CodDoc = CcbCCaja.CodDoc AND
                CcbDCaja.NroDoc = CcbCCaja.NroDoc NO-LOCK:
                IF lRpta THEN lRpta = FALSE.
                ELSE PUT STREAM REPORT UNFORMATTED
                    '|||||||||||||||||||||||||||||||||||||||||||||'.
                PUT STREAM REPORT UNFORMATTED
                    CcbDCaja.CodRef '|'
                    CcbDCaja.NroRef '|'
                    CcbDCaja.FchDoc '|'
                    IF CcbDCaja.codmon = 1 THEN 'S/.' ELSE 'US$' '|'
                    CcbDCaja.ImpTot '|'
                    SKIP.
            END.
        END.
        ELSE PUT STREAM REPORT UNFORMATTED '' SKIP.
        lRpta = ?.
    END.

    OUTPUT STREAM REPORT CLOSE.

    IF lRpta = ? THEN
        MESSAGE
            "Archivo fué Generado"
            VIEW-AS ALERT-BOX INFORMA.

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
  {src/adm/template/snd-list.i "CcbCCaja"}

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

