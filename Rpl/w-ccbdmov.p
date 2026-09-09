TRIGGER PROCEDURE FOR REPLICATION-WRITE OF ccbdmov.
/*
    /* De las tiendas a la base principal */
    {rpl/reptrig.i
    &Table  = ccbdmov
    &Key    =  "string(ccbdmov.codcia,'999') + string(ccbdmov.coddoc,'x(3)') + ~
        string(ccbdmov.nrodoc,'x(15)') + string(ccbdmov.codref,'x(3)') + ~
        string(ccbdmov.nroref,'x(15)')"
    &Prg    = r-ccbdmov
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
    &FlgDB30 = TRUE   /* SERVIDOR ATE */
    }
*/
