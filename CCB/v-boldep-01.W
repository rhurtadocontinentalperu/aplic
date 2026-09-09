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
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-coddiv  AS CHAR.
DEF SHARED VAR s-nomcia  AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.

DEFINE VAR W-TIPDEP AS CHAR.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEF BUFFER b-CcbBoldep FOR CcbBoldep.

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
&Scoped-define EXTERNAL-TABLES CcbBolDep
&Scoped-define FIRST-EXTERNAL-TABLE CcbBolDep


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbBolDep.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbBolDep.FchReg CcbBolDep.codbco ~
CcbBolDep.NroRef CcbBolDep.TipDep CcbBolDep.CodCta CcbBolDep.CodAge ~
CcbBolDep.ImpTot CcbBolDep.CodCli CcbBolDep.CodDiv 
&Scoped-define ENABLED-TABLES CcbBolDep
&Scoped-define FIRST-ENABLED-TABLE CcbBolDep
&Scoped-Define ENABLED-OBJECTS RECT-29 RECT-39 RECT-40 
&Scoped-Define DISPLAYED-FIELDS CcbBolDep.NroDoc CcbBolDep.FchDoc ~
CcbBolDep.FlgSit CcbBolDep.FchReg CcbBolDep.codbco CcbBolDep.CodMon ~
CcbBolDep.NroRef CcbBolDep.TipDep CcbBolDep.TpoCmb CcbBolDep.CodCta ~
CcbBolDep.DesCta CcbBolDep.CodAge CcbBolDep.ImpTot CcbBolDep.SdoAct ~
CcbBolDep.CodCli CcbBolDep.NomCli CcbBolDep.CodDiv CcbBolDep.Autorizo ~
CcbBolDep.FchAut CcbBolDep.usuario 
&Scoped-define DISPLAYED-TABLES CcbBolDep
&Scoped-define FIRST-DISPLAYED-TABLE CcbBolDep
&Scoped-Define DISPLAYED-OBJECTS F-Estado x-NomBco FILL-IN-Moneda ~
FILL-IN-NomDiv 

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
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .81
     FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-Moneda AS CHARACTER FORMAT "X(256)":U INITIAL "S/." 
     LABEL "Importe Total" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE FILL-IN-NomDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomBco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 1.31.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 6.15.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 4.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbBolDep.NroDoc AT ROW 1.27 COL 6 COLON-ALIGNED FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .81
          FONT 0
     CcbBolDep.FchDoc AT ROW 1.27 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbBolDep.FlgSit AT ROW 1.27 COL 43 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Pendiente","Autorizada","Rechazada" 
          DROP-DOWN-LIST
          SIZE 11.29 BY 1
     F-Estado AT ROW 1.27 COL 55.29 COLON-ALIGNED NO-LABEL
     CcbBolDep.FchReg AT ROW 2.54 COL 14 COLON-ALIGNED
          LABEL "Fecha de Depósito"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbBolDep.codbco AT ROW 3.5 COL 14 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "?" 
          DROP-DOWN-LIST
          SIZE 8 BY 1
     x-NomBco AT ROW 3.5 COL 23 COLON-ALIGNED NO-LABEL
     CcbBolDep.CodMon AT ROW 3.5 COL 60 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .81
     CcbBolDep.NroRef AT ROW 4.46 COL 14 COLON-ALIGNED
          LABEL "Nro. Deposito" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbBolDep.TipDep AT ROW 4.46 COL 31 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Efectivo", "EFE":U,
"Cheque", "CHQ":U
          SIZE 18.72 BY .81
     CcbBolDep.TpoCmb AT ROW 4.46 COL 58 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbBolDep.CodCta AT ROW 5.42 COL 14 COLON-ALIGNED
          LABEL "Codigo de Cuenta"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbBolDep.DesCta AT ROW 5.42 COL 22 COLON-ALIGNED NO-LABEL FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 50 BY .81
     CcbBolDep.CodAge AT ROW 6.38 COL 16 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Lima", "Lima":U,
"Provincia", "Provincia":U,
"Otros", "Otros":U
          SIZE 27 BY .77
     FILL-IN-Moneda AT ROW 7.35 COL 14 COLON-ALIGNED
     CcbBolDep.ImpTot AT ROW 7.35 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbBolDep.SdoAct AT ROW 7.35 COL 58 COLON-ALIGNED
          LABEL "Saldo Actual"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbBolDep.CodCli AT ROW 8.69 COL 14 COLON-ALIGNED
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     CcbBolDep.NomCli AT ROW 8.73 COL 28.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     CcbBolDep.CodDiv AT ROW 9.65 COL 14 COLON-ALIGNED
          LABEL "Division" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     FILL-IN-NomDiv AT ROW 9.65 COL 24 COLON-ALIGNED NO-LABEL
     CcbBolDep.Autorizo AT ROW 10.5 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbBolDep.FchAut AT ROW 10.5 COL 40.57 COLON-ALIGNED
          LABEL "Fecha Autorizacion"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbBolDep.usuario AT ROW 11.38 COL 14 COLON-ALIGNED
          LABEL "Solicitante"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Moneda" VIEW-AS TEXT
          SIZE 6.57 BY .81 AT ROW 3.5 COL 53
     "Plaza:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 6.38 COL 11
     RECT-29 AT ROW 1 COL 1
     RECT-39 AT ROW 2.35 COL 1
     RECT-40 AT ROW 8.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbBolDep
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
         HEIGHT             = 12.27
         WIDTH              = 79.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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

/* SETTINGS FOR FILL-IN CcbBolDep.Autorizo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbBolDep.CodCta IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.CodDiv IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR RADIO-SET CcbBolDep.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.DesCta IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.FchAut IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbBolDep.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.FchReg IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Moneda IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX CcbBolDep.FlgSit IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbBolDep.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbBolDep.SdoAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbBolDep.TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN x-NomBco IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbBolDep.codbco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbBolDep.codbco V-table-Win
ON VALUE-CHANGED OF CcbBolDep.codbco IN FRAME F-Main /* Banco */
DO:
  FIND cb-tabl WHERE cb-tabl.tabla = '04'
    AND cb-tabl.codigo = SELF:SCREEN-VALUE NO-LOCK.
  x-NomBco:SCREEN-VALUE = cb-tabl.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbBolDep.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbBolDep.CodCli V-table-Win
ON LEAVE OF CcbBolDep.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY 
        "" @ CcbBolDep.NomCli 
        WITH FRAME {&FRAME-NAME}.
    RETURN.
  END.    
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                AND  gn-clie.codcli = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
    MESSAGE "Cliente no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  DISPLAY 
    gn-clie.nomcli @ CcbBolDep.NomCli 
/*    gn-clie.ruc @ FILL-IN_Ruc */
    WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbBolDep.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbBolDep.CodCta V-table-Win
ON LEAVE OF CcbBolDep.CodCta IN FRAME F-Main /* Codigo de Cuenta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY 
        "" @ CcbBolDep.CodCta 
        WITH FRAME {&FRAME-NAME}.
    RETURN.
  END.    
                 
  FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
                AND  cb-ctas.Codcta = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-ctas THEN DO:
    MESSAGE "Cuenta no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  CcbBolDep.CodMon:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cb-ctas.Codmon).
  CcbBolDep.Descta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cb-ctas.Nomcta. 
  IF cb-ctas.codmon = 1
  THEN FILL-IN-Moneda:SCREEN-VALUE = 'S/.'.
  ELSE FILL-IN-Moneda:SCREEN-VALUE = 'US$'.
  DISPLAY 
    cb-ctas.Codcta @ CcbBolDep.Codcta 
    cb-ctas.Nomcta @ CcbBolDep.Descta WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbBolDep.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbBolDep.CodDiv V-table-Win
ON LEAVE OF CcbBolDep.CodDiv IN FRAME F-Main /* Division */
DO:
  FIND GN-DIVI WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
  IF AVAILABLE GN-DIVI THEN FILL-IN-NomDiv:SCREEN-VALUE = GN-DIVI.DesDiv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbBolDep.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbBolDep.FchDoc V-table-Win
ON LEAVE OF CcbBolDep.FchDoc IN FRAME F-Main /* Fecha */
DO:
    FIND gn-tcmb WHERE gn-tcmb.fecha = DATE(CcbBolDep.FchDoc:SCREEN-VALUE) NO-LOCK NO-ERROR.
    IF AVAIL gn-tcmb THEN 
    DISPLAY 
        gn-tcmb.compra @ CcbBolDep.TpoCmb WITH FRAME {&FRAME-NAME}.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbBolDep.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbBolDep.NroRef V-table-Win
ON LEAVE OF CcbBolDep.NroRef IN FRAME F-Main /* Nro. Deposito */
DO:
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '999999')
    NO-ERROR.
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
  {src/adm/template/row-list.i "CcbBolDep"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbBolDep"}

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
  L-CREA = YES.
  DO WITH FRAME {&FRAME-NAME}:
    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
    DISPLAY 
        TODAY @ CcbBolDep.FchReg
        TODAY @ CcbBolDep.FchDoc
        gn-tcmb.compra @ CcbBolDep.TpoCmb. 
    FOR EACH cb-tabl WHERE cb-tabl.tabla = '04' NO-LOCK:
        CcbBolDep.codbco:ADD-LAST(cb-tabl.codigo).
    END.
/*    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
 *         Ccbboldep.coddiv:ADD-LAST(gn-divi.coddiv).
 *     END.    */
    ASSIGN
        Ccbboldep.fchdoc:SENSITIVE = NO
        CcbBolDep.TipDep:SCREEN-VALUE = 'EFE'
        CcbBolDep.CodDiv:SCREEN-VALUE = s-coddiv.
    FIND GN-DIVI WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = s-coddiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-DIVI THEN FILL-IN-NomDiv:SCREEN-VALUE = GN-DIVI.DesDiv.
  END.
    
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

  IF L-CREA THEN DO:
    FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia 
        AND  FacCorre.CodDiv = s-coddiv 
        AND  FacCorre.CodDoc = s-coddoc 
        EXCLUSIVE-LOCK.
    FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ccbboldep.NroDoc = STRING(faccorre.nroser, "999") + 
                      STRING(faccorre.correlativo, "999999").
    RELEASE faccorre.
  END.
 
  ASSIGN
    ccbboldep.CodCia = s-codcia
    ccbboldep.CodDIV = ccbboldep.CodDIV:screen-value in frame {&FRAME-NAME}
    ccbboldep.CodDoc = s-coddoc
    ccbboldep.usuario= s-user-id
   
    CcbBolDep.SdoAct = CcbBolDep.ImpTot
    CcbBoldep.Nomcli = CcbBoldep.Nomcli:screen-value in frame {&frame-name}
    CcbBoldep.DesCta = CcbBoldep.Descta:screen-value in frame {&frame-name}
    CcbBoldep.Codmon = INTEGER (CcbBoldep.Codmon:screen-value in frame {&frame-name}).
IF L-CREA THEN DO:
    ASSIGN 
    CcbBolDep.FlgEst = "" 
    /*CcbBolDep.FchReg = TODAY*/
    CcbBolDep.FchAut = DATE("").
    
END.

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
  DEF VAR s-rpta-1 AS CHAR NO-UNDO.
  
  IF CcbBolDep.FlgEst = "A" THEN
  DO:
    MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  IF CcbBolDep.FlgEst = "C" THEN
  DO:
    MESSAGE "El Documento se encuentra Cancelado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  IF CcbBolDep.FlgEst = "X" THEN
  DO:
    MESSAGE "El Documento se encuentra Cerrado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  IF CcbBolDep.FlgSit = "Autorizada" THEN
  DO:
    MESSAGE "El Documento está Autorizado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.  
  IF CcbBolDep.ImpTot <> CcbBolDep.SdoAct THEN
  DO:
    MESSAGE "El Documento tiene Amortizaciones" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.

/*  IF CcbBolDep.FlgSit = "Autorizada" THEN
 *   DO:
 *     MESSAGE "El Documento esta Autorizado" SKIP
 *         "Continuamos con la anulación?"
 *         VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta-1 AS LOG.
 *         IF rpta-1 = NO THEN RETURN "ADM-ERROR".
 *   END.  
 *   RUN lib/_clave ('3490114', OUTPUT s-rpta-1).
 *   IF s-rpta-1 = "ERROR" THEN RETURN "ADM-ERROR".*/
  
  /* Dispatch standard ADM method.                             */
/*  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  FIND CURRENT CcbBoldep EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbBoldep THEN RETURN 'ADM-ERROR'.
  ASSIGN
    CcbBolDep.Autorizo = s-user-id
    CcbBolDep.FchAut = TODAY
    CcbBolDep.FlgEst = 'A'
    CcbBolDep.Hora = STRING(TIME, 'HH:MM')
    CcbBolDep.SdoAct = 0.
  FIND CURRENT CcbBoldep NO-LOCK NO-ERROR.
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

  IF AVAILABLE CcbBoldep THEN DO WITH FRAME {&FRAME-NAME}:
    FOR EACH cb-tabl WHERE cb-tabl.tabla = '04' NO-LOCK:
        CcbBolDep.codbco:ADD-LAST(cb-tabl.codigo).
    END.
    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
        Ccbboldep.coddiv:ADD-LAST(gn-divi.coddiv).
    END.
    FIND cb-tabl WHERE cb-tabl.tabla = '04'
        AND cb-tabl.codigo = ccbboldep.codbco NO-LOCK NO-ERROR.
    IF AVAILABLE cb-tabl THEN x-NomBco:SCREEN-VALUE = cb-tabl.Nombre.
    IF CcbBoldep.FlgEst = "" THEN F-Estado:SCREEN-VALUE = "".
    IF CcbBoldep.FlgEst = "P" THEN F-Estado:SCREEN-VALUE = "PENDIENTE".
    IF CcbBoldep.FlgEst = "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
    IF CcbBoldep.FlgEst = "C" THEN F-Estado:SCREEN-VALUE = "CANCELADO".
    IF CcbBoldep.FlgEst = "X" THEN F-Estado:SCREEN-VALUE = "CERRADO".
    IF ccbboldep.codmon = 1
    THEN FILL-IN-Moneda:SCREEN-VALUE = 'S/.'.
    ELSE FILL-IN-Moneda:SCREEN-VALUE = 'US$'.
    FIND GN-DIVI WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = ccbboldep.coddiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-DIVI
    THEN FILL-IN-NomDiv:SCREEN-VALUE = GN-DIVI.DesDiv.
    ELSE FILL-IN-NomDiv:SCREEN-VALUE = ''.
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
    CcbBolDep.CodDiv:SENSITIVE = NO.
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

DEFINE VAR F-MONEDA AS CHAR.  

DEFINE FRAME F-CAB
/*  CcbBolDep.NroDoc FORMAT "XXX-XXXXXX"
    CcbBolDep.FchDoc FORMAT "99/99/9999"
    CcbBolDep.FlgSit 
    CcbBolDep.CodMon 
    CcbBolDep.TpoCmb 
    CcbBolDep.Hora  
    CcbBolDep.codbco  
    CcbBolDep.NroRef 
    CcbBolDep.TipDep 
    CcbBolDep.CodCta 
    CcbBolDep.DesCta 
    CcbBolDep.CodAge 
    CcbBolDep.ImpTot 
    CcbBolDep.SdoAct 
    CcbBolDep.CodCli 
    CcbBolDep.NomCli 
    CcbBolDep.FchAut 
    CcbBolDep.usuario
    CcbBolDep.CodDiv
    CcbBolDep.Autorizo*/

    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(45)" SKIP(2)
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 200 STREAM-IO DOWN.         
    OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30.
    PUT STREAM Report CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN2}.  

    IF CcbBolDep.CodMon = 2 THEN F-MONEDA = "US$.".
       ELSE F-MONEDA = "S/.".
       
       
    PUT STREAM REPORT {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(45)" 
                      {&PRN3} + "Fecha : " AT 65 FORMAT "X(10)" TODAY AT 77 FORMAT "99/99/9999" SKIP.
    PUT STREAM REPORT "Hora : " + STRING(TIME,"HH:MM AM") AT 94 FORMAT "X(20)" SKIP.
                      
    PUT STREAM REPORT {&PRN2} + {&PRN7A} + {&PRN6A} + "BOLETA DE DEPOSITO" + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(30)" AT 35 SKIP(2).
    PUT STREAM REPORT "NUMERO : " AT 1 
                      {&PRN6A} + CcbBolDep.NroDoc + {&PRN6B} AT 12 FORMAT "XXXXX-XXXXXXXXX" 
                      {&PRN2} + "FECHA : "  AT 35 FORMAT "X(10)" 
                      CcbBolDep.FchDoc AT 46 FORMAT "99/99/9999" 
                      {&PRN2} + {&PRN7A} + {&PRN6A} + CcbBolDep.FlgSit + {&PRN6B} + {&PRN7B} + {&PRN2} AT 65 FORMAT "X(20)" SKIP(1).
                      
    PUT STREAM REPORT "-----------------------------------------------------------------------------------" AT 1 SKIP(1).
    
    PUT STREAM REPORT "MONEDA : " AT 1 
                      F-MONEDA    AT 12 FORMAT "X(10)" 
                      "TIPO DE CAMBIO : " AT 27 
                      CcbBolDep.TpoCmb FORMAT ">>9.9999" AT 45 
                      "HORA : " AT 57
                      CcbBolDep.Hora AT 65 SKIP(1).    
    PUT STREAM REPORT "BANCO : " AT 1 
                      CcbBolDep.codbco AT 12 FORMAT "X(08)" 
                      "NUMERO DE DEPOSITO : " AT 27 
                      {&PRN6A} + CcbBolDep.NroRef + {&PRN6B} AT 49 FORMAT "X(20)" SKIP(1).
    PUT STREAM REPORT "CODIGO DE CUENTA : " AT 1 
                      CcbBolDep.CodCta AT 27 FORMAT "X(10)" 
                      CcbBolDep.DesCta AT 45 FORMAT "X(25)" SKIP(1).    
    PUT STREAM REPORT "AGENCIA : " AT 1 
                      CcbBolDep.CodAge AT 12 FORMAT "X(10)" 
                      "IMPORTE TOTAL : " AT 27 
                      CcbBolDep.ImpTot FORMAT ">>>>,>>9.99" AT 45 
                      "SALDO ACTUAL  : " AT 57 
                      CcbBolDep.SdoAct FORMAT ">>>>,>>9.99" AT 73 SKIP(1).    
    PUT STREAM REPORT "CLIENTE : " AT 1 
                      CcbBolDep.CodCli AT 12 FORMAT "X(10)" 
                      CcbBolDep.NomCli AT 27 FORMAT "X(40)" SKIP(1).

    PUT STREAM REPORT "-----------------------------------------------------------------------------------" AT 1 SKIP(1).

    PUT STREAM REPORT "DIVISION : " AT 1 
                      CcbBolDep.CodDiv AT 12 FORMAT "X(10)"
                      "AUTORIZO : " AT 27 
                      CcbBolDep.Autorizo AT 39 FORMAT "X(12)"
                      "Fecha AUTORIZACION : " at 52
                      CcbBolDep.FchAut at 74 SKIP(1).
    PUT STREAM REPORT "USUARIO : " AT 1 
                      {&PRN6A} + CcbBolDep.usuario  + {&PRN6B} AT 12 SKIP(1).
    OUTPUT STREAM Report CLOSE.

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
 DO WITH FRAME {&FRAME-NAME}:
    CASE HANDLE-CAMPO:name:
        WHEN "CODBCO" THEN ASSIGN input-var-1 = "04".
        WHEN "CODCTA" THEN ASSIGN input-var-1 = "10" input-var-2 = CcbBolDep.Codbco:SCREEN-VALUE.
        WHEN "CODAGE" THEN ASSIGN input-var-1 = CcbBolDep.Codbco:SCREEN-VALUE.
          /*
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.
 END.

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
  {src/adm/template/snd-list.i "CcbBolDep"}

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
DO WITH FRAME {&FRAME-NAME} :
    IF CcbBolDep.codbco:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de Banco no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CcbBolDep.Codbco.
         RETURN "ADM-ERROR".   
    END.
    IF CcbBolDep.CodCta:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de Cuenta no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CcbBolDep.CodCta.
         RETURN "ADM-ERROR".   
    END.
    
/***IF  CcbBolDep.CodAge:SCREEN-VALUE = "" THEN DO:
        MESSAGE "La Agencia no debe ser en blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO  CcbBolDep.CodAge.
       RETURN "ADM-ERROR".   
    END.    
    IF CcbBolDep.CodCli:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de Cliente no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CcbBolDep.CodCli.
         RETURN "ADM-ERROR".   
    END.***/
    /*
    IF CcbBolDep.NroRef:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Numero de deposito no debe ser blanco"
       VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO CcbBolDep.NroRef.
       RETURN "ADM-ERROR".   
    END.
    */     
    IF CcbBolDep.NroRef:SCREEN-VALUE <> "" AND CcbBolDep.CodBco:SCREEN-VALUE = "CR" THEN DO:
       FIND B-CcbBolDep WHERE B-CcbBolDep.CodCia = S-CODCIA 
                         AND  B-CcbBolDep.CodBco = CcbBolDep.CodBco:SCREEN-VALUE 
                         AND  B-CcbBolDep.CodCta = CcbBolDep.CodCta:SCREEN-VALUE 
                         /*AND  B-CcbBolDep.NroRef = CcbBolDep.NroRef:SCREEN-VALUE*/
                         AND B-CcbBoldep.FchReg = INPUT CcbBolDep.FchReg
                         AND B-CcbBoldep.ImpTot = INPUT CcbBolDep.ImpTot
                         AND  B-CcbBolDep.FlgEst <> "A" 
                        NO-LOCK NO-ERROR.
       IF AVAILABLE B-CcbBolDep AND ROWID(B-CcbBolDep) <> ROWID(CcbBolDep) THEN DO:
          MESSAGE "Numero de Deposito ya Existe" SKIP
                  "esta en Proceso Nro. " B-CcbBolDep.NroDoc SKIP
                  "en el Deposito  Nro. " B-CcbBolDep.NroRef 
                  "¿Continuamos con la grabación?"
                  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta-1 AS LOG.
          IF rpta-1 = NO THEN DO:
            APPLY "ENTRY" TO CcbBolDep.NroRef.
            RETURN "ADM-ERROR".
          END.
       END.
    END.
    IF DEC(CcbBolDep.ImpTot:SCREEN-VALUE) = 0 THEN DO:
         MESSAGE "El Importe Total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CcbBolDep.ImpTot.
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
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
IF CcbBolDep.FlgEst = "A" THEN
DO:
    MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF CcbBolDep.FlgEst = "C" THEN
DO:
    MESSAGE "El Documento se encuentra Cancelado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF CcbBolDep.FlgEst = "X" THEN
DO:
    MESSAGE "El Documento se encuentra Cerrado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF CcbBolDep.ImpTot <> CcbBolDep.SdoAct THEN
DO:
    MESSAGE "El Documento tiene Amortizaciones" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF CcbBolDep.FlgSit = "Autorizada" THEN
DO:
    MESSAGE "El Documento está Autorizado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.  

/*IF CcbBolDep.FlgSit = "Autorizada" THEN
 * DO:
 *     IF CcbBolDep.Autorizo <> s-user-id THEN DO:
 *         MESSAGE "El Documento esta Autorizado" VIEW-AS ALERT-BOX ERROR.
 *         RETURN "ADM-ERROR".
 *     END.
 * END.  */

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

