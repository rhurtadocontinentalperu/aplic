def temp-table t-docu
    field codcia as int
    field codig  like gn-convt.codig column-label 'Codigo'
    field nombr  like gn-ConVt.Nombr format 'x(30)' column-label 'Descripcion'
    field totmn  as dec format '>>>,>>>,>>9.99' column-label 'Importe S/.'
    field totme  as dec format '>>>,>>>,>>9.99' column-label 'Importe US$'
    INDEX Llave01 AS PRIMARY codcia codig.
    
for each ccbcdocu no-lock where codcia = 1
    and lookup(trim(coddoc), 'fac,bol') > 0
    and fchdoc >= date(06,01,2003)
    and fchdoc <= date(09,30,2003)
    and flgest <> 'A':
    display ccbcdocu.coddoc ccbcdocu.nrodoc ccbcdocu.fchdoc.
    pause 0.
    find t-docu where t-docu.codcia = ccbcdocu.codcia
        and t-docu.codig = ccbcdocu.fmapgo
        exclusive-lock no-error.
    if not available t-docu
    then create t-docu.
    assign
        t-docu.codcia = ccbcdocu.codcia
        t-docu.codig  = ccbcdocu.fmapgo.
    if ccbcdocu.codmon = 1
    then t-docu.totmn = t-docu.totmn + ccbcdocu.imptot.
    else t-docu.totme = t-docu.totme + ccbcdocu.imptot.
    find gn-convt where gn-convt.codig = t-docu.codig NO-LOCK NO-ERROR.
    if available gn-convt then t-docu.nombr = gn-convt.nombr.
end.

output to c:\tmp\yudini.txt.
for each t-docu:
    display t-docu.codig t-docu.nombr t-docu.totmn t-docu.totme 
        with use-text stream-io no-box width 200.
end.    
output close.
