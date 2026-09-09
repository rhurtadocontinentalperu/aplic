DEF VAR s-codcia AS INT INIT 001.
DEF VAR s-coddiv AS CHAR INIT '00015'.
DEF VAR f-desde AS DATE.
DEF VAR f-hasta AS DATE.
DEF VAR x-imptot AS DEC FORMAT '>>>,>>>,>>9.99'.

ASSIGN
    f-desde = TODAY
    f-hasta = TODAY.

OUTPUT TO c:\tmp\por-cliente.txt.
FOR EACH FacCpedi NO-LOCK WHERE FacCpedi.CodCia = S-CODCIA 
    AND FacCpedi.CodDiv = S-CODDIV 
    AND FacCpedi.CodDoc = "COT"    
    AND FacCpedi.FchPed >= F-desde 
    AND FacCpedi.FchPed <= F-hasta 
    AND FacCpedi.FlgEst <> 'A',
    FIRST gn-ven OF faccpedi NO-LOCK
    BREAK BY Faccpedi.codcia BY Faccpedi.codcli:
    ACCUMULATE FacCPedi.ImpTot (SUB-TOTAL BY Faccpedi.codcli).
    ACCUMULATE FacCPedi.ImpTot (TOTAL BY Faccpedi.codcia).
    IF LAST-OF(Faccpedi.codcli)
    THEN DO:
        DISPLAY
            Faccpedi.codcli
            Faccpedi.nomcli
            Faccpedi.codven
            gn-ven.nomven
            (ACCUM SUB-TOTAL BY Faccpedi.codcli FacCPedi.ImpTot) @ x-imptot
            WITH STREAM-IO NO-BOX WIDTH 320.
    END.
    IF LAST-OF(Faccpedi.codcia)
    THEN DO:
        UNDERLINE x-imptot.
        DOWN 1.
        DISPLAY
            (ACCUM TOTAL BY Faccpedi.codcia FacCPedi.ImpTot) @ x-imptot
            WITH STREAM-IO NO-BOX WIDTH 320.
    END.
END.
OUTPUT CLOSE.
