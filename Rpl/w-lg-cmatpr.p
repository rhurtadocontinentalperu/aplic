TRIGGER PROCEDURE FOR REPLICATION-WRITE OF lg-cmatpr.
/*
    {rpl/reptrig.i
    &Table  = lg-cmatpr
    &Key    =  "string(lg-cmatpr.codcia,'999') + string(lg-cmatpr.nrolis,'999999') + ~
    string(lg-cmatpr.codpro,'x(11)')"
    &Prg    = r-lg-cmatpr
    &Event  = WRITE}
*/
