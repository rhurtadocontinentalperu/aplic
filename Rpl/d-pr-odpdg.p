TRIGGER PROCEDURE FOR REPLICATION-DELETE OF pr-odpdg.

/*     {rpl/reptrig.i                                                                 */
/*     &Table  = pr-odpdg                                                             */
/*     &Key    =  "string(pr-odpdg.codcia,'999') + string(pr-odpdg.numord,'x(6)') + ~ */
/*     string(pr-odpdg.codgas, 'x(6)')"                                               */
/*     &Prg    = r-pr-odpdg                                                           */
/*     &Event  = DELETE}                                                              */
/*                                                                                    */
