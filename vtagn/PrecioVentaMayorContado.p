&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

DEF INPUT PARAMETER S-CODCIA AS INT.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER S-TPOCMB AS DEC.
DEF OUTPUT PARAMETER F-FACTOR AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-FLGSIT AS CHAR.
DEF INPUT PARAMETER S-UNDVTA AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF INPUT PARAMETER pCodAlm AS CHAR.       /* PARA CONTROL DE ALMACENES DE REMATES */
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.
DEF OUTPUT PARAMETER f-FleteUnitario AS DEC.
/* RHC 14/08/2015 Si necesitas sacar precios SIN aplicar descuentos
    entonces s-FlgSit = 'SINDESCUENTOS'
*/    
/* ******************* */
/* VALORES POR DEFECTO */
/* ******************* */
ASSIGN
    F-PREBAS = 0
    F-PREVTA = 0
    F-DSCTOS = 0
    Y-DSCTOS = 0
    X-TIPDTO = ''
    f-FleteUnitario = 0.
/* ******************* */
/* ******************* */
DEF SHARED VAR CL-CODCIA AS INT.

DEF VAR x-Ajuste-por-flete AS LOG NO-UNDO.
/* OJO: Configuración de la LISTA DE PRECIOS */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK.
ASSIGN
    x-Ajuste-por-flete = GN-DIVI.Campo-Log[4].  /* Factor de Ajuste por Flete */

DEF VAR SW-LOG1 AS LOGI NO-UNDO.
DEF VAR X-PREVTA1 AS DECI NO-UNDO.
DEF VAR X-PREVTA2 AS DECI NO-UNDO.
DEF VAR X-FACTOR  AS DECI NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pCodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN RETURN.

/* CONTROL POR DIVISION */
DEF VAR x-FlgDtoVol LIKE GN-DIVI.FlgDtoVol INIT NO NO-UNDO.
DEF VAR x-FlgDtoProm LIKE GN-DIVI.FlgDtoProm INIT NO NO-UNDO.

/* CONFIGURACIONES DE LA DIVISION */
/* OJO: Configuración de la LISTA DE PRECIOS */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK.
ASSIGN
    x-FlgDtoVol = GN-DIVI.FlgDtoVol             /* Descuento por Volumen */
    x-FlgDtoProm = GN-DIVI.FlgDtoProm           /* Descuento Promocional */
    x-Ajuste-por-flete = GN-DIVI.Campo-Log[4].  /* Factor de Ajuste por Flete */

/* VARIABLES DESCUENTOS CALCULADOS */
DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR x-DctoxVolumen    AS DECIMAL DECIMALS 4 NO-UNDO.

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
         HEIGHT             = 5.62
         WIDTH              = 49.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.   

/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        '    Unidad base:' Almmmatg.UndBas SKIP
        'Unidad de venta:' s-UndVta
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival.
ASSIGN
    X-FACTOR = 1
    X-PREVTA1 = 0
    X-PREVTA2 = 0
    SW-LOG1 = FALSE.
/* RHC 04.04.2011 ALMACENES DE REMATE */
IF Almacen.Campo-C[3] = 'Si' THEN DO:
    FIND VtaTabla WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = 'REMATES'
        AND Vtatabla.llave_c1 = s-codmat
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        IF s-CodMon = Almmmatg.MonVta 
        THEN F-PREBAS = VtaTabla.Valor[1] * f-Factor.
        ELSE IF s-CodMon = 1 
            THEN F-PREBAS = ROUND ( VtaTabla.Valor[1] * f-Factor * Almmmatg.TpoCmb, 6 ).
            ELSE F-PREBAS = ROUND ( VtaTabla.Valor[1] * f-Factor / Almmmatg.TpoCmb, 6 ).
        ASSIGN
            F-PREVTA = F-PREBAS.
        RUN lib/RedondearMas (F-PREBAS, X-NRODEC, OUTPUT F-PREBAS).
        RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).
        RETURN.
    END.
END.
/* ********************************* */
/* RUN lib/RedondearMas (F-PREBAS, 4, OUTPUT F-PREBAS). */
/* RUN lib/RedondearMas (F-PREVTA, 4, OUTPUT F-PREVTA). */
/* ********************************* */
/* PRECIOS PRODUCTOS DE TERCEROS */
/* ********************************* */
DEF VAR x-ClfCli2 LIKE gn-clie.clfcli2 INIT 'C' NO-UNDO.
DEF VAR x-Cols AS CHAR INIT 'A++,A+,A-' NO-UNDO.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia 
    AND gn-clie.codcli = s-codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie AND gn-clie.clfcli2 > '' THEN x-ClfCli2 = gn-clie.clfcli2.
/* ********************************* */
/****   PRECIO C    ****/
/* ********************************* */
IF Almmmatg.UndC > "" AND NOT SW-LOG1 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
        AND  Almtconv.Codalter = Almmmatg.UndC 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
    ELSE MESSAGE 'NO configurada la equivalencia para la unidad C' VIEW-AS ALERT-BOX WARNING.
    IF AVAILABLE Almtconv AND (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
        SW-LOG1 = TRUE.
        F-DSCTOS = Almmmatg.dsctos[3].
        IF Almmmatg.MonVta = 1 THEN
            ASSIGN 
                X-PREVTA1 = Almmmatg.Prevta[4]
                X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
            ASSIGN 
                X-PREVTA2 = Almmmatg.Prevta[4]
                X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
END.
/* ********************************* */
/****   PRECIO B    ****/
/* ********************************* */
IF Almmmatg.UndB > "" AND NOT SW-LOG1 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
        AND  Almtconv.Codalter = Almmmatg.UndB 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
    ELSE MESSAGE 'NO configurada la equivalencia para la unidad B' VIEW-AS ALERT-BOX WARNING.
    IF AVAILABLE Almtconv AND (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
        SW-LOG1 = TRUE.
        F-DSCTOS = Almmmatg.dsctos[2].
        IF Almmmatg.MonVta = 1 THEN 
            ASSIGN 
                X-PREVTA1 = Almmmatg.Prevta[3]
                X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
            ASSIGN
                X-PREVTA2 = Almmmatg.Prevta[3]
                X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
END.
/* ********************************* */
/****   PRECIO A    ****/
/* ********************************* */
IF Almmmatg.UndA > "" AND NOT SW-LOG1 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
        AND  Almtconv.Codalter = Almmmatg.UndA 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
    ELSE MESSAGE 'NO configurada la equivalencia para la unidad A' VIEW-AS ALERT-BOX WARNING.
    IF AVAILABLE Almtconv AND (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
        SW-LOG1 = TRUE.
        F-PREBAS = Almmmatg.PreVta[1].
        F-DSCTOS = Almmmatg.dsctos[1].
        IF Almmmatg.MonVta = 1 THEN 
            ASSIGN 
                X-PREVTA1 = Almmmatg.Prevta[2]
                X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
            ASSIGN 
                X-PREVTA2 = Almmmatg.Prevta[2]
                X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
    ELSE DO:
        SW-LOG1 = TRUE.
        F-DSCTOS = Almmmatg.dsctos[1].
        IF Almmmatg.MonVta = 1 THEN 
            ASSIGN 
                X-PREVTA1 = Almmmatg.Prevta[2]
                X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
            ASSIGN 
                X-PREVTA2 = Almmmatg.Prevta[2]
                X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
END.       
/* **************************************************** */
/* El F-PREBAS siempre = Almmmatg.PreVta[1] (Precio Lista) */
/* **************************************************** */
IF s-CodMon = Almmmatg.MonVta THEN F-PREBAS = Almmmatg.PreVta[1].
ELSE IF s-CodMon = 1 THEN F-PREBAS = Almmmatg.PreVta[1] * Almmmatg.TpoCmb.
ELSE F-PREBAS = Almmmatg.PreVta[1] / Almmmatg.TpoCmb.
/*      IF s-CodMon = Almmmatg.MonVta THEN F-PREBAS = Almmmatg.PreVta[1].                       */
/*      ELSE IF s-CodMon = 1 THEN F-PREBAS = ROUND ( Almmmatg.PreVta[1] * Almmmatg.TpoCmb, 6 ). */
/*      ELSE F-PREBAS = ROUND ( Almmmatg.PreVta[1] / Almmmatg.TpoCmb, 6 ).                      */
/* **************************************************** */
/* EL PRECIO DEBE AFECTARSE CON EL FACTOR DE CONVERSION */
/* **************************************************** */
F-PREBAS = F-PREBAS * F-FACTOR.
IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
    IF S-CODMON = 1 
    THEN F-PREVTA = X-PREVTA1.
    ELSE F-PREVTA = X-PREVTA2.     
END.      
/* ********************************************************** */
/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
/* ********************************************************** */
RUN Descuentos.
/* ********************************************************** */

/* RHC INCREMENTO AL PRECIO UNITARIO POR PAGAR CON TARJETA DE CREDITO */
/* Calculamos el margen de utilidad */
DEF VAR x-MargenUtilidad AS DEC NO-UNDO.
DEF VAR x-ImporteCosto AS DEC NO-UNDO.

x-ImporteCosto = Almmmatg.Ctotot.
IF s-CODMON <> Almmmatg.Monvta THEN DO:
    x-ImporteCosto = IF s-CODMON = 1 
                THEN Almmmatg.Ctotot * Almmmatg.Tpocmb
                ELSE Almmmatg.Ctotot / Almmmatg.Tpocmb.
END.
IF x-ImporteCosto > 0
THEN x-MargenUtilidad = ( (f-PreVta / f-Factor) - x-ImporteCosto ) / x-ImporteCosto * 100.
IF x-MargenUtilidad < 0 THEN x-MargenUtilidad = 0.
/*************************************************/
CASE s-FlgSit:
    WHEN 'T' THEN DO:       /* PAGO CON TARJETA DE CREDITO */
        /* BUSCAMOS EL RANGO ADECUADO */
        FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
                AND FacTabla.Tabla = 'TC'
                AND FacTabla.Codigo BEGINS '00':
            IF x-MargenUtilidad >= FacTabla.Valor[1]
                    AND x-MargenUtilidad < FacTabla.Valor[2] THEN DO:
                f-PreVta = f-Prevta * (1 + FacTabla.Valor[3] / 100).
                f-PreBas = f-PreBas * (1 + FacTabla.Valor[3] / 100).
                LEAVE.
            END.
        END.                
    END.
END CASE.

/* *************************************************************************** */
/* *************************************************************************** */
/* Determinamos el Flete Unitario */
/* *************************************************************************** */
/* 1ro. Factor Harold */
/* *************************************************************************** */
RUN vtagn/flete-unitario-general-v01.p (s-CodMat,
                                        pCodDiv,
                                        S-CODMON,
                                        f-Factor,
                                        OUTPUT f-FleteUnitario).
/* *************************************************************************** */
/* 2do. Factor Rodhenberg */
/* *************************************************************************** */
RUN gn/factor-porcentual-flete-v2.p (INPUT pCodDiv, 
                                     INPUT s-CodMat,
                                     INPUT-OUTPUT f-FleteUnitario, 
                                     INPUT "CO", 
                                     INPUT f-factor, 
                                     INPUT s-CodMon).
/* *************************************************************************** */
/* *************************************************************************** */

RUN lib/RedondearMas (F-PREBAS, X-NRODEC, OUTPUT F-PREBAS).
RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).
F-PREBAS = F-PREVTA.   /* OJO */

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Descuentos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos Procedure 
PROCEDURE Descuentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

Y-DSCTOS = 0.        
IF s-FlgSit = 'SINDESCUENTOS' THEN RETURN.

FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-UndVta 
    NO-LOCK NO-ERROR.
IF AVAILABLE Almtconv 
THEN ASSIGN
        X-FACTOR = Almtconv.Equival.
ELSE ASSIGN 
        X-FACTOR = 1.

/************ Descuento Promocional ************/
ASSIGN
    x-DctoPromocional = 0
    x-DctoxVolumen = 0.
PROMOCIONAL:    /* RHC 25/03/2015 */
DO:
    IF Almmmatg.CodFam = "011" THEN LEAVE PROMOCIONAL.
    IF Almmmatg.CodFam = "013" AND Almmmatg.SubFam <> "014" THEN LEAVE PROMOCIONAL.
    FIND FIRST VtaTabla WHERE VtaTabla.codcia = Almmmatg.codcia
        AND VtaTabla.tabla = "DTOPROLIMA"
        AND VtaTabla.llave_c1 = Almmmatg.codmat
        AND VtaTabla.llave_c2 = pCodDiv
        AND TODAY >= VtaTabla.Rango_Fecha[1]
        AND TODAY <= VtaTabla.Rango_Fecha[2]
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        ASSIGN
            F-DSCTOS = 0
            F-PREVTA = Almmmatg.Prevta[1]
            x-DctoPromocional = VtaTabla.Valor[1]
            SW-LOG1 = TRUE
            X-TIPDTO = "PROM".
        IF Almmmatg.MonVta = 1 THEN 
            ASSIGN 
                X-PREVTA1 = F-PREVTA
                X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
        ELSE
            ASSIGN 
                X-PREVTA2 = F-PREVTA
                X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
        ASSIGN
            X-PREVTA1 = X-PREVTA1 * X-FACTOR
            X-PREVTA2 = X-PREVTA2 * X-FACTOR.             
        IF S-CODMON = 1 
        THEN F-PREVTA = X-PREVTA1.
        ELSE F-PREVTA = X-PREVTA2.     
    END.
END.
/*************** Descuento por Volumen ****************/
ASSIGN
    X-CANTI = X-CANPED * X-FACTOR.
DO J = 1 TO 10:
    IF X-CANTI >= Almmmatg.DtoVolR[J] AND Almmmatg.DtoVolR[J] > 0  THEN DO:
        IF X-RANGO  = 0 THEN X-RANGO = Almmmatg.DtoVolR[J].
        IF X-RANGO <= Almmmatg.DtoVolR[J] THEN DO:
            ASSIGN
                X-RANGO  = Almmmatg.DtoVolR[J]
                F-DSCTOS = 0
                F-PREVTA = Almmmatg.Prevta[1]
                x-DctoxVolumen  = Almmmatg.DtoVolD[J] 
                SW-LOG1 = TRUE
                X-TIPDTO = "VOL".
            IF Almmmatg.MonVta = 1 THEN 
                ASSIGN 
                    X-PREVTA1 = F-PREVTA
                    X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
            ELSE
                ASSIGN 
                    X-PREVTA2 = F-PREVTA
                    X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
            ASSIGN
                X-PREVTA1 = X-PREVTA1 * F-FACTOR
                X-PREVTA2 = X-PREVTA2 * F-FACTOR.                                        
        END.
        IF S-CODMON = 1 
            THEN F-PREVTA = X-PREVTA1.
        ELSE F-PREVTA = X-PREVTA2.     
    END.
END.
/* *************************************** */
/* DEPURAMOS LOS PORCENTAJES DE DESCUENTOS */
/* *************************************** */
IF x-FlgDtoVol  = NO THEN x-DctoxVolumen    = 0.
IF x-FlgDtoProm = NO THEN x-DctoPromocional = 0.

IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
    ASSIGN
        Y-DSCTOS = x-DctoPromocional    /* OJO */
        X-TIPDTO = "PROM".
    IF x-DctoxVolumen > 0 THEN 
        ASSIGN
            Y-DSCTOS = x-DctoxVolumen    /* OJO */
            X-TIPDTO = "VOL".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Factor-de-Ajuste) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Factor-de-Ajuste Procedure 
PROCEDURE Factor-de-Ajuste :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*  NOTA:   
    En algunos casos afecta el precio en otros es el flete */
DEF VAR x-FactorFlete AS DEC NO-UNDO.

/* CASE s-CodDiv:                              */
/*     WHEN "00065" THEN DO:       /* FLETE */ */
CASE x-Ajuste-por-Flete:
    WHEN TRUE THEN DO:
        /* Sobretasa por Sublinea */
        FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
            AND VtaTabla.Llave_c1 = pCodDiv
            AND VtaTabla.Llave_c2 = Almmmatg.codfam
            AND VtaTabla.Llave_c3 = Almmmatg.subfam
            AND VtaTabla.Tabla = "DIVFACXSLIN"
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla AND VtaTabla.Valor[2] <> 0
            THEN ASSIGN
            f-PreVta = ROUND(f-PreVta * ( 1 + VtaTabla.Valor[2] / 100), x-NroDec)
            f-PreBas = ROUND(f-PreBas * ( 1 + VtaTabla.Valor[2] / 100), x-NroDec).
        ELSE DO:
            FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
                AND VtaTabla.Llave_c1 = pCodDiv
                AND VtaTabla.Llave_c2 = Almmmatg.codfam
                AND VtaTabla.Tabla = "DIVFACXLIN"
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaTabla AND VtaTabla.Valor[2] <> 0
                THEN ASSIGN
                f-PreVta = ROUND(f-PreVta * ( 1 + VtaTabla.Valor[2] / 100), x-NroDec)
                f-PreBas = ROUND(f-PreBas * ( 1 + VtaTabla.Valor[2] / 100), x-NroDec).
        END.
        /* Factor Flete: Se basa en el precio de la unidad de Oficina */
        FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
            AND VtaTabla.Llave_c1 = pCodDiv
            AND VtaTabla.Llave_c2 = Almmmatg.codfam
            AND VtaTabla.Llave_c3 = Almmmatg.subfam
            AND VtaTabla.Tabla = "DIVFACXSLIN"
            NO-LOCK NO-ERROR.
        x-FactorFlete = 0.
        IF AVAILABLE VtaTabla AND VtaTabla.Valor[1] > 0  THEN ASSIGN x-FactorFlete = VtaTabla.Valor[1] / 100.
        ELSE DO:
            FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
                AND VtaTabla.Llave_c1 = pCodDiv
                AND VtaTabla.Llave_c2 = Almmmatg.codfam
                AND VtaTabla.Tabla = "DIVFACXLIN"
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaTabla AND VtaTabla.Valor[1] > 0 THEN ASSIGN x-FactorFlete = VtaTabla.Valor[1] / 100.
        END.
        /* Factor de ajuste */
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
            AND  Almtconv.Codalter = Almmmatg.UndA 
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
        /* Flete ajustado a la unidad de venta */
        f-FleteUnitario = Almmmatg.PreVta[2] * x-FactorFlete / x-Factor * f-Factor.
        IF s-CodMon <> Almmmatg.MonVta 
            THEN IF s-CodMon = 1 
            THEN f-FleteUnitario = ROUND ( f-FleteUnitario * Almmmatg.TpoCmb, 6 ).
            ELSE f-FleteUnitario = ROUND ( f-FleteUnitario / Almmmatg.TpoCmb, 6 ).
         /* RHC 17/10/2015 Importe Unitario Flete en Soles */
         FIND TabGener WHERE TabGener.codcia = s-codcia
             AND TabGener.clave = "%FLETE-IMP"
             AND TabGener.codigo = pCodDiv + "|" + Almmmatg.codmat
             NO-LOCK NO-ERROR.
         IF AVAILABLE TabGener THEN f-FleteUnitario = TabGener.ValorIni.
         /* ********************************************** */

    END.
    OTHERWISE DO:               /* PRECIO */
        FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
            AND VtaTabla.Llave_c1 = pcoddiv
            AND VtaTabla.Llave_c2 = Almmmatg.codfam
            AND VtaTabla.Llave_c3 = Almmmatg.subfam
            AND VtaTabla.Tabla = "DIVFACXSLIN"
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla AND VtaTabla.Valor[1] > 0 THEN DO:
            f-PreVta = f-Prevta * (1 + VtaTabla.Valor[1] / 100).
            f-PreBas = f-PreBas * (1 + VtaTabla.Valor[1] / 100).
        END.
        ELSE DO:
            FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
                AND VtaTabla.Llave_c1 = pcoddiv
                AND VtaTabla.Llave_c2 = Almmmatg.codfam
                AND VtaTabla.Tabla = "DIVFACXLIN"
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaTabla AND VtaTabla.Valor[1] > 0 THEN DO:
                f-PreVta = f-Prevta * (1 + VtaTabla.Valor[1] / 100).
                f-PreBas = f-PreBas * (1 + VtaTabla.Valor[1] / 100).
            END.
        END.
        /* ************************************************ */
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

