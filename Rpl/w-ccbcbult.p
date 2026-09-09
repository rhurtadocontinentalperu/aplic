TRIGGER PROCEDURE FOR REPLICATION-WRITE OF ccbcbult.
/*
    {rpl/reptrig.i
    &Table  = ccbcbult
    &Key    = "string(ccbcbult.codcia,'999') + string(ccbcbult.coddiv, 'x(5)') ~
        + string(ccbcbult.coddoc, 'x(3)') + ccbcbult.nrodoc "
    &Prg    = r-ccbcbult
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
    &FlgDB18 = "NOT LOOKUP(ccbcbult.coddiv,'00060,00061,00062,00063,10060') > 0"     /* AREQUIPA */
    &FlgDB19 = "(IF ccbcbult.coddiv = '00069' THEN NO ELSE YES)"    /* TRUJILLO */
    &FlgDB20 = TRUE
    &FlgDB30 = TRUE
    }
*/
