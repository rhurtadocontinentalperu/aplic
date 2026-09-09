&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
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

DEFINE INPUT PARAMETER d_Rowid AS ROWID.

DEFINE NEW SHARED VARIABLE s-PtoVta AS INT.
DEFINE NEW SHARED VARIABLE s-codcli LIKE gn-clie.codcli.
DEFINE NEW SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

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

DEFINE VAR Fac_Rowid AS ROWID NO-UNDO.     /* COntrol de Cabecera de Comprobantes */

DEF VAR pMensaje AS CHAR NO-UNDO.

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
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
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
         HEIGHT             = 7.69
         WIDTH              = 72.29.
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

/* Importe del pedido en pantalla */
DEFINE VARIABLE x-Importe-Control   AS DEC NO-UNDO. 

FIND Faccpedi WHERE ROWID(Faccpedi) = D_ROWID NO-LOCK NO-ERROR. 
IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.

/* AVISO DEL ADMINISTRADOR */
DEF VAR pRpta AS CHAR.
RUN ccb/d-msgblo (Faccpedi.codcli, Faccpedi.nrocard, OUTPUT pRpta).
IF pRpta = 'ADM-ERROR' THEN RETURN.
/* *********************** */

/* Verifica I/C */
RUN proc_verifica_ic.

IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
FIND B-CPEDM WHERE ROWID(B-CPEDM) = d_rowid NO-LOCK NO-ERROR.

/* NUMERO DE SERIE DEL COMPROBANTE PARA TERMINAL */
s-CodDoc = B-CPEDM.Cmpbnte.
/* QUITAR ESTA LINEA CUANDO COMIENCE LA FACTURACION ELECTRONICA */
IF TODAY < DATE(07,04,2016) THEN s-CodDoc = "TCK".   
/* ***************************************************** */

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
FIND faccorre WHERE faccorre.codcia = s-codcia AND
    faccorre.coddoc = s-Coddoc AND
    faccorre.coddiv = s-Coddiv AND
    faccorre.NroSer = s-ptovta NO-LOCK NO-ERROR.
IF NOT AVAILABLE faccorre THEN DO:
    MESSAGE "DOCUMENTO:" s-CodDoc "SERIE:" s-ptovta SKIP
        "NO ESTA CONFIGURADO SU CORRELATIVO PARA LA DIVISION" s-coddiv
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

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

/* CALCULAMOS PERCEPCION */
RUN vta2/percepcion-por-pedido ( ROWID(B-CPEDM) ).

/* VENTANA DE CANCELACIÓN */
x-Importe-Control = B-CPEDM.ImpTot.      /* OJO */
RUN sunat\d-cancelar-pedido-minorista-sunat (
    B-CPEDM.codmon,     /* Moneda Documento */
    (B-CPEDM.imptot + B-CPEDM.acubon[5]),     /* Importe Total */
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

pMensaje = "".  /* Si hay un mensaje => hay un error */
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* FIJAMOS EL PEDIDO EN UN PUNTERO DEL BUFFER */
    {lib\lock-genericov21.i &Tabla="B-CPEDM" ~
        &Condicion="ROWID(B-CPEDM) = d_rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO PRINCIPAL, LEAVE PRINCIPAL" }
    /* CONTROL DE SITUACION DEL PEDIDO AL CONTADO */
    IF B-CPEDM.FlgEst <> "P" THEN DO:
        pMensaje = "Pedido mostrador ya no esta PENDIENTE".
        UNDO PRINCIPAL, LEAVE PRINCIPAL.
    END.
    IF B-CPEDM.ImpTot <> x-Importe-Control THEN DO:
        pMensaje = 'El IMPORTE del pedido ha sido cambiado por el vendedor' + CHR(10) +
            'Proceso cancelado' .
        UNDO PRINCIPAL, LEAVE PRINCIPAL.
    END.

    /* CREACION DE LAS ORDENES DE DESPACHO */
    RUN Crea-Ordenes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo crear la Orden de Despacho".
        UNDO PRINCIPAL, LEAVE PRINCIPAL.
    END.

    /* CREACION DE COMPROBANTES A PARTIR DE LAS ORDENES DE DESPACHO */
    RUN Crea-Comprobantes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo crear el Comprobante".
        UNDO PRINCIPAL, LEAVE PRINCIPAL.
    END.
    /* ************************ */

    /* Actualiza Flag del pedido */
    ASSIGN B-CPEDM.flgest = "C".        /* Pedido Mostrador CERRADO */
    FOR EACH Facdpedi OF B-CPEDM:
        ASSIGN
            Facdpedi.canate = Facdpedi.canped.
    END.
    /* ************************* */

    /* CREACION DE OTROS DOCUMENTOS ANEXOS */
    RUN Documentos-Anexos.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo crear los Documentos Anexos".
        UNDO PRINCIPAL, LEAVE PRINCIPAL.
    END.

    /* Actualiza Control de Vales de Compras */
    /* Se va a aplicar todo lo que se pueda */
    DEF VAR x-Importe-Vales AS DEC NO-UNDO.

    FIND FIRST T-CcbCCaja.
    x-Importe-Vales = T-CcbCCaja.ImpNac[10] + T-CcbCCaja.ImpUsa[10] * T-CcbCCaja.TpoCmb.
    FOR EACH T-VALES:
        FIND VtaVales WHERE VtaVales.codcia = s-codcia
            AND VtaVales.nrodoc = T-VALES.nrodoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaVales THEN DO:
            pMensaje = 'NO se pudo actualizar el vale de consumo ' + T-VALES.nrodoc.
            UNDO PRINCIPAL, LEAVE PRINCIPAL.
        END.
        IF VtaVales.FlgEst <> "P" THEN DO:
            pMensaje = 'El vale de consumo ' + T-VALES.nrodoc + ' acaba de ser utilizado en otra caja'.
            UNDO PRINCIPAL, LEAVE PRINCIPAL.
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
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = 'Error al actualizar el control de Tickets'.
        UNDO PRINCIPAL, LEAVE PRINCIPAL.
    END.
END. /* DO TRANSACTION... */
/* liberamos tablas */
IF AVAILABLE(B-CPEDM) THEN RELEASE B-CPEDM.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(FacDPedi) THEN RELEASE FacDPedi.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDocu.
IF AVAILABLE(Ccbdmov) THEN RELEASE Ccbdmov.
IF pMensaje > "" THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
/* *********************** */
FOR EACH T-CDOCU NO-LOCK BY T-CDOCU.NroPed:         
    FIND CcbCDocu WHERE
        CcbCDocu.CodCia = S-CodCia AND
        CcbCDocu.CodDiv = S-CodDiv AND
        CcbCDocu.CodDoc = T-CDOCU.CodDoc AND
        CcbCDocu.NroDoc = T-CDOCU.NroDoc
        NO-LOCK NO-ERROR. 
    IF AVAILABLE CcbCDocu THEN DO:
        IF TODAY >= DATE(07,01,2016) OR s-user-id = 'ADMIN' THEN DO:
            RUN sunat\r-tickets-sunat ( ROWID(Ccbcdocu), "O", YES ).
        END.
        ELSE DO:
            IF Ccbcdocu.CodDoc = "FAC" THEN RUN sunat/r-tick500-caja (ROWID(ccbcdocu), "O") NO-ERROR.
            IF Ccbcdocu.CodDoc = "BOL" THEN RUN sunat/r-bole01 (ROWID(ccbcdocu)) NO-ERROR.
            IF Ccbcdocu.CodDoc = "TCK" THEN RUN vtagn/r-tickets (ROWID(ccbcdocu), "O") NO-ERROR.    /* ORIGINAL */
        END.
    END.
END.

RETURN 'OK'.

/* ******************************************************************************* */
/* RHC 27/04/2016 RUTINAS GENERALES DE CAJA COBRANZAS MOSTRADOR MAYORISTA Y UTILEX */
/* ******************************************************************************* */
{ccb\i-canc-mayorista-cont.i}
/* ******************************************************************************* */

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
                pMensaje = 'ERROR: el ticket ' + T-Tickets.NroTck + ' YA ha sido aplicado'.
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

/* CONSISTENCIA */
FOR EACH T-CODES NO-LOCK, FIRST FacCPedi WHERE FacCPedi.codcia = T-CODES.codcia
    AND FacCPedi.coddiv = T-CODES.coddiv
    AND FacCPedi.coddoc = T-CODES.coddoc
    AND FacCPedi.nroped = T-CODES.nroped
    NO-LOCK:
    /* Verifica Detalle */
    FOR EACH FacDPedi OF FacCPedi NO-LOCK BY FacDPedi.NroItm:
        FIND Almmmate WHERE Almmmate.CodCia = FacDPedi.CodCia 
            AND Almmmate.CodAlm = FacDPedi.AlmDes 
            AND Almmmate.codmat = FacDPedi.CodMat 
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            MESSAGE "Artículo" FacDPedi.CodMat "NO está asignado al almacén" FacDPedi.AlmDes SKIP
                'Proceso abortado'
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.
/*  FIN DE CONSISTENCIA */
FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
FILL-IN-items = 999999.
IF s-coddoc = 'BOL' THEN FILL-IN-items = FacCfgGn.Items_Boleta.
IF s-coddoc = 'FAC' THEN FILL-IN-items = FacCfgGn.Items_Factura.

EMPTY TEMP-TABLE T-CDOCU.
TRLOOP:    
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
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
            AND FacCPedi.nroped = T-CODES.nroped.
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
            FIND CcbCDocu WHERE ROWID(CcbCDocu) = Fac_Rowid.
            CREATE CcbDDocu.
            BUFFER-COPY Facdpedi TO CcbDDocu
                ASSIGN
                    CcbDDocu.NroItm = iCountItem
                    CcbDDocu.CodCia = CcbCDocu.CodCia
                    CcbDDocu.Coddoc = CcbCDocu.Coddoc
                    CcbDDocu.NroDoc = CcbCDocu.NroDoc 
                    CcbDDocu.FchDoc = CcbCDocu.FchDoc
                    CcbDDocu.CodDiv = CcbcDocu.CodDiv
                    CcbDDocu.AlmDes = FacDPedi.AlmDes    /* OJO */
                    CcbDDocu.CanDes = FacDPedi.CanPed.
            /* CIERRA SALDO DE LA ORDEN DE DESPACHO */
            ASSIGN
                FacDPedi.CanAte = FacDPedi.CanPed.
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
            iCountItem = iCountItem + 1.
            IF iCountItem > FILL-IN-items OR LAST-OF (FacDPedi.CodCia) THEN DO:
                /* GRABAMOS LOS TOTALES DEL COMPROBANTE + SU PERCEPCION */
                {vtamin/graba-totales-fac.i}
                ASSIGN
                    Ccbcdocu.SdoAct  = Ccbcdocu.ImpTot.
                /* CALCULO DE PERCEPCIONES */
                RUN vta2/calcula-percepcion-contado ( ROWID(Ccbcdocu), ROWID(B-CPEDM) ).
                FIND CURRENT CcbCDocu.
                /* **************************************************** */
                /* Control de documentos */
                CREATE T-CDOCU.
                BUFFER-COPY CcbCDocu TO T-CDOCU.
                /* Descarga de Almacen */
                /*RUN vtagn/act_alm-04 (ROWID(CcbCDocu)).*/
                RUN vta2/act_alm (ROWID(CcbCDocu)).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
                /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
                RUN sunat\progress-to-ppll ( INPUT ROWID(Ccbcdocu), OUTPUT pMensaje ).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO TRLOOP, RETURN 'ADM-ERROR'.
                /* *********************************************************** */
            END.
            IF iCountItem > FILL-IN-items THEN DO:
                iCountItem = 1.
                lCreaHeader = TRUE.
            END.
        END. /* FOR EACH FacDPedi... */
        ASSIGN
            FacCPedi.FlgEst = "C".      /* CERRAMOS ORDENES DE DESPACHO */
    END.
END.
RETURN 'ok'.

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

  /* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
  DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.

  RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE CcbCDocu.
    ASSIGN
        CcbCDocu.CodCia = s-CodCia
        CcbCDocu.CodDiv = s-CodDiv   
        CcbCDocu.DivOri = FacCPedi.CodDiv    /* OJO: division de estadisticas */
        CcbCDocu.CodDoc = s-CodDoc
/*         CcbCDocu.NroDoc = STRING(FacCorre.NroSer,"999") +         */
/*                             STRING(FacCorre.Correlativo,"999999") */
        CcbCDocu.NroDoc = STRING(FacCorre.NroSer, ENTRY(1, x-Formato, '-')) +
                            STRING(FacCorre.Correlativo, ENTRY(2, x-Formato, '-'))
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.CodMov = s-CodMov
        /*CcbCDocu.CodAlm = cCodAlm*/
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
        CcbCDocu.ImpDto2    = FaccPedi.ImpDto2
        /* INFORMACION DE LA TIQUETERA */
        CcbCDocu.libre_c03 = FacCorre.NroImp
        /* INFORMACION DEL ENCARTE */
        Ccbcdocu.Libre_c05 = B-CPEDM.FlgSit + '|' + B-CPEDM.Libre_c05
        CcbCDocu.Tipo    = s-Tipo       /* SUNAT */
        CcbCDocu.CodCaja = s-CodTer.
    /* PUNTERO DE LA FACTURA */
    ASSIGN
        Fac_Rowid = ROWID(Ccbcdocu).
    /* ********************* */
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
    /*IF cMess <> "" THEN ASSIGN CcbCDocu.Libre_c05 = cMess.        */

    /* Guarda Centro de Costo */
    FIND gn-ven WHERE
        gn-ven.codcia = s-codcia AND
        gn-ven.codven = ccbcdocu.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN ccbcdocu.cco = gn-ven.cco.
    /* PUNTERO DE LA FACTURA */
    ASSIGN
        Fac_Rowid = ROWID(Ccbcdocu).
    /* ********************* */
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
RETURN 'OK'.

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

    FOR EACH FacDPedm OF Faccpedi NO-LOCK
        BREAK BY FacDPedm.CodCia BY TRIM(FacDPedm.AlmDes): 
        IF FIRST-OF(TRIM(FacDPedm.AlmDes)) OR x_NewPed THEN DO:
            i_NPed = i_NPed + 1.
            CREATE T-CPEDM.
            BUFFER-COPY Faccpedi TO T-CPEDM
                ASSIGN
                    T-CPEDM.NroPed =
                        SUBSTRING(Faccpedi.NroPed,1,3) + STRING(i_NPed,"999999")
                    T-CPEDM.CodAlm = TRIM(FacDPedm.AlmDes)        /* OJO */
                    T-CPEDM.ImpBrt = 0
                    T-CPEDM.ImpDto = 0
                    T-CPEDM.ImpExo = 0
                    T-CPEDM.ImpIgv = 0
                    T-CPEDM.ImpIsc = 0
                    T-CPEDM.ImpTot = 0
                    T-CPEDM.ImpVta = 0
                    T-CPEDM.NroCard = Faccpedi.NroCard
/*Solo Tickets*/    t-cpedm.Cmpbnte = 'TCK'.
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
                ROUND(FacDPedm.ImpDto / (1 + Faccpedi.PorIgv / 100),2).
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

    FOR EACH FacDPedm OF Faccpedi NO-LOCK
        BREAK BY FacDPedm.CodCia BY TRIM(FacDPedm.AlmDes): 
        IF FIRST-OF(TRIM(FacDPedm.AlmDes)) OR x_NewPed THEN DO:
            i_NPed = i_NPed + 1.
            CREATE T-CPEDM.
            BUFFER-COPY Faccpedi TO T-CPEDM
                ASSIGN
                    T-CPEDM.NroPed =
                        SUBSTRING(Faccpedi.NroPed,1,3) + STRING(i_NPed,"999999")
                    T-CPEDM.CodAlm = TRIM(FacDPedm.AlmDes)        /* OJO */
                    T-CPEDM.ImpBrt = 0
                    T-CPEDM.ImpDto = 0
                    T-CPEDM.ImpExo = 0
                    T-CPEDM.ImpIgv = 0
                    T-CPEDM.ImpIsc = 0
                    T-CPEDM.ImpTot = 0
                    T-CPEDM.ImpVta = 0
                    T-CPEDM.NroCard = Faccpedi.NroCard.
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
                ROUND(FacDPedm.ImpDto / (1 + Faccpedi.PorIgv / 100),2).
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

