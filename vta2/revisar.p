DEF VAR pHojRut   AS CHAR.
DEF VAR pFlgEst-1 AS CHAR.
DEF VAR pFlgEst-2 AS CHAR.
DEF VAR pFchDoc   AS DATE.

FOR EACH faccpedi NO-LOCK WHERE faccpedi.codcia = 001
    AND faccpedi.coddoc = 'o/d'
    AND LOOKUP(faccpedi.flgest, 'P,C') > 0
    AND faccpedi.divdes = '00000'
    AND faccpedi.fchped >= TODAY - 15
    AND flgsit = 'C',
    EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = 001
    AND ccbcdocu.coddoc = 'G/R'
    AND ccbcdocu.coddiv = '00000'
    AND ccbcdocu.codcli = faccpedi.codcli
    AND ccbcdocu.fchdoc >= faccpedi.fchped
    AND ccbcdocu.flgest <> 'A'
    /*AND ccbcdocu.flgubia <> 'C'*/
    AND ccbcdocu.libre_c01 = faccpedi.coddoc
    AND ccbcdocu.libre_c02 = faccpedi.nroped:
/*     DISPLAY 'buscando' ccbcdocu.coddoc ccbcdocu.nrodoc SKIP.    */
/*     PAUSE 0.                                                    */
/*     /* RHC 21/10/2013 Verificamos H/R */                        */
    pFlgEst-1 = ''.
    RUN dist/p-rut002 ( "G/R",
                        Ccbcdocu.coddoc,
                        Ccbcdocu.nrodoc,
                        "",
                        "",
                        "",
                        0,
                        0,
                        OUTPUT pHojRut,
                        OUTPUT pFlgEst-1,     /* de Di-RutaC */
                        OUTPUT pFlgEst-2,     /* de Di-RutaG */
                        OUTPUT pFchDoc).
    IF pFlgEst-1 <> '' THEN NEXT.
    DISPLAY pFlgEst-1  faccpedi.fchped faccpedi.coddiv faccpedi.coddoc faccpedi.nroped
        ccbcdocu.coddoc ccbcdocu.nrodoc SKIP
        WITH STREAM-IO NO-BOX WIDTH 320.
    PAUSE 0.
END.
