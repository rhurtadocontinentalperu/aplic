def var x-signo as int no-undo.


def temp-table detalle
  field codven like gn-ven.codven
  field codcli like gn-clie.codcli
  field fmapgo like ccbcdocu.fmapgo
  field impnac as dec extent 2
  field impusa as dec extent 2.
for each gn-divi no-lock where codcia = 001:
 for each ccbcdocu no-lock
        use-index llave10
       where codcia = 001
        
        and fchdoc >= 01/01/07  
        and fchdoc <= 01/15/07
        and lookup(coddoc,'fac,bol,n/c') > 0
        and ccbcdocu.coddiv = gn-divi.coddiv
        and lookup(codven,'901,015,173') > 0
        and flgest <> 'a':
        
    x-signo = if ccbcdocu.coddoc = 'n/c' then -1 else 1.

    find detalle where detalle.codven = ccbcdocu.codven
        and detalle.codcli = ccbcdocu.codcli
        and detalle.fmapgo = ccbcdocu.fmapgo
        exclusive-lock no-error.
    if not available detalle then create detalle.
    assign 
        detalle.codven = ccbcdocu.codven
        detalle.codcli = ccbcdocu.codcli
         detalle.fmapgo = ccbcdocu.fmapgo.
    
    if ccbcdocu.fchdoc <= 12/31/07
     then do:
        if ccbcdocu.codmon=1
        then detalle.impnac[1] = detalle.impnac[1] + (ccbcdocu.imptot * x-signo).
       else detalle.impusa[1] = detalle.impusa[1] + (ccbcdocu.imptot * x-signo).
    end.
  
    else do:
      if ccbcdocu.codmon=1
      then detalle.impnac[1] = detalle.impnac[1] + (ccbcdocu.imptot * x-signo).
      else detalle.impusa[1] = detalle.impusa[1] + (ccbcdocu.imptot * x-signo).
       end.

   end.
end.
for each detalle, 
     first gn-ven  no-lock where gn-ven.codcia = 001
     and gn-ven.codven = detalle.codven ,
      first gn-clie  no-lock where gn-clie.codcia = 000
     and gn-clie.codcli = detalle.codcli
     break by detalle.codven
                       by detalle.codcli
                       by detalle.fmapgo:

      accumulate detalle.impnac[1](sub-total by detalle.codven).
      accumulate detalle.impnac[2](sub-total by detalle.codven).
      accumulate detalle.impusa[1](sub-total by detalle.codven).
      accumulate detalle.impusa[2](sub-total by detalle.codven).
  

  display
        detalle.codven
        gn-ven.nomven
        detalle.codcli
        gn-clie.nomcli
        gn-clie.canal
        detalle.fmapgo
        detalle.impnac[1]
         detalle.impusa[1]
          detalle.impnac[2]
         detalle.impusa[2]
         gn-clie.implc
         with stream-io no-box
         width 320.
        




end.
