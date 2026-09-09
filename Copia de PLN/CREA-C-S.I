FIND PL-MOV-SEM WHERE
    PL-MOV-SEM.CodCia  = PL-FLG-SEM.CodCia AND
    PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo AND
    PL-MOV-SEM.NroSem  = {1} AND
    PL-MOV-SEM.CodPln  = PL-FLG-SEM.CodPln AND
    PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
    PL-MOV-SEM.CodCal  = {2} AND
    PL-MOV-SEM.CodMov  = {3} NO-ERROR.
IF NOT AVAILABLE PL-MOV-SEM THEN DO:
    CREATE PL-MOV-SEM.
    PL-MOV-SEM.CodCia  = PL-FLG-SEM.CodCia.
    PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo.
    PL-MOV-SEM.NroSem  = {1}.
    PL-MOV-SEM.CodPln  = PL-FLG-SEM.CodPln.
    PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer.
    PL-MOV-SEM.CodCal  = {2}.
    PL-MOV-SEM.CodMov  = {3}.
END.
PL-MOV-SEM.ValCal-Sem  = {4}.
PL-MOV-SEM.Fch-Ult-Cal = TODAY.
PL-MOV-SEM.Hra-Ult-Cal = STRING(TIME,'HH:MM').