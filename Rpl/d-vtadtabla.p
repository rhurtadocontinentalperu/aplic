TRIGGER PROCEDURE FOR REPLICATION-DELETE OF VtaDTabla.
/*
/* 09/02/2018 Se activó de las sedes remotas a ATE 
    para actualizar los CUPUTX de 48h de vigencia */

    {rpl/reptrig.i
    &Table  = VtaDTabla
    &Key    =  "string(VtaDTabla.codcia,'999') + ~
        string(VtaDTabla.tabla,'x(20)') + ~
        string(VtaDTabla.llave,'x(20)') + ~
        string(VtaDTabla.tipo,'x(20)') +  ~
        string(VtaDTabla.llavedetalle,'x(20)') + ~
        string(VtaDTabla.Libre_c01,'x(100)')"
    &Prg    = r-VtaDTabla
    &Event  = DELETE
    &FlgDB0 = NO  /* Replicar de la sede remota a la base principal */
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
    &FlgDB16 = NO   /* Bellavista 00516 */
    &FlgDB17 = NO
    &FlgDB18 = NO   /* AREQUIPA */
    &FlgDB19 = NO       /* EXPOLIBRERIA */
    &FlgDB20 = NO   /* SERVIDOR CENTRAL */
    &FlgDB30 = NO   /* SERVIDOR ATE */
    }
    
*/
