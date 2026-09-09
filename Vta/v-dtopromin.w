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

DEFINE SHARED VAR S-CODCIA AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Almmmatg
&Scoped-define FIRST-EXTERNAL-TABLE Almmmatg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almmmatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almmmatg.PromMinDivi[1] ~
Almmmatg.PromMinFchD[1] Almmmatg.PromMinFchH[1] Almmmatg.PromMinDto[1] ~
Almmmatg.PromMinDivi[2] Almmmatg.PromMinFchD[2] Almmmatg.PromMinFchH[2] ~
Almmmatg.PromMinDto[2] Almmmatg.PromMinDivi[3] Almmmatg.PromMinFchD[3] ~
Almmmatg.PromMinFchH[3] Almmmatg.PromMinDto[3] Almmmatg.PromMinDivi[4] ~
Almmmatg.PromMinFchD[4] Almmmatg.PromMinFchH[4] Almmmatg.PromMinDto[4] ~
Almmmatg.PromMinDivi[5] Almmmatg.PromMinFchD[5] Almmmatg.PromMinFchH[5] ~
Almmmatg.PromMinDto[5] Almmmatg.PromMinDivi[6] Almmmatg.PromMinFchD[6] ~
Almmmatg.PromMinFchH[6] Almmmatg.PromMinDto[6] Almmmatg.PromMinDivi[7] ~
Almmmatg.PromMinFchD[7] Almmmatg.PromMinFchH[7] Almmmatg.PromMinDto[7] ~
Almmmatg.PromMinDivi[8] Almmmatg.PromMinFchD[8] Almmmatg.PromMinFchH[8] ~
Almmmatg.PromMinDto[8] Almmmatg.PromMinDivi[9] Almmmatg.PromMinFchD[9] ~
Almmmatg.PromMinFchH[9] Almmmatg.PromMinDto[9] Almmmatg.PromMinDivi[10] ~
Almmmatg.PromMinFchD[10] Almmmatg.PromMinFchH[10] Almmmatg.PromMinDto[10] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}PromMinDivi[1] ~{&FP2}PromMinDivi[1] ~{&FP3}~
 ~{&FP1}PromMinFchD[1] ~{&FP2}PromMinFchD[1] ~{&FP3}~
 ~{&FP1}PromMinFchH[1] ~{&FP2}PromMinFchH[1] ~{&FP3}~
 ~{&FP1}PromMinDto[1] ~{&FP2}PromMinDto[1] ~{&FP3}~
 ~{&FP1}PromMinDivi[2] ~{&FP2}PromMinDivi[2] ~{&FP3}~
 ~{&FP1}PromMinFchD[2] ~{&FP2}PromMinFchD[2] ~{&FP3}~
 ~{&FP1}PromMinFchH[2] ~{&FP2}PromMinFchH[2] ~{&FP3}~
 ~{&FP1}PromMinDto[2] ~{&FP2}PromMinDto[2] ~{&FP3}~
 ~{&FP1}PromMinDivi[3] ~{&FP2}PromMinDivi[3] ~{&FP3}~
 ~{&FP1}PromMinFchD[3] ~{&FP2}PromMinFchD[3] ~{&FP3}~
 ~{&FP1}PromMinFchH[3] ~{&FP2}PromMinFchH[3] ~{&FP3}~
 ~{&FP1}PromMinDto[3] ~{&FP2}PromMinDto[3] ~{&FP3}~
 ~{&FP1}PromMinDivi[4] ~{&FP2}PromMinDivi[4] ~{&FP3}~
 ~{&FP1}PromMinFchD[4] ~{&FP2}PromMinFchD[4] ~{&FP3}~
 ~{&FP1}PromMinFchH[4] ~{&FP2}PromMinFchH[4] ~{&FP3}~
 ~{&FP1}PromMinDto[4] ~{&FP2}PromMinDto[4] ~{&FP3}~
 ~{&FP1}PromMinDivi[5] ~{&FP2}PromMinDivi[5] ~{&FP3}~
 ~{&FP1}PromMinFchD[5] ~{&FP2}PromMinFchD[5] ~{&FP3}~
 ~{&FP1}PromMinFchH[5] ~{&FP2}PromMinFchH[5] ~{&FP3}~
 ~{&FP1}PromMinDto[5] ~{&FP2}PromMinDto[5] ~{&FP3}~
 ~{&FP1}PromMinDivi[6] ~{&FP2}PromMinDivi[6] ~{&FP3}~
 ~{&FP1}PromMinFchD[6] ~{&FP2}PromMinFchD[6] ~{&FP3}~
 ~{&FP1}PromMinFchH[6] ~{&FP2}PromMinFchH[6] ~{&FP3}~
 ~{&FP1}PromMinDto[6] ~{&FP2}PromMinDto[6] ~{&FP3}~
 ~{&FP1}PromMinDivi[7] ~{&FP2}PromMinDivi[7] ~{&FP3}~
 ~{&FP1}PromMinFchD[7] ~{&FP2}PromMinFchD[7] ~{&FP3}~
 ~{&FP1}PromMinFchH[7] ~{&FP2}PromMinFchH[7] ~{&FP3}~
 ~{&FP1}PromMinDto[7] ~{&FP2}PromMinDto[7] ~{&FP3}~
 ~{&FP1}PromMinDivi[8] ~{&FP2}PromMinDivi[8] ~{&FP3}~
 ~{&FP1}PromMinFchD[8] ~{&FP2}PromMinFchD[8] ~{&FP3}~
 ~{&FP1}PromMinFchH[8] ~{&FP2}PromMinFchH[8] ~{&FP3}~
 ~{&FP1}PromMinDto[8] ~{&FP2}PromMinDto[8] ~{&FP3}~
 ~{&FP1}PromMinDivi[9] ~{&FP2}PromMinDivi[9] ~{&FP3}~
 ~{&FP1}PromMinFchD[9] ~{&FP2}PromMinFchD[9] ~{&FP3}~
 ~{&FP1}PromMinFchH[9] ~{&FP2}PromMinFchH[9] ~{&FP3}~
 ~{&FP1}PromMinDto[9] ~{&FP2}PromMinDto[9] ~{&FP3}~
 ~{&FP1}PromMinDivi[10] ~{&FP2}PromMinDivi[10] ~{&FP3}~
 ~{&FP1}PromMinFchD[10] ~{&FP2}PromMinFchD[10] ~{&FP3}~
 ~{&FP1}PromMinFchH[10] ~{&FP2}PromMinFchH[10] ~{&FP3}~
 ~{&FP1}PromMinDto[10] ~{&FP2}PromMinDto[10] ~{&FP3}
&Scoped-define ENABLED-TABLES Almmmatg
&Scoped-define FIRST-ENABLED-TABLE Almmmatg
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-64 RECT-65 
&Scoped-Define DISPLAYED-FIELDS Almmmatg.PromMinDivi[1] ~
Almmmatg.PromMinFchD[1] Almmmatg.PromMinFchH[1] Almmmatg.PromMinDto[1] ~
Almmmatg.PromMinDivi[2] Almmmatg.PromMinFchD[2] Almmmatg.PromMinFchH[2] ~
Almmmatg.PromMinDto[2] Almmmatg.PromMinDivi[3] Almmmatg.PromMinFchD[3] ~
Almmmatg.PromMinFchH[3] Almmmatg.PromMinDto[3] Almmmatg.PromMinDivi[4] ~
Almmmatg.PromMinFchD[4] Almmmatg.PromMinFchH[4] Almmmatg.PromMinDto[4] ~
Almmmatg.PromMinDivi[5] Almmmatg.PromMinFchD[5] Almmmatg.PromMinFchH[5] ~
Almmmatg.PromMinDto[5] Almmmatg.PromMinDivi[6] Almmmatg.PromMinFchD[6] ~
Almmmatg.PromMinFchH[6] Almmmatg.PromMinDto[6] Almmmatg.PromMinDivi[7] ~
Almmmatg.PromMinFchD[7] Almmmatg.PromMinFchH[7] Almmmatg.PromMinDto[7] ~
Almmmatg.PromMinDivi[8] Almmmatg.PromMinFchD[8] Almmmatg.PromMinFchH[8] ~
Almmmatg.PromMinDto[8] Almmmatg.PromMinDivi[9] Almmmatg.PromMinFchD[9] ~
Almmmatg.PromMinFchH[9] Almmmatg.PromMinDto[9] Almmmatg.PromMinDivi[10] ~
Almmmatg.PromMinFchD[10] Almmmatg.PromMinFchH[10] Almmmatg.PromMinDto[10] ~
Almmmatg.codmat Almmmatg.DesMat Almmmatg.UndBas 
&Scoped-Define DISPLAYED-OBJECTS F-PRECIO-1 F-PRECIO-2 F-PRECIO-3 ~
F-PRECIO-4 F-PRECIO-5 F-PRECIO-6 F-PRECIO-7 F-PRECIO-8 F-PRECIO-9 ~
F-PRECIO-10 

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

DEFINE VARIABLE F-PRECIO-2 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
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
     SIZE 51.29 BY .85.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 51.43 BY 9.35.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53.57 BY 11.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almmmatg.PromMinDivi[1] AT ROW 4.12 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinFchD[1] AT ROW 4.12 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinFchH[1] AT ROW 4.04 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinDto[1] AT ROW 4.12 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinDivi[2] AT ROW 4.92 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinFchD[2] AT ROW 4.92 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinFchH[2] AT ROW 4.85 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinDto[2] AT ROW 4.92 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinDivi[3] AT ROW 5.73 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinFchD[3] AT ROW 5.73 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinFchH[3] AT ROW 5.65 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinDto[3] AT ROW 5.73 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinDivi[4] AT ROW 6.54 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinFchD[4] AT ROW 6.54 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinFchH[4] AT ROW 6.46 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinDto[4] AT ROW 6.54 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinDivi[5] AT ROW 7.35 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinFchD[5] AT ROW 7.35 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinFchH[5] AT ROW 7.31 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinDto[5] AT ROW 7.35 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinDivi[6] AT ROW 8.15 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinFchD[6] AT ROW 8.19 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinFchH[6] AT ROW 8.12 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinDto[6] AT ROW 8.15 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinDivi[7] AT ROW 8.96 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     Almmmatg.PromMinFchD[7] AT ROW 9 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinFchH[7] AT ROW 8.92 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinDto[7] AT ROW 8.96 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinDivi[8] AT ROW 9.77 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinFchD[8] AT ROW 9.81 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinFchH[8] AT ROW 9.73 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinDto[8] AT ROW 9.77 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinDivi[9] AT ROW 10.58 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinFchD[9] AT ROW 10.62 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinFchH[9] AT ROW 10.54 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinDto[9] AT ROW 10.58 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinDivi[10] AT ROW 11.42 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almmmatg.PromMinFchD[10] AT ROW 11.42 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinFchH[10] AT ROW 11.35 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.PromMinDto[10] AT ROW 11.42 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-1 AT ROW 4.12 COL 41.72 COLON-ALIGNED NO-LABEL
     F-PRECIO-2 AT ROW 4.96 COL 41.72 COLON-ALIGNED NO-LABEL
     F-PRECIO-3 AT ROW 5.77 COL 41.72 COLON-ALIGNED NO-LABEL
     F-PRECIO-4 AT ROW 6.58 COL 41.72 COLON-ALIGNED NO-LABEL
     F-PRECIO-5 AT ROW 7.38 COL 41.72 COLON-ALIGNED NO-LABEL
     F-PRECIO-6 AT ROW 8.19 COL 41.72 COLON-ALIGNED NO-LABEL
     F-PRECIO-7 AT ROW 9 COL 41.72 COLON-ALIGNED NO-LABEL
     F-PRECIO-8 AT ROW 9.81 COL 41.72 COLON-ALIGNED NO-LABEL
     F-PRECIO-9 AT ROW 10.62 COL 41.72 COLON-ALIGNED NO-LABEL
     F-PRECIO-10 AT ROW 11.5 COL 41.72 COLON-ALIGNED NO-LABEL
     Almmmatg.codmat AT ROW 1.46 COL 1 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
          BGCOLOR 15 FGCOLOR 1 
     Almmmatg.DesMat AT ROW 2.27 COL 1 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 51.14 BY .69
          BGCOLOR 15 FGCOLOR 1 
     Almmmatg.UndBas AT ROW 1.46 COL 18.14 COLON-ALIGNED NO-LABEL FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 1 
     RECT-10 AT ROW 3.12 COL 2.72
     RECT-64 AT ROW 3.15 COL 2.86
     RECT-65 AT ROW 1.08 COL 1.72
     "Descuento" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3.31 COL 34.29
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Inicio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.23 COL 12.57
     "Fin" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.27 COL 23.72
     "Division" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.23 COL 3.57
     "Precio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.31 COL 43.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almmmatg
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
         HEIGHT             = 11.73
         WIDTH              = 54.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almmmatg.codmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-2 IN FRAME F-Main
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
/* SETTINGS FOR FILL-IN Almmmatg.PromMinDivi[10] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almmmatg.PromMinDivi[1] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almmmatg.PromMinDivi[2] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almmmatg.PromMinDivi[3] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almmmatg.PromMinDivi[4] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almmmatg.PromMinDivi[5] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almmmatg.PromMinDivi[6] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almmmatg.PromMinDivi[7] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almmmatg.PromMinDivi[8] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almmmatg.PromMinDivi[9] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almmmatg.UndBas IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Almmmatg.PromMinDivi[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDivi[10] V-table-Win
ON LEAVE OF Almmmatg.PromMinDivi[10] IN FRAME F-Main /* PromMinDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-10 = 0.
       DISPLAY F-PRECIO-10 
               0 @ Almmmatg.PromMinDto[10]
               ? @ Almmmatg.PromMinFchD[10]
               ? @ Almmmatg.PromMinFchH[10].
       
       RETURN.
    END.
    IF SELF:SCREEN-VALUE <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
          MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       F-PRECIO-10 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(Almmmatg.PromMinDto[10]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-10.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDivi[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDivi[1] V-table-Win
ON LEAVE OF Almmmatg.PromMinDivi[1] IN FRAME F-Main /* PromMinDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-1 = 0.
       DISPLAY F-PRECIO-1 
               0 @ Almmmatg.PromMinDto[1]
               ? @ Almmmatg.PromMinFchD[1]
               ? @ Almmmatg.PromMinFchH[1].
       RETURN.
    END.
    IF SELF:SCREEN-VALUE <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
          MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       F-PRECIO-1 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(Almmmatg.PromMinDto[1]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-1.
           
    END.  
 END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDivi[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDivi[2] V-table-Win
ON LEAVE OF Almmmatg.PromMinDivi[2] IN FRAME F-Main /* PromMinDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-2 = 0.
       DISPLAY F-PRECIO-2
               0 @ Almmmatg.PromMinDto[2]
               ? @ Almmmatg.PromMinFchD[2]
               ? @ Almmmatg.PromMinFchH[2].
       RETURN.
    END.
    IF SELF:SCREEN-VALUE <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
          MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       F-PRECIO-2 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(Almmmatg.PromMinDto[2]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-2.
           
    END.  
 END.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDivi[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDivi[3] V-table-Win
ON LEAVE OF Almmmatg.PromMinDivi[3] IN FRAME F-Main /* PromMinDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-3 = 0.
       DISPLAY F-PRECIO-3 
               0 @ Almmmatg.PromMinDto[3]
               ? @ Almmmatg.PromMinFchD[3]
               ? @ Almmmatg.PromMinFchH[3].
       
       RETURN.
    END.
    IF SELF:SCREEN-VALUE <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
          MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       F-PRECIO-3 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(Almmmatg.PromMinDto[3]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-3.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDivi[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDivi[4] V-table-Win
ON LEAVE OF Almmmatg.PromMinDivi[4] IN FRAME F-Main /* PromMinDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-4 = 0.
       DISPLAY F-PRECIO-4 
               0 @ Almmmatg.PromMinDto[4]
               ? @ Almmmatg.PromMinFchD[4]
               ? @ Almmmatg.PromMinFchH[4].
       
       RETURN.
    END.
    IF SELF:SCREEN-VALUE <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
          MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       F-PRECIO-4 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(Almmmatg.PromMinDto[4]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-4.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDivi[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDivi[5] V-table-Win
ON LEAVE OF Almmmatg.PromMinDivi[5] IN FRAME F-Main /* PromMinDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-5 = 0.
       DISPLAY F-PRECIO-5
               0 @ Almmmatg.PromMinDto[5]
               ? @ Almmmatg.PromMinFchD[5]
               ? @ Almmmatg.PromMinFchH[5].

       RETURN.
    END.
    IF SELF:SCREEN-VALUE <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
          MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       F-PRECIO-5 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(Almmmatg.PromMinDto[5]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-5.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDivi[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDivi[6] V-table-Win
ON LEAVE OF Almmmatg.PromMinDivi[6] IN FRAME F-Main /* PromMinDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-6 = 0.
       DISPLAY F-PRECIO-6 
               0 @ Almmmatg.PromMinDto[6]
               ? @ Almmmatg.PromMinFchD[6]
               ? @ Almmmatg.PromMinFchH[6].
       
       RETURN.
    END.
    IF SELF:SCREEN-VALUE <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
          MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       F-PRECIO-6 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(Almmmatg.PromMinDto[6]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-6.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDivi[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDivi[7] V-table-Win
ON LEAVE OF Almmmatg.PromMinDivi[7] IN FRAME F-Main /* PromMinDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-7 = 0.
       DISPLAY F-PRECIO-7 
               0 @ Almmmatg.PromMinDto[7]
               ? @ Almmmatg.PromMinFchD[7]
               ? @ Almmmatg.PromMinFchH[7].
       RETURN.
    END.
    IF SELF:SCREEN-VALUE <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
          MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       F-PRECIO-7 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(Almmmatg.PromMinDto[7]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-7.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDivi[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDivi[8] V-table-Win
ON LEAVE OF Almmmatg.PromMinDivi[8] IN FRAME F-Main /* PromMinDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-8 = 0.
       DISPLAY F-PRECIO-8 
               0 @ Almmmatg.PromMinDto[8]
               ? @ Almmmatg.PromMinFchD[8]
               ? @ Almmmatg.PromMinFchH[8].
       RETURN.
    END.
    IF SELF:SCREEN-VALUE <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
          MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       F-PRECIO-8 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(Almmmatg.PromMinDto[8]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-8.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDivi[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDivi[9] V-table-Win
ON LEAVE OF Almmmatg.PromMinDivi[9] IN FRAME F-Main /* PromMinDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-9 = 0.
       DISPLAY F-PRECIO-9 
               0 @ Almmmatg.PromMinDto[9]
               ? @ Almmmatg.PromMinFchD[9]
               ? @ Almmmatg.PromMinFchH[9].
       RETURN.
    END.
    IF SELF:SCREEN-VALUE <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
          MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       F-PRECIO-9 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(Almmmatg.PromMinDto[9]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-9.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDto[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDto[10] V-table-Win
ON LEAVE OF Almmmatg.PromMinDto[10] IN FRAME F-Main /* PromMinDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF PromMinDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF PromMinDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-10 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-10  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDto[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDto[1] V-table-Win
ON LEAVE OF Almmmatg.PromMinDto[1] IN FRAME F-Main /* PromMinDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF PromMinDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF PromMinDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-1 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-1  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDto[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDto[2] V-table-Win
ON LEAVE OF Almmmatg.PromMinDto[2] IN FRAME F-Main /* PromMinDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF PromMinDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF PromMinDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-2 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-2  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDto[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDto[3] V-table-Win
ON LEAVE OF Almmmatg.PromMinDto[3] IN FRAME F-Main /* PromMinDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF PromMinDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF PromMinDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-3 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-3  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDto[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDto[4] V-table-Win
ON LEAVE OF Almmmatg.PromMinDto[4] IN FRAME F-Main /* PromMinDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF PromMinDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF PromMinDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-4 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-4  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDto[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDto[5] V-table-Win
ON LEAVE OF Almmmatg.PromMinDto[5] IN FRAME F-Main /* PromMinDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF PromMinDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF PromMinDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-5 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-5  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDto[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDto[6] V-table-Win
ON LEAVE OF Almmmatg.PromMinDto[6] IN FRAME F-Main /* PromMinDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF PromMinDivi[6]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF PromMinDivi[6]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-6 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-6  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDto[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDto[7] V-table-Win
ON LEAVE OF Almmmatg.PromMinDto[7] IN FRAME F-Main /* PromMinDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF PromMinDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF PromMinDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-7 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-7  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDto[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDto[8] V-table-Win
ON LEAVE OF Almmmatg.PromMinDto[8] IN FRAME F-Main /* PromMinDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF PromMinDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF PromMinDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-8 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-8  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinDto[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinDto[9] V-table-Win
ON LEAVE OF Almmmatg.PromMinDto[9] IN FRAME F-Main /* PromMinDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF PromMinDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF PromMinDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-9 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-9 .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PromMinFchH[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PromMinFchH[10] V-table-Win
ON LEAVE OF Almmmatg.PromMinFchH[10] IN FRAME F-Main /* PromMinFchH */
DO:
 DO WITH FRAME {&FRAME-NAME}:

 /*
    IF DATE(SELF:SCREEN-VALUE) <> ?= "" THEN DO:
       F-PRECIO-1 = 0.
       DECI(Almmmatg.PromMinDto[1]:SCREEN-VALUE) = 0.
       DATE(Almmmatg.PromMinFchD[1]:SCREEN-VALUE) = ?.
       DATE(Almmmatg.PromMinFchH[1]:SCREEN-VALUE) = ?.
       DISPLAY F-PRECIO-1 Almmmatg.PromMinDto[1] Almmmatg.PromMinFchD[1] Almmmatg.PromMinFchH[1].
       RETURN.
    END.
    IF SELF:SCREEN-VALUE <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
          MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       F-PRECIO-1 = ROUND(Almmmatg.Prevta[1] * ( 1 - ( DECI(Almmmatg.PromMinDto[1]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-1.
           
    END.  
 */
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
  {src/adm/template/row-list.i "Almmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almmmatg"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almmmatg THEN DO WITH FRAME {&FRAME-NAME}:
     
     F-PRECIO-1 = IF PromMinDivi[1] <> "" THEN ROUND(Almmmatg.PreAlt[1] * ( 1 - ( PromMinDto[1] / 100 ) ),4) ELSE 0.     
     F-PRECIO-2 = IF PromMinDivi[2] <> "" THEN ROUND(Almmmatg.PreAlt[1] * ( 1 - ( PromMinDto[2] / 100 ) ),4) ELSE 0.
     F-PRECIO-3 = IF PromMinDivi[3] <> "" THEN ROUND(Almmmatg.PreAlt[1] * ( 1 - ( PromMinDto[3] / 100 ) ),4) ELSE 0.
     F-PRECIO-4 = IF PromMinDivi[4] <> "" THEN ROUND(Almmmatg.PreAlt[1] * ( 1 - ( PromMinDto[4] / 100 ) ),4) ELSE 0.
     F-PRECIO-5 = IF PromMinDivi[5] <> "" THEN ROUND(Almmmatg.PreAlt[1] * ( 1 - ( PromMinDto[5] / 100 ) ),4) ELSE 0.
     F-PRECIO-6 = IF PromMinDivi[6] <> "" THEN ROUND(Almmmatg.PreAlt[1] * ( 1 - ( PromMinDto[6] / 100 ) ),4) ELSE 0.
     F-PRECIO-7 = IF PromMinDivi[7] <> "" THEN ROUND(Almmmatg.PreAlt[1] * ( 1 - ( PromMinDto[7] / 100 ) ),4) ELSE 0.
     F-PRECIO-8 = IF PromMinDivi[8] <> "" THEN ROUND(Almmmatg.PreAlt[1] * ( 1 - ( PromMinDto[8] / 100 ) ),4) ELSE 0.
     F-PRECIO-9 = IF PromMinDivi[9] <> "" THEN ROUND(Almmmatg.PreAlt[1] * ( 1 - ( PromMinDto[9] / 100 ) ),4) ELSE 0.
     F-PRECIO-10 = IF PromMinDivi[10] <> "" THEN ROUND(Almmmatg.PreAlt[1] * ( 1 - ( PromMinDto[10] / 100 ) ),4) ELSE 0.
     
     DISPLAY F-PRECIO-1 F-PRECIO-2 F-PRECIO-3 F-PRECIO-4 F-PRECIO-5
             F-PRECIO-6 F-PRECIO-7 F-PRECIO-8 F-PRECIO-9 F-PRECIO-10.
     
  
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
  {src/adm/template/snd-list.i "Almmmatg"}

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


