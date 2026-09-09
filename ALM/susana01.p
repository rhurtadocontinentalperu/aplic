def var x-stkact as dec no-undo.
def var x-fchdoc as date no-undo.
def var x-ok     as log no-undo.

x-fchdoc = date(01,01,2003).

output to c:\tmp\almmmatg.d.
for each almmmatg where codcia = 1 and tpoart <> 'D' no-lock:
    x-stkact = 0.
    x-ok = NO.
    for each almacen where almacen.codcia = almmmatg.codcia
            and lookup(almacen.coddiv, '00000') > 0 no-lock:
        for each almmmate of almmmatg where almmmate.codalm = almacen.codalm
                no-lock:
            x-stkact = x-stkact + almmmate.stkact.
        end.                
    end.            
    if x-stkact = 0
    then do:
        x-ok = YES.
        /* buscamos que no tengan movimientos a partir del 01/01/2003 */
        for each almacen where almacen.codcia = almmmatg.codcia
                and lookup(almacen.coddiv, '00000') > 0 no-lock:
            find first almdmov where almdmov.codcia = almmmatg.codcia
                and almdmov.codalm = almacen.codalm
                and almdmov.fchdoc > x-fchdoc
                and almdmov.codmat = almmmatg.codmat
                no-lock no-error.
            if available almdmov
            then do:
                x-ok = NO.
                leave.
            end.                        
        end.
        if x-ok = YES
        then do:
            export almmmatg.
            /*
            display almmmatg.codmat almmmatg.desmat x-stkact.
            */
        end.
    end.
end.
output close.

