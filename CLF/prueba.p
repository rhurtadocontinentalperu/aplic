DEF VAR x-fecha AS DATE.
DEF VAR a AS INT64.
DEF VAR cDivisiones AS CHAR INIT '*'.
DEF VAR cCodDiv AS CHAR.
DEF VAR cCtgCtble AS CHAR.
DEF VAR cCategoriasContables AS CHAR INIT 'MC,MI'.
DEF TEMP-TABLE t-Ventas_Cabecera NO-UNDO LIKE Ventas_Cabecera.
DEF VAR iConteo AS INTE NO-UNDO.

a = ETIME(YES).
iConteo = 0.
FOR EACH ventas_cabecera NO-LOCK WHERE 
        ventas_cabecera.datekey >= DATE(01,01,2022) AND 
        ventas_cabecera.datekey <= DATE(01,31,2022):
    IF LOOKUP(ventas_cabecera.coddoc, 'FAC,BOL') = 0 THEN NEXT.
    /* 1) Por las divisiones válidas */
    IF cDivisiones <> "*" THEN DO:
        cCodDiv = TRIM(ventas_cabecera.coddiv).
        IF LOOKUP(cCodDiv, cDivisiones) = 0 THEN NEXT.        
    END.
    IF iConteo MODULO 10000 = 0 THEN DO:
        DISPLAY ventas_cabecera.datekey ventas_cabecera.coddoc ventas_cabecera.nrodoc
            WITH STREAM-IO NO-BOX.
        PAUSE 0.
    END.
    iConteo = iConteo + 1.
    /* 3) Temporal */
    CREATE t-Ventas_Cabecera.
    BUFFER-COPY Ventas_Cabecera TO t-Ventas_Cabecera.
    FOR EACH ventas_detalle NO-LOCK USE-INDEX Index03 WHERE
        ventas_detalle.coddoc = ventas_cabecera.coddoc AND
        ventas_detalle.nrodoc = ventas_cabecera.nrodoc,
        FIRST DimProducto 
        FIELDS(codmat tpoart CtgCtble)
        NO-LOCK WHERE DimProducto.codmat = Ventas_Detalle.codmat:
        /* 2) Por el artículo */
        IF DimProducto.tpoart <> 'A' THEN NEXT.
        cCtgCtble = DimProducto.CtgCtble.
        IF LOOKUP(cCtgCtble,cCategoriasContables) = 0 THEN NEXT.
    END.
END.
MESSAGE ETIME.

FOR EACH t-Ventas_Cabecera NO-LOCK:
    DISPLAY t-Ventas_Cabecera.datekey t-Ventas_Cabecera.coddoc t-Ventas_Cabecera.nrodoc
        WITH STREAM-IO NO-BOX.
    PAUSE 0.
    FOR EACH Ventas_Cabecera NO-LOCK WHERE Ventas_Cabecera.CodDoc = "N/C" AND
            Ventas_Cabecera.CodRef = t-Ventas_Cabecera.CodDoc AND       /* FAC o BOL */
            Ventas_Cabecera.NroRef = t-Ventas_Cabecera.NroDoc,
        EACH Ventas_Detalle NO-LOCK WHERE Ventas_Detalle.CodDoc = Ventas_Cabecera.CodDoc AND
            Ventas_Detalle.NroDoc = Ventas_Cabecera.NroDoc,
        FIRST DimProducto NO-LOCK WHERE DimProducto.codmat = Ventas_Detalle.codmat:
        IF DimProducto.tpoart <> 'A' THEN NEXT.
        cCtgCtble = DimProducto.CtgCtble.
        IF LOOKUP(cCtgCtble,cCategoriasContables) = 0 THEN NEXT.
    END.
END.

