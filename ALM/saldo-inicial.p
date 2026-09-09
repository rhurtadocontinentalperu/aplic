def temp-table t-cmov like almcmov.
def temp-table t-dmov like almdmov.
def var x-fecha as date no-undo.
def var x-nroitm as int no-undo.
def var s-codcia as int init 001 no-undo.

x-fecha = 01/01/2005.   /* fecha de corte */

for each almacen where almacen.codcia = s-codcia no-lock:
  create t-cmov.
  assign
      t-cmov.CodAlm = almacen.codalm
      t-cmov.CodCia = s-codcia
      t-cmov.CodMon = 1
      t-cmov.CodMov = 00
      t-cmov.FchDoc = x-fecha
      t-cmov.NroDoc = 1
      t-cmov.NroSer = 0
      t-cmov.TipMov = 'I'
      t-cmov.TpoCmb = 1
      t-cmov.usuario= 'SISTEMAS'
  x-nroitm = 1.
  for each almmmatg where codcia = s-codcia no-lock:
    find last almstkal of almmmatg where almstkal.codalm = almacen.codalm
        and almstkal.fecha < x-fecha
        no-lock no-error.
    if available almstkal and almstkal.stkact <> 0 then do:
        find last almstkge of almmmatg where almstkge.fecha < x-fecha
          no-lock no-error.
        create t-dmov.
        assign
            t-dmov.CanDes = AlmStkal.StkAct
            t-dmov.CodAjt = 'A'
            t-dmov.CodAlm = t-cmov.codalm
            t-dmov.CodCia = t-cmov.codcia
            t-dmov.codmat = almmmatg.codmat
            t-dmov.CodMon = t-cmov.codmon
            t-dmov.CodMov = t-cmov.codmov
            t-dmov.CodUnd = almmmatg.undbas
            t-dmov.Factor = 1
            t-dmov.FchDoc = t-cmov.fchdoc
            t-dmov.NroDoc = t-cmov.nrodoc
            t-dmov.NroItm = x-nroitm
            t-dmov.NroSer = t-cmov.nroser
            t-dmov.PreUni = (if available almstkge then AlmStkge.CtoUni else 0)
            t-dmov.TipMov = t-cmov.tipmov
            t-dmov.TpoCmb = t-cmov.tpocmb
            t-dmov.ImpCto = t-dmov.candes * t-dmov.preuni.
        x-nroitm = x-nroitm + 1.
    end.      
  end.
end.

output to c:\tmp\almcmov.d.
for each t-cmov:
    export t-cmov.
end.  
output close.
output to c:\tmp\almdmov.d.
for each t-dmov:
    export t-dmov.
end.  
output close.
