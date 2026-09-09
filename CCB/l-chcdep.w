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
DEFINE NEW SHARED VARIABLE input-var-1 AS CHARACTER.
DEFINE NEW SHARED VARIABLE input-var-2 AS CHARACTER.
DEFINE NEW SHARED VARIABLE input-var-3 AS CHARACTER.
DEFINE NEW SHARED VARIABLE output-var-1 AS ROWID.
DEFINE NEW SHARED VARIABLE output-var-2 AS CHARACTER.
DEFINE NEW SHARED VARIABLE output-var-3 AS CHARACTER.

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHARACTER.
DEFINE SHARED VARIABLE cb-codcia AS INTEGER.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER.

/* Definición de variables locales */
DEFINE VARIABLE whpadre AS WIDGET-HANDLE.
DEFINE VARIABLE wh      AS WIDGET-HANDLE.
DEFINE VARIABLE curr-record AS RECID.
DEFINE VARIABLE X-MON    AS CHAR INIT "".
DEFINE VARIABLE X-EST    AS CHAR INIT "".
DEFINE VARIABLE F-ESTADO AS CHAR INIT "P".
DEFINE VARIABLE S-CODDOC AS CHAR INIT "CHC".

DEFINE BUFFER B-CCBC FOR CcbCDocu.


/* Preprocesadores para condiciones */

&SCOPED-DEFINE CONDICION ( CcbCDocu.Codcia = S-CODCIA  AND CcbcDocu.FlgEst = F-ESTADO AND CcbCDocu.CodDoc = S-CODDOC)

&SCOPED-DEFINE CODIGO CcbcDocu.NroDoc

/* Preprocesadores para cada campo filtro */

&SCOPED-DEFINE FILTRO1 ( CcbcDocu.Nomcli BEGINS FILL-IN-filtro )
&SCOPED-DEFINE FILTRO2 ( INDEX ( CcbcDocu.Nomcli , FILL-IN-filtro ) <> 0 )


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
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCDocu.CodDiv CcbCDocu.CodDoc ~
CcbCDocu.NroDoc CcbCDocu.NomCli CcbCDocu.FchVto X-MON @ X-MON ~
CcbCDocu.ImpTot X-EST @ X-EST CcbCDocu.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} USE-INDEX LLAVE03 NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} USE-INDEX LLAVE03 NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table FILL-IN-codigo CMB-filtro ~
FILL-IN-filtro F-Banco F-Cta FILL-IN-NroOpe F-Fecha BUTTON-5 RECT-1 RECT-29 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codigo CMB-filtro FILL-IN-filtro ~
F-Banco F-Cta FILL-IN-NroOpe F-Fecha FILL-IN-17 FILL-IN-16 

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
Nombres que Inicien con|y||integral.CcbCDocu.NomCli
Nombres que Contengan|y||integral.CcbCDocu.NomCli
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
<SORTBY-OPTIONS></SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ,
     Sort-Case = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES></FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-5 
     LABEL "Aceptar Deposito" 
     SIZE 19.86 BY .85
     FONT 6.

DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 20 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE F-Banco AS CHARACTER FORMAT "X(3)":U 
     LABEL "Banco" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-Cta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-Fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Deposito" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-16 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-17 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27.72 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "XXXXXXXXX":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NroOpe AS CHARACTER FORMAT "X(8)":U 
     LABEL "N' Operacion" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 107 BY 14.81.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51.43 BY 3.15.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table L-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCDocu.CodDiv FORMAT "x(5)":U WIDTH 6.43
      CcbCDocu.CodDoc COLUMN-LABEL "Tipo" FORMAT "x(5)":U
      CcbCDocu.NroDoc FORMAT "XXX-XXXXXXXX":U
      CcbCDocu.NomCli FORMAT "x(55)":U
      CcbCDocu.FchVto COLUMN-LABEL "Fecha de     !Presentacion" FORMAT "99/99/9999":U
      X-MON @ X-MON COLUMN-LABEL "Mon." FORMAT "XXXX":U
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U
      X-EST @ X-EST COLUMN-LABEL "Estado" FORMAT "XXX":U
      CcbCDocu.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 104 BY 10.08
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.35 COL 2
     FILL-IN-codigo AT ROW 1.35 COL 16.43 COLON-ALIGNED
     CMB-filtro AT ROW 1.27 COL 28.86 NO-LABEL
     FILL-IN-filtro AT ROW 1.35 COL 49.43 NO-LABEL
     F-Banco AT ROW 12.65 COL 56.86 COLON-ALIGNED
     F-Cta AT ROW 13.54 COL 47.14 COLON-ALIGNED
     FILL-IN-NroOpe AT ROW 14.46 COL 47 COLON-ALIGNED
     F-Fecha AT ROW 14.5 COL 76.14 COLON-ALIGNED
     BUTTON-5 AT ROW 13.69 COL 12
     FILL-IN-17 AT ROW 13.58 COL 58.57 COLON-ALIGNED NO-LABEL
     FILL-IN-16 AT ROW 12.65 COL 62.43 COLON-ALIGNED NO-LABEL
     "Buscar x" VIEW-AS TEXT
          SIZE 7.86 BY .62 AT ROW 1.46 COL 2.14
          FONT 6
     RECT-1 AT ROW 1 COL 1
     RECT-29 AT ROW 12.54 COL 38
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
         HEIGHT             = 14.88
         WIDTH              = 107.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB L-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW L-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-16 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-17 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.CcbCDocu"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&CONDICION} USE-INDEX LLAVE03"
     _FldNameList[1]   > integral.CcbCDocu.CodDiv
"CcbCDocu.CodDiv" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.CcbCDocu.CodDoc
"CcbCDocu.CodDoc" "Tipo" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" ? "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? "x(55)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.CcbCDocu.FchVto
"CcbCDocu.FchVto" "Fecha de     !Presentacion" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"X-MON @ X-MON" "Mon." "XXXX" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = integral.CcbCDocu.ImpTot
     _FldNameList[8]   > "_<CALC>"
"X-EST @ X-EST" "Estado" "XXX" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > integral.CcbCDocu.SdoAct
"CcbCDocu.SdoAct" "Saldo Actual" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
  IF ccbcdocu.imptot <> ccbcdocu.sdoact
  THEN ccbcdocu.sdoact:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11.
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


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 L-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Aceptar Deposito */
DO:
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0
  THEN DO:
    MESSAGE "Debe Seleccionar al menos un registro...." VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  
  MESSAGE 'Esta Seguro de realizar Operacion ' SKIP
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE X-OK AS LOGICAL.
  
  CASE X-OK:       
       WHEN FALSE THEN 
        DO:
           MESSAGE "Operacion Cancelada "
                  VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
           RETURN "ADM-ERROR".
        END.
  END CASE.    
  IF F-BANCO:SCREEN-VALUE = "" THEN DO:
     MESSAGE "Error en Codigo de Banco ...."
     VIEW-AS ALERT-BOX.
     APPLY "ENTRY" TO F-BANCO.
     RETURN NO-APPLY.     
  END. 
  IF F-CTA:SCREEN-VALUE = "" THEN DO:
     MESSAGE "Error en Codigo de Cuenta Bancaria ...."
     VIEW-AS ALERT-BOX.
     APPLY "ENTRY" TO F-CTA.
     RETURN NO-APPLY.     
  END. 
  ASSIGN
    F-Banco 
    F-Cta
    F-Fecha.
  IF F-FECHA = ?  THEN DO:
     MESSAGE "Error en fecha de Deposito...."
     VIEW-AS ALERT-BOX.
     APPLY "ENTRY" TO F-CTA.
     RETURN NO-APPLY.     
  END. 
  RUN Genera-Deposito.
  RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY "" @ F-BANCO
            "" @ F-CTA
            ?  @ F-FECHA
            "" @ FILL-IN-16
            "" @ FILL-IN-17
            "" @ FILL-IN-NroOpe.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-filtro L-table-Win
ON VALUE-CHANGED OF CMB-filtro IN FRAME F-Main
DO:
    IF CMB-filtro = CMB-filtro:SCREEN-VALUE AND
       FILL-IN-filtro = FILL-IN-filtro:SCREEN-VALUE  
       THEN RETURN.
    ASSIGN
       FILL-IN-filtro
       CMB-filtro.
       
    IF CMB-filtro = "Todos" THEN DO:
       RUN set-attribute-list('Key-Name=?').
    END.
    
    ELSE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Banco L-table-Win
ON ENTRY OF F-Banco IN FRAME F-Main /* Banco */
DO:
  ASSIGN
    F-Banco 
    F-Cta
    F-Fecha.
 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Banco L-table-Win
ON LEAVE OF F-Banco IN FRAME F-Main /* Banco */
DO:

  ASSIGN
    F-Banco 
    F-Cta
    F-Fecha.
  
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY 
        "" @ F-Banco 
        "" @ FILL-IN-16 
        WITH FRAME {&FRAME-NAME}.
     RETURN.
  END.
  FIND cb-tabl WHERE cb-tabl.Tabla  = "04"
                AND  cb-tabl.Codigo = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-tabl THEN DO:
    MESSAGE "Banco no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  DISPLAY 
    cb-tabl.Codigo @ F-Banco 
    cb-tabl.Nombre @ FILL-IN-16 
    WITH FRAME {&FRAME-NAME}.   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Banco L-table-Win
ON MOUSE-SELECT-DBLCLICK OF F-Banco IN FRAME F-Main /* Banco */
DO:
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = "04"
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    RUN LKUP/C-Tablas.r("").
    IF OUTPUT-VAR-1 <> ? THEN DO:
        FIND cb-tabl WHERE ROWID(cb-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
        DISPLAY 
          cb-tabl.Codigo @ F-Banco 
          cb-tabl.Nombre @ FILL-IN-16 
          WITH FRAME {&FRAME-NAME}.  
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Cta L-table-Win
ON LEAVE OF F-Cta IN FRAME F-Main /* Cuenta */
DO:
  ASSIGN
    F-Banco 
    F-Cta
    F-Fecha.
 
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY 
        "" @ F-Cta 
        "" @ FILL-IN-17  
        WITH FRAME {&FRAME-NAME}.
     RETURN .
  END.
                 
  FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
                AND  cb-ctas.Codcta = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-ctas THEN DO:
    MESSAGE "Cuenta no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY. 
  END.
            
  DISPLAY 
    cb-ctas.Codcta @ F-Cta 
    cb-ctas.Nomcta @ FILL-IN-17  
    WITH FRAME {&FRAME-NAME}.  
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Cta L-table-Win
ON MOUSE-SELECT-DBLCLICK OF F-Cta IN FRAME F-Main /* Cuenta */
DO:
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = "10"
          input-var-2 = F-Banco:SCREEN-VALUE
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    RUN LKUP/C-Cuenta.r("Cuentas").
    IF OUTPUT-VAR-1 <> ? THEN DO:
        FIND cb-ctas WHERE ROWID(cb-ctas) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
        DISPLAY 
          cb-ctas.Codcta @ F-Cta 
          cb-ctas.Nomcta @ FILL-IN-17 
          WITH FRAME {&FRAME-NAME}.  
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Fecha L-table-Win
ON ENTRY OF F-Fecha IN FRAME F-Main /* Fecha Deposito */
DO:
  ASSIGN
    F-Banco 
    F-Cta
    F-Fecha.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Fecha L-table-Win
ON LEAVE OF F-Fecha IN FRAME F-Main /* Fecha Deposito */
DO:
  ASSIGN
    F-Banco 
    F-Cta
    F-Fecha.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codigo L-table-Win
ON LEAVE OF FILL-IN-codigo IN FRAME F-Main /* Documento */
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
            RETURN.
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


&Scoped-define SELF-NAME FILL-IN-NroOpe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroOpe L-table-Win
ON LEAVE OF FILL-IN-NroOpe IN FRAME F-Main /* N' Operacion */
DO:
    ASSIGN SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '99999999') NO-ERROR.
  ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK L-table-Win 


/* ***************************  Main Block  *************************** */

ON FIND OF Ccbcdocu
DO:
    IF CcbcDocu.CodMon = 1 THEN
        ASSIGN
            X-MON = "S/." .
    ELSE
        ASSIGN
            X-MON = "US$" .
            
    IF CcbCDocu.FlgEst = "P" THEN
        ASSIGN
            X-EST = "PEN" .
    ELSE
       IF CcbCDocu.FlgEst = "C" THEN
          ASSIGN
              X-EST = "CAN" .    
       ELSE       
          IF CcbcDocu.FlgEst = "A" THEN
             ASSIGN
                 X-EST = "ANU" .            
            
END.

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
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Nombres que Inicien con */
    WHEN 'Nombres que Contengan':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro2} )
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Nombres que Contengan */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       {&OPEN-QUERY-{&BROWSE-NAME}}
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
        output-var-2 = STRING( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroDoc, "999-999999" )
        output-var-3 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nomcli.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Deposito L-table-Win 
PROCEDURE Genera-Deposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR n AS INTEGER NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    DO n = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(n) THEN DO:
            /* cruce con boleta de deposito */
            FIND FIRST B-CCBC WHERE B-CCBC.codcia = ccbcdocu.codcia
                AND B-CCBC.coddoc = "BD"
                AND B-CCBC.codcli = ccbcdocu.codcli
                AND B-CCBC.flgest <> "A"
                AND B-CCBC.flgate = F-Banco
                AND B-CCBC.codcta = F-Cta
                AND B-CCBC.nroref = FILL-IN-NroOpe
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-CCBC THEN DO:
                MESSAGE 'Se ha detectado una Boleta de Depósito del cliente' ccbcdocu.nomcli SKIP
                    'Número de boleta:' B-CCBC.nrodoc 'del día' B-CCBC.fchdoc 'importe' B-CCBC.imptot SKIP(1)
                    'El Cheque' ccbcdocu.nrodoc 'NO se va a depositar'
                    VIEW-AS ALERT-BOX WARNING.
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
    
            CREATE B-CCBC.
            ASSIGN
                 B-CCBC.CodCia = CcbCDocu.CodCia 
                 B-CCBC.CodDiv = CcbCDocu.CodDiv 
                 B-CCBC.CodDoc = "CHD"
                 B-CCBC.NroDoc = CcbCDocu.NroDoc
                 B-CCBC.CodMon = CcbCDocu.CodMon
                 B-CCBC.ImpTot = CcbCDocu.ImpTot
                 B-CCBC.SdoAct = CcbCDocu.SdoAct
                 B-CCBC.ImpBrt = CcbCDocu.ImpBrt
                 B-CCBC.FchUbi = F-FECHA
                 B-CCBC.CodAge = F-BANCO
                 B-CCBC.CodCta = F-CTA
                 B-CCBC.NroOrd = FILL-IN-NroOpe
                 B-CCBC.CodCli = CcbCDocu.CodCli 
                 B-CCBC.NomCli = CcbCDocu.NomCli 
                 B-CCBC.RucCli = CcbCDocu.RucCli 
                 B-CCbC.FlgEst = "P"
                 B-CCBC.Usuario = s-User-Id
                 B-CCBC.TpoCmb = CcbCDocu.TpoCmb 
                 B-CCBC.FchDoc = TODAY 
                 B-CCBC.FchVto = CcbCDocu.FchVto.
            /* RHC 24.06.10 MOVIMIENTO DE SUSTENTO DE CANCELACION */
            CREATE Ccbdcaja.
            ASSIGN
                CcbDCaja.CodCia = Ccbcdocu.codcia
                CcbDCaja.CodCli = Ccbcdocu.codcli
                CcbDCaja.CodDiv = Ccbcdocu.coddiv
                CcbDCaja.CodDoc = 'CHD'
                CcbDCaja.NroDoc = Ccbcdocu.nrodoc
                CcbDCaja.CodMon = Ccbcdocu.codmon
                CcbDCaja.CodRef = Ccbcdocu.coddoc
                CcbDCaja.NroRef = Ccbcdocu.nrodoc
                CcbDCaja.FchDoc = TODAY
                CcbDCaja.ImpTot = Ccbcdocu.imptot
                CcbDCaja.TpoCmb = Ccbcdocu.tpocmb.
            /* ************************************************** */
            FIND CURRENT CCbCDocu EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE Ccbcdocu THEN 
                ASSIGN
                    Ccbcdocu.FlgEst = "C"
                    Ccbcdocu.FchCan = TODAY
                    ccbcdocu.SdoAct = 0.     
            /* RHC 15.09.2011 CLiente con segmentación A y B lo aceptamos automáticamente */
            /* RHC 06/05/2021 NO VA */
/*             FIND gn-clie WHERE gn-clie.codcia = cl-codcia                        */
/*                 AND gn-clie.codcli = Ccbcdocu.codcli                             */
/*                 NO-LOCK.                                                         */
/*             IF gn-clie.clfcom = 'A' OR gn-clie.clfcom = 'B' THEN DO:             */
/*                 /* Nos posicionamos en el CHD */                                 */
/*                 FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = ROWID(B-CCBC) NO-LOCK.     */
/*                                                                                  */
/*                 CREATE B-CCBC.                                                   */
/*                 BUFFER-COPY CcbCDocu TO B-CCBC                                   */
/*                     ASSIGN                                                       */
/*                         B-CCBC.CodDoc = 'CHV'                                    */
/*                         B-CCBC.FchDoc = TODAY                                    */
/*                         B-CCBC.FlgEst = 'C'     /* SE GENERA YA CANCELADO */     */
/*                         B-CCBC.SdoAct = 0                                        */
/*                         B-CCBC.Usuario = s-user-id.                              */
/*                 /* RHC 24.06.10 MOVIMIENTO DE SUSTENTO DE CANCELACION DEL CHD */ */
/*                 CREATE Ccbdcaja.                                                 */
/*                 ASSIGN                                                           */
/*                     CcbDCaja.CodCia = Ccbcdocu.codcia                            */
/*                     CcbDCaja.CodCli = Ccbcdocu.codcli                            */
/*                     CcbDCaja.CodDiv = Ccbcdocu.coddiv                            */
/*                     CcbDCaja.CodDoc = 'CHV'                                      */
/*                     CcbDCaja.NroDoc = Ccbcdocu.nrodoc                            */
/*                     CcbDCaja.CodMon = Ccbcdocu.codmon                            */
/*                     CcbDCaja.CodRef = Ccbcdocu.coddoc                            */
/*                     CcbDCaja.NroRef = Ccbcdocu.nrodoc                            */
/*                     CcbDCaja.FchDoc = TODAY                                      */
/*                     CcbDCaja.ImpTot = Ccbcdocu.imptot                            */
/*                     CcbDCaja.TpoCmb = Ccbcdocu.tpocmb.                           */
/*                 /* ************************************************** */         */
/*                FIND B-CCBC OF CCbCDocu EXCLUSIVE-LOCK NO-ERROR.                  */
/*                IF AVAILABLE B-CCBC THEN                                          */
/*                   ASSIGN                                                         */
/*                    B-CCBC.FlgEst = "C"                                           */
/*                    B-CCBC.FchCan = TODAY                                         */
/*                    B-CCBC.SdoAct = 0.                                            */
/*             END.                                                                 */
            /* ********************************************* */
        END.
    END.
END.
IF AVAILABLE (Ccbcdocu) THEN RELEASE CcbCDocu.
IF AVAILABLE (Ccbdcaja) THEN RELEASE Ccbdcaja.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields L-table-Win 
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
  {src/adm/template/snd-list.i "CcbCDocu"}

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

