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

DEFINE VARIABLE ghJson          AS HANDLE     NO-UNDO.
DEFINE VARIABLE giRoot          AS INTEGER    NO-UNDO.
DEFINE VARIABLE giArray         AS INTEGER    NO-UNDO.
DEFINE VARIABLE giItems         AS INTEGER    NO-UNDO.
DEFINE VARIABLE gcLastError     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDateFormat    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTempJsonFile  AS CHARACTER  NO-UNDO.  /* ? Archivo JSON temporal */

ASSIGN
    ghJson       = ?
    giRoot       = 0
    giArray      = 0
    giItems      = 0
    gcLastError  = ""
    gcDateFormat = SESSION:DATE-FORMAT
    gcTempJsonFile = "".

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


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-CurrencyToInteger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CurrencyToInteger Procedure 
FUNCTION CurrencyToInteger RETURNS INTEGER
  ( INPUT pcCurrency AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-NullToBlank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD NullToBlank Procedure 
FUNCTION NullToBlank RETURNS CHARACTER
  ( INPUT pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SafeDate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SafeDate Procedure 
FUNCTION SafeDate RETURNS DATE
  ( INPUT pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SafeDecimal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SafeDecimal Procedure 
FUNCTION SafeDecimal RETURNS DECIMAL
  ( INPUT pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SafeInteger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SafeInteger Procedure 
FUNCTION SafeInteger RETURNS INTEGER
  ( INPUT pcValue AS CHARACTER )  FORWARD.

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
         HEIGHT             = 14.31
         WIDTH              = 61.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-JsonDestroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JsonDestroy Procedure 
PROCEDURE JsonDestroy :
/*------------------------------------------------------------------------------
  Purpose:     Libera variables internas
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ? Eliminar archivo temporal si existe */
    IF gcTempJsonFile > "" THEN DO:
        FILE-INFO:FILE-NAME = gcTempJsonFile.
        IF FILE-INFO:FILE-SIZE > 0 THEN
            OS-DELETE VALUE(gcTempJsonFile) NO-ERROR.
    END.

    ASSIGN
        ghJson       = ?
        giRoot       = 0
        giArray      = 0
        giItems      = 0
        gcLastError  = ""
        gcTempJsonFile = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-JsonExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JsonExists Procedure 
PROCEDURE JsonExists :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piItemId AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcField  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER plExiste AS LOGICAL   NO-UNDO.

    DEFINE VARIABLE cValor AS CHARACTER NO-UNDO.

    plExiste = FALSE.

    IF NOT VALID-HANDLE(ghJson) THEN
        RETURN.

    cValor = DYNAMIC-FUNCTION(
                    "getVal" IN ghJson,
                    piItemId,
                    pcField) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN.

    cValor = NullToBlank(cValor).

    IF cValor > "" THEN
        plExiste = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-JsonGetChar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JsonGetChar Procedure 
PROCEDURE JsonGetChar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piItemId AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcField  AS CHARACTER NO-UNDO.

    DEFINE OUTPUT PARAMETER pcValue  AS CHARACTER NO-UNDO.

    pcValue = "".

    IF NOT VALID-HANDLE(ghJson) THEN
        RETURN.

    pcValue = DYNAMIC-FUNCTION(
                    "getVal" IN ghJson,
                    piItemId,
                    pcField) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        pcValue = "".
        RETURN.
    END.

    pcValue = NullToBlank(pcValue).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-JsonGetCurrency) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JsonGetCurrency Procedure 
PROCEDURE JsonGetCurrency :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/** Convierte una moneda del JSON al código interno                   */
/** SOL,PEN,S/ -> 1                                                   */
/** USD,DOL,DÓLAR -> 2                                                */

    DEFINE INPUT  PARAMETER piItemId AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcField  AS CHARACTER NO-UNDO.

    DEFINE OUTPUT PARAMETER piValue  AS INTEGER   NO-UNDO.

    DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

    RUN JsonGetChar(
        INPUT  piItemId,
        INPUT  pcField,
        OUTPUT cValue).

    piValue = CurrencyToInteger(cValue).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-JsonGetDate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JsonGetDate Procedure 
PROCEDURE JsonGetDate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piItemId AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcField  AS CHARACTER NO-UNDO.

    DEFINE OUTPUT PARAMETER pdValue  AS DATE      NO-UNDO.

    DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

    RUN JsonGetChar(
        INPUT  piItemId,
        INPUT  pcField,
        OUTPUT cValue).

    pdValue = SafeDate(cValue).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-JsonGetDecimal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JsonGetDecimal Procedure 
PROCEDURE JsonGetDecimal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piItemId AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcField  AS CHARACTER NO-UNDO.

    DEFINE OUTPUT PARAMETER pdValue  AS DECIMAL   NO-UNDO.

    DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

    RUN JsonGetChar(
        INPUT  piItemId,
        INPUT  pcField,
        OUTPUT cValue).

    pdValue = SafeDecimal(cValue).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-JsonGetInteger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JsonGetInteger Procedure 
PROCEDURE JsonGetInteger :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piItemId AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcField  AS CHARACTER NO-UNDO.

    DEFINE OUTPUT PARAMETER piValue  AS INTEGER   NO-UNDO.

    DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

    RUN JsonGetChar(
        INPUT  piItemId,
        INPUT  pcField,
        OUTPUT cValue).

    piValue = SafeInteger(cValue).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-JsonGetItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JsonGetItem Procedure 
PROCEDURE JsonGetItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piArrayId AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER piIndex   AS INTEGER NO-UNDO.

    DEFINE OUTPUT PARAMETER piItemId  AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER plOk      AS LOGICAL NO-UNDO.

    ASSIGN
        piItemId = 0
        plOk     = FALSE.

    IF NOT VALID-HANDLE(ghJson) THEN
        RETURN.

    piItemId = DYNAMIC-FUNCTION(
                    "getArrayItem" IN ghJson,
                    piArrayId,
                    piIndex) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN.

    IF piItemId <= 0 THEN
        RETURN.

    plOk = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-JsonGetLogical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JsonGetLogical Procedure 
PROCEDURE JsonGetLogical :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piItemId AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcField  AS CHARACTER NO-UNDO.

    DEFINE OUTPUT PARAMETER plValue  AS LOGICAL   NO-UNDO.

    DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

    RUN JsonGetChar(
        INPUT  piItemId,
        INPUT  pcField,
        OUTPUT cValue).

    cValue = CAPS(TRIM(cValue)).

    CASE cValue:

        WHEN "TRUE"  THEN plValue = TRUE.
        WHEN "YES"   THEN plValue = TRUE.
        WHEN "SI"    THEN plValue = TRUE.
        WHEN "1"     THEN plValue = TRUE.

        OTHERWISE
            plValue = FALSE.

    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-JsonInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JsonInit Procedure 
PROCEDURE JsonInit :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa el parser JSON
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER phJson      AS HANDLE    NO-UNDO.
    DEFINE INPUT  PARAMETER plcJson     AS LONGCHAR  NO-UNDO.

    DEFINE OUTPUT PARAMETER piArrayId   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER piItems     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcError     AS CHARACTER NO-UNDO.

    ASSIGN
        gcLastError = ""
        pcError     = ""
        piArrayId   = 0
        piItems     = 0
        ghJson      = phJson.

    IF NOT VALID-HANDLE(ghJson) THEN DO:

        gcLastError = "Handle JSON inválido".
        pcError     = gcLastError.
        RETURN.

    END.

    RUN iniJson IN ghJson (INPUT plcJson) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:

        gcLastError = ERROR-STATUS:GET-MESSAGE(1).
        pcError     = gcLastError.
        RETURN.

    END.

    giRoot = DYNAMIC-FUNCTION(
                    "parseVal" IN ghJson,
                    0,
                    "") NO-ERROR.

    IF ERROR-STATUS:ERROR OR giRoot <= 0 THEN DO:

        gcLastError = "No fue posible interpretar el JSON.".
        pcError     = gcLastError.
        RETURN.

    END.

    giArray = giRoot.

    giItems = DYNAMIC-FUNCTION(
                    "arrayCount" IN ghJson,
                    giArray) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:

        gcLastError = "No fue posible obtener la cantidad de elementos.".
        pcError     = gcLastError.
        RETURN.

    END.

    ASSIGN
        piArrayId = giArray
        piItems   = giItems.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-JsonInitFromFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JsonInitFromFile Procedure 
PROCEDURE JsonInitFromFile :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa el parser JSON desde un ARCHIVO TEMPORAL
  Parameters:  phJson      - Handle de la librería JSON
               pcJsonFile  - Ruta del archivo JSON
  Notes:       ? Usa parseFile de json10.p (que usa LONGCHAR)
               ? Sin límite de tamaño práctico
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER phJson      AS HANDLE    NO-UNDO.
    DEFINE INPUT  PARAMETER pcJsonFile  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER piArrayId   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER piItems     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcError     AS CHARACTER NO-UNDO.

    DEFINE VARIABLE iRoot AS INTEGER NO-UNDO.

    ASSIGN
        gcLastError = ""
        pcError     = ""
        piArrayId   = 0
        piItems     = 0
        ghJson      = phJson
        gcTempJsonFile = pcJsonFile.

    /* ============================================================
       Validar que el handle JSON sea válido
       ============================================================ */
    IF NOT VALID-HANDLE(ghJson) THEN DO:
        gcLastError = "Handle JSON inválido".
        pcError     = gcLastError.
        RETURN.
    END.

    /* ============================================================
       Validar que el archivo existe
       ============================================================ */
    IF pcJsonFile = "" THEN DO:
        gcLastError = "No se especificó archivo JSON".
        pcError     = gcLastError.
        RETURN.
    END.

    FILE-INFO:FILE-NAME = pcJsonFile.
    IF FILE-INFO:FILE-SIZE <= 0 THEN DO:
        gcLastError = "Archivo JSON vacío o no existe: " + pcJsonFile.
        pcError     = gcLastError.
        RETURN.
    END.

    /* ============================================================
       ? USAR parseFile DEL JSON PARSER
       ============================================================ */
    iRoot = DYNAMIC-FUNCTION(
                "parseFile" IN ghJson,
                0,           /* Tipo: 0 = objeto */
                pcJsonFile   /* Ruta del archivo */
            ) NO-ERROR.

    IF ERROR-STATUS:ERROR OR iRoot <= 0 THEN DO:
        gcLastError = "No fue posible interpretar el JSON: " 
                    + (IF ERROR-STATUS:ERROR THEN ERROR-STATUS:GET-MESSAGE(1) ELSE "").
        pcError     = gcLastError.
        RETURN.
    END.

    /* ============================================================
       Obtener el array y la cantidad de elementos
       ============================================================ */
    giArray = iRoot.

    giItems = DYNAMIC-FUNCTION(
                    "arrayCount" IN ghJson,
                    giArray) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        gcLastError = "No fue posible obtener la cantidad de elementos: " 
                    + ERROR-STATUS:GET-MESSAGE(1).
        pcError     = gcLastError.
        RETURN.
    END.

    ASSIGN
        piArrayId = giArray
        piItems   = giItems.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-JsonInitFromFile_Old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JsonInitFromFile_Old Procedure 
PROCEDURE JsonInitFromFile_Old :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa el parser JSON desde un ARCHIVO TEMPORAL
  Parameters:  phJson      - Handle de la librería JSON
               pcJsonFile  - Ruta del archivo JSON
  Notes:       ? Usa iniJsonFromFile de json10.p
               ? LEE DIRECTAMENTE DEL ARCHIVO - SIN LONGCHAR
               ? Ideal para JSON de CUALQUIER tamaño
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER phJson      AS HANDLE    NO-UNDO.
    DEFINE INPUT  PARAMETER pcJsonFile  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER piArrayId   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER piItems     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcError     AS CHARACTER NO-UNDO.

    DEFINE VARIABLE iFileSize AS INTEGER NO-UNDO.

    ASSIGN
        gcLastError = ""
        pcError     = ""
        piArrayId   = 0
        piItems     = 0
        ghJson      = phJson
        gcTempJsonFile = pcJsonFile.

    /* ============================================================
       Validar que el handle JSON sea válido
       ============================================================ */
    IF NOT VALID-HANDLE(ghJson) THEN DO:
        gcLastError = "Handle JSON inválido".
        pcError     = gcLastError.
        RETURN.
    END.

    /* ============================================================
       Validar que el archivo existe
       ============================================================ */
    IF pcJsonFile = "" THEN DO:
        gcLastError = "No se especificó archivo JSON".
        pcError     = gcLastError.
        RETURN.
    END.

    FILE-INFO:FILE-NAME = pcJsonFile.
    IF FILE-INFO:FILE-SIZE <= 0 THEN DO:
        gcLastError = "Archivo JSON vacío o no existe: " + pcJsonFile.
        pcError     = gcLastError.
        RETURN.
    END.

    iFileSize = FILE-INFO:FILE-SIZE.

    /* ============================================================
       ? USAR iniJsonFromFile DEL JSON PARSER
       ============================================================ */
    /* iniJsonFromFile lee el archivo directamente sin usar LONGCHAR */
    RUN iniJsonFromFile IN ghJson (INPUT pcJsonFile) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        gcLastError = "Error al leer archivo: " + ERROR-STATUS:GET-MESSAGE(1).
        pcError     = gcLastError.
        RETURN.
    END.

    /* ============================================================
       Parsear el JSON usando parseVal
       ============================================================ */
    giRoot = DYNAMIC-FUNCTION(
                    "parseVal" IN ghJson,
                    0,
                    "") NO-ERROR.

    IF ERROR-STATUS:ERROR OR giRoot <= 0 THEN DO:
        gcLastError = "No fue posible interpretar el JSON.".
        pcError     = gcLastError.
        RETURN.
    END.

    giArray = giRoot.

    giItems = DYNAMIC-FUNCTION(
                    "arrayCount" IN ghJson,
                    giArray) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        gcLastError = "No fue posible obtener la cantidad de elementos: " 
                    + ERROR-STATUS:GET-MESSAGE(1).
        pcError     = gcLastError.
        RETURN.
    END.

    ASSIGN
        piArrayId = giArray
        piItems   = giItems.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-JsonInitFromStream) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JsonInitFromStream Procedure 
PROCEDURE JsonInitFromStream :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa el parser JSON desde un archivo (VERSIÓN STREAMING)
  Parameters:  phJson      - Handle de la librería JSON
               pcJsonFile  - Ruta del archivo JSON
  Notes:       ?? Versión experimental para archivos MUY grandes
               ? Lee el archivo completamente en LONGCHAR (sin límite en 10.1C)
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER phJson      AS HANDLE    NO-UNDO.
    DEFINE INPUT  PARAMETER pcJsonFile  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER piArrayId   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER piItems     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcError     AS CHARACTER NO-UNDO.

    DEFINE VARIABLE lcJsonContent AS LONGCHAR NO-UNDO.
    DEFINE VARIABLE cLine AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iFileSize AS INTEGER NO-UNDO.

    ASSIGN
        gcLastError = ""
        pcError     = ""
        piArrayId   = 0
        piItems     = 0
        ghJson      = phJson
        gcTempJsonFile = pcJsonFile.

    IF NOT VALID-HANDLE(ghJson) THEN DO:
        gcLastError = "Handle JSON inválido".
        pcError     = gcLastError.
        RETURN.
    END.

    FILE-INFO:FILE-NAME = pcJsonFile.
    IF FILE-INFO:FILE-SIZE <= 0 THEN DO:
        gcLastError = "Archivo JSON vacío o no existe: " + pcJsonFile.
        pcError     = gcLastError.
        RETURN.
    END.

    /* ? Usar COPY-LOB para cargar el archivo en LONGCHAR */
    /* En Progress 10.1C, LONGCHAR no tiene límite conocido */
    COPY-LOB FILE pcJsonFile TO lcJsonContent.

    IF LENGTH(lcJsonContent) = 0 THEN DO:
        gcLastError = "No se pudo leer el contenido del archivo.".
        pcError     = gcLastError.
        RETURN.
    END.

    /* ? Inicializar el parser con el contenido LONGCHAR */
    RUN iniJson IN ghJson (INPUT lcJsonContent) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        gcLastError = ERROR-STATUS:GET-MESSAGE(1).
        pcError     = gcLastError.
        RETURN.
    END.

    giRoot = DYNAMIC-FUNCTION(
                    "parseVal" IN ghJson,
                    0,
                    "") NO-ERROR.

    IF ERROR-STATUS:ERROR OR giRoot <= 0 THEN DO:
        gcLastError = "No fue posible interpretar el JSON.".
        pcError     = gcLastError.
        RETURN.
    END.

    giArray = giRoot.

    giItems = DYNAMIC-FUNCTION(
                    "arrayCount" IN ghJson,
                    giArray) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        gcLastError = "No fue posible obtener la cantidad de elementos.".
        pcError     = gcLastError.
        RETURN.
    END.

    ASSIGN
        piArrayId = giArray
        piItems   = giItems.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-CurrencyToInteger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CurrencyToInteger Procedure 
FUNCTION CurrencyToInteger RETURNS INTEGER
  ( INPUT pcCurrency AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Convierte código de moneda al formato Continental.
    Notes:  
------------------------------------------------------------------------------*/

  pcCurrency = CAPS(TRIM(pcCurrency)).

    CASE pcCurrency:

        WHEN "SOL" THEN
            RETURN 1.

        WHEN "PEN" THEN
            RETURN 1.

        WHEN "S/" THEN
            RETURN 1.

        WHEN "USD" THEN
            RETURN 2.

        WHEN "DOL" THEN
            RETURN 2.

        WHEN "DOLAR" THEN
            RETURN 2.

        WHEN "DÓLAR" THEN
            RETURN 2.

        OTHERWISE
            RETURN 2.

    END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-NullToBlank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION NullToBlank Procedure 
FUNCTION NullToBlank RETURNS CHARACTER
  ( INPUT pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Convierte NULL, ?, "null" y espacios a cadena vacía.
    Notes:  
------------------------------------------------------------------------------*/

  IF pcValue = ? THEN
        RETURN "".

    pcValue = TRIM(pcValue).

    IF CAPS(pcValue) = "NULL" THEN
        RETURN "".

    RETURN pcValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SafeDate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SafeDate Procedure 
FUNCTION SafeDate RETURNS DATE
  ( INPUT pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Convierte Character a DATE.
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dFecha AS DATE      NO-UNDO.
    DEFINE VARIABLE cFecha AS CHARACTER NO-UNDO.

    ASSIGN
        cFecha = TRIM(pcValue)
        dFecha = ?.

    IF cFecha = ""
    OR CAPS(cFecha) = "NULL" THEN
        RETURN ?.

    /* yyyy-mm-dd */
    IF LENGTH(cFecha) >= 10
    AND SUBSTRING(cFecha,5,1) = "-"
    AND SUBSTRING(cFecha,8,1) = "-" THEN DO:

        dFecha =
            DATE(
                INTEGER(SUBSTRING(cFecha,6,2)),
                INTEGER(SUBSTRING(cFecha,9,2)),
                INTEGER(SUBSTRING(cFecha,1,4))
            ) NO-ERROR.

        IF NOT ERROR-STATUS:ERROR THEN
            RETURN dFecha.
    END.

    /* yyyy/mm/dd */
    IF LENGTH(cFecha) >= 10
    AND SUBSTRING(cFecha,5,1) = "/"
    AND SUBSTRING(cFecha,8,1) = "/" THEN DO:

        dFecha =
            DATE(
                INTEGER(SUBSTRING(cFecha,6,2)),
                INTEGER(SUBSTRING(cFecha,9,2)),
                INTEGER(SUBSTRING(cFecha,1,4))
            ) NO-ERROR.

        IF NOT ERROR-STATUS:ERROR THEN
            RETURN dFecha.
    END.

    /* Intento estándar */
    dFecha = DATE(cFecha) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    RETURN dFecha.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SafeDecimal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SafeDecimal Procedure 
FUNCTION SafeDecimal RETURNS DECIMAL
  ( INPUT pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Convierte Character a Decimal sin generar error.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dValor AS DECIMAL NO-UNDO.

    ASSIGN
        pcValue = NullToBlank(pcValue)
        dValor  = 0.

    IF pcValue = "" THEN
        RETURN 0.

    dValor = DECIMAL(pcValue) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN 0.

    RETURN dValor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SafeInteger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SafeInteger Procedure 
FUNCTION SafeInteger RETURNS INTEGER
  ( INPUT pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Convierte Character a Integer sin error.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iValor AS INTEGER NO-UNDO.

    ASSIGN
        pcValue = NullToBlank(pcValue)
        iValor  = 0.

    IF pcValue = "" THEN
        RETURN 0.

    iValor = INTEGER(pcValue) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN 0.

    RETURN iValor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

