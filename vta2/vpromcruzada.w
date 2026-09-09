&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Tabla FOR VtaCTabla.
DEFINE TEMP-TABLE T-DTabla NO-UNDO LIKE VtaDTabla.



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
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-Tabla AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR s-adm-copiar AS LOG INIT NO NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES VtaCTabla
&Scoped-define FIRST-EXTERNAL-TABLE VtaCTabla


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCTabla.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaCTabla.Estado VtaCTabla.Descripcion ~
VtaCTabla.FechaInicial VtaCTabla.FechaFinal VtaCTabla.Libre_d01 ~
VtaCTabla.Libre_c01 
&Scoped-define ENABLED-TABLES VtaCTabla
&Scoped-define FIRST-ENABLED-TABLE VtaCTabla
&Scoped-Define DISPLAYED-FIELDS VtaCTabla.Llave VtaCTabla.Estado ~
VtaCTabla.Descripcion VtaCTabla.FechaInicial VtaCTabla.FechaFinal ~
VtaCTabla.UsrCreacion VtaCTabla.FchCreacion VtaCTabla.UsrModificacion ~
VtaCTabla.FchModificacion VtaCTabla.Libre_d01 VtaCTabla.Libre_c01 
&Scoped-define DISPLAYED-TABLES VtaCTabla
&Scoped-define FIRST-DISPLAYED-TABLE VtaCTabla


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

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     VtaCTabla.Llave AT ROW 1.19 COL 13 COLON-ALIGNED WIDGET-ID 12
          LABEL "Promoción"
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     VtaCTabla.Estado AT ROW 1.19 COL 32 NO-LABEL WIDGET-ID 18
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Activa", "A":U,
"Inactiva", "I":U
          SIZE 20 BY .81
     VtaCTabla.Descripcion AT ROW 2.15 COL 13 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     VtaCTabla.FechaInicial AT ROW 3.12 COL 13 COLON-ALIGNED WIDGET-ID 10
          LABEL "Válida desde"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaCTabla.FechaFinal AT ROW 3.12 COL 31 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaCTabla.UsrCreacion AT ROW 3.15 COL 56 COLON-ALIGNED WIDGET-ID 14
          LABEL "Creado por"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaCTabla.FchCreacion AT ROW 3.15 COL 69 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     VtaCTabla.UsrModificacion AT ROW 4.12 COL 56 COLON-ALIGNED WIDGET-ID 16
          LABEL "Modificado por"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaCTabla.FchModificacion AT ROW 4.12 COL 69 COLON-ALIGNED NO-LABEL WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     VtaCTabla.Libre_d01 AT ROW 4.23 COL 13 COLON-ALIGNED WIDGET-ID 22
          LABEL "Por la compra de" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     VtaCTabla.Libre_c01 AT ROW 4.23 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 24
          VIEW-AS COMBO-BOX INNER-LINES 2
          LIST-ITEMS "Unidades","Soles" 
          DROP-DOWN-LIST
          SIZE 10 BY 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.VtaCTabla
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-Tabla B "?" ? INTEGRAL VtaCTabla
      TABLE: T-DTabla T "?" NO-UNDO INTEGRAL VtaDTabla
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
         HEIGHT             = 6.88
         WIDTH              = 99.29.
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

/* SETTINGS FOR FILL-IN VtaCTabla.FchCreacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCTabla.FchModificacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCTabla.FechaInicial IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCTabla.Libre_d01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCTabla.Llave IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaCTabla.UsrCreacion IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaCTabla.UsrModificacion IN FRAME F-Main
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

&Scoped-define SELF-NAME VtaCTabla.Llave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCTabla.Llave V-table-Win
ON LEAVE OF VtaCTabla.Llave IN FRAME F-Main /* Promoción */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
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
  {src/adm/template/row-list.i "VtaCTabla"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCTabla"}

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
      ASSIGN
          VtaCTabla.Estado:SCREEN-VALUE = "I"
          VtaCTabla.Libre_c01:SCREEN-VALUE = "Soles".
      DISPLAY
          TODAY @ VtaCTabla.FechaFinal 
          TODAY @ VtaCTabla.FechaInicial.
      s-adm-copiar = NO.
  END.
  RUN Procesa-Handle IN lh_handle ('Disable-Update').

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
      VtaCTabla.CodCia = s-codcia
      VtaCTabla.Tabla = s-tabla.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = "YES" THEN
      ASSIGN
      VtaCTabla.FchCreacion = TODAY
      VtaCTabla.UsrCreacion = s-user-id
      VtaCTabla.Libre_c02 = "OR"
      VtaCTabla.Libre_c03 = "OR"
      VtaCTabla.Libre_c04 = "OR"
      VtaCTabla.Libre_c05 = "OR".
  ELSE ASSIGN
      VtaCTabla.FchModificacion = TODAY
      VtaCTabla.UsrModificacion = s-user-id.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' AND s-adm-copiar = YES THEN DO:
      FOR EACH T-DTABLA:
          CREATE VtaDTabla.
          BUFFER-COPY T-DTABLA
              TO VtaDTabla
              ASSIGN
              VtaDTabla.CodCia = VtaCTabla.CodCia
              VtaDTabla.Tabla  = VtaCTabla.Tabla
              VtaDTabla.Llave  = VtaCTabla.Llave.
      END.
      RUN Procesa-Handle IN lh_handle ('Open-Browses').
  END.
  RUN lib/logtabla ('vtactabla',
                    VtaCTabla.Tabla + ',' + VtaCTabla.Llave + ',' + 
                    STRING(VtaCTabla.FechaFinal) + ',' + STRING(VtaCTabla.FechaInicial) + ',' +
                    STRING(VtaCTabla.Libre_d01) + ',' + VtaCTabla.Libre_c01 + ',' +
                    STRING(VtaCTabla.Estado) + ',' + STRING(VtaCTabla.Libre_l01),
                    'WRITE').

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
  RUN Procesa-Handle IN lh_handle ('Enable-Update').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          VtaCTabla.Estado:SCREEN-VALUE = "I"
          VtaCTabla.Libre_c01:SCREEN-VALUE = "Soles".
      DISPLAY
          ""    @ VtaCTabla.Llave
          TODAY @ VtaCTabla.FechaFinal 
          TODAY @ VtaCTabla.FechaInicial.
      s-adm-copiar = YES.
      EMPTY TEMP-TABLE T-DTabla.
      FOR EACH VtaDTabla OF VtaCTabla WHERE VtaDTabla.Tipo = "M" NO-LOCK,
          EACH Almmmatg WHERE Almmmatg.CodCia = VtaDTabla.CodCia
          AND Almmmatg.codmat = VtaDTabla.LlaveDetalle NO-LOCK:
          CREATE T-DTabla.
          BUFFER-COPY Vtadtabla TO T-DTabla.
      END.
      FOR EACH VtaDTabla OF VtaCTabla WHERE VtaDTabla.Tipo = "P" NO-LOCK,
          EACH gn-prov WHERE gn-prov.CodPro = VtaDTabla.LlaveDetalle
          AND gn-prov.CodCia = pv-codcia NO-LOCK:
          CREATE T-DTabla.
          BUFFER-COPY Vtadtabla TO T-DTabla.
      END.
      FOR EACH VtaDTabla OF VtaCTabla WHERE VtaDTabla.Tipo = "L" NO-LOCK,
          FIRST Almtfami WHERE Almtfami.CodCia = VtaDTabla.CodCia
          AND Almtfami.codfam = VtaDTabla.LlaveDetalle NO-LOCK:
          CREATE T-DTabla.
          BUFFER-COPY Vtadtabla TO T-DTabla.
      END.
      FOR EACH VtaDTabla OF VtaCTabla WHERE VtaDTabla.Tipo = "D" NO-LOCK,
          EACH GN-DIVI WHERE GN-DIVI.CodCia = VtaDTabla.CodCia
          AND GN-DIVI.CodDiv = VtaDTabla.LlaveDetalle NO-LOCK:
          CREATE T-DTabla.
          BUFFER-COPY Vtadtabla TO T-DTabla.
      END.
      FOR EACH VtaDTabla OF VtaCTabla WHERE VtaDTabla.Tipo = "OF" NO-LOCK,
          EACH Almmmatg WHERE Almmmatg.CodCia = VtaDTabla.CodCia
          AND Almmmatg.codmat = VtaDTabla.LlaveDetalle NO-LOCK:
          CREATE T-DTabla.
          BUFFER-COPY Vtadtabla TO T-DTabla.
      END.
      FOR EACH VtaDTabla OF VtaCTabla WHERE VtaDTabla.Tipo = "XL" NO-LOCK,
          FIRST Almtfami WHERE Almtfami.CodCia = VtaDTabla.CodCia
          AND Almtfami.codfam = VtaDTabla.LlaveDetalle NO-LOCK:
          CREATE T-DTabla.
          BUFFER-COPY Vtadtabla TO T-DTabla.
      END.
      FOR EACH VtaDTabla OF VtaCTabla WHERE VtaDTabla.Tipo = "XM" NO-LOCK,
          EACH Almmmatg WHERE Almmmatg.CodCia = VtaDTabla.CodCia
          AND Almmmatg.codmat = VtaDTabla.LlaveDetalle NO-LOCK:
          CREATE T-DTabla.
          BUFFER-COPY Vtadtabla TO T-DTabla.
      END.
      FOR EACH VtaDTabla OF VtaCTabla WHERE VtaDTabla.Tipo = "TEXT" NO-LOCK,
          EACH Almmmatg WHERE Almmmatg.CodCia = VtaDTabla.CodCia
          AND Almmmatg.codmat = VtaDTabla.LlaveDetalle NO-LOCK:
          CREATE T-DTabla.
          BUFFER-COPY Vtadtabla TO T-DTabla.
      END.
  END.
  RUN Procesa-Handle IN lh_handle ('Disable-Update').


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
  DEF VAR x-Correlativo AS INT INIT 1 NO-UNDO.
  /*DEF BUFFER b-tabla FOR vtactabla.*/

  FIND LAST b-tabla WHERE b-tabla.codcia = s-codcia
      AND b-tabla.tabla = s-tabla
      NO-LOCK NO-ERROR.
  IF AVAILABLE b-tabla THEN DO:
      ASSIGN
          x-Correlativo = INTEGER(b-tabla.llave) + 1 NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN "ADM-ERROR".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      VtaCTabla.CodCia = s-codcia
      VtaCTabla.Tabla = s-tabla
      VtaCTabla.Llave = STRING(x-Correlativo, '999999999').


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
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
  RETURN 'ADM-ERROR'.

  FOR EACH Vtadtabla OF Vtactabla:
      DELETE Vtadtabla.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  RUN Procesa-Handle IN lh_handle ('Enable-Update').

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
  {src/adm/template/snd-list.i "VtaCTabla"}

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
    IF INPUT VtaCTabla.FechaInicial > INPUT VtaCTabla.FechaFinal THEN DO:
        MESSAGE "Ingrese correctamente las fechas" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO VtaCTabla.FechaInicial.
        RETURN "ADM-ERROR".
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

RUN Procesa-Handle IN lh_handle ('Disable-Update').
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

