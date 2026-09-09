&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

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

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-AFPS
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-AFPS


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-AFPS.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS INTEGRAL.PL-AFPS.codafp ~
INTEGRAL.PL-AFPS.desafp INTEGRAL.PL-AFPS.Comision-Porcentual-AFP ~
INTEGRAL.PL-AFPS.Seguro-Invalidez-AFP INTEGRAL.PL-AFPS.Comision-Fija-AFP ~
INTEGRAL.PL-AFPS.Fondo-AFP INTEGRAL.PL-AFPS.banco ~
INTEGRAL.PL-AFPS.nroctacte-afp INTEGRAL.PL-AFPS.nroctacte-fondo 
&Scoped-define ENABLED-TABLES INTEGRAL.PL-AFPS
&Scoped-define FIRST-ENABLED-TABLE INTEGRAL.PL-AFPS
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 
&Scoped-Define DISPLAYED-FIELDS INTEGRAL.PL-AFPS.codafp ~
INTEGRAL.PL-AFPS.desafp INTEGRAL.PL-AFPS.Comision-Porcentual-AFP ~
INTEGRAL.PL-AFPS.Seguro-Invalidez-AFP INTEGRAL.PL-AFPS.Comision-Fija-AFP ~
INTEGRAL.PL-AFPS.Fondo-AFP INTEGRAL.PL-AFPS.banco ~
INTEGRAL.PL-AFPS.nroctacte-afp INTEGRAL.PL-AFPS.nroctacte-fondo 
&Scoped-define DISPLAYED-TABLES INTEGRAL.PL-AFPS
&Scoped-define FIRST-DISPLAYED-TABLE INTEGRAL.PL-AFPS


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58.43 BY 6.27.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58.43 BY .08.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58.43 BY .08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     INTEGRAL.PL-AFPS.codafp AT ROW 1.31 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.29 BY .81
     INTEGRAL.PL-AFPS.desafp AT ROW 2.12 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.72 BY .81
     INTEGRAL.PL-AFPS.Comision-Porcentual-AFP AT ROW 3.31 COL 20 COLON-ALIGNED
          LABEL "%Comisión PORCENTUAL"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     INTEGRAL.PL-AFPS.Seguro-Invalidez-AFP AT ROW 3.31 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     INTEGRAL.PL-AFPS.Comision-Fija-AFP AT ROW 4.08 COL 20 COLON-ALIGNED
          LABEL "%Comisión MIXTA" FORMAT "ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     INTEGRAL.PL-AFPS.Fondo-AFP AT ROW 4.12 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     INTEGRAL.PL-AFPS.banco AT ROW 5.35 COL 14.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40 BY .81
     INTEGRAL.PL-AFPS.nroctacte-afp AT ROW 6.15 COL 14.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
     INTEGRAL.PL-AFPS.nroctacte-fondo AT ROW 6.15 COL 42.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 3.08 COL 1
     RECT-3 AT ROW 5.12 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.PL-AFPS
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 8.73
         WIDTH              = 64.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN INTEGRAL.PL-AFPS.Comision-Fija-AFP IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-AFPS.Comision-Porcentual-AFP IN FRAME F-Main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "integral.PL-AFPS"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-AFPS"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-AFPS"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

