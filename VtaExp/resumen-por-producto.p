DEF VAR s-codcia AS INT INIT 001.
DEF VAR s-coddiv AS CHAR INIT '00015'.
DEF VAR f-desde AS DATE.
DEF VAR f-hasta AS DATE.
DEF VAR x-imptot AS DEC FORMAT '>>>,>>>,>>9.99'.

ASSIGN
    f-desde = 01/06/09 
    f-hasta = 01/09/09.

OUTPUT TO m:\tmp\por-producto.txt.
FOR EACH FacCpedi NO-LOCK WHERE FacCpedi.CodCia = S-CODCIA 
    AND FacCpedi.CodDiv = S-CODDIV 
    AND FacCpedi.CodDoc = "COT"    
    AND FacCpedi.FchPed >= F-desde 
    AND FacCpedi.FchPed <= F-hasta 
    AND FacCpedi.FlgEst <> 'A',
    EACH facdpedi OF faccpedi NO-LOCK,
    FIRST almmmatg OF facdpedi NO-LOCK /*WHERE almmmatg.chr__02 = 'P'*/
    BREAK BY Faccpedi.codcia BY almmmatg.codmat:
    ACCUMULATE FacDPedi.ImpLin (SUB-TOTAL BY Almmmatg.codmat).
    ACCUMULATE FacDPedi.ImpLin (TOTAL BY Faccpedi.codcia).
    IF LAST-OF(Almmmatg.codmat)
    THEN DO:
        DISPLAY
            Almmmatg.codfam
            Almmmatg.codmat
            Almmmatg.desmat
            Almmmatg.desmar
            Almmmatg.undbas
            (ACCUM SUB-TOTAL BY Almmmatg.codmat FacDPedi.ImpLin) @ x-imptot
            WITH STREAM-IO NO-BOX WIDTH 320.
    END.
    IF LAST-OF(Faccpedi.codcia)
    THEN DO:
        UNDERLINE x-imptot.
        DOWN 1.
        DISPLAY
            (ACCUM TOTAL BY Faccpedi.codcia FacDPedi.ImpLin) @ x-imptot
            WITH STREAM-IO NO-BOX WIDTH 320.
    END.
END.
OUTPUT CLOSE.
