TRIGGER PROCEDURE FOR WRITE OF Gn-Prov.

IF NEW gn-prov THEN DO:
    /* RHC 31/10/18 Se crea un registro en gn-clied automaticamente */
    CREATE gn-provd.
    BUFFER-COPY gn-prov TO gn-provd
        ASSIGN 
        Gn-ProvD.DomFiscal = YES
        Gn-ProvD.Sede = "@@@"   /* Valor que no se puede anular */
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DELETE gn-provd.
END.

/* RHC 04/03/2019 Log General */
/* DEF VAR pEvento AS CHAR NO-UNDO.                                          */
/* IF NEW gn-prov THEN DO:                                                   */
/*     pEvento = "CREATE".                                                   */
/* END.                                                                      */
/* ELSE DO:                                                                  */
/*     pEvento = "WRITE".                                                    */
/* END.                                                                      */
/* {TRIGGERS/i-logtransactions.i &TableName="gn-prov" &TipoEvento="pEvento"} */
