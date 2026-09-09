TRIGGER PROCEDURE FOR REPLICATION-DELETE OF VtaDctoPromMin.

/* 09/02/2018 Se activó de las sedes remotas a ATE 
    para actualizar los CUPUTX de 48h de vigencia */

    {rpl/reptrig.i
    &Table  = VtaDctoPromMin
    &Key    =  "STRING(VtaDctoPromMin.codcia,'999') + '|' + ~
                VtaDctoPromMin.codmat + '|' + ~
                VtaDctoPromMin.coddiv + '|' + ~
                STRING(VtaDctoPromMin.fchini) + '|' + ~
                STRING(VtaDctoPromMin.fchfin)"
    &Prg    = r-VtaDctoPromMin
    &Event  = DELETE
    &FlgDB0 = YES
    &FlgDB1 = YES
    &FlgDB2 = YES    /* Surquillo 00023 */
    &FlgDB3 = YES    /* Chorrillos 00027 */
    &FlgDB4 = YES    /* San Borja 00502 */
    &FlgDB5 = YES    /* La Molina 00503 */
    &FlgDB6 = YES    /* Beneficiencia 00504 */
    &FlgDB7 = YES    /* Plaza YESrte 00505 */
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
    &FlgDB19 = YES       /* EXPOLIBRERIA */
    &FlgDB20 = NO   /* SERVIDOR UTILEX */
    &FlgDB30 = YES   /* SERVIDOR ATE */
    }
    
