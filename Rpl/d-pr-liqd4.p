TRIGGER PROCEDURE FOR REPLICATION-DELETE OF pr-liqd4.

/*     {rpl/reptrig.i                                                                 */
/*     &Table  = pr-liqd4                                                             */
/*     &Key    =  "string(pr-liqd4.codcia,'999') + string(pr-liqd4.numliq,'x(6)') + ~ */
/*     string(pr-liqd4.codmat, 'x(6)') + string(pr-liqd4.numord, 'x(6)')"             */
/*     &Prg    = r-pr-liqd4                                                           */
/*     &Event  = DELETE}                                                              */
/*                                                                                    */
