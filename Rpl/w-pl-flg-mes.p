TRIGGER PROCEDURE FOR REPLICATION-WRITE OF pl-flg-mes.

/*     {rpl/reptrig.i                                                                      */
/*     &Table  = pl-flg-mes                                                                */
/*     &Key    =  "string(pl-flg-mes.codcia,'999') + string(pl-flg-mes.periodo,'9999') + ~ */
/*     string(pl-flg-mes.codpln,'99') + string(pl-flg-mes.nromes,'99') + ~                 */
/*     string(pl-flg-mes.codper, 'x(6)')"                                                  */
/*     &Prg    = r-pl-flg-mes                                                              */
/*     &Event  = WRITE}                                                                    */
