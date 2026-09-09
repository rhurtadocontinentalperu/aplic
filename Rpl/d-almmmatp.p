TRIGGER PROCEDURE FOR REPLICATION-DELETE OF almmmatp.
/*
    {rpl/reptrig.i
    &Table  = almmmatp
    &Key    =  "string(almmmatp.codcia,'999') + string(almmmatp.codmat,'x(6)')"
    &Prg    = r-almmmatp
    &Event  = DELETE}
*/
