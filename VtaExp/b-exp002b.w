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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF BUFFER B-TURNO FOR ExpTurno.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ExpTermi
&Scoped-define FIRST-EXTERNAL-TABLE ExpTermi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ExpTermi.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ExpTurno gn-clie

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ExpTurno.Turno ExpTurno.Hora ~
ExpTurno.CodCli gn-clie.NomCli ExpTurno.Estado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ExpTurno.CodCli 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ExpTurno
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ExpTurno
&Scoped-define QUERY-STRING-br_table FOR EACH ExpTurno OF ExpTermi WHERE ~{&KEY-PHRASE} ~
      AND ExpTurno.Tipo = "I" ~
 AND ExpTurno.Fecha = TODAY NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCia = cl-codcia ~
  AND gn-clie.CodCli = ExpTurno.CodCli NO-LOCK ~
    BY ExpTurno.Turno
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ExpTurno OF ExpTermi WHERE ~{&KEY-PHRASE} ~
      AND ExpTurno.Tipo = "I" ~
 AND ExpTurno.Fecha = TODAY NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCia = cl-codcia ~
  AND gn-clie.CodCli = ExpTurno.CodCli NO-LOCK ~
    BY ExpTurno.Turno.
&Scoped-define TABLES-IN-QUERY-br_table ExpTurno gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ExpTurno
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-clie


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

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
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ExpTurno, 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ExpTurno.Turno FORMAT ">>>9":U
      ExpTurno.Hora FORMAT "x(10)":U
      ExpTurno.CodCli COLUMN-LABEL "<<<Cliente>>>" FORMAT "x(11)":U
      gn-clie.NomCli FORMAT "x(250)":U
      ExpTurno.Estado FORMAT "X":U
  ENABLE
      ExpTurno.CodCli
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 69 BY 11.35
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.ExpTermi
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
         HEIGHT             = 12.62
         WIDTH              = 74.
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
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.ExpTurno OF INTEGRAL.ExpTermi,INTEGRAL.gn-clie WHERE INTEGRAL.ExpTurno ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.ExpTurno.Turno|yes"
     _Where[1]         = "INTEGRAL.ExpTurno.Tipo = ""I""
 AND INTEGRAL.ExpTurno.Fecha = TODAY"
     _JoinCode[2]      = "INTEGRAL.gn-clie.CodCia = cl-codcia
  AND INTEGRAL.gn-clie.CodCli = ExpTurno.CodCli"
     _FldNameList[1]   = INTEGRAL.ExpTurno.Turno
     _FldNameList[2]   = INTEGRAL.ExpTurno.Hora
     _FldNameList[3]   > INTEGRAL.ExpTurno.CodCli
"ExpTurno.CodCli" "<<<Cliente>>>" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.gn-clie.NomCli
     _FldNameList[5]   = INTEGRAL.ExpTurno.Estado
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
  {src/adm/template/row-list.i "ExpTermi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ExpTermi"}

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
  DEF VAR x-Turno AS INT INIT 1 NO-UNDO.
  
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN x-Turno = ExpTurno.Turno.
  ELSE DO:
    FOR EACH B-TURNO NO-LOCK WHERE b-turno.codcia = ExpTermi.CodCia
        AND b-turno.coddiv = ExpTermi.CodDiv
        AND b-turno.block = ExpTermi.Block
        AND b-turno.fecha = TODAY
        AND b-turno.tipo  = 'I' BY B-TURNO.Turno:
        x-Turno = b-turno.turno + 1.
    END.
  END.    

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    ExpTurno.CodCia = ExpTermi.CodCia
    ExpTurno.CodDiv = ExpTermi.CodDiv
    ExpTurno.Block  = ExpTermi.Block  
    ExpTurno.Fecha  = TODAY
    ExpTurno.Hora   = STRING(TIME, 'HH:MM')
    ExpTurno.Tipo   = 'I'
    ExpTurno.Usuario = s-user-id
    ExpTurno.CodVen = ExpTermi.CodVen.
    ExpTurno.Turno  = x-Turno.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE ExpTurno THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */
  DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
  DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
  DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
  DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
  DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
  DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
  DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
  DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
  DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
  DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
  DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
  DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
  DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
  DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

  SESSION:DATE-FORMAT = 'mdy'.
  GET-KEY-VALUE SECTION 'Startup' KEY 'Base' VALUE RB-REPORT-LIBRARY.
  ASSIGN
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + '/vtaexp/rbvta.prl'
    RB-REPORT-NAME = 'Tickets Turno'
    RB-INCLUDE-RECORDS = 'O'
    RB-OTHER-PARAMETERS = 's-nomcli = ' + gn-clie.nomcli
    RB-FILTER = "expturno.codcia = " + STRING(expturno.codcia) +
                " AND expturno.coddiv = '" + TRIM(expturno.coddiv) + "'" +
                " AND expturno.block = '" + TRIM(expturno.block) + "'" +
                " AND expturno.fecha = " + STRING(expturno.fecha) +
                " AND expturno.tipo = '" + TRIM(expturno.tipo) + "'" +
                " AND expturno.hora = '" + TRIM(expturno.hora) + "'" +
                " AND expturno.codcli = '" + TRIM(expturno.codcli) + "'".
  SESSION:DATE-FORMAT = 'dmy'.
  
    /* CAPTURAMOS PARAMETROS DE LA IMPRESION */
  DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

  GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.
  
  ASSIGN cDelimeter = CHR(32).

  IF NOT (cDatabaseName = ? OR
          cHostName = ? OR
          cNetworkProto = ? OR
          cPortNumber = ?) THEN DO:
      ASSIGN
          cNewConnString =
          "-db" + cDelimeter + cDatabaseName + cDelimeter +
          "-H" + cDelimeter + cHostName + cDelimeter +
          "-N" + cDelimeter + cNetworkProto + cDelimeter +
          "-S" + cDelimeter + cPortNumber + cDelimeter.
      RB-DB-CONNECTION = cNewConnString.
  END.

  RUN aderb/_printrb (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-DB-CONNECTION,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-MEMO-FILE,
                    RB-PRINT-DESTINATION,
                    RB-PRINTER-NAME,
                    RB-PRINTER-PORT,
                    RB-OUTPUT-FILE,
                    RB-NUMBER-COPIES,
                    RB-BEGIN-PAGE,
                    RB-END-PAGE,
                    RB-TEST-PATTERN,
                    RB-WINDOW-TITLE,
                    RB-DISPLAY-ERRORS,
                    RB-DISPLAY-STATUS,
                    RB-NO-WAIT,
                    RB-OTHER-PARAMETERS).    

/* "~033A" */
  OUTPUT TO PRINTER.
  PUT CONTROL CHR(27) + 'm'.
  OUTPUT CLOSE.

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
  RUN dispatch IN THIS-PROCEDURE ('imprime':U).
  
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
  {src/adm/template/snd-list.i "ExpTermi"}
  {src/adm/template/snd-list.i "ExpTurno"}
  {src/adm/template/snd-list.i "gn-clie"}

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
  FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = ExpTurno.CodCli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-CLIE THEN DO:
    MESSAGE 'Cliente no registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  /* Revisar si ya tiene turno */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
    FIND LAST B-TURNO WHERE B-TURNO.codcia = Exptermi.codcia
        AND B-TURNO.coddiv = Exptermi.coddiv
        AND B-TURNO.codcli = ExpTurno.CodCli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        AND B-TURNO.fecha = TODAY NO-LOCK NO-ERROR.
    IF AVAILABLE B-TURNO THEN DO:
        MESSAGE 'El cliente YA tiene un turno' VIEW-AS ALERT-BOX WARNING.
    END.
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
  RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

