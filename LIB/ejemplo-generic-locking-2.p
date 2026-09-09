DEF VAR s-codcia AS INTE INIT 001.
DEF VAR s-nroser AS INTE INIT 369.

DEF VAR pMensaje AS CHAR NO-UNDO.

RUN Grabacion (OUTPUT pMensaje).
MESSAGE 'Valor de retorno >>>' RETURN-VALUE.
IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    MESSAGE "Mensaje de error >>>" pMensaje VIEW-AS ALERT-BOX ERROR.
END.

RETURN.

PROCEDURE Grabacion:

    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        {lib/generic-locking.i ~
            &TableName="Faccorre" ~
            &VarScope="FIRST" ~
            &Condition="Faccorre.codcia = 3 AND Faccorre.coddoc = 'BD' ~
            AND Faccorre.flgest = YES" ~
            &VarMessage="pMensaje" ~
            &TypeLocking="EXCLUSIVE-LOCK NO-WAIT" ~
            }
        /* El control del error es a través de "pMensaje" */
        IF pMensaje > '' THEN RETURN "ADM-ERROR".

        UPDATE Faccorre.correlativo.
        RELEASE Faccorre.
    END.

END PROCEDURE.
