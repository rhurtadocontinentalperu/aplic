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

DEFINE TEMP-TABLE pTable LIKE w-report.

/* Librerias

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.

RUN <libreria>.rutina_interna IN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-excel:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

*/

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
         HEIGHT             = 5.42
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-web_api-captura-lineas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-captura-lineas Procedure 
PROCEDURE web_api-captura-lineas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Sintaxis 
http://192.168.100.221:62/api/Sales/Record/Line/sha256$5uqVbpQ6dWv0z2Tw$8cfcfcd13571eba4873e06dd6dd25674503c498657f7da6969aae41a0249c64a?&Code=010
&Code=010 es opcional, si no se indica devuelve todas las líneas
*/

DEF INPUT PARAMETER pCodFam AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VAR hDoc AS HANDLE NO-UNDO.
DEFINE VAR x-Url AS CHAR.
DEFINE VAR x-Xml AS LONGCHAR.
DEFINE VAR x-Texto AS CHAR CASE-SENSITIVE NO-UNDO.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = 'CONFIG-WEB-LINEAS' NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    pMensaje = "NO se encontró la configuración CONFIG-WEB-LINEAS".
    RETURN "ADM-ERROR".
END.

CREATE X-DOCUMENT hDoc.

/* Barremos todas la LINEAS */
x-url = TRIM(VtaTabla.Llave_c1) + TRIM(VtaTabla.Llave_c2) + '?' + "FormatXML=1".

IF pCodFam > '' THEN x-Url = x-Url + "&Code=" + pCodFam.

hDoc:LOAD("File", x-url, FALSE) NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    pMensaje = "NO se pudo cargar la información de la url:" + CHR(10) + x-url.
    RETURN "ADM-ERROR".
END.
hDoc:SAVE("LONGCHAR",x-Xml) NO-ERROR.

/* Separamos la DATA */
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

x-Texto = STRING(x-Xml).

/* Barremos todo el texto */
DEF VAR x-Cadena AS CHAR NO-UNDO.

/* Limpiamos el texto */
DEF VAR x-Limite-Inicial AS CHAR CASE-SENSITIVE NO-UNDO.
DEF VAR x-Limite-Final AS CHAR CASE-SENSITIVE NO-UNDO.

x-Limite-Inicial = "<Data>".
x-Limite-Final   = "</Data>".
x-Inicio = INDEX(x-Texto, x-Limite-Inicial) + LENGTH(x-Limite-Inicial).
x-Fin = INDEX(x-Texto, x-Limite-Final).
x-Texto = SUBSTRING(x-Texto, x-Inicio , (x-Fin - x-Inicio)).

REPEAT:
    /* ************************************************************************* */
    /* Capturamos el primer bloque entre <Row> y </Row> */
    /* ************************************************************************* */
    x-Limite-Inicial = "<Row>".
    x-Limite-Final   = "</Row>".
    x-Inicio = INDEX(x-Texto, x-Limite-Inicial) + LENGTH(x-Limite-Inicial).
    x-Fin = INDEX(x-Texto, x-Limite-Final).
    IF x-Inicio > x-Fin THEN LEAVE.     /* Fin del proceso */
    x-Cadena = SUBSTRING(x-Texto, x-Inicio , (x-Fin - x-Inicio)).
    RUN web_api-captura-lineas-save (INPUT x-Cadena, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    /* ************************************************************************* */
    /* Recortamos la cadena nuevamente con lo que queda */
    /* ************************************************************************* */
    x-Cadena = "<Row>" + x-Cadena + "</Row>".
    x-Texto = SUBSTRING(x-Texto, INDEX(x-Texto, x-Cadena) + LENGTH(x-Cadena)).
END.

RETURN "OK".

END PROCEDURE.

/* ******************************** */
PROCEDURE web_api-captura-lineas-save:
/* ******************************** */

    DEF INPUT PARAMETER x-Cadena AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    /* ************************************************************************* */
    /* Capturamos informacion de x-Cadena */
    /* ************************************************************************* */
    DEF VAR x-Limite-Inicial AS CHAR CASE-SENSITIVE NO-UNDO.
    DEF VAR x-Limite-Final AS CHAR CASE-SENSITIVE NO-UNDO.
    DEF VAR x-Inicio AS INTE NO-UNDO.
    DEF VAR x-Fin AS INTE NO-UNDO.
    DEF VAR x-Code AS CHAR NO-UNDO.
    DEF VAR x-Name AS CHAR NO-UNDO.
    DEF VAR x-ExchangeRate AS CHAR NO-UNDO.
    DEF VAR x-Timestamp_update AS CHAR NO-UNDO.

    DEF VAR pCuenta AS INTE NO-UNDO.

    x-Limite-Inicial = "<Code>".
    x-Limite-Final = "</Code>".
    x-Inicio = INDEX(x-Cadena, x-Limite-Inicial) + LENGTH(x-Limite-Inicial).
    x-Fin = INDEX(x-Cadena, x-Limite-Final).
    x-Code = SUBSTRING(x-cadena, x-Inicio , (x-Fin - x-Inicio)).

    x-Limite-Inicial = "<Name>".
    x-Limite-Final = "</Name>".
    x-Inicio = INDEX(x-Cadena, x-Limite-Inicial) + LENGTH(x-Limite-Inicial).
    x-Fin = INDEX(x-Cadena, x-Limite-Final).
    x-Name = SUBSTRING(x-cadena, x-Inicio , (x-Fin - x-Inicio)).

    x-Limite-Inicial = "<ExchangeRate>".
    x-Limite-Final = "</ExchangeRate>".
    x-Inicio = INDEX(x-Cadena, x-Limite-Inicial) + LENGTH(x-Limite-Inicial).
    x-Fin = INDEX(x-Cadena, x-Limite-Final).
    x-ExchangeRate = SUBSTRING(x-cadena, x-Inicio , (x-Fin - x-Inicio)).

    x-Limite-Inicial = "<Timestamp_update>".
    x-Limite-Final = "</Timestamp_update>".
    x-Inicio = INDEX(x-Cadena, x-Limite-Inicial) + LENGTH(x-Limite-Inicial).
    x-Fin = INDEX(x-Cadena, x-Limite-Final).
    x-Timestamp_update = SUBSTRING(x-cadena, x-Inicio , (x-Fin - x-Inicio)).

    /* Grabamos */
    FIND Almtfami WHERE Almtfami.CodCia = s-codcia AND
        Almtfami.codfam = x-Code
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtfami THEN DO:
        CREATE Almtfami.
        ASSIGN
            Almtfami.CodCia = s-codcia 
            Almtfami.codfam = x-Code
            Almtfami.desfam = x-Name
            Almtfami.SwComercial = YES
            Almtfami.TpoCmb = DECIMAL(x-ExchangeRate)
            Almtfami.Libre_c05 = "NO"
            Almtfami.Libre_f02 = TODAY
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            RETURN 'ADM-ERROR'.
        END.
    END.
    ELSE DO:
        FIND CURRENT Almtfami EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            Almtfami.TpoCmb = DECIMAL(x-ExchangeRate).
    END.
    /* Campos de control */
    ASSIGN
        Almtfami.Libre_c04 = x-Timestamp_update.
    RELEASE Almtfami.

    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-captura-peldano-valido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-captura-peldano-valido Procedure 
PROCEDURE web_api-captura-peldano-valido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Sintaxis 
http://192.168.100.221:64/api/Pricing/PartOfThePriceLadder/00502/xml
*/

DEF INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.

DEF OUTPUT PARAMETER pEstadoValido AS LOG NO-UNDO.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

pEstadoValido = YES.

DEFINE VAR hDoc AS HANDLE NO-UNDO.
DEFINE VAR x-Url AS CHAR.
DEFINE VAR x-Xml AS LONGCHAR.
DEFINE VAR x-Texto AS CHAR CASE-SENSITIVE NO-UNDO.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = 'CONFIG-WEB-PELDANO-VALIDO' NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    pMessage = "NO se encontró la configuración CONFIG-WEB-PELDANO-VALIDO".
    RETURN "ADM-ERROR".
END.

CREATE X-DOCUMENT hDoc.

/* Barremos todas la LINEAS */
x-url = TRIM(VtaTabla.Llave_c1) + TRIM(pCodDiv) + '/xml'.
/* MESSAGE x-url. */
/* RETURN.        */

/* Capturamos el API */
DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.

/*MESSAGE string(x-url) SKIP x-texto.*/

x-oXmlHttp:OPEN( "GET", x-Url, NO ). 
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
x-oXmlHttp:setOption( 2, 13056 ) .  
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pMessage = ERROR-STATUS:GET-MESSAGE(1).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
IF x-oXmlHttp:STATUS <> 200 THEN DO:
    pMessage = "ERROR AL ENVIAR TRAMA : " + CHR(10) + x-oXmlHttp:responseText.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
/* Respuesta del API */
x-Xml = x-oXmlHttp:responseText.
x-Texto = STRING(x-Xml).

/* DEF VAR x-editor AS CHAR VIEW-AS EDITOR SIZE 60 BY 6. */
/* x-editor = string(x-url).                             */
/* UPDATE x-editor.                                      */
/* RETURN.                                               */

DEF VAR Inicio AS INT64 NO-UNDO.
DEF VAR Fin AS INT64 NO-UNDO.

/* Separamos la DATA */
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

x-Inicio = INDEX(x-Texto, "<Data>").
x-Fin = INDEX(x-Texto, "</Data>").

IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
    pMessage = "NO hay datos registrados".
    RETURN "ADM-ERROR".
END.

x-Texto = SUBSTRING(x-Texto, x-Inicio + 6, (x-Fin - x-Inicio - 6)).

DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.

/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Error AS CHAR NO-UNDO.
IF INDEX(x-Texto, '<error>') > 0 THEN DO:
    x-Cadena1 = "<error>".
    x-Cadena2 = "</error>".
    x-Inicio = INDEX(x-Texto, x-Cadena1).
    x-Fin = INDEX(x-Texto, x-Cadena2).
    IF x-Inicio < x-Fin THEN x-Error = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).
    pMessage = /*"ERROR: No se encontró información requerida" + CHR(10) + CHR(10) +*/
        "Error: " + x-Error + CHR(10) + CHR(10) +
        "División: " + pCodDiv + CHR(10) +
        "Comunicarse con el Jefe de Línea".
    RETURN "ADM-ERROR".
END.
/*MESSAGE x-texto.*/

/* **************************************************************************************** */
/* Buscamos la moneda de venta */
/* **************************************************************************************** */
DEF VAR x-Estado AS CHAR NO-UNDO.
DEF VAR x-Estados AS CHAR INIT '0,1' NO-UNDO.
DEF VAR pEstado AS INTE NO-UNDO.

x-Cadena1 = "<ParteDeLaEscaleraPrecios>".
x-Cadena2 = "</ParteDeLaEscaleraPrecios>".

x-Inicio = INDEX(x-Texto, x-Cadena1).
x-Fin = INDEX(x-Texto, x-Cadena2).
IF x-Inicio > x-Fin THEN DO:
    pMessage = "No hay dato de valides del peldaño".
    RETURN "ADM-ERROR".
END.
x-Estado = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pEstado = LOOKUP(x-Estado, x-Estados).
IF pEstado = 0 THEN DO:
    pMessage = "División: " + pCodDiv + CHR(10) +
                "Respuesta no está en el formato correcto" + CHR(10) + x-texto.
    RETURN "ADM-ERROR".
END.

IF x-Estado = "0" THEN pEstadoValido = NO.       /* No pertenece al peldaño de precios */
IF x-Estado = "1" THEN pEstadoValido = YES.      /* Sí pertenece al peldaño de precios */

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-pricing-preuni) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-preuni Procedure 
PROCEDURE web_api-pricing-preuni :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Devuelve el precio unitario ya afectado por el descuento x clf y x cond vta
------------------------------------------------------------------------------*/
/* Sintaxis
192.168.100.221:62/api/Sales/Record/PriceSalesChannelUnit/
sha256$5uqVbpQ6dWv0z2Tw$8cfcfcd13571eba4873e06dd6dd25674503c498657f7da6969aae41a0249c64a
?FormatXML=True&
FieldName=DiscountedPriceCategoryCustomerAndConditionSale,
ExchangeRate,                   /* Tipo de Cambio */
CurrencySale,                   /* Moneda de Venta */
PercentageDiscountSalesCondition,
PercentageDiscountCategoryCustomer,
CurrencyRepositionCost,         
AmountRepositionCost,
RepositionCostInCurrencySale    /* Costo de Reposición EN MONEDA DE VENTA */
&ArtCode=002056
&SalesChannel=1
&CategoryCustomer=A
&SalesCondition=001
&StateCategoryCustomer=1        /* Activo: obligatorio */
&StateSalesCondition=1          /* Activo: obligatorio */
*/

DEF INPUT PARAMETER pArtCode AS CHAR.
DEF INPUT PARAMETER pSalesChannel AS CHAR.
DEF INPUT PARAMETER pCategoryCustomer AS CHAR.
DEF INPUT PARAMETER pSalesCondition AS CHAR.
DEF OUTPUT PARAMETER pMonVta AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pTpoCmb AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pPrecioDescontado AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

/*MESSAGE partcode psaleschannel pCategoryCustomer pSalesCondition.*/

DEFINE VAR x-Url AS LONGCHAR.
DEFINE VAR x-Xml AS LONGCHAR.
DEFINE VAR x-Texto AS CHAR.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = 'CONFIG-WEB-PRICING' NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    pMessage = "NO se encontró la configuración CONFIG-WEB-PRICING".
    RETURN "ADM-ERROR".
END.

/* Capturamos URL y TOKEN */
x-Url = TRIM(VtaTabla.Llave_c1) +       /* URL */
        TRIM(VtaTabla.Llave_c2) .       /* Token */
/* Campos a devolver */
x-Url = x-Url + ~
"?FormatXML=True&~
FieldName=DiscountedPriceCategoryCustomerAndConditionSale,~
ExchangeRate,~
CurrencySale,~
PercentageDiscountSalesCondition,~
PercentageDiscountCategoryCustomer,~
RepositionCostInCurrencySale,~
AmountRepositionCost".
/* Llave de búsqueda */
x-Url = x-Url + ~
'&ArtCode=' + pArtCode + ~
'&SalesChannel=' + pSalesChannel + ~
'&CategoryCustomer=' + pCategoryCustomer + ~
'&SalesCondition=' + pSalesCondition.

/* Capturamos el API */
DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.

/*MESSAGE string(x-url) SKIP x-texto.*/

x-oXmlHttp:OPEN( "GET", x-Url, NO ). 
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
x-oXmlHttp:setOption( 2, 13056 ) .  
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pMessage = ERROR-STATUS:GET-MESSAGE(1).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
IF x-oXmlHttp:STATUS <> 200 THEN DO:
    pMessage = "ERROR AL ENVIAR TRAMA : " + CHR(10) + x-oXmlHttp:responseText.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
/* Respuesta del API */
x-Xml = x-oXmlHttp:responseText.
x-Texto = STRING(x-Xml).

/* DEF VAR x-editor AS CHAR VIEW-AS EDITOR SIZE 60 BY 6. */
/* x-editor = string(x-url).                             */
/* UPDATE x-editor.                                      */
/* RETURN.                                               */

DEF VAR Inicio AS INT64 NO-UNDO.
DEF VAR Fin AS INT64 NO-UNDO.

/* Separamos la DATA */
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.


x-Inicio = INDEX(x-Texto, "<Data>").
x-Fin = INDEX(x-Texto, "</Data>").

IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
    pMessage = "NO hay datos registrados".
    RETURN "ADM-ERROR".
END.

x-Texto = SUBSTRING(x-Texto, x-Inicio + 6, (x-Fin - x-Inicio - 6)).

DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.

/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
IF INDEX(x-Texto, '<error>') > 0 THEN DO:
    x-Cadena1 = "<error>".
    x-Cadena2 = "</error>".
    x-Inicio = INDEX(x-Texto, x-Cadena1).
    x-Fin = INDEX(x-Texto, x-Cadena2).
    IF x-Inicio > x-Fin THEN DO:
        pMessage = "VALIDACION: Precio Peldaño Bruto NO disponible para la venta" + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto o está configurado con margen negativo" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea".
    END.
    ELSE DO:
        pMessage = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).
        pMessage = pMessage + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto o está configurado con margen negativo" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea".
    END.
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */
/* Buscamos la moneda de venta */
/* **************************************************************************************** */
DEF VAR x-MonVta AS CHAR NO-UNDO.
DEF VAR x-Monedas AS CHAR INIT 'S/,$' NO-UNDO.

x-Cadena1 = "<CurrencySale>".
x-Cadena2 = "</CurrencySale>".

x-Inicio = INDEX(x-Texto, x-Cadena1).
x-Fin = INDEX(x-Texto, x-Cadena2).
IF x-Inicio > x-Fin THEN DO:
    pMessage = "Moneda de Venta: NO registrado en la lista de precios".
    RETURN "ADM-ERROR".
END.
x-MonVta = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pMonVta = LOOKUP(x-MonVta, x-Monedas).
IF pMonVta = 0 THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Moneda de Venta no está en el formato correcto" + CHR(10) + x-texto.
    RETURN "ADM-ERROR".
END.

/* **************************************************************************************** */
/* Tipo de cambio */
/* **************************************************************************************** */
DEF VAR x-TpoCmb AS CHAR NO-UNDO.

x-Cadena1 = "<ExchangeRate>".
x-Cadena2 = "</ExchangeRate>".

x-Inicio = INDEX(x-Texto, x-Cadena1).
x-Fin = INDEX(x-Texto, x-Cadena2).
IF x-Inicio > x-Fin THEN DO:
    pMessage = "Tipo de cambio: NO registrado en la lista de precios".
    RETURN "ADM-ERROR".
END.
x-TpoCmb = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pTpoCmb = DECIMAL(x-TpoCmb) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Tipo de Cambio no está en el formato correcto" + CHR(10) + x-texto.
    RETURN "ADM-ERROR".
END.

/* **************************************************************************************** */
/* Buscamos el precio descontado */
/* **************************************************************************************** */
DEF VAR x-PrecioDescontado AS CHAR NO-UNDO.

x-Cadena1 = "<DiscountedPriceCategoryCustomerAndConditionSale>".
x-Cadena2 = "</DiscountedPriceCategoryCustomerAndConditionSale>".

x-Inicio = INDEX(x-Texto, x-Cadena1).
x-Fin = INDEX(x-Texto, x-Cadena2).
IF x-Inicio > x-Fin THEN DO:
    pMessage = "Precio Unitario Peldaño Bruto: NO registrado en la lista de precios".
    RETURN "ADM-ERROR".
END.
x-PrecioDescontado = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pPrecioDescontado = DECIMAL(x-PrecioDescontado) NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    pMessage = "Precio Unitario Peldaño no está en formato de números" + CHR(10) + x-texto.
    RETURN "ADM-ERROR".
END.

/* **************************************************************************************** */
/* Buscamos el costo de reposición */
/* **************************************************************************************** */
DEF VAR x-CostoReposicion AS CHAR NO-UNDO.
DEF VAR pCostoReposicion AS DECI NO-UNDO.

x-Cadena1 = "<RepositionCostInCurrencySale>".
x-Cadena2 = "</RepositionCostInCurrencySale>".

x-Inicio = INDEX(x-Texto, x-Cadena1).
x-Fin = INDEX(x-Texto, x-Cadena2).
IF x-Inicio > x-Fin THEN DO:
/*     pMessage = "Precio Unitario Peldaño: NO registrado en la lista de precios". */
/*     RETURN "ADM-ERROR".                                                         */
END.
ELSE DO:
    x-CostoReposicion = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).
    pCostoReposicion = DECIMAL(x-CostoReposicion) NO-ERROR.
    IF ERROR-STATUS:ERROR = NO THEN DO:
        IF pPrecioDescontado < pCostoReposicion THEN DO:
            pMessage = "Artículo NO disponible para la venta porque su margen configurado es negativo" + CHR(10) +
                "Precio Peldaño Bruto está por debajo del costo de reposición" + CHR(10) + CHR(10) +
                "Por favor consultar al Jefe de Línea".
            /*pMessage = "Precio Unitario Peldaño Bruto (" + STRING(pPrecioDescontado) + ") es menor al Costo de Reposición".*/
            RETURN "ADM-ERROR".
        END.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

