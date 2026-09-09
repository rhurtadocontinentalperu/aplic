&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE VAR    I AS INTEGER NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES Almmmatp
&Scoped-define FIRST-EXTERNAL-TABLE Almmmatp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almmmatp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS almmmatp.DtoVolR[1] almmmatp.DtoVolR[2] ~
almmmatp.DtoVolR[3] almmmatp.DtoVolR[4] almmmatp.DtoVolR[5] ~
almmmatp.DtoVolR[6] almmmatp.DtoVolR[7] almmmatp.DtoVolR[8] ~
almmmatp.DtoVolR[9] almmmatp.DtoVolR[10] 
&Scoped-define ENABLED-TABLES almmmatp
&Scoped-define FIRST-ENABLED-TABLE almmmatp
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-13 RECT-14 
&Scoped-Define DISPLAYED-FIELDS almmmatp.codmat almmmatp.UndBas ~
almmmatp.DesMat almmmatp.DtoVolR[1] almmmatp.DtoVolR[2] almmmatp.DtoVolR[3] ~
almmmatp.DtoVolR[4] almmmatp.DtoVolR[5] almmmatp.DtoVolR[6] ~
almmmatp.DtoVolR[7] almmmatp.DtoVolR[8] almmmatp.DtoVolR[9] ~
almmmatp.DtoVolR[10] 
&Scoped-define DISPLAYED-TABLES almmmatp
&Scoped-define FIRST-DISPLAYED-TABLE almmmatp
&Scoped-Define DISPLAYED-OBJECTS F-PRECIO-1 F-PRECIO-11 F-PRECIO-2 ~
F-PRECIO-12 F-PRECIO-3 F-PRECIO-13 F-PRECIO-4 F-PRECIO-14 F-PRECIO-5 ~
F-PRECIO-15 F-PRECIO-6 F-PRECIO-16 F-PRECIO-7 F-PRECIO-17 F-PRECIO-8 ~
F-PRECIO-18 F-PRECIO-9 F-PRECIO-19 F-PRECIO-10 F-PRECIO-20 

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
DEFINE VARIABLE F-PRECIO-1 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-10 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-11 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-12 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-13 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-14 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-15 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-16 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-17 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-18 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-19 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-2 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-20 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-3 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-4 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-5 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-6 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-7 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-8 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-9 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40.86 BY .85.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 9.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.14 BY 11.65.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     almmmatp.codmat AT ROW 1.46 COL 1.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
          BGCOLOR 15 FGCOLOR 1 
     almmmatp.UndBas AT ROW 1.46 COL 18.14 COLON-ALIGNED NO-LABEL FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 1 
     almmmatp.DesMat AT ROW 2.31 COL 1.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40.57 BY .69
          BGCOLOR 15 FGCOLOR 1 
     almmmatp.DtoVolR[1] AT ROW 4.19 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-PRECIO-1 AT ROW 4.19 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-11 AT ROW 4.23 COL 16.57 COLON-ALIGNED NO-LABEL
     almmmatp.DtoVolR[2] AT ROW 5.04 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-PRECIO-2 AT ROW 5.04 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-12 AT ROW 5.08 COL 16.57 COLON-ALIGNED NO-LABEL
     almmmatp.DtoVolR[3] AT ROW 5.85 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-PRECIO-3 AT ROW 5.85 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-13 AT ROW 5.88 COL 16.57 COLON-ALIGNED NO-LABEL
     almmmatp.DtoVolR[4] AT ROW 6.65 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-PRECIO-4 AT ROW 6.65 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-14 AT ROW 6.69 COL 16.57 COLON-ALIGNED NO-LABEL
     almmmatp.DtoVolR[5] AT ROW 7.46 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-PRECIO-5 AT ROW 7.46 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-15 AT ROW 7.5 COL 16.57 COLON-ALIGNED NO-LABEL
     almmmatp.DtoVolR[6] AT ROW 8.27 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-PRECIO-6 AT ROW 8.27 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-16 AT ROW 8.31 COL 16.57 COLON-ALIGNED NO-LABEL
     almmmatp.DtoVolR[7] AT ROW 9.08 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-PRECIO-7 AT ROW 9.08 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-17 AT ROW 9.12 COL 16.57 COLON-ALIGNED NO-LABEL
     almmmatp.DtoVolR[8] AT ROW 9.88 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-PRECIO-8 AT ROW 9.88 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-18 AT ROW 9.92 COL 16.57 COLON-ALIGNED NO-LABEL
     almmmatp.DtoVolR[9] AT ROW 10.69 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-PRECIO-9 AT ROW 10.69 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-19 AT ROW 10.73 COL 16.57 COLON-ALIGNED NO-LABEL
     almmmatp.DtoVolR[10] AT ROW 11.58 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-PRECIO-10 AT ROW 11.58 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-20 AT ROW 11.62 COL 16.57 COLON-ALIGNED NO-LABEL
     "Precio S/." VIEW-AS TEXT
          SIZE 10.86 BY .5 AT ROW 3.27 COL 18.57
     "Precio US$." VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 3.27 COL 31.29
     "Cantidad Minima" VIEW-AS TEXT
          SIZE 11.14 BY .5 AT ROW 3.27 COL 5.14
     RECT-10 AT ROW 3.12 COL 2.72
     RECT-13 AT ROW 3.15 COL 2.86
     RECT-14 AT ROW 1.08 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almmmatp
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
         HEIGHT             = 11.77
         WIDTH              = 44.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
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

/* SETTINGS FOR FILL-IN almmmatp.codmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN almmmatp.DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-11 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-12 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-13 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-14 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-15 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-16 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-17 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-18 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-19 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-20 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-7 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-8 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-9 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN almmmatp.UndBas IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
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
  {src/adm/template/row-list.i "Almmmatp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almmmatp"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FIRST Almmmatg OF Almmmatp NO-LOCK NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almmmatp THEN DO WITH FRAME {&FRAME-NAME}:
     FIND FIRST Almmmatg OF Almmmatp NO-LOCK NO-ERROR.
     IF Almmmatp.MonVta = 1 THEN DO:
        F-PRECIO-1 = IF Almmmatp.DtoVolR[1] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[1] / 100 ) ),4) / Almmmatg.Tpocmb ELSE 0.             
        F-PRECIO-2 = IF Almmmatp.DtoVolR[2] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[2] / 100 ) ),4) / Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-3 = IF Almmmatp.DtoVolR[3] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[3] / 100 ) ),4) / Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-4 = IF Almmmatp.DtoVolR[4] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[4] / 100 ) ),4) / Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-5 = IF Almmmatp.DtoVolR[5] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[5] / 100 ) ),4) / Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-6 = IF Almmmatp.DtoVolR[6] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[6] / 100 ) ),4) / Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-7 = IF Almmmatp.DtoVolR[7] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[7] / 100 ) ),4) / Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-8 = IF Almmmatp.DtoVolR[8] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[8] / 100 ) ),4) / Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-9 = IF Almmmatp.DtoVolR[9] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[9] / 100 ) ),4) / Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-10 = IF Almmmatp.DtoVolR[10] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[10] / 100 ) ),4) / Almmmatg.Tpocmb ELSE 0.

        F-PRECIO-11 = IF Almmmatp.DtoVolR[1] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[1] / 100 ) ),4) ELSE 0.     
        F-PRECIO-12 = IF Almmmatp.DtoVolR[2] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[2] / 100 ) ),4) ELSE 0.
        F-PRECIO-13 = IF Almmmatp.DtoVolR[3] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[3] / 100 ) ),4) ELSE 0.
        F-PRECIO-14 = IF Almmmatp.DtoVolR[4] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[4] / 100 ) ),4) ELSE 0.
        F-PRECIO-15 = IF Almmmatp.DtoVolR[5] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[5] / 100 ) ),4) ELSE 0.
        F-PRECIO-16 = IF Almmmatp.DtoVolR[6] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[6] / 100 ) ),4) ELSE 0.
        F-PRECIO-17 = IF Almmmatp.DtoVolR[7] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[7] / 100 ) ),4) ELSE 0.
        F-PRECIO-18 = IF Almmmatp.DtoVolR[8] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[8] / 100 ) ),4) ELSE 0.
        F-PRECIO-19 = IF Almmmatp.DtoVolR[9] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[9] / 100 ) ),4) ELSE 0.
        F-PRECIO-20 = IF Almmmatp.DtoVolR[10] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[10] / 100 ) ),4) ELSE 0.

     END.
     ELSE DO:
        F-PRECIO-11 = IF Almmmatp.DtoVolR[1] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[1] / 100 ) ),4) * Almmmatg.Tpocmb ELSE 0.             
        F-PRECIO-12 = IF Almmmatp.DtoVolR[2] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[2] / 100 ) ),4) * Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-13 = IF Almmmatp.DtoVolR[3] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[3] / 100 ) ),4) * Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-14 = IF Almmmatp.DtoVolR[4] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[4] / 100 ) ),4) * Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-15 = IF Almmmatp.DtoVolR[5] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[5] / 100 ) ),4) * Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-16 = IF Almmmatp.DtoVolR[6] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[6] / 100 ) ),4) * Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-17 = IF Almmmatp.DtoVolR[7] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[7] / 100 ) ),4) * Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-18 = IF Almmmatp.DtoVolR[8] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[8] / 100 ) ),4) * Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-19 = IF Almmmatp.DtoVolR[9] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[9] / 100 ) ),4) * Almmmatg.Tpocmb ELSE 0.
        F-PRECIO-20 = IF Almmmatp.DtoVolR[10] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[10] / 100 ) ),4) * Almmmatg.Tpocmb ELSE 0.

        F-PRECIO-1 = IF Almmmatp.DtoVolR[1] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[1] / 100 ) ),4) ELSE 0.     
        F-PRECIO-2 = IF Almmmatp.DtoVolR[2] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[2] / 100 ) ),4) ELSE 0.
        F-PRECIO-3 = IF Almmmatp.DtoVolR[3] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[3] / 100 ) ),4) ELSE 0.
        F-PRECIO-4 = IF Almmmatp.DtoVolR[4] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[4] / 100 ) ),4) ELSE 0.
        F-PRECIO-5 = IF Almmmatp.DtoVolR[5] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[5] / 100 ) ),4) ELSE 0.
        F-PRECIO-6 = IF Almmmatp.DtoVolR[6] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[6] / 100 ) ),4) ELSE 0.
        F-PRECIO-7 = IF Almmmatp.DtoVolR[7] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[7] / 100 ) ),4) ELSE 0.
        F-PRECIO-8 = IF Almmmatp.DtoVolR[8] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[8] / 100 ) ),4) ELSE 0.
        F-PRECIO-9 = IF Almmmatp.DtoVolR[9] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[9] / 100 ) ),4) ELSE 0.
        F-PRECIO-10 = IF Almmmatp.DtoVolR[10] <> 0 THEN ROUND(Almmmatp.PreOfi * ( 1 - ( Almmmatp.DtoVolD[10] / 100 ) ),4) ELSE 0.

     
     END.
     DISPLAY F-PRECIO-1
             F-PRECIO-2
             F-PRECIO-3
             F-PRECIO-4 
             F-PRECIO-5
             F-PRECIO-6 
             F-PRECIO-7 
             F-PRECIO-8 
             F-PRECIO-9 
             F-PRECIO-10
             F-PRECIO-11
             F-PRECIO-12
             F-PRECIO-13
             F-PRECIO-14 
             F-PRECIO-15
             F-PRECIO-16 
             F-PRECIO-17 
             F-PRECIO-18 
             F-PRECIO-19 
             F-PRECIO-20.
     
  
  END.
  
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
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
        WHEN "" THEN .
    END CASE.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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
  {src/adm/template/snd-list.i "Almmmatp"}

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

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME} :
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */
   /*
   DO I = 1 TO 10 :
      IF INTEGER(Almmmatp.DtoVolR[I]:SCREEN-VALUE) = 0 THEN NEXT .
      
   
   END.
   */
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

