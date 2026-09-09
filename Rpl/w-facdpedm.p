TRIGGER PROCEDURE FOR REPLICATION-WRITE OF facdpedm.
/*
    {rpl/reptrig.i
    &Table  = facdpedm
    &Key    =  "string(facdpedm.codcia,'999') + string(facdpedm.coddoc,'x(3)') + string(facdpedm.nroped,'x(9)') + ~
    string(facdpedm.codmat, 'x(6)')"
    &Prg    = r-facdpedm
    &Event  = WRITE}
*/
