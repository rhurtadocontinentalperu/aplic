DEFINE VAR S-CODMAT AS CHAR.
DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.


define var s-codcia as integer init 1.
define var s-codalm as char init "11".
define var i as integer .
define var x-canped as deci .

for each almmmatg where almmmatg.codcia = s-codcia AND almmmatg.codMAT = "000756" :

do i = 1 to num-entries(s-codalm) :
FOR EACH FacDPedi WHERE FacDPedi.CodCia = s-codcia 
                   AND  FacDPedi.almdes = entry(i,s-codalm)
                   AND  FacDPedi.codmat = almmmatg.codmat 
                   AND  LOOKUP(FacDPedi.CodDoc,'PED') > 0 
                   AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
    FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                     AND  FacCPedi.CodAlm = FacDPedi.almdes
                                     /*AND  Faccpedi.FlgEst = "P"*/
                                     AND  Faccpedi.TpoPed = "1"
                                    NO-LOCK NO-ERROR.
    IF NOT AVAIL Faccpedi THEN NEXT.
    FIND tmp-tabla WHERE t-CodDoc = FacCPedi.codDoc
                    AND  t-NroPed = FacCPedi.NroPed
                   NO-ERROR.
    IF NOT AVAIL tmp-tabla THEN DO:
        CREATE tmp-tabla.
        ASSIGN 
          t-CodDoc = FacCPedi.codDoc
          t-NroPed = FacCPedi.NroPed
          t-FchPed = FacCPedi.FchPed
          t-NomCli = FacCPedi.NomCli
          t-codmat = FacDPedi.CodMat
          t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
    END.
END.
/*for each tmp-tabla:
 display tmp-tabla.
end.*/




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
    FIND tmp-tabla WHERE t-CodDoc = FacCPedi.codDoc
                    AND  t-NroPed = FacCPedi.NroPed
                   NO-ERROR.
    IF NOT AVAIL tmp-tabla THEN DO:
        CREATE tmp-tabla.
        ASSIGN 
          t-CodDoc = FacCPedi.codDoc
          t-NroPed = FacCPedi.NroPed
          t-FchPed = FacCPedi.FchPed
          t-NomCli = FacCPedi.NomCli
          t-codmat = FacDPedi.CodMat
          t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
    END.
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
            FIND tmp-tabla WHERE t-CodDoc = FacCPedm.codDoc
                            AND  t-NroPed = FacCPedm.NroPed
                           NO-ERROR.
            IF NOT AVAIL tmp-tabla THEN DO:
                CREATE tmp-tabla.
                ASSIGN 
                  t-CodDoc = FacCPedm.codDoc
                  t-NroPed = FacCPedm.NroPed
                  t-FchPed = FacCPedm.FchPed
                  t-NomCli = FacCPedm.NomCli
                  t-codmat = FacDPedm.CodMat
                  t-CanPed = FacDPedm.Factor * FacDPedm.CanPed.
            END.
            /* cantidad en reservacion */
        END.
    END.
END.
end.
for each tmp-tabla:
 display tmp-tabla with width 500.
end.
end.

