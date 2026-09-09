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

DEF SHARED VAR s-codcia AS INT.

DEF BUFFER B-MATG FOR Almmmatg.

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
&Scoped-define EXTERNAL-TABLES vtapmatg
&Scoped-define FIRST-EXTERNAL-TABLE vtapmatg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR vtapmatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS vtapmatg.Periodo vtapmatg.codmat ~
vtapmatg.Tipo vtapmatg.CanBase vtapmatg.CanProy[1] vtapmatg.CanProy[7] ~
vtapmatg.CanProy[2] vtapmatg.CanProy[8] vtapmatg.CanProy[3] ~
vtapmatg.CanProy[9] vtapmatg.CanProy[4] vtapmatg.CanProy[10] ~
vtapmatg.CanProy[5] vtapmatg.CanProy[11] vtapmatg.CanProy[6] ~
vtapmatg.CanProy[12] 
&Scoped-define ENABLED-TABLES vtapmatg
&Scoped-define FIRST-ENABLED-TABLE vtapmatg
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 
&Scoped-Define DISPLAYED-FIELDS vtapmatg.Periodo vtapmatg.codmat ~
vtapmatg.Tipo vtapmatg.CanBase vtapmatg.CanProy[1] vtapmatg.PorProy[1] ~
vtapmatg.CanProy[7] vtapmatg.PorProy[7] vtapmatg.CanProy[2] ~
vtapmatg.PorProy[2] vtapmatg.CanProy[8] vtapmatg.PorProy[8] ~
vtapmatg.CanProy[3] vtapmatg.PorProy[3] vtapmatg.CanProy[9] ~
vtapmatg.PorProy[9] vtapmatg.CanProy[4] vtapmatg.PorProy[4] ~
vtapmatg.CanProy[10] vtapmatg.PorProy[10] vtapmatg.CanProy[5] ~
vtapmatg.PorProy[5] vtapmatg.CanProy[11] vtapmatg.PorProy[11] ~
vtapmatg.CanProy[6] vtapmatg.PorProy[6] vtapmatg.CanProy[12] ~
vtapmatg.PorProy[12] 
&Scoped-define DISPLAYED-TABLES vtapmatg
&Scoped-define FIRST-DISPLAYED-TABLE vtapmatg
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_DesMat-1 FILL-IN_CodAnt ~
FILL-IN_DesMat-2 FILL-IN-UndBas-1 FILL-IN_PMaxMn2 FILL-IN-UndBas-2 

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
DEFINE VARIABLE FILL-IN-UndBas-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-UndBas-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodAnt AS CHARACTER FORMAT "X(8)" 
     LABEL "Codigo Equivalente" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81.

DEFINE VARIABLE FILL-IN_DesMat-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_DesMat-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_PMaxMn2 AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.9999)" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 2.96.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 7.27.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     vtapmatg.Periodo AT ROW 1 COL 17 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     vtapmatg.codmat AT ROW 2.08 COL 17 COLON-ALIGNED WIDGET-ID 72
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     FILL-IN_DesMat-1 AT ROW 2.08 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     vtapmatg.Tipo AT ROW 3.15 COL 19 NO-LABEL WIDGET-ID 64
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "por Equivalencia", "E":U,
"por Proyeccion", "P":U
          SIZE 25 BY .81
     FILL-IN_CodAnt AT ROW 4.77 COL 17 COLON-ALIGNED WIDGET-ID 88
     FILL-IN_DesMat-2 AT ROW 4.77 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     FILL-IN-UndBas-1 AT ROW 5.85 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     FILL-IN_PMaxMn2 AT ROW 5.85 COL 35 COLON-ALIGNED HELP
          "Precio maximo en moneda extranjera" NO-LABEL WIDGET-ID 90
     FILL-IN-UndBas-2 AT ROW 5.85 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     vtapmatg.CanBase AT ROW 8 COL 17 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     vtapmatg.CanProy[1] AT ROW 9.08 COL 17 COLON-ALIGNED WIDGET-ID 22
          LABEL "Enero"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     vtapmatg.PorProy[1] AT ROW 9.08 COL 29 COLON-ALIGNED WIDGET-ID 46
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     vtapmatg.CanProy[7] AT ROW 9.08 COL 47 COLON-ALIGNED WIDGET-ID 34
          LABEL "Julio"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     vtapmatg.PorProy[7] AT ROW 9.08 COL 59 COLON-ALIGNED WIDGET-ID 58
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     vtapmatg.CanProy[2] AT ROW 9.88 COL 17 COLON-ALIGNED WIDGET-ID 24
          LABEL "Febrero"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     vtapmatg.PorProy[2] AT ROW 9.88 COL 29 COLON-ALIGNED WIDGET-ID 48
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     vtapmatg.CanProy[8] AT ROW 9.88 COL 47 COLON-ALIGNED WIDGET-ID 36
          LABEL "Agosto"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     vtapmatg.PorProy[8] AT ROW 9.88 COL 59 COLON-ALIGNED WIDGET-ID 60
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     vtapmatg.CanProy[3] AT ROW 10.69 COL 17 COLON-ALIGNED WIDGET-ID 26
          LABEL "Marzo"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     vtapmatg.PorProy[3] AT ROW 10.69 COL 29 COLON-ALIGNED WIDGET-ID 50
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     vtapmatg.CanProy[9] AT ROW 10.69 COL 47 COLON-ALIGNED WIDGET-ID 38
          LABEL "Setiembre"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     vtapmatg.PorProy[9] AT ROW 10.69 COL 59 COLON-ALIGNED WIDGET-ID 62
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     vtapmatg.CanProy[4] AT ROW 11.5 COL 17 COLON-ALIGNED WIDGET-ID 28
          LABEL "Abril"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     vtapmatg.PorProy[4] AT ROW 11.5 COL 29 COLON-ALIGNED WIDGET-ID 52
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     vtapmatg.CanProy[10] AT ROW 11.5 COL 47 COLON-ALIGNED WIDGET-ID 16
          LABEL "Octubre"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     vtapmatg.PorProy[10] AT ROW 11.5 COL 59 COLON-ALIGNED WIDGET-ID 40
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     vtapmatg.CanProy[5] AT ROW 12.31 COL 17 COLON-ALIGNED WIDGET-ID 30
          LABEL "Mayo"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     vtapmatg.PorProy[5] AT ROW 12.31 COL 29 COLON-ALIGNED WIDGET-ID 54
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     vtapmatg.CanProy[11] AT ROW 12.31 COL 47 COLON-ALIGNED WIDGET-ID 18
          LABEL "Noviembre"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     vtapmatg.PorProy[11] AT ROW 12.31 COL 59 COLON-ALIGNED WIDGET-ID 42
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     vtapmatg.CanProy[6] AT ROW 13.12 COL 17 COLON-ALIGNED WIDGET-ID 32
          LABEL "Junio"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     vtapmatg.PorProy[6] AT ROW 13.12 COL 29 COLON-ALIGNED WIDGET-ID 56
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     vtapmatg.CanProy[12] AT ROW 13.12 COL 47 COLON-ALIGNED WIDGET-ID 20
          LABEL "Diciembre"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     vtapmatg.PorProy[12] AT ROW 13.12 COL 59 COLON-ALIGNED WIDGET-ID 44
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     "1" VIEW-AS TEXT
          SIZE 2 BY .81 AT ROW 5.85 COL 19 WIDGET-ID 80
     "Tipo:" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 3.15 COL 14 WIDGET-ID 68
     "EQUIVALEN A" VIEW-AS TEXT
          SIZE 11 BY .81 AT ROW 5.85 COL 26 WIDGET-ID 82
     RECT-1 AT ROW 4.23 COL 2 WIDGET-ID 86
     RECT-2 AT ROW 7.46 COL 2 WIDGET-ID 92
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.vtapmatg
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
         HEIGHT             = 14.27
         WIDTH              = 115.86.
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

/* SETTINGS FOR FILL-IN vtapmatg.CanProy[10] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN vtapmatg.CanProy[11] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN vtapmatg.CanProy[12] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN vtapmatg.CanProy[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN vtapmatg.CanProy[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN vtapmatg.CanProy[3] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN vtapmatg.CanProy[4] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN vtapmatg.CanProy[5] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN vtapmatg.CanProy[6] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN vtapmatg.CanProy[7] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN vtapmatg.CanProy[8] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN vtapmatg.CanProy[9] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-UndBas-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-UndBas-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodAnt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DesMat-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DesMat-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PMaxMn2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vtapmatg.PorProy[10] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN vtapmatg.PorProy[11] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN vtapmatg.PorProy[12] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN vtapmatg.PorProy[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN vtapmatg.PorProy[2] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN vtapmatg.PorProy[3] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN vtapmatg.PorProy[4] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN vtapmatg.PorProy[5] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN vtapmatg.PorProy[6] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN vtapmatg.PorProy[7] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN vtapmatg.PorProy[8] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN vtapmatg.PorProy[9] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME vtapmatg.CanBase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vtapmatg.CanBase V-table-Win
ON LEAVE OF vtapmatg.CanBase IN FRAME F-Main /* Cantidad Base */
DO:
  RUN Calcula-Importes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vtapmatg.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vtapmatg.codmat V-table-Win
ON LEAVE OF vtapmatg.codmat IN FRAME F-Main /* Codigo Articulo */
DO:
  ASSIGN
      SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '999999')
      NO-ERROR.
  FIND b-matg WHERE b-matg.codcia = s-codcia
      AND b-matg.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE b-matg 
  THEN ASSIGN 
            FILL-IN_DesMat-1:SCREEN-VALUE = b-matg.desmat
            FILL-IN-UndBas-1:SCREEN-VALUE = b-matg.undbas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodAnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodAnt V-table-Win
ON LEAVE OF FILL-IN_CodAnt IN FRAME F-Main /* Codigo Equivalente */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  ASSIGN
      SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '999999')
      NO-ERROR.
  FIND b-matg WHERE b-matg.codcia = s-codcia
      AND b-matg.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE b-matg 
  THEN ASSIGN
            FILL-IN_DesMat-2:SCREEN-VALUE = b-matg.desmat
            FILL-IN-UndBas-2:SCREEN-VALUE = b-matg.undbas.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vtapmatg.Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vtapmatg.Periodo V-table-Win
ON LEAVE OF vtapmatg.Periodo IN FRAME F-Main /* Periodo */
DO:
  IF INTEGER(SELF:SCREEN-VALUE) < YEAR(TODAY) THEN DO:
      MESSAGE 'Perido incorrecto' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vtapmatg.Tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vtapmatg.Tipo V-table-Win
ON VALUE-CHANGED OF vtapmatg.Tipo IN FRAME F-Main /* Tipo */
DO:
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF SELF:SCREEN-VALUE = 'P' THEN DO:
      ASSIGN
          input-var-1 = ''
          input-var-2 = ''
          input-var-3 = ''
          output-var-1 = ?.
      RUN lkup/c-proyvta ('Plantillas de Proyecciones').
      IF output-var-1 <> ? THEN DO:
          /* pintamos información */
          FIND Factabla WHERE ROWID(Factabla) = output-var-1 NO-LOCK NO-ERROR.
          IF AVAILABLE Factabla 
          THEN DISPLAY
              FacTabla.Valor[1] @ Vtapmatg.PorPro[1]
              FacTabla.Valor[2] @ Vtapmatg.PorPro[2]
              FacTabla.Valor[3] @ Vtapmatg.PorPro[3]
              FacTabla.Valor[4] @ Vtapmatg.PorPro[4]
              FacTabla.Valor[5] @ Vtapmatg.PorPro[5]
              FacTabla.Valor[6] @ Vtapmatg.PorPro[6]
              FacTabla.Valor[7] @ Vtapmatg.PorPro[7]
              FacTabla.Valor[8] @ Vtapmatg.PorPro[8]
              FacTabla.Valor[9] @ Vtapmatg.PorPro[9]
              FacTabla.Valor[10] @ Vtapmatg.PorPro[10]
              FacTabla.Valor[11] @ Vtapmatg.PorPro[11]
              FacTabla.Valor[12] @ Vtapmatg.PorPro[12]
              WITH FRAME {&FRAME-NAME}.
          RUN Calcula-Importes.
      END.
  END.
  CASE vtapmatg.Tipo:SCREEN-VALUE:
    WHEN 'E' THEN ASSIGN
                    FILL-IN_CodAnt:SENSITIVE = YES
                    FILL-IN_PMaxMn2:SENSITIVE = YES.
                    
    WHEN 'P' THEN ASSIGN
                    FILL-IN_CodAnt:SCREEN-VALUE = ''
                    FILL-IN_CodAnt:SENSITIVE = NO
                    FILL-IN_PMaxMn2:SENSITIVE = NO.
  END CASE.
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
  {src/adm/template/row-list.i "vtapmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "vtapmatg"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Importes V-table-Win 
PROCEDURE Calcula-Importes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-CanBase LIKE vtapmatg.canbase.
DEF VAR x-CanProy LIKE vtapmatg.canproy.

x-CanBase = DECIMAL(vtapmatg.CanBase:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
ASSIGN
    x-CanProy[1] = ROUND(x-CanBase * DECIMAL(vtapmatg.PorProy[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) / 100 , 0)
    x-CanProy[2] = ROUND(x-CanBase * DECIMAL(vtapmatg.PorProy[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) / 100 , 0)
    x-CanProy[3] = ROUND(x-CanBase * DECIMAL(vtapmatg.PorProy[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) / 100 , 0)
    x-CanProy[4] = ROUND(x-CanBase * DECIMAL(vtapmatg.PorProy[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) / 100 , 0)
    x-CanProy[5] = ROUND(x-CanBase * DECIMAL(vtapmatg.PorProy[5]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) / 100 , 0)
    x-CanProy[6] = ROUND(x-CanBase * DECIMAL(vtapmatg.PorProy[6]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) / 100 , 0)
    x-CanProy[7] = ROUND(x-CanBase * DECIMAL(vtapmatg.PorProy[7]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) / 100 , 0)
    x-CanProy[8] = ROUND(x-CanBase * DECIMAL(vtapmatg.PorProy[8]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) / 100 , 0)
    x-CanProy[9] = ROUND(x-CanBase * DECIMAL(vtapmatg.PorProy[9]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) / 100 , 0)
    x-CanProy[10] = ROUND(x-CanBase * DECIMAL(vtapmatg.PorProy[10]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) / 100 , 0)
    x-CanProy[11] = ROUND(x-CanBase * DECIMAL(vtapmatg.PorProy[11]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) / 100 , 0)
    x-CanProy[12] = ROUND(x-CanBase * DECIMAL(vtapmatg.PorProy[12]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) / 100 , 0).
DISPLAY
    x-CanProy[1] @ vtapmatg.canproy[1]
    x-CanProy[2] @ vtapmatg.canproy[2]
    x-CanProy[3] @ vtapmatg.canproy[3]
    x-CanProy[4] @ vtapmatg.canproy[4]
    x-CanProy[5] @ vtapmatg.canproy[5]
    x-CanProy[6] @ vtapmatg.canproy[6]
    x-CanProy[7] @ vtapmatg.canproy[7]
    x-CanProy[8] @ vtapmatg.canproy[8]
    x-CanProy[9] @ vtapmatg.canproy[9]
    x-CanProy[10] @ vtapmatg.canproy[10]
    x-CanProy[11] @ vtapmatg.canproy[11]
    x-CanProy[12] @ vtapmatg.canproy[12]
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY 
          YEAR(TODAY) + 1 @ vtapmatg.periodo.
      ASSIGN
          FILL-IN_CodAnt:SENSITIVE = YES
          FILL-IN_PMaxMn2:SENSITIVE = YES
          Vtapmatg.Tipo:SCREEN-VALUE = 'E'.
  END.

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
      vtapmatg.codcia = s-codcia.
  IF vtapmatg.canbase > 0 
  THEN ASSIGN
          vtapmatg.PorProy[1] = ROUND(vtapmatg.canproy[1] / vtapmatg.CanBase * 100, 0)
          vtapmatg.PorProy[2] = ROUND(vtapmatg.canproy[2] / vtapmatg.CanBase * 100, 0)
          vtapmatg.PorProy[3] = ROUND(vtapmatg.canproy[3] / vtapmatg.CanBase * 100, 0)
          vtapmatg.PorProy[4] = ROUND(vtapmatg.canproy[4] / vtapmatg.CanBase * 100, 0)
          vtapmatg.PorProy[5] = ROUND(vtapmatg.canproy[5] / vtapmatg.CanBase * 100, 0)
          vtapmatg.PorProy[6] = ROUND(vtapmatg.canproy[6] / vtapmatg.CanBase * 100, 0)
          vtapmatg.PorProy[7] = ROUND(vtapmatg.canproy[7] / vtapmatg.CanBase * 100, 0)
          vtapmatg.PorProy[8] = ROUND(vtapmatg.canproy[8] / vtapmatg.CanBase * 100, 0)
          vtapmatg.PorProy[9] = ROUND(vtapmatg.canproy[9] / vtapmatg.CanBase * 100, 0)
          vtapmatg.PorProy[10] = ROUND(vtapmatg.canproy[10] / vtapmatg.CanBase * 100, 0)
          vtapmatg.PorProy[11] = ROUND(vtapmatg.canproy[11] / vtapmatg.CanBase * 100, 0)
          vtapmatg.PorProy[12] = ROUND(vtapmatg.canproy[12] / vtapmatg.CanBase * 100, 0).
  ELSE ASSIGN
          vtapmatg.PorProy[1] = 0
          vtapmatg.PorProy[2] = 0
          vtapmatg.PorProy[3] = 0
          vtapmatg.PorProy[4] = 0
          vtapmatg.PorProy[5] = 0
          vtapmatg.PorProy[6] = 0
          vtapmatg.PorProy[7] = 0
          vtapmatg.PorProy[8] = 0
          vtapmatg.PorProy[9] = 0
          vtapmatg.PorProy[10] = 0
          vtapmatg.PorProy[11] = 0
          vtapmatg.PorProy[12] = 0.
  FIND Almmmatg OF Vtapmatg EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN UNDO, RETURN 'ADM-ERROR'.
  ASSIGN
      Almmmatg.codant = FILL-IN_CodAnt:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      Almmmatg.pmaxmn2 = DECIMAL(FILL-IN_PMaxMn2:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  RELEASE Almmmatg.

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
        FILL-IN_CodAnt:SENSITIVE = NO
        FILL-IN_PMaxMn2:SENSITIVE = NO.
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
  IF AVAILABLE Vtapmatg THEN DO WITH FRAME {&FRAME-NAME}:
      FIND Almmmatg OF VTapmatg NO-LOCK.
      DISPLAY
          Almmmatg.desmat @ FILL-IN_desmat-1
          Almmmatg.codant @ FILL-IN_codant
          Almmmatg.pmaxmn2 @ FILL-IN_pmaxmn2
          Almmmatg.undbas @ FILL-IN-undbas-1.
      ASSIGN
          FILL-IN_desmat-2:SCREEN-VALUE = ''
          FILL-IN-undbas-2:SCREEN-VALUE = ''.
      FIND b-matg WHERE b-matg.codcia = s-codcia
          AND b-matg.codmat = Almmmatg.codant
          NO-LOCK NO-ERROR.
      IF AVAILABLE b-matg 
      THEN DISPLAY
                b-matg.desmat @ FILL-IN_desmat-2
                b-matg.undbas @ FILL-IN-undbas-2.

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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          vtapmatg.codmat:SENSITIVE = NO
          vtapmatg.Periodo:SENSITIVE = NO.
      CASE vtapmatg.Tipo:
        WHEN 'E' THEN ASSIGN
                        FILL-IN_CodAnt:SENSITIVE = YES
                        FILL-IN_PMaxMn2:SENSITIVE = YES.

        WHEN 'P' THEN ASSIGN
                        FILL-IN_CodAnt:SENSITIVE = NO
                        FILL-IN_PMaxMn2:SENSITIVE = NO.
      END CASE.
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
  RUN dispatch IN THIS-PROCEDURE ('display-fields').

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
  {src/adm/template/snd-list.i "vtapmatg"}

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
    FIND b-matg WHERE b-matg.codcia = s-codcia
        AND b-matg.codmat = Vtapmatg.codmat:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE b-matg THEN DO:
        MESSAGE 'Código de artículo NO registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO vtapmatg.codmat.
        RETURN 'ADM-ERROR'.
    END.
    IF Vtapmatg.tipo:SCREEN-VALUE = 'P' 
    THEN DO: 
        IF DECIMAL(vtapmatg.CanBase:SCREEN-VALUE) <= 0 THEN DO:
            MESSAGE 'Cantidad base NO puede ser cero' VIEW-AS ALERT-BOX ERROR.
            APPLY 'entry':U TO Vtapmatg.canbase.
            RETURN 'ADM-ERROR'.
        END.
        DISPLAY
            '' @ FILL-IN_CodAnt
            '' @  FILL-IN_DesMat-2
            0 @ FILL-IN_PMaxMn2.
    END.
    ELSE DO:
        FIND b-matg WHERE b-matg.codcia = s-codcia
            AND b-matg.codmat = FILL-IN_CodAnt:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE b-matg THEN DO:
            MESSAGE 'Código de artículo NO registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'entry':U TO FILL-IN_CodAnt.
            RETURN 'ADM-ERROR'.
        END.
        DISPLAY
            0 @ Vtapmatg.canbase.
        RUN Calcula-Importes.
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

