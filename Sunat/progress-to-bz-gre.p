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
DEFINE INPUT PARAMETER pSerieGRE AS INT. 
DEFINE INPUT PARAMETER pNroGRE AS INT.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.   
DEFINE OUTPUT PARAMETER pReturn AS CHAR NO-UNDO.    
DEFINE INPUT-OUTPUT PARAMETER pOtros AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pEstadoBizlinks AS CHAR NO-UNDO.

/*
    Si pOtros = "", documentos electronicos.
    Si pOtros = "XML", solo genera XML nada mas a documentos electronicos.
    Si pOtros = "CONTINGENCIA", documentos de contigencia.
    Si pOtros = "XMLCONTINGENCIA", solo genera XML nada mas a documentos de contigencia.
    Si pOtros = "XMLTEST", Enviara servidores de prueba.
*/

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

/* Del servidor */
DEFINE VAR x-servidor-ip AS CHAR INIT "".
DEFINE VAR x-servidor-puerto AS CHAR INIT "".

/* set the Carraige return/line feed we need to delimit the scripts */ 
DEFINE VAR gcCRLF AS CHAR.
ASSIGN gcCRLF = CHR(13) + CHR(10). 

/* De la Empresa */
DEFINE VAR cRucEmpresa AS CHAR FORMAT 'x(11)'.
DEFINE VAR cRazonSocial AS CHAR.
DEFINE VAR cNombreComercial AS CHAR.
DEFINE VAR cURLDocumento AS CHAR.
/*DEFINE VAR cDirecEmisor AS CHAR.*/

cRucEmpresa = "20100038146".
cRazonSocial = "Continental S.A.C.".
cNombreComercial = cRazonSocial.
/*cDirecEmisor = "CAL.RENE DESCARTES Nro.114 URB.SANTA RAQUEL II ETAPA, LIMA-LIMA-ATE".*/

/* XML */
DEFINE VAR hoXmlHttp AS COM-HANDLE NO-UNDO.
DEFINE VAR hoXMLBody AS com-HANDLE NO-UNDO.
DEFINE VAR loXmlHttp AS COM-HANDLE NO-UNDO.
DEFINE VAR loXMLBody AS com-HANDLE NO-UNDO.

DEFINE VAR x-XML-documento AS LONGCHAR.
DEFINE VAR x-XML-cabecera AS LONGCHAR.
DEFINE VAR x-XML-detalle AS LONGCHAR.
DEFINE VAR x-XML-adicionales AS LONGCHAR.
DEFINE VAR x-XML-doc-relacionados AS LONGCHAR.
DEFINE VAR x-xml-hashcode AS LONGCHAR.

/* Comprobante */
DEFINE VAR cTipoDoctoSunat AS CHAR FORMAT 'x(2)'.
DEFINE VAR cSerieSunat AS CHAR FORMAT 'x(4)'.
DEFINE VAR cCorrelativoSunat AS CHAR FORMAT 'x(6)'.

/* Buffers Tables */
DEFINE BUFFER b-gre_header FOR gre_header.
DEFINE BUFFER b-gre_detail FOR gre_detail.
DEFINE BUFFER b-gre_doc_relacionado FOR gre_doc_relacionado.

/* Log */
DEFINE STREAM sFileTxt.
define stream log-epos.     /* Trama del ePOS */


/* Extras */
DEFINE VAR x-tipo-docmnto-sunat AS CHAR INIT "".
DEFINE VAR x-generar-solo-xml AS LOG INIT NO.
DEFINE VAR x-documento-contingencia AS LOG INIT NO.
DEFINE VAR x-enviar-servidor-prueba AS LOG INIT NO.

IF pOtros = "XML" THEN x-generar-solo-xml = YES.
IF pOtros = "CONTINGENCIA" THEN x-documento-contingencia = YES.
IF pOtros = "XMLCONTINGENCIA" THEN DO:
    x-documento-contingencia = YES.
    x-generar-solo-xml = YES.
END.        

IF pOtros = "XMLTEST" THEN DO:
    x-enviar-servidor-prueba = YES.
END.

/* ------------------------------------------------------------------------------- */
DEFINE VAR x-esta-probando AS LOG.
DEFINE VAR x-servidor-prueba AS LOG.
DEFINE VAR x-productivo AS LOG.

/* Servidor */
DEFINE VAR x-servidor AS CHAR.

x-servidor = "ninguno".
x-servidor = CAPS(SESSION:STARTUP-PARAMETERS).
IF INDEX(x-servidor,"-H") > 0 THEN DO:
    x-servidor = SUBSTRING(x-servidor,INDEX(x-servidor,"-H")).
    x-servidor = REPLACE(x-servidor,"-H","").
    IF INDEX(x-servidor,",") > 1 THEN DO:
        x-servidor = SUBSTRING(x-servidor,1,INDEX(x-servidor,",") - 1).
    END.
    x-servidor = TRIM(x-servidor).
END.

/**/
x-esta-probando = YES.
x-servidor-prueba = YES.

DEFINE VAR cIPorigen AS CHAR.
DEFINE VAR cIPdestino AS CHAR.
DEFINE VAR cOtrosDatos AS CHAR.

cIPorigen = "192.168.100.210".

RUN lib/redireccionar-ip(cIPorigen, cOtrosDatos, OUTPUT cIPdestino).

/*IF x-servidor = "192.168.100.210" THEN x-servidor-prueba = NO.*/
IF x-servidor = cIPdestino THEN x-servidor-prueba = NO.

/**/
x-productivo = NO.


/*
/* --------------------------------------------------------------------------- */
/* Datos del Documento */
DEFINE VAR cTipoDocto AS CHAR FORMAT 'x(5)'.    
DEFINE VAR cNroDocto AS CHAR.
DEFINE VAR cDivision AS CHAR.
DEFINE VAR fFechaInicioFE AS DATE.
DEFINE VAR cDivisionEmision AS CHAR.

fFechaInicioFE = 06/10/2016.

/* Directorios - Carpeta Compartida 
    - Se dejos sin efecto, pero los programas quedan, se opto por EPOS */

DEFINE VAR cPathTemporal AS CHAR.
/**/
cPathTemporal = "\\192.168.100.217\newsie\FE_BORRAR".

DEFINE VAR x-servidor-ip AS CHAR INIT "".
DEFINE VAR x-servidor-puerto AS CHAR INIT "".
DEFINE VAR loXmlHttp AS COM-HANDLE NO-UNDO.
DEFINE VAR loXMLBody AS com-HANDLE NO-UNDO.

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
DEFINE VAR x-XML-anticipos AS LONGCHAR.
DEFINE VAR x-XML-factoring AS LONGCHAR.

DEFINE VAR x-Importe-maximo-boleta AS DEC INIT 700.00.      /* Maximo venta boleta */
DEFINE VAR x-url-consulta-documento-electronico AS CHAR.
DEFINE VAR x-doc-referencia AS CHAR INIT "".
DEFINE VAR x-ruc-cli AS CHAR.
DEFINE VAR x-tipo-ide AS CHAR.
DEFINE VAR x-es-transferencia-gratuita AS LOGICAL INIT NO.

DEFINE VAR cURL_wdsl_SUNAT AS CHAR.

cURL_wdsl_SUNAT = "https://www.sunat.gob.pe:443/ol-it-wsconscpegem/billConsultService?wsdl".

DEFINE STREAM sFileTxt.
define stream log-epos.     /* Trama del ePOS */
DEFINE VAR mShowMsg AS LOG INIT NO.

DEFINE VAR cDATAQR AS CHAR INIT "".

DEFINE VAR x-tipo-docmnto-sunat AS CHAR INIT "".
DEFINE VAR x-tipoDocumentoAdquiriente AS CHAR INIT "".
DEFINE VAR x-numeroDocumentoAdquiriente AS CHAR INIT "".
/* Caso de N/C, N/D */
DEFINE VAR x-tipoDocumentoReferenciaPrincipal AS CHAR INIT "".
DEFINE VAR x-numeroDocumentoReferenciaPrincipal AS CHAR INIT "".

/**/
DEFINE VAR x-generar-solo-xml AS LOG INIT NO.
DEFINE VAR x-documento-contingencia AS LOG INIT NO.
DEFINE VAR x-enviar-servidor-prueba AS LOG INIT NO.

IF pOtros = "XML" THEN x-generar-solo-xml = YES.
IF pOtros = "CONTINGENCIA" THEN x-documento-contingencia = YES.
IF pOtros = "XMLCONTINGENCIA" THEN DO:
    x-documento-contingencia = YES.
    x-generar-solo-xml = YES.
END.        

IF pOtros = "XMLTEST" THEN DO:
    x-enviar-servidor-prueba = YES.
END.
/*
/* Impuesto a la bolsas plasticas */
DEFINE VAR x-articulo-ICBPER AS CHAR.
DEFINE VAR x-linea-bolsas-plastica AS CHAR.
DEFINE VAR x-precio-ICBPER AS DEC.

x-articulo-ICBPER = "099268".
x-linea-bolsas-plastica = "086".

/* ICBPER */
DEFINE VAR x-enviar-icbper AS LOG.
x-enviar-icbper = YES.   
*/

/*  */
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.
DEFINE BUFFER x-ccbddocu FOR ccbddocu.
DEFINE BUFFER x-factabla FOR factabla.
DEFINE BUFFER z-factabla FOR factabla.
/*
/* Para verificar los ANTICIPOS de CAMPAÑA (A/C) */
DEFINE BUFFER x-ccbdcaja FOR ccbdcaja.
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
*/
DEFINE VAR x-es-anticipo-de-campana AS LOG INIT NO.

/* Resolucion SUNAT,nuevas validaciones desde 01Ab2021 */
DEFINE VAR x-tipo-venta AS CHAR.
DEFINE VAR x-cuotas AS INT.
DEFINE VAR x-cuotas-factor AS DEC EXTENT 30.
DEFINE VAR x-cuotas-vcto AS DATE EXTENT 30.
 
/* ------------------------------------------------------------------------------- */
DEFINE VAR x-esta-probando AS LOG.
DEFINE VAR x-servidor-prueba AS LOG.
DEFINE VAR x-productivo AS LOG.

/* Servidor */
DEFINE VAR x-servidor AS CHAR.

x-servidor = "ninguno".
x-servidor = CAPS(SESSION:STARTUP-PARAMETERS).
IF INDEX(x-servidor,"-H") > 0 THEN DO:
    x-servidor = SUBSTRING(x-servidor,INDEX(x-servidor,"-H")).
    x-servidor = REPLACE(x-servidor,"-H","").
    IF INDEX(x-servidor,",") > 1 THEN DO:
        x-servidor = SUBSTRING(x-servidor,1,INDEX(x-servidor,",") - 1).
    END.
    x-servidor = TRIM(x-servidor).
END.

/**/
x-esta-probando = YES.
x-servidor-prueba = YES.

IF x-servidor = "192.168.100.210" THEN x-servidor-prueba = NO.

/**/
x-productivo = YES.

*/

/* *----------------*/
DEFINE VAR x-ser AS CHAR.
DEFINE VAR x-nro AS CHAR.

x-ser = "".
x-nro = "".

IF x-enviar-servidor-prueba = YES THEN DO:
    /*MESSAGE "TESTING".*/
    /*
    x-ser = "F222".
    x-nro = STRING(TIME,"HH:MM:SS").
    x-nro = REPLACE(x-nro,":","9").
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fgenera-tag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fgenera-tag Procedure 
FUNCTION fgenera-tag RETURNS CHARACTER
  ( INPUT pTag AS CHAR,INPUT pDato AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-como-pago) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-como-pago Procedure 
FUNCTION fget-como-pago RETURNS CHARACTER
    ( INPUT pTipoDoc AS CHAR, pNroDoc AS CHAR, pCodDiv AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-descripcion-articulo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-descripcion-articulo Procedure 
FUNCTION fget-descripcion-articulo RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pCodDoc AS CHAR, INPUT pCondCred AS CHAR, INPUT pTipoFac AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-doc-original) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-doc-original Procedure 
FUNCTION fget-doc-original RETURNS CHARACTER
  ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-email-cliente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-email-cliente Procedure 
FUNCTION fget-email-cliente RETURNS CHARACTER
  ( INPUT pCodCliente AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-personalizados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-personalizados Procedure 
FUNCTION fget-personalizados RETURNS CHARACTER
  ( INPUT pTipoVenta AS CHAR,INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pCoddiv AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-personalizados-pre-impreso) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-personalizados-pre-impreso Procedure 
FUNCTION fget-personalizados-pre-impreso RETURNS CHARACTER
  ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pCodDiv AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-personalizados-ticket) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-personalizados-ticket Procedure 
FUNCTION fget-personalizados-ticket RETURNS CHARACTER
    ( INPUT pTipoDoc AS CHAR, pNroDoc AS CHAR, pCodDiv AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-prefijo-serie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-prefijo-serie Procedure 
FUNCTION fget-prefijo-serie RETURNS CHARACTER
  (INPUT pTipoDoc AS CHAR, INPUT pSerieDoc AS INT,  INPUT pNroDoc AS INT, INPUT pDivision AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-producto-sunat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-producto-sunat Procedure 
FUNCTION fget-producto-sunat RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-tipo-documento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-tipo-documento Procedure 
FUNCTION fget-tipo-documento RETURNS CHARACTER
  ( INPUT pTipoDocumento AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-unidad-medida) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-unidad-medida Procedure 
FUNCTION fget-unidad-medida RETURNS CHARACTER
  ( INPUT pUM AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-utf-8) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-utf-8 Procedure 
FUNCTION fget-utf-8 RETURNS CHARACTER
  ( INPUT pString AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fGetTipoOperacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fGetTipoOperacion Procedure 
FUNCTION fGetTipoOperacion RETURNS CHARACTER
  (INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-flog-envio-xml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD flog-envio-xml Procedure 
FUNCTION flog-envio-xml RETURNS CHARACTER
  (INPUT pTexto AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-flog-epos-txt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD flog-epos-txt Procedure 
FUNCTION flog-epos-txt RETURNS CHARACTER
  (INPUT pTexto AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fset-placa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fset-placa Procedure 
FUNCTION fset-placa RETURNS CHARACTER
  ( INPUT pDato AS CHAR)  FORWARD.

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
         HEIGHT             = 20.19
         WIDTH              = 68.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Verificar si existe */
FIND FIRST b-gre_header WHERE b-gre_header.m_divorigen = pCodDiv AND
                            b-gre_header.serieguia = pSerieGRE AND
                            b-gre_header.numeroguia = pNroGRE NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-gre_header THEN DO:
    pReturn = "999|Guia de remision electronica " + STRING(pSerieGRE,"999") + "-" + STRING(pNroGRE,"99999999") + " NO EXISTE".
    RETURN "ADM-ERROR".
END.
IF pOtros = "" AND NOT b-gre_header.m_rspta_sunat = 'CON TRANSPORTISTA' THEN DO:
    pReturn = "999|Guia de remision electronica " + STRING(pSerieGRE,"999") + "-" + STRING(pNroGRE,"99999999") + " aun no tiene asignado movilidad o ya fue enviado a Sunat".
    RETURN "ADM-ERROR".
END.
                                                                  
/* Detalle */
FIND FIRST b-gre_detail WHERE b-gre_detail.ncorrelativo = b-gre_header.ncorrelatio NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-gre_detail THEN DO:
    pReturn = "999|Guia de remision electronica " + STRING(pSerieGRE,"999") + "-" + STRING(pNroGRE,"99999999") + " aun NO tiene detalle de articulos".
    RETURN "ADM-ERROR".
END.

/* Prefijo de la serie del documento electronico */
cSerieSunat = fGet-prefijo-serie("GRE", b-gre_header.serieguia, b-gre_header.numeroguia, b-gre_header.m_divorigen).

IF (TRUE <> (cSerieSunat > "")) OR LOOKUP(cSerieSunat,"T") = 0 THEN DO:
    pReturn = "999|Guia de remision electronica " + STRING(pSerieGRE,"999") + "-" + STRING(pNroGRE,"99999999") + " imposible ubicar el prefijo".
    RETURN "ADM-ERROR".
END.

IF x-documento-contingencia = YES THEN cSerieSunat = "0".

cSerieSunat = cSerieSunat  +  STRING(b-gre_header.serieGuia,"999").
cCorrelativoSunat   = STRING(b-gre_header.numeroGuia,"99999999").

x-servidor-ip = "".
x-servidor-puerto = "".

/* Servidor Webservice BIZLINKS */
DEFINE VAR x-config-servidor AS CHAR.

x-config-servidor = "CONFIG-FE-BIZLINKS".
IF x-enviar-servidor-prueba THEN x-config-servidor = "CONFIG-FE-BIZTEST".

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                            factabla.tabla = x-config-servidor  /*"CONFIG-FE-BIZLINKS"*/ AND
                            factabla.codigo = pcoddiv NO-LOCK NO-ERROR.

IF AVAILABLE factabla THEN DO:
    /* De la division */
    x-servidor-ip = TRIM(factabla.campo-c[1]).
    x-servidor-puerto = TRIM(factabla.campo-c[2]).
END.
FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                            factabla.tabla = x-config-servidor  /*"CONFIG-FE-BIZLINKS"*/ AND
                            factabla.codigo = "TODOS" NO-LOCK NO-ERROR.
IF NOT AVAILABLE factabla THEN DO:
    pReturn = "999|El Servidor del WebService no esta configurado(" + x-config-servidor + ")".
    RETURN "ADM-ERROR".
END.

IF TRUE <> (x-servidor-ip > "") THEN DO:
    /*  */
    x-servidor-ip = TRIM(factabla.campo-c[1]).
    x-servidor-puerto = TRIM(factabla.campo-c[2]).
END.
IF (TRUE <> (x-servidor-ip > "")) OR (TRUE <> (x-servidor-puerto > "")) THEN DO:
    pReturn = "999|La IP y/o Puerto Servidor del WebService esta vacio".
    RETURN "ADM-ERROR".
END.
IF TRUE <> (x-servidor-ip > "") THEN DO:
    pReturn = "999|La IP del Servidor del WebService no esta vacio".
    RETURN "ADM-ERROR".
END.
IF TRUE <> (x-servidor-puerto > "") THEN DO:
    pReturn = "999|El PUERTO del Servidor del WebService no esta vacio".
    RETURN "ADM-ERROR".
END.
/* ----------------------------------------- */

/* Tipo documento SUNAT */
cTipoDoctoSunat     = '09'.     /* Guia de remision electronica de SUNAT */

x-tipo-docmnto-sunat = cTipoDoctoSunat.

/* Construyo el XML */
x-XML-documento = "".
x-XML-detalle = "".
x-XML-cabecera = "".
x-XML-adicionales = "".
x-XML-doc-relacionados = "".

/* ---------------------------------------------------------------------------- */
/*      PLAN B - para GRE aun no implementada*/
/* ---------------------------------------------------------------------------- */

IF CAPS(USERID("DICTDB")) = "ADMIN" OR CAPS(USERID("DICTDB")) = "MASTER" THEN DO:
    /**/
END.
ELSE DO:
    /*
    FIND FIRST z-factabla WHERE z-factabla.codcia = s-codcia AND
                                z-factabla.tabla = "CONTINGENCIA" AND
                                z-factabla.codigo = "PLAN-B" NO-LOCK NO-ERROR.
    IF AVAILABLE z-factabla AND z-factabla.campo-c[1] = "SI" THEN DO:    
        pReturn = "PLAN-B".
        RETURN.        
    END. 
    */
END.

/* XML Detalle GRE */
RUN generar-xml-detail(OUTPUT x-xml-detalle).

IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    pReturn = "999|ERROR al generar el XML del detalle".
    RETURN "ADM-ERROR".
END.
/* *************************************************** */

/* XML cabecera */
RUN generar-xml-header(OUTPUT x-XML-cabecera).

IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    pReturn = "999|ERROR al generar el XML de la cabecera:" + x-XML-cabecera.
    x-XML-cabecera = "".
    RETURN "ADM-ERROR".
END.

/* XML documentos relacionador */
RUN generar-xml-doc-relacionado(OUTPUT x-XML-doc-relacionados).

IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    pReturn = "999|ERROR al generar el XML documentos relacionados".
    RETURN "ADM-ERROR".
END.

/* Envio a SUNAT */
DEFINE VAR x-retval AS CHAR INIT "".
DEFINE VAR x-data-QR AS CHAR.
DEFINE VAR x-emision AS CHAR.
DEFINE VAR x-DLL-PLAN AS CHAR INIT "NO".

/* Siempre en NO, solo para sistemas en modo desarrollo se puede usar en SI */
x-DLL-PLAN = "NO".      

/**************************************************************/

IF x-DLL-PLAN = "SI" THEN DO:
    /*
    DEFINE VARIABLE oObjDLL    AS COM-HANDLE.
    DEFINE VAR lValor           AS CHAR.
    DEFINE VAR lSerieNumero     AS CHAR.
    
    CREATE "bizlinks-componente.bizlinks" oObjDLL.
    
    oObjDLL:_UsuarioSQL = "postgres".
    oObjDLL:_Pass = "Sistemas25".
    
    lSerieNumero = cSerieSunat + "-" + cCorrelativoSunat.
    lValor = oObjDLL:_get_comprobante('6','20100038146',cTipoDoctoSunat,lSerieNumero).
    
    RELEASE OBJECT oObjDLL NO-ERROR.
    
    IF lValor BEGINS "DATA"  THEN DO:
    
        /*
            ENTRY(3,lValor,"|") = SIGNED/AC_03 documento ya esta firmado
        */
        IF ENTRY(3,lValor,"|") BEGINS "SIGNED" THEN DO:
            x-xml-hashcode = ENTRY(4,lValor,"|").
            x-retval = "OK".
        END.
        ELSE DO:
            x-retval = ENTRY(2,lValor,"|"). 
        END.
    END.
    ELSE DO:
        IF CAPS(lValor) = CAPS("WARNING|DOCUMENTO NO EXISTE") THEN DO:
            x-DLL-PLAN = "NO".
        END.
        ELSE DO:
            x-retval = ENTRY(2,lValor,"|").
        END.
    END.
    */
END.

x-retval = "OK".
pEstadoBizlinks = "".

IF x-DLL-PLAN = "NO" THEN DO:
    /* Envia el XML a BizLinks */
    RUN enviar-xml(OUTPUT x-retval).
END.
IF x-retval = "OK" THEN DO:
    pReturn = "OK|Genero el XML : " + x-retval.
END.
ELSE DO:
    IF x-generar-solo-xml = YES THEN DO:
        pReturn = "OK|Genero el XML : " + x-retval.
    END.
    ELSE DO:
        pReturn = "999|Imposible enviar el XML (v1) : " + x-retval.
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
DEFINE OUTPUT PARAMETER p-msg AS CHAR NO-UNDO.

/* Envio a BizLinks */
DEFIN VAR x-url-webservice AS CHAR.
DEFINE VAR x-loadXML AS LOG.  

DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.
DEFINE VAR x-oXMLBody AS com-HANDLE NO-UNDO.

DEFINE VAR cMsgErr1 AS CHAR.
DEFINE VAR cMsgErr2 AS CHAR.

p-msg = "OK".
pEstadoBizlinks = "".

/* --------------------------- Uno los XMLs ------------------------------ */
x-XML-documento = "<Guia>".
x-XML-documento = x-XML-documento + x-XML-cabecera + x-XML-doc-relacionados + x-XML-adicionales + x-XML-detalle.
x-XML-documento = x-XML-documento + "</Guia>".   
/* ---------------------------------------------------------------------- */

/*
&apos; = '
&quot; = " 
*/

x-XML-documento = REPLACE(x-XML-documento,"&","&amp;").
x-XML-documento = REPLACE(x-XML-documento,"'","&apos;").
x-XML-documento = REPLACE(x-XML-documento,'"',"&quot;").

DEFINE VAR x-tmp AS CHAR.
DEFINE VAR x-nombre-del-xml AS CHAR.
DEFINE VAR x-log-envio AS CHAR.

x-tmp = session:temp-directory.

IF x-ser = "" THEN DO:
    x-nombre-del-xml = x-tmp + cSerieSunat + "-" + cCorrelativoSunat + "-" + cTipoDoctoSunat + ".xml".
END.
ELSE DO:
    x-nombre-del-xml = x-tmp + x-ser + "-" + x-nro + "-" + cTipoDoctoSunat + ".xml".   
END.

COPY-LOB x-XML-documento TO FILE x-nombre-del-xml NO-ERROR.
IF pOtros = "XML" THEN DO:
    MESSAGE "Se genero el XML" SKIP
    x-nombre-del-xml.
        RETURN "ADM-ERROR".
END.

/* ????????????????????????????????????????????? */
/* cRucEmpresa = '20511358907'.    R.U.C. - StandFord */
x-log-envio = flog-envio-xml("/* -----------------------------------------------vvv----------------------------------- */").
x-log-envio = flog-envio-xml("     0.- GUIA DE REMISION : " + cTipoDoctoSunat + " " + cSerieSunat + "-" + cCorrelativoSunat).
x-log-envio = flog-envio-xml("/* ---------------------------------------------------------------------------------- */").

IF x-ser = "" THEN DO:
    x-url-webservice = "http://" + x-servidor-ip + ":" + x-servidor-puerto + "/einvoice/rest/" +
                    "6/" + cRucEmpresa + "/" + cTipoDoctoSunat + "/" + cSerieSunat + "-" + cCorrelativoSunat.
END.
ELSE DO:
    x-url-webservice = "http://" + x-servidor-ip + ":" + x-servidor-puerto + "/einvoice/rest/" +
                    "6/" + cRucEmpresa + "/" + cTipoDoctoSunat + "/" + x-ser + "-" + x-nro.
END.
x-log-envio = flog-envio-xml("URL :" + x-url-webservice).

IF x-generar-solo-xml = YES THEN DO:
    p-msg = x-nombre-del-xml.
    RELEASE OBJECT x-oXmlHttp NO-ERROR. 
    RELEASE OBJECT x-oXMLBody NO-ERROR.
    RETURN "OK".
END.

/* ------------------------------------- */

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.
CREATE "MSXML2.DOMDocument.6.0" x-oXMLBody.

x-loadXML = x-oXMLBody:loadXML(x-XML-documento) NO-ERROR. 

IF NOT x-loadXML THEN DO:    

    p-msg = "ERROR en loadXML : "  + gcCRLF + x-oXMLBody:parseError:reason.    

    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RELEASE OBJECT x-oXMLBody NO-ERROR.

    x-log-envio = flog-envio-xml("1.- " + p-msg).

    pEstadoBizlinks = "SIN CONEXION".

    IF lookup(USERID("DICTDB"),"ADMIN, MASTER") > 0 THEN DO:
        /*MESSAGE "1. " + x-oXMLBody:parseError:reason.*/
    END.

    RETURN "ADM-ERROR".
END.

x-oXmlHttp:OPEN( "PUT", x-url-webservice, NO ). 
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=utf-8" ).
/*x-oXmlHttp:setRequestHeader( "Content-Length", LENGTH(x-xml-documento)).    */
x-oXmlHttp:setOption( 2, 13056 ) .  /*SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056*/             
x-oXmlHttp:SEND(x-oXMLBody:documentElement:XML) NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:    
    
    /* p-msg = "ERROR en SEND : El XML tiene problemas de Estructura ó el Servicio de Bizlinks esta caido" + gcCRLF + " (" + */
    p-msg = "ERROR en el evento SEND : Al momento de enviar la trama genero un ERROR, acontinuacion el numero de error y mensaje" + gcCRLF + " (" + 
        "No. ERROR : " + STRING(ERROR-STATUS:GET-NUMBER(1)) + ")" + gcCRLF +  
        "MENSAJE   : " + ERROR-STATUS:GET-MESSAGE(1).

    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RELEASE OBJECT x-oXMLBody NO-ERROR.

    x-log-envio = flog-envio-xml("2.- " + p-msg).
    pEstadoBizlinks = "SIN RESPUESTA".

    IF lookup(USERID("DICTDB"),"ADMIN, MASTER") > 0 THEN DO:
        /*MESSAGE "2. (*) " + ERROR-STATUS:GET-MESSAGE(1).*/
    END.

    RETURN "ADM-ERROR".
END.

IF x-oXmlHttp:STATUS <> 200 THEN DO:

    IF LENGTH(TRIM(x-oXmlHttp:responseText)) > 250 THEN DO:
        cMsgerr1 = SUBSTRING(TRIM(x-oXmlHttp:responseText),1,250).
        cMsgerr2 = SUBSTRING(TRIM(x-oXmlHttp:responseText),251).
    END.
    ELSE DO:
        cMsgerr1 = x-oXmlHttp:responseText.
    END.

    p-msg = "ERROR en SEND : " + x-oXmlHttp:responseText. 

    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RELEASE OBJECT x-oXMLBody NO-ERROR.


    x-log-envio = flog-envio-xml("3.- " + cMsgErr1).
    IF cMsgErr2 > "" THEN DO:
        x-log-envio = flog-envio-xml("3.1.- " + cMsgErr2).
    END.
    pEstadoBizlinks = "ERROR DE ENVIO".

    IF lookup(USERID("DICTDB"),"ADMIN, MASTER") > 0 THEN DO:
        /*MESSAGE "3.- " + x-oXmlHttp:responseText. */
    END.

    RETURN "ADM-ERROR".
END.

IF lookup(USERID("DICTDB"),"ADMIN, MASTER") > 0 THEN DO:
    MESSAGE x-oXmlHttp:responseText.
END.

/* La Respuesta */
DEFINE VAR x-rspta AS CHAR.
DEFINE VAR x-orspta AS COM-HANDLE NO-UNDO.
DEFINE var x-oMsg AS COM-HANDLE NO-UNDO.

DEFINE VAR x-status AS CHAR.
DEFINE VAR x-codestatus AS CHAR.
DEFINE VAR x-hashcode AS CHAR.
DEFINE VAR cFiler AS CHAR.

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
x-log-envio = flog-envio-xml("4.- X-RSPTA :" + x-rspta).

IF NOT (TRUE <> (x-status > "")) THEN DO:

    IF x-status = ? THEN x-status = "ERROR".

    pEstadoBizlinks = x-status.

    x-log-envio = flog-envio-xml("5.- X-STATUS :" + x-status).

    IF CAPS(x-status) = "DUPLICATED" OR CAPS(x-status) = "SIGNED" OR  CAPS(x-status) = "IN PROCESS" THEN DO:
        /* PROCESO OK */
        IF CAPS(x-status) = "SIGNED" OR CAPS(x-status) = "IN PROCESS" THEN DO:
            x-xml-hashcode = x-hashcode.
            p-msg = "OK".
        END.
        ELSE DO:
            p-msg = "El documento esta " + x-status.            
            p-msg = "RECHAZADO POR SUNAT".
        END.
        x-log-envio = flog-envio-xml("6.- " + p-msg).
    END.
    ELSE DO:
        x-oMsg = x-oRspta:selectSingleNode( "//message" ). 
        /* x-codestatus = x-oMsg:TEXT NO-ERROR. */
        cFiler = x-oMsg:TEXT NO-ERROR.       

        x-log-envio = flog-envio-xml("7.- X-MSG-ERROR :" + x-codestatus + " " + cFiler).
        p-msg = cFiler.
        /*
        IF x-codestatus = ? THEN DO:
            /**/
        END.
        ELSE DO:
            p-msg = TRIM(x-codestatus) + "|" + cFiler.
        END.
        */
    END.
END.
ELSE DO:
    IF NOT (TRUE <> (x-codestatus > "") ) THEN DO:

        pEstadoBizlinks = x-codestatus.
        
        x-oMsg = x-oRspta:selectSingleNode( "//descriptionDetail" ).
        p-msg = x-oMsg:TEXT NO-ERROR.

        x-log-envio = flog-envio-xml("8.- MENSAJE-DETALLE :" + x-codestatus + " " + p-msg).
        /*
        IF x-codestatus = ? THEN DO:
            pEstadoBizlinks = "ERROR".
            /**/
        END.
        ELSE DO:
            pEstadoBizlinks = x-codestatus.
            p-msg = TRIM(x-codestatus).
        END.
        */
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

&IF DEFINED(EXCLUDE-generar-xml-detail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-xml-detail Procedure 
PROCEDURE generar-xml-detail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pXML-DETAIL AS LONGCHAR.

pXML-DETAIL = "".

FOR EACH b-gre_detail WHERE b-gre_detail.ncorrelativo = b-gre_header.ncorrelatio NO-LOCK:
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = b-gre_detail.codmat NO-LOCK NO-ERROR.
    /*IF pXML-DETAIL = "" THEN pXML-DETAIL = "<GuiaItem>".*/
    pXML-DETAIL = pXML-DETAIL + "<GuiaItem>".
    pXML-DETAIL = pXML-DETAIL + fgenera-tag("indicador","D").
    pXML-DETAIL = pXML-DETAIL + fgenera-tag("numeroOrdenItem",string(b-gre_detail.nroItm)).
    pXML-DETAIL = pXML-DETAIL + fgenera-tag("cantidad",string(b-gre_detail.candes,">>>>>>>9.99")).
    pXML-DETAIL = pXML-DETAIL + fgenera-tag("unidadMedida",fget-unidad-medida(b-gre_detail.codund)).
    IF AVAILABLE almmmatg THEN DO:
        pXML-DETAIL = pXML-DETAIL + fgenera-tag("descripcion",almmmatg.desmat).
    END.
    ELSE DO:    
        pXML-DETAIL = pXML-DETAIL + fgenera-tag("descripcion","-").
    END.
    pXML-DETAIL = pXML-DETAIL + fgenera-tag("codigo",string(b-gre_detail.codmat)).
    pXML-DETAIL = pXML-DETAIL + "</GuiaItem>".
END.

/*IF pXML-DETAIL > "" THEN pXML-DETAIL = pXML-DETAIL + "</GuiaItem>".*/

/*
DEFINE VAR x-item AS INT INIT 0.    
DEFINE VAR x-codigo-razon-exoneracion AS CHAR.
DEFINE VAR x-codigo-importe-referencial AS CHAR.
DEFINE VAR x-codigo-importe-unitario-con-igv AS CHAR.
DEFINE VAR x-existe-icbper AS LOG.
DEFINE VAR x-codfam-icbper AS CHAR.

DEFINE VAR x-XMLicbper AS CHAR.

pXML-DETAIL = "".

x-existe-icbper = NO.
x-codfam-icbper = "".

FOR EACH b-ccbddocu OF b-ccbcdocu NO-LOCK BY b-ccbddocu.nroitm :
    FIND FIRST almmmatg OF b-ccbddocu NO-LOCK NO-ERROR.
    /*
    /* Ic - 09Mar2020 - no enviar el IMPSTO */
    IF x-enviar-icbper = YES THEN DO:
        IF b-ccbddocu.codmat = x-articulo-ICBPER THEN DO:
            x-codfam-icbper = almmmatg.codfam.
            x-existe-icbper = YES.
            NEXT.
        END.        
    END. 
    */
    x-item = x-item + 1. 
    pXML-DETAIL = pXML-DETAIL + "<item>".
    pXML-DETAIL = pXML-DETAIL + "<numeroOrdenItem>" + STRING(x-item) + "</numeroOrdenItem>".
    pXML-DETAIL = pXML-DETAIL + "<unidadMedida>" + fget-unidad-medida(b-ccbddocu.undvta) + "</unidadMedida>".
    pXML-DETAIL = pXML-DETAIL + "<cantidad>" + TRIM(STRING(b-ccbddocu.candes,">>>>>>>9.99")) + "</cantidad>".
    pXML-DETAIL = pXML-DETAIL + "<codigoProducto>" + TRIM(b-ccbddocu.codmat) + "</codigoProducto>".
    pXML-DETAIL = pXML-DETAIL + "<descripcion>" + fget-descripcion-articulo(b-ccbddocu.codmat, b-ccbcdocu.coddoc, b-ccbcdocu.cndcre, b-ccbcdocu.tpofac) + "</descripcion>".
    IF b-ccbcdocu.tpofac = 'S' THEN DO:
       /* Factura SERVICIOS no va MARCA */
        pXML-DETAIL = pXML-DETAIL + "<codigoAuxiliar40_1>9037</codigoAuxiliar40_1>".
        pXML-DETAIL = pXML-DETAIL + "<textoAuxiliar40_1>-</textoAuxiliar40_1>".
    END.
    ELSE DO:
        pXML-DETAIL = pXML-DETAIL + "<codigoAuxiliar40_1>9037</codigoAuxiliar40_1>".
        IF AVAILABLE almmmatg THEN DO:
            pXML-DETAIL = pXML-DETAIL + "<textoAuxiliar40_1>" + fget-utf-8(almmmatg.desmar) + "</textoAuxiliar40_1>".
        END.        
        ELSE DO:
            pXML-DETAIL = pXML-DETAIL + "<textoAuxiliar40_1>-</textoAuxiliar40_1>".
        END.
    END.
    /* Unidad de medida de Conti */
    pXML-DETAIL = pXML-DETAIL + "<codigoAuxiliar40_3>8090</codigoAuxiliar40_3>".
    pXML-DETAIL = pXML-DETAIL + "<textoAuxiliar40_3>" + TRIM(b-ccbddocu.undvta) + "</textoAuxiliar40_3>".

    x-codigo-razon-exoneracion = "".
    x-codigo-importe-referencial = "".
    x-codigo-importe-unitario-con-igv = "".

    IF b-ccbddocu.cTipoAfectacion = "GRAVADA" THEN DO:
        x-codigo-importe-unitario-con-igv = "01".                               
        x-codigo-razon-exoneracion = '10'.                  
    END.

    IF b-ccbddocu.cTipoAfectacion = "GRATUITA" THEN DO:
        x-codigo-importe-unitario-con-igv = "01".                               
        x-codigo-razon-exoneracion = '15'.                  
        x-codigo-importe-referencial = "02".                
    END.
    IF b-ccbddocu.cTipoAfectacion = "EXONERADA" THEN DO:
        x-codigo-importe-unitario-con-igv = "01".                               
        x-codigo-razon-exoneracion = '20'.                  
        /*x-codigo-importe-referencial = "02".                */
    END.
    IF b-ccbddocu.cTipoAfectacion = "INAFECTA" THEN DO:
        /* Conti no tiene articulos inafectos */
        x-codigo-importe-unitario-con-igv = "01".                               
        x-codigo-razon-exoneracion = '30'.
        x-codigo-importe-referencial = "02". 
    END.

    pXML-DETAIL = pXML-DETAIL + "<importeUnitarioSinImpuesto>" + TRIM(STRING(b-ccbddocu.importeUnitarioSinImpuesto,">>>>>>9.9999")) + "</importeUnitarioSinImpuesto>".
    pXML-DETAIL = pXML-DETAIL + "<importeUnitarioConImpuesto>" + TRIM(STRING(b-ccbddocu.importeUnitarioConImpuesto,">>>>>>9.9999")) + "</importeUnitarioConImpuesto>".
    pXML-DETAIL = pXML-DETAIL + "<codigoImporteUnitarioConImpuesto>" + x-codigo-importe-unitario-con-igv + "</codigoImporteUnitarioConImpuesto>".   /*???????????????????????????????*/
    /* Correo Luis Urbano - validacion SUNAT desde Julio2020 */
    pXML-DETAIL = pXML-DETAIL + "<montoBaseIgv>" + TRIM(STRING(b-ccbddocu.montoBaseIgv,">>>>>>9.99")) + "</montoBaseIgv>".
    pXML-DETAIL = pXML-DETAIL + "<tasaIgv>" + TRIM(STRING(b-ccbddocu.tasaIgv * 100,">>>>>9.99")) + "</tasaIgv>".
    /*
      Segun recomendacion de BizLinks del dia 31Jul2020
        Les informamos que el importeIgv a nivel de item debe ser mayor a 0.00 cuando el item es gravado. 
        Lo que pueden hacer es colocar '0.01' (valor mínimo aceptable) en el campo importeIgv 
        (los demás campos deben permanecer igual) para que el comprobante se envíe sin problemas.            
    */   
    pXML-DETAIL = pXML-DETAIL + "<importeIgv>" + TRIM(STRING(b-ccbddocu.importeIgv,">>>>>>9.99")) + "</importeIgv>".
    /**/
    pXML-DETAIL = pXML-DETAIL + "<codigoRazonExoneracion>" + x-codigo-razon-exoneracion + "</codigoRazonExoneracion>".
    IF x-codigo-importe-referencial <> "" THEN 
        pXML-DETAIL = pXML-DETAIL + "<codigoImporteReferencial>" + x-codigo-importe-referencial + "</codigoImporteReferencial>".    
    IF b-ccbddocu.importeReferencial > 0 THEN DO:
        pXML-DETAIL = pXML-DETAIL + "<importeReferencial>" + TRIM(STRING(b-ccbddocu.importeReferencial,">>>>>>>9.9999")) + "</importeReferencial>".
        /*pXML-DETAIL = pXML-DETAIL + "<importeTotalSinImpuesto>" + TRIM(STRING(x-monto-base-igv,">>>>>>>9.99")) + "</importeTotalSinImpuesto>".*/
        pXML-DETAIL = pXML-DETAIL + "<importeTotalSinImpuesto>" + TRIM(STRING(b-ccbddocu.importeTotalSinImpuesto,">>>>>>9.99")) + "</importeTotalSinImpuesto>".
    END.
    ELSE DO:
        pXML-DETAIL = pXML-DETAIL + "<importeTotalSinImpuesto>" + TRIM(STRING(b-ccbddocu.importeTotalSinImpuesto,">>>>>>9.99")) + "</importeTotalSinImpuesto>".
    END.                
    IF b-ccbddocu.importeDescuento > 0 THEN
        pXML-DETAIL = pXML-DETAIL + "<importeDescuento>" + TRIM(STRING(b-ccbddocu.importeDescuento,">>>>>>>9.99")) + "</importeDescuento>".
    IF b-ccbddocu.importeBaseDescuento > 0 THEN
        pXML-DETAIL = pXML-DETAIL + "<importeBaseDescuento>" + TRIM(STRING(b-ccbddocu.importeBaseDescuento,">>>>>>>9.99")) + "</importeBaseDescuento>".
    IF b-ccbddocu.factorDescuento > 0 THEN DO:
        pXML-DETAIL = pXML-DETAIL + "<factorDescuento>" + TRIM(STRING(b-ccbddocu.factorDescuento,">>9.99999")) + "</factorDescuento>".
        /**/
        pXML-DETAIL = pXML-DETAIL + "<codigoAuxiliar40_2>8998</codigoAuxiliar40_2>".
        pXML-DETAIL = pXML-DETAIL + "<textoAuxiliar40_2>" + TRIM(STRING(b-ccbddocu.factorDescuento * 100,">>9.99999")) + "</textoAuxiliar40_2>".
    END.

    /* Ic - 09Mar2020, Impuesto Bolsa Plastica */   
    x-XMLicbper = "".
    IF b-ccbddocu.montoTributoBolsaPlastico > 0 THEN DO:
        x-XMLicbper = x-XMLicbper + "<impuestoBolsaPlastico>" + TRIM(STRING(b-ccbddocu.impuestoBolsaPlastico,">>>>>>>9.99")) + "</impuestoBolsaPlastico>".
        x-XMLicbper = x-XMLicbper + "<montoTributoBolsaPlastico>" + TRIM(STRING(b-ccbddocu.montoTributoBolsaPlastico,">>>>>>>9.99")) + "</montoTributoBolsaPlastico>".
        x-XMLicbper = x-XMLicbper + "<cantidadBolsaPlastico>" + TRIM(STRING(INTEGER(b-ccbddocu.cantidadBolsaPlastico),">>>>>>>9")) + "</cantidadBolsaPlastico>".
        x-XMLicbper = x-XMLicbper + "<montoUnitarioBolsaPlastico>" + TRIM(STRING(b-ccbddocu.montoUnitarioBolsaPlastico,">>>>>>>9.9999")) + "</montoUnitarioBolsaPlastico>".

        pXML-DETAIL = pXML-DETAIL + x-XMLicbper.
    END.    

    pXML-DETAIL = pXML-DETAIL + "<importeTotalImpuestos>" + TRIM(STRING(b-ccbddocu.importeTotalImpuestos,">>>>>>9.99")) + "</importeTotalImpuestos>".
    pXML-DETAIL = pXML-DETAIL + "</item>".
END.
*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generar-xml-doc-relacionado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-xml-doc-relacionado Procedure 
PROCEDURE generar-xml-doc-relacionado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pXML-DETAIL AS LONGCHAR.

pXML-DETAIL = "".

/*

    Reunion 19May2023, Juan Hermoza, Luis Urbano, Harold Segura (envio correo del acta), Max Ramos
            decidieron que no vaya el documento relacionado a sunat

FOR EACH b-gre_doc_relacionado WHERE b-gre_doc_relacionado.ncorrelativo = b-gre_header.ncorrelatio NO-LOCK:
    IF pXML-DETAIL = "" THEN pXML-DETAIL = "<documentoRelacionado>".
    pXML-DETAIL = pXML-DETAIL  + fgenera-tag("indicador",b-gre_doc_relacionado.indicador).
    pXML-DETAIL = pXML-DETAIL  + fgenera-tag("ordenDocRel",STRING(b-gre_doc_relacionado.ordenDocRel)).
    pXML-DETAIL = pXML-DETAIL  + fgenera-tag("tipoDocumentoDocRel",b-gre_doc_relacionado.tipoDocumentoDocRel).
    pXML-DETAIL = pXML-DETAIL  + fgenera-tag("codigoDocumentoDocRel",b-gre_doc_relacionado.codigoDocumentoDocRel).
    pXML-DETAIL = pXML-DETAIL  + fgenera-tag("numeroDocumentoDocRel",b-gre_doc_relacionado.numeroDocumentoDocRel).
    pXML-DETAIL = pXML-DETAIL  + fgenera-tag("numeroDocumentoEmisorDocRel",b-gre_doc_relacionado.numeroDocumentoEmisorDocRel).
    pXML-DETAIL = pXML-DETAIL  + fgenera-tag("tipoDocumentoEmisorDocRel",b-gre_doc_relacionado.tipoDocumentoEmisorDocRel).
END.

IF NOT (pXML-DETAIL = "") THEN pXML-DETAIL = pXML-DETAIL + "</documentoRelacionado>".
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generar-xml-header) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-xml-header Procedure 
PROCEDURE generar-xml-header :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-xml-header AS LONGCHAR.

DEFINE VAR cMsgErr AS CHAR.

p-xml-header = "".
CASE b-gre_header.motivoTraslado:
    WHEN "01" THEN RUN gre-venta(OUTPUT p-xml-header).
    WHEN "02" THEN RUN gre-compra(OUTPUT p-xml-header).
    WHEN "03" THEN RUN gre-venta(OUTPUT p-xml-header).
    WHEN "04" THEN RUN gre-traslado-establecimientos(OUTPUT p-xml-header).
    WHEN "05" THEN RUN gre-consignacion(OUTPUT p-xml-header).
    WHEN "06" THEN DO:
        IF b-gre_header.m_codmov = 91 THEN DO:
            RUN gre-devolucion-proveedor(OUTPUT p-xml-header).     /* devoluciones a Proveedores */
        END.
        ELSE DO:
            cMsgErr = "Motivo de traslado(" + b-gre_header.motivoTraslado + ") con codigo de movimiento (" + STRING(b-gre_header.m_codmov) + ") no esta implementado".
        END.
    END.        
    WHEN "07" THEN RUN gre-recojo-bien-transformado(OUTPUT p-xml-header).
    WHEN "08" THEN RUN gre-importacion(OUTPUT p-xml-header).
    WHEN "09" THEN RUN gre-exportacion(OUTPUT p-xml-header).
    WHEN "13" THEN DO:
        IF b-gre_header.m_codmov = 29 THEN DO:
            RUN gre-devolucion-cliente(OUTPUT p-xml-header).     /* devolucion de clientes */
        END.
        ELSE DO:
            RUN gre-otros(OUTPUT p-xml-header).     /* otros */
        END.
    END.        
    WHEN "14" THEN RUN gre-venta(OUTPUT p-xml-header).
    WHEN "17" THEN RUN gre-traslado-para-transformacion(OUTPUT p-xml-header).
    WHEN "18" THEN RUN gre-itinirante(OUTPUT p-xml-header).
    OTHERWISE DO:        
        cMsgErr = "Motivo de traslado(" + b-gre_header.motivoTraslado + ") No implementado".
    END.
END.

IF p-xml-header = "" THEN DO:
    p-xml-header = cMsgErr.
    RETURN "ADM-ERROR".
END.
    

DEFINE VAR xmlTodos AS LONGCHAR.
DEFINE VAR x-aaaa-mm-dd AS CHAR.

x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaEmisionGuia,"99-99-9999"),7,4) + "-".
x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEmisionGuia,"99-99-9999"),4,2) + "-" .
x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEmisionGuia,"99-99-9999"),1,2).

xmlTodos = fgenera-tag("correoEmisor",b-gre_header.correoRemitente).
xmlTodos = xmlTodos + fgenera-tag("correoAdquiriente",b-gre_header.correoDestinatario).
xmlTodos = xmlTodos + fgenera-tag("serieNumeroGuia",cSerieSunat + "-" + cCorrelativoSunat).
xmlTodos = xmlTodos + fgenera-tag("fechaEmisionGuia",x-aaaa-mm-dd).
xmlTodos = xmlTodos + fgenera-tag("horaEmisionGuia","00:01:01").
/*xmlTodos = xmlTodos + fgenera-tag("horaEmisionGuia",b-gre_header.horaEmisionGuia).*/
xmlTodos = xmlTodos + fgenera-tag("tipoDocumentoGuia",b-gre_header.tipoDocumentoGuia).
xmlTodos = xmlTodos + fgenera-tag("numeroDocumentoRemitente",b-gre_header.numeroDocumentoRemitente).
xmlTodos = xmlTodos + fgenera-tag("tipoDocumentoRemitente",b-gre_header.tipoDocumentoRemitente).
xmlTodos = xmlTodos + fgenera-tag("razonSocialRemitente",SUBSTRING(b-gre_header.razonSocialRemitente,1,100)).       /* A pedido de Bizlinks */
xmlTodos = xmlTodos + fgenera-tag("numeroDocumentoDestinatario",b-gre_header.numeroDocumentoDestinatario).
xmlTodos = xmlTodos + fgenera-tag("tipoDocumentoDestinatario",b-gre_header.tipoDocumentoDestinatario).
xmlTodos = xmlTodos + fgenera-tag("razonSocialDestinatario",SUBSTRING(b-gre_header.razonSocialDestinatario,1,100)).
xmlTodos = xmlTodos + fgenera-tag("numeroDocumentoEstablecimiento",b-gre_header.numeroDocumentoEstablecimiento).
xmlTodos = xmlTodos + fgenera-tag("tipoDocumentoEstablecimiento",b-gre_header.tipoDocumentoEstablecimiento).
xmlTodos = xmlTodos + fgenera-tag("razonSocialEstablecimiento",b-gre_header.razonSocialEstablecimiento).

xmlTodos = xmlTodos + fgenera-tag("motivoTraslado",b-gre_header.motivoTraslado).
IF b-gre_header.motivoTraslado = "13" THEN DO:
    xmlTodos = xmlTodos + fgenera-tag("descripcionMotivoTraslado",b-gre_header.descripcionMotivoTraslado).
END.
/*xmlTodos = xmlTodos + fgenera-tag("indTransbordoProgramado",string(b-gre_header.indTransbordoProgramado)).*/
xmlTodos = xmlTodos + fgenera-tag("pesoBrutoTotalBienes",string(b-gre_header.pesoBrutoTotalBienes,">>>>>>>>9.99")).
xmlTodos = xmlTodos + fgenera-tag("unidadMedidaPesoBruto",b-gre_header.unidadMedidaPesoBruto).

IF b-gre_header.indTrasVehiculoCatM1L = YES  THEN DO:
    xmlTodos = xmlTodos + fgenera-tag("indTrasVehiculoCatM1L","true").  
END.
ELSE DO:
    xmlTodos = xmlTodos + fgenera-tag("indTrasVehiculoCatM1L","false").
END.

IF b-gre_header.indTransbordoProgramado = 1  THEN DO:
    xmlTodos = xmlTodos + fgenera-tag("indTransbordoProgramado","true").
END.
ELSE DO:
    xmlTodos = xmlTodos + fgenera-tag("indTransbordoProgramado","false").
END.

IF b-gre_header.indTrasVehiculoCatM1L = NO AND b-gre_header.modalidadTraslado = "02" THEN DO:
    /* Privado */
    p-xml-header = p-xml-header + fgenera-tag("numeroPlacaVehiculoPrin",fset-placa(b-gre_header.numeroPlacaVehiculoPrin)).
    p-xml-header = p-xml-header + fgenera-tag("tarjetaUnicaCirculacionPrin",fset-placa(b-gre_header.tarjetaUnicaCirculacionPrin)).
    p-xml-header = p-xml-header + fgenera-tag("numeroPlacaVehiculoSec1",fset-placa(b-gre_header.numeroPlacaVehiculoSec1)).
    p-xml-header = p-xml-header + fgenera-tag("tarjetaUnicaCirculacionSec1",fset-placa(b-gre_header.tarjetaUnicaCirculacionSec1)).
END.

p-xml-header = xmlTodos + p-xml-header.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-compra) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-compra Procedure 
PROCEDURE gre-compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    Motivo traslado : 02
*/

DEFINE OUTPUT PARAMETER p-xml-header AS LONGCHAR.

DEFINE VAR x-aaaa-mm-dd AS CHAR.

p-xml-header = fgenera-tag("modalidadTraslado",b-gre_header.modalidadTraslado).
IF b-gre_header.modalidadTraslado = "02" THEN DO:
    /* Privado */
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),1,2).

    p-xml-header = p-xml-header + fgenera-tag("fechaInicioTraslado",x-aaaa-mm-dd).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoConductor",b-gre_header.numeroDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoConductor",b-gre_header.tipoDocumentoConductor).    
        p-xml-header = p-xml-header + fgenera-tag("nombreConductor",b-gre_header.nombreConductor).
        p-xml-header = p-xml-header + fgenera-tag("apellidoConductor",b-gre_header.apellidoConductor).
        p-xml-header = p-xml-header + fgenera-tag("numeroLicencia",b-gre_header.numeroLicencia).
    END.
END.
ELSE DO:
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),1,2).

    /* Publico */
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).

    p-xml-header = p-xml-header + fgenera-tag("fechaEntregaBienes",x-aaaa-mm-dd).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroRucTransportista",b-gre_header.numeroRucTransportista).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoTransportista",b-gre_header.tipoDocumentoTransportista).
        p-xml-header = p-xml-header + fgenera-tag("razonSocialTransportista",b-gre_header.razonSocialTransportista).
    END.

    IF b-gre_header.numeroRegistroMTC > "" THEN DO:
        /*p-xml-header = p-xml-header + fgenera-tag("numeroRegistroMTC",b-gre_header.numeroRegistroMTC).       */
    END.
END.
    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-consignacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-consignacion Procedure 
PROCEDURE gre-consignacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
    05
*/
DEFINE OUTPUT PARAMETER p-xml-header AS LONGCHAR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-devolucion-cliente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-devolucion-cliente Procedure 
PROCEDURE gre-devolucion-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
    13 : Devoluciones por ventas (clientes)
*/
DEFINE OUTPUT PARAMETER p-xml-header AS LONGCHAR.      

DEFINE VAR x-aaaa-mm-dd AS CHAR.

p-xml-header = fgenera-tag("modalidadTraslado",b-gre_header.modalidadTraslado).
IF b-gre_header.modalidadTraslado = "02" THEN DO:
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),1,2).

    /* Privado */
    p-xml-header = p-xml-header + fgenera-tag("fechaInicioTraslado",x-aaaa-mm-dd).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoConductor",b-gre_header.numeroDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoConductor",b-gre_header.tipoDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("nombreConductor",b-gre_header.nombreConductor).
        p-xml-header = p-xml-header + fgenera-tag("apellidoConductor",b-gre_header.apellidoConductor).
        p-xml-header = p-xml-header + fgenera-tag("numeroLicencia",b-gre_header.numeroLicencia).
    END.
END.
ELSE DO:
    /* Publico */
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),1,2).

    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).

    p-xml-header = p-xml-header + fgenera-tag("fechaEntregaBienes",x-aaaa-mm-dd).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroRucTransportista",b-gre_header.numeroRucTransportista).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoTransportista",b-gre_header.tipoDocumentoTransportista).
        p-xml-header = p-xml-header + fgenera-tag("razonSocialTransportista",b-gre_header.razonSocialTransportista).
    END.
    IF b-gre_header.numeroRegistroMTC > "" THEN DO:
        /*p-xml-header = p-xml-header + fgenera-tag("numeroRegistroMTC",b-gre_header.numeroRegistroMTC).       */
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-devolucion-proveedor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-devolucion-proveedor Procedure 
PROCEDURE gre-devolucion-proveedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
    06 : Devoluciones por compras
*/
DEFINE OUTPUT PARAMETER p-xml-header AS LONGCHAR.      

DEFINE VAR x-aaaa-mm-dd AS CHAR.

p-xml-header = fgenera-tag("modalidadTraslado",b-gre_header.modalidadTraslado).
IF b-gre_header.modalidadTraslado = "02" THEN DO:
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),1,2).

    /* Privado */
    p-xml-header = p-xml-header + fgenera-tag("fechaInicioTraslado",x-aaaa-mm-dd).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoConductor",b-gre_header.numeroDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoConductor",b-gre_header.tipoDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("nombreConductor",b-gre_header.nombreConductor).
        p-xml-header = p-xml-header + fgenera-tag("apellidoConductor",b-gre_header.apellidoConductor).
        p-xml-header = p-xml-header + fgenera-tag("numeroLicencia",b-gre_header.numeroLicencia).
    END.
END.
ELSE DO:
    /* Publico */
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),1,2).

    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).

    p-xml-header = p-xml-header + fgenera-tag("fechaEntregaBienes",x-aaaa-mm-dd).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroRucTransportista",b-gre_header.numeroRucTransportista).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoTransportista",b-gre_header.tipoDocumentoTransportista).
        p-xml-header = p-xml-header + fgenera-tag("razonSocialTransportista",b-gre_header.razonSocialTransportista).
    END.
    IF b-gre_header.numeroRegistroMTC > "" THEN DO:
        /*p-xml-header = p-xml-header + fgenera-tag("numeroRegistroMTC",b-gre_header.numeroRegistroMTC).       */
    END.
END.
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-exportacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-exportacion Procedure 
PROCEDURE gre-exportacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
    09
*/    
DEFINE OUTPUT PARAMETER p-xml-header AS LONGCHAR.
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-importacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-importacion Procedure 
PROCEDURE gre-importacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
    08
*/
DEFINE OUTPUT PARAMETER p-xml-header AS LONGCHAR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-itinirante) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-itinirante Procedure 
PROCEDURE gre-itinirante :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
    18 Itinerante
*/
DEFINE OUTPUT PARAMETER p-xml-header AS LONGCHAR.

DEFINE VAR x-aaaa-mm-dd AS CHAR.

p-xml-header = fgenera-tag("modalidadTraslado",b-gre_header.modalidadTraslado).

IF b-gre_header.modalidadTraslado = "02" THEN DO:
    /* Privado */    
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),1,2).
    
    p-xml-header = p-xml-header + fgenera-tag("fechaInicioTraslado",x-aaaa-mm-dd).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoConductor",b-gre_header.numeroDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoConductor",b-gre_header.tipoDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("nombreConductor",b-gre_header.nombreConductor).
        p-xml-header = p-xml-header + fgenera-tag("apellidoConductor",b-gre_header.apellidoConductor).
        p-xml-header = p-xml-header + fgenera-tag("numeroLicencia",b-gre_header.numeroLicencia).
    END.
END.
ELSE DO:
    /* Publico */
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),1,2).

    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).

    p-xml-header = p-xml-header + fgenera-tag("fechaEntregaBienes",x-aaaa-mm-dd).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroRucTransportista",b-gre_header.numeroRucTransportista).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoTransportista",b-gre_header.tipoDocumentoTransportista).
        p-xml-header = p-xml-header + fgenera-tag("razonSocialTransportista",b-gre_header.razonSocialTransportista).
    END.
    /* No obligatorios */
    /*
    p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoPtoLlegada",b-gre_header.numeroDocumentoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("codigoPtollegada",b-gre_header.codigoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoPtoPartida",b-gre_header.numeroDocumentoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("codigoPtoPartida",b-gre_header.codigoPtoPartida).
    */
    IF b-gre_header.numeroRegistroMTC > "" THEN DO:
        /*p-xml-header = p-xml-header + fgenera-tag("numeroRegistroMTC",b-gre_header.numeroRegistroMTC).       */
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-otros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-otros Procedure 
PROCEDURE gre-otros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER p-xml-header AS LONGCHAR.      

/*
    13 : Otros
*/

DEFINE VAR x-aaaa-mm-dd AS CHAR.

p-xml-header = fgenera-tag("modalidadTraslado",b-gre_header.modalidadTraslado).
IF b-gre_header.modalidadTraslado = "02" THEN DO:
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),1,2).

    /* Privado */
    p-xml-header = p-xml-header + fgenera-tag("fechaInicioTraslado",x-aaaa-mm-dd).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoConductor",b-gre_header.numeroDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoConductor",b-gre_header.tipoDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("nombreConductor",b-gre_header.nombreConductor).
        p-xml-header = p-xml-header + fgenera-tag("apellidoConductor",b-gre_header.apellidoConductor).
        p-xml-header = p-xml-header + fgenera-tag("numeroLicencia",b-gre_header.numeroLicencia).
    END.
END.
ELSE DO:
    /* Publico */
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),1,2).

    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).

    p-xml-header = p-xml-header + fgenera-tag("fechaEntregaBienes",x-aaaa-mm-dd).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroRucTransportista",b-gre_header.numeroRucTransportista).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoTransportista",b-gre_header.tipoDocumentoTransportista).
        p-xml-header = p-xml-header + fgenera-tag("razonSocialTransportista",b-gre_header.razonSocialTransportista).
    END.

    IF b-gre_header.numeroRegistroMTC > "" THEN DO:
        /*p-xml-header = p-xml-header + fgenera-tag("numeroRegistroMTC",b-gre_header.numeroRegistroMTC).       */
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-recojo-bien-transformado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-recojo-bien-transformado Procedure 
PROCEDURE gre-recojo-bien-transformado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
    07 : Recojo de bienes transformados
*/
DEFINE OUTPUT PARAMETER p-xml-header AS LONGCHAR.      

DEFINE VAR x-aaaa-mm-dd AS CHAR.

p-xml-header = fgenera-tag("modalidadTraslado",b-gre_header.modalidadTraslado).

IF b-gre_header.modalidadTraslado = "02" THEN DO:
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),1,2).

    /* Privado */
    p-xml-header = p-xml-header + fgenera-tag("fechaInicioTraslado",x-aaaa-mm-dd).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoConductor",b-gre_header.numeroDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoConductor",b-gre_header.tipoDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("nombreConductor",b-gre_header.nombreConductor).
        p-xml-header = p-xml-header + fgenera-tag("apellidoConductor",b-gre_header.apellidoConductor).
        p-xml-header = p-xml-header + fgenera-tag("numeroLicencia",b-gre_header.numeroLicencia).
    END.
END.
ELSE DO:
    /* Publico */
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),1,2).

    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).

    p-xml-header = p-xml-header + fgenera-tag("fechaEntregaBienes",x-aaaa-mm-dd).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroRucTransportista",b-gre_header.numeroRucTransportista).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoTransportista",b-gre_header.tipoDocumentoTransportista).
        p-xml-header = p-xml-header + fgenera-tag("razonSocialTransportista",b-gre_header.razonSocialTransportista).
    END.
    IF b-gre_header.numeroRegistroMTC > "" THEN DO:
        /*p-xml-header = p-xml-header + fgenera-tag("numeroRegistroMTC",b-gre_header.numeroRegistroMTC).       */
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-traslado-establecimientos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-traslado-establecimientos Procedure 
PROCEDURE gre-traslado-establecimientos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
    04 : motivo de Traslado
*/
DEFINE OUTPUT PARAMETER p-xml-header AS LONGCHAR.

DEFINE VAR x-aaaa-mm-dd AS CHAR.

p-xml-header = fgenera-tag("modalidadTraslado",b-gre_header.modalidadTraslado).

IF b-gre_header.modalidadTraslado = "02" THEN DO:
    /* Privado */    
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),1,2).
    
    p-xml-header = p-xml-header + fgenera-tag("fechaInicioTraslado",x-aaaa-mm-dd).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoConductor",b-gre_header.numeroDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoConductor",b-gre_header.tipoDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("nombreConductor",b-gre_header.nombreConductor).
        p-xml-header = p-xml-header + fgenera-tag("apellidoConductor",b-gre_header.apellidoConductor).
        p-xml-header = p-xml-header + fgenera-tag("numeroLicencia",b-gre_header.numeroLicencia).
    END.
    p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoPtoLlegada",b-gre_header.numeroDocumentoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("codigoPtollegada",b-gre_header.codigoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoPtoPartida",b-gre_header.numeroDocumentoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("codigoPtoPartida",b-gre_header.codigoPtoPartida).
END.
ELSE DO:
    /* Publico */
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),1,2).

    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).

    p-xml-header = p-xml-header + fgenera-tag("fechaEntregaBienes",x-aaaa-mm-dd).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroRucTransportista",b-gre_header.numeroRucTransportista).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoTransportista",b-gre_header.tipoDocumentoTransportista).
        p-xml-header = p-xml-header + fgenera-tag("razonSocialTransportista",b-gre_header.razonSocialTransportista).
    END.
    /* No obligatorios */
    p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoPtoLlegada",b-gre_header.numeroDocumentoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("codigoPtollegada",b-gre_header.codigoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoPtoPartida",b-gre_header.numeroDocumentoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("codigoPtoPartida",b-gre_header.codigoPtoPartida).

    IF b-gre_header.numeroRegistroMTC > "" THEN DO:
        /*p-xml-header = p-xml-header + fgenera-tag("numeroRegistroMTC",b-gre_header.numeroRegistroMTC).       */
    END.


END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-traslado-para-transformacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-traslado-para-transformacion Procedure 
PROCEDURE gre-traslado-para-transformacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
    17 : Traslado de bienes para transformacion
*/
DEFINE OUTPUT PARAMETER p-xml-header AS LONGCHAR.      

DEFINE VAR x-aaaa-mm-dd AS CHAR.

p-xml-header = fgenera-tag("modalidadTraslado",b-gre_header.modalidadTraslado).

IF b-gre_header.modalidadTraslado = "02" THEN DO:
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),1,2).

    /* Privado */
    p-xml-header = p-xml-header + fgenera-tag("fechaInicioTraslado",x-aaaa-mm-dd).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoConductor",b-gre_header.numeroDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoConductor",b-gre_header.tipoDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("nombreConductor",b-gre_header.nombreConductor).
        p-xml-header = p-xml-header + fgenera-tag("apellidoConductor",b-gre_header.apellidoConductor).
        p-xml-header = p-xml-header + fgenera-tag("numeroLicencia",b-gre_header.numeroLicencia).
    END.
END.
ELSE DO:
    /* Publico */
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),1,2).

    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).

    p-xml-header = p-xml-header + fgenera-tag("fechaEntregaBienes",x-aaaa-mm-dd).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroRucTransportista",b-gre_header.numeroRucTransportista).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoTransportista",b-gre_header.tipoDocumentoTransportista).
        p-xml-header = p-xml-header + fgenera-tag("razonSocialTransportista",b-gre_header.razonSocialTransportista).
    END.
    IF b-gre_header.numeroRegistroMTC > "" THEN DO:
        /*p-xml-header = p-xml-header + fgenera-tag("numeroRegistroMTC",b-gre_header.numeroRegistroMTC).       */
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-venta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-venta Procedure 
PROCEDURE gre-venta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*  Motivo de traslado
    01 : Venta
    03 : Venta con entrega a terceros
    14 : Venta sujeta a confirmacion
*/

DEFINE OUTPUT PARAMETER p-xml-header AS LONGCHAR.

DEFINE VAR x-aaaa-mm-dd AS CHAR.

p-xml-header = fgenera-tag("modalidadTraslado",b-gre_header.modalidadTraslado).
IF b-gre_header.modalidadTraslado = "02" THEN DO:
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaInicioTraslado,"99-99-9999"),1,2).

    /* Privado */
    p-xml-header = p-xml-header + fgenera-tag("fechaInicioTraslado",x-aaaa-mm-dd).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroDocumentoConductor",b-gre_header.numeroDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoConductor",b-gre_header.tipoDocumentoConductor).
        p-xml-header = p-xml-header + fgenera-tag("nombreConductor",b-gre_header.nombreConductor).
        p-xml-header = p-xml-header + fgenera-tag("apellidoConductor",b-gre_header.apellidoConductor).
        p-xml-header = p-xml-header + fgenera-tag("numeroLicencia",b-gre_header.numeroLicencia).
    END.
END.
ELSE DO:
    /* Publico */
    x-aaaa-mm-dd = SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),7,4) + "-".
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),4,2) + "-" .
    x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-gre_header.fechaEntregaBienes,"99-99-9999"),1,2).

    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoLLegada",b-gre_header.ubigeoPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoLLegada",b-gre_header.direccionPtoLlegada).
    p-xml-header = p-xml-header + fgenera-tag("ubigeoPtoPartida",b-gre_header.ubigeoPtoPartida).
    p-xml-header = p-xml-header + fgenera-tag("direccionPtoPartida",b-gre_header.direccionPtoPartida).

    p-xml-header = p-xml-header + fgenera-tag("fechaEntregaBienes",x-aaaa-mm-dd).
    IF b-gre_header.indTrasVehiculoCatM1L = NO THEN DO:
        p-xml-header = p-xml-header + fgenera-tag("numeroRucTransportista",b-gre_header.numeroRucTransportista).
        p-xml-header = p-xml-header + fgenera-tag("tipoDocumentoTransportista",b-gre_header.tipoDocumentoTransportista).
        p-xml-header = p-xml-header + fgenera-tag("razonSocialTransportista",b-gre_header.razonSocialTransportista).
    END.
    IF b-gre_header.numeroRegistroMTC > "" THEN DO:
        /*p-xml-header = p-xml-header + fgenera-tag("numeroRegistroMTC",b-gre_header.numeroRegistroMTC).       */
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pcrea-obj-xml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pcrea-obj-xml Procedure 
PROCEDURE pcrea-obj-xml :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CREATE "MSXML2.ServerXMLHTTP.6.0" hoXmlHttp.
CREATE "MSXML2.DOMDocument.6.0" hoXMLBody.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pelimina-obj-xml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pelimina-obj-xml Procedure 
PROCEDURE pelimina-obj-xml :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RELEASE OBJECT hoXmlHttp NO-ERROR.
RELEASE OBJECT hoXMLBody NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fgenera-tag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fgenera-tag Procedure 
FUNCTION fgenera-tag RETURNS CHARACTER
  ( INPUT pTag AS CHAR,INPUT pDato AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS CHAR.
  DEFINE VAR x-dato AS CHAR.

  x-retval = "".

  x-dato = pDato.
  IF TRUE <> (pDato > "") THEN DO:
      /*x-dato = "-".*/
  END.

  IF NOT ( TRUE <> (pTag > "")) AND NOT ( TRUE <> (pDato > "")) THEN DO:
      /*x-retval = "<" + TRIM(pTag) + ">" + TRIM(pDato) + "</" + TRIM(pTag) + ">".*/
      x-retval = "<" + TRIM(pTag) + ">" + TRIM(x-Dato) + "</" + TRIM(pTag) + ">".
  END.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-como-pago) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-como-pago Procedure 
FUNCTION fget-como-pago RETURNS CHARACTER
    ( INPUT pTipoDoc AS CHAR, pNroDoc AS CHAR, pCodDiv AS CHAR) :

    DEFINE VAR lRetVal AS CHAR INIT "".
    DEFINE VAR lRetTipo AS CHAR INIT "".
    DEFINE VAR lRetDetalle AS CHAR INIT "".
    DEFINE VAR lRetImpte AS CHAR INIT "".

    DEFINE VAR lTotRecibido AS DEC.
    DEFINE VAR lFpagosx AS DEC.
    DEFINE VAR lMoneda AS CHAR.
    DEFINE VAR lFiler1 AS CHAR.

    DEFINE BUFFER zz-ccbcdocu FOR ccbcdocu.
    FIND FIRST zz-ccbcdocu WHERE zz-ccbcdocu.codcia = s-codcia AND 
                                    zz-ccbcdocu.coddiv = pCodDiv AND
                                    zz-ccbcdocu.coddoc = pTipoDoc AND
                                    zz-ccbcdocu.nrodoc = pNroDoc AND 
                                    zz-ccbcdocu.flgest <> 'A'
                                 NO-LOCK NO-ERROR.

    IF AVAILABLE zz-ccbcdocu THEN DO:

        DEFINE BUFFER zz-CcbDCaja FOR CcbDCaja.
        DEFINE BUFFER zz-CcbCCaja FOR CcbCCaja.

        FIND FIRST zz-CcbDCaja WHERE
              zz-CcbDCaja.CodCia = s-codcia AND
              zz-CcbDCaja.CodRef = zz-CcbCDocu.Coddoc AND
              zz-CcbDCaja.NroRef = zz-CcbCDocu.Nrodoc NO-LOCK NO-ERROR.
        IF AVAILABLE zz-CcbDCaja THEN DO:
            FIND FIRST zz-ccbccaja OF zz-ccbdcaja NO-LOCK NO-ERROR.
        END.

        IF AVAILABLE zz-ccbccaja THEN DO:
            /* EFECTIVO */
            lTotRecibido = 0.
            lFpagosx    = 0.
            lMoneda = IF (zz-ccbcdocu.codmon = 2) THEN "$." ELSE "S/".
            
            IF TRIM(lMoneda) = 'S/' THEN DO:
                lFpagosx = IF (zz-ccbccaja.impnac[1] > 0) THEN  zz-ccbccaja.impnac[1] ELSE 0.
                lFpagosx = lFpagosx + IF (zz-ccbccaja.impnac[5] > 0) THEN  zz-ccbccaja.impnac[5] ELSE 0.
                lFpagosx = lFpagosx + IF (zz-ccbccaja.impnac[7] > 0) THEN  zz-ccbccaja.impnac[7] ELSE 0.
            END.
            ELSE DO:
                lFpagosx = IF (zz-ccbccaja.impusa[1] > 0) THEN  zz-ccbccaja.impusa[1] ELSE 0.
                lFpagosx = lFpagosx + IF (zz-ccbccaja.impusa[5] > 0) THEN  zz-ccbccaja.impusa[5] ELSE 0.
                lFpagosx = lFpagosx + IF (zz-ccbccaja.impusa[7] > 0) THEN  zz-ccbccaja.impusa[7] ELSE 0.
            END.
            lTotRecibido = lFpagosx.
            IF lTotRecibido > 0 THEN DO:
                lRetTipo = "EFECTIVO".
                lRetDetalle = "SOLES S/".
                lRetImpte = STRING(lFpagosx,">>,>>9.99").
                IF TRIM(lMoneda) <> 'S/' THEN DO:
                    lRetDetalle = "DOLARES - $".
                    lRetImpte = STRING(lFpagosx * zz-ccbccaja.tpocmb,">>,>>9.99").
                END.            
            END.
            
            /* TARJETA */
            IF zz-ccbccaja.impnac[4] > 0 THEN DO:
                lRetTipo = lRetTipo + IF(lRetTipo <> "") THEN "@@" ELSE "".
                lRetTipo = lRetTipo + "TARJETA".
                lRetDetalle = lRetDetalle + IF(lRetDetalle <> "") THEN "@@" ELSE "".
                lRetDetalle = lRetDetalle + fget-utf-8(TRIM(zz-ccbccaja.voucher[9])).
                lRetImpte = lRetImpte + IF(lRetImpte <> "") THEN "@@" ELSE "".
                lRetImpte = lRetImpte + STRING(zz-ccbccaja.impnac[4],">>,>>9.99").
                lTotRecibido = lTotRecibido + zz-ccbccaja.impnac[4].
            END.
            /* NOTA DE CREDITO */
            IF zz-ccbccaja.impnac[6] > 0 THEN DO:
                lFiler1 = "-".
                /* Buscar la N/C */
                DEFINE BUFFER ix-ccbdmov FOR ccbdmov.
                FIND FIRST ix-ccbdmov WHERE ix-ccbdmov.codcia = s-codcia AND 
                                                ix-ccbdmov.codref = zz-ccbccaja.coddoc AND 
                                                ix-ccbdmov.nroref = zz-ccbccaja.nrodoc AND 
                                                ix-ccbdmov.coddoc = 'N/C' NO-LOCK NO-ERROR.
                IF AVAILABLE ix-ccbdmov THEN DO:
                    lFiler1 = SUBSTRING( SUBSTRING(ix-ccbdmov.nrodoc,1,3) + "-" + 
                                         SUBSTRING(ix-ccbdmov.nrodoc,4) + FILL(" ",16),1,16).
                END.
                RELEASE ix-ccbdmov.
    
                lRetTipo = lRetTipo + IF(lRetTipo <> "") THEN "@@" ELSE "".
                lRetTipo = lRetTipo + "NOTA CRED".
                lRetDetalle = lRetDetalle + IF(lRetDetalle <> "") THEN "@@" ELSE "".
                lRetDetalle = lRetDetalle + lFiler1.
                lRetImpte = lRetImpte + IF(lRetImpte <> "") THEN "@@" ELSE "".
                lRetImpte = lRetImpte + STRING(zz-ccbccaja.impnac[6],">>,>>9.99").
                lTotRecibido = lTotRecibido + zz-ccbccaja.impnac[6].
            END.
            /* VALES */
            IF zz-ccbccaja.impnac[10] > 0 THEN DO:
                lRetTipo = lRetTipo + IF(lRetTipo <> "") THEN "@@" ELSE "".
                lRetTipo = lRetTipo + "VALES".
                lRetDetalle = lRetDetalle + IF(lRetDetalle <> "") THEN "@@" ELSE "".
                lRetDetalle = lRetDetalle + "VALES".
                lRetImpte = lRetImpte + IF(lRetImpte <> "") THEN "@@" ELSE "".
                lRetImpte = lRetImpte + STRING(zz-ccbccaja.impnac[10],">>,>>9.99").
                lTotRecibido = lTotRecibido + zz-ccbccaja.impnac[10].
            END.
    
            IF lRetTipo <> "" THEN DO:
                lRetVal = lRetVal + "PE|" +
                    "TIPOPAGO|" +
                    lRetTipo +
                    gcCRLF.
                lRetVal = lRetVal + "PE|" +
                    "DETALLETIPOPAGO|" +
                    lRetDetalle +
                    gcCRLF.
                lRetVal = lRetVal + "PE|" +
                    "IMPTIPOPAGO|" +
                    lRetImpte +
                    gcCRLF.
            END.
    
            IF lTotRecibido > 0 THEN DO:
                lRetVal = lRetVal + "PE|" +
                    "TOTALRECIBIDO|" +
                    STRING(lTotRecibido,">>,>>9.99") +
                    gcCRLF.
    
            END.
            IF zz-ccbccaja.vuenac > 0  THEN DO:
                lRetVal = lRetVal + "PE|" +
                    "IMPCAMBIOPAGO|" +
                    STRING(zz-ccbccaja.vuenac,">>,>>9.99") +
                    gcCRLF.
            END.                                           
        END.
        RELEASE zz-CcbDCaja.
        RELEASE zz-CcbCCaja.

    END.

    RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-descripcion-articulo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-descripcion-articulo Procedure 
FUNCTION fget-descripcion-articulo RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pCodDoc AS CHAR, INPUT pCondCred AS CHAR, INPUT pTipoFac AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lRetVal AS CHAR INIT "".

    DEFINE BUFFER bz-almmmatg FOR almmmatg.

    FIND FIRST bz-almmmatg WHERE bz-almmmatg.codcia = s-codcia AND 
                                bz-almmmatg.codmat = pCodMat
                                NO-LOCK NO-ERROR.
    IF AVAILABLE bz-almmmatg THEN lRetVal = TRIM(almmmatg.desmat).

    IF pCoddoc = 'N/C' OR pCoddoc = 'N/D' THEN DO:
        /* Notas de Credito / Debito que no es devolucion de Mercaderia */
        IF pCondCred <> 'D' THEN DO:
            FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                        ccbtabla.tabla = pCoddoc AND 
                                        ccbtabla.codigo = pCodmat
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE ccbtabla THEN DO:
                lRetVal = TRIM(ccbtabla.nombre).
            END.
        END.
    END.
    ELSE DO:
        IF pTipoFac = 'S' /*OR pTipoFac = 'A' */ THEN DO:
            /* Factura de Servicios o Anticipo de campaña */
            FIND FIRST almmserv WHERE almmserv.codcia = s-codcia AND 
                                        almmserv.codmat = pCodMat 
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE almmserv THEN DO:
                lRetVal = TRIM(almmserv.desmat).
            END.
        END.        
    END.

    RELEASE bz-almmmatg.

  lRetVal = fget-utf-8(TRIM(lRetVal)).

  RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-doc-original) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-doc-original Procedure 
FUNCTION fget-doc-original RETURNS CHARACTER
  ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Se debe enviar N/C o N/D
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR lRetVal AS CHAR.

    DEFINE VAR lDocFactura AS CHAR.
    DEFINE VAR lDocBoleta AS CHAR.
    DEFINE VAR lDocLetra AS CHAR.

    lRetVal = ?.

    DEFINE BUFFER fx-ccbcdocu FOR ccbcdocu.
    DEFINE BUFFER fx-ccbdmvto FOR ccbdmvto.

    FIND FIRST fx-ccbcdocu USE-INDEX llave01 WHERE fx-ccbcdocu.codcia = s-codcia AND 
                                    fx-ccbcdocu.coddoc = pTipoDoc AND 
                                    fx-ccbcdocu.nrodoc = pNroDoc 
                                    NO-LOCK NO-ERROR.
    IF AVAILABLE fx-ccbcdocu THEN DO:    
        /*DISPLAY fx-ccbcdocu.coddoc fx-ccbcdocu.nrodoc fx-ccbcdocu.codref fx-ccbcdocu.nroref.*/
        IF fx-ccbcdocu.codref = 'FAC' OR fx-ccbcdocu.codref = 'BOL' OR 
                fx-ccbcdocu.codref = 'TCK' THEN DO:

            IF fx-ccbcdocu.codref = 'FAC' THEN lRetVal = 'F' + fx-ccbcdocu.nroref.
            IF fx-ccbcdocu.codref = 'BOL' OR fx-ccbcdocu.codref = 'TCK' THEN lRetVal = 'B' + fx-ccbcdocu.nroref.        

        END.
        ELSE DO:            
            IF fx-ccbcdocu.codref = 'LET' THEN DO:
                /* Como Referencia - LETRA */
                lRetVal = fget-doc-original(fx-ccbcdocu.codref, fx-ccbcdocu.nroref).
            END.
            ELSE DO:
                IF fx-ccbcdocu.codref = 'CJE' OR fx-ccbcdocu.codref = 'RNV' OR fx-ccbcdocu.codref = 'REF' THEN DO:
                    /* Si en CANJE, RENOVACION y REFINANCIACION */
                    lDocFactura = "".
                    lDocBoleta = "".
                    lDocLetra = "".
                    /*DISPLAY pTipoDoc pNroDoc.*/                    
                    FOR EACH fx-ccbdmvto WHERE fx-ccbdmvto.codcia = s-codcia AND 
                                                fx-ccbdmvto.coddoc = fx-ccbcdocu.codref AND 
                                                fx-ccbdmvto.nrodoc = fx-ccbcdocu.nroref NO-LOCK:                        
                                                
                        IF fx-ccbdmvto.nroref <> pnroDoc THEN DO:
                            IF fx-ccbdmvto.codref = 'FAC' OR fx-ccbdmvto.codref = 'BOL' THEN DO:
                                IF fx-ccbdmvto.codref = 'FAC' AND lDocFactura = "" THEN lDocFactura = "F" + fx-ccbdmvto.nroref.
                                IF fx-ccbdmvto.codref = 'BOL' AND lDocBoleta = "" THEN lDocBoleta = "B" + fx-ccbdmvto.nroref.
                                LEAVE.
                            END.
                            ELSE DO:
                                IF fx-ccbdmvto.codref = 'LET' THEN  DO:                                    
                                    lRetVal = fget-doc-original("LET", fx-ccbdmvto.nroref).
                                    /*DISPLAY fx-ccbdmvto.codref fx-ccbdmvto.nroref lRetVal.*/
                                    IF SUBSTRING(lRetVal,1,1) = 'F' OR SUBSTRING(lRetVal,1,1) = 'B' THEN DO:
                                        IF SUBSTRING(lRetVal,1,1)='F' AND lDocFactura = "" THEN lDocFactura = lRetVal.
                                        IF SUBSTRING(lRetVal,1,1)="B" AND lDocBoleta = "" THEN lDocBoleta = lRetVal.
                                        LEAVE.
                                    END.
                                END.
                            END.
                        END.
                    END.
                    
                    IF lDocFactura  = "" AND lDocBoleta = "" AND lDocLetra <> "" THEN DO:
                        /* es una LETRA */
                        /*lRetVal = fget-doc-original("LET", lDocLetra).*/
                    END.
                    ELSE DO:
                        IF lDocBoleta  <> "" THEN lRetVal = lDocBoleta.
                        IF lDocFactura  <> "" THEN lRetVal = lDocFactura.
                    END.
                END.
                /* 
                    Puede que hayan CLA : Canje x letra adelantada, pero el dia que salte ese error
                    ya se programa...
                */
                IF fx-ccbcdocu.codref = 'CLA' THEN DO:
                    /* Buscar el A/R */
                    DEFINE BUFFER zx-ccbcdocu FOR ccbcdocu.
                    FIND FIRST zx-ccbcdocu WHERE  zx-ccbcdocu.codcia = s-codcia AND 
                                                zx-ccbcdocu.coddoc = 'A/R' AND 
                                                zx-ccbcdocu.codref = "CLA" AND
                                                zx-ccbcdocu.nroref = fx-ccbcdocu.nroref 
                                                NO-LOCK NO-ERROR.
                    IF AVAILABLE zx-ccbcdocu THEN DO:
                        /**/
                        DEFINE BUFFER zx-ccbdmov FOR ccbdmov.
                        FIND FIRST zx-ccbdmov WHERE zx-ccbdmov.codcia = s-codcia AND 
                                                zx-ccbdmov.coddoc = 'A/R' AND 
                                                zx-ccbdmov.nrodoc = zx-ccbcdocu.nrodoc
                                                NO-LOCK NO-ERROR.
                        IF AVAILABLE zx-ccbdmov THEN DO:
                            /* Caja */
                            DEFINE BUFFER zx-ccbdcaja FOR ccbdcaja.
                            FOR EACH zx-ccbdcaja WHERE zx-ccbdcaja.codcia = s-codcia AND 
                                                        zx-ccbdcaja.coddoc = zx-ccbdmov.codref AND 
                                                        zx-ccbdcaja.nrodoc = zx-ccbdmov.nroref
                                                        NO-LOCK:
                                IF zx-ccbdcaja.codref = 'FAC' OR zx-ccbdcaja.codref = 'BOL' THEN DO:
                                    IF zx-ccbdcaja.codref = 'FAC' THEN lRetVal = "F" + zx-ccbdcaja.nroref.
                                    IF zx-ccbdcaja.codref = 'BOL' THEN lRetVal = "B" + zx-ccbdcaja.nroref.
                                    LEAVE.
                                END.
                            END.
                            RELEASE zx-ccbdcaja.
                        END.
                        RELEASE zx-ccbdmov.
                    END.
                    RELEASE zx-ccbcdocu.
                END.
            END.
        END.
    END.

    RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-email-cliente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-email-cliente Procedure 
FUNCTION fget-email-cliente RETURNS CHARACTER
  ( INPUT pCodCliente AS CHAR ) :

DEFINE VAR lRetVal AS CHAR INIT "".

FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND 
                            gn-clie.codcli = pCodCliente NO-LOCK NO-ERROR.
lRetVal = "-".
IF AVAILABLE gn-clie THEN DO:
    IF NOT (TRUE <> (gn-clie.transporte[4] > "")) THEN DO:
        lRetVal = fget-utf-8(TRIM(gn-clie.transporte[4])).
    END.
    ELSE DO:
        IF NOT (TRUE <> (gn-clie.e-mail > "")) THEN DO:
            /*
                Ic - 22Abr2019, Ruben corrio un proceso para copiar el e-mail al campo gn-clie.transporte[4] siempre y cuando no existiese
            */
            /*lRetVal = fget-utf-8(TRIM(gn-clie.e-mail)).*/
        END.
    END.
END.

lRetVal = TRIM(lRetVal).         

/*
lRetVal = REPLACE(lRetVal,"/",";").
lRetVal = REPLACE(lRetVal,"\",";").
*/
lRetVal = REPLACE(lRetVal,",",";").
IF TRUE <> (lRetVal > "") THEN lRetVal = "-".

/* Verificar que el eMail es correcto */
/*IF INDEX(lRetVal," ") = 0 THEN DO:*/
    IF lRetval <> "-" THEN DO:    
        DEFINE VAR x-parse AS INT.
        DEFINE VAR x-dominio AS CHAR.

        x-parse = NUM-ENTRIES(lRetVal,"@").
        IF x-parse >= 2 THEN DO:
            x-dominio = ENTRY(2,lRetVal,"@") NO-ERROR.
            x-parse = NUM-ENTRIES(x-dominio,".") NO-ERROR.
            IF x-parse <= 1 THEN DO:
                /* Dominio errado */
                /*lRetVal = "-".*/
            END.
        END.
        ELSE DO:
            /* Estructura de correo errado */
            /*lRetVal = "-".*/
        END.
    END.
/*
END.
ELSE DO:
    /* Correo tiene espacios */
    lRetVal = "-".
END.
*/

/*MESSAGE "CORREO " lRetVal.*/

lRetVal = "<correoAdquiriente>" + lRetVal + "</correoAdquiriente>".

RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-personalizados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-personalizados Procedure 
FUNCTION fget-personalizados RETURNS CHARACTER
  ( INPUT pTipoVenta AS CHAR,INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pCoddiv AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lRetVal AS CHAR INIT "".

    /*
    IF pTipoVenta = 'MOSTRADOR' THEN lRetVal = fget-personalizados-ticket(pRowId).
    IF pTipoVenta = 'CREDITO' THEN lRetVal = fget-personalizados-pre-impreso(pRowId).
    */

    lRetVal = fget-personalizados-pre-impreso(pTipoDoc, pNroDoc, pCodDiv).

    RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-personalizados-pre-impreso) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-personalizados-pre-impreso Procedure 
FUNCTION fget-personalizados-pre-impreso RETURNS CHARACTER
  ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pCodDiv AS CHAR ) :

  DEFINE VAR lRetVal AS CHAR INIT "".
  DEFINE VAR lOrdenCompra AS CHAR INIT "".
  DEFINE VAR x-dir-despacho AS CHAR INIT "".

  /*
  DEFINE BUFFER zy-ccbcdocu FOR ccbcdocu.
  
  FIND FIRST zy-ccbcdocu WHERE zy-ccbcdocu.codcia = s-codcia AND 
                                zy-ccbcdocu.coddiv = pCodDiv AND 
                                zy-ccbcdocu.coddoc = pTipoDoc AND 
                                zy-ccbcdocu.nrodoc = pNroDoc AND
                                zy-ccbcdocu.flgest <> 'A'
                                NO-LOCK NO-ERROR.
  IF AVAILABLE zy-ccbcdocu THEN DO:

      /* URL consulta documento electronico */
      /*
      lRetval = "<codigoLeyenda_6>6001</codigoLeyenda_6>".
      lRetval = lRetval + "<textoLeyenda_6>" + x-url-consulta-documento-electronico + "</textoLeyenda_6>".
      */
      IF zy-ccbcdocu.NroOrd <> ? OR zy-ccbcdocu.NroOrd <> '' THEN DO:
            lOrdenCompra = TRIM(zy-ccbcdocu.NroOrd).
      END.

      /* Plantillas adicionales */

      /* Nombre de la tienda, para ticket de UTILEX */
      FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                                gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.      
      IF AVAILABLE gn-div THEN DO:
          /* Lugar de Emision y nombre de la tienda */
          /*
          lRetval = lRetval + "<codigoLeyenda_7>6002</codigoLeyenda_7>" .
          lRetval = lRetval + "<textoLeyenda_7>" + fget-utf-8(TRIM(REPLACE(gn-div.desdiv,"|"," "))) + "</textoLeyenda_7>" .
          */
          IF NOT (TRUE <> (gn-div.dirdiv > "")) THEN DO:
              x-dir-despacho = CAPS(fget-utf-8(TRIM(REPLACE(gn-div.dirdiv,"|"," ")))).
              IF NOT (TRUE <> (gn-div.faxdiv > "")) THEN DO:
                  x-dir-despacho = x-dir-despacho + " - " + CAPS(TRIM(gn-div.faxdiv)).
              END.
              lRetval = lRetval + "<codigoAuxiliar250_1>9017</codigoAuxiliar250_1>" .
              lRetval = lRetval + "<textoAuxiliar250_1>" + x-dir-despacho + "</textoAuxiliar250_1>" .
          END.
      END.
      
      /* Pedido */
      IF zy-ccbcdocu.nroped <> ? AND zy-ccbcdocu.nroped <> '' THEN DO:
          lRetval = lRetval + "<codigoAuxiliar40_1>9708</codigoAuxiliar40_1>" .
          lRetval = lRetval + "<textoAuxiliar40_1>" + zy-ccbcdocu.nroped + "</textoAuxiliar40_1>" .
      END.
      /* Forma de Pago */
      FIND FIRST gn-convt WHERE gn-convt.codig = zy-ccbcdocu.fmapgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN DO:
          /*
          lRetval = lRetval + "<codigoAuxiliar40_2>9015</codigoAuxiliar40_2>" .
          lRetval = lRetval + "<textoAuxiliar40_2>" + fget-utf-8(TRIM(REPLACE(gn-convt.nombr,"|"," "))) + "</textoAuxiliar40_2>" .
          */
          lRetval = lRetval + "<codigoAuxiliar100_2>9015</codigoAuxiliar100_2>" .
          lRetval = lRetval + "<textoAuxiliar100_2>" + fget-utf-8(TRIM(REPLACE(gn-convt.nombr,"|"," "))) + "</textoAuxiliar100_2>" .
      END.
      /* Tipo de Venta */
      IF zy-ccbcdocu.tipo <> ? AND zy-ccbcdocu.tipo <> '' THEN DO:
          lRetval = lRetval + "<codigoAuxiliar40_3>9421</codigoAuxiliar40_3>" .
          lRetval = lRetval + "<textoAuxiliar40_3>" + fget-utf-8(zy-ccbcdocu.tipo) + "</textoAuxiliar40_3>" .
      END.
      /* Codigo vendedor */
      IF zy-ccbcdocu.codven <> ? AND zy-ccbcdocu.codven <> '' THEN DO:
          lRetval = lRetval + "<codigoAuxiliar40_4>9218</codigoAuxiliar40_4>" .
          lRetval = lRetval + "<textoAuxiliar40_4>" + fget-utf-8(zy-ccbcdocu.codven) + "</textoAuxiliar40_4>" .
      END.
      /* Cajera */
      IF zy-ccbcdocu.usuario <> ? AND zy-ccbcdocu.usuario <> '' THEN DO:
          lRetval = lRetval + "<codigoAuxiliar40_5>8569</codigoAuxiliar40_5>" .
          lRetval = lRetval + "<textoAuxiliar40_5>" + fget-utf-8(zy-ccbcdocu.usuario) + "</textoAuxiliar40_5>" .
      END.
      /* % IGV */
      IF zy-ccbcdocu.porigv >= 0  THEN DO:
          lRetval = lRetval + "<codigoAuxiliar40_6>9011</codigoAuxiliar40_6>" .
          lRetval = lRetval + "<textoAuxiliar40_6>" + STRING(zy-ccbcdocu.porigv,lFmtoImpte) + "</textoAuxiliar40_6>" .
      END.
      /* Ic - 24Ago2018 RTV, supermercados peruanos */      
      IF zy-ccbcdocu.coddoc = 'N/C' AND zy-ccbcdocu.codcli = "20100070970" THEN DO:
          lOrdenCompra = "".
          FIND FIRST almcmov WHERE almcmov.codcia = s-codcia AND 
                                      almcmov.codalm = zy-ccbcdocu.codalm AND
                                      almcmov.tipmov = 'I' AND
                                      almcmov.codmov = zy-ccbcdocu.codmov AND 
                                      almcmov.nrodoc = INTEGER(TRIM(zy-ccbcdocu.nroped))
                                      NO-LOCK NO-ERROR.
          IF AVAILABLE almcmov THEN DO:
              IF NOT (TRUE <> (almcmov.lpn > "")) THEN lOrdenCompra = TRIM(almcmov.lpn).
          END.
      END.

      IF zy-ccbcdocu.coddoc = 'FAC' OR zy-ccbcdocu.coddoc = 'BOL' THEN DO:
          lRetval = lRetval + "<codigoAuxiliar100_1>9611</codigoAuxiliar100_1>" .
          lRetval = lRetval + "<textoAuxiliar100_1>INCORP. AL REGIMEN DE AGENTE DE RETENCION DE IGV (RS: 265-2009) A PARTIR DEL 01/10/10</textoAuxiliar100_1>" .

          /* Orden de Compra, es para la impresion  ????????????????????????????? Bizlinks debe indicar el codigo */
          
          IF lOrdenCompra <> "" THEN DO:
              lRetval = lRetval + "<codigoAuxiliar250_1>9619</codigoAuxiliar250_1>" .
              lRetval = lRetval + "<textoAuxiliar250_1>O.COMPRA : " + lOrdenCompra + "</textoAuxiliar250_1>" .
          END.
          
      END.
      ELSE DO:
          IF zy-ccbcdocu.coddoc = 'N/C' AND zy-ccbcdocu.codcli = "20100070970" THEN DO:
              /* Ic - 24Ago2018 RTV, supermercados peruanos */      
              IF lOrdenCompra <> "" THEN DO:
                  
                  lRetval = lRetval + "<codigoAuxiliar250_1>9619</codigoAuxiliar250_1>" .
                  lRetval = lRetval + "<textoAuxiliar250_1>RTV : " + lOrdenCompra + "</textoAuxiliar250_1>" .
                  
              END.              
          END.
      END.
  END.
*/

  RETURN lRetVal.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-personalizados-ticket) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-personalizados-ticket Procedure 
FUNCTION fget-personalizados-ticket RETURNS CHARACTER
    ( INPUT pTipoDoc AS CHAR, pNroDoc AS CHAR, pCodDiv AS CHAR ) :

    DEFINE VAR lRetVal AS CHAR INIT "".

    DEFINE BUFFER zy-ccbcdocu FOR ccbcdocu.
    /*
    FIND FIRST zy-ccbcdocu WHERE zy-ccbcdocu.codcia = s-codcia AND 
                                  zy-ccbcdocu.coddiv = pCodDiv AND 
                                  zy-ccbcdocu.coddoc = pTipoDoc AND 
                                  zy-ccbcdocu.nrodoc = pNroDoc AND
                                  zy-ccbcdocu.flgest <> 'A'
                                  NO-LOCK NO-ERROR.

    IF AVAILABLE zy-ccbcdocu THEN DO:

        cURLDocumento = fget-url(zy-ccbcdocu.coddoc).

        /* Plantillas adicionales */
        FIND FIRST gn-div OF zy-ccbcdocu NO-LOCK NO-ERROR.
        IF AVAILABLE gn-div THEN DO:
            lRetVal = lRetVal + "PE|" +
                "LOCAL|" +
                fget-utf-8(TRIM(REPLACE(gn-div.DESdiv,"|"," "))) + 
                gcCRLF.
            lRetVal = lRetVal + "PE|" +
                "SUCURSAL01|" +
                fget-utf-8(TRIM(REPLACE(gn-div.dirdiv,"|"," "))) + 
                gcCRLF.

            IF gn-div.faxdiv <> ? AND gn-div.faxdiv <> ""  THEN DO:
                lRetVal = lRetVal + "PE|" +
                    "SUCURSAL02|" +
                    fget-utf-8(TRIM(REPLACE(gn-div.faxdiv,"|"," "))) + 
                    gcCRLF.
            END.
            IF gn-div.teldiv <> ? AND gn-div.teldiv <> ""  THEN DO:
                lRetVal = lRetVal + "PE|" +
                    "NumInterno|" +
                    fget-utf-8(TRIM(gn-div.teldiv)) + 
                    gcCRLF.
            END.

        END.
        lRetVal = lRetVal + "PE|" +
            "HorVenta|" +
            TRIM(zy-ccbcdocu.horcie) + 
            gcCRLF.
        lRetVal = lRetVal + "PE|" +
            "Tienda|" +
            TRIM(zy-ccbcdocu.coddiv) + 
            gcCRLF.
        IF zy-ccbcdocu.usuario <> ? AND zy-ccbcdocu.usuario <> '' THEN DO:
            lRetVal = lRetVal + "PE|" +
                "Cajero|" +
                fget-utf-8(TRIM(zy-ccbcdocu.usuario)) +
                gcCRLF.
        END.
        IF zy-ccbcdocu.porigv >= 0  THEN DO:
            lRetVal = lRetVal + "PE|" +
                "IGV|" +
                STRING(zy-ccbcdocu.porigv,lFmtoImpte) +
                gcCRLF.
        END.        
        /* para tickets
        IF zy-ccbcdocu.coddoc = 'FAC' THEN lRetVal = lRetVal + "PE|Plantilla|T01ch.jasper" + gcCRLF.
        IF zy-ccbcdocu.coddoc = 'BOL' THEN lRetVal = lRetVal + "PE|Plantilla|T03ch.jasper" + gcCRLF.
        IF zy-ccbcdocu.coddoc = 'TCK' THEN lRetVal = lRetVal + "PE|Plantilla|T03ch.jasper" + gcCRLF.
        IF zy-ccbcdocu.coddoc = 'N/C' THEN lRetVal = lRetVal + "PE|Plantilla|T07ch.jasper" + gcCRLF.
        IF zy-ccbcdocu.coddoc = 'N/D' THEN lRetVal = lRetVal + "PE|Plantilla|T08ch.jasper" + gcCRLF.
        */
        /* A4 - Pre-impreso */
        IF zy-ccbcdocu.coddoc = 'FAC' THEN lRetVal = lRetVal + "PE|Plantilla|T01.jasper" + gcCRLF.
        IF zy-ccbcdocu.coddoc = 'BOL' THEN lRetVal = lRetVal + "PE|Plantilla|T03.jasper" + gcCRLF.
        IF zy-ccbcdocu.coddoc = 'TCK' THEN lRetVal = lRetVal + "PE|Plantilla|T03.jasper" + gcCRLF.
        IF zy-ccbcdocu.coddoc = 'N/C' THEN lRetVal = lRetVal + "PE|Plantilla|T07.jasper" + gcCRLF.
        IF zy-ccbcdocu.coddoc = 'N/D' THEN lRetVal = lRetVal + "PE|Plantilla|T08.jasper" + gcCRLF.
    END.
    ELSE DO:
        lRetVal = lRetVal + "PE|Plantilla|T01ch.jasper" + gcCRLF.
    END.
    

    /* PAGO */
    lRetVal = lRetVal + fget-como-pago(pTipoDoc, pNroDoc, pCodDiv).
    /* */
    lRetVal = lRetVal + "PES|MensajesAt" + gcCRLF.
    lRetVal = lRetVal + "PESD|1|GRACIAS POR SU COMPRA"  + gcCRLF.
    lRetVal = lRetVal + "PESD|2|STANDFORD - CONTI"  + gcCRLF.
    lRetVal = lRetVal + "PESD|3|EN EL PERU"  + gcCRLF.

    lRetVal = lRetVal + "PE|" +
        "URL|" +
        fget-utf-8(cURLDocumento) +
        gcCRLF.

    RELEASE zy-ccbcdocu.
    */
    
    RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-prefijo-serie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-prefijo-serie Procedure 
FUNCTION fget-prefijo-serie RETURNS CHARACTER
  (INPUT pTipoDoc AS CHAR, INPUT pSerieDoc AS INT,  INPUT pNroDoc AS INT, INPUT pDivision AS CHAR) :

    /* 
        pDivision : Puede ser vacio 
        Por ahora solo retorna T para guia de remision electronica
    */

    DEFINE VAR lxRet AS CHAR.

    lxRet = 'T'.

  RETURN lxRet.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-producto-sunat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-producto-sunat Procedure 
FUNCTION fget-producto-sunat RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR x-retval AS CHAR INIT "".

    RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-tipo-documento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-tipo-documento Procedure 
FUNCTION fget-tipo-documento RETURNS CHARACTER
  ( INPUT pTipoDocumento AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS CHAR.

lRetVal = "-99".

CASE pTipoDocumento:
    WHEN 'FAC' THEN DO:
        lRetVal = "01".
    END.
    WHEN 'BOL' OR WHEN 'TCK' THEN DO:
        lRetVal = "03".
    END.            
    WHEN 'N/D' THEN do:
        lRetVal = "08".
    END.            
    WHEN 'N/C' THEN DO:
        lRetVal = "07".
    END.
END.

RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-unidad-medida) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-unidad-medida Procedure 
FUNCTION fget-unidad-medida RETURNS CHARACTER
  ( INPUT pUM AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lRetVal AS CHAR.
    lRetval = "ST".

    FIND FIRST unidades WHERE unidades.codunid = pUM NO-LOCK NO-ERROR.
    IF AVAILABLE unidades THEN DO:
        IF unidades.codsunat <> ? AND unidades.codsunat <> '' THEN DO:
            lRetVal = TRIM(unidades.codsunat).
        END.
    END.

    RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
lRetVal = REPLACE(x-debedecir,"´","'").
lRetVal = REPLACE(x-debedecir,"á","a").
lRetVal = REPLACE(x-debedecir,"é","e").
lRetVal = REPLACE(x-debedecir,"í","i").
lRetVal = REPLACE(x-debedecir,"ó","o").
lRetVal = REPLACE(x-debedecir,"ú","u").
lRetVal = REPLACE(x-debedecir,"Á","A").
lRetVal = REPLACE(x-debedecir,"É","E").
lRetVal = REPLACE(x-debedecir,"Í","I").
lRetVal = REPLACE(x-debedecir,"Ó","O").
lRetVal = REPLACE(x-debedecir,"Ú","U").
lRetVal = REPLACE(x-debedecir,"ü","u").
lRetVal = REPLACE(x-debedecir,"Ü","U").
lRetVal = REPLACE(x-debedecir,"ü","u").
lRetVal = REPLACE(x-debedecir,"º"," ").
lRetVal = REPLACE(x-debedecir,"´","'").
lRetVal = REPLACE(x-debedecir,"Ø"," ").
lRetVal = REPLACE(x-debedecir,"º"," ").
lRetVal = REPLACE(x-debedecir,"ª"," ").
lRetVal = REPLACE(x-debedecir,"º"," ").
lRetVal = REPLACE(x-debedecir,"º"," ").

RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fGetTipoOperacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fGetTipoOperacion Procedure 
FUNCTION fGetTipoOperacion RETURNS CHARACTER
  (INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE BUFFER xy-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER xy-gn-clie FOR gn-clie.

DEFINE VAR x-retval AS CHAR.

x-retval = "".

FIND FIRST xy-ccbcdocu WHERE xy-ccbcdocu.codcia = s-codcia AND 
                                xy-ccbcdocu.coddoc = pCodDoc AND 
                                xy-ccbcdocu.nrodoc = pNroDoc 
                                NO-LOCK NO-ERROR.
IF AVAILABLE xy-ccbcdocu THEN DO:
    /* Segun la contadora Maria Bernal, correo del dia 15Jun2018 */
    IF pCodDoc = 'FAC' OR pCodDoc = 'BOL' THEN DO:
        x-retval = '0101'.
    END.
    /* exportacion de bienes: ventas al extranjero */

    
    /* Ventas no domiciliados */
    FIND FIRST xy-gn-clie WHERE xy-gn-clie.codcia = s-codcia AND 
                                    xy-gn-clie.codcli = xy-ccbcdocu.codcli
                                    NO-LOCK NO-ERROR.
    IF AVAILABLE xy-gn-clie AND xy-gn-clie.libre_c01 = 'E' THEN x-retval = '0401'.  /*03'.*/
    /* Facturas x anticipos */
    /*IF xy-ccbcdocu.tpofac = 'A' THEN x-retval = '04'.*/
    /* Venta itinerante */
    /*IF xy-ccbcdocu.coddiv = '00515' THEN x-retval = '05'.*/
END.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/*
Maria Bernal
        
15 jun. (hace 3 días)
        
Sr. César:

De acuerdo a la consulta con SUNAT sobre este tema, tenemos lo siguiente:

- Para Tipo de Operación:

01, venta interna:  para ventas dentro del país, sean al credito o contado.
02, exportacion de bienes: ventas al extranjero.
03, no domiciliados, cuando le vendamos a un extranjero, con FT o BV.
04, venta interna-anticipos, cuando la factura sea por anticipos.
05, venta itinerante, cuando vendamos en algun evento especial, en un espacio que no corresponda a las instalaciones de donde sale la mercadería.
El resto de códigos no aplica para Continental SAC.

- Para Codigo del establecimiento anexo:

Nos corresponde asignar el código del establecimiento dónde se entrega el bien Y/O se paga , cualquiera de los 2 es válido. No afecta si la venta es al crédito, pues en ese caso, el código del establecimiento se tomará de donde sale la mercadería.

Slds.
María.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-flog-envio-xml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION flog-envio-xml Procedure 
FUNCTION flog-envio-xml RETURNS CHARACTER
  (INPUT pTexto AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE BUFFER x-factabla FOR factabla.

/* IP de la PC */
DEFINE VAR x-ip AS CHAR.
DEFINE VAR x-pc AS CHAR.

RUN lib/_get_ip.r(OUTPUT x-pc, OUTPUT x-ip).

/* ---- */
DEFINE VAR lClientComputerName  AS CHAR.
DEFINE VAR lClientName          AS CHAR.
DEFINE VAR lComputerName        AS CHAR.

DEFINE VAR lPCName AS CHAR.
 
lClientComputerName = OS-GETENV ( "CLIENTCOMPUTERNAME"). 
lClientName         = OS-GETENV ( "CLIENTNAME").
lComputerName       = OS-GETENV ( "COMPUTERNAME").

lPcName = IF (lClientComputerName = ? OR lClientComputerName = "") THEN lClientName ELSE lClientComputerName.
lPCName = IF (CAPS(lPCName) = "CONSOLE") THEN "" ELSE lPCName.
lPCName = IF (lPCName = ? OR lPCName = "") THEN lComputerName ELSE lPCName.
/* ------ */

FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia 
                            and x-factabla.tabla = 'TXTLOGEPOS'
                            and x-factabla.codigo = 'ALL'
                            NO-LOCK NO-ERROR.

IF AVAILABLE x-factabla AND x-factabla.campo-l[1] = YES THEN DO:
    DEFINE VAR x-archivo AS CHAR.
    DEFINE VAR x-file AS CHAR.
    DEFINE VAR x-linea AS CHAR.

    x-file = STRING(TODAY,"99/99/9999").
    /*x-file = x-file + "-" + STRING(TIME,"HH:MM:SS").*/

    x-file = REPLACE(x-file,"/","").
    x-file = REPLACE(x-file,":","").

    x-archivo = session:TEMP-DIRECTORY + "LOG-GRE-ENVIO-SUNAT-" + x-file + ".txt".

    OUTPUT STREAM log-epos TO VALUE(x-archivo) APPEND.

    x-linea = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"hh:mm:ss") + " (" + lPCName + "-" + x-pc + ":" + x-ip + ") - " + TRIM(pTexto).

    PUT STREAM log-epos x-linea FORMAT 'x(300)' SKIP.

    OUTPUT STREAM LOG-epos CLOSE.
END.


RETURN "".  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-flog-epos-txt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION flog-epos-txt Procedure 
FUNCTION flog-epos-txt RETURNS CHARACTER
  (INPUT pTexto AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

/*
DEFINE BUFFER x-factabla FOR factabla.

/* IP de la PC */
DEFINE VAR x-ip AS CHAR.
DEFINE VAR x-pc AS CHAR.

RUN lib/_get_ip.r(OUTPUT x-pc, OUTPUT x-ip).

/* ---- */
DEFINE VAR lClientComputerName  AS CHAR.
DEFINE VAR lClientName          AS CHAR.
DEFINE VAR lComputerName        AS CHAR.

DEFINE VAR lPCName AS CHAR.

lClientComputerName = OS-GETENV ( "CLIENTCOMPUTERNAME").
lClientName         = OS-GETENV ( "CLIENTNAME").
lComputerName       = OS-GETENV ( "COMPUTERNAME").

lPcName = IF (lClientComputerName = ? OR lClientComputerName = "") THEN lClientName ELSE lClientComputerName.
lPCName = IF (CAPS(lPCName) = "CONSOLE") THEN "" ELSE lPCName.
lPCName = IF (lPCName = ? OR lPCName = "") THEN lComputerName ELSE lPCName.
/* ------ */

FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia 
                            and x-factabla.tabla = 'TXTLOGEPOS'
                            and x-factabla.codigo = 'ALL'
                            NO-LOCK NO-ERROR.

IF AVAILABLE x-factabla AND x-factabla.campo-l[1] = YES THEN DO:
    DEFINE VAR x-archivo AS CHAR.
    DEFINE VAR x-file AS CHAR.
    DEFINE VAR x-linea AS CHAR.

    x-file = STRING(TODAY,"99/99/9999").
    /*x-file = x-file + "-" + STRING(TIME,"HH:MM:SS").*/

    x-file = REPLACE(x-file,"/","").
    x-file = REPLACE(x-file,":","").

    x-archivo = session:TEMP-DIRECTORY + "conect-epos-" + x-file + ".txt".

    /*MESSAGE x-archivo.*/

    OUTPUT STREAM log-epos TO VALUE(x-archivo) APPEND.

    x-linea = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"hh:mm:ss") + " (" + lPCName + "-" + x-pc + ":" + x-ip + ") - " + TRIM(pTexto).

    PUT STREAM log-epos x-linea FORMAT 'x(300)' SKIP.

    OUTPUT STREAM LOG-epos CLOSE.
END.
*/

RETURN "".  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fset-placa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fset-placa Procedure 
FUNCTION fset-placa RETURNS CHARACTER
  ( INPUT pDato AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS CHAR.
  DEFINE VAR x-dato AS CHAR.

  x-retval = pDato.

  x-retval = replace(x-retval,"-","").
  x-retval = replace(x-retval," ","").

  RETURN x-retval.   /* Function return value. */

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
/*
  DEFINE VAR xUserId AS CHAR.

  xUserid = CAPS(USERID("integral")).

  IF (xUserId = 'ADMIN' OR xUserId = 'MASTER') AND mShowMsg = YES THEN DO:
        MESSAGE pMsg.
  END.
*/

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

