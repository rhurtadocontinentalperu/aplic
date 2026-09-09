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
&GLOBAL-DEFINE VERSION 1.0
/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
DEFINE VARIABLE db-work       AS CHARACTER NO-UNDO.
DEFINE VARIABLE db-model      AS CHARACTER NO-UNDO.
DEFINE VARIABLE prl-model     AS CHARACTER NO-UNDO.
DEFINE VARIABLE prl-work      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lk            AS CHARACTER NO-UNDO.

DEFINE VARIABLE L-OK  AS LOGICAL .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-CFG-RPT

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table integral.PL-CFG-RPT.CodRep ~
integral.PL-CFG-RPT.DesRep 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table integral.PL-CFG-RPT.CodRep ~
integral.PL-CFG-RPT.DesRep 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CodRep ~{&FP2}CodRep ~{&FP3}~
 ~{&FP1}DesRep ~{&FP2}DesRep ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table integral.PL-CFG-RPT
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table integral.PL-CFG-RPT
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH integral.PL-CFG-RPT ~
      WHERE PL-CFG-RPT.TpoRpt = R-TpoRpt NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table integral.PL-CFG-RPT
&Scoped-define FIRST-TABLE-IN-QUERY-br_table integral.PL-CFG-RPT


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 br_table R-TpoRpt Btn-generar 
&Scoped-Define DISPLAYED-OBJECTS R-TpoRpt 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-generar 
     LABEL "&Generar Reporte" 
     SIZE 15.57 BY .92.

DEFINE VARIABLE R-TpoRpt AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Semana", 1,
"Mes", 2,
"Consolidado", 3
     SIZE 12.43 BY 2.04
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54.29 BY 8.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      integral.PL-CFG-RPT SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      integral.PL-CFG-RPT.CodRep COLUMN-LABEL "        Libreria"
      integral.PL-CFG-RPT.DesRep
  ENABLE
      integral.PL-CFG-RPT.CodRep
      integral.PL-CFG-RPT.DesRep
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 51.57 BY 5.96
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 3.65 COL 2.14
     R-TpoRpt AT ROW 1.35 COL 12.43 NO-LABEL
     Btn-generar AT ROW 2.46 COL 27
     "Reporte:" VIEW-AS TEXT
          SIZE 6.14 BY .46 AT ROW 1.42 COL 5.14
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
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
         HEIGHT             = 8.92
         WIDTH              = 54.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table RECT-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.PL-CFG-RPT"
     _Options          = "NO-LOCK"
     _Where[1]         = "PL-CFG-RPT.TpoRpt = R-TpoRpt"
     _FldNameList[1]   > integral.PL-CFG-RPT.CodRep
"PL-CFG-RPT.CodRep" "        Libreria" ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > integral.PL-CFG-RPT.DesRep
"PL-CFG-RPT.DesRep" ? ? "character" ? ? ? ? ? ? yes ?
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

{src/adm/method/browser.i}

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


&Scoped-define SELF-NAME Btn-generar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-generar B-table-Win
ON CHOOSE OF Btn-generar IN FRAME F-Main /* Generar Reporte */
DO:
    IF NOT AVAILABLE PL-CFG-RPT THEN DO:
        BELL.
        MESSAGE "Debe Seleccionar un Reporte" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        IF CONNECTED("db-work") THEN DISCONNECT db-work.
        GET-KEY-VALUE SECTION "Planillas" KEY "Directorio de programas" VALUE db-model.
        /* Verificamos si el archivo PRL existe */
        prl-model = db-model + "reporte/reports.prl".
        prl-work  = db-model + "reporte/".
        
        GET-KEY-VALUE SECTION "Planillas" KEY "Directorio de programas" VALUE db-model.
        db-model = db-model + "db-work".
        
        CASE PL-CFG-RPT.TpoRpt:
            WHEN 1 THEN prl-work = prl-work + "sem/".
            WHEN 2 THEN prl-work = prl-work + "mes/".
            WHEN 3 THEN prl-work = prl-work + "s-m/".
        END CASE.
        prl-work = prl-work + PL-CFG-RPT.CodRep + ".prl".
        FILE-INFO:FILE-NAME = prl-work.
        IF FILE-INFO:FULL-PATHNAME = ? THEN
            OS-COPY VALUE( prl-model ) VALUE( prl-work ).
        /* CREANDO LA BASE DE DATOS */
        db-work = SESSION:TEMP-DIRECTORY + "db-work.db".
        IF CONNECTED("db-work") THEN DISCONNECT db-work.
        lk = SESSION:TEMP-DIRECTORY + "db-work.lk".
        FILE-INFO:FILE-NAME = lk.
        IF lk = FILE-INFO:FULL-PATHNAME THEN OS-DELETE VALUE(lk).
        CREATE DATABASE db-work FROM db-model REPLACE.
        CONNECT VALUE( db-work ) -1 -ld db-work.
        L-OK = NO.
        RUN pln/w-rpl-2.w( PL-CFG-RPT.CodRep, PL-CFG-RPT.TpoRpt, FALSE, "",OUTPUT L-OK).
        IF CONNECTED("db-work") THEN DISCONNECT db-work.
        IF L-OK THEN 
           RUN pln/w-rpl-3.w( PL-CFG-RPT.CodRep, FALSE, PL-CFG-RPT.TpoRpt, "" ).
           
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
    IF CONNECTED( "db-work") THEN DISCONNECT db-work.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-TpoRpt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-TpoRpt B-table-Win
ON VALUE-CHANGED OF R-TpoRpt IN FRAME F-Main
DO:
    ASSIGN R-TpoRpt.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consistencias B-table-Win 
PROCEDURE consistencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF integral.PL-CFG-RPT.CodRep:SCREEN-VALUE IN BROWSE br_table = "" THEN DO:
        BELL.
        MESSAGE
            "Debe ingresar nombre de Libreria"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    RETURN "".

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
   
    /* Dispatch standard ADM method.                             */
    IF NOT QUERY-OFF-END("{&BROWSE-NAME}") THEN
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
    ELSE DO WITH FRAME F-MAIN:
        CREATE integral.PL-CFG-RPT.
        ASSIGN integral.PL-CFG-RPT.TpoRpt = R-TpoRpt.
        RUN dispatch IN THIS-PROCEDURE ('open-query':U).
        RUN dispatch IN THIS-PROCEDURE ('cancel-record':U).
        RUN dispatch IN THIS-PROCEDURE ('apply-entry':U).
        APPLY "ENTRY":U TO br_table.
    END.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN integral.PL-CFG-RPT.TpoRpt = R-TpoRpt.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH PL-VAR-RPT WHERE
        PL-VAR-RPT.CodRep = PL-CFG-RPT.CodRep AND
        PL-VAR-RPT.TpoRpt = PL-CFG-RPT.TpoRpt:
        DELETE PL-VAR-RPT.
    END.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  RUN consistencias.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "integral.PL-CFG-RPT"}

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

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


