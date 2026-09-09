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
         HEIGHT             = 15.88
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

/* Capturamos el API */
DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.

x-oXmlHttp:OPEN( "GET", x-Url, NO ). 
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
x-oXmlHttp:setOption( 2, 13056 ) .  
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pMessage = "Se detecta demasiadas peticiones de uso del servidor de aplicaciones," + CHR(10) +
        "Vuelva a intentar y de persistir el mismo mensaje, contactar a Sistemas" + CHR(10) +
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

DEF VAR Inicio AS INT64 NO-UNDO.
DEF VAR Fin AS INT64 NO-UNDO.

/* Separamos la DATA */
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.

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
    pMessage = "VALIDACION: División sin configuración de Peldaño" + CHR(10) + 
        "División: " + pCodDiv + CHR(10) + CHR(10) +
        "Comunicarse con el Jefe de Línea para su diagnóstico previo" + CHR(10) +
        "y de ser necesario se comunicará con sistemas".
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.

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
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
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

RELEASE OBJECT x-oXmlHttp NO-ERROR.

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

&IF DEFINED(EXCLUDE-web_api-pricing-preuni-Old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE web_api-pricing-preuni-Old Procedure 
PROCEDURE web_api-pricing-preuni-Old :
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

