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
&Scoped-define INTERNAL-TABLES PL-VAR-MES

/* Definitions for FRAME F-Main                                         */
&Scoped-define FIELDS-IN-QUERY-F-Main PL-VAR-MES.ValVar-MES[1] ~
PL-VAR-MES.ValVar-MES[2] PL-VAR-MES.ValVar-MES[3] PL-VAR-MES.ValVar-MES[4] ~
PL-VAR-MES.ValVar-MES[5] PL-VAR-MES.ValVar-MES[6] PL-VAR-MES.ValVar-MES[7] ~
PL-VAR-MES.ValVar-MES[8] PL-VAR-MES.ValVar-MES[9] PL-VAR-MES.ValVar-MES[10] ~
PL-VAR-MES.ValVar-MES[11] PL-VAR-MES.ValVar-MES[12] ~
PL-VAR-MES.ValVar-MES[13] PL-VAR-MES.ValVar-MES[14] ~
PL-VAR-MES.ValVar-MES[15] PL-VAR-MES.ValVar-MES[16] ~
PL-VAR-MES.ValVar-MES[17] PL-VAR-MES.ValVar-MES[18] ~
PL-VAR-MES.ValVar-MES[19] PL-VAR-MES.ValVar-MES[20] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-Main PL-VAR-MES.ValVar-MES[1] ~
PL-VAR-MES.ValVar-MES[2] PL-VAR-MES.ValVar-MES[3] PL-VAR-MES.ValVar-MES[4] ~
PL-VAR-MES.ValVar-MES[5] PL-VAR-MES.ValVar-MES[6] PL-VAR-MES.ValVar-MES[7] ~
PL-VAR-MES.ValVar-MES[8] PL-VAR-MES.ValVar-MES[9] PL-VAR-MES.ValVar-MES[10] ~
PL-VAR-MES.ValVar-MES[11] PL-VAR-MES.ValVar-MES[12] ~
PL-VAR-MES.ValVar-MES[13] PL-VAR-MES.ValVar-MES[14] ~
PL-VAR-MES.ValVar-MES[15] PL-VAR-MES.ValVar-MES[16] ~
PL-VAR-MES.ValVar-MES[17] PL-VAR-MES.ValVar-MES[18] ~
&Scoped-define ENABLED-TABLES-IN-QUERY-F-Main PL-VAR-MES
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-F-Main PL-VAR-MES

&Scoped-define FIELD-PAIRS-IN-QUERY-F-Main~
 ~{&FP1}ValVar-MES[1] ~{&FP2}ValVar-MES[1] ~{&FP3}~
 ~{&FP1}ValVar-MES[2] ~{&FP2}ValVar-MES[2] ~{&FP3}~
 ~{&FP1}ValVar-MES[3] ~{&FP2}ValVar-MES[3] ~{&FP3}~
 ~{&FP1}ValVar-MES[4] ~{&FP2}ValVar-MES[4] ~{&FP3}~
 ~{&FP1}ValVar-MES[5] ~{&FP2}ValVar-MES[5] ~{&FP3}~
 ~{&FP1}ValVar-MES[6] ~{&FP2}ValVar-MES[6] ~{&FP3}~
 ~{&FP1}ValVar-MES[7] ~{&FP2}ValVar-MES[7] ~{&FP3}~
 ~{&FP1}ValVar-MES[8] ~{&FP2}ValVar-MES[8] ~{&FP3}~
 ~{&FP1}ValVar-MES[9] ~{&FP2}ValVar-MES[9] ~{&FP3}~
 ~{&FP1}ValVar-MES[10] ~{&FP2}ValVar-MES[10] ~{&FP3}~
 ~{&FP1}ValVar-MES[11] ~{&FP2}ValVar-MES[11] ~{&FP3}~
 ~{&FP1}ValVar-MES[12] ~{&FP2}ValVar-MES[12] ~{&FP3}~
 ~{&FP1}ValVar-MES[13] ~{&FP2}ValVar-MES[13] ~{&FP3}~
 ~{&FP1}ValVar-MES[14] ~{&FP2}ValVar-MES[14] ~{&FP3}~
 ~{&FP1}ValVar-MES[15] ~{&FP2}ValVar-MES[15] ~{&FP3}~
 ~{&FP1}ValVar-MES[16] ~{&FP2}ValVar-MES[16] ~{&FP3}~
 ~{&FP1}ValVar-MES[17] ~{&FP2}ValVar-MES[17] ~{&FP3}~
 ~{&FP1}ValVar-MES[18] ~{&FP2}ValVar-MES[18] ~{&FP3}~
 ~{&FP1}ValVar-MES[19] ~{&FP2}ValVar-MES[19] ~{&FP3}~
 ~{&FP1}ValVar-MES[20] ~{&FP2}ValVar-MES[20] ~{&FP3}
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH PL-VAR-MES SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main PL-VAR-MES
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main PL-VAR-MES


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS PL-VAR-MES.ValVar-MES[1] ~
PL-VAR-MES.ValVar-MES[2] PL-VAR-MES.ValVar-MES[3] PL-VAR-MES.ValVar-MES[4] ~
PL-VAR-MES.ValVar-MES[5] PL-VAR-MES.ValVar-MES[6] PL-VAR-MES.ValVar-MES[7] ~
PL-VAR-MES.ValVar-MES[8] PL-VAR-MES.ValVar-MES[9] PL-VAR-MES.ValVar-MES[10] ~
PL-VAR-MES.ValVar-MES[11] PL-VAR-MES.ValVar-MES[12] ~
PL-VAR-MES.ValVar-MES[13] PL-VAR-MES.ValVar-MES[14] ~
PL-VAR-MES.ValVar-MES[15] PL-VAR-MES.ValVar-MES[16] ~
PL-VAR-MES.ValVar-MES[17] PL-VAR-MES.ValVar-MES[18] ~
PL-VAR-MES.ValVar-MES[19] PL-VAR-MES.ValVar-MES[20] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}ValVar-MES[1] ~{&FP2}ValVar-MES[1] ~{&FP3}~
 ~{&FP1}ValVar-MES[2] ~{&FP2}ValVar-MES[2] ~{&FP3}~
 ~{&FP1}ValVar-MES[3] ~{&FP2}ValVar-MES[3] ~{&FP3}~
 ~{&FP1}ValVar-MES[4] ~{&FP2}ValVar-MES[4] ~{&FP3}~
 ~{&FP1}ValVar-MES[5] ~{&FP2}ValVar-MES[5] ~{&FP3}~
 ~{&FP1}ValVar-MES[6] ~{&FP2}ValVar-MES[6] ~{&FP3}~
 ~{&FP1}ValVar-MES[7] ~{&FP2}ValVar-MES[7] ~{&FP3}~
 ~{&FP1}ValVar-MES[8] ~{&FP2}ValVar-MES[8] ~{&FP3}~
 ~{&FP1}ValVar-MES[9] ~{&FP2}ValVar-MES[9] ~{&FP3}~
 ~{&FP1}ValVar-MES[10] ~{&FP2}ValVar-MES[10] ~{&FP3}~
 ~{&FP1}ValVar-MES[11] ~{&FP2}ValVar-MES[11] ~{&FP3}~
 ~{&FP1}ValVar-MES[12] ~{&FP2}ValVar-MES[12] ~{&FP3}~
 ~{&FP1}ValVar-MES[13] ~{&FP2}ValVar-MES[13] ~{&FP3}~
 ~{&FP1}ValVar-MES[14] ~{&FP2}ValVar-MES[14] ~{&FP3}~
 ~{&FP1}ValVar-MES[15] ~{&FP2}ValVar-MES[15] ~{&FP3}~
 ~{&FP1}ValVar-MES[16] ~{&FP2}ValVar-MES[16] ~{&FP3}~
 ~{&FP1}ValVar-MES[17] ~{&FP2}ValVar-MES[17] ~{&FP3}~
 ~{&FP1}ValVar-MES[18] ~{&FP2}ValVar-MES[18] ~{&FP3}~
 ~{&FP1}ValVar-MES[19] ~{&FP2}ValVar-MES[19] ~{&FP3}~
 ~{&FP1}ValVar-MES[20] ~{&FP2}ValVar-MES[20] ~{&FP3}
&Scoped-define ENABLED-TABLES PL-VAR-MES
&Scoped-define FIRST-ENABLED-TABLE PL-VAR-MES
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-10 B-ok B-cancel 
&Scoped-Define DISPLAYED-FIELDS PL-VARG.NomVar-Mes[1] PL-VARG.NomVar-Mes[2] ~
PL-VARG.NomVar-Mes[3] PL-VARG.NomVar-Mes[4] PL-VARG.NomVar-Mes[5] ~
PL-VARG.NomVar-Mes[6] PL-VARG.NomVar-Mes[7] PL-VARG.NomVar-Mes[8] ~
PL-VARG.NomVar-Mes[9] PL-VARG.NomVar-Mes[10] PL-VAR-MES.ValVar-MES[1] ~
PL-VAR-MES.ValVar-MES[2] PL-VAR-MES.ValVar-MES[3] PL-VAR-MES.ValVar-MES[4] ~
PL-VAR-MES.ValVar-MES[5] PL-VAR-MES.ValVar-MES[6] PL-VAR-MES.ValVar-MES[7] ~
PL-VAR-MES.ValVar-MES[8] PL-VAR-MES.ValVar-MES[9] PL-VAR-MES.ValVar-MES[10] ~
PL-VARG.NomVar-Mes[11] PL-VARG.NomVar-Mes[12] PL-VARG.NomVar-Mes[13] ~
PL-VARG.NomVar-Mes[14] PL-VARG.NomVar-Mes[15] PL-VARG.NomVar-Mes[16] ~
PL-VARG.NomVar-Mes[17] PL-VARG.NomVar-Mes[18] PL-VARG.NomVar-Mes[19] ~
PL-VARG.NomVar-Mes[20] PL-VAR-MES.ValVar-MES[11] PL-VAR-MES.ValVar-MES[12] ~
PL-VAR-MES.ValVar-MES[13] PL-VAR-MES.ValVar-MES[14] ~
PL-VAR-MES.ValVar-MES[15] PL-VAR-MES.ValVar-MES[16] ~
PL-VAR-MES.ValVar-MES[17] PL-VAR-MES.ValVar-MES[18] ~
PL-VAR-MES.ValVar-MES[19] PL-VAR-MES.ValVar-MES[20] 

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

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77.86 BY 10.23.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Main FOR 
      PL-VAR-MES SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     PL-VARG.NomVar-Mes[1] AT ROW 1.69 COL 4.29 COLON-ALIGNED
          LABEL "1"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[2] AT ROW 2.65 COL 4.29 COLON-ALIGNED
          LABEL "2"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[3] AT ROW 3.62 COL 4.29 COLON-ALIGNED
          LABEL "3"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[4] AT ROW 4.54 COL 4.29 COLON-ALIGNED
          LABEL "4"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[5] AT ROW 5.5 COL 4.29 COLON-ALIGNED
          LABEL "5"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[6] AT ROW 6.46 COL 4.29 COLON-ALIGNED
          LABEL "6"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[7] AT ROW 7.38 COL 4.29 COLON-ALIGNED
          LABEL "7"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[8] AT ROW 8.35 COL 4.29 COLON-ALIGNED
          LABEL "8"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[9] AT ROW 9.31 COL 4.29 COLON-ALIGNED
          LABEL "9"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[10] AT ROW 10.23 COL 4.29 COLON-ALIGNED
          LABEL "10"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VAR-MES.ValVar-MES[1] AT ROW 1.69 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[2] AT ROW 2.65 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[3] AT ROW 3.62 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[4] AT ROW 4.54 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[5] AT ROW 5.5 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[6] AT ROW 6.46 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[7] AT ROW 7.38 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[8] AT ROW 8.35 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[9] AT ROW 9.31 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[10] AT ROW 10.23 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VARG.NomVar-Mes[11] AT ROW 1.69 COL 43.43 COLON-ALIGNED
          LABEL "11"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[12] AT ROW 2.65 COL 43.43 COLON-ALIGNED
          LABEL "12"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[13] AT ROW 3.62 COL 43.43 COLON-ALIGNED
          LABEL "13"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[14] AT ROW 4.54 COL 43.43 COLON-ALIGNED
          LABEL "14"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     PL-VARG.NomVar-Mes[15] AT ROW 5.5 COL 43.43 COLON-ALIGNED
          LABEL "15"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[16] AT ROW 6.46 COL 43.43 COLON-ALIGNED
          LABEL "16"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[17] AT ROW 7.38 COL 43.43 COLON-ALIGNED
          LABEL "17"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[18] AT ROW 8.35 COL 43.43 COLON-ALIGNED
          LABEL "18"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[19] AT ROW 9.31 COL 43.43 COLON-ALIGNED
          LABEL "19"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     PL-VARG.NomVar-Mes[20] AT ROW 10.23 COL 43.43 COLON-ALIGNED
          LABEL "20"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     B-ok AT ROW 11.96 COL 52.43
     PL-VAR-MES.ValVar-MES[11] AT ROW 1.69 COL 66.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[12] AT ROW 2.65 COL 66.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[13] AT ROW 3.62 COL 66.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[14] AT ROW 4.54 COL 66.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[15] AT ROW 5.5 COL 66.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[16] AT ROW 6.46 COL 66.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[17] AT ROW 7.38 COL 66.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[18] AT ROW 8.35 COL 66.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[19] AT ROW 9.31 COL 66.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     PL-VAR-MES.ValVar-MES[20] AT ROW 10.23 COL 66.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     B-cancel AT ROW 11.96 COL 67
     RECT-3 AT ROW 1.23 COL 1.72
     RECT-10 AT ROW 11.62 COL 1.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 79.57 BY 13.23
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
         TITLE              = "Variables Generales de Mes"
         HEIGHT             = 13.12
         WIDTH              = 79.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 82
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 82
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
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[10] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[11] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[12] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[13] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[14] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[15] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[16] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[17] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[18] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[19] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[20] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[2] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[3] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[4] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[5] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[6] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[7] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[8] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VARG.NomVar-Mes[9] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[10] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[11] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[12] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[13] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[14] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[15] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[16] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[17] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[18] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[19] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[20] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[3] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[4] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[5] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[6] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[7] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[8] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PL-VAR-MES.ValVar-MES[9] IN FRAME F-Main
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "integral.PL-VAR-MES"
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
ON END-ERROR OF W-Win /* Variables Generales de Mes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Variables Generales de Mes */
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
    FIND integral.PL-VAR-MES WHERE
         integral.PL-VAR-MES.Periodo = s-Periodo AND
         integral.PL-VAR-MES.NroMES = s-NroMes NO-ERROR.
         IF NOT AVAILABLE integral.PL-VAR-MES THEN DO:
         CREATE integral.PL-VAR-MES.
         ASSIGN
                integral.PL-VAR-MES.Periodo = s-Periodo
                integral.PL-VAR-MES.NroMes  = s-NroMes.
    END.
    DO i = 1 TO 20:
        ASSIGN integral.PL-VAR-MES.VALVAR-MES[i].
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
  IF AVAILABLE PL-VAR-MES THEN 
    DISPLAY PL-VAR-MES.ValVar-MES[1] PL-VAR-MES.ValVar-MES[2] 
          PL-VAR-MES.ValVar-MES[3] PL-VAR-MES.ValVar-MES[4] 
          PL-VAR-MES.ValVar-MES[5] PL-VAR-MES.ValVar-MES[6] 
          PL-VAR-MES.ValVar-MES[7] PL-VAR-MES.ValVar-MES[8] 
          PL-VAR-MES.ValVar-MES[9] PL-VAR-MES.ValVar-MES[10] 
          PL-VAR-MES.ValVar-MES[11] PL-VAR-MES.ValVar-MES[12] 
          PL-VAR-MES.ValVar-MES[13] PL-VAR-MES.ValVar-MES[14] 
          PL-VAR-MES.ValVar-MES[15] PL-VAR-MES.ValVar-MES[16] 
          PL-VAR-MES.ValVar-MES[17] PL-VAR-MES.ValVar-MES[18] 
          PL-VAR-MES.ValVar-MES[19] PL-VAR-MES.ValVar-MES[20] 
      WITH FRAME F-Main IN WINDOW W-Win.
  IF AVAILABLE PL-VARG THEN 
    DISPLAY PL-VARG.NomVar-Mes[1] PL-VARG.NomVar-Mes[2] PL-VARG.NomVar-Mes[3] 
          PL-VARG.NomVar-Mes[4] PL-VARG.NomVar-Mes[5] PL-VARG.NomVar-Mes[6] 
          PL-VARG.NomVar-Mes[7] PL-VARG.NomVar-Mes[8] PL-VARG.NomVar-Mes[9] 
          PL-VARG.NomVar-Mes[10] PL-VARG.NomVar-Mes[11] PL-VARG.NomVar-Mes[12] 
          PL-VARG.NomVar-Mes[13] PL-VARG.NomVar-Mes[14] PL-VARG.NomVar-Mes[15] 
          PL-VARG.NomVar-Mes[16] PL-VARG.NomVar-Mes[17] PL-VARG.NomVar-Mes[18] 
          PL-VARG.NomVar-Mes[19] PL-VARG.NomVar-Mes[20] 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-3 RECT-10 PL-VAR-MES.ValVar-MES[1] PL-VAR-MES.ValVar-MES[2] 
         PL-VAR-MES.ValVar-MES[3] PL-VAR-MES.ValVar-MES[4] 
         PL-VAR-MES.ValVar-MES[5] PL-VAR-MES.ValVar-MES[6] 
         PL-VAR-MES.ValVar-MES[7] PL-VAR-MES.ValVar-MES[8] 
         PL-VAR-MES.ValVar-MES[9] PL-VAR-MES.ValVar-MES[10] B-ok 
         PL-VAR-MES.ValVar-MES[11] PL-VAR-MES.ValVar-MES[12] 
         PL-VAR-MES.ValVar-MES[13] PL-VAR-MES.ValVar-MES[14] 
         PL-VAR-MES.ValVar-MES[15] PL-VAR-MES.ValVar-MES[16] 
         PL-VAR-MES.ValVar-MES[17] PL-VAR-MES.ValVar-MES[18] 
         PL-VAR-MES.ValVar-MES[19] PL-VAR-MES.ValVar-MES[20] B-cancel 
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
    FIND LAST integral.PL-VAR-MES WHERE
        integral.PL-VAR-MES.Periodo = s-Periodo AND
        integral.PL-VAR-MES.NroMes  = s-NroMes NO-ERROR.
    IF NOT AVAILABLE integral.PL-VAR-MES THEN DO:
        CREATE integral.PL-VAR-MES.
        ASSIGN
            integral.PL-VAR-MES.Periodo = s-Periodo
            integral.PL-VAR-MES.NroMes  = s-NroMes.
    END.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    IF PL-VARG.NOMVAR-MES[1] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[1]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[2] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[2]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[3] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[3]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[4] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[4]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[5] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[5]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[6] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[6]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[7] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[7]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[8] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[8]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[9] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[9]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[10] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[10]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[11] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[11]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[12] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[12]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[13] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[13]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[14] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[14]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[15] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[15]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[16] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[16]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[17] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[17]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[18] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[18]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[19] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[19]:SENSITIVE IN FRAME F-Main = FALSE.
    IF PL-VARG.NOMVAR-MES[20] = "" THEN
        ASSIGN integral.PL-VAR-MES.ValVar-MES[20]:SENSITIVE IN FRAME F-Main = FALSE.

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
  {src/adm/template/snd-list.i "PL-VAR-MES"}

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


