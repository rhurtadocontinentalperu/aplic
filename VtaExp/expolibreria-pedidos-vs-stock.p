DEF TEMP-TABLE t-matg LIKE almmmatg
    FIELD canped AS DEC
    FIELD stkact AS DEC.

FOR EACH faccpedi NO-LOCK WHERE codcia = 1 AND coddiv = '00015'
    AND coddoc = 'cot' AND flgest <> 'A'
    AND fchped >= 01/06/09,
    EACH facdpedi OF faccpedi NO-LOCK,
    FIRST almmmatg OF facdpedi NO-LOCK:
    FIND t-matg OF almmmatg EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE t-matg THEN DO:
        CREATE t-matg.
        BUFFER-COPY almmmatg TO t-matg.
    END.
    t-matg.canped = t-matg.canped + facdpedi.canped.
END.

OUTPUT TO m:\tmp\expolibraria.txt.
FOR EACH t-matg NO-LOCK, FIRST almmmate OF t-matg NO-LOCK WHERE almmmate.codalm = '15',
    FIRST gn-prov NO-LOCK WHERE gn-prov.codcia = 0
    AND gn-prov.codpro = t-matg.codpr1:
    DISPLAY
        t-matg.codmat
        t-matg.desmat
        t-matg.desmar
        t-matg.undbas
        t-matg.codpr1
        gn-prov.nompro
        t-matg.canped
        almmmate.stkact
        WITH STREAM-IO NO-BOX WIDTH 320.
END.
OUTPUT CLOSE.

