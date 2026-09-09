disable triggers for load of faccpedi.
disable triggers for load of facdpedi.

define var x-cot as integer.
define var x-ped as integer.
define var x-od as integer.

for each faccpedi where codcia = 1 and fchped < 01/01/2003 :
    display coddoc fchped.
    pause 0.
    case coddoc:
     when "COT" then x-cot = x-cot + 1.
     when "PED" then x-ped = x-ped + 1.
     when "O/D" then x-od = x-od + 1.
    end.
    for each facdpedi of faccpedi:
      delete facdpedi.
    end.
    delete faccpedi.
    
end.
display x-cot x-ped x-od.
