TRIGGER PROCEDURE FOR DELETE OF facdpedi.

/* Stock Comprometido */
/* 10/10/2024 */
/* RUN web/p-ctrl-sku-disp-riqra (INPUT "FacDPedi",                          */
/*                                INPUT (Facdpedi.CodDoc + ":" +             */
/*                                       Facdpedi.NroPed + ":" +             */
/*                                       Facdpedi.CodMat + ":" +             */
/*                                       Facdpedi.AlmDes),                   */
/*                                INPUT (Facdpedi.CanPed * Facdpedi.Factor), */
/*                                INPUT 0,                                   */
/*                                "D"                                        */
/*                                ).                                         */
/* IF LOOKUP(FacDPedi.CodDoc,'PED,O/D,OTR') > 0 THEN DO:                                                       */
/*     {gn\comprometido-facdpedi.i &pCodCia=Facdpedi.codcia &pCodAlm=Facdpedi.almdes &pCodMat=Facdpedi.codmat} */
/* END.                                                                                                        */

