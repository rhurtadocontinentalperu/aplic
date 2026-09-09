define var s-codcia as integer init 1.
define var s-codalm as char init "11".
define var i as integer .
define var x-canped as deci .

for each almmmatg where almmmatg.codcia = s-codcia AND almmmatg.codMAT = "000756":

do i = 1 to num-entries(s-codalm) :
FOR EACH FacDPedi WHERE FacDPedi.CodCia = s-codcia 
                   AND  FacDPedi.almdes = entry(i,s-codalm)
                   AND  FacDPedi.codmat = almmmatg.codmat 
                   AND  LOOKUP(FacDPedi.CodDoc,'PED') > 0 
                   AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
    FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                     AND  FacCPedi.CodAlm = FacDPedi.almdes
                                     AND  Faccpedi.FlgEst = "P"
                                     AND  Faccpedi.TpoPed = "1"
                                    NO-LOCK NO-ERROR.
    IF NOT AVAIL Faccpedi THEN NEXT.

    X-CanPed = X-CanPed + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
END.

/*********   Barremos las O/D que son parciales y totales    ****************/
FOR EACH FacDPedi WHERE FacDPedi.CodCia = s-codcia
                   AND  FacDPedi.almdes = entry(i,s-codalm)
                   AND  FacDPedi.codmat = almmmatg.codmat 
                   AND  LOOKUP(FacDPedi.CodDoc,'O/D') > 0 
                   AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
    FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                     AND  FacCPedi.CodAlm = entry(i,s-codalm) 
                                     AND  Faccpedi.FlgEst = "P"
                                    NO-LOCK NO-ERROR.
    IF NOT AVAIL FacCPedi THEN NEXT.
    X-CanPed = X-CanPed + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
END.

/*******************************************************/

/* Segundo barremos los pedidos de mostrador de acuerdo a la vigencia */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.
FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK.
TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
          (FacCfgGn.Hora-Res * 3600) + 
          (FacCfgGn.Minu-Res * 60).
FOR EACH Facdpedm WHERE Facdpedm.CodCia = s-codcia 
                   AND  Facdpedm.AlmDes = entry(i,s-codalm)
                   AND  Facdpedm.codmat = almmmatg.codmat 
                   AND  Facdpedm.FlgEst = "P" :
    FIND FIRST Faccpedm OF Facdpedm WHERE Faccpedm.CodCia = Facdpedm.CodCia 
                                     AND  Faccpedm.CodAlm = entry(i,s-codalm) 
                                     AND  Faccpedm.FlgEst = "P"  
                                    NO-LOCK NO-ERROR. 
    IF NOT AVAIL Faccpedm THEN NEXT.
    
    TimeNow = (TODAY - FacCPedm.FchPed) * 24 * 3600.
    TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedm.Hora, 1, 2)) * 3600) +
              (INTEGER(SUBSTRING(FacCPedm.Hora, 4, 2)) * 60) ).
    IF TimeOut > 0 THEN DO:
        IF TimeNow <= TimeOut   /* Dentro de la valides */
        THEN DO:
            /* cantidad en reservacion */
            X-CanPed = X-CanPed + FacDPedm.Factor * FacDPedm.CanPed.
        END.
    END.
END.
end.
DISPLAY X-CANPED.
end.

