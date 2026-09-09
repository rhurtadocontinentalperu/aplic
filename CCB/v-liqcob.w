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

DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddiv  AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-ptovta  AS INTE.
DEF SHARED VAR s-tipo    AS CHAR.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-codcli  LIKE gn-clie.codcli.
DEF SHARED VAR s-codcob  LIKE gn-cob.codcob.
DEF SHARED VAR s-tpocmb  AS DEC.

DEF VAR s-ok AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR X-ImpNac AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR X-ImpUsa AS DECIMAL INITIAL 0 NO-UNDO.

DEF SHARED TEMP-TABLE T-CcbDCob LIKE CcbDCob.
DEF SHARED TEMP-TABLE T-CcbCCob LIKE CcbCCob.
DEF BUFFER b-CcbCCob FOR CcbCCob.
DEF BUFFER b-CcbDCob FOR CcbDCob.
DEF BUFFER b-CDocu   FOR ccbcdocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCCob
&Scoped-define FIRST-EXTERNAL-TABLE CcbCCob


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCCob.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCCob.CodCob CcbCCob.Glosa CcbCCob.TpoCmb 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodCob ~{&FP2}CodCob ~{&FP3}~
 ~{&FP1}Glosa ~{&FP2}Glosa ~{&FP3}~
 ~{&FP1}TpoCmb ~{&FP2}TpoCmb ~{&FP3}
&Scoped-define ENABLED-TABLES CcbCCob
&Scoped-define FIRST-ENABLED-TABLE CcbCCob
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS CcbCCob.NroDoc CcbCCob.CodCob CcbCCob.Glosa ~
CcbCCob.TpoCmb CcbCCob.FchDoc CcbCCob.usuario 
&Scoped-Define DISPLAYED-OBJECTS F-NomCob X-Status 

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
DEFINE VARIABLE F-NomCob AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .69 NO-UNDO.

DEFINE VARIABLE X-Status AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 67.57 BY 3.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCCob.NroDoc AT ROW 1.19 COL 7 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .69
          FONT 0
     CcbCCob.CodCob AT ROW 1.88 COL 6.86 COLON-ALIGNED
          LABEL "Cobrador"
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .69
     CcbCCob.Glosa AT ROW 2.69 COL 7 COLON-ALIGNED
          LABEL "Concepto"
          VIEW-AS FILL-IN 
          SIZE 39 BY .69
     F-NomCob AT ROW 1.88 COL 16.14 COLON-ALIGNED NO-LABEL
     X-Status AT ROW 1.19 COL 54.14 COLON-ALIGNED
     CcbCCob.TpoCmb AT ROW 1.88 COL 54.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbCCob.FchDoc AT ROW 2.69 COL 54.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .69
     CcbCCob.usuario AT ROW 3.54 COL 54.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.86 BY .69
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCCob
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
         HEIGHT             = 5.04
         WIDTH              = 67.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCCob.CodCob IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-NomCob IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCob.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCob.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCob.NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCob.usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbCCob.CodCob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCob.CodCob V-table-Win
ON LEAVE OF CcbCCob.CodCob IN FRAME F-Main /* Cobrador */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-cob WHERE gn-cob.codcia = S-CODCIA AND
                    gn-cob.codcob = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-cob
  THEN DO:
    MESSAGE "Cobrador no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  DISPLAY gn-cob.nomcob @ F-Nomcob
          WITH FRAME {&FRAME-NAME}.

  s-codcli = SELF:SCREEN-VALUE.
  
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
  {src/adm/template/row-list.i "CcbCCob"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCCob"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-temporal V-table-Win 
PROCEDURE Borra-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH T-CcbDCob:
      DELETE T-CcbDCob.
  END.

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
  RUN Borra-temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Cambia-Pantalla IN lh_handle (INPUT 2).

  FIND faccorre WHERE faccorre.codcia = s-codcia AND 
                      faccorre.codDIV = s-coddiv and
                      faccorre.coddoc = s-coddoc NO-LOCK.
  Do with frame {&FRAME-NAME}:
     DISPLAY STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999")
          @ CcbCCob.nrodoc WITH FRAME {&FRAME-NAME}.
     /* Tipo de Cambio */
  
      DISPLAY s-tpocmb @ CcbCCob.tpocmb TODAY @ CcbCCob.fchdoc WITH FRAME {&FRAME-NAME}.
  
     CcbCCob.tpocmb:sensitive = no.
  end.
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
    CcbCCob.Coddoc    = S-CODDOC
    CcbCCob.Codcia    = S-CODCIA
    CcbCCob.Coddiv    = S-CODDIV
    CcbCCob.Flgest    = "C".

  /* Detalle */
  FOR EACH t-CcbDCob:
    CREATE CcbDCob.
    ASSIGN
        CcbDCob.CodCia = s-codcia
        CcbDCob.CodDoc = CcbCCob.coddoc
        CcbDCob.NroDoc = CcbCCob.nrodoc
        CcbDCob.CodCli = T-CcbdCob.codcli
        CcbDCob.Nomcli = T-CcbdCob.Nomcli
        CcbDCob.Codcob = CcbCCob.codcob
        CcbDCob.FchDoc = CcbCCob.fchdoc
        CcbDCob.ImpNac[1] = t-CcbDCob.ImpNac[1] 
        CcbDCob.ImpNac[2] = t-CcbDCob.ImpNac[2] 
        CcbDCob.ImpNac[3] = t-CcbDCob.ImpNac[3] 
        CcbDCob.ImpNac[4] = t-CcbDCob.ImpNac[4] 
        CcbDCob.ImpNac[5] = t-CcbDCob.ImpNac[5] 
        CcbDCob.ImpNac[6] = t-CcbDCob.ImpNac[6] 
        CcbDCob.ImpUsa[1] = t-CcbDCob.ImpUsa[1] 
        CcbDCob.ImpUsa[2] = t-CcbDCob.ImpUsa[2] 
        CcbDCob.ImpUsa[3] = t-CcbDCob.ImpUsa[3] 
        CcbDCob.ImpUsa[4] = t-CcbDCob.ImpUsa[4] 
        CcbDCob.ImpUsa[5] = t-CcbDCob.ImpUsa[5] 
        CcbDCob.ImpUsa[6] = t-CcbDCob.ImpUsa[6] 
        CcbDCob.TpoCmb = CcbCCob.tpocmb.
      ASSIGN
        CcbCCob.ImpNac[1] = CcbCCob.ImpNac[1] + t-CcbDCob.ImpNac[1] 
        CcbCCob.ImpNac[2] = CcbCCob.ImpNac[2] + t-CcbDCob.ImpNac[2] 
        CcbCCob.ImpNac[3] = CcbCCob.ImpNac[3] + t-CcbDCob.ImpNac[3] 
        CcbCCob.ImpNac[4] = CcbCCob.ImpNac[4] + t-CcbDCob.ImpNac[4] 
        CcbCCob.ImpNac[5] = CcbCCob.ImpNac[5] + t-CcbDCob.ImpNac[5] 
        CcbCCob.ImpNac[6] = CcbCCob.ImpNac[6] + t-CcbDCob.ImpNac[6] 
        CcbCCob.ImpUsa[1] = CcbCCob.ImpUsa[1] + t-CcbDCob.ImpUsa[1] 
        CcbCCob.ImpUsa[2] = CcbCCob.ImpUsa[2] + t-CcbDCob.ImpUsa[2] 
        CcbCCob.ImpUsa[3] = CcbCCob.ImpUsa[3] + t-CcbDCob.ImpUsa[3] 
        CcbCCob.ImpUsa[4] = CcbCCob.ImpUsa[4] + t-CcbDCob.ImpUsa[4] 
        CcbCCob.ImpUsa[5] = CcbCCob.ImpUsa[5] + t-CcbDCob.ImpUsa[5] 
        CcbCCob.ImpUsa[6] = CcbCCob.ImpUsa[6] + t-CcbDCob.ImpUsa[6] .
        
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
  RUN Cambia-Pantalla IN lh_handle (INPUT 1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FacCorre WHERE FacCorre.CodCia = s-codcia AND
                      FacCorre.CodDIV = s-coddiv and
                      FacCorre.CodDoc = s-coddoc EXCLUSIVE-LOCK.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    CcbCCob.CodCia = s-codcia
    CcbCCob.CodDoc = s-coddoc
    CcbCCob.NroDoc = STRING(faccorre.nroser, "999") + 
                      STRING(faccorre.correlativo, "999999")
    CcbCCob.CodDiv = S-CODDIV
    CcbCCob.Tipo   = s-tipo
    /*CcbCCob.TpoCmb = s-TpoCmb*/
    CcbCCob.usuario= s-user-id
    CcbCCob.CodCaja= S-CODTER
    FacCorre.Correlativo = FacCorre.Correlativo + 1.
  RELEASE faccorre.

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
  /* actualizamos la cuenta corriente */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
     FOR EACH CcbDCob OF CcbCCob:
         DELETE CcbDCob.
     END.
     FIND b-CcbCCob WHERE ROWID(b-CcbCCob) = ROWID(CcbCCob) EXCLUSIVE-LOCK.
     ASSIGN  b-CcbCCob.flgest = "A".
     RELEASE b-CcbCCob.
  END.
  
  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Repintar-Detalle IN lh_handle.

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
  IF AVAILABLE CcbCCob 
  THEN DO WITH FRAME {&FRAME-NAME}:
    FIND gn-cob WHERE gn-cob.codcia = S-CODCIA AND
        gn-cob.codcob = CcbCCob.codcob NO-LOCK NO-ERROR.
    IF AVAILABLE gn-cob THEN 
       DISPLAY gn-cob.nomcob @ F-Nomcob.
    CASE CcbCCob.flgest:
    WHEN "A" THEN X-Status:SCREEN-VALUE = "ANULADO".
    OTHERWISE X-Status:SCREEN-VALUE = "EMITIDO".
    END CASE.
  END.
  
END PROCEDURE.

/*  THEN DISPLAY gn-clie.nomcli @ FILL-IN_NomCli gn-clie.ruc @ FILL-IN_Ruc.*/

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
  
 RUN CCB\r-liqcob (ROWID(CcbCCob)).

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
  RUN Cambia-Pantalla IN lh_handle (INPUT 1).
  RUN dispatch IN THIS-PROCEDURE ('imprime':U).

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
  {src/adm/template/snd-list.i "CcbCCob"}

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
    FIND FIRST t-CcbDCob NO-ERROR.
    IF NOT AVAILABLE t-CcbDCob
    THEN DO:
        MESSAGE "No ha ingresado informacion" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF CcbCCob.CodCob:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Codigo de cobrador no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO CcbCCob.CodCob.
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

RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


