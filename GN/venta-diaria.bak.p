&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 3.69
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pDiasUtiles AS INT.
DEF INPUT PARAMETER pAlmacenes AS CHAR.
DEF OUTPUT PARAMETER pVentaDiaria AS DEC.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.

DEF TEMP-TABLE Detalle
    FIELD FchDoc AS DATE
    FIELD CanDes AS DEC.

FIND Almmmate WHERE ROWID(Almmmate) = pRowid
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN RETURN.

FIND Almmmatg OF Almmmate NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

/* determinamos las fechas de venta */
DEF VAR x-FchIni-Ant AS DATE NO-UNDO.
DEF VAR x-FchFin-Ant AS DATE NO-UNDO.
DEF VAR x-FchIni-Hoy AS DATE NO-UNDO.
DEF VAR x-FchFin-Hoy AS DATE NO-UNDO.

DEF VAR x-Venta-Ant AS DEC NO-UNDO.
DEF VAR x-Venta-Hoy AS DEC NO-UNDO.
DEF VAR x-Venta-Mes AS DEC NO-UNDO.

DEF VAR x-Mes AS INT NO-UNDO.
DEF VAR x-Ano AS INT NO-UNDO.
DEF VAR x-Meses AS INT INIT 3 NO-UNDO.      /* Meses de estudio estadístico */

/* rango del año pasado */
x-Mes = MONTH(TODAY) - x-Meses.
x-Ano = YEAR(TODAY) - 1.
IF x-Mes <= 0 
    THEN ASSIGN 
            x-Mes = x-Mes + 12
            x-Ano = x-Ano - 1.
x-FchIni-Ant = DATE(x-Mes,01,x-Ano).
x-Mes = x-Mes + x-Meses.
IF x-Mes > 12 
    THEN ASSIGN
            x-Mes = x-Mes - 12
            x-Ano = x-Ano + 1.
x-FchFin-Ant = DATE(x-Mes,01,x-Ano) - 1.

RUN Venta-Diaria-Promedio (x-FchIni-Ant, x-FchFin-Ant, pDiasUtiles * x-Meses, OUTPUT x-Venta-Ant).

/* rango del presente año */
x-Mes = MONTH(TODAY) - x-Meses.
x-Ano = YEAR(TODAY).
IF x-Mes <= 0 
    THEN ASSIGN 
            x-Mes = x-Mes + 12
            x-Ano = x-Ano - 1.
x-FchIni-Hoy = DATE(x-Mes,01,x-Ano).
x-Mes = x-Mes + x-Meses.
IF x-Mes > 12 
    THEN ASSIGN
            x-Mes = x-Mes - 12
            x-Ano = x-Ano + 1.
x-FchFin-Hoy = DATE(x-Mes,01,x-Ano) - 1.

RUN Venta-Diaria-Promedio (x-FchIni-Hoy, x-FchFin-Hoy, pDiasUtiles * x-Meses, OUTPUT x-Venta-Hoy).

/* Salidas por ventas del presente mes año pasado */
x-Mes = MONTH(TODAY).
x-Ano = YEAR(TODAY) - 1.
x-FchIni-Ant = DATE(x-Mes,01,x-Ano).
x-Mes = x-Mes + 1.
IF x-Mes > 12 
    THEN ASSIGN
            x-Mes = x-Mes - 12
            x-Ano = x-Ano + 1.
x-FchFin-Ant = DATE(x-Mes,01,x-Ano) - 1.

RUN Venta-Diaria-Promedio (x-FchIni-Ant, x-FchFin-Ant, pDiasUtiles, OUTPUT x-Venta-Mes).

IF x-Venta-Ant > 0 
THEN pVentaDiaria = x-Venta-Hoy / x-Venta-Ant * x-Venta-Mes.
ELSE pVentaDiaria = x-Venta-Hoy.


/* RHC 03.07.09 BLOQUEADO

/* CALCULO DE LA VENTA DIARIA */
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pDiasUtiles AS INT.
DEF OUTPUT PARAMETER pVentaDiaria AS DEC.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.


FIND Almmmate WHERE ROWID(Almmmate) = pRowid
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN RETURN.

FIND Almmmatg OF Almmmate NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

/* determinamos las fechas de venta */
DEF VAR x-FchIni-Ant AS DATE NO-UNDO.
DEF VAR x-FchFin-Ant AS DATE NO-UNDO.
DEF VAR x-FchIni-Hoy AS DATE NO-UNDO.
DEF VAR x-FchFin-Hoy AS DATE NO-UNDO.

DEF VAR x-Mes AS INT NO-UNDO.
DEF VAR x-Ano AS INT NO-UNDO.
DEF VAR x-Meses AS INT INIT 3 NO-UNDO.      /* Meses de estudio estadístico */

/* rango del año pasado */
x-Mes = MONTH(TODAY) - x-Meses.
x-Ano = YEAR(TODAY) - 1.
IF x-Mes <= 0 
    THEN ASSIGN 
            x-Mes = x-Mes + 12
            x-Ano = x-Ano - 1.
x-FchIni-Ant = DATE(x-Mes,01,x-Ano).
x-Mes = x-Mes + x-Meses.
IF x-Mes > 12 
    THEN ASSIGN
            x-Mes = x-Mes - 12
            x-Ano = x-Ano + 1.
x-FchFin-Ant = DATE(x-Mes,01,x-Ano) - 1.

/* rango del presente año */
x-Mes = MONTH(TODAY) - x-Meses.
x-Ano = YEAR(TODAY).
IF x-Mes <= 0 
    THEN ASSIGN 
            x-Mes = x-Mes + 12
            x-Ano = x-Ano - 1.
x-FchIni-Hoy = DATE(x-Mes,01,x-Ano).
x-Mes = x-Mes + x-Meses.
IF x-Mes > 12 
    THEN ASSIGN
            x-Mes = x-Mes - 12
            x-Ano = x-Ano + 1.
x-FchFin-Hoy = DATE(x-Mes,01,x-Ano) - 1.

/* Salidas por ventas del año pasado */
DEF VAR x-Venta-Ant AS DEC NO-UNDO.

FOR EACH almdmov USE-INDEX almd03 NO-LOCK WHERE almdmov.codcia = s-codcia
    AND almdmov.codalm = almmmate.codalm
    AND almdmov.tipmov = 'S'
    AND almdmov.codmov = 02     /* Ventas */
    AND almdmov.fchdoc >= x-FchIni-Ant
    AND almdmov.fchdoc <= x-FchFin-Ant
    AND almdmov.codmat = almmmate.codmat,
    FIRST almcmov OF almdmov NO-LOCK WHERE almcmov.flgest <> 'A':  /* NO anuladas */
    x-Venta-Ant = x-Venta-Ant + almdmov.candes * almdmov.factor.
END.

IF almmmatg.codant <> '' THEN DO:   /* Ventas por el codigo equivalente */
    FOR EACH almdmov USE-INDEX almd03 NO-LOCK WHERE almdmov.codcia = s-codcia
        AND almdmov.codalm = almmmate.codalm
        AND almdmov.tipmov = 'S'
        AND almdmov.codmov = 02     /* Ventas */
        AND almdmov.fchdoc >= x-FchIni-Ant
        AND almdmov.fchdoc <= x-FchFin-Ant
        AND almdmov.codmat = almmmatg.codant,
        FIRST almcmov OF almdmov NO-LOCK WHERE almcmov.flgest <> 'A':  /* NO anuladas */
        x-Venta-Ant = x-Venta-Ant + almdmov.candes * almdmov.factor.
    END.
END.

/* Salidas por ventas del presente año */
DEF VAR x-Venta-Hoy AS DEC NO-UNDO.

FOR EACH almdmov USE-INDEX almd03 NO-LOCK WHERE almdmov.codcia = s-codcia
    AND almdmov.codalm = almmmate.codalm
    AND almdmov.tipmov = 'S'
    AND almdmov.codmov = 02     /* Ventas */
    AND almdmov.fchdoc >= x-FchIni-Hoy
    AND almdmov.fchdoc <= x-FchFin-Hoy
    AND almdmov.codmat = almmmate.codmat,
    FIRST almcmov OF almdmov NO-LOCK WHERE almcmov.flgest <> 'A':  /* NO anuladas */
    x-Venta-Hoy = x-Venta-Hoy + almdmov.candes * almdmov.factor.
END.

IF almmmatg.codant <> '' THEN DO:   /* Ventas por el codigo equivalente */
    FOR EACH almdmov USE-INDEX almd03 NO-LOCK WHERE almdmov.codcia = s-codcia
        AND almdmov.codalm = almmmate.codalm
        AND almdmov.tipmov = 'S'
        AND almdmov.codmov = 02     /* Ventas */
        AND almdmov.fchdoc >= x-FchIni-Hoy
        AND almdmov.fchdoc <= x-FchFin-Hoy
        AND almdmov.codmat = almmmatg.codant,
        FIRST almcmov OF almdmov NO-LOCK WHERE almcmov.flgest <> 'A':  /* NO anuladas */
        x-Venta-Hoy = x-Venta-Hoy + almdmov.candes * almdmov.factor.
    END.
END.

/* Salidas por ventas del presente mes año pasado */
DEF VAR x-Venta-Mes AS DEC NO-UNDO.

x-Mes = MONTH(TODAY).
x-Ano = YEAR(TODAY) - 1.
x-FchIni-Ant = DATE(x-Mes,01,x-Ano).
x-Mes = x-Mes + 1.
IF x-Mes > 12 
    THEN ASSIGN
            x-Mes = x-Mes - 12
            x-Ano = x-Ano + 1.
x-FchFin-Ant = DATE(x-Mes,01,x-Ano) - 1.

FOR EACH almdmov USE-INDEX almd03 NO-LOCK WHERE almdmov.codcia = s-codcia
    AND almdmov.codalm = almmmate.codalm
    AND almdmov.tipmov = 'S'
    AND almdmov.codmov = 02     /* Ventas */
    AND almdmov.fchdoc >= x-FchIni-Ant
    AND almdmov.fchdoc <= x-FchFin-Ant
    AND almdmov.codmat = almmmate.codmat,
    FIRST almcmov OF almdmov NO-LOCK WHERE almcmov.flgest <> 'A':  /* NO anuladas */
    x-Venta-Mes = x-Venta-Mes + almdmov.candes * almdmov.factor.
END.

IF almmmatg.codant <> '' THEN DO:   /* Ventas por el codigo equivalente */
    FOR EACH almdmov USE-INDEX almd03 NO-LOCK WHERE almdmov.codcia = s-codcia
        AND almdmov.codalm = almmmate.codalm
        AND almdmov.tipmov = 'S'
        AND almdmov.codmov = 02     /* Ventas */
        AND almdmov.fchdoc >= x-FchIni-Ant
        AND almdmov.fchdoc <= x-FchFin-Ant
        AND almdmov.codmat = almmmatg.codant,
        FIRST almcmov OF almdmov NO-LOCK WHERE almcmov.flgest <> 'A':  /* NO anuladas */
        x-Venta-Mes = x-Venta-Mes + almdmov.candes * almdmov.factor.
    END.
END.

IF x-Venta-Ant > 0 
    THEN pVentaDiaria = x-Venta-Hoy / x-Venta-Ant * x-Venta-Mes / pDiasUtiles.
    ELSE pVentaDiaria = x-Venta-Mes / pDiasUtiles.

********************************************************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Venta-Diaria-Promedio) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Venta-Diaria-Promedio Procedure 
PROCEDURE Venta-Diaria-Promedio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pFchIni AS DATE.
DEF INPUT PARAMETER pFchFin AS DATE.
DEF INPUT PARAMETER pTotalDias AS INT.
DEF OUTPUT PARAMETER pVtaPromedio AS DEC.

DEF VAR x-Items AS INT NO-UNDO.
DEF VAR x-Promedio AS DEC NO-UNDO.
DEF VAR x-Desviacion AS DEC NO-UNDO.
DEF VAR x-Almacenes AS CHAR NO-UNDO.
DEF VAR k AS INT NO-UNDO.

/* CALCULO ESTADISTICO DE LAS VENTAS DIARIAS */
pVtaPromedio = 0.

FOR EACH Detalle:
    DELETE Detalle.
END.

/* Buscamos las ventas de todos los almacenes involucrados */
x-Almacenes = Almmmate.CodAlm.
DO k = 1 TO NUM-ENTRIES(pAlmacenes):
    IF ENTRY(k, pAlmacenes) <> Almmmate.CodAlm 
    THEN x-Almacenes = TRIM(x-Almacenes) + ',' + ENTRY(k, pAlmacenes).
END.
/* Ventas de TODOS los almacenes */
DO k = 1 TO NUM-ENTRIES(x-Almacenes):
    FOR EACH almdmov USE-INDEX almd03 NO-LOCK WHERE almdmov.codcia = s-codcia
        AND almdmov.codalm = ENTRY(k, x-Almacenes)
        AND almdmov.tipmov = 'S'
        AND almdmov.codmov = 02     /* Ventas */
        AND almdmov.fchdoc >= pFchIni
        AND almdmov.fchdoc <= pFchFin
        AND almdmov.codmat = almmmate.codmat,
        FIRST almcmov OF almdmov NO-LOCK WHERE almcmov.flgest <> 'A':  /* NO anuladas */
        FIND Detalle WHERE Detalle.FchDoc = Almdmov.fchdoc NO-ERROR.
        IF NOT AVAILABLE Detalle THEN CREATE Detalle.
        ASSIGN
            Detalle.fchdoc = Almdmov.fchdoc
            Detalle.candes = Detalle.candes + almdmov.candes * almdmov.factor.
    END.
    IF almmmatg.codant <> '' THEN DO:   /* Ventas por el codigo equivalente */
        FOR EACH almdmov USE-INDEX almd03 NO-LOCK WHERE almdmov.codcia = s-codcia
            AND almdmov.codalm = ENTRY(k, x-Almacenes)
            AND almdmov.tipmov = 'S'
            AND almdmov.codmov = 02     /* Ventas */
            AND almdmov.fchdoc >= pFchIni
            AND almdmov.fchdoc <= pFchFin
            AND almdmov.codmat = almmmatg.codant,
            FIRST almcmov OF almdmov NO-LOCK WHERE almcmov.flgest <> 'A':  /* NO anuladas */
            FIND Detalle WHERE Detalle.FchDoc = Almdmov.fchdoc NO-ERROR.
            IF NOT AVAILABLE Detalle THEN CREATE Detalle.
            ASSIGN
                Detalle.fchdoc = Almdmov.fchdoc
                Detalle.candes = Detalle.candes + almdmov.candes * almdmov.factor.
        END.
    END.
END.
/* Desviacion estandar */
FOR EACH Detalle:
    x-Items = x-Items + 1.
    x-Promedio = x-Promedio + Detalle.candes.
END.
IF x-Items > 0 
THEN x-Promedio = x-Promedio / pTotalDias.      /*x-Items.*/
ELSE RETURN.
FOR EACH Detalle:
    x-Desviacion = x-Desviacion + EXP( ( Detalle.CanDes - x-Promedio ) , 2 ).
END.
/*x-Desviacion = SQRT ( x-Desviacion / ( x-Items - 1 ) ).*/
x-Desviacion = SQRT ( x-Desviacion / ( pTotalDias - 1 ) ).

/* Eliminamos los items que están fuera de rango */
FOR EACH Detalle:
    IF Detalle.candes > (x-Promedio + 3 * x-Desviacion)
        OR Detalle.candes < (x-Promedio - 3 * x-Desviacion) THEN DO:
        DELETE Detalle.
    END.
END.
x-Items = 0.
x-Promedio = 0.
FOR EACH Detalle:
    x-Items = x-Items + 1.
    x-Promedio = x-Promedio + Detalle.candes.
END.
pVtaPromedio = x-Promedio / pTotalDias.     /*x-Items.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

