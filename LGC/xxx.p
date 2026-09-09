DEF VAR x-Importe LIKE Lg-docmp.preuni NO-UNDO.

FIND LAST LG-CFGIGV NO-LOCK NO-ERROR.
FIND lg-cocmp WHERE lg-cocmp.codcia = 001
    AND lg-cocmp.coddiv = '00000'
    AND lg-cocmp.tpodoc = "N"
    AND lg-cocmp.nrodoc = 083981.
ASSIGN 
    LG-COCmp.ImpTot = 0
    LG-COCmp.ImpExo = 0.
FOR EACH lg-docmp OF lg-cocmp:
    DISPLAY lg-docmp.codmat.
    PAUSE 0.
    ASSIGN 
        x-Importe = lg-docmp.CanPedi * lg-docmp.PreUni.
    ASSIGN
        lg-docmp.ImpTot = ROUND(x-Importe * 
                                (1 - (lg-docmp.Dsctos[1] / 100)) *
                                (1 - (lg-docmp.Dsctos[2] / 100)) *
                                (1 - (lg-docmp.Dsctos[3] / 100)) *
                                (1 + (lg-docmp.IgvMat / 100)), 2).
    ASSIGN
        LG-COCmp.ImpTot = LG-COCmp.ImpTot + lg-docmp.ImpTot.
    IF lg-docmp.IgvMat = 0 THEN LG-COCmp.ImpExo = LG-COCmp.ImpExo + lg-docmp.ImpTot.
END.
ASSIGN 
    LG-COCmp.ImpIgv = (LG-COCmp.ImpTot - LG-COCmp.ImpExo) - 
    ROUND((LG-COCmp.ImpTot - LG-COCmp.ImpExo) / (1 + LG-CFGIGV.PorIgv / 100),2)
    LG-COCmp.ImpBrt = LG-COCmp.ImpTot - LG-COCmp.ImpExo - LG-COCmp.ImpIgv
    LG-COCmp.ImpDto = 0
    LG-COCmp.ImpNet = LG-COCmp.ImpBrt - LG-COCmp.ImpDto.
DISPLAY lg-cocmp.imptot.
