&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES LG-CFGCOM
&Scoped-define FIRST-EXTERNAL-TABLE LG-CFGCOM


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LG-CFGCOM.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS LG-CFGCOM.VentFecI LG-CFGCOM.CrecFecI[1] ~
LG-CFGCOM.CrecFecI[2] LG-CFGCOM.DiaRep LG-CFGCOM.Division LG-CFGCOM.CodFam ~
LG-CFGCOM.VentFecF LG-CFGCOM.CrecFecF[1] LG-CFGCOM.CrecFecF[2] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}VentFecI ~{&FP2}VentFecI ~{&FP3}~
 ~{&FP1}CrecFecI[1] ~{&FP2}CrecFecI[1] ~{&FP3}~
 ~{&FP1}CrecFecI[2] ~{&FP2}CrecFecI[2] ~{&FP3}~
 ~{&FP1}DiaRep ~{&FP2}DiaRep ~{&FP3}~
 ~{&FP1}Division ~{&FP2}Division ~{&FP3}~
 ~{&FP1}CodFam ~{&FP2}CodFam ~{&FP3}~
 ~{&FP1}VentFecF ~{&FP2}VentFecF ~{&FP3}~
 ~{&FP1}CrecFecF[1] ~{&FP2}CrecFecF[1] ~{&FP3}~
 ~{&FP1}CrecFecF[2] ~{&FP2}CrecFecF[2] ~{&FP3}
&Scoped-define ENABLED-TABLES LG-CFGCOM
&Scoped-define FIRST-ENABLED-TABLE LG-CFGCOM
&Scoped-Define ENABLED-OBJECTS RECT-28 RECT-29 RECT-27 
&Scoped-Define DISPLAYED-FIELDS LG-CFGCOM.VentFecI LG-CFGCOM.CrecFecI[1] ~
LG-CFGCOM.CrecFecI[2] LG-CFGCOM.DiaRep LG-CFGCOM.Division LG-CFGCOM.CodFam ~
LG-CFGCOM.VentFecF LG-CFGCOM.CrecFecF[1] LG-CFGCOM.CrecFecF[2] 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 55 BY 3.15.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 31.43 BY 3.85.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62.72 BY 2.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     LG-CFGCOM.VentFecI AT ROW 1.96 COL 14.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     LG-CFGCOM.CrecFecI[1] AT ROW 2.96 COL 14.57 COLON-ALIGNED
          LABEL "" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     LG-CFGCOM.CrecFecI[2] AT ROW 3.96 COL 14.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     LG-CFGCOM.DiaRep AT ROW 5.12 COL 14.57 COLON-ALIGNED
          LABEL "Dias Reposicion" FORMAT ">>9"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .69
     LG-CFGCOM.Division AT ROW 5.96 COL 14.57 COLON-ALIGNED
          LABEL "Divisiones Evaluadas" FORMAT "X(45)"
          VIEW-AS FILL-IN 
          SIZE 46.43 BY .69
     LG-CFGCOM.CodFam AT ROW 6.77 COL 14.72 COLON-ALIGNED
          LABEL "Familias" FORMAT "X(50)"
          VIEW-AS FILL-IN 
          SIZE 46 BY .69
     LG-CFGCOM.VentFecF AT ROW 1.96 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     LG-CFGCOM.CrecFecF[1] AT ROW 2.96 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     LG-CFGCOM.CrecFecF[2] AT ROW 3.96 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     "Periodo 1" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.96 COL 47.86
     "Crecimiento" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.08 COL 7.14
     "Ventas (unidades)" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 2.04 COL 2
     RECT-28 AT ROW 1.08 COL 15.57
     RECT-29 AT ROW 5.04 COL 1.72
     RECT-27 AT ROW 1.77 COL 1.57
     "Hasta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.31 COL 33.86
     "Desde" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.27 COL 20.72
     "Periodo 2" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 4.08 COL 47.72
     "Periodo 1" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.04 COL 47.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.LG-CFGCOM
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
         HEIGHT             = 7
         WIDTH              = 64.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN LG-CFGCOM.CodFam IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LG-CFGCOM.CrecFecI[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LG-CFGCOM.DiaRep IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LG-CFGCOM.Division IN FRAME F-Main
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
  {src/adm/template/row-list.i "LG-CFGCOM"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "LG-CFGCOM"}

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
  {src/adm/template/snd-list.i "LG-CFGCOM"}

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


