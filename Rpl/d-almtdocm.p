TRIGGER PROCEDURE FOR REPLICATION-DELETE OF almtdocm.

    /*
    {rpl/reptrig.i
    &Table  = almtdocm
    &Key    =  "string(almtdocm.codcia,'999') + string(almtdocm.codalm,'x(3)') + ~
    string(almtdocm.tipmov,'x(1)') + string(almtdocm.codmov,'99')"
    &Prg    = r-almtdocm
    &Event  = DELETE}
*/
