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
DEFINE SHARED VARIABLE S-PERIODO  AS INTEGER.
DEFINE SHARED VARIABLE S-NROMES   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-FCHDOC   AS DATE.
DEFINE SHARED TEMP-TABLE MVTO LIKE CcbDMvto.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR. 
DEFINE SHARED VARIABLE S-CODPRO   AS CHAR. 
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.
S-CODMON = 1.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 

DEFINE VAR x-ctagan  AS CHAR NO-UNDO.
DEFINE VAR x-ctaper  AS CHAR NO-UNDO.
DEFINE VAR x-rndgan  AS CHAR NO-UNDO.
DEFINE VAR x-rndper  AS CHAR NO-UNDO.

DEFINE BUFFER B-CMvto FOR CcbCMvto.

DEFINE SHARED VAR cb-codcia AS INTEGER .
DEFINE SHARED VAR cl-codcia AS INTEGER .
DEFINE SHARED VAR pv-codcia AS INTEGER .

/* FIND Empresas WHERE Empresas.CodCia = s-codcia.         */
/* IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia. */
/* IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia. */
/* IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia. */

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN ASSIGN I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
     cb-cfgg.Codcfg = 'C01' NO-LOCK NO-ERROR.
IF AVAILABLE cb-Cfgg THEN
   ASSIGN
      x-ctagan = cb-cfgg.codcta[1] 
      x-ctaper = cb-cfgg.codcta[2].
ELSE DO:
   MESSAGE 'Configuracion de Cuentas de Redondeo no existe' VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
     cb-cfgg.Codcfg = 'RND' NO-LOCK NO-ERROR.
IF AVAILABLE cb-Cfgg THEN
   ASSIGN
      x-rndgan = cb-cfgg.codcta[1] 
      x-rndper = cb-cfgg.codcta[2].
ELSE DO:
   MESSAGE 'Configuracion de Cuentas de Redondeo no existe' VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

DEFINE TEMP-TABLE T-DMOV LIKE CB-DMOV.

DEFINE VAR p-codope  AS CHAR NO-UNDO.
DEFINE VAR p-nroast  AS CHAR NO-UNDO.
DEFINE VAR s-NroMesCie AS LOGICAL NO-UNDO.

DEFINE STREAM report.

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
&Scoped-Define ENABLED-FIELDS CcbCMvto.CodDiv CcbCMvto.FchDoc ~
CcbCMvto.CodCli CcbCMvto.TpoCmb CcbCMvto.CodProv CcbCMvto.CodMon ~
CcbCMvto.Glosa 
&Scoped-define ENABLED-TABLES CcbCMvto
&Scoped-define FIRST-ENABLED-TABLE CcbCMvto
&Scoped-Define ENABLED-OBJECTS RECT-19 
&Scoped-Define DISPLAYED-FIELDS CcbCMvto.CodDiv CcbCMvto.NroDoc ~
CcbCMvto.FchDoc CcbCMvto.CodCli CcbCMvto.TpoCmb CcbCMvto.CodProv ~
CcbCMvto.CodMon CcbCMvto.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCMvto
&Scoped-define FIRST-DISPLAYED-TABLE CcbCMvto
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_NomCli x-NomPro F-Asiento ~
FILL-IN-Estado 

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
DEFINE VARIABLE F-Asiento AS CHARACTER FORMAT "X(256)":U 
     LABEL "Asiento" 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .69.

DEFINE VARIABLE x-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 4.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCMvto.CodDiv AT ROW 1.08 COL 44.86 COLON-ALIGNED
          LABEL "Divisionaria" FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 6.14 BY .69
     CcbCMvto.NroDoc AT ROW 1.15 COL 11.72 COLON-ALIGNED
          LABEL "Canje" FORMAT "999-999999"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .69
          FONT 1
     CcbCMvto.FchDoc AT ROW 1.19 COL 74.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCMvto.CodCli AT ROW 1.88 COL 11.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.29 BY .69
     FILL-IN_NomCli AT ROW 1.96 COL 24 COLON-ALIGNED NO-LABEL
     CcbCMvto.TpoCmb AT ROW 1.96 COL 74.14 COLON-ALIGNED
          LABEL "T.C."
          VIEW-AS FILL-IN 
          SIZE 8 BY .69
     CcbCMvto.CodProv AT ROW 2.69 COL 11.72 COLON-ALIGNED
          LABEL "Proveedor" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 12.29 BY .69
     CcbCMvto.CodMon AT ROW 2.69 COL 73.43 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Nuevos Soles", 1,
"Dolares", 2
          SIZE 12.57 BY 1.15
     x-NomPro AT ROW 2.73 COL 24 COLON-ALIGNED NO-LABEL
     CcbCMvto.Glosa AT ROW 3.5 COL 11.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51.29 BY .69
     F-Asiento AT ROW 4.23 COL 11.72 COLON-ALIGNED
     FILL-IN-Estado AT ROW 4.23 COL 72 COLON-ALIGNED WIDGET-ID 2
     "Moneda" VIEW-AS TEXT
          SIZE 6.72 BY .5 AT ROW 3.08 COL 66
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
         HEIGHT             = 4.58
         WIDTH              = 90.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCMvto.CodDiv IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCMvto.CodProv IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-Asiento IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCMvto.TpoCmb IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN x-NomPro IN FRAME F-Main
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
  /* Verifica que se encuentre registrado como proveedor */
/*  FIND gn-prov WHERE gn-prov.CodCia = 0 AND 
 *        gn-prov.Codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.*/
  FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
       gn-prov.Ruc = gn-clie.Ruc NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-prov THEN DO:
     MESSAGE 'Cliente no se encuentra registrado como Proveedor' VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY 
        gn-clie.NomCli @ FILL-IN_NomCli
        gn-prov.codpro @ CcbCMvto.CodProv
        gn-prov.nompro @ x-NomPro.
  END.
  s-fchdoc = DATE(CcbCMvto.FchDoc:SCREEN-VALUE).
  s-codcli = CcbCMvto.Codcli:SCREEN-VALUE.
  s-codpro = gn-prov.codpro.
  s-codmon = INTEGER(CcbCMvto.CodMon:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodDiv V-table-Win
ON LEAVE OF CcbCMvto.CodDiv IN FRAME F-Main /* Divisionaria */
DO:
  FIND GN-DIVI WHERE GN-DIVI.CodCia = s-codcia AND
       GN-DIVI.CodDiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-DIVI THEN DO:
     MESSAGE 'Divisionaria no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  S-CODDIV = SELF:SCREEN-VALUE.
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


&Scoped-define SELF-NAME CcbCMvto.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.FchDoc V-table-Win
ON LEAVE OF CcbCMvto.FchDoc IN FRAME F-Main /* Fecha */
DO:
    s-fchdoc = DATE(CcbCMvto.FchDoc:SCREEN-VALUE).
    FIND gn-tcmb WHERE gn-tcmb.FECHA = INPUT {&SELF-NAME}
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tcmb 
    THEN DO:
        IF cb-oper.TpoCmb = 1 
        THEN s-TpoCmb = gn-tcmb.Compra.
        ELSE s-TpoCmb = gn-tcmb.Venta.
    END.       
    ELSE MESSAGE "No existe Tipo de Cambio" SKIP
                 "para la fecha registrada" VIEW-AS ALERT-BOX.
    DISPLAY s-TpoCmb @ Ccbcmvto.tpocmb WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.TpoCmb V-table-Win
ON LEAVE OF CcbCMvto.TpoCmb IN FRAME F-Main /* T.C. */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Canje V-table-Win 
PROCEDURE Actualiza-Canje :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT AVAILABLE CcbCMvto THEN RETURN "ADM-ERROR".
  RUN ccb/cjeclpv.p(ROWID(CcbCMvto)).
  RUN Genera-Asiento.
  RUN Actualiza-Flag(TRUE).
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
       RAW-TRANSFER CcbDMvto TO MVTO.
/*       ASSIGN MVTO.CodCia = CcbDMvto.CodCia
              MVTO.CodDoc = CcbDMvto.CodDoc
              MVTO.TpoRef = CcbDMvto.TpoRef
              MVTO.CodRef = CcbDMvto.CodRef
              MVTO.NroRef = CcbDMvto.NroRef
              MVTO.FchEmi = CcbDMvto.FchEmi
              MVTO.FchVto = CcbDMvto.FchVto
              MVTO.ImpTot = CcbDMvto.ImpTot. */
   END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Flag V-table-Win 
PROCEDURE Actualiza-Flag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER X-Flag AS LOGICAL.
  FIND B-CMvto WHERE B-CMvto.codcia = s-codcia AND
       B-CMvto.Coddoc = CcbCMvto.Coddoc AND
       B-CMvto.Nrodoc = CcbCMvto.Nrodoc NO-ERROR.
  IF AVAILABLE B-CMvto THEN DO:
     ASSIGN
        B-CMvto.FlgCbd = X-Flag.
     IF X-Flag THEN
        ASSIGN
           B-CMvto.FchCbd = TODAY
           B-CMvto.Codope = p-codope
           B-CMvto.Nroast = p-nroast.
     ELSE
        ASSIGN
           B-CMvto.FchCbd = TODAY
           B-CMvto.Codope = ''
           B-CMvto.Nroast = ''.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-asto V-table-Win 
PROCEDURE Anula-asto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-mes     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.
DEFINE BUFFER C-DMOV FOR CB-DMOV.

FOR EACH CB-DMOV WHERE
    CB-DMOV.codcia  = p-codcia AND
    CB-DMOV.periodo = p-periodo AND
    CB-DMOV.nromes  = p-mes AND
    CB-DMOV.codope  = p-codope AND
    CB-DMOV.nroast  = p-nroast:
    FOR EACH C-DMOV WHERE C-DMOV.RELACION = RECID(CB-DMOV) :
        RUN cbd/cb-acmd.p(RECID(C-DMOV),NO,YES).
        DELETE C-DMOV.
    END.
    RUN cbd/cb-acmd.p(RECID(CB-DMOV),NO,YES).
    DELETE CB-DMOV.
END.

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
    /* Eliminar el documento cancelado en caja */
    FOR EACH CcbDCaja WHERE CcbDCaja.CodCia = CcbCMvto.CodCia 
        AND CcbDCaja.CodDoc = CcbCMvto.CodDoc 
        AND CcbDCaja.NroDoc = CcbCMvto.NroDoc:
        FIND CcbCDocu WHERE CcbCDocu.CodCia = Ccbdcaja.CodCia 
            AND CcbCDocu.CodDoc = Ccbdcaja.CodRef 
            AND CcbCDocu.NroDoc = Ccbdcaja.NroRef EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN DO:
            CcbCDocu.SdoAct = CcbCDocu.SdoAct + Ccbdcaja.ImpTot.
            CcbCDocu.FlgEst = IF CcbCDocu.SdoAct <= 0 THEN 'C' ELSE 'P'.
        END.
        RELEASE CcbCDocu.
        DELETE CcbDCaja.
    END.

/*     FOR EACH CcbDMvto NO-LOCK WHERE                                                                 */
/*              CcbDMvto.CodCia = CcbCMvto.CodCia AND                                                  */
/*              CcbDMvto.CodDoc = CcbCMvto.CodDoc AND                                                  */
/*              CcbDMvto.NroDoc = CcbCMvto.NroDoc AND                                                  */
/*              CcbDMvto.TpoRef = 'C':                                                                 */
/*         FIND CcbCDocu WHERE                                                                         */
/*              CcbCDocu.CodCia = CcbDMvto.CodCia AND                                                  */
/*              CcbCDocu.CodDoc = CcbDMvto.CodRef AND                                                  */
/*              CcbCDocu.NroDoc = CcbDMvto.NroRef EXCLUSIVE-LOCK NO-ERROR.                             */
/*         IF AVAILABLE CcbCDocu THEN DO:                                                              */
/*            IF CcbCDocu.CodMon = CcbCMvto.CodMon THEN                                                */
/*               ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct + CcbDMvto.ImpTot.                           */
/*            ELSE DO:                                                                                 */
/*               IF CcbCDocu.CodMon = 1 THEN                                                           */
/*                     ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct + (CcbDMvto.ImpTot * CcbCMvto.TpoCmb). */
/*               ELSE  ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct + (CcbDMvto.ImpTot / CcbCMvto.TpoCmb). */
/*            END.                                                                                     */
/*            ASSIGN                                                                                   */
/*                CcbCDocu.FlgEst = IF CcbCDocu.SdoAct = 0 THEN 'C' ELSE 'P'.                          */
/*         END.                                                                                        */
/*         RELEASE CcbCDocu.                                                                           */
/*     END.                                                                                            */
/*     /* Eliminar el documento cancelado en caja */                                                   */
/*     FOR EACH CcbDCaja WHERE                                                                         */
/*            CcbDCaja.CodCia = CcbCMvto.CodCia AND                                                    */
/*            CcbDCaja.CodDoc = CcbCMvto.CodDoc AND                                                    */
/*            CcbDCaja.NroDoc = CcbCMvto.NroDoc:                                                       */
/*            DELETE CcbDCaja.                                                                         */
/*     END.                                                                                            */
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
          DELETE CcbDMvto.
   END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Diferencia-Cambio V-table-Win 
PROCEDURE Diferencia-Cambio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER v-codcta AS CHAR.
DEFINE INPUT PARAMETER v-clfaux AS CHAR.
DEFINE INPUT PARAMETER v-codaux AS CHAR.
DEFINE INPUT PARAMETER v-coddoc AS CHAR.
DEFINE INPUT PARAMETER v-nrodoc AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER v-impmn1 AS DECIMAL.
DEFINE INPUT-OUTPUT PARAMETER v-impmn2 AS DECIMAL.

FOR EACH CB-DMOV WHERE CB-DMOV.codcia = s-codcia AND
    CB-DMOV.periodo = s-periodo AND CB-DMOV.codcta = v-codcta AND
    CB-DMOV.codaux = v-codaux AND CB-DMOV.coddoc = v-coddoc AND
    CB-DMOV.nrodoc = v-nrodoc NO-LOCK:
    IF NOT CB-DMOV.Tpomov THEN
       ASSIGN
          v-impmn1 = v-impmn1 + CB-DMOV.impmn1
          v-impmn2 = v-impmn2 + CB-DMOV.impmn2.   
    ELSE
       ASSIGN
          v-impmn1 = v-impmn1 - CB-DMOV.impmn1
          v-impmn2 = v-impmn2 - CB-DMOV.impmn2.   
END.
v-impmn1 = ROUND(v-impmn1, 2).
v-impmn2 = ROUND(v-impmn2, 2).
IF v-impmn1 <> 0 AND v-impmn1 <> 0 THEN
   ASSIGN
      v-impmn1 = 0
      v-impmn2 = 0.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Elimina-Asiento V-table-Win 
PROCEDURE Elimina-Asiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN anula-asto(
      s-codcia,
      s-periodo,
      s-nromes,
      CcbCMvto.Codope,
      CcbCMvto.nroast ). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Asiento V-table-Win 
PROCEDURE Genera-Asiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-nroast  AS INTE NO-UNDO.
DEFINE VAR p-fchast  AS DATE NO-UNDO.
DEFINE VAR d-uno     AS DECI NO-UNDO.
DEFINE VAR d-dos     AS DECI NO-UNDO.
DEFINE VAR h-uno     AS DECI NO-UNDO.
DEFINE VAR h-dos     AS DECI NO-UNDO.
DEFINE VAR x-genaut  AS INTE NO-UNDO.
DEFINE VAR I         AS INTE NO-UNDO.
DEFINE VAR J         AS INTE NO-UNDO.
DEFINE VAR x-codcta  AS CHAR NO-UNDO.
DEFINE VAR x-clfaux  AS CHAR NO-UNDO.
DEFINE VAR x-coddoc  AS LOGICAL NO-UNDO.
DEFINE VAR x-soles   AS DECIMAL NO-UNDO.
DEFINE VAR x-dolar   AS DECIMAL NO-UNDO.

FOR EACH T-DMOV: 
   DELETE T-DMOV.
END.

DEFINE BUFFER Detalle FOR CB-DMOV.

FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND
     FacDocum.CodDoc = S-CODDOC NO-LOCK NO-ERROR.
IF AVAILABLE FacDocum THEN p-codope = FacDocum.Codope.

FIND cb-cfga WHERE cb-cfga.codcia = cb-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
   BELL.
   MESSAGE "Plan de cuentas no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = CcbCMvto.CodCia AND
        CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
        CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK:
    CASE CcbDMvto.TpoRef :
       WHEN 'C' THEN DO:
            FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
                 CcbCDocu.CodDoc = CcbDMvto.Codref AND
                 CcbCDocu.Nrodoc = CcbDMvto.Nroref NO-LOCK NO-ERROR.
            FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND
                 FacDocum.CodDoc = CcbDMvto.Codref NO-LOCK NO-ERROR.
            IF AVAILABLE FacDocum THEN 
               x-codcta = IF CcbCDocu.Codmon = 1 THEN FacDocum.CodCta[1] ELSE FacDocum.CodCta[2].
            CREATE T-DMOV.
            ASSIGN
              T-DMOV.codcta  = x-codcta.
              T-DMOV.coddiv  = CcbCMvto.CodDiv.
              T-DMOV.Coddoc  = FacDocum.CodCbd.
/*              T-DMOV.Nrodoc  = STRING(CcbCDocu.Fchdoc, '99/99/9999').
 *               T-DMOV.codaux  = FacCfgGn.CliVar.*/
              T-DMOV.NroDoc  = CcbDMvto.NroRef.
              T-DMOV.CodAux  = CcbCMvto.CodCli.
              T-DMOV.GLODOC  = CcbCMvto.Glosa.
              T-DMOV.tpomov  = TRUE.
/*              T-DMOV.impmn1  = IF CcbCMvto.Codmon = 1 THEN CcbDMvto.ImpTot ELSE ROUND(CcbDMvto.ImpTot * CcbCMvto.Tpocmb, 2).
 *               T-DMOV.impmn2  = IF CcbCMvto.Codmon = 2 THEN CcbDMvto.ImpTot ELSE ROUND(CcbDMvto.ImpTot / CcbCMvto.Tpocmb, 2).
 *               T-DMOV.tpocmb  = CcbCMvto.tpocmb.*/
              T-DMOV.impmn1  = CcbDMvto.DepNac[1].
              T-DMOV.impmn2  = CcbDMvto.DepUsa[1].
              T-DMOV.tpocmb  = CcbDMvto.DepNac[1] / CcbDMvto.DepUsa[1].
              T-DMOV.FCHDOC  = CcbCMvto.Fchdoc.
              T-DMOV.FLGACT  = TRUE.
              T-DMOV.RELACION = 0.
              T-DMOV.codmon  = CcbCMvto.Codmon.
         END.
       WHEN 'P' THEN DO:
            CREATE T-DMOV.
            ASSIGN
              T-DMOV.codcta  = CcbDMvto.Codcta.
              T-DMOV.coddiv  = CcbCMvto.CodDiv.
              T-DMOV.Coddoc  = CcbDMvto.Codref.
              T-DMOV.Nrodoc  = CcbDMvto.Nroref.
              T-DMOV.codaux  = CcbCMvto.codprov.
              T-DMOV.GLODOC  = CcbCMvto.Glosa.
              T-DMOV.tpomov  = FALSE.
/*              T-DMOV.impmn1  = IF CcbCMvto.Codmon = 1 THEN CcbDMvto.ImpTot ELSE ROUND(CcbDMvto.ImpTot * CcbCMvto.Tpocmb, 2).
 *               T-DMOV.impmn2  = IF CcbCMvto.Codmon = 2 THEN CcbDMvto.ImpTot ELSE ROUND(CcbDMvto.ImpTot / CcbCMvto.Tpocmb, 2).
 *               T-DMOV.tpocmb  = CcbCMvto.tpocmb.*/
              T-DMOV.impmn1  = CcbDMvto.DepNac[1].
              T-DMOV.impmn2  = CcbDMvto.DepUsa[1].
              T-DMOV.tpocmb  = CcbDMvto.DepNac[1] / CcbDMvto.DepUsa[1].
              T-DMOV.FCHDOC  = CcbCMvto.Fchdoc.
              T-DMOV.FLGACT  = TRUE.
              T-DMOV.RELACION = 0.
              T-DMOV.codmon  = CcbCMvto.Codmon.
/*              x-soles = T-DMOV.impmn1.
 *               x-dolar = T-DMOV.impmn2.
 *             RUN Diferencia-Cambio (T-DMOV.codcta, '@PV', T-DMOV.codaux, T-dmov.Coddoc, T-dmov.Nrodoc,
 *                                    INPUT-OUTPUT x-soles, INPUT-OUTPUT x-dolar).
 *             IF x-soles <> 0 OR x-dolar <> 0 THEN DO:
 *               ASSIGN
 *                  T-DMOV.impmn1 = T-DMOV.impmn1 - x-soles
 *                  T-DMOV.impmn2 = T-DMOV.impmn2 - x-dolar.
 *               IF x-soles > 0 OR x-dolar > 0 THEN x-codcta = x-ctagan.
 *               ELSE x-codcta = x-ctaper.
 *               CREATE T-DMOV.
 *               ASSIGN
 *                 T-DMOV.codcta  = x-codcta.
 *                 T-DMOV.coddiv  = CcbCMvto.CodDiv.
 *                 T-DMOV.Coddoc  = CcbDMvto.Codref.
 *                 T-DMOV.Nrodoc  = CcbDMvto.Nroref.
 *                 T-DMOV.codaux  = CcbCMvto.codcli.
 *                 T-DMOV.GLODOC  = CcbCMvto.Glosa.
 *                 T-DMOV.tpomov  = IF x-soles > 0 OR x-dolar > 0 THEN FALSE ELSE TRUE.
 *                 T-DMOV.impmn1  = ABS(x-soles).
 *                 T-DMOV.impmn2  = ABS(x-dolar).
 *                 T-DMOV.FCHDOC  = CcbCMvto.Fchdoc.
 *                 T-DMOV.FLGACT  = TRUE.
 *                 T-DMOV.RELACION = 0.
 *                 T-DMOV.codmon  = CcbCMvto.Codmon.
 *                 T-DMOV.tpocmb  = CcbCMvto.tpocmb.
 *             END.*/
         END.
    END.
END.

d-uno  = 0.
d-dos  = 0.
h-uno  = 0.
h-dos  = 0.

RUN cbd/cbdnast.p(cb-codcia,
                  s-codcia, 
                  s-periodo, 
                  s-nromes, 
                  p-codope, 
                  OUTPUT x-nroast). 
p-nroast = STRING(x-nroast, '999999').

J = 0.
FOR EACH T-DMOV :
    FIND cb-ctas WHERE
        cb-ctas.codcia = cb-codcia AND
        cb-ctas.codcta = T-DMOV.codcta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN NEXT.
    x-clfaux = cb-ctas.clfaux.
    x-coddoc = cb-ctas.piddoc.
    IF T-DMOV.impmn1 > 0 OR T-DMOV.impmn2 > 0 THEN DO:
        J = J + 1.
        CREATE CB-DMOV.
        CB-DMOV.codcia  = s-codcia.
        CB-DMOV.PERIODO = s-periodo.
        CB-DMOV.NROMES  = s-nromes.
        CB-DMOV.CODOPE  = p-codope.
        CB-DMOV.NROAST  = p-nroast.
        CB-DMOV.NROITM  = J.
        CB-DMOV.codcta  = T-DMOV.codcta.
        CB-DMOV.coddiv  = T-DMOV.coddiv.
        Cb-dmov.Coddoc  = IF x-coddoc THEN T-DMOV.coddoc ELSE ''.
        Cb-dmov.Nrodoc  = IF x-coddoc THEN T-DMOV.nrodoc ELSE ''.
        CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''.
        CB-DMOV.codaux  = IF x-clfaux <> '' THEN T-DMOV.codaux ELSE ''.
        CB-DMOV.GLODOC  = T-DMOV.glodoc.
        CB-DMOV.tpomov  = T-DMOV.tpomov.
        CB-DMOV.impmn1  = T-DMOV.impmn1.
        CB-DMOV.impmn2  = T-DMOV.impmn2.
        CB-DMOV.FCHDOC  = T-DMOV.Fchdoc.
        CB-DMOV.FCHVTO  = T-DMOV.Fchdoc.
        CB-DMOV.FLGACT  = TRUE.
        CB-DMOV.RELACION = 0.
        CB-DMOV.codmon  = 1.
        CB-DMOV.tpocmb  = T-DMOV.tpocmb.
        RUN cbd/cb-acmd.p(RECID(CB-DMOV),YES,YES).
        IF CB-DMOV.tpomov THEN DO:
            h-uno = h-uno + CB-DMOV.impmn1.
            h-dos = h-dos + CB-DMOV.impmn2.
        END.
        ELSE DO:
            d-uno = d-uno + CB-DMOV.impmn1.
            d-dos = d-dos + CB-DMOV.impmn2.
        END.

        x-GenAut = 0.
        /* Preparando para Autom ticas */
        /* Verificamos si la Cuenta genera automaticas de Clase 9 */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut9) <> "" THEN DO:
                    x-GenAut = 1.
                    LEAVE.
                END.
            END.
        END.
        /* Verificamos si la Cuenta genera automaticas de Clase 6 */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut6) <> "" THEN DO:
                    x-GenAut = 2.
                    LEAVE.
                END.
           END.
        END.
        /* Verificamos si la Cuenta genera automaticas de otro tipo */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut) <> "" THEN DO:
                    x-GenAut = 3.
                    LEAVE.
                END.
           END.
        END.
        cb-dmov.CtaAut = "".
        cb-dmov.CtrCta = "".
        CASE x-GenAut:
            /* Genera Cuentas Clase 9 */
            WHEN 1 THEN DO:
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                IF cb-dmov.CtrCta = "" THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
            END.
            /* Genera Cuentas Clase 6 */
            WHEN 2 THEN DO:
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                IF cb-dmov.CtrCta = "" THEN
                    cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
            END.
            WHEN 3 THEN DO:
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            END.
        END CASE.
        /* Chequendo las cuentas a generar en forma autom tica */
        IF x-GenAut > 0 THEN DO:
            IF NOT CAN-FIND(FIRST cb-ctas WHERE
                cb-ctas.CodCia = cb-codcia AND
                cb-ctas.CodCta = cb-dmov.CtaAut) THEN DO:
                BELL.
                MESSAGE
                    "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro, Cuenta" cb-dmov.CtaAut "no existe"
                    VIEW-AS ALERT-BOX ERROR.
                cb-dmov.CtaAut = "".
            END.
            IF NOT CAN-FIND( cb-ctas WHERE
                cb-ctas.CodCia = cb-codcia AND
                cb-ctas.CodCta = cb-dmov.CtrCta ) THEN DO:
                BELL.
                MESSAGE
                    "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro, Contra Cuenta" cb-dmov.CtrCta "no existe"
                    VIEW-AS ALERT-BOX ERROR.
                cb-dmov.CtrCta = "".
            END.
        END. /*Fin del x-genaut > 0 */
        IF cb-dmov.CtaAut <> "" AND cb-dmov.CtrCta <> "" THEN DO:
            J = J + 1.
            CREATE detalle.
            detalle.CodCia   = cb-dmov.CodCia.
            detalle.Periodo  = cb-dmov.Periodo.
            detalle.NroMes   = cb-dmov.NroMes.
            detalle.CodOpe   = cb-dmov.CodOpe.
            detalle.NroAst   = cb-dmov.NroAst.
            detalle.TpoItm   = "A".
            detalle.Relacion = RECID(cb-dmov).
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.NroItm   = cb-dmov.NroItm.
            detalle.Codcta   = cb-dmov.CtaAut.
            detalle.CodDiv   = cb-dmov.CodDiv.
            detalle.ClfAux   = cb-dmov.ClfAux.
            detalle.CodAux   = cb-dmov.CodCta.
            detalle.NroRuc   = cb-dmov.NroRuc.
            detalle.CodDoc   = cb-dmov.CodDoc.
            detalle.NroDoc   = cb-dmov.NroDoc.
            detalle.GloDoc   = cb-dmov.GloDoc.
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.TpoMov   = cb-dmov.TpoMov.
            detalle.NroRef   = cb-dmov.NroRef.
            detalle.FchDoc   = cb-dmov.FchDoc.
            detalle.FchVto   = cb-dmov.FchVto.
            detalle.ImpMn1   = cb-dmov.ImpMn1.
            detalle.ImpMn2   = cb-dmov.ImpMn2.
            detalle.ImpMn3   = cb-dmov.ImpMn3.
            detalle.Tm       = cb-dmov.Tm.
            detalle.CCO      = cb-dmov.CCO.
            RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
            IF detalle.tpomov THEN DO:
                h-uno = h-uno + detalle.impmn1.
                h-dos = h-dos + detalle.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
            J = J + 1.
            CREATE detalle.
            detalle.CodCia   = cb-dmov.CodCia.
            detalle.Periodo  = cb-dmov.Periodo.
            detalle.NroMes   = cb-dmov.NroMes.
            detalle.CodOpe   = cb-dmov.CodOpe.
            detalle.NroAst   = cb-dmov.NroAst.
            detalle.TpoItm   = "A".
            detalle.Relacion = RECID(cb-dmov).
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.NroItm   = cb-dmov.NroItm.
            detalle.Codcta   = cb-dmov.Ctrcta.
            detalle.CodDiv   = cb-dmov.CodDiv.
            detalle.ClfAux   = cb-dmov.ClfAux.
            detalle.CodAux   = cb-dmov.CodCta.
            detalle.NroRuc   = cb-dmov.NroRuc.
            detalle.CodDoc   = cb-dmov.CodDoc.
            detalle.NroDoc   = cb-dmov.NroDoc.
            detalle.GloDoc   = cb-dmov.GloDoc.
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.TpoMov   = NOT cb-dmov.TpoMov.
            detalle.ImpMn1   = cb-dmov.ImpMn1.
            detalle.ImpMn2   = cb-dmov.ImpMn2.
            detalle.ImpMn3   = cb-dmov.ImpMn3.
            detalle.NroRef   = cb-dmov.NroRef.
            detalle.FchDoc   = cb-dmov.FchDoc.
            detalle.FchVto   = cb-dmov.FchVto.
            detalle.Tm       = cb-dmov.Tm.
            detalle.CCO      = cb-dmov.CCO.
            RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
            IF detalle.tpomov THEN DO:
                h-uno = h-uno + detalle.impmn1.
                h-dos = h-dos + detalle.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
        END.
    END.
END.
FIND cb-cmov WHERE
     cb-cmov.codcia  = s-codcia AND
     cb-cmov.PERIODO = s-periodo AND
     cb-cmov.NROMES  = s-nromes AND
     cb-cmov.CODOPE  = p-codope AND
     cb-cmov.NROAST  = p-nroast NO-ERROR.
IF NOT AVAILABLE cb-cmov THEN DO:
     CREATE cb-cmov.
     cb-cmov.codcia  = s-codcia.
     cb-cmov.PERIODO = s-periodo.
     cb-cmov.NROMES  = s-nromes.
     cb-cmov.CODOPE  = p-codope.
     cb-cmov.NROAST  = p-nroast. 
END.
ASSIGN
   cb-cmov.Coddiv = CcbCMvto.Coddiv
   cb-cmov.Fchast = CcbCMvto.Fchdoc
   cb-cmov.TOTITM = J
   cb-cmov.CODMON = 1
   cb-cmov.TPOCMB = CcbCMvto.Tpocmb
   cb-cmov.DBEMN1 = d-uno
   cb-cmov.DBEMN2 = d-dos
   cb-cmov.HBEMN1 = h-uno
   cb-cmov.HBEMN2 = h-dos
   cb-cmov.NOTAST = CcbCMvto.Glosa
   cb-cmov.GLOAST = CcbCMvto.Glosa.
ASSIGN
   CcbCMvto.CodOpe = cb-cmov.codope
   CcbCMvto.NroAst = cb-cmov.nroast
   CcbCMvto.NroMes = cb-cmov.nromes
   CcbCMvto.Periodo= cb-cmov.periodo.
  
MESSAGE ' PROCESO CONCLUIDO  ' VIEW-AS ALERT-BOX INFORMATION.

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
   RUN Borra-Documento. 
   FOR EACH MVTO ON ERROR UNDO, RETURN "ADM-ERROR":
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
          IF MVTO.TpoRef = 'C' THEN DO:
             ASSIGN
                B-CMVTO.ImpDoc = B-CMVTO.ImpDoc + MVTO.ImpDoc
                B-CMVTO.ImpTot = B-CMVTO.ImpTot + MVTO.ImpTot.
          END.
       END.
    END.
    RELEASE B-CMVTO.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime V-table-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER F-CUENTAS AS Integer.

FIND Cb-cmov OF Ccbcmvto NO-LOCK NO-ERROR.
IF NOT AVAILABLE Cb-cmov THEN RETURN.

    /* 1 todas las cuentas
       2 eliminar las automaticas
     */
    DEF VAR X-IMPRESO AS CHAR FORMAT "X(20)".
    X-IMPRESO = STRING(TIME,"HH:MM AM") + "-" + STRING(TODAY,"99/99/9999").
    DEFINE var X-PAG AS CHAR FORMAT "999". 
    DEFINE VARIABLE x-filtro   AS CHAR.   
    DEFINE VARIABLE x-glodoc   AS CHARACTER FORMAT "X(35)".
    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-fecha    AS DATE FORMAT "99/99/9999" INITIAL TODAY.
    DEFINE VARIABLE x-codmon   AS INTEGER INITIAL 1.
    DEFINE VARIABLE x-con-reg  AS INTEGER.
    DEFINE VARIABLE x-nom-ope  AS CHARACTER FORMAT "x(40)".
    DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    x-codmon = integral.cb-cmov.codmon.
    x-fecha  = integral.cb-cmov.Fchast.
  
    DEFINE FRAME f-cab
        cb-dmov.coddiv LABEL "Divis"
        cb-dmov.codcta LABEL "Cuenta"
        cb-dmov.clfaux LABEL "Clf!Aux"
        cb-dmov.codaux       LABEL "Auxiliar"
        cb-dmov.cco          LABEL "C.Cos"
        cb-dmov.nroref LABEL "Referencia"
        cb-dmov.coddoc COLUMN-LABEL "Cod!Doc."
        cb-dmov.nrodoc LABEL "Nro!Documento"
        cb-dmov.fchdoc LABEL "Fecha!Doc"
        x-glodoc       LABEL "Detalle"
        x-debe         LABEL "Cargos"
        x-haber        LABEL "Abonos"
        WITH WIDTH 160 NO-BOX STREAM-IO DOWN.
    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 66.    
    PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66) .
    PUT STREAM report CONTROL CHR(27) CHR(80) CHR(15).
    PUT STREAM report s-nomcia SKIP.
    /*PUT STREAM report x-nomope. */
    PUT STREAM report "ASIENTO No: " AT 50 
                      integral.cb-cmov.codope
                      "-"
                      integral.cb-cmov.nroast 
                      SKIP(1).
    PUT STREAM report pinta-mes SKIP(1).
    PUT STREAM report CONTROL CHR(27) CHR(70) CHR(27) CHR(120) 0.
    PUT STREAM report CONTROL CHR(27) CHR(80) CHR(15).
    PUT STREAM report "FECHA     : " cb-cmov.fchast.
    PUT STREAM REPORT "REFERENCIA : " AT 70 cb-cmov.NroVou SKIP.
    IF integral.cb-cmov.codmon = 1 THEN
        PUT STREAM report "MONEDA    :         S/. " SKIP.
    ELSE
        PUT STREAM report "MONEDA    :         US$ " SKIP.
    PUT STREAM report "T.CAMBIO  : " integral.cb-cmov.tpocmb SKIP.    
    PUT STREAM report "CONCEPTO  : " integral.cb-cmov.notast SKIP.
    
    PUT STREAM report CONTROL CHR(27) CHR(77) CHR(15).

    PUT STREAM report FILL("_",160) FORMAT "X(160)" SKIP.

    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                    AND cb-dmov.periodo = s-periodo
                    AND cb-dmov.nromes  = s-NroMes
                    AND cb-dmov.codope  = cb-cmov.codope
                    AND cb-dmov.nroast  = cb-cmov.nroast
        BREAK BY (cb-dmov.nroast)
              BY (cb-dmov.Nroitm) ON ERROR UNDO, LEAVE:
        IF F-CUENTAS = 2 AND cb-dmov.tpoitm = "A" THEN NEXT.
        x-glodoc = glodoc.
        IF x-glodoc = "" THEN DO:
            CASE cb-dmov.clfaux:
            WHEN "@CL" THEN DO:
                FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                    AND gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
            END.
            WHEN "@PV" THEN DO:
                FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                    AND gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
            END.
            WHEN "@CT" THEN DO:
                find cb-ctas WHERE cb-ctas.codcta = cb-dmov.codaux
                    AND cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
               IF AVAILABLE cb-ctas THEN x-glodoc = cb-ctas.nomcta.
            END.
            OTHERWISE DO:
                FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                    AND cb-auxi.codaux = cb-dmov.codaux
                    AND cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-auxi THEN x-glodoc = cb-auxi.nomaux.
            END.
            END CASE.
        END.
        IF x-glodoc = "" THEN DO:
            IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
        END.
        CASE x-codmon:
            WHEN 2 THEN DO:
                SUBSTR(x-glodoc,( 35 - LENGTH(STRING(ImpMn2)) ),31) = "(US$" + STRING(ImpMn2) + ")".
            END.
        END CASE.
        IF cb-dmov.tpomov THEN DO:
            x-debe  = 0.
            x-haber = ImpMn1.
        END.
        ELSE DO:
            x-debe  = ImpMn1.
            x-haber = 0.
        END.
        IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ?
        THEN DO:
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
            IF LINE-COUNTER(report)  + 5 > PAGE-SIZE(report)
            THEN DO :
                      X-PAG =  STRING(PAGE-NUMBER(report),"999").
                      UNDERLINE STREAM report 
                              cb-dmov.coddiv
                              cb-dmov.codcta
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                       DISPLAY STREAM report 
                              "PAG."              @ cb-dmov.coddiv
                              X-PAG               @ cb-dmov.codcta
                              "    .....Van.... " @ x-glodoc
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                       WITH FRAME f-cab.    
                       X-PAG =  STRING(PAGE-NUMBER(report) + 1 ,"999").  
                       DOWN STREAM report with frame f-cab.
                       PAGE stream report.
                       DISPLAY STREAM report 
                              "PAG."              @ cb-dmov.coddiv
                              X-PAG               @ cb-dmov.codcta
                              "    .....Vienen.... " @ x-glodoc
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                       UNDERLINE STREAM report 
                              cb-dmov.coddiv
                              cb-dmov.codcta
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                     
                       
                 END.     
            DISPLAY STREAM report cb-dmov.coddiv
                                  cb-dmov.codcta
                                  cb-dmov.clfaux
                                  cb-dmov.codaux
                                  cb-dmov.cco
                                  cb-dmov.nroref
                                  cb-dmov.coddoc
                                  cb-dmov.nrodoc
                                  cb-dmov.fchdoc
                                  x-glodoc
                                  x-debe   WHEN (x-debe  <> 0)
                                  x-haber  WHEN (x-haber <> 0) 
                            WITH FRAME f-cab.

        END.
        IF LAST-OF (cb-dmov.nroast)
        THEN DO:
            x-glodoc = "                    TOTALES :".
            IF LINE-COUNTER(report)  + 3 > PAGE-SIZE(report)
            THEN PAGE stream report.
            DOWN STREAM report 1 WITH FRAME f-cab.
            UNDERLINE STREAM report 
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
            DOWN STREAM report with frame f-cab.
            DISPLAY STREAM report x-glodoc
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                WITH FRAME f-cab.
                


        END.
    END.
    DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 10 :
        PUT STREAM report "" skip.
    END.
    PUT STREAM report "               -----------------       -----------------       -----------------       ----------------- " SKIP.
    PUT STREAM report "                  PREPARADO                  Vo. Bo.            ADMINISTRACION             CONTADOR           Impreso:".
    PUT STREAM report x-impreso SKIP.
    
    OUTPUT STREAM report CLOSE.

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
  FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND
                     cb-peri.Periodo = s-Periodo NO-LOCK NO-ERROR.
  IF AVAILABLE cb-peri THEN
     s-NroMesCie = cb-peri.MesCie[s-nromes + 1].
  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
     UNDO, RETURN 'ADM-ERROR'.
  END.
  FIND FIRST FacDocum WHERE FacDocum.CodCia = s-codcia 
    AND FacDocum.CodDoc = S-CODDOC NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacDocum THEN DO:
    MESSAGE 'Correlativo no configurado para el documento' s-coddoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  FIND Cb-Oper WHERE Cb-oper.codcia = cb-codcia
        AND Cb-oper.codope = FacDocum.Codope
        NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Cb-Oper THEN DO:
    MESSAGE 'Libro Contable no configurado:' facdocum.codope 'para el documento' s-coddoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  s-tpocmb = 1.
  RUN Numero-de-Documento(NO).
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ CcbCMvto.FchDoc
             S-CODCLI @ CcbCMvto.CodCli
             /*FacCfgGn.Tpocmb[1] @ CcbCMvto.TpoCmb*/
             STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999") @ CcbCMvto.NroDoc.
    FIND LAST gn-tcmb WHERE gn-tcmb.FECHA <= TODAY NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tcmb 
    THEN IF cb-oper.TpoCmb = 1 
        THEN s-TpoCmb = gn-tcmb.Compra.
        ELSE s-TpoCmb = gn-tcmb.Venta.
    DISPLAY s-TpoCmb @ Ccbcmvto.tpocmb.
    s-coddiv = CcbCMvto.CodDiv:SCREEN-VALUE.
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
            /*CcbCMvto.CodDiv  = S-CODDIV*/
            CcbCMvto.nromes  = s-nromes
            CcbCMvto.periodo = s-periodo.
     DISPLAY CcbCMvto.NroDoc.
  END.
/*  FIND gn-clie WHERE gn-clie.CodCia = 0 AND 
 *        gn-clie.CodCli = CcbCMvto.CodCli NO-LOCK NO-ERROR.
 *   IF AVAILABLE gn-clie THEN DO:
 *      ASSIGN CcbCMvto.CodDpto = gn-clie.CodDept 
 *             CcbCMvto.CodProv = gn-clie.CodProv 
 *             CcbCMvto.CodDist = gn-clie.CodDist.
 *   END.*/
  
  RUN Genera-Detalle.   
  RUN Graba-Totales.
  RUN Actualiza-Canje.      
  
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
      MESSAGE 'El documento se encuentra anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
   END.  
   
   FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND
                      cb-peri.Periodo = s-Periodo NO-LOCK NO-ERROR.
   IF AVAILABLE cb-peri THEN
      s-NroMesCie = cb-peri.MesCie[s-nromes + 1].
   IF s-NroMesCie THEN DO:
      MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
   END.

   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      /*IF CcbCMvto.FlgEst = "E" THEN RUN Borra-Cancelaciones.*/
      RUN Borra-Cancelaciones.
      RUN Borra-Documento.   
      FIND B-CMVTO WHERE ROWID(B-CMVTO) = ROWID(CcbCMvto) EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-CMVTO THEN 
         ASSIGN B-CMVTO.FlgEst = "A"
                B-CMVTO.Glosa  = '**** Documento Anulado ****'
                B-CMVTO.ImpTot = 0
                B-CMVTO.ImpDoc = 0.
      RELEASE B-CMVTO.
      RUN Elimina-Asiento.
      RUN Actualiza-Flag (FALSE).
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
  IF AVAILABLE CcbCMvto THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = CcbCMvto.CodCli NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie  THEN 
        DISPLAY gn-clie.NomCli @ FILL-IN_NomCli.
     DISPLAY
        CcbCMvto.codope + '-' + CcbCMvto.nroast @ F-Asiento.
     CASE Ccbcmvto.flgest:
         WHEN 'P' THEN FILL-IN-Estado = 'CON ERROR'.
         WHEN 'E' THEN FILL-IN-Estado = 'CORRECTO'.
         WHEN 'A' THEN FILL-IN-Estado = 'ANULADO'.
         OTHERWISE FILL-IN-Estado = '¿?'.
     END CASE.
     DISPLAY FILL-IN-Estado WITH FRAME {&FRAME-NAME}.
  END.
  /* Code placed here will execute AFTER standard behavior.    */

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
    /*CcbCMvto.FchDoc:SENSITIVE = NO.*/
    CcbCMvto.CodProv:SENSITIVE = NO.
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
  DEFINE VARIABLE answer AS LOGICAL NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


  IF CCBCMVTO.FLGEST = "A" THEN RETURN.

  SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
  IF NOT answer THEN RETURN.
  RUN Imprime(1).
  
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
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  
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
     FIND FIRST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC EXCLUSIVE-LOCK NO-ERROR.
  ELSE
     FIND FIRST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC NO-LOCK NO-ERROR.
    
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
DEFINE VAR s-impcob AS DECIMAL NO-UNDO.
DEFINE VAR s-imppag AS DECIMAL NO-UNDO.
DO WITH FRAME {&FRAME-NAME}:
   IF CcbCMvto.CodCli:SCREEN-VALUE = "" THEN DO:
      MESSAGE 'Codigo de Cliente en blanco' VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO CcbCMvto.CodCli.
      RETURN 'ADM-ERROR'.
   END.
   s-impcob = 0.
   s-imppag = 0.
   FOR EACH MVTO:
       IF MVTO.TpoRef = 'C' 
       THEN s-impcob = s-impcob + 
                        (IF s-CodMon = 1 THEN MVTO.DepNac[1]
                                        ELSE MVTO.DepUsa[1]).
/*        IF MVTO.TpoRef = 'C' THEN s-impcob = s-impcob + MVTO.ImpTot. */

       IF MVTO.TpoRef = 'P' 
       THEN s-imppag = s-imppag + 
                        (IF s-CodMon = 1 THEN MVTO.DepNac[1]
                                        ELSE MVTO.DepUsa[1]).
   END.
   IF s-impcob <> s-imppag THEN DO:
      MESSAGE 'Los importes totales del canje deben ser iguales' VIEW-AS ALERT-BOX ERROR.
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
IF NOT AVAILABLE CcbCDocu THEN RETURN "ADM-ERROR".
RETURN 'ADM-ERROR'.   /* No debe permitir realizar modificaciones  */
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

