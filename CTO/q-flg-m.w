&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS q-tables 
/*------------------------------------------------------------------------

  File:  

  Description: from QUERY.W - Template For Query objects in the ADM

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

{bin/s-global.i}
{pln/s-global.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartQuery
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,Navigation-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-MAIN
&Scoped-define QUERY-NAME Query-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES PL-PLAN
&Scoped-define FIRST-EXTERNAL-TABLE PL-PLAN


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR PL-PLAN.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PL-FLG-MES PL-PERS

/* Definitions for QUERY Query-Main                                     */
&Scoped-define QUERY-STRING-Query-Main FOR EACH PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.NroMes = s-NroMes ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.SitAct <> "Inactivo" NO-LOCK, ~
      EACH PL-PERS OF PL-FLG-MES NO-LOCK ~
    BY PL-FLG-MES.Proyecto ~
       BY PL-FLG-MES.seccion ~
        BY PL-PERS.patper ~
         BY PL-PERS.matper ~
          BY PL-PERS.nomper
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.NroMes = s-NroMes ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.SitAct <> "Inactivo" NO-LOCK, ~
      EACH PL-PERS OF PL-FLG-MES NO-LOCK ~
    BY PL-FLG-MES.Proyecto ~
       BY PL-FLG-MES.seccion ~
        BY PL-PERS.patper ~
         BY PL-PERS.matper ~
          BY PL-PERS.nomper.
&Scoped-define TABLES-IN-QUERY-Query-Main PL-FLG-MES PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main PL-FLG-MES
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main PL-PERS


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 RECT-18 FILL-IN-codper 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codper 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/b-buscar":U
     LABEL "" 
     SIZE 4 BY .92.

DEFINE VARIABLE FILL-IN-codper AS CHARACTER FORMAT "X(6)":U 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 6.14 BY 2.88.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      PL-FLG-MES, 
      PL-PERS SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-MAIN
     BUTTON-1 AT ROW 1.38 COL 2
     FILL-IN-codper AT ROW 2.69 COL 1.57 NO-LABEL
     RECT-18 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartQuery
   External Tables: integral.PL-PLAN
   Allow: Basic,Query
   Frames: 1
   Add Fields to: NEITHER
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
  CREATE WINDOW q-tables ASSIGN
         HEIGHT             = 2.88
         WIDTH              = 15.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB q-tables 
/* ************************* Included-Libraries *********************** */

{src/adm/method/query.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW q-tables
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-MAIN
   FRAME-NAME Size-to-Fit                                               */
ASSIGN 
       FRAME F-MAIN:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN FILL-IN-codper IN FRAME F-MAIN
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-MAIN
/* Query rebuild information for FRAME F-MAIN
     _Query            is NOT OPENED
*/  /* FRAME F-MAIN */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for QUERY Query-Main
     _TblList          = "integral.PL-FLG-MES,integral.PL-PERS OF integral.PL-FLG-MES"
     _Options          = "NO-LOCK"
     _OrdList          = "integral.PL-FLG-MES.Proyecto|yes,integral.PL-FLG-MES.seccion|yes,integral.PL-PERS.patper|yes,integral.PL-PERS.matper|yes,integral.PL-PERS.nomper|yes"
     _Where[1]         = "PL-FLG-MES.CodCia = s-CodCia
 AND PL-FLG-MES.Periodo = s-Periodo
 AND PL-FLG-MES.NroMes = s-NroMes
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln
 AND PL-FLG-MES.SitAct <> ""Inactivo"""
     _Design-Parent    is WINDOW q-tables @ ( 1.42 , 2.72 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 q-tables
ON CHOOSE OF BUTTON-1 IN FRAME F-MAIN
DO:
    DEFINE VARIABLE reg-act AS ROWID.
    RUN PLN/H-FLG-M.W (PL-PLAN.CodPln, OUTPUT reg-act).
    IF reg-act <> ? THEN DO:
        REPOSITION {&QUERY-NAME} TO ROWID reg-act NO-ERROR.
        RUN dispatch IN THIS-PROCEDURE ('get-next':U).
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codper q-tables
ON ENTRY OF FILL-IN-codper IN FRAME F-MAIN
DO:
    SELF:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codper q-tables
ON RETURN OF FILL-IN-codper IN FRAME F-MAIN
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    IF NOT CAN-FIND( FIRST PL-FLG-MES WHERE
        PL-FLG-MES.CodCia = s-codcia AND
        PL-FLG-MES.Periodo = s-periodo AND
        PL-FLG-MES.codpln = PL-PLAN.codpln AND
        PL-FLG-MES.NroMes = s-nromes AND
        PL-FLG-MES.codper = FILL-IN-codper:SCREEN-VALUE ) THEN DO:
        BELL.
        MESSAGE "C¢digo de personal no registrado" VIEW-AS ALERT-BOX ERROR.
    END.
    ELSE DO:
        FIND PL-FLG-MES WHERE
            PL-FLG-MES.CodCia = s-codcia AND
            PL-FLG-MES.Periodo = s-periodo AND
            PL-FLG-MES.codpln = PL-PLAN.codpln AND
            PL-FLG-MES.NroMes = s-nromes AND
            PL-FLG-MES.codper = FILL-IN-codper:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE PL-FLG-MES THEN DO:
            REPOSITION {&QUERY-NAME} TO ROWID ROWID( PL-FLG-MES ) NO-ERROR.
            RUN dispatch IN THIS-PROCEDURE ('get-next':U).
        END.
        ELSE DO:
            BELL.
            MESSAGE "Registro de personal no encontrado" VIEW-AS ALERT-BOX ERROR.
        END.
    END.
    SELF:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK q-tables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available q-tables  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "PL-PLAN"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "PL-PLAN"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI q-tables  _DEFAULT-DISABLE
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
  HIDE FRAME F-MAIN.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records q-tables  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "PL-PLAN"}
  {src/adm/template/snd-list.i "PL-FLG-MES"}
  {src/adm/template/snd-list.i "PL-PERS"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed q-tables 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/qstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

