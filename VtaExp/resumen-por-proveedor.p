DEF VAR s-codcia AS INT INIT 001.
DEF VAR s-coddiv AS CHAR INIT '00015'.
DEF VAR f-desde AS DATE.
DEF VAR f-hasta AS DATE.
DEF VAR x-imptot AS DEC FORMAT '>>>,>>>,>>9.99'.

ASSIGN
    f-desde = TODAY 
    f-hasta = TODAY.

OUTPUT TO c:\tmp\por-proveedor.txt.
FOR EACH FacCpedi NO-LOCK WHERE FacCpedi.CodCia = S-CODCIA 
    AND FacCpedi.CodDiv = S-CODDIV 
    AND FacCpedi.CodDoc = "COT"    
    AND FacCpedi.FchPed >= F-desde 
    AND FacCpedi.FchPed <= F-hasta 
    AND FacCpedi.FlgEst <> 'A',
    EACH facdpedi OF faccpedi NO-LOCK,
    FIRST almmmatg OF facdpedi NO-LOCK,
    FIRST gn-prov NO-LOCK WHERE gn-prov.codcia = 0
        AND gn-prov.codpro = Almmmatg.codpr1
    BREAK BY Faccpedi.codcia BY almmmatg.codpr1:
    ACCUMULATE FacDPedi.ImpLin (SUB-TOTAL BY Almmmatg.codpr1).
    ACCUMULATE FacDPedi.ImpLin (TOTAL BY Faccpedi.codcia).
    IF LAST-OF(Almmmatg.codpr1)
    THEN DO:
        DISPLAY
            Almmmatg.codpr1
            Gn-prov.nompro
            (ACCUM SUB-TOTAL BY Almmmatg.codpr1 FacDPedi.ImpLin) @ x-imptot
            WITH STREAM-IO NO-BOX.
    END.
    IF LAST-OF(Faccpedi.codcia)
    THEN DO:
        UNDERLINE x-imptot.
        DOWN 1.
        DISPLAY
            (ACCUM TOTAL BY Faccpedi.codcia FacDPedi.ImpLin) @ x-imptot
            WITH STREAM-IO NO-BOX.
    END.
END.
OUTPUT CLOSE.
