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

DEF SHARED VAR s-codcia AS INT.

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
&Scoped-Define ENABLED-FIELDS T-MATG.PromDivi[1] T-MATG.PromFchD[1] ~
T-MATG.PromFchH[1] T-MATG.PromDto[1] T-MATG.PromDivi[2] T-MATG.PromFchD[2] ~
T-MATG.PromFchH[2] T-MATG.PromDto[2] T-MATG.PromDivi[3] T-MATG.PromFchD[3] ~
T-MATG.PromFchH[3] T-MATG.PromDto[3] T-MATG.PromDivi[4] T-MATG.PromFchD[4] ~
T-MATG.PromFchH[4] T-MATG.PromDto[4] T-MATG.PromDivi[5] T-MATG.PromFchD[5] ~
T-MATG.PromFchH[5] T-MATG.PromDto[5] T-MATG.PromDivi[6] T-MATG.PromFchD[6] ~
T-MATG.PromFchH[6] T-MATG.PromDto[6] T-MATG.PromDivi[7] T-MATG.PromFchD[7] ~
T-MATG.PromFchH[7] T-MATG.PromDto[7] T-MATG.PromDivi[8] T-MATG.PromFchD[8] ~
T-MATG.PromFchH[8] T-MATG.PromDto[8] T-MATG.PromDivi[9] T-MATG.PromFchD[9] ~
T-MATG.PromFchH[9] T-MATG.PromDto[9] T-MATG.PromDivi[10] ~
T-MATG.PromFchD[10] T-MATG.PromFchH[10] T-MATG.PromDto[10] 
&Scoped-define ENABLED-TABLES T-MATG
&Scoped-define FIRST-ENABLED-TABLE T-MATG
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-66 
&Scoped-Define DISPLAYED-FIELDS T-MATG.PromDivi[1] T-MATG.PromFchD[1] ~
T-MATG.PromFchH[1] T-MATG.PromDto[1] T-MATG.PromDivi[2] T-MATG.PromFchD[2] ~
T-MATG.PromFchH[2] T-MATG.PromDto[2] T-MATG.PromDivi[3] T-MATG.PromFchD[3] ~
T-MATG.PromFchH[3] T-MATG.PromDto[3] T-MATG.PromDivi[4] T-MATG.PromFchD[4] ~
T-MATG.PromFchH[4] T-MATG.PromDto[4] T-MATG.PromDivi[5] T-MATG.PromFchD[5] ~
T-MATG.PromFchH[5] T-MATG.PromDto[5] T-MATG.PromDivi[6] T-MATG.PromFchD[6] ~
T-MATG.PromFchH[6] T-MATG.PromDto[6] T-MATG.PromDivi[7] T-MATG.PromFchD[7] ~
T-MATG.PromFchH[7] T-MATG.PromDto[7] T-MATG.PromDivi[8] T-MATG.PromFchD[8] ~
T-MATG.PromFchH[8] T-MATG.PromDto[8] T-MATG.PromDivi[9] T-MATG.PromFchD[9] ~
T-MATG.PromFchH[9] T-MATG.PromDto[9] T-MATG.PromDivi[10] ~
T-MATG.PromFchD[10] T-MATG.PromFchH[10] T-MATG.PromDto[10] 
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
     SIZE 51.29 BY .85.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 10.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     T-MATG.PromDivi[1] AT ROW 2.15 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 4 FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     T-MATG.PromFchD[1] AT ROW 2.15 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromFchH[1] AT ROW 2.15 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromDto[1] AT ROW 2.15 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 24 FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .81
     F-PRECIO-1 AT ROW 2.15 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 94
     T-MATG.PromDivi[2] AT ROW 3.12 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 6 FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     T-MATG.PromFchD[2] AT ROW 3.12 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromFchH[2] AT ROW 3.12 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromDto[2] AT ROW 3.12 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 26 FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .81
     F-PRECIO-2 AT ROW 3.12 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 98
     T-MATG.PromDivi[3] AT ROW 4.08 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 8 FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     T-MATG.PromFchD[3] AT ROW 4.08 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromFchH[3] AT ROW 4.08 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromDto[3] AT ROW 4.08 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 28 FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .81
     F-PRECIO-3 AT ROW 4.08 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 100
     T-MATG.PromDivi[4] AT ROW 5.04 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 10 FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     T-MATG.PromFchD[4] AT ROW 5.04 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromFchH[4] AT ROW 5.04 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 70
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromDto[4] AT ROW 5.04 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 30 FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .81
     F-PRECIO-4 AT ROW 5.04 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 102
     T-MATG.PromDivi[5] AT ROW 6 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 12 FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     T-MATG.PromFchD[5] AT ROW 6 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromFchH[5] AT ROW 6 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 72
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromDto[5] AT ROW 6 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 32 FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .81
     F-PRECIO-5 AT ROW 6 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 104
     T-MATG.PromDivi[6] AT ROW 6.96 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 14 FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     T-MATG.PromFchD[6] AT ROW 6.96 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromFchH[6] AT ROW 6.96 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 74
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromDto[6] AT ROW 6.96 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 34 FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .81
     F-PRECIO-6 AT ROW 6.96 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 106
     T-MATG.PromDivi[7] AT ROW 7.92 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 16 FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     T-MATG.PromFchD[7] AT ROW 7.92 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromFchH[7] AT ROW 7.92 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 76
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromDto[7] AT ROW 7.92 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 36 FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .81
     F-PRECIO-7 AT ROW 7.92 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     T-MATG.PromDivi[8] AT ROW 8.88 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 18 FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     T-MATG.PromFchD[8] AT ROW 8.88 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 58
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromFchH[8] AT ROW 8.88 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 78
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromDto[8] AT ROW 8.88 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 38 FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .81
     F-PRECIO-8 AT ROW 8.88 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 110
     T-MATG.PromDivi[9] AT ROW 9.85 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 20 FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     T-MATG.PromFchD[9] AT ROW 9.85 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromFchH[9] AT ROW 9.85 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 80
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromDto[9] AT ROW 9.85 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 40 FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .81
     F-PRECIO-9 AT ROW 9.85 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 112
     T-MATG.PromDivi[10] AT ROW 10.81 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 2 FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     T-MATG.PromFchD[10] AT ROW 10.81 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromFchH[10] AT ROW 10.81 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     T-MATG.PromDto[10] AT ROW 10.81 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 22 FORMAT "->9.9999"
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .81
     F-PRECIO-10 AT ROW 10.81 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 96
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Division" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.31 COL 3.86 WIDGET-ID 84
     "Descuento" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.38 COL 34.57 WIDGET-ID 92
     "Inicio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.31 COL 12.86 WIDGET-ID 90
     "Fin" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.35 COL 24 WIDGET-ID 88
     "Precio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.38 COL 44.14 WIDGET-ID 86
     RECT-10 AT ROW 1.19 COL 3 WIDGET-ID 82
     RECT-66 AT ROW 1.96 COL 3 WIDGET-ID 114
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
         HEIGHT             = 13.23
         WIDTH              = 58.
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
/* SETTINGS FOR FILL-IN T-MATG.PromDivi[10] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDivi[1] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDivi[2] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDivi[3] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDivi[4] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDivi[5] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDivi[6] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDivi[7] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDivi[8] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDivi[9] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDto[10] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDto[1] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDto[2] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDto[3] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDto[4] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDto[5] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDto[6] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDto[7] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDto[8] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN T-MATG.PromDto[9] IN FRAME F-Main
   EXP-FORMAT                                                           */
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
    IF T-MATG.PromDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[1]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[1]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-10 V-table-Win
ON LEAVE OF F-PRECIO-10 IN FRAME F-Main
DO:
   DO WITH FRAME {&FRAME-NAME}:
    IF T-MATG.PromDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[10]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[10]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-2 V-table-Win
ON LEAVE OF F-PRECIO-2 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF T-MATG.PromDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[2]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[2]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-3 V-table-Win
ON LEAVE OF F-PRECIO-3 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF T-MATG.PromDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[3]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[3]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1]  ) * 100, 4 ) ).
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-4 V-table-Win
ON LEAVE OF F-PRECIO-4 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF T-MATG.PromDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[4]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[4]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-5 V-table-Win
ON LEAVE OF F-PRECIO-5 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF T-MATG.PromDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[5]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[5]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-6 V-table-Win
ON LEAVE OF F-PRECIO-6 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF T-MATG.PromDivi[6]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[6]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[6]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[6]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-7 V-table-Win
ON LEAVE OF F-PRECIO-7 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF T-MATG.PromDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[7]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[7]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-8 V-table-Win
ON LEAVE OF F-PRECIO-8 IN FRAME F-Main
DO:
   DO WITH FRAME {&FRAME-NAME}:
    IF T-MATG.PromDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[8]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[8]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1]  ) * 100, 4 ) ).
 END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PRECIO-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PRECIO-9 V-table-Win
ON LEAVE OF F-PRECIO-9 IN FRAME F-Main
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF T-MATG.PromDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN DO:
        PromDto[9]:SCREEN-VALUE = '0'.
        RETURN.
    END.
    PromDto[9]:SCREEN-VALUE = STRING ( ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / T-MATG.PreVta[1]  ) * 100, 4 ) ).
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDivi[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDivi[10] V-table-Win
ON LEAVE OF T-MATG.PromDivi[10] IN FRAME F-Main /* PromDivi */
DO:
    IF SELF:SCREEN-VALUE = "" THEN DO:
        F-PRECIO-10 = 0.
        ASSIGN
            T-MATG.PromDto[10]:SCREEN-VALUE = '0'
            T-MATG.PromFchD[10]:SCREEN-VALUE = ''
            T-MATG.PromFchH[10]:SCREEN-VALUE = ''.
        RETURN.
    END.
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
        AND Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division  No Existe " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-PRECIO-10 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(T-MATG.PromDto[10]:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-10 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDivi[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDivi[1] V-table-Win
ON LEAVE OF T-MATG.PromDivi[1] IN FRAME F-Main /* PromDivi */
DO:
    IF SELF:SCREEN-VALUE = "" THEN DO:
        F-PRECIO-1 = 0.
        ASSIGN
            T-MATG.PromDto[1]:SCREEN-VALUE = '0'
            T-MATG.PromFchD[1]:SCREEN-VALUE = ''
            T-MATG.PromFchH[1]:SCREEN-VALUE = ''.
        RETURN.
    END.
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
        AND Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division  No Existe " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-PRECIO-1 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(T-MATG.PromDto[1]:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-1 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDivi[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDivi[2] V-table-Win
ON LEAVE OF T-MATG.PromDivi[2] IN FRAME F-Main /* PromDivi */
DO:
    IF SELF:SCREEN-VALUE = "" THEN DO:
        F-PRECIO-2 = 0.
        ASSIGN
            T-MATG.PromDto[2]:SCREEN-VALUE = '0'
            T-MATG.PromFchD[2]:SCREEN-VALUE = ''
            T-MATG.PromFchH[2]:SCREEN-VALUE = ''.
        RETURN.
    END.
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
        AND Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division  No Existe " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-PRECIO-2 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(T-MATG.PromDto[2]:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-2 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDivi[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDivi[3] V-table-Win
ON LEAVE OF T-MATG.PromDivi[3] IN FRAME F-Main /* PromDivi */
DO:
    IF SELF:SCREEN-VALUE = "" THEN DO:
        F-PRECIO-3 = 0.
        ASSIGN
            T-MATG.PromDto[3]:SCREEN-VALUE = '0'
            T-MATG.PromFchD[3]:SCREEN-VALUE = ''
            T-MATG.PromFchH[3]:SCREEN-VALUE = ''.
        RETURN.
    END.
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
        AND Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division  No Existe " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-PRECIO-3 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(T-MATG.PromDto[3]:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-3 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDivi[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDivi[4] V-table-Win
ON LEAVE OF T-MATG.PromDivi[4] IN FRAME F-Main /* PromDivi */
DO:
    IF SELF:SCREEN-VALUE = "" THEN DO:
        F-PRECIO-4 = 0.
        ASSIGN
            T-MATG.PromDto[4]:SCREEN-VALUE = '0'
            T-MATG.PromFchD[4]:SCREEN-VALUE = ''
            T-MATG.PromFchH[4]:SCREEN-VALUE = ''.
        RETURN.
    END.
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
        AND Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division  No Existe " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-PRECIO-4 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(T-MATG.PromDto[4]:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-4 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDivi[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDivi[5] V-table-Win
ON LEAVE OF T-MATG.PromDivi[5] IN FRAME F-Main /* PromDivi */
DO:
    IF SELF:SCREEN-VALUE = "" THEN DO:
        F-PRECIO-5 = 0.
        ASSIGN
            T-MATG.PromDto[5]:SCREEN-VALUE = '0'
            T-MATG.PromFchD[5]:SCREEN-VALUE = ''
            T-MATG.PromFchH[5]:SCREEN-VALUE = ''.
        RETURN.
    END.
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
        AND Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division  No Existe " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-PRECIO-5 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(T-MATG.PromDto[5]:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-5 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDivi[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDivi[6] V-table-Win
ON LEAVE OF T-MATG.PromDivi[6] IN FRAME F-Main /* PromDivi */
DO:
    IF SELF:SCREEN-VALUE = "" THEN DO:
        F-PRECIO-6 = 0.
        ASSIGN
            T-MATG.PromDto[6]:SCREEN-VALUE = '0'
            T-MATG.PromFchD[6]:SCREEN-VALUE = ''
            T-MATG.PromFchH[6]:SCREEN-VALUE = ''.
        RETURN.
    END.
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
        AND Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division  No Existe " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-PRECIO-6 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(T-MATG.PromDto[6]:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-6 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDivi[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDivi[7] V-table-Win
ON LEAVE OF T-MATG.PromDivi[7] IN FRAME F-Main /* PromDivi */
DO:
    IF SELF:SCREEN-VALUE = "" THEN DO:
        F-PRECIO-7 = 0.
        ASSIGN
            T-MATG.PromDto[7]:SCREEN-VALUE = '0'
            T-MATG.PromFchD[7]:SCREEN-VALUE = ''
            T-MATG.PromFchH[7]:SCREEN-VALUE = ''.
        RETURN.
    END.
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
        AND Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division  No Existe " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-PRECIO-7 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(T-MATG.PromDto[7]:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-7 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDivi[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDivi[8] V-table-Win
ON LEAVE OF T-MATG.PromDivi[8] IN FRAME F-Main /* PromDivi */
DO:
    IF SELF:SCREEN-VALUE = "" THEN DO:
        F-PRECIO-8 = 0.
        ASSIGN
            T-MATG.PromDto[8]:SCREEN-VALUE = '0'
            T-MATG.PromFchD[8]:SCREEN-VALUE = ''
            T-MATG.PromFchH[8]:SCREEN-VALUE = ''.
        RETURN.
    END.
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
        AND Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division  No Existe " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-PRECIO-8 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(T-MATG.PromDto[8]:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-8 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDivi[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDivi[9] V-table-Win
ON LEAVE OF T-MATG.PromDivi[9] IN FRAME F-Main /* PromDivi */
DO:
    IF SELF:SCREEN-VALUE = "" THEN DO:
        F-PRECIO-9 = 0.
        ASSIGN
            T-MATG.PromDto[9]:SCREEN-VALUE = '0'
            T-MATG.PromFchD[9]:SCREEN-VALUE = ''
            T-MATG.PromFchH[9]:SCREEN-VALUE = ''.
        RETURN.
    END.
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
        AND Gn-Divi.Coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division  No Existe " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-PRECIO-9 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(T-MATG.PromDto[9]:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-9 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDto[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDto[10] V-table-Win
ON LEAVE OF T-MATG.PromDto[10] IN FRAME F-Main /* PromDto */
DO:
    IF T-MATG.PromDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[10]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-10 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-10 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDto[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDto[1] V-table-Win
ON LEAVE OF T-MATG.PromDto[1] IN FRAME F-Main /* PromDto */
DO:
    IF T-MATG.PromDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[1]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-1 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-1 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDto[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDto[2] V-table-Win
ON LEAVE OF T-MATG.PromDto[2] IN FRAME F-Main /* PromDto */
DO:
    IF T-MATG.PromDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[2]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-2 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-2 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDto[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDto[3] V-table-Win
ON LEAVE OF T-MATG.PromDto[3] IN FRAME F-Main /* PromDto */
DO:
    IF T-MATG.PromDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[3]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-3 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-3 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDto[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDto[4] V-table-Win
ON LEAVE OF T-MATG.PromDto[4] IN FRAME F-Main /* PromDto */
DO:
    IF T-MATG.PromDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[4]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-4 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-4 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDto[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDto[5] V-table-Win
ON LEAVE OF T-MATG.PromDto[5] IN FRAME F-Main /* PromDto */
DO:
    IF T-MATG.PromDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[5]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-5 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-5 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDto[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDto[6] V-table-Win
ON LEAVE OF T-MATG.PromDto[6] IN FRAME F-Main /* PromDto */
DO:
    IF T-MATG.PromDivi[6]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[6]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-6 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-6 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDto[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDto[7] V-table-Win
ON LEAVE OF T-MATG.PromDto[7] IN FRAME F-Main /* PromDto */
DO:
  IF T-MATG.PromDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
  IF T-MATG.PromDivi[7]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
     MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
             "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.    
  F-PRECIO-7 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
  DISPLAY F-PRECIO-7 WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDto[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDto[8] V-table-Win
ON LEAVE OF T-MATG.PromDto[8] IN FRAME F-Main /* PromDto */
DO:
    IF T-MATG.PromDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[8]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-8 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-8 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PromDto[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PromDto[9] V-table-Win
ON LEAVE OF T-MATG.PromDto[9] IN FRAME F-Main /* PromDto */
DO:
    IF T-MATG.PromDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF T-MATG.PromDivi[9]:SCREEN-VALUE = "" AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Divisiones Declaradas " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    F-PRECIO-9 = ROUND(T-MATG.Prevta[1] * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4).
    DISPLAY F-PRECIO-9 WITH FRAME {&FRAME-NAME}.
  
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
  T-MATG.fchact = TODAY.
  DO x-Orden = 1 TO 10:
      IF T-MATG.PromDivi[x-Orden] = '' OR T-MATG.PromDto[x-Orden] = 0
      THEN ASSIGN
                T-MATG.PromDivi[x-Orden] = ''
                T-MATG.PromFchD[x-Orden] = ?
                T-MATG.PromFchH[x-Orden] = ?
                T-MATG.PromDto[x-Orden] = 0.
  END.
  /* Validación de fechas */
  DO x-Orden = 1 TO 10:
      IF T-MATG.PromDivi[x-Orden] <> '' THEN DO:
          IF T-MATG.PromFchD[x-Orden] = ?
              OR T-MATG.PromFchH[x-Orden] = ? THEN DO:
              MESSAGE 'Debe ingresar las dos fechas' VIEW-AS ALERT-BOX ERROR.
              UNDO, RETURN 'ADM-ERROR'.
          END.
          IF T-MATG.PromFchD[x-Orden] > T-MATG.PromFchH[x-Orden] THEN DO:
              MESSAGE 'Rango de fechas errado' VIEW-AS ALERT-BOX ERROR.
              UNDO, RETURN 'ADM-ERROR'.
          END.
          IF T-MATG.PromDto[x-Orden] < 0 THEN DO:
              MESSAGE 'NO se aceptan descuento negativos' VIEW-AS ALERT-BOX ERROR.
              UNDO, RETURN 'ADM-ERROR'.
          END.
      END.
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
     
     F-PRECIO-1 = IF PromDivi[1] <> "" THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( PromDto[1] / 100 ) ),4) ELSE 0.     
     F-PRECIO-2 = IF PromDivi[2] <> "" THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( PromDto[2] / 100 ) ),4) ELSE 0.
     F-PRECIO-3 = IF PromDivi[3] <> "" THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( PromDto[3] / 100 ) ),4) ELSE 0.
     F-PRECIO-4 = IF PromDivi[4] <> "" THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( PromDto[4] / 100 ) ),4) ELSE 0.
     F-PRECIO-5 = IF PromDivi[5] <> "" THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( PromDto[5] / 100 ) ),4) ELSE 0.
     F-PRECIO-6 = IF PromDivi[6] <> "" THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( PromDto[6] / 100 ) ),4) ELSE 0.
     F-PRECIO-7 = IF PromDivi[7] <> "" THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( PromDto[7] / 100 ) ),4) ELSE 0.
     F-PRECIO-8 = IF PromDivi[8] <> "" THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( PromDto[8] / 100 ) ),4) ELSE 0.
     F-PRECIO-9 = IF PromDivi[9] <> "" THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( PromDto[9] / 100 ) ),4) ELSE 0.
     F-PRECIO-10 = IF PromDivi[10] <> "" THEN ROUND(T-MATG.Prevta[1] * ( 1 - ( PromDto[10] / 100 ) ),4) ELSE 0.
     
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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

