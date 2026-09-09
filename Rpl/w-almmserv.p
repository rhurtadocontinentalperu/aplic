TRIGGER PROCEDURE FOR REPLICATION-WRITE OF almmserv.
/*
    {rpl/reptrig.i
    &Table  = almmserv
    &Key    =  "string(almmserv.codcia,'999') + string(almmserv.codmat,'x(6)')"
    &Prg    = r-almmserv
    &Event  = WRITE}
*/
