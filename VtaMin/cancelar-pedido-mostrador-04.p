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
DEFINE BUFFER B-CPEDM FOR FacCPedm.

DEFINE SHARED VAR s-User-Id AS CHAR.
DEFINE SHARED VAR s-CodCia AS INT.
DEFINE SHARED VAR CL-CodCia AS INT.
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

/* VARIABLES PARA LA CANCELACION */
DEFINE VARIABLE list_docs   AS CHARACTER.

DEF VAR s-FechaI AS DATETIME NO-UNDO.
DEF VAR s-FechaT AS DATETIME NO-UNDO.
DEF VAR cMess   AS CHAR    NO-UNDO.
DEFINE VAR cCodAlm AS CHAR NO-UNDO.

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
         HEIGHT             = 7.96
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* PEDIDOS ACTIVOS MOSTRADOR */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.
DEFINE VARIABLE cliename    LIKE Gn-Clie.Nomcli.
DEFINE VARIABLE clieruc     LIKE Gn-Clie.Ruc.

FIND FacCPedm WHERE ROWID(FacCPedm) = D-ROWID NO-LOCK NO-ERROR. 
IF NOT AVAILABLE FacCPedm THEN RETURN 'ADM-ERROR'.

    /* AVISO DEL ADMINISTRADOR */
    DEF VAR pRpta AS CHAR.
    RUN ccb/d-msgblo (faccpedm.codcli, faccpedm.nrocard, OUTPUT pRpta).
    IF pRpta = 'ADM-ERROR' THEN RETURN.
    /* *********************** */

    /* Verifica I/C */
    RUN proc_verifica_ic.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    FIND B-CPEDM WHERE ROWID(B-CPEDM) = d-rowid NO-LOCK NO-ERROR. 

    /* NUMERO DE SERIE DEL COMPROBANTE PARA TERMINAL */
    s-CodDoc = B-CPEDM.Cmpbnte.
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
    s-PtoVta = Ccbdterm.nroser.
    FIND FacDocum WHERE
        facdocum.codcia = s-codcia AND
        facdocum.coddoc = s-CodDoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDocum THEN DO:
        MESSAGE
            "NO ESTA DEFINIDO EL DOCUMENTO" s-CodDoc                    
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    s-CodMov = Facdocum.codmov.
    IF LOOKUP(B-CPEDM.FmaPgo,"000,001") > 0 THEN DO:
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
    s-codCli = B-CPEDM.CodCli.
    /* 09.09.09 Control de Vigencia del Pedido Mostrador */
    /* Tiempo por defecto fuera de campaña */
    FIND FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK.
    TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
              (FacCfgGn.Hora-Res * 3600) + 
              (FacCfgGn.Minu-Res * 60).
    /* Tiempo dentro de campaña */
    FIND FIRST FacCfgVta WHERE Faccfgvta.codcia = s-codcia
        AND Faccfgvta.coddoc = B-CPEDM.CodDoc
        AND TODAY >= Faccfgvta.fechad
        AND TODAY <= Faccfgvta.fechah
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCfgVta 
    THEN TimeOut = (FacCfgVta.Dias-Res * 24 * 3600) +
                    (FacCfgVta.Hora-Res * 3600) + 
                    (FacCfgVta.Minu-Res * 60).
    IF TimeOut > 0 THEN DO:
        TimeNow = (TODAY - B-CPEDM.FchPed) * 24 * 3600.
        TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(B-CPEDM.Hora, 1, 2)) * 3600) +
                  (INTEGER(SUBSTRING(B-CPEDM.Hora, 4, 2)) * 60) ).
        IF TimeNow > TimeOut THEN DO:
            MESSAGE 'El Pedido' B-CPEDM.NroPed 'está VENCIDO' SKIP
                'Fue generado el' B-CPEDM.FchPed 'a las' B-CPEDM.Hora 'horas'
                VIEW-AS ALERT-BOX WARNING.
            RETURN 'ADM-ERROR'.
        END.
    END.

    /* **************************************************** */
    IF LOOKUP(B-CPEDM.FmaPgo,"000,002") > 0 THEN DO:
        /* Retenciones y N/C */
        RUN Temporal-de-Retenciones.

        /* VENTANA DE CANCELACIÓN */
        RUN ccb/d-canped-02a(
            B-CPEDM.codmon,     /* Moneda Documento */
            B-CPEDM.imptot,     /* Importe Total */
            monto_ret,          /* Retención */
            B-CPEDM.NomCli,     /* Nombre Cliente */
            TRUE,               /* Venta Contado */
            B-CPEDM.FlgSit,     /* Pago con Tarjeta de Crédito */
            OUTPUT L-OK).       /* Flag Retorno */

    END.
    ELSE L-OK = YES.
    IF L-OK = NO THEN RETURN "ADM-ERROR".

    /*
    /*Busca Promocion*/
    RUN vta/r-promociones (d-rowid,OUTPUT cMess).      
    */
    
    /* Temporal de Pedidos separados por Almacen */
    RUN proc_CreTmp.
    /* **************************************** */
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND B-CPEDM WHERE ROWID(B-CPEDM) = d-rowid EXCLUSIVE-LOCK NO-ERROR. 
        IF NOT AVAILABLE B-CPEDM THEN UNDO, RETURN 'ADM-ERROR'.
        IF B-CPEDM.FlgEst <> "P" THEN DO:
            MESSAGE
                "Pedido mostrador ya no esta PENDIENTE"
                VIEW-AS ALERT-BOX ERROR.
            RELEASE B-CPEDM.
            /*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/
            RETURN 'ADM-ERROR'.
        END.

        /* Creacion del Comprobante */
        FIND faccorre WHERE faccorre.codcia = s-codcia AND  
            faccorre.coddoc = s-CodDoc AND  
            faccorre.NroSer = s-ptovta EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
        RUN proc_CreaComprobante.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /* ************************* */

        /* Actualiza Flag del pedido */
        ASSIGN B-CPEDM.flgest = "C".        /* Pedido Mostrador CERRADO */
        FOR EACH Facdpedm OF B-CPEDM:
            ASSIGN
                Facdpedm.canate = Facdpedm.canped
                Facdpedm.flgest = Faccpedm.flgest.
        END.
        /* ************************* */

        IF LOOKUP(B-CPEDM.FmaPgo,"000,002") > 0 THEN DO:
            FIND FIRST T-CcbCCaja.
            /* Genera Cheque */
            IF ((T-CcbCCaja.Voucher[2] <> "") AND
                (T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2]) > 0) OR
                ((T-CcbCCaja.Voucher[3] <> "") AND
                (T-CcbCCaja.ImpNac[3] + T-CcbCCaja.ImpUsa[3]) > 0) THEN DO:
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
                    CcbCDocu.RucCli = clieruc
                    CcbCDocu.FlgEst = "P"
                    CcbCDocu.Usuario = s-User-Id
                    CcbCDocu.TpoCmb = T-CcbCCaja.TpoCmb
                    CcbCDocu.FchDoc = TODAY.
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
                RUN proc_AplicaDoc(
                    "BD",
                    T-CcbCCaja.Voucher[5],
                    NroDocCja,
                    T-CcbCCaja.tpocmb,
                    T-CcbCCaja.ImpNac[5],
                    T-CcbCCaja.ImpUsa[5]
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
        END. /* IF LOOKUP(B-CPEDM.FmaPgo,"000,002")... */

        /**** SOLO CONTADO Y CONTRA ENTREGA DESCARGAN DEL ALMACEN ****/
        IF LOOKUP(B-CPEDM.FmaPgo,"000,001") > 0 THEN DO:
            RUN proc_DesAlm.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
        END.
        IF LOOKUP(B-CPEDM.FmaPgo,"002") > 0 THEN DO:
            RUN Proc_OrdDes.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
        END.
        /*
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
        */
    END. /* DO TRANSACTION... */
    /* liberamos tablas */
    RELEASE B-CPEDM.
    RELEASE FacCorre.
    RELEASE Ccbcdocu.
    /* *********************** */
    DO ON ENDKEY UNDO, LEAVE:
        MESSAGE list_docs SKIP "CONFIRMAR IMPRESION DE DOCUMENTO(S)" VIEW-AS ALERT-BOX INFORMATION.
    END.
    /* IMPRIME FACTURAS O BOLETAS Y SUS ORDENES DE DESPACHO */
    FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed:
        FIND CcbCDocu WHERE
            CcbCDocu.CodCia = S-CodCia AND
            CcbCDocu.CodDiv = S-CodDiv AND
            CcbCDocu.CodDoc = T-CPEDM.CodRef AND
            CcbCDocu.NroDoc = T-CPEDM.NroRef
            NO-LOCK NO-ERROR. 
        IF AVAILABLE CcbCDocu THEN DO:
            IF Ccbcdocu.CodDoc = "FAC" THEN DO:
                CASE Ccbcdocu.coddiv:
                    WHEN '00002' THEN RUN ccb/r-fact02 (ROWID(ccbcdocu)).
                    WHEN '00005' THEN RUN ccb/r-fact00005 (ROWID(ccbcdocu)).
                    OTHERWISE RUN ccb/r-fact01 (ROWID(ccbcdocu)).
                END.
            END.
            IF Ccbcdocu.CodDoc = "BOL" THEN RUN ccb/r-bole01 (ROWID(ccbcdocu)).
            IF Ccbcdocu.CodDoc = "TCK" THEN RUN ccb/r-tick500 (ROWID(ccbcdocu)).
            FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
            IF AVAIL CcbDdocu THEN DO:
                CASE s-coddiv:
                    WHEN '00000' THEN RUN ccb/r-odesp (ROWID(ccbcdocu), CcbCDocu.CodAlm).
                    OTHERWISE RUN vtamay/r-odesp-001a (ROWID(ccbcdocu), CcbCDocu.CodAlm, 'ORIGINAL',NO).
                END CASE.
            END.
        END.
    END.

    /*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/





/* **************************************************************************

**************************************************************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-copia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copia Procedure 
PROCEDURE copia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
FIND FacCPedm WHERE ROWID(FacCPedm) = D-ROWID NO-LOCK NO-ERROR. 
IF NOT AVAILABLE FacCPedm THEN RETURN 'ADM-ERROR'.

/* AVISO DEL ADMINISTRADOR */
DEF VAR pRpta AS CHAR.
RUN ccb/d-msgblo (faccpedm.codcli, faccpedm.nrocard, OUTPUT pRpta).
IF pRpta = 'ADM-ERROR' THEN RETURN.
/* *********************** */

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
            gn-clie.codcia = CL-CODCIA AND
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
    RUN ccb/d-canped-02a(
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
    /* Creacion del Comprobante */
    FIND faccorre WHERE
        faccorre.codcia = s-codcia AND  
        faccorre.coddoc = s-coddoc AND  
        faccorre.NroSer = s-ptovta
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
    RUN proc_CreaComprobante.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    
    /**** ACTUALIZAMOS FLAG DEL PEDIDO  DE MOSTRADOR COMO ATENDIDO ****/
    ASSIGN FacCPedm.flgest = "C".
    FOR EACH Facdpedm OF Faccpedm:
        ASSIGN
            Facdpedm.canate = Facdpedm.canped
            Facdpedm.flgest = Faccpedm.flgest.
    END.
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
                Gn-Clie.Codcia = CL-CODCIA AND
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
FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed:
    FIND CcbCDocu WHERE 
        CcbCDocu.CodCia = S-CodCia AND
        CcbCDocu.CodDiv = S-CodDiv AND
        CcbCDocu.CodDoc = T-CPEDM.CodRef AND
        CcbCDocu.NroDoc = T-CPEDM.NroRef NO-LOCK NO-ERROR. 
    IF AVAILABLE CcbCDocu THEN DO:
        /* Cambiamos al formato similar al de ATE */
        IF Ccbcdocu.CodDoc = "FAC" THEN RUN vtamin/r-impfac2 (ROWID(ccbcdocu)).
        IF Ccbcdocu.CodDoc = "TCK" THEN DO:
            RUN vtamin/r-tick500a (ROWID(ccbcdocu)).
            /****
            CASE s-codter:
                WHEN "TERM04" THEN RUN vtamin/r-tick500 (ROWID(ccbcdocu)).
                OTHERWISE RUN vtamin/r-tick01 (ROWID(ccbcdocu)).
            END CASE.
            ****/
        END.
        FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
    END.
END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
        RELEASE Ccbdmov.

    END. /* DO TRANSACTION... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_CreaComprobante) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaComprobante Procedure 
PROCEDURE proc_CreaComprobante :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE i           AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE x_cto1      AS DECIMAL INITIAL 0.
DEFINE VARIABLE x_cto2      AS DECIMAL INITIAL 0.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH T-CPEDM BREAK BY T-CPEDM.NroPed:
        cCodAlm = TRIM(T-CPEDM.CodAlm).   /* << OJO << lo tomamos del pedido */
        /* Crea Documento */
        CREATE CcbCDocu.
        ASSIGN
            CcbCDocu.CodCia = S-CodCia
            CcbCDocu.CodDiv = S-CodDiv
            CcbCDocu.CodDoc = s-CodDoc
            Ccbcdocu.nrodoc = STRING(faccorre.nroser, "999") +
                STRING(FacCorre.Correlativo, "999999")
            Faccorre.correlativo = Faccorre.correlativo + 1.
        ASSIGN
            T-CPEDM.CodRef    = s-CodDoc
            T-CPEDM.NroRef    = ccbcdocu.nrodoc
            CcbCDocu.FchDoc   = TODAY
            CcbCDocu.usuario  = S-User-Id
            CcbCDocu.usrdscto = T-CPEDM.usrdscto 
            CcbCDocu.Tipo     = S-Tipo
            CcbCDocu.CodAlm   = cCodAlm
            CcbCDocu.CodCli   = T-CPEDM.Codcli
            CcbCDocu.RucCli   = T-CPEDM.RucCli 
            CcbCDocu.CodAnt   = T-CPEDM.Atencion
            CcbCDocu.NomCli   = T-CPEDM.Nomcli
            CcbCDocu.DirCli   = T-CPEDM.DirCli
            CcbCDocu.CodMon   = T-CPEDM.codmon
            CcbCDocu.CodMov   = S-CodMov
            CcbCDocu.CodVen   = T-CPEDM.codven
            CcbCDocu.FchCan   = TODAY
            CcbCDocu.FchVto   = TODAY
            CcbCDocu.ImpBrt   = T-CPEDM.impbrt
            CcbCDocu.ImpDto   = T-CPEDM.impdto
            CcbCDocu.ImpExo   = T-CPEDM.impexo
            CcbCDocu.ImpIgv   = T-CPEDM.impigv
            CcbCDocu.ImpIsc   = T-CPEDM.impisc
            CcbCDocu.ImpTot   = T-CPEDM.imptot
            CcbCDocu.ImpVta   = T-CPEDM.impvta
            CcbCDocu.TipVta   = "1" 
            CcbCDocu.TpoFac   = "C"
            CcbCDocu.FlgEst   = "P"
            CcbCDocu.FmaPgo   = T-CPEDM.FmaPgo
            CcbCDocu.CodPed   = T-CPEDM.coddoc
            CcbCDocu.NroPed   = B-CPEDM.NroPed
            CcbCDocu.PorIgv   = T-CPEDM.porigv 
            CcbCDocu.PorDto   = T-CPEDM.PorDto
            CcbCDocu.SdoAct   = T-CPEDM.imptot
            CcbCDocu.TpoCmb   = T-CPEDM.tpocmb
            CcbCDocu.Glosa    = T-CPEDM.Glosa
            CcbCDocu.TipBon[1] = T-CPEDM.TipBon[1]
            CcbCDocu.NroCard  = T-CPEDM.NroCard 
            CcbCDocu.FlgEnv   = B-CPEDM.FlgEnv. /* OJO Control de envio de documento */

        IF FIRST-OF(T-CPEDM.NroPed) THEN DO:         
            IF cMess <> "" THEN ASSIGN CcbCDocu.Libre_c05 = cMess.        
        END.

        /* Lista de Docs para el Message */
        IF list_docs = "" THEN list_docs = ccbcdocu.coddoc + " " + Ccbcdocu.nrodoc.
        ELSE list_docs = list_docs + CHR(10) + ccbcdocu.coddoc + " " + Ccbcdocu.nrodoc.
        /* Guarda Centro de Costo */
        FIND gn-ven WHERE
            gn-ven.codcia = s-codcia AND
            gn-ven.codven = ccbcdocu.codven
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN ccbcdocu.cco = gn-ven.cco.
        /* Guarda Tipo de Entrega */
        ASSIGN
            CcbCDocu.CodAge = T-CPEDM.CodTrans
            CcbCDocu.FlgSit = IF T-CPEDM.DocDesp = "GUIA" THEN "G" ELSE ""
            CcbCDocu.FlgCon = IF T-CPEDM.DocDesp = "GUIA" THEN "G" ELSE "".
        IF B-CPEDM.FmaPgo = "001" THEN CcbCDocu.FlgCon = "E".
        IF B-CPEDM.FmaPgo = "002" THEN CcbCDocu.FlgCon = "A".
        /* TRACKING */
        FIND Almacen OF Ccbcdocu NO-LOCK.
        s-FechaT = DATETIME(TODAY, MTIME).
        RUN gn/pTracking-01 (s-CodCia,
                          Almacen.CodDiv,
                          B-CPEDM.CodDoc,
                          B-CPEDM.NroPed,
                          s-User-Id,
                          'EFAC',
                          'P',
                          s-FechaI,
                          s-FechaT,
                          Ccbcdocu.CodDoc,
                          Ccbcdocu.NroDoc,
                          B-CPEDM.CodDoc,
                          B-CPEDM.NroPed).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

        /* Actualiza Detalle */
        i = 1.
        FOR EACH T-DPEDM OF T-CPEDM BY nroitm:
            CREATE CcbDDocu.
            ASSIGN
                CcbDDocu.CodCia = ccbcdocu.codcia
                CcbDDocu.CodDiv = ccbcdocu.coddiv
                CcbDDocu.CodDoc = ccbcdocu.coddoc
                CcbDDocu.NroDoc = ccbcdocu.nrodoc
                CcbDDocu.codmat = T-DPEDM.codmat
                CcbDDocu.Factor = T-DPEDM.factor
                CcbDDocu.ImpDto = T-DPEDM.impdto
                CcbDDocu.ImpIgv = T-DPEDM.impigv
                CcbDDocu.ImpIsc = T-DPEDM.impisc
                CcbDDocu.ImpLin = T-DPEDM.implin
                CcbDDocu.AftIgv = T-DPEDM.aftigv
                CcbDDocu.AftIsc = T-DPEDM.aftisc
                CcbDDocu.CanDes = T-DPEDM.canped
                CcbDDocu.NroItm = i
                CcbDDocu.PorDto = T-DPEDM.pordto
                CcbDDocu.PreBas = T-DPEDM.prebas
                CcbDDocu.PreUni = T-DPEDM.preuni
                CcbDDocu.PreVta[1] = T-DPEDM.prevta[1]
                CcbDDocu.PreVta[2] = T-DPEDM.prevta[2]
                CcbDDocu.PreVta[3] = T-DPEDM.prevta[3]
                CcbDDocu.UndVta = T-DPEDM.undvta
                CcbDDocu.AlmDes = T-DPEDM.AlmDes
                CcbDDocu.Por_Dsctos[1] = T-DPEDM.Por_Dsctos[1]
                CcbDDocu.Por_Dsctos[2] = T-DPEDM.Por_Dsctos[2]
                CcbDDocu.Por_Dsctos[3] = T-DPEDM.Por_Dsctos[3]
                CcbDDocu.Flg_factor = T-DPEDM.Flg_factor
                CcbDDocu.FchDoc = TODAY.
            i = i + 1.
            /* Guarda Costos */
            FIND Almmmatg WHERE
                Almmmatg.CodCia = S-CODCIA AND
                Almmmatg.codmat = CcbDDocu.Codmat 
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmatg THEN DO: 
                IF almmmatg.monvta = 1 THEN DO:
                    x_cto1 = ROUND(Almmmatg.Ctotot *
                        CcbDDocu.CanDes * CcbDDocu.Factor,2).
                    x_cto2 = ROUND((Almmmatg.Ctotot *
                        CcbDDocu.CanDes * CcbDDocu.Factor) / Almmmatg.Tpocmb,2).
                END.
                IF almmmatg.monvta = 2 THEN DO:
                    x_cto1 = ROUND(Almmmatg.Ctotot * CcbDDocu.CanDes *
                        CcbDDocu.Factor * Almmmatg.TpoCmb, 2).
                    x_cto2 = ROUND((Almmmatg.Ctotot * CcbDDocu.CanDes *
                        CcbDDocu.Factor), 2).
                end.
                CcbDDocu.ImpCto =
                    IF CcbCDocu.Codmon = 1 THEN x_cto1 ELSE x_cto2.
            END.
            CcbCDocu.ImpCto = CcbCDocu.ImpCto + CcbDDocu.ImpCto.
        END. /* FOR EACH T-DPEDM OF... */
    END. /* FOR EACH T-CPEDM... */
END.

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

    DEFINE VARIABLE x_igv AS DECIMAL NO-UNDO.
    DEFINE VARIABLE x_isc AS DECIMAL NO-UNDO.
    DEFINE VARIABLE x_NewPed AS LOGICAL INIT YES NO-UNDO.
    DEFINE VARIABLE i_NPed   AS INTEGER INIT 0.
    DEFINE VARIABLE i_NItem  AS INTEGER INIT 0.

    FOR EACH T-CPEDM:
        DELETE T-CPEDM.
    END.
    FOR EACH T-DPEDM:
        DELETE T-DPEDM.
    END.

    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

    FOR EACH FacDPedm OF FacCPedm NO-LOCK
        BREAK BY FacDPedm.CodCia BY TRIM(FacDPedm.AlmDes): 
        IF FIRST-OF(TRIM(FacDPedm.AlmDes)) OR x_NewPed THEN DO:
            i_NPed = i_NPed + 1.
            CREATE T-CPEDM.
            BUFFER-COPY FacCPedm TO T-CPEDM
                ASSIGN
                    T-CPEDM.NroPed =
                        SUBSTRING(FacCPedm.NroPed,1,3) + STRING(i_NPed,"999999")
                    T-CPEDM.CodAlm = TRIM(FacDPedm.AlmDes)        /* OJO */
                    T-CPEDM.ImpBrt = 0
                    T-CPEDM.ImpDto = 0
                    T-CPEDM.ImpExo = 0
                    T-CPEDM.ImpIgv = 0
                    T-CPEDM.ImpIsc = 0
                    T-CPEDM.ImpTot = 0
                    T-CPEDM.ImpVta = 0
                    T-CPEDM.NroCard = FacCPedm.NroCard.
            x_igv = 0.
            x_isc = 0.
            x_NewPed = NO.
            i_NItem = 0.
        END.

        ASSIGN
            x_igv = x_igv + FacDPedm.ImpIgv
            x_isc = x_isc + FacDPedm.ImpIsc
            T-CPEDM.ImpTot = T-CPEDM.ImpTot + FacDPedm.ImpLin.

        /* No Imponible */
        IF NOT FacDPedm.AftIgv THEN DO:
            T-CPEDM.ImpExo = T-CPEDM.ImpExo + FacDPedm.ImpLin.
            T-CPEDM.ImpDto = T-CPEDM.ImpDto + FacDPedm.ImpDto.
        END.
        /* Imponible */
        ELSE DO:
            T-CPEDM.ImpDto = T-CPEDM.ImpDto +
                ROUND(FacDPedm.ImpDto / (1 + FacCPedm.PorIgv / 100),2).
        END.

        CREATE T-DPEDM.
            BUFFER-COPY FacDPedm TO T-DPEDM
                ASSIGN T-DPEDM.NroPed = T-CPEDM.NroPed.

        i_NItem = i_NItem + 1.
        IF (T-CPEDM.Cmpbnte = "BOL" AND i_NItem >= FacCfgGn.Items_Boleta) OR
            (T-CPEDM.Cmpbnte = "FAC" AND i_NItem >= FacCfgGn.Items_Factura) THEN DO:
            x_NewPed = YES.
        END.

        IF LAST-OF(TRIM(FacDPedm.AlmDes)) OR x_NewPed THEN DO:
            ASSIGN 
                T-CPEDM.ImpIgv = ROUND(x_igv,2)
                T-CPEDM.ImpIsc = ROUND(x_isc,2)
                T-CPEDM.ImpVta = T-CPEDM.ImpTot - T-CPEDM.ImpExo - T-CPEDM.ImpIgv.
            /*** DESCUENTO GLOBAL ****/
            IF T-CPEDM.PorDto > 0 THEN DO:
                ASSIGN
                    T-CPEDM.ImpDto = T-CPEDM.ImpDto +
                        ROUND((T-CPEDM.ImpVta + T-CPEDM.ImpExo) *
                        T-CPEDM.PorDto / 100,2)
                    T-CPEDM.ImpTot = ROUND(T-CPEDM.ImpTot *
                        (1 - T-CPEDM.PorDto / 100),2)
                    T-CPEDM.ImpVta = ROUND(T-CPEDM.ImpVta *
                        (1 - T-CPEDM.PorDto / 100),2)
                    T-CPEDM.ImpExo = ROUND(T-CPEDM.ImpExo *
                        (1 - T-CPEDM.PorDto / 100),2)
                    T-CPEDM.ImpIgv =
                        T-CPEDM.ImpTot - T-CPEDM.ImpExo - T-CPEDM.ImpVta.
            END.
            T-CPEDM.ImpBrt =
                T-CPEDM.ImpVta + T-CPEDM.ImpIsc + T-CPEDM.ImpDto + T-CPEDM.ImpExo.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_CreTmp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreTmp Procedure 
PROCEDURE proc_CreTmp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE x_igv AS DECIMAL NO-UNDO.
    DEFINE VARIABLE x_isc AS DECIMAL NO-UNDO.
    DEFINE VARIABLE x_NewPed AS LOGICAL INIT YES NO-UNDO.
    DEFINE VARIABLE i_NPed   AS INTEGER INIT 0.
    DEFINE VARIABLE i_NItem  AS INTEGER INIT 0.

    FOR EACH T-CPEDM:
        DELETE T-CPEDM.
    END.
    FOR EACH T-DPEDM:
        DELETE T-DPEDM.
    END.

    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

    FOR EACH FacDPedm OF FacCPedm NO-LOCK
        BREAK BY FacDPedm.CodCia BY TRIM(FacDPedm.AlmDes): 
        IF FIRST-OF(TRIM(FacDPedm.AlmDes)) OR x_NewPed THEN DO:
            i_NPed = i_NPed + 1.
            CREATE T-CPEDM.
            BUFFER-COPY FacCPedm TO T-CPEDM
                ASSIGN
                    T-CPEDM.NroPed =
                        SUBSTRING(FacCPedm.NroPed,1,3) + STRING(i_NPed,"999999")
                    T-CPEDM.CodAlm = TRIM(FacDPedm.AlmDes)        /* OJO */
                    T-CPEDM.ImpBrt = 0
                    T-CPEDM.ImpDto = 0
                    T-CPEDM.ImpExo = 0
                    T-CPEDM.ImpIgv = 0
                    T-CPEDM.ImpIsc = 0
                    T-CPEDM.ImpTot = 0
                    T-CPEDM.ImpVta = 0
                    T-CPEDM.NroCard = FacCPedm.NroCard.
            x_igv = 0.
            x_isc = 0.
            x_NewPed = NO.
            i_NItem = 0.
        END.

        ASSIGN
            x_igv = x_igv + FacDPedm.ImpIgv
            x_isc = x_isc + FacDPedm.ImpIsc
            T-CPEDM.ImpTot = T-CPEDM.ImpTot + FacDPedm.ImpLin.

        /* No Imponible */
        IF NOT FacDPedm.AftIgv THEN DO:
            T-CPEDM.ImpExo = T-CPEDM.ImpExo + FacDPedm.ImpLin.
            T-CPEDM.ImpDto = T-CPEDM.ImpDto + FacDPedm.ImpDto.
        END.
        /* Imponible */
        ELSE DO:
            T-CPEDM.ImpDto = T-CPEDM.ImpDto +
                ROUND(FacDPedm.ImpDto / (1 + FacCPedm.PorIgv / 100),2).
        END.

        CREATE T-DPEDM.
            BUFFER-COPY FacDPedm TO T-DPEDM
                ASSIGN T-DPEDM.NroPed = T-CPEDM.NroPed.

        i_NItem = i_NItem + 1.
        IF (T-CPEDM.Cmpbnte = "BOL" AND i_NItem >= FacCfgGn.Items_Boleta) OR
            (T-CPEDM.Cmpbnte = "FAC" AND i_NItem >= FacCfgGn.Items_Factura) THEN DO:
            x_NewPed = YES.
        END.

        IF LAST-OF(TRIM(FacDPedm.AlmDes)) OR x_NewPed THEN DO:
            ASSIGN 
                T-CPEDM.ImpIgv = ROUND(x_igv,2)
                T-CPEDM.ImpIsc = ROUND(x_isc,2)
                T-CPEDM.ImpVta = T-CPEDM.ImpTot - T-CPEDM.ImpExo - T-CPEDM.ImpIgv.
            /*** DESCUENTO GLOBAL ****/
            IF T-CPEDM.PorDto > 0 THEN DO:
                ASSIGN
                    T-CPEDM.ImpDto = T-CPEDM.ImpDto +
                        ROUND((T-CPEDM.ImpVta + T-CPEDM.ImpExo) *
                        T-CPEDM.PorDto / 100,2)
                    T-CPEDM.ImpTot = ROUND(T-CPEDM.ImpTot *
                        (1 - T-CPEDM.PorDto / 100),2)
                    T-CPEDM.ImpVta = ROUND(T-CPEDM.ImpVta *
                        (1 - T-CPEDM.PorDto / 100),2)
                    T-CPEDM.ImpExo = ROUND(T-CPEDM.ImpExo *
                        (1 - T-CPEDM.PorDto / 100),2)
                    T-CPEDM.ImpIgv =
                        T-CPEDM.ImpTot - T-CPEDM.ImpExo - T-CPEDM.ImpVta.
            END.
            T-CPEDM.ImpBrt =
                T-CPEDM.ImpVta + T-CPEDM.ImpIsc + T-CPEDM.ImpDto + T-CPEDM.ImpExo.
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

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed:
          FIND FIRST CcbCDocu WHERE 
              CcbCDocu.CodCia = S-CodCia AND
              CcbCDocu.CodDoc = T-CPEDM.CodRef AND
              CcbCDocu.NroDoc = T-CPEDM.NroRef AND
              CcbCDocu.CodAlm = TRIM(T-CPEDM.CodAlm)
              EXCLUSIVE-LOCK NO-ERROR. 
          IF NOT AVAILABLE CcbCDocu THEN DO:
              RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
              UNDO, RETURN 'ADM-ERROR'.
          END.
          /* Correlativo de Salida */
          FIND Almacen WHERE 
              Almacen.CodCia = CcbCDocu.CodCia AND  
              Almacen.CodAlm = TRIM(CcbCDocu.CodAlm)
              EXCLUSIVE-LOCK NO-ERROR.
          IF ERROR-STATUS:ERROR THEN DO:
              RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
              UNDO, RETURN 'ADM-ERROR'.
          END.
          CREATE Almcmov.
          ASSIGN
              Almcmov.CodCia  = CcbCDocu.CodCia
              Almcmov.CodAlm  = TRIM(CcbCDocu.CodAlm)
              Almcmov.TipMov  = "S"
              Almcmov.CodMov  = CcbCDocu.CodMov
              Almcmov.NroSer  = s-PtoVta
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
              CcbcDocu.NroSal = STRING(Almcmov.NroDoc)
              Almacen.CorrSal = Almacen.CorrSal + 1.
          FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
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
      RELEASE Almacen.
      RELEASE almcmov.
      RELEASE almdmov.
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
        IF NOT AVAILABLE FacCorre THEN RETURN 'ADM-ERROR'.

        FIND FIRST T-CcbCCaja.

        /* Crea Cabecera de Caja */
        CREATE CcbCCaja.
        ASSIGN
            CcbCCaja.CodCia     = s-CodCia
            CcbCCaja.CodDiv     = s-CodDiv 
            CcbCCaja.CodDoc     = s-CodCja
            CcbCCaja.NroDoc     = STRING(FacCorre.NroSer,"999") +
                STRING(FacCorre.Correlativo,"999999")
            FacCorre.Correlativo = FacCorre.Correlativo + 1
            CcbCCaja.CodCaja    = s-CodTer
            CcbCCaja.usuario    = s-user-id
            CcbCCaja.CodCli     = B-CPEDM.codcli
            CcbCCaja.NomCli     = B-CPEDM.NomCli
            CcbCCaja.CodMon     = B-CPEDM.CodMon
            CcbCCaja.FchDoc     = TODAY
            CcbCCaja.CodBco[2]  = T-CcbCCaja.CodBco[2]
            CcbCCaja.CodBco[3]  = T-CcbCCaja.CodBco[3]
            CcbCCaja.CodBco[4]  = T-CcbCCaja.CodBco[4]
            CcbCCaja.CodBco[5]  = T-CcbCCaja.CodBco[5]
            CcbCCaja.CodBco[8]  = T-CcbCCaja.CodBco[8]
            CcbCCaja.ImpNac[1]  = T-CcbCCaja.ImpNac[1]
            CcbCCaja.ImpNac[2]  = T-CcbCCaja.ImpNac[2]
            CcbCCaja.ImpNac[3]  = T-CcbCCaja.ImpNac[3]
            CcbCCaja.ImpNac[4]  = T-CcbCCaja.ImpNac[4]
            CcbCCaja.ImpNac[5]  = T-CcbCCaja.ImpNac[5]
            CcbCCaja.ImpNac[6]  = T-CcbCCaja.ImpNac[6]
            CcbCCaja.ImpNac[7]  = T-CcbCCaja.ImpNac[7]            
            CcbCCaja.ImpNac[8]  = T-CcbCCaja.ImpNac[8]
            CcbCCaja.ImpNac[9]  = T-CcbCCaja.ImpNac[9]
            CcbCCaja.ImpNac[10] = T-CcbCCaja.ImpNac[10]
            CcbCCaja.ImpUsa[1]  = T-CcbCCaja.ImpUsa[1]
            CcbCCaja.ImpUsa[2]  = T-CcbCCaja.ImpUsa[2]
            CcbCCaja.ImpUsa[3]  = T-CcbCCaja.ImpUsa[3]
            CcbCCaja.ImpUsa[4]  = T-CcbCCaja.ImpUsa[4] 
            CcbCCaja.ImpUsa[5]  = T-CcbCCaja.ImpUsa[5]
            CcbCCaja.ImpUsa[6]  = T-CcbCCaja.ImpUsa[6]
            CcbCCaja.ImpUsa[7]  = T-CcbCCaja.ImpUsa[7]
            CcbCCaja.ImpUsa[8]  = T-CcbCCaja.ImpUsa[8]
            CcbCCaja.ImpUsa[9]  = T-CcbCCaja.ImpUsa[9]
            CcbCCaja.ImpUsa[10] = T-CcbCCaja.ImpUsa[10]
            CcbCCaja.Tipo       = s-Tipo
            CcbCCaja.TpoCmb     = T-CcbCCaja.TpoCmb
            CcbCCaja.Voucher[2] = T-CcbCCaja.Voucher[2]
            CcbCCaja.Voucher[3] = T-CcbCCaja.Voucher[3]
            CcbCCaja.Voucher[4] = T-CcbCCaja.Voucher[4] 
            CcbCCaja.Voucher[5] = T-CcbCCaja.Voucher[5] 
            CcbCCaja.Voucher[6] = T-CcbCCaja.Voucher[6]
            CcbCCaja.Voucher[7] = T-CcbCCaja.Voucher[7]
            CcbCCaja.Voucher[8] = T-CcbCCaja.Voucher[8]
            CcbCCaja.Voucher[9] = T-CcbCCaja.Voucher[9]
            CcbCCaja.Voucher[10] = T-CcbCCaja.Voucher[10]
            CcbCCaja.FchVto[2]  = T-CcbCCaja.FchVto[2]
            CcbCCaja.FchVto[3]  = T-CcbCCaja.FchVto[3]
            CcbCCaja.VueNac     = T-CcbCCaja.VueNac 
            CcbCCaja.VueUsa     = T-CcbCCaja.VueUsa
            CcbCCaja.FLGEST     = "C".

        RELEASE faccorre.
    
        /* Crea Detalle de Caja */
        FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed:
            FIND CcbCDocu WHERE
                CcbCDocu.CodCia = S-CodCia AND
                CcbCDocu.CodDiv = S-CodDiv AND
                CcbCDocu.CodDoc = T-CPEDM.CodRef AND
                CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR. 
            IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.
            CREATE CcbDCaja.
            ASSIGN
                CcbDCaja.CodCia = CcbCCaja.CodCia
                CcbdCaja.CodDiv = CcbCCaja.CodDiv
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

&IF DEFINED(EXCLUDE-proc_OrdDes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_OrdDes Procedure 
PROCEDURE proc_OrdDes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR F-CODDOC AS CHAR NO-UNDO.
    DEFINE VAR I-Nroped AS INTEGER NO-UNDO.
    DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.

    F-CODDOC = 'O/D'.
    FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":
        FIND FIRST CcbCDocu WHERE
            CcbCDocu.CodCia = S-CodCia AND
            CcbCDocu.CodDoc = T-CPEDM.CodRef AND
            CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN DO:
            /* RHC 29.05.04 se usa el correlativo del almacen de descarga */
            FIND FIRST FacCorre WHERE
                faccorre.codcia = s-codcia AND
                faccorre.coddoc = f-coddoc AND
                faccorre.codalm = ccbcdocu.codalm
                EXCLUSIVE-LOCK NO-ERROR.                             
            IF AVAILABLE FacCorre THEN DO:
                I-NroPed = FacCorre.Correlativo.
                CREATE FacCPedi NO-ERROR.
                ASSIGN
                    FacCPedi.CodCia = S-CodCia
                    FacCPedi.CodDoc = F-CodDoc
                    FacCPedi.NroPed = STRING(s-ptovta,"999") + STRING(I-NroPed,"999999")
                    FacCorre.Correlativo = FacCorre.Correlativo + 1.
                RELEASE FacCorre.
                ASSIGN
                    FacCPedi.FchPed = CcbCDocu.FchDoc
                    FacCPedi.CodAlm = trim(CcbCDocu.CodAlm)
                    FacCPedi.PorIgv = CcbCDocu.PorIgv 
                    FacCPedi.TpoCmb = CcbCDocu.TpoCmb
                    FacCPedi.CodDiv = CcbCDocu.CodDiv
                    FacCPedi.Nroref = CcbCDocu.NroPed
                    FacCPedi.Tpoped = 'MOSTRADOR'
                    FacCPedi.Hora   = STRING(TIME,"HH:MM")
                    FacCPedi.TipVta = CcbCDocu.Tipvta
                    FacCPedi.Codcli = CcbCDocu.Codcli
                    FacCPedi.NomCli = CcbCDocu.Nomcli
                    FacCPedi.DirCli = CcbCDocu.DirCli
                    FacCPedi.Codven = CcbCDocu.Codven
                    FacCPedi.Fmapgo = CcbCDocu.Fmapgo
                    FacCPedi.Glosa  = CcbCDocu.Glosa
                    FacCPedi.LugEnt = CcbCDocu.Lugent
                    FacCPedi.ImpBrt = CcbCDocu.ImpBrt
                    FacCPedi.ImpDto = CcbCDocu.ImpDto
                    FacCPedi.ImpVta = CcbCDocu.ImpVta
                    FacCPedi.ImpExo = CcbCDocu.ImpExo
                    FacCPedi.ImpIgv = CcbCDocu.ImpIgv
                    FacCPedi.ImpIsc = CcbCDocu.ImpIsc
                    FacCPedi.ImpTot = CcbCDocu.ImpTot
                    FacCPedi.Flgest = 'F'
                    FacCPedi.Cmpbnte  = CcbCDocu.CodDoc
                    FacCPedi.NCmpbnte = CcbCDocu.Nrodoc
                    FacCPedi.CodTrans = CcbCDocu.CodAge
                    FacCPedi.Usuario  = S-USER-ID.
                FOR EACH CcbDDocu OF CcbCDocu BY NroItm:
                    CREATE FacDPedi. 
                    ASSIGN
                        FacDPedi.CodCia = FacCPedi.CodCia 
                        FacDPedi.coddoc = FacCPedi.coddoc 
                        FacDPedi.NroPed = FacCPedi.NroPed 
                        FacDPedi.FchPed = FacCPedi.FchPed
                        FacDPedi.Hora   = FacCPedi.Hora 
                        FacDPedi.FlgEst = FacCPedi.FlgEst
                        FacDPedi.codmat = trim(CcbDDocu.codmat) 
                        FacDPedi.Factor = CcbDDocu.Factor 
                        FacDPedi.CanPed = CcbDDocu.CanDes
                        FacDPedi.ImpDto = CcbDDocu.ImpDto 
                        FacDPedi.ImpLin = CcbDDocu.ImpLin 
                        FacDPedi.PorDto = CcbDDocu.PorDto 
                        FacDPedi.PorDto2 = CcbDDocu.PorDto2 
                        FacDPedi.PreUni = CcbDDocu.PreUni 
                        FacDPedi.UndVta = CcbDDocu.UndVta 
                        FacDPedi.AftIgv = CcbDDocu.AftIgv 
                        FacDPedi.AftIsc = CcbDDocu.AftIsc 
                        FacDPedi.ImpIgv = CcbDDocu.ImpIgv 
                        FacDPedi.ImpIsc = CcbDDocu.ImpIsc 
                        FacDPedi.PreBas = CcbDDocu.PreBas
                        FacDPedi.Por_Dsctos[1] = CcbDDocu.Por_Dsctos[1]
                        FacDPedi.Por_Dsctos[2] = CcbDDocu.Por_Dsctos[2]
                        FacDPedi.Por_Dsctos[3] = CcbDDocu.Por_Dsctos[3]
                        FacDPedi.Flg_factor = CcbDDocu.Flg_factor.
                END.
                ASSIGN
                    CcbCDocu.CodRef = FacCPedi.CodDoc
                    CcbCDocu.NroRef = FacCPedi.NroPed.
                RELEASE FacDPedi.
                RELEASE FacCPedi.       
            END.
        END.
        RELEASE CcbCDocu.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_verifica_ic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_verifica_ic Procedure 
PROCEDURE proc_verifica_ic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lFoundIC AS LOGICAL NO-UNDO.

    /* Busca I/C tipo "Sencillo" Activo */
    IF NOT s-codter BEGINS "ATE" THEN DO:
        lFoundIC = FALSE.
        FOR EACH ccbccaja WHERE
            ccbccaja.codcia = s-codcia AND
            ccbccaja.coddiv >= "" AND
            ccbccaja.coddoc = "I/C" AND
            ccbccaja.tipo = "SENCILLO" AND
            ccbccaja.codcaja = s-codter AND
            ccbccaja.flgcie = "P" NO-LOCK:
            IF CcbCCaja.FlgEst <> "A" THEN lFoundIC = TRUE.
        END.
        IF NOT lFoundIC THEN DO:
            MESSAGE
                "Se debe ingresar el I/C SENCILLO como primer movimiento"
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Temporal-de-Retenciones) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Temporal-de-Retenciones Procedure 
PROCEDURE Temporal-de-Retenciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE dTpoCmb     LIKE CcbcCaja.TpoCmb NO-UNDO.

    /* Retenciones */
    FOR EACH wrk_ret:
        DELETE wrk_ret.
    END.
    /* N/C */
    FOR EACH wrk_dcaja:
        DELETE wrk_dcaja.
    END.
    IF B-CPEDM.CodDoc = "FAC" AND       /* Solo Facturas */
        B-CPEDM.ImpTot > 0 THEN DO:
        /* Tipo de Cambio Caja */
        dTpoCmb = 1.
        FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-tccja THEN DO:
            IF B-CPEDM.Codmon = 1 THEN dTpoCmb = Gn-tccja.Compra.
            ELSE dTpoCmb = Gn-tccja.Venta.
        END.
        FIND gn-clie WHERE
            gn-clie.codcia = cl-codcia AND
            gn-clie.codcli = B-CPEDM.CodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie AND gn-clie.rucold = "Si" THEN DO:     /* AGENTE RETENEDOR */
            CREATE wrk_ret.
            ASSIGN
                wrk_ret.CodCia = B-CPEDM.Codcia
                wrk_ret.CodCli = B-CPEDM.CodCli
                wrk_ret.CodDoc = B-CPEDM.CodDoc
                wrk_ret.NroDoc = B-CPEDM.NroPed
                wrk_ret.FchDoc = B-CPEDM.FchPed
                wrk_ret.CodRef = s-CodCja                    
                wrk_ret.NroRef = ""
                wrk_ret.CodMon = "S/."
                cNomcli = gn-clie.nomcli.
            /* OJO: Cálculo de Retenciones Siempre en Soles */
            IF B-CPEDM.Codmon = 1 THEN DO:
                wrk_ret.ImpTot = B-CPEDM.imptot.
                wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
            END.
            ELSE DO:
                wrk_ret.ImpTot = ROUND((B-CPEDM.imptot * dTpoCmb),2).
                wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

