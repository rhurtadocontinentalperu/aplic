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
DEF INPUT PARAMETER s-TpoPed AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* Lista de Precios o División */
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT-OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.       /* Default 1 */
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-CNDVTA AS CHAR.       
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF OUTPUT PARAMETER F-PREBAS AS DEC DECIMALS 4.
DEF OUTPUT PARAMETER F-PREVTA AS DEC DECIMALS 4.    /* Precio - Dscto CondVta - ClasfCliente */
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.       /* Descuento incluido en el precio unitario base */
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.       /* Descuento por Volumen y/o Promocional */
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.       /* Descuento por evento */
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.      /* Tipo de descuento aplicado (PROM, VOL) */ 
DEF INPUT PARAMETER pClfCli AS CHAR.        /* SOlo si tiene un valor me sirve */
DEF OUTPUT PARAMETER f-FleteUnitario AS DEC.
DEF INPUT  PARAMETER s-TipVta AS CHAR.      /* Lista "A" o "B" */
DEF INPUT PARAMETER pError AS LOG.          /* Mostrar el error en pantalla */

/* VARIABLES GLOBALES */
DEF SHARED VAR S-CODCIA AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

/* TIPO DE PEDIDO:
R: Remates
S: Supermercados
M: Contrato Marco Institucionales
P: Provincias 
N: Normal
E: Expolibrerias
VU: ValesUtilex
LF: Lista Express WEB
LU: Lista Express UTILEX
MM: Contrato Marco Especial
*/

/* VARIABLES LOCALES */
DEF VAR S-TPOCMB AS DEC NO-UNDO.
DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR x-ClfCli  AS CHAR NO-UNDO.      /* Clasificacion para productos propios */
DEF VAR x-ClfCli2 AS CHAR NO-UNDO.      /* Clasificacion para productos de terceros */
DEF VAR X-PREVTA1 AS DECI NO-UNDO.
DEF VAR X-PREVTA2 AS DECI NO-UNDO.

DEF VAR x-PreBase-Dcto AS DECI NO-UNDO.

/* VARIABLES DESCUENTOS CALCULADOS */
DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 6 NO-UNDO.
DEF VAR x-DctoxVolumen    AS DECIMAL DECIMALS 6 NO-UNDO.

/* CONTROL POR LISTA DE PRECIOS/DIVISION */
DEF VAR x-FlgDtoVol LIKE GN-DIVI.FlgDtoVol NO-UNDO.
DEF VAR x-FlgDtoProm LIKE GN-DIVI.FlgDtoProm NO-UNDO.
DEF VAR x-FlgDtoClfCli LIKE GN-DIVI.FlgDtoClfCli NO-UNDO.
DEF VAR x-FlgDtoCndVta LIKE GN-DIVI.FlgDtoCndVta NO-UNDO.
DEF VAR x-Libre_C01 LIKE GN-DIVI.Libre_C01 NO-UNDO.     /* Dcto Exluyenbres, acumulados o el mejor */
DEF VAR x-Ajuste-por-flete AS LOG NO-UNDO.
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK.
/* *********************************************************************************************** */
/* CONTROL DE VIGENCIA DE LA LISTA */
/* *********************************************************************************************** */
IF GN-DIVI.Campo-Date[1] <> ? AND TODAY < GN-DIVI.Campo-Date[1] THEN DO:
    IF pError = YES THEN MESSAGE 'La lista de precios aún no está vigente' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
IF GN-DIVI.Campo-Date[2] <> ? AND TODAY > GN-DIVI.Campo-Date[2] THEN DO:
    IF pError = YES THEN MESSAGE 'La lista de precios ya no está vigente' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
/* *********************************************************************************************** */
/* *********************************************************************************************** */
ASSIGN
    x-FlgDtoVol         = GN-DIVI.FlgDtoVol             /* Descuento por Volumen */
    x-FlgDtoProm        = GN-DIVI.FlgDtoProm           /* Descuento Promocional */
    x-FlgDtoClfCli      = GN-DIVI.FlgDtoClfCli       /* Descuento por Clasificacion */
    x-FlgDtoCndVta      = GN-DIVI.FlgDtoCndVta       /* Descuento por venta */
    x-Libre_C01         = GN-DIVI.Libre_C01             /* Tipo de descuento */
    x-Ajuste-por-flete  = GN-DIVI.Campo-Log[4].  /* Factor de Ajuste por Flete */
/* Valores de x-Libre_c01:
"Prioridades Excluyentes"   ""
"Prioridades Acumuladas"    "A"
"Busca mejor precio"        "M"
*/

/* CATALOGO DEL PRODUCTO */
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    IF pError = YES THEN MESSAGE 'Producto' s-CodMat 'NO registrado en el catálogo general' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* CLIENTE */
FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA AND gn-clie.CodCli = S-CODCLI NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie AND pError = YES THEN DO:
    MESSAGE 'Cliente (' s-codcli ') NO registrado' SKIP
        'Se continuará el cálculo asumiendo la clasificación C'
        VIEW-AS ALERT-BOX WARNING.
END.

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
         HEIGHT             = 7.27
         WIDTH              = 56.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* *************************************************************************** */
/* ******************* CALCULO GENERAL DEL PRECIO DE VENTA ******************* */
/* *************************************************************************** */
ASSIGN
    MaxCat = 0
    MaxVta = 0
    x-PreBase-Dcto = Almmmatg.PreVta[1]
    F-PreBas = Almmmatg.PreOfi.     /* Valor por Defecto */
/* *************************************************************************** */
/* PRECIOS ESPECIALES POR CONTRATO MARCO Y REMATES */
/* *************************************************************************** */
CASE s-TpoPed:
    WHEN "M" THEN DO:       /* CASO ESPECIAL -> Ventas CONTRATO MARCO */
        RUN Precio-Contrato-Marco.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
        IF RETURN-VALUE = "OK" THEN RETURN 'OK'.
        /* SI DEVUELVE ADM-OK buscamos precio de acuerdo a la división activa */
    END.
    WHEN "R" THEN DO:       /* CASO ESPECIAL -> REMATES */
        RUN Precio-Remate.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
        RETURN 'OK'.
    END.
END CASE.
/* *************************************************************************** */
/* CLASIFICACION DEL CLIENTE */
/* *************************************************************************** */
ASSIGN
    x-ClfCli  = "C"         /* Valores por defecto */
    x-ClfCli2 = "C".
IF AVAIL gn-clie AND gn-clie.clfcli  > '' THEN x-ClfCli  = gn-clie.clfcli.
IF AVAIL gn-clie AND gn-clie.clfcli2 > '' THEN x-ClfCli2 = gn-clie.clfcli2.
IF pClfCli > '' THEN ASSIGN x-ClfCli = pClfCli x-ClfCli2 = pClfCli.
/* *************************************************************************** */
/* UNIFICACION DE CRITERIOS DE CALCULO */
/* *************************************************************************** */
/* 2 Tipos de lists de precios: 
Lista de Precio General (Almmmatg)
Lista de Precio x División (VtaListaMay)
*/
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK.
CASE GN-DIVI.VentaMayorista:
    WHEN 1 THEN DO:     /* Lista de Precio General */
        /* *************************************************************************** */
        /* PRECIO BASE Y UNIDAD DE VENTA */
        /* *************************************************************************** */
        ASSIGN
            f-Factor = 1
            x-PreBase-Dcto = Almmmatg.PreVta[1]
            F-PreBas = Almmmatg.PreOfi.     /* Valor por Defecto */
    END.
    WHEN 2 THEN DO:     /* Lista de Precio por División */
        /* *************************************************************************** */
        /* PRECIO BASE Y UNIDAD DE VENTA */
        /* *************************************************************************** */
        FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.CodDiv = pCodDiv NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaListaMay THEN DO:
            IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios:' pCodDiv
                VIEW-AS ALERT-BOX WARNING.
            RETURN "ADM-ERROR".
        END.
        ASSIGN 
            f-Factor = 1
            x-PreBase-Dcto = VtaListaMay.PreOfi
            F-PreBas = VtaListaMay.PreOfi.       /* Precio Lista Por Defecto */
        /* Valores por Defecto: De la Lista de Precios por División */
        IF VtaListaMay.CHR__01 > '' THEN ASSIGN s-UndVta = VtaListaMay.Chr__01.
    END.
END CASE.
IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndBas.
IF TRUE <> (s-UndVta > '') THEN DO:
    IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'NO definido la unidad de venta en la lista:' pCodDiv
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
/* Revisemos el factor de conversión */
IF Almmmatg.UndBas <> s-UndVta THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND Almtconv.Codalter = s-UndVta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat
            'Unidad de venta:' s-UndVta VIEW-AS ALERT-BOX WARNING.
        RETURN "ADM-ERROR".
    END.
    f-Factor = Almtconv.Equival.
END.
/* *************************************************************************** */
/* CONFIGURACION DE PRECIOS EVENTO */
/* *************************************************************************** */
/* Si no ubica una configuración toma por defecto la de la división */
FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-CodCia AND
    VtaDTabla.Tabla = 'CFGLP' AND
    VtaDTabla.Llave = pCodDiv AND
    VtaDTabla.Tipo = Almmmatg.CodFam:
    IF Almmmatg.SubFam = VtaDTabla.Libre_c01 THEN NEXT.     /* Subfamilia (-) */
    IF VtaDTabla.LlaveDetalle > '' AND Almmmatg.SubFam <> VtaDTabla.LlaveDetalle THEN NEXT. /* Subfamilia (+) */
    /* CALCULO DE PRECIO Y DESCUENTO POR PRODUCTO */
    x-FlgDtoCndVta = VtaDTabla.Libre_l01.
    x-FlgDtoClfCli = VtaDTabla.Libre_l02.
    x-FlgDtoVol    = VtaDTabla.Libre_l03.
    x-FlgDtoProm   = VtaDTabla.Libre_l04.
    x-Libre_C01    = VtaDTabla.Libre_c02.   /* "" Excluyentes, "A" acumulados "M" mejor precio */
    LEAVE.
END.
/* ****************************************** */
/* Verificar que el producto es SIN DESCUENTO */
/* ****************************************** */
CASE GN-DIVI.VentaMayorista:
    WHEN 1 THEN DO:     /* Lista de Precios General */
        /************ Descuento Promocional ************/
        /* RHC 15/07/17 LAS SIGUIENTES REGLAS VIENEN DE EVENTOS ANTERIORES */
        /* Solo afecta a las familias 011 y 013 con excepción de (familia 013 y subfamilia 014) */
        /* *************************************************************************** */
        PROMOCIONAL:    /* RHC 25/03/2015 */
        DO:
            IF LOOKUP(Almmmatg.CodFam, "011,013") = 0 THEN LEAVE PROMOCIONAL.
            IF Almmmatg.CodFam = "013" AND Almmmatg.SubFam = "014" THEN LEAVE PROMOCIONAL.
            ASSIGN                                           
/*                 x-FlgDtoVol = YES                              */
/*                 x-FlgDtoProm = NO                              */
/*                 x-FlgDtoClfCli = YES                           */
/*                 x-FlgDtoCndVta = YES                           */
/*                 x-Libre_C01 = "A"           /* ACUMULATIVAS */ */
                x-ClfCli = "C"              /* FORZAMOS A "C" */ 
                x-ClfCli2 = "C".    
        END.
        IF s-CodMon = 2 AND Almmmatg.CodFam = "011" THEN s-CndVta = "000".   /* Contado */
        /* **************************************************************************** */
        /* Ic - 29Ene2016, ValesUtiles sin Dscto */
        IF s-TpoPed = "VU" THEN DO:
            ASSIGN x-FlgDtoClfCli = NO x-FlgDtoCndVta = NO.
        END.
    END.
    WHEN 2 THEN DO:     /* Lista por División */
        CASE VtaListaMay.FlagDesctos:
            WHEN 1 THEN                     /* SIN DESCUENTOS */
                ASSIGN
                    x-FlgDtoClfCli = NO
                    x-FlgDtoCndVta = NO.
        END CASE.
    END.
END CASE.
/* *************************************************************************** */
/* RHC 22/07/2016  TRANSFERENCIA GRATUITA */
/* *************************************************************************** */
IF LOOKUP(S-CNDVTA, "899,900") > 0 THEN
    ASSIGN                           
    x-ClfCli = "C"              /* FORZAMOS A "C" */ 
    x-ClfCli2 = "C"
    s-CndVta = "000"
    x-FlgDtoVol = NO
    x-FlgDtoProm = NO                                
    x-FlgDtoClfCli = YES
    x-FlgDtoCndVta = YES.
/* *************************************************************************** */
/* CALCULAMOS EL PRECIO DE VENTA FINAL */
/* *************************************************************************** */
RUN Precio-de-Venta.
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
/* *************************************************************************** */
/* SOLO PARA PAPEL FOTOCOPIA */
/* *************************************************************************** */
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
CASE GN-DIVI.VentaMayorista:
    WHEN 1 THEN DO:     /* Lista de Precios General */
        IF GN-DIVI.CanalVenta = "TDA" AND s-codmon = 1 AND Almmmatg.codfam = '011' THEN DO:
            CASE TRUE:
                WHEN gn-ConVt.TotDias > 15 AND gn-ConVt.TotDias <= 30 THEN
                    ASSIGN
                    f-PreVta = f-Prevta * (1 + 0 / 100)
                    f-PreBas = f-PreBas * (1 + 0 / 100).
                WHEN gn-ConVt.TotDias > 30 AND gn-ConVt.TotDias <= 45 THEN
                    ASSIGN
                    f-PreVta = f-Prevta * (1 + 1 / 100)
                    f-PreBas = f-PreBas * (1 + 1 / 100).
            END CASE.
        END.
    END.
END CASE.
/* *************************************************************************** */
/* Determinamos el Flete Unitario */
/* *************************************************************************** */
/* 1ro. Factor Harold */
RUN vtagn/flete-unitario-general-v01.p (s-CodMat,
                                     pCodDiv,
                                     S-CODMON,
                                     f-Factor,
                                     OUTPUT f-FleteUnitario).
/* 2do. Factor Rodhenberg */
IF f-FleteUnitario > 0 THEN DO:
    RUN gn/factor-porcentual-flete-v2(INPUT pcoddiv, 
                                      INPUT s-CodMat,
                                      INPUT-OUTPUT f-FleteUnitario, 
                                      INPUT s-TpoPed, 
                                      INPUT f-factor, 
                                      INPUT s-CodMon).
END.
/* *************************************************************************** */
/* *************************************************************************** */

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Precio-Contrato-Marco) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Contrato-Marco Procedure 
PROCEDURE Precio-Contrato-Marco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RHC 26/03/2015 DSCUENTO PROMNOCIONAL Y VOLUMEN */
FIND FIRST Almmmatp OF Almmmatg NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatp THEN DO:
    IF pError = NO THEN RETURN "ADM-ERROR".
    MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de CONTRATO MARCO' SKIP(1)
        '¿Tomamos los precios de la lista por defecto?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN 'ADM-ERROR'.
    ELSE RETURN 'ADM-OK'.
END.
/* PRECIO BASE Y UNIDAD DE VENTA */
ASSIGN
    F-PreBas = Almmmatp.PreOfi
    s-UndVta = Almmmatp.Chr__01
    pDiasDctoPro = 999999
    x-FlgDtoClfCli = NO
    x-FlgDtoCndVta = NO
    x-FlgDtoProm = YES
    x-FlgDtoVol = YES
    x-Libre_C01 = ""
    .

{vta2/PrecioListaxMayorCredito.i &Tabla=Almmmatp ~
    &PreVta=Almmmatp.PreOfi ~
    &Promocional="~
        DO J = 1 TO 10:~
            IF Almmmatp.PromDivi[J] = pCodDiv~
                AND TODAY >= Almmmatp.PromFchD[J]~
                AND TODAY <= Almmmatp.PromFchH[J]~
                AND Almmmatp.PromDto[J] > 0 THEN DO:~
                x-DctoPromocional = Almmmatp.PromDto[J].~
            END.~
        END."}

/* DESCUENTOS ADICIONALES POR DIVISION */
z-Dsctos = 0.
RETURN "OK".

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
IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        '   Unidad Stock:' Almmmatg.UndStk SKIP
        'Unidad de Venta:' s-UndVta
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* VALORES POR DEFECTO */
ASSIGN
    F-FACTOR = Almtconv.Equival     /* Equivalencia */
    s-tpocmb = Almmmatg.TpoCmb.     /* ¿? */
/* ************************************************************* */
/* DESCUENTOS POR CLASIFICACION DE CLIENTES Y CONDICION DE VENTA */
/* ************************************************************* */
/* AHORA DEPENDE SI EL PRODUCTO ES PROPIO O DE TERCEROS */
/* DESCUENTO POR CLASIFICACION DEL PRODUCTO */
ASSIGN
    MaxCat = 0                      /* Descuento por Clasificación del Cliente */
    MaxVta = 0.                     /* Descuento por Condición de Venta */
IF Almmmatg.chr__02 = "P" THEN DO:  /* PROPIOS */
    FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI NO-LOCK NO-ERROR.
    IF AVAIL ClfClie THEN MaxCat = ClfClie.PorDsc.
END.
ELSE DO:        /* TERCEROS */
    FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI2 NO-LOCK NO-ERROR.
    IF AVAIL ClfClie THEN MaxCat = ClfClie.PorDsc1.
END.
/* *************************************************** */
/* DESCUENTO POR CONDICION DE VENTA Y TIPO DE PRODUCTO */
/* *************************************************** */
FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA
    AND Dsctos.clfCli = Almmmatg.Chr__02
    NO-LOCK NO-ERROR.
IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
/* ********************************************************************************* */
/* DESCUENTOS PROMOCIONALES Y POR VOLUMEN: SOLO SI EL VENCIMIENTO ES MENOR A 30 DIAS */                        
/* ********************************************************************************* */
ASSIGN
    x-DctoPromocional = 0
    x-DctoxVolumen = 0.
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
/* ********************************************************************************* */
/************ Descuento Promocional ************/ 
/* ********************************************************************************* */
DEF VAR x-Old-Descuento LIKE x-DctoPromocional NO-UNDO.
IF AVAILABLE gn-convt AND 
    (gn-convt.totdias <= pDiasDctoPro OR gn-convt.libre_l02 = YES)      /* Condición unica campaña (404) */
    THEN DO:
    /* Tomamos el mayor descuento */
    x-Old-Descuento = 0.
    FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND
        VtaDctoProm.CodDiv = pCodDiv AND 
        VtaDctoProm.CodMat = Almmmatg.CodMat AND
        (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin):
        /* Solo en caso de EVENTOS existe el VIP, MR */
        IF gn-divi.CanalVenta = "FER" THEN DO:
            CASE gn-clie.LocCli: 
                WHEN 'VIP' THEN x-DctoPromocional = VtaDctoProm.DescuentoVIP. 
                WHEN 'MR' THEN x-DctoPromocional = VtaDctoProm.DescuentoMR. 
                OTHERWISE x-DctoPromocional = VtaDctoProm.Descuento. 
            END CASE. 
        END.
        ELSE DO:
            x-DctoPromocional = VtaDctoProm.Descuento. 
        END.
        x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento).
        x-Old-Descuento = x-DctoPromocional.
    END.
END.
/* ********************************************************************************* */
/*************** Descuento por Volumen ****************/
/* ********************************************************************************* */
IF AVAILABLE gn-convt AND 
    (gn-convt.totdias <= pDiasDctoVol OR gn-convt.libre_l02 = YES)      /* Condición unica campaña (404) */
    THEN DO:
    /* Tomamos el mayor descuento */
    x-Old-Descuento = 0.
    FOR EACH VtaDctoVol NO-LOCK WHERE VtaDctoVol.CodCia = s-CodCia AND
        VtaDctoVol.CodDiv = pCodDiv AND 
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
END.
/* ********************************************************************************* */
/* DEPURAMOS LOS PORCENTAJES DE DESCUENTOS */
/* ********************************************************************************* */
IF x-FlgDtoClfCli = NO THEN MaxCat = 0.     /* Descuento por Clasificacion */
IF x-FlgDtoCndVta = NO THEN MaxVta = 0.     /* Descuento por Condicion de Venta */
IF x-FlgDtoClfCli = YES AND x-ClfCli = 'C' AND GN-DIVI.PorDtoClfCli > 0 
    THEN MaxCat = GN-DIVI.PorDtoClfCli.     /* Descuento especial Categoria C */
IF x-FlgDtoVol  = NO THEN x-DctoxVolumen    = 0.
IF x-FlgDtoProm = NO THEN x-DctoPromocional = 0.
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
                F-PREBAS = x-PreBase-Dcto       /* OJO => Se cambia Precio Base */
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            IF x-DctoxVolumen > 0 THEN 
                ASSIGN
                    Y-DSCTOS = x-DctoxVolumen    /* OJO */
                    X-TIPDTO = "VOL".
        END.
        /* Si no hay descuento promocional ni volumen => x clasificación y venta */
        IF Y-DSCTOS = 0 THEN F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
    END.
    WHEN x-Libre_C01 = "A" THEN DO:     /* Descuentos Acumulados */
        F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
        IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
            ASSIGN
                F-PREBAS = x-PreBase-Dcto       /* OJO => Se cambia Precio Base */
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            IF x-DctoxVolumen > 0 THEN 
                ASSIGN
                    Y-DSCTOS = x-DctoxVolumen   /* OJO */
                    X-TIPDTO = "VOL".
        END.
    END.
    WHEN x-Libre_c01 = "M" THEN DO:     /* Mejor Descuento */
        F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
        IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
            ASSIGN
                F-PREBAS = x-PreBase-Dcto       /* OJO => Se cambia Precio Base */
                Y-DSCTOS = MAXIMUM( x-DctoPromocional, x-DctoxVolumen).
        END.
    END.
END CASE.

/* ******************************** */
/* PRECIO BASE A LA MONEDA DE VENTA */
/* ******************************** */
PRECIOBASE:
DO:
    IF S-CODMON = 1 THEN DO:
        IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
        ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB /** F-FACTOR*/.
    END.
    IF S-CODMON = 2 THEN DO:
        IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
        ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.
    END.
END.
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
/************************************************/
/*RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).*/
RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).
/************************************************/
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Remate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Remate Procedure 
PROCEDURE Precio-Remate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* FACTOR DE EQUIVALENCIA */
s-UndVta = Almmmatg.Chr__01.
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        '   Unidad Stock:' Almmmatg.UndBas SKIP
        'Unidad de Venta:' s-UndVta
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival.

FIND VtaTabla WHERE Vtatabla.codcia = s-codcia
    AND Vtatabla.tabla = 'REMATES'
    AND Vtatabla.llave_c1 = s-codmat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    IF pError = YES THEN MESSAGE "Producto en REMATE NO tiene precio de venta"
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF s-CodMon = Almmmatg.MonVta THEN F-PREBAS = VtaTabla.Valor[1].
ELSE IF s-CodMon = 1 THEN F-PREBAS = ROUND ( VtaTabla.Valor[1] * Almmmatg.TpoCmb, 6 ).
ELSE F-PREBAS = ROUND ( VtaTabla.Valor[1] / Almmmatg.TpoCmb, 6 ).
     
ASSIGN
    F-PREVTA = F-PREBAS /** f-Factor*/.
RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

