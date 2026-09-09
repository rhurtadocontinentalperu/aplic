define var x-coddoc as char.
define var x-glo as char.
define var x-pri as char.
define var x-fin as char.

for each cb-dmov where cb-dmov.codcia = 1 and periodo = 2007 and
    nromes = 3 and
    codope = "062" and
    lookup(codcta,"121101,121102") > 0 and
    coddiv <> "00000" and
    glodoc = "VENTAS CONTADO":
    if codcta = "121101" then x-coddoc = "FAC" .
    if codcta = "121102" then x-coddoc = "BOL" .
    /* RHC 01.06.04 */
    if cb-dmov.coddoc = '12'
    then x-coddoc = 'TCK'.
    
    x-pri = "".
    x-fin = "".
    
    find first ccbcdocu where ccbcdocu.codcia = 1 and
               ccbcdocu.coddiv = cb-dmov.coddiv and
               ccbcdocu.coddoc = x-coddoc and
               ccbcdocu.fchdoc = cb-dmov.fchdoc and
               ccbcdocu.tipo = "MOSTRADOR"           
               no-lock no-error.
    if available ccbcdocu then x-pri = ccbcdocu.nrodoc.
               
    find last  ccbcdocu where ccbcdocu.codcia = 1 and
               ccbcdocu.coddiv = cb-dmov.coddiv and
               ccbcdocu.coddoc = x-coddoc and
               ccbcdocu.fchdoc = cb-dmov.fchdoc and
               ccbcdocu.tipo = "MOSTRADOR"           
               no-lock no-error.
               
    if available ccbcdocu then x-fin = ccbcdocu.nrodoc .
    
    cb-dmov.glodoc = x-coddoc + " " + x-pri + "/" + x-fin.
    cb-dmov.nrodoc = x-pri.
    
    display /*cb-dmov.GloDoc */
            cb-dmov.fchdoc 
            cb-dmov.codcta 
            cb-dmov.nrodoc
            x-pri format "x(20)" 
            x-fin format "x(25)"  with stream-io.
    
    pause 0.
end.
 
