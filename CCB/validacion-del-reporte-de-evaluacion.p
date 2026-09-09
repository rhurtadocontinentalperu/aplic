
DEF VAR x-importe AS DECI NO-UNDO.
DEF VAR x-imptot AS DECI NO-UNDO.
DEF VAR x-TpoCmbCmp AS DECI NO-UNDO.
DEF VAR x-TpoCmbVta AS DECI NO-UNDO.
DEF VAR x-ImpLin AS DECI NO-UNDO.
DEF VAR x-totlin AS DECI NO-UNDO.
DEF VAR TOGGLE-Solo-Ruc AS LOG INIT YES NO-UNDO.

DEF VAR x-a AS INTE NO-UNDO.
DEF VAR x-b AS INTE NO-UNDO.

FOR EACH Ccbcdocu 
    FIELDS(codcia coddiv fchdoc coddoc nrodoc codcli imptot codmon tpofac fmapgo TotalPrecioVenta)
    NO-LOCK 
    WHERE Ccbcdocu.codcia = 1 
    AND codcli = "20100047218"
    AND fchdoc >= DATE(10,01,2021)
    AND fchdoc <= DATE(04,30,2022)
    AND LOOKUP(coddoc, 'FAC,BOL') > 0 
    AND Ccbcdocu.flgest <> "A",
    FIRST gn-clie 
    FIELDS(codcia codcli ruc)
    NO-LOCK
    WHERE gn-clie.codcia = 0 AND
    gn-clie.codcli = Ccbcdocu.codcli:
    /* FILTROS */
    IF TOGGLE-Solo-Ruc = YES AND TRUE <> (gn-clie.ruc > "") THEN NEXT.
    IF LOOKUP(CcbCdocu.TpoFac, 'A,S') > 0 THEN NEXT.
    IF LOOKUP(Ccbcdocu.FmaPgo, '899,900') > 0 THEN NEXT.
    /* 11/07/2025 Cabecera sin detalle (¿?) */
    IF NOT CAN-FIND(FIRST CcbDDocu OF CcbCDocu NO-LOCK) THEN NEXT.

    x-a = x-a + 1.

    /* 1ro vemos el detalle */
    /* 12/09/2024: Gina Condor NO línea 011 */
    x-totlin = 0.
    FOR EACH Ccbddocu FIELDS (codcia coddiv coddoc nrodoc codmat implin cImporteTotalConImpuesto) OF Ccbcdocu NO-LOCK, 
        FIRST Almmmatg FIELDS (codcia codmat codfam CatConta) OF Ccbddocu NO-LOCK WHERE Almmmatg.codfam <> '011':
        x-ImpLin = Ccbddocu.cImporteTotalConImpuesto.
        IF x-ImpLin = 0 AND Ccbddocu.ImpLin > 0 THEN x-ImpLin = Ccbddocu.ImpLin.
        IF Ccbcdocu.codmon = 2 THEN x-ImpLin = x-ImpLin * x-TpoCmbVta.  /* Todo en SOLES */
        x-totlin = x-totlin + x-implin.
    END.
    /* 2do vemos la cabecera */
    x-ImpTot = CcbCDocu.TotalPrecioVenta.
    IF x-ImpTot = 0 AND Ccbcdocu.ImpTot > 0 THEN x-ImpTot = Ccbcdocu.ImpTot.
    FOR EACH Ccbddocu FIELDS (codcia coddiv coddoc nrodoc codmat implin cImporteTotalConImpuesto) OF Ccbcdocu NO-LOCK, 
        FIRST Almmmatg FIELDS (codcia codmat codfam) OF Ccbddocu NO-LOCK WHERE Almmmatg.codfam = '011':
        x-ImpLin = Ccbddocu.cImporteTotalConImpuesto.
        IF x-ImpLin = 0 AND Ccbddocu.ImpLin > 0 THEN x-ImpLin = Ccbddocu.ImpLin.
        x-ImpTot = x-ImpTot - x-ImpLin.
    END.
    IF Ccbcdocu.codmon = 2 THEN DO:
        FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
        IF AVAILABLE gn-tcmb THEN
            ASSIGN
            x-TpoCmbCmp = gn-tcmb.compra 
            x-TpoCmbVta = gn-tcmb.venta.
        x-ImpTot = x-ImpTot * x-TpoCmbVta.  /* Todo en SOLES */
    END.
    IF x-imptot <> x-implin THEN x-imptot = Ccbcdocu.ImpTot.
    /* 3ro. vemos la diferencia */
    IF x-imptot <> x-totlin THEN DO:
        x-b = x-b + 1.
        DISPLAY ccbcdocu.coddoc ccbcdocu.nrodoc ccbcdocu.codmon x-imptot x-totlin WITH STREAM-IO NO-BOX WIDTH 320.
    END.
END.
    DISPLAY x-a x-b.
