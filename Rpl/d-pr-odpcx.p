TRIGGER PROCEDURE FOR REPLICATION-DELETE OF pr-odpcx.

/*     {rpl/reptrig.i                                                                 */
/*     &Table  = pr-odpcx                                                             */
/*     &Key    =  "string(pr-odpcx.codcia,'999') + string(pr-odpcx.numord,'x(6)') + ~ */
/*     string(pr-odpcx.codart, 'x(6)')"                                               */
/*     &Prg    = r-pr-odpcx                                                           */
/*     &Event  = DELETE}                                                              */
/*                                                                                    */
