/* DESCRIPCION: deshacer lo hecho */
session:date-format = 'dmy'.

def temp-table t-cmov like almcmov
    field codmov-2 like almcmov.codmov.

def temp-table t-matg like almmmatg.

def var x-linea as char format 'x(40)'.

/* cargamos el temporal */
input from c:\tmp\ruben.prn.
repeat:
    import unformatted x-linea.
    create t-cmov.
    /* 
    assign
        t-cmov.codcia = 1
        t-cmov.nroser = integer(substring(x-linea,23,3))
        t-cmov.nrodoc = integer(substring(x-linea,29,6))
        t-cmov.codalm = substring(x-linea,11,3)
        t-cmov.tipmov = substring(x-linea,16,1)
        t-cmov.codmov = integer(substring(x-linea,18,2))
        t-cmov.fchdoc = date( integer(substring(x-linea,4,2)),
                            integer(substring(x-linea,1,2)),
                            integer(substring(x-linea,7,4)) )
    case t-cmov.codmov:
        when 03 then t-cmov.codmov-2 = 66.
        when 76 or when 77 or when 78 then t-cmov.codmov-2 = 03.
    end case.
    */
    assign
        t-cmov.codcia = 1
        t-cmov.nrodoc = integer(substring(x-linea,41,6))
        t-cmov.codalm = substring(x-linea,11,3)
        t-cmov.tipmov = substring(x-linea,31,1)
        t-cmov.codmov = integer(substring(x-linea,33,3))
        t-cmov.fchdoc = date( integer(substring(x-linea,4,2)),
                            integer(substring(x-linea,1,2)),
                            integer(substring(x-linea,7,4)) )
        t-cmov.codmov-2 = 66.
end.
input close.

for each t-cmov:
    display t-cmov.codalm t-cmov.tipmov t-cmov.codmov t-cmov.nroser t-cmov.nrodoc t-cmov.codmov-2.
end.
message 'primera parte ok?' view-as alert-box question
    buttons yes-no update rpta-1 as logical.
if rpta-1 = no then return.


/* cargamos los movimientos a extornar */
disable triggers for load of almcmov.
disable triggers for load of almdmov.

def temp-table t-almcmov like almcmov
    field codmov-2 like almcmov.codmov.

def temp-table t-almdmov like almdmov.

output to c:\tmp\inconsistencias.txt.
for each almacen no-lock where codcia = 1
    and lookup(trim(coddiv) , '00001,00002,00003,00004,00013,00014') = 0:
    for each t-cmov where t-cmov.codcia = 1
        and t-cmov.codalm = almacen.codalm:
        find almcmov where almcmov.codcia = t-cmov.codcia
            and almcmov.codalm = t-cmov.codalm
            and almcmov.tipmov = t-cmov.tipmov
            and almcmov.codmov = t-cmov.codmov-2    /* mov. cambiado */
            and almcmov.nrodoc = t-cmov.nrodoc
            exclusive-lock no-error.
        if error-status:error then DO:
            display t-cmov.fchdoc t-cmov.codalm 
                t-cmov.tipmov t-cmov.codmov 
                t-cmov.nroser t-cmov.nrodoc.
            next.
        end.
        create t-almcmov.
        buffer-copy almcmov to t-almcmov
            assign t-almcmov.codmov-2 = t-cmov.codmov.  /* mov. original */
        for each almdmov of almcmov:
            create t-almdmov.
            buffer-copy almdmov to t-almdmov.
        end.
    end.    
end.
output close.

/* punto de chequeo */
for each t-almcmov:
    display t-almcmov.fchdoc t-almcmov.codalm t-almcmov.tipmov t-almcmov.codmov t-almcmov.nroser t-almcmov.nrodoc.
    for each t-almdmov of t-almcmov:
        display t-almdmov.fchdoc t-almdmov.codmat t-almdmov.candes.
    end.
end.    
message 'segunda parte ok?' view-as alert-box question
    buttons yes-no update rpta-2 as logical.
if rpta-2 = no then return.

for each t-almcmov:
    find almcmov of t-almcmov exclusive-lock.
    for each almdmov of almcmov:
        find t-matg where t-matg.codcia = 1 
            and t-matg.codmat = almdmov.codmat no-lock no-error.
        if not available t-matg 
        then do:
            create t-matg.
            assign
                t-matg.codcia = 1
                t-matg.codmat = almdmov.codmat.
        end.
        delete almdmov.
    end.
    delete almcmov.
    create almcmov.
    buffer-copy t-almcmov to almcmov
        assign almcmov.codmov = t-almcmov.codmov-2.
    for each t-almdmov of t-almcmov:
        create almdmov.
        buffer-copy t-almdmov to almdmov
            assign almdmov.codmov = t-almcmov.codmov-2.
        find t-matg where t-matg.codcia = 1 
            and t-matg.codmat = almdmov.codmat no-lock no-error.
        if not available t-matg 
        then do:
            create t-matg.
            assign
                t-matg.codcia = 1
                t-matg.codmat = almdmov.codmat.
        end.
    end.
end.

/* actualizamos kardex general */
output to c:\tmp\t-matg.ate.
for each t-matg:
    display t-matg.codmat with no-box no-labels stream-io.
end.
output close.
