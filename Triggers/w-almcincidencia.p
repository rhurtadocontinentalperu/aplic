TRIGGER PROCEDURE FOR WRITE OF AlmCIncidencia OLD BUFFER OldAlmCIncidencia.
/* ************************************************************************ */

DEF SHARED VAR s-user-id AS CHAR.

/* Incidencia APROBADA */
IF OldAlmCIncidencia.FlgEst <> "C" AND AlmCIncidencia.FlgEst = "C" THEN DO:
    FOR EACH AlmDIncidencia OF AlmCIncidencia NO-LOCK:
        CREATE LogIncidencias.
        BUFFER-COPY AlmCIncidencia TO LogIncidencias.
        ASSIGN
            LogIncidencias.Evento = "APROBADA"
            LogIncidencias.Fecha = TODAY
            LogIncidencias.Hora = STRING(TIME, "HH:MM:SS")
            LogIncidencias.Usuario = s-user-id.
        ASSIGN
            LogIncidencias.CanInc = AlmDIncidencia.CanInc
            LogIncidencias.CanPed = AlmDIncidencia.CanPed
            LogIncidencias.CodMat = AlmDIncidencia.CodMat
            LogIncidencias.Factor = AlmDIncidencia.Factor
            LogIncidencias.Incidencia = AlmDIncidencia.Incidencia
            LogIncidencias.UndVta = AlmDIncidencia.UndVta.
    END.
END.
/* Incidencia ANULADA (REEGRESA A CHEQUEO) */
IF OldAlmCIncidencia.FlgEst <> "A" AND AlmCIncidencia.FlgEst = "A" THEN DO:
    FOR EACH AlmDIncidencia OF AlmCIncidencia NO-LOCK:
        CREATE LogIncidencias.
        BUFFER-COPY AlmCIncidencia TO LogIncidencias.
        ASSIGN
            LogIncidencias.Evento = "ANULADA"
            LogIncidencias.Fecha = TODAY
            LogIncidencias.Hora = STRING(TIME, "HH:MM:SS")
            LogIncidencias.Usuario = s-user-id.
        ASSIGN
            LogIncidencias.CanInc = AlmDIncidencia.CanInc
            LogIncidencias.CanPed = AlmDIncidencia.CanPed
            LogIncidencias.CodMat = AlmDIncidencia.CodMat
            LogIncidencias.Factor = AlmDIncidencia.Factor
            LogIncidencias.Incidencia = AlmDIncidencia.Incidencia
            LogIncidencias.UndVta = AlmDIncidencia.UndVta.
    END.
END.
/* Incidencia CERRADA */
IF OldAlmCIncidencia.FlgEst <> "P" AND AlmCIncidencia.FlgEst = "P" THEN DO:
    FOR EACH AlmDIncidencia OF AlmCIncidencia NO-LOCK:
        CREATE LogIncidencias.
        BUFFER-COPY AlmCIncidencia TO LogIncidencias.
        ASSIGN
            LogIncidencias.Evento = "CERRADA"
            LogIncidencias.Fecha = TODAY
            LogIncidencias.Hora = STRING(TIME, "HH:MM:SS")
            LogIncidencias.Usuario = s-user-id.
        ASSIGN
            LogIncidencias.CanInc = AlmDIncidencia.CanInc
            LogIncidencias.CanPed = AlmDIncidencia.CanPed
            LogIncidencias.CodMat = AlmDIncidencia.CodMat
            LogIncidencias.Factor = AlmDIncidencia.Factor
            LogIncidencias.Incidencia = AlmDIncidencia.Incidencia
            LogIncidencias.UndVta = AlmDIncidencia.UndVta.
    END.
END.
