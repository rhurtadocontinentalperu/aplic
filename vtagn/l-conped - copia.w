&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
DEFINE SHARED VARIABLE input-var-1 AS CHARACTER.
DEFINE SHARED VARIABLE input-var-2 AS CHARACTER.
DEFINE SHARED VARIABLE input-var-3 AS CHARACTER.
DEFINE SHARED VARIABLE output-var-1 AS ROWID.
DEFINE SHARED VARIABLE output-var-2 AS CHARACTER.
DEFINE SHARED VARIABLE output-var-3 AS CHARACTER.

DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.

/* Definición de variables locales */
DEFINE VARIABLE whpadre AS WIDGET-HANDLE.
DEFINE VARIABLE wh      AS WIDGET-HANDLE.
DEFINE VARIABLE curr-record AS RECID.

/* Preprocesadores para condiciones */
/*&SCOPED-DEFINE CONDICION ( TRUE )
 * &SCOPED-DEFINE CODIGO GN-CIAS.codcia
 * 
 * /* Preprocesadores para cada campo filtro */
 * &SCOPED-DEFINE FILTRO1 ( GN-CIAS.nomcia BEGINS FILL-IN-filtro )
 * &SCOPED-DEFINE FILTRO2 ( INDEX ( GN-CIAS.nomcia , FILL-IN-filtro ) <> 0 )*/

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


DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodAlm LIKE FacCPedi.CodAlm FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.


FOR EACH tmp-tabla:
    DISPLAY tmp-tabla.
END.

RUN CARGA-TEMPORAL.

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
&Scoped-define INTERNAL-TABLES tmp-tabla

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table t-CodAlm t-CodDoc t-NroPed t-FchPed t-NomCli t-CanPed   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH tmp-tabla WHERE ~{&KEY-PHRASE} NO-LOCK     ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH tmp-tabla WHERE ~{&KEY-PHRASE} NO-LOCK     ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table tmp-tabla
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tmp-tabla


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-1 

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
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
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
Código|y||integral.GN-CIAS.CodCia|yes
Descripción|||integral.GN-CIAS.NomCia|yes
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
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 9.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      tmp-tabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table L-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      t-CodAlm COLUMN-LABEL "Almacen" FORMAT 'x(3)'
      t-CodDoc COLUMN-LABEL "Codigo!Documento"  FORMAT "XXX"
      t-NroPed COLUMN-LABEL "Numero!Pedido" FORMAT "XXX-XXXXXXXX"
      t-FchPed COLUMN-LABEL "  Fecha       !  Pedido       "  FORMAT "99/99/9999"
      t-NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
      t-CanPed COLUMN-LABEL "Cantidad" FORMAT ">>>,>>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 73.29 BY 8.62
         BGCOLOR 15 FGCOLOR 0 FONT 4
         TITLE BGCOLOR 15 FGCOLOR 0 "STOCK COMPROMETIDO EN PEDIDOS".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.19 COL 1.72
     RECT-1 AT ROW 1 COL 1
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
         HEIGHT             = 9.42
         WIDTH              = 79.43.
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tmp-tabla WHERE ~{&KEY-PHRASE} NO-LOCK
    ~{&SORTBY-PHRASE}.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
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
ON ANY-PRINTABLE OF br_table IN FRAME F-Main /* STOCK COMPROMETIDO EN PEDIDOS */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main /* STOCK COMPROMETIDO EN PEDIDOS */
DO:
  /*  RUN p-aceptar IN whpadre.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main /* STOCK COMPROMETIDO EN PEDIDOS */
DO:
    RETURN NO-APPLY.
    /* This code displays initial values for newly added or copied rows. */
    {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* STOCK COMPROMETIDO EN PEDIDOS */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON START-SEARCH OF br_table IN FRAME F-Main /* STOCK COMPROMETIDO EN PEDIDOS */
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
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* STOCK COMPROMETIDO EN PEDIDOS */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK L-table-Win 


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

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'Código':U THEN DO:
      &Scope SORTBY-PHRASE BY GN-CIAS.CodCia
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Descripción':U THEN DO:
      &Scope SORTBY-PHRASE BY GN-CIAS.NomCia
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    OTHERWISE DO:
      &Undefine SORTBY-PHRASE
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
/*
&IF DEFINED (FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) > 0 &THEN

IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
    ASSIGN
        output-var-1 = ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} )
        output-var-2 = STRING( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codcia, "999" )
        output-var-3 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nomcia.

&ENDIF
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal L-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/**********   Barremos para los PEDIDOS MOSTRADOR ***********************/ 
FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccfggn THEN RETURN.

/* Stock comprometido por PEDIDOS ACTIVOS MOSTRADOR */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.

/* Tiempo por defecto fuera de campaña */
TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
          (FacCfgGn.Hora-Res * 3600) + 
          (FacCfgGn.Minu-Res * 60).

DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR k AS INT NO-UNDO.

DO k = 1 TO NUM-ENTRIES(input-var-1):
    x-CodAlm = ENTRY(k, input-var-1).
    FOR EACH Facdpedi USE-INDEX Llave04 NO-LOCK WHERE Facdpedi.CodCia = s-codcia 
        AND Facdpedi.AlmDes = x-codalm
        AND Facdpedi.codmat = input-var-2
        AND Facdpedi.coddoc = 'P/M'
        AND Facdpedi.FlgEst = "P" :
        FIND FIRST Faccpedi OF Facdpedi WHERE Faccpedi.FlgEst = "P" NO-LOCK NO-ERROR. 
        IF NOT AVAIL Faccpedi THEN NEXT.

        TimeNow = (TODAY - FacCPedi.FchPed) * 24 * 3600.
        TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedi.Hora, 1, 2)) * 3600) +
                  (INTEGER(SUBSTRING(FacCPedi.Hora, 4, 2)) * 60) ).
        IF TimeOut > 0 THEN DO:
            IF TimeNow <= TimeOut   /* Dentro de la valides */
            THEN DO:
                CREATE tmp-tabla.
                ASSIGN 
                  t-CodAlm = x-CodAlm
                  t-CodDoc = FacCPedi.codDoc
                  t-NroPed = FacCPedi.NroPed
                  t-FchPed = FacCPedi.FchPed
                  t-NomCli = FacCPedi.NomCli
                  t-codmat = FacDPedi.CodMat
                  t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
            END.
        END.
    END.

    /**********   Barremos los PEDIDOS AL CREDITO   ***********************/ 
    FOR EACH FacDPedi USE-INDEX llave04 NO-LOCK WHERE FacDPedi.CodCia = s-codcia 
                       AND  FacDPedi.almdes = x-codalm
                       AND  FacDPedi.codmat = input-var-2 
                       AND  FacDPedi.CodDoc = 'PED'
                       AND (Facdpedi.canped - Facdpedi.canate) > 0
                       AND  FacDPedi.FlgEst = 'P',
                       FIRST FacCPedi OF FacDPedi NO-LOCK WHERE 
                        LOOKUP(Faccpedi.FlgEst, "G,X,P,W,WX,WL") > 0:
        CREATE tmp-tabla.
        ASSIGN 
            t-CodAlm = x-CodAlm
          t-CodDoc = FacCPedi.codDoc
          t-NroPed = FacCPedi.NroPed
          t-FchPed = FacCPedi.FchPed
          t-NomCli = FacCPedi.NomCli
          t-codmat = FacDPedi.CodMat
          t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
    END.
    /*********   Barremos las O/D que son parciales y totales    ****************/
    FOR EACH FacDPedi USE-INDEX llave04 NO-LOCK WHERE FacDPedi.CodCia = s-codcia
            AND  FacDPedi.almdes = x-codalm
            AND  FacDPedi.codmat = input-var-2
            AND  FacDPedi.CodDoc = 'O/D'
            AND (Facdpedi.canped - Facdpedi.canate) > 0
            AND  FacDPedi.FlgEst = 'P',
            FIRST FacCPedi OF FacDPedi NO-LOCK WHERE Faccpedi.FlgEst = "P":
        CREATE tmp-tabla.
        ASSIGN 
            t-CodAlm = x-CodAlm
          t-CodDoc = FacCPedi.codDoc
          t-NroPed = FacCPedi.NroPed
          t-FchPed = FacCPedi.FchPed
          t-NomCli = FacCPedi.NomCli
          t-codmat = FacDPedi.CodMat
          t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
    END.
    /*******************************************************/
    /* Stock Comprometido por Pedidos por Reposicion Automatica */
/*     FOR EACH Almcrepo NO-LOCK WHERE Almcrepo.codcia = s-codcia                */
/*         AND Almcrepo.TipMov = 'A'                                             */
/*         AND Almcrepo.AlmPed = x-codalm                                        */
/*         AND Almcrepo.FlgEst = 'P'                                             */
/*         AND Almcrepo.FlgSit = 'A',                                            */
/*         EACH Almdrepo OF Almcrepo NO-LOCK WHERE Almdrepo.codmat = input-var-2 */
/*         AND almdrepo.CanApro > almdrepo.CanAten:                              */
/*         /* cantidad en reservacion */                                         */
/*         CREATE tmp-tabla.                                                     */
/*         ASSIGN                                                                */
/*             t-CodAlm = x-CodAlm                                               */
/*           t-CodDoc = "REP"                                                    */
/*           t-NroPed = STRING (Almcrepo.NroDoc)                                 */
/*           t-FchPed = almcrepo.FchDoc                                          */
/*           t-NomCli = ""                                                       */
/*           t-codmat = almdrepo.CodMat                                          */
/*           t-CanPed = (almdrepo.CanApro - almdrepo.CanAten).                   */
/*     END.                                                                      */
    FOR EACH Almcrepo USE-INDEX Llave02 NO-LOCK WHERE Almcrepo.codcia = s-CodCia
        AND Almcrepo.almped = x-CodAlm
        AND Almcrepo.flgest = 'P',
        FIRST Almdrepo OF Almcrepo NO-LOCK WHERE Almdrepo.codmat = input-var-2
        AND (Almdrepo.CanApro > Almdrepo.CanAten):
        IF NOT LOOKUP(Almcrepo.TipMov, 'A,M,RAN,INC') > 0 THEN NEXT.
        /* cantidad en reservacion */
        CREATE tmp-tabla.
        ASSIGN 
            t-CodAlm = x-CodAlm
            t-CodDoc = "REP"
            t-NroPed = STRING (Almcrepo.NroSer, '999') + STRING(Almcrepo.NroDoc)
            t-FchPed = almcrepo.FchDoc
            t-NomCli = ""
            t-codmat = almdrepo.CodMat
            t-CanPed = (almdrepo.CanApro - almdrepo.CanAten).
    END.
    /* RHC 23/04/2020 Mercadería comprometida por Cotizaciones */
    FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-CodCia AND
        FacTabla.Tabla = "GN-DIVI" AND
            FacTabla.Campo-L[2] = YES AND   /* Compromete mercaderia por COT */
        FacTabla.Valor[1] > 0,          /* Tope en horas */
        FIRST gn-divi NO-LOCK WHERE gn-divi.codcia = s-CodCia AND
        gn-divi.coddiv = FacTabla.Codigo,
        EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-CodCia AND
        Faccpedi.coddiv = gn-divi.coddiv AND 
        Faccpedi.coddoc = "COT" AND
        Faccpedi.flgest = "P",
        FIRST Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.codmat = input-var-2 AND
        Facdpedi.flgest = "P" AND
        Facdpedi.almdes = x-CodAlm:

        TimeOut = (FacTabla.Valor[1] * 3600).       /* En segundos */
        TimeNow = (TODAY - Faccpedi.FchPed) * 24 * 3600.
        TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(Faccpedi.Hora, 1, 2)) * 3600) +
                                     (INTEGER(SUBSTRING(Faccpedi.Hora, 4, 2)) * 60) ).
        IF TimeOut > 0 THEN DO:
            IF TimeNow <= TimeOut   /* Dentro de la valides */
            THEN DO:
                CREATE tmp-tabla.
                ASSIGN 
                  t-CodAlm = x-CodAlm
                  t-CodDoc = FacCPedi.codDoc
                  t-NroPed = FacCPedi.NroPed
                  t-FchPed = FacCPedi.FchPed
                  t-NomCli = FacCPedi.NomCli
                  t-codmat = FacDPedi.CodMat
                  t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
            END.
        END.

    END.

END.




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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize L-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

/*    RUN get-attribute ('Keys-Accepted').
 * 
 *     IF RETURN-VALUE <> "" AND RETURN-VALUE <> ? THEN
 *         ASSIGN
 *             CMB-filtro:LIST-ITEMS IN FRAME {&FRAME-NAME} =
 *             CMB-filtro:LIST-ITEMS + "," + RETURN-VALUE.*/

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
  {src/adm/template/snd-list.i "tmp-tabla"}

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

