def var x-cantot as dec no-undo.
def var x-rowid as rowid no-undo.

/* Reporte de Ingreso de Productos Terminados vs las Liquidaciones */
output to c:\tmp\liquidaciones.txt.
for each almdmov no-lock where codcia = 001 /*and codalm = '12'*/
    and tipmov =  'I' and codmov = 50
    and fchdoc >= 01/01/2005 and fchdoc <= 12/31/2005,
    first almcmov of almdmov no-lock,
    first almmmatg of almdmov no-lock:
    /* buscamos la liquidacion */
    x-rowid = ?.
    busca:
    for each pr-liqcx no-lock where pr-liqcx.codcia = 001
        and pr-liqcx.numord = almcmov.nroref
        and pr-liqcx.codart = almdmov.codmat:
        find first pr-liqc of pr-liqcx where almdmov.fchdoc >= pr-liqc.fecini
            and almdmov.fchdoc <= pr-liqc.fecfin
            no-lock no-error.
        if available pr-liqc then do:
            x-rowid = rowid(pr-liqc).
            leave busca.
        end.
    end.
    if x-rowid = ? then next.
        
/*    find first pr-liqcx where pr-liqcx.codcia = 001
 *         and pr-liqcx.numord = almcmov.nroref
 *         and pr-liqcx.codart = almdmov.codmat
 *         no-lock no-error.
 *     if not available pr-liqcx then next.
 *     find first pr-liqc of pr-liqcx no-lock no-error.
 *     if not available pr-liqc then next.
 *     x-cantot = 0.
 *     for each pr-liqcx of pr-liqc no-lock:
 *         x-cantot = x-cantot + pr-liqcx.canfin.
 *     end.*/

    find pr-liqc where rowid(pr-liqc) = x-rowid no-lock.
    x-cantot = 0.
    for each pr-liqcx of pr-liqc no-lock:
        x-cantot = x-cantot + pr-liqcx.canfin.
    end.

    display
        almdmov.nrodoc  column-label 'Nº Ingreso'
        almdmov.codalm  column-label 'Alm'
        almdmov.fchdoc  column-label 'Fecha Ing'
        almdmov.codmat  column-label 'Codigo'
        almmmatg.desmat column-label 'Descripcion'
        almdmov.codund  column-label 'Unidad'
        almdmov.candes  column-label 'Cantidad'
        almcmov.nroref  column-label 'Nº Orden'
        pr-liqc.numliq  column-label 'Nº Liquid'
        x-cantot        column-label 'Cant. Total'
        pr-liqc.ctomat  column-label 'Materiales'
        pr-liqc.ctohor  column-label 'M. Obra'
        pr-liqc.ctogas  column-label 'Servicios'
        pr-liqc.factor  column-label 'Factor GF'
        pr-liqc.ctofab  column-label 'Gast. Fabric.'
        pr-liqc.tpocmb  column-label 'T/Cambio'
        pr-liqc.ctotot  column-label 'Costo Total'
        pr-liqc.preuni  column-label 'Costo Uni.'
        pr-liqc.fecini  column-label 'Rang. Inic.'
        pr-liqc.fecfin  column-label 'Rango Fin.'
        pr-liqc.fchliq  column-label 'Fecha Liquid.'
        with stream-io width 320.        
end.
output close.
