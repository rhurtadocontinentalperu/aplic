TRIGGER PROCEDURE FOR REPLICATION-DELETE OF pr-liqd3.
/*
    {rpl/reptrig.i
    &Table  = pr-liqd3
    &Key    =  "string(pr-liqd3.codcia,'999') + string(pr-liqd3.numliq,'x(6)') + ~
    string(pr-liqd3.codgas, 'x(6)') + string(pr-liqd3.codpro, 'x(11)')"
    &Prg    = r-pr-liqd3
    &Event  = DELETE}
*/
