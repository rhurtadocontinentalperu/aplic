TRIGGER PROCEDURE FOR REPLICATION-DELETE OF lg-doser.
/*
    {rpl/reptrig.i
    &Table  = lg-doser
    &Key    =  "string(lg-doser.codcia,'999') + string(lg-doser.coddoc,'x(3)') + ~
    string(lg-doser.nroser,'999') + string(lg-doser.nrodoc, '999999') + ~
    string(lg-doser.codser, 'x(8)')"
    &Prg    = r-lg-doser
    &Event  = DELETE}
*/
