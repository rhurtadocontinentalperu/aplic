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
&Scoped-define EXTERNAL-TABLES Almmmatp
&Scoped-define FIRST-EXTERNAL-TABLE Almmmatp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almmmatp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS almmmatp.PromDivi[1] almmmatp.PromFchD[1] ~
almmmatp.PromFchH[1] almmmatp.PromDto[1] almmmatp.PromDivi[2] ~
almmmatp.PromFchD[2] almmmatp.PromFchH[2] almmmatp.PromDto[2] ~
almmmatp.PromDivi[3] almmmatp.PromFchD[3] almmmatp.PromFchH[3] ~
almmmatp.PromDto[3] almmmatp.PromDivi[4] almmmatp.PromFchD[4] ~
almmmatp.PromFchH[4] almmmatp.PromDto[4] almmmatp.PromDivi[5] ~
almmmatp.PromFchD[5] almmmatp.PromFchH[5] almmmatp.PromDto[5] ~
almmmatp.PromDivi[6] almmmatp.PromFchD[6] almmmatp.PromFchH[6] ~
almmmatp.PromDto[6] almmmatp.PromDivi[7] almmmatp.PromFchD[7] ~
almmmatp.PromFchH[7] almmmatp.PromDto[7] almmmatp.PromDivi[8] ~
almmmatp.PromFchD[8] almmmatp.PromFchH[8] almmmatp.PromDto[8] ~
almmmatp.PromDivi[9] almmmatp.PromFchD[9] almmmatp.PromFchH[9] ~
almmmatp.PromDto[9] almmmatp.PromDivi[10] almmmatp.PromFchD[10] ~
almmmatp.PromFchH[10] almmmatp.PromDto[10] almmmatp.PromPrecio[1] ~
almmmatp.PromPrecio[2] almmmatp.PromPrecio[3] almmmatp.PromPrecio[4] ~
almmmatp.PromPrecio[5] almmmatp.PromPrecio[6] almmmatp.PromPrecio[7] ~
almmmatp.PromPrecio[8] almmmatp.PromPrecio[9] almmmatp.PromPrecio[10] 
&Scoped-define ENABLED-TABLES almmmatp
&Scoped-define FIRST-ENABLED-TABLE almmmatp
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-64 RECT-66 
&Scoped-Define DISPLAYED-FIELDS almmmatp.PromDivi[1] almmmatp.PromFchD[1] ~
almmmatp.PromFchH[1] almmmatp.PromDto[1] almmmatp.PromDivi[2] ~
almmmatp.PromFchD[2] almmmatp.PromFchH[2] almmmatp.PromDto[2] ~
almmmatp.PromDivi[3] almmmatp.PromFchD[3] almmmatp.PromFchH[3] ~
almmmatp.PromDto[3] almmmatp.PromDivi[4] almmmatp.PromFchD[4] ~
almmmatp.PromFchH[4] almmmatp.PromDto[4] almmmatp.PromDivi[5] ~
almmmatp.PromFchD[5] almmmatp.PromFchH[5] almmmatp.PromDto[5] ~
almmmatp.PromDivi[6] almmmatp.PromFchD[6] almmmatp.PromFchH[6] ~
almmmatp.PromDto[6] almmmatp.PromDivi[7] almmmatp.PromFchD[7] ~
almmmatp.PromFchH[7] almmmatp.PromDto[7] almmmatp.PromDivi[8] ~
almmmatp.PromFchD[8] almmmatp.PromFchH[8] almmmatp.PromDto[8] ~
almmmatp.PromDivi[9] almmmatp.PromFchD[9] almmmatp.PromFchH[9] ~
almmmatp.PromDto[9] almmmatp.PromDivi[10] almmmatp.PromFchD[10] ~
almmmatp.PromFchH[10] almmmatp.PromDto[10] almmmatp.codmat almmmatp.DesMat ~
almmmatp.UndBas almmmatp.PromPrecio[1] almmmatp.PromPrecio[2] ~
almmmatp.PromPrecio[3] almmmatp.PromPrecio[4] almmmatp.PromPrecio[5] ~
almmmatp.PromPrecio[6] almmmatp.PromPrecio[7] almmmatp.PromPrecio[8] ~
almmmatp.PromPrecio[9] almmmatp.PromPrecio[10] 
&Scoped-define DISPLAYED-TABLES almmmatp
&Scoped-define FIRST-DISPLAYED-TABLE almmmatp


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
DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 54.29 BY .85.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 54.14 BY 8.54.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 11.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     almmmatp.PromDivi[1] AT ROW 4.04 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromFchD[1] AT ROW 4.04 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromFchH[1] AT ROW 4.04 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromDto[1] AT ROW 4.04 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromDivi[2] AT ROW 4.85 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromFchD[2] AT ROW 4.85 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromFchH[2] AT ROW 4.85 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromDto[2] AT ROW 4.85 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromDivi[3] AT ROW 5.65 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromFchD[3] AT ROW 5.65 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromFchH[3] AT ROW 5.65 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromDto[3] AT ROW 5.65 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromDivi[4] AT ROW 6.46 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromFchD[4] AT ROW 6.46 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromFchH[4] AT ROW 6.46 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromDto[4] AT ROW 6.46 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromDivi[5] AT ROW 7.31 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromFchD[5] AT ROW 7.31 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromFchH[5] AT ROW 7.31 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromDto[5] AT ROW 7.31 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromDivi[6] AT ROW 8.12 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromFchD[6] AT ROW 8.12 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromFchH[6] AT ROW 8.12 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromDto[6] AT ROW 8.12 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromDivi[7] AT ROW 8.92 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromFchD[7] AT ROW 8.92 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     almmmatp.PromFchH[7] AT ROW 8.92 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromDto[7] AT ROW 8.92 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromDivi[8] AT ROW 9.73 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromFchD[8] AT ROW 9.73 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromFchH[8] AT ROW 9.73 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromDto[8] AT ROW 9.73 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromDivi[9] AT ROW 10.54 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromFchD[9] AT ROW 10.54 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromFchH[9] AT ROW 10.54 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromDto[9] AT ROW 10.54 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromDivi[10] AT ROW 11.35 COL 1.43 COLON-ALIGNED NO-LABEL FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.PromFchD[10] AT ROW 11.35 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromFchH[10] AT ROW 11.35 COL 21.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almmmatp.PromDto[10] AT ROW 11.35 COL 32.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almmmatp.codmat AT ROW 1.46 COL 1 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
          BGCOLOR 15 FGCOLOR 1 
     almmmatp.DesMat AT ROW 2.27 COL 1 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 51.14 BY .69
          BGCOLOR 15 FGCOLOR 1 
     almmmatp.UndBas AT ROW 1.46 COL 18.14 COLON-ALIGNED NO-LABEL FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 1 
     almmmatp.PromPrecio[1] AT ROW 4.04 COL 41.72 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.PromPrecio[2] AT ROW 4.85 COL 41.72 COLON-ALIGNED NO-LABEL WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.PromPrecio[3] AT ROW 5.65 COL 41.72 COLON-ALIGNED NO-LABEL WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.PromPrecio[4] AT ROW 6.46 COL 41.72 COLON-ALIGNED NO-LABEL WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.PromPrecio[5] AT ROW 7.31 COL 41.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.PromPrecio[6] AT ROW 8.12 COL 41.72 COLON-ALIGNED NO-LABEL WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     almmmatp.PromPrecio[7] AT ROW 8.92 COL 41.72 COLON-ALIGNED NO-LABEL WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.PromPrecio[8] AT ROW 9.73 COL 41.72 COLON-ALIGNED NO-LABEL WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.PromPrecio[9] AT ROW 10.54 COL 41.72 COLON-ALIGNED NO-LABEL WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.PromPrecio[10] AT ROW 11.35 COL 41.72 COLON-ALIGNED NO-LABEL WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     "Descuento" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3.31 COL 34.29
     "Inicio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.23 COL 12.57
     "Fin" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.27 COL 23.72
     "Division" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.23 COL 3.57
     "Precio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.31 COL 43.86
     RECT-10 AT ROW 3.12 COL 2.72
     RECT-64 AT ROW 3.96 COL 2.86
     RECT-66 AT ROW 1 COL 2 WIDGET-ID 22
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
         HEIGHT             = 11.73
         WIDTH              = 82.86.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN almmmatp.codmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN almmmatp.DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN almmmatp.PromDivi[10] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN almmmatp.PromDivi[1] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN almmmatp.PromDivi[2] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN almmmatp.PromDivi[3] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN almmmatp.PromDivi[4] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN almmmatp.PromDivi[5] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN almmmatp.PromDivi[6] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN almmmatp.PromDivi[7] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN almmmatp.PromDivi[8] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN almmmatp.PromDivi[9] IN FRAME F-Main
   EXP-FORMAT                                                           */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME almmmatp.PromDivi[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDivi[10] V-table-Win
ON LEAVE OF almmmatp.PromDivi[10] IN FRAME F-Main /* PromDivi */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF SELF:SCREEN-VALUE = "" THEN DO:
          ASSIGN 
              Almmmatp.PromDto[10]:SCREEN-VALUE = "0.0000"
              Almmmatp.PromPrecio[10]:SCREEN-VALUE = "0.0000"
              .
          RETURN.
      END.
      IF SELF:SCREEN-VALUE <> "" THEN DO:        
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
              Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
              MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
              SELF:SCREEN-VALUE = "".
              RETURN NO-APPLY.
          END.
          Almmmatp.PromPrecio[10]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(Almmmatp.PromDto[10]:SCREEN-VALUE) / 100 ) ),4)).
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDivi[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDivi[1] V-table-Win
ON LEAVE OF almmmatp.PromDivi[1] IN FRAME F-Main /* PromDivi */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF SELF:SCREEN-VALUE = "" THEN DO:
          ASSIGN 
              Almmmatp.PromDto[1]:SCREEN-VALUE = "0.0000"
              Almmmatp.PromPrecio[1]:SCREEN-VALUE = "0.0000"
              .
          RETURN.
      END.
      IF SELF:SCREEN-VALUE <> "" THEN DO:        
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
              Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
              MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
              SELF:SCREEN-VALUE = "".
              RETURN NO-APPLY.
          END.
          Almmmatp.PromPrecio[1]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(Almmmatp.PromDto[1]:SCREEN-VALUE) / 100 ) ),4)).
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDivi[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDivi[2] V-table-Win
ON LEAVE OF almmmatp.PromDivi[2] IN FRAME F-Main /* PromDivi */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF SELF:SCREEN-VALUE = "" THEN DO:
          ASSIGN 
              Almmmatp.PromDto[2]:SCREEN-VALUE = "0.0000"
              Almmmatp.PromPrecio[2]:SCREEN-VALUE = "0.0000"
              .
          RETURN.
      END.
      IF SELF:SCREEN-VALUE <> "" THEN DO:        
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
              Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
              MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
              SELF:SCREEN-VALUE = "".
              RETURN NO-APPLY.
          END.
          Almmmatp.PromPrecio[2]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(Almmmatp.PromDto[2]:SCREEN-VALUE) / 100 ) ),4)).
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDivi[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDivi[3] V-table-Win
ON LEAVE OF almmmatp.PromDivi[3] IN FRAME F-Main /* PromDivi */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF SELF:SCREEN-VALUE = "" THEN DO:
          ASSIGN 
              Almmmatp.PromDto[3]:SCREEN-VALUE = "0.0000"
              Almmmatp.PromPrecio[3]:SCREEN-VALUE = "0.0000"
              .
          RETURN.
      END.
      IF SELF:SCREEN-VALUE <> "" THEN DO:        
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
              Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
              MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
              SELF:SCREEN-VALUE = "".
              RETURN NO-APPLY.
          END.
          Almmmatp.PromPrecio[3]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(Almmmatp.PromDto[3]:SCREEN-VALUE) / 100 ) ),4)).
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDivi[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDivi[4] V-table-Win
ON LEAVE OF almmmatp.PromDivi[4] IN FRAME F-Main /* PromDivi */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF SELF:SCREEN-VALUE = "" THEN DO:
          ASSIGN 
              Almmmatp.PromDto[4]:SCREEN-VALUE = "0.0000"
              Almmmatp.PromPrecio[4]:SCREEN-VALUE = "0.0000"
              .
          RETURN.
      END.
      IF SELF:SCREEN-VALUE <> "" THEN DO:        
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
              Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
              MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
              SELF:SCREEN-VALUE = "".
              RETURN NO-APPLY.
          END.
          Almmmatp.PromPrecio[4]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(Almmmatp.PromDto[4]:SCREEN-VALUE) / 100 ) ),4)).
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDivi[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDivi[5] V-table-Win
ON LEAVE OF almmmatp.PromDivi[5] IN FRAME F-Main /* PromDivi */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF SELF:SCREEN-VALUE = "" THEN DO:
          ASSIGN 
              Almmmatp.PromDto[5]:SCREEN-VALUE = "0.0000"
              Almmmatp.PromPrecio[5]:SCREEN-VALUE = "0.0000"
              .
          RETURN.
      END.
      IF SELF:SCREEN-VALUE <> "" THEN DO:        
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
              Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
              MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
              SELF:SCREEN-VALUE = "".
              RETURN NO-APPLY.
          END.
          Almmmatp.PromPrecio[5]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(Almmmatp.PromDto[5]:SCREEN-VALUE) / 100 ) ),4)).
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDivi[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDivi[6] V-table-Win
ON LEAVE OF almmmatp.PromDivi[6] IN FRAME F-Main /* PromDivi */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF SELF:SCREEN-VALUE = "" THEN DO:
          ASSIGN 
              Almmmatp.PromDto[6]:SCREEN-VALUE = "0.0000"
              Almmmatp.PromPrecio[6]:SCREEN-VALUE = "0.0000"
              .
          RETURN.
      END.
      IF SELF:SCREEN-VALUE <> "" THEN DO:        
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
              Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
              MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
              SELF:SCREEN-VALUE = "".
              RETURN NO-APPLY.
          END.
          Almmmatp.PromPrecio[6]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(Almmmatp.PromDto[6]:SCREEN-VALUE) / 100 ) ),4)).
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDivi[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDivi[7] V-table-Win
ON LEAVE OF almmmatp.PromDivi[7] IN FRAME F-Main /* PromDivi */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF SELF:SCREEN-VALUE = "" THEN DO:
          ASSIGN 
              Almmmatp.PromDto[7]:SCREEN-VALUE = "0.0000"
              Almmmatp.PromPrecio[7]:SCREEN-VALUE = "0.0000"
              .
          RETURN.
      END.
      IF SELF:SCREEN-VALUE <> "" THEN DO:        
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
              Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
              MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
              SELF:SCREEN-VALUE = "".
              RETURN NO-APPLY.
          END.
          Almmmatp.PromPrecio[7]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(Almmmatp.PromDto[7]:SCREEN-VALUE) / 100 ) ),4)).
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDivi[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDivi[8] V-table-Win
ON LEAVE OF almmmatp.PromDivi[8] IN FRAME F-Main /* PromDivi */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF SELF:SCREEN-VALUE = "" THEN DO:
          ASSIGN 
              Almmmatp.PromDto[8]:SCREEN-VALUE = "0.0000"
              Almmmatp.PromPrecio[8]:SCREEN-VALUE = "0.0000"
              .
          RETURN.
      END.
      IF SELF:SCREEN-VALUE <> "" THEN DO:        
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
              Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
              MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
              SELF:SCREEN-VALUE = "".
              RETURN NO-APPLY.
          END.
          Almmmatp.PromPrecio[8]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(Almmmatp.PromDto[8]:SCREEN-VALUE) / 100 ) ),4)).
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDivi[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDivi[9] V-table-Win
ON LEAVE OF almmmatp.PromDivi[9] IN FRAME F-Main /* PromDivi */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF SELF:SCREEN-VALUE = "" THEN DO:
          ASSIGN 
              Almmmatp.PromDto[9]:SCREEN-VALUE = "0.0000"
              Almmmatp.PromPrecio[9]:SCREEN-VALUE = "0.0000"
              .
          RETURN.
      END.
      IF SELF:SCREEN-VALUE <> "" THEN DO:        
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
              Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
              MESSAGE "Division  No Existe " SKIP
                  "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
              SELF:SCREEN-VALUE = "".
              RETURN NO-APPLY.
          END.
          Almmmatp.PromPrecio[9]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(Almmmatp.PromDto[9]:SCREEN-VALUE) / 100 ) ),4)).
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDto[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDto[10] V-table-Win
ON LEAVE OF almmmatp.PromDto[10] IN FRAME F-Main /* PromDto */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF Almmmatp.PromDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF Almmmatp.PromDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      almmmatp.PromPrecio[10]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDto[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDto[1] V-table-Win
ON LEAVE OF almmmatp.PromDto[1] IN FRAME F-Main /* PromDto */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF Almmmatp.PromDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF Almmmatp.PromDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      almmmatp.PromPrecio[1]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDto[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDto[2] V-table-Win
ON LEAVE OF almmmatp.PromDto[2] IN FRAME F-Main /* PromDto */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF Almmmatp.PromDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF Almmmatp.PromDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      almmmatp.PromPrecio[2]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDto[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDto[3] V-table-Win
ON LEAVE OF almmmatp.PromDto[3] IN FRAME F-Main /* PromDto */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF Almmmatp.PromDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF Almmmatp.PromDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      almmmatp.PromPrecio[3]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDto[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDto[4] V-table-Win
ON LEAVE OF almmmatp.PromDto[4] IN FRAME F-Main /* PromDto */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF Almmmatp.PromDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF Almmmatp.PromDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      almmmatp.PromPrecio[4]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDto[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDto[5] V-table-Win
ON LEAVE OF almmmatp.PromDto[5] IN FRAME F-Main /* PromDto */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF Almmmatp.PromDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF Almmmatp.PromDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      almmmatp.PromPrecio[5]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDto[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDto[6] V-table-Win
ON LEAVE OF almmmatp.PromDto[6] IN FRAME F-Main /* PromDto */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF Almmmatp.PromDivi[6]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF Almmmatp.PromDivi[6]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      almmmatp.PromPrecio[6]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDto[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDto[7] V-table-Win
ON LEAVE OF almmmatp.PromDto[7] IN FRAME F-Main /* PromDto */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF Almmmatp.PromDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF Almmmatp.PromDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      almmmatp.PromPrecio[7]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDto[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDto[8] V-table-Win
ON LEAVE OF almmmatp.PromDto[8] IN FRAME F-Main /* PromDto */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF Almmmatp.PromDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF Almmmatp.PromDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      almmmatp.PromPrecio[8]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromDto[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromDto[9] V-table-Win
ON LEAVE OF almmmatp.PromDto[9] IN FRAME F-Main /* PromDto */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF Almmmatp.PromDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF Almmmatp.PromDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      almmmatp.PromPrecio[9]:SCREEN-VALUE = STRING(ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromFchH[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromFchH[10] V-table-Win
ON LEAVE OF almmmatp.PromFchH[10] IN FRAME F-Main /* PromFchH */
DO:
 DO WITH FRAME {&FRAME-NAME}:

 /*
    IF DATE(SELF:SCREEN-VALUE) <> ?= "" THEN DO:
       F-PRECIO-1 = 0.
       DECI(Almmmatp.PromDto[1]:SCREEN-VALUE) = 0.
       DATE(Almmmatp.PromFchD[1]:SCREEN-VALUE) = ?.
       DATE(Almmmatp.PromFchH[1]:SCREEN-VALUE) = ?.
       DISPLAY F-PRECIO-1 Almmmatp.PromDto[1] Almmmatp.PromFchD[1] Almmmatp.PromFchH[1].
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
       F-PRECIO-1 = ROUND(Almmmatp.PreOfi * ( 1 - ( DECI(Almmmatp.PromDto[1]:SCREEN-VALUE) / 100 ) ),4).
       DISPLAY F-PRECIO-1.
           
    END.  
 */
 END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromPrecio[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromPrecio[10] V-table-Win
ON LEAVE OF almmmatp.PromPrecio[10] IN FRAME F-Main /* PromPrecio */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF Almmmatp.PromDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF Almmmatp.PromDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = "0.0000".
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[10]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[10]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / Almmmatp.PreOfi  ) * 100, 4 ) ).
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromPrecio[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromPrecio[1] V-table-Win
ON LEAVE OF almmmatp.PromPrecio[1] IN FRAME F-Main /* PromPrecio */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF Almmmatp.PromDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF Almmmatp.PromDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = "0.0000".
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[1]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[1]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / Almmmatp.PreOfi  ) * 100, 4 ) ).
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromPrecio[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromPrecio[2] V-table-Win
ON LEAVE OF almmmatp.PromPrecio[2] IN FRAME F-Main /* PromPrecio */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF Almmmatp.PromDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF Almmmatp.PromDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = "0.0000".
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[2]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / Almmmatp.PreOfi  ) * 100, 4 ) ).
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromPrecio[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromPrecio[3] V-table-Win
ON LEAVE OF almmmatp.PromPrecio[3] IN FRAME F-Main /* PromPrecio */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF Almmmatp.PromDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF Almmmatp.PromDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = "0.0000".
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[3]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[3]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / Almmmatp.PreOfi  ) * 100, 4 ) ).
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromPrecio[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromPrecio[4] V-table-Win
ON LEAVE OF almmmatp.PromPrecio[4] IN FRAME F-Main /* PromPrecio */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF Almmmatp.PromDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF Almmmatp.PromDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = "0.0000".
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[4]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[4]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / Almmmatp.PreOfi  ) * 100, 4 ) ).
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromPrecio[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromPrecio[5] V-table-Win
ON LEAVE OF almmmatp.PromPrecio[5] IN FRAME F-Main /* PromPrecio */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF Almmmatp.PromDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF Almmmatp.PromDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = "0.0000".
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[5]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[5]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / Almmmatp.PreOfi  ) * 100, 4 ) ).
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromPrecio[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromPrecio[7] V-table-Win
ON LEAVE OF almmmatp.PromPrecio[7] IN FRAME F-Main /* PromPrecio */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF Almmmatp.PromDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF Almmmatp.PromDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = "0.0000".
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[7]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[7]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / Almmmatp.PreOfi  ) * 100, 4 ) ).
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromPrecio[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromPrecio[8] V-table-Win
ON LEAVE OF almmmatp.PromPrecio[8] IN FRAME F-Main /* PromPrecio */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF Almmmatp.PromDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF Almmmatp.PromDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = "0.0000".
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[8]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[8]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / Almmmatp.PreOfi  ) * 100, 4 ) ).
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.PromPrecio[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.PromPrecio[9] V-table-Win
ON LEAVE OF almmmatp.PromPrecio[9] IN FRAME F-Main /* PromPrecio */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF Almmmatp.PromDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF Almmmatp.PromDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = "0.0000".
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[9]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[9]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / Almmmatp.PreOfi  ) * 100, 4 ) ).
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
  Almmmatp.fchact = TODAY.
  DO x-Orden = 1 TO 10:
      IF Almmmatp.PromDivi[x-Orden] = '' OR Almmmatp.PromDto[x-Orden] = 0
      THEN ASSIGN
                Almmmatp.PromDivi[x-Orden] = ''
                Almmmatp.PromFchD[x-Orden] = ?
                Almmmatp.PromFchH[x-Orden] = ?
                Almmmatp.PromDto[x-Orden] = 0
                almmmatp.PromPrecio[x-Orden] = 0
                .
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN lib/logtabla ('Almmmatp', Almmmatp.codmat, 'WRITE').   /* Log de cambios */

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

