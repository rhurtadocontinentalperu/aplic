&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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

DEFINE VARIABLE lista-var-SEM AS CHARACTER NO-UNDO.
DEFINE VARIABLE lista-var-MES AS CHARACTER NO-UNDO.
DEFINE VARIABLE i         AS INTEGER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-VARG
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-VARG


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-VARG.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS integral.PL-VARG.NomVar-Sem[1] ~
integral.PL-VARG.NomVar-Sem[2] integral.PL-VARG.NomVar-Sem[3] ~
integral.PL-VARG.NomVar-Sem[4] integral.PL-VARG.NomVar-Sem[5] ~
integral.PL-VARG.NomVar-Sem[6] integral.PL-VARG.NomVar-Sem[7] ~
integral.PL-VARG.NomVar-Sem[8] integral.PL-VARG.NomVar-Sem[9] ~
integral.PL-VARG.NomVar-Sem[10] integral.PL-VARG.NomVar-Sem[11] ~
integral.PL-VARG.NomVar-Sem[12] integral.PL-VARG.NomVar-Sem[13] ~
integral.PL-VARG.NomVar-Sem[14] integral.PL-VARG.NomVar-Sem[15] ~
integral.PL-VARG.NomVar-Sem[16] integral.PL-VARG.NomVar-Sem[17] ~
integral.PL-VARG.NomVar-Sem[18] integral.PL-VARG.NomVar-Sem[19] ~
integral.PL-VARG.NomVar-Sem[20] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}NomVar-Sem[1] ~{&FP2}NomVar-Sem[1] ~{&FP3}~
 ~{&FP1}NomVar-Sem[2] ~{&FP2}NomVar-Sem[2] ~{&FP3}~
 ~{&FP1}NomVar-Sem[3] ~{&FP2}NomVar-Sem[3] ~{&FP3}~
 ~{&FP1}NomVar-Sem[4] ~{&FP2}NomVar-Sem[4] ~{&FP3}~
 ~{&FP1}NomVar-Sem[5] ~{&FP2}NomVar-Sem[5] ~{&FP3}~
 ~{&FP1}NomVar-Sem[6] ~{&FP2}NomVar-Sem[6] ~{&FP3}~
 ~{&FP1}NomVar-Sem[7] ~{&FP2}NomVar-Sem[7] ~{&FP3}~
 ~{&FP1}NomVar-Sem[8] ~{&FP2}NomVar-Sem[8] ~{&FP3}~
 ~{&FP1}NomVar-Sem[9] ~{&FP2}NomVar-Sem[9] ~{&FP3}~
 ~{&FP1}NomVar-Sem[10] ~{&FP2}NomVar-Sem[10] ~{&FP3}~
 ~{&FP1}NomVar-Sem[11] ~{&FP2}NomVar-Sem[11] ~{&FP3}~
 ~{&FP1}NomVar-Sem[12] ~{&FP2}NomVar-Sem[12] ~{&FP3}~
 ~{&FP1}NomVar-Sem[13] ~{&FP2}NomVar-Sem[13] ~{&FP3}~
 ~{&FP1}NomVar-Sem[14] ~{&FP2}NomVar-Sem[14] ~{&FP3}~
 ~{&FP1}NomVar-Sem[15] ~{&FP2}NomVar-Sem[15] ~{&FP3}~
 ~{&FP1}NomVar-Sem[16] ~{&FP2}NomVar-Sem[16] ~{&FP3}~
 ~{&FP1}NomVar-Sem[17] ~{&FP2}NomVar-Sem[17] ~{&FP3}~
 ~{&FP1}NomVar-Sem[18] ~{&FP2}NomVar-Sem[18] ~{&FP3}~
 ~{&FP1}NomVar-Sem[19] ~{&FP2}NomVar-Sem[19] ~{&FP3}~
 ~{&FP1}NomVar-Sem[20] ~{&FP2}NomVar-Sem[20] ~{&FP3}
&Scoped-define ENABLED-TABLES integral.PL-VARG
&Scoped-define FIRST-ENABLED-TABLE integral.PL-VARG
&Scoped-Define ENABLED-OBJECTS RECT-3 
&Scoped-Define DISPLAYED-FIELDS integral.PL-VARG.NomVar-Sem[1] ~
integral.PL-VARG.NomVar-Sem[2] integral.PL-VARG.NomVar-Sem[3] ~
integral.PL-VARG.NomVar-Sem[4] integral.PL-VARG.NomVar-Sem[5] ~
integral.PL-VARG.NomVar-Sem[6] integral.PL-VARG.NomVar-Sem[7] ~
integral.PL-VARG.NomVar-Sem[8] integral.PL-VARG.NomVar-Sem[9] ~
integral.PL-VARG.NomVar-Sem[10] integral.PL-VARG.NomVar-Sem[11] ~
integral.PL-VARG.NomVar-Sem[12] integral.PL-VARG.NomVar-Sem[13] ~
integral.PL-VARG.NomVar-Sem[14] integral.PL-VARG.NomVar-Sem[15] ~
integral.PL-VARG.NomVar-Sem[16] integral.PL-VARG.NomVar-Sem[17] ~
integral.PL-VARG.NomVar-Sem[18] integral.PL-VARG.NomVar-Sem[19] ~
integral.PL-VARG.NomVar-Sem[20] 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 69 BY 9.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     integral.PL-VARG.NomVar-Sem[1] AT ROW 1.35 COL 7.86 COLON-ALIGNED
          LABEL "1"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[2] AT ROW 2.23 COL 7.86 COLON-ALIGNED
          LABEL "2"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[3] AT ROW 3.15 COL 7.86 COLON-ALIGNED
          LABEL "3"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[4] AT ROW 4.04 COL 7.86 COLON-ALIGNED
          LABEL "4"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[5] AT ROW 4.96 COL 7.86 COLON-ALIGNED
          LABEL "5"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[6] AT ROW 5.85 COL 7.86 COLON-ALIGNED
          LABEL "6"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[7] AT ROW 6.73 COL 7.86 COLON-ALIGNED
          LABEL "7"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[8] AT ROW 7.65 COL 8 COLON-ALIGNED
          LABEL "8"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[9] AT ROW 8.54 COL 7.86 COLON-ALIGNED
          LABEL "9"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[10] AT ROW 9.46 COL 7.86 COLON-ALIGNED
          LABEL "10"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[11] AT ROW 1.35 COL 37.72 COLON-ALIGNED
          LABEL "11"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[12] AT ROW 2.23 COL 37.72 COLON-ALIGNED
          LABEL "12"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[13] AT ROW 3.15 COL 37.72 COLON-ALIGNED
          LABEL "13"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[14] AT ROW 4.04 COL 37.72 COLON-ALIGNED
          LABEL "14"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[15] AT ROW 4.96 COL 37.72 COLON-ALIGNED
          LABEL "15"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[16] AT ROW 5.85 COL 37.72 COLON-ALIGNED
          LABEL "16"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[17] AT ROW 6.73 COL 37.72 COLON-ALIGNED
          LABEL "17"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[18] AT ROW 7.65 COL 37.72 COLON-ALIGNED
          LABEL "18"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[19] AT ROW 8.54 COL 37.72 COLON-ALIGNED
          LABEL "19"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     integral.PL-VARG.NomVar-Sem[20] AT ROW 9.46 COL 37.72 COLON-ALIGNED
          LABEL "20"
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .81
     RECT-3 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.PL-VARG
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
         HEIGHT             = 9.5
         WIDTH              = 69.
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

/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[10] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[11] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[12] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[13] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[14] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[15] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[16] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[17] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[18] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[19] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[20] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[3] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[4] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[5] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[6] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[7] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[8] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN integral.PL-VARG.NomVar-Sem[9] IN FRAME F-Main
   EXP-LABEL                                                            */
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME integral.PL-VARG.NomVar-Sem[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-VARG.NomVar-Sem[1] V-table-Win
ON ANY-PRINTABLE OF integral.PL-VARG.NomVar-Sem[1] IN FRAME F-Main /* 1 */
,integral.PL-VARG.NomVar-Sem[2]
,integral.PL-VARG.NomVar-Sem[3]
,integral.PL-VARG.NomVar-Sem[4]
,integral.PL-VARG.NomVar-Sem[5]
,integral.PL-VARG.NomVar-Sem[6]
,integral.PL-VARG.NomVar-Sem[7]
,integral.PL-VARG.NomVar-Sem[8]
,integral.PL-VARG.NomVar-Sem[9]
,integral.PL-VARG.NomVar-Sem[10]
,integral.PL-VARG.NomVar-Sem[11]
,integral.PL-VARG.NomVar-Sem[12]
,integral.PL-VARG.NomVar-Sem[13]
,integral.PL-VARG.NomVar-Sem[14]
,integral.PL-VARG.NomVar-Sem[15]
,integral.PL-VARG.NomVar-Sem[16]
,integral.PL-VARG.NomVar-Sem[17]
,integral.PL-VARG.NomVar-Sem[18]
,integral.PL-VARG.NomVar-Sem[19]
,integral.PL-VARG.NomVar-Sem[20]
DO:
    IF R-INDEX( "abcdefghijklmnopqrstuvwxyz1234567890$&#%-_" ,
        CAPS( CHR( LASTKEY ) ) ) = 0 THEN DO:
        BELL.
        RETURN NO-APPLY.
    END.
    APPLY CAPS(CHR(LASTKEY)).
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-VARG.NomVar-Sem[1] V-table-Win
ON LEAVE OF integral.PL-VARG.NomVar-Sem[1] IN FRAME F-Main /* 1 */
,integral.PL-VARG.NomVar-Sem[2]
,integral.PL-VARG.NomVar-Sem[3]
,integral.PL-VARG.NomVar-Sem[4]
,integral.PL-VARG.NomVar-Sem[5]
,integral.PL-VARG.NomVar-Sem[6]
,integral.PL-VARG.NomVar-Sem[7]
,integral.PL-VARG.NomVar-Sem[8]
,integral.PL-VARG.NomVar-Sem[9]
,integral.PL-VARG.NomVar-Sem[10]
,integral.PL-VARG.NomVar-Sem[11]
,integral.PL-VARG.NomVar-Sem[12]
,integral.PL-VARG.NomVar-Sem[13]
,integral.PL-VARG.NomVar-Sem[14]
,integral.PL-VARG.NomVar-Sem[15]
,integral.PL-VARG.NomVar-Sem[16]
,integral.PL-VARG.NomVar-Sem[17]
,integral.PL-VARG.NomVar-Sem[18]
,integral.PL-VARG.NomVar-Sem[19]
,integral.PL-VARG.NomVar-Sem[20]
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    IF LOOKUP(SELF:SCREEN-VALUE,lista-var-MES) > 0 
    THEN DO:
        MESSAGE "Variable ya existe en Variables Mensuales" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.              
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[1]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[1]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 1" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[2]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[2]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 2" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[3]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[3]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 3" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[4]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[4]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 4" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[5]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[5]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 5" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[6]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[6]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 6" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[7]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[7]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 7" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[8]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[8]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 8" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[9]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[9]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 9" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[10]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[10]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 10" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[11]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[11]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 11" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[12]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[12]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 12" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[13]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[13]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 13" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[14]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[14]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 14" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[15]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[15]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 15" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[16]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[16]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 16" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[17]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[17]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 17" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[18]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[18]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 18" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[19]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[19]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 19" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  
    IF SELF:LABEL <> integral.PL-VARG.NomVar-Sem[20]:LABEL AND
       SELF:SCREEN-VALUE = integral.PL-VARG.NomVar-Sem[20]:SCREEN-VALUE
    THEN DO:
        MESSAGE "Variable se repite con la Variable 20" 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.                  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

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
  {src/adm/template/row-list.i "integral.PL-VARG"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-VARG"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    DO i = 1 TO 20:
        IF integral.PL-VARG.NomVar-Mes[i] <> "" THEN
            IF lista-var-MES = "" 
            THEN lista-var-MES = integral.PL-VARG.NomVar-Mes[i].
            ELSE lista-var-MES = lista-var-MES + "," + integral.PL-VARG.NomVar-Mes[i].
        IF integral.PL-VARG.NomVar-Sem[i] <> "" THEN
            IF lista-var-SEM = "" 
            THEN lista-var-SEM = integral.PL-VARG.NomVar-Sem[i].
            ELSE lista-var-SEM = lista-var-SEM + "," + integral.PL-VARG.NomVar-Sem[i].
    END.
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
  {src/adm/template/snd-list.i "integral.PL-VARG"}

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


