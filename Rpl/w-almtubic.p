TRIGGER PROCEDURE FOR REPLICATION-WRITE OF almtubic.

    {rpl/reptrig.i
    &Table  = almtubic
    &Key    =  "string(almtubic.codcia,'999') + string(almtubic.codalm,'x(5)') + almtubic.codubi"
    &Prg    = r-almtubic
    &Event  = WRITE
    &FlgDB0 = NO  /* Replicar de la sede remota a la base principal */
    &FlgDB1 = TRUE    /* Plaza Lima Norte 00501 */
    &FlgDB2 = TRUE    /* Surquillo 00023 */
    &FlgDB3 = TRUE    /* Chorrillos 00027 */
    &FlgDB4 = TRUE    /* San Borja 00502 */
    &FlgDB5 = TRUE    /* La Molina 00503 */
    &FlgDB6 = TRUE    /* Beneficiencia 00504 */
    &FlgDB7 = TRUE    /* Plaza Norte 00505 */
    &FlgDB8 = TRUE    /* La Rambla 00507 */
    &FlgDB9 = TRUE    /* San Isidro 00508 */
    &FlgDB10 = TRUE  /* 00065 */
    &FlgDB11 = TRUE   /* Atocongo 00510 */
    &FlgDB12 = TRUE   /* Angamos  00511 */
    &FlgDB13 = TRUE   /* Salaverry 00512 */
    &FlgDB14 = TRUE   /* Centro Civico 00513 */
    &FlgDB15 = TRUE   /* Primavera 00514 */
    &FlgDB16 = TRUE   /* Bellavista 00516 */
    &FlgDB17 = TRUE
    &FlgDB18 = TRUE   /* AREQUIPA */
    &FlgDB19 = TRUE   /* TRUJILLO */
    &FlgDB20 = NO   /* SERVIDOR CENTRAL UTILEX */
    &FlgDB30 = NO   /* SERVIDOR ATE */
    }
    
