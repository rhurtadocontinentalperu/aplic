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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-ptovta AS INTE.
DEF SHARED VAR s-tipo   AS CHAR.
DEF SHARED VAR s-codalm LIKE almacen.codalm.
DEF SHARED VAR s-codmov LIKE almtmovm.codmov.
DEF SHARED VAR s-codter LIKE ccbcterm.codter.

DEF VAR s-codped AS CHAR INITIAL "P/M".
DEF VAR s-ok     AS LOGICAL INITIAL NO NO-UNDO.

DEF SHARED TEMP-TABLE T-CcbDDocu LIKE CcbDDocu.
DEF SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.
DEF BUFFER b-ccbcdocu FOR ccbcdocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.NroPed CcbCDocu.FmaPgo 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}NroPed ~{&FP2}NroPed ~{&FP3}~
 ~{&FP1}FmaPgo ~{&FP2}FmaPgo ~{&FP3}
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.NroPed ~
CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.DirCli CcbCDocu.RucCli ~
CcbCDocu.CodVen CcbCDocu.FmaPgo CcbCDocu.FchDoc CcbCDocu.CodMon ~
CcbCDocu.TpoCmb 
&Scoped-Define DISPLAYED-OBJECTS X-Status F-CndVta 

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
DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30.14 BY .81 NO-UNDO.

DEFINE VARIABLE X-Status AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89.72 BY 5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.19 COL 9 COLON-ALIGNED FORMAT "XXX-XXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .81
          FONT 6
     CcbCDocu.NroPed AT ROW 1.96 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodCli AT ROW 2.73 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.NomCli AT ROW 3.5 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44 BY .81
     CcbCDocu.DirCli AT ROW 4.27 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     CcbCDocu.RucCli AT ROW 5.04 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     X-Status AT ROW 1.19 COL 34.72 COLON-ALIGNED
     CcbCDocu.CodVen AT ROW 1.96 COL 34.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.FmaPgo AT ROW 5.04 COL 35.43 COLON-ALIGNED
          LABEL "Cond.Vta."
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-CndVta AT ROW 5.04 COL 43.14 COLON-ALIGNED NO-LABEL
     CcbCDocu.FchDoc AT ROW 1.19 COL 72.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodMon AT ROW 1.96 COL 74.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .77
     CcbCDocu.TpoCmb AT ROW 2.73 COL 72.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     RECT-1 AT ROW 1 COL 1
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 2.08 COL 67.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCDocu
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
         HEIGHT             = 5.08
         WIDTH              = 100.86.
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
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET CcbCDocu.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.DirCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbCDocu.NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NroPed V-table-Win
ON LEAVE OF CcbCDocu.NroPed IN FRAME F-Main /* Pedido */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  /*
  ASSIGN SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), "999999999") NO-ERROR.
  */
  FIND FacCPedm WHERE faccpedm.codcia = s-codcia AND
        faccpedm.coddoc = s-codped AND nroped = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCPedm
  THEN DO:
    MESSAGE "Pedido de mostrador no registrado" VIEW-AS ALERT-BOX WARNING 
        TITLE "ATENCION!".
    RETURN NO-APPLY.
  END.
  /* Verificacion del pedido */
  IF faccpedm.flgest NE "P" 
  THEN DO:
    MESSAGE "Pedido de mostrador no esta pendiente de facturar" VIEW-AS 
        ALERT-BOX WARNING TITLE "ATENCION!".
    RETURN NO-APPLY.
  END.
  IF Faccpedm.Cmpbnte NE s-coddoc
  THEN DO:
    MESSAGE "El pedido de mostrador solo acepta" (IF Faccpedm.Cmpbnte = "FAC" THEN "factura" ELSE "boleta")
        VIEW-AS ALERT-BOX WARNING TITLE "ATENCION!".
    RETURN NO-APPLY.
  END.
  DEF VAR TimeOut AS INTEGER NO-UNDO.
  DEF VAR TimeNow AS INTEGER NO-UNDO.
  FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK.
  TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
            (FacCfgGn.Hora-Res * 3600) + 
            (FacCfgGn.Minu-Res * 60).
  IF TimeOut > 0
  THEN DO:
    TimeNow = (TODAY - FacCPedm.FchPed) * 24 * 3600.
    TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedm.Hora, 1, 2)) * 3600) +
                (INTEGER(SUBSTRING(FacCPedm.Hora, 4, 2)) * 60) ).
    IF TimeNow > TimeOut
    THEN DO:
        MESSAGE "El pedido esta fuera de valides" VIEW-AS ALERT-BOX WARNING
            TITLE "ATENCION!".
        RETURN NO-APPLY.
    END.
  END.
  FIND gn-clie WHERE gn-clie.codcia = 0 AND
    gn-clie.CodCli = faccpedm.codcli NO-LOCK.
  DISPLAY faccpedm.codcli @ ccbcdocu.codcli faccpedm.codven @ ccbcdocu.codven
    gn-clie.DirCli @ ccbcdocu.dircli
    gn-clie.NomCli @ ccbcdocu.nomcli gn-clie.Ruc @ ccbcdocu.ruccli
    WITH FRAME {&FRAME-NAME}.
  /* CARGAMOS Y PINTAMOS EL TEMPORAL */
  RUN Carga-Temporal IN lh_handle (INPUT SELF:SCREEN-VALUE).  

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
  {src/adm/template/row-list.i "CcbCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCDocu"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingreso-a-Caja V-table-Win 
PROCEDURE Ingreso-a-Caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND faccorre WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.CodDoc = "I/C" AND
    FacCorre.NroSer = 001 EXCLUSIVE-LOCK.
  FIND FIRST T-CcbCCaja.
  CREATE CcbCCaja.
  ASSIGN
    CcbCCaja.CodCia    = s-codcia
    CcbCCaja.CodDoc    = "I/C"
    CcbCCaja.NroDoc    = STRING(FacCorre.NroSer, "999") + 
                            STRING(FacCorre.Correlativo, "999999")
    FacCorre.Correlativo= FacCorre.Correlativo + 1
    CcbCCaja.CodBco[2] = T-CcbCCaja.CodBco[2] 
    CcbCCaja.CodBco[4] = T-CcbCCaja.CodBco[4] 
    CcbCCaja.CodCli    = ccbcdocu.codcli
    CcbCCaja.CodMon    = ccbcdocu.codmon
    CcbCCaja.FchDoc    = TODAY
    CcbCCaja.ImpNac[1] = T-CcbCCaja.ImpNac[1] 
    CcbCCaja.ImpNac[2] = T-CcbCCaja.ImpNac[2] 
    CcbCCaja.ImpNac[4] = T-CcbCCaja.ImpNac[4] 
    CcbCCaja.ImpUsa[1] = T-CcbCCaja.ImpUsa[1] 
    CcbCCaja.ImpUsa[2] = T-CcbCCaja.ImpUsa[2] 
    CcbCCaja.ImpUsa[4] = T-CcbCCaja.ImpUsa[4] 
    CcbCCaja.Tipo      = s-tipo
    CcbCCaja.TpoCmb    = T-CcbCCaja.TpoCmb
    CcbCCaja.usuario   = s-user-id
    CcbCCaja.Voucher[2]= T-CcbCCaja.Voucher[2]
    CcbCCaja.Voucher[4]= T-CcbCCaja.Voucher[4] 
    CcbCCaja.VueNac    = T-CcbCCaja.VueNac 
    CcbCCaja.VueUsa    = T-CcbCCaja.VueUsa.
  RELEASE faccorre.
  CREATE CcbDCaja.
  ASSIGN
    CcbDCaja.CodCia = s-codcia
    CcbDCaja.CodDoc = ccbccaja.coddoc
    CcbDCaja.NroDoc = ccbccaja.nrodoc
    CcbDCaja.CodRef = ccbcdocu.coddoc
    CcbDCaja.NroRef = ccbcdocu.nrodoc
    CcbDCaja.CodCli = ccbcdocu.codcli
    CcbDCaja.CodMon = ccbcdocu.codmon
    CcbDCaja.FchDoc = ccbccaja.fchdoc
    CcbDCaja.ImpTot = ccbcdocu.imptot
    CcbDCaja.TpoCmb = ccbccaja.tpocmb.
  ASSIGN
    ccbcdocu.flgest = "C"
    ccbcdocu.fchcan = TODAY
    ccbcdocu.sdoact = 0.
  RELEASE ccbccaja.
  RELEASE ccbdcaja.

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
  RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Cambia-Pantalla IN lh_handle (INPUT 2).
  FIND faccorre WHERE faccorre.codcia = s-codcia 
                 AND  faccorre.coddoc = s-coddoc 
                 AND  NroSer = s-ptovta NO-LOCK.
  DISPLAY STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999")
    @ ccbcdocu.nrodoc WITH FRAME {&FRAME-NAME}.

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
DO TRANSACTION ON ERROR UNDO, RETURN ERROR:
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND faccpedm WHERE faccpedm.codcia = s-codcia AND 
        faccpedm.coddoc = s-codped AND
        faccpedm.nroped = ccbcdocu.nroped EXCLUSIVE-LOCK.
  s-codalm = faccpedm.codalm.   /* << OJO << lo tomamos del pedido */
  
  FIND faccorre WHERE faccorre.codcia = s-codcia AND faccorre.coddoc = s-coddoc AND
    NroSer = s-ptovta EXCLUSIVE-LOCK.
  ASSIGN
    ccbcdocu.nrodoc = STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999")
    faccorre.correlativo = faccorre.correlativo + 1.
  RELEASE faccorre.
    
  ASSIGN
    CcbCDocu.CodCia = s-codcia
    CcbCDocu.CodDoc = s-coddoc
    CcbCDocu.usuario= s-user-id
    CcbCDocu.Tipo   = s-tipo
    CcbCDocu.CodAlm = s-codalm
    CcbCDocu.CodCli = faccpedm.codcli
    CcbCDocu.CodMon = faccpedm.codmon
    CcbCDocu.CodMov = s-codmov
    CcbCDocu.CodPed = faccpedm.coddoc
    CcbCDocu.CodVen = faccpedm.codven
    CcbCDocu.FchCan = TODAY
    CcbCDocu.FchDoc = TODAY
    CcbCDocu.FchVto = TODAY
    CcbCDocu.ImpBrt = faccpedm.impbrt
    CcbCDocu.ImpDto = faccpedm.impdto
    CcbCDocu.ImpExo = faccpedm.impexo
    CcbCDocu.ImpIgv = faccpedm.impigv
    CcbCDocu.ImpIsc = faccpedm.impisc
    CcbCDocu.ImpTot = faccpedm.imptot
    CcbCDocu.ImpVta = faccpedm.impvta
    CcbCDocu.NroPed = faccpedm.nroped
    CcbCDocu.PorIgv = faccpedm.porigv 
    CcbCDocu.SdoAct = faccpedm.imptot
    CcbCDocu.TpoCmb = faccpedm.tpocmb.
  /* actualizamos el detalle */
  ASSIGN
    faccpedm.flgest = "C".
  DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
  FOR EACH facdpedm OF faccpedm BY nroitm:
    CREATE ccbDDocu.
    ASSIGN
        CcbDDocu.AftIgv = facdpedm.aftigv
        CcbDDocu.AftIsc = facdpedm.aftisc
        CcbDDocu.CanDes = facdpedm.canped
        CcbDDocu.CodCia = facdpedm.codcia
        CcbDDocu.CodDoc = ccbcdocu.coddoc
        CcbDDocu.codmat = facdpedm.codmat
        CcbDDocu.Factor = facdpedm.factor
        CcbDDocu.ImpDto = facdpedm.impdto
        CcbDDocu.ImpIgv = facdpedm.impigv
        CcbDDocu.ImpIsc = facdpedm.impisc
        CcbDDocu.ImpLin = facdpedm.implin
        CcbDDocu.NroDoc = ccbcdocu.nrodoc
        CcbDDocu.NroItm = i
        CcbDDocu.PorDto = facdpedm.pordto
        CcbDDocu.PreBas = facdpedm.prebas
        CcbDDocu.PreUni = facdpedm.preuni
        CcbDDocu.PreVta[1] = facdpedm.prevta[1]
        CcbDDocu.PreVta[2] = facdpedm.prevta[2]
        CcbDDocu.PreVta[3] = facdpedm.prevta[3]
        CcbDDocu.UndVta = facdpedm.undvta
        i = i + 1.
  END.
  RELEASE faccpedm.
  /* Cancelacion del documento */
  RUN Ingreso-a-Caja.
  /* Orden de despacho al almacen */
  RUN Orden-de-despacho.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
/*  RETURN "ADM-ERROR".*/
  
  IF ccbcdocu.flgcie NE "P"
  THEN DO:
    MESSAGE "Ya se realizo el cierre de caja" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
    /* regresamos el pedido a su estado original */
    FIND faccpedm WHERE faccpedm.codcia = ccbcdocu.codcia AND
         faccpedm.coddoc = ccbcdocu.codped AND
         faccpedm.nroped = ccbcdocu.nroped EXCLUSIVE-LOCK.
    ASSIGN
      faccpedm.flgest = "P".
    /****   Add by C.Q. 09/02/2000  ****/
/*    FOR EACH facDpedm OF faccpedm:
 *         Facdpedm.FlgEst = "P".
 *     END.*/
    /***********************************/
    RELEASE faccpedm.
    /* Anulamos el I/C */
    FOR EACH ccbdcaja WHERE CcbDCaja.CodCia = s-codcia AND
             CcbDCaja.CodRef = ccbcdocu.coddoc AND
             CcbDCaja.CodDoc = "I/C" AND
             CcbDCaja.NroRef = ccbcdocu.nrodoc EXCLUSIVE-LOCK:
        FIND ccbccaja OF ccbdcaja EXCLUSIVE-LOCK.
        ASSIGN 
            ccbccaja.flgest = "A".
        DELETE ccbdcaja.
    END.
    /* Anulamos orden de despacho */
    IF CcbCDocu.FlgAte = "D" THEN DO:
       FIND almcmov WHERE almcmov.codcia = ccbcdocu.codcia AND
            almcmov.codalm = ccbcdocu.codalm AND
            almcmov.tipmov = "S" AND 
            almcmov.codmov = ccbcdocu.codmov AND
            almcmov.nroser = INTEGER(SUBSTRING(ccbcdocu.nrodoc, 1, 3)) AND 
            almcmov.nrodoc = INTEGER(CcbcDocu.NroSal) EXCLUSIVE-LOCK.
       FOR EACH almdmov OF almcmov:
           RUN alm/almcgstk (ROWID(almdmov)).
           RUN alm/almacpr1 (ROWID(almdmov), "U").
           RUN alm/almacpr2 (ROWID(almdmov), "U").
           DELETE almdmov.
       END.
       ASSIGN
           almcmov.flgest = "A".
           
       RELEASE almcmov.
    END.
    
    /* borramos detalle */
    FOR EACH ccbddocu OF ccbcdocu:
        DELETE ccbddocu.
    END.
    /* NO SE BORRA LA FACTURA, SOLO SE CAMBIA EL FLGEST */
    FIND b-ccbcdocu WHERE ROWID(b-ccbcdocu) = ROWID(ccbcdocu) EXCLUSIVE-LOCK.
    ASSIGN
        b-ccbcdocu.flgest = "A"
        b-ccbcdocu.UsuAnu = S-USER-ID.
        
  END.
  /*
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  */
  
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
  IF AVAILABLE ccbcdocu
  THEN DO WITH FRAME {&FRAME-NAME}:
/*    FIND gn-clie WHERE gn-clie.codcia = 0 
 *                   AND  gn-clie.codcli = ccbcdocu.codcli 
 *                  NO-LOCK NO-ERROR.
 *     IF AVAILABLE gn-clie THEN 
 *         DISPLAY gn-clie.dircli @ CcbCDocu.DirCli 
 *                 gn-clie.nomcli @ CcbCDocu.NomCli 
 *                 gn-clie.ruc @ CcbCDocu.RucCli.
 *     ELSE 
 *         DISPLAY "" @ CcbCDocu.DirCli 
 *                 "" @ CcbCDocu.NomCli 
 *                 "" @ CcbCDocu.RucCli.*/
                
    CASE ccbcdocu.flgest:
        WHEN "A" THEN X-Status:SCREEN-VALUE = "ANULADO".
        WHEN "P" THEN X-Status:SCREEN-VALUE = "PENDIENTE".
        WHEN "C" THEN X-Status:SCREEN-VALUE = "CANCELADO".
        OTHERWISE X-Status:SCREEN-VALUE = "".
    END CASE.

    FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo 
                   AND  gn-ConVt.TipVta BEGINS "1"
                  NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN
       F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    ELSE
       F-CndVta:SCREEN-VALUE = "".

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
  RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN ccb/r-fact01 (ROWID(ccbcdocu)).
  RUN ccb/r-odesp  (ROWID(ccbcdocu)).

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
  RUN ccb/d-canc01 (faccpedm.codmon, faccpedm.imptot, OUTPUT s-ok).
  IF s-ok = NO THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Cambia-Pantalla IN lh_handle (INPUT 1).
  RUN dispatch IN THIS-PROCEDURE ('imprime':U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Orden-de-despacho V-table-Win 
PROCEDURE Orden-de-despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  CREATE almcmov.
  ASSIGN
    Almcmov.CodAlm = s-codalm
    Almcmov.CodCia = s-codcia
    Almcmov.CodMov = s-codmov
    Almcmov.FchDoc = TODAY
    Almcmov.HorSal = STRING(TIME, "HH:MM:SS")
    Almcmov.NroDoc = INTEGER(SUBSTRING(ccbcdocu.nrodoc, 4))
    Almcmov.NroSer = INTEGER(SUBSTRING(ccbcdocu.nrodoc, 1, 3))
    Almcmov.TipMov = "S"
    Almcmov.usuario= s-user-id.
  DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
  FOR EACH ccbddocu OF ccbcdocu:
    CREATE Almdmov.
    ASSIGN
        Almdmov.AftIgv = ccbddocu.aftigv
        Almdmov.AftIsc = ccbddocu.aftisc
        Almdmov.CanDes = ccbddocu.candes
        Almdmov.CodAlm = s-codalm
        Almdmov.CodCia = s-codcia
        Almdmov.codmat = ccbddocu.codmat
        Almdmov.CodMon = ccbcdocu.codmon
        Almdmov.CodMov = s-codmov
        Almdmov.CodUnd = ccbddocu.undvta
        Almdmov.Factor = ccbddocu.factor
        Almdmov.FchDoc = TODAY
        Almdmov.ImpDto = ccbddocu.impdto
        Almdmov.ImpIgv = ccbddocu.impigv
        Almdmov.ImpIsc = ccbddocu.impisc
        Almdmov.ImpLin = ccbddocu.implin
        Almdmov.NroDoc = almcmov.nrodoc
        Almdmov.NroItm = i
        Almdmov.NroSer = almcmov.nroser
        Almdmov.PorDto = ccbddocu.pordto
        Almdmov.PreBas = ccbddocu.prebas
        Almdmov.PreUni = ccbddocu.preuni
        Almdmov.TipMov = "S"
        Almdmov.TpoCmb = ccbcdocu.tpocmb
        Almcmov.TotItm = i
        i = i + 1.
        RUN alm/almdgstk (ROWID(almdmov)).
        RUN alm/almacpr1 (ROWID(almdmov), "U").
        RUN alm/almacpr2 (ROWID(almdmov), "U").
  END.  
  RELEASE almcmov.

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
        WHEN "NroPed" THEN 
            ASSIGN
                input-var-1 = ccbcdocu.nroped:SCREEN-VALUE IN FRAME {&FRAME-NAME}
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
  {src/adm/template/snd-list.i "CcbCDocu"}

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

  RETURN "ADM-ERROR".
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
    FIND faccpedm WHERE faccpedm.codcia = s-codcia AND
        faccpedm.coddoc = s-codped AND
        faccpedm.nroped = ccbcdocu.nroped:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE faccpedm
    THEN DO:
        MESSAGE "Pedido de mostrador no registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    FIND almacen OF faccpedm NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almacen
    THEN DO:
        MESSAGE "ERROR : No esta configurado el almacen en el pedido" SKIP
            "Avise inmediatamente al administrador del sistema" 
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

/*RETURN "OK".*/
MESSAGE "Acceso Denegado" VIEW-AS ALERT-BOX ERROR.
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


