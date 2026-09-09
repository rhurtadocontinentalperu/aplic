TRIGGER PROCEDURE FOR REPLICATION-WRITE OF invconteo.
/*
    {rpl/reptrig.i
    &Table  = invconteo
    &Key    =  "string(invconteo.codcia,'999') + string(invconteo.codalm,'x(3)') + ~
    string(invconteo.fchinv,'99/99/99') + string(invconteo.codmat,'x(6)')"
    &Prg    = r-invconteo
    &Event  = WRITE}
*/
