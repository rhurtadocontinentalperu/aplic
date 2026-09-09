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

DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codcia  AS INT.

DEFINE BUFFER b-gncliel FOR Gn-ClieL.

DEFINE SHARED VAR lh_handle AS HANDLE.

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
&Scoped-define EXTERNAL-TABLES gn-clie
&Scoped-define FIRST-EXTERNAL-TABLE gn-clie


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-clie.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Gn-ClieL

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Gn-ClieL.FchIni Gn-ClieL.FchFin ~
Gn-ClieL.MonLC Gn-ClieL.ImpLC Gn-ClieL.UsrLC Gn-ClieL.FchAut[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Gn-ClieL.FchIni ~
Gn-ClieL.FchFin Gn-ClieL.ImpLC 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Gn-ClieL
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Gn-ClieL
&Scoped-define QUERY-STRING-br_table FOR EACH Gn-ClieL OF gn-clie WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Gn-ClieL OF gn-clie WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Gn-ClieL
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Gn-ClieL


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-3 ChkbComoDNI 
&Scoped-Define DISPLAYED-OBJECTS ChkbComoDNI 

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
DEFINE BUTTON BUTTON-3 
     LABEL "Sentinel" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE ChkbComoDNI AS LOGICAL INITIAL yes 
     LABEL "RUC que inicie con 10 buscar como DNI" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Gn-ClieL SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Gn-ClieL.FchIni FORMAT "99/99/99":U WIDTH 8
      Gn-ClieL.FchFin FORMAT "99/99/99":U WIDTH 8
      Gn-ClieL.MonLC FORMAT "9":U WIDTH 11.57 VIEW-AS COMBO-BOX INNER-LINES 2
                      LIST-ITEM-PAIRS "Soles",1,
                                      "Dolares",2
                      DROP-DOWN-LIST 
      Gn-ClieL.ImpLC FORMAT ">,>>>,>>>,>>9.99":U WIDTH 16
      Gn-ClieL.UsrLC FORMAT "X(10)":U
      Gn-ClieL.FchAut[1] FORMAT "99/99/9999":U
  ENABLE
      Gn-ClieL.FchIni
      Gn-ClieL.FchFin
      Gn-ClieL.ImpLC
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 73.72 BY 6.08
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.08 COL 1.29
     BUTTON-3 AT ROW 7.35 COL 16.72 WIDGET-ID 2
     ChkbComoDNI AT ROW 7.5 COL 33 WIDGET-ID 4
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
         HEIGHT             = 8.23
         WIDTH              = 83.29.
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
     _TblList          = "INTEGRAL.Gn-ClieL OF INTEGRAL.gn-clie"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > INTEGRAL.Gn-ClieL.FchIni
"Gn-ClieL.FchIni" ? ? "date" ? ? ? ? ? ? yes ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Gn-ClieL.FchFin
"Gn-ClieL.FchFin" ? ? "date" ? ? ? ? ? ? yes ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Gn-ClieL.MonLC
"Gn-ClieL.MonLC" ? ? "integer" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Soles,1,Dolares,2" 2 no 0 no no
     _FldNameList[4]   > INTEGRAL.Gn-ClieL.ImpLC
"Gn-ClieL.ImpLC" ? ">,>>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.Gn-ClieL.UsrLC
     _FldNameList[6]   = INTEGRAL.Gn-ClieL.FchAut[1]
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
  IF RETURN-VALUE = 'YES'
  THEN DISPLAY
            (TODAY - DAY(TODAY) + 1) @ Gn-ClieL.FchIni
            TODAY @ Gn-ClieL.FchFin
            WITH BROWSE {&BROWSE-NAME}.
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Sentinel */
DO:    
  ASSIGN ChkBComoDNI.
  
  RUN riesgo-crediticio IN lh_handle(INPUT ChkbComoDNI).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF Gn-ClieL.FchFin, Gn-ClieL.FchIni DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND gn-LinUsr WHERE gn-LinUsr.Usuario = S-USER-ID NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-LinUsr THEN DO:
    MESSAGE 'El usuario NO tiene autorización para modificar la línea de crédito'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  DEF VAR s-LogTabla AS LOG INIT YES NO-UNDO.

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      IF gn-cliel.fchini <> DATE(Gn-ClieL.FchIni:SCREEN-VALUE IN BROWSE {&browse-name})
          OR gn-cliel.fchfin <> DATE(Gn-ClieL.FchFin:SCREEN-VALUE IN BROWSE {&browse-name})
          OR Gn-ClieL.ImpLC <> DECIMAL(Gn-ClieL.ImpLC:SCREEN-VALUE IN BROWSE {&browse-name})
          THEN s-LogTabla = YES.
      ELSE s-LogTabla = NO.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN 
      ASSIGN
      s-LogTabla = YES
      Gn-ClieL.MonLC = 1.      /* OJO >>> SOLES */

  ASSIGN
    Gn-ClieL.CodCia = gn-clie.codcia
    Gn-ClieL.CodCli = gn-clie.codcli.
 
  ASSIGN
      gn-cliel.fchaut[1] = TODAY
      gn-cliel.usrlc = s-user-id.

  /* RHC 30.11.11 Verificación de fechas */
  DEF VAR lValido AS LOG.

  lValido = YES.
  IF Gn-ClieL.FchFin < Gn-ClieL.FchIni THEN lvalido = NO.

  FOR EACH b-gncliel WHERE b-gncliel.codcia = gn-clie.codcia
      AND b-GnClieL.CodCli = gn-clie.codcli
      AND ROWID(b-gncliel) <> ROWID(gn-cliel)
      AND lvalido = YES NO-LOCK:
      IF Gn-ClieL.FchIni >= b-gncliel.fchini AND Gn-ClieL.FchIni <= b-gncliel.fchfin 
          THEN lvalido = NO.
      IF Gn-ClieL.FchFin >= b-gncliel.fchini AND Gn-ClieL.FchFin <= b-gncliel.fchfin 
          THEN lvalido = NO.
      IF Gn-ClieL.FchIni <= b-gncliel.fchini AND Gn-ClieL.FchFin >= b-gncliel.fchfin 
          THEN lvalido = NO.
  END.

  IF NOT lvalido THEN DO:
      MESSAGE 'Rango de Fechas INCORRECTO'          
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY 'ENTRY':U TO Gn-ClieL.FchIni IN BROWSE {&browse-name}.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* RHC 05.10.04 Historico de lineas de credito */
  IF s-LogTabla THEN DO:
      FIND CURRENT Gn-Clie EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Gn-Clie THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN
          Gn-Clie.FlagAut = "".
      FIND CURRENT Gn-Clie NO-LOCK.
      CREATE LogTabla.
      ASSIGN
        logtabla.codcia = s-codcia
        logtabla.Dia = TODAY
        logtabla.Evento = 'LINEA-CREDITO'
        logtabla.Hora = STRING(TIME, 'HH:MM')
        logtabla.Tabla = 'GN-CLIEL'
        logtabla.Usuario = s-user-id
        logtabla.ValorLlave = STRING(gn-clie.codcli, 'x(11)') + '|' +
                                STRING(gn-clie.nomcli, 'x(50)') + '|' +
                                STRING(gn-clieL.MonLC, '9') + '|' +
                                STRING(gn-clieL.ImpLC, '->>>>>>>>9.99') + '|' +
                                STRING(gn-clie.CndVta, 'x(4)').
      RELEASE LogTabla.
  END.

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida-update.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
  CREATE LogTabla.
  ASSIGN
    logtabla.codcia = s-codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'LINEA-CREDITO-DELETE'
    logtabla.Hora = STRING(TIME, 'HH:MM')
    logtabla.Tabla = 'GN-CLIEL'
    logtabla.Usuario = s-user-id
    logtabla.ValorLlave = STRING(gn-clie.codcli, 'x(11)') + '|' +
                            STRING(gn-clie.nomcli, 'x(50)') + '|' +
                            STRING(gn-clieL.MonLC, '9') + '|' +
                            STRING(gn-clieL.ImpLC, '->>>>>>>>9.99') + '|' +
                            STRING(gn-clie.CndVta, 'x(4)').
  RELEASE LogTabla.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

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
  {src/adm/template/snd-list.i "Gn-ClieL"}

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
  DEFINE VAR wcambio AS DECIMAL.
  DEFINE VAR lvalido AS LOG INIT YES.

  FIND gn-LinUsr WHERE gn-LinUsr.Usuario = S-USER-ID NO-LOCK NO-ERROR.
  FIND FIRST FacCfgGn  WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  wcambio = FacCfgGn.Tpocmb[1].

  IF DECIMAL(gn-cliel.ImpLC:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0 THEN DO:
    MESSAGE 'Ingrese el importe de la línea' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

/*   IF gn-clie.MonLC = 1 THEN DO:                                                                             */
/*    IF DECIMAL(gn-cliel.ImpLC:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > ROUND( gn-LinUsr.MaxDol * wcambio, 2) */
/*    THEN DO:                                                                                                 */
/*       MESSAGE "El Maximo Credito que puede otorgar es S/." ROUND(gn-LinUsr.MaxDol * wcambio, 2)             */
/*               VIEW-AS ALERT-BOX WARNING.                                                                    */
/*       RETURN 'ADM-ERROR'.                                                                                   */
/*    END.                                                                                                     */
/*   END.                                                                                                      */
/*   IF gn-clie.MonLC = 2 THEN DO:                                                                             */
/*    IF DECIMAL(gn-cliel.ImpLC:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > gn-LinUsr.MaxDol                      */
/*    THEN DO:                                                                                                 */
/*       MESSAGE "El Maximo Credito que puede otorgar es" gn-LinUsr.MaxDol                                     */
/*               VIEW-AS ALERT-BOX WARNING.                                                                    */
/*       RETURN 'ADM-ERROR'.                                                                                   */
/*    END.                                                                                                     */
/*   END.                                                                                                      */

  IF DECIMAL(gn-cliel.ImpLC:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > ROUND( gn-LinUsr.MaxDol * wcambio, 2)  
  THEN DO:
     MESSAGE "El Maximo Credito que puede otorgar es S/." ROUND(gn-LinUsr.MaxDol * wcambio, 2)
             VIEW-AS ALERT-BOX WARNING.
     RETURN 'ADM-ERROR'.
  END.
                         
  /*
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
  */
  /*RD01 - Valida Fechas*/

/*   lValido = YES.                                                                              */
/*   IF DATE(Gn-ClieL.FchFin:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <                            */
/*       DATE(Gn-ClieL.FchIni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:                    */
/*       MESSAGE 'uno'.                                                                          */
/*       lvalido = NO.                                                                           */
/*   END.                                                                                        */
/*                                                                                               */
/*                                                                                               */
/*   FOR EACH b-gncliel WHERE b-gncliel.codcia = gn-clie.codcia                                  */
/*       AND b-GnClieL.CodCli = gn-clie.codcli                                                   */
/*       AND ROWID(b-gncliel) <> ROWID(gn-cliel)                                                 */
/*       AND lvalido = YES NO-LOCK:                                                              */
/*                                                                                               */
/*       IF DATE(Gn-ClieL.FchIni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) >= b-gncliel.fchini      */
/*           AND DATE(Gn-ClieL.FchIni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= b-gncliel.fchfin */
/*           THEN DO:                                                                            */
/*           lvalido = NO.                                                                       */
/*           LEAVE.                                                                              */
/*       END.                                                                                    */
/*                                                                                               */
/*       IF DATE(Gn-ClieL.FchFin:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) >= b-gncliel.fchini      */
/*           AND DATE(Gn-ClieL.FchFin:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= b-gncliel.fchfin */
/*           THEN DO:                                                                            */
/*           lvalido = NO.                                                                       */
/*           LEAVE.                                                                              */
/*       END.                                                                                    */
/*                                                                                               */
/*       IF DATE(Gn-ClieL.FchIni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= b-gncliel.fchini      */
/*           AND DATE(Gn-ClieL.FchFin:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) >= b-gncliel.fchfin */
/*           THEN DO:                                                                            */
/*           lvalido = NO.                                                                       */
/*           LEAVE.                                                                              */
/*       END.                                                                                    */
/*                                                                                               */
/*   END.                                                                                        */
/*                                                                                               */
/*   IF NOT lvalido THEN DO:                                                                     */
/*       MESSAGE 'Rango de Fechas INCORRECTO'                                                    */
/*           VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                  */
/*       RETURN 'adm-error'.                                                                     */
/*   END.                                                                                        */


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
FIND gn-LinUsr WHERE gn-LinUsr.Usuario = S-USER-ID NO-LOCK NO-ERROR.
IF NOT AVAILABLE Gn-LinUsr THEN DO:
    MESSAGE 'El usuario NO tiene autorización para modificar la línea de crédito'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

IF Gn-ClieL.FchFin < 10/18/2011 THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

