&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR CcbCDocu.



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

/* Shared Variable Definitions ---                                       */

DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE cl-codcia  AS INT.
DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.
DEFINE SHARED VARIABLE S-NROSER   AS INT.

DEFINE SHARED VARIABLE S-PORDTO AS DEC.
DEFINE SHARED VARIABLE S-PORIGV AS DEC.
DEFINE SHARED VARIABLE s-Sunat-Activo AS LOG.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE R-NRODEV       AS ROWID     NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-CODCLI       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 


FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.FlgEst = YES NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* ICBPER */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.

/* DEFINE VAR x-nueva-arimetica-sunat-2021 AS LOG. */
/*                                                 */
/* x-nueva-arimetica-sunat-2021 = YES.             */
/*                                                 */

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.RucCli CcbCDocu.DirCli ~
CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.RucCli CcbCDocu.DirCli ~
CcbCDocu.TpoCmb CcbCDocu.Glosa CcbCDocu.CodMon CcbCDocu.CodRef ~
CcbCDocu.NroRef 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu


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
     CcbCDocu.NroDoc AT ROW 1.19 COL 12 COLON-ALIGNED
          LABEL "Número" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .81
          FONT 0
     CcbCDocu.FchDoc AT ROW 1.19 COL 70 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodCli AT ROW 1.96 COL 12 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbCDocu.NomCli AT ROW 1.96 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     CcbCDocu.RucCli AT ROW 1.96 COL 70 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbCDocu.DirCli AT ROW 2.73 COL 12 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     CcbCDocu.TpoCmb AT ROW 2.73 COL 70 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     CcbCDocu.Glosa AT ROW 3.5 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.72 BY .81
     CcbCDocu.CodMon AT ROW 3.5 COL 72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 16.86 BY .81
     CcbCDocu.CodRef AT ROW 4.27 COL 12 COLON-ALIGNED
          LABEL "Referencia"
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .81
     CcbCDocu.NroRef AT ROW 4.27 COL 18 COLON-ALIGNED NO-LABEL FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 13.29 BY .81
          FONT 0
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.69 COL 66 WIDGET-ID 8
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
      TABLE: B-CDocu B "?" ? INTEGRAL CcbCDocu
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
         HEIGHT             = 7.12
         WIDTH              = 98.43.
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
/* SETTINGS FOR RADIO-SET CcbCDocu.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
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
FOR EACH DETA:
    DELETE DETA.
END.
IF NOT L-CREA THEN DO:
   FOR EACH CcbDDocu WHERE CcbDDocu.CodCia = CcbCDocu.CodCia
                      AND  CcbDDocu.CodDoc = CcbCDocu.CodDoc
                      AND  CcbDDocu.NroDoc = CcbCDocu.NroDoc
                     NO-LOCK:
       CREATE DETA.
       ASSIGN DETA.CodCia = CcbDDocu.CodCia
              DETA.codmat = CcbDDocu.codmat 
              DETA.PreUni = CcbDDocu.PreUni 
              DETA.CanDes = CcbDDocu.CanDes 
              DETA.Factor = CcbDDocu.Factor 
              DETA.ImpIsc = CcbDDocu.ImpIsc
              DETA.ImpIgv = CcbDDocu.ImpIgv 
              DETA.ImpLin = CcbDDocu.ImpLin
              DETA.PorDto = CcbDDocu.PorDto 
              DETA.PreBas = CcbDDocu.PreBas 
              DETA.ImpDto = CcbDDocu.ImpDto
              DETA.AftIgv = CcbDDocu.AftIgv
              DETA.AftIsc = CcbDDocu.AftIsc
              DETA.UndVta = CcbDDocu.UndVta.
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
FOR EACH CcbDDocu WHERE CcbDDocu.CodCia = CcbCDocu.CodCia
    AND  CcbDDocu.CodDoc = CcbCDocu.CodDoc 
    AND  CcbDDocu.NroDoc = CcbCDocu.NroDoc:
    DELETE CcbDDocu.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO ON ERROR UNDO, RETURN "ADM-ERROR":
   RUN Borra-Documento. 
   FOR EACH DETA ON ERROR UNDO, RETURN "ADM-ERROR":
       CREATE CcbDDocu.
       ASSIGN CcbDDocu.CodCia = CcbCDocu.CodCia 
              CcbDDocu.Coddiv = CcbCDocu.Coddiv 
              CcbDDocu.CodDoc = CcbCDocu.CodDoc 
              CcbDDocu.NroDoc = CcbCDocu.NroDoc
              CcbDDocu.codmat = DETA.codmat 
              CcbDDocu.PreUni = DETA.PreUni 
              CcbDDocu.CanDes = DETA.CanDes 
              CcbDDocu.Factor = DETA.Factor 
              CcbDDocu.ImpIsc = DETA.ImpIsc
              CcbDDocu.ImpIgv = DETA.ImpIgv 
              CcbDDocu.ImpLin = DETA.ImpLin
              CcbDDocu.PorDto = DETA.PorDto 
              CcbDDocu.PreBas = DETA.PreBas 
              CcbDDocu.ImpDto = DETA.ImpDto
              CcbDDocu.AftIgv = DETA.AftIgv
              CcbDDocu.AftIsc = DETA.AftIsc
              CcbDDocu.UndVta = DETA.UndVta
              CcbDDocu.Por_Dsctos[1] = DETA.Por_Dsctos[1]
              CcbDDocu.Por_Dsctos[2] = DETA.Por_Dsctos[2]
              CcbDDocu.Por_Dsctos[3] = DETA.Por_Dsctos[3]
              CcbDDocu.Flg_factor = DETA.Flg_factor
              CcbDDocu.ImpCto     = DETA.ImpCto.
   END.
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

{vta/graba-totales-abono.i}

&IF {&ARITMETICA-SUNAT} &THEN
    DEF VAR hProc AS HANDLE NO-UNDO.
    DEFINE VAR pMensaje AS CHAR NO-UNDO.

    RUN sunat/sunat-calculo-importes.r PERSISTENT SET hProc.
    RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                                 INPUT Ccbcdocu.CodDoc,
                                 INPUT Ccbcdocu.NroDoc,
                                 OUTPUT pMensaje).

    DELETE PROCEDURE hProc.

    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
&ENDIF

/* BLOQUEADO 13.08.10
FIND B-CDOCU WHERE B-CDOCU.codcia = CcbCDocu.codcia 
              AND  B-CDOCU.Coddoc = CcbCdocu.coddoc 
              AND  B-CDOCU.NroDoc = CcbCdocu.nrodoc 
             EXCLUSIVE-LOCK NO-ERROR.
     
IF AVAILABLE B-CDOCU THEN DO ON ERROR UNDO, RETURN "ADM-ERROR":
   ASSIGN 
      B-CDOCU.ImpBrt = 0
      B-CDOCU.ImpDto = 0
      B-CDOCU.ImpIgv = 0
      B-CDOCU.ImpTot = 0
      B-CDOCU.ImpVta = 0.
   FOR EACH DETA:
       ASSIGN
          B-CDOCU.ImpExo = B-CDOCU.ImpExo + IF DETA.AftIgv = No  THEN (DETA.PreUni * DETA.CanDes) ELSE 0
          B-CDOCU.ImpDto = B-CDOCU.ImpDto + DETA.ImpDto
          B-CDOCU.ImpIgv = B-CDOCU.ImpIgv + DETA.ImpIgv
          B-CDOCU.ImpTot = B-CDOCU.ImpTot + DETA.ImpLin.
          B-CDOCU.ImpCto = B-CDOCU.ImpCto + DETA.ImpCto.
       IF DETA.AftIgv = Yes THEN 
          ASSIGN
             B-CDOCU.ImpBrt = B-CDOCU.ImpBrt + (DETA.PreUni * DETA.CanDes)
             B-CDOCU.ImpVta = B-CDOCU.ImpVta + ((DETA.PreUni * DETA.CanDes) - (DETA.ImpIgv + DETA.ImpDto)).

   END.
   FIND FIRST FacCfgGn NO-LOCK NO-ERROR.
   ASSIGN
      B-CDOCU.SdoAct = B-CDOCU.ImpTot
      B-CDOCU.ImpTot2= B-CDOCU.ImpTot
      B-CDOCU.ImpIgv = B-CDOCU.ImpTot - (B-CDOCU.ImpTot / (1 + (FacCfgGn.PorIgv / 100)))
      B-CDOCU.ImpBrt = B-CDOCU.ImpTot - (B-CDOCU.ImpIgv  ) + B-CDOCU.ImpDto
      B-CDOCU.ImpVta = B-CDOCU.ImpBrt - B-CDOCU.ImpDto.

    /****   Add by C.Q. 04/02/2000  ****/
    IF B-CDOCU.PorDto > 0 THEN DO:
       B-CDOCU.ImpDto = B-CDOCU.ImpDto + ROUND(B-CDOCU.ImpTot * B-CDOCU.PorDto / 100,2).
       B-CDOCU.ImpTot = ROUND(B-CDOCU.ImpTot * (1 - B-CDOCU.PorDto / 100),2).
       B-CDOCU.ImpVta = ROUND(B-CDOCU.ImpTot / (1 + B-CDOCU.PorIgv / 100),2).
       B-CDOCU.ImpIgv = B-CDOCU.ImpTot - B-CDOCU.ImpVta.
       B-CDOCU.ImpBrt = B-CDOCU.ImpTot - B-CDOCU.ImpIgv - B-CDOCU.ImpIsc + 
                  B-CDOCU.ImpDto - B-CDOCU.ImpExo.
       B-CDOCU.SdoAct = B-CDOCU.ImpTot.
       B-CDOCU.ImpTot2= B-CDOCU.ImpTot.
    END.
    /***********************************/

END.
RELEASE B-CDOCU.
*************************************************** */
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
/*   DEF VAR pStatus AS LOG.                                                 */
/*   RUN sunat\p-inicio-actividades (INPUT Ccbcdocu.fchdoc, OUTPUT pStatus). */
/*   IF pStatus = YES THEN DO:     /* Ya iniciaron las actividades */        */
  IF s-Sunat-Activo = YES THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  /* ********************************************* */
  
  IF CcbCDocu.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se encuentra anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.SdoAct < CcbCDocu.ImpTot  THEN DO:
      MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
  END.
  /* consistencia de la fecha del cierre del sistema */
  DEF VAR dFchCie AS DATE.
  RUN gn/fecha-de-cierre (OUTPUT dFchCie).
  IF ccbcdocu.fchdoc <= dFchCie THEN DO:
      MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  /* fin de consistencia */
  {adm/i-DocPssw.i ccbcdocu.CodCia ccbcdocu.CodDoc ""DEL""}

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
       /* Motivo de anulacion */
       DEF VAR cReturnValue AS CHAR NO-UNDO.
       RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
       IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       /* ******************* */
       FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
           AND Faccpedi.coddoc = CcbCDocu.CodPed 
           AND Faccpedi.nroped = CcbCDocu.NroPed
           EXCLUSIVE-LOCK NO-ERROR.
       IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN "ADM-ERROR".
       /* EXTORNA CONTROL DE PERCEPCIONES POR ABONOS */
       FOR EACH B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
           AND B-CDOCU.coddiv = Ccbcdocu.coddiv
           AND B-CDOCU.coddoc = "PRA"
           AND B-CDOCU.codref = Ccbcdocu.codped
           AND B-CDOCU.nroref = Ccbcdocu.nroped:
           DELETE B-CDOCU.
       END.
       /* ****************************************** */
       RUN Borra-Documento.   
       /* ****************************************** */
       FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(CcbCDocu) NO-ERROR.
       IF AVAILABLE B-CDOCU THEN 
           ASSIGN 
           B-CDOCU.FlgEst = "A"
           B-CDOCU.SdoAct = 0 
           B-CDOCU.Glosa  = '**** Documento Anulado ****'
           B-CDOCU.UsuAnu = S-USER-ID.
       /* *************** ANULAMOS LA N/C EN EL SPEED **************** */
       RUN sypsa/anular-comprobante (ROWID(Ccbcdocu)).
       IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
       /* APERTURAMOS HOJA DE CALCULO */
       IF NOT CAN-FIND(FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                       AND LOOKUP(Ccbcdocu.coddoc, "N/C,N/D") > 0
                       AND Ccbcdocu.codped = Faccpedi.coddoc
                       AND Ccbcdocu.nroped = Faccpedi.nroped
                       AND Ccbcdocu.flgest <> "A" NO-LOCK)
           THEN DO:
           ASSIGN
               Faccpedi.FlgEst = "P"
               FacCPedi.FchAprobacion = TODAY
               FacCPedi.UsrAprobacion = s-user-id.
       END.
  END.
  IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
  IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDOCU.

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  IF Ccbcdocu.FlgEst = "A" THEN RETURN.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
     FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                    AND  FacCorre.CodDoc = S-CODDOC 
                    AND  FacCorre.CodDiv = S-CODDIV 
                    AND  FacCorre.NroSer = s-NroSer
                   EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                    AND  FacCorre.CodDoc = S-CODDOC 
                    AND  FacCorre.CodDiv = S-CODDIV 
                    AND  FacCorre.NroSer = s-NroSer
                   NO-LOCK NO-ERROR.
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

MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
RETURN 'ADM-ERROR'. /* No se puede realizar modificaciones */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

