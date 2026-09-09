TRIGGER PROCEDURE FOR WRITE OF Di-RutaG.

DEF SHARED VAR s-user-id AS CHAR.

/* RHC 21.05.2011 Control de retorno de documentos */
/*
IF Di-RutaG.FlgEst = "N" THEN DO:
    FIND LAST Cntdocum USE-INDEX Llave02 WHERE Cntdocum.codcia = DI-RutaG.CodCia
        AND Cntdocum.coddoc = "G/R"
        AND Cntdocum.nrodoc = STRING (DI-RutaG.SerRef, '999') + STRING (DI-RutaG.NroRef, '999999')
        AND Cntdocum.flgest <> 'A'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Cntdocum OR Cntdocum.tipmov <> "I" THEN DO:
        MESSAGE 'El documento NO está registrado en el control documentario'
            VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
END.
/* RHC 21.05.2011 Control de retorno de documentos */
IF Di-RutaG.FlgEst = "C" THEN DO:
    FIND LAST Cntdocum USE-INDEX Llave02 WHERE Cntdocum.codcia = DI-RutaG.CodCia
        AND Cntdocum.coddoc = "G/R"
        AND Cntdocum.nrodoc = STRING (DI-RutaG.SerRef, '999') + STRING (DI-RutaG.NroRef, '999999')
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
    logtabla.codcia = Di-RutaG.codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'WRITE'
    logtabla.Hora = STRING(TIME, 'HH:MM')
    logtabla.Tabla = 'Di-RutaG'
    logtabla.Usuario = s-user-id
    logtabla.ValorLlave = STRING(Di-RutaG.coddiv, 'x(5)') + '|' +
                        STRING(Di-RutaG.coddoc, 'x(3)') + '|' +
                        STRING(Di-RutaG.nrodoc, 'x(12)') + '|' +
                        STRING(Di-RutaG.TipMov, 'x') + '|' +
                        STRING(Di-RutaG.CodMov, '99') + '|' +
                        STRING(Di-RutaG.CodAlm, 'x(3)') + '|' +
                        STRING(Di-RutaG.serref, '999') + '|' +
                        STRING(Di-RutaG.nroref, '999999') + '|' +
                        STRING(Di-RutaG.horest, 'x(5)').
                    
        
RELEASE LogTabla.
