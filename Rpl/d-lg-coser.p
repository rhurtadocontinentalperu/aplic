TRIGGER PROCEDURE FOR REPLICATION-DELETE OF lg-coser.
/*
    {rpl/reptrig.i
    &Table  = lg-coser
    &Key    =  "string(lg-coser.codcia,'999') + string(lg-coser.coddoc,'x(3)') + ~
    string(lg-coser.nroser,'999') + string(lg-coser.nrodoc, '999999')"
    &Prg    = r-lg-coser
    &Event  = DELETE}
*/
