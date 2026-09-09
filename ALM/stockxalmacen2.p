define var x as integer .
define var x-stock as deci init 0.
define var i as integer.
define var s-codcia as integer init 1.
define var x-codmat as char init "002686,002726,017891,002825,002826,002827,002842,002883,002884,002885,002886,002887,002888,019349,003761,004390,001715,001914,005206,002031,002140,005602,005604,015508,015509,015802,022648,016834,002854,005195,002124,022146,005601,002828,002841,002843,004126,004127,004256,004442,004443,004444,004445,004454,004449,004455,004461,015729,015739,019629,019653,019927,014608,014612,014618,014621,014625,018189,019571,019871,022645,022967,022970,022975,022968,022969".
define var x-tot as deci .
define var x-codalm as char init "03,03A,03B,04,04A,04B,05,05A,05B,83,83A,83B".
output to /usr/tmp/listado.txt.
do i = 1 to num-entries(x-codmat):
find almmmatg where almmmatg.codcia = s-codcia and
                    almmmatg.codmat = entry(i,x-codmat)
                    no-lock no-error.
x = 1.                    
x-tot = 0.
for each almacen where almacen.codcia = s-codcia and
                       almacen.flgrep:
if almacen.almcsg then next.

find last almstkal where almstkal.codcia = s-codcia and
                       almstkal.codmat = entry(i,x-codmat) and
                       almstkal.codalm = almacen.codalm and
                       almstkal.fecha  < 01/01/2003
                       no-lock no-error.
  if available almstkal then do:    
     x-tot = x-tot + almstkal.stkact.
    display 
     almmmatg.codmat when x = 1 format "x(6)" column-label "Codigo"
     almmmatg.desmat when x = 1 format "x(35)" column-label "Descripcion"
     almmmatg.desmar when x = 1 format "x(10)" column-label "Marca"
     almmmatg.undbas when x = 1 column-label "UM"
     almacen.codalm column-label "Almacen"
     almacen.Descripcion format "x(35)" column-label ""
     almstkal.stkact  column-label "Stock"
     x-tot column-label "Saldo"
     with width 350.
     pause 0.
     x = 0. 
  end. 
  
end.
end.
output close.                      
