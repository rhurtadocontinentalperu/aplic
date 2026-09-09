&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------
  File: 
  Description: from cntnrdlg.w - ADM SmartDialog Template
  Input Parameters:
      <none>
  Output Parameters:
      <none>
  Author: 
  Created: 
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
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.

DEFINE VARIABLE D-INIMES AS DATE.
DEFINE VARIABLE D-FINMES AS DATE.
DEFINE VARIABLE D-FchCie AS DATE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS w-ano l-meses FILL-IN-DiaCie Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS w-ano l-meses FILL-IN-DiaCie dia-1 dia-4 ~
dia-5 dia-6 dia-7 dia-8 dia-2 dia-3 dia-9 dia-10 dia-11 dia-12 dia-13 ~
dia-14 dia-15 dia-16 dia-17 dia-18 dia-19 dia-20 dia-21 dia-22 dia-23 ~
dia-24 dia-25 dia-26 dia-27 dia-28 dia-29 DTEXT-29 dia-30 dia-31 DTEXT-31 ~
DTEXT-30 TOGGLE-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\proces":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5.

DEFINE VARIABLE l-meses AS INTEGER FORMAT "99":U INITIAL 1 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS " 1"," 2"," 3"," 4"," 5"," 6"," 7"," 8"," 9","10","11","12" 
     SIZE 7.14 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE DTEXT-29 AS CHARACTER FORMAT "X(256)":U INITIAL "29" 
     VIEW-AS FILL-IN 
     SIZE 2.86 BY .62 NO-UNDO.

DEFINE VARIABLE DTEXT-30 AS CHARACTER FORMAT "X(256)":U INITIAL "30" 
     VIEW-AS FILL-IN 
     SIZE 2.86 BY .62 NO-UNDO.

DEFINE VARIABLE DTEXT-31 AS CHARACTER FORMAT "X(256)":U INITIAL "31" 
     VIEW-AS FILL-IN 
     SIZE 2.86 BY .62 NO-UNDO.

DEFINE VARIABLE FILL-IN-DiaCie AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Dia a Cerrar" 
     VIEW-AS FILL-IN 
     SIZE 3.86 BY .81 NO-UNDO.

DEFINE VARIABLE w-ano AS INTEGER FORMAT "9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .77
     FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-54
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.57 BY 6.77.

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

DEFINE FRAME D-Dialog
     w-ano AT ROW 1.19 COL 10.72 COLON-ALIGNED NO-LABEL
     l-meses AT ROW 1.19 COL 33.57 COLON-ALIGNED NO-LABEL
     FILL-IN-DiaCie AT ROW 2.65 COL 11 COLON-ALIGNED
     Btn_OK AT ROW 2.35 COL 20
     Btn_Cancel AT ROW 2.35 COL 34
     dia-1 AT ROW 4.96 COL 5.57
     dia-4 AT ROW 4.96 COL 20.43
     dia-5 AT ROW 4.96 COL 25.43
     dia-6 AT ROW 4.96 COL 30.43
     dia-7 AT ROW 4.96 COL 35.43
     dia-8 AT ROW 4.96 COL 40.43
     dia-2 AT ROW 5 COL 10.43
     dia-3 AT ROW 5 COL 15.57
     dia-9 AT ROW 6.42 COL 5.57
     dia-10 AT ROW 6.46 COL 10.43
     dia-11 AT ROW 6.46 COL 15.57
     dia-12 AT ROW 6.46 COL 20.43
     dia-13 AT ROW 6.46 COL 25.43
     dia-14 AT ROW 6.46 COL 30.43
     dia-15 AT ROW 6.46 COL 35.43
     dia-16 AT ROW 6.46 COL 40.43
     dia-17 AT ROW 7.88 COL 5.57
     dia-18 AT ROW 7.92 COL 10.43
     dia-19 AT ROW 7.92 COL 15.57
     dia-20 AT ROW 7.92 COL 20.43
     dia-21 AT ROW 7.92 COL 25.43
     dia-22 AT ROW 7.92 COL 30.43
     dia-23 AT ROW 7.92 COL 35.43
     dia-24 AT ROW 7.92 COL 40.43
     dia-25 AT ROW 9.42 COL 5.57
     dia-26 AT ROW 9.46 COL 10.43
     dia-27 AT ROW 9.46 COL 15.57
     dia-28 AT ROW 9.46 COL 20.43
     dia-29 AT ROW 9.46 COL 25.43
     DTEXT-29 AT ROW 9.46 COL 27.43 NO-LABEL
     dia-30 AT ROW 9.46 COL 30.43
     dia-31 AT ROW 9.46 COL 35.43
     DTEXT-31 AT ROW 9.46 COL 37.43 NO-LABEL
     DTEXT-30 AT ROW 9.5 COL 32.43 NO-LABEL
     TOGGLE-4 AT ROW 11.31 COL 5.57
     RECT-54 AT ROW 4.23 COL 3.29
     "19" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 8 COL 17.86
     "4" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 5.04 COL 22.72
     "27" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 9.46 COL 17.86
     "13" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.46 COL 27.72
     "8" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 5.12 COL 42.57
     "22" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.96 COL 32.72
     "17" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.92 COL 7.86
     "10" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.46 COL 12.72
     "9" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 6.5 COL 7.86
     "1" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 5.04 COL 8.14
     "Dias Cerrados" VIEW-AS TEXT
          SIZE 12.72 BY .65 AT ROW 11.31 COL 8.57
          FONT 6
     "20" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.96 COL 22.72
     "Periodo :" VIEW-AS TEXT
          SIZE 7.72 BY .62 AT ROW 1.19 COL 4.72
          FONT 6
     "18" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.96 COL 12.72
     "26" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 9.46 COL 12.72
     "21" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.96 COL 27.72
     "3" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 5.08 COL 17.86
     "11" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.5 COL 17.86
     "Meses :" VIEW-AS TEXT
          SIZE 7.14 BY .73 AT ROW 1.19 COL 28
          FONT 6
     "5" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 5.04 COL 27.72
     "16" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.54 COL 42.57
     "14" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.46 COL 32.72
     "1" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 5.04 COL 7.86
     "28" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 9.46 COL 22.72
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME D-Dialog
     "25" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 9.46 COL 7.86
     "12" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.46 COL 22.72
     "6" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 5.04 COL 32.72
     "2" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 5.08 COL 12.72
     "7" VIEW-AS TEXT
          SIZE 2.14 BY .54 AT ROW 5.04 COL 37.72
     "15" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 6.46 COL 37.72
     "23" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.96 COL 37.72
     "24" VIEW-AS TEXT
          SIZE 2.57 BY .62 AT ROW 7.96 COL 42.57
     "  Dias :" VIEW-AS TEXT
          SIZE 8.29 BY .65 AT ROW 4.08 COL 4.43
          FONT 6
     SPACE(34.56) SKIP(7.45)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Cierres Diarios de Almacen".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   Custom                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX dia-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-10 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-11 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-12 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-13 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-14 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-15 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-16 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-17 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-18 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-19 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-20 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-21 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-22 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-23 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-24 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-25 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-26 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-27 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-28 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-29 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-30 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-31 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX dia-9 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN DTEXT-29 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN DTEXT-30 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN DTEXT-31 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR RECTANGLE RECT-54 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Cierres Diarios de Almacen */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN FILL-IN-DiaCie l-meses w-ano.
  RUN Generar-Cierre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-DiaCie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-DiaCie D-Dialog
ON LEAVE OF FILL-IN-DiaCie IN FRAME D-Dialog /* Dia a Cerrar */
DO:
   ASSIGN FILL-IN-DiaCie l-meses w-ano.
   D-INIMES = DATE(l-meses,01,w-ano).
   D-FINMES = D-INIMES + 32 - DAY(D-INIMES + 32).
   IF FILL-IN-DiaCie > DAY(D-FINMES) THEN DO:
      MESSAGE "El dia no puede ser mayor a " DAY(D-FINMES) VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-meses
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-meses D-Dialog
ON VALUE-CHANGED OF l-meses IN FRAME D-Dialog
DO:
  ASSIGN W-ANO L-MESES.
  RUN abrir-dat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME w-ano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-ano D-Dialog
ON LEAVE OF w-ano IN FRAME D-Dialog
DO:
  ASSIGN W-ANO L-MESES.
  RUN abrir-dat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Abrir-Dat D-Dialog 
PROCEDURE Abrir-Dat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
D-INIMES = DATE(l-meses,01,w-ano).
D-FINMES = D-INIMES + 32 - DAY(D-INIMES + 32).
DO WITH FRAME {&FRAME-NAME}:
   DIA-29:VISIBLE = DAY(D-FINMES) > 28.
   DTEXT-29:VISIBLE = DAY(D-FINMES) > 28. 
   DIA-30:VISIBLE = DAY(D-FINMES) > 29.
   DTEXT-30:VISIBLE = DAY(D-FINMES) > 29. 
   DIA-31:VISIBLE = DAY(D-FINMES) > 30.
   DTEXT-31:VISIBLE = DAY(D-FINMES) > 30.
END.
 
 DIA-1  = NO.
 DIA-2  = NO.
 DIA-3  = NO.
 DIA-4  = NO.
 DIA-5  = NO.
 DIA-6  = NO.
 DIA-7  = NO.
 DIA-8  = NO.
 DIA-9  = NO.
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
FOR EACH AlmCierr WHERE 
         AlmCierr.CodCia = S-CODCIA   AND
         AlmCierr.FchCie >= D-INIMES  AND 
         AlmCierr.FchCie <= D-FINMES  :
    IF DAY(AlmCierr.FchCie) = 01 AND AlmCierr.FlgCie THEN DIA-1 = YES.
    IF DAY(AlmCierr.FchCie) = 02 AND AlmCierr.FlgCie THEN DIA-2 = YES.
    IF DAY(AlmCierr.FchCie) = 03 AND AlmCierr.FlgCie THEN DIA-3 = YES.
    IF DAY(AlmCierr.FchCie) = 04 AND AlmCierr.FlgCie THEN DIA-4 = YES.
    IF DAY(AlmCierr.FchCie) = 05 AND AlmCierr.FlgCie THEN DIA-5 = YES.
    IF DAY(AlmCierr.FchCie) = 06 AND AlmCierr.FlgCie THEN DIA-6 = YES.
    IF DAY(AlmCierr.FchCie) = 07 AND AlmCierr.FlgCie THEN DIA-7 = YES.
    IF DAY(AlmCierr.FchCie) = 08 AND AlmCierr.FlgCie THEN DIA-8 = YES.
    IF DAY(AlmCierr.FchCie) = 09 AND AlmCierr.FlgCie THEN DIA-9 = YES.
    IF DAY(AlmCierr.FchCie) = 10 AND AlmCierr.FlgCie THEN DIA-10 = YES.
    IF DAY(AlmCierr.FchCie) = 11 AND AlmCierr.FlgCie THEN DIA-11 = YES.
    IF DAY(AlmCierr.FchCie) = 12 AND AlmCierr.FlgCie THEN DIA-12 = YES.
    IF DAY(AlmCierr.FchCie) = 13 AND AlmCierr.FlgCie THEN DIA-13 = YES.
    IF DAY(AlmCierr.FchCie) = 14 AND AlmCierr.FlgCie THEN DIA-14 = YES.
    IF DAY(AlmCierr.FchCie) = 15 AND AlmCierr.FlgCie THEN DIA-15 = YES.
    IF DAY(AlmCierr.FchCie) = 16 AND AlmCierr.FlgCie THEN DIA-16 = YES.
    IF DAY(AlmCierr.FchCie) = 17 AND AlmCierr.FlgCie THEN DIA-17 = YES.
    IF DAY(AlmCierr.FchCie) = 18 AND AlmCierr.FlgCie THEN DIA-18 = YES.
    IF DAY(AlmCierr.FchCie) = 19 AND AlmCierr.FlgCie THEN DIA-19 = YES.
    IF DAY(AlmCierr.FchCie) = 20 AND AlmCierr.FlgCie THEN DIA-20 = YES.
    IF DAY(AlmCierr.FchCie) = 21 AND AlmCierr.FlgCie THEN DIA-21 = YES.
    IF DAY(AlmCierr.FchCie) = 22 AND AlmCierr.FlgCie THEN DIA-22 = YES.
    IF DAY(AlmCierr.FchCie) = 23 AND AlmCierr.FlgCie THEN DIA-23 = YES.
    IF DAY(AlmCierr.FchCie) = 24 AND AlmCierr.FlgCie THEN DIA-24 = YES.
    IF DAY(AlmCierr.FchCie) = 25 AND AlmCierr.FlgCie THEN DIA-25 = YES.
    IF DAY(AlmCierr.FchCie) = 26 AND AlmCierr.FlgCie THEN DIA-26 = YES.
    IF DAY(AlmCierr.FchCie) = 27 AND AlmCierr.FlgCie THEN DIA-27 = YES.
    IF DAY(AlmCierr.FchCie) = 28 AND AlmCierr.FlgCie THEN DIA-28 = YES.
    IF DAY(AlmCierr.FchCie) = 29 AND AlmCierr.FlgCie THEN DIA-29 = YES.
    IF DAY(AlmCierr.FchCie) = 30 AND AlmCierr.FlgCie THEN DIA-30 = YES.
    IF DAY(AlmCierr.FchCie) = 31 AND AlmCierr.FlgCie THEN DIA-31 = YES.

END.
DO WITH FRAME {&FRAME-NAME}:
   DISPLAY DIA-1  DIA-2  DIA-3  DIA-4  DIA-5  DIA-6  DIA-7  DIA-8  DIA-9  DIA-10 
           DIA-11 DIA-12 DIA-13 DIA-14 DIA-15 DIA-16 DIA-17 DIA-18 DIA-19 DIA-20 
           DIA-21 DIA-22 DIA-23 DIA-24 DIA-25 DIA-26 DIA-27 DIA-28.
   IF DAY(D-FINMES) > 28 THEN DISPLAY DIA-29.
   IF DAY(D-FINMES) > 29 THEN DISPLAY DIA-30.
   IF DAY(D-FINMES) > 30 THEN DISPLAY DIA-31. 
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY w-ano l-meses FILL-IN-DiaCie dia-1 dia-4 dia-5 dia-6 dia-7 dia-8 dia-2 
          dia-3 dia-9 dia-10 dia-11 dia-12 dia-13 dia-14 dia-15 dia-16 dia-17 
          dia-18 dia-19 dia-20 dia-21 dia-22 dia-23 dia-24 dia-25 dia-26 dia-27 
          dia-28 dia-29 DTEXT-29 dia-30 dia-31 DTEXT-31 DTEXT-30 TOGGLE-4 
      WITH FRAME D-Dialog.
  ENABLE w-ano l-meses FILL-IN-DiaCie Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Cierre D-Dialog 
PROCEDURE Generar-Cierre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE D-FchApe AS DATE.
D-FchApe = DATE(1,1,w-ano).
D-FchCie = DATE(l-meses,FILL-IN-DiaCie,w-ano).
FIND AlmCierr WHERE 
     AlmCierr.CodCia = S-CODCIA   AND
     AlmCierr.FchCie = D-FchCie - 1 NO-LOCK NO-ERROR.
IF NOT AVAILABLE AlmCierr AND D-FchCie <> D-FchApe THEN DO:
   MESSAGE "Debe cerrar el dia anterior" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
IF AVAILABLE AlmCierr AND NOT AlmCierr.FlgCie THEN DO:
   MESSAGE "Debe cerrar el dia anterior" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
FIND AlmCierr WHERE 
     AlmCierr.CodCia = S-CODCIA   AND
     AlmCierr.FchCie = D-FchCie EXCLUSIVE-LOCK NO-ERROR.
/*RHC 15.11.04
 * IF NOT AVAILABLE AlmCierr THEN DO:
 *    CREATE AlmCierr.
 *    ASSIGN AlmCierr.CodCia = S-CODCIA
 *           AlmCierr.FchCie = D-FchCie.
 * END.
 * ASSIGN AlmCierr.FlgCie = YES
 *        AlmCierr.UsuCierr = S-USER-ID.
 * RELEASE AlmCierr.       
 * */
IF NOT AVAILABLE AlmCierr
THEN DO:
    CREATE Almcierr.
    ASSIGN
        Almcierr.codcia = s-codcia
        Almcierr.fchcie = d-FchCie
        Almcierr.flgcie = YES
        Almcierr.usucierr = s-user-id.
END.
ELSE DO:
    ASSIGN
        Almcierr.flgcie = NOT Almcierr.flgcie   /* Si está cerrado lo abrimos y viceversa */
        Almcierr.usucierr = s-user-id.
END.
RELEASE Almcierr.

RUN abrir-dat.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  
  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN w-ano = year(today)
         l-meses = month(today)
         FILL-IN-DiaCie = DAY(TODAY).
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Abrir-Dat.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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


