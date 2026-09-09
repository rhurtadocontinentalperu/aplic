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
&SCOPED-DEFINE HTTP-NEWLINE CHR(13) + CHR(10)

DEFINE INPUT PARAMETER pURL AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pRESULT AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pTempFile AS CHARACTER NO-UNDO.  /* ? Ruta del archivo temporal */
DEFINE OUTPUT PARAMETER pContent AS LONGCHAR NO-UNDO.    /* ? Opcional, para compatibilidad */

/*
/* 1. Obtener archivo temporal desde la API */
RUN lib/http-get-contenido-file.p(
    xUrl,
    OUTPUT pResult,
    OUTPUT pTempFile,
    OUTPUT pContent
).

/* 2. Procesar JSON línea por línea */
RUN lib/json-stream-processor.p(
    INPUT  pTempFile,
    INPUT  pcCodCli,
    OUTPUT pcReturn,
    OUTPUT pcError
).

/* 3. Limpiar archivo temporal */
OS-DELETE VALUE(pTempFile) NO-ERROR.
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
         HEIGHT             = 8.23
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

/* ? Variables para archivo temporal */
DEFINE VARIABLE cTempFile    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cJsonFile    AS CHARACTER NO-UNDO.  /* Archivo solo con JSON */
DEFINE VARIABLE cChunk       AS CHARACTER NO-UNDO.

/* ============================================================
   Inicialización
   ============================================================ */
ASSIGN
    pRESULT   = ""
    pTempFile = ""
    pContent  = ""
    iTimeout  = 60 * 1000  /* 60 segundos */
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
   Crear Archivo Temporal para la Respuesta Completa
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
    IF cTempFile > "" THEN OS-DELETE VALUE(cTempFile) NO-ERROR.
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
   PROCESAR RESPUESTA - EXTRAER SOLO EL JSON
   ============================================================ */

/* ? Verificar que el archivo temporal existe */
FILE-INFO:FILE-NAME = cTempFile.
IF FILE-INFO:FILE-SIZE <= 0 THEN DO:
    pRESULT = "0:Archivo Temporal Vacio".
    pTempFile = "".
    RETURN.
END.

/* ? Crear archivo solo para JSON */
cJsonFile = SESSION:TEMP-DIRECTORY + "json_" + STRING(ETIME) + "_" + STRING(RANDOM(1, 99999)) + ".tmp".

/* ? Procesar el archivo temporal y extraer JSON */
RUN extractJsonFromFile(INPUT cTempFile, 
                        INPUT cJsonFile,
                        OUTPUT pRESULT).

/* ? Verificar que el archivo JSON fue creado */
FILE-INFO:FILE-NAME = cJsonFile.
IF FILE-INFO:FILE-SIZE <= 0 THEN DO:
    pRESULT = "0:No se pudo extraer JSON".
    pTempFile = "".
    OS-DELETE VALUE(cTempFile) NO-ERROR.
    RETURN.
END.

/* ? Eliminar archivo temporal original */
OS-DELETE VALUE(cTempFile) NO-ERROR.

/* ? Devolver la ruta del archivo JSON */
pTempFile = cJsonFile.

/* ? Opcional: Cargar el JSON en LONGCHAR si es pequeño */
DEFINE VARIABLE iFileSize AS INTEGER NO-UNDO.
FILE-INFO:FILE-NAME = cJsonFile.
iFileSize = FILE-INFO:FILE-SIZE.

/*
IF iFileSize > 0 AND iFileSize < 32000 THEN DO:
    /* Si es pequeño, cargarlo en memoria para compatibilidad */
    COPY-LOB FILE cJsonFile TO pContent.
END.
ELSE DO:
    /* Si es grande, dejar vacío y usar el archivo */
    pContent = "".
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-extractJsonFromFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extractJsonFromFile Procedure 
PROCEDURE extractJsonFromFile :
/*------------------------------------------------------------------------------
  Purpose: Extrae el contenido JSON de un archivo que contiene headers HTTP
  Parameters:
    INPUT  pcSourceFile  - Archivo con la respuesta HTTP completa
    INPUT  pcTargetFile  - Archivo donde guardar solo el JSON
    OUTPUT pcResult      - Resultado de la operación
  Notes:   
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcSourceFile AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcTargetFile AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

    DEFINE VARIABLE iJsonStart AS INTEGER NO-UNDO.
    DEFINE VARIABLE cLine AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lFound AS LOGICAL NO-UNDO.
    DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.
    DEFINE VARIABLE cTemp AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cLlave AS CHAR NO-UNDO.
    cLlave = CHR(123).

    ASSIGN
        pcResult = "0:Error"
        lFound = FALSE.

    /* ============================================================
       Verificar que el archivo fuente existe
       ============================================================ */
    FILE-INFO:FILE-NAME = pcSourceFile.
    IF FILE-INFO:FILE-SIZE <= 0 THEN DO:
        pcResult = "0:Archivo Origen Vacio".
        RETURN.
    END.
    /* ============================================================
       Verificar que el archivo fuente tiene contenido mínimo
       ============================================================ */
    IF FILE-INFO:FILE-SIZE < 10 THEN DO:
        pcResult = "0:Archivo Origen Demasiado Pequeño".
        RETURN.
    END.

    /* ============================================================
       Abrir archivo fuente para lectura
       ============================================================ */
    INPUT FROM VALUE(pcSourceFile).
    IF ERROR-STATUS:ERROR THEN DO:
        pcResult = "0:No se pudo abrir origen: " + ERROR-STATUS:GET-MESSAGE(1).
        RETURN.
    END.

    /* ============================================================
       Abrir archivo destino para escritura
       ============================================================ */
    OUTPUT TO VALUE(pcTargetFile).
    IF ERROR-STATUS:ERROR THEN DO:
        pcResult = "0:No se pudo crear destino: " + ERROR-STATUS:GET-MESSAGE(1).
        INPUT CLOSE.
        RETURN.
    END.
    
    /* ============================================================
       Buscar el inicio del JSON
       ============================================================ */
    lFound = FALSE.
    iCounter = 0.
    
    REPEAT:
        IMPORT UNFORMATTED cLine.
        iCounter = iCounter + 1.
        
/*         IF SUBSTRING(cLine,1,1) = "[" THEN iJsonStart = 1. */
/*         IF iJsonStart > 0 THEN DO:                         */
        IF INDEX(cLine, "[") > 0 OR INDEX(cLine, cLlave) > 0 THEN DO:
            /* ? Encontrado el inicio del JSON */
            lFound = TRUE.
            /* Encontrar la posición del primer "[" o "{" */
            IF INDEX(cLine, "[") > 0 THEN
                PUT UNFORMATTED SUBSTRING(cLine, INDEX(cLine, "[")) SKIP.
            ELSE
                PUT UNFORMATTED SUBSTRING(cLine, INDEX(cLine, cLlave)) SKIP.
            /* ? Escribir desde la posición encontrada hasta el final de la línea */
/*             PUT UNFORMATTED SUBSTRING(cLine, iJsonStart) SKIP. */
            
            /* ? Escribir el resto de las líneas */
            REPEAT:
                IMPORT UNFORMATTED cLine.
                PUT UNFORMATTED cLine SKIP.
            END.
            LEAVE.
        END.
    END.
    
    /* ============================================================
       Cerrar archivos
       ============================================================ */
    INPUT CLOSE.
    OUTPUT CLOSE.
    
    /* ============================================================
       Verificar resultado
       ============================================================ */
    IF lFound THEN DO:
        FILE-INFO:FILE-NAME = pcTargetFile.
        IF FILE-INFO:FILE-SIZE > 0 THEN
            pcResult = "1:Success".
        ELSE
            pcResult = "0:Archivo Destino Vacio".
    END.
    ELSE DO:
        pcResult = "0:JSON No Encontrado".
        OS-DELETE VALUE(pcTargetFile) NO-ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readHandler Procedure 
PROCEDURE readHandler :
/*------------------------------------------------------------------------------
  Purpose: Lee datos del socket y los escribe DIRECTAMENTE al archivo temporal
  Notes:   Evita completamente el error 9324
------------------------------------------------------------------------------*/

    DEFINE VARIABLE bytesAvail AS INTEGER NO-UNDO.
    DEFINE VARIABLE b AS MEMPTR NO-UNDO.
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
    
    /* Obtener el chunk como CHARACTER */
    cChunk = GET-STRING(b, 1, bytesAvail) NO-ERROR.
    
    IF cChunk <> ? AND cChunk > "" THEN DO:
        /* ESCRIBIR DIRECTAMENTE AL ARCHIVO TEMPORAL */
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
  Purpose: Parsea una URL en sus componentes
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

