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

DEFINE INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pFlgEst AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO. 

/*
    pRetval : - retorna OK
              - El mensaje de error de la validacion
*/


DEFINE VAR x-division-veri AS CHAR INIT "".
DEFINE VAR cSaltoLinea AS CHAR.

DEF NEW SHARED VAR s-codcia AS INT.   
DEF NEW SHARED VAR cl-codcia AS INT.   
DEF NEW SHARED VAR s-user-id AS CHAR.
DEF NEW SHARED VAR s-coddiv AS CHAR.   

/* PRODUCTOS POR ROTACION */
DEFINE NEW SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.
DEFINE NEW SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE NEW SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE NEW SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.
DEFINE NEW SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEFINE NEW SHARED VAR s-TpoPed AS CHAR.

cSaltoLinea = CHR(13) + CHR(10).
s-User-Id = USERID("DICTDB").
s-Codcia = 1.
cl-codcia = 0.

/*DEFINE BUFFER x-faccpedi FOR faccpedi.*/
DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER COTIZACION FOR Faccpedi.
DEF BUFFER BONIFICACION FOR Faccpedi.
DEF BUFFER B-DPEDI FOR facdpedi.

/* Verificar si esta pendiente */
&SCOPED-DEFINE CondicionVeri ~
( FacCPedi.CodCia = s-Codcia ~
AND FacCPedi.CodDoc = pCoddoc ~
AND FacCPedi.CodDiv = x-division-veri ~
AND FacCPedi.FlgEst = pflgest ~
)

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
         HEIGHT             = 12.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND FIRST faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.coddoc = pCodDoc AND
                            faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.

IF NOT AVAILABLE faccpedi THEN DO:
    pRetVal = "El documento " + pCodDoc + " " + pNroDoc + " no existe".
    RETURN "ADM-ERROR".
END.

DEF VAR LocalMaster AS CHAR NO-UNDO.
DEF VAR LocalRelacionados AS CHAR NO-UNDO.
DEF VAR LocalAgrupados AS LOG NO-UNDO.
DEF VAR LocalCliente AS CHAR NO-UNDO.
DEF VAR x-CodUbic AS CHAR INIT 'ANP' NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR x-Cuenta AS INT NO-UNDO.

x-division-veri = Faccpedi.CodDiv.

RUN ccb/p-cliente-master (Faccpedi.CodCli,
                    OUTPUT LocalMaster,
                    OUTPUT LocalRelacionados,
                    OUTPUT LocalAgrupados).
IF LocalAgrupados = YES AND LocalRelacionados > '' THEN .
ELSE LocalRelacionados = Faccpedi.CodCli.

FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-Codcia
    AND Ccbcdocu.flgest = 'P'
    AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,LET,N/D,CHQ') > 0
    AND LOOKUP(CcbCDocu.CodCli, LocalRelacionados) > 0      /*Ccbcdocu.codcli = Faccpedi.codcli*/    
    AND (Ccbcdocu.fchvto + 5) < TODAY   /*AND (Ccbcdocu.fchvto + 8) < TODAY*/
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN DO:
    pRetval = 'El cliente/grupo tiene una deuda atrazada:' + cSaltoLinea +
        'Cliente:' + Ccbcdocu.nomcli + cSaltoLinea + 
        'Documento:' + Ccbcdocu.coddoc + " " + Ccbcdocu.nrodoc + cSaltoLinea +
        'Vencimiento:' + string(Ccbcdocu.fchvto,"99/99/9999").
    RETURN "ADM-ERROR".
END.

IF NOT {&CondicionVeri} OR CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate <> 0 NO-LOCK) THEN DO:
    pRetVal =  'El documento' + Faccpedi.coddoc + " " + Faccpedi.nroped + ' ya NO se encuentra pendiente de aprobación'.
    RETURN "ADM-ERROR".
END.

FIND FIRST COTIZACION WHERE COTIZACION.CodCia = FacCPedi.CodCia
  AND COTIZACION.CodDiv = INTEGRAL.FacCPedi.CodDiv
  AND COTIZACION.CodDoc = INTEGRAL.FacCPedi.CodRef
  AND COTIZACION.NroPed = INTEGRAL.FacCPedi.NroRef NO-LOCK NO-ERROR.
IF NOT AVAILABLE cotizacion THEN DO:
    pRetVal =  'El pedido comercial del documento' + Faccpedi.coddoc + " " + Faccpedi.nroped + ' no se encuentra'.
    RETURN "ADM-ERROR".
END.
IF cotizacion.flgest = 'A' THEN DO:
    pRetVal =  'El pedido comercial del documento' + Faccpedi.coddoc + " " + Faccpedi.nroped + ' esta anulado'.
    RETURN "ADM-ERROR".
END.

GRABACION:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pRetVal = "Imposible bloquear FACCPEDI" + cSaltoLinea + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABACION, LEAVE GRABACION.
    END.
    ASSIGN
        Faccpedi.Flgest = 'P'
        Faccpedi.UsrAprobacion = USERID("DICTDB")
        Faccpedi.FchAprobacion = TODAY.
    /* RHC 30/12/2015 Para no depender del vendedor o el tipo de venta
        vamos a fijarnos en el tipo de canal de venta de la division */
    FIND gn-divi WHERE gn-divi.codcia = COTIZACION.codcia
        AND gn-divi.coddiv = COTIZACION.coddiv NO-LOCK.
    CASE pFlgEst:
        WHEN "X" OR WHEN "T" THEN DO:   /* Aprobado por CREDITOS y COBRANZAS Y TESORERIA */
            /* RHC 01.12.2011 Chequeo de precios con bajo margen SOLO ATE */
            /* si el margen es bajo pasan para pre-aprobarlos por SECR. GG (W) */
            IF Faccpedi.coddiv = '00000' THEN DO:
                {vta2/i-verifica-margen-utilidad-1.i}
            END.
            /* Trámite Documentario pasa a ser aprobado por Logística */
            IF Faccpedi.TipVta = "Si" THEN DO:
                /*ASSIGN Faccpedi.FlgEst = "WC".*/
                ASSIGN Faccpedi.FlgEst = "WL".
            END.
            /* Supermercados pasa a APROBACION POR SECR. GG */
            IF GN-DIVI.CanalVenta = "MOD" THEN DO:  /* SUPERMERCADOS */
                ASSIGN Faccpedi.FlgEst = "W".
            END.
            x-CodUbic = "ANPX".
        END.
        WHEN "WC" THEN DO:
            /* Pasa a ser aprobado por LOGISTICA */
            ASSIGN
                Faccpedi.Flgest = 'WL'.     /* Aprobaciòn por Logística */
            x-CodUbic = "ANPWX".
        END.
        WHEN "W" THEN DO:   /* Aprobado por Asistente de Gerencia General */
            ASSIGN
                Faccpedi.Flgest = 'WX'.     /* Aprobaciòn por Gerencia General */
            /* Provincias pasa a APROBACION POR LOGISTICA */
            IF GN-DIVI.CanalVenta = "PRO" THEN DO:  /* PROVINCIAS */
                ASSIGN Faccpedi.FlgEst = "WL".
            END.
            /* Supermercados pasa a APROBACION POR LOGISTICA */
            IF GN-DIVI.CanalVenta = "MOD" THEN DO:  /* SUPERMERCADOS */
                ASSIGN Faccpedi.FlgEst = "WL".
            END.
            /* RHC 18.04.2012 APROBACION AUTOMATICA (TEMPORAL) */
            IF Faccpedi.FlgEst = "WL" THEN Faccpedi.FlgEst = "P".
            /* ************************************ */
            x-CodUbic = "ANPWX".
        END.
    END CASE.

    /* TRACKING */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            s-User-Id,
                            x-CodUbic,
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed).

    /* RHC 13.07.2012 GENERACION AUTOMATICA DE ORDENES DE DESPACHO */
    /* RHC 08/02/2018 Se puede crear una O/D o una OTR */
    DEF VAR hProc AS HANDLE NO-UNDO.
    DEF VAR pComprobante AS CHAR NO-UNDO.
    DEF VAR pxFlgEst AS CHAR NO-UNDO.
    DEF VAR pRowid AS ROWID NO-UNDO.

    RUN vtagn/ventas-library PERSISTENT SET hProc.

    pMensaje = "".
    pRowid = ROWID(Faccpedi).
    pxFlgEst = Faccpedi.FlgEst.  /* OJO */

    CASE TRUE:
        WHEN Faccpedi.CrossDocking = NO THEN DO:
            RUN VTA_Genera-OD IN hProc ( pRowid, OUTPUT pComprobante, OUTPUT pMensaje).
            pRetVal = pMensaje.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO GRABACION, LEAVE GRABACION. 
        END.
        WHEN Faccpedi.CrossDocking = YES THEN DO:
            RUN VTA_Genera-OTR IN hProc ( pRowid, OUTPUT pMensaje).
            pRetVal = pMensaje.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO GRABACION, LEAVE GRABACION. 
        END.
    END CASE.
    /* ********************************************************* */
    /* RHC 07/01/2020 ExpoBodega BONIFICACION amarrada al BONIFICACION */
    /* ********************************************************* */
    FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK.
    FIND BONIFICACION WHERE BONIFICACION.CodCia = Faccpedi.codcia AND
        BONIFICACION.CodDiv = Faccpedi.coddiv AND
        BONIFICACION.CodDoc = Faccpedi.coddoc AND
        BONIFICACION.CodRef = Faccpedi.codref AND
        BONIFICACION.NroRef = Faccpedi.nroref AND
        BONIFICACION.CodOrigen = Faccpedi.coddoc AND
        BONIFICACION.NroOrigen = Faccpedi.nroped NO-LOCK NO-ERROR.
    IF AVAILABLE BONIFICACION THEN DO:
        FIND CURRENT BONIFICACION EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="x-Cuenta"}
            pRetVal = pMensaje.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO GRABACION, LEAVE GRABACION. 
        END.
        ASSIGN
            BONIFICACION.FlgEst = pxFlgEst
            BONIFICACION.UsrAprobacion = Faccpedi.UsrAprobacion
            BONIFICACION.FchAprobacion = Faccpedi.FchAprobacion.
        pMensaje = "".
        CASE TRUE:
            WHEN BONIFICACION.CrossDocking = NO THEN DO:
                RUN VTA_Genera-OD IN hProc (ROWID(BONIFICACION), OUTPUT pComprobante, OUTPUT pMensaje).
                pRetVal = pMensaje.
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO GRABACION, LEAVE GRABACION. 
            END.
            WHEN BONIFICACION.CrossDocking = YES THEN DO:
                RUN VTA_Genera-OTR IN hProc (ROWID(BONIFICACION), OUTPUT pMensaje).
                pRetVal = pMensaje.
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO GRABACION, LEAVE GRABACION. 
            END.
        END CASE.
        RELEASE BONIFICACION.
    END.
    DELETE PROCEDURE hProc.
    /* ********************************************************* */
    FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
END.

pRetVal = "".

IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
RELEASE BONIFICACION NO-ERROR.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


