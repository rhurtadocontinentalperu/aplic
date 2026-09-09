TRIGGER PROCEDURE FOR WRITE OF almcrepo.

/* Stock Comprometido */
/* 10/10/2024 */
/* Anulados y Rechazados */
/* IF LOOKUP(Almcrepo.FlgEst, "A,R") > 0 THEN DO:                                */
/*     FOR EACH Almdrepo OF Almcrepo NO-LOCK:                                    */
/*         RUN web/p-ctrl-sku-disp-riqra (INPUT "Almdrepo",                      */
/*                                        INPUT (Almdrepo.CodAlm + ":" +         */
/*                                               Almdrepo.TipMov + ":" +         */
/*                                               STRING(Almdrepo.NroSer) + ":" + */
/*                                               STRING(Almdrepo.NroDoc) + ":" + */
/*                                               Almdrepo.CodMat + ":" +         */
/*                                               Almdrepo.AlmPed),               */
/*                                        INPUT Almdrepo.CanApro,                */
/*                                        INPUT 0,                               */
/*                                        "D"                                    */
/*                                        ).                                     */
/*     END.                                                                      */
/* END.                                                                          */
