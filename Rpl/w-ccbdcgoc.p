TRIGGER PROCEDURE FOR REPLICATION-WRITE OF ccbdcgoc.
/*
    {rpl/reptrig.i
    &Table  = ccbdcgoc
    &Key    =  "string(ccbdcgoc.codcia,'999') + string(ccbdcgoc.coddiv,'x(5)') + ~
        string(ccbdcgoc.coddoc,'x(3)') + string(ccbdcgoc.nrodoc,'x(15)') + ~
        string(ccbdcgoc.codref,'x(3)') + string(ccbdcgoc.nroref,'x(15)')"
    &Prg    = r-ccbdcgoc
    &Event  = WRITE}
*/
