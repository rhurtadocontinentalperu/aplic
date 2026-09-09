TRIGGER PROCEDURE FOR DELETE OF almdrepo.

/* Stock Comprometido */
/* 10/10/2024*/
/* RUN web/p-ctrl-sku-disp-riqra (INPUT "Almdrepo",                  */
/*                            INPUT (Almdrepo.CodAlm + ":" +         */
/*                                   Almdrepo.TipMov + ":" +         */
/*                                   STRING(Almdrepo.NroSer) + ":" + */
/*                                   STRING(Almdrepo.NroDoc) + ":" + */
/*                                   Almdrepo.CodMat + ":" +         */
/*                                   Almdrepo.AlmPed),               */
/*                            INPUT Almdrepo.CanApro,                */
/*                            0,                                     */
/*                            "D"                                    */
/*                            ).                                     */
