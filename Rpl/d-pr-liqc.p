TRIGGER PROCEDURE FOR REPLICATION-DELETE OF pr-liqc.

/*     {rpl/reptrig.i                                                            */
/*     &Table  = pr-liqc                                                         */
/*     &Key    =  "string(pr-liqc.codcia,'999') + string(pr-liqc.numliq,'x(6)')" */
/*     &Prg    = r-pr-liqc                                                       */
/*     &Event  = DELETE}                                                         */
/*                                                                               */
