TRIGGER PROCEDURE FOR REPLICATION-DELETE OF lg-docmp.
/*
    {rpl/reptrig.i
    &Table  = lg-docmp
    &Key    =  "string(lg-docmp.codcia,'999') + string(lg-docmp.coddiv,'x(5)') + ~
    string(lg-docmp.tpodoc,'x(1)') + string(lg-docmp.nrodoc, '999999') + ~
    string(lg-docmp.tpobien, '9') + string(lg-docmp.codmat, 'x(6)')"
    &Prg    = r-lg-docmp
    &Event  = DELETE}
*/
