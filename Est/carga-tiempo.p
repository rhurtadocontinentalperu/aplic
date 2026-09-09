DEF VAR X AS DATE.
DEF VAR Y AS DATE.
DEF VAR Z AS DATE.
DEF VAR W AS CHAR INIT "Domingo,Lunes,Martes,Miercoles,Jueves,Viernes,Sabado".
DEF VAR T AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre".

DELETE FROM dwh_tiempo.

ASSIGN
    X = 01/01/2006
    Y = 12/31/2011.
DO Z = X TO Y:
    CREATE dwh_Tiempo.
    ASSIGN
        dwh_Tiempo.CodCia = 1
        dwh_Tiempo.NombreDia = ENTRY(WEEKDAY(Z), W)
        dwh_Tiempo.NombreMes = ENTRY(MONTH(Z), T)
        dwh_Tiempo.NroDia = DAY(Z)
        dwh_Tiempo.NroMes = MONTH(Z)
        dwh_Tiempo.Periodo = YEAR(Z)
        dwh_Tiempo.Fecha = dwh_Tiempo.Periodo * 10000 + dwh_Tiempo.NroMes * 100 + dwh_Tiempo.NroDia.
    FIND FIRST vtatabla WHERE vtatabla.codcia = 1
        AND Z >= vtatabla.rango_fecha[1]
        AND Z <= vtatabla.rango_fecha[2]
        NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN dwh_Tiempo.Campania = vtatabla.llave_c1.

END.
