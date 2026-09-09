disable triggers for load of almdmov.

def var x-linea as char format 'x(200)'.
def temp-table t-dmov like almdmov.

input from c:\tmp\borrar.prn.
repeat:
    import unformatted x-linea.
    create t-dmov.
    assign
        t-dmov.codcia = 001
        t-dmov.codalm = substring(x-linea,24,3)
        t-dmov.tipmov = substring(x-linea,40,1)
        t-dmov.codmov = integer(substring(x-linea,42,3))
        t-dmov.nroser = integer(substring(x-linea,47,3))
        t-dmov.nrodoc = integer(substring(x-linea,54,6))
        t-dmov.codmat = substring(x-linea,1,6)
        t-dmov.candes = decimal(substring(x-linea,60,20)).
end.
input close.

for each t-dmov by codmat:
    display t-dmov.codmat t-dmov.candes.
    for each almdmov of t-dmov:
        delete almdmov.
    end.
    for each almdmov where almdmov.codcia = 001
            and almdmov.codalm = t-dmov.codalm
            and almdmov.tipmov = 's'
            and almdmov.codmov = 66
            and almdmov.codmat = t-dmov.codmat
            and almdmov.nroser = t-dmov.nroser
            and almdmov.nrodoc = t-dmov.nrodoc:
        delete almdmov.
    end.
end.
