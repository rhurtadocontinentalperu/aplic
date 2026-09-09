TRIGGER PROCEDURE FOR WRITE OF almdrepo OLD BUFFER OldAlmdrepo.

/* Correción del estado de atención */
IF Almdrepo.CanApro > Almdrepo.CanAten THEN Almdrepo.FlgEst = "P".
ELSE Almdrepo.FlgEst = "C".

/* Stock Comprometido */
/* 10/10/2024*/
/* RUN web/p-ctrl-sku-disp-riqra (INPUT "Almdrepo",                      */
/*                                INPUT (Almdrepo.CodAlm + ":" +         */
/*                                       Almdrepo.TipMov + ":" +         */
/*                                       STRING(Almdrepo.NroSer) + ":" + */
/*                                       STRING(Almdrepo.NroDoc) + ":" + */
/*                                       Almdrepo.CodMat + ":" +         */
/*                                       Almdrepo.AlmPed),               */
/*                                INPUT Almdrepo.CanApro,                */
/*                                INPUT OldAlmdrepo.CanApro,             */
/*                                "W"                                    */
/*                                ).                                     */
