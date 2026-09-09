&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF BUFFER B-CDOCU FOR ccbcdocu.

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR.

FIND B-CDOCU WHERE ROWID(B-CDOCU) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CDOCU THEN RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Se van a generar 2 N/C:
    La primera debe descargar el A/C
    La segunda son los decuentos por pronto pago 
    
*/

DEF BUFFER ANTICIPOS FOR Ccbcdocu.
DEF VAR x-Saldo-Actual AS DEC NO-UNDO.
DEF VAR x-Monto-Aplicar AS DEC NO-UNDO.
DEF VAR x-TpoCmb-Compra AS DEC INIT 1 NO-UNDO.
DEF VAR x-TpoCmb-Venta  AS DEC INIT 1 NO-UNDO.

pMensaje = ''.
RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FIND CURRENT B-CDOCU EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = 'NO se pudo bloquear el comprobante'.
        UNDO, LEAVE.
    END.
    /* Aplicamos los anticipos que encontremos por fecha */
    ASSIGN
        x-Saldo-Actual = B-CDOCU.ImpTot
        x-Monto-Aplicar = 0.
    FIND LAST gn-tcmb WHERE gn-tcmb.Fecha <= TODAY NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tcmb
        THEN ASSIGN
                x-TpoCmb-Compra = gn-tcmb.Compra
                x-TpoCmb-Venta  = gn-tcmb.Venta.
    FOR EACH ANTICIPOS EXCLUSIVE-LOCK WHERE ANTICIPOS.codcia = B-CDOCU.codcia
        AND ANTICIPOS.coddoc = "A/C"
        AND ANTICIPOS.codcli = B-CDOCU.codcli
        BY ANTICIPOS.FchDoc:
        IF B-CDOCU.CodMon = ANTICIPOS.CodMon 
            THEN x-Monto-Aplicar = MINIMUM(x-Saldo-Actual,ANTICIPOS.SdoAct).
            ELSE IF B-CDOCU.CodMon = 1 
                THEN x-Monto-Aplicar  = ROUND(MINIMUM(ANTICIPOS.SdoAct * x-TpoCmb-Compra, x-Saldo-Actual),2).
            ELSE x-Monto-Aplicar  = ROUND(MINIMUM(ANTICIPOS.SdoAct / x-TpoCmb-Venta , x-Saldo-Actual),2).
        IF x-Monto-Aplicar <= 0 THEN LEAVE.
        /* Nota de Crédito descargar A/C */
        RUN Nota-Credito-Anticipo.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la N/C x aplicación de A/C'.
            UNDO RLOOP, LEAVE.
        END.
        /* Nota de Crédito por Descuento */
        RUN Nota-Credito-Descuentos.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la N/C x aplicación de A/C'.
            UNDO RLOOP, LEAVE.
        END.
        x-Saldo-Actual = x-Saldo-Actual - x-Monto-Aplicar.
        IF x-Saldo-Actual <= 0 THEN LEAVE.
    END.
END.
IF AVAILABLE(ANTICIPOS) THEN RELEASE ANTICIPOS.

IF pMensaje <> '' THEN RETURN 'ADM-ERROR'.
ELSE RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Nota-Credito-Anticipo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Nota-Credito-Anticipo Procedure 
PROCEDURE Nota-Credito-Anticipo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-coddoc AS CHAR INIT "N/C" NO-UNDO.
DEF VAR s-nroser AS INT NO-UNDO.
DEF VAR cListItems AS CHAR NO-UNDO.
/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
DEF VAR pConcepto AS CHAR INIT '00001' NO-UNDO.
DEF VAR x-ImpMn AS DEC NO-UNDO.
DEF VAR x-ImpMe AS DEC NO-UNDO.

RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

{sunat\i-lista-series.i &CodCia=s-CodCia ~
    &CodDiv=s-CodDiv ~
    &CodDoc=s-CodDoc ~
    &FlgEst='' ~          /* En blanco si quieres solo ACTIVOS */
    &Tipo='CREDITO' ~
    &ListaSeries=cListItems ~
    }
s-NroSer = INTEGER(ENTRY(1,cListItems)).
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    {vtagn/i-faccorre-01.i &Codigo = s-CodDoc &Serie = s-NroSer}

    CREATE Ccbcdocu.
    BUFFER-COPY B-CDOCU TO Ccbcdocu
        ASSIGN
        Ccbcdocu.codcia = s-codcia
        Ccbcdocu.coddiv = s-coddiv
        Ccbcdocu.coddoc = s-CodDoc
        Ccbcdocu.nrodoc = STRING(FacCorre.nroser, ENTRY(1,x-Formato,'-')) +
                             STRING(Faccorre.correlativo, ENTRY(2,x-Formato,'-'))
        Ccbcdocu.codref = ANTICIPOS.CodRef
        Ccbcdocu.nroref = ANTICIPOS.NroRef
        Ccbcdocu.codped = ANTICIPOS.CodRef
        Ccbcdocu.nroped = ANTICIPOS.NroRef
        Ccbcdocu.cndcre = "N"
        Ccbcdocu.tpocmb = (IF B-CDOCU.codmon = 1 THEN x-TpoCmb-Compra ELSE x-TpoCmb-Venta)
        Ccbcdocu.fchdoc = TODAY
        Ccbcdocu.fchvto = ADD-INTERVAL (TODAY, 1, 'years')
        Ccbcdocu.usuario = s-user-id
        Ccbcdocu.imptot = x-Monto-Aplicar
        Ccbcdocu.sdoact = x-Monto-Aplicar
        Ccbcdocu.fchcan = TODAY
        Ccbcdocu.flgest = "P"
        Ccbcdocu.tpofac = "ADELANTO"
        Ccbcdocu.Tipo   = "CREDITO"     /* SUNAT */
        Ccbcdocu.CodCaja= "".   
    FOR EACH Ccbdcaja NO-LOCK WHERE CcbDCaja.CodCia = s-codcia
        AND CcbDCaja.CodDoc = ANTICIPOS.CodRef
        AND CcbDCaja.NroDoc = ANTICIPOS.NroRef:
        ASSIGN
            Ccbcdocu.codref = CcbDCaja.CodRef 
            Ccbcdocu.nroref = CcbDCaja.NroRef.
    END.
    FIND GN-VEN WHERE GN-VEN.codcia = s-codcia AND GN-VEN.codven = Ccbcdocu.codven NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEN THEN Ccbcdocu.cco = GN-VEN.cco.
    ASSIGN
        Faccorre.correlativo = Faccorre.correlativo + 1.
    /* Detalle */
    CREATE Ccbddocu.
    BUFFER-COPY Ccbcdocu
        TO Ccbddocu
        ASSIGN
        Ccbddocu.nroitm = 1
        Ccbddocu.codmat = pConcepto
        Ccbddocu.candes = 1
        Ccbddocu.preuni = Ccbcdocu.imptot
        Ccbddocu.implin = Ccbcdocu.imptot
        Ccbddocu.factor = 1.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia
        AND CcbTabla.Tabla = s-CodDoc
        AND CcbTabla.Codigo = Ccbddocu.codmat NO-LOCK.
    IF CcbTabla.Afecto THEN
        ASSIGN
            Ccbddocu.AftIgv = Yes
            Ccbddocu.ImpIgv = Ccbddocu.implin * ((Ccbcdocu.PorIgv / 100) / (1 + (Ccbcdocu.PorIgv / 100))).
    ELSE
        ASSIGN
            Ccbddocu.AftIgv = No
            Ccbddocu.ImpIgv = 0.
    /* Totales */
    ASSIGN
        Ccbcdocu.ImpExo = (IF Ccbddocu.AftIgv = No  THEN Ccbddocu.implin ELSE 0)
        Ccbcdocu.ImpIgv = Ccbddocu.ImpIgv
        Ccbcdocu.ImpVta = Ccbcdocu.ImpTot - Ccbcdocu.ImpIgv
        Ccbcdocu.ImpBrt = Ccbcdocu.ImpVta.
    IF Ccbcdocu.CodMon = 1
        THEN ASSIGN
        x-ImpMn = Ccbcdocu.ImpTot
        x-ImpMe = Ccbcdocu.ImpTot / Ccbcdocu.TpoCmb.
    ELSE ASSIGN
        x-ImpMn = Ccbcdocu.ImpTot * Ccbcdocu.TpoCmb
        x-ImpMe = Ccbcdocu.ImpTot.
    /* Amortizamos el Anticipo */
    CREATE CCBDMOV.
    ASSIGN
        CCBDMOV.CodCia = s-CodCia
        CCBDMOV.CodDiv = s-CodDiv
        CCBDMOV.CodDoc = ANTICIPOS.CodDoc
        CCBDMOV.NroDoc = ANTICIPOS.NroDoc
        CCBDMOV.CodRef = Ccbcdocu.CodDoc     /* N/C */
        CCBDMOV.NroRef = Ccbcdocu.NroDoc
        CCBDMOV.CodMon = Ccbcdocu.CodMon
        CCBDMOV.CodCli = Ccbcdocu.CodCli
        CCBDMOV.FchDoc = Ccbcdocu.FchDoc
        CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
        CCBDMOV.TpoCmb = Ccbcdocu.TpoCmb
        CCBDMOV.usuario = s-User-ID
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = 'NO se pudo generar el detalle de la N/C x A/R'.
        UNDO, LEAVE.
    END.
    IF Ccbcdocu.CodMon = 1 THEN
        ASSIGN CCBDMOV.ImpTot = x-ImpMn.
    ELSE ASSIGN CCBDMOV.ImpTot = x-ImpMe.
    /* Actualizamo saldo del A/C */
    ASSIGN
        ANTICIPOS.SdoAct = ANTICIPOS.SdoAct - Ccbdmov.imptot.
    IF ANTICIPOS.SdoAct <= 0 THEN
        ASSIGN
        ANTICIPOS.flgest = 'C'
        ANTICIPOS.fchcan = TODAY.
END.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(Ccbdmov)  THEN RELEASE Ccbdmov.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Nota-Credito-Descuentos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Nota-Credito-Descuentos Procedure 
PROCEDURE Nota-Credito-Descuentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-coddoc AS CHAR INIT 'N/C' NO-UNDO.
DEF VAR s-nroser AS INT NO-UNDO.
DEF VAR cListItems AS CHAR NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).
DEF VAR pConcepto AS CHAR INIT '00001' NO-UNDO.
{sunat\i-lista-series.i &CodCia=s-CodCia ~
    &CodDiv=s-CodDiv ~
    &CodDoc=s-CodDoc ~
    &FlgEst='' ~          /* En blanco si quieres solo ACTIVOS */
    &Tipo='CREDITO' ~
    &ListaSeries=cListItems ~
    }
s-NroSer = INTEGER(ENTRY(1,cListItems)).

DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    {lib/lock-genericov2.i ~
        &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-codcia ~
        AND FacCorre.CodDiv = s-coddiv ~
        AND FacCorre.CodDoc = s-coddoc ~
        AND FacCorre.NroSer = s-nroser" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="LEAVE" ~
        }

    CREATE Ccbcdocu.
    BUFFER-COPY B-CDOCU TO Ccbcdocu
        ASSIGN
        CcbCDocu.CodDoc = S-CODDOC
        CcbCDocu.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.FchVto = ADD-INTERVAL (TODAY, 1, 'years')
        CcbCDocu.TpoFac = ""
        CcbCDocu.CndCre = "N"
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.FlgEst = "P"     /* Pendiente */
        CcbCDocu.CodPed = B-CDOCU.coddoc
        CcbCDocu.NroPed = B-CDOCU.nrodoc
        CcbCDocu.Tipo   = "CREDITO"
        CcbCDocu.CodCaja= ""
        CcbCDocu.CodCta = pConcepto
        Ccbcdocu.imptot = x-Monto-Aplicar
        Ccbcdocu.sdoact = x-Monto-Aplicar.
    FOR EACH Ccbdcaja NO-LOCK WHERE CcbDCaja.CodCia = s-codcia
        AND CcbDCaja.CodDoc = ANTICIPOS.CodRef
        AND CcbDCaja.NroDoc = ANTICIPOS.NroRef:
        ASSIGN
            Ccbcdocu.codref = CcbDCaja.CodRef 
            Ccbcdocu.nroref = CcbDCaja.NroRef.
    END.
    /* Detalle */
    CREATE Ccbddocu.
    BUFFER-COPY Ccbcdocu
        TO Ccbddocu
        ASSIGN
        Ccbddocu.nroitm = 1
        Ccbddocu.codmat = pConcepto
        Ccbddocu.candes = 1
        Ccbddocu.preuni = Ccbcdocu.imptot
        Ccbddocu.implin = Ccbcdocu.imptot
        Ccbddocu.factor = 1.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia
        AND CcbTabla.Tabla = s-CodDoc
        AND CcbTabla.Codigo = Ccbddocu.codmat NO-LOCK.
    IF CcbTabla.Afecto THEN
        ASSIGN
            Ccbddocu.AftIgv = Yes
            Ccbddocu.ImpIgv = Ccbddocu.implin * ((Ccbcdocu.PorIgv / 100) / (1 + (Ccbcdocu.PorIgv / 100))).
    ELSE
        ASSIGN
            Ccbddocu.AftIgv = No
            Ccbddocu.ImpIgv = 0.
    /* Totales */
    ASSIGN
        Ccbcdocu.ImpExo = (IF Ccbddocu.AftIgv = No  THEN Ccbddocu.implin ELSE 0)
        Ccbcdocu.ImpIgv = Ccbddocu.ImpIgv
        Ccbcdocu.ImpVta = Ccbcdocu.ImpTot - Ccbcdocu.ImpIgv
        Ccbcdocu.ImpBrt = Ccbcdocu.ImpVta.

END.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
IF AVAILABLE(Ccbdmov)  THEN RELEASE Ccbdmov.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

