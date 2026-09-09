TRIGGER PROCEDURE FOR REPLICATION-WRITE OF di-rutad.

/*     {rpl/reptrig.i                                                               */
/*     &Table  = di-rutad                                                           */
/*     &Key    = "string(di-rutad.codcia,'999') + string(di-rutad.coddiv, 'x(5)') ~ */
/*         + string(di-rutad.coddoc, 'x(3)') + string(di-rutad.nrodoc, 'x(15)') ~   */
/*         + string(di-rutad.codref, 'x(3)') + di-rutad.nroref"                     */
/*         "                                                                        */
/*     &Prg    = r-di-rutad                                                         */
/*     &Event  = WRITE                                                              */
/*     &FlgDB0 = NO                                                                 */
/*     &FlgDB1 = TRUE                                                               */
/*     &FlgDB2 = TRUE                                                               */
/*     &FlgDB3 = TRUE                                                               */
/*     &FlgDB4 = TRUE                                                               */
/*     &FlgDB5 = TRUE                                                               */
/*     &FlgDB6 = TRUE                                                               */
/*     &FlgDB7 = TRUE                                                               */
/*     &FlgDB8 = TRUE                                                               */
/*     &FlgDB9 = TRUE                                                               */
/*     &FlgDB10 = TRUE                                                              */
/*     &FlgDB11 = TRUE                                                              */
/*     &FlgDB12 = TRUE                                                              */
/*     &FlgDB13 = TRUE                                                              */
/*     &FlgDB14 = TRUE                                                              */
/*     &FlgDB15 = TRUE                                                              */
/*     &FlgDB16 = TRUE                                                              */
/*     &FlgDB17 = TRUE                                                              */
/*     &FlgDB18 = TRUE                                                              */
/*     &FlgDB19 = TRUE                                                              */
/*     &FlgDB20 = TRUE                                                              */
/*     &FlgDB30 = TRUE                                                              */
/*     }                                                                            */
