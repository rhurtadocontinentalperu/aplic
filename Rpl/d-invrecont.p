TRIGGER PROCEDURE FOR REPLICATION-DELETE OF invrecont.
/*
    {rpl/reptrig.i
    &Table  = invrecont
    &Key    =  "string(invrecont.codcia,'999') + string(invrecont.codalm,'x(3)') + ~
    string(invrecont.fchinv,'99/99/99') + string(invrecont.codmat,'x(6)')"
    &Prg    = r-invrecont
    &Event  = DELETE}
*/
