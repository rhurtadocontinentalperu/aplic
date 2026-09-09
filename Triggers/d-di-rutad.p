TRIGGER PROCEDURE FOR DELETE OF Di-RutaD.

DEF SHARED VAR s-user-id AS CHAR.

/* RHC 10.06.2011 CONTROL DE TRACKING */
FIND Ccbcdocu WHERE Ccbcdocu.codcia = di-rutad.codcia
    AND Ccbcdocu.coddoc = di-rutad.codref
    AND Ccbcdocu.nrodoc = di-rutad.nroref
    NO-LOCK NO-ERROR NO-WAIT.
IF AVAILABLE Ccbcdocu 
    THEN RUN vtagn/pTracking-04 (Di-RutaD.CodCia,
                                 Di-RutaD.CodDiv,
                                 Ccbcdocu.CodPed,
                                 Ccbcdocu.NroPed,
                                 s-User-Id,
                                 'RHR',
                                 'A',
                                 DATETIME(TODAY, MTIME),
                                 DATETIME(TODAY, MTIME),
                                 Di-RutaD.CodRef,
                                 Di-RutaD.NroRef,
                                 Di-RutaD.CodDoc + '|' + Di-RutaD.NroDoc,
                                 Di-RutaD.FlgEst + '|' + Di-RutaD.FlgEstDet).

/* RHC 20.05.2011 buscamos en el control documentario */
/*
FIND LAST CntDocum USE-INDEX Llave02 WHERE CntDocum.codcia = di-rutad.codcia
    AND CntDocum.coddoc = di-rutad.codref
    AND CntDocum.nrodoc = di-rutad.nroref
    AND CntDocum.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE CntDocum /*AND CntDocum.tipmov = "S"*/ THEN DO:
    MESSAGE 'La' CntDocum.coddoc CntDocum.nrodoc 'ya pasó por el control documentario'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
*/

CREATE LogTabla.
ASSIGN
    logtabla.codcia = Di-RutaD.codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'DELETE'
    logtabla.Hora = STRING(TIME, 'HH:MM')
    logtabla.Tabla = 'Di-RutaD'
    logtabla.Usuario = s-user-id
    logtabla.ValorLlave = STRING(Di-RutaD.coddiv, 'x(5)') + '|' +
                        STRING(Di-RutaD.coddoc, 'x(3)') + '|' +
                        STRING(Di-RutaD.nrodoc, 'x(12)') + '|' +
                        STRING(Di-RutaD.codref, 'x(3)') + '|' +
                        STRING(Di-RutaD.nroref, 'x(12)') + '|' +
                        STRING(Di-RutaD.horest, 'x(5)').
RELEASE LogTabla.
