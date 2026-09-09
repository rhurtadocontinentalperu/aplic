&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-Tickets NO-UNDO LIKE VtaDTickets.
DEFINE NEW SHARED TEMP-TABLE T-VALES NO-UNDO LIKE VtaVales.
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

DEFINE NEW SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

DEF NEW SHARED VAR s-PtoVta AS INT.
DEF NEW SHARED VAR s-codcli LIKE gn-clie.codcli.
DEF NEW SHARED VAR s-tipo   AS CHAR INITIAL "MOSTRADOR".
DEF NEW SHARED VAR s-CodMov LIKE Almtmovm.Codmov.
DEF NEW SHARED VAR s-codcja AS CHAR INITIAL "I/C".
DEF NEW SHARED VAR s-sercja AS INT.

DEFINE BUFFER B-CPEDM FOR FacCPedi.
DEFINE BUFFER B-DPEDM FOR Facdpedi.

DEFINE SHARED VAR s-User-Id AS CHAR.
DEFINE SHARED VAR s-CodCia AS INT.
DEFINE SHARED VAR CL-CodCia AS INT.
DEFINE SHARED VAR s-CodDiv AS CHAR.
DEFINE SHARED VAR s-CodTer LIKE ccbcterm.codter.
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

DEFINE TEMP-TABLE T-CPEDM LIKE FacCPedi.
DEFINE TEMP-TABLE T-DPEDM LIKE FacDPedi.

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

/* TEMPORALES DE ORDENES DE DESPACHO */
DEFINE TEMP-TABLE T-CODES LIKE FacCPedi.
DEFINE TEMP-TABLE T-DODES LIKE FacDPedi.

/* TEMPORALES DE COMPROBANTES */
DEFINE TEMP-TABLE T-CDOCU LIKE CcbCDocu.

{ccb\i-ChqUser.i}

/* Control del documento Ingreso Caja por terminal */
FIND FIRST ccbdterm WHERE
    CcbDTerm.CodCia = s-codcia AND
    CcbDTerm.CodDiv = s-coddiv AND
    CcbDTerm.CodDoc = s-codcja AND
    CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbdterm THEN DO:
    MESSAGE
       "EL DOCUMENTO INGRESO DE CAJA NO ESTA CONFIGURADO EN ESTE TERMINAL"
       VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-sercja = ccbdterm.nroser.

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
      TABLE: T-Tickets T "NEW SHARED" NO-UNDO INTEGRAL VtaDTickets
      TABLE: T-VALES T "NEW SHARED" NO-UNDO INTEGRAL VtaVales
      TABLE: T-VVALE T "NEW SHARED" NO-UNDO INTEGRAL VtaVVale
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 11.23
         WIDTH              = 90.29.
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

FIND Faccpedi WHERE ROWID(Faccpedi) = D-ROWID NO-LOCK NO-ERROR. 
IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.

    /* AVISO DEL ADMINISTRADOR */
    DEF VAR pRpta AS CHAR.
    RUN ccb/d-msgblo (Faccpedi.codcli, Faccpedi.nrocard, OUTPUT pRpta).
    IF pRpta = 'ADM-ERROR' THEN RETURN.
    /* *********************** */

    /* Verifica I/C */
    RUN proc_verifica_ic.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    FIND B-CPEDM WHERE ROWID(B-CPEDM) = d-rowid NO-LOCK NO-ERROR. 

    /* NUMERO DE SERIE DEL COMPROBANTE PARA TERMINAL */
    s-CodDoc = 'TCK'.
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
    /* Retenciones y N/C */
    RUN Temporal-de-Retenciones.

    /* VENTANA DE CANCELACIÓN */
    RUN vta2/d-canped-min(
        B-CPEDM.codmon,     /* Moneda Documento */
        B-CPEDM.imptot,     /* Importe Total */
        monto_ret,          /* Retención */
        B-CPEDM.NomCli,     /* Nombre Cliente */
        TRUE,               /* Venta Contado */
        B-CPEDM.FlgSit,     /* Pago con Tarjeta de Crédito */
        B-CPEDM.Libre_c03,  /* Banco */
        B-CPEDM.Libre_c04,  /* Tarjeta */
        B-CPEDM.Libre_C02,  /* Proveedor tickets */
        B-CPEDM.Atencion,   /* DNI */
        OUTPUT L-OK).       /* Flag Retorno */
    IF L-OK = NO THEN RETURN "ADM-ERROR".

    /*Busca Promocion*/
    RUN vtagn/r-promociones-04 (d-rowid,OUTPUT cMess).      

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* FIJAMOS EL PEDIDO EN UN PUNTERO DEL BUFFER */
        FIND B-CPEDM WHERE ROWID(B-CPEDM) = d-rowid EXCLUSIVE-LOCK NO-ERROR. 
        IF NOT AVAILABLE B-CPEDM THEN UNDO, RETURN 'ADM-ERROR'.
        /* ****************************************** */
        IF B-CPEDM.FlgEst <> "P" THEN DO:
            MESSAGE
                "Pedido mostrador ya no esta PENDIENTE"
                VIEW-AS ALERT-BOX ERROR.
            /*RELEASE B-CPEDM.*/
            /*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/
            RETURN 'ADM-ERROR'.
        END.
        
        /* CREACION DE LAS ORDENES DE DESPACHO */
        RUN Crea-Ordenes.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
         /******************************** */
        
        /* CREACION DE COMPROBANTES A PARTIR DE LAS ORDENES DE DESPACHO */
        RUN Crea-Comprobantes.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /* ************************ */

        /* Actualiza Flag del pedido */
        ASSIGN B-CPEDM.flgest = "C".        /* Pedido Mostrador CERRADO */
        FOR EACH Facdpedi OF B-CPEDM:
            ASSIGN
                Facdpedi.canate = Facdpedi.canped.
        END.
        /* ************************* */

        /* CREACION DE OTROS DOCUMENTOS ANEXOS */
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

        /* Actualiza Control de Vales de Compras */
        /* Se va a aplicar todo lo que se pueda */
        DEF VAR x-Importe-Vales AS DEC NO-UNDO.

        x-Importe-Vales = T-CcbCCaja.ImpNac[10] + T-CcbCCaja.ImpUsa[10] * T-CcbCCaja.TpoCmb.
        FOR EACH T-VALES:
            FIND VtaVales WHERE VtaVales.codcia = s-codcia
                AND VtaVales.nrodoc = T-VALES.nrodoc
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaVales THEN DO:
                MESSAGE 'NO se pudo actualizar el vale de consumo' T-VALES.nrodoc
                    VIEW-AS ALERT-BOX ERROR.
                UNDO, RETURN "ADM-ERROR".
            END.
            IF VtaVales.FlgEst <> "P" THEN DO:
                MESSAGE 'El vale de consumo' T-VALES.nrodoc 'acaba de ser utilizado en otra caja' 
                    VIEW-AS ALERT-BOX ERROR.
                UNDO, RETURN "ADM-ERROR".
            END.
            ASSIGN
                VtaVales.CodDiv = s-coddiv
                VtaVales.CodRef = "I/C"
                VtaVales.FchApl = DATETIME(TODAY, MTIME)
                VtaVales.FlgEst = 'C'
                VtaVales.NroRef = NroDocCja
                VtaVales.UsrApli = s-user-id.
            IF VtaVales.CodMon = 1 THEN DO:
                VtaVales.ImpApl = MINIMUM(x-Importe-Vales, VtaVales.ImpVal).
                x-Importe-Vales = x-Importe-Vales - VtaVales.ImpVal.
            END.
            IF VtaVales.CodMon = 2 THEN DO:
                VtaVales.ImpApl = MINIMUM(x-Importe-Vales / T-CcbCCaja.TpoCmb, VtaVales.ImpVal).
                x-Importe-Vales = x-Importe-Vales - VtaVales.ImpVal * T-CcbCCaja.TpoCmb.
            END.
            IF x-Importe-Vales <= 0 THEN x-Importe-Vales = 0.
        END.

        /* ACTUALIZA CONTROL DE TICKETS */
        RUN Actualiza-Tickets.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    END. /* DO TRANSACTION... */
    /* liberamos tablas */
    IF AVAILABLE(B-CPEDM) THEN RELEASE B-CPEDM.
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
    IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
    IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
    /* *********************** */
    FOR EACH T-CDOCU NO-LOCK BY T-CDOCU.NroPed:         
        FIND CcbCDocu WHERE
            CcbCDocu.CodCia = S-CodCia AND
            CcbCDocu.CodDiv = S-CodDiv AND
            CcbCDocu.CodDoc = T-CDOCU.CodDoc AND
            CcbCDocu.NroDoc = T-CDOCU.NroDoc
            NO-LOCK NO-ERROR. 
        IF AVAILABLE CcbCDocu THEN DO:
            IF Ccbcdocu.CodDoc = "FAC" THEN DO:                
                RUN vta2/r-tick500-caja (ROWID(ccbcdocu)).
            END.
            IF Ccbcdocu.CodDoc = "BOL" THEN RUN ccb/r-bole01 (ROWID(ccbcdocu)).
            IF Ccbcdocu.CodDoc = "TCK" THEN RUN vta2/r-tick500-caja (ROWID(ccbcdocu)).
        END.
    END.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Actualiza-Tickets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Tickets Procedure 
PROCEDURE Actualiza-Tickets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FOR EACH T-Tickets:
            FIND VtaDTickets OF T-Tickets NO-LOCK NO-ERROR.
            IF AVAILABLE Vtadtickets THEN DO:
                MESSAGE 'ERROR: el ticket' T-Tickets.NroTck 'YA ha sido aplicado' SKIP
                    VIEW-AS ALERT-BOX ERROR.
                UNDO, RETURN 'ADM-ERROR'.
            END.
            CREATE Vtadtickets.
            BUFFER-COPY T-Tickets TO Vtadtickets
                ASSIGN
                    Vtadtickets.CodRef = "I/C"
                    Vtadtickets.NroRef = NroDocCja
                    VtaDTickets.Fecha = DATETIME(TODAY, MTIME)
                    VtaDTickets.CodDiv = s-coddiv
                    VtaDTickets.Usuario = s-user-id.
        END.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Crea-Comprobantes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Comprobantes Procedure 
PROCEDURE Crea-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.
DEFINE VARIABLE lItemOk AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-items AS INT NO-UNDO.
DEFINE VARIABLE X_cto1 AS DEC NO-UNDO.
DEFINE VARIABLE X_cto2 AS DEC NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
FILL-IN-items = 99.
IF s-coddoc = 'BOL' THEN FILL-IN-items = FacCfgGn.Items_Boleta.
IF s-coddoc = 'FAC' THEN FILL-IN-items = FacCfgGn.Items_Factura.

trloop:    
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FOR EACH T-CDOCU:
        DELETE T-CDOCU.
    END.
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = s-CodDoc AND
        FacCorre.NroSer = s-PtoVta
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    FOR EACH T-CODES NO-LOCK:
        FIND FacCPedi WHERE FacCPedi.codcia = T-CODES.codcia
            AND FacCPedi.coddoc = T-CODES.coddoc
            AND FacCPedi.nroped = T-CODES.nroped
            NO-LOCK.
        /* Verifica Detalle */
        lItemOk = TRUE.
        FOR EACH FacDPedi OF FacCPedi NO-LOCK BY FacDPedi.NroItm:
            FIND Almmmate WHERE
                Almmmate.CodCia = FacDPedi.CodCia AND
                Almmmate.CodAlm = FacDPedi.AlmDes AND
                Almmmate.codmat = FacDPedi.CodMat 
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmate THEN DO:
                MESSAGE
                    "Artículo" FacDPedi.CodMat "NO está asignado al almacén" Faccpedi.codalm
                    VIEW-AS ALERT-BOX ERROR.
                lItemOk = FALSE.
            END.
        END.
        IF NOT lItemOk THEN UNDO trloop, RETURN 'ADM-ERROR'.
        /* ***************** */
        ASSIGN
            lCreaHeader = TRUE
            lItemOk = FALSE.
        FOR EACH FacDPedi OF FacCPedi,
            FIRST Almmmatg OF FacDPedi NO-LOCK,
            FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = FacDPedi.CodCia 
                AND Almmmate.CodAlm = FacDPedi.AlmDes
                AND Almmmate.CodMat = FacDPedi.CodMat
            BREAK BY FacDPedi.CodCia BY Almmmate.CodUbi BY FacDPedi.CodMat:
            /* Crea Cabecera */
            IF lCreaHeader THEN DO:
                /* Cabecera de Guía */
                RUN proc_CreaCabecera.
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
                ASSIGN
                    x_cto1 = 0
                    X_cto2 = 0
                    iCountItem = 1
                    lCreaHeader = FALSE.
            END.
            /* Crea Detalle */
            CREATE CcbDDocu.
            BUFFER-COPY Facdpedi 
                EXCEPT Facdpedi.AlmDes 
                        Facdpedi.CanPed
                        Facdpedi.CanAte
                        Facdpedi.ImpIgv
                        Facdpedi.ImpIsc
                        Facdpedi.impDto
                        facdpedi.ImpLin
                TO CcbDDocu
                ASSIGN
                    CcbDDocu.NroItm = iCountItem
                    CcbDDocu.CodCia = CcbCDocu.CodCia
                    CcbDDocu.Coddoc = CcbCDocu.Coddoc
                    CcbDDocu.NroDoc = CcbCDocu.NroDoc 
                    CcbDDocu.FchDoc = CcbCDocu.FchDoc
                    CcbDDocu.CodDiv = CcbcDocu.CodDiv.
            /* Contador de registros válidos */
            iCountItem = iCountItem + 1.
            ASSIGN
                Ccbddocu.CanDes = Facdpedi.CanPed
                Ccbddocu.ImpIgv = Facdpedi.ImpIgv
                Ccbddocu.ImpIsc = Facdpedi.ImpIsc
                Ccbddocu.ImpDto = Facdpedi.ImpDto
                Ccbddocu.ImpLin = Facdpedi.ImpLin.
            /* Guarda Costos */
            IF almmmatg.monvta = 1 THEN DO:
                x_cto1 = ROUND(Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor,2).
                x_cto2 = ROUND((Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor) / Almmmatg.Tpocmb,2).
            END.
            IF almmmatg.monvta = 2 THEN DO:
                x_cto1 = ROUND(Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor * Almmmatg.TpoCmb, 2).
                x_cto2 = ROUND((Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor), 2).
            END.
            CcbDDocu.ImpCto = IF CcbCDocu.Codmon = 1 THEN x_cto1 ELSE x_cto2.
            CcbCDocu.ImpCto = CcbCDocu.ImpCto + CcbDDocu.ImpCto.
            /* ************** */
            IF iCountItem > FILL-IN-items OR LAST-OF (FacDPedi.CodCia) THEN DO:
                {vta2/graba-totales-fac.i}
                /* Control de documentos */
                CREATE T-CDOCU.
                BUFFER-COPY CcbCDocu TO T-CDOCU.
                /* Descarga de Almacen */
                RUN vta2/act_alm (ROWID(CcbCDocu)).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
            END.
            IF iCountItem > FILL-IN-items THEN DO:
                iCountItem = 1.
                lCreaHeader = TRUE.
            END.
        END. /* FOR EACH FacDPedi... */
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Crea-Ordenes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Ordenes Procedure 
PROCEDURE Crea-Ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE x_igv AS DECIMAL NO-UNDO.
    DEFINE VARIABLE x_isc AS DECIMAL NO-UNDO.
    DEFINE VARIABLE i_NPed   AS INTEGER INIT 0.
    DEFINE VARIABLE i_NItem  AS INTEGER INIT 0.

    /*
    FOR EACH T-CPEDM:
        DELETE T-CPEDM.
    END.
    FOR EACH T-DPEDM:
        DELETE T-DPEDM.
    END.
    */
    EMPTY TEMP-TABLE T-CODES.
    EMPTY TEMP-TABLE T-DODES.

    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

    DEFINE VARIABLE s-CodDoc AS CHAR NO-UNDO.
    DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
    DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
    DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.
    
    ASSIGN
        s-CodDoc = "O/D".

    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
        FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
            FacCorre.CodDoc = S-CODDOC AND
            FacCorre.CodDiv = s-CodDiv AND
            FacCorre.FlgEst = YES
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccorre THEN DO:
            MESSAGE 'NO está configurado el correlativo para el documento' s-coddoc
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        /* Barremos el P/M */
        FOR EACH B-DPEDM OF B-CPEDM NO-LOCK,
            FIRST Almacen NO-LOCK WHERE Almacen.codcia = B-DPEDM.codcia
            AND Almacen.codalm = B-DPEDM.almdes
            BREAK BY Almacen.coddiv BY Almacen.codalm: 
            IF FIRST-OF(Almacen.CodDiv) OR FIRST-OF(Almacen.CodAlm) THEN DO:
                I-NITEM = 0.
                CREATE FacCPedi.
                BUFFER-COPY B-CPEDM
                    EXCEPT 
                    B-CPEDM.FlgEst
                    B-CPEDM.FlgSit
                    TO FacCPedi
                    ASSIGN 
                    FacCPedi.CodCia = S-CODCIA
                    FacCPedi.CodDiv = S-CODDIV
                    FacCPedi.CodAlm = ALmacen.CodAlm    /* <<< OJO <<< */
                    FacCPedi.DivDes = Almacen.CodDiv    /* <<< OJO <<< */
                    FacCPedi.CodDoc = s-coddoc 
                    FacCPedi.CodRef = B-CPEDM.CodDoc    /* El Pedido */
                    FacCPedi.NroRef = B-CPEDM.NroPed
                    FacCPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
                    FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
                    FacCorre.Correlativo = FacCorre.Correlativo + 1
                    FacCPedi.Hora = STRING(TIME,"HH:MM")
                    FacCPedi.FchPed = TODAY
                    FacCPedi.FchVen = TODAY.
                FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
                    AND gn-divi.coddiv = Faccpedi.divdes
                    NO-LOCK.
                ASSIGN
                    s-FlgPicking = GN-DIVI.FlgPicking
                    s-FlgBarras  = GN-DIVI.FlgBarras.
                /* VENTA CAJERO MINORISTA 06.12.2010 */
                ASSIGN
                    s-FlgPicking = NO
                    s-FlgBarras  = NO.
                /* ********************** */
                IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".
                IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".
                IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "".  /* REVISAR PICKING O/D */
                /* RHC 25.08.11 */
                IF FacCPedi.FlgSit = "C" THEN FacCPedi.FlgEst = "C".
                /* TRACKING */
                RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                                        Faccpedi.CodDiv,
                                        Faccpedi.CodRef,
                                        Faccpedi.NroRef,
                                        s-User-Id,
                                        'GOD',
                                        'P',
                                        DATETIME(TODAY, MTIME),
                                        DATETIME(TODAY, MTIME),
                                        Faccpedi.CodDoc,
                                        Faccpedi.NroPed,
                                        Faccpedi.CodRef,
                                        Faccpedi.NroRef).
            END.
            I-NITEM = I-NITEM + 1.
            CREATE FacDPedi. 
            BUFFER-COPY B-DPEDM 
                EXCEPT B-DPEDM.CanAte
                TO FacDPedi
                ASSIGN  
                FacDPedi.CodCia  = FacCPedi.CodCia 
                FacDPedi.coddiv  = FacCPedi.coddiv 
                FacDPedi.coddoc  = FacCPedi.coddoc 
                FacDPedi.NroPed  = FacCPedi.NroPed 
                FacDPedi.FchPed  = FacCPedi.FchPed
                FacDPedi.Hora    = FacCPedi.Hora 
                FacDPedi.FlgEst  = FacCPedi.FlgEst
                FacDPedi.NroItm  = I-NITEM
                FacDPedi.CanPick = B-DPEDM.CanPed.     /* <<< OJO <<< */
            /* ******************************************* */
            CREATE T-DODES.
            BUFFER-COPY FacDPedi TO T-DODES.
            IF LAST-OF(Almacen.CodDiv) OR LAST-OF(Almacen.CodAlm) THEN DO:
                {vta2/graba-totales-ped.i}
                /* TEMPORAL DE CONTROL */
                CREATE T-CODES.
                BUFFER-COPY FacCPedi TO T-CODES.
            END.
        END.
    END.

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

&IF DEFINED(EXCLUDE-proc_CreaCabecera) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaCabecera Procedure 
PROCEDURE proc_CreaCabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE CcbCDocu.
    ASSIGN
        CcbCDocu.CodCia = s-CodCia
        CcbCDocu.CodDiv = s-CodDiv   
        CcbCDocu.DivOri = FacCPedi.CodDiv    /* OJO: division de estadisticas */
        CcbCDocu.CodDoc = s-CodDoc
        CcbCDocu.NroDoc = STRING(FacCorre.NroSer,"999") +
                            STRING(FacCorre.Correlativo,"999999") 
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.CodMov = s-CodMov
        CcbCDocu.CodAlm = FacCPedi.CodAlm
        CcbCDocu.CodRef = FacCPedi.CodDoc           /* CONTROL POR DEFECTO */
        CcbCDocu.NroRef = FacCPedi.NroPed
        CcbCDocu.Libre_c01 = FacCPedi.CodDoc        /* CONTROL ADICIONAL */
        CcbCDocu.Libre_c02 = FacCPedi.NroPed
        Ccbcdocu.CodPed = B-CPEDM.CodDoc           /* NUMERO DE PEDIDO */
        Ccbcdocu.NroPed = B-CPEDM.NroPed
        CcbCDocu.Tipo   = s-Tipo
        CcbCDocu.FchVto = TODAY
        CcbCDocu.CodCli = FacCPedi.CodCli
        Ccbcdocu.NomCli = FacCPedi.NomCli
        Ccbcdocu.RucCli = FacCPedi.RucCli
        CcbCDocu.CodAnt = FacCPedi.Atencion     /* DNI */
        Ccbcdocu.DirCli = FacCPedi.DirCli
        CcbCDocu.CodVen = FacCPedi.CodVen
        CcbCDocu.TipVta = "1"
        CcbCDocu.TpoFac = "C"       /* GUIA VENTA AUTOMATICA */
        CcbCDocu.FmaPgo = FacCPedi.FmaPgo
        CcbCDocu.CodMon = FacCPedi.CodMon
        CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
        CcbCDocu.PorIgv = FacCPedi.PorIgv
        CcbCDocu.NroOrd = FacCPedi.ordcmp
        CcbCDocu.FlgEst = "P"       /* POR FACTURAR */
        CcbCDocu.FlgSit = "P"
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.HorCie = STRING(TIME,'hh:mm')
        CcbCDocu.Glosa     = B-CPEDM.Glosa
        CcbCDocu.TipBon[1] = B-CPEDM.TipBon[1]
        CcbCDocu.NroCard   = B-CPEDM.NroCard 
        CcbCDocu.FlgEnv    = B-CPEDM.FlgEnv /* OJO Control de envio de documento */
        CcbCDocu.Libre_c04 = FaccPedi.Cmpbnte   /*Que Documento imprimira*/
        FacCorre.Correlativo = FacCorre.Correlativo + 1
        CcbCDocu.ImpDto2    = FaccPedi.ImpDto2.
    FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
        CcbCDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
        CcbCDocu.FchVto = CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
    END.
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
        AND gn-clie.CodCli = CcbCDocu.CodCli 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO:
        ASSIGN
            CcbCDocu.CodDpto = gn-clie.CodDept 
            CcbCDocu.CodProv = gn-clie.CodProv 
            CcbCDocu.CodDist = gn-clie.CodDist.
    END.
    /* ******************************** */
    IF cMess <> "" THEN ASSIGN CcbCDocu.Libre_c05 = cMess.        

    /* Guarda Centro de Costo */
    FIND gn-ven WHERE
        gn-ven.codcia = s-codcia AND
        gn-ven.codven = ccbcdocu.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN ccbcdocu.cco = gn-ven.cco.
    /* TRACKING FACTURAS */
    RUN vtagn/pTracking-04 (s-CodCia,
                            s-CodDiv,
                            Ccbcdocu.CodPed,
                            Ccbcdocu.NroPed,
                            s-User-Id,
                            'EFAC',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Ccbcdocu.coddoc,
                            Ccbcdocu.nrodoc,
                            CcbCDocu.Libre_c01,
                            CcbCDocu.Libre_c02).
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

    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
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
        FOR EACH T-CDOCU NO-LOCK BY T-CDOCU.NroDoc:
            FIND CcbCDocu WHERE CcbCDocu.CodCia = T-CDOCU.CodCia
                AND CcbCDocu.CodDoc = T-CDOCU.CodDoc
                AND CcbCDocu.NroDoc = T-CDOCU.NroDoc
                EXCLUSIVE-LOCK NO-ERROR. 
            IF NOT AVAILABLE Ccbcdocu THEN UNDO trloop, RETURN 'ADM-ERROR'.
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
                CcbDCaja.TpoCmb = CcbCCaja.TpoCmb.
            ASSIGN
                CcbCDocu.FlgEst = "C"
                CcbCDocu.FchCan = TODAY
                CcbCDocu.SdoAct = 0.
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

