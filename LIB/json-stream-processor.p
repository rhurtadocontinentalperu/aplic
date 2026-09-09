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

DEFINE INPUT PARAMETER pcJsonFile AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcCodCli   AS CHARACTER NO-UNDO.  /* Opcional */
DEFINE OUTPUT PARAMETER pcReturn  AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pcError   AS CHARACTER NO-UNDO.

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
DEFINE VARIABLE cLine       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cField      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lInArray    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lInObject   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lFirst      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE iLevel      AS INTEGER   NO-UNDO.
DEFINE VARIABLE iLineCount  AS INTEGER   NO-UNDO.
DEFINE VARIABLE cBuffer     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iPos        AS INTEGER   NO-UNDO.
DEFINE VARIABLE iBraceLevel AS INTEGER   NO-UNDO.

/* Variables para campos extraídos */
DEFINE VARIABLE cCodCli     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFchDoc     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFchVto     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodDoc     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNroDoc     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDivision   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFmaPgo     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetSit     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetBco     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetCta     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetStatus  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodigo     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNumero     AS CHARACTER NO-UNDO.
DEFINE VARIABLE dFchDoc     AS DATE      NO-UNDO.
DEFINE VARIABLE dFchVto     AS DATE      NO-UNDO.
DEFINE VARIABLE fImpTot     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE fSdoAct     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE iCodMon     AS INTEGER   NO-UNDO.
DEFINE VARIABLE cLineResult AS CHARACTER NO-UNDO.

DEFINE VARIABLE cLlave AS CHARACTER NO-UNDO.
cLlave = CHR(123).

/* ============================================================
   Inicialización
   ============================================================ */
ASSIGN
    pcReturn  = ""
    pcError   = ""
    lInArray  = FALSE
    lInObject = FALSE
    lFirst    = TRUE
    iLevel    = 0
    iLineCount = 0
    cBuffer   = "".

/* ============================================================
   Validar que el archivo existe
   ============================================================ */
IF pcJsonFile = "" THEN DO:
    pcError = "No se especificó archivo JSON".
    RETURN.
END.

FILE-INFO:FILE-NAME = pcJsonFile.
IF FILE-INFO:FILE-SIZE <= 0 THEN DO:
    pcError = "Archivo JSON vacío o no existe: " + pcJsonFile.
    RETURN.
END.

/* ============================================================
   Procesar archivo línea por línea
   ============================================================ */
INPUT FROM VALUE(pcJsonFile).

REPEAT:
    IMPORT UNFORMATTED cLine.
    iLineCount = iLineCount + 1.
    
    /* ============================================================
       Buscar el inicio del JSON (array "[")
       ============================================================ */
    IF NOT lInArray THEN DO:
        iPos = INDEX(cLine, "[").
        IF iPos > 0 THEN DO:
            lInArray = TRUE.
            /* Si hay más contenido después de "[", procesarlo */
            IF LENGTH(cLine) > iPos THEN
                cLine = SUBSTRING(cLine, iPos + 1).
            ELSE
                NEXT.  /* ? CONTINUE reemplazado por NEXT */
        END.
        ELSE
            NEXT.  /* ? CONTINUE reemplazado por NEXT */
    END.
    
    /* ============================================================
       Si estamos dentro del array, buscar objetos "{"
       ============================================================ */
    IF lInArray AND NOT lInObject THEN DO:
        iPos = INDEX(cLine, cLlave).
        IF iPos > 0 THEN DO:
            lInObject = TRUE.
            iBraceLevel = 0.
            cBuffer = SUBSTRING(cLine, iPos).
            /* Reiniciar variables para el nuevo objeto */
            ASSIGN
                cCodCli    = ""
                cFchDoc    = ""
                cFchVto    = ""
                cCodDoc    = ""
                cNroDoc    = ""
                cDivision  = ""
                cFmaPgo    = ""
                cLetSit    = ""
                cLetBco    = ""
                cLetCta    = ""
                cLetStatus = ""
                cCodigo    = ""
                cNumero    = ""
                dFchDoc    = ?
                dFchVto    = ?
                fImpTot    = 0
                fSdoAct    = 0
                iCodMon    = 0.
            NEXT.  /* ? CONTINUE reemplazado por NEXT */
        END.
        ELSE
            NEXT.  /* ? CONTINUE reemplazado por NEXT */
    END.
    
    /* ============================================================
       Procesar objeto completo (acumular líneas hasta "}")
       ============================================================ */
    IF lInObject THEN DO:
        /* Acumular la línea en el buffer */
        IF cBuffer = "" THEN
            cBuffer = cLine.
        ELSE
            cBuffer = cBuffer + CHR(10) + cLine.
        
        /* Verificar si el objeto está completo */
        iPos = R-INDEX(cBuffer, "}").
        IF iPos > 0 THEN DO:
            /* El objeto está completo, procesarlo */
            RUN processJsonObject(
                INPUT  cBuffer,
                OUTPUT cCodCli,
                OUTPUT cFchDoc,
                OUTPUT cFchVto,
                OUTPUT cCodDoc,
                OUTPUT cNroDoc,
                OUTPUT iCodMon,
                OUTPUT fImpTot,
                OUTPUT fSdoAct,
                OUTPUT cDivision,
                OUTPUT cFmaPgo,
                OUTPUT cLetSit,
                OUTPUT cLetBco,
                OUTPUT cLetCta,
                OUTPUT cLetStatus,
                OUTPUT cCodigo,
                OUTPUT cNumero,
                OUTPUT lOk
            ).
            
            IF lOk THEN DO:
                /* Construir línea de resultado */
                cLineResult = cCodCli + ":"
                            + cFchDoc + ":"
                            + cFchVto + ":"
                            + cCodDoc + ":"
                            + cNroDoc + ":"
                            + STRING(iCodMon,"9") + ":"
                            + TRIM(STRING(fImpTot,"->>>>>>>>9.99")) + ":"
                            + TRIM(STRING(fSdoAct,"->>>>>>>>9.99")) + ":"
                            + cDivision + ":"
                            + cFmaPgo + ":"
                            + cLetSit + ":"
                            + cLetBco + ":"
                            + cLetCta + ":"
                            + cLetStatus + ":"
                            + cCodigo + ":"
                            + cNumero.
                
                /* Acumular en el resultado */
                IF lFirst THEN
                    pcReturn = cLineResult.
                ELSE
                    pcReturn = pcReturn + "," + cLineResult.
                
                lFirst = FALSE.
            END.
            
            /* Limpiar buffer y salir del objeto */
            cBuffer = "".
            lInObject = FALSE.
        END.
    END.
    
END.

INPUT CLOSE.

/* ============================================================
   Verificar que se encontraron datos
   ============================================================ */
IF pcReturn = "" AND pcError = "" THEN pcError = "No se encontraron datos en el archivo JSON".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-extractField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extractField Procedure 
PROCEDURE extractField :
/*------------------------------------------------------------------------------
  Purpose:     Extrae nombre y valor de un campo JSON
  Parameters:  pcLine      - Línea con formato "campo": "valor"
               pcFieldName - Nombre del campo
               pcFieldValue - Valor del campo
  Notes:       Maneja diferentes formatos: strings, números, booleanos
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcLine      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.

    DEFINE VARIABLE iPos1 AS INTEGER NO-UNDO.
    DEFINE VARIABLE iPos2 AS INTEGER NO-UNDO.
    DEFINE VARIABLE cTemp AS CHARACTER NO-UNDO.

    ASSIGN
        pcFieldName = ""
        pcFieldValue = ""
        cTemp = TRIM(pcLine).

    /* ============================================================
       Buscar el nombre del campo (entre comillas)
       ============================================================ */
    IF cTemp BEGINS '"' THEN DO:
        iPos1 = INDEX(cTemp, '"').
        IF iPos1 > 0 THEN DO:
            iPos2 = INDEX(cTemp, '"', iPos1 + 1).
            IF iPos2 > 0 THEN
                pcFieldName = SUBSTRING(cTemp, iPos1 + 1, iPos2 - iPos1 - 1).
        END.
    END.

    /* ============================================================
       Buscar el valor (después de ":")
       ============================================================ */
    iPos1 = INDEX(cTemp, ":").
    IF iPos1 > 0 THEN DO:
        cTemp = TRIM(SUBSTRING(cTemp, iPos1 + 1)).
        
        /* Quitar coma final si existe */
        IF cTemp MATCHES "*,*" THEN
            cTemp = SUBSTRING(cTemp, 1, LENGTH(cTemp) - 1).
        
        cTemp = TRIM(cTemp).
        
        /* Si es string entre comillas */
        IF cTemp BEGINS '"' THEN DO:
            iPos1 = INDEX(cTemp, '"').
            IF iPos1 > 0 THEN DO:
                iPos2 = INDEX(cTemp, '"', iPos1 + 1).
                IF iPos2 > 0 THEN
                    pcFieldValue = SUBSTRING(cTemp, iPos1 + 1, iPos2 - iPos1 - 1).
            END.
        END.
        ELSE DO:
            /* Es número, booleano o null */
            IF cTemp = "null" THEN
                pcFieldValue = "".
            ELSE
                pcFieldValue = cTemp.
        END.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processJsonObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processJsonObject Procedure 
PROCEDURE processJsonObject :
/*------------------------------------------------------------------------------
  Purpose:     Procesa un objeto JSON (una factura o documento)
  Parameters:  pcObject - Objeto JSON completo (puede tener varias líneas)
  Notes:       Extrae campos específicos sin usar json10.p
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcObject     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcCodCli     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFchDoc     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFchVto     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcCodDoc     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcNroDoc     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER piCodMon     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pfImpTot     AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pfSdoAct     AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcDivision   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFmaPgo     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcLetSit     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcLetBco     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcLetCta     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcLetStatus  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcCodigo     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcNumero     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER plOk         AS LOGICAL   NO-UNDO.

    DEFINE VARIABLE cLine      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFieldName AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFieldValue AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iPos       AS INTEGER NO-UNDO.
    DEFINE VARIABLE i          AS INTEGER NO-UNDO.

    ASSIGN
        plOk = FALSE
        pcCodCli   = ""
        pcFchDoc   = ""
        pcFchVto   = ""
        pcCodDoc   = ""
        pcNroDoc   = ""
        piCodMon   = 0
        pfImpTot   = 0
        pfSdoAct   = 0
        pcDivision = ""
        pcFmaPgo   = ""
        pcLetSit   = ""
        pcLetBco   = ""
        pcLetCta   = ""
        pcLetStatus = ""
        pcCodigo   = ""
        pcNumero   = "".

    /* ============================================================
       Procesar cada línea del objeto
       ============================================================ */
    DO i = 1 TO NUM-ENTRIES(pcObject, CHR(10)):
        cLine = ENTRY(i, pcObject, CHR(10)).
        
        /* Buscar campo: "campo": "valor" */
        /*IF cLine MATCHES '*"*": "*' THEN DO:*/
        IF INDEX(cLine, ":") > 0 THEN DO:
            RUN extractField(INPUT cLine, OUTPUT cFieldName, OUTPUT cFieldValue).
            /* Asignar según el nombre del campo */
            CASE cFieldName:
                WHEN "codclie" THEN pcCodCli = cFieldValue.
                WHEN "ClienteCodigo" THEN pcCodCli = cFieldValue.
                WHEN "DocumentoFechaEmision" THEN pcFchDoc = STRING(SafeDate(cFieldValue)).
                WHEN "DocumentoFechaVencimiento" THEN pcFchVto = STRING(SafeDate(cFieldValue)).
                WHEN "DocumentoTipo" THEN pcCodDoc = cFieldValue.
                WHEN "DocumentoNumero" THEN pcNroDoc = cFieldValue.
                WHEN "DocumentoMoneda" THEN piCodMon = CurrencyToInteger(cFieldValue).
                WHEN "DocumentoTotal" THEN pfImpTot = SafeDecimal(cFieldValue).
                WHEN "DocumentoSaldo" THEN pfSdoAct = SafeDecimal(cFieldValue).
                WHEN "DocumentoDivision" THEN pcDivision = cFieldValue.
                WHEN "DocumentoCondicionPago" THEN pcFmaPgo = cFieldValue.
                WHEN "LetraSituacion" THEN pcLetSit = cFieldValue.
                WHEN "LetraBanco" THEN pcLetBco = cFieldValue.
                WHEN "LetraCuentaBancaria" THEN pcLetCta = cFieldValue.
                WHEN "LetraEstado" THEN pcLetStatus = cFieldValue.
                WHEN "coddoc" THEN pcCodigo = cFieldValue.
                WHEN "nrodoc" THEN pcNumero = cFieldValue.
            END CASE.
        END.
    END.

    /* ============================================================
       Validar que tenemos datos mínimos
       ============================================================ */
    IF pcCodCli = "" OR pcFchDoc = "" OR pcNroDoc = "" THEN
        RETURN.

    plOk = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-CurrencyToInteger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CurrencyToInteger Procedure 
FUNCTION CurrencyToInteger RETURNS INTEGER
  ( INPUT pcCurrency AS CHARACTER ) :

    pcCurrency = CAPS(TRIM(pcCurrency)).

    CASE pcCurrency:
        WHEN "SOL"  THEN RETURN 1.
        WHEN "PEN"  THEN RETURN 1.
        WHEN "S/"   THEN RETURN 1.
        WHEN "USD"  THEN RETURN 2.
        WHEN "DOL"  THEN RETURN 2.
        WHEN "DOLAR" THEN RETURN 2.
        WHEN "DÓLAR" THEN RETURN 2.
        OTHERWISE RETURN 1.
    END CASE.


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

    DEFINE VARIABLE dValor AS DECIMAL NO-UNDO.

    pcValue = TRIM(pcValue).
    IF pcValue = "" OR pcValue = "null" THEN
        RETURN 0.

    dValor = DECIMAL(pcValue) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN 0.

    RETURN dValor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

