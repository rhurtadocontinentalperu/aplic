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
&Scoped-define EXTERNAL-TABLES VtaListaMay
&Scoped-define FIRST-EXTERNAL-TABLE VtaListaMay


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaListaMay.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaListaMay.DesMat VtaListaMay.DtoVolR[1] ~
VtaListaMay.DtoVolD[1] VtaListaMay.DtoVolR[2] VtaListaMay.DtoVolD[2] ~
VtaListaMay.DtoVolR[3] VtaListaMay.DtoVolD[3] VtaListaMay.DtoVolR[4] ~
VtaListaMay.DtoVolD[4] VtaListaMay.DtoVolR[5] VtaListaMay.DtoVolD[5] ~
VtaListaMay.DtoVolR[6] VtaListaMay.DtoVolD[6] VtaListaMay.DtoVolR[7] ~
VtaListaMay.DtoVolD[7] VtaListaMay.DtoVolR[8] VtaListaMay.DtoVolD[8] ~
VtaListaMay.DtoVolR[9] VtaListaMay.DtoVolD[9] VtaListaMay.DtoVolR[10] ~
VtaListaMay.DtoVolD[10] 
&Scoped-define ENABLED-TABLES VtaListaMay
&Scoped-define FIRST-ENABLED-TABLE VtaListaMay
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-13 
&Scoped-Define DISPLAYED-FIELDS VtaListaMay.codmat VtaListaMay.Chr__01 ~
VtaListaMay.DesMat VtaListaMay.DtoVolR[1] VtaListaMay.DtoVolD[1] ~
VtaListaMay.DtoVolR[2] VtaListaMay.DtoVolD[2] VtaListaMay.DtoVolR[3] ~
VtaListaMay.DtoVolD[3] VtaListaMay.DtoVolR[4] VtaListaMay.DtoVolD[4] ~
VtaListaMay.DtoVolR[5] VtaListaMay.DtoVolD[5] VtaListaMay.DtoVolR[6] ~
VtaListaMay.DtoVolD[6] VtaListaMay.DtoVolR[7] VtaListaMay.DtoVolD[7] ~
VtaListaMay.DtoVolR[8] VtaListaMay.DtoVolD[8] VtaListaMay.DtoVolR[9] ~
VtaListaMay.DtoVolD[9] VtaListaMay.DtoVolR[10] VtaListaMay.DtoVolD[10] 
&Scoped-define DISPLAYED-TABLES VtaListaMay
&Scoped-define FIRST-DISPLAYED-TABLE VtaListaMay
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
     SIZE 40.86 BY .85.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 9.5.


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
     VtaListaMay.DesMat AT ROW 2.15 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 41 BY .69
     VtaListaMay.DtoVolR[1] AT ROW 4.19 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[1] AT ROW 4.19 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-1 AT ROW 4.19 COL 28 COLON-ALIGNED NO-LABEL
     VtaListaMay.DtoVolR[2] AT ROW 5.04 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[2] AT ROW 5.04 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-2 AT ROW 5.04 COL 28 COLON-ALIGNED NO-LABEL
     VtaListaMay.DtoVolR[3] AT ROW 5.85 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[3] AT ROW 5.85 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-3 AT ROW 5.85 COL 28 COLON-ALIGNED NO-LABEL
     VtaListaMay.DtoVolR[4] AT ROW 6.65 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[4] AT ROW 6.65 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-4 AT ROW 6.65 COL 28 COLON-ALIGNED NO-LABEL
     VtaListaMay.DtoVolR[5] AT ROW 7.46 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[5] AT ROW 7.46 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-5 AT ROW 7.46 COL 28 COLON-ALIGNED NO-LABEL
     VtaListaMay.DtoVolR[6] AT ROW 8.27 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[6] AT ROW 8.27 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-6 AT ROW 8.27 COL 28 COLON-ALIGNED NO-LABEL
     VtaListaMay.DtoVolR[7] AT ROW 9.08 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[7] AT ROW 9.08 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-7 AT ROW 9.08 COL 28 COLON-ALIGNED NO-LABEL
     VtaListaMay.DtoVolR[8] AT ROW 9.88 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[8] AT ROW 9.88 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-8 AT ROW 9.88 COL 28 COLON-ALIGNED NO-LABEL
     VtaListaMay.DtoVolR[9] AT ROW 10.69 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[9] AT ROW 10.69 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-9 AT ROW 10.69 COL 28 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     VtaListaMay.DtoVolR[10] AT ROW 11.58 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaListaMay.DtoVolD[10] AT ROW 11.58 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-10 AT ROW 11.58 COL 28 COLON-ALIGNED NO-LABEL
     "Cantidad Minima" VIEW-AS TEXT
          SIZE 11.14 BY .5 AT ROW 3.27 COL 5.14
     "Descuento %" VIEW-AS TEXT
          SIZE 10.86 BY .5 AT ROW 3.27 COL 18.57
     "Precio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.27 COL 31.29
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
   External Tables: INTEGRAL.VtaListaMay
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
         WIDTH              = 46.86.
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
       RETURN NO-APPLY.
    END.    
    F-PRECIO-10 = ROUND(VtaListaMay.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-10 = 0.
    DISPLAY F-PRECIO-10  .
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
       RETURN NO-APPLY.
    END.    
    F-PRECIO-1 = ROUND(VtaListaMay.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-1 = 0.
    DISPLAY F-PRECIO-1  .
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
       RETURN NO-APPLY.
    END.    
    F-PRECIO-2 = ROUND(VtaListaMay.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-2 = 0.
    DISPLAY F-PRECIO-2  .
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
       RETURN NO-APPLY.
    END.    
    F-PRECIO-3 = ROUND(VtaListaMay.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-3 = 0.
    DISPLAY F-PRECIO-3  .
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
       RETURN NO-APPLY.
    END.    
    F-PRECIO-4 = ROUND(VtaListaMay.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-4 = 0.
    DISPLAY F-PRECIO-4  .
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
       RETURN NO-APPLY.
    END.    
    F-PRECIO-5 = ROUND(VtaListaMay.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-5 = 0.
    DISPLAY F-PRECIO-5  .
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
       RETURN NO-APPLY.
    END.    
    F-PRECIO-6 = ROUND(VtaListaMay.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-6 = 0.
    DISPLAY F-PRECIO-6  .
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
       RETURN NO-APPLY.
    END.    
    F-PRECIO-7 = ROUND(VtaListaMay.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-7 = 0.
    DISPLAY F-PRECIO-7  .
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
       RETURN NO-APPLY.
    END.    
    F-PRECIO-8 = ROUND(VtaListaMay.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-8 = 0.
    DISPLAY F-PRECIO-8  .
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
       RETURN NO-APPLY.
    END.    
    F-PRECIO-9 = ROUND(VtaListaMay.PreOfi * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-9 = 0.
    DISPLAY F-PRECIO-9  .
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
       F-PRECIO-10 = 0 .
       DISPLAY  
           F-PRECIO-10 
           0 @ VtaListaMay.DtoVolD[10].
       RETURN.
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
       F-PRECIO-1 = 0 .
       DISPLAY  
           F-PRECIO-1 
           0 @ VtaListaMay.DtoVolD[1].
       RETURN.
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
       F-PRECIO-2 = 0 .
       DISPLAY  
           F-PRECIO-2
           0 @ VtaListaMay.DtoVolD[2].
       RETURN.
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
       F-PRECIO-3 = 0 .
       DISPLAY  
           F-PRECIO-3 
           0 @ VtaListaMay.DtoVolD[3].
       RETURN.
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
       F-PRECIO-4 = 0 .
       DISPLAY  
           F-PRECIO-4 
           0 @ VtaListaMay.DtoVolD[4].
       RETURN.
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
       F-PRECIO-5 = 0 .
       DISPLAY  
           F-PRECIO-5 
           0 @ VtaListaMay.DtoVolD[5].
       RETURN.
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
       F-PRECIO-6 = 0 .
       DISPLAY  
           F-PRECIO-6 
           0 @ VtaListaMay.DtoVolD[6].
       RETURN.
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
       F-PRECIO-7 = 0 .
       DISPLAY  
           F-PRECIO-7 
           0 @ VtaListaMay.DtoVolD[7].
       RETURN.
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
       F-PRECIO-8 = 0 .
       DISPLAY  
           F-PRECIO-8 
           0 @ VtaListaMay.DtoVolD[8].
       RETURN.
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
       F-PRECIO-9 = 0 .
       DISPLAY  
           F-PRECIO-9 
           0 @ VtaListaMay.DtoVolD[9].
       RETURN.
    END.
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-1 V-table-Win
ON LEAVE OF F-PRECIO-1 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[1]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaMay.PreOfi ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[1]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[1]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-10 V-table-Win
ON LEAVE OF F-PRECIO-10 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[10]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaMay.PreOfi ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[10]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[10]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-2 V-table-Win
ON LEAVE OF F-PRECIO-2 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaMay.PreOfi ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[2]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[2]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-3 V-table-Win
ON LEAVE OF F-PRECIO-3 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[3]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaMay.PreOfi ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[3]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[3]:SCREEN-VALUE = '0'.
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-4 V-table-Win
ON LEAVE OF F-PRECIO-4 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[4]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaMay.PreOfi ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[4]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[4]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-5 V-table-Win
ON LEAVE OF F-PRECIO-5 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[5]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaMay.PreOfi ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[5]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[5]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-6 V-table-Win
ON LEAVE OF F-PRECIO-6 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[6]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaMay.PreOfi ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[6]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[6]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-7 V-table-Win
ON LEAVE OF F-PRECIO-7 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[7]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaMay.PreOfi ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[7]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[7]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-8 V-table-Win
ON LEAVE OF F-PRECIO-8 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[8]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaMay.PreOfi ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[8]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[8]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-9 V-table-Win
ON LEAVE OF F-PRECIO-9 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(VtaListaMay.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    VtaListaMay.DtoVolD[9]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / VtaListaMay.PreOfi ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN VtaListaMay.DtoVolR[9]:SCREEN-VALUE = '0' VtaListaMay.DtoVolD[9]:SCREEN-VALUE = '0'.
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

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaListaMay"}

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
                VtaListaMay.DtoVolD[x-Orden] = 0.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN lib/logtabla ('VtaListaMay', VtaListaMay.codmat, 'WRITE').   /* Log de cambios */

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
  
  IF AVAILABLE VtaListaMay THEN DO WITH FRAME {&FRAME-NAME}:
     
     F-PRECIO-1 = IF VtaListaMay.DtoVolR[1] <> 0 THEN ROUND(VtaListaMay.PreOfi * ( 1 - ( DtoVolD[1] / 100 ) ),4) ELSE 0.     
     F-PRECIO-2 = IF VtaListaMay.DtoVolR[2] <> 0 THEN ROUND(VtaListaMay.PreOfi * ( 1 - ( DtoVolD[2] / 100 ) ),4) ELSE 0.
     F-PRECIO-3 = IF VtaListaMay.DtoVolR[3] <> 0 THEN ROUND(VtaListaMay.PreOfi * ( 1 - ( DtoVolD[3] / 100 ) ),4) ELSE 0.
     F-PRECIO-4 = IF VtaListaMay.DtoVolR[4] <> 0 THEN ROUND(VtaListaMay.PreOfi * ( 1 - ( DtoVolD[4] / 100 ) ),4) ELSE 0.
     F-PRECIO-5 = IF VtaListaMay.DtoVolR[5] <> 0 THEN ROUND(VtaListaMay.PreOfi * ( 1 - ( DtoVolD[5] / 100 ) ),4) ELSE 0.
     F-PRECIO-6 = IF VtaListaMay.DtoVolR[6] <> 0 THEN ROUND(VtaListaMay.PreOfi * ( 1 - ( DtoVolD[6] / 100 ) ),4) ELSE 0.
     F-PRECIO-7 = IF VtaListaMay.DtoVolR[7] <> 0 THEN ROUND(VtaListaMay.PreOfi * ( 1 - ( DtoVolD[7] / 100 ) ),4) ELSE 0.
     F-PRECIO-8 = IF VtaListaMay.DtoVolR[8] <> 0 THEN ROUND(VtaListaMay.PreOfi * ( 1 - ( DtoVolD[8] / 100 ) ),4) ELSE 0.
     F-PRECIO-9 = IF VtaListaMay.DtoVolR[9] <> 0 THEN ROUND(VtaListaMay.PreOfi * ( 1 - ( DtoVolD[9] / 100 ) ),4) ELSE 0.
     F-PRECIO-10 = IF VtaListaMay.DtoVolR[10] <> 0 THEN ROUND(VtaListaMay.PreOfi * ( 1 - ( DtoVolD[10] / 100 ) ),4) ELSE 0.
     
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
  {src/adm/template/snd-list.i "VtaListaMay"}

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
   /*
   DO I = 1 TO 10 :
      IF INTEGER(VtaListaMay.DtoVolR[I]:SCREEN-VALUE) = 0 THEN NEXT .
      
   
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

