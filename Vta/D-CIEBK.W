&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-54 w-ano l-meses 
&Scoped-Define DISPLAYED-OBJECTS w-divi dia-1 dia-9 dia-17 dia-25 TOGGLE-4 ~
dia-2 dia-10 dia-18 dia-26 dia-3 dia-11 dia-19 dia-27 w-ano dia-4 dia-12 ~
dia-20 dia-28 dia-5 dia-13 dia-21 dia-29 dia-6 dia-14 dia-22 dia-30 l-meses ~
dia-7 dia-15 dia-23 dia-31 dia-8 dia-16 dia-24 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE l-meses AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     SIZE 10.14 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE w-ano AS INTEGER FORMAT "9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .77
     FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE w-divi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .65
     FGCOLOR 1 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-54
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL 
     SIZE 50.57 BY 6.77.

DEFINE VARIABLE dia-1 AS LOGICAL INITIAL no 
     LABEL "1" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-10 AS LOGICAL INITIAL no 
     LABEL "10" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-11 AS LOGICAL INITIAL no 
     LABEL "11" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-12 AS LOGICAL INITIAL no 
     LABEL "12" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-13 AS LOGICAL INITIAL no 
     LABEL "13" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-14 AS LOGICAL INITIAL no 
     LABEL "14" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-15 AS LOGICAL INITIAL no 
     LABEL "15" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-16 AS LOGICAL INITIAL no 
     LABEL "16" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-17 AS LOGICAL INITIAL no 
     LABEL "17" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-18 AS LOGICAL INITIAL no 
     LABEL "18" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-19 AS LOGICAL INITIAL no 
     LABEL "19" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-2 AS LOGICAL INITIAL no 
     LABEL "2" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-20 AS LOGICAL INITIAL no 
     LABEL "20" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-21 AS LOGICAL INITIAL no 
     LABEL "21" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-22 AS LOGICAL INITIAL no 
     LABEL "22" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-23 AS LOGICAL INITIAL no 
     LABEL "23" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-24 AS LOGICAL INITIAL no 
     LABEL "24" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-25 AS LOGICAL INITIAL no 
     LABEL "25" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-26 AS LOGICAL INITIAL no 
     LABEL "26" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-27 AS LOGICAL INITIAL no 
     LABEL "27" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-28 AS LOGICAL INITIAL no 
     LABEL "28" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-29 AS LOGICAL INITIAL no 
     LABEL "29" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-3 AS LOGICAL INITIAL no 
     LABEL "3" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-30 AS LOGICAL INITIAL no 
     LABEL "30" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-31 AS LOGICAL INITIAL no 
     LABEL "31" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-4 AS LOGICAL INITIAL no 
     LABEL "4" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-5 AS LOGICAL INITIAL no 
     LABEL "5" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-6 AS LOGICAL INITIAL no 
     LABEL "6" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-7 AS LOGICAL INITIAL no 
     LABEL "7" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-8 AS LOGICAL INITIAL no 
     LABEL "8" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE dia-9 AS LOGICAL INITIAL no 
     LABEL "9" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .69 NO-UNDO.

DEFINE VARIABLE TOGGLE-4 AS LOGICAL INITIAL yes 
     LABEL "Dias Cerrados" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.43 BY .77
     FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     w-divi AT ROW 1.38 COL 2.86 NO-LABEL
     dia-1 AT ROW 3.46 COL 5.14
     dia-9 AT ROW 4.92 COL 5.14
     dia-17 AT ROW 6.38 COL 5.14
     dia-25 AT ROW 7.92 COL 5.14
     TOGGLE-4 AT ROW 9.85 COL 4
     dia-2 AT ROW 3.46 COL 11.14
     dia-10 AT ROW 4.92 COL 11.14
     dia-18 AT ROW 6.38 COL 11.14
     dia-26 AT ROW 7.92 COL 11.14
     dia-3 AT ROW 3.46 COL 17.14
     dia-11 AT ROW 4.92 COL 17.14
     dia-19 AT ROW 6.38 COL 17.14
     dia-27 AT ROW 7.92 COL 17.14
     w-ano AT ROW 1.35 COL 19.72 COLON-ALIGNED NO-LABEL
     dia-4 AT ROW 3.42 COL 23.14
     dia-12 AT ROW 4.92 COL 23.14
     dia-20 AT ROW 6.38 COL 23.14
     dia-28 AT ROW 7.92 COL 23.14
     dia-5 AT ROW 3.42 COL 29.14
     dia-13 AT ROW 4.92 COL 29.14
     dia-21 AT ROW 6.38 COL 29.14
     dia-29 AT ROW 7.92 COL 29.14
     dia-6 AT ROW 3.42 COL 35.14
     dia-14 AT ROW 4.92 COL 35.14
     dia-22 AT ROW 6.38 COL 35.14
     dia-30 AT ROW 7.92 COL 35.14
     l-meses AT ROW 1.23 COL 38.57 COLON-ALIGNED NO-LABEL
     dia-7 AT ROW 3.42 COL 41.14
     dia-15 AT ROW 4.92 COL 41.14
     dia-23 AT ROW 6.38 COL 41.14
     dia-31 AT ROW 7.92 COL 41.14
     dia-8 AT ROW 3.46 COL 47.14
     dia-16 AT ROW 4.92 COL 47.14
     dia-24 AT ROW 6.38 COL 47.14
     "  Dias :" VIEW-AS TEXT
          SIZE 8.29 BY .65 AT ROW 2.42 COL 4.43
          FONT 6
     RECT-54 AT ROW 2.73 COL 2.86
     "1" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 3.54 COL 7.43
     "1" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 3.54 COL 7.72
     "9" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 5 COL 7.43
     "17" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.42 COL 7.43
     "25" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.96 COL 7.43
     "Dias Cerrados" VIEW-AS TEXT
          SIZE 12.72 BY .65 AT ROW 9.85 COL 7
          FONT 6
     "Periodo :" VIEW-AS TEXT
          SIZE 7.72 BY .62 AT ROW 1.42 COL 13.57
          FONT 6
     "2" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 3.54 COL 13.43
     "10" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 4.92 COL 13.43
     "18" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.42 COL 13.43
     "26" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.92 COL 13.43
     "3" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 3.54 COL 19.43
     "11" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 4.96 COL 19.43
     "19" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.46 COL 19.43
     "27" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.92 COL 19.43
     "4" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 3.5 COL 25.43
     "12" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 4.92 COL 25.43
     "20" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.42 COL 25.43
     "28" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.92 COL 25.43
     "Meses :" VIEW-AS TEXT
          SIZE 7.14 BY .73 AT ROW 1.35 COL 33
          FONT 6
     "5" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 3.5 COL 31.43
     "13" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 4.92 COL 31.43
     "21" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.42 COL 31.43
     "29" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.92 COL 31.43
     "6" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 3.5 COL 37.43
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Dialog-Frame
     "14" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 4.92 COL 37.43
     "22" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.42 COL 37.43
     "30" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.96 COL 37.43
     "7" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 3.5 COL 43.43
     "15" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 4.92 COL 43.43
     "23" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.42 COL 43.43
     "31" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.92 COL 43.43
     "8" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 3.54 COL 49.29
     "16" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 4.96 COL 49.29
     "24" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.38 COL 49.29
     SPACE(3.27) SKIP(3.87)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Cierres Diarios".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   Default                                                              */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX dia-1 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-10 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-11 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-12 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-13 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-14 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-15 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-16 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-17 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-18 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-19 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-2 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-20 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-21 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-22 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-23 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-24 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-25 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-26 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-27 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-28 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-29 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-3 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-30 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-31 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-4 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-5 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-6 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-7 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-8 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-9 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-4 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN w-divi IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Cierres Diarios */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-meses
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-meses Dialog-Frame
ON VALUE-CHANGED OF l-meses IN FRAME Dialog-Frame
DO:
  ASSIGN W-ANO L-MESES.
  RUN abrir-dat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

assign w-ano = year(today)
       w-divi = s-coddiv
       l-meses = string(month(today)).
run abrir-dat.    

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE abrir-dat Dialog-Frame 
PROCEDURE abrir-dat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DIA-1 = NO.
 DIA-2 = NO.
 DIA-3 = NO.
 DIA-4 = NO.
 DIA-5 = NO.
 DIA-6 = NO.
 DIA-7 = NO.
 DIA-8 = NO.
 DIA-9 = NO.
 DIA-10 = NO.
 DIA-11 = NO.
 DIA-12 = NO.
 DIA-13 = NO.
 DIA-14 = NO.
 DIA-15 = NO.
 DIA-16 = NO.
 DIA-17 = NO.
 DIA-18 = NO.
 DIA-19 = NO.
 DIA-20 = NO.
 DIA-21 = NO.
 DIA-22 = NO.
 DIA-23 = NO.
 DIA-24 = NO.
 DIA-25 = NO.
 DIA-26 = NO.
 DIA-27 = NO.
 DIA-28 = NO.
 DIA-29 = NO.
 DIA-30 = NO.
 DIA-31 = NO.
FOR EACH TADTCIE0 WHERE integral.TadtCie0.CieCia = S-CODCIA AND
    integral.TadtCie0.CieDiv = S-CODDIV AND integral.TadtCie0.CiaMes = INT(L-MESES) AND
    integral.TadtCie0.CiePerio = W-ANO:
        IF integral.TadtCie0.CieFlagc[1]  = "X" THEN DIA-1 = YES.
        IF integral.TadtCie0.CieFlagc[2]  = "X" THEN DIA-2 = YES.
        IF integral.TadtCie0.CieFlagc[3]  = "X" THEN DIA-3 = YES.
        IF integral.TadtCie0.CieFlagc[4]  = "X" THEN DIA-4 = YES.
        IF integral.TadtCie0.CieFlagc[5]  = "X" THEN DIA-5 = YES.
        IF integral.TadtCie0.CieFlagc[6]  = "X" THEN DIA-6 = YES.
        IF integral.TadtCie0.CieFlagc[7]  = "X" THEN DIA-7 = YES.
        IF integral.TadtCie0.CieFlagc[8]  = "X" THEN DIA-8 = YES.
        IF integral.TadtCie0.CieFlagc[9]  = "X" THEN DIA-9 = YES.
        IF integral.TadtCie0.CieFlagc[10] = "X" THEN DIA-10 = YES.
        IF integral.TadtCie0.CieFlagc[11] = "X" THEN DIA-11 = YES.
        IF integral.TadtCie0.CieFlagc[12] = "X" THEN DIA-12 = YES.
        IF integral.TadtCie0.CieFlagc[13] = "X" THEN DIA-13 = YES.
        IF integral.TadtCie0.CieFlagc[14] = "X" THEN DIA-14 = YES.
        IF integral.TadtCie0.CieFlagc[15] = "X" THEN DIA-15 = YES.
        IF integral.TadtCie0.CieFlagc[16] = "X" THEN DIA-16 = YES.
        IF integral.TadtCie0.CieFlagc[17] = "X" THEN DIA-17 = YES.
        IF integral.TadtCie0.CieFlagc[18] = "X" THEN DIA-18 = YES.
        IF integral.TadtCie0.CieFlagc[19] = "X" THEN DIA-19 = YES.
        IF integral.TadtCie0.CieFlagc[20] = "X" THEN DIA-20 = YES.
        IF integral.TadtCie0.CieFlagc[21] = "X" THEN DIA-21 = YES.
        IF integral.TadtCie0.CieFlagc[22] = "X" THEN DIA-22 = YES.
        IF integral.TadtCie0.CieFlagc[23] = "X" THEN DIA-23 = YES.
        IF integral.TadtCie0.CieFlagc[24] = "X" THEN DIA-24 = YES.
        IF integral.TadtCie0.CieFlagc[25] = "X" THEN DIA-25 = YES.
        IF integral.TadtCie0.CieFlagc[26] = "X" THEN DIA-26 = YES.
        IF integral.TadtCie0.CieFlagc[27] = "X" THEN DIA-27 = YES.
        IF integral.TadtCie0.CieFlagc[28] = "X" THEN DIA-28 = YES.
        IF integral.TadtCie0.CieFlagc[29] = "X" THEN DIA-29 = YES.
        IF integral.TadtCie0.CieFlagc[30] = "X" THEN DIA-30 = YES.
        IF integral.TadtCie0.CieFlagc[31] = "X" THEN DIA-31 = YES.

END.
DISPLAY DIA-1  WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-2  WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-3  WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-4  WITH FRAME {&FRAME-NAME}. 
DISPLAY DIA-5  WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-6  WITH FRAME {&FRAME-NAME}.         
DISPLAY DIA-7  WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-8  WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-9  WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-10 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-11 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-12 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-13 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-14 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-15 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-16 WITH FRAME {&FRAME-NAME}. 
DISPLAY DIA-17 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-18 WITH FRAME {&FRAME-NAME}.         
DISPLAY DIA-19 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-20 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-21 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-22 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-23 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-24 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-25 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-26 WITH FRAME {&FRAME-NAME}. 
DISPLAY DIA-27 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-28 WITH FRAME {&FRAME-NAME}.         
DISPLAY DIA-29 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-30 WITH FRAME {&FRAME-NAME}.
DISPLAY DIA-31 WITH FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame _DEFAULT-ENABLE
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
  DISPLAY w-divi dia-1 dia-9 dia-17 dia-25 TOGGLE-4 dia-2 dia-10 dia-18 dia-26 
          dia-3 dia-11 dia-19 dia-27 w-ano dia-4 dia-12 dia-20 dia-28 dia-5 
          dia-13 dia-21 dia-29 dia-6 dia-14 dia-22 dia-30 l-meses dia-7 dia-15 
          dia-23 dia-31 dia-8 dia-16 dia-24 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-54 w-ano l-meses 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


