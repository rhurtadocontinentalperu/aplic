&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.



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
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-NroSer AS INTE.
DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-CodAlm AS CHAR.    /* OJO */

DEF VAR pMensaje AS CHAR NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacCPedi.CodRef FacCPedi.NroRef ~
FacCPedi.CodCli FacCPedi.NomCli FacCPedi.DirCli FacCPedi.Glosa 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.CodRef FacCPedi.usuario FacCPedi.NroRef FacCPedi.CodCli ~
FacCPedi.NomCli FacCPedi.DirCli FacCPedi.Glosa 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado 

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
DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "ESTADO" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.27 COL 15 COLON-ALIGNED WIDGET-ID 58
          LABEL "Número" FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     F-Estado AT ROW 1.27 COL 39 COLON-ALIGNED WIDGET-ID 114
     FacCPedi.FchPed AT ROW 1.27 COL 109.14 COLON-ALIGNED WIDGET-ID 46
          LABEL "Fecha de Emisión"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodRef AT ROW 2.08 COL 15 COLON-ALIGNED WIDGET-ID 132
          LABEL "Tipo Comprobante" FORMAT "x(3)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "FACTURA","FAC",
                     "BOLETA","BOL"
          DROP-DOWN-LIST
          SIZE 12 BY 1
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.usuario AT ROW 2.08 COL 109 COLON-ALIGNED WIDGET-ID 66
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.NroRef AT ROW 2.88 COL 15 COLON-ALIGNED WIDGET-ID 140
          LABEL "Nro. Comprobante"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.CodCli AT ROW 3.69 COL 15 COLON-ALIGNED WIDGET-ID 38
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FacCPedi.NomCli AT ROW 4.5 COL 15 COLON-ALIGNED WIDGET-ID 136
          VIEW-AS FILL-IN 
          SIZE 72.86 BY .81
     FacCPedi.DirCli AT ROW 5.31 COL 15 COLON-ALIGNED WIDGET-ID 138
          VIEW-AS FILL-IN 
          SIZE 72.86 BY .81
     FacCPedi.Glosa AT ROW 6.12 COL 15 COLON-ALIGNED WIDGET-ID 110
          LABEL "Glosa" FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 73 BY .81
          BGCOLOR 11 FGCOLOR 0 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.FacCPedi
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 6.81
         WIDTH              = 125.29.
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
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX FacCPedi.CodRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME FacCPedi.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.NroRef V-table-Win
ON LEAVE OF FacCPedi.NroRef IN FRAME F-Main /* Nro. Comprobante */
DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
  FIND Ccbcdocu WHERE CcbCDocu.CodCia = s-CodCia
      AND CcbCDocu.CodDiv = s-CodDiv
      AND CcbCDocu.CodDoc = FacCPedi.CodRef:SCREEN-VALUE 
      AND CcbCDocu.NroDoc = FacCPedi.NroRef:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbCDocu OR CcbCDocu.FlgEst = "A" THEN DO:
      MESSAGE "Comprobante NO válido" VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  IF CAN-FIND(FacCPedi WHERE FacCPedi.CodCia = s-CodCia 
              AND FacCPedi.CodDiv = s-CodDiv
              AND FacCPedi.CodDoc = s-CodDoc
              AND FacCPedi.CodRef = FacCPedi.CodRef:SCREEN-VALUE 
              AND FacCPedi.NroRef = FacCPedi.NroRef:SCREEN-VALUE 
              AND FacCPedi.FlgEst <> "A" NO-LOCK)
      THEN DO:
      MESSAGE 'El Comprobante YA fue registrado en un Retiro de Mercadería anterior'
          VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  DISPLAY 
      Ccbcdocu.CodCli @ FacCPedi.CodCli 
      Ccbcdocu.NomCli @ FacCPedi.NomCli
      Ccbcdocu.DirCli @ FacCPedi.DirCli 
      WITH FRAME {&FRAME-NAME}.
  ASSIGN
      s-CodAlm = FacCPedi.CodAlm.   /* OJO */
  /* Pintamos los ITEMs sugeridos */
  RUN Serie-Sugerida.
  RUN Procesa-Handle IN lh_handle ('Browse').
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
  {src/adm/template/row-list.i "FacCPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedi"}

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

EMPTY TEMP-TABLE ITEM.

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

EMPTY TEMP-TABLE ITEM.
FOR EACH Facdpedi OF Faccpedi NO-LOCK:
    CREATE ITEM.
    BUFFER-COPY Facdpedi TO ITEM.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Delete-Items V-table-Win 
PROCEDURE Delete-Items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Eliminamos Detalle */
    FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = Faccpedi.codcia AND
        FacDPedi.CodDiv = Faccpedi.coddiv AND
        FacDPedi.CodDoc = Faccpedi.coddoc AND
        FacDPedi.NroPed = Faccpedi.nroped:
        {lib/lock-genericov3.i ~
            &Tabla="B-DPEDI" ~
            &Condicion="ROWID(B-DPEDI) = ROWID(FacDPedi)" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TippoError="UNDO PRINCIPAL, RETURN 'ADM-ERROR'"}
        DELETE B-DPEDI.            
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
      MESSAGE 'La serie' s-NroSer 'NO existe' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ FacCPedi.NroPed
          TODAY @ FacCPedi.FchPed.
      ASSIGN
          FacCPedi.CodRef:SCREEN-VALUE = "BOL".
      RUN Borra-Temporal.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').

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
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
      ASSIGN 
          FacCPedi.CodCia = S-CODCIA
          FacCPedi.CodDiv = S-CODDIV
          FacCPedi.CodDoc = s-coddoc 
          FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"99999999")
          FacCPedi.FchPed = TODAY 
          FacCPedi.Hora   = STRING(TIME,"HH:MM:SS")
          FacCPedi.FlgEst = "P"     /* POR ENTREGAR */
          FacCPedi.CodAlm = s-CodAlm
          NO-ERROR.
      IF ERROR-STATUS:ERROR = YES THEN DO:
          {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* NUEVA COTIZACION */
    ASSIGN
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM:SS").
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  ELSE DO:
      RUN Delete-Items.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      /* MODIFICANDO COTIZACION */
      ASSIGN                                                  
          FacCPedi.UsrAct = S-USER-ID
          Faccpedi.fecact = TODAY
          FacCPedi.HorAct = STRING(TIME,"HH:MM:SS").
  END.
  FOR EACH ITEM NO-LOCK BY ITEM.NroItm:
      /* Validamos antes de grabar */
      IF CAN-FIND(FIRST Facdpedi WHERE FacDPedi.CodCia = s-CodCia
                  AND FacDPedi.codmat = ITEM.CodMat 
                  AND FacDPedi.Libre_c01 = ITEM.Libre_c01   /* # Serie */
                  AND FacDPedi.CodDoc = s-CodDoc
                  AND FacDPedi.CodDiv = s-CodDiv
                  AND CAN-FIND(FIRST FacCPedi OF FacDPedi WHERE FacCpedi.FlgEst = "T" NO-LOCK)
                  NO-LOCK)
          THEN DO:
          pMensaje = "El código " + ITEM.CodMat + " con Nro. Serie " + ITEM.Libre_c01 + CHR(10) +
              "Ya está registrado en otro retiro de mercadería".
          UNDO, RETURN "ADM-ERROR".
      END.
      I-NITEM = I-NITEM + 1.
      CREATE FacDPedi.
      BUFFER-COPY ITEM 
          TO FacDPedi
          ASSIGN
              FacDPedi.CodCia = FacCPedi.CodCia
              FacDPedi.CodDiv = FacCPedi.CodDiv
              FacDPedi.coddoc = FacCPedi.coddoc
              FacDPedi.NroPed = FacCPedi.NroPed
              FacDPedi.FchPed = FacCPedi.FchPed
              FacDPedi.Hora   = FacCPedi.Hora 
              FacDPedi.FlgEst = FacCPedi.FlgEst
              FacDPedi.NroItm = I-NITEM.
  END.
  
  IF AVAILABLE FacCorre THEN RELEASE FacCorre.
  IF AVAILABLE FacDPedi THEN RELEASE FacDPedi.

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
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').

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

  /* Dispatch standard ADM method.                             */
/*   RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
  IF LOOKUP(FacCPedi.FlgEst,"P") = 0 THEN DO:
      MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE FacCPedi THEN UNDO, RETURN 'ADM-ERROR'.
      /* ************************************** */
      ASSIGN                 
          FacCPedi.UsrAprobacion = s-user-id
          FacCPedi.FchAprobacion = TODAY
          FacCPedi.FlgEst = 'A'
          FacCPedi.Glosa  = "ANULADO POR: " + TRIM (s-user-id) + " EL DIA: " + STRING(TODAY) + " " + STRING(TIME, 'HH:MM').
      FIND CURRENT FacCPedi NO-LOCK.
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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
  IF AVAILABLE Faccpedi THEN DO WITH FRAME {&FRAME-NAME}:
      CASE FacCPedi.FlgEst:
          WHEN "P" THEN DISPLAY "POR ENTREGAR" @ f-Estado.
          WHEN "C" THEN DISPLAY "ENTREGADO" @ f-Estado.
          WHEN "A" THEN DISPLAY "ANULADO" @ f-Estado.
      END CASE.
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
          FacCPedi.CodCli:SENSITIVE = NO
          FacCPedi.DirCli:SENSITIVE = NO
          FacCPedi.NomCli:SENSITIVE = NO
          .
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN
          ASSIGN
          FacCPedi.CodRef:SENSITIVE = NO
          FacCPedi.NroRef:SENSITIVE = NO
          .
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
  pMensaje = ''.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RUN Procesa-handle IN lh_handle ('browse').
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  {src/adm/template/snd-list.i "FacCPedi"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Serie-Sugerida V-table-Win 
PROCEDURE Serie-Sugerida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Solicitado AS DECI NO-UNDO.    
DEF VAR x-NroItm AS INTE INIT 0 NO-UNDO.

EMPTY TEMP-TABLE ITEM.
/* Solo va a barrer los productos que tengan control de serie y método FIFO */
FOR EACH Ccbddocu NO-LOCK WHERE CcbDDocu.CodCia = s-CodCia
        AND CcbDDocu.CodDoc = FacCPedi.CodRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        AND CcbDDocu.NroDoc = FacCPedi.NroRef:SCREEN-VALUE IN FRAME {&FRAME-NAME},
    FIRST CcbCDocu OF CcbDDocu NO-LOCK,
    FIRST Almmmatg OF Ccbddocu NO-LOCK WHERE CAPS(Almmmatg.RequiereSerialNr) = "SI":
    x-Solicitado = Ccbddocu.CanDes * Ccbddocu.Factor.   /* En unidades de stock */
    /* Cada fifommatg es el mismo código pero diferente # de serie */
    FOR EACH Fifommatg NO-LOCK WHERE fifommatg.CodCia = CcbDDocu.CodCia 
            AND fifommatg.CodMat = CcbDDocu.CodMat
        BY fifommatg.FchIng:    /* OJO */
        /* Por cada # de Serie Distribuimos, si tiene saldo */
        FOR EACH Fifommate NO-LOCK WHERE fifommate.CodCia = fifommatg.CodCia 
            AND fifommate.CodAlm = CcbCDocu.CodAlm
            AND fifommate.CodMat = fifommatg.CodMat 
            AND fifommate.SerialNumber = fifommatg.SerialNumber
            AND fifommate.StkAct > 0:
            /* Solo se puede atender si NO está en trámite */
            IF CAN-FIND(FIRST Facdpedi WHERE FacDPedi.CodCia = s-CodCia
                        AND FacDPedi.codmat = fifommatg.CodMat 
                        AND FacDPedi.Libre_c01 = fifommatg.SerialNumber     /* # Serie */
                        AND FacDPedi.CodDoc = s-CodDoc
                        AND FacDPedi.CodDiv = s-CodDiv
                        AND CAN-FIND(FIRST FacCPedi OF FacDPedi WHERE FacCpedi.FlgEst = "T" NO-LOCK)
                        NO-LOCK)
                THEN NEXT.
            /* Cubrimos la cantidad solicitada */
            x-NroItm = x-NroItm + 1.
            CREATE ITEM.
            ASSIGN
                ITEM.CodCia = s-CodCia
                ITEM.CodDiv = s-CodDiv
                ITEM.CodDoc = s-CodDoc
                ITEM.CodCli = CcbCDocu.CodCli
                ITEM.codmat = CcbDDocu.CodMat
                ITEM.AlmDes = CcbCDocu.CodAlm
                ITEM.CanPed = MINIMUM(x-Solicitado, fifommate.StkAct)
                ITEM.Factor = 1
                ITEM.Libre_c01 = fifommatg.SerialNumber
                ITEM.NroItm = x-NroItm
                ITEM.UndVta = Almmmatg.UndBas.
            /* Llevamos saldo */
            IF x-Solicitado <= 0 THEN LEAVE.
        END.
    END.
END.

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
    IF TRUE <> (FacCPedi.NroRef:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Ingrese el número de comprobante' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FacCPedi.NroRef.
        RETURN 'ADM-ERROR'.
    END.
    FIND Ccbcdocu WHERE CcbCDocu.CodCia = s-CodCia
        AND CcbCDocu.CodDiv = s-CodDiv
        AND CcbCDocu.CodDoc = FacCPedi.CodRef:SCREEN-VALUE 
        AND CcbCDocu.NroDoc = FacCPedi.NroRef:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbCDocu OR CcbCDocu.FlgEst = "A" THEN DO:
        MESSAGE "Comprobante NO válido" VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FacCPedi.NroRef.
        RETURN 'ADM-ERROR'.
    END.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        IF CAN-FIND(FacCPedi WHERE FacCPedi.CodCia = s-CodCia 
                    AND FacCPedi.CodDiv = s-CodDiv
                    AND FacCPedi.CodDoc = s-CodDoc
                    AND FacCPedi.CodRef = FacCPedi.CodRef:SCREEN-VALUE 
                    AND FacCPedi.NroRef = FacCPedi.NroRef:SCREEN-VALUE 
                    AND FacCPedi.FlgEst <> "A" NO-LOCK)
            THEN DO:
            MESSAGE 'El Comprobante YA fue registrado en un Retiro de Mercadería anterior'
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO FacCPedi.NroRef.
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

IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
/* ****************************************************************************** */
/* FILTROS DE MODIFICACION */
/* ****************************************************************************** */
IF LOOKUP(FacCPedi.FlgEst,"P") = 0 THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-CodAlm = FacCPedi.CodAlm.
RUN Carga-Temporal.
RUN Procesa-Handle IN lh_Handle ('Pagina2').
RUN Procesa-Handle IN lh_Handle ('browse').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

