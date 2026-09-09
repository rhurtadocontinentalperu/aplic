&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE PROMEDIO-RIESGO-CAJA AS DECIMAL NO-UNDO.
IF mes-actual <> 7 AND mes-actual <> 12 THEN RETURN.
/* Si su contrato ya vencio */
IF ( PL-FLG-MES.Vcontr <> ? AND
    PL-FLG-MES.Vcontr < fecha-inicio-mes ) THEN RETURN.
IF PL-FLG-MES.Vcontr <> ? THEN DO:
   IF mes-actual = 7 THEN
      IF PL-FLG-MES.Vcontr < DATE (07, 01, s-periodo)
         THEN  RETURN.
   ELSE
      IF PL-FLG-MES.Vcontr < DATE (12, 01, s-periodo)
         THEN  RETURN.
END.
DEFINE VARIABLE rem-ordinaria     AS DECIMAL NO-UNDO.
DEFINE VARIABLE remuneracion-fija AS DECIMAL NO-UNDO.
DEFINE VARIABLE ing-diario        AS DECIMAL NO-UNDO.
DEFINE VARIABLE acumulado-hex     AS DECIMAL NO-UNDO.
DEFINE VARIABLE ACUMULADO-HEX-126 AS DECIMAL NO-UNDO.
DEFINE VARIABLE ACUMULADO-NOCTURNIDAD AS DECIMAL NO-UNDO.
DEFINE VARIABLE dias-trabajados   AS DECIMAL NO-UNDO.
DEFINE VARIABLE faltas-injustificadas AS DECIMAL NO-UNDO.
DEFINE VARIABLE ing-fondo-spp     AS DECIMAL NO-UNDO.
DEFINE VARIABLE ing-fondo-snp     AS DECIMAL NO-UNDO.
DEFINE VARIABLE ing-fonavi        AS DECIMAL NO-UNDO.
DEFINE VARIABLE no-afecto-rps     AS DECIMAL NO-UNDO.
DEFINE VARIABLE no-afecto-5ta     AS DECIMAL NO-UNDO.
DEFINE VARIABLE no-afecto-senati  AS DECIMAL NO-UNDO.
DEFINE VARIABLE factor            AS DECIMAL NO-UNDO.
DEFINE VARIABLE VEC-i             AS DECIMAL NO-UNDO.
DEFINE VARIABLE MAX-i             AS DECIMAL NO-UNDO.
DEFINE VARIABLE ANO-i             AS INTEGER NO-UNDO.
DEFINE VARIABLE MES-i             AS INTEGER NO-UNDO.
DEFINE VARIABLE VAR-i             AS INTEGER NO-UNDO.
DEFINE VARIABLE ULT-i             AS INTEGER NO-UNDO.
DEFINE VARIABLE X-FACVAC          AS INTEGER NO-UNDO.
/* RHC NUEVAS DEFINE VARIABLES */
DEFINE VARIABLE FECHA-INGRESO     AS DATE NO-UNDO.
DEFINE VARIABLE PROMEDIO-ALIMENTACION AS DECIMAL NO-UNDO.
DEFINE VARIABLE MESES-SERV-HHEE  AS INTEGER NO-UNDO.
DEFINE VARIABLE MESES-SERV-NOCTURNIDAD AS INTEGER NO-UNDO.
DEFINE VARIABLE MESES-SERV-COM   AS INTEGER NO-UNDO.
DEFINE VARIABLE SUELDO-MES-ANTERIOR AS INTEGER NO-UNDO.
DEFINE VARIABLE ASIGNACION-FAMILIAR-MES-ANTERIOR AS INTEGER NO-UNDO.
/* BUSCAMOS IMPORTES MES ANTERIOR */
FIND PL-MOV-MES WHERE PL-MOV-MES.codcia = PL-FLG-MES.codcia
AND PL-MOV-MES.periodo = PL-FLG-MES.periodo
AND PL-MOV-MES.nromes  = PL-FLG-MES.nromes - 1
AND PL-MOV-MES.codmov = 101     /* SUELDO */
AND PL-MOV-MES.codcal = 000     /* MANUAL */
AND PL-MOV-MES.codper = PL-FLG-MES.codper
NO-LOCK NO-ERROR.
IF AVAILABLE PL-MOV-MES THEN SUELDO-MES-ANTERIOR = PL-MOV-MES.valcal-mes.
FIND PL-MOV-MES WHERE PL-MOV-MES.codcia = PL-FLG-MES.codcia
AND PL-MOV-MES.periodo = PL-FLG-MES.periodo
AND PL-MOV-MES.nromes  = PL-FLG-MES.nromes - 1
AND PL-MOV-MES.codmov = 103     /* ASIGNACION FAMILIAR */
AND PL-MOV-MES.codcal = 000     /* MANUAL */
AND PL-MOV-MES.codper = PL-FLG-MES.codper
NO-LOCK NO-ERROR.
IF AVAILABLE PL-MOV-MES THEN ASIGNACION-FAMILIAR-MES-ANTERIOR = PL-MOV-MES.valcal-mes.
FECHA-INGRESO = PL-FLG-MES.FecIng.
remuneracion-fija = ^101(0) + ^103(0) + ^134(0) +
                    ^140(0) + ^141(0).
ing-diario = remuneracion-fija / 30.
IF ^100(0) > 0 THEN dias-trabajados = ^100(0).
ELSE dias-trabajados = 30.
/* FACTOR DE LA GRATIFICACION */
DEFINE VARIABLE FECHA-CIERRE AS DATE NO-UNDO.
DEFINE VARIABLE FECHA-INICIO AS DATE NO-UNDO.
DEFINE VARIABLE MESES-SERV-GRATI AS INTEGER NO-UNDO.
DEFINE VARIABLE ANOS-TRAB    AS DECIMAL NO-UNDO.
DEFINE VARIABLE MESES-TRAB   AS DECIMAL NO-UNDO.
DEFINE VARIABLE DIAS-TRAB    AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-INICIO     AS DATE NO-UNDO.
DEFINE VARIABLE F-INICIO-2   AS DATE NO-UNDO.
/* VERIFICAMOS SI SE PAGO GRATIFICACION  */
IF mes-actual = 7 THEN
   IF PL-FLG-MES.Vcontr = ? THEN
      FECHA-CIERRE = DATE(06, 30, S-PERIODO).
   ELSE
      FECHA-CIERRE = 
           MINIMUM( DATE(06, 30, S-PERIODO), PL-FLG-MES.Vcontr).
ELSE 
   IF PL-FLG-MES.Vcontr = ? THEN
      FECHA-CIERRE = DATE(12, 30, S-PERIODO).
   ELSE   
      FECHA-CIERRE = 
           MINIMUM( DATE(12, 30, S-PERIODO), PL-FLG-MES.Vcontr).
IF MONTH(PL-FLG-MES.FECING) = 12 THEN
   F-INICIO =  IF DAY(PL-FLG-MES.FECING) = 01 THEN PL-FLG-MES.FECING 
               ELSE DATE(01, 01, YEAR(PL-FLG-MES.FECING) + 1).
ELSE
   F-INICIO =  IF DAY(PL-FLG-MES.FECING) = 01 THEN PL-FLG-MES.FECING 
               ELSE DATE(MONTH(PL-FLG-MES.FECING) + 1, 01, YEAR(PL-FLG-MES.FECING)).
IF mes-actual = 7 THEN
   FECHA-INICIO = 
        MAXIMUM( DATE(01, 01, S-PERIODO), F-INICIO).
ELSE
   FECHA-INICIO = 
        MAXIMUM( DATE(06, 01, S-PERIODO), F-INICIO).
IF FECHA-CIERRE < FECHA-INICIO THEN
   FECHA-CIERRE = ?.
MESES-SERV-GRATI  = 0.
IF FECHA-CIERRE <> ? THEN DO:
    /* RHC 03.12.04 BLOQUEADO
   F-INICIO-2 = 
        MINIMUM( DATE(07, 01, S-PERIODO), F-INICIO).
   RUN PLN/P-TSERV.P( 
           F-INICIO-2,
           FECHA-CIERRE,
           OUTPUT ANOS-TRAB,OUTPUT MESES-TRAB,OUTPUT DIAS-TRAB).
    ************************* */
    RUN PLN/P-TSERV (FECHA-INICIO - 1,
                    FECHA-CIERRE,
                    OUTPUT ANOS-TRAB,OUTPUT MESES-TRAB, OUTPUT DIAS-TRAB).

   MESES-SERV-GRATI = ANOS-TRAB * 12 + MESES-TRAB + DIAS-TRAB / 30.
   IF MESES-SERV-GRATI >= 6 THEN 
      MESES-SERV-GRATI = 6.
END.
factor = (MESES-SERV-GRATI / 6).
/* REVIZA VACACIONES */
VEC-i = 0.
MAX-i = 0.
ANO-i = s-Periodo.
MES-i = MES-ACTUAL.
IF MES-i = 1 THEN
   ASSIGN
      MES-i = 12
      ANO-i = s-Periodo - 1.
ELSE
   ASSIGN
      MES-i = MES-i - 1.
    /*  ANO-i = ANO-I - 1.*/
DO VAR-i = 1 TO 6:
    FOR EACH PL-MOV-MES WHERE 
        PL-MOV-MES.CodCia  = s-CodCia          AND
        PL-MOV-MES.Periodo = ANO-i             AND
        PL-MOV-MES.NroMes  = MES-i             AND
        PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
        PL-MOV-MES.CodCal  = 1                 AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        PL-MOV-MES.CODMOV  = 106                
        NO-LOCK :
        IF FECHA-INICIO <= DATE( MES-i, 01, ANO-i) THEN DO:
           ACUMULADO-HEX = ACUMULADO-HEX + PL-MOV-MES.ValCal-Mes.
           MAX-i = MAX-i + 1.
           IF MAX-i = 1 THEN VEC-i = VEC-i + 1.
        END.
    END.
    MAX-i = 0.
    MES-i = MES-i - 1.
    IF MES-i = 0 THEN 
       ASSIGN MES-i = 12
              ANO-i = ANO-i - 1.
END.
X-FACVAC = IF VEC-i > 0 THEN 1 ELSE 0.
/* ACUMULADO DE HORAS EXTRAS */
ACUMULADO-HEX = 0.
VEC-i = 0.
MAX-i = 0.
ANO-i = s-Periodo.
MES-i = MES-ACTUAL.
DO VAR-i = 1 TO 7:
    FIND FIRST PL-MOV-MES WHERE 
        PL-MOV-MES.CodCia  = s-CodCia          AND
        PL-MOV-MES.Periodo = ANO-i             AND
        PL-MOV-MES.NroMes  = MES-i             AND
        PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
        PL-MOV-MES.CodCal  = 1                 AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        (PL-MOV-MES.CODMOV = 125               OR
        PL-MOV-MES.CODMOV = 127)
        NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-MES THEN DO:
        ASSIGN
            VEC-i = VEC-i + 1.
        /* RHC 19.03.10 acumulamos */
        FOR EACH PL-MOV-MES WHERE 
                PL-MOV-MES.CodCia  = s-CodCia          AND
                PL-MOV-MES.Periodo = ANO-i             AND
                PL-MOV-MES.NroMes  = MES-i             AND
                PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
                PL-MOV-MES.CodCal  = 1                 AND
                PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
                (PL-MOV-MES.CODMOV = 125               OR
                PL-MOV-MES.CODMOV = 127)
                NO-LOCK:
            ASSIGN
                ACUMULADO-HEX = ACUMULADO-HEX + PL-MOV-MES.ValCal-Mes.
        END.
    END.
    MES-i = MES-i - 1.
    IF MES-i = 0 THEN
        ASSIGN
            MES-i = 12
            ANO-i = ANO-i - 1.
    /* RHC 22.06.10 VERIFICAMOS LA FECHA DE INGRESO */
    IF YEAR(FECHA-INGRESO) = ANO-i 
        AND MONTH(FECHA-INGRESO) > MES-i THEN LEAVE.
    IF YEAR(FECHA-INGRESO) > ANO-i THEN LEAVE.
END.
IF YEAR(FECHA-INGRESO) < s-Periodo
THEN MESES-SERV-HHEE = 6.
ELSE MESES-SERV-HHEE = MES-ACTUAL - MONTH(FECHA-INGRESO).
IF VEC-i < 3 THEN ACUMULADO-HEX = 0.
IF VEC-i > 0 THEN ACUMULADO-HEX = ACUMULADO-HEX / MINIMUM(6,MESES-SERV-HHEE).
/* RHC 09.07.10 ACUMULADO DE HORAS EXTRAS CONCEPTO 126 */
ACUMULADO-HEX-126 = 0.
VEC-i = 0.
MAX-i = 0.
ANO-i = s-Periodo.
MES-i = MES-ACTUAL.
IF MES-i = 1 THEN
   ASSIGN
      MES-i = 12
      ANO-i = s-Periodo - 1.
ELSE
   ASSIGN
      MES-i = MES-i - 1.
    /*  ANO-i = ANO-I - 1.*/
DO VAR-i = 1 TO 7:
    FOR EACH PL-MOV-MES WHERE 
        PL-MOV-MES.CodCia  = s-CodCia          AND
        PL-MOV-MES.Periodo = ANO-i             AND
        PL-MOV-MES.NroMes  = MES-i             AND
        PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
        PL-MOV-MES.CodCal  = 1                 AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        PL-MOV-MES.CODMOV = 126
             NO-LOCK :
        IF FECHA-INICIO <= DATE( MES-i, 01, ANO-i) THEN DO:
           ACUMULADO-HEX-126 = ACUMULADO-HEX-126 + PL-MOV-MES.ValCal-Mes.
           MAX-i = MAX-i + 1.
           IF MAX-i = 1 THEN VEC-i = VEC-i + 1.
        END.
    END.
    MAX-i = 0.
    MES-i = MES-i - 1.
    IF MES-i = 0 THEN 
       ASSIGN MES-i = 12
              ANO-i = ANO-i - 1.
END.
IF VEC-i < 3 THEN ACUMULADO-HEX-126 = 0.
/* RHC 09.07.10 SOLO LOS MESES QUE HA TRABAJADO*/
IF VEC-i > 0 THEN ACUMULADO-HEX-126 = ACUMULADO-HEX-126 / MINIMUM(6,MESES-SERV-HHEE).
/* ************************************************************************ */
/* ACUMULADO DE NOCTURNIDAD */
VEC-i = 0.
MAX-i = 0.
ANO-i = s-Periodo.
MES-i = MES-ACTUAL.
DO VAR-i = 1 TO 7:
    FIND FIRST PL-MOV-MES WHERE 
        PL-MOV-MES.CodCia  = s-CodCia          AND
        PL-MOV-MES.Periodo = ANO-i             AND
        PL-MOV-MES.NroMes  = MES-i             AND
        PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
        PL-MOV-MES.CodCal  = 1                 AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        PL-MOV-MES.CODMOV = 802
        NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-MES THEN DO:
        ASSIGN
            VEC-i = VEC-i + 1.
    END.
    MES-i = MES-i - 1.
    IF MES-i = 0 THEN
        ASSIGN
            MES-i = 12
            ANO-i = ANO-i - 1.
    /* RHC 22.06.10 VERIFICAMOS LA FECHA DE INGRESO */
    IF YEAR(FECHA-INGRESO) = ANO-i 
        AND MONTH(FECHA-INGRESO) > MES-i THEN LEAVE.
    IF YEAR(FECHA-INGRESO) > ANO-i THEN LEAVE.
END.
IF YEAR(FECHA-INGRESO) < s-Periodo
THEN MESES-SERV-NOCTURNIDAD = 6.
ELSE MESES-SERV-NOCTURNIDAD = MES-ACTUAL - MONTH(FECHA-INGRESO).
/* RHC 09.12.2011 NOCTURNIDAD CONCEPTO 802 */
ACUMULADO-NOCTURNIDAD = 0.
VEC-i = 0.
MAX-i = 0.
ANO-i = s-Periodo.
MES-i = MES-ACTUAL.
IF MES-i = 1 THEN
   ASSIGN
      MES-i = 12
      ANO-i = s-Periodo - 1.
ELSE
   ASSIGN
      MES-i = MES-i - 1.
DO VAR-i = 1 TO 7:
    FOR EACH PL-MOV-MES WHERE 
        PL-MOV-MES.CodCia  = s-CodCia          AND
        PL-MOV-MES.Periodo = ANO-i             AND
        PL-MOV-MES.NroMes  = MES-i             AND
        PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
        PL-MOV-MES.CodCal  = 1                 AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        PL-MOV-MES.CODMOV = 802
             NO-LOCK :
        IF FECHA-INICIO <= DATE( MES-i, 01, ANO-i) THEN DO:
           ACUMULADO-NOCTURNIDAD = ACUMULADO-NOCTURNIDAD + PL-MOV-MES.ValCal-Mes.
           MAX-i = MAX-i + 1.
           IF MAX-i = 1 THEN VEC-i = VEC-i + 1.
        END.
    END.
    MAX-i = 0.
    MES-i = MES-i - 1.
    IF MES-i = 0 THEN 
       ASSIGN MES-i = 12
              ANO-i = ANO-i - 1.
END.
IF VEC-i < 3 THEN ACUMULADO-NOCTURNIDAD = 0.
/* RHC 09.07.10 SOLO LOS MESES QUE HA TRABAJADO*/
IF VEC-i > 0 THEN ACUMULADO-NOCTURNIDAD = ACUMULADO-NOCTURNIDAD / MINIMUM(6,MESES-SERV-NOCTURNIDAD).
/* RHC 09.07.10 PROMEDIO ALIMENTACION */
PROMEDIO-ALIMENTACION = 0.
VEC-i = 0.
ANO-i = s-Periodo.
MES-i = MES-ACTUAL.
IF YEAR(FECHA-INGRESO) < s-Periodo
THEN MESES-SERV-COM = 6.
ELSE MESES-SERV-COM = MES-ACTUAL - MONTH(FECHA-INGRESO).
IF MES-ACTUAL = 12 THEN ASSIGN MES-i = 11 MESES-SERV-COM = MESES-SERV-COM + 1.
IF MES-ACTUAL = 7  THEN ASSIGN MES-i = 6.
DO VAR-i = 1 TO 6:
    FOR EACH PL-MOV-MES WHERE 
        PL-MOV-MES.CodCia  = s-CodCia          AND
        PL-MOV-MES.Periodo = ANO-i             AND
        PL-MOV-MES.NroMes  = MES-i             AND
        PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
        PL-MOV-MES.CodCal  = 1                 AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        PL-MOV-MES.CODMOV  = 117               NO-LOCK :
        PROMEDIO-ALIMENTACION = PROMEDIO-ALIMENTACION + PL-MOV-MES.ValCal-Mes.
        VEC-i = VEC-i + 1.
    END.
    MES-i = MES-i - 1.
    IF MES-i = 0
    THEN ASSIGN MES-i = 12
                ANO-i = ANO-i - 1.
    /* RHC 22.06.10 VERIFICAMOS LA FECHA DE INGRESO */
    IF YEAR(FECHA-INGRESO) = ANO-i 
        AND MONTH(FECHA-INGRESO) > MES-i THEN LEAVE.
    IF YEAR(FECHA-INGRESO) > ANO-i THEN LEAVE.
END.
IF VEC-i < 3 THEN PROMEDIO-ALIMENTACION = 0.
IF VEC-i > 0 THEN PROMEDIO-ALIMENTACION = PROMEDIO-ALIMENTACION / MINIMUM(6,MESES-SERV-COM).
/* ACUMULADO DE COMISION */
DEFINE VARIABLE ACUMULADO-COMISION AS DECIMAL NO-UNDO.
ACUMULADO-COMISION = 0.
VEC-i = 0.
ANO-i = s-Periodo.
MES-i = MES-ACTUAL.
IF YEAR(FECHA-INGRESO) < s-Periodo
THEN MESES-SERV-COM = 6.
ELSE MESES-SERV-COM = MES-ACTUAL - MONTH(FECHA-INGRESO).
IF MES-ACTUAL = 12 THEN ASSIGN MES-i = 11 MESES-SERV-COM = MESES-SERV-COM + 1.
IF MES-ACTUAL = 7  THEN ASSIGN MES-i = 6.
DO VAR-i = 1 TO 6:
    FOR EACH PL-MOV-MES WHERE 
        PL-MOV-MES.CodCia  = s-CodCia          AND
        PL-MOV-MES.Periodo = ANO-i             AND
        PL-MOV-MES.NroMes  = MES-i             AND
        PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
        PL-MOV-MES.CodCal  = 1                 AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        PL-MOV-MES.CODMOV  = 209               NO-LOCK :
        ACUMULADO-COMISION = ACUMULADO-COMISION + PL-MOV-MES.ValCal-Mes.
        VEC-i = VEC-i + 1.
    END.
    MES-i = MES-i - 1.
    IF MES-i = 0
    THEN ASSIGN MES-i = 12
                ANO-i = ANO-i - 1.
    /* RHC 22.06.10 VERIFICAMOS LA FECHA DE INGRESO */
    IF YEAR(FECHA-INGRESO) = ANO-i 
        AND MONTH(FECHA-INGRESO) > MES-i THEN LEAVE.
    IF YEAR(FECHA-INGRESO) > ANO-i THEN LEAVE.
END.
IF VEC-i < 3 THEN ACUMULADO-COMISION = 0.
IF VEC-i > 0 THEN ACUMULADO-COMISION = ACUMULADO-COMISION / MINIMUM(6,MESES-SERV-COM).
/* ACUMULADO DE BONIFICACION POR INCENTIVO  */
DEFINE VARIABLE ACUMULADO-BONIFI AS DECIMAL NO-UNDO.
ACUMULADO-BONIFI = 0.
VEC-i = 0.
ANO-i = s-Periodo.
MES-i = MES-ACTUAL.
IF YEAR(FECHA-INGRESO) < s-Periodo
THEN MESES-SERV-COM = 6.
ELSE MESES-SERV-COM = MES-ACTUAL - MONTH(FECHA-INGRESO).
IF MES-ACTUAL = 12 THEN ASSIGN MES-i = 11 MESES-SERV-COM = MESES-SERV-COM + 1.
IF MES-ACTUAL = 7  THEN ASSIGN MES-i = 6.
DO VAR-i = 1 TO 6:
    FOR EACH PL-MOV-MES WHERE 
        PL-MOV-MES.CodCia  = s-CodCia          AND
        PL-MOV-MES.Periodo = ANO-i             AND
        PL-MOV-MES.NroMes  = MES-i             AND
        PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
        PL-MOV-MES.CodCal  = 1                 AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        PL-MOV-MES.CODMOV  = 131               NO-LOCK :
        ACUMULADO-BONIFI = ACUMULADO-BONIFI + PL-MOV-MES.ValCal-Mes.
        VEC-i = VEC-i + 1.
    END.
    MES-i = MES-i - 1.
    IF MES-i = 0
    THEN ASSIGN MES-i = 12
                ANO-i = ANO-i - 1.
    /* RHC 22.06.10 VERIFICAMOS LA FECHA DE INGRESO */
    IF YEAR(FECHA-INGRESO) = ANO-i 
        AND MONTH(FECHA-INGRESO) > MES-i THEN LEAVE.
    IF YEAR(FECHA-INGRESO) > ANO-i THEN LEAVE.
END.
IF VEC-i < 3 THEN ACUMULADO-BONIFI = 0.
IF VEC-i > 0 THEN ACUMULADO-BONIFI = ACUMULADO-BONIFI / MINIMUM(6,MESES-SERV-COM).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


