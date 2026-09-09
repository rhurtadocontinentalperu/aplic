TRIGGER PROCEDURE FOR REPLICATION-WRITE OF controlod.
/*
    {rpl/reptrig.i
    &Table  = controlod
    &Key    = "string(controlod.codcia,'999') + ~
        string(controlod.coddoc,'x(3)') + ~
        string(controlod.nrodoc,'x(12)') + ~
        controlod.nroetq"
    &Prg    = r-controlod
    &Event  = WRITE
    &FlgDB0 = NO          /* Replicas: Sede Remota -> Sede Principal */
    &FlgDB1 = TRUE    /* Plaza Lima TRUErte 00501 */
    &FlgDB2 = TRUE    /* Surquillo 00023 */
    &FlgDB3 = TRUE    /* Chorrillos 00027 */
    &FlgDB4 = TRUE    /* San Borja 00502 */
    &FlgDB5 = TRUE    /* La Molina 00503 */
    &FlgDB6 = TRUE    /* Beneficiencia 00504 */
    &FlgDB7 = TRUE    /* Feria Plaza TRUErte 00505 */
    &FlgDB8 = TRUE    /* La Rambla 00507 */
    &FlgDB9 = TRUE    /* San Isidro 00508 */
    &FlgDB10 = TRUE   /* Chiclayo 00065 */
    &FlgDB11 = TRUE   /* Atocongo 00510 */
    &FlgDB12 = TRUE   /* Angamos 00511 */
    &FlgDB13 = TRUE   /* Salaverry 00512 */
    &FlgDB14 = TRUE   /* Centro Civico 00513 */
    &FlgDB15 = TRUE   /* Primavera 00514 */
    &FlgDB16 = TRUE
    &FlgDB17 = TRUE
    &FlgDB18 = "NOT LOOKUP(controlod.coddiv,'00060,00061,00062,00063,10060') > 0"     /* AREQUIPA */
    &FlgDB19 = "(IF controlod.coddiv = '00069' THEN NO ELSE YES)"    /* TRUJILLO */
    &FlgDB20 = TRUE   /* SERVIDOR CENTRAL */
    &FlgDB30 = TRUE
    }
*/
