&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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

DEFINE SHARED VARIABLE S-NROSEM  AS INTEGER.
DEFINE SHARED VARIABLE S-PERIODO AS INTEGER.
DEFINE        VARIABLE S-VALVAR  AS DECIMAL EXTENT 20.
DEFINE        VARIABLE OK        AS LOGICAL.

RUN VERIFICA.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartQuery

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,Navigation-Target

&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-VAR-SEM

/* Definitions for QUERY Query-Main                                     */
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH integral.PL-VAR-SEM ~
      WHERE PL-VAR-SEM.Periodo = s-periodo ~
 AND PL-VAR-SEM.NroSem = s-nrosem NO-LOCK.
&Scoped-define TABLES-IN-QUERY-Query-Main integral.PL-VAR-SEM
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main integral.PL-VAR-SEM


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      integral.PL-VAR-SEM SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartQuery
   Allow: Basic,Query
   Frames: 1
   Add Fields to: NEITHER
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
  CREATE WINDOW q-tables ASSIGN
         HEIGHT             = 1.35
         WIDTH              = 22.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW q-tables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for QUERY Query-Main
     _TblList          = "integral.PL-VAR-SEM"
     _Options          = "NO-LOCK"
     _Where[1]         = "PL-VAR-SEM.Periodo = s-periodo
 AND PL-VAR-SEM.NroSem = s-nrosem"
     _Design-Parent    is WINDOW q-tables @ ( 1.15 , 9.86 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB q-tables 
/* ************************* Included-Libraries *********************** */

{src/adm/method/query.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK q-tables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available q-tables _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI q-tables _DEFAULT-DISABLE
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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records q-tables _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-VAR-SEM"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verifica q-tables 
PROCEDURE verifica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


FIND integral.PL-VAR-SEM WHERE 
                        integral.PL-VAR-SEM.PERIODO = S-PERIODO AND 
                        integral.PL-VAR-SEM.NROSEM  = S-NROSEM 
                        NO-LOCK NO-ERROR.

OK = FALSE.
IF NOT AVAILABLE integral.PL-VAR-SEM
THEN DO:
    FIND LAST integral.PL-VAR-SEM WHERE 
                        integral.PL-VAR-SEM.PERIODO = S-PERIODO AND 
                        integral.PL-VAR-SEM.NROSEM  <= S-NROSEM 
                        NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-VAR-SEM
    THEN ASSIGN S-VALVAR[1] = integral.PL-VAR-SEM.ValVar-SEM[1]
                S-VALVAR[2] = integral.PL-VAR-SEM.ValVar-SEM[2]
                S-VALVAR[3] = integral.PL-VAR-SEM.ValVar-SEM[3]
                S-VALVAR[4] = integral.PL-VAR-SEM.ValVar-SEM[4]
                S-VALVAR[5] = integral.PL-VAR-SEM.ValVar-SEM[5]
                S-VALVAR[6] = integral.PL-VAR-SEM.ValVar-SEM[6]
                S-VALVAR[7] = integral.PL-VAR-SEM.ValVar-SEM[7]
                S-VALVAR[8] = integral.PL-VAR-SEM.ValVar-SEM[8]
                S-VALVAR[9] = integral.PL-VAR-SEM.ValVar-SEM[9]
                S-VALVAR[10] = integral.PL-VAR-SEM.ValVar-SEM[10]
                S-VALVAR[11] = integral.PL-VAR-SEM.ValVar-SEM[11]
                S-VALVAR[12] = integral.PL-VAR-SEM.ValVar-SEM[12]
                S-VALVAR[13] = integral.PL-VAR-SEM.ValVar-SEM[13]
                S-VALVAR[14] = integral.PL-VAR-SEM.ValVar-SEM[14]
                S-VALVAR[15] = integral.PL-VAR-SEM.ValVar-SEM[15]
                S-VALVAR[16] = integral.PL-VAR-SEM.ValVar-SEM[16]
                S-VALVAR[17] = integral.PL-VAR-SEM.ValVar-SEM[17]
                S-VALVAR[18] = integral.PL-VAR-SEM.ValVar-SEM[18]
                S-VALVAR[19] = integral.PL-VAR-SEM.ValVar-SEM[19]
                S-VALVAR[20] = integral.PL-VAR-SEM.ValVar-SEM[20]
                OK =TRUE.

    CREATE integral.PL-VAR-SEM.
    ASSIGN integral.PL-VAR-SEM.PERIODO = S-PERIODO 
           integral.PL-VAR-SEM.NROSEM  = S-NROSEM.

    IF ok
    THEN ASSIGN integral.PL-VAR-SEM.ValVar-SEM[1]  = S-VALVAR[1]
                integral.PL-VAR-SEM.ValVar-SEM[2]  = S-VALVAR[2]
                integral.PL-VAR-SEM.ValVar-SEM[3]  = S-VALVAR[3]
                integral.PL-VAR-SEM.ValVar-SEM[4]  = S-VALVAR[4]
                integral.PL-VAR-SEM.ValVar-SEM[5]  = S-VALVAR[5]
                integral.PL-VAR-SEM.ValVar-SEM[6]  = S-VALVAR[6]
                integral.PL-VAR-SEM.ValVar-SEM[7]  = S-VALVAR[7]
                integral.PL-VAR-SEM.ValVar-SEM[8]  = S-VALVAR[8]
                integral.PL-VAR-SEM.ValVar-SEM[9]  = S-VALVAR[9]
                integral.PL-VAR-SEM.ValVar-SEM[10] = S-VALVAR[10]
                integral.PL-VAR-SEM.ValVar-SEM[11] = S-VALVAR[11]
                integral.PL-VAR-SEM.ValVar-SEM[12] = S-VALVAR[12]
                integral.PL-VAR-SEM.ValVar-SEM[13] = S-VALVAR[13]
                integral.PL-VAR-SEM.ValVar-SEM[14] = S-VALVAR[14]
                integral.PL-VAR-SEM.ValVar-SEM[15] = S-VALVAR[15]
                integral.PL-VAR-SEM.ValVar-SEM[16] = S-VALVAR[16]
                integral.PL-VAR-SEM.ValVar-SEM[17] = S-VALVAR[17]
                integral.PL-VAR-SEM.ValVar-SEM[18] = S-VALVAR[18]
                integral.PL-VAR-SEM.ValVar-SEM[19] = S-VALVAR[19]
                integral.PL-VAR-SEM.ValVar-SEM[20] = S-VALVAR[20].

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


