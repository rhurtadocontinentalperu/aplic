

FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = 1,
    EACH faccpedi NO-LOCK WHERE faccpedi.codcia = 1 
        and faccpedi.coddiv = gn-divi.coddiv
        and faccpedi.coddoc = "COT" 
        AND faccpedi.flgest = "C" 
        and faccpedi.fchped >= 01/01/2024 
        and faccpedi.coddiv <> faccpedi.libre_c01:
    DISPLAY faccpedi.coddiv faccpedi.coddoc faccpedi.nroped WITH STREAM-IO.
END.
