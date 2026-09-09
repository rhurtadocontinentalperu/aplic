
/* Definimos la clase principal */
CLASS cls_stock_comprometido:
    /* Definimos variables de clase */
    DEFINE PRIVATE STATIC VARIABLE iCodCia AS INTEGER NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE cCodMat AS CHARACTER NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE cCodAlm AS CHARACTER NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE lContado AS LOGICAL NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE fComprometido AS DECIMAL NO-UNDO.

    /* Definimos el constructor */
    CONSTRUCTOR PUBLIC cls_stock_comprometido (INPUT piCodCia AS INTEGER,
                                               INPUT pcCodMat AS CHARACTER,
                                               INPUT pcCodAlm AS CHARACTER,
                                               INPUT plContado AS LOGICAL
                                               ):
        SUPER().
        iCodCia = piCodCia.
        cCodMat = pcCodMat.
        cCodAlm = pcCodAlm.
        lContado = plContado.

    END CONSTRUCTOR.


    METHOD PUBLIC LOGICAL RutinaMaster():

        DEFINE VAR x-flg-reserva-stock AS CHAR.
        /* Buffers de trabajo */
        DEF BUFFER B-CREPO FOR integral.Almcrepo.
        DEF BUFFER B-DREPO FOR integral.Almdrepo.
        DEFINE BUFFER x-gre_detail FOR gre_detail.
        DEFINE BUFFER x-gre_header FOR gre_header.

        fComprometido = 0.  /* Valor por defecto */   
        IF NUM-ENTRIES(cCodAlm) > 1 THEN cCodAlm = ENTRY(1, cCodAlm).   /* El 1er almacén */

        IF lContado = YES THEN fComprometido = ComprometidoMostrador().



        RETURN TRUE.
    END METHOD.

    METHOD PRIVATE DECIMAL ComprometidoMostrador():
    /* ***************************************** */

        DEF VAR pComprometido AS DECIMAL NO-UNDO.

        FIND FIRST FacCfgGn WHERE Faccfggn.codcia = iCodCia NO-LOCK NO-ERROR. 
        IF NOT AVAILABLE Faccfggn THEN RETURN 0.

        DEF BUFFER B-DPEDI FOR integral.Facdpedi.
        DEF BUFFER B-CPEDI FOR integral.Faccpedi.
        
        /* 07/03/2023 Tiempos de Reserva */
        FIND FIRST FacCfgVta WHERE FacCfgVta.CodCia = iCodCia AND
            FacCfgVta.CodDoc = "P/M" AND
            (TODAY >= FacCfgVta.FechaD AND TODAY <= FacCfgVta.FechaH)
            NO-LOCK NO-ERROR.
        /* ********************************************************************************************* */
        /* Stock comprometido por PEDIDOS ACTIVOS MOSTRADOR */
        /* ********************************************************************************************* */
        DEF VAR TimeOut AS INTEGER NO-UNDO.
        DEF VAR TimeNow AS INTEGER NO-UNDO.
        DEF VAR TimeLimit AS CHARACTER NO-UNDO.
        /* Definimos rango de fecha y hora */
        DEF VAR dtDesde AS DATETIME NO-UNDO.
        DEF VAR fDesde AS DATE NO-UNDO.
        DEF VAR cHora  AS CHAR NO-UNDO.
        /* Tiempo por defecto fuera de campaña (segundos) */
        TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
                  (FacCfgGn.Hora-Res * 3600) + 
                  (FacCfgGn.Minu-Res * 60).
        IF AVAILABLE FacCfgVta THEN TimeOut = (FacCfgVta.Dias-Res * 24 * 3600) +
                  (FacCfgVta.Hora-Res * 3600) + 
                  (FacCfgVta.Minu-Res * 60).
    
        dtDesde = ADD-INTERVAL(NOW, (-1 * TimeOut) , 'seconds').
        fDesde = DATE(dtDesde).
        cHora  = ENTRY(2,STRING(dtDesde, '99/99/9999 HH:MM'), ' ').

        FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = iCodCia
            AND B-DPEDI.codmat = cCodMat
            AND B-DPEDI.coddoc = 'P/M'
            AND B-DPEDI.flgest = 'P'
            AND B-DPEDI.almdes = cCodAlm
            AND B-DPEDI.fchped >= fDesde,
            FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.FlgEst = "P":
            IF B-DPEDI.fchped > TODAY THEN NEXT.
            IF B-DPEDI.fchped = fDesde AND B-DPEDI.hora < cHora THEN NEXT.
            /* cantidad en reservacion */
            pComprometido = pComprometido + (B-DPEDI.Factor * B-DPEDI.CanPed).
        END.

        RETURN pComprometido.

    END METHOD.


END CLASS.

    
