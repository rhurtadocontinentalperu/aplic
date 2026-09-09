TRIGGER PROCEDURE FOR REPLICATION-DELETE OF vtalistamin.

    {rpl/reptrig.i
    &Table  = vtalistamin
    &Key    =  "string(vtalistamin.codcia,'999') + ~
            string(vtalistamin.coddiv,'x(5)') +
            STRING(vtalistamin.codmat, 'x(6)')"
    &Prg    = r-vtalistamin
    &Event  = DELETE
    &FlgDB0 = TRUE  /* Replicar de la sede remota a la base principal */
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
    
