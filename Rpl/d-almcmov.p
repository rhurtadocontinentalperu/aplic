TRIGGER PROCEDURE FOR REPLICATION-DELETE OF almcmov.
/*
/* CODMOV = 09 INGRESOS POR DEVOLUCION DE MERCADERIA */
FIND almacen WHERE almacen.codcia = almcmov.codcia
    AND almacen.codalm = almcmov.codalm NO-LOCK NO-ERROR.
IF AVAILABLE almacen THEN DO:
    {rpl/reptrig.i
    &Table  = almcmov
    &Key    = "STRING(almcmov.codcia,'999') + string(almcmov.CodAlm,'x(5)') + ~
        string(almcmov.TipMov,'x(1)') + STRING(almcmov.CodMov,'99') + ~
        STRING(almcmov.NroSer,'999') + STRING(almcmov.NroDoc)"
    &Prg    = r-almcmov
    &Event  = DELETE
    &FlgDB0 = NO
    &FlgDB1 = TRUE
    &FlgDB2 = TRUE
    &FlgDB3 = TRUE
    &FlgDB4 = TRUE
    &FlgDB5 = TRUE
    &FlgDB6 = TRUE
    &FlgDB7 = TRUE
    &FlgDB8 = TRUE
    &FlgDB9 = TRUE
    &FlgDB10 = "NOT ( almcmov.tipmov = 'I' AND almcmov.codmov = 09 AND LOOKUP(almacen.coddiv,'00065') > 0 )"
    &FlgDB11 = TRUE
    &FlgDB12 = TRUE
    &FlgDB13 = TRUE
    &FlgDB14 = TRUE
    &FlgDB15 = TRUE
    &FlgDB16 = TRUE
    &FlgDB17 = TRUE
    &FlgDB18 = "NOT LOOKUP(almacen.coddiv,'00060,00061,00062,00063,10060') > 0"     /* AREQUIPA */
    &FlgDB19 = "NOT LOOKUP(almacen.coddiv,'00069') > 0"   /* TRUJILLO */
    &FlgDB20 = TRUE   /* SERVIDOR CENTRAL */
    &FlgDB30 = TRUE
    }
END.

*/
