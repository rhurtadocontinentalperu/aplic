/* 
    VALMIESA SOFTWARE 
*/ 

DEFINE INPUT PARAMETER ROWID-FLG-MES AS ROWID.
{bin/s-global.i}
{pln/s-global.i}

FIND integral.PL-FLG-MES WHERE
    ROWID(integral.PL-FLG-MES) = ROWID-FLG-MES NO-ERROR.
IF NOT AVAILABLE integral.PL-FLG-MES THEN DO:
    BELL.
    MESSAGE 'Registro de personal no existe'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

DEFINE VARIABLE s-CodPln AS INTEGER NO-UNDO.
DEFINE VARIABLE s-CodCal AS INTEGER NO-UNDO.
DEFINE VARIABLE s-CodRed AS INTEGER NO-UNDO.

ASSIGN
    s-CodPln = 1
    s-CodCal = 1
    s-CodRed = 0.
DEFINE VARIABLE FECHA-INICIO-MES    AS DATE NO-UNDO.
DEFINE VARIABLE FECHA-FIN-MES       AS DATE NO-UNDO.

FECHA-INICIO-MES   = DATE(S-NROMES, 01, S-PERIODO).
IF S-NROMES < 12
THEN FECHA-FIN-MES  = DATE(S-NROMES + 1, 01, S-PERIODO) - 1.
ELSE FECHA-FIN-MES  = DATE(S-NROMES, 31, S-PERIODO).

FIND integral.PL-MOV-MES WHERE
    integral.PL-MOV-MES.CodCia  = integral.PL-FLG-MES.CodCia AND
    integral.PL-MOV-MES.Periodo = integral.PL-FLG-MES.Periodo AND
    integral.PL-MOV-MES.NroMes  = integral.PL-FLG-MES.NroMes AND
    integral.PL-MOV-MES.CodPln  = integral.PL-FLG-MES.CodPln AND
    integral.PL-MOV-MES.CodPer  = integral.PL-FLG-MES.CodPer AND
    integral.PL-MOV-MES.CodCal  = s-CodCal AND
    integral.PL-MOV-MES.CodMov  = s-CodRed NO-LOCK NO-ERROR.
IF AVAILABLE integral.PL-MOV-MES THEN
    ASSIGN
        integral.PL-FLG-MES.Exceso-Mes =
        integral.PL-MOV-MES.valcal-Mes.
ELSE ASSIGN integral.PL-FLG-MES.Exceso-Mes = 0.

DELETE FROM integral.PL-MOV-MES WHERE
    integral.PL-MOV-MES.CodCia  = integral.PL-FLG-MES.CodCia AND
    integral.PL-MOV-MES.Periodo = integral.PL-FLG-MES.Periodo AND
    integral.PL-MOV-MES.NroMes  = integral.PL-FLG-MES.NroMes AND
    integral.PL-MOV-MES.CodPln  = integral.PL-FLG-MES.CodPln AND
    integral.PL-MOV-MES.CodPer  = integral.PL-FLG-MES.CodPer AND
    integral.PL-MOV-MES.CodCal  = s-CodCal.

/* EXTORNAMOS LOS SALDOS DE CUENTA CORRIENTE */
FOR EACH integral.PL-MOV-CTE-MES WHERE
    integral.PL-MOV-CTE-MES.CodCia  = integral.PL-FLG-MES.CodCia AND
    integral.PL-MOV-CTE-MES.Periodo = integral.PL-FLG-MES.Periodo AND
    integral.PL-MOV-CTE-MES.NroMes  = integral.PL-FLG-MES.NroMes AND
    integral.PL-MOV-CTE-MES.CodPer  = integral.PL-FLG-MES.CodPer:
    FIND integral.PL-CFG-CTE-MES WHERE
        integral.PL-CFG-CTE-MES.CodCia  = integral.PL-FLG-MES.CodCia AND
        integral.PL-CFG-CTE-MES.Periodo = integral.PL-FLG-MES.Periodo AND
        integral.PL-CFG-CTE-MES.NroMes  = integral.PL-FLG-MES.NroMes AND
        integral.PL-CFG-CTE-MES.Clf-Cte-Mes = integral.PL-MOV-CTE-MES.Clf-Cte-Mes AND
        integral.PL-CFG-CTE-MES.Tpo-Cte-Mes = integral.PL-MOV-CTE-MES.Tpo-Cte-Mes AND
        integral.PL-CFG-CTE-MES.CodPer = integral.PL-MOV-CTE-MES.CodPer AND
        integral.PL-CFG-CTE-MES.Nro-Cte-Mes = integral.PL-MOV-CTE-MES.Nro-Cte-Mes NO-ERROR.
    IF AVAILABLE integral.PL-CFG-CTE-MES THEN
        ASSIGN
            integral.PL-CFG-CTE-MES.Sdo-Cte-Mes =
                integral.PL-CFG-CTE-MES.Sdo-Cte-Mes +
                integral.PL-MOV-CTE-MES.Val-Cte-Mes
            integral.PL-CFG-CTE-MES.Sdo-Usa-Mes =
                integral.PL-CFG-CTE-MES.Sdo-Usa-Mes +
                integral.PL-MOV-CTE-MES.Val-Usa-Mes.
    DELETE integral.PL-MOV-CTE-MES.
END.

IF integral.PL-FLG-MES.SitAct = 'Inactivo' THEN RETURN.

DEFINE NEW SHARED VARIABLE VAL-VAR AS DECIMAL EXTENT 20.
DEFINE VARIABLE VAR                AS DECIMAL NO-UNDO.
DEFINE VARIABLE NETO               AS DECIMAL NO-UNDO.
DEFINE VARIABLE TOTAL-REMUNERACION AS DECIMAL NO-UNDO.
DEFINE VARIABLE TOTAL-DESCUENTO    AS DECIMAL NO-UNDO.
DEFINE VARIABLE TOTAL-APORTE       AS DECIMAL NO-UNDO.
DEFINE VARIABLE GRATIFICACION      AS LOGICAL NO-UNDO.
DEFINE VARIABLE MES-ACTUAL         AS INTEGER NO-UNDO.

ASSIGN
    MES-ACTUAL    = s-NroMes
    GRATIFICACION = FALSE.

FIND FIRST integral.PL-SEM WHERE
    integral.PL-SEM.CodCia  = s-CodCia AND
    integral.PL-SEM.Periodo = s-Periodo AND
    integral.PL-SEM.NroMes  = s-NroMes AND
    integral.PL-SEM.FlgGtf  = TRUE NO-LOCK NO-ERROR.
IF AVAILABLE integral.PL-SEM THEN
    ASSIGN GRATIFICACION = TRUE.

FIND integral.PL-PERS WHERE integral.PL-PERS.CodPer = integral.PL-FLG-MES.CodPer NO-LOCK NO-ERROR.
FIND integral.PL-AFPS WHERE integral.PL-AFPS.CodAfp = integral.PL-FLG-MES.CodAfp NO-LOCK NO-ERROR.
FIND integral.PL-CLAS WHERE integral.PL-CLAS.Clase = integral.PL-FLG-MES.Clase NO-LOCK NO-ERROR.
FIND LAST integral.PL-VAR-SEM WHERE
    integral.PL-VAR-SEM.Periodo = s-Periodo AND
    integral.PL-VAR-SEM.NroSem <= s-NroSem NO-LOCK.
FIND LAST integral.PL-VAR-MES WHERE
    integral.PL-VAR-MES.Periodo = s-Periodo AND
    integral.PL-VAR-MES.NroMes <= MES-ACTUAL NO-LOCK.

DEFINE VARIABLE ASIGNACION-FAMILIAR AS DECIMAL NO-UNDO.
ASSIGN ASIGNACION-FAMILIAR = integral.PL-VAR-MES.ValVar-Mes[1].

DEFINE VARIABLE POR-ALIMENTOS AS DECIMAL NO-UNDO.
ASSIGN POR-ALIMENTOS = integral.PL-VAR-SEM.ValVar-Sem[1].

DEFINE VARIABLE UIT-PROMEDIO AS DECIMAL NO-UNDO.
ASSIGN UIT-PROMEDIO = integral.PL-VAR-MES.ValVar-Mes[2].

DEFINE VARIABLE ACCIDENTE-TRABAJO AS DECIMAL NO-UNDO.
ASSIGN ACCIDENTE-TRABAJO = integral.PL-VAR-SEM.ValVar-Sem[2].

DEFINE VARIABLE REG-PREST-SALUD AS DECIMAL NO-UNDO.
ASSIGN REG-PREST-SALUD = integral.PL-VAR-MES.ValVar-Mes[3].

DEFINE VARIABLE SIST-NAC-PENSIONES AS DECIMAL NO-UNDO.
ASSIGN SIST-NAC-PENSIONES = integral.PL-VAR-MES.ValVar-Mes[4].

DEFINE VARIABLE FONAVI AS DECIMAL NO-UNDO.
ASSIGN FONAVI = integral.PL-VAR-MES.ValVar-Mes[5].

DEFINE VARIABLE TPO-CAMBIO AS DECIMAL NO-UNDO.
ASSIGN TPO-CAMBIO = integral.PL-VAR-MES.ValVar-Mes[6].

DEFINE VARIABLE TOPE-SEGURO-AFP AS DECIMAL NO-UNDO.
ASSIGN TOPE-SEGURO-AFP = integral.PL-VAR-MES.ValVar-Mes[7].

DEFINE VARIABLE MOVILIDAD AS DECIMAL NO-UNDO.
ASSIGN MOVILIDAD = integral.PL-VAR-MES.ValVar-Mes[8].

DEFINE VARIABLE MINIMO-LEGAL AS DECIMAL NO-UNDO.
ASSIGN MINIMO-LEGAL = integral.PL-VAR-MES.ValVar-Mes[9].

DEFINE VARIABLE CALCULO-MENSUAL-CTS AS DECIMAL NO-UNDO.
ASSIGN CALCULO-MENSUAL-CTS = integral.PL-VAR-MES.ValVar-Mes[10].

DEFINE VARIABLE HORAS-EFECTIVAS AS DECIMAL NO-UNDO.
ASSIGN HORAS-EFECTIVAS = integral.PL-VAR-MES.ValVar-Mes[11].

DEFINE VARIABLE VACACIONES-TRUNCAS AS DECIMAL NO-UNDO.
ASSIGN VACACIONES-TRUNCAS = integral.PL-VAR-MES.ValVar-Mes[12].

DEFINE VARIABLE GRATIFICACION-TRUNCA AS DECIMAL NO-UNDO.
ASSIGN GRATIFICACION-TRUNCA = integral.PL-VAR-MES.ValVar-Mes[13].

/* FIN DE CABECERA */


RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^119(0);^400(0);^099(0);^100(0);^118(0);^142(0);^501(0);^502(0);^503(0);^504(0);^101(0);^103(0);^134(0);^209(0)" ).
/* Si su contrato ya vencio */
IF ( PL-FLG-MES.Vcontr <> ? AND
    PL-FLG-MES.Vcontr < fecha-inicio-mes ) THEN RETURN.

IF PL-FLG-MES.sitact = "Vacaciones" THEN RETURN.
    
IF LOOKUP(PL-FLG-MES.sitact,
    "Descanso pre-natal,Descanso post-natal") > 0 THEN DO:
    IF VAL-VAR[1] = 0 THEN RETURN. /* Si no se paga subsidio */
END.

/* Si no esta en planilla */
IF VAL-VAR[2] > 0 THEN RETURN.

/*/* Si dias trabajados es cero */
IF VAL-VAR[3] = 0 THEN RETURN. */

DEFINE VARIABLE dias-trabajados AS DECIMAL NO-UNDO.
DEFINE VARIABLE ing-diario      AS DECIMAL NO-UNDO.
DEFINE VARIABLE ing-hora        AS DECIMAL NO-UNDO.
DEFINE VARIABLE ing-fondo-snp   AS DECIMAL NO-UNDO.
DEFINE VARIABLE ing-fondo-spp   AS DECIMAL NO-UNDO.
DEFINE VARIABLE ing-fonavi      AS DECIMAL NO-UNDO.
DEFINE VARIABLE rem-ordinaria   AS DECIMAL NO-UNDO.
DEFINE VARIABLE no-afecto-5ta   AS DECIMAL NO-UNDO.
DEFINE VARIABLE no-afecto-rps   AS DECIMAL NO-UNDO.
DEFINE VARIABLE factor          AS DECIMAL NO-UNDO.
DEFINE VARIABLE tiempo-de-serv  AS DECIMAL NO-UNDO.
DEFINE VARIABLE quinquenio      AS LOGICAL NO-UNDO.
DEFINE VARIABLE remuneracion-fija AS DECIMAL NO-UNDO.
DEFINE VARIABLE descuento         AS DECIMAL NO-UNDO.

IF VAL-VAR[4] > 0 THEN dias-trabajados = VAL-VAR[4].
ELSE dias-trabajados = 30.

dias-trabajados = dias-trabajados - ( VAL-VAR[5] + VAL-VAR[6] +
    VAL-VAR[7] + VAL-VAR[8] + VAL-VAR[9] + VAL-VAR[10] ).


IF dias-trabajados > 0 THEN
    factor = dias-trabajados / 30.
ELSE factor = 0.

remuneracion-fija = VAL-VAR[11] + VAL-VAR[12] + VAL-VAR[13]. 

ing-diario = remuneracion-fija / 30.

ing-hora = ing-diario / 8.

/* Cálculo del Tiempo de Servicio */
tiempo-de-serv = ( s-periodo - YEAR( PL-FLG-MES.fecing ) ) +
    ( mes-actual - MONTH( PL-FLG-MES.fecing ) ) / 12.

quinquenio = MONTH( PL-FLG-MES.fecing ) = mes-actual.

/* Calculo del promedio de quinta de los ·ltimos 3 meses
   si el trabajador tiene comision                        */
DEFINE VARIABLE prm-afecto-quinta AS DECIMAL NO-UNDO.

IF VAL-VAR[14] > 0  AND mes-actual > 3 THEN DO:
   DEFINE VARIABLE VAR-i AS INTEGER NO-UNDO.
   DEFINE VARIABLE MES-i AS INTEGER NO-UNDO.
   DEFINE VARIABLE ANO-i AS INTEGER NO-UNDO.
/*   MES-i = mes-actual - 1.*/
   MES-i = mes-actual.
   ANO-i = s-periodo.

   /* S U E L D O S */
   DO VAR-i = 1 TO 3:
       FOR EACH PL-MOV-MES WHERE 
           PL-MOV-MES.CodCia  = s-CodCia          AND
           PL-MOV-MES.Periodo = ANO-i             AND
           PL-MOV-MES.NroMes  = MES-i             AND
           PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
           PL-MOV-MES.CodCal  = 1                 AND
           PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
           PL-MOV-MES.CODMOV  = 405               NO-LOCK :
           prm-afecto-quinta = prm-afecto-quinta + PL-MOV-MES.ValCal-Mes.
       END.
       MES-i = MES-i - 1.
       IF MES-i < 0
       THEN ASSIGN MES-i = 12
                   ANO-i = ANO-i - 1.
   END.
   DO VAR-i = 1 TO 3:
       FOR EACH PL-MOV-MES WHERE 
           PL-MOV-MES.CodCia  = s-CodCia          AND
           PL-MOV-MES.Periodo = ANO-i             AND
           PL-MOV-MES.NroMes  = MES-i             AND
           PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
           PL-MOV-MES.CodCal  = 1                 AND
           PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
           PL-MOV-MES.CODMOV  = 409               NO-LOCK :
           prm-afecto-quinta = prm-afecto-quinta + PL-MOV-MES.ValCal-Mes.
       END.
       MES-i = MES-i - 1.
       IF MES-i < 0
       THEN ASSIGN MES-i = 12
                   ANO-i = ANO-i - 1.
   END.
   /* V A C A C I O N E S  */
   DO VAR-i = 1 TO 3:
       FOR EACH PL-MOV-MES WHERE 
           PL-MOV-MES.CodCia  = s-CodCia          AND
           PL-MOV-MES.Periodo = ANO-i             AND
           PL-MOV-MES.NroMes  = MES-i             AND
           PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
           PL-MOV-MES.CodCal  = 3                 AND
           PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
           PL-MOV-MES.CODMOV  = 405               NO-LOCK :
           prm-afecto-quinta = prm-afecto-quinta + PL-MOV-MES.ValCal-Mes.
       END.
       MES-i = MES-i - 1.
       IF MES-i < 0
       THEN ASSIGN MES-i = 12
                   ANO-i = ANO-i - 1.
   END.
   DO VAR-i = 1 TO 3:
       FOR EACH PL-MOV-MES WHERE 
           PL-MOV-MES.CodCia  = s-CodCia          AND
           PL-MOV-MES.Periodo = ANO-i             AND
           PL-MOV-MES.NroMes  = MES-i             AND
           PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
           PL-MOV-MES.CodCal  = 3                 AND
           PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
           PL-MOV-MES.CODMOV  = 409               NO-LOCK :
           prm-afecto-quinta = prm-afecto-quinta + PL-MOV-MES.ValCal-Mes.
       END.
       MES-i = MES-i - 1.
       IF MES-i < 0
       THEN ASSIGN MES-i = 12
                   ANO-i = ANO-i - 1.
   END.
   /* G R A T I F I C A C I O N E S  */
   DO VAR-i = 1 TO 3:
       FOR EACH PL-MOV-MES WHERE 
           PL-MOV-MES.CodCia  = s-CodCia          AND
           PL-MOV-MES.Periodo = ANO-i             AND
           PL-MOV-MES.NroMes  = MES-i             AND
           PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
           PL-MOV-MES.CodCal  = 4                 AND
           PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
           PL-MOV-MES.CODMOV  = 405               NO-LOCK :
           prm-afecto-quinta = prm-afecto-quinta + PL-MOV-MES.ValCal-Mes.
       END.
       MES-i = MES-i - 1.
       IF MES-i < 0
       THEN ASSIGN MES-i = 12
                   ANO-i = ANO-i - 1.
   END.
   DO VAR-i = 1 TO 3:
       FOR EACH PL-MOV-MES WHERE 
           PL-MOV-MES.CodCia  = s-CodCia          AND
           PL-MOV-MES.Periodo = ANO-i             AND
           PL-MOV-MES.NroMes  = MES-i             AND
           PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
           PL-MOV-MES.CodCal  = 4                 AND
           PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
           PL-MOV-MES.CODMOV  = 409               NO-LOCK :
           prm-afecto-quinta = prm-afecto-quinta + PL-MOV-MES.ValCal-Mes.
       END.
       MES-i = MES-i - 1.
       IF MES-i < 0
       THEN ASSIGN MES-i = 12
                   ANO-i = ANO-i - 1.
   END.
   prm-afecto-quinta = ROUND(prm-afecto-quinta / 3,2).
END.
/* 10 Tipo de Pago ( 0 -> Soles   1-> Dolares) */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^010(0)" ).
/* TIPO DE PAGO */
var = VAL-VAR[1].
RUN @GRABA(10,'Otros').

/* 11 Tipo de Cambio */ 
ASSIGN VAR = 0.
/* TIPO DE CAMBIO   tpo-cambio  */
var = tpo-cambio.


RUN @GRABA(11,'Otros').

/* 100 Dias Trabajados */ 
ASSIGN VAR = 0.
/* DIAS TRABAJADOS */
var = dias-trabajados.
RUN @GRABA(100,'Otros').

/* 142 Dias de Subsidio */ 
ASSIGN VAR = 0.
/* DIAS DE SUBSIDIO */

RUN @GRABA(142,'Otros').

/* 501 Falta Justificada */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^501(0)" ).
/* Falta Justificada */
var = VAL-VAR[1].
RUN @GRABA(501,'Otros').

/* 502 Falta Injustificada */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^502(0)" ).
var = VAL-VAR[1].
RUN @GRABA(502,'Otros').

/* 503 Licencia S/Goce De Haber */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^503(0)" ).
var = VAL-VAR[1].
RUN @GRABA(503,'Otros').

/* 99 Dias Efectivos */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^099(0)" ).
/* DIAS EFECTIVOS */
IF VAL-VAR[1] > 0 THEN
   var = IF dias-trabajados < VAL-VAR[1] THEN dias-trabajados ELSE VAL-VAR[1].
ELSE
   var = IF dias-trabajados < 26 THEN dias-trabajados ELSE 26.
RUN @GRABA(99,'Otros').

/* 101 SUELDO BASICO */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^101(0);^010(0)" ).
/* SUELDO BASICO */
DEFINE VARIABLE Sueldo AS DECIMAL NO-UNDO.
Sueldo = VAL-VAR[1].
IF VAL-VAR[2] = 1 AND TPO-CAMBIO > 0 THEN
   Sueldo = VAL-VAR[1] * TPO-CAMBIO.

IF PL-FLG-MES.sitact = "Activo" THEN DO:
    IF dias-trabajados > 0 THEN var = Sueldo * factor.
    ELSE var = 0.
    rem-ordinaria = rem-ordinaria + Sueldo.
    ing-fondo-spp = ing-fondo-spp + var.
    ing-fondo-snp = ing-fondo-snp + var.
    ing-fonavi    = ing-fonavi    + var.
END.
RUN @GRABA(101,'Remuneraciones').

/* 103 ASIGNACION FAMILIAR LEY */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^103(0)" ).
/* ASIGNACION FAMILIAR */
IF dias-trabajados > 0 THEN DO:
    var = VAL-VAR[1] * factor.
    rem-ordinaria = rem-ordinaria + VAL-VAR[1].
    ing-fondo-spp = ing-fondo-spp + var.
    ing-fondo-snp = ing-fondo-snp + var.
    ing-fonavi    = ing-fonavi    + var.
END.

RUN @GRABA(103,'Remuneraciones').

/* 106 REMUNER. VACACIONAL */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^106(0)" ).
/* REMUNERACION VACACIONAL */
/* Se permite el pago de algunos dias de vaciones en 
   el cßlculo de suelo  ***
IF PL-FLG-MES.sitact = "Vacaciones" THEN DO: */
   var = VAL-VAR[1].
   rem-ordinaria = rem-ordinaria + VAL-VAR[1].
   ing-fondo-spp = ing-fondo-spp + var.
   ing-fondo-snp = ing-fondo-snp + var.
   ing-fonavi    = ing-fonavi    + var.
/*END.*/
RUN @GRABA(106,'Remuneraciones').

/* 107 REMUNER. VACACIONES TRABAJADAS */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^107(0)" ).
   var = VAL-VAR[1].
   rem-ordinaria = rem-ordinaria + VAL-VAR[1].
   ing-fondo-spp = ing-fondo-spp + var.
   ing-fondo-snp = ing-fondo-snp + var.
   ing-fonavi    = ing-fonavi    + var.

RUN @GRABA(107,'Remuneraciones').

/* 108 REMUNER. VACACIONES TRUNCAS */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^108(0)" ).
/* RECORD TRUNCO VACACIONAL */
var = VAL-VAR[1].
rem-ordinaria = rem-ordinaria + VAL-VAR[1].
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(108,'Remuneraciones').

/* 116 Aumento */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^116(0)" ).
/* BONIFICACION */
var = VAL-VAR[1] * factor.
rem-ordinaria = rem-ordinaria + VAL-VAR[1].
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(116,'Remuneraciones').

/* 118 Desc Médico */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^118(0)" ).
/* DESCUENTO MEDICO */
var = VAL-VAR[1] * ing-diario.
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(118,'Remuneraciones').

/* 120 Incremento 3.3% SNP */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^120(0)" ).
/* INCREMENTO 3.3% SNP */
IF dias-trabajados > 0 THEN DO:
    var = VAL-VAR[1] * factor.
    rem-ordinaria = rem-ordinaria + VAL-VAR[1].
    ing-fondo-spp = ing-fondo-spp + var.
    ing-fondo-snp = ing-fondo-snp + var.
    ing-fonavi    = ing-fonavi    + var.
END.
RUN @GRABA(120,'Remuneraciones').

/* 125 HORAS EXTRAS 25% */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^125(0)" ).
/* H Ext SIMPLES */
var = VAL-VAR[1] * ing-hora * 1.25.
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(125,'Remuneraciones').

/* 126 HORAS EXTRAS 100% */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^126(0)" ).
/* H EXT DOBLES */
var = VAL-VAR[1] * ing-hora * 2.
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(126,'Remuneraciones').

/* 127 HORAS EXTRAS 35% */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^127(0)" ).
/* H EXT 135% */
var = VAL-VAR[1] * ing-hora * 1.35.
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(127,'Remuneraciones').

/* 128 HORAS EXTRAS 58.72% */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^128(0)" ).
/* H EXT 158.72% En campaña, personal de Lima con basico reducido en Oct. 2001*/
var = VAL-VAR[1] * ing-hora * 1.5872.
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(128,'Remuneraciones').

/* 130 OTROS INGRESOS */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^130(0)" ).
/* OTROS INGRESOS */
var = VAL-VAR[1] * ing-diario.
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(130,'Remuneraciones').

/* 131 BONIFICACION POR INCENTIVO */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^131(0)" ).
var = VAL-VAR[1].
rem-ordinaria = rem-ordinaria + VAL-VAR[1].
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(131,'Remuneraciones').

/* 132 Por A±os Servicio */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^397(0)" ).
/* POR ANOS DE SERVICIO */
/*IF quinquenio AND VAL-VAR[1] = 0 THEN DO:
    CASE tiempo-de-serv:
    WHEN 30.00 THEN DO:
        BELL.
        MESSAGE
            "El(La) Señor(a)"
            PL-PERS.patper + " " +
            PL-PERS.matper + ", " +
            PL-PERS.nomper SKIP
            "esta cumpliendo en este mes" SKIP
            "30 años de servicio"
            VIEW-AS ALERT-BOX TITLE "Felicidades".
        var = remuneracion-fija * 3.
    END.
    WHEN 25.00 THEN DO:
        BELL.
        MESSAGE
            "El(La) Señor(a)"
            PL-PERS.patper + " " +
            PL-PERS.matper + ", " +
            PL-PERS.nomper SKIP
            "esta cumpliendo en este mes" SKIP
            "25 años de servicio"
            VIEW-AS ALERT-BOX TITLE "Felicidades".
        var = remuneracion-fija * 2.5.
    END.
    WHEN 20.00 THEN var = remuneracion-fija * 2.
    WHEN 15.00 THEN var = remuneracion-fija * 1.5.
    WHEN 10.00 THEN var = remuneracion-fija * 1.
    WHEN 5.00  THEN var = remuneracion-fija * 0.5.
    END CASE.
    ing-fondo-spp = ing-fondo-spp + var.
    ing-fondo-snp = ing-fondo-snp + var.
    ing-fonavi    = ing-fonavi    + var.
END.*/
var = 0.
RUN @GRABA(132,'Remuneraciones').

/* 134 BONIFICACION ESPECIAL */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^134(0)" ).
var = ROUND( VAL-VAR[1] / 30 * dias-trabajados , 2).

rem-ordinaria = rem-ordinaria + VAL-VAR[1].
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
ing-fonavi    = ing-fonavi    + var.

RUN @GRABA(134,'Remuneraciones').

/* 135 AGUINALDO */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^135(0)" ).
/* AGUINALDO */
var = VAL-VAR[1].
no-afecto-5ta = no-afecto-5ta + var.
no-afecto-rps = no-afecto-rps + var.
RUN @GRABA(135,'Remuneraciones').

/* 136 REINTEGRO */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^136(0)" ).
/* REINTEGRO */
var = VAL-VAR[1].
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(136,'Remuneraciones').

/* 137 Participación Utilidades */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^137(0)" ).
/* PARTICIPACION DE UTILIDADES */
var = VAL-VAR[1].
no-afecto-rps = no-afecto-rps + var.
RUN @GRABA(137,'Remuneraciones').

/* 138 ASIGNACION EXTRAORDINARIA */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^138(0)" ).
/* ASIG EXTRAORDINARIA */
var = VAL-VAR[1].
rem-ordinaria = rem-ordinaria + VAL-VAR[1].
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(138,'Remuneraciones').

/* 139 GRATIFICACION TRUNCA */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^139(0)" ).
/* GRATIFICACION TRUNCA*/
var = VAL-VAR[1].
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
/*ing-fonavi    = ing-fonavi    + var.*/
RUN @GRABA(139,'Remuneraciones').

/* 140 AFP 10.23% */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^140(0)" ).
/* AFP 10.23 */
var = VAL-VAR[1] * factor.
rem-ordinaria = rem-ordinaria + VAL-VAR[1].
ing-fondo-spp = ing-fondo-spp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(140,'Remuneraciones').

/* 141 AFP  3.00% */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^141(0)" ).
/* AFP 3.00% */
var = VAL-VAR[1] * factor.
no-afecto-5ta = no-afecto-5ta + VAL-VAR[1].
ing-fondo-spp = ing-fondo-spp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(141,'Remuneraciones').

/* 209 COMISIONES */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^209(0)" ).
/* COMISION */
var = VAL-VAR[1].
ing-fondo-spp = ing-fondo-spp + var.
ing-fondo-snp = ing-fondo-snp + var.
ing-fonavi    = ing-fonavi    + var.
RUN @GRABA(209,'Remuneraciones').

/* 612 GRATIFICACIONES EXTRAORDINARIAS */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^612(0)" ).
var = VAL-VAR[1].
no-afecto-rps = no-afecto-rps + var.
RUN @GRABA(612,'Remuneraciones').

/* 404 Total Afecto a AFP */ 
ASSIGN VAR = 0.
/* TOTAL AFECTO A AFP */
IF AVAILABLE PL-AFPS THEN var = ing-fondo-spp.
RUN @GRABA(404,'Otros').

/* 405 Total Afecto a 5ta Categoria */ 
ASSIGN VAR = 0.
/* TOTAL AFECTO A 5TA CATEGORIA */
var = total-remuneracion - no-afecto-5ta.
RUN @GRABA(405,'Otros').

/* 407 Total Afecto a IPSS */ 
ASSIGN VAR = 0.
/* TOTAL AFECTO A IPSS */
var = total-remuneracion - no-afecto-rps.
RUN @GRABA(407,'Otros').

/* 408 Total Afecto a SNP */ 
ASSIGN VAR = 0.
/* TOTAL AFECTO A SNP */
IF NOT AVAILABLE PL-AFPS THEN var = ing-fondo-snp.
RUN @GRABA(408,'Otros').

/* 409 Total Afecto a 5ta.Categ.Otras empresas */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^409(0)" ).
/* TOTAL AFECTO A 5TA CATEG OTRAS EMPRESAS */
var = VAL-VAR[1].
RUN @GRABA(409,'Otros').

/* 410 Imp.Renta de 5ta. Otras Empresas */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^410(0)" ).
/* IMP RENTA DE 5TA OTRAS EMPRESAS */
var = VAL-VAR[1].
RUN @GRABA(410,'Otros').

/* 200 Adelanto Vacaciones */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^200(3)" ).
/* ADELANTO DE VACACIONES */
IF PL-FLG-MES.sitact = "Vacaciones" THEN var = VAL-VAR[1].
RUN @GRABA(200,'Descuentos').

/* 202 SNP */ 
ASSIGN VAR = 0.
/* SNP */
IF NOT AVAILABLE PL-AFPS THEN
    var = ROUND( ing-fondo-snp , 2 ) *
    ( sist-nac-pensiones / 100 ).
RUN @GRABA(202,'Descuentos').

/* 206 ADELANTO QUINCENAL */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^206(2)" ).
/* ADEL QUINCENA */
var = VAL-VAR[1].

RUN @GRABA(206,'Descuentos').

/* 207 OTROS DESCUENTOS */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^207(0)" ).
/* OTROS DESCUENTOS */
var = VAL-VAR[1].
RUN @GRABA(207,'Descuentos').

/* 208 Seguro Privado de Salud */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^208(0)" ).
/* SEGURO PRIVADO DE SALUD */
var = VAL-VAR[1].
RUN @GRABA(208,'Descuentos').

/* 211 Uniforme */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^211(0)" ).
/* UNIFORME */
var = VAL-VAR[1].

RUN @GRABA(211,'Descuentos').

/* 215 IMPUESTO A LA RENTA DE 5TA, CATEGORIA */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^215(0);^209(0);$405(1);$405(3);$405(4);$409(1);$409(3);$409(4);$215(1);$215(3);$215(4);$410(1);$410(3);$410(4)" ).
/* IMP RENTA 5TA */
IF VAL-VAR[1] = 0 THEN DO:

DEFINE VARIABLE base-imponible  AS DECIMAL NO-UNDO.
DEFINE VARIABLE acumulado       AS DECIMAL NO-UNDO.
DEFINE VARIABLE proy-sueldo     AS DECIMAL NO-UNDO.
DEFINE VARIABLE proy-gratif     AS DECIMAL NO-UNDO.
DEFINE VARIABLE renta-anual     AS DECIMAL NO-UNDO.
DEFINE VARIABLE renta-afecta    AS DECIMAL NO-UNDO.
DEFINE VARIABLE quinta-anual    AS DECIMAL NO-UNDO.
DEFINE VARIABLE quinta-faltante AS DECIMAL NO-UNDO.

IF VAL-VAR[2] > 0 THEN
  base-imponible = prm-afecto-quinta.
ELSE
  base-imponible = rem-ordinaria.

proy-sueldo    = base-imponible * ( 12 - mes-actual ).

/* Gratificaciones Pendientes */
IF mes-actual < 7 THEN
   proy-gratif = base-imponible * 2.
IF mes-actual >= 7 AND mes-actual < 12 THEN
   proy-gratif = base-imponible.

acumulado    = VAL-VAR[3] + VAL-VAR[4] + VAL-VAR[5] + 
               VAL-VAR[6] + VAL-VAR[7] + VAL-VAR[8].

renta-anual  = acumulado + proy-sueldo + proy-gratif.

IF mes-actual = 12 then renta-anual = renta-anual .

renta-afecta = renta-anual - ( 7 * uit-promedio ).

IF renta-afecta > 0 THEN DO:
    IF renta-afecta <= ( 27 * uit-promedio ) THEN DO:
        quinta-anual = renta-afecta * .15.
    END.
    IF renta-afecta > ( 27 * uit-promedio ) AND
       renta-afecta <= ( 54 * uit-promedio ) THEN DO:
        quinta-anual = ( 27 * uit-promedio ) * .15 + 
                       (renta-afecta - ( 27 * uit-promedio )) * .21.
    END.
    IF renta-afecta > ( 54 * uit-promedio ) THEN DO:
        quinta-anual = ( 27 * uit-promedio ) * .15 +
                       ( 27 * uit-promedio ) * .21 +
        ( renta-afecta - ( 54 * uit-promedio ) ) * .27.
    END.


    /* Restamos Todo lo Pagado */
    quinta-faltante = quinta-anual - 
                      (VAL-VAR[9] + VAL-VAR[10] + VAL-VAR[11] +
                       VAL-VAR[12] + VAL-VAR[13] + VAL-VAR[14] ).
    IF mes-actual = 12 THEN var = ROUND(quinta-faltante,0).
    ELSE var = ROUND(quinta-faltante / ( 13 - mes-actual ), 0).

END.


IF var < 0 THEN var = 0.
END.
ELSE
   var = VAL-VAR[1].   

RUN @GRABA(215,'Descuentos').

/* 220 MANDATO JUDICIAL */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^220(0)" ).
var = VAL-VAR[1].

RUN @GRABA(220,'Descuentos').

/* 221 FONDO AFP 8% */ 
ASSIGN VAR = 0.
/* FONFO AFP 8% */
IF AVAILABLE PL-AFPS THEN
    var = ROUND( ing-fondo-spp , 2 ) *
    ( fondo-afp / 100 ).
RUN @GRABA(221,'Descuentos').

/* 222 PRIMA DE SEGURO AFP */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^404(4);^222(4)" ).
/* PRIMA DE SEGURO AFP */
IF AVAILABLE PL-AFPS THEN DO:
   IF ing-fondo-spp + VAL-VAR[1] > tope-seguro-afp THEN
        var = tope-seguro-afp *
              ( seguro-invalidez-afp / 100 ).
    ELSE
        var = ROUND( ing-fondo-spp + VAL-VAR[1] , 2 ) *
              ( seguro-invalidez-afp / 100 ).
    var = var - VAL-VAR[2].
END.
RUN @GRABA(222,'Descuentos').

/* 223 APORTE VOLUNTARIO A AFP C/FIN PREVISIONA */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^223(0)" ).
var = VAL-VAR[1].

RUN @GRABA(223,'Descuentos').

/* 225 COMISION (%)  AFP */ 
ASSIGN VAR = 0.
/* COMISION % SOBRE R.A.AFP */
IF AVAILABLE PL-AFPS THEN
    var = ROUND( ing-fondo-spp , 2 ) *
    ( comision-porcentual-afp / 100 ).
RUN @GRABA(225,'Descuentos').

/* 226 Serv AFP(S/.) */ 
ASSIGN VAR = 0.
/* SERV AFP S/. */

IF AVAILABLE PL-AFPS THEN var = comision-fija-afp.

RUN @GRABA(226,'Descuentos').

/* 227 IPSS VIDA */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^227(0)" ).
/* IPSS VIDA */
var = VAL-VAR[1].
RUN @GRABA(227,'Descuentos').

/* 204 CUENTA CORRIENTE */ 
ASSIGN VAR = 0.
/* CTA CORRIENTE */
descuento = 0.
RUN pln/p-odst-m.p(INPUT-OUTPUT VAR, s-CodCal,PL-FLG-MES.CodPln,PL-FLG-MES.CodPer,NETO,TPO-CAMBIO,DESCUENTO,1,1).
RUN pln/p-odst-m.p(INPUT-OUTPUT VAR, s-CodCal,PL-FLG-MES.CodPln,PL-FLG-MES.CodPer,NETO,TPO-CAMBIO,DESCUENTO,1,2).
RUN pln/p-odst-m.p(INPUT-OUTPUT VAR, s-CodCal,PL-FLG-MES.CodPln,PL-FLG-MES.CodPer,NETO,TPO-CAMBIO,DESCUENTO,1,3).
RUN pln/p-odst-m.p(INPUT-OUTPUT VAR, s-CodCal,PL-FLG-MES.CodPln,PL-FLG-MES.CodPer,NETO,TPO-CAMBIO,DESCUENTO,1,4).

RUN @GRABA(204,'Descuentos').

/* 205 ADELANTO */ 
ASSIGN VAR = 0.
/* ADELANTO */
descuento = 0.
RUN pln/p-odst-m.p(INPUT-OUTPUT VAR, s-CodCal,PL-FLG-MES.CodPln,PL-FLG-MES.CodPer,NETO,TPO-CAMBIO,DESCUENTO,2,2).


RUN @GRABA(205,'Descuentos').

/* 301 ESSALUD */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^118(0)" ).
/* IPSS */
var = (( total-remuneracion - no-afecto-rps ) - (VAL-VAR[1] * ing-diario)) *
    ( reg-prest-salud / 100 ).

RUN @GRABA(301,'Aportes').

/* 303 FONAVI (Empleador) */ 
ASSIGN VAR = 0.
/* FONAVI */
var = 0.
/*var = ing-fonavi * ( fonavi / 100 ).*/
RUN @GRABA(303,'Aportes').

/* 305 IMPUESTO EXTRAORDINARIO DE SOLIDARIDAD */ 
ASSIGN VAR = 0.
RUN PLN/P-CALC-M.R(
   integral.PL-FLG-MES.Codcia,
   integral.PL-FLG-MES.PERIODO,
   integral.PL-FLG-MES.NroMes,
   integral.PL-FLG-MES.codpln,
   s-codcal,
   integral.PL-FLG-MES.codper,
   "^118(0)" ).
/* IMP EXT DE SOLIDARIDAD */
var = (ing-fonavi - (VAL-VAR[1] * ing-diario)) * ( fonavi / 100 ).
RUN @GRABA(305,'Aportes').

/* 401 Total Ingresos */ 
ASSIGN VAR = 0.
/* TOTAL INGRESOS */
var = total-remuneracion.
RUN @GRABA(401,'Otros').

/* 402 Total Egresos */ 
ASSIGN VAR = 0.
/* TOTAL EGRESOS */
var = total-descuento.
RUN @GRABA(402,'Otros').

/* 403 Total a Pagar */ 
ASSIGN VAR = 0.
/* TOTAL A  PAGAR */
var = neto.
RUN @GRABA(403,'Otros').

/* 406 Total Aportes */ 
ASSIGN VAR = 0.
/* TOTAL APORTES */
var = total-aporte.
RUN @GRABA(406,'Otros').

PROCEDURE @GRABA.
/*--------------*/

DEFINE INPUT PARAMETER s-CodMov AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER s-TipBol AS CHARACTER NO-UNDO.

FIND FIRST PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = PL-FLG-MES.CodCia AND
    PL-MOV-MES.Periodo = PL-FLG-MES.Periodo AND
    PL-MOV-MES.NroMes  = PL-FLG-MES.NroMes AND
    PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
    PL-MOV-MES.CodCal  = s-CodCal AND
    PL-MOV-MES.CodMov  = s-CodMov NO-ERROR.
IF NOT AVAILABLE PL-MOV-MES THEN DO:
    IF VAR = 0 THEN RETURN.
    CREATE PL-MOV-MES.
    ASSIGN
        PL-MOV-MES.CodCia  = PL-FLG-MES.CodCia
        PL-MOV-MES.Periodo = PL-FLG-MES.Periodo
        PL-MOV-MES.NroMes  = PL-FLG-MES.NroMes
        PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer
        PL-MOV-MES.CodCal  = s-CodCal
        PL-MOV-MES.CodMov  = s-CodMov.
END.
ASSIGN
    PL-MOV-MES.ValCal-MES  = ROUND(VAR, 2)
    PL-MOV-MES.Fch-Ult-Cal = TODAY
    PL-MOV-MES.Hra-Ult-Cal = STRING(TIME,'HH:MM').
IF s-TipBol = 'Remuneraciones' THEN
    ASSIGN
        NETO = NETO + PL-MOV-MES.ValCal-MES
        TOTAL-REMUNERACION = TOTAL-REMUNERACION + PL-MOV-MES.ValCal-MES.
IF s-TipBol = 'Descuentos' THEN
    ASSIGN
        NETO = NETO - PL-MOV-MES.ValCal-MES
        TOTAL-DESCUENTO = TOTAL-DESCUENTO + PL-MOV-MES.ValCal-MES.
IF s-TipBol = 'Aportes' THEN
    ASSIGN TOTAL-APORTE = TOTAL-APORTE + PL-MOV-MES.ValCal-MES.
END PROCEDURE.
