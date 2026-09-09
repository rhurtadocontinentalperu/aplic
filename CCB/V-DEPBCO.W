&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
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
DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-codcta LIKE cb-ctas.codcta.
DEF SHARED VAR s-user-id AS CHAR.

DEF SHARED TEMP-TABLE MVTO LIKE ccbdmvto.

DEF BUFFER b-ccbcmvto FOR ccbcmvto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCMvto
&Scoped-define FIRST-EXTERNAL-TABLE CcbCMvto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCMvto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCMvto.CodDiv CcbCMvto.CodCta ~
CcbCMvto.Glosa 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}~
 ~{&FP1}CodCta ~{&FP2}CodCta ~{&FP3}~
 ~{&FP1}Glosa ~{&FP2}Glosa ~{&FP3}
&Scoped-define ENABLED-TABLES CcbCMvto
&Scoped-define FIRST-ENABLED-TABLE CcbCMvto
&Scoped-Define ENABLED-OBJECTS RECT-3 
&Scoped-Define DISPLAYED-FIELDS CcbCMvto.CodDiv CcbCMvto.CodCta ~
CcbCMvto.CodMon CcbCMvto.Glosa CcbCMvto.FchDoc CcbCMvto.Usuario 
&Scoped-Define DISPLAYED-OBJECTS s-NroSer s-nrocor FILL-IN-1 X-Status 

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
DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE s-nrocor AS INTEGER FORMAT "999999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE s-NroSer AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Deposito No." 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE X-Status AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60 BY 4.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     s-NroSer AT ROW 1.19 COL 13 COLON-ALIGNED
     CcbCMvto.CodDiv AT ROW 1.96 COL 13 COLON-ALIGNED
          LABEL "Division" FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     CcbCMvto.CodCta AT ROW 2.73 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     CcbCMvto.CodMon AT ROW 3.5 COL 15 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .77
     CcbCMvto.Glosa AT ROW 4.27 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     s-nrocor AT ROW 1.19 COL 17 COLON-ALIGNED NO-LABEL
     FILL-IN-1 AT ROW 2.73 COL 22 COLON-ALIGNED NO-LABEL
     CcbCMvto.FchDoc AT ROW 1.19 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCMvto.Usuario AT ROW 1.96 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     X-Status AT ROW 3.5 COL 47 COLON-ALIGNED
     RECT-3 AT ROW 1 COL 1
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 3.65 COL 8
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.58
         WIDTH              = 61.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCMvto.CodDiv IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR RADIO-SET CcbCMvto.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-nrocor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-NroSer IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.Usuario IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN X-Status IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CcbCMvto.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodCta V-table-Win
ON LEAVE OF CcbCMvto.CodCta IN FRAME F-Main /* Cuenta Contable */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND cb-ctas WHERE cb-ctas.CodCia = 0 AND 
    cb-ctas.Codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-ctas
  THEN DO:
    MESSAGE "Codigo de cuenta no registrado" VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
  IF NOT cb-ctas.codcta BEGINS "104"
  THEN DO:
    MESSAGE "Debe ser una cuenta de bancos" VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
  ASSIGN
    s-codcta = cb-ctas.codcta
    FILL-IN-1:SCREEN-VALUE = cb-ctas.Nomcta
    CcbCMvto.CodMon:SCREEN-VALUE = STRING(cb-ctas.Codmon).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodDiv V-table-Win
ON LEAVE OF CcbCMvto.CodDiv IN FRAME F-Main /* Division */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-divi WHERE GN-DIVI.CodCia = s-codcia AND
    GN-DIVI.CodDiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-divi
  THEN DO:
    MESSAGE "Codigo de division no registrado" VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s-NroSer V-table-Win
ON LEAVE OF s-NroSer IN FRAME F-Main /* Deposito No. */
DO:
  ASSIGN s-NroSer.
  FIND faccorre WHERE faccorre.codcia = s-codcia AND faccorre.coddoc = s-coddoc
    AND faccorre.nroser = s-nroser NO-LOCK NO-ERROR.
  IF AVAILABLE faccorre
  THEN s-nrocor:SCREEN-VALUE = STRING(faccorre.correlativo).
  ELSE s-nrocor:SCREEN-VALUE = "".
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
  FOR EACH MVTO:
    DELETE MVTO.
  END.
  RUN Cambia-Pantalla IN lh_handle (2).
  DO WITH FRAME {&FRAME-NAME}:
      FIND FIRST faccorre WHERE FacCorre.CodCia = s-codcia AND
        FacCorre.CodDoc = s-coddoc NO-LOCK.
      ASSIGN
        s-NroSer = faccorre.nroser
        s-NroCor = faccorre.correlativo
        s-NroSer:SCREEN-VALUE = STRING(faccorre.nroser, "999")
        s-NroCor:SCREEN-VALUE = STRING(faccorre.correlativo, "999999").
      FIND NEXT faccorre WHERE FacCorre.CodCia = s-codcia AND
        FacCorre.CodDoc = s-coddoc NO-LOCK NO-ERROR.
      IF AVAILABLE faccorre
      THEN DO:
        APPLY "ENTRY":U TO s-nroser.
        ASSIGN
            s-NroSer:SENSITIVE     = YES.
      END.
      ELSE ASSIGN
            s-NroSer:SENSITIVE     = NO.
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
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
    FIND faccorre WHERE FacCorre.CodCia = s-codcia AND
      FacCorre.CodDoc = s-coddoc AND FacCorre.NroSer = s-nroser
      EXCLUSIVE-LOCK.
    ASSIGN
      ccbcmvto.codcia = s-codcia
      ccbcmvto.coddoc = s-coddoc
      ccbcmvto.nrodoc = STRING(FacCorre.NroSer, "999") +
                          STRING(FacCorre.Correlativo, "999999")
      ccbcmvto.codmon = cb-ctas.codmon
      ccbcmvto.usuario= s-user-id
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE faccorre.
    /* grabamos el detalle */
    FOR EACH MVTO:
      CREATE ccbdmvto.
      ASSIGN
          CcbDMvto.CodCia = s-codcia 
          CcbDMvto.CodDoc = s-coddoc
          CcbDMvto.NroDoc = CcbCMvto.NroDoc
          CcbDMvto.FchCie = MVTO.fchcie
          CcbDMvto.HorCie = MVTO.horcie
          CcbDMvto.usuario= MVTO.usuario.
      IF ccbcmvto.codmon = 1
      THEN ASSIGN
          CcbDMvto.DepNac[1] = MVTO.depnac[1]
          CcbDMvto.DepNac[2] = MVTO.depnac[2]
          CcbDMvto.DepNac[3] = MVTO.depnac[3].
      ELSE ASSIGN
          CcbDMvto.DepUsa[1] = MVTO.depnac[1]
          CcbDMvto.DepUsa[2] = MVTO.depnac[2]
          CcbDMvto.DepUsa[3] = MVTO.depnac[3].
      /* actualizamos cierre de caja */
      FIND ccbcierr OF ccbdmvto EXCLUSIVE-LOCK.
      IF ccbcmvto.codmon = 1
      THEN ASSIGN
          CcbCierr.DepNac[1] = CcbCierr.DepNac[1] + MVTO.depnac[1]
          CcbCierr.DepNac[2] = CcbCierr.DepNac[2] + MVTO.depnac[2]
          CcbCierr.DepNac[3] = CcbCierr.DepNac[3] + MVTO.depnac[3].
      ELSE ASSIGN
          CcbCierr.DepUsa[1] = CcbCierr.DepUsa[1] + MVTO.depnac[1]
          CcbCierr.DepUsa[2] = CcbCierr.DepUsa[2] + MVTO.depnac[2]
          CcbCierr.DepUsa[3] = CcbCierr.DepUsa[3] + MVTO.depnac[3].
      IF (CcbCierr.DepNac[1] + CcbCierr.DepNac[2] + CcbCierr.DepNac[3]) +
          (CcbCierr.DepUsa[1] + CcbCierr.DepUsa[2] + CcbCierr.DepUsa[3]) -
          (CcbCierr.ImpNac[1] + CcbCierr.ImpNac[2] + CcbCierr.ImpNac[3]) -
          (CcbCierr.ImpUsa[1] + CcbCierr.ImpUsa[2] + CcbCierr.ImpUsa[3]) >= 0
      THEN CcbCierr.FlgEst = "D".     /* Depositado */
      DELETE MVTO.
    END.        
  END.                    

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
  RUN Cambia-Pantalla IN lh_handle (1).
  ASSIGN
    s-NroSer:SENSITIVE      IN FRAME {&FRAME-NAME} = NO.
    
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
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
      /* borramos detalle */
      FIND cb-ctas WHERE cb-ctas.codcia = 0 AND
        cb-ctas.codcta = ccbcmvto.codcta NO-LOCK.
      FOR EACH ccbdmvto WHERE ccbdmvto.codcia = ccbcmvto.codcia AND
            ccbdmvto.coddoc = ccbcmvto.coddoc AND
            ccbdmvto.nrodoc = ccbcmvto.nrodoc EXCLUSIVE-LOCK:
        FIND ccbcierr OF ccbdmvto EXCLUSIVE-LOCK.
        ASSIGN
            CcbCierr.DepNac[1] = CcbCierr.DepNac[1] - ccbdmvto.depnac[1]
            CcbCierr.DepNac[2] = CcbCierr.DepNac[2] - ccbdmvto.depnac[2]
            CcbCierr.DepNac[3] = CcbCierr.DepNac[3] - ccbdmvto.depnac[3]
            CcbCierr.DepUsa[1] = CcbCierr.DepUsa[1] - ccbdmvto.depusa[1]
            CcbCierr.DepUsa[2] = CcbCierr.DepUsa[2] - ccbdmvto.depusa[2]
            CcbCierr.DepUsa[3] = CcbCierr.DepUsa[3] - ccbdmvto.depusa[3]
            CcbCierr.FlgEst = "P".
        DELETE ccbdmvto.
      END.
      /* NO SE BORRA, SE MARCA COMO ANULADO 
      /* Dispatch standard ADM method.                             */
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
      */
      FIND b-ccbcmvto WHERE ROWID(b-ccbcmvto) = ROWID(ccbcmvto) EXCLUSIVE-LOCK.
      ASSIGN 
        b-ccbcmvto.flgest = "A".
      RELEASE b-ccbcmvto.
  END.    
  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN repintar-browse-1 IN lh_handle.
  
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
  IF AVAILABLE ccbcmvto 
  THEN DO WITH FRAME {&FRAME-NAME}:
    FIND cb-ctas WHERE cb-ctas.codcia = 0 AND cb-ctas.codcta = ccbcmvto.codcta
        NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas 
    THEN FILL-IN-1:SCREEN-VALUE = cb-ctas.nomcta.
    ELSE FILL-IN-1:SCREEN-VALUE = "".
    CASE ccbcmvto.flgest:
    WHEN "A" THEN X-Status:SCREEN-VALUE = "ANULADO".
    OTHERWISE X-Status:SCREEN-VALUE = "EMITIDO".
    END CASE.
    ASSIGN
        s-nroser:SCREEN-VALUE = SUBSTRING(ccbcmvto.nrodoc,1,3)
        s-nrocor:SCREEN-VALUE = SUBSTRING(ccbcmvto.nrodoc,4).
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
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Cambia-Pantalla IN lh_handle (1).
  ASSIGN
    s-NroSer:SENSITIVE      IN FRAME {&FRAME-NAME} = NO.

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
        WHEN "CodCta" THEN 
            ASSIGN
                input-var-1 = "104"
                input-var-2 = ""
                input-var-3 = "".
    END CASE.

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
    FIND faccorre WHERE faccorre.codcia = s-codcia AND
        faccorre.coddoc = s-coddoc AND
        faccorre.nroser = s-nroser NO-LOCK NO-ERROR.
    IF NOT AVAILABLE faccorre
    THEN DO:
        MESSAGE "Numero de serie no registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
        gn-divi.coddiv = ccbcmvto.coddiv:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi
    THEN DO:
        MESSAGE "Codigo de division no registrado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO ccbcmvto.coddiv.
        RETURN "ADM-ERROR".
    END.
    FIND cb-ctas WHERE cb-ctas.codcia = 0 AND 
        cb-ctas.codcta = ccbcmvto.codcta:SCREEN-VALUE  NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas
    THEN DO:
        MESSAGE "Codigo de cuenta no registrado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO ccbcmvto.codcta.
        RETURN "ADM-ERROR".
    END.
    IF NOT cb-ctas.codcta BEGINS "104"
    THEN DO:
        MESSAGE "No es una cuenta de bancos" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO ccbcmvto.codcta.
        RETURN "ADM-ERROR".
    END.
    FIND FIRST MVTO NO-LOCK NO-ERROR.
    IF NOT AVAILABLE MVTO
    THEN DO:
        MESSAGE "No ha ingresado ningun deposito" VIEW-AS ALERT-BOX ERROR.
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
MESSAGE "Acceso denegado" VIEW-AS ALERT-BOX ERROR.
RETURN "ADM-ERROR".
/*RETURN "OK".*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


