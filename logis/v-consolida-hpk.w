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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

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
&Scoped-define EXTERNAL-TABLES LogisConsolidaHpk Almacen
&Scoped-define FIRST-EXTERNAL-TABLE LogisConsolidaHpk


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LogisConsolidaHpk, Almacen.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS LogisConsolidaHpk.CodAlm ~
LogisConsolidaHpk.Sectores 
&Scoped-define ENABLED-TABLES LogisConsolidaHpk
&Scoped-define FIRST-ENABLED-TABLE LogisConsolidaHpk
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 
&Scoped-Define DISPLAYED-FIELDS LogisConsolidaHpk.Caso ~
LogisConsolidaHpk.CodAlm Almacen.Descripcion LogisConsolidaHpk.Sectores ~
LogisConsolidaHpk.FchCreacion LogisConsolidaHpk.FchModificacion ~
LogisConsolidaHpk.HoraCreacion LogisConsolidaHpk.HoraModificacion ~
LogisConsolidaHpk.UsrCreacion LogisConsolidaHpk.UsrModificacion 
&Scoped-define DISPLAYED-TABLES LogisConsolidaHpk Almacen
&Scoped-define FIRST-DISPLAYED-TABLE LogisConsolidaHpk
&Scoped-define SECOND-DISPLAYED-TABLE Almacen


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
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/search.ico":U
     LABEL "Button 1" 
     SIZE 6 BY 1.35.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 4.58.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 4.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     LogisConsolidaHpk.Caso AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     LogisConsolidaHpk.CodAlm AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
          BGCOLOR 11 FGCOLOR 0 
     Almacen.Descripcion AT ROW 2.08 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 20 FORMAT "X(50)"
          VIEW-AS FILL-IN 
          SIZE 42 BY .81
     LogisConsolidaHpk.Sectores AT ROW 2.88 COL 21 NO-LABEL WIDGET-ID 18
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 50 BY 4
          BGCOLOR 11 FGCOLOR 0 
     BUTTON-1 AT ROW 2.88 COL 71 WIDGET-ID 32
     LogisConsolidaHpk.FchCreacion AT ROW 8 COL 9 COLON-ALIGNED WIDGET-ID 6
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     LogisConsolidaHpk.FchModificacion AT ROW 8 COL 49 COLON-ALIGNED WIDGET-ID 8
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     LogisConsolidaHpk.HoraCreacion AT ROW 8.81 COL 9 COLON-ALIGNED WIDGET-ID 10
          LABEL "Hora"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     LogisConsolidaHpk.HoraModificacion AT ROW 8.81 COL 49 COLON-ALIGNED WIDGET-ID 12
          LABEL "Hora"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     LogisConsolidaHpk.UsrCreacion AT ROW 9.62 COL 9 COLON-ALIGNED WIDGET-ID 14
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     LogisConsolidaHpk.UsrModificacion AT ROW 9.62 COL 49 COLON-ALIGNED WIDGET-ID 16
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     "Datos modificación" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 7.19 COL 43 WIDGET-ID 26
          BGCOLOR 9 FGCOLOR 15 
     "Datos creación" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 7.19 COL 5 WIDGET-ID 24
          BGCOLOR 9 FGCOLOR 15 
     "Sectores:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.15 COL 14 WIDGET-ID 22
     RECT-1 AT ROW 7.46 COL 2 WIDGET-ID 28
     RECT-2 AT ROW 7.46 COL 41 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.LogisConsolidaHpk,INTEGRAL.Almacen
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
         HEIGHT             = 14.15
         WIDTH              = 80.86.
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

/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LogisConsolidaHpk.Caso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almacen.Descripcion IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LogisConsolidaHpk.FchCreacion IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LogisConsolidaHpk.FchModificacion IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LogisConsolidaHpk.HoraCreacion IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LogisConsolidaHpk.HoraModificacion IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LogisConsolidaHpk.UsrCreacion IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LogisConsolidaHpk.UsrModificacion IN FRAME F-Main
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

&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 V-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    DEF VAR x-Sectores AS CHAR NO-UNDO.
    x-Sectores = LogisConsolidaHpk.Sectores:SCREEN-VALUE.
    RUN alm/d-tsectores (INPUT LogisConsolidaHpk.CodAlm:SCREEN-VALUE,
                         INPUT-OUTPUT x-Sectores).
    LogisConsolidaHpk.Sectores:SCREEN-VALUE = x-Sectores.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LogisConsolidaHpk.CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LogisConsolidaHpk.CodAlm V-table-Win
ON LEAVE OF LogisConsolidaHpk.CodAlm IN FRAME F-Main /* Almacen */
DO:
  FIND Almacen WHERE Almacen.CodCia = s-CodCia
      AND Almacen.CodAlm = LogisConsolidaHpk.CodAlm:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN DISPLAY Almacen.Descripcion WITH FRAME {&FRAME-NAME}.
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
  {src/adm/template/row-list.i "LogisConsolidaHpk"}
  {src/adm/template/row-list.i "Almacen"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "LogisConsolidaHpk"}
  {src/adm/template/row-find.i "Almacen"}

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
  ASSIGN
      LogisConsolidaHpk.CodCia = s-CodCia.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN
      ASSIGN
      LogisConsolidaHpk.FchCreacion = TODAY
      LogisConsolidaHpk.HoraCreacion = STRING(TIME, 'HH:MM:SS')
      LogisConsolidaHpk.Caso = NEXT-VALUE(next-caso-hpk)
      LogisConsolidaHpk.UsrCreacion = s-user-id.
  ELSE ASSIGN
      LogisConsolidaHpk.FchModificacion = TODAY
      LogisConsolidaHpk.HoraModificacion = STRING(TIME, 'HH:MM:SS')
      LogisConsolidaHpk.UsrModificacion = s-user-id.

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
  DISABLE BUTTON-1 WITH FRAME {&FRAME-NAME}.

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
  DISABLE LogisConsolidaHpk.Sectores WITH FRAME {&FRAME-NAME}.
  ENABLE BUTTON-1 WITH FRAME {&FRAME-NAME}.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DISABLE LogisConsolidaHpk.CodAlm WITH FRAME {&FRAME-NAME}.

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
  {src/adm/template/snd-list.i "LogisConsolidaHpk"}
  {src/adm/template/snd-list.i "Almacen"}

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
    IF TRUE <> (LogisConsolidaHpk.CodAlm:SCREEN-VALUE > '') 
        OR NOT CAN-FIND(FIRST Almacen WHERE Almacen.CodCia = s-CodCia
                        AND Almacen.CodAlm = LogisConsolidaHpk.CodAlm:SCREEN-VALUE NO-LOCK)
        THEN DO:
        MESSAGE 'Error el el código del almacén' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO LogisConsolidaHpk.CodAlm.
        RETURN 'ADM-ERROR'.
    END.
    DEF VAR k AS INTE NO-UNDO.
    IF TRUE <> (LogisConsolidaHpk.Sectores:SCREEN-VALUE > '')  THEN DO:
        MESSAGE 'NO hay sectores definidos' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO LogisConsolidaHpk.CodAlm.
        RETURN 'ADM-ERROR'.
    END.
    DEF VAR x-Sectores AS CHAR NO-UNDO.
    x-Sectores = LogisConsolidaHpk.Sectores:SCREEN-VALUE.
    DO k = 1 TO NUM-ENTRIES(x-Sectores):
        IF NOT CAN-FIND(FIRST AlmtZona WHERE AlmtZona.CodCia = s-CodCia
                        AND AlmtZona.CodAlm = LogisConsolidaHpk.CodAlm:SCREEN-VALUE
                        AND AlmtZona.CodZona = ENTRY(k, x-Sectores) NO-LOCK)
            THEN DO:
            MESSAGE 'ERROR: el sector' ENTRY(k, x-Sectores) 'no pertenece al almacén' LogisConsolidaHpk.CodAlm:SCREEN-VALUE
                VIEW-AS ALERT-BOX ERROR.
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

