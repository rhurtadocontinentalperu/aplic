&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-VVALE NO-UNDO LIKE VtaVVale.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER d-Rowid AS ROWID.

DEFINE NEW SHARED VARIABLE s-PtoVta AS INT.
DEFINE NEW SHARED VARIABLE s-codcli LIKE gn-clie.codcli.
DEFINE NEW SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

DEFINE SHARED VAR s-User-Id AS CHAR.
DEFINE SHARED VAR s-CodCia AS INT.
DEFINE SHARED VAR cl-CODCIA AS INTEGER.
DEFINE SHARED VAR s-CodDiv AS CHAR.
DEFINE SHARED VAR s-Tipo   AS CHAR.      /* MOSTRADOR */
DEFINE SHARED VAR s-CodTer LIKE ccbcterm.codter.
DEFINE SHARED VAR s-CodMov LIKE Almtmovm.Codmov.
DEFINE SHARED VAR s-CodCja AS CHAR.      /* I/C */
DEFINE SHARED VAR s-SerCja AS INT.
DEFINE SHARED VAR S-CODALM AS CHAR.

DEFINE NEW SHARED VAR S-CodDoc AS CHAR.
DEFINE VAR x-cto1 AS DECI INIT 0 NO-UNDO.
DEFINE VAR x-cto2 AS DECI INIT 0 NO-UNDO.

DEFINE VAR l-Ok AS LOG NO-UNDO.
DEFINE VAR i AS INTEGER INITIAL 1 NO-UNDO.

DEFINE VARIABLE monto_ret AS DECIMAL NO-UNDO.
DEFINE VARIABLE dTpoCmb LIKE CcbcCaja.TpoCmb NO-UNDO.
DEFINE VARIABLE cNomcli AS CHAR NO-UNDO.
DEFINE VARIABLE NroDocCja AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE T-CPEDM LIKE FacCPedm
    FIELD CodRef LIKE CcbCDocu.CodRef
    FIELD NroRef LIKE CcbCDocu.NroRef.
DEFINE TEMP-TABLE T-DPEDM LIKE FacDPedm.

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
   Temp-Tables and Buffers:
      TABLE: T-VVALE T "NEW SHARED" NO-UNDO INTEGRAL VtaVVale
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND FacCPedm WHERE ROWID(FacCPedm) = D-ROWID NO-LOCK NO-ERROR. 
IF NOT AVAILABLE FacCPedm THEN RETURN 'ADM-ERROR'.

s-CodDoc = FacCPedm.Cmpbnte.
FIND FIRST ccbdterm WHERE
    CcbDTerm.CodCia = s-codcia AND
    CcbDTerm.CodDiv = s-coddiv AND
    CcbDTerm.CodDoc = s-CodDoc AND
    CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbdterm THEN DO:
    MESSAGE
        "DOCUMENTO" s-CodDoc "NO ESTA CONFIGURADO EN ESTE TERMINAL"
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-ptovta = ccbdterm.nroser.  /* Numero de Serie */

/* COMPROBANTE */
FIND FacDocum WHERE
    facdocum.codcia = s-codcia AND
    facdocum.coddoc = s-CodDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum THEN DO:
    MESSAGE
        "NO ESTA DEFINIDO EL DOCUMENTO" s-CodDoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-codmov = facdocum.codmov.  /* Movimiento de Almacen */

IF LOOKUP(FacCPedM.FmaPgo,"000,001") > 0 THEN DO:
    /* MOVIMIENTO DE ALMACEN */
    FIND almtmovm WHERE
        Almtmovm.CodCia = s-codcia AND
        Almtmovm.Codmov = s-codmov AND
        Almtmovm.Tipmov = "S"
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almtmovm THEN DO:
        MESSAGE
            "NO ESTA DEFINIDO EL MOVIMIENTO DE SALIDA" s-codmov
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
END.

/*** Control de Correlativo *** */
FIND FacCorre WHERE
    faccorre.codcia = s-codcia AND
    faccorre.coddoc = s-CodDoc AND
    faccorre.nroser = s-ptovta NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE
        "No esta definida la serie" s-ptovta SKIP
        "para el comprobante" faccpedm.cmpbnte 
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

s-codCli = FacCPedm.CodCli.

IF LOOKUP(FacCPedm.FmaPgo,"000,002") > 0 THEN DO:

    /* Retenciones */
    FOR EACH wrk_ret:
        DELETE wrk_ret.
    END.
    /* N/C */
    FOR EACH wrk_dcaja:
        DELETE wrk_dcaja.
    END.
    IF FacCPedM.CodDoc = "FAC" AND       /* Solo Facturas */
        FacCPedM.ImpTot > 0 THEN DO:

        /* Tipo de Cambio Caja */
        dTpoCmb = 1.
        FIND LAST Gn-tccja WHERE  Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-TcCja THEN DO:
            IF FacCPedM.Codmon = 1 THEN dTpoCmb = Gn-Tccja.Compra.
            ELSE dTpoCmb = Gn-Tccja.Venta.
        END.
        FIND gn-clie WHERE
            gn-clie.codcia = cl-codcia AND
            gn-clie.codcli = FacCPedM.CodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie AND gn-clie.rucold = "Si" THEN DO:     /* AGENTE RETENEDOR */
            CREATE wrk_ret.
            ASSIGN
                wrk_ret.CodCia = FacCPedM.Codcia
                wrk_ret.CodCli = FacCPedM.CodCli
                wrk_ret.CodDoc = FacCPedM.CodDoc
                wrk_ret.NroDoc = FacCPedM.NroPed
                wrk_ret.FchDoc = FacCPedM.FchPed
                wrk_ret.CodRef = s-CodCja
                wrk_ret.NroRef = ""
                wrk_ret.CodMon = "S/."
                cNomcli = gn-clie.nomcli.
            /* OJO: Cálculo de Retenciones Siempre en Soles */
            IF FacCPedM.Codmon = 1 THEN DO:
                wrk_ret.ImpTot = FacCPedM.imptot.
                wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
            END.
            ELSE DO:
                wrk_ret.ImpTot = ROUND((FacCPedM.imptot * dTpoCmb),2).
                wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
            END.
        END.
    END.
    /* VENTANA DE CANCELACIÓN */
    RUN ccb/d-canped-02(
        FacCPedM.codmon,    /* Moneda Documento */
        FacCPedM.imptot,    /* Importe Total */
        monto_ret,          /* Retención */
        FacCPedM.NomCli,    /* Nombre Cliente */
        TRUE,               /* Venta Contado */
        FacCPedM.FlgSit,    /* Pago con Tarjeta de Crédito */
        OUTPUT L-OK).       /* Flag Retorno */
END.
ELSE L-OK = YES.

IF L-OK = NO THEN RETURN "ADM-ERROR".

RUN proc_CreaTemp.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FacCPedm WHERE ROWID(FacCPedm) = D-ROWID EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCPedm THEN UNDO, RETURN 'ADM-ERROR'.
    FOR EACH T-CPEDM:
        FIND faccorre WHERE
            faccorre.codcia = s-codcia AND  
            faccorre.coddoc = s-coddoc AND  
            faccorre.NroSer = s-ptovta
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
        CREATE CcbCDocu.
        BUFFER-COPY T-CPEDM TO CcbCDocu
            ASSIGN
                CcbCDocu.CodCia   = S-CodCia
                CcbCDocu.CodDiv   = S-CodDiv
                CcbCDocu.CodDoc   = s-CodDoc
                ccbcdocu.nrodoc   = STRING(faccorre.nroser, "999") +
                    STRING(FacCorre.Correlativo, "999999")
                CcbCDocu.FchDoc   = TODAY
                CcbCDocu.usuario  = S-User-Id
                CcbCDocu.Tipo     = S-Tipo
                CcbCDocu.CodAlm   = S-CodAlm
                CcbCDocu.CodMov   = S-CodMov
                CcbCDocu.CodPed   = T-CPEDM.coddoc
                CcbCDocu.NroPed   = FacCPedm.NroPed
                CcbCDocu.CodVen   = T-CPEDM.codven
                CcbCDocu.FchCan   = TODAY
                CcbCDocu.FchVto   = TODAY
                CcbCDocu.TipVta   = "1" 
                CcbCDocu.TpoFac   = "C"
                CcbCDocu.FlgEst   = "P"
                CcbCDocu.AcuBon[1] = T-CPEDM.AcuBon[1]
                CcbCDocu.AcuBon[2] = T-CPEDM.Importe[1]
                CcbCDocu.AcuBon[3] = T-CPEDM.Importe[2]
                CcbCDocu.CodAge   = T-CPEDM.CodTrans
                CcbCDocu.FlgSit   = (IF T-CPEDM.DocDesp = "GUIA" THEN "G" ELSE "")
                CcbCDocu.FlgCon   = (IF T-CPEDM.DocDesp = "GUIA" THEN "G" ELSE "").
        /* GRABA EL TIPO DE ENTREGA */
        IF FacCPedm.FmaPgo = "001" THEN CcbCDocu.FlgCon = "E".
        IF FacCPedm.FmaPgo = "002" THEN CcbCDocu.FlgCon = "A".
        ASSIGN
            T-CPEDM.CodRef    = Ccbcdocu.CodDoc
            T-CPEDM.NroRef    = Ccbcdocu.NroDoc
            faccorre.correlativo = faccorre.correlativo + 1.

        i = 1.
        FOR EACH T-DPEDM OF T-CPEDM BY nroitm:
            CREATE ccbDDocu.
            BUFFER-COPY T-DPEDM TO CcbDDocu
                ASSIGN 
                    CcbDDocu.CodCia = ccbcdocu.codcia
                    CcbDDocu.CodDoc = ccbcdocu.coddoc
                    CcbDDocu.NroDoc = ccbcdocu.nrodoc
                    CcbDDocu.FchDoc = ccbcdocu.fchdoc
                    CcbDDocu.CodDiv = ccbcdocu.coddiv
                    CcbDDocu.CanDes = T-DPEDM.canped
                    CcbDDocu.NroItm = i.
            i = i + 1.
            /* Costos */
            FIND Almmmatg WHERE
                Almmmatg.CodCia = S-CODCIA AND
                Almmmatg.codmat = CcbDDocu.Codmat
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmatg THEN DO:
                if almmmatg.monvta = 1 then do:
                    x-cto1 = ROUND(Almmmatg.Ctotot *
                        CcbDDocu.CanDes * CcbDDocu.Factor, 2).
                    x-cto2 = ROUND((Almmmatg.Ctotot *
                        CcbDDocu.CanDes * CcbDDocu.Factor ) / Almmmatg.Tpocmb, 2).
                end.
                if almmmatg.monvta = 2 then do:
                    x-cto1 = ROUND(Almmmatg.Ctotot *
                        CcbDDocu.CanDes * CcbDDocu.Factor * Almmmatg.TpoCmb, 2).
                    x-cto2 = ROUND((Almmmatg.Ctotot *
                        CcbDDocu.CanDes * CcbDDocu.Factor), 2).
                end.
                CcbDDocu.ImpCto = IF CcbCDocu.Codmon = 1 THEN x-cto1 ELSE x-cto2.
            END.
            CcbCDocu.ImpCto = CcbCDocu.ImpCto + CcbDDocu.ImpCto.
        END.
    END.
    /**** ACTUALIZAMOS FLAG DEL PEDIDO  DE MOSTRADOR COMO ATENDIDO ****/
    ASSIGN FacCPedm.flgest = "C".
    /***********************************/

    /**** SOLO CONTADO Y CONTADO ANTICIPADO GENERAN INGRESO A CAJA ****/
    IF LOOKUP(FacCPedm.FmaPgo,"000,002") > 0 THEN DO:

        FIND FIRST T-CcbCCaja.
        /* Genera Cheque */
        IF ((T-CcbCCaja.Voucher[2] <> "") AND
            (T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2]) > 0) OR
            ((T-CcbCCaja.Voucher[3] <> "") AND
            (T-CcbCCaja.ImpNac[3] + T-CcbCCaja.ImpUsa[3]) > 0) THEN DO:
            CREATE CcbCDocu.
            ASSIGN
                CcbCDocu.CodCia = S-CodCia
                CcbCDocu.CodDiv = S-CodDiv
                CcbCDocu.CodDoc = "CHC"
                CcbCDocu.CodCli = T-CcbCCaja.Voucher[10]
                CcbCDocu.FlgEst = "P"
                CcbCDocu.Usuario = s-User-Id
                CcbCDocu.TpoCmb = T-CcbCCaja.TpoCmb
                CcbCDocu.FchDoc = TODAY.
            FIND Gn-Clie WHERE
                Gn-Clie.Codcia = cl-codcia AND
                Gn-Clie.CodCli = CcbCDocu.CodCli
                NO-LOCK NO-ERROR.
            IF AVAILABLE Gn-Clie THEN
                ASSIGN
                    CcbCDocu.NomCli = Gn-Clie.Nomcli
                    CcbCDocu.RucCli = Gn-Clie.Ruc.
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
        END.

        /* Cancelacion del documento */
        NroDocCja = "".
        RUN proc_IngCja(OUTPUT NroDocCja).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

        /* Actualiza la Boleta de Deposito */
        IF T-CcbCCaja.Voucher[5] <> "" AND
            (T-CcbCCaja.ImpNac[5] + T-CcbCCaja.ImpUsa[5]) > 0 THEN DO:
            RUN proc_AplicaBD(
                T-CcbCCaja.Voucher[5],
                NroDocCja,
                T-CcbCCaja.tpocmb,
                T-CcbCCaja.ImpNac[5],
                T-CcbCCaja.ImpUsa[5],
                T-CcbCCaja.CodBco[5]
                ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
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
                    NroDocCja,
                    T-CcbCCaja.tpocmb,
                    IF CcbCDocu.CodMon = 1 THEN wrk_dcaja.Imptot ELSE 0,
                    IF CcbCDocu.CodMon = 2 THEN wrk_dcaja.Imptot ELSE 0
                    ).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            END.
        END.

        /* Aplica de Anticipo */
        IF T-CcbCCaja.Voucher[7] <> "" AND
            (T-CcbCCaja.ImpNac[7] + T-CcbCCaja.ImpUsa[7]) > 0 THEN DO:
            RUN proc_AplicaDoc(
                "A/R",
                T-CcbCCaja.Voucher[7],
                NroDocCja,
                T-CcbCCaja.tpocmb,
                T-CcbCCaja.ImpNac[7],
                T-CcbCCaja.ImpUsa[7]
                ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.

        /* Retenciones */
        IF CAN-FIND(FIRST wrk_ret) THEN DO:
            FOR EACH wrk_ret:
                wrk_ret.NroRef = NroDocCja.
            END.
            RUN proc_CreaRetencion.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.

    END.
    /**** SOLO CONTADO Y CONTRA ENTREGA DESCARGAN DEL ALMACEN ****/
    IF LOOKUP(FacCPedm.FmaPgo,"000,001") > 0 THEN DO:
        RUN proc_DesAlm.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
    END.

    /* Actualiza Control de Vales de Compras */
    FOR EACH T-VVALE:
        CREATE VtaVVale.
        BUFFER-COPY T-VVALE TO VtaVVale
            ASSIGN
                VtaVVale.CodCia = s-codcia
                VtaVVale.CodDiv = s-coddiv
                VtaVVale.CodRef = s-CodCja
                VtaVVale.NroRef = NroDocCja
                VtaVVale.Fecha = TODAY
                VtaVVale.Hora = STRING(TIME,'HH:MM').
    END.

    RELEASE FacCPedm.

END.    /* DO TRANSACTIO... */

/**** IMPRIMIMOS LAS FACTURAS O BOLETAS Y SUS ORDENES DE DESPACHO ****/
FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":
    FIND CcbCDocu WHERE 
        CcbCDocu.CodCia = S-CodCia AND
        CcbCDocu.CodDiv = S-CodDiv AND
        CcbCDocu.CodDoc = T-CPEDM.CodRef AND
        CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR. 
    IF AVAILABLE CcbCDocu THEN  DO:
        /* Cambiamos al formato similar al de ATE */
        IF Ccbcdocu.CodDoc = "FAC" THEN RUN vta/r-impfac2 (ROWID(ccbcdocu)).
        IF Ccbcdocu.CodDoc = "TCK" THEN DO:
            CASE s-codter:
                WHEN "TERM04" THEN RUN ccb/r-tick500 (ROWID(ccbcdocu)).
                OTHERWISE RUN ccb/r-tick01 (ROWID(ccbcdocu)).
            END CASE.
        END.
        FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-proc_AplicaBD) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaBD Procedure 
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

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':

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
            CCBDMOV.CodRef = s-CodCja
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

&ENDIF

&IF DEFINED(EXCLUDE-proc_AplicaDoc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaDoc Procedure 
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
            CCBDMOV.CodRef = s-CodCja
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

        RELEASE B-CDocu.

    END. /* DO TRANSACTION... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_CreaRetencion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaRetencion Procedure 
PROCEDURE proc_CreaRetencion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST T-CcbCCaja NO-ERROR.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':
        FOR EACH wrk_ret NO-LOCK:
            FIND FIRST CCBCMOV WHERE
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
            CREATE CCBCMOV.
            ASSIGN
                CCBCMOV.CodCia = wrk_ret.CodCia
                CCBCMOV.CodDoc = wrk_ret.CodDoc
                CCBCMOV.NroDoc = wrk_ret.NroDoc
                CCBCMOV.CodRef = wrk_ret.CodRef
                CCBCMOV.NroRef = wrk_ret.NroRef
                CCBCMOV.CodCli = wrk_ret.CodCli
                CCBCMOV.CodDiv = s-CodDiv
                CCBCMOV.CodMon = 1                  /* Ojo: Siempre en Soles */
                CCBCMOV.TpoCmb = T-CcbCCaja.TpoCmb
                CCBCMOV.FchDoc = wrk_ret.FchDoc
                CCBCMOV.ImpTot = wrk_ret.ImpTot
                CCBCMOV.DocRef = wrk_ret.NroRet     /* Comprobante */
                CCBCMOV.FchRef = wrk_ret.FchRet     /* Fecha */
                CCBCMOV.ImpRef = wrk_ret.ImpRet     /* Importe */
                CCBCMOV.FchMov = TODAY
                CCBCMOV.HraMov = STRING(TIME,"HH:MM:SS")
                CCBCMOV.usuario = s-User-ID
                CCBCMOV.chr__01 = cNomcli.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_CreaTemp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaTemp Procedure 
PROCEDURE proc_CreaTemp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
    DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

    FOR EACH T-CPEDM:
        DELETE T-CPEDM.
    END.
    FOR EACH T-DPEDM:
        DELETE T-DPEDM.
    END.

    DEFINE VARIABLE L-NewPed AS LOGICAL INIT YES NO-UNDO.
    DEFINE VARIABLE I-NPED   AS INTEGER INIT 0.
    DEFINE VARIABLE I-NItem  AS INTEGER INIT 0.

    FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
    FOR EACH FacDPedm NO-LOCK OF FacCPedm 
        BREAK BY FacDPedm.CodCia
        BY trim(FacDPedm.AlmDes):
        IF FIRST-OF(trim(FacDPedm.AlmDes)) OR L-NewPed THEN DO:
            I-NPED = I-NPED + 1.
            CREATE T-CPEDM.
            BUFFER-COPY FacCPedm TO T-CPEDM
                ASSIGN
                    T-CPEDM.NroPed =
                        SUBSTRING(FacCPedm.NroPed,1,3) +
                        STRING(I-NPED,"999999")
                    T-CPEDM.CodAlm = TRIM(FacDPedm.AlmDes)
                    T-CPEDM.ImpBrt = 0
                    T-CPEDM.ImpDto = 0
                    T-CPEDM.ImpExo = 0
                    T-CPEDM.ImpIgv = 0
                    T-CPEDM.ImpIsc = 0
                    T-CPEDM.ImpTot = 0
                    T-CPEDM.ImpVta = 0
                    F-IGV          = 0
                    F-ISC          = 0
                    L-NewPed       = NO
                    I-NItem        = 0.
        END.
        ASSIGN      
            T-CPEDM.ImpDto = T-CPEDM.ImpDto + FacDPedm.ImpDto
            F-IGV = F-IGV + FacDPedm.ImpIgv
            F-ISC = F-ISC + FacDPedm.ImpIsc
            T-CPEDM.ImpTot = T-CPEDM.ImpTot + FacDPedm.ImpLin.
        IF NOT FacDPedm.AftIgv THEN
            T-CPEDM.ImpExo = T-CPEDM.ImpExo + FacDPedm.ImpLin.
        CREATE T-DPEDM.
        BUFFER-COPY FacDPedm TO T-DPEDM
            ASSIGN T-DPEDM.NroPed = T-CPEDM.NroPed.
        I-NItem = I-NItem + 1.
        IF (T-CPEDM.Cmpbnte = "BOL" AND I-NItem >= FacCfgGn.Items_Boleta) OR
            (T-CPEDM.Cmpbnte = "FAC" AND I-NItem >= FacCfgGn.Items_Factura) THEN DO:
            L-NewPed = YES.
        END.

        IF LAST-OF(trim(FacDPedm.AlmDes)) OR L-NewPed THEN DO:
            ASSIGN
                T-CPEDM.ImpIgv = ROUND(F-IGV,2).
                T-CPEDM.ImpIsc = ROUND(F-ISC,2).
                T-CPEDM.ImpBrt =
                    T-CPEDM.ImpTot - T-CPEDM.ImpIgv - T-CPEDM.ImpIsc + 
                    T-CPEDM.ImpDto - T-CPEDM.ImpExo.
                T-CPEDM.ImpVta = T-CPEDM.ImpBrt - T-CPEDM.ImpDto.
            /*** DESCUENTO GLOBAL ****/
            IF T-CPEDM.PorDto > 0 THEN DO:
                T-CPEDM.ImpDto = T-CPEDM.ImpDto + ROUND(T-CPEDM.ImpTot * T-CPEDM.PorDto / 100,2).
                T-CPEDM.ImpTot = ROUND(T-CPEDM.ImpTot * (1 - T-CPEDM.PorDto / 100),2).
                T-CPEDM.ImpVta = ROUND(T-CPEDM.ImpTot / (1 + T-CPEDM.PorIgv / 100),2).
                T-CPEDM.ImpIgv = T-CPEDM.ImpTot - T-CPEDM.ImpVta.
                T-CPEDM.ImpBrt =
                    T-CPEDM.ImpTot - T-CPEDM.ImpIgv - T-CPEDM.ImpIsc +
                    T-CPEDM.ImpDto - T-CPEDM.ImpExo.
                T-CPEDM.Importe[1] = (T-CPEDM.ImpTot / Faccpedm.ImpTot) * Faccpedm.Importe[1].
                T-CPEDM.Importe[2] = (T-CPEDM.ImpTot / Faccpedm.ImpTot) * Faccpedm.Importe[2].
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_DesAlm) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_DesAlm Procedure 
PROCEDURE proc_DesAlm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i AS INTEGER INITIAL 1 NO-UNDO.

    FOR EACH T-CPEDM NO-LOCK
        BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":

        FIND FIRST CcbCDocu WHERE 
            CcbCDocu.CodCia = S-CodCia AND
            CcbCDocu.CodDoc = T-CPEDM.CodRef AND
            CcbCDocu.NroDoc = T-CPEDM.NroRef AND
            CcbCDocu.CodAlm = TRIM(T-CPEDM.CodAlm)
            EXCLUSIVE-LOCK NO-ERROR. 
        IF NOT AVAILABLE CcbCDocu THEN DO:
            MESSAGE
                "Documento" T-CPEDM.CodRef T-CPEDM.NroRef
                "mal grabado" SKIP
                "Anule este movimiento y vuelva a crear otro"
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        /* Correlativo de Salida */
        FIND Almacen WHERE 
            Almacen.CodCia = CcbCDocu.CodCia AND  
            Almacen.CodAlm = TRIM(CcbCDocu.CodAlm)
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Almacen THEN DO:
            MESSAGE
                "Correlativo de Almacén no Disponible"
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        CREATE Almcmov.
        ASSIGN
            Almcmov.CodCia  = CcbCDocu.CodCia
            Almcmov.CodAlm  = trim(CcbCDocu.CodAlm)
            Almcmov.TipMov  = "S"
            Almcmov.CodMov  = CcbCDocu.CodMov
            Almcmov.NroSer  = S-PtoVta
            Almcmov.NroDoc  = Almacen.CorrSal
            Almcmov.CodRef  = CcbCDocu.CodDoc
            Almcmov.NroRef  = CcbCDocu.NroDoc
            Almcmov.NroRf1  = SUBSTRING(CcbCDocu.CodDoc,1,1) + CcbCDocu.NroDoc
            Almcmov.NroRf2  = CcbCDocu.NroPed
            Almcmov.Nomref  = CcbCDocu.NomCli
            Almcmov.FchDoc  = TODAY
            Almcmov.HorSal  = STRING(TIME, "HH:MM:SS")
            Almcmov.CodVen  = Ccbcdocu.CodVen
            Almcmov.CodCli  = Ccbcdocu.CodCli
            Almcmov.usuario = S-User-Id
            CcbcDocu.NroSal = STRING(Almcmov.NroDoc,"999999").
            Almacen.CorrSal = Almacen.CorrSal + 1.
        RELEASE Almacen.
        FOR EACH ccbddocu OF ccbcdocu NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
            CREATE Almdmov.
            ASSIGN
                Almdmov.CodCia = AlmCmov.CodCia
                Almdmov.CodAlm = trim(AlmCmov.CodAlm)
                Almdmov.TipMov = trim(AlmCmov.TipMov)
                Almdmov.CodMov = AlmCmov.CodMov
                Almdmov.NroSer = Almcmov.NroSer
                Almdmov.NroDoc = Almcmov.NroDoc
                Almdmov.FchDoc = Almcmov.FchDoc
                Almdmov.NroItm = i
                Almdmov.codmat = trim(ccbddocu.codmat)
                Almdmov.CanDes = ccbddocu.candes
                Almdmov.AftIgv = ccbddocu.aftigv
                Almdmov.AftIsc = ccbddocu.aftisc
                Almdmov.CodMon = ccbcdocu.codmon
                Almdmov.CodUnd = ccbddocu.undvta
                Almdmov.Factor = ccbddocu.factor
                Almdmov.ImpDto = ccbddocu.impdto
                Almdmov.ImpIgv = ccbddocu.impigv
                Almdmov.ImpIsc = ccbddocu.impisc
                Almdmov.ImpLin = ccbddocu.implin
                Almdmov.PorDto = ccbddocu.pordto
                Almdmov.PreBas = ccbddocu.prebas
                Almdmov.PreUni = ccbddocu.preuni
                Almdmov.TpoCmb = ccbcdocu.tpocmb
                Almdmov.Por_Dsctos[1] = ccbddocu.Por_Dsctos[1]
                Almdmov.Por_Dsctos[2] = ccbddocu.Por_Dsctos[2]
                Almdmov.Por_Dsctos[3] = ccbddocu.Por_Dsctos[3]
                Almdmov.Flg_factor = ccbddocu.Flg_factor
                Almdmov.Hradoc = STRING(TIME, "HH:MM:SS")
                Almcmov.TotItm = i
                i = i + 1.
            RUN alm/almdcstk (ROWID(almdmov)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            RUN alm/almacpr1 (ROWID(almdmov), 'U').
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_IngCja) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_IngCja Procedure 
PROCEDURE proc_IngCja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER para_nrodoccja LIKE CcbCCaja.NroDoc.

    DEFINE VARIABLE x_NumDoc AS CHARACTER.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':

        FIND Faccorre WHERE 
            FacCorre.CodCia = s-codcia AND
            FacCorre.CodDiv = s-coddiv AND
            FacCorre.CodDoc = s-codcja AND
            FacCorre.NroSer = s-sercja
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccorre THEN UNDO, RETURN 'ADM-ERROR'.           

        FIND FIRST T-CcbCCaja.

        CREATE CcbCCaja.
        BUFFER-COPY T-CcbCCaja TO CcbCCaja
        ASSIGN
            CcbCCaja.CodCia  = S-CodCia
            CcbCCaja.CodDiv  = S-CodDiv 
            CcbCCaja.CodDoc  = s-codcja
            CcbCCaja.NroDoc  = STRING(FacCorre.NroSer, "999") +
                STRING(FacCorre.Correlativo, "999999")
            CcbCCaja.CodCli  = FacCPedm.codcli
            CcbCCaja.NomCli  = FacCPedm.NomCli
            CcbCCaja.CodMon  = FacCPedm.CodMon
            CcbCCaja.FchDoc  = TODAY
            CcbCcaja.Tipo    = s-tipo
            CcbCCaja.CodCaja = S-CODTER
            CcbCCaja.usuario = s-user-id
            CcbCCaja.FLGEST  = "C"
            FacCorre.Correlativo = FacCorre.Correlativo + 1.

        RELEASE faccorre.

        /* Crea Detalle de Caja */
        FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed:
            FIND CcbCDocu WHERE
                CcbCDocu.CodCia = S-CodCia AND
                CcbCDocu.CodDiv = S-CodDiv AND
                CcbCDocu.CodDoc = T-CPEDM.CodRef AND
                CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR. 
            IF NOT AVAILABLE Ccbcdocu THEN UNDO, RETURN 'ADM-ERROR'.
            CREATE CcbDCaja.
            ASSIGN
                CcbDCaja.CodCia = CcbCCaja.CodCia
                CcbDCaja.CodDiv = CcbCCaja.CodDiv
                CcbDCaja.CodDoc = CcbCCaja.CodDoc
                CcbDCaja.NroDoc = CcbCCaja.NroDoc
                CcbDCaja.CodRef = CcbCDocu.CodDoc
                CcbDCaja.NroRef = CcbCDocu.NroDoc
                CcbDCaja.CodCli = CcbCDocu.CodCli
                CcbDCaja.CodMon = CcbCDocu.CodMon
                CcbDCaja.FchDoc = CcbCCaja.FchDoc
                CcbDCaja.ImpTot = CcbCDocu.ImpTot
                CcbDCaja.TpoCmb = CcbCCaja.TpoCmb
                CcbCDocu.FlgEst = "C"
                CcbCDocu.FchCan = TODAY
                CcbCDocu.SdoAct = 0.
            RELEASE CcbCDocu.
        END.

        /* Cancelación por Cheque */
        IF T-CcbCCaja.Voucher[2] <> "" OR T-CcbCCaja.Voucher[3] <> "" THEN DO:
            IF T-CcbCCaja.Voucher[2] <> "" THEN x_NumDoc = T-CcbCCaja.Voucher[2].
            IF T-CcbCCaja.Voucher[3] <> "" THEN x_NumDoc = T-CcbCCaja.Voucher[3].       
            FIND CcbCDocu WHERE 
                CcbCDocu.CodCia = S-CodCia AND
                CcbCDocu.CodDiv = S-CodDiv AND
                CcbCDocu.CodDoc = "CHC" AND
                CcbCDocu.NroDoc = x_NumDoc
                EXCLUSIVE-LOCK NO-ERROR. 
            IF AVAILABLE CcbCDocu THEN
                ASSIGN
                    CcbCDocu.CodRef = CcbCCaja.CodDoc 
                    CcbCDocu.NroRef = CcbCCaja.NroDoc.               
        END.
    
        /* Captura Nro de Caja */
        para_nrodoccja = CcbCCaja.NroDoc.

        RELEASE ccbccaja.
        RELEASE ccbdcaja.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

