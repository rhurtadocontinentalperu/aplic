&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATG FOR Almmmatg.



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
&Scoped-define FRAME-NAME Ranking

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Almmmatg
&Scoped-define FIRST-EXTERNAL-TABLE Almmmatg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almmmatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RECT-4 RECT-5 RECT-6 
&Scoped-Define DISPLAYED-FIELDS Almmmatg.codmat Almmmatg.DesMat 
&Scoped-define DISPLAYED-TABLES Almmmatg
&Scoped-define FIRST-DISPLAYED-TABLE Almmmatg
&Scoped-Define DISPLAYED-OBJECTS txtClasf txtClasf-2 txtClasf-3 txtRank ~
txtRank-2 txtRank-3 txtClasf-4 txtClasf-5 txtClasf-6 txtRank-4 txtRank-5 ~
txtRank-6 

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
DEFINE VARIABLE txtClasf AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE txtClasf-2 AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE txtClasf-3 AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE txtClasf-4 AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE txtClasf-5 AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE txtClasf-6 AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE txtRank AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE txtRank-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE txtRank-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE txtRank-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE txtRank-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE txtRank-6 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.43 BY 2.69.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21 BY 2.73.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 2.73.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.14 BY 2.69.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21 BY 2.73.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 2.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Ranking
     Almmmatg.codmat AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     Almmmatg.DesMat AT ROW 1.27 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 8 FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 57 BY .81
     txtClasf AT ROW 4.85 COL 56 RIGHT-ALIGNED NO-LABEL WIDGET-ID 152
     txtClasf-2 AT ROW 4.85 COL 77 RIGHT-ALIGNED NO-LABEL WIDGET-ID 156
     txtClasf-3 AT ROW 4.85 COL 97.86 RIGHT-ALIGNED NO-LABEL WIDGET-ID 160
     txtRank AT ROW 5.85 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 154
     txtRank-2 AT ROW 5.85 COL 68 COLON-ALIGNED NO-LABEL WIDGET-ID 158
     txtRank-3 AT ROW 5.85 COL 88.86 COLON-ALIGNED NO-LABEL WIDGET-ID 162
     txtClasf-4 AT ROW 7.81 COL 56.29 RIGHT-ALIGNED NO-LABEL WIDGET-ID 164
     txtClasf-5 AT ROW 7.81 COL 77.29 RIGHT-ALIGNED NO-LABEL WIDGET-ID 168
     txtClasf-6 AT ROW 7.81 COL 98.72 RIGHT-ALIGNED NO-LABEL WIDGET-ID 172
     txtRank-4 AT ROW 8.81 COL 47.29 COLON-ALIGNED NO-LABEL WIDGET-ID 166
     txtRank-5 AT ROW 8.81 COL 68.29 COLON-ALIGNED NO-LABEL WIDGET-ID 170
     txtRank-6 AT ROW 8.81 COL 89.72 COLON-ALIGNED NO-LABEL WIDGET-ID 174
     "Ranking" VIEW-AS TEXT
          SIZE 8.43 BY .77 AT ROW 8.92 COL 35.43 WIDGET-ID 150
          FONT 15
     "Clasificacion" VIEW-AS TEXT
          SIZE 12.14 BY .77 AT ROW 4.73 COL 32.57 WIDGET-ID 144
          FONT 15
     "No Campaña" VIEW-AS TEXT
          SIZE 28.29 BY 1.35 AT ROW 7.92 COL 2.72 WIDGET-ID 142
          FGCOLOR 9 FONT 8
     "Campaña" VIEW-AS TEXT
          SIZE 21 BY 1.35 AT ROW 4.85 COL 9.43 WIDGET-ID 140
          FGCOLOR 9 FONT 8
     "Mayorista" VIEW-AS TEXT
          SIZE 13.29 BY .96 AT ROW 3.23 COL 87.29 WIDGET-ID 132
          FGCOLOR 4 FONT 9
     "Utilex/Institucionales" VIEW-AS TEXT
          SIZE 22.86 BY .96 AT ROW 3.27 COL 61.72 WIDGET-ID 130
          FGCOLOR 4 FONT 9
     "Ranking" VIEW-AS TEXT
          SIZE 8.43 BY .77 AT ROW 5.88 COL 35.43 WIDGET-ID 148
          FONT 15
     "Todos" VIEW-AS TEXT
          SIZE 8.72 BY .96 AT ROW 3.27 COL 46.57 WIDGET-ID 128
          FGCOLOR 4 FONT 9
     "Clasificacion" VIEW-AS TEXT
          SIZE 12.14 BY .77 AT ROW 7.88 COL 32.72 WIDGET-ID 146
          FONT 15
     RECT-1 AT ROW 4.27 COL 46 WIDGET-ID 114
     RECT-2 AT ROW 4.23 COL 62.57 WIDGET-ID 124
     RECT-3 AT ROW 4.19 COL 84.57 WIDGET-ID 126
     RECT-4 AT ROW 7.38 COL 46 WIDGET-ID 134
     RECT-5 AT ROW 7.35 COL 62.57 WIDGET-ID 136
     RECT-6 AT ROW 7.31 COL 84.57 WIDGET-ID 138
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.Almmmatg
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-MATG B "?" ? INTEGRAL Almmmatg
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
         HEIGHT             = 10
         WIDTH              = 107.72.
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
/* SETTINGS FOR FRAME Ranking
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME Ranking:SCROLLABLE       = FALSE
       FRAME Ranking:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almmmatg.codmat IN FRAME Ranking
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DesMat IN FRAME Ranking
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN txtClasf IN FRAME Ranking
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtClasf-2 IN FRAME Ranking
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtClasf-3 IN FRAME Ranking
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtClasf-4 IN FRAME Ranking
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtClasf-5 IN FRAME Ranking
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtClasf-6 IN FRAME Ranking
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txtRank IN FRAME Ranking
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtRank-2 IN FRAME Ranking
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtRank-3 IN FRAME Ranking
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtRank-4 IN FRAME Ranking
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtRank-5 IN FRAME Ranking
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtRank-6 IN FRAME Ranking
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME Ranking
/* Query rebuild information for FRAME Ranking
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME Ranking */
&ANALYZE-RESUME

 


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
  {src/adm/template/row-list.i "Almmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
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
  HIDE FRAME Ranking.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
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

  txtClasf:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .
  txtClasf-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .
  txtClasf-3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .
  txtClasf-4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .
  txtClasf-5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .
  txtClasf-6:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .
  txtRank:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .
  txtRank-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .
  txtRank-3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .
  txtRank-4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .
  txtRank-5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .
  txtRank-6:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almmmatg THEN DO WITH FRAME {&FRAME-NAME}:
/*       FIND B-MATG WHERE B-MATG.codcia = Almmmatg.codcia        */
/*           AND B-MATG.codmat = Almmmatg.Libre_c04               */
/*           NO-LOCK NO-ERROR.                                    */
/*       IF AVAILABLE B-MATG                                      */
/*           THEN ASSIGN                                          */
/*                 FILL-IN_DesMat-2:SCREEN-VALUE = B-MATG.DesMat. */

      /* Ranking */
      FIND FIRST factabla WHERE factabla.codcia = Almmmatg.codcia AND 
                                factabla.tabla = 'RANKVTA' AND 
                                factabla.codigo = almmmatg.codmat
                                NO-LOCK NO-ERROR.
      IF AVAILABLE factabla THEN DO:
          txtClasf:SCREEN-VALUE IN FRAME {&FRAME-NAME} = factabla.campo-c[1].
          txtClasf-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = factabla.campo-c[2] .
          txtClasf-3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = factabla.campo-c[3] .
          txtClasf-4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = factabla.campo-c[4] .
          txtClasf-5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = factabla.campo-c[5] .
          txtClasf-6:SCREEN-VALUE IN FRAME {&FRAME-NAME} = factabla.campo-c[6] .
          txtRank:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(factabla.valor[1],">>,>>>,>>9").
          txtRank-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(factabla.valor[2],">>,>>>,>>9").
          txtRank-3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(factabla.valor[3],">>,>>>,>>9").
          txtRank-4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(factabla.valor[4],">>,>>>,>>9").
          txtRank-5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(factabla.valor[5],">>,>>>,>>9").
          txtRank-6:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(factabla.valor[6],">>,>>>,>>9").        
      END.
      RELEASE factabla.
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
/*     IF Almmmatg.Libre_c04:SCREEN-VALUE <> '' THEN DO:                             */
/*         FIND b-matg WHERE b-matg.codcia = almmmatg.codcia                         */
/*             AND b-matg.codmat = Almmmatg.Libre_c04:SCREEN-VALUE NO-LOCK NO-ERROR. */
/*         IF NOT AVAILABLE b-matg THEN DO:                                          */
/*             MESSAGE 'Código equivalente no registrado' VIEW-AS ALERT-BOX ERROR.   */
/*             APPLY 'ENTRY':U TO Almmmatg.Libre_c04.                                */
/*             RETURN 'ADM-ERROR'.                                                   */
/*         END.                                                                      */
/*     END.                                                                          */
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

