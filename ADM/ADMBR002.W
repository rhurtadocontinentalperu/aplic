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
&Scoped-define EXTERNAL-TABLES Empresas
&Scoped-define FIRST-EXTERNAL-TABLE Empresas


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Empresas.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-peri

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table cb-peri.CodCia cb-peri.Periodo ~
cb-peri.MesCie[1] cb-peri.MesCie[2] cb-peri.MesCie[3] cb-peri.MesCie[4] ~
cb-peri.MesCie[5] cb-peri.MesCie[6] cb-peri.MesCie[7] cb-peri.MesCie[8] ~
cb-peri.MesCie[9] cb-peri.MesCie[10] cb-peri.MesCie[11] cb-peri.MesCie[12] ~
cb-peri.MesCie[13] cb-peri.MesCie[14] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table cb-peri.CodCia ~
cb-peri.Periodo cb-peri.MesCie[1] cb-peri.MesCie[2] cb-peri.MesCie[3] ~
cb-peri.MesCie[4] cb-peri.MesCie[5] cb-peri.MesCie[6] cb-peri.MesCie[7] ~
cb-peri.MesCie[8] cb-peri.MesCie[9] cb-peri.MesCie[10] cb-peri.MesCie[11] ~
cb-peri.MesCie[12] cb-peri.MesCie[13] cb-peri.MesCie[14] 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CodCia ~{&FP2}CodCia ~{&FP3}~
 ~{&FP1}Periodo ~{&FP2}Periodo ~{&FP3}~
 ~{&FP1}MesCie[1] ~{&FP2}MesCie[1] ~{&FP3}~
 ~{&FP1}MesCie[2] ~{&FP2}MesCie[2] ~{&FP3}~
 ~{&FP1}MesCie[3] ~{&FP2}MesCie[3] ~{&FP3}~
 ~{&FP1}MesCie[4] ~{&FP2}MesCie[4] ~{&FP3}~
 ~{&FP1}MesCie[5] ~{&FP2}MesCie[5] ~{&FP3}~
 ~{&FP1}MesCie[6] ~{&FP2}MesCie[6] ~{&FP3}~
 ~{&FP1}MesCie[7] ~{&FP2}MesCie[7] ~{&FP3}~
 ~{&FP1}MesCie[8] ~{&FP2}MesCie[8] ~{&FP3}~
 ~{&FP1}MesCie[9] ~{&FP2}MesCie[9] ~{&FP3}~
 ~{&FP1}MesCie[10] ~{&FP2}MesCie[10] ~{&FP3}~
 ~{&FP1}MesCie[11] ~{&FP2}MesCie[11] ~{&FP3}~
 ~{&FP1}MesCie[12] ~{&FP2}MesCie[12] ~{&FP3}~
 ~{&FP1}MesCie[13] ~{&FP2}MesCie[13] ~{&FP3}~
 ~{&FP1}MesCie[14] ~{&FP2}MesCie[14] ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table cb-peri
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table cb-peri
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH cb-peri WHERE cb-peri.CodCia = Empresas.CodCia NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table cb-peri
&Scoped-define FIRST-TABLE-IN-QUERY-br_table cb-peri


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      cb-peri SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      cb-peri.CodCia COLUMN-LABEL "CodCia"
      cb-peri.Periodo
      cb-peri.MesCie[1] COLUMN-LABEL "Ape"
      cb-peri.MesCie[2] COLUMN-LABEL "Ene"
      cb-peri.MesCie[3] COLUMN-LABEL "Feb"
      cb-peri.MesCie[4] COLUMN-LABEL "Mar"
      cb-peri.MesCie[5] COLUMN-LABEL "Abr"
      cb-peri.MesCie[6] COLUMN-LABEL "May"
      cb-peri.MesCie[7] COLUMN-LABEL "Jun"
      cb-peri.MesCie[8] COLUMN-LABEL "Jul"
      cb-peri.MesCie[9] COLUMN-LABEL "Ago"
      cb-peri.MesCie[10] COLUMN-LABEL "Set"
      cb-peri.MesCie[11] COLUMN-LABEL "Oct"
      cb-peri.MesCie[12] COLUMN-LABEL "Nov"
      cb-peri.MesCie[13] COLUMN-LABEL "Dic"
      cb-peri.MesCie[14] COLUMN-LABEL "Cie"
  ENABLE
      cb-peri.CodCia
      cb-peri.Periodo HELP "Periodo"
      cb-peri.MesCie[1] HELP "Mes Cerrado"
      cb-peri.MesCie[2] HELP "Mes Cerrado"
      cb-peri.MesCie[3] HELP "Mes Cerrado"
      cb-peri.MesCie[4] HELP "Mes Cerrado"
      cb-peri.MesCie[5] HELP "Mes Cerrado"
      cb-peri.MesCie[6] HELP "Mes Cerrado"
      cb-peri.MesCie[7] HELP "Mes Cerrado"
      cb-peri.MesCie[8] HELP "Mes Cerrado"
      cb-peri.MesCie[9] HELP "Mes Cerrado"
      cb-peri.MesCie[10] HELP "Mes Cerrado"
      cb-peri.MesCie[11] HELP "Mes Cerrado"
      cb-peri.MesCie[12] HELP "Mes Cerrado"
      cb-peri.MesCie[13] HELP "Mes Cerrado"
      cb-peri.MesCie[14] HELP "Mes Cerrado"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 57.86 BY 7.81
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.Empresas
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
         HEIGHT             = 7.92
         WIDTH              = 57.86.
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
     _TblList          = "integral.cb-peri WHERE integral.Empresas <external> ..."
     _Options          = "NO-LOCK"
     _JoinCode[1]      = "cb-peri.CodCia = Empresas.CodCia"
     _FldNameList[1]   > integral.cb-peri.CodCia
"cb-peri.CodCia" "CodCia" ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > integral.cb-peri.Periodo
"cb-peri.Periodo" ? ? "integer" ? ? ? ? ? ? yes "Periodo"
     _FldNameList[3]   > integral.cb-peri.MesCie[1]
"cb-peri.MesCie[1]" "Ape" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
     _FldNameList[4]   > integral.cb-peri.MesCie[2]
"cb-peri.MesCie[2]" "Ene" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
     _FldNameList[5]   > integral.cb-peri.MesCie[3]
"cb-peri.MesCie[3]" "Feb" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
     _FldNameList[6]   > integral.cb-peri.MesCie[4]
"cb-peri.MesCie[4]" "Mar" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
     _FldNameList[7]   > integral.cb-peri.MesCie[5]
"cb-peri.MesCie[5]" "Abr" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
     _FldNameList[8]   > integral.cb-peri.MesCie[6]
"cb-peri.MesCie[6]" "May" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
     _FldNameList[9]   > integral.cb-peri.MesCie[7]
"cb-peri.MesCie[7]" "Jun" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
     _FldNameList[10]   > integral.cb-peri.MesCie[8]
"cb-peri.MesCie[8]" "Jul" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
     _FldNameList[11]   > integral.cb-peri.MesCie[9]
"cb-peri.MesCie[9]" "Ago" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
     _FldNameList[12]   > integral.cb-peri.MesCie[10]
"cb-peri.MesCie[10]" "Set" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
     _FldNameList[13]   > integral.cb-peri.MesCie[11]
"cb-peri.MesCie[11]" "Oct" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
     _FldNameList[14]   > integral.cb-peri.MesCie[12]
"cb-peri.MesCie[12]" "Nov" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
     _FldNameList[15]   > integral.cb-peri.MesCie[13]
"cb-peri.MesCie[13]" "Dic" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
     _FldNameList[16]   > integral.cb-peri.MesCie[14]
"cb-peri.MesCie[14]" "Cie" ? "logical" ? ? ? ? ? ? yes "Mes Cerrado"
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
  {src/adm/template/row-list.i "Empresas"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Empresas"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

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
  {src/adm/template/snd-list.i "Empresas"}
  {src/adm/template/snd-list.i "cb-peri"}

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


