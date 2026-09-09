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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.

DEF INPUT PARAMETER pTpoPed AS CHAR.
/* Sintaxis: Por defecto trabaja con la LISTA MAYORISTA (Almmmatg y VtaListaMay)
Enviar "MIN" si va a trabajar con la LISTA MINORISTA VtaListaMinGn
*/    
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* División/Lista de Precios */
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pCodMon AS INTE.    /* 1: Soles    2: Dólares */
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pUndVta AS CHAR.
DEF OUTPUT PARAMETER pFactor AS DECI.
DEF INPUT PARAMETER pFmaPgo AS CHAR.
DEF INPUT PARAMETER pNroDec AS INTE.
DEF INPUT PARAMETER pCanPed AS DECI.
DEF INPUT PARAMETER pFlgSit AS CHAR.
/* pFlgSit = "T" es pago con Tarjeta de Crédito */
/* Si necesitas sacar precios SIN aplicar descuentos
    entonces pFlgSit = 'SINDESCUENTOS'
*/    
DEF INPUT PARAMETER pClfCli AS CHAR.        /* SOlo si tiene un valor me sirve */

DEF OUTPUT PARAMETER f-PreBas AS DECI.
DEF OUTPUT PARAMETER f-PreVta AS DECI.
/*DEF OUTPUT PARAMETER f-Dsctos AS DECI.*/
DEF OUTPUT PARAMETER y-Dsctos AS DECI.
DEF OUTPUT PARAMETER z-Dsctos AS DECI.
DEF OUTPUT PARAMETER x-TipDto AS CHAR.
DEF OUTPUT PARAMETER f-FleteUnitario AS DECI.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    pMensaje = "Artículo " + pCodMat + " no registrado en el catálogo de artículos".
    RETURN 'ADM-ERROR'.
END.
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = pUndVta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
        'Unidad de venta: ' + pUndVta.
    RETURN "ADM-ERROR".
END.
pFactor = Almtconv.Equival.


/* *********************************************************************************** */
/* CONTROL POR DIVISION */
/* *********************************************************************************** */
DEF VAR pSalesChannel AS CHAR NO-UNDO.
DEF VAR x-FlgDtoVol LIKE GN-DIVI.FlgDtoVol NO-UNDO.
DEF VAR x-FlgDtoProm LIKE GN-DIVI.FlgDtoProm NO-UNDO.
DEF VAR x-Libre_C01 LIKE GN-DIVI.Libre_C01 NO-UNDO.     /* Dcto Excluyentes, acumulados o el mejor */
DEF VAR x-Ajuste-por-flete AS LOG NO-UNDO.

/* OJO: Configuración de la LISTA DE PRECIOS */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK.
ASSIGN
    pSalesChannel = TRIM(STRING(INTEGER(GN-DIVI.Grupo_Divi_GG)))
    x-Ajuste-por-flete = GN-DIVI.Campo-Log[4].  /* Factor de Ajuste por Flete */
ASSIGN
    x-FlgDtoVol = GN-DIVI.FlgDtoVol             /* Descuento por Volumen */
    x-FlgDtoProm = GN-DIVI.FlgDtoProm           /* Descuento Promocional */
    x-Libre_C01 = GN-DIVI.Libre_C01.            /* Tipo de descuento */

/* *********************************************************************************** */
/* CONTROL POR CLIENTE */
/* *********************************************************************************** */
FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = pCodCli NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN DO:
    pMensaje = "Cliente no válido".
    RETURN 'ADM-ERROR'.
END.

DEF VAR x-ClfCli  AS CHAR INIT "C" NO-UNDO.      /* Clasificacion para productos propios */
DEF VAR x-ClfCli2 AS CHAR INIT "C" NO-UNDO.      /* Clasificacion para productos de terceros */

IF gn-clie.clfcli  > '' THEN x-ClfCli  = gn-clie.clfcli.
IF gn-clie.clfcli2 > '' THEN x-ClfCli2 = gn-clie.clfcli2.

IF pClfCli > '' THEN
    ASSIGN
    x-ClfCli = pClfCli
    x-ClfCli2 = pClfCli.

/* *********************************************************************************** */
/* CONDICION DE VENTA */
/* *********************************************************************************** */
FIND gn-convt WHERE gn-convt.Codig = pFmaPgo NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-convt THEN DO:
    pMensaje = "Condición de Venta no válida".
    RETURN 'ADM-ERROR'.
END.
/* ********************************************************************************* */
/* DESCUENTOS PROMOCIONALES Y POR VOLUMEN: SOLO SI EL VENCIMIENTO ES MENOR A 30 DIAS */                        
/* ********************************************************************************* */
DEF VAR x-DctoPromocional AS DECI NO-UNDO.
DEF VAR x-DctoxVolumen AS DECI NO-UNDO.

DEF VAR pDiasDctoVol AS INT INIT 60 NO-UNDO.    /* Tope Para % Descuento por Volumen (hasta 60 dias ) */
DEF VAR pDiasDctoPro AS INT INIT 60 NO-UNDO.    /* Tope Para % Descuento Promocional (hasta 60 dias ) */

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
         HEIGHT             = 6
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* *********************************************************************************** */
/* ******************* CALCULO GENERAL DEL PRECIO DE VENTA ******************* */
/* *********************************************************************************** */
DEF VAR x-MonVta AS INTE NO-UNDO.       /* Moneda de venta de la lista de Precios */
DEF VAR x-TpoCmb AS DECI NO-UNDO.       /* Tipo de Cambio de la Lista de Precios */
DEF VAR x-ImporteCosto AS DEC NO-UNDO.  /* CFosto de la Lista de Precios */

DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN web/web-library.p PERSISTENT SET hProc.

RUN web_api-pricing-precio-costo IN hProc (INPUT pCodMat,
                                           INPUT pSalesChannel,
                                           INPUT (IF Almmmatg.CHR__02 = "P" THEN x-ClfCli ELSE x-ClfCli2),
                                           INPUT pFmaPgo,
                                           OUTPUT x-MonVta,
                                           OUTPUT x-TpoCmb,
                                           OUTPUT f-PreVta,       /* Precio descontado ClfCli y CndVta */
                                           OUTPUT x-ImporteCosto,
                                           OUTPUT pMensaje).
DELETE PROCEDURE hProc.
IF RETURN-VALUE = 'ADM-ERROR' OR pMensaje > '' THEN RETURN 'ADM-ERROR'.

/* Ajustamos de acuerdo a la moneda de venta */
IF pCodMon = x-MonVta THEN F-PREBAS = F-PREVTA.
ELSE IF pCodMon = 1 THEN F-PREBAS = ROUND ( F-PREVTA * x-TpoCmb, 6 ).
        ELSE F-PREBAS = ROUND ( F-PREVTA / x-TpoCmb, 6 ).

F-PREBAS = F-PREBAS * pFACTOR.     /* Ajustamos a la unidad de venta */
F-PREVTA = F-PREBAS.

/* *********************************************************************************** */
/* CONFIGURACION DE DESCUENTOS */
/* *********************************************************************************** */
/* Si no ubica una configuración toma por defecto la de la división */
FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-CodCia AND
    VtaDTabla.Tabla = 'CFGLP' AND
    VtaDTabla.Llave = pCodDiv AND
    VtaDTabla.Tipo = Almmmatg.CodFam:
    IF Almmmatg.SubFam = VtaDTabla.Libre_c01 THEN NEXT.     /* Subfamilia (-) */
    IF VtaDTabla.LlaveDetalle > '' AND Almmmatg.SubFam <> VtaDTabla.LlaveDetalle THEN NEXT. /* Subfamilia (+) */
    /* CALCULO DE PRECIO Y DESCUENTO POR PRODUCTO */
    x-FlgDtoVol    = VtaDTabla.Libre_l03.
    x-FlgDtoProm   = VtaDTabla.Libre_l04.
    x-Libre_C01    = VtaDTabla.Libre_c02.   /* "" Excluyentes, "A" acumulados */
    LEAVE.
END.
/* *********************************************************************************** */
/* PRECIO DE VENTA Y DESCUENTOS PROMOCIONALES O POR VOLUMEN DE VENTA  */
/* *********************************************************************************** */
CASE TRUE:
    WHEN pTpoPed = "MIN" THEN DO:
        /* Descuentos Minoristas */
        RUN Precio-Utilex.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
    OTHERWISE DO:
        /* Descuentos Mayoristas */
        CASE gn-divi.VentaMayorista:
            WHEN 1 THEN DO:     /* Lista de Precios General */
                RUN Precio-Empresa.
                IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
            END.
            WHEN 2 THEN DO:     /* Lista de Precio por División */
                RUN Precio-Division.
                IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
            END.
        END CASE.
    END.
END CASE.
/* *********************************************************************************** */
/* INCREMENTO AL PRECIO UNITARIO POR PAGAR CON TARJETA DE CREDITO */
/* *********************************************************************************** */
DEF VAR x-MargenUtilidad AS DEC NO-UNDO.

CASE pFlgSit:
    WHEN 'T' THEN DO:       /* PAGO CON TARJETA DE CREDITO */
        IF pCodMon <> x-Monvta THEN DO:
            x-ImporteCosto = IF pCodMon = 1 THEN x-ImporteCosto * x-Tpocmb ELSE x-ImporteCosto / x-Tpocmb.
        END.
        IF x-ImporteCosto > 0 THEN x-MargenUtilidad = ( (f-PreVta / pFactor) - x-ImporteCosto ) / x-ImporteCosto * 100.
        IF x-MargenUtilidad < 0 THEN x-MargenUtilidad = 0.

        /* BUSCAMOS EL RANGO ADECUADO */
        FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
                AND FacTabla.Tabla = 'TC'
                AND FacTabla.Codigo BEGINS '00':
            IF x-MargenUtilidad >= FacTabla.Valor[1] AND x-MargenUtilidad < FacTabla.Valor[2] THEN DO:
                f-PreVta = f-Prevta * (1 + FacTabla.Valor[3] / 100).
                f-PreBas = f-PreBas * (1 + FacTabla.Valor[3] / 100).
                LEAVE.
            END.
        END.                
    END.
END CASE.

/* *********************************************************************************** */
/* Determinamos el Flete Unitario */
/* *********************************************************************************** */
/* 1ro. Factor Harold Segura */
/* *********************************************************************************** */
RUN vtagn/flete-unitario-general-v01.p (INPUT pCodMat,
                                        INPUT pCodDiv,
                                        INPUT pCODMON,
                                        INPUT pFactor,
                                        OUTPUT f-FleteUnitario).
/* *********************************************************************************** */
/* 2do. Factor Karin Rodhenberg */
/* *********************************************************************************** */
RUN gn/factor-porcentual-flete-v2.p (INPUT pcoddiv, 
                                     INPUT pCodMat,
                                     INPUT-OUTPUT f-FleteUnitario, 
                                     INPUT "",  /* s-TpoPed: Parámetro fuera de uso */
                                     INPUT pFactor, 
                                     INPUT pCodMon).
/* *********************************************************************************** */
/* *********************************************************************************** */
/* Aplicamos redondeo final */
/* OJO: Control de Precio Base */
F-PREBAS = F-PREVTA.
RUN lib/RedondearMas (F-PREBAS, pNRODEC, OUTPUT F-PREBAS).
RUN lib/RedondearMas (F-PREVTA, pNRODEC, OUTPUT F-PREVTA).

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Precio-Division) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Division Procedure 
PROCEDURE Precio-Division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ****************************************************************************************** */
/* Rutina única */
/* ****************************************************************************************** */
FIND VtaListaMay WHERE VtaListaMay.codcia = s-codcia AND
    VtaListaMay.coddiv = pCodDiv AND
    VtaListamay.codmat = pCodMat
    NO-LOCK NO-ERROR.

{pri/PrecioFinalMayoristaGeneral.i ~
    &Tabla=VtaListaMay ~
    &PreVta=F-PREVTA ~
    &Promocional="~
    /* Tomamos el mayor descuento */ ~
    DEF VAR x-Old-Descuento AS DEC NO-UNDO. ~
    x-Old-Descuento = 0. ~
    FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND ~
        VtaDctoProm.CodDiv = pCodDiv AND ~
        VtaDctoProm.CodMat = Almmmatg.CodMat AND ~
        VtaDctoProm.FlgEst = 'A' AND ~
        (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin): ~
        /* Solo en caso de EVENTOS existe el VIP, MR */ ~
        IF gn-divi.CanalVenta = 'FER' THEN DO: ~
            CASE gn-clie.LocCli:  ~
                WHEN 'VIP' THEN x-DctoPromocional = VtaDctoProm.DescuentoVIP.  ~
                WHEN 'MR' THEN x-DctoPromocional = VtaDctoProm.DescuentoMR. ~
                OTHERWISE x-DctoPromocional = VtaDctoProm.Descuento. ~
            END CASE. ~
        END. ~
        ELSE DO: ~
            x-DctoPromocional = VtaDctoProm.Descuento. ~
        END.
        x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento). ~
        x-Old-Descuento = x-DctoPromocional. ~
    END. ~
" }

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Empresa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Empresa Procedure 
PROCEDURE Precio-Empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ****************************************************************************************** */
/* PROCEDIMIENTO NORMAL */
/* ****************************************************************************************** */
/* Rutina única */
/* ****************************************************************************************** */
{pri/PrecioFinalMayoristaGeneral.i ~
    &Tabla=Almmmatg ~
    &PreVta=F-PREVTA ~
    &Promocional="~
    /* Tomamos el mayor descuento */ ~
    DEF VAR x-Old-Descuento AS DEC NO-UNDO. ~
    x-Old-Descuento = 0. ~
    FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND ~
        VtaDctoProm.CodDiv = pCodDiv AND ~
        VtaDctoProm.CodMat = Almmmatg.CodMat AND ~
        VtaDctoProm.FlgEst = 'A' AND ~
        (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin): ~
        /* Solo en caso de EVENTOS existe el VIP, MR */ ~
        x-DctoPromocional = VtaDctoProm.Descuento. ~
        x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento). ~
        x-Old-Descuento = x-DctoPromocional. ~
    END. ~
    " }

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Utilex) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Utilex Procedure 
PROCEDURE Precio-Utilex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST VtaListaMinGn OF Almmmatg NO-LOCK NO-ERROR.

DEFINE VAR X-CANTI AS DECI    INIT 0.   
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR J AS INTEGER.

/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
/* Ic - 28Nov2022, Correo de Cesar Canus
    Por favor ampliar la regla de negocio para propios 
    Acabo de conversar con Gloria y no le afecta en su gestión esta regla  de negocio que funciona muy bien con Terceros
    
    Gracias        
*/

/* Tomamos el mayor descuento */ 
/* Determinamos el mejor descuento */
DEF VAR x-Old-Descuento AS DEC NO-UNDO. 
DEF VAR x-DctoPromocional AS DEC NO-UNDO.

x-Old-Descuento = 0. 
x-DctoPromocional = 0.
FOR EACH VtaDctoPromMin NO-LOCK WHERE VtaDctoPromMin.CodCia = s-CodCia AND 
    VtaDctoPromMin.CodDiv = pCodDiv AND 
    VtaDctoPromMin.CodMat = Almmmatg.CodMat AND 
    VtaDCtoPromMin.FlgEst = "A" AND
    (TODAY >= VtaDctoPromMin.FchIni AND TODAY <= VtaDctoPromMin.FchFin): 
    x-DctoPromocional = VtaDctoPromMin.Descuento. 
    x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento). 
    x-Old-Descuento = x-DctoPromocional. 
END.
ASSIGN
    Y-DSCTOS = 0
    Z-DSCTOS = 0.
Y-DSCTOS = x-DctoPromocional.
IF AVAILABLE VtaListaMinGn THEN DO:
    X-CANTI = pCanPed * pFactor.
    ASSIGN
        X-RANGO = 0.
    DO J = 1 TO 10:
        IF X-CANTI >= VtaListaMinGn.DtoVolR[J] AND VtaListaMinGn.DtoVolR[J] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = VtaListaMinGn.DtoVolR[J].
            IF X-RANGO <= VtaListaMinGn.DtoVolR[J] THEN DO:
                Z-DSCTOS = VtaListaMinGn.DtoVolD[J].
            END.   
        END.   
    END.
    IF Y-DSCTOS <> 0 OR Z-DSCTOS <> 0 THEN DO:
        IF Y-DSCTOS > Z-DSCTOS THEN DO:
            /* DESCUENTO PROMOCIONAL */
            IF GN-DIVI.FlgDtoProm = YES THEN DO:
                ASSIGN
                    F-PREVTA = f-PreVta
                    Y-DSCTOS = x-DctoPromocional
                    X-TIPDTO = "PROM".
            END.
        END.
        ELSE DO:
            /* DESCUENTO POR VOLUMEN */
            ASSIGN
                X-CANTI = pCanPed * pFactor
                X-RANGO = 0.
            DO J = 1 TO 10:
                IF X-CANTI >= VtaListaMinGn.DtoVolR[J] AND VtaListaMinGn.DtoVolR[J] > 0  THEN DO:
                    /* Determinamos cuál es mayor, el Promocional o Por Volúmen */
                    IF X-RANGO  = 0 THEN X-RANGO = VtaListaMinGn.DtoVolR[J].
                    IF X-RANGO <= VtaListaMinGn.DtoVolR[J] THEN DO:
                        ASSIGN
                            X-RANGO  = VtaListaMinGn.DtoVolR[J]
                            F-PREVTA = f-PreVta
                            Y-DSCTOS = VtaListaMinGn.DtoVolD[J] 
                            X-TIPDTO = "VOL".
                    END.   
                END.   
            END.
        END.
    END.
END.
/* DESCUENTOS ADICIONALES POR DIVISION */
ASSIGN
    z-Dsctos = 0.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

