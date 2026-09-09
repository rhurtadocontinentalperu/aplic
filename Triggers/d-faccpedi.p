TRIGGER PROCEDURE FOR DELETE OF Faccpedi.

/* Stock Comprometido */
    /*
IF LOOKUP(FacCPedi.CodDoc,'PED,O/D,OTR') > 0 THEN DO.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK:
        /* Stock Comprometido */
        {gn\comprometido-facdpedi.i &pCodCia=Facdpedi.codcia &pCodAlm=Facdpedi.almdes &pCodMat=Facdpedi.codmat}
    END.
END.
*/

