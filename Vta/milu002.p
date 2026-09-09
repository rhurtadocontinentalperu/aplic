def buffer b-fac for ccbcdocu.
def buffer b-det for ccbddocu.

output to c:\tmp\nc00002.txt.
for each ccbcdocu no-lock where codcia = 001 and coddoc = 'n/c'
    and lookup(trim(coddiv), '00001,00002') > 0
    and flgest <> 'a' 
    and fchdoc >= date(05,01,2004) 
    and fchdoc <= date(05,31,2004),
    first ccbddocu of ccbcdocu where ccbddocu.codmat = '00002' no-lock,
    first b-fac no-lock where b-fac.codcia = 001
        and b-fac.coddoc = ccbcdocu.codref
        and b-fac.nrodoc = ccbcdocu.nroref,
        each b-det of b-fac no-lock,
    first almmmatg of b-det:
    display ccbcdocu.fchdoc ccbcdocu.coddoc ccbcdocu.nrodoc
        ccbcdocu.codmon ccbcdocu.imptot b-fac.coddoc b-fac.nrodoc
        b-fac.codmon b-fac.imptot b-det.codmat almmmatg.desmat with stream-io no-box width 200.
end.
output close.

output to c:\tmp\nc00003.txt.
for each ccbcdocu no-lock where codcia = 001 and coddoc = 'n/c'
    and lookup(trim(coddiv), '00001,00002') > 0
    and flgest <> 'a' 
    and fchdoc >= date(05,01,2004) 
    and fchdoc <= date(05,31,2004),
    first ccbddocu of ccbcdocu where ccbddocu.codmat = '00003' no-lock,
    first b-fac no-lock where b-fac.codcia = 001
        and b-fac.coddoc = ccbcdocu.codref
        and b-fac.nrodoc = ccbcdocu.nroref,
        each b-det of b-fac no-lock,
    first almmmatg of b-det:
    display ccbcdocu.fchdoc ccbcdocu.coddoc ccbcdocu.nrodoc
        ccbcdocu.codmon ccbcdocu.imptot b-fac.coddoc b-fac.nrodoc
        b-fac.codmon b-fac.imptot b-det.codmat almmmatg.desmat with stream-io no-box width 200.
end.
output close.
    
