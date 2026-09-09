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
DEFINE VAR    I AS INTEGER NO-UNDO.

DEFINE VAR F-PRECIO AS DEC NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES VtaListaMay Almmmatg
&Scoped-define FIRST-EXTERNAL-TABLE VtaListaMay


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaListaMay, Almmmatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaListaMay.DtoVolR[1] VtaListaMay.DtoVolD[1] ~
VtaListaMay.DtoVolP[1] VtaListaMay.DtoVolR[2] VtaListaMay.DtoVolD[2] ~
VtaListaMay.DtoVolP[2] VtaListaMay.DtoVolR[3] VtaListaMay.DtoVolD[3] ~
VtaListaMay.DtoVolP[3] VtaListaMay.DtoVolR[4] VtaListaMay.DtoVolD[4] ~
VtaListaMay.DtoVolP[4] VtaListaMay.DtoVolR[5] VtaListaMay.DtoVolD[5] ~
VtaListaMay.DtoVolP[5] VtaListaMay.DtoVolR[6] VtaListaMay.DtoVolD[6] ~
VtaListaMay.DtoVolP[6] VtaListaMay.DtoVolR[7] VtaListaMay.DtoVolD[7] ~
VtaListaMay.DtoVolP[7] VtaListaMay.DtoVolR[8] VtaListaMay.DtoVolD[8] ~
VtaListaMay.DtoVolP[8] VtaListaMay.DtoVolR[9] VtaListaMay.DtoVolD[9] ~
VtaListaMay.DtoVolP[9] VtaListaMay.DtoVolR[10] VtaListaMay.DtoVolD[10] ~
VtaListaMay.DtoVolP[10] 
&Scoped-define ENABLED-TABLES VtaListaMay
&Scoped-define FIRST-ENABLED-TABLE VtaListaMay
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-13 
&Scoped-Define DISPLAYED-FIELDS VtaListaMay.codmat VtaListaMay.Chr__01 ~
Almmmatg.DesMat VtaListaMay.DtoVolR[1] VtaListaMay.DtoVolD[1] ~
VtaListaMay.DtoVolP[1] VtaListaMay.DtoVolR[2] VtaListaMay.DtoVolD[2] ~
VtaListaMay.DtoVolP[2] VtaListaMay.DtoVolR[3] VtaListaMay.DtoVolD[3] ~
VtaListaMay.DtoVolP[3] VtaListaMay.DtoVolR[4] VtaListaMay.DtoVolD[4] ~
VtaListaMay.DtoVolP[4] VtaListaMay.DtoVolR[5] VtaListaMay.DtoVolD[5] ~
VtaListaMay.DtoVolP[5] VtaListaMay.DtoVolR[6] VtaListaMay.DtoVolD[6] ~
VtaListaMay.DtoVolP[6] VtaListaMay.DtoVolR[7] VtaListaMay.DtoVolD[7] ~
VtaListaMay.DtoVolP[7] VtaListaMay.DtoVolR[8] VtaListaMay.DtoVolD[8] ~
VtaListaMay.DtoVolP[8] VtaListaMay.DtoVolR[9] VtaListaMay.DtoVolD[9] ~
VtaListaMay.DtoVolP[9] VtaListaMay.DtoVolR[10] VtaListaMay.DtoVolD[10] ~
VtaListaMay.DtoVolP[10] 
&Scoped-define DISPLAYED-TABLES VtaListaMay Almmmatg
&Scoped-define FIRST-DISPLAYED-TABLE VtaListaMay
&Scoped-define SECOND-DISPLAYED-TABLE Almmmatg
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 F-PRECIO-11 F-PRECIO-12 ~
F-PRECIO-13 F-PRECIO-14 F-PRECIO-15 F-PRECIO-16 F-PRECIO-17 F-PRECIO-18 ~
F-PRECIO-19 F-PRECIO-20 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPreVta V-table-Win 
FUNCTION fPreVta RETURNS DECIMAL
  ( INPUT pPreUni AS DECI, INPUT pMoneda AS INTE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-PRECIO-11 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-12 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-13 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-14 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-15 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-16 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-17 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-18 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-19 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-PRECIO-20 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 9 BY .5 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51.29 BY .85.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51.14 BY 9.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     VtaListaMay.codmat AT ROW 1.46 COL 1.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
          BGCOLOR 15 FGCOLOR 1 
     VtaListaMay.Chr__01 AT ROW 1.46 COL 18.14 COLON-ALIGNED NO-LABEL FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 1 
     Almmmatg.DesMat AT ROW 2.15 COL 3 NO-LABEL WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 41 BY .69
     FILL-IN-1 AT ROW 3.27 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     VtaListaMay.DtoVolR[1] AT ROW 4.19 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[1] AT ROW 4.19 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     VtaListaMay.DtoVolP[1] AT ROW 4.19 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     F-PRECIO-11 AT ROW 4.19 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     VtaListaMay.DtoVolR[2] AT ROW 5.04 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[2] AT ROW 5.04 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     VtaListaMay.DtoVolP[2] AT ROW 5.04 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     F-PRECIO-12 AT ROW 5.04 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     VtaListaMay.DtoVolR[3] AT ROW 5.85 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[3] AT ROW 5.85 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     VtaListaMay.DtoVolP[3] AT ROW 5.85 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     F-PRECIO-13 AT ROW 5.85 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     VtaListaMay.DtoVolR[4] AT ROW 6.65 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[4] AT ROW 6.65 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     VtaListaMay.DtoVolP[4] AT ROW 6.65 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     F-PRECIO-14 AT ROW 6.65 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     VtaListaMay.DtoVolR[5] AT ROW 7.46 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[5] AT ROW 7.46 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     VtaListaMay.DtoVolP[5] AT ROW 7.46 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     F-PRECIO-15 AT ROW 7.46 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     VtaListaMay.DtoVolR[6] AT ROW 8.27 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[6] AT ROW 8.27 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     VtaListaMay.DtoVolP[6] AT ROW 8.27 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     F-PRECIO-16 AT ROW 8.27 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     VtaListaMay.DtoVolR[7] AT ROW 9.08 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[7] AT ROW 9.08 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     VtaListaMay.DtoVolP[7] AT ROW 9.08 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     F-PRECIO-17 AT ROW 9.08 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     VtaListaMay.DtoVolR[8] AT ROW 9.88 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[8] AT ROW 9.88 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     VtaListaMay.DtoVolP[8] AT ROW 9.88 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     F-PRECIO-18 AT ROW 9.88 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     VtaListaMay.DtoVolR[9] AT ROW 10.69 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[9] AT ROW 10.69 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     VtaListaMay.DtoVolP[9] AT ROW 10.69 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     F-PRECIO-19 AT ROW 10.69 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     VtaListaMay.DtoVolR[10] AT ROW 11.58 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[10] AT ROW 11.58 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     VtaListaMay.DtoVolP[10] AT ROW 11.58 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     F-PRECIO-20 AT ROW 11.58 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     "Descuento %" VIEW-AS TEXT
          SIZE 10.86 BY .5 AT ROW 3.27 COL 18.57
     "Precio US$" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.27 COL 43 WIDGET-ID 30
     "Cantidad Minima" VIEW-AS TEXT
          SIZE 11.14 BY .5 AT ROW 3.27 COL 5.14
     RECT-10 AT ROW 3.12 COL 2.72
     RECT-13 AT ROW 3.15 COL 2.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.VtaListaMay,INTEGRAL.Almmmatg
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
         HEIGHT             = 12.81
         WIDTH              = 55.29.
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

/* SETTINGS FOR FILL-IN VtaListaMay.Chr__01 IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaListaMay.codmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DesMat IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-PRECIO-11 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-12 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-13 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-14 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-15 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-16 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-17 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-18 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-19 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PRECIO-20 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME VtaListaMay.DtoVolD[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolD[10] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolD[10] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(VtaListaMay.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolP[10]:SCREEN-VALUE = STRING(ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN VtaListaMay.DtoVolP[10]:SCREEN-VALUE = '0.0000'.
      F-PRECIO-20 = fPreVta(DECIMAL(VtaListaMay.DtoVolP[10]:SCREEN-VALUE), 2).
      DISPLAY F-PRECIO-20.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolD[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolD[1] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolD[1] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(VtaListaMay.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolP[1]:SCREEN-VALUE = STRING(ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN VtaListaMay.DtoVolP[1]:SCREEN-VALUE = '0.0000'.
      F-PRECIO-11 = fPreVta(DECIMAL(VtaListaMay.DtoVolP[1]:SCREEN-VALUE), 2).
      DISPLAY F-PRECIO-11.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolD[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolD[2] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolD[2] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(VtaListaMay.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolP[2]:SCREEN-VALUE = STRING(ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN VtaListaMay.DtoVolP[2]:SCREEN-VALUE = '0.0000'.
      F-PRECIO-12 = fPreVta(DECIMAL(VtaListaMay.DtoVolP[2]:SCREEN-VALUE), 2).
      DISPLAY F-PRECIO-12.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolD[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolD[3] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolD[3] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(VtaListaMay.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolP[3]:SCREEN-VALUE = STRING(ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN VtaListaMay.DtoVolP[3]:SCREEN-VALUE = '0.0000'.
      F-PRECIO-13 = fPreVta(DECIMAL(VtaListaMay.DtoVolP[3]:SCREEN-VALUE), 2).
      DISPLAY F-PRECIO-13.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolD[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolD[4] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolD[4] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(VtaListaMay.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolP[4]:SCREEN-VALUE = STRING(ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN VtaListaMay.DtoVolP[4]:SCREEN-VALUE = '0.0000'.
      F-PRECIO-14 = fPreVta(DECIMAL(VtaListaMay.DtoVolP[4]:SCREEN-VALUE), 2).
      DISPLAY F-PRECIO-14.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolD[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolD[5] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolD[5] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(VtaListaMay.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolP[5]:SCREEN-VALUE = STRING(ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN VtaListaMay.DtoVolP[5]:SCREEN-VALUE = '0.0000'.
      F-PRECIO-15 = fPreVta(DECIMAL(VtaListaMay.DtoVolP[5]:SCREEN-VALUE), 2).
      DISPLAY F-PRECIO-15.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolD[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolD[6] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolD[6] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(VtaListaMay.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolP[6]:SCREEN-VALUE = STRING(ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN VtaListaMay.DtoVolP[6]:SCREEN-VALUE = '0.0000'.
      F-PRECIO-16 = fPreVta(DECIMAL(VtaListaMay.DtoVolP[6]:SCREEN-VALUE), 2).
      DISPLAY F-PRECIO-16.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolD[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolD[7] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolD[7] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(VtaListaMay.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolP[7]:SCREEN-VALUE = STRING(ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN VtaListaMay.DtoVolP[7]:SCREEN-VALUE = '0.0000'.
      F-PRECIO-17 = fPreVta(DECIMAL(VtaListaMay.DtoVolP[7]:SCREEN-VALUE), 2).
      DISPLAY F-PRECIO-17.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolD[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolD[8] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolD[8] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(VtaListaMay.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolP[8]:SCREEN-VALUE = STRING(ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN VtaListaMay.DtoVolP[8]:SCREEN-VALUE = '0.0000'.
      F-PRECIO-18 = fPreVta(DECIMAL(VtaListaMay.DtoVolP[8]:SCREEN-VALUE), 2).
      DISPLAY F-PRECIO-18.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolD[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolD[9] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolD[9] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(VtaListaMay.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolP[9]:SCREEN-VALUE = STRING(ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4)).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN VtaListaMay.DtoVolP[9]:SCREEN-VALUE = '0.0000'.
      F-PRECIO-19 = fPreVta(DECIMAL(VtaListaMay.DtoVolP[9]:SCREEN-VALUE), 2).
      DISPLAY F-PRECIO-19.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolP[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolP[10] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolP[10] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolD[10]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 6 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[10]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[10]:SCREEN-VALUE = '0'.
      F-PRECIO-20 = fPreVta(DECIMAL(SELF:SCREEN-VALUE),2).
      DISPLAY F-PRECIO-20.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolP[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolP[1] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolP[1] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolD[1]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 6 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[1]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[1]:SCREEN-VALUE = '0'.
      F-PRECIO-11 = fPreVta(DECIMAL(SELF:SCREEN-VALUE),2).
      DISPLAY F-PRECIO-11.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolP[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolP[2] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolP[2] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolD[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 6 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[2]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[2]:SCREEN-VALUE = '0'.
      F-PRECIO-12 = fPreVta(DECIMAL(SELF:SCREEN-VALUE),2).
      DISPLAY F-PRECIO-12.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolP[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolP[3] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolP[3] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolD[3]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 6 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[3]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[3]:SCREEN-VALUE = '0'.
      F-PRECIO-13 = fPreVta(DECIMAL(SELF:SCREEN-VALUE),2).
      DISPLAY F-PRECIO-13.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolP[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolP[4] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolP[4] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolD[4]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 6 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[4]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[4]:SCREEN-VALUE = '0'.
      F-PRECIO-14 = fPreVta(DECIMAL(SELF:SCREEN-VALUE),2).
      DISPLAY F-PRECIO-14.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolP[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolP[5] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolP[5] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolD[5]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 6 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[5]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[5]:SCREEN-VALUE = '0'.
      F-PRECIO-15 = fPreVta(DECIMAL(SELF:SCREEN-VALUE),2).
      DISPLAY F-PRECIO-15.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolP[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolP[6] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolP[6] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolD[6]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 6 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[6]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[6]:SCREEN-VALUE = '0'.
      F-PRECIO-16 = fPreVta(DECIMAL(SELF:SCREEN-VALUE),2).
      DISPLAY F-PRECIO-16.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolP[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolP[7] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolP[7] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolD[7]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 6 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[7]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[7]:SCREEN-VALUE = '0'.
      F-PRECIO-17 = fPreVta(DECIMAL(SELF:SCREEN-VALUE),2).
      DISPLAY F-PRECIO-17.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolP[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolP[8] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolP[8] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolD[8]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 6 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[8]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[8]:SCREEN-VALUE = '0'.
      F-PRECIO-18 = fPreVta(DECIMAL(SELF:SCREEN-VALUE),2).
      DISPLAY F-PRECIO-18.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolP[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolP[9] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolP[9] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(VtaListaMay.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = "0.0000".
          RETURN NO-APPLY.
      END.
      VtaListaMay.DtoVolD[9]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 6 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[9]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[9]:SCREEN-VALUE = '0'.
      F-PRECIO-19 = fPreVta(DECIMAL(SELF:SCREEN-VALUE),2).
      DISPLAY F-PRECIO-19.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolR[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolR[10] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolR[10] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ VtaListaMay.DtoVolP[10] 0 @ VtaListaMay.DtoVolD[10] 0 @ F-PRECIO-20.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolR[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolR[1] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolR[1] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ VtaListaMay.DtoVolP[1] 0 @ VtaListaMay.DtoVolD[1] 0 @ F-PRECIO-11.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolR[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolR[2] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolR[2] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ VtaListaMay.DtoVolP[2] 0 @ VtaListaMay.DtoVolD[2] 0 @ F-PRECIO-12.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolR[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolR[3] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolR[3] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ VtaListaMay.DtoVolP[3] 0 @ VtaListaMay.DtoVolD[3] 0 @ F-PRECIO-13.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolR[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolR[4] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolR[4] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ VtaListaMay.DtoVolP[4] 0 @ VtaListaMay.DtoVolD[4] 0 @ F-PRECIO-14.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolR[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolR[5] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolR[5] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ VtaListaMay.DtoVolP[5] 0 @ VtaListaMay.DtoVolD[5] 0 @ F-PRECIO-15.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolR[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolR[6] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolR[6] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ VtaListaMay.DtoVolP[6] 0 @ VtaListaMay.DtoVolD[6] 0 @ F-PRECIO-16.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolR[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolR[7] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolR[7] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ VtaListaMay.DtoVolP[7] 0 @ VtaListaMay.DtoVolD[7] 0 @ F-PRECIO-17.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolR[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolR[8] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolR[8] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ VtaListaMay.DtoVolP[8] 0 @ VtaListaMay.DtoVolD[8] 0 @ F-PRECIO-18.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.DtoVolR[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.DtoVolR[9] V-table-Win
ON LEAVE OF VtaListaMay.DtoVolR[9] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ VtaListaMay.DtoVolP[9] 0 @ VtaListaMay.DtoVolD[9] 0 @ F-PRECIO-19.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-11 V-table-Win
ON LEAVE OF F-PRECIO-11 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[1]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[1]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[1]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-12 V-table-Win
ON LEAVE OF F-PRECIO-12 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[2]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[2]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-13 V-table-Win
ON LEAVE OF F-PRECIO-13 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[2]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[2]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-14 V-table-Win
ON LEAVE OF F-PRECIO-14 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[2]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[2]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-15 V-table-Win
ON LEAVE OF F-PRECIO-15 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[2]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[2]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-16 V-table-Win
ON LEAVE OF F-PRECIO-16 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[2]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[2]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-17
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-17 V-table-Win
ON LEAVE OF F-PRECIO-17 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[2]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[2]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-18
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-18 V-table-Win
ON LEAVE OF F-PRECIO-18 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[2]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[2]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-19
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-19 V-table-Win
ON LEAVE OF F-PRECIO-19 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[2]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[2]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-20 V-table-Win
ON LEAVE OF F-PRECIO-20 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[2]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[2]:SCREEN-VALUE = '0'.
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
  {src/adm/template/row-list.i "VtaListaMay"}
  {src/adm/template/row-list.i "Almmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaListaMay"}
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
  VtaListaMay.fchact = TODAY.
  DO x-Orden = 1 TO 10:
      IF VtaListaMay.DtoVolR[x-Orden] = 0 OR VtaListaMay.DtoVolD[x-Orden] = 0
      THEN ASSIGN
                VtaListaMay.DtoVolR[x-Orden] = 0
                VtaListaMay.DtoVolD[x-Orden] = 0
                VtaListaMay.DtoVolP[x-Orden] = 0.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN lib/logtabla ('VtaListaMay', VtaListaMay.codmat, 'WRITE').   /* Log de cambios */

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
  IF AVAILABLE Almmmatg THEN DO:
      IF Almmmatg.MonVta = 1 THEN FILL-IN-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Precio S/.".
      ELSE FILL-IN-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Precio US$".
  END.
  
  IF AVAILABLE VtaListaMay THEN DO WITH FRAME {&FRAME-NAME}:
      F-PRECIO = VtaListaMay.PreOfi.
      F-PRECIO-11 = fPreVta(VtaListaMay.DtoVolP[1],2).
      F-PRECIO-12 = fPreVta(VtaListaMay.DtoVolP[2],2).
      F-PRECIO-13 = fPreVta(VtaListaMay.DtoVolP[3],2).
      F-PRECIO-14 = fPreVta(VtaListaMay.DtoVolP[4],2).
      F-PRECIO-15 = fPreVta(VtaListaMay.DtoVolP[5],2).
      F-PRECIO-16 = fPreVta(VtaListaMay.DtoVolP[6],2).
      F-PRECIO-17 = fPreVta(VtaListaMay.DtoVolP[7],2).
      F-PRECIO-18 = fPreVta(VtaListaMay.DtoVolP[8],2).
      F-PRECIO-19 = fPreVta(VtaListaMay.DtoVolP[9],2).
      F-PRECIO-20 = fPreVta(VtaListaMay.DtoVolP[10],2).
      DISPLAY F-PRECIO-11 F-PRECIO-12 F-PRECIO-13 F-PRECIO-14 F-PRECIO-15 F-PRECIO-16 F-PRECIO-17 F-PRECIO-18 F-PRECIO-19 F-PRECIO-20.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Margen-de-Utilidad V-table-Win 
PROCEDURE Margen-de-Utilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pPreUni AS DEC.
DEF INPUT PARAMETER pUndVta AS CHAR.
DEF INPUT PARAMETER pTpoCmb AS DEC.
DEF OUTPUT PARAMETER x-Limite AS DEC.
DEF OUTPUT PARAMETER pError AS CHAR.

DEF VAR x-Margen AS DEC NO-UNDO.    /* Margen de utilidad */

pError = ''.

RUN vtagn/p-margen-utilidad-v11 (pCodDiv,
                                 pCodMat,
                                 pPreUni,
                                 pUndVta,
                                 1,                      /* Moneda */
                                 pTpoCmb,
                                 YES,                     /* Muestra error? */
                                 "",                     /* Almacén */
                                 OUTPUT x-Margen,        /* Margen de utilidad */
                                 OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                 OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                 ).
/* RUN vtagn/p-margen-utilidad-v2 (pCodDiv,                                                           */
/*                                 pCodMat,                                                           */
/*                                 pPreUni,                                                           */
/*                                 pUndVta,                                                           */
/*                                 1,                      /* Moneda */                               */
/*                                 pTpoCmb,                                                           */
/*                                 YES,                     /* Muestra error? */                      */
/*                                 "",                     /* Almacén */                              */
/*                                 OUTPUT x-Margen,        /* Margen de utilidad */                   */
/*                                 OUTPUT x-Limite,        /* Margen mínimo de utilidad */            */
/*                                 OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */ */
/*                                 ).                                                                 */

IF RETURN-VALUE = 'ADM-ERROR' THEN pError = 'ADM-ERROR'.

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
  {src/adm/template/snd-list.i "VtaListaMay"}
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

DEF VAR x-ValorAnterior AS DEC NO-UNDO.
DEF VAR x-Orden AS INT NO-UNDO.
DEF VAR x-PreUni AS DEC NO-UNDO.

DEF VAR x-DtoVolP AS DECI EXTENT 10 NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN pri/pri-librerias PERSISTENT SET hProc.

DO WITH FRAME {&FRAME-NAME} :
    ASSIGN
        x-DtoVolP[01] = DECIMAL (VtaListaMay.DtoVolP[1]:SCREEN-VALUE)
        x-DtoVolP[02] = DECIMAL (VtaListaMay.DtoVolP[2]:SCREEN-VALUE)
        x-DtoVolP[03] = DECIMAL (VtaListaMay.DtoVolP[3]:SCREEN-VALUE)
        x-DtoVolP[04] = DECIMAL (VtaListaMay.DtoVolP[4]:SCREEN-VALUE)
        x-DtoVolP[05] = DECIMAL (VtaListaMay.DtoVolP[5]:SCREEN-VALUE)
        x-DtoVolP[06] = DECIMAL (VtaListaMay.DtoVolP[6]:SCREEN-VALUE)
        x-DtoVolP[07] = DECIMAL (VtaListaMay.DtoVolP[7]:SCREEN-VALUE)
        x-DtoVolP[08] = DECIMAL (VtaListaMay.DtoVolP[8]:SCREEN-VALUE)
        x-DtoVolP[09] = DECIMAL (VtaListaMay.DtoVolP[9]:SCREEN-VALUE)
        x-DtoVolP[10] = DECIMAL (VtaListaMay.DtoVolP[10]:SCREEN-VALUE)
        .
    DO x-Orden = 1 TO 10:
        IF INPUT VtaListaMay.DtoVolR[x-Orden] <= 0 THEN NEXT.
        IF x-ValorAnterior = 0 THEN x-ValorAnterior = INPUT VtaListaMay.DtoVolR[x-Orden].
        IF INPUT VtaListaMay.DtoVolR[x-Orden] < x-ValorAnterior THEN DO:
            MESSAGE 'Cantidad mínima mal registrada' VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        x-ValorAnterior = INPUT VtaListaMay.DtoVolR[x-Orden].
        /* ****************************************************************************************************** */
        /* Control Margen de Utilidad */
        /* ****************************************************************************************************** */
        DEFINE VAR x-Margen AS DECI NO-UNDO.
        DEFINE VAR x-Limite AS DECI NO-UNDO.
        DEFINE VAR pError AS CHAR NO-UNDO.
        /* 1ro. Calculamos el margen de utilidad */
        x-PreUni = x-DtoVolP[x-Orden].
        RUN PRI_Margen-Utilidad IN hProc (INPUT VtaListaMay.CodDiv,
                                          INPUT VtaListaMay.CodMat,
                                          INPUT VtaListaMay.CHR__01,
                                          INPUT x-PreUni,
                                          INPUT Almmmatg.MonVta,        /*INPUT 1,*/
                                          OUTPUT x-Margen,
                                          OUTPUT x-Limite,
                                          OUTPUT pError).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            /* Error crítico */
            MESSAGE pError SKIP 'No admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.
            RETURN 'ADM-ERROR'.
        END.
        /* Controlamos si el margen de utilidad está bajo a través de la variable pError */
        IF pError > '' THEN DO:
            /* Error por margen de utilidad */
            /* 2do. Verificamos si solo es una ALERTA, definido por GG */
            DEF VAR pAlerta AS LOG NO-UNDO.
            RUN PRI_Alerta-de-Margen IN hProc (INPUT VtaListaMay.CodMat,
                                               OUTPUT pAlerta).
            IF pAlerta = YES THEN MESSAGE pError VIEW-AS ALERT-BOX WARNING TITLE 'CONTROL DE MARGEN'.
            ELSE DO:
                MESSAGE pError SKIP 'No admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.
                RETURN 'ADM-ERROR'.
            END.
        END.
        /* ****************************************************************************************************** */
    END.
END.
DELETE PROCEDURE hProc.

RETURN "OK".
END PROCEDURE.

/*

DO WITH FRAME {&FRAME-NAME} :
    DEF VAR x-Limite AS DEC NO-UNDO.
    DEF VAR pError AS CHAR NO-UNDO.
    DEF VAR k AS INT NO-UNDO.
    DO k = 1 TO 10:
        IF k = 1 AND DECIMAL(VtaListaMay.DtoVolD[1]:SCREEN-VALUE) > 0 THEN DO:
            pError = ''.
            RUN Margen-de-Utilidad (VtaListaMay.CodDiv,
                                    VtaListaMay.codmat,
                                    DECIMAL (f-Precio-1:SCREEN-VALUE),
                                    VtaListaMay.Chr__01,
                                    1,
                                    OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                    OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                    ).
            IF pError = "ADM-ERROR" THEN DO:
                APPLY 'entry' TO f-Precio-1.
                RETURN "ADM-ERROR".
            END.
        END.
        IF k = 2 AND DECIMAL(VtaListaMay.DtoVolD[2]:SCREEN-VALUE) > 0 THEN DO:
            pError = ''.
            RUN Margen-de-Utilidad (VtaListaMay.CodDiv,
                                    VtaListaMay.codmat,
                                    DECIMAL (f-Precio-2:SCREEN-VALUE),
                                    VtaListaMay.Chr__01,
                                    1,
                                    OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                    OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                    ).
            IF pError = "ADM-ERROR" THEN DO:
                APPLY 'entry' TO f-Precio-2.
                RETURN "ADM-ERROR".
            END.
        END.
        IF k = 3 AND DECIMAL(VtaListaMay.DtoVolD[3]:SCREEN-VALUE) > 0 THEN DO:
            pError = ''.
            RUN Margen-de-Utilidad (VtaListaMay.CodDiv,
                                    VtaListaMay.codmat,
                                    DECIMAL (f-Precio-3:SCREEN-VALUE),
                                    VtaListaMay.Chr__01,
                                    1,
                                    OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                    OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                    ).
            IF pError = "ADM-ERROR" THEN DO:
                APPLY 'entry' TO f-Precio-3.
                RETURN "ADM-ERROR".
            END.
        END.
        IF k = 4 AND DECIMAL(VtaListaMay.DtoVolD[4]:SCREEN-VALUE) > 0 THEN DO:
            pError = ''.
            RUN Margen-de-Utilidad (VtaListaMay.CodDiv,
                                    VtaListaMay.codmat,
                                    DECIMAL (f-Precio-4:SCREEN-VALUE),
                                    VtaListaMay.Chr__01,
                                    1,
                                    OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                    OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                    ).
            IF pError = "ADM-ERROR" THEN DO:
                APPLY 'entry' TO f-Precio-4.
                RETURN "ADM-ERROR".
            END.
        END.
        IF k = 5 AND DECIMAL(VtaListaMay.DtoVolD[5]:SCREEN-VALUE) > 0 THEN DO:
            pError = ''.
            RUN Margen-de-Utilidad (VtaListaMay.CodDiv,
                                    VtaListaMay.codmat,
                                    DECIMAL (f-Precio-5:SCREEN-VALUE),
                                    VtaListaMay.Chr__01,
                                    1,
                                    OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                    OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                    ).
            IF pError = "ADM-ERROR" THEN DO:
                APPLY 'entry' TO f-Precio-5.
                RETURN "ADM-ERROR".
            END.
        END.
        IF k = 6 AND DECIMAL(VtaListaMay.DtoVolD[6]:SCREEN-VALUE) > 0 THEN DO:
            pError = ''.
            RUN Margen-de-Utilidad (VtaListaMay.CodDiv,
                                    VtaListaMay.codmat,
                                    DECIMAL (f-Precio-6:SCREEN-VALUE),
                                    VtaListaMay.Chr__01,
                                    1,
                                    OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                    OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                    ).
            IF pError = "ADM-ERROR" THEN DO:
                APPLY 'entry' TO f-Precio-6.
                RETURN "ADM-ERROR".
            END.
        END.
        IF k = 7 AND DECIMAL(VtaListaMay.DtoVolD[7]:SCREEN-VALUE) > 0 THEN DO:
            pError = ''.
            RUN Margen-de-Utilidad (VtaListaMay.CodDiv,
                                    VtaListaMay.codmat,
                                    DECIMAL (f-Precio-7:SCREEN-VALUE),
                                    VtaListaMay.Chr__01,
                                    1,
                                    OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                    OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                    ).
            IF pError = "ADM-ERROR" THEN DO:
                APPLY 'entry' TO f-Precio-7.
                RETURN "ADM-ERROR".
            END.
        END.
        IF k = 8 AND DECIMAL(VtaListaMay.DtoVolD[8]:SCREEN-VALUE) > 0 THEN DO:
            pError = ''.
            RUN Margen-de-Utilidad (VtaListaMay.CodDiv,
                                    VtaListaMay.codmat,
                                    DECIMAL (f-Precio-8:SCREEN-VALUE),
                                    VtaListaMay.Chr__01,
                                    1,
                                    OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                    OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                    ).
            IF pError = "ADM-ERROR" THEN DO:
                APPLY 'entry' TO f-Precio-8.
                RETURN "ADM-ERROR".
            END.
        END.
        IF k = 9 AND DECIMAL(VtaListaMay.DtoVolD[9]:SCREEN-VALUE) > 0 THEN DO:
            pError = ''.
            RUN Margen-de-Utilidad (VtaListaMay.CodDiv,
                                    VtaListaMay.codmat,
                                    DECIMAL (f-Precio-9:SCREEN-VALUE),
                                    VtaListaMay.Chr__01,
                                    1,
                                    OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                    OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                    ).
            IF pError = "ADM-ERROR" THEN DO:
                APPLY 'entry' TO f-Precio-9.
                RETURN "ADM-ERROR".
            END.
        END.
        IF k = 10 AND DECIMAL(VtaListaMay.DtoVolD[10]:SCREEN-VALUE) > 0 THEN DO:
            pError = ''.
            RUN Margen-de-Utilidad (VtaListaMay.CodDiv,
                                    VtaListaMay.codmat,
                                    DECIMAL (f-Precio-10:SCREEN-VALUE),
                                    VtaListaMay.Chr__01,
                                    1,
                                    OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                    OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                    ).
            IF pError = "ADM-ERROR" THEN DO:
                APPLY 'entry' TO f-Precio-10.
                RETURN "ADM-ERROR".
            END.
        END.
    END.
END.
*/

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPreVta V-table-Win 
FUNCTION fPreVta RETURNS DECIMAL
  ( INPUT pPreUni AS DECI, INPUT pMoneda AS INTE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE pMoneda:
      WHEN 2 THEN DO:
          IF Almmmatg.MonVta = 2 THEN RETURN pPreUni.
          ELSE RETURN pPreUni / Almmmatg.TpoCmb.
      END.
      WHEN 1 THEN DO:
          IF Almmmatg.MonVta = 1 THEN RETURN pPreUni.
          ELSE RETURN pPreUni * Almmmatg.TpoCmb.
      END.
  END CASE.
  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

