&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.



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

/* Shared Variable Definitions ---                                       */

DEFINE SHARED VARIABLE s-CodCia AS INTEGER.
DEFINE SHARED VARIABLE s-CodDiv AS CHAR.
DEFINE SHARED VARIABLE s-User-Id AS CHAR.
DEFINE SHARED VARIABLE s-CodDoc AS CHAR.
DEFINE SHARED VARIABLE pv-CodCia AS INTEGER.
DEFINE SHARED VARIABLE cl-CodCia AS INTEGER.
DEFINE SHARED VARIABLE lh_Handle AS HANDLE.

/* Local Variable Definitions ---                                       */
DEFINE BUFFER b-CDocu FOR CcbCDocu.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.FchDoc CcbCDocu.NomCli ~
CcbCDocu.DirCli CcbCDocu.FchVto CcbCDocu.RucCli CcbCDocu.TpoCmb ~
CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.HorCie CcbCDocu.DirCli ~
CcbCDocu.FchVto CcbCDocu.RucCli CcbCDocu.TpoCmb CcbCDocu.CodVen ~
CcbCDocu.NroPed CcbCDocu.FmaPgo CcbCDocu.Libre_c02 CcbCDocu.Glosa ~
CcbCDocu.NroOrd CcbCDocu.CodRef CcbCDocu.NroRef 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-nOMvEN F-CndVta 

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
DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     FGCOLOR 9 FONT 0 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.27 COL 11 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 17.29 BY .81
          FONT 0
     F-Estado AT ROW 1.27 COL 29 COLON-ALIGNED NO-LABEL
     CcbCDocu.FchDoc AT ROW 1.27 COL 75 COLON-ALIGNED
          LABEL "Emisión"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodCli AT ROW 2.08 COL 11 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.NomCli AT ROW 2.08 COL 24 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 39 BY .81
     CcbCDocu.HorCie AT ROW 2.08 COL 75 COLON-ALIGNED HELP
          ""
          LABEL "Hora" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 7.72 BY .81
          FGCOLOR 12 
     CcbCDocu.DirCli AT ROW 2.88 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 52 BY .81
     CcbCDocu.FchVto AT ROW 2.88 COL 75 COLON-ALIGNED
          LABEL "Vencmento"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .81
     CcbCDocu.RucCli AT ROW 3.69 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.TpoCmb AT ROW 3.69 COL 75 COLON-ALIGNED
          LABEL "T/  Cambio" FORMAT ">,>>9.99<<"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .81
     CcbCDocu.CodVen AT ROW 4.5 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-nOMvEN AT ROW 4.5 COL 17 COLON-ALIGNED NO-LABEL
     CcbCDocu.NroPed AT ROW 4.5 COL 75 COLON-ALIGNED
          LABEL "Pedido" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          FONT 0
     CcbCDocu.FmaPgo AT ROW 5.31 COL 11 COLON-ALIGNED
          LABEL "Cond.Vta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     F-CndVta AT ROW 5.31 COL 17 COLON-ALIGNED NO-LABEL
     CcbCDocu.Libre_c02 AT ROW 5.31 COL 75 COLON-ALIGNED WIDGET-ID 6
          LABEL "O/Despacho" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.Glosa AT ROW 6.12 COL 11 COLON-ALIGNED
          LABEL "Glosa" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 52 BY .81
     CcbCDocu.NroOrd AT ROW 6.12 COL 75 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .81
     CcbCDocu.CodRef AT ROW 6.92 COL 11 COLON-ALIGNED
          LABEL "Comprobante"
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .81
     CcbCDocu.NroRef AT ROW 6.92 COL 18 NO-LABEL FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
          FONT 0
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCDocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
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
         HEIGHT             = 7.23
         WIDTH              = 91.72.
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

/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.CodRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.HorCie IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* SETTINGS FOR FILL-IN CcbCDocu.Libre_c02 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroOrd IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL EXP-FORMAT                               */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Transportista V-table-Win 
PROCEDURE Asigna-Transportista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT AVAILABLE Ccbcdocu THEN RETURN.

  IF LOOKUP(ccbcdocu.flgest, 'X,P,F') = 0 THEN RETURN.

  RUN vta/w-agtrans-02 (Ccbcdocu.codcia, Ccbcdocu.coddiv, Ccbcdocu.coddoc, Ccbcdocu.nrodoc).
  RUN dispatch IN THIS-PROCEDURE ('display-fields').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    IF CcbCDocu.FlgEst = "A" THEN DO:
        MESSAGE
            'La Guía está ANULADA'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF CcbCDocu.FlgEst = 'F' AND Ccbcdocu.CodPed <> 'P/M' THEN DO:
        MESSAGE
            'La Guía está Facturada'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

    RUN alm/p-ciealm-01 (Ccbcdocu.FchDoc, Ccbcdocu.CodAlm).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

    /* consistencia de la fecha del cierre del sistema */
    DEF VAR dFchCie AS DATE.
    RUN gn/fecha-de-cierre (OUTPUT dFchCie).
    IF ccbcdocu.fchdoc <= dFchCie THEN DO:
        MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
    /* fin de consistencia */

    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}

    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN 
            Ccbcdocu.FlgEst = "A"
            Ccbcdocu.SdoAct = 0
            Ccbcdocu.Glosa  = "** A N U L A D O **"
            Ccbcdocu.FchAnu = TODAY
            Ccbcdocu.Usuanu = s-User-Id.

        /* Extornamos Orden de Despacho */
        RUN proc_ActualizaO_D.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /* Borra Detalle G/R */
        FOR EACH CcbDDocu WHERE CcbDDocu.CodCia = CcbCDocu.CodCia 
            AND CcbDDocu.CodDoc = CcbCDocu.CodDoc 
            AND CcbDDocu.Nrodoc = CcbCDocu.NroDoc:
            DELETE CcbDDocu.
        END.
        /* EXTORNA STOCK DEL ALMACEN SOLO PARA PEDIDOS AL CREDITO */
        RUN vtagn/des_alm-04 (ROWID(CcbCDocu)).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /* ANULAMOS TRACKING */
        RUN vtagn/pTracking-04 (Ccbcdocu.CodCia,
                          Ccbcdocu.CodDiv,
                          Ccbcdocu.CodPed,
                          Ccbcdocu.NroPed,
                          s-User-Id,
                          'EGUI',
                          'A',
                          DATETIME(TODAY, MTIME),
                          DATETIME(TODAY, MTIME),
                          Ccbcdocu.coddoc,
                          Ccbcdocu.nrodoc,
                          Ccbcdocu.Libre_C01,
                          Ccbcdocu.Libre_C02).

        FIND CURRENT Ccbcdocu NO-LOCK.
    END.

    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    RUN dispatch IN lh_Handle ('open-query':U).

    MESSAGE 'Se ha vuelto a reactivar la' ccbcdocu.Libre_c01 ccbcdocu.Libre_c02
        VIEW-AS ALERT-BOX INFORMATION.

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
    IF AVAILABLE CcbCDocu THEN DO WITH FRAME {&FRAME-NAME}:
        CASE CcbCDocu.FlgEst:
            WHEN "A" THEN DISPLAY "ANULADA" @ F-Estado.
            WHEN "F" THEN DISPLAY "FACTURADA" @ F-Estado.
            WHEN "P" THEN DISPLAY "PARA FACTURAR" @ F-Estado.
            WHEN "X" THEN DISPLAY "POR CHEQUEAR" @ F-Estado.
        END CASE.
        F-NomVen:SCREEN-VALUE = "".
        FIND gn-ven WHERE
            gn-ven.CodCia = s-CodCia AND
            gn-ven.CodVen = CcbCDocu.CodVen NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
        F-CndVta:SCREEN-VALUE = "".
        FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
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
  IF CcbCDocu.FlgEst <> "A" THEN DO:
      IF CcbCDocu.FlgEnv  = YES    /* Es G/R manual */
          OR Ccbcdocu.FlgEst = 'X'
      THEN DO:
          MESSAGE 'Esta GUIA SOLO debe imprimirse en PAPEL BLANCO' SKIP
              'NO usar formatos preimpresos' SKIP
              'Continuamos la impresion?'
              VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
              UPDATE rpta-1 AS LOG.
          IF rpta-1 = NO THEN RETURN.
          RUN vta/r-ImpGui3 (ROWID(CcbCDocu)).
      END.
      ELSE DO:
          IF Ccbcdocu.flgest <> 'F' THEN DO:
              MESSAGE 'NO se puede imprimir la guía' SKIP
                      'Aún no se ha Facturado' VIEW-AS ALERT-BOX ERROR.
              RETURN.
          END.
          RUN vta/d-fmtgui-02 (ROWID(CcbCDocu)).
      END.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_ActualizaO_D V-table-Win 
PROCEDURE proc_ActualizaO_D :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Cabecera de O/D */
        FIND FacCPedi WHERE
            FacCPedi.CodCia = CcbCDocu.CodCia AND
            FacCPedi.CodDoc = CcbCDocu.Libre_c01 AND
            FacCPedi.NroPed = CcbCDocu.Libre_c02 
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.
        FOR EACH CcbDDocu OF CcbCDocu NO-LOCK:
            /* Detalle de la O/D */
            FIND FacDPedi OF FacCPedi WHERE FacDPedi.CodMat = CcbDDocu.CodMat
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Facdpedi THEN UNDO, RETURN 'ADM-ERROR'.
            ASSIGN
                FacDPedi.CanAte = FacDPedi.CanAte - Ccbddocu.candes.
            FacDPedi.FlgEst = IF (FacDPedi.CanPed - FacDPedi.CanAte) <= 0 THEN "C" ELSE "P".
            RELEASE FacDPedi.
        END.
        /* Cabecera de Pedido */
        ASSIGN FacCPedi.FlgEst = "P".
        RELEASE FacCPedi.
    END.

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

