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
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pEstadoBizLinks AS CHAR INIT "|" NO-UNDO.  
DEFINE OUTPUT PARAMETER pEstadoSUNAT AS CHAR INIT "|" NO-UNDO.
DEFINE OUTPUT PARAMETER pEstadoDocumento AS CHAR INIT "" NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pMotivoRechazo AS CHAR INIT "" NO-UNDO.

/* 
    pEstadoBizLinks  : Retorna COD|Decricpion
    pEstadoSUNAT    : Retorna COD|Decricpion
*/

DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR x-servidor-ip AS CHAR.
DEFINE VAR x-servidor-puerto AS CHAR.

DEFINE VAR x-ruc-emisor AS CHAR INIT "20100038146".
DEFINE VAR x-tipo-doc-emisor AS CHAR INIT "6".
DEFINE VAR x-serie-documento AS CHAR.
DEFINE VAR x-nro-documento AS CHAR.
DEFINE VAR x-tipo-documento-sunat AS CHAR INIT "XX".
DEFINE VAR x-url AS CHAR.

DEFINE VAR cUrlPDF AS LONGCHAR.

/*x-Ruc-emisor = '20511358907'.       /* Para Prueba con Standford */*/

DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.
DEFINE VAR x-oXMLBody AS com-HANDLE NO-UNDO.

DEFINE BUFFER x-felogcomprobantes FOR felogcomprobantes.

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

RUN webservice-configuracion.

IF x-servidor-ip = "" THEN DO:
    pEstadoBizLinks = "ERROR IP|La IP del servidor del WEBSERVICE esta vacio".
    RETURN.
END.

DEFINE VAR x-prefijo-serie AS CHAR.
DEFINE VAR x-serie-numero AS CHAR.

DEFINE VAR x-estado-biz AS CHAR.
DEFINE VAR x-estado-sunat AS CHAR.
DEFINE VAR x-abreviado AS CHAR.
DEFINE VAR x-detallado AS CHAR.

IF LOOKUP(pCodDoc,"FAC,BOL,N/C,N/D,G/R") > 0 THEN DO:

    IF LOOKUP(pCodDoc,"FAC,BOL,N/C,N/D") > 0 THEN DO:
        /* Verificar si el documento fue enviado a BIZLINKS */
        
        FIND FIRST x-felogcomprobantes WHERE x-felogcomprobantes.codcia = s-codcia AND
                                                x-felogcomprobantes.coddoc = pCodDoc AND
                                                x-felogcomprobantes.nrodoc = pNroDoc NO-LOCK NO-ERROR.
        IF NOT AVAILABLE x-felogcomprobantes THEN DO:
            /*
            pEstadoBizLinks = "NO EXISTE|Documento no enviado a SUNAT".
            RETURN.
            */
        END.

        RUN gn/p-prefijo-serie-documento(INPUT pCodDoc, 
                                         INPUT pNroDoc, 
                                         INPUT pCodDiv,
                                         OUTPUT x-prefijo-serie).

    END.
    ELSE DO:
        x-prefijo-serie = 'T'.
    END.

    IF pCodDoc = "FAC" THEN x-tipo-documento-sunat = "01".
    IF pCodDoc = "BOL" THEN x-tipo-documento-sunat = "03".
    IF pCodDoc = "N/C" THEN x-tipo-documento-sunat = "07".
    IF pCodDoc = "N/D" THEN x-tipo-documento-sunat = "08".
    IF pCodDoc = "G/R" THEN x-tipo-documento-sunat = "09".

    x-Serie-documento = x-prefijo-serie + SUBSTRING(pNroDoc,1,3).
    x-nro-documento = SUBSTRING(pNroDoc,4).
    x-serie-numero = x-Serie-documento + "-" + x-Nro-DOcumento.

    /* Documento */
    RUN extrae-estado(INPUT x-Tipo-Doc-Emisor, 
                      INPUT x-Tipo-Documento-Sunat, 
                      INPUT x-serie-numero,
                      OUTPUT x-estado-biz,
                      OUTPUT x-estado-sunat).
                
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        pEstadoDocumento = ENTRY(2,x-estado-biz,"|").
        RETURN.
    END.

    pEstadoBizlinks = x-estado-biz.
    pEstadoSunat = x-estado-sunat.

    IF ENTRY(1,pEstadoBizlinks,"|") = "MISSING" THEN DO:
        RUN gn/p-estados-bizlinks-sunat.r(INPUT x-estado-biz,
                                  INPUT x-estado-sunat,
                                  OUTPUT x-abreviado,
                                  OUTPUT x-detallado).
        pEstadoDocumento = x-abreviado.

        RETURN.
    END.
    /* si el Documento a sido enviado a BAJA -> (TRUE <> (x-felogcomprobantes.libre_c02 > "")), solo facturas */
    IF pCodDoc <> "G/R" AND NOT (AVAILABLE x-felogcomprobantes AND TRUE <> (x-felogcomprobantes.libre_c02 > "")) THEN DO:
        pEstadoDocumento = "Enviado a BAJA".        

        /* Estado de la BAJA 
            TipoDocmnto : RC, RA, RX, RC:Resumen Boletas, RA:Baja Facturas, RX:Baja Boletas 
        */
        x-Tipo-Documento-Sunat = "RA".
        IF SUBSTRING(x-prefijo-serie,1,1) = "B" THEN DO:
            x-Tipo-Documento-Sunat = "RC".
        END.
                
        x-serie-numero = x-felogcomprobantes.libre_c02.

        RUN extrae-estado(INPUT x-Tipo-Doc-Emisor, 
                          INPUT x-Tipo-Documento-Sunat, 
                          INPUT x-serie-numero,
                          OUTPUT x-estado-biz,
                          OUTPUT x-estado-sunat).

        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            RETURN.
        END.

        /**/
        RUN gn/p-estados-bizlinks-sunat.r(INPUT x-estado-biz,
                                  INPUT x-estado-sunat,
                                  OUTPUT x-abreviado,
                                  OUTPUT x-detallado).

        IF x-abreviado = "" THEN x-abreviado = "Sin ninguna respuesta".
        pEstadoDocumento = pEstadoDocumento + " : " + x-abreviado.
        RETURN.
    END.
    ELSE DO:

        /* FACTURAS */
        RUN gn/p-estados-bizlinks-sunat.r(INPUT x-estado-biz,
                                  INPUT x-estado-sunat,
                                  OUTPUT x-abreviado,
                                  OUTPUT x-detallado).
        pEstadoDocumento = x-abreviado.
    END.

END.
ELSE DO:
    /* Resumenes */
    x-Tipo-Documento-Sunat = pCodDoc.   /* RC, RA, RX, RC:Resumen Boletas, RA:Baja Facturas, RX:Baja Boletas */
    IF pCodDoc = 'RX' THEN x-Tipo-Documento-Sunat = 'RC'.
    x-serie-numero = pNroDoc.

    RUN extrae-estado(INPUT x-Tipo-Doc-Emisor, 
                      INPUT x-Tipo-Documento-Sunat, 
                      INPUT x-serie-numero,
                      OUTPUT x-estado-biz,
                      OUTPUT x-estado-sunat).

    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        pEstadoDocumento = ENTRY(2,pEstadoBizlinks,"|").
        RETURN.
    END.

    pEstadoBizlinks = x-estado-biz.
    pEstadoSunat = x-estado-sunat.

    /**/
    RUN gn/p-estados-bizlinks-sunat.r(INPUT x-estado-biz,
                              INPUT x-estado-sunat,
                              OUTPUT x-abreviado,
                              OUTPUT x-detallado).
    pEstadoDocumento = x-abreviado.

END.
/*
CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.
CREATE "MSXML2.DOMDocument.6.0" x-oXMLBody.

/* Ambas funcionan */
x-URL   = "http://" + x-servidor-ip + ":" + x-servidor-Puerto + "/einvoice/rest/" + x-Tipo-Doc-Emisor + "/" + 
                    x-Ruc-emisor + "/" + x-Tipo-Documento-Sunat + "/" + x-serie-numero.
                    /*x-Serie-documento + "-" + x-Nro-DOcumento.*/

x-oXmlHttp:OPEN( "GET", x-URL, NO ) .    
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml" ).
/*x-oXmlHttp:setRequestHeader( "Content-Length", LENGTH(lEnvioXML)).    */

x-oXmlHttp:setOption( 2, 13056 ) .  /*SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056*/             
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pEstadoBizLinks = "SIN CONEXION|No hay conexion con el PSE (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
    RETURN.
END.

IF x-oXmlHttp:STATUS <> 200 THEN DO:
    pEstadoBizLinks = "ERROR 200|" + x-oXmlHttp:responseText.
    RETURN .
END.
  
/* Respuesta */
DEFINE var x-oMsg AS COM-HANDLE NO-UNDO.
DEFINE VAR x-oRspta AS COM-HANDLE NO-UNDO.

DEFINE VAR x-rspta AS CHAR.
DEFINE VAR x-status AS CHAR.
DEFINE VAR x-status-descripcion AS CHAR.
DEFINE VAR x-status-documento AS CHAR.
DEFINE VAR x-status-sunat AS CHAR.

CREATE "MSXML2.DOMDocument.6.0" x-oRspta. 

x-rspta = x-oXmlHttp:responseText.
/*MESSAGE x-rspta.*/
x-oRspta:LoadXML(x-oXmlHttp:responseText).
x-oMsg = x-oRspta:selectSingleNode( "//status" ).
x-status = TRIM(x-oMsg:TEXT) NO-ERROR.
x-oMsg = x-oRspta:selectSingleNode( "//descriptionDetail" ).
x-status-descripcion = TRIM(x-oMsg:TEXT) NO-ERROR.
/* Sunat */
x-oMsg = x-oRspta:selectSingleNode( "//statusSunat" ).
x-status-sunat = TRIM(x-oMsg:TEXT) NO-ERROR.
x-oMsg = x-oRspta:selectSingleNode( "//statusDocument" ).
x-status-documento = TRIM(x-oMsg:TEXT) NO-ERROR.


IF x-status = ? THEN x-status = "".
IF x-status-descripcion = ? THEN x-status-descripcion = "".
IF x-status-sunat = ? THEN x-status-sunat = "".
IF x-status-documento = ? THEN x-status-documento = "".

pEstadoBizLinks = x-status + "|" + x-status-descripcion.
pEstadoSunat = x-status-sunat + "|".

RELEASE OBJECT x-oXmlHttp NO-ERROR.
RELEASE OBJECT x-oXMLBody NO-ERROR.
RELEASE OBJECT x-oRspta NO-ERROR.
RELEASE OBJECT x-oMsg NO-ERROR.
/*
MESSAGE "pEstadoBizLinks " pEstadoBizLinks SKIP
        "pEstadoSunat " pEstadoSunat.

*/
*/
RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-extrae-estado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extrae-estado Procedure 
PROCEDURE extrae-estado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-Tipo-Doc-Emisor AS CHAR.
DEFINE INPUT PARAMETER p-Tipo-Documento-Sunat AS CHAR.
DEFINE INPUT PARAMETER p-serie-numero AS CHAR.
DEFINE OUTPUT PARAMETER p-EstadoBizLinks AS CHAR INIT "|".
DEFINE OUTPUT PARAMETER p-EstadoSunat AS CHAR INIT "|". 

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.
CREATE "MSXML2.DOMDocument.6.0" x-oXMLBody.

/* Ambas funcionan */
x-URL   = "http://" + x-servidor-ip + ":" + x-servidor-Puerto + "/einvoice/rest/" + x-Tipo-Doc-Emisor + "/" + 
                    x-Ruc-emisor + "/" + x-Tipo-Documento-Sunat + "/" + x-serie-numero.

x-oXmlHttp:OPEN( "GET", x-URL, NO ) .    
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml" ).
/*x-oXmlHttp:setRequestHeader( "Content-Length", LENGTH(lEnvioXML)).    */

x-oXmlHttp:setOption( 2, 13056 ) .  /*SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056*/             
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    p-EstadoBizLinks = "SIN CONEXION|No hay conexion con el PSE (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
    /*MESSAGE x-URL.*/
    RETURN "ADM-ERROR".
END.

IF x-oXmlHttp:STATUS <> 200 THEN DO:
    p-EstadoBizLinks = "ERROR 200|" + x-oXmlHttp:responseText.
    RETURN "ADM-ERROR".
END.
  
/* MESSAGE x-url. */
/* Respuesta */
DEFINE var x-oMsg AS COM-HANDLE NO-UNDO.
DEFINE VAR x-oRspta AS COM-HANDLE NO-UNDO.

DEFINE VAR x-rspta AS CHAR.
DEFINE VAR x-status AS CHAR.
DEFINE VAR x-status-descripcion AS CHAR.
DEFINE VAR x-status-documento AS CHAR.
DEFINE VAR x-status-sunat AS CHAR.
DEFINE VAR x-mensaje-sunat AS CHAR.

CREATE "MSXML2.DOMDocument.6.0" x-oRspta. 

x-rspta = x-oXmlHttp:responseText.
IF USERID("DICTDB") = 'MASTER' OR USERID("DICTDB") = 'ADMIN' THEN DO:
    /*MESSAGE x-rspta. */
END.

x-oRspta:LoadXML(x-oXmlHttp:responseText).
x-oMsg = x-oRspta:selectSingleNode( "//status" ).
x-status = TRIM(x-oMsg:TEXT) NO-ERROR.
x-oMsg = x-oRspta:selectSingleNode( "//descriptionDetail" ).
x-status-descripcion = TRIM(x-oMsg:TEXT) NO-ERROR.

/* Sunat status */
x-oMsg = x-oRspta:selectSingleNode( "//statusSunat" ).
x-status-sunat = TRIM(x-oMsg:TEXT) NO-ERROR.

x-oMsg = x-oRspta:selectSingleNode( "//messageSunat" ).
x-mensaje-sunat = TRIM(x-oMsg:TEXT) NO-ERROR.
IF x-mensaje-sunat = ? THEN x-mensaje-sunat = "".

x-oMsg = x-oRspta:selectSingleNode( "//statusDocument" ).
x-status-documento = TRIM(x-oMsg:TEXT) NO-ERROR.

x-oMsg = x-oRspta:selectSingleNode( "//pdfFileUrl" ).
cUrlPDF = TRIM(x-oMsg:TEXT) NO-ERROR.

IF cUrlPDF = ? THEN cUrlPDF = "".
IF x-status = ? THEN x-status = "".
IF x-status-descripcion = ? THEN x-status-descripcion = "".
IF x-status-sunat = ? THEN x-status-sunat = "".
IF x-status-documento = ? THEN x-status-documento = "".

p-EstadoBizLinks = x-status + "|" + x-status-descripcion.
p-EstadoSunat = x-status-sunat + "|".

/* v2 */
/* <messageSunat>{"codigo":"2775","mensaje":"El XML no contiene el atributo o no existe informacion del codigo de ubigeo. :  error: Punto de LLegada: errorCode 2775 (nodo: "/" valor: "")"}</messageSunat> */
IF x-status-sunat = "RC_05" THEN DO:
    /* Rechazado por Sunat */
    x-mensaje-sunat = REPLACE(x-mensaje-sunat,"<messageSunat>","").
    x-mensaje-sunat = REPLACE(x-mensaje-sunat,"}</messageSunat>","").
    IF NUM-ENTRIES(x-mensaje-sunat,",") > 1 THEN DO:
        x-mensaje-sunat = ENTRY(2,x-mensaje-sunat,",").
    END.    
    pMotivoRechazo = x-mensaje-sunat.
END.
IF x-status-sunat = "AC_03" THEN DO:

END.

RELEASE OBJECT x-oXmlHttp NO-ERROR.
RELEASE OBJECT x-oXMLBody NO-ERROR.
RELEASE OBJECT x-oRspta NO-ERROR.
RELEASE OBJECT x-oMsg NO-ERROR.
/*
MESSAGE "pEstadoBizLinks " pEstadoBizLinks SKIP
        "pEstadoSunat " pEstadoSunat.

*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-webservice-configuracion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE webservice-configuracion Procedure 
PROCEDURE webservice-configuracion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                            factabla.tabla = "CONFIG-FE-BIZLINKS" AND
                            factabla.codigo = "TODOS" NO-LOCK NO-ERROR.
IF NOT AVAILABLE factabla THEN DO:
    /*MESSAGE "El Servidor del WebService no esta configurado" VIEW-AS ALERT-BOX INFORMATION.*/
    RETURN "ADM-ERROR".
END.
/*  */
x-servidor-ip = TRIM(factabla.campo-c[1]).
x-servidor-puerto = TRIM(factabla.campo-c[2]).

IF (TRUE <> (x-servidor-ip > "")) OR (TRUE <> (x-servidor-puerto > "")) THEN DO:
    x-servidor-ip = "".
    x-servidor-puerto = "".

    /*MESSAGE "La IP y/o Puerto del Servidor del WebService esta vacio" VIEW-AS ALERT-BOX INFORMATION.*/
    RETURN "ADM-ERROR".
END.

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

