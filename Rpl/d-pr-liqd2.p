TRIGGER PROCEDURE FOR REPLICATION-DELETE OF pr-liqd2.

/*
    {rpl/reptrig.i
    &Table  = pr-liqd2
    &Key    =  "string(pr-liqd2.codcia,'999') + string(pr-liqd2.numliq,'x(6)') + ~
    string(pr-liqd2.codper, 'x(6)')"
    &Prg    = r-pr-liqd2
    &Event  = DELETE}
*/
