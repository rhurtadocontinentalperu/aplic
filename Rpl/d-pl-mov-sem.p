TRIGGER PROCEDURE FOR REPLICATION-DELETE OF pl-mov-sem.
/*
    {rpl/reptrig.i
    &Table  = pl-mov-sem
    &Key    =  "string(pl-mov-sem.codcia,'999') + string(pl-mov-sem.periodo,'9999') + ~
    string(pl-mov-sem.nrosem,'99') + string(pl-mov-sem.codpln,'99') + ~
    string(pl-mov-sem.codcal, '999') + string(pl-mov-sem.codper, 'x(6)') + ~
    string(pl-mov-sem.codmov, '999')"
    &Prg    = r-pl-mov-sem
    &Event  = DELETE}
*/
