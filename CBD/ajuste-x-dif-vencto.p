def buffer b-dmov for cb-dmov.
for each cb-dmov where codcia = 001 and periodo = 2006
    and codope = '019'
    and codcta = '121202'
    and glodoc begins 'ajuste x dif':
    find first b-dmov where b-dmov.codcia = 001
        and b-dmov.periodo = 2006
        and b-dmov.codope = '062'
        and b-dmov.codcta = cb-dmov.codcta
        and b-dmov.coddoc = cb-dmov.coddoc
        and b-dmov.nrodoc = cb-dmov.nrodoc
        no-lock no-error.
    if not available b-dmov 
    then find first b-dmov where b-dmov.codcia = 001
        and b-dmov.periodo = 2006
        and b-dmov.codope = '000'
        and b-dmov.codcta = cb-dmov.codcta
        and b-dmov.coddoc = cb-dmov.coddoc
        and b-dmov.nrodoc = cb-dmov.nrodoc
        no-lock no-error.

/*    display 
 *         cb-dmov.codcta 
 *         cb-dmov.nromes 
 *         cb-dmov.nroast 
 *         cb-dmov.impmn1 
 *         cb-dmov.impmn2 
 *         cb-dmov.coddoc 
 *         cb-dmov.nrodoc 
 *         cb-dmov.fchvto
 *     with stream-io no-box no-labels.*/
    if available b-dmov
    then do:
/*        display 
 *             b-dmov.nromes 
 *             b-dmov.nroast 
 *             b-dmov.impmn1 
 *             b-dmov.impmn2 
 *             b-dmov.coddoc 
 *             b-dmov.nrodoc 
 *             b-dmov.fchvto
 *             with stream-io no-box no-labels.*/
        cb-dmov.fchvto = b-dmov.fchvto.
    end.
end.    
