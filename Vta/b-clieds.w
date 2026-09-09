&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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

DEFINE SHARED VARIABLE s-user-id AS CHARACTER.
DEFINE SHARED VARIABLE s-codcia AS INTEGER.
DEFINE VARIABLE x-CodCli AS CHARACTER NO-UNDO.

DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0 NO-UNDO.
FOR Empresas FIELDS
    (Empresas.CodCia Empresas.Campo-CodCli) WHERE
    Empresas.CodCia = S-CODCIA NO-LOCK:
END.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = S-CODCIA.

DEFINE TEMP-TABLE tt-load NO-UNDO
    FIELDS codcli AS CHARACTER
    FIELDS fecini AS DATE
    FIELDS fecfin AS DATE
    FIELDS dscto AS DECIMAL
    INDEX idx01 IS PRIMARY codcli fecini.

DEFINE BUFFER b_gn-clieDS FOR gn-clieDS.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES gn-clie
&Scoped-define FIRST-EXTERNAL-TABLE gn-clie


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-clie.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gn-clieds

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table gn-clieds.fecini gn-clieds.fecfin ~
gn-clieds.dscto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table gn-clieds.fecini ~
gn-clieds.fecfin gn-clieds.dscto 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table gn-clieds
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table gn-clieds
&Scoped-define QUERY-STRING-br_table FOR EACH gn-clieds OF gn-clie WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH gn-clieds OF gn-clie WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table gn-clieds
&Scoped-define FIRST-TABLE-IN-QUERY-br_table gn-clieds


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 br_table FILL-IN-file BUTTON-5 ~
BUTTON-load 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-file EDITOR-1 

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
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-load 
     LABEL "Cargar Datos" 
     SIZE 15 BY .77.

DEFINE VARIABLE EDITOR-1 AS CHARACTER INITIAL "OBS: El archivo de carga debe incluir el código del cliente, rango de fechas y el descuento correspondiente delimitados por comas." 
     VIEW-AS EDITOR
     SIZE 35 BY 2.15
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-file AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo" 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 5.92.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52 BY 5.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      gn-clieds SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      gn-clieds.fecini FORMAT "99/99/99":U
      gn-clieds.fecfin FORMAT "99/99/99":U WIDTH 7.14
      gn-clieds.dscto FORMAT "%>>9.99":U
  ENABLE
      gn-clieds.fecini
      gn-clieds.fecfin
      gn-clieds.dscto
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 29.43 BY 4.88
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.81 COL 3
     FILL-IN-file AT ROW 1.81 COL 57 COLON-ALIGNED WIDGET-ID 8
     BUTTON-5 AT ROW 1.81 COL 98 WIDGET-ID 6
     BUTTON-load AT ROW 2.88 COL 59 WIDGET-ID 14
     EDITOR-1 AT ROW 4.23 COL 60 NO-LABEL WIDGET-ID 16
     " Cargar desde archivo" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 1 COL 59 WIDGET-ID 12
          BGCOLOR 1 FGCOLOR 15 
     " Vigencia de Descuentos" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 1 COL 3 WIDGET-ID 4
          BGCOLOR 1 FGCOLOR 15 
     RECT-1 AT ROW 1.27 COL 1 WIDGET-ID 2
     RECT-2 AT ROW 1.27 COL 51 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.gn-clie
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
         HEIGHT             = 6.31
         WIDTH              = 103.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
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
/* BROWSE-TAB br_table RECT-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.gn-clieds OF INTEGRAL.gn-clie"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > INTEGRAL.gn-clieds.fecini
"gn-clieds.fecini" ? ? "date" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gn-clieds.fecfin
"gn-clieds.fecfin" ? ? "date" ? ? ? ? ? ? yes ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.gn-clieds.dscto
"gn-clieds.dscto" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN
        ASSIGN
            Gn-ClieDS.FecIni:READ-ONLY = TRUE
            Gn-ClieDS.FecFin:READ-ONLY = TRUE.
    ELSE
        ASSIGN
            Gn-ClieDS.FecIni:READ-ONLY = FALSE
            Gn-ClieDS.FecFin:READ-ONLY = FALSE.
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
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* ... */
DO:

    DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

    SYSTEM-DIALOG GET-FILE FILL-IN-file
        FILTERS
            "Archivos Excel (*.csv)" "*.csv",
            "Archivos Texto (*.txt)" "*.txt",
            "Todos (*.*)" "*.*"
        TITLE
            "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.

    IF OKpressed = TRUE THEN
        FILL-IN-file:SCREEN-VALUE = FILL-IN-file.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-load B-table-Win
ON CHOOSE OF BUTTON-load IN FRAME F-Main /* Cargar Datos */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN FILL-IN-file.
        IF FILL-IN-file = "" THEN DO:
            MESSAGE "Ingrese el Archivo"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO FILL-IN-file.
            RETURN NO-APPLY.
        END.
        IF SEARCH(FILL-IN-file) = ? THEN DO:
            MESSAGE "Archivo no existe"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO FILL-IN-file.
            RETURN NO-APPLY.
        END.
    END.
    RUN proc_charge_data.
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "gn-clie"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-clie"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    Gn-ClieDS.CodCia = Gn-clie.codcia
    Gn-ClieDS.CodCli = Gn-clie.codcli
    Gn-ClieDS.Fecha = DATETIME-TZ(TODAY, MTIME, TIMEZONE)
    Gn-ClieDS.Usuario = s-user-id.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF AVAILABLE gn-clie THEN x-CodCli = gn-clie.codcli.
  ELSE x-CodCli = ?.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_charge_data B-table-Win 
PROCEDURE proc_charge_data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lConflicts AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lClientOk AS LOGICAL NO-UNDO.

    DEFINE BUFFER b_gn-clie FOR gn-clie.

    FOR EACH tt-load:
        DELETE tt-load.
    END.

    OUTPUT TO VALUE(FILL-IN-file) APPEND.
    PUT UNFORMATTED "" CHR(10) SKIP.
    OUTPUT CLOSE.
    INPUT FROM VALUE(FILL-IN-file).
    REPEAT:
        CREATE tt-load.
        IMPORT DELIMITER ","
            tt-load.codcli
            tt-load.fecini
            tt-load.fecfin
            tt-load.dscto.
        IF tt-load.codcli = "" OR tt-load.codcli = ? THEN DELETE tt-load.
    END.
    INPUT CLOSE.

    IF NOT CAN-FIND(FIRST tt-load) THEN DO:
        MESSAGE "No existen registros a cargar"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN.
    END.

    /* Validación del Temporal */
    FOR EACH tt-load BREAK BY codcli BY fecini:
        IF FIRST-OF(tt-load.codcli) THEN DO:
            lClientOk = TRUE.
            FOR b_gn-clie FIELDS
                (b_gn-clie.codcia b_gn-clie.codcli) WHERE
                b_gn-clie.codcia = cl-codcia AND
                b_gn-clie.codcli = tt-load.codcli NO-LOCK:
            END.
            IF NOT AVAILABLE b_gn-clie THEN DO:
                MESSAGE
                    "Código de cliente " tt-load.codcli " NO EXISTE"
                    VIEW-AS ALERT-BOX ERROR.
                lClientOk = FALSE.
            END.
        END.
        IF NOT lClientOk THEN NEXT.
        IF tt-load.fecini = ? THEN DO:
            MESSAGE
                "Cliente: " tt-load.codcli SKIP
                "Rango no permite Fecha inicio nulo"
                VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        IF tt-load.FecFin = ? THEN DO:
            MESSAGE
                "Cliente: " tt-load.codcli SKIP
                "Rango solo con Fecha inicio " tt-load.fecini SKIP
                "Debe ingresar la fecha de fin"
                VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        IF tt-load.FecIni > tt-load.FecFin THEN DO:
            MESSAGE
                "Cliente: " tt-load.codcli SKIP
                "Fecha Fin no puede ser menor a fecha inicio"
                VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.

        /* Valida con datos existentes */
        IF CAN-FIND(FIRST b_gn-clieDS NO-LOCK
            WHERE b_gn-clieDS.CodCia = cl-CodCia
            AND b_gn-clieDS.CodCli = tt-load.codcli
            AND b_gn-clieDS.fecini = tt-load.FecIni) THEN DO:
            MESSAGE
                "Registro para cliente" tt-load.codcli
                "Fecha inicio " tt-load.FecIni " YA EXISTE"
                VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        FOR EACH b_gn-clieDS NO-LOCK
            WHERE b_gn-clieDS.CodCia = cl-CodCia
            AND b_gn-clieDS.CodCli = tt-load.codcli
            AND ((b_gn-clieDS.fecini = ? AND tt-load.FecIni = ?)
            OR (b_gn-clieDS.fecini = ? AND b_gn-clieDS.fecfin = ?)
            OR ((tt-load.FecIni >= b_gn-clieDS.fecini OR b_gn-clieDS.fecini = ?)
            AND tt-load.FecIni <= b_gn-clieDS.fecfin)):
            lConflicts = TRUE.
            LEAVE.
        END.
        IF lConflicts THEN DO:
            MESSAGE
                "Cliente: " tt-load.codcli SKIP
                "Rango de Fechas:" tt-load.FecIni tt-load.FecIni "no pueden traslaparse"
                VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.

        /* Carga Datos */
        CREATE gn-clieds.
        ASSIGN
            Gn-ClieDS.CodCia = cl-codcia
            Gn-ClieDS.CodCli = tt-load.codcli
            gn-clieds.fecini = tt-load.FecIni
            gn-clieds.fecfin = tt-load.FecFin
            gn-clieds.dscto = tt-load.Dscto
            Gn-ClieDS.Fecha = DATETIME-TZ(TODAY, MTIME, TIMEZONE)
            Gn-ClieDS.Usuario = s-user-id.

    END.

    RUN dispatch IN THIS-PROCEDURE ('open-query':U).

    MESSAGE "Proceso de carga completo"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

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
  {src/adm/template/snd-list.i "gn-clie"}
  {src/adm/template/snd-list.i "gn-clieds"}

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

    DEFINE VARIABLE conflicts AS LOGICAL NO-UNDO.
    DEFINE VARIABLE fFecFin AS DATE NO-UNDO.
    DEFINE VARIABLE fFecIni AS DATE NO-UNDO.

    fFecIni = DATE(INPUT BROWSE {&BROWSE-NAME} gn-clieDS.fecini).
    fFecFin = DATE(INPUT gn-clieDS.fecfin).

    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE <> 'NO' THEN DO:
        IF fFecIni = ? THEN DO:
            MESSAGE
                "Debe ingresar la fecha de inicio"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO gn-clieDS.fecini.
            RETURN "ADM-ERROR".
        END.
        IF fFecFin = ? THEN DO:
            MESSAGE
                "Debe ingresar la fecha de fin"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO gn-clieDS.fecfin.
            RETURN "ADM-ERROR".
        END.
        IF fFecIni > fFecFin THEN DO:
            MESSAGE
                "Fecha Fin no puede ser menor a fecha inicio"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.

        IF CAN-FIND(FIRST b_gn-clieDS NO-LOCK
            WHERE b_gn-clieDS.CodCia = cl-CodCia
            AND b_gn-clieDS.CodCli = x-CodCli
            AND b_gn-clieDS.fecini = fFecIni) THEN DO:
            MESSAGE
                "Fecha inicio YA EXISTE"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.

        conflicts = FALSE.
        FOR EACH b_gn-clieDS NO-LOCK
            WHERE b_gn-clieDS.CodCia = cl-CodCia
            AND b_gn-clieDS.CodCli = x-CodCli
            AND RECID(gn-clieDS) <> RECID(b_gn-clieDS)
            AND ((b_gn-clieDS.fecini = ? AND fFecIni = ?)
            OR (b_gn-clieDS.fecini = ? AND b_gn-clieDS.fecfin = ?)
            OR ((fFecIni >= b_gn-clieDS.fecini OR b_gn-clieDS.fecini = ?)
            AND fFecIni <= b_gn-clieDS.fecfin)):
            conflicts = TRUE.
            LEAVE.
        END.
        IF conflicts THEN DO:
            MESSAGE
                "Rango de Fechas no pueden traslaparse"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
    END.
    IF INPUT gn-clieDS.dscto = 0 THEN DO:
        MESSAGE
            "Debe ingresar el % de descuento"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO gn-clieDS.dscto.
        RETURN "ADM-ERROR".
    END.

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

