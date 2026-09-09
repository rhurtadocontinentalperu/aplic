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

DEF VAR F-PRECIO AS DEC NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS almmmatp.DtoVolR[1] almmmatp.DtoVolD[1] ~
almmmatp.DtoVolP[1] almmmatp.DtoVolR[2] almmmatp.DtoVolD[2] ~
almmmatp.DtoVolP[2] almmmatp.DtoVolR[3] almmmatp.DtoVolD[3] ~
almmmatp.DtoVolP[3] almmmatp.DtoVolR[4] almmmatp.DtoVolD[4] ~
almmmatp.DtoVolP[4] almmmatp.DtoVolR[5] almmmatp.DtoVolD[5] ~
almmmatp.DtoVolP[5] almmmatp.DtoVolR[6] almmmatp.DtoVolD[6] ~
almmmatp.DtoVolP[6] almmmatp.DtoVolR[7] almmmatp.DtoVolD[7] ~
almmmatp.DtoVolP[7] almmmatp.DtoVolR[8] almmmatp.DtoVolD[8] ~
almmmatp.DtoVolP[8] almmmatp.DtoVolR[9] almmmatp.DtoVolD[9] ~
almmmatp.DtoVolP[9] almmmatp.DtoVolR[10] almmmatp.DtoVolD[10] ~
almmmatp.DtoVolP[10] 
&Scoped-define ENABLED-TABLES almmmatp
&Scoped-define FIRST-ENABLED-TABLE almmmatp
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-13 
&Scoped-Define DISPLAYED-FIELDS almmmatp.codmat almmmatp.Chr__01 ~
almmmatp.DesMat almmmatp.DtoVolR[1] almmmatp.DtoVolD[1] almmmatp.DtoVolP[1] ~
almmmatp.DtoVolR[2] almmmatp.DtoVolD[2] almmmatp.DtoVolP[2] ~
almmmatp.DtoVolR[3] almmmatp.DtoVolD[3] almmmatp.DtoVolP[3] ~
almmmatp.DtoVolR[4] almmmatp.DtoVolD[4] almmmatp.DtoVolP[4] ~
almmmatp.DtoVolR[5] almmmatp.DtoVolD[5] almmmatp.DtoVolP[5] ~
almmmatp.DtoVolR[6] almmmatp.DtoVolD[6] almmmatp.DtoVolP[6] ~
almmmatp.DtoVolR[7] almmmatp.DtoVolD[7] almmmatp.DtoVolP[7] ~
almmmatp.DtoVolR[8] almmmatp.DtoVolD[8] almmmatp.DtoVolP[8] ~
almmmatp.DtoVolR[9] almmmatp.DtoVolD[9] almmmatp.DtoVolP[9] ~
almmmatp.DtoVolR[10] almmmatp.DtoVolD[10] almmmatp.DtoVolP[10] 
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
     SIZE 41.29 BY .85.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 8.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     almmmatp.codmat AT ROW 1.38 COL 1 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
          BGCOLOR 15 FGCOLOR 1 
     almmmatp.Chr__01 AT ROW 1.38 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .69
     almmmatp.DesMat AT ROW 2.31 COL 1.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40.57 BY .69
          BGCOLOR 15 FGCOLOR 1 
     almmmatp.DtoVolR[1] AT ROW 4.19 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     almmmatp.DtoVolD[1] AT ROW 4.19 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     almmmatp.DtoVolP[1] AT ROW 4.19 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.DtoVolR[2] AT ROW 5.04 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     almmmatp.DtoVolD[2] AT ROW 5.04 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     almmmatp.DtoVolP[2] AT ROW 5.04 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.DtoVolR[3] AT ROW 5.85 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     almmmatp.DtoVolD[3] AT ROW 5.85 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     almmmatp.DtoVolP[3] AT ROW 5.85 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.DtoVolR[4] AT ROW 6.65 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     almmmatp.DtoVolD[4] AT ROW 6.65 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     almmmatp.DtoVolP[4] AT ROW 6.65 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.DtoVolR[5] AT ROW 7.46 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     almmmatp.DtoVolD[5] AT ROW 7.46 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     almmmatp.DtoVolP[5] AT ROW 7.46 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.DtoVolR[6] AT ROW 8.27 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     almmmatp.DtoVolD[6] AT ROW 8.27 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     almmmatp.DtoVolP[6] AT ROW 8.27 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.DtoVolR[7] AT ROW 9.08 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     almmmatp.DtoVolD[7] AT ROW 9.08 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     almmmatp.DtoVolP[7] AT ROW 9.08 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.DtoVolR[8] AT ROW 9.88 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     almmmatp.DtoVolD[8] AT ROW 9.88 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     almmmatp.DtoVolP[8] AT ROW 9.88 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.DtoVolR[9] AT ROW 10.69 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     almmmatp.DtoVolD[9] AT ROW 10.69 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     almmmatp.DtoVolP[9] AT ROW 10.69 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     almmmatp.DtoVolR[10] AT ROW 11.58 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     almmmatp.DtoVolD[10] AT ROW 11.58 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     almmmatp.DtoVolP[10] AT ROW 11.58 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     "Descuento %" VIEW-AS TEXT
          SIZE 10.86 BY .5 AT ROW 3.27 COL 18.57
     "Cantidad Minima" VIEW-AS TEXT
          SIZE 11.14 BY .5 AT ROW 3.27 COL 5.14
     "Precio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.27 COL 31.29
     RECT-10 AT ROW 3.12 COL 2.72
     RECT-13 AT ROW 3.96 COL 2.86
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
         HEIGHT             = 12.81
         WIDTH              = 46.
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

/* SETTINGS FOR FILL-IN almmmatp.Chr__01 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN almmmatp.codmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN almmmatp.DesMat IN FRAME F-Main
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

&Scoped-define SELF-NAME almmmatp.DtoVolD[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolD[10] V-table-Win
ON LEAVE OF almmmatp.DtoVolD[10] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatp.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      almmmatp.DtoVolP[10]:SCREEN-VALUE = STRING( ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN almmmatp.DtoVolP[10]:SCREEN-VALUE = '0.0000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolD[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolD[1] V-table-Win
ON LEAVE OF almmmatp.DtoVolD[1] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatp.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      almmmatp.DtoVolP[1]:SCREEN-VALUE = STRING( ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN almmmatp.DtoVolP[1]:SCREEN-VALUE = '0.0000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolD[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolD[2] V-table-Win
ON LEAVE OF almmmatp.DtoVolD[2] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatp.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      almmmatp.DtoVolP[2]:SCREEN-VALUE = STRING( ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN almmmatp.DtoVolP[2]:SCREEN-VALUE = '0.0000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolD[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolD[3] V-table-Win
ON LEAVE OF almmmatp.DtoVolD[3] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatp.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      almmmatp.DtoVolP[3]:SCREEN-VALUE = STRING( ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN almmmatp.DtoVolP[3]:SCREEN-VALUE = '0.0000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolD[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolD[4] V-table-Win
ON LEAVE OF almmmatp.DtoVolD[4] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatp.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      almmmatp.DtoVolP[4]:SCREEN-VALUE = STRING( ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN almmmatp.DtoVolP[4]:SCREEN-VALUE = '0.0000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolD[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolD[5] V-table-Win
ON LEAVE OF almmmatp.DtoVolD[5] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatp.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      almmmatp.DtoVolP[5]:SCREEN-VALUE = STRING( ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN almmmatp.DtoVolP[5]:SCREEN-VALUE = '0.0000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolD[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolD[6] V-table-Win
ON LEAVE OF almmmatp.DtoVolD[6] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatp.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      almmmatp.DtoVolP[6]:SCREEN-VALUE = STRING( ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN almmmatp.DtoVolP[6]:SCREEN-VALUE = '0.0000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolD[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolD[7] V-table-Win
ON LEAVE OF almmmatp.DtoVolD[7] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatp.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      almmmatp.DtoVolP[7]:SCREEN-VALUE = STRING( ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN almmmatp.DtoVolP[7]:SCREEN-VALUE = '0.0000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolD[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolD[8] V-table-Win
ON LEAVE OF almmmatp.DtoVolD[8] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatp.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      almmmatp.DtoVolP[8]:SCREEN-VALUE = STRING( ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN almmmatp.DtoVolP[8]:SCREEN-VALUE = '0.0000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolD[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolD[9] V-table-Win
ON LEAVE OF almmmatp.DtoVolD[9] IN FRAME F-Main /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatp.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.000000'.
          RETURN NO-APPLY.
      END.
      almmmatp.DtoVolP[9]:SCREEN-VALUE = STRING( ROUND(F-PRECIO * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN almmmatp.DtoVolP[9]:SCREEN-VALUE = '0.0000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolP[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolP[10] V-table-Win
ON LEAVE OF almmmatp.DtoVolP[10] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.0000'.
          RETURN NO-APPLY.
      END.
      Almmmatp.DtoVolD[10]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN 
          ASSIGN Almmmatp.DtoVolR[10]:SCREEN-VALUE = '0' Almmmatp.DtoVolD[10]:SCREEN-VALUE = '0.000000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolP[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolP[1] V-table-Win
ON LEAVE OF almmmatp.DtoVolP[1] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.0000'.
          RETURN NO-APPLY.
      END.
      Almmmatp.DtoVolD[1]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN 
          ASSIGN Almmmatp.DtoVolR[1]:SCREEN-VALUE = '0' Almmmatp.DtoVolD[1]:SCREEN-VALUE = '0.000000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolP[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolP[2] V-table-Win
ON LEAVE OF almmmatp.DtoVolP[2] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.0000'.
          RETURN NO-APPLY.
      END.
      Almmmatp.DtoVolD[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN 
          ASSIGN Almmmatp.DtoVolR[2]:SCREEN-VALUE = '0' Almmmatp.DtoVolD[2]:SCREEN-VALUE = '0.000000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolP[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolP[3] V-table-Win
ON LEAVE OF almmmatp.DtoVolP[3] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.0000'.
          RETURN NO-APPLY.
      END.
      Almmmatp.DtoVolD[3]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN 
          ASSIGN Almmmatp.DtoVolR[3]:SCREEN-VALUE = '0' Almmmatp.DtoVolD[3]:SCREEN-VALUE = '0.000000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolP[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolP[4] V-table-Win
ON LEAVE OF almmmatp.DtoVolP[4] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.0000'.
          RETURN NO-APPLY.
      END.
      Almmmatp.DtoVolD[4]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN 
          ASSIGN Almmmatp.DtoVolR[4]:SCREEN-VALUE = '0' Almmmatp.DtoVolD[4]:SCREEN-VALUE = '0.000000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolP[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolP[5] V-table-Win
ON LEAVE OF almmmatp.DtoVolP[5] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.0000'.
          RETURN NO-APPLY.
      END.
      Almmmatp.DtoVolD[5]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN 
          ASSIGN Almmmatp.DtoVolR[5]:SCREEN-VALUE = '0' Almmmatp.DtoVolD[5]:SCREEN-VALUE = '0.000000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolP[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolP[6] V-table-Win
ON LEAVE OF almmmatp.DtoVolP[6] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.0000'.
          RETURN NO-APPLY.
      END.
      Almmmatp.DtoVolD[6]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN 
          ASSIGN Almmmatp.DtoVolR[6]:SCREEN-VALUE = '0' Almmmatp.DtoVolD[6]:SCREEN-VALUE = '0.000000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolP[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolP[7] V-table-Win
ON LEAVE OF almmmatp.DtoVolP[7] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.0000'.
          RETURN NO-APPLY.
      END.
      Almmmatp.DtoVolD[7]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN 
          ASSIGN Almmmatp.DtoVolR[7]:SCREEN-VALUE = '0' Almmmatp.DtoVolD[7]:SCREEN-VALUE = '0.000000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolP[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolP[8] V-table-Win
ON LEAVE OF almmmatp.DtoVolP[8] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.0000'.
          RETURN NO-APPLY.
      END.
      Almmmatp.DtoVolD[8]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN 
          ASSIGN Almmmatp.DtoVolR[8]:SCREEN-VALUE = '0' Almmmatp.DtoVolD[8]:SCREEN-VALUE = '0.000000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolP[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolP[9] V-table-Win
ON LEAVE OF almmmatp.DtoVolP[9] IN FRAME F-Main /* DtoVolP */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatp.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = '0.0000'.
          RETURN NO-APPLY.
      END.
      Almmmatp.DtoVolD[9]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / F-PRECIO ) * 100, 4 ) ).
      IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN 
          ASSIGN Almmmatp.DtoVolR[9]:SCREEN-VALUE = '0' Almmmatp.DtoVolD[9]:SCREEN-VALUE = '0.000000'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolR[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolR[10] V-table-Win
ON LEAVE OF almmmatp.DtoVolR[10] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ almmmatp.DtoVolP[10] 0 @ Almmmatp.DtoVolD[10].
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolR[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolR[1] V-table-Win
ON LEAVE OF almmmatp.DtoVolR[1] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ almmmatp.DtoVolP[1] 0 @ Almmmatp.DtoVolD[1].
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolR[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolR[2] V-table-Win
ON LEAVE OF almmmatp.DtoVolR[2] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ almmmatp.DtoVolP[2] 0 @ Almmmatp.DtoVolD[2].
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolR[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolR[3] V-table-Win
ON LEAVE OF almmmatp.DtoVolR[3] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ almmmatp.DtoVolP[3] 0 @ Almmmatp.DtoVolD[3].
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolR[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolR[4] V-table-Win
ON LEAVE OF almmmatp.DtoVolR[4] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ almmmatp.DtoVolP[4] 0 @ Almmmatp.DtoVolD[4].
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolR[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolR[5] V-table-Win
ON LEAVE OF almmmatp.DtoVolR[5] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ almmmatp.DtoVolP[5] 0 @ Almmmatp.DtoVolD[5].
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolR[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolR[6] V-table-Win
ON LEAVE OF almmmatp.DtoVolR[6] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ almmmatp.DtoVolP[6] 0 @ Almmmatp.DtoVolD[6].
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolR[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolR[7] V-table-Win
ON LEAVE OF almmmatp.DtoVolR[7] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ almmmatp.DtoVolP[7] 0 @ Almmmatp.DtoVolD[7].
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolR[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolR[8] V-table-Win
ON LEAVE OF almmmatp.DtoVolR[8] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ almmmatp.DtoVolP[8] 0 @ Almmmatp.DtoVolD[8].
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmmatp.DtoVolR[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmmatp.DtoVolR[9] V-table-Win
ON LEAVE OF almmmatp.DtoVolR[9] IN FRAME F-Main /* DtoVolR */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
          DISPLAY  0 @ almmmatp.DtoVolP[9] 0 @ Almmmatp.DtoVolD[9].
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
  
  /* CONSISTENCIAS PREVIAS */
  DEF VAR x-Margen AS DEC NO-UNDO.
  DEF VAR x-Limite AS DEC NO-UNDO.
  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR iCuentaRangos AS INT NO-UNDO.

  /* CONSISTENCIA CANTIDAD DE RANGOS */
  iCuentaRangos = 0.
  DO x-Orden = 1 TO 10:
      IF Almmmatp.DtoVolR[x-Orden] <> 0 THEN iCuentaRangos = iCuentaRangos + 1.
  END.
  IF iCuentaRangos = 1 THEN DO:
      MESSAGE "Debe definir más de un rango" VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* CONSISTENCIA DE MAYOR A MENOR */
  iCuentaRangos = 0.
  DO x-Orden = 1 TO 10:
      IF Almmmatp.DtoVolR[x-Orden] = 0 THEN NEXT.
      IF iCuentaRangos > 0 AND Almmmatp.DtoVolR[x-Orden] > 0 AND Almmmatp.DtoVolR[x-Orden] < iCuentaRangos 
          THEN DO:
          MESSAGE "Debe definir los rangos de menor a mayor" VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      iCuentaRangos = Almmmatp.DtoVolR[x-Orden].
  END.

  Almmmatp.fchact = TODAY.
  DO x-Orden = 1 TO 10:
      IF Almmmatp.DtoVolR[x-Orden] = 0 OR Almmmatp.DtoVolD[x-Orden] = 0
      THEN ASSIGN
                Almmmatp.DtoVolR[x-Orden] = 0
                Almmmatp.DtoVolD[x-Orden] = 0
                Almmmatp.DtoVolP[x-Orden] = 0.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  
  RUN lib/logtabla ('Almmmatp', Almmmatp.codmat, 'WRITE').   /* Log de cambios */

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
  IF AVAILABLE Almmmatp THEN DO WITH FRAME {&FRAME-NAME}:
      /* A LA MONEDA DE LA LISTA DE PRECIOS */
      F-PRECIO = Almmmatp.PreOfi.
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

