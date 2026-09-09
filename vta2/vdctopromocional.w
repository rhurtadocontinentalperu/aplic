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
DEFINE SHARED VAR s-user-id AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES VtaListaPrecios Almmmatg
&Scoped-define FIRST-EXTERNAL-TABLE VtaListaPrecios


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaListaPrecios, Almmmatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaListaPrecios.PromDivi[1] ~
VtaListaPrecios.PromFchD[1] VtaListaPrecios.PromFchH[1] ~
VtaListaPrecios.PromDto[1] VtaListaPrecios.PromDivi[2] ~
VtaListaPrecios.PromFchD[2] VtaListaPrecios.PromFchH[2] ~
VtaListaPrecios.PromDto[2] VtaListaPrecios.PromDivi[3] ~
VtaListaPrecios.PromFchD[3] VtaListaPrecios.PromFchH[3] ~
VtaListaPrecios.PromDto[3] VtaListaPrecios.PromDivi[4] ~
VtaListaPrecios.PromFchD[4] VtaListaPrecios.PromFchH[4] ~
VtaListaPrecios.PromDto[4] VtaListaPrecios.PromDivi[5] ~
VtaListaPrecios.PromFchD[5] VtaListaPrecios.PromFchH[5] ~
VtaListaPrecios.PromDto[5] VtaListaPrecios.PromDivi[6] ~
VtaListaPrecios.PromFchD[6] VtaListaPrecios.PromFchH[6] ~
VtaListaPrecios.PromDto[6] VtaListaPrecios.PromDivi[7] ~
VtaListaPrecios.PromFchD[7] VtaListaPrecios.PromFchH[7] ~
VtaListaPrecios.PromDto[7] VtaListaPrecios.PromDivi[8] ~
VtaListaPrecios.PromFchD[8] VtaListaPrecios.PromFchH[8] ~
VtaListaPrecios.PromDto[8] VtaListaPrecios.PromDivi[9] ~
VtaListaPrecios.PromFchD[9] VtaListaPrecios.PromFchH[9] ~
VtaListaPrecios.PromDto[9] VtaListaPrecios.PromDivi[10] ~
VtaListaPrecios.PromFchD[10] VtaListaPrecios.PromFchH[10] ~
VtaListaPrecios.PromDto[10] 
&Scoped-define ENABLED-TABLES VtaListaPrecios
&Scoped-define FIRST-ENABLED-TABLE VtaListaPrecios
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-64 RECT-65 
&Scoped-Define DISPLAYED-FIELDS VtaListaPrecios.codmat Almmmatg.UndBas ~
Almmmatg.DesMat VtaListaPrecios.PromDivi[1] VtaListaPrecios.PromFchD[1] ~
VtaListaPrecios.PromFchH[1] VtaListaPrecios.PromDto[1] ~
VtaListaPrecios.PromDivi[2] VtaListaPrecios.PromFchD[2] ~
VtaListaPrecios.PromFchH[2] VtaListaPrecios.PromDto[2] ~
VtaListaPrecios.PromDivi[3] VtaListaPrecios.PromFchD[3] ~
VtaListaPrecios.PromFchH[3] VtaListaPrecios.PromDto[3] ~
VtaListaPrecios.PromDivi[4] VtaListaPrecios.PromFchD[4] ~
VtaListaPrecios.PromFchH[4] VtaListaPrecios.PromDto[4] ~
VtaListaPrecios.PromDivi[5] VtaListaPrecios.PromFchD[5] ~
VtaListaPrecios.PromFchH[5] VtaListaPrecios.PromDto[5] ~
VtaListaPrecios.PromDivi[6] VtaListaPrecios.PromFchD[6] ~
VtaListaPrecios.PromFchH[6] VtaListaPrecios.PromDto[6] ~
VtaListaPrecios.PromDivi[7] VtaListaPrecios.PromFchD[7] ~
VtaListaPrecios.PromFchH[7] VtaListaPrecios.PromDto[7] ~
VtaListaPrecios.PromDivi[8] VtaListaPrecios.PromFchD[8] ~
VtaListaPrecios.PromFchH[8] VtaListaPrecios.PromDto[8] ~
VtaListaPrecios.PromDivi[9] VtaListaPrecios.PromFchD[9] ~
VtaListaPrecios.PromFchH[9] VtaListaPrecios.PromDto[9] ~
VtaListaPrecios.PromDivi[10] VtaListaPrecios.PromFchD[10] ~
VtaListaPrecios.PromFchH[10] VtaListaPrecios.PromDto[10] 
&Scoped-define DISPLAYED-TABLES VtaListaPrecios Almmmatg
&Scoped-define FIRST-DISPLAYED-TABLE VtaListaPrecios
&Scoped-define SECOND-DISPLAYED-TABLE Almmmatg
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
     VtaListaPrecios.codmat AT ROW 1.46 COL 1 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
          BGCOLOR 15 FGCOLOR 1 
     Almmmatg.UndBas AT ROW 1.46 COL 18.14 COLON-ALIGNED NO-LABEL WIDGET-ID 4 FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 1 
     Almmmatg.DesMat AT ROW 2.27 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 51.14 BY .69
          BGCOLOR 15 FGCOLOR 1 
     VtaListaPrecios.PromDivi[1] AT ROW 4.04 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     VtaListaPrecios.PromFchD[1] AT ROW 4.04 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromFchH[1] AT ROW 4.04 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromDto[1] AT ROW 4.04 COL 32.57 COLON-ALIGNED NO-LABEL FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-1 AT ROW 4.04 COL 41.72 COLON-ALIGNED NO-LABEL
     VtaListaPrecios.PromDivi[2] AT ROW 4.85 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     VtaListaPrecios.PromFchD[2] AT ROW 4.85 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromFchH[2] AT ROW 4.85 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromDto[2] AT ROW 4.85 COL 32.57 COLON-ALIGNED NO-LABEL FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-2 AT ROW 4.85 COL 41.72 COLON-ALIGNED NO-LABEL
     VtaListaPrecios.PromDivi[3] AT ROW 5.65 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     VtaListaPrecios.PromFchD[3] AT ROW 5.65 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromFchH[3] AT ROW 5.65 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromDto[3] AT ROW 5.65 COL 32.57 COLON-ALIGNED NO-LABEL FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-3 AT ROW 5.65 COL 41.72 COLON-ALIGNED NO-LABEL
     VtaListaPrecios.PromDivi[4] AT ROW 6.46 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     VtaListaPrecios.PromFchD[4] AT ROW 6.46 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromFchH[4] AT ROW 6.46 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromDto[4] AT ROW 6.46 COL 32.57 COLON-ALIGNED NO-LABEL FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-4 AT ROW 6.46 COL 41.72 COLON-ALIGNED NO-LABEL
     VtaListaPrecios.PromDivi[5] AT ROW 7.31 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     VtaListaPrecios.PromFchD[5] AT ROW 7.31 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromFchH[5] AT ROW 7.31 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     VtaListaPrecios.PromDto[5] AT ROW 7.31 COL 32.57 COLON-ALIGNED NO-LABEL FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-5 AT ROW 7.31 COL 41.72 COLON-ALIGNED NO-LABEL
     VtaListaPrecios.PromDivi[6] AT ROW 8.12 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     VtaListaPrecios.PromFchD[6] AT ROW 8.12 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromFchH[6] AT ROW 8.12 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromDto[6] AT ROW 8.12 COL 32.57 COLON-ALIGNED NO-LABEL FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-6 AT ROW 8.12 COL 41.72 COLON-ALIGNED NO-LABEL
     VtaListaPrecios.PromDivi[7] AT ROW 8.92 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     VtaListaPrecios.PromFchD[7] AT ROW 8.92 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromFchH[7] AT ROW 8.92 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromDto[7] AT ROW 8.92 COL 32.57 COLON-ALIGNED NO-LABEL FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-7 AT ROW 8.92 COL 41.72 COLON-ALIGNED NO-LABEL
     VtaListaPrecios.PromDivi[8] AT ROW 9.73 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     VtaListaPrecios.PromFchD[8] AT ROW 9.73 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromFchH[8] AT ROW 9.73 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromDto[8] AT ROW 9.73 COL 32.57 COLON-ALIGNED NO-LABEL FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-8 AT ROW 9.73 COL 41.72 COLON-ALIGNED NO-LABEL
     VtaListaPrecios.PromDivi[9] AT ROW 10.54 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     VtaListaPrecios.PromFchD[9] AT ROW 10.54 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromFchH[9] AT ROW 10.54 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromDto[9] AT ROW 10.54 COL 32.57 COLON-ALIGNED NO-LABEL FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-9 AT ROW 10.54 COL 41.72 COLON-ALIGNED NO-LABEL
     VtaListaPrecios.PromDivi[10] AT ROW 11.35 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     VtaListaPrecios.PromFchD[10] AT ROW 11.35 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaListaPrecios.PromFchH[10] AT ROW 11.35 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     VtaListaPrecios.PromDto[10] AT ROW 11.35 COL 32.57 COLON-ALIGNED NO-LABEL FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-10 AT ROW 11.35 COL 41.72 COLON-ALIGNED NO-LABEL
     "Precio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.31 COL 43.86
     "Descuento" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3.31 COL 34.29
     "Inicio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.23 COL 12.57
     "Fin" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.27 COL 23.72
     "Division" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.23 COL 3.57
     RECT-10 AT ROW 3.12 COL 2.72
     RECT-64 AT ROW 3.15 COL 2.86
     RECT-65 AT ROW 1.08 COL 1.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.VtaListaPrecios,INTEGRAL.Almmmatg
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
         HEIGHT             = 12.85
         WIDTH              = 56.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN VtaListaPrecios.codmat IN FRAME F-Main
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
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDivi[10] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDivi[1] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDivi[2] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDivi[3] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDivi[4] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDivi[5] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDivi[6] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDivi[7] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDivi[8] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDivi[9] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDto[10] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDto[1] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDto[2] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDto[3] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDto[4] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDto[5] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDto[6] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDto[7] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDto[8] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaListaPrecios.PromDto[9] IN FRAME F-Main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME F-PRECIO-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-1 V-table-Win
ON LEAVE OF F-PRECIO-1 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[1]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[1]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaPrecios.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-10 V-table-Win
ON LEAVE OF F-PRECIO-10 IN FRAME F-Main
DO:
   DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[10]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[10]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaPrecios.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-2 V-table-Win
ON LEAVE OF F-PRECIO-2 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[2]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaPrecios.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-3 V-table-Win
ON LEAVE OF F-PRECIO-3 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[3]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[3]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaPrecios.PreVta[1]  ) * 100, 4 ) ).
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-4 V-table-Win
ON LEAVE OF F-PRECIO-4 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[4]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[4]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaPrecios.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-5 V-table-Win
ON LEAVE OF F-PRECIO-5 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[5]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[5]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaPrecios.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-6 V-table-Win
ON LEAVE OF F-PRECIO-6 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[6]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[6]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[6]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[6]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaPrecios.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-7 V-table-Win
ON LEAVE OF F-PRECIO-7 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[7]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[7]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaPrecios.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-8 V-table-Win
ON LEAVE OF F-PRECIO-8 IN FRAME F-Main
DO:
   DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[8]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[8]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaPrecios.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-9 V-table-Win
ON LEAVE OF F-PRECIO-9 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[9]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[9]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaPrecios.PreVta[1]  ) * 100, 4 ) ).
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDivi[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDivi[10] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDivi[10] IN FRAME F-Main /* PromDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-10 = 0.
       DISPLAY F-PRECIO-10 
               0 @ VtaListaPrecios.PromDto[10].
/*                ? @ VtaListaPrecios.PromFchD[10]  */
/*                ? @ VtaListaPrecios.PromFchH[10]. */
       
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
       F-PRECIO-10 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(VtaListaPrecios.PromDto[10]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-10.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDivi[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDivi[1] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDivi[1] IN FRAME F-Main /* PromDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-1 = 0.
       ASSIGN
           VtaListaPrecios.PromDto[1]:SCREEN-VALUE = '0'
           VtaListaPrecios.PromFchD[1]:SCREEN-VALUE = ''
           VtaListaPrecios.PromFchH[1]:SCREEN-VALUE = ''.
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
       F-PRECIO-1 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(VtaListaPrecios.PromDto[1]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-1.
           
    END.  
 END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDivi[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDivi[2] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDivi[2] IN FRAME F-Main /* PromDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-2 = 0.
       DISPLAY F-PRECIO-2
               0 @ VtaListaPrecios.PromDto[2].
/*                ? @ VtaListaPrecios.PromFchD[2]   */
/*                ? @ VtaListaPrecios.PromFchH[2].  */
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
       F-PRECIO-2 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(VtaListaPrecios.PromDto[2]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-2.
           
    END.  
 END.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDivi[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDivi[3] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDivi[3] IN FRAME F-Main /* PromDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-3 = 0.
       DISPLAY F-PRECIO-3 
               0 @ VtaListaPrecios.PromDto[3].
/*                ? @ VtaListaPrecios.PromFchD[3]   */
/*                ? @ VtaListaPrecios.PromFchH[3].  */
       
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
       F-PRECIO-3 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(VtaListaPrecios.PromDto[3]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-3.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDivi[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDivi[4] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDivi[4] IN FRAME F-Main /* PromDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-4 = 0.
       DISPLAY F-PRECIO-4 
               0 @ VtaListaPrecios.PromDto[4].
/*                ? @ VtaListaPrecios.PromFchD[4]   */
/*                ? @ VtaListaPrecios.PromFchH[4].  */
       
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
       F-PRECIO-4 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(VtaListaPrecios.PromDto[4]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-4.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDivi[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDivi[5] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDivi[5] IN FRAME F-Main /* PromDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-5 = 0.
       DISPLAY F-PRECIO-5
               0 @ VtaListaPrecios.PromDto[5].
/*                ? @ VtaListaPrecios.PromFchD[5]  */
/*                ? @ VtaListaPrecios.PromFchH[5]. */
/*                                          */
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
       F-PRECIO-5 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(VtaListaPrecios.PromDto[5]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-5.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDivi[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDivi[6] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDivi[6] IN FRAME F-Main /* PromDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-6 = 0.
       DISPLAY F-PRECIO-6 
               0 @ VtaListaPrecios.PromDto[6].
/*                ? @ VtaListaPrecios.PromFchD[6]   */
/*                ? @ VtaListaPrecios.PromFchH[6].  */
       
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
       F-PRECIO-6 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(VtaListaPrecios.PromDto[6]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-6.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDivi[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDivi[7] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDivi[7] IN FRAME F-Main /* PromDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-7 = 0.
       DISPLAY F-PRECIO-7 
               0 @ VtaListaPrecios.PromDto[7].
/*                ? @ VtaListaPrecios.PromFchD[7]   */
/*                ? @ VtaListaPrecios.PromFchH[7].  */
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
       F-PRECIO-7 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(VtaListaPrecios.PromDto[7]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-7.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDivi[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDivi[8] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDivi[8] IN FRAME F-Main /* PromDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-8 = 0.
       DISPLAY F-PRECIO-8 
               0 @ VtaListaPrecios.PromDto[8].
/*                ? @ VtaListaPrecios.PromFchD[8]  */
/*                ? @ VtaListaPrecios.PromFchH[8]. */
/*        RETURN.                           */
    END.
    IF SELF:SCREEN-VALUE <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
          MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       F-PRECIO-8 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(VtaListaPrecios.PromDto[8]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-8.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDivi[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDivi[9] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDivi[9] IN FRAME F-Main /* PromDivi */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE = "" THEN DO:
       F-PRECIO-9 = 0.
       DISPLAY F-PRECIO-9 
               0 @ VtaListaPrecios.PromDto[9].
/*                ? @ VtaListaPrecios.PromFchD[9]   */
/*                ? @ VtaListaPrecios.PromFchH[9].  */
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
       F-PRECIO-9 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(VtaListaPrecios.PromDto[9]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-9.
           
    END.  
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDto[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDto[10] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDto[10] IN FRAME F-Main /* PromDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-10 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-10  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDto[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDto[1] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDto[1] IN FRAME F-Main /* PromDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-1 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-1  .
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDto[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDto[2] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDto[2] IN FRAME F-Main /* PromDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-2 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-2  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDto[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDto[3] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDto[3] IN FRAME F-Main /* PromDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-3 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-3  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDto[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDto[4] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDto[4] IN FRAME F-Main /* PromDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-4 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-4  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDto[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDto[5] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDto[5] IN FRAME F-Main /* PromDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-5 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-5  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDto[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDto[6] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDto[6] IN FRAME F-Main /* PromDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[6]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[6]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-6 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-6  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDto[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDto[7] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDto[7] IN FRAME F-Main /* PromDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-7 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-7  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDto[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDto[8] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDto[8] IN FRAME F-Main /* PromDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-8 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-8  .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromDto[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromDto[9] V-table-Win
ON LEAVE OF VtaListaPrecios.PromDto[9] IN FRAME F-Main /* PromDto */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF VtaListaPrecios.PromDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF VtaListaPrecios.PromDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-9 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-9 .

 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaPrecios.PromFchH[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaPrecios.PromFchH[10] V-table-Win
ON LEAVE OF VtaListaPrecios.PromFchH[10] IN FRAME F-Main /* PromFchH */
DO:
 DO WITH FRAME {&FRAME-NAME}:

 /*
    IF DATE(SELF:SCREEN-VALUE) <> ?= "" THEN DO:
       F-PRECIO-1 = 0.
       DECI(VtaListaPrecios.PromDto[1]:SCREEN-VALUE) = 0.
       DATE(VtaListaPrecios.PromFchD[1]:SCREEN-VALUE) = ?.
       DATE(VtaListaPrecios.PromFchH[1]:SCREEN-VALUE) = ?.
       DISPLAY F-PRECIO-1 VtaListaPrecios.PromDto[1] VtaListaPrecios.PromFchD[1] VtaListaPrecios.PromFchH[1].
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
       F-PRECIO-1 = ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( DECI(VtaListaPrecios.PromDto[1]:SCREEN-VALUE) / 100 ) ),4).
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
  {src/adm/template/row-list.i "VtaListaPrecios"}
  {src/adm/template/row-list.i "Almmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaListaPrecios"}
  {src/adm/template/row-find.i "Almmmatg"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Orden AS INT NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
        VtaListaPrecios.FchActualizacion = TODAY
        VtaListaPrecios.UsrActualizacion = s-user-id.
  DO x-Orden = 1 TO 10:
      IF VtaListaPrecios.PromDivi[x-Orden] = '' OR VtaListaPrecios.PromDto[x-Orden] = 0
      THEN ASSIGN
                VtaListaPrecios.PromDivi[x-Orden] = ''
                VtaListaPrecios.PromFchD[x-Orden] = ?
                VtaListaPrecios.PromFchH[x-Orden] = ?
                VtaListaPrecios.PromDto[x-Orden] = 0.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN lib/logtabla ('VtaListaPrecios', VtaListaPrecios.codmat, 'WRITE').   /* Log de cambios */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          F-PRECIO-1:SENSITIVE = NO
          F-PRECIO-10:SENSITIVE = NO
          F-PRECIO-2:SENSITIVE = NO
          F-PRECIO-3:SENSITIVE = NO
          F-PRECIO-4:SENSITIVE = NO
          F-PRECIO-5:SENSITIVE = NO
          F-PRECIO-6:SENSITIVE = NO
          F-PRECIO-7:SENSITIVE = NO
          F-PRECIO-8:SENSITIVE = NO
          F-PRECIO-9:SENSITIVE = NO.
  END.

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
  IF AVAILABLE VtaListaPrecios THEN DO WITH FRAME {&FRAME-NAME}:
     
     F-PRECIO-1 = IF PromDivi[1] <> "" THEN ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( PromDto[1] / 100 ) ),4) ELSE 0.     
     F-PRECIO-2 = IF PromDivi[2] <> "" THEN ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( PromDto[2] / 100 ) ),4) ELSE 0.
     F-PRECIO-3 = IF PromDivi[3] <> "" THEN ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( PromDto[3] / 100 ) ),4) ELSE 0.
     F-PRECIO-4 = IF PromDivi[4] <> "" THEN ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( PromDto[4] / 100 ) ),4) ELSE 0.
     F-PRECIO-5 = IF PromDivi[5] <> "" THEN ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( PromDto[5] / 100 ) ),4) ELSE 0.
     F-PRECIO-6 = IF PromDivi[6] <> "" THEN ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( PromDto[6] / 100 ) ),4) ELSE 0.
     F-PRECIO-7 = IF PromDivi[7] <> "" THEN ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( PromDto[7] / 100 ) ),4) ELSE 0.
     F-PRECIO-8 = IF PromDivi[8] <> "" THEN ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( PromDto[8] / 100 ) ),4) ELSE 0.
     F-PRECIO-9 = IF PromDivi[9] <> "" THEN ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( PromDto[9] / 100 ) ),4) ELSE 0.
     F-PRECIO-10 = IF PromDivi[10] <> "" THEN ROUND(VtaListaPrecios.Prevta[1] * ( 1 - ( PromDto[10] / 100 ) ),4) ELSE 0.
     
     DISPLAY F-PRECIO-1 F-PRECIO-2 F-PRECIO-3 F-PRECIO-4 F-PRECIO-5
             F-PRECIO-6 F-PRECIO-7 F-PRECIO-8 F-PRECIO-9 F-PRECIO-10.
     
  
  END.

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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          F-PRECIO-1:SENSITIVE = YES
          F-PRECIO-10:SENSITIVE = YES
          F-PRECIO-2:SENSITIVE = YES
          F-PRECIO-3:SENSITIVE = YES
          F-PRECIO-4:SENSITIVE = YES
          F-PRECIO-5:SENSITIVE = YES
          F-PRECIO-6:SENSITIVE = YES
          F-PRECIO-7:SENSITIVE = YES
          F-PRECIO-8:SENSITIVE = YES
          F-PRECIO-9:SENSITIVE = YES.
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
  {src/adm/template/snd-list.i "VtaListaPrecios"}
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

