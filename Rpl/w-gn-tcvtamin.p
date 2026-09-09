TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gn-tcvtamin.

    {rpl/reptrig.i
    &Table  = gn-tcvtamin
    &Key    =  "string(gn-tcvtamin.codcia, '999')" + 
                "string(gn-tcvtamin.fechaini, '99/99/99')"
    &Prg    = r-gn-tcvtamin
    &Event  = WRITE
    &FlgDB0 = TRUE
    &FlgDB1 = NO      /* Replicar a la División 00501 (Plaza Norte) */
    &FlgDB2 = NO    /* Replicar a la División 00023 (Surquillo) */
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
    }
