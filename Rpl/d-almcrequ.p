TRIGGER PROCEDURE FOR REPLICATION-DELETE OF almcrequ.
/*
    {rpl/reptrig.i
    &Table  = almcrequ
    &Key    =  "string(almcrequ.codcia,'999') + string(almcrequ.codalm,'x(3)') + 
    string(almcrequ.nroser, '999') + string(almcrequ.nrodoc, '999999')"
    &Prg    = r-almcrequ
    &Event  = DELETE}
*/
