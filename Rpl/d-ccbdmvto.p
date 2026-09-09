TRIGGER PROCEDURE FOR REPLICATION-DELETE OF ccbdmvto.
/*
    {rpl/reptrig.i
    &Table  = ccbdmvto
    &Key    = "string(ccbdmvto.codcia,'999') + string(ccbdmvto.coddoc,'x(3)') + ~
        string(ccbdmvto.nrodoc,'x(15)') + string(ccbdmvto.codref,'x(3)') + ~
        ccbdmvto.nroref"
    &Prg    = r-ccbdmvto
    &Event  = DELETE
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
