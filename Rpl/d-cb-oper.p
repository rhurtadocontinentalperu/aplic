TRIGGER PROCEDURE FOR REPLICATION-DELETE OF cb-oper.

/*     {rpl/reptrig.i                                                            */
/*     &Table  = cb-oper                                                         */
/*     &Key    =  "string(cb-oper.codcia,'999') + string(cb-oper.codope,'x(3)')" */
/*     &Prg    = r-cb-oper                                                       */
/*     &Event  = DELETE}                                                         */
