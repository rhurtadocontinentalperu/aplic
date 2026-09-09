&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
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


{bin/s-global.i}
{pln/s-global.i}

FIND FIRST integral.PL-VARG NO-LOCK NO-ERROR.
IF NOT AVAILABLE integral.PL-VARG THEN DO:
    BELL.
    MESSAGE "Registro de variables generales no existe"
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

DEFINE VARIABLE i AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PL-VAR-SEM

/* Definitions for FRAME F-Main                                         */
&Scoped-define FIELDS-IN-QUERY-F-Main PL-VAR-SEM.ValVar-SEM[1] ~
PL-VAR-SEM.ValVar-SEM[2] PL-VAR-SEM.ValVar-SEM[3] PL-VAR-SEM.ValVar-SEM[4] ~
PL-VAR-SEM.ValVar-SEM[5] PL-VAR-SEM.ValVar-SEM[6] PL-VAR-SEM.ValVar-SEM[7] ~
PL-VAR-SEM.ValVar-SEM[8] PL-VAR-SEM.ValVar-SEM[9] PL-VAR-SEM.ValVar-SEM[10] ~
PL-VAR-SEM.ValVar-SEM[11] PL-VAR-SEM.ValVar-SEM[12] ~
PL-VAR-SEM.ValVar-SEM[13] PL-VAR-SEM.ValVar-SEM[14] ~
PL-VAR-SEM.ValVar-SEM[15] PL-VAR-SEM.ValVar-SEM[16] ~
PL-VAR-SEM.ValVar-SEM[17] PL-VAR-SEM.ValVar-SEM[18] ~
PL-VAR-SEM.ValVar-SEM[19] PL-VAR-SEM.ValVar-SEM[20] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-Main PL-VAR-SEM.ValVar-SEM[1] ~
PL-VAR-SEM.ValVar-SEM[2] PL-VAR-SEM.ValVar-SEM[3] PL-VAR-SEM.ValVar-SEM[4] ~
PL-VAR-SEM.ValVar-SEM[5] PL-VAR-SEM.ValVar-SEM[6] PL-VAR-SEM.ValVar-SEM[7] ~
PL-VAR-SEM.ValVar-SEM[8] PL-VAR-SEM.ValVar-SEM[9] PL-VAR-SEM.ValVar-SEM[10] ~
PL-VAR-SEM.ValVar-SEM[11] PL-VAR-SEM.ValVar-SEM[12] ~
PL-VAR-SEM.ValVar-SEM[13] PL-VAR-SEM.ValVar-SEM[14] ~
PL-VAR-SEM.ValVar-SEM[15] PL-VAR-SEM.ValVar-SEM[16] ~
PL-VAR-SEM.ValVar-SEM[17] PL-VAR-SEM.ValVar-SEM[18] ~
&Scoped-define ENABLED-TABLES-IN-QUERY-F-Main PL-VAR-SEM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-F-Main PL-VAR-SEM

&Scoped-define FIELD-PAIRS-IN-QUERY-F-Main~
 ~{&FP1}ValVar-SEM[1] ~{&FP2}ValVar-SEM[1] ~{&FP3}~
 ~{&FP1}ValVar-SEM[2] ~{&FP2}ValVar-SEM[2] ~{&FP3}~
 ~{&FP1}ValVar-SEM[3] ~{&FP2}ValVar-SEM[3] ~{&FP3}~
 ~{&FP1}ValVar-SEM[4] ~{&FP2}ValVar-SEM[4] ~{&FP3}~
 ~{&FP1}ValVar-SEM[5] ~{&FP2}ValVar-SEM[5] ~{&FP3}~
 ~{&FP1}ValVar-SEM[6] ~{&FP2}ValVar-SEM[6] ~{&FP3}~
 ~{&FP1}ValVar-SEM[7] ~{&FP2}ValVar-SEM[7] ~{&FP3}~
 ~{&FP1}ValVar-SEM[8] ~{&FP2}ValVar-SEM[8] ~{&FP3}~
 ~{&FP1}ValVar-SEM[9] ~{&FP2}ValVar-SEM[9] ~{&FP3}~
 ~{&FP1}ValVar-SEM[10] ~{&FP2}ValVar-SEM[10] ~{&FP3}~
 ~{&FP1}ValVar-SEM[11] ~{&FP2}ValVar-SEM[11] ~{&FP3}~
 ~{&FP1}ValVar-SEM[12] ~{&FP2}ValVar-SEM[12] ~{&FP3}~
 ~{&FP1}ValVar-SEM[13] ~{&FP2}ValVar-SEM[13] ~{&FP3}~
 ~{&FP1}ValVar-SEM[14] ~{&FP2}ValVar-SEM[14] ~{&FP3}~
 ~{&FP1}ValVar-SEM[15] ~{&FP2}ValVar-SEM[15] ~{&FP3}~
 ~{&FP1}ValVar-SEM[16] ~{&FP2}ValVar-SEM[16] ~{&FP3}~
 ~{&FP1}ValVar-SEM[17] ~{&FP2}ValVar-SEM[17] ~{&FP3}~
 ~{&FP1}ValVar-SEM[18] ~{&FP2}ValVar-SEM[18] ~{&FP3}~
 ~{&FP1}ValVar-SEM[19] ~{&FP2}ValVar-SEM[19] ~{&FP3}~
 ~{&FP1}ValVar-SEM[20] ~{&FP2}ValVar-SEM[20] ~{&FP3}
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH PL-VAR-SEM SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main PL-VAR-SEM
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main PL-VAR-SEM


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS PL-VAR-SEM.ValVar-SEM[1] ~
PL-VAR-SEM.ValVar-SEM[2] PL-VAR-SEM.ValVar-SEM[3] PL-VAR-SEM.ValVar-SEM[4] ~
PL-VAR-SEM.ValVar-SEM[5] PL-VAR-SEM.ValVar-SEM[6] PL-VAR-SEM.ValVar-SEM[7] ~
PL-VAR-SEM.ValVar-SEM[8] PL-VAR-SEM.ValVar-SEM[9] PL-VAR-SEM.ValVar-SEM[10] ~
PL-VAR-SEM.ValVar-SEM[11] PL-VAR-SEM.ValVar-SEM[12] ~
PL-VAR-SEM.ValVar-SEM[13] PL-VAR-SEM.ValVar-SEM[14] ~
PL-VAR-SEM.ValVar-SEM[15] PL-VAR-SEM.ValVar-SEM[16] ~
PL-VAR-SEM.ValVar-SEM[17] PL-VAR-SEM.ValVar-SEM[18] ~
PL-VAR-SEM.ValVar-SEM[19] PL-VAR-SEM.ValVar-SEM[20] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}ValVar-SEM[1] ~{&FP2}ValVar-SEM[1] ~{&FP3}~
 ~{&FP1}ValVar-SEM[2] ~{&FP2}ValVar-SEM[2] ~{&FP3}~
 ~{&FP1}ValVar-SEM[3] ~{&FP2}ValVar-SEM[3] ~{&FP3}~
 ~{&FP1}ValVar-SEM[4] ~{&FP2}ValVar-SEM[4] ~{&FP3}~
 ~{&FP1}ValVar-SEM[5] ~{&FP2}ValVar-SEM[5] ~{&FP3}~
 ~{&FP1}ValVar-SEM[6] ~{&FP2}ValVar-SEM[6] ~{&FP3}~
 ~{&FP1}ValVar-SEM[7] ~{&FP2}ValVar-SEM[7] ~{&FP3}~
 ~{&FP1}ValVar-SEM[8] ~{&FP2}ValVar-SEM[8] ~{&FP3}~
 ~{&FP1}ValVar-SEM[9] ~{&FP2}ValVar-SEM[9] ~{&FP3}~
 ~{&FP1}ValVar-SEM[10] ~{&FP2}ValVar-SEM[10] ~{&FP3}~
 ~{&FP1}ValVar-SEM[11] ~{&FP2}ValVar-SEM[11] ~{&FP3}~
 ~{&FP1}ValVar-SEM[12] ~{&FP2}ValVar-SEM[12] ~{&FP3}~
 ~{&FP1}ValVar-SEM[13] ~{&FP2}ValVar-SEM[13] ~{&FP3}~
 ~{&FP1}ValVar-SEM[14] ~{&FP2}ValVar-SEM[14] ~{&FP3}~
 ~{&FP1}ValVar-SEM[15] ~{&FP2}ValVar-SEM[15] ~{&FP3}~
 ~{&FP1}ValVar-SEM[16] ~{&FP2}ValVar-SEM[16] ~{&FP3}~
 ~{&FP1}ValVar-SEM[17] ~{&FP2}ValVar-SEM[17] ~{&FP3}~
 ~{&FP1}ValVar-SEM[18] ~{&FP2}ValVar-SEM[18] ~{&FP3}~
 ~{&FP1}ValVar-SEM[19] ~{&FP2}ValVar-SEM[19] ~{&FP3}~
 ~{&FP1}ValVar-SEM[20] ~{&FP2}ValVar-SEM[20] ~{&FP3}
&Scoped-define ENABLED-TABLES PL-VAR-SEM
&Scoped-define FIRST-ENABLED-TABLE PL-VAR-SEM
&Scoped-Define ENABLED-OBJECTS RECT-9 RECT-10 B-ok B-cancel 
&Scoped-Define DISPLAYED-FIELDS PL-VARG.NomVar-Sem[1] PL-VARG.NomVar-Sem[2] ~
PL-VARG.NomVar-Sem[3] PL-VARG.NomVar-Sem[4] PL-VARG.NomVar-Sem[5] ~
PL-VARG.NomVar-Sem[6] PL-VARG.NomVar-Sem[7] PL-VARG.NomVar-Sem[8] ~
PL-VARG.NomVar-Sem[9] PL-VARG.NomVar-Sem[10] PL-VAR-SEM.ValVar-SEM[1] ~
PL-VAR-SEM.ValVar-SEM[2] PL-VAR-SEM.ValVar-SEM[3] PL-VAR-SEM.ValVar-SEM[4] ~
PL-VAR-SEM.ValVar-SEM[5] PL-VAR-SEM.ValVar-SEM[6] PL-VAR-SEM.ValVar-SEM[7] ~
PL-VAR-SEM.ValVar-SEM[8] PL-VAR-SEM.ValVar-SEM[9] PL-VAR-SEM.ValVar-SEM[10] ~
PL-VARG.NomVar-Sem[11] PL-VARG.NomVar-Sem[12] PL-VARG.NomVar-Sem[13] ~
PL-VARG.NomVar-Sem[14] PL-VARG.NomVar-Sem[15] PL-VARG.NomVar-Sem[16] ~
PL-VARG.NomVar-Sem[17] PL-VARG.NomVar-Sem[18] PL-VARG.NomVar-Sem[19] ~
PL-VARG.NomVar-Sem[20] PL-VAR-SEM.ValVar-SEM[11] PL-VAR-SEM.ValVar-SEM[12] ~
PL-VAR-SEM.ValVar-SEM[13] PL-VAR-SEM.ValVar-SEM[14] ~
PL-VAR-SEM.ValVar-SEM[15] PL-VAR-SEM.ValVar-SEM[16] ~
PL-VAR-SEM.ValVar-SEM[17] PL-VAR-SEM.ValVar-SEM[18] ~
PL-VAR-SEM.ValVar-SEM[19] PL-VAR-SEM.ValVar-SEM[20] 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-cancel 
     IMAGE-UP FILE "img/b-cancel":U
     LABEL "" 
     SIZE 11 BY 1.54.

DEFINE BUTTON B-ok 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "" 
     SIZE 11 BY 1.54.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77.86 BY 2.27.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77.86 BY 10.38.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Main FOR 
      PL-VAR-SEM SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     PL-VARG.NomVar-Sem[1] AT ROW 1.65 COL 4 COLON-ALIGNED
          LABEL "1"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[2] AT ROW 2.62 COL 4 COLON-ALIGNED
          LABEL "2"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[3] AT ROW 3.58 COL 4 COLON-ALIGNED
          LABEL "3"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[4] AT ROW 4.5 COL 4 COLON-ALIGNED
          LABEL "4"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[5] AT ROW 5.46 COL 4 COLON-ALIGNED
          LABEL "5"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[6] AT ROW 6.42 COL 4 COLON-ALIGNED
          LABEL "6"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[7] AT ROW 7.35 COL 4 COLON-ALIGNED
          LABEL "7"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[8] AT ROW 8.31 COL 4 COLON-ALIGNED
          LABEL "8"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[9] AT ROW 9.27 COL 4 COLON-ALIGNED
          LABEL "9"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[10] AT ROW 10.19 COL 4 COLON-ALIGNED
          LABEL "10"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VAR-SEM.ValVar-SEM[1] AT ROW 1.65 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[2] AT ROW 2.62 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[3] AT ROW 3.58 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[4] AT ROW 4.5 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[5] AT ROW 5.46 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[6] AT ROW 6.42 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[7] AT ROW 7.35 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[8] AT ROW 8.31 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[9] AT ROW 9.27 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[10] AT ROW 10.19 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VARG.NomVar-Sem[11] AT ROW 1.65 COL 43.14 COLON-ALIGNED
          LABEL "11"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[12] AT ROW 2.62 COL 43.14 COLON-ALIGNED
          LABEL "12"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[13] AT ROW 3.58 COL 43.14 COLON-ALIGNED
          LABEL "13"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[14] AT ROW 4.5 COL 43.14 COLON-ALIGNED
          LABEL "14"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[15] AT ROW 5.46 COL 43.14 COLON-ALIGNED
          LABEL "15"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     PL-VARG.NomVar-Sem[16] AT ROW 6.42 COL 43.14 COLON-ALIGNED
          LABEL "16"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[17] AT ROW 7.35 COL 43.14 COLON-ALIGNED
          LABEL "17"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[18] AT ROW 8.31 COL 43.14 COLON-ALIGNED
          LABEL "18"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[19] AT ROW 9.27 COL 43.14 COLON-ALIGNED
          LABEL "19"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Sem[20] AT ROW 10.19 COL 43.14 COLON-ALIGNED
          LABEL "20"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     B-ok AT ROW 12.23 COL 52.14
     PL-VAR-SEM.ValVar-SEM[11] AT ROW 1.65 COL 66.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[12] AT ROW 2.62 COL 66.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[13] AT ROW 3.58 COL 66.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[14] AT ROW 4.5 COL 66.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[15] AT ROW 5.46 COL 66.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[16] AT ROW 6.42 COL 66.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[17] AT ROW 7.35 COL 66.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[18] AT ROW 8.31 COL 66.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[19] AT ROW 9.27 COL 66.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-SEM.ValVar-SEM[20] AT ROW 10.19 COL 66.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     B-cancel AT ROW 12.23 COL 66.72
     RECT-9 AT ROW 1.23 COL 1.72
     RECT-10 AT ROW 11.85 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 13.27
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
         TITLE              = "Variables Generales de Semana"
         HEIGHT             = 13.35
         WIDTH              = 79.14
         MAX-HEIGHT         = 17.19
         MAX-WIDTH          = 81.57
         VIRTUAL-HEIGHT     = 17.19
         VIRTUAL-WIDTH      = 81.57
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[10] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[11] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[12] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[13] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[14] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[15] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[16] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[17] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[18] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[19] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[20] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[2] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[3] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[4] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[5] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[6] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[7] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[8] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Sem[9] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[10] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[11] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[12] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[13] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[14] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[15] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[16] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[17] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[18] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[19] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[20] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[3] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[4] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[5] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[6] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[7] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[8] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-SEM.ValVar-SEM[9] IN FRAME F-Main
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "integral.PL-VAR-SEM"
     _Query            is NOT OPENED
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
ON END-ERROR OF W-Win /* Variables Generales de Semana */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Variables Generales de Semana */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-cancel W-Win
ON CHOOSE OF B-cancel IN FRAME F-Main
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok W-Win
ON CHOOSE OF B-ok IN FRAME F-Main
DO:
    FIND integral.PL-VAR-SEM WHERE
        integral.PL-VAR-SEM.Periodo = s-Periodo AND
        integral.PL-VAR-SEM.NroSem  = s-NroSem NO-ERROR.
    IF NOT AVAILABLE integral.PL-VAR-SEM THEN DO:
        CREATE integral.PL-VAR-SEM.
        ASSIGN
            integral.PL-VAR-SEM.Periodo = s-Periodo
            integral.PL-VAR-SEM.NroSem  = s-NroSem.
    END.
    DO i = 1 TO 20:
        ASSIGN integral.PL-VAR-SEM.VALVAR-SEM[I].
    END.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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
  IF AVAILABLE PL-VAR-SEM THEN 
    DISPLAY PL-VAR-SEM.ValVar-SEM[1] PL-VAR-SEM.ValVar-SEM[2] 
          PL-VAR-SEM.ValVar-SEM[3] PL-VAR-SEM.ValVar-SEM[4] 
          PL-VAR-SEM.ValVar-SEM[5] PL-VAR-SEM.ValVar-SEM[6] 
          PL-VAR-SEM.ValVar-SEM[7] PL-VAR-SEM.ValVar-SEM[8] 
          PL-VAR-SEM.ValVar-SEM[9] PL-VAR-SEM.ValVar-SEM[10] 
          PL-VAR-SEM.ValVar-SEM[11] PL-VAR-SEM.ValVar-SEM[12] 
          PL-VAR-SEM.ValVar-SEM[13] PL-VAR-SEM.ValVar-SEM[14] 
          PL-VAR-SEM.ValVar-SEM[15] PL-VAR-SEM.ValVar-SEM[16] 
          PL-VAR-SEM.ValVar-SEM[17] PL-VAR-SEM.ValVar-SEM[18] 
          PL-VAR-SEM.ValVar-SEM[19] PL-VAR-SEM.ValVar-SEM[20] 
      WITH FRAME F-Main IN WINDOW W-Win.
  IF AVAILABLE PL-VARG THEN 
    DISPLAY PL-VARG.NomVar-Sem[1] PL-VARG.NomVar-Sem[2] PL-VARG.NomVar-Sem[3] 
          PL-VARG.NomVar-Sem[4] PL-VARG.NomVar-Sem[5] PL-VARG.NomVar-Sem[6] 
          PL-VARG.NomVar-Sem[7] PL-VARG.NomVar-Sem[8] PL-VARG.NomVar-Sem[9] 
          PL-VARG.NomVar-Sem[10] PL-VARG.NomVar-Sem[11] PL-VARG.NomVar-Sem[12] 
          PL-VARG.NomVar-Sem[13] PL-VARG.NomVar-Sem[14] PL-VARG.NomVar-Sem[15] 
          PL-VARG.NomVar-Sem[16] PL-VARG.NomVar-Sem[17] PL-VARG.NomVar-Sem[18] 
          PL-VARG.NomVar-Sem[19] PL-VARG.NomVar-Sem[20] 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-9 RECT-10 PL-VAR-SEM.ValVar-SEM[1] PL-VAR-SEM.ValVar-SEM[2] 
         PL-VAR-SEM.ValVar-SEM[3] PL-VAR-SEM.ValVar-SEM[4] 
         PL-VAR-SEM.ValVar-SEM[5] PL-VAR-SEM.ValVar-SEM[6] 
         PL-VAR-SEM.ValVar-SEM[7] PL-VAR-SEM.ValVar-SEM[8] 
         PL-VAR-SEM.ValVar-SEM[9] PL-VAR-SEM.ValVar-SEM[10] B-ok 
         PL-VAR-SEM.ValVar-SEM[11] PL-VAR-SEM.ValVar-SEM[12] 
         PL-VAR-SEM.ValVar-SEM[13] PL-VAR-SEM.ValVar-SEM[14] 
         PL-VAR-SEM.ValVar-SEM[15] PL-VAR-SEM.ValVar-SEM[16] 
         PL-VAR-SEM.ValVar-SEM[17] PL-VAR-SEM.ValVar-SEM[18] 
         PL-VAR-SEM.ValVar-SEM[19] PL-VAR-SEM.ValVar-SEM[20] B-cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable W-Win 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
    FIND LAST integral.PL-VAR-SEM WHERE
        integral.PL-VAR-SEM.Periodo = s-Periodo AND
        integral.PL-VAR-SEM.NroSem  = s-NroSem NO-ERROR.
    IF NOT AVAILABLE integral.PL-VAR-SEM THEN DO:
        CREATE integral.PL-VAR-SEM.
        ASSIGN
            integral.PL-VAR-SEM.Periodo = s-Periodo
            integral.PL-VAR-SEM.NroSem  = s-NroSem.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    IF PL-VARG.NOMVAR-SEM[1] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[1]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[2] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[2]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[3] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[3]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[4] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[4]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[5] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[5]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[6] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[6]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[7] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[7]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[8] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[8]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[9] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[9]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[10] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[10]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[11] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[11]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[12] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[12]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[13] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[13]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[14] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[14]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[15] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[15]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[16] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[16]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[17] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[17]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[18] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[18]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[19] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[19]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-SEM[20] = "" THEN
        ASSIGN integral.PL-VAR-SEM.ValVar-SEM[20]:SENSITIVE IN FRAME F-Main = FALSE.

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
  {src/adm/template/snd-list.i "PL-VAR-SEM"}

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


