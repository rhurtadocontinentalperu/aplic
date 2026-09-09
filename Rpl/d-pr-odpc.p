TRIGGER PROCEDURE FOR REPLICATION-DELETE OF pr-odpc.

/*     {rpl/reptrig.i                                                            */
/*     &Table  = pr-odpc                                                         */
/*     &Key    =  "string(pr-odpc.codcia,'999') + string(pr-odpc.numord,'x(6)')" */
/*     &Prg    = r-pr-odpc                                                       */
/*     &Event  = DELETE}                                                         */
/*                                                                               */
