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
&SCOPED-DEFINE CONDICION ( PL-FLG-SEM.codpln = PL-PLAN.codpln AND PL-FLG-SEM.Codcia = s-codcia AND PL-FLG-SEM.Periodo = s-periodo AND PL-FLG-SEM.NroSem = s-NroSem )

{bin/s-global.i}
{pln/s-global.i}

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
&Scoped-define EXTERNAL-TABLES integral.PL-PLAN
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-PLAN


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-PLAN.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-FLG-SEM integral.PL-PERS

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table integral.PL-FLG-SEM.seccion ~
integral.PL-FLG-SEM.codper integral.PL-PERS.patper integral.PL-PERS.matper ~
integral.PL-PERS.nomper integral.PL-FLG-SEM.cargos integral.PL-FLG-SEM.CTS ~
integral.PL-FLG-SEM.Clase integral.PL-FLG-SEM.Proyecto ~
integral.PL-FLG-SEM.cnpago integral.PL-FLG-SEM.nrodpt ~
integral.PL-FLG-SEM.codafp integral.PL-FLG-SEM.nroafp ~
integral.PL-FLG-SEM.SitAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table integral.PL-FLG-SEM.seccion 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table integral.PL-FLG-SEM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table integral.PL-FLG-SEM
&Scoped-define QUERY-STRING-br_table FOR EACH integral.PL-FLG-SEM WHERE PL-FLG-SEM.codpln = PL-PLAN.codpln ~
      AND PL-FLG-SEM.CodCia = s-codcia AND ~
   PL-FLG-SEM.Periodo = s-periodo AND ~
      PL-FLG-SEM.NroSem = s-nromes  NO-LOCK, ~
      EACH integral.PL-PERS WHERE PL-PERS.codper = PL-FLG-SEM.codper NO-LOCK ~
    BY PL-PERS.patper ~
       BY PL-PERS.matper ~
        BY PL-PERS.nomper
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH integral.PL-FLG-SEM WHERE PL-FLG-SEM.codpln = PL-PLAN.codpln ~
      AND PL-FLG-SEM.CodCia = s-codcia AND ~
   PL-FLG-SEM.Periodo = s-periodo AND ~
      PL-FLG-SEM.NroSem = s-nromes  NO-LOCK, ~
      EACH integral.PL-PERS WHERE PL-PERS.codper = PL-FLG-SEM.codper NO-LOCK ~
    BY PL-PERS.patper ~
       BY PL-PERS.matper ~
        BY PL-PERS.nomper.
&Scoped-define TABLES-IN-QUERY-br_table integral.PL-FLG-SEM ~
integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_table integral.PL-FLG-SEM
&Scoped-define SECOND-TABLE-IN-QUERY-br_table integral.PL-PERS


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 F-Codper F-DesPer br_table 
&Scoped-Define DISPLAYED-OBJECTS F-Codper F-DesPer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-Codper AS CHARACTER FORMAT "X(256)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesPer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Apellido" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 7.85.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      integral.PL-FLG-SEM, 
      integral.PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      integral.PL-FLG-SEM.seccion FORMAT "X(25)":U
      integral.PL-FLG-SEM.codper FORMAT "X(7)":U
      integral.PL-PERS.patper FORMAT "X(40)":U
      integral.PL-PERS.matper FORMAT "X(40)":U
      integral.PL-PERS.nomper FORMAT "X(40)":U
      integral.PL-FLG-SEM.cargos FORMAT "X(25)":U
      integral.PL-FLG-SEM.CTS FORMAT "x(40)":U
      integral.PL-FLG-SEM.Clase FORMAT "x(30)":U
      integral.PL-FLG-SEM.Proyecto FORMAT "x(40)":U
      integral.PL-FLG-SEM.cnpago FORMAT "X(25)":U
      integral.PL-FLG-SEM.nrodpt FORMAT "X(20)":U
      integral.PL-FLG-SEM.codafp FORMAT "99":U
      integral.PL-FLG-SEM.nroafp FORMAT "X(15)":U
      integral.PL-FLG-SEM.SitAct FORMAT "X(20)":U
  ENABLE
      integral.PL-FLG-SEM.seccion
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 71 BY 6.62
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Codper AT ROW 1.31 COL 5.72 COLON-ALIGNED
     F-DesPer AT ROW 1.31 COL 23 COLON-ALIGNED
     br_table AT ROW 2.19 COL 1
     RECT-3 AT ROW 1.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.PL-PLAN
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
         HEIGHT             = 7.96
         WIDTH              = 71.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table F-DesPer F-Main */
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
     _TblList          = "integral.PL-FLG-SEM WHERE integral.PL-PLAN ...,integral.PL-PERS WHERE integral.PL-FLG-SEM ..."
     _Options          = "NO-LOCK"
     _OrdList          = "integral.PL-PERS.patper|yes,integral.PL-PERS.matper|yes,integral.PL-PERS.nomper|yes"
     _JoinCode[1]      = "PL-FLG-SEM.codpln = PL-PLAN.codpln"
     _Where[1]         = "PL-FLG-SEM.CodCia = s-codcia AND
   PL-FLG-SEM.Periodo = s-periodo AND
      PL-FLG-SEM.NroSem = s-nromes "
     _JoinCode[2]      = "PL-PERS.codper = PL-FLG-SEM.codper"
     _FldNameList[1]   > integral.PL-FLG-SEM.seccion
"PL-FLG-SEM.seccion" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.PL-FLG-SEM.codper
"PL-FLG-SEM.codper" ? "X(7)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = integral.PL-PERS.patper
     _FldNameList[4]   = integral.PL-PERS.matper
     _FldNameList[5]   = integral.PL-PERS.nomper
     _FldNameList[6]   = integral.PL-FLG-SEM.cargos
     _FldNameList[7]   = integral.PL-FLG-SEM.CTS
     _FldNameList[8]   = integral.PL-FLG-SEM.Clase
     _FldNameList[9]   = integral.PL-FLG-SEM.Proyecto
     _FldNameList[10]   = integral.PL-FLG-SEM.cnpago
     _FldNameList[11]   = integral.PL-FLG-SEM.nrodpt
     _FldNameList[12]   = integral.PL-FLG-SEM.codafp
     _FldNameList[13]   = integral.PL-FLG-SEM.nroafp
     _FldNameList[14]   = integral.PL-FLG-SEM.SitAct
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
ON END-SEARCH OF br_table IN FRAME F-Main
DO:
    APPLY "VALUE-CHANGED" TO {&BROWSE-NAME}.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  RETURN NO-APPLY.
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


&Scoped-define SELF-NAME F-Codper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Codper B-table-Win
ON LEAVE OF F-Codper IN FRAME F-Main /* Codigo */
OR RETURN OF F-CodPer DO:
    ASSIGN F-CodPer.
    IF F-CodPer = "" THEN RETURN.
    IF LENGTH(F-CodPer) < 6 THEN
        F-CodPer = FILL("0", 6 - LENGTH(F-CodPer)) + F-CodPer.
    FIND FIRST PL-FLG-SEM WHERE
        PL-FLG-SEM.CodCia = s-codcia AND
        PL-FLG-SEM.Periodo = s-periodo AND
        PL-FLG-SEM.codpln = PL-PLAN.codpln AND
        PL-FLG-SEM.NroSem = s-nrosem AND
        PL-FLG-SEM.CodPer = F-CodPer
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-FLG-SEM THEN DO:
        BELL.
        MESSAGE "Registro no encontrado" VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = "".
        RETURN.
    END.
    REPOSITION {&BROWSE-NAME} TO ROWID ROWID(PL-FLG-SEM) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE
            "Registro no se encuentra en el filtro actual" SKIP
            "       Deshacer la actual selección ?       "
            VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO TITLE "Pregunta"
            UPDATE answ AS LOGICAL.
        IF answ THEN DO:
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
            REPOSITION {&BROWSE-NAME} TO ROWID ROWID(PL-FLG-SEM) NO-ERROR.
        END.
    END.
    APPLY "VALUE-CHANGED":U TO br_table.
    ASSIGN SELF:SCREEN-VALUE = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DesPer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DesPer B-table-Win
ON LEAVE OF F-DesPer IN FRAME F-Main /* Apellido */
DO:
    IF INPUT F-DesPer = "" THEN RETURN.
    FIND LAST PL-PERS WHERE
        PL-PERS.PatPer BEGINS INPUT F-DesPer
        NO-LOCK NO-ERROR.
    IF AVAILABLE PL-PERS THEN DO:
        FIND FIRST PL-FLG-SEM WHERE
            PL-FLG-SEM.codpln = PL-PLAN.codpln AND
            PL-FLG-SEM.CodCia = s-codcia AND
            PL-FLG-SEM.Periodo = s-periodo AND
            PL-FLG-SEM.NroSem = s-nrosem AND
            PL-FLG-SEM.CodPer = PL-PERS.CodPer
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE PL-FLG-SEM THEN DO:
            BELL.
            MESSAGE "Registro no encontrado" VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = "".
            RETURN.
        END.
        REPOSITION {&BROWSE-NAME} TO ROWID ROWID(PL-FLG-SEM) NO-ERROR.
    END.
    ELSE DO:
        BELL.
        MESSAGE "No existe personal con ese apellido paterno" VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = "".
        RETURN.
    END.
    ASSIGN SELF:SCREEN-VALUE = "".

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
  {src/adm/template/row-list.i "integral.PL-PLAN"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-PLAN"}

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
  {src/adm/template/snd-list.i "integral.PL-PLAN"}
  {src/adm/template/snd-list.i "integral.PL-FLG-SEM"}
  {src/adm/template/snd-list.i "integral.PL-PERS"}

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

