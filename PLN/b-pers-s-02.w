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
&SCOPED-DEFINE CONDICION ( ~
    PL-FLG-SEM.Codcia = s-codcia AND ~
    PL-FLG-SEM.Periodo = s-periodo AND ~
    PL-FLG-SEM.codpln = PL-PLAN.codpln AND ~
    PL-FLG-SEM.NroSem = s-nrosem )

{bin/s-global.i}
{pln/s-global.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_pl-flg-m

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES INTEGRAL.PL-PLAN
&Scoped-define FIRST-EXTERNAL-TABLE INTEGRAL.PL-PLAN


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR INTEGRAL.PL-PLAN.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES INTEGRAL.PL-FLG-SEM INTEGRAL.PL-PERS

/* Definitions for BROWSE br_pl-flg-m                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-m INTEGRAL.PL-FLG-SEM.codper ~
INTEGRAL.PL-PERS.patper INTEGRAL.PL-PERS.matper INTEGRAL.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-m 
&Scoped-define QUERY-STRING-br_pl-flg-m FOR EACH INTEGRAL.PL-FLG-SEM OF INTEGRAL.PL-PLAN ~
      WHERE PL-FLG-SEM.CodCia = s-codcia AND ~
   PL-FLG-SEM.Periodo = s-periodo AND ~
      PL-FLG-SEM.NROSEM = s-nrosem  NO-LOCK, ~
      EACH INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-SEM NO-LOCK
&Scoped-define OPEN-QUERY-br_pl-flg-m OPEN QUERY br_pl-flg-m FOR EACH INTEGRAL.PL-FLG-SEM OF INTEGRAL.PL-PLAN ~
      WHERE PL-FLG-SEM.CodCia = s-codcia AND ~
   PL-FLG-SEM.Periodo = s-periodo AND ~
      PL-FLG-SEM.NROSEM = s-nrosem  NO-LOCK, ~
      EACH INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-SEM NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-m INTEGRAL.PL-FLG-SEM ~
INTEGRAL.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-m INTEGRAL.PL-FLG-SEM
&Scoped-define SECOND-TABLE-IN-QUERY-br_pl-flg-m INTEGRAL.PL-PERS


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_pl-flg-m}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 COMBO-BOX-1 COMBO-BOX-2 ~
FILL-IN-NOMBRE br_pl-flg-m 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-1 COMBO-BOX-2 FILL-IN-NOMBRE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Código" 
     LABEL "Mostrar ordenado por" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Código","Nombre" 
     DROP-DOWN-LIST
     SIZE 10.57 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Nombres que inicie con" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Nombres que inicie con","Nombres que contenga" 
     DROP-DOWN-LIST
     SIZE 20.43 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-NOMBRE AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .81
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 91 BY 15.96.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_pl-flg-m FOR 
      INTEGRAL.PL-FLG-SEM, 
      INTEGRAL.PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_pl-flg-m
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-flg-m B-table-Win _STRUCTURED
  QUERY br_pl-flg-m NO-LOCK DISPLAY
      INTEGRAL.PL-FLG-SEM.codper FORMAT "X(6)":U
      INTEGRAL.PL-PERS.patper FORMAT "X(40)":U COLUMN-FONT 4 LABEL-FONT 4
      INTEGRAL.PL-PERS.matper FORMAT "X(40)":U COLUMN-FONT 4 LABEL-FONT 4
      INTEGRAL.PL-PERS.nomper FORMAT "X(40)":U COLUMN-FONT 4 LABEL-FONT 4
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 88.57 BY 13.23
         BGCOLOR 15 FGCOLOR 0 FONT 6.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-1 AT ROW 1.19 COL 7.57
     COMBO-BOX-2 AT ROW 2.12 COL 2 NO-LABEL
     FILL-IN-NOMBRE AT ROW 2.15 COL 22.86 NO-LABEL
     br_pl-flg-m AT ROW 3.35 COL 2
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91 BY 15.96
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.PL-PLAN
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
         HEIGHT             = 15.96
         WIDTH              = 91.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* BROWSE-TAB br_pl-flg-m FILL-IN-NOMBRE F-Main */
ASSIGN 
       br_pl-flg-m:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 1.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-1 IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-2 IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-NOMBRE IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-m
/* Query rebuild information for BROWSE br_pl-flg-m
     _TblList          = "INTEGRAL.PL-FLG-SEM OF INTEGRAL.PL-PLAN,INTEGRAL.PL-PERS OF INTEGRAL.PL-FLG-SEM"
     _Options          = "NO-LOCK"
     _Where[1]         = "PL-FLG-SEM.CodCia = s-codcia AND
   PL-FLG-SEM.Periodo = s-periodo AND
      PL-FLG-SEM.NROSEM = s-nrosem "
     _JoinCode[2]      = "PL-FLG-SEM.CodCia = s-codcia AND
   PL-FLG-SEM.Periodo = s-periodo AND
      PL-FLG-SEM.NRO = s-nromes "
     _FldNameList[1]   = INTEGRAL.PL-FLG-SEM.codper
     _FldNameList[2]   > INTEGRAL.PL-PERS.patper
"PL-PERS.patper" ? ? "character" ? ? 4 ? ? 4 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.PL-PERS.matper
"PL-PERS.matper" ? ? "character" ? ? 4 ? ? 4 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.PL-PERS.nomper
"PL-PERS.nomper" ? ? "character" ? ? 4 ? ? 4 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br_pl-flg-m */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_pl-flg-m
&Scoped-define SELF-NAME br_pl-flg-m
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-m B-table-Win
ON ROW-ENTRY OF br_pl-flg-m IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-m B-table-Win
ON ROW-LEAVE OF br_pl-flg-m IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-m B-table-Win
ON VALUE-CHANGED OF br_pl-flg-m IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-1 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-1 IN FRAME F-Main /* Mostrar ordenado por */
DO:
    IF INPUT COMBO-BOX-1 <> COMBO-BOX-1
    THEN RUN OPEN-QUERY.
    ASSIGN COMBO-BOX-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-2 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-2 IN FRAME F-Main
DO:
    IF INPUT COMBO-BOX-2 <> COMBO-BOX-2
    THEN IF FILL-IN-NOMBRE:SCREEN-VALUE <> "" THEN RUN OPEN-QUERY.
    ASSIGN COMBO-BOX-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NOMBRE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NOMBRE B-table-Win
ON LEAVE OF FILL-IN-NOMBRE IN FRAME F-Main
DO:
    IF INPUT FILL-IN-NOMBRE <> FILL-IN-NOMBRE
    THEN RUN OPEN-QUERY.
    ASSIGN FILL-IN-NOMBRE.
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
  {src/adm/template/row-list.i "INTEGRAL.PL-PLAN"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "INTEGRAL.PL-PLAN"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OPEN-QUERY B-table-Win 
PROCEDURE OPEN-QUERY :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:    
        CASE COMBO-BOX-1:SCREEN-VALUE:
            WHEN COMBO-BOX-1:ENTRY(1) THEN RUN OPEN-QUERY-CODIGO.
            WHEN COMBO-BOX-1:ENTRY(2) THEN RUN OPEN-QUERY-NOMBRE.
        END CASE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OPEN-QUERY-CODIGO B-table-Win 
PROCEDURE OPEN-QUERY-CODIGO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

    IF FILL-IN-NOMBRE:SCREEN-VALUE = "" THEN
        OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-SEM WHERE
            {&CONDICION} NO-LOCK,
            EACH PL-PERS OF PL-FLG-SEM NO-LOCK
            BY PL-FLG-SEM.codper.
    ELSE
        IF COMBO-BOX-2:SCREEN-VALUE = COMBO-BOX-2:ENTRY(1) THEN
            OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-SEM WHERE
                {&CONDICION} NO-LOCK,
                EACH PL-PERS OF PL-FLG-SEM NO-LOCK WHERE
                    PL-PERS.patper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE OR
                    PL-PERS.matper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE OR
                    PL-PERS.nomper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE
                BY PL-FLG-SEM.codper.
        ELSE
            OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-SEM WHERE
                {&CONDICION} NO-LOCK,
                EACH PL-PERS OF PL-FLG-SEM NO-LOCK WHERE
                    INDEX( PL-PERS.patper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0 OR
                    INDEX( PL-PERS.matper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0 OR
                    INDEX( PL-PERS.nomper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0
                BY PL-FLG-SEM.codper.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OPEN-QUERY-NOMBRE B-table-Win 
PROCEDURE OPEN-QUERY-NOMBRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

    IF FILL-IN-NOMBRE:SCREEN-VALUE = "" THEN
        OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-SEM WHERE
            {&CONDICION} NO-LOCK,
            EACH PL-PERS OF PL-FLG-SEM NO-LOCK
            BY PL-PERS.patper
            BY PL-PERS.matper
            BY PL-PERS.nomper.
    ELSE
        IF COMBO-BOX-2:SCREEN-VALUE = COMBO-BOX-2:ENTRY(1) THEN
            OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-SEM WHERE
                {&CONDICION} NO-LOCK,
                EACH PL-PERS OF PL-FLG-SEM NO-LOCK WHERE
                    PL-PERS.patper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE OR
                    PL-PERS.matper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE OR
                    PL-PERS.nomper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE
                BY PL-PERS.patper
                BY PL-PERS.matper
                BY PL-PERS.nomper.
        ELSE
            OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-SEM WHERE
                {&CONDICION} NO-LOCK,
                EACH PL-PERS OF PL-FLG-SEM NO-LOCK WHERE
                    INDEX( PL-PERS.patper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0 OR
                    INDEX( PL-PERS.matper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0 OR
                    INDEX( PL-PERS.nomper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0
                BY PL-PERS.patper
                BY PL-PERS.matper
                BY PL-PERS.nomper.
END.

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
  {src/adm/template/snd-list.i "INTEGRAL.PL-PLAN"}
  {src/adm/template/snd-list.i "INTEGRAL.PL-FLG-SEM"}
  {src/adm/template/snd-list.i "INTEGRAL.PL-PERS"}

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

