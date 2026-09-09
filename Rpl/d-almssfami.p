TRIGGER PROCEDURE FOR REPLICATION-DELETE OF almssfami.

    {rpl/reptrig.i
    &Table  = almssfami
    &Key    =  "string(almssfami.codcia,'999') + string(almssfami.codfam,'x(3)') + ~
    string(almssfami.subfam,'x(3)') + string(AlmSSFami.CodSSFam,'x(3)')"
    &Prg    = r-almssfami
    &Event  = DELETE
    &FlgDB0 = TRUE  /* Replicar de la sede remota a la base principal */
    &FlgDB1 = NO    /* Plaza Lima Norte 00501 */
    &FlgDB2 = NO    /* Surquillo 00023 */
    &FlgDB3 = NO    /* Chorrillos 00027 */
    &FlgDB4 = NO    /* San Borja 00502 */
    &FlgDB5 = NO    /* La Molina 00503 */
    &FlgDB6 = NO    /* Beneficiencia 00504 */
    &FlgDB7 = NO    /* Plaza Norte 00505 */
    &FlgDB8 = NO    /* La Rambla 00507 */
    &FlgDB9 = NO    /* San Isidro 00508 */
    &FlgDB10 = NO  /* 00065 */
    &FlgDB11 = NO   /* Atocongo 00510 */
    &FlgDB12 = NO   /* Angamos 00511 */
    &FlgDB13 = NO   /* Salaverry 00512 */
    &FlgDB14 = NO   /* Centro Civico 00513 */
    &FlgDB15 = NO   /* Primavera 00514 */
    &FlgDB16 = NO   /* Bellavista 00516 */
    &FlgDB17 = NO
    &FlgDB18 = NO   /* AREQUIPA */
    &FlgDB19 = NO   /* TRUJILLO */
    &FlgDB20 = NO   /* SERVIDOR CENTRAL */
    &FlgDB30 = NO   /* SERVIDOR ATE */
    }
    
