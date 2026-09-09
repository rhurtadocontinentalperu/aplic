&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmatg

/* Definitions for FRAME F-Main                                         */
&Scoped-define FIELDS-IN-QUERY-F-Main Almmmatg.codmat Almmmatg.DesMat ~
Almmmatg.PromDivi[1] Almmmatg.PromDivi[2] Almmmatg.PromDivi[3] ~
Almmmatg.PromDivi[4] Almmmatg.PromDivi[5] Almmmatg.PromDivi[6] ~
Almmmatg.PromDivi[7] Almmmatg.PromDivi[8] Almmmatg.PromDivi[9] ~
Almmmatg.PromDivi[10] Almmmatg.PromFchD[1] Almmmatg.PromFchD[2] ~
Almmmatg.PromFchD[3] Almmmatg.PromFchD[4] Almmmatg.PromFchD[5] ~
Almmmatg.PromFchD[6] Almmmatg.PromFchD[7] Almmmatg.PromFchD[8] ~
Almmmatg.PromFchD[9] Almmmatg.PromFchD[10] Almmmatg.PromFchH[1] ~
Almmmatg.PromFchH[2] Almmmatg.PromFchH[3] Almmmatg.PromFchH[4] ~
Almmmatg.PromFchH[5] Almmmatg.PromFchH[6] Almmmatg.PromFchH[7] ~
Almmmatg.PromFchH[8] Almmmatg.PromFchH[9] Almmmatg.PromFchH[10] ~
Almmmatg.PromDto[1] Almmmatg.PromDto[2] Almmmatg.PromDto[3] ~
Almmmatg.PromDto[4] Almmmatg.PromDto[5] Almmmatg.PromDto[6] ~
Almmmatg.PromDto[7] Almmmatg.PromDto[8] Almmmatg.PromDto[9] ~
Almmmatg.PromDto[10] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-Main Almmmatg.PromDivi[1] ~
Almmmatg.PromDivi[2] Almmmatg.PromDivi[3] Almmmatg.PromDivi[4] ~
Almmmatg.PromDivi[5] Almmmatg.PromDivi[6] Almmmatg.PromDivi[7] ~
Almmmatg.PromDivi[8] Almmmatg.PromDivi[9] Almmmatg.PromDivi[10] ~
Almmmatg.PromFchD[1] Almmmatg.PromFchD[2] Almmmatg.PromFchD[3] ~
Almmmatg.PromFchD[4] Almmmatg.PromFchD[5] Almmmatg.PromFchD[6] ~
Almmmatg.PromFchD[7] Almmmatg.PromFchD[8] Almmmatg.PromFchD[9] ~
Almmmatg.PromFchD[10] Almmmatg.PromFchH[1] Almmmatg.PromFchH[2] ~
Almmmatg.PromFchH[3] Almmmatg.PromFchH[4] Almmmatg.PromFchH[5] ~
Almmmatg.PromFchH[6] Almmmatg.PromFchH[7] Almmmatg.PromFchH[8] ~
Almmmatg.PromFchH[9] Almmmatg.PromFchH[10] Almmmatg.PromDto[1] ~
Almmmatg.PromDto[2] Almmmatg.PromDto[3] Almmmatg.PromDto[4] ~
Almmmatg.PromDto[5] Almmmatg.PromDto[6] Almmmatg.PromDto[7] ~
Almmmatg.PromDto[8] Almmmatg.PromDto[9] Almmmatg.PromDto[10] 
&Scoped-define ENABLED-TABLES-IN-QUERY-F-Main Almmmatg
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-F-Main Almmmatg

&Scoped-define FIELD-PAIRS-IN-QUERY-F-Main~
 ~{&FP1}PromDivi[1] ~{&FP2}PromDivi[1] ~{&FP3}~
 ~{&FP1}PromDivi[2] ~{&FP2}PromDivi[2] ~{&FP3}~
 ~{&FP1}PromDivi[3] ~{&FP2}PromDivi[3] ~{&FP3}~
 ~{&FP1}PromDivi[4] ~{&FP2}PromDivi[4] ~{&FP3}~
 ~{&FP1}PromDivi[5] ~{&FP2}PromDivi[5] ~{&FP3}~
 ~{&FP1}PromDivi[6] ~{&FP2}PromDivi[6] ~{&FP3}~
 ~{&FP1}PromDivi[7] ~{&FP2}PromDivi[7] ~{&FP3}~
 ~{&FP1}PromDivi[8] ~{&FP2}PromDivi[8] ~{&FP3}~
 ~{&FP1}PromDivi[9] ~{&FP2}PromDivi[9] ~{&FP3}~
 ~{&FP1}PromDivi[10] ~{&FP2}PromDivi[10] ~{&FP3}~
 ~{&FP1}PromFchD[1] ~{&FP2}PromFchD[1] ~{&FP3}~
 ~{&FP1}PromFchD[2] ~{&FP2}PromFchD[2] ~{&FP3}~
 ~{&FP1}PromFchD[3] ~{&FP2}PromFchD[3] ~{&FP3}~
 ~{&FP1}PromFchD[4] ~{&FP2}PromFchD[4] ~{&FP3}~
 ~{&FP1}PromFchD[5] ~{&FP2}PromFchD[5] ~{&FP3}~
 ~{&FP1}PromFchD[6] ~{&FP2}PromFchD[6] ~{&FP3}~
 ~{&FP1}PromFchD[7] ~{&FP2}PromFchD[7] ~{&FP3}~
 ~{&FP1}PromFchD[8] ~{&FP2}PromFchD[8] ~{&FP3}~
 ~{&FP1}PromFchD[9] ~{&FP2}PromFchD[9] ~{&FP3}~
 ~{&FP1}PromFchD[10] ~{&FP2}PromFchD[10] ~{&FP3}~
 ~{&FP1}PromFchH[1] ~{&FP2}PromFchH[1] ~{&FP3}~
 ~{&FP1}PromFchH[2] ~{&FP2}PromFchH[2] ~{&FP3}~
 ~{&FP1}PromFchH[3] ~{&FP2}PromFchH[3] ~{&FP3}~
 ~{&FP1}PromFchH[4] ~{&FP2}PromFchH[4] ~{&FP3}~
 ~{&FP1}PromFchH[5] ~{&FP2}PromFchH[5] ~{&FP3}~
 ~{&FP1}PromFchH[6] ~{&FP2}PromFchH[6] ~{&FP3}~
 ~{&FP1}PromFchH[7] ~{&FP2}PromFchH[7] ~{&FP3}~
 ~{&FP1}PromFchH[8] ~{&FP2}PromFchH[8] ~{&FP3}~
 ~{&FP1}PromFchH[9] ~{&FP2}PromFchH[9] ~{&FP3}~
 ~{&FP1}PromFchH[10] ~{&FP2}PromFchH[10] ~{&FP3}~
 ~{&FP1}PromDto[1] ~{&FP2}PromDto[1] ~{&FP3}~
 ~{&FP1}PromDto[2] ~{&FP2}PromDto[2] ~{&FP3}~
 ~{&FP1}PromDto[3] ~{&FP2}PromDto[3] ~{&FP3}~
 ~{&FP1}PromDto[4] ~{&FP2}PromDto[4] ~{&FP3}~
 ~{&FP1}PromDto[5] ~{&FP2}PromDto[5] ~{&FP3}~
 ~{&FP1}PromDto[6] ~{&FP2}PromDto[6] ~{&FP3}~
 ~{&FP1}PromDto[7] ~{&FP2}PromDto[7] ~{&FP3}~
 ~{&FP1}PromDto[8] ~{&FP2}PromDto[8] ~{&FP3}~
 ~{&FP1}PromDto[9] ~{&FP2}PromDto[9] ~{&FP3}~
 ~{&FP1}PromDto[10] ~{&FP2}PromDto[10] ~{&FP3}
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH Almmmatg SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main Almmmatg


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almmmatg.PromDivi[1] Almmmatg.PromDivi[2] ~
Almmmatg.PromDivi[3] Almmmatg.PromDivi[4] Almmmatg.PromDivi[5] ~
Almmmatg.PromDivi[6] Almmmatg.PromDivi[7] Almmmatg.PromDivi[8] ~
Almmmatg.PromDivi[9] Almmmatg.PromDivi[10] Almmmatg.PromFchD[1] ~
Almmmatg.PromFchD[2] Almmmatg.PromFchD[3] Almmmatg.PromFchD[4] ~
Almmmatg.PromFchD[5] Almmmatg.PromFchD[6] Almmmatg.PromFchD[7] ~
Almmmatg.PromFchD[8] Almmmatg.PromFchD[9] Almmmatg.PromFchD[10] ~
Almmmatg.PromFchH[1] Almmmatg.PromFchH[2] Almmmatg.PromFchH[3] ~
Almmmatg.PromFchH[4] Almmmatg.PromFchH[5] Almmmatg.PromFchH[6] ~
Almmmatg.PromFchH[7] Almmmatg.PromFchH[8] Almmmatg.PromFchH[9] ~
Almmmatg.PromFchH[10] Almmmatg.PromDto[1] Almmmatg.PromDto[2] ~
Almmmatg.PromDto[3] Almmmatg.PromDto[4] Almmmatg.PromDto[5] ~
Almmmatg.PromDto[6] Almmmatg.PromDto[7] Almmmatg.PromDto[8] ~
Almmmatg.PromDto[9] Almmmatg.PromDto[10] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}PromDivi[1] ~{&FP2}PromDivi[1] ~{&FP3}~
 ~{&FP1}PromDivi[2] ~{&FP2}PromDivi[2] ~{&FP3}~
 ~{&FP1}PromDivi[3] ~{&FP2}PromDivi[3] ~{&FP3}~
 ~{&FP1}PromDivi[4] ~{&FP2}PromDivi[4] ~{&FP3}~
 ~{&FP1}PromDivi[5] ~{&FP2}PromDivi[5] ~{&FP3}~
 ~{&FP1}PromDivi[6] ~{&FP2}PromDivi[6] ~{&FP3}~
 ~{&FP1}PromDivi[7] ~{&FP2}PromDivi[7] ~{&FP3}~
 ~{&FP1}PromDivi[8] ~{&FP2}PromDivi[8] ~{&FP3}~
 ~{&FP1}PromDivi[9] ~{&FP2}PromDivi[9] ~{&FP3}~
 ~{&FP1}PromDivi[10] ~{&FP2}PromDivi[10] ~{&FP3}~
 ~{&FP1}PromFchD[1] ~{&FP2}PromFchD[1] ~{&FP3}~
 ~{&FP1}PromFchD[2] ~{&FP2}PromFchD[2] ~{&FP3}~
 ~{&FP1}PromFchD[3] ~{&FP2}PromFchD[3] ~{&FP3}~
 ~{&FP1}PromFchD[4] ~{&FP2}PromFchD[4] ~{&FP3}~
 ~{&FP1}PromFchD[5] ~{&FP2}PromFchD[5] ~{&FP3}~
 ~{&FP1}PromFchD[6] ~{&FP2}PromFchD[6] ~{&FP3}~
 ~{&FP1}PromFchD[7] ~{&FP2}PromFchD[7] ~{&FP3}~
 ~{&FP1}PromFchD[8] ~{&FP2}PromFchD[8] ~{&FP3}~
 ~{&FP1}PromFchD[9] ~{&FP2}PromFchD[9] ~{&FP3}~
 ~{&FP1}PromFchD[10] ~{&FP2}PromFchD[10] ~{&FP3}~
 ~{&FP1}PromFchH[1] ~{&FP2}PromFchH[1] ~{&FP3}~
 ~{&FP1}PromFchH[2] ~{&FP2}PromFchH[2] ~{&FP3}~
 ~{&FP1}PromFchH[3] ~{&FP2}PromFchH[3] ~{&FP3}~
 ~{&FP1}PromFchH[4] ~{&FP2}PromFchH[4] ~{&FP3}~
 ~{&FP1}PromFchH[5] ~{&FP2}PromFchH[5] ~{&FP3}~
 ~{&FP1}PromFchH[6] ~{&FP2}PromFchH[6] ~{&FP3}~
 ~{&FP1}PromFchH[7] ~{&FP2}PromFchH[7] ~{&FP3}~
 ~{&FP1}PromFchH[8] ~{&FP2}PromFchH[8] ~{&FP3}~
 ~{&FP1}PromFchH[9] ~{&FP2}PromFchH[9] ~{&FP3}~
 ~{&FP1}PromFchH[10] ~{&FP2}PromFchH[10] ~{&FP3}~
 ~{&FP1}PromDto[1] ~{&FP2}PromDto[1] ~{&FP3}~
 ~{&FP1}PromDto[2] ~{&FP2}PromDto[2] ~{&FP3}~
 ~{&FP1}PromDto[3] ~{&FP2}PromDto[3] ~{&FP3}~
 ~{&FP1}PromDto[4] ~{&FP2}PromDto[4] ~{&FP3}~
 ~{&FP1}PromDto[5] ~{&FP2}PromDto[5] ~{&FP3}~
 ~{&FP1}PromDto[6] ~{&FP2}PromDto[6] ~{&FP3}~
 ~{&FP1}PromDto[7] ~{&FP2}PromDto[7] ~{&FP3}~
 ~{&FP1}PromDto[8] ~{&FP2}PromDto[8] ~{&FP3}~
 ~{&FP1}PromDto[9] ~{&FP2}PromDto[9] ~{&FP3}~
 ~{&FP1}PromDto[10] ~{&FP2}PromDto[10] ~{&FP3}
&Scoped-define ENABLED-TABLES Almmmatg
&Scoped-define FIRST-ENABLED-TABLE Almmmatg
&Scoped-Define ENABLED-OBJECTS RECT-11 RECT-10 RECT-9 RECT-8 RECT-7 RECT-1 
&Scoped-Define DISPLAYED-FIELDS Almmmatg.codmat Almmmatg.DesMat ~
Almmmatg.PromDivi[1] Almmmatg.PromDivi[2] Almmmatg.PromDivi[3] ~
Almmmatg.PromDivi[4] Almmmatg.PromDivi[5] Almmmatg.PromDivi[6] ~
Almmmatg.PromDivi[7] Almmmatg.PromDivi[8] Almmmatg.PromDivi[9] ~
Almmmatg.PromDivi[10] Almmmatg.PromFchD[1] Almmmatg.PromFchD[2] ~
Almmmatg.PromFchD[3] Almmmatg.PromFchD[4] Almmmatg.PromFchD[5] ~
Almmmatg.PromFchD[6] Almmmatg.PromFchD[7] Almmmatg.PromFchD[8] ~
Almmmatg.PromFchD[9] Almmmatg.PromFchD[10] Almmmatg.PromFchH[1] ~
Almmmatg.PromFchH[2] Almmmatg.PromFchH[3] Almmmatg.PromFchH[4] ~
Almmmatg.PromFchH[5] Almmmatg.PromFchH[6] Almmmatg.PromFchH[7] ~
Almmmatg.PromFchH[8] Almmmatg.PromFchH[9] Almmmatg.PromFchH[10] ~
Almmmatg.PromDto[1] Almmmatg.PromDto[2] Almmmatg.PromDto[3] ~
Almmmatg.PromDto[4] Almmmatg.PromDto[5] Almmmatg.PromDto[6] ~
Almmmatg.PromDto[7] Almmmatg.PromDto[8] Almmmatg.PromDto[9] ~
Almmmatg.PromDto[10] 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-updv05 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36 BY 9.42.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36 BY .85.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39.43 BY 13.54.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 7.43 BY 9.42.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 10.86 BY 9.42.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 9.72 BY 9.42.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Main FOR 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almmmatg.codmat AT ROW 1.46 COL 1 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .69
     Almmmatg.DesMat AT ROW 2.27 COL 1 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 33.57 BY .69
     Almmmatg.PromDivi[1] AT ROW 4.12 COL 1.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDivi[2] AT ROW 4.92 COL 1.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDivi[3] AT ROW 5.73 COL 1.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDivi[4] AT ROW 6.54 COL 1.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDivi[5] AT ROW 7.35 COL 1.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDivi[6] AT ROW 8.15 COL 1.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDivi[7] AT ROW 8.96 COL 1.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDivi[8] AT ROW 9.77 COL 1.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDivi[9] AT ROW 10.58 COL 1.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDivi[10] AT ROW 11.42 COL 1.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromFchD[1] AT ROW 4.12 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchD[2] AT ROW 4.92 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchD[3] AT ROW 5.73 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchD[4] AT ROW 6.54 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchD[5] AT ROW 7.35 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchD[6] AT ROW 8.19 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchD[7] AT ROW 9 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchD[8] AT ROW 9.81 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchD[9] AT ROW 10.62 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchD[10] AT ROW 11.42 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchH[1] AT ROW 4.08 COL 19.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchH[2] AT ROW 4.88 COL 19.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchH[3] AT ROW 5.69 COL 19.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchH[4] AT ROW 6.5 COL 19.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     Almmmatg.PromFchH[5] AT ROW 7.35 COL 19.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchH[6] AT ROW 8.15 COL 19.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchH[7] AT ROW 8.96 COL 19.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchH[8] AT ROW 9.77 COL 19.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchH[9] AT ROW 10.58 COL 19.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromFchH[10] AT ROW 11.38 COL 19.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.PromDto[1] AT ROW 4.08 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDto[2] AT ROW 4.88 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDto[3] AT ROW 5.69 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDto[4] AT ROW 6.5 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDto[5] AT ROW 7.31 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDto[6] AT ROW 8.12 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDto[7] AT ROW 8.92 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDto[8] AT ROW 9.73 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDto[9] AT ROW 10.54 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     Almmmatg.PromDto[10] AT ROW 11.38 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     RECT-11 AT ROW 1.12 COL 1.57
     RECT-10 AT ROW 3.12 COL 2.72
     RECT-9 AT ROW 3.12 COL 21.29
     RECT-8 AT ROW 3.12 COL 10.29
     RECT-7 AT ROW 3.12 COL 2.72
     "Division" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.23 COL 3.57
     RECT-1 AT ROW 3.08 COL 2.72
     "Descuento" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3.23 COL 30.86
     "Fin" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.23 COL 21.43
     "Inicio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.23 COL 12.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Descuento Promocional X Division"
         HEIGHT             = 13.88
         WIDTH              = 41.14
         MAX-HEIGHT         = 21.27
         MAX-WIDTH          = 109.57
         VIRTUAL-HEIGHT     = 21.27
         VIRTUAL-WIDTH      = 109.57
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* SETTINGS FOR FILL-IN Almmmatg.codmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "integral.Almmmatg"
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Descuento Promocional X Division */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Descuento Promocional X Division */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv05.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv05 ).
       RUN set-position IN h_p-updv05 ( 12.81 , 2.43 ) NO-ERROR.
       RUN set-size IN h_p-updv05 ( 1.42 , 37.14 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv05 ,
             Almmmatg.PromDivi[10]:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/

  {&OPEN-QUERY-F-Main}
  GET FIRST F-Main.
  IF AVAILABLE Almmmatg THEN 
    DISPLAY Almmmatg.codmat Almmmatg.DesMat Almmmatg.PromDivi[1] 
          Almmmatg.PromDivi[2] Almmmatg.PromDivi[3] Almmmatg.PromDivi[4] 
          Almmmatg.PromDivi[5] Almmmatg.PromDivi[6] Almmmatg.PromDivi[7] 
          Almmmatg.PromDivi[8] Almmmatg.PromDivi[9] Almmmatg.PromDivi[10] 
          Almmmatg.PromFchD[1] Almmmatg.PromFchD[2] Almmmatg.PromFchD[3] 
          Almmmatg.PromFchD[4] Almmmatg.PromFchD[5] Almmmatg.PromFchD[6] 
          Almmmatg.PromFchD[7] Almmmatg.PromFchD[8] Almmmatg.PromFchD[9] 
          Almmmatg.PromFchD[10] Almmmatg.PromFchH[1] Almmmatg.PromFchH[2] 
          Almmmatg.PromFchH[3] Almmmatg.PromFchH[4] Almmmatg.PromFchH[5] 
          Almmmatg.PromFchH[6] Almmmatg.PromFchH[7] Almmmatg.PromFchH[8] 
          Almmmatg.PromFchH[9] Almmmatg.PromFchH[10] Almmmatg.PromDto[1] 
          Almmmatg.PromDto[2] Almmmatg.PromDto[3] Almmmatg.PromDto[4] 
          Almmmatg.PromDto[5] Almmmatg.PromDto[6] Almmmatg.PromDto[7] 
          Almmmatg.PromDto[8] Almmmatg.PromDto[9] Almmmatg.PromDto[10] 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-11 RECT-10 RECT-9 RECT-8 RECT-7 RECT-1 Almmmatg.PromDivi[1] 
         Almmmatg.PromDivi[2] Almmmatg.PromDivi[3] Almmmatg.PromDivi[4] 
         Almmmatg.PromDivi[5] Almmmatg.PromDivi[6] Almmmatg.PromDivi[7] 
         Almmmatg.PromDivi[8] Almmmatg.PromDivi[9] Almmmatg.PromDivi[10] 
         Almmmatg.PromFchD[1] Almmmatg.PromFchD[2] Almmmatg.PromFchD[3] 
         Almmmatg.PromFchD[4] Almmmatg.PromFchD[5] Almmmatg.PromFchD[6] 
         Almmmatg.PromFchD[7] Almmmatg.PromFchD[8] Almmmatg.PromFchD[9] 
         Almmmatg.PromFchD[10] Almmmatg.PromFchH[1] Almmmatg.PromFchH[2] 
         Almmmatg.PromFchH[3] Almmmatg.PromFchH[4] Almmmatg.PromFchH[5] 
         Almmmatg.PromFchH[6] Almmmatg.PromFchH[7] Almmmatg.PromFchH[8] 
         Almmmatg.PromFchH[9] Almmmatg.PromFchH[10] Almmmatg.PromDto[1] 
         Almmmatg.PromDto[2] Almmmatg.PromDto[3] Almmmatg.PromDto[4] 
         Almmmatg.PromDto[5] Almmmatg.PromDto[6] Almmmatg.PromDto[7] 
         Almmmatg.PromDto[8] Almmmatg.PromDto[9] Almmmatg.PromDto[10] 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


