output to C:\reporteRPLN1.txt.
for each PL-FLG-MES where PL-FLG-MES.CodCia = 1 and
                          PL-FLG-MES.NroMes = 11 and
                          PL-FLG-MES.Periodo = 2003.
    find PL-PERS where PL-PERS.codper =PL-FLG-MES.codper
                       NO-LOCK NO-ERROR.
    export '|'  
                PL-PERS.codper
                PL-PERS.patper
                PL-PERS.matper
                PL-PERS.nomper
                PL-FLG-MES.seccion.
end.
output close.
                              
