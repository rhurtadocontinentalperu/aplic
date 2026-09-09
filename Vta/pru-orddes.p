/*
FOR EACH FACCPEDI NO-LOCK WHERE FACCPEDI.CODCIA = 1 AND FACCPEDI.NROPED = '000097262',
    EACH FACDPEDI OF FACCPEDI NO-LOCK:
    DISPLAY 
       FacDPedi.CanPed 
       FacDPedi.CanPick 
       FacDPedi.canate 
       FacDPedi.PreBas 
       FacDPedi.PreUni
       FacDPedi.PorDto
       FacDPedi.ImpDto 
       FacDPedi.ImpIgv 
       FacDPedi.ImpIsc 
       FacDPedi.ImpLin
        WITH WIDTH 320.
END.     */

FOR EACH FACCPEDI NO-LOCK WHERE FACCPEDI.CODCIA = 1 AND FACCPEDI.NROPED = '000097263',
    EACH FACDPEDI OF FACCPEDI NO-LOCK:
    DISPLAY 
       FacDPedi.CanPed  COLUMN-LABEL "CanPed"
       FacDPedi.CanPick COLUMN-LABEL "CanPick" 
       FacDPedi.PreBas  COLUMN-LABEL "PreBas" 
       FacDPedi.PreUni  COLUMN-LABEL "PreUni"
       FacDPedi.PorDto  COLUMN-LABEL "PorDto"
       FacDPedi.ImpDto  COLUMN-LABEL "ImpDto" 
       FacDPedi.AftIgv  COLUMN-LABEL "ImpIscC"
       FacDPedi.ImpIgv  COLUMN-LABEL "ImpIgv"
       FacDPedi.ImpIsc  COLUMN-LABEL "ImpIsc" 
       FacDPedi.ImpLin  COLUMN-LABEL "ImpLin"
       WITH WIDTH 320.
    DISPLAY 
       FacCPedi.PorDto  COLUMN-LABEL "PorDto" 
       FacCPedi.ImpDto  COLUMN-LABEL "ImpDtoC" 
       FacCPedi.ImpTot  COLUMN-LABEL "ImpTotC" 
       FacCPedi.ImpVta  COLUMN-LABEL "ImpVtaC"
       FacCPedi.ImpExo  COLUMN-LABEL "ImpExoC" 
       FacCPedi.ImpIgv  COLUMN-LABEL "ImpIgvC"
       FacCPedi.ImpIsc  COLUMN-LABEL "ImpIscC" 
       FacCPedi.ImpBrt  COLUMN-LABEL "ImpBrto"
       WITH WIDTH 320.


END.     
