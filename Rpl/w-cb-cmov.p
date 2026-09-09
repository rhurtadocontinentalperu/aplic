TRIGGER PROCEDURE FOR REPLICATION-WRITE OF cb-cmov.
/*
    {rpl/reptrig.i
    &Table  = cb-cmov
    &Key    =  "string(cb-cmov.codcia,'999') + string(cb-cmov.periodo,'9999') + ~
        string(cb-cmov.nromes,'99') + string(cb-cmov.codope,'x(3)') + ~
        string(cb-cmov.nroast, 'x(6)')"
    &Prg    = r-cb-cmov
    &Event  = WRITE}
*/
