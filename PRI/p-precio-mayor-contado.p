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

/* OJO: Configuración de la LISTA DE PRECIOS */
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

/* VARIABLES DESCUENTOS CALCULADOS */
DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 6 NO-UNDO.
DEF VAR x-DctoxVolumen    AS DECIMAL DECIMALS 6 NO-UNDO.

/* CONTROL POR LISTA DE PRECIOS/DIVISION */
DEF VAR x-FlgDtoVol LIKE GN-DIVI.FlgDtoVol NO-UNDO.
DEF VAR x-FlgDtoProm LIKE GN-DIVI.FlgDtoProm NO-UNDO.
DEF VAR x-Libre_C01 LIKE GN-DIVI.Libre_C01 NO-UNDO.     /* Dcto Exluyenbres, acumulados o el mejor */
DEF VAR x-Ajuste-por-flete AS LOG NO-UNDO.

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-CodDiv NO-LOCK.
ASSIGN
    x-FlgDtoVol         = GN-DIVI.FlgDtoVol             /* Descuento por Volumen */
    x-FlgDtoProm        = GN-DIVI.FlgDtoProm           /* Descuento Promocional */
    x-Libre_C01         = GN-DIVI.Libre_C01             /* Tipo de descuento */
    x-Ajuste-por-flete  = GN-DIVI.Campo-Log[4].  /* Factor de Ajuste por Flete */
/* *************************************************************************** */
/* CONFIGURACION DE PRECIOS EVENTO */
/* *************************************************************************** */
/* Si no ubica una configuración toma por defecto la de la división */
FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-CodCia AND
    VtaDTabla.Tabla = 'CFGLP' AND
    VtaDTabla.Llave = s-CodDiv AND
    VtaDTabla.Tipo = Almmmatg.CodFam:
    IF Almmmatg.SubFam = VtaDTabla.Libre_c01 THEN NEXT.     /* Subfamilia (-) */
    IF VtaDTabla.LlaveDetalle > '' AND Almmmatg.SubFam <> VtaDTabla.LlaveDetalle THEN NEXT. /* Subfamilia (+) */
    /* CALCULO DE PRECIO Y DESCUENTO POR PRODUCTO */
    x-FlgDtoVol    = VtaDTabla.Libre_l03.
    x-FlgDtoProm   = VtaDTabla.Libre_l04.
    x-Libre_C01    = VtaDTabla.Libre_c02.   /* "" Excluyentes, "A" acumulados "M" mejor precio */
    LEAVE.
END.

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
        RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).
        RETURN 'OK'.
    END.
END.
/* ********************************* */

/*RDP 17.08.10 Reduce a 4 decimales*/
RUN lib/RedondearMas (F-PREVTA, 4, OUTPUT F-PREVTA).
/**************************/

/* PRECIOS PRODUCTOS DE TERCEROS */
DEF VAR x-ClfCli2 LIKE gn-clie.clfcli2 INIT 'C' NO-UNDO.
DEF VAR x-Cols AS CHAR INIT 'A++,A+,A-' NO-UNDO.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = s-codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie AND gn-clie.clfcli2 > '' THEN x-ClfCli2 = gn-clie.clfcli2.

/****   PRECIO C    ****/
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
/****   PRECIO B    ****/
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
/****   PRECIO A    ****/
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
ELSE IF s-CodMon = 1 THEN F-PREBAS = ROUND ( Almmmatg.PreVta[1] * Almmmatg.TpoCmb, 4 ).
                    ELSE F-PREBAS = ROUND ( Almmmatg.PreVta[1] / Almmmatg.TpoCmb, 4 ).
F-PREBAS = F-PREBAS * F-FACTOR.
IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
    IF S-CODMON = 1 
    THEN F-PREVTA = X-PREVTA1.
    ELSE F-PREVTA = X-PREVTA2.     
END.      

/* *************************************************************************** */
/* CALCULAMOS EL PRECIO DE VENTA FINAL */
/* *************************************************************************** */
RUN Precio-de-Venta.
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
/* *************************************************************************** */

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
RUN gn/flete-unitario.p (s-CodMat,
                         s-CodDiv,
                         S-CODMON,
                         f-Factor,
                         OUTPUT f-FleteUnitario).

RUN lib/RedondearMas (F-PREBAS, X-NRODEC, OUTPUT F-PREBAS).
RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
            AND VtaTabla.Llave_c1 = s-CodDiv
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
                AND VtaTabla.Llave_c1 = s-CodDiv
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
            AND VtaTabla.Llave_c1 = s-CodDiv
            AND VtaTabla.Llave_c2 = Almmmatg.codfam
            AND VtaTabla.Llave_c3 = Almmmatg.subfam
            AND VtaTabla.Tabla = "DIVFACXSLIN"
            NO-LOCK NO-ERROR.
        x-FactorFlete = 0.
        IF AVAILABLE VtaTabla AND VtaTabla.Valor[1] > 0  THEN ASSIGN x-FactorFlete = VtaTabla.Valor[1] / 100.
        ELSE DO:
            FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
                AND VtaTabla.Llave_c1 = s-CodDiv
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
             AND TabGener.codigo = s-CodDiv + "|" + Almmmatg.codmat
             NO-LOCK NO-ERROR.
         IF AVAILABLE TabGener THEN f-FleteUnitario = TabGener.ValorIni.
         /* ********************************************** */

    END.
    OTHERWISE DO:               /* PRECIO */
        FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
            AND VtaTabla.Llave_c1 = s-coddiv
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
                AND VtaTabla.Llave_c1 = s-coddiv
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

&IF DEFINED(EXCLUDE-Precio-de-Venta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-de-Venta Procedure 
PROCEDURE Precio-de-Venta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR j AS INT NO-UNDO.
DEF VAR x-Canti AS DEC NO-UNDO.
DEF VAR x-Rango AS DEC NO-UNDO.

/* FACTOR DE EQUIVALENCIA (OJO: La s-UndVta ya debe tener un valor cargado) */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        '   Unidad Stock:' Almmmatg.UndStk SKIP
        'Unidad de Venta:' s-UndVta
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* VALORES POR DEFECTO */
ASSIGN
    F-FACTOR = Almtconv.Equival     /* Equivalencia */
    s-tpocmb = Almmmatg.TpoCmb.     /* ¿? */
/* ********************************************************************************* */
/* DESCUENTOS PROMOCIONALES Y POR VOLUMEN: SOLO SI EL VENCIMIENTO ES MENOR A 30 DIAS */                        
/* ********************************************************************************* */
ASSIGN
    x-DctoPromocional = 0
    x-DctoxVolumen = 0.
/* ********************************************************************************* */
/************ Descuento Promocional ************/ 
/* ********************************************************************************* */
DEF VAR x-Old-Descuento LIKE x-DctoPromocional NO-UNDO.
/* Tomamos el mayor descuento */
x-Old-Descuento = 0.
FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND
    VtaDctoProm.CodDiv = s-CodDiv AND 
    VtaDctoProm.CodMat = Almmmatg.CodMat AND
    (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin):
    x-DctoPromocional = VtaDctoProm.Descuento. 
    x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento).
    x-Old-Descuento = x-DctoPromocional.
END.
/* ********************************************************************************* */
/*************** Descuento por Volumen ****************/
/* ********************************************************************************* */
/* Tomamos el mayor descuento */
x-Old-Descuento = 0.
FOR EACH VtaDctoVol NO-LOCK WHERE VtaDctoVol.CodCia = s-CodCia AND
    VtaDctoVol.CodDiv = s-CodDiv AND 
    VtaDctoVol.CodMat = Almmmatg.CodMat AND
    (TODAY >= VtaDctoVol.FchIni AND TODAY <= VtaDctoVol.FchFin):
    X-CANTI = X-CANPED * F-FACTOR.
    X-RANGO = 0.
    DO J = 1 TO 10:
        IF X-CANTI >= VtaDctoVol.DtoVolR[J] AND VtaDctoVol.DtoVolR[J] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = VtaDctoVol.DtoVolR[J].
            IF X-RANGO <= VtaDctoVol.DtoVolR[J] THEN DO:
                ASSIGN
                    X-RANGO  = VtaDctoVol.DtoVolR[J]
                    x-DctoxVolumen = VtaDctoVol.DtoVolD[J].
            END.   
        END.   
    END.
    x-DctoxVolumen = MAXIMUM(x-DctoxVolumen, x-Old-Descuento).
    x-Old-Descuento = x-DctoxVolumen.
END.
/* ********************************************************************************* */
/* DEPURAMOS LOS PORCENTAJES DE DESCUENTOS */
/* ********************************************************************************* */

IF x-FlgDtoVol  = NO THEN x-DctoxVolumen    = 0.
IF x-FlgDtoProm = NO THEN x-DctoPromocional = 0.
IF x-DctoxVolumen <= 0 AND x-DctoPromocional <= 0 THEN DO:
    RETURN 'OK'.
END.
/* *********************************** */
/* PRECIO BASE, DE VENTA Y DESCUENTOS */
/* *********************************** */
ASSIGN
    F-DSCTOS = 0                    /* Dcto por ClfCli y/o Cnd Vta */
    Y-DSCTOS = 0                    /* Dcto por Volumen o Promocional */
    X-TIPDTO = "".
CASE TRUE:
    WHEN x-Libre_C01 = "" THEN DO:      /* Descuentos Excluyentes */
        IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
            ASSIGN
                F-PREVTA = Almmmatg.Prevta[1] * F-FACTOR      
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            IF x-DctoxVolumen > 0 THEN 
                ASSIGN
                    Y-DSCTOS = x-DctoxVolumen    /* OJO */
                    X-TIPDTO = "VOL".
        END.
    END.
    WHEN x-Libre_C01 = "A" THEN DO:     /* Descuentos Acumulados */
        IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
            ASSIGN
                F-PREVTA = Almmmatg.Prevta[1] * F-FACTOR
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            IF x-DctoxVolumen > 0 THEN 
                ASSIGN
                    Y-DSCTOS = x-DctoxVolumen   /* OJO */
                    X-TIPDTO = "VOL".
        END.
    END.
    WHEN x-Libre_c01 = "M" THEN DO:     /* Mejor Descuento */
        IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
            ASSIGN
                F-PREVTA = Almmmatg.Prevta[1] * F-FACTOR
                Y-DSCTOS = MAXIMUM( x-DctoPromocional, x-DctoxVolumen).
        END.
    END.
END CASE.
IF Almmmatg.MonVta <> s-CodMon THEN
    IF s-CodMon = 1 THEN F-PREVTA = F-PREVTA * s-TpoCmb.
    ELSE F-PREVTA = F-PREVTA / s-TpoCmb.

RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

