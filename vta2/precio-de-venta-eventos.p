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
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* Lista de Precios */
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
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.      /* Tipo de descuento aplicado (PROM, VOL) */ 
DEF INPUT PARAMETER pClfCli AS CHAR.        /* SOlo si tiene un valor me sirve */
DEF OUTPUT PARAMETER f-FleteUnitario AS DEC.
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

/* OJO: Configuración de la LISTA DE PRECIOS */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK.
IF GN-DIVI.VentaMayorista <> 2 OR GN-DIVI.CanalVenta <> "FER" THEN DO:
    RETURN 'ADM-ERROR'.
END.
/* IF s-TpoPed <> "E" OR GN-DIVI.VentaMayorista <> 2 OR GN-DIVI.CanalVenta <> "FER" THEN DO: */
/*     RETURN 'ADM-ERROR'.                                                                   */
/* END.                                                                                      */

/* VARIABLES LOCALES */
DEF VAR S-TPOCMB AS DEC NO-UNDO.
DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR x-ClfCli  AS CHAR NO-UNDO.      /* Clasificacion para productos propios */
DEF VAR x-ClfCli2 AS CHAR NO-UNDO.      /* Clasificacion para productos de terceros */
DEF VAR X-PREVTA1 AS DECI NO-UNDO.
DEF VAR X-PREVTA2 AS DECI NO-UNDO.

/* VARIABLES DESCUENTOS CALCULADOS */
DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR x-DctoxVolumen    AS DECIMAL DECIMALS 4 NO-UNDO.

/* CONTROL POR DIVISION */
DEF VAR x-FlgDtoVol LIKE GN-DIVI.FlgDtoVol NO-UNDO.
DEF VAR x-FlgDtoProm LIKE GN-DIVI.FlgDtoProm NO-UNDO.
DEF VAR x-FlgDtoClfCli LIKE GN-DIVI.FlgDtoClfCli NO-UNDO.
DEF VAR x-FlgDtoCndVta LIKE GN-DIVI.FlgDtoCndVta NO-UNDO.
DEF VAR x-Libre_C01 LIKE GN-DIVI.Libre_C01 NO-UNDO.     /* Dcto Exluyenbres, acumulados o el mejor */
DEF VAR x-Ajuste-por-flete AS LOG NO-UNDO.

/* CONFIGURACIONES DE LA DIVISION */
ASSIGN
    x-FlgDtoVol = GN-DIVI.FlgDtoVol             /* Descuento por Volumen */
    x-FlgDtoProm = GN-DIVI.FlgDtoProm           /* Descuento Promocional */
    x-FlgDtoClfCli = GN-DIVI.FlgDtoClfCli       /* Descuento por Clasificacion */
    x-FlgDtoCndVta = GN-DIVI.FlgDtoCndVta       /* Descuento por venta */
    x-Libre_C01 = GN-DIVI.Libre_C01             /* Tipo de descuento */
    x-Ajuste-por-flete = GN-DIVI.Campo-Log[4].  /* Factor de Ajuste por Flete */

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
         HEIGHT             = 4.08
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
    F-PreBas = Almmmatg.PreOfi.     /* Valor por Defecto */
/* ************************* */
/* CLASIFICACION DEL CLIENTE */
/* ************************* */
ASSIGN
    x-ClfCli  = "C"         /* Valores por defecto */
    x-ClfCli2 = "C".
IF AVAIL gn-clie AND gn-clie.clfcli <> ''  THEN x-ClfCli  = gn-clie.clfcli.
IF AVAIL gn-clie AND gn-clie.clfcli2 <> '' THEN x-ClfCli2 = gn-clie.clfcli2.
IF pClfCli > '' THEN ASSIGN x-ClfCli = pClfCli x-ClfCli2 = pClfCli.

/* PRECIO BASE Y UNIDAD DE VENTA */
FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.CodDiv = pCodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaMay THEN DO:
    IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios:' pCodDiv
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
/* Valores por Defecto: De la Lista de Precios por División */
IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = VtaListaMay.Chr__01.
ASSIGN 
    f-Factor = 1
    F-PreBas = VtaListaMay.PreOfi.       /* Precio Lista Por Defecto */
/* Revisemos el factor de conversión */
IF Almmmatg.UndBas <> s-UndVta THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND 
        Almtconv.Codalter = s-UndVta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat
            'Unidad de venta:' s-UndVta VIEW-AS ALERT-BOX WARNING.
        RETURN "ADM-ERROR".
  END.
  f-Factor = Almtconv.Equival.
END.

/* CONFIGURACION DE PRECIOS EVENTO */
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
    x-Libre_C01    = VtaDTabla.Libre_c02.   /* "" Excluyentes, "A" acumulados */
    LEAVE.
END.
/* ****************************************** */
/* Verificar que el producto es SIN DESCUENTO */
/* ****************************************** */
CASE VtaListaMay.FlagDesctos:
    WHEN 1 THEN                     /* SIN DESCUENTOS */
        ASSIGN
            x-FlgDtoClfCli = NO
            x-FlgDtoCndVta = NO.
END CASE.
/* ********************************************** */
{vta2/PrecioListaxMayorCredito.i &Tabla=VtaListaMay ~
    &PreVta=VtaListaMay.PreOfi ~
    &Promocional="~
    IF (TODAY >= VtaListaMay.PromFchD AND TODAY <= VtaListaMay.PromFchH) ~
    THEN DO: ~
        CASE gn-clie.LocCli: ~
            WHEN 'VIP' THEN x-DctoPromocional = VtaListaMay.Libre_d01. ~
            WHEN 'MR' THEN x-DctoPromocional = VtaListaMay.Libre_d02. ~
            OTHERWISE x-DctoPromocional = VtaListaMay.Libre_d03. ~
        END CASE. ~
    END. ~
    " }

/* ****************************** */
/* Determinamos el Flete Unitario */
RUN gn/flete-unitario.p (s-CodMat,
                         pCodDiv,
                         S-CODMON,
                         f-Factor,
                         OUTPUT f-FleteUnitario).

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


