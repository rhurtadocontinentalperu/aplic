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

/* Shared Variable Definitions ---                                       */

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR INITIAL 'CJE'.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-FCHDOC   AS DATE.
DEFINE SHARED TEMP-TABLE MVTO LIKE CcbDMvto.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR. 
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.
DEFINE SHARED VARIABLE cl-codcia  AS INT.

S-CODMON = 1.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 
DEFINE VARIABLE s-Renumera-Letras AS LOG NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS CcbCMvto.CodCli CcbCMvto.TpoCmb ~
CcbCMvto.CodMon CcbCMvto.Glosa 
&Scoped-define ENABLED-TABLES CcbCMvto
&Scoped-define FIRST-ENABLED-TABLE CcbCMvto
&Scoped-Define ENABLED-OBJECTS RECT-19 
&Scoped-Define DISPLAYED-FIELDS CcbCMvto.NroDoc CcbCMvto.FchDoc ~
CcbCMvto.CodCli CcbCMvto.TpoCmb CcbCMvto.CodMon CcbCMvto.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCMvto
&Scoped-define FIRST-DISPLAYED-TABLE CcbCMvto
&Scoped-Define DISPLAYED-OBJECTS x-Estado FILL-IN_NomCli FILL-IN_DirCli 

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
DEFINE VARIABLE FILL-IN_DirCli AS CHARACTER FORMAT "x(60)" 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 44.72 BY .69.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 32.14 BY .69.

DEFINE VARIABLE x-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 3.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCMvto.NroDoc AT ROW 1.12 COL 11.86 COLON-ALIGNED
          LABEL "Canje"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     x-Estado AT ROW 1.12 COL 26 COLON-ALIGNED NO-LABEL
     CcbCMvto.FchDoc AT ROW 1.19 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCMvto.CodCli AT ROW 1.77 COL 11.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     FILL-IN_NomCli AT ROW 1.77 COL 24.43 COLON-ALIGNED NO-LABEL
     CcbCMvto.TpoCmb AT ROW 1.96 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .69
     FILL-IN_DirCli AT ROW 2.46 COL 11.86 COLON-ALIGNED
     CcbCMvto.CodMon AT ROW 2.69 COL 67.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Nuevos Soles", 1,
"Dólares", 2
          SIZE 12.57 BY 1.15
     CcbCMvto.Glosa AT ROW 3.15 COL 11.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.86 BY .69
     "Moneda" VIEW-AS TEXT
          SIZE 6.72 BY .5 AT ROW 3.08 COL 59.86
     RECT-19 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCMvto
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
         HEIGHT             = 3.19
         WIDTH              = 84.57.
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

/* SETTINGS FOR FILL-IN CcbCMvto.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DirCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN x-Estado IN FRAME F-Main
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
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
       gn-clie.CodCli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
     MESSAGE 'Codigo de Cliente no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY gn-clie.NomCli @ FILL-IN_NomCli
             gn-clie.DirCli @ FILL-IN_DirCli.
  END.
  s-fchdoc = DATE(CcbCMvto.FchDoc:SCREEN-VALUE).
  s-codcli = CcbCMvto.Codcli:SCREEN-VALUE.
  s-codmon = INTEGER(CcbCMvto.CodMon:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodMon V-table-Win
ON VALUE-CHANGED OF CcbCMvto.CodMon IN FRAME F-Main /* Moneda */
DO:
   S-CodMon = INTEGER(CcbCMvto.CodMon:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.TpoCmb V-table-Win
ON LEAVE OF CcbCMvto.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
  S-TPOCMB = DECIMAL(CcbCMvto.TpoCmb:SCREEN-VALUE).
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
IF NOT L-CREA THEN DO:
   FOR EACH CcbDMvto WHERE 
            CcbDMvto.CodCia = CcbCMvto.CodCia 
        AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        AND CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK:
       CREATE MVTO.
       ASSIGN MVTO.CodCia = CcbDMvto.CodCia
              MVTO.CodDoc = CcbDMvto.CodDoc
              MVTO.TpoRef = CcbDMvto.TpoRef
              MVTO.CodRef = CcbDMvto.CodRef
              MVTO.NroRef = CcbDMvto.NroRef
              MVTO.FchEmi = CcbDMvto.FchEmi
              MVTO.FchVto = CcbDMvto.FchVto
              MVTO.ImpTot = CcbDMvto.ImpTot.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobacion-Canje V-table-Win 
PROCEDURE Aprobacion-Canje :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT AVAILABLE CcbCMvto THEN RETURN "ADM-ERROR".
  
  MESSAGE 'Canje de documentos aprobado ' SKIP
          'Desea Realmente Aprobrar este Canje' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO TITLE 'Aprobación' UPDATE s-resp AS LOGICAL.
   
  IF s-resp = Yes THEN RUN ccb/cjeaprob.p(ROWID(CcbCMvto)).
   
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
DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
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
                /* RHC 19.03.10 YA se estan marcando como ANULADAS 
                 IF AVAILABLE CcbCDocu THEN DELETE CcbCDocu.
                */
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
DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
   FOR EACH CcbDMvto WHERE 
          CcbDMvto.CodCia = CcbCMvto.CodCia AND
          CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
          CcbDMvto.NroDoc = CcbCMvto.NroDoc:
       IF Ccbdmvto.TpoRef = 'O' THEN DO:
           FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
               AND Ccbcdocu.coddoc = Ccbdmvto.codref
               AND Ccbcdocu.nrodoc = Ccbdmvto.nroref
               EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE Ccbcdocu THEN DO:
               ASSIGN
                   Ccbcdocu.FlgSit = Ccbcdocu.FlgSitA
                   Ccbcdocu.FlgSitA = ''.
               RELEASE Ccbcdocu.
           END.
       END.
       /*DELETE CcbDMvto.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    RUN Borra-Documento. 
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
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
    s-Renumera-Letras = NO.
    FOR EACH MVTO BY MVTO.codref BY MVTO.nroref:
        CREATE CcbDMvto.
        ASSIGN CcbDMvto.CodCia = CcbCMvto.CodCia 
               CcbDMvto.CodDoc = CcbCMvto.CodDoc 
               CcbDMvto.NroDoc = CcbCMvto.NroDoc
               CcbDMvto.CodCli = CcbCMvto.CodCli
               CcbDMvto.TpoRef = MVTO.TpoRef
               CcbDMvto.CodRef = MVTO.CodRef
               CcbDMvto.NroRef = MVTO.NroRef
               CcbDMvto.FchEmi = MVTO.FchEmi
               CcbDMvto.FchVto = MVTO.FchVto
               CcbDMvto.ImpDoc = MVTO.ImpTot
               CcbDMvto.ImpTot = MVTO.ImpTot
               CcbDMvto.CodDpto = CcbCMvto.CodDpto
               CcbDMvto.CodProv = CcbCMvto.CodProv
               CcbDMvto.CodDist = CcbCMvto.CodDist.
        IF MVTO.TpoRef = "O" THEN DO:
            FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                AND Ccbcdocu.coddoc = Ccbdmvto.codref
                AND Ccbcdocu.nrodoc = Ccbdmvto.nroref
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcdocu THEN DO:
                MESSAGE 'No se pudo bloquear la' Ccbdmvto.codref Ccbdmvto.nroref
                    VIEW-AS ALERT-BOX ERROR.
                UNDO, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                Ccbcdocu.FlgSitA = Ccbcdocu.FlgSit
                Ccbcdocu.FlgSit = 'X'.   /* Canje pendiente */
        END.
        IF MVTO.TpoRef = "L" THEN DO:
            ASSIGN
                CcbDMvto.NroRef = STRING(FacCorre.NroSer, '999') + 
                                 STRING(FacCorre.Correlativo, '999999').
            ASSIGN
                Faccorre.correlativo = Faccorre.correlativo + 1.
            IF MVTO.NroRef <> CCbdmvto.NroRef THEN s-Renumera-Letras = YES.
        END.
    END.
END.

   
END PROCEDURE.

/*
    FOR EACH MVTO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
        CREATE CcbDMvto.
        ASSIGN CcbDMvto.CodCia = CcbCMvto.CodCia 
               CcbDMvto.CodDoc = CcbCMvto.CodDoc 
               CcbDMvto.NroDoc = CcbCMvto.NroDoc
               CcbDMvto.CodCli = CcbCMvto.CodCli
               CcbDMvto.TpoRef = MVTO.TpoRef
               CcbDMvto.CodRef = MVTO.CodRef
               CcbDMvto.NroRef = MVTO.NroRef
               CcbDMvto.FchEmi = MVTO.FchEmi
               CcbDMvto.FchVto = MVTO.FchVto
               CcbDMvto.ImpDoc = MVTO.ImpTot
               CcbDMvto.ImpTot = MVTO.ImpTot
               CcbDMvto.CodDpto = CcbCMvto.CodDpto
               CcbDMvto.CodProv = CcbCMvto.CodProv
               CcbDMvto.CodDist = CcbCMvto.CodDist.
        IF Ccbdmvto.TpoRef = 'O' THEN DO:
            FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                AND Ccbcdocu.coddoc = Ccbdmvto.codref
                AND Ccbcdocu.nrodoc = Ccbdmvto.nroref
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE Ccbcdocu THEN DO:
                ASSIGN
                    Ccbcdocu.FlgSitA = Ccbcdocu.FlgSit
                    Ccbcdocu.FlgSit = 'X'.   /* Canje pendiente */
                RELEASE Ccbcdocu.
            END.
        END.
    END.
*/

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

DO ON ERROR UNDO, RETURN "ADM-ERROR":
    FIND B-CMVTO WHERE 
         B-CMVTO.codcia = CcbCMvto.codcia AND
         B-CMVTO.Coddoc = CcbCMvto.coddoc AND
         B-CMVTO.NroDoc = CcbCMvto.nrodoc EXCLUSIVE-LOCK NO-ERROR.
         
    IF AVAILABLE B-CMVTO THEN DO:
       ASSIGN
           B-CMVTO.ImpDoc = 0
           B-CMVTO.ImpTot = 0.
       FOR EACH MVTO BREAK BY MVTO.CodDoc BY MVTO.NroDoc:
          IF MVTO.TpoRef = 'L' THEN DO:
             s-canlet = s-canlet + 1.
             s-nrolet = INTEGER(SUBSTRING(MVTO.NroRef, 4)). 
             ASSIGN
                B-CMVTO.ImpDoc = B-CMVTO.ImpDoc + MVTO.ImpDoc
                B-CMVTO.ImpTot = B-CMVTO.ImpTot + MVTO.ImpTot.
          END.
       END.
    END.
    
    FIND FIRST FacCorre WHERE 
         FacCorre.CodCia = S-CODCIA AND
         FacCorre.CodDoc = 'LET' AND
         FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN DO:
       ASSIGN FacCorre.Correlativo = IF FacCorre.Correlativo > s-nrolet THEN
                                     FacCorre.Correlativo ELSE s-nrolet + 1.
    END.
    RELEASE FacCorre.
    
    ASSIGN  B-CMVTO.NroLet = s-canlet.      
    
    RELEASE B-CMVTO.
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
  L-CREA = YES.
  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ CcbCMvto.FchDoc
             S-CODCLI @ CcbCMvto.CodCli
             FacCfgGn.Tpocmb[1] @ CcbCMvto.TpoCmb
             STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ CcbCMvto.NroDoc.
     s-tpocmb = FacCfgGn.Tpocmb[1].
     s-codmon = INTEGER(CcbCMvto.CodMon:SCREEN-VALUE).
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  IF L-CREA THEN DO WITH FRAME {&FRAME-NAME}:
     RUN Numero-de-Documento(YES).
     ASSIGN CcbCMvto.CodCia = S-CODCIA
            CcbCMvto.FlgEst = "P"
            CcbCMvto.CodDoc = S-CODDOC
            CcbCMvto.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999")
            CcbCMvto.usuario = S-USER-ID
            CcbCMvto.CodDiv  = S-CODDIV.
     DISPLAY CcbCMvto.NroDoc.
  END.
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
       gn-clie.CodCli = CcbCMvto.CodCli NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN DO:
     ASSIGN CcbCMvto.CodDpto = gn-clie.CodDept 
            CcbCMvto.CodProv = gn-clie.CodProv 
            CcbCMvto.CodDist = gn-clie.CodDist.
  END.
  
  RUN Genera-Detalle.   
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  RUN Graba-Totales.

  IF AVAILABLE (ccbcdocu) THEN RELEASE ccbcdocu.
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
-----------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
   IF CcbCMvto.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se enuentra anulado...' VIEW-AS ALERT-BOX
               INFORMATION.
      RETURN 'ADM-ERROR'.
   END.  
   IF CcbCMvto.FlgEst = 'E' THEN DO:
      RUN Verifica-Anulacion.
      IF RETURN-VALUE = "ADM-ERROR" THEN DO :
         MESSAGE "No se puede anular el Canje de Documentos por Letras"
                  VIEW-AS ALERT-BOX ERROR.
         RETURN "ADM-ERROR".
      END.   
   END.
   /* consistencia de la fecha del cierre del sistema */
/*    DEF VAR dFchCie AS DATE.                                                            */
/*    RUN gn/fecha-de-cierre (OUTPUT dFchCie).                                            */
/*    IF ccbcmvto.fchdoc <= dFchCie THEN DO:                                              */
/*        MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1) */
/*            VIEW-AS ALERT-BOX WARNING.                                                  */
/*        RETURN 'ADM-ERROR'.                                                             */
/*    END.                                                                                */
   /* fin de consistencia */

   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
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

       IF CcbCMvto.FlgEst = "E" THEN RUN Borra-Cancelaciones.
       RUN Borra-Documento.   
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       FIND B-CMVTO WHERE ROWID(B-CMVTO) = ROWID(CcbCMvto) EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE B-CMVTO 
       THEN ASSIGN 
           B-CMVTO.FlgEst = "A"
           B-CMVTO.Glosa  = '**** Documento Anulado ****'
           B-CMVTO.ImpTot = 0
           B-CMVTO.ImpDoc = 0.
       RELEASE B-CMVTO.
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
  IF AVAILABLE CcbCMvto THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = CcbCMvto.CodCli NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN 
        DISPLAY gn-clie.NomCli @ FILL-IN_NomCli 
                gn-clie.DirCli @ FILL-IN_DirCli.
    CASE Ccbcmvto.flgest:
        WHEN 'P' THEN x-Estado:SCREEN-VALUE = 'POR APROBAR'.
        WHEN 'E' THEN x-Estado:SCREEN-VALUE = 'APROBADO'.
        WHEN 'A' THEN x-Estado:SCREEN-VALUE = 'ANULADO'.
        OTHERWISE x-Estado:SCREEN-VALUE = '???'.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /*RDP 01/12/2010 - No imprime letras
    IF CCBCMVTO.FLGEST <> "A" THEN
        MESSAGE
            "¿Desea Imprimir Letras?"
            VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOGICAL.
    IF rpta THEN RUN ccb\p-implet(ROWID(CCBCMVTO)).
    ELSE RUN CCB\R-RELETR.R(ROWID(CCBCMVTO)).
    */
    /*RDP 01/12/2010 Imprime Cargos*/
    IF CCBCMVTO.FLGEST <> "A" THEN 
        RUN CCB\R-RELETR.R(ROWID(CCBCMVTO)).

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
  s-fchdoc = TODAY.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND gn-tcmb WHERE gn-tcmb.fecha = s-fchdoc NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN 
     DO WITH FRAME {&FRAME-NAME}:
        DISPLAY gn-tcmb.compra @ integral.CcbCMvto.TpoCmb.
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
     L-CREA = NO.
     RUN Actualiza-Deta.
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
   s-impori = 0.
   s-implet = 0.
   FOR EACH MVTO:
       IF MVTO.TpoRef = 'O' THEN s-impori = s-impori + MVTO.ImpTot.
       IF MVTO.TpoRef = 'L' THEN s-implet = s-implet + MVTO.ImpTot.
   END.
   IF s-impori <> s-implet THEN DO:
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
RETURN "OK".

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

/* VERIFICAMOS EL ESTADO DE LA LETRA */

FOR EACH CcbCDocu NO-LOCK WHERE CcbCDocu.CodCia = CcbCMvto.CodCia 
    AND CcbCDocu.CodRef = CcbCMvto.CodDoc 
    AND CcbCDocu.NroRef = CcbCMvto.NroDoc:
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
   MESSAGE 'Las letras registran amortizaciones o están en trámite' VIEW-AS ALERT-BOX ERROR.
   RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

