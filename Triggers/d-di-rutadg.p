TRIGGER PROCEDURE FOR DELETE OF Di-RutaDG.

DEF SHARED VAR s-user-id AS CHAR.

/* RHC 20.05.2011 buscamos en el control documentario */
/*
FIND LAST CntDocum USE-INDEX Llave02 WHERE CntDocum.codcia = DI-RutaDG.CodCia
    AND CntDocum.coddoc = DI-RutaDG.CodRef
    AND CntDocum.nrodoc = DI-RutaDG.NroRef
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
    logtabla.codcia = Di-RutaDG.codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'DELETE'
    logtabla.Hora = STRING(TIME, 'HH:MM')
    logtabla.Tabla = 'Di-RutaDG'
    logtabla.Usuario = s-user-id
    logtabla.ValorLlave = STRING(Di-RutaDG.coddiv, 'x(5)') + '|' +
                        STRING(Di-RutaDG.coddoc, 'x(3)') + '|' +
                        STRING(Di-RutaDG.nrodoc, 'x(12)') + '|' +
                        STRING(Di-RutaDG.CodRef, 'x(3)') + '|' +
                        STRING(Di-RutaDG.nroref, 'x(9)') + '|' +
                        STRING(Di-RutaDG.horest, 'x(5)') + '|' +
                        STRING(Di-RutaDG.tipo, 'x').
RELEASE LogTabla.
