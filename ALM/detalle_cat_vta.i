
MESSAGE 'NroPag ' almcatvtac.nropag .
/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(almcatvtac.nropag).

/*Header del Excel */
cRange = "D" + '2'.
chWorkSheet:Range(cRange):Value = "CATALOGO DE PRODUCTOS PARA EL PROVEEDOR " + GN-PROV.NOMPRO.
cRange = "K" + '2'.
chWorkSheet:Range(cRange):Value = TODAY.

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".

/* set the column names for the Worksheet */
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Nro.Pag".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nro.Sec".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Codigo".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripción".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Unidades".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Precio".

FOR EACH almcatvtad WHERE almcatvtad.codcia = s-codcia
    AND almcatvtad.coddiv = s-coddiv
    AND almcatvtad.codpro = gn-prov.codpro
    AND almcatvtad.nropag = almcatvtac.nropag NO-LOCK,
    FIRST almmmatg WHERE almmmatg.codcia = s-codcia
    AND almmmatg.codmat = almcatvtad.codmat NO-LOCK
    BREAK BY almcatvtad.nropag:
    IF FIRST-OF(almcatvtad.nropag) THEN DO:
        /*
        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = almcatvtad.nropag.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = AlmCatVtaC.DesPag.
        */        
    END.
    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(almcatvtad.nropag,'999').
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(almcatvtad.nrosec,'999').
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = almcatvtad.codmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almcatvtad.DesMat.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.undbas.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.PreAlt[4].
    /*
    IF LAST-OF(almcatvtad.nropag) THEN t-Column = t-Column + 3.
    */
END.
