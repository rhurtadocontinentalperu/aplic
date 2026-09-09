TRIGGER PROCEDURE FOR REPLICATION-DELETE OF lg-cocmp.
/*
    {rpl/reptrig.i
    &Table  = lg-cocmp
    &Key    =  "string(lg-cocmp.codcia,'999') + string(lg-cocmp.coddiv,'x(5)') + ~
    string(lg-cocmp.tpodoc,'x(1)') + string(lg-cocmp.nrodoc, '999999')"
    &Prg    = r-lg-cocmp
    &Event  = DELETE}
*/
