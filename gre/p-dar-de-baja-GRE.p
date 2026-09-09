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

DEFINE INPUT PARAMETER piSerieGuia AS INT NO-UNDO.
DEFINE INPUT PARAMETER piNumeroGuia AS INT NO-UNDO.
DEFINE INPUT PARAMETER pcMotivo AS CHAR NO-UNDO.            /* Motivo de la baja */
DEFINE INPUT PARAMETER pcMotivoDetalle AS CHAR NO-UNDO.     /* Glosa x la baja */
DEFINE OUTPUT PARAMETER piNuevoPGRE AS INT NO-UNDO.
DEFINE OUTPUT PARAMETER pcRetVal AS CHAR NO-UNDO.

DEFINE VAR s-codcia AS INT INIT 1.
DEFINE VAR cMotivo AS CHAR NO-UNDO.
DEFINE VAR cMotivoDetalle AS CHAR NO-UNDO.
 
DEFINE BUFFER b-gre_header FOR gre_header.
DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-facdpedi FOR facdpedi.
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-almcmov FOR almcmov. 
DEFINE BUFFER b-almdmov FOR almdmov.

DEFINE BUFFER b1-almcmov FOR almcmov.
/*
DEFINE BUFFER b-faccorre FOR faccorre.
DEFINE BUFFER x-gre_header FOR gre_header.
DEFINE BUFFER x-almcmov FOR almcmov.
DEFINE BUFFER x-vtatabla FOR vtatabla.
*/

DEFINE TEMP-TABLE t-gre_header LIKE gre_header.
DEFINE TEMP-TABLE t-gre_detail LIKE gre_detail.
DEFINE TEMP-TABLE t-almcmov LIKE almcmov.
DEFINE TEMP-TABLE t-almdmov LIKE almdmov.

cMotivo = pcMotivo.
cMotivoDetalle = pcMotivoDetalle.

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
DEFINE VAR iCorrelativo AS INT NO-UNDO.
DEFINE VAR cValorDeRetorno AS CHAR NO-UNDO.
DEFINE VAR iCodMov AS INT NO-UNDO.
DEFINE VAR iSerie AS INT NO-UNDO.
DEFINE VAR iNumero AS INT NO-UNDO.
DEFINE VAR lAfectaMovAlm AS LOG INIT NO NO-UNDO.
DEFINE VAR cNroOTR AS CHAR NO-UNDO.
DEFINE VAR cNroComprobante AS CHAR NO-UNDO.
DEFINE VAR cNroGuiaRemision AS CHAR NO-UNDO.
DEFINE VAR R-ROWID AS ROWID NO-UNDO.
DEFINE VAR R-ROWID_almcmov AS ROWID NO-UNDO.
DEFINE VAR cReservaStock AS CHAR INIT "NO".
DEFINE VAR cMsg AS CHAR.
DEFINE VAR iMaximoDiasParaBajaEnSunat AS INT.
DEFINE VAR iDiasAntiguedaEnviado_a_Sunat AS INT.
/**/
RUN gre/get-parametro-config-gre("PARAMETRO","BAJA_EN_SUNAT","MAXIMO_DIAS","N","5",OUTPUT cValorDeRetorno).
If cValorDeRetorno = "ERROR" THEN DO: 
    pcRetVal = "No se pudo recuperar el parametro de maximos de dias para baja en sunat".
    RETURN "ADM-ERROR".
END.
iMaximoDiasParaBajaEnSunat = INTEGER(cValorDeRetorno).
/* */
FIND FIRST b-gre_header WHERE b-gre_header.serieGuia = piSerieGuia AND 
                b-gre_header.numeroGuia = piNumeroGuia NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-gre_header THEN DO:
    pcRetVal = "No existe GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999").
    RETURN "ADM-ERROR".
END.
IF b-gre_header.m_rspta_sunat <> "ACEPTADO POR SUNAT"  THEN DO:
    pcRetVal = "La GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " NO esta ACEPTADO POR SUNAT".
    RETURN "ADM-ERROR".
END.
iDiasAntiguedaEnviado_a_Sunat = INTERVAL(TODAY,b-gre_header.fechahora_envio_a_sunat,'days').
IF iDiasAntiguedaEnviado_a_Sunat > iMaximoDiasParaBajaEnSunat THEN DO:
    pcRetVal = "La GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " fue aceptado a sunat hace " + STRING(iDiasAntiguedaEnviado_a_Sunat) + " dia(s) " +
                "y el maximo de dias para la baja es " + STRING(iMaximoDiasParaBajaEnSunat).
    RETURN "ADM-ERROR".
END.
/* Cargamos la data a un temporal */
EMPTY TEMP-TABLE t-gre_header.
EMPTY TEMP-TABLE t-gre_detail.
EMPTY TEMP-TABLE t-almcmov.
EMPTY TEMP-TABLE t-almdmov.
/* GRE */
CREATE t-gre_header.
BUFFER-COPY b-gre_header TO t-gre_header.
FIND FIRST t-gre_header NO-LOCK NO-ERROR.

pcRetVal = "COPIANDO A TEMPORAL EL gre_detail".
FOR EACH gre_detail WHERE gre_detail.ncorrelativo = b-gre_header.ncorrelatio NO-LOCK:
    CREATE t-gre_detail.
    BUFFER-COPY gre_detail TO t-gre_detail.
END.
/* Afecta Almacen */
FIND FIRST almtmovm WHERE almtmovm.codcia = s-codcia AND almtmovm.tipmov = 'S' AND
                            almtmovm.codmov = b-gre_header.m_codmov NO-LOCK NO-ERROR.
IF NOT AVAILABLE almtmovm THEN DO:
    pcRetVal = "La GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " cuyo codmov es " + STRING(b-gre_header.m_codmov) + 
                    " no existe en la tabla".
    RETURN "ADM-ERROR".
END.
lAfectaMovAlm = almtmovm.movVal.
/* Movimiento almacen */
R-ROWID_almcmov = ?.
FIND FIRST almcmov WHERE almcmov.codcia = s-codcia AND almcmov.codalm = b-gre_header.m_codalm AND
                            almcmov.tipmov = b-gre_header.m_tipmov AND almcmov.codmov = b-gre_header.m_codmov AND
                            almcmov.nroser = b-gre_header.serieGuia AND almcmov.nrodoc = b-gre_header.numeroGuia 
                            NO-LOCK NO-ERROR.
IF lAfectaMovAlm THEN DO:
    cReservaStock = "SI".
    IF NOT AVAILABLE almcmov THEN DO:
        pcRetVal = "La GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " NO existe en movimientos de almacenes".
        RETURN "ADM-ERROR".
    END.
    IF almcmov.flgest = "A" THEN DO:
        pcRetVal = "La GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " el movimiento de almacen esta ANULADO".
        RETURN "ADM-ERROR".
    END.
END.
IF AVAILABLE almcmov THEN DO:
    R-ROWID_almcmov = ROWID(almcmov).
    lAfectaMovAlm = YES.
END.        
/* */
IF lAfectaMovAlm = YES THEN DO:
    pcRetVal = "COPIANDO A TEMPORAL EL almcmov".
    CREATE t-almcmov.
    BUFFER-COPY almcmov TO t-almcmov.
    FIND FIRST t-almcmov NO-LOCK NO-ERROR.

    pcRetVal = "COPIANDO A TEMPORAL EL almdmov".
    FOR EACH almdmov OF almcmov NO-LOCK:
        CREATE t-almdmov.
        BUFFER-COPY almdmov TO t-almdmov.
    END.
END.
/* */
RUN gre/get-parametro-config-gre("PARAMETRO","COD.MOV.ING-EXTORNO/GRE BAJA","CODMOV","N","8",OUTPUT cValorDeRetorno).
If cValorDeRetorno = "ERROR" THEN DO:
    pcRetVal = "La GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " NO se pudo leer el codmov para el extorno".
    RETURN "ADM-ERROR".
END.
iCodMov = INTEGER(cValorDeRetorno).
/* Validamos el codigo movimiento x extorno - INGRESO */
FIND FIRST almtmovm WHERE almtmovm.codcia = s-codcia AND almtmovm.tipmov = 'I' AND almtmovm.codmov = iCodMov NO-LOCK NO-ERROR.
IF NOT AVAILABLE almtmovm THEN DO:
    pcRetVal = "El codmov(" + STRING(iCodMov) + ") para el extorno NO EXISTE".
    RETURN "ADM-ERROR".
END.
pcRetVal = "PROCESANDO".
piNuevoPGRE = 0.

PROCESO_GRABADO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':

    FIND CURRENT b-gre_header EXCLUSIVE-LOCK NO-ERROR NO-WAIT.    
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "GRE " + STRING(piSerieGuia,"999") + "-" + 
                    STRING(piNumeroGuia,"99999999") + " imposible bloquear tabla gre_header " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
    END.
    /* Actualizo GRE_HEADER --> BAJA EN SUNAT y crear LOG */
    CREATE gre_header_log.
    BUFFER-COPY b-gre_header TO gre_header_log NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "GRE " + STRING(piSerieGuia,"999") + "-" + 
                    STRING(piNumeroGuia,"99999999") + " ERROR al grabar el LOG " + ERROR-STATUS:GET-MESSAGE(1).
        RELEASE b-gre_header.
        RELEASE gre_header_log.
        UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN gre_header_log.m_motivo_log = "BAJA EN SUNAT"
          gre_header_log.USER_log = USERID("dictdb")
          gre_header_log.cmotivo = cMotivo
          gre_header_log.dmotivo_detalle = cMotivoDetalle.
    /* Creamos la nueva PGRE */
    iCorrelativo = 0.
    RUN gre/correlativo-gre(OUTPUT iCorrelativo).

    IF RETURN-VALUE <> "OK" THEN DO:
        pcRetVal = "GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " nose pudo generar el numero de la PGRE".
        UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN t-gre_header.ncorrelatio = iCorrelativo
        t-gre_header.modalidadTraslado = ""
        t-gre_header.numeroRucTransportista = ""
        t-gre_header.tipoDocumentoTransportista = ""
        t-gre_header.RazonSocialTransportista = ""
        t-gre_header.numeroRegistroMTC = ""
        t-gre_header.indTrasVehiculoCatM1L = NO
        t-gre_header.numeroPlacaVehiculoPrin = ""
        t-gre_header.numeroPlacaVehiculoSec1 = ""
        t-gre_header.numeroDocumentoConductor = ""
        t-gre_header.tipoDocumentoConductor = ""
        t-gre_header.nombreConductor = ""
        t-gre_header.apellidoConductor = ""
        t-gre_header.numeroLicencia = ""
        t-gre_header.m_rspta_sunat = 'SIN ENVIAR' 
        t-gre_header.correlativo_vehiculo = 0
        t-gre_header.fechahora_asigna_vehiculo = ?
        t-gre_header.USER_asigna_vehiculo = ""
        t-gre_header.indTransbordoProgramado = 0
        t-gre_header.fechaInicioTraslado = ?
        t-gre_header.fechaEntregaBienes = ?
        t-gre_header.serieGuia = 0
        t-gre_header.numeroGuia = 0
        t-gre_header.tarjetaUnicaCirculacionPri = ""
        t-gre_header.tarjetaUnicaCirculacionSec1 = ""
        t-gre_header.m_motivo_de_rechazo = ""
        t-gre_header.m_estado_mov_almacen = "POR PROCESAR"
        t-gre_header.m_msgerr_mov_almacen = ""
        t-gre_header.fechahora_envio_a_sunat = ?
        t-gre_header.USER_envio_a_sunat = ""
        t-gre_header.m_estado_bizlinks = ""        
        t-gre_header.m_fechahorareg = NOW
        t-gre_header.m_fechahora_mov_almacen = ?
        t-gre_header.estado_en_hojaruta = "EN PROCESO"
        t-gre_header.user_recupera_cmpte = ""
        t-gre_header.fechahora_recupera_cmpte = ?
        t-gre_header.fechaEmisionGuia = TODAY
        t-gre_header.horaEmisionGuia = STRING(TIME,"hh:mm:ss").
    
    FOR EACH t-gre_detail :
        ASSIGN t-gre_detail.ncorrelativo = iCorrelativo.
    END.
    /* - */
    CREATE gre_header.
    BUFFER-COPY t-gre_header TO gre_header.

    FOR EACH t-gre_detail NO-LOCK:
        CREATE gre_detail.
        BUFFER-COPY t-gre_detail TO gre_detail.
    END.
    /* Actualizo la GRE a BAJA EN SUNAT */
    ASSIGN b-gre_header.m_rspta_sunat = 'BAJA EN SUNAT'. 
    /* Si es OTR se activa */
    IF b-gre_header.m_coddoc = 'OTR' THEN DO:
        cMsg = "".
        RUN actualiza-otr-recepcion-mercaderia(R-ROWID_almcmov, OUTPUT cMsg).
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            pcRetVal = cMsg.
            UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
        END.
    END.
    cNroGuiaRemision = STRING(b-gre_header.serieGuia,"999") + STRING(b-gre_header.numeroGuia,"99999999").
    cNroComprobante = STRING(b-gre_header.m_nroser,"999") + STRING(b-gre_header.m_nrodoc,"99999999").
    IF b-gre_header.m_coddoc = 'FAI' THEN cNroComprobante = STRING(b-gre_header.m_nroser,"999") + STRING(b-gre_header.m_nrodoc,"999999").
    /* Dar de baja a la GRE en CCBCDOCU */
    IF LOOKUP(b-gre_header.m_coddoc,"FAC,BOL,FAI") > 0 THEN DO:
        FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND b-ccbcdocu.coddoc = "G/R" AND b-ccbcdocu.nrodoc = cNroGuiaRemision EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            RELEASE b-ccbcdocu NO-ERROR.
            pcRetVal =  "La tabla CCBCDOCU esta bloqueada ó registro de G/R (" + cNroGuiaRemision + ") no existe...imposible dar de baja la GRE (" + 
                  ERROR-STATUS:GET-MESSAGE(1) + ")" .
            UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN b-ccbcdocu.flgest = 'A'
                b-ccbcdocu.usuanu = USERID("dictdb")
                b-ccbcdocu.fchanu = TODAY. 
    END.
    ELSE DO:
        /* Lo que era ITINERANTES antes de la GRE  */
        IF TRUE <> (b-gre_header.m_coddoc > "") THEN DO:
            FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND b-ccbcdocu.coddoc = "G/R" AND b-ccbcdocu.nrodoc = cNroGuiaRemision EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                RELEASE b-ccbcdocu NO-ERROR.
                pcRetVal =  "La tabla *CCBCDOCU* esta bloqueada ó registro de G/R(" + cNroGuiaRemision + ") no existe...imposible dar de baja la GRE (" + 
                      ERROR-STATUS:GET-MESSAGE(1) + ")" .
                UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
            END.
            ASSIGN b-ccbcdocu.flgest = 'A'
                    b-ccbcdocu.usuanu = USERID("dictdb")
                    b-ccbcdocu.fchanu = TODAY. 
        END.
    END.
    IF lAfectaMovAlm = YES THEN DO:    
        /* Creamos el movimiento de extorno en almacen  */
        FIND FIRST almacen WHERE almacen.codcia = s-codcia AND almacen.codalm = b-gre_header.m_codalm EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF LOCKED almacen THEN DO:
            pcRetVal = "GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " tabla almacen esta bloqueada".
            UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
        END.
        IF NOT AVAILABLE almacen THEN DO:
            pcRetVal = "GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " el almacen " + b-gre_header.m_codalm + 
                                    " NO existe".
            UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
        END.                
        iSerie = 0.
        iNumero = almacen.corring.
        ASSIGN almacen.corring = almacen.corring + 1.
    
        ASSIGN t-almcmov.tipmov = 'I'
                t-almcmov.codmov = iCodMov
                t-almcmov.nroser = iSerie
                t-almcmov.nrodoc = iNumero
                t-almcmov.fchdoc = TODAY
                t-almcmov.usuario = USERID("dictdb")
                t-almcmov.crossdocking = NO
                t-almcmov.almacenXD = "".
        FOR EACH t-almdmov :
            ASSIGN t-almdmov.tipmov = 'I'
                    t-almdmov.codmov = iCodMov
                    t-almdmov.nroser = iSerie
                    t-almdmov.nrodoc = iNumero
                    t-almdmov.fchdoc = TODAY.
        END.
        /**/
        CREATE b-almcmov.
        BUFFER-COPY t-almcmov TO b-almcmov NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pcRetVal = "Error al crear la PGRE desde la GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " ERROR: " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
        END.
        FOR EACH t-almdmov NO-LOCK:
            CREATE b-almdmov.
            BUFFER-COPY t-almdmov TO b-almdmov NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pcRetVal = "Error al crear el detalle de la PGRE desde la GRE " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + 
                    "Articulo " + t-almdmov.codmat + " ERROR: " + ERROR-STATUS:GET-MESSAGE(1).
                UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
            END.
            /* Stocks */
            R-ROWID = ROWID(b-Almdmov).
            RUN alm/almdcstk (R-ROWID) NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                pcRetVal = "ERROR DETALLE (alm/almdcstk) --->Guia : " + STRING(b-gre_header.serieGuia,"999") + "-" + STRING(b-gre_header.numeroGuia,"99999999") + 
                                " ARTICULO:" + b-almdmov.codmat + "   ERROR:" + ERROR-STATUS:GET-MESSAGE(1).
                UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
            END.
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pcRetVal  = "No se pudo actualizar el stock desde la guia " + STRING(b-Almcmov.NroSer,"999") + STRING(b-Almcmov.NroDoc,"99999999") + " articulo " + b-almdmov.codmat.
                UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
            END.
            RUN alm/almacpr1 (R-ROWID, "U") NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                pcRetVal = "ERROR DETALLE (alm/almacpr1) --->Guia : " + STRING(b-gre_header.serieGuia,"999") + "-" + STRING(b-gre_header.numeroGuia,"99999999") + 
                                " ARTICULO:" + b-almdmov.codmat + "   ERROR:" + ERROR-STATUS:GET-MESSAGE(1).
                UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
            END.
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pcRetVal = "No se pudo actualizar el ALMACPR1 desde la guia " + STRING(b-Almcmov.NroSer,"999") + STRING(b-Almcmov.NroDoc,"99999999") + " articulo " + b-almdmov.codmat.
                UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
            END.
        END.
    END.
    RELEASE b-gre_header NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "Error al crear la PGRE desde la GRE(RELEASE b-gre_header) " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " ERROR: " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
    END.
    RELEASE gre_header_log NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "Error al crear la PGRE desde la GRE(RELEASE gre_header_log) " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " ERROR: " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
    END.
    RELEASE gre_header NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "Error al crear la PGRE desde la GRE(RELEASE gre_header) " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " ERROR: " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
    END.
    RELEASE gre_detail NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "Error al crear la PGRE desde la GRE(RELEASE gre_detail) " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " ERROR: " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
    END.
    RELEASE b-faccpedi NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "Error al crear la PGRE desde la GRE(RELEASE b-faccpedi) " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " ERROR: " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
    END.
    RELEASE b-ccbcdocu NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "Error al crear la PGRE desde la GRE(RELEASE b-ccbcdocu) " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " ERROR: " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
    END.
    IF lAfectaMovAlm = YES THEN DO:    
        RELEASE almacen NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pcRetVal = "Error al crear la PGRE desde la GRE(RELEASE almacen) " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " ERROR: " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
        END.
        RELEASE b-almcmov NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pcRetVal = "Error al crear la PGRE desde la GRE(RELEASE b-almcmov) " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " ERROR: " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
        END.
        RELEASE b-almdmov NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pcRetVal = "Error al crear la PGRE desde la GRE(RELEASE b-almdmov) " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " ERROR: " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO PROCESO_GRABADO, RETURN 'ADM-ERROR'.
        END. 
    END.
    pcRetVal = "OK".
    piNuevoPGRE = iCorrelativo.
END.              

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-actualiza-otr-recepcion-mercaderia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualiza-otr-recepcion-mercaderia Procedure 
PROCEDURE actualiza-otr-recepcion-mercaderia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER rRowIdAlmcmov AS ROWID NO-UNDO.
DEFINE OUTPUT PARAMETER cMsgRetval AS CHAR NO-UNDO.

DEFINE VAR cNroOTR AS CHAR.  

cMsgRetval = "Actualizando OTR y actualizando movimiento de almacen a recepcionado".
 
PROCESO_GRABAR:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    cNroOTR = STRING(b-gre_header.m_nroser,"999") + 
            STRING(b-gre_header.m_nrodoc,"999999").
    FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND b-faccpedi.coddoc = b-gre_header.m_CodDoc AND b-faccpedi.nroped = cNroOTR NO-LOCK NO-ERROR.
    IF AVAILABLE b-faccpedi THEN DO:
        IF b-faccpedi.flgest <> 'A' THEN DO:
            IF b-faccpedi.flgsit = 'C' THEN DO:
                FIND CURRENT b-faccpedi EXCLUSIVE-LOCK NO-ERROR.
                IF LOCKED b-faccpedi THEN DO:
                    RELEASE b-faccpedi NO-ERROR.
                    cMsgRetval = "La tabla FACCPEDI esta bloqueada...imposible actualizar flag situacion de la OTR".                  
                    UNDO PROCESO_GRABAR, RETURN 'ADM-ERROR'.
                END.
                ELSE DO:
                    IF AVAILABLE b-faccpedi THEN DO:
                        ASSIGN b-faccpedi.flgest = 'P'.         /* OJO */
                        ASSIGN b-faccpedi.flgsit = 'PGRE' NO-ERROR.
                        /* ******************************************* */
                        /* 05/08/2024: Actualizar la cantidad atendida */
                        FOR EACH b-facdpedi OF b-faccpedi EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
                            ASSIGN b-facdpedi.canate = 0.       /* OJO */
                        END.
                        /* ******************************************* */
                    END.
                END.                            
            END.
        END.
        ELSE DO:
            cMsgRetVal = "La OTR " + cNroOTR + " esta ANULADA".
            UNDO PROCESO_GRABAR, RETURN 'ADM-ERROR'.
        END.
    END.
    /* */
    IF rRowIdAlmcmov <> ? THEN DO:
        /* Marcamos el movimiento de almacen como BAJA EN SUNAT */
        FIND FIRST b1-almcmov WHERE ROWID(b1-almcmov) = rRowIdAlmcmov EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF LOCKED(b1-almcmov) THEN DO:
            cMsgRetVal = "La tabla almcmov esta bloqueada...imposible cambiar a RECEPCIONADO la salida por transferencia".
            UNDO PROCESO_GRABAR, RETURN 'ADM-ERROR'.
        END.
        IF NOT AVAILABLE b1-almcmov THEN DO:
            cMsgRetVal = "No exite el movimiento en el almacen...imposible cambiar a RECEPCIONADO la salida por transferencia".
            UNDO PROCESO_GRABAR, RETURN 'ADM-ERROR'.
        END.
        IF b1-almcmov.flgsit = 'R' THEN DO:
            cMsgRetVal = "El movimiento en el almacen ya fue recepcionado...imposible cambiar a RECEPCIONADO la salida por transferencia".
            UNDO PROCESO_GRABAR, RETURN 'ADM-ERROR'.
        END.
        /* Como recepcionado */
        ASSIGN b1-almcmov.flgsit = 'B'.
    END.

    RELEASE b-faccpedi NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        cMsgRetVal = "Error (RELEASE b-faccpedi) " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " ERROR: " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO PROCESO_GRABAR, RETURN 'ADM-ERROR'.
    END. 
    RELEASE b1-almcmov NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        cMsgRetVal = "Error (RELEASE b1-almcmov) " + STRING(piSerieGuia,"999") + "-" + STRING(piNumeroGuia,"99999999") + " ERROR: " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO PROCESO_GRABAR, RETURN 'ADM-ERROR'.
    END. 

    cMsgRetVal = "OK".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

