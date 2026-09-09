&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
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

&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.
DEFINE SHARED VARIABLE S-NROSER   AS INT.
DEFINE SHARED VARIABLE S-PORIGV   LIKE ccbcdocu.porigv.
DEFINE SHARED VARIABLE s-TpoFac   AS CHAR.
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-CODCLI       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 

DEFINE BUFFER B-CDOCU FOR CcbCDocu.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN I-NroSer = FacCorre.NroSer.
FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE SHARED VARIABLE s-Sunat-Activo AS LOG.

/* DEFINE VAR x-nueva-arimetica-sunat-2021 AS LOG. */
/*                                                 */
/* x-nueva-arimetica-sunat-2021 = YES.             */

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
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.TpoCmb CcbCDocu.NomCli CcbCDocu.DirCli ~
CcbCDocu.RucCli CcbCDocu.Glosa CcbCDocu.CodMon CcbCDocu.CodRef ~
CcbCDocu.NroRef 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.TpoCmb CcbCDocu.NomCli CcbCDocu.DirCli ~
CcbCDocu.RucCli CcbCDocu.Glosa CcbCDocu.CodMon CcbCDocu.CodRef ~
CcbCDocu.NroRef 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado 

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
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FILL-IN-Estado AT ROW 1 COL 36 COLON-ALIGNED
     CcbCDocu.FchDoc AT ROW 1 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodCli AT ROW 1.96 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.TpoCmb AT ROW 1.96 COL 66 COLON-ALIGNED
          LABEL "Tpo. Cambio"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCDocu.NomCli AT ROW 2.92 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44 BY .81
     CcbCDocu.DirCli AT ROW 3.88 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     CcbCDocu.RucCli AT ROW 3.88 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.Glosa AT ROW 4.85 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     CcbCDocu.CodMon AT ROW 4.85 COL 68 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2
          SIZE 15 BY .77
     CcbCDocu.CodRef AT ROW 5.81 COL 11 COLON-ALIGNED
          LABEL "Referencia"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbCDocu.NroRef AT ROW 5.81 COL 17 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.85 COL 60
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.CcbCDocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
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
         HEIGHT             = 6.38
         WIDTH              = 93.86.
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

/* SETTINGS FOR FILL-IN CcbCDocu.CodRef IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
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
  {src/adm/template/row-list.i "CcbCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCDocu"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Documento V-table-Win 
PROCEDURE Borra-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH Ccbddocu OF Ccbcdocu:
    DELETE Ccbddocu.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Pedido V-table-Win 
PROCEDURE Captura-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAMETER x-Ok AS LOG.
  
  ASSIGN
    input-var-1 = 'PNC'
    input-var-2 = s-coddiv
    input-var-3 = ''
    output-var-1 = ?
    output-var-2 = ''
    output-var-3 = ''
    x-Ok = Yes.
  RUN lkup/c-pedi-2 ('PRE-NOTAS DE CREDITO').
  IF output-var-1 = ? THEN DO:
    x-Ok = No.
    RETURN.
  END.
  FIND Faccpedi WHERE ROWID(Faccpedi) = output-var-1 NO-LOCK NO-ERROR.
  /* pintamos informacion */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        Ccbcdocu.codmon:SCREEN-VALUE = STRING(Faccpedi.codmon, '9').
    DISPLAY 
        Faccpedi.codcli @ CcbCDocu.CodCli 
        SUBSTRING(Faccpedi.nroref,1,3) @ CcbCDocu.CodRef 
        Faccpedi.dircli @ CcbCDocu.DirCli 
        TODAY @ CcbCDocu.FchDoc 
        Faccpedi.glosa @ CcbCDocu.Glosa 
        Faccpedi.nomcli @ CcbCDocu.NomCli 
        CcbCDocu.NroDoc 
        SUBSTRING(Faccpedi.nroref,4) @ CcbCDocu.NroRef 
        Faccpedi.ruccli @ CcbCDocu.RucCli 
        FacCfgGn.Tpocmb[1] @ CcbCDocu.TpoCmb.
  END.
  RUN Carga-Temporal.
  
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
  FOR EACH DETA:
    DELETE DETA.
  END.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
    CREATE DETA.
    BUFFER-COPY Facdpedi TO DETA
        ASSIGN
            DETA.coddoc = s-coddoc
            DETA.candes = Facdpedi.canped.
    IF DETA.AftIgv = YES THEN
      ASSIGN
          DETA.ImpIgv = (DETA.CanDes * DETA.PreUni) * ((s-PorIgv / 100) / (1 + (s-PorIgv / 100))).
    ELSE
      ASSIGN
          DETA.ImpIgv = 0.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-detalle V-table-Win 
PROCEDURE Genera-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN Borra-Documento. 
  FOR EACH DETA:
    CREATE CcbDDocu.
    BUFFER-COPY DETA TO Ccbddocu
        ASSIGN 
            CcbDDocu.CodCia = CcbCDocu.CodCia 
            CcbDDocu.CodDiv = CcbCDocu.coddiv
            CcbDDocu.CodDoc = CcbCDocu.CodDoc 
            CcbDDocu.NroDoc = CcbCDocu.NroDoc.
    DELETE DETA.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales V-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*   ASSIGN                                                                                                             */
/*     Ccbcdocu.ImpBrt = 0                                                                                              */
/*     Ccbcdocu.ImpExo = 0                                                                                              */
/*     Ccbcdocu.ImpDto = 0                                                                                              */
/*     Ccbcdocu.ImpIgv = 0                                                                                              */
/*     Ccbcdocu.ImpTot = 0.                                                                                             */
/*                                                                                                                      */
/*   FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:                                                                             */
/*     ASSIGN                                                                                                           */
/*         Ccbcdocu.ImpBrt = Ccbcdocu.ImpBrt + (IF Ccbddocu.AftIgv = Yes THEN Ccbddocu.PreUni * Ccbddocu.CanDes ELSE 0) */
/*         Ccbcdocu.ImpExo = Ccbcdocu.ImpExo + (IF Ccbddocu.AftIgv = No  THEN Ccbddocu.PreUni * Ccbddocu.CanDes ELSE 0) */
/*         Ccbcdocu.ImpDto = Ccbcdocu.ImpDto + Ccbddocu.ImpDto                                                          */
/*         Ccbcdocu.ImpIgv = Ccbcdocu.ImpIgv + Ccbddocu.ImpIgv                                                          */
/*         Ccbcdocu.ImpTot = Ccbcdocu.ImpTot + Ccbddocu.ImpLin.                                                         */
/*   END.                                                                                                               */
/*   ASSIGN                                                                                                             */
/*     Ccbcdocu.ImpVta = Ccbcdocu.ImpBrt - Ccbcdocu.ImpIgv                                                              */
/*     Ccbcdocu.ImpBrt = Ccbcdocu.ImpBrt - Ccbcdocu.ImpIgv + Ccbcdocu.ImpDto                                            */
/*     Ccbcdocu.SdoAct = Ccbcdocu.ImpTot.                                                                               */

  {vta2/graba-totales-factura-cred.i}

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
  IF FacCorre.FlgEst = NO THEN DO:
     MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
     RETURN 'ADM-ERROR'.
  END.

  IF s-Sunat-Activo = YES THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  
  ASSIGN
    input-var-1 = 'PNC'
    input-var-2 = s-coddiv
    input-var-3 = 'P'
    output-var-1 = ?
    output-var-2 = ''
    output-var-3 = ''
    s-PorIgv =  FacCfgGn.PorIgv.

  RUN lkup/c-pedi-2 ('PRE-NOTAS DE CREDITO').
  IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.
  FIND Faccpedi WHERE ROWID(Faccpedi) = output-var-1 NO-LOCK NO-ERROR.

  /* ------------------------- */
    /* Que no supere el monto del comprobante - programa obsoleto nooo */

  ASSIGN
      s-PorIgv = Faccpedi.PorIgv.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        CcbCDocu.NroDoc:SCREEN-VALUE = STRING(Faccorre.nroser, '999') +
                                        STRING(Faccorre.correlativo, '999999').
    ASSIGN
        Ccbcdocu.codmon:SCREEN-VALUE = STRING(Faccpedi.codmon, '9').
    DISPLAY 
        Faccpedi.codcli @ CcbCDocu.CodCli 
        SUBSTRING(Faccpedi.nroref,1,3) @ CcbCDocu.CodRef 
        Faccpedi.dircli @ CcbCDocu.DirCli 
        TODAY @ CcbCDocu.FchDoc 
        Faccpedi.glosa @ CcbCDocu.Glosa 
        Faccpedi.nomcli @ CcbCDocu.NomCli 
        SUBSTRING(Faccpedi.nroref,4) @ CcbCDocu.NroRef 
        Faccpedi.ruccli @ CcbCDocu.RucCli 
        FacCfgGn.Tpocmb[1] @ CcbCDocu.TpoCmb.
  END.
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').

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
    CcbCDocu.FchVto = ADD-INTERVAL(CcbCDocu.FchDoc, 1, 'years')
    CcbCDocu.usuario = S-USER-ID.

  FIND FIRST B-CDOCU WHERE B-CDOCU.CodCia = s-codcia 
    AND B-CDOCU.CodDoc = CcbCDocu.CodRef 
    AND B-CDOCU.NroDoc = CcbCDocu.NroRef NO-LOCK NO-ERROR.   
          
  ASSIGN 
    CcbCDocu.CodVen = B-CDOCU.CodVen.

  /* ACTUALIZAMOS EL CENTRO DE COSTO */
  FIND GN-VEN WHERE GN-VEN.codcia = s-codcia
    AND GN-VEN.codven = CCBCDOCU.codven NO-LOCK NO-ERROR.
  IF AVAILABLE GN-VEN THEN CCBCDOCU.cco = GN-VEN.cco.

  RUN Genera-Detalle.   
  RUN Graba-Totales.

  FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
  IF AVAILABLE Ccbddocu THEN
      ASSIGN
      Ccbcdocu.codcta = Ccbddocu.codmat.

  /* ****************************** */
  /* Ic - 16Nov2021 - Importes Arimetica de SUNAT */
  /* ****************************** */
  &IF {&ARITMETICA-SUNAT} &THEN
      DEF VAR hProc AS HANDLE NO-UNDO.
      RUN sunat/sunat-calculo-importes.r PERSISTENT SET hProc.
      RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                                   INPUT Ccbcdocu.CodDoc,
                                   INPUT Ccbcdocu.NroDoc,
                                   OUTPUT pMensaje).
    
      DELETE PROCEDURE hProc.
    
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
  &ENDIF
  /* ****************************** */
  /* RHC 02-07-2012 ASIENTO DE TRANSFERENCIA PARA SPEED */
  /* ************************************************** */
  /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
  RUN sunat\progress-to-ppll-v3  ( INPUT Ccbcdocu.coddiv,
                                   INPUT Ccbcdocu.coddoc,
                                   INPUT Ccbcdocu.nrodoc,
                                   INPUT-OUTPUT TABLE T-FELogErrores,
                                   OUTPUT pMensaje ).
  /* *********************************************************** */

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
  FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.coddiv = s-coddiv
    AND FacCorre.nroser = s-nroser
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccorre THEN DO:
    MESSAGE 'No se pudo bloquear el control de correlativos'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN DO:
    MESSAGE 'No se pudo bloquear la pre-nota de credito'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    Ccbcdocu.codcia = s-codcia
    Ccbcdocu.coddoc = s-coddoc
    Ccbcdocu.coddiv = s-coddiv
    Ccbcdocu.nrodoc = STRING(Faccorre.nroser, '999') +
                        STRING(Faccorre.correlativo, '999999')
    CcbCDocu.FlgEst = "P"
    CcbCDocu.PorIgv = s-PorIgv
    CcbCDocu.CndCre = 'N'
    CcbCDocu.codped = Faccpedi.coddoc
    CcbCDocu.nroped = Faccpedi.nroped
    CcbCDocu.TpoFac = s-TpoFac.
  ASSIGN
    Faccpedi.flgest = 'C'.
  FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
  ASSIGN
    Faccorre.correlativo = Faccorre.correlativo + 1.
  RELEASE Faccorre.                        

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
  
  /* ********************************************* */
  /* Inicio de actividades facturación electrónica */
  /* ********************************************* */
  IF caps(s-user-id) <> 'ADMIN' THEN DO:
      IF s-Sunat-Activo = YES THEN DO:
          MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* ********************************************* */
  
  IF CcbCDocu.FlgEst = "A" THEN DO:
    MESSAGE 'El documento se enuentra anulado...' VIEW-AS ALERT-BOX.
    RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.SdoAct <> CcbCDocu.ImpTot  THEN DO:
    MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
    RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.CndCre <> 'N' THEN DO:
    MESSAGE 'El documento corresponde a devolución de mercaderia' VIEW-AS ALERT-BOX.
    RETURN 'ADM-ERROR'.
  END.
  /* documento con canje de letras pendiente de aprobar */
  IF Ccbcdocu.flgsit = 'X' THEN DO:
      MESSAGE 'Documento con canje por letra pendiente de aprobar' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  /* consistencia de la fecha del cierre del sistema */
  IF caps(s-user-id) <> 'ADMIN' THEN DO:
      DEF VAR dFchCie AS DATE.
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF ccbcdocu.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.

  /* RHC CONSISTENCIA SOLO PARA TIENDAS UTILEX */
  IF LOOKUP(s-coddiv, '00023,00027,00501,00502') > 0 
      AND Ccbcdocu.fchdoc < TODAY
      THEN DO:
      MESSAGE 'Solo se pueden anular documentos del día'
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  /* fin de consistencia */
  {adm/i-DocPssw.i ccbcdocu.CodCia ccbcdocu.CodDoc ""DEL""}

/*    /* Dispatch standard ADM method.                             */
 *     RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
 *     /* Code placed here will execute AFTER standard behavior.    */*/

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      /* Motivo de anulacion */
      DEF VAR cReturnValue AS CHAR NO-UNDO.
      RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
      IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      /* ******************* */

      FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.

      /* Extornamos Amortizaciones de A/C si las hubiera */
      RUN vta2/extorna-ac (ROWID(Ccbcdocu)).
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

      RUN Borra-Documento.
      ASSIGN
          Ccbcdocu.flgest = 'A'.
      FIND Faccpedi WHERE Faccpedi.codcia = ccbcdocu.codcia
          AND Faccpedi.coddoc = Ccbcdocu.codped
          AND Faccpedi.nroped = Ccbcdocu.nroped
          EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE Faccpedi THEN Faccpedi.flgest = 'P'.
      /* *************** ANULAMOS LA N/C EN EL SPEED **************** */
/*       RUN sypsa/anular-comprobante (ROWID(Ccbcdocu)).              */
/*       IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR". */
      /* ************************************************************ */
      RELEASE Faccpedi.
      FIND CURRENT Ccbcdocu NO-LOCK NO-ERROR.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('Browse').
  
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
  IF AVAILABLE Ccbcdocu THEN DO WITH FRAME {&FRAME-NAME}:
    CASE Ccbcdocu.flgest:
        WHEN 'X' THEN FILL-IN-Estado:SCREEN-VALUE = 'POR APROBAR'.
        WHEN 'P' THEN FILL-IN-Estado:SCREEN-VALUE = 'PENDIENTE'.
        WHEN 'C' THEN FILL-IN-Estado:SCREEN-VALUE = 'CANCELADO'.
        WHEN 'A' THEN FILL-IN-Estado:SCREEN-VALUE = 'ANULADO'.
        OTHERWISE  FILL-IN-Estado:SCREEN-VALUE = ''.
    END.
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
        CcbCDocu.CodCli:SENSITIVE = NO
        CcbCDocu.CodMon:SENSITIVE = NO
        CcbCDocu.CodRef:SENSITIVE = NO
        CcbCDocu.DirCli:SENSITIVE = NO
        CcbCDocu.FchDoc:SENSITIVE = NO
        CcbCDocu.NomCli:SENSITIVE = NO
        CcbCDocu.NroDoc:SENSITIVE = NO
        CcbCDocu.NroRef:SENSITIVE = NO
        CcbCDocu.RucCli:SENSITIVE = NO
        CcbCDocu.TpoCmb:SENSITIVE = NO.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF LOOKUP(CCBCDOCU.FLGEST, "A,X") > 0 THEN RETURN.

  DEFINE VAR x-version AS CHAR.
  DEFINE VAR x-formato-tck AS LOG.
  DEFINE VAR x-Imprime-directo AS LOG.
  DEFINE VAR x-nombre-impresora AS CHAR.

  x-formato-tck = NO.        /* YES : Formato Ticket,  NO : Formato A4 */
  x-imprime-directo = YES.
  x-nombre-impresora = "".

  DEF VAR pMensaje AS CHAR NO-UNDO.
  DEF VAR hPrinter AS HANDLE NO-UNDO.

  RUN sunat\r-print-electronic-doc-sunat PERSISTENT SET hPrinter.

  /* 1-8-23 Reimpresión: Límite de reimpresiones */
  DEF VAR iImpresionesExistentes AS INTE INIT 0 NO-UNDO.

  CASE TRUE:
      WHEN CAN-FIND(FIRST Invoices_Printed WHERE Invoices_Printed.CodCia = s-codcia AND
                    Invoices_Printed.CodDoc = Ccbcdocu.coddoc AND
                    Invoices_Printed.NroDoc = Ccbcdocu.nrodoc AND 
                    LOOKUP(Invoices_Printed.Version_Printed,"L,A") > 0 NO-LOCK) 
          THEN DO:
          iImpresionesExistentes = DYNAMIC-FUNCTION('PRINT_fget-count-invoice-printed' IN hPrinter, 
                                                    Ccbcdocu.coddoc, 
                                                    Ccbcdocu.nrodoc).
          IF iImpresionesExistentes > 0 THEN DO:
              FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia AND
                  VtaTabla.Tabla = 'CFG_PRINT_INVOICE' AND
                  VtaTabla.Llave_c1 = 'PARAMETER' AND
                  VtaTabla.Llave_c2 = 'RE-IMPRESION'
                  NO-LOCK NO-ERROR.
              IF AVAILABLE VtaTabla AND iImpresionesExistentes >= VtaTabla.Valor[1] THEN DO:
                  MESSAGE 'No se pueden hacer más reimpresiones' SKIP(1)
                      'El límite de reimpresiones es:' STRING(VtaTabla.Valor[1], '>9')
                      VIEW-AS ALERT-BOX WARNING.
                  DELETE PROCEDURE hPrinter.
                  RETURN.
              END.
          END.
          x-version = 'R'.
          {gn/i-print-electronic-doc-sunat.i}
      END.
      OTHERWISE DO:
          x-version = 'L'.
          {gn/i-print-electronic-doc-sunat.i}
      END.
  END CASE.

  DELETE PROCEDURE hPrinter.


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
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 

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
  {src/adm/template/snd-list.i "CcbCDocu"}

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
  Purpose:     Validacion de datos
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
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
  RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

