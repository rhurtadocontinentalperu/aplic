TRIGGER PROCEDURE FOR REPLICATION-DELETE OF cb-dmov.

/*     {rpl/reptrig.i                                                                */
/*     &Table  = cb-dmov                                                             */
/*     &Key    =  "string(cb-dmov.codcia,'999') + string(cb-dmov.periodo,'9999') + ~ */
/*     string(cb-dmov.nromes,'99') + ~                                               */
/*     string(cb-dmov.codope,'x(3)') + string(cb-dmov.nroast, 'x(6)') + ~            */
/*     string(cb-dmov.codcta, 'x(6)') + string(cb-dmov.codaux, 'x(11)') + ~          */
/*     string(cb-dmov.coddoc, 'x(2)') + string(cb-dmov.nrodoc, 'x(10)')"             */
/*     &Prg    = r-cb-dmov                                                           */
/*     &Event  = DELETE}                                                             */
