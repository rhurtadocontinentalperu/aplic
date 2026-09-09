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

DEFINE SHARED TEMP-TABLE DCMP LIKE ImDOCmp.
DEFINE BUFFER B-CCMP FOR ImCOCmp.
DEFINE VARIABLE Im-CREA   AS LOGICAL NO-UNDO.
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-PROVEE  AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-PORCFR  AS DEC.
DEFINE SHARED VARIABLE S-TPOCMB  AS DECIMAL.
DEFINE SHARED VARIABLE S-IMPCFR  AS DECIMAL.

/*
 * DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
 * DEFINE SHARED VARIABLE S-TPODOC AS CHAR.
 * 
 * */
/*DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.
 * 
 * DEFINE VARIABLE X-TIPO AS CHAR INIT "CC".
 * DEFINE VARIABLE s-Control-Compras AS LOG NO-UNDO.   /* Control de 7 dias */
 * 
 * 
 * */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ImCDua ImCOCmp
&Scoped-define FIRST-EXTERNAL-TABLE ImCDua


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ImCDua, ImCOCmp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ImCDua.NroDua ImCDua.CodPro ImCDua.Codmon ~
ImCDua.ImpFob ImCDua.ImpFlete ImCDua.Seguro ImCDua.AjValor ImCDua.ValAdua ~
ImCDua.FchDua ImCDua.TpoCmb 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}NroDua ~{&FP2}NroDua ~{&FP3}~
 ~{&FP1}CodPro ~{&FP2}CodPro ~{&FP3}~
 ~{&FP1}ImpFob ~{&FP2}ImpFob ~{&FP3}~
 ~{&FP1}ImpFlete ~{&FP2}ImpFlete ~{&FP3}~
 ~{&FP1}Seguro ~{&FP2}Seguro ~{&FP3}~
 ~{&FP1}AjValor ~{&FP2}AjValor ~{&FP3}~
 ~{&FP1}ValAdua ~{&FP2}ValAdua ~{&FP3}~
 ~{&FP1}FchDua ~{&FP2}FchDua ~{&FP3}~
 ~{&FP1}TpoCmb ~{&FP2}TpoCmb ~{&FP3}
&Scoped-define ENABLED-TABLES ImCDua
&Scoped-define FIRST-ENABLED-TABLE ImCDua
&Scoped-Define ENABLED-OBJECTS RECT-24 
&Scoped-Define DISPLAYED-FIELDS ImCDua.NroPed ImCDua.NroDua ImCDua.CodPro ~
ImCDua.Codmon ImCDua.ImpFob ImCDua.ImpFlete ImCOCmp.NomPro ImCDua.NroCon ~
ImCDua.Seguro ImCDua.AjValor ImCDua.ValAdua ImCDua.FchDoc ImCDua.Hora ~
ImCDua.Userid-dua ImCDua.FchDua ImCDua.FchVto ImCDua.TpoCmb 

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
DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 78 BY 7.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ImCDua.NroPed AT ROW 1.19 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .81
     ImCDua.NroDua AT ROW 1.96 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .81
     ImCDua.CodPro AT ROW 2.73 COL 10 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     ImCDua.Codmon AT ROW 3.88 COL 13 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 8.72 BY 1.31
     ImCDua.ImpFob AT ROW 5.42 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     ImCDua.ImpFlete AT ROW 6.19 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     ImCOCmp.NomPro AT ROW 2.73 COL 15 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36 BY .81
     ImCDua.NroCon AT ROW 1.19 COL 32 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .81
     ImCDua.Seguro AT ROW 5.42 COL 39 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     ImCDua.AjValor AT ROW 6.23 COL 39 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     ImCDua.ValAdua AT ROW 7.04 COL 39 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     ImCDua.FchDoc AT ROW 1.19 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCDua.Hora AT ROW 1.96 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCDua.Userid-dua AT ROW 2.73 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCDua.FchDua AT ROW 3.88 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCDua.FchVto AT ROW 4.65 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCDua.TpoCmb AT ROW 5.42 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     "Proveedor:" VIEW-AS TEXT
          SIZE 8.14 BY .5 AT ROW 2.92 COL 4
     "Moneda:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.88 COL 5
     RECT-24 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.ImCDua,INTEGRAL.ImCOCmp
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
         HEIGHT             = 7.19
         WIDTH              = 78.14.
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

/* SETTINGS FOR FILL-IN ImCDua.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCDua.FchVto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCDua.Hora IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCDua.NroCon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCDua.NroPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCDua.Userid-dua IN FRAME F-Main
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-DCMP V-table-Win 
PROCEDURE Actualiza-DCMP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH DCMP:
    DELETE DCMP.
END.
IF NOT Im-CREA THEN DO:
   FOR EACH ImDOCmp NO-LOCK WHERE ImDOCmp.CodCia = ImCOCmp.CodCia 
                    AND  ImDOCmp.NroImp = ImCOCmp.NroImp:
       CREATE DCMP.
       BUFFER-COPY ImDOCmp TO DCMP.
   END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "ImCDua"}
  {src/adm/template/row-list.i "ImCOCmp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ImCDua"}
  {src/adm/template/row-find.i "ImCOCmp"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FOR EACH ImDOCmp WHERE ImDOCmp.CodCia = ImCOCmp.CodCia 
                      AND ImDOCmp.NroImp = ImCOCmp.NroImp:
       DELETE ImDOCmp.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DCMP:
    DELETE DCMP.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN Borra-Temporal.
  FOR EACH ImCOCmp USE-INDEX Llave01 NO-LOCK :
    CREATE DCMP.
    BUFFER-COPY ImCOCmp TO DCMP.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Orden-Compra V-table-Win 
PROCEDURE Genera-Orden-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DCMP WHERE DCMP.CanPedi > 0:
    CREATE ImDOCmp.
    BUFFER-COPY DCMP TO ImDOcmp
        ASSIGN 
            ImDOCmp.CodCia = ImCOCmp.CodCia 
            ImDOCmp.Coddoc = ImCOCmp.Coddoc
            ImDOCmp.NroImp = ImCOCmp.NroImp.
    RELEASE ImDOCmp.
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
/*  DEFINE VARIABLE p-NroRef LIKE ImCOCmp.NroImp.
 *   IF p-NroRef = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /*FIND LG-CORR WHERE LG-CORR.CodCia = S-CODCIA /* 001*/
 *     AND LG-CORR.CodDiv = s-CodDiv /*"00000" */
 *     AND LG-CORR.CodDoc = "O/C" 
 *     AND LG-CORR.NroSer = s-nroser /*001*/
 *     NO-LOCK NO-ERROR.
 *     MESSAGE "LG-CIA" LG-CORR.CodCia VIEW-AS ALERT-BOX ERROR.
 *     MESSAGE "LG-DIV" LG-CORR.CodDiv VIEW-AS ALERT-BOX ERROR.
 *     MESSAGE "LG-DOC" LG-CORR.CodDoc VIEW-AS ALERT-BOX ERROR.
 *     MESSAGE "LG-SER" LG-CORR.NroSer VIEW-AS ALERT-BOX ERROR.
 *     MESSAGE "CIA" S-CODCIA VIEW-AS ALERT-BOX ERROR.
 *     MESSAGE "DIV" S-CODDIV VIEW-AS ALERT-BOX ERROR.
 *     MESSAGE "SER" S-NROSER VIEW-AS ALERT-BOX ERROR.
 *   IF NOT AVAILABLE LG-CORR THEN DO:
 *     MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
 *     RETURN 'ADM-ERROR'.
 *   END.
 *   
 *   /* Dispatch standard ADM method.                             */
 *   RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
 * 
 *   /* Code placed here will execute AFTER standard behavior.    */
 * 
 *   Im-CREA = YES.
 *   RUN Actualiza-DCMP.
 *   RUN Procesa-Handle IN lh_Handle ("Pagina2").
 *   RUN Procesa-Handle IN lh_Handle ('Browse-add').
 *   DO WITH FRAME {&FRAME-NAME}:
 *      /*FIND CCMP WHERE CCMP.codcia = s-codcia
 *  *         AND CCMP.Coddiv = s-coddiv
 *  *         AND CCMP.NroImp = p-nroref
 *  *         NO-LOCK.*/
 *      FIND Gn-ConCp WHERE Gn-ConCp.codig = B-CCMP.CndCmp NO-LOCK.
 *      RUN Carga-Temporal.
 *      DISPLAY 
 *         "CO" + 
 *             STRING(ImCOCmp.periodo, '9999') +
 *             STRING(Lg-Corr.nroser, '999') +
 *             ImCOCmp.NroPedPro  @ ImCOCmp.NroPed
 *         B-CCMP.periodo           @ ImCOCmp.periodo
 *         LG-CORR.NroImp         @ ImCocmp.NroImp
 *         B-CCMP.CodPro            @ ImCOCmp.CodPro
 *         B-CCMP.NomPro            @ ImCOCmp.NomPro
 *         B-CCMP.pais              @ ImCOCmp.pais
 *         B-CCMP.NroPedPro         @ ImCOCmp.NroPedPro
 *         B-CCMP.moneda            @ ImCOCmp.moneda
 *         B-CCMP.CndCmp            @ ImCOCmp.CndCmp
 *         Gn-ConCp.Nombr         @ F-DesCnd
 *         B-CCMP.CodBco            @ ImCOCmp.CodBco
 *         TODAY                  @ ImCOCmp.Fchdoc 
 *         STRING(TIME, "HH:MM")  @ ImCOCmp.Hora
 *         S-user-id              @ ImCOCmp.Userid-com
 *         TODAY + 14             @ ImCOCmp.FchProd
 *         B-CCMP.TpoCmb            @ ImCOCmp.TpoCmb 
 *         B-CCMP.NroCreDoc         @ ImCOCmp.NroCreDoc
 *         B-CCMP.ImpFob            @ ImCOCmp.ImpFob
 *         B-CCMP.ImpFle            @ ImCOCmp.ImpFle
 *         B-CCMP.ImpCfr            @ ImCOCmp.ImpCfr.
 *         
 *      /*FIND LAST gn-tcmb WHERE gn-tcmb.FECHA <= TODAY NO-LOCK NO-ERROR.
 *  *        IF AVAILABLE gn-tcmb THEN DO:
 *  *           DISPLAY gn-tcmb.compra @ ImCOCmp.TpoCmb.
 *  *           S-TPOCMB = gn-tcmb.compra.
 *  *        END.
 *      S-CODMON = 1.*/
 *      s-PorCfr = 0.
 *        FIND FIRST LG-tabla WHERE Lg-tabla.codcia = s-codcia
 *           AND Lg-tabla.tabla = '01'
 *           NO-LOCK NO-ERROR.
 *        IF AVAILABLE Lg-Tabla THEN DO:
 *           s-PorCfr = Lg-Tabla.Valor[1].
 *           ImCOCmp.FlgEst[1]:SCREEN-VALUE = Lg-tabla.codigo.
 *        END.
 *   END.
 *     S-PROVEE = "".*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE X-NROIMP AS INTEGER NO-UNDO.
  DEFINE VARIABLE f-ImpTot AS DEC NO-UNDO.
  DEFINE VARIABLE f-CanTot AS DEC NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF Im-CREA THEN DO:
     FIND LG-CORR WHERE LG-CORR.CodCia = S-CODCIA AND
                        LG-CORR.CodDiv = s-CodDiv AND
                        LG-CORR.CodDoc = "O/C" 
                        EXCLUSIVE-LOCK NO-ERROR.
     LG-CORR.NroImp = LG-CORR.NroImp + 1.
     DO WITH FRAME {&FRAME-NAME}:
        ASSIGN 
               ImCOCmp.CodCia     = S-CODCIA
               ImCOCmp.CodDiv     = s-CodDiv
               ImCOCmp.FlgSit     = "E"
               ImCOCmp.Userid-com = S-USER-ID
               ImCOCmp.NroPed     ="CO" + 
                                    STRING(ImCOCmp.periodo, "9999") +
                                    STRING(LG-CORR.nroser, "999") + 
                                    ImCOCmp.NroPedPro
               ImCOCmp.NroImp     = LG-CORR.NroImp. 
               RELEASE LG-CORR.
     END.
  END.
  ELSE DO:
     ImCOCmp.Userid-com = S-USER-ID.
  END.

  FIND gn-prov WHERE gn-prov.CodCia = 0 AND 
                     gn-prov.CodPro = ImCOCmp.CodPro 
                     NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN 
     ASSIGN ImCOCmp.NomPro = gn-prov.NomPro.
  ASSIGN B-CCMP.ImpTot = 0.
  FOR EACH DCMP NO-LOCK:
      B-CCMP.ImpTot = B-CCMP.ImpTot + DCMP.ImpTot.
  END.

  IF NOT Im-CREA THEN DO:
      RUN Borra-Detalle.
  END.
  RUN Genera-Orden-Compra.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).
  
  RELEASE LG-CORR.
  RELEASE B-CCMP.
  RELEASE ImCOCmp.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE X-NROIMP AS INTEGER NO-UNDO.
  DEFINE VARIABLE f-ImpTot AS DEC NO-UNDO.
  DEFINE VARIABLE f-CanTot AS DEC NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF Im-CREA THEN DO:
     FIND LG-CORR WHERE LG-CORR.CodCia = S-CODCIA 
        AND LG-CORR.CodDiv = s-CodDiv
        AND  LG-CORR.CodDoc = "O/C" 
        EXCLUSIVE-LOCK NO-ERROR.
     X-NROIMP = LG-CORR.NroImp.
     ASSIGN LG-CORR.NroImp = LG-CORR.NroImp + 1.
     RELEASE LG-CORR.
     ASSIGN ImCOCmp.CodCia     = S-CODCIA
            ImCOCmp.CodDiv     = s-CodDiv
            ImCOCmp.NroImp     = X-NROIMP
            ImCOCmp.FlgSit     = "E"
            ImCOCmp.Userid-com = S-USER-ID
            ImCOCmp.NroPed     ="CO" + STRING(ImCOCmp.periodo, '9999') +
            STRING(Lg-Corr.nroser, '999') + ImCOCmp.NroPedPro.
  END.
  
   FIND gn-prov WHERE gn-prov.CodCia = 0 
                AND  gn-prov.CodPro = ImCOCmp.CodPro 
               NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN 
     ASSIGN ImCOCmp.NomPro = gn-prov.NomPro.
  ASSIGN 
    ImCOCmp.ImpTot = 0
    ImCOCmp.CanTot = 0.

  FOR EACH DCMP NO-LOCK:
      ImCOCmp.ImpTot = ImCOCmp.ImpTot + DCMP.ImpTot.
      ImCOCmp.CanTot = ImCOCmp.CanTot + DCMP.CanTot.
  END.

  IF NOT Im-CREA THEN DO:
      RUN Borra-Detalle.
  END.
  RUN Genera-Orden-Compra.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).
  RELEASE LG-CORR.
  RELEASE B-CCMP.
  RELEASE ImCOCmp.
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
  
  RUN Procesa-Handle IN lh_Handle ("Pagina1").
  RUN Procesa-Handle IN lh_Handle ('Browse').

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE L-ATEPAR AS LOGICAL INIT NO NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */
  IF LOOKUP(ImCOCmp.FlgSit, "E") = 0 THEN DO:
     MESSAGE "La Orden de Compra no puede ser anulada" SKIP
              "se encuentra " ENTRY(LOOKUP(ImCOCmp.FlgSit,"A,C"),"Anulada,Cerrada")
              VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  FOR EACH ImDOCMP OF ImCOCMP:
      IF ImDOCmp.CanAten > 0 THEN DO:
         L-ATEPAR = YES.
         LEAVE.
      END.
  END.
  IF L-ATEPAR THEN DO:
     MESSAGE "La Orden de Compra no puede ser anulada" SKIP
              "se encuentra parcialmente atendida" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  IF AVAILABLE ImCOCmp AND (LOOKUP(ImCOCmp.FlgSit,"A") = 0) THEN DO
     ON ERROR UNDO, RETURN "ADM-ERROR":
     FIND B-CCMP USE-INDEX Llave01 EXCLUSIVE-LOCK NO-ERROR.
     /*FIND B-CCMP USE-INDEX Llave01 OF ImCOCmp  EXCLUSIVE-LOCK NO-ERROR.*/
     IF AVAILABLE B-CCMP THEN DO:
        ASSIGN B-CCMP.FlgSit = "A"
               B-CCMP.Userid-com = S-USER-ID.
        RUN Borra-Detalle.
     END.
     RELEASE B-CCMP.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('Browse').


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
  
  /*IF AVAILABLE ImCOCmp THEN DO WITH FRAME {&FRAME-NAME}:
 *      FIND gn-prov WHERE gn-prov.CodCia = 0 
 *                    AND  gn-prov.CodPro = ImCOCmp.CodPro 
 *                   NO-LOCK NO-ERROR.
 *               
 *      IF AVAILABLE gn-prov THEN 
 *         DISPLAY gn-prov.Ruc    @ F-RucPro.
 *      FIND gn-concp WHERE gn-concp.Codig = ImCOCmp.CndCmp NO-LOCK NO-ERROR.
 *      IF AVAILABLE gn-concp THEN 
 *         DISPLAY gn-concp.Nombr @ F-DesCnd.           
 *      S-PROVEE = ImCOCmp.CodPro.
 *      
 *      IF LOOKUP(ImCOCmp.FlgSit,"E,A") > 0 THEN
 *         F-SitDoc:SCREEN-VALUE = ENTRY(LOOKUP(ImCOCmp.FlgSit,"E,A,C"),"Emitido,Anulado,Cerrado").
 *         
 *   END.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR I AS INTEGER.
  DEF VAR MENS AS CHARACTER.
  DEF VAR x-Ok AS LOG NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
  IF x-Ok = NO THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   DEF VAR x-Copias AS CHAR.
  
  RUN lgc/d-impodc (OUTPUT x-Copias).
  IF x-Copias = 'ADM-ERROR' THEN RETURN.
  DO i = 1 TO NUM-ENTRIES(x-Copias):
    CASE ENTRY(i, x-Copias):
        WHEN 'ALM' THEN MENS = 'ALMACEN'.
        WHEN 'CBD' THEN MENS = 'CONTABILIDAD'.
        WHEN 'PRO' THEN MENS = 'PROVEEDOR'.
        WHEN 'ARC' THEN MENS = 'ARCHIVO'.
    END CASE.
    IF LG-COCmp.FlgSit <> "A" THEN RUN lgc\r-impcmp(ROWID(LG-COCmp), MENS).
  END.
  
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
  /*
 *   DO WITH FRAME {&FRAME-NAME}:
 *     FOR EACH Lg-Tabla NO-LOCK WHERE Lg-Tabla.codcia = s-codcia
 *             AND Lg-Tabla.Tabla = '01':
 *         ImCOCmp.FlgEst[1]:ADD-LAST(lg-tabla.Codigo).
 *     END.            
 *   END.*/

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
  
  RUN Genera-Orden-Compra.

  RUN Procesa-Handle IN lh_Handle ("Pagina1").
  RUN Procesa-Handle IN lh_Handle ('Browse').

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
    CASE HANDLE-CAMPO:name:
        WHEN "CndCmp" THEN ASSIGN input-var-1 = "" /*"20"*/.
        

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
  {src/adm/template/snd-list.i "ImCDua"}
  {src/adm/template/snd-list.i "ImCOCmp"}

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
     Im-CREA = NO.
     RUN Actualiza-DCMP.
     RUN Procesa-Handle IN lh_Handle ("Pagina2").
     RUN Procesa-Handle IN lh_Handle ('Browse').
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
/*DO WITH FRAME {&FRAME-NAME} :
 * 
 *    IF ImCocmp.CodPro:SCREEN-VALUE = "" THEN DO:
 *       MESSAGE "Codigo de proveedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
 *       APPLY "ENTRY" TO ImCocmp.CodPro.
 *       RETURN "ADM-ERROR".   
 *    END.
 * 
 *    IF ImCOCmp.CndCmp:SCREEN-VALUE = "" THEN DO:
 *       MESSAGE "Condicion de Compra no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
 *       APPLY "ENTRY" TO ImCOCmp.CndCmp.
 *       RETURN "ADM-ERROR".         
 *    END.  
 * 
 *    FIND gn-prov WHERE gn-prov.CodCia = 0 
 *                  AND  gn-prov.CodPro = ImCocmp.CodPro:SCREEN-VALUE 
 *                 NO-LOCK NO-ERROR.
 *    IF NOT AVAILABLE gn-prov THEN DO:
 *       MESSAGE "Proveedor no Registrado" VIEW-AS ALERT-BOX ERROR.
 *       APPLY "ENTRY" TO ImCocmp.CodPro.
 *       RETURN "ADM-ERROR".
 *    END.
 *    
 *    FIND Lg-Tabla WHERE Lg-Tabla.CodCia = s-CodCia
 *         AND Lg-Tabla.Tabla = '01'
 *         AND Lg-Tabla.Codigo = ImCOCmp.FlgEst[1]:SCREEN-VALUE
 *         NO-LOCK NO-ERROR.
 *    IF NOT AVAILABLE Lg-Tabla THEN DO:
 *       MESSAGE "INCOTERM no existe" VIEW-AS ALERT-BOX ERROR.
 *       APPLY "ENTRY" TO ImCOCmp.FlgEst[1].
 *       RETURN "ADM-ERROR".         
 *    END. 
 * 
 * END.
 * */

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
IF NOT AVAILABLE ImCOCmp THEN RETURN "ADM-ERROR".
IF LOOKUP(ImCOCmp.FlgSit, "E") = 0 THEN RETURN "ADM-ERROR".
S-TPOCMB = ImCOCmp.TpoCmb.
/*S-CODMON = LG-COCmp.Codmon.*/
S-PORCFR = 0.
FIND Lg-tabla WHERE Lg-tabla.codcia = s-codcia
    AND Lg-tabla.tabla = '01'
    AND Lg-tabla.codigo = ImCOCmp.FlgEst[1]
    NO-LOCK NO-ERROR.
IF AVAILABLE Lg-tabla THEN s-PorCfr = lg-tabla.Valor[1].
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


