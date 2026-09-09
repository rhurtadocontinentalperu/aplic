
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


    METHOD PUBLIC DECIMAL RutinaMaster():

        DEFINE VAR x-flg-reserva-stock AS CHAR.
        /* Buffers de trabajo */
        DEF BUFFER B-CREPO FOR integral.Almcrepo.
        DEF BUFFER B-DREPO FOR integral.Almdrepo.
        DEFINE BUFFER x-gre_detail FOR gre_detail.
        DEFINE BUFFER x-gre_header FOR gre_header.

        fComprometido = 0.  /* Valor por defecto */   
        IF NUM-ENTRIES(cCodAlm) > 1 THEN cCodAlm = ENTRY(1, cCodAlm).   /* El 1er almacén */

        IF lContado = YES THEN fComprometido = ComprometidoMostrador().

        /* ********************************************************************************************* */
        /**********   Barremos para los O/D y OTR   ***********************/ 
        /* ********************************************************************************************* */
        
        fComprometido = fComprometido + ComprometidoPedido(INPUT "O/D", INPUT "P").
        fComprometido = fComprometido + ComprometidoPedido(INPUT "OTR", INPUT "P").
        fComprometido = fComprometido + ComprometidoGRE().
        fComprometido = fComprometido + ComprometidoCredito(INPUT "PED", INPUT "G,X,P,T,W,WX,WL,WC").
        fComprometido = fComprometido + ComprometidoReposiciones(INPUT "P,X", INPUT "A,M,RAN,INC").
        fComprometido = fComprometido + ComprometidoCOT(INPUT "P").

        RETURN fComprometido.

    END METHOD.

    METHOD PRIVATE DECIMAL ComprometidoCOT(INPUT pcFlgEst AS CHAR):

        DEF VAR pComprometido AS DECIMAL NO-UNDO.
        DEF VAR TimeLimit AS CHARACTER NO-UNDO.
        DEF VAR TimeOut AS INTEGER NO-UNDO.
        DEF VAR dtDesde AS DATETIME NO-UNDO.
        DEF VAR fDesde AS DATE NO-UNDO.
        DEF VAR cHora  AS CHAR NO-UNDO.
        DEF VAR x-flg-reserva-stock AS CHAR NO-UNDO.
        DEF BUFFER B-DPEDI FOR integral.Facdpedi.
        DEF BUFFER B-CPEDI FOR integral.Faccpedi.


        /* Barremos todas las divisiones que comprometen stock por COTIZACIONES */
        RLOOP:
        FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = iCodCia AND
            FacTabla.tabla = 'GN-DIVI' AND
            FacTabla.campo-l[2] = YES AND
            FacTabla.Valor[1] > 0:
            /* RHC 21/05/2020 Ahora tiene horas y/o hora tope */
            /* Pasada esa hora NO vale la Cotización */
            TimeLimit = ''.
            IF FacTabla.campo-c[1] > '' AND FacTabla.campo-c[1] > '0000' THEN DO:
                TimeLimit = STRING(FacTabla.campo-c[1], 'XX:XX').
                IF STRING(TIME, 'HH:MM') > TimeLimit THEN NEXT RLOOP.
            END.
            TimeOut = 0.
            IF FacTabla.valor[1] > 0 THEN TimeOut = (FacTabla.Valor[1] * 3600).       /* Tiempo máximo en segundos */
            dtDesde = ADD-INTERVAL(NOW, (-1 * TimeOut) , 'seconds').
            fDesde = DATE(dtDesde).
            cHora  = ENTRY(2,STRING(dtDesde, '99/99/9999 HH:MM'), ' ').
            /* Estados Válidos */
            x-flg-reserva-stock = "P".
            FIND FIRST VtaTabla WHERE VtaTabla.codcia = iCodCia AND
                VtaTabla.tabla = "CONFIG-VTAS" AND
                VtaTabla.llave_c1 = "PEDIDO.COMERCIAL" AND
                VtaTabla.llave_c2 = "FLG.RESERVA.STOCK" AND
                VtaTabla.llave_c3 = FacTabla.Codigo NO-LOCK NO-ERROR.     /* division */
            IF AVAILABLE VtaTabla THEN DO:
               IF NOT (TRUE <> (VtaTabla.llave_c4 > "")) THEN DO:
                    x-flg-reserva-stock = TRIM(VtaTabla.llave_c4).
               END.
            END.
            /* Barremos todas las cotizaciones relacionadas */
            FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = iCodCia
                AND B-DPEDI.codmat = cCodMat
                AND B-DPEDI.coddoc = 'COT'
                AND B-DPEDI.flgest = pcFlgEst 
                AND B-DPEDI.almdes = cCodAlm
                AND B-DPEDI.fchped >= fDesde,
                FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.CodDiv = FacTabla.Codigo:
                IF B-DPEDI.fchped > TODAY THEN NEXT.
                IF LOOKUP(B-CPEDI.FlgEst,x-Flg-Reserva-Stock) = 0 THEN NEXT.
                IF B-DPEDI.CanAte >= B-DPEDI.CanPed THEN NEXT.
                IF B-DPEDI.fchped = fDesde AND B-DPEDI.hora < cHora THEN NEXT.
                /* cantidad en reserva */
                pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.CanAte)).
            END.
        END.
        RETURN pComprometido.
       
    END METHOD.


    METHOD PRIVATE DECIMAL ComprometidoReposiciones (INPUT pcFlgEst AS CHAR, INPUT pcTipMov AS CHAR):
    /* ******************************************************************************************* */
        DEF BUFFER B-CREPO FOR integral.Almcrepo.
        DEF BUFFER B-DREPO FOR integral.Almdrepo.
    
        DEFINE VAR LocalDiasComprometidoRAN AS DECI INIT 60 NO-UNDO.      /* Exagerando */
        DEFINE VAR j AS INTE NO-UNDO.
        DEFINE VAR k AS INTE NO-UNDO.
        DEFINE VAR pComprometido AS DECIMAL NO-UNDO.
    
        DO j = 1 TO 2:
            DO k = 1 TO 4:
                FOR EACH B-CREPO NO-LOCK WHERE B-CREPO.codcia = iCodCia
                    AND B-CREPO.almped = cCodAlm
                    AND B-CREPO.flgest = ENTRY(j, pcFlgEst)
                    AND B-CREPO.tipmov = ENTRY(k, pcTipMov)
                    AND B-CREPO.fchdoc >= (TODAY - LocalDiasComprometidoRAN),    /* OJO: No mas de 60 días */
                    EACH B-DREPO NO-LOCK WHERE B-DREPO.codcia = iCodCia
                    AND B-DREPO.codalm = B-CREPO.codalm
                    AND B-DREPO.tipmov = B-CREPO.tipmov
                    AND B-DREPO.nroser = B-CREPO.nroser
                    AND B-DREPO.nrodoc = B-CREPO.nrodoc
                    AND B-DREPO.codmat = cCodMat
                    AND B-DREPO.flgest = 'P':
                    pComprometido = pComprometido + (B-DREPO.CanApro - B-DREPO.CanAten).
                END.
            END.
        END.
        RETURN pComprometido.

    END METHOD.


    METHOD PRIVATE DECIMAL ComprometidoCredito(INPUT pcCodDoc AS CHAR, INPUT pcFlgEst AS CHAR):
    /* ************************************************************************************* */
        DEFINE VAR x-fecha AS DATE.
        DEFINE VAR LocalDiasComprometido AS DECI INIT 30 NO-UNDO.      /* Exagerando */
        DEFINE VAR LocalDiasComprometidoRAN AS DECI INIT 60 NO-UNDO.      /* Exagerando */
        DEFINE VAR pComprometido AS DECIMAL NO-UNDO.

        DEF BUFFER B-DPEDI FOR integral.Facdpedi.
        DEF BUFFER B-CPEDI FOR integral.Faccpedi.

        FIND FIRST VtaTabla WHERE VtaTabla.CodCia = iCodCia AND 
            VtaTabla.Tabla = 'CONFIG-VTAS' AND 
            VtaTabla.Llave_c1 = 'STOCK-COMPROMETIDO'
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla AND VtaTabla.Valor[01] > 0 THEN LocalDiasComprometido = VtaTabla.Valor[01].
        x-fecha = (TODAY - LocalDiasComprometido).


        DEFINE VAR x-sec AS INT.
        
        FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = iCodCia
            AND B-DPEDI.almdes = cCodAlm
            AND B-DPEDI.codmat = cCodMat
            AND B-DPEDI.coddoc = pcCodDoc
            AND B-DPEDI.flgest = 'P'
            AND B-DPEDI.FchPed >= x-fecha,
            FIRST B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = B-DPEDI.codcia
                AND B-CPEDI.coddiv = B-DPEDI.coddiv
                AND B-CPEDI.coddoc = B-DPEDI.coddoc
                AND B-CPEDI.nroped = B-DPEDI.nroped :
            IF LOOKUP(B-CPEDI.FlgEst, pcFlgEst) = 0 THEN NEXT.
            IF B-CPEDI.FchVen < TODAY THEN NEXT.    /* OJO */
            IF B-DPEDI.canate >= B-DPEDI.CanPed THEN NEXT.
            pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
        END.
        RETURN pComprometido.

    END METHOD.


    METHOD PRIVATE DECIMAL ComprometidoGRE():
    /* *********************************** */
        DEF VAR pComprometido AS DECIMAL NO-UNDO.

        FOR EACH gre_detail WHERE gre_detail.reserva_stock = "SI" AND 
                gre_detail.codmat = cCodMat NO-LOCK,
            FIRST gre_header WHERE gre_detail.ncorrelativo = gre_header.ncorrelatio AND
                gre_header.m_codalm = cCodAlm NO-LOCK :
            pComprometido = pComprometido + (gre_detail.candes * gre_detail.factor).
        END.
        RETURN pComprometido.
    END METHOD.

    METHOD PRIVATE DECIMAL ComprometidoPedido(INPUT pcCodDoc AS CHAR, INPUT pcFlgEst AS CHAR):
    /* ************************************************************************************ */
        DEFINE VAR x-fecha AS DATE NO-UNDO.
        DEFINE VAR LocalDiasComprometido AS DECI INIT 30 NO-UNDO.           /* Exagerando */
        DEFINE VAR LocalDiasComprometidoRAN AS DECI INIT 60 NO-UNDO.        /* Exagerando */
        DEFINE VAR fComprometido AS DECIMAL NO-UNDO.
    
        FIND FIRST VtaTabla WHERE VtaTabla.CodCia = iCodCia AND 
            VtaTabla.Tabla = 'CONFIG-VTAS' AND 
            VtaTabla.Llave_c1 = 'STOCK-COMPROMETIDO'
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla AND VtaTabla.Valor[01] > 0 THEN LocalDiasComprometido = VtaTabla.Valor[01].
        x-fecha = (TODAY - LocalDiasComprometido).

        DEF BUFFER B-DPEDI FOR Facdpedi.
        DEF BUFFER B-CPEDI FOR Faccpedi.

        /* 03/02/2023 L.Mesia la OTR reserva stock de otra manera */
        FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = iCodCia
            AND B-DPEDI.almdes = cCodAlm
            AND B-DPEDI.codmat = cCodMat
            AND B-DPEDI.coddoc = pcCodDoc
            AND B-DPEDI.flgest = "P"
            AND B-DPEDI.FchPed >= x-Fecha,
            FIRST B-CPEDI OF B-DPEDI NO-LOCK:
            IF B-DPEDI.CanAte >= B-DPEDI.canped THEN NEXT.
            IF LOOKUP(B-CPEDI.FlgEst, pcFlgEst) = 0 THEN NEXT.
            fComprometido = fComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
        END.
        RETURN fComprometido.


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

    
