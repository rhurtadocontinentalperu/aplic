def var x as int no-undo.

for each almmmate where codcia = 001 and codalm = '04a' and stkact = 0,
    first almmmatg of almmmate no-lock where codfam = '002'
        and almmmatg.fching < 11/01/2005:
    find first almdmov where almdmov.codcia = 001
        and almdmov.codalm = almmmate.codalm
        and almdmov.codmat = almmmatg.codmat
        no-lock no-error.
    if not available almdmov then do:
        display almmmate.codmat almmmate.stkact.
        pause 0.
        x = x + 1.
        delete almmmate.
    end.
end.
message x.
