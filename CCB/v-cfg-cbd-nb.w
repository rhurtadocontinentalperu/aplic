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

DEFINE SHARED VARIABLE S-CODDOC AS CHAR.

DEFINE SHARED VAR s-codcia AS INTE.
DEFINE SHARED VAR cb-codcia AS INTE.

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
&Scoped-define EXTERNAL-TABLES FacDocum
&Scoped-define FIRST-EXTERNAL-TABLE FacDocum


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacDocum.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacDocum.Codope 
&Scoped-define ENABLED-TABLES FacDocum
&Scoped-define FIRST-ENABLED-TABLE FacDocum
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RECT-4 RECT-5 RECT-6 ~
RECT-8 RECT-10 RECT-11 RECT-12 RECT-13 RECT-14 RECT-15 
&Scoped-Define DISPLAYED-FIELDS FacDocum.Codope 
&Scoped-define DISPLAYED-TABLES FacDocum
&Scoped-define FIRST-DISPLAYED-TABLE FacDocum
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NomOpe FILL-IN-11 FILL-IN-NOM-11 ~
FILL-IN-21 FILL-IN-NOM-21 FILL-IN-31 FILL-IN-NOM-31 FILL-IN-41 ~
FILL-IN-NOM-41 FILL-IN-51 FILL-IN-NOM-51 FILL-IN-61 FILL-IN-NOM-61 ~
FILL-IN-12 FILL-IN-NOM-12 FILL-IN-22 FILL-IN-NOM-22 FILL-IN-32 ~
FILL-IN-NOM-32 FILL-IN-42 FILL-IN-NOM-42 FILL-IN-52 FILL-IN-NOM-52 ~
FILL-IN-62 FILL-IN-NOM-62 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomCta V-table-Win 
FUNCTION fNomCta RETURNS CHARACTER
  ( INPUT pCodCta AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-11 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-12 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-21 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-22 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-31 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-32 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-41 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-42 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-51 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-52 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-61 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-62 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOM-11 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOM-12 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOM-21 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOM-22 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOM-31 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOM-32 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOM-41 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOM-42 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOM-51 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOM-52 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOM-61 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOM-62 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomOpe AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.35.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 45 BY 1.08
     BGCOLOR 14 FGCOLOR 0 .

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 3.5.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 45 BY 1.08
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 3.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 6 BY 3.5.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 6 BY 3.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 1.08.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 3.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 1.08.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 3.5.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 45 BY 1.08
     BGCOLOR 14 FGCOLOR 0 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 45 BY 1.08
     BGCOLOR 11 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacDocum.Codope AT ROW 1.27 COL 15 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-NomOpe AT ROW 1.27 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     FILL-IN-11 AT ROW 3.69 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 122
     FILL-IN-NOM-11 AT ROW 3.69 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 166
     FILL-IN-21 AT ROW 3.69 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 126
     FILL-IN-NOM-21 AT ROW 3.69 COL 63 COLON-ALIGNED NO-LABEL WIDGET-ID 168
     FILL-IN-31 AT ROW 4.77 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 130
     FILL-IN-NOM-31 AT ROW 4.77 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 170
     FILL-IN-41 AT ROW 4.77 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 132
     FILL-IN-NOM-41 AT ROW 4.77 COL 63 COLON-ALIGNED NO-LABEL WIDGET-ID 172
     FILL-IN-51 AT ROW 5.85 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 134
     FILL-IN-NOM-51 AT ROW 5.85 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 174
     FILL-IN-61 AT ROW 5.85 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 136
     FILL-IN-NOM-61 AT ROW 5.85 COL 63 COLON-ALIGNED NO-LABEL WIDGET-ID 176
     FILL-IN-12 AT ROW 8.27 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 124
     FILL-IN-NOM-12 AT ROW 8.27 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 182
     FILL-IN-22 AT ROW 8.27 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 128
     FILL-IN-NOM-22 AT ROW 8.27 COL 63 COLON-ALIGNED NO-LABEL WIDGET-ID 184
     FILL-IN-32 AT ROW 9.35 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 142
     FILL-IN-NOM-32 AT ROW 9.35 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 186
     FILL-IN-42 AT ROW 9.35 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 144
     FILL-IN-NOM-42 AT ROW 9.35 COL 63 COLON-ALIGNED NO-LABEL WIDGET-ID 188
     FILL-IN-52 AT ROW 10.42 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 146
     FILL-IN-NOM-52 AT ROW 10.42 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 190
     FILL-IN-62 AT ROW 10.42 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 148
     FILL-IN-NOM-62 AT ROW 10.42 COL 63 COLON-ALIGNED NO-LABEL WIDGET-ID 192
     "DEBE S/." VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.62 COL 26 WIDGET-ID 100
          BGCOLOR 14 FGCOLOR 0 FONT 6
     "(123)" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 10.69 COL 2 WIDGET-ID 154
     "(7)" VIEW-AS TEXT
          SIZE 3 BY .5 AT ROW 9.62 COL 2 WIDGET-ID 156
     "(9)" VIEW-AS TEXT
          SIZE 3 BY .5 AT ROW 8.54 COL 2 WIDGET-ID 158
     "(7)" VIEW-AS TEXT
          SIZE 3 BY .5 AT ROW 5.04 COL 2 WIDGET-ID 118
     "DEBE US$" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 7.19 COL 26 WIDGET-ID 112
          BGCOLOR 14 FGCOLOR 0 FONT 6
     "(9)" VIEW-AS TEXT
          SIZE 3 BY .5 AT ROW 3.96 COL 2 WIDGET-ID 116
     "HABER US$" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 7.19 COL 71 WIDGET-ID 110
          BGCOLOR 11 FGCOLOR 0 FONT 6
     "HABER S/." VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 2.62 COL 71 WIDGET-ID 98
          BGCOLOR 11 FGCOLOR 0 FONT 6
     "(123)" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 6.12 COL 2 WIDGET-ID 120
     RECT-1 AT ROW 1 COL 7 WIDGET-ID 60
     RECT-2 AT ROW 2.35 COL 7 WIDGET-ID 70
     RECT-3 AT ROW 3.42 COL 7 WIDGET-ID 72
     RECT-4 AT ROW 2.35 COL 52 WIDGET-ID 74
     RECT-5 AT ROW 3.42 COL 52 WIDGET-ID 76
     RECT-6 AT ROW 2.35 COL 7 WIDGET-ID 90
     RECT-8 AT ROW 2.35 COL 52 WIDGET-ID 94
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     RECT-10 AT ROW 6.92 COL 7 WIDGET-ID 102
     RECT-11 AT ROW 8 COL 7 WIDGET-ID 104
     RECT-12 AT ROW 6.92 COL 52 WIDGET-ID 106
     RECT-13 AT ROW 8 COL 52 WIDGET-ID 108
     RECT-14 AT ROW 3.42 COL 1 WIDGET-ID 162
     RECT-15 AT ROW 8 COL 1 WIDGET-ID 164
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.FacDocum
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
         HEIGHT             = 14.23
         WIDTH              = 107.
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

/* SETTINGS FOR FILL-IN FILL-IN-11 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-12 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-21 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-22 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-31 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-32 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-41 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-42 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-51 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-52 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-61 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-62 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NOM-11 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NOM-12 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NOM-21 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NOM-22 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NOM-31 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NOM-32 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NOM-41 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NOM-42 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NOM-51 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NOM-52 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NOM-61 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NOM-62 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomOpe IN FRAME F-Main
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

&Scoped-define SELF-NAME FacDocum.Codope
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacDocum.Codope V-table-Win
ON LEAVE OF FacDocum.Codope IN FRAME F-Main /* Operacion */
DO:
  FIND cb-oper WHERE cb-oper.CodCia = cb-codcia
      AND cb-oper.Codope = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-oper THEN DO:
      MESSAGE 'Operción no válida' VIEW-AS ALERT-BOX WARNING.
      SELF:SCREEN-VALUE = "".
      RETURN NO-APPLY.
  END.
  FILL-IN-NomOpe:SCREEN-VALUE = cb-oper.Nomope.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-11 V-table-Win
ON LEAVE OF FILL-IN-11 IN FRAME F-Main
DO:
  FILL-IN-NOM-11:SCREEN-VALUE = "".
  IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
  FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
      AND cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-ctas THEN DO:
      MESSAGE 'Cuenta NO válida' VIEW-AS ALERT-BOX WARNING.
      SELF:SCREEN-VALUE = "".
      RETURN NO-APPLY.
  END.
  FILL-IN-NOM-11:SCREEN-VALUE = DYNAMIC-FUNCTION('fNomCta':U, SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-12 V-table-Win
ON LEAVE OF FILL-IN-12 IN FRAME F-Main
DO:
    FILL-IN-NOM-12:SCREEN-VALUE = "".
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
        AND cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta NO válida' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    FILL-IN-NOM-12:SCREEN-VALUE = DYNAMIC-FUNCTION('fNomCta':U, SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-21
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-21 V-table-Win
ON LEAVE OF FILL-IN-21 IN FRAME F-Main
DO:
    FILL-IN-NOM-21:SCREEN-VALUE = "".
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
        AND cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta NO válida' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    FILL-IN-NOM-21:SCREEN-VALUE = DYNAMIC-FUNCTION('fNomCta':U, SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-22
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-22 V-table-Win
ON LEAVE OF FILL-IN-22 IN FRAME F-Main
DO:
    FILL-IN-NOM-22:SCREEN-VALUE = "".
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
        AND cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta NO válida' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    FILL-IN-NOM-22:SCREEN-VALUE = DYNAMIC-FUNCTION('fNomCta':U, SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-31
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-31 V-table-Win
ON LEAVE OF FILL-IN-31 IN FRAME F-Main
DO:
    FILL-IN-NOM-31:SCREEN-VALUE = "".
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
        AND cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta NO válida' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    FILL-IN-NOM-31:SCREEN-VALUE = DYNAMIC-FUNCTION('fNomCta':U, SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-32
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-32 V-table-Win
ON LEAVE OF FILL-IN-32 IN FRAME F-Main
DO:
    FILL-IN-NOM-32:SCREEN-VALUE = "".
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
        AND cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta NO válida' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    FILL-IN-NOM-32:SCREEN-VALUE = DYNAMIC-FUNCTION('fNomCta':U, SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-41
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-41 V-table-Win
ON LEAVE OF FILL-IN-41 IN FRAME F-Main
DO:
    FILL-IN-NOM-41:SCREEN-VALUE = "".
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
        AND cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta NO válida' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    FILL-IN-NOM-41:SCREEN-VALUE = DYNAMIC-FUNCTION('fNomCta':U, SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-42
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-42 V-table-Win
ON LEAVE OF FILL-IN-42 IN FRAME F-Main
DO:
    FILL-IN-NOM-42:SCREEN-VALUE = "".
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
        AND cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta NO válida' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    FILL-IN-NOM-42:SCREEN-VALUE = DYNAMIC-FUNCTION('fNomCta':U, SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-51
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-51 V-table-Win
ON LEAVE OF FILL-IN-51 IN FRAME F-Main
DO:
    FILL-IN-NOM-51:SCREEN-VALUE = "".
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
        AND cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta NO válida' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    FILL-IN-NOM-51:SCREEN-VALUE = DYNAMIC-FUNCTION('fNomCta':U, SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-52
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-52 V-table-Win
ON LEAVE OF FILL-IN-52 IN FRAME F-Main
DO:
    FILL-IN-NOM-52:SCREEN-VALUE = "".
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
        AND cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta NO válida' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    FILL-IN-NOM-52:SCREEN-VALUE = DYNAMIC-FUNCTION('fNomCta':U, SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-61
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-61 V-table-Win
ON LEAVE OF FILL-IN-61 IN FRAME F-Main
DO:
    FILL-IN-NOM-61:SCREEN-VALUE = "".
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
        AND cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta NO válida' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    FILL-IN-NOM-61:SCREEN-VALUE = DYNAMIC-FUNCTION('fNomCta':U, SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-62
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-62 V-table-Win
ON LEAVE OF FILL-IN-62 IN FRAME F-Main
DO:
    FILL-IN-NOM-62:SCREEN-VALUE = "".
    IF TRUE <> (SELF:SCREEN-VALUE > "") THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
        AND cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta NO válida' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    FILL-IN-NOM-62:SCREEN-VALUE = DYNAMIC-FUNCTION('fNomCta':U, SELF:SCREEN-VALUE).
  
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
  {src/adm/template/row-list.i "FacDocum"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacDocum"}

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
  ASSIGN FRAME {&FRAME-NAME}
      FILL-IN-11 FILL-IN-12 FILL-IN-21 FILL-IN-22 FILL-IN-31 FILL-IN-32 
      FILL-IN-41 FILL-IN-42 FILL-IN-51 FILL-IN-52 FILL-IN-61 FILL-IN-62 
      
       .

  ASSIGN
      FacDocum.CodCta[1] = TRIM(FILL-IN-11) + ":" + TRIM(FILL-IN-12)
      FacDocum.CodCta[2] = TRIM(FILL-IN-21) + ":" + TRIM(FILL-IN-22)
      FacDocum.CodCta[3] = TRIM(FILL-IN-31) + ":" + TRIM(FILL-IN-32)
      FacDocum.CodCta[4] = TRIM(FILL-IN-41) + ":" + TRIM(FILL-IN-42)
      FacDocum.CodCta[5] = TRIM(FILL-IN-51) + ":" + TRIM(FILL-IN-52)
      FacDocum.CodCta[6] = TRIM(FILL-IN-61) + ":" + TRIM(FILL-IN-62)
      .

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
  DISABLE 
      FILL-IN-11 FILL-IN-12 FILL-IN-21 FILL-IN-22 FILL-IN-31 FILL-IN-32 
      FILL-IN-41 FILL-IN-42 FILL-IN-51 FILL-IN-52 FILL-IN-61 FILL-IN-62 
      
      WITH FRAME {&FRAME-NAME}.


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
  ASSIGN
      FILL-IN-11         = ""
      FILL-IN-12         = ""
      FILL-IN-21         = ""
      FILL-IN-22         = ""
      FILL-IN-31         = ""
      FILL-IN-32         = ""
      FILL-IN-41         = ""
      FILL-IN-42         = ""
      FILL-IN-51         = ""
      FILL-IN-52         = ""
      FILL-IN-61         = ""
      FILL-IN-62         = ""
      FILL-IN-NOM-11     = ""
      FILL-IN-NOM-12     = ""
      FILL-IN-NOM-21     = ""
      FILL-IN-NOM-22     = ""
      FILL-IN-NOM-31     = ""
      FILL-IN-NOM-32     = ""
      FILL-IN-NOM-41     = ""
      FILL-IN-NOM-42     = ""
      FILL-IN-NOM-51     = ""
      FILL-IN-NOM-52     = ""
      FILL-IN-NOM-61     = ""
      FILL-IN-NOM-62     = ""
      FILL-IN-NomOpe     = ""
      .

  IF AVAILABLE FacDocum THEN DO:
      /* Cargamos variables */
      ASSIGN
          FILL-IN-11 = ENTRY(1,FacDocum.CodCta[1],":")
          FILL-IN-21 = ENTRY(1,FacDocum.CodCta[2],":")
          FILL-IN-31 = ENTRY(1,FacDocum.CodCta[3],":")
          FILL-IN-41 = ENTRY(1,FacDocum.CodCta[4],":")
          FILL-IN-51 = ENTRY(1,FacDocum.CodCta[5],":")
          FILL-IN-61 = ENTRY(1,FacDocum.CodCta[6],":")
          .

      IF NUM-ENTRIES(FacDocum.CodCta[1],":") > 1 THEN FILL-IN-12 = ENTRY(2,FacDocum.CodCta[1],":").
      IF NUM-ENTRIES(FacDocum.CodCta[2],":") > 1 THEN FILL-IN-22 = ENTRY(2,FacDocum.CodCta[2],":").
      IF NUM-ENTRIES(FacDocum.CodCta[3],":") > 1 THEN FILL-IN-32 = ENTRY(2,FacDocum.CodCta[3],":").
      IF NUM-ENTRIES(FacDocum.CodCta[4],":") > 1 THEN FILL-IN-42 = ENTRY(2,FacDocum.CodCta[4],":").
      IF NUM-ENTRIES(FacDocum.CodCta[5],":") > 1 THEN FILL-IN-52 = ENTRY(2,FacDocum.CodCta[5],":").
      IF NUM-ENTRIES(FacDocum.CodCta[6],":") > 1 THEN FILL-IN-62 = ENTRY(2,FacDocum.CodCta[6],":").
      /* Completamos datos */
      FIND cb-oper WHERE cb-oper.CodCia = cb-codcia AND
          cb-oper.Codope = FacDocum.Codope NO-LOCK NO-ERROR.
      IF AVAILABLE cb-oper THEN FILL-IN-NomOpe = cb-oper.Nomope.

      FILL-IN-NOM-11 = DYNAMIC-FUNCTION('fNomCta':U, FILL-IN-11).
      FILL-IN-NOM-21 = DYNAMIC-FUNCTION('fNomCta':U, FILL-IN-21).
      FILL-IN-NOM-31 = DYNAMIC-FUNCTION('fNomCta':U, FILL-IN-31).
      FILL-IN-NOM-41 = DYNAMIC-FUNCTION('fNomCta':U, FILL-IN-41).
      FILL-IN-NOM-51 = DYNAMIC-FUNCTION('fNomCta':U, FILL-IN-51).
      FILL-IN-NOM-61 = DYNAMIC-FUNCTION('fNomCta':U, FILL-IN-61).
      FILL-IN-NOM-12 = DYNAMIC-FUNCTION('fNomCta':U, FILL-IN-12).
      FILL-IN-NOM-22 = DYNAMIC-FUNCTION('fNomCta':U, FILL-IN-22).
      FILL-IN-NOM-32 = DYNAMIC-FUNCTION('fNomCta':U, FILL-IN-32).
      FILL-IN-NOM-42 = DYNAMIC-FUNCTION('fNomCta':U, FILL-IN-42).
      FILL-IN-NOM-52 = DYNAMIC-FUNCTION('fNomCta':U, FILL-IN-52).
      FILL-IN-NOM-62 = DYNAMIC-FUNCTION('fNomCta':U, FILL-IN-62).

  END.
  DISPLAY
      FILL-IN-NomOpe
      FILL-IN-11 FILL-IN-12 FILL-IN-21 FILL-IN-22 FILL-IN-31 FILL-IN-32 FILL-IN-41 FILL-IN-42 
      FILL-IN-51 FILL-IN-52 FILL-IN-61 FILL-IN-62 
      FILL-IN-NOM-11 FILL-IN-NOM-12 FILL-IN-NOM-21 FILL-IN-NOM-22 FILL-IN-NOM-31 FILL-IN-NOM-32 
      FILL-IN-NOM-41 FILL-IN-NOM-42 FILL-IN-NOM-51 FILL-IN-NOM-52 FILL-IN-NOM-61 FILL-IN-NOM-62 
      
      WITH FRAME {&FRAME-NAME}.

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
  ENABLE 
      FILL-IN-11 FILL-IN-12 FILL-IN-21 FILL-IN-22 FILL-IN-31 FILL-IN-32 
      FILL-IN-41 FILL-IN-42 FILL-IN-51 FILL-IN-52 FILL-IN-61 FILL-IN-62 
      
      WITH FRAME {&FRAME-NAME}.

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
  {src/adm/template/snd-list.i "FacDocum"}

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

IF NOT AVAILABLE FacDocum THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNomCta V-table-Win 
FUNCTION fNomCta RETURNS CHARACTER
  ( INPUT pCodCta AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF pCodCta > "" THEN DO:
      FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia 
          AND cb-ctas.codcta = pCodCta NO-LOCK NO-ERROR.
      IF AVAILABLE cb-ctas THEN RETURN cb-ctas.Nomcta.
  END.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

