TRIGGER PROCEDURE FOR REPLICATION-WRITE OF di-rutag.
/*
    {rpl/reptrig.i
    &Table  = di-rutag
    &Key    = "string(di-rutag.codcia,'999') + string(di-rutag.coddiv, 'x(5)') ~
        + string(di-rutag.coddoc, 'x(3)') + string(di-rutag.nrodoc, 'x(15)') ~
        + string(di-rutag.codalm, 'x(5)') + string(di-rutag.serref, '999') + string(di-rutag.nroref)"
        "
    &Prg    = r-di-rutag
    &Event  = WRITE
    &FlgDB0 = NO
    &FlgDB1 = TRUE
    &FlgDB2 = TRUE
    &FlgDB3 = TRUE
    &FlgDB4 = TRUE
    &FlgDB5 = TRUE
    &FlgDB6 = TRUE
    &FlgDB7 = TRUE
    &FlgDB8 = TRUE
    &FlgDB9 = TRUE
    &FlgDB10 = TRUE
    &FlgDB11 = TRUE
    &FlgDB12 = TRUE
    &FlgDB13 = TRUE
    &FlgDB14 = TRUE
    &FlgDB15 = TRUE
    &FlgDB16 = TRUE
    &FlgDB17 = TRUE
    &FlgDB18 = TRUE
    &FlgDB19 = TRUE
    &FlgDB20 = TRUE
    &FlgDB30 = TRUE
    }
*/
