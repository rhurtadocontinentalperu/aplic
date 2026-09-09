def var x-imp2003 as dec.
def var x-imp2004 as dec.
def var x-imptot as dec.

output to c:\tmp\proveedores.prn.
for each gn-prov no-lock where codcia = 0:
    assign
        x-imp2003 = 0
        x-imp2004 = 0.
    for each lg-cocmp no-lock where codcia = 1 and tpodoc = 'n'
            and codpro = gn-prov.codpro
            and fchdoc >= date(05,01,2003)
            and fchdoc <= date(04,30,2004)
            and lookup(trim(flgsit), 'P,T') > 0:
        x-imptot = imptot.
        if codmon = 1 then x-imptot = imptot / tpocmb.
        if fchdoc <= date(12,31,2003)
        then x-imp2003 = x-imp2003 + x-imptot.
        else x-imp2004 = x-imp2004 + x-imptot.
    end.
    if x-imp2003 <> 0 or x-imp2004 <> 0 then
    display gn-prov.codpro gn-prov.nompro x-imp2003 x-imp2004
        with stream-io no-labels width 200.
end.
output close.
