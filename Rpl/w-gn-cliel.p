TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gn-cliel.
/*
    {rpl/reptrig.i
    &Table  = gn-cliel
    &Key    =  "string(gn-cliel.codcia,'999') + string(gn-cliel.codcli, 'x(11)') + ~
    string(gn-cliel.fchini, '99/99/99')"
    &Prg    = r-gn-cliel
    &Event  = WRITE}
*/
