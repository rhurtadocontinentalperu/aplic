TRIGGER PROCEDURE FOR REPLICATION-DELETE OF pr-mov-mes.

/*     {rpl/reptrig.i                                                                      */
/*     &Table  = pr-mov-mes                                                                */
/*     &Key    =  "string(pr-mov-mes.codcia,'999') + string(pr-mov-mes.periodo,'9999') + ~ */
/*     string(pr-mov-mes.codpln, '99') + string(pr-mov-mes.nromes, '99') + ~               */
/*     string(pr-mov-mes.codper, 'x(6)') + string(pr-mov-mes.numord, 'x(6)') + ~           */
/*     string(pr-mov-mes.horai, '99.99') + string(pr-mov-mes.horaf, '99.99')"              */
/*     &Prg    = r-pr-mov-mes                                                              */
/*     &Event  = DELETE}                                                                   */
