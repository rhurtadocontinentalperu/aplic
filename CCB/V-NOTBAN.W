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

DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR s-CodDiv  AS CHAR.
DEFINE SHARED VAR s-CodDoc  AS CHAR.
DEFINE SHARED VAR s-CodCia  AS INTEGER.
DEFINE SHARED VAR s-User-Id AS CHAR.

DEFINE SHARED TEMP-TABLE T-CcbDCaja LIKE CcbDCaja.
DEFINE SHARED VAR s-MonCta AS CHAR.
DEFINE SHARED VAR s-CodCta AS CHAR.
DEFINE SHARED VAR s-NroSer LIKE FacCorre.NroSer.

DEFINE BUFFER T-CMvto FOR CCbCMvto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCMvto
&Scoped-define FIRST-EXTERNAL-TABLE CcbCMvto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCMvto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCMvto.NroDoc CcbCMvto.CodDiv ~
CcbCMvto.NroRef CcbCMvto.FchCbd CcbCMvto.CodCta CcbCMvto.CodMon ~
CcbCMvto.TpoCmb CcbCMvto.Libre_dec[1] CcbCMvto.Libre_chr[1] ~
CcbCMvto.Libre_dec[2] CcbCMvto.Libre_chr[2] CcbCMvto.Glosa CcbCMvto.Usuario 
&Scoped-define ENABLED-TABLES CcbCMvto
&Scoped-define FIRST-ENABLED-TABLE CcbCMvto
&Scoped-Define ENABLED-OBJECTS RECT-3 
&Scoped-Define DISPLAYED-FIELDS CcbCMvto.NroDoc CcbCMvto.CodDiv ~
CcbCMvto.FchDoc CcbCMvto.NroRef CcbCMvto.FchCbd CcbCMvto.CodCta ~
CcbCMvto.CodMon CcbCMvto.TpoCmb CcbCMvto.Libre_dec[1] CcbCMvto.Libre_chr[1] ~
CcbCMvto.Libre_dec[2] CcbCMvto.Libre_chr[2] CcbCMvto.Glosa CcbCMvto.Usuario 
&Scoped-define DISPLAYED-TABLES CcbCMvto
&Scoped-define FIRST-DISPLAYED-TABLE CcbCMvto


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
DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.29 BY 6.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCMvto.NroDoc AT ROW 1.38 COL 13 COLON-ALIGNED
          LABEL "Número" FORMAT "999999999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     CcbCMvto.CodDiv AT ROW 1.38 COL 30 COLON-ALIGNED FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     CcbCMvto.FchDoc AT ROW 1.38 COL 44 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.57 BY .69
     CcbCMvto.NroRef AT ROW 2.15 COL 13 COLON-ALIGNED FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .69
     CcbCMvto.FchCbd AT ROW 2.15 COL 44 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .69
     CcbCMvto.CodCta AT ROW 2.92 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbCMvto.CodMon AT ROW 3.69 COL 15 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 17.43 BY .69
     CcbCMvto.TpoCmb AT ROW 3.5 COL 44 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbCMvto.Libre_dec[1] AT ROW 4.46 COL 13 COLON-ALIGNED
          LABEL "Ingresos" FORMAT "->,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCMvto.Libre_chr[1] AT ROW 4.46 COL 38 COLON-ALIGNED
          LABEL "Cuenta Ingresos"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     CcbCMvto.Libre_dec[2] AT ROW 5.42 COL 13 COLON-ALIGNED
          LABEL "Egresos" FORMAT "->,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCMvto.Libre_chr[2] AT ROW 5.42 COL 38 COLON-ALIGNED
          LABEL "Cuenta Egresos"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     CcbCMvto.Glosa AT ROW 6.38 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .69
     CcbCMvto.Usuario AT ROW 5.42 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .69
     "Moneda:" VIEW-AS TEXT
          SIZE 6.14 BY .69 AT ROW 3.69 COL 8.14
     RECT-3 AT ROW 1.04 COL 1
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
         HEIGHT             = 6.35
         WIDTH              = 73.29.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCMvto.CodDiv IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCMvto.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.Libre_chr[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.Libre_chr[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.Libre_dec[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCMvto.Libre_dec[2] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCMvto.NroDoc IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCMvto.NroRef IN FRAME F-Main
   EXP-FORMAT                                                           */
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

&Scoped-define SELF-NAME CcbCMvto.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodCta V-table-Win
ON LEAVE OF CcbCMvto.CodCta IN FRAME F-Main /* Cuenta Contable */
DO:
  FIND FIRST cb-Ctas WHERE cb-ctas.CodCta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE cb-Ctas THEN DO :
     s-MonCta = STRING(cb-ctas.CodMon).
     integral.CcbCMvto.CodMon:SCREEN-VALUE = s-MonCta.     
     s-CodCta = integral.CcbCMvto.CodCta:SCREEN-VALUE.
   END.     
   ELSE DO :
     s-MonCta = "".
     MESSAGE "Codigo de Cuenta no Registrada " VIEW-AS ALERT-BOX.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancela_Docum V-table-Win 
PROCEDURE Cancela_Docum :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER iCodCia AS INTEGER.
DEFINE INPUT PARAMETER cCodDoc AS CHAR.
DEFINE INPUT PARAMETER cNroDoc AS CHAR.
DEFINE INPUT PARAMETER iCodMon AS INTEGER.
DEFINE INPUT PARAMETER fTpoCmb AS DECIMAL.
DEFINE INPUT PARAMETER fImpTot AS DECIMAL.
DEFINE INPUT PARAMETER LSumRes AS LOGICAL.

DEFINE VAR XfImport AS DECIMAL INITIAL 0.

FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = iCodCia AND CcbCDocu.CodDoc = cCodDoc AND 
                          CcbCDocu.NroDoc = cNroDoc NO-ERROR.
IF AVAILABLE CcbCDocu THEN DO :
   XfImport = fImpTot.
   IF CcbCDocu.CodMon <> iCodMon THEN DO:
      IF CcbCDocu.CodMon = 1 THEN 
         ASSIGN XfImport = ROUND( fImpTot * fTpoCmb , 2 ).
      ELSE ASSIGN XfImport = ROUND( fImpTot / fTpoCmb , 2 ).
   END.
   
   IF LSumRes THEN ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct + XfImport.
   ELSE ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct - XfImport.
   
   IF CcbCDocu.SdoAct <= 0 THEN ASSIGN CcbCDocu.FlgEst = "C".
   ELSE ASSIGN CcbCDocu.FlgEst = "P".

   RELEASE CcbCDocu.
END.                          
ELSE MESSAGE "NO SE ENCONTRO EL NUMERO DEL DOCUMENTO A CANCELAR" VIEW-AS ALERT-BOX.

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
  
  /* Limpiamos la base temporal                                */
  
  FIND FIRST T-CcbDCaja NO-ERROR.
  IF AVAILABLE T-CcbDCaja THEN DO :
     FOR EACH T-CcbDCaja :
         DELETE T-CcbDCaja.
     END.   
  END.   
  
        
  FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia AND
                            FacCorre.CodDiv = s-CodDiv AND
                            FacCorre.CodDoc = s-CodDoc AND 
                            FacCorre.NroSer = s-NroSer NO-LOCK NO-ERROR.
                            
  IF AVAILABLE FacCorre THEN DO :                          
     CcbCMvto.NroDoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(s-NroSer, '999') +
                                                        STRING(FacCorre.Correlativo,"999999"). 
  END.   
  ELSE DO :
     MESSAGE "No existe CORRELATIVO para " + s-CodDoc VIEW-AS ALERT-BOX.
     RUN dispatch IN THIS-PROCEDURE ('cancel-record':U).
     RETURN.
  END.
  
  integral.CcbCMvto.Usuario:SCREEN-VALUE = s-User-Id.
  integral.CcbCMvto.FchDoc:SCREEN-VALUE = STRING(TODAY).
  integral.CcbCMvto.FchCbd:SCREEN-VALUE = STRING(TODAY).
  integral.CcbCMvto.CodDiv:SCREEN-VALUE = s-CodDiv.
  integral.CcbCMvto.NroDoc:SENSITIVE = NO.
  integral.CcbCMvto.Usuario:SENSITIVE = NO.
  INTEGRAL.CcbCMvto.CodDiv:SENSITIVE = NO.
  CcbCMvto.Libre_chr[1]:SCREEN-VALUE = "77111100".
  CcbCMvto.Libre_chr[2]:SCREEN-VALUE = "96672111".
  
  RUN Ejecuta-Handle IN lh_Handle('CmbPag2').
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR s-NroDoc AS CHAR.
  DEFINE VAR XfImport AS DECIMAL.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /* Actualizamos Correlativos */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.CodDoc = s-CodDoc AND
          FacCorre.NroSer = s-NroSer
          NO-ERROR.
      IF AVAILABLE FacCorre THEN DO : 
          s-NroDoc = STRING(FacCorre.NroSer, '999') +
                    STRING(FacCorre.Correlativo,"999999"). 
          ASSIGN 
              FacCorre.Correlativo = FacCorre.Correlativo + 1.
          ASSIGN 
              CcbCMvto.NroDoc = s-NroDoc
              CcbCMvto.CodDoc = s-CodDoc
              CcbCMvto.CodCia = s-CodCia
              CcbCMvto.FchDoc = TODAY.
      END.   
      RELEASE FacCorre.
  END.
  
  FIND FIRST T-CcbDCaja NO-ERROR.
  Xfimport = 0.
  FOR EACH T-CcbDCaja WHERE T-CcbDCaja.CodRef = "LET" :
      INSERT INTO integral.CcbDCaja ( CodCia, CodDoc, NroDoc, CodRef, NroRef, ImpTot,
                                     FchDoc, CodCli, CodMon, TpoCmb )
             VALUES ( s-CodCia, s-CodDoc, s-NroDoc, "LET" , T-CcbDCaja.NroRef, T-CCbDCaja.ImpTot,
                      T-CcbDCaja.FchDoc, T-CcbDCaja.CodCli, T-CcbDCaja.CodMon, CcbCMvto.TpoCmb ).
      XfImport = XfImport + T-CCbDCaja.ImpTot.
      RUN Cancela_Docum ( s-CodCia, T-CcbDCaja.CodRef, T-CcbDCaja.NroRef, 
                          T-CcbDCaja.CodMon, T-CcbDCaja.TpoCmb, T-CCbDCaja.ImpTot, FALSE ).
  END.
  
  ASSIGN
    CcbCMvto.ImpTot = XfImport + CcbCMvto.Libre_dec[1] - CcbCMvto.Libre_dec[2].
    CcbCMvto.ImpDoc = XfImport + CcbCMvto.Libre_dec[1] - CcbCMvto.Libre_dec[2].
         
  RUN Ejecuta-Handle IN lh_Handle('CmbPag1').
  
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
  
  RUN Ejecuta-Handle IN lh_Handle('CmbPag1').
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior.   */
  /* Dispatch standard ADM method.                               */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */
  
  
  /* CHEQUEAMOS LAS LETRAS SI ES QUE SE PUEDE ANULAR             */
  RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  
  FIND FIRST CcbDCaja WHERE CcbDCaja.CodCia = CcbCMvto.CodCia AND 
                            CcbDCaja.CodDoc = CcbCMvto.CodDoc AND 
                            CcbDCaja.NroDoc = CcbCMvto.NroDoc NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbDCaja THEN MESSAGE "Error en Detalle de Notas Bancarias ".

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      FOR EACH CcbDCaja WHERE CcbDCaja.CodCia = CcbCMvto.CodCia AND 
                              CcbDCaja.CodDoc = CcbCMvto.CodDoc AND 
                              CcbDCaja.NroDoc = CcbCMvto.NroDoc :
          RUN Cancela_Docum ( CcbDCaja.CodCia, CcbDCaja.CodRef, CcbDCaja.NroRef, 
                              CcbDCaja.CodMon, CcbDCaja.TpoCmb, CCbDCaja.ImpTot, TRUE ).
          DELETE CcbDCaja.                    
      END.
      FIND FIRST T-CMvto WHERE T-CMvto.CodCia = CCbCMvto.CodCia AND 
                               T-CMvto.CodDoc = CCbCMvto.CodDoc AND 
                               T-CMvto.NroDoc = CCbCMvto.NroDoc NO-ERROR.
      ASSIGN T-CMvto.FlgEst = "A"
             T-CMvto.Glosa  = "  * * * A N U L A D O * * *  POR " + s-User-Id + " " + STRING(today).

      RELEASE T-CMvto.
  END.
  
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  
  RUN Ejecuta-Handle IN lh_Handle('CmbPag1').
  RUN Ejecuta-Handle IN lh_Handle('Refresca').
   
  /* Code placed here will execute AFTER standard behavior.    */

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
  IF Ccbcmvto.flgest <> 'A' THEN RUN ccb/r-notban (ROWID(ccbcmvto)).  

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

    CASE HANDLE-CAMPO:name:
        WHEN "CodCta" THEN
            ASSIGN
                input-var-1 = "104,162".             
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
     RETURN.
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
    IF INPUT CcbCMvto.FchCbd > INPUT CcbCMvto.FchDoc THEN DO:
        MESSAGE 'La fecha contable errada'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */
   FIND FIRST T-CcbDCaja NO-ERROR.
   IF NOT AVAILABLE T-CcbDCaja THEN DO:
      MESSAGE "No existe detalle debe ingresarlo"
         VIEW-AS ALERT-BOX ERROR.         
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
IF integral.CcbCMvto.FlgEst = "A" THEN DO:
   MESSAGE "DOCUMENTO HA SIDO ANULADO ANTERIORMENTE "
   VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".   
END.
IF s-user-id <> 'ADMIN' THEN DO:
    /* consistencia de la fecha del cierre del sistema */
    DEF VAR dFchCie AS DATE.
    RUN gn/fecha-de-cierre (OUTPUT dFchCie).
    IF ccbcmvto.fchdoc <= dFchCie THEN DO:
        MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
    /* fin de consistencia */
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

