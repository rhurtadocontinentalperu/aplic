TRIGGER PROCEDURE FOR REPLICATION-DELETE OF pr-odpd.

/*     {rpl/reptrig.i                                                               */
/*     &Table  = pr-odpd                                                            */
/*     &Key    =  "string(pr-odpd.codcia,'999') + string(pr-odpd.numord,'x(6)') + ~ */
/*     string(pr-odpd.codmat, 'x(6)')"                                              */
/*     &Prg    = r-pr-odpd                                                          */
/*     &Event  = DELETE}                                                            */
