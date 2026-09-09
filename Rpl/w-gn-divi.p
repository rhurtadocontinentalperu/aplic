TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gn-divi.

    {rpl/reptrig.i
    &Table  = gn-divi
    &Key    =  "string(gn-divi.codcia,'999') + coddiv"
    &Prg    = r-gn-divi
    &Event  = WRITE
    &FlgDb0 = YES
    &FlgDB1 = NO    /* Replicar a la División 00501 (Plaza Norte) */
    &FlgDB2 = NO    /* Replicar a la División 00023 (Surquillo) */
    &FlgDB3 = NO
    &FlgDB4 = NO
    &FlgDB5 = NO
    &FlgDB6 = NO
    &FlgDB7 = NO
    &FlgDB8 = NO    /* La Rambla 00507 */
    &FlgDB9 = NO    /* San Isidro 00508 */
    &FlgDB10 = NO   /* 00065 */
    &FlgDB11 = NO   /* Atocongo 00510 */
    &FlgDB12 = NO   /* Angamos 00511 */
    &FlgDB13 = NO   /* Salaverry 00512 */
    &FlgDB14 = NO   /* Centro Civico 00513 */
    &FlgDB15 = NO   /* Primavera 00514 */
    &FlgDB16 = NO   /* Bellavista 00516 */
    &FlgDB17 = NO
    &FlgDB18 = NO   /* AREQUIPA */
    &FlgDB19 = NO       /* EXPOLIBRERIA */
    &FlgDB20 = NO   /* SERVIDOR CENTRAL */
    &FlgDB30 = NO   /* SERVIDOR ATE */
    }
