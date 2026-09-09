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
&Scoped-Define ENABLED-FIELDS CcbCDocu.NomCli CcbCDocu.TpoCmb ~
CcbCDocu.DirCli CcbCDocu.FchDoc CcbCDocu.RucCli CcbCDocu.FchVto ~
CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-21 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.CodRef ~
CcbCDocu.NroRef CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.TpoCmb ~
CcbCDocu.DirCli CcbCDocu.FchDoc CcbCDocu.RucCli CcbCDocu.HorCie ~
CcbCDocu.CodVen CcbCDocu.FchVto CcbCDocu.FmaPgo CcbCDocu.NroPed ~
CcbCDocu.CodPed CcbCDocu.CodAge CcbCDocu.NroOrd CcbCDocu.Glosa ~
CcbCDocu.CodMon 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-pedido F-Estado F-nOMvEN F-CndVta ~
F-NomTra 

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
     SIZE 46 BY .69 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     FGCOLOR 9 FONT 0 NO-UNDO.

DEFINE VARIABLE F-NomTra AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .69 NO-UNDO.

DEFINE VARIABLE F-nOMvEN AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-pedido AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .69
     FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 7.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.27 COL 11 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 17.29 BY .69
          FONT 0
     FILL-IN-pedido AT ROW 1.27 COL 35.14 COLON-ALIGNED
     CcbCDocu.CodRef AT ROW 1.27 COL 49 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .69
     CcbCDocu.NroRef AT ROW 1.27 COL 55.72 NO-LABEL FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .69
          FONT 0
     F-Estado AT ROW 1.27 COL 71.72 COLON-ALIGNED NO-LABEL
     CcbCDocu.CodCli AT ROW 1.96 COL 11 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     CcbCDocu.NomCli AT ROW 1.96 COL 24 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 39 BY .69
     CcbCDocu.TpoCmb AT ROW 1.96 COL 73.29 COLON-ALIGNED
          LABEL "T/  Cambio" FORMAT ">,>>9.99<<"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .69
     CcbCDocu.DirCli AT ROW 2.69 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 52 BY .69
     CcbCDocu.FchDoc AT ROW 2.69 COL 73.29 COLON-ALIGNED
          LABEL "Emisión"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCDocu.RucCli AT ROW 3.35 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbCDocu.HorCie AT ROW 3.35 COL 73.29 COLON-ALIGNED HELP
          "" NO-LABEL FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 7.72 BY .69
          FGCOLOR 12 
     CcbCDocu.CodVen AT ROW 4.04 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     F-nOMvEN AT ROW 4.04 COL 17 COLON-ALIGNED NO-LABEL
     CcbCDocu.FchVto AT ROW 4.04 COL 73.29 COLON-ALIGNED
          LABEL "Vencmento"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .69
     CcbCDocu.FmaPgo AT ROW 4.73 COL 11 COLON-ALIGNED
          LABEL "Cond.Vta"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     F-CndVta AT ROW 4.73 COL 17 COLON-ALIGNED NO-LABEL
     CcbCDocu.NroPed AT ROW 4.73 COL 73.29 COLON-ALIGNED
          LABEL "Nro" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
          FONT 0
     CcbCDocu.CodPed AT ROW 4.81 COL 65.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .69
     CcbCDocu.CodAge AT ROW 5.42 COL 11 COLON-ALIGNED
          LABEL "Transportista" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     F-NomTra AT ROW 5.42 COL 22 COLON-ALIGNED NO-LABEL
     CcbCDocu.NroOrd AT ROW 5.42 COL 73.29 COLON-ALIGNED
          LABEL "O/ Compra" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .69
     CcbCDocu.LugEnt AT ROW 6.12 COL 11 COLON-ALIGNED
          LABEL "Entregar en" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 52 BY .69
          FGCOLOR 9 
     CcbCDocu.Glosa AT ROW 6.81 COL 11 COLON-ALIGNED
          LABEL "Glosa" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 52 BY .69
     CcbCDocu.CodMon AT ROW 6.96 COL 75.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.14 BY .62
     "Moneda:" VIEW-AS TEXT
          SIZE 6.29 BY .58 AT ROW 6.92 COL 68.86
     RECT-21 AT ROW 1 COL 1
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
         HEIGHT             = 7
         WIDTH              = 89.
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

/* SETTINGS FOR FILL-IN CcbCDocu.CodAge IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR RADIO-SET CcbCDocu.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.CodRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomTra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nOMvEN IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-pedido IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.HorCie IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* SETTINGS FOR FILL-IN CcbCDocu.LugEnt IN FRAME F-Main
   NO-DISPLAY NO-ENABLE EXP-LABEL EXP-FORMAT                            */
ASSIGN 
       CcbCDocu.LugEnt:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NroOrd IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-FORMAT                                         */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedido V-table-Win 
PROCEDURE Actualiza-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER I-Factor AS INTEGER.

  FOR EACH CcbDDocu NO-LOCK WHERE 
           CcbDDocu.CodCia = CcbCDocu.CodCia AND  
           CcbDDocu.CodDoc = CcbCDocu.CodDoc AND  
           CcbDDocu.NroDoc = CcbCDocu.NroDoc
           ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND FacDPedi WHERE 
           FacDPedi.CodCia = CcbCDocu.CodCia AND  
           FacDPedi.CodDoc = CcbCDocu.Codped AND  
           FacDPedi.NroPed = CcbCDocu.NroPed AND  
           FacDPedi.CodMat = CcbDDocu.CodMat 
           EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE FacDPedi THEN DO:
         ASSIGN FacDPedi.CanAte = FacDPedi.CanAte + (CcbDDocu.CanDes * I-Factor).
         IF (FacDPedi.CanPed - FacDPedi.CanAte) = 0 
         THEN FacDPedi.FlgEst = "C".
         ELSE FacDPedi.FlgEst = "P".
      END.
      RELEASE FacDPedi.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  RUN local-display-fields.

END PROCEDURE.


/*
  IF LOOKUP(ccbcdocu.flgest, 'X,P,F') = 0 THEN RETURN.
  FIND Faccpedi WHERE Faccpedi.codcia = ccbcdocu.codcia
      AND Faccpedi.coddoc = Ccbcdocu.codped
      AND Faccpedi.nroped = Ccbcdocu.nroped
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacCPedi THEN RUN vta\w-agtrans-01 (ROWID(FacCPedi), ROWID(Ccbcdocu)).
  RUN local-display-fields.
*/

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
            'La Guía de Remisión está ANULADA'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF CcbCDocu.FlgEst = 'F' THEN DO:
        MESSAGE
            'La Guía de Remisión está FACTURADA'
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
        /* Motivo de anulacion */
        DEF VAR cReturnValue AS CHAR NO-UNDO.
        RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
        IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /* ******************* */
        /* Borra Detalle G/R */
        FOR EACH CcbDDocu WHERE CcbDDocu.CodCia = CcbCDocu.CodCia 
            AND CcbDDocu.CodDoc = CcbCDocu.CodDoc 
            AND CcbDDocu.Nrodoc = CcbCDocu.NroDoc:
            DELETE CcbDDocu.
        END.
        /* Actualizamos estado de la GRI */
        FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
            AND B-CDOCU.coddoc = Ccbcdocu.Libre_c01
            AND B-CDOCU.nrodoc = Ccbcdocu.Libre_c02
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CDOCU THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN
            B-CDOCU.FlgEst = 'P'.
        /* ***************************** */
        /* TRACKING GUIAS */
        FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
            AND Faccpedi.coddoc = Ccbcdocu.CodPed       /* PED */
            AND Faccpedi.nroped = Ccbcdocu.NroPed
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN 'ADM-ERROR'.
        RUN gn/pTracking (s-CodCia,
                          Faccpedi.CodDiv,
                          s-CodDiv,
                          Faccpedi.CodDoc,
                          Faccpedi.NroPed,
                          s-User-Id,
                          'EGUI',
                          'A',
                          'IO',
                          DATETIME(TODAY, MTIME),
                          DATETIME(TODAY, MTIME),
                          Ccbcdocu.coddoc,
                          Ccbcdocu.nrodoc).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /* **************** */
        FIND b-CDocu WHERE ROWID(b-CDocu) = ROWID(CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN 
            b-CDocu.FlgEst = "A"
            b-CDocu.SdoAct = 0
            b-CDocu.Glosa  = "** A N U L A D O **"
            b-CDocu.FchAnu = TODAY
            b-CDocu.Usuanu = s-User-Id.
        RELEASE b-CDocu.
    END.

    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    RUN dispatch IN lh_Handle ('open-query':U).

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
            WHEN "A" THEN DISPLAY " ANULADO " @ F-Estado.
            WHEN "F" THEN DISPLAY "FACTURADO" @ F-Estado.
            WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado.
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
        FIND gn-prov WHERE
            gn-prov.CodCia = pv-CodCia AND
            gn-prov.CODPRO = CcbCDocu.CodAge NO-LOCK NO-ERROR.
        IF AVAILABLE GN-PROV THEN F-NomTra:SCREEN-VALUE = GN-PROV.NomPRO.
        /*C-TpoVta:SCREEN-VALUE = ENTRY(INTEGER(CcbCDocu.TipVta),C-TpoVta:LIST-ITEMS).*/
        FILL-IN-pedido:SCREEN-VALUE = "".
        FIND FaccPedi WHERE
            FaccPedi.CodCia = s-CodCia AND
            FaccPedi.Coddoc = CcbCDocu.CodPed AND
            FaccPedi.NroPed = CcbCDocu.NroPed NO-LOCK NO-ERROR.
        IF AVAILABLE FaccPedi THEN FILL-IN-pedido:SCREEN-VALUE = FaccPedi.NroRef.
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
          RUN vta/d-fmtgui-04 (ROWID(CcbCDocu)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_ActualizaPedido V-table-Win 
PROCEDURE proc_ActualizaPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER b-CPedi FOR FacCPedi.
    DEFINE BUFFER b-DPedi FOR FacDPedi.

    DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Cabecera de O/D */
        FIND FacCPedi WHERE
            FacCPedi.CodCia = CcbCDocu.CodCia AND
            FacCPedi.CodDoc = CcbCDocu.Codped AND
            FacCPedi.NroPed = CcbCDocu.NroPed NO-LOCK NO-ERROR.
        FOR EACH CcbDDocu NO-LOCK WHERE
            CcbDDocu.CodCia = CcbCDocu.CodCia AND
            CcbDDocu.CodDoc = CcbCDocu.CodDoc AND
            CcbDDocu.NroDoc = CcbCDocu.NroDoc:
            /* Detalle de la O/D */
            FIND FacDPedi WHERE 
                FacDPedi.CodCia = CcbCDocu.CodCia AND  
                FacDPedi.CodDoc = CcbCDocu.Codped AND  
                FacDPedi.NroPed = CcbCDocu.NroPed AND  
                FacDPedi.CodMat = CcbDDocu.CodMat
                NO-LOCK NO-ERROR.
            IF AVAILABLE FacDPedi THEN DO:
                /* Busca el Detalle del Pedido */
                FIND b-DPedi WHERE
                    b-DPedi.CodCia = FacCPedi.CodCia AND
                    b-DPedi.CodDoc = "PED" AND
                    b-DPedi.NroPed = FacCPedi.NroRef AND
                    b-DPedi.CodMat = FacDPedi.CodMat
                    EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE b-DPedi THEN DO:
                    b-DPedi.CanAte = b-DPedi.CanAte + (FacDPedi.CanPed * -1).
                    b-DPedi.FlgEst = IF (b-DPedi.CanPed - b-DPedi.CanAte) <= 0 THEN "C" ELSE "P".
                END.
                RELEASE b-DPedi.
            END.
        END.
        /* Cabecera de Pedido */
        FIND b-CPedi WHERE
            b-CPedi.CodCia = FacCPedi.CodCia AND
            b-CPedi.CodDiv = FacCPedi.CodDiv AND
            b-CPedi.CodDoc = "PED" AND
            b-CPedi.NroPed = FacCPedi.NroRef
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b-CPedi THEN
            ASSIGN b-CPedi.FlgEst = "P".
        RELEASE b-CPedi.
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

