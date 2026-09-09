USING Progress.Lang.*.

CLASS web.api.PricingService:

    DEFINE PRIVATE VARIABLE s-codcia AS INTEGER NO-UNDO.
    
    CONSTRUCTOR PUBLIC PricingService (INPUT piCodCia AS INTEGER):
        ASSIGN s-codcia = piCodCia.
    END CONSTRUCTOR.

    METHOD PUBLIC CHARACTER web_api_captura_lineas(INPUT pCodFam AS CHARACTER, OUTPUT pMensaje AS CHARACTER):
        DEFINE VARIABLE hDoc     AS HANDLE NO-UNDO.
        DEFINE VARIABLE x-Url    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE x-Xml    AS LONGCHAR NO-UNDO.
        DEFINE VARIABLE x-Texto  AS CHARACTER CASE-SENSITIVE NO-UNDO.
        DEFINE VARIABLE x-Cadena AS CHARACTER NO-UNDO.
        DEFINE VARIABLE x-Inicio AS INTEGER NO-UNDO.
        DEFINE VARIABLE x-Fin    AS INTEGER NO-UNDO.
        
        FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
            AND VtaTabla.Tabla = 'CONFIG-WEB-LINEAS' NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaTabla THEN DO:
            pMensaje = "NO se encontró la configuración CONFIG-WEB-LINEAS".
            RETURN "ADM-ERROR".
        END.

        CREATE X-DOCUMENT hDoc.
        x-url = TRIM(VtaTabla.Llave_c1) + TRIM(VtaTabla.Llave_c2) + '?' + "FormatXML=1".
        IF pCodFam > '' THEN x-Url = x-Url + "&Code=" + pCodFam.

        hDoc:LOAD("File", x-url, FALSE) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "NO se pudo cargar la información de la url: " + x-url.
            RETURN "ADM-ERROR".
        END.
        hDoc:SAVE("LONGCHAR", x-Xml).

        x-Texto = STRING(x-Xml).
        x-Inicio = INDEX(x-Texto, "<Data>") + 6.
        x-Fin = INDEX(x-Texto, "</Data>").
        x-Texto = SUBSTRING(x-Texto, x-Inicio, (x-Fin - x-Inicio)).

        REPEAT:
            x-Inicio = INDEX(x-Texto, "<Row>") + 5.
            x-Fin = INDEX(x-Texto, "</Row>").
            IF x-Inicio > x-Fin OR x-Inicio = 5 THEN LEAVE.
            
            x-Cadena = SUBSTRING(x-Texto, x-Inicio, (x-Fin - x-Inicio)).
            
            /* CAMBIO: Llamada directa sin THIS-OBJECT */
            web_api_captura_lineas_save(INPUT x-Cadena, OUTPUT pMensaje).
            
            x-Texto = SUBSTRING(x-Texto, x-Fin + 6).
        END.
        
        DELETE OBJECT hDoc.
        RETURN "OK".
    END METHOD.

    METHOD PRIVATE CHARACTER web_api_captura_lineas_save(INPUT x-Cadena AS CHARACTER, OUTPUT pMensaje AS CHARACTER):
        DEFINE VARIABLE x-Code      AS CHARACTER NO-UNDO.
        DEFINE VARIABLE x-Name      AS CHARACTER NO-UNDO.
        DEFINE VARIABLE x-ExchRate  AS CHARACTER NO-UNDO.
        DEFINE VARIABLE x-Timestamp AS CHARACTER NO-UNDO.

        /* CAMBIO: Llamadas directas a ExtractTag sin THIS-OBJECT */
        x-Code      = ExtractTag(x-Cadena, "Code").
        x-Name      = ExtractTag(x-Cadena, "Name").
        x-ExchRate  = ExtractTag(x-Cadena, "ExchangeRate").
        x-Timestamp = ExtractTag(x-Cadena, "Timestamp_update").

        FIND Almtfami WHERE Almtfami.CodCia = s-codcia 
             AND Almtfami.codfam = x-Code EXCLUSIVE-LOCK NO-ERROR.
             
        IF NOT AVAILABLE Almtfami THEN DO:
            CREATE Almtfami.
            ASSIGN Almtfami.CodCia = s-codcia 
                   Almtfami.codfam = x-Code
                   Almtfami.SwComercial = YES.
        END.
        
        ASSIGN Almtfami.desfam    = x-Name
               Almtfami.TpoCmb    = DECIMAL(x-ExchRate)
               Almtfami.Libre_c04 = x-Timestamp
               Almtfami.Libre_f02 = TODAY.
        
        RELEASE Almtfami.
        RETURN "OK".
    END METHOD.

    METHOD PUBLIC LOGICAL web_api_captura_peldano_valido(INPUT pCodDiv AS CHARACTER, OUTPUT pSalesChannel AS CHARACTER, OUTPUT pMessage AS CHARACTER):
        DEFINE VARIABLE x-oXmlHttp AS COM-HANDLE NO-UNDO.
        DEFINE VARIABLE x-Url      AS CHARACTER NO-UNDO.
        DEFINE VARIABLE x-Texto    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE x-Estado   AS CHARACTER NO-UNDO.
        
        FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
            AND VtaTabla.Tabla = 'CONFIG-WEB-PELDANO-VALIDO' NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaTabla THEN DO:
            pMessage = "Falta CONFIG-WEB-PELDANO-VALIDO".
            RETURN FALSE.
        END.

        x-url = TRIM(VtaTabla.Llave_c1) + TRIM(pCodDiv) + '/xml'.
        CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.
        x-oXmlHttp:OPEN("GET", x-Url, FALSE).
        x-oXmlHttp:SEND().

        IF x-oXmlHttp:STATUS <> 200 THEN DO:
            pMessage = "Error API: " + x-oXmlHttp:responseText.
            RELEASE OBJECT x-oXmlHttp.
            RETURN FALSE.
        END.

        x-Texto = x-oXmlHttp:responseText.
        
        /* CAMBIO: Llamadas directas sin THIS-OBJECT */
        pSalesChannel = ExtractTag(x-Texto, "PeldanoPrecios").
        x-Estado      = ExtractTag(x-Texto, "ParteDeLaEscaleraPrecios").
        
        RELEASE OBJECT x-oXmlHttp.
        RETURN (x-Estado = "1").
    END METHOD.

    METHOD PRIVATE CHARACTER ExtractTag(INPUT pSource AS CHARACTER, INPUT pTag AS CHARACTER):
        DEFINE VARIABLE cOpen  AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cClose AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iStart AS INTEGER NO-UNDO.
        DEFINE VARIABLE iEnd   AS INTEGER NO-UNDO.

        ASSIGN cOpen  = "<" + pTag + ">"
               cClose = "</" + pTag + ">"
               iStart = INDEX(pSource, cOpen)
               iEnd   = INDEX(pSource, cClose).

        IF iStart > 0 AND iEnd > iStart THEN
            RETURN SUBSTRING(pSource, iStart + LENGTH(cOpen), (iEnd - (iStart + LENGTH(cOpen)))).
        ELSE
            RETURN "".
    END METHOD.

END CLASS.
