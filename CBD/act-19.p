define var x-cta1 as char.
define var x-cta2 as char.
define buffer b-mov for cb-dmov.
define temp-table tempo like cb-dmov.

for each cb-dmov where codcia = 1 
and periodo = 2003 and
nromes = 0 
and codope = "000" and
nroast = "000001" and
substring(codcta,1,2) = "19":
 case codcta :
     when "191101" then do:
         x-cta1 = "129101".
         x-cta2 = "121201".
     end.    
     when "191102" then do:
         x-cta1 = "129102".
         x-cta2 = "121202".
     end.    
     when "191103" then do:
          x-cta1 = "129103".
          x-cta2 = "121201".
     end.     
     when "191104" then do:
          x-cta1 = "129104".
          x-cta2 = "121202".
     end.     
     when "191105" then do:
          x-cta1 = "129105".
          x-cta2 = "123101".
     end.     
     when "191106" then do:
          x-cta1 = "129106".
          x-cta2 = "123102".
     end.     
 end.
 create tempo.
 raw-transfer cb-dmov to tempo.
 tempo.codcta = x-cta1.
 tempo.tpomov = false.
 tempo.nroast = "000003".
 create tempo.
 raw-transfer cb-dmov to tempo.
 tempo.codcta = x-cta2.
 tempo.nroast = "000003". 
 
end.

for each tempo:
 create cb-dmov.
 raw-transfer tempo to cb-dmov.
 display tempo.codcta.
 pause 0.
end.


