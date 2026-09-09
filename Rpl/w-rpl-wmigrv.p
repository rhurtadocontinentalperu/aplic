TRIGGER PROCEDURE FOR REPLICATION-WRITE OF RPL-WMIGRV.

/* RHC 17/07/2012 SE VA A HACER MEDIANTE UN BATCH EN LINUX */

/* TIENDAS UTILEX */
/* IF LOOKUP(rpl-wmigrv.coddiv, '00501,00023,00027,00502') > 0 THEN DO:         */
/*     {rpl/reptrig.i                                                           */
/*     &Table  = rpl-wmigrv                                                     */
/*     &Key    = "string(rpl-wmigrv.coddiv, 'x(5)') ~                           */
/*         + string(rpl-wmigrv.twcorre, 'x(10)') ~                              */
/*         + string(rpl-wmigrv.wsecue, '99999')"                                */
/*     &Prg    = r-ccbcdocu                                                     */
/*     &Event  = WRITE                                                          */
/*     &FlgDB0 = "NOT LOOKUP(rpl-wmigrv.coddiv, '00501,00023,00027,00502') > 0" */
/*     &FlgDB1 = TRUE                                                           */
/*     &FlgDB2 = TRUE                                                           */
/*     &FlgDB3 = TRUE                                                           */
/*     &FlgDB4 = TRUE                                                           */
/*     &FlgDB5 = TRUE                                                           */
/*     &FlgDB6 = TRUE                                                           */
/*     &FlgDB7 = TRUE                                                           */
/*     &FlgDB8 = TRUE                                                           */
/*     &FlgDB9 = TRUE                                                           */
/*     &FlgDB10 = TRUE                                                          */
/*     &FlgDB11 = TRUE                                                          */
/*     &FlgDB12 = TRUE                                                          */
/*     &FlgDB13 = TRUE                                                          */
/*     &FlgDB14 = TRUE                                                          */
/*     &FlgDB15 = TRUE                                                          */
/*     &FlgDB16 = TRUE                                                          */
/*     &FlgDB17 = TRUE                                                          */
/*     &FlgDB18 = TRUE                                                          */
/*     &FlgDB19 = TRUE                                                          */
/*     &FlgDB20 = TRUE                                                          */
/*     }                                                                        */
/* END.                                                                         */
