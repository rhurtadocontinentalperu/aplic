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

/*RUN pwrite_log("Definiciones de p-estado....-v3xxxxxxxxx.p").*/

DEFINE TEMP-TABLE tTagsEstadoDoc
    FIELD   cTag    AS  CHAR    FORMAT 'x(100)'
    FIELD   cValue  AS  CHAR    FORMAT 'x(255)'.

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE INPUT PARAMETER pContenido AS CHAR.      /*  */
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tTagsEstadoDoc.      /*  */

DEFINE TEMP-TABLE tTagsEstadoConfig
    FIELD   cTag    AS  CHAR    FORMAT 'x(100)'.

DEFINE NEW SHARED VAR s-codcia AS INT INIT 1.

DEFINE VAR x-servidor-ip AS CHAR.
DEFINE VAR x-servidor-puerto AS CHAR.

DEFINE VAR x-ruc-emisor AS CHAR INIT "20100038146".
DEFINE VAR x-tipo-doc-emisor AS CHAR INIT "6".
DEFINE VAR x-serie-documento AS CHAR.
DEFINE VAR x-nro-documento AS CHAR.
DEFINE VAR x-tipo-documento-sunat AS CHAR INIT "XX".
DEFINE VAR x-url AS CHAR.

DEFINE BUFFER x-felogcomprobantes FOR felogcomprobantes.

DEFINE VAR cFiler00 AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fwrite_log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fwrite_log Procedure 
FUNCTION fwrite_log RETURNS CHARACTER
  (INPUT pTexto AS CHAR)  FORWARD.

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
         HEIGHT             = 12.92
         WIDTH              = 75.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN webservice-configuracion.

IF x-servidor-ip = "" THEN DO:
    cFiler00 = fwrite_log("La IP del servidor del WEBSERVICE esta vacio").
    RUN add_value("ERROR","La IP del servidor del WEBSERVICE esta vacio").    
    RETURN "ADM-ERROR".
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
                                         OUTPUT x-prefijo-serie) NO-ERROR.
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

    cFiler00 = fwrite_log(pCodDoc + " " + pNroDoc + " Cual es el estado" ).
    /* Documento */
    RUN extrae-estado(INPUT x-Tipo-Doc-Emisor, 
                      INPUT x-Tipo-Documento-Sunat, 
                      INPUT x-serie-numero,
                      OUTPUT x-estado-biz,
                      OUTPUT x-estado-sunat) NO-ERROR.
    cFiler00 = fwrite_log(pCodDoc + " " + pNroDoc + " Cual es el estado....regreso" ).
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
                      OUTPUT x-estado-sunat) NO-ERROR.
END.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-add_value) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add_value Procedure 
PROCEDURE add_value :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER cTag AS CHAR.
DEFINE INPUT PARAMETER cValue AS CHAR.

CREATE tTagsEstadoDoc.
    ASSIGN tTagsEstadoDoc.ctag = ctag
            tTagsEstadoDoc.cvalue = cValue.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

/* Ambas funcionan */
x-URL   = "http://" + x-servidor-ip + ":" + x-servidor-Puerto + "/einvoice/rest/" + x-Tipo-Doc-Emisor + "/" + 
                    x-Ruc-emisor + "/" + x-Tipo-Documento-Sunat + "/" + x-serie-numero.

/*MESSAGE "x-URL " x-URL.*/

/* El contenido de la web */
define var v-result as char no-undo.
define var v-response as LONGCHAR no-undo.
define var v-content as LONGCHAR no-undo.
define var cTexto as LONGCHAR no-undo.

DEFINE VAR cValueTag AS CHAR.

DEFINE VAR cTagInicial AS CHAR.
DEFINE VAR cTagFinal AS CHAR.
DEFINE VAR lCargaInfoApi AS LOG.


RUN lib/http-get-contenido.r(x-Url,output v-result,output v-response,output v-content) NO-ERROR.

IF USERID("dictdb") = "ADMIN" OR USERID("dictdb") = "MASTER" THEN DO:
    /*
    MESSAGE "v-result " SKIP
            v-result SKIP
            "v-content : "SKIP
            string(v-content).
    */
END.
IF v-result = "1:Success"  THEN DO:

    cTagInicial = "<status>".
    cTagFinal =  "</status>".
    RUN getValueTag(v-content,cTagInicial,cTagFinal, OUTPUT cTexto).
    
    IF lookup(string(cTexto),"ERROR,IN PROCESS") > 0 THEN DO:

        cValueTag = cTexto.

        cTagInicial = "<descriptionDetail>".
        cTagFinal =  "</descriptionDetail>".
        RUN getValueTag(v-content,cTagInicial,cTagFinal, OUTPUT cTexto).

        IF lookup(cValueTag,"IN PROCESS") > 0 AND TRUE <> (cTexto > "") THEN DO:
            cTexto = "EN PROCESO!!".
        END.

        RUN add_value("statusSunat",cValueTag).
        RUN add_value("messageSunat",cTexto).
    END.
    ELSE DO:
        /* Cargo los TAGs */
        lCargaInfoApi = NO.
        FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'CONFIG-GRE' AND
                                vtatabla.llave_c1 = "XML TAGS" AND vtatabla.llave_c2 = pContenido NO-LOCK:
            CREATE tTagsEstadoConfig.
            ASSIGN tTagsEstadoConfig.cTag = vtatabla.llave_c4.
            lCargaInfoApi = YES.
        END.
        
        FOR EACH tTagsEstadoConfig NO-LOCK:

            cTagInicial = "<" + tTagsEstadoConfig.cTag + ">".
            cTagFinal =  "</" + tTagsEstadoConfig.cTag + ">".
            RUN getValueTag(v-content,cTagInicial,cTagFinal, OUTPUT cTexto).

            IF cTexto = ? THEN NEXT.
            IF TRUE <> (cTexto > "") THEN NEXT.
            RUN add_value(tTagsEstadoConfig.cTag,cTexto).
        END.

        
        IF USERID("dictdb") = "ADMIN" OR USERID("dictdb") = "MASTER" THEN DO:
            /*
            DEFINE VAR xhProc AS HANDLE NO-UNDO.

            RUN lib\Tools-to-excel PERSISTENT SET xhProc.

            def var c-csv-file as char no-undo.
            def var c-xls-file as char no-undo. /* will contain the XLS file path created */

            c-xls-file = 'd:\xpciman\TagGRE.xlsx'.

            run pi-crea-archivo-csv IN xhProc (input  buffer tTagsEstadoDoc:handle,
                                    /*input  session:temp-directory + "file"*/ c-xls-file,
                                    output c-csv-file) .

            run pi-crea-archivo-xls  IN xhProc (input  buffer tTagsEstadoDoc:handle,
                                    input  c-csv-file,
                                    output c-xls-file) .

            DELETE PROCEDURE xhProc.
            MESSAGE "Excel".
            */
        END.
        
    END.
END.

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-extrae-estado-old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extrae-estado-old Procedure 
PROCEDURE extrae-estado-old :
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

/*
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
    RUN add_value("ERROR","No hay conexion con el PSE (" + ERROR-STATUS:GET-MESSAGE(1) + ")").    
    RETURN "ADM-ERROR".
END.

IF x-oXmlHttp:STATUS <> 200 THEN DO:
    RUN add_value("ERROR","<> 200 : " + x-oXmlHttp:responseText).
    RETURN "ADM-ERROR".
END.
  
/* Respuesta */
DEFINE var x-oMsg AS COM-HANDLE NO-UNDO.
DEFINE VAR x-oRspta AS COM-HANDLE NO-UNDO.

DEFINE VAR x-rspta AS CHAR.
DEFINE VAR x-valuetxt AS CHAR.
DEFINE VAR iCount AS INT.

CREATE "MSXML2.DOMDocument.6.0" x-oRspta. 

x-rspta = x-oXmlHttp:responseText.
IF USERID("DICTDB") = 'MASTER' OR USERID("DICTDB") = 'ADMIN' THEN DO:
    MESSAGE x-rspta. 
END.

/* Cargo los TAGs */

FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'CONFIG-GRE' AND
                        vtatabla.llave_c1 = "XML TAGS" AND vtatabla.llave_c2 = pContenido NO-LOCK:
    CREATE tTagsEstadoConfig.
    ASSIGN tTagsEstadoConfig.cTag = vtatabla.llave_c4.
    iCount = iCount + 1.
END.

x-oRspta:LoadXML(x-oXmlHttp:responseText).

FOR EACH tTagsEstadoConfig NO-LOCK:
    x-oMsg = x-oRspta:selectSingleNode( "//" + tTagsEstadoConfig.cTag).
    x-valuetxt = TRIM(x-oMsg:TEXT) NO-ERROR.
    IF x-valuetxt = ? THEN NEXT.
    IF TRUE <> (x-valuetxt > "") THEN NEXT.
    RUN add_value(tTagsEstadoConfig.cTag,x-valuetxt).
END.

/*
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
    x-mensaje-sunat = ENTRY(2,x-mensaje-sunat,",").
    pMotivoRechazo = x-mensaje-sunat.
END.
IF x-status-sunat = "AC_03" THEN DO:

END.
*/

RELEASE OBJECT x-oXmlHttp NO-ERROR.
RELEASE OBJECT x-oXMLBody NO-ERROR.
RELEASE OBJECT x-oRspta NO-ERROR.
RELEASE OBJECT x-oMsg NO-ERROR.
*/

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
DEFINE INPUT PARAMETER pContent AS LONGCHAR.
DEFINE INPUT PARAMETER pTagInicial AS CHAR.
DEFINE INPUT PARAMETER ptagFinal AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LONGCHAR.

DEFINE VAR iPosInicial AS INT.
DEFINE VAR iPosFinal AS INT.

iPosInicial = INDEX(pContent,pTagInicial).
IF iPosInicial > 0 THEN DO:
    iPosFinal = INDEX(pContent,pTagFinal).
    IF iPosFinal > 0 THEN DO:
        pRetVal = SUBSTRING(pContent,iPosInicial + LENGTH(pTagInicial),(iPosFinal - (iPosInicial + LENGTH(pTagInicial))) ).
    END.
    ELSE DO:
        pRetVal = SUBSTRING(pContent,iPosInicial + LENGTH(pTagInicial) ).
    END.

    pRetVal = TRIM(pRetVal).

    IF pRetVal = ? THEN pRetVal = "".
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pwrite_log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pwrite_log Procedure 
PROCEDURE pwrite_log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTexto AS CHAR NO-UNDO.
/*
DEFINE VAR x-linea AS CHAR.

x-linea = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"hh:mm:ss") + " - " + TRIM(pTexto).

PUT UNFORMATTED x-linea SKIP.
*/

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

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fwrite_log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fwrite_log Procedure 
FUNCTION fwrite_log RETURNS CHARACTER
  (INPUT pTexto AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
/*
DEFINE VAR x-linea AS CHAR.

x-linea = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"hh:mm:ss") + " - " + TRIM(pTexto).

PUT UNFORMATTED x-linea SKIP.
*/
RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

