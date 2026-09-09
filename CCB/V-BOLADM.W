&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEFINE STREAM report.

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-coddiv  AS CHAR.
DEF SHARED VAR s-nomcia  AS CHAR.
DEFINE VAR W-TIPDEP AS CHAR.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEF BUFFER b-CcbBoldep FOR CcbBoldep.

FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/*
DEFINE VARIABLE x-nrodoc LIKE CcbBolDep.NroDoc.

FIND FIRST CcbBolDep WHERE CcbBolDep.NRODOC = x-nrodoc NO-ERROR.
     /*IF AVAILABLE CcbDMvto THEN x-nrodoc = CcbBolDep.NroDoc.*/
     */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbBolDep
&Scoped-define FIRST-EXTERNAL-TABLE CcbBolDep


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbBolDep.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbBolDep.CodDiv CcbBolDep.CodCli ~
CcbBolDep.NomCli 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}~
 ~{&FP1}CodCli ~{&FP2}CodCli ~{&FP3}~
 ~{&FP1}NomCli ~{&FP2}NomCli ~{&FP3}
&Scoped-define ENABLED-TABLES CcbBolDep
&Scoped-define FIRST-ENABLED-TABLE CcbBolDep
&Scoped-Define ENABLED-OBJECTS RECT-29 RECT-31 RECT-38 
&Scoped-Define DISPLAYED-FIELDS CcbBolDep.CodDiv CcbBolDep.NroDoc ~
CcbBolDep.FchDoc CcbBolDep.FlgSit CcbBolDep.CodMon CcbBolDep.TpoCmb ~
CcbBolDep.Hora CcbBolDep.codbco CcbBolDep.NroRef CcbBolDep.TipDep ~
CcbBolDep.CodCta CcbBolDep.DesCta CcbBolDep.CodAge CcbBolDep.ImpTot ~
CcbBolDep.SdoAct CcbBolDep.CodCli CcbBolDep.NomCli CcbBolDep.usuario ~
CcbBolDep.Autorizo CcbBolDep.FchAut 
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
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .81
     FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72 BY 1.31.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72 BY 3.08.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72 BY 4.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbBolDep.CodDiv AT ROW 7.73 COL 6 COLON-ALIGNED
          LABEL "Division" FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .69
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
          SIZE 11.29 BY 1
     F-Estado AT ROW 1.27 COL 55.29 COLON-ALIGNED NO-LABEL
     CcbBolDep.CodMon AT ROW 2.81 COL 15 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .54
     CcbBolDep.TpoCmb AT ROW 2.65 COL 43.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbBolDep.Hora AT ROW 2.65 COL 60 COLON-ALIGNED FORMAT "xx:xx"
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .69
     CcbBolDep.codbco AT ROW 3.69 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     CcbBolDep.NroRef AT ROW 3.69 COL 32 COLON-ALIGNED
          LABEL "Nro. Deposito"
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     CcbBolDep.TipDep AT ROW 3.69 COL 50.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Efectivo", "EFE":U,
"Cheque", "CHQ":U
          SIZE 18.72 BY .73
     CcbBolDep.CodCta AT ROW 4.54 COL 12.72 COLON-ALIGNED
          LABEL "Codigo de Cuenta"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbBolDep.DesCta AT ROW 4.54 COL 21.72 COLON-ALIGNED NO-LABEL FORMAT "X(40)"
          VIEW-AS FILL-IN 
          SIZE 45 BY .69
     CcbBolDep.CodAge AT ROW 5.35 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbBolDep.ImpTot AT ROW 5.38 COL 32.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
     CcbBolDep.SdoAct AT ROW 5.35 COL 55.29 COLON-ALIGNED
          LABEL "Saldo Actual"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
     CcbBolDep.CodCli AT ROW 6.88 COL 6 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbBolDep.NomCli AT ROW 6.88 COL 17.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 47 BY .69
     CcbBolDep.usuario AT ROW 8.62 COL 6.14 COLON-ALIGNED
          LABEL "User"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbBolDep.Autorizo AT ROW 7.73 COL 27.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbBolDep.FchAut AT ROW 7.73 COL 54 COLON-ALIGNED
          LABEL "Fecha Autorizacion"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     RECT-29 AT ROW 1 COL 1
     RECT-31 AT ROW 6.54 COL 1
     RECT-38 AT ROW 2.35 COL 1
     "Moneda" VIEW-AS TEXT
          SIZE 6.57 BY .5 AT ROW 2.85 COL 8
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 8.77
         WIDTH              = 72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbBolDep.Autorizo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.CodAge IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.codbco IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbBolDep.CodCta IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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
/* SETTINGS FOR COMBO-BOX CcbBolDep.FlgSit IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.Hora IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbBolDep.ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbBolDep.NroRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbBolDep.SdoAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR RADIO-SET CcbBolDep.TipDep IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbBolDep.usuario IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CcbBolDep.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbBolDep.CodCli V-table-Win
ON LEAVE OF CcbBolDep.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY "" @ CcbBolDep.NomCli WITH FRAME {&FRAME-NAME}.
     RETURN.
  END.
  FIND gn-clie WHERE gn-clie.codcia = 0 
                AND  gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
    MESSAGE "Cliente no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  DISPLAY gn-clie.nomcli @ CcbBolDep.NomCli WITH FRAME {&FRAME-NAME}.
  IF SELF:SCREEN-VALUE = FacCfgGn.CliVar THEN 
     CcbBolDep.NomCli:SENSITIVE = YES.
  ELSE CcbBolDep.NomCli:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbBolDep.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbBolDep.CodDiv V-table-Win
ON LEAVE OF CcbBolDep.CodDiv IN FRAME F-Main /* Division */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
       GN-DIVI.CodDiv = CcbBolDep.CodDiv:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-DIVI THEN DO:
     MESSAGE "Division no existe " VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
  
    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
    DISPLAY 
        TODAY @ CcbBolDep.FchDoc
        gn-tcmb.compra @ CcbBolDep.TpoCmb WITH FRAME {&FRAME-NAME}. 
  
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
    ccbboldep.CodCia = s-codcia
    ccbboldep.CodDIV = s-coddiv
    ccbboldep.CodDoc = s-coddoc
    CcbBolDep.SdoAct = CcbBolDep.ImpTot
    CcbBoldep.Nomcli = CcbBoldep.Nomcli:screen-value in frame {&frame-name}
    CcbBoldep.DesCta = CcbBoldep.Descta:screen-value in frame {&frame-name}
    CcbBoldep.Codmon = INTEGER (CcbBoldep.Codmon:screen-value in frame {&frame-name})
    CcbBolDep.TipDep = w-tipdep.

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

     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  
  /* Dispatch standard ADM method.                             */
/*  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
   FIND b-CcbBoldep WHERE b-CcbBolDep.CodCia = CcbBolDep.CodCia AND 
        b-CcbBolDep.CodDoc = CcbBolDep.CodDoc AND 
        b-CcbBolDep.NroDoc = CcbBolDep.NroDoc NO-ERROR.
   IF AVAILABLE b-CcbBolDep THEN ASSIGN b-CcbBoldep.FlgEst = "A".
/*   FIND b-CcbBoldep OF CcbBoldep EXCLUSIVE-LOCK.
       ASSIGN b-CcbBoldep.FlgEst = "A". */
   RELEASE b-CcbBoldep.
   
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
     IF CcbBoldep.FlgEst = "" THEN F-Estado:SCREEN-VALUE = "".
     IF CcbBoldep.FlgEst = "P" THEN F-Estado:SCREEN-VALUE = "PENDIENTE".
     IF CcbBoldep.FlgEst = "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
     IF CcbBoldep.FlgEst = "C" THEN F-Estado:SCREEN-VALUE = "CANCELADO".
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
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
  
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     L-CREA = NO.
     CcbBolDep.NomCli:SENSITIVE = NO.
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
   IF CcbBolDep.CodCli:SCREEN-VALUE <> "" THEN DO:
      FIND gn-clie WHERE 
           gn-clie.codcia = 0 AND  
           gn-clie.codcli = CcbBolDep.CodCli:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
         MESSAGE "Cliente no registrado" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CcbBolDep.CodCli.
         RETURN "ADM-ERROR".   
      END.
   END.
   IF CcbBolDep.CodDiv:SCREEN-VALUE <> "" THEN DO:
      FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
           GN-DIVI.CodDiv = CcbBolDep.CodDiv:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF NOT AVAILABLE GN-DIVI THEN DO:
         MESSAGE "Division no existe " VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CcbBolDep.CodDiv.
         RETURN "ADM-ERROR".   
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
IF CcbBolDep.ImpTot > CcbBolDep.SdoAct THEN
DO:
    MESSAGE "El Documento tiene Amortizaciones" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


