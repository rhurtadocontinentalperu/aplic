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

DEFINE SHARED VAR pCodDiv AS CHAR.
DEFINE SHARED VAR cl-codcia AS INTE.
DEFINE SHARED VAR s-codcli AS CHAR.
DEFINE SHARED VAR s-fmapgo AS CHAR.
DEFINE SHARED VAR s-codmon AS INTE.

DEFINE VAR x-PreUni AS DECI NO-UNDO.

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
VtaListaMay.DtoVolR[2] VtaListaMay.DtoVolD[2] VtaListaMay.DtoVolR[3] ~
VtaListaMay.DtoVolD[3] VtaListaMay.DtoVolR[4] VtaListaMay.DtoVolD[4] ~
VtaListaMay.DtoVolR[5] VtaListaMay.DtoVolD[5] VtaListaMay.DtoVolR[6] ~
VtaListaMay.DtoVolD[6] VtaListaMay.DtoVolR[7] VtaListaMay.DtoVolD[7] ~
VtaListaMay.DtoVolR[8] VtaListaMay.DtoVolD[8] VtaListaMay.DtoVolR[9] ~
VtaListaMay.DtoVolD[9] VtaListaMay.DtoVolR[10] VtaListaMay.DtoVolD[10] 
&Scoped-define ENABLED-TABLES VtaListaMay
&Scoped-define FIRST-ENABLED-TABLE VtaListaMay
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-13 
&Scoped-Define DISPLAYED-FIELDS VtaListaMay.codmat VtaListaMay.Chr__01 ~
VtaListaMay.DtoVolR[1] VtaListaMay.DtoVolD[1] VtaListaMay.DtoVolR[2] ~
VtaListaMay.DtoVolD[2] VtaListaMay.DtoVolR[3] VtaListaMay.DtoVolD[3] ~
VtaListaMay.DtoVolR[4] VtaListaMay.DtoVolD[4] VtaListaMay.DtoVolR[5] ~
VtaListaMay.DtoVolD[5] VtaListaMay.DtoVolR[6] VtaListaMay.DtoVolD[6] ~
VtaListaMay.DtoVolR[7] VtaListaMay.DtoVolD[7] VtaListaMay.DtoVolR[8] ~
VtaListaMay.DtoVolD[8] VtaListaMay.DtoVolR[9] VtaListaMay.DtoVolD[9] ~
VtaListaMay.DtoVolR[10] VtaListaMay.DtoVolD[10] 
&Scoped-define DISPLAYED-TABLES VtaListaMay
&Scoped-define FIRST-DISPLAYED-TABLE VtaListaMay
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_DesMat FILL-IN_Precio-1 ~
FILL-IN_Precio-2 FILL-IN_Precio-3 FILL-IN_Precio-4 FILL-IN_Precio-5 ~
FILL-IN_Precio-6 FILL-IN_Precio-7 FILL-IN_Precio-8 FILL-IN_Precio-9 ~
FILL-IN_Precio-10 

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
DEFINE VARIABLE FILL-IN_DesMat AS CHARACTER FORMAT "X(45)" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .69.

DEFINE VARIABLE FILL-IN_Precio-1 AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Precio-10 AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Precio-2 AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Precio-3 AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Precio-4 AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Precio-5 AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Precio-6 AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Precio-7 AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Precio-8 AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Precio-9 AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.29 BY 1.12.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.14 BY 9.5.


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
     FILL-IN_DesMat AT ROW 2.15 COL 3 NO-LABEL WIDGET-ID 8
     VtaListaMay.DtoVolR[1] AT ROW 4.23 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[1] AT ROW 4.23 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     FILL-IN_Precio-1 AT ROW 4.23 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     VtaListaMay.DtoVolR[2] AT ROW 5.04 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[2] AT ROW 5.04 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     FILL-IN_Precio-2 AT ROW 5.04 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     VtaListaMay.DtoVolR[3] AT ROW 5.85 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[3] AT ROW 5.85 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     FILL-IN_Precio-3 AT ROW 5.85 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     VtaListaMay.DtoVolR[4] AT ROW 6.65 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[4] AT ROW 6.65 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     FILL-IN_Precio-4 AT ROW 6.65 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     VtaListaMay.DtoVolR[5] AT ROW 7.46 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[5] AT ROW 7.46 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     FILL-IN_Precio-5 AT ROW 7.46 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     VtaListaMay.DtoVolR[6] AT ROW 8.27 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[6] AT ROW 8.27 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     FILL-IN_Precio-6 AT ROW 8.27 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     VtaListaMay.DtoVolR[7] AT ROW 9.08 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[7] AT ROW 9.08 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     FILL-IN_Precio-7 AT ROW 9.08 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     VtaListaMay.DtoVolR[8] AT ROW 9.88 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[8] AT ROW 9.88 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     FILL-IN_Precio-8 AT ROW 9.88 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     VtaListaMay.DtoVolR[9] AT ROW 10.69 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[9] AT ROW 10.69 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     FILL-IN_Precio-9 AT ROW 10.69 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 74
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     VtaListaMay.DtoVolR[10] AT ROW 11.5 COL 4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[10] AT ROW 11.5 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     FILL-IN_Precio-10 AT ROW 11.5 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     "Precio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.42 COL 34 WIDGET-ID 56
     "Cantidad Minima" VIEW-AS TEXT
          SIZE 11.14 BY .5 AT ROW 3.42 COL 7
     "Descuento %" VIEW-AS TEXT
          SIZE 10.86 BY .5 AT ROW 3.42 COL 22
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
         WIDTH              = 48.
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
/* SETTINGS FOR FILL-IN FILL-IN_DesMat IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN_Precio-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Precio-10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Precio-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Precio-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Precio-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Precio-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Precio-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Precio-7 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Precio-8 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Precio-9 IN FRAME F-Main
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
  DEF VAR pMensaje AS CHAR NO-UNDO.
  DEF VAR pMonVta AS INTE NO-UNDO.
  DEF VAR pTpoCmb AS DECI NO-UNDO.
  DEF VAR pPrecioDescontado AS DECI NO-UNDO.
  
  FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
      gn-divi.coddiv = pCodDiv NO-LOCK.
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND
      gn-clie.codcli = s-CodCli NO-LOCK.

  IF AVAILABLE Almmmatg THEN DO WITH FRAME {&FRAME-NAME}:
      FILL-IN_DesMat:SCREEN-VALUE = Almmmatg.DesMat.
      DEFINE VAR hProc AS HANDLE NO-UNDO.
      RUN web/web-library.p PERSISTENT SET hProc.
      RUN web_api-pricing-preuni IN hProc (Almmmatg.codmat,
                                           GN-DIVI.Grupo_Divi_GG,
                                           (IF Almmmatg.CHR__02 = "P" THEN gn-clie.clfCli ELSE gn-clie.ClfCli2),
                                           s-FmaPgo,
                                           OUTPUT pMonVta,
                                           OUTPUT pTpoCmb,
                                           OUTPUT pPrecioDescontado,
                                           OUTPUT pMensaje).
      DELETE PROCEDURE hProc.
  END.

  IF s-CodMon = pMonVta THEN DO:
      x-PreUni = pPrecioDescontado.
  END.
  ELSE DO:
      IF s-CodMon = 1 THEN x-PreUni = pPrecioDescontado * pTpoCmb.
      ELSE x-PreUni = pPrecioDescontado / pTpoCmb.
  END.
  IF AVAILABLE VtaListaMay THEN DO:
      DISPLAY
          x-PreUni * (1 - VtaListaMay.DtoVolD[1] / 100)  WHEN VtaListaMay.DtoVolD[1]  > 0 @ FILL-IN_Precio-1
          x-PreUni * (1 - VtaListaMay.DtoVolD[2] / 100)  WHEN VtaListaMay.DtoVolD[2]  > 0 @ FILL-IN_Precio-2
          x-PreUni * (1 - VtaListaMay.DtoVolD[3] / 100)  WHEN VtaListaMay.DtoVolD[3]  > 0 @ FILL-IN_Precio-3
          x-PreUni * (1 - VtaListaMay.DtoVolD[4] / 100)  WHEN VtaListaMay.DtoVolD[4]  > 0 @ FILL-IN_Precio-4
          x-PreUni * (1 - VtaListaMay.DtoVolD[5] / 100)  WHEN VtaListaMay.DtoVolD[5]  > 0 @ FILL-IN_Precio-5
          x-PreUni * (1 - VtaListaMay.DtoVolD[6] / 100)  WHEN VtaListaMay.DtoVolD[6]  > 0 @ FILL-IN_Precio-6
          x-PreUni * (1 - VtaListaMay.DtoVolD[7] / 100)  WHEN VtaListaMay.DtoVolD[7]  > 0 @ FILL-IN_Precio-7
          x-PreUni * (1 - VtaListaMay.DtoVolD[8] / 100)  WHEN VtaListaMay.DtoVolD[8]  > 0 @ FILL-IN_Precio-8
          x-PreUni * (1 - VtaListaMay.DtoVolD[9] / 100)  WHEN VtaListaMay.DtoVolD[9]  > 0 @ FILL-IN_Precio-9
          x-PreUni * (1 - VtaListaMay.DtoVolD[10] / 100) WHEN VtaListaMay.DtoVolD[10] > 0 @ FILL-IN_Precio-10
          WITH FRAME {&FRAME-NAME}.
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

DO WITH FRAME {&FRAME-NAME} :
    DO x-Orden = 1 TO 10:
        IF INPUT VtaListaMay.DtoVolR[x-Orden] <= 0 THEN NEXT.
        IF x-ValorAnterior = 0 THEN x-ValorAnterior = INPUT VtaListaMay.DtoVolR[x-Orden].
        IF INPUT VtaListaMay.DtoVolR[x-Orden] < x-ValorAnterior THEN DO:
            MESSAGE 'Cantidad mínima mal registrada' VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        x-ValorAnterior = INPUT VtaListaMay.DtoVolR[x-Orden].
    END.
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPreVta V-table-Win 
FUNCTION fPreVta RETURNS DECIMAL
  ( INPUT pPreUni AS DECI, INPUT pMoneda AS INTE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Almmmatg THEN RETURN 0.

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

