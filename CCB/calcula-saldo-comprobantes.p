DEF TEMP-TABLE docu LIKE ccbcdocu.
/* buscamos las cancelaciones de comprobantes */
FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = 001
    AND LOOKUP(ccbcdocu.coddoc, 'FAC,BOL,LET,N/D,CHQ') > 0
    AND ccbcdocu.flgest <> 'A':
    DISPLAY ccbcdocu.coddiv ccbcdocu.coddoc ccbcdocu.nrodoc ccbcdocu.fchdoc.
    PAUSE 0.
    FOR EACH ccbdcaja NO-LOCK WHERE ccbdcaja.codcia = ccbcdocu.codcia
        AND ccbdcaja.codref = ccbcdocu.coddoc
        AND ccbdcaja.nroref = ccbcdocu.nrodoc:
        FIND FIRST docu OF ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE docu THEN DO:
            CREATE docu.
            BUFFER-COPY ccbcdocu TO docu
                ASSIGN 
                    docu.sdoact = ccbcdocu.imptot
                    docu.flgest = 'P'
                    docu.fchcan = ?.
        END.
        IF ccbcdocu.codmon = ccbdcaja.codmon 
        THEN docu.sdoact = docu.sdoact - ccbdcaja.imptot.
        ELSE IF ccbcdocu.codmon = 1 
            THEN docu.sdoact = docu.sdoact - ccbdcaja.imptot * ccbdcaja.tpocmb.
            ELSE docu.sdoact = docu.sdoact - ccbdcaja.imptot / ccbdcaja.tpocmb.
        IF docu.sdoact <= 0 
        THEN ASSIGN
                docu.flgest = 'C'
                docu.fchcan = ccbdcaja.fchdoc.
    END.
END.

/* buscamos las aplicaciones de las notas de credito */
FOR EACH ccbcdocu NO-LOCK WHERE codcia = 001 AND coddoc = 'N/C':
    DISPLAY ccbcdocu.coddiv ccbcdocu.coddoc ccbcdocu.nrodoc ccbcdocu.fchdoc.
    PAUSE 0.
    FOR EACH ccbdmov NO-LOCK WHERE ccbdmov.codcia = ccbcdocu.codcia
        AND ccbdmov.coddoc = ccbcdocu.coddoc
        AND ccbdmov.nrodoc = ccbcdocu.nrodoc:
        FIND FIRST docu OF ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE docu THEN DO:
            CREATE docu.
            BUFFER-COPY ccbcdocu TO docu
                ASSIGN 
                    docu.sdoact = ccbcdocu.imptot
                    docu.flgest = 'P'
                    docu.fchcan = ?.
        END.
        IF ccbcdocu.codmon = ccbdmov.codmon 
        THEN docu.sdoact = docu.sdoact - ccbdmov.imptot.
        ELSE IF ccbcdocu.codmon = 1 
            THEN docu.sdoact = docu.sdoact - ccbdmov.imptot * ccbdcaja.tpocmb.
            ELSE docu.sdoact = docu.sdoact - ccbdmov.imptot / ccbdcaja.tpocmb.
        IF docu.sdoact <= 0 
        THEN ASSIGN
                docu.flgest = 'C'
                docu.fchcan = ccbdmov.fchdoc.
    END.
END.

OUTPUT TO c:\tmp\docu.d.
FOR EACH docu NO-LOCK:
    EXPORT docu.
END.
OUTPUT CLOSE.
