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
DEF INPUT PARAMETER S-CODDIV AS CHAR.
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
DEF VAR x-Ajuste-por-flete AS LOG NO-UNDO.

/* OJO: Configuración de la LISTA DE PRECIOS */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-CodDiv NO-LOCK.
ASSIGN
    x-Ajuste-por-flete = GN-DIVI.Campo-Log[4].  /* Factor de Ajuste por Flete */

DEF VAR SW-LOG1 AS LOGI NO-UNDO.

DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.
DEFINE VARIABLE X-FACTOR  AS DECI NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pCodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN RETURN.


DEF SHARED VAR CL-CODCIA AS INT.

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
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* variables sacadas del include */
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.   

/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
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

/* *********************************************************************************** */
/* RHC 04.04.2011 ALMACENES DE REMATE */
/* *********************************************************************************** */
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
        RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).
        RETURN 'OK'.
    END.
END.
/* *********************************************************************************** */
/* RDP 17.08.10 Reduce a 4 decimales*/
RUN lib/RedondearMas (F-PREVTA, 4, OUTPUT F-PREVTA).
/* *********************************************************************************** */

/* PRECIOS PRODUCTOS DE TERCEROS */
DEF VAR x-ClfCli2 LIKE gn-clie.clfcli2 INIT 'C' NO-UNDO.
DEF VAR x-Cols AS CHAR INIT 'A++,A+,A-' NO-UNDO.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = s-codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie AND gn-clie.clfcli2 <> '' THEN x-ClfCli2 = gn-clie.clfcli2.
/* *********************************************************************************** */
/****   PRECIO C    ****/
/* *********************************************************************************** */
IF Almmmatg.UndC <> "" AND NOT SW-LOG1 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
        AND  Almtconv.Codalter = Almmmatg.UndC 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
    ELSE MESSAGE 'NO configurada la equivalencia para la unidad C' VIEW-AS ALERT-BOX WARNING.
    IF AVAILABLE Almtconv AND (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
        SW-LOG1 = TRUE.
        F-DSCTOS = Almmmatg.dsctos[3].
        IF Almmmatg.MonVta = 1 THEN
          ASSIGN X-PREVTA1 = Almmmatg.Prevta[4]
                 X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = Almmmatg.Prevta[4]
                 X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
END.
/* *********************************************************************************** */
/****   PRECIO B    ****/
/* *********************************************************************************** */
IF Almmmatg.UndB <> "" AND NOT SW-LOG1 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
        AND  Almtconv.Codalter = Almmmatg.UndB 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
    ELSE MESSAGE 'NO configurada la equivalencia para la unidad B' VIEW-AS ALERT-BOX WARNING.
    IF AVAILABLE Almtconv AND (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
        SW-LOG1 = TRUE.
        F-DSCTOS = Almmmatg.dsctos[2].
        IF Almmmatg.MonVta = 1 THEN 
          ASSIGN X-PREVTA1 = Almmmatg.Prevta[3]
                 X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = Almmmatg.Prevta[3]
                 X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
END.
/* *********************************************************************************** */
/****   PRECIO A    ****/
/* *********************************************************************************** */
IF Almmmatg.UndA <> "" AND NOT SW-LOG1 THEN DO:
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
          ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]
                 X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]
                 X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
    ELSE DO:
        SW-LOG1 = TRUE.
        F-DSCTOS = Almmmatg.dsctos[1].
        IF Almmmatg.MonVta = 1 THEN 
          ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]
                 X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]
                 X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
END.       
/* El F-PREBAS siempre = Almmmatg.PreVta[1] (Precio Lista) */
IF s-CodMon = Almmmatg.MonVta THEN F-PREBAS = Almmmatg.PreVta[1].
ELSE IF s-CodMon = 1 THEN F-PREBAS = ROUND ( Almmmatg.PreVta[1] * Almmmatg.TpoCmb, 6 ).
                    ELSE F-PREBAS = ROUND ( Almmmatg.PreVta[1] / Almmmatg.TpoCmb, 6 ).
F-PREBAS = F-PREBAS * F-FACTOR.

IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
    IF S-CODMON = 1 
    THEN F-PREVTA = X-PREVTA1.
    ELSE F-PREVTA = X-PREVTA2.     
END.      
/* *********************************************************************************** */
/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
/* *********************************************************************************** */
RUN Descuentos.
/* *********************************************************************************** */
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

/* ************************************************ */
/* RHC 19/11/2013 INCREMENTO POR DIVISION Y FAMILIA */
/* ************************************************ */
/* Determinamos el Flete Unitario */
/* RHC 24/09/18 Factor HAROLD */
/* RUN gn/flete-unitario.p (s-CodMat,                */
/*                          s-CodDiv,                */
/*                          S-CODMON,                */
/*                          f-Factor,                */
/*                          OUTPUT f-FleteUnitario). */
/* *************************************************************************** */
/* *************************************************************************** */
/* Determinamos el Flete Unitario */
/* *************************************************************************** */
/* 1ro. Factor Harold Segura */
/* *************************************************************************** */
RUN vtagn/flete-unitario-general-v01.p (s-CodMat,
                                        s-CodDiv,
                                        S-CODMON,
                                        f-Factor,
                                        OUTPUT f-FleteUnitario).
/* *************************************************************************** */
/* 2do. Factor Karin Rodhenberg */
/* *************************************************************************** */
RUN gn/factor-porcentual-flete-v2.p (INPUT s-coddiv, 
                                     INPUT s-CodMat,
                                     INPUT-OUTPUT f-FleteUnitario, 
                                     INPUT "N",     /*INPUT s-TpoPed, */
                                     INPUT f-factor, 
                                     INPUT s-CodMon).
/*MESSAGE 'f-prebas' f-prebas 'f-prevta' f-prevta 'f-fleteunitario' f-fleteunitario.*/
/* ***************************************************************************************** */
/* RHC 08/02/2020 Solo clientes VIP HUANCAYO */
/* ***************************************************************************************** */
RUN VIP-Huancayo.
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
/* ***************************************************************************************** */

RUN lib/RedondearMas (F-PREBAS, X-NRODEC, OUTPUT F-PREBAS).
RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).


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
/* *********************************************************************************** */
/************ Descuento Promocional ************/
/* *********************************************************************************** */
DEF VAR x-Old-Descuento AS DEC NO-UNDO. 
DEF VAR x-DctoPromocional AS DEC NO-UNDO.
PROMOCIONAL:    /* RHC 25/03/2015 */
DO:
    IF Almmmatg.CodFam = "011" THEN LEAVE PROMOCIONAL.
    IF Almmmatg.CodFam = "013" AND Almmmatg.SubFam <> "014" THEN LEAVE PROMOCIONAL.
    /* Tomamos el mayor descuento */ 
    x-Old-Descuento = 0. 
    x-DctoPromocional = 0.
    FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND 
        VtaDctoProm.CodDiv = s-CodDiv AND 
        VtaDctoProm.CodMat = Almmmatg.CodMat AND 
        VtaDctoProm.FlgEst = "A" AND
        (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin): 
        x-DctoPromocional = VtaDctoProm.Descuento. 
        x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento). 
        x-Old-Descuento = x-DctoPromocional. 
    END. 
    IF x-DctoPromocional > 0 THEN DO:
        ASSIGN
            F-DSCTOS = 0
            F-PREVTA = Almmmatg.Prevta[1]
            Y-DSCTOS = x-DctoPromocional
            SW-LOG1 = TRUE
            X-TIPDTO = "PROM".
        IF Almmmatg.Monvta = 1 THEN 
          ASSIGN X-PREVTA1 = F-PREVTA
                 X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = F-PREVTA
                 X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
            AND Almtconv.Codalter = s-UndVta
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv
        THEN x-Factor = Almtconv.Equival.
        ELSE x-Factor = 1.
        X-PREVTA1 = X-PREVTA1 * X-FACTOR.
        X-PREVTA2 = X-PREVTA2 * X-FACTOR.             
        IF S-CODMON = 1 
        THEN F-PREVTA = X-PREVTA1.
        ELSE F-PREVTA = X-PREVTA2.     
    END.
END.
/* *********************************************************************************** */
/*************** Descuento por Volumen ****************/
/* *********************************************************************************** */
DEF VAR x-DctoxVolumen AS DEC NO-UNDO.

FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-UndVta 
    NO-LOCK NO-ERROR.
IF AVAILABLE Almtconv 
THEN ASSIGN
        X-FACTOR = Almtconv.Equival.
ELSE ASSIGN 
        X-FACTOR = 1.
X-CANTI = X-CANPED * X-FACTOR.
x-DctoxVolumen = 0.
x-Rango = 0.
DO J = 1 TO 10:
   IF X-CANTI >= Almmmatg.DtoVolR[J] AND Almmmatg.DtoVolR[J] > 0  THEN DO:
      IF X-RANGO  = 0 THEN X-RANGO = Almmmatg.DtoVolR[J].
      IF X-RANGO <= Almmmatg.DtoVolR[J] THEN DO:
          ASSIGN
              X-RANGO  = Almmmatg.DtoVolR[J]
              F-DSCTOS = 0
              F-PREVTA = Almmmatg.Prevta[1]
              Y-DSCTOS = Almmmatg.DtoVolD[J] 
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
          X-PREVTA1 = X-PREVTA1 * F-FACTOR.
          X-PREVTA2 = X-PREVTA2 * F-FACTOR.                                        
          x-DctoxVolumen = Y-DSCTOS.
      END.   
      IF S-CODMON = 1 
      THEN F-PREVTA = X-PREVTA1.
      ELSE F-PREVTA = X-PREVTA2.     
   END.   
END.
/* ************************************************************************************** */
/* RHC 15/09/2020 Descuento por volumen por división */
/* ************************************************************************************** */
DEF VAR x-Old-Vol-Div AS DEC NO-UNDO. 
x-Old-Vol-Div = 0. 
FOR EACH VtaDctoVol NO-LOCK WHERE VtaDctoVol.CodCia = s-CodCia AND
    VtaDctoVol.CodDiv = s-CodDiv AND
    VtaDctoVol.CodMat = s-CodMat AND
    (TODAY >= VtaDctoVol.FchIni AND TODAY <= VtaDctoVol.FchFin)
    BY VtaDctoVol.FchIni:
    X-Rango = 0.
    DO J = 1 TO 10:
        IF X-CANTI >= VtaDctoVol.DtoVolR[J] AND VtaDctoVol.DtoVolR[J] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = VtaDctoVol.DtoVolR[J].
            IF X-RANGO <= VtaDctoVol.DtoVolR[J] THEN DO:
                ASSIGN
                    F-DSCTOS = 0
                    F-PREVTA = Almmmatg.Prevta[1]
                    SW-LOG1 = TRUE
                    X-TIPDTO = "VOL"
                    X-RANGO  = VtaDctoVol.DtoVolR[J]
                    Y-DSCTOS = VtaDctoVol.DtoVolD[J].
                IF Almmmatg.MonVta = 1 THEN 
                    ASSIGN 
                        X-PREVTA1 = F-PREVTA
                        X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
                ELSE
                   ASSIGN 
                       X-PREVTA2 = F-PREVTA
                       X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
                X-PREVTA1 = X-PREVTA1 * F-FACTOR.
                X-PREVTA2 = X-PREVTA2 * F-FACTOR.                                        
                x-DctoxVolumen = Y-DSCTOS.
            END.
            IF S-CODMON = 1 
            THEN F-PREVTA = X-PREVTA1.
            ELSE F-PREVTA = X-PREVTA2.     
        END.
    END.
    x-DctoxVolumen = MAXIMUM(x-DctoxVolumen, x-Old-Vol-Div). 
    x-Old-Vol-Div = x-DctoxVolumen.
    IF x-DctoxVolumen > 0 THEN Y-DSCTOS = x-DctoxVolumen.
END.
/* ************************************************************************************** */
/* RHC 11/08/2020 Se toma el mejor precio: Cesar Camus */
/* ************************************************************************************** */
/* 23/06/2022 Parche pala la línea 011: siempre como terceros GDLL */
CASE TRUE:
    WHEN Almmmatg.CodFam = '011' THEN DO:
        IF (x-DctoPromocional > 0 OR x-DctoxVolumen > 0) THEN DO:
            IF Almmmatg.Prevta[1] * (1 - (x-DctoPromocional / 100)) < Almmmatg.Prevta[1] * (1 - (x-DctoxVolumen / 100))
                THEN ASSIGN 
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            ELSE ASSIGN
                Y-DSCTOS = x-DctoxVolumen    /* OJO */
                X-TIPDTO = "VOL".
        END.
    END.
    OTHERWISE DO:
        IF (x-DctoPromocional > 0 OR x-DctoxVolumen > 0) AND Almmmatg.chr__02 = "T" THEN DO:
            IF Almmmatg.Prevta[1] * (1 - (x-DctoPromocional / 100)) < Almmmatg.Prevta[1] * (1 - (x-DctoxVolumen / 100))
                THEN ASSIGN 
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            ELSE ASSIGN
                Y-DSCTOS = x-DctoxVolumen    /* OJO */
                X-TIPDTO = "VOL".
        END.
    END.
END CASE.
/* IF (x-DctoPromocional > 0 OR x-DctoxVolumen > 0) AND Almmmatg.chr__02 = "T" THEN DO:                            */
/*     IF Almmmatg.Prevta[1] * (1 - (x-DctoPromocional / 100)) < Almmmatg.Prevta[1] * (1 - (x-DctoxVolumen / 100)) */
/*         THEN ASSIGN                                                                                             */
/*         Y-DSCTOS = x-DctoPromocional    /* OJO */                                                               */
/*         X-TIPDTO = "PROM".                                                                                      */
/*     ELSE ASSIGN                                                                                                 */
/*         Y-DSCTOS = x-DctoxVolumen    /* OJO */                                                                  */
/*         X-TIPDTO = "VOL".                                                                                       */
/* END.                                                                                                            */
/* *************************************************** */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VIP-Huancayo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VIP-Huancayo Procedure 
PROCEDURE VIP-Huancayo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* SOLO HUANCAYO */
IF s-CodDiv <> "00072" THEN RETURN 'OK'.

/* RHC 08/02/2020 Solo clientes VIP HUANCAYO */
FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia AND
    VtaTabla.Tabla = "CLIENTE_VIP_CONTI" AND
    VtaTabla.Llave_c1 = s-CodCli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN RETURN 'OK'.
     
/* Simulamos una venta crédito */
DEF VAR z-Dsctos AS DEC NO-UNDO.
RUN pri/PrecioVentaMayorCredito (
    "N",
    s-CodDiv,
    s-CodCli,
    s-CodMon,
    INPUT-OUTPUT s-UndVta,
    OUTPUT f-Factor,
    s-CodMat,
    "000",
    x-CanPed,
    4,
    OUTPUT f-PreBas,
    OUTPUT f-PreVta,
    OUTPUT f-Dsctos,
    OUTPUT y-Dsctos,
    OUTPUT z-Dsctos,
    OUTPUT x-TipDto,
    /*"",*/
    OUTPUT f-FleteUnitario,
    "",
    TRUE
    ).
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

