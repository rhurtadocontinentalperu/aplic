TRIGGER PROCEDURE FOR DELETE OF gn-ven.

DEFINE SHARED VAR s-codcia AS INT.

/* Vamos a probar un método alternativo */
IF gn-ven.libre_f01 <> ? THEN DO:
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.fchdoc >= gn-ven.libre_f01
        AND Ccbcdocu.codven = gn-ven.codven:
            MESSAGE 'Este vendedor tiene historial de ventas, no se puede anular'
                VIEW-AS ALERT-BOX ERROR.
            RETURN ERROR.
        
    END.
END.

/* 08/07/2025: Es mejor bloquearlo hasta tener un índice por vendedor 
Indice recomendado:
Tabla: CcbCDocu
Indice: codcia codven fchdoc


IF CAN-FIND(FIRST faccpedi WHERE faccpedi.codcia = s-codcia
            AND faccpedi.coddoc = 'COT'
            AND faccpedi.codven = gn-ven.codven
            NO-LOCK)
    THEN DO:
    MESSAGE 'Este vendedor tiene historial de ventas, no se puede anular'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF CAN-FIND(FIRST faccpedi WHERE faccpedi.codcia = s-codcia
            AND faccpedi.coddoc = 'P/M'
            AND faccpedi.codven = gn-ven.codven
            NO-LOCK)
    THEN DO:
    MESSAGE 'Este vendedor tiene historial de ventas, no se puede anular'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
*/
