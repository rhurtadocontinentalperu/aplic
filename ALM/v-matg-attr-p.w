&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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

DEF VAR TOGGLE-1 AS LOG NO-UNDO.
DEF VAR TOGGLE-2 AS LOG NO-UNDO.
DEF VAR TOGGLE-3 AS LOG NO-UNDO.
DEF VAR TOGGLE-4 AS LOG NO-UNDO.
DEF VAR TOGGLE-5 AS LOG NO-UNDO.
DEF VAR TOGGLE-6 AS LOG NO-UNDO.
DEF VAR TOGGLE-7 AS LOG NO-UNDO.
DEF VAR TOGGLE-8 AS LOG NO-UNDO.
DEF VAR TOGGLE-9 AS LOG NO-UNDO.
DEF VAR TOGGLE-10 AS LOG NO-UNDO.
DEF VAR TOGGLE-11 AS LOG NO-UNDO.
DEF VAR TOGGLE-12 AS LOG NO-UNDO.
DEF VAR TOGGLE-13 AS LOG NO-UNDO.
DEF VAR TOGGLE-14 AS LOG NO-UNDO.
DEF VAR TOGGLE-15 AS LOG NO-UNDO.

/*/ Control de armado de descripción */
DEF VAR D-TOGGLE-1 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-2 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-3 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-4 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-5 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-6 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-7 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-8 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-9 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-10 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-11 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-12 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-13 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-14 AS LOG NO-UNDO.
DEF VAR D-TOGGLE-15 AS LOG NO-UNDO.

DEF VAR T-TOGGLE-1 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-2 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-3 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-4 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-5 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-6 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-7 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-8 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-9 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-10 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-11 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-12 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-13 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-14 AS LOG NO-UNDO.
DEF VAR T-TOGGLE-15 AS LOG NO-UNDO.


DEF VAR x-CodCta LIKE Almtmatg.CodCta NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES AlmTMatg
&Scoped-define FIRST-EXTERNAL-TABLE AlmTMatg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR AlmTMatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS almtmatg.DesMat 
&Scoped-define ENABLED-TABLES almtmatg
&Scoped-define FIRST-ENABLED-TABLE almtmatg
&Scoped-Define ENABLED-OBJECTS RECT-23 RECT-24 
&Scoped-Define DISPLAYED-FIELDS almtmatg.codmat almtmatg.DesMat 
&Scoped-define DISPLAYED-TABLES almtmatg
&Scoped-define FIRST-DISPLAYED-TABLE almtmatg
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Atributo-1 FILL-IN-Valor-1 ~
COMBO-BOX-Valor-1 FILL-IN-Atributo-2 FILL-IN-Valor-2 COMBO-BOX-Valor-2 ~
FILL-IN-Atributo-3 FILL-IN-Valor-3 COMBO-BOX-Valor-3 FILL-IN-Atributo-4 ~
FILL-IN-Valor-4 COMBO-BOX-Valor-4 FILL-IN-Atributo-5 FILL-IN-Valor-5 ~
COMBO-BOX-Valor-5 FILL-IN-Atributo-6 FILL-IN-Valor-6 COMBO-BOX-Valor-6 ~
FILL-IN-Atributo-7 FILL-IN-Valor-7 COMBO-BOX-Valor-7 FILL-IN-Atributo-8 ~
FILL-IN-Valor-8 COMBO-BOX-Valor-8 FILL-IN-Atributo-9 FILL-IN-Valor-9 ~
COMBO-BOX-Valor-9 FILL-IN-Atributo-10 FILL-IN-Valor-10 COMBO-BOX-Valor-10 ~
FILL-IN-Atributo-11 FILL-IN-Valor-11 COMBO-BOX-Valor-11 FILL-IN-Atributo-12 ~
FILL-IN-Valor-12 COMBO-BOX-Valor-12 FILL-IN-Atributo-13 FILL-IN-Valor-13 ~
COMBO-BOX-Valor-13 FILL-IN-Atributo-14 FILL-IN-Valor-14 COMBO-BOX-Valor-14 ~
FILL-IN-Atributo-15 FILL-IN-Valor-15 COMBO-BOX-Valor-15 

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
DEFINE VARIABLE COMBO-BOX-Valor-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-10 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-11 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-12 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-13 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-14 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-15 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-6 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-7 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-8 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Valor-9 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-10 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-11 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-12 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-13 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-14 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-15 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-6 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-7 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-8 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Atributo-9 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-10 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-11 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-12 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-13 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-14 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-15 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-6 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-7 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-8 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-9 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 15.19.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31 BY 15.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     almtmatg.codmat AT ROW 1.19 COL 13 COLON-ALIGNED WIDGET-ID 6
          LABEL "Codigo"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     almtmatg.DesMat AT ROW 1.96 COL 13 COLON-ALIGNED WIDGET-ID 8 FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 57 BY .81
     FILL-IN-Atributo-1 AT ROW 3.88 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-Valor-1 AT ROW 3.88 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     COMBO-BOX-Valor-1 AT ROW 3.88 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-Atributo-2 AT ROW 4.85 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     FILL-IN-Valor-2 AT ROW 4.85 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     COMBO-BOX-Valor-2 AT ROW 4.85 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-Atributo-3 AT ROW 5.81 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-Valor-3 AT ROW 5.81 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     COMBO-BOX-Valor-3 AT ROW 5.81 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FILL-IN-Atributo-4 AT ROW 6.77 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     FILL-IN-Valor-4 AT ROW 6.77 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     COMBO-BOX-Valor-4 AT ROW 6.77 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     FILL-IN-Atributo-5 AT ROW 7.73 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FILL-IN-Valor-5 AT ROW 7.73 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     COMBO-BOX-Valor-5 AT ROW 7.73 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     FILL-IN-Atributo-6 AT ROW 8.69 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     FILL-IN-Valor-6 AT ROW 8.69 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     COMBO-BOX-Valor-6 AT ROW 8.69 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     FILL-IN-Atributo-7 AT ROW 9.65 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     FILL-IN-Valor-7 AT ROW 9.65 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     COMBO-BOX-Valor-7 AT ROW 9.65 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     FILL-IN-Atributo-8 AT ROW 10.62 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     FILL-IN-Valor-8 AT ROW 10.62 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     COMBO-BOX-Valor-8 AT ROW 10.62 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     FILL-IN-Atributo-9 AT ROW 11.58 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     FILL-IN-Valor-9 AT ROW 11.58 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     COMBO-BOX-Valor-9 AT ROW 11.58 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     FILL-IN-Atributo-10 AT ROW 12.54 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     FILL-IN-Valor-10 AT ROW 12.54 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     COMBO-BOX-Valor-10 AT ROW 12.54 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     FILL-IN-Atributo-11 AT ROW 13.5 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     FILL-IN-Valor-11 AT ROW 13.5 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     COMBO-BOX-Valor-11 AT ROW 13.5 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 96
     FILL-IN-Atributo-12 AT ROW 14.46 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 100
     FILL-IN-Valor-12 AT ROW 14.46 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 102
     COMBO-BOX-Valor-12 AT ROW 14.46 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 98
     FILL-IN-Atributo-13 AT ROW 15.42 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     FILL-IN-Valor-13 AT ROW 15.42 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 110
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     COMBO-BOX-Valor-13 AT ROW 15.42 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 106
     FILL-IN-Atributo-14 AT ROW 16.38 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 116
     FILL-IN-Valor-14 AT ROW 16.38 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 118
     COMBO-BOX-Valor-14 AT ROW 16.38 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 114
     FILL-IN-Atributo-15 AT ROW 17.35 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 124
     FILL-IN-Valor-15 AT ROW 17.35 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 126
     COMBO-BOX-Valor-15 AT ROW 17.35 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 122
     "Atributos" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.12 COL 8 WIDGET-ID 130
          BGCOLOR 9 FGCOLOR 15 
     "Valores" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.12 COL 21 WIDGET-ID 132
          BGCOLOR 9 FGCOLOR 15 
     RECT-23 AT ROW 3.31 COL 6 WIDGET-ID 134
     RECT-24 AT ROW 3.31 COL 19 WIDGET-ID 136
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.AlmTMatg
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
         HEIGHT             = 17.96
         WIDTH              = 73.86.
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

/* SETTINGS FOR FILL-IN almtmatg.codmat IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-11 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-12 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-13 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-14 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-15 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-7 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-8 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-Valor-9 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN almtmatg.DesMat IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-11 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-12 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-13 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-14 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-15 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-7 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-8 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Atributo-9 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-11 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-12 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-13 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-14 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-15 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-7 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-8 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-9 IN FRAME F-Main
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

&Scoped-define SELF-NAME COMBO-BOX-Valor-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-1 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-1 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-10 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-10 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-11 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-11 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-12 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-12 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-13 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-13 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-14 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-14 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-15 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-15 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-2 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-2 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-3 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-3 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-4 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-4 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-5 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-5 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-6 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-6 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-7 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-7 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-8 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-8 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Valor-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Valor-9 V-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Valor-9 IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN Genera-Nombre.
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
  {src/adm/template/row-list.i "AlmTMatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "AlmTMatg"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Atributos V-table-Win 
PROCEDURE Carga-Atributos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.
DEF BUFFER Atributo FOR Vtactabla.
DEF BUFFER DAtributo FOR Vtadtabla.


rloop:
DO WITH FRAME {&FRAME-NAME}:
    FIND Almssfami OF AlmTMatg NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almssfami THEN LEAVE rloop.
    /* Buscamos Plantilla */
    FIND Vtactabla WHERE VtaCTabla.CodCia = AlmTMatg.codcia 
        AND VtaCTabla.Tabla = 'PATTR'
        AND VtaCTabla.Llave = AlmSSFami.CodPlantilla
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtactabla THEN LEAVE rloop.
    k = 0.
    FOR EACH Vtadtabla OF Vtactabla NO-LOCK,
        FIRST Atributo WHERE Atributo.codcia = Vtadtabla.codcia
        AND Atributo.tabla = 'ATTR'
        AND Atributo.llave = VtaDTabla.LlaveDetalle:
        k = k + 1.
        CASE k:
            WHEN 1 THEN DO:
                FILL-IN-Atributo-1 = Atributo.Descripcion.
                FILL-IN-Valor-1 = VtaDTabla.Libre_c01.
                D-TOGGLE-1 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-1 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-1:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-1 = YES.
                END.
                IF TOGGLE-1 = NO AND FILL-IN-Valor-1 = '' THEN T-TOGGLE-1 = YES.
            END.
            WHEN 2 THEN DO:
                FILL-IN-Atributo-2 = Atributo.Descripcion.
                FILL-IN-Valor-2 = VtaDTabla.Libre_c01.
                D-TOGGLE-2 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-2 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-2:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-2 = YES.
                END.
                IF TOGGLE-2 = NO AND FILL-IN-Valor-2 = '' THEN T-TOGGLE-2 = YES.
            END.
            WHEN 3 THEN DO:
                FILL-IN-Atributo-3 = Atributo.Descripcion.
                FILL-IN-Valor-3 = VtaDTabla.Libre_c01.
                D-TOGGLE-3 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-3 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-3:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-3 = YES.
                END.
                IF TOGGLE-3 = NO AND FILL-IN-Valor-3 = '' THEN T-TOGGLE-3 = YES.
            END.
            WHEN 4 THEN DO:
                FILL-IN-Atributo-4 = Atributo.Descripcion.
                FILL-IN-Valor-4 = VtaDTabla.Libre_c01.
                D-TOGGLE-4 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-4 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-4:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-4 = YES.
                END.
                IF TOGGLE-4 = NO AND FILL-IN-Valor-4 = '' THEN T-TOGGLE-4 = YES.
            END.
            WHEN 5 THEN DO:
                FILL-IN-Atributo-5 = Atributo.Descripcion.
                FILL-IN-Valor-5 = VtaDTabla.Libre_c01.
                D-TOGGLE-5 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-5 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-5:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-5 = YES.
                END.
                IF TOGGLE-5 = NO AND FILL-IN-Valor-5 = '' THEN T-TOGGLE-5 = YES.
            END.
            WHEN 6 THEN DO:
                FILL-IN-Atributo-6 = Atributo.Descripcion.
                FILL-IN-Valor-6 = VtaDTabla.Libre_c01.
                D-TOGGLE-6 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-6 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-6:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-6 = YES.
                END.
                IF TOGGLE-6 = NO AND FILL-IN-Valor-6 = '' THEN T-TOGGLE-6 = YES.
            END.
            WHEN 7 THEN DO:
                FILL-IN-Atributo-7 = Atributo.Descripcion.
                FILL-IN-Valor-7 = VtaDTabla.Libre_c01.
                D-TOGGLE-7 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-7 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-7:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-7 = YES.
                END.
                IF TOGGLE-7 = NO AND FILL-IN-Valor-7 = '' THEN T-TOGGLE-7 = YES.
            END.
            WHEN 8 THEN DO:
                FILL-IN-Atributo-8 = Atributo.Descripcion.
                FILL-IN-Valor-8 = VtaDTabla.Libre_c01.
                D-TOGGLE-8 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-8 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-8:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-8 = YES.
                END.
                IF TOGGLE-8 = NO AND FILL-IN-Valor-8 = '' THEN T-TOGGLE-8 = YES.
            END.
            WHEN 9 THEN DO:
                FILL-IN-Atributo-9 = Atributo.Descripcion.
                FILL-IN-Valor-9 = VtaDTabla.Libre_c01.
                D-TOGGLE-9 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-9 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-9:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-9 = YES.
                END.
                IF TOGGLE-9 = NO AND FILL-IN-Valor-9 = '' THEN T-TOGGLE-9 = YES.
            END.
            WHEN 10 THEN DO:
                FILL-IN-Atributo-10 = Atributo.Descripcion.
                FILL-IN-Valor-10 = VtaDTabla.Libre_c01.
                D-TOGGLE-10 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-10 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-10:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-10 = YES.
                END.
                IF TOGGLE-10 = NO AND FILL-IN-Valor-10 = '' THEN T-TOGGLE-10 = YES.
            END.
            WHEN 11 THEN DO:
                FILL-IN-Atributo-11 = Atributo.Descripcion.
                FILL-IN-Valor-11 = VtaDTabla.Libre_c01.
                D-TOGGLE-11 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-11 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-11:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-11 = YES.
                    IF TOGGLE-11 = NO AND FILL-IN-Valor-11 = '' THEN T-TOGGLE-11 = YES.
                END.
            END.
            WHEN 12 THEN DO:
                FILL-IN-Atributo-12 = Atributo.Descripcion.
                FILL-IN-Valor-12 = VtaDTabla.Libre_c01.
                D-TOGGLE-12 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-12 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-12:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-12 = YES.
                END.
                IF TOGGLE-12 = NO AND FILL-IN-Valor-12 = '' THEN T-TOGGLE-12 = YES.
            END.
            WHEN 13 THEN DO:
                FILL-IN-Atributo-13 = Atributo.Descripcion.
                FILL-IN-Valor-13 = VtaDTabla.Libre_c01.
                D-TOGGLE-13 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-13 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-13:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-13 = YES.
                END.
                IF TOGGLE-13 = NO AND FILL-IN-Valor-13 = '' THEN T-TOGGLE-13 = YES.
            END.
            WHEN 14 THEN DO:
                FILL-IN-Atributo-14 = Atributo.Descripcion.
                FILL-IN-Valor-14 = VtaDTabla.Libre_c01.
                D-TOGGLE-14 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-14 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-14:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-14 = YES.
                END.
                IF TOGGLE-14 = NO AND FILL-IN-Valor-14 = '' THEN T-TOGGLE-14 = YES.
            END.
            WHEN 15 THEN DO:
                FILL-IN-Atributo-15 = Atributo.Descripcion.
                FILL-IN-Valor-15 = VtaDTabla.Libre_c01.
                D-TOGGLE-15 =  VtaDTabla.Libre_l01.
                IF FILL-IN-Valor-15 = "" AND Atributo.Libre_L01 = YES
                    THEN DO:    /* Cargamos lista */
                    FOR EACH DAtributo OF Atributo NO-LOCK:
                        COMBO-BOX-Valor-15:ADD-LAST((IF DAtributo.Libre_c02 <> "" THEN DAtributo.Libre_c02 ELSE DAtributo.Libre_c01)).
                    END.
                    TOGGLE-15 = YES.
                END.
                IF TOGGLE-15 = NO AND FILL-IN-Valor-15 = '' THEN T-TOGGLE-15 = YES.
            END.
        END CASE.
    END.
    
END.
DISPLAY
    COMBO-BOX-Valor-1 COMBO-BOX-Valor-10 COMBO-BOX-Valor-2 COMBO-BOX-Valor-3 
    COMBO-BOX-Valor-4 COMBO-BOX-Valor-5 COMBO-BOX-Valor-6 COMBO-BOX-Valor-7 
    COMBO-BOX-Valor-8 COMBO-BOX-Valor-9 COMBO-BOX-Valor-11 COMBO-BOX-Valor-12 
    COMBO-BOX-Valor-13 COMBO-BOX-Valor-14 COMBO-BOX-Valor-15
    FILL-IN-Atributo-1 FILL-IN-Atributo-10 FILL-IN-Atributo-11 FILL-IN-Atributo-12 FILL-IN-Atributo-13 
    FILL-IN-Atributo-14 FILL-IN-Atributo-15 FILL-IN-Atributo-2 FILL-IN-Atributo-3 
    FILL-IN-Atributo-4 FILL-IN-Atributo-5 FILL-IN-Atributo-6 FILL-IN-Atributo-7 
    FILL-IN-Atributo-8 FILL-IN-Atributo-9
    FILL-IN-Valor-1 FILL-IN-Valor-10 FILL-IN-Valor-11 FILL-IN-Valor-12 FILL-IN-Valor-13 
    FILL-IN-Valor-14 FILL-IN-Valor-15 FILL-IN-Valor-2 FILL-IN-Valor-3 FILL-IN-Valor-4 
    FILL-IN-Valor-5 FILL-IN-Valor-6 FILL-IN-Valor-7 FILL-IN-Valor-8 FILL-IN-Valor-9
    WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Nombre V-table-Win 
PROCEDURE Genera-Nombre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-DesMat AS CHAR NO-UNDO.

FIND Almssfami OF AlmTMatg NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almssfami THEN RETURN.
FIND Vtactabla WHERE VtaCTabla.CodCia = AlmTMatg.codcia 
    AND VtaCTabla.Tabla = 'PATTR'
    AND VtaCTabla.Llave = AlmSSFami.CodPlantilla
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtactabla OR Vtactabla.Libre_L01 = NO THEN RETURN.
/*x-DesMat = TRIM(COMBO-BOX-Valor-1) + TRIM(FILL-IN-Valor-1).*/
IF D-TOGGLE-1 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-1) + TRIM(FILL-IN-Valor-1).
IF D-TOGGLE-2 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-2) + TRIM(FILL-IN-Valor-2).
IF D-TOGGLE-3 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-3) + TRIM(FILL-IN-Valor-3).
IF D-TOGGLE-4 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-4) + TRIM(FILL-IN-Valor-4).
IF D-TOGGLE-5 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-5) + TRIM(FILL-IN-Valor-5).
IF D-TOGGLE-6 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-6) + TRIM(FILL-IN-Valor-6).
IF D-TOGGLE-7 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-7) + TRIM(FILL-IN-Valor-7).
IF D-TOGGLE-8 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-8) + TRIM(FILL-IN-Valor-8).
IF D-TOGGLE-9 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-9) + TRIM(FILL-IN-Valor-9).
IF D-TOGGLE-10 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-10) + TRIM(FILL-IN-Valor-10).
IF D-TOGGLE-11 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-11) + TRIM(FILL-IN-Valor-11).
IF D-TOGGLE-12 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-12) + TRIM(FILL-IN-Valor-12).
IF D-TOGGLE-13 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-13) + TRIM(FILL-IN-Valor-13).
IF D-TOGGLE-14 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-14) + TRIM(FILL-IN-Valor-14).
IF D-TOGGLE-15 THEN x-DesMat = x-DesMat + (IF x-DesMat = '' THEN '' ELSE ' ' ) + TRIM(COMBO-BOX-Valor-15) + TRIM(FILL-IN-Valor-15).

x-CodCta = ''.
IF D-TOGGLE-1 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-1) + TRIM(FILL-IN-Valor-1).
IF D-TOGGLE-2 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-2) + TRIM(FILL-IN-Valor-2).
IF D-TOGGLE-3 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-3) + TRIM(FILL-IN-Valor-3).
IF D-TOGGLE-4 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-4) + TRIM(FILL-IN-Valor-4).
IF D-TOGGLE-5 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-5) + TRIM(FILL-IN-Valor-5).
IF D-TOGGLE-6 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-6) + TRIM(FILL-IN-Valor-6).
IF D-TOGGLE-7 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-7) + TRIM(FILL-IN-Valor-7).
IF D-TOGGLE-8 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-8) + TRIM(FILL-IN-Valor-8).
IF D-TOGGLE-9 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-9) + TRIM(FILL-IN-Valor-9).
IF D-TOGGLE-10 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-10) + TRIM(FILL-IN-Valor-10).
IF D-TOGGLE-11 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-11) + TRIM(FILL-IN-Valor-11).
IF D-TOGGLE-12 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-12) + TRIM(FILL-IN-Valor-12).
IF D-TOGGLE-13 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-13) + TRIM(FILL-IN-Valor-13).
IF D-TOGGLE-14 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-14) + TRIM(FILL-IN-Valor-14).
IF D-TOGGLE-15 THEN x-CodCta = x-CodCta + (IF x-CodCta = '' THEN '' ELSE ',' ) + TRIM(COMBO-BOX-Valor-15) + TRIM(FILL-IN-Valor-15).

AlmTMatg.DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = CAPS(x-DesMat).
x-CodCta = CAPS(x-CodCta).

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
  ASSIGN
      Almtmatg.CodCta = x-CodCta.


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
          COMBO-BOX-Valor-1:SENSITIVE = NO
          COMBO-BOX-Valor-2:SENSITIVE = NO
          COMBO-BOX-Valor-3:SENSITIVE = NO
          COMBO-BOX-Valor-4:SENSITIVE = NO
          COMBO-BOX-Valor-5:SENSITIVE = NO
          COMBO-BOX-Valor-6:SENSITIVE = NO
          COMBO-BOX-Valor-7:SENSITIVE = NO
          COMBO-BOX-Valor-8:SENSITIVE = NO
          COMBO-BOX-Valor-9:SENSITIVE = NO
          COMBO-BOX-Valor-10:SENSITIVE = NO
          COMBO-BOX-Valor-11:SENSITIVE = NO
          COMBO-BOX-Valor-12:SENSITIVE = NO
          COMBO-BOX-Valor-13:SENSITIVE = NO
          COMBO-BOX-Valor-14:SENSITIVE = NO
          COMBO-BOX-Valor-15:SENSITIVE = NO
          FILL-IN-Valor-1:SENSITIVE = NO
          FILL-IN-Valor-10 :SENSITIVE = NO
          FILL-IN-Valor-11:SENSITIVE = NO
          FILL-IN-Valor-12:SENSITIVE = NO
          FILL-IN-Valor-13:SENSITIVE = NO
          FILL-IN-Valor-14:SENSITIVE = NO
          FILL-IN-Valor-15:SENSITIVE = NO
          FILL-IN-Valor-2:SENSITIVE = NO
          FILL-IN-Valor-3:SENSITIVE = NO
          FILL-IN-Valor-4:SENSITIVE = NO
          FILL-IN-Valor-5:SENSITIVE = NO
          FILL-IN-Valor-6:SENSITIVE = NO
          FILL-IN-Valor-7:SENSITIVE = NO
          FILL-IN-Valor-8:SENSITIVE = NO
          FILL-IN-Valor-9:SENSITIVE = NO.


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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          COMBO-BOX-Valor-1 = ''
          COMBO-BOX-Valor-2 = ''
          COMBO-BOX-Valor-3 = ''
          COMBO-BOX-Valor-4 = ''
          COMBO-BOX-Valor-5 = ''
          COMBO-BOX-Valor-6 = ''
          COMBO-BOX-Valor-7 = ''
          COMBO-BOX-Valor-8 = ''
          COMBO-BOX-Valor-9 = ''
          COMBO-BOX-Valor-10 = ''
          COMBO-BOX-Valor-11 = ''
          COMBO-BOX-Valor-12 = ''
          COMBO-BOX-Valor-13 = ''
          COMBO-BOX-Valor-14 = ''
          COMBO-BOX-Valor-15 = ''
          FILL-IN-Atributo-1 = ''
          FILL-IN-Atributo-2 = ''
          FILL-IN-Atributo-3 = ''
          FILL-IN-Atributo-4 = ''
          FILL-IN-Atributo-5 = ''
          FILL-IN-Atributo-6 = ''
          FILL-IN-Atributo-7 = ''
          FILL-IN-Atributo-8 = ''
          FILL-IN-Atributo-9 = ''
          FILL-IN-Atributo-10 = ''
          FILL-IN-Atributo-11 = ''
          FILL-IN-Atributo-12 = ''
          FILL-IN-Atributo-13 = ''
          FILL-IN-Atributo-14 = ''
          FILL-IN-Atributo-15 = ''
          FILL-IN-Valor-1 = ''
          FILL-IN-Valor-2 = ''
          FILL-IN-Valor-3 = ''
          FILL-IN-Valor-4 = ''
          FILL-IN-Valor-5 = ''
          FILL-IN-Valor-6 = ''
          FILL-IN-Valor-7 = ''
          FILL-IN-Valor-8 = ''
          FILL-IN-Valor-9 = ''
          FILL-IN-Valor-10 = ''
          FILL-IN-Valor-11 = ''
          FILL-IN-Valor-12 = ''
          FILL-IN-Valor-13 = ''
          FILL-IN-Valor-14 = ''
          FILL-IN-Valor-15 = ''
          TOGGLE-1 = no
          TOGGLE-2 = no
          TOGGLE-3 = no
          TOGGLE-4 = no
          TOGGLE-5 = no
          TOGGLE-6 = no
          TOGGLE-7 = no
          TOGGLE-8 = no
          TOGGLE-9 = NO
          TOGGLE-10 = no
          TOGGLE-11 = no
          TOGGLE-12 = no
          TOGGLE-13 = no
          TOGGLE-14 = no
          TOGGLE-15 = no.
      ASSIGN
          D-TOGGLE-1  = NO
          D-TOGGLE-2  = NO
          D-TOGGLE-3  = NO
          D-TOGGLE-4  = NO
          D-TOGGLE-5  = NO
          D-TOGGLE-6  = NO
          D-TOGGLE-7  = NO
          D-TOGGLE-8  = NO
          D-TOGGLE-9  = NO
          D-TOGGLE-10 = NO
          D-TOGGLE-11 = NO
          D-TOGGLE-12 = NO
          D-TOGGLE-13 = NO
          D-TOGGLE-14 = NO
          D-TOGGLE-15 = NO.
      ASSIGN
          T-TOGGLE-1  = NO
          T-TOGGLE-2  = NO
          T-TOGGLE-3  = NO
          T-TOGGLE-4  = NO
          T-TOGGLE-5  = NO
          T-TOGGLE-6  = NO
          T-TOGGLE-7  = NO
          T-TOGGLE-8  = NO
          T-TOGGLE-9  = NO
          T-TOGGLE-10 = NO
          T-TOGGLE-11 = NO
          T-TOGGLE-12 = NO
          T-TOGGLE-13 = NO
          T-TOGGLE-14 = NO
          T-TOGGLE-15 = NO.
      COMBO-BOX-Valor-1:DELETE( COMBO-BOX-Valor-1:LIST-ITEMS ).
      COMBO-BOX-Valor-2:DELETE( COMBO-BOX-Valor-2:LIST-ITEMS ).
      COMBO-BOX-Valor-3:DELETE( COMBO-BOX-Valor-3:LIST-ITEMS ).
      COMBO-BOX-Valor-4:DELETE( COMBO-BOX-Valor-4:LIST-ITEMS ).
      COMBO-BOX-Valor-5:DELETE( COMBO-BOX-Valor-5:LIST-ITEMS ).
      COMBO-BOX-Valor-6:DELETE( COMBO-BOX-Valor-6:LIST-ITEMS ).
      COMBO-BOX-Valor-7:DELETE( COMBO-BOX-Valor-7:LIST-ITEMS ).
      COMBO-BOX-Valor-8:DELETE( COMBO-BOX-Valor-8:LIST-ITEMS ).
      COMBO-BOX-Valor-9:DELETE( COMBO-BOX-Valor-9:LIST-ITEMS ).
      COMBO-BOX-Valor-10:DELETE( COMBO-BOX-Valor-10:LIST-ITEMS ).
      COMBO-BOX-Valor-11:DELETE( COMBO-BOX-Valor-11:LIST-ITEMS ).
      COMBO-BOX-Valor-12:DELETE( COMBO-BOX-Valor-12:LIST-ITEMS ).
      COMBO-BOX-Valor-13:DELETE( COMBO-BOX-Valor-13:LIST-ITEMS ).
      COMBO-BOX-Valor-14:DELETE( COMBO-BOX-Valor-14:LIST-ITEMS ).
      COMBO-BOX-Valor-15:DELETE( COMBO-BOX-Valor-15:LIST-ITEMS ).

      RUN Carga-Atributos.
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
          AlmTMatg.desmat:SENSITIVE = NO
          COMBO-BOX-Valor-1:SENSITIVE = TOGGLE-1
          COMBO-BOX-Valor-2:SENSITIVE = TOGGLE-2
          COMBO-BOX-Valor-3:SENSITIVE = TOGGLE-3
          COMBO-BOX-Valor-4:SENSITIVE = TOGGLE-4
          COMBO-BOX-Valor-5:SENSITIVE = TOGGLE-5
          COMBO-BOX-Valor-6:SENSITIVE = TOGGLE-6
          COMBO-BOX-Valor-7:SENSITIVE = TOGGLE-7
          COMBO-BOX-Valor-8:SENSITIVE = TOGGLE-8
          COMBO-BOX-Valor-9:SENSITIVE = TOGGLE-9
          COMBO-BOX-Valor-10:SENSITIVE = TOGGLE-10
          COMBO-BOX-Valor-11:SENSITIVE = TOGGLE-11
          COMBO-BOX-Valor-12:SENSITIVE = TOGGLE-12
          COMBO-BOX-Valor-13:SENSITIVE = TOGGLE-13
          COMBO-BOX-Valor-14:SENSITIVE = TOGGLE-14
          COMBO-BOX-Valor-15:SENSITIVE = TOGGLE-15
          FILL-IN-Valor-1:SENSITIVE = T-TOGGLE-1
          FILL-IN-Valor-10 :SENSITIVE = T-TOGGLE-10
          FILL-IN-Valor-11:SENSITIVE = T-TOGGLE-11
          FILL-IN-Valor-12:SENSITIVE = T-TOGGLE-12
          FILL-IN-Valor-13:SENSITIVE = T-TOGGLE-13
          FILL-IN-Valor-14:SENSITIVE = T-TOGGLE-14
          FILL-IN-Valor-15:SENSITIVE = T-TOGGLE-15
          FILL-IN-Valor-2:SENSITIVE = T-TOGGLE-2
          FILL-IN-Valor-3:SENSITIVE = T-TOGGLE-3
          FILL-IN-Valor-4:SENSITIVE = T-TOGGLE-4
          FILL-IN-Valor-5:SENSITIVE = T-TOGGLE-5
          FILL-IN-Valor-6:SENSITIVE = T-TOGGLE-6
          FILL-IN-Valor-7:SENSITIVE = T-TOGGLE-7
          FILL-IN-Valor-8:SENSITIVE = T-TOGGLE-8
          FILL-IN-Valor-9:SENSITIVE = T-TOGGLE-9.

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
  {src/adm/template/snd-list.i "AlmTMatg"}

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

FIND Almssfami OF AlmTMatg NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almssfami THEN RETURN 'ADM-ERROR'.
/* Buscamos Plantilla */
FIND Vtactabla WHERE VtaCTabla.CodCia = AlmTMatg.codcia 
    AND VtaCTabla.Tabla = 'PATTR'
    AND VtaCTabla.Llave = AlmSSFami.CodPlantilla
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtactabla THEN RETURN 'ADM-ERROR'.
x-CodCta = Almtmatg.CodCta.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

