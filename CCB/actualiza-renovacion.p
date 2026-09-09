define var s-codcia as integer init 1.

/*******Renovaciones*****************/
for each ccbcmvto where codcia = s-codcia and coddoc = "RNV" :
display nrodoc fchdoc coddoc nroref nrolet.
find ccbcdocu where ccbcdocu.codcia = s-codcia and 
                    ccbcdocu.coddoc = "LET" and
                    ccbcdocu.nrodoc = ccbcmvto.nroref
                    no-error.
if available ccbcdocu then do:
   ccbcmvto.codmon = ccbcdocu.codmon.
   ccbcdocu.sdoact = ccbcdocu.imptot - ccbcmvto.imptot.
   for each ccbdcaja where ccbdcaja.codcia = s-codcia and
                           ccbdcaja.coddoc <> "RNV" and
                           ccbdcaja.codref = "LET" and
                           ccbdcaja.nroref = ccbcmvto.nroref :
       ccbcdocu.sdoact = ccbcdocu.sdoact - ccbdcaja.imptot.                            
   end.                        
   if ccbcdocu.sdoact <> 0 then ccbcdocu.flgest = "P".
   if ccbcdocu.sdoact = 0 then ccbcdocu.flgest = "C".
   
end.

for each ccbdmvto where ccbdmvto.codcia = s-codcia and
                        ccbdmvto.coddoc = ccbcmvto.coddoc and
                        ccbdmvto.nrodoc = ccbcmvto.nrodoc:
    
find ccbcdocu where ccbcdocu.codcia = s-codcia and 
                    ccbcdocu.coddoc = "LET" and
                    ccbcdocu.nrodoc = ccbdmvto.nroref
                    no-error.
if available ccbcdocu then do:
   ccbcdocu.codmon = ccbcmvto.codmon.
end.
end.


end.
                  
/**************************************/
                    
                    
