define var s-codcia as integer init 1.
define var x-fecha as date init today.
define var x-despro as char.
define var f-stkgen as deci.
define var f-precto as deci.
define var f-valcto1 as deci.
define var f-valcto2 as deci.
define var i-codmon as integer init 2.
define var f-costo as deci.
define var f-tot1 as deci format "->>,>>>,>>>,>>>,>>9.99".
define var f-tot2 as deci format "->>,>>>,>>>,>>>,>>9.99".
define var x-stock as deci.

output to /usr/tmp/stock.txt.

define temp-table tempo
  field codmat like almmmatg.codmat
  field desmat like almmmatg.desmat
  field undbas like almmmatg.undbas
  field stkact like test.almmmate.stkact
  field preuni1 like almdmov.preuni
  field preuni2 like almdmov.preuni
  field codpro like gn-prov.codpro
  field nompro like gn-prov.nompro
  field imptot1 like almdmov.preuni
  field imptot2 like almdmov.preuni.

  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = s-codcia :
                                  
     
      FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= x-fecha
           NO-LOCK NO-ERROR.
      
      FIND LAST AlmStkge WHERE AlmStkge.Codcia = S-CODCIA AND
                        AlmStkge.Codmat = Almmmatg.Codmat AND
                        AlmStkge.Fecha <= x-fecha
                        NO-LOCK NO-ERROR.
                        
      IF NOT AVAILABLE AlmStkge THEN NEXT. 
      x-stock = 0.
      for each test.almmmate where test.almmmate.codcia = 1 and
                                   test.almmmate.codmat = almmmatg.codmat:
          x-stock = x-stock + test.Almmmate.stkact.                         
      end.
      IF x-stock = 0 THEN NEXT.
      
      FIND Tempo WHERE Tempo.Codpro = almmmatg.codpr1
                             EXCLUSIVE-LOCK NO-ERROR.

      IF NOT AVAILABLE Tempo THEN DO:
         X-DESpro = "".
         FIND gn-prov WHERE gn-prov.codcia = 0
                       AND  gn-prov.codpro = Almmmatg.Codpr1
                       NO-LOCK NO-ERROR.
         IF AVAILABLE gn-prov THEN X-DESpro = gn-prov.nompro.
         
         CREATE Tempo.
         ASSIGN 
         Tempo.codmat = Almmmatg.codmat
         Tempo.desmat = Almmmatg.desmat
         Tempo.undbas = Almmmatg.undbas
         Tempo.Codpro = Almmmatg.Codpr1 
         Tempo.Nompro = x-despro.
      END.        
      
      F-STKGEN = x-stock .
      F-PRECTO = AlmStkGe.CtoUni.
      
      IF I-CodMon = 1 THEN F-VALCTO1 = F-STKGEN * F-PRECTO.
      IF I-CodMon = 2 THEN F-VALCTO1 = F-STKGEN * F-PRECTO / Gn-Tcmb.Compra. 
      
 
      /***************Costo Ultima Reposicion********MAGM***********/
         F-COSTO = Almmmatg.Ctolis.
         IF I-CodMon <> Almmmatg.MonVta THEN DO:
            IF I-CodMon = 1 THEN F-costo = F-costo * gn-tcmb.venta. 
            IF I-CodMon = 2 THEN F-costo = F-costo / gn-tcmb.venta. 
         END.            

      F-VALCTO2 = F-COSTO * F-STKGEN.
      
      /***************************************************************/

      tempo.imptot1 = tempo.imptot1 + f-valcto1.
      tempo.imptot2 = tempo.imptot2 + f-valcto2.
      
      tempo.preuni1 = f-precto.
      tempo.preuni2 = f-costo.
      tempo.stkact  = f-stkgen.
      
      f-tot1 = f-tot1 + f-valcto1.
      f-tot2 = f-tot2 + f-valcto2.
      
  END.

for each tempo where tempo.stkact <> 0 break by imptot1 descending:
    display tempo.codpro format "x(11)" column-label "Codigo "
            tempo.nompro format "x(45)" column-label "Nombre o Razon Social"
            imptot1 column-label "Importe/Promedio!US$!Sin IGV"
            with width 350.
end.
display "" skip.
display f-tot1 no-label .
output close.
