TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gn-clieb.
/*
    {rpl/reptrig.i
    &Table  = gn-clieb
    &Key    =  "string(gn-clieb.codcia,'999') + string(gn-clieb.codcli, 'x(11)') + ~
    string(gn-clieb.codbco, 'x(3)') + string(gn-clieb.nrocta, 'x(30)')"
    &Prg    = r-gn-clieb
    &Event  = WRITE}
*/
