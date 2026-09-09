/* DESCRIPCION: cambia el codigo del movimiento original por el '66'
                ajuste por inconsistencia de kardex logistico y contable
*/
                
def temp-table t-cmov like almcmov.
def var x-linea as char format 'x(40)'.

/* cargamos el temporal */
input from c:\tmp\ruben.prn.
repeat:
    import unformatted x-linea.
    create t-cmov.
    assign
        t-cmov.codcia = 1
        t-cmov.nroser = integer(substring(x-linea,23,3))
        t-cmov.nrodoc = integer(substring(x-linea,29,6))
        t-cmov.codalm = substring(x-linea,11,3)
        t-cmov.tipmov = substring(x-linea,16,1)
        t-cmov.codmov = integer(substring(x-linea,18,2)).
end.
input close.

/* cargamos movimientos en un temporal */
disable triggers for load of almcmov.
disable triggers for load of almdmov.

def temp-table t-almcmov like almcmov.
def temp-table t-almdmov like almdmov.

for each almacen no-lock where codcia = 1
    and lookup(trim(coddiv) , '00001,00002,00003,00004,00013,00014') = 0:
    for each t-cmov where t-cmov.codcia = 1
        and t-cmov.codalm = almacen.codalm:
        find almcmov where almcmov.codcia = t-cmov.codcia
            and almcmov.codalm = t-cmov.codalm
            and almcmov.tipmov = t-cmov.tipmov
            and almcmov.codmov = t-cmov.codmov
            and almcmov.nrodoc = t-cmov.nrodoc
            exclusive-lock no-error.
        if error-status:error then next.
        create t-almcmov.
        buffer-copy almcmov to t-almcmov.
        for each almdmov of almcmov:
            create t-almdmov.
            buffer-copy almdmov to t-almdmov.
        end.
    end.    
end.
/* punto de chequeo
for each t-almcmov:
    display t-almcmov.codalm t-almcmov.tipmov t-almcmov.codmov t-almcmov.nrodoc.
    for each t-almdmov of t-almcmov:
        display t-almdmov.codmat t-almdmov.candes.
    end.
end.    
*/

/* actualizamos almacenes */
/* guardamos un log con los materiales que hemos actualizado */
output to c:\tmp\mate-ate.txt.
for each t-almcmov:
    find almcmov of t-almcmov exclusive-lock.
    for each almdmov of almcmov:
        display almdmov.codmat with stream-io no-box no-labels.
        delete almdmov.
    end.
    delete almcmov.
    create almcmov.
    buffer-copy t-almcmov to almcmov
        assign almcmov.codmov = 66.
    for each t-almdmov of t-almcmov:
        display t-almdmov.codmat with stream-io no-box no-labels.
        create almdmov.
        buffer-copy t-almdmov to almdmov
            assign almdmov.codmov = 66.
    end.
end.
output close.
