&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES INTEGRAL.AS-CHOR
&Scoped-define FIRST-EXTERNAL-TABLE INTEGRAL.AS-CHOR


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR INTEGRAL.AS-CHOR.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES INTEGRAL.AS-DHOR

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table INTEGRAL.AS-DHOR.FchHor ~
INTEGRAL.AS-DHOR.HrIni1 INTEGRAL.AS-DHOR.HrFin1 INTEGRAL.AS-DHOR.HrIni2 ~
INTEGRAL.AS-DHOR.HrFin2 INTEGRAL.AS-DHOR.Tolera INTEGRAL.AS-DHOR.HEIni1 ~
INTEGRAL.AS-DHOR.HEFin1 INTEGRAL.AS-DHOR.HEIni2 INTEGRAL.AS-DHOR.HEFin2 ~
INTEGRAL.AS-DHOR.HEIni3 INTEGRAL.AS-DHOR.HEFin3 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table INTEGRAL.AS-DHOR.FchHor ~
INTEGRAL.AS-DHOR.HrIni1 INTEGRAL.AS-DHOR.HrFin1 INTEGRAL.AS-DHOR.HrIni2 ~
INTEGRAL.AS-DHOR.HrFin2 INTEGRAL.AS-DHOR.Tolera INTEGRAL.AS-DHOR.HEIni1 ~
INTEGRAL.AS-DHOR.HEFin1 INTEGRAL.AS-DHOR.HEIni2 INTEGRAL.AS-DHOR.HEFin2 ~
INTEGRAL.AS-DHOR.HEIni3 INTEGRAL.AS-DHOR.HEFin3 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}FchHor ~{&FP2}FchHor ~{&FP3}~
 ~{&FP1}HrIni1 ~{&FP2}HrIni1 ~{&FP3}~
 ~{&FP1}HrFin1 ~{&FP2}HrFin1 ~{&FP3}~
 ~{&FP1}HrIni2 ~{&FP2}HrIni2 ~{&FP3}~
 ~{&FP1}HrFin2 ~{&FP2}HrFin2 ~{&FP3}~
 ~{&FP1}Tolera ~{&FP2}Tolera ~{&FP3}~
 ~{&FP1}HEIni1 ~{&FP2}HEIni1 ~{&FP3}~
 ~{&FP1}HEFin1 ~{&FP2}HEFin1 ~{&FP3}~
 ~{&FP1}HEIni2 ~{&FP2}HEIni2 ~{&FP3}~
 ~{&FP1}HEFin2 ~{&FP2}HEFin2 ~{&FP3}~
 ~{&FP1}HEIni3 ~{&FP2}HEIni3 ~{&FP3}~
 ~{&FP1}HEFin3 ~{&FP2}HEFin3 ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table INTEGRAL.AS-DHOR
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table INTEGRAL.AS-DHOR
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH INTEGRAL.AS-DHOR OF INTEGRAL.AS-CHOR WHERE ~{&KEY-PHRASE} NO-LOCK ~
    BY INTEGRAL.AS-DHOR.CodHor ~
       BY INTEGRAL.AS-DHOR.FchHor DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table INTEGRAL.AS-DHOR
&Scoped-define FIRST-TABLE-IN-QUERY-br_table INTEGRAL.AS-DHOR


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table FILL-IN-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 

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
DEFINE VARIABLE FILL-IN-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Busqueda" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .81
     BGCOLOR 15  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      INTEGRAL.AS-DHOR SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      INTEGRAL.AS-DHOR.FchHor COLUMN-LABEL "Fecha          !"
      INTEGRAL.AS-DHOR.HrIni1
      INTEGRAL.AS-DHOR.HrFin1
      INTEGRAL.AS-DHOR.HrIni2
      INTEGRAL.AS-DHOR.HrFin2
      INTEGRAL.AS-DHOR.Tolera
      INTEGRAL.AS-DHOR.HEIni1
      INTEGRAL.AS-DHOR.HEFin1
      INTEGRAL.AS-DHOR.HEIni2
      INTEGRAL.AS-DHOR.HEFin2
      INTEGRAL.AS-DHOR.HEIni3
      INTEGRAL.AS-DHOR.HEFin3
  ENABLE
      INTEGRAL.AS-DHOR.FchHor
      INTEGRAL.AS-DHOR.HrIni1
      INTEGRAL.AS-DHOR.HrFin1
      INTEGRAL.AS-DHOR.HrIni2
      INTEGRAL.AS-DHOR.HrFin2
      INTEGRAL.AS-DHOR.Tolera
      INTEGRAL.AS-DHOR.HEIni1
      INTEGRAL.AS-DHOR.HEFin1
      INTEGRAL.AS-DHOR.HEIni2
      INTEGRAL.AS-DHOR.HEFin2
      INTEGRAL.AS-DHOR.HEIni3
      INTEGRAL.AS-DHOR.HEFin3
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 61.57 BY 9.15
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.08 COL 1
     FILL-IN-1 AT ROW 1.15 COL 50.43 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.AS-CHOR
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 10.23
         WIDTH              = 61.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

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
     _TblList          = "INTEGRAL.AS-DHOR OF INTEGRAL.AS-CHOR"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "INTEGRAL.AS-DHOR.CodHor|yes,INTEGRAL.AS-DHOR.FchHor|no"
     _FldNameList[1]   > INTEGRAL.AS-DHOR.FchHor
"AS-DHOR.FchHor" "Fecha          !" ? "date" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > INTEGRAL.AS-DHOR.HrIni1
"AS-DHOR.HrIni1" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[3]   > INTEGRAL.AS-DHOR.HrFin1
"AS-DHOR.HrFin1" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[4]   > INTEGRAL.AS-DHOR.HrIni2
"AS-DHOR.HrIni2" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[5]   > INTEGRAL.AS-DHOR.HrFin2
"AS-DHOR.HrFin2" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[6]   > INTEGRAL.AS-DHOR.Tolera
"AS-DHOR.Tolera" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[7]   > INTEGRAL.AS-DHOR.HEIni1
"AS-DHOR.HEIni1" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[8]   > INTEGRAL.AS-DHOR.HEFin1
"AS-DHOR.HEFin1" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[9]   > INTEGRAL.AS-DHOR.HEIni2
"AS-DHOR.HEIni2" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[10]   > INTEGRAL.AS-DHOR.HEFin2
"AS-DHOR.HEFin2" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[11]   > INTEGRAL.AS-DHOR.HEIni3
"AS-DHOR.HEIni3" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[12]   > INTEGRAL.AS-DHOR.HEFin3
"AS-DHOR.HEFin3" ? ? "character" ? ? ? ? ? ? yes ?
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
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


&Scoped-define SELF-NAME FILL-IN-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-1 B-table-Win
ON LEAVE OF FILL-IN-1 IN FRAME F-Main /* Fecha de Busqueda */
OR RETURN OF FILL-IN-1 DO:
    ASSIGN FILL-IN-1.
    IF FILL-IN-1 NE ? THEN DO:
        FIND FIRST AS-DHOR WHERE AS-DHOR.CodHor = As-CHor.CodHor AND
                                 AS-DHOR.FchHor >= FILL-IN-1
            NO-LOCK NO-ERROR.
        IF NOT AVAIL AS-DHOR THEN
            FIND LAST AS-DHOR NO-LOCK NO-ERROR.
        IF AVAIL AS-DHOR THEN DO:
            REPOSITION {&BROWSE-NAME} TO ROWID ROWID(AS-DHOR).
            APPLY "ENTRY" TO {&BROWSE-NAME}.
        END.    
        SELF:SCREEN-VALUE = ?.        
    END.
   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "INTEGRAL.AS-CHOR"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "INTEGRAL.AS-CHOR"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
   AS-DHOR.CodHor = AS-CHOR.CodHor.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "INTEGRAL.AS-CHOR"}
  {src/adm/template/snd-list.i "INTEGRAL.AS-DHOR"}

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


