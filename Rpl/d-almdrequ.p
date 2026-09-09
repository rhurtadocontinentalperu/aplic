TRIGGER PROCEDURE FOR REPLICATION-DELETE OF almdrequ.
/*
    {rpl/reptrig.i
    &Table  = almdrequ
    &Key    =  "string(almdrequ.codcia,'999') + string(almdrequ.codalm,'x(3)') + ~
        string(almdrequ.nroser, '999') + string(almdrequ.nrodoc, '999999') + ~
        string(almdrequ.codmat, 'x(6)')"
    &Prg    = r-almdrequ
    &Event  = DELETE}
*/
