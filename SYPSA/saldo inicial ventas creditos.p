/* saldo inicial por cuentas por cobrar */
DEF VAR s-codcia AS INT INIT 001.
DEF VAR cl-codcia AS INT INIT 000.
DEF VAR x-codcta AS CHAR.
DEF VAR x-tpomov AS CHAR.
DEF VAR x-coddoc AS CHAR.

OUTPUT TO c:\tmp\saldoventasconti-xcredito.txt.
FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
    FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddiv = gn-divi.coddiv
        AND LOOKUP(ccbcdocu.coddoc, 'FAC,BOL,LET,N/C,N/D,A/C,A/R,BD,TCK,CHQ,CHC,CHD,CHV') > 0
        AND flgest = 'P',
        FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = ccbcdocu.codcli,
        FIRST Facdocum OF Ccbcdocu NO-LOCK:
        FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = Ccbcdocu.Codcia 
            AND Cb-cfgrv.CodDiv = Ccbcdocu.Coddiv 
            AND Cb-cfgrv.Coddoc = Ccbcdocu.Coddoc 
            AND Cb-cfgrv.Fmapgo = Ccbcdocu.Fmapgo 
            AND Cb-cfgrv.Codmon = Ccbcdocu.Codmon 
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" 
            THEN x-codcta = (IF ccbcdocu.codmon = 1 THEN FacDocum.CodCta[1]
            ELSE FacDocum.CodCta[2]).
        ELSE x-codcta = Cb-cfgrv.codcta.
        x-tpomov = 'A'.
        IF LOOKUP(ccbcdocu.coddoc, 'N/C,BD,A/C,A/R') > 0 THEN x-tpomov = 'C'.
        CASE ccbcdocu.coddoc:
            WHEN 'FAC' THEN x-coddoc = "F".
            WHEN 'BOL' THEN x-coddoc = "B".
            WHEN 'LET' THEN x-coddoc = "L".
            WHEN 'N/C' THEN x-coddoc = "N".
            WHEN 'N/D' THEN x-coddoc = "N".
            OTHERWISE x-coddoc = ccbcdocu.coddoc.
        END CASE.
        IF LOOKUP(ccbcdocu.coddoc, 'FAC,BOL,LET,N/C,N/D') > 0 THEN DO:
            x-CodDoc = x-CodDoc + STRING(ccbcdocu.codmon, '9').
            IF Ccbcdocu.coddoc = "N/C" THEN DO:
                IF Ccbcdocu.codmon = 1 THEN x-CodDoc = "N3".
                ELSE x-CodDoc = "N4".
            END.
        END.
        /* Genererar texto */
        FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK.
        PUT UNFORMATTED
/*             (IF gn-clie.codant <> '' THEN gn-clie.codant ELSE SUBSTRING(gn-clie.codcli,1,10)) '|' */
            gn-clie.codant '|'
            ccbcdocu.fmapgo '|'
            x-coddoc '|'
            ccbcdocu.nrodoc '|'
            ccbcdocu.fchdoc '|'
            (IF ccbcdocu.codmon = 1 THEN '00' ELSE '01') '|'
            '|'
            '2' '|'
            ccbcdocu.sdoact '|'
            'Cuenta Puente' '|'
            x-tpomov '|'
            FILL('|', 9)
            ccbcdocu.sdoact '|'
            x-codcta '|'
            (IF x-tpomov = 'C' THEN 'A' ELSE 'C') '|'
            ccbcdocu.fchvto '|'
            gn-tcmb.venta '|'
            gn-clie.codcli
            SKIP.
    END.
END.
OUTPUT CLOSE.

