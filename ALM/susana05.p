def var x-cantidad as dec no-undo.
def var x-familia  as char format 'x(30)' column-label 'Descripcion'.
def var x-subfamilia as char format 'x(40)' column-label 'Descripcion'.

output to c:\tmp\familias.txt.
for each almmmatg no-lock where codcia = 1 and tpoart <> 'D'
        break by codfam by subfam by desmar:
    if first-of(codfam) or first-of(subfam) or first-of(desmar)
    then x-cantidad = 0.
    x-cantidad = x-cantidad + 1.
    if last-of(codfam) or last-of(subfam) or last-of(desmar)
    then do:
        assign
            x-familia = ''
            x-subfamilia = ''.
        find almtfami where Almtfami.CodCia = almmmatg.CODCIA 
            AND Almtfami.codfam = almmmatg.codfam
            no-lock no-error.
        if available almtfami then x-familia = almtfami.desfam.
        find almsfami where AlmSFami.CodCia = almmmatg.CODCIA 
            AND AlmSFami.codfam = Almmmatg.codfam
            AND AlmSFami.subfam = almmmatg.subfam
            no-lock no-error.
        if available almsfami then x-subfamilia = almsfami.dessub.
        display almmmatg.codfam x-familia almmmatg.subfam x-subfamilia desmar x-cantidad with stream-io width 200.
    end.
end.
output close.
