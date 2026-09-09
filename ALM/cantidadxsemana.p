DEF VAR s-codcia AS INT INIT 001.
DEF VAR s-periodo AS INT INIT 2004.
DEF VAR x-FechaD AS DATE.
DEF VAR x-FechaH AS DATE.
DEF VAR x-Fecha  AS DATE.
DEF VAR x-NroFchD AS INT.
DEF VAR x-NroFchH AS INT.
DEF VAR i AS INT.

DEF TEMP-TABLE DETALLE
    FIELD codcia LIKE almmmatg.codcia
    FIELD codmat LIKE almmmatg.codmat
    FIELD desmat LIKE almmmatg.desmat 
    FIELD desmar LIKE almmmatg.desmar format 'x(20)'
    FIELD codpro LIKE gn-prov.codpro
    FIELD nompro LIKE gn-prov.nompro 
    FIELD ruc    LIKE gn-prov.ruc
    FIELD undbas LIKE almmmatg.undbas format 'x(4)'
    FIELD cantidad AS DEC EXTENT 18 format '->>>>9'
    FIELD venta    AS DEC EXTENT 18 format '->>>>9'
    INDEX LLave01 AS PRIMARY codcia codmat.

FOR EACH Almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.tpoart <> 'D' AND almmmatg.codfam = '002'
        NO-LOCK
        BY Almmmatg.codmat:
display almmmatg.codmat. pause 0.
    FIND DETALLE OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE THEN CREATE DETALLE.
    BUFFER-COPY Almmmatg TO DETALLE.
    FIND GN-PROV WHERE gn-prov.codcia = 0
        AND gn-prov.codpro = almmmatg.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-PROV
    THEN ASSIGN
            DETALLE.codpro = gn-prov.codpro
            DETALLE.nompro = gn-prov.nompro
            DETALLE.ruc    = gn-prov.ruc.
    FOR EACH PL-SEM WHERE pl-sem.codcia = s-codcia AND pl-sem.periodo = s-periodo
            AND pl-sem.nrosem >= 01 AND pl-sem.nrosem <= 18 NO-LOCK:
        ASSIGN
            x-FechaD = pl-sem.fecini
            x-FechaH = pl-sem.fecfin
            x-NroFchD = YEAR(x-FechaD) * 100 + MONTH(x-FechaD)
            x-NroFchH = YEAR(x-FechaH) * 100 + MONTH(x-FechaH).
        FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia
                AND LOOKUP(TRIM(gn-divi.coddiv), '00000,00001,00002,00003,00005,00009,00011,00012,00013,00014') > 0
                NO-LOCK:
            FOR EACH EvtArti WHERE evtarti.codcia = s-codcia
                    AND evtarti.codmat = almmmatg.codmat
                    AND evtarti.coddiv = gn-divi.coddiv
                    AND evtarti.nrofch >= x-NroFchD
                    AND evtarti.nrofch <= x-NroFchH NO-LOCK:
                RUN bin/_dateif (evtarti.codmes, evtarti.codano, OUTPUT x-FechaD, OUTPUT x-FechaH).
                DO i = 1 TO DAY(x-FechaH):
                    x-Fecha = DATE(evtarti.codmes, i, evtarti.codano).
                    IF x-Fecha >= pl-sem.fecini AND x-Fecha <= pl-sem.fecfin
                    THEN ASSIGN
                            DETALLE.Cantidad[pl-sem.nrosem] = DETALLE.Cantidad[pl-sem.nrosem] + EvtArti.Canxdia[i]
                            DETALLE.Venta[pl-sem.nrosem] = DETALLE.Venta[pl-sem.nrosem] + EvtArti.Vtaxdiamn[i].
                END.
            END.
        END.
    END.
END.

output to c:\tmp\cantidad002.txt.
for each detalle:
display detalle except venta
with stream-io no-labels no-box width 350.
end.
output close.
        
output to c:\tmp\venta002.txt.
for each detalle:
display detalle except cantidad
with stream-io no-labels no-box width 350.
end.
output close.
