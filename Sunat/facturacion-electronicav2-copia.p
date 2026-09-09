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

DEFINE SHARED VAR s-codcia AS INT.

/* Datos del Documento */
DEFINE VAR cTipoDocto AS CHAR FORMAT 'x(2)'.
DEFINE VAR cNroDocto AS CHAR.
DEFINE VAR cDivision AS CHAR.
DEFINE VAR fFechaInicioFE AS DATE.  

fFechaInicioFE = 06/10/2016.

/* Directorios - Carpeta Compartida 
    - Se dejos sin efecto, pero los programas quedan, se opto por EPOS */
DEFINE VAR cPathHome AS CHAR.
DEFINE VAR cPathPPL AS CHAR.
DEFINE VAR cPathEntrada AS CHAR.
DEFINE VAR cPathSalida AS CHAR.
DEFINE VAR cPathEstado AS CHAR.
DEFINE VAR cFile_DE AS LONGCHAR.

DEFINE VAR cPathTemporal AS CHAR.

cPathHome = "\\192.168.100.245".

cPathPPL = cPathHome + "\dte\20100038146" .

cPathEntrada = cPathPPL + "\OnLine\Entrada".
cPathSalida = cPathPPL + "\OnLine\Salida".
cPathEstado = cPathPPL + "\Estado".

/**/
cPathTemporal = "\\192.168.100.217\newsieold\FE_BORRAR".

/* e-POS */
DEFINE SHARED VARIABLE hSocket AS HANDLE NO-UNDO.
/*DEFINE VARIABLE mID_ePOS AS CHAR.       /* ID del ePOS */*/
DEFINE VARIABLE mID_caja AS CHAR.       /* ID de la caja */
DEFINE VARIABLE mIP_ePOS AS CHAR.       /* IP del ePOS */
DEFINE VARIABLE mNO_PORT AS CHAR.       /* Puerto */
DEFINE VARIABLE mHeader AS MEMPTR NO-UNDO.
DEFINE VARIABLE mData AS MEMPTR NO-UNDO.
DEFINE VARIABLE mFileTxt AS CHAR.
DEFINE VARIABLE mModoPrueba AS CHAR INIT '0'.   /* 1 : Prueba   <> 1: Produccion*/
DEFINE VARIABLE lReintentos AS INT.             /* Cuantas veces debe intentar grabar en el ePOS */

/* Caracteres de control del e-POS */
DEFINE VARIABLE mSeparador AS CHAR.
DEFINE VARIABLE mControlIniMsg AS CHAR INIT '@**@'.
DEFINE VARIABLE mControlFinMsg AS CHAR INIT '*@@*'.
DEFINE VARIABLE mControlIniRpta AS CHAR.
DEFINE VARIABLE mControlFinRpta AS CHAR.
DEFINE VARIABLE gcCRLF           AS CHARACTER   NO-UNDO. 

/* set the Carraige return/line feed we need to delimit the scripts */ 
ASSIGN gcCRLF = CHR(13) + CHR(10). 
ASSIGN mControlIniRpta = CHR(2)     /* STX */
        mControlFinRpta = CHR(3).   /* ETX */

lReintentos = 3.

/* Data del servidor/cliente */
DEFINE VARIABLE mDataServer AS CHAR NO-UNDO.
DEFINE VARIABLE mDataServer1 AS CHAR NO-UNDO.
DEFINE VARIABLE mDataClient AS LONGCHAR.

mSeparador = CHR(9).

/* De los documentos */
DEFINE VAR cDoctosValidos AS CHAR.
DEFINE VAR cTipoDoctoSunat AS CHAR FORMAT 'x(2)'.
DEFINE VAR cSerieSunat AS CHAR FORMAT 'x(4)'.
DEFINE VAR cCorrelativoSunat AS CHAR FORMAT 'x(6)'.
DEFINE VAR lFmtoImpte AS CHAR INIT ">>>>>>9.99".

DEFINE VAR lConceptoTributario AS CHAR.

cDoctosValidos = "FAC,BOL,TCK,N/C,N/D".

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
    /*Calle Rene Descartes Mz C Lt 1, Urb. Sta. Raquel 2da.Etapa - ATE - LIMA - LIMA".*/
cUBIGEO = "150103".

/* WebServices */
DEFINE VAR cURL_wdsl_EGATEWAY AS CHAR.
DEFINE VAR cURL_wdsl_ESERVER AS CHAR.
DEFINE VAR cURL_wdsl_SUNAT AS CHAR.

DEFINE SHARED VARIABLE hWebService     AS HANDLE NO-UNDO.
DEFINE SHARED VARIABLE hPortType       AS HANDLE NO-UNDO.

DEFINE VAR hoXmlHttp AS COM-HANDLE NO-UNDO.
DEFINE VAR hoXMLBody AS com-HANDLE NO-UNDO.

cURL_wdsl_EGATEWAY = 'http://192.168.100.249:8060/axis2/services/Online?wsdl'.
cURL_wdsl_ESERVER = 'http://asp402r.paperless.com.pe/axis2/services/Online?wsdl'.
/*cURL_wdsl_SUNAT = 'https://www.sunat.gob.pe/ol-it-wsconscpegem/billConsultService?wsdl'.*/
cURL_wdsl_SUNAT = "https://www.sunat.gob.pe:443/ol-it-wsconscpegem/billConsultService".
cURL_wdsl_SUNAT = "https://www.sunat.gob.pe:443/ol-it-wsconscpegem/billConsultService?wsdl".

/* Los ePOS */
DEFINE TEMP-TABLE tt-ePos
    FIELDS  tt-sec  AS CHAR     FORMAT 'x(5)'
    FIELDS  tt-ip   AS CHAR     FORMAT 'x(20)'
    FIELDS  tt-id   AS CHAR     FORMAT 'x(15)'
    FIELDS tt-port  AS CHAR     FORMAT 'x(10)'
    INDEX idx0 tt-sec ASCEN.


/* - */
DEFINE STREAM sFileTxt.
DEFINE VAR mShowMsg AS LOG INIT NO.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR cDATAQR AS CHAR INIT "".

define stream log-epos.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fDesconectar-epos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDesconectar-epos Procedure 
FUNCTION fDesconectar-epos RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fEstado-PPL-documento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado-PPL-documento Procedure 
FUNCTION fEstado-PPL-documento RETURNS CHARACTER
    ( INPUT pTipoDocto AS CHAR, INPUT pNroDocto AS char, INPUT pCodDiv  AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-fGet-Prefijo-Serie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fGet-Prefijo-Serie Procedure 
FUNCTION fGet-Prefijo-Serie RETURNS CHARACTER
  (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-fget-url) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-url Procedure 
FUNCTION fget-url RETURNS CHARACTER
  (INPUT pTipoDoc AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-fget_id_pos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget_id_pos Procedure 
FUNCTION fget_id_pos RETURNS CHARACTER
  ( INPUT pDivision AS CHAR )  FORWARD.

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
         HEIGHT             = 28.19
         WIDTH              = 64.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-bol-generar-txt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bol-generar-txt Procedure 
PROCEDURE bol-generar-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pTipoDocmto AS CHAR.
DEFINE INPUT PARAMETER pNroDocmto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pReturn AS CHAR NO-UNDO.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.

/*FIND FIRST b-ccbcdocu WHERE ROWID(b-ccbcdocu)=pRowid NO-LOCK NO-ERROR.*/
FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                            b-ccbcdocu.coddiv = pCodDiv AND 
                            b-ccbcdocu.coddoc = pTipoDocmto AND 
                            b-ccbcdocu.nrodoc = pNroDocmto
                            NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-ccbcdocu  THEN DO:
    pReturn = "004|No existe documento (Generarando trama)".
    RETURN .
END.
IF b-ccbcdocu.flgest = 'A' THEN DO:
    pReturn = "004|Documento esta ANULADO (Generando trama)".
    RETURN .
END.

DEFINE VAR cFileSunat AS CHAR.
DEFINE VAR dDescuentos AS DEC.
DEFINE VAR lxitem AS INT.
DEFINE VAR lxNumTexto AS CHAR.
DEFINE VAR lxRucCli AS CHAR.
DEFINE VAR lxNomCli AS CHAR.
DEFINE VAR lxDirCli AS CHAR.
DEFINE VAR lxTipoIde AS CHAR.
DEFINE VAR lxImpTot AS DEC.

DEFINE VAR lRC AS LOG.
DEFINE VAR lFmtoImpte AS CHAR INIT ">>>>>>9.99".
DEFINE VAR lCodRet AS CHAR.
DEFINE VAR lMoneda AS CHAR.
DEFINE VAR lFPago AS CHAR.
DEFINE VAR lGuiaRemision AS CHAR.
DEFINE VAR lPersonalizados AS CHAR INIT "".
DEFINE VAR lCdoigoDeAfectacion AS CHAR.
DEFINE VAR lMarca AS CHAR.

DEFINE VAR lImpGravado AS DEC.

/* URL */
/*cURLDocumento = fget-url(b-ccbcdocu.coddoc).*/

cDATAQR = "".
cTipoDoctoSunat = '03'.
cSerieSunat = fGet-prefijo-serie(b-ccbcdocu.coddoc, b-ccbcdocu.nrodoc, b-ccbcdocu.coddiv).
cSerieSunat = cSerieSunat  +  SUBSTRING(b-ccbcdocu.nrodoc,1,3).

cCorrelativoSunat = SUBSTRING(b-ccbcdocu.nrodoc,4).

lxImpTot = b-ccbcdocu.imptot.
lxRucCli = IF (b-ccbcdocu.ruccli = ?) THEN "" ELSE TRIM(b-ccbcdocu.ruccli).
lxNomCli = IF (b-ccbcdocu.nomcli = ?) THEN "" ELSE TRIM(b-ccbcdocu.nomcli).
lxDirCli = IF (b-ccbcdocu.dircli = ?) THEN "" ELSE b-ccbcdocu.dircli.
lxTipoIde = '6'.
/* UTF-8 */
lxNomCli = fget-utf-8(lxNomCli).
lxDirCli = fget-utf-8(lxDirCli).

/* dDescuentos = (b-ccbcdocu.impdto + b-ccbcdocu.impdto2).  10Abr2018 - Segun Ruben no va el IMPDTO */
dDescuentos = (b-ccbcdocu.impdto2).

IF lxImpTot > 700.00 THEN DO:
    IF lxRucCli = "" THEN DO:
        lxRucCli = IF (b-ccbcdocu.codant = ?) THEN "" ELSE TRIM(b-ccbcdocu.codant).
        lxTipoIde = '1'.
        IF lxRucCli = "" OR lxRucCli BEGINS "11111" THEN DO:
            lxRucCli = "12345678".            
        END.
        ELSE DO:
            /* 8 Digitos de DNI */
            lxRucCli = "00000000" + lxRucCli.            
            lxRucCli = SUBSTRING(lxRucCli, (LENGTH(lxRucCli) - 8) + 1).
        END.
    END.
    ELSE DO:
        IF LENGTH(lxRucCli) = 11 AND SUBSTRING(lxRucCli,1,3) = '000' THEN DO:
            /* Es DNI */
            lxRucCli = STRING(INTEGER(lxRucCli),"99999999").
            lxTipoIde = '1'.
        END.    
    END.
END.
ELSE DO: 
    IF LENGTH(lxRucCli) = 11 AND SUBSTRING(lxRucCli,1,3) = '000' THEN DO:
        lxRucCli = '0'.
        lxTipoIde = '0'.
        lxNomCli = '-'.
        lxDirCli = "".
    END.
    IF LENGTH(lxRucCli) <> 11 THEN lxRucCli = '0'.    
    IF LENGTH(lxRucCli) <> 11 THEN lxTipoIde = '0'.    
    IF LENGTH(lxRucCli) <> 11 THEN lxNomCli = '-'.    
    IF LENGTH(lxRucCli) <> 11 THEN lxDirCli = ''.    
END.
    
/* Data a enviar al e-POS */
mDataClient = mControlIniMsg + "2" + mSeparador + mModoPrueba + mSeparador + cRucEmpresa
                + mSeparador + mID_caja + mSeparador + cTipoDoctoSunat + mSeparador.

lMoneda = IF(b-ccbcdocu.codmon = 1) THEN 'PEN' ELSE 'USD'.
mDataClient = mDataClient + "EN|" +
        cTipoDoctoSunat + "|" +
        cSerieSunat + "-" + cCorrelativoSunat + "|" +
        "|" +     /* Tipo de N/C o N/D */
        "|" +     /* Factura que referencia la N/C */
        "|" +    /* Sustento */
        STRING(YEAR(b-ccbcdocu.fchdoc), "9999") + "-" + STRING(MONTH(b-ccbcdocu.fchdoc),"99") + "-" + STRING(DAY(b-ccbcdocu.fchdoc),"99") + "|" +
        lMoneda + "|" +
        cRucEmpresa + "|" +
        "6|" +   /* Tipo de Identificador del emisor */
        TRIM(cNombreComercial) + "|"  +
        TRIM(cRazonSocial) +  "|" +
        cUbigeo + "|" +    /* Codigo UBIGEO emisor */
        cDirecEmisor + "|" +    /* Direccion Emisor */
        "|" +    /* Departamento emisor (Ciudad) */
        "|" +    /* Provincia emisor (Comuna) */
        "|" +    /* Distrito Emisor */
        TRIM(lxRucCli) + "|" +
        lxTipoIde + "|"  +  /* Tipo identificacion Receptor */
        lxNomCli + "|" + 
        TRIM(REPLACE(lxDirCli,"|", " ")) + "|" +
        STRING(b-ccbcdocu.impbrt,lFmtoImpte) + "|" +
        STRING(b-ccbcdocu.impigv,lFmtoImpte) + "|" +
        STRING(dDescuentos,lFmtoImpte) + "|" +
        "|" +    /* Monto Recargos */
        STRING(b-ccbcdocu.imptot,lFmtoImpte) + "|" +
        "|" +    /* Codigos de otros conceptos tributarios o comerciales recomendados */
        "|" +    /* Total Valor Venta neto */
        lxRucCli + "|" +
        lxTipoIde +   /* Tipo documento del adquiriente */
        gcCRLF.

/* DOC */
/* 19Jul2016 - No se debe considerar la forma de pago */
/*
IF b-ccbcdocu.fmapgo = '900' THEN DO:
    /* Toda la factura con cond.pago 900 es una operacion GRATUITA */
    mDataClient = mDataClient + "DOC|" +
        "1004|" + 
        STRING(b-ccbcdocu.impvta,lFmtoImpte) + 
        gcCRLF.
END.
ELSE DO:
*/    
    IF b-ccbcdocu.fmapgo <> '899' AND b-ccbcdocu.porigv = 0.00 THEN DO:
        /* Operacion Inafectas */
        mDataClient = mDataClient + "DOC|" +
            "1002|" + 
            STRING(b-ccbcdocu.impvta,lFmtoImpte) + 
            gcCRLF.
    END.
    ELSE DO:
        lConceptoTributario = "1001".
        RUN pConcepto-Tributario(INPUT b-ccbcdocu.coddoc, INPUT b-ccbcdocu.fmapgo, OUTPUT lConceptoTributario).
        
        lImpGravado = b-ccbcdocu.impvta.
        /* Operaciones Gratuitas */
        IF b-ccbcdocu.fmapgo = '899' THEN lImpGravado = b-ccbcdocu.impbrt.

        /* Operacion Gravadas */
        mDataClient = mDataClient + "DOC|" +
            lConceptoTributario + "|" +
            STRING(lImpGravado,lFmtoImpte) + 
            gcCRLF.            
        IF b-ccbcdocu.impexo > 0 THEN DO:                
            /* Operacion Exoneradas */
            mDataClient = mDataClient + "DOC|" +
                "1003|" +
                STRING(b-ccbcdocu.impexo,lFmtoImpte) +
                gcCRLF.
        END.            
        /* Bonificaciones ( hay que leer el detalle del docto campo linre_c05='OF' ) */
        
        IF dDescuentos > 0 THEN DO:
            /* Descuientos */
            mDataClient = mDataClient + "DOC|" + 
                "2005|" +
                STRING(dDescuentos,lFmtoImpte) + 
                gcCRLF.
        END.
    END.

/*END.*/

lxNumTexto = "".
RUN lib\_numero.R(INPUT b-ccbcdocu.imptot, 2, 1, OUTPUT lxNumTexto).

/* UTF-8 */
lxNumTexto = fget-utf-8(lxNumTexto).

IF lMoneda = 'PEN' THEN DO:
    lxNumTexto = lxNumTexto + " SOLES".
END.
ELSE DO:
    lxNumTexto = lxNumTexto + " DOLARES AMERICANOS".
END.

mDataClient = mDataClient + "DN|" +
    "1|" +
    "1000|" +
    lxNumTexto +
    gcCRLF.

DEFINE VAR lPrecioUnit AS DEC.
DEFINE VAR lImpItmVVta AS DEC.
DEFINE VAR lVVtaUnit AS DEC.
DEFINE VAR lVVtaItem AS DEC.
DEFINE VAR lxDesMat AS CHAR INIT "".

DEFINE VAR lSumaIgv AS DEC.
DEFINE VAR lIgvImpDto2 AS DEC.  /* IGV del Descuento Final aplicado a cada item */
DEFINE VAR lImpIgvLin AS DEC.   /* IGV de cada item */


lxitem = 1.
lSumaIgv = 0.
FOR EACH b-ccbddocu OF b-ccbcdocu NO-LOCK:

    FIND FIRST almmmatg OF b-ccbddocu NO-LOCK NO-ERROR.

    lPrecioUnit = ROUND((b-ccbddocu.implin - b-ccbddocu.ImpDto2) / b-ccbddocu.candes , 4).
    lImpItmVVta = (b-ccbddocu.implin - b-ccbddocu.ImpDto2).  /* Casos inafectos */
    IF b-ccbcdocu.fmapgo <> '899' AND b-ccbcdocu.porigv > 0 THEN DO:
        lImpItmVVta = ROUND((b-ccbddocu.implin - b-ccbddocu.ImpDto2) /  (1 + ( b-ccbcdocu.porigv / 100 )) ,  2).
    END.
    lVVtaUnit = ROUND(lImpItmVVta / b-ccbddocu.candes,2).
    lVVtaItem = ROUND(b-ccbddocu.candes * lVVtaUnit,2).
    lxDesMat = fget-descripcion-articulo(b-ccbddocu.codmat, b-ccbcdocu.coddoc, b-ccbcdocu.cndcre, b-ccbcdocu.tpofac).
    lMarca = IF (AVAILABLE almmmatg) THEN fget-utf-8(almmmatg.desmar) ELSE "".
    IF b-ccbcdocu.tpofac = 'S' THEN DO:
       /* Factura SERVICIOS no va MARCA */
       lMarca = "".
    END.

    /* UTF-8 */
    lxDesMat = fget-utf-8(lxDesMat).

    lFPago = '01'.    
    /* Transferencia Gratuita */
    lFPago = IF (b-ccbcdocu.fmapgo = '899') THEN '02' ELSE "01".    

    mDataClient = mDataClient + "DE|" +
        STRING(lxItem,">>>9") + "|" +
        STRING(lPrecioUnit,">>>>>>9.9999") + "|" +   /* 03Ago2016 - P.Uni a 4 digitos */ 
        /*STRING(lPrecioUnit,lFmtoImpte) + "|" +   /* 03Ago2016 - P.Uni a 4 digitos */*/
        fget-unidad-medida(b-ccbddocu.undvta) + "|" +
        STRING(b-ccbddocu.candes,lFmtoImpte) +  "|" +
        STRING(lImpItmVVta,lFmtoImpte) + "|" +
        b-ccbddocu.codmat + "|" +
        lFPago + "|" +
        STRING(lVVtaUnit,lFmtoImpte) + "|" +
        STRING(lVVtaItem,lFmtoImpte) + "|" + 
        "|" +
        lMarca + 
        gcCRLF.

   mDataClient = mDataClient + "DEDI|" +
       TRIM(lxDesMat) +
       gcCRLF.

   IF b-ccbddocu.ImpDto2 > 0 THEN DO:
       mDataClient = mDataClient +  "DEDR|" +
           "false|" + 
            STRING(b-ccbddocu.ImpDto2,lFmtoImpte) +
           gcCRLF.
   END.

    lCdoigoDeAfectacion = '10'. 
    RUN pcodigo-afectacion(INPUT b-ccbcdocu.coddoc, INPUT b-ccbcdocu.fmapgo, OUTPUT lCdoigoDeAfectacion).
    /* 19Julo2016 */
    /*    
    IF b-ccbcdocu.fmapgo = '900' THEN DO:
        /* Por ahora estamos poniendo 15 sin afecto a IGV x promocion */
        lCdoigoDeAfectacion = '15'.
    END.
    */

    IF b-ccbddocu.impigv > 0 THEN DO:

        lImpIgvLin = b-ccbddocu.impigv.
        lIgvImpDto2 = 0.
        IF b-ccbddocu.aftigv = YES AND b-ccbcdocu.porigv > 0
            THEN lIgvImpDto2 = ROUND(b-ccbddocu.impdto2 / ( 1 + b-ccbcdocu.porigv) * b-ccbcdocu.porigv, 4).
        lImpIgvLin = lImpIgvLin - lIgvImpDto2.

        mDataClient = mDataClient + "DEIM|" +
            STRING(lImpIgvLin,lFmtoImpte) + "|" +
            /*STRING(b-ccbddocu.impigv,lFmtoImpte) + "|" +*/
            STRING(lImpItmVVta,lFmtoImpte) + "|"  +
            STRING(ROUND(lImpIgvLin,2),lFmtoImpte) + "|" +
            /*STRING(ROUND(b-ccbddocu.impigv,2),lFmtoImpte) + "|" +*/
            STRING(b-ccbcdocu.porigv,lFmtoImpte) + "|" +
            "|" +
            lCdoigoDeAfectacion + "|" +
            "|" +
            "1000|" +
            "IGV|" +
            "VAT" +
            gcCRLF.
        lSumaIgv = lSumaIgv + ROUND(lImpIgvLin,2).
        /*lSumaIgv = lSumaIgv + ROUND(b-ccbddocu.impigv,2).*/
    END.
    ELSE DO:
        /* caso sin IGV ????? */
    END.

    lxItem = lxItem + 1.
END.

IF lSumaIgv > 0 THEN DO:
    mDataClient = mDataClient + "DI|" +
        STRING(lSumaIgv,lFmtoImpte) + "|" +
        STRING(lSumaIgv,lFmtoImpte) + "|" +
        "1000|" +
        "IGV|" +
        "VAT|" +
        gcCRLF.

END.

/* GUIA REMISION */
DEFINE BUFFER bx-ccbcdocu FOR ccbcdocu.
FOR EACH bx-ccbcdocu WHERE bx-ccbcdocu.codcia = s-codcia AND
                            bx-ccbcdocu.coddoc = 'G/R' AND
                            bx-ccbcdocu.codref = b-ccbcdocu.coddoc AND 
                            bx-ccbcdocu.nroref = b-ccbcdocu.nrodoc
                            NO-LOCK :
    lGuiaRemision = IF(bx-ccbcdocu.nrodoc = ?) THEN "" ELSE TRIM(bx-ccbcdocu.nrodoc). 

    IF lGuiaRemision <> "" THEN DO:
        lGuiaRemision = "0" + SUBSTRING(bx-ccbcdocu.nrodoc,1,3) + "-" + 
                        SUBSTRING(bx-ccbcdocu.nrodoc,4) NO-ERROR.

        mDataClient = mDataClient + "RE|" + 
            "||||" +
            lGuiaRemision + "|" +
            "09|||" + 
            gcCRLF.
    END.
END.
/*RELEASE bx-ccbcdocu.*/

mDataClient = mDataClient + "PE|" +
    "GLOSAMONTO|" +
    lxNumTexto +
    gcCRLF.

/* Personalizados */
lPersonalizados = fget-personalizados(b-ccbcdocu.tipo, pTipoDocmto, pNroDocmto, pCodDiv).
mDataClient = mDataClient + lPersonalizados.

/* Correo del Cliente */
mDataClient = mDataClient + fget-email-cliente(b-ccbcdocu.codcli).
/*
RELEASE b-ccbcdocu.
RELEASE b-ccbddocu.
*/
RELEASE gn-div.
RELEASE gn-convt.

/* Enviamos la data al e-POS */
mDataClient = mDataClient + mControlFinMsg.

IF USERID("integral") = 'ADMIN' OR USERID("integral") = 'MASTER' THEN DO:
    COPY-LOB mDataClient TO FILE cPathTemporal + "\" + cSerieSunat + "-" + cCorrelativoSunat + 
        "-" + cTipoDoctoSunat + ".txt" NO-ERROR.
END.

IF NOT USERID("integral") = "MASTER" THEN DO:
    /* Set size of memory pointer to write server socket */
    SET-SIZE(mData) = 0.
    SET-SIZE(mData) = LENGTH(mDataClient) + 1.
    SET-BYTE-ORDER(mData) = BIG-ENDIAN.
    PUT-STRING(mData,1,LENGTH(mDataClient) + 1) = mDataClient.

    /* Write the whole thing to the server socket */
    lRC = hSocket:WRITE(mData,1,GET-SIZE(mData)) NO-ERROR.

    pReturn = "000|Escritura OK en el e-POS".
    IF lRC = FALSE OR ERROR-STATUS:ERROR = YES THEN DO:
      pReturn = "999|Imposible escribir en el e-POS(" + ERROR-STATUS:GET-MESSAGE(1) + ")".
      SET-SIZE(mData) = 0.
    END.

    IF SUBSTRING(pReturn,1,3)="000"  THEN DO:
        /* A esperar la respuesta del Server */    
        hSocket:SET-READ-RESPONSE-PROCEDURE('pProcessServerResponse', THIS-PROCEDURE).

        IF hSocket:CONNECTED() THEN DO: 
          /* Esperando respuesta */
          mDataServer = "".
          WAIT-FOR READ-RESPONSE OF hSocket. 
          /* Cadena devuelta por el e-POS */
          mDataServer = REPLACE(mDataServer,mControlIniRpta,"").    /* STX */
          mDataServer = REPLACE(mDataServer,mControlFinRpta,"").    /* ETX */

          pReturn = mDataServer.
          /*pReturn = REPLACE(mDataServer,mSeparador,"|").*/

          lCodRet = ENTRY(1,pReturn,mSeparador).
          IF (lCodRet = '0' OR lCodRet = '00') AND NUM-ENTRIES(pReturn,mSeparador) > 4 THEN DO:
                /* 000|mmmmeeeennnnssssaajjee|Codigo HASH */
                /*pReturn = "000" + "|" + ENTRY(2,pReturn,mSeparador) + "|" + ENTRY(5,pReturn,mSeparador).*/
                /* Ic - QR */
                cDATAQR = ENTRY(4,pReturn,mSeparador).
                cDATAQR = ENTRY(1,cDATAQR,"|") + "|" + ENTRY(2,cDATAQR,"|") + "|" + ENTRY(3,cDATAQR,"|") + "|" +
                            ENTRY(4,cDATAQR,"|") + "|" + ENTRY(5,cDATAQR,"|") + "|" + ENTRY(6,cDATAQR,"|") + "|" + 
                            ENTRY(7,cDATAQR,"|") + "|" + ENTRY(8,cDATAQR,"|") + "|" + ENTRY(9,cDATAQR,"|").
                cDATAQR = REPLACE(cDataQR,"|","@").
                pReturn = "000" + "|" + ENTRY(2,pReturn,mSeparador) + "|" + ENTRY(5,pReturn,mSeparador) + "|" + cDataQR.
          END.
          ELSE DO: 
                pReturn = "667|Operacion no retorno el HASH(" + mDataServer + ")".
          END.

        END.        
        ELSE DO:
            pReturn = "602|Se desconecto del servidor, cuando esperaba respuesta de este al generar BOLETA".
        END.
    END.
END.
ELSE DO:
    pReturn = "-222|User MASTER".
END.

/*MESSAGE pReturn.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-borrar-pconectar-epos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE borrar-pconectar-epos Procedure 
PROCEDURE borrar-pconectar-epos :
/*------------------------------------------------------------------------------
  Purpose:  Conectarse al e-POS via Socket
    Notes:  
------------------------------------------------------------------------------*/

/*
    Se conecta al ePos dando como referencia la division.
    pConecto-epos(Division, IdCaja, RetVal) usado RUBEN en las cajas y/o facturacion
*/


DEFINE INPUT    PARAMETER pDivision AS CHAR.
DEFINE INPUT    PARAMETER pID_POS AS CHAR.
DEFINE OUTPUT   PARAMETER pRetVal AS CHAR.

DEFINE VAR lRetVal AS CHAR.
DEFINE VAR lHost AS CHAR.
DEFINE VAR lPort AS CHAR.
DEFINE VAR lStrConn AS CHAR.

DEFINE VAR lConexionVal AS CHAR INIT "***".

cDivision = "".

/* Buscamos la division en las configuraciones de e-POS */
FIND FIRST FECFGEPOS WHERE FECFGEPOS.codcia = s-codcia AND
                            FECFGEPOS.coddiv = pDivision /*AND
                            FECFGEPOS.ID_POS = pID_POS */         /* 02Jun2016 */
                            NO-LOCK NO-ERROR.
IF AVAILABLE FECFGEPOS THEN DO:

    cDivision = pDivision.
   
    /* Desconectamos el e-POS */    
    fDesconectar-epos().

    lRetVal = '002|No tiene configurado el IP y/o Puerto del e-POS en tabla FECFGEPOS'.

    FOR EACH FECFGEPOS NO-LOCK WHERE FECFGEPOS.codcia = s-codcia AND 
                            FECFGEPOS.coddiv = pDivision 
                            BY FECFGEPOS.tipo:
        /* Parametros conexion del e-POS */
        lHost = TRIM(FECFGEPOS.IP_EPOS).
        lPort = TRIM(FECFGEPOS.PORT_EPOS). 
        mID_caja = TRIM(FECFGEPOS.ID_POS).     
        mIP_ePOS = TRIM(FECFGEPOS.IP_EPOS).

        IF lHost <> '' AND lPort <> '' THEN DO:
            /* Conectar el e-POS */
            lRetVal = "000|Conexion Ok".
            lStrConn = "-H " + lHost + " -S " + lPort.
            hSocket:CONNECT(lStrConn) NO-ERROR.        
            IF hSocket:CONNECTED() = YES THEN DO:
                /* Configuracion del e-POS */            
                lRetVal = "".
                RUN pConfigurar-epos(OUTPUT lRetval).
                IF SUBSTRING(lRetVal,1,3)="000"  THEN DO:
                    lRetVal = lRetVal + "|" + lHost + "|" + mID_caja.
                    LEAVE.
                END.                
                ELSE DO:
                    /* Desconectamos el e-POS si no se puede Configurar */    
                    fDesconectar-epos().
                END.
            END.
            ELSE lRetVal = "999|Imposible conectarse al e-Pos -  Host(" + lHost + 
                            ") Port(" + lPort + ") ID (" + mID_caja + ") - Divi:" + pDivision .
        END.

    END.
END.
ELSE DO:
    lRetVal = "001|Division(" + pDivision + ") no esta inscrito en la tabla FECFGEPOS de e-POS".
END.

pRetVal = lRetVal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-borrar-pconfirmar-documento-preanulado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE borrar-pconfirmar-documento-preanulado Procedure 
PROCEDURE borrar-pconfirmar-documento-preanulado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTipoDocto AS CHAR.
DEFINE INPUT PARAMETER pNroDocto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

DEFINE VAR lRetval AS CHAR.
DEFINE VAR lID_caja AS CHAR.     /* ID caja */
DEFINE VAR lIP_POS AS CHAR.     /* IP */
DEFINE VAR lPrefijoSerie AS CHAR.
DEFINE VAR lTipoDocSunat AS CHAR.
DEFINE VAR lRC AS LOG.
DEFINE VAR lCodRet AS CHAR.
DEFINE VAR lPort AS CHAR.

/* Validaciones */
IF LOOKUP(pTipoDocto, cDoctosValidos,",") = 0 THEN DO:
    pRetVal = "001|Documento debe ser  " + cDoctosValidos.
    RETURN .
END.
    
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.

pRetVal = '002|Documento no existe en PROGRESS'.
FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                            b-ccbcdocu.coddiv = pCodDiv AND
                            b-ccbcdocu.coddoc = pTipoDocto AND 
                            b-ccbcdocu.nrodoc = pNroDocto NO-LOCK NO-ERROR.

IF AVAILABLE b-ccbcdocu THEN DO:    

    pRetVal = '004|Documento no fue enviado a SUNAT'.

    FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = s-codcia AND
                                FELogComprobantes.coddiv = pCodDiv AND 
                                FELogComprobantes.coddoc = pTipoDocto AND
                                FELogComprobantes.nrodoc = pNroDocto
                                NO-LOCK NO-ERROR.
    IF AVAILABLE FELogComprobantes THEN DO:

        pRetVal = '005|Documento ya fue confirmado'.
        IF FELogComprobantes.flagPPLL = 2 THEN DO:

            /* Conectar y configurar ePOS */
            lID_caja = FELogComprobantes.ID_POS.
            lIP_POS = FELogComprobantes.IP_ePOS.
            mID_caja = lID_caja.
            lPort = "5500".

            pRetVal = "".
            RUN pconexion-epos(INPUT lIP_POS, INPUT lPort, OUTPUT pRetVal).

            IF SUBSTRING(pRetVal,1,3) = '000' THEN DO:

                pRetVal = "".
                RUN pconfigurar-epos(OUTPUT pRetVal).

                IF SUBSTRING(pRetVal,1,3) = '000' THEN DO:
    
                    lPrefijoSerie = fGet-Prefijo-Serie(pTipoDocto, pNroDocto, pCodDiv).
                    lTipoDocSunat = fGet-tipo-documento(pTipoDocto).
    
                    /* Data a enviar */
                    mDataClient = mControlIniMsg + "3" + mSeparador + mModoPrueba + mSeparador + cRucEmpresa
                                    + mSeparador + lID_caja + mSeparador + lTipoDocSunat + mSeparador + 
                                    lPrefijoSerie + SUBSTRING(pNroDocto,1,3) + "-" + SUBSTRING(pNroDocto,4) + mControlFinMsg.

                    /* Set size of memory pointer to write server socket */
                    SET-SIZE(mData) = 0.
                    SET-SIZE(mData) = LENGTH(mDataClient) + 1.
                    SET-BYTE-ORDER(mData) = BIG-ENDIAN.
                    PUT-STRING(mData,1,LENGTH(mDataClient) + 1) = mDataClient.

                    /* Write the whole thing to the server socket */
                    lRC = hSocket:WRITE(mData,1,GET-SIZE(mData)) NO-ERROR.

                    pRetVal = "000|Confirmacion enviado correctamente".
                    IF lRC = FALSE OR ERROR-STATUS:GET-MESSAGE(1) <> '' THEN DO:
                        pRetVal = "004|No se pudo enviar la CONFIRMACION al e-POS(" + lIP_POS + ") ID(" + lID_caja + ")".
                        SET-SIZE(mData) = 0.
                    END.
                    IF SUBSTRING(pRetVal,1,3)="000"  THEN DO:
                        /* A esperar la respuesta del Server */          
                        hSocket:SET-READ-RESPONSE-PROCEDURE('pProcessServerResponse', THIS-PROCEDURE).    
                        IF hSocket:CONNECTED() THEN DO: 
                            /* Esperando respuesta */
                            mDataServer = "".     
                            WAIT-FOR READ-RESPONSE OF hSocket. 
                        
                            /* Cadena devuelta por el e-POS */
                            mDataServer = REPLACE(mDataServer,mControlIniRpta,"").    /* STX */
                            mDataServer = REPLACE(mDataServer,mControlFinRpta,"").    /* ETX */
                        
                            pRetVal = REPLACE(mDataServer,mSeparador,"|").
                        
                            lCodRet = ENTRY(1,pRetVal,"|").
                            IF (lCodRet = '0' OR lCodRet = '00') AND NUM-ENTRIES(pRetVal,"|") > 1 THEN DO:
                                  pRetVal = "000" + "|" + ENTRY(2,pRetVal,"|").
                            END.                       
                        END.        
                        ELSE DO:
                             pRetVal = "999|Se desconecto del servidor, cuando esperaba respuesta de este".
                        END.
                    END.                    
                END. /* Configurar */
            END. /* Conexion */
        END.
    END.
END.

RELEASE b-ccbcdocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-borrar-penviar-documento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE borrar-penviar-documento Procedure 
PROCEDURE borrar-penviar-documento :
/*------------------------------------------------------------------------------
  Purpose:  Generar el Documento TXT y dejalo en el ePOS indicado
    Notes:  
    Return :    XXX - DDDDDDDDDDDDDDDDDD
                
                xxx - Codigo del error 
                ddd.. - descripcion del error.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTipoDocto AS CHAR.
DEFINE INPUT PARAMETER pNroDocto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

DEFINE VAR lRetval AS CHAR.
DEFINE VAR lIntento AS INT.

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

IF AVAILABLE FELogComprobantes THEN DO:
    RELEASE b-FELogComprobantes.
    pRetVal = "666|Documento ya esta PROCESADO en FELogComprobantes".
    RETURN .
END.

RELEASE b-FELogComprobantes.
   
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE VAR rRowId AS ROWID.

lRetVal = '002|Documento no existe'.
FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                            b-ccbcdocu.coddiv = pCodDiv AND
                            b-ccbcdocu.coddoc = pTipoDocto AND 
                            b-ccbcdocu.nrodoc = pNroDocto NO-LOCK NO-ERROR.
IF AVAILABLE b-ccbcdocu THEN DO:
    /* Guardo referencia */
    cTipoDocto = pTipoDocto.
    cNroDocto = pNroDocto.
    cDivision = pCodDiv.

    rRowId = ROWID(b-ccbcdocu).
    
    RELEASE b-ccbcdocu.
    
    /* Intentos para grabar */
    REPEAT lIntento = 1 TO lReintentos:

        lRetVal = '888|Opcion no implementada'.
        mFileTxt = "".

        /* Generacion del DOCUMENTO */
        CASE pTipoDocto:
            WHEN 'FAC'  THEN DO:
                /* Facturas */        
                RUN fac-generar-txt(INPUT rRowid, OUTPUT lRetval).
            END.
            WHEN 'BOL' OR WHEN 'TCK' THEN DO:
                /* Boletas */
                RUN bol-generar-txt(INPUT rRowid, OUTPUT lRetval).
            END.
            WHEN 'N/C' THEN DO:
                /* Notas de Credito */
                RUN nc-generar-txt(INPUT rRowid, OUTPUT lRetval).
            END.
            WHEN 'N/D' THEN DO:
                /* Notas de Debito */
                RUN nd-generar-txt(INPUT rRowid, OUTPUT lRetval).
            END.
        END CASE.
        
        IF SUBSTRING(lRetval,1,3) = '000' THEN DO:
            lIntento = lReintentos + 2.
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
    667-Operacion no retorno el HASH
    665-Imposible ubicar el Origen del Documento".    /* casos de N/C y N/D*/
    666-Documento ya esta PROCESADO en FELogComprobantes
    888-Opcion no implementada
    999-Imposible escribir en el e-POS".
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-borrar-pgenerar_factura) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE borrar-pgenerar_factura Procedure 
PROCEDURE borrar-pgenerar_factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTipoDocto AS CHAR.
DEFINE INPUT PARAMETER pNroDocto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pReturn AS CHAR NO-UNDO.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.

FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                            b-ccbcdocu.coddiv = pCodDiv AND
                            b-ccbcdocu.coddoc = pTipoDocto AND 
                            b-ccbcdocu.nrodoc = pNroDocto NO-LOCK NO-ERROR.


/*FIND FIRST b-ccbcdocu WHERE ROWID(b-ccbcdocu)=pRowid NO-LOCK NO-ERROR.*/
IF NOT AVAILABLE b-ccbcdocu  THEN DO:
    RELEASE b-ccbcdocu.
    RELEASE b-ccbddocu.

    pReturn = "004|Al generar TXT no existe Documento ???".
    RETURN .
END.

DEFINE VAR cFileSunat AS CHAR.
DEFINE VAR dDescuentos AS DEC.
DEFINE VAR lxitem AS INT.
DEFINE VAR lxNumTexto AS CHAR.
/* - */
DEFINE VAR lRC AS LOG.
DEFINE VAR lCodRet AS CHAR.
DEFINE VAR lMoneda AS CHAR.
DEFINE VAR lFPago AS CHAR.
DEFINE VAR lPersonalizados AS CHAR INIT "".
DEFINE VAR lxNomCli AS CHAR.
DEFINE VAR lxDirCli AS CHAR.
DEFINE VAR lCdoigoDeAfectacion AS CHAR.
DEFINE VAR lGuiaRemision AS CHAR.
DEFINE VAR lOrdenCompra AS CHAR.

cFile_DE            = "".
mDataClient         = "".
cTipoDoctoSunat     = '01'.
cSerieSunat         = "F" + SUBSTRING(b-ccbcdocu.nrodoc,1,3).
cCorrelativoSunat   = SUBSTRING(b-ccbcdocu.nrodoc,4).
lxNomCli = TRIM(b-ccbcdocu.nomcli).
lxDirCli = TRIM(REPLACE(b-ccbcdocu.dircli,"|", " ")).

lOrdenCompra = "".
IF b-ccbcdocu.nroord <> ? AND  b-ccbcdocu.nroord <> "" THEN lOrdenCompra = TRIM(b-ccbcdocu.nroord).

dDescuentos = (b-ccbcdocu.impdto + b-ccbcdocu.impdto2).

/* UTF-8 */
lxNomCli = fget-utf-8(lxNomCli).
lxDirCli = fget-utf-8(lxDirCli).

/* Data a enviar al e-POS */
/*
mDataClient = mControlIniMsg + "2" + mSeparador + mModoPrueba + mSeparador + cRucEmpresa
                + mSeparador + mID_ePOS + mSeparador + cTipoDoctoSunat + mSeparador.
*/                

lMoneda = IF(b-ccbcdocu.codmon = 1) THEN 'PEN' ELSE 'USD'.

mDataClient = mDataClient + "EN|" +
        cTipoDoctoSunat + "|" +
        cSerieSunat + "-" + cCorrelativoSunat + "|" +
        "|"  +   /* Tipo de N/C o N/D */
        "|"  +   /* Factura que referencia la N/C */
        "|"  +   /* Sustento */
        STRING(YEAR(b-ccbcdocu.fchdoc),"9999") + "-" + STRING(MONTH(b-ccbcdocu.fchdoc),"99") + "-" + STRING(DAY(b-ccbcdocu.fchdoc),"99") + "|" +
        lMoneda + "|" + 
        cRucEmpresa + "|" +
        "6|" +   /* Tipo de Identificador del emisor */
        TRIM(cNombreComercial) + "|" +
        TRIM(cRazonSocial) +  "|" +
        cUBIGEO + "|" +    /* Codigo UBIGEO emisor */
        cDirecEmisor + "|" +    /* Direccion Emisor */
        "|" +    /* Departamento emisor (Ciudad) */
        "|" +    /* Provincia emisor (Comuna) */
        "|" +    /* Distrito Emisor */
        TRIM(b-ccbcdocu.ruccli) + "|" +
        "6|" +   /* Tipo identificacion Receptor */
        lxNomCli + "|" +
        lxDirCli + "|" +
        STRING(b-ccbcdocu.impbrt,lFmtoImpte) + "|" +
        STRING(b-ccbcdocu.impigv,lFmtoImpte) + "|" +
        STRING(dDescuentos,lFmtoImpte) + "|" +
        "|"  +   /* Monto Recargos */
        STRING(b-ccbcdocu.imptot,lFmtoImpte) + "|" + 
        "|" +    /* Codigos de otros conceptos tributarios o comerciales recomendados */
        "|" +    /* Total Valor Venta neto */
        TRIM(b-ccbcdocu.ruccli) + "|" +
        "6"  + "|" +   /* Tipo docume2nto del adquiriente */
        "|" +   /*Código País Emisor*/
        "|" +   /*Urbanización Emisor*/
        "|" +   /*Dirección del Punto de Partida, Código de Ubigeo*/
        "|" +   /*Dirección del Punto de Partida, Dirección completa y detallada*/
        "|" +   /*Dirección del Punto de Partida, Urbanización*/
        "|" +   /*Dirección del Punto de Partida, Provincia*/
        "|" +   /*Dirección del Punto de Partida, Departamento*/
        "|" +   /*Dirección del Punto de Partida, Distrito*/
        "|" +   /*Dirección del Punto de Partida, Código de País*/
        "|" +   /*Dirección del Punto de Llegada, Código de Ubigeo*/
        "|" +   /*Dirección del Punto de Llegada, Dirección completa y detallada*/
        "|" +   /*Dirección del Punto de Llegada, Urbanización*/
        "|" +   /*Dirección del Punto de Llegada, Provincia*/
        "|" +   /*Dirección del Punto de Llegada, Departamento*/
        "|" +   /*Dirección del Punto de Llegada, Distrito*/
        "|" +   /*Dirección del Punto de Llegada, Código de País*/
        "|" +   /*Placa Vehículo*/
        "|" +   /*N° constancia de inscripción del vehículo o certificado de habilitacion vehicular*/
        "|" +   /*Marca Vehículo*/
        "|" +   /*N° de licencia de conducir*/
        "|" +   /*Ruc transportista*/
        "|" +   /*Ruc transportista -Tipo Documento*/
        "|" +   /*Razón social del transportista*/
        "|" +    /*Condiciones de pago*/
        lOrdenCompra + /* OrdenCompra */
        gcCRLF.

/* DOC */
/*
1001 Total valor de venta - operaciones gravadas
1002 Total valor de venta - operaciones inafectas
1003 Total valor de venta - operaciones exoneradas
1004 Total valor de venta – Operaciones gratuitas
*/
IF b-ccbcdocu.fmapgo = '900' THEN DO:
    /*  Correo de Maria Bernal, 19Jul2016
    Enrique:
            1.- La condición Venta 900 (Transferencia Gratuita), se le deberá asignar segun tabla SUNAT,  
                el código 31: INAFECTO POR BONIFICACIÓN.
                Segun lo conversado con Carmen Ayala, el motivo de generar estos comprobantes a los clientes 
                es por la bonificación que se les otorga por cumplimiento de objetivos: compras.
            2.- El Valor de Venta referencial  debe ser el del costo.
    */
    /* Inafectas */
    mDataClient = mDataClient +  "DOC|" +
        "1002|" +
        STRING(b-ccbcdocu.impvta,lFmtoImpte) + 
        gcCRLF.
END.
ELSE DO:
    IF b-ccbcdocu.porigv = 0.00 THEN DO:
        /* Operacion Inafectas */
        mDataClient = mDataClient +  "DOC|" +
            "1002|" +
            STRING(b-ccbcdocu.impvta,lFmtoImpte) + 
            gcCRLF.
    END.
    ELSE DO:
        /* Operacion Gravadas */
        mDataClient = mDataClient + "DOC|" +
            "1001|" +
            STRING(b-ccbcdocu.impvta,lFmtoImpte) +
            gcCRLF.            
        IF b-ccbcdocu.impexo > 0 THEN DO:                
            /* Operacion Exoneradas */
            mDataClient = mDataClient + "DOC|" +
                "1003|" +
                STRING(b-ccbcdocu.impexo,lFmtoImpte) +
                gcCRLF.
        END.            
        /* Bonificaciones ( hay que leer el detalle del docto campo linre_c05='OF' ) */
        
        IF dDescuentos > 0 THEN DO:
            /* Descuientos */
            mDataClient = mDataClient + "DOC|" +
                "2005|" +
                STRING( dDescuentos,lFmtoImpte) + 
                gcCRLF.
        END.
    END.
END.

lxNumTexto = "".
RUN lib\_numero.R(INPUT b-ccbcdocu.imptot, 2, 1, OUTPUT lxNumTexto).

/* UTF-8 */
lxNumTexto = fget-utf-8(lxNumTexto).

mDataClient = mDataClient +  "DN|" +
    "1|" +
    "1000|" +
    lxNumTexto +
    gcCRLF.

DEFINE VAR lPrecioUnit AS DEC.
DEFINE VAR lImpItmVVta AS DEC.
DEFINE VAR lVVtaUnit AS DEC.
DEFINE VAR lVVtaItem AS DEC.
DEFINE VAR lxDesMat AS CHAR.

DEFINE VAR lSumaIgv AS DEC.

lxitem = 1.
lSumaIgv = 0.
FOR EACH b-ccbddocu OF b-ccbcdocu NO-LOCK:
    FIND FIRST almmmatg OF b-ccbddocu NO-LOCK NO-ERROR.

    lPrecioUnit = ROUND((b-ccbddocu.implin - b-ccbddocu.ImpDto2) / b-ccbddocu.candes , 4).
    lImpItmVVta = (b-ccbddocu.implin - b-ccbddocu.ImpDto2).  /* Casos inafectos */
    IF b-ccbcdocu.fmapgo <> '900' AND b-ccbcdocu.porigv > 0 THEN DO:
        lImpItmVVta = ROUND((b-ccbddocu.implin - b-ccbddocu.ImpDto2) /  (1 + ( b-ccbcdocu.porigv / 100 )) ,  2).
    END.
    lVVtaUnit = ROUND(lImpItmVVta / b-ccbddocu.candes,2).
    lVVtaItem = ROUND(b-ccbddocu.candes * lVVtaUnit,2).
    lxDesMat = fget-descripcion-articulo(b-ccbddocu.codmat, b-ccbcdocu.coddoc, b-ccbcdocu.cndcre, b-ccbcdocu.tpofac).

    /* UTF-8 */
    lxDesMat = fget-utf-8(lxDesMat).
   
    lFPago = "01".                          
    /* 19Jul2016 */
    lFPago = IF (b-ccbcdocu.fmapgo = '900') THEN '02' ELSE "01".

    mDataClient = mDataClient + "DE|" +
        STRING(lxItem,">>>9") + "|" +
        STRING(lPrecioUnit,">>>>>>9.9999") + "|" +   /* 03Ago2016 - P.Uni a 4 digitos */
        /*STRING(lPrecioUnit,lFmtoImpte) + "|" +   /* 03Ago2016 - P.Uni a 4 digitos */*/
        fget-unidad-medida(b-ccbddocu.undvta) + "|" +
        STRING(b-ccbddocu.candes,lFmtoImpte) + "|" +
        STRING(lImpItmVVta,lFmtoImpte) + "|" +
        b-ccbddocu.codmat + "|" +
        lFPago  + "|" +
        STRING(lVVtaUnit,lFmtoImpte) + "|" +
        STRING(lVVtaItem,lFmtoImpte) +
        gcCRLF.

   mDataClient = mDataClient +  "DEDI|" +
       TRIM(lxDesMat) +
       gcCRLF.

   IF b-ccbddocu.ImpDto2 > 0 THEN DO:
       mDataClient = mDataClient + "DEDR|" +
           "false|" +
           STRING(b-ccbddocu.ImpDto2,lFmtoImpte) +
           gcCRLF.
   END.
   lCdoigoDeAfectacion = '10'.
   
    IF b-ccbcdocu.fmapgo = '900' THEN DO:
        /* Por ahora estamos poniendo 15 sin afecto a IGV x promocion */
        lCdoigoDeAfectacion = '15'.
    END.   

    IF b-ccbddocu.impigv > 0 THEN DO:
        mDataClient = mDataClient + "DEIM|" +
            STRING(b-ccbddocu.impigv,lFmtoImpte) + "|" +
            STRING(lImpItmVVta,lFmtoImpte) + "|"  +
            STRING(ROUND(b-ccbddocu.impigv,2),lFmtoImpte) + "|" +
            STRING(b-ccbcdocu.porigv,lFmtoImpte) + "|" +
            "|" +
            lCdoigoDeAfectacion + "|" +
            "|" +
            "1000|" +
            "IGV|" +
            "VAT" +
            gcCRLF.
        lSumaIgv = lSumaIgv + ROUND(b-ccbddocu.impigv,2).
    END.
    ELSE DO:
        /* Sin IGV ????????????????? */
    END.

    lxItem = lxItem + 1.
END.

IF lSumaIgv > 0 THEN DO:
    mDataClient = mDataClient + "DI|" +
        STRING(lSumaIgv,lFmtoImpte) + "|" +
        STRING(lSumaIgv,lFmtoImpte) + "|" +
        "1000|" +
        "IGV|" +
        "VAT|" +
        gcCRLF.
END.

/* GUIA REMISION */
DEFINE BUFFER bx-ccbcdocu FOR ccbcdocu.
FOR EACH bx-ccbcdocu WHERE bx-ccbcdocu.codcia = s-codcia AND
                            bx-ccbcdocu.coddoc = 'G/R' AND
                            bx-ccbcdocu.codref = b-ccbcdocu.coddoc AND 
                            bx-ccbcdocu.nroref = b-ccbcdocu.nrodoc
                            NO-LOCK :

    lGuiaRemision = IF(bx-ccbcdocu.nrodoc = ?) THEN "" ELSE TRIM(bx-ccbcdocu.nrodoc). 

    IF lGuiaRemision <> "" THEN DO:
        lGuiaRemision = "0" + SUBSTRING(bx-ccbcdocu.nrodoc,1,3) + "-" + 
                        SUBSTRING(bx-ccbcdocu.nrodoc,4) NO-ERROR.

        mDataClient = mDataClient + "RE|" + 
            "||||" +
            lGuiaRemision + "|" +
            "09|||" + 
            gcCRLF.
    END.
END.

mDataClient = mDataClient + "PE|" +
    "GLOSAMONTO|" +
    lxNumTexto +
    gcCRLF.

/* Personalizados */
/*lPersonalizados = fget-personalizados(b-ccbcdocu.tipo, pTipoDocmto, pNroDocmto, pCodDiv).*/
mDataClient = mDataClient + lPersonalizados.

/* Correo del Cliente */
mDataClient = mDataClient + fget-email-cliente(b-ccbcdocu.codcli).

RELEASE bx-ccbcdocu.

RELEASE b-ccbcdocu.
RELEASE b-ccbddocu.
RELEASE gn-div.
RELEASE gn-convt.

/* Enviamos la data a la carpeta compartida */
cFile_DE = mDataClient.
cPathEntrada = cPathTemporal + "\" + cRucEmpresa + "_" + cTipoDoctoSunat + "_" + cSerieSunat + 
                cCorrelativoSunat + "_" + STRING(YEAR(TODAY),"9999") + 
                 STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + ".TXT".

/*COPY-LOB cFile_DE TO FILE cPathEntrada.*/

/* Enviamos la data al e-POS */
mDataClient = mControlIniMsg + "2" + mSeparador + mModoPrueba + mSeparador + cRucEmpresa
                + mSeparador + mID_caja + mSeparador + cTipoDoctoSunat + mSeparador + 
                mDataClient + mControlFinMsg.

/*mDataClient = mDataClient + mControlFinMsg.*/

IF USERID("integral") = 'ADMIN' OR USERID("integral") = 'MASTER' THEN DO:
    COPY-LOB mDataClient TO FILE cPathTemporal + "\" + cSerieSunat + "-" + cCorrelativoSunat + 
                        "-" + cTipoDoctoSunat + ".txt".
END.

IF NOT USERID("integral") = "MASTER" THEN DO:
    /* Set size of memory pointer to write server socket */
    SET-SIZE(mData) = 0.
    SET-SIZE(mData) = LENGTH(mDataClient) + 1.
    SET-BYTE-ORDER(mData) = BIG-ENDIAN.
    PUT-STRING(mData,1,LENGTH(mDataClient) + 1) = mDataClient.

    /* Write the whole thing to the server socket */
    lRC = hSocket:WRITE(mData,1,GET-SIZE(mData)) NO-ERROR.

    pReturn = "000|Escritura OK en el e-POS".
    IF lRC = FALSE OR ERROR-STATUS:GET-MESSAGE(1) <> '' THEN DO:
      pReturn = "999|Imposible escribir en el e-POS(" + ERROR-STATUS:GET-MESSAGE(1) + ")". 
      SET-SIZE(mData) = 0.
    END.

    IF SUBSTRING(pReturn,1,3)="000"  THEN DO:
        /* A esperar la respuesta del Server */  
        mDataServer = "".
        hSocket:SET-READ-RESPONSE-PROCEDURE('pProcessServerResponse', THIS-PROCEDURE).

        IF hSocket:CONNECTED() THEN DO: 
          /* Esperando respuesta */      
          WAIT-FOR READ-RESPONSE OF hSocket. 

          /* Cadena devuelta por el e-POS */
          mDataServer = REPLACE(mDataServer,mControlIniRpta,"").   /*STX*/
          mDataServer = REPLACE(mDataServer,mControlFinRpta,"").   /*ETX*/      

          /*pReturn = REPLACE(mDataServer,mSeparador,"|").*/
          pReturn = mDataServer.

          lCodRet = ENTRY(1,pReturn,mSeparador).

          IF (lCodRet = '0' OR lCodRet = '00') AND NUM-ENTRIES(pReturn,mSeparador) > 4 THEN DO:
                /* 000|mmmmeeeennnnssssaajjee|Codigo HASH */
                pReturn = "000" + "|" + ENTRY(2,pReturn,mSeparador) + "|" + ENTRY(5,pReturn,mSeparador).
          END.
          ELSE DO: 
                pReturn = "667|Operacion no retorno el HASH(" + mDataServer + ")".
          END.


        END.        
        ELSE DO:
            pReturn = "602|Se desconecto del servidor, cuando esperaba respuesta de este al generar FACTURA".
        END.
    END.
END.
ELSE DO:
    pReturn = "-222|User MASTER".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fac-generar-txt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fac-generar-txt Procedure 
PROCEDURE fac-generar-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTipoDocmto AS CHAR.
DEFINE INPUT PARAMETER pNroDocmto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pReturn AS CHAR NO-UNDO.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.

FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                            b-ccbcdocu.coddiv = pCodDiv AND 
                            b-ccbcdocu.coddoc = pTipoDocmto AND 
                            b-ccbcdocu.nrodoc = pNroDocmto
                            NO-LOCK NO-ERROR.

IF NOT AVAILABLE b-ccbcdocu  THEN DO:
    pReturn = "004|Documento NO existe (Generando trama)".
    RETURN .
END.
IF b-ccbcdocu.flgest = 'A' THEN DO:
    pReturn = "004|Documento esta ANULADO (Generando trama)".
    RETURN .
END.

DEFINE VAR cFileSunat AS CHAR.
DEFINE VAR dDescuentos AS DEC.
DEFINE VAR lxitem AS INT.
DEFINE VAR lxNumTexto AS CHAR.
/* - */
DEFINE VAR lRC AS LOG.
DEFINE VAR lCodRet AS CHAR.
DEFINE VAR lMoneda AS CHAR.
DEFINE VAR lFPago AS CHAR.
DEFINE VAR lPersonalizados AS CHAR INIT "".
DEFINE VAR lxNomCli AS CHAR.
DEFINE VAR lxDirCli AS CHAR.
DEFINE VAR lCdoigoDeAfectacion AS CHAR.
DEFINE VAR lGuiaRemision AS CHAR.
DEFINE VAR lOrdenCompra AS CHAR.
DEFINE VAR lMarca AS CHAR.

DEFINE VAR lImpGravado AS DEC.

cFile_DE            = "".
mDataClient         = "".
cTipoDoctoSunat     = '01'.
cSerieSunat         = "F" + SUBSTRING(b-ccbcdocu.nrodoc,1,3).
cCorrelativoSunat   = SUBSTRING(b-ccbcdocu.nrodoc,4).
lxNomCli = TRIM(b-ccbcdocu.nomcli).
lxDirCli = TRIM(REPLACE(b-ccbcdocu.dircli,"|", " ")).

lOrdenCompra = "".
IF b-ccbcdocu.nroord <> ? AND  b-ccbcdocu.nroord <> "" THEN lOrdenCompra = TRIM(b-ccbcdocu.nroord).

/* dDescuentos = (b-ccbcdocu.impdto + b-ccbcdocu.impdto2).  10Abr2018 - Segun Ruben no va el IMPDTO */
dDescuentos = (b-ccbcdocu.impdto2).

/* UTF-8 */
lxNomCli = fget-utf-8(lxNomCli).
lxDirCli = fget-utf-8(lxDirCli).

/* Data a enviar al e-POS */
/*
mDataClient = mControlIniMsg + "2" + mSeparador + mModoPrueba + mSeparador + cRucEmpresa
                + mSeparador + mID_ePOS + mSeparador + cTipoDoctoSunat + mSeparador.
*/                

        /*"2018-01-01" + "|" +*/

lMoneda = IF(b-ccbcdocu.codmon = 1) THEN 'PEN' ELSE 'USD'.

mDataClient = mDataClient + "EN|" +
        cTipoDoctoSunat + "|" +
        cSerieSunat + "-" + cCorrelativoSunat + "|" +
        "|"  +   /* Tipo de N/C o N/D */
        "|"  +   /* Factura que referencia la N/C */
        "|"  +   /* Sustento */
        STRING(YEAR(b-ccbcdocu.fchdoc),"9999") + "-" + STRING(MONTH(b-ccbcdocu.fchdoc),"99") + "-" + STRING(DAY(b-ccbcdocu.fchdoc),"99") + "|" +
        lMoneda + "|" + 
        cRucEmpresa + "|" +
        "6|" +   /* Tipo de Identificador del emisor */
        TRIM(cNombreComercial) + "|" +
        TRIM(cRazonSocial) +  "|" +
        cUBIGEO + "|" +    /* Codigo UBIGEO emisor */
        cDirecEmisor + "|" +    /* Direccion Emisor */
        "|" +    /* Departamento emisor (Ciudad) */
        "|" +    /* Provincia emisor (Comuna) */
        "|" +    /* Distrito Emisor */
        TRIM(b-ccbcdocu.ruccli) + "|" +
        "6|" +   /* Tipo identificacion Receptor */
        lxNomCli + "|" +
        lxDirCli + "|" +
        STRING(b-ccbcdocu.impbrt,lFmtoImpte) + "|" +
        STRING(b-ccbcdocu.impigv,lFmtoImpte) + "|" +
        STRING(dDescuentos,lFmtoImpte) + "|" +
        "|"  +   /* Monto Recargos */
        STRING(b-ccbcdocu.imptot,lFmtoImpte) + "|" + 
        "|" +    /* Codigos de otros conceptos tributarios o comerciales recomendados */
        "|" +    /* Total Valor Venta neto */
        TRIM(b-ccbcdocu.ruccli) + "|" +
        "6"  + "|" +   /* Tipo docume2nto del adquiriente */
        "|" +   /*Código País Emisor*/
        "|" +   /*Urbanización Emisor*/
        "|" +   /*Dirección del Punto de Partida, Código de Ubigeo*/
        "|" +   /*Dirección del Punto de Partida, Dirección completa y detallada*/
        "|" +   /*Dirección del Punto de Partida, Urbanización*/
        "|" +   /*Dirección del Punto de Partida, Provincia*/
        "|" +   /*Dirección del Punto de Partida, Departamento*/
        "|" +   /*Dirección del Punto de Partida, Distrito*/
        "|" +   /*Dirección del Punto de Partida, Código de País*/
        "|" +   /*Dirección del Punto de Llegada, Código de Ubigeo*/
        "|" +   /*Dirección del Punto de Llegada, Dirección completa y detallada*/
        "|" +   /*Dirección del Punto de Llegada, Urbanización*/
        "|" +   /*Dirección del Punto de Llegada, Provincia*/
        "|" +   /*Dirección del Punto de Llegada, Departamento*/
        "|" +   /*Dirección del Punto de Llegada, Distrito*/
        "|" +   /*Dirección del Punto de Llegada, Código de País*/
        "|" +   /*Placa Vehículo*/
        "|" +   /*N° constancia de inscripción del vehículo o certificado de habilitacion vehicular*/
        "|" +   /*Marca Vehículo*/
        "|" +   /*N° de licencia de conducir*/
        "|" +   /*Ruc transportista*/
        "|" +   /*Ruc transportista -Tipo Documento*/
        "|" +   /*Razón social del transportista*/
        "|" +    /*Condiciones de pago*/
        lOrdenCompra + /* OrdenCompra */
        gcCRLF.

/* DOC */
/*
1001 Total valor de venta - operaciones gravadas
1002 Total valor de venta - operaciones inafectas
1003 Total valor de venta - operaciones exoneradas
1004 Total valor de venta – Operaciones gratuitas
*/
/*
IF b-ccbcdocu.fmapgo = '900' THEN DO:
    /*  Correo de Maria Bernal, 19Jul2016
    Enrique:
            1.- La condición Venta 900 (Transferencia Gratuita), se le deberá asignar segun tabla SUNAT,  
                el código 31: INAFECTO POR BONIFICACIÓN.
                Segun lo conversado con Carmen Ayala, el motivo de generar estos comprobantes a los clientes 
                es por la bonificación que se les otorga por cumplimiento de objetivos: compras.
            2.- El Valor de Venta referencial  debe ser el del costo.
    */
    /* Inafectas */
    mDataClient = mDataClient +  "DOC|" +
        "1002|" +
        STRING(b-ccbcdocu.impvta,lFmtoImpte) + 
        gcCRLF.
END.
ELSE DO:
*/
    IF b-ccbcdocu.fmapgo <> '899' AND b-ccbcdocu.porigv = 0.00 THEN DO:
        /* Operacion Inafectas */
        mDataClient = mDataClient +  "DOC|" +
            "1002|" +
            STRING(b-ccbcdocu.impvta,lFmtoImpte) + 
            gcCRLF.
    END.
    ELSE DO:
        lConceptoTributario = "1001".
        RUN pConcepto-Tributario(INPUT b-ccbcdocu.coddoc, INPUT b-ccbcdocu.fmapgo, OUTPUT lConceptoTributario).
        
        lImpGravado = b-ccbcdocu.impvta.
        /* Operaciones Gratuitas */
        IF b-ccbcdocu.fmapgo = '899' THEN lImpGravado = b-ccbcdocu.impbrt.

        /* Operacion Gravadas */
        mDataClient = mDataClient + "DOC|" +
            lConceptoTributario + "|" +
            STRING(lImpGravado,lFmtoImpte) +
            gcCRLF.            
        IF b-ccbcdocu.impexo > 0 THEN DO:                
            /* Operacion Exoneradas */
            mDataClient = mDataClient + "DOC|" +
                "1003|" +
                STRING(b-ccbcdocu.impexo,lFmtoImpte) +
                gcCRLF.
        END.            
        /* Bonificaciones ( hay que leer el detalle del docto campo linre_c05='OF' ) */
        
        IF dDescuentos > 0 THEN DO:
            /* Descuientos */
            mDataClient = mDataClient + "DOC|" +
                "2005|" +
                STRING( dDescuentos,lFmtoImpte) + 
                gcCRLF.
        END.
    END.
/*END.*/

lxNumTexto = "".
RUN lib\_numero.R(INPUT b-ccbcdocu.imptot, 2, 1, OUTPUT lxNumTexto).

/* UTF-8 */
lxNumTexto = fget-utf-8(lxNumTexto).

IF lMoneda = 'PEN' THEN DO:
    lxNumTexto = lxNumTexto + " SOLES".
END.
ELSE DO:
    lxNumTexto = lxNumTexto + " DOLARES AMERICANOS".
END.

mDataClient = mDataClient +  "DN|" +
    "1|" +
    "1000|" +
    lxNumTexto +
    gcCRLF.

DEFINE VAR lPrecioUnit AS DEC.
DEFINE VAR lImpItmVVta AS DEC.
DEFINE VAR lVVtaUnit AS DEC.
DEFINE VAR lVVtaItem AS DEC.
DEFINE VAR lxDesMat AS CHAR.

DEFINE VAR lSumaIgv AS DEC.
DEFINE VAR lIgvImpDto2 AS DEC.  /* IGV del Descuento Final aplicado a cada item */
DEFINE VAR lImpIgvLin AS DEC.   /* IGV de cada item */

lxitem = 1.
lSumaIgv = 0.
FOR EACH b-ccbddocu OF b-ccbcdocu NO-LOCK:
    FIND FIRST almmmatg OF b-ccbddocu NO-LOCK NO-ERROR.
    /*
    lPrecioUnit = ROUND((b-ccbddocu.implin - b-ccbddocu.ImpDto2) / b-ccbddocu.candes , 4).

    lImpItmVVta = (b-ccbddocu.implin).  /* Casos inafectos */
    lImpItmVVta = ROUND((b-ccbddocu.implin - b-ccbddocu.ImpDto2) 
    */

    lPrecioUnit = ROUND((b-ccbddocu.implin - b-ccbddocu.ImpDto2) / b-ccbddocu.candes , 4).

    lImpItmVVta = (b-ccbddocu.implin - b-ccbddocu.ImpDto2).  /* Casos inafectos */
    IF b-ccbcdocu.fmapgo <> '899' AND b-ccbcdocu.porigv > 0 THEN DO:
        lImpItmVVta = ROUND((b-ccbddocu.implin - b-ccbddocu.ImpDto2) /  (1 + ( b-ccbcdocu.porigv / 100 )) ,  2).
        /*
        lImpItmVVta2 = ROUND((b-ccbddocu.implin) /  (1 + ( b-ccbcdocu.porigv / 100 )) ,  2).
        */
    END.
    
    lVVtaUnit = ROUND(lImpItmVVta / b-ccbddocu.candes,2).
    lVVtaItem = ROUND(b-ccbddocu.candes * lVVtaUnit,2).
    /*
    lVVtaUnit2 = ROUND(lImpItmVVta2 / b-ccbddocu.candes,2).
    lVVtaItem2 = ROUND(b-ccbddocu.candes * lVVtaUnit2,2).
    */

    lxDesMat = fget-descripcion-articulo(b-ccbddocu.codmat, b-ccbcdocu.coddoc, b-ccbcdocu.cndcre, b-ccbcdocu.tpofac).
    lMarca = IF (AVAILABLE almmmatg) THEN fget-utf-8(almmmatg.desmar) ELSE "".    
    IF b-ccbcdocu.tpofac = 'S' THEN DO:
        /* Factura SERVICIOS no va MARCA */
        lMarca = "".
    END.    

    /* UTF-8 */
    lxDesMat = fget-utf-8(lxDesMat).
   
    lFPago = "01".                          
    /* Transferencia Gratuita */
    lFPago = IF (b-ccbcdocu.fmapgo = '899') THEN '02' ELSE "01".    

    mDataClient = mDataClient + "DE|" +
        STRING(lxItem,">>>9") + "|" +                                                           /* ID */
        STRING(lPrecioUnit,">>>>>>9.9999") + "|" +   /* 03Ago2016 - P.Uni a 4 digitos */        /* PriceAmount */
        /*STRING(lPrecioUnit,lFmtoImpte) + "|" +   /* 03Ago2016 - P.Uni a 4 digitos */*/        
        fget-unidad-medida(b-ccbddocu.undvta) + "|" +                                           /* unitCode */
        STRING(b-ccbddocu.candes,lFmtoImpte) + "|" +                                            /* InvoicedQuantity */
        STRING(lImpItmVVta,lFmtoImpte) + "|" +                                                  /* LineExtensionAmount */
        b-ccbddocu.codmat + "|" +
        lFPago  + "|" +                                                                         /* PriceTypeCode */
        STRING(lVVtaUnit,lFmtoImpte) + "|" +                                                    /* PriceAmount */
        STRING(lVVtaItem,lFmtoImpte) + "|" +                                                    /* LineExtensionAmount */
        "|" +
        lMarca +
        gcCRLF.

   mDataClient = mDataClient +  "DEDI|" +
       TRIM(lxDesMat) +
       gcCRLF.

   IF b-ccbddocu.ImpDto2 > 0 THEN DO:
       mDataClient = mDataClient + "DEDR|" +
           "false|" +
           STRING(b-ccbddocu.ImpDto2,lFmtoImpte) +
           gcCRLF.
   END.
   lCdoigoDeAfectacion = '10'.
    RUN pcodigo-afectacion(INPUT b-ccbcdocu.coddoc, INPUT b-ccbcdocu.fmapgo, OUTPUT lCdoigoDeAfectacion).
    /*
    IF b-ccbcdocu.fmapgo = '900' THEN DO:
        /* Por ahora estamos poniendo 15 sin afecto a IGV x promocion */
        lCdoigoDeAfectacion = '15'.
    END.   
    */
    IF b-ccbddocu.impigv > 0 THEN DO:
        lImpIgvLin = b-ccbddocu.impigv.
        lIgvImpDto2 = 0.
        IF b-ccbddocu.aftigv = YES AND b-ccbcdocu.porigv > 0
            THEN lIgvImpDto2 = ROUND(b-ccbddocu.impdto2 / ( 1 + b-ccbcdocu.porigv) * b-ccbcdocu.porigv, 4).
        lImpIgvLin = lImpIgvLin - lIgvImpDto2.

        mDataClient = mDataClient + "DEIM|" +
            STRING(lImpIgvLin,lFmtoImpte) + "|" +
            /*STRING(b-ccbddocu.impigv,lFmtoImpte) + "|" +*/
            STRING(lImpItmVVta,lFmtoImpte) + "|"  +
            STRING(ROUND(lImpIgvLin,2),lFmtoImpte) + "|" +
            /*STRING(ROUND(b-ccbddocu.impigv,2),lFmtoImpte) + "|" +*/
            STRING(b-ccbcdocu.porigv,lFmtoImpte) + "|" +
            "|" +
            lCdoigoDeAfectacion + "|" +
            "|" +
            "1000|" +
            "IGV|" +
            "VAT" +
            gcCRLF.
        lSumaIgv = lSumaIgv + ROUND(lImpIgvLin,2).
        /*lSumaIgv = lSumaIgv + ROUND(b-ccbddocu.impigv,2).*/
    END.
    ELSE DO:
        /* Sin IGV ????????????????? */
    END.

    lxItem = lxItem + 1.
END.

IF lSumaIgv > 0 THEN DO:
    mDataClient = mDataClient + "DI|" +
        STRING(lSumaIgv,lFmtoImpte) + "|" +
        STRING(lSumaIgv,lFmtoImpte) + "|" +
        "1000|" +
        "IGV|" +
        "VAT|" +
        gcCRLF.
END.

/* GUIA REMISION */
DEFINE BUFFER bx-ccbcdocu FOR ccbcdocu.
FOR EACH bx-ccbcdocu WHERE bx-ccbcdocu.codcia = s-codcia AND
                            bx-ccbcdocu.coddoc = 'G/R' AND
                            bx-ccbcdocu.codref = b-ccbcdocu.coddoc AND 
                            bx-ccbcdocu.nroref = b-ccbcdocu.nrodoc
                            NO-LOCK :

    lGuiaRemision = IF(bx-ccbcdocu.nrodoc = ?) THEN "" ELSE TRIM(bx-ccbcdocu.nrodoc). 

    IF lGuiaRemision <> "" THEN DO:
        lGuiaRemision = "0" + SUBSTRING(bx-ccbcdocu.nrodoc,1,3) + "-" + 
                        SUBSTRING(bx-ccbcdocu.nrodoc,4) NO-ERROR.

        mDataClient = mDataClient + "RE|" + 
            "||||" +
            lGuiaRemision + "|" +
            "09|||" + 
            gcCRLF.
    END.
END.

mDataClient = mDataClient + "PE|" +
    "GLOSAMONTO|" +
    lxNumTexto +
    gcCRLF.

/* Personalizados */
lPersonalizados = fget-personalizados(b-ccbcdocu.tipo, pTipoDocmto, pNroDocmto, pCodDiv).

mDataClient = mDataClient + lPersonalizados.

/* Correo del Cliente */
mDataClient = mDataClient + fget-email-cliente(b-ccbcdocu.codcli).
/*
RELEASE bx-ccbcdocu.

RELEASE b-ccbcdocu.
RELEASE b-ccbddocu.
*/
RELEASE gn-div.
RELEASE gn-convt.

/* Enviamos la data a la carpeta compartida */
cFile_DE = mDataClient.
cPathEntrada = cPathTemporal + "\" + cRucEmpresa + "_" + cTipoDoctoSunat + "_" + cSerieSunat + 
                cCorrelativoSunat + "_" + STRING(YEAR(TODAY),"9999") + 
                 STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + ".TXT".

/*COPY-LOB cFile_DE TO FILE cPathEntrada.*/

/* Enviamos la data al e-POS */
mDataClient = mControlIniMsg + "2" + mSeparador + mModoPrueba + mSeparador + cRucEmpresa
                + mSeparador + mID_caja + mSeparador + cTipoDoctoSunat + mSeparador + 
                mDataClient + mControlFinMsg.

/*mDataClient = mDataClient + mControlFinMsg.*/

IF USERID("integral") = 'ADMIN' OR USERID("integral") = 'MASTER' THEN DO:
    COPY-LOB mDataClient TO FILE cPathTemporal + "\" + cSerieSunat + "-" + cCorrelativoSunat + 
                        "-" + cTipoDoctoSunat + ".txt" NO-ERROR.
END.

IF NOT USERID("integral") = "MASTER" THEN DO:
    /* Set size of memory pointer to write server socket */
    SET-SIZE(mData) = 0.
    SET-SIZE(mData) = LENGTH(mDataClient) + 1.
    SET-BYTE-ORDER(mData) = BIG-ENDIAN.
    PUT-STRING(mData,1,LENGTH(mDataClient) + 1) = mDataClient.

    /* Write the whole thing to the server socket */
    lRC = hSocket:WRITE(mData,1,GET-SIZE(mData)) NO-ERROR.

    pReturn = "000|Escritura OK en el e-POS".
    IF lRC = FALSE OR ERROR-STATUS:GET-MESSAGE(1) <> '' THEN DO:
      pReturn = "999|Imposible escribir en el e-POS(" + ERROR-STATUS:GET-MESSAGE(1) + ")". 
      SET-SIZE(mData) = 0.
    END.

    IF SUBSTRING(pReturn,1,3)="000"  THEN DO:
        /* A esperar la respuesta del Server */  
        mDataServer = "".
        hSocket:SET-READ-RESPONSE-PROCEDURE('pProcessServerResponse', THIS-PROCEDURE).

        IF hSocket:CONNECTED() THEN DO: 
          /* Esperando respuesta */      
          WAIT-FOR READ-RESPONSE OF hSocket. 

          /* Cadena devuelta por el e-POS */
          mDataServer = REPLACE(mDataServer,mControlIniRpta,"").   /*STX*/
          mDataServer = REPLACE(mDataServer,mControlFinRpta,"").   /*ETX*/      

          /*pReturn = REPLACE(mDataServer,mSeparador,"|").*/
          pReturn = mDataServer.

          lCodRet = ENTRY(1,pReturn,mSeparador).

          IF (lCodRet = '0' OR lCodRet = '00') AND NUM-ENTRIES(pReturn,mSeparador) > 4 THEN DO:
                /* 000|mmmmeeeennnnssssaajjee|Codigo HASH */
                /*pReturn = "000" + "|" + ENTRY(2,pReturn,mSeparador) + "|" + ENTRY(5,pReturn,mSeparador).*/
                /* Ic - QR */
                cDATAQR = ENTRY(4,pReturn,mSeparador).
                cDATAQR = ENTRY(1,cDATAQR,"|") + "|" + ENTRY(2,cDATAQR,"|") + "|" + ENTRY(3,cDATAQR,"|") + "|" +
                            ENTRY(4,cDATAQR,"|") + "|" + ENTRY(5,cDATAQR,"|") + "|" + ENTRY(6,cDATAQR,"|") + "|" + 
                            ENTRY(7,cDATAQR,"|") + "|" + ENTRY(8,cDATAQR,"|") + "|" + ENTRY(9,cDATAQR,"|").
                cDATAQR = REPLACE(cDataQR,"|","@").
                pReturn = "000" + "|" + ENTRY(2,pReturn,mSeparador) + "|" + ENTRY(5,pReturn,mSeparador) + "|" + cDataQR.

          END.
          ELSE DO: 
                pReturn = "667|Operacion no retorno el HASH(" + mDataServer + ")".
          END.


        END.        
        ELSE DO:
            pReturn = "602|Se desconecto del servidor, cuando esperaba respuesta de este al generar FACTURA".
        END.
    END.
END.
ELSE DO:
    pReturn = "-222|User MASTER".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nc-generar-txt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nc-generar-txt Procedure 
PROCEDURE nc-generar-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTipoDocmto AS CHAR.
DEFINE INPUT PARAMETER pNroDocmto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pReturn AS CHAR NO-UNDO.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER ix-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.

FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                            b-ccbcdocu.coddiv = pCodDiv AND 
                            b-ccbcdocu.coddoc = pTipoDocmto AND 
                            b-ccbcdocu.nrodoc = pNroDocmto
                            NO-LOCK NO-ERROR.

IF NOT AVAILABLE b-ccbcdocu  THEN DO:
    pReturn = "004|Documento NO existe (Generando trama)".
    RETURN .
END.
IF b-ccbcdocu.flgest = 'A' THEN DO:
    pReturn = "004|Documento esta ANULADO (Generando trama)".
    RETURN .
END.

/* Fecha de inicio de la facturacion electronica de la tienda */
fFechaInicioFE = ?.
FIND FIRST gn-div OF b-ccbcdocu NO-LOCK NO-ERROR.
IF AVAILABLE gn-div THEN DO:
    fFechaInicioFE = gn-divi.libre_f01.
END.
IF fFechaInicioFE = ? THEN DO:
    pReturn = "664|La tienda no tiene configurado la fecha de inicio de facturacion electronica".
    RETURN .
END.

DEFINE VAR cFileSunat AS CHAR.
DEFINE VAR dDescuentos AS DEC.
DEFINE VAR lxitem AS INT.
DEFINE VAR lxNumTexto AS CHAR.
DEFINE VAR lxRucCli AS CHAR.
DEFINE VAR lxNomCli AS CHAR.
DEFINE VAR lxDirCli AS CHAR.
DEFINE VAR lxTipoIde AS CHAR.
DEFINE VAR lxImpTot AS DEC.

DEFINE VAR lxTipoNC_ND AS CHAR.
DEFINE VAR lxDoctoRef AS CHAR.
DEFINE VAR lNroDoctoRef AS CHAR INIT "".
DEFINE VAR lxDesMat AS CHAR.
DEFINE VAR lMarca AS CHAR.

DEFINE VAR lRC AS LOG.
/*DEFINE VAR lFmtoImpte AS CHAR INIT ">>>>>>9.99".*/
DEFINE VAR lCodRet AS CHAR.
DEFINE VAR lMoneda AS CHAR.
DEFINE VAR lFPago AS CHAR.
DEFINE VAR lFiler1 AS CHAR.
DEFINE VAR lFiler2 AS CHAR.
DEFINE VAR lGlosa AS CHAR.
DEFINE VAR lPrefijoRef AS CHAR.
DEFINE VAR lPersonalizados AS CHAR INIT "".

lxTipoNC_ND = '10'. /* Motivo de la N/C, usando un motivo GRAL */
lxDesMat = "".
IF b-ccbcdocu.cndcre = 'D' THEN lxTipoNC_ND = '07'.
IF b-ccbcdocu.cndcre <> 'D' THEN DO:
    FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                ccbtabla.tabla = 'N/C' AND 
                                ccbtabla.codigo = b-ccbcdocu.codcta
                                NO-LOCK NO-ERROR.
    IF AVAILABLE ccbtabla THEN DO:
        IF ccbtabla.libre_c01 <> ? AND ccbtabla.libre_c01 <> '' THEN lxTipoNC_ND = ccbtabla.libre_c01.
    END.
END.

cURLDocumento = fget-url(b-ccbcdocu.coddoc).
cTipoDoctoSunat = '07'.
lxDoctoRef = fget-doc-original(b-ccbcdocu.coddoc, b-ccbcdocu.nrodoc).
IF lxDoctoRef = ? OR lxDoctoRef = '?' THEN DO:
    pReturn = "665|Imposible ubicar el Origen del Documento".
    RETURN .
END.

lNroDoctoRef = lxDoctoRef.

cSerieSunat = SUBSTRING(lxDoctoRef,1,1).
cSerieSunat = cSerieSunat + SUBSTRING(b-ccbcdocu.nrodoc,1,3).
cCorrelativoSunat = SUBSTRING(b-ccbcdocu.nrodoc,4).
lxDoctoRef = SUBSTRING(lxDoctoRef,1,4) + "-" + SUBSTRING(lxDoctoRef,5).
lPrefijoRef = SUBSTRING(lxDoctoRef,1,1).

/* Fecha de Emision de la referencia */
DEFINE VAR lxCodRef AS CHAR INIT "".
DEFINE VAR lxNroRef AS CHAR.
DEFINE VAR lxVcto AS CHAR INIT "".

IF SUBSTRING(lxDoctoRef,1,1)="F" THEN DO:
    lxCodRef = 'FAC'.
END.
lxNroRef = SUBSTRING(lxDoctoRef,2,3) + SUBSTRING(lxDoctoRef,6).

/* Lo busco como FACTURA */
FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                ix-ccbcdocu.coddoc = lxCodRef AND 
                                ix-ccbcdocu.nrodoc = lxNroRef
                                NO-LOCK NO-ERROR.
IF NOT AVAILABLE ix-ccbcdocu THEN DO:
    IF SUBSTRING(lxDoctoRef,1,1)="B" THEN DO:
        /* Lo busco como BOLETA */
        lxCodRef = 'BOL'.
        FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                        ix-ccbcdocu.coddoc = lxCodRef AND 
                                        ix-ccbcdocu.nrodoc = lxNroRef
                                        NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ix-ccbcdocu THEN DO:
            /* Lo busco como TICKET */
            lxCodRef = 'TCK'.
            FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                            ix-ccbcdocu.coddoc = lxCodRef AND 
                                            ix-ccbcdocu.nrodoc = lxNroRef
                                            NO-LOCK NO-ERROR.
        END.
    END.
END.

IF AVAILABLE ix-ccbcdocu THEN DO:

    /* Fecha de inicio de la facturacion electronica de la tienda de donde se emitio la FAC/BOL */
    fFechaInicioFE = ?.
    FIND FIRST gn-div OF ix-ccbcdocu NO-LOCK NO-ERROR.
    IF AVAILABLE gn-div THEN DO:
        fFechaInicioFE = gn-divi.libre_f01.
    END.
    IF fFechaInicioFE = ? THEN DO:
        /*RELEASE ix-ccbcdocu.*/
        pReturn = "667|La tienda de donde se emitio el documento de referencia NO tiene configurado la fecha de inicio de facturacion electronica".
        RETURN .
    END.

    lxVcto =    STRING(YEAR(ix-ccbcdocu.fchdoc),"9999") + "-" + 
                STRING(MONTH(ix-ccbcdocu.fchdoc),"99") + "-" + 
                STRING(DAY(ix-ccbcdocu.fchdoc),"99").
    /* Si la fecha de emision del docmtno de referencia es menor al inicio de Facturacion Electronica */
    IF ix-ccbcdocu.fchdoc < fFechaInicioFE THEN DO:
        lxDoctoRef = "0" + SUBSTRING(lxDoctoRef,2).        
    END.
END.

/*RELEASE ix-ccbcdocu.*/

dDescuentos = (b-ccbcdocu.impdto + b-ccbcdocu.impdto2).

lxImpTot = b-ccbcdocu.imptot.
lxRucCli = b-ccbcdocu.ruccli.
lxNomCli = TRIM(REPLACE(b-ccbcdocu.nomcli,"|"," ")).
lxDirCli = IF (b-ccbcdocu.dircli = ?) THEN "" ELSE b-ccbcdocu.dircli.
lxDirCli = TRIM(REPLACE(lxDirCli,"|"," ")).
lxTipoIde = '6'.
lGlosa  = TRIM(REPLACE(b-ccbcdocu.glosa,"|"," ")).
lGlosa  = IF lGlosa = "" THEN "Generacion de la N/C" ELSE lGlosa.

/* UTF-8 */
lxNomCli = fget-utf-8(lxNomCli).
lxDirCli = fget-utf-8(lxDirCli).
lGlosa = fget-utf-8(lGlosa).

IF SUBSTRING(lPrefijoRef,1,1) = 'B' THEN DO:
    lxRucCli = TRIM(b-ccbcdocu.CodAnt).
    lxTipoIde = '1'.
    /*
    IF lxRucCli = ? OR lxRucCli = ''  THEN DO:
        lxRucCli  = "12345678".
    END.
    */
END.

IF lxRucCli = ? OR lxRucCli = ''  THEN DO:
    pReturn = "663|Documento Electronico le Falta RUC ó DNI(" + lxDoctoRef + "), RUC/DNI:" + TRIM(lxRucCli).
    RETURN.
END.


/*
IF lxRucCli = ? OR lxRucCli = ''  THEN DO:
    lxTipoIde = '1'.
    lxRucCli  = "12345678".
    IF b-ccbcdocu.CodAnt <> ? AND b-ccbcdocu.CodAnt <> '' AND LENGTH(b-ccbcdocu.CodAnt) = 8 THEN DO:
        lxRucCli = TRIM(b-ccbcdocu.CodAnt).
    END.
END.
ELSE DO:
    IF LENGTH(lxRucCli) = 11 AND SUBSTRING(lxRucCli,1,3) = '000' THEN DO:
        /* Es DNI */
        /*
        lxRucCli = STRING(INTEGER(lxRucCli),"99999999").
        lxTipoIde = '1'.
        */
    END.    
END.
*/

/* Data a enviar al e-POS */
mDataClient = mControlIniMsg + "2" + mSeparador + mModoPrueba + mSeparador + cRucEmpresa
                + mSeparador + mID_caja + mSeparador + cTipoDoctoSunat + mSeparador.

lMoneda = IF(b-ccbcdocu.codmon = 1) THEN 'PEN' ELSE 'USD'.
mDataClient = mDataClient + "EN|" +
        cTipoDoctoSunat + "|" +
        cSerieSunat + "-" + cCorrelativoSunat + "|" +
        lxTipoNC_ND + "|" +    /* Tipo de N/C o N/D */
        lxDoctoRef + "|" +    /* Factura que referencia la N/C */
        lGlosa + "|" +     /* Sustento */
        STRING(YEAR(b-ccbcdocu.fchdoc),"9999") + "-" + STRING(MONTH(b-ccbcdocu.fchdoc),"99") + "-" + STRING(DAY(b-ccbcdocu.fchdoc),"99") + "|" +
        lMoneda + "|" +
        cRucEmpresa + "|" +
        "6|" +   /* Tipo de Identificador del emisor */
        TRIM(cNombreComercial) + "|" +
        TRIM(cRazonSocial) + "|" +
        cUBIGEO + "|"  +   /* Codigo UBIGEO emisor */
        cDirecEmisor + "|"  +   /* Direccion Emisor */
        "|"  +   /* Departamento emisor (Ciudad) */
        "|"  +   /* Provincia emisor (Comuna) */
        "|"  +   /* Distrito Emisor */
        TRIM(lxRucCli) + "|" +
        lxTipoIde + "|" +   /* Tipo identificacion Receptor */
        lxNomCli + "|" +
        lxDirCli + "|" +
        STRING(b-ccbcdocu.impbrt,lFmtoImpte) + "|" +
        STRING(b-ccbcdocu.impigv,lFmtoImpte) + "|" +
        STRING(dDescuentos,lFmtoImpte) + "|" +
        "|" +    /* Monto Recargos */
        STRING(b-ccbcdocu.imptot,lFmtoImpte) + "|" +
        "|" +    /* Codigos de otros conceptos tributarios o comerciales recomendados */
        "|" +    /* Total Valor Venta neto */
        lxRucCli + "|" +
        lxTipoIde +   /* Tipo documento del adquiriente */
        gcCRLF.

/* DOC */
IF b-ccbcdocu.porigv = 0.00 THEN DO:
    /* Operacion Inafectas */
    mDataClient = mDataClient + "DOC|" +
        "1002|" +
        STRING(b-ccbcdocu.impvta,lFmtoImpte) +
        gcCRLF.
END.
ELSE DO:
    /* Operacion Gravadas */
    mDataClient = mDataClient + "DOC|" +
        "1001|" +
        STRING(b-ccbcdocu.impvta,lFmtoImpte) + 
        gcCRLF.            
    IF b-ccbcdocu.impexo > 0 THEN DO:                
        /* Operacion Exoneradas */
        mDataClient = mDataClient + "DOC|" +
            "1003|" +
            STRING(b-ccbcdocu.impexo,lFmtoImpte) + 
            gcCRLF.
    END.            
    /* Bonificaciones ( hay que leer el detalle del docto campo linre_c05='OF' ) */
    
    IF dDescuentos > 0 THEN DO:
        /* Descuientos */
        mDataClient = mDataClient + "DOC|" + 
            "2005|" + 
            STRING(dDescuentos,lFmtoImpte) +
            gcCRLF.
    END.
END.

lxNumTexto = "".
RUN lib\_numero.R(INPUT b-ccbcdocu.imptot, 2, 1, OUTPUT lxNumTexto).

/* UTF-8 */
lxNumTexto = fget-utf-8(lxNumTexto).

IF lMoneda = 'PEN' THEN DO:
    lxNumTexto = lxNumTexto + " SOLES".
END.
ELSE DO:
    lxNumTexto = lxNumTexto + " DOLARES AMERICANOS".
END.


mDataClient = mDataClient + "DN|" +
    "1|" +
    "1000|" +
    lxNumTexto +
    gcCRLF.

DEFINE VAR lPrecioUnit AS DEC.
DEFINE VAR lImpItmVVta AS DEC.
DEFINE VAR lVVtaUnit AS DEC.
DEFINE VAR lVVtaItem AS DEC.

DEFINE VAR lSumaIgv AS DEC.

lxitem = 1.
lSumaIgv = 0.
FOR EACH b-ccbddocu OF b-ccbcdocu NO-LOCK :

    lxDesMat = "".
    FIND FIRST almmmatg OF b-ccbddocu NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN lxDesMat = almmmatg.desmat.

    IF b-ccbcdocu.cndcre <> 'D' THEN DO:
        FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                    ccbtabla.tabla = 'N/C' AND 
                                    ccbtabla.codigo = b-ccbddocu.codmat
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE ccbtabla THEN DO:
            lxDesMat = ccbtabla.nombre.
        END.
    END.

    lxDesMat = TRIM(REPLACE(lxDesMat,"|"," ")).
    /* UTF-8 */
    lxDesMat = fget-utf-8(lxDesMat).
    lMarca = IF (AVAILABLE almmmatg) THEN fget-utf-8(almmmatg.desmar) ELSE "".

    lPrecioUnit = ROUND((b-ccbddocu.implin - b-ccbddocu.ImpDto2) / b-ccbddocu.candes , 4).
    lImpItmVVta = (b-ccbddocu.implin - b-ccbddocu.ImpDto2).  /* Casos inafectos */
    IF b-ccbcdocu.porigv > 0 THEN DO:
        lImpItmVVta = ROUND((b-ccbddocu.implin - b-ccbddocu.ImpDto2) /  (1 + ( b-ccbcdocu.porigv / 100 )) ,  2).
    END.
    lVVtaUnit = ROUND(lImpItmVVta / b-ccbddocu.candes,2).
    lVVtaItem = ROUND(b-ccbddocu.candes * lVVtaUnit,2).
    
    mDataClient = mDataClient + "DE|" +
        STRING(lxItem,">>>9") + "|" +
        STRING(lPrecioUnit,">>>>>>9.9999") + "|" +   /* 03Ago2016 - P.Uni a 4 digitos */
        /*STRING(lPrecioUnit,lFmtoImpte) + "|" +   /* 03Ago2016 - P.Uni a 4 digitos */*/
        fget-unidad-medida(b-ccbddocu.undvta) + "|"   +      /* b-ccbddocu.undvta */
        STRING(b-ccbddocu.candes,lFmtoImpte) + "|" +
        STRING(lImpItmVVta,lFmtoImpte) + "|" +
        b-ccbddocu.codmat + "|" +        
        "01|" + /* IF (b-ccbcdocu.fmapgo = '900') THEN '02' ELSE "01" */
        STRING(lVVtaUnit,lFmtoImpte) + "|" +
        STRING(lVVtaItem,lFmtoImpte) + "|" +
        "|" + 
        lMarca +
        gcCRLF.

   mDataClient = mDataClient + "DEDI|" +
       lxDesMat +
       gcCRLF.

/*
   IF b-ccbddocu.ImpDto2 > 0 THEN DO:
       PUT UNFORMATTED "DEDR|"
           "false|"
            b-ccbddocu.ImpDto2
           SKIP.
   END.
*/   
    IF b-ccbddocu.impigv > 0 THEN DO:
        mDataClient = mDataClient + "DEIM|" +
            STRING(b-ccbddocu.impigv,lFmtoImpte) + "|" +
            STRING(lImpItmVVta,lFmtoImpte) + "|"  +
            STRING(ROUND(b-ccbddocu.impigv,2), lFmtoImpte) + "|" +
            STRING(b-ccbcdocu.porigv,lFmtoImpte) + "|" +
            "|" +
            "10|" +
            "|" +
            "1000|" +
            "IGV|" +
            "VAT" +
            gcCRLF.

        lSumaIgv = lSumaIgv + ROUND(b-ccbddocu.impigv,2).

    END.

    lxItem = lxItem + 1.
END.

IF lSumaIgv > 0 THEN DO:
    mDataClient = mDataClient + "DI|" +
        STRING(lSumaIgv,lFmtoImpte) + "|" +
        STRING(lSumaIgv,lFmtoImpte) + "|" +
        "1000|" +
        "IGV|" +
        "VAT|" +
        gcCRLF.

END.

lFiler1 = IF (SUBSTRING(lPrefijoRef,1,1) = 'F') THEN "01" ELSE "03".
lFiler2 = IF (SUBSTRING(lPrefijoRef,1,1) = 'F') THEN "380" ELSE "346".
mDataClient = mDataClient + "RE|" +
    lxDoctoRef + "|" +
    lxVcto + "|" +
    lFiler1  + "|" +
    lFiler2  + "||||" +
    gcCRLF.

mDataClient = mDataClient + "PE|" +
    "GLOSAMONTO|" +
    lxNumTexto +
    gcCRLF.

/* Personalizados */
lPersonalizados = fget-personalizados(b-ccbcdocu.tipo, pTipoDocmto, pNroDocmto, pCodDiv).
mDataClient = mDataClient + lPersonalizados.

/* Correo del Cliente */
mDataClient = mDataClient + fget-email-cliente(b-ccbcdocu.codcli).

/*
RELEASE b-ccbcdocu.
RELEASE b-ccbddocu.
*/
RELEASE gn-div.
RELEASE gn-convt.

/* Enviamos la data al e-POS */
mDataClient = mDataClient + mControlFinMsg.

IF USERID("integral") = 'ADMIN' OR USERID("integral") = 'MASTER' THEN DO:
    COPY-LOB mDataClient TO FILE cPathTemporal + "\" + cSerieSunat + "-" + cCorrelativoSunat + 
                            "-" + cTipoDoctoSunat + ".txt" NO-ERROR.
END.

IF NOT USERID("integral") = 'MASTER' THEN DO:
    /* Set size of memory pointer to write server socket */
    SET-SIZE(mData) = 0.
    SET-SIZE(mData) = LENGTH(mDataClient) + 1.
    SET-BYTE-ORDER(mData) = BIG-ENDIAN.
    PUT-STRING(mData,1,LENGTH(mDataClient) + 1) = mDataClient.

    /* Write the whole thing to the server socket */
    lRC = hSocket:WRITE(mData,1,GET-SIZE(mData)) NO-ERROR.

    pReturn = "000|Escritura OK en el e-POS".
    IF lRC = FALSE OR ERROR-STATUS:GET-MESSAGE(1) <> '' THEN DO:
      pReturn = "999|Imposible escribir en el e-POS(" + ERROR-STATUS:GET-MESSAGE(1) + ")".
      SET-SIZE(mData) = 0.
    END.

    IF SUBSTRING(pReturn,1,3)="000"  THEN DO:
        /* A esperar la respuesta del Server */    
        hSocket:SET-READ-RESPONSE-PROCEDURE('pProcessServerResponse', THIS-PROCEDURE).

        IF hSocket:CONNECTED() THEN DO: 
          /* Esperando respuesta */
          mDataServer = "".
          WAIT-FOR READ-RESPONSE OF hSocket. 

          /* Cadena devuelta por el e-POS */
          mDataServer = REPLACE(mDataServer,mControlIniRpta,"").    /* STX */
          mDataServer = REPLACE(mDataServer,mControlFinRpta,"").    /* ETX */

          pReturn = mDataServer.
          /*pReturn = REPLACE(mDataServer,mSeparador,"|").*/

          lCodRet = ENTRY(1,pReturn,mSeparador).

          IF (lCodRet = '0' OR lCodRet = '00') AND NUM-ENTRIES(pReturn,mSeparador) > 4 THEN DO:
                /* 000|mmmmeeeennnnssssaajjee|Codigo HASH */
                /*pReturn = "000" + "|" + ENTRY(2,pReturn,mSeparador) + "|" + ENTRY(5,pReturn,mSeparador) + "|" + lNroDoctoRef.*/
                /* Ic - QR */
                cDATAQR = ENTRY(4,pReturn,mSeparador).
                cDATAQR = ENTRY(1,cDATAQR,"|") + "|" + ENTRY(2,cDATAQR,"|") + "|" + ENTRY(3,cDATAQR,"|") + "|" +
                            ENTRY(4,cDATAQR,"|") + "|" + ENTRY(5,cDATAQR,"|") + "|" + ENTRY(6,cDATAQR,"|") + "|" + 
                            ENTRY(7,cDATAQR,"|") + "|" + ENTRY(8,cDATAQR,"|") + "|" + ENTRY(9,cDATAQR,"|").
                cDATAQR = REPLACE(cDataQR,"|","@").
                pReturn = "000" + "|" + ENTRY(2,pReturn,mSeparador) + "|" + ENTRY(5,pReturn,mSeparador) + "|" + lNroDoctoRef + "|" + cDataQR.
          END.      
          ELSE DO: 
                pReturn = "667|Operacion no retorno el HASH(" + mDataServer + ")".
          END.

        END.        
        ELSE DO:
            pReturn = "602|Se desconecto del servidor, cuando esperaba respuesta de este al generar N/C".
        END.

    END.
END.
ELSE DO:
    pReturn = "-222|User MASTER".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nd-generar-txt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nd-generar-txt Procedure 
PROCEDURE nd-generar-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTipoDocmto AS CHAR.
DEFINE INPUT PARAMETER pNroDocmto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pReturn AS CHAR NO-UNDO.

DEFINE BUFFER ix-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.

FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                            b-ccbcdocu.coddiv = pCodDiv AND 
                            b-ccbcdocu.coddoc = pTipoDocmto AND 
                            b-ccbcdocu.nrodoc = pNroDocmto
                            NO-LOCK NO-ERROR.

IF NOT AVAILABLE b-ccbcdocu  THEN DO:
    pReturn = "004|Documento NOexiste (Generando trama)".
    RETURN .
END.
IF b-ccbcdocu.flgest = 'A' THEN DO:
    pReturn = "004|Documento esta ANULADO (Generando trama)".
    RETURN .
END.


/* Fecha de inicio de la facturacion electronica de la tienda */
fFechaInicioFE = ?.
FIND FIRST gn-div OF b-ccbcdocu NO-LOCK NO-ERROR.
IF AVAILABLE gn-div THEN DO:
    fFechaInicioFE = gn-divi.libre_f01.
END.
IF fFechaInicioFE = ? THEN DO:
    pReturn = "664|La tienda no tiene configurado la fecha de inicio de facturacion electronica".
    RETURN .
END.

DEFINE VAR cFileSunat AS CHAR.
DEFINE VAR dDescuentos AS DEC.
DEFINE VAR lxitem AS INT.
DEFINE VAR lxNumTexto AS CHAR.
DEFINE VAR lxRucCli AS CHAR.
DEFINE VAR lxNomCli AS CHAR.
DEFINE VAR lxDirCli AS CHAR.
DEFINE VAR lxTipoIde AS CHAR.
DEFINE VAR lxImpTot AS DEC.

DEFINE VAR lxTipoNC_ND AS CHAR.
DEFINE VAR lxDoctoRef AS CHAR.
DEFINE VAR lNroDoctoRef AS CHAR INIT "".
DEFINE VAR lxDesMat AS CHAR.
DEFINE VAR lMarca AS CHAR.

DEFINE VAR lRC AS LOG.
DEFINE VAR lFmtoImpte AS CHAR INIT ">>>>>>9.99".
DEFINE VAR lCodRet AS CHAR.
DEFINE VAR lMoneda AS CHAR.
DEFINE VAR lFPago AS CHAR.
DEFINE VAR lFiler1 AS CHAR.
DEFINE VAR lFiler2 AS CHAR.
DEFINE VAR lGlosa AS CHAR.
DEFINE VAR lPrefijoRef AS CHAR.
DEFINE VAR lPersonalizados AS CHAR INIT "".

lxTipoNC_ND = '03'.  /* Motivo de la N/D, usando un motivo GRAL */
lxDesMat = "".
IF b-ccbcdocu.cndcre = 'D' THEN lxTipoNC_ND = '08'.
IF b-ccbcdocu.cndcre <> 'D' THEN DO:
    FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                ccbtabla.tabla = 'N/D' AND 
                                ccbtabla.codigo = b-ccbcdocu.codcta
                                NO-LOCK NO-ERROR.
    IF AVAILABLE ccbtabla THEN DO:
        IF ccbtabla.libre_c01 <> ? AND ccbtabla.libre_c01 <> '' THEN lxTipoNC_ND = ccbtabla.libre_c01.
    END.
END.

cURLDocumento = fget-url(b-ccbcdocu.coddoc).
cTipoDoctoSunat = '08'.

/* ************************************ */

lxDoctoRef = fget-doc-original(b-ccbcdocu.coddoc, b-ccbcdocu.nrodoc).
IF lxDoctoRef = ? OR lxDoctoRef = '?' THEN DO:
    pReturn = "665|Imposible ubicar el Origen del Documento".
    RETURN .
END.

lNroDoctoRef = lxDoctoRef.

cSerieSunat = SUBSTRING(lxDoctoRef,1,1).
cSerieSunat = cSerieSunat + SUBSTRING(b-ccbcdocu.nrodoc,1,3).
cCorrelativoSunat = SUBSTRING(b-ccbcdocu.nrodoc,4).

lxDoctoRef = SUBSTRING(lxDoctoRef,1,4) + "-" + SUBSTRING(lxDoctoRef,5).
lPrefijoRef = SUBSTRING(lxDoctoRef,1,1).

/* Fecha de Emision de la referencia */
DEFINE VAR lxCodRef AS CHAR INIT "".
DEFINE VAR lxNroRef AS CHAR.
DEFINE VAR lxVcto AS CHAR INIT "".

IF SUBSTRING(lxDoctoRef,1,1)="F" THEN DO:
    lxCodRef = 'FAC'.
END.
lxNroRef = SUBSTRING(lxDoctoRef,2,3) + SUBSTRING(lxDoctoRef,6).

FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                ix-ccbcdocu.coddoc = lxCodRef AND 
                                ix-ccbcdocu.nrodoc = lxNroRef
                                NO-LOCK NO-ERROR.
IF NOT AVAILABLE ix-ccbcdocu THEN DO:
    IF SUBSTRING(lxDoctoRef,1,1)="B" THEN DO:
        lxCodRef = 'BOL'.
        FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                        ix-ccbcdocu.coddoc = lxCodRef AND 
                                        ix-ccbcdocu.nrodoc = lxNroRef
                                        NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ix-ccbcdocu THEN DO:
            lxCodRef = 'TCK'.
            FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                            ix-ccbcdocu.coddoc = lxCodRef AND 
                                            ix-ccbcdocu.nrodoc = lxNroRef
                                            NO-LOCK NO-ERROR.
        END.
    END.
END.

IF AVAILABLE ix-ccbcdocu THEN DO:
    /* Fecha de inicio de la facturacion electronica de la tienda de donde se emitio la FAC/BOL */
    fFechaInicioFE = ?.
    FIND FIRST gn-div OF ix-ccbcdocu NO-LOCK NO-ERROR.
    IF AVAILABLE gn-div THEN DO:
        fFechaInicioFE = gn-divi.libre_f01.
    END.
    IF fFechaInicioFE = ? THEN DO:
        /*RELEASE ix-ccbcdocu.*/
        pReturn = "667|La tienda de donde se emitio el documento de referencia NO tiene configurado la fecha de inicio de facturacion electronica".
        RETURN .
    END.

    lxVcto =    STRING(YEAR(ix-ccbcdocu.fchdoc),"9999") + "-" + 
                STRING(MONTH(ix-ccbcdocu.fchdoc),"99") + "-" + 
                STRING(DAY(ix-ccbcdocu.fchdoc),"99").
    /* Si la fecha de emision del docmtno de referencia es menor al inicio de Facturacion Electronica */
    IF ix-ccbcdocu.fchdoc < fFechaInicioFE THEN DO:
        lxDoctoRef = "0" + SUBSTRING(lxDoctoRef,2).        
    END.

END.

/*RELEASE ix-ccbcdocu.*/

/***************************/
/*
IF b-ccbcdocu.codref = "LET" THEN DO:
    /* F0010014587 / B002001258 */
    lxDoctoRef = fget-doc-original(b-ccbcdocu.codref, b-ccbcdocu.nroref).
    cSerieSunat = SUBSTRING(lxDoctoRef,1,1).
    lxDoctoRef = SUBSTRING(lxDoctoRef,1,4) + "-" + SUBSTRING(lxDoctoRef,5).
END.
ELSE DO:    
    cSerieSunat = fGet-prefijo-serie(b-ccbcdocu.codref, b-ccbcdocu.nroref, "").
    lxDoctoRef = cSerieSunat + SUBSTRING(b-ccbcdocu.nroref,1,3) + "-" + SUBSTRING(b-ccbcdocu.nroref,4).
END.
cSerieSunat = cSerieSunat + SUBSTRING(b-ccbcdocu.nrodoc,1,3).
cCorrelativoSunat = SUBSTRING(b-ccbcdocu.nrodoc,4).
*/
 
dDescuentos = (b-ccbcdocu.impdto + b-ccbcdocu.impdto2).

lxImpTot = b-ccbcdocu.imptot.
lxRucCli = b-ccbcdocu.ruccli.
lxNomCli = TRIM(REPLACE(b-ccbcdocu.nomcli,"|"," ")).
lxDirCli = IF (b-ccbcdocu.dircli = ?) THEN "" ELSE b-ccbcdocu.dircli.
lxDirCli = TRIM(REPLACE(lxDirCli,"|"," ")).
lxTipoIde = '6'.
lGlosa  = TRIM(REPLACE(b-ccbcdocu.glosa,"|"," ")).
lGlosa  = IF lGlosa = "" THEN "Generacion de la N/D" ELSE lGlosa.

IF SUBSTRING(lPrefijoRef,1,1) = 'B' THEN DO:
    IF lxRucCli <> ? AND lxRucCli <> '' THEN DO:
        lxTipoIde = '6'.
    END.
    ELSE DO:
        lxRucCli = TRIM(b-ccbcdocu.CodAnt).
        lxTipoIde = '1'.
    END.
  /*
  IF lxRucCli = ? OR lxRucCli = ''  THEN DO:
      lxRucCli  = "12345678".
  END.
  */
END.

IF lxRucCli = ? OR lxRucCli = ''  THEN DO:
  pReturn = "663|Documento le Falta RUC ó DNI".
  RETURN.
END.

/*                                                          
IF lxRucCli = ? OR lxRucCli = ''  THEN DO:
    lxTipoIde = '1'.
    lxRucCli  = "12345678".
    IF b-ccbcdocu.CodAnt <> ? AND b-ccbcdocu.CodAnt <> '' AND LENGTH(b-ccbcdocu.CodAnt) = 8 THEN DO:
        lxRucCli = TRIM(b-ccbcdocu.CodAnt).        
    END.
END.
ELSE DO:
    IF LENGTH(lxRucCli) = 11 AND SUBSTRING(lxRucCli,1,3) = '000' THEN DO:
        /* Es DNI */
        lxRucCli = STRING(INTEGER(lxRucCli),"99999999").
        lxTipoIde = '1'.
    END.    
END.
*/

/* Data a enviar al e-POS */
mDataClient = mControlIniMsg + "2" + mSeparador + mModoPrueba + mSeparador + cRucEmpresa
                + mSeparador + mID_caja + mSeparador + cTipoDoctoSunat + mSeparador.

lMoneda = IF(b-ccbcdocu.codmon = 1) THEN 'PEN' ELSE 'USD'.
mDataClient = mDataClient + "EN|" +
        cTipoDoctoSunat + "|" +
        cSerieSunat + "-" + cCorrelativoSunat + "|" +
        lxTipoNC_ND + "|" +    /* Tipo de N/C o N/D */
        lxDoctoRef + "|" +    /* Factura que referencia la N/D */
        lGlosa + "|" +     /* Sustento */
        STRING(YEAR(b-ccbcdocu.fchdoc),"9999") + "-" + STRING(MONTH(b-ccbcdocu.fchdoc),"99") + "-" + STRING(DAY(b-ccbcdocu.fchdoc),"99") + "|" +
        lMoneda + "|" +
        cRucEmpresa + "|" +
        "6|" +   /* Tipo de Identificador del emisor */
        TRIM(cNombreComercial) + "|" +
        TRIM(cRazonSocial) + "|" +
        cUBIGEO + "|"  +   /* Codigo UBIGEO emisor */
        cDirecEmisor + "|"  +   /* Direccion Emisor */
        "|"  +   /* Departamento emisor (Ciudad) */
        "|"  +   /* Provincia emisor (Comuna) */
        "|"  +   /* Distrito Emisor */
        TRIM(lxRucCli) + "|" +
        lxTipoIde + "|" +   /* Tipo identificacion Receptor */
        lxNomCli + "|" +
        lxDirCli + "|" +
        STRING(b-ccbcdocu.impbrt,lFmtoImpte) + "|" +
        STRING(b-ccbcdocu.impigv,lFmtoImpte) + "|" +
        STRING(dDescuentos,lFmtoImpte) + "|" +
        "|" +    /* Monto Recargos */
        STRING(b-ccbcdocu.imptot,lFmtoImpte) + "|" +
        "|" +    /* Codigos de otros conceptos tributarios o comerciales recomendados */
        "|" +    /* Total Valor Venta neto */
        lxRucCli + "|" +
        lxTipoIde +   /* Tipo documento del adquiriente */
        gcCRLF.

/* DOC */
IF b-ccbcdocu.porigv = 0.00 THEN DO:
    /* Operacion Inafectas */
    mDataClient = mDataClient + "DOC|" +
        "1002|" +
        STRING(b-ccbcdocu.impvta,lFmtoImpte) +
        gcCRLF.
END.
ELSE DO:
    /* Operacion Gravadas */
    mDataClient = mDataClient + "DOC|" +
        "1001|" +
        STRING(b-ccbcdocu.impvta,lFmtoImpte) + 
        gcCRLF.            
    IF b-ccbcdocu.impexo > 0 THEN DO:                
        /* Operacion Exoneradas */
        mDataClient = mDataClient + "DOC|" +
            "1003|" +
            STRING(b-ccbcdocu.impexo,lFmtoImpte) + 
            gcCRLF.
    END.            
    /* Bonificaciones ( hay que leer el detalle del docto campo linre_c05='OF' ) */
    
    IF dDescuentos > 0 THEN DO:
        /* Descuientos */
        mDataClient = mDataClient + "DOC|" + 
            "2005|" + 
            STRING(dDescuentos,lFmtoImpte) +
            gcCRLF.
    END.
END.

lxNumTexto = "".
RUN lib\_numero.R(INPUT b-ccbcdocu.imptot, 2, 1, OUTPUT lxNumTexto).

IF lMoneda = 'PEN' THEN DO:
    lxNumTexto = lxNumTexto + " SOLES".
END.
ELSE DO:
    lxNumTexto = lxNumTexto + " DOLARES AMERICANOS".
END.


mDataClient = mDataClient + "DN|" +
    "1|" +
    "1000|" +
    lxNumTexto +
    gcCRLF.

DEFINE VAR lPrecioUnit AS DEC.
DEFINE VAR lImpItmVVta AS DEC.
DEFINE VAR lVVtaUnit AS DEC.
DEFINE VAR lVVtaItem AS DEC.

DEFINE VAR lSumaIgv AS DEC.

lxitem = 1.
lSumaIgv = 0.
FOR EACH b-ccbddocu OF b-ccbcdocu NO-LOCK :
    lxDesMat = "".
    FIND FIRST almmmatg OF b-ccbddocu NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN lxDesMat = almmmatg.desmat.

    IF b-ccbcdocu.cndcre <> 'D' THEN DO:
        FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                    ccbtabla.tabla = 'N/D' AND 
                                    ccbtabla.codigo = b-ccbddocu.codmat
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE ccbtabla THEN DO:
            lxDesMat = ccbtabla.nombre.
        END.
    END.

    lxDesMat = TRIM(REPLACE(lxDesMat,"|"," ")).
    lMarca = IF (AVAILABLE almmmatg) THEN fget-utf-8(almmmatg.desmar) ELSE "".

    lPrecioUnit = ROUND((b-ccbddocu.implin - b-ccbddocu.ImpDto2) / b-ccbddocu.candes , 4).
    lImpItmVVta = (b-ccbddocu.implin - b-ccbddocu.ImpDto2).  /* Casos inafectos */
    IF b-ccbcdocu.porigv > 0 THEN DO:
        lImpItmVVta = ROUND((b-ccbddocu.implin - b-ccbddocu.ImpDto2) /  (1 + ( b-ccbcdocu.porigv / 100 )) ,  2).
    END.
    lVVtaUnit = ROUND(lImpItmVVta / b-ccbddocu.candes,2).
    lVVtaItem = ROUND(b-ccbddocu.candes * lVVtaUnit,2).
    
    mDataClient = mDataClient + "DE|" +
        STRING(lxItem,">>>9") + "|" +
        STRING(lPrecioUnit,">>>>>>9.9999") + "|" +   /* 03Ago2016 - P.Uni a 4 digitos */
        /*STRING(lPrecioUnit,lFmtoImpte) + "|" +   /* 03Ago2016 - P.Uni a 4 digitos */*/
        fget-unidad-medida(b-ccbddocu.undvta) + "|"   +      /* b-ccbddocu.undvta */
        STRING(b-ccbddocu.candes,lFmtoImpte) + "|" +
        STRING(lImpItmVVta,lFmtoImpte) + "|" +
        b-ccbddocu.codmat + "|" +        
        "01|" + /* IF (b-ccbcdocu.fmapgo = '900') THEN '02' ELSE "01" */
        STRING(lVVtaUnit,lFmtoImpte) + "|" +
        STRING(lVVtaItem,lFmtoImpte) + "|" +
        "|" +
        lMarca + 
        gcCRLF.

   mDataClient = mDataClient + "DEDI|" +
       lxDesMat +
       gcCRLF.

/*
   IF b-ccbddocu.ImpDto2 > 0 THEN DO:
       PUT UNFORMATTED "DEDR|"
           "false|"
            b-ccbddocu.ImpDto2
           SKIP.
   END.
*/   
    IF b-ccbddocu.impigv > 0 THEN DO:
        mDataClient = mDataClient + "DEIM|" +
            STRING(b-ccbddocu.impigv,lFmtoImpte) + "|" +
            STRING(lImpItmVVta,lFmtoImpte) + "|"  +
            STRING(ROUND(b-ccbddocu.impigv,2), lFmtoImpte) + "|" +
            STRING(b-ccbcdocu.porigv,lFmtoImpte) + "|" +
            "|" +
            "10|" +
            "|" +
            "1000|" +
            "IGV|" +
            "VAT" +
            gcCRLF.

        lSumaIgv = lSumaIgv + ROUND(b-ccbddocu.impigv,2).

    END.

    lxItem = lxItem + 1.
END.     

lFiler1 = IF (SUBSTRING(lPrefijoRef,1,1) = 'F') THEN "01" ELSE "03".
lFiler2 = IF (SUBSTRING(lPrefijoRef,1,1) = 'F') THEN "380" ELSE "346".
mDataClient = mDataClient + "RE|" +
    lxDoctoRef + "|" +
    lxVcto + "|" +
    lFiler1  + "|" +
    lFiler2  + "||||" +
    gcCRLF.

IF lSumaIgv > 0 THEN DO:
    mDataClient = mDataClient + "DI|" +
        STRING(lSumaIgv,lFmtoImpte) + "|" +
        STRING(lSumaIgv,lFmtoImpte) + "|" +
        "1000|" +
        "IGV|" +
        "VAT|" +
        gcCRLF.

END.
mDataClient = mDataClient + "PE|" +
    "GLOSAMONTO|" +
    lxNumTexto +
    gcCRLF.

/* Personalizados */
lPersonalizados = fget-personalizados(b-ccbcdocu.tipo, pTipoDocmto, pNroDocmto, pCodDiv).
mDataClient = mDataClient + lPersonalizados.

/* Correo del Cliente */
mDataClient = mDataClient + fget-email-cliente(b-ccbcdocu.codcli).

/*
RELEASE b-ccbcdocu.
RELEASE b-ccbddocu.
*/
RELEASE gn-div.
RELEASE gn-convt.

/* Enviamos la data al e-POS */
mDataClient = mDataClient + mControlFinMsg.

IF USERID("integral") = 'ADMIN' OR USERID("integral") = 'MASTER' THEN DO:
    COPY-LOB mDataClient TO FILE cPathTemporal + "\" + cSerieSunat + "-" + cCorrelativoSunat + 
                        "-" + cTipoDoctoSunat + ".txt".

END.

IF NOT USERID("integral") = "MASTER" THEN DO:
    /* Set size of memory pointer to write server socket */
    SET-SIZE(mData) = 0.
    SET-SIZE(mData) = LENGTH(mDataClient) + 1.
    SET-BYTE-ORDER(mData) = BIG-ENDIAN.
    PUT-STRING(mData,1,LENGTH(mDataClient) + 1) = mDataClient.

    /* Write the whole thing to the server socket */
    lRC = hSocket:WRITE(mData,1,GET-SIZE(mData)) NO-ERROR.

    pReturn = "000|Escritura OK en el e-POS".
    IF lRC = FALSE OR ERROR-STATUS:GET-MESSAGE(1) <> '' THEN DO:
      pReturn = "999|Imposible escribir en el e-POS(" + ERROR-STATUS:GET-MESSAGE(1) + ")".
      SET-SIZE(mData) = 0.
    END.

    IF SUBSTRING(pReturn,1,3)="000"  THEN DO:    
        /* A esperar la respuesta del Server */    
        hSocket:SET-READ-RESPONSE-PROCEDURE('pProcessServerResponse', THIS-PROCEDURE).

        IF hSocket:CONNECTED() THEN DO: 
          /* Esperando respuesta */
          mDataServer = "".
          WAIT-FOR READ-RESPONSE OF hSocket. 

          /* Cadena devuelta por el e-POS */
          mDataServer = REPLACE(mDataServer,mControlIniRpta,"").    /* STX */
          mDataServer = REPLACE(mDataServer,mControlFinRpta,"").    /* ETX */

          pReturn = mDataServer.
          /*pReturn = REPLACE(mDataServer,mSeparador,"|").*/

          lCodRet = ENTRY(1,pReturn,mSeparador).

          IF (lCodRet = '0' OR lCodRet = '00') AND NUM-ENTRIES(pReturn,mSeparador) > 4 THEN DO:
                /* 000|mmmmeeeennnnssssaajjee|Codigo HASH */
                /*pReturn = "000" + "|" + ENTRY(2,pReturn,mSeparador) + "|" + ENTRY(5,pReturn,mSeparador) + "|" + lNroDoctoRef.*/
                /* Ic - QR */
                cDATAQR = ENTRY(4,pReturn,mSeparador).
                cDATAQR = ENTRY(1,cDATAQR,"|") + "|" + ENTRY(2,cDATAQR,"|") + "|" + ENTRY(3,cDATAQR,"|") + "|" +
                            ENTRY(4,cDATAQR,"|") + "|" + ENTRY(5,cDATAQR,"|") + "|" + ENTRY(6,cDATAQR,"|") + "|" + 
                            ENTRY(7,cDATAQR,"|") + "|" + ENTRY(8,cDATAQR,"|") + "|" + ENTRY(9,cDATAQR,"|").
                cDATAQR = REPLACE(cDataQR,"|","@").
                pReturn = "000" + "|" + ENTRY(2,pReturn,mSeparador) + "|" + ENTRY(5,pReturn,mSeparador) + "|" + lNroDoctoRef + "|" + cDataQR.
          END.      
          ELSE DO: 
                pReturn = "667|Operacion no retorno el HASH(" + mDataServer + ")".
          END.

        END.        
        ELSE DO:
            pReturn = "602|Se desconecto del servidor, cuando esperaba respuesta de este al generar N/C".
        END.
    END.
END.
ELSE DO:
    pReturn = "-222|User MASTER".
END.

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

IF pFormaPago = '900' THEN DO:
    /* Por ahora estamos poniendo 15 sin afecto a IGV x promocion */
    /*lRetval = '21'.*/
END.
IF pFormaPago = '899' THEN DO:
    /* Por ahora estamos poniendo 15 sin afecto a IGV x promocion */
    lRetval = '21'.
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
IF pFormaPago = '900' THEN DO:
    lRetVal = '1002'.
END.
IF pFormaPago = '899' THEN DO:
    lRetVal = '1004'.
END.

pConceptoTributario = lRetVal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pconectar-ws) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pconectar-ws Procedure 
PROCEDURE pconectar-ws :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*DEFINE INPUT PARAMETER pWDSL AS CHAR NO-UNDO.*/
DEFINE INPUT PARAMETER pDestino AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE VAR lWDSL AS CHAR.

lWDSL = cURL_WDSL_EGATEWAY.

CASE CAPS(pDestino) :
    WHEN 'EGATEWAY' THEN lWDSL = cURL_WDSL_eGateWay.
    WHEN 'ESERVER' THEN lWDSL = cURL_WDSL_eServer.
    WHEN 'SUNAT' THEN lWDSL = cURL_WDSL_Sunat.
END CASE.

pRetVal = "000|Conexion WDSL OK(" + lWDSL + ")".

RUN pdesconectar-ws.

/* Set up a proxy for the service interface. This uses the Port Type name */
/* Fijamos un proxy para la interface del servicio, aca usamos el nombre del PortType */
CREATE SERVER hWebService.
/*hWebService:CONNECT("-WSDL 'http://192.168.100.245:8060/axis2/services/Online?wsdl'") NO-ERROR.*/
hWebService:CONNECT("-WSDL '" + lWDSL + "'") NO-ERROR.
    
IF NOT hWebService:CONNECTED() THEN DO:
    pRetVal = "999|" + lWDSL + ", no esta conectado".

    DELETE OBJECT hWebService NO-ERROR.
    DELETE OBJECT hPortType NO-ERROR.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pconectar-ws-port) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pconectar-ws-port Procedure 
PROCEDURE pconectar-ws-port :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pPuerto AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

/* use the Port type name here to create proxy and set a handle to it */
/* Usamos el nombre del Port Type para crear un proy y asignarlo a una  variable handle */

/*RUN OnLinePortType SET hOnLinePortType ON hWebService NO-ERROR.    */
RUN VALUE(pPuerto) SET hPortType ON hWebService NO-ERROR.

pRetVal = "000|OK".
IF NOT VALID-HANDLE(hPortType) THEN DO:
    pRetVal = "888|Puerto : " + pPuerto + " no es valido".

    RUN pdesconectar-ws.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pconecto-epos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pconecto-epos Procedure 
PROCEDURE pconecto-epos :
/*------------------------------------------------------------------------------
  Purpose:  Conectarse al e-POS via Socket
    Notes:  
------------------------------------------------------------------------------*/

/* 01 : Conectar al ePOS */

DEFINE INPUT    PARAMETER pDivision AS CHAR.
DEFINE INPUT    PARAMETER pCodCaja AS CHAR.
DEFINE OUTPUT   PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE VAR lRetVal AS CHAR.
DEFINE VAR lHost AS CHAR.
DEFINE VAR lPort AS CHAR.
DEFINE VAR lStrConn AS CHAR.

DEFINE VAR x-logtxt AS CHAR.
DEFINE VAR x-logmsg AS CHAR.
DEFINE VAR x-ip-epos AS CHAR.

DEFINE VAR lConexionVal AS CHAR INIT "***".

cDivision = "".
mShowMsg = YES.

DEFINE BUFFER x-factabla FOR factabla.
EMPTY TEMP-TABLE tt-ePos.

/* Busco su ID de la CAJA */
FIND FIRST ccbcterm WHERE ccbcterm.codcia = s-codcia AND
                        ccbcterm.coddiv = pDivision AND 
                        ccbcterm.codter = pCodCaja
                        NO-LOCK NO-ERROR.
IF AVAILABLE ccbcterm THEN DO:
    IF NOT (TRUE <> (ccbcterm.id_pos > ""))  THEN DO:
        /* Busco la IP del ePos */
        FIND FIRST FECFGEPOS WHERE FECFGEPOS.codcia = s-codcia AND
                                    FECFGEPOS.coddiv = pDivision AND
                                    FECFGEPOS.ID_POS = ccbcterm.id_pos      /* ID de caja */
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE FECFGEPOS THEN DO:
            CREATE tt-ePos.
                ASSIGN  tt-sec  = "00"
                        tt-ip   = TRIM(FECFGEPOS.IP_EPOS)
                        tt-port = TRIM(FECFGEPOS.PORT_EPOS) 
                        tt-id   = TRIM(FECFGEPOS.ID_POS).
        END.
    END.
END.
ELSE DO:
    /* CDs */
    FOR EACH FECFGEPOS NO-LOCK WHERE FECFGEPOS.codcia = s-codcia AND 
                            FECFGEPOS.coddiv = pDivision AND 
                            FECFGEPOS.tipo > "05"
                            BY FECFGEPOS.tipo:
        CREATE tt-ePos.
            ASSIGN  tt-sec  = FECFGEPOS.tipo
                    tt-ip   = TRIM(FECFGEPOS.IP_EPOS)
                    tt-port = TRIM(FECFGEPOS.PORT_EPOS) 
                    tt-id   = TRIM(FECFGEPOS.ID_POS).

    END.
END.

/**/
FIND FIRST tt-ePos NO-LOCK NO-ERROR.

IF AVAILABLE tt-ePos THEN DO:

    cDivision = pDivision.
   
    /* Desconectamos el e-POS */    
    fDesconectar-epos().    

    /*lRetVal = '002|No tiene configurado el IP y/o Puerto del e-POS en tabla FECFGEPOS'.*/
    lRetVal = '002|Los ePOS esta ocupados'.
    FOR EACH tt-epos NO-LOCK BY tt-sec:

        /* Ic - 28Feb2018, controlar que el ePOS no este ocupado */
        /*
        x-ip-epos = TRIM(tt-epos.tt-ip).
        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                                    factabla.tabla = 'EPOS' AND 
                                    factabla.codigo = x-ip-epos NO-ERROR.        
        IF NOT AVAILABLE factabla THEN DO:
            CREATE factabla.
                ASSIGN factabla.codcia = s-codcia
                        factabla.tabla = 'EPOS'
                        factabla.codigo = x-ip-epos
                        factabla.campo-L[1] = NO.
        END.
        IF factabla.campo-L[1] = NO THEN DO:
            ASSIGN factabla.campo-L[1] = YES
                factabla.campo-c[1] = STRING(NOW,"99/99/9999 HH:MM:SS").
        END.
        ELSE DO:
            /* ePOS ocupado, verificar si realmente esta ocupado */
            DEFINE VAR x-fecha-hora-epos AS CHAR.
            DEFINE VAR x-fecha-hora-sistema AS DATETIME.
            DEFINE VAR y-fecha-hora-epos AS DATETIME.
            DEFINE VAR x-segundos-transcurridos AS INT.
            
            x-fecha-hora-epos = factabla.campo-c[1].
            x-fecha-hora-sistema = NOW.
            y-fecha-hora-epos = DATETIME(x-fecha-hora-epos).

            x-segundos-transcurridos = (x-fecha-hora-sistema - y-fecha-hora-epos).
            IF x-segundos-transcurridos > 30 THEN DO:
                /* El ePOS no puede estar ocupado mas de 30 Segundos */
                ASSIGN factabla.campo-c[1] = STRING(NOW,"99/99/9999 HH:MM:SS").
            END.
            ELSE DO:
                /* Siguiente ePOS */
                NEXT.
            END.

        END.
        */

        /* Parametros conexion del e-POS */
        lHost = TRIM(tt-epos.tt-ip).
        lPort = TRIM(tt-epos.tt-port). 
        /* el ID de la caja para el ePOS, va para la configuracion */
        mID_caja = TRIM(tt-epos.tt-id).
        mIP_ePOS = lHost.
        mNO_PORT = TRIM(lPort).
        lRetVal = "002|EROR Conexion - IP(" + lHost + ") , ID Caja(" + mID_caja + ")".

        IF lHost <> '' AND lPort <> '' THEN DO:
            /* Conectar el e-POS */
            lRetVal = "000|Conexion Ok - IP(" + lHost + ") , ID Caja(" + mID_caja + ")".
            lStrConn = "-H " + lHost + " -S " + lPort.            

            /* -- LOG ---- */
            x-logmsg = lStrConn + " / IP(" + lHost + ") , ID Caja(" + mID_caja + "), DIVISION(" + pDivision + ")".
            x-logtxt = flog-epos-txt("CONECTO EPOS (Conectandose) : " + x-logmsg).

            hSocket:CONNECT(lStrConn) NO-ERROR.
            IF hSocket:CONNECTED() = YES THEN DO:

                /* -- LOG ---- */
                x-logtxt = flog-epos-txt("CONECTO EPOS (Configurar) : " + x-logmsg).

                /* Configuracion del e-POS */            
                lRetVal = "989|Antes de configurar".
                RUN pConfigurar-epos(OUTPUT lRetval).

                IF SUBSTRING(lRetVal,1,3)="000"  THEN DO:

                    /* -- LOG ---- */
                    x-logtxt = flog-epos-txt("CONECTO EPOS (Configuracion Ok) : " + x-logmsg).

                    lRetVal = lRetVal + "|" + lHost + "|" + mID_caja.
                    LEAVE.
                END.                
                ELSE DO:
                    /* -- LOG ---- */
                    x-logtxt = flog-epos-txt("CONECTO EPOS (Error configurar) : " + x-logmsg + " : MSG(" + lRetVal + ")").

                    /* Desconectamos el e-POS si no se puede Configurar */    
                    fDesconectar-epos().
                END.
            END.
            ELSE DO:
                /* ----- LOG ----------- */
                x-logtxt = flog-epos-txt("CONECTO EPOS (Nose pudo conectar) " + x-logmsg).

                lRetVal = "999|Imposible conectarse al e-Pos -  Host(" + lHost + 
                            ") Port(" + lPort + ") ID Caja (" + mID_caja + ") - Divi:" + pDivision .
            END.
        END.
    END.
    IF lRetVal = '002|Los ePOS esta ocupados' THEN DO:
        x-logtxt = flog-epos-txt("CONECTO EPOS (Nose pudo conectar - ePOS OCUPADOS) " + x-logmsg).
    END.
END.
ELSE DO:

    x-logtxt = flog-epos-txt("CONECTO EPOS (Error ) :  Division(" +  pDivision + "), ID Caja(" + pCodCaja + ")  no esta inscrito en la tabla FECFGEPOS de e-POS").

    lRetVal = "001|Division(" + pDivision + "), ID Caja(" + pCodCaja + ")  no esta inscrito en la tabla FECFGEPOS de e-POS".
END.

pRetVal = lRetVal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pconexion-epos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pconexion-epos Procedure 
PROCEDURE pconexion-epos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pIP_ePOS AS CHAR.
DEFINE INPUT PARAMETER pPORT_ePOS AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

DEFINE VAR lRetVal AS CHAR.
DEFINE VAR lStrConn AS CHAR.

/* Desconectar */
IF VALID-HANDLE(hSocket) THEN DO:
    IF hSocket:CONNECTED() THEN DO:
        hSocket:DISCONNECT() NO-ERROR.
    END. 
END.

SET-SIZE(mHeader) = 0.
SET-SIZE(mData)   = 0.
ERROR-STATUS:ERROR  = NO.

/*  */
lRetVal = "999|Imposible Conectar al ePOS(" + pIP_ePOS + ") Port(" + pPORT_ePOS + ")".

lStrConn = "-H " + pIP_ePOS + " -S " + pPORT_ePOS.
hSocket:CONNECT(lStrConn) NO-ERROR.        

IF hSocket:CONNECTED() = YES THEN DO:
    lRetVal = "000|Conexion Ok".
END.

pRetVal = lRetVal.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pconfigurar-epos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pconfigurar-epos Procedure 
PROCEDURE pconfigurar-epos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 
    01.01  : Configurar el ePOS 
   
   mID_ePOS : Id de caja 

*/

DEFINE OUTPUT PARAMETER pRetval AS CHAR.

DEFINE VAR z-filer AS CHAR.

  DEFINE VAR lDataEnvio AS CHAR.
  DEFINE VAR lRC AS LOG.
  DEFINE VAR lCodRet AS CHAR.
  
  lDataEnvio = mControlIniMsg + "1" + mSeparador + mModoPrueba + mSeparador + cRucEmpresa
            + mSeparador + mID_caja + mSeparador + cDivision + mControlFinMsg .

  z-filer = flog-epos-txt("CONECTO EPOS (Configurar) :   Paso 1 - preparando data para el SOCKET DIV(" + cDivision + ")  Caja(" + mID_caja + ")").

  pRetVal = "998|Configuracion error en escritura del SCKET".

  /* Set size of memory pointer to write server socket */
  SET-SIZE(mData) = 0.
  SET-SIZE(mData) = LENGTH(ldataEnvio) + 1.
  SET-BYTE-ORDER(mData) = BIG-ENDIAN.
  PUT-STRING(mData,1,LENGTH(ldataEnvio) + 1) = lDataEnvio.

  /* Write the whole thing to the server socket */
  lRC = hSocket:WRITE(mData,1,GET-SIZE(mData)) NO-ERROR.

  z-filer = flog-epos-txt("CONECTO EPOS (Configurar) :   Paso 2 - Escribiendo al SOCKET DIV(" + cDivision + ")  Caja(" + mID_caja + ")").

  pRetVal = "000|Configuracion enviado correctamente".
  IF lRC = FALSE OR ERROR-STATUS:ERROR = YES THEN DO:

      z-filer = flog-epos-txt("CONECTO EPOS (Configurar) :   Paso 3 - Error escritura en el Socket DIV(" + cDivision + ")  Caja(" + mID_caja + ")").

      pRetVal = "001|No se pudo enviar la configuracion al e-POS".
      SET-SIZE(mData) = 0.
  END.

  IF SUBSTRING(pRetVal,1,3)="000"  THEN DO:

      z-filer = flog-epos-txt("CONECTO EPOS (Configurar) :   Paso 4 - Escritura OK DIV(" + cDivision + ")  Caja(" + mID_caja + ")").
      /* --- */      

    /* A esperar la respuesta del Server */          
    hSocket:SET-READ-RESPONSE-PROCEDURE('pProcessServerResponse', THIS-PROCEDURE) NO-ERROR.    

    z-filer = flog-epos-txt("CONECTO EPOS (Configurar) :   Paso 5 - SET-READ-RESPONSE-PROCEDURE -  SOCKET DIV(" + cDivision + ")  Caja(" + mID_caja + ")").

    IF hSocket:CONNECTED() THEN DO: 

        z-filer = flog-epos-txt("CONECTO EPOS (Configurar) :   Paso 6 - Esperando respuesta de SOCKET DIV(" + cDivision + ")  Caja(" + mID_caja + ")").

      /* Esperando respuesta */
      mDataServer = "".     
      WAIT-FOR READ-RESPONSE OF hSocket PAUSE 8.

      IF TRUE <> (mDataServer > "") THEN DO:
          pRetVal = "008|No se pudo enviar la configuracion al e-POS".
          z-filer = flog-epos-txt("CONECTO EPOS (Configurar) :   Paso 6.1 - ERROR tardo en responder el ePOS -  SOCKET DIV(" + cDivision + ")  Caja(" + mID_caja + ") DATA(" + mDataServer + ")").
      END.
      ELSE DO:
          z-filer = flog-epos-txt("CONECTO EPOS (Configurar) :   Paso 7 - Respondio -  SOCKET DIV(" + cDivision + ")  Caja(" + mID_caja + ") DATA(" + mDataServer + ")").

          /* Cadena devuelta por el e-POS */
          mDataServer = REPLACE(mDataServer,mControlIniRpta,"").    /* STX */
          mDataServer = REPLACE(mDataServer,mControlFinRpta,"").    /* ETX */
          pRetVal = REPLACE(mDataServer,mSeparador,"|").
          lCodRet = ENTRY(1,pRetVal,"|").
          IF (lCodRet = '0' OR lCodRet = '00') AND NUM-ENTRIES(pRetVal,"|") > 1 THEN DO:
                pRetVal = "000" + "|" + ENTRY(2,pRetVal,"|").
          END.
      END.
    END.        
    ELSE DO:

        z-filer = flog-epos-txt("CONECTO EPOS (Configurar) :   Paso 8 - Se desconecto intespestivamente el SOCKET DIV(" + cDivision + ")  Caja(" + mID_caja + ")").

        pRetVal = "602|Se desconecto del servidor, cuando se estaba configurandoo".
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pconfirmar-documento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pconfirmar-documento Procedure 
PROCEDURE pconfirmar-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTipoDocto AS CHAR.
DEFINE INPUT PARAMETER pNroDocto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE VAR lRetval AS CHAR.
DEFINE VAR lID_POS AS CHAR.
DEFINE VAR lPrefijoSerie AS CHAR.
DEFINE VAR lTipoDocSunat AS CHAR.
DEFINE VAR lRC AS LOG.
DEFINE VAR lCodRet AS CHAR.

DEFINE VAR lReintentosConfirmar AS INT .
DEFINE VAR lIntento AS INT .

/* Validaciones */
IF LOOKUP(pTipoDocto, cDoctosValidos,",") = 0 THEN DO:
    pRetVal = "001|Documento debe ser  " + cDoctosValidos.
    RETURN .
END.
    
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.

pRetVal = '002|Documento no existe en PROGRESS'.
FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                            b-ccbcdocu.coddiv = pCodDiv AND
                            b-ccbcdocu.coddoc = pTipoDocto AND 
                            b-ccbcdocu.nrodoc = pNroDocto NO-LOCK NO-ERROR.

IF AVAILABLE b-ccbcdocu THEN DO:   

    /* 13Jul2016 - Debe trabajar con el mismo ePOS que genero la trama */
    lID_POS = mID_caja. 

    lReintentosConfirmar = 5.

    /*REPEAT lIntento = 1 TO lReintentosConfirmar:*/

        pRetVal = '003|Imposible ubicar el ID(' + lID_POS + ') del ePOS de la tienda(' + pCodDiv + ")".
    
        lPrefijoSerie = fGet-Prefijo-Serie(pTipoDocto, pNroDocto, pCodDiv).
        lTipoDocSunat = fGet-tipo-documento(pTipoDocto).
    
        IF lID_POS <> "" THEN DO:
            IF hSocket:CONNECTED() = NO THEN DO:
                /* Que sucede si Perdio Conexion al ePOS, reconectamos? */
            END.

            /* Data a enviar */
            mDataClient = mControlIniMsg + "3" + mSeparador + mModoPrueba + mSeparador + cRucEmpresa
                            + mSeparador + lID_POS + mSeparador + lTipoDocSunat + mSeparador + 
                            lPrefijoSerie + SUBSTRING(pNroDocto,1,3) + "-" + SUBSTRING(pNroDocto,4) + mControlFinMsg.
    
            /* Set size of memory pointer to write server socket */
            SET-SIZE(mData) = 0.
            SET-SIZE(mData) = LENGTH(mDataClient) + 1.
            SET-BYTE-ORDER(mData) = BIG-ENDIAN.
            PUT-STRING(mData,1,LENGTH(mDataClient) + 1) = mDataClient.
    
            /* Write the whole thing to the server socket */
            lRC = hSocket:WRITE(mData,1,GET-SIZE(mData)) NO-ERROR.
    
            pRetVal = "000|Confirmacion enviado correctamente".
            IF lRC = FALSE OR ERROR-STATUS:GET-MESSAGE(1) <> '' THEN DO:
                pRetVal = "004|No se pudo enviar la CONFIRMACION al e-POS".
                SET-SIZE(mData) = 0.
            END.
    
            IF SUBSTRING(pRetVal,1,3)="000"  THEN DO:
              /* A esperar la respuesta del Server */          
              hSocket:SET-READ-RESPONSE-PROCEDURE('pProcessServerResponse', THIS-PROCEDURE).    
              IF hSocket:CONNECTED() THEN DO: 
                /* Esperando respuesta */
                mDataServer = "".     
                WAIT-FOR READ-RESPONSE OF hSocket. 
    
                /* Cadena devuelta por el e-POS */
                mDataServer = REPLACE(mDataServer,mControlIniRpta,"").    /* STX */
                mDataServer = REPLACE(mDataServer,mControlFinRpta,"").    /* ETX */
    
                pRetVal = REPLACE(mDataServer,mSeparador,"|").
    
                lCodRet = ENTRY(1,pRetVal,"|").
                IF (lCodRet = '0' OR lCodRet = '00' OR lCodRet = '000') AND NUM-ENTRIES(pRetVal,"|") > 1 THEN DO:
                      pRetVal = "000" + "|" + ENTRY(2,pRetVal,"|").
                      /* Ya NO mas reintentos */
                      lReintentosConfirmar = 50.
                END.
    
              END.        
              ELSE DO:
                  pRetVal = "999|Se desconecto del servidor, cuando esperaba respuesta de este".
              END.
            END.
        END.
    /*END.*/
END.

/*RELEASE b-ccbcdocu.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pconfirmo-documento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pconfirmo-documento Procedure 
PROCEDURE pconfirmo-documento :
DEFINE INPUT PARAMETER pIP_ePOS AS CHAR.
DEFINE INPUT PARAMETER pID_caja AS CHAR.
DEFINE INPUT PARAMETER pTipoDocto AS CHAR.
DEFINE INPUT PARAMETER pNroDocto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE VAR lRetval AS CHAR.
DEFINE VAR lID_POS AS CHAR.
DEFINE VAR lPrefijoSerie AS CHAR.
DEFINE VAR lTipoDocSunat AS CHAR.
DEFINE VAR lRC AS LOG.
DEFINE VAR lCodRet AS CHAR.

DEFINE VAR lReintentosConfirmar AS INT .
DEFINE VAR lIntento AS INT .

DEFINE VAR x-logtxt AS CHAR.
DEFINE VAR x-logmsg AS CHAR.

/* Validaciones */
IF LOOKUP(pTipoDocto, cDoctosValidos,",") = 0 THEN DO:
    pRetVal = "001|Documento debe ser  " + cDoctosValidos.
    RETURN .
END.
    
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.

pRetVal = '002|Documento no existe en PROGRESS'.
FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                            b-ccbcdocu.coddiv = pCodDiv AND
                            b-ccbcdocu.coddoc = pTipoDocto AND 
                            b-ccbcdocu.nrodoc = pNroDocto NO-LOCK NO-ERROR.

IF AVAILABLE b-ccbcdocu THEN DO:   
    
    lID_POS = pID_caja.    /*mID_ePOS*/ /*fGet_id_pos(pCodDiv).*/    

    lReintentosConfirmar = 2.
    lPrefijoSerie = fGet-Prefijo-Serie(pTipoDocto, pNroDocto, pCodDiv).
    lTipoDocSunat = fGet-tipo-documento(pTipoDocto).

    x-logmsg = " IP:" + pIP_EPOS + ", ID:" + pID_CAJA + ", DIVI:" + pCodDiv + ", TDOC:" + pTipoDocto + ", NroDoc:" + pNroDocto.

    REPEAT lIntento = 1 TO lReintentosConfirmar:

        pRetVal = '003|El ID(' + lID_POS + ') del ePOS de la tienda(' + pCodDiv + ") esta vacia".
        
        IF lID_POS <> "" THEN DO:

            /* LOG */
            x-logtxt = flog-epos-txt("CONFIRMO DOCTO(" + STRING(lIntento,">>9") + ") (conexion) : " + x-logmsg).

            pRetVal = '999|Imposible conectarse al ePOS(' + pIP_ePOS + ') ID caja (' + pID_caja + ') de la tienda(' + pCodDiv + ")".
            /* Conectarse */
            RUN pconexion-epos(INPUT pIP_ePOS, INPUT "5500", OUTPUT pRetVal).

            IF SUBSTRING(pRetVal,1,3) = "000" THEN DO:

                /* Data a enviar */
                mDataClient = mControlIniMsg + "3" + mSeparador + mModoPrueba + mSeparador + cRucEmpresa
                                + mSeparador + lID_POS + mSeparador + lTipoDocSunat + mSeparador + 
                                lPrefijoSerie + SUBSTRING(pNroDocto,1,3) + "-" + SUBSTRING(pNroDocto,4) + mControlFinMsg.

                /* LOG */
                x-logtxt = flog-epos-txt("CONFIRMO DOCTO(" + STRING(lIntento,">>9") + ") (envia confirmacion) : " + x-logmsg + "  DATA(" + STRING(mDataClient) + ")" ).

                /* Set size of memory pointer to write server socket */
                SET-SIZE(mData) = 0.
                SET-SIZE(mData) = LENGTH(mDataClient) + 1.
                SET-BYTE-ORDER(mData) = BIG-ENDIAN.
                PUT-STRING(mData,1,LENGTH(mDataClient) + 1) = mDataClient.

                /* Write the whole thing to the server socket */
                lRC = hSocket:WRITE(mData,1,GET-SIZE(mData)) NO-ERROR.

                pRetVal = "000|Confirmacion enviado correctamente".
                IF lRC = FALSE OR ERROR-STATUS:ERROR = YES THEN DO:

                    /* LOG */
                    x-logtxt = flog-epos-txt("CONFIRMO DOCTO(" + STRING(lIntento,">>9") + ") (No se pudo enviar la confirmacion) : " + x-logmsg ).

                    pRetVal = "004|No se pudo enviar la CONFIRMACION al e-POS(" + pIP_ePOS + "), ID Caja(" + pID_caja + ")".
                    SET-SIZE(mData) = 0.
                END.

                IF SUBSTRING(pRetVal,1,3)="000"  THEN DO:

                    /* LOG */
                    x-logtxt = flog-epos-txt("CONFIRMO DOCTO(" + STRING(lIntento,">>9") + ") (esperando respuesta del servidor) : " + x-logmsg ).

                  /* A esperar la respuesta del Server */          
                  hSocket:SET-READ-RESPONSE-PROCEDURE('pProcessServerResponse', THIS-PROCEDURE).    
                  IF hSocket:CONNECTED() THEN DO: 
                    /* Esperando respuesta */
                    mDataServer = "".     
                    WAIT-FOR READ-RESPONSE OF hSocket. 

                    /* LOG */
                    x-logtxt = flog-epos-txt("CONFIRMO DOCTO(" + STRING(lIntento,">>9") + ") (respondio el servidor) : " + x-logmsg + "  DATA(" + STRING(mDataServer) + ")" ).

                    /* Cadena devuelta por el e-POS */
                    mDataServer1 = mDataServer.
                    mDataServer = REPLACE(mDataServer,mControlIniRpta,"").    /* STX */
                    mDataServer = REPLACE(mDataServer,mControlFinRpta,"").    /* ETX */

                    pRetVal = REPLACE(mDataServer,mSeparador,"|").

                    lCodRet = ENTRY(1,pRetVal,"|").
                    IF (lCodRet = '0' OR lCodRet = '00' OR lCodRet = '000') /*AND NUM-ENTRIES(pRetVal,"|") > 1*/ THEN DO:                        

                          pRetVal = "000" + "|" + ENTRY(2,pRetVal,"|").
                          /* LOG */
                          x-logtxt = flog-epos-txt("CONFIRMO DOCTO(" + STRING(lIntento,">>9") + ") (confirmo OK) : " + x-logmsg + " DATA(" + pRetVal + ")").


                          /* Ya NO mas reintentos */
                          lIntento = lReintentosConfirmar + 50.
                    END.
                    ELSE DO:
                            x-logtxt = flog-epos-txt("CONFIRMO DOCTO(" + STRING(lIntento,">>9") + ") (Error al confirmar) : " + x-logmsg + " DATA(" + mDataServer1 + ")").
                    END.
                  END.        
                  ELSE DO:
                        /* LOG */
                        x-logtxt = flog-epos-txt("CONFIRMO DOCTO(" + STRING(lIntento,">>9") + ") (Se desconecto el servidor) : " + x-logmsg ).

                      pRetVal = "999|Se desconecto del servidor(" + pIP_ePOS + ") ID Caja(" + pID_caja + "), cuando esperaba respuesta de este".
                  END.
                END.
            END.
        END.
        ELSE DO:
            lIntento = lReintentosConfirmar + 50.
        END.
    END.
END.

/*RELEASE b-ccbcdocu.*/

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

&IF DEFINED(EXCLUDE-pdesconectar-ws) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pdesconectar-ws Procedure 
PROCEDURE pdesconectar-ws :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF hWebService:CONNECTED() THEN hWebService:DISCONNECT().

DELETE OBJECT hWebService NO-ERROR.
DELETE OBJECT hPortType NO-ERROR.

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

DEFINE INPUT PARAMETER pIP_EPOS AS CHAR.
DEFINE INPUT PARAMETER pID_caja AS CHAR. 
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

&IF DEFINED(EXCLUDE-pestado-documento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pestado-documento Procedure 
PROCEDURE pestado-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pDestino AS CHAR.
DEFINE INPUT PARAMETER pTipoDocto AS CHAR.
DEFINE INPUT PARAMETER pNroDocto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

/*
    pDestino : EGATEWAY, ESERVER, SUNAT
*/

/* Validaciones */
IF LOOKUP(pTipoDocto, cDoctosValidos,",") = 0 THEN DO:
    pRetVal = "001|Documento debe ser  " + cDoctosValidos.
    RETURN.
END.

pRetVal = '002|Documento no existe en Progress'.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE VAR cTipoDocmnto AS CHAR.
DEFINE VAR lPreFijoDocmnto AS CHAR.
DEFINE VAR lNroDocmnto AS CHAR.


pRetVal = '002|Documento no existe en Progress'.
FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                            b-ccbcdocu.coddiv = pCodDiv AND
                            b-ccbcdocu.coddoc = pTipoDocto AND 
                            b-ccbcdocu.nrodoc = pNroDocto NO-LOCK NO-ERROR.

IF AVAILABLE b-ccbcdocu THEN DO:
    pRetVal = "".
    /* Conexion al WS */
    RUN pconectar-ws(INPUT pDestino, OUTPUT pRetVal).
    IF SUBSTRING(pRetVal,1,3)='000' THEN DO:
        /* PortType */
        pRetVal = "661|Este WDSL(" + pDestino + ") no esta definido su PortType".
        IF CAPS(pDestino) = "EGATEWAY" THEN RUN pconectar-ws-port(INPUT "OnLinePortType", OUTPUT pRetVal).
        IF CAPS(pDestino) = "ESERVER" THEN RUN pconectar-ws-port(INPUT "OnLinePortType", OUTPUT pRetVal).
        /**/
        IF SUBSTRING(pRetVal,1,3)='000' THEN DO:
            lPreFijoDocmnto = fGet-prefijo-serie(pTipoDocto,pNroDocto,pCodDiv).
            cTipoDocmnto = fget-tipo-documento(pTipoDocto).     /* Tipo Documento SUNAT */

            lNroDocmnto = lPreFijoDocmnto + SUBSTRING(pNroDocto,1,3) + "-" + SUBSTRING(pNroDocto,4).

            pRetVal = "662|Este WDSL(" + pDestino + ") no esta definido su PortType".
            RUN pget-estado-doc-eserver(INPUT cTipoDocmnto, INPUT lNroDocmnto, OUTPUT pRetVal).
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pestado-documento-eserver) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pestado-documento-eserver Procedure 
PROCEDURE pestado-documento-eserver :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTipoDocto AS CHAR.
DEFINE INPUT PARAMETER pNroDocto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

/* Validaciones */
IF LOOKUP(pTipoDocto, cDoctosValidos,",") = 0 THEN DO:
    pRetVal = "001|Documento debe ser  " + cDoctosValidos.
    RETURN.
END.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE VAR rRowId AS ROWID.
/*DEFINE VAR lRetVal AS CHAR.*/

DEFINE VAR lTipoDocmnto AS INT.
DEFINE VAR cTipoDocmnto AS CHAR.
DEFINE VAR lPreFijoDocmnto AS CHAR.
DEFINE VAR lNroDocmnto AS CHAR.
DEFINE VAR lURL_wdsl AS CHAR.

/* WS de PaperLess */
lURL_wdsl = 'http://asp402r.paperless.com.pe/axis2/services/Online?wsdl'.

pRetVal = '002|Documento no existe en Progress'.
FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                            b-ccbcdocu.coddiv = pCodDiv AND
                            b-ccbcdocu.coddoc = pTipoDocto AND 
                            b-ccbcdocu.nrodoc = pNroDocto NO-LOCK NO-ERROR.

IF AVAILABLE b-ccbcdocu THEN DO:

    cTipoDocto = pTipoDocto.
    cNroDocto = pNroDocto.
    cDivision = pCodDiv.
    
    RELEASE b-ccbcdocu.

    lPreFijoDocmnto = fGet-prefijo-serie(pTipoDocto,pNroDocto,pCodDiv).
    cTipoDocmnto = fget-tipo-documento(pTipoDocto).     /* Tipo Documento SUNAT */

    lNroDocmnto = lPreFijoDocmnto + SUBSTRING(pNroDocto,1,3) + "-" + SUBSTRING(pNroDocto,4).

    /* Usamos WebService */
    /*DEFINE VARIABLE hWebService     AS HANDLE NO-UNDO.*/
    DEFINE VARIABLE hOnLinePortType  AS HANDLE NO-UNDO.
    DEFINE VARIABLE GetResult       AS LONGCHAR NO-UNDO.

    DEFINE VAR lPos1 AS INT.
    DEFINE VAR lPos2 AS INT.
    DEFINE VAR lFiler AS CHAR.

    /* Set up a proxy for the service interface. This uses the Port Type name */
    /* Fijamos un proxy para la interface del servicio, aca usamos el nombre del PortType */
    CREATE SERVER hWebService.
    /*hWebService:CONNECT("-WSDL 'http://192.168.100.245:8060/axis2/services/Online?wsdl'") NO-ERROR.*/
    hWebService:CONNECT("-WSDL '" + lURL_wdsl + "'") NO-ERROR.
        
    IF NOT hWebService:CONNECTED() THEN DO:
        pRetVal = "999|" + lURL_wdsl + ", no esta conectado".

        DELETE OBJECT hWebService NO-ERROR.
        DELETE OBJECT hOnLinePortType NO-ERROR.

        RETURN.
    END.

    /* use the Port type name here to create proxy and set a handle to it */
    /* Usamos el nombre del Port Type para crear un proy y asignarlo a una  variable handle */
    RUN OnLinePortType SET hOnLinePortType ON hWebService NO-ERROR.    

    IF NOT VALID-HANDLE(hOnLinePortType) THEN DO:
        pRetVal = "888|Puerto : OnLinePortType no es valido".

        IF hWebService:CONNECTED() THEN hWebService:DISCONNECT().

        DELETE OBJECT hWebService NO-ERROR.
        DELETE OBJECT hOnLinePortType NO-ERROR.

        RETURN.
    END.
    pRetVal = "".

    /* Use the operation name here, and invoke it in the proxy handle */
    /* Usamos el nombre de la funcion/procedimiento del WDSL, lo invocamos con el handle */
    RUN OnlineRecovery IN hOnLinePortType(INPUT cRucEmpresa, 
                                          INPUT 'admin_continental',
                                          INPUT 'abc123',
                                          INPUT cTipoDocmnto,
                                          INPUT lNroDocmnto,
                                          INPUT 3,      /* 3 : estado en la Sunat, 7 : Hash */
                                          OUTPUT GetResult) NO-ERROR.

    /*MESSAGE STRING(GetResult).*/

    IF ERROR-STATUS:ERROR THEN DO:
      pRetVal = '666'.
      DEFINE VARIABLE iCnt AS INTEGER NO-UNDO.
        
      DO iCnt = 1 TO ERROR-STATUS:NUM-MESSAGES:
          pRetVal = pRetVal + "|" + ERROR-STATUS:GET-MESSAGE(iCnt).
      END.
    END.
    ELSE DO:
        /* Viene en XML */
        /*GetResult = TRIM(GetResult).*/
        /* Codigo */
        lPos1 = INDEX(GetResult,"<Codigo>").
        lPos2 = INDEX(GetResult,"</Codigo>").

        lFiler = SUBSTRING(GetResult,lPos1,(lPos2 - lPos1)).
        lFiler = REPLACE(lFiler,"<Codigo>","").
        pRetVal = lFiler.

        /* Mensaje */
        lPos1 = INDEX(GetResult,"<Mensaje>").
        IF lPos1 > 0 THEN DO:
            /* Existen mensajes que solo viene Codigo */
            lPos2 = INDEX(GetResult,"</Mensaje>").

            lFiler = SUBSTRING(GetResult,lPos1,(lPos2 - lPos1)).
            lFiler = REPLACE(lFiler,"<Mensaje>","").

            pRetVal = pRetVal + "|" + lFiler.
        END.
        ELSE DO:
            pRetVal = pRetVal + "| ".
        END.
        
    END.
        
    IF hWebService:CONNECTED() THEN hWebService:DISCONNECT().

    DELETE OBJECT hWebService NO-ERROR.
    DELETE OBJECT hOnLinePortType NO-ERROR.
    
END.
ELSE RELEASE b-ccbcdocu.

END PROCEDURE.

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

&IF DEFINED(EXCLUDE-pget-estado-doc-eserver) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pget-estado-doc-eserver Procedure 
PROCEDURE pget-estado-doc-eserver :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTipoDocumento AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pNroDocumento AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE VAR lPos1 AS INT.
DEFINE VAR lPos2 AS INT.
DEFINE VAR lFiler AS CHAR.
DEFINE VAR GetResult AS CHAR.

/* Use the operation name here, and invoke it in the proxy handle */
/* Usamos el nombre de la funcion/procedimiento del WDSL, lo invocamos con el handle */
RUN OnlineRecovery IN hPortType(INPUT cRucEmpresa, 
                                      INPUT 'admin_continental',
                                      INPUT 'abc123',
                                      INPUT pTipoDocumento,
                                      INPUT pNroDocumento,
                                      INPUT 3,      /* 3 : estado en la Sunat, 7 : Hash */
                                      OUTPUT GetResult) NO-ERROR.

IF ERROR-STATUS:ERROR THEN DO:
  pRetVal = '666'.
  DEFINE VARIABLE iCnt AS INTEGER NO-UNDO.
    
  DO iCnt = 1 TO ERROR-STATUS:NUM-MESSAGES:
      pRetVal = pRetVal + "|" + ERROR-STATUS:GET-MESSAGE(iCnt).
  END.
END.
ELSE DO:
    /* Viene en XML */
    /*GetResult = TRIM(GetResult).*/
    /* Codigo */
    lPos1 = INDEX(GetResult,"<Codigo>").
    lPos2 = INDEX(GetResult,"</Codigo>").

    lFiler = SUBSTRING(GetResult,lPos1,(lPos2 - lPos1)).
    lFiler = REPLACE(lFiler,"<Codigo>","").
    pRetVal = lFiler.

    /* Mensaje */
    lPos1 = INDEX(GetResult,"<Mensaje>").
    IF lPos1 > 0 THEN DO:
        /* Existen mensajes que solo viene Codigo */
        lPos2 = INDEX(GetResult,"</Mensaje>").

        lFiler = SUBSTRING(GetResult,lPos1,(lPos2 - lPos1)).
        lFiler = REPLACE(lFiler,"<Mensaje>","").

        pRetVal = pRetVal + "|" + lFiler.
    END.
    ELSE DO:
        pRetVal = pRetVal + "| ".
    END.
    
END.

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

&IF DEFINED(EXCLUDE-pProcessServerResponse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pProcessServerResponse Procedure 
PROCEDURE pProcessServerResponse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE mMemptrRd  AS MEMPTR      NO-UNDO. 
    DEFINE VARIABLE lRc        AS LOGICAL     NO-UNDO. 
    DEFINE VARIABLE iB         AS INTEGER     NO-UNDO. 

    DEFINE VARIABLE cResp            AS CHARACTER   NO-UNDO. 

    mDataServer = "602|Se perdio conexion con el SOCKET".
    IF hSocket:CONNECTED() = YES THEN DO:
        /* set the size and order of the returned packet in the socket */ 
        SET-SIZE(mMemptrRd)       = 0. 
        ASSIGN iB                 = hSocket:GET-BYTES-AVAILABLE(). 
        SET-SIZE(mMemptrRd)       = iB. 
        SET-BYTE-ORDER(mMemptrRd) = BIG-ENDIAN. 

        /* check if there is data to read */ 
        IF iB = 0 THEN DO:    
            mDataServer = "600|No existe data en el servidor".
            RETURN. 
        END. 

        /* read the packet */ 
        ASSIGN lRC = SELF:READ(mMemptrRd,1,iB,1) NO-ERROR. 
        IF lRC = FALSE OR ERROR-STATUS:ERROR = YES THEN DO: 
            mDataServer = "601|Imposible leer el paquete de datos del servidor".      
          RETURN. 
        END. 

        /* assigning the message returned to a variable for outputing */ 
        mDataServer = "".
        ASSIGN cResp = GET-STRING(mMemptrRd,1). 
        mDataServer = TRIM(cResp).
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fDesconectar-epos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDesconectar-epos Procedure 
FUNCTION fDesconectar-epos RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF VALID-HANDLE(hSocket) THEN DO:
    IF hSocket:CONNECTED() THEN DO:
        hSocket:DISCONNECT() NO-ERROR.
    END. 
END.

SET-SIZE(mHeader) = 0.
SET-SIZE(mData)   = 0.
ERROR-STATUS:ERROR  = NO.


/* Libero el ePOS */
DEFINE VAR x-ip-ePos AS CHAR.

x-ip-epos = mIP_ePOS.
FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = 'EPOS' AND 
                            factabla.codigo = x-ip-epos NO-ERROR.
IF AVAILABLE factabla THEN DO:
    ASSIGN factabla.campo-L[1] = NO.
END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fEstado-PPL-documento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado-PPL-documento Procedure 
FUNCTION fEstado-PPL-documento RETURNS CHARACTER
    ( INPUT pTipoDocto AS CHAR, INPUT pNroDocto AS char, INPUT pCodDiv  AS CHAR) :
    /*------------------------------------------------------------------------------
      Purpose:  Generar el Documento TXT y dejalo en el directorio compartido pPathEntrada
        Notes:  
        Return :    XXX - DDDDDDDDDDDDDDDDDD

                    xxx - Codigo del error 
                    ddd.. - descripcion del error.
    ------------------------------------------------------------------------------*/

    DEFINE VAR lRetval AS CHAR.

    /* Validaciones */
    IF LOOKUP(pTipoDocto, cDoctosValidos,",") = 0 THEN RETURN "001|Documento debe ser  " + cDoctosValidos.

    file-info:file-name = cPathSalida.

    if file-info:file-type = ? THEN DO:   
        RETURN "003|No existe directorio de Salida (" + cPathSalida + ")".
    END.


    DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
    DEFINE VAR rRowId AS ROWID.

    FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                                b-ccbcdocu.coddiv = pCodDiv AND
                                b-ccbcdocu.coddoc = pTipoDocto AND 
                                b-ccbcdocu.nrodoc = pNroDocto NO-LOCK NO-ERROR.

    IF NOT AVAILABLE b-ccbcdocu THEN DO:
        RELEASE b-ccbcdocu.
        RETURN "002|Documento no existe".
    END.

    /* Guardo referencia */
    cTipoDocto = pTipoDocto.
    cNroDocto = pNroDocto.
    cDivision = pCodDiv.

    rRowId = ROWID(b-ccbcdocu).

    RELEASE b-ccbcdocu.

    lRetVal = '999|Opcion no implementada'.

    /*

    /* Cargar el documento */
    CASE pTipoDocto:
        WHEN 'FAC'  THEN DO:
            /* Facturas */
            RUN fac-generar-txt(INPUT rRowid, OUTPUT lRetval).
        END.
        WHEN 'BOL' OR WHEN 'TCK' THEN DO:
            /* Boletas */
            RUN bol-generar-txt(INPUT rRowid, OUTPUT lRetval).
        END.
        WHEN 'N/C' THEN DO:
            /* Notas de Credito */
            RUN nc-generar-txt(INPUT rRowid, OUTPUT lRetval).
        END.
        WHEN 'N/D' THEN DO:
            /* Notas de Debito */
        END.
    END CASE.

    */      

    RETURN lRetval.   /* Function return value. */

END FUNCTION.

    /* Codigo de Retorno :

    000-Archivo generado OK               
    001-Documento debe ser FAC, BOL, N/C, N/D, TCK
    002-Documento no existe
    003-No existe directorio de entrada
    
    */

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

    RELEASE fx-ccbcdocu.
    RELEASE fx-ccbdmvto.

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
IF AVAILABLE gn-clie THEN DO:
    IF gn-clie.transporte[4] <> ? AND gn-clie.transporte[4] <> "" THEN DO:
        lRetVal = "PE|CorreoCliente|" + fget-utf-8(TRIM(gn-clie.transporte[4])) + gcCRLF.
    END.
    ELSE DO:
        IF gn-clie.e-mail <> ? AND gn-clie.e-mail <> ""  THEN DO:
            lRetVal = "PE|CorreoCliente|" + fget-utf-8(TRIM(gn-clie.e-mail)) + gcCRLF.
        END.
    END.
END.

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

  DEFINE BUFFER zy-ccbcdocu FOR ccbcdocu.
  
  FIND FIRST zy-ccbcdocu WHERE zy-ccbcdocu.codcia = s-codcia AND 
                                zy-ccbcdocu.coddiv = pCodDiv AND 
                                zy-ccbcdocu.coddoc = pTipoDoc AND 
                                zy-ccbcdocu.nrodoc = pNroDoc AND
                                zy-ccbcdocu.flgest <> 'A'
                                NO-LOCK NO-ERROR.
  IF AVAILABLE zy-ccbcdocu THEN DO:

      cURLDocumento = fget-url(zy-ccbcdocu.coddoc).

      IF zy-ccbcdocu.NroOrd <> ? OR zy-ccbcdocu.NroOrd <> '' THEN DO:
            lOrdenCompra = TRIM(zy-ccbcdocu.NroOrd).
      END.

      /* Plantillas adicionales */
      FIND FIRST gn-div OF zy-ccbcdocu NO-LOCK NO-ERROR.
      IF AVAILABLE gn-div THEN DO:
          lRetVal = lRetVal + "PE|" +
              "LUGAREMISION|" +
              fget-utf-8(TRIM(REPLACE(gn-div.dirdiv,"|"," "))) + 
              gcCRLF.
      END.
      IF zy-ccbcdocu.nroped <> ? AND zy-ccbcdocu.nroped <> '' THEN DO:
          lRetVal = lRetVal + "PE|" +
              "PEDIDO|" +
              zy-ccbcdocu.nroped +
              gcCRLF.
      END.
      FIND FIRST gn-convt WHERE gn-convt.codig = zy-ccbcdocu.fmapgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-div THEN DO:
          lRetVal = lRetVal + "PE|" +
              "FORMAPAGO|" +
              fget-utf-8(TRIM(REPLACE(gn-convt.nombr,"|"," "))) + 
              gcCRLF.
      END.
      IF zy-ccbcdocu.tipo <> ? AND zy-ccbcdocu.tipo <> '' THEN DO:
          lRetVal = lRetVal + "PE|" +
              "TIPOVENTA|" +
              fget-utf-8(zy-ccbcdocu.tipo) +
              gcCRLF.
      END.
      IF zy-ccbcdocu.codven <> ? AND zy-ccbcdocu.codven <> '' THEN DO:
          lRetVal = lRetVal + "PE|" +
              "VENDEDOR|" +
              fget-utf-8(zy-ccbcdocu.codven) +
              gcCRLF.
      END.
      IF zy-ccbcdocu.horcie <> ? AND zy-ccbcdocu.horcie <> '' THEN DO:
          lRetVal = lRetVal + "PE|" +
              "HORA|" + 
              zy-ccbcdocu.horcie +
              gcCRLF.
      END.
      IF zy-ccbcdocu.usuario <> ? AND zy-ccbcdocu.usuario <> '' THEN DO:
          lRetVal = lRetVal + "PE|" +
              "CAJERA|" +
              fget-utf-8(zy-ccbcdocu.usuario) +
              gcCRLF.
      END.
      IF zy-ccbcdocu.porigv >= 0  THEN DO:
          lRetVal = lRetVal + "PE|" +
              "IGV|" +
              STRING(zy-ccbcdocu.porigv,lFmtoImpte) +
              gcCRLF.
      END.

      IF zy-ccbcdocu.coddoc = 'FAC' THEN lRetVal = lRetVal + "PE|Plantilla|T01.jasper" + gcCRLF.
      IF zy-ccbcdocu.coddoc = 'BOL' THEN lRetVal = lRetVal + "PE|Plantilla|T03.jasper" + gcCRLF.
      IF zy-ccbcdocu.coddoc = 'TCK' THEN lRetVal = lRetVal + "PE|Plantilla|T03.jasper" + gcCRLF.
      IF zy-ccbcdocu.coddoc = 'N/C' THEN lRetVal = lRetVal + "PE|Plantilla|T07.jasper" + gcCRLF.
      IF zy-ccbcdocu.coddoc = 'N/D' THEN lRetVal = lRetVal + "PE|Plantilla|T08.jasper" + gcCRLF.

      IF zy-ccbcdocu.coddoc = 'FAC' OR zy-ccbcdocu.coddoc = 'BOL' THEN DO:
          lRetVal = lRetVal + "PES|MensajesAt" + gcCRLF.
          lRetVal = lRetVal + "PESD|1|INCORP. AL REGIMEN DE AGENTE DE RETENCION DE IGV (RS: 265-2009) A PARTIR DEL 01/10/10"  + gcCRLF.
          IF lOrdenCompra <> "" THEN DO:
              lRetVal = lRetVal + "PESD|2|O.COMPRA : " + lOrdenCompra  + gcCRLF.
          END.
      END.
  END.
  ELSE DO:
        lRetVal = lRetVal + "PE|Plantilla|T01.jasper" + gcCRLF.
  END.

  lRetVal = lRetVal + "PE|" +
    "URL|" +
    fget-utf-8(cURLDocumento) +
    gcCRLF.


  RELEASE zy-ccbcdocu.

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

    RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fGet-Prefijo-Serie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fGet-Prefijo-Serie Procedure 
FUNCTION fGet-Prefijo-Serie RETURNS CHARACTER
  (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR) :

    DEFINE VAR lxRet AS CHAR.

    lxRet = ?.

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

        RELEASE z-ccbcdocu.
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

&IF DEFINED(EXCLUDE-fget-url) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-url Procedure 
FUNCTION fget-url RETURNS CHARACTER
  (INPUT pTipoDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lURL AS CHAR NO-UNDO.

lURL = "http://asp402r.paperless.com.pe/BoletaContinental/".
CASE pTipoDoc:
    WHEN "FAC" THEN lURL = lURL + "".
    WHEN "BOL" THEN lURL = lURL + "".
    WHEN "TCK" THEN lURL = lURL + "".
    WHEN "N/D" THEN lURL = lURL + "".
    WHEN "N/C" THEN lURL = lURL + "".
    OTHERWISE
        lURL = lURL + "??????".
END CASE.


RETURN lURL.   /* Function return value. */

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

RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget_id_pos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget_id_pos Procedure 
FUNCTION fget_id_pos RETURNS CHARACTER
  ( INPUT pDivision AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS CHAR.

lRetVal = "".

DEFINE BUFFER ix-FECFGEPOS FOR FECFGEPOS.

/* Buscamos la division en las configuraciones de e-POS */
FIND FIRST ix-FECFGEPOS WHERE ix-FECFGEPOS.codcia = s-codcia AND
                            ix-FECFGEPOS.coddiv = pDivision 
                            NO-LOCK NO-ERROR.
IF AVAILABLE ix-FECFGEPOS THEN DO:
    lRetVal = TRIM(FECFGEPOS.ID_POS).
END.
RELEASE ix-FECFGEPOS.

RETURN lRetVal.   /* Function return value. */

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

