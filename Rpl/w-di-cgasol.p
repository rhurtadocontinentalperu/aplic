TRIGGER PROCEDURE FOR REPLICATION-WRITE OF di-cgasol.
/*
    {rpl/reptrig.i
    &Table  = di-cgasol
    &Key    =  "string(di-cgasol.codcia,'999') + string(di-cgasol.coddiv,'x(5)') + string(di-cgasol.fecha,'99/99/99') + string(di-cgasol.placa,'x(10)')"
    &Prg    = r-di-cgasol
    &Event  = WRITE}
*/
