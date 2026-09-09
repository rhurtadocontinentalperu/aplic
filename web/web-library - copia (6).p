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
DEF SHARED VAR s-user-id AS CHAR.
/* DEF SHARED VAR s-aplic-id AS CHAR.  */
/* DEF SHARED VAR s-prog-name AS CHAR. */

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


/* 04/02/2026: Nueva libreria que lee JSon's */
DEF VAR hJson AS HANDLE NO-UNDO.
RUN lib/json10.p PERSISTENT SET hJson.

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
         HEIGHT             = 18.46
         WIDTH              = 59.43.
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
09/06/2026 
http://192.168.1.246:64/api/Pricing/PartOfThePriceLadder/00001/xml
*/

DEF INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pEstadoValido AS LOG NO-UNDO.
DEF OUTPUT PARAMETER pSalesChannel AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

pEstadoValido = NO.

DEFINE VAR x-Url AS CHAR.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = 'CONFIG-WEB-PELDANO-VALIDO' NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    pMessage = "NO se encontró la configuración CONFIG-WEB-PELDANO-VALIDO".
    RETURN "ADM-ERROR".
END.
/* Barremos todas la LINEAS */
x-url = TRIM(VtaTabla.Llave_c1) + '?Code=' + TRIM(pCodDiv).

/* Capturamos el API */
DEF VAR pResult AS CHAR NO-UNDO.
DEF VAR pResponse AS LONGCHAR NO-UNDO.
DEF VAR pContent AS LONGCHAR CASE-SENSITIVE NO-UNDO.
DEF VAR cAbrirCorchete AS CHAR NO-UNDO.
DEF VAR cCerrarCorchete AS CHAR NO-UNDO.

cAbrirCorchete = CHR(123).
cCerrarCorchete = CHR(125).

RUN lib/http-get-contenido.r(x-Url,
                             OUTPUT pResult,
                             OUTPUT pResponse,
                             OUTPUT pContent) 
    NO-ERROR.
IF INDEX(pResult, '0:No Socket') > 0 THEN DO:
    pMessage = "ERROR:" + CHR(10) + CHR(10) +
        "URL no existe: " + TRIM(VtaTabla.Llave_c1) + CHR(10) + CHR(10) +
        "Proceso abortado".
    RETURN 'ADM-ERROR'.
END.
IF INDEX(pResult, '[]') > 0 THEN DO:
    pMessage = "API no retornó ninguna información" + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RETURN 'ADM-ERROR'.
END.

DEF VAR pContent2 AS LONGCHAR CASE-SENSITIVE NO-UNDO.

pContent2 = REPLACE(pContent, cAbrirCorchete, '[').
pContent2 = REPLACE(pContent, cCerrarCorchete, ']').
IF INDEX(pContent2, '[]') > 0 THEN DO:
    pMessage = "API no retornó ninguna información" + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RETURN 'ADM-ERROR'.
END.

/* 04/02/2026: Nueva libreria que lee JSon's */
/* DEF VAR hJson AS HANDLE NO-UNDO.       */
/* RUN lib/json10.p PERSISTENT SET hJson. */

DEFINE VARIABLE miJson AS CHARACTER NO-UNDO.
DEFINE VARIABLE raiz AS INTEGER NO-UNDO.     
DEFINE VARIABLE arrayId AS INTEGER NO-UNDO.
DEFINE VARIABLE itemId AS INTEGER NO-UNDO.

/* Inicializamos variables */
RUN iniJson IN hJson (INPUT pContent).
/* Capturamos JSON */
raiz = DYNAMIC-FUNCTION("parseVal":U IN hJson, INPUT 0, INPUT "").
arrayId = raiz.

/* Total items en el arreglo */
DEFINE VARIABLE TotalItems AS INTE NO-UNDO.
TotalItems = DYNAMIC-FUNCTION("arrayCount":U IN hJson, INPUT arrayId).
/* Definimos variables a capturar */
DEF VAR cStepChannel AS CHAR NO-UNDO.
DEF VAR cUseStepChannel AS CHAR NO-UNDO.
/* Barremos todos los items */
DEF VAR iRegistro AS INTE NO-UNDO.
DO iRegistro = 1 TO TotalItems:
    itemId = DYNAMIC-FUNCTION("getArrayItem" IN hJson, INPUT arrayId, INPUT iRegistro).
    IF itemId > 0 THEN DO:
        cStepChannel    = DYNAMIC-FUNCTION("getVal" IN hJson, INPUT itemId,INPUT "StepChannel").
        cUseStepChannel = DYNAMIC-FUNCTION("getVal" IN hJson, INPUT itemId,INPUT "UseStepChannel").
    END.
END.
pSalesChannel = cStepChannel.
IF cUseStepChannel = "0" THEN pEstadoValido = NO.       /* No pertenece al peldaño de precios */
IF cUseStepChannel = "1" THEN pEstadoValido = YES.      /* Sí pertenece al peldaño de precios */

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-pricing-ctoreposicion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-ctoreposicion Procedure 
PROCEDURE web_api-pricing-ctoreposicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Devuelve el costo de reposicion a la moneda de venta
------------------------------------------------------------------------------*/

/* Sintaxis
http://192.168.0.237:62/api/storeprocedure/XML
/002056
/x    <<< OJO <<<
/C
/000
*/
DEF INPUT PARAMETER pCodDiv  AS CHAR.
DEF INPUT PARAMETER pArtCode AS CHAR.
DEF INPUT PARAMETER pCategoryCustomer AS CHAR.
DEF INPUT PARAMETER pSalesCondition AS CHAR.
DEF OUTPUT PARAMETER pMonVta AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pTpoCmb AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pRepositionCostInCurrencySale AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

DEF VAR pSalesChannel AS CHAR INIT '6' NO-UNDO.     /* TIENDAS MAYORISTAS */

IF pCodDiv  > '' THEN DO:
    FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-div AND GN-DIVI.Grupo_Divi_GG > "" 
        THEN pSalesChannel = TRIM(STRING(INTEGER(GN-DIVI.Grupo_Divi_GG))).
END.

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

/* Llave de búsqueda */
/* Llave de búsqueda */
x-Url = x-Url + ~
'/' + pArtCode + ~
'/' + pSalesChannel + ~
'/' + pCategoryCustomer + ~
'/' + pSalesCondition.

/* DEF VAR x-editor AS CHAR VIEW-AS EDITOR SIZE 60 BY 6. */
/* x-editor = string(x-url).                             */
/* UPDATE x-editor.                                      */
/* RETURN.                                               */

/* Capturamos el API */
DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.

x-oXmlHttp:OPEN( "GET", x-Url, NO ). 
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
x-oXmlHttp:setOption( 2, 13056 ) .  
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (100.198)," + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas"  + CHR(10) +
        TRIM(x-Url).
    RUN web_connection_log (x-Url, ERROR-STATUS:GET-MESSAGE(1)).
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

/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

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
            "Comunicarse con el Jefe de Línea".
    END.
    ELSE DO:
        pMessage = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).
        pMessage = pMessage + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto o está configurado con margen negativo" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Comunicarse con el Jefe de Línea".
    END.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */

DEF VAR Inicio AS INT64 NO-UNDO.
DEF VAR Fin AS INT64 NO-UNDO.

/* Separamos la DATA */
x-Inicio = INDEX(x-Texto, "<Data>").
x-Fin = INDEX(x-Texto, "</Data>").

IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
    pMessage = "XML no retornó ninguna información" + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, "XML no retornó ninguna información").
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.

x-Texto = SUBSTRING(x-Texto, x-Inicio + 6, (x-Fin - x-Inicio - 6)).

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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-MonVta = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pMonVta = LOOKUP(x-MonVta, x-Monedas).
IF pMonVta = 0 THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Moneda de Venta no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-TpoCmb = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pTpoCmb = DECIMAL(x-TpoCmb) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Tipo de Cambio no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
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
    pMessage = "Costo de Reposición: NO registrado en la lista de precios".
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-CostoReposicion = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pRepositionCostInCurrencySale = DECIMAL(x-CostoReposicion) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Costo de Reposición no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.

RELEASE OBJECT x-oXmlHttp NO-ERROR.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-pricing-ctoreposicion-Old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-ctoreposicion-Old Procedure 
PROCEDURE web_api-pricing-ctoreposicion-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Devuelve el costo de reposicion a la moneda de venta
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
DEF INPUT PARAMETER pCategoryCustomer AS CHAR.
DEF INPUT PARAMETER pSalesCondition AS CHAR.
DEF OUTPUT PARAMETER pMonVta AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pTpoCmb AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pRepositionCostInCurrencySale AS DECI NO-UNDO.
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
FieldName=ExchangeRate,~
CurrencySale,~
RepositionCostInCurrencySale".

/* Llave de búsqueda */
x-Url = x-Url + ~
'&ArtCode=' + pArtCode + ~
'&CategoryCustomer=' + pCategoryCustomer + ~
'&SalesCondition=' + pSalesCondition.

/* DEF VAR x-editor AS CHAR VIEW-AS EDITOR SIZE 60 BY 6. */
/* x-editor = string(x-url).                             */
/* UPDATE x-editor.                                      */
/* RETURN.                                               */

/* Capturamos el API */
DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.

x-oXmlHttp:OPEN( "GET", x-Url, NO ). 
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
x-oXmlHttp:setOption( 2, 13056 ) .  
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pMessage = "API NO responde" + CHR(10) + CHR(10) + "Comunicarse con el área de Sistemas".
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

/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

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
            "Comunicarse con el Jefe de Línea".
    END.
    ELSE DO:
        pMessage = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).
        pMessage = pMessage + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto o está configurado con margen negativo" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Comunicarse con el Jefe de Línea".
    END.
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */

DEF VAR Inicio AS INT64 NO-UNDO.
DEF VAR Fin AS INT64 NO-UNDO.

/* Separamos la DATA */
x-Inicio = INDEX(x-Texto, "<Data>").
x-Fin = INDEX(x-Texto, "</Data>").

IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
    pMessage = "API NO responde".
    RETURN "ADM-ERROR".
END.

x-Texto = SUBSTRING(x-Texto, x-Inicio + 6, (x-Fin - x-Inicio - 6)).

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
/* Buscamos el costo de reposición */
/* **************************************************************************************** */
DEF VAR x-CostoReposicion AS CHAR NO-UNDO.
DEF VAR pCostoReposicion AS DECI NO-UNDO.

x-Cadena1 = "<RepositionCostInCurrencySale>".
x-Cadena2 = "</RepositionCostInCurrencySale>".

x-Inicio = INDEX(x-Texto, x-Cadena1).
x-Fin = INDEX(x-Texto, x-Cadena2).
IF x-Inicio > x-Fin THEN DO:
    pMessage = "Costo de Reposición: NO registrado en la lista de precios".
    RETURN "ADM-ERROR".
END.
x-CostoReposicion = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pRepositionCostInCurrencySale = DECIMAL(x-CostoReposicion) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Costo de Reposición no está en el formato correcto" + CHR(10) + x-texto.
    RETURN "ADM-ERROR".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-pricing-margen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-margen Procedure 
PROCEDURE web_api-pricing-margen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv                         AS CHAR.
DEF INPUT PARAMETER pArtCode                        AS CHAR.
DEF INPUT PARAMETER pSalesChannel AS CHAR.
DEF INPUT PARAMETER pCategoryCustomer               AS CHAR.
DEF INPUT PARAMETER pSalesCondition                 AS CHAR.
DEF OUTPUT PARAMETER pMonVta                        AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pTpoCmb                        AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pRepositionCostInCurrencySale  AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pPrecioDescontado              AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pMessage                       AS CHAR NO-UNDO.

DEF VAR pcReturn AS LONGCHAR NO-UNDO.
DEF VAR pcError AS LONGCHAR NO-UNDO.
DEFINE VAR priMonVta AS INTE NO-UNDO.
DEFINE VAR priTpoCmb AS DECI NO-UNDO.

DEF VAR hProc AS HANDLE NO-UNDO.

RUN web/web-library.p PERSISTENT SET hProc.

RUN web_api-unit-cost-price IN hProc (INPUT pArtCode,
                                      INPUT pCategoryCustomer,
                                      INPUT pSalesCondition,
                                      INPUT "",     /* Sin Cliente */
                                      INPUT pCodDiv,
                                      OUTPUT pcReturn,
                                      OUTPUT pcError).
DELETE PROCEDURE hProc.
IF pcError > '' AND TRUE <> (pcReturn > '') THEN DO:
    pMessage = STRING(pcError).
    RETURN 'ADM-ERROR'.
END.
/* Sintaxis pcReturn
<cCodMat>:<cCodMon>:<fTpoCmb>:<fPreUni>:<fRepositionCostInCurrencySale>:<cContrato>[,...].
*/
/* **************************************************************************************** */
/* Buscamos la moneda de venta */
/* **************************************************************************************** */
pMonVta = INTEGER(ENTRY(2,pcReturn,':')) NO-ERROR.
IF pMonVta = 0 THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Moneda de Venta no está en el formato correcto" + CHR(10) + ENTRY(2,pcReturn,':').
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */
/* Tipo de cambio */
/* **************************************************************************************** */
pTpoCmb = DECIMAL(ENTRY(3,pcReturn,':')) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Tipo de Cambio no está en el formato correcto" + CHR(10) + ENTRY(3,pcReturn,':').
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */
/* Buscamos el costo de reposición */
/* **************************************************************************************** */
pRepositionCostInCurrencySale = DECIMAL(ENTRY(5,pcReturn,':')) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Costo de Reposición no está en el formato correcto" + CHR(10) + ENTRY(5,pcReturn,':').
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */
/* Buscamos el precio descontado */
/* **************************************************************************************** */
pPrecioDescontado = DECIMAL(ENTRY(4,pcReturn,':')) NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    pMessage = "Precio Unitario Peldaño no está en formato de números" + CHR(10) + ENTRY(4,pcReturn,':').
    RETURN "ADM-ERROR".
END.
IF pPrecioDescontado <= 0 THEN DO:
    pMessage = "Precio Peldaño Bruto está mal configurado" + CHR(10) + CHR(10) +     
        "Por favor consultar al Jefe de Línea". 
    RETURN 'ADM-ERROR'.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-pricing-margen-old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-margen-old Procedure 
PROCEDURE web_api-pricing-margen-old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv                         AS CHAR.
DEF INPUT PARAMETER pArtCode                        AS CHAR.
DEF INPUT PARAMETER pSalesChannel AS CHAR.
DEF INPUT PARAMETER pCategoryCustomer               AS CHAR.
DEF INPUT PARAMETER pSalesCondition                 AS CHAR.
DEF OUTPUT PARAMETER pMonVta                        AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pTpoCmb                        AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pRepositionCostInCurrencySale  AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pPrecioDescontado              AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pMessage                       AS CHAR NO-UNDO.

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

/* Llave de búsqueda */
/* Llave de búsqueda */
x-Url = x-Url + ~
'/' + pArtCode + ~
'/' + pSalesChannel + ~
'/' + pCategoryCustomer + ~
'/' + pSalesCondition.

/* Capturamos el API */
DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.

x-oXmlHttp:OPEN( "GET", x-Url, NO ). 
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
x-oXmlHttp:setOption( 2, 13056 ) .  
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (100.198)," + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas"  + CHR(10) +
        TRIM(x-Url).
    RUN web_connection_log (x-Url, ERROR-STATUS:GET-MESSAGE(1)).
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

/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

IF INDEX(x-Texto, '<error>') > 0 THEN DO:
    x-Cadena1 = "<error>".
    x-Cadena2 = "</error>".
    x-Inicio = INDEX(x-Texto, x-Cadena1).
    x-Fin = INDEX(x-Texto, x-Cadena2).
    x-Texto = "API no responde".
    IF x-Inicio > x-Fin THEN DO:
        pMessage = "VALIDACION: Precio Peldaño Bruto NO disponible para la venta" + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
            "y de ser necesario se comunicará con sistemas".
    END.
    ELSE DO:
        pMessage = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).
        pMessage = pMessage + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
            "y de ser necesario se comunicará con sistemas".
    END.
    RUN web_connection_log (x-Url, x-Texto).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */
DEF VAR Inicio AS INT64 NO-UNDO.
DEF VAR Fin AS INT64 NO-UNDO.

/* Separamos la DATA */
x-Inicio = INDEX(x-Texto, "<Data>").
x-Fin = INDEX(x-Texto, "</Data>").

IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
    pMessage = "XML no retornó ninguna información" + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, "XML no retornó ninguna información").
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.

x-Texto = SUBSTRING(x-Texto, x-Inicio + 6, (x-Fin - x-Inicio - 6)).

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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-MonVta = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pMonVta = LOOKUP(x-MonVta, x-Monedas).
IF pMonVta = 0 THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Moneda de Venta no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-TpoCmb = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pTpoCmb = DECIMAL(x-TpoCmb) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Tipo de Cambio no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
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
    pMessage = "Costo de Reposición: NO registrado en la lista de precios".
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-CostoReposicion = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pRepositionCostInCurrencySale = DECIMAL(x-CostoReposicion) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Costo de Reposición no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-PrecioDescontado = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pPrecioDescontado = DECIMAL(x-PrecioDescontado) NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    pMessage = "Precio Unitario Peldaño no está en formato de números" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
IF pPrecioDescontado <= 0 THEN DO:
    pMessage = "Precio Peldaño Bruto está mal configurado" + CHR(10) + CHR(10) +     
        "Por favor consultar al Jefe de Línea". 
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.

RELEASE OBJECT x-oXmlHttp NO-ERROR.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-pricing-precio-costo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-precio-costo Procedure 
PROCEDURE web_api-pricing-precio-costo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pArtCode AS CHAR.
DEF INPUT PARAMETER pSalesChannel AS CHAR.
DEF INPUT PARAMETER pCategoryCustomer AS CHAR.
DEF INPUT PARAMETER pSalesCondition AS CHAR.
DEF OUTPUT PARAMETER pMonVta AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pTpoCmb AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pPrecioDescontado AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pRepositionCostInCurrencySale AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

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
/* Llave de búsqueda */
x-Url = x-Url + ~
'/' + pArtCode + ~
'/' + pSalesChannel + ~
'/' + pCategoryCustomer + ~
'/' + pSalesCondition.

/* Capturamos el API */
DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.

x-oXmlHttp:OPEN( "GET", x-Url, NO ). 
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
x-oXmlHttp:setOption( 2, 13056 ) .  
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (Servidor de aplicaciones detenido o no existe)" + CHR(10) +
        x-Url + CHR(10) + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, ERROR-STATUS:GET-MESSAGE(1)).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
IF x-oXmlHttp:STATUS <> 200 THEN DO:
    pMessage = "ERROR AL ENVIAR TRAMA : " + CHR(10) + x-oXmlHttp:responseText.
    RUN web_connection_log (x-Url, "ERROR AL ENVIAR TRAMA : " + x-oXmlHttp:responseText).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
/* Respuesta del API */
x-Xml = x-oXmlHttp:responseText.
x-Texto = STRING(x-Xml).
/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

IF INDEX(x-Texto, '<error>') > 0 THEN DO:
    x-Cadena1 = "<error>".
    x-Cadena2 = "</error>".
    x-Inicio = INDEX(x-Texto, x-Cadena1).
    x-Fin = INDEX(x-Texto, x-Cadena2).
    x-Texto = "API no responde".
    IF x-Inicio > x-Fin THEN DO:
        pMessage = "VALIDACION: Precio Peldaño Bruto NO disponible para la venta" + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
            "y de ser necesario se comunicará con sistemas".
    END.
    ELSE DO:
        pMessage = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).
        pMessage = pMessage + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
            "y de ser necesario se comunicará con sistemas".
    END.
    RUN web_connection_log (x-Url, x-Texto).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */

DEF VAR Inicio AS INT64 NO-UNDO.
DEF VAR Fin AS INT64 NO-UNDO.

/* Separamos la DATA */
x-Inicio = INDEX(x-Texto, "<Data>").
x-Fin = INDEX(x-Texto, "</Data>").

IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
    pMessage = "XML no retornó ninguna información" + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, "XML no retornó ninguna información").
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.

x-Texto = SUBSTRING(x-Texto, x-Inicio + 6, (x-Fin - x-Inicio - 6)).

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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-MonVta = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pMonVta = LOOKUP(x-MonVta, x-Monedas).
IF pMonVta = 0 THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Moneda de Venta no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-TpoCmb = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pTpoCmb = DECIMAL(x-TpoCmb) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Tipo de Cambio no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-PrecioDescontado = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pPrecioDescontado = DECIMAL(x-PrecioDescontado) NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    pMessage = "Precio Unitario Peldaño no está en formato de números" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
IF pPrecioDescontado <= 0 THEN DO:
    pMessage = "Precio Peldaño Bruto está mal configurado" + CHR(10) + CHR(10) +     
        "Por favor consultar al Jefe de Línea". 
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.

/* **************************************************************************************** */
/* Buscamos el costo de reposición */
/* **************************************************************************************** */
DEF VAR x-CostoReposicion AS CHAR NO-UNDO.

x-Cadena1 = "<RepositionCostInCurrencySale>".
x-Cadena2 = "</RepositionCostInCurrencySale>".

x-Inicio = INDEX(x-Texto, x-Cadena1).
x-Fin = INDEX(x-Texto, x-Cadena2).
IF x-Inicio > x-Fin THEN DO:
    pMessage = "Costo de Reposición: NO registrado en la lista de precios".
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-CostoReposicion = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pRepositionCostInCurrencySale = DECIMAL(x-CostoReposicion) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Costo de Reposición no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.

RELEASE OBJECT x-oXmlHttp NO-ERROR.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-pricing-precio-costo-socket) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-precio-costo-socket Procedure 
PROCEDURE web_api-pricing-precio-costo-socket :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       VíA SOCKET
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pArtCode AS CHAR.
DEF INPUT PARAMETER pSalesChannel AS CHAR.
DEF INPUT PARAMETER pCategoryCustomer AS CHAR.
DEF INPUT PARAMETER pSalesCondition AS CHAR.
DEF OUTPUT PARAMETER pMonVta AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pTpoCmb AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pPrecioDescontado AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pRepositionCostInCurrencySale AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

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
/* Llave de búsqueda */
x-Url = x-Url + ~
'/' + pArtCode + ~
'/' + pSalesChannel + ~
'/' + pCategoryCustomer + ~
'/' + pSalesCondition.

/* Capturamos el API */
DEF VAR x-Resultado AS CHAR NO-UNDO.
DEF VAR x-Respuesta AS LONGCHAR NO-UNDO.
DEF VAR x-Contenido AS LONGCHAR NO-UNDO.

RUN lib/http-get-contenido.p (INPUT x-Url,
                              OUTPUT x-Resultado,
                              OUTPUT x-Respuesta,
                              OUTPUT x-Contenido).      /* Respuesta del API */

/* Control de errores */
IF x-Resultado BEGINS "0:" THEN DO:
    pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (Servidor de aplicaciones detenido o no existe)" + CHR(10) +
        x-Url + CHR(10) + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, ERROR-STATUS:GET-MESSAGE(1)).
    RETURN 'ADM-ERROR'.
END.

/* Respuesta del API */
x-Xml = x-Contenido.
x-Texto = STRING(x-Xml).
/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

IF INDEX(x-Texto, '<error>') > 0 THEN DO:
    x-Cadena1 = "<error>".
    x-Cadena2 = "</error>".
    x-Inicio = INDEX(x-Texto, x-Cadena1).
    x-Fin = INDEX(x-Texto, x-Cadena2).
    x-Texto = "API no responde".
    IF x-Inicio > x-Fin THEN DO:
        pMessage = "VALIDACION: Precio Peldaño Bruto NO disponible para la venta" + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
            "y de ser necesario se comunicará con sistemas".
    END.
    ELSE DO:
        pMessage = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).
        pMessage = pMessage + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
            "y de ser necesario se comunicará con sistemas".
    END.
    RUN web_connection_log (x-Url, x-Texto).
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */

DEF VAR Inicio AS INT64 NO-UNDO.
DEF VAR Fin AS INT64 NO-UNDO.

/* Separamos la DATA */
x-Inicio = INDEX(x-Texto, "<Data>").
x-Fin = INDEX(x-Texto, "</Data>").

IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
    pMessage = "XML no retornó ninguna información" + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, "XML no retornó ninguna información").
    RETURN "ADM-ERROR".
END.

x-Texto = SUBSTRING(x-Texto, x-Inicio + 6, (x-Fin - x-Inicio - 6)).

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
IF pPrecioDescontado <= 0 THEN DO:
    pMessage = "Precio Peldaño Bruto está mal configurado" + CHR(10) + CHR(10) +     
        "Por favor consultar al Jefe de Línea". 
    RETURN 'ADM-ERROR'.
END.

/* **************************************************************************************** */
/* Buscamos el costo de reposición */
/* **************************************************************************************** */
DEF VAR x-CostoReposicion AS CHAR NO-UNDO.

x-Cadena1 = "<RepositionCostInCurrencySale>".
x-Cadena2 = "</RepositionCostInCurrencySale>".

x-Inicio = INDEX(x-Texto, x-Cadena1).
x-Fin = INDEX(x-Texto, x-Cadena2).
IF x-Inicio > x-Fin THEN DO:
    pMessage = "Costo de Reposición: NO registrado en la lista de precios".
    RETURN "ADM-ERROR".
END.
x-CostoReposicion = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pRepositionCostInCurrencySale = DECIMAL(x-CostoReposicion) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Costo de Reposición no está en el formato correcto" + CHR(10) + x-texto.
    RETURN "ADM-ERROR".
END.

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
http://192.168.0.237:62/api/storeprocedure/XML
/002056
/1
/C
/000
*/
DEF INPUT PARAMETER pArtCode AS CHAR.
DEF INPUT PARAMETER pSalesChannel AS CHAR.
DEF INPUT PARAMETER pCategoryCustomer AS CHAR.
DEF INPUT PARAMETER pSalesCondition AS CHAR.
DEF OUTPUT PARAMETER pMonVta AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pTpoCmb AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pPrecioDescontado AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

/* */
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
/* Llave de búsqueda */
x-Url = x-Url + ~
'/' + pArtCode + ~
'/' + pSalesChannel + ~
'/' + pCategoryCustomer + ~
'/' + pSalesCondition.

/* Capturamos el API */
DEF VAR pResult AS CHAR NO-UNDO.
DEF VAR pResponse AS LONGCHAR NO-UNDO.
DEF VAR pContent AS LONGCHAR NO-UNDO.

RUN lib/http-get-contenido.r(x-Url,
                             OUTPUT pResult,
                             OUTPUT pResponse,
                             OUTPUT pContent) 
    NO-ERROR.

IF pResult <> "1:Success"  THEN DO:
    /* ERROR DETECTADO */
    CASE pResult:
        WHEN "0:Not Content" THEN DO:
            pMessage = "VALIDACION: Precio Peldaño Bruto NO disponible para la venta" + CHR(10) + 
                "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
                "NO disponible para la venta" + CHR(10) + 
                "Artículo: " + pArtCode + CHR(10) +
                "Peldaño: " + pSalesChannel + CHR(10) +
                "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
                "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
                "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
                "y de ser necesario se comunicará con sistemas".
        END.
        WHEN "0:No Socket" THEN DO:
            pMessage = "ERROR AL ENVIAR TRAMA : " + CHR(10) + x-Url.
        END.
        WHEN "0:Failure" THEN DO:
            pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (Servidor de aplicaciones detenido o no existe)" + CHR(10) +
                x-Url + CHR(10) + CHR(10) +
                "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
        END.
        OTHERWISE DO:
            pMessage = "ERROR API : " + CHR(10) + x-Url + "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
        END.
    END CASE.
    RETURN "ADM-ERROR".
END.

/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

DEF VAR Inicio AS INT64 NO-UNDO.
DEF VAR Fin AS INT64 NO-UNDO.

/* Separamos la DATA */
x-Texto = pContent.
x-Inicio = INDEX(x-Texto, "<Data>").
x-Fin = INDEX(x-Texto, "</Data>").

IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
    pMessage = "XML no retornó ninguna información" + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RETURN "ADM-ERROR".
END.

x-Texto = SUBSTRING(x-Texto, x-Inicio + 6, (x-Fin - x-Inicio - 6)).

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
IF pPrecioDescontado <= 0 THEN DO:
    pMessage = "Precio Peldaño Bruto está mal configurado" + CHR(10) + CHR(10) +     
        "Por favor consultar al Jefe de Línea". 
    RETURN 'ADM-ERROR'.
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

END.
ELSE DO:

END.



RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-pricing-preuni-contrato) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-preuni-contrato Procedure 
PROCEDURE web_api-pricing-preuni-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* 
Sintaxis:
http://192.168.100.221:9000/sales/salespricelist/item/<cliente>/<artículo>/view

Resultado:         
[
    {
        "id": 4,
        "idcustomerriqra": null,
        "pricelistid": null,
        "custcode": "11111111111",
        "name": "0",
        "artcode": "084471",
        "factor": null,
        "price": 41.9169,
        "undvta": "UNI"
    }
]
*/

DEF INPUT PARAMETER pCustomer AS CHAR.                                     
DEF INPUT PARAMETER pArtCode AS CHAR.
DEF OUTPUT PARAMETER pMonVta AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pPrecioDescontado AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pUndVta AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

/* 30/11/2024: error el el API */
/*
pPrecioDescontado = 0.
RETURN 'OK'.
*/

/* */
DEFINE VAR x-Url AS LONGCHAR.
DEFINE VAR x-Xml AS LONGCHAR.
DEFINE VAR x-Texto AS CHAR.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = 'CONFIG-WEB-PRICING' NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla OR TRUE <> (VtaTabla.Libre_c01 > '') THEN DO:
    pMessage = "NO se encontró la configuración CONFIG-WEB-PRICING Libre_c01".
    RETURN "ADM-ERROR".
END.

/* Capturamos URL */
x-Url = TRIM(VtaTabla.Libre_c01).       /* URL http://192.168.100.221:9000 */

/* Llave de búsqueda */
x-Url = x-Url + '/sales/salespricelist/item/' + TRIM(pCustomer) + '/' +
    TRIM(pArtCode) + '/view'.

/* Capturamos el API */
/* Capturamos el API */
DEF VAR pResult AS CHAR NO-UNDO.
DEF VAR pResponse AS LONGCHAR NO-UNDO.
DEF VAR pContent AS LONGCHAR NO-UNDO.

RUN lib/http-get-contenido.r(x-Url,
                             OUTPUT pResult,
                             OUTPUT pResponse,
                             OUTPUT pContent) 
    NO-ERROR.

IF pResult <> "1:Success"  THEN DO:
    /* ERROR DETECTADO */
    CASE pResult:
        WHEN "0:Not Content" THEN DO:
            /* Si no tiene precio contrato se continúa con el proceso sin mostrar errores */
            pPrecioDescontado = 0.
            RETURN "OK".
        END.
        WHEN "0:No Socket" THEN DO:
            pMessage = "ERROR AL ENVIAR TRAMA : " + CHR(10) + x-Url.
        END.
        WHEN "0:Failure" THEN DO:
            pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (Servidor de aplicaciones detenido o no existe)" + CHR(10) +
                x-Url + CHR(10) + CHR(10) +
                "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
        END.
        OTHERWISE DO:
            pMessage = "ERROR API : " + CHR(10) + x-Url + "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
        END.
    END CASE.
    RETURN "ADM-ERROR".
END.

/* Respuesta del API */
x-Texto = TRIM(STRING(pContent)).

/* **************************************************************************************** */
/* Buscamos error */
/* Si no tiene precio entonces NO está definido en el contrato */
/* **************************************************************************************** */
IF x-Texto BEGINS "[]" THEN DO:
    pPrecioDescontado = 0.
    RETURN "OK".
END.

/* **************************************************************************************** */
/* Buscamos el precio contrato */
/* **************************************************************************************** */
DEF VAR x-PrecioDescontado AS CHAR NO-UNDO.
DEF VAR z AS INTE NO-UNDO.

/* 09/03/2024: Verificamos primero el "offerprice" */
z = INDEX(x-Texto, '"offerprice":') + LENGTH('"offerprice":').
DO WHILE TRUE:
    IF LOOKUP(SUBSTRING(x-Texto,z,1), ',|"|}|]', '|') > 0 THEN LEAVE.
    x-PrecioDescontado = x-PrecioDescontado + SUBSTRING(x-Texto,z,1).
    z = z + 1.
END.

IF TRIM(x-PrecioDescontado) = 'null' OR DECIMAL(x-PrecioDescontado) = 0.0 THEN DO:
    x-PrecioDescontado = ''.
    z = INDEX(x-Texto, '"price":') + LENGTH('"price":').
    DO WHILE TRUE:
        IF LOOKUP(SUBSTRING(x-Texto,z,1), ',|"|}|]', '|') > 0 THEN LEAVE.
        x-PrecioDescontado = x-PrecioDescontado + SUBSTRING(x-Texto,z,1).
        z = z + 1.
    END.
END.
ASSIGN
    pPrecioDescontado = DECIMAL(x-PrecioDescontado) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Precio Unitario Contrato no está en formato de números" + CHR(10) + x-texto.
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */
/* Buscamos la moneda de venta */
/* **************************************************************************************** */
/* 02/11/2023: B.Acuña moneda siempre en soles */
pMonVta = 1.

/* **************************************************************************************** */
/* Buscamos la unidad de venta */
/* **************************************************************************************** */
DEF VAR x-UndVta AS CHAR NO-UNDO.

z = INDEX(x-Texto, '"undvta":') + LENGTH('"undvta":').
DO WHILE TRUE:
    IF LOOKUP(SUBSTRING(x-Texto,z,1), ',|}|]', '|') > 0 THEN LEAVE.
    x-UndVta = x-UndVta + SUBSTRING(x-Texto,z,1).
    z = z + 1.
END.
pUndVta = TRIM(x-UndVta).
pUndVta = REPLACE(pUndVta, '"','').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-pricing-preuni-contrato-old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-preuni-contrato-old Procedure 
PROCEDURE web_api-pricing-preuni-contrato-old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* 
Sintaxis:
http://192.168.100.221:9000/sales/salespricelist/item/<cliente>/<artículo>/view

Resultado:         
[
    {
        "id": 4,
        "idcustomerriqra": null,
        "pricelistid": null,
        "custcode": "11111111111",
        "name": "0",
        "artcode": "084471",
        "factor": null,
        "price": 41.9169,
        "undvta": "UNI"
    }
]
*/
DEF INPUT PARAMETER pCustomer AS CHAR.                                     
DEF INPUT PARAMETER pArtCode AS CHAR.
DEF OUTPUT PARAMETER pMonVta AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pPrecioDescontado AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pUndVta AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

/* */
DEFINE VAR x-Url AS LONGCHAR.
DEFINE VAR x-Xml AS LONGCHAR.
DEFINE VAR x-Texto AS CHAR.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = 'CONFIG-WEB-PRICING' NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla OR TRUE <> (VtaTabla.Libre_c01 > '') THEN DO:
    pMessage = "NO se encontró la configuración CONFIG-WEB-PRICING Libre_c01".
    RETURN "ADM-ERROR".
END.

/* Capturamos URL */
x-Url = TRIM(VtaTabla.Libre_c01).       /* URL http://192.168.100.221:9000 */

/* Llave de búsqueda */
x-Url = x-Url + '/sales/salespricelist/item/' + TRIM(pCustomer) + '/' +
    TRIM(pArtCode) + '/view'.

/* Capturamos el API */
DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.

x-oXmlHttp:OPEN( "GET", x-Url, NO ). 
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
x-oXmlHttp:setOption( 2, 13056 ) .  
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (Servidor de aplicaciones detenido o no existe)" + CHR(10) +
        x-Url + CHR(10) + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, ERROR-STATUS:GET-MESSAGE(1)).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
IF x-oXmlHttp:STATUS <> 200 THEN DO:
    pMessage = "ERROR AL ENVIAR TRAMA : " + CHR(10) + x-oXmlHttp:responseText.
    RUN web_connection_log (x-Url, "ERROR AL ENVIAR TRAMA : " + x-oXmlHttp:responseText).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
/* Respuesta del API */
x-Xml = x-oXmlHttp:responseText.
x-Texto = TRIM(STRING(x-Xml)).

/* **************************************************************************************** */
/* Buscamos error */
/* Si no tiene precio entonces NO está definido en el contrato */
/* **************************************************************************************** */
IF x-Texto BEGINS "[]" THEN DO:
    pPrecioDescontado = 0.
    RETURN "OK".
END.
/*RUN lib/limpiar-texto-abc (x-Texto,'',OUTPUT x-Texto).*/

x-Texto = REPLACE(x-Texto,CHR(10),"").
x-Texto = REPLACE(x-Texto,"[","").
x-Texto = REPLACE(x-Texto,"]","").
IF x-Texto BEGINS "[]" THEN DO:
    pPrecioDescontado = 0.
    RETURN "OK".
END.
/*
RUN lib/limpiar-texto (x-texto, '', OUTPUT x-Texto).
MESSAGE x-texto.
*/

/* **************************************************************************************** */
/* Buscamos el precio contrato */
/* **************************************************************************************** */
DEF VAR x-PrecioDescontado AS CHAR NO-UNDO.
DEF VAR z AS INTE NO-UNDO.

z = INDEX(x-Texto, '"price":') + LENGTH('"price":').
DO WHILE TRUE:
    IF LOOKUP(SUBSTRING(x-Texto,z,1), ',|"|}|]', '|') > 0 THEN LEAVE.
    x-PrecioDescontado = x-PrecioDescontado + SUBSTRING(x-Texto,z,1).
    z = z + 1.
END.

pPrecioDescontado = DECIMAL(x-PrecioDescontado) NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    pMessage = "Precio Unitario Contrato no está en formato de números" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */
/* Buscamos la moneda de venta */
/* **************************************************************************************** */
/* DEF VAR x-MonVta AS CHAR NO-UNDO.                                                               */
/*                                                                                                 */
/* z = INDEX(x-Texto, '"currency":') + LENGTH('"currency":').                                      */
/* DO WHILE TRUE:                                                                                  */
/*     IF LOOKUP(SUBSTRING(x-Texto,z,1), ',|"|}|]', '|') > 0 THEN LEAVE.                           */
/*     x-MonVta = x-MonVta + SUBSTRING(x-Texto,z,1).                                               */
/*     z = z + 1.                                                                                  */
/* END.                                                                                            */
/*                                                                                                 */
/* pMonVta = INTEGER(x-MonVta) NO-ERROR.                                                           */
/* IF ERROR-STATUS:ERROR THEN DO:                                                                  */
/*     pMessage = "La Moneda de Venta Contrato no está en formato de números" + CHR(10) + x-texto. */
/*     RELEASE OBJECT x-oXmlHttp NO-ERROR.                                                         */
/*     RETURN "ADM-ERROR".                                                                         */
/* END.                                                                                            */

/* 02/11/2023: B.Acuña moneda siempre en soles */
pMonVta = 1.

/* **************************************************************************************** */
/* Buscamos la unidad de venta */
/* **************************************************************************************** */
DEF VAR x-UndVta AS CHAR NO-UNDO.

z = INDEX(x-Texto, '"undvta":') + LENGTH('"undvta":').
DO WHILE TRUE:
    IF LOOKUP(SUBSTRING(x-Texto,z,1), ',|}|]', '|') > 0 THEN LEAVE.
    x-UndVta = x-UndVta + SUBSTRING(x-Texto,z,1).
    z = z + 1.
END.
pUndVta = TRIM(x-UndVta).
pUndVta = REPLACE(pUndVta, '"','').

RELEASE OBJECT x-oXmlHttp NO-ERROR.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-pricing-preuni-contrato-socket) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-preuni-contrato-socket Procedure 
PROCEDURE web_api-pricing-preuni-contrato-socket :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 
Sintaxis:
http://192.168.100.221:9000/sales/salespricelist/item/<cliente>/<artículo>/view

Resultado:         
[
    {
        "id": 4,
        "idcustomerriqra": null,
        "pricelistid": null,
        "custcode": "11111111111",
        "name": "0",
        "artcode": "084471",
        "factor": null,
        "price": 41.9169,
        "undvta": "UNI"
    }
]
*/
DEF INPUT PARAMETER pCustomer AS CHAR.                                     
DEF INPUT PARAMETER pArtCode AS CHAR.
DEF OUTPUT PARAMETER pMonVta AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pPrecioDescontado AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pUndVta AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

/* */
DEFINE VAR x-Url AS LONGCHAR.
DEFINE VAR x-Xml AS LONGCHAR.
DEFINE VAR x-Texto AS CHAR.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = 'CONFIG-WEB-PRICING' NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla OR TRUE <> (VtaTabla.Libre_c01 > '') THEN DO:
    pMessage = "NO se encontró la configuración CONFIG-WEB-PRICING Libre_c01".
    RETURN "ADM-ERROR".
END.

/* Capturamos URL */
x-Url = TRIM(VtaTabla.Libre_c01).       /* URL http://192.168.100.221:9000 */

/* Llave de búsqueda */
x-Url = x-Url + '/sales/salespricelist/item/' + TRIM(pCustomer) + '/' +
    TRIM(pArtCode) + '/view'.

/* Capturamos el API */
DEF VAR x-Resultado AS CHAR NO-UNDO.
DEF VAR x-Respuesta AS LONGCHAR NO-UNDO.
DEF VAR x-Contenido AS LONGCHAR NO-UNDO.

RUN lib/http-get-contenido.p (INPUT x-Url,
                              OUTPUT x-Resultado,
                              OUTPUT x-Respuesta,
                              OUTPUT x-Contenido).      /* Respuesta del API */
/* Control de errores */
IF x-Resultado BEGINS "0:" THEN DO:
    pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (Servidor de aplicaciones detenido o no existe)" + CHR(10) +
        x-Url + CHR(10) + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, ERROR-STATUS:GET-MESSAGE(1)).
    RETURN 'ADM-ERROR'.
END.

/* Respuesta del API */
x-Xml = x-Contenido.
x-Texto = TRIM(STRING(x-Xml)).

/* **************************************************************************************** */
/* Buscamos error */
/* Si no tiene precio entonces NO está definido en el contrato */
/* **************************************************************************************** */
IF x-Texto BEGINS "[]" THEN DO:
    pPrecioDescontado = 0.
    RETURN "OK".
END.

x-Texto = REPLACE(x-Texto,CHR(10),"").
x-Texto = REPLACE(x-Texto,"[","").
x-Texto = REPLACE(x-Texto,"]","").
IF x-Texto BEGINS "[]" THEN DO:
    pPrecioDescontado = 0.
    RETURN "OK".
END.
/* **************************************************************************************** */
/* Buscamos el precio contrato */
/* **************************************************************************************** */
DEF VAR x-PrecioDescontado AS CHAR NO-UNDO.
DEF VAR z AS INTE NO-UNDO.

z = INDEX(x-Texto, '"price":') + LENGTH('"price":').
DO WHILE TRUE:
    IF LOOKUP(SUBSTRING(x-Texto,z,1), ',|"|}|]', '|') > 0 THEN LEAVE.
    x-PrecioDescontado = x-PrecioDescontado + SUBSTRING(x-Texto,z,1).
    z = z + 1.
END.

pPrecioDescontado = DECIMAL(x-PrecioDescontado) NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    pMessage = "Precio Unitario Contrato no está en formato de números" + CHR(10) + x-texto.
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */
/* Buscamos la moneda de venta */
/* **************************************************************************************** */
/* DEF VAR x-MonVta AS CHAR NO-UNDO.                                                               */
/*                                                                                                 */
/* z = INDEX(x-Texto, '"currency":') + LENGTH('"currency":').                                      */
/* DO WHILE TRUE:                                                                                  */
/*     IF LOOKUP(SUBSTRING(x-Texto,z,1), ',|"|}|]', '|') > 0 THEN LEAVE.                           */
/*     x-MonVta = x-MonVta + SUBSTRING(x-Texto,z,1).                                               */
/*     z = z + 1.                                                                                  */
/* END.                                                                                            */
/*                                                                                                 */
/* pMonVta = INTEGER(x-MonVta) NO-ERROR.                                                           */
/* IF ERROR-STATUS:ERROR THEN DO:                                                                  */
/*     pMessage = "La Moneda de Venta Contrato no está en formato de números" + CHR(10) + x-texto. */
/*     RELEASE OBJECT x-oXmlHttp NO-ERROR.                                                         */
/*     RETURN "ADM-ERROR".                                                                         */
/* END.                                                                                            */

/* 02/11/2023: B.Acuña moneda siempre en soles */
pMonVta = 1.
/* **************************************************************************************** */
/* Buscamos la unidad de venta */
/* **************************************************************************************** */
DEF VAR x-UndVta AS CHAR NO-UNDO.

z = INDEX(x-Texto, '"undvta":') + LENGTH('"undvta":').
DO WHILE TRUE:
    IF LOOKUP(SUBSTRING(x-Texto,z,1), ',|}|]', '|') > 0 THEN LEAVE.
    x-UndVta = x-UndVta + SUBSTRING(x-Texto,z,1).
    z = z + 1.
END.
pUndVta = TRIM(x-UndVta).
pUndVta = REPLACE(pUndVta, '"','').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-pricing-preuni-ctouni) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-preuni-ctouni Procedure 
PROCEDURE web_api-pricing-preuni-ctouni :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Sintaxis
http://192.168.0.237:62/api/storeprocedure/XML
/002056
/1
/C
/000
*/
DEF INPUT PARAMETER pArtCode AS CHAR.
DEF INPUT PARAMETER pSalesChannel AS CHAR.
DEF INPUT PARAMETER pCategoryCustomer AS CHAR.
DEF INPUT PARAMETER pSalesCondition AS CHAR.
DEF OUTPUT PARAMETER pMonVta AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pTpoCmb AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pPrecioDescontado AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pRepositionCostInCurrencySale AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

/* ******************************************************************************************* */
/* Valores por defecto */
/* ******************************************************************************************* */
IF TRUE <> (pSalesChannel > "") THEN pSalesChannel = "6".           /* Tiendas Mayoristas */
IF TRUE <> (pCategoryCustomer > "") THEN pCategoryCustomer = "C".   /* Por defecto */
IF TRUE <> (pSalesCondition > "") THEN pSalesCondition = "000".     /* Contado */  
/* ******************************************************************************************* */

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
/* Llave de búsqueda */
x-Url = x-Url + ~
'/' + pArtCode + ~
'/' + pSalesChannel + ~
'/' + pCategoryCustomer + ~
'/' + pSalesCondition.

/* Capturamos el API */
DEF VAR pResult AS CHAR NO-UNDO.
DEF VAR pResponse AS LONGCHAR NO-UNDO.
DEF VAR pContent AS LONGCHAR NO-UNDO.

RUN lib/http-get-contenido.r(x-Url,
                             OUTPUT pResult,
                             OUTPUT pResponse,
                             OUTPUT pContent) 
    NO-ERROR.

IF pResult <> "1:Success"  THEN DO:
    /* ERROR DETECTADO */
    CASE pResult:
        WHEN "0:Not Content" THEN DO:
            pMessage = "VALIDACION: Precio Peldaño Bruto NO disponible para la venta" + CHR(10) + 
                "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
                "NO disponible para la venta" + CHR(10) + 
                "Artículo: " + pArtCode + CHR(10) +
                "Peldaño: " + pSalesChannel + CHR(10) +
                "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
                "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
                "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
                "y de ser necesario se comunicará con sistemas".
        END.
        WHEN "0:No Socket" THEN DO:
            pMessage = "ERROR AL ENVIAR TRAMA : " + CHR(10) + x-Url.
        END.
        WHEN "0:Failure" THEN DO:
            pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (Servidor de aplicaciones detenido o no existe)" + CHR(10) +
                x-Url + CHR(10) + CHR(10) +
                "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
        END.
        OTHERWISE DO:
            pMessage = "ERROR API : " + CHR(10) + x-Url + "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
        END.
    END CASE.
    RETURN "ADM-ERROR".
END.

/* Respuesta del API */
x-Xml = pContent.
x-Texto = STRING(x-Xml).

/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

IF INDEX(x-Texto, '<error>') > 0 THEN DO:
    x-Cadena1 = "<error>".
    x-Cadena2 = "</error>".
    x-Inicio = INDEX(x-Texto, x-Cadena1).
    x-Fin = INDEX(x-Texto, x-Cadena2).
    x-Texto = "API no responde".
    IF x-Inicio > x-Fin THEN DO:
        pMessage = "VALIDACION: Precio Peldaño Bruto NO disponible para la venta" + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
            "y de ser necesario se comunicará con sistemas".
    END.
    ELSE DO:
        pMessage = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).
        pMessage = pMessage + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
            "y de ser necesario se comunicará con sistemas".
    END.
    RUN web_connection_log (x-Url, x-Texto).
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */

DEF VAR Inicio AS INT64 NO-UNDO.
DEF VAR Fin AS INT64 NO-UNDO.

/* Separamos la DATA */
x-Inicio = INDEX(x-Texto, "<Data>").
x-Fin = INDEX(x-Texto, "</Data>").

IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
    pMessage = "XML no retornó ninguna información" + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, "XML no retornó ninguna información").
    RETURN "ADM-ERROR".
END.

x-Texto = SUBSTRING(x-Texto, x-Inicio + 6, (x-Fin - x-Inicio - 6)).

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
IF pPrecioDescontado <= 0 THEN DO:
    pMessage = "Precio Peldaño Bruto está mal configurado" + CHR(10) + CHR(10) +     
        "Por favor consultar al Jefe de Línea". 
    RETURN 'ADM-ERROR'.
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
    pMessage = "Costo de Reposición: NO registrado en la lista de precios".
    RETURN "ADM-ERROR".
END.
x-CostoReposicion = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pRepositionCostInCurrencySale = DECIMAL(x-CostoReposicion) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Costo de Reposición no está en el formato correcto" + CHR(10) + x-texto.
    RETURN "ADM-ERROR".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-pricing-preuni-ctouni-old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-preuni-ctouni-old Procedure 
PROCEDURE web_api-pricing-preuni-ctouni-old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Sintaxis
http://192.168.0.237:62/api/storeprocedure/XML
/002056
/1
/C
/000
*/
DEF INPUT PARAMETER pArtCode AS CHAR.
DEF INPUT PARAMETER pSalesChannel AS CHAR.
DEF INPUT PARAMETER pCategoryCustomer AS CHAR.
DEF INPUT PARAMETER pSalesCondition AS CHAR.
DEF OUTPUT PARAMETER pMonVta AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pTpoCmb AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pPrecioDescontado AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pRepositionCostInCurrencySale AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

/* ******************************************************************************************* */
/* Valores por defecto */
/* ******************************************************************************************* */
IF TRUE <> (pSalesChannel > "") THEN pSalesChannel = "6".           /* Tiendas Mayoristas */
IF TRUE <> (pCategoryCustomer > "") THEN pCategoryCustomer = "C".   /* Por defecto */
IF TRUE <> (pSalesCondition > "") THEN pSalesCondition = "000".     /* Contado */  
/* ******************************************************************************************* */

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
/* Llave de búsqueda */
x-Url = x-Url + ~
'/' + pArtCode + ~
'/' + pSalesChannel + ~
'/' + pCategoryCustomer + ~
'/' + pSalesCondition.

/* DEF VAR x-editor AS CHAR VIEW-AS EDITOR SIZE 60 BY 6. */
/* x-editor = string(x-url).                             */
/* UPDATE x-editor.                                      */
/* RETURN.                                               */

/* Capturamos el API */
DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.

x-oXmlHttp:OPEN( "GET", x-Url, NO ). 
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
x-oXmlHttp:setOption( 2, 13056 ) .  
x-oXmlHttp:SEND() NO-ERROR.


IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (Servidor de aplicaciones detenido o no existe)" + CHR(10) +
        x-Url + CHR(10) + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, ERROR-STATUS:GET-MESSAGE(1)).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
IF x-oXmlHttp:STATUS <> 200 THEN DO:
    pMessage = "ERROR AL ENVIAR TRAMA : " + CHR(10) + x-oXmlHttp:responseText.
    RUN web_connection_log (x-Url, "ERROR AL ENVIAR TRAMA : " + x-oXmlHttp:responseText).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
/* Respuesta del API */
x-Xml = x-oXmlHttp:responseText.
x-Texto = STRING(x-Xml).
/*
MESSAGE string(x-Url) SKIP
        x-Texto.
*/
/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

IF INDEX(x-Texto, '<error>') > 0 THEN DO:
    x-Cadena1 = "<error>".
    x-Cadena2 = "</error>".
    x-Inicio = INDEX(x-Texto, x-Cadena1).
    x-Fin = INDEX(x-Texto, x-Cadena2).
    x-Texto = "API no responde".
    IF x-Inicio > x-Fin THEN DO:
        pMessage = "VALIDACION: Precio Peldaño Bruto NO disponible para la venta" + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
            "y de ser necesario se comunicará con sistemas".
    END.
    ELSE DO:
        pMessage = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).
        pMessage = pMessage + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
            "y de ser necesario se comunicará con sistemas".
    END.
    RUN web_connection_log (x-Url, x-Texto).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */

DEF VAR Inicio AS INT64 NO-UNDO.
DEF VAR Fin AS INT64 NO-UNDO.

/* Separamos la DATA */
x-Inicio = INDEX(x-Texto, "<Data>").
x-Fin = INDEX(x-Texto, "</Data>").

IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
    pMessage = "XML no retornó ninguna información" + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, "XML no retornó ninguna información").
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.

x-Texto = SUBSTRING(x-Texto, x-Inicio + 6, (x-Fin - x-Inicio - 6)).

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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-MonVta = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pMonVta = LOOKUP(x-MonVta, x-Monedas).
IF pMonVta = 0 THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Moneda de Venta no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-TpoCmb = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pTpoCmb = DECIMAL(x-TpoCmb) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Tipo de Cambio no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-PrecioDescontado = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pPrecioDescontado = DECIMAL(x-PrecioDescontado) NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    pMessage = "Precio Unitario Peldaño no está en formato de números" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
IF pPrecioDescontado <= 0 THEN DO:
    pMessage = "Precio Peldaño Bruto está mal configurado" + CHR(10) + CHR(10) +     
        "Por favor consultar al Jefe de Línea". 
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
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
    pMessage = "Costo de Reposición: NO registrado en la lista de precios".
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-CostoReposicion = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pRepositionCostInCurrencySale = DECIMAL(x-CostoReposicion) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Costo de Reposición no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.

RELEASE OBJECT x-oXmlHttp NO-ERROR.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-pricing-preuni-old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-preuni-old Procedure 
PROCEDURE web_api-pricing-preuni-old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Devuelve el precio unitario ya afectado por el descuento x clf y x cond vta
------------------------------------------------------------------------------*/
/* Sintaxis
http://192.168.0.237:62/api/storeprocedure/XML
/002056
/1
/C
/000
*/
DEF INPUT PARAMETER pArtCode AS CHAR.
DEF INPUT PARAMETER pSalesChannel AS CHAR.
DEF INPUT PARAMETER pCategoryCustomer AS CHAR.
DEF INPUT PARAMETER pSalesCondition AS CHAR.
DEF OUTPUT PARAMETER pMonVta AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pTpoCmb AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pPrecioDescontado AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

/*MESSAGE s-aplic-id s-prog-name.*/

/* */
/* IF s-user-id = 'ADMIN' THEN DO: */
/*     pMonVta = 1.                */
/*     ptpoCmb = 1.                */
/*     pPrecioDescontado = 91.35.  */
/*     RETURN 'OK'.                */
/* END.                            */
/* */
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
/* Llave de búsqueda */
x-Url = x-Url + ~
'/' + pArtCode + ~
'/' + pSalesChannel + ~
'/' + pCategoryCustomer + ~
'/' + pSalesCondition.

/* DEF VAR x-editor AS CHAR VIEW-AS EDITOR SIZE 60 BY 6. */
/* x-editor = string(x-url).                             */
/* UPDATE x-editor.                                      */
/* RETURN.                                               */

/* Capturamos el API */
DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.

RUN lib/p-write-log-txt.p("VENTAS-UTILEX","CODIGO:" + pArtCode + ' api precio - OPEN').
x-oXmlHttp:OPEN( "GET", x-Url, NO ). 
RUN lib/p-write-log-txt.p("VENTAS-UTILEX","CODIGO:" + pArtCode + ' api precio - setRequestHeader').
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
RUN lib/p-write-log-txt.p("VENTAS-UTILEX","CODIGO:" + pArtCode + ' api precio - setOption').
x-oXmlHttp:setOption( 2, 13056 ) .  
RUN lib/p-write-log-txt.p("VENTAS-UTILEX","CODIGO:" + pArtCode + ' api precio - SEND').
x-oXmlHttp:SEND() NO-ERROR.
RUN lib/p-write-log-txt.p("VENTAS-UTILEX","CODIGO:" + pArtCode + ' api precio - SEND-FIN').

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (Servidor de aplicaciones detenido o no existe)" + CHR(10) +
        x-Url + CHR(10) + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, ERROR-STATUS:GET-MESSAGE(1)).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
IF x-oXmlHttp:STATUS <> 200 THEN DO:
    pMessage = "ERROR AL ENVIAR TRAMA : " + CHR(10) + x-oXmlHttp:responseText.
    RUN web_connection_log (x-Url, "ERROR AL ENVIAR TRAMA : " + x-oXmlHttp:responseText).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
/* Respuesta del API */
x-Xml = x-oXmlHttp:responseText.
x-Texto = STRING(x-Xml).
/*
MESSAGE string(x-Url) SKIP
        x-Texto.
*/
/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

IF INDEX(x-Texto, '<error>') > 0 THEN DO:
    x-Cadena1 = "<error>".
    x-Cadena2 = "</error>".
    x-Inicio = INDEX(x-Texto, x-Cadena1).
    x-Fin = INDEX(x-Texto, x-Cadena2).
    x-Texto = "API no responde".
    IF x-Inicio > x-Fin THEN DO:
        pMessage = "VALIDACION: Precio Peldaño Bruto NO disponible para la venta" + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
            "y de ser necesario se comunicará con sistemas".
    END.
    ELSE DO:
        pMessage = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).
        pMessage = pMessage + CHR(10) + 
            "Porque NO está configurado el precio peldaño bruto" + CHR(10) + 
            "NO disponible para la venta" + CHR(10) + 
            "Artículo: " + pArtCode + CHR(10) +
            "Peldaño: " + pSalesChannel + CHR(10) +
            "Categoría del cliente: " + pCategoryCustomer + CHR(10) +
            "Condición de venta: " + pSalesCondition + CHR(10) + CHR(10) +
            "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
            "y de ser necesario se comunicará con sistemas".
    END.
    RUN web_connection_log (x-Url, x-Texto).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */

DEF VAR Inicio AS INT64 NO-UNDO.
DEF VAR Fin AS INT64 NO-UNDO.

/* Separamos la DATA */
x-Inicio = INDEX(x-Texto, "<Data>").
x-Fin = INDEX(x-Texto, "</Data>").

IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
    pMessage = "XML no retornó ninguna información" + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, "XML no retornó ninguna información").
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.

x-Texto = SUBSTRING(x-Texto, x-Inicio + 6, (x-Fin - x-Inicio - 6)).

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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-MonVta = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pMonVta = LOOKUP(x-MonVta, x-Monedas).
IF pMonVta = 0 THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Moneda de Venta no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-TpoCmb = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pTpoCmb = DECIMAL(x-TpoCmb) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMessage = "Artículo: " + pArtCode + CHR(10) +
                "Tipo de Cambio no está en el formato correcto" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
x-PrecioDescontado = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), (x-Fin - x-Inicio - LENGTH(x-Cadena1))).

pPrecioDescontado = DECIMAL(x-PrecioDescontado) NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    pMessage = "Precio Unitario Peldaño no está en formato de números" + CHR(10) + x-texto.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
IF pPrecioDescontado <= 0 THEN DO:
    pMessage = "Precio Peldaño Bruto está mal configurado" + CHR(10) + CHR(10) +     
        "Por favor consultar al Jefe de Línea". 
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
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

END.
ELSE DO:

END.

RELEASE OBJECT x-oXmlHttp NO-ERROR.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-riqra-import-horizontal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-riqra-import-horizontal Procedure 
PROCEDURE web_api-riqra-import-horizontal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Sintaxis
http://192.168.0.232:5000/synchronizefromsatellite/pedidossatelitehorizontal?codvendor=690
*/

DEF INPUT PARAMETER pCodVendedor AS CHAR.
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

/* */
DEFINE VAR x-Url AS LONGCHAR.
DEFINE VAR x-Xml AS LONGCHAR.
DEFINE VAR x-Texto AS CHAR.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = 'CONFIG-WEB-RIQRA-HORIZONTAL' 
    AND VtaTabla.Llave_c1 = 'PPX' NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla OR TRUE <> (VtaTabla.Libre_c01 > '') THEN DO:
    pMessage = "NO se encontró la configuración CONFIG-WEB-RIQRA PPX".
    RETURN "ADM-ERROR".
END.

/* Capturamos URL y TOKEN */
x-Url = TRIM(VtaTabla.Libre_c01).    /* URL */

/* Llave de búsqueda */
x-Url = x-Url + '?' + 'codvendor=' + pCodVendedor.
/*MESSAGE STRING(x-url).*/
/* Capturamos el API */

DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.

x-oXmlHttp:OPEN( "GET", x-Url, NO ). 
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
x-oXmlHttp:setOption( 2, 13056 ) .  
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (Servidor de aplicaciones detenido o no existe)" + CHR(10) +
        x-Url + CHR(10) + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, ERROR-STATUS:GET-MESSAGE(1)).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.

DEF VAR xyz AS LONGCHAR.
xyz = x-oXmlHttp:responseText.
/*
MESSAGE "xyz" SKIP 
     STRING(xyz).   
*/
IF x-oXmlHttp:STATUS <> 200 THEN DO:
    pMessage = "ERROR AL ENVIAR TRAMA : " + CHR(10) + x-oXmlHttp:responseText.
    RUN web_connection_log (x-Url, "ERROR AL ENVIAR TRAMA : " + x-oXmlHttp:responseText).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
/* Respuesta del API */
x-Xml = x-oXmlHttp:responseText.
x-Texto = STRING(x-Xml).

/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

IF INDEX(x-Texto, '<error>') > 0 THEN DO:
    x-Cadena1 = "<error>".
    x-Cadena2 = "</error>".
    x-Inicio = INDEX(x-Texto, x-Cadena1).
    x-Fin = INDEX(x-Texto, x-Cadena2).
    x-Texto = "API no responde (CONFIG-WEB-RIQRA-HORIZONTAL)".
    pMessage = x-Texto.
    RUN web_connection_log (x-Url, x-Texto).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */
RELEASE OBJECT x-oXmlHttp NO-ERROR.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-riqra-import-ppx) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-riqra-import-ppx Procedure 
PROCEDURE web_api-riqra-import-ppx :
/*------------------------------------------------------------------------------
  Purpose:     Importa la información de RIQRA y a PROGRESS PPX
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Sintaxis
http://192.168.0.232:5000/synchronizefromsatellite/pedidossateliteferias?codevento=<division>&codclie=<cliente>
*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCustomer AS CHAR.

DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

/* */
DEFINE VAR x-Url AS LONGCHAR.
DEFINE VAR x-Xml AS LONGCHAR.
DEFINE VAR x-Texto AS CHAR.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = 'CONFIG-WEB-RIQRA' 
    AND VtaTabla.Llave_c1 = 'PPX' NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla OR TRUE <> (VtaTabla.Libre_c01 > '') THEN DO:
    pMessage = "NO se encontró la configuración CONFIG-WEB-RIQRA PPX".
    RETURN "ADM-ERROR".
END.

/* Capturamos URL y TOKEN */
x-Url = TRIM(VtaTabla.Libre_c01).    /* URL */

/* Llave de búsqueda */
x-Url = x-Url + '?' + 'codevento=' + pCodDiv + '&' + 'codclie=' + pCustomer.
/*MESSAGE STRING(x-url).*/
/* Capturamos el API */
DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.

x-oXmlHttp:OPEN( "GET", x-Url, NO ). 
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
x-oXmlHttp:setOption( 2, 13056 ) .  
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (Servidor de aplicaciones detenido o no existe)" + CHR(10) +
        x-Url + CHR(10) + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, ERROR-STATUS:GET-MESSAGE(1)).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.

DEF VAR xyz AS LONGCHAR.
xyz = x-oXmlHttp:responseText.

IF x-oXmlHttp:STATUS <> 200 THEN DO:
    pMessage = "ERROR AL ENVIAR TRAMA : " + CHR(10) + x-oXmlHttp:responseText.
    RUN web_connection_log (x-Url, "ERROR AL ENVIAR TRAMA : " + x-oXmlHttp:responseText).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
/* Respuesta del API */
x-Xml = x-oXmlHttp:responseText.
x-Texto = STRING(x-Xml).

/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

IF INDEX(x-Texto, '<error>') > 0 THEN DO:
    x-Cadena1 = "<error>".
    x-Cadena2 = "</error>".
    x-Inicio = INDEX(x-Texto, x-Cadena1).
    x-Fin = INDEX(x-Texto, x-Cadena2).
    x-Texto = "API no responde (CONFIG-WEB-RIQRA)".
    pMessage = x-Texto.
    RUN web_connection_log (x-Url, x-Texto).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */
RELEASE OBJECT x-oXmlHttp NO-ERROR.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-riqra-stock-disponible) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-riqra-stock-disponible Procedure 
PROCEDURE web_api-riqra-stock-disponible :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Sintaxis
http://192.168.100.170:4500/api/stock-aviable?stockdepo=11&artcode=061112
*/

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCanDes AS DECI.

DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

/* */
DEFINE VAR x-Url AS LONGCHAR.
DEFINE VAR x-Xml AS LONGCHAR.
DEFINE VAR x-Texto AS CHAR.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = 'CONFIG-WEB-RIQRA-HORIZONTAL' 
    AND VtaTabla.Llave_c1 = 'STOCK-DISPONIBLE' NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla OR TRUE <> (VtaTabla.Libre_c01 > '') THEN DO:
    pMessage = "NO se encontró la configuración CONFIG-WEB-RIQRA-HORIZONTAL STOCK-DISPONIBLE".
    RETURN "ADM-ERROR".
END.

/* Capturamos URL y TOKEN */
x-Url = TRIM(VtaTabla.Libre_c01).    /* URL */

/* Llave de búsqueda */
x-Url = x-Url + '?' + 'stockdepo=' + pCodAlm + '&artcode=' + pCodMat + '&qty=' + STRING(pCanDes).
/*MESSAGE STRING(x-url).*/
/* Capturamos el API */

DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.

x-oXmlHttp:OPEN( "GET", x-Url, NO ). 
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
x-oXmlHttp:setOption( 2, 13056 ) .  
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones (Servidor de aplicaciones detenido o no existe)" + CHR(10) +
        x-Url + CHR(10) + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RUN web_connection_log (x-Url, ERROR-STATUS:GET-MESSAGE(1)).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.

DEF VAR xyz AS LONGCHAR.
xyz = x-oXmlHttp:responseText.
/*
MESSAGE "xyz" SKIP 
     STRING(xyz).   
*/
IF x-oXmlHttp:STATUS <> 200 THEN DO:
    pMessage = "ERROR AL ENVIAR TRAMA : " + CHR(10) + x-oXmlHttp:responseText.
    RUN web_connection_log (x-Url, "ERROR AL ENVIAR TRAMA : " + x-oXmlHttp:responseText).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
/* Respuesta del API */
x-Xml = x-oXmlHttp:responseText.
x-Texto = STRING(x-Xml).

/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

IF INDEX(x-Texto, '<error>') > 0 THEN DO:
    x-Cadena1 = "<error>".
    x-Cadena2 = "</error>".
    x-Inicio = INDEX(x-Texto, x-Cadena1).
    x-Fin = INDEX(x-Texto, x-Cadena2).
    x-Texto = "API no responde (CONFIG-WEB-RIQRA-HORIZONTAL)".
    pMessage = x-Texto.
    RUN web_connection_log (x-Url, x-Texto).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
/* **************************************************************************************** */
RELEASE OBJECT x-oXmlHttp NO-ERROR.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-satelite-vendedor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-satelite-vendedor Procedure 
PROCEDURE web_api-satelite-vendedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Sintaxis
http://192.168.0.232:5000/otherqueries/sellerriqra?code=690&idenviroment=15
*/
DEF INPUT PARAMETER pCodVen AS CHAR.
DEF INPUT PARAMETER pIdEnviroment AS CHAR.  /* 15 para Horizontal */
DEF OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

pMessage = "0".
RETURN.

/* */
DEFINE VAR x-Url AS LONGCHAR.
DEFINE VAR x-Xml AS LONGCHAR.
DEFINE VAR x-Texto AS CHAR.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = 'CONFIG-WEB-SATELITE' 
    AND VtaTabla.Llave_c1 = "VENDEDOR"
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    pMessage = "NO se encontró la configuración CONFIG-WEB-SATELITE VENDEDOR".
    RETURN "ADM-ERROR".
END.

/* Capturamos URL */
x-Url = TRIM(VtaTabla.Libre_c01).       /* URL */

/* Llave de búsqueda */
x-Url = x-Url + ~
    '?code=' + pCodVen +
    '&idenviroment=' + pIdEnviroment.

/* Capturamos el API */
DEF VAR pResult AS CHAR NO-UNDO.
DEF VAR pResponse AS LONGCHAR NO-UNDO.
DEF VAR pContent AS LONGCHAR NO-UNDO.

RUN lib/http-get-contenido.r(x-Url,
                             OUTPUT pResult,
                             OUTPUT pResponse,
                             OUTPUT pContent) 
    NO-ERROR.
IF TRIM(STRING(pContent)) = "[]"  THEN DO:     /* Devuelve una valor vacío */
    pMessage = "0".     /* NO registrado como vendedor SATELITE */
    RETURN.
END.

pMessage = "1".    /* Detectado como vendedor SATELITE */

/* **************************************************************************************** */
/* Buscamos error */
/* **************************************************************************************** */
DEF VAR x-Cadena1 AS CHAR NO-UNDO.
DEF VAR x-Cadena2 AS CHAR NO-UNDO.
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

DEF VAR Inicio AS INT64 NO-UNDO.
DEF VAR Fin AS INT64 NO-UNDO.

/* Separamos la DATA */
x-Cadena1 = '"status": '.
x-Texto = pContent.
x-Inicio = INDEX(x-Texto, x-Cadena1).

IF x-Inicio = 0 THEN DO:
    pMessage = "XML no retornó ninguna información" + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas".
    RETURN "ADM-ERROR".
END.
x-Fin = INDEX(x-Texto, ",", x-Inicio).
x-Cadena2 = SUBSTRING(x-Texto, x-Inicio + LENGTH(x-Cadena1), x-Fin - x-Inicio - LENGTH(x-Cadena1)).
pMessage = x-Cadena2.   /* Puede ser "1" o "0" */
/*
"1": Vendedor activo en Satélite
"0": Vendedor NO activo en Satélite 
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api-unit-cost-price) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-unit-cost-price Procedure 
PROCEDURE web_api-unit-cost-price :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Precio de Costo Unitario
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pcArtCode            AS CHAR.
DEF INPUT PARAMETER pcCategoryCustomer   AS CHAR.
DEF INPUT PARAMETER pcSalesCondition     AS CHAR.
DEF INPUT PARAMETER pcCustomer           AS CHAR.
DEF INPUT PARAMETER pcOffice             AS CHAR.
DEF OUTPUT PARAMETER pcReturn           AS LONGCHAR NO-UNDO.
DEF OUTPUT PARAMETER pcError            AS LONGCHAR NO-UNDO.

/* Sintaxis
http:http://192.168.100.223:7000/sales/salespricelist/price/sp
?ArtCode=200594[,200593[,200592[,...]]]
&CategoryCustomer=C[,C[,A[,...]]]
&SalesCondition=002[,002[,000[,...]]]
&Customer=20456127917
&Office=00038
*/

/* Sintaxis pcReturn
<cCodMat>:<cCodMon>:<fTpoCmb>:<fPreUni>:<fRepositionCostInCurrencySale>:<cContrato>[,...].
*/

/* */
DEFINE VAR x-Url AS LONGCHAR NO-UNDO.
DEFINE VAR x-Xml AS LONGCHAR NO-UNDO.
DEFINE VAR x-Texto AS CHAR NO-UNDO.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = 'CONFIG-WEB-PRICING' NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    pcError = "NO se encontró la configuración CONFIG-WEB-PRICING".
    RETURN.
END.

/* Capturamos URL y TOKEN */
x-Url = TRIM(VtaTabla.Llave_c6).    /* URL */
        
/* 1ro. Armamos la cadena de la URL */
DEF VAR iRegistro AS INTE NO-UNDO.

x-Url = x-Url + "?ArtCode=" + pcArtCode.

x-Url = x-Url + "&CategoryCustomer=" + pcCategoryCustomer.

x-Url = x-Url + "&SalesCondition=" + pcSalesCondition.

x-Url = x-Url + "&Customer=" + pcCustomer.
x-Url = x-Url + "&Office=" + pcOffice.

/* Capturamos el API */
DEF VAR pResult AS CHAR NO-UNDO.
DEF VAR pResponse AS LONGCHAR NO-UNDO.
DEF VAR pContent AS LONGCHAR CASE-SENSITIVE NO-UNDO.
DEF VAR cAbrirCorchete AS CHAR NO-UNDO.
DEF VAR cCerrarCorchete AS CHAR NO-UNDO.

cAbrirCorchete = CHR(123).
cCerrarCorchete = CHR(125).

RUN lib/http-get-contenido.r(x-Url,
                             OUTPUT pResult,
                             OUTPUT pResponse,
                             OUTPUT pContent) 
    NO-ERROR.
pContent = REPLACE(pContent, cAbrirCorchete, '[').
pContent = REPLACE(pContent, cCerrarCorchete, ']').
/* ****************** */
/* CONTROL DE ERRORES */
IF INDEX(pResult, '0:No Socket') > 0 THEN DO:
    pcError = "ERROR:" + CHR(10) + CHR(10) +
        "URL no existe: " + TRIM(VtaTabla.Llave_c6) + CHR(10) + CHR(10) +
        "Proceso abortado".
    RETURN.
END.
IF INDEX(pResult, '[]') > 0 THEN DO:
    pcError = "ERROR:" + CHR(10) + CHR(10) +
        "No hay información" + CHR(10) + CHR(10) +
        "Proceso abortado".
    RETURN.
END.
IF INDEX(pContent, '[]') > 0 THEN DO:
    pcError = "ERROR:" + CHR(10) + CHR(10) +
        "No hay información" + CHR(10) + CHR(10) +
        "Proceso abortado".
    RETURN.
END.
/* **************************** */
/* BARREMOS EL ARCHIVO DEVUELTO */
/* Buscamos el contenido "content": [ */
DEF VAR iInicio AS INTE NO-UNDO.
DEF VAR iFin AS INTE NO-UNDO.
DEF VAR iPosicion AS INTE NO-UNDO.

iInicio = INDEX(pContent,'"ArtCode":').

/* Barremos por cada artículo */
DEF VAR cCodMat AS CHAR NO-UNDO.
DEF VAR fFinalOfferPrice    AS DECI DECIMALS 4 NO-UNDO.
DEF VAR fSpecialPrice       AS DECI DECIMALS 4 NO-UNDO.
DEF VAR fRepositionCostInCurrencySale AS DECI DECIMALS 4 NO-UNDO.
DEF VAR cTexto AS CHAR NO-UNDO.
DEF VAR fPreUni AS DECI FORMAT '>>>,>>>,>>9.9999' DECIMALS 4 NO-UNDO.
DEF VAR cCodMon AS CHAR INIT "1" NO-UNDO.
DEF VAR fTpoCmb AS DECI NO-UNDO.
DEF VAR cContrato AS CHAR INIT "N" NO-UNDO.
DEF VAR iControl_1 AS INTE NO-UNDO.
DEF VAR iControl_2 AS INTE NO-UNDO.

/*000752,000753,...*/
/* Si se encuentra un error => Pasamos el siguiente artículo */
DO iRegistro = 1 TO NUM-ENTRIES(pcArtCode):
    iInicio = INDEX(pContent,'"ArtCode":').
    cCodMat = ENTRY(iRegistro,pcArtCode).
    cCodMat = '"' + TRIM(cCodMat) + '"'.
    /* ****************************************************************************** */
    /* Buscamos inicio */
    iPosicion = INDEX(pContent,cCodMat,iInicio).
    IF iPosicion <= 0 THEN DO:
        pcError = pcError + (IF TRUE <> (pcError > '') THEN '' ELSE CHR(10) ) + 
            "Artículo " + cCodMat + ": NO hay información".
        NEXT.
    END.
    iInicio = iPosicion.
    /* Buscamos final */
    REPEAT:
        iPosicion = iPosicion + 1.
        IF SUBSTRING(pContent,iPosicion,1) = "]" THEN LEAVE.
    END.
    iFin = iPosicion.
    /* ****************************************************************************** */
    /* ****************************************************************************** */
    /* Buscamos precio peldaño */
    cTexto = ''.
    iPosicion = INDEX(pContent,'"FinalOfferPrice":',iInicio).
    iPosicion = iPosicion + LENGTH('"FinalOfferPrice":') + 1.
    IF iPosicion<= 0 OR iPosicion > iFin THEN DO:
        pcError = pcError + (IF TRUE <> (pcError > '') THEN '' ELSE CHR(10) ) +
            "Artículo " + cCodMat + ": Precio de Venta NO registrado".
        NEXT.
    END.
    REPEAT:
        cTexto = cTexto + TRIM(SUBSTRING(pContent,iPosicion,1)).
        IF TRUE <> (SUBSTRING(pContent,iPosicion,1)  > '') OR TRIM(SUBSTRING(pContent,iPosicion,1)) = ']' THEN LEAVE.
        iPosicion = iPosicion + 1.
    END.
    fFinalOfferPrice = 0.
    ASSIGN fFinalOfferPrice = DECIMAL(cTexto) NO-ERROR.
    /* Buscamos precio contrato */
    cTexto = ''.
    iPosicion = INDEX(pContent,'"SpecialPrice":',iInicio).
    iPosicion = iPosicion + LENGTH('"SpecialPrice":') + 1.
    IF iPosicion > 0 AND iPosicion < iFin THEN DO:
        REPEAT:
            cTexto = cTexto + TRIM(SUBSTRING(pContent,iPosicion,1)).
            IF TRUE <> (SUBSTRING(pContent,iPosicion,1)  > '') OR TRIM(SUBSTRING(pContent,iPosicion,1)) = ']' THEN LEAVE.
            iPosicion = iPosicion + 1.
        END.
    END.
    fSpecialPrice = 0.
    ASSIGN fSpecialPrice = DECIMAL(cTexto) NO-ERROR.
    /* Buscamos moneda */
    iPosicion = INDEX(pContent, '"CurrencySale": "S/"', iInicio).
    IF iPosicion > 0 THEN cCodMon = "1". ELSE cCodMon = "2".
    /* Buscamos Tipo de Cambio */
    cTexto = "".
    iPosicion = INDEX(pContent,'"ExchangeRate":',iInicio).
    iPosicion = iPosicion + LENGTH('"ExchangeRate":') + 1.
    IF iPosicion <= 0 OR iPosicion > iFin THEN DO:
        pcError = pcError + (IF TRUE <> (pcError > '') THEN '' ELSE CHR(10) ) +
            "Artículo " + cCodMat + ": Tipo de Cambio NO registrado".
        NEXT.
    END.
    REPEAT:
        IF TRIM(SUBSTRING(pContent,iPosicion,1)) = "," THEN LEAVE.
        cTexto = cTexto + TRIM(SUBSTRING(pContent,iPosicion,1)).
        iPosicion = iPosicion + 1.
    END.
    fTpoCmb = 1.
    ASSIGN fTpoCmb = DECIMAL(cTexto) NO-ERROR.
    /* Contrato Y o N */
    IF fSpecialPrice > 0 THEN DO:
        cContrato = "Y".
        fPreUni = fSpecialPrice.
        cCodMon = "1".
    END.
    ELSE DO:
        cContrato = "N".
        fPreUni = fFinalOfferPrice.
    END.
    /* Buscamos precio costo (OJO >>> SIN IGV) */
    cTexto = ''.
    iPosicion = INDEX(pContent,'"RepositionCostInCurrencySale":',iInicio).
    iPosicion = iPosicion + LENGTH('"RepositionCostInCurrencySale":') + 1.
    IF iPosicion <= 0 OR iPosicion > iFin THEN DO:
        pcError = pcError + (IF TRUE <> (pcError > '') THEN '' ELSE CHR(10) ) +
            "Artículo " + cCodMat + ": Costo de Reposición NO registrado".
        NEXT.
    END.
    REPEAT:
        cTexto = cTexto + TRIM(SUBSTRING(pContent,iPosicion,1)).
        IF TRUE <> (SUBSTRING(pContent,iPosicion,1)  > '') OR TRIM(SUBSTRING(pContent,iPosicion,1)) = ',' THEN LEAVE.
        iPosicion = iPosicion + 1.
    END.
    fRepositionCostInCurrencySale = 0.
    ASSIGN fRepositionCostInCurrencySale = DECIMAL(cTexto) NO-ERROR.
    /* Armamos el texto a devolver */
    cCodMat = REPLACE(cCodMat,'"','').
    pcReturn = pcReturn + 
        (IF TRUE <> (pcReturn > '') THEN '' ELSE ',') +
        cCodMat + ':' + 
        TRIM(cCodMon) + ':' +
        TRIM(STRING(fTpoCmb)) + ':' +
        TRIM(STRING(fPreUni,'>>>,>>>,>>9.9999')) + ':' + 
        TRIM(STRING(fRepositionCostInCurrencySale,'>>>,>>>,>>9.9999')) + ':' + 
        cContrato.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api_unit_price) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api_unit_price Procedure 
PROCEDURE web_api_unit_price :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
        pcReturn: devuelve los artículos válidos
        pcError : devuleve los artículos con errores
------------------------------------------------------------------------------*/

/* Sintaxis
http:http://192.168.100.223:7000/sales/salespricelist/price/sp
?ArtCode=200594[,200593[,200592[,...]]]
&CategoryCustomer=C[,C[,A[,...]]]
&SalesCondition=002[,002[,000[,...]]]
&Customer=20456127917
&Office=00038
*/
/* Formato de Retorno:
    <cCodMat>:<fPreUni>:<cCodMon>:<fTpoCmb>:<pcListaCondiciones>:<pcListaClasificacion>:<cContrato>[,...]
*/

DEF INPUT PARAMETER pcListaArticulos        AS LONGCHAR NO-UNDO.
DEF INPUT PARAMETER pcListaClasificacion    AS LONGCHAR NO-UNDO.
DEF INPUT PARAMETER pcListaCondiciones      AS LONGCHAR NO-UNDO.
DEF INPUT PARAMETER pcCustomer AS CHAR NO-UNDO.
DEF INPUT PARAMETER pcOffice AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pcReturn AS LONGCHAR NO-UNDO.
DEF OUTPUT PARAMETER pcError AS LONGCHAR NO-UNDO.

/* */
DEFINE VAR x-Url AS LONGCHAR NO-UNDO.
DEFINE VAR x-Xml AS LONGCHAR NO-UNDO.
DEFINE VAR x-Texto AS CHAR NO-UNDO.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = 'CONFIG-WEB-PRICING' NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    pcError = "NO se encontró la configuración CONFIG-WEB-PRICING".
    RETURN.
END.

/* Capturamos URL y TOKEN */
x-Url = TRIM(VtaTabla.Llave_c6).    /* URL */
        
/* 1ro. Armamos la cadena de la URL */
DEF VAR iRegistro AS INTE NO-UNDO.

x-Url = x-Url + "?ArtCode=" + pcListaArticulos.

x-Url = x-Url + "&CategoryCustomer=" + pcListaClasificacion.

x-Url = x-Url + "&SalesCondition=" + pcListaCondiciones.

x-Url = x-Url + "&Customer=" + pcCustomer.
x-Url = x-Url + "&Office=" + pcOffice.

/* Capturamos el API */
DEF VAR pResult AS CHAR NO-UNDO.
DEF VAR pResponse AS LONGCHAR NO-UNDO.
DEF VAR pContent AS LONGCHAR CASE-SENSITIVE NO-UNDO.
DEF VAR cAbrirCorchete AS CHAR NO-UNDO.
DEF VAR cCerrarCorchete AS CHAR NO-UNDO.

cAbrirCorchete = CHR(123).
cCerrarCorchete = CHR(125).

/*MESSAGE 'URL:' STRING(x-Url).*/

RUN lib/http-get-contenido.r(x-Url,
                             OUTPUT pResult,
                             OUTPUT pResponse,
                             OUTPUT pContent) 
    NO-ERROR.
IF INDEX(pResult, '0:No Socket') > 0 THEN DO:
    pcError = "ERROR:" + CHR(10) + CHR(10) +
        "URL no existe: " + TRIM(VtaTabla.Llave_c6) + CHR(10) + CHR(10) +
        "Proceso abortado".
    RETURN.
END.
IF INDEX(pResult, '[]') > 0 THEN DO:
    pcError = "ERROR:" + CHR(10) + CHR(10) +
        "No encontró precio en el Pricing " + CHR(10) + 
        "Informar al Jefe de Línea " + CHR(10) +
        'Artículo: ' + STRING(pcListaArticulos) + CHR(10) +
        'Clasificación Cliente: ' + STRING(pcListaClasificacion) + CHR(10) +
        'Condición de Venta: ' + STRING(pcListaCondiciones) .
    RETURN.
END.

DEF VAR pContent2 AS LONGCHAR CASE-SENSITIVE NO-UNDO.

cAbrirCorchete = CHR(123).
cCerrarCorchete = CHR(125).

pContent2 = REPLACE(pContent, cAbrirCorchete, '[').
pContent2 = REPLACE(pContent, cCerrarCorchete, ']').

IF INDEX(pContent2, '[]') > 0 THEN DO:
    pcError = "ERROR:" + CHR(10) + CHR(10) +
        "No encontró precio en el Pricing " + CHR(10) + 
        "Informar al Jefe de Línea " + CHR(10) + 
        'Artículo: ' + STRING(pcListaArticulos) + CHR(10) +
        'Clasificación Cliente: ' + STRING(pcListaClasificacion) + CHR(10) +
        'Condición de Venta: ' + STRING(pcListaCondiciones) .
    RETURN.
END.

/* 04/02/2026: Nueva libreria que lee JSon's */
/* DEF VAR hJson AS HANDLE NO-UNDO.       */
/* RUN lib/json10.p PERSISTENT SET hJson. */

DEFINE VARIABLE miJson AS CHARACTER NO-UNDO.
DEFINE VARIABLE raiz AS INTEGER NO-UNDO.     
DEFINE VARIABLE arrayId AS INTEGER NO-UNDO.
DEFINE VARIABLE itemId AS INTEGER NO-UNDO.

/* Inicializamos variables */
RUN iniJson IN hJson (INPUT pContent).
/* Capturamos JSON */
raiz = DYNAMIC-FUNCTION("parseVal":U IN hJson, INPUT 0, INPUT "").
arrayId = raiz.

/* Total items en el arreglo */
DEFINE VARIABLE TotalItems AS INTE NO-UNDO.
TotalItems = DYNAMIC-FUNCTION("arrayCount":U IN hJson, INPUT arrayId).
/* Definimos variables a capturar */
DEF VAR cArtCode AS CHAR NO-UNDO.
DEF VAR cFinalOfferPrice AS CHAR NO-UNDO.
DEF VAR cSpecialPrice AS CHAR NO-UNDO.
DEF VAR cCurrencySale AS CHAR NO-UNDO.
DEF VAR cExchangeRate AS CHAR NO-UNDO.
/* Definimos variables para la devolución */
DEF VAR cCodMat AS CHAR NO-UNDO.
DEF VAR fPreUni AS DECI FORMAT '>>>,>>>,>>9.9999' DECIMALS 4 NO-UNDO.
DEF VAR cCodMon AS CHAR INIT "1" NO-UNDO.
DEF VAR fTpoCmb AS DECI NO-UNDO.
DEF VAR cContrato AS CHAR INIT "N" NO-UNDO.
DEF VAR fFinalOfferPrice    AS DECI DECIMALS 4 NO-UNDO.
DEF VAR fSpecialPrice       AS DECI DECIMALS 4 NO-UNDO.
/* Barremos todos los items */
DO iRegistro = 1 TO TotalItems:
    itemId = DYNAMIC-FUNCTION("getArrayItem" IN hJson, INPUT arrayId, INPUT iRegistro).
    IF itemId > 0 THEN DO:
        cArtCode            = DYNAMIC-FUNCTION("getVal" IN hJson, INPUT itemId,INPUT "ArtCode").
        cFinalOfferPrice    = DYNAMIC-FUNCTION("getVal" IN hJson, INPUT itemId,INPUT "FinalOfferPrice").
        cSpecialPrice       = DYNAMIC-FUNCTION("getVal" IN hJson, INPUT itemId,INPUT "SpecialPrice").
        cCurrencySale       = DYNAMIC-FUNCTION("getVal" IN hJson, INPUT itemId,INPUT "CurrencySale").
        cExchangeRate       = DYNAMIC-FUNCTION("getVal" IN hJson, INPUT itemId,INPUT "ExchangeRate").
        /* Acondicionamos valores */
        cCodMat = cArtCode.
        fFinalOfferPrice = 0.
        ASSIGN fFinalOfferPrice = DECIMAL(cFinalOfferPrice) NO-ERROR.
        fSpecialPrice = 0.
        ASSIGN fSpecialPrice = DECIMAL(cSpecialPrice) NO-ERROR.
        cCodMon = (IF cCurrencySale = "S/" THEN "1" ELSE "2").
        fTpoCmb = 1.
        ASSIGN fTpoCmb = DECIMAL(cExchangeRate) NO-ERROR.
        /* Contrato */
        IF fSpecialPrice > 0 THEN DO:
            cContrato = "Y".
            fPreUni = fSpecialPrice.
            cCodMon = "1".
        END.
        ELSE DO:
            cContrato = "N".
            fPreUni = fFinalOfferPrice.
        END.
        /* Armamos el texto a devolver */
        pcReturn = pcReturn + 
            (IF TRUE <> (pcReturn > '') THEN '' ELSE ',') +
            cCodMat + ':' + 
            TRIM(STRING(fPreUni,'>>>,>>>,>>9.9999')) + ':' + 
            cCodMon + ":" + 
            TRIM(STRING(fTpoCmb)) + ":" + 
            (IF NUM-ENTRIES(pcListaCondiciones) = 1 THEN pcListaCondiciones ELSE ENTRY(iRegistro, pcListaCondiciones)) + ":" +
            (IF NUM-ENTRIES(pcListaClasificacion) = 1 THEN pcListaClasificacion ELSE ENTRY(iRegistro, pcListaClasificacion)) + ":" +
            cContrato.
    END.
END.

/* DELETE PROCEDURE hJson. */
/* **************************************************************************** */
/* ********************

DEF VAR cAbrirCorchete AS CHAR NO-UNDO.
DEF VAR cCerrarCorchete AS CHAR NO-UNDO.

cAbrirCorchete = CHR(123).
cCerrarCorchete = CHR(125).

/*
MESSAGE 'URL:' STRING(pContent).
*/

pContent = REPLACE(pContent, cAbrirCorchete, '[').
pContent = REPLACE(pContent, cCerrarCorchete, ']').

/* ****************** */
/* CONTROL DE ERRORES */
IF INDEX(pResult, '0:No Socket') > 0 THEN DO:
    pcError = "ERROR:" + CHR(10) + CHR(10) +
        "URL no existe: " + TRIM(VtaTabla.Llave_c6) + CHR(10) + CHR(10) +
        "Proceso abortado".
    RETURN.
END.
IF INDEX(pResult, '[]') > 0 THEN DO:
    pcError = "ERROR:" + CHR(10) + CHR(10) +
        "No encontró precio en el Pricing " + CHR(10) + 
        "Informar al Jefe de Línea " + CHR(10) +
        'Artículo: ' + STRING(pcListaArticulos) + CHR(10) +
        'Clasificación Cliente: ' + STRING(pcListaClasificacion) + CHR(10) +
        'Condición de Venta: ' + STRING(pcListaCondiciones) .
    RETURN.
END.
IF INDEX(pContent, '[]') > 0 THEN DO:
    pcError = "ERROR:" + CHR(10) + CHR(10) +
        "No encontró precio en el Pricing " + CHR(10) + 
        "Informar al Jefe de Línea " + CHR(10) + 
        'Artículo: ' + STRING(pcListaArticulos) + CHR(10) +
        'Clasificación Cliente: ' + STRING(pcListaClasificacion) + CHR(10) +
        'Condición de Venta: ' + STRING(pcListaCondiciones) .
    RETURN.
END.
/* **************************** */
/* BARREMOS EL ARCHIVO DEVUELTO */
/* Buscamos el contenido "content": [ */
DEF VAR iInicio AS INTE NO-UNDO.
DEF VAR iFin AS INTE NO-UNDO.
DEF VAR iPosicion AS INTE NO-UNDO.

iInicio = INDEX(pContent,'"ArtCode":').

/* Barremos por cada artículo */
DEF VAR cCodMat AS CHAR NO-UNDO.
DEF VAR fFinalOfferPrice    AS DECI DECIMALS 4 NO-UNDO.
DEF VAR fSpecialPrice       AS DECI DECIMALS 4 NO-UNDO.
DEF VAR cTexto AS CHAR NO-UNDO.
DEF VAR fPreUni AS DECI FORMAT '>>>,>>>,>>9.9999' DECIMALS 4 NO-UNDO.
DEF VAR cCodMon AS CHAR INIT "1" NO-UNDO.
DEF VAR fTpoCmb AS DECI NO-UNDO.
DEF VAR cContrato AS CHAR INIT "N" NO-UNDO.
DEF VAR iControl_1 AS INTE NO-UNDO.
DEF VAR iControl_2 AS INTE NO-UNDO.

/*000752,000753,...*/
/* Si se encuentra un error => Pasamos el siguiente artículo */
/*MESSAGE 'Lista:' STRING(pcListaArticulos) SKIP 'Contenido:' STRING(pContent).*/
DO iRegistro = 1 TO NUM-ENTRIES(pcListaArticulos):

    iInicio = INDEX(pContent,'"ArtCode":').

    cCodMat = ENTRY(iRegistro,pcListaArticulos).
    cCodMat = '"' + TRIM(cCodMat) + '"'.
    /* ****************************************************************************** */
    /* Buscamos inicio */
    iPosicion = INDEX(pContent,cCodMat,iInicio).
    IF iPosicion <= 0 THEN DO:
        pcError = pcError + (IF TRUE <> (pcError > '') THEN '' ELSE CHR(10) ) + 
            "Artículo " + cCodMat + ": NO hay información".
        NEXT.
    END.
    iInicio = iPosicion.
    /* Buscamos final */
    REPEAT:
        iPosicion = iPosicion + 1.
        IF SUBSTRING(pContent,iPosicion,1) = "]" THEN LEAVE.
    END.
    iFin = iPosicion.
    /* ****************************************************************************** */
    /* ****************************************************************************** */
    /* Buscamos precio peldaño */
    cTexto = ''.
    iPosicion = INDEX(pContent,'"FinalOfferPrice":',iInicio).
    iPosicion = iPosicion + LENGTH('"FinalOfferPrice":') + 1.
    IF iPosicion<= 0 OR iPosicion > iFin THEN DO:
        pcError = pcError + (IF TRUE <> (pcError > '') THEN '' ELSE CHR(10) ) +
            "Artículo " + cCodMat + ": Precio de Venta NO registrado".
        NEXT.
    END.
    REPEAT:
        cTexto = cTexto + TRIM(SUBSTRING(pContent,iPosicion,1)).
        IF TRUE <> (SUBSTRING(pContent,iPosicion,1)  > '') OR TRIM(SUBSTRING(pContent,iPosicion,1)) = ']' THEN LEAVE.
        iPosicion = iPosicion + 1.
    END.
    fFinalOfferPrice = 0.
    ASSIGN fFinalOfferPrice = DECIMAL(cTexto) NO-ERROR.
    /* Buscamos precio contrato */
    cTexto = ''.
    iPosicion = INDEX(pContent,'"SpecialPrice":',iInicio).
    iPosicion = iPosicion + LENGTH('"SpecialPrice":') + 1.
    IF iPosicion > 0 AND iPosicion < iFin THEN DO:
        REPEAT:
            cTexto = cTexto + TRIM(SUBSTRING(pContent,iPosicion,1)).
            IF TRUE <> (SUBSTRING(pContent,iPosicion,1)  > '') OR TRIM(SUBSTRING(pContent,iPosicion,1)) = ']' THEN LEAVE.
            iPosicion = iPosicion + 1.
        END.
    END.
    fSpecialPrice = 0.
    ASSIGN fSpecialPrice = DECIMAL(cTexto) NO-ERROR.
    /* Buscamos moneda */
    iPosicion = INDEX(pContent, '"CurrencySale": "S/"', iInicio).
    IF iPosicion > 0 AND iPosicion < iFin THEN cCodMon = "1". ELSE cCodMon = "2".
    /* Buscamos Tipo de Cambio */
    cTexto = "".
    iPosicion = INDEX(pContent,'"ExchangeRate":',iInicio).
    iPosicion = iPosicion + LENGTH('"ExchangeRate":') + 1.
    IF iPosicion <= 0 OR iPosicion > iFin THEN DO:
        pcError = pcError + (IF TRUE <> (pcError > '') THEN '' ELSE CHR(10) ) +
            "Artículo " + cCodMat + ": Tipo de Cambio NO registrado".
        NEXT.
    END.
    REPEAT:
        IF TRIM(SUBSTRING(pContent,iPosicion,1)) = "," THEN LEAVE.
        cTexto = cTexto + TRIM(SUBSTRING(pContent,iPosicion,1)).
        iPosicion = iPosicion + 1.
    END.
    fTpoCmb = 1.
    ASSIGN fTpoCmb = DECIMAL(cTexto) NO-ERROR.
    /* Contrato */
    IF fSpecialPrice > 0 THEN DO:
        cContrato = "Y".
        fPreUni = fSpecialPrice.
        cCodMon = "1".
    END.
    ELSE DO:
        cContrato = "N".
        fPreUni = fFinalOfferPrice.
    END.

    /* Armamos el texto a devolver */
    cCodMat = REPLACE(cCodMat,'"','').
    pcReturn = pcReturn + 
        (IF TRUE <> (pcReturn > '') THEN '' ELSE ',') +
        cCodMat + ':' + 
        TRIM(STRING(fPreUni,'>>>,>>>,>>9.9999')) + ':' + 
        cCodMon + ":" + 
        TRIM(STRING(fTpoCmb)) + ":" + 
        (IF NUM-ENTRIES(pcListaCondiciones) = 1 THEN pcListaCondiciones ELSE ENTRY(iRegistro, pcListaCondiciones)) + ":" +
        (IF NUM-ENTRIES(pcListaClasificacion) = 1 THEN pcListaClasificacion ELSE ENTRY(iRegistro, pcListaClasificacion)) + ":" +
        cContrato.
END.
******************** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api_unit_price_manager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api_unit_price_manager Procedure 
PROCEDURE web_api_unit_price_manager :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
        pcReturn: devuelve los artículos válidos
        pcError : devuleve los artículos con errores
------------------------------------------------------------------------------*/
/* Fecha: 15/10/2025
*/
DEF INPUT PARAMETER pcCodCli AS CHAR.
DEF INPUT PARAMETER pcCodDiv AS CHAR.
DEF INPUT PARAMETER pcCodMat AS LONGCHAR.
DEF INPUT PARAMETER pcClfCli AS LONGCHAR.
DEF INPUT PARAMETER pcFmaPgo AS LONGCHAR.
DEF OUTPUT PARAMETER pcReturn AS LONGCHAR NO-UNDO.
DEF OUTPUT PARAMETER pcError AS LONGCHAR NO-UNDO.

/* 
Formato de pcCodMat 
    Puede ser 1 o más artículos
000752[,000753[:...]]
<CodMat>[,...[,....]]

Formato de pcClfCli
    Puede ser 1 o más artículos
    Si se envía más de 1 debe corresponder 1 por cada artículo
C[,A[,...]]
<ClfCli>[,...[,....]]

Formato de pcFmaPgo: 
    Si se envía solo 1 es por defecto para todos los artículos
    Si se envía más de 1 debe corresponder 1 por cada artículo
000[,001[,...]]
<FmaPgo>[,...]
*/

/* Formato de pcReturn
000752:13.3572:2:3.55:002:C:N
<CodMat>:<PreUni>:<CodMon>:<TpoCmb>:<FmaPgo>:<ClfCli>:<Contrato>
*/

DEF VAR iItem       AS INTE NO-UNDO.
DEF VAR cCodMat     AS CHAR NO-UNDO.
DEF VAR cClfCli     AS CHAR INIT "C" NO-UNDO.
DEF VAR cFmaPgo     AS CHAR INIT "000" NO-UNDO.
DEF VAR cDesMat     AS CHAR NO-UNDO.
DEF VAR dFecha      AS DATETIME NO-UNDO.
DEF VAR fPreUni     AS DECI NO-UNDO.
DEF VAR lDatos_del_API AS LOG NO-UNDO.
DEF VAR cMensaje    AS CHAR NO-UNDO.
DEF VAR cContrato   AS CHAR INIT "N" NO-UNDO.
DEF VAR iCodMon     AS INTE INIT 1 NO-UNDO.     /* 1: Soles    2: Dólares */
DEF VAR fTpoCmb    AS DECI INIT 1 NO-UNDO.

DEF VAR s-codcia AS INTE INIT 000 NO-UNDO.      /* OJO: Con esto lo separamos de otros logs */

/* NOTA: 
        Se va a dar prioridad a buscar los precios en el buffer,
        pero si no lo consigue entonces se envía una cadena de artículos
        al API
*/        
DEF VAR cListaArticulos     AS LONGCHAR NO-UNDO.
DEF VAR cListaClasificacion AS LONGCHAR NO-UNDO.
DEF VAR cListaCondiciones   AS LONGCHAR NO-UNDO.

DO iItem = 1 TO NUM-ENTRIES(pcCodMat):
    cCodMat = ENTRY(iItem,pcCodMat).
    IF NUM-ENTRIES(pcClfCli) = 1 THEN cClfCli = pcClfCli. ELSE cClfCli = ENTRY(iItem,pcClfCli).
    IF NUM-ENTRIES(pcFmaPgo) = 1 THEN cFmaPgo = pcFmaPgo. ELSE cFmaPgo = ENTRY(iItem,pcFmaPgo).

    cDesMat = pcCodCli + ":" + pcCodDiv + ":" + pcFmaPgo + ":" + cClfCli.

    /* 4.- Datos del API */
    cListaArticulos = cListaArticulos +
                (IF TRUE <> (cListaArticulos > '') THEN '' ELSE ',') +
                ENTRY(iItem,pcCodMat).
    IF NUM-ENTRIES(pcClfCli) = 1 THEN cListaClasificacion = pcClfCli.
    ELSE DO:
        cListaClasificacion = cListaClasificacion + 
            (IF TRUE <> (cListaClasificacion > '') THEN '' ELSE ',') +
            ENTRY(iItem,pcClfCli).
    END.
    IF NUM-ENTRIES(pcFmaPgo) = 1 THEN cListaCondiciones = pcFmaPgo.
    ELSE DO:
        cListaCondiciones = cListaCondiciones +
            (IF TRUE <> (cListaCondiciones > '') THEN '' ELSE ',') +
            ENTRY(iItem,pcFmaPgo).
    END.
    lDatos_del_API = YES.

END.

/* Ahora calculamos los precios del API */
DEF VAR xListaArticulos AS LONGCHAR NO-UNDO.
DEF VAR xListaClasificacion AS LONGCHAR NO-UNDO.
DEF VAR xListaCondiciones AS LONGCHAR NO-UNDO.
DEF VAR xItem AS INTE NO-UNDO.

DEF VAR xReturn AS LONGCHAR NO-UNDO.
DEF VAR xError  AS LONGCHAR NO-UNDO.

ASSIGN
    xItem = 0
    xListaArticulos = ""
    xListaClasificacion = ""
    xListaCondiciones = ""
    .
DEF VAR iLimiteEnvio AS INTE INIT 5 NO-UNDO.        /* <<<<<<<<<<<< OJO <<<<<<<<<<<<<< */

IF cListaArticulos > '' THEN DO:
    /* Limitamos la cadena a 20 registros por vez */
    DO WHILE xItem < NUM-ENTRIES(cListaArticulos):
        REPEAT:
            xItem = xItem + 1.
            xListaArticulos = xListaArticulos +
                (IF TRUE <> (xListaArticulos > '') THEN '' ELSE ',') +
                ENTRY(xItem,cListaArticulos).
            xListaClasificacion = xListaClasificacion +
                (IF TRUE <> (xListaClasificacion > '') THEN '' ELSE ',') +
                ENTRY(xItem,cListaClasificacion).
            xListaCondiciones = xListaCondiciones +
                (IF TRUE <> (xListaCondiciones > '') THEN '' ELSE ',') +
                ENTRY(xItem,cListaCondiciones).
            IF (xItem + 1) > NUM-ENTRIES(cListaArticulos) THEN LEAVE.
            IF xItem MODULO iLimiteEnvio = 0 THEN LEAVE.
        END.
        RUN web_api_unit_price (INPUT xListaArticulos,
                                INPUT xListaClasificacion,
                                INPUT xListaCondiciones,
                                INPUT pcCodCli,
                                INPUT pcCodDiv,
                                OUTPUT xReturn,
                                OUTPUT xError
                                ).
/*         IF INDEX(xListaArticulos,'045575') > 0 THEN */
/*             MESSAGE PCCODDIV SKIP STRING(xReturn).  */
        /* Decisión:
            Si viene un xError grave => Paramos el proceso
            En caso contrario guardamos el error y continuamos con los otros 20 artículos 
        */
        pcError = pcError + (IF TRUE <> (pcReturn > '') THEN '' ELSE CHR(10)) + xError.
        pcReturn = pcReturn + (IF TRUE <> (pcReturn > '') THEN '' ELSE ',') + xReturn.
        /* *************************************************** */
        /* ERROR GRAVE */
        IF xError > '' AND TRUE <> (xReturn > '') THEN RETURN.
        /* *************************************************** */

        /* Formato de pcOutput
        000752:13.3572:2:3.55:002:C:N
        <CodMat>:<PreUni>:<CodMon>:<TpoCmb>:<FmaPgo>:<ClfCli>:<Contrato>
        */

        xListaArticulos = ''.
        xListaClasificacion = ''.
        xListaCondiciones = ''.
    END.
END.
/*MESSAGE STRING(pcReturn).*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_api_unit_price_manager_old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api_unit_price_manager_old Procedure 
PROCEDURE web_api_unit_price_manager_old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
        pcReturn: devuelve los artículos válidos
        pcError : devuleve los artículos con errores
------------------------------------------------------------------------------*/
/* Fecha: 15/10/2025
*/
DEF INPUT PARAMETER pcCodCli AS CHAR.
DEF INPUT PARAMETER pcCodDiv AS CHAR.
DEF INPUT PARAMETER pcCodMat AS LONGCHAR.
DEF INPUT PARAMETER pcClfCli AS LONGCHAR.
DEF INPUT PARAMETER pcFmaPgo AS LONGCHAR.
DEF OUTPUT PARAMETER pcReturn AS LONGCHAR NO-UNDO.
DEF OUTPUT PARAMETER pcError AS LONGCHAR NO-UNDO.

/* 
Formato de pcCodMat 
    Puede ser 1 o más artículos
000752[,000753[:...]]
<CodMat>[,...[,....]]

Formato de pcClfCli
    Puede ser 1 o más artículos
    Si se envía más de 1 debe corresponder 1 por cada artículo
C[,A[,...]]
<ClfCli>[,...[,....]]

Formato de pcFmaPgo: 
    Si se envía solo 1 es por defecto para todos los artículos
    Si se envía más de 1 debe corresponder 1 por cada artículo
000[,001[,...]]
<FmaPgo>[,...]
*/

/* Formato de pcReturn
000752:13.3572:2:3.55:002:C:N
<CodMat>:<PreUni>:<CodMon>:<TpoCmb>:<FmaPgo>:<ClfCli>:<Contrato>
*/

DEF VAR iItem       AS INTE NO-UNDO.
DEF VAR cCodMat     AS CHAR NO-UNDO.
DEF VAR cClfCli     AS CHAR INIT "C" NO-UNDO.
DEF VAR cFmaPgo     AS CHAR INIT "000" NO-UNDO.
DEF VAR cDesMat     AS CHAR NO-UNDO.
DEF VAR dFecha      AS DATETIME NO-UNDO.
DEF VAR fPreUni     AS DECI NO-UNDO.
DEF VAR lDatos_del_API AS LOG NO-UNDO.
DEF VAR cMensaje    AS CHAR NO-UNDO.
DEF VAR cContrato   AS CHAR INIT "N" NO-UNDO.
DEF VAR iCodMon     AS INTE INIT 1 NO-UNDO.     /* 1: Soles    2: Dólares */
DEF VAR fTpoCmb    AS DECI INIT 1 NO-UNDO.

DEF VAR s-codcia AS INTE INIT 000 NO-UNDO.      /* OJO: Con esto lo separamos de otros logs */

/* NOTA: 
        Se va a dar prioridad a buscar los precios en el buffer,
        pero si no lo consigue entonces se envía una cadena de artículos
        al API
*/        
DEF VAR cListaArticulos     AS LONGCHAR NO-UNDO.
DEF VAR cListaClasificacion AS LONGCHAR NO-UNDO.
DEF VAR cListaCondiciones   AS LONGCHAR NO-UNDO.

DO iItem = 1 TO NUM-ENTRIES(pcCodMat):
    cCodMat = ENTRY(iItem,pcCodMat).
    IF NUM-ENTRIES(pcClfCli) = 1 THEN cClfCli = pcClfCli. ELSE cClfCli = ENTRY(iItem,pcClfCli).
    IF NUM-ENTRIES(pcFmaPgo) = 1 THEN cFmaPgo = pcFmaPgo. ELSE cFmaPgo = ENTRY(iItem,pcFmaPgo).

    cDesMat = pcCodCli + ":" + pcCodDiv + ":" + pcFmaPgo + ":" + cClfCli.

    /* 4.- Datos del API */
    cListaArticulos = cListaArticulos +
                (IF TRUE <> (cListaArticulos > '') THEN '' ELSE ',') +
                ENTRY(iItem,pcCodMat).
    IF NUM-ENTRIES(pcClfCli) = 1 THEN cListaClasificacion = pcClfCli.
    ELSE DO:
        cListaClasificacion = cListaClasificacion + 
            (IF TRUE <> (cListaClasificacion > '') THEN '' ELSE ',') +
            ENTRY(iItem,pcClfCli).
    END.
    IF NUM-ENTRIES(pcFmaPgo) = 1 THEN cListaCondiciones = pcFmaPgo.
    ELSE DO:
        cListaCondiciones = cListaCondiciones +
            (IF TRUE <> (cListaCondiciones > '') THEN '' ELSE ',') +
            ENTRY(iItem,pcFmaPgo).
    END.
    lDatos_del_API = YES.

/* LO VAMOS A BLOQUEAR POR AHORA
    /* 1.- Buscamos la información en el buffer */
    FIND FIRST LogListaMinGn USE-INDEX Idx01 WHERE LogListaMinGn.CodCia = s-codcia
        AND LogListaMinGn.codmat = cCodMat
        AND LogListaMinGn.DesMat BEGINS cDesMat
        NO-LOCK NO-ERROR.
    CASE TRUE:
        WHEN AVAILABLE LogListaMinGn THEN DO:
            /* 2.- Veamos si está dentro del tiempo */
            dFecha = DATETIME(
                STRING(
                    REPLACE( STRING(LogListaMinGn.LogDate,'99/99/9999'),'/','-')
                    ) + " " + LogListaMinGn.LogTime
                ).
            IF INTERVAL(NOW,dFecha,'minutes') <= 1 THEN DO:
                /* 3.- Datos del buffer */
                pcReturn = pcReturn +
                            (IF TRUE <> (pcReturn > '') THEN '' ELSE ',') +
                                cCodMat + ":" + 
                                STRING(LogListaMinGn.PreOfi) + ":" +
                                STRING(LogListaMinGn.MonVta,'9') + ":" +
                                STRING(LogListaMinGn.TpoCmb) + ":" +
                                ENTRY(3,LogListaMinGn.DesMat,':') + ":" +
                                ENTRY(4,LogListaMinGn.DesMat,':') + ":" +
                                ENTRY(5,LogListaMinGn.DesMat,':')
                    .
                                
            END.
            ELSE DO:
                /* 4.- Datos del API */
                cListaArticulos = cListaArticulos +
                            (IF TRUE <> (cListaArticulos > '') THEN '' ELSE ',') +
                            ENTRY(iItem,pcCodMat).
                IF NUM-ENTRIES(pcClfCli) = 1 THEN cListaClasificacion = pcClfCli.
                ELSE DO:
                    cListaClasificacion = cListaClasificacion + 
                        (IF TRUE <> (cListaClasificacion > '') THEN '' ELSE ',') +
                        ENTRY(iItem,pcClfCli).
                END.
                IF NUM-ENTRIES(pcFmaPgo) = 1 THEN cListaCondiciones = pcFmaPgo.
                ELSE DO:
                    cListaCondiciones = cListaCondiciones +
                        (IF TRUE <> (cListaCondiciones > '') THEN '' ELSE ',') +
                        ENTRY(iItem,pcFmaPgo).
                END.
                lDatos_del_API = YES.
            END.
        END.
        OTHERWISE DO:
            /* 5.- Datos del API */
            cListaArticulos = cListaArticulos +
                        (IF TRUE <> (cListaArticulos > '') THEN '' ELSE ',') +
                        ENTRY(iItem,pcCodMat).
            IF NUM-ENTRIES(pcClfCli) = 1 THEN cListaClasificacion = pcClfCli.
            ELSE DO:
                cListaClasificacion = cListaClasificacion + 
                    (IF TRUE <> (cListaClasificacion > '') THEN '' ELSE ',') +
                    ENTRY(iItem,pcClfCli).
            END.
            IF NUM-ENTRIES(pcFmaPgo) = 1 THEN cListaCondiciones = pcFmaPgo.
            ELSE DO:
                cListaCondiciones = cListaCondiciones +
                    (IF TRUE <> (cListaCondiciones > '') THEN '' ELSE ',') +
                    ENTRY(iItem,pcFmaPgo).
            END.
            lDatos_del_API = YES.
        END.
    END CASE.
*/    
END.

/* Ahora calculamos los precios del API */
DEF VAR xListaArticulos AS LONGCHAR NO-UNDO.
DEF VAR xListaClasificacion AS LONGCHAR NO-UNDO.
DEF VAR xListaCondiciones AS LONGCHAR NO-UNDO.
DEF VAR xItem AS INTE NO-UNDO.

DEF VAR pcOutput AS LONGCHAR NO-UNDO.
ASSIGN
    xItem = 0
    xListaArticulos = ""
    xListaClasificacion = ""
    xListaCondiciones = ""
    .
DEF VAR iLimiteEnvio AS INTE INIT 10 NO-UNDO.

IF cListaArticulos > '' THEN DO:
    /* Limitamos la cadena a 20 registros por vez */
    DO WHILE xItem < NUM-ENTRIES(cListaArticulos):
        REPEAT:
            xItem = xItem + 1.
            xListaArticulos = xListaArticulos +
                (IF TRUE <> (xListaArticulos > '') THEN '' ELSE ',') +
                ENTRY(xItem,cListaArticulos).
            xListaClasificacion = xListaClasificacion +
                (IF TRUE <> (xListaClasificacion > '') THEN '' ELSE ',') +
                ENTRY(xItem,cListaClasificacion).
            xListaCondiciones = xListaCondiciones +
                (IF TRUE <> (xListaCondiciones > '') THEN '' ELSE ',') +
                ENTRY(xItem,cListaCondiciones).
            IF (xItem + 1) > NUM-ENTRIES(cListaArticulos) THEN LEAVE.
            IF xItem MODULO iLimiteEnvio = 0 THEN LEAVE.
        END.
        RUN web_api_unit_price (INPUT xListaArticulos,
                                INPUT xListaClasificacion,
                                INPUT xListaCondiciones,
                                INPUT pcCodCli,
                                INPUT pcCodDiv,
                                OUTPUT pcOutput,
                                OUTPUT pcError
                                ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
        pcReturn = pcReturn + (IF TRUE <> (pcReturn > '') THEN '' ELSE ',') + pcOutput.

        /* Formato de pcOutput
        000752:13.3572:2:3.55:002:C:N
        <CodMat>:<PreUni>:<CodMon>:<TpoCmb>:<FmaPgo>:<ClfCli>:<Contrato>
        */

        /* LO VAMOS A BLOQUEAR POR AHORA
        /* Guardamos buffer por cada artículo */
        DO iItem = 1 TO NUM-ENTRIES(pcOutput):
            cCodMat = ENTRY(1,ENTRY(iItem,pcOutput,','),':').
            cFmaPgo = ENTRY(5,ENTRY(iItem,pcOutput,','),':').
            cClfCli = ENTRY(6,ENTRY(iItem,pcOutput,','),':').
            cDesMat = pcCodCli + ":" + pcCodDiv + ":" + cFmaPgo + ":" + cClfCli.
            cContrato = ENTRY(7,ENTRY(iItem,pcOutput,','),':').
            fPreUni = 0.
            fPreUni = DECIMAL(ENTRY(2,ENTRY(iItem,pcOutput,','),':')).
            iCodMon = 1.
            iCodMon = INTEGER(ENTRY(3,ENTRY(iItem,pcOutput,','),':')).
            fTpoCmb = 1.
            fTpoCmb = DECIMAL(ENTRY(4,ENTRY(iItem,pcOutput,','),':')).
            /* 6.- Bloqueamos hasta conseguirlo o pasamos al siguiente */
            FIND FIRST LogListaMinGn USE-INDEX Idx01 WHERE LogListaMinGn.CodCia = s-codcia
                AND LogListaMinGn.codmat = cCodMat
                AND LogListaMinGn.DesMat BEGINS cDesMat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE LogListaMinGn THEN CREATE LogListaMinGn.
            ELSE DO:
                {lib/lock-genericov3.i ~
                    &Tabla="LogListaMinGn" ~
                    &Alcance="FIRST" ~
                    &Condicion="LogListaMinGn.CodCia = s-codcia ~
                    AND LogListaMinGn.codmat = cCodMat ~
                    AND LogListaMinGn.DesMat BEGINS cDesMat" ~
                    &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
                    &Accion="RETRY" ~
                    &Mensaje="NO" ~
                    &txtMensaje="cMensaje" ~
                    &TipoError="NEXT" ~
                    &Intentos="10" ~
                    }
            END.
            ASSIGN
                LogListaMinGn.CodCia = s-codcia
                LogListaMinGn.codmat = cCodMat
                .
            cDesMat = pcCodCli + ":" + pcCodDiv + ":" + cFmaPgo + ":" + cClfCli + ":" + cContrato.
            ASSIGN
                LogListaMinGn.MonVta = iCodMon
                LogListaMinGn.PreOfi = fPreUni
                LogListaMinGn.DesMat = cDesMat
                LogListaMinGn.LogDate = TODAY
                LogListaMinGn.LogTime = STRING(TIME,'HH:MM:SS')
                LogListaMinGn.TpoCmb = fTpoCmb
                LogListaMinGn.usuario = s-user-id
                .
            RELEASE LogListaMinGn.
        END.
        */
        xListaArticulos = ''.
        xListaClasificacion = ''.
        xListaCondiciones = ''.
    END.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-web_connection_log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_connection_log Procedure 
PROCEDURE web_connection_log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pUrl AS CHAR.
DEFINE INPUT PARAMETER pError AS CHAR.

DEFINE VAR lClientComputerName  AS CHAR.
DEFINE VAR lClientName          AS CHAR.
DEFINE VAR lComputerName        AS CHAR.
DEFINE VAR lRemote-user         AS CHAR.
DEFINE VAR lxClientName         AS CHAR.

lClientComputerName = OS-GETENV ( "CLIENTCOMPUTERNAME").
lClientName         = OS-GETENV ( "CLIENTNAME").
lComputerName       = OS-GETENV ( "COMPUTERNAME").
lRemote-user        = OS-GETENV ( "REMOTE_USER").

lxClientName        = IF (lClientComputerName = ? OR lClientComputerName = "") THEN lClientName ELSE lClientComputerName.
lxClientName        = IF (CAPS(lxClientName) = "CONSOLE") THEN "" ELSE lxClientName.
lxClientName        = IF (lxClientName = ? OR lxClientName = "") THEN lComputerName ELSE lxClientName.

CREATE connection_log.
ASSIGN
    connection_log.connect_ClientType = s-user-id
    connection_log.connect_device = lxClientName
    connection_log.connect_estado = "FAIL_API_PRICING"
    /*connection_log.connect_id = */
    connection_log.connect_name = pUrl
    /*connection_log.connect_pid =*/
    connection_log.connect_thora_procesada = STRING(TIME, 'HH:MM:SS')
    connection_log.connect_time = STRING(TODAY, '99/99/9999')
    connection_log.connect_type = pError
    /*connection_log.connect_usr = */
    .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

