&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-FCHDOC   AS DATE.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR. 
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.
S-CODMON = 1.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 
DEFINE VARIABLE s-Renumera-Letras AS LOG NO-UNDO.

DEFINE SHARED VARIABLE CL-CODCIA AS INTEGER.

DEFINE SHARED TEMP-TABLE MVTO LIKE CcbDMvto.

DEFINE BUFFER B-CMvto FOR CcbCMvto.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

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
&Scoped-define EXTERNAL-TABLES CcbCMvto
&Scoped-define FIRST-EXTERNAL-TABLE CcbCMvto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCMvto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCMvto.NroDoc CcbCMvto.FchDoc ~
CcbCMvto.CodCli CcbCMvto.Glosa CcbCMvto.CodMon CcbCMvto.ImpTot 
&Scoped-define ENABLED-TABLES CcbCMvto
&Scoped-define FIRST-ENABLED-TABLE CcbCMvto
&Scoped-Define DISPLAYED-FIELDS CcbCMvto.NroDoc CcbCMvto.FchDoc ~
CcbCMvto.CodCli CcbCMvto.Usuario CcbCMvto.Glosa CcbCMvto.CodMon ~
CcbCMvto.ImpTot 
&Scoped-define DISPLAYED-TABLES CcbCMvto
&Scoped-define FIRST-DISPLAYED-TABLE CcbCMvto
&Scoped-Define DISPLAYED-OBJECTS x-Estado x-NomCli 

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
     LABEL "ESTADO" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCMvto.NroDoc AT ROW 1.19 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     x-Estado AT ROW 1.19 COL 36 COLON-ALIGNED
     CcbCMvto.FchDoc AT ROW 1.19 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCMvto.CodCli AT ROW 2.15 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     x-NomCli AT ROW 2.15 COL 23 COLON-ALIGNED NO-LABEL
     CcbCMvto.Usuario AT ROW 2.15 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCMvto.Glosa AT ROW 3.12 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     CcbCMvto.CodMon AT ROW 3.12 COL 83 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11 BY .77
     CcbCMvto.ImpTot AT ROW 4.08 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 3.31 COL 76
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.CcbCMvto
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
         HEIGHT             = 4.58
         WIDTH              = 97.57.
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

/* SETTINGS FOR FILL-IN CcbCMvto.Usuario IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbCMvto.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodCli V-table-Win
ON LEAVE OF CcbCMvto.CodCli IN FRAME F-Main /* Cliente */
DO:
  x-NomCli:SCREEN-VALUE = ''.
  FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
    AND Gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-clie THEN x-NomCli:SCREEN-VALUE = Gn-clie.nomcli.
  s-fchdoc = DATE(CcbCMvto.FchDoc:SCREEN-VALUE).
  s-codcli = CcbCMvto.Codcli:SCREEN-VALUE.
  s-codmon = INTEGER(CcbCMvto.CodMon:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.ImpTot
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.ImpTot V-table-Win
ON LEAVE OF CcbCMvto.ImpTot IN FRAME F-Main /* Importe Total */
DO:
  RUN Carga-Importe.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Deta V-table-Win 
PROCEDURE Actualiza-Deta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH MVTO:
    DELETE MVTO.
END.
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'NO' THEN DO:
   FOR EACH CcbDMvto WHERE 
            CcbDMvto.CodCia = CcbCMvto.CodCia 
        AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        AND CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK:
       CREATE MVTO.
       BUFFER-COPY CcbDMvto TO MVTO.
   END.
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
  {src/adm/template/row-list.i "CcbCMvto"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCMvto"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Cancelaciones V-table-Win 
PROCEDURE Borra-Cancelaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO ON ERROR UNDO, RETURN "ADM-ERROR":
    FOR EACH CcbDMvto NO-LOCK WHERE 
             CcbDMvto.CodCia = CcbCMvto.CodCia AND
             CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
             CcbDMvto.NroDoc = CcbCMvto.NroDoc
             ON ERROR UNDO, RETURN "ADM-ERROR":
        FIND CcbCDocu WHERE 
             CcbCDocu.CodCia = CcbDMvto.CodCia AND
             CcbCDocu.CodDoc = CcbDMvto.CodRef AND 
             CcbCDocu.NroDoc = CcbDMvto.NroRef EXCLUSIVE-LOCK NO-ERROR.
        CASE CcbDMvto.TpoRef:
            WHEN 'O' THEN DO:
                 IF AVAILABLE CcbCDocu THEN DO:
                    IF CcbCDocu.CodMon = CcbCMvto.CodMon THEN
                       ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct + CcbDMvto.ImpTot.
                    ELSE DO:
                       IF CcbCDocu.CodMon = 1 THEN
                             ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct + (CcbDMvto.ImpTot * CcbCMvto.TpoCmb).
                       ELSE  ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct + (CcbDMvto.ImpTot / CcbCMvto.TpoCmb).
                    END.
                    ASSIGN
                        CcbCDocu.SdoAct = IF CcbCDocu.SdoAct <= 0 THEN 0 ELSE CcbCDocu.SdoAct
                        CcbCDocu.FlgEst = IF CcbCDocu.SdoAct = 0 THEN 'C' ELSE 'P'.
                 END.
              END.
            WHEN 'L' THEN DO:
/*                  IF AVAILABLE CcbCDocu               */
/*                  THEN ASSIGN                         */
/*                         Ccbcdocu.flgest = 'A'        */
/*                         Ccbcdocu.sdoact = 0          */
/*                         Ccbcdocu.fchact = TODAY      */
/*                         CcbCDocu.UsuAnu = s-user-id. */
              END.
        END CASE.
        RELEASE CcbCDocu.
    END.
    /* Eliminar el documento cancelado en caja */
    FOR EACH CcbDCaja WHERE 
           CcbDCaja.CodCia = CcbCMvto.CodCia AND
           CcbDCaja.CodDoc = CcbCMvto.CodDoc AND
           CcbDCaja.NroDoc = CcbCMvto.NroDoc:
           DELETE CcbDCaja.
    END.
  END.
  
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
  /* Eliminar el detalle del canje */
  DO ON ERROR UNDO, RETURN "ADM-ERROR":
    FOR EACH CcbDMvto WHERE 
          CcbDMvto.CodCia = CcbCMvto.CodCia AND
          CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
          CcbDMvto.NroDoc = CcbCMvto.NroDoc:
          DELETE CcbDMvto.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Importe V-table-Win 
PROCEDURE Carga-Importe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH MVTO WHERE MVTO.TpoRef = 'O':
    DELETE MVTO.
  END.
  CREATE MVTO.
  ASSIGN
    MVTO.TpoRef = 'O'
    MVTO.ImpTot = DECIMAL(CcbCMvto.ImpTot:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  RELEASE MVTO.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR s-NuevoCanje AS LOG NO-UNDO.

RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN s-NuevoCanje = YES.
    ELSE s-NuevoCanje = NO.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    IF s-NuevoCanje = YES THEN DO:
        /* bloqueamos el correlativo de letras */
        FIND FIRST FacCorre WHERE Faccorre.codcia = s-codcia
            AND Faccorre.coddiv = s-coddiv
            AND Faccorre.coddoc = 'LET'
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccorre THEN DO:
            MESSAGE 'No se pudo bloquear el control de correlativo de letras'
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    s-Renumera-Letras = NO.
    FOR EACH MVTO WHERE MVTO.TpoRef = 'L':
        CREATE CcbDMvto.
        BUFFER-COPY MVTO TO Ccbdmvto
            ASSIGN 
                CcbDMvto.CodCia = CcbCMvto.CodCia 
                CcbDMvto.CodDoc = CcbCMvto.CodDoc 
                CcbDMvto.NroDoc = CcbCMvto.NroDoc
                CcbDMvto.CodCli = CcbCMvto.CodCli
                CcbDMvto.CodDpto = CcbCMvto.CodDpto
                CcbDMvto.CodProv = CcbCMvto.CodProv
                CcbDMvto.CodDist = CcbCMvto.CodDist.
        IF s-NuevoCanje = YES THEN DO:
            ASSIGN
                CcbDMvto.NroRef = STRING(FacCorre.NroSer, '999') + 
                                 STRING(FacCorre.Correlativo, '999999').
            ASSIGN
                Faccorre.correlativo = Faccorre.correlativo + 1.
            IF MVTO.NroRef <> CCbdmvto.NroRef THEN s-Renumera-Letras = YES.
        END.
    END.
END.
RETURN 'OK'.

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
  DEFINE VAR s-nrolet AS INTEGER NO-UNDO INITIAL 0.
  DEFINE VAR s-canlet AS INTEGER NO-UNDO INITIAL 0.

  ASSIGN
    Ccbcmvto.ImpDoc = 0
    Ccbcmvto.ImpTot = 0.
  FOR EACH Ccbdmvto NO-LOCK WHERE Ccbdmvto.codcia = Ccbcmvto.codcia
        AND Ccbdmvto.coddoc = Ccbcmvto.coddoc
        AND Ccbdmvto.nrodoc = Ccbcmvto.nrodoc
        BY Ccbdmvto.nroref:
    IF Ccbdmvto.TpoRef = 'L' THEN DO:
        ASSIGN
            s-canlet = s-canlet + 1
            s-nrolet = INTEGER(SUBSTRING(Ccbdmvto.NroRef, 4))
            Ccbcmvto.ImpDoc = Ccbcmvto.ImpDoc + Ccbdmvto.ImpDoc
            Ccbcmvto.ImpTot = Ccbcmvto.ImpTot + Ccbdmvto.ImpTot.
    END.
  END.
  ASSIGN  
    Ccbcmvto.NroLet = s-canlet.      

  /* Actualiza correlativo de letras */
  FIND FIRST FacCorre WHERE 
         FacCorre.CodCia = S-CODCIA AND
         FacCorre.CodDoc = 'LET' AND
         FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE FacCorre THEN DO:
       ASSIGN FacCorre.Correlativo = IF FacCorre.Correlativo > s-nrolet THEN
                                     FacCorre.Correlativo ELSE s-nrolet + 1.
  END.
    
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
  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ CcbCMvto.FchDoc
             S-CODCLI @ CcbCMvto.CodCli
             STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ CcbCMvto.NroDoc.
     s-tpocmb = FacCfgGn.Tpocmb[1].
     s-fchdoc = TODAY.
  END.
  RUN Actualiza-Deta.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse2').

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
  DEF VAR s-NuevoRegistro AS LOG NO-UNDO.

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN s-NuevoRegistro = NO.
  ELSE s-NuevoRegistro = YES.

  IF s-NuevoRegistro = YES THEN DO:
      FIND FacCorre WHERE 
            FacCorre.CodCia = S-CODCIA AND
            FacCorre.CodDoc = S-CODDOC AND
            FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF s-NuevoRegistro = YES THEN DO:
      ASSIGN 
          CcbCMvto.CodCia = S-CODCIA
          CcbCMvto.FlgEst = "P"
          CcbCMvto.CodDoc = S-CODDOC
          CcbCMvto.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          CcbCMvto.usuario = S-USER-ID
          CcbCMvto.CodDiv  = S-CODDIV
          FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  ELSE DO:
      RUN Borra-Documento. 
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  ASSIGN 
    CcbCMvto.CodDpto = gn-clie.CodDept 
    CcbCMvto.CodProv = gn-clie.CodProv 
    CcbCMvto.CodDist = gn-clie.CodDist.
  
  RUN Genera-Detalle.   
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN Graba-Totales.

  IF AVAILABLE (faccorre) THEN RELEASE faccorre.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF CcbCMvto.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se encuentra anulado...' VIEW-AS ALERT-BOX
               INFORMATION.
      RETURN 'ADM-ERROR'.
  END.  
  IF CcbCMvto.FlgEst = 'C' THEN DO:
      RUN Verifica-Anulacion.
      IF RETURN-VALUE = "ADM-ERROR" THEN DO :
         MESSAGE "No se puede anular el Canje de Documentos por Letras"
                  VIEW-AS ALERT-BOX ERROR.
         RETURN "ADM-ERROR".
      END.   
  END.
  /* consistencia de la fecha del cierre del sistema */
/*   DEF VAR dFchCie AS DATE.                                                            */
/*   RUN gn/fecha-de-cierre (OUTPUT dFchCie).                                            */
/*   IF ccbcmvto.fchdoc <= dFchCie THEN DO:                                              */
/*       MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1) */
/*           VIEW-AS ALERT-BOX WARNING.                                                  */
/*       RETURN 'ADM-ERROR'.                                                             */
/*   END.                                                                                */
  /* fin de consistencia */

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND CURRENT Ccbcmvto EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcmvto THEN UNDO, RETURN 'ADM-ERROR'.

    /* RHC 19.03.10 Creamos las letras pero como ANULADAS */
    FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = CcbCMvto.codcia AND
        CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
        CcbDMvto.NroDoc = CcbCMvto.NroDoc AND 
        CcbDMvto.TpoRef = "L" :
        /* SOLO LETRAS */
        FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddoc = Ccbdmvto.codref
            AND Ccbcdocu.nrodoc = Ccbdmvto.nroref
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Ccbcdocu THEN DO:
            CREATE CcbCDocu.
            ASSIGN
                CcbCDocu.CodCia = CcbDMvto.CodCia 
                CcbCDocu.CodDiv = S-CODDIV
                CcbCDocu.CodCli = CcbDMvto.CodCli
                CcbCDocu.CodDoc = CcbDMvto.CodRef 
                CcbCDocu.NroDoc = CcbDMvto.NroRef 
                CcbCDocu.CodMon = CcbCMvto.CodMon 
                CcbCDocu.CodRef = CcbDMvto.CodDoc  
                CcbCDocu.NroRef = CcbDMvto.NroDoc 
                CcbCDocu.FchDoc = CcbDMvto.FchEmi
                CcbCDocu.FchVto = CcbDMvto.FchVto
                CcbCDocu.Glosa  = CcbCMvto.Glosa
                CcbCDocu.ImpTot = CcbDMvto.ImpTot 
                CcbCDocu.TpoCmb = CcbCMvto.TpoCmb
                CcbCDocu.CodDpto = CcbCMvto.CodDpto
                CcbCDocu.CodProv = CcbCMvto.CodProv
                CcbCDocu.CodDist = CcbCMvto.CodDist
                CcbCDocu.usuario= S-USER-ID.
            FIND gn-clie WHERE 
                 gn-clie.CodCia = cl-codcia AND
                 gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN  CcbCDocu.NomCli = gn-clie.NomCli.
        END.
        ASSIGN
            Ccbcdocu.flgest = 'A'     /* ANULADA */
            Ccbcdocu.flgubi = 'C'
            CcbCDocu.UsuAnu = s-user-id.
        RELEASE Ccbcdocu.
    END.

    IF CcbCMvto.FlgEst = "C" THEN DO:
        RUN Borra-Cancelaciones.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
        Ccbcmvto.FlgEst = "A"
        Ccbcmvto.Glosa  = '**** Documento Anulado ****'.
    /*RUN Borra-Documento.   */
    FIND CURRENT Ccbcmvto NO-LOCK NO-ERROR.
  END.
  RUN Procesa-Handle IN lh_Handle ('Browse').
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  IF AVAILABLE Ccbcmvto THEN DO WITH FRAME {&FRAME-NAME}:
    x-NomCli:SCREEN-VALUE = ''.
    FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
        AND Gn-clie.codcli = CcbCMvto.CodCli NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-clie THEN x-NomCli:SCREEN-VALUE = Gn-clie.nomcli.
    CASE Ccbcmvto.flgest:
        WHEN 'C' THEN x-Estado:SCREEN-VALUE = 'CANJEADO'.
        WHEN 'P' THEN x-Estado:SCREEN-VALUE = 'EMITIDO'.
        WHEN 'A' THEN x-Estado:SCREEN-VALUE = 'ANULADO'.
        WHEN 'E' THEN x-Estado:SCREEN-VALUE = 'ANTIGUO'.
        OTHERWISE x-Estado:SCREEN-VALUE = '???'.
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
        CcbCMvto.FchDoc:SENSITIVE = NO
        CcbCMvto.NroDoc:SENSITIVE = NO.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO'
    THEN ASSIGN
            CcbCMvto.CodCli:SENSITIVE = NO.
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
  IF Ccbcmvto.FlgEst <> 'C' THEN RETURN.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    MESSAGE
        "¿Desea Imprimir Letras?"
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOGICAL.
    IF rpta THEN RUN ccb\p-implet(ROWID(CCBCMVTO)).
    ELSE RUN CCB\R-RELETR.R(ROWID(CCBCMVTO)).

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
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
   
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  IF s-Renumera-Letras THEN DO:
      MESSAGE 'Las letras han sido renumeradas automáticamente'
          VIEW-AS ALERT-BOX WARNING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-de-Documento V-table-Win 
PROCEDURE Numero-de-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER L-INCREMENTA AS LOGICAL.
  IF L-INCREMENTA THEN
     FIND FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
    
  IF AVAILABLE FacCorre THEN DO:
     ASSIGN I-NroDoc = FacCorre.Correlativo.
     IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  RELEASE FacCorre.

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
  {src/adm/template/snd-list.i "CcbCMvto"}

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
  IF p-state = 'update-begin':U THEN DO:
     RUN Actualiza-Deta.
     RUN Carga-Importe.
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
  END.  

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
  DEFINE VAR s-impori AS DECIMAL NO-UNDO.
  DEFINE VAR s-implet AS DECIMAL NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF CcbCMvto.CodCli:SCREEN-VALUE = "" THEN DO:
        MESSAGE 'Codigo de Cliente en blanco' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO CcbCMvto.CodCli.
        RETURN 'ADM-ERROR'.
    END.
    FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
        AND Gn-clie.codcli = CcbCMvto.CodCli:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-clie THEN DO:
        MESSAGE 'Cliente no registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.        
    s-impori = DECIMAL(CcbCMvto.ImpTot:SCREEN-VALUE).
    s-implet = 0.
    FOR EACH MVTO:
        IF MVTO.TpoRef = 'L' THEN s-implet = s-implet + MVTO.ImpTot.
    END.
    IF s-implet = 0 OR s-impori <> s-implet THEN DO:
        MESSAGE 'Verificar el importe total de letras' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO CcbCMvto.Glosa.
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
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE ccbcmvto THEN RETURN "ADM-ERROR".
RETURN 'ADM-ERROR'.   /* No debe permitir realizar modificaciones  */

IF Ccbcmvto.flgest <> 'P' THEN RETURN "ADM-ERROR".
s-tpocmb = FacCfgGn.Tpocmb[1].
s-codcli = Ccbcmvto.codcli.
s-codmon = Ccbcmvto.codmon.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Anulacion V-table-Win 
PROCEDURE Verifica-Anulacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR s-resp AS CHAR NO-UNDO.
  s-resp = ''.

  FOR EACH CcbCDocu NO-LOCK WHERE 
      CcbCDocu.CodCia = CcbCMvto.CodCia AND
      CcbCDocu.CodDoc = 'LET' AND
      CcbCDocu.CodRef = CcbCMvto.CodDoc AND
      CcbCDocu.NroRef = CcbCMvto.NroDoc:
      IF Ccbcdocu.FlgEst <> 'P' THEN DO:
          s-resp = 'NO'.
        LEAVE.
    END.
    IF NOT (CcbCDocu.FlgEst = 'P' AND CcbCDocu.FlgUbi = 'C') THEN DO:
        s-resp = 'NO'.
        LEAVE.
    END.
    IF CcbCDocu.FlgSit <> '' THEN DO:
        s-resp = 'NO'.
        LEAVE.
    END.
  END.
  IF s-resp = 'No' THEN DO:
    MESSAGE 'Las letras registras amortizaciones' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

