DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF TEMP-TABLE detalle
    FIELD codcli LIKE faccpedi.codcli
    FIELD nomcli LIKE faccpedi.nomcli
    FIELD dircli LIKE faccpedi.dircli
    FIELD imptot LIKE faccpedi.imptot
    INDEX llave01 AS PRIMARY codcli.

FOR EACH faccpedi NO-LOCK WHERE codcia = 1
    AND coddoc = 'cot'
    AND coddiv = '00015'
    AND fchped >= 10/25/2010
    AND LOOKUP(flgest, 'p,c') > 0:
    FIND detalle WHERE detalle.codcli = faccpedi.codcli
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE detalle THEN DO:
        CREATE detalle.
        ASSIGN
            detalle.codcli = faccpedi.codcli
            detalle.nomcli = faccpedi.nomcli
            detalle.dircli = faccpedi.dircli.
    END.
    detalle.imptot = detalle.imptot + faccpedi.imptot.
END.

OUTPUT TO c:\tmp\resumen-por-clientes.txt.
FOR EACH detalle, FIRST gn-clie WHERE gn-clie.codcia = 0
    AND gn-clie.codcli = detalle.codcli:
    x-Llave = detalle.codcli + '|' + detalle.nomcli + '|' + detalle.dircli + '|'.
    /* departamento provincia distrito y codipo postal */
    FIND Tabdepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdepto 
    THEN x-Llave = x-Llave + gn-clie.coddept + ' ' + TabDepto.NomDepto + '|'.
    ELSE x-Llave = x-LLave + ' ' + '|'.
    FIND Tabprovi WHERE TabProvi.CodDepto = gn-clie.coddept
        AND TabProvi.CodProvi = gn-clie.codprov NO-LOCK NO-ERROR.
    IF AVAILABLE Tabprovi 
    THEN x-Llave = x-Llave + gn-clie.coddept + ' ' + TabProvi.NomProvi + '|'.
    ELSE x-Llave = x-Llave + ' ' + '|'.
    FIND Tabdistr WHERE TabDistr.CodDepto = gn-clie.coddept
        AND TabDistr.CodProvi = gn-clie.codprov
        AND TabDistr.CodDistr = gn-clie.coddist NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr 
    THEN x-Llave = x-LLave + gn-clie.coddist + ' ' + TabDistr.NomDistr + '|'.
    ELSE x-Llave = x-Llave + ' ' + '|'.
    FIND almtabla WHERE almtabla.tabla = 'CP'
        AND almtabla.codigo = FacCPedi.CodPos NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla
    THEN x-Llave = x-Llave + faccpedi.codpos + ' ' + almtabla.nombre + '|'.
    ELSE x-Llave = x-LLave + ' ' + '|'.
    x-Llave = x-LLave + gn-clie.telfnos[1] + '|'.
    x-LLave = x-LLave + STRING(detalle.imptot, '>>>,>>>,>>9.99') + '|'.
    PUT x-LLave SKIP.
END.
OUTPUT CLOSE.
