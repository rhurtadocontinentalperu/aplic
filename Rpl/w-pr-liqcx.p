TRIGGER PROCEDURE FOR REPLICATION-WRITE OF pr-liqcx.

/*     {rpl/reptrig.i                                                                 */
/*     &Table  = pr-liqcx                                                             */
/*     &Key    =  "string(pr-liqcx.codcia,'999') + string(pr-liqcx.numliq,'x(6)') + ~ */
/*     string(pr-liqcx.codart, 'x(6)')"                                               */
/*     &Prg    = r-pr-liqcx                                                           */
/*     &Event  = WRITE}                                                               */
