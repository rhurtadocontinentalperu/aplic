&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tlg-dincid-chk NO-UNDO LIKE lg-dincid-chk.
DEFINE TEMP-TABLE tReporte NO-UNDO LIKE w-report.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR s-Task-No AS INTE NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES lg-cincid-chk
&Scoped-define FIRST-EXTERNAL-TABLE lg-cincid-chk


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR lg-cincid-chk.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS lg-cincid-chk.Cerrado lg-cincid-chk.Fecha ~
lg-cincid-chk.CodAlm lg-cincid-chk.Hora lg-cincid-chk.Usuario 
&Scoped-define ENABLED-TABLES lg-cincid-chk
&Scoped-define FIRST-ENABLED-TABLE lg-cincid-chk
&Scoped-Define DISPLAYED-FIELDS lg-cincid-chk.NroDoc lg-cincid-chk.Cerrado ~
lg-cincid-chk.Fecha lg-cincid-chk.CodAlm lg-cincid-chk.Hora ~
lg-cincid-chk.Usuario 
&Scoped-define DISPLAYED-TABLES lg-cincid-chk
&Scoped-define FIRST-DISPLAYED-TABLE lg-cincid-chk
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado FILL-IN-NomAlm 

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
DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     lg-cincid-chk.NroDoc AT ROW 1.27 COL 9 COLON-ALIGNED WIDGET-ID 4
          LABEL "Correlativo"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     lg-cincid-chk.Cerrado AT ROW 1.27 COL 23 WIDGET-ID 18
          LABEL "Cerrado"
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .77
     FILL-IN-Estado AT ROW 1.27 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     lg-cincid-chk.Fecha AT ROW 1.27 COL 69 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     lg-cincid-chk.CodAlm AT ROW 2.08 COL 9 COLON-ALIGNED WIDGET-ID 10
          LABEL "Almacén"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     FILL-IN-NomAlm AT ROW 2.08 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     lg-cincid-chk.Hora AT ROW 2.08 COL 69 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     lg-cincid-chk.Usuario AT ROW 2.88 COL 69 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.lg-cincid-chk
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: tlg-dincid-chk T "?" NO-UNDO INTEGRAL lg-dincid-chk
      TABLE: tReporte T "?" NO-UNDO INTEGRAL w-report
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
         HEIGHT             = 3.96
         WIDTH              = 86.86.
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

/* SETTINGS FOR TOGGLE-BOX lg-cincid-chk.Cerrado IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN lg-cincid-chk.CodAlm IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lg-cincid-chk.NroDoc IN FRAME F-Main
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

&Scoped-define SELF-NAME lg-cincid-chk.CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-cincid-chk.CodAlm V-table-Win
ON LEAVE OF lg-cincid-chk.CodAlm IN FRAME F-Main /* Almacén */
DO:
    FIND Almacen WHERE Almacen.codcia = s-codcia 
        AND Almacen.codalm = SELF:SCREEN-VALUE
        AND Almacen.coddiv = s-coddiv
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
        MESSAGE 'Almacén no válido' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF Almacen.Campo-C[9] = "I" THEN DO:
        MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY Almacen.Descripcion @ FILL-IN-NomAlm.
  
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
  {src/adm/template/row-list.i "lg-cincid-chk"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "lg-cincid-chk"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Reporte V-table-Win 
PROCEDURE Borra-Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no:
      DELETE w-report.
  END.
  RELEASE w-report.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Temporal V-table-Win 
PROCEDURE Captura-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER TABLE FOR tlg-dincid-chk.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reporte V-table-Win 
PROCEDURE Carga-Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Acumulamos por artículo e incidencia */
  EMPTY TEMP-TABLE tReporte.
  FOR EACH lg-dincid-chk OF lg-cincid-chk NO-LOCK, FIRST Almmmatg OF lg-dincid-chk NO-LOCK:
      FIND tReporte WHERE tReporte.Campo-C[1] = lg-dincid-chk.codmat
          AND tReporte.Campo-C[4] = lg-dincid-chk.incidencia
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE tReporte THEN CREATE tReporte.
      ASSIGN
          tReporte.Campo-C[1] = lg-dincid-chk.codmat
          tReporte.Campo-C[2] = almmmatg.desmat
          tReporte.Campo-C[3] = almmmatg.undstk
          tReporte.Campo-F[1] = tReporte.Campo-F[1] + lg-dincid-chk.cantidad
          tReporte.Campo-C[4] = lg-dincid-chk.incidencia
          .
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = lg-cincid-chk.CodAlm
          AND Almmmate.codmat = lg-dincid-chk.codmat
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmate THEN DO:
          tReporte.Campo-C[5] = Almmmate.CodUbi.
          FIND Almtubic WHERE almtubic.CodCia = s-codcia 
              AND almtubic.CodAlm = Almmmate.codalm
              AND almtubic.CodUbi = Almmmate.codubi
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtubic THEN DO:
              ASSIGN
                  tReporte.Campo-C[6] = almtubic.CodZona
                  tReporte.Campo-C[8] = almtubic.CodUbi
                  tReporte.Campo-C[9] = almtubic.DesUbi.
              FIND AlmtZona WHERE AlmtZona.CodCia = s-codcia 
                  AND AlmtZona.CodAlm = Almmmate.codalm
                  AND AlmtZona.CodZona = almtubic.CodZona
                  NO-LOCK NO-ERROR.
              IF AVAILABLE AlmtZona THEN tReporte.Campo-C[7] = AlmtZona.DesZona.
          END.
      END.
      FIND lg-tabla WHERE lg-tabla.CodCia = s-codcia 
          AND lg-tabla.Tabla = "CFG_INCID_CHK"
          AND lg-tabla.Codigo = lg-dincid-chk.incidencia
          NO-LOCK NO-ERROR.
      IF AVAILABLE lg-tabla THEN tReporte.Campo-C[10] = lg-tabla.Nombre.

  END.
  /* Cargamos tabla de impresión */
  s-Task-No = 0.
  REPEAT:
      s-Task-No = RANDOM(0,999999).
      IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                      AND w-report.llave-c = s-user-id NO-LOCK)
          THEN DO:
          CREATE w-report.
          ASSIGN
              w-report.task-no = s-task-no
              w-report.llave-c = "BORRAR".
          LEAVE.
      END.
  END.
  FOR EACH tReporte NO-LOCK:
      CREATE w-report.
      BUFFER-COPY tReporte TO w-report ASSIGN w-report.task-no = s-task-no.
  END.
  FIND w-report WHERE w-report.task-no = s-task-no
      AND w-report.llave-c = "BORRAR" EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF AVAILABLE w-report THEN DELETE w-report.

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

EMPTY TEMP-TABLE tlg-dincid-chk.
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = "NO" THEN DO:
    FOR EACH lg-dincid-chk OF lg-cincid-chk NO-LOCK:
        CREATE tlg-dincid-chk.
        BUFFER-COPY lg-dincid-chk TO tlg-dincid-chk.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importa-Temporal V-table-Win 
PROCEDURE Importa-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER TABLE FOR tlg-dincid-chk.

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
      lg-cincid-chk.Fecha = TODAY
      lg-cincid-chk.Hora = STRING(TIME,'HH:MM:SS')
      lg-cincid-chk.Usuario = s-user-id
      .
  /* Actualizamos detalle */
  RUN Procesa-Handle IN lh_handle ('Captura-Temporal').
  FOR EACH lg-dincid-chk OF lg-cincid-chk EXCLUSIVE-LOCK:
      DELETE lg-dincid-chk.
  END.
  DEF VAR iOrden AS INTE INIT 1 NO-UNDO.
  FOR EACH tlg-dincid-chk NO-LOCK BY tlg-dincid-chk.Orden:
      CREATE lg-dincid-chk.
      BUFFER-COPY tlg-dincid-chk TO lg-dincid-chk
          ASSIGN
          lg-dincid-chk.CodCia = lg-cincid-chk.CodCia 
          lg-dincid-chk.CodDiv = lg-cincid-chk.CodDiv 
          lg-dincid-chk.NroDoc = lg-cincid-chk.NroDoc
          lg-dincid-chk.Orden  = iOrden
          .
      iOrden = iOrden + 1.
  END.
  IF lg-cincid-chk.Cerrado = YES THEN lg-cincid-chk.FlgEst = "C".
  RUN Procesa-handle IN lh_handle ('Pagina1').

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
  RUN Procesa-handle IN lh_handle ('Pagina1').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      lg-cincid-chk.CodCia = s-codcia
      lg-cincid-chk.CodDiv = s-coddiv
      lg-cincid-chk.NroDoc = NEXT-VALUE(id-lg-incid-chk)
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF lg-cincid-chk.Cerrado = YES THEN DO:
      MESSAGE "No se puede anular una incidencia cerrada" VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  FIND CURRENT lg-cincid-chk EXCLUSIVE-LOCK NO-WAIT.
  IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE 'Registro en uso por otro usuario:' SKIP
          ERROR-STATUS:GET-MESSAGE(1)
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      lg-cincid-chk.FlgEst = "A".
  FIND CURRENT lg-cincid-chk NO-LOCK NO-ERROR.
   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */



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
  IF AVAILABLE lg-cincid-chk THEN DO WITH FRAME {&FRAME-NAME}:
      FILL-IN-Estado:SCREEN-VALUE = "".
      IF lg-cincid-chk.flgest = "A"  THEN FILL-IN-Estado:SCREEN-VALUE = "ANULADO".

      FILL-IN-NomAlm:SCREEN-VALUE = "".
      FIND Almacen WHERE ALmacen.codcia = s-codcia 
          AND Almacen.codalm = lg-cincid-chk.CodAlm
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN FILL-IN-NomAlm:SCREEN-VALUE = Almacen.Descripcion.
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
  DISABLE 
      lg-cincid-chk.Fecha 
      lg-cincid-chk.Hora 
      lg-cincid-chk.NroDoc 
      lg-cincid-chk.Usuario
      WITH FRAME {&FRAME-NAME}.
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle ('Pagina2').

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
  /* Solo se imprimen cerrados */
  IF NOT AVAILABLE lg-cincid-chk OR lg-cincid-chk.Cerrado = NO THEN DO:
      MESSAGE 'Solo se pueden imprimir incidencias cerradas'
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Carga-Reporte.

  DEFINE VAR p-pagina-final AS INTEGER.
  DEFINE VAR p-pagina-inicial AS INTEGER.
  DEFINE VAR p-salida-impresion AS INTEGER.
  DEFINE VAR p-printer-name AS CHAR.
  DEFINE VAR p-printer-port AS CHARACTER.
  DEFINE VAR p-print-file AS CHAR.
  DEFINE VAR p-nro-copias AS INTEGER.
  DEFINE VAR p-orientacion AS INTEGER.

  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR.            /* Otros parametros */

  /* capturamos ruta inicial */
  GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  ASSIGN
      RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "logis/rblogis.prl"
      RB-REPORT-NAME = "Cargo Incidencias de Chequeo"
      RB-INCLUDE-RECORDS = "O".

  ASSIGN
      RB-FILTER = "w-report.task-no = " + STRING(s-task-no).

  RUN lib/_Imprime3 (p-pagina-final,
                     p-pagina-inicial,
                     p-salida-impresion,
                     p-printer-name,
                     p-printer-port,
                     p-print-file,
                     p-nro-copias,
                     p-orientacion,
                     RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

  /*RUN Borra-Reporte.*/

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
  {src/adm/template/snd-list.i "lg-cincid-chk"}

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
    /* Almacén */
    FIND Almacen WHERE Almacen.codcia = s-codcia 
        AND Almacen.codalm = INPUT lg-cincid-chk.CodAlm 
        AND Almacen.coddiv = s-coddiv
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
        MESSAGE 'Almacén no válido' VIEW-AS ALERT-BOX WARNING.
        lg-cincid-chk.CodAlm:SCREEN-VALUE = ''.
        APPLY 'ENTRY':U TO lg-cincid-chk.CodAlm.
        RETURN 'ADM-ERROR'.
    END.
    IF Almacen.Campo-C[9] = "I" THEN DO:
        MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX WARNING.
        lg-cincid-chk.CodAlm:SCREEN-VALUE = ''.
        APPLY 'ENTRY':U TO lg-cincid-chk.CodAlm.
        RETURN 'ADM-ERROR'.
    END.

    IF INPUT lg-cincid-chk.Cerrado = YES THEN DO:
        MESSAGE 'Se procede a CERRAR la incidencia?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN 'ADM-ERROR'.
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

IF lg-cincid-chk.Cerrado = YES THEN DO:
    MESSAGE 'Incidencia CERRADA' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
IF lg-cincid-chk.FlgEst = "A" THEN DO:
    MESSAGE 'Incidencia ANULADA' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

