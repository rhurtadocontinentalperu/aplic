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

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Expmmatg
&Scoped-define FIRST-EXTERNAL-TABLE Expmmatg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Expmmatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Expmmatg.DtoVolR[1] Expmmatg.DtoVolD[1] ~
Expmmatg.DtoVolR[2] Expmmatg.DtoVolD[2] Expmmatg.DtoVolR[3] ~
Expmmatg.DtoVolD[3] Expmmatg.DtoVolR[4] Expmmatg.DtoVolD[4] ~
Expmmatg.DtoVolR[5] Expmmatg.DtoVolD[5] Expmmatg.DtoVolR[6] ~
Expmmatg.DtoVolD[6] Expmmatg.DtoVolR[7] Expmmatg.DtoVolD[7] ~
Expmmatg.DtoVolR[8] Expmmatg.DtoVolD[8] Expmmatg.DtoVolR[9] ~
Expmmatg.DtoVolD[9] Expmmatg.DtoVolR[10] Expmmatg.DtoVolD[10] 
&Scoped-define ENABLED-TABLES Expmmatg
&Scoped-define FIRST-ENABLED-TABLE Expmmatg
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-13 RECT-14 
&Scoped-Define DISPLAYED-FIELDS Expmmatg.DtoVolR[1] Expmmatg.DtoVolD[1] ~
Expmmatg.DtoVolR[2] Expmmatg.DtoVolD[2] Expmmatg.DtoVolR[3] ~
Expmmatg.DtoVolD[3] Expmmatg.DtoVolR[4] Expmmatg.DtoVolD[4] ~
Expmmatg.DtoVolR[5] Expmmatg.DtoVolD[5] Expmmatg.DtoVolR[6] ~
Expmmatg.DtoVolD[6] Expmmatg.DtoVolR[7] Expmmatg.DtoVolD[7] ~
Expmmatg.DtoVolR[8] Expmmatg.DtoVolD[8] Expmmatg.DtoVolR[9] ~
Expmmatg.DtoVolD[9] Expmmatg.DtoVolR[10] Expmmatg.DtoVolD[10] ~
Expmmatg.codmat 
&Scoped-define DISPLAYED-TABLES Expmmatg
&Scoped-define FIRST-DISPLAYED-TABLE Expmmatg
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_PreOfi f-DesMat f-UndBas ~
F-PRECIO-1 F-PRECIO-2 F-PRECIO-3 F-PRECIO-4 F-PRECIO-5 F-PRECIO-6 ~
F-PRECIO-7 F-PRECIO-8 F-PRECIO-9 F-PRECIO-10 

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
DEFINE VARIABLE f-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .69
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

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

DEFINE VARIABLE f-UndBas AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN_PreOfi AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     LABEL "Precio Lista" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40.86 BY .85.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 9.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44.29 BY 11.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_PreOfi AT ROW 1.46 COL 29 COLON-ALIGNED WIDGET-ID 6
     f-DesMat AT ROW 2.35 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     f-UndBas AT ROW 1.46 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     Expmmatg.DtoVolR[1] AT ROW 4.19 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Expmmatg.DtoVolD[1] AT ROW 4.19 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Expmmatg.DtoVolR[2] AT ROW 5.04 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Expmmatg.DtoVolD[2] AT ROW 5.04 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Expmmatg.DtoVolR[3] AT ROW 5.85 COL 3.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Expmmatg.DtoVolD[3] AT ROW 5.85 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Expmmatg.DtoVolR[4] AT ROW 6.65 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Expmmatg.DtoVolD[4] AT ROW 6.65 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Expmmatg.DtoVolR[5] AT ROW 7.46 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Expmmatg.DtoVolD[5] AT ROW 7.46 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Expmmatg.DtoVolR[6] AT ROW 8.27 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Expmmatg.DtoVolD[6] AT ROW 8.27 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Expmmatg.DtoVolR[7] AT ROW 9.08 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Expmmatg.DtoVolD[7] AT ROW 9.08 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Expmmatg.DtoVolR[8] AT ROW 9.88 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Expmmatg.DtoVolD[8] AT ROW 9.88 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Expmmatg.DtoVolR[9] AT ROW 10.69 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Expmmatg.DtoVolD[9] AT ROW 10.69 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Expmmatg.DtoVolR[10] AT ROW 11.58 COL 3.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Expmmatg.DtoVolD[10] AT ROW 11.58 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-PRECIO-1 AT ROW 4.19 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-2 AT ROW 5.04 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-3 AT ROW 5.85 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-4 AT ROW 6.65 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-5 AT ROW 7.46 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-6 AT ROW 8.27 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-7 AT ROW 9.08 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-8 AT ROW 9.88 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-9 AT ROW 10.69 COL 28 COLON-ALIGNED NO-LABEL
     F-PRECIO-10 AT ROW 11.58 COL 28 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     Expmmatg.codmat AT ROW 1.46 COL 1.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
          BGCOLOR 15 FGCOLOR 1 
     "Cantidad Minima" VIEW-AS TEXT
          SIZE 11.14 BY .5 AT ROW 3.27 COL 5.14
     "Precio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.27 COL 31.29
     "Descuento %" VIEW-AS TEXT
          SIZE 10.86 BY .5 AT ROW 3.27 COL 18.57
     RECT-10 AT ROW 3.12 COL 2.72
     RECT-13 AT ROW 3.15 COL 2.86
     RECT-14 AT ROW 1.08 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Expmmatg
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
         HEIGHT             = 11.81
         WIDTH              = 44.86.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Expmmatg.codmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-DesMat IN FRAME F-Main
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
/* SETTINGS FOR FILL-IN f-UndBas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PreOfi IN FRAME F-Main
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

&Scoped-define SELF-NAME Expmmatg.DtoVolD[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolD[10] V-table-Win
ON LEAVE OF Expmmatg.DtoVolD[10] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(Expmmatg.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-10 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-10  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolD[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolD[1] V-table-Win
ON LEAVE OF Expmmatg.DtoVolD[1] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(Expmmatg.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-1 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    MESSAGE almmmatg.prealt[4] f-precio-1.
    DISPLAY F-PRECIO-1  .

 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolD[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolD[2] V-table-Win
ON LEAVE OF Expmmatg.DtoVolD[2] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(Expmmatg.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-2 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-2  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolD[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolD[3] V-table-Win
ON LEAVE OF Expmmatg.DtoVolD[3] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(Expmmatg.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-3 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-3  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolD[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolD[4] V-table-Win
ON LEAVE OF Expmmatg.DtoVolD[4] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(Expmmatg.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-4 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-4  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolD[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolD[5] V-table-Win
ON LEAVE OF Expmmatg.DtoVolD[5] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(Expmmatg.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-5 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-5  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolD[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolD[6] V-table-Win
ON LEAVE OF Expmmatg.DtoVolD[6] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(Expmmatg.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-6 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-6  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolD[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolD[7] V-table-Win
ON LEAVE OF Expmmatg.DtoVolD[7] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(Expmmatg.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-7 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-7  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolD[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolD[8] V-table-Win
ON LEAVE OF Expmmatg.DtoVolD[8] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(Expmmatg.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-8 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-8  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolD[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolD[9] V-table-Win
ON LEAVE OF Expmmatg.DtoVolD[9] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(Expmmatg.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-9 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-9  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolR[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolR[10] V-table-Win
ON LEAVE OF Expmmatg.DtoVolR[10] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[10]:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-10 = 0 .
       DISPLAY  F-PRECIO-10 
                0 @ Expmmatg.DtoVolD[10].
       RETURN.
    END.
    F-PRECIO-10 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(Expmmatg.DtoVolD[10]:SCREEN-VALUE) / 100 ) ),4).    
    DISPLAY F-PRECIO-10.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolR[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolR[1] V-table-Win
ON LEAVE OF Expmmatg.DtoVolR[1] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[1]:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-1 = 0 .
       DISPLAY  F-PRECIO-1 
                0 @ Expmmatg.DtoVolD[1].
       RETURN.
    END.
    F-PRECIO-1 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(Expmmatg.DtoVolD[1]:SCREEN-VALUE) / 100 ) ),4).    
    DISPLAY F-PRECIO-1.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolR[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolR[2] V-table-Win
ON LEAVE OF Expmmatg.DtoVolR[2] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[2]:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-2 = 0 .
       DISPLAY  F-PRECIO-2 
                0 @ Expmmatg.DtoVolD[2].
       RETURN.
    END.
    F-PRECIO-2 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(Expmmatg.DtoVolD[2]:SCREEN-VALUE) / 100 ) ),4).    
    DISPLAY F-PRECIO-2.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolR[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolR[3] V-table-Win
ON LEAVE OF Expmmatg.DtoVolR[3] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[3]:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-3 = 0 .
       DISPLAY  F-PRECIO-3 
                0 @ Expmmatg.DtoVolD[3].
       RETURN.
    END.
    F-PRECIO-3 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(Expmmatg.DtoVolD[3]:SCREEN-VALUE) / 100 ) ),4).    
    DISPLAY F-PRECIO-3.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolR[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolR[4] V-table-Win
ON LEAVE OF Expmmatg.DtoVolR[4] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[4]:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-4 = 0 .
       DISPLAY  F-PRECIO-4 
                0 @ Expmmatg.DtoVolD[4].
       RETURN.
    END.
    F-PRECIO-4 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(Expmmatg.DtoVolD[4]:SCREEN-VALUE) / 100 ) ),4).    
    DISPLAY F-PRECIO-4.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolR[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolR[5] V-table-Win
ON LEAVE OF Expmmatg.DtoVolR[5] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[5]:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-5 = 0 .
       DISPLAY  F-PRECIO-5 
                0 @ Expmmatg.DtoVolD[5].
       RETURN.
    END.
    F-PRECIO-5 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(Expmmatg.DtoVolD[5]:SCREEN-VALUE) / 100 ) ),4).    
    DISPLAY F-PRECIO-5.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolR[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolR[6] V-table-Win
ON LEAVE OF Expmmatg.DtoVolR[6] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[6]:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-6 = 0 .
       DISPLAY  F-PRECIO-6 
                0 @ Expmmatg.DtoVolD[6].
       RETURN.
    END.
    F-PRECIO-6 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(Expmmatg.DtoVolD[6]:SCREEN-VALUE) / 100 ) ),4).    
    DISPLAY F-PRECIO-6.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolR[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolR[7] V-table-Win
ON LEAVE OF Expmmatg.DtoVolR[7] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[7]:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-7 = 0 .
       DISPLAY  F-PRECIO-7 
                0 @ Expmmatg.DtoVolD[7].
       RETURN.
    END.
    F-PRECIO-7 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(Expmmatg.DtoVolD[7]:SCREEN-VALUE) / 100 ) ),4).    
    DISPLAY F-PRECIO-7.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolR[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolR[8] V-table-Win
ON LEAVE OF Expmmatg.DtoVolR[8] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[8]:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-8 = 0 .
       DISPLAY  F-PRECIO-8 
                0 @ Expmmatg.DtoVolD[8].
       RETURN.
    END.
    F-PRECIO-8 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(Expmmatg.DtoVolD[8]:SCREEN-VALUE) / 100 ) ),4).    
    DISPLAY F-PRECIO-8.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Expmmatg.DtoVolR[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Expmmatg.DtoVolR[9] V-table-Win
ON LEAVE OF Expmmatg.DtoVolR[9] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Expmmatg.DtoVolR[9]:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-9 = 0 .
       DISPLAY  F-PRECIO-9 
                0 @ Expmmatg.DtoVolD[9].
       RETURN.
    END.
    F-PRECIO-9 = ROUND(Almmmatg.PreAlt[3] * ( 1 - ( DECI(Expmmatg.DtoVolD[9]:SCREEN-VALUE) / 100 ) ),4).    
    DISPLAY F-PRECIO-9.
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
  {src/adm/template/row-list.i "Expmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Expmmatg"}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /*Expmmatg.fchact = TODAY.*/
  
  RUN lib/logtabla ('Expmmatg', Expmmatg.codmat, 'WRITE').   /* Log de cambios */

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
  IF AVAILABLE Expmmatg THEN DO WITH FRAME {&FRAME-NAME}:
      FIND Almmmatg OF Expmmatg NO-LOCK.
      FILL-IN_PreOfi = Almmmatg.PreAlt[3].
     
     F-PRECIO-1 = IF Expmmatg.DtoVolR[1] <> 0 THEN ROUND(Almmmatg.PreAlt[3] * ( 1 - ( Expmmatg.DtoVolD[1] / 100 ) ),4) ELSE 0.     
     F-PRECIO-2 = IF Expmmatg.DtoVolR[2] <> 0 THEN ROUND(Almmmatg.PreAlt[3] * ( 1 - ( Expmmatg.DtoVolD[2] / 100 ) ),4) ELSE 0.
     F-PRECIO-3 = IF Expmmatg.DtoVolR[3] <> 0 THEN ROUND(Almmmatg.PreAlt[3] * ( 1 - ( Expmmatg.DtoVolD[3] / 100 ) ),4) ELSE 0.
     F-PRECIO-4 = IF Expmmatg.DtoVolR[4] <> 0 THEN ROUND(Almmmatg.PreAlt[3] * ( 1 - ( Expmmatg.DtoVolD[4] / 100 ) ),4) ELSE 0.
     F-PRECIO-5 = IF Expmmatg.DtoVolR[5] <> 0 THEN ROUND(Almmmatg.PreAlt[3] * ( 1 - ( Expmmatg.DtoVolD[5] / 100 ) ),4) ELSE 0.
     F-PRECIO-6 = IF Expmmatg.DtoVolR[6] <> 0 THEN ROUND(Almmmatg.PreAlt[3] * ( 1 - ( Expmmatg.DtoVolD[6] / 100 ) ),4) ELSE 0.
     F-PRECIO-7 = IF Expmmatg.DtoVolR[7] <> 0 THEN ROUND(Almmmatg.PreAlt[3] * ( 1 - ( Expmmatg.DtoVolD[7] / 100 ) ),4) ELSE 0.
     F-PRECIO-8 = IF Expmmatg.DtoVolR[8] <> 0 THEN ROUND(Almmmatg.PreAlt[3] * ( 1 - ( Expmmatg.DtoVolD[8] / 100 ) ),4) ELSE 0.
     F-PRECIO-9 = IF Expmmatg.DtoVolR[9] <> 0 THEN ROUND(Almmmatg.PreAlt[3] * ( 1 - ( Expmmatg.DtoVolD[9] / 100 ) ),4) ELSE 0.
     F-PRECIO-10 = IF Expmmatg.DtoVolR[10] <> 0 THEN ROUND(Almmmatg.PreAlt[3] * ( 1 - ( Expmmatg.DtoVolD[10] / 100 ) ),4) ELSE 0.
     
     DISPLAY F-PRECIO-1 F-PRECIO-2 F-PRECIO-3 F-PRECIO-4 F-PRECIO-5
             F-PRECIO-6 F-PRECIO-7 F-PRECIO-8 F-PRECIO-9 F-PRECIO-10
         FILL-IN_PreOfi
             Almmmatg.UndBas @ f-UndBas Almmmatg.DesMat @ f-DEsMat.
     
  
  END.
  
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "Expmmatg"}

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
      IF INTEGER(Expmmatg.DtoVolR[I]:SCREEN-VALUE) = 0 THEN NEXT .
      
   
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

