&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : http-get-contenido.p
    Purpose     : Obtiene contenido de una URL vía HTTP GET
    Author(s)   : Optimizado
    Notes       : Soporta respuestas grandes (LONGCHAR)
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&SCOPED-DEFINE HTTP-NEWLINE CHR(13) + CHR(10)

DEFINE INPUT PARAMETER pURL         AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pRESULT     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pRESPONSE   AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pContent    AS LONGCHAR NO-UNDO.

DEFINE VAR piTimeout AS INTEGER NO-UNDO.  /* Nuevo: timeout configurable */

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE cHOST        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPORT        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cURL         AS CHARACTER NO-UNDO.
DEFINE VARIABLE requestString AS CHARACTER NO-UNDO.
DEFINE VARIABLE vSocket      AS HANDLE NO-UNDO.
DEFINE VARIABLE vBuffer      AS MEMPTR NO-UNDO.
DEFINE VARIABLE vloop        AS LOGICAL NO-UNDO.
DEFINE VARIABLE wStatus      AS LOGICAL NO-UNDO.
DEFINE VARIABLE vstarttime   AS INTEGER NO-UNDO.
DEFINE VARIABLE iTimeout     AS INTEGER NO-UNDO.
DEFINE VARIABLE cUserAgent   AS CHARACTER NO-UNDO.

/* ? NUEVAS VARIABLES PARA ARCHIVO TEMPORAL */
DEFINE VARIABLE cTempFile    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cChunk       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lcTempBuffer AS LONGCHAR NO-UNDO.

/* ============================================================
   Inicialización
   ============================================================ */
ASSIGN
    pRESULT   = ""
    pRESPONSE = ""
    pContent  = ""
    iTimeout  = (IF piTimeout > 0 THEN piTimeout ELSE 60) * 1000  /* Default 60 seg */
    cUserAgent = "Progress-OpenEdge/10.1C".

/* ============================================================
   Validación de URL
   ============================================================ */
IF TRIM(pURL) = "" THEN DO:
    pRESULT = "0:URL Vacia".
    RETURN.
END.

/* ============================================================
   Parsear URL
   ============================================================ */
RUN UrlParser(INPUT pURL, OUTPUT cHOST, OUTPUT cPORT, OUTPUT cURL).

IF cHOST = "" OR cURL = "" THEN DO:
    pRESULT = "0:URL Invalida".
    RETURN.
END.

/* ============================================================
   Construir Request HTTP
   ============================================================ */
requestString = "GET " + cURL + " HTTP/1.1" + {&HTTP-NEWLINE} +
                "Accept: */*" + {&HTTP-NEWLINE} +
                "Accept-Encoding: identity" + {&HTTP-NEWLINE} +
                "User-Agent: " + cUserAgent + {&HTTP-NEWLINE} +
                "Host: " + cHOST + {&HTTP-NEWLINE} +
                "Connection: Close" + {&HTTP-NEWLINE} +
                {&HTTP-NEWLINE}.

/* ============================================================
   Crear Archivo Temporal
   ============================================================ */
cTempFile = SESSION:TEMP-DIRECTORY + "http_" + STRING(ETIME) + "_" + STRING(RANDOM(1, 99999)) + ".tmp".

/* ============================================================
   Crear Socket y Conectar
   ============================================================ */
CREATE SOCKET vSocket.
vSocket:SET-READ-RESPONSE-PROCEDURE("readHandler", THIS-PROCEDURE).

wStatus = vSocket:CONNECT("-H " + cHOST + " -S " + cPORT) NO-ERROR.

IF NOT wStatus THEN DO:
    pRESULT = "0:No Socket - " + (IF ERROR-STATUS:ERROR THEN ERROR-STATUS:GET-MESSAGE(1) ELSE "").
    DELETE OBJECT vSocket.
    RETURN.
END.

/* ============================================================
   Enviar Request
   ============================================================ */
SET-SIZE(vBuffer) = LENGTH(requestString) + 1.
PUT-STRING(vBuffer, 1) = requestString.
vSocket:WRITE(vBuffer, 1, LENGTH(requestString)).
SET-SIZE(vBuffer) = 0.

/* ============================================================
   Esperar Respuesta con Timeout
   ============================================================ */
vloop = TRUE.
vstarttime = ETIME.

WAITLOOP:
DO WHILE vloop:
    PROCESS EVENTS.
    PAUSE 0.
    
    IF vstarttime + iTimeout < ETIME THEN DO:
        vSocket:DISCONNECT().
        pRESULT = "0:Timeout (60s)".
        DELETE OBJECT vSocket.
        /* Limpiar archivo temporal */
        IF cTempFile > "" THEN OS-DELETE VALUE(cTempFile) NO-ERROR.
        RETURN.
    END.
END.

/* ============================================================
   Desconectar y Limpiar
   ============================================================ */
vSocket:DISCONNECT().
DELETE OBJECT vSocket.

/* ============================================================
   PROCESAR RESPUESTA USANDO ARCHIVO TEMPORAL
   ============================================================ */

/* ? 1. Leer el contenido del archivo temporal al LONGCHAR */
COPY-LOB FILE cTempFile TO pRESPONSE.
pResponse = SUBSTRING(pResponse,INDEX(pResponse,'[')).

/* ? 2. Eliminar archivo temporal */
OS-DELETE VALUE(cTempFile) NO-ERROR.

/* ============================================================
   Extraer Headers y Body
   ============================================================ */
DEFINE VARIABLE iHeaderEnd AS INTEGER NO-UNDO.
DEFINE VARIABLE cHeaders   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cBody      AS LONGCHAR NO-UNDO.

/* Buscar el fin de los headers (doble CRLF) */
iHeaderEnd = INDEX(pRESPONSE, {&HTTP-NEWLINE} + {&HTTP-NEWLINE}).

IF iHeaderEnd > 0 THEN DO:
    /* Extraer headers como CHARACTER (normalmente pequeños) */
    cHeaders = SUBSTRING(pRESPONSE, 1, iHeaderEnd - 1) NO-ERROR.
    
    /* Extraer body como LONGCHAR (puede ser grande) */
    cBody = SUBSTRING(pRESPONSE, 
                      iHeaderEnd + LENGTH({&HTTP-NEWLINE} + {&HTTP-NEWLINE}), 
                      -1) NO-ERROR.
    
    pRESPONSE = cHeaders.
    pContent = cBody.
    
    /* Verificar si hay error en el contenido */
    IF INDEX(pContent, "<error>Not Content</error>") > 0 THEN
        pRESULT = "0:Not Content".
    ELSE
        pRESULT = "1:Success".
    
    /* Verificar códigos de estado HTTP en headers */
    IF cHeaders MATCHES "*404*" THEN pRESULT = "0:HTTP 404".
    IF cHeaders MATCHES "*500*" THEN pRESULT = "0:HTTP 500".
    IF cHeaders MATCHES "*401*" THEN pRESULT = "0:HTTP 401".
    IF cHeaders MATCHES "*403*" THEN pRESULT = "0:HTTP 403".
    
END.
ELSE DO:
    /* Si no se encontró el fin de headers, todo es body */
    pContent = pRESPONSE.
    pRESULT = "1:Success".
END.

/* Limpiar memoria */
ASSIGN
    cHeaders = ""
    cBody = "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-readHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readHandler Procedure 
PROCEDURE readHandler :
/*------------------------------------------------------------------------------
  Purpose: Lee datos del socket y los escribe DIRECTAMENTE al archivo temporal
  Notes:   Evita completamente el error 9324
------------------------------------------------------------------------------*/

    DEFINE VARIABLE bytesAvail AS INTEGER NO-UNDO.
    DEFINE VARIABLE b AS MEMPTR NO-UNDO.
    DEFINE VARIABLE iRead AS INTEGER NO-UNDO.
    DEFINE VARIABLE cChunk AS CHARACTER NO-UNDO.

    IF vSocket:connected() THEN
        bytesAvail = vSocket:GET-BYTES-AVAILABLE().
    
    IF bytesAvail = 0 THEN DO:
        vloop = FALSE.
        RETURN.
    END.

    /* ============================================================
       Leer datos del socket
       ============================================================ */
    SET-SIZE(b) = bytesAvail + 1.
    vSocket:READ(b, 1, bytesAvail, 1).
    
    /* ? Obtener el chunk como CHARACTER */
    cChunk = GET-STRING(b, 1, bytesAvail) NO-ERROR.
    
    IF cChunk <> ? AND cChunk > "" THEN DO:
        /* ? ESCRIBIR DIRECTAMENTE AL ARCHIVO TEMPORAL */
        OUTPUT TO VALUE(cTempFile) APPEND.
        PUT UNFORMATTED cChunk.
        OUTPUT CLOSE.
    END.
    
    SET-SIZE(b) = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-UrlParser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UrlParser Procedure 
PROCEDURE UrlParser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER purl AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER phost AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pport AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER ppath AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE vStr AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iPos AS INTEGER NO-UNDO.
    DEFINE VARIABLE bSSL AS LOGICAL NO-UNDO.

    ASSIGN
        phost = ""
        pport = "80"
        ppath = "/"
        bSSL = FALSE.

    IF purl BEGINS "https://" THEN DO:
        bSSL = TRUE.
        pport = "443".
        vStr = SUBSTRING(purl, 9).
    END.
    ELSE IF purl BEGINS "http://" THEN DO:
        vStr = SUBSTRING(purl, 8).
    END.
    ELSE DO:
        ppath = purl.
        RETURN.
    END.

    /* Extraer host */
    iPos = INDEX(vStr, "/").
    IF iPos > 0 THEN DO:
        phost = SUBSTRING(vStr, 1, iPos - 1).
        ppath = SUBSTRING(vStr, iPos).
    END.
    ELSE DO:
        phost = vStr.
        ppath = "/".
    END.

    /* Extraer puerto si existe */
    iPos = INDEX(phost, ":").
    IF iPos > 0 THEN DO:
        pport = SUBSTRING(phost, iPos + 1).
        phost = SUBSTRING(phost, 1, iPos - 1).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

