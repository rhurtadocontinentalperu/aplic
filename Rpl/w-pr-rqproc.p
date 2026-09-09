TRIGGER PROCEDURE FOR REPLICATION-WRITE OF pr-rqproc.

/*     {rpl/reptrig.i                                                                   */
/*     &Table  = pr-rqproc                                                              */
/*     &Key    =  "string(pr-rqproc.codcia,'999') + string(pr-rqproc.codalm,'x(3)') + ~ */
/*     string(pr-rqproc.nroser, '999') + string(pr-rqproc.nrodoc, '999999')"            */
/*     &Prg    = r-pr-rqproc                                                            */
/*     &Event  = WRITE}                                                                 */
