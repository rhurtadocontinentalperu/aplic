&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-VtaListaMinGn NO-UNDO LIKE VtaListaMinGn
       FIELD ttLogDate LIKE LogTransactions.LogDate
       FIELD ttEvent   LIKE LogTransactions.Event
       FIELD ttUsuario LIKE LogTransactions.Usuario
       INDEX Llave01 CodCia CodMat ttLogDate.
DEFINE TEMP-TABLE tt-VtaListaMinGn NO-UNDO LIKE VtaListaMinGn
       INDEX Llave01 CodCia.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS SmartBrowser 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEF VAR xtLogDate LIKE logtransactions.logdate.
DEF VAR xtEvent LIKE logtransactions.event.
DEF VAR xtUsuario LIKE logtransactions.Usuario.

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

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-VtaListaMinGn

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table t-VtaListaMinGn.codmat ~
t-vtalistamingn.ttlogdate @ xtLogDate t-vtalistamingn.ttevent @ xtEvent ~
t-vtalistamingn.ttusuario @ xtUsuario t-VtaListaMinGn.PreOfi ~
t-VtaListaMinGn.Chr__01 t-VtaListaMinGn.DtoVolD[1] ~
t-VtaListaMinGn.DtoVolD[2] t-VtaListaMinGn.DtoVolD[3] ~
t-VtaListaMinGn.DtoVolD[4] t-VtaListaMinGn.DtoVolD[5] ~
t-VtaListaMinGn.DtoVolD[6] t-VtaListaMinGn.DtoVolD[7] ~
t-VtaListaMinGn.DtoVolD[8] t-VtaListaMinGn.DtoVolD[9] ~
t-VtaListaMinGn.DtoVolD[10] t-VtaListaMinGn.DtoVolR[1] ~
t-VtaListaMinGn.DtoVolR[2] t-VtaListaMinGn.DtoVolR[3] ~
t-VtaListaMinGn.DtoVolR[4] t-VtaListaMinGn.DtoVolR[5] ~
t-VtaListaMinGn.DtoVolR[6] t-VtaListaMinGn.DtoVolR[7] ~
t-VtaListaMinGn.DtoVolR[8] t-VtaListaMinGn.DtoVolR[9] ~
t-VtaListaMinGn.DtoVolR[10] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH t-VtaListaMinGn WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-VtaListaMinGn WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table t-VtaListaMinGn
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-VtaListaMinGn


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" SmartBrowser _INLINE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" SmartBrowser _INLINE
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
      t-VtaListaMinGn SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table SmartBrowser _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      t-VtaListaMinGn.codmat FORMAT "X(6)":U
      t-vtalistamingn.ttlogdate @ xtLogDate COLUMN-LABEL "Fecha" FORMAT "99/99/9999 HH:MM:SS":U
      t-vtalistamingn.ttevent @ xtEvent COLUMN-LABEL "Evento" FORMAT "x(8)":U
      t-vtalistamingn.ttusuario @ xtUsuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
      t-VtaListaMinGn.PreOfi FORMAT ">,>>>,>>9.9999":U
      t-VtaListaMinGn.Chr__01 COLUMN-LABEL "Unidad" FORMAT "X(8)":U
      t-VtaListaMinGn.DtoVolD[1] FORMAT "->,>>9.999999":U
      t-VtaListaMinGn.DtoVolD[2] FORMAT "->,>>9.999999":U
      t-VtaListaMinGn.DtoVolD[3] FORMAT "->,>>9.999999":U
      t-VtaListaMinGn.DtoVolD[4] FORMAT "->,>>9.999999":U
      t-VtaListaMinGn.DtoVolD[5] FORMAT "->,>>9.999999":U
      t-VtaListaMinGn.DtoVolD[6] FORMAT "->,>>9.999999":U
      t-VtaListaMinGn.DtoVolD[7] FORMAT "->,>>9.999999":U
      t-VtaListaMinGn.DtoVolD[8] FORMAT "->,>>9.999999":U
      t-VtaListaMinGn.DtoVolD[9] FORMAT "->,>>9.999999":U
      t-VtaListaMinGn.DtoVolD[10] FORMAT "->,>>9.999999":U
      t-VtaListaMinGn.DtoVolR[1] FORMAT "->>>,>>>,>>9":U
      t-VtaListaMinGn.DtoVolR[2] FORMAT "->>>,>>>,>>9":U
      t-VtaListaMinGn.DtoVolR[3] FORMAT "->>>,>>>,>>9":U
      t-VtaListaMinGn.DtoVolR[4] FORMAT "->>>,>>>,>>9":U
      t-VtaListaMinGn.DtoVolR[5] FORMAT "->>>,>>>,>>9":U
      t-VtaListaMinGn.DtoVolR[6] FORMAT "->>>,>>>,>>9":U
      t-VtaListaMinGn.DtoVolR[7] FORMAT "->>>,>>>,>>9":U
      t-VtaListaMinGn.DtoVolR[8] FORMAT "->>>,>>>,>>9":U
      t-VtaListaMinGn.DtoVolR[9] FORMAT "->>>,>>>,>>9":U
      t-VtaListaMinGn.DtoVolR[10] FORMAT "->>>,>>>,>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 139 BY 22.88
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: t-VtaListaMinGn T "?" NO-UNDO INTEGRAL VtaListaMinGn
      ADDITIONAL-FIELDS:
          FIELD ttLogDate LIKE LogTransactions.LogDate
          FIELD ttEvent   LIKE LogTransactions.Event
          FIELD ttUsuario LIKE LogTransactions.Usuario
          INDEX Llave01 CodCia CodMat ttLogDate
      END-FIELDS.
      TABLE: tt-VtaListaMinGn T "?" NO-UNDO INTEGRAL VtaListaMinGn
      ADDITIONAL-FIELDS:
          INDEX Llave01 CodCia
      END-FIELDS.
   END-TABLES.
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
  CREATE WINDOW SmartBrowser ASSIGN
         HEIGHT             = 22.88
         WIDTH              = 140.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB SmartBrowser 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW SmartBrowser
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.t-VtaListaMinGn"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   = Temp-Tables.t-VtaListaMinGn.codmat
     _FldNameList[2]   > "_<CALC>"
"t-vtalistamingn.ttlogdate @ xtLogDate" "Fecha" "99/99/9999 HH:MM:SS" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"t-vtalistamingn.ttevent @ xtEvent" "Evento" "x(8)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"t-vtalistamingn.ttusuario @ xtUsuario" "Usuario" "x(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.t-VtaListaMinGn.PreOfi
     _FldNameList[6]   > Temp-Tables.t-VtaListaMinGn.Chr__01
"t-VtaListaMinGn.Chr__01" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.t-VtaListaMinGn.DtoVolD[1]
     _FldNameList[8]   = Temp-Tables.t-VtaListaMinGn.DtoVolD[2]
     _FldNameList[9]   = Temp-Tables.t-VtaListaMinGn.DtoVolD[3]
     _FldNameList[10]   = Temp-Tables.t-VtaListaMinGn.DtoVolD[4]
     _FldNameList[11]   = Temp-Tables.t-VtaListaMinGn.DtoVolD[5]
     _FldNameList[12]   = Temp-Tables.t-VtaListaMinGn.DtoVolD[6]
     _FldNameList[13]   = Temp-Tables.t-VtaListaMinGn.DtoVolD[7]
     _FldNameList[14]   = Temp-Tables.t-VtaListaMinGn.DtoVolD[8]
     _FldNameList[15]   = Temp-Tables.t-VtaListaMinGn.DtoVolD[9]
     _FldNameList[16]   = Temp-Tables.t-VtaListaMinGn.DtoVolD[10]
     _FldNameList[17]   = Temp-Tables.t-VtaListaMinGn.DtoVolR[1]
     _FldNameList[18]   = Temp-Tables.t-VtaListaMinGn.DtoVolR[2]
     _FldNameList[19]   = Temp-Tables.t-VtaListaMinGn.DtoVolR[3]
     _FldNameList[20]   = Temp-Tables.t-VtaListaMinGn.DtoVolR[4]
     _FldNameList[21]   = Temp-Tables.t-VtaListaMinGn.DtoVolR[5]
     _FldNameList[22]   = Temp-Tables.t-VtaListaMinGn.DtoVolR[6]
     _FldNameList[23]   = Temp-Tables.t-VtaListaMinGn.DtoVolR[7]
     _FldNameList[24]   = Temp-Tables.t-VtaListaMinGn.DtoVolR[8]
     _FldNameList[25]   = Temp-Tables.t-VtaListaMinGn.DtoVolR[9]
     _FldNameList[26]   = Temp-Tables.t-VtaListaMinGn.DtoVolR[10]
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table SmartBrowser
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table SmartBrowser
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table SmartBrowser
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK SmartBrowser 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available SmartBrowser  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal SmartBrowser 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pTabla AS CHAR.
DEF INPUT PARAMETER pLogDate-1 AS DATE.
DEF INPUT PARAMETER pLogdate-2 AS DATE.


EMPTY TEMP-TABLE t-vtalistamingn.
EMPTY TEMP-TABLE tt-vtalistamingn.
FOR EACH logtransactions NO-LOCK WHERE
    logtransactions.tablename = pTabla AND
    DATE(logtransactions.logdate) >= pLogDate-1 AND 
    DATE(logtransactions.logdate) <= pLogDate-2:
    CREATE tt-vtalistamingn.
    RAW-TRANSFER logtransactions.datarecord TO tt-vtalistamingn.
    CREATE t-vtalistamingn.
    BUFFER-COPY tt-vtalistamingn TO t-vtalistamingn
    ASSIGN
        t-vtalistamingn.ttlogdate = logtransactions.logdate
        t-vtalistamingn.ttevent = logtransactions.event
        t-vtalistamingn.ttusuario = logtransactions.Usuario.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI SmartBrowser  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca SmartBrowser 
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record SmartBrowser 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros SmartBrowser 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros SmartBrowser 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records SmartBrowser  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "t-VtaListaMinGn"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed SmartBrowser 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida SmartBrowser 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update SmartBrowser 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

