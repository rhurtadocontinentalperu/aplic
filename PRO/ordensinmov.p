define var s-codalm as char init "12".
define var s-codcia as integer init 1.
define var i as integer.
define var x as integer.

output to c:\reporte.txt.

find pr-cfgpro where pr-cfgpro.codcia = s-codcia 
     no-lock no-error.
if not available pr-cfgpro then return.
 

for each pr-odpc where pr-odpc.codcia = s-codcia and
                       pr-odpc.codalm = s-codalm :
 x = 0.
 do I = 1 to 4 :
    for each almcmov where almcmov.codcia = s-codcia and
                           almcmov.codalm = s-codalm and
                           almcmov.tipmov = pr-cfgpro.tipmov[i] and
                           almcmov.codmov = pr-cfgpro.codmov[i] and
                           almcmov.codref = "OP" and
                           almcmov.nroref = pr-odpc.numord and
                           almcmov.flgest <> "A":
/*
        display almcmov.fchdoc almcmov.codref almcmov.nroref.
        pause 0.
*/        
        x = x + 1.                   
    end.                                                  
 end.
 
 if x = 0 then display fchord numord .
 pause 0.
  
 
end.
output close.
                       
