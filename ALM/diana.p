def temp-table t-prov like gn-prov.

for each almmmatg where codcia = 1 and catconta[1] = 'E1' no-lock,
    first gn-prov where gn-prov.codcia = 0 and gn-prov.codpro = almmmatg.codpr1 no-lock:
    find first t-prov where t-prov.codcia = gn-prov.codcia
        and t-prov.codpro = gn-prov.codpro no-lock no-error.
    if available t-prov then next.
    create t-prov.
    buffer-copy gn-prov to t-prov.
end.
    
output to c:\tmp\envases.txt.
for each t-prov:
    display t-prov.codpro t-prov.nompro with stream-io.
end.    
output close.
