DEF VAR x-linea AS CHAR NO-UNDO.

DO TRANSACTION:
    DELETE FROM ooItemAlternativeCode.
END.

INPUT FROM d:\barras.prn.
REPEAT :
    IMPORT UNFORMATTED x-linea.
    IF TRUE <> (x-linea > '') THEN LEAVE.
    CREATE ooItemAlternativeCode.
    ASSIGN
        ooItemAlternativeCode.ItemNro   = SUBSTRING(x-Linea,1,15)
        ooItemAlternativeCode.FreeText  = SUBSTRING(x-Linea,16,15)
        ooItemAlternativeCode.ItemCode  = SUBSTRING(x-Linea,31,15)
        ooItemAlternativeCode.Factor    = DECIMAL(SUBSTRING(x-Linea,46,15))
        ooItemAlternativeCode.Weight    = DECIMAL(SUBSTRING(x-Linea,61,15))
        ooItemAlternativeCode.Long      = DECIMAL(SUBSTRING(x-Linea,76,15))
        ooItemAlternativeCode.Height    = DECIMAL(SUBSTRING(x-Linea,91,15))
        ooItemAlternativeCode.WIDTH     = DECIMAL(SUBSTRING(x-LInea,106,15))
        ooItemAlternativeCode.Volume    = DECIMAL(SUBSTRING(x-Linea,121,15))
        .
END.
INPUT CLOSE.

