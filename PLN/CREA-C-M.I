FIND PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = PL-FLG-MES.CodCia AND
    PL-MOV-MES.Periodo = PL-FLG-MES.Periodo AND
    PL-MOV-MES.NroMes  = PL-FLG-MES.NroMes AND
    PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
    PL-MOV-MES.CodCal  = {1} AND
    PL-MOV-MES.CodMov  = {2} NO-ERROR.
IF NOT AVAILABLE PL-MOV-MES THEN DO:
    CREATE PL-MOV-MES.
    PL-MOV-MES.CodCia  = PL-FLG-MES.CodCia.
    PL-MOV-MES.Periodo = PL-FLG-MES.Periodo.
    PL-MOV-MES.NroMes  = PL-FLG-MES.NroMes.
    PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln.
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer.
    PL-MOV-MES.CodCal  = {1}.
    PL-MOV-MES.CodMov  = {2}.
END.
PL-MOV-MES.ValCal-MES  = {3}.
PL-MOV-MES.Fch-Ult-Cal = TODAY.
PL-MOV-MES.Hra-Ult-Cal = STRING(TIME,'HH:MM').