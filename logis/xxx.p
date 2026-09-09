RLOOP:
FOR EACH almcdocu NO-LOCK WHERE almcdocu.codcia = 1
    AND almcdocu.coddoc = 'o/d'
    AND almcdocu.flgest = 'C'
    AND almcdocu.codllave = '00000'
    AND almcdocu.fchdoc >= (TODAY - 30),
    FIRST faccpedi NO-LOCK WHERE faccpedi.codcia = 1 
    AND faccpedi.coddoc = almcdocu.coddoc
    AND faccpedi.nroped = almcdocu.nrodoc:
    IF NOT(faccpedi.divdes = '00000' AND faccpedi.flgest = 'C')
        THEN NEXT.
    FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = 1
        AND ccbcdocu.codped = faccpedi.codref
        AND ccbcdocu.nroped = faccpedi.nroref
        AND ccbcdocu.coddoc = 'G/R'
        AND ccbcdocu.libre_c01 = 'O/D'
        AND ccbcdocu.libre_c02 = faccpedi.nroped
        AND ccbcdocu.flgest <> 'A':
        FOR EACH di-rutad WHERE di-rutad.codcia = 1
            AND di-rutad.coddoc = 'H/R'
            AND di-rutad.codref = ccbcdocu.coddoc
            AND di-rutad.nroref = ccbcdocu.nrodoc,
            FIRST di-rutac OF di-rutad WHERE di-rutac.flgest <> 'A' NO-LOCK:
            NEXT RLOOP.
        END.
    END.
    DISPLAY almcdocu.coddoc almcdocu.nrodoc.
END.


