TRIGGER PROCEDURE FOR DELETE OF VtaListaMay.

    DEF SHARED VAR s-user-id AS CHAR.

    /* Actualizamos VtaDctoProm: Promociones Vigentes */
    FOR EACH VtaDctoProm EXCLUSIVE-LOCK WHERE VtaDctoProm.CodCia = VtaListaMay.CodCia 
        AND VtaDctoProm.CodDiv = VtaListaMay.CodDiv 
        AND VtaDctoProm.CodMat = VtaListaMay.codmat:
        DELETE VtaDctoProm.
    END.

    CREATE LogVtaListaMay.
    BUFFER-COPY VtaListaMay TO LogVtaListaMay
        ASSIGN
            LogVtaListaMay.LogEvento = "DELETE"
            LogVtaListaMay.LogDate = TODAY
            LogVtaListaMay.LogTime = STRING(TIME, 'HH:MM:SS')
            LogVtaListaMay.LogUser = s-user-id.
