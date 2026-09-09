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

/*------------------------------------------------------------------------
    File        : http-get-contenido-file_corregido.p
    Purpose     : Ejecuta una peticion HTTP desde Progress y devuelve la
                  respuesta JSON en un archivo temporal.

    Correcciones principales:
      1. La ruta de trabajo se puede controlar mediante pWorkDir.
      2. Se valida que el directorio exista y sea escribible.
      3. El archivo temporal se crea antes de iniciar el socket.
      4. Se controla ERROR-STATUS en OUTPUT/PUT.
      5. No se pierde la respuesta silenciosamente ante un error de I/O.
      6. Se usa la misma ruta de trabajo para el archivo HTTP y el JSON.
      7. Se evita asumir que el TEMP del cliente es el TEMP de Graphon.
      8. Se mantiene la firma original mediante una rutina interna que
         recibe el directorio; el llamador existente no necesita cambiar.

    Nota importante:
      En un Terminal Server, SESSION:TEMP-DIRECTORY pertenece al servidor
      donde corre Progress. Si el archivo debe quedar en el PC del usuario,
      pWorkDir debe ser una ruta realmente accesible desde la sesion Graphon
      (unidad redireccionada o recurso compartido).
  ----------------------------------------------------------------------*/

&SCOPED-DEFINE HTTP-NEWLINE CHR(13) + CHR(10)
&SCOPED-DEFINE RESPONSE-TIMEOUT 120

DEFINE INPUT  PARAMETER pURL      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pRESULT   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pTempFile AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pContent  AS LONGCHAR  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-GetLastError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetLastError Procedure 
FUNCTION GetLastError RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 7.77
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Variables compartidas con readHandler. En ABL los handlers internos
   no pueden acceder a variables locales de otro procedimiento interno. */
DEFINE VARIABLE vSocket   AS HANDLE    NO-UNDO.
DEFINE VARIABLE vloop     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cTempFile AS CHARACTER NO-UNDO.

/* -----------------------------------------------------------------
   Directorio de trabajo.
   Si se deja vacio se utiliza SESSION:TEMP-DIRECTORY.
   Para Graphon se recomienda llamar a la rutina parametrizada incluida
   mas abajo cuando se conozca la ruta de trabajo correcta.
   ----------------------------------------------------------------- */
DEFINE VARIABLE cWorkDir AS CHARACTER NO-UNDO.

ASSIGN cWorkDir = SESSION:TEMP-DIRECTORY.

RUN ExecuteRequest (INPUT pURL,
                    INPUT cWorkDir,
                    OUTPUT pRESULT,
                    OUTPUT pTempFile,
                    OUTPUT pContent).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ExecuteRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExecuteRequest Procedure 
PROCEDURE ExecuteRequest :
/*------------------------------------------------------------------------------
  Purpose: Ejecuta petición HTTP/HTTPS utilizando el componente COM MSXML2.
  Notes:   Nativo de Windows. Evita problemas de sockets, redirecciones 32/64
           bits y comandos externos (curl/OS-COMMAND).
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcURL      AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcWorkDir  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcResult   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcTempFile AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcContent  AS LONGCHAR  NO-UNDO.

    DEFINE VARIABLE hHttp     AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE cRawFile  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cJsonFile AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cResponse AS LONGCHAR   NO-UNDO.
    DEFINE VARIABLE iStatus   AS INTEGER    NO-UNDO.

    ASSIGN
        pcResult   = "0:Error"
        pcTempFile = ""
        pcContent  = ""
        pcWorkDir  = TRIM(pcWorkDir).

    /* --------------------------------------------------------------
       1. Normalización de la ruta de trabajo (Evita error '\\\')
       -------------------------------------------------------------- */
    IF pcWorkDir = "" THEN
        pcWorkDir = SESSION:TEMP-DIRECTORY.

    pcWorkDir = RIGHT-TRIM(pcWorkDir, "/\") + "\".

    FILE-INFO:FILE-NAME = pcWorkDir.
    IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
        pcResult = "0:Directorio de trabajo no accesible: " + pcWorkDir.
        RETURN.
    END.

    /* --------------------------------------------------------------
       2. Validación de URL
       -------------------------------------------------------------- */
    IF TRIM(pcURL) = "" THEN DO:
        pcResult = "0:URL Vacia".
        RETURN.
    END.

    /* --------------------------------------------------------------
       3. Nombres de archivos temporales
       -------------------------------------------------------------- */
    ASSIGN
        cRawFile  = pcWorkDir + "http_" + STRING(SESSION:SERVER-CONNECTION-ID) + "_" + STRING(ETIME) + ".tmp"
        cJsonFile = pcWorkDir + "json_" + STRING(SESSION:SERVER-CONNECTION-ID) + "_" + STRING(ETIME) + ".tmp".
/*     ASSIGN                                                                                        */
/*         cRawFile  = pcWorkDir + "http_" + STRING(ETIME) + "_" + STRING(RANDOM(1,99999)) + ".tmp"  */
/*         cJsonFile = pcWorkDir + "json_" + STRING(ETIME) + "_" + STRING(RANDOM(1,99999)) + ".tmp". */

    /* --------------------------------------------------------------
       4. Creación del objeto COM MSXML
       -------------------------------------------------------------- */
    CREATE "MSXML2.ServerXMLHTTP.6.0" hHttp NO-ERROR.

    IF NOT VALID-HANDLE(hHttp) THEN
        CREATE "MSXML2.ServerXMLHTTP" hHttp NO-ERROR.

    IF NOT VALID-HANDLE(hHttp) THEN DO:
        pcResult = "0:No se pudo instanciar componente COM MSXML2.ServerXMLHTTP".
        RETURN.
    END.

    /* --------------------------------------------------------------
       5. Configuración y ejecución de la petición HTTP GET
       -------------------------------------------------------------- */
    /* Open(Method, URL, Async) -> FALSE = Sincrónico */
    hHttp:OPEN("GET", pcURL, FALSE) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        pcResult = "0:Error al abrir conexion HTTP - " + GetLastError().
        RELEASE OBJECT hHttp NO-ERROR.
        RETURN.
    END.

    /* Configurar Timeouts en ms: (Resolve, Connect, Send, Receive) */
    hHttp:setTimeouts(10000, 10000, 300000, 300000) NO-ERROR.

    /* Enviar la solicitud */
    hHttp:SEND() NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        pcResult = "0:Error al enviar peticion HTTP - " + GetLastError().
        RELEASE OBJECT hHttp NO-ERROR.
        RETURN.
    END.

    /* --------------------------------------------------------------
       6. Evaluar código de respuesta HTTP
       -------------------------------------------------------------- */
    ASSIGN iStatus = hHttp:STATUS NO-ERROR.

    IF iStatus <> 200 THEN DO:
        pcResult = "0:HTTP Error " + STRING(iStatus) + ": " + STRING(hHttp:statusText).
        RELEASE OBJECT hHttp NO-ERROR.
        RETURN.
    END.

    /* Obtener cuerpo de la respuesta */
    ASSIGN cResponse = hHttp:responseText NO-ERROR.

    /* Liberar memoria del objeto COM inmediatamente */
    RELEASE OBJECT hHttp NO-ERROR.

    IF cResponse = "" OR cResponse = ? THEN DO:
        pcResult = "0:Respuesta HTTP vacia".
        RETURN.
    END.

    /* Guardar respuesta bruta en disco para mantener el flujo de extractJsonFromFile */
    COPY-LOB FROM cResponse TO FILE cRawFile NO-ERROR.

    /* --------------------------------------------------------------
       7. Extraer el bloque JSON del archivo descargado
       -------------------------------------------------------------- */
    RUN extractJsonFromFile(INPUT  cRawFile,
                            INPUT  cJsonFile,
                            OUTPUT pcResult).

    /* Eliminar el archivo temporal bruto */
    OS-DELETE VALUE(cRawFile) NO-ERROR.

    IF pcResult <> "1:Success" THEN DO:
        pcTempFile = "".
        RETURN.
    END.

    /* --------------------------------------------------------------
       8. Confirmación del archivo JSON de salida
       -------------------------------------------------------------- */
    FILE-INFO:FILE-NAME = cJsonFile.

    IF FILE-INFO:FULL-PATHNAME = ? OR FILE-INFO:FILE-SIZE <= 0 THEN DO:
        pcResult = "0:No se pudo crear archivo JSON: " + cJsonFile.
        OS-DELETE VALUE(cJsonFile) NO-ERROR.
        pcTempFile = "".
        RETURN.
    END.

    /* Asignar variables de salida */
    pcTempFile = cJsonFile.
    pcResult   = "1:Success".

    /* Asignar también a la variable LONGCHAR de salida */
    /*COPY-LOB FROM FILE cJsonFile TO pcContent NO-ERROR.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-extractJsonFromFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extractJsonFromFile Procedure 
PROCEDURE extractJsonFromFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcSourceFile AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcTargetFile AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcResult     AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cLine    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lFound   AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cLlave   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iPos     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cErr     AS CHARACTER NO-UNDO.

    ASSIGN
        pcResult = "0:Error"
        lFound   = FALSE
        cLlave   = CHR(123).

    FILE-INFO:FILE-NAME = pcSourceFile.

    IF FILE-INFO:FULL-PATHNAME = ? OR FILE-INFO:FILE-SIZE <= 0 THEN DO:
        pcResult = "0:Archivo Origen Vacio: " + pcSourceFile.
        RETURN.
    END.

    INPUT FROM VALUE(pcSourceFile).

    IF ERROR-STATUS:ERROR THEN DO:
        pcResult = "0:No se pudo abrir origen: " + GetLastError().
        RETURN.
    END.

    OUTPUT TO VALUE(pcTargetFile).

    IF ERROR-STATUS:ERROR THEN DO:
        cErr = GetLastError().
        INPUT CLOSE.
        pcResult = "0:No se pudo crear destino: " + pcTargetFile +
                   " - " + cErr.
        RETURN.
    END.

    REPEAT ON STOP UNDO, LEAVE:

        IMPORT UNFORMATTED cLine.

        IF INDEX(cLine,"[") > 0 OR INDEX(cLine,cLlave) > 0 THEN DO:

            lFound = TRUE.

            iPos = INDEX(cLine,"[").
            IF iPos = 0 OR
               (INDEX(cLine,cLlave) > 0 AND INDEX(cLine,cLlave) < iPos) THEN
                iPos = INDEX(cLine,cLlave).

            PUT UNFORMATTED SUBSTRING(cLine,iPos) SKIP.

            IF ERROR-STATUS:ERROR THEN DO:
                cErr = GetLastError().
                INPUT CLOSE.
                OUTPUT CLOSE.
                pcResult = "0:Error escribiendo JSON: " + cErr.
                RETURN.
            END.

            REPEAT:
                IMPORT UNFORMATTED cLine.
                PUT UNFORMATTED cLine SKIP.

                IF ERROR-STATUS:ERROR THEN DO:
                    cErr = GetLastError().
                    INPUT CLOSE.
                    OUTPUT CLOSE.
                    pcResult = "0:Error escribiendo JSON: " + cErr.
                    RETURN.
                END.
            END.

            LEAVE.
        END.
    END.

    INPUT CLOSE.
    OUTPUT CLOSE.

    IF ERROR-STATUS:ERROR THEN DO:
        pcResult = "0:Error cerrando archivo JSON: " + GetLastError().
        RETURN.
    END.

    FILE-INFO:FILE-NAME = pcTargetFile.

    IF lFound AND FILE-INFO:FULL-PATHNAME <> ?
       AND FILE-INFO:FILE-SIZE > 0 THEN
        pcResult = "1:Success".
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE bytesAvail AS INTEGER   NO-UNDO.
    DEFINE VARIABLE b          AS MEMPTR    NO-UNDO.
    DEFINE VARIABLE cChunk     AS LONGCHAR NO-UNDO.
    DEFINE VARIABLE cErr       AS CHARACTER NO-UNDO.

    IF NOT VALID-HANDLE(vSocket) THEN DO:
        vloop = FALSE.
        RETURN.
    END.

    IF NOT vSocket:CONNECTED() THEN DO:
        vloop = FALSE.
        RETURN.
    END.

    bytesAvail = vSocket:GET-BYTES-AVAILABLE().

    /* Cero bytes no es un error de escritura. Esperamos otro evento.
       El fin de la comunicacion se controla cuando el socket se desconecta
       o mediante el timeout de la rutina principal. */
    IF bytesAvail <= 0 THEN
        RETURN.

    SET-SIZE(b) = bytesAvail + 1.

    vSocket:READ(b,1,bytesAvail,1) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        cErr = GetLastError().
        SET-SIZE(b) = 0.
        pRESULT = "0:Error leyendo socket - " + cErr.
        vloop = FALSE.
        RETURN.
    END.

    /*cChunk = GET-STRING(b,1,bytesAvail) NO-ERROR.*/
    COPY-LOB FROM b STARTING AT 1 FOR bytesAvail TO cChunk.

    IF cChunk = ? THEN DO:
        SET-SIZE(b) = 0.
        pRESULT = "0:Error convirtiendo respuesta del socket".
        vloop = FALSE.
        RETURN.
    END.

    IF cChunk <> "" THEN DO:
        COPY-LOB FROM cChunk TO FILE cTempFile NO-ERROR.

/*         OUTPUT TO VALUE(cTempFile) APPEND.                             */
/*                                                                        */
/*         IF ERROR-STATUS:ERROR THEN DO:                                 */
/*             cErr = GetLastError().                                     */
/*             SET-SIZE(b) = 0.                                           */
/*             pRESULT = "0:Error abriendo archivo temporal: " + cErr.    */
/*             vloop = FALSE.                                             */
/*             RETURN.                                                    */
/*         END.                                                           */
/*                                                                        */
/*         PUT UNFORMATTED STRING(cChunk).                                */
/*                                                                        */
/*         IF ERROR-STATUS:ERROR THEN DO:                                 */
/*             cErr = GetLastError().                                     */
/*             OUTPUT CLOSE.                                              */
/*             SET-SIZE(b) = 0.                                           */
/*             pRESULT = "0:Error escribiendo archivo temporal: " + cErr. */
/*             vloop = FALSE.                                             */
/*             RETURN.                                                    */
/*         END.                                                           */
/*                                                                        */
/*         OUTPUT CLOSE.                                                  */

        IF ERROR-STATUS:ERROR THEN DO:
            cErr = GetLastError().
            SET-SIZE(b) = 0.
            pRESULT = "0:Error cerrando archivo temporal: " + cErr.
            vloop = FALSE.
            RETURN.
        END.
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

    DEFINE INPUT  PARAMETER purl  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER phost AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pport AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER ppath AS CHARACTER NO-UNDO.

    DEFINE VARIABLE vStr AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iPos AS INTEGER   NO-UNDO.

    ASSIGN
        phost = ""
        pport = "80"
        ppath = "/".

    IF purl BEGINS "https://" THEN DO:
        /*
           IMPORTANTE: el socket CONNECT usado por este programa es TCP
           directo. No implementa TLS/SSL. Si la URL es HTTPS real, debe
           utilizarse una capa SSL compatible con la instalacion de OE 10.1C
           o un proxy/intermediario. No se debe tratar HTTPS como HTTP plano.
        */
        pport = "443".
        vStr = SUBSTRING(purl,9).
    END.
    ELSE IF purl BEGINS "http://" THEN DO:
        vStr = SUBSTRING(purl,8).
    END.
    ELSE DO:
        RETURN.
    END.

    iPos = INDEX(vStr,"/").

    IF iPos > 0 THEN DO:
        phost = SUBSTRING(vStr,1,iPos - 1).
        ppath = SUBSTRING(vStr,iPos).
    END.
    ELSE DO:
        phost = vStr.
        ppath = "/".
    END.

    iPos = INDEX(phost,":").

    IF iPos > 0 THEN DO:
        pport = SUBSTRING(phost,iPos + 1).
        phost = SUBSTRING(phost,1,iPos - 1).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-GetLastError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetLastError Procedure 
FUNCTION GetLastError RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/* ==================================================================
   Devuelve el ultimo error disponible en ERROR-STATUS.
   ================================================================== */

DEFINE VARIABLE i AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c AS CHARACTER NO-UNDO.
    DEFINE VARIABLE m AS INTEGER   NO-UNDO.

    ASSIGN
        c = ""
        m = ERROR-STATUS:NUM-MESSAGES.

    DO i = 1 TO m:
        IF ERROR-STATUS:GET-MESSAGE(i) <> "" THEN DO:
            IF c <> "" THEN
                c = c + " | ".
            c = c + ERROR-STATUS:GET-MESSAGE(i).
        END.
    END.

    IF c = "" THEN
        c = "Error no especificado".

    RETURN c.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

