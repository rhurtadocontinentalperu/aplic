TRIGGER PROCEDURE FOR WRITE OF even_control_turno.

CREATE even_control_turno_log.
BUFFER-COPY even_control_turno TO even_control_turno_log.

IF NEW even_control_turno THEN DO:
    ASSIGN
        even_control_turno_log.LogEvento = "CREATE".
END.
ELSE DO:
    ASSIGN
        even_control_turno_log.LogEvento = "UPDATE".
END.
ASSIGN
    even_control_turno_log.LogFecha = TODAY
    even_control_turno_log.LogHora = STRING(TIME,'HH:MM:SS')
    .
/* MESSAGE even_control_turno_log.LogEvento */
/*     even_control_turno_log.BLOCK         */
/*     even_control_turno_log.codcli        */
/*     even_control_turno_log.estado        */
/*     VIEW-AS ALERT-BOX WARNING.           */
RELEASE even_control_turno_log.





