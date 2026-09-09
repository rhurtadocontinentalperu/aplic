&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-MATG LIKE Almmmatg.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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
&Scoped-define EXTERNAL-TABLES T-MATG
&Scoped-define FIRST-EXTERNAL-TABLE T-MATG


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR T-MATG.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS T-MATG.DtoVolR[1] T-MATG.DtoVolD[1] ~
T-MATG.DtoVolR[2] T-MATG.DtoVolD[2] T-MATG.DtoVolR[3] T-MATG.DtoVolD[3] ~
T-MATG.DtoVolR[4] T-MATG.DtoVolD[4] T-MATG.DtoVolR[5] T-MATG.DtoVolD[5] ~
T-MATG.DtoVolR[6] T-MATG.DtoVolD[6] T-MATG.DtoVolR[7] T-MATG.DtoVolD[7] ~
T-MATG.DtoVolR[8] T-MATG.DtoVolD[8] T-MATG.DtoVolR[9] T-MATG.DtoVolD[9] ~
T-MATG.DtoVolR[10] T-MATG.DtoVolD[10] 
&Scoped-define ENABLED-TABLES T-MATG
&Scoped-define FIRST-ENABLED-TABLE T-MATG
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-66 
&Scoped-Define DISPLAYED-FIELDS T-MATG.DtoVolR[1] T-MATG.DtoVolD[1] ~
T-MATG.DtoVolR[2] T-MATG.DtoVolD[2] T-MATG.DtoVolR[3] T-MATG.DtoVolD[3] ~
T-MATG.DtoVolR[4] T-MATG.DtoVolD[4] T-MATG.DtoVolR[5] T-MATG.DtoVolD[5] ~
T-MATG.DtoVolR[6] T-MATG.DtoVolD[6] T-MATG.DtoVolR[7] T-MATG.DtoVolD[7] ~
T-MATG.DtoVolR[8] T-MATG.DtoVolD[8] T-MATG.DtoVolR[9] T-MATG.DtoVolD[9] ~
T-MATG.DtoVolR[10] T-MATG.DtoVolD[10] 
&Scoped-define DISPLAYED-TABLES T-MATG
&Scoped-define FIRST-DISPLAYED-TABLE T-MATG
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

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 10.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     T-MATG.DtoVolR[1] AT ROW 2.15 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.DtoVolD[1] AT ROW 2.15 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 52 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-PRECIO-1 AT ROW 2.15 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     T-MATG.DtoVolR[2] AT ROW 3.12 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.DtoVolD[2] AT ROW 3.12 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 54 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-PRECIO-2 AT ROW 3.12 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     T-MATG.DtoVolR[3] AT ROW 4.08 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.DtoVolD[3] AT ROW 4.08 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 56 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-PRECIO-3 AT ROW 4.08 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     T-MATG.DtoVolR[4] AT ROW 5.04 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.DtoVolD[4] AT ROW 5.04 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 58 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-PRECIO-4 AT ROW 5.04 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     T-MATG.DtoVolR[5] AT ROW 6 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.DtoVolD[5] AT ROW 6 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 60 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-PRECIO-5 AT ROW 6 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     T-MATG.DtoVolR[6] AT ROW 6.96 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.DtoVolD[6] AT ROW 6.96 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 62 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-PRECIO-6 AT ROW 6.96 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     T-MATG.DtoVolR[7] AT ROW 7.92 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.DtoVolD[7] AT ROW 7.92 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 64 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-PRECIO-7 AT ROW 7.92 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     T-MATG.DtoVolR[8] AT ROW 8.88 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.DtoVolD[8] AT ROW 8.88 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 66 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-PRECIO-8 AT ROW 8.88 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     T-MATG.DtoVolR[9] AT ROW 9.85 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.DtoVolD[9] AT ROW 9.85 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 68 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-PRECIO-9 AT ROW 9.85 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 88
     T-MATG.DtoVolR[10] AT ROW 10.81 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     T-MATG.DtoVolD[10] AT ROW 10.81 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 50 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-PRECIO-10 AT ROW 10.81 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     "Precio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.35 COL 30.57 WIDGET-ID 48
     "Descuento %" VIEW-AS TEXT
          SIZE 10.86 BY .5 AT ROW 1.35 COL 17.86 WIDGET-ID 44
     "Cantidad Minima" VIEW-AS TEXT
          SIZE 11.14 BY .5 AT ROW 1.35 COL 4.43 WIDGET-ID 46
     RECT-10 AT ROW 1.19 COL 2 WIDGET-ID 42
     RECT-66 AT ROW 1.96 COL 2 WIDGET-ID 90
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: Temp-Tables.T-MATG
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-MATG T "SHARED" ? INTEGRAL Almmmatg
   END-TABLES.
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
         HEIGHT             = 14
         WIDTH              = 54.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN T-MATG.DtoVolD[10] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.DtoVolD[1] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.DtoVolD[2] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.DtoVolD[3] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.DtoVolD[4] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.DtoVolD[5] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.DtoVolD[6] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.DtoVolD[7] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.DtoVolD[8] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.DtoVolD[9] IN FRAME F-Main
   EXP-FORMAT                                                           */
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

&Scoped-define SELF-NAME T-MATG.DtoVolD[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolD[10] V-table-Win
ON LEAVE OF T-MATG.DtoVolD[10] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(T-MATG.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-10 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-10 = 0.
    DISPLAY F-PRECIO-10  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolD[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolD[1] V-table-Win
ON LEAVE OF T-MATG.DtoVolD[1] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(T-MATG.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-1 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-1 = 0.
    DISPLAY F-PRECIO-1  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolD[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolD[2] V-table-Win
ON LEAVE OF T-MATG.DtoVolD[2] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(T-MATG.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-2 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-2 = 0.
    DISPLAY F-PRECIO-2  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolD[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolD[3] V-table-Win
ON LEAVE OF T-MATG.DtoVolD[3] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(T-MATG.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-3 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-3 = 0.
    DISPLAY F-PRECIO-3  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolD[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolD[4] V-table-Win
ON LEAVE OF T-MATG.DtoVolD[4] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(T-MATG.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-4 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-4 = 0.
    DISPLAY F-PRECIO-4  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolD[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolD[5] V-table-Win
ON LEAVE OF T-MATG.DtoVolD[5] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(T-MATG.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-5 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-5 = 0.
    DISPLAY F-PRECIO-5  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolD[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolD[6] V-table-Win
ON LEAVE OF T-MATG.DtoVolD[6] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(T-MATG.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-6 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-6 = 0.
    DISPLAY F-PRECIO-6  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolD[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolD[7] V-table-Win
ON LEAVE OF T-MATG.DtoVolD[7] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(T-MATG.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-7 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-7 = 0.
    DISPLAY F-PRECIO-7  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolD[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolD[8] V-table-Win
ON LEAVE OF T-MATG.DtoVolD[8] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(T-MATG.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-8 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-8 = 0.
    DISPLAY F-PRECIO-8  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolD[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolD[9] V-table-Win
ON LEAVE OF T-MATG.DtoVolD[9] IN FRAME F-Main /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(T-MATG.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-9 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN F-PRECIO-9 = 0.
    DISPLAY F-PRECIO-9  .
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolR[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolR[10] V-table-Win
ON LEAVE OF T-MATG.DtoVolR[10] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-10 = 0 .
       DISPLAY  
           F-PRECIO-10 
           0 @ T-MATG.DtoVolD[10].
       RETURN.
    END.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolR[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolR[1] V-table-Win
ON LEAVE OF T-MATG.DtoVolR[1] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-1 = 0 .
       DISPLAY  
           F-PRECIO-1 
           0 @ T-MATG.DtoVolD[1].
       RETURN.
    END.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolR[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolR[2] V-table-Win
ON LEAVE OF T-MATG.DtoVolR[2] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-2 = 0 .
       DISPLAY  
           F-PRECIO-2
           0 @ T-MATG.DtoVolD[2].
       RETURN.
    END.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolR[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolR[3] V-table-Win
ON LEAVE OF T-MATG.DtoVolR[3] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-3 = 0 .
       DISPLAY  
           F-PRECIO-3 
           0 @ T-MATG.DtoVolD[3].
       RETURN.
    END.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolR[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolR[4] V-table-Win
ON LEAVE OF T-MATG.DtoVolR[4] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-4 = 0 .
       DISPLAY  
           F-PRECIO-4 
           0 @ T-MATG.DtoVolD[4].
       RETURN.
    END.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolR[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolR[5] V-table-Win
ON LEAVE OF T-MATG.DtoVolR[5] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-5 = 0 .
       DISPLAY  
           F-PRECIO-5 
           0 @ T-MATG.DtoVolD[5].
       RETURN.
    END.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolR[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolR[6] V-table-Win
ON LEAVE OF T-MATG.DtoVolR[6] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-6 = 0 .
       DISPLAY  
           F-PRECIO-6 
           0 @ T-MATG.DtoVolD[6].
       RETURN.
    END.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolR[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolR[7] V-table-Win
ON LEAVE OF T-MATG.DtoVolR[7] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-7 = 0 .
       DISPLAY  
           F-PRECIO-7 
           0 @ T-MATG.DtoVolD[7].
       RETURN.
    END.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolR[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolR[8] V-table-Win
ON LEAVE OF T-MATG.DtoVolR[8] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-8 = 0 .
       DISPLAY  
           F-PRECIO-8 
           0 @ T-MATG.DtoVolD[8].
       RETURN.
    END.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.DtoVolR[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.DtoVolR[9] V-table-Win
ON LEAVE OF T-MATG.DtoVolR[9] IN FRAME F-Main /* DtoVolR */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(SELF:SCREEN-VALUE) = 0  THEN DO:
       F-PRECIO-9 = 0 .
       DISPLAY  
           F-PRECIO-9
           0 @ T-MATG.DtoVolD[9].
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
    IF INTEGER(T-MATG.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    T-MATG.DtoVolD[1]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1] ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN T-MATG.DtoVolR[1]:SCREEN-VALUE = '0' T-MATG.DtoVolD[1]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-10 V-table-Win
ON LEAVE OF F-PRECIO-10 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    T-MATG.DtoVolD[10]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1] ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN T-MATG.DtoVolR[10]:SCREEN-VALUE = '0' T-MATG.DtoVolD[10]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-2 V-table-Win
ON LEAVE OF F-PRECIO-2 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    T-MATG.DtoVolD[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1] ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN T-MATG.DtoVolR[2]:SCREEN-VALUE = '0' T-MATG.DtoVolD[2]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-3 V-table-Win
ON LEAVE OF F-PRECIO-3 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    T-MATG.DtoVolD[3]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1] ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN T-MATG.DtoVolR[3]:SCREEN-VALUE = '0' T-MATG.DtoVolD[3]:SCREEN-VALUE = '0'.
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-4 V-table-Win
ON LEAVE OF F-PRECIO-4 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    T-MATG.DtoVolD[4]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1] ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN T-MATG.DtoVolR[4]:SCREEN-VALUE = '0' T-MATG.DtoVolD[4]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-5 V-table-Win
ON LEAVE OF F-PRECIO-5 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    T-MATG.DtoVolD[5]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1] ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN T-MATG.DtoVolR[5]:SCREEN-VALUE = '0' T-MATG.DtoVolD[5]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-6 V-table-Win
ON LEAVE OF F-PRECIO-6 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    T-MATG.DtoVolD[6]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1] ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN T-MATG.DtoVolR[6]:SCREEN-VALUE = '0' T-MATG.DtoVolD[6]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-7 V-table-Win
ON LEAVE OF F-PRECIO-7 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    T-MATG.DtoVolD[7]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1] ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN T-MATG.DtoVolR[7]:SCREEN-VALUE = '0' T-MATG.DtoVolD[7]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-8 V-table-Win
ON LEAVE OF F-PRECIO-8 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    T-MATG.DtoVolD[8]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1] ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN T-MATG.DtoVolR[8]:SCREEN-VALUE = '0' T-MATG.DtoVolD[8]:SCREEN-VALUE = '0'.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-9 V-table-Win
ON LEAVE OF F-PRECIO-9 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(T-MATG.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    T-MATG.DtoVolD[9]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1] ) * 100, 4 ) ).
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN ASSIGN T-MATG.DtoVolR[9]:SCREEN-VALUE = '0' T-MATG.DtoVolD[9]:SCREEN-VALUE = '0'.
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
  {src/adm/template/row-list.i "T-MATG"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "T-MATG"}

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
  DO x-Orden = 1 TO 10:
      IF T-MATG.DtoVolR[x-Orden] = 0 OR T-MATG.DtoVolD[x-Orden] = 0
      THEN ASSIGN
                T-MATG.DtoVolR[x-Orden] = 0
                T-MATG.DtoVolD[x-Orden] = 0.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  IF AVAILABLE T-MATG THEN DO WITH FRAME {&FRAME-NAME}:
     F-PRECIO-1 = IF DtoVolR[1] <> 0 THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( DtoVolD[1] / 100 ) ),4) ELSE 0.     
     F-PRECIO-2 = IF DtoVolR[2] <> 0 THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( DtoVolD[2] / 100 ) ),4) ELSE 0.
     F-PRECIO-3 = IF DtoVolR[3] <> 0 THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( DtoVolD[3] / 100 ) ),4) ELSE 0.
     F-PRECIO-4 = IF DtoVolR[4] <> 0 THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( DtoVolD[4] / 100 ) ),4) ELSE 0.
     F-PRECIO-5 = IF DtoVolR[5] <> 0 THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( DtoVolD[5] / 100 ) ),4) ELSE 0.
     F-PRECIO-6 = IF DtoVolR[6] <> 0 THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( DtoVolD[6] / 100 ) ),4) ELSE 0.
     F-PRECIO-7 = IF DtoVolR[7] <> 0 THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( DtoVolD[7] / 100 ) ),4) ELSE 0.
     F-PRECIO-8 = IF DtoVolR[8] <> 0 THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( DtoVolD[8] / 100 ) ),4) ELSE 0.
     F-PRECIO-9 = IF DtoVolR[9] <> 0 THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( DtoVolD[9] / 100 ) ),4) ELSE 0.
     F-PRECIO-10 = IF DtoVolR[10] <> 0 THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( DtoVolD[10] / 100 ) ),4) ELSE 0.
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
  {src/adm/template/snd-list.i "T-MATG"}

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.    
DEF VAR x-PreUni AS DECI NO-UNDO.
DO WITH FRAME {&FRAME-NAME} :
    DO k = 1 TO 10:
        x-PreUni =  INPUT T-MATG.DtoVolD[k].
        IF x-PreUni < 0 THEN DO:
            MESSAGE 'NO se aceptan descuentos negativos' VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.

END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

