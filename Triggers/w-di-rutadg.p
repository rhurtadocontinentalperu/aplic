TRIGGER PROCEDURE FOR WRITE OF Di-RutaDG.

DEF SHARED VAR s-user-id AS CHAR.

/* RHC 21.05.2011 Control de retorno de documentos */
/*
IF Di-RutaDG.FlgEst = "N" OR Di-RutaDG.FlgEst = "NR" OR Di-RutaDG.FlgEst = "R" THEN DO:
    FIND LAST Cntdocum USE-INDEX Llave02 WHERE Cntdocum.codcia = DI-RutaDG.CodCia
        AND Cntdocum.coddoc = DI-RutaDG.CodRef
        AND Cntdocum.nrodoc = DI-RutaDG.NroRef
        AND Cntdocum.flgest <> 'A'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Cntdocum OR Cntdocum.tipmov <> "I" THEN DO:
        MESSAGE 'El documento NO está registrado en el control documentario'
            VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
END.
/* RHC 24.05.2011 Control de entrega de documentos */
IF Di-RutaDG.FlgEst = "C" THEN DO:
    FIND LAST Cntdocum USE-INDEX Llave02 WHERE Cntdocum.codcia = DI-RutaDG.CodCia
        AND Cntdocum.coddoc = DI-RutaDG.CodRef
        AND Cntdocum.nrodoc = DI-RutaDG.NroRef
        AND Cntdocum.flgest <> 'A'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Cntdocum OR Cntdocum.tipmov <> "S" THEN DO:
        MESSAGE 'El documento NO está registrado en el control documentario'
            VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
END.
*/

CREATE LogTabla.
ASSIGN
    logtabla.codcia = Di-RutaDG.codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'WRITE'
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
