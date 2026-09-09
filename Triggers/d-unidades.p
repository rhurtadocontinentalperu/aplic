TRIGGER PROCEDURE FOR DELETE OF Unidades.

/* NO se puede anular una unidad si está en uso en el catálogo de productos */
DEF SHARED VAR s-codcia AS INT.
DEF BUFFER b-Almmmatg FOR Almmmatg.

FIND FIRST b-Almmmatg WHERE b-Almmmatg.codcia = s-codcia
    AND b-Almmmatg.undbas = Unidades.Codunid
    NO-LOCK NO-ERROR.
IF AVAILABLE b-Almmmatg THEN DO:
    MESSAGE 'Unidad registrada en la unidad base del artículo: ' b-Almmmatg.codmat
        SKIP 'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
FIND FIRST b-Almmmatg WHERE b-Almmmatg.codcia = s-codcia
    AND b-Almmmatg.unda = Unidades.Codunid
    NO-LOCK NO-ERROR.
IF AVAILABLE b-Almmmatg THEN DO:
    MESSAGE 'Unidad registrada en la unidad A del artículo: ' b-Almmmatg.codmat
        SKIP 'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
FIND FIRST b-Almmmatg WHERE b-Almmmatg.codcia = s-codcia
    AND b-Almmmatg.undb = Unidades.Codunid
    NO-LOCK NO-ERROR.
IF AVAILABLE b-Almmmatg THEN DO:
    MESSAGE 'Unidad registrada en la unidad B del artículo: ' b-Almmmatg.codmat
        SKIP 'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
FIND FIRST b-Almmmatg WHERE b-Almmmatg.codcia = s-codcia
    AND b-Almmmatg.undc = Unidades.Codunid
    NO-LOCK NO-ERROR.
IF AVAILABLE b-Almmmatg THEN DO:
    MESSAGE 'Unidad registrada en la unidad C del artículo: ' b-Almmmatg.codmat
        SKIP 'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
