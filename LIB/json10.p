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
/* Variables globales */
DEFINE TEMP-TABLE ttJson NO-UNDO
    FIELD nId   AS INTEGER
    FIELD pId   AS INTEGER
    FIELD nType AS INTEGER
    FIELD nKey  AS CHARACTER
    FIELD nVal  AS CHARACTER
    FIELD nNum  AS DECIMAL
    FIELD nBool AS LOGICAL
    FIELD nIdx  AS INTEGER
    INDEX idx1  nId
    INDEX idx2  pId.

DEFINE VARIABLE gJson AS CHARACTER NO-UNDO.
DEFINE VARIABLE gPos  AS INTEGER   NO-UNDO.
DEFINE VARIABLE gLen  AS INTEGER   NO-UNDO.
DEFINE VARIABLE gNext AS INTEGER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-arrayCount) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD arrayCount Procedure 
FUNCTION arrayCount RETURNS INTEGER (INPUT arrayId AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getArrayId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getArrayId Procedure 
FUNCTION getArrayId RETURNS INTEGER (INPUT parId AS INTEGER, INPUT keyName AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getArrayItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getArrayItem Procedure 
FUNCTION getArrayItem RETURNS INTEGER (INPUT arrayId AS INTEGER, INPUT itemIndex AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNestedVal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNestedVal Procedure 
FUNCTION getNestedVal RETURNS CHARACTER
    (INPUT pRootId AS INTEGER, 
     INPUT pPath AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNum Procedure 
FUNCTION getNum RETURNS DECIMAL FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjId Procedure 
FUNCTION getObjId RETURNS INTEGER (INPUT parId AS INTEGER, INPUT keyName AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getStr Procedure 
FUNCTION getStr RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getVal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getVal Procedure 
FUNCTION getVal RETURNS CHARACTER (INPUT parId AS INTEGER, INPUT keyName AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD parseFile Procedure 
FUNCTION parseFile RETURNS INTEGER
  ( INPUT piType AS INTEGER,
    INPUT pcPath AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseVal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD parseVal Procedure 
FUNCTION parseVal RETURNS INTEGER (INPUT parId AS INTEGER, INPUT keyName AS CHARACTER) FORWARD.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-iniJson) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE iniJson Procedure 
PROCEDURE iniJson :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pJson AS LONGCHAR NO-UNDO.
    
    EMPTY TEMP-TABLE ttJson.
    gJson = pJson.
    gLen = LENGTH(pJson).
    gPos = 1.
    gNext = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-iniJsonFromFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE iniJsonFromFile Procedure 
PROCEDURE iniJsonFromFile :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa el parser JSON directamente desde un archivo
  Parameters:  pcFileName - Ruta del archivo a leer
  Notes:       ? Usa LONGCHAR para COPY-LOB (seguro)
               ? Para archivos muy grandes, usa streaming
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcFileName AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cLine      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lcBuffer   AS LONGCHAR  NO-UNDO.  /* ? LONGCHAR para COPY-LOB */
    DEFINE VARIABLE iFileSize  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iPos       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lFound     AS LOGICAL   NO-UNDO.

    /* ============================================================
       Validar que el archivo existe
       ============================================================ */
    IF pcFileName = "" THEN DO:
        RETURN ERROR "No se especificó archivo".
    END.

    FILE-INFO:FILE-NAME = pcFileName.
    IF FILE-INFO:FILE-SIZE <= 0 THEN DO:
        RETURN ERROR "Archivo no existe o está vacío: " + pcFileName.
    END.

    iFileSize = FILE-INFO:FILE-SIZE.

    /* ============================================================
       ? Para archivos <= 50MB, usar COPY-LOB a LONGCHAR (seguro)
       ============================================================ */
    IF iFileSize <= 50000000 THEN DO:  /* 50MB */
        /* Leer el archivo completo en LONGCHAR */
        COPY-LOB FILE pcFileName TO lcBuffer.
        
        IF LENGTH(lcBuffer) = 0 THEN DO:
            RETURN ERROR "No se pudo leer el archivo: " + pcFileName.
        END.
        
        /* Pasar el LONGCHAR a iniJson */
        RUN iniJson (INPUT lcBuffer) NO-ERROR.
        
        IF ERROR-STATUS:ERROR THEN
            RETURN ERROR "Error al inicializar JSON: " + ERROR-STATUS:GET-MESSAGE(1).
        
        RETURN.
    END.
    
    /* ============================================================
       Para archivos > 50MB: Usar streaming línea por línea
       ============================================================ */
    lcBuffer = "".
    lFound = FALSE.

    DEF VAR cLlave AS CHAR NO-UNDO.
    cLlave = CHR(123).
    
    INPUT FROM VALUE(pcFileName).
    
    REPEAT:
        IMPORT UNFORMATTED cLine.
        
        /* Buscar primer "{" o "[" */
        IF NOT lFound THEN DO:
            iPos = INDEX(cLine, cLlave).
            IF iPos = 0 THEN
                iPos = INDEX(cLine, "[").
            
            IF iPos > 0 THEN DO:
                lFound = TRUE.
                lcBuffer = SUBSTRING(cLine, iPos).
            END.
        END.
        ELSE DO:
            lcBuffer = lcBuffer + CHR(10) + cLine.
        END.
    END.
    
    INPUT CLOSE.

    /* ============================================================
       Verificar que se encontró JSON
       ============================================================ */
    IF NOT lFound OR LENGTH(lcBuffer) = 0 THEN DO:
        RETURN ERROR "No se encontró JSON en el archivo: " + pcFileName.
    END.

    /* ============================================================
       Pasar el contenido al parser usando iniJson
       ============================================================ */
    RUN iniJson (INPUT lcBuffer) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ERROR "Error al inicializar JSON: " + ERROR-STATUS:GET-MESSAGE(1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processObjectArray) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processObjectArray Procedure 
PROCEDURE processObjectArray :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pArrayId AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pCount   AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE vItemId AS INTEGER NO-UNDO.
    DEFINE VARIABLE i AS INTEGER NO-UNDO.
    
    pCount = 0.
    
    IF pArrayId > 0 THEN DO:
        pCount = arrayCount(pArrayId).
        
        DO i = 1 TO pCount:
            vItemId = getArrayItem(pArrayId, i).
            
            /* Procesar cada objeto del array */
            IF vItemId > 0 THEN DO:
                /* Aquí puedes procesar cada objeto según tus necesidades */
                MESSAGE "Procesando objeto " + STRING(i) + 
                        " del array " + STRING(pArrayId)
                    VIEW-AS ALERT-BOX.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readFile Procedure 
PROCEDURE readFile :
/*------------------------------------------------------------------------------
  Purpose:     Lee un archivo JSON y lo carga en el parser
  Parameters:  pcFileName - Ruta del archivo a leer
  Notes:       ? Usa iniJsonFromFile para leer directamente del archivo
               ? Sin LONGCHAR para archivos grandes
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcFileName AS CHARACTER NO-UNDO.

    /* ============================================================
       Validar que el archivo existe
       ============================================================ */
    IF pcFileName = "" THEN DO:
        RETURN ERROR "No se especificó archivo".
    END.

    FILE-INFO:FILE-NAME = pcFileName.
    IF FILE-INFO:FILE-SIZE <= 0 THEN DO:
        RETURN ERROR "Archivo no existe o está vacío: " + pcFileName.
    END.

    /* ============================================================
       ? Inicializar el parser desde el archivo
       ============================================================ */
    RUN iniJsonFromFile (INPUT pcFileName) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ERROR "Error al inicializar JSON: " + ERROR-STATUS:GET-MESSAGE(1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-skipWS) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE skipWS Procedure 
PROCEDURE skipWS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WHILE gPos <= gLen:
        IF SUBSTRING(gJson, gPos, 1) <> " " AND
           SUBSTRING(gJson, gPos, 1) <> CHR(10) AND
           SUBSTRING(gJson, gPos, 1) <> CHR(13) AND
           SUBSTRING(gJson, gPos, 1) <> CHR(9) THEN
            LEAVE.
        gPos = gPos + 1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-arrayCount) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION arrayCount Procedure 
FUNCTION arrayCount RETURNS INTEGER (INPUT arrayId AS INTEGER):
    DEFINE VARIABLE count AS INTEGER NO-UNDO.
    
    FOR EACH ttJson WHERE ttJson.pId = arrayId:
        count = count + 1.
    END.
    
    RETURN count.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getArrayId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getArrayId Procedure 
FUNCTION getArrayId RETURNS INTEGER (INPUT parId AS INTEGER, INPUT keyName AS CHARACTER):
    DEFINE BUFFER b FOR ttJson.
    
    FIND FIRST b WHERE b.pId = parId AND b.nKey = keyName AND b.nType = 4 NO-ERROR.
    IF AVAILABLE b THEN
        RETURN b.nId.
    
    RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getArrayItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getArrayItem Procedure 
FUNCTION getArrayItem RETURNS INTEGER (INPUT arrayId AS INTEGER, INPUT itemIndex AS INTEGER):
    DEFINE BUFFER b FOR ttJson.

    DEFINE VAR inId AS INT NO-UNDO.
    
    FIND FIRST b WHERE b.pId = arrayId AND b.nIdx = itemIndex NO-ERROR.
    IF AVAILABLE b THEN
        /* Ic RETURN b.nId.  */
        inId = b.nId.
        FIND FIRST b WHERE b.pId = inId NO-ERROR.
        IF AVAILABLE b THEN
            RETURN b.nIdx.
    
    RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNestedVal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNestedVal Procedure 
FUNCTION getNestedVal RETURNS CHARACTER
    (INPUT pRootId AS INTEGER, 
     INPUT pPath AS CHARACTER):
    
    DEFINE VARIABLE vParts AS CHARACTER EXTENT 10 NO-UNDO.
    DEFINE VARIABLE vCount AS INTEGER NO-UNDO.
    DEFINE VARIABLE vCurrentId AS INTEGER NO-UNDO.
    DEFINE VARIABLE i AS INTEGER NO-UNDO.
    DEFINE VARIABLE vResult AS CHARACTER NO-UNDO.
    
    /* Separar path por puntos */
    vCount = NUM-ENTRIES(pPath, ".").
    DO i = 1 TO vCount:
        vParts[i] = ENTRY(i, pPath, ".").
    END.
    
    vCurrentId = pRootId.
    vResult = "".
    
    /* Navegar por el path */
    DO i = 1 TO vCount - 1:
        vCurrentId = getObjId(vCurrentId, vParts[i]).
        IF vCurrentId = 0 THEN
            RETURN "".
    END.
    
    /* Última parte es el valor */
    vResult = getVal(vCurrentId, vParts[vCount]).
    
    RETURN vResult.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNum Procedure 
FUNCTION getNum RETURNS DECIMAL:
    DEFINE VARIABLE vNum AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vCh  AS CHARACTER NO-UNDO.
    
    DO WHILE gPos <= gLen:
        vCh = SUBSTRING(gJson, gPos, 1).
        
        IF (vCh >= "0" AND vCh <= "9") OR vCh = "." OR vCh = "-" THEN DO:
            vNum = vNum + vCh.
            gPos = gPos + 1.
        END.
        ELSE
            LEAVE.
    END.
    
    IF vNum = "" THEN
        RETURN 0.
    
    RETURN DECIMAL(vNum).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjId Procedure 
FUNCTION getObjId RETURNS INTEGER (INPUT parId AS INTEGER, INPUT keyName AS CHARACTER):
    DEFINE BUFFER b FOR ttJson.
    
    FIND FIRST b WHERE b.pId = parId AND b.nKey = keyName AND b.nType = 3 NO-ERROR.
    IF AVAILABLE b THEN
        RETURN b.nId.
    
    RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getStr Procedure 
FUNCTION getStr RETURNS CHARACTER:
    DEFINE VARIABLE vStr AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vCh  AS CHARACTER NO-UNDO.
    
    gPos = gPos + 1.
    
    DO WHILE gPos <= gLen:
        vCh = SUBSTRING(gJson, gPos, 1).
        
        IF vCh = '\' THEN DO:
            gPos = gPos + 1.
            vCh = SUBSTRING(gJson, gPos, 1).
            
            IF vCh = '"' THEN vStr = vStr + '"'.
            ELSE IF vCh = '\' THEN vStr = vStr + '\'.
            ELSE IF vCh = 'n' THEN vStr = vStr + CHR(10).
            ELSE IF vCh = 'r' THEN vStr = vStr + CHR(13).
            ELSE IF vCh = 't' THEN vStr = vStr + CHR(9).
            ELSE vStr = vStr + vCh.
        END.
        ELSE IF vCh = '"' THEN DO:
            gPos = gPos + 1.
            RETURN vStr.
        END.
        ELSE DO:
            vStr = vStr + vCh.
        END.
        
        gPos = gPos + 1.
    END.
    
    RETURN vStr.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getVal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getVal Procedure 
FUNCTION getVal RETURNS CHARACTER (INPUT parId AS INTEGER, INPUT keyName AS CHARACTER):
    DEFINE BUFFER b FOR ttJson.
    
    FIND FIRST b WHERE b.pId = parId AND b.nKey = keyName NO-ERROR.
    IF AVAILABLE b THEN DO:
        CASE b.nType:
            WHEN 1 THEN RETURN b.nVal.        /* String */
            WHEN 2 THEN RETURN STRING(b.nNum). /* Number */
            WHEN 5 THEN 
                IF b.nBool THEN RETURN "true".
                ELSE RETURN "false".           /* Boolean */
            WHEN 6 THEN RETURN "null".         /* Null */
        END CASE.
    END.
    
    RETURN "".
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION parseFile Procedure 
FUNCTION parseFile RETURNS INTEGER
  ( INPUT piType AS INTEGER,
    INPUT pcPath AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Parsea un archivo JSON y retorna el ID del elemento raíz
  Parameters:  piType - Tipo de parse (0 = objeto, 1 = array)
               pcPath - Ruta del archivo a leer
  Notes:       ? Usa iniJsonFromFile para leer directamente del archivo
               ? Sin LONGCHAR para archivos grandes
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iRoot AS INTEGER NO-UNDO.

    /* ============================================================
       Validar que el archivo existe
       ============================================================ */
    IF pcPath = "" THEN
        RETURN 0.

    FILE-INFO:FILE-NAME = pcPath.
    IF FILE-INFO:FILE-SIZE <= 0 THEN
        RETURN 0.

    /* ============================================================
       ? Inicializar el parser desde el archivo
       ============================================================ */
    RUN iniJsonFromFile (INPUT pcPath) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN 0.

    /* ============================================================
       Parsear el JSON usando parseVal
       ============================================================ */
    iRoot = parseVal(piType, "") NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN 0.

    RETURN iRoot.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseVal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION parseVal Procedure 
FUNCTION parseVal RETURNS INTEGER (INPUT parId AS INTEGER, INPUT keyName AS CHARACTER):

    DEFINE VARIABLE vId AS INTEGER NO-UNDO.
    DEFINE VARIABLE vStr AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vNum AS DECIMAL NO-UNDO.
    DEFINE VARIABLE vBool AS LOGICAL NO-UNDO.
    DEFINE VARIABLE vCh AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vIdx AS INTEGER NO-UNDO.

    DEFINE VAR cOpenCorchete AS CHAR NO-UNDO.
    DEFINE VAR cCloseCorchete AS CHAR NO-UNDO.

    cOpenCorchete = CHR(123).   /*  '{' */
    cCloseCorchete = CHR(125).  /* '}'. */
    
    RUN skipWS.
    
    IF gPos > gLen THEN
        RETURN 0.
    
    vCh = SUBSTRING(gJson, gPos, 1).
    
    /* Objeto { } */
    IF vCh = cOpenCorchete THEN DO:
        vId = gNext.
        gNext = gNext + 1.
        
        CREATE ttJson.
        ASSIGN ttJson.nId = vId
               ttJson.pId = parId
               ttJson.nKey = keyName
               ttJson.nType = 3
               ttJson.nIdx = vId.
        
        gPos = gPos + 1.
        RUN skipWS.
        
        DO WHILE gPos <= gLen AND SUBSTRING(gJson, gPos, 1) <> "}":
            RUN skipWS.
            
            IF SUBSTRING(gJson, gPos, 1) = '"' THEN DO:
                vStr = getStr().
                
                RUN skipWS.
                
                IF gPos <= gLen AND SUBSTRING(gJson, gPos, 1) = ":" THEN
                    gPos = gPos + 1.
                
                RUN skipWS.
                
                parseVal(vId, vStr).
                
                RUN skipWS.
                
                IF gPos <= gLen AND SUBSTRING(gJson, gPos, 1) = "," THEN DO:
                    gPos = gPos + 1.
                    RUN skipWS.
                END.
            END.
        END.
        
        IF gPos <= gLen AND SUBSTRING(gJson, gPos, 1) = "}" THEN
            gPos = gPos + 1.
        
        RETURN vId.
    END.
    
    /* Array [ ] - CORREGIDO */
    IF vCh = "[" THEN DO:
        vId = gNext.
        gNext = gNext + 1.
        
        CREATE ttJson.
        ASSIGN ttJson.nId = vId
               ttJson.pId = parId
               ttJson.nKey = keyName
               ttJson.nType = 4   /* ARRAY */
               ttJson.nIdx = vId.
        
        gPos = gPos + 1.
        RUN skipWS.
        
        vIdx = 0.
        
        DO WHILE gPos <= gLen AND SUBSTRING(gJson, gPos, 1) <> "]":
            vIdx = vIdx + 1.
            
            /* Crear elemento del array */
            CREATE ttJson.
            ASSIGN ttJson.nId = gNext
                   ttJson.pId = vId
                   ttJson.nKey = "item"
                   ttJson.nIdx = vIdx.
            
            gNext = gNext + 1.
            
            /* Parsear el valor (que puede ser objeto, string, número, etc.) */
            parseVal(ttJson.nId, STRING(vIdx)).
            
            RUN skipWS.
            
            IF gPos <= gLen AND SUBSTRING(gJson, gPos, 1) = "," THEN DO:
                gPos = gPos + 1.
                RUN skipWS.
            END.
        END.
        
        IF gPos <= gLen AND SUBSTRING(gJson, gPos, 1) = "]" THEN
            gPos = gPos + 1.
        
        RETURN vId.
    END.
    
    /* String */
    IF vCh = '"' THEN DO:
        vStr = getStr().
        
        CREATE ttJson.
        ASSIGN ttJson.nId = gNext
               ttJson.pId = parId
               ttJson.nKey = keyName
               ttJson.nType = 1
               ttJson.nVal = vStr
               ttJson.nIdx = gNext.
        
        gNext = gNext + 1.
        RETURN ttJson.nId.
    END.
    
    /* Boolean true */
    IF SUBSTRING(gJson, gPos, 4) = "true" THEN DO:
        CREATE ttJson.
        ASSIGN ttJson.nId = gNext
               ttJson.pId = parId
               ttJson.nKey = keyName
               ttJson.nType = 5
               ttJson.nBool = TRUE
               ttJson.nIdx = gNext.
        
        gNext = gNext + 1.
        gPos = gPos + 4.
        RETURN ttJson.nId.
    END.
    
    /* Boolean false */
    IF SUBSTRING(gJson, gPos, 5) = "false" THEN DO:
        CREATE ttJson.
        ASSIGN ttJson.nId = gNext
               ttJson.pId = parId
               ttJson.nKey = keyName
               ttJson.nType = 5
               ttJson.nBool = FALSE
               ttJson.nIdx = gNext.
        
        gNext = gNext + 1.
        gPos = gPos + 5.
        RETURN ttJson.nId.
    END.
    
    /* Null */
    IF SUBSTRING(gJson, gPos, 4) = "null" THEN DO:
        CREATE ttJson.
        ASSIGN ttJson.nId = gNext
               ttJson.pId = parId
               ttJson.nKey = keyName
               ttJson.nType = 6
               ttJson.nIdx = gNext.
        
        gNext = gNext + 1.
        gPos = gPos + 4.
        RETURN ttJson.nId.
    END.
    
    /* Number */
    IF (vCh >= "0" AND vCh <= "9") OR vCh = "-" THEN DO:
        vNum = getNum().
        
        CREATE ttJson.
        ASSIGN ttJson.nId = gNext
               ttJson.pId = parId
               ttJson.nKey = keyName
               ttJson.nType = 2
               ttJson.nNum = vNum
               ttJson.nVal = STRING(vNum)
               ttJson.nIdx = gNext.
        
        gNext = gNext + 1.
        RETURN ttJson.nId.
    END.
    
    RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

