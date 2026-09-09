/*disable triggers for load of ccbboldep.*/

define temp-table x-tempo like ccbboldep.
for each ccbboldep where ccbboldep.codcia = 1 and
                         ccbboldep.coddoc = "BD" and
                         ccbboldep.coddiv = "00000" and
                         ccbboldep.fchdoc >= 01/01/2003 and
                         CAPS(substring(ccbboldep.codcli,1,1)) = "A":
 create x-tempo.
 raw-transfer ccbboldep to x-tempo.
end.
                         
                         
output to c:\boletas.txt.

 for each x-tempo:
    x-tempo.sdoact = x-tempo.imptot.
    x-tempo.flgest = "P".
 end.


define var x-tot as deci.
define var x-tipo as deci.

for each ccbccaja where codcia = 1 and 
coddiv = "00000" and
coddoc = "I/C" and
fchdoc >= 01/01/2003 and
CcbCCaja.ImpNac[5] + CcbCCaja.ImpUsa[5] > 0 and
ccbccaja.flgest <> "A":
find x-tempo where x-tempo.codcia = 1 and 
                   x-tempo.coddoc = "BD" and
                   x-tempo.nrodoc = CcbCCaja.Voucher[5]
                     no-error.
if available x-tempo then do:
/*
 display ccbboldep.coddoc 
         ccbboldep.nrodoc 
         ccbccaja.codcli  
         CcbCCaja.fchdoc 
         ccbccaja.coddoc
         ccbccaja.nrodoc
         CcbCCaja.ImpNac[5]
         CcbCCaja.ImpUsa[5] 
         ccbboldep.imptot column-label "Importe"
         ccbboldep.sdoact column-label "Saldo"
         ccbboldep.codmon column-label "moneda"
         with width 300.
         pause 0.
 */        
 x-tot = 0.
 if x-tempo.codmon = 1 then do:
    x-tot = x-tot + CcbCCaja.ImpNac[5] + CcbCCaja.ImpUsa[5] * ccbccaja.tpocmb.
 end.
 if x-tempo.codmon = 2 then do:
    x-tot = x-tot + CcbCCaja.ImpUsa[5] + CcbCCaja.ImpNac[5] / ccbccaja.tpocmb.
 end.
 
 x-tempo.sdoact = x-tempo.sdoact - x-tot.        
 if x-tempo.sdoact = 0 then x-tempo.flgest = "C".        
end.
end.
                      
                     

for each x-tempo:
 find ccbboldep where ccbboldep.codcia = 1 and
                      ccbboldep.coddoc = x-tempo.coddoc and
                      ccbboldep.nrodoc = x-tempo.nrodoc
                      no-error.
 if available ccbboldep then do:
    if x-tempo.sdoact <> ccbboldep.sdoact then do:
        display ccbboldep.codcli
                ccbboldep.nomcli
                ccbboldep.coddoc 
                ccbboldep.nrodoc 
                ccbboldep.fchdoc
                ccbboldep.imptot column-label "Importe"
                ccbboldep.sdoact column-label "Saldo"
                ccbboldep.codmon column-label "moneda"
                x-tempo.sdoact   column-label "Saldo Real"
                with width 300.
                pause 0.
        ccbboldep.sdoact = x-tempo.sdoact.
        ccbboldep.flgest = x-tempo.flgest.

    end.
    
 end.
                      
                      
end.
