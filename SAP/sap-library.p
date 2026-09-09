&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tw-report NO-UNDO LIKE w-report.



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
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

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

DEF VAR hJsonUtils AS HANDLE NO-UNDO.
RUN lib/json-utils.p PERSISTENT SET hJsonUtils.

/* ============================================================
   1. DEFINIR LA LIBRERÍA JSON-FILE
   ============================================================ */
DEF VAR hJsonFile AS HANDLE NO-UNDO.
RUN lib/json-utils-file.p PERSISTENT SET hJsonFile.

/* ========================================================
   Cache de Configuración
   ======================================================== */
DEFINE TEMP-TABLE ttConfig NO-UNDO
    FIELD cKey   AS CHARACTER
    FIELD cValue AS CHARACTER
    FIELD dFechaLectura AS DATE
    FIELD tHoraLectura  AS INTEGER
    INDEX idx_key cKey.

DEF STREAM Texto.
DEF STREAM LogTexto.

/*
DEF VAR hJsonStream AS HANDLE NO-UNDO.
RUN lib/json-stream-processor.p PERSISTENT SET hJsonStream.

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

&IF DEFINED(EXCLUDE-getConfigValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getConfigValue Procedure 
FUNCTION getConfigValue RETURNS CHARACTER PRIVATE
    (INPUT pcTabla   AS CHARACTER,
     INPUT pcLlave1  AS CHARACTER,
     INPUT pcLlave2  AS CHARACTER,
     INPUT plRefresh AS LOGICAL) FORWARD.

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
   Temp-Tables and Buffers:
      TABLE: tw-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15.31
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-api_factura_anticipo_pendientes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE api_factura_anticipo_pendientes Procedure 
PROCEDURE api_factura_anticipo_pendientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
        pcReturn: devuelve los artículos válidos
        pcError : devuleve los artículos con errores
------------------------------------------------------------------------------*/

/* Sintaxis
http://192.168.0.232:5500/continental/interfaces/finanzas/facturaanticipo/pendientes
?codcliente=10081846770
*/
/* Formato de Retorno:
    {
        "DocEntry": 38,
        "DocNum": 3,
        "FechaAnticipo": "04-06-2026",
        "CodigoCliente": "CL10081846770",
        "NombreCliente": "HURTADO CALDERON RUBEN",
        "Moneda": "SOL",
        "Referencia_NroBoleta": "01F833-00002577",
        "TotalAnticipo": 29500.0,
        "TotalSinIGV": 25000.0,
        "Aplicaciones": 0.0,
        "SaldoPendiente": 25000.0
    },
*/

DEF INPUT  PARAMETER pcCodCli AS CHAR     NO-UNDO.
DEF OUTPUT PARAMETER pcReturn AS LONGCHAR NO-UNDO.
DEF OUTPUT PARAMETER pcError  AS LONGCHAR NO-UNDO.

/*---------------- Variables ----------------*/
DEFINE VARIABLE xUrl             AS LONGCHAR NO-UNDO.
DEFINE VARIABLE pResult          AS CHARACTER NO-UNDO.
DEFINE VARIABLE pResponse        AS LONGCHAR NO-UNDO.
DEFINE VARIABLE pContent         AS LONGCHAR CASE-SENSITIVE NO-UNDO.
DEFINE VARIABLE pContent2        AS LONGCHAR CASE-SENSITIVE NO-UNDO.

DEFINE VARIABLE cAbrirCorchete   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCerrarCorchete  AS CHARACTER NO-UNDO.

DEFINE VARIABLE raiz             AS INTEGER   NO-UNDO.
DEFINE VARIABLE arrayId          AS INTEGER   NO-UNDO.
DEFINE VARIABLE itemId           AS INTEGER   NO-UNDO.
DEFINE VARIABLE TotalItems       AS INTEGER   NO-UNDO.

DEFINE VARIABLE cCodDoc          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNroDoc          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFchDoc          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMoneda          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValor           AS CHARACTER NO-UNDO.

DEFINE VARIABLE dFchDoc          AS DATE      NO-UNDO.

DEFINE VARIABLE iCodMon          AS INTEGER   NO-UNDO.
DEFINE VARIABLE fImpTot          AS DECIMAL   NO-UNDO.
DEFINE VARIABLE fSdoAct          AS DECIMAL   NO-UNDO.

DEFINE VARIABLE iRegistro        AS INTEGER   NO-UNDO.
DEFINE VARIABLE i                AS INTEGER   NO-UNDO.

ASSIGN
    pcReturn = ""
    pcError  = "".

DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /****************************************************/
    /* Configuración                                    */
    /****************************************************/
    xUrl = getConfigValue("CONFIG-WEB-SAT", "FACTURAANTICIPO", "PENDIENTE", NO).
    IF xUrl = "" THEN DO:
        pcError = "No se encontró la configuración CONFIG-WEB-SAT/FACTURAANTICIPO/PENDIENTE".
        LEAVE.
    END.
    xUrl = xUrl + "?codcliente=" + pcCodCli.
    /*
    FIND FIRST VtaTabla WHERE VtaTabla.CodCia   = s-CodCia
        AND VtaTabla.Tabla    = "CONFIG-WEB-SAT"
        AND VtaTabla.Llave_c1 = "FACTURAANTICIPO"
        AND VtaTabla.Llave_c2 = "PENDIENTE"
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaTabla THEN DO:
        pcError = "No se encontró la configuración CONFIG-WEB-SAT/FACTURAANTICIPO/PENDIENTE".
        LEAVE.
    END.
    xUrl = TRIM(VtaTabla.Libre_c01)
         + "?codcliente="
         + pcCodCli.
    */
    /****************************************************/
    /* HTTP                                             */
    /****************************************************/
    RUN lib/http-get-contenido.r(
            xUrl,
            OUTPUT pResult,
            OUTPUT pResponse,
            OUTPUT pContent)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcError = "Error ejecutando HTTP GET:".
        DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
            pcError = pcError + CHR(10) + ERROR-STATUS:GET-MESSAGE(i).
        END.
        LEAVE.
    END.
    IF TRIM(pContent) = "" THEN DO:
        pcError = "La API respondió sin contenido.".
        LEAVE.
    END.
    IF INDEX(pResult,"0:No Socket") > 0 THEN DO:
        pcError = "No fue posible conectarse al servicio." + CHR(10) + "URL: " + xUrl.
        LEAVE.
    END.
    IF INDEX(pContent,"[]") > 0 THEN LEAVE.

    cAbrirCorchete  = CHR(123).
    cCerrarCorchete = CHR(125).
    pContent2 = REPLACE(pContent,cAbrirCorchete,"[").
    pContent2 = REPLACE(pContent2,cCerrarCorchete,"]").
    IF INDEX(pContent2,"[]") > 0 THEN LEAVE.

    /****************************************************/
    /* JSON                                             */
    /****************************************************/
    RUN JsonInit IN hJsonUtils (INPUT hJson, 
                                INPUT pContent,
                                OUTPUT arrayId,
                                OUTPUT TotalItems,
                                OUTPUT pcError
                                ).
    IF PcError > "" THEN LEAVE.
    IF TotalItems <= 0 THEN LEAVE.

    /****************************************************/
    /* Procesamiento                                    */
    /****************************************************/
    DEF VAR plOk AS LOG NO-UNDO.
    cCodDoc = "A/R".
    DO iRegistro = 1 TO TotalItems:
        DO ON ERROR UNDO, NEXT:
            RUN JsonGetItem IN hJsonUtils (arrayId, iRegistro, OUTPUT itemId, OUTPUT plOk).
            IF plOk = NO THEN NEXT.

            RUN JsonGetChar IN hJsonUtils (itemId, "Referencia_NroBoleta", OUTPUT cNroDoc).
            cFchDoc = "".
            RUN JsonGetDate IN hJsonUtils (itemId, "FechaAnticipo", OUTPUT dFchDoc).
            IF dFchDoc <> ? THEN cFchDoc = STRING(dFchDoc).
            RUN JsonGetCurrency IN hJsonUtils (itemId, "Moneda", OUTPUT iCodMon).
            RUN JsonGetDecimal IN hJsonUtils (itemId, "TotalSinIGV", OUTPUT fImpTot).
            RUN JsonGetDecimal IN hJsonUtils (itemId, "SaldoPendiente", OUTPUT fSdoAct).

            pcReturn = pcReturn
                     + (IF pcReturn = "" THEN "" ELSE ",")
                     + cFchDoc + ":"
                     + cCodDoc + ":"
                     + cNroDoc + ":"
                     + STRING(iCodMon,"9") + ":"
                     + TRIM(STRING(fImpTot,"->>>>>>>>9.99")) + ":"
                     + TRIM(STRING(fSdoAct,"->>>>>>>>9.99")).

        END.
    END.
    RUN JsonDestroy IN hJsonUtils.
END.

/****************************************************/
/* Error general                                    */
/****************************************************/

IF ERROR-STATUS:ERROR
AND pcError = "" THEN DO:
    DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
        pcError = pcError + ERROR-STATUS:GET-MESSAGE(i) + CHR(10).
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-api_od_pendientes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE api_od_pendientes Procedure 
PROCEDURE api_od_pendientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
        pcReturn: devuelve los artículos válidos
        pcError : devuleve los artículos con errores
------------------------------------------------------------------------------*/

/* Sintaxis
http://192.168.0.232:5500/continental/interfaces/ventas/pedidodlogistico/credito/pendientes
?codcliente=10081846770
*/
/* Formato de Retorno:
    {
        "DocEntry": 35,
        "DocNum": 2,
        "Codigo": "CL10081846770",
        "Nombre": "HURTADO CALDERON RUBEN",
        "FechaEmision": "14-05-2026",
        "FechaEntregaComprometida": "15-05-2026",
        "Moneda": "SOL",
        "EstadoDocumento": "O",
        "TotalCompletoSinIGV": 952.22,
        "MontoIGVCompleto": 171.4,
        "GastosAdicionalesFletes": 0.0,
        "TotalCompletoConIGV": 1123.62,
        "Comentarios": "CALLE RENEE DESCARTES 114",
        "EmpleadoDeVentas": "Berta Beatriz Kamigama Kuabara",
        "TipoVenta": "CR",
        "PedidoLogistico": "001129521",
        "OrdenDespacho": "001032383",
        "CodReferencia": null,
        "NroReferencia": "001113151",
        "DivisionVenta": null,
        "DivisionDespacho": null
    },
*/

DEF INPUT  PARAMETER pcCodCli AS CHAR     NO-UNDO.
DEF OUTPUT PARAMETER pcReturn AS LONGCHAR NO-UNDO.
DEF OUTPUT PARAMETER pcError  AS LONGCHAR NO-UNDO.

/*---------------- Variables ----------------*/
DEFINE VARIABLE xUrl             AS LONGCHAR NO-UNDO.
DEFINE VARIABLE pResult          AS CHARACTER NO-UNDO.
DEFINE VARIABLE pResponse        AS LONGCHAR NO-UNDO.
DEFINE VARIABLE pContent         AS LONGCHAR CASE-SENSITIVE NO-UNDO.
DEFINE VARIABLE pContent2        AS LONGCHAR CASE-SENSITIVE NO-UNDO.

DEFINE VARIABLE cAbrirCorchete   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCerrarCorchete  AS CHARACTER NO-UNDO.

DEFINE VARIABLE raiz             AS INTEGER   NO-UNDO.
DEFINE VARIABLE arrayId          AS INTEGER   NO-UNDO.
DEFINE VARIABLE itemId           AS INTEGER   NO-UNDO.
DEFINE VARIABLE TotalItems       AS INTEGER   NO-UNDO.

DEFINE VARIABLE cCodDoc          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNroDoc          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFchDoc          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMoneda          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValor           AS CHARACTER NO-UNDO.

DEFINE VARIABLE dFchDoc          AS DATE      NO-UNDO.

DEFINE VARIABLE iCodMon          AS INTEGER   NO-UNDO.
DEFINE VARIABLE fImpTot          AS DECIMAL   NO-UNDO.

DEFINE VARIABLE iRegistro        AS INTEGER   NO-UNDO.
DEFINE VARIABLE i                AS INTEGER   NO-UNDO.

ASSIGN
    pcReturn = ""
    pcError  = "".

DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /****************************************************/
    /* Configuración                                    */
    /****************************************************/
    FIND FIRST VtaTabla
         WHERE VtaTabla.CodCia   = s-CodCia
           AND VtaTabla.Tabla    = "CONFIG-WEB-SAT"
           AND VtaTabla.Llave_c1 = "ORDENDEDESPACHO"
           AND VtaTabla.Llave_c2 = "PENDIENTE"
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaTabla THEN DO:
        pcError = "No se encontró la configuración CONFIG-WEB-SAT/ORDENDEDESPACHO/PENDIENTE".
        LEAVE.
    END.
    xUrl = TRIM(VtaTabla.Libre_c01) + "?codcliente=" + pcCodCli.

    /****************************************************/
    /* HTTP                                             */
    /****************************************************/
    RUN lib/http-get-contenido.r(
            xUrl,
            OUTPUT pResult,
            OUTPUT pResponse,
            OUTPUT pContent)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcError = "Error ejecutando HTTP GET:".
        DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
            pcError = pcError + CHR(10) + ERROR-STATUS:GET-MESSAGE(i).
        END.
        LEAVE.
    END.
    IF TRIM(pContent) = "" THEN DO:
        pcError = "La API respondió sin contenido.".
        LEAVE.
    END.
    IF INDEX(pResult,"0:No Socket") > 0
        OR INDEX(pResult,"404") > 0
        OR INDEX(pResult,"401") > 0
        OR INDEX(pResult,"500") > 0
        OR INDEX(pResult,"Timeout") > 0 THEN DO:
        pcError =
            "Error consumiendo API."
            + CHR(10)
            + "URL : "
            + xUrl
            + CHR(10)
            + "Detalle : "
            + pResult.

        LEAVE.
    END.
    IF INDEX(pContent,"[]") > 0 THEN LEAVE.
    cAbrirCorchete  = CHR(123).
    cCerrarCorchete = CHR(125).
    pContent2 = REPLACE(pContent,cAbrirCorchete,"[").
    pContent2 = REPLACE(pContent2,cCerrarCorchete,"]").
    IF INDEX(pContent2,"[]") > 0 THEN LEAVE.

    /****************************************************/
    /* JSON                                             */
    /****************************************************/
    RUN JsonInit IN hJsonUtils (INPUT hJson, 
                                INPUT pContent,
                                OUTPUT arrayId,
                                OUTPUT TotalItems,
                                OUTPUT pcError
                                ).
    IF PcError > "" THEN LEAVE.
    IF TotalItems <= 0 THEN LEAVE.

    /****************************************************/
    /* Procesamiento                                    */
    /****************************************************/
    DEF VAR plOk AS LOG NO-UNDO.

    cCodDoc = "O/D".
    DO iRegistro = 1 TO TotalItems:
        DO ON ERROR UNDO, NEXT:
            RUN JsonGetItem IN hJsonUtils (arrayId, iRegistro, OUTPUT itemId, OUTPUT plOk).
            IF plOk = NO THEN NEXT.
            RUN JsonGetChar IN hJsonUtils (itemId, "OrdenDespacho", OUTPUT cNroDoc).
            IF cNroDoc = "" THEN NEXT.
            RUN JsonGetDate IN hJsonUtils (itemId, "FechaEmision", OUTPUT dFchDoc).
            IF dFchDoc <> ? THEN cFchDoc = STRING(dFchDoc).
            RUN JsonGetCurrency IN hJsonUtils (itemId, "Moneda", OUTPUT iCodMon).
            RUN JsonGetDecimal IN hJsonUtils (itemId, "TotalCompletoConIGV", OUTPUT fImpTot).
            
            pcReturn = pcReturn + 
                        (IF pcReturn = "" THEN "" ELSE ",")
                     + cFchDoc + ":"
                     + cCodDoc + ":"
                     + cNroDoc + ":"
                     + STRING(iCodMon,"9") + ":"
                     + TRIM(STRING(fImpTot,"->>>>>>>>9.99")).

        END.
    END.
    RUN JsonDestroy IN hJsonUtils.
END.

/****************************************************/
/* Error general                                    */
/****************************************************/
IF ERROR-STATUS:ERROR AND pcError = "" THEN DO:
    DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
        pcError = pcError + ERROR-STATUS:GET-MESSAGE(i) + CHR(10).
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-api_pagos_recibidos_pendientes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE api_pagos_recibidos_pendientes Procedure 
PROCEDURE api_pagos_recibidos_pendientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
        pcReturn: devuelve los artículos válidos
        pcError : devuleve los artículos con errores
------------------------------------------------------------------------------*/

DEF INPUT  PARAMETER pcCodCli AS CHAR     NO-UNDO.
DEF OUTPUT PARAMETER pcReturn AS LONGCHAR NO-UNDO.
DEF OUTPUT PARAMETER pcError  AS LONGCHAR NO-UNDO.

/*---------------- Variables ----------------*/
DEFINE VARIABLE xUrl             AS LONGCHAR NO-UNDO.
DEFINE VARIABLE pResult          AS CHARACTER NO-UNDO.
DEFINE VARIABLE pResponse        AS LONGCHAR NO-UNDO.
DEFINE VARIABLE pContent         AS LONGCHAR CASE-SENSITIVE NO-UNDO.
DEFINE VARIABLE pContent2        AS LONGCHAR CASE-SENSITIVE NO-UNDO.
DEFINE VARIABLE cAbrirCorchete   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCerrarCorchete  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDateFormat      AS CHARACTER NO-UNDO.
DEFINE VARIABLE i               AS INTEGER   NO-UNDO.

DEFINE VARIABLE raiz            AS INTEGER NO-UNDO.
DEFINE VARIABLE arrayId         AS INTEGER NO-UNDO.
DEFINE VARIABLE itemId          AS INTEGER NO-UNDO.
DEFINE VARIABLE TotalItems      AS INTEGER NO-UNDO.

DEFINE VARIABLE cCodDoc         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNroDoc         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMoneda         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValor          AS CHARACTER NO-UNDO.
DEFINE VARIABLE dFchDoc         AS DATE NO-UNDO.
DEFINE VARIABLE iCodMon         AS INTEGER NO-UNDO.
DEFINE VARIABLE fImpTot         AS DECIMAL NO-UNDO.
DEFINE VARIABLE fSdoAct         AS DECIMAL NO-UNDO.

DEFINE VARIABLE cFchDoc         AS CHARACTER NO-UNDO.

DEFINE VARIABLE iRegistro       AS INTEGER NO-UNDO.

pcReturn = "".
pcError  = "".

DO ON ERROR UNDO, LEAVE ON STOP  UNDO, LEAVE:
    /*----------------------------------------------------*/
    /* Obtiene configuración                              */
    /*----------------------------------------------------*/
    FIND FIRST VtaTabla WHERE VtaTabla.CodCia   = s-CodCia
        AND VtaTabla.Tabla    = "CONFIG-WEB-SAT"
        AND VtaTabla.Llave_c1 = "PAGORECIBIDO"
        AND VtaTabla.Llave_c2 = "PENDIENTE"
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaTabla THEN DO:
        pcError = "No existe la configuración CONFIG-WEB-SAT/PAGORECIBIDO/PENDIENTE".
        LEAVE.
    END.
    xUrl = TRIM(VtaTabla.Libre_c01) + "?codcliente=" + pcCodCli.

    /*----------------------------------------------------*/
    /* Invoca API                                         */
    /*----------------------------------------------------*/
    RUN lib/http-get-contenido.r
        (xUrl,
         OUTPUT pResult,
         OUTPUT pResponse,
         OUTPUT pContent)
         NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcError = "Error ejecutando HTTP GET:" + CHR(10).
        DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
            pcError = pcError + ERROR-STATUS:GET-MESSAGE(i) + CHR(10).
        END.
        LEAVE.
    END.

    /*----------------------------------------------------*/
    /* Validaciones HTTP                                  */
    /*----------------------------------------------------*/
    IF TRIM(pContent) = "" THEN DO:
        pcError = "La API respondió sin contenido.".
        LEAVE.
    END.
    IF pResult <> "" THEN DO:
        IF INDEX(pResult,"0:") > 0
            OR INDEX(pResult,"404") > 0
            OR INDEX(pResult,"401") > 0
            OR INDEX(pResult,"500") > 0
            OR INDEX(pResult,"Timeout") > 0 THEN DO:
            pcError = "Error consumiendo API." + CHR(10) + "URL : " + xUrl + CHR(10)
                + "Detalle : " + pResult.
            LEAVE.
        END.
    END.

    /*----------------------------------------------------*/
    /* No existen documentos                              */
    /*----------------------------------------------------*/
    IF INDEX(pContent,"[]") > 0 THEN LEAVE.

    cAbrirCorchete  = CHR(123).
    cCerrarCorchete = CHR(125).

    pContent2 = REPLACE(pContent,cAbrirCorchete,"[").
    pContent2 = REPLACE(pContent2,cCerrarCorchete,"]").

    IF INDEX(pContent2,"[]") > 0 THEN LEAVE.

    /*----------------------------------------------------*/
    /* JSON                                               */
    /*----------------------------------------------------*/
    RUN JsonInit IN hJsonUtils (INPUT hJson, 
                                INPUT pContent,
                                OUTPUT arrayId,
                                OUTPUT TotalItems,
                                OUTPUT pcError
                                ).
    IF PcError > "" THEN LEAVE.
    IF TotalItems <= 0 THEN LEAVE.

    /*----------------------------------------------------*/
    /* Procesamiento                                      */
    /*----------------------------------------------------*/
    DEF VAR plOk AS LOG NO-UNDO.

/*     cDateFormat = SESSION:DATE-FORMAT. */
/*     SESSION:DATE-FORMAT = "ymd".       */
    DO iRegistro = 1 TO TotalItems:
        DO ON ERROR UNDO,NEXT:
            RUN JsonGetItem IN hJsonUtils (arrayId, iRegistro, OUTPUT itemId, OUTPUT plOk).
            IF plOk = NO THEN NEXT.

            RUN JsonGetChar IN hJsonUtils (itemId, "coddoc", OUTPUT cCodDoc).
            RUN JsonGetChar IN hJsonUtils (itemId, "nrodoc", OUTPUT cNroDoc).

            cFchDoc = "".
            RUN JsonGetDate IN hJsonUtils (itemId, "FechaContabilizacion", OUTPUT dFchDoc).
            IF dFchDoc <> ? THEN cFchDoc = STRING(dFchDoc).

            RUN JsonGetCurrency IN hJsonUtils (itemId, "Moneda", OUTPUT iCodMon).
            RUN JsonGetDecimal IN hJsonUtils (itemId, "TotalRecibido", OUTPUT fImpTot).
            RUN JsonGetDecimal IN hJsonUtils (itemId, "SaldoDisponible", OUTPUT fSdoAct).
            
            pcReturn = pcReturn
                     + (IF pcReturn = "" THEN "" ELSE ",")
                     + cFchDoc
                     + ":"
                     + cCodDoc
                     + ":"
                     + cNroDoc
                     + ":"
                     + STRING(iCodMon)
                     + ":"
                     + TRIM(STRING(fImpTot,"->>>>>>>>9.99"))
                     + ":"
                     + TRIM(STRING(fSdoAct,"->>>>>>>>9.99")).
        END.
    END.
/*     SESSION:DATE-FORMAT = cDateFormat. */
END.
/*----------------------------------------------------*/
/* Restaurar siempre el formato de fecha              */
/*----------------------------------------------------*/
/* IF SESSION:DATE-FORMAT <> cDateFormat THEN SESSION:DATE-FORMAT = cDateFormat. */

/*----------------------------------------------------*/
/* Error general                                      */
/*----------------------------------------------------*/

IF ERROR-STATUS:ERROR AND pcError = "" THEN DO:
    DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
        pcError = pcError + ERROR-STATUS:GET-MESSAGE(i) + CHR(10).
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-AC-Pendientes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-AC-Pendientes Procedure 
PROCEDURE Carga-AC-Pendientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Solicitamos la información */
  DEF INPUT PARAMETER pcCodDoc AS CHAR NO-UNDO.
  DEF INPUT PARAMETER pcCodCli AS CHAR NO-UNDO.
  DEF PARAMETER BUFFER btw-report FOR tw-report.
  DEF OUTPUT PARAMETER pcReturn AS LONGCHAR NO-UNDO.
  DEF OUTPUT PARAMETER pcError  AS LONGCHAR NO-UNDO.

  FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = pcCodCli NO-LOCK.

  EMPTY TEMP-TABLE btw-report.

  RUN api_factura_anticipo_pendientes (INPUT pcCodCli,
                                       OUTPUT pcReturn,
                                       OUTPUT pcError).
  IF pcError > '' THEN RETURN.
  IF TRUE <> (pcReturn > '') THEN RETURN.

  /* Cargamos el temporal */
  DEF VAR iLinea AS INTE NO-UNDO.
  DEF VAR cLinea AS CHAR NO-UNDO.
  DEF VAR cCodDoc AS CHAR NO-UNDO.

  DO iLinea = 1 TO NUM-ENTRIES(pcReturn,','):
      cLinea = ENTRY(iLinea,pcReturn,',').
      CREATE btw-report.
      ASSIGN
          btw-report.campo-c[1] = ENTRY(2,cLinea,':')
          btw-report.campo-c[2] = ENTRY(3,cLinea,':')
          btw-report.campo-c[3] = gn-clie.NomCli
          btw-report.campo-c[4] = ENTRY(1,cLinea,':')
          btw-report.campo-c[5] = (IF ENTRY(4,cLinea,':') = "1" THEN "PEN" ELSE "DOL")
          btw-report.campo-c[6] = ENTRY(6,cLinea,':')
          btw-report.Campo-I[1] = INTEGER(ENTRY(4,cLinea,':'))
          btw-report.campo-f[1] = DECIMAL(ENTRY(5,cLinea,':'))
          btw-report.campo-f[2] = DECIMAL(ENTRY(6,cLinea,':'))
          .
  END.

END PROCEDURE.

/* Formato: Todo en formato Progress
    <FchDoc1>:<CodDoc1>:<NroDoc1>:<Moneda1>:<Importe1>:<Saldo1>[,<FchDoc2>:<CodDoc2>:<NroDoc2>:<Moneda2>:<Importe2>:<Saldo2>,[...]]
    FchDoc1 = "dd/mm/yyyy"
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-EECC-Pendientes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-EECC-Pendientes Procedure 
PROCEDURE Carga-EECC-Pendientes :
/*------------------------------------------------------------------------------
  Purpose: Carga Estado de Cuenta Pendientes
  Notes:   Usa json-stream-processor.p para archivos grandes
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pcCodCli AS CHAR NO-UNDO.
DEF PARAMETER BUFFER btw-report FOR tw-report.
DEF OUTPUT PARAMETER pcReturn AS LONGCHAR NO-UNDO.
DEF OUTPUT PARAMETER pcError  AS LONGCHAR NO-UNDO.

/*--------------------------------------------------------------------------*/
/* Variables                                                                */
/*--------------------------------------------------------------------------*/

DEFINE VARIABLE pcMaster       AS CHARACTER NO-UNDO.
DEFINE VARIABLE pcRelacionados AS CHARACTER NO-UNDO.
DEFINE VARIABLE pcAgrupados    AS LOGICAL   NO-UNDO.

DEFINE VARIABLE iLinea         AS INTEGER   NO-UNDO.
DEFINE VARIABLE iCampos        AS INTEGER   NO-UNDO.
DEFINE VARIABLE cLinea         AS CHARACTER NO-UNDO.
DEFINE VARIABLE iError         AS INTEGER   NO-UNDO.

/* ? Variables para HTTP y procesamiento JSON */
DEFINE VARIABLE xUrl           AS LONGCHAR NO-UNDO.
DEFINE VARIABLE pResult        AS CHARACTER NO-UNDO.
DEFINE VARIABLE pTempFile      AS CHARACTER NO-UNDO.
DEFINE VARIABLE pContent       AS LONGCHAR NO-UNDO.
DEFINE VARIABLE lcJsonResult   AS LONGCHAR NO-UNDO.
DEFINE VARIABLE cJsonError     AS CHARACTER NO-UNDO.

/*--------------------------------------------------------------------------*/
/* Inicialización                                                           */
/*--------------------------------------------------------------------------*/

ASSIGN
    pcReturn = ""
    pcError  = "". 
    lcJsonResult = "".

EMPTY TEMP-TABLE btw-report.

/*--------------------------------------------------------------------------*/
/* Protección general                                                       */
/*--------------------------------------------------------------------------*/

DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /*--------------------------------------------------------------*/
    /* Validación parámetros                                        */
    /*--------------------------------------------------------------*/
    IF TRIM(pcCodCli) = "" THEN DO:
        pcError = "No se recibió el código del cliente.".
        LEAVE.
    END.

    /*--------------------------------------------------------------*/
    /* Obtiene Cliente Master                                       */
    /*--------------------------------------------------------------*/
    RUN ccb/p-cliente-master
    (
        INPUT  pcCodCli,
        OUTPUT pcMaster,
        OUTPUT pcRelacionados,
        OUTPUT pcAgrupados
    )
    NO-ERROR.
    
    IF ERROR-STATUS:ERROR THEN DO:
        pcError = "Error ejecutando ccb/p-cliente-master.".
        DO iError = 1 TO ERROR-STATUS:NUM-MESSAGES:
            pcError = pcError + CHR(10) + ERROR-STATUS:GET-MESSAGE(iError).
        END.
        LEAVE.
    END.
    
    IF NOT (pcAgrupados = YES AND TRIM(pcRelacionados) > "") THEN 
        pcRelacionados = pcCodCli.

    /*--------------------------------------------------------------*/
    /* Obtener URL de configuración                                 */
    /*--------------------------------------------------------------*/
    xUrl = getConfigValue("CONFIG-WEB-SAT", "ESTADODECUENTA", "PENDIENTE", NO).
    IF xUrl = "" THEN DO:
        pcError = "No se encontró la configuración CONFIG-WEB-SAT/ESTADODECUENTA/PENDIENTE".
        LEAVE.
    END.
    xUrl = xUrl + "?listaclientes=" + pcRelacionados.

    /*--------------------------------------------------------------*/
    /* Llamada HTTP - Obtener archivo temporal                      */
    /*--------------------------------------------------------------*/
    RUN lib/http-get-contenido-file-v2.p(
            xUrl,
            OUTPUT pResult,
            OUTPUT pTempFile,
            OUTPUT pContent
        ) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcError = "Error ejecutando HTTP GET:".
        DO iError = 1 TO ERROR-STATUS:NUM-MESSAGES:
            pcError = pcError + CHR(10) + ERROR-STATUS:GET-MESSAGE(iError).
        END.
        LEAVE.
    END.
    
    IF pResult <> "1:Success" THEN DO:
        pcError = "Error en HTTP: " + pResult.
        LEAVE.
    END.
    
    IF pTempFile = "" THEN DO:
        pcError = "No se recibió archivo temporal".
        LEAVE.
    END.
    
    FILE-INFO:FILE-NAME = pTempFile.
    IF FILE-INFO:FILE-SIZE <= 0 THEN DO:
        pcError = "El archivo temporal está vacío: " + pTempFile.
        LEAVE.
    END.

    /* ? Verificar que el archivo contiene JSON */
    DEFINE VARIABLE cFirstLine AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cLlave AS CHARACTER NO-UNDO.

    INPUT FROM VALUE(pTempFile).
    IMPORT UNFORMATTED cFirstLine.
    INPUT CLOSE.
    IF cFirstLine = "" OR (INDEX(cFirstLine, cLlave) = 0 AND INDEX(cFirstLine, "[") = 0) THEN DO:
        pcError = "El archivo no contiene JSON válido: " + pTempFile.
        LEAVE.
    END.

    /*--------------------------------------------------------------*/
    /* ? PROCESAR JSON CON STREAM PROCESSOR                        */
    /*--------------------------------------------------------------*/
    RUN lib/json-stream-processor.p(
            INPUT  pTempFile,
            INPUT  pcRelacionados,
            OUTPUT lcJsonResult,
            OUTPUT cJsonError
        ).
    
    IF cJsonError > "" THEN DO:
        pcError = cJsonError.
        LEAVE.
    END.
    
    IF TRIM(lcJsonResult) = "" THEN DO:
        /* No hay datos, salir */
        OS-DELETE VALUE(pTempFile) NO-ERROR.
        LEAVE.
    END.

    /*--------------------------------------------------------------*/
    /* Procesamiento de líneas                                      */
    /*--------------------------------------------------------------*/
    pcReturn = lcJsonResult.
    
    DO iLinea = 1 TO NUM-ENTRIES(pcReturn, ","):
        cLinea = ENTRY(iLinea, pcReturn, ",").
        IF TRIM(cLinea) = "" THEN NEXT.
        
        /*----------------------------------------------------------*/
        /* Validar cantidad de columnas                             */
        /*----------------------------------------------------------*/
        iCampos = NUM-ENTRIES(cLinea, ":").
        IF iCampos < 16 THEN DO:
            pcError = pcError
                    + (IF pcError = "" THEN "" ELSE CHR(10))
                    + "Registro " + STRING(iLinea) + " descartado. "
                    + "Se esperaban 16 columnas y llegaron " + STRING(iCampos).
            NEXT.
        END.
        
        /*----------------------------------------------------------*/
        /* Crear registro en la tabla temporal                      */
        /*----------------------------------------------------------*/
        DO ON ERROR UNDO, NEXT:
            CREATE btw-report.
            ASSIGN
                btw-report.campo-c[1]  = ENTRY(1 ,cLinea, ":")
                btw-report.campo-c[2]  = ENTRY(2 ,cLinea, ":")
                btw-report.campo-c[3]  = ENTRY(3 ,cLinea, ":")
                btw-report.campo-c[4]  = ENTRY(4 ,cLinea, ":")
                btw-report.campo-c[5]  = ENTRY(5 ,cLinea, ":")
                btw-report.campo-c[6]  = ENTRY(6 ,cLinea, ":")
                btw-report.campo-c[7]  = ENTRY(7 ,cLinea, ":")
                btw-report.campo-c[8]  = ENTRY(8 ,cLinea, ":")
                btw-report.campo-c[9]  = ENTRY(9 ,cLinea, ":")
                btw-report.campo-c[10] = ENTRY(10,cLinea, ":")
                btw-report.campo-c[11] = ENTRY(11,cLinea, ":")
                btw-report.campo-c[12] = ENTRY(12,cLinea, ":")
                btw-report.campo-c[13] = ENTRY(13,cLinea, ":")
                btw-report.campo-c[14] = ENTRY(14,cLinea, ":")
                btw-report.campo-c[15] = ENTRY(15,cLinea, ":")
                btw-report.campo-c[16] = ENTRY(16,cLinea, ":").

            /* Normalizar valores "null" */
            DO iError = 1 TO 16:
                IF TRIM(LC(btw-report.campo-c[iError])) = "null" THEN 
                    btw-report.campo-c[iError] = "".
            END.
            /*------------------------------------------------------*/
            /* Fecha Documento                                      */
            /*------------------------------------------------------*/
            IF btw-report.campo-c[2] > "" THEN DO:
                btw-report.campo-d[1] = DATE(btw-report.campo-c[2]) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN 
                    ASSIGN
                        ERROR-STATUS:ERROR = NO
                        btw-report.campo-d[1] = ?.
            END.
            /*------------------------------------------------------*/
            /* Fecha Vencimiento                                    */
            /*------------------------------------------------------*/
            IF btw-report.campo-c[3] > "" THEN DO:
                btw-report.campo-d[2] = DATE(btw-report.campo-c[3]) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                    ASSIGN
                        ERROR-STATUS:ERROR = NO
                        btw-report.campo-d[1] = ?.
            END.
            /*------------------------------------------------------*/
            /* Moneda                                                */
            /*------------------------------------------------------*/
            IF btw-report.campo-c[6] > "" THEN DO:
                btw-report.campo-i[1] = INTEGER(btw-report.campo-c[6]) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                    ASSIGN
                        ERROR-STATUS:ERROR = NO
                        btw-report.campo-i[1] = 0.
            END.
            ELSE btw-report.campo-i[1] = 0.
            /*------------------------------------------------------*/
            /* Importe                                               */
            /*------------------------------------------------------*/
            IF btw-report.campo-c[7] > "" THEN DO:
                btw-report.campo-f[1] = DECIMAL(btw-report.campo-c[7]) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                    ASSIGN
                        ERROR-STATUS:ERROR = NO
                        btw-report.campo-f[1] = 0.
            END.
            ELSE btw-report.campo-f[1] = 0.
            /*------------------------------------------------------*/
            /* Saldo                                                 */
            /*------------------------------------------------------*/
            IF btw-report.campo-c[8] > "" THEN DO:
                btw-report.campo-f[2] = DECIMAL(btw-report.campo-c[8]) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                    ASSIGN
                        ERROR-STATUS:ERROR = NO
                        btw-report.campo-f[2] = 0.
            END.
            ELSE btw-report.campo-f[2] = 0.
            /*------------------------------------------------------*/
            /* Validaciones mínimas                                 */
            /*------------------------------------------------------*/
             IF btw-report.campo-c[4] = "" THEN NEXT.
             IF btw-report.campo-c[5] = "" THEN NEXT.
            /*----------------------------------------------------------*/
            /* Adecuaciones para documentos BD e I/C                    */
            /*----------------------------------------------------------*/
            IF LOOKUP(TRIM(btw-report.campo-c[15]),"I/C,BD") > 0 THEN DO:
                CASE TRIM(btw-report.campo-c[15]):
                    WHEN "BD" THEN DO:
                        ASSIGN
                            btw-report.campo-c[4] = "BD"
                            btw-report.campo-c[5] = btw-report.campo-c[16].
                        FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                              AND Ccbcdocu.coddoc = "BD"
                              AND Ccbcdocu.nrodoc = btw-report.campo-c[16]
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE Ccbcdocu THEN DO:
                            FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
                                  AND gn-divi.coddiv = Ccbcdocu.coddiv
                                NO-LOCK NO-ERROR.
                            IF AVAILABLE gn-divi THEN btw-report.campo-c[9] = gn-divi.desdiv.
                            FIND FIRST gn-convt WHERE gn-convt.codig = Ccbcdocu.fmapgo
                                NO-LOCK NO-ERROR.
                            IF AVAILABLE gn-convt THEN btw-report.campo-c[10] = gn-convt.nombr.
                        END.
                    END.
                    WHEN "I/C" THEN DO:
                        ASSIGN
                            btw-report.campo-c[4] = "I/C"
                            btw-report.campo-c[5] = btw-report.campo-c[16].
                        FIND FIRST Ccbccaja WHERE Ccbccaja.codcia = s-codcia
                              AND Ccbccaja.coddoc = "I/C"
                              AND Ccbccaja.nrodoc = btw-report.campo-c[16]
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE Ccbccaja THEN DO:
                            IF LENGTH(Ccbccaja.Voucher[1]) >= 3 THEN btw-report.campo-c[4] = SUBSTRING(Ccbccaja.Voucher[1],1,3).
                            IF LENGTH(Ccbccaja.Voucher[1]) >= 4 THEN btw-report.campo-c[5] = SUBSTRING(Ccbccaja.Voucher[1],4).
                            FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
                                  AND gn-divi.coddiv = Ccbccaja.coddiv
                                NO-LOCK NO-ERROR.
                            IF AVAILABLE gn-divi THEN btw-report.campo-c[9] = gn-divi.desdiv.
                            FIND FIRST gn-convt WHERE gn-convt.codig = Ccbccaja.codcta[10]
                                NO-LOCK NO-ERROR.
                            IF AVAILABLE gn-convt THEN btw-report.campo-c[10] = gn-convt.nombr.
                        END.
                    END.
                END CASE.
            END.
            /*----------------------------------------------------------*/
            /* Completa División y Forma de Pago                        */
            /*----------------------------------------------------------*/
            IF LOOKUP(TRIM(btw-report.campo-c[4]), "FACTURA,BOLETA,NOTA DE CREDITO") > 0 
                AND btw-report.campo-c[9] = "" THEN DO:
                DEFINE VARIABLE cCodDoc AS CHARACTER NO-UNDO.
                DEFINE VARIABLE cNroDoc AS CHARACTER NO-UNDO.
                DEFINE VARIABLE cSerie  AS CHARACTER NO-UNDO.
    
                ASSIGN
                    cCodDoc = ""
                    cNroDoc = ""
                    cSerie  = "".
                IF NUM-ENTRIES(btw-report.campo-c[5],"-") = 2 THEN DO:
                    cSerie = ENTRY(1,btw-report.campo-c[5],"-").
                    IF LENGTH(cSerie) >= 4 THEN DO:
                        IF SUBSTRING(cSerie,1,1) = "F" THEN cCodDoc = "FAC".
                        ELSE cCodDoc = "BOL".
                        cNroDoc = SUBSTRING(cSerie,2,3) + ENTRY(2,btw-report.campo-c[5],"-").
                    END.
                END.
                IF btw-report.campo-c[4] = "NOTA DE CREDITO" THEN cCodDoc = "N/C".
                IF cCodDoc > "" AND cNroDoc > "" THEN DO:
                    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                          AND Ccbcdocu.coddoc = cCodDoc
                          AND Ccbcdocu.nrodoc = cNroDoc
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Ccbcdocu THEN DO:
                        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
                              AND gn-divi.coddiv = Ccbcdocu.divori
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE gn-divi THEN btw-report.campo-c[9] = gn-divi.desdiv.
                        IF TRIM(btw-report.campo-c[10]) BEGINS 'ANTICIPO DE CAMPA' THEN btw-report.campo-c[4] = "A/C".
                        FIND FIRST gn-convt WHERE gn-convt.codig = Ccbcdocu.fmapgo NO-LOCK NO-ERROR.
                        IF AVAILABLE gn-convt THEN btw-report.campo-c[10] = gn-convt.nombr.
                    END.
                END.
            END.
            FIND Facdocum WHERE FacDocum.CodCia = s-codcia AND FacDocum.CodDoc = btw-report.campo-c[4] NO-LOCK NO-ERROR.
            IF AVAILABLE Facdocum THEN btw-report.campo-c[4] = FacDocum.NomDoc.

        END.
    END.
    /* ? Eliminar archivo temporal */
    OS-DELETE VALUE(pTempFile) NO-ERROR.
END.    /* DO ON ERROR */

     /*--------------------------------------------------------------*/
     /* Captura errores generales                                    */
/*--------------------------------------------------------------*/
IF ERROR-STATUS:ERROR AND pcError = "" THEN DO:
    DO iError = 1 TO ERROR-STATUS:NUM-MESSAGES:
        pcError = pcError + ERROR-STATUS:GET-MESSAGE(iError) + CHR(10).
    END.
END.

END PROCEDURE.

/* Formato: Todo en formato Progress
        1        2         3         4         5         6         7         8          9         10
    <CodCli>:<FchDoc1>:<FchVto1>:<CodDoc1>:<NroDoc1>:<Moneda1>:<ImpTot1>:<SdoAct1>.<División1>:<FmaPgo1>:~
       11         12       13         14       15        16
    <LetSit1>:<LetBco1>:<LetCta1>:<LetStat1>:<Codigo1>:>Numero1>[,,
    FchDoc1 = "yyyy-mm-dd"
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-OD-Pendientes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-OD-Pendientes Procedure 
PROCEDURE Carga-OD-Pendientes PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Solicitamos la información */
DEF INPUT PARAMETER pcCodDoc AS CHAR NO-UNDO.
DEF INPUT PARAMETER pcCodCli AS CHAR NO-UNDO.

DEF PARAMETER BUFFER btw-report FOR tw-report.

DEF OUTPUT PARAMETER pcReturn AS LONGCHAR NO-UNDO.
DEF OUTPUT PARAMETER pcError  AS LONGCHAR NO-UNDO.

/* Variables locales */
DEF BUFFER ORDENES FOR Faccpedi.

DEF VAR iLinea      AS INTE NO-UNDO.
DEF VAR cLinea      AS CHAR NO-UNDO.
DEF VAR cNroDoc     AS CHAR NO-UNDO.
DEF VAR iCodMon     AS INTE NO-UNDO.
DEF VAR dImporte    AS DECI NO-UNDO.
DEF VAR iError      AS INTE NO-UNDO.

ASSIGN
    pcError  = ""
    pcReturn = "".

EMPTY TEMP-TABLE btw-report.

DO ON ERROR UNDO, LEAVE:
    /*-----------------------------------------------------*/
    /* Obtiene órdenes pendientes desde la API             */
    /*-----------------------------------------------------*/
    RUN api_od_pendientes (
        INPUT  pcCodCli,
        OUTPUT pcReturn,
        OUTPUT pcError
    ) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcError = "Error ejecutando api_od_pendientes:" + CHR(10).
        DO iError = 1 TO ERROR-STATUS:NUM-MESSAGES:
            pcError = pcError + ERROR-STATUS:GET-MESSAGE(iError) + CHR(10).
        END.
        LEAVE.
    END.
    IF pcError > "" THEN LEAVE.
    IF TRIM(pcReturn) = "" THEN LEAVE.

    /*-----------------------------------------------------*/
    /* Cargamos el temporal                                */
    /*-----------------------------------------------------*/
    DO iLinea = 1 TO NUM-ENTRIES(pcReturn,","):
        cLinea = ENTRY(iLinea,pcReturn,",").
        /* Validamos formato mínimo esperado */
        IF NUM-ENTRIES(cLinea,":") < 5 THEN NEXT.
        cNroDoc = ENTRY(3,cLinea,":").
        IF TRIM(cNroDoc) = "" OR cNroDoc = "null" THEN NEXT.

        FIND ORDENES WHERE ORDENES.codcia = s-codcia
              AND ORDENES.coddoc = pcCodDoc
              AND ORDENES.nroped = cNroDoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ORDENES THEN NEXT.

        /* Conversión segura de moneda */
        iCodMon = INTEGER(ENTRY(4,cLinea,":")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN iCodMon = 1.

        /* Conversión segura de importe */
        dImporte = DECIMAL(ENTRY(5,cLinea,":")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN dImporte = 0.

        CREATE btw-report.
        ASSIGN
            btw-report.campo-c[1] = ENTRY(2,cLinea,":")
            btw-report.campo-c[2] = cNroDoc
            btw-report.campo-c[3] = ORDENES.NomCli
            btw-report.campo-c[4] = ENTRY(1,cLinea,":")
            btw-report.campo-c[5] = (IF iCodMon = 1 THEN "PEN" ELSE "DOL")
            btw-report.campo-i[1] = iCodMon
            btw-report.campo-f[1] = dImporte.
    END.
END.

/*---------------------------------------------------------*/
/* Error no controlado                                     */
/*---------------------------------------------------------*/
IF ERROR-STATUS:ERROR AND pcError = "" THEN DO:
    pcError = "Error inesperado procesando órdenes pendientes:" + CHR(10).
    DO iError = 1 TO ERROR-STATUS:NUM-MESSAGES:
        pcError = pcError
                + ERROR-STATUS:GET-MESSAGE(iError)
                + CHR(10).
    END.
END.

END PROCEDURE.

/* Formato: Todo en formato Progress
    <FchDoc1>:<CodDoc1>:<NroDoc1>:<Moneda1>:<Importe1>[,<FchDoc2>:<CodDoc2>:<NroDoc2>:<Moneda2>:<Importe2>,[...]]
    FchDoc1 = "14-05-2026"
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-PR-Pendientes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-PR-Pendientes Procedure 
PROCEDURE Carga-PR-Pendientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Solicitamos la información */
  DEF INPUT PARAMETER pcCodDoc AS CHAR NO-UNDO.
  DEF INPUT PARAMETER pcCodCli AS CHAR NO-UNDO.
  DEF INPUT PARAMETER pcFmaPgo AS CHAR NO-UNDO.
  DEF PARAMETER BUFFER btw-report FOR tw-report.
  DEF OUTPUT PARAMETER pcReturn AS LONGCHAR NO-UNDO.
  DEF OUTPUT PARAMETER pcError  AS LONGCHAR NO-UNDO.

  EMPTY TEMP-TABLE btw-report.

  /* ************************************************************************* */
  /* 1ro. Información que ya está en en SAP */
  /* ************************************************************************* */
  RUN api_pagos_recibidos_pendientes (INPUT pcCodCli,
                                      OUTPUT pcReturn,
                                      OUTPUT pcError).
  IF pcError > '' THEN RETURN.
  /*IF TRUE <> (pcReturn > '') THEN RETURN.*/

  /* Cargamos el temporal */
  DEF VAR iLinea AS INTE NO-UNDO.
  DEF VAR cLinea AS CHAR NO-UNDO.
  DEF VAR cCodDoc AS CHAR NO-UNDO.

  IF pcReturn > '' THEN DO:
      cCodDoc = pcCodDoc.
      IF cCodDoc = "A/R" THEN cCodDoc = "I/C".      /* OJO */
      DO iLinea = 1 TO NUM-ENTRIES(pcReturn,','):
          cLinea = ENTRY(iLinea,pcReturn,',').
          IF ENTRY(2, cLinea, ':') = cCodDoc THEN DO:
              /* OJO: Solo con la condición de venta 002 */
              CASE pcCodDoc:
                  WHEN "BD" THEN DO:
                      FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia AND
                          Ccbcdocu.coddoc = pcCodDoc AND
                          Ccbcdocu.nrodoc = ENTRY(3,cLinea,':')
                          NO-LOCK NO-ERROR.
                  END.
                  WHEN "A/R" THEN DO:
                      FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia AND
                          Ccbcdocu.coddoc = pcCodDoc AND
                          Ccbcdocu.codref = "I/C" AND
                          Ccbcdocu.nroref = ENTRY(3,cLinea,':')
                          NO-LOCK NO-ERROR.
                  END.
                  OTHERWISE NEXT.
              END CASE.
              IF NOT AVAILABLE Ccbcdocu OR Ccbcdocu.fmapgo <> pcFmaPgo THEN NEXT.
              CREATE btw-report.
              ASSIGN
                  btw-report.campo-c[1] = Ccbcdocu.coddoc        /* BD o A/R */
                  btw-report.campo-c[2] = Ccbcdocu.nrodoc
                  btw-report.campo-c[3] = Ccbcdocu.NomCli
                  btw-report.campo-c[4] = ENTRY(1,cLinea,':')
                  btw-report.campo-c[5] = (IF ENTRY(4,cLinea,':') = "1" THEN "PEN" ELSE "DOL")
                  btw-report.campo-c[6] = ENTRY(6,cLinea,':')
                  btw-report.Campo-I[1] = INTEGER(ENTRY(4,cLinea,':'))
                  btw-report.campo-f[1] = DECIMAL(ENTRY(5,cLinea,':'))
                  btw-report.campo-f[2] = DECIMAL(ENTRY(6,cLinea,':'))
                  .
          END.
      END.
  END.
  /* ************************************************************************* */
  /* 2do. Información que aún no ha pasado a SAT */
  /* ************************************************************************* */
  FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia 
      AND Ccbcdocu.codcli = pcCodCli
      AND Ccbcdocu.flgest = "P"
      AND Ccbcdocu.coddoc = pcCodDoc
      AND Ccbcdocu.fmapgo = pcFmaPgo,
      FIRST Interface_SAP NO-LOCK WHERE Interface_SAP.code_key = Ccbcdocu.coddoc
      AND Interface_SAP.number_key = Ccbcdocu.nrodoc
      AND Interface_SAP.state = "N":
      CREATE btw-report.
      ASSIGN
          btw-report.campo-c[1] = Ccbcdocu.coddoc        /* BD o A/R */
          btw-report.campo-c[2] = Ccbcdocu.nrodoc
          btw-report.campo-c[3] = Ccbcdocu.NomCli
          btw-report.campo-c[4] = STRING(Ccbcdocu.fchdoc)
          btw-report.campo-c[5] = (IF Ccbcdocu.codmon = 1 THEN "PEN" ELSE "DOL")
          btw-report.campo-c[6] = STRING(Ccbcdocu.sdoact)
          btw-report.Campo-I[1] = Ccbcdocu.codmon
          btw-report.campo-f[1] = Ccbcdocu.imptot
          btw-report.campo-f[2] = Ccbcdocu.sdoact
          .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearConfigCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearConfigCache Procedure 
PROCEDURE clearConfigCache PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
  Purpose: Vacía el cache de configuración (útil para recargas)
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE ttConfig.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processJsonFromFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processJsonFromFile Procedure 
PROCEDURE processJsonFromFile :
/*------------------------------------------------------------------------------
  Purpose: Procesa un archivo JSON y genera el formato de salida requerido
  Parameters:
    INPUT  pcJsonFile  - Ruta del archivo JSON
    OUTPUT pcReturn    - Datos formateados
    OUTPUT pcError     - Mensaje de error
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcJsonFile AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcReturn AS LONGCHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER pcError AS LONGCHAR NO-UNDO.

    DEFINE VARIABLE lcContent AS LONGCHAR NO-UNDO.
    DEFINE VARIABLE arrayId AS INTEGER NO-UNDO.
    DEFINE VARIABLE TotalItems AS INTEGER NO-UNDO.
    DEFINE VARIABLE iRegistro AS INTEGER NO-UNDO.
    DEFINE VARIABLE itemId AS INTEGER NO-UNDO.
    DEFINE VARIABLE plOk AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cLine AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lFirstLine AS LOGICAL NO-UNDO.

    /* ... resto de variables ... */
    /* ? Variables para cada campo - TODAS CHARACTER (seguras para 32KB) */
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
    DEFINE VARIABLE cValor      AS CHARACTER NO-UNDO.

    DEFINE VARIABLE dFchDoc     AS DATE      NO-UNDO.
    DEFINE VARIABLE dFchVto     AS DATE      NO-UNDO.
    DEFINE VARIABLE fImpTot     AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE fSdoAct     AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE iCodMon     AS INTEGER   NO-UNDO.

    ASSIGN
        pcReturn = ""
        pcError = "".

    /* ? Cargar el archivo en LONGCHAR (solo si es manejable) */
    COPY-LOB FILE pcJsonFile TO lcContent.

    IF LENGTH(lcContent) = 0 THEN DO:
        pcError = "El archivo JSON está vacío.".
        RETURN.
    END.

    /* ? Inicializar JSON */
    RUN JsonInit IN hJsonUtils (INPUT hJson, 
                                INPUT lcContent,
                                OUTPUT arrayId,
                                OUTPUT TotalItems,
                                OUTPUT pcError
                                ).
    IF pcError > "" THEN RETURN.
    IF TotalItems <= 0 THEN RETURN.

    /* ? Procesar items (igual que antes) */
    lFirstLine = TRUE.
    
    DO iRegistro = 1 TO TotalItems:
        DO ON ERROR UNDO, NEXT:
            RUN JsonGetItem IN hJsonUtils (arrayId, iRegistro, OUTPUT itemId, OUTPUT plOk).
            IF plOk = NO THEN NEXT.

            /* --- Extraer valores --- */
            RUN JsonGetChar IN hJsonUtils (itemId, "codclie", OUTPUT cCodCli).
            IF cCodCli = "" THEN NEXT.
            
            RUN JsonGetDate IN hJsonUtils (itemId, "DocumentoFechaEmision", OUTPUT dFchDoc).
            IF dFchDoc = ? THEN NEXT.
            cFchDoc = STRING(dFchDoc).
            
            RUN JsonGetDate IN hJsonUtils (itemId, "DocumentoFechaVencimiento", OUTPUT dFchVto).
            IF dFchVto = ? THEN NEXT.
            cFchVto = STRING(dFchVto).
            
            RUN JsonGetChar IN hJsonUtils (itemId, "DocumentoTipo", OUTPUT cCodDoc).
            IF cCodDoc = "" THEN NEXT.
            
            RUN JsonGetChar IN hJsonUtils (itemId, "DocumentoNumero", OUTPUT cNroDoc).
            IF cNroDoc = "" THEN NEXT.
            
            RUN JsonGetCurrency IN hJsonUtils (itemId, "DocumentoMoneda", OUTPUT iCodMon).
            RUN JsonGetChar IN hJsonUtils (itemId, "DocumentoDivision", OUTPUT cDivision).
            RUN JsonGetChar IN hJsonUtils (itemId, "DocumentoCondicionPago", OUTPUT cFmaPgo).
            RUN JsonGetChar IN hJsonUtils (itemId, "LetraSituacion", OUTPUT cLetSit).
            RUN JsonGetChar IN hJsonUtils (itemId, "LetraBanco", OUTPUT cLetBco).
            RUN JsonGetChar IN hJsonUtils (itemId, "LetraCuentaBancaria", OUTPUT cLetCta).
            RUN JsonGetChar IN hJsonUtils (itemId, "LetraEstado", OUTPUT cLetStatus).
            RUN JsonGetChar IN hJsonUtils (itemId, "coddoc", OUTPUT cCodigo).
            RUN JsonGetChar IN hJsonUtils (itemId, "nrodoc", OUTPUT cNumero).
            
            fImpTot = 0.
            RUN JsonGetDecimal IN hJsonUtils (itemId, "DocumentoTotal", OUTPUT fImpTot).
            
            fSdoAct = 0.
            RUN JsonGetDecimal IN hJsonUtils (itemId, "DocumentoSaldo", OUTPUT fSdoAct).
            
            /* Construir línea */
            cLine = cCodCli + ":"
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
            
            /* Acumular */
            IF lFirstLine THEN
                pcReturn = cLine.
            ELSE
                pcReturn = pcReturn + "," + cLine.
            
            lFirstLine = FALSE.
        END.
    END.
    
    RUN JsonDestroy IN hJsonUtils.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Saldo-AC-PED-OD-Disponible) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Saldo-AC-PED-OD-Disponible Procedure 
PROCEDURE Saldo-AC-PED-OD-Disponible :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF PARAMETER BUFFER bFaccpedi FOR Faccpedi.   
  DEF OUTPUT PARAMETER x-Saldo AS DECI NO-UNDO.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* Control de Facturas Adelantadas */
  DEFINE VARIABLE x-ImpTot AS DECI NO-UNDO.
  DEFINE VARIABLE x-ImpPED AS DECI NO-UNDO.
  DEFINE VARIABLE x-ImpOD  AS DECI NO-UNDO.
  DEFINE VARIABLE x-ImpAC  AS DECI NO-UNDO.

  ASSIGN
      x-Saldo = 0
      x-ImpTot = 0.
  /* ****************************************************************************** */
  /* 1ro Buscamos los A/C por aplicar pero que tengan la misma moneda que el pedido */
  /* ****************************************************************************** */
  RUN Saldo-AC-Pendientes (INPUT bFaccpedi.codcli,
                           INPUT bFaccpedi.codmon,
                           OUTPUT x-ImpAC,
                           OUTPUT pMensaje).
  IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
  x-Saldo = x-Saldo + x-ImpAC.
  IF x-Saldo <= 0 THEN DO:
      RETURN.
  END.
  
  /* ****************************************************************************** */
  /* 2do Buscamos PED y O/D en trámite */
  /* ****************************************************************************** */
  DEF VAR x-EstadosValidos AS CHAR NO-UNDO.
  DEF VAR x-FlgEst AS CHAR NO-UNDO.
  DEF VAR k AS INTE NO-UNDO.

  DEF BUFFER PEDIDO FOR Faccpedi.
  DEF BUFFER bgn-divi FOR gn-divi.

  ASSIGN
      x-EstadosValidos = "G,X,T,W,WX,WL,WC,P".
  ASSIGN
      x-ImpPED = 0.
  FOR EACH bgn-divi NO-LOCK WHERE bgn-divi.codcia = s-codcia:
      DO k = 1 TO NUM-ENTRIES(x-EstadosValidos):
          x-FlgEst = ENTRY(k, x-EstadosValidos).
          FOR EACH PEDIDO NO-LOCK WHERE PEDIDO.codcia = s-codcia 
              AND PEDIDO.coddiv = bgn-divi.coddiv
              AND PEDIDO.coddoc = "PED"
              AND PEDIDO.flgest = x-FlgEst
              AND PEDIDO.codcli = bFaccpedi.codcli:
              IF NOT (PEDIDO.fchven >= TODAY
                      AND PEDIDO.codmon = bFaccpedi.codmon
                      AND PEDIDO.TpoLic = YES) 
                  THEN NEXT.
              x-Saldo = x-Saldo - PEDIDO.imptot.
              x-ImpPED = x-ImpPED + PEDIDO.ImpTot.
          END.
      END.
  END.

  ASSIGN
      x-ImpOD = 0.
  RUN Saldo-OD-Pendientes (INPUT bFaccpedi.codcli,
                           INPUT bFaccpedi.codmon,
                           OUTPUT x-ImpOD,
                           OUTPUT pMensaje).
  IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
  x-Saldo = x-Saldo - x-ImpOD.
  x-ImpOD = x-ImpOD + x-ImpOD.

  /* Las Ordenes de Despacho que NO han pasado a SAP todavía */
  DEF BUFFER ORDEN FOR Faccpedi.

  FOR EACH bgn-divi NO-LOCK WHERE bgn-divi.codcia = s-codcia,
      EACH ORDEN NO-LOCK WHERE ORDEN.codcia = s-codcia 
          AND ORDEN.coddiv = bgn-divi.coddiv
          AND ORDEN.coddoc = "O/D"
          AND ORDEN.codcli = bFaccpedi.codcli
          AND ORDEN.flgest = "P"
        AND ORDEN.codmon = bFaccpedi.codmon,
      FIRST PEDIDO NO-LOCK WHERE PEDIDO.codcia = ORDEN.codcia
          AND PEDIDO.coddoc = ORDEN.codref
          AND PEDIDO.nroped = ORDEN.nroref:
      IF PEDIDO.TpoLic = NO THEN NEXT.
      x-Saldo = x-Saldo - ORDEN.imptot.
      x-ImpOD = x-ImpOD + ORDEN.ImpTot.
  END.

  IF x-Saldo <= 0 THEN x-Saldo = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Saldo-AC-Pendientes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Saldo-AC-Pendientes Procedure 
PROCEDURE Saldo-AC-Pendientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Calcula saldo de A/C por aplicar siempre y cuando el PED 
                tiene seleccionado APLICAR ADELANTOS
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pcCodCli AS CHAR NO-UNDO.
DEF INPUT PARAMETER piCodMon AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pfSdoAct AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pcError AS LONGCHAR NO-UNDO.

DEF VAR pcReturn AS LONGCHAR NO-UNDO.

/* De acuerdo a la moneda del PED */
RUN Carga-AC-Pendientes (INPUT "A/C",
                         INPUT pcCodCli,
                         BUFFER tw-report,
                         OUTPUT pcReturn,
                         OUTPUT pcError).
IF pcError > '' THEN RETURN.

IF TRUE <> (pcReturn > '') THEN RETURN.

FOR EACH tw-report NO-LOCK WHERE tw-report.Campo-I[1] = piCodMon:
    pfSdoAct = pfSdoAct + tw-report.campo-f[2].
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Saldo-EECC-PED-OD) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Saldo-EECC-PED-OD Procedure 
PROCEDURE Saldo-EECC-PED-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pcCodCli AS CHAR NO-UNDO.
DEF INPUT PARAMETER pMonLCred AS INT NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tw-report.
DEF OUTPUT PARAMETER pDeuda AS DECI NO-UNDO.

DEF BUFFER bgn-divi FOR gn-divi.
DEF BUFFER bgn-convt FOR gn-convt.
DEF BUFFER bInterface_SAP FOR Interface_SAP.
DEF BUFFER bFaccpedi FOR Faccpedi.
DEF BUFFER bFacdpedi FOR Facdpedi.

FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK.

DEF VAR pMaster AS CHAR.
DEF VAR pRelacionados AS CHAR.
DEF VAR pAgrupados AS LOG.

RUN ccb/p-cliente-master (pcCodCli,
                          OUTPUT pMaster,
                          OUTPUT pRelacionados,
                          OUTPUT pAgrupados).
IF pAgrupados = YES AND pRelacionados > '' THEN .
ELSE pRelacionados = pcCodCli.

DEF VAR pSaldoDoc AS DEC NO-UNDO.
DEF VAR pcReturn AS LONGCHAR NO-UNDO.
DEF VAR pcError AS LONGCHAR NO-UNDO.

/* ************************************************************************************** */
/* 1ro. Acumulamos deudas por EECC */
/* ************************************************************************************** */
FOR EACH tw-report.
    pSaldoDoc = tw-report.Campo-F[2].
    IF pMonLCred = 1 THEN DO:
        IF tw-report.Campo-I[1] = 2 THEN pSaldoDoc = pSaldoDoc * gn-tcmb.Compra.
    END.
    ELSE DO:
        IF tw-report.Campo-I[1] = 1 THEN pSaldoDoc = pSaldoDoc / gn-tcmb.Venta.
    END.
    pDeuda = pDeuda + pSaldoDoc.
END.

DEF VAR cFmaPgo AS CHAR INIT "G,X,P,W,WX,WL" NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR cCodCli AS CHAR NO-UNDO.
DEF VAR iCuenta AS INT NO-UNDO.
DEF VAR fSaldoPED AS DECI NO-UNDO.
DEF VAR fSaldoOD AS DECI NO-UNDO.

DO iCuenta = 1 TO NUM-ENTRIES(pRelacionados):
    cCodCli = ENTRY(iCuenta, pRelacionados).
    /* ************************************************************************************** */
    /* 2do. Suma Pedidos Credito Pendientes Generar Guias */
    /* ************************************************************************************** */
    DO k = 1 TO NUM-ENTRIES(cFmaPgo):
        FOR EACH bgn-divi NO-LOCK WHERE bgn-divi.codcia = s-codcia,
            EACH bFaccpedi NO-LOCK USE-INDEX Llave10 WHERE bFaccpedi.CodCia = S-CODCIA 
            AND bFaccpedi.coddiv = bgn-divi.coddiv
            AND bFaccpedi.CodDoc = "PED"
            AND bFaccpedi.FlgEst = ENTRY(k,cFmaPgo)
            AND bFaccpedi.CodCli = cCodCli:
            FIND FIRST bgn-convt WHERE bgn-convt.codig = bFaccpedi.FmaPgo NO-LOCK NO-ERROR.
            IF AVAILABLE bgn-convt AND bgn-convt.tipvta = "1" THEN NEXT.     /* NO CONTADOS */
            FOR EACH bFacdpedi OF bFaccpedi NO-LOCK WHERE bFacdpedi.CanPed > bFacdpedi.CanAte:
                pSaldoDoc = (bFacdpedi.CanPed - bFacdpedi.CanAte) * bFacdpedi.ImpLin / bFacdpedi.CanPed.
                IF pMonLCred = 1 THEN DO:
                    IF bFaccpedi.CodMon = 2 THEN pSaldoDoc = pSaldoDoc * gn-tcmb.Compra.
                END.
                ELSE DO:
                    IF bFaccpedi.CodMon = 1 THEN pSaldoDoc = pSaldoDoc / gn-tcmb.Venta.
                END.
                fSaldoPED = fSaldoPED + pSaldoDoc.
            END.             
        END.
    END.
    /* ************************************************************************************** */
    /* 3ro. Suma Ordenes de Despacho Pendientes Generar Guias */
    /* ************************************************************************************** */
    RUN Carga-OD-Pendientes (INPUT "O/D",
                             INPUT cCodCli,
                             BUFFER tw-report,
                             OUTPUT pcReturn,
                             OUTPUT pcError).
    FOR EACH tw-report:
        FIND bFaccpedi WHERE bFaccpedi.codcia = s-codcia AND
            bFaccpedi.coddoc = tw-report.campo-c[2] AND
            bFaccpedi.nroped = tw-report.campo-c[3]
            NO-LOCK NO-ERROR.
        IF AVAILABLE bFaccpedi AND
            CAN-FIND(bgn-convt WHERE bgn-convt.codig = bFaccpedi.fmapgo AND bgn-convt.tipvta = "1" NO-LOCK)
            THEN NEXT.
        pSaldoDoc = tw-report.campo-f[1].
        IF pMonLCred = 1 THEN DO:
            IF tw-report.Campo-I[1] = 2 THEN pSaldoDoc = pSaldoDoc * gn-tcmb.Compra.
        END.
        ELSE DO:
            IF tw-report.Campo-I[1] = 1 THEN pSaldoDoc = pSaldoDoc / gn-tcmb.Venta.
        END.
        fSaldoOD  = fSaldoOD + pSaldoDoc.
    END.
    /* Las Ordenes de Despacho que NO han pasado a SAP todavía */
    FOR EACH bgn-divi NO-LOCK WHERE bgn-divi.codcia = s-codcia,
        EACH bFaccpedi NO-LOCK USE-INDEX Llave10 WHERE bFaccpedi.CodCia = S-CODCIA 
            AND bFaccpedi.coddiv = bgn-divi.coddiv
            AND bFaccpedi.CodDoc = "O/D" 
            AND bFaccpedi.FlgEst = "P"
            AND bFaccpedi.CodCli = cCodCli,
        FIRST bInterface_SAP NO-LOCK WHERE bInterface_SAP.code_key = bFaccpedi.coddoc 
            AND bInterface_SAP.number_key = bFaccpedi.nroped
            AND bInterface_SAP.state_stock = "N":        /* OJO */
        FIND FIRST bgn-convt WHERE bgn-convt.codig = bFaccpedi.FmaPgo NO-LOCK.

        IF bgn-convt.tipvta = "1" OR bgn-convt.codig = "899" THEN NEXT.     /* NO CONTADOS */

        FOR EACH bFacdpedi OF bFaccpedi NO-LOCK WHERE bFacdpedi.CanPed > bFacdpedi.CanAte:
            pSaldoDoc = (bFacdpedi.CanPed - bFacdpedi.CanAte) * bFacdpedi.ImpLin / bFacdpedi.CanPed.
            IF pMonLCred = 1 THEN DO:
                IF bFaccpedi.CodMon = 2 THEN pSaldoDoc = pSaldoDoc * gn-tcmb.Compra.
            END.
            ELSE DO:
                IF bFaccpedi.CodMon = 1 THEN pSaldoDoc = pSaldoDoc / gn-tcmb.Venta.
            END.
            fSaldoOD  = fSaldoOD + pSaldoDoc.
        END.             
    END.
END.
pDeuda = pDeuda + fSaldoPED + fSaldoOD.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Saldo-OD-Pendientes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Saldo-OD-Pendientes Procedure 
PROCEDURE Saldo-OD-Pendientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pcCodCli AS CHAR NO-UNDO.
DEF INPUT PARAMETER piCodMon AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pfSdoAct AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pcError AS LONGCHAR NO-UNDO.

DEF VAR pcReturn AS LONGCHAR NO-UNDO.

/* De acuerdo a la moneda del PED */
RUN Carga-OD-Pendientes (INPUT "O/D",
                         INPUT pcCodCli,
                         BUFFER tw-report,
                         OUTPUT pcReturn,
                         OUTPUT pcError).
IF pcError > '' THEN RETURN.
/*IF TRUE <> (pcReturn > '') THEN RETURN.*/

FOR EACH tw-report NO-LOCK WHERE tw-report.Campo-I[1] = piCodMon:
    pfSdoAct = pfSdoAct + tw-report.campo-f[1].
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Verifica-Linea-de-Credito) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Linea-de-Credito Procedure 
PROCEDURE Verifica-Linea-de-Credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT  PARAMETER pcCodDiv   AS CHAR    NO-UNDO.
DEF INPUT  PARAMETER pcCodCli   AS CHAR    NO-UNDO.
DEF INPUT  PARAMETER piCodMon   AS INTEGER NO-UNDO.
DEF INPUT  PARAMETER pfImporte  AS DECIMAL NO-UNDO.
/*DEF INPUT  PARAMETER plMensaje  AS LOGICAL NO-UNDO.*/
DEF OUTPUT PARAMETER pcError    AS CHARACTER NO-UNDO.

/*--------------------------------------------------------------
    Verificación de Línea de Crédito
--------------------------------------------------------------*/

DEFINE VARIABLE fMonLC      AS INTEGER   NO-UNDO INITIAL 1.
DEFINE VARIABLE fImpLC      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE pfDeuda     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE pcReturn    AS LONGCHAR  NO-UNDO.
DEFINE VARIABLE cMensaje    AS CHARACTER NO-UNDO.

/* Inicialización */

ASSIGN
    pcError  = ""
    pcReturn = "".

/*--------------------------------------------------------------
    Obtiene Línea de Crédito
--------------------------------------------------------------*/

RUN ccb/p-implc (
    INPUT  cl-codcia,
    INPUT  pcCodCli,
    INPUT  pcCodDiv,
    OUTPUT fMonLC,
    OUTPUT fImpLC
).

/*--------------------------------------------------------------
    Obtiene Estado de Cuenta
--------------------------------------------------------------*/
EMPTY TEMP-TABLE tw-report.
RUN Carga-EECC-Pendientes (
    INPUT  pcCodCli,
    BUFFER tw-report,
    OUTPUT pcReturn,
    OUTPUT pcError
).
IF pcError > "" THEN RETURN.

/*--------------------------------------------------------------
    Calcula deuda
--------------------------------------------------------------*/
RUN Saldo-EECC-PED-OD (
    INPUT  pcCodCli,
    INPUT  fMonLC,
    INPUT  TABLE tw-report,
    OUTPUT pfDeuda
).

/*--------------------------------------------------------------
    Tipo de Cambio
--------------------------------------------------------------*/
FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-tcmb THEN DO:
    pcError = "No existe tipo de cambio registrado para la fecha de hoy.".
    RETURN.
END.

/*--------------------------------------------------------------
    Conversión de Moneda
--------------------------------------------------------------*/
IF fMonLC = 1 AND piCodMon = 2 THEN pfImporte = pfImporte * gn-tcmb.compra.
IF fMonLC = 2 AND piCodMon = 1 THEN pfImporte = pfImporte / gn-tcmb.venta.

/*--------------------------------------------------------------
    Verificación de Línea de Crédito
--------------------------------------------------------------*/

IF (fImpLC * 1.10) - (pfImporte + pfDeuda) < 0 THEN DO:
    cMensaje = "La Línea de Crédito del cliente ha sido excedida."
        + CHR(10) + CHR(10)
        + "Límite de Crédito : "
        + (IF fMonLC = 1 THEN "S/ " ELSE "US$ ")
        + STRING(fImpLC,"ZZ,ZZZ,ZZ9.99")
        + CHR(10)
        + "Crédito Utilizado : "
        + (IF fMonLC = 1 THEN "S/ " ELSE "US$ ")
        + STRING(pfImporte + pfDeuda,"-Z,ZZZ,ZZ9.99")
        + CHR(10)
        + "Crédito Disponible : "
        + (IF fMonLC = 1 THEN "S/ " ELSE "US$ ")
        + STRING(fImpLC - (pfImporte + pfDeuda),"-Z,ZZZ,ZZ9.99")
        + CHR(10) + CHR(10)
        + "Comuníquese con el Gestor de Créditos y Cobranzas.".
    pcError = cMensaje.

/*     IF plMensaje THEN MESSAGE cMensaje VIEW-AS ALERT-BOX ERROR TITLE "VERIFICACIÓN DE LÍNEA DE CRÉDITO". */

    RETURN.
END.
/*--------------------------------------------------------------
    Sin errores
--------------------------------------------------------------*/
pcError = "".
RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getConfigValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getConfigValue Procedure 
FUNCTION getConfigValue RETURNS CHARACTER PRIVATE
    (INPUT pcTabla   AS CHARACTER,
     INPUT pcLlave1  AS CHARACTER,
     INPUT pcLlave2  AS CHARACTER,
     INPUT plRefresh AS LOGICAL):
/*------------------------------------------------------------------------------
  Purpose:  Obtiene valor de configuración con cache.
            Si plRefresh = TRUE, fuerza recarga desde BD.
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE cKey   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i      AS INTEGER   NO-UNDO.
    
    /* Construir clave única */
    cKey = pcTabla + "|" + pcLlave1 + "|" + pcLlave2.
    
    /* ========================================================
       Buscar en cache (si no se fuerza refresh)
       ======================================================== */
    IF NOT plRefresh THEN DO:
        FIND FIRST ttConfig 
            WHERE ttConfig.cKey = cKey 
            NO-LOCK NO-ERROR.
        
        IF AVAILABLE ttConfig THEN DO:
            /* Validar que el cache no esté expirado (24 horas) */
            IF TODAY - ttConfig.dFechaLectura < 1 THEN
                RETURN ttConfig.cValue.
            ELSE
                FIND CURRENT ttConfig EXCLUSIVE-LOCK NO-ERROR.
        END.
    END.
    
    /* ========================================================
       Cargar desde Base de Datos
       ======================================================== */
    FIND FIRST VtaTabla
        WHERE VtaTabla.CodCia   = s-CodCia
          AND VtaTabla.Tabla    = pcTabla
          AND VtaTabla.Llave_c1 = pcLlave1
          AND VtaTabla.Llave_c2 = pcLlave2
        NO-LOCK NO-ERROR.
    
    IF AVAILABLE VtaTabla THEN
        cValue = TRIM(VtaTabla.Libre_c01).
    ELSE
        cValue = "".
    
    /* ========================================================
       Guardar en cache (o actualizar si existe)
       ======================================================== */
    IF AVAILABLE ttConfig THEN DO:
        /* Actualizar registro existente */
        ASSIGN ttConfig.cValue = cValue
               ttConfig.dFechaLectura = TODAY
               ttConfig.tHoraLectura = TIME.
    END.
    ELSE DO:
        /* Crear nuevo registro en cache */
        CREATE ttConfig.
        ASSIGN ttConfig.cKey = cKey
               ttConfig.cValue = cValue
               ttConfig.dFechaLectura = TODAY
               ttConfig.tHoraLectura = TIME.
    END.
    
    RETURN cValue.
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

