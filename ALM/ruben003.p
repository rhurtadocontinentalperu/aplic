/* REPORTE DE PRECIOS MENOR Y MAYOR PARA SUNAT */

def var x-linea as char format 'x(220)'.
def var x-precio-b as dec no-undo.
def var x-precio-c as dec no-undo.
def var x-factor-a as dec no-undo.
def var x-factor-b as dec no-undo.
def var x-factor-c as dec no-undo.
def var x-pordto   as dec no-undo.
def var x-tpocmb   as dec no-undo.

def var x-plvmen   as dec format '>>>,>>>,>>.99' init 0.
def var x-plsvmen  as dec format '>>>,>>>,>>.99' init 0.
def var x-minvmen  as dec format '>>>,>>>,>>.99' init 0.
def var x-maxvmen  as dec format '>>>,>>>,>>.99' init 0.
def var x-plvmay   as dec format '>>>,>>>,>>.99' init 0.
def var x-plsvmay  as dec format '>>>,>>>,>>.99' init 0.
def var x-minvmay  as dec format '>>>,>>>,>>.99' init 0.
def var x-maxvmay  as dec format '>>>,>>>,>>.99' init 0.
def frame frame1
    almmmatg.codmat
    with title 'procesando codigo' view-as dialog-box centered overlay.

def stream s-salida.
output stream s-salida to c:\tmp\sunat.txt.
for each almmmatg no-lock where codcia = 1:
    if tpoart = 'D' then next.
    if lookup(trim(catconta[1]), 'E1,E2,S1,S2,MP,PP,SP,AF,XX') > 0 then next.
    if catconta[1] = '' then next.
    display almmmatg.codmat with frame frame1. pause 0.
    x-tpocmb = if almmmatg.monvta = 2 then almmmatg.tpocmb else 1.
    x-linea = codmat + '|' + 
                desmat + '|' +
                '-' + '|' +
                undbas + '|'.
    /*
    find almtabla where tabla = 'MK' 
        and codigo = codmar no-lock no-error.
    if available almtabla
    then x-linea = x-linea + almtabla.Nombre + '|'.
    else x-linea = x-linea + almmmatg.desmar + '|'.
    */
    x-linea = x-linea + almmmatg.desmar + '|'.

    x-linea = x-linea + '-' + '|'.

    /* calculamos el menor precio */
    x-factor-a = 1.
    find almtconv where codunid = undbas and codalter = undA
        no-lock no-error.
    if available almtconv then x-factor-a = equival.
    x-factor-b = 1.
    find almtconv where codunid = undbas and codalter = undB
        no-lock no-error.
    if available almtconv then x-factor-b = equival.
    x-factor-c = 1.
    find almtconv where codunid = undbas and codalter = undC
        no-lock no-error.
    if available almtconv then x-factor-c = equival.

    x-plvmen = x-tpocmb * prevta[2] / x-factor-a.
    if x-plvmen = ? then x-plvmen = 0.
    x-plsvmen = x-plvmen.

    x-precio-b = ( if x-factor-b > 0 then prevta[3] / x-factor-b else prevta[3] ) * x-tpocmb.
    x-precio-c = ( if x-factor-c > 0 then prevta[4] / x-factor-c else prevta[4] ) * x-tpocmb.
    if x-precio-b = ? then x-precio-b = 0.
    if x-precio-c = ? then x-precio-c = 0.

    /* tomamos el precio que exista */
    x-plvmay  = x-precio-c.
    if x-plvmay <= 0 then x-plvmay = x-precio-b.
    if x-plvmay <= 0 then x-plvmay = x-plvmen.
    x-plsvmay = x-plvmay.

    /* buscamos el maximo % de descuento */
    x-pordto = 0.
    for each gn-divi where codcia = 1 no-lock:
        for each ccbddocu use-index llave03 where ccbddocu.codcia = 1 
            and ccbddocu.coddoc = 'fac'
            and ccbddocu.coddiv = gn-divi.coddiv
            and ccbddocu.codmat = almmmatg.codmat
            and ccbddocu.fchdoc >= date(01,01,2004)
            no-lock:
            IF ccbddocu.pordto <> ? AND ccbddocu.pordto > 0
            THEN x-pordto = MAXIMUM(x-pordto, CcbDDocu.PorDto).
        end.            
        for each ccbddocu use-index llave03 where ccbddocu.codcia = 1 
            and ccbddocu.coddoc = 'bol'
            and ccbddocu.coddiv = gn-divi.coddiv
            and ccbddocu.codmat = almmmatg.codmat
            and ccbddocu.fchdoc >= date(01,01,2004)
            no-lock:
            IF ccbddocu.pordto <> ? AND ccbddocu.pordto > 0
            THEN x-pordto = MAXIMUM(x-pordto, CcbDDocu.PorDto).
        end.            
    end.
    x-maxvmay = x-pordto.

    x-linea = x-linea + string(x-plvmen , '>>>,>>>,>>9.99') + '|'.
    x-linea = x-linea + string(x-plsvmen, '>>>,>>>,>>9.99') + '|'.
    x-linea = x-linea + string(x-minvmen, '>>>,>>>,>>9.99') + '|'.
    x-linea = x-linea + string(x-maxvmen, '>>>,>>>,>>9.99') + '|'.
    x-linea = x-linea + string(x-plvmay , '>>>,>>>,>>9.99') + '|'.
    x-linea = x-linea + string(x-plsvmay, '>>>,>>>,>>9.99') + '|'.
    x-linea = x-linea + string(x-minvmay, '>>>,>>>,>>9.99') + '|'.
    x-linea = x-linea + string(x-maxvmay, '>>>,>>>,>>9.99') + '|'.
    x-linea = x-linea + 'fin'.
    
    display stream s-salida x-linea with use-text no-labels no-box stream-io width 250.
end.
hide frame frame1.
output stream s-salida close.
