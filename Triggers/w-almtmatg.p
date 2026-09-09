TRIGGER PROCEDURE FOR WRITE OF almtmatg.

/* RHC 11/04/2019 Control de Unidades de Medida solicitada por Juan Ponte */
IF NOT (TRUE <> (almtmatg.UndBas > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="almtmatg.UndBas"}
END.
IF NOT (TRUE <> (almtmatg.UndCmp > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="almtmatg.UndCmp"}
END.
IF NOT (TRUE <> (almtmatg.UndStk > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="almtmatg.UndStk"}
END.
IF NOT (TRUE <> (almtmatg.UndA > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="almtmatg.UndA"}
END.
IF NOT (TRUE <> (almtmatg.UndB > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="almtmatg.UndB"}
END.
IF NOT (TRUE <> (almtmatg.UndC > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="almtmatg.UndC"}
END.
IF NOT (TRUE <> (almtmatg.CHR__01 > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="almtmatg.Chr__01"}
END.
IF NOT (TRUE <> (almtmatg.UndAlt[1] > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="almtmatg.UndAlt[1]"}
END.

