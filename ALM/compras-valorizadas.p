def var x-candes as dec.
def var x-ctouni as dec format '>>>,>>9.999999'.
def var x-ctotot as dec format '>>>,>>>,>>9.99'.

output to c:\tmp\nov2005.txt.
for each almmmatg where almmmatg.codcia = 001 no-lock,
    each almdmov no-lock where almdmov.codcia = 001
        and almdmov.codmat = almmmatg.codmat
        and almdmov.fchdoc >= 11/01/2005
        and almdmov.fchdoc <= 11/30/2005
        and tipmov = 'i'
        and (codmov = 02 or codmov = 06 or codmov = 16)
        break by almmmatg.codcia by almmmatg.codmat:
    x-candes = (candes * factor).
    x-ctouni = preuni.
    x-ctotot = impcto.
    if almdmov.codmon = 2 
    then assign
            x-ctotot = round(x-ctotot * almdmov.tpocmb, 2)
            x-ctouni = round(x-ctotot / x-candes, 6).
    accumulate x-candes (sub-total by almmmatg.codmat).
    accumulate x-candes (total by almmmatg.codcia).
    accumulate x-ctotot (sub-total by almmmatg.codmat).
    accumulate x-ctotot (total by almmmatg.codcia).
    display almmmatg.codmat almmmatg.desmat almmmatg.undbas
        tipmov codmov fchdoc x-candes x-ctouni x-ctotot
        with stream-io no-box width 320.    
    if last-of(almmmatg.codmat)
    then do:
        underline x-candes x-ctotot.
        display 
            accum sub-total by almmmatg.codmat x-candes @ x-candes
            accum sub-total by almmmatg.codmat x-ctotot @ x-ctotot.
    end.
    if last-of(almmmatg.codcia)
    then do:
        underline x-candes x-ctotot.
        display 
            accum total by almmmatg.codcia x-candes @ x-candes
            accum total by almmmatg.codcia x-ctotot @ x-ctotot.
    end.
end.
output close.
