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
DEFINE SHARED VARIABLE S-CODDIV AS CHAR.
DEFINE SHARED VARIABLE s-CodDoc AS CHAR.
DEFINE SHARED VARIABLE S-CODTER AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
/*DEF SHARED VAR lh_handle AS HANDLE.*/

DEFINE NEW SHARED VARIABLE output-var-1 AS ROWID.
DEFINE NEW SHARED VARIABLE output-var-2 AS CHARACTER.
DEFINE NEW SHARED VARIABLE output-var-3 AS CHARACTER.

DEFINE VARIABLE C-Mon AS CHARACTER NO-UNDO.

DEFINE BUFFER b-ccbccaja FOR ccbccaja.
DEFINE BUFFER b-CcbCDocu FOR CcbCDocu.

/* Preprocesadores para condiciones */
&Scoped-define Condicion ccbccaja.codcia = s-codcia ~
AND (LOOKUP(ccbccaja.tipo,"CABO,CAFA,MOSTRADOR") > 0) ~
AND ccbccaja.coddiv = s-coddiv AND ccbccaja.coddoc = "I/C" ~
AND CcbCCaja.FchDoc >= f-desde AND CcbCCaja.FchDoc <= f-hasta ~
AND ccbccaja.flgest <> "A" AND ccbccaja.flgcie <> "C" ~
AND ccbccaja.codcaja = s-codter 

&SCOPED-DEFINE CODIGO integral.CcbCCaja.NroDoc

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 (integral.CcbCCaja.NomCli BEGINS FILL-IN-filtro)
&SCOPED-DEFINE FILTRO2 (INDEX(integral.CcbCCaja.NomCli, FILL-IN-filtro) <> 0)

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
&Scoped-define FIELDS-IN-QUERY-br_table CcbCCaja.NroDoc CcbCCaja.FchDoc ~
CcbCCaja.NomCli CcbCCaja.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCCaja WHERE ~{&KEY-PHRASE} ~
      AND {&condicion} ~
 NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCCaja WHERE ~{&KEY-PHRASE} ~
      AND {&condicion} ~
 NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CcbCCaja
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCCaja


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-codigo f-desde f-hasta CMB-filtro ~
FILL-IN-filtro br_table RECT-1 
&Scoped-Define DISPLAYED-OBJECTS w-divi FILL-IN-codigo f-desde f-hasta ~
CMB-filtro FILL-IN-filtro 

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
     DROP-DOWN-LIST
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
     SIZE 80 BY 9.23.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCCaja SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table L-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCCaja.NroDoc COLUMN-LABEL "Numero I/C" FORMAT "XXX-XXXXXXXX":U
      CcbCCaja.FchDoc COLUMN-LABEL "Fecha de I/C" FORMAT "99/99/9999":U
      CcbCCaja.NomCli COLUMN-LABEL "Nombre de Cliente" FORMAT "X(60)":U
      CcbCCaja.usuario COLUMN-LABEL "Cajera" FORMAT "x(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 76.14 BY 6.65
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     w-divi AT ROW 1.23 COL 6.43 COLON-ALIGNED
     FILL-IN-codigo AT ROW 1.23 COL 25.72 COLON-ALIGNED NO-LABEL
     f-desde AT ROW 1.23 COL 49.14 COLON-ALIGNED
     f-hasta AT ROW 1.23 COL 65.86 COLON-ALIGNED
     CMB-filtro AT ROW 2.19 COL 1.86 NO-LABEL
     FILL-IN-filtro AT ROW 2.23 COL 27.72 NO-LABEL
     br_table AT ROW 3.31 COL 1.86
     "Buscar x" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.35 COL 19
          FONT 6
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
         HEIGHT             = 9.23
         WIDTH              = 80.
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
     _TblList          = "integral.CcbCCaja"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&condicion}
"
     _FldNameList[1]   > integral.CcbCCaja.NroDoc
"CcbCCaja.NroDoc" "Numero I/C" "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.CcbCCaja.FchDoc
"CcbCCaja.FchDoc" "Fecha de I/C" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.CcbCCaja.NomCli
"CcbCCaja.NomCli" "Nombre de Cliente" "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.CcbCCaja.usuario
"CcbCCaja.usuario" "Cajera" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
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
    /*RUN Procesa-handle IN lh_handle ('browse').*/
    APPLY 'VALUE-CHANGED' TO  {&BROWSE-NAME}.

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
    /*RUN Procesa-handle IN lh_handle ('browse').*/

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
    /*RUN Procesa-handle IN lh_handle ('browse').*/

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
                /*RUN Procesa-handle IN lh_handle ('browse').*/
            END.
        END.
        /*ELSE RUN Procesa-handle IN lh_handle ('browse').*/
        ASSIGN SELF:SCREEN-VALUE = "".
    &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro L-table-Win
ON LEAVE OF FILL-IN-filtro IN FRAME F-Main
OR "RETURN":U OF FILL-IN-filtro DO:

    APPLY "VALUE-CHANGED" TO CMB-filtro.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK L-table-Win 


ASSIGN
    w-divi = S-CodDiv
    f-desde = TODAY
    f-hasta = TODAY.

ON FIND OF CcbDCaja DO:
    C-Mon = "S/.".
    IF CcbDCaja.CodMon = 2 THEN C-Mon = "US$".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Anula-Cancelacion L-table-Win 
PROCEDURE proc_Anula-Cancelacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE x_nrodoc AS CHARACTER NO-UNDO.
    DEF VAR s-FechaI AS DATETIME NO-UNDO.
    DEF VAR s-FechaT AS DATETIME NO-UNDO.

    IF NOT AVAILABLE CcbCCaja THEN RETURN.

    s-FechaI = DATETIME(TODAY, MTIME).

    /* Valida Clave de Anulación */
    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}

    IF ccbccaja.flgcie NE "P" THEN DO:
        MESSAGE
            "Ya se hizo el cierre de caja"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF ccbccaja.flgest = "A" THEN DO:
        MESSAGE
            "Registro ya fue Anulado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    /* Verifica Cheque Aceptado */
    IF ((CcbCCaja.Voucher[2] <> "" ) AND
        (CcbCCaja.ImpNac[2] + CcbCCaja.ImpUsa[2]) > 0 ) OR
        ((CcbCCaja.Voucher[3] <> "" ) AND
        (CcbCCaja.ImpNac[3] + CcbCCaja.ImpUsa[3]) > 0) THEN DO:

        IF CcbCCaja.Voucher[2] <> "" THEN x_nrodoc = CcbCCaja.Voucher[2].
        IF CcbCCaja.Voucher[3] <> "" THEN x_nrodoc = CcbCCaja.Voucher[3].

        FIND FIRST CcbCDocu WHERE 
            CcbCDocu.CodCia = S-CodCia AND
            CcbCDocu.CodDoc = "CHC" AND
            CcbCDocu.NroDoc = x_nrodoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu AND CcbCDocu.FlgEst = "C" THEN DO:
            MESSAGE
                "Ingreso con Cheque Aceptado,"
                "No es posible Anular la Operacion"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
    END.

    /* Motivo de anulacion */
    DEF VAR cReturnValue AS CHAR.

    RUN ccb/d-motanu-2 (OUTPUT cReturnValue).
    IF cReturnValue = 'ADM-ERROR' THEN RETURN "ADM-ERROR".

    /* Actualiza la cuenta corriente */
    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Extorna Saldo de documentos */
        FOR EACH ccbdcaja OF ccbccaja:
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia 
                AND ccbcdocu.coddoc = ccbdcaja.codref 
                AND ccbcdocu.nrodoc = ccbdcaja.nroref
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcdocu THEN UNDO, RETURN 'ADM-ERROR'.
            /* Extorna Salida de Almacen */
            RUN proc_Extorna-Alm(ROWID(CcbCDocu), CcbCCaja.CodCaja).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            /* Elimina Detalle de Documento */
            FOR EACH ccbDdocu OF ccbcdocu:
                DELETE ccbDdocu.
            END.
            ASSIGN
                ccbCdocu.sdoact = 0
                ccbcdocu.fchcan = ?
                ccbCdocu.flgest = "A"
                ccbCdocu.FchAnu = TODAY
                ccbCdocu.UsuAnu = S-USER-ID.
/*             FOR EACH Vtactrkped WHERE Vtactrkped.codcia = s-codcia */
/*                 AND Vtactrkped.coddoc = Ccbcdocu.codped            */
/*                 AND Vtactrkped.nroped = Ccbcdocu.nroped:           */
/*                 ASSIGN                                             */
/*                     Vtactrkped.FlgSit = 'A'.                       */
/*                 FOR EACH Vtadtrkped OF Vtactrkped:                 */
/*                     ASSIGN                                         */
/*                         Vtadtrkped.flgsit = 'A'.                   */
/*                 END.                                               */
/*             END.                                                   */
            /* MOTIVO DE ANULACION */
            CREATE Ccbaudit.
            ASSIGN
                CcbAudit.CodCia = ccbcdocu.codcia
                CcbAudit.CodCli = ccbcdocu.codcli
                CcbAudit.CodDiv = ccbcdocu.coddiv
                CcbAudit.CodDoc = ccbcdocu.coddoc
                CcbAudit.CodMon = ccbcdocu.codmon
                CcbAudit.CodRef = cReturnValue
                CcbAudit.Evento = 'DELETE'
                CcbAudit.Fecha  = TODAY
                CcbAudit.Hora   = STRING(TIME, 'HH:MM')
                CcbAudit.ImpTot = ccbcdocu.sdoact
                CcbAudit.NomCli = ccbcdocu.nomcli
                CcbAudit.NroDoc = ccbcdocu.nrodoc
                CcbAudit.Usuario = s-user-id.
            /* ******************* */
            DELETE ccbdcaja.
        END.

        /* EXTORNOS DE CANCELACIONES */
        /* Cheque */
        IF ((CcbCCaja.Voucher[2] <> "" ) AND
            (CcbCCaja.ImpNac[2] + CcbCCaja.ImpUsa[2]) > 0 ) OR
            ((CcbCCaja.Voucher[3] <> "" ) AND
            (CcbCCaja.ImpNac[3] + CcbCCaja.ImpUsa[3]) > 0) THEN DO:
            FIND CcbCDocu WHERE
                CcbCDocu.CodCia = S-CodCia AND
                CcbCDocu.CodDoc = "CHC" AND
                CcbCDocu.NroDoc = x_nrodoc
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE CcbCDocu THEN DELETE CcbCDocu.
        END.

        /* Elimina Detalle de la Aplicación para N/C y A/R y BD */
        FOR EACH CCBDMOV WHERE CCBDMOV.CodCia = ccbccaja.CodCia 
                AND CCBDMOV.CodDiv = ccbccaja.CodDiv 
                AND CCBDMOV.CodRef = ccbccaja.coddoc 
                AND CCBDMOV.NroRef = ccbccaja.nrodoc:
            /* Tipo de Documento */
            FIND FacDoc WHERE FacDoc.CodCia = CCBDMOV.CodCia 
                AND FacDoc.CodDoc = CCBDMOV.CodDoc
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE FacDoc THEN DO:
                MESSAGE
                    "DOCUMENTO" CCBDMOV.CodDoc 'NO CONFIGURADO'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
            END.
            FIND FIRST CcbCDocu WHERE CcbCDocu.codcia = CCBDMOV.CodCia 
                AND CcbCDocu.coddoc = CCBDMOV.CodDoc 
                AND CcbCDocu.nrodoc = CCBDMOV.NroDoc EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE ccbcdocu THEN DO:
                MESSAGE
                    "DOCUMENTO" CCBDMOV.CodDoc CCBDMOV.NroDoc "NO REGISTRADO"
                    VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
            END.
            IF FacDoc.TpoDoc THEN
                ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct - CCBDMOV.Imptot.
            ELSE
                ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct + CCBDMOV.Imptot.
            /* Cancela Documento */
            IF CcbCDocu.SdoAct <> 0 THEN
                ASSIGN
                    CcbCDocu.FlgEst = "P"
                    CcbCDocu.FchCan = ?.
            RELEASE CcbCDocu.
            DELETE CCBDMOV.
        END.

        /* Extorna Retencion */
        FOR EACH CcbCMov WHERE CCBCMOV.CodCia = CcbCCaja.CodCia 
            AND CCBCMOV.CodRef = CcbCCaja.CodDoc 
            AND CCBCMOV.NroRef = CcbCCaja.NroDoc:
            DELETE CcbCMov.
        END.

        /* Anula Ingreso de Caja */
        FIND b-ccbccaja WHERE
            ROWID(b-ccbccaja) = ROWID(ccbccaja)
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b-ccbccaja THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN b-ccbccaja.flgest = "A".

        RELEASE b-ccbccaja.
        IF AVAILABLE(ccbcdocu) THEN RELEASE ccbcdocu.
        IF AVAILABLE(ccbddocu) THEN RELEASE ccbddocu.
        IF AVAILABLE(ccbaudit) THEN RELEASE ccbaudit.
    END. /* DO TRANSACTION... */

    RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AnulaBD L-table-Win 
PROCEDURE proc_AnulaBD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_NroDoc LIKE CCBDMOV.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CCBDMOV.NroDoc.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CCBDMOV.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CCBDMOV.ImpTot.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND ccbboldep WHERE
            ccbboldep.CodCia = s-CodCia AND
            ccbboldep.CodDoc = "BD" AND
            ccbboldep.nrodoc = para_NroDoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE CcbBolDep THEN DO:
            MESSAGE
                "BOLETA DE DEPOSITO" para_NroDoc "NO EXISTE"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.

        /* Elimina Detalle de la Aplicación */
        FOR EACH CCBDMOV WHERE
            CCBDMOV.CodCia = s-CodCia AND
            CCBDMOV.CodDiv = s-CodDiv AND
            CCBDMOV.NroDoc = ccbboldep.NroDoc AND
            CCBDMOV.CodDoc = ccbboldep.CodDoc
            EXCLUSIVE-LOCK:
            /* Referencia I/C */
            IF CCBDMOV.CodRef = s-coddoc AND
                CCBDMOV.NroRef = para_NroDocCja THEN
                DELETE CCBDMOV.
        END.

        IF CcbBolDep.CodMon = 1 THEN
            ASSIGN CcbBolDep.SdoAct = CcbBolDep.SdoAct + para_ImpNac.
        ELSE
            ASSIGN CcbBolDep.SdoAct = CcbBolDep.SdoAct + para_ImpUSA.

        IF CcbBolDep.SdoAct > 0 THEN
            ASSIGN
                CcbBolDep.FchCan = ?
                CcbBolDep.FlgEst = "p".

        RELEASE ccbboldep.

  END. /* DO TRANSACTION... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AnulaDoc L-table-Win 
PROCEDURE proc_AnulaDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_CodDoc LIKE CcbCDocu.CodDoc.
    DEFINE INPUT PARAMETER para_NroDoc LIKE CcbDMov.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CcbDMov.NroDoc.    
    DEFINE INPUT PARAMETER para_ImpNac LIKE CcbDMov.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CcbDMov.ImpTot.

    DEFINE VARIABLE x-Monto LIKE ccbcdocu.ImpTot.

    /* Tipo de Documento */
    FIND FacDoc WHERE
        FacDoc.CodCia = s-CodCia AND
        FacDoc.CodDoc = para_CodDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDoc THEN DO:
        MESSAGE
            para_CodDoc 'NO CONFIGURADO'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND FIRST ccbcdocu WHERE
            ccbcdocu.codcia = s-codcia AND
            ccbcdocu.coddoc = para_CodDoc AND
            ccbcdocu.nrodoc = para_NroDoc
            EXCLUSIVE-LOCK.

        IF NOT AVAILABLE ccbcdocu THEN DO:
            MESSAGE
                "DOCUMENTO" para_CodDoc para_NroDoc "NO REGISTRADO"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.

        /* Elimina Detalle de la Aplicación */
        FOR EACH CCBDMOV WHERE
            CCBDMOV.CodCia = s-CodCia AND
            CCBDMOV.CodDiv = s-CodDiv AND
            CCBDMOV.NroDoc = ccbcdocu.NroDoc AND
            CCBDMOV.CodDoc = ccbcdocu.CodDoc
            EXCLUSIVE-LOCK:
            /* Referencia I/C */
            IF CCBDMOV.CodRef = s-coddoc AND
                CCBDMOV.NroRef = para_NroDocCja THEN
                DELETE CCBDMOV.
        END.

        IF CcbCDocu.CodMon = 1 THEN ASSIGN x-Monto = para_ImpNac.
        ELSE ASSIGN x-Monto = para_ImpUSA.

        IF FacDoc.TpoDoc THEN
            ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct - x-Monto.
        ELSE
            ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct + x-Monto.

        /* Cancela Documento */
        IF CcbCDocu.SdoAct <> 0 THEN
            ASSIGN
                CcbCDocu.FlgEst = "P"
                CcbCDocu.FchCan = ?.

        RELEASE CcbCDocu.

  END. /* DO TRANSACTION... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Extorna-Alm L-table-Win 
PROCEDURE proc_Extorna-Alm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_rowid AS ROWID.
    DEFINE INPUT PARAMETER para_CodTer AS CHARACTER.

    FIND b-CcbCDocu WHERE ROWID(b-CcbCDocu) = para_rowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE b-CcbCDocu THEN RETURN 'ADM-ERROR'.

    /* Busca Número de Serie */
    FIND FIRST ccbdterm WHERE
        CcbDTerm.CodCia = b-CcbCDocu.codcia AND
        CcbDTerm.CodDiv = b-CcbCDocu.coddiv AND
        CcbDTerm.CodDoc = b-CcbCDocu.coddoc AND
        CcbDTerm.CodTer = para_CodTer NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbdterm THEN DO:
        MESSAGE
            "DOCUMENTO NO ESTA CONFIGURADO EN ESTE TERMINAL"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    /* 09.09.10 PARCHE PARA ERRORES DE GRABACION EN EL ALMACEN */
    FIND almcmov WHERE 
        almcmov.codcia = b-CcbCDocu.codcia AND
        almcmov.codalm = b-CcbCDocu.codalm AND
        almcmov.tipmov = "S" AND
        almcmov.codmov = b-CcbCDocu.codmov AND
        almcmov.nroSer = Ccbdterm.nroser AND
        almcmov.nrodoc = INTEGER(b-CcbCDocu.nrosal)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almcmov THEN RETURN 'OK'.
    /* ******************************************************** */

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Anula orden de despacho */
        FIND almcmov WHERE 
            almcmov.codcia = b-CcbCDocu.codcia AND
            almcmov.codalm = b-CcbCDocu.codalm AND
            almcmov.tipmov = "S" AND
            almcmov.codmov = b-CcbCDocu.codmov AND
            almcmov.nroSer = Ccbdterm.nroser AND
            almcmov.nrodoc = INTEGER(b-CcbCDocu.nrosal)
            EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.

        RUN alm/p-ciealm-01 (almcmov.fchdoc, almcmov.codalm).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

        FOR EACH almdmov OF almcmov:
            /* RUN alm/almcgstk (ROWID(almdmov)). */
            RUN alm/almacstk (ROWID(almdmov)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            /* RHC 05.04.04 ACTIVAMOS KARDEX POR ALMACEN */
            RUN alm/almacpr1 (ROWID(almdmov), 'D').
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            DELETE almdmov.
        END.
        ASSIGN 
            almcmov.flgest = "A".
        IF AVAILABLE(almcmov) THEN RELEASE almcmov.
        IF AVAILABLE(almdmov) THEN RELEASE almdmov.
        IF AVAILABLE(almmmate) THEN RELEASE almmmate.
    END.

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

