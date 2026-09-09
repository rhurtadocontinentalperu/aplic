/*output to c:\boletas.txt.*/
/*disable triggers for load of ccbboldep.
 * 
 * for each ccbboldep where coddiv <> "00009" :
 * display coddoc imptot sdoact codmon codcli.
 * delete ccbboldep.*/
/*
 for each ccbboldep where coddiv = "00009" :
    sdoact = imptot.
    flgest = "P".
 end.
 */
define var x-tot as deci.
define var x-tipo as deci.

for each ccbccaja where codcia = 1 and 
coddiv = "00000" and
coddoc = "I/C" and
fchdoc >= 01/01/2003 and
ccbccaja.voucher[5] = "001004750" and
CcbCCaja.ImpNac[5] + CcbCCaja.ImpUsa[5] > 0 and
ccbccaja.flgest <> "A":
/*
 if ccbccaja.tpocmb = 0 then do:
   x-tipo = 0.
   find last gn-tccja where gn-tccja.coddiv = "00009" and
                            gn-tccja.fecha <= ccbccaja.fchdoc
                            no-lock no-error.
   if available gn-tccja then x-tipo = gn-tccja.compra.                         
   ccbccaja.tpocmb = x-tipo.
 end.
*/
find ccbboldep where ccbboldep.codcia = 1 and 
                     ccbboldep.coddoc = "BD" and
                     ccbboldep.nrodoc = CcbCCaja.Voucher[5]
                     no-error.
if available ccbboldep then do:
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
      /*   pause 0.*/
    /*
    for each ccbdcaja of ccbccaja:
        display codref no-label nroref no-label imptot no-label.
        pause 0.
    end.
    */     
/* pause 0.       */
 x-tot = 0.
 if ccbboldep.codmon = 1 then do:
    x-tot = x-tot + CcbCCaja.ImpNac[5] + CcbCCaja.ImpUsa[5] * ccbccaja.tpocmb.
 end.
 if ccbboldep.codmon = 2 then do:
    x-tot = x-tot + CcbCCaja.ImpUsa[5] + CcbCCaja.ImpNac[5] / ccbccaja.tpocmb.
 end.
 
 ccbboldep.sdoact = ccbboldep.sdoact - x-tot.        
 if ccbboldep.sdoact = 0 then ccbboldep.flgest = "C".        
end.
end.
                      
                     
