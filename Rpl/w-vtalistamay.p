TRIGGER PROCEDURE FOR REPLICATION-WRITE OF vtalistamay.
/* Revisa tambien qoocostos.p */
    {rpl/reptrig.i
    &Table  = vtalistamay
    &Key    =  "string(vtalistamay.codcia,'999') + string(vtalistamay.coddiv, 'x(5)') + string(vtalistamay.codmat,'x(6)')"
    &Prg    = r-vtalistamay
    &Event  = WRITE
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
    &FlgDB10 = NO   /* 00065 */
    &FlgDB11 = NO   /* Atocongo 00510 */
    &FlgDB12 = NO   /* Angamos 00511 */
    &FlgDB13 = NO   /* Salaverry 00512 */
    &FlgDB14 = NO   /* Centro Civico 00513 */
    &FlgDB15 = NO   /* Primavera 00514 */
    &FlgDB16 = TRUE
    &FlgDB17 = TRUE
    &FlgDB18 = NO   /* Jesus Obrero 00005 */
    &FlgDB19 = NO       /* EXPOLIBRERIA */
    &FlgDB20 = NO   /* SERVIDOR CENTRAL */
    &FlgDB30 = NO   /* SERVIDOR ATE */
    }
    
