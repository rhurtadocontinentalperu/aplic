TRIGGER PROCEDURE FOR DELETE OF almssfami.

FIND FIRST Almmmatg WHERE Almmmatg.codcia = almssfami.codcia
    AND Almmmatg.codfam = almssfami.codfam
    AND Almmmatg.subfam = almssfami.subfam
    AND Almmmatg.codssfam = almssfami.codssfam
    NO-LOCK NO-ERROR NO-WAIT.
IF AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Código de sub-sub-familia está siendo usado en el artículo:' Almmmatg.codmat
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.


