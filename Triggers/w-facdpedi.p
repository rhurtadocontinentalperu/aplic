TRIGGER PROCEDURE FOR WRITE OF facdpedi OLD BUFFER OldFacdpedi.


DEF SHARED VAR cl-codcia AS INT.

/* RHC 10/07/2020 */
IF Facdpedi.Factor = 0 THEN Facdpedi.Factor = 1.

/* RHC 13/07/2015 Peso y Unidad */
FIND Almmmatg OF Facdpedi NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg THEN DO:
    Facdpedi.PesMat = Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.PesMat.
    IF TRUE <> (Facdpedi.UndVta > '') THEN Facdpedi.UndVta = Almmmatg.UndBas.
END.

/* Correción del estado de atención */
IF facdpedi.canped > facdpedi.canate THEN facdpedi.flgest = "P".
ELSE facdpedi.flgest = "C".
/* Correción del Precio Base */
IF Facdpedi.PreBas = 0 THEN Facdpedi.PreBas = Facdpedi.PreUni.
/* Correccion del factor */
IF Facdpedi.Factor = 0 OR Facdpedi.Factor = ? THEN DO:
    Facdpedi.Factor = 1.
    FIND Almmmatg OF Facdpedi NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg AND Almmmatg.FacEqu > 0 THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = Facdpedi.UndVta
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN Facdpedi.Factor = Almtconv.Equival.
    END.
END.
/* CONTROL DE CAMBIO DE PRECIOS Y DESCUENTOS */
IF Facdpedi.coddoc = "COT" THEN DO:
    IF ( Facdpedi.PreVta[1] > 0 
         AND ABS(Facdpedi.PreUni - Facdpedi.PreVta[1]) > 0.01 )
        OR FacDPedi.Por_Dsctos[1] > 0 
        THEN FacDPedi.CodAux = "*".
        ELSE FacDPedi.CodAux = "".
END.

/* Stock Comprometido */
/* 10/10/2024*/
/* RUN web/p-ctrl-sku-disp-riqra (INPUT "FacDPedi",                                */
/*                                INPUT (Facdpedi.CodDoc + ":" +                   */
/*                                       Facdpedi.NroPed + ":" +                   */
/*                                       Facdpedi.CodMat + ":" +                   */
/*                                       Facdpedi.AlmDes),                         */
/*                                INPUT (Facdpedi.CanPed * Facdpedi.Factor),       */
/*                                INPUT (OldFacdpedi.canped * OldFacdpedi.factor), */
/*                                "W"                                              */
/*                                ).                                               */

/* IF LOOKUP(FacDPedi.CodDoc,'PED,O/D,OTR') > 0 THEN DO:                                                       */
/*     {gn\comprometido-facdpedi.i &pCodCia=Facdpedi.codcia &pCodAlm=Facdpedi.almdes &pCodMat=Facdpedi.codmat} */
/* END.                                                                                                        */

