for each ccbdcaja where ccbdcaja.codcia = 1 and 
                        ccbdcaja.coddoc = "RET" :
 find ccbcdocu where ccbcdocu.codcia = 1 and 
                     ccbcdocu.coddoc = ccbdcaja.coddoc and
                     ccbcdocu.nrodoc = ccbdcaja.nrodoc 
                     no-lock no-error.
 if available ccbcdocu then do:
    if ccbdcaja.fchdoc <> ccbcdocu.fchdoc then do:
       display ccbdcaja.fchdoc ccbcdocu.fchdoc.
       pause 0.
       ccbdcaja.fchdoc = ccbcdocu.fchdoc.
    end.   
 end.
end.
                     
                      
