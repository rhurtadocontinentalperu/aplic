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
DEFINE INPUT PARAMETER pTipoDocmto AS CHAR.
DEFINE INPUT PARAMETER pNroDocmto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pReturn AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pOtros AS CHAR NO-UNDO.

/*
    Si pOtros = "", documentos electronicos.
    Si pOtros = "XML", solo genera XML a documentos electronicos.
    Si pOtros = "CONTINGENCIA", documentos de contigencia.
    Si pOtros = "XMLCONTINGENCIA", solo genera XML a documentos de contigencia.
*/

DEFINE SHARED VAR s-codcia AS INT.

/* Datos del Documento */
DEFINE VAR cTipoDocto AS CHAR FORMAT 'x(2)'.
DEFINE VAR cNroDocto AS CHAR.
DEFINE VAR cDivision AS CHAR.
DEFINE VAR fFechaInicioFE AS DATE.
DEFINE VAR cDivisionEmision AS CHAR.

fFechaInicioFE = 06/10/2016.

/* Directorios - Carpeta Compartida 
    - Se dejos sin efecto, pero los programas quedan, se opto por EPOS */

DEFINE VAR cPathTemporal AS CHAR.
/**/

DEFINE VAR cIPorigen AS CHAR.
DEFINE VAR cIPdestino AS CHAR.
DEFINE VAR cOtrosDatos AS CHAR.

cIPorigen = "192.168.100.217".

RUN lib/redireccionar-ip(cIPorigen, cOtrosDatos, OUTPUT cIPdestino).

/*cPathTemporal = "\\192.168.100.217\newsie\FE_BORRAR".*/
cPathTemporal = "\\" + cIPdestino + "\newsie\FE_BORRAR".

DEFINE VAR x-servidor-ip AS CHAR INIT "".
DEFINE VAR x-servidor-puerto AS CHAR INIT "".
DEFINE VAR loXmlHttp AS COM-HANDLE NO-UNDO.
DEFINE VAR loXMLBody AS com-HANDLE NO-UNDO.

DEFINE VAR gcCRLF AS CHAR.

/* set the Carraige return/line feed we need to delimit the scripts */ 
ASSIGN gcCRLF = CHR(13) + CHR(10). 

/* De los documentos */
DEFINE VAR cDoctosValidos AS CHAR.
DEFINE VAR cTipoDoctoSunat AS CHAR FORMAT 'x(2)'.
DEFINE VAR cSerieSunat AS CHAR FORMAT 'x(4)'.
DEFINE VAR cCorrelativoSunat AS CHAR FORMAT 'x(6)'.
DEFINE VAR lFmtoImpte AS CHAR INIT ">>>>>>9.99".

cDoctosValidos = "FAC,BOL,N/C,N/D".

/* De la Empresa */
DEFINE VAR cRucEmpresa AS CHAR FORMAT 'x(11)'.
DEFINE VAR cRazonSocial AS CHAR.
DEFINE VAR cNombreComercial AS CHAR.
DEFINE VAR cURLDocumento AS CHAR.
DEFINE VAR cDirecEmisor AS CHAR.
DEFINE VAR cUBIGEO AS CHAR.

cRucEmpresa = "20100038146".
cRazonSocial = "Continental S.A.C.".
cNombreComercial = cRazonSocial.
cDirecEmisor = "CAL.RENE DESCARTES Nro.114 URB.SANTA RAQUEL II ETAPA, LIMA-LIMA-ATE".
cUBIGEO = "150103".

DEFINE VAR cUrbanizacion AS CHAR.
DEFINE VAR cDepartamento AS CHAR.
DEFINE VAR cProvincia AS CHAR.
DEFINE VAR cDistrito AS CHAR.

FIND FIRST gn-cias NO-LOCK NO-ERROR.

cDirecEmisor = gn-cias.dircia.
cUrbanizacion = gn-cias.libre-c[16].     /* Urb */
cDepartamento = gn-cias.libre-c[17].     /* Dpto */
cProvincia = gn-cias.libre-c[18].        /* Prov */
cDistrito = gn-cias.libre-c[19].         /* Distrito */
cUBIGEO = gn-cias.libre-c[20].

DEFINE VAR hoXmlHttp AS COM-HANDLE NO-UNDO.
DEFINE VAR hoXMLBody AS com-HANDLE NO-UNDO.

DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR lxTipoOperacion AS CHAR.
DEFINE VAR x-CodigoEstablecimiento AS CHAR.
DEFINE VAR x-ruta-file-contingencia AS CHAR INIT "".

DEFINE VAR x-XML-documento AS LONGCHAR.
DEFINE VAR x-XML-cabecera AS LONGCHAR.
DEFINE VAR x-XML-detalle AS LONGCHAR.
DEFINE VAR x-XML-adicionales AS LONGCHAR.
DEFINE VAR x-xml-hashcode AS LONGCHAR.

DEFINE VAR x-Importe-maximo-boleta AS DEC INIT 700.00.      /* Maximo venta boleta */
DEFINE VAR x-url-consulta-documento-electronico AS CHAR.
DEFINE VAR x-doc-referencia AS CHAR INIT "".
DEFINE VAR x-ruc-cli AS CHAR.
DEFINE VAR x-tipo-ide AS CHAR.

DEFINE VAR cURL_wdsl_SUNAT AS CHAR.

cURL_wdsl_SUNAT = "https://www.sunat.gob.pe:443/ol-it-wsconscpegem/billConsultService?wsdl".

DEFINE STREAM sFileTxt.
define stream log-epos.     /* Trama del ePOS */
DEFINE VAR mShowMsg AS LOG INIT NO.

DEFINE VAR cDATAQR AS CHAR INIT "".

/**/
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.

/* Totales */
DEFINE VAR x-vvta-gravada AS DEC INIT 0.
DEFINE VAR x-vvta-inafectas AS DEC INIT 0.
DEFINE VAR x-vvta-exoneradas AS DEC INIT 0.
DEFINE VAR x-vvta-gratuitas AS DEC INIT 0.
DEFINE VAR x-total-igv AS DEC INIT 0.               /* Total Impuestos */
DEFINE VAR x-total-igv2 AS DEC INIT 0.              /* IGV */
DEFINE VAR x-imp-total AS DEC INIT 0.
DEFINE VAR x-imp-isc AS DEC INIT 0.

DEFINE VAR x-tipo-docmnto-sunat AS CHAR INIT "".
DEFINE VAR x-tipoDocumentoAdquiriente AS CHAR INIT "".
DEFINE VAR x-numeroDocumentoAdquiriente AS CHAR INIT "".
/* Caso de N/C, N/D */
DEFINE VAR x-tipoDocumentoReferenciaPrincipal AS CHAR INIT "".
DEFINE VAR x-numeroDocumentoReferenciaPrincipal AS CHAR INIT "".

/**/
DEFINE VAR x-generar-solo-xml AS LOG INIT NO.
DEFINE VAR x-documento-contingencia AS LOG INIT NO.

IF pOtros = "XML" THEN x-generar-solo-xml = YES.
IF pOtros = "CONTINGENCIA" THEN x-documento-contingencia = YES.
IF pOtros = "XMLCONTINGENCIA" THEN DO:
    x-documento-contingencia = YES.
    x-generar-solo-xml = YES.
END.        

/* */
DEFINE VAR h-query  AS HANDLE.
DEFINE VAR p-buffer AS HANDLE.
DEFINE VAR p-field AS HANDLE.

DEFINE TEMP-TABLE ttFields
    FIELD   tFieldName  AS  CHAR
    FIELD   tHandle     AS  HANDLE
    FIELD   tIndexField AS  INT.

/*
IF NUM-ENTRIES(pCodDiv,"|") > 1 THEN DO:
    IF ENTRY(1,pCodDiv,"|") = "XML" THEN x-generar-solo-xml = YES.
    IF ENTRY(1,pCodDiv,"|") = "CONTINGENCIA" THEN x-documento-contingencia = YES.
    IF ENTRY(1,pCodDiv,"|") = "XMLCONTINGENCIA" THEN DO:
        x-documento-contingencia = YES.
        x-generar-solo-xml = YES.
    END.        

    pCodDiv = ENTRY(2,pCodDiv,"|").
    MESSAGE "xxx" pCodDiv.
END.
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

&IF DEFINED(EXCLUDE-fget-utf-8) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-utf-8 Procedure 
FUNCTION fget-utf-8 RETURNS CHARACTER
  ( INPUT pString AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fshow-msg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fshow-msg Procedure 
FUNCTION fshow-msg RETURNS CHARACTER
  ( INPUT pMsg AS CHAR )  FORWARD.

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
         HEIGHT             = 15.77
         WIDTH              = 62.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = s-codcia AND 
                            FELogComprobantes.coddiv = pCodDiv AND
                            FELogComprobantes.coddoc = pTipoDocmto AND 
                            FELogComprobantes.nrodoc = pNroDocmto NO-LOCK NO-ERROR.

IF NOT AVAILABLE FELogComprobantes THEN DO:
    IF x-generar-solo-xml = NO THEN DO:
        pReturn = "666|Documento NO esta PROCESADO en FELogComprobantes (Div:" + pCodDiv + 
                                            ", TDoc : " + pTipoDocmto + ", NroDoc : " + pNroDocmto + ")".
        RETURN "ADM-ERROR".
    END.
END. 

FIND FIRST FECOMPROCAB WHERE FECOMPROCAB.codcia = s-codcia AND 
                            FECOMPROCAB.coddoc = pTipoDocmto AND 
                            FECOMPROCAB.nrodoc = pNroDocmto NO-LOCK NO-ERROR.
IF NOT AVAILABLE FECOMPROCAB THEN DO:
    /* Si no existe enviamos a crearlos */
    IF x-generar-solo-xml = NO THEN DO:
        pReturn = "666|Documento NO esta en la tabla de envio - FECOMPROCAB (Div:" + pCodDiv + 
                                            ", TDoc : " + pTipoDocmto + ", NroDoc : " + pNroDocmto + ")".
        RETURN "ADM-ERROR".
    END.

END. 

/* Verificar si el documento existe y no este anulado */  
FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                            b-ccbcdocu.coddiv = pCodDiv AND 
                            b-ccbcdocu.coddoc = pTipoDocmto AND 
                            b-ccbcdocu.nrodoc = pNroDocmto
                            NO-LOCK NO-ERROR.

IF NOT AVAILABLE b-ccbcdocu  THEN DO:
    pReturn = "004|Documento (" + pTipoDocmto + "-" + pNroDocmto + ") NO existe - al enviar el XML".
    RETURN "ADM-ERROR".
END.
IF x-generar-solo-xml = NO THEN DO:
    IF b-ccbcdocu.flgest = 'A' THEN DO:
        pReturn = "004|Documento (" + pTipoDocmto + "-" + pNroDocmto + ") esta ANULADO (Generando trama)".
        RETURN "ADM-ERROR".
    END.
END.

IF x-documento-contingencia = YES THEN cSerieSunat = "0".
/* aca hay q verificar si el FECOMPROCAB tambien es contingencia */
 
x-servidor-ip = "".
x-servidor-puerto = "".

/* Servidor Webservice BIZLINKS */
FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                            factabla.tabla = "CONFIG-FE-BIZLINKS" AND
                            factabla.codigo = pCodDiv NO-LOCK NO-ERROR.

IF AVAILABLE factabla THEN DO:
    /* De la division */
    x-servidor-ip = TRIM(factabla.campo-c[1]).
    x-servidor-puerto = TRIM(factabla.campo-c[2]).
END.
FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                            factabla.tabla = "CONFIG-FE-BIZLINKS" AND
                            factabla.codigo = "TODOS" NO-LOCK NO-ERROR.
IF NOT AVAILABLE factabla THEN DO:
    pReturn = "667|El Servidor del WebService no esta configurado".
    RETURN "ADM-ERROR".
END.
x-url-consulta-documento-electronico = TRIM(factabla.campo-c[3]).
x-Importe-maximo-boleta = factabla.valor[1].

IF TRUE <> (x-servidor-ip > "") THEN DO:
    /*  */
    x-servidor-ip = TRIM(factabla.campo-c[1]).
    x-servidor-puerto = TRIM(factabla.campo-c[2]).
END.
IF (TRUE <> (x-servidor-ip > "")) OR (TRUE <> (x-servidor-puerto > "")) THEN DO:
    pReturn = "667|La IP y/o Puerto Servidor del WebService esta vacio".
    RETURN "ADM-ERROR".
END.

IF TRUE <> (x-servidor-ip > "") THEN DO:
    pReturn = "667|La IP del Servidor del WebService no esta vacio".
    RETURN "ADM-ERROR".
END.
IF TRUE <> (x-servidor-puerto > "") THEN DO:
    pReturn = "667|El PUERTO del Servidor del WebService no esta vacio".
    RETURN "ADM-ERROR".
END.
IF TRUE <> (x-url-consulta-documento-electronico > "") THEN DO:
    pReturn = "667|El URL para la consulta del documento electronico no esta definidos".
    RETURN "ADM-ERROR".
END.

/* Construyo el XML */
x-XML-documento = "".
x-XML-detalle = "".
x-XML-cabecera = "".
x-XML-adicionales = "".

/* Envio a SUNAT */
DEFINE VAR x-retval AS CHAR INIT "".
DEFINE VAR x-data-QR AS CHAR.
DEFINE VAR x-emision AS CHAR.
DEFINE VAR x-txt-contingencia AS CHAR INIT "".

IF fecomprocab.contingencia = '1' THEN DO:
    x-txt-contingencia = "<contingencia>1</contingencia>".
END.

    cTipoDoctoSunat = fecomprocab.tipodocumento.
    cSerieSunat = ENTRY(1,fecomprocab.serienumero,"-").
    cCorrelativoSunat = ENTRY(1,fecomprocab.serienumero,"-").
    x-vvta-gravada = fecomprocab.totvvtaopgravadas.
    x-vvta-inafectas = fecomprocab.totvvtaopnogravadas.       
    x-vvta-exoneradas = fecomprocab.totvvtaopexoneradas.
    x-vvta-gratuitas = fecomprocab.totvvtaopgratuitas.
    x-total-igv = fecomprocab.totimpuestos.
    x-total-igv2 = fecomprocab.totigv.
    x-imp-total = fecomprocab.totalventa.
    x-imp-isc = 0.        
    x-emision = fecomprocab.fechaemision.
    x-tipo-ide = TRIM(fecomprocab.tipodocadquiriente).
    x-ruc-cli = TRIM(fecomprocab.nrodocadquiriente).
    x-tipoDocumentoAdquiriente = x-tipo-ide.
    x-numeroDocumentoAdquiriente = x-ruc-cli.
    x-tipoDocumentoReferenciaPrincipal = TRIM(fecomprocab.tipodocrefprincipal).
    x-numeroDocumentoReferenciaPrincipal = TRIM(fecomprocab.nrodocrefprincipal).
    x-tipo-docmnto-sunat = fecomprocab.tipodocumento.


/* Data del documento */

/* La cabecera */

    p-buffer = BUFFER FECOMPROCAB:HANDLE.
    
    CREATE QUERY h-query.
    h-query:SET-BUFFERS(BUFFER FECOMPROCAB:HANDLE). 
    h-query:QUERY-PREPARE("for each " + p-buffer:NAME + " where codcia = " + STRING(s-codcia) +
                        " and coddoc = '" + pTipoDocmto + "' and nrodoc = '" + pNroDocmto + "'"). 
    h-query:QUERY-OPEN().
    h-query:GET-FIRST().
    RUN extraigo-los-campos.
    RUN generar-xml(INPUT "FECOMPROCAB", OUTPUT x-XML-cabecera).
    h-query:QUERY-CLOSE() NO-ERROR.

    x-XML-cabecera = x-txt-contingencia + "<correoEmisor>-</correoEmisor>" + x-XML-cabecera.
    
/* Detalle */
    p-buffer = BUFFER FECOMPRODET:HANDLE.
    CREATE QUERY h-query.
    h-query:SET-BUFFERS(BUFFER FECOMPRODET:HANDLE). 
    h-query:QUERY-PREPARE("for each " + p-buffer:NAME + " where codcia = " + STRING(s-codcia) +
                        " and coddoc = '" + pTipoDocmto + "' and nrodoc = '" + pNroDocmto + "'"). 
    h-query:QUERY-OPEN().
    h-query:GET-FIRST().

    RUN extraigo-los-campos.
    RUN generar-xml(INPUT "FECOMPRODET", OUTPUT x-XML-detalle).
    h-query:QUERY-CLOSE() NO-ERROR.

    /* Envia el XML a BizLinks */
    x-retval = "".
    RUN enviar-xml(OUTPUT x-retval).

    IF x-retval = "OK" THEN DO:
        /* Data para el QR */
        x-data-QR = cRucEmpresa + "@" + cTipoDoctoSunat + "@" + cSerieSunat + "@" + cCorrelativoSunat + "@" + 
                    TRIM(STRING(b-ccbcdocu.impigv,">>,>>>,>>9.99")) + "@" + TRIM(STRING(b-ccbcdocu.imptot,">>>,>>>,>>9.99")) + "@" +
                    x-emision + "@" + x-tipo-ide + "@" + x-ruc-cli + "@"
            .

        pReturn = "000|Proceso OK|" + x-xml-hashcode.
        IF (pTipoDocmto = 'N/C') OR (pTipoDocmto = 'N/D') THEN DO:
            pReturn = pReturn + "|" + x-doc-referencia. /* + "|" + x-data-QR.*/
        END.

        pReturn = pReturn + "|" + x-data-QR.

        /* Importes adicionales */
        pReturn = pReturn + "|" + STRING(x-vvta-gravada).
        pReturn = pReturn + "|" + STRING(x-vvta-inafectas).
        pReturn = pReturn + "|" + STRING(x-vvta-exoneradas).
        pReturn = pReturn + "|" + STRING(x-vvta-gratuitas).
        pReturn = pReturn + "|" + STRING(x-total-igv).          /* Total impuestos */
        pReturn = pReturn + "|" + STRING(x-total-igv2).         /* Total IGV */
        pReturn = pReturn + "|" + STRING(x-imp-isc).
        pReturn = pReturn + "|" + STRING(x-imp-total).
        pReturn = pReturn + "|" + x-tipo-docmnto-sunat.
        pReturn = pReturn + "|" + x-tipoDocumentoAdquiriente.
        pReturn = pReturn + "|" + x-numeroDocumentoAdquiriente.
        pReturn = pReturn + "|" + x-tipoDocumentoReferenciaPrincipal.
        pReturn = pReturn + "|" + x-numeroDocumentoReferenciaPrincipal.

    END.
    ELSE DO:
        IF x-generar-solo-xml = YES THEN DO:
            pReturn = "XXX|Genero el XML : " + x-retval.
        END.
        ELSE DO:
            pReturn = "999|Imposible enviar el XML : " + x-retval.
        END.

    END.

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-enviar-xml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-xml Procedure 
PROCEDURE enviar-xml :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-msg AS CHAR.

/* Envio a BizLinks */
DEFIN VAR x-url-webservice AS CHAR.
DEFINE VAR x-loadXML AS LOG.

DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.
DEFINE VAR x-oXMLBody AS com-HANDLE NO-UNDO.

p-msg = "OK".

/* Uno los XMLs */
x-XML-documento = "<documentHeader>".
/*x-XML-documento = x-XML-documento + x-XML-cabecera + x-XML-adicionales + x-XML-detalle.*/
x-XML-documento = x-XML-documento + x-XML-cabecera + x-XML-detalle.
x-XML-documento = x-XML-documento + "</documentHeader>".   

/*
&apos; = '
&quot; = " 
*/

x-XML-documento = REPLACE(x-XML-documento,"&","&amp;").
x-XML-documento = REPLACE(x-XML-documento,"'","&apos;").
x-XML-documento = REPLACE(x-XML-documento,'"',"&quot;").

DEFINE VAR x-tmp AS CHAR.
DEFINE VAR x-nombre-del-xml AS CHAR.

x-tmp = session:temp-directory.

x-nombre-del-xml = x-tmp + cSerieSunat + "-" + cCorrelativoSunat + "-" + cTipoDoctoSunat + ".xml".

COPY-LOB x-XML-documento TO FILE x-tmp + cSerieSunat + "-" + cCorrelativoSunat + 
    "-" + cTipoDoctoSunat + ".xml" NO-ERROR.

IF x-generar-solo-xml = YES THEN DO:
    p-msg = x-nombre-del-xml.
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RELEASE OBJECT x-oXMLBody NO-ERROR.
    RETURN "ADM-ERROR".
END.

MESSAGE "dddd".
    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RELEASE OBJECT x-oXMLBody NO-ERROR.
    RETURN "ADM-ERROR".


/* ????????????????????????????????????????????? */
/* cRucEmpresa = '20511358907'.    R.U.C. - StandFord */

x-url-webservice = "http://" + x-servidor-ip + ":" + x-servidor-puerto + "/einvoice/rest/" +
                    "6/" + cRucEmpresa + "/" + cTipoDoctoSunat + "/" + cSerieSunat + "-" + cCorrelativoSunat.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.
CREATE "MSXML2.DOMDocument.6.0" x-oXMLBody.

x-loadXML = x-oXMLBody:loadXML(x-XML-documento) NO-ERROR. 

IF NOT x-loadXML THEN DO:    

    p-msg = "ERROR en loadXML : "  + gcCRLF + x-oXMLBody:parseError:reason.

    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RELEASE OBJECT x-oXMLBody NO-ERROR.
    RETURN "ADM-ERROR".
END.

x-oXmlHttp:OPEN( "PUT", x-url-webservice, NO ) .    
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=ISO-8859-1" ).
/*x-oXmlHttp:setRequestHeader( "Content-Length", LENGTH(x-xml-documento)).    */

x-oXmlHttp:setOption( 2, 13056 ) .  /*SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056*/             

x-oXmlHttp:SEND(x-oXMLBody:documentElement:XML) NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:    
    p-msg = "ERROR en SEND : El XML tiene problemas de Estructura (" + 
        STRING(ERROR-STATUS:GET-NUMBER(1)) + ")" + gcCRLF +  
        ERROR-STATUS:GET-MESSAGE(1).

    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RELEASE OBJECT x-oXMLBody NO-ERROR.
    RETURN "ADM-ERROR".
END.

IF x-oXmlHttp:STATUS <> 200 THEN DO:
    p-msg = "ERROR en SEND (Err:200) : " + gcCRLF + x-oXmlHttp:responseText. 

    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RELEASE OBJECT x-oXMLBody NO-ERROR.
    RETURN "ADM-ERROR".
END.

/* La Respuesta */
DEFINE VAR x-rspta AS CHAR.
DEFINE VAR x-orspta AS COM-HANDLE NO-UNDO.
DEFINE var x-oMsg AS COM-HANDLE NO-UNDO.

DEFINE VAR x-status AS CHAR.
DEFINE VAR x-codestatus AS CHAR.
DEFINE VAR x-hashcode AS CHAR.

CREATE "MSXML2.DOMDocument.6.0" x-orspta.

x-rspta = x-oXmlHttp:responseText.
x-oRspta:LoadXML(x-oXmlHttp:responseText).

x-oMsg = x-oRspta:selectSingleNode( "//status" ).
x-status = x-oMsg:TEXT NO-ERROR.
x-oMsg = x-oRspta:selectSingleNode( "//hashCode" ).
x-hashcode = x-oMsg:TEXT NO-ERROR.
x-oMsg = x-oRspta:selectSingleNode( "//codeStatus" ).
x-codestatus = x-oMsg:TEXT NO-ERROR.
/*  */
p-msg = x-rspta.

IF NOT (TRUE <> (x-status > "")) THEN DO:
    IF CAPS(x-status) = "DUPLICATED" OR CAPS(x-status) = "SIGNED" OR  CAPS(x-status) = "IN PROCESS" THEN DO:
        /* PROCESO OK */
        IF CAPS(x-status) = "SIGNED" THEN DO:
            x-xml-hashcode = x-hashcode.
            p-msg = "OK".
        END.
        ELSE DO:
            p-msg = "El documento esta " + x-status.
        END.
    END.
    ELSE DO:
        x-oMsg = x-oRspta:selectSingleNode( "//message" ).
        x-codestatus = x-oMsg:TEXT NO-ERROR.       
        IF x-codestatus = ? THEN DO:
            /**/
        END.
        ELSE DO:
            p-msg = TRIM(x-codestatus).
        END.
    END.
END.
ELSE DO:
    IF NOT (TRUE <> (x-codestatus > "") ) THEN DO:
        x-oMsg = x-oRspta:selectSingleNode( "//descriptionDetail" ).
        x-codestatus = x-oMsg:TEXT NO-ERROR.
        IF x-codestatus = ? THEN DO:
            /**/
        END.
        ELSE DO:
            p-msg = TRIM(x-codestatus).
        END.
    END.
END.

RELEASE OBJECT x-oXmlHttp NO-ERROR.
RELEASE OBJECT x-oXMLBody NO-ERROR.
RELEASE OBJECT x-oRspta NO-ERROR.
RELEASE OBJECT x-oMsg NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-extraigo-los-campos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extraigo-los-campos Procedure 
PROCEDURE extraigo-los-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-sec AS INT.

EMPTY TEMP-TABLE ttFields.

DO x-sec = 1 TO p-buffer:NUM-FIELDS:
    p-field = p-buffer:BUFFER-FIELD(x-sec).
    CREATE ttFields.
        ASSIGN ttFields.tFieldName = p-field:NAME
                ttFields.tHandle = p-field
                ttFields.tIndexField = x-sec.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generar-xml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-xml Procedure 
PROCEDURE generar-xml :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTabla AS CHAR.
DEFINE OUTPUT PARAMETER pRetValXML AS CHAR NO-UNDO.

DEFINE VAR x-data AS CHAR.

pRetValXML = "".

h-query:GET-FIRST().

DO WHILE NOT h-query:QUERY-OFF-END:
    IF pTabla = "FECOMPRODET" THEN DO:
        pRetValXML = pRetValXML + "<item>".
    END.
    
    FOR EACH fetabtag WHERE fetabtag.codcia = s-codcia AND 
                            fetabtag.tabla = pTabla AND 
                            fetabtag.inactivo = NO BY orden:
        IF TRUE <> (fetabtag.tag > "") THEN NEXT.

        FIND FIRST ttFields WHERE ttFields.tFieldName = fetabtag.nomcampo
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE ttFields THEN DO:
            p-field = p-buffer:BUFFER-FIELD(ttFields.tIndexField).
            /*
                 Se asume que la tabla solo tiene valores CHARACTER
                 INTEGER, DECIMAL si existe otro tipo se debe programar
             */
            IF STRING(p-field:BUFFER-VALUE) <> ? THEN DO:
                x-data = "".
                IF fetabtag.condicionado = 'S' THEN DO:
                    /* Vacio y Ceros no van */
                    IF p-field:DATA-TYPE = "character" THEN DO:
                        IF TRUE <> (STRING(p-field:BUFFER-VALUE) > "") THEN NEXT.
                    END.
                    ELSE DO:
                        IF p-field:BUFFER-VALUE <= 0 THEN NEXT.
                    END.
                END.
                IF p-field:DATA-TYPE = "character" THEN DO:
                    x-data = TRIM(p-field:BUFFER-VALUE).
                END.
                ELSE DO:
                    IF TRUE <> (fetabtag.formato > "") THEN DO:
                        x-data = STRING(p-field:BUFFER-VALUE).
                    END.
                    ELSE DO:
                        x-data = STRING(p-field:BUFFER-VALUE,TRIM(fetabtag.formato)).
                    END.
                END.
                /**/
                IF (fetabtag.tag BEGINS "codigoAuxiliar") OR
                    (fetabtag.tag BEGINS "codigoLeyenda") THEN DO:
                    /* Codigo/Leyenda */
                    pRetValXML = pRetValXML + "<" + TRIM(fetabtag.tag) + ">" + 
                                TRIM(fetabtag.codigoauxiliar) +
                                "</" + TRIM(fetabtag.tag) + ">".
                    /* Texto */
                    pRetValXML = pRetValXML + "<" + REPLACE(TRIM(fetabtag.tag),"codigo","texto") + ">" + 
                                TRIM(x-data) +
                                "</" + REPLACE(TRIM(fetabtag.tag),"codigo","texto") + ">".

                END.
                ELSE DO:
                    pRetValXML = pRetValXML + "<" + TRIM(fetabtag.tag) + ">" + 
                                TRIM(x-data) +
                                "</" + TRIM(fetabtag.tag) + ">".
                END.
            END.
        END.        
    END.
    IF pTabla = "FECOMPRODET" THEN DO:
        pRetValXML = pRetValXML + "</item>".
    END.

    h-query:GET-NEXT().
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fget-utf-8) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-utf-8 Procedure 
FUNCTION fget-utf-8 RETURNS CHARACTER
  ( INPUT pString AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VAR lRetVal AS CHAR.
DEF VAR x-dice AS CHAR NO-UNDO.
DEF VAR x-debedecir AS CHAR NO-UNDO.

/* UTF-8 */
x-dice = TRIM(pString).
RUN lib\limpiar-texto(x-dice,'',OUTPUT x-debedecir).
lRetVal = CODEPAGE-CONVERT(x-debedecir, "utf-8", SESSION:CHARSET).

RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fshow-msg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fshow-msg Procedure 
FUNCTION fshow-msg RETURNS CHARACTER
  ( INPUT pMsg AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR xUserId AS CHAR.

  xUserid = CAPS(USERID("integral")).

  IF (xUserId = 'ADMIN' OR xUserId = 'MASTER') AND mShowMsg = YES THEN DO:
        MESSAGE pMsg.
  END.


  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

