IF NOT connected('cissac')
    THEN CONNECT -db cissac -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
        'NO podemos capturar el stock'
        VIEW-AS ALERT-BOX WARNING.
END.

/*DEFINE INPUT PARAMETER cCodCli AS CHAR.*/
DEFINE INPUT PARAMETER  f-Desde      AS DATE.
DEFINE INPUT PARAMETER  f-Hasta      AS DATE.
DEFINE INPUT PARAMETER  cDivi        AS CHAR.
/*DEFINE OUTPUT PARAMETER x-montoletra AS DEC.*/

DEF SHARED VAR s-codcia AS INT.

DEFINE BUFFER b-faccpedi FOR cissac.faccpedi.

DEFINE SHARED TEMP-TABLE tabla NO-UNDO
    FIELDS t-codcli LIKE cissac.gn-clie.codcli
    FIELDS t-coddoc LIKE cissac.faccpedi.coddoc
    FIELDS t-nrocot LIKE cissac.faccpedi.nroped
    FIELDS t-totcot AS DECIMAL FORMAT "->>>>>>>>>9.99"
    FIELDS t-codfac LIKE cissac.ccbcdocu.coddoc
    FIELDS t-nrofac LIKE cissac.ccbcdocu.nrodoc
    FIELDS t-totfac AS DECIMAL FORMAT "->>>>>>>>>9.99"
    FIELDS t-totlet AS DECIMAL FORMAT "->>>>>>>>>9.99"
    FIELDS t-letcis AS DECIMAL FORMAT "->>>>>>>>>9.99"
    FIELDS t-libred AS DECIMAL FORMAT "->>>>>>>>>9.99"
    FIELDS t-librec AS CHAR
    FIELDS t-libref AS DATE.


FOR EACH cissac.ccbcdocu WHERE cissac.ccbcdocu.codcia = s-codcia
    AND LOOKUP(cissac.ccbcdocu.coddiv,"00000,00015") > 0
    AND cissac.ccbcdocu.coddoc = "LET"
    /*AND cissac.ccbcdocu.codcli = cCodCli*/ 
    AND cissac.ccbcdocu.fchdoc >= f-Desde
    AND cissac.ccbcdocu.fchdoc <= f-Hasta
    AND cissac.ccbcdocu.flgest = 'P' NO-LOCK:

    FIND FIRST tabla WHERE t-codcli = cissac.ccbcdocu.codcli NO-LOCK NO-ERROR.
    IF NOT AVAIL tabla THEN DO:
        CREATE tabla.
        ASSIGN t-codcli = cissac.ccbcdocu.codcli.
    END.
    IF cissac.ccbcdocu.codmon = 1 THEN
        t-letcis = t-letcis + cissac.ccbcdocu.imptot.
    ELSE DO:
        FIND FIRST cissac.gn-tcmb WHERE cissac.gn-tcmb.fecha = cissac.ccbcdocu.fchdoc NO-LOCK NO-ERROR.
        IF AVAIL cissac.gn-tcmb THEN
            t-letcis = t-letcis + (cissac.ccbcdocu.imptot * cissac.gn-tcmb.venta).
        ELSE t-letcis = t-letcis + (cissac.ccbcdocu.imptot * cissac.ccbcdocu.tpocmb).
    END.
    /*
    x-montoletra = x-montoletra + cissac.ccbcdocu.imptot.    
    */
END.


FOR EACH tabla NO-LOCK:
    /*Carga Cotizacion y Facturado*/
    FOR EACH cissac.gn-divi WHERE cissac.gn-divi.codcia = s-codcia
        AND LOOKUP(cissac.gn-divi.CodDiv,cDivi) > 0 NO-LOCK:
        FOR EACH cissac.faccpedi WHERE cissac.faccpedi.codcia = s-codcia
            AND cissac.faccpedi.coddiv = cissac.gn-divi.coddiv
            AND cissac.faccpedi.coddoc = "COT"
            AND cissac.faccpedi.codcli = t-codcli
            AND cissac.faccpedi.fchped >= f-Desde        
            AND cissac.faccpedi.fchped <= f-hasta        
            AND LOOKUP(TRIM(cissac.faccpedi.FmaPgo),"102,103,104") > 0
            AND cissac.faccpedi.flgest <> 'A'
            AND lookup(trim(cissac.faccpedi.codven),'015,173') > 0 NO-LOCK:

            IF cissac.faccpedi.codmon = 1 THEN
                ASSIGN t-totcot = t-totcot + cissac.faccpedi.imptot.
            ELSE DO:
                /*Total Cotizacion*/
                FIND FIRST cissac.gn-tcmb WHERE cissac.gn-tcmb.fecha = cissac.faccpedi.fchped NO-LOCK NO-ERROR.
                IF AVAIL cissac.gn-tcmb THEN
                    t-totcot = t-totcot + (cissac.faccpedi.imptot * cissac.gn-tcmb.venta).
                ELSE t-totcot = t-totcot + (cissac.faccpedi.imptot * cissac.faccpedi.tpocmb).
            END.
            
            /*Busca Pedidos*/
            FOR EACH b-faccpedi WHERE b-faccpedi.codcia = cissac.faccpedi.codcia
                AND b-faccpedi.coddiv = cissac.faccpedi.coddiv
                AND b-faccpedi.coddoc = "PED"
                AND b-faccpedi.flgest <> 'A'
                AND b-faccpedi.nroref = cissac.faccpedi.nroped NO-LOCK:
                /*Busca Facturas*/
                FOR EACH cissac.ccbcdocu WHERE cissac.ccbcdocu.codcia = cissac.faccpedi.codcia
                    AND cissac.ccbcdocu.coddiv = cissac.faccpedi.coddiv
                    AND LOOKUP(cissac.ccbcdocu.coddoc,'FAC,BOL,TCK,N/C') > 0
                    AND cissac.ccbcdocu.fchdoc >= f-Desde
                    AND cissac.ccbcdocu.fchdoc <= f-hasta
                    AND cissac.ccbcdocu.flgest <> 'A'
                    AND cissac.ccbcdocu.Nroped = b-faccpedi.nroped NO-LOCK:
                    IF cissac.ccbcdocu.codmon = 1 THEN
                        ASSIGN t-totfac = t-totfac + cissac.ccbcdocu.imptot.
                    ELSE DO:
                        FIND FIRST cissac.gn-tcmb WHERE cissac.gn-tcmb.fecha = cissac.ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                        IF AVAIL cissac.gn-tcmb THEN
                            t-totcot = t-totcot + (cissac.ccbcdocu.imptot * cissac.gn-tcmb.venta).
                        ELSE t-totcot = t-totcot + (cissac.ccbcdocu.imptot * cissac.ccbcdocu.tpocmb).
                    END.
                END.
            END.
        END.    
    END.
END.
