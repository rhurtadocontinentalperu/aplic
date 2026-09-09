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

total_ingresos = 0.
total_dias = 0.

REPEAT:
    s-task-no = RANDOM(1, 999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN LEAVE.
END.

/* Empleados */ 
/* Boleta de Remuneraciones */
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados */
    PL-MOV-MES.CodCal = 01 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 101 OR                                 /* Basico */
    PL-MOV-MES.CodMov = 103 OR                                  /* Asig. Familiar */
    PL-MOV-MES.CodMov = 106 OR                                  /* Vacacional */
    PL-MOV-MES.CodMov = 107 OR                                  /* Vacaciones Trabajadas*/
    PL-MOV-MES.CodMov = 108 OR                                  /* Vacaciones Truncas */
    PL-MOV-MES.CodMov = 118 OR                                  /* Descanso medico */
    PL-MOV-MES.CodMov = 125 OR                                  /* HE 25% */
    PL-MOV-MES.CodMov = 126 OR                                  /* HE 100% */
    PL-MOV-MES.CodMov = 127 OR                                  /* HE 35% */
    PL-MOV-MES.CodMov = 131 OR                                  /* Bonificacion Incentivo */
    PL-MOV-MES.CodMov = 134 OR                                  /* Bonificacion Especial */
    PL-MOV-MES.CodMov = 136 OR                                  /* Reintegro */
    PL-MOV-MES.CodMov = 138 OR                                  /* Asignación Extraordinaria */
    PL-MOV-MES.CodMov = 139 OR                                  /* Gratificacion Trunca */
    PL-MOV-MES.CodMov = 801 OR                                  /* Bonificacion por Produccion */
    PL-MOV-MES.CodMov = 802 OR                                  /* Bonificacion Nocturna */
    PL-MOV-MES.CodMov = 803 OR                                  /* Subsidio Pre-Post Natal */
     PL-MOV-MES.CodMov = 130 OR                                  /* Otros Ingresos */
     PL-MOV-MES.CodMov = 146 OR                                  /* Riesgo de Caja */
     PL-MOV-MES.CodMov = 209 OR                                  /* Comisiones */
    PL-MOV-MES.CodMov = 100)                                    /* Dias Calendarios */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    DISPLAY
        "   Mes: " + STRING(PL-MOV-MES.NroMes) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.

    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    CASE PL-MOV-MES.CodMov:
        WHEN 100 THEN DO:
            w-report.Campo-F[2] = w-report.Campo-F[2] + PL-MOV-MES.ValCal-Mes.
            total_dias = total_dias + PL-MOV-MES.ValCal-Mes.
        END.
        OTHERWISE DO:
            w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
            total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
        END.
    END CASE.
END.
/* Boleta de Gratificaciones */
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 04 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    PL-MOV-MES.CodMov = 212                                     /* Gratificacion */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    DISPLAY
        "   Mes: " + STRING(PL-MOV-MES.NroMes) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.

    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.
/* Liquidacion */
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 05 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 431 OR                                  /* Liq Acumulada */
    PL-MOV-MES.CodMov = 139)                                     /* Gratificacion Trunca */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    DISPLAY
        "   Mes: " + STRING(PL-MOV-MES.NroMes) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.

    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.
/* Liquidacion de Eventuales */
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 08 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 431 OR                                 /* Acumu. Vacaciones */
    PL-MOV-MES.CodMov = 611)                                    /* Gratificacion Trunca */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    DISPLAY
        "   Mes: " + STRING(PL-MOV-MES.NroMes) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.

    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


