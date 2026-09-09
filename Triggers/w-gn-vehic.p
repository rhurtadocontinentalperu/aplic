TRIGGER PROCEDURE FOR WRITE OF gn-vehic.

/* RHC 04/03/2019 Log General */
DEF VAR pEvento AS CHAR NO-UNDO.
IF NEW gn-vehic THEN DO:
    pEvento = "CREATE".
END.
ELSE DO:
    pEvento = "WRITE".
END.
/*{TRIGGERS/i-logtransactions.i &TableName="gn-vehic" &TipoEvento="pEvento"}*/

