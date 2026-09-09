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
    Si pOtros = "XML", solo genera XML nada mas a documentos electronicos.
    Si pOtros = "CONTINGENCIA", documentos de contigencia.
    Si pOtros = "XMLCONTINGENCIA", solo genera XML nada mas a documentos de contigencia.
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
cPathTemporal = "\\192.168.100.217\newsie\FE_BORRAR".

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

DEFINE VAR cURL_wdsl_SUNAT AS CHAR.

cURL_wdsl_SUNAT = "https://www.sunat.gob.pe:443/ol-it-wsconscpegem/billConsultService?wsdl".

DEFINE STREAM sFileTxt.
define stream log-epos.     /* Trama del ePOS */
DEFINE VAR mShowMsg AS LOG INIT NO.

DEFINE VAR cDATAQR AS CHAR INIT "".

/* Totales */
DEFINE VAR x-vvta-gravada AS DEC INIT 0.
DEFINE VAR x-vvta-inafectas AS DEC INIT 0.
DEFINE VAR x-vvta-exoneradas AS DEC INIT 0.
DEFINE VAR x-vvta-gratuitas AS DEC INIT 0.
DEFINE VAR x-total-anticipos AS DEC INIT 0.
DEFINE VAR x-total-igv AS DEC INIT 0.               /* Total Impuestos */
DEFINE VAR x-total-igv2 AS DEC INIT 0.              /* IGV */
DEFINE VAR x-imp-total AS DEC INIT 0.
DEFINE VAR x-imp-isc AS DEC INIT 0.
DEFINE VAR x-total-otros-tributos AS DEC INIT 0.    /* BOLSAS PLASTICAS */
DEFINE VAR x-monto-base-dscto-global-anticipo AS DEC.
DEFINE VAR x-total-dscto-globales-anticipo AS DEC.
DEFINE VAR x-porcentaje-dscto-global-anticipo AS DEC.

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
/*MESSAGE pOtros.*/
IF pOtros = "XMLTEST" THEN DO:
    x-enviar-servidor-prueba = YES.
END.

/* Impuesto a la bolsas plasticas */
DEFINE VAR x-articulo-ICBPER AS CHAR.
DEFINE VAR x-linea-bolsas-plastica AS CHAR.

x-articulo-ICBPER = "099268".
x-linea-bolsas-plastica = "086".

/* ICBPER */
DEFINE VAR x-enviar-icbper AS LOG.
x-enviar-icbper = YES.   

/*  */
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.
DEFINE BUFFER x-ccbddocu FOR ccbddocu.
DEFINE BUFFER x-factabla FOR factabla.
DEFINE BUFFER z-factabla FOR factabla.

/* Para verificar los ANTICIPOS de CAMPAÑA (A/C) */
DEFINE BUFFER x-ccbdcaja FOR ccbdcaja.
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.

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

DEFINE VAR x-totalVenta AS DEC.
DEFINE VAR x-totalValorVenta AS DEC.
DEFINE VAR x-totalPrecioVenta AS DEC.
DEFINE VAR x-sumatoria-montobaseigv AS DEC.

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
  (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR)  FORWARD.

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
         HEIGHT             = 23.12
         WIDTH              = 80.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = s-codcia AND 
                            FELogComprobantes.coddiv = pCodDiv AND
                            FELogComprobantes.coddoc = pTipoDocmto AND 
                            FELogComprobantes.nrodoc = pNroDocmto NO-LOCK NO-ERROR.

IF x-enviar-servidor-prueba = NO THEN DO:
    IF AVAILABLE FELogComprobantes THEN DO:
        IF x-generar-solo-xml = NO THEN DO:
            pReturn = "666|Documento ya esta PROCESADO en FELogComprobantes (Div:" + pCodDiv + 
                                                ", TDoc : " + pTipoDocmto + ", NroDoc : " + pNroDocmto + ")".
            RETURN "ADM-ERROR".
        END.
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

/* Detalle */
FIND FIRST b-ccbddocu OF b-ccbcdocu NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-ccbddocu THEN DO:
    pReturn = "005|Documento (" + pTipoDocmto + "-" + pNroDocmto + ") NO tiene detalle de articulos".
    RETURN "ADM-ERROR".
END.

/* Tipos de documentos validos */
IF LOOKUP(pTipoDocmto,"FAC,BOL,N/C,N/D") = 0 THEN DO:
    pReturn = "999|Tipo documento(" + pTipoDocmto + ") ERRADO".
    RETURN "ADM-ERROR".
END.

FIND FIRST gn-div OF b-ccbcdocu NO-LOCK NO-ERROR.
IF AVAILABLE gn-div THEN DO:
    fFechaInicioFE = gn-divi.libre_f01.
END.
IF fFechaInicioFE = ? THEN DO:
    pReturn = "664|La tienda no tiene configurado la fecha de inicio de facturacion electronica".
    RETURN "ADM-ERROR".
END.

/* Prefijo de la serie del documento electronico */
cSerieSunat = fGet-prefijo-serie(b-ccbcdocu.coddoc, b-ccbcdocu.nrodoc, b-ccbcdocu.coddiv).

IF (TRUE <> (cSerieSunat > "")) OR LOOKUP(cSerieSunat,"F,B") = 0 THEN DO:
    pReturn = "665|Imposible ubicar el Origen del Documento (" + pTipoDocmto + "-" + pNroDocmto + ")".
    RETURN "ADM-ERROR".
END.

IF x-documento-contingencia = YES THEN cSerieSunat = "0".

x-CodigoEstablecimiento = TRIM(gn-divi.campo-char[10]).
IF TRUE <> (x-CodigoEstablecimiento > "") THEN DO:
    pReturn = "665|La division (" + gn-divi.coddiv + ") no tiene asignado establecimiento".
    RETURN "ADM-ERROR".
END.

/* Notas de Credito y Debito */
x-doc-referencia = "".
IF pTipoDocmto = 'N/C' OR pTipoDocmto = 'N/D' THEN DO:
    x-doc-referencia = fget-doc-original(b-ccbcdocu.coddoc, b-ccbcdocu.nrodoc).
    IF (TRUE <> (x-doc-referencia > "")) THEN DO:
        pReturn = "669|Imposible ubicar el Origen del Documento".
        RETURN "ADM-ERROR".
    END.
    IF LOOKUP(SUBSTRING(x-doc-referencia,1,1),"F,B") = 0 THEN DO:
        pReturn = "669|El documento de referencia debe ser Factura ó Boleta".
        RETURN "ADM-ERROR".
    END.
END.

cSerieSunat = cSerieSunat  +  SUBSTRING(b-ccbcdocu.nrodoc,1,3).
cCorrelativoSunat   = SUBSTRING(b-ccbcdocu.nrodoc,4).

x-servidor-ip = "".
x-servidor-puerto = "".

/* Verificar la condicion de venta para la nuevas validaciones de SUNAT desde 04Abr2021 */
DEFINE VAR x-msg AS CHAR INIT "".
RUN validar-condicion-venta(OUTPUT x-msg).

IF x-msg <> "OK" THEN DO:
    pReturn = "669.A|" + x-msg.
    RETURN "ADM-ERROR".
END.

IF (b-ccbcdocu.coddoc = 'N/C' AND SUBSTRING(x-doc-referencia,1,1) = 'F') THEN DO:
    /* Es nota de Credito que hace referencia Factura */
    IF b-ccbcdocu.cndcre <> 'D' THEN DO:
        FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                    ccbtabla.tabla = 'N/C' AND 
                                    ccbtabla.codigo = b-ccbcdocu.codcta
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE ccbtabla THEN DO:
            IF ccbtabla.libre_c01 = "13" THEN DO:
                pReturn = "667|Nota de Credito ESPECIAL no implementado aun...".
                RETURN "ADM-ERROR".
            END.            
        END.
    END.
END.

DEFINE VAR x-config-servidor AS CHAR.

/*  */
x-config-servidor = "CONFIG-FE-BIZLINKS".
IF x-enviar-servidor-prueba THEN x-config-servidor = "CONFIG-FE-BIZTEST".

/* Servidor Webservice BIZLINKS */
FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                            factabla.tabla = x-config-servidor  /*"CONFIG-FE-BIZLINKS"*/ AND
                            factabla.codigo = gn-div.coddiv NO-LOCK NO-ERROR.

IF AVAILABLE factabla THEN DO:
    /* De la division */
    x-servidor-ip = TRIM(factabla.campo-c[1]).
    x-servidor-puerto = TRIM(factabla.campo-c[2]).
END.
FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                            factabla.tabla = x-config-servidor  /*"CONFIG-FE-BIZLINKS"*/ AND
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

/* Tipo documento SUNAT */
IF pTipoDocmto = 'FAC' THEN cTipoDoctoSunat     = '01'.
IF pTipoDocmto = 'BOL' THEN cTipoDoctoSunat     = '03'.
IF pTipoDocmto = 'N/C' THEN cTipoDoctoSunat     = '07'.
IF pTipoDocmto = 'N/D' THEN cTipoDoctoSunat     = '08'. 

x-tipo-docmnto-sunat = cTipoDoctoSunat.

/* Construyo el XML */
x-XML-documento = "".
x-XML-detalle = "".
x-XML-cabecera = "".
x-XML-adicionales = "".
x-XML-anticipos = "".
x-es-anticipo-de-campana = NO.

/* ---------------------------------------------------------------------------- */
/*      PLAN B */
/* ---------------------------------------------------------------------------- */

IF CAPS(USERID("DICTDB")) = "ADMIN" OR CAPS(USERID("DICTDB")) = "MASTER" THEN DO:
    /**/
END.
ELSE DO:
    FIND FIRST z-factabla WHERE z-factabla.codcia = s-codcia AND
                                z-factabla.tabla = "CONTINGENCIA" AND
                                z-factabla.codigo = "PLAN-B" NO-LOCK NO-ERROR.
    IF AVAILABLE z-factabla AND z-factabla.campo-c[1] = "SI" THEN DO:    
        pReturn = "PLAN-B".
        RETURN.
    END. 
END.

/**/
x-totalVenta = 0.
x-totalValorVenta = 0.
x-totalPrecioVenta = 0.
x-sumatoria-montobaseigv = 0.

/* DEtalle */
RUN generar-xml-detail(OUTPUT x-xml-detalle).

/* b-ccbcdocu.acubon[10] = total monto ICBPER */
x-totalPrecioVenta = x-totalValorVenta + b-ccbcdocu.acubon[10] + ROUND((x-sumatoria-montobaseigv * (b-ccbcdocu.porigv / 100)) , 2).
/*x-totalPrecioVenta = ROUND(x-totalPrecioVenta * (b-ccbcdocu.porigv / 100) , 2).*/

IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    pReturn = "999|ERROR al generar el XML del detalle".
    RETURN "ADM-ERROR".
END.
/* *************************************************** */

/* XML cabecera */
RUN generar-xml-header(OUTPUT x-XML-cabecera).

IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    pReturn = "999|ERROR al generar el XML de la cabecera".
    RETURN "ADM-ERROR".
END.

IF pTipoDocmto = 'FAC' THEN RUN factura-electronica(OUTPUT x-XML-adicionales).
IF pTipoDocmto = 'BOL' THEN RUN boleta-electronica(OUTPUT x-XML-adicionales).
IF pTipoDocmto = 'N/C' THEN RUN nota-credito-electronica(OUTPUT x-XML-adicionales).
IF pTipoDocmto = 'N/D' THEN RUN nota-debito-electronica(OUTPUT x-XML-adicionales).

IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    pReturn = "999|ERROR al generar el XML de los adicionales".
    RETURN "ADM-ERROR".
END.

/* DEtalle */
/*
RUN generar-xml-detail(OUTPUT x-xml-detalle).

IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    pReturn = "999|ERROR al generar el XML del detalle".
    RETURN "ADM-ERROR".
END.
*/

/* Envio a SUNAT */
DEFINE VAR x-retval AS CHAR INIT "".
DEFINE VAR x-data-QR AS CHAR.
DEFINE VAR x-emision AS CHAR.
DEFINE VAR x-DLL-PLAN AS CHAR INIT "NO".

IF CAPS(USERID("DICTDB")) = "ADMIN" OR CAPS(USERID("DICTDB")) = "MASTER" THEN DO:
    FIND FIRST z-factabla WHERE z-factabla.codcia = s-codcia AND
                                z-factabla.tabla = "CONTINGENCIA" AND
                                z-factabla.codigo = "BIZLINKS-DLL" NO-LOCK NO-ERROR.
    IF AVAILABLE z-factabla AND z-factabla.campo-c[1] = "SI" THEN DO:    
        x-DLL-PLAN = "SI".
    END. 
END.

/* Siempre en NO, solo para sistemas en modo desarrollo se puede usar en SI */
x-DLL-PLAN = "NO".      

/**************************************************************/

IF x-DLL-PLAN = "SI" THEN DO:
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
END.

IF x-DLL-PLAN = "NO" THEN DO:
    /* Envia el XML a BizLinks */
    RUN enviar-xml(OUTPUT x-retval).
END.

x-emision = SUBSTRING(STRING(b-ccbcdocu.fchdoc,"99-99-9999"),7,4) + "-".
x-emision = x-emision + SUBSTRING(STRING(b-ccbcdocu.fchdoc,"99-99-9999"),4,2) + "-" .
x-emision = x-emision + SUBSTRING(STRING(b-ccbcdocu.fchdoc,"99-99-9999"),1,2).

IF x-retval = "OK" THEN DO:
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
        pReturn = "999|Imposible enviar el XML (v1) : " + x-retval.
    END.
    
END.

    /* Para la trazabilidad - resumen de comprobantes x linea + sublinea */    
    DEFINE TEMP-TABLE tw-report LIKE w-report.
    DEFINE VAR y-msg AS CHAR.

    DEFINE VAR xhProc AS HANDLE NO-UNDO.             /* Handle Libreria */

    RUN gn\master-library.r PERSISTENT SET xhProc.

    RUN VTA_cmpte_linea IN xhProc (INPUT pTipoDocmto, INPUT pNroDocmto, 
                                  OUTPUT TABLE tw-report, INPUT YES, OUTPUT y-msg).

    DELETE PROCEDURE xhProc.                 /* Release Libreria */


RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-boleta-electronica) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE boleta-electronica Procedure 
PROCEDURE boleta-electronica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-xml-boleta AS LONGCHAR.

DEFINE VAR x-enviar-guia-remision AS LOG.

p-xml-boleta = "". 

/* Orden de Compra */
IF b-ccbcdocu.nroord <> ? AND  b-ccbcdocu.nroord <> "" THEN DO:
    p-xml-boleta = p-xml-boleta + "<ordenCompra>" + b-ccbcdocu.nroord + "</ordenCompra>".
END.

/* ********************************************************************************************** */
/* RHC 22/05/2019 NO se envía el detalle de las G/R */
/* Ic 19Jun2019, pedido de MAX RAMOS esas divisiones si deben llevar G/R  */
/* ********************************************************************************************** */
/*
IF LOOKUP(b-ccbcdocu.divori,"00024,00030,00070") = 0 THEN DO:
    RETURN 'OK'.
END.
*/

x-enviar-guia-remision = NO.
RUN enviar-guia-remision(INPUT b-ccbcdocu.divori, OUTPUT x-enviar-guia-remision).
IF x-enviar-guia-remision = NO THEN DO:
    RETURN 'OK'.
END.

/* ********************************************************************************************** */

/* GUIA REMISION */   
DEFINE VAR lGuiaRemision AS CHAR.
DEFINE VAR x-sec AS INT INIT 0.

DEFINE BUFFER bx-ccbcdocu FOR ccbcdocu.
FOR EACH bx-ccbcdocu WHERE bx-ccbcdocu.codcia = s-codcia AND
                            bx-ccbcdocu.coddoc = 'G/R' AND
                            bx-ccbcdocu.codref = b-ccbcdocu.coddoc AND 
                            bx-ccbcdocu.nroref = b-ccbcdocu.nrodoc
                            NO-LOCK :

    lGuiaRemision = IF(bx-ccbcdocu.nrodoc = ?) THEN "" ELSE TRIM(bx-ccbcdocu.nrodoc). 

    IF lGuiaRemision <> "" THEN DO:
        x-sec = x-sec + 1.
        IF x-sec <= 5 THEN DO:
            lGuiaRemision = "0" + SUBSTRING(bx-ccbcdocu.nrodoc,1,3) + "-" + 
                            SUBSTRING(bx-ccbcdocu.nrodoc,4) NO-ERROR.
            p-xml-boleta = p-xml-boleta + "<tipoReferencia_" + STRING(x-sec) + ">09</tipoReferencia_" + STRING(x-sec) + ">".
            p-xml-boleta = p-xml-boleta + "<numeroDocumentoReferencia_" + STRING(x-sec) + ">" + lGuiaRemision + "</numeroDocumentoReferencia_" + STRING(x-sec) + ">".
        END.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enviar-guia-remision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-guia-remision Procedure 
PROCEDURE enviar-guia-remision :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ********************************************************************************************** */
/* RHC 22/05/2019 NO se envía el detalle de las G/R */
/* Ic 19Jun2019, pedido de MAX RAMOS esas divisiones si deben llevar G/R  */
/* ********************************************************************************************** */
DEFINE INPUT PARAMETER pDivision AS CHAR.
DEFINE OUTPUT PARAMETER x-enviar-guia-remision AS LOG.


RUN sunat/p-consignar-guia-de-remision.r(INPUT pDivision, OUTPUT x-enviar-guia-remision).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

p-msg = "OK".

/* Uno los XMLs */
x-XML-documento = "<documentHeader>".
x-XML-documento = x-XML-documento + x-XML-cabecera + x-XML-adicionales + x-XML-detalle + x-XML-factoring + x-XML-anticipos.
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
DEFINE VAR x-log-envio AS CHAR.

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

/* ????????????????????????????????????????????? */
/* cRucEmpresa = '20511358907'.    R.U.C. - StandFord */
x-log-envio = flog-envio-xml("/* ---------------------------------------------------------------------------------- */").
x-log-envio = flog-envio-xml("     0.- COMPROBANTE : " + cTipoDoctoSunat + " " + cSerieSunat + "-" + cCorrelativoSunat).
x-log-envio = flog-envio-xml("/* ---------------------------------------------------------------------------------- */").

x-url-webservice = "http://" + x-servidor-ip + ":" + x-servidor-puerto + "/einvoice/rest/" +
                    "6/" + cRucEmpresa + "/" + cTipoDoctoSunat + "/" + cSerieSunat + "-" + cCorrelativoSunat.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.
CREATE "MSXML2.DOMDocument.6.0" x-oXMLBody.

x-loadXML = x-oXMLBody:loadXML(x-XML-documento) NO-ERROR. 

IF NOT x-loadXML THEN DO:    

    p-msg = "ERROR en loadXML : "  + gcCRLF + x-oXMLBody:parseError:reason.    

    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RELEASE OBJECT x-oXMLBody NO-ERROR.

    x-log-envio = flog-envio-xml("1.- " + p-msg).

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

    RETURN "ADM-ERROR".
END.

IF x-oXmlHttp:STATUS <> 200 THEN DO:
    p-msg = "ERROR en SEND (Err:200) : " + gcCRLF + x-oXmlHttp:responseText. 

    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RELEASE OBJECT x-oXMLBody NO-ERROR.

    x-log-envio = flog-envio-xml("3.- (Err:200) " + p-msg).

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
x-log-envio = flog-envio-xml("4.- X-RSPTA :" + x-rspta).

IF NOT (TRUE <> (x-status > "")) THEN DO:

    x-log-envio = flog-envio-xml("5.- X-STATUS :" + x-status).

    IF CAPS(x-status) = "DUPLICATED" OR CAPS(x-status) = "SIGNED" OR  CAPS(x-status) = "IN PROCESS" THEN DO:
        /* PROCESO OK */
        IF CAPS(x-status) = "SIGNED" THEN DO:
            x-xml-hashcode = x-hashcode.
            p-msg = "OK".
        END.
        ELSE DO:
            p-msg = "El documento esta " + x-status.            
        END.
        x-log-envio = flog-envio-xml("6.- " + p-msg).
    END.
    ELSE DO:
        x-oMsg = x-oRspta:selectSingleNode( "//message" ). 
        x-codestatus = x-oMsg:TEXT NO-ERROR.       

        x-log-envio = flog-envio-xml("7.- X-MSG-ERROR :" + x-codestatus).

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

        x-log-envio = flog-envio-xml("8.- MENSAJE-DETALLE :" + x-codestatus).

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

&IF DEFINED(EXCLUDE-factura-electronica) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE factura-electronica Procedure 
PROCEDURE factura-electronica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-xml-factura AS LONGCHAR.

DEFINE VAR x-enviar-guia-remision AS LOG.

p-xml-factura = "".

/* Orden de Compra */
IF b-ccbcdocu.nroord <> ? AND  b-ccbcdocu.nroord <> "" THEN DO:
    p-xml-factura = p-xml-factura + "<ordenCompra>" + b-ccbcdocu.nroord + "</ordenCompra>".
END.

/* ********************************************************************************************** */
/* RHC 22/05/2019 NO se envía el detalle de las G/R */
/* Ic 19Jun2019, pedido de MAX RAMOS esas divisiones si deben llevar G/R  */
/* ********************************************************************************************** */

x-enviar-guia-remision = NO.
RUN enviar-guia-remision(INPUT b-ccbcdocu.divori, OUTPUT x-enviar-guia-remision).
IF x-enviar-guia-remision = NO THEN DO:
    RETURN 'OK'.
END.
/*
IF LOOKUP(b-ccbcdocu.divori,"00024,00030,00070") = 0 THEN DO:
    RETURN 'OK'.
END.
*/

/* ********************************************************************************************** */

/* GUIA REMISION */
DEFINE VAR lGuiaRemision AS CHAR.
DEFINE VAR x-sec AS INT INIT 0.

DEFINE BUFFER bx-ccbcdocu FOR ccbcdocu.
FOR EACH bx-ccbcdocu WHERE bx-ccbcdocu.codcia = s-codcia AND
                            bx-ccbcdocu.coddoc = 'G/R' AND
                            bx-ccbcdocu.codref = b-ccbcdocu.coddoc AND 
                            bx-ccbcdocu.nroref = b-ccbcdocu.nrodoc
                            NO-LOCK :

    lGuiaRemision = IF(bx-ccbcdocu.nrodoc = ?) THEN "" ELSE TRIM(bx-ccbcdocu.nrodoc). 

    IF lGuiaRemision <> "" THEN DO:
        x-sec = x-sec + 1.
        IF x-sec <= 5 THEN DO:
            /* Bizlinks, solo tiene 5 referencias como maximo */
            lGuiaRemision = "0" + SUBSTRING(bx-ccbcdocu.nrodoc,1,3) + "-" + 
                            SUBSTRING(bx-ccbcdocu.nrodoc,4) NO-ERROR.
            p-xml-factura = p-xml-factura + "<tipoReferencia_" + STRING(x-sec) + ">09</tipoReferencia_" + STRING(x-sec) + ">".
            p-xml-factura = p-xml-factura + "<numeroDocumentoReferencia_" + STRING(x-sec) + ">" + lGuiaRemision + "</numeroDocumentoReferencia_" + STRING(x-sec)  + ">".
        END.
    END.
END.

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generar-file-contingencia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-file-contingencia Procedure 
PROCEDURE generar-file-contingencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTipoDocmto AS CHAR.
DEFINE INPUT PARAMETER pNroDocmto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE INPUT PARAMETER pRutaContingencia AS CHAR.
DEFINE OUTPUT PARAMETER pReturn AS CHAR NO-UNDO.

x-ruta-file-contingencia = pRutaContingencia.

/* Generacion del DOCUMENTO */
CASE pTipoDocmto:
    WHEN 'FAC'  THEN DO:
        /* Facturas */        
        RUN fac-generar-txt(INPUT pTipoDocmto, INPUT pNroDocmto, INPUT pCodDiv, OUTPUT pReturn).
    END.
    WHEN 'BOL' OR WHEN 'TCK' THEN DO:
        /* Boletas */
        RUN bol-generar-txt(INPUT pTipoDocmto, INPUT pNroDocmto, INPUT pCodDiv, OUTPUT pReturn).
    END.
    WHEN 'N/C' THEN DO:
        /* Notas de Credito */
        RUN nc-generar-txt(INPUT pTipoDocmto, INPUT pNroDocmto, INPUT pCodDiv, OUTPUT pReturn).
    END.
    WHEN 'N/D' THEN DO:
        /* Notas de Debito */
        RUN nd-generar-txt(INPUT pTipoDocmto, INPUT pNroDocmto, INPUT pCodDiv, OUTPUT pReturn).
    END.
END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generar-xml-anticipos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-xml-anticipos Procedure 
PROCEDURE generar-xml-anticipos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pCodMonDocDespacho AS INT.
DEFINE INPUT PARAMETER pTpoCmbDocDespacho AS DEC.
DEFINE OUTPUT PARAMETER pRetImpTot AS DEC.
DEFINE OUTPUT PARAMETER pRetImpVVTA AS DEC.
DEFINE OUTPUT PARAMETER pRetImpIGV AS DEC.
DEFINE OUTPUT PARAMETER pRetXML AS CHAR.

/* La factura del A/C */
DEFINE VAR x-monto-del-anticipo AS DEC.
DEFINE VAR x-vvta-del-anticipo AS DEC.
DEFINE VAR x-igv-del-anticipo AS DEC.

DEFINE VAR x-suma-de-anticipos AS DEC.
DEFINE VAR x-suma-vvta-de-anticipos AS DEC.
DEFINE VAR x-suma-igv-de-anticipos AS DEC.

DEFINE VAR x-anticipo AS CHAR.

pRetImpTot = 0.
pRetXML = "".
pRetImpVVTA = 0.
pRetImpIGV = 0.

x-anticipo = "".

IF (pCoddoc = 'FAC' OR pCoddoc = 'BOL') THEN DO:

    DEFINE VAR x-retval AS CHAR.
    DEFINE VAR x-sec AS INT.
    DEFINE VAR x-hProc AS HANDLE NO-UNDO.

    RUN gn/master-library.r PERSISTENT SET x-hProc.

    RUN anticipos-aplicados-despacho IN x-hProc (INPUT pCoddoc,
                                                 INPUT pNrodoc,
                                                 OUTPUT x-retval).    

    DELETE PROCEDURE x-hProc.

    REPEAT x-sec = 1 TO NUM-ENTRIES(x-retval,"*"):

        x-anticipo = ENTRY(x-sec,x-retval,"*").

        x-monto-del-anticipo = DECIMAL(TRIM(ENTRY(7,x-anticipo,"|"))).
        x-vvta-del-anticipo = DECIMAL(TRIM(ENTRY(9,x-anticipo,"|"))).
        x-igv-del-anticipo = DECIMAL(TRIM(ENTRY(10,x-anticipo,"|"))).

        x-suma-de-anticipos = x-suma-de-anticipos + x-monto-del-anticipo.
        x-suma-vvta-de-anticipos = x-suma-vvta-de-anticipos + x-vvta-del-anticipo.
        x-suma-igv-de-anticipos = x-suma-igv-de-anticipos + x-igv-del-anticipo.

        IF pRetXML = "" THEN DO :
            pRetXML = "<anticipo>".
        END.
        ELSE DO:
            pRetXML = pRetXML + "<anticipo>".
        END.
        pRetXML = pRetXML + fgenera-tag("indicador",TRIM(ENTRY(1,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("numeroOrdenAnticipo",TRIM(ENTRY(2,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("tipoDocumentoEmisorAnticipo",TRIM(ENTRY(3,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("numeroDocumentoEmisorAnticipo",TRIM(ENTRY(4,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("tipoDocumentoAnticipo",TRIM(ENTRY(5,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("serieNumeroDocumentoAnticipo",TRIM(ENTRY(6,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("totalPrepagadoAnticipo",TRIM(ENTRY(7,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("fechaPago",TRIM(ENTRY(8,x-anticipo,"|"))).

        pRetXML = pRetXML + "</anticipo>".

        x-es-anticipo-de-campana = YES.

    END.

END.

/* ------------------------------------------------------------ */
/*
/* Todas las A/C comprometidas en el comprobante electronico */
FOR EACH x-ccbdcaja WHERE x-ccbdcaja.codcia = s-codcia AND
                            x-ccbdcaja.codref = pCodDoc AND
                            x-ccbdcaja.nroref = pNroDoc AND
                            x-ccbdcaja.coddoc = 'A/C' NO-LOCK:

    /* Verificamos que la A/C no este anulado */
    FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                x-ccbcdocu.coddoc = x-ccbdcaja.coddoc AND
                                x-ccbcdocu.nrodoc = x-ccbdcaja.nrodoc AND 
                                x-ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.

    IF (AVAILABLE x-ccbcdocu) THEN DO:
        x-coddoc-ac = x-ccbcdocu.codref.
        x-nrodoc-ac = x-ccbcdocu.nroref.
        
        /* Ubicamos la factura del A/C */
        FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                    x-ccbcdocu.coddoc = x-coddoc-ac AND
                                    x-ccbcdocu.nrodoc = x-nrodoc-ac AND 
                                    x-ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
        IF (AVAILABLE x-ccbcdocu) AND x-ccbcdocu.imptot > 0 THEN DO:
            /* Montos usados del A/C para cancelar la el documento */
            x-monto-del-anticipo = x-ccbdcaja.imptot.
            x-vvta-del-anticipo = ROUND(x-monto-del-anticipo /  ( 1 + (x-ccbcdocu.porigv / 100)),2).
            x-igv-del-anticipo = x-monto-del-anticipo - x-vvta-del-anticipo.

            IF pCodMonDocDespacho <> x-ccbdcaja.codmon THEN DO:
                IF pCodMonDocDespacho = 2 THEN DO:
                    /* La factura del despacho esta en DOLARES y el anticipo en SOLES */
                    x-monto-del-anticipo = x-monto-del-anticipo / x-ccbdcaja.tpocmb.
                    x-vvta-del-anticipo = x-vvta-del-anticipo / x-ccbdcaja.tpocmb.
                    x-igv-del-anticipo = x-igv-del-anticipo / x-ccbdcaja.tpocmb.
                END.
                ELSE DO:
                    /* La factura del despacho esta SOLES y el anticipo en DOLARES */
                    x-monto-del-anticipo = x-monto-del-anticipo * x-ccbdcaja.tpocmb.
                    x-vvta-del-anticipo = x-vvta-del-anticipo * x-ccbdcaja.tpocmb.
                    x-igv-del-anticipo = x-igv-del-anticipo * x-ccbdcaja.tpocmb.
                END.
            END.
            x-suma-de-anticipos = x-suma-de-anticipos + x-monto-del-anticipo.
            x-suma-vvta-de-anticipos = x-suma-vvta-de-anticipos + x-vvta-del-anticipo.
            x-suma-igv-de-anticipos = x-suma-igv-de-anticipos + x-igv-del-anticipo.

            x-orden-anticipo = x-orden-anticipo + 1.

            IF pRetXML = "" THEN DO :
                pRetXML = "<anticipo>".
            END.
            ELSE DO:
                pRetXML = pRetXML + "<anticipo>".
            END.
            pRetXML = pRetXML + fgenera-tag("indicador","A").
            pRetXML = pRetXML + fgenera-tag("numeroOrdenAnticipo",STRING(x-orden-anticipo)).
            pRetXML = pRetXML + fgenera-tag("tipoDocumentoEmisorAnticipo","6").
            pRetXML = pRetXML + fgenera-tag("numeroDocumentoEmisorAnticipo",cRucEmpresa).
            /*pRetXML = pRetXML + fgenera-tag("tipoDocumentoAnticipo",fget-tipo-documento(x-ccbcdocu.coddoc)).*/
            pRetXML = pRetXML + fgenera-tag("tipoDocumentoAnticipo","02").

            x-serie-numero-anticipo = fget-prefijo-serie(x-ccbcdocu.coddoc,x-ccbcdocu.nrodoc,"") +
                                SUBSTRING(x-ccbcdocu.nrodoc,1,3) + "-" + SUBSTRING(x-ccbcdocu.nrodoc,4).

            x-fecha-pago = STRING(YEAR(x-ccbdcaja.fchdoc),"9999") + "-" + STRING(MONTH(x-ccbdcaja.fchdoc),"99") + "-" + STRING(DAY(x-ccbdcaja.fchdoc),"99").

            pRetXML = pRetXML + fgenera-tag("serieNumeroDocumentoAnticipo",x-serie-numero-anticipo).
            pRetXML = pRetXML + fgenera-tag("totalPrepagadoAnticipo",STRING(x-monto-del-anticipo,">>>>>>>9.99")).
            pRetXML = pRetXML + fgenera-tag("fechaPago",x-fecha-pago).

            pRetXML = pRetXML + "</anticipo>".

            x-es-anticipo-de-campana = YES.
        END.
    END.
END.
*/

IF x-suma-de-anticipos <= 0 THEN DO:
    x-suma-de-anticipos = 0.
    x-suma-vvta-de-anticipos = 0.
    x-suma-igv-de-anticipos = 0.
    pRetXML = "".
END.

pRetImpTot = x-suma-de-anticipos.
pRetImpVVTA = x-suma-vvta-de-anticipos.
pRetImpIgv = x-suma-igv-de-anticipos.

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

DEFINE VAR x-item AS INT INIT 0.    
DEFINE VAR x-unitario-sin-impuesto AS DEC INIT 0.
DEFINE VAR x-unitario-con-impuesto AS DEC INIT 0.
DEFINE VAR x-importe-igv AS DEC INIT 0.
DEFINE VAR x-monto-base-igv AS DEC INIT 0.
DEFINE VAR x-importe-sin-impuesto AS DEC INIT 0.
DEFINE VAR x-importe-con-impuesto AS DEC INIT 0.
DEFINE VAR x-importe-descuento AS DEC INIT 0.
DEFINE VAR x-importe-base-descuento AS DEC INIT 0.
DEFINE VAR x-factor-descuento AS DEC INIT 0.
DEFINE VAR x-base-IMPDTO AS DEC INIT 0.
DEFINE VAR x-base-IMPDTO2 AS DEC INIT 0.
DEFINE VAR x-igv-impdto2 AS DEC INIT 0.

DEFINE VAR x-tasa-igv AS DEC INIT 0.
DEFINE VAR x-codigo-razon-exoneracion AS CHAR.
DEFINE VAR x-codigo-importe-referencial AS CHAR.
DEFINE VAR x-codigo-importe-unitario-con-igv AS CHAR.
DEFINE VAR x-importe-referencial AS DEC.

DEFINE VAR x-existe-icbper AS LOG.
DEFINE VAR x-codfam-icbper AS CHAR.

DEFINE VAR x-implin AS DEC.

DEFINE VAR x-XMLicbper AS CHAR.

pXML-DETAIL = "".

x-existe-icbper = NO.
x-codfam-icbper = "".
    
FOR EACH b-ccbddocu OF b-ccbcdocu NO-LOCK BY b-ccbddocu.nroitm :
    FIND FIRST almmmatg OF b-ccbddocu NO-LOCK NO-ERROR.

    /* Ic - 09Mar2020 - no enviar el IMPSTO */
    IF x-enviar-icbper = YES THEN DO:
        IF b-ccbddocu.codmat = x-articulo-ICBPER THEN DO:
            x-codfam-icbper = almmmatg.codfam.
            x-existe-icbper = YES.
            NEXT.
        END.        
    END.

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

    x-unitario-sin-impuesto = 0.    /* importeUnitarioSinImpuesto */
    x-unitario-con-impuesto = 0.    /* importeUnitarioConImpuesto */
    x-importe-igv = 0.              /* importeIgv , importeTotalImpuestos */

    x-monto-base-igv = 0.           /* montoBaseIgv*/

    x-importe-sin-impuesto = 0.     /* importeTotalSinImpuesto */
    x-importe-con-impuesto = 0.     /* importeBaseDescuento */
    x-importe-descuento = 0.        /* importeDescuento */
    x-importe-base-descuento = 0.
    x-factor-descuento = 0.
    x-base-IMPDTO2 = 0.
    x-base-IMPDTO = 0.
    x-tasa-igv = 0.                             /* tasaIgv */
    x-codigo-razon-exoneracion = "".            /* codigoRazonExoneracion */
    x-codigo-importe-referencial = "".
    x-codigo-importe-unitario-con-igv = "".     /*codigoImporteUnitarioConImpuesto*/
    x-importe-referencial = 0.
    
    IF (b-ccbddocu.implin <= 0.0050) OR (b-ccbddocu.preuni <= 0.0050) THEN DO:        
        /* Bonificaciones (Precio Unitario es menor igual <= 0.0050) */
        IF LOOKUP(b-ccbcdocu.fmapgo, '899,900') > 0 THEN DO:
            x-importe-igv = 0.01.
            x-tasa-igv = b-ccbcdocu.porigv.
            /* total = (1.18 * 0.01) / 0.18 */
            x-importe-con-impuesto = (( 1 + (b-ccbcdocu.porigv / 100)) * x-importe-igv ) / (b-ccbcdocu.porigv / 100).

            /* AQUI SI TIENE VALOR MAYOR A CERO*/
            x-monto-base-igv = x-importe-con-impuesto - x-importe-igv.

            x-importe-sin-impuesto = 0.
            x-codigo-importe-unitario-con-igv = "01".        
            x-codigo-razon-exoneracion = '15'.
            x-codigo-importe-referencial = "02".
            x-importe-referencial = x-monto-base-igv.
        END.
        ELSE DO:
            x-importe-igv = 0.01.
            x-tasa-igv = b-ccbcdocu.porigv.
            /* total = (1.18 * 0.01) / 0.18 */
            x-importe-con-impuesto = (( 1 + (b-ccbcdocu.porigv / 100)) * x-importe-igv ) / (b-ccbcdocu.porigv / 100).   
            x-unitario-con-impuesto = x-importe-con-impuesto.

            /* AQUI TAMBIEN TIENE VALOR > 0 */
            x-monto-base-igv = x-importe-con-impuesto - x-importe-igv.

            x-codigo-importe-unitario-con-igv = "01".                               
            x-codigo-razon-exoneracion = '10'.
        END.
    END. 
    ELSE DO:    
        IF b-ccbddocu.aftigv = NO THEN DO:        
            IF LOOKUP(b-ccbcdocu.fmapgo, '899,900') > 0 THEN DO:
                /* Gratuitas Inafectas */
                x-importe-sin-impuesto = b-ccbddocu.implin - b-ccbddocu.impigv.

                /* AQUI TBM VA EL VALOR MAYOR A CERO */
                x-monto-base-igv = x-importe-sin-impuesto.

                x-importe-sin-impuesto = 0.
                x-codigo-razon-exoneracion = '32'.
                x-codigo-importe-referencial = "02".
                x-codigo-importe-unitario-con-igv = "01".       
                x-importe-referencial = x-monto-base-igv.
            END.
            ELSE DO:
                IF b-ccbddocu.codmat = x-articulo-ICBPER THEN DO:
                    /* Inafectas - Nuestra  */                    
                    x-importe-sin-impuesto = b-ccbddocu.implin.
                    x-unitario-sin-impuesto = b-ccbddocu.implin / b-ccbddocu.candes.
                    x-unitario-con-impuesto = x-importe-con-impuesto / b-ccbddocu.candes.
                    x-codigo-razon-exoneracion = '30'.
                    x-codigo-importe-unitario-con-igv = "01".

                    /* ADD x correo LUIS URBANO (Ya no deberia pasar x aca) */
                    x-monto-base-igv = b-ccbddocu.implin - b-ccbddocu.impigv.   
                END.
                ELSE DO:
                    /* Exonerada */
                    x-importe-sin-impuesto = b-ccbddocu.implin - b-ccbddocu.impigv.
                    x-unitario-sin-impuesto = x-importe-sin-impuesto / b-ccbddocu.candes.
                    x-importe-con-impuesto = b-ccbddocu.implin.
                    x-unitario-con-impuesto = x-importe-con-impuesto / b-ccbddocu.candes.
                    x-codigo-importe-unitario-con-igv = "01".
                    x-codigo-razon-exoneracion = '20'.

                    /*  ADD x correo LUIS URBANO */
                    x-monto-base-igv = x-importe-sin-impuesto.
                END.
            END.
        END.
        ELSE DO:
            IF b-ccbddocu.impigv <= 0 AND (b-ccbddocu.impdto > 0 OR b-ccbddocu.impdto2 > 0) THEN DO:
                /* Exonerada */
                x-importe-sin-impuesto = b-ccbddocu.implin - b-ccbddocu.impigv.
                x-unitario-sin-impuesto = x-importe-sin-impuesto / b-ccbddocu.candes.
                x-importe-con-impuesto = b-ccbddocu.implin.
                x-unitario-con-impuesto = x-importe-con-impuesto / b-ccbddocu.candes.
                x-codigo-importe-unitario-con-igv = "01".
                x-codigo-razon-exoneracion = '20'.

                /*  ADD x correo LUIS URBANO */
                x-monto-base-igv = x-importe-sin-impuesto.
            END.
            ELSE DO:
                IF LOOKUP(b-ccbcdocu.fmapgo, '899,900') > 0 THEN DO:
                    /* Venta Gratuita */
                    x-importe-sin-impuesto = b-ccbddocu.implin - b-ccbddocu.impigv.

                    /* ESTOOOOOOOO */
                    x-monto-base-igv = x-importe-sin-impuesto.

                    x-importe-sin-impuesto = 0.
                    x-importe-igv = b-ccbddocu.impigv.
                    x-tasa-igv = b-ccbcdocu.porigv.
                    x-codigo-razon-exoneracion = '11'.
                    x-codigo-importe-referencial = "02".
                    x-importe-referencial = x-monto-base-igv.
                    x-codigo-importe-unitario-con-igv = "01".
                END.
                ELSE DO:
                    /* Venta GRAVADA */              
                    IF b-ccbddocu.impdto <= 0 AND b-ccbddocu.impdto2 <= 0 THEN DO:
                        /* 
                            impdto : Descuento x volumen y/o promocional esta incluido(restado) en el IMPLIN
                            impdto2 : Descuento x encarte - global
                        */
                        x-importe-sin-impuesto = b-ccbddocu.implin - b-ccbddocu.impigv.
                        x-importe-con-impuesto = b-ccbddocu.implin.
                        x-unitario-con-impuesto = x-importe-con-impuesto / b-ccbddocu.candes.
                        x-importe-igv = b-ccbddocu.impigv.
                        x-unitario-sin-impuesto = x-importe-sin-impuesto / b-ccbddocu.candes.

                        /*  */
                        x-monto-base-igv = x-importe-sin-impuesto.

                        x-codigo-razon-exoneracion = '10'.
                        x-tasa-igv = b-ccbcdocu.porigv.
                        x-codigo-importe-unitario-con-igv = "01".
                    END.
                    ELSE DO:
                        
                        /*x-implin = b-ccbddocu.implin + b-ccbddocu.impdto .*/

                        /**/
                        /* Descuento por Item */
                        x-igv-impdto2 = 0.

                        /* base imponible de IMPDTO */        
                        IF b-ccbddocu.impdto > 0 THEN DO:
                            x-base-IMPDTO = b-ccbddocu.impdto / (1 + ( b-ccbcdocu.porigv / 100 )) .
                        END.
                        /* base imponible de IMPDTO2 */        
                        IF b-ccbddocu.impdto2 > 0 THEN DO:
                            x-base-IMPDTO2 = b-ccbddocu.impdto2 / (1 + ( b-ccbcdocu.porigv / 100 )) .
                            x-igv-impdto2 = b-ccbddocu.impdto2 - x-base-IMPDTO2.
                        END.
                        /* b-ccbddocu.implin, Ya tiene descontado el impdto */
                        /*
                        x-importe-sin-impuesto = (b-ccbddocu.implin - b-ccbddocu.impigv) + x-base-impdto - x-base-IMPDTO2.
                        x-importe-sin-impuesto = (b-ccbddocu.implin - b-ccbddocu.impigv).
                        */

                        /*x-unitario-sin-impuesto = x-importe-sin-impuesto / b-ccbddocu.candes.*/
                        x-unitario-sin-impuesto = b-ccbddocu.preuni / (1 + ( b-ccbcdocu.porigv / 100 )).

                        x-importe-sin-impuesto = (b-ccbddocu.candes * x-unitario-sin-impuesto).
                        /*
                        x-importe-con-impuesto = b-ccbddocu.implin + b-ccbddocu.impdto - b-ccbddocu.impdto2 .
                        x-unitario-con-impuesto = x-importe-con-impuesto / b-ccbddocu.candes.
                        */
                        x-unitario-con-impuesto = b-ccbddocu.preuni.

                        /* Es el monto base del igv (restado los descuentos, el implin es el neto) */
                        x-monto-base-igv = b-ccbddocu.implin - b-ccbddocu.impigv - x-base-IMPDTO2.

                        x-importe-igv = b-ccbddocu.impigv.

                        IF b-ccbddocu.impdto2 > 0 THEN DO:
                            /*x-importe-igv = x-importe-igv - (b-ccbddocu.impdto2 - x-base-IMPDTO2).*/
                            x-importe-igv = x-importe-igv - (b-ccbddocu.impdto2 - x-base-IMPDTO2).
                        END.
                        x-importe-descuento = x-base-IMPDTO + x-base-IMPDTO2.
                        
                        x-importe-base-descuento = b-ccbddocu.implin - b-ccbddocu.impigv + x-base-IMPDTO + x-base-IMPDTO2.

                        /*x-factor-descuento = (b-ccbddocu.impdto2 + b-ccbddocu.impdto) / b-ccbddocu.implin.*/
                        IF b-Ccbddocu.Por_Dsctos[1] > 0 OR b-Ccbddocu.Por_Dsctos[2] > 0 OR
                             b-Ccbddocu.Por_Dsctos[3] > 0 OR b-Ccbddocu.dcto_otros_factor > 0 THEN DO:
                            x-factor-descuento = ( 1 -  ( 1 - b-Ccbddocu.Por_Dsctos[1] / 100 ) *
                                        ( 1 - b-Ccbddocu.Por_Dsctos[2] / 100 ) *
                                        ( 1 - b-Ccbddocu.Por_Dsctos[3] / 100 ) *
                                        ( 1 - b-Ccbddocu.dcto_otros_factor / 100 ) ) * 100.                        

                            x-factor-descuento = x-factor-descuento /*/ 100 */.
                        END.

                        /* Ic - 19Jun2021, Recalculo el importe base del descuento (regla de tres simple) */
                        IF x-factor-descuento > 0 THEN DO:
                            /*x-importe-base-descuento = ROUND((x-importe-descuento * 100) / x-factor-descuento , 2).*/
                        END.                        

                        x-tasa-igv = b-ccbcdocu.porigv.
                        x-codigo-razon-exoneracion = '10'.
                        x-codigo-importe-unitario-con-igv = "01". 
                        /*IF b-Ccbddocu.implin <= 0  THEN x-codigo-razon-exoneracion = '11'.*/
                    END.
                END.
            END.
        END.
    END.

    /* Nueva normativa SUNAT Set2021 */
    /*
    x-unitario-con-impuesto = ROUND((x-importe-sin-impuesto + x-importe-igv) / b-ccbddocu.candes,4).
    x-monto-base-igv = x-importe-sin-impuesto.
    */
    x-totalValorVenta = x-totalValorVenta + x-importe-sin-impuesto.
    x-sumatoria-montobaseigv = x-sumatoria-montobaseigv + x-monto-base-igv.

    pXML-DETAIL = pXML-DETAIL + "<importeTotalSinImpuesto>" + TRIM(STRING(x-importe-sin-impuesto,">>>>>>9.99")) + "</importeTotalSinImpuesto>".
    pXML-DETAIL = pXML-DETAIL + "<importeUnitarioSinImpuesto>" + TRIM(STRING(x-unitario-sin-impuesto,">>>>>>9.9999")) + "</importeUnitarioSinImpuesto>".
    pXML-DETAIL = pXML-DETAIL + "<importeUnitarioConImpuesto>" + TRIM(STRING(x-unitario-con-impuesto,">>>>>>9.9999")) + "</importeUnitarioConImpuesto>".
    pXML-DETAIL = pXML-DETAIL + "<codigoImporteUnitarioConImpuesto>" + x-codigo-importe-unitario-con-igv + "</codigoImporteUnitarioConImpuesto>".

    /* Correo Luis Urbano - validacion SUNAT desde Julio2020 */
    pXML-DETAIL = pXML-DETAIL + "<montoBaseIgv>" + TRIM(STRING(x-monto-base-igv,">>>>>>9.99")) + "</montoBaseIgv>".

    pXML-DETAIL = pXML-DETAIL + "<tasaIgv>" + TRIM(STRING(x-tasa-igv,">>>>>9.99")) + "</tasaIgv>".

    /*
      Segun recomendacion de BizLinks del dia 31Jul2020
        Les informamos que el importeIgv a nivel de item debe ser mayor a 0.00 cuando el item es gravado. 
        Lo que pueden hacer es colocar '0.01' (valor mínimo aceptable) en el campo importeIgv 
        (los demás campos deben permanecer igual) para que el comprobante se envíe sin problemas.            
    */

    IF x-importe-igv > 0 AND x-importe-igv <= 0.0090 THEN x-importe-igv = 0.01.

    pXML-DETAIL = pXML-DETAIL + "<importeIgv>" + TRIM(STRING(x-importe-igv,">>>>>>9.99")) + "</importeIgv>".
    pXML-DETAIL = pXML-DETAIL + "<importeTotalImpuestos>" + TRIM(STRING(x-importe-igv,">>>>>>9.99")) + "</importeTotalImpuestos>".
    pXML-DETAIL = pXML-DETAIL + "<codigoRazonExoneracion>" + x-codigo-razon-exoneracion + "</codigoRazonExoneracion>".
    IF x-codigo-importe-referencial <> "" THEN 
        pXML-DETAIL = pXML-DETAIL + "<codigoImporteReferencial>" + x-codigo-importe-referencial + "</codigoImporteReferencial>".
    IF x-importe-referencial > 0 THEN 
        pXML-DETAIL = pXML-DETAIL + "<importeReferencial>" + TRIM(STRING(x-importe-referencial,">>>>>>>9.99")) + "</importeReferencial>".
    IF x-importe-descuento > 0 THEN
        pXML-DETAIL = pXML-DETAIL + "<importeDescuento>" + TRIM(STRING(x-importe-descuento,">>>>>>>9.99")) + "</importeDescuento>".
    IF x-importe-base-descuento > 0 THEN
        pXML-DETAIL = pXML-DETAIL + "<importeBaseDescuento>" + TRIM(STRING(x-importe-base-descuento,">>>>>>>9.99")) + "</importeBaseDescuento>".
    IF x-factor-descuento > 0 THEN DO:
        pXML-DETAIL = pXML-DETAIL + "<factorDescuento>" + TRIM(STRING(x-factor-descuento,">>9.9999")) + "</factorDescuento>".
        /**/
        pXML-DETAIL = pXML-DETAIL + "<codigoAuxiliar40_2>8998</codigoAuxiliar40_2>".
        pXML-DETAIL = pXML-DETAIL + "<textoAuxiliar40_2>" + TRIM(STRING(x-factor-descuento,">>9.9999")) + "</textoAuxiliar40_2>".
    END.

    /* Ic - 09Mar2020, Impuesto Bolsa Plastica */   
     /*IF x-codfam-icbper = x-linea-bolsas-plastica  THEN DO:*/
     
     /*IF x-existe-icbper = YES  THEN DO:*/


     /*IF x-enviar-icbper = YES THEN DO:*/
         IF AVAILABLE almmmatg AND almmmatg.codfam = x-linea-bolsas-plastica THEN DO:
            x-XMLicbper = "".
            RUN impuesto-icbper(OUTPUT x-XMLicbper, INPUT b-Ccbddocu.candes).

            pXML-DETAIL = pXML-DETAIL + x-XMLicbper.
        END.
     /*END.*/
        
    pXML-DETAIL = pXML-DETAIL + "</item>".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generar-xml-factoring) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-xml-factoring Procedure 
PROCEDURE generar-xml-factoring :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    x-xml-factoring = "".
    
    /*IF NOT (x-esta-probando = YES AND x-servidor-prueba = YES) THEN RETURN.*/

    IF x-productivo = NO THEN RETURN.
    
    /* Solo si es Factura o nota de Credito */
    IF NOT (b-ccbcdocu.coddoc = 'FAC' OR b-ccbcdocu.coddoc = 'N/C') THEN DO:    
        RETURN "OK".
    END.
    IF (b-ccbcdocu.coddoc = 'N/C' AND SUBSTRING(x-doc-referencia,1,1) <> 'F') THEN DO:
        /* Es nota de Credito pero no hace referencia Factura */
        RETURN "OK".
    END.

    FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                ccbtabla.tabla = 'N/C' AND 
                                ccbtabla.codigo = b-ccbcdocu.codcta
                                NO-LOCK NO-ERROR.
    IF AVAILABLE ccbtabla THEN DO:
        IF ccbtabla.libre_c01 <> '13' THEN DO:
            /* No es N/C especial */
            RETURN "OK".
        END.
    END.

    
    IF x-tipo-venta = "CONTADO" THEN DO:
        x-xml-factoring = "<formaPagoNegociable>0</formaPagoNegociable>".
        RETURN.
    END.

    DEFINE VAR x-sec AS INT.
    DEFINE VAR x-impte-cuota AS DEC. 
    DEFINE VAR x-suma-cuotas AS DEC.
    DEFINE VAR x-aaaa-mm-dd AS CHAR.
    
    x-xml-factoring = "<formaPagoNegociable>1</formaPagoNegociable>".
    x-xml-factoring = x-xml-factoring + "<montoNetoPendiente>" + TRIM(STRING(b-ccbcdocu.imptot,">>>>>>>9.99")) + "</montoNetoPendiente>".
    REPEAT x-sec = 1 TO x-cuotas:
        IF x-cuotas = 1 THEN DO:
            x-impte-cuota = b-ccbcdocu.imptot.
        END.
        ELSE DO:
            IF x-sec = x-cuotas THEN DO:
                x-impte-cuota = b-ccbcdocu.imptot - x-suma-cuotas.
            END.
            ELSE DO:
                x-impte-cuota = TRUNCATE(b-ccbcdocu.imptot * (x-cuotas-factor[x-sec] / 100),2).
                /*x-impte-cuota = ROUND(b-ccbcdocu.imptot * (x-cuotas-factor[x-sec] / 100),2).*/
                x-suma-cuotas = x-suma-cuotas + x-impte-cuota.
            END.            
        END.
        x-xml-factoring = x-xml-factoring + "<montoPagoCuota" + STRING(x-sec) + ">" + TRIM(STRING(x-impte-cuota,">>>>>>>9.99")) + "</montoPagoCuota" + STRING(x-sec) + ">".
    END.
    REPEAT x-sec = 1 TO x-cuotas:
        x-aaaa-mm-dd = SUBSTRING(STRING(x-cuotas-vcto[x-sec],"99-99-9999"),7,4) + "-".
        x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(x-cuotas-vcto[x-sec],"99-99-9999"),4,2) + "-" .
        x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(x-cuotas-vcto[x-sec],"99-99-9999"),1,2).

        x-xml-factoring = x-xml-factoring + "<fechaPagoCuota" + STRING(x-sec) + ">" + x-aaaa-mm-dd + "</fechaPagoCuota" + STRING(x-sec) + ">".
    END.
    
    RETURN "OK".

END.

/*
DEFINE VAR x-tipo-venta AS CHAR.
DEFINE VAR x-cuotas AS INT.
DEFINE VAR x-cuotas-factor AS DEC EXTENT 30.
DEFINE VAR x-cuotas-vcto AS DATE EXTENT 30.
*/

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

DEFINE VAR x-aaaa-mm-dd AS CHAR INIT "".
DEFINE VAR x-nom-cli AS CHAR.
DEFINE VAR x-dir-cli AS CHAR.
DEFINE VAR x-importe-letras AS CHAR.

DEFINE VAR x-es-icbper AS LOG.

DEFINE VAR x-hora-emision AS CHAR.

x-Ruc-Cli = IF (b-ccbcdocu.ruccli = ?) THEN "" ELSE TRIM(b-ccbcdocu.ruccli).
x-Nom-Cli = IF (b-ccbcdocu.nomcli = ?) THEN "" ELSE TRIM(b-ccbcdocu.nomcli).
x-Dir-Cli = IF (b-ccbcdocu.dircli = ?) THEN "" ELSE b-ccbcdocu.dircli.
x-Tipo-Ide = '6'.
/* UTF-8 */
x-Nom-Cli = fget-utf-8(x-Nom-Cli). 
x-Dir-Cli = fget-utf-8(x-Dir-Cli).

IF b-ccbcdocu.coddoc = 'BOL' OR b-ccbcdocu.coddoc = 'N/C' OR b-ccbcdocu.coddoc = 'N/D' THEN DO:
    IF b-ccbcdocu.imptot > x-Importe-maximo-boleta THEN DO:
        /* Verificamos si el RUC */
        IF x-Ruc-Cli = "" THEN DO:
            /* DNI */
            x-Ruc-Cli = IF (b-ccbcdocu.codant = ?) THEN "" ELSE TRIM(b-ccbcdocu.codant).
            x-Tipo-Ide = '1'.
            IF x-Ruc-Cli = "" OR x-Ruc-Cli BEGINS "11111" THEN DO:
                /* El Ruc o DNI es generico */
                x-Ruc-Cli = "12345678".            
            END.
            ELSE DO:
                /* 8 Digitos de DNI */
                x-Ruc-Cli = "00000000" + x-Ruc-Cli.            
                x-Ruc-Cli = SUBSTRING(x-Ruc-Cli, (LENGTH(x-Ruc-Cli) - 8) + 1).
            END.
        END.
        ELSE DO:
            IF LENGTH(x-Ruc-Cli) = 11 AND SUBSTRING(x-Ruc-Cli,1,3) = '000' THEN DO:
                /* Es DNI */
                x-Ruc-Cli = STRING(INTEGER(x-Ruc-Cli),"99999999").
                x-Tipo-Ide = '1'.
            END.    
        END.
    END.
    ELSE DO: 
        IF x-Ruc-Cli = "" THEN DO:
            /* DNI */
            x-Ruc-Cli = IF (b-ccbcdocu.codant = ?) THEN "" ELSE TRIM(b-ccbcdocu.codant).
            /* BUscamos error */
            DEF VAR i-Ruc-Cli AS INT NO-UNDO.
            ASSIGN
                i-Ruc-Cli = INTEGER(x-Ruc-Cli) NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN x-Ruc-Cli = ''.
            x-Tipo-Ide = '1'.
            IF x-Ruc-Cli = "" OR INTEGER(x-Ruc-Cli) = 0 OR x-Ruc-Cli BEGINS "11111" THEN DO:
                /* Si Ruc o DNI es generico */
                x-Ruc-Cli = '0'.    /* DOC.TRIB.NO.DOM.SIN.RUC */
                x-Tipo-Ide = '0'.
            END.
            ELSE DO:
                /* 8 Digitos de DNI */
                x-Ruc-Cli = "00000000" + x-Ruc-Cli.            
                x-Ruc-Cli = SUBSTRING(x-Ruc-Cli, (LENGTH(x-Ruc-Cli) - 8) + 1).
            END.
        END.
        ELSE DO:
            IF LENGTH(x-Ruc-Cli) = 11 AND SUBSTRING(x-Ruc-Cli,1,3) = '000' THEN DO:
                /* ES DNI */
                x-Tipo-Ide = '1'.
                x-Ruc-Cli = SUBSTRING(x-Ruc-Cli,4).
                x-Ruc-Cli = "00000000" + x-Ruc-Cli.            
                x-Ruc-Cli = SUBSTRING(x-Ruc-Cli, (LENGTH(x-Ruc-Cli) - 8) + 1).
            END.
            ELSE DO:
                IF x-Ruc-Cli BEGINS "11111" THEN DO:
                    x-Ruc-Cli = '0'.
                    x-Tipo-Ide = '0'.
                END.
            END.
        END.
        
    END.
    IF x-Nom-Cli = "" THEN x-Nom-Cli = "-".
END.

x-aaaa-mm-dd = SUBSTRING(STRING(b-ccbcdocu.fchdoc,"99-99-9999"),7,4) + "-".
x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-ccbcdocu.fchdoc,"99-99-9999"),4,2) + "-" .
x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-ccbcdocu.fchdoc,"99-99-9999"),1,2).

/* Hora de Emision */
x-hora-emision = "00:01:01".
IF NOT (TRUE <> (b-ccbcdocu.horcie > "")) THEN x-hora-emision = b-ccbcdocu.horcie  .
IF LENGTH(x-hora-emision) = 5  THEN x-hora-emision = x-hora-emision + ":01".
IF LENGTH(x-hora-emision) > 8  THEN x-hora-emision = "00:01:01".

p-xml-header = "".
x-XML-anticipos = "".

IF x-documento-contingencia = YES THEN DO:
    p-xml-header = "<contingencia>1</contingencia>".
END.

p-xml-header = p-xml-header + "<correoEmisor>-</correoEmisor>".
p-xml-header = p-xml-header + "<serieNumero>" +  cSerieSunat + "-" + cCorrelativoSunat + "</serieNumero>".
p-xml-header = p-xml-header + "<fechaEmision>" + x-aaaa-mm-dd + "</fechaEmision>".
/*p-xml-header = p-xml-header + "<horaEmision>" + b-ccbcdocu.horcie + "</horaEmision>".*/
p-xml-header = p-xml-header + "<horaEmision>" + x-hora-emision + "</horaEmision>".
p-xml-header = p-xml-header + "<tipoDocumento>" + cTipoDoctoSunat + "</tipoDocumento>".
IF (b-ccbcdocu.codmon = 2) THEN DO:
    p-xml-header = p-xml-header + "<tipoMoneda>USD</tipoMoneda>".
END.
ELSE DO:
    p-xml-header = p-xml-header + "<tipoMoneda>PEN</tipoMoneda>".
END.
p-xml-header = p-xml-header + "<tipoDocumentoEmisor>6</tipoDocumentoEmisor>".
p-xml-header = p-xml-header + "<numeroDocumentoEmisor>" + cRucEmpresa + "</numeroDocumentoEmisor>".
p-xml-header = p-xml-header + "<razonSocialEmisor>" + fget-utf-8(cRazonSocial) + "</razonSocialEmisor>".
p-xml-header = p-xml-header + "<ubigeoEmisor>" + cUbigeo + "</ubigeoEmisor>".
p-xml-header = p-xml-header + "<direccionEmisor>" + fget-utf-8(cDirecEmisor) + "</direccionEmisor>".
p-xml-header = p-xml-header + "<urbanizacion>SANTA RAQUEL</urbanizacion>".
p-xml-header = p-xml-header + "<provinciaEmisor>LIMA</provinciaEmisor>".
p-xml-header = p-xml-header + "<departamentoEmisor>LIMA</departamentoEmisor>".
p-xml-header = p-xml-header + "<distritoEmisor>ATE</distritoEmisor>".
p-xml-header = p-xml-header + "<paisEmisor>PE</paisEmisor>".
p-xml-header = p-xml-header + "<codigoLocalAnexoEmisor>" + x-CodigoEstablecimiento + "</codigoLocalAnexoEmisor>".
p-xml-header = p-xml-header + "<tipoDocumentoAdquiriente>" + x-Tipo-Ide + "</tipoDocumentoAdquiriente>".
p-xml-header = p-xml-header + "<numeroDocumentoAdquiriente>" + x-Ruc-Cli + "</numeroDocumentoAdquiriente>".
p-xml-header = p-xml-header + "<razonSocialAdquiriente>" + fget-utf-8(x-Nom-Cli) + "</razonSocialAdquiriente>".

x-tipoDocumentoAdquiriente = x-Tipo-Ide.
x-numeroDocumentoAdquiriente = x-Ruc-Cli.

/* Totales */
x-vvta-gravada = 0.
x-vvta-inafectas = 0.
x-vvta-exoneradas = 0.
x-vvta-gratuitas = 0.
x-total-igv = 0.                /* Total Impuestos */
x-total-igv2 = 0.               /* Total IGV */
x-imp-total = 0.
x-imp-isc = 0.
x-total-otros-tributos = 0.     /* BOLSAS PLASTICAS */

x-monto-base-dscto-global-anticipo = 0.
x-total-dscto-globales-anticipo = 0.
x-total-anticipos = 0.
x-porcentaje-dscto-global-anticipo = 0.

DEFINE VAR x-tipo-factura AS CHAR.

x-total-igv = b-ccbcdocu.impigv.
x-total-igv2 = b-ccbcdocu.impigv.
x-imp-total =  b-ccbcdocu.imptot.

x-tipo-factura = "".

IF LOOKUP(b-ccbcdocu.fmapgo, '899,900') = 0 AND b-ccbcdocu.porigv = 0.00 THEN DO:
    /* Operacion INAFECTAS */
    x-vvta-inafectas = b-ccbcdocu.impvta.
    x-vvta-gravada = 0.
    x-total-igv = 0.
    x-total-igv2 = 0.
END.
ELSE DO:    
    /* Operacion Gravadas */
    x-vvta-gravada = b-ccbcdocu.impvta.
    /* Operaciones Gratuitas */
    IF LOOKUP(b-ccbcdocu.fmapgo, '899,900') > 0 THEN DO:
        x-vvta-gratuitas = b-ccbcdocu.impbrt.
        x-vvta-gravada = 0.
        x-imp-total = 0.
    END.
    IF b-ccbcdocu.impexo > 0 THEN DO:                
        /* Operacion Exoneradas */
        x-vvta-exoneradas = b-ccbcdocu.impexo.
    END.

    IF x-enviar-icbper = NO THEN x-vvta-inafectas = b-ccbcdocu.acubon[10].
    /*x-vvta-inafectas = b-ccbcdocu.acubon[10].*/   /* Inafectas */

    /* Bonificaciones ( hay que leer el detalle del docto campo linre_c05='OF' ) */    
END.

/*
/* Ic 22Ago2019, Incluir las bolsas plasticas en Inafecta, aprobada por Graciela Pacaya y Daniel Llican */
x-vvta-inafectas = x-vvta-inafectas + x-total-otros-tributos.
*/

/* Ic - 25Oct2019, anticipos */
DEFINE VAR z-vvta-anticipos AS DEC INIT 0.
DEFINE VAR z-tot-anticipos AS DEC INIT 0.
DEFINE VAR z-igv-anticipos AS DEC INIT 0.
DEFINE VAR z-texto-xml AS CHAR INIT ''.

/* Si hay anticipos de campaña (A/C) */
RUN generar-xml-anticipos(INPUT b-ccbcdocu.coddoc,
                              INPUT b-ccbcdocu.nrodoc,
                              INPUT b-ccbcdocu.codmon,
                              INPUT b-ccbcdocu.tpocmb,
                              OUTPUT z-tot-anticipos,
                              OUTPUT z-vvta-anticipos,
                              OUTPUT z-igv-anticipos,
                              OUTPUT z-texto-xml).

IF z-tot-anticipos > 0 THEN DO:

    x-XML-anticipos = z-texto-xml.
    
    IF z-tot-anticipos = x-imp-total THEN DO:
        x-total-anticipos = z-tot-anticipos.
        x-monto-base-dscto-global-anticipo = z-vvta-anticipos.
        x-porcentaje-dscto-global-anticipo = 1.
        x-total-dscto-globales-anticipo = z-vvta-anticipos.
        x-total-igv2 = 0.
        x-total-igv = 0.
        x-imp-total = 0.
        x-vvta-gravada = 0.
    END.
    ELSE DO:
        
        /* Tiene pagos con Anticipos - Recalculamos valor */
        z-vvta-anticipos = IF( z-vvta-anticipos >= x-vvta-gravada) THEN x-vvta-gravada ELSE z-vvta-anticipos.

        x-monto-base-dscto-global-anticipo = x-vvta-gravada.
        x-total-dscto-globales-anticipo = z-vvta-anticipos.

        x-vvta-gravada = x-vvta-gravada - z-vvta-anticipos.
        x-total-igv2 = x-total-igv2 - z-igv-anticipos.

        x-total-anticipos = z-tot-anticipos.
        x-imp-total = x-imp-total - z-tot-anticipos.

        IF x-imp-total < 0 THEN x-imp-total = 0.

        IF x-total-igv2 < 0 OR x-imp-total = 0 THEN x-total-igv2 = 0.
        x-total-igv = x-total-igv2.

        x-porcentaje-dscto-global-anticipo = x-total-dscto-globales-anticipo / x-monto-base-dscto-global-anticipo.    
    END.
END.

/*totalVenta=totalPrecioVenta + totalOtrosCargos – totalDescuentos*/

IF x-vvta-gravada <= 0.01 THEN x-vvta-gravada = 0.00.       /* Redondeo x caso anticipos */

IF x-vvta-gravada > 0 OR z-tot-anticipos > 0 THEN p-xml-header = p-xml-header + "<totalValorVentaNetoOpGravadas>" + TRIM(STRING(x-vvta-gravada,">>>>>>>9.99")) + "</totalValorVentaNetoOpGravadas>".
IF x-vvta-inafectas > 0 THEN p-xml-header = p-xml-header + "<totalValorVentaNetoOpNoGravada>" + TRIM(STRING(x-vvta-inafectas,">>>>>>>9.99")) + "</totalValorVentaNetoOpNoGravada>".
IF x-vvta-gratuitas > 0 THEN p-xml-header = p-xml-header + "<totalValorVentaNetoOpGratuitas>" + TRIM(STRING(x-vvta-gratuitas,">>>>>>>9.99")) + "</totalValorVentaNetoOpGratuitas>".
/*IF x-imp-total > 0 THEN p-xml-header = p-xml-header + "<totalVenta>" + TRIM(STRING(x-imp-total,">>>>>>>9.99")) + "</totalVenta>".*/
IF z-tot-anticipos > 0 THEN DO:
    IF x-vvta-exoneradas > 0 THEN DO:
        p-xml-header = p-xml-header + "<totalValorVentaNetoOpExoneradas>" + TRIM(STRING(x-vvta-exoneradas,">>>>>>>9.99")) + "</totalValorVentaNetoOpExoneradas>".
    END.
END.
ELSE DO:
    p-xml-header = p-xml-header + "<totalValorVentaNetoOpExoneradas>" + TRIM(STRING(x-vvta-exoneradas,">>>>>>>9.99")) + "</totalValorVentaNetoOpExoneradas>".
END.
p-xml-header = p-xml-header + "<totalIgv>" + TRIM(STRING(x-total-igv2,">>>>>>>9.99")) + "</totalIgv>".
p-xml-header = p-xml-header + "<totalImpuestos>" + TRIM(STRING(x-total-igv,">>>>>>>9.99")) + "</totalImpuestos>".

IF z-tot-anticipos > 0 THEN DO:
    p-xml-header = p-xml-header + fgenera-tag("totalDocumentoAnticipo",TRIM(STRING(x-total-anticipos,">>>>>>>9.99"))).
    p-xml-header = p-xml-header + fgenera-tag("montoBaseDsctoGlobalAnticipo",TRIM(STRING(x-monto-base-dscto-global-anticipo,">>>>>>>9.99"))).
    p-xml-header = p-xml-header + fgenera-tag("porcentajeDsctoGlobalAnticipo",TRIM(STRING(x-porcentaje-dscto-global-anticipo,">>9.99999"))).
    p-xml-header = p-xml-header + fgenera-tag("totalDsctoGlobalesAnticipo",TRIM(STRING(x-total-dscto-globales-anticipo,">>>>>>>9.99"))).
END.

/* ***************************************************************************************************************** */
/* RHC 15/08/19 Solicitado por G.P. BOLSAS PLASTICAS */
/* 
    Ic 22Ago2019, se retiro x q no se mostraba en el impreso de Bizlinks
                    aprobada por Graciela Pacaya y Daniel Llican
    p-xml-header = p-xml-header + "<totalOtrosTributos>" + TRIM(STRING(x-total-otros-tributos,">>>>>>>9.99")) + "</totalOtrosTributos>". 
*/
/* ***************************************************************************************************************** */

p-xml-header = p-xml-header + "<totalValorVenta>" + TRIM(STRING(x-totalValorVenta,">>>>>>>9.99")) + "</totalValorVenta>".
p-xml-header = p-xml-header + "<totalPrecioVenta>" + TRIM(STRING(x-totalPrecioVenta,">>>>>>>9.99")) + "</totalPrecioVenta>".
p-xml-header = p-xml-header + "<totalVenta>" + TRIM(STRING(x-imp-total,">>>>>>>9.99")) + "</totalVenta>".

IF fGetTipoOperacion(b-ccbcdocu.coddoc,b-ccbcdocu.nrodoc) <> "" THEN DO:
    p-xml-header = p-xml-header + "<tipoOperacion>" + fGetTipoOperacion(b-ccbcdocu.coddoc,b-ccbcdocu.nrodoc) + "</tipoOperacion>".
END.
p-xml-header = p-xml-header + "<direccionAdquiriente>" + x-dir-Cli + "</direccionAdquiriente>".

/* Vencimiento */
x-aaaa-mm-dd = SUBSTRING(STRING(b-ccbcdocu.fchvto,"99-99-9999"),7,4) + "-".
x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-ccbcdocu.fchvto,"99-99-9999"),4,2) + "-" .
x-aaaa-mm-dd = x-aaaa-mm-dd + SUBSTRING(STRING(b-ccbcdocu.fchvto,"99-99-9999"),1,2).

IF (b-ccbcdocu.coddoc = 'FAC' OR b-ccbcdocu.coddoc = 'BOL') THEN DO:
    /* ???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? */
    p-xml-header = p-xml-header + "<fechaVencimiento>" + x-aaaa-mm-dd + "</fechaVencimiento>".
END.
ELSE DO:
    p-xml-header = p-xml-header + "<codigoAuxiliar40_8>8999</codigoAuxiliar40_8>".
    p-xml-header = p-xml-header + "<textoAuxiliar40_8>" + x-aaaa-mm-dd + "</textoAuxiliar40_8>".
END.

/* Importe en Letras */
x-importe-letras = "".
RUN lib\_numero.R(INPUT x-imp-total, 2, 1, OUTPUT x-importe-letras).
x-importe-letras = "SON : " + TRIM(x-importe-letras).

IF b-ccbcdocu.codmon = 1 THEN DO:
    x-importe-letras = TRIM(x-importe-letras) + " SOLES".
END.
ELSE DO:
    x-importe-letras = TRIM(x-importe-letras) + " DOLARES AMERICANOS".
END.

p-xml-header = p-xml-header + "<codigoLeyenda_1>1000</codigoLeyenda_1>".
p-xml-header = p-xml-header + "<textoLeyenda_1>" + x-importe-letras + "</textoLeyenda_1>".

/* Bolsa Plastica ICBPER - 09Mar2020*/
IF x-enviar-icbper = YES THEN DO:
    IF b-ccbcdocu.coddoc = 'FAC' OR b-ccbcdocu.coddoc = 'BOL' THEN DO:
        IF b-ccbcdocu.acubon[10] > 0 THEN DO:
            p-xml-header = p-xml-header + "<montoBaseICBPER>" + TRIM(STRING(b-ccbcdocu.acubon[10],">>>>>>>9.99"))+ "</montoBaseICBPER>".
            p-xml-header = p-xml-header + "<totalMontoICBPER>" + TRIM(STRING(b-ccbcdocu.acubon[10],">>>>>>>9.99"))+ "</totalMontoICBPER>".
        END.
    END.
END.


/*
IF LENGTH(x-importe-letras) > 200 THEN DO:
    p-xml-header = p-xml-header + "<codigoLeyenda_1>1000</codigoLeyenda_1>".
    p-xml-header = p-xml-header + "<textoLeyenda_1>" + SUBSTRING(x-importe-letras,1,200) + "</textoLeyenda_1>".
    p-xml-header = p-xml-header + "<codigoLeyenda_2>9846</codigoLeyenda_2>".
    p-xml-header = p-xml-header + "<textoLeyenda_2>" + SUBSTRING(x-importe-letras,201) + "</textoLeyenda_2>".
END.
ELSE DO:
    p-xml-header = p-xml-header + "<codigoLeyenda_1>1000</codigoLeyenda_1>".
    p-xml-header = p-xml-header + "<textoLeyenda_1>" + x-importe-letras + "</textoLeyenda_1>".
END.
*/

/*      Ya existe en PERSONALIZADOS
p-xml-header = p-xml-header + "<codigoAuxiliar40_1>9011</codigoAuxiliar40_1>".
p-xml-header = p-xml-header + "<textoAuxiliar40_1>" + STRING(b-ccbcdocu.porigv)+ "%" + "</textoAuxiliar40_1>".
*/

/* Personalizados */
p-xml-header = p-xml-header + fget-personalizados(b-ccbcdocu.tipo, pTipoDocmto, pNroDocmto, pCodDiv).

/* Correo del Cliente */
p-xml-header = p-xml-header + fget-email-cliente(b-ccbcdocu.codcli).

/* Buscamos configuración de Proveedor de Fact. Electroc. */
FIND FIRST VtaDTabla WHERE VtaDTabla.CodCia = s-CodCia AND
    VtaDTabla.Tabla = 'SUNATPRV' AND
    VtaDTabla.Tipo = pCodDiv AND
    CAN-FIND(FIRST VtaCTabla OF VtaDTabla NO-LOCK)
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaDTabla AND VtaDTabla.Llave = "BL" THEN DO:
    IF LOOKUP(b-Ccbcdocu.CodDoc, 'BOL,FAC,N/D') > 0 THEN DO:

        p-xml-header = p-xml-header + "<codigoAuxiliar250_2>9670</codigoAuxiliar250_2>".
        p-xml-header = p-xml-header + "<textoAuxiliar250_2>ABONAR EN LAS SIGUIENTES CUENTAS RECAUDADORAS:</textoAuxiliar250_2>".

        p-xml-header = p-xml-header + "<codigoAuxiliar250_3>9671</codigoAuxiliar250_3>".
        p-xml-header = p-xml-header + "<textoAuxiliar250_3>BCP SOLES: 191-1532467-0-63  (CCI 002-191-001532467063-55)</textoAuxiliar250_3>".

        p-xml-header = p-xml-header + "<codigoAuxiliar250_4>9672</codigoAuxiliar250_4>".
        p-xml-header = p-xml-header + "<textoAuxiliar250_4>BCP DOLARES: 191-1524222-1-91 (CCI 002-191-001524222191-57)</textoAuxiliar250_4>".
    END.
    /* RHC 19/02/2019 Caso de DETRACCION */
    IF LOOKUP(b-Ccbcdocu.CodDoc, 'BOL,FAC') > 0 AND b-Ccbcdocu.TpoFac = "S" THEN DO:
        FOR EACH b-Ccbddocu OF b-Ccbcdocu NO-LOCK, FIRST almmserv NO-LOCK WHERE almmserv.CodCia = b-Ccbddocu.codcia AND
            almmserv.codmat = b-Ccbddocu.codmat AND
            almmserv.AftDetraccion = YES:
            /* Solo para importes mayores a S/700.00 */
            DEF VAR x-ImpTot AS DEC NO-UNDO.
            x-ImpTot = b-Ccbcdocu.ImpTot.
            IF b-Ccbcdocu.CodMon = 2  THEN x-ImpTot = x-ImpTot * b-Ccbcdocu.TpoCmb.
            IF x-ImpTot > 700 THEN DO:
                p-xml-header = p-xml-header + "<codigoAuxiliar250_5>9673</codigoAuxiliar250_5>".
                p-xml-header = p-xml-header + "<textoAuxiliar250_5>BCP SOLES: 191-1532467-0-63  (CCI 002-191-001532467063-55)</textoAuxiliar250_5>".

                p-xml-header = p-xml-header + "<codigoAuxiliar250_6>9674</codigoAuxiliar250_6>".
                p-xml-header = p-xml-header + "<textoAuxiliar250_6>BCP DOLARES: 191-1524222-1-91 (CCI 002-191-001524222191-57)</textoAuxiliar250_6>".
            END.
            LEAVE.
        END.
    END.
END.

/* Factorng - nuevo requerimiento de SUNAT, desde el 04Abr2021 */
RUN generar-xml-factoring.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-impuesto-icbper) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE impuesto-icbper Procedure 
PROCEDURE impuesto-icbper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pXMLicbper AS CHAR.
DEFINE INPUT PARAMETER pCantidad AS DEC.

pXMLicbper = "". 

DEFINE VAR x-precio-ICBPER AS DEC.
DEFINE VAR x-implin AS DEC.

x-precio-ICBPER = 0.0.   

/* Sacar el importe de bolsas plasticas */
DEFINE VAR z-hProc AS HANDLE NO-UNDO.               /* Handle Libreria */

RUN ccb\libreria-ccb.p PERSISTENT SET z-hProc.

/* Procedimientos */
RUN precio-impsto-bolsas-plastica IN z-hProc (INPUT TODAY, OUTPUT x-precio-ICBPER).

DELETE PROCEDURE z-hProc.                   /* Release Libreria */

x-implin = pCantidad * x-precio-ICBPER.

pXMLicbper = pXMLicbper + "<impuestoBolsaPlastico>" + TRIM(STRING(x-implin,">>>>>>>9.99")) + "</impuestoBolsaPlastico>".
pXMLicbper = pXMLicbper + "<montoTributoBolsaPlastico>" + TRIM(STRING(x-implin,">>>>>>>9.99")) + "</montoTributoBolsaPlastico>".
pXMLicbper = pXMLicbper + "<cantidadBolsaPlastico>" + TRIM(STRING(INTEGER(pCantidad),">>>>>>>9")) + "</cantidadBolsaPlastico>".
pXMLicbper = pXMLicbper + "<montoUnitarioBolsaPlastico>" + TRIM(STRING(x-precio-ICBPER,">>>>>>>9.9999")) + "</montoUnitarioBolsaPlastico>".

/*
/* Busco el impuesto */
FIND FIRST x-ccbddocu WHERE x-ccbddocu.codcia = b-ccbddocu.codcia AND
                            x-ccbddocu.coddiv = b-ccbddocu.coddiv AND
                            x-ccbddocu.codmat = x-articulo-ICBPER AND
                            x-ccbddocu.coddoc = b-ccbddocu.coddoc AND
                            x-ccbddocu.nrodoc = b-ccbddocu.nrodoc NO-LOCK NO-ERROR.
IF AVAILABLE x-ccbddocu THEN DO:
    pXMLicbper = pXMLicbper + "<impuestoBolsaPlastico>" + TRIM(STRING(x-ccbddocu.implin,">>>>>>>9.99")) + "</impuestoBolsaPlastico>".
    pXMLicbper = pXMLicbper + "<montoTributoBolsaPlastico>" + TRIM(STRING(x-ccbddocu.implin,">>>>>>>9.99")) + "</montoTributoBolsaPlastico>".
    pXMLicbper = pXMLicbper + "<cantidadBolsaPlastico>" + TRIM(STRING(INTEGER(x-ccbddocu.candes),">>>>>>>9")) + "</cantidadBolsaPlastico>".
    pXMLicbper = pXMLicbper + "<montoUnitarioBolsaPlastico>" + TRIM(STRING(x-ccbddocu.preuni,">>>>>>>9.9999")) + "</montoUnitarioBolsaPlastico>".
END.
*/

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nota-credito-electronica) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nota-credito-electronica Procedure 
PROCEDURE nota-credito-electronica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-xml-nota-credito AS LONGCHAR.

DEFINE VAR x-motivo AS CHAR.
DEFINE VAR x-Glosa AS CHAR.

x-motivo = '10'. /* Motivo de la N/C, usando un motivo GRAL */

IF b-ccbcdocu.cndcre = 'D' THEN x-motivo = '07'.
IF b-ccbcdocu.cndcre <> 'D' THEN DO:
    FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                ccbtabla.tabla = 'N/C' AND 
                                ccbtabla.codigo = b-ccbcdocu.codcta
                                NO-LOCK NO-ERROR.
    IF AVAILABLE ccbtabla THEN DO:
        IF ccbtabla.libre_c01 <> ? AND ccbtabla.libre_c01 <> '' THEN x-motivo = ccbtabla.libre_c01.
    END.
END.

DEFINE BUFFER ix-ccbcdocu FOR ccbcdocu.

/* Fecha de Emision de la referencia */
DEFINE VAR x-CodRef AS CHAR INIT "".
DEFINE VAR x-NroRef AS CHAR.
DEFINE VAR x-Vcto AS CHAR INIT "". 
DEFINE VAR x-DoctoRef AS CHAR INIT "".
DEFINE VAR x-Tipo-DoctoRef AS CHAR INIT "".
DEFINE VAR x-OrdenCompra AS CHAR INIT "".
DEFINE VAR lReferencia AS CHAR.
DEFINE VAR lReferencia1 AS CHAR.
DEFINE VAR lFEmisDocRef AS DATE.

x-DoctoRef = x-doc-referencia.
x-Tipo-DoctoRef = IF(SUBSTRING(x-doc-referencia,1,1) = "F") THEN "01" ELSE "03".

IF (SUBSTRING(x-doc-referencia,1,1) = "F") THEN DO:
    x-CodRef = 'FAC'.
END.
x-NroRef = SUBSTRING(x-doc-referencia,2,3) + SUBSTRING(x-doc-referencia,5).

/* Lo busco como FACTURA */
FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                ix-ccbcdocu.coddoc = x-CodRef AND 
                                ix-ccbcdocu.nrodoc = x-NroRef
                                NO-LOCK NO-ERROR.
IF NOT AVAILABLE ix-ccbcdocu THEN DO:
    IF SUBSTRING(x-doc-referencia,1,1)="B" THEN DO:
        /* Lo busco como BOLETA */
        x-CodRef = 'BOL'.
        FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                        ix-ccbcdocu.coddoc = x-CodRef AND 
                                        ix-ccbcdocu.nrodoc = x-NroRef
                                        NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ix-ccbcdocu THEN DO:
            /* Lo busco como TICKET */
            x-CodRef = 'TCK'.
            FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                            ix-ccbcdocu.coddoc = x-CodRef AND 
                                            ix-ccbcdocu.nrodoc = x-NroRef
                                            NO-LOCK NO-ERROR.
        END.
    END.
END.

lFEmisDocRef = ?.
IF AVAILABLE ix-ccbcdocu THEN DO:
    lFEmisDocRef = ix-ccbcdocu.fchdoc.
    /* Fecha de inicio de la facturacion electronica de la tienda de donde se emitio la FAC/BOL */
    fFechaInicioFE = ?.
    FIND FIRST gn-div OF ix-ccbcdocu NO-LOCK NO-ERROR.
    IF AVAILABLE gn-div THEN DO:
        fFechaInicioFE = gn-divi.libre_f01.
    END.
    IF fFechaInicioFE = ? THEN DO:
        /*
        pReturn = "667|La tienda de donde se emitio el documento de referencia NO tiene configurado la fecha de inicio de facturacion electronica".
        RETURN .
        */
        x-Vcto = "0000-00-00".
    END.
    ELSE DO:
        x-Vcto =    STRING(YEAR(ix-ccbcdocu.fchdoc),"9999") + "-" + 
                    STRING(MONTH(ix-ccbcdocu.fchdoc),"99") + "-" + 
                    STRING(DAY(ix-ccbcdocu.fchdoc),"99").
        /* Si la fecha de emision del docmtno de referencia es menor al inicio de Facturacion Electronica */
        IF ix-ccbcdocu.fchdoc < fFechaInicioFE THEN DO:
            x-DoctoRef = "0" + SUBSTRING(x-DoctoRef,2).        
        END.

    END.
END.

/* Referencia */
lReferencia     = IF(SUBSTRING(x-doc-referencia,1,1)="B") THEN "BOLETA DE VENTA ELECTRONICA"
                   ELSE "FACTURA ELECTRONICA".
lReferencia1     = x-DoctoRef.
lReferencia1     = lReferencia1 + " - " + IF(lFEmisDocRef = ?) THEN "" 
                                       ELSE STRING(lFEmisDocRef,"99/99/9999").

lReferencia = lReferencia + " " + lReferencia1.

/*  RTV
    Ic 24Ago2018 - Correo de Jessica Barreda, autorizado por Julissa Calderon
                (REITERATIVO2: AUTOMATIZACIÓN DE NC - CLIENTE SUPERMERCADOS PERUANOS)
    Solo para Supermecados Peruanos : 20100070970
*/
x-OrdenCompra = "".
IF b-ccbcdocu.codcli = "20100070970" THEN DO:
    FIND FIRST almcmov WHERE almcmov.codcia = s-codcia AND 
                                almcmov.codalm = b-ccbcdocu.codalm AND
                                almcmov.tipmov = 'I' AND
                                almcmov.codmov = b-ccbcdocu.codmov AND 
                                almcmov.nrodoc = INTEGER(TRIM(b-ccbcdocu.nroped))
                                NO-LOCK NO-ERROR.
    IF AVAILABLE almcmov THEN DO:
        IF NOT (TRUE <> (almcmov.lpn > "")) THEN x-OrdenCompra = TRIM(almcmov.lpn).
    END.
END.

x-Glosa  = TRIM(REPLACE(b-ccbcdocu.glosa,"|"," ")).
x-Glosa  = IF LENGTH(x-Glosa) <= 10 THEN "Generacion de la N/C" ELSE x-Glosa.

x-Glosa  = fget-utf-8(x-Glosa).

p-xml-nota-credito = "<codigoSerieNumeroAfectado>" + x-motivo + "</codigoSerieNumeroAfectado>".
p-xml-nota-credito = p-xml-nota-credito + "<motivoDocumento>" + x-glosa + "</motivoDocumento>".
p-xml-nota-credito = p-xml-nota-credito + "<tipoDocumentoReferenciaPrincipal>" + x-Tipo-DoctoRef + "</tipoDocumentoReferenciaPrincipal>".
p-xml-nota-credito = p-xml-nota-credito + "<numeroDocumentoReferenciaPrincipal>" + SUBSTRING(x-DoctoRef,1,4) + "-" + SUBSTRING(x-DoctoRef,5) + "</numeroDocumentoReferenciaPrincipal>".
IF x-OrdenCompra <> "" THEN p-xml-nota-credito = p-xml-nota-credito + "<ordenCompra>" + x-OrdenCompra + "</ordenCompra>".

x-tipoDocumentoReferenciaPrincipal = x-Tipo-DoctoRef.
x-numeroDocumentoReferenciaPrincipal = SUBSTRING(x-DoctoRef,1,4) + "-" + SUBSTRING(x-DoctoRef,5).

p-xml-nota-credito = p-xml-nota-credito + "<codigoAuxiliar100_3>9030</codigoAuxiliar100_3>".
p-xml-nota-credito = p-xml-nota-credito + "<textoAuxiliar100_3>" + lReferencia + "</textoAuxiliar100_3>".


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nota-debito-electronica) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nota-debito-electronica Procedure 
PROCEDURE nota-debito-electronica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-xml-nota-debito AS LONGCHAR.

DEFINE VAR x-motivo AS CHAR.
DEFINE VAR x-Glosa AS CHAR.

x-motivo = '03'. /* Motivo de la N/C, usando un motivo GRAL */

IF b-ccbcdocu.cndcre = 'D' THEN x-motivo = '08'.
IF b-ccbcdocu.cndcre <> 'D' THEN DO:
    FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                ccbtabla.tabla = 'N/D' AND 
                                ccbtabla.codigo = b-ccbcdocu.codcta
                                NO-LOCK NO-ERROR.
    IF AVAILABLE ccbtabla THEN DO:
        IF ccbtabla.libre_c01 <> ? AND ccbtabla.libre_c01 <> '' THEN x-motivo = ccbtabla.libre_c01.
    END.
END.

DEFINE BUFFER ix-ccbcdocu FOR ccbcdocu.

/* Fecha de Emision de la referencia */
DEFINE VAR x-CodRef AS CHAR INIT "".
DEFINE VAR x-NroRef AS CHAR.
DEFINE VAR x-Vcto AS CHAR INIT "". 
DEFINE VAR x-DoctoRef AS CHAR INIT "".
DEFINE VAR x-Tipo-DoctoRef AS CHAR INIT "".
DEFINE VAR lReferencia AS CHAR.
DEFINE VAR lReferencia1 AS CHAR.
DEFINE VAR lFEmisDocRef AS DATE.

x-DoctoRef = x-doc-referencia.
x-Tipo-DoctoRef = IF(SUBSTRING(x-doc-referencia,1,1) = "F") THEN "01" ELSE "03".
lFEmisDocRef = ?.

IF (SUBSTRING(x-doc-referencia,1,1) = "F") THEN DO:
    x-CodRef = 'FAC'.
END.
x-NroRef = SUBSTRING(x-doc-referencia,2,3) + SUBSTRING(x-doc-referencia,6).

/* Lo busco como FACTURA */
FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                ix-ccbcdocu.coddoc = x-CodRef AND 
                                ix-ccbcdocu.nrodoc = x-NroRef
                                NO-LOCK NO-ERROR.
IF NOT AVAILABLE ix-ccbcdocu THEN DO:   

    IF (SUBSTRING(x-doc-referencia,1,1) = "B") THEN DO:
        /* Lo busco como BOLETA */
        x-CodRef = 'BOL'.
        FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                        ix-ccbcdocu.coddoc = x-CodRef AND 
                                        ix-ccbcdocu.nrodoc = x-NroRef
                                        NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ix-ccbcdocu THEN DO:
            /* Lo busco como TICKET */
            x-CodRef = 'TCK'.
            FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                            ix-ccbcdocu.coddoc = x-CodRef AND 
                                            ix-ccbcdocu.nrodoc = x-NroRef
                                            NO-LOCK NO-ERROR.
        END.
    END.
END.

IF AVAILABLE ix-ccbcdocu THEN DO:

    lFEmisDocRef = ix-ccbcdocu.fchdoc.

    /* Fecha de inicio de la facturacion electronica de la tienda de donde se emitio la FAC/BOL */
    fFechaInicioFE = ?.
    FIND FIRST gn-div OF ix-ccbcdocu NO-LOCK NO-ERROR.
    IF AVAILABLE gn-div THEN DO:
        fFechaInicioFE = gn-divi.libre_f01.
    END.
    IF fFechaInicioFE = ? THEN DO:
        /*
        pReturn = "667|La tienda de donde se emitio el documento de referencia NO tiene configurado la fecha de inicio de facturacion electronica".
        RETURN .
        */
        x-Vcto = "0000-00-00".
    END.
    ELSE DO:
        x-Vcto =    STRING(YEAR(ix-ccbcdocu.fchdoc),"9999") + "-" + 
                    STRING(MONTH(ix-ccbcdocu.fchdoc),"99") + "-" + 
                    STRING(DAY(ix-ccbcdocu.fchdoc),"99").
        /* Si la fecha de emision del docmtno de referencia es menor al inicio de Facturacion Electronica */
        IF ix-ccbcdocu.fchdoc < fFechaInicioFE THEN DO:
            x-DoctoRef = "0" + SUBSTRING(x-DoctoRef,2).        
        END.

    END.
END.

/* Referencia */
lReferencia     = IF(SUBSTRING(x-doc-referencia,1,1)="B") THEN "BOLETA DE VENTA ELECTRONICA"
                   ELSE "FACTURA ELECTRONICA".
lReferencia1     = x-DoctoRef.
lReferencia1     = lReferencia1 + " - " + IF(lFEmisDocRef = ?) THEN "" 
                                       ELSE STRING(lFEmisDocRef,"99/99/9999").

lReferencia = lReferencia + " - " + lReferencia1.


x-Glosa  = TRIM(REPLACE(b-ccbcdocu.glosa,"|"," ")).
x-Glosa  = IF x-Glosa = "" THEN "Generacion de la N/D" ELSE x-Glosa.
x-Glosa  = fget-utf-8(x-Glosa).

p-xml-nota-debito = "<codigoSerieNumeroAfectado>" + x-motivo + "</codigoSerieNumeroAfectado>".
p-xml-nota-debito = p-xml-nota-debito + "<motivoDocumento>" + x-glosa + "</motivoDocumento>".
p-xml-nota-debito = p-xml-nota-debito + "<tipoDocumentoReferenciaPrincipal>" + x-Tipo-DoctoRef + "</tipoDocumentoReferenciaPrincipal>".
p-xml-nota-debito = p-xml-nota-debito + "<numeroDocumentoReferenciaPrincipal>" + SUBSTRING(x-DoctoRef,1,4) + "-" + SUBSTRING(x-DoctoRef,5) + "</numeroDocumentoReferenciaPrincipal>".

/**/
x-tipoDocumentoReferenciaPrincipal = x-Tipo-DoctoRef.
x-numeroDocumentoReferenciaPrincipal = SUBSTRING(x-DoctoRef,1,4) + "-" + SUBSTRING(x-DoctoRef,5).

p-xml-nota-debito = p-xml-nota-debito + "<codigoAuxiliar100_3>9030</codigoAuxiliar100_3>".
p-xml-nota-debito = p-xml-nota-debito + "<textoAuxiliar100_3>" + lReferencia + "</textoAuxiliar100_3>".


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pcodigo-afectacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pcodigo-afectacion Procedure 
PROCEDURE pcodigo-afectacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTipoDoc AS CHAR.
DEFINE INPUT PARAMETER pFormaPago AS CHAR.
DEFINE OUTPUT PARAMETER pCodAfectacion AS CHAR.

DEFINE VAR lRetval AS CHAR.

lRetval = "".

/*
10  Gravado - Operación Onerosa
21  Exonerado – Transferencia Gratuita
*/
lRetval = '10'. 
/* 19Julo2016 */

/* IF pFormaPago = '900' THEN DO:                                       */
/*     /* Por ahora estamos poniendo 15 sin afecto a IGV x promocion */ */
/*     /*lRetval = '21'.*/                                              */
/* END.                                                                 */
IF LOOKUP(pFormaPago, '899,900') > 0 THEN DO:
    /* Por ahora estamos poniendo 15 sin afecto a IGV x promocion */
    /*lRetval = '21'.*/
    lRetval = '13'.
END.

pCodAfectacion = lRetval.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pconcepto-tributario) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pconcepto-tributario Procedure 
PROCEDURE pconcepto-tributario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pFormaPago AS CHAR.
DEFINE OUTPUT PARAMETER pConceptoTributario AS CHAR.
/*
1001    Total valor de venta - operaciones gravadas     
1002    Total valor de venta - operaciones inafectas    
1003    Total valor de venta - operaciones exoneradas   
1004    Total valor de venta – Operaciones gratuitas    
1005    Sub total de venta      
2001    Percepciones    
2002    Retenciones     
2003    Detracciones    
2004    Bonifi caciones 
2005    Total descuentos        
3001    FISE (Ley 29852) Fondo Inclusión Social Energético      
*/

DEFINE VAR lRetVal AS CHAR.

lRetVal = '1001'.
/* IF pFormaPago = '900' THEN DO: */
/*     lRetVal = '1002'.          */
/* END.                           */
IF LOOKUP(pFormaPago, '899,900') > 0 THEN DO:
    lRetVal = '1004'.
END.

pConceptoTributario = lRetVal.

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

&IF DEFINED(EXCLUDE-penvio-documento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE penvio-documento Procedure 
PROCEDURE penvio-documento :
/*------------------------------------------------------------------------------
  Purpose:  Generar el Documento TXT y dejalo en el ePOS indicado
    Notes:  
    Return :    XXX - DDDDDDDDDDDDDDDDDD - XXX.XXX.XXX.XXX - XXXXXXXX
                
                xxx - Codigo del error 
                ddd.. - descripcion del error.
                XX.XX. - IP del ePos
                XXXX - ID del ePos
------------------------------------------------------------------------------*/

/* 02 : Envio del documento */
DEFINE INPUT PARAMETER pTipoDocto AS CHAR.
DEFINE INPUT PARAMETER pNroDocto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE VAR lRetval AS CHAR.
DEFINE VAR lIntento AS INT.

DEFINE VAR x-logmsg AS CHAR.
DEFINE VAR x-logtxt AS CHAR.

/* Validaciones */
IF LOOKUP(pTipoDocto, cDoctosValidos,",") = 0 THEN DO:
    pRetVal = "001|Documento debe ser  " + cDoctosValidos.
    RETURN .
END.

/* Validacion que no exista en en LOG (FELogComprobantes) */ 
DEFINE BUFFER b-FELogComprobantes FOR FELogComprobantes.

FIND FIRST b-FELogComprobantes WHERE b-FELogComprobantes.codcia = s-codcia AND 
                            b-FELogComprobantes.coddiv = pCodDiv AND
                            b-FELogComprobantes.coddoc = pTipoDocto AND 
                            b-FELogComprobantes.nrodoc = pNroDocto NO-LOCK NO-ERROR.

IF AVAILABLE b-FELogComprobantes THEN DO:
    pRetVal = "666|Documento ya esta PROCESADO en FELogComprobantes (Div:" + pCodDiv + 
                                        ", TDoc:" + pTipoDocto + ", NroDoc:" + pNroDocto + ")".
    RETURN .
END.

/*
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE VAR rRowId AS ROWID.

lRetVal = '002|Documento no existe'.
FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                            b-ccbcdocu.coddiv = pCodDiv AND
                            b-ccbcdocu.coddoc = pTipoDocto AND 
                            b-ccbcdocu.nrodoc = pNroDocto NO-LOCK NO-ERROR.

x-logmsg = " IP:" + pIP_EPOS + ", ID:" + pID_CAJA + ", DIVI:" + pCodDiv + ", TDOC:" + pTipoDocto + ", NroDoc:" + pNroDocto.

IF AVAILABLE b-ccbcdocu THEN DO:
    /* Guardo referencia */
    cTipoDocto = pTipoDocto.
    cNroDocto = pNroDocto.
    cDivision = pCodDiv.

    rRowId = ROWID(b-ccbcdocu).
    
    /* Intentos para grabar */
    REPEAT lIntento = 1 TO lReintentos:

        /* -- LOG ---- */        
        x-logtxt = flog-epos-txt("ENVIAR DOCTO(" + STRING(lIntento,">>9") + " (conexion epos) : " + x-logmsg).

        lRetVal = "664|Imposible conectar al ePOS(" + pIP_EPOS + ") al enviar la TRAMA".
        /* Conectar al ePOS */
        RUN pconexion-epos(INPUT pIP_EPOS, INPUT mNO_PORT, OUTPUT lRetVal).

        IF SUBSTRING(lRetVal,1,3) = "000" THEN DO:

            /* LOG */
            x-logtxt = flog-epos-txt("ENVIAR DOCTO(" + STRING(lIntento,">>9") + ") (genera TXT) : " + x-logmsg).

            /* el ID de la caja */
            mID_caja = pID_caja.

            lRetVal = '888|Opcion no implementada'.
            mFileTxt = "".
    
            /* Generacion del DOCUMENTO */
            CASE pTipoDocto:
                WHEN 'FAC'  THEN DO:
                    /* Facturas */        
                    RUN fac-generar-txt(INPUT pTipoDocto, INPUT pNroDocto, INPUT pCodDiv, OUTPUT lRetval).
                END.
                WHEN 'BOL' OR WHEN 'TCK' THEN DO:
                    /* Boletas */
                    RUN bol-generar-txt(INPUT pTipoDocto, INPUT pNroDocto, INPUT pCodDiv, OUTPUT lRetval).
                END.
                WHEN 'N/C' THEN DO:
                    /* Notas de Credito */
                    RUN nc-generar-txt(INPUT pTipoDocto, INPUT pNroDocto, INPUT pCodDiv, OUTPUT lRetval).
                END.
                WHEN 'N/D' THEN DO:
                    /* Notas de Debito */
                    RUN nd-generar-txt(INPUT pTipoDocto, INPUT pNroDocto, INPUT pCodDiv, OUTPUT lRetval).
                END.
            END CASE.
            
            IF SUBSTRING(lRetval,1,3) = '000' /*OR SUBSTRING(lRetval,1,3) = "888"*/  THEN DO:
                x-logtxt = flog-epos-txt("ENVIAR DOCTO(" + STRING(lIntento,">>9") + ") (OK) : " + x-logmsg + " MSG(" + lRetVal + ")").
                x-logtxt = flog-epos-txt("ENVIAR DOCTO(" + STRING(lIntento,">>9") + ")        MSG(" + lRetVal + ")").
                lIntento = lReintentos + 2.
            END.
        END.
        ELSE DO:
            x-logtxt = flog-epos-txt("ENVIAR DOCTO(" + STRING(lIntento,">>9") + ") (conexion epos - no se pudo conectar) : " + x-logmsg + " ERROR(" + lRetVal + ")").
        END.
    END.
END.

/* 000 : Generacion del documento OK */
IF SUBSTRING(lRetval,1,3) = '000' THEN DO:
    /* 
        Si el ePOS esta configurado con MODALIDAD PRE-ANULADO
        entonces se debe CONFIRMAR la generacion del documento
    */
END.
ELSE DO:
    /* 
        Si el ePOS esta configurado con MODALIDAD PRE-CONFIRMADO
        entonces se debe enviar una ANULACION del documento.
        POR CONFIRMAR ESTOOOOOOooooooo.....
    */
END.

*/

pRetVal = lRetVal.

END PROCEDURE.


/* Codigos de Retorno :
    000-Archivo enviado correctamente.
    001-Documento debe ser FAC, BOL, N/C, N/D, TCK
    002-Documento no existe
    003-No existe directorio de entrada
    004-Al generar TXT no existe Documento ???
    600-No existe data en el servidor
    601-Imposible leer el paquete de datos del servidor
    602-Se desconecto del servidor, cuando esperaba respuesta de este al generar BOLETA,FACTURA,N/C...etc
    664-Imposible conectar al ePOS(" + pIP_EPOS + ") al enviar la TRAMA
    665-Imposible ubicar el Origen del Documento".    /* casos de N/C y N/D*/
    666-Documento ya esta PROCESADO en FELogComprobantes    
    667-Operacion no retorno el HASH
    888-Opcion no implementada
    999-Imposible escribir en el e-POS".
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pestado-documento-sunat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pestado-documento-sunat Procedure 
PROCEDURE pestado-documento-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pTipoDocto AS CHAR.
DEFINE INPUT PARAMETER pNroDocto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

DEFINE VAR lUserSOL AS CHAR INIT "CONTINE2".
DEFINE VAR lPwdSOL AS CHAR INIT "iman10071325".
DEFINE VAR lUserName AS CHAR.
DEFINE VAR lPreFijoDocmnto AS CHAR.
DEFINE VAR lTipoDocmntoSunat AS CHAR.
DEFINE VAR lEnvioXML AS LONGCHAR.
DEFINE VAR lSerie AS CHAR.
DEFINE VAR lNroDoc AS CHAR.

DEFINE VAR lloadXML AS LOG.
DEFINE var loXmlMsg AS COM-HANDLE NO-UNDO.
DEFINE VAR loXmlRspta AS COM-HANDLE NO-UNDO.
DEFINE VAR lCodigo AS CHAR.
DEFINE VAR lMensaje AS CHAR.

pRetVal             = "".
lUserName           = cRucEmpresa + lUserSOL.
lPreFijoDocmnto     = fGet-prefijo-serie(pTipoDocto,pNroDocto,pCodDiv).
lTipoDocmntoSunat   = fget-tipo-documento(pTipoDocto).     /* Tipo Documento SUNAT */

lSerie = lPreFijoDocmnto + SUBSTRING(pNroDocto,1,3).
lNroDoc = SUBSTRING(pNroDocto,4).

lEnvioXML = "<soapenv:Envelope xmlns:ser='http://service.sunat.gob.pe'  
    xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/'
    xmlns:wsse='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'>
    <soapenv:Header>
    <wsse:Security>
    <wsse:UsernameToken>
    <wsse:Username>" + lUserName + "</wsse:Username>
    <wsse:Password>" + lPwdSOL + "</wsse:Password>
    </wsse:UsernameToken>
    </wsse:Security>
    </soapenv:Header>
    <soapenv:Body>
    <ser:getStatus>
    <rucComprobante>" + cRucEmpresa + "</rucComprobante>
    <tipoComprobante>" + lTipoDocmntoSunat + "</tipoComprobante>
    <serieComprobante>" + lSerie + "</serieComprobante>
    <numeroComprobante>" + lNroDoc + "</numeroComprobante>
    </ser:getStatus>
    </soapenv:Body>
    </soapenv:Envelope> ".

lloadXML = hoXMLBody:loadXML( lEnvioXML ).
IF NOT lloadXML THEN DO:
    RETURN.
END.

hoXmlHttp:OPEN( "POST", cURL_wdsl_SUNAT, NO ) .
hoXmlHttp:setRequestHeader( "Content-Type", "text/xml" ) .
hoXmlHttp:setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" ) . 
hoXmlHttp:setRequestHeader( "Content-Length", LENGTH(lEnvioXML) ) .
hoXmlHttp:SetRequestHeader( "SOAPAction" , "getStatus" ). 
hoXmlHttp:setOption( 2, 13056 ) .  /*SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056*/
         
hoXmlHttp:SEND(hoXMLBody:documentElement:XML) .

IF hoXmlHttp:status <> 200 THEN DO:
    /*
    MESSAGE loXmlHttp:responseText.
    */
        RETURN .
END.

CREATE "MSXML2.DOMDocument.6.0" loXmlRspta.
loXmlRspta:LoadXML(hoXmlHttp:responseText).
loXmlMsg = loXmlRspta:selectSingleNode( "//statusCode" ).

lCodigo = loXmlMsg:TEXT NO-ERROR.
loXmlMsg = loXmlRspta:selectSingleNode( "//statusMessage" ).
lMensaje = loXmlMsg:TEXT NO-ERROR.

pRetVal = lCodigo + "|" + lMensaje.

RELEASE OBJECT loXmlRspta NO-ERROR.
RELEASE OBJECT loXmlMsg NO-ERROR.

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pobtener-cdr-sunat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pobtener-cdr-sunat Procedure 
PROCEDURE pobtener-cdr-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pTipoDocto AS CHAR.
DEFINE INPUT PARAMETER pNroDocto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE INPUT PARAMETER pRutaCDR AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

DEFINE VAR lUserSOL AS CHAR INIT "CONTINE2".
DEFINE VAR lPwdSOL AS CHAR INIT "iman10071325".
DEFINE VAR lUserName AS CHAR.
DEFINE VAR lPreFijoDocmnto AS CHAR.
DEFINE VAR lTipoDocmntoSunat AS CHAR.
DEFINE VAR lEnvioXML AS LONGCHAR.
DEFINE VAR lSerie AS CHAR.
DEFINE VAR lNroDoc AS CHAR.

DEFINE VAR lloadXML AS LOG.
DEFINE var loXmlMsg AS COM-HANDLE NO-UNDO.
DEFINE VAR loXmlRspta AS COM-HANDLE NO-UNDO.
DEFINE VAR lCodigo AS CHAR.
DEFINE VAR lMensaje AS CHAR.

DEFINE VAR lContent AS LONGCHAR NO-UNDO.
DEFINE VARIABLE decdmptr AS MEMPTR   NO-UNDO.
DEFINE VAR lNomFileZipCDR AS CHAR.

pRetVal             = "".
lUserName           = cRucEmpresa + lUserSOL.
lPreFijoDocmnto     = fGet-prefijo-serie(pTipoDocto,pNroDocto,pCodDiv).
lTipoDocmntoSunat   = fget-tipo-documento(pTipoDocto).     /* Tipo Documento SUNAT */

lSerie = lPreFijoDocmnto + SUBSTRING(pNroDocto,1,3).
lNroDoc = SUBSTRING(pNroDocto,4).

lNomFileZipCDR = "cdr_" + cRucEmpresa + "_" + lTipoDocmntoSunat +
                    "_" + REPLACE(lSerie,"/","") + "-" + lNroDoc + ".zip".

lEnvioXML = "<soapenv:Envelope xmlns:ser='http://service.sunat.gob.pe'  
    xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/'
    xmlns:wsse='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'>
    <soapenv:Header>
    <wsse:Security>
    <wsse:UsernameToken>
    <wsse:Username>" + lUserName + "</wsse:Username>
    <wsse:Password>" + lPwdSOL + "</wsse:Password>
    </wsse:UsernameToken>
    </wsse:Security>
    </soapenv:Header>
    <soapenv:Body>
    <ser:getStatusCdr>
    <rucComprobante>" + cRucEmpresa + "</rucComprobante>
    <tipoComprobante>" + lTipoDocmntoSunat + "</tipoComprobante>
    <serieComprobante>" + lSerie + "</serieComprobante>
    <numeroComprobante>" + lNroDoc + "</numeroComprobante>
    </ser:getStatusCdr>
    </soapenv:Body>
    </soapenv:Envelope> ".

lloadXML = hoXMLBody:loadXML( lEnvioXML ).
IF NOT lloadXML THEN DO:
    /*MESSAGE loXMLBody:parseError:reason.
    RELEASE OBJECT loXmlHttp NO-ERROR.
    RELEASE OBJECT loXMLBody NO-ERROR.
    */
    RETURN.
END.

hoXmlHttp:OPEN( "POST", cURL_wdsl_SUNAT, NO ) .
hoXmlHttp:setRequestHeader( "Content-Type", "text/xml" ) .
hoXmlHttp:setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" ) . 
hoXmlHttp:setRequestHeader( "Content-Length", LENGTH(lEnvioXML) ) .
hoXmlHttp:SetRequestHeader( "SOAPAction" , "getStatusCdr" ). 
hoXmlHttp:setOption( 2, 13056 ) .  /*SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056*/
         
hoXmlHttp:SEND(hoXMLBody:documentElement:XML) .

IF hoXmlHttp:status <> 200 THEN DO:
    /*
    MESSAGE loXmlHttp:responseText.
    */
        RETURN .
END.

CREATE "MSXML2.DOMDocument.6.0" loXmlRspta.
loXmlRspta:LoadXML(hoXmlHttp:responseText).

loXmlMsg = loXmlRspta:selectSingleNode( "//statusCode" ).
lCodigo = loXmlMsg:TEXT NO-ERROR.

loXmlMsg = loXmlRspta:selectSingleNode( "//statusMessage" ).
lMensaje = loXmlMsg:TEXT NO-ERROR.

pRetVal = lCodigo + "|" + lMensaje.

loXmlMsg = loXmlRspta:selectSingleNode( "//content" ).
lContent = loXmlMsg:TEXT NO-ERROR.

/*MESSAGE lNomFileZipCDR lCodigo lMensaje.*/

IF lContent <> ? THEN DO:
    /*MESSAGE "OK".*/
    decdmptr = BASE64-DECODE(lContent).
    COPY-LOB FROM decdmptr TO FILE pRutaCDR + lNomFileZipCDR.
END.

RELEASE OBJECT loXmlRspta NO-ERROR.
RELEASE OBJECT loXmlMsg NO-ERROR.

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validar-condicion-venta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validar-condicion-venta Procedure 
PROCEDURE validar-condicion-venta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

    DEFINE VAR x-sec AS INT.
    DEFINE VAR x-vcmtos AS CHAR.
    DEFINE VAR x-cuota-anterior AS INT.
    DEFINE VAR x-cuota-actual AS INT.
    DEFINE VAR x-suma-factores AS INT.

    DEFINE VAR x-tabla AS CHAR INIT "CONFIG-VTAS".
    DEFINE VAR x-llave_01 AS CHAR INIT "SUNAT.CUOTAS".
    DEFINE VAR x-llave_02 AS CHAR INIT "COND.VTA".

    x-tipo-venta = "".
    x-cuotas = 0.
    REPEAT x-sec = 1 TO 30:
        x-cuotas-factor[x-sec] = 0.
        x-cuotas-vcto[x-sec] = ?.
    END.

    pRetVal = "OK".
    /* Solo si es Factura o nota de Credito */
    IF NOT (b-ccbcdocu.coddoc = 'FAC' /*OR b-ccbcdocu.coddoc = 'BOL'*/ OR b-ccbcdocu.coddoc = 'N/C') THEN DO:    
        RETURN "OK".
    END.
    IF (b-ccbcdocu.coddoc = 'N/C' AND SUBSTRING(x-doc-referencia,1,1) <> 'F') THEN DO:
        /* Es nota de Credito pero no hace referencia Factura */
        RETURN "OK".
    END.
    
    FIND FIRST gn-convt WHERE gn-convt.codig = b-ccbcdocu.fmapgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
        IF gn-convt.tipvta = '1' OR gn-convt.tipvta = '2' THEN DO:
            IF gn-convt.tipvta = '1' THEN DO:
                x-tipo-venta = "CONTADO".
            END.
            ELSE DO:
                IF TRUE <> (gn-convt.vencmtos > "") THEN DO:
                    pRetVal = b-ccbcdocu.fmapgo + " - Vencimientos de Cuotas no existe".
                    RETURN "ADM-ERROR".
                END.

                x-tipo-venta = "CREDITO".
                x-tabla = "CONFIG-VTAS".
                x-llave_01 = "SUNAT.CUOTAS".
                x-llave_02 = "COND.VTA".

                /* Verificamos si tiene particularidades */
                x-cuotas = 0.
                x-cuota-anterior = 0.
                x-suma-factores = 0.
                FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND
                                        vtatabla.tabla = x-tabla AND
                                        vtatabla.llave_c1 = x-llave_01 AND
                                        vtatabla.llave_c2 = x-llave_02 AND
                                        vtatabla.llave_c3 = b-ccbcdocu.fmapgo NO-LOCK BY valor[1]:
                    x-cuotas = x-cuotas + 1.
                    x-cuota-actual = vtatabla.valor[1].
                    /**/
                    IF x-cuota-actual <= 0 THEN DO:
                        pRetVal = b-ccbcdocu.fmapgo + " - Vencimientos de Cuota " + STRING(x-cuotas) + " debe ser mayor que CERO".
                        RETURN "ADM-ERROR".
                    END.
                    IF x-cuota-actual <= x-cuota-anterior THEN DO:
                        pRetVal = b-ccbcdocu.fmapgo + " - Vencimientos de Cuota " + STRING(x-cuotas) + " debe ser mayor a la cuota anterior".
                        RETURN "ADM-ERROR".
                    END.
                    x-cuotas-factor[x-cuotas] = vtatabla.valor[2].
                    x-cuotas-vcto[x-cuotas] = b-ccbcdocu.fchdoc + x-cuota-actual.
                    x-cuota-anterior = x-cuota-actual.       
                    x-suma-factores = x-suma-factores + vtatabla.valor[2].
                END.
                IF x-cuotas > 0 THEN DO:
                    IF x-suma-factores <> 100 THEN DO:
                        pRetVal = b-ccbcdocu.fmapgo + " - La suma de los %s de las cuotas no es 100%".
                        RETURN "ADM-ERROR".
                    END.
                    ELSE DO:
                        RETURN "OK".
                    END.
                END.

                /* Cuotas calculo automatico*/                
                x-vcmtos = TRIM(gn-convt.vencmtos).
                x-cuotas = NUM-ENTRIES(x-vcmtos,",").
                x-cuota-anterior = 0.
                x-suma-factores = 0.
                REPEAT x-sec = 1 TO x-cuotas:
                    IF TRUE <> (ENTRY(x-sec,x-vcmtos,",") > "") THEN DO:
                        pRetVal = b-ccbcdocu.fmapgo + " - Vencimientos de Cuota " + STRING(x-sec) + " esta errado".
                        RETURN "ADM-ERROR".
                    END.
                    x-cuota-actual = INTEGER(TRIM(ENTRY(x-sec,x-vcmtos,","))) NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN DO:
                        pRetVal = b-ccbcdocu.fmapgo + " - Vencimientos de Cuota " + STRING(x-sec) + " debe ser valor numerico".
                        RETURN "ADM-ERROR".
                    END.
                    IF x-cuota-actual <= 0 THEN DO:
                        pRetVal = b-ccbcdocu.fmapgo + " - Vencimientos de Cuota " + STRING(x-sec) + " debe ser mayor que CERO".
                        RETURN "ADM-ERROR".
                    END.
                    IF x-cuota-actual <= x-cuota-anterior THEN DO:
                        pRetVal = b-ccbcdocu.fmapgo + " - Vencimientos de Cuota " + STRING(x-sec) + " debe ser mayor a la cuota anterior".
                        RETURN "ADM-ERROR".
                    END.
                    /* Cargo los valores */
                    IF x-cuotas = 1 THEN DO:
                        x-cuotas-factor[x-sec] = 100.
                    END.
                    ELSE DO:
                        IF x-sec = x-cuotas THEN DO:
                            x-cuotas-factor[x-sec] = 100 - x-suma-factores.
                        END.
                        ELSE DO:
                            x-cuotas-factor[x-sec] = 100 / x-cuotas.
                            x-suma-factores = x-suma-factores + 100 / x-cuotas.
                        END.
                    END.                    
                    x-cuotas-vcto[x-sec] = b-ccbcdocu.fchdoc + x-cuota-actual.
                    x-cuota-anterior = x-cuota-actual.
                END.
            END.            
        END.
        ELSE DO:
            pRetVal = b-ccbcdocu.fmapgo + " - CONDICION NO INDICA SI LA VENTA 'CREDITO o CONTADO'".
        END.
    END.
    ELSE DO:
        pRetVal = b-ccbcdocu.fmapgo + " - CONDICION DE VENTA NO EXISTE".
    END.
    
    RETURN "OK".


END PROCEDURE.

/*
DEFINE VAR x-tipo-venta AS CHAR.
DEFINE VAR x-cuotas AS INT.
DEFINE VAR x-cuotas-factor AS DEC EXTENT 30.
DEFINE VAR x-cuotas-vcto AS DATE EXTENT 30.

*/

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

  x-retval = "".

  IF NOT ( TRUE <> (pTag > "")) AND NOT ( TRUE <> (pDato > "")) THEN DO:
      x-retval = "<" + TRIM(pTag) + ">" + TRIM(pDato) + "</" + TRIM(pTag) + ">".
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
  (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR) :

    /* pDivision : Puede ser vacio */

    DEFINE VAR lxRet AS CHAR.

    lxRet = '?'.

    IF pTipoDoc = 'N/C' OR pTipoDoc = 'N/D' THEN DO:

        DEFINE BUFFER z-ccbcdocu FOR ccbcdocu.            

        IF pDivision <> "" THEN DO:
            FIND FIRST z-ccbcdocu WHERE z-ccbcdocu.codcia = s-codcia AND 
                                        z-ccbcdocu.coddiv = pDivision AND
                                        z-ccbcdocu.coddoc = pTipoDoc AND 
                                        z-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
        END.
        ELSE DO:
            FIND FIRST z-ccbcdocu WHERE z-ccbcdocu.codcia = s-codcia AND 
                                        z-ccbcdocu.coddoc = pTipoDoc AND 
                                        z-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
        END.

        IF AVAILABLE z-ccbcdocu THEN DO:
            IF z-ccbcdocu.codref = 'LET' THEN DO:
                /* la Referencia es una LETRA, es un CANJE */
                /* Devuelve el documento Original F001001255 o B145001248 */
                lxRet = fget-doc-original(z-ccbcdocu.codref, z-ccbcdocu.nroref).                
                lxRet = SUBSTRING(lxRet,1,1).
            END.
            ELSE lxRet = fGet-Prefijo-Serie(z-ccbcdocu.codref, z-ccbcdocu.nroref, "").
        END.
        ELSE lxRet = '?'.

        /*RELEASE z-ccbcdocu.*/
    END.
    ELSE DO:
        IF pTipoDoc = 'FAC' THEN lxRet = 'F'.
        IF pTipoDoc = 'BOL' OR pTipoDoc = 'TCK' THEN lxRet = 'B'.        
    END.


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

    x-archivo = session:TEMP-DIRECTORY + "LOG-ENVIO-SUNAT-" + x-file + ".txt".

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

RETURN "".  

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

