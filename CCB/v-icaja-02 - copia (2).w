&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-VVALE NO-UNDO LIKE VtaVVale.



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
DEFINE SHARED VAR s-amortiza-letras AS LOG INIT NO NO-UNDO.

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
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-FlgSit AS CHAR.    /* YES o NO */

DEF VAR s-ok AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR X-ImpNac AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR X-ImpUsa AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR X-Importe AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR x-mon AS INTEGER INIT 0 NO-UNDO.
DEF VAR X-NUMDOC AS CHAR INIT "".

DEF SHARED TEMP-TABLE T-CcbDCaja LIKE CcbDCaja.
DEF TEMP-TABLE TT-CcbDCaja LIKE T-CcbDCaja.
DEF SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

DEF BUFFER b-ccbccaja FOR ccbccaja.
DEF BUFFER b-ccbdcaja FOR ccbdcaja.
DEF BUFFER b-CDocu    FOR ccbcdocu.
DEF BUFFER x-ccbcdocu FOR ccbcdocu.
DEF BUFFER x-faccpedi FOR faccpedi.
DEF BUFFER x-vtatabla FOR vtatabla.

/* Se usa para las retenciones */
DEFINE NEW SHARED TEMP-TABLE wrk_ret NO-UNDO
    FIELDS CodCia LIKE CcbDCaja.CodCia
    FIELDS CodCli LIKE CcbCDocu.CodCli
    FIELDS CodDoc LIKE CcbCDocu.CodDoc COLUMN-LABEL "Tipo  "
    FIELDS NroDoc LIKE CcbCDocu.NroDoc COLUMN-LABEL "Documento " FORMAT "x(10)"
    FIELDS CodRef LIKE CcbDCaja.CodRef
    FIELDS NroRef LIKE CcbDCaja.NroRef
    FIELDS FchDoc LIKE CcbCDocu.FchDoc COLUMN-LABEL "    Fecha    !    Emisión    "
    FIELDS FchVto LIKE CcbCDocu.FchVto COLUMN-LABEL "    Fecha    ! Vencimiento"
    FIELDS CodMon AS CHARACTER COLUMN-LABEL "Moneda" FORMAT "x(3)"
    FIELDS ImpTot LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe Total"
    FIELDS ImpRet LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe!a Retener"
    FIELDS FchRet AS DATE
    FIELDS NroRet AS CHARACTER
    INDEX ind01 CodRef NroRef.

/* Se usa para las N/C */
DEFINE NEW SHARED TEMP-TABLE wrk_dcaja NO-UNDO LIKE ccbdcaja.

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
&Scoped-define EXTERNAL-TABLES CcbCCaja
&Scoped-define FIRST-EXTERNAL-TABLE CcbCCaja


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCCaja.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCCaja.CodCli CcbCCaja.TpoCmb ~
CcbCCaja.NomCli CcbCCaja.FchDoc CcbCCaja.Glosa 
&Scoped-define ENABLED-TABLES CcbCCaja
&Scoped-define FIRST-ENABLED-TABLE CcbCCaja
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS CcbCCaja.NroDoc CcbCCaja.CodCli ~
CcbCCaja.TpoCmb CcbCCaja.NomCli CcbCCaja.FchDoc CcbCCaja.Glosa ~
CcbCCaja.usuario 
&Scoped-define DISPLAYED-TABLES CcbCCaja
&Scoped-define FIRST-DISPLAYED-TABLE CcbCCaja
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
DEFINE VARIABLE FILL-IN_Ruc AS CHARACTER FORMAT "x(11)" 
     LABEL "Ruc" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69.

DEFINE VARIABLE X-Status AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67.57 BY 3.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCCaja.NroDoc AT ROW 1.38 COL 7 COLON-ALIGNED
          LABEL "Número" FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .69
          FONT 6
     X-Status AT ROW 1.38 COL 54 COLON-ALIGNED
     CcbCCaja.CodCli AT ROW 2.15 COL 7 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FILL-IN_Ruc AT ROW 2.15 COL 26 COLON-ALIGNED
     CcbCCaja.TpoCmb AT ROW 2.15 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbCCaja.NomCli AT ROW 2.92 COL 7 COLON-ALIGNED
          LABEL "Nombre" FORMAT "X(50)"
          VIEW-AS FILL-IN 
          SIZE 40.86 BY .69
     CcbCCaja.FchDoc AT ROW 2.92 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CcbCCaja.Glosa AT ROW 3.69 COL 7 COLON-ALIGNED
          LABEL "Concepto"
          VIEW-AS FILL-IN 
          SIZE 41 BY .69
     CcbCCaja.usuario AT ROW 3.69 COL 54 COLON-ALIGNED
          LABEL "Usuario"
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
   Temp-Tables and Buffers:
      TABLE: T-VVALE T "NEW SHARED" NO-UNDO INTEGRAL VtaVVale
   END-TABLES.
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
         HEIGHT             = 3.69
         WIDTH              = 67.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCCaja.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FILL-IN_Ruc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.NomCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CcbCCaja.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.CodCli V-table-Win
ON LEAVE OF CcbCCaja.CodCli IN FRAME F-Main /* Cliente */
DO:

    IF SELF:SCREEN-VALUE = "" THEN DO:
        s-codcli = "NOT FOUND!".
        RETURN.
    END.

    FIND gn-clie WHERE
        gn-clie.codcia = cl-codcia AND
        gn-clie.codcli = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE "Cliente no registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF gn-clie.codcli <> "11111111111" THEN DO:
        DISPLAY
            gn-clie.nomcli @ CcbcCaja.Nomcli
            gn-clie.ruc @ FILL-IN_Ruc
            WITH FRAME {&FRAME-NAME}.
    END.

    s-codcli = SELF:SCREEN-VALUE.
    CcbCcaja.Codcli:SENSITIVE = NO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-Cheque V-table-Win 
PROCEDURE Anula-Cheque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    IF ((CcbCCaja.Voucher[2] <> "" ) AND
        (CcbCCaja.ImpNac[2] + CcbCCaja.ImpUsa[2]) > 0 ) OR
        ((CcbCCaja.Voucher[3] <> "" ) AND
        (CcbCCaja.ImpNac[3] + CcbCCaja.ImpUsa[3]) > 0) THEN DO:

        IF CcbCCaja.Voucher[2] <> "" THEN X-NUMDOC = CcbCCaja.Voucher[2].
        IF CcbCCaja.Voucher[3] <> "" THEN X-NUMDOC = CcbCCaja.Voucher[3].

        FIND CcbCDocu WHERE
            CcbCDocu.CodCia = S-CodCia AND
            CcbCDocu.CodDoc = "CHC" AND
            CcbCDocu.NroDoc = X-NUMDOC
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN DELETE CcbCDocu.
        RELEASE Ccbcdocu.
    END.
END.

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

    FOR EACH T-CcbDCaja:
        DELETE T-CcbDCaja.
    END.

    FOR EACH wrk_ret:
        DELETE wrk_ret.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-DCO V-table-Win 
PROCEDURE Cierra-DCO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF Ccbcdocu.CodDiv <> "00506" THEN RETURN 'OK'.
IF Ccbcdocu.SdoAct > 0 THEN RETURN 'OK'.
IF Ccbcdocu.CodDoc <> "DCO" THEN RETURN 'OK'.
IF LOOKUP(Ccbcdocu.CodRef, 'FAC,BOL') = 0 THEN RETURN 'OK'.

/* Buscamos FAC o BOL relacionados */
DEF BUFFER b-Ccbcdocu FOR Ccbcdocu.
{lib/lock-genericov3.i ~
    &Tabla="b-Ccbcdocu" ~
    &Alcance="FIRST" ~
    &Condicion="b-Ccbcdocu.codcia = Ccbcdocu.codcia AND ~
    b-Ccbcdocu.coddoc = Ccbcdocu.codref AND ~
    b-Ccbcdocu.nrodoc = Ccbcdocu.nroref" ~
    &Bloqueo="EXCLUSIVE-LOCK" ~
    &Accion="RETRY" ~
    &Mensaje="YES" ~
    &TipoError="UNDO, RETURN 'ADM-ERROR'"}
/* Cancelacion total */
CREATE Ccbdcaja.
ASSIGN
    CcbDCaja.CodCia = b-Ccbcdocu.codcia 
    CcbDCaja.CodDiv = s-coddiv
    CcbDCaja.CodDoc = Ccbcdocu.coddoc           /* DCO */
    CcbDCaja.NroDoc = Ccbcdocu.nrodoc
    CcbDCaja.CodRef = b-Ccbcdocu.coddoc         /* FAC */
    CcbDCaja.NroRef = b-Ccbcdocu.nrodoc
    CcbDCaja.CodCli = b-Ccbcdocu.codcli
    CcbDCaja.CodMon = b-Ccbcdocu.codmon 
    CcbDCaja.FchDoc = TODAY
    CcbDCaja.ImpTot = b-Ccbcdocu.sdoact
    CcbDCaja.TpoCmb = Ccbcdocu.tpocmb.
ASSIGN
    b-CcbCDocu.FchCan = TODAY
    b-CcbCDocu.FlgEst = "C"
    b-CcbCDocu.SdoAct = 0.
RELEASE b-Ccbcdocu.
RELEASE Ccbdcaja.

RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-Cierre-DCO V-table-Win 
PROCEDURE Extorna-Cierre-DCO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF Ccbcdocu.CodDiv <> "00506" THEN RETURN 'OK'.
IF Ccbcdocu.CodDoc <> "DCO" THEN RETURN 'OK'.
IF LOOKUP(Ccbcdocu.CodRef, 'FAC,BOL') = 0 THEN RETURN 'OK'.

/* Buscamos FAC o BOL relacionados */
DEF BUFFER b-Ccbcdocu FOR Ccbcdocu.
DEF BUFFER b-CcbDCaja FOR CcbDCaja.

{lib/lock-genericov3.i ~
    &Tabla="b-Ccbcdocu" ~
    &Alcance="FIRST" ~
    &Condicion="b-Ccbcdocu.codcia = Ccbcdocu.codcia AND ~
    b-Ccbcdocu.coddoc = Ccbcdocu.codref AND ~
    b-Ccbcdocu.nrodoc = Ccbcdocu.nroref" ~
    &Bloqueo="EXCLUSIVE-LOCK" ~
    &Accion="RETRY" ~
    &Mensaje="YES" ~
    &TipoError="UNDO, RETURN 'ADM-ERROR'"}
/* Cancelacion total */
ASSIGN
    b-CcbCDocu.FchCan = ?
    b-CcbCDocu.FlgEst = "P".
FOR EACH b-CcbDCaja WHERE b-CcbDCaja.CodCia = b-Ccbcdocu.codcia AND
    b-CcbDCaja.CodDiv = s-coddiv AND
    b-CcbDCaja.CodDoc = Ccbcdocu.coddoc AND          /* DCO */
    b-CcbDCaja.NroDoc = Ccbcdocu.nrodoc AND 
    b-CcbDCaja.CodRef = b-Ccbcdocu.coddoc AND        /* FAC */
    b-CcbDCaja.NroRef = b-Ccbcdocu.nrodoc EXCLUSIVE-LOCK ON ERROR UNDO, RETURN 'ADM-ERROR':
    ASSIGN
        b-CcbCDocu.SdoAct = b-CcbCDocu.SdoAct + b-CcbDCaja.ImpTot.
    DELETE b-CcbDCaja.
END.
RELEASE b-Ccbcdocu.
RELEASE b-CcbDCaja.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Cheque V-table-Win 
PROCEDURE Genera-Cheque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cliename LIKE Gn-Clie.Nomcli.
    DEFINE VARIABLE clieruc LIKE Gn-Clie.Ruc.

    FIND Gn-Clie WHERE
        Gn-Clie.Codcia = cl-codcia AND
        Gn-Clie.CodCli = T-CcbCCaja.Voucher[10]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-Clie THEN
        ASSIGN
            cliename = Gn-Clie.Nomcli
            clieruc = Gn-Clie.Ruc.

    CREATE CcbCDocu.
    ASSIGN
        CcbCDocu.CodCia = S-CodCia
        CcbCDocu.CodDiv = S-CodDiv
        CcbCDocu.CodDoc = "CHC"
        CcbCDocu.CodCli = T-CcbCCaja.Voucher[10]
        CcbCDocu.NomCli = cliename
        CcbCDocu.RucCli = clieRuc
        CcbCDocu.FlgEst = "P"
        CcbCDocu.Usuario = s-User-Id
        CcbCDocu.TpoCmb = T-CcbCCaja.TpoCmb 
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.CodRef = CcbCCaja.CodDoc
        CcbCDocu.NroRef = CcbCCaja.NroDoc.
    IF T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2] > 0 THEN
        ASSIGN
            CcbCDocu.NroDoc = T-CcbCCaja.Voucher[2]
            CcbCDocu.CodMon = IF T-ccbCCaja.ImpNac[2] <> 0 THEN 1 ELSE 2
            CcbCDocu.ImpTot = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
            CcbCDocu.SdoAct = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
            CcbCDocu.ImpBrt = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
            CcbCDocu.FchVto = T-CcbCCaja.FchVto[2].
    ELSE
        ASSIGN
            CcbCDocu.NroDoc = T-CcbCCaja.Voucher[3]
            CcbCDocu.CodMon = IF T-ccbCCaja.ImpNac[3] <> 0 THEN 1 ELSE 2
            CcbCDocu.ImpTot = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
            CcbCDocu.SdoAct = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
            CcbCDocu.ImpBrt = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
            CcbCDocu.FchVto = T-CcbCCaja.FchVto[3].
    RELEASE Ccbcdocu.


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
        CcbCCaja.CodBco[2]  = t-CcbCCaja.CodBco[2]
        CcbCCaja.CodBco[3]  = t-CcbCCaja.CodBco[3]
        CcbCCaja.CodBco[4]  = t-CcbCCaja.CodBco[4]
        CcbCCaja.CodBco[5]  = t-CcbCCaja.CodBco[5]
        CcbCCaja.CodBco[7]  = t-CcbCCaja.CodBco[7]
        CcbCCaja.CodBco[8]  = t-CcbCCaja.CodBco[8]
        CcbCCaja.Codcta[5]  = t-CcbCCaja.CodBco[5]
        CcbCCaja.FchVto[2]  = t-CcbCCaja.FchVto[2]
        CcbCCaja.FchVto[3]  = t-CcbCCaja.FchVto[3]
        CcbCCaja.ImpNac[1]  = t-CcbCCaja.ImpNac[1]
        CcbCCaja.ImpNac[2]  = t-CcbCCaja.ImpNac[2]
        CcbCCaja.ImpNac[3]  = t-CcbCCaja.ImpNac[3]
        CcbCCaja.ImpNac[4]  = t-CcbCCaja.ImpNac[4]
        CcbCCaja.ImpNac[5]  = t-CcbCCaja.ImpNac[5]
        CcbCCaja.ImpNac[6]  = t-CcbCCaja.ImpNac[6]
        CcbCCaja.ImpNac[7]  = t-CcbCCaja.ImpNac[7]
        CcbCCaja.ImpNac[8]  = t-CcbCCaja.ImpNac[8]
        CcbCCaja.ImpNac[9]  = t-CcbCCaja.ImpNac[9]
        CcbCCaja.ImpNac[10]  = t-CcbCCaja.ImpNac[10]
        CcbCCaja.ImpUsa[1]  = t-CcbCCaja.ImpUsa[1]
        CcbCCaja.ImpUsa[2]  = t-CcbCCaja.ImpUsa[2]
        CcbCCaja.ImpUsa[3]  = t-CcbCCaja.ImpUsa[3]
        CcbCCaja.ImpUsa[4]  = t-CcbCCaja.ImpUsa[4]
        CcbCCaja.ImpUsa[5]  = t-CcbCCaja.ImpUsa[5]
        CcbCCaja.ImpUsa[6]  = t-CcbCCaja.ImpUsa[6]
        CcbCCaja.ImpUsa[7]  = t-CcbCCaja.ImpUsa[7]
        CcbCCaja.ImpUsa[8]  = t-CcbCCaja.ImpUsa[8]
        CcbCCaja.ImpUsa[9]  = t-CcbCCaja.ImpUsa[9]
        CcbCCaja.ImpUsa[10]  = t-CcbCCaja.ImpUsa[10]
        CcbCCaja.Voucher[2] = t-CcbCCaja.Voucher[2]
        CcbCCaja.Voucher[3] = t-CcbCCaja.Voucher[3]
        CcbCCaja.Voucher[4] = t-CcbCCaja.Voucher[4]
        CcbCCaja.Voucher[5] = t-CcbCCaja.Voucher[5]
        CcbCCaja.Voucher[6] = t-CcbCCaja.Voucher[6]
        CcbCCaja.Voucher[7] = t-CcbCCaja.Voucher[7]
        CcbCCaja.Voucher[8] = t-CcbCCaja.Voucher[8]
        CcbCCaja.Voucher[9] = t-CcbCCaja.Voucher[9]
        CcbCCaja.Voucher[10] = t-CcbCCaja.Voucher[10]
        CcbCCaja.VueNac     = t-CcbCCaja.VueNac
        CcbCCaja.VueUsa     = t-CcbCCaja.VueUsa
        CcbCCaja.TpoCmb     = t-CcbCCaja.TpoCmb
        CcbcCaja.Flgest     = "C".

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
  IF s-user-id <> 'ADMIN' THEN DO:
      /* RHC 28/03/2016 Rutrina que verifica que no haya un cierre de caja pendiente */
      RUN ccb/control-cierre-caja (s-codcia,s-coddiv,s-user-id,s-codter).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      /* Verifica Monto Tope por CAJA */
      DEFINE VARIABLE lAnswer AS LOGICAL NO-UNDO.
      RUN ccb\p-vermtoic.p(OUTPUT lAnswer).
      IF lAnswer THEN RETURN ERROR.

      /* Busca I/C tipo "Sencillo" Activo */
      IF NOT s-codter BEGINS "ATE" THEN DO:
          lAnswer = FALSE.
          FOR EACH b-ccbccaja WHERE
              b-ccbccaja.codcia = s-codcia AND
              b-ccbccaja.coddiv = s-coddiv AND
              b-ccbccaja.coddoc = "I/C" AND
              b-ccbccaja.tipo = "SENCILLO" AND
              b-ccbccaja.usuario = s-user-id AND
              b-ccbccaja.codcaja = s-codter AND
              b-ccbccaja.flgcie = "P" NO-LOCK:
              IF b-ccbccaja.flgest <> "A" THEN lAnswer = TRUE.
          END.
          IF NOT lAnswer THEN DO:
              MESSAGE
                  "Se debe ingresar el I/C SENCILLO como primer movimiento"
                  VIEW-AS ALERT-BOX ERROR.
              RETURN ERROR.
          END.
      END.
  END.

  RUN Borra-temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Cambia-Pantalla IN lh_handle (INPUT 2).

    FIND faccorre WHERE
        faccorre.codcia = s-codcia AND
        faccorre.coddoc = s-coddoc AND
        faccorre.NroSer = s-ptovta NO-LOCK.
    do with frame {&FRAME-NAME}:
        DISPLAY
            STRING(faccorre.nroser, "999") +
                STRING(FacCorre.Correlativo, "999999") @
                ccbccaja.nrodoc
            WITH FRAME {&FRAME-NAME}.
        /* Tipo de Cambio */
        DISPLAY
            s-tpocmb @ ccbccaja.tpocmb
            TODAY @ ccbccaja.fchdoc
            WITH FRAME {&FRAME-NAME}.
        ccbccaja.tpocmb:sensitive = no.
        ccbccaja.fchDoc:sensitive = no.

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
      CcbCCaja.FchDoc = TODAY.

  DEFINE VAR x-msg AS CHAR.

    /* Crea Detalle de Caja */
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
    FOR EACH ccbdcaja OF ccbccaja NO-LOCK:
        FIND ccbcdocu WHERE
            ccbcdocu.codcia = s-codcia AND
            /*ccbcdocu.codcli = CcbCCaja.Codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME} AND*/
            ccbcdocu.coddoc = ccbdcaja.codref AND
            ccbcdocu.nrodoc = ccbdcaja.nroref
            EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN ccbcdocu.sdoact = ccbcdocu.sdoact - ccbdcaja.imptot.
        IF ccbcdocu.sdoact <= 0 THEN DO: /* OJO */
            ASSIGN
                ccbcdocu.fchcan = TODAY
                ccbcdocu.flgest = "C".
            /* RHC 23/05/2019 LISTA EXPRESS: Cancelamos la FAC o BOL relacionada al DCO */
            RUN Cierra-DCO.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            /* ************************************************************************ */
            /* RHC 14.12.2010 Control de Facturas Adelantadas */
            /* RHC 29/10/2021 En caso se aplique una N/C NO genera A/C */
            FIND FIRST t-ccbccaja.
            IF AVAILABLE t-ccbccaja AND (T-CcbCCaja.ImpNac[6] + T-CcbCCaja.ImpUsa[6] = 0) 
                THEN DO:
                RUN ccb/p-ctrl-fac-adel ( ROWID(Ccbcdocu), "C" ).
                IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
            END.
        END.
    END.
    
    /* Trazabilidad */  
    RUN trazabilidad(OUTPUT x-msg).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    
    /* Registra el ingreso a Caja */
    RUN Ingreso-a-Caja.
    
    /* Genera Cheque */
    IF ((T-CcbCCaja.Voucher[2] <> "" ) AND
        (T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2]) > 0 ) OR
        ((T-CcbCCaja.Voucher[3] <> "" ) AND
        (T-CcbCCaja.ImpNac[3] + T-CcbCCaja.ImpUsa[3]) > 0) THEN
        RUN Genera-Cheque.

    /* Actualiza la Boleta de Deposito */
    IF T-CcbCCaja.Voucher[5] <> "" AND
        (T-CcbCCaja.ImpNac[5] + T-CcbCCaja.ImpUsa[5]) > 0 THEN DO:

        DEFINE VAR x-es-vta-whatsapp AS LOG INIT NO.

        /* Ic - 04Feb2021, documentos de pago - WhatsApp */
        FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                x-vtatabla.tabla = "CONFIG-VTAS" AND
                                x-vtatabla.llave_c1 = "DOC.DE.PAGOS" AND
                                x-vtatabla.llave_c2 = "DIVISION.DOC" AND 
                                x-vtatabla.llave_c3 = s-coddiv NO-LOCK:

            IF TRIM(T-CcbCCaja.CodBco[5]) = TRIM(x-vtatabla.llave_c4) THEN DO:
                x-es-vta-whatsapp = YES.
            END.
        END.

        IF x-es-vta-whatsapp = NO /* T-CcbCCaja.CodBco[5] = "BD" */ THEN DO:
            RUN proc_AplicaDoc(
                "BD",
                T-CcbCCaja.Voucher[5],
                ccbccaja.nrodoc,
                T-CcbCCaja.tpocmb,
                T-CcbCCaja.ImpNac[5],
                T-CcbCCaja.ImpUsa[5]
                ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.

    END.
    
    /* Aplica Nota de Credito */
    IF CAN-FIND(FIRST wrk_dcaja) THEN DO:
        FOR EACH wrk_dcaja NO-LOCK,
                FIRST CcbCDocu WHERE CcbCDocu.CodCia = wrk_dcaja.CodCia
                AND CcbCDocu.CodCli = wrk_dcaja.CodCli
                AND CcbCDocu.CodDoc = wrk_dcaja.CodRef
                AND CcbCDocu.NroDoc = wrk_dcaja.NroRef NO-LOCK:
            RUN proc_AplicaDoc(
                CcbCDocu.CodDoc,
                CcbCDocu.NroDoc,
                ccbccaja.nrodoc,
                T-CcbCCaja.tpocmb,
                IF CcbCDocu.CodMon = 1 THEN wrk_dcaja.Imptot ELSE 0,
                IF CcbCDocu.CodMon = 2 THEN wrk_dcaja.Imptot ELSE 0
                ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    
    /* Aplica Anticipo Recibido A/R o LPA */
    IF T-CcbCCaja.Voucher[7] <> "" AND
        (T-CcbCCaja.ImpNac[7] + T-CcbCCaja.ImpUsa[7]) > 0 THEN DO:
        RUN proc_AplicaDoc(
            /*"A/R",*/
            T-CcbCCaja.CodBco[7],
            T-CcbCCaja.Voucher[7],
            ccbccaja.nrodoc,
            T-CcbCCaja.tpocmb,
            T-CcbCCaja.ImpNac[7],
            T-CcbCCaja.ImpUsa[7]
            ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    
    /* Retenciones */
    IF CAN-FIND(FIRST wrk_ret) THEN DO:
        FOR EACH wrk_ret:
            wrk_ret.NroRef = ccbccaja.nrodoc.
        END.
        RUN proc_CreaRetencion.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    
    /* Actualiza Control de Vales de Compras */
    FOR EACH T-VVALE:
        CREATE VtaVVale.
        BUFFER-COPY T-VVALE TO VtaVVale
        ASSIGN
            VtaVVale.CodCia = s-codcia
            VtaVVale.CodDiv = s-coddiv
            VtaVVale.CodRef = ccbccaja.coddoc
            VtaVVale.NroRef = ccbccaja.nrodoc
            VtaVVale.Fecha = TODAY
            VtaVVale.Hora = STRING(TIME,'HH:MM').
    END.
    
    /* COMPROBANTES DE PERCEPCION */
/*     RUN vta2/genera-comprobante-percepcion ( ROWID(Ccbccaja) ).  */
/*     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */

    /* Code placed here will execute AFTER standard behavior.    */
    RUN Cambia-Pantalla IN lh_handle (INPUT 1).
    RUN dispatch IN THIS-PROCEDURE ('imprime':U).

    IF AVAILABLE(B-CDocu) THEN RELEASE B-CDocu.
    IF AVAILABLE(Ccbdmov) THEN RELEASE Ccbdmov.
    IF AVAILABLE(Vtavvale) THEN RELEASE Vtavvale.
    IF AVAILABLE(Ccbcdocu) THEN RELEASE ccbcdocu.
    IF AVAILABLE(Ccbdcaja) THEN RELEASE Ccbdcaja.

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
    FIND FacCorre WHERE
        FacCorre.CodCia = s-codcia AND
        FacCorre.CodDoc = s-coddoc AND
        FacCorre.NroSer = s-ptovta
        EXCLUSIVE-LOCK.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN
        CcbCCaja.CodCia     = s-codcia
        CcbCCaja.CodDoc     = s-coddoc
        CcbCCaja.NroDoc     = STRING(faccorre.nroser, "999") +
            STRING(faccorre.correlativo, "999999")
        CcbcCaja.CodDiv     = S-CODDIV
        CcbCCaja.Tipo       = s-tipo
        CcbCCaja.usuario    = s-user-id
        CcbCCaja.CodCaja    = S-CODTER
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
    DEFINE BUFFER b_dmov FOR CCBDMOV.

    IF ccbccaja.flgcie NE "P" THEN DO:
        MESSAGE
            "Ya se hizo el cierre de caja"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF ccbccaja.flgest = "A" THEN DO:
        MESSAGE
            "Registro ya fue Anulado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    /* Verifica Cheque Aceptado */
    IF ((CcbCCaja.Voucher[2] <> "" ) AND
        (CcbCCaja.ImpNac[2] + CcbCCaja.ImpUsa[2]) > 0 ) OR
        ((CcbCCaja.Voucher[3] <> "" ) AND
        (CcbCCaja.ImpNac[3] + CcbCCaja.ImpUsa[3]) > 0) THEN DO:

        IF CcbCCaja.Voucher[2] <> "" THEN X-NUMDOC = CcbCCaja.Voucher[2].
        IF CcbCCaja.Voucher[3] <> "" THEN X-NUMDOC = CcbCCaja.Voucher[3].       

        FIND FIRST CcbCDocu WHERE 
            CcbCDocu.CodCia = S-CodCia AND
            CcbCDocu.CodDoc = "CHC" AND
            CcbCDocu.NroDoc = X-NUMDOC
            NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu AND CcbCDocu.FlgEst = "C" THEN DO:
            MESSAGE
                "Ingreso con Cheque Aceptado,"
                "No es posible Anular la Operacion"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.

    END.

    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}

    /* Actualiza la cuenta corriente */
    RLOOP:
    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Extornamos PERCEPCIONES */
        RUN vta2/anula-comprobante-percepcion ( ROWID(Ccbccaja) ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

        /* Extorna Saldo de documentos */
        FOR EACH ccbdcaja OF ccbccaja:
            FIND FIRST ccbcdocu WHERE
                ccbcdocu.codcia = s-codcia AND
                ccbcdocu.codcli = CcbCCaja.Codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME} AND
                ccbcdocu.coddoc = ccbdcaja.codref AND
                ccbcdocu.nrodoc = ccbdcaja.nroref
                EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN
                ccbcdocu.sdoact = ccbcdocu.sdoact + ccbdcaja.imptot
                ccbcdocu.fchcan = ?
                ccbcdocu.flgest = "P".
            /* ********************************************** */
            /* RHC 14.12.2010 Control de Facturas Adelantadas */
            RUN ccb/p-ctrl-fac-adel ( ROWID(Ccbcdocu), "D" ).            
            /* ********************************************** */
            /* RHC 23/05/2019 Extornamos aplicacion de DCO */
            /* ******************************************* */
            RUN Extorna-Cierre-DCO.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
            /* ******************************************* */
            RELEASE ccbcdocu.
            DELETE ccbdcaja.
        END.

        /* EXTORNOS DE CANCELACIONES */
        /* Cheque */
        IF ((CcbCCaja.Voucher[2] <> "" ) AND
            (CcbCCaja.ImpNac[2] + CcbCCaja.ImpUsa[2]) > 0 ) OR
            ((CcbCCaja.Voucher[3] <> "" ) AND
            (CcbCCaja.ImpNac[3] + CcbCCaja.ImpUsa[3]) > 0) THEN DO:
            RUN Anula-Cheque.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.

        /* Elimina Detalle de la Aplicación para N/C y A/R y BD */
        FOR EACH CCBDMOV WHERE
            CCBDMOV.CodCia = ccbccaja.CodCia AND
            CCBDMOV.CodDiv = ccbccaja.CodDiv AND
            CCBDMOV.CodRef = ccbccaja.coddoc AND
            CCBDMOV.NroRef = ccbccaja.nrodoc:
            /* Tipo de Documento */
            FIND FacDoc WHERE
                FacDoc.CodCia = CCBDMOV.CodCia AND
                FacDoc.CodDoc = CCBDMOV.CodDoc
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE FacDoc THEN DO:
                MESSAGE
                    "DOCUMENTO" CCBDMOV.CodDoc 'NO CONFIGURADO'
                    VIEW-AS ALERT-BOX ERROR.
                UNDO, RETURN "ADM-ERROR".
            END.
            FIND FIRST CcbCDocu WHERE
                CcbCDocu.codcia = CCBDMOV.CodCia AND
                CcbCDocu.coddoc = CCBDMOV.CodDoc AND
                CcbCDocu.nrodoc = CCBDMOV.NroDoc EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE ccbcdocu THEN DO:
                MESSAGE
                    "DOCUMENTO" CCBDMOV.CodDoc CCBDMOV.NroDoc "NO REGISTRADO"
                    VIEW-AS ALERT-BOX ERROR.
                UNDO, RETURN "ADM-ERROR".
            END.
            IF FacDoc.TpoDoc THEN
                ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct - CCBDMOV.Imptot.
            ELSE
                ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct + CCBDMOV.Imptot.
            /* Cancela Documento */
            IF CcbCDocu.SdoAct <> 0 THEN
                ASSIGN
                    CcbCDocu.FlgEst = "P"
                    CcbCDocu.FchCan = ?.
            RELEASE CcbCDocu.
            DELETE CCBDMOV.
        END.

        /* Extorna Retencion */
        FOR EACH CcbCMov WHERE
            CCBCMOV.CodCia = CcbCCaja.CodCia AND
            CCBCMOV.CodRef = CcbCCaja.CodDoc AND
            CCBCMOV.NroRef = CcbCCaja.NroDoc:
            DELETE CcbCMov.
        END.

        /* Anula Ingreso de Caja */
        FIND b-ccbccaja WHERE
            ROWID(b-ccbccaja) = ROWID(ccbccaja)
            EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN 
            b-ccbccaja.flgest = "A"
            b-ccbccaja.usranu = s-user-id
            b-ccbccaja.fchanu = TODAY
            b-ccbccaja.horanu = STRING(TIME, 'HH:MM:SS').
        RELEASE b-ccbccaja.
    END. /* DO TRANSACTION... */

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

    IF AVAILABLE ccbccaja THEN DO WITH FRAME {&FRAME-NAME}:
        FIND gn-clie WHERE
            gn-clie.codcia = cl-codcia AND
            gn-clie.codcli = ccbccaja.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie AND gn-clie.codcli <> "11111111" THEN 
            DISPLAY
                gn-clie.nomcli @ CcbcCaja.Nomcli
                gn-clie.ruc @ FILL-IN_Ruc.
        CASE ccbccaja.flgest:
            WHEN "A" THEN X-Status:SCREEN-VALUE = "ANULADO".
            OTHERWISE X-Status:SCREEN-VALUE = "EMITIDO".
        END CASE.
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

    RUN CCB\r-recibo3 (ROWID(CcbcCaja)).

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
    DEFINE VARIABLE monto_ret AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dTpoCmb LIKE CcbcCaja.TpoCmb NO-UNDO.

    RUN valida.
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

    ASSIGN
        X-ImpNac = 0
        X-ImpUsa = 0
        X-Importe = 0.

    FOR EACH T-CcbDCaja:
        IF LOOKUP(T-CcbDCaja.CodRef, "N/C") > 0 THEN
            x-importe = x-importe - t-ccbdcaja.imptot.
        ELSE
            x-importe = x-importe + t-ccbdcaja.imptot.
    END.

    /* Retenciones */
    EMPTY TEMP-TABLE wrk_ret.
    /* N/C */
    EMPTY TEMP-TABLE wrk_dcaja.
    /* RHC 19/12/2015 Bloqueado a solicitud de Susana Leon 
    IF x-importe > 0 THEN DO WITH FRAME {&FRAME-NAME}:
        FIND gn-clie WHERE
            gn-clie.codcia = cl-codcia AND
            gn-clie.codcli = ccbccaja.codcli:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie AND gn-clie.rucold = "Si" THEN DO:
            dTpoCmb = 1.
            FOR EACH t-CcbDCaja NO-LOCK:
                /* Solo Facturas */
                IF LOOKUP(T-CcbDCaja.CodRef,"FAC,N/D") = 0 THEN NEXT.
                /* Verifica si Documento ya tiene
                   aplicada la retencion */
                /*ML01* Inhibe la consistencia ***
                FIND FIRST CcbCmov WHERE
                    CCBCMOV.CodCia = s-CodCia AND
                    CCBCMOV.CodDoc = T-CcbDCaja.CodRef AND
                    CCBCMOV.NroDoc = T-CcbDCaja.NroRef
                    NO-LOCK NO-ERROR.
                IF AVAILABLE CCBCMOV THEN NEXT.
                *ML01* Inhibe la consistencia ***/
                /* Busca Documento */
                FIND FIRST ccbcdocu WHERE
                    ccbcdocu.codcia = s-codcia AND
                    ccbcdocu.coddoc = T-CcbDCaja.CodRef AND
                    ccbcdocu.nrodoc = T-CcbDCaja.NroRef
                    USE-INDEX LLAVE01 NO-LOCK NO-ERROR.
                IF AVAILABLE ccbcdocu THEN DO:
                    /* Tipo de Cambio Caja */
                    IF dTpoCmb = 1 THEN DO:
                        FIND LAST Gn-tccja WHERE Gn-tccja.fecha <= TODAY NO-LOCK NO-ERROR.
                        IF AVAILABLE Gn-tccja THEN DO:
                            IF ccbcdocu.Codmon = 1 THEN dTpoCmb = Gn-tccja.Compra.
                            ELSE dTpoCmb = Gn-tccja.Venta.
                        END.
                    END.
                    CREATE wrk_ret.
                    ASSIGN
                        wrk_ret.CodCia = ccbcdocu.codcia
                        wrk_ret.CodCli = ccbcdocu.codcli
                        wrk_ret.CodDoc = ccbcdocu.coddoc
                        wrk_ret.NroDoc = ccbcdocu.nrodoc
                        wrk_ret.FchDoc = ccbcdocu.fchdoc
                        wrk_ret.CodRef = s-coddoc
                        wrk_ret.NroRef = INPUT CcbCCaja.nrodoc
                        wrk_ret.CodMon = "S/.".
                    /* OJO: Cálculo de Retenciones Siempre en Soles */
                    IF T-CcbDCaja.CodDoc = "S/." THEN DO:
                        /*ML01* Captura el Saldo ***
                        wrk_ret.ImpTot = ccbcdocu.ImpTot *
                        *ML01* ***/
                        /*ML01*/                wrk_ret.ImpTot = ccbcdocu.SdoAct *
                            IF ccbcdocu.coddoc = "N/C" THEN -1 ELSE 1.
                        wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
                    END.
                    ELSE DO:
                        /*ML01* Captura el Saldo ***
                        wrk_ret.ImpTot = ROUND((ccbcdocu.ImpTot * dTpoCmb),2) *
                        *ML01* ***/
                        /*ML01*/                wrk_ret.ImpTot = ROUND((ccbcdocu.SdoAct * dTpoCmb),2) *
                            IF ccbcdocu.coddoc = "N/C" THEN -1 ELSE 1.
                        wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
                    END.
                    monto_ret = monto_ret + wrk_ret.ImpRet.
                END.
            END.
        END.
    END.
    *************************************** Fin de Bloqueo */
    /* Ventana de Cancelación */

    IF s-coddiv = '00506' THEN DO:
        RUN ccb/d-canped-02a.r(
            x-mon,
            X-Importe,
            monto_ret,
            CcbCCaja.NomCli:SCREEN-VALUE IN FRAME {&FRAME-NAME},
            /*TRUE, Posibilita el pago a tarjeta credito*/
            TRUE,
            "T",
            OUTPUT s-ok
            ).
    END.
    ELSE DO:
        RUN ccb/d-canped-02a.r(
            x-mon,
            X-Importe,
            monto_ret,
            CcbCCaja.NomCli:SCREEN-VALUE IN FRAME {&FRAME-NAME},
            /*TRUE, Posibilita el pago a tarjeta credito*/
            /*
            NO,
            "",
            */
            TRUE,
            "T",
            OUTPUT s-ok
            ).
    END.

    IF s-ok = NO THEN RETURN "ADM-ERROR".

    /* 
        Ic - 29Ene2021 - Validar si es 002 - Contado anticipado
        que el numero de BD o A/R que hayan ingresado en el PEDIDO
        sean el mismo que se esta usando en caja  t-ccbccaja
    */
    DEFINE VAR x-retmsg AS CHAR.
    
    FIND FIRST T-CCBCCAJA NO-LOCK NO-ERROR.

    IF T-CCBCCAJA.voucher[5] <> "" THEN DO:
        /* BD */        
        RUN valida-documento-anticipo(INPUT 'BD', INPUT T-CCBCCAJA.voucher[5], OUTPUT x-retmsg).
        IF x-retmsg <> "OK" THEN DO:
            MESSAGE x-retmsg
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.    
    IF T-CCBCCAJA.voucher[7] <> "" THEN DO:
        /* A/R o LPA */
        
        RUN valida-documento-anticipo(INPUT T-CCBCCAJA.codbco[7], INPUT T-CCBCCAJA.voucher[7], OUTPUT x-retmsg).
        IF x-retmsg <> "OK" THEN DO:
            MESSAGE x-retmsg
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.
    
    /* RHC 14/11/16 Verificamos si se ha cancelado con NCI */
    FIND FIRST wrk_dcaja WHERE wrk_dcaja.codref = "NCI" NO-LOCK NO-ERROR.
    IF AVAILABLE wrk_dcaja THEN DO:
        IF CAN-FIND(FIRST wrk_dcaja WHERE wrk_dcaja.codref <> "NCI" NO-LOCK)
            THEN DO:
            MESSAGE 'NO se pueden aplicar NCI con N/C en la misma liquidación'
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        IF NOT CAN-FIND(FIRST T-Ccbdcaja WHERE T-Ccbdcaja.codref = "FAI" NO-LOCK)
            THEN DO:
            MESSAGE "Las NCI's solo se pueden aplicar a FAI's" VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.
    /* *************************************************** */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Documentos V-table-Win 
PROCEDURE Procesa-Documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR I AS INTEGER.

    input-var-1 = "P,J".
    input-var-2 = S-CODCLI.
    input-var-3 = "FAC,BOL,N/D,CHQ,DCO,LET".  /* Solo letras en cartera */

    RUN lkup\C-doctip-03a.r ("Documentos Pendientes").   /* TODAS LAS DIVISIONES */

    IF output-var-1 = ? THEN RETURN ERROR.

    EMPTY TEMP-TABLE T-CcbdCaja.
    DO i = 1 TO NUM-ENTRIES(output-var-2) WITH FRAME {&FRAME-NAME}:
         /* Solo acepta documentos de Cargo */
        FIND FIRST facdocum WHERE
            FacDocum.CodCia = s-codcia AND
            FacDocum.CodDoc = SUBSTRING(ENTRY(I,output-var-2),1,3)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE facdocum OR NOT FacDocum.TpoDoc THEN DO:
            MESSAGE
                "El documento seleccionado" SUBSTRING(ENTRY(I,output-var-2),1,3)
                SUBSTRING(ENTRY(I,output-var-2),4)
                "no es un documento de cargo"
                VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.

        FIND ccbcdocu WHERE
            ccbcdocu.codcia = s-codcia AND
            ccbcdocu.codcli = CcbCCaja.Codcli:SCREEN-VALUE AND
            ccbcdocu.coddoc = SUBSTRING(ENTRY(I,output-var-2),1,3) AND
            ccbcdocu.nrodoc = SUBSTRING(ENTRY(I,output-var-2),4) 
            USE-INDEX LLAVE01 NO-LOCK NO-ERROR.
        /* LETRAS N BANCO */
        IF Ccbcdocu.coddoc = 'LET' AND Ccbcdocu.flgubi <> 'C' THEN DO:
            MESSAGE 'La letra' ccbcdocu.nrodoc 'NO está en CARTERA' VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        IF Ccbcdocu.SdoAct <= 0 THEN NEXT.  /* Parche */

        /* RHC 13/07/2017 FAC VENTA ANTICIPADA */
        IF LOOKUP(Ccbcdocu.coddoc,"FAC,BOL") > 0 AND Ccbcdocu.tpofac = "V" THEN NEXT.

        CREATE T-CCBDCAJA.
        ASSIGN
           T-CcbDCaja.CodCia = S-CODCIA
           T-CcbDCaja.CodCli = Ccbcdocu.Codcli           
           T-CcbDCaja.NroRef = Ccbcdocu.NroDoc
           T-CcbDCaja.CodRef = Ccbcdocu.CodDoc
           T-CcbDCaja.CodMon = ccbcdocu.codmon
           T-CcbDcaja.imptot = ccbcdocu.sdoact
           /* Solo para Desplegar Moneda en BROWSE,
              no tiene otro efecto secundario */
           T-CcbDcaja.coddoc = IF ccbcdocu.codmon = 1 THEN "S/." ELSE "US$".

        RELEASE T-CCBDCAJA.

    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AnulaBD V-table-Win 
PROCEDURE proc_AnulaBD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_NroDoc LIKE CCBDMOV.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CCBDMOV.NroDoc.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CCBDMOV.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CCBDMOV.ImpTot.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':

        FIND ccbboldep WHERE
            ccbboldep.CodCia = s-CodCia AND
            ccbboldep.CodDoc = "BD" AND
            ccbboldep.nrodoc = para_NroDoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE CcbBolDep THEN DO:
            MESSAGE
                "BOLETA DE DEPOSITO" para_NroDoc "NO EXISTE"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.

        /* Elimina Detalle de la Aplicación */
        FOR EACH CCBDMOV WHERE
            CCBDMOV.CodCia = s-CodCia AND
            CCBDMOV.CodDiv = s-CodDiv AND
            CCBDMOV.NroDoc = ccbboldep.NroDoc AND
            CCBDMOV.CodDoc = ccbboldep.CodDoc
            EXCLUSIVE-LOCK:
            /* Referencia I/C */
            IF CCBDMOV.CodRef = s-coddoc AND
                CCBDMOV.NroRef = para_NroDocCja THEN
                DELETE CCBDMOV.
        END.

        IF CcbBolDep.CodMon = 1 THEN
            ASSIGN CcbBolDep.SdoAct = CcbBolDep.SdoAct + para_ImpNac.
        ELSE
            ASSIGN CcbBolDep.SdoAct = CcbBolDep.SdoAct + para_ImpUSA.

        IF CcbBolDep.SdoAct > 0 THEN
            ASSIGN
                CcbBolDep.FchCan = ?
                CcbBolDep.FlgEst = "p".

        RELEASE ccbboldep.

    END. /* DO TRANSACTION... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AnulaDoc V-table-Win 
PROCEDURE proc_AnulaDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_CodDoc LIKE CcbCDocu.CodDoc.
    DEFINE INPUT PARAMETER para_NroDoc LIKE CcbDMov.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CcbDMov.NroDoc.    
    DEFINE INPUT PARAMETER para_ImpNac LIKE CcbDMov.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CcbDMov.ImpTot.

    DEFINE VARIABLE x-Monto LIKE ccbcdocu.ImpTot.

    /* Tipo de Documento */
    FIND FacDoc WHERE
        FacDoc.CodCia = s-CodCia AND
        FacDoc.CodDoc = para_CodDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDoc THEN DO:
        MESSAGE
            para_CodDoc 'NO CONFIGURADO'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':

        FIND FIRST ccbcdocu WHERE
            ccbcdocu.codcia = s-codcia AND
            ccbcdocu.coddoc = para_CodDoc AND
            ccbcdocu.nrodoc = para_NroDoc
            EXCLUSIVE-LOCK.

        IF NOT AVAILABLE ccbcdocu THEN DO:
            MESSAGE
                "DOCUMENTO" para_CodDoc para_NroDoc "NO REGISTRADO"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.

        /* Elimina Detalle de la Aplicación */
        FOR EACH CCBDMOV WHERE
            CCBDMOV.CodCia = s-CodCia AND
            CCBDMOV.CodDiv = s-CodDiv AND
            CCBDMOV.NroDoc = ccbcdocu.NroDoc AND
            CCBDMOV.CodDoc = ccbcdocu.CodDoc
            EXCLUSIVE-LOCK:
            /* Referencia I/C */
            IF CCBDMOV.CodRef = s-coddoc AND
                CCBDMOV.NroRef = para_NroDocCja THEN
                DELETE CCBDMOV.
        END.

        IF CcbCDocu.CodMon = 1 THEN ASSIGN x-Monto = para_ImpNac.
        ELSE ASSIGN x-Monto = para_ImpUSA.

        IF FacDoc.TpoDoc THEN
            ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct - x-Monto.
        ELSE
            ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct + x-Monto.

        /* Cancela Documento */
        IF CcbCDocu.SdoAct <> 0 THEN
            ASSIGN
                CcbCDocu.FlgEst = "P"
                CcbCDocu.FchCan = ?.
        RELEASE CcbCDocu.

    END. /* DO TRANSACTION... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaBD V-table-Win 
PROCEDURE proc_AplicaBD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_NroDoc LIKE CCBDMOV.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CCBDMOV.NroDoc.
    DEFINE INPUT PARAMETER para_TpoCmb LIKE CcbCDocu.tpocmb.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CCBDMOV.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CCBDMOV.ImpTot.
    DEFINE INPUT PARAMETER para_CodBco LIKE CCBDMOV.CodBco.

    /* Tipo de Documento */
    FIND FacDoc WHERE
        FacDoc.CodCia = s-CodCia AND
        FacDoc.CodDoc = "BD"
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDoc THEN DO:
        MESSAGE
           'BOLETA DE DEPOSITO NO CONFIGURADO'
                VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':

        FIND ccbboldep WHERE
            ccbboldep.CodCia = s-CodCia AND
            ccbboldep.CodDoc = "BD" AND
            ccbboldep.nrodoc = para_NroDoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE CcbBolDep THEN DO:
            MESSAGE
                "BOLETA DE DEPOSITO" para_NroDoc "NO EXISTE"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.

        /* Crea Detalle de la Aplicación */
        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = s-CodCia
            CCBDMOV.CodDiv = s-CodDiv
            CCBDMOV.NroDoc = ccbboldep.NroDoc
            CCBDMOV.CodDoc = ccbboldep.CodDoc
            CCBDMOV.CodMon = ccbboldep.CodMon
            CCBDMOV.CodRef = s-coddoc
            CCBDMOV.NroRef = para_NroDocCja
            CCBDMOV.CodCli = ccbboldep.CodCli
            CCBDMOV.FchDoc = ccbboldep.FchDoc
            CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBDMOV.TpoCmb = para_tpocmb
            CCBDMOV.CodBco = para_CodBco
            CCBDMOV.usuario = s-User-ID.

        IF ccbboldep.CodMon = 1 THEN
            ASSIGN CCBDMOV.ImpTot = para_ImpNac.
        ELSE ASSIGN CCBDMOV.ImpTot = para_ImpUSA.

        ASSIGN CcbBolDep.SdoAct = CcbBolDep.SdoAct - CCBDMOV.ImpTot.

        IF CcbBolDep.SdoAct <= 0 THEN
            ASSIGN
                CcbBolDep.FchCan = TODAY
                CcbBolDep.FlgEst = "C".

    END. /* DO TRANSACTION... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaDoc V-table-Win 
PROCEDURE proc_AplicaDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_CodDoc LIKE CcbCDocu.CodDoc.
    DEFINE INPUT PARAMETER para_NroDoc LIKE CcbDMov.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CcbDMov.NroDoc.    
    DEFINE INPUT PARAMETER para_TpoCmb LIKE CCBDMOV.TpoCmb.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CcbDMov.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CcbDMov.ImpTot.

    DEFINE BUFFER B-CDocu FOR CcbCDocu.

    /* Tipo de Documento */
    FIND FIRST FacDoc WHERE
        FacDoc.CodCia = s-CodCia AND
        FacDoc.CodDoc = para_CodDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDoc THEN DO:
        MESSAGE
            para_CodDoc 'NO CONFIGURADO'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Busca Documento */
        FIND FIRST B-CDocu WHERE
            B-CDocu.CodCia = s-codcia AND
            B-CDocu.CodDoc = para_CodDoc AND
            B-CDocu.NroDoc = para_NroDoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CDocu THEN DO:
            MESSAGE
                "DOCUMENTO" para_CodDoc para_NroDoc "NO REGISTRADO"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
        /* Crea Detalle de la Aplicación */
        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = s-CodCia
            CCBDMOV.CodDiv = s-CodDiv
            CCBDMOV.NroDoc = B-CDocu.NroDoc
            CCBDMOV.CodDoc = B-CDocu.CodDoc
            CCBDMOV.CodMon = B-CDocu.CodMon
            CCBDMOV.CodRef = s-CodDoc
            CCBDMOV.NroRef = para_NroDocCja
            CCBDMOV.CodCli = B-CDocu.CodCli
            CCBDMOV.FchDoc = B-CDocu.FchDoc
            CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBDMOV.TpoCmb = para_tpocmb
            CCBDMOV.usuario = s-User-ID.
        IF B-CDocu.CodMon = 1 THEN
            ASSIGN CCBDMOV.ImpTot = para_ImpNac.
        ELSE ASSIGN CCBDMOV.ImpTot = para_ImpUSA.
        IF FacDoc.TpoDoc THEN
            ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct + CCBDMOV.ImpTot.
        ELSE
            ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct - CCBDMOV.ImpTot.
        /* Cancela Documento */
        IF B-CDocu.SdoAct = 0 THEN
            ASSIGN 
                B-CDocu.FlgEst = "C"
                B-CDocu.FchCan = TODAY.
        ELSE
            ASSIGN
                B-CDocu.FlgEst = "P"
                B-CDocu.FchCan = ?.
        /* RHC 26/08/2015 Chequeo adicional */
        IF B-CDOCU.SdoAct < 0 THEN DO:
            MESSAGE 'ERROR (' + T-CcbCCaja.CodBco[5] + ') en el saldo del documento:' B-CDocu.coddoc B-CDocu.nrodoc SKIP
                'Proceso Abortado'
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        /* ******************************** */
/*         RELEASE B-CDocu. */
/*         RELEASE Ccbdmov. */
    END. /* DO TRANSACTION... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaRetencion V-table-Win 
PROCEDURE proc_CreaRetencion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FOR EACH wrk_ret NO-LOCK:
/*ML01* ***
            FIND FIRST CcbCmov WHERE
                CCBCMOV.CodCia = wrk_ret.CodCia AND
                CCBCMOV.CodDoc = wrk_ret.CodDoc AND
                CCBCMOV.NroDoc = wrk_ret.NroDoc
                NO-LOCK NO-ERROR.
            IF AVAILABLE CCBCMOV THEN DO:
                MESSAGE
                    "YA EXISTE RETENCION PARA DOCUMENTO"
                    CCBCMOV.CodDoc CCBCMOV.NroDoc SKIP
                    "CREADO POR:" CCBCMOV.usuario SKIP
                    "FECHA:" CCBCMOV.FchMov SKIP
                    "HORA:" CCBCMOV.HraMov
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
*ML01* ***/
/*ML01*/ FIND CcbCmov WHERE
                CCBCMOV.CodCia = wrk_ret.CodCia AND
                CCBCMOV.CodDiv = s-CodDiv AND
                CCBCMOV.CodDoc = wrk_ret.CodDoc AND
                CCBCMOV.NroDoc = wrk_ret.NroDoc
                NO-ERROR.
            IF NOT AVAILABLE CCBCMOV THEN DO:
            CREATE CCBCMOV.
            ASSIGN
                CCBCMOV.CodCia = wrk_ret.CodCia
                CCBCMOV.CodDoc = wrk_ret.CodDoc
                CCBCMOV.NroDoc = wrk_ret.NroDoc
                CCBCMOV.CodRef = wrk_ret.CodRef
                CCBCMOV.NroRef = wrk_ret.NroRef
                CCBCMOV.CodCli = wrk_ret.CodCli
                CCBCMOV.CodDiv = s-CodDiv
                CCBCMOV.CodMon = 1                  /* Ojo!!! Siempre en Soles */
/*ML03*/        .
/*ML01*/    END.
/*ML01*/    ASSIGN
                CCBCMOV.TpoCmb = s-tpocmb
                CCBCMOV.FchDoc = wrk_ret.FchDoc
                CCBCMOV.ImpTot = wrk_ret.ImpTot
                CCBCMOV.DocRef = wrk_ret.NroRet     /* Comprobante */
                CCBCMOV.FchRef = wrk_ret.FchRet     /* Fecha */
/*ML01* ***
                CCBCMOV.ImpRef = wrk_ret.ImpRet     /* Importe */
*ML01* ***/
/*ML01*/        CCBCMOV.ImpRef = CCBCMOV.ImpRef + wrk_ret.ImpRet     /* Importe */
                CCBCMOV.FchMov = TODAY
                CCBCMOV.HraMov = STRING(TIME,"HH:MM:SS")
                CCBCMOV.usuario = s-User-ID.
            DO WITH FRAME {&FRAME-NAME}:
                CCBCMOV.chr__01 = CcbCCaja.NomCli:SCREEN-VALUE.
            END.
            RELEASE Ccbcmov.
        END.
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trazabilidad V-table-Win 
PROCEDURE trazabilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */

RUN ccb\libreria-ccb.r PERSISTENT SET hProc.

RUN trazabilidad-inicial IN hProc (INPUT ccbccaja.coddoc, 
                                   INPUT ccbccaja.nrodoc, 
                                   OUTPUT pRetVal).

DELETE PROCEDURE hProc.                 /* Release Libreria */

IF pRetVal <> "OK" THEN DO:
    RETURN "ADM-ERROR".
END.
ELSE DO:
    pRetVal = "".
    RETURN "OK".
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
       /* SOLO OPENORANGE */
       DEF VAR pClienteOpenOrange AS LOG NO-UNDO.
       RUN gn/clienteopenorange (cl-codcia, CcbCCaja.CodCli:SCREEN-VALUE, s-CodDoc, OUTPUT pClienteOpenOrange).
       IF pClienteOpenOrange = YES THEN DO:
           MESSAGE "Cliente NO se puede antender por Continental" SKIP
               "Solo se le puede antender por OpenOrange"
               VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO CcbCCaja.CodCli.
           RETURN "ADM-ERROR".   
       END.

       x-mon = T-CcbDCaja.CodMon.
       FOR EACH T-CcbDCaja:
           IF x-mon <> T-CcbDCaja.CodMon THEN DO:
              MESSAGE "Documentos a cancelar con diferente moneda" VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".         
           END.
       END.

       /* NO se puede mezclar FAI con otros documentos */
       DEF VAR k AS INT NO-UNDO.
       DEF VAR j AS INT NO-UNDO.
       k = 0.
       j = 0.
       FOR EACH T-Ccbdcaja:
           k = k + 1.
           IF T-Ccbdcaja.codref = "FAI" THEN j = j + 1.
       END.
       IF j > 0 AND j <> k THEN DO:
           MESSAGE "NO se pueden cancelar FAI's con otros comprobantes" VIEW-AS ALERT-BOX ERROR.
               RETURN 'ADM-ERROR'.
       END.
       /* RHC 12/04/17 Verificar duplicidad de comprobantes */
       EMPTY TEMP-TABLE TT-CcbDCaja.
       FOR EACH T-Ccbdcaja:
           FIND FIRST TT-CcbDCaja WHERE TT-CcbDCaja.codref = T-CcbDCaja.codref
               AND TT-CcbDCaja.nroref = T-CcbDCaja.nroref
               NO-LOCK NO-ERROR.
           IF AVAILABLE TT-CcbDCaja THEN DO:
               MESSAGE 'ERROR: Se ha encontrado duplicado el comprobante' T-CcbDCaja.codref T-CcbDCaja.nroref SKIP
                   'Se procede a eliminarlo del registro' SKIP
                   'Revise nuevamente su información'
                   VIEW-AS ALERT-BOX ERROR.
               DELETE T-CcbDCaja.
               RUN Procesa-Handle IN lh_handle ('Pinta-Detalle').
               RETURN 'ADM-ERROR'.
           END.
           CREATE TT-CcbDCaja.
           BUFFER-COPY T-CcbDCaja TO TT-CcbDCaja.
       END.
       /* RHC 05/06/2017 Verificar si no está en trámite de CANJE x Letra */
       FOR EACH T-Ccbdcaja NO-LOCK:
           FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = T-CcbDCaja.CodCia
               AND CcbCDocu.CodDoc = T-CcbDCaja.CodRef
               AND CcbCDocu.NroDoc = T-CcbDCaja.NroRef NO-LOCK NO-ERROR.
           IF AVAILABLE CcbCDocu AND Ccbcdocu.flgsit <> 'X' THEN DO:
               FOR EACH Ccbcmvto NO-LOCK WHERE Ccbcmvto.codcia = T-CcbDCaja.CodCia
                   AND Ccbcmvto.codcli = T-CcbDCaja.CodCli
                   AND LOOKUP(Ccbcmvto.coddoc, 'CJE,CLA,REF,RNV') > 0
                   AND Ccbcmvto.flgest = 'P':
                   FIND FIRST CcbDMvto WHERE CcbDMvto.CodCia = Ccbcmvto.codcia
                       AND CcbDMvto.CodDoc = Ccbcmvto.coddoc
                       AND CcbDMvto.NroDoc = Ccbcmvto.nrodoc
                       AND CcbDMvto.TpoRef = "O"
                       AND CcbDMvto.CodRef = T-CcbDCaja.CodRef
                       AND CcbDMvto.NroRef = T-CcbDCaja.NroRef
                       NO-LOCK NO-ERROR.
                   IF AVAILABLE CcbDMvto THEN DO:
                       MESSAGE 'Se ha encontrado un comprobante con un canje POR APROBAR' SKIP
                           'Comprobante:' T-CcbDCaja.CodRef T-CcbDCaja.NroRef SKIP
                           'Canje:' Ccbcmvto.coddoc Ccbcmvto.nrodoc
                           VIEW-AS ALERT-BOX ERROR.
                       RETURN 'ADM-ERROR'.
                   END.
               END.
           END.
       END.

       /*  Ic - 10Dic2019
           Ticket 68704, 
           Correo de Susana Leon
                   Daniel:
                       Lo que sí puede hacer en estos momentos es cerrar la funcionalidad en el sistema progress:
                       * Una nota de crédito no puede ser aplicada a una letra        
       */
       DEFINE VAR x-hay-letras AS LOG INIT NO.
       DEFINE VAR x-hay-nc AS LOG INIT NO.

       RECORRIDO:
       FOR EACH T-Ccbdcaja NO-LOCK:
           IF T-Ccbdcaja.codref = 'LET' THEN x-hay-letras = YES.
           IF (T-Ccbdcaja.codref = 'N/C' OR T-Ccbdcaja.codref = 'NCI') THEN x-hay-nc = YES.
           IF x-hay-letras = YES AND x-hay-nc = YES THEN DO:
               LEAVE RECORRIDO.
           END.
       END.
       IF s-amortiza-letras = NO AND x-hay-letras = YES AND x-hay-nc = YES THEN DO:
           MESSAGE "En una liquidacion donde se esta cancelando LETRAS, " SKIP 
                   "no esta permitido la aplicacion de NOTAS DE CREDITO"
               VIEW-AS ALERT-BOX ERROR.
           RETURN "ADM-ERROR".
       END.
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-documento-anticipo V-table-Win 
PROCEDURE valida-documento-anticipo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

DEFINE VAR x-coddoc-deposito AS CHAR.
DEFINE VAR x-nrodocdoc-deposito AS CHAR.

pRetVal = "OK".

VERIFICAR:
FOR EACH T-ccbdcaja WHERE (T-ccbdcaja.codref = "FAC" OR T-ccbdcaja.codref = "BOL") NO-LOCK:
    FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                x-ccbcdocu.coddoc = T-ccbdcaja.codref AND 
                                x-ccbcdocu.nrodoc = T-ccbdcaja.nroref NO-LOCK NO-ERROR.
    /* Si CONTADO ANTICIPADO */
    IF AVAILABLE x-ccbcdocu THEN DO:
        /* EL Pedido */
        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                    x-faccpedi.coddoc = x-ccbcdocu.codped AND
                                    x-faccpedi.nroped = x-ccbcdocu.nroped NO-LOCK NO-ERROR.
        IF x-ccbcdocu.fmapgo = '002' THEN DO:
            /*  Aqui se valida si el numero de A/R o BD digitado en el pedido logistico es
                el mismo que se esta usando en la cancelacion
            pRetVal = "El comprobante " + T-ccbdcaja.codref + " " + T-ccbdcaja.nroref + " cuya condicion de venta" + CHR(10) + CHR(13) +
                        "002 - CONTADO ANTICIPADO, no coincide con el numero digitado en el pedido logistico".
            IF AVAILABLE x-faccpedi THEN DO:
                IF x-faccpedi.libre_c03 = pNroDoc  THEN DO:
                    IF pCodDoc = 'BD' THEN DO:
                        /* Es una BD */
                        pRetVal = "OK".
                        LEAVE VERIFICAR.
                    END.
                END.
                ELSE DO:
                    IF x-faccpedi.usrchq = pCodDoc THEN DO:
                        pRetVal = "OK".
                        LEAVE VERIFICAR.
                    END.
                END.
            END.
            */
        END.
        ELSE DO:
            /* Se esta usando el campo importe de la Boleta de Deposito y el nro voucher para el numero de cotixacion ventas whatsapp*/
            IF pCodDoc = 'BD' THEN DO:
                /* WhatsApp */
                IF AVAILABLE x-faccpedi THEN DO:
                    IF (T-CCBCCAJA.CodBco[5] = 'PPE' OR T-CCBCCAJA.CodBco[5] = 'PLN') THEN DO:
                        IF T-CCBCCAJA.voucher[5] <> x-faccpedi.nroref THEN DO:
                            pRetVal = "El numero digitado en la cancelacion, no coincide con el numero de pedido comercial del comprobante".
                            LEAVE VERIFICAR.
                        END.
                    END.
                END.
            END.
        END.
    END.                                
END.

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

