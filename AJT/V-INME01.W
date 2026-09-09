&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
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

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES aj-inme
&Scoped-define FIRST-EXTERNAL-TABLE aj-inme


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR aj-inme.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS aj-inme.Periodo aj-inme.Indice[1] ~
aj-inme.Indice[2] aj-inme.Indice[3] aj-inme.Indice[4] aj-inme.Indice[5] ~
aj-inme.Indice[6] aj-inme.Indice[7] aj-inme.Indice[8] aj-inme.Indice[9] ~
aj-inme.Indice[10] aj-inme.Indice[11] aj-inme.Indice[12] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}Periodo ~{&FP2}Periodo ~{&FP3}~
 ~{&FP1}Indice[1] ~{&FP2}Indice[1] ~{&FP3}~
 ~{&FP1}Indice[2] ~{&FP2}Indice[2] ~{&FP3}~
 ~{&FP1}Indice[3] ~{&FP2}Indice[3] ~{&FP3}~
 ~{&FP1}Indice[4] ~{&FP2}Indice[4] ~{&FP3}~
 ~{&FP1}Indice[5] ~{&FP2}Indice[5] ~{&FP3}~
 ~{&FP1}Indice[6] ~{&FP2}Indice[6] ~{&FP3}~
 ~{&FP1}Indice[7] ~{&FP2}Indice[7] ~{&FP3}~
 ~{&FP1}Indice[8] ~{&FP2}Indice[8] ~{&FP3}~
 ~{&FP1}Indice[9] ~{&FP2}Indice[9] ~{&FP3}~
 ~{&FP1}Indice[10] ~{&FP2}Indice[10] ~{&FP3}~
 ~{&FP1}Indice[11] ~{&FP2}Indice[11] ~{&FP3}~
 ~{&FP1}Indice[12] ~{&FP2}Indice[12] ~{&FP3}
&Scoped-define ENABLED-TABLES aj-inme
&Scoped-define FIRST-ENABLED-TABLE aj-inme
&Scoped-Define ENABLED-OBJECTS RECT-2 
&Scoped-Define DISPLAYED-FIELDS aj-inme.Periodo aj-inme.Indice[1] ~
aj-inme.Indice[2] aj-inme.Indice[3] aj-inme.Indice[4] aj-inme.Indice[5] ~
aj-inme.Indice[6] aj-inme.Indice[7] aj-inme.Indice[8] aj-inme.Indice[9] ~
aj-inme.Indice[10] aj-inme.Indice[11] aj-inme.Indice[12] 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59.86 BY 5.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     aj-inme.Periodo AT ROW 1.19 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     aj-inme.Indice[1] AT ROW 2.54 COL 9 COLON-ALIGNED
          LABEL "Enero" FORMAT "zz,zzz,zz9.999999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     aj-inme.Indice[2] AT ROW 3.35 COL 9 COLON-ALIGNED
          LABEL "Febrero" FORMAT "zz,zzz,zz9.999999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     aj-inme.Indice[3] AT ROW 4.15 COL 9 COLON-ALIGNED
          LABEL "Marzo" FORMAT "zz,zzz,zz9.999999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     aj-inme.Indice[4] AT ROW 4.96 COL 9 COLON-ALIGNED
          LABEL "Abril" FORMAT "zz,zzz,zz9.999999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     aj-inme.Indice[5] AT ROW 5.77 COL 9 COLON-ALIGNED
          LABEL "Mayo" FORMAT "zz,zzz,zz9.999999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     aj-inme.Indice[6] AT ROW 6.58 COL 9 COLON-ALIGNED
          LABEL "Junio" FORMAT "zz,zzz,zz9.999999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     aj-inme.Indice[7] AT ROW 2.54 COL 39 COLON-ALIGNED
          LABEL "Julio" FORMAT "zz,zzz,zz9.999999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     aj-inme.Indice[8] AT ROW 3.35 COL 39 COLON-ALIGNED
          LABEL "Agosto" FORMAT "zz,zzz,zz9.999999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     aj-inme.Indice[9] AT ROW 4.19 COL 39 COLON-ALIGNED
          LABEL "Septiembre" FORMAT "zz,zzz,zz9.999999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     aj-inme.Indice[10] AT ROW 5 COL 39 COLON-ALIGNED
          LABEL "Octubre" FORMAT "zz,zzz,zz9.999999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     aj-inme.Indice[11] AT ROW 5.81 COL 39 COLON-ALIGNED
          LABEL "Noviembre" FORMAT "zz,zzz,zz9.999999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     aj-inme.Indice[12] AT ROW 6.62 COL 39 COLON-ALIGNED
          LABEL "Diciembre" FORMAT "zz,zzz,zz9.999999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     RECT-2 AT ROW 2.31 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.aj-inme
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 6.96
         WIDTH              = 60.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN aj-inme.Indice[10] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN aj-inme.Indice[11] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN aj-inme.Indice[12] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN aj-inme.Indice[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN aj-inme.Indice[2] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN aj-inme.Indice[3] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN aj-inme.Indice[4] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN aj-inme.Indice[5] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN aj-inme.Indice[6] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN aj-inme.Indice[7] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN aj-inme.Indice[8] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN aj-inme.Indice[9] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "aj-inme"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "aj-inme"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
 DO WITH FRAME {&FRAME-NAME} :
     AJ-INME.PERIODO:SENSITIVE = TRUE.
     APPLY "ENTRY" TO AJ-INME.PERIODO.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  DO WITH FRAME {&FRAME-NAME} :
     aj-inme.PERIODO:SENSITIVE =  NO.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  DO WITH FRAME {&FRAME-NAME} :
     aj-inme.PERIODO:SENSITIVE =  NO.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  
  DO WITH FRAME {&FRAME-NAME} :
     aj-inme.PERIODO:SENSITIVE =  NO.
  END.


  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "aj-inme"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


