&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-DPAPE LIKE ac-dpape.



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
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-nroser AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-tipmov AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF SHARED VARIABLE lh_Handle  AS HANDLE.

DEF BUFFER b-dpape FOR ac-dpape.
DEF BUFFER b-cpape FOR ac-cpape.

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
&Scoped-define EXTERNAL-TABLES ac-cpape
&Scoped-define FIRST-EXTERNAL-TABLE ac-cpape


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ac-cpape.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ac-cpape.CCosto_Destino ~
ac-cpape.Responsable_Destino ac-cpape.Observaciones 
&Scoped-define ENABLED-TABLES ac-cpape
&Scoped-define FIRST-ENABLED-TABLE ac-cpape
&Scoped-Define DISPLAYED-FIELDS ac-cpape.NroSer ac-cpape.NroDoc ~
ac-cpape.FchDoc ac-cpape.CCosto_Destino ac-cpape.Usuario ~
ac-cpape.Responsable_Destino ac-cpape.Observaciones 
&Scoped-define DISPLAYED-TABLES ac-cpape
&Scoped-define FIRST-DISPLAYED-TABLE ac-cpape
&Scoped-Define DISPLAYED-OBJECTS x-Estado x-NomCco x-NomPer 

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
DEFINE VARIABLE x-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-NomCco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomPer AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ac-cpape.NroSer AT ROW 1.27 COL 11 COLON-ALIGNED WIDGET-ID 16
          LABEL "Numero"
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .81
          BGCOLOR 15 FGCOLOR 9 
     ac-cpape.NroDoc AT ROW 1.27 COL 15 COLON-ALIGNED NO-LABEL WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
          BGCOLOR 15 FGCOLOR 9 
     x-Estado AT ROW 1.27 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     ac-cpape.FchDoc AT ROW 1.27 COL 87 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ac-cpape.CCosto_Destino AT ROW 2.08 COL 11 COLON-ALIGNED WIDGET-ID 2
          LABEL "Destino"
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
     x-NomCco AT ROW 2.08 COL 16 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     ac-cpape.Usuario AT ROW 2.08 COL 87 COLON-ALIGNED WIDGET-ID 10
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ac-cpape.Responsable_Destino AT ROW 2.88 COL 11 COLON-ALIGNED WIDGET-ID 8
          LABEL "Responsable"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     x-NomPer AT ROW 2.88 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     ac-cpape.Observaciones AT ROW 3.69 COL 13 NO-LABEL WIDGET-ID 12
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 70 BY 3
     "Observaciones:" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 3.96 COL 2 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.ac-cpape
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DPAPE T "SHARED" ? INTEGRAL ac-dpape
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
         HEIGHT             = 8.12
         WIDTH              = 103.72.
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

/* SETTINGS FOR FILL-IN ac-cpape.CCosto_Destino IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ac-cpape.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ac-cpape.NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ac-cpape.NroSer IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN ac-cpape.Responsable_Destino IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ac-cpape.Usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN x-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCco IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPer IN FRAME F-Main
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

&Scoped-define SELF-NAME ac-cpape.CCosto_Destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ac-cpape.CCosto_Destino V-table-Win
ON LEAVE OF ac-cpape.CCosto_Destino IN FRAME F-Main /* Destino */
DO:
    x-NomCco:SCREEN-VALUE = ''.
    FIND ac-tabl WHERE ac-tabl.codcia = s-codcia
        AND ac-tabl.ctabla = 'CC'
        AND ac-tabl.ccodigo = ac-cpape.CCosto_Destino:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE ac-tabl THEN x-NomCco:SCREEN-VALUE = AC-TABL.cDescri.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ac-cpape.CCosto_Destino V-table-Win
ON LEFT-MOUSE-DBLCLICK OF ac-cpape.CCosto_Destino IN FRAME F-Main /* Destino */
OR F8 OF ac-cpape.Ccosto_destino
DO:
  ASSIGN
      input-var-1 = ''
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?.
  RUN act/c-ccosto ('Centro de Costo').
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
  APPLY 'entry':U TO ac-cpape.ccosto_destino.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ac-cpape.Responsable_Destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ac-cpape.Responsable_Destino V-table-Win
ON LEAVE OF ac-cpape.Responsable_Destino IN FRAME F-Main /* Responsable */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    ASSIGN
        SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '999999')
        NO-ERROR.
    x-NomPer:SCREEN-VALUE = ''.
    FIND pl-pers WHERE pl-pers.codcia = s-codcia
        AND pl-pers.codper = ac-cpape.Responsable_Destino:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN x-NomPer:SCREEN-VALUE = TRIM(pl-pers.patper) + ' ' +
                                                        TRIM(pl-pers.matper) + ', ' +
                                                        pl-pers.nomper.
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
  {src/adm/template/row-list.i "ac-cpape"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ac-cpape"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH T-DPAPE:
    DELETE T-DPAPE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH T-DPAPE:
    DELETE T-DPAPE.
END.
FOR EACH ac-dpape OF ac-cpape NO-LOCK:
    CREATE T-DPAPE.
    BUFFER-COPY ac-dpape TO T-DPAPE.
END.

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
  FIND FIRST AC-CORRE WHERE ac-corre.codcia = s-codcia
      AND ac-corre.coddiv = s-coddiv
      AND ac-corre.tipmov = s-tipmov
      AND ac-corre.nroser = s-nroser
      NO-LOCK NO-ERROR.
  IF ac-corre.flgest = NO THEN DO:
    MESSAGE 'Serie DESACTIVADA' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY
          ac-corre.nroser      @ ac-cpape.NroSer
          ac-corre.correlativo @ ac-cpape.NroDoc.
  END.
  RUN Borra-Temporal.
  RUN Procesa-Handle IN lh_handle('pagina2').

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
  DEF VAR x-item LIKE ac-dpape.ITEM.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      FIND FIRST AC-CORRE WHERE ac-corre.codcia = s-codcia
          AND ac-corre.coddiv = s-coddiv
          AND ac-corre.tipmov = s-tipmov
          AND ac-corre.nroser = s-nroser
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE ac-corre THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN
          ac-cpape.CodCia = s-codcia
          ac-cpape.CodDiv = s-coddiv
          ac-cpape.TipMov = s-tipmov
          ac-cpape.NroDoc = ac-corre.correlativo
          ac-cpape.NroSer = ac-corre.nroser
          ac-cpape.HorDoc = STRING(TIME, 'HH:MM').
      ASSIGN
          ac-corre.correlativo = ac-corre.correlativo + 1.
  END.
  ELSE DO:
      FOR EACH ac-dpape OF ac-cpape:
          FIND ac-parti OF ac-dpape EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE ac-parti THEN UNDO, RETURN 'ADM-ERROR'.
          DELETE ac-dpape.
          /* guardamos la ultima ubicacion del activo */
          {act/ultubi.i}
/*           ASSIGN                                                                                     */
/*               ac-parti.UbiAct = '@@'                                                                 */
/*               ac-parti.NroPap = ''.                                                                  */
/*           FOR EACH b-dpape OF ac-parti USE-INDEX Llave02 NO-LOCK,                                    */
/*               FIRST b-cpape OF b-dpape NO-LOCK WHERE b-cpape.flag <> 'A':                            */
/*               ASSIGN                                                                                 */
/*                   AC-PARTI.NroPap = STRING(b-dpape.nroser, '999') + STRING(b-dpape.nrodoc, '999999') */
/*                   AC-PARTI.UbiAct = b-cpape.CCosto_Destino.                                          */
/*           END.                                                                                       */
/*           RELEASE ac-parti.                                                                          */
      END.
  END.
  ASSIGN
      ac-cpape.Usuario = s-user-id.
  x-Item = 1.
  FOR EACH T-DPAPE BY T-DPAPE.ITEM:
      CREATE ac-dpape.
      BUFFER-COPY T-DPAPE TO ac-dpape
          ASSIGN
          ac-dpape.CodCia = ac-cpape.codcia
          ac-dpape.CodDiv = ac-cpape.coddiv
          ac-dpape.FchDoc = ac-cpape.FchDoc
          ac-dpape.HorDoc = ac-cpape.HorDoc
          ac-dpape.TipMov = ac-cpape.tipmov
          ac-dpape.NroSer = ac-cpape.nroser
          ac-dpape.NroDoc = ac-cpape.nrodoc
          ac-dpape.ITEM   = x-Item.
      x-Item = x-Item + 1.
      FIND ac-parti OF ac-dpape EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE ac-parti THEN UNDO, RETURN 'ADM-ERROR'.
      /* guardamos la ultima ubicacion del activo */
      {act/ultubi.i}
/*       ASSIGN                                                                                     */
/*           ac-parti.UbiAct = '@@'                                                                 */
/*           ac-parti.NroPap = ''.                                                                  */
/*       FOR EACH b-dpape OF ac-parti USE-INDEX Llave02 NO-LOCK,                                    */
/*           FIRST b-cpape OF b-dpape NO-LOCK WHERE b-cpape.flag <> 'A':                            */
/*           ASSIGN                                                                                 */
/*               AC-PARTI.NroPap = STRING(b-dpape.nroser, '999') + STRING(b-dpape.nrodoc, '999999') */
/*               AC-PARTI.UbiAct = b-cpape.CCosto_Destino.                                          */
/*       END.                                                                                       */
/*       RELEASE ac-parti.                                                                          */
  END.
  RELEASE ac-corre.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle('pagina1').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       Tiene que borrarse obligatoriamente el detalle
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF ac-cpape.flag = 'A' THEN RETURN 'ADM-ERROR'.
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      {act/chequea-item.i}
      FOR EACH ac-dpape OF ac-cpape:
          FIND ac-parti OF ac-dpape EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE ac-parti THEN UNDO, RETURN 'ADM-ERROR'.
          DELETE ac-dpape.
          /* guardamos la ultima ubicacion del activo */
          {act/ultubi.i}
      END.
      FIND CURRENT ac-cpape EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE ac-cpape THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN
          ac-cpape.flag = 'A'.
      FIND CURRENT ac-cpape NO-LOCK NO-ERROR.
  END.

  /* Dispatch standard ADM method.                             */
/*   RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle('pagina1').
  RUN local-display-fields.

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
  IF AVAILABLE ac-cpape THEN DO WITH FRAME {&FRAME-NAME}:
      x-NomCco:SCREEN-VALUE = ''.
      FIND ac-tabl WHERE ac-tabl.codcia = s-codcia
          AND ac-tabl.ctabla = 'CC'
          AND ac-tabl.ccodigo = ac-cpape.CCosto_Destino
          NO-LOCK NO-ERROR.
      IF AVAILABLE ac-tabl THEN x-NomCco:SCREEN-VALUE = AC-TABL.cDescri.
      x-NomPer:SCREEN-VALUE = ''.
      FIND pl-pers WHERE pl-pers.codcia = s-codcia
          AND pl-pers.codper = ac-cpape.Responsable_Destino
          NO-LOCK NO-ERROR.
      IF AVAILABLE pl-pers THEN x-NomPer:SCREEN-VALUE = TRIM(pl-pers.patper) + ' ' +
                                                          TRIM(pl-pers.matper) + ', ' +
                                                          pl-pers.nomper.
      CASE ac-cpape.flag:
          WHEN 'A' THEN x-Estado:SCREEN-VALUE = 'ANULADO'.
          OTHERWISE x-Estado:SCREEN-VALUE = 'EMITIDO'.
      END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'act/rbact.prl'.
  RB-REPORT-NAME = 'Ingreso del Activo'.
  RB-INCLUDE-RECORDS = 'O'.
  RB-FILTER = "ac-cpape.codcia = " + STRING(ac-cpape.codcia) +
      " AND ac-cpape.coddiv = '" + ac-cpape.coddiv + "'" +
      " AND ac-cpape.tipmov = '" + ac-cpape.tipmov + "'" +
      " AND ac-cpape.nroser = " + STRING(ac-cpape.nroser) +
      " AND ac-cpape.nrodoc = " + STRING(ac-cpape.nrodoc).
  RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.

  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).


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
  RUN Procesa-Handle IN lh_handle('pagina1').

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
  {src/adm/template/snd-list.i "ac-cpape"}

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
    FIND ac-tabl WHERE ac-tabl.codcia = s-codcia
        AND ac-tabl.ctabla = 'CC'
        AND ac-tabl.ccodigo = ac-cpape.CCosto_Destino:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ac-tabl THEN DO:
        MESSAGE 'Destino (centro de costo) NO registrado'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    FIND pl-pers WHERE pl-pers.codcia = s-codcia
        AND pl-pers.codper = ac-cpape.Responsable_Destino:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN DO:
        MESSAGE 'Responsable_Destino (código del personal) NO registrado'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
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
MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
RETURN 'ADM-ERROR'.
IF ac-cpape.flag = 'A' THEN RETURN 'ADM-ERROR'.
RUN Carga-Temporal.
RUN Procesa-Handle IN lh_handle('pagina2').
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

