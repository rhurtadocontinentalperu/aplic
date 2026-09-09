TRIGGER PROCEDURE FOR REPLICATION-WRITE OF vtavales.


    {rpl/reptrig.i
    &Table  = vtavales
    &Key    = "string(vtavales.codcia,'999') + ~
        string(vtavales.nrodoc, 'x(15)')"
    &Prg    = r-vtavales
    &Event  = WRITE
    &FlgDB0 = FALSE
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
