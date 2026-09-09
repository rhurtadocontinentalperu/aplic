&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          reporte          PROGRESS
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
&Scoped-define EXTERNAL-TABLES EvtArti
&Scoped-define FIRST-EXTERNAL-TABLE EvtArti


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR EvtArti.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS EvtArti.Canxdia[1] EvtArti.Canxdia[2] ~
EvtArti.Canxdia[3] EvtArti.Canxdia[4] EvtArti.Canxdia[5] EvtArti.Canxdia[6] ~
EvtArti.Canxdia[7] EvtArti.Canxdia[8] EvtArti.Canxdia[9] ~
EvtArti.Canxdia[10] EvtArti.Canxdia[11] EvtArti.Canxdia[12] ~
EvtArti.Canxdia[13] EvtArti.Canxdia[14] EvtArti.Canxdia[15] ~
EvtArti.Canxdia[16] EvtArti.Canxdia[17] EvtArti.Canxdia[18] ~
EvtArti.Canxdia[19] EvtArti.Canxdia[20] EvtArti.Canxdia[21] ~
EvtArti.Canxdia[22] EvtArti.Canxdia[23] EvtArti.Canxdia[24] ~
EvtArti.Canxdia[25] EvtArti.Canxdia[26] EvtArti.Canxdia[27] ~
EvtArti.Canxdia[28] EvtArti.Canxdia[29] EvtArti.Canxdia[30] ~
EvtArti.Canxdia[31] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}Canxdia[1] ~{&FP2}Canxdia[1] ~{&FP3}~
 ~{&FP1}Canxdia[2] ~{&FP2}Canxdia[2] ~{&FP3}~
 ~{&FP1}Canxdia[3] ~{&FP2}Canxdia[3] ~{&FP3}~
 ~{&FP1}Canxdia[4] ~{&FP2}Canxdia[4] ~{&FP3}~
 ~{&FP1}Canxdia[5] ~{&FP2}Canxdia[5] ~{&FP3}~
 ~{&FP1}Canxdia[6] ~{&FP2}Canxdia[6] ~{&FP3}~
 ~{&FP1}Canxdia[7] ~{&FP2}Canxdia[7] ~{&FP3}~
 ~{&FP1}Canxdia[8] ~{&FP2}Canxdia[8] ~{&FP3}~
 ~{&FP1}Canxdia[9] ~{&FP2}Canxdia[9] ~{&FP3}~
 ~{&FP1}Canxdia[10] ~{&FP2}Canxdia[10] ~{&FP3}~
 ~{&FP1}Canxdia[11] ~{&FP2}Canxdia[11] ~{&FP3}~
 ~{&FP1}Canxdia[12] ~{&FP2}Canxdia[12] ~{&FP3}~
 ~{&FP1}Canxdia[13] ~{&FP2}Canxdia[13] ~{&FP3}~
 ~{&FP1}Canxdia[14] ~{&FP2}Canxdia[14] ~{&FP3}~
 ~{&FP1}Canxdia[15] ~{&FP2}Canxdia[15] ~{&FP3}~
 ~{&FP1}Canxdia[16] ~{&FP2}Canxdia[16] ~{&FP3}~
 ~{&FP1}Canxdia[17] ~{&FP2}Canxdia[17] ~{&FP3}~
 ~{&FP1}Canxdia[18] ~{&FP2}Canxdia[18] ~{&FP3}~
 ~{&FP1}Canxdia[19] ~{&FP2}Canxdia[19] ~{&FP3}~
 ~{&FP1}Canxdia[20] ~{&FP2}Canxdia[20] ~{&FP3}~
 ~{&FP1}Canxdia[21] ~{&FP2}Canxdia[21] ~{&FP3}~
 ~{&FP1}Canxdia[22] ~{&FP2}Canxdia[22] ~{&FP3}~
 ~{&FP1}Canxdia[23] ~{&FP2}Canxdia[23] ~{&FP3}~
 ~{&FP1}Canxdia[24] ~{&FP2}Canxdia[24] ~{&FP3}~
 ~{&FP1}Canxdia[25] ~{&FP2}Canxdia[25] ~{&FP3}~
 ~{&FP1}Canxdia[26] ~{&FP2}Canxdia[26] ~{&FP3}~
 ~{&FP1}Canxdia[27] ~{&FP2}Canxdia[27] ~{&FP3}~
 ~{&FP1}Canxdia[28] ~{&FP2}Canxdia[28] ~{&FP3}~
 ~{&FP1}Canxdia[29] ~{&FP2}Canxdia[29] ~{&FP3}~
 ~{&FP1}Canxdia[30] ~{&FP2}Canxdia[30] ~{&FP3}~
 ~{&FP1}Canxdia[31] ~{&FP2}Canxdia[31] ~{&FP3}
&Scoped-define ENABLED-TABLES EvtArti
&Scoped-define FIRST-ENABLED-TABLE EvtArti
&Scoped-Define DISPLAYED-FIELDS EvtArti.Canxdia[1] EvtArti.Canxdia[2] ~
EvtArti.Canxdia[3] EvtArti.Canxdia[4] EvtArti.Canxdia[5] EvtArti.Canxdia[6] ~
EvtArti.Canxdia[7] EvtArti.Canxdia[8] EvtArti.Canxdia[9] ~
EvtArti.Canxdia[10] EvtArti.Canxdia[11] EvtArti.Canxdia[12] ~
EvtArti.Canxdia[13] EvtArti.Canxdia[14] EvtArti.Canxdia[15] ~
EvtArti.Canxdia[16] EvtArti.Canxdia[17] EvtArti.Canxdia[18] ~
EvtArti.Canxdia[19] EvtArti.Canxdia[20] EvtArti.Canxdia[21] ~
EvtArti.Canxdia[22] EvtArti.Canxdia[23] EvtArti.Canxdia[24] ~
EvtArti.Canxdia[25] EvtArti.Canxdia[26] EvtArti.Canxdia[27] ~
EvtArti.Canxdia[28] EvtArti.Canxdia[29] EvtArti.Canxdia[30] ~
EvtArti.Canxdia[31] 

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

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EvtArti.Canxdia[1] AT ROW 1.12 COL 1.57 COLON-ALIGNED
          LABEL "1" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[2] AT ROW 2 COL 1.57 COLON-ALIGNED
          LABEL "2" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[3] AT ROW 2.81 COL 1.57 COLON-ALIGNED
          LABEL "3" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[4] AT ROW 3.62 COL 1.57 COLON-ALIGNED
          LABEL "4" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[5] AT ROW 4.42 COL 1.57 COLON-ALIGNED
          LABEL "5" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[6] AT ROW 5.23 COL 1.57 COLON-ALIGNED
          LABEL "6" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[7] AT ROW 6.04 COL 1.57 COLON-ALIGNED
          LABEL "7" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[8] AT ROW 6.85 COL 1.57 COLON-ALIGNED
          LABEL "8" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[9] AT ROW 7.65 COL 1.57 COLON-ALIGNED
          LABEL "9" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[10] AT ROW 8.5 COL 1.57 COLON-ALIGNED
          LABEL "10" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[11] AT ROW 9.31 COL 1.57 COLON-ALIGNED
          LABEL "11" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[12] AT ROW 10.12 COL 1.57 COLON-ALIGNED
          LABEL "12" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[13] AT ROW 10.92 COL 1.57 COLON-ALIGNED
          LABEL "13" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[14] AT ROW 11.73 COL 1.57 COLON-ALIGNED
          LABEL "14" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[15] AT ROW 12.54 COL 1.57 COLON-ALIGNED
          LABEL "15" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[16] AT ROW 13.35 COL 1.57 COLON-ALIGNED
          LABEL "16" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[17] AT ROW 1.15 COL 13.43 COLON-ALIGNED
          LABEL "17" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[18] AT ROW 1.96 COL 13.43 COLON-ALIGNED
          LABEL "18" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     EvtArti.Canxdia[19] AT ROW 2.77 COL 13.43 COLON-ALIGNED
          LABEL "19" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[20] AT ROW 3.58 COL 13.43 COLON-ALIGNED
          LABEL "20" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[21] AT ROW 4.38 COL 13.43 COLON-ALIGNED
          LABEL "21" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[22] AT ROW 5.19 COL 13.43 COLON-ALIGNED
          LABEL "22" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[23] AT ROW 6 COL 13.43 COLON-ALIGNED
          LABEL "23" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[24] AT ROW 6.81 COL 13.43 COLON-ALIGNED
          LABEL "24" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[25] AT ROW 7.62 COL 13.43 COLON-ALIGNED
          LABEL "25" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[26] AT ROW 8.46 COL 13.43 COLON-ALIGNED
          LABEL "26" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[27] AT ROW 9.27 COL 13.43 COLON-ALIGNED
          LABEL "27" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[28] AT ROW 10.08 COL 13.43 COLON-ALIGNED
          LABEL "28" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[29] AT ROW 10.88 COL 13.43 COLON-ALIGNED
          LABEL "29" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[30] AT ROW 11.69 COL 13.43 COLON-ALIGNED
          LABEL "30" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
     EvtArti.Canxdia[31] AT ROW 12.5 COL 13.43 COLON-ALIGNED
          LABEL "31" FORMAT "->>>>>>"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 9 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: REPORTE.EvtArti
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
         HEIGHT             = 13.15
         WIDTH              = 22.29.
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

/* SETTINGS FOR FILL-IN EvtArti.Canxdia[10] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[11] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[12] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[13] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[14] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[15] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[16] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[17] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[18] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[19] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[20] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[21] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[22] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[23] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[24] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[25] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[26] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[27] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[28] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[29] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[2] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[30] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[31] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[3] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[4] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[5] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[6] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[7] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[8] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN EvtArti.Canxdia[9] IN FRAME F-Main
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

 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartViewerCues" V-table-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartViewer,uib,49270
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
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
  {src/adm/template/row-list.i "EvtArti"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "EvtArti"}

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
  {src/adm/template/snd-list.i "EvtArti"}

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


