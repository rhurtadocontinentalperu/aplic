TRIGGER PROCEDURE FOR DELETE OF VtaTabla.

IF LOOKUP(VtaTabla.Tabla, "DTOPROLIMA,DTOPROUTILEX") > 0 THEN RETURN.
IF VtaTabla.Tabla = "BREVETE" THEN DO:
    /* Internamiento de vehículo */
    FIND FIRST TraIngSal WHERE TraIngSal.CodCia = VtaTabla.codcia AND
        TraIngSal.Brevete = VtaTabla.Llave_c1 NO-LOCK NO-ERROR.
    IF AVAILABLE TraIngSal THEN DO:
        MESSAGE 'Brevete ya tiene una transacción' SKIP
            'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    FIND FIRST DI-RutaC WHERE DI-RutaC.CodCia = VtaTabla.codcia AND
        DI-RutaC.CodDoc = "H/R" AND
        DI-RutaC.Libre_c01 = VtaTabla.Llave_c1 NO-LOCK NO-ERROR.
    IF AVAILABLE DI-RutaC THEN DO:
        MESSAGE 'Brevete ya tiene una transacción' SKIP
            'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* RHC 04/03/2019 Log General */
    /*{TRIGGERS/i-logtransactions.i &TableName="vtatabla" &Event="DELETE"}*/
END.
/* 21/01/2021 Log de control */
DEF SHARED VAR s-user-id AS CHAR.
DEF VAR pEvento AS CHAR NO-UNDO.
pEvento = 'DELETE'.
CREATE LogVtaTabla.
BUFFER-COPY VtaTabla TO LogVtaTabla
    ASSIGN
    LogVtaTabla.LogDate = TODAY
    LogVtaTabla.LogEvento = pEvento
    LogVtaTabla.LogTime = STRING(TIME, 'HH:MM:SS')
    LogVtaTabla.LogUser = s-user-id.
RELEASE LogVtaTabla.


