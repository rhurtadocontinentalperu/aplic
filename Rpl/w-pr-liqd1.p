TRIGGER PROCEDURE FOR REPLICATION-WRITE OF pr-liqd1.

/*     {rpl/reptrig.i                                                                 */
/*     &Table  = pr-liqd1                                                             */
/*     &Key    =  "string(pr-liqd1.codcia,'999') + string(pr-liqd1.numliq,'x(6)') + ~ */
/*     string(pr-liqd1.codmat, 'x(6)')"                                               */
/*     &Prg    = r-pr-liqd1                                                           */
/*     &Event  = WRITE}                                                               */
