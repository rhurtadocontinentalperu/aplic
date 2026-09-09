TRIGGER PROCEDURE FOR REPLICATION-WRITE OF pr-rqprod.

/*     {rpl/reptrig.i                                                                   */
/*     &Table  = pr-rqprod                                                              */
/*     &Key    =  "string(pr-rqprod.codcia,'999') + string(pr-rqprod.codalm,'x(3)') + ~ */
/*     string(pr-rqprod.nroser, '999') + string(pr-rqprod.nrodoc, '999999') + ~         */
/*     string(pr-rqprod.codmat, 'x(6)')"                                                */
/*     &Prg    = r-pr-rqprod                                                            */
/*     &Event  = WRITE}                                                                 */
