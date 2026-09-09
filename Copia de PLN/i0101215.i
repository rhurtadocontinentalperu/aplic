&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
/* CALCULO DE IMPUESTO A LA RENTA DE QUINTA CATEGORIA */
DEF VAR AFECTO-QUINTA-CATEGORIA AS DEC INIT 0 NO-UNDO.
DEF VAR PROMEDIO-HORAS-EXTRAS AS DEC INIT 0 NO-UNDO.
DEF VAR PROMEDIO-COMISIONES AS DEC INIT 0 NO-UNDO.
DEF VAR REMUNERACION-MESES-ANTERIORES AS DEC INIT 0 NO-UNDO.
DEF VAR REMUNERACION-PROYECTADA AS DEC INIT 0 NO-UNDO.
DEF VAR GRATIFICACION-PROYECTADA AS DEC INIT 0 NO-UNDO.
DEF VAR IMPUESTO-RETENIDO-QUINTA AS DE INIT 0 NO-UNDO.
DEF VAR BASE-IMPONIBLE-QUINTA AS DE INIT 0 NO-UNDO.

DEF VAR x-Contador AS INT NO-UNDO.
DEF VAR x-MES AS INT NO-UNDO.
DEF VAR x-ANO AS INT NO-UNDO.

VAR = 0.     /* VALOR POR DEFECTO */

/* SI INGRESA ESTE MES O ES ABRIL, AGOSTO O DICIEMBRE SE CALCULA TODO */
IF (PL-FLG-MES.FecIng >= FECHA-INICIO-MES OR PL-FLG-MES.FecIng <= FECHA-FIN-MES)
    OR (MES-ACTUAL = 01 OR MES-ACTUAL = 04 OR MES-ACTUAL = 08 OR MES-ACTUAL = 12)
THEN DO:
    /* RENTA BRUTA MENSUAL */
    AFECTO-QUINTA-CATEGORIA = ^101(0) + ^103(0) + ^134(0).
    /* PROMEDIO HORAS EXTRAS */
    ASSIGN
        x-MES = MES-ACTUAL
        x-ANO = s-periodo.
    DO x-Contador = 1 TO 4:
        FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.codcia = s-codcia
                AND PL-MOV-MES.periodo = x-ANO
                AND PL-MOV-MES.nromes  = x-MES
                AND PL-MOV-MES.codpln  = PL-FLG-MES.codpln
                AND PL-MOV-MES.codper  = PL-FLG-MES.codper
                AND PL-MOV-MES.codcal  = 001    /* Sueldos */
                AND (PL-MOV-MES.codmov  = 125
                    OR PL-MOV-MES.codmov = 126
                    OR PL-MOV-MES.codmov = 127):
            PROMEDIO-HORAS-EXTRAS = PROMEDIO-HORAS-EXTRAS + PL-MOV-MES.valcal-mes.
        END.
        x-MES = x-MES - 1.
        IF x-MES <= 0
        THEN ASSIGN
                x-MES = 12
                x-ANO = x-ANO - 1.
    END.    
    PROMEDIO-HORAS-EXTRAS = PROMEDIO-HORAS-EXTRAS / 4.
    /* PROMEDIO COMISIONES */
    ASSIGN
        x-MES = MES-ACTUAL
        x-ANO = s-periodo.
    DO x-Contador = 1 TO 4:
        FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.codcia = s-codcia
                AND PL-MOV-MES.periodo = x-ANO
                AND PL-MOV-MES.nromes  = x-MES
                AND PL-MOV-MES.codpln  = PL-FLG-MES.codpln
                AND PL-MOV-MES.codper  = PL-FLG-MES.codper
                AND PL-MOV-MES.codcal  = 001    /* Sueldos */
                AND PL-MOV-MES.codmov  = 209:
            PROMEDIO-COMISIONES = PROMEDIO-COMISIONES + PL-MOV-MES.valcal-mes.
        END.
        x-MES = x-MES - 1.
        IF x-MES <= 0
        THEN ASSIGN
                x-MES = 12
                x-ANO = x-ANO - 1.
    END.    
    PROMEDIO-COMISIONES = PROMEDIO-COMISIONES / 4.
    /* REMUNERACION MESES ANTERIORES */
    REMUNERACION-MESES-ANTERIORES = $401(1).
    /* PROYECCION DE REMUNERACIONES */
    REMUNERACION-PROYECTADA = ( AFECTO-QUINTA-CATEGORIA + 
                                PROMEDIO-HORAS-EXTRAS +
                                PROMEDIO-COMISIONES ) * (12 - MES-ACTUAL) +
                                TOTAL-REMUNERACION.
    /* GRATIFICACIONES PROYECTADAS */
    IF MES-ACTUAL < 7
    THEN GRATIFICACION-PROYECTADA = AFECTO-QUINTA-CATEGORIA * 2.
    ELSE IF MES-ACTUAL < 12
        THEN GRATIFICACION-PROYECTADA = AFECTO-QUINTA-CATEGORIA * 1 + $401(4).
        ELSE GRATIFICACION-PROYECTADA = $401(4).
    /* BASE IMPONIBLE */
    BASE-IMPONIBLE-QUINTA = (REMUNERACION-PROYECTADA + GRATIFICACIONES-PROYECTADAS + REMUNERACION-MESES-ANTERIORES) 
                                - (7 * UIT-PROMEDIO).
    IF BASE-IMPONIBLE-QUINTA > 0 THEN VAR = BASE-IMPONIBLE-QUINTA.
    /* IMPUESTO A LA RENTA */
    IF VAR <= 27 * UIT-PROMEDIO
    THEN VAR = VAR * 0.15.
    ELSE IF VAR <= 54 * UIT-PROMEDIO
        THEN VAR = VAR * 0.21.
        ELSE VAR = VAR * 0.30.
    /* IMPUESTO RETENIDO MESES ANTERIORES */
    IMPUESTO-RETENIDO-QUINTA = $215(1).
    /* RETENCIONES */
    VAR = VAR - IMPUESTO-RETENIDO-QUINTA.
    IF VAR < 0 THEN VAR = 0.
END.    
ELSE DO:    /* TOMAMOS EL MONTO DEL MES ANTERIOR */
    ASSIGN
        x-MES = MES-ACTUAL - 1
        x-ANO = s-periodo.
    IF x-MES <= 0
    THEN ASSIGN
            x-MES = 12
            x-ANO = x-ANO - 1.
    FIND PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.codcia = s-codcia
        AND PL-MOV-MES.periodo = x-ANO
        AND PL-MOV-MES.nromes  = x-MES
        AND PL-MOV-MES.codpln  = PL-FLG-MES.codpln
        AND PL-MOV-MES.codper  = PL-FLG-MES.codper
        AND PL-MOV-MES.codcal  = 001    /* Sueldos */
        AND PL-MOV-MES.codmov  = 215
        NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-MES THEN VAR = PL-MOV-MES.valcal-mes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


