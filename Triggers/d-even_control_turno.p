TRIGGER PROCEDURE FOR DELETE OF even_control_turno.

CREATE even_control_turno_log.
BUFFER-COPY even_control_turno TO even_control_turno_log.

ASSIGN
    even_control_turno_log.LogEvento = "DELETE"
    even_control_turno_log.LogFecha = TODAY
    even_control_turno_log.LogHora = STRING(TIME,'HH:MM:SS')
    .
RELEASE even_control_turno_log.
