DEF NEW SHARED VAR s-codcia AS INTE INIT 001.
DEF NEW SHARED VAR s-codmat AS CHAR INIT '079812'.

DEF BUFFER x-vtatabla FOR vtatabla.
DEF BUFFER B-DPEDI FOR facdpedi.
DEF BUFFER B-CPEDI FOR faccpedi.
DEFINE BUFFER x-gre_detail FOR gre_detail.
DEFINE BUFFER x-gre_header FOR gre_header.
DEFINE BUFFER B-CREPO FOR almcrepo.
DEFINE BUFFER B-DREPO FOR almdrepo.


DEF VAR x-Total AS DECI.

DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.
DEF VAR fDesde  AS DATE    NO-UNDO.
DEF VAR dtDesde AS DATETIME NO-UNDO.
DEF VAR cHora   AS CHAR    NO-UNDO.

x-Total = 0.

FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK.
/* 07/03/2023 Tiempos de Reserva */
FIND FIRST FacCfgVta WHERE FacCfgVta.CodCia = s-codcia AND
    FacCfgVta.CodDoc = "P/M" AND
    (TODAY >= FacCfgVta.FechaD AND TODAY <= FacCfgVta.FechaH)
    NO-LOCK NO-ERROR.

DEFINE VAR x-fecha AS DATE.
DEFINE VAR LocalDiasComprometido AS DECI INIT 30 NO-UNDO.      /* Exagerando */
DEFINE VAR x-flg-reserva-stock AS CHAR.
DEFINE VAR TimeLimit AS CHAR NO-UNDO.

DEF VAR j AS INTE NO-UNDO.
DEF VAR k AS INTE NO-UNDO.
DEF VAR x-FlgEst AS CHAR INIT 'P,X' NO-UNDO.
DEF VAR x-TipMov AS CHAR INIT 'A,M,RAN,INC' NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').

TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
          (FacCfgGn.Hora-Res * 3600) + 
          (FacCfgGn.Minu-Res * 60).
IF AVAILABLE FacCfgVta THEN TimeOut = (FacCfgVta.Dias-Res * 24 * 3600) +
          (FacCfgVta.Hora-Res * 3600) + 
          (FacCfgVta.Minu-Res * 60).
dtDesde = ADD-INTERVAL(NOW, (-1 * TimeOut) , 'seconds').
fDesde = DATE(ADD-INTERVAL(NOW, (-1 * TimeOut) , 'seconds')).
cHora  = ENTRY(2,STRING(dtDesde, '99/99/9999 HH:MM'), ' ').

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia AND 
    VtaTabla.Tabla = 'CONFIG-VTAS' AND 
    VtaTabla.Llave_c1 = 'STOCK-COMPROMETIDO'
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla AND VtaTabla.Valor[01] > 0 THEN LocalDiasComprometido = VtaTabla.Valor[01].
x-fecha = (TODAY - LocalDiasComprometido).

/* Solo barremos los almacenes donde esté ASIGNADO el artículo */
DEF VAR a AS INT64.
a = ETIME(YES).

FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia
        AND Almacen.Campo-c[9] <> "I" AND Almacen.FlgRep = YES /*AND Almacen.Campo-c[6] = "Si"*/,
    FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = Almacen.codalm 
        AND Almmmate.codmat = s-CodMat
        AND Almmmate.stkact > 0:    /* OJO */

    FOR EACH B-DPEDI /*USE-INDEX Llave05*/ NO-LOCK WHERE B-DPEDI.CodCia = s-codcia 
        AND B-DPEDI.codmat = s-codmat 
        AND B-DPEDI.coddoc = 'P/M'
        AND B-DPEDI.FlgEst = "P"
        AND B-DPEDI.AlmDes = "11"
        AND (B-DPEDI.fchped >= fDesde 
        /*AND B-DPEDI.fchped <= TODAY*/),
        FIRST B-CPEDI OF B-DPEDI WHERE B-CPEDI.FlgEst = "P" NO-LOCK:
        IF B-DPEDI.fchped > TODAY THEN NEXT.

        IF B-DPEDI.fchped = fDesde AND B-DPEDI.hora < cHora THEN NEXT.
        /* cantidad en reservacion */
    END.

    /*********   Barremos las O/D que son parciales y totales    ****************/
    RUN PED-Comprometido (Almacen.CodAlm,s-CodMat,"O/D","P",INPUT-OUTPUT x-Total).

    /* ORDENES Y SOLICITUDES DE TRANSFERENCIA */
    RUN PED-Comprometido (Almacen.CodAlm,s-CodMat,"OTR","P",INPUT-OUTPUT x-Total).

    /* Guia de remision electronica PGRE */
    RUN GRE-Comprometido (Almacen.CodAlm,s-CodMat,INPUT-OUTPUT x-Total).
    
    /* ORDENES Y SOLICITUDES DE TRANSFERENCIA */
    /* RHC Solo almacenes comerciales */
    x-flg-reserva-stock = "G,X,P,T,W,WX,WL,WC".

    FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.CodCia = s-codcia 
            AND  B-DPEDI.almdes = Almacen.codalm
            AND  B-DPEDI.codmat = s-codmat 
            AND  B-DPEDI.CodDoc = 'PED'
            AND  B-DPEDI.FlgEst = 'P'
            AND B-DPEDI.FchPed >= x-fecha,
        FIRST B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = B-DPEDI.codcia
            AND B-CPEDI.coddiv = B-DPEDI.coddiv
            AND B-CPEDI.coddoc = B-DPEDI.coddoc
            AND B-CPEDI.nroped = B-DPEDI.nroped:
        IF LOOKUP(B-CPEDI.FlgEst, x-flg-reserva-stock) = 0 THEN NEXT.
        IF B-CPEDI.FchVen < TODAY THEN NEXT.    /* OJO */
        IF B-DPEDI.CanAte >= B-DPEDI.CanPed THEN NEXT.
    END.
    DO j = 1 TO 2:
        DO k = 1 TO 4:
            FOR EACH B-CREPO NO-LOCK WHERE B-CREPO.codcia = s-codcia
                    AND B-CREPO.almped = Almacen.CodAlm
                    AND B-CREPO.flgest = ENTRY(j, x-FlgEst)
                    AND B-CREPO.tipmov = ENTRY(k, x-TipMov)
                    AND B-CREPO.fchdoc >= (TODAY - 60),    /* OJO: No mas de 60 días */
                EACH B-DREPO NO-LOCK WHERE B-DREPO.codcia = s-codcia
                    AND B-DREPO.codalm = B-CREPO.codalm
                    AND B-DREPO.tipmov = B-CREPO.tipmov
                    AND B-DREPO.nroser = B-CREPO.nroser
                    AND B-DREPO.nrodoc = B-CREPO.nrodoc
                    AND B-DREPO.codmat = s-CodMat
                    AND B-DREPO.flgest = 'P':
                /* cantidad en reservacion */
            END.
        END.
    END. 

    /* ******************************************************* */
    /* RHC 23/04/2020 Mercadería comprometida por Cotizaciones */
    /* ******************************************************* */
    RLOOP:
    FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-CodCia AND
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
        IF FacTabla.valor[1] > 0 THEN TimeOut = (FacTabla.Valor[1] * 3600).       /* Tiempo máximo en en segundos */
        dtDesde = ADD-INTERVAL(NOW, (-1 * TimeOut) , 'seconds').
        fDesde = DATE(dtDesde).
        cHora  = ENTRY(2,STRING(dtDesde, '99/99/9999 HH:MM'), ' ').
        /* Barremos todas las cotizaciones relacionadas */
        x-flg-reserva-stock = "P".
        FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
            x-vtatabla.tabla = "CONFIG-VTAS" AND
            x-vtatabla.llave_c1 = "PEDIDO.COMERCIAL" AND
            x-vtatabla.llave_c2 = "FLG.RESERVA.STOCK" AND
            x-vtatabla.llave_c3 = FacTabla.Codigo NO-LOCK NO-ERROR.     /* division */
        IF AVAILABLE x-vtatabla THEN DO:
            IF NOT (TRUE <> (x-vtatabla.llave_c4 > "")) THEN DO:
                x-flg-reserva-stock = TRIM(x-vtatabla.llave_c4).
            END.
        END.
        FOR EACH B-DPEDI /*USE-INDEX Llave05*/ NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
            AND B-DPEDI.codmat = s-CodMat
            AND B-DPEDI.coddoc = 'COT'
            AND B-DPEDI.flgest = 'P'
            AND B-DPEDI.almdes = Almacen.CodAlm
            AND (B-DPEDI.fchped >= fDesde 
                 /*AND B-DPEDI.fchped <= TODAY*/),
            FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.CodDiv = FacTabla.Codigo:
            IF B-DPEDI.fchped > TODAY THEN NEXT.

            IF LOOKUP(B-CPEDI.FlgEst,x-flg-reserva-stock) = 0 THEN NEXT.
            IF B-DPEDI.CanAte >= B-DPEDI.CanPed THEN NEXT.
            IF B-DPEDI.fchped = fDesde AND B-DPEDI.hora < cHora THEN NEXT.
            /* cantidad en reserva */
        END.
    END.


END.
MESSAGE ETIME.


PROCEDURE PED-Comprometido:

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pFlgEst AS CHAR.
DEF INPUT-OUTPUT PARAMETER pComprometido AS DECI.

DEFINE VAR x-flg-reserva-stock AS CHAR.
DEF VAR k AS INTE NO-UNDO.

x-flg-reserva-stock = pFlgEst.
/* 03/02/2023 L.Mesia la OTR reserva stock de otra manera */

FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-codcia
    AND B-DPEDI.almdes = pCodAlm
    AND B-DPEDI.codmat = pCodMat
    AND B-DPEDI.coddoc = pCodDoc
    AND B-DPEDI.flgest = "P"
    AND B-DPEDI.FchPed >= (TODAY - 30),
    FIRST B-CPEDI OF B-DPEDI NO-LOCK:
    IF B-DPEDI.CanAte >= B-DPEDI.canped THEN NEXT.
    IF LOOKUP(B-CPEDI.FlgEst, x-flg-reserva-stock) = 0 THEN NEXT.
END.

END PROCEDURE.


PROCEDURE GRE-Comprometido:

    DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT-OUTPUT PARAMETER pComprometido AS DECI.

FOR EACH x-gre_detail WHERE x-gre_detail.reserva_stock = "SI" AND 
        x-gre_detail.codmat = pCodMat NO-LOCK,
    FIRST x-gre_header WHERE x-gre_detail.ncorrelativo = x-gre_header.ncorrelatio AND
        x-gre_header.m_codalm = pCodAlm NO-LOCK :
END.

END PROCEDURE.

