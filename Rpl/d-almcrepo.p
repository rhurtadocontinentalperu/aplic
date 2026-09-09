TRIGGER PROCEDURE FOR REPLICATION-DELETE OF almcrepo.

/* DEF VAR lFlgDb30 AS LOG INIT YES NO-UNDO.                                      */
/*                                                                                */
/* lFlgDb30 = YES.                                                                */
/* FIND Almacen WHERE Almacen.CodCia = Almcrepo.CodCia                            */
/*     AND Almacen.CodAlm = Almcrepo.AlmPed                                       */
/*     NO-LOCK NO-ERROR.                                                          */
/* IF AVAILABLE Almacen THEN DO:                                                  */
/*     IF LOOKUP(Almacen.CodDiv,'00000') > 0 THEN lFlgDb30 = NO.                  */
/* END.                                                                           */
/*                                                                                */
/* {rpl/reptrig.i                                                                 */
/* &Table  = almcrepo                                                             */
/* &Key    = "string(almcrepo.codcia,'999') + string(almcrepo.codalm, 'x(5)') + ~ */
/*     string(almcrepo.tipmov,'x') + string(almcrepo.nroser, '999') + ~           */
/*     string(almcrepo.nrodoc)"                                                   */
/* &Prg    = r-almcrepo                                                           */
/* &Event  = DELETE                                                               */
/* &FlgDB0 = NO                                                                   */
/* &FlgDB1 = TRUE    /* Plaza Lima Norte 00501 */                                 */
/* &FlgDB2 = TRUE    /* Surquillo 00023 */                                        */
/* &FlgDB3 = TRUE    /* Chorrillos 00027 */                                       */
/* &FlgDB4 = TRUE    /* San Borja 00502 */                                        */
/* &FlgDB5 = TRUE    /* La Molina 00503 */                                        */
/* &FlgDB6 = TRUE    /* Beneficiencia 00504 */                                    */
/* &FlgDB7 = TRUE    /* Feria Plaza Norte 00505 */                                */
/* &FlgDB8 = TRUE    /* La Rambla 00507 */                                        */
/* &FlgDB9 = TRUE    /* San Isidro 00508 */                                       */
/* &FlgDB10 = TRUE   /* Chiclayo 00065 */                                         */
/* &FlgDB11 = TRUE   /* Atocongo 00510 */                                         */
/* &FlgDB12 = TRUE   /* Angamos 00511 */                                          */
/* &FlgDB13 = TRUE   /* Salaverry 00512 */                                        */
/* &FlgDB14 = TRUE   /* Centro Civico 00513 */                                    */
/* &FlgDB15 = TRUE   /* Primavera 00514 */                                        */
/* &FlgDB16 = TRUE                                                                */
/* &FlgDB17 = TRUE                                                                */
/* &FlgDB18 = TRUE   /* AREQUIPA */                                               */
/* &FlgDB19 = TRUE   /* TRUJILLO */                                               */
/* &FlgDB20 = TRUE   /* SERVIDOR CENTRAL */                                       */
/* &FlgDB30 = lFlgDb30     /* SERVIDOR ATE */                                     */
/* }                                                                              */
