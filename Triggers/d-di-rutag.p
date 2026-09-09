TRIGGER PROCEDURE FOR DELETE OF Di-RutaG.

DEF SHARED VAR s-user-id AS CHAR.

/* RHC 20.05.2011 buscamos en el control documentario */
/*
FIND LAST CntDocum USE-INDEX Llave02 WHERE CntDocum.codcia = di-rutag.codcia
    AND CntDocum.coddoc = "G/R"
    AND CntDocum.nrodoc = STRING (DI-RutaG.SerRef, '999') + STRING (DI-RutaG.NroRef, '999999')
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
    logtabla.codcia = Di-RutaG.codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'DELETE'
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
