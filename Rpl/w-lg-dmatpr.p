TRIGGER PROCEDURE FOR REPLICATION-WRITE OF lg-dmatpr.
/*
    {rpl/reptrig.i
    &Table  = lg-dmatpr
    &Key    =  "string(lg-dmatpr.codcia,'999') + string(lg-dmatpr.nrolis,'999999') + ~
    string(lg-dmatpr.tpobien, '9') + string(lg-dmatpr.codpro,'x(11)') + ~
    string(lg-dmatpr.codmat, 'x(6)')"
    &Prg    = r-lg-dmatpr
    &Event  = WRITE}
*/
