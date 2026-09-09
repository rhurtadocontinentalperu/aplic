TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gn-clied.

    {rpl/reptrig.i
    &Table  = gn-clied
    &Key    =  "string(gn-clied.codcia,'999') + string(gn-clied.codcli, 'x(11)') + string(gn-clied.sede)"
    &Prg    = r-gn-clied
    &Event  = WRITE
    &FlgDb0 = NO    /* Replicar sede remota a la base principal */
    &FlgDB1 = YES    /* Replicar a la División 00501 (Plaza Norte) */
    &FlgDB2 = YES    /* Replicar a la División 00023 (Surquillo) */
    &FlgDB3 = YES
    &FlgDB4 = YES
    &FlgDB5 = YES
    &FlgDB6 = YES
    &FlgDB7 = YES
    &FlgDB8 = YES    /* La Rambla 00507 */
    &FlgDB9 = YES    /* San Isidro 00508 */
    &FlgDB10 = YES   /* 00065 */
    &FlgDB11 = YES   /* Atocongo 00510 */
    &FlgDB12 = YES   /* Angamos 00511 */
    &FlgDB13 = YES   /* Salaverry 00512 */
    &FlgDB14 = YES   /* Centro Civico 00513 */
    &FlgDB15 = YES   /* Primavera 00514 */
    &FlgDB16 = YES   /* Bellavista 00516 */
    &FlgDB17 = YES
    &FlgDB18 = YES   /* AREQUIPA */
    &FlgDB19 = NO       /* EXPOLIBRERIA */
    &FlgDB20 = NO   /* SERVIDOR CENTRAL */
    &FlgDB30 = NO   /* SERVIDOR DESARROLLO */
    }
