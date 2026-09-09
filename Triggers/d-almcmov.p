TRIGGER PROCEDURE FOR DELETE OF Almcmov.

/* Verificamos la Fecha de Cierre de Almacenes */
DEF SHARED VAR s-codcia AS INT.
FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia
    AND TabGener.Clave = "CIERRE"
    AND TabGener.Codigo = "ALMACEN"
    NO-LOCK NO-ERROR.
IF AVAILABLE TabGener AND TabGener.Libre_f01 <> ? THEN DO:
    IF Almcmov.FchDoc <> ? AND Almcmov.FchDoc <= TabGener.Libre_f01 THEN DO:
        MESSAGE "NO se pueden modificar/anular movimientos de almacén generados hasta el" TabGener.Libre_f01
            VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
END.

/* RHC 13/05/2017 Ya no se usa
DEF VAR xRaw AS RAW NO-UNDO.
RAW-TRANSFER Almcmov TO xRaw.

RUN orange\exporta-almacenes ('Almcmov',xRaw,"D").

*/
