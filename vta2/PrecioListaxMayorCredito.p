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
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT-OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-CNDVTA AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF OUTPUT PARAMETER F-PREBAS AS DEC DECIMALS 4.
DEF OUTPUT PARAMETER F-PREVTA AS DEC DECIMALS 4.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.       /* Descuento incluido en el precio unitario base */
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.       /* Descuento por Volumen y/o Promocional */
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.       /* Descuento por evento */
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.      /* Tipo de descuento aplicado (PROM, VOL) */ 
DEF INPUT  PARAMETER s-TipVta AS CHAR.      /* Lista "A" o "B" */
DEF INPUT PARAMETER pError AS LOG.          /* Mostrar el error en pantalla */

/* TIPO DE PEDIDO:
R: Remates
S: Supermercados
M: Contrato Marco
P: Provincias 
*/

/* VARIABLES GLOBALES */
DEF SHARED VAR S-CODCIA AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

/* VARIABLES LOCALES */
DEF VAR S-TPOCMB AS DEC NO-UNDO.
DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR x-ClfCli  AS CHAR NO-UNDO.      /* Clasificacion para productos propios */
DEF VAR x-ClfCli2 AS CHAR NO-UNDO.      /* Clasificacion para productos de terceros */
DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.
/* VARIABLES DESCUENTOS CALCULADOS */
DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR x-DctoxVolumen    AS DECIMAL DECIMALS 4 NO-UNDO.

/* CONTROL POR DIVISION */
DEF VAR x-FlgDtoVol LIKE GN-DIVI.FlgDtoVol NO-UNDO.
DEF VAR x-FlgDtoProm LIKE GN-DIVI.FlgDtoProm NO-UNDO.
DEF VAR x-FlgDtoClfCli LIKE GN-DIVI.FlgDtoClfCli NO-UNDO.
DEF VAR x-FlgDtoCndVta LIKE GN-DIVI.FlgDtoCndVta NO-UNDO.
DEF VAR x-Libre_C01 LIKE GN-DIVI.Libre_C01 NO-UNDO.     /* Dcto Exluyenbres, acumulados o el mejor */

/* CONFIGURACIONES DE LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK.
ASSIGN
    x-FlgDtoVol = GN-DIVI.FlgDtoVol             /* Descuento por Volumen */
    x-FlgDtoProm = GN-DIVI.FlgDtoProm           /* Descuento Promocional */
    x-FlgDtoClfCli = GN-DIVI.FlgDtoClfCli       /* Descuento por Clasificacion */
    x-FlgDtoCndVta = GN-DIVI.FlgDtoCndVta       /* Descuento por venta */
    x-Libre_C01 = GN-DIVI.Libre_C01.            /* Tipo de descuento */

/* CATALOGO DEL PRODUCTO */
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    IF pError = YES THEN MESSAGE 'Producto' s-CodMat 'NO registrado en el catálogo general' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* CLIENTE */
FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
    AND gn-clie.CodCli = S-CODCLI 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie AND pError = YES THEN DO:
    MESSAGE 'Cliente (' s-codcli ') NO registrado' SKIP
        'Comunicarse con el administrador del sistema' SKIP
        'Se continuará el cálculo asumiendo la clasificación C'
        VIEW-AS ALERT-BOX WARNING.
END.

DEF VAR pDiasDctoVol AS INT INIT 30 NO-UNDO.    /* Tope Para % Descuento por Volumen (hasta 30 dias ) */
DEF VAR pDiasDctoPro AS INT INIT 30 NO-UNDO.    /* Tope Para % Descuento Promocional (hasta 30 dias ) */

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
         HEIGHT             = 7.19
         WIDTH              = 56.57.
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
    F-PreBas = Almmmatg.PreOfi.     /* Valor por Defecto */
/* *********************************************** */
/* PRECIOS ESPECIALES POR CONTRATO MARCO Y REMATES */
/* *********************************************** */
CASE s-TpoPed:
    WHEN "M" THEN DO:       /* CASO ESPECIAL -> Ventas CONTRATO MARCO */
        RUN Precio-Contrato-Marco.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
        RETURN 'OK'.
    END.
    WHEN "R" THEN DO:       /* CASO ESPECIAL -> REMATES */
        RUN Precio-Remate.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
        RETURN 'OK'.
    END.
/*     WHEN "LF" THEN DO:      /* LISTA FACIL */                    */
/*         RUN vta2/Precio-Utilex-Menor (pCodDiv,                  */
/*                                        s-CodMon,                 */
/*                                        s-TpoCmb,                 */
/*                                        OUTPUT s-UndVta,          */
/*                                        OUTPUT f-Factor,          */
/*                                        s-CodMat,                 */
/*                                        x-CanPed,                 */
/*                                        4,                        */
/*                                        '',       /* s-codbko, */ */
/*                                        '',                       */
/*                                        '',                       */
/*                                        '',                       */
/*                                        '',                       */
/*                                        OUTPUT f-PreBas,          */
/*                                        OUTPUT f-PreVta,          */
/*                                        OUTPUT f-Dsctos,          */
/*                                        OUTPUT y-Dsctos,          */
/*                                        OUTPUT z-Dsctos,          */
/*                                        OUTPUT x-TipDto ).        */
/*         IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".   */
/*         RETURN 'OK'.                                             */
/*     END.                                                         */
END CASE.
/* *********************************************** */
/* PRECIOS ESPECIALES PARA CONTRATOS (INACTIVO)    */
/* *********************************************** */
RUN Precio-Contrato.
IF RETURN-VALUE = "OK" THEN RETURN "OK".
/* *********************************************** */

/* ************************* */
/* CLASIFICACION DEL CLIENTE */
/* ************************* */
ASSIGN
    x-ClfCli  = "C"         /* Valores por defecto */
    x-ClfCli2 = "C".
IF AVAIL gn-clie AND gn-clie.clfcli <> ''  THEN x-ClfCli  = gn-clie.clfcli.
IF AVAIL gn-clie AND gn-clie.clfcli2 <> '' THEN x-ClfCli2 = gn-clie.clfcli2.

/************ Descuento Promocional ************/
PROMOCIONAL:    /* RHC 25/03/2015 */
DO:
    /* Solo afecta a las familias 011 y 013 con excepción de (familia 013 y subfamilia 014)
    */
    IF LOOKUP(Almmmatg.CodFam, "011,013") = 0 THEN LEAVE PROMOCIONAL.
    IF Almmmatg.CodFam = "013" AND Almmmatg.SubFam = "014" THEN LEAVE PROMOCIONAL.
    ASSIGN                                           
         x-FlgDtoVol = YES                                
         x-FlgDtoProm = NO                                
         x-FlgDtoClfCli = YES                             
         x-FlgDtoCndVta = YES                             
         x-Libre_C01 = "A"           /* ACUMULATIVAS */   
         x-ClfCli = "C"              /* FORZAMOS A "C" */ 
         x-ClfCli2 = "C".                                 
END.
/* IF LOOKUP(Almmmatg.CodFam, "011,013") > 0 THEN            */
/*     ASSIGN                                                */
/*          x-FlgDtoVol = YES                                */
/*          x-FlgDtoProm = NO                                */
/*          x-FlgDtoClfCli = YES                             */
/*          x-FlgDtoCndVta = YES                             */
/*          x-Libre_C01 = "A"           /* ACUMULATIVAS */   */
/*          x-ClfCli = "C"              /* FORZAMOS A "C" */ */
/*          x-ClfCli2 = "C".                                 */

/* RHC 17/02/2015 NO aplica descuento por volumen SOLO DIVISION ORIGINAL (s-coddiv) 00018 */
/* Ic - 20Feb2014 - Se incluye la familia 012 x indicacion de E.Macchiu */
IF s-CodDiv = "00018" AND (Almmmatg.CodFam = "010" OR Almmmatg.CodFam = "012") THEN DO:
     ASSIGN                                           
         x-FlgDtoVol = NO.
END.
/* RHC 19/02/2015 En caso de Fotocopias (011) se amplia el límite a 60 dias */
IF Almmmatg.CodFam = "011" THEN pDiasDctoVol = 60.
IF s-CodMon = 2 AND Almmmatg.CodFam = "011" THEN s-CndVta = "000".   /* Contado */

/* **************************************************************************** */
/* ****************************************************************** */
/* PRECIO DE VENTA Y DESCUENTOS PROMOCIONALES O POR VOLUMEN DE VENTA  */
/* ****************************************************************** */
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

/* ***************************************************************************************** */
/* DESCUENTO ESPECIAL POR EVENTO Y POR DIVISION (SOLO SI NO TIENE DESCUENTO POR VOL O PROMO) */
/* ***************************************************************************************** */
z-Dsctos = 0.
IF y-Dsctos = 0 THEN DO:
    FIND FIRST VtaDtoEsp WHERE Vtadtoesp.codcia = s-codcia
        AND Vtadtoesp.coddiv = pCodDiv
        AND TODAY >= Vtadtoesp.FechaD 
        AND TODAY <= Vtadtoesp.FechaH
        NO-LOCK NO-ERROR.
    FIND gn-convt WHERE gn-ConVt.Codig = s-cndvta NO-LOCK NO-ERROR.
    IF AVAILABLE Vtadtoesp AND AVAILABLE gn-convt THEN DO:
        CASE Almmmatg.CHR__02:
            WHEN "P" THEN DO:       /* PROPIOS */
                IF gn-ConVt.TipVta = "1" THEN z-Dsctos = VtaDtoEsp.DtoPropios[1].   /* CONTADO */
                IF gn-ConVt.TipVta = "2" THEN z-Dsctos = VtaDtoEsp.DtoPropios[2].   /* CREDITO */
            END.
            WHEN "T" THEN DO:       /* TERCEROS */
                IF gn-ConVt.TipVta = "1" THEN z-Dsctos = VtaDtoEsp.DtoTerceros[1].   /* CONTADO */
                IF gn-ConVt.TipVta = "2" THEN z-Dsctos = VtaDtoEsp.DtoTerceros[2].   /* CREDITO */
            END.
        END CASE.
    END.
END.

/* RHC 14/10/2013 *************************************************** */
/* SOLO PARA PROVINCIAS EN TODAS SUS MODALIDADES DE VENTA             */
/* PRECIO ESPECIAL PRODUCTO DE TERCEROS PARA LISTAS ACTIVAS "A" Y "B" */
/* ****************************************************************** */
RUN Descuentos-Promocionales-Especiales.
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
/* ****************************************************************** */


/* ************************************* */
/* RHC 22/07/2013 Parche para Provincias */
/* ************************************* */
/* IF s-TpoPed = "P" THEN DO:                                                                      */
/*     DEF VAR xPrecioFinal AS DEC NO-UNDO.                                                        */
/*     DEF VAR xPrecioBase  AS DEC NO-UNDO.                                                        */
/*     /* Tomamos el mejor precio en caso no sea la familia 010 */                                 */
/*     FIND VtaTabla WHERE VtaTabla.codcia = s-codcia                                              */
/*         AND VtaTabla.tabla = "DCPRPROV"                                                         */
/*         AND VtaTabla.llave_c1 = s-codmat                                                        */
/*         AND VtaTabla.llave_c2 = pCodDiv                                                        */
/*         AND TODAY >= VtaTabla.Rango_Fecha[1]                                                    */
/*         AND TODAY <= VtaTabla.Rango_Fecha[2]                                                    */
/*         NO-LOCK NO-ERROR.                                                                       */
/*     IF AVAILABLE VtaTabla AND Almmmatg.CHR__02 <> "P" THEN DO:                                  */
/*         /* Calculamos el precio final teórico */                                                */
/*         xPrecioFinal = ROUND ( f-PreVta * ( 1 - z-Dsctos / 100 ) * ( 1 - y-Dsctos / 100 ), 2 ). */
/*         /* Comparamos */                                                                        */
/*         xPrecioBase = VtaTabla.Valor[2].                                                        */
/*         FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndStk                                 */
/*             AND Almtconv.Codalter = s-undvta                                                    */
/*             NO-LOCK NO-ERROR.                                                                   */
/*         ASSIGN                                                                                  */
/*             F-FACTOR = Almtconv.Equival.     /* Equivalencia */                                 */
/*         IF S-CODMON = 1 THEN DO:                                                                */
/*             IF Almmmatg.MonVta = 1 THEN ASSIGN xPrecioBase = xPrecioBase * F-FACTOR.            */
/*             ELSE ASSIGN xPrecioBase = xPrecioBase * S-TPOCMB * F-FACTOR.                        */
/*         END.                                                                                    */
/*         IF S-CODMON = 2 THEN DO:                                                                */
/*             IF Almmmatg.MonVta = 2 THEN ASSIGN xPrecioBase = xPrecioBase * F-FACTOR.            */
/*             ELSE ASSIGN xPrecioBase = (xPrecioBase / S-TPOCMB) * F-FACTOR.                      */
/*         END.                                                                                    */
/*         IF xPrecioBase < xPrecioFinal THEN DO:                                                  */
/*             ASSIGN                                                                              */
/*                 y-Dsctos = 0                                                                    */
/*                 z-Dsctos = 0                                                                    */
/*                 f-Dsctos = 0                                                                    */
/*                 f-PreVta = xPrecioBase.                                                         */
/*         END.                                                                                    */
/*     END.                                                                                        */
/* END.                                                                                            */

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Descuentos-Promocionales-Especiales) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Promocionales-Especiales Procedure 
PROCEDURE Descuentos-Promocionales-Especiales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RHC 14/10/2013 *************************************************** */
/* SOLO PARA PROVINCIAS EN TODAS SUS MODALIDADES DE VENTA             */
/* PRECIO ESPECIAL PRODUCTO PROPIOS                                   */
/* PRECIO ESPECIAL PRODUCTO DE TERCEROS PARA LISTAS ACTIVAS "A" Y "B" */
/* ****************************************************************** */
IF s-TpoPed <> "P" THEN RETURN.

CASE TRUE:
    WHEN Almmmatg.CHR__02 = "T"                 /* PRODUCTOS DE TERCEROS */
        AND LOOKUP(s-TipVta, "A,B") > 0         /* LISTAS A y B */
        AND Almmmatg.PromMinDivi[1] = "00018"   /* <<< OJO <<< */
        AND TODAY >= Almmmatg.PromMinFchD[1] 
        AND TODAY <= Almmmatg.PromMinFchH[1]
        THEN DO:
            /* FILTRO DE ERRORES */
            IF s-TipVta = "A" AND Almmmatg.PromMinDto[1] < 0 THEN DO:
                IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'tiene un precio negativo en la lista especial'
                    VIEW-AS ALERT-BOX WARNING.
                RETURN "ADM-ERROR".
            END.
            IF s-TipVta = "B" AND Almmmatg.PromMinDto[2] < 0 THEN DO:
                IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'tiene un precio negativo en la lista especial'
                    VIEW-AS ALERT-BOX WARNING.
                RETURN "ADM-ERROR".
            END.
            /* Determinamos el Precio Base */
            IF s-TipVta = "A" AND Almmmatg.PromMinDto[1] > 0 THEN DO:
                ASSIGN
                    F-DSCTOS = 0                    /* Dcto por ClfCli y/o Cnd Vta */
                    Y-DSCTOS = 0                    /* Dcto por Volumen o Promocional */
                    Z-DSCTOS = 0                    /* Dcto por Evento */
                    X-TIPDTO = ""
                    /*f-PreBas = ROUND( Almmmatg.PreVta[1] * ( 1 - Almmmatg.PromMinDto[1] / 100 ), 4).*/
                    f-PreBas = Almmmatg.PromMinDto[1].
                /* ******************************** */
                /* PRECIO BASE A LA MONEDA DE VENTA */
                /* ******************************** */
                IF S-CODMON = 1 THEN DO:
                    IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                    ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB /** F-FACTOR*/.
                END.
                IF S-CODMON = 2 THEN DO:
                    IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                    ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.
                END.
                F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
                /************************************************/
                RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
                /************************************************/
            END.
            IF s-TipVta = "B" AND Almmmatg.PromMinDto[2] > 0 THEN DO:
                ASSIGN
                    F-DSCTOS = 0                    /* Dcto por ClfCli y/o Cnd Vta */
                    Y-DSCTOS = 0                    /* Dcto por Volumen o Promocional */
                    Z-DSCTOS = 0                    /* Dcto por Evento */
                    X-TIPDTO = ""
                    /*f-PreBas = ROUND( Almmmatg.PreVta[1] * ( 1 - Almmmatg.PromMinDto[2] / 100 ), 4).*/
                    f-PreBas = Almmmatg.PromMinDto[2].
                /* ******************************** */
                /* PRECIO BASE A LA MONEDA DE VENTA */
                /* ******************************** */
                IF S-CODMON = 1 THEN DO:
                    IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                    ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB /** F-FACTOR*/.
                END.
                IF S-CODMON = 2 THEN DO:
                    IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                    ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.
                END.
                F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
                /************************************************/
                RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
                /************************************************/
            END.
        END.
    WHEN Almmmatg.CHR__02 = "P"                 /* PRODUCTOS PROPIOS */
        AND Almmmatg.PromMinDivi[1] = "00018"    /* <<< OJO <<< */
        AND TODAY >= Almmmatg.PromMinFchD[1] 
        AND TODAY <= Almmmatg.PromMinFchH[1]
        THEN DO:
            /* FILTRO DE ERRORES */
            IF Almmmatg.PromMinDto[1] < 0 THEN DO:
                IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'tiene un descuento negativo en la lista especial'
                    VIEW-AS ALERT-BOX WARNING.
                RETURN "ADM-ERROR".
            END.
            /* Determinamos el Precio Base */
            IF Almmmatg.PromMinDto[1] > 0 THEN DO:
                ASSIGN
                    F-DSCTOS = 0                    /* Dcto por ClfCli y/o Cnd Vta */
                    Y-DSCTOS = 0                    /* Dcto por Volumen o Promocional */
                    Z-DSCTOS = 0                    /* Dcto por Evento */
                    X-TIPDTO = ""
                    f-PreBas = ROUND( Almmmatg.PreVta[1] * ( 1 - Almmmatg.PromMinDto[1] / 100 ), 4).
                /* ******************************** */
                /* PRECIO BASE A LA MONEDA DE VENTA */
                /* ******************************** */
                IF S-CODMON = 1 THEN DO:
                    IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                    ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB /** F-FACTOR*/.
                END.
                IF S-CODMON = 2 THEN DO:
                    IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                    ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.
                END.
                F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
                /************************************************/
                RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
                /************************************************/
            END.
        END.
END CASE.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Contrato) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Contrato Procedure 
PROCEDURE Precio-Contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF pCodDiv = "00015" THEN RETURN "ADM-ERROR".  /* NO Expolibreria */

/* RHC 04/10/2013 BLOQUEADO HASTA DEFINIR SU USO */
RETURN "ADM-ERROR".
/* ********************************************* */

DEF BUFFER B-Tabla FOR VtaTabla.

/* Buscamos lista válida para el cliente */
FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
    AND VtaTabla.Tabla = "LPXCCL"
    AND VtaTabla.Llave_c1 = s-CodCli
    AND CAN-FIND(FIRST B-Tabla WHERE B-Tabla.codcia = s-codcia
                 AND B-Tabla.Tabla = "LPXC"
                 AND B-Tabla.Valor[1] = VtaTabla.Valor[1]
                 AND TODAY >= B-Tabla.Rango_Fecha[1]
                 AND TODAY <= B-Tabla.Rango_Fecha[2]
                 NO-LOCK)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN RETURN 'ADM-ERROR'.

/* Buscamos el producto */
FIND VtaListaPrecios WHERE VtaListaPrecios.codcia = s-codcia
    AND VtaListaPrecios.TpoPed = "LPXC"
    AND VtaListaPrecios.NroLista = INTEGER(VtaTabla.Valor[1])
    AND VtaListaPrecios.CodMat = s-CodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaPrecios THEN RETURN 'ADM-ERROR'.

/* ***************************************************************************************** */
/* CAPTURAMOS EL PRECIO TAL COMO ESTA, SOLO VAMOS A TOMAR EN CUENTA EL DESCUENTO PROMOCIONAL */
/* ***************************************************************************************** */
ASSIGN
    s-UndVta = VtaListaPrecios.Chr__01
    s-tpocmb = Almmmatg.TpoCmb.

DEF VAR j AS INT NO-UNDO.

/* DESCUENTO POR CLASIFICACION DEL CLIENTE */
ASSIGN
    MaxCat = 0.
/* DESCUENTO POR CONDICION DE VENTA */    
ASSIGN
    MaxVta = 0.
/* DESCUENTO TOTAL APLICADO */    
F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' VtaListaPrecios.codmat SKIP
        'Unidad de venta:' s-UndVta
        VIEW-AS ALERT-BOX WARNING.
    RETURN "OK".    /* Forzamos terminar el proceso */
END.
ASSIGN
    F-FACTOR = Almtconv.Equival.

/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF Almmmatg.MonVta = 1 
    THEN ASSIGN F-PREBAS = VtaListaPrecios.PreOfi /** f-Factor*/.
    ELSE ASSIGN F-PREBAS = VtaListaPrecios.PreOfi * S-TPOCMB /** f-Factor*/.
END.
IF S-CODMON = 2 THEN DO:
    IF Almmmatg.MonVta = 2 
    THEN ASSIGN F-PREBAS = VtaListaPrecios.PreOfi /** f-Factor*/.
    ELSE ASSIGN F-PREBAS = (VtaListaPrecios.PreOfi / S-TPOCMB) /** f-Factor*/.
END.

/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */

/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
Y-DSCTOS = 0.        
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
IF AVAILABLE gn-convt AND gn-convt.totdias <= 15 THEN DO:
    /************ Descuento Promocional ************/ 
    DO J = 1 TO 10:
        IF VtaListaPrecios.PromDivi[J] = pCodDiv 
            AND TODAY >= VtaListaPrecios.PromFchD[J] 
            AND TODAY <= VtaListaPrecios.PromFchH[J] 
            AND VtaListaPrecios.PromDto[J] > 0
            THEN DO:
            F-DSCTOS = 0.
            F-PREVTA = VtaListaPrecios.PreOfi /** f-Factor*/.
            Y-DSCTOS = VtaListaPrecios.PromDto[J].
            IF Almmmatg.Monvta = 1 THEN 
              ASSIGN X-PREVTA1 = F-PREVTA
                     X-PREVTA2 = ROUND(F-PREVTA / s-TpoCmb,6).
            ELSE
              ASSIGN X-PREVTA2 = F-PREVTA
                     X-PREVTA1 = ROUND(F-PREVTA * s-TpoCmb,6).
            X-PREVTA1 = X-PREVTA1 /** F-FACTOR*/.
            X-PREVTA2 = X-PREVTA2 /** F-FACTOR*/.             
         END.   
    END.
    /* PRECIO FINAL */
    IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
        IF S-CODMON = 1 THEN F-PREVTA = X-PREVTA1.
        ELSE F-PREVTA = X-PREVTA2.     
        IF S-CODMON = 1 THEN F-PREBAS = X-PREVTA1.
        ELSE F-PREBAS = X-PREVTA2.     
    END.    
END.
/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

/* DESCUENTOS ADICIONALES POR DIVISION */
z-Dsctos = 0.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
    IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios de la división' pCodDiv
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
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


/* *******************************

DEF VAR j AS INT NO-UNDO.

FIND FIRST Almmmatp OF Almmmatg NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatp THEN DO:
    IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios de la división' pCodDiv
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

/* DESCUENTO POR CLASIFICACION DEL CLIENTE */
ASSIGN
    MaxCat = 0.
/* DESCUENTO POR CONDICION DE VENTA */    
ASSIGN
    MaxVta = 0.
/* DESCUENTO TOTAL APLICADO */    
F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.

s-UndVta = Almmmatp.Chr__01.

/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatp.codmat SKIP
        'Unidad de venta:' s-UndVta
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival.

/* RHC 12.06.08 tipo de cambio de la familia */
s-tpocmb = Almmmatg.TpoCmb.     /* ¿? */

/* PRECIO BASE  OJO-> EL PRECIO SIMEPRE ESTA EN SOLES */
IF s-CodMon = 1 THEN f-PreBas = Almmmatp.PreOfi.
ELSE f-PreBas = (Almmmatp.PreOfi / S-TPOCMB).

/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */

/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
Y-DSCTOS = 0.        
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
/************ Descuento Promocional ************/ 
DO J = 1 TO 10:
    IF Almmmatp.PromDivi[J] = pCodDiv 
        AND TODAY >= Almmmatp.PromFchD[J] 
        AND TODAY <= Almmmatp.PromFchH[J] 
        AND Almmmatp.PromDto[J] > 0
        THEN DO:
        F-DSCTOS = 0.
        F-PREVTA = Almmmatp.PreOfi /** f-Factor*/.
        Y-DSCTOS = Almmmatp.PromDto[J].
        IF Almmmatp.Monvta = 1 THEN 
          ASSIGN X-PREVTA1 = F-PREVTA
                 X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = F-PREVTA
                 X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
        X-PREVTA1 = X-PREVTA1 /** F-FACTOR*/.
        X-PREVTA2 = X-PREVTA2 /** F-FACTOR*/.             
     END.   
END.
/* PRECIO FINAL */
IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
    IF S-CODMON = 1 THEN F-PREVTA = X-PREVTA1.
    ELSE F-PREVTA = X-PREVTA2.     
    IF S-CODMON = 1 THEN F-PREBAS = X-PREVTA1.
    ELSE F-PREBAS = X-PREVTA2.     
END.    
/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

****************************************** */

/* DESCUENTOS ADICIONALES POR DIVISION */
z-Dsctos = 0.

RETURN "OK".

END PROCEDURE.

/*
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Buscamos lista del cliente */
DEF BUFFER B-TABLA FOR VtaTabla.
FIND FIRST VtaListaPrecios WHERE VtaListaPrecios.codcia = s-codcia
    AND VtaListaPrecios.tpoped = s-tpoped
    AND VtaListaPrecios.codmat = s-codmat
    AND CAN-FIND(FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
                 AND VtaTabla.tabla = 'LPRECIOSC'
                 AND VtaTabla.llave_c1 = s-tpoped
                 AND VtaTabla.llave_c2 = s-codcli
                 AND CAN-FIND(FIRST B-TABLA WHERE B-TABLA.codcia = s-codcia
                              AND B-TABLA.tabla = 'LPRECIOS'
                              AND B-TABLA.llave_c1 = VtaTabla.llave_c1
                              AND B-TABLA.llave_c2 = "A"
                              AND B-TABLA.valor[1] = VtaTabla.valor[1]
                              NO-LOCK)
                 NO-LOCK)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaPrecios THEN DO:
    IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios por CONTRATO MARCO'
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
    

DEF VAR j AS INT NO-UNDO.

/* DESCUENTO POR CLASIFICACION DEL CLIENTE */
ASSIGN
    MaxCat = 0.
/* DESCUENTO POR CONDICION DE VENTA */    
ASSIGN
    MaxVta = 0.
/* DESCUENTO TOTAL APLICADO */    
F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.

s-UndVta = VtaListaPrecios.Chr__01.

/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatp.codmat SKIP
        'Unidad de venta:' s-UndVta
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival.

/* RHC 12.06.08 tipo de cambio de la familia */
s-tpocmb = Almmmatg.TpoCmb.     /* ¿? */

/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF Almmmatg.MonVta = 1 
    THEN ASSIGN F-PREBAS = VtaListaPrecios.PreOfi * f-Factor.
    ELSE ASSIGN F-PREBAS = VtaListaPrecios.PreOfi * S-TPOCMB * f-Factor.
END.
IF S-CODMON = 2 THEN DO:
    IF Almmmatg.MonVta = 2 
    THEN ASSIGN F-PREBAS = VtaListaPrecios.PreOfi * f-Factor.
    ELSE ASSIGN F-PREBAS = (VtaListaPrecios.PreOfi / S-TPOCMB) * f-Factor.
END.

/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */

/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
Y-DSCTOS = 0.        
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
/************ Descuento Promocional ************/ 
DO J = 1 TO 10:
    IF VtaListaPrecios.PromDivi[J] = pCodDiv 
        AND TODAY >= VtaListaPrecios.PromFchD[J] 
        AND TODAY <= VtaListaPrecios.PromFchH[J] 
        AND VtaListaPrecios.PromDto[J] > 0
        THEN DO:
        F-DSCTOS = 0.
        F-PREVTA = VtaListaPrecios.PreOfi * f-Factor.
        Y-DSCTOS = VtaListaPrecios.PromDto[J].
        IF Almmmatg.Monvta = 1 THEN 
          ASSIGN X-PREVTA1 = F-PREVTA
                 X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = F-PREVTA
                 X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
        X-PREVTA1 = X-PREVTA1 * F-FACTOR.
        X-PREVTA2 = X-PREVTA2 * F-FACTOR.             
     END.   
END.
/* PRECIO FINAL */
IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
    IF S-CODMON = 1 THEN F-PREVTA = X-PREVTA1.
    ELSE F-PREVTA = X-PREVTA2.     
    IF S-CODMON = 1 THEN F-PREBAS = X-PREVTA1.
    ELSE F-PREBAS = X-PREVTA2.     
END.    
/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

/* DESCUENTOS ADICIONALES POR DIVISION */
z-Dsctos = 0.

RETURN "OK".

END PROCEDURE.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Division) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Division Procedure 
PROCEDURE Precio-Division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* PRECIO BASE Y UNIDAD DE VENTA */
FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.CodDiv = pCodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaMay THEN DO:
    IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios de la división' pCodDiv
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
ASSIGN
    F-PreBas = VtaListaMay.PreOfi
    s-UndVta = VtaListaMay.Chr__01.
/*MESSAGE 'unidad' s-undvta.*/

{vta2/PrecioListaxMayorCredito.i &Tabla=VtaListaMay ~
    &PreVta=VtaListaMay.PreOfi ~
    &Promocional="~
    IF TODAY >= VtaListaMay.PromFchD AND TODAY <= VtaListaMay.PromFchH THEN DO:
        ASSIGN
            x-DctoPromocional = VtaListaMay.PromDto.
END."}

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

/* PRECIO BASE Y UNIDAD DE VENTA */
ASSIGN
    F-PreBas = Almmmatg.PreOfi.
    s-UndVta = Almmmatg.Chr__01.

/* PROCEDIMIENTO NORMAL */
FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
    AND VtaTabla.tabla = "DTOPROLIMA"
    AND VtaTabla.llave_c1 = s-codmat
    AND VtaTabla.llave_c2 = pCodDiv
    AND TODAY >= VtaTabla.Rango_Fecha[1]
    AND TODAY <= VtaTabla.Rango_Fecha[2]
    NO-LOCK NO-ERROR.
/* RHC 04/09/2015 PARCHE */
IF s-CodDiv = '00024' AND Almmmatg.CodMat = '060282' THEN pDiasDctoPro = 60.
/* ********************* */
{vta2/PrecioListaxMayorCredito.i &Tabla=Almmmatg ~
    &PreVta=Almmmatg.PreVta[1] ~
    &Promocional="~
    IF AVAILABLE VtaTabla THEN x-DctoPromocional = VtaTabla.Valor[1]."}

/* ************************************************ */
/* RHC 19/11/2013 INCREMENTO POR DIVISION Y FAMILIA */
/* ************************************************ */
/* RHC 07/05/2020 NO va */
/* FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia               */
/*     AND VtaTabla.Llave_c1 = pCodDiv                          */
/*     AND VtaTabla.Llave_c2 = Almmmatg.codfam                  */
/*     AND VtaTabla.Llave_c3 = Almmmatg.subfam                  */
/*     AND VtaTabla.Tabla = "DIVFACXSLIN"                       */
/*     NO-LOCK NO-ERROR.                                        */
/* IF AVAILABLE VtaTabla AND VtaTabla.Valor[1] > 0 THEN DO:     */
/*     f-PreVta = f-Prevta * (1 + VtaTabla.Valor[1] / 100).     */
/*     f-PreBas = f-PreBas * (1 + VtaTabla.Valor[1] / 100).     */
/* END.                                                         */
/* ELSE DO:                                                     */
/*     FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia           */
/*         AND VtaTabla.Llave_c1 = pCodDiv                      */
/*         AND VtaTabla.Llave_c2 = Almmmatg.codfam              */
/*         AND VtaTabla.Tabla = "DIVFACXLIN"                    */
/*         NO-LOCK NO-ERROR.                                    */
/*     IF AVAILABLE VtaTabla AND VtaTabla.Valor[1] > 0 THEN DO: */
/*         f-PreVta = f-Prevta * (1 + VtaTabla.Valor[1] / 100). */
/*         f-PreBas = f-PreBas * (1 + VtaTabla.Valor[1] / 100). */
/*     END.                                                     */
/* END.                                                         */
/* ************************************************ */

/* RHC 15/02/2015 Incremento especial por papel fotocopia */
/* IF GN-DIVI.CanalVenta = "TDA" AND s-codmon = 1 AND Almmmatg.codfam = '011' THEN DO: */
/*     CASE TRUE:                                                                      */
/*         WHEN gn-ConVt.TotDias > 15 AND gn-ConVt.TotDias <= 30 THEN                  */
/*             ASSIGN                                                                  */
/*             f-PreVta = f-Prevta * (1 + 1 / 100)                                     */
/*             f-PreBas = f-PreBas * (1 + 1 / 100).                                    */
/*         WHEN gn-ConVt.TotDias > 30 AND gn-ConVt.TotDias <= 45 THEN                  */
/*             ASSIGN                                                                  */
/*             f-PreVta = f-Prevta * (1 + 2.5 / 100)                                   */
/*             f-PreBas = f-PreBas * (1 + 2.5 / 100).                                  */
/*     END CASE.                                                                       */
/* END.                                                                                */
/* ****************************************************** */
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
/* ****************************************************** */


/* RHC 05/03/2014 PRECIO FINAL POR VOLUMEN SOLO PARA LA DIVISION 00060, 00061 Y 00062 */
/* FIND VtaTabla WHERE VtaTabla.codcia = s-codcia                                                                             */
/*     AND VtaTabla.Tabla = "DCTOVOLARE"                                                                                      */
/*     AND VtaTabla.Llave_c1 = Almmmatg.codmat                                                                                */
/*     NO-LOCK NO-ERROR.                                                                                                      */
/* IF pCodDiv = "00060" AND TODAY <= 03/31/2014 AND AVAILABLE VtaTabla THEN DO:                                              */
/*     /* FACTOR DE EQUIVALENCIA (OJO: La s-UndVta ya debe tener un valor cargado) */                                         */
/*     FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas                                                                */
/*         AND Almtconv.Codalter = s-undvta                                                                                   */
/*         NO-LOCK NO-ERROR.                                                                                                  */
/*     IF NOT AVAILABLE Almtconv THEN DO:                                                                                     */
/*         IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP */
/*             '   Unidad Stock:' Almmmatg.UndStk SKIP                                                                        */
/*             'Unidad de Venta:' s-UndVta                                                                                    */
/*             VIEW-AS ALERT-BOX ERROR.                                                                                       */
/*         RETURN "ADM-ERROR".                                                                                                */
/*     END.                                                                                                                   */
/*     /* VALORES POR DEFECTO */                                                                                              */
/*     ASSIGN                                                                                                                 */
/*         F-FACTOR = Almtconv.Equival     /* Equivalencia */                                                                 */
/*         s-tpocmb = Almmmatg.TpoCmb.     /* ¿? */                                                                           */
/*     /*************** Descuento por Volumen ****************/                                                               */
/*     DEF VAR x-PrecioFinal AS DEC NO-UNDO.                                                                                  */
/*     ASSIGN                                                                                                                 */
/*         X-RANGO = 0                                                                                                        */
/*         X-CANTI = X-CANPED * F-FACTOR                                                                                      */
/*         x-PrecioFinal = 0.                                                                                                 */
/*     DO J = 1 TO 10:                                                                                                        */
/*         IF X-CANTI >= VtaTabla.Valor[J] AND VtaTabla.Valor[J + 10] > 0  THEN DO:                                           */
/*             IF X-RANGO  = 0 THEN X-RANGO = VtaTabla.Valor[J].                                                              */
/*             IF X-RANGO <= VtaTabla.Valor[J] THEN DO:                                                                       */
/*                 ASSIGN                                                                                                     */
/*                     X-RANGO  = VtaTabla.Valor[J]                                                                           */
/*                     x-PrecioFinal = VtaTabla.Valor[J + 10].                                                                */
/*             END.                                                                                                           */
/*         END.                                                                                                               */
/*     END.                                                                                                                   */
/*     IF x-PrecioFinal > 0 THEN DO:   /* SIEMPRE EN SOLES */                                                                 */
/*         F-PREBAS = Almmmatg.PreVta[1].    /* OJO => Se cambia Precio Base */                                               */
/*         /* RHC 19/11/2013 INCREMENTO POR DIVISION Y FAMILIA */                                                             */
/*         FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia                                                                     */
/*             AND VtaTabla.Llave_c1 = pCodDiv                                                                               */
/*             AND VtaTabla.Llave_c2 = Almmmatg.codfam                                                                        */
/*             AND VtaTabla.Tabla = "DIVFACXLIN"                                                                              */
/*             NO-LOCK NO-ERROR.                                                                                              */
/*         IF AVAILABLE VtaTabla THEN f-PreBas = f-PreBas * (1 + VtaTabla.Valor[1] / 100).                                    */
/*         /* ******************************** */                                                                             */
/*         /* PRECIO BASE A LA MONEDA DE VENTA */                                                                             */
/*         /* ******************************** */                                                                             */
/*         IF S-CODMON = 1 THEN DO:                                                                                           */
/*             IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS.                                                        */
/*             ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB.                                                                    */
/*         END.                                                                                                               */
/*         IF S-CODMON = 2 THEN DO:                                                                                           */
/*             IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS.                                                        */
/*             ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB).                                                                  */
/*         END.                                                                                                               */
/*         ASSIGN                                                                                                             */
/*             F-PREVTA = F-PREBAS                                                                                            */
/*             Y-DSCTOS = ROUND(( 1 - (x-PrecioFinal / f-PreBas) ) * 100 , 4).                                                */
/*             X-TIPDTO = "VOL".                                                                                              */
/*     END.                                                                                                                   */
/* END.                                                                                                                       */

RETURN "OK".

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
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

