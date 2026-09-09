&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER x-vtatabla FOR VtaTabla.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description : NUeva rutina 2026

    Author(s)   :
    Created     :
    Notes       : Los precios va a ser cargados a través de una api
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* *************************************************************************** */
/* VARIABLES GLOBALES */
/* *************************************************************************** */
DEF SHARED VAR S-CODCIA AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR sh_hProcPricing AS HANDLE NO-UNDO.

/* ***************************  Definitions  ************************** */
DEF INPUT PARAMETER s-TpoPed AS CHAR.               /* Tipo de Pedido */
DEF INPUT PARAMETER pCodDiv AS CHAR.                /* División o Lista de Precios */
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT-OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.               /* Default 1 */
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-CNDVTA AS CHAR.               /* Condicion de venta */     
DEF INPUT PARAMETER X-CANPED AS DEC.                /* EN la unidad de venta */
DEF INPUT PARAMETER x-NroDec AS INT.
DEF OUTPUT PARAMETER F-PREBAS AS DEC DECIMALS 4.
DEF OUTPUT PARAMETER F-PREVTA AS DEC DECIMALS 4.    /* Precio - Dscto CondVta - ClasfCliente */
DEF OUTPUT PARAMETER F-DSCTOS AS DEC DECIMALS 6.    /* Descuento incluido en el precio unitario base */
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC DECIMALS 6.    /* Descuento por Volumen y/o Promocional */
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC DECIMALS 6.    /* Descuento por evento */
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.              /* Tipo de descuento aplicado (PROM, VOL) */ 
DEF INPUT PARAMETER pClfCli AS CHAR.                 /* Se usa si se quiere forzar la clasificación */
DEF OUTPUT PARAMETER f-FleteUnitario AS DEC.
/* SOlo por compatibilidad */
DEF INPUT  PARAMETER s-TipVta AS CHAR.      /* Lista "A" o "B" (SOLO POR COMPATIBILIDAD) */
DEF INPUT PARAMETER pViewError AS LOG.          /* Mostrar el error en pantalla */

DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

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

/* CONSISTENCIAS BASE */
IF TRUE <> (s-codmat > '') THEN DO:
    pError = "Debe ingresar el código del artículo".
    RETURN 'ADM-ERROR'.
END.

/* VARIABLES LOCALES */
DEF VAR S-TPOCMB  AS DECI NO-UNDO.
DEF VAR x-ClfCli  AS CHAR INIT "C" NO-UNDO.      /* Clasificacion para productos propios */
DEF VAR x-ClfCli2 AS CHAR INIT "C" NO-UNDO.      /* Clasificacion para productos de terceros */
DEF VAR X-PREVTA1 AS DECI NO-UNDO.
DEF VAR X-PREVTA2 AS DECI NO-UNDO.

DEFINE VAR cLineaProducto AS CHAR.

/* VARIABLES DESCUENTOS CALCULADOS */
DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR x-DctoxVolumen    AS DECIMAL DECIMALS 4 NO-UNDO.

/* CONTROL POR DIVISION */
DEF VAR x-FlgDtoVol     LIKE GN-DIVI.FlgDtoVol NO-UNDO.
DEF VAR x-FlgDtoProm    LIKE GN-DIVI.FlgDtoProm NO-UNDO.
DEF VAR x-Libre_C01     LIKE GN-DIVI.Libre_C01 NO-UNDO.     /* Dcto Excluyentes, acumulados o el mejor */
DEF VAR x-Ajuste-por-flete AS LOG NO-UNDO.

/* CONFIGURACIONES DE LA DIVISION */
/* OJO: Configuración de la LISTA DE PRECIOS */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pError = "División: " + pCodDiv + " errada".
    RETURN 'ADM-ERROR'.
END.
/* Solo pasan por aquí si la lista de precios está definid POR DIVISION */
IF s-TpoPed = "E" AND NOT (GN-DIVI.VentaMayorista = 2) THEN DO:
    pError = 'La lista de precios NO es una LISTA POR DIVISION: ' + pCodDiv.
    RETURN "ADM-ERROR".
END.
ASSIGN
    x-FlgDtoVol     = GN-DIVI.FlgDtoVol             /* Descuento por Volumen */
    x-FlgDtoProm    = GN-DIVI.FlgDtoProm            /* Descuento Promocional */
    x-Libre_C01     = GN-DIVI.Libre_C01             /* Tipo de descuento */
    x-Ajuste-por-flete = GN-DIVI.Campo-Log[4].      /* Factor de Ajuste por Flete */

/* *************************************************************************** */
/* CATALOGO DEL PRODUCTO */
/* *************************************************************************** */
FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    pError = 'Producto: ' + s-CodMat + ' NO registrado en el catálogo general'.
    RETURN "ADM-ERROR".
END.
cLineaProducto = Almmmatg.codfam.
/* Unidad de Venta */
IF TRUE <> (s-UndVta > '') THEN DO:
    /*IF Almmmatg.Chr__01 > '' THEN ASSIGN s-UndVta = Almmmatg.Chr__01.*/
    IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndBas.
    IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndStk.
    IF TRUE <> (s-UndVta > '') THEN DO:
        pError = 'Producto: ' + Almmmatg.CodMat + ' NO definida la unidad de venta'.
        RETURN "ADM-ERROR".
    END.
END.
/* Revisemos el factor de conversión */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND 
    Almtconv.Codalter = s-UndVta NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    pError = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
        'Unidad de venta: ' + s-UndVta + CHR(10) +
        'Unidad base: ' + Almmmatg.undbas.
    RETURN "ADM-ERROR".
END.
f-Factor = Almtconv.Equival.
/* *************************************************************************** */
/* Ir a carga-configuracion */
DEF VAR pDiasDctoVol AS INT INIT 60 NO-UNDO.    /* Tope Para % Descuento por Volumen (hasta 60 dias ) */
DEF VAR pDiasDctoPro AS INT INIT 60 NO-UNDO.    /* Tope Para % Descuento Promocional (hasta 60 dias ) */

/* Ic - 23Ene2020, clasificacion de Cliente por Linea de producto */
DEFINE VAR x-tabla-clsfclie-x-linea AS CHAR.

x-tabla-clsfclie-x-linea = "CLSF_CLIE_X_LINEA".

/* *************************************************************************** */
/* CLASIFICACION DEL CLIENTE */
/* *************************************************************************** */
DEF VAR x-MonVta AS INTE NO-UNDO.       /* Moneda de venta de la lista de precios */

/* CLIENTE */
ASSIGN
    x-ClfCli  = "C"         /* Productos Propios */
    x-ClfCli2 = "C".        /* Productos de Terceros */
/* Valor forzado */
IF pClfCli > '' THEN ASSIGN x-ClfCli = pClfCli x-ClfCli2 = pClfCli.     /* OJO */
/* Valores por el cliente */
IF s-CodCli > '' THEN DO:
    FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
        AND gn-clie.CodCli = S-CODCLI 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        pError = 'Cliente (' + s-codcli + ') NO registrado' + CHR(10) +
            'Comunicarse con gestor del maestro de clientes'.
        RETURN 'ADM-ERROR'.
    END.
    IF gn-clie.clfcli  > '' THEN x-ClfCli  = gn-clie.clfcli.
    IF gn-clie.clfcli2 > '' THEN x-ClfCli2 = gn-clie.clfcli2.
    /* *************************************************************************** */
    /* 1/9/2025: César Camus, tabla de excepciones productos propios */
    /* *************************************************************************** */
    IF Almmmatg.CHR__02 = "P" THEN DO:
        FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia 
            AND VtaTabla.Tabla = "CUSTOMER_CLFCLI_CR" 
            AND VtaTabla.Llave_c1 = s-codcli
            AND VtaTabla.Llave_c2 = Almmmatg.codfam
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla AND VtaTabla.Llave_c3 > "" THEN x-ClfCli  = VtaTabla.Llave_c3.
    END.
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
   Temp-Tables and Buffers:
      TABLE: x-vtatabla B "?" ? INTEGRAL VtaTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 10.38
         WIDTH              = 55.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* *************************************************************************** */
/* ******************* CALCULO GENERAL DEL PRECIO DE VENTA ******************* */
/* *************************************************************************** */
/* *************************************************************************** */
/* PRECIOS ESPECIALES POR CONTRATO MARCO Y REMATES */
/* *************************************************************************** */
CASE s-TpoPed:
    WHEN "M" THEN DO:       /* CASO ESPECIAL -> Ventas CONTRATO MARCO */
        RUN Precio-Contrato-Marco.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
        /* *************************************************************************** */
        /* OJO: Control de Precio Base */
        F-PREBAS = F-PREVTA.
        /* *************************************************************************** */
        IF RETURN-VALUE = "OK" THEN RETURN 'OK'.
        /* SI DEVUELVE ADM-OK buscamos precio de acuerdo a la división activa */
    END.
    WHEN "R" THEN DO:       /* CASO ESPECIAL -> REMATES */
        RUN Precio-Remate.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
        /* *************************************************************************** */
        /* OJO: Control de Precio Base */
        F-PREBAS = F-PREVTA.
        /* *************************************************************************** */
        RETURN 'OK'.
    END.
END CASE.
/* *************************************************************************** */
/* CONTINUA LA RUTINA CON EL PRECIO DEL PRICING */
/* DE ACUERDO AL TIPO DE COTIZACION */
/* *************************************************************************** */
CASE s-TpoPed:
    WHEN "E" THEN DO:
    END.
    OTHERWISE DO:
        /* *************************************************************************** */
        /************ Descuento Promocional ************/
        /* RHC 15/07/17 LAS SIGUIENTES REGLAS VIENEN DE EVENTOS ANTERIORES */
        /* Solo afecta a las familias 011 y 013 con excepción de (familia 013 y subfamilia 014) */
        /* *************************************************************************** */
        PROMOCIONAL:    /* RHC 01/10/2020 Y.M. solo para línea 013 */
        DO:
            IF LOOKUP(Almmmatg.CodFam, "013") = 0 THEN LEAVE PROMOCIONAL.
            IF Almmmatg.CodFam = "013" AND Almmmatg.SubFam = "014" THEN LEAVE PROMOCIONAL.
            ASSIGN                                           
                x-FlgDtoVol = YES                                
                x-FlgDtoProm = NO                                
                x-ClfCli = "C"              /* FORZAMOS A "C" */ 
                x-ClfCli2 = "C".    
        END.

        PROMOCIONAL:    /* RHC 29/09/2020 Y.M. no va la línea 013 */
        DO:
            IF LOOKUP(Almmmatg.CodFam, "011") = 0 THEN LEAVE PROMOCIONAL.
            ASSIGN                                           
                x-FlgDtoVol = YES                                
                x-FlgDtoProm = NO                                
                x-Libre_C01 = ""           /* ACUMULATIVAS - Daniel Llican, con autorizacion de Mayra Padilla - 08Abr2022 */
                x-ClfCli = "C"              /* FORZAMOS A "C" */ 
                x-ClfCli2 = "C".    
        END.
        /* *************************************************************************** */
        /* *************************************************************************** */
        /* RHC 19/02/2015 En caso de Fotocopias (011) se amplia el límite a 60 dias */
        /* *************************************************************************** */
        IF Almmmatg.CodFam = "011" THEN pDiasDctoVol = 60.
        IF s-CodMon = 2 AND Almmmatg.CodFam = "011" THEN s-CndVta = "000".   /* Contado */
        /* *************************************************************************** */
        /* RHC 22/07/2016  TRANSFERENCIA GRATUITA */
        /* *************************************************************************** */
        IF S-CNDVTA = "899" THEN DO:
            ASSIGN
                s-CndVta = "000".
        END.
        IF LOOKUP(S-CNDVTA, "899,900") > 0 THEN
            ASSIGN                           
            x-ClfCli = "C"              /* FORZAMOS A "C" */ 
            x-ClfCli2 = "C"
            x-FlgDtoVol = NO
            x-FlgDtoProm = NO                                
            .
    END.
END CASE.
/* *************************************************************************** */
/* *************************************************************************** */
/* RUTINA PRINCIPAL */
/* *************************************************************************** */
/* *************************************************************************** */
DEF VAR hProc AS HANDLE NO-UNDO.
DEF VAR pcReturn AS LONGCHAR NO-UNDO.
DEF VAR pcError  AS LONGCHAR NO-UNDO.

IF VALID-HANDLE(sh_hProcPricing) THEN DO:
    RUN web_api_unit_price IN sh_hProcPricing (INPUT s-CodMat,
                                               INPUT (IF Almmmatg.CHR__02 = "P" THEN x-ClfCli ELSE x-ClfCli2),
                                               INPUT s-CndVta,
                                               INPUT s-CodCli,
                                               INPUT pCodDiv,      /* OJO */
                                               OUTPUT pcReturn,
                                               OUTPUT pcError).
    /* Grabe error */
    IF pcError > '' THEN DO:
        pError = "ERROR API PRICING: " + CHR(10) + STRING(pcError).
        RETURN 'ADM-ERROR'.
    END.
END.
ELSE DO:
    pError = "ERROR API PRICING: Librería no cargada".
    RETURN 'ADM-ERROR'.
END.
/* ***************************************************************************************** */
/* 02/11/2023: Precio Contrato C.Camus */
/* 06/03/2024 Orden de ejecución */
/* ***************************************************************************************** */
DEF VAR pPrecioContrato AS DECI NO-UNDO.

IF ENTRY(7,pcReturn,":") = "Y" THEN pPrecioContrato = DECIMAL(ENTRY(2,pcReturn,":")).

/* VALORES QUE DEVUELVE EL API DEL PRICING */
x-MonVta = DECIMAL(ENTRY(3,pcReturn,":")).      /* Moneda a la que está la lista de precios */
s-TpoCmb = DECIMAL(ENTRY(4,pcReturn,":")).      /* Tipo de cambio a considerar */
f-PreVta = DECIMAL(ENTRY(2,pcReturn,":")).      /* Precio Unitario Lista de Precios */

/* ************************************************************************************************** */
/* OJO: 02/11/2023: C.Camus Si tiene precio contrato entonces SI afecto a RECARGA y NO afectoa  FLETE */
/* ************************************************************************************************** */
CASE TRUE:
    WHEN pPrecioContrato <= 0 THEN DO:      /* NO ES CONTRATO */
        /* *************************************************************************************** */
        CASE TRUE:
            WHEN s-TpoPed = "E" THEN DO:       /* EXPOLIBRERIA */
                RUN Precio-Expolibreria.
                IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
            END.
            OTHERWISE DO:
                /* Contrato Marco no lleva descuentos */
                IF s-TpoPed = "M" THEN ASSIGN x-FlgDtoVol = NO x-FlgDtoProm = NO.
                RUN Precio-Tiendas.
                IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
            END.
        END CASE.

        /* PRECIO CONTRATOS NO AFECTO A FLETE */
        /* *************************************************************************** */
        /* Determinamos el Flete Unitario */
        /* *************************************************************************** */
        /* 1ro. Factor Harold Segura */
        /* *************************************************************************** */
        RUN vtagn/flete-unitario-general-v01.p (s-CodMat,
                                                pCodDiv,
                                                S-CODMON,
                                                f-Factor,
                                                OUTPUT f-FleteUnitario).
        /* *************************************************************************** */
        /* 2do. Factor Karin Rodhenberg */
        /* *************************************************************************** */
        RUN gn/factor-porcentual-flete-v3.p (INPUT pcoddiv, 
                                             INPUT s-CodMat,
                                             INPUT-OUTPUT f-FleteUnitario, 
                                             INPUT s-TpoPed, 
                                             INPUT f-factor, 
                                             INPUT s-CodMon,
                                             INPUT f-PreVta).
    END.
    OTHERWISE DO:
        /* PRECIO BASE Y UNIDAD DE VENTA */
        ASSIGN
            f-PreVta = pPrecioContrato * f-Factor
            Y-DSCTOS = 0
            x-TipDto = "CONTRATO".

        IF S-CODMON = 1 THEN DO:
            IF x-MonVta = 1 THEN ASSIGN f-PreVta = f-PreVta /** F-FACTOR*/.
            ELSE ASSIGN f-PreVta = f-PreVta * S-TPOCMB /** F-FACTOR*/.
        END.
        IF S-CODMON = 2 THEN DO:
            IF x-MonVta = 2 THEN ASSIGN f-PreVta = f-PreVta /** F-FACTOR*/.
            ELSE ASSIGN f-PreVta = (f-PreVta / S-TPOCMB) /** F-FACTOR*/.
        END.
        ASSIGN
            f-PreBas = f-PreVta.
        /************************************************/
        RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).
        /************************************************/
    END.
END CASE.
/* TODAS LAS LISTAS AFECTAS A RECARGO */
/* ***************************************************************************************** */
/* 30/10/2023: Incremento de precio por RECARGO (papel fill) C.Camus */
/* ***************************************************************************************** */
RUN Recargo.

/* ***************************************************************************************** */
/* DESCUENTO ESPECIAL POR EVENTO Y POR DIVISION (SOLO SI NO TIENE DESCUENTO POR VOL O PROMO) */
/* ***************************************************************************************** */
ASSIGN z-Dsctos = 0.

/* ***************************************************************************************** */
/* OJO: Control de Precio Base */
F-PREBAS = F-PREVTA.
/* *************************************************************************** */

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-carga_configuracion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga_configuracion Procedure 
PROCEDURE carga_configuracion PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Ic - 21Mar2025
    Correo de Carla Tenazoa, confirmado por Cesar Camus, avalado por Rodolfo Salas que modifica la politica
    Maximo dias para aplicar los descuentos por promocion y volumen por articulo 
*/

/* Default */
pDiasDctoVol = 60.     /* Tope Para % Descuento por Volumen (hasta 60 dias ) */
pDiasDctoPro = 60.

DEFINE VAR cTabla AS CHAR NO-UNDO.
DEFINE VAR cLlave_c1 AS CHAR NO-UNDO.
DEFINE VAR cLlave_c2 AS CHAR NO-UNDO.
DEFINE VAR cLlave_c3 AS CHAR NO-UNDO.
DEFINE VAR cLlave_c4 AS CHAR NO-UNDO.

cTabla = "CONFIG-VTAS".
cLlave_c1 = "MAX_DIAS_APLICA_DSCTO_PROMO_VOL".
cLlave_c2 = "LINEA-DIVISION".
cLlave_c3 = cLineaProducto.
cLlave_c4 = pCodDiv.

/* Excepciones */
FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = cTabla AND
    vtatabla.llave_c1 = cLlave_c1 AND 
    vtatabla.llave_c2 = cLlave_c2 AND
    vtatabla.llave_c3 = cLlave_c3 AND 
    vtatabla.llave_c4 = cLlave_c4 NO-LOCK NO-ERROR.
IF AVAILABLE vtatabla THEN DO:
    cLlave_c2 = "LINEA".
    cLlave_c3 = cLineaProducto.

    pDiasDctoPro = vtatabla.valor[1].
    pDiasDctoVol = vtatabla.valor[2].

    /* Nivel de division */
    IF pDiasDctoPro > 0 AND pDiasDctoVol > 0 THEN RETURN.

    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = cTabla AND
        vtatabla.llave_c1 = cLlave_c1 AND 
        vtatabla.llave_c2 = cLlave_c2 AND
        vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        IF pDiasDctoPro <= 0 THEN pDiasDctoPro = vtatabla.valor[1].
        IF pDiasDctoVol <= 0 THEN pDiasDctoVol = vtatabla.valor[2].
    END.
END.
IF pDiasDctoPro > 0 AND pDiasDctoVol > 0 THEN RETURN.

/* Globales */
cLlave_c2 = "GLOBAL".
cLlave_c3 = "*".

FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = cTabla AND
    vtatabla.llave_c1 = cLlave_c1 AND vtatabla.llave_c2 = cLlave_c2 AND
    vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.
IF AVAILABLE vtatabla THEN DO:
    pDiasDctoPro = vtatabla.valor[1].
    pDiasDctoVol = vtatabla.valor[2].
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Contrato-Marco) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Contrato-Marco Procedure 
PROCEDURE Precio-Contrato-Marco PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-FlgDtoClfCli AS LOG NO-UNDO.
DEF VAR x-FlgDtoCndVta AS LOG NO-UNDO.
DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.

/* RHC 26/03/2015 DESCUENTO PROMOCIONAL Y VOLUMEN */
FIND FIRST Almmmatp OF Almmmatg NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatp THEN RETURN 'ADM-OK'.

/* PRECIO BASE Y UNIDAD DE VENTA */
ASSIGN
    F-PreVta = Almmmatp.PreOfi * f-Factor   /* OJO */
    s-tpocmb = Almmmatg.TpoCmb      /* ¿? */
    pDiasDctoPro = 999999
    x-FlgDtoClfCli = NO
    x-FlgDtoCndVta = NO
    x-FlgDtoProm = YES
    x-FlgDtoVol = YES
    x-Libre_C01 = ""    /* EXCLUYENTES */
    x-MonVta = 1        /* Siempre en Soles */
    .

/* ASSIGN                                                                          */
/*     F-PreBas = Almmmatp.PreOfi                                                  */
/*     s-UndVta = Almmmatp.Chr__01                                                 */
/*     pDiasDctoPro = 999999                                                       */
/*     x-FlgDtoClfCli = NO                                                         */
/*     x-FlgDtoCndVta = NO                                                         */
/*     x-FlgDtoProm = YES                                                          */
/*     x-FlgDtoVol = YES                                                           */
/*     x-Libre_C01 = ""    /* EXCLUYENTES */                                       */
/*     .                                                                           */
/* IF TRUE <> (s-UndVta > '') THEN s-UndVta = Almmmatg.Chr__01.                    */
/* IF TRUE <> (s-UndVta > '') THEN s-UndVta = Almmmatg.UndBas.                     */
/*                                                                                 */
/* IF TRUE <> (s-UndVta > '') THEN DO:                                             */
/*     pError = 'Producto ' + Almmmatg.CodMat + ' NO definido la unidad de venta'. */
/*     RETURN "ADM-ERROR".                                                         */
/* END.                                                                            */

{pri/unit-price-credit-sale.i ~
    &Tabla=Almmmatp ~
    /*&PreVta=Almmmatp.PreOfi ~*/
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

&IF DEFINED(EXCLUDE-Precio-Division) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Division Procedure 
PROCEDURE Precio-Division PRIVATE :
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
    VtaListamay.codmat = s-CodMat
    NO-LOCK NO-ERROR.

{pri/unit-price-credit-sale.i ~
    &Tabla=VtaListaMay ~
    /*&PreVta=F-PREVTA ~*/
    &Promocional="~
    /* Tomamos el mayor descuento */ ~
    DEF VAR x-Old-Descuento AS DEC NO-UNDO. ~
    x-Old-Descuento = 0. ~
    FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND ~
        VtaDctoProm.CodDiv = pCodDiv AND ~
        VtaDctoProm.CodMat = s-CodMat AND ~
        VtaDctoProm.FlgEst = 'A' AND ~
        (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin): ~
        /* Solo en caso de EVENTOS existe el VIP, MR */ ~
        x-DctoPromocional = VtaDctoProm.Descuento. ~
        x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento). ~
        x-Old-Descuento = x-DctoPromocional. ~
    END. ~
    " }
/* ****************************************************************************************** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Empresa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Empresa Procedure 
PROCEDURE Precio-Empresa PRIVATE :
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
{pri/unit-price-credit-sale.i ~
    &Tabla=Almmmatg ~
    /*&PreVta=F-PREVTA ~*/
    &Promocional="~
    /* Tomamos el mayor descuento */ ~
    DEF VAR x-Old-Descuento AS DEC NO-UNDO. ~
    x-Old-Descuento = 0. ~
    FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND ~
        VtaDctoProm.CodDiv = pCodDiv AND ~
        VtaDctoProm.CodMat = s-CodMat AND ~
        VtaDctoProm.FlgEst = 'A' AND ~
        (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin): ~
        /* Solo en caso de EVENTOS existe el VIP, MR */ ~
        x-DctoPromocional = VtaDctoProm.Descuento. ~
        x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento). ~
        x-Old-Descuento = x-DctoPromocional. ~
    END. ~
    " }
/* ****************************************************************************************** */

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Expolibreria) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Expolibreria Procedure 
PROCEDURE Precio-Expolibreria PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    F-PreVta = f-PreVta * f-Factor      /* En unidades de venta */
    F-PreBas = f-PreVta.                /* Valor por Defecto */
/* ****************************************************************************************** */
/* CONFIGURACION DE PRECIOS EVENTO */
/* ****************************************************************************************** */
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

FIND VtaListaMay WHERE VtaListaMay.codcia = s-codcia 
    AND VtaListaMay.coddiv = pCodDiv
    AND VtaListaMay.codmat = s-CodMat
    NO-LOCK NO-ERROR.

{pri/unit-price-credit-sale.i ~
    &Tabla=VtaListaMay ~
    /*&PreVta=F-PREVTA ~*/
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
/* ****************************************************************************************** */
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Remate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Remate Procedure 
PROCEDURE Precio-Remate PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* FACTOR DE EQUIVALENCIA */
/* s-UndVta = Almmmatg.Chr__01.                                                                                 */
/* IF TRUE <> (s-UndVta > '') THEN s-UndVta = Almmmatg.UndBas.                                                  */
/* IF TRUE <> (s-UndVta > '') THEN DO:                                                                          */
/*     pError = 'Producto ' + Almmmatg.CodMat + ' NO definido la unidad de venta'.                              */
/*     RETURN "ADM-ERROR".                                                                                      */
/* END.                                                                                                         */
/* FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas                                                      */
/*     AND Almtconv.Codalter = s-undvta                                                                         */
/*     NO-LOCK NO-ERROR.                                                                                        */
/* IF NOT AVAILABLE Almtconv THEN DO:                                                                           */
/*     pError = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) + */
/*         '   Unidad Stock: ' + Almmmatg.UndBas + CHR(10) +                                                    */
/*         'Unidad de Venta: ' + s-UndVta.                                                                      */
/*     RETURN "ADM-ERROR".                                                                                      */
/* END.                                                                                                         */
/* F-FACTOR = Almtconv.Equival.                                                                                 */

FIND VtaTabla WHERE Vtatabla.codcia = s-codcia
    AND Vtatabla.tabla = 'REMATES'
    AND Vtatabla.llave_c1 = s-codmat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    pError = "Producto en REMATE NO tiene precio de venta".
    RETURN "ADM-ERROR".
END.
IF s-CodMon = Almmmatg.MonVta THEN F-PREBAS = VtaTabla.Valor[1].
ELSE IF s-CodMon = 1 THEN F-PREBAS = ROUND ( VtaTabla.Valor[1] * Almmmatg.TpoCmb, 6 ).
ELSE F-PREBAS = ROUND ( VtaTabla.Valor[1] / Almmmatg.TpoCmb, 6 ).
     
ASSIGN
    F-PREVTA = F-PREBAS * f-Factor.     /* OJO */
RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Tiendas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Tiendas Procedure 
PROCEDURE Precio-Tiendas PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN
        F-PreVta = f-PreVta * f-Factor      /* En unidades de venta */
        F-PreBas = f-PreVta.                /* Valor por Defecto */
    /* *************************************************************************** */
    /* *************************************************************************** */
    /* PRECIO DE VENTA Y DESCUENTOS PROMOCIONALES O POR VOLUMEN DE VENTA  */
    /* *************************************************************************** */
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
    /* *************************************************************************** */

    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Recargo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recargo Procedure 
PROCEDURE Recargo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Recargo AS DECI NO-UNDO.

FIND FacTabla WHERE FacTabla.CodCia = s-codcia AND 
    FacTabla.Tabla = "RECARGO_CREDITOS" AND
    FacTabla.Codigo = pCodDiv NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla THEN DO:
    x-Recargo = FacTabla.Valor[1].
    /* Buscamos excepciones */
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN 
    EXCEPCION:
    DO:
        /* Excepción por SKU */
        FIND FIRST VtaDTabla WHERE VtaDTabla.CodCia = FacTabla.codcia AND
            VtaDTabla.Tabla = FacTabla.tabla AND
            VtaDTabla.Llave = FacTabla.Codigo AND
            VtaDTabla.Tipo = "SKU" AND
            VtaDTabla.LlaveDetalle = Almmmatg.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaDTabla THEN DO:
            x-Recargo = VtaDTabla.Libre_d01.
            LEAVE EXCEPCION.
        END.
        /* Excepción por LINEA */
        FIND FIRST VtaDTabla WHERE VtaDTabla.CodCia = FacTabla.codcia AND
            VtaDTabla.Tabla = FacTabla.tabla AND
            VtaDTabla.Llave = FacTabla.Codigo AND
            VtaDTabla.Tipo = "LINEA" AND
            VtaDTabla.LlaveDetalle = Almmmatg.codfam AND
            VtaDTabla.Libre_c01 = Almmmatg.subfam
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaDTabla THEN DO:
            x-Recargo = VtaDTabla.Libre_d01.
            LEAVE EXCEPCION.
        END.
        ELSE DO:
            FIND FIRST VtaDTabla WHERE VtaDTabla.CodCia = FacTabla.codcia AND
                VtaDTabla.Tabla = FacTabla.tabla AND
                VtaDTabla.Llave = FacTabla.Codigo AND
                VtaDTabla.Tipo = "LINEA" AND
                VtaDTabla.LlaveDetalle = Almmmatg.codfam AND
                TRUE <> (VtaDTabla.Libre_c01 > '') NO-LOCK NO-ERROR.
            IF AVAILABLE VtaDTabla THEN DO:
                x-Recargo = VtaDTabla.Libre_d01.
                LEAVE EXCEPCION.
            END.
        END.
    END.    /* EXCEPCION */
    IF S-CODMON = 2 THEN ASSIGN x-Recargo = (x-Recargo / S-TPOCMB) /** F-FACTOR*/.
    ASSIGN
        f-PreBas = f-PreBas + x-Recargo
        f-PreVta = f-PreVta + x-Recargo.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

