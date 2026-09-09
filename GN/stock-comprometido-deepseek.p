/* *************************** Configuraciones ************************** */
DEFINE VARIABLE cFlgReservaStock AS CHARACTER NO-UNDO INIT "G,X,P,T,W,WX,WL,WC".
DEFINE VARIABLE cTiposMovimiento  AS CHARACTER NO-UNDO INIT "A,M,RAN,INC".
DEFINE VARIABLE cDocumentosCompra AS CHARACTER NO-UNDO INIT "O/D,OTR".
DEFINE VARIABLE iDiasComprometido AS INTEGER   NO-UNDO INIT 30.
DEFINE VARIABLE iDiasReposicion   AS INTEGER   NO-UNDO INIT 60.

/* *************************** Buffers Reutilizables ********************* */
DEFINE BUFFER bDpPed  FOR Facdpedi.
DEFINE BUFFER bCpPed  FOR Faccpedi.
DEFINE BUFFER bAlmRep FOR Almcrepo.
DEFINE BUFFER bDetRep FOR Almdrepo.

/* *************************** Procedimientos **************************** */
PROCEDURE calcularComprometido:
    DEFINE INPUT  PARAMETER pCantidad     AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER pFactor       AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER pCanAten      AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER poComprometido AS DECIMAL NO-UNDO.
    
    poComprometido = pFactor * (pCantidad - pCanAten).
END PROCEDURE.

/* *************************** Main Block ******************************* */
FIND FIRST FacCfgGn WHERE
    FacCfgGn.codcia = s-codcia
    NO-LOCK NO-ERROR.
    
IF NOT AVAILABLE FacCfgGn THEN RETURN.

/* Optimización: Pre-cálculo de fechas límite */
DEFINE VARIABLE dtHoy         AS DATETIME  NO-UNDO INIT NOW.
DEFINE VARIABLE dtFechaCorte AS DATETIME  NO-UNDO.
DEFINE VARIABLE dFechaPedido AS DATE      NO-UNDO.
DEFINE VARIABLE cHoraPedido  AS CHARACTER NO-UNDO.

ASSIGN
    dFechaPedido = DATE(dtHoy)
    cHoraPedido  = ENTRY(2, STRING(dtHoy, "99/99/9999 HH:MM"), " ")
    dtFechaCorte = ADD-INTERVAL(dtHoy, -iDiasComprometido, "days").

/* 1. Optimización: Pedidos Activos Mostrador */
IF pContado THEN DO:
    FOR EACH bDpPed NO-LOCK
        WHERE bDpPed.codcia  = s-codcia
          AND bDpPed.codmat  = pCodMat
          AND bDpPed.coddoc  = 'P/M'
          AND bDpPed.flgest  = 'P'
          AND bDpPed.almdes  = pCodAlm
          AND bDpPed.fchped >= ADD-INTERVAL(TODAY, -iDiasComprometido, "days"),
        
        FIRST bCpPed OF bDpPed NO-LOCK
        WHERE bCpPed.FlgEst = "P":
        
        IF bDpPed.fchped > TODAY OR
          (bDpPed.fchped = dFechaPedido AND bDpPed.hora < cHoraPedido) THEN NEXT.
        
        RUN calcularComprometido(
            INPUT  bDpPed.CanPed,
            INPUT  bDpPed.Factor,
            INPUT  0,  /* CanAten para P/M */
            OUTPUT pComprometido
        ).
    END.
END.

/* 2. Optimización: Pedidos O/D y OTR */
DO TRANSACTION:
    DEFINE VARIABLE iDoc AS INTEGER NO-UNDO.
    
    DO iDoc = 1 TO NUM-ENTRIES(cDocumentosCompra):
        RUN procesarDocumento(
            INPUT pCodAlm,
            INPUT pCodMat,
            INPUT ENTRY(iDoc, cDocumentosCompra),
            INPUT "P",
            INPUT ADD-INTERVAL(TODAY, -iDiasComprometido, "days"),
            INPUT-OUTPUT pComprometido
        ).
    END.
END.

/* 3. Optimización: Guías de Remisión */
RUN procesarGuiasRemision(
    INPUT pCodAlm,
    INPUT pCodMat,
    INPUT-OUTPUT pComprometido
).

/* 4. Optimización: Pedidos al Crédito */
FOR EACH bDpPed NO-LOCK
    WHERE bDpPed.codcia = s-codcia
      AND bDpPed.almdes = pCodAlm
      AND bDpPed.codmat = pCodMat
      AND bDpPed.coddoc = "PED"
      AND bDpPed.flgest = 'P'
      AND bDpPed.FchPed >= dtFechaCorte,
    
    FIRST bCpPed OF bDpPed NO-LOCK
    WHERE LOOKUP(bCpPed.FlgEst, cFlgReservaStock) > 0
      AND bCpPed.FchVen >= TODAY:
    
    IF bDpPed.canate >= bDpPed.CanPed THEN NEXT.
    
    RUN calcularComprometido(
        INPUT  bDpPed.CanPed,
        INPUT  bDpPed.Factor,
        INPUT  bDpPed.canate,
        OUTPUT pComprometido
    ).
END.

/* 5. Optimización: Reposiciones */
RUN procesarReposiciones(
    INPUT pCodAlm,
    INPUT pCodMat,
    INPUT ADD-INTERVAL(TODAY, -iDiasReposicion, "days"),
    INPUT-OUTPUT pComprometido
).

/* 6. Optimización: Cotizaciones */
RUN procesarCotizaciones(
    INPUT pCodAlm,
    INPUT pCodMat,
    INPUT dtFechaCorte,
    INPUT-OUTPUT pComprometido
).

/* *************************** Procedimientos **************************** */
PROCEDURE procesarDocumento:
    DEFINE INPUT  PARAMETER ipCodAlm        AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER ipCodMat        AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER ipCodDoc        AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER ipFlgEst        AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER ipFecha         AS DATE      NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER iopComprometido AS DECIMAL   NO-UNDO.
    
    FOR EACH bDpPed NO-LOCK
        WHERE bDpPed.codcia  = s-codcia
          AND bDpPed.almdes  = ipCodAlm
          AND bDpPed.codmat  = ipCodMat
          AND bDpPed.coddoc  = ipCodDoc
          AND bDpPed.flgest  = "P"
          AND bDpPed.FchPed >= ipFecha,
        
        FIRST bCpPed OF bDpPed NO-LOCK
        WHERE LOOKUP(bCpPed.FlgEst, ipFlgEst) > 0:
        
        IF bDpPed.CanAte >= bDpPed.CanPed THEN NEXT.
        
        RUN calcularComprometido(
            INPUT  bDpPed.CanPed,
            INPUT  bDpPed.Factor,
            INPUT  bDpPed.canate,
            OUTPUT iopComprometido
        ).
    END.
END PROCEDURE.

PROCEDURE procesarReposiciones:
    DEFINE INPUT  PARAMETER ipCodAlm        AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER ipCodMat        AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER ipFechaCorte    AS DATE      NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER iopComprometido AS DECIMAL   NO-UNDO.
    
    DEFINE BUFFER bRep FOR Almcrepo.
    
    FOR EACH bRep NO-LOCK
        WHERE bRep.codcia   = s-codcia
          AND bRep.almped   = ipCodAlm
          AND bRep.flgest   = "P"
          AND bRep.fchdoc  >= ipFechaCorte
          AND bRep.tipmov   = "A",  // Solo movimientos tipo "A"
        
        EACH bDetRep NO-LOCK
        WHERE bDetRep.codcia  = s-codcia
          AND bDetRep.codalm  = bRep.codalm
          AND bDetRep.tipmov  = bRep.tipmov
          AND bDetRep.nroser  = bRep.nroser
          AND bDetRep.nrodoc  = bRep.nrodoc
          AND bDetRep.codmat  = ipCodMat
          AND bDetRep.flgest  = 'P':
        
        iopComprometido = iopComprometido + 
            (bDetRep.CanApro - bDetRep.CanAten).
    END.
END PROCEDURE.
