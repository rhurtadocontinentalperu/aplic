TRIGGER PROCEDURE FOR REPLICATION-WRITE OF lg-corr.
/*
    {rpl/reptrig.i
    &Table  = lg-corr
    &Key    =  "string(lg-corr.codcia,'999') + string(lg-corr.coddoc,'x(3)') + ~
    string(lg-corr.coddiv,'x(5)')"
    &Prg    = r-lg-corr
    &Event  = WRITE}
*/
