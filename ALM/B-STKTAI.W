&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          thgerenc         PROGRESS
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
DEFINE STREAM report.
DEFINE SHARED VARIABLE S-NOMCIA    AS CHAR.
DEFINE SHARED VARIABLE S-CODCIA    AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM AS CHAR.

/* Definición de variables locales */
DEFINE VARIABLE whpadre AS WIDGET-HANDLE.
DEFINE VARIABLE wh      AS WIDGET-HANDLE.
DEFINE VARIABLE curr-record AS RECID.

/*****   Variables Calculadas   ***/
DEFINE VARIABLE F-TOTVAL  AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PORVAL  AS DECIMAL NO-UNDO.

DEFINE BUFFER T-GERENC FOR THGERENC.TLGCINV0.

/* COPIA */

DEFINE VARIABLE I-ORDEN AS INTEGER INIT 1 NO-UNDO.
DEFINE VAR R-ROWID    AS ROWID   NO-UNDO.
DEFINE VAR F-STKGEN   AS DECIMAL NO-UNDO.
DEFINE VAR F-STKSUB   AS DECIMAL NO-UNDO.
DEFINE VAR F-CODMAR AS CHAR NO-UNDO.

/* FIN COPIA */

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* Preprocesadores para condiciones */

&SCOPED-DEFINE CONDICION ( TRUE )
&SCOPED-DEFINE CODIGO THGERENC.TLGCINV0.Codigo

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 ( (THGERENC.TLGCINV0.NomArt BEGINS FILL-IN-filtro) AND (THGERENC.TLGCINV0.Marca BEGINS F-Marca) AND (THGERENC.TLGCINV0.CodPro BEGINS F-PROVEE) ~
                          AND (THGERENC.TLGCINV0.TipArt BEGINS RADIO-SET_TipArt ) )
&SCOPED-DEFINE FILTRO2 ( (INDEX ( THGERENC.TLGCINV0.NomArt , FILL-IN-filtro ) <> 0) AND (THGERENC.TLGCINV0.Marca BEGINS F-Marca) AND (THGERENC.TLGCINV0.CodPro BEGINS F-PROVEE) ~
                          AND (THGERENC.TLGCINV0.TipArt BEGINS RADIO-SET_TipArt ) ) 

/* Preprocesadores para Impresion */


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

&Scoped-define ADM-SUPPORTED-LINKS                                                                                             Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES TLGCINV0

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table TLGCINV0.Codigo TLGCINV0.NomArt ~
TLGCINV0.Marca TLGCINV0.Unidad TLGCINV0.StkTot TLGCINV0.StoTra ~
TLGCINV0.TipArt TLGCINV0.PreCos TLGCINV0.TotVal TLGCINV0.Stock[11] ~
TLGCINV0.Stock[12] TLGCINV0.Stock[8] TLGCINV0.Stock[3] TLGCINV0.Stock[2] ~
TLGCINV0.Stock[1] TLGCINV0.Stock[4] TLGCINV0.Stock[6] TLGCINV0.Stock[7] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH TLGCINV0 WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table TLGCINV0
&Scoped-define FIRST-TABLE-IN-QUERY-br_table TLGCINV0


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 F-PROVEE RADIO-SET_TipArt F-Marca ~
FILL-IN-codigo CMB-filtro FILL-IN-filtro br_table 
&Scoped-Define DISPLAYED-OBJECTS F-PROVEE RADIO-SET_TipArt F-Marca ~
FILL-IN-codigo CMB-filtro FILL-IN-filtro 

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
Nombres que inicien con|y||THGERENC.TLGCINV0.NomArt
Nombres que contengan|y||THGERENC.TLGCINV0.NomArt
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
Codigo|y||THGERENC.TLGCINV0.CodCia|yes,THGERENC.TLGCINV0.Codigo|yes
Descripcion|||THGERENC.TLGCINV0.CodCia|yes,THGERENC.TLGCINV0.NomArt|yes
Marca|||THGERENC.TLGCINV0.CodCia|yes,THGERENC.TLGCINV0.Marca|yes
Valorizado|||THGERENC.TLGCINV0.CodCia|yes,THGERENC.TLGCINV0.TotVal|no
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "Codigo,Descripcion,Marca,Valorizado",
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
DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Nombres que inicien con" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     SIZE 23 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE F-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 18.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-PROVEE AS CHARACTER FORMAT "X(8)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "X(6)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RADIO-SET_TipArt AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "T", "",
"A", "A":U,
"B", "B":U,
"C", "C":U
     SIZE 19.57 BY .62.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89.29 BY 13.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      TLGCINV0 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table L-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      TLGCINV0.Codigo COLUMN-LABEL "Codigo" FORMAT "X(7)"
      TLGCINV0.NomArt COLUMN-LABEL "Descripcion" FORMAT "X(45)"
      TLGCINV0.Marca FORMAT "X(12)"
      TLGCINV0.Unidad COLUMN-LABEL "Und" FORMAT "X(5)"
      TLGCINV0.StkTot FORMAT "->>>,>>9.99" COLUMN-BGCOLOR 16 LABEL-BGCOLOR 8
      TLGCINV0.StoTra COLUMN-LABEL "Mercaderia!Transito"
      TLGCINV0.TipArt COLUMN-LABEL "T!R"
      TLGCINV0.PreCos COLUMN-LABEL " Precio ! Compra" FORMAT "->,>>9.99"
      TLGCINV0.TotVal COLUMN-LABEL "Total ! Valor US$." COLUMN-BGCOLOR 11
      TLGCINV0.Stock[11] COLUMN-LABEL "[ A01 ]" FORMAT "->>>,>>9.99"
      TLGCINV0.Stock[12] COLUMN-LABEL "[ A02 ]" FORMAT "->>>,>>9.99"
      TLGCINV0.Stock[8] COLUMN-LABEL "[ T08 ]" FORMAT "->>>,>>9.99"
      TLGCINV0.Stock[3] COLUMN-LABEL "[ T03 ]" FORMAT "->>>,>>9.99"
      TLGCINV0.Stock[2] COLUMN-LABEL "[ T02 ]" FORMAT "->>>,>>9.99"
      TLGCINV0.Stock[1] COLUMN-LABEL "[ T01 ]" FORMAT "->>>,>>9.99"
      TLGCINV0.Stock[4] COLUMN-LABEL "[ T04 ]" FORMAT "->>>,>>9.99"
      TLGCINV0.Stock[6] COLUMN-LABEL "[ T06 ]" FORMAT "->>>,>>9.99"
      TLGCINV0.Stock[7] COLUMN-LABEL "[ T07 ]" FORMAT "->>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 88.14 BY 11.12
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-PROVEE AT ROW 2.15 COL 58.57 COLON-ALIGNED
     RADIO-SET_TipArt AT ROW 1.35 COL 53 NO-LABEL
     F-Marca AT ROW 1.19 COL 30.57 COLON-ALIGNED
     FILL-IN-codigo AT ROW 1.23 COL 14.14 COLON-ALIGNED
     CMB-filtro AT ROW 2.15 COL 1.57 NO-LABEL
     FILL-IN-filtro AT ROW 2.15 COL 24.72 NO-LABEL
     br_table AT ROW 3.08 COL 1.57
     RECT-1 AT ROW 1 COL 1
     "Buscar x" VIEW-AS TEXT
          SIZE 7.57 BY .46 AT ROW 1.38 COL 2.57
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
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW L-table-Win ASSIGN
         HEIGHT             = 13.35
         WIDTH              = 89.29.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW L-table-Win
  NOT-VISIBLE,                                                          */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main = 5.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "THGERENC.TLGCINV0"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > THGERENC.TLGCINV0.Codigo
"TLGCINV0.Codigo" "Codigo" "X(7)" "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > THGERENC.TLGCINV0.NomArt
"TLGCINV0.NomArt" "Descripcion" "X(45)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > THGERENC.TLGCINV0.Marca
"TLGCINV0.Marca" ? "X(12)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > THGERENC.TLGCINV0.Unidad
"TLGCINV0.Unidad" "Und" "X(5)" "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   > THGERENC.TLGCINV0.StkTot
"TLGCINV0.StkTot" ? "->>>,>>9.99" "decimal" 16 ? ? 8 ? ? no ?
     _FldNameList[6]   > THGERENC.TLGCINV0.StoTra
"TLGCINV0.StoTra" "Mercaderia!Transito" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[7]   > THGERENC.TLGCINV0.TipArt
"TLGCINV0.TipArt" "T!R" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[8]   > THGERENC.TLGCINV0.PreCos
"TLGCINV0.PreCos" " Precio ! Compra" "->,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[9]   > THGERENC.TLGCINV0.TotVal
"TLGCINV0.TotVal" "Total ! Valor US$." ? "decimal" 11 ? ? ? ? ? no ?
     _FldNameList[10]   > THGERENC.TLGCINV0.Stock[11]
"TLGCINV0.Stock[11]" "[ A01 ]" "->>>,>>9.99" "integer" ? ? ? ? ? ? no ?
     _FldNameList[11]   > THGERENC.TLGCINV0.Stock[12]
"TLGCINV0.Stock[12]" "[ A02 ]" "->>>,>>9.99" "integer" ? ? ? ? ? ? no ?
     _FldNameList[12]   > THGERENC.TLGCINV0.Stock[8]
"TLGCINV0.Stock[8]" "[ T08 ]" "->>>,>>9.99" "integer" ? ? ? ? ? ? no ?
     _FldNameList[13]   > THGERENC.TLGCINV0.Stock[3]
"TLGCINV0.Stock[3]" "[ T03 ]" "->>>,>>9.99" "integer" ? ? ? ? ? ? no ?
     _FldNameList[14]   > THGERENC.TLGCINV0.Stock[2]
"TLGCINV0.Stock[2]" "[ T02 ]" "->>>,>>9.99" "integer" ? ? ? ? ? ? no ?
     _FldNameList[15]   > THGERENC.TLGCINV0.Stock[1]
"TLGCINV0.Stock[1]" "[ T01 ]" "->>>,>>9.99" "integer" ? ? ? ? ? ? no ?
     _FldNameList[16]   > THGERENC.TLGCINV0.Stock[4]
"TLGCINV0.Stock[4]" "[ T04 ]" "->>>,>>9.99" "integer" ? ? ? ? ? ? no ?
     _FldNameList[17]   > THGERENC.TLGCINV0.Stock[6]
"TLGCINV0.Stock[6]" "[ T06 ]" "->>>,>>9.99" "integer" ? ? ? ? ? ? no ?
     _FldNameList[18]   > THGERENC.TLGCINV0.Stock[7]
"TLGCINV0.Stock[7]" "[ T07 ]" "->>>,>>9.99" "integer" ? ? ? ? ? ? no ?
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

{src/bin/_prns.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

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
/*
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
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  
  
/*  IF AVAILABLE Almmmatg THEN DO:
      RADIO-SET_TipArt = THGERENC.TLGCINV0.TipArt.
/*    EDITOR_Detalle   = Almmmatg.Detalle.
      DISPLAY Almmmatg.CanEmp @ FILL-IN_CanEmp 
              Almmmatg.FchIng @ FILL-IN_FchIng 
              Almmmatg.Pesmat @ FILL-IN_Pesmat 
              Almmmatg.UndBas @ FILL-IN_UndBas 
              RADIO-SET_TipArt
              EDITOR_Detalle
              Almmmatg.UndStk @ F-XUndM1
              "Peso Kg/" + Almmmatg.UndStk @ F-XUndM2 */
      DISPLAY 
              RADIO-SET_TipArt
              WITH FRAME {&FRAME-NAME}.

   END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-filtro L-table-Win
ON VALUE-CHANGED OF CMB-filtro IN FRAME F-Main
DO:
    IF CMB-filtro = CMB-filtro:SCREEN-VALUE AND
        FILL-IN-filtro = FILL-IN-filtro:SCREEN-VALUE AND
        F-Marca = F-Marca:SCREEN-VALUE AND
        RADIO-SET_TipArt = RADIO-SET_TipArt:SCREEN-VALUE AND
        F-Provee = F-Provee:SCREEN-VALUE THEN RETURN.
    ASSIGN
        FILL-IN-filtro
        CMB-filtro
        F-Marca
        F-Provee
        RADIO-SET_TipArt.
    CASE CMB-filtro:
         WHEN 'Todos':U THEN DO:
              IF F-Marca <> "" OR F-PROVEE <> "" THEN RUN set-attribute-list('Key-Name=Nombres que inicien con').
              ELSE RUN set-attribute-list('Key-Name=?').
         END.
         WHEN 'Nombres que contengan':U THEN DO:
              IF FILL-IN-filtro <> "" THEN 
                 RUN set-attribute-list('Key-Name=' + CMB-filtro).
              ELSE DO:
                 IF F-Marca <> "" THEN 
                    RUN set-attribute-list('Key-Name=Nombres que inicien con').
                 ELSE RUN set-attribute-list('Key-Name=?').
              END.
         END.
         OTHERWISE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    END CASE.
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Marca L-table-Win
ON LEAVE OF F-Marca IN FRAME F-Main /* Marca */
DO:
  APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Marca L-table-Win
ON MOUSE-SELECT-DBLCLICK OF F-Marca IN FRAME F-Main /* Marca */
OR F8 OF F-Marca
DO:
  ASSIGN input-var-1 = "MK".
  RUN LKUP\C-AlmTab.R ("Marcas").
  IF output-var-1 <> ? THEN 
     F-Marca:SCREEN-VALUE = output-var-3. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PROVEE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PROVEE L-table-Win
ON LEAVE OF F-PROVEE IN FRAME F-Main /* Proveedor */
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codigo L-table-Win
ON LEAVE OF FILL-IN-codigo IN FRAME F-Main /* Codigo */
DO:
    IF INPUT FILL-IN-codigo = "" THEN RETURN.
    &IF "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}" &THEN
        FIND FIRST {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
            {&CONDICION} AND
            ( {&CODIGO} = string (integer(INPUT FILL-IN-codigo:screen-value),"999999" ))
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            BELL.
            MESSAGE "Registro no encontrado" VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = "".
            RETURN.
        END.
        REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&TABLES-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
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
                REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&TABLES-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
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


&Scoped-define SELF-NAME RADIO-SET_TipArt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET_TipArt L-table-Win
ON VALUE-CHANGED OF RADIO-SET_TipArt IN FRAME F-Main
DO:
   APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK L-table-Win 


/* ***************************  Main Block  *************************** */

/***

ON FIND OF THGERENC.TLGCINV0 DO:
SSAAA   ASSIGN THGERENC.TLGCINV0.TOTVAL = ROUND(THGERENC.TLGCINV0.StkTot * THGERENC.TLGCINV0.PreCos,2).
   
/*   FIND Almmmate WHERE Almmmate.CodCia = Almmmatg.CodCia AND
 *         Almmmate.CodAlm = S-CODALM AND
 *         Almmmate.CodMat = Almmmatg.CodMat NO-LOCK NO-ERROR.
 *    IF AVAILABLE Almmmate THEN ASSIGN F-STKSUB = Almmmate.StkAct.
 *       FOR EACH Almmmate NO-LOCK WHERE  
 *                Almmmate.CodCia = Almmmatg.CodCia AND
 *                Almmmate.CodMat = Almmmatg.CodMat: 
 *           F-STKGEN = F-STKGEN + Almmmate.StkAct.
 *    END.
 * */

END.

****/

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
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY TLGCINV0.CodCia BY TLGCINV0.Codigo
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
           &Scope SORTBY-PHRASE BY TLGCINV0.CodCia BY TLGCINV0.NomArt
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Marca':U THEN DO:
           &Scope SORTBY-PHRASE BY TLGCINV0.CodCia BY TLGCINV0.Marca
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Valorizado':U THEN DO:
           &Scope SORTBY-PHRASE BY TLGCINV0.CodCia BY TLGCINV0.TotVal DESCENDING
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
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY TLGCINV0.CodCia BY TLGCINV0.Codigo
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
           &Scope SORTBY-PHRASE BY TLGCINV0.CodCia BY TLGCINV0.NomArt
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Marca':U THEN DO:
           &Scope SORTBY-PHRASE BY TLGCINV0.CodCia BY TLGCINV0.Marca
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Valorizado':U THEN DO:
           &Scope SORTBY-PHRASE BY TLGCINV0.CodCia BY TLGCINV0.TotVal DESCENDING
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
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY TLGCINV0.CodCia BY TLGCINV0.Codigo
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
           &Scope SORTBY-PHRASE BY TLGCINV0.CodCia BY TLGCINV0.NomArt
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Marca':U THEN DO:
           &Scope SORTBY-PHRASE BY TLGCINV0.CodCia BY TLGCINV0.Marca
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Valorizado':U THEN DO:
           &Scope SORTBY-PHRASE BY TLGCINV0.CodCia BY TLGCINV0.TotVal DESCENDING
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
        output-var-2 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codigo
        output-var-3 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NomArt.

&ENDIF

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime L-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
 

      RUN get-attribute ('SortBy-Case':U).
       
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
             run prn-codigo.             
         END.
         WHEN 'Descripcion':U THEN DO:
             run prn-descripcion.            
         END.
         WHEN 'Marca':U THEN DO:
             run prn-marca.
         END.
         WHEN 'Valorizado':U THEN DO:
             run prn-valor.
         END.
         OTHERWISE DO:
             run prn-codigo.
         END.   
       END CASE.


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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prn-codigo L-table-Win 
PROCEDURE prn-codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/******* Imprime Informacion Consolidado de STOCKS *******/

DEFINE VAR T-ALM-A1 AS DECIMAL INIT 0.  
DEFINE VAR T-ALM-A2 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-01 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-02 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-03 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-04 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-06 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-07 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-08 AS DECIMAL INIT 0.

DEFINE VAR N-Item AS INTEGER INIT 0.

DEFINE FRAME F-CAB
    T-GERENC.Codigo    FORMAT "999999"
    T-GERENC.NomArt    FORMAT "X(35)"
    T-GERENC.Unidad    FORMAT "X(4)"
    T-GERENC.PreCos    FORMAT "->,>>9.99"
    T-GERENC.StkTot    FORMAT "->>,>>9.99"
    T-GERENC.Stock[11] FORMAT "->>>9.99" 
    T-GERENC.Stock[12] FORMAT "->>>9.99"
    T-GERENC.Stock[8]  FORMAT "->>>9.99"
    T-GERENC.Stock[2]  FORMAT "->>>9.99"
    T-GERENC.Stock[1]  FORMAT "->>>9.99"
    T-GERENC.Stock[3]  FORMAT "->>>9.99"
    T-GERENC.Stock[4]  FORMAT "->>>9.99"
    T-GERENC.Stock[6]  FORMAT "->>>9.99"
    T-GERENC.Stock[7]  FORMAT "->>>9.99"        
    T-GERENC.TotVal    FORMAT "->,>>>,>>9"    
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + "TAI HENG S.A." + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
    "Pag.  :" AT 108 PAGE-NUMBER(REPORT) FORMAT ">>>9" SKIP(1)     
    {&PRN2} + {&PRN7A} + {&PRN6A} + "CONSOLIDADO DE STOCKS" + {&PRN6B} + {&PRN7B} + {&PRN3} AT 37 FORMAT "X(30)" 
    {&PRN4} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(12)" TODAY AT 95 FORMAT "99/99/9999" SKIP
    "Hora  :" AT 135 STRING(TIME, "HH:MM:SS") SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "Codigo Desccripcion                        Und.   PRECIO  T O T A L                  A     L     M     A     C     E     N     E     S                TOT.VALOR." SKIP
    "                                                   COSTO    STOCK      A 0 1    A 0 2    T 0 8    T 0 2    T 0 1    T 0 3    T 0 4    T 0 6    T 0 7     US$.   " SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*** 999999 12345678901234567890123456789012345 XXXX ->,>>9.99 ->>,>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->,>>>,>>9*/
     
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 200 STREAM-IO DOWN.         
    OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62.

    PUT STREAM Report CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN4}.  

    FOR EACH T-GERENC NO-LOCK WHERE T-GERENC.CodCia = s-codcia AND
             T-GERENC.Marca  BEGINS F-Marca  AND
             T-GERENC.CodPro BEGINS F-PROVEE AND
             T-GERENC.TipArt BEGINS RADIO-SET_TipArt 
               BY T-GERENC.CodCia 
               BY T-GERENC.Codigo :

         T-ALM-A1 = T-ALM-A1 + (T-GERENC.PreCos * T-GERENC.Stock[11]).
         T-ALM-A2 = T-ALM-A2 + (T-GERENC.PreCos * T-GERENC.Stock[12]).
         T-ALM-01 = T-ALM-01 + (T-GERENC.PreCos * T-GERENC.Stock[1]).
         T-ALM-02 = T-ALM-02 + (T-GERENC.PreCos * T-GERENC.Stock[2]).
         T-ALM-03 = T-ALM-03 + (T-GERENC.PreCos * T-GERENC.Stock[3]).
         T-ALM-04 = T-ALM-04 + (T-GERENC.PreCos * T-GERENC.Stock[4]).
         T-ALM-06 = T-ALM-06 + (T-GERENC.PreCos * T-GERENC.Stock[6]).
         T-ALM-07 = T-ALM-07 + (T-GERENC.PreCos * T-GERENC.Stock[7]).
         T-ALM-08 = T-ALM-08 + (T-GERENC.PreCos * T-GERENC.Stock[8]).
            
         DISPLAY STREAM REPORT
                T-GERENC.Codigo    
                T-GERENC.NomArt    
                T-GERENC.Unidad    
                T-GERENC.PreCos    
                T-GERENC.StkTot    
                T-GERENC.Stock[11] WHEN T-GERENC.Stock[11] > 0 
                T-GERENC.Stock[12] WHEN T-GERENC.Stock[12] > 0
                T-GERENC.Stock[8]  WHEN T-GERENC.Stock[8] > 0 
                T-GERENC.Stock[2]  WHEN T-GERENC.Stock[2] > 0 
                T-GERENC.Stock[1]  WHEN T-GERENC.Stock[1] > 0 
                T-GERENC.Stock[3]  WHEN T-GERENC.Stock[3] > 0 
                T-GERENC.Stock[4]  WHEN T-GERENC.Stock[4] > 0 
                T-GERENC.Stock[6]  WHEN T-GERENC.Stock[6] > 0 
                T-GERENC.Stock[7]  WHEN T-GERENC.Stock[7] > 0                   
                T-GERENC.TotVal WHEN T-GERENC.TotVal > 0                   
                WITH FRAME F-CAB.
    END.
    OUTPUT STREAM Report CLOSE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prn-descripcion L-table-Win 
PROCEDURE prn-descripcion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/******* Imprime Informacion Consolidado de STOCKS *******/

DEFINE VAR T-ALM-A1 AS DECIMAL INIT 0.  
DEFINE VAR T-ALM-A2 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-01 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-02 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-03 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-04 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-06 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-07 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-08 AS DECIMAL INIT 0.

DEFINE VAR N-Item AS INTEGER INIT 0.

DEFINE FRAME F-CAB
    T-GERENC.Codigo    FORMAT "999999"
    T-GERENC.NomArt    FORMAT "X(35)"
    T-GERENC.Unidad    FORMAT "X(4)"
    T-GERENC.PreCos    FORMAT "->,>>9.99"
    T-GERENC.StkTot    FORMAT "->>,>>9.99"
    T-GERENC.Stock[11] FORMAT "->>>9.99" 
    T-GERENC.Stock[12] FORMAT "->>>9.99"
    T-GERENC.Stock[8]  FORMAT "->>>9.99"
    T-GERENC.Stock[2]  FORMAT "->>>9.99"
    T-GERENC.Stock[1]  FORMAT "->>>9.99"
    T-GERENC.Stock[3]  FORMAT "->>>9.99"
    T-GERENC.Stock[4]  FORMAT "->>>9.99"
    T-GERENC.Stock[6]  FORMAT "->>>9.99"
    T-GERENC.Stock[7]  FORMAT "->>>9.99"        
    T-GERENC.TotVal    FORMAT "->,>>>,>>9"    
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + "TAI HENG S.A." + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
    "Pag.  :" AT 108 PAGE-NUMBER(REPORT) FORMAT ">>>9" SKIP(1)     
    {&PRN2} + {&PRN7A} + {&PRN6A} + "CONSOLIDADO DE STOCKS" + {&PRN6B} + {&PRN7B} + {&PRN3} AT 37 FORMAT "X(30)" 
    {&PRN4} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(12)" TODAY AT 95 FORMAT "99/99/9999" SKIP
    "Hora  :" AT 135 STRING(TIME, "HH:MM:SS") SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "Codigo Desccripcion                        Und.   PRECIO  T O T A L                  A     L     M     A     C     E     N     E     S                TOT.VALOR." SKIP
    "                                                   COSTO    STOCK      A 0 1    A 0 2    T 0 8    T 0 2    T 0 1    T 0 3    T 0 4    T 0 6    T 0 7     US$.   " SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*** 999999 12345678901234567890123456789012345 XXXX ->,>>9.99 ->>,>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->,>>>,>>9*/
     
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 200 STREAM-IO DOWN.         
    OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62.

    PUT STREAM Report CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN4}.  

    FOR EACH T-GERENC NO-LOCK WHERE T-GERENC.CodCia = s-codcia AND
             T-GERENC.Marca  BEGINS F-Marca  AND
             T-GERENC.CodPro BEGINS F-PROVEE AND
             T-GERENC.TipArt BEGINS RADIO-SET_TipArt
               BY T-GERENC.CodCia 
               BY T-GERENC.NomArt :

         T-ALM-A1 = T-ALM-A1 + (T-GERENC.PreCos * T-GERENC.Stock[11]).
         T-ALM-A2 = T-ALM-A2 + (T-GERENC.PreCos * T-GERENC.Stock[12]).
         T-ALM-01 = T-ALM-01 + (T-GERENC.PreCos * T-GERENC.Stock[1]).
         T-ALM-02 = T-ALM-02 + (T-GERENC.PreCos * T-GERENC.Stock[2]).
         T-ALM-03 = T-ALM-03 + (T-GERENC.PreCos * T-GERENC.Stock[3]).
         T-ALM-04 = T-ALM-04 + (T-GERENC.PreCos * T-GERENC.Stock[4]).
         T-ALM-06 = T-ALM-06 + (T-GERENC.PreCos * T-GERENC.Stock[6]).
         T-ALM-07 = T-ALM-07 + (T-GERENC.PreCos * T-GERENC.Stock[7]).
         T-ALM-08 = T-ALM-08 + (T-GERENC.PreCos * T-GERENC.Stock[8]).
            
         DISPLAY STREAM REPORT
                T-GERENC.Codigo    
                T-GERENC.NomArt    
                T-GERENC.Unidad    
                T-GERENC.PreCos    
                T-GERENC.StkTot    
                T-GERENC.Stock[11] WHEN T-GERENC.Stock[11] > 0 
                T-GERENC.Stock[12] WHEN T-GERENC.Stock[12] > 0
                T-GERENC.Stock[8]  WHEN T-GERENC.Stock[8] > 0 
                T-GERENC.Stock[2]  WHEN T-GERENC.Stock[2] > 0 
                T-GERENC.Stock[1]  WHEN T-GERENC.Stock[1] > 0 
                T-GERENC.Stock[3]  WHEN T-GERENC.Stock[3] > 0 
                T-GERENC.Stock[4]  WHEN T-GERENC.Stock[4] > 0 
                T-GERENC.Stock[6]  WHEN T-GERENC.Stock[6] > 0 
                T-GERENC.Stock[7]  WHEN T-GERENC.Stock[7] > 0                 
                T-GERENC.TotVal WHEN T-GERENC.TotVal > 0                   
                WITH FRAME F-CAB.
    END.
    OUTPUT STREAM Report CLOSE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prn-marca L-table-Win 
PROCEDURE prn-marca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/******* Imprime Informacion Consolidado de STOCKS *******/

DEFINE VAR T-ALM-A1 AS DECIMAL INIT 0.  
DEFINE VAR T-ALM-A2 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-01 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-02 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-03 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-04 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-06 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-07 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-08 AS DECIMAL INIT 0.

DEFINE VAR N-Item AS INTEGER INIT 0.

DEFINE FRAME F-CAB
    T-GERENC.Codigo    FORMAT "999999"
    T-GERENC.NomArt    FORMAT "X(35)"
    T-GERENC.Unidad    FORMAT "X(4)"
    T-GERENC.PreCos    FORMAT "->,>>9.99"
    T-GERENC.StkTot    FORMAT "->>,>>9.99"
    T-GERENC.Stock[11] FORMAT "->>>9.99" 
    T-GERENC.Stock[12] FORMAT "->>>9.99"
    T-GERENC.Stock[8]  FORMAT "->>>9.99"
    T-GERENC.Stock[2]  FORMAT "->>>9.99"
    T-GERENC.Stock[1]  FORMAT "->>>9.99"
    T-GERENC.Stock[3]  FORMAT "->>>9.99"
    T-GERENC.Stock[4]  FORMAT "->>>9.99"
    T-GERENC.Stock[6]  FORMAT "->>>9.99"
    T-GERENC.Stock[7]  FORMAT "->>>9.99"        
    T-GERENC.TotVal    FORMAT "->,>>>,>>9"    
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + "TAI HENG S.A." + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
    "Pag.  :" AT 108 PAGE-NUMBER(REPORT) FORMAT ">>>9" SKIP(1)     
    {&PRN2} + {&PRN7A} + {&PRN6A} + "CONSOLIDADO DE STOCKS" + {&PRN6B} + {&PRN7B} + {&PRN3} AT 37 FORMAT "X(30)" 
    {&PRN4} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(12)" TODAY AT 95 FORMAT "99/99/9999" SKIP
    "Hora  :" AT 135 STRING(TIME, "HH:MM:SS") SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "Codigo Desccripcion                        Und.   PRECIO  T O T A L                  A     L     M     A     C     E     N     E     S                TOT.VALOR." SKIP
    "                                                   COSTO    STOCK      A 0 1    A 0 2    T 0 8    T 0 2    T 0 1    T 0 3    T 0 4    T 0 6    T 0 7     US$.   " SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*** 999999 12345678901234567890123456789012345 XXXX ->,>>9.99 ->>,>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->,>>>,>>9*/
     
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 200 STREAM-IO DOWN.         
    OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62.

    PUT STREAM Report CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN4}.  

    FOR EACH T-GERENC NO-LOCK WHERE T-GERENC.CodCia = s-codcia AND
             T-GERENC.Marca  BEGINS F-Marca  AND
             T-GERENC.CodPro BEGINS F-PROVEE AND
             T-GERENC.TipArt BEGINS RADIO-SET_TipArt
             BY T-GERENC.CodCia 
             BY T-GERENC.Marca :

         T-ALM-A1 = T-ALM-A1 + (T-GERENC.PreCos * T-GERENC.Stock[11]).
         T-ALM-A2 = T-ALM-A2 + (T-GERENC.PreCos * T-GERENC.Stock[12]).
         T-ALM-01 = T-ALM-01 + (T-GERENC.PreCos * T-GERENC.Stock[1]).
         T-ALM-02 = T-ALM-02 + (T-GERENC.PreCos * T-GERENC.Stock[2]).
         T-ALM-03 = T-ALM-03 + (T-GERENC.PreCos * T-GERENC.Stock[3]).
         T-ALM-04 = T-ALM-04 + (T-GERENC.PreCos * T-GERENC.Stock[4]).
         T-ALM-06 = T-ALM-06 + (T-GERENC.PreCos * T-GERENC.Stock[6]).
         T-ALM-07 = T-ALM-07 + (T-GERENC.PreCos * T-GERENC.Stock[7]).
         T-ALM-08 = T-ALM-08 + (T-GERENC.PreCos * T-GERENC.Stock[8]).
            
         DISPLAY STREAM REPORT
                T-GERENC.Codigo    
                T-GERENC.NomArt    
                T-GERENC.Unidad    
                T-GERENC.PreCos    
                T-GERENC.StkTot    
                T-GERENC.Stock[11] WHEN T-GERENC.Stock[11] > 0 
                T-GERENC.Stock[12] WHEN T-GERENC.Stock[12] > 0
                T-GERENC.Stock[8]  WHEN T-GERENC.Stock[8] > 0 
                T-GERENC.Stock[2]  WHEN T-GERENC.Stock[2] > 0 
                T-GERENC.Stock[1]  WHEN T-GERENC.Stock[1] > 0 
                T-GERENC.Stock[3]  WHEN T-GERENC.Stock[3] > 0 
                T-GERENC.Stock[4]  WHEN T-GERENC.Stock[4] > 0 
                T-GERENC.Stock[6]  WHEN T-GERENC.Stock[6] > 0 
                T-GERENC.Stock[7]  WHEN T-GERENC.Stock[7] > 0                 
                T-GERENC.TotVal WHEN T-GERENC.TotVal > 0                   
                WITH FRAME F-CAB.
    END.
    OUTPUT STREAM Report CLOSE. 
    
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prn-valor L-table-Win 
PROCEDURE prn-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/******* Imprime Informacion Consolidado de STOCKS *******/

DEFINE VAR T-ALM-A1 AS DECIMAL INIT 0.  
DEFINE VAR T-ALM-A2 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-01 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-02 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-03 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-04 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-06 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-07 AS DECIMAL INIT 0.
DEFINE VAR T-ALM-08 AS DECIMAL INIT 0.

DEFINE VAR N-Item AS INTEGER INIT 0.

DEFINE FRAME F-CAB
    T-GERENC.Codigo    FORMAT "999999"
    T-GERENC.NomArt    FORMAT "X(35)"
    T-GERENC.Unidad    FORMAT "X(4)"
    T-GERENC.PreCos    FORMAT "->,>>9.99"
    T-GERENC.StkTot    FORMAT "->>,>>9.99"
    T-GERENC.Stock[11] FORMAT "->>>9.99" 
    T-GERENC.Stock[12] FORMAT "->>>9.99"
    T-GERENC.Stock[8]  FORMAT "->>>9.99"
    T-GERENC.Stock[2]  FORMAT "->>>9.99"
    T-GERENC.Stock[1]  FORMAT "->>>9.99"
    T-GERENC.Stock[3]  FORMAT "->>>9.99"
    T-GERENC.Stock[4]  FORMAT "->>>9.99"
    T-GERENC.Stock[6]  FORMAT "->>>9.99"
    T-GERENC.Stock[7]  FORMAT "->>>9.99"        
    T-GERENC.TotVal    FORMAT "->,>>>,>>9"    
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + "TAI HENG S.A." + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
    "Pag.  :" AT 108 PAGE-NUMBER(REPORT) FORMAT ">>>9" SKIP(1)     
    {&PRN2} + {&PRN7A} + {&PRN6A} + "CONSOLIDADO DE STOCKS" + {&PRN6B} + {&PRN7B} + {&PRN3} AT 37 FORMAT "X(30)" 
    {&PRN4} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(12)" TODAY AT 95 FORMAT "99/99/9999" SKIP
    "Hora  :" AT 135 STRING(TIME, "HH:MM:SS") SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "Codigo Desccripcion                        Und.   PRECIO  T O T A L                  A     L     M     A     C     E     N     E     S                TOT.VALOR." SKIP
    "                                                   COSTO    STOCK      A 0 1    A 0 2    T 0 8    T 0 2    T 0 1    T 0 3    T 0 4    T 0 6    T 0 7     US$.   " SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*** 999999 12345678901234567890123456789012345 XXXX ->,>>9.99 ->>,>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->>>9.99 ->,>>>,>>9*/
     
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 200 STREAM-IO DOWN.         
    OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62.

    PUT STREAM Report CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN4}.  

    FOR EACH T-GERENC NO-LOCK WHERE T-GERENC.CodCia = s-codcia AND
             T-GERENC.Marca  BEGINS F-Marca  AND
             T-GERENC.CodPro BEGINS F-PROVEE AND
             T-GERENC.TipArt BEGINS RADIO-SET_TipArt
               BY T-GERENC.CodCia 
               BY T-GERENC.TotVal DESCENDING :

         T-ALM-A1 = T-ALM-A1 + (T-GERENC.PreCos * T-GERENC.Stock[11]).
         T-ALM-A2 = T-ALM-A2 + (T-GERENC.PreCos * T-GERENC.Stock[12]).
         T-ALM-01 = T-ALM-01 + (T-GERENC.PreCos * T-GERENC.Stock[1]).
         T-ALM-02 = T-ALM-02 + (T-GERENC.PreCos * T-GERENC.Stock[2]).
         T-ALM-03 = T-ALM-03 + (T-GERENC.PreCos * T-GERENC.Stock[3]).
         T-ALM-04 = T-ALM-04 + (T-GERENC.PreCos * T-GERENC.Stock[4]).
         T-ALM-06 = T-ALM-06 + (T-GERENC.PreCos * T-GERENC.Stock[6]).
         T-ALM-07 = T-ALM-07 + (T-GERENC.PreCos * T-GERENC.Stock[7]).
         T-ALM-08 = T-ALM-08 + (T-GERENC.PreCos * T-GERENC.Stock[8]).
            
         DISPLAY STREAM REPORT
                T-GERENC.Codigo    
                T-GERENC.NomArt    
                T-GERENC.Unidad    
                T-GERENC.PreCos    
                T-GERENC.StkTot    
                T-GERENC.Stock[11] WHEN T-GERENC.Stock[11] > 0 
                T-GERENC.Stock[12] WHEN T-GERENC.Stock[12] > 0
                T-GERENC.Stock[8]  WHEN T-GERENC.Stock[8] > 0 
                T-GERENC.Stock[2]  WHEN T-GERENC.Stock[2] > 0 
                T-GERENC.Stock[1]  WHEN T-GERENC.Stock[1] > 0 
                T-GERENC.Stock[3]  WHEN T-GERENC.Stock[3] > 0 
                T-GERENC.Stock[4]  WHEN T-GERENC.Stock[4] > 0 
                T-GERENC.Stock[6]  WHEN T-GERENC.Stock[6] > 0 
                T-GERENC.Stock[7]  WHEN T-GERENC.Stock[7] > 0                 
                T-GERENC.TotVal WHEN T-GERENC.TotVal > 0                   
                WITH FRAME F-CAB.
    END.
    OUTPUT STREAM Report CLOSE. 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA-PARAMETROS L-table-Win 
PROCEDURE PROCESA-PARAMETROS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RECOGE-PARAMETROS L-table-Win 
PROCEDURE RECOGE-PARAMETROS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
  {src/adm/template/snd-list.i "TLGCINV0"}

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


