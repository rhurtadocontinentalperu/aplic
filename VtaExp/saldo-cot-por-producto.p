DEF TEMP-TABLE detalle LIKE almmmatg
    FIELD canped LIKE facdpedi.canped
    FIELD canate LIKE facdpedi.canate
    FIELD stkact LIKE almmmate.stkact
    FIELD impped LIKE facdpedi.implin
    FIELD impate LIKE facdpedi.implin.

DEF VAR x-canate AS DEC NO-UNDO.
DEF VAR x-nompro LIKE gn-prov.nompro.

FOR EACH faccpedi NO-LOCK WHERE codcia = 1
    AND coddoc = 'cot'
    AND coddiv = '00015'
    AND flgest <> 'A'
    AND fchped >= 01/06/09,
    EACH facdpedi OF faccpedi NO-LOCK,
    FIRST almmmatg OF facdpedi NO-LOCK:
    FIND detalle OF almmmatg EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE detalle THEN DO:
        CREATE detalle.
        BUFFER-COPY almmmatg TO detalle.
    END.
    detalle.canped = detalle.canped + facdpedi.canped.
    detalle.canate = detalle.canate + facdpedi.canate.
    detalle.impped = detalle.impped + facdpedi.canped * (facdpedi.implin / facdpedi.canped).
    detalle.impate = detalle.impate + facdpedi.canate * (facdpedi.implin / facdpedi.canped).
    FIND almmmate WHERE almmmate.codcia = facdpedi.codcia
        AND almmmate.codalm = '15'
        AND almmmate.codmat = facdpedi.codmat
        NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN detalle.stkact = almmmate.stkact.
END.
OUTPUT TO m:\tmp\por-producto.txt.
FOR EACH detalle NO-LOCK:
    FIND gn-prov WHERE gn-prov.codcia = 0
        AND gn-prov.codpro = detalle.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN x-nompro = gn-prov.nompro.
    ELSE x-nompro = ''.

    DISPLAY 
        detalle.codmat  COLUMN-LABEL 'Material'
        detalle.desmat  COLUMN-LABEL 'Descripcion'
        detalle.desmar  COLUMN-LABEL 'Marca'
        detalle.undbas  COLUMN-LABEL 'Unidad'
        detalle.canped  COLUMN-LABEL 'Cotizado'
        detalle.impped  COLUMN-LABEL 'Cotizado!Valorizado'
        detalle.canate  COLUMN-LABEL 'Atendido'
        detalle.impate  COLUMN-LABEL 'Atendido!Valorizado'
        detalle.stkact  COLUMN-LABEL 'Stock!Alm 15'
        detalle.codpr1  COLUMN-LABEL 'Proveedor'
        x-nompro        COLUMN-LABEL 'Nombre'
        WITH STREAM-IO NO-BOX WIDTH 320.
END.
OUTPUT CLOSE.

