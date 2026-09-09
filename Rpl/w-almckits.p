TRIGGER PROCEDURE FOR REPLICATION-WRITE OF almckits.

    /* Revisa tambie qoocostos.p */

    {rpl/reptrig.i
    &Table  = almckits
    &Key    = "string(almckits.codcia,'999') + almckits.codmat"
    &Prg    = r-almckits
    &Event  = WRITE
    &FlgDB0 = YES          /* Replicas: Sede Remota -> Sede Principal */
    &FlgDB1 = NO    /* Plaza Lima Norte 00501 */
    &FlgDB2 = NO    /* Surquillo 00023 */
    &FlgDB3 = NO    /* Chorrillos 00027 */
    &FlgDB4 = NO    /* San Borja 00502 */
    &FlgDB5 = NO    /* La Molina 00503 */
    &FlgDB6 = NO    /* Beneficiencia 00504 */
    &FlgDB7 = NO    /* Feria Plaza Norte 00505 */
    &FlgDB8 = NO    /* La Rambla 00507 */
    &FlgDB9 = NO    /* San Isidro 00508 */
    &FlgDB10 = NO   /* Chiclayo 00065 */
    &FlgDB11 = NO   /* Atocongo 00510 */
    &FlgDB12 = NO   /* Angamos 00511 */
    &FlgDB13 = NO   /* Salaverry 00512 */
    &FlgDB14 = NO   /* Centro Civico 00513 */
    &FlgDB15 = NO   /* Primavera 00514 */
    &FlgDB16 = NO   /* Bellavista 00516 */
    &FlgDB17 = TRUE
    &FlgDB18 = NO   /* AREQUIPA */
    &FlgDB19 = NO   /* TRUJILLO */
    &FlgDB20 = NO   /* SERVIDOR CENTRAL */
    &FlgDB30 = NO   /* SERVIDOR ATE */
    }
    
