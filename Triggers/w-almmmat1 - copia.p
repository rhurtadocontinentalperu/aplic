TRIGGER PROCEDURE FOR WRITE OF almmmat1 OLD BUFFER Oldalmmmat1.

DEFINE SHARED VAR s-user-id AS CHAR.

/* RHC 30.01.2013 AGREGAMOS LOG DE CONTROL PARA OPENORANGE */
/* AGREGAMOS CONTROL PARA EL SPEED */
FIND Almmmatg OF Almmmat1 EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
IF AVAILABLE Almmmatg THEN Almmmatg.Libre_d05 = 1.
IF AVAILABLE(Almmmatg) THEN RELEASE Almmmatg.

IF Oldalmmmat1.codmat <> '' THEN DO:
    IF almmmat1.Barras[1] <> Oldalmmmat1.Barras[1]
        OR almmmat1.Barras[2] <> Oldalmmmat1.Barras[2]
        OR almmmat1.Barras[3] <> Oldalmmmat1.Barras[3]
        OR almmmat1.Equival[1] <> Oldalmmmat1.Equival[1]
        OR almmmat1.Equival[2] <> Oldalmmmat1.Equival[2]
        OR almmmat1.Equival[3] <> Oldalmmmat1.Equival[3]
        THEN DO:
/*         CREATE OpenPrecios.                                    */
/*         ASSIGN                                                 */
/*             OpenPrecios.CodCia = almmmat1.codcia               */
/*             OpenPrecios.CodMat = almmmat1.codmat               */
/*             OpenPrecios.LogDate = TODAY                        */
/*             OpenPrecios.LogTime = STRING(TIME, 'HH:MM:SS')     */
/*             OpenPrecios.LogUser = s-user-id                    */
/*             OpenPrecios.FlagFechaHora = DATETIME(TODAY, MTIME) */
/*             OpenPrecios.FlagUsuario = s-user-id                */
/*             OpenPrecios.flagestado = "U".                      */
    END.
END.
ELSE DO:
/*     CREATE OpenPrecios.                                    */
/*     ASSIGN                                                 */
/*         OpenPrecios.CodCia = almmmat1.codcia               */
/*         OpenPrecios.CodMat = almmmat1.codmat               */
/*         OpenPrecios.LogDate = TODAY                        */
/*         OpenPrecios.LogTime = STRING(TIME, 'HH:MM:SS')     */
/*         OpenPrecios.LogUser = s-user-id                    */
/*         OpenPrecios.FlagFechaHora = DATETIME(TODAY, MTIME) */
/*         OpenPrecios.FlagUsuario = s-user-id                */
/*         OpenPrecios.flagestado = "I".                      */
END.
