DEF VAR x-margen AS DEC.
DEF VAR x-ctotot AS DEC.
DEF VAR x-prebas AS DEC.
DEF VAR x-precio-1 AS DEC.
DEF VAR x-precio-2 AS DEC.
DEF VAR x-codfam AS CHAR NO-UNDO.
DEF VAR x-archivo AS CHAR NO-UNDO.

x-codfam = '010'.
x-archivo = 'd:\prueba' + TRIM(x-codfam) + '.txt'.
OUTPUT TO VALUE(x-archivo).
PUT UNFORMATTED 
    'SKU|DECRIPCION|MARCA|UNIDAD|LINEA|SUBLINEA|COSTO REPOSICION|P. BASE AL xx/xx/xx|MARGEN|CANAL|FACTOR-1|PRECIO-1|GRUPO|FACTOR-2|PRECIO-2'
    SKIP.
FOR EACH almmmatg NO-LOCK WHERE codcia = 1 AND codfam = x-codfam AND tpoart <> "D", 
    FIRST almtfami OF almmmatg NO-LOCK WHERE almtfami.swcomercial = YES:
    x-ctotot = (IF monvta = 2 THEN ctotot * almmmatg.tpocmb ELSE ctotot).
    x-prebas = (IF monvta = 2 THEN preofi * almmmatg.tpocmb ELSE preofi).
    x-precio-1 = x-prebas.
    x-precio-2 = x-prebas.
    x-margen = 0.
    IF x-ctotot > 0 THEN x-margen = (x-prebas - x-ctotot) / x-ctotot * 100.
    FOR EACH pricanal NO-LOCK WHERE pricanal.CodCia = almmmatg.codcia,
        EACH pricanalgrupo OF pricanal NO-LOCK,
        FIRST prigrupo OF pricanalgrupo NO-LOCK:
        PUT UNFORMATTED
            codmat '|'
            desmat '|'
            desmar '|'
            CHR__01 '|'
            almmmatg.codfam '|'
            subfam '|'
            x-ctotot '|'
            x-prebas '|'
            x-margen '|'
            pricanal.descripcion '|'
            pricanal.Factor '|'
            x-precio-1 '|'
            prigrupo.Descripcion '|'
            pricanalgrupo.Factor '|'
            x-precio-2
            SKIP.
    END.
END.
OUTPUT CLOSE.

