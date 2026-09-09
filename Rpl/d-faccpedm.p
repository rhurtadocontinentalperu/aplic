TRIGGER PROCEDURE FOR REPLICATION-DELETE OF faccpedm.
/*
    {rpl/reptrig.i
    &Table  = faccpedm
    &Key    =  "string(faccpedm.codcia,'999') + string(faccpedm.coddoc,'x(3)') + ~
    string(faccpedm.nroped,'x(9)')"
    &Prg    = r-faccpedm
    &Event  = DELETE}
*/
