TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gn-prov.

/*                                                                                 */
/*     {rpl/reptrig.i                                                              */
/*     &Table  = gn-prov                                                           */
/*     &Key    =  "string(gn-prov.codcia,'999') + string(gn-prov.codpro, 'x(11)')" */
/*     &Prg    = r-gn-prov                                                         */
/*     &Event  = WRITE                                                             */
/*     &FlgDB0 = TRUE  /* Replicar de la sede remota a la base principal */        */
/*     &FlgDB1 = NO    /* Replicar a la División 00501 (Plaza Norte) */            */
/*     &FlgDB2 = NO    /* Replicar a la División 00023 (Surquillo) */              */
/*     &FlgDB3 = NO                                                                */
/*     &FlgDB4 = NO                                                                */
/*     &FlgDB5 = NO                                                                */
/*     &FlgDB6 = NO                                                                */
/*     &FlgDB7 = NO                                                                */
/*     &FlgDB8 = NO                                                                */
/*     &FlgDB9 = NO    /* San Isidro 00508 */                                      */
/*     &FlgDB10 = NO   /* 00065 */                                                 */
/*     &FlgDB11 = NO   /* Trujillo 00067 */                                        */
/*     &FlgDB12 = NO   /* Angamos 00511 */                                         */
/*     &FlgDB13 = NO   /* Salaverry 00512 */                                       */
/*     &FlgDB14 = NO   /* Centro Civico 00513 */                                   */
/*     &FlgDB15 = NO   /* Primavera 00514 */                                       */
/*     &FlgDB16 = NO   /* Bellavista 00516 */                                      */
/*     &FlgDB17 = TRUE                                                             */
/*     &FlgDB18 = NO   /* AREQUIPA */                                              */
/*     &FlgDB19 = NO   /* TRUJILLO */                                              */
/*     &FlgDB20 = NO   /* SERVIDOR CENTRAL */                                      */
/*     &FlgDB30 = NO   /* SERVIDOR ATE */                                          */
/*     }                                                                           */
/*                                                                                 */
