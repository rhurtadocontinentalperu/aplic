def var s-codfam as char init '008'.
def var x-ok     as logi.
def var x-stkact as dec init 0 no-undo.

for each almmmatg where codcia = 1 and codfam = s-codfam and tpoart <> 'D' and subfam = '100':
    x-stkact = 0.
    for each almacen where almacen.codcia = 1 
        and lookup(almacen.coddiv, '00000,00001,00002,00003,00004,00009,00012,00013') > 0
        no-lock:
        for each almmmate of almmmatg where almmmate.codalm = almacen.codalm
            no-lock:
            x-stkact = x-stkact + stkact.
        end.
    end.        
    if x-stkact = 0
    then do:
        x-ok = yes.
        for each lg-cocmp where lg-cocmp.codcia = 1 
                and lg-cocmp.tpodoc = 'N'
                and lg-cocmp.fchdoc >= date(01,01,2004)
                no-lock,
                each lg-docmp of lg-cocmp no-lock:
            if lg-docmp.codmat = almmmatg.codmat
            then do:
                x-ok = no.
                leave.
            end.              
        end.            
        if x-ok = yes
        then do:
            /*display almmmatg.codmat almmmatg.desmat x-stkact with use-text.*/
            almmmatg.tpoart = 'D'.
        end.
    end.
end.

/*
for each almmmatg where codcia = 1 and codfam = s-codfam and tpoart = 'D':
    /*display codmat desmat almacenes format 'x(20)' with use-text width 100.*/
    almacenes = ''.
end.
*/
