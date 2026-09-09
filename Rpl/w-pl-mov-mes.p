TRIGGER PROCEDURE FOR REPLICATION-WRITE OF pl-mov-mes.

/*     {rpl/reptrig.i                                                                      */
/*     &Table  = pl-mov-mes                                                                */
/*     &Key    =  "string(pl-mov-mes.codcia,'999') + string(pl-mov-mes.periodo,'9999') + ~ */
/*     string(pl-mov-mes.nromes,'99') + string(pl-mov-mes.codpln,'99') + ~                 */
/*     string(pl-mov-mes.codcal, '999') + string(pl-mov-mes.codper, 'x(6)') + ~            */
/*     string(pl-mov-mes.codmov, '999')"                                                   */
/*     &Prg    = r-pl-mov-mes                                                              */
/*     &Event  = WRITE}                                                                    */
/*                                                                                         */
