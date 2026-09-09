TRIGGER PROCEDURE FOR DELETE OF Di-RutaC.

DEF SHARED VAR s-user-id AS CHAR.

CREATE LogTabla.
ASSIGN
    logtabla.codcia = Di-RutaC.codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'DELETE'
    logtabla.Hora = STRING(TIME, 'HH:MM')
    logtabla.Tabla = 'Di-RutaC'
    logtabla.Usuario = s-user-id
    logtabla.ValorLlave = STRING(Di-RutaC.coddiv, 'x(5)') + '|' +
                        STRING(Di-RutaC.coddoc, 'x(3)') + '|' +
                        STRING(Di-RutaC.nrodoc, 'x(12)').
RELEASE LogTabla.
