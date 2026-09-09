TRIGGER PROCEDURE FOR REPLICATION-DELETE OF pl-flg-sem.
/*
    {rpl/reptrig.i
    &Table  = pl-flg-sem
    &Key    =  "string(pl-flg-sem.codcia,'999') + string(pl-flg-sem.periodo,'9999') + ~
    string(pl-flg-sem.codpln,'99') + string(pl-flg-sem.nrosem,'99') + ~
    string(pl-flg-sem.codper, 'x(6)')"
    &Prg    = r-pl-flg-sem
    &Event  = DELETE}
*/
