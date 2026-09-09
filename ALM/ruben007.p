/* RHC 08.07.2006 cambiamos la fecha de los documentos */
/* Se debe replicar a las tiendas */

def var x-linea as char format 'x(100)'.
def var x-fchdoc as date.
def temp-table t-cmov like almcmov.
def temp-table t-almcmov like almcmov.
def temp-table t-almdmov like almdmov.
def temp-table t-matg like almmmatg.

x-fchdoc = 06/30/2006.      /* OJO CON LA FECHA */

input from c:\tmp\inconsistencia.prn.
repeat:
    import unformatted x-linea.
    create t-cmov.
    assign
        t-cmov.codcia = 001
        t-cmov.tipmov = substring(x-linea,1,1)
        t-cmov.codmov = integer(substring(x-linea,3,2))
        t-cmov.codalm = substring(x-linea,8,3)
        t-cmov.nroser = integer(substring(x-linea,32,3))
        t-cmov.nrodoc = integer(substring(x-linea,36,6)).
end.    
input close.

for each t-cmov where t-cmov.codcia = 001 and t-cmov.codalm <> '':
    find almcmov where almcmov.codcia = t-cmov.codcia
        and almcmov.codalm = t-cmov.codalm
        and almcmov.tipmov = t-cmov.tipmov
        and almcmov.codmov = t-cmov.codmov
        and almcmov.nroser = t-cmov.nroser
        and almcmov.nrodoc = t-cmov.nrodoc
        no-lock.
    create t-almcmov.
    buffer-copy almcmov to t-almcmov
        assign
            t-almcmov.fchdoc = x-fchdoc.
    for each almdmov of almcmov no-lock:
        create t-almdmov.
        buffer-copy almdmov to t-almdmov
            assign
                t-almdmov.fchdoc = x-fchdoc.
    end.        
end.

for each t-almcmov:
    display 
        t-almcmov.tipmov
        t-almcmov.codmov
        t-almcmov.codalm
        t-almcmov.almdes
        t-almcmov.fchdoc
        t-almcmov.nroser
        t-almcmov.nrodoc
        with stream-io no-box no-labels width 200.
end.

message 'procedemos?' view-as alert-box question buttons yes-no update rpta as log.
if rpta = no then return.

for each t-almcmov:
    find almcmov of t-almcmov exclusive-lock no-error.
    if available almcmov then do:
        almcmov.fchdoc = t-almcmov.fchdoc.
        for each almdmov of almcmov:
            almdmov.fchdoc = almcmov.fchdoc.
            find t-matg of almdmov no-lock no-error.
            if not available t-matg then do:
                create t-matg.
                assign
                    t-matg.codcia = almdmov.codcia
                    t-matg.codmat = almdmov.codmat.
            end.
        end.
    end.
end.


output to c:\tmp\materiales.txt.
for each t-matg:
    display t-matg.codmat with stream-io no-box no-labels.
end.
output close.
