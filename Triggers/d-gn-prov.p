TRIGGER PROCEDURE FOR DELETE OF Gn-Prov.

    /* RHC 10/10/2019 Que no se halla usado anteriormente */
    DEF SHARED VAR s-codcia AS INT.
    FIND FIRST TraIngSal WHERE TraIngSal.CodCia = s-codcia AND
        TraIngSal.CodPro = gn-prov.codpro NO-LOCK NO-ERROR.
    IF AVAILABLE TraIngSal THEN DO:
        MESSAGE 'Proveeedor ya tiene una transacción' SKIP
            'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    FIND FIRST DI-RutaC WHERE DI-RutaC.CodCia = s-codcia AND
        DI-RutaC.CodDoc = "H/R" AND
        DI-RutaC.CodPro = gn-prov.codpro NO-LOCK NO-ERROR.
    IF AVAILABLE DI-RutaC THEN DO:
        MESSAGE 'Proveedor ya tiene una transacción' SKIP
            'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.

    /* RHC 04/03/2019 Log General */
    /*{TRIGGERS/i-logtransactions.i &TableName="gn-prov" &Event="DELETE"}*/
