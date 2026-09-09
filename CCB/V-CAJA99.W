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
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddiv  AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-ptovta  AS INTE.
DEF SHARED VAR s-tipo    AS CHAR.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-codcli  LIKE gn-clie.codcli.
DEF SHARED VAR s-tpocmb  AS DEC.

DEF VAR s-ok AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR X-ImpNac AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR X-ImpUsa AS DECIMAL INITIAL 0 NO-UNDO.

DEF SHARED TEMP-TABLE T-CcbDCaja LIKE CcbDCaja.
DEF SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.
DEF BUFFER b-ccbccaja FOR ccbccaja.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCCaja
&Scoped-define FIRST-EXTERNAL-TABLE CcbCCaja


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCCaja.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCCaja.TpoCmb CcbCCaja.CodCli ~
CcbCCaja.NomCli CcbCCaja.FchDoc CcbCCaja.Glosa 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}TpoCmb ~{&FP2}TpoCmb ~{&FP3}~
 ~{&FP1}CodCli ~{&FP2}CodCli ~{&FP3}~
 ~{&FP1}NomCli ~{&FP2}NomCli ~{&FP3}~
 ~{&FP1}FchDoc ~{&FP2}FchDoc ~{&FP3}~
 ~{&FP1}Glosa ~{&FP2}Glosa ~{&FP3}
&Scoped-define ENABLED-TABLES CcbCCaja
&Scoped-define FIRST-ENABLED-TABLE CcbCCaja
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS CcbCCaja.NroDoc CcbCCaja.TpoCmb ~
CcbCCaja.CodCli CcbCCaja.NomCli CcbCCaja.FchDoc CcbCCaja.Glosa ~
CcbCCaja.usuario 
&Scoped-Define DISPLAYED-OBJECTS X-Status FILL-IN_Ruc 

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
DEFINE VARIABLE FILL-IN_Ruc AS CHARACTER FORMAT "x(10)" 
     LABEL "Ruc" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69.

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
     CcbCCaja.NroDoc AT ROW 1.19 COL 7 COLON-ALIGNED FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .69
          FONT 6
     X-Status AT ROW 1.19 COL 54.14 COLON-ALIGNED
     CcbCCaja.TpoCmb AT ROW 1.96 COL 54.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbCCaja.CodCli AT ROW 1.96 COL 7 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .69
     FILL-IN_Ruc AT ROW 1.96 COL 26.14 COLON-ALIGNED
     CcbCCaja.NomCli AT ROW 2.73 COL 7 COLON-ALIGNED
          LABEL "Nombre" FORMAT "X(50)"
          VIEW-AS FILL-IN 
          SIZE 40.86 BY .69
     CcbCCaja.FchDoc AT ROW 2.73 COL 54.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCCaja.Glosa AT ROW 3.5 COL 7 COLON-ALIGNED
          LABEL "Concepto"
          VIEW-AS FILL-IN 
          SIZE 41 BY .69
     CcbCCaja.usuario AT ROW 3.5 COL 54.14 COLON-ALIGNED
          LABEL "User"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCCaja
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
         HEIGHT             = 3.5
         WIDTH              = 67.57.
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

/* SETTINGS FOR FILL-IN FILL-IN_Ruc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.NomCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME CcbCCaja.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.CodCli V-table-Win
ON LEAVE OF CcbCCaja.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-clie WHERE gn-clie.codcia = 0 AND
    gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie
  THEN DO:
    MESSAGE "Cliente no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  IF gn-clie.codcli <> "11111111" THEN DO:
     DISPLAY gn-clie.nomcli @ CcbcCaja.Nomcli
             gn-clie.ruc @ FILL-IN_Ruc 
             WITH FRAME {&FRAME-NAME}.
  END.           
  s-codcli = SELF:SCREEN-VALUE.
END.



/*  DISPLAY gn-clie.nomcli @ FILL-IN_NomCli gn-clie.ruc @ FILL-IN_Ruc 
        WITH FRAME {&FRAME-NAME}.
  s-codcli = SELF:SCREEN-VALUE.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.TpoCmb V-table-Win
ON LEAVE OF CcbCCaja.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
  ASSIGN
         CcbCcaja.TpoCmb = int(CcbCcaja.TpoCmb:SCREEN-VALUE).

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
  {src/adm/template/row-list.i "CcbCCaja"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCCaja"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingreso-a-caja V-table-Win 
PROCEDURE Ingreso-a-caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST t-ccbccaja.
  ASSIGN
    CcbCCaja.CodBco[2] = t-CcbCCaja.CodBco[2] 
    CcbCCaja.CodBco[3] = t-CcbCCaja.CodBco[3] 
    CcbCCaja.CodBco[4] = t-CcbCCaja.CodBco[4]
    CcbCCaja.Codcta[5] = t-CcbCCaja.CodBco[5] 
    CcbCCaja.FchVto[2] = t-CcbCCaja.FchVto[2] 
    CcbCCaja.FchVto[3] = t-CcbCCaja.FchVto[3] 
    CcbCCaja.ImpNac[1] = t-CcbCCaja.ImpNac[1] 
    CcbCCaja.ImpNac[2] = t-CcbCCaja.ImpNac[2] 
    CcbCCaja.ImpNac[3] = t-CcbCCaja.ImpNac[3] 
    CcbCCaja.ImpNac[4] = t-CcbCCaja.ImpNac[4] 
    CcbCCaja.ImpNac[5] = t-CcbCCaja.ImpNac[5] 
    CcbCCaja.ImpUsa[1] = t-CcbCCaja.ImpUsa[1] 
    CcbCCaja.ImpUsa[2] = t-CcbCCaja.ImpUsa[2] 
    CcbCCaja.ImpUsa[3] = t-CcbCCaja.ImpUsa[3] 
    CcbCCaja.ImpUsa[4] = t-CcbCCaja.ImpUsa[4] 
    CcbCCaja.ImpUsa[5] = t-CcbCCaja.ImpUsa[5] 
    CcbCCaja.Voucher[2]= t-CcbCCaja.Voucher[2] 
    CcbCCaja.Voucher[3]= t-CcbCCaja.Voucher[3] 
    CcbCCaja.Voucher[4]= t-CcbCCaja.Voucher[4] 
    CcbCCaja.Voucher[5]= t-CcbCCaja.Voucher[5] 
    CcbCCaja.VueNac    = t-CcbCCaja.VueNac    
    CcbCCaja.VueUsa    = t-CcbCCaja.VueUsa
    CcbcCaja.Flgest    = "C".
    
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
  FOR EACH T-CcbDCaja:
      DELETE T-CcbDCaja.
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Cambia-Pantalla IN lh_handle (INPUT 2).
  FIND faccorre WHERE faccorre.codcia = s-codcia AND faccorre.coddoc = s-coddoc AND
       NroSer = s-ptovta NO-LOCK.
  DISPLAY STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999")
          @ ccbccaja.nrodoc WITH FRAME {&FRAME-NAME}.
  /* Tipo de Cambio */
  DISPLAY s-tpocmb @ ccbccaja.tpocmb TODAY @ ccbccaja.fchdoc WITH FRAME {&FRAME-NAME}.

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
  FIND FacCorre WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.CodDoc = s-coddoc AND FacCorre.NroSer = s-ptovta
    NO-ERROR.
  ASSIGN
    CcbCCaja.CodCia = s-codcia
    CcbCCaja.CodDoc = s-coddoc
    CcbCCaja.NroDoc = STRING(faccorre.nroser, "999") + 
                      STRING(faccorre.correlativo, "999999")
    CcbcCaja.CodDiv = S-CODDIV
    CcbCCaja.Tipo   = s-tipo
    CcbCCaja.TpoCmb = s-TpoCmb
    CcbCCaja.usuario= s-user-id
    CcbCCaja.CodCaja= S-CODTER

    FacCorre.Correlativo = FacCorre.Correlativo + 1.
  RELEASE faccorre.
    
  /* Detalle */
  FOR EACH t-ccbdcaja:
    CREATE ccbdcaja.
    ASSIGN
        CcbDCaja.CodCia = s-codcia
        CcbDCaja.CodDoc = ccbccaja.coddoc
        CcbDCaja.NroDoc = ccbccaja.nrodoc
        CcbDCaja.CodCli = ccbccaja.codcli
        CcbDCaja.CodMon = t-ccbdcaja.codmon
        CcbDCaja.CodRef = t-ccbdcaja.codref
        CcbDCaja.FchDoc = ccbccaja.fchdoc
        CcbDCaja.ImpTot = t-ccbdcaja.imptot
        CcbDCaja.NroRef = t-ccbdcaja.nroref
        CcbDCaja.TpoCmb = ccbccaja.tpocmb.
  END.
  /* Cancela cuenta por cobrar */
  FOR EACH ccbdcaja OF ccbccaja:
    FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
        ccbcdocu.coddoc = ccbdcaja.codref AND
        ccbcdocu.nrodoc = ccbdcaja.nroref EXCLUSIVE-LOCK.
    ASSIGN
        ccbcdocu.sdoact = ccbcdocu.sdoact - ccbdcaja.imptot.
    IF ccbcdocu.sdoact <= 0
    THEN ASSIGN
            ccbcdocu.fchcan = TODAY
            ccbcdocu.flgest = "C".
  END.
  RUN Ingreso-a-Caja.
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF ccbccaja.flgcie NE "P"
  THEN DO:
    MESSAGE "Ya se hizo el cierre de caja" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  /* actualizamos la cuenta corriente */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
    FOR EACH ccbdcaja OF ccbccaja:
      FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
          ccbcdocu.coddoc = ccbdcaja.codref AND
          ccbcdocu.nrodoc = ccbdcaja.nroref EXCLUSIVE-LOCK.
      ASSIGN
          ccbcdocu.sdoact = ccbcdocu.sdoact + ccbdcaja.imptot.
      IF ccbcdocu.sdoact > 0 
      THEN ASSIGN
              ccbcdocu.flgest = "P"
              ccbcdocu.fchcan = ?.
      DELETE ccbdcaja.        
    END.
    /*
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
    */
    FIND b-ccbccaja WHERE ROWID(b-ccbccaja) = ROWID(ccbccaja) EXCLUSIVE-LOCK.
    ASSIGN
        b-ccbccaja.flgest = "A".
    RELEASE b-ccbccaja.
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
  IF AVAILABLE ccbccaja 
  THEN DO WITH FRAME {&FRAME-NAME}:
    FIND gn-clie WHERE gn-clie.codcia = 0 AND
        gn-clie.codcli = ccbccaja.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie AND gn-clie.codcli <> "11111111" THEN 
       DISPLAY gn-clie.nomcli @ CcbcCaja.Nomcli gn-clie.ruc @ FILL-IN_Ruc.
    CASE ccbccaja.flgest:
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
  
 RUN CCB\r-recibo (ROWID(CcbcCaja)).

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
  ASSIGN
    X-ImpNac = 0
    X-ImpUsa = 0.
  FOR EACH T-CcbDCaja:
    IF t-ccbdcaja.codmon = 1
    THEN ASSIGN
            X-ImpNac = X-ImpNac + t-ccbdcaja.imptot
            X-ImpUsa = X-ImpUsa + t-ccbdcaja.imptot / s-TpoCmb.
    ELSE ASSIGN
            X-ImpUsa = X-ImpUsa + t-ccbdcaja.imptot
            X-ImpNac = X-ImpNac + t-ccbdcaja.imptot * s-TpoCmb.
  END.  
  RUN ccb/d-canc02 (X-ImpNac, X-ImpUsa, s-TpoCmb, s-codcli, OUTPUT s-ok).
  IF s-ok = NO THEN RETURN "ADM-ERROR".

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
  {src/adm/template/snd-list.i "CcbCCaja"}

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
    FIND FIRST t-ccbdcaja NO-ERROR.
    IF NOT AVAILABLE t-ccbdcaja
    THEN DO:
        MESSAGE "No ha ingresado informacion" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF CcbCCaja.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO CcbCCaja.CodCli.
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


