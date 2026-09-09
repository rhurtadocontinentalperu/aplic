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
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-coddiv  AS CHAR.
DEFINE VAR W-TIPDEP AS CHAR.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEF BUFFER b-CcbCChq FOR CcbCChq.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCChq
&Scoped-define FIRST-EXTERNAL-TABLE CcbCChq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCChq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCChq.CodDiv CcbCChq.FchDoc CcbCChq.CodMon ~
CcbCChq.Hora CcbCChq.codbco CcbCChq.NroRef CcbCChq.CodCta CcbCChq.CodAge ~
CcbCChq.ImpTot CcbCChq.CodCli 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}~
 ~{&FP1}FchDoc ~{&FP2}FchDoc ~{&FP3}~
 ~{&FP1}Hora ~{&FP2}Hora ~{&FP3}~
 ~{&FP1}codbco ~{&FP2}codbco ~{&FP3}~
 ~{&FP1}NroRef ~{&FP2}NroRef ~{&FP3}~
 ~{&FP1}CodCta ~{&FP2}CodCta ~{&FP3}~
 ~{&FP1}CodAge ~{&FP2}CodAge ~{&FP3}~
 ~{&FP1}ImpTot ~{&FP2}ImpTot ~{&FP3}~
 ~{&FP1}CodCli ~{&FP2}CodCli ~{&FP3}
&Scoped-define ENABLED-TABLES CcbCChq
&Scoped-define FIRST-ENABLED-TABLE CcbCChq
&Scoped-Define ENABLED-OBJECTS RECT-29 RECT-31 RECT-38 
&Scoped-Define DISPLAYED-FIELDS CcbCChq.CodDiv CcbCChq.NroDoc ~
CcbCChq.FchDoc CcbCChq.FlgSit CcbCChq.CodMon CcbCChq.TpoCmb CcbCChq.Hora ~
CcbCChq.codbco CcbCChq.NroRef CcbCChq.CodCta CcbCChq.DesCta CcbCChq.CodAge ~
CcbCChq.ImpTot CcbCChq.SdoAct CcbCChq.CodCli CcbCChq.NomCli CcbCChq.usuario ~
CcbCChq.Autorizo CcbCChq.FchAut 
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
     SIZE 72.57 BY 1.31.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72.57 BY 3.08.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72.29 BY 4.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCChq.CodDiv AT ROW 7.73 COL 6 COLON-ALIGNED
          LABEL "Division"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .69
     CcbCChq.NroDoc AT ROW 1.27 COL 6 COLON-ALIGNED FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .81
          FONT 0
     CcbCChq.FchDoc AT ROW 1.27 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCChq.FlgSit AT ROW 1.27 COL 43 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Pendiente","Autorizada","Rechazada" 
          SIZE 11.29 BY 1
     F-Estado AT ROW 1.27 COL 55.29 COLON-ALIGNED NO-LABEL
     CcbCChq.CodMon AT ROW 2.81 COL 15 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .54
     CcbCChq.TpoCmb AT ROW 2.65 COL 43.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbCChq.Hora AT ROW 2.65 COL 60 COLON-ALIGNED FORMAT "xx:xx"
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .69
     CcbCChq.codbco AT ROW 3.69 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     CcbCChq.NroRef AT ROW 3.69 COL 28.57 COLON-ALIGNED
          LABEL "Nro. Cheque" FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 18.72 BY .69
     CcbCChq.CodCta AT ROW 4.54 COL 12.72 COLON-ALIGNED
          LABEL "Codigo de Cuenta"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbCChq.DesCta AT ROW 4.54 COL 21.72 COLON-ALIGNED NO-LABEL FORMAT "X(40)"
          VIEW-AS FILL-IN 
          SIZE 45 BY .69
     CcbCChq.CodAge AT ROW 5.35 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbCChq.ImpTot AT ROW 5.38 COL 32.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
     CcbCChq.SdoAct AT ROW 5.35 COL 55.29 COLON-ALIGNED
          LABEL "Saldo Actual"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
     CcbCChq.CodCli AT ROW 6.88 COL 6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCChq.NomCli AT ROW 6.88 COL 16.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .69
     CcbCChq.usuario AT ROW 8.62 COL 6.14 COLON-ALIGNED
          LABEL "User"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCChq.Autorizo AT ROW 7.73 COL 27.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbCChq.FchAut AT ROW 7.73 COL 54 COLON-ALIGNED
          LABEL "Fecha Autorizacion"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     RECT-29 AT ROW 1 COL 1
     RECT-31 AT ROW 6.54 COL 1
     RECT-38 AT ROW 2.35 COL 1.14
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
   External Tables: integral.CcbCChq
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
         WIDTH              = 73.
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

/* SETTINGS FOR FILL-IN CcbCChq.Autorizo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCChq.CodCta IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCChq.CodDiv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCChq.DesCta IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCChq.FchAut IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX CcbCChq.FlgSit IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCChq.Hora IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCChq.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCChq.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCChq.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCChq.SdoAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCChq.TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCChq.usuario IN FRAME F-Main
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CcbCChq.CodAge
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCChq.CodAge V-table-Win
ON LEAVE OF CcbCChq.CodAge IN FRAME F-Main /* Agencia */
DO:
/*
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY 
        "" @ CcbCChq.Codage 
        WITH FRAME {&FRAME-NAME}.
    RETURN.
  END.    
  IF AVAIL cb-ctas THEN DO: 
    FIND gn-agbco WHERE gn-agbco.codcia = s-codcia 
                   AND  gn-agbco.Codbco = cb-ctas.codbco 
                   AND  gn-agbco.Codage = SELF:SCREEN-VALUE
                 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-agbco THEN DO:
      MESSAGE "Agencia no registrado" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
    END.
    DISPLAY 
      gn-agbco.Codage @ CcbCChq.Codage 
      WITH FRAME {&FRAME-NAME}.  
    END.
  ELSE DO:
      MESSAGE "Cuenta no registrado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CcbCChq.CodCta.
      RETURN "ADM-ERROR".   
  END.      
*/    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCChq.codbco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCChq.codbco V-table-Win
ON LEAVE OF CcbCChq.codbco IN FRAME F-Main /* Banco */
DO:
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY 
        "" @ CcbCChq.codbco 
        WITH FRAME {&FRAME-NAME}.
    RETURN.
  END.
  FIND cb-tabl WHERE cb-tabl.Tabla  = "04"
                AND  cb-tabl.Codigo = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-tabl THEN DO:
    MESSAGE "Banco no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  DISPLAY 
    cb-tabl.Codigo @ CcbCChq.codbco 
    WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCChq.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCChq.CodCli V-table-Win
ON LEAVE OF CcbCChq.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY 
        "" @ CcbCChq.NomCli 
        WITH FRAME {&FRAME-NAME}.
    RETURN.
  END.    
  FIND gn-clie WHERE gn-clie.codcia = 0 
                AND  gn-clie.codcli = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
    MESSAGE "Cliente no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  DISPLAY 
    gn-clie.nomcli @ CcbCChq.NomCli 
/*    gn-clie.ruc @ FILL-IN_Ruc */
    WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCChq.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCChq.CodCta V-table-Win
ON LEAVE OF CcbCChq.CodCta IN FRAME F-Main /* Codigo de Cuenta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY 
        "" @ CcbCChq.CodCta 
        WITH FRAME {&FRAME-NAME}.
    RETURN.
  END.    
                 
  FIND cb-ctas WHERE cb-ctas.codcia = 0 
                AND  cb-ctas.Codcta = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-ctas THEN DO:
    MESSAGE "Cuenta no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  CcbCChq.CodMon:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cb-ctas.Codmon).
  CcbCChq.Descta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cb-ctas.Nomcta. 
  DISPLAY 
    cb-ctas.Codcta @ CcbCChq.Codcta 
    cb-ctas.Nomcta @ CcbCChq.Descta WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCChq.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCChq.FchDoc V-table-Win
ON LEAVE OF CcbCChq.FchDoc IN FRAME F-Main /* Fecha */
DO:
    FIND gn-tcmb WHERE gn-tcmb.fecha = DATE(CcbCChq.FchDoc:SCREEN-VALUE) NO-LOCK NO-ERROR.
    IF AVAIL gn-tcmb THEN 
    DISPLAY 
        gn-tcmb.compra @ CcbCChq.TpoCmb WITH FRAME {&FRAME-NAME}.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCChq.Hora
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCChq.Hora V-table-Win
ON LEAVE OF CcbCChq.Hora IN FRAME F-Main /* Hora */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     IF SELF:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'No se ha registrado la hora de deposito a Banco' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO SELF.
        RETURN NO-APPLY.
     END.
     IF INTEGER(SUBSTRING(SELF:SCREEN-VALUE,1,2)) > 24 THEN DO:
        MESSAGE 'La hora no puede ser mayor a 24 HORAS' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO SELF.
        RETURN NO-APPLY.
     END.
     IF INTEGER(SUBSTRING(SELF:SCREEN-VALUE,4,2)) > 60 THEN DO:
        MESSAGE 'Los minutos no pueden ser mayor a 60 MINUTOS' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO SELF.
        RETURN NO-APPLY.
     END.
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
  {src/adm/template/row-list.i "CcbCChq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCChq"}

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
        TODAY @ CcbCChq.FchDoc
        gn-tcmb.compra @ CcbCChq.TpoCmb WITH FRAME {&FRAME-NAME}. 
  
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
                       AND  FacCorre.CodDoc = s-coddoc 
/*                 AND  FacCorre.CodDiv = s-coddiv */
                EXCLUSIVE-LOCK.

   FacCorre.Correlativo = FacCorre.Correlativo + 1.
   CcbCChq.NroDoc = STRING(faccorre.nroser, "999") + 
                      STRING(faccorre.correlativo, "999999").

   RELEASE faccorre.
  
END.
 
  ASSIGN
    CcbCChq.CodCia = s-codcia
    CcbCChq.CodDIV = s-coddiv
    CcbCChq.CodDoc = s-coddoc
    CcbCChq.usuario= s-user-id
   
    CcbCChq.SdoAct = CcbCChq.ImpTot
    CcbCChq.Nomcli = CcbCChq.Nomcli:screen-value in frame {&frame-name}
    CcbCChq.DesCta = CcbCChq.Descta:screen-value in frame {&frame-name}
    CcbCChq.Codmon = INTEGER (CcbCChq.Codmon:screen-value in frame {&frame-name}).
IF L-CREA THEN DO:
    ASSIGN 
    CcbCChq.FlgEst = "" 
    CcbCChq.FchReg = TODAY
    CcbCChq.FchAut = DATE("").
    
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

     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  
  /* Dispatch standard ADM method.                             */
/*  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
   FIND b-CcbCChq WHERE b-CcbCChq.CodCia = CcbCChq.CodCia AND 
        b-CcbCChq.CodDoc = CcbCChq.CodDoc AND 
        b-CcbCChq.NroDoc = CcbCChq.NroDoc NO-ERROR.
   IF AVAILABLE b-CcbCChq THEN ASSIGN b-CcbCChq.FlgEst = "A".
/*   FIND b-CcbCChq OF CcbCChq EXCLUSIVE-LOCK.
       ASSIGN b-CcbCChq.FlgEst = "A". */
   RELEASE b-CcbCChq.
   
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

  IF AVAILABLE CcbCChq THEN DO WITH FRAME {&FRAME-NAME}:
     IF CcbCChq.FlgEst = "" THEN F-Estado:SCREEN-VALUE = "".
     IF CcbCChq.FlgEst = "P" THEN F-Estado:SCREEN-VALUE = "PENDIENTE".
     IF CcbCChq.FlgEst = "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
     IF CcbCChq.FlgEst = "C" THEN F-Estado:SCREEN-VALUE = "CANCELADO".
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
 input-var-1 = "".
 input-var-2 = "".
 input-var-3 = "".
   
 DO WITH FRAME {&FRAME-NAME}:
    CASE HANDLE-CAMPO:name:
        WHEN "CODBCO" THEN ASSIGN input-var-1 = "04".
        WHEN "CODCTA" THEN ASSIGN input-var-1 = "10" input-var-2 = CcbCChq.Codbco:SCREEN-VALUE.
        WHEN "CODAGE" THEN ASSIGN input-var-1 = CcbCChq.Codbco:SCREEN-VALUE.
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
  {src/adm/template/snd-list.i "CcbCChq"}

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
    IF CcbCChq.codbco:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de Banco no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CcbCChq.Codbco.
         RETURN "ADM-ERROR".   
    END.
    IF CcbCChq.CodCta:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de Cuenta no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CcbCChq.CodCta.
         RETURN "ADM-ERROR".   
    END.
    
/***IF  CcbCChq.CodAge:SCREEN-VALUE = "" THEN DO:
        MESSAGE "La Agencia no debe ser en blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO  CcbCChq.CodAge.
       RETURN "ADM-ERROR".   
    END.    
    IF CcbCChq.CodCli:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Codigo de Cliente no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CcbCChq.CodCli.
         RETURN "ADM-ERROR".   
    END.***/
    /*
    IF CcbCChq.NroRef:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Numero de deposito no debe ser blanco"
       VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO CcbCChq.NroRef.
       RETURN "ADM-ERROR".   
    END.
    */     
    IF CcbCChq.NroRef:SCREEN-VALUE <> "" AND CcbCChq.CodBco:SCREEN-VALUE = "CR" THEN DO:
       FIND B-CcbCChq WHERE B-CcbCChq.CodCia = S-CODCIA AND
            B-CcbCChq.CodBco = CcbCChq.CodBco:SCREEN-VALUE AND
            B-CcbCChq.CodCta = CcbCChq.CodCta:SCREEN-VALUE AND
            B-CcbCChq.NroRef = CcbCChq.NroRef:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF AVAILABLE B-CcbCChq AND ROWID(B-CcbCChq) <> ROWID(CcbCChq) THEN DO:
          MESSAGE "Numero de Deposito ya Existe" SKIP
                  "esta en Proceso Nro. " B-CcbCChq.NroDoc SKIP
                  "en el Voucher   Nro. " B-CcbCChq.NroAst VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO CcbCChq.NroRef.
          RETURN "ADM-ERROR".
       END.
    END.
    IF DEC(CcbCChq.ImpTot:SCREEN-VALUE) = 0 THEN DO:
         MESSAGE "El Importe Total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CcbCChq.ImpTot.
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
IF CcbCChq.FlgEst = "A" THEN
DO:
    MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF CcbCChq.FlgEst = "C" THEN
DO:
    MESSAGE "El Documento se encuentra Cancelado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF CcbCChq.ImpTot > CcbCChq.SdoAct THEN
DO:
    MESSAGE "El Documento tiene Amortizaciones" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/*
IF CcbCChq.FlgSit = "Autorizada" THEN
DO:
    MESSAGE "El Documento esta Autorizado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.  */
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


