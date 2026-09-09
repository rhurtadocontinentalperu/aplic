/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var x-cargo as char format "x(20)".
define var y as integer init 0.
define var x-tot as deci init 0.
define var x-tipo as deci init 0.
define var x-factor as deci init 0.
define var i as integer .
define var x-des as char.
define var x-chek as deci .

define var x-in as integer.
define var x-de as integer.
define var x-nom as char format "x(40)".
define var x as char format "x(200)".
define var x-cta as char format "x(11)".
define var x-dir as char format "x(40)".

output to "c:\temp\pdt.txt".

x-dir = "RENE DESCARTES MZ C LT 1 URB. STA RAQUEL 2DA ETAPA ATE".
x-nom = "CONTINENTAL S.A.".
x-cargo = "19101179051005      ".

y = 0 .
x-tot = 0.
x-chek = 0.
for each tempo:
find pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  and
                      pl-flg-mes.periodo = tempo.periodo and
                      pl-flg-mes.nromes  = tempo.nromes  and
                      pl-flg-mes.codper  = tempo.codper  no-lock no-error.
  if available pl-flg-mes and cnpago = "EFECTIVO" or cnpago = "" THEN NEXT .
  if available pl-flg-mes and nrodpt <> "" then do: 
   x-in = 0.
   x-in = (tempo.valcal-mes  ) .
   x-tot = x-tot + x-in.
   x-chek = x-chek + DECI(substring(nrodpt,5,8)).
   y  = y + 1.
  end.  
end.

x-chek = x-chek + DECI(substring(x-cargo,4,8)).
x-tot = x-tot * 100.
x = "".
  x  =    "#" +
          "1" + 
          "H" +
          "C" +
          STRING(x-cargo,"x(20)") +          
          "S/" +
          string(x-tot,"999999999999999") +
          string(DAY(TODAY),"99")  + string(MONTH(TODAY),"99") + string(YEAR(TODAY),"9999") +
          "PAGO DE HABERES     " +
          string(x-chek,"999999999999999") + 
          STRING(y,"999999") +
          "1" +
          "               " + 
          "0".
  DISPLAY x  WITH no-labels WIDTH 300.


for each tempo :
find pl-pers where pl-pers.codper = tempo.codper no-lock no-error.
find pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  and
                      pl-flg-mes.periodo = tempo.periodo and
                      pl-flg-mes.nromes  = tempo.nromes  and
                      pl-flg-mes.codper  = tempo.codper  no-lock no-error.
if available pl-flg-mes and cnpago = "EFECTIVO" or cnpago = "" THEN NEXT .
if available pl-flg-mes and nrodpt <> "" then do: 
  x-in = 0.
  x-in = (tempo.valcal-mes ) * 100.  
  x-des = "".
  do I = 1 to length(left-trim(PL-PERS.nomper)):
     if substr(left-trim(PL-PERS.nomper),i,1) = " " then do:
        x-des = substr(left-trim(PL-PERS.nomper),1,i - 1).
        leave.
     end.
  end.
  if x-des = "" then  x-des = trim(PL-PERS.nomper).

  x-nom =   trim(PL-PERS.patper) + " " + trim(PL-PERS.matper) + " " + x-des .  
/*  x-cta = substring(trim(PL-FLG-MES.nrodpt-cts),1,3) + substring(trim(PL-FLG-MES.nrodpt-cts),5,8) .*/
  x-cta = substring(PL-FLG-MES.nrodpt,1,3) + substring(PL-FLG-MES.nrodpt,5,8) + substring(PL-FLG-MES.nrodpt,14,1) + substring(PL-FLG-MES.nrodpt,16,2).
  
  x  =    " " +
          "2" + 
          "A" +
          STRING(x-cta,"x(20)") +
          string(x-nom,"x(40)") + 
          "S/" + 
          string(x-in,"999999999999999") +
          "PAGO DE HABERES                         " +
          "0" + 
          "DNI" +
          string(lelect,"x(9)") +
          "0" .
  DISPLAY x  WITH no-labels WIDTH 300.
  end.  
end.  

output close.


END PROCEDURE.
