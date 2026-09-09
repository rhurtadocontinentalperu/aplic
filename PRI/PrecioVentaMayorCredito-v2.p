&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER x-VtaTabla FOR VtaTabla.



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
DEF INPUT PARAMETER s-TpoPed AS CHAR.   /* Tipo de Pedido */
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* Lista de Precios */
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT-OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.       /* Default 1 */
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-CNDVTA AS CHAR.       /* Condicion de venta */     
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF OUTPUT PARAMETER F-PREBAS AS DEC DECIMALS 4.
DEF OUTPUT PARAMETER F-PREVTA AS DEC DECIMALS 4.    /* Precio - Dscto CondVta - ClasfCliente */
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.       /* Descuento incluido en el precio unitario base */
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.       /* Descuento por Volumen y/o Promocional */
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.       /* Descuento por evento */
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.      /* Tipo de descuento aplicado (PROM, VOL) */ 
/* Se anula este parámetro por compatibilidad  */
DEF INPUT PARAMETER pClfCli AS CHAR.        /* Solo si tiene un valor me sirve */
/* */
DEF OUTPUT PARAMETER f-FleteUnitario AS DEC.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.  /* Mensaje de Error */

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

/* ************************************************************************************ */
/* CATALOGO DEL PRODUCTO */
/* ************************************************************************************ */
FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia 
    AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    pMensaje = 'Producto ' + s-CodMat + ' NO registrado en el catálogo general de productos' + CHR(10) +
        'Comunicarse con gestor del maestro del catálogo de productos'.
    RETURN "ADM-ERROR".
END.
/* ************************************************************************************ */
/* Verifica cuál es el tipo de cambio a usar */
/* ************************************************************************************ */
DEF VAR x-TpoCmbCompra AS DECI NO-UNDO.
DEF VAR x-TpoCmbVenta AS DECI NO-UNDO.

/* Valores por defecto */
ASSIGN
    x-TpoCmbCompra = Almmmatg.TpoCmb
    x-TpoCmbVenta  = Almmmatg.TpoCmb.

FIND FacTabla WHERE FacTabla.CodCia = s-CodCia 
    AND FacTabla.Tabla = 'GN-DIVI' 
    AND FacTabla.Codigo = pCodDiv
    NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla AND FacTabla.Campo-L[5] = YES THEN DO:
    /* TIPO DE CAMBIO COMERCIAL */
    FIND LAST Gn-tccom WHERE Gn-tccom.fecha <= TODAY NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = 'NO registrado el tipo de cambio comercial' + CHR(10) +
            'Comunicarse con el gestor financiero'.
        RETURN "ADM-ERROR".
    END.
    ASSIGN
        x-TpoCmbCompra = Gn-tccom.compra
        x-TpoCmbVenta  = Gn-tccom.venta.
END.
/* ************************************************************************************ */
/* VARIABLES LOCALES */
/* ************************************************************************************ */
DEF VAR S-TPOCMB AS DEC NO-UNDO.
DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR x-ClfCli  AS CHAR INIT "C" NO-UNDO.      /* Clasificacion para productos propios */
DEF VAR x-ClfCli2 AS CHAR INIT "C" NO-UNDO.      /* Clasificacion para productos de terceros */
DEF VAR X-PREVTA1 AS DECI NO-UNDO.
DEF VAR X-PREVTA2 AS DECI NO-UNDO.
/* ************************************************************************************ */
/* VARIABLES DESCUENTOS CALCULADOS */
/* ************************************************************************************ */
DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR x-DctoxVolumen    AS DECIMAL DECIMALS 4 NO-UNDO.
/* ************************************************************************************ */
/* CONTROL POR DIVISION */
/* ************************************************************************************ */
DEF VAR x-FlgDtoVol     LIKE GN-DIVI.FlgDtoVol NO-UNDO.
DEF VAR x-FlgDtoProm    LIKE GN-DIVI.FlgDtoProm NO-UNDO.
DEF VAR x-FlgDtoClfCli  LIKE GN-DIVI.FlgDtoClfCli NO-UNDO.
DEF VAR x-FlgDtoCndVta  LIKE GN-DIVI.FlgDtoCndVta NO-UNDO.
DEF VAR x-TpoDcto       AS CHAR NO-UNDO.     /* E: excluyente, A: acumulativo */
DEF VAR x-Ajuste-por-flete AS LOG NO-UNDO.
DEF VAR x-Precio-Mostrador AS LOG NO-UNDO.
/* ************************************************************************************ */
/* CONFIGURACIONES DE LA DIVISION */
/* ************************************************************************************ */
/* OJO: Configuración de la LISTA DE PRECIOS */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMensaje = "División/Lista de Precios " + pCodDiv + " NO definida" + CHR(10) +
        'Comunicarse con gestor del maestro de divisiones/listas de precios'.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    x-FlgDtoVol     = GN-DIVI.FlgDtoVol                 /* Descuento por Volumen */
    x-FlgDtoProm    = GN-DIVI.FlgDtoProm                /* Descuento Promocional */
    x-FlgDtoClfCli  = GN-DIVI.FlgDtoClfCli              /* Descuento por Clasificacion */
    x-FlgDtoCndVta  = GN-DIVI.FlgDtoCndVta              /* Descuento por venta */
    x-TpoDcto       = GN-DIVI.Libre_C01                 /* Tipo de descuento */
    x-Ajuste-por-flete = GN-DIVI.Campo-Log[4]           /* Factor de Ajuste por Flete */
    x-Precio-Mostrador = NO.
IF TRUE <> (x-TpoDcto > '') THEN x-TpoDcto = "E".       /* Excluyentes */
/* ************************************************************************************ */
/* CLIENTE */
/* ************************************************************************************ */
IF s-CodCli > '' THEN DO:
    FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
        AND gn-clie.CodCli = S-CODCLI 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        pMensaje = 'Cliente ' + s-codcli + ' NO registrado' + CHR(10) +
            'Comunicarse con gestor del maestro de clientes'.
        RETURN 'ADM-ERROR'.
    END.
END.
/* ************************************************************************************ */
DEF VAR pDiasDctoVol AS INT NO-UNDO.    /* Tope Para % Descuento por Volumen (hasta 60 dias ) */
DEF VAR pDiasDctoPro AS INT NO-UNDO.    /* Tope Para % Descuento Promocional (hasta 60 dias ) */

FIND FIRST VtaCTabla WHERE VtaCTabla.CodCia = s-CodCia 
    AND VtaCTabla.Tabla = 'CFGLPMAYCR' 
    AND VtaCTabla.Llave = pCodDiv NO-LOCK NO-ERROR.
IF AVAILABLE VtaCTabla THEN DO:
    ASSIGN
        pDiasDctoPro = VtaCTabla.Libre_d01 
        pDiasDctoVol = VtaCTabla.Libre_d02.
END.

/* Ic - 23 Ene2020, clasificacion de Cliente por Linea de producto */
DEFINE VAR x-tabla-clsfclie-x-linea AS CHAR.

x-tabla-clsfclie-x-linea = "CLSF_CLIE_X_LINEA".

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
      TABLE: x-VtaTabla B "?" ? INTEGRAL VtaTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.58
         WIDTH              = 60.
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
    F-Factor = 1                    /* Valor por Defecto */
    F-PreVta = Almmmatg.PreOfi.     /* Valor por Defecto */
    F-PreBas = Almmmatg.PreOfi.     /* Valor por Defecto */
/* *************************************************************************** */
/* CLASIFICACION DEL CLIENTE */
/* *************************************************************************** */
FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
    AND gn-clie.CodCli = S-CODCLI 
    NO-LOCK NO-ERROR.
ASSIGN
    x-ClfCli  = "C"         /* Valores por defecto */
    x-ClfCli2 = "C".
IF s-codcli > '' AND AVAILABLE gn-clie THEN DO:
    IF gn-clie.clfcli  > '' THEN x-ClfCli  = gn-clie.clfcli.
    IF gn-clie.clfcli2 > '' THEN x-ClfCli2 = gn-clie.clfcli2.
END.
/* *************************************************************************** */
/* Ic - 23Ene2020, Clasificación de Cliente por Línea de Producto */
/* La carga del maestro se encuentra en vta2/w-clasificacion-cliente-linea-prod.w */
/* *************************************************************************** */
FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
    x-vtatabla.tabla = x-tabla-clsfclie-x-linea AND
    x-vtatabla.llave_c1 = S-CODCLI AND
    x-vtatabla.llave_c2 = almmmatg.codfam NO-LOCK NO-ERROR.
IF AVAILABLE x-vtatabla THEN DO:
    x-ClfCli  = TRIM(x-vtatabla.libre_c01).
    x-ClfCli2 = TRIM(x-vtatabla.libre_c02).
END.
/* Si viene la clasificación como parámetro => se asigna dicha clasificación */
IF pClfCli > '' THEN 
    ASSIGN 
        x-ClfCli = pClfCli 
        x-ClfCli2 = pClfCli.
/* *************************************************************************** */
/* PRECIOS ESPECIALES POR CONTRATO MARCO Y REMATES */
/* *************************************************************************** */
CASE s-TpoPed:
    WHEN "M" THEN DO:       /* CASO ESPECIAL -> Ventas CONTRATO MARCO */
        RUN Precio-Contrato-Marco.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
        IF RETURN-VALUE = "OK" THEN RETURN 'OK'.
        /* SI DEVUELVE ADM-OK buscamos precio de acuerdo a la división activa */
        IF RETURN-VALUE = "ADM-OK" THEN DO:
            RUN Precio-Normal.
            IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
        END.
    END.
    WHEN "R" THEN DO:       /* CASO ESPECIAL -> REMATES */
        RUN Precio-Remate.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
    OTHERWISE DO:
        RUN Precio-Normal.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
END CASE.
/* ***************************************************************************************** */
/* ***************************************************************************************** */
/* OJO: Control de Precio Base */
/* ***************************************************************************************** */
/* ***************************************************************************************** */
F-PREBAS = F-PREVTA.
/* ***************************************************************************************** */
/* ***************************************************************************************** */

RETURN 'OK'.

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

/* RHC 26/03/2015 DESCUENTO PROMOCIONAL Y VOLUMEN */
FIND FIRST Almmmatp OF Almmmatg NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatp THEN DO:
    /* Va a tomar el precio de la lista mayorista crédito */
    RETURN 'ADM-OK'.
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
    x-TpoDcto = "E"    /* EXCLUYENTES */
    .

{pri/PrecioVentaMayorCredito-v2.i &Tabla=Almmmatp ~
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

&IF DEFINED(EXCLUDE-Precio-Division) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Division Procedure 
PROCEDURE Precio-Division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* *************************************************************************** */
/* PRECIO BASE Y UNIDAD DE VENTA */
/* *************************************************************************** */
FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.CodDiv = pCodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaMay THEN DO:
    pMensaje = 'Producto ' + Almmmatg.CodMat + ' NO definido en la lista de precios: ' + pCodDiv.
    RETURN "ADM-ERROR".
END.
/* *************************************************************************** */
/* Valores por Defecto: De la Lista de Precios por División */
/* *************************************************************************** */
IF VtaListaMay.CHR__01 > '' THEN ASSIGN s-UndVta = VtaListaMay.Chr__01.
IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndBas.
IF TRUE <> (s-UndVta > '') THEN DO:
    pMensaje = 'Producto ' + Almmmatg.CodMat + ' NO definido la unidad de venta en la lista: ' + pCodDiv.
    RETURN "ADM-ERROR".
END.
ASSIGN 
    f-Factor = 1
    F-PreBas = VtaListaMay.PreOfi.       /* Precio Lista Por Defecto */
/* *************************************************************************** */
/* Revisemos el factor de conversión */
/* *************************************************************************** */
IF Almmmatg.UndBas <> s-UndVta THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND Almtconv.Codalter = s-UndVta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
            'Unidad de venta: ' + s-UndVta.
        RETURN "ADM-ERROR".
  END.
  f-Factor = Almtconv.Equival.
END.
/* ****************************************************************************************** */
/* Verificar que el producto es SIN DESCUENTO */
/* ****************************************************************************************** */
CASE VtaListaMay.FlagDesctos:
    WHEN 1 THEN                     /* SIN DESCUENTOS */
        ASSIGN
            x-FlgDtoClfCli = NO
            x-FlgDtoCndVta = NO.
END CASE.
/* ****************************************************************************************** */
/* Rutima única */
/* ****************************************************************************************** */
{pri/PrecioVentaMayorCredito-v2.i ~
    &Tabla=VtaListaMay ~
    &PreVta=VtaListaMay.PreOfi ~
    &Promocional="~
    /* Tomamos el mejor descuento */ ~
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

&IF DEFINED(EXCLUDE-Precio-Empresa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Empresa Procedure 
PROCEDURE Precio-Empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* *************************************************************************** */
/* PRECIO BASE Y UNIDAD DE VENTA */
/* *************************************************************************** */
ASSIGN 
    f-Factor = 1
    s-UndVta = Almmmatg.CHR__01
    F-PreBas = Almmmatg.PreOfi.       /* Precio Lista Por Defecto */
IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndBas.
IF TRUE <> (s-UndVta > '') THEN DO:
    pMensaje = 'Producto ' + Almmmatg.CodMat + ' NO definida la unidad de venta'.
    RETURN "ADM-ERROR".
END.
/* *************************************************************************** */
/* Revisemos el factor de conversión */
/* *************************************************************************** */
IF Almmmatg.UndBas <> s-UndVta THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND Almtconv.Codalter = s-UndVta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
            'Unidad de venta: ' + s-UndVta.
        RETURN "ADM-ERROR".
  END.
  f-Factor = Almtconv.Equival.
END.
/* ****************************************************************************************** */
/* Rutina única */
/* ****************************************************************************************** */
{pri/PrecioVentaMayorCredito-v2.i ~
    &Tabla=Almmmatg ~
    &PreVta=Almmmatg.PreVta[1] ~
    &Promocional="~
    /* Tomamos el mejor descuento */ ~
    DEF VAR x-Old-Descuento AS DEC NO-UNDO. ~
    x-Old-Descuento = 0. ~
    FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND ~
        VtaDctoProm.CodDiv = pCodDiv AND ~
        VtaDctoProm.CodMat = Almmmatg.CodMat AND ~
        VtaDctoProm.FlgEst = 'A' AND ~
        (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin): ~
        x-DctoPromocional = VtaDctoProm.Descuento. ~
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

&IF DEFINED(EXCLUDE-Precio-Normal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Normal Procedure 
PROCEDURE Precio-Normal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ****************************************************************************************** */
/* CONFIGURACION DE PRECIOS EVENTO: CFGLMAYCR */
/* Si no ubica una configuración, toma por defecto la de la división */
/* ****************************************************************************************** */
FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-CodCia AND
    VtaDTabla.Tabla = 'CFGLPMAYCR' AND
    VtaDTabla.Llave = pCodDiv AND
    VtaDTabla.Tipo = "L" AND
    VtaDTabla.LlaveDetalle = Almmmatg.CodFam,
    FIRST VtaCTabla OF VtaDTabla NO-LOCK:
    IF Almmmatg.SubFam = VtaDTabla.Libre_c02 THEN NEXT.     /* Subfamilia (-) */
    IF VtaDTabla.Libre_c01 > '' AND Almmmatg.SubFam <> VtaDTabla.Libre_c01 THEN NEXT. /* Subfamilia (+) */
    /* CALCULO DE PRECIO Y DESCUENTO POR PRODUCTO */
    x-FlgDtoCndVta = VtaDTabla.Libre_l01.
    x-FlgDtoClfCli = VtaDTabla.Libre_l02.
    x-FlgDtoVol    = VtaDTabla.Libre_l03.
    x-FlgDtoProm   = VtaDTabla.Libre_l04.
    x-TpoDcto      = VtaDTabla.Libre_c05.   /* "E" Excluyentes, "A" acumulados */
    x-Precio-Mostrador = VtaDTabla.Libre_l05.
    LEAVE.
END.

FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-CodCia AND
    VtaDTabla.Tabla = 'CFGLPMAYCR' AND
    VtaDTabla.Llave = pCodDiv AND
    VtaDTabla.Tipo = "A" AND
    VtaDTabla.LlaveDetalle = Almmmatg.CodMat,
    FIRST VtaCTabla OF VtaDTabla NO-LOCK:
    /* CALCULO DE PRECIO Y DESCUENTO POR PRODUCTO */
    x-FlgDtoCndVta = VtaDTabla.Libre_l01.
    x-FlgDtoClfCli = VtaDTabla.Libre_l02.
    x-FlgDtoVol    = VtaDTabla.Libre_l03.
    x-FlgDtoProm   = VtaDTabla.Libre_l04.
    x-TpoDcto      = VtaDTabla.Libre_c05.   /* "E" Excluyentes, "A" acumulados */
    x-Precio-Mostrador = VtaDTabla.Libre_l05.
    LEAVE.
END.
IF TRUE <> (x-TpoDcto > '') THEN x-TpoDcto = "E".

IF x-Precio-Mostrador = YES THEN
    ASSIGN
        x-ClfCli = "C"
        x-ClfCli2 = "C".
/* ****************************************************************************************** */
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
/* ***************************************************************************************** */
/* DESCUENTO ESPECIAL POR EVENTO Y POR DIVISION (SOLO SI NO TIENE DESCUENTO POR VOL O PROMO) */
/* ***************************************************************************************** */
ASSIGN z-Dsctos = 0.
IF y-Dsctos = 0 THEN DO:
    FIND FIRST VtaDtoEsp WHERE Vtadtoesp.codcia = s-codcia
        AND Vtadtoesp.coddiv = pCodDiv
        AND TODAY >= Vtadtoesp.FechaD 
        AND TODAY <= Vtadtoesp.FechaH
        NO-LOCK NO-ERROR.
    FIND FIRST gn-convt WHERE gn-ConVt.Codig = s-cndvta NO-LOCK NO-ERROR.
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
RUN gn/factor-porcentual-flete-v2.p (INPUT pcoddiv, 
                                     INPUT s-CodMat,
                                     INPUT-OUTPUT f-FleteUnitario, 
                                     INPUT s-TpoPed, 
                                     INPUT f-factor, 
                                     INPUT s-CodMon).
/* *************************************************************************** */
/* OJO: Control de Precio Base */
F-PREBAS = F-PREVTA.

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
    pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
        '   Unidad Stock: ' + Almmmatg.UndBas + CHR(10) +
        'Unidad de Venta: ' + s-UndVta.
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival.

FIND VtaTabla WHERE Vtatabla.codcia = s-codcia
    AND Vtatabla.tabla = 'REMATES'
    AND Vtatabla.llave_c1 = s-codmat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    pMensaje = "Producto en REMATE NO tiene precio de venta".
    RETURN "ADM-ERROR".
END.
F-PREBAS = VtaTabla.Valor[1].
CASE TRUE:
    WHEN s-CodMon = 1 AND Almmmatg.MonVta = 2 THEN F-PREBAS = VtaTabla.Valor[1] * x-TpoCmbVenta.
    WHEN s-CodMon = 2 AND Almmmatg.MonVta = 1 THEN F-PREBAS = VtaTabla.Valor[1] / x-TpoCmbCompra.
END CASE.
/* IF s-CodMon = Almmmatg.MonVta THEN F-PREBAS = VtaTabla.Valor[1].                       */
/* ELSE IF s-CodMon = 1 THEN F-PREBAS = ROUND ( VtaTabla.Valor[1] * Almmmatg.TpoCmb, 6 ). */
/* ELSE F-PREBAS = ROUND ( VtaTabla.Valor[1] / Almmmatg.TpoCmb, 6 ).                      */
ASSIGN 
    F-PREVTA = F-PREBAS.
RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

