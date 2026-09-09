TRIGGER PROCEDURE FOR REPLICATION-DELETE OF ccbccgoc.

/*     {rpl/reptrig.i                                                                 */
/*     &Table  = ccbccgoc                                                             */
/*     &Key    =  "string(ccbccgoc.codcia,'999') + string(ccbccgoc.coddiv,'x(5)') + ~ */
/*     string(ccbccgoc.coddoc,'x(3)') + string(ccbccgoc.nrodoc,'x(15)')"              */
/*     &Prg    = r-ccbccgoc                                                           */
/*     &Event  = DELETE}                                                              */
