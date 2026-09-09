OUTPUT TO c:\tmp\cancelaciones.txt.
PUT UNFORMATTED
    'DOC|NUMERO|CANCELACION|DIV EMIS|COMPROBANTE|NUM COMPROBANTE|EMISION|CLIENTE|NOMBRE|MON|IMPORTE PAGO'
    SKIP.
FOR EACH ccbdcaja NO-LOCK WHERE ccbdcaja.codcia = 001
    AND ccbdcaja.fchdoc >= 07/01/2012
    AND ccbdcaja.fchdoc <= TODAY,
    FIRST ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = 001
    AND ccbcdocu.coddoc = ccbdcaja.codref
    AND ccbcdocu.nrodoc = ccbdcaja.nroref
    AND ccbcdocu.tipo <> 'MOSTRADOR':
    PUT UNFORMATTED
        ccbdcaja.coddoc '|'
        ccbdcaja.nrodoc '|'
        ccbdcaja.fchdoc '|'
        ccbcdocu.coddiv '|'
        ccbdcaja.codref '|'
        ccbdcaja.nroref '|'
        ccbcdocu.fchdoc '|'
        ccbcdocu.codcli '|'
        ccbcdocu.nomcli '|'
        ccbdcaja.codmon '|'
        ccbdcaja.imptot
        SKIP.
END.
OUTPUT CLOSE.

