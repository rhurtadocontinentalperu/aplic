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
DEFINE SHARED VARIABLE S-CODCIA    AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

/* Definición de variables locales */
DEFINE VARIABLE whpadre AS WIDGET-HANDLE.
DEFINE VARIABLE wh      AS WIDGET-HANDLE.
DEFINE VARIABLE curr-record AS RECID.
DEFINE VARIABLE F-STKACT AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRECIO1 AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRECIO2 AS DECIMAL NO-UNDO.


/* COPIA */
DEFINE VARIABLE I-ORDEN AS INTEGER INIT 1 NO-UNDO.
DEFINE VAR R-ROWID    AS ROWID   NO-UNDO.
DEFINE VAR F-STKGEN   AS DECIMAL NO-UNDO.
DEFINE VAR F-STKSUB   AS DECIMAL NO-UNDO.
DEFINE VAR F-CODMAR AS CHAR NO-UNDO.
DEFINE VARIABLE P-VTASOL AS DECIMAL NO-UNDO.
DEFINE VARIABLE P-VTADOL AS DECIMAL NO-UNDO.

/* FIN COPIA */

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* Preprocesadores para condiciones */
&SCOPED-DEFINE CONDICION ( Almmmatg.CodCia = S-CODCIA  AND LOOKUP(S-CODALM,Almmmatg.almacenes) <> 0 )
&SCOPED-DEFINE CODIGO Almmmatg.codmat

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 ( (Almmmatg.DesMat BEGINS FILL-IN-filtro) AND (Almmmatg.DesMar BEGINS F-Marca) AND (Almmmatg.TpoArt BEGINS R-Tipo) )
&SCOPED-DEFINE FILTRO2 ( (INDEX ( Almmmatg.DesMat , FILL-IN-filtro ) <> 0) AND (Almmmatg.DesMar BEGINS F-Marca) AND (Almmmatg.TpoArt BEGINS R-Tipo) )

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


DEFINE VARIABLE F-PREUSSA AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSB AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSC AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSD AS DECIMAL NO-UNDO.

DEFINE VARIABLE F-PRESOLA AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLB AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLC AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLD AS DECIMAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartLookup

&Scoped-define ADM-SUPPORTED-LINKS                                                       Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almmmatg.codfam Almmmatg.codmat ~
Almmmatg.DesMat Almmmatg.UndStk F-STKSUB @ F-STKSUB F-PRESOLA @ F-PRESOLA ~
F-PREUSSA @ F-PREUSSA Almmmatg.UndA F-PRESOLB @ F-PRESOLB ~
F-PREUSSB @ F-PREUSSB Almmmatg.UndB F-PRESOLC @ F-PRESOLC ~
F-PREUSSC @ F-PREUSSC Almmmatg.UndC F-PRESOLD @ F-PRESOLD ~
F-PREUSSD @ F-PREUSSD Almmmatg.Chr__01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-24 RECT-25 CMB-filtro br_table ~
FILL-IN-codigo FILL-IN-filtro F-Marca R-Tipo 
&Scoped-Define DISPLAYED-OBJECTS CMB-filtro RADIO-SET_TipArt FILL-IN_FchIng ~
FILL-IN_UndBas FILL-IN-codigo F-XUndM2 FILL-IN-filtro F-Marca ~
FILL-IN_CanEmp FILL-IN_Pesmat F-mar F-XUndM1 EDITOR_Detalle R-Tipo 

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
Nombres que inicien con|y||integral.Almmmatg.DesMat
Nombres que contengan|y||integral.Almmmatg.DesMat
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
Codigo|y||integral.Almmmatg.CodCia|yes,integral.Almmmatg.codmat|yes
Descripcion|||integral.Almmmatg.CodCia|yes,integral.Almmmatg.DesMat|yes
Marca|||integral.Almmmatg.CodCia|yes,integral.Almmmatg.CodMar|yes
Familia|||integral.Almmmatg.CodCia|yes,integral.Almmmatg.codfam|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "Codigo,Descripcion,Marca,Familia",
     SortBy-Case = Codigo':U).

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
     SIZE 24.57 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE EDITOR_Detalle AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
     SIZE 31.57 BY 1.73
     BGCOLOR 15 .

DEFINE VARIABLE F-mar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 48.14 BY .69
     BGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE F-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-XUndM1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-XUndM2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "X(9)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_CanEmp AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Empaque" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69.

DEFINE VARIABLE FILL-IN_FchIng AS DATE FORMAT "99/99/9999" 
     LABEL "Fch.Ing." 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69.

DEFINE VARIABLE FILL-IN_Pesmat AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69.

DEFINE VARIABLE FILL-IN_UndBas AS CHARACTER FORMAT "X(4)" 
     LABEL "Und.Bas." 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Activos", "A",
"Inactivos", "D",
"Ambos", ""
     SIZE 25.14 BY .54 NO-UNDO.

DEFINE VARIABLE RADIO-SET_TipArt AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "A", "A":U,
"B", "B":U,
"C", "C":U,
"D", "D":U
     SIZE 4.29 BY 2.58.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.86 BY 14.23.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26.43 BY .85.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.72 BY 3.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table L-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almmmatg.codfam
      Almmmatg.codmat COLUMN-LABEL "Codigo!Articulo"
      Almmmatg.DesMat FORMAT "X(49)"
      Almmmatg.UndStk COLUMN-LABEL "Unidad"
      F-STKSUB @ F-STKSUB COLUMN-LABEL "Stock!Almacen" FORMAT "->,>>>,>>9.9999"
            COLUMN-BGCOLOR 10
      F-PRESOLA @ F-PRESOLA COLUMN-LABEL "Precio Vta.  A!S/." FORMAT ">>,>>>,>>9.9999"
            COLUMN-BGCOLOR 11
      F-PREUSSA @ F-PREUSSA COLUMN-LABEL "Precio Vta. A!USS" FORMAT ">>,>>>,>>9.9999"
            COLUMN-BGCOLOR 11
      Almmmatg.UndA COLUMN-LABEL "UM.!A" FORMAT "X(8)" COLUMN-BGCOLOR 11
      F-PRESOLB @ F-PRESOLB COLUMN-LABEL "Precio Vta. B!S/." FORMAT ">>,>>>,>>9.9999"
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      F-PREUSSB @ F-PREUSSB COLUMN-LABEL "Precio Vta. B!USS" FORMAT ">>,>>>,>>9.9999"
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      Almmmatg.UndB COLUMN-LABEL "UM.!B" FORMAT "X(8)" COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      F-PRESOLC @ F-PRESOLC COLUMN-LABEL "Precio Vta. C!S/." FORMAT ">>,>>>,>>9.9999"
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 9
      F-PREUSSC @ F-PREUSSC COLUMN-LABEL "Precio Vta. C!USS" FORMAT ">>,>>>,>>9.9999"
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 9
      Almmmatg.UndC COLUMN-LABEL "UM.!C" FORMAT "X(8)" COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 9
      F-PRESOLD @ F-PRESOLD COLUMN-LABEL "Precio Oficina!S/." FORMAT ">>,>>>,>>9.9999"
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      F-PREUSSD @ F-PREUSSD COLUMN-LABEL "Precio Oficina!USS" FORMAT ">>,>>>,>>9.9999"
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      Almmmatg.Chr__01 COLUMN-LABEL "UM.!Pre.Ofi." COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 86.43 BY 11.04
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CMB-filtro AT ROW 2.15 COL 2.14 NO-LABEL
     br_table AT ROW 3.96 COL 1.72
     RADIO-SET_TipArt AT ROW 15.42 COL 2.57 NO-LABEL
     FILL-IN_FchIng AT ROW 15.46 COL 12.43 COLON-ALIGNED
     FILL-IN_UndBas AT ROW 16.46 COL 12.43 COLON-ALIGNED
     FILL-IN-codigo AT ROW 1.23 COL 14.86 COLON-ALIGNED
     F-XUndM2 AT ROW 16.46 COL 19.86 COLON-ALIGNED NO-LABEL
     FILL-IN-filtro AT ROW 2.19 COL 27.29 NO-LABEL
     F-Marca AT ROW 1.23 COL 30.72 COLON-ALIGNED
     FILL-IN_CanEmp AT ROW 15.46 COL 37.29 COLON-ALIGNED
     FILL-IN_Pesmat AT ROW 16.46 COL 37.29 COLON-ALIGNED NO-LABEL
     F-mar AT ROW 17.38 COL 37.29 COLON-ALIGNED
     F-XUndM1 AT ROW 15.46 COL 46.43 COLON-ALIGNED NO-LABEL
     EDITOR_Detalle AT ROW 15.46 COL 55.57 NO-LABEL
     R-Tipo AT ROW 1.38 COL 61.86 NO-LABEL
     "Estado" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 1.38 COL 54.29
          FONT 6
     RECT-1 AT ROW 1 COL 1
     "Buscar x" VIEW-AS TEXT
          SIZE 8.43 BY .58 AT ROW 1.31 COL 2.43
          FONT 6
     RECT-24 AT ROW 1.19 COL 61
     RECT-25 AT ROW 15.27 COL 1.14
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
         HEIGHT             = 17.92
         WIDTH              = 87.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW L-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table CMB-filtro F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main = 3.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR EDITOR EDITOR_Detalle IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-mar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-XUndM1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-XUndM2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN_CanEmp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchIng IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Pesmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_UndBas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET_TipArt IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.Almmmatg"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   = integral.Almmmatg.codfam
     _FldNameList[2]   > integral.Almmmatg.codmat
"Almmmatg.codmat" "Codigo!Articulo" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(49)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > integral.Almmmatg.UndStk
"Almmmatg.UndStk" "Unidad" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   > "_<CALC>"
"F-STKSUB @ F-STKSUB" "Stock!Almacen" "->,>>>,>>9.9999" ? 10 ? ? ? ? ? no ?
     _FldNameList[6]   > "_<CALC>"
"F-PRESOLA @ F-PRESOLA" "Precio Vta.  A!S/." ">>,>>>,>>9.9999" ? 11 ? ? ? ? ? no ?
     _FldNameList[7]   > "_<CALC>"
"F-PREUSSA @ F-PREUSSA" "Precio Vta. A!USS" ">>,>>>,>>9.9999" ? 11 ? ? ? ? ? no ?
     _FldNameList[8]   > integral.Almmmatg.UndA
"Almmmatg.UndA" "UM.!A" "X(8)" "character" 11 ? ? ? ? ? no ?
     _FldNameList[9]   > "_<CALC>"
"F-PRESOLB @ F-PRESOLB" "Precio Vta. B!S/." ">>,>>>,>>9.9999" ? 13 15 ? ? ? ? no ?
     _FldNameList[10]   > "_<CALC>"
"F-PREUSSB @ F-PREUSSB" "Precio Vta. B!USS" ">>,>>>,>>9.9999" ? 13 15 ? ? ? ? no ?
     _FldNameList[11]   > integral.Almmmatg.UndB
"Almmmatg.UndB" "UM.!B" "X(8)" "character" 13 15 ? ? ? ? no ?
     _FldNameList[12]   > "_<CALC>"
"F-PRESOLC @ F-PRESOLC" "Precio Vta. C!S/." ">>,>>>,>>9.9999" ? 9 15 ? ? ? ? no ?
     _FldNameList[13]   > "_<CALC>"
"F-PREUSSC @ F-PREUSSC" "Precio Vta. C!USS" ">>,>>>,>>9.9999" ? 9 15 ? ? ? ? no ?
     _FldNameList[14]   > integral.Almmmatg.UndC
"Almmmatg.UndC" "UM.!C" "X(8)" "character" 9 15 ? ? ? ? no ?
     _FldNameList[15]   > "_<CALC>"
"F-PRESOLD @ F-PRESOLD" "Precio Oficina!S/." ">>,>>>,>>9.9999" ? 12 15 ? ? ? ? no ?
     _FldNameList[16]   > "_<CALC>"
"F-PREUSSD @ F-PREUSSD" "Precio Oficina!USS" ">>,>>>,>>9.9999" ? 12 15 ? ? ? ? no ?
     _FldNameList[17]   > integral.Almmmatg.Chr__01
"Almmmatg.Chr__01" "UM.!Pre.Ofi." ? "character" 12 15 ? ? ? ? no ?
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
ON RIGHT-MOUSE-CLICK OF br_table IN FRAME F-Main
DO:
    RUN VTA\D-STKRET (Almmmatg.codmat).
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
  /*  RUN ALM/D-DETMOV.R (almmmatg.codmat, almmmatg.desmat).*/
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
   IF AVAILABLE Almmmatg THEN DO:
      RADIO-SET_TipArt = Almmmatg.TipArt.
      EDITOR_Detalle   = Almmmatg.Detalle.
      DISPLAY Almmmatg.CanEmp @ FILL-IN_CanEmp 
              Almmmatg.FchIng @ FILL-IN_FchIng 
              Almmmatg.Pesmat @ FILL-IN_Pesmat 
              Almmmatg.UndBas @ FILL-IN_UndBas 
              Almmmatg.DesMar @ F-mar
              RADIO-SET_TipArt
              EDITOR_Detalle
              Almmmatg.UndStk @ F-XUndM1
              "Peso Kg/" + Almmmatg.UndStk @ F-XUndM2 
              WITH FRAME {&FRAME-NAME}.

   END.
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
        R-Tipo = R-Tipo:SCREEN-VALUE
        THEN RETURN.
    ASSIGN
        FILL-IN-filtro
        CMB-filtro
        F-Marca
        R-Tipo.
        
    CASE CMB-filtro:
         WHEN 'Todos':U THEN DO:
              IF F-Marca <> "" THEN RUN set-attribute-list('Key-Name=Nombres que inicien con').
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


&Scoped-define SELF-NAME R-Tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-Tipo L-table-Win
ON VALUE-CHANGED OF R-Tipo IN FRAME F-Main
DO:
  APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK L-table-Win 


/* ***************************  Main Block  *************************** */
ON FIND OF Almmmatg DO:
     IF Almmmatg.MonVta = 1 THEN
        ASSIGN P-VTASOL = Almmmatg.Prevta[1]
               P-VTADOL = ROUND(Almmmatg.Prevta[1] / FacCfgGn.Tpocmb[1],2).
     ELSE 
        ASSIGN P-VTADOL = Almmmatg.Prevta[1]
               P-VTASOL = ROUND(Almmmatg.Prevta[1] * FacCfgGn.Tpocmb[1],2).
     ASSIGN F-STKSUB = 0
            F-STKGEN = 0.
     FIND Almmmate WHERE Almmmate.CodCia = Almmmatg.CodCia 
                    AND  Almmmate.CodAlm = S-CODALM 
                    AND  Almmmate.CodMat = Almmmatg.CodMat 
                   NO-LOCK NO-ERROR.
     IF AVAILABLE Almmmate THEN ASSIGN F-STKSUB = Almmmate.StkAct.
    /* FOR EACH Almmmate NO-LOCK WHERE  
              Almmmate.CodCia = Almmmatg.CodCia AND
              Almmmate.CodMat = Almmmatg.CodMat: 
         F-STKGEN = F-STKGEN + Almmmate.StkAct.
     END.*/
  IF Almmmatg.MonVta = 1 THEN DO:
    F-PRESOLA = Almmmatg.Prevta[2].
    F-PRESOLB = Almmmatg.Prevta[3].
    F-PRESOLC = Almmmatg.Prevta[4].
    F-PRESOLD = Almmmatg.PreOfi.

    F-PREUSSA = Almmmatg.Prevta[2] / Almmmatg.TpoCmb.
    F-PREUSSB = Almmmatg.Prevta[3] / Almmmatg.TpoCmb.
    F-PREUSSC = Almmmatg.Prevta[4] / Almmmatg.TpoCmb.
    F-PREUSSD = Almmmatg.PreOfi / Almmmatg.TpoCmb.
  END.
  ELSE DO:
    F-PREUSSA = Almmmatg.Prevta[2].
    F-PREUSSB = Almmmatg.Prevta[3].
    F-PREUSSC = Almmmatg.Prevta[4].
    F-PREUSSD = Almmmatg.PreOfi.

    F-PRESOLA = Almmmatg.Prevta[2] * Almmmatg.TpoCmb.
    F-PRESOLB = Almmmatg.Prevta[3] * Almmmatg.TpoCmb.
    F-PRESOLC = Almmmatg.Prevta[4] * Almmmatg.TpoCmb.
    F-PRESOLD = Almmmatg.PreOfi * Almmmatg.TpoCmb.
  END.
     
END.
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
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.codmat
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.DesMat
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Marca':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.CodMar
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Familia':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.codfam
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
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.codmat
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.DesMat
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Marca':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.CodMar
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Familia':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.codfam
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
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.codmat
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.DesMat
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Marca':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.CodMar
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Familia':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.codfam
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
        output-var-2 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat
        output-var-3 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.DesMat.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize L-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    RUN get-attribute ('Keys-Accepted').
    R-Tipo = 'A'.

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
  {src/adm/template/snd-list.i "Almmmatg"}

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


