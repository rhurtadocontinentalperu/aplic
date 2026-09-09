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
DEFINE SHARED TEMP-TABLE RMOV LIKE cb-dmov.
DEFINE BUFFER CMOV FOR cb-cmov.
DEFINE BUFFER DETALLE FOR cb-dmov.
DEFINE STREAM REPORT.

DEFINE {&NEW} SHARED VAR S-CODCIA AS INTEGER.
DEFINE {&NEW} SHARED VAR S-PERIODO AS INTEGER.
DEFINE {&NEW} SHARED VAR S-NROMES  AS INTEGER.
DEFINE {&NEW} SHARED VARIABLE s-user-id AS CHARACTER.
     
DEFINE VARIABLE L-CREA    AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE X-CODOPE  AS CHAR INIT "061" NO-UNDO.                                 
DEFINE VARIABLE X-NroItm AS INTEGER INITIAL 0 NO-UNDO.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER.
DEFINE SHARED VARIABLE pv-codcia AS INTEGER.
DEFINE SHARED VARIABLE cb-codcia AS INTEGER.

DEFINE VARIABLE x-DbeSol AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-HbeSol AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-SdoSol AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-DbeDol AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-HbeDol AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-SdoDol AS DECIMAL NO-UNDO.

/* FIND Empresas WHERE Empresas.CodCia = s-codcia.         */
/* IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia. */
/* IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia. */
/* IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia. */

FIND FIRST cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.CodCfg = 1
      NO-LOCK  NO-ERROR.


FIND cb-oper WHERE cb-oper.CodCia = 0 AND
     cb-oper.Codope = X-CODOPE NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-oper THEN 
   FIND cb-oper WHERE cb-oper.CodCia = S-CODCIA AND
        cb-oper.Codope = X-CODOPE NO-LOCK NO-ERROR.

/*ML01* 24/Jun/2008 ***/
DEFINE SHARED VARIABLE fFchAst AS DATE NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES cb-cmov
&Scoped-define FIRST-EXTERNAL-TABLE cb-cmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cb-cmov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cb-cmov.FchAst cb-cmov.CodDiv cb-cmov.CodMon ~
cb-cmov.GloAst cb-cmov.TpoCmb 
&Scoped-define ENABLED-TABLES cb-cmov
&Scoped-define FIRST-ENABLED-TABLE cb-cmov
&Scoped-Define ENABLED-OBJECTS RECT-7 
&Scoped-Define DISPLAYED-FIELDS cb-cmov.NroAst cb-cmov.FchAst ~
cb-cmov.CodDiv cb-cmov.CodMon cb-cmov.GloAst cb-cmov.TpoCmb 
&Scoped-define DISPLAYED-TABLES cb-cmov
&Scoped-define FIRST-DISPLAYED-TABLE cb-cmov
&Scoped-Define DISPLAYED-OBJECTS F-DesDiv 

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
DEFINE VARIABLE F-DesDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71.86 BY 2.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-cmov.NroAst AT ROW 1.19 COL 8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
     cb-cmov.FchAst AT ROW 1.19 COL 57.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .69
     cb-cmov.CodDiv AT ROW 1.96 COL 8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.72 BY .69
     F-DesDiv AT ROW 1.96 COL 18.86 COLON-ALIGNED NO-LABEL
     cb-cmov.CodMon AT ROW 1.96 COL 59.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 10.86 BY .73
     cb-cmov.GloAst AT ROW 2.69 COL 5.28
          VIEW-AS FILL-IN 
          SIZE 35.57 BY .69
     cb-cmov.TpoCmb AT ROW 2.69 COL 57.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .69
     "Moneda" VIEW-AS TEXT
          SIZE 6.57 BY .5 AT ROW 2.12 COL 52.57
     RECT-7 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.cb-cmov
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
         HEIGHT             = 2.73
         WIDTH              = 71.86.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-DesDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.GloAst IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cb-cmov.NroAst IN FRAME F-Main
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

&Scoped-define SELF-NAME cb-cmov.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CodDiv V-table-Win
ON LEAVE OF cb-cmov.CodDiv IN FRAME F-Main /* División */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
       GN-DIVI.CodDiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-DIVI THEN DO:
     MESSAGE "Codigo de Division no Registrado" VIEW-AS ALERT-BOX.
     SELF:SCREEN-VALUE = "".
     RETURN NO-APPLY.
  END.
  DISPLAY GN-DIVI.DesDiv @ F-DesDiv WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cmov.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CodMon V-table-Win
ON VALUE-CHANGED OF cb-cmov.CodMon IN FRAME F-Main /* Moneda */
DO:
  IF INPUT {&SELF-NAME} = 1
  THEN ASSIGN
            cb-cmov.TpoCmb:SCREEN-VALUE = '0.00'
            cb-cmov.TpoCmb:SENSITIVE = NO.
  ELSE DO:
    FIND gn-tcmb WHERE gn-tcmb.FECHA = INPUT cb-cmov.FchAst NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tcmb THEN DO :
        IF cb-oper.TpoCmb = 1 
        THEN DISPLAY gn-tcmb.Compra @ cb-cmov.TpoCmb WITH FRAME {&FRAME-NAME}.
        ELSE DISPLAY gn-tcmb.Venta @ cb-cmov.TpoCmb WITH FRAME {&FRAME-NAME}.
    END.
    ASSIGN
        cb-cmov.TpoCmb:SENSITIVE = YES.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cmov.FchAst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.FchAst V-table-Win
ON LEAVE OF cb-cmov.FchAst IN FRAME F-Main /* Fecha */
DO:
  IF INPUT cb-cmov.FchAst = ? THEN RETURN.
  FIND gn-tcmb WHERE gn-tcmb.FECHA = INPUT cb-cmov.FchAst NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DO :
     IF cb-oper.TpoCmb = 1 THEN 
          DISPLAY gn-tcmb.Compra @ cb-cmov.TpoCmb WITH FRAME {&FRAME-NAME}.
     ELSE DISPLAY gn-tcmb.Venta @ cb-cmov.TpoCmb WITH FRAME {&FRAME-NAME}.
  END.
  ELSE MESSAGE "Tipo de cambio no registrado" VIEW-AS ALERT-BOX WARNING.
  APPLY 'VALUE-CHANGED' TO cb-cmov.CodMon.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-RMOV V-table-Win 
PROCEDURE Actualiza-RMOV :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH RMOV:
    DELETE RMOV.
END.
IF cb-cmov.FlgEst = "A" THEN DO:
   MESSAGE "Registro Anulado " VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
IF L-CREA THEN RETURN.
FOR EACH cb-dmov WHERE cb-dmov.CodCia = cb-cmov.CodCia AND
    cb-dmov.Periodo = cb-cmov.Periodo AND
    cb-dmov.NroMes = cb-cmov.NroMes AND
    cb-dmov.Codope = cb-cmov.Codope AND
    cb-dmov.Nroast = cb-cmov.Nroast:
    
    IF cb-dmov.TpoItm = "A" THEN NEXT.
    IF cb-dmov.TpoItm = "D" THEN NEXT.
    
    CREATE RMOV.
    ASSIGN RMOV.C-Fcaja = cb-dmov.C-Fcaja
           RMOV.C-Fcaja = cb-dmov.C-Fcaja
           RMOV.cco = cb-dmov.cco 
           RMOV.Clfaux = cb-dmov.Clfaux
           RMOV.CndCmp = cb-dmov.CndCmp
           RMOV.Codaux = cb-dmov.Codaux
           RMOV.CodCia = cb-dmov.CodCia
           RMOV.Codcta = cb-dmov.Codcta
           RMOV.CodDiv = cb-dmov.CodDiv
           RMOV.Coddoc = cb-dmov.Coddoc
           RMOV.Codmon = cb-dmov.Codmon
           RMOV.Codope = cb-dmov.Codope
           RMOV.Codref = cb-dmov.Codref
           RMOV.CtaAut = cb-dmov.CtaAut
           RMOV.CtrCta = cb-dmov.CtrCta
           RMOV.DisCCo = cb-dmov.DisCCo
           RMOV.Fchdoc = cb-dmov.Fchdoc
           RMOV.Fchvto = cb-dmov.Fchvto
           RMOV.flgact = cb-dmov.flgact
           RMOV.Glodoc = cb-dmov.Glodoc
           RMOV.ImpMn1 = cb-dmov.ImpMn1
           RMOV.ImpMn2 = cb-dmov.ImpMn2
           RMOV.ImpMn3 = cb-dmov.ImpMn3
           RMOV.Nroast = cb-dmov.Nroast
           RMOV.Nrodoc = cb-dmov.Nrodoc
           RMOV.Nroitm = cb-dmov.Nroitm
           RMOV.NroMes = cb-dmov.NroMes
           RMOV.Nroref = cb-dmov.Nroref
           RMOV.Nroruc = cb-dmov.Nroruc
           RMOV.OrdCmp = cb-dmov.OrdCmp
           RMOV.Periodo = cb-dmov.Periodo
           RMOV.rel-ac-cb = cb-dmov.rel-ac-cb
           RMOV.Relacion = cb-dmov.Relacion
           RMOV.tm = cb-dmov.tm
           RMOV.Tpocmb = cb-dmov.Tpocmb
           RMOV.TpoItm = cb-dmov.TpoItm
           RMOV.TpoMov = cb-dmov.TpoMov.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Totales V-table-Win 
PROCEDURE Actualiza-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND CMOV WHERE CMOV.Codcia  = cb-CMOV.Codcia AND
       CMOV.periodo = cb-CMOV.periodo AND
       CMOV.Nromes  = cb-CMOV.Nromes  AND
       CMOV.Codope  = cb-CMOV.Codope  AND
       CMOV.Nroast  = cb-CMOV.Nroast NO-ERROR.
  ASSIGN CMOV.DbeMn1 = x-DbeSol
         CMOV.DbeMn2 = x-DbeDol 
         CMOV.HbeMn1 = x-HbeSol
         CMOV.HbeMn2 = x-HbeDol.
  RELEASE CMOV.
  
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
  {src/adm/template/row-list.i "cb-cmov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cb-cmov"}

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
   FOR EACH cb-dmov WHERE cb-dmov.Codcia  = cb-CMOV.Codcia AND
            cb-dmov.periodo = cb-CMOV.periodo AND
            cb-dmov.Nromes  = cb-CMOV.Nromes  AND
            cb-dmov.Codope  = cb-CMOV.Codope  AND
            cb-dmov.Nroast  = cb-CMOV.Nroast:
         /* Des-actulizando saldos acumulados */ 
         RUN cbd/cb-acmd.p(RECID(cb-dmov), NO , YES).
         /* Borrando el detalle del Documento */ 
         DELETE cb-dmov.
   END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Automatica V-table-Win 
PROCEDURE Genera-Automatica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    DEFINE VAR x-GenAut AS INTEGER.
    DEFINE VAR i        AS INTEGER INIT 1.
    /* Grabamos datos para la generaci¢n de Cuentas Autom ticas */
    x-GenAut  = 0.
       
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):

        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) 
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut9) <> ""
            THEN DO:
                x-GenAut = 1.
                LEAVE.
            END.                                              
        END.
    END.
    /* Verificamos si la Cuenta genera automaticas de Clase 6 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) 
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut6) <> ""
            THEN DO:
                x-GenAut = 2.
                LEAVE.
            END.
       END.
    END.
    /* Verificamos si la Cuenta genera automaticas de otro tipo */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut )
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut) <> ""
            THEN DO:
                x-GenAut = 3.
                LEAVE.
            END.
       END.
    END.
    ASSIGN cb-dmov.CtaAut = ""
           cb-dmov.CtrCta = "".
    
    CASE x-GenAut:
        /* Genera Cuentas Clase 9 */
        WHEN 1 THEN DO:
             ASSIGN cb-dmov.CtrCta    = cb-ctas.Cc1Cta.
             IF cb-ctas.CLFAUX = "@CT" THEN 
                cb-dmov.CtaAut = cb-dmov.CodAux.
             ELSE
                cb-dmov.CtaAut = cb-ctas.An1Cta.
             IF cb-dmov.CtrCta = ""  THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
             
        END.
        /* Genera Cuentas Clase 6 */
        WHEN 2 THEN DO:
                        ASSIGN cb-dmov.CtaAut = cb-ctas.An1Cta
                               cb-dmov.CtrCta    = cb-ctas.Cc1Cta.
                        IF cb-dmov.CtrCta = ""
                        THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
                    END.
        WHEN 3 THEN DO:
                        ASSIGN cb-dmov.CtaAut = cb-ctas.An1Cta
                               cb-dmov.CtrCta    = cb-ctas.Cc1Cta.
                    END.
    END CASE.

/* Generando las cuentas autom ticas */
IF cb-dmov.CtrCta <> "" THEN DO:
    FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = cb-codcia
                        AND integral.cb-ctas.CodCta = cb-dmov.CodCta
                        NO-LOCK NO-ERROR.
        IF cb-dmov.CtaAut <> ""
        THEN DO:
            CREATE DETALLE.
            X-NroItm = X-NroItm + 1.
            ASSIGN DETALLE.CodCia   = cb-dmov.CodCia
                   DETALLE.Periodo  = cb-dmov.Periodo
                   DETALLE.NroMes   = cb-dmov.NroMes
                   DETALLE.CodOpe   = cb-dmov.CodOpe
                   DETALLE.NroAst   = cb-dmov.NroAst
                   DETALLE.TpoItm   = "A"
                   DETALLE.CodMon   = cb-dmov.CodMon
                   DETALLE.TpoCmb   = cb-dmov.TpoCmb
                   DETALLE.NroItm   = X-NroItm
                   DETALLE.Codcta   = cb-dmov.CtaAut
                   DETALLE.CodDiv   = cb-dmov.CodDiv
                   DETALLE.ClfAux   = cb-dmov.ClfAux
                   DETALLE.CodAux   = cb-dmov.CodCta
                   DETALLE.NroRuc   = cb-dmov.NroRuc
                   DETALLE.CodDoc   = cb-dmov.CodDoc
                   DETALLE.NroDoc   = cb-dmov.NroDoc
                   DETALLE.GloDoc   = cb-dmov.GloDoc
                   DETALLE.CodMon   = cb-dmov.CodMon
                   DETALLE.TpoCmb   = cb-dmov.TpoCmb
                   DETALLE.TpoMov   = cb-dmov.TpoMov
                   DETALLE.NroRef   = cb-dmov.NroRef
                   DETALLE.FchDoc   = cb-dmov.FchDoc
                   DETALLE.FchVto   = cb-dmov.FchVto
                   DETALLE.ImpMn1   = cb-dmov.ImpMn1
                   DETALLE.ImpMn2   = cb-dmov.ImpMn2
                   DETALLE.ImpMn3   = cb-dmov.ImpMn3
                   DETALLE.Tm       = cb-dmov.Tm
                   DETALLE.CCO      = cb-dmov.CCO.
            IF DETALLE.TpoMov THEN x-HbeSol = x-HbeSol + DETALLE.ImpMn1.
            ELSE x-DbeSol = x-DbeSol + DETALLE.ImpMn1.        
            IF DETALLE.TpoMov THEN x-HbeDol = x-HbeDol + DETALLE.ImpMn2.
            ELSE x-DbeDol = x-DbeDol + DETALLE.ImpMn2.        
        END.
         
    CREATE DETALLE.
    X-NroItm = X-NroItm + 1.
    ASSIGN DETALLE.CodCia   = cb-dmov.CodCia
           DETALLE.Periodo  = cb-dmov.Periodo
           DETALLE.NroMes   = cb-dmov.NroMes
           DETALLE.CodOpe   = cb-dmov.CodOpe
           DETALLE.NroAst   = cb-dmov.NroAst
           DETALLE.TpoItm   = "A"
           DETALLE.CodMon   = cb-dmov.CodMon
           DETALLE.TpoCmb   = cb-dmov.TpoCmb
           DETALLE.NroItm   = X-NroItm
           DETALLE.Codcta   = cb-dmov.Ctrcta
           DETALLE.CodDiv   = cb-dmov.CodDiv
           DETALLE.ClfAux   = cb-dmov.ClfAux
           DETALLE.CodAux   = cb-dmov.CodCta
           DETALLE.NroRuc   = cb-dmov.NroRuc
           DETALLE.CodDoc   = cb-dmov.CodDoc
           DETALLE.NroDoc   = cb-dmov.NroDoc
           DETALLE.GloDoc   = cb-dmov.GloDoc
           DETALLE.CodMon   = cb-dmov.CodMon
           DETALLE.TpoCmb   = cb-dmov.TpoCmb
           DETALLE.TpoMov   = NOT cb-dmov.TpoMov
           DETALLE.ImpMn1   = cb-dmov.ImpMn1
           DETALLE.ImpMn2   = cb-dmov.ImpMn2
           DETALLE.ImpMn3   = cb-dmov.ImpMn3
           DETALLE.NroRef   = cb-dmov.NroRef
           DETALLE.FchDoc   = cb-dmov.FchDoc
           DETALLE.FchVto   = cb-dmov.FchVto
           DETALLE.Tm       = cb-dmov.Tm
           DETALLE.CCO      = cb-dmov.CCO.
    IF DETALLE.TpoMov THEN x-HbeSol = x-HbeSol + DETALLE.ImpMn1.
    ELSE x-DbeSol = x-DbeSol + DETALLE.ImpMn1.        
    IF DETALLE.TpoMov THEN x-HbeDol = x-HbeDol + DETALLE.ImpMn2.
    ELSE x-DbeDol = x-DbeDol + DETALLE.ImpMn2.        
END.
*/
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
ASSIGN x-DbeSol = 0
       x-HbeSol = 0
       x-SdoSol = 0
       x-DbeDol = 0
       x-HbeDol = 0
       x-SdoDol = 0.
FOR EACH RMOV : 
   X-NroItm = X-NroItm + 1.
   CREATE cb-dmov.
   Cb-dmov.CodCia  = Cb-cmov.CodCia.
   Cb-dmov.Periodo = Cb-cmov.Periodo.
   Cb-dmov.NroMes  = Cb-cmov.NroMes. 
   Cb-dmov.Codope  = Cb-cmov.Codope.
   Cb-dmov.Nroast  = Cb-cmov.Nroast.
   Cb-dmov.Tpocmb  = RMOV.TpoCmb. 
   Cb-dmov.C-Fcaja = RMOV.c-FCaja.
   Cb-dmov.cco     = RMOV.cco.
   Cb-dmov.Clfaux  = RMOV.ClfAux.
   Cb-dmov.Codaux  = RMOV.CodAux. 
   Cb-dmov.Codcta  = RMOV.CodCta. 
   Cb-dmov.CodDiv  = RMOV.CodDiv.
   Cb-dmov.Codmon  = RMOV.CodMon. 
   Cb-dmov.CtaAut  = RMOV.CtaAut. 
   Cb-dmov.CtrCta  = RMOV.CtrCta. 
   Cb-dmov.flgact  = YES.
   cb-dmov.TpoItm  = RMOV.TpoItm.
   Cb-dmov.Glodoc  = RMOV.GloDoc. 
   Cb-dmov.ImpMn1  = RMOV.ImpMn1. 
   Cb-dmov.ImpMn2  = RMOV.ImpMn2. 
   Cb-dmov.ImpMn3  = RMOV.IMpMn3.
   Cb-dmov.Coddoc  = RMOV.CodDoc. 
   Cb-dmov.Nrodoc  = RMOV.NroDoc. 
   Cb-dmov.Fchdoc  = RMOV.FchDoc. 
   Cb-dmov.Fchvto  = RMOV.FchVto. 
   Cb-dmov.CodRef  = RMOV.CodRef. 
   Cb-dmov.Nroref  = RMOV.NroRef. 
   Cb-dmov.Nroruc  = RMOV.NroRuc. 
   Cb-dmov.tm      = RMOV.Tm.
   Cb-dmov.TpoMov  = RMOV.TpoMov.
   cb-dmov.CndCmp  = RMOV.CndCmp.
   cb-dmov.DisCCo  = RMOV.DisCCo.
   cb-dmov.NroItm  = X-NroItm.
   cb-dmov.OrdCmp  = RMOV.OrdCmp.
   
   RUN cbd/cb-acmd.p(RECID(cb-dmov), YES, YES).   
   
   IF cb-dmov.TpoMov THEN x-HbeSol = x-HbeSol + cb-dmov.ImpMn1.
   ELSE x-DbeSol = x-DbeSol + cb-dmov.ImpMn1.        
   IF cb-dmov.TpoMov THEN x-HbeDol = x-HbeDol + cb-dmov.ImpMn2.
   ELSE x-DbeDol = x-DbeDol + cb-dmov.ImpMn2.        
   
   RUN Genera-Automatica.
END.
/* Calculamos Diferencia de cambio */

RUN Genera-Diferencia-Cambio (x-DbeSol, x-HbeSol, 1).

RUN Genera-Diferencia-Cambio (x-DbeDol, x-HbeDol, 2).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Diferencia-Cambio V-table-Win 
PROCEDURE Genera-Diferencia-Cambio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER x-debe   AS DECIMAL.
DEFINE INPUT PARAMETER x-Haber  AS DECIMAL.
DEFINE INPUT PARAMETER x-Moneda AS INTEGER.

IF ABS(x-Debe) - ABS(x-Haber) = 0 THEN RETURN.

   FIND cb-cfgg WHERE cb-cfgg.CodCia = 0 AND
        cb-cfgg.Codcfg = "C01" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-cfgg THEN
      FIND cb-cfgg WHERE cb-cfgg.CodCia = S-CodCia AND
           cb-cfgg.Codcfg = "C01" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-cfgg THEN RETURN.

   DEFINE VARIABLE CtaDif AS CHAR NO-UNDO.
   IF (ABS(x-Debe) - ABS(x-Haber)) < 0 THEN CtaDif = cb-cfgg.codcta[1].  /* PERDIDA */
   ELSE CtaDif = cb-cfgg.codcta[2].                                      /* GANANCIA */
   
   X-NroItm = X-NroItm + 1.
   CREATE cb-dmov.
   cb-dmov.CodCia  = cb-cmov.CodCia. 
   cb-dmov.NroMes  = cb-cmov.NroMes. 
   cb-dmov.Periodo = cb-cmov.Periodo.
   cb-dmov.Codope  = cb-cmov.Codope.
   cb-dmov.NroAst  = cb-cmov.NroAst.
   cb-dmov.Codcta  = CtaDif.
   cb-dmov.CodDiv  = cb-cmov.CodDiv.
   cb-dmov.Codmon  = x-Moneda.
   cb-dmov.TpoItm  = "D".
   cb-dmov.flgact  = YES.
   IF CtaDif = cb-cfgg.codcta[2] THEN cb-dmov.Glodoc  = "Ganancia por Diferencia de Cambio". 
   ELSE cb-dmov.Glodoc  = "Perdida por Diferencia de Cambio". 
   cb-dmov.Tpocmb  = 0.
   
   IF x-Moneda = 1 THEN ASSIGN cb-dmov.ImpMn1  = ABSOLUTE(x-Debe - x-Haber) cb-dmov.ImpMn2 = 0. 
   ELSE ASSIGN cb-dmov.ImpMn2  = ABSOLUTE(x-Debe - x-Haber) cb-dmov.ImpMn1 = 0. 

   cb-dmov.ImpMn3  = ABSOLUTE(x-Debe - x-Haber). 
   cb-dmov.TpoMov  = (x-Debe > x-Haber).
   cb-dmov.NroItm  = X-NroItm.

   IF cb-dmov.TpoMov THEN x-HbeSol = x-HbeSol + cb-dmov.ImpMn1.
   ELSE x-DbeSol = x-DbeSol + cb-dmov.ImpMn1.
   IF cb-dmov.TpoMov THEN x-HbeDol = x-HbeDol + cb-dmov.ImpMn2.
   ELSE x-DbeDol = x-DbeDol + cb-dmov.ImpMn2.
      
   FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                      cb-ctas.CodCta = cb-dmov.CodCta NO-LOCK NO-ERROR.   
   RUN Genera-Automatica.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Voucher V-table-Win 
PROCEDURE Imprime-Voucher :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE cb-cmov THEN RETURN.
IF cb-cmov.FlgEst = "A" THEN RETURN.

FIND cb-oper WHERE cb-oper.CodCia = 0 AND
     cb-oper.Codope = cb-cmov.codope NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-oper THEN
   FIND cb-oper WHERE cb-oper.CodCia = cb-cmov.codcia AND
        cb-oper.Codope = cb-cmov.codope NO-LOCK NO-ERROR.

DEFINE var X-PAG AS CHAR FORMAT "999". 
DEFINE VARIABLE X-NomCta   AS CHAR LABEL "Descripcion".
DEFINE VARIABLE X-Mon      AS CHAR.
DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
DEFINE VARIABLE x-codmon   AS INTEGER INITIAL 1.
DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
DEFINE VARIABLE x-TotDeb   AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
DEFINE VARIABLE x-TotHab   AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".

RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
pinta-mes = pinta-mes + " DE " + STRING( s-periodo , "9,999" ).
x-codmon = cb-cmov.codmon.
IF x-CodMon = 1 THEN  x-Mon = "S/.".
ELSE x-Mon = "US$".
    
DEFINE FRAME f-cab
  cb-dmov.codcta 
  cb-dmov.codDoc AT 11
  cb-dmov.NroDoc AT 16 FORMAT "X(10)"
  cb-dmov.CodAux AT 27 FORMAT "X(8)"
  cb-dmov.FchVto AT 37
  X-NomCta       FORMAT "X(45)" AT 48
  x-debe         AT 97
  x-haber        AT 117 
  HEADER
       empresas.nomcia
       cb-oper.Nomope AT 50
       "FECHA : " TO 119 cb-cmov.fchast FORMAT "99/99/9999" SKIP 
       "ASIENTO No: " AT 55 cb-cmov.codope "-" cb-cmov.nroast 
                "HORA : " TO 119 STRING(TIME, "HH:MM AM") SKIP
       "MONEDA : " TO 119 x-Mon SKIP
       "Glosa     : " cb-cmov.GloAst FORMAT "X(80)" VIEW-AS TEXT 
       "TIPO CAMBIO : " TO 119 cb-cmov.TpoCmb FORMAT ">,>>9.9999" SKIP(1)
       "----------------------------------------------------------------------------------------------------------------------------------" SKIP
       " Cuenta   Doc  Numero   Auxiliar    Fecha Vcto Descripcion                                               Cargos            Abonos " SKIP
       "----------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 130 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

/*OUTPUT STREAM report TO C:\TMP\PRUEBA.PRN PAGED PAGE-SIZE 33.    */
OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 33.   
PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(33) .
 
PUT STREAM report CONTROL "~033x" NULL "~017~033P".

FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = cb-cmov.codcia
                AND cb-dmov.periodo = cb-cmov.periodo
                AND cb-dmov.nromes  = cb-cmov.NroMes
                AND cb-dmov.codope  = cb-cmov.codope
                AND cb-dmov.nroast  = cb-cmov.nroast
    BREAK BY cb-dmov.nroast 
          BY cb-dmov.tpomov 
    ON ERROR UNDO, LEAVE:
    /* IF cb-dmov.tpoitm = "A" THEN NEXT.*/
    x-NomCta = "".
    FIND cb-ctas WHERE cb-ctas.CodCia = 0 AND
         cb-ctas.codcta = cb-dmov.CodCta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN 
       FIND cb-ctas WHERE cb-ctas.CodCia = S-CODCIA AND
            cb-ctas.codcta = cb-dmov.CodCta NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas THEN x-NomCta  = cb-ctas.nomcta.
    CASE x-codmon:
        WHEN 2 THEN DO:
            x-NomCta = x-NomCta + " (US$" + STRING(ImpMn2) + ")".
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
    DISPLAY STREAM report 
            cb-dmov.codcta
            cb-dmov.codDoc 
            cb-dmov.CodAux
            cb-dmov.NroDoc 
            cb-dmov.FchVto 
            x-NomCta
            x-debe WHEN (x-debe > 0)
            x-haber WHEN (x-haber > 0) WITH FRAME f-cab.
    X-TotDeb = X-TotDeb + x-debe.
    X-TotHab = X-TotHab + x-Haber.
END.
PUT STREAM report SKIP.
PUT STREAM report "----------------" AT 97  "----------------" AT 115 SKIP.
PUT STREAM report X-TotDeb AT 97    X-TotHab AT 115 SKIP.
PUT STREAM report "----------------" AT 97  "----------------" AT 115 SKIP.
PUT STREAM report SKIP.

DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 5 :
   PUT STREAM report "" skip.
END.
PUT STREAM report "                         -----------------       -----------------       -----------------      "  AT 20 SKIP.
PUT STREAM report "                              HECHO                   REVISADO.           Vo.Bo.GERENCIA        "  AT 20 SKIP.
PUT STREAM report pinta-mes.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  DISPLAY TODAY @ integral.cb-cmov.Fchast WITH FRAME {&FRAME-NAME}. 
  RUN Actualiza-RMOV.
  RUN Procesa-Handle IN lh_Handle ("Browse").
  RUN Procesa-Handle IN lh_Handle ("Pagina2").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE X-NROAST AS INTEGER NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  IF L-CREA THEN DO:
     RUN cbd/cbdnast.p(cb-codcia, s-codcia, s-periodo, s-NroMes, X-CodOpe , OUTPUT x-nroast).
     ASSIGN cb-cmov.Codcia  = S-CODCIA
            cb-cmov.Periodo = S-PERIODO
            cb-cmov.Nromes  = S-NROMES
            cb-cmov.CodOpe  = X-CodOpe
            cb-cmov.Nroast  = STRING(X-NROAST,"999999")
            cb-cmov.Usuario = S-USER-ID.
     DISPLAY X-NROAST @ cb-cmov.Nroast WITH FRAME {&FRAME-NAME}.
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
  
  RUN Procesa-Handle IN lh_Handle ("Pagina1").
  
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
   IF cb-cmov.FlgEst = "A" THEN DO:
      MESSAGE "Registro Anulado " VIEW-AS ALERT-BOX ERROR.
      RETURN ERROR.
   END.
   RUN Borra-Detalle.
  /* Dispatch standard ADM method.                             */
  FIND CMOV WHERE CMOV.Codcia  = cb-CMOV.Codcia AND
       CMOV.periodo = cb-CMOV.periodo AND
       CMOV.Nromes  = cb-CMOV.Nromes  AND
       CMOV.Codope  = cb-CMOV.Codope  AND
       CMOV.Nroast  = cb-CMOV.Nroast NO-ERROR.
  ASSIGN CMOV.Flgest = "A"
         CMOV.GloAst = "A  N  U  L  A  D  O" + cb-CMOV.GloAst.
  RELEASE CMOV.
  /* Code placed here will execute AFTER standard behavior.    */

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
  
  IF AVAILABLE cb-cmov THEN DO:
     FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
          GN-DIVI.CodDiv = cb-cmov.CodDiv NO-LOCK NO-ERROR.
     IF AVAILABLE GN-DIVI THEN 
         DISPLAY GN-DIVI.DesDiv @ F-DesDiv WITH FRAME {&FRAME-NAME}.
     ELSE DISPLAY "" @ F-DesDiv WITH FRAME {&FRAME-NAME}.
     fFchAst = cb-cmov.fchast.
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

  SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
  IF NOT answer THEN RETURN.

  RUN Imprime-Voucher.

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
  IF NOT L-Crea THEN RUN Borra-Detalle.
  RUN Genera-Detalle.
  RUN Actualiza-Totales.
  RUN dispatch IN THIS-PROCEDURE ('imprime':U).
  RUN Procesa-Handle IN lh_Handle ("Browse").
  RUN Procesa-Handle IN lh_Handle ("Pagina1").
 
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
  {src/adm/template/snd-list.i "cb-cmov"}

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

  IF p-state = 'update-begin':U AND NOT AVAILABLE cb-cmov THEN RETURN ERROR.
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  IF p-state = 'update-begin':U THEN DO:
     L-CREA = NO.
     RUN Actualiza-RMOV.
     RUN Procesa-Handle IN lh_Handle ("Browse").
     RUN Procesa-Handle IN lh_Handle ("Pagina2").
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
DEFINE VARIABLE I-MON AS INTEGER NO-UNDO.
DO WITH FRAME {&FRAME-NAME}:
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
      END. */
   I-MON = INTEGER(cb-cmov.Codmon:SCREEN-VALUE).
   ASSIGN x-DbeSol = 0   x-HbeSol = 0    x-SdoSol = 0
          x-DbeDol = 0   x-HbeDol = 0    x-SdoDol = 0.
   FOR EACH RMOV : 
       IF RMOV.TpoMov THEN x-HbeSol = x-HbeSol + RMOV.ImpMn1.
       ELSE x-DbeSol = x-DbeSol + RMOV.ImpMn1.        
       IF RMOV.TpoMov THEN x-HbeDol = x-HbeDol + RMOV.ImpMn2.
       ELSE x-DbeDol = x-DbeDol + RMOV.ImpMn2.        
   END.
   IF (I-MON = 1 AND (x-DbeSol - x-HbeSol) <> 0) OR
      (I-MON = 2 AND (x-DbeDol - x-HbeDol) <> 0) THEN DO:
      MESSAGE "Asiento descuadrado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO cb-cmov.GloAst.
      RETURN "ADM-ERROR".
   END.
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

