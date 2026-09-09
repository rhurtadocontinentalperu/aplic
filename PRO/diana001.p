def temp-table t-cliente like gn-clie.

for each ccbcdocu where codcia = 1 and coddoc = 'fac'
        and coddiv = '00000' 
        and fchdoc >= date(01,01,2004) 
        and flgest <> 'A' no-lock,
        first gn-clie where gn-clie.codcia = 0
            and gn-clie.codcli = ccbcdocu.codcli no-lock:
    find t-cliente of gn-clie no-lock no-error.
    if available t-cliente then next.
    create t-cliente.
    buffer-copy gn-clie to t-cliente.
end.

output to c:\tmp\diana.txt.
for each t-cliente where t-cliente.codcli <> '':
    display t-cliente.codcli t-cliente.nomcli t-cliente.canal t-cliente.codven
        with stream-io no-box width 100.
end.
output close.



