TRIGGER PROCEDURE FOR DELETE OF gn-vehic.

/* RHC 10/10/2019 Que no se halla usado anteriormente */
/* Internamiento de vehículo */
FIND FIRST TraIngSal WHERE TraIngSal.CodCia = gn-vehic.codcia AND
    TraIngSal.Placa = gn-vehic.placa NO-LOCK NO-ERROR.
IF AVAILABLE TraIngSal THEN DO:
    MESSAGE 'Vehículo ya tiene una transacción' SKIP
        'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
FIND FIRST DI-RutaC WHERE DI-RutaC.CodCia = gn-vehic.codcia AND
    DI-RutaC.CodDoc = "H/R" AND
    DI-RutaC.CodVeh = gn-vehic.placa NO-LOCK NO-ERROR.
IF AVAILABLE DI-RutaC THEN DO:
    MESSAGE 'Vehículo ya tiene una transacción' SKIP
        'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* RHC 04/03/2019 Log General */
/*{TRIGGERS/i-logtransactions.i &TableName="gn-vehic" &Event="DELETE"}*/

