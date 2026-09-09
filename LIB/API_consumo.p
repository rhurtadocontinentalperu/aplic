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

DEFINE VAR x-codcia AS INT INIT 1.
DEFINE VAR x-tabla AS CHAR.

x-tabla = "CONFIG-API".

DEFINE TEMP-TABLE pTable LIKE w-report. 

/**/

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-API_consumir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE API_consumir Procedure 
PROCEDURE API_consumir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pURLApi AS LONGCHAR.
DEFINE OUTPUT PARAMETER pResultado AS LONGCHAR.

DEFINE VAR x-url-webservice AS LONGCHAR.
DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.
                                 

/*x-url-webservice = "http://192.168.100.221:62/api/Sales/Record/PriceSalesChannelUnitView/sha256$5uqVbpQ6dWv0z2Tw$8cfcfcd13571eba4873e06dd6dd25674503c498657f7da6969aae41a0249c64a?FormatXML=True&FieldName=DiscountedPriceCategoryCustomerAndConditionSale,ExchangeRate,CurrencySale,PercentageDiscountSalesCondition,PercentageDiscountCategoryCustomer,CurrencyRepositionCost,AmountRepositionCost&ArtCode=000981&SalesChannel=1&CategoryCustomer=C&SalesCondition=001".*/
x-url-webservice = pURLApi.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.
                                 
x-oXmlHttp:OPEN( "GET", x-url-webservice, NO ). 

x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
/*x-oXmlHttp:setRequestHeader( "Content-Length", LENGTH(x-xml-documento)).    */

x-oXmlHttp:setOption( 2, 13056 ) .  /*SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056*/      

x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    /**/
    pResultaDO = "ERROR:" + ERROR-STATUS:GET-MESSAGE(1).
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN "ADM-ERROR".
END.
IF x-oXmlHttp:STATUS <> 200 THEN DO:
    pResultaDO = "ERROR:" + x-oXmlHttp:responseText.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RETURN .
END.

/* La Respuesta */
DEFINE VAR x-rspta AS LONGCHAR.
DEFINE VAR x-orspta AS COM-HANDLE NO-UNDO.

x-rspta = x-oXmlHttp:responseText.

RELEASE OBJECT x-oXmlHttp NO-ERROR.
RELEASE OBJECT x-oRspta NO-ERROR.

pResultado = trim(x-rspta).

/*COPY-LOB x-rspta TO FILE "d:\testeo.txt".*/

/*x-texto = x-rspta.*/
/*UPDATE x-texto.*/

/*MESSAGE SUBSTRING(string(x-oXmlHttp:responseText),1,255).*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-API_get_servidor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE API_get_servidor Procedure 
PROCEDURE API_get_servidor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER p-retval AS CHAR NO-UNDO.

p-retval = "".

FIND FIRST vtatabla WHERE vtatabla.codcia = x-codcia AND
                    vtatabla.tabla = x-tabla AND
                    vtatabla.llave_c1 = "SERVIDOR" AND
                    vtatabla.llave_c2 = "IP-PORT" NO-LOCK NO-ERROR.
IF NOT AVAILABLE vtatabla THEN RETURN "ADM-ERROR".

p-retval = TRIM(vtatabla.llave_c3).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-API_get_tabla_formato) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE API_get_tabla_formato Procedure 
PROCEDURE API_get_tabla_formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-tabla AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p-url-tabla AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p-formato AS CHAR NO-UNDO.


FIND FIRST vtatabla WHERE vtatabla.codcia = x-codcia AND
                    vtatabla.tabla = x-tabla AND
                    vtatabla.llave_c1 = "TABLA" AND
                    vtatabla.llave_c2 = p-tabla NO-LOCK NO-ERROR.
IF NOT AVAILABLE vtatabla THEN RETURN "ADM-ERROR".

p-url-tabla = TRIM(vtatabla.llave_c3).
p-formato = TRIM(vtatabla.llave_c4).

IF TRUE <> (p-formato > "") THEN p-formato = "XML".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-API_get_token) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE API_get_token Procedure 
PROCEDURE API_get_token :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER p-retval AS CHAR NO-UNDO.

p-retval = "".

FIND FIRST vtatabla WHERE vtatabla.codcia = x-codcia AND
                    vtatabla.tabla = x-tabla AND
                    vtatabla.llave_c1 = "SERVIDOR" AND
                    vtatabla.llave_c2 = "TOKEN" NO-LOCK NO-ERROR.
IF NOT AVAILABLE vtatabla THEN RETURN "ADM-ERROR".

p-retval = TRIM(vtatabla.llave_c3).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-API_tabla) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE API_tabla Procedure 
PROCEDURE API_tabla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-tabla AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pURLApi AS CHAR NO-UNDO.

DEFINE VAR x-servidor AS CHAR.
DEFINE VAR x-token AS CHAR.
DEFINE VAR x-url-tabla AS CHAR.
DEFINE VAR x-formato AS CHAR.

RUN API_get_servidor(OUTPUT x-servidor).
IF TRUE <> (x-servidor > "") THEN RETURN "ADM-ERROR".

RUN API_get_token(OUTPUT x-token).
IF TRUE <> (x-token > "") THEN RETURN "ADM-ERROR".

RUN API_get_tabla_formato(INPUT p-tabla, OUTPUT x-url-tabla, OUTPUT x-formato).
IF TRUE <> (x-url-tabla > "") THEN RETURN "ADM-ERROR".

/*pUrlApi = x-servidor + x-url-tabla + "/" + x-token + "?" + x-formato.*/
pUrlApi = x-servidor + x-url-tabla + "/" + x-token + "?" + x-formato.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getValueTag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValueTag Procedure 
PROCEDURE getValueTag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTexto AS LONGCHAR NO-UNDO.
DEFINE INPUT PARAMETER pTagField AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pValue AS CHAR NO-UNDO.

DEFINE VAR x-tag1 AS CHAR.
DEFINE VAR x-tag2 AS CHAR.
DEFINE VAR x-inicio AS INT.
DEFINE VAR x-fin AS INT.

pValue = "".

x-tag1 = "<" + pTagField + ">".
x-tag2 = "</" + pTagField + ">".

x-inicio = INDEX(pTexto, x-Tag1).
x-fin = INDEX(pTexto, x-Tag2).
IF x-Inicio > x-Fin THEN DO:
    pValue = "No existe valor para " + pTagField.
    RETURN "ADM-ERROR".
END.
pValue = SUBSTRING(pTexto, x-Inicio + LENGTH(x-Tag1), (x-Fin - x-Inicio - LENGTH(x-Tag1))).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-xml-to-temp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE xml-to-temp Procedure 
PROCEDURE xml-to-temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTramaXML AS LONGCHAR NO-UNDO.
DEFINE INPUT PARAMETER pFieldList AS LONGCHAR NO-UNDO.      /* Field1,Field2,Field3....FieldN */
DEFINE OUTPUT PARAMETER TABLE FOR pTable.       /* w-report */
DEFINE OUTPUT PARAMETER pMessage AS CHAR NO-UNDO.

EMPTY TEMP-TABLE pTable.

/* Separamos la DATA */
DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-Fin AS INTE NO-UNDO.
DEFINE VAR x-row-data AS LONGCHAR.
DEFINE VAR x-conteo AS INT.
DEFINE VAR x-field AS CHAR.
DEFINE VAR x-data AS CHAR.
DEFINE VAR x-row AS INT.
DEFINE VAR x-salir AS LOG.
DEFINE VAR x-position AS INT.

DEFINE VAR x-xml AS LONGCHAR.
DEFINE VAR x-fields AS LONGCHAR.

x-xml = pTramaXML.
x-fields = pFieldList.

x-Inicio = INDEX(x-xml, "<Data>").
x-Fin = INDEX(x-xml, "</Data>").

IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
    pMessage = "NO hay datos registrados".
    RETURN "ADM-ERROR".
END.

x-Inicio = INDEX(x-xml, "<Data>").
x-Fin = INDEX(x-xml, "</Data>").

IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
    pMessage = "NO hay datos registrados".
    RETURN "ADM-ERROR".
END.

x-Inicio = x-Inicio + 6.
x-xml = SUBSTRING(x-xml, x-Inicio, (x-Fin - x-Inicio)).

x-salir = NO.
x-position = 0.

EMPTY TEMP-TABLE pTable.

/* Filas */
REPEAT WHILE x-salir = NO:
    x-Inicio = INDEX(x-xml, "<Rows>").
    x-Fin = INDEX(x-xml, "</Rows>").

    IF x-Inicio = 0 OR x-Fin = 0 THEN DO:
        x-salir = YES.
        LEAVE.
    END.
    x-inicio = x-inicio + 6. /* <Rows> = 6 */
    x-row-data = SUBSTRING(x-xml,x-inicio, x-fin - x-inicio).

    /* Columnas / Fields */
    REPEAT x-conteo = 1 TO NUM-ENTRIES(x-fields,","):
        IF x-conteo = 1 THEN DO:
            CREATE pTable.
        END.
        x-field = ENTRY(x-conteo,x-fields).
        RUN getValueTag(INPUT x-row-data, INPUT x-field, OUTPUT x-data).
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            ASSIGN pTable.campo-c[x-conteo] = "ERROR:" + x-data.
        END.
        ELSE DO:
            ASSIGN pTable.campo-c[x-conteo] = x-data.
        END.        
    END.

    x-Fin = x-fin + 7.  /* </Rows> = 7 */
    x-xml = SUBSTRING(x-xml,x-Fin).
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

