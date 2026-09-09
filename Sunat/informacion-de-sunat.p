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

/* Local Variable Definitions ---                                       */
/* handle to internet session */
  define var hInternetSession   as  int  no-undo.
/* handle to the ftp session inside the internet connection */
  define var hFTPSession        as  int  no-undo.
/* current directory which we are processing */
  define var cCurrentDir        as  char no-undo.

DEFINE VAR x-ruc AS CHAR.

&SCOPE  MAX_PATH 260

&SCOPE FILE_ATTRIBUTE_NORMAL  128

/* Internet constants */

&SCOPE INTERNET_OPEN_TYPE_PRECONFIG    0
/* indicates to use config information from registry */
&SCOPE INTERNET_FLAG_EXISITING_CONNECT 536870912
/* used for ftp connections */
&SCOPE INTERNET_FLAG_PASSIVE           134217728

/* Flags for FTP transfer mode */
&SCOPE  FTP_TRANSFER_TYPE_ASCII  1   /* 0x00000001 */
&SCOPE  FTP_TRANSFER_TYPE_BINARY 2   /* 0x00000002 */


&SCOPE INTERNET_DEFAULT_FTP_PORT     21
&SCOPE INTERNET_DEFAULT_GOPHER_PORT  70
&SCOPE INTERNET_DEFAULT_HTTP_PORT    80
&SCOPE INTERNET_DEFAULT_HTTPS_PORT  443
&SCOPE INTERNET_DEFAULT_SOCKS_PORT 1080

/* Type of service to access */
&SCOPE INTERNET_SERVICE_FTP    1
&SCOPE INTERNET_SERVICE_GOPHER 2
&SCOPE INTERNET_SERVICE_HTTP   3

PROCEDURE InternetConnectA EXTERNAL "wininet.dll" PERSISTENT:
  define input parameter  hInternetSession  as  long.
  define input parameter  lpszServerName    as  char.
  define input parameter  nServerPort       as  long.
  define input parameter  lpszUserName      as  char.
  define input parameter  lpszPassword      as  char.
  define input parameter  dwService         as  long.
  define input parameter  dwFlags           as  long.
  define input parameter  dwContext         as  long.
  define return parameter hInternetConnect  as  long.
END.

PROCEDURE InternetGetLastResponseInfoA EXTERNAL "wininet.dll" PERSISTENT:
  define output parameter lpdwError          as  long.
  define output parameter lpszBuffer         as  char.
  define input-output  parameter lpdwBufferLength   as  long.
  define return parameter iResultCode       as  long.
END.

PROCEDURE InternetOpenUrlA EXTERNAL "wininet.dll" PERSISTENT:
  define input parameter  hInternetSession  as  long.
  define input parameter  lpszUrl           as  char.
  define input parameter  lpszHeaders       as  char.
  define input parameter  dwHeadersLength   as  long.
  define input parameter  dwFlags           as  long.
  define input parameter  dwContext         as  long.
  define return parameter iResultCode       as  long.
END.

PROCEDURE InternetOpenA EXTERNAL "wininet.dll" PERSISTENT:
  define input parameter  sAgent            as  char.
  define input parameter  lAccessType       as  long.
  define input parameter  sProxyName        as  char.
  define input parameter  sProxyBypass      as  char.
  define input parameter  lFlags            as  long.
  define return parameter iResultCode       as  long.
END.

PROCEDURE InternetReadFile EXTERNAL "wininet.dll" PERSISTENT:
  define input  parameter  hFile            as  long.
  define output parameter  sBuffer          as  char.
  define input  parameter  lNumBytesToRead  as  long.
  define output parameter  lNumOfBytesRead  as  long.
  define return parameter  iResultCode      as  long.
END.

PROCEDURE InternetCloseHandle EXTERNAL "wininet.dll" PERSISTENT:
  define input parameter  hInet             as  long.
  define return parameter iResultCode       as  long.
END.

PROCEDURE FtpFindFirstFileA EXTERNAL "wininet.dll" PERSISTENT :
    define input parameter  hFtpSession as  long.
    define input parameter  lpFileName as char.
    define input parameter  lpFindFileData as memptr.
    define input parameter  dwFlags        as long.
    define input parameter  dwContext      as long.
    define return parameter hSearch as long.
END PROCEDURE.    


PROCEDURE InternetFindNextFileA EXTERNAL "wininet.dll" PERSISTENT:
    define input parameter  hSearch as long.
    define input parameter  lpFindFileData as memptr.
    define return parameter found as long.
END PROCEDURE.


PROCEDURE FtpGetCurrentDirectoryA EXTERNAL "wininet.dll" PERSISTENT:
    define input parameter  hFtpSession as long.
    define input parameter  lpszCurrentDirectory as long.
    define input-output parameter lpdwCurrentDirectory as long.
    define return parameter iRetCode as long.
END PROCEDURE.

PROCEDURE FtpSetCurrentDirectoryA EXTERNAL "wininet.dll" PERSISTENT:
    define input parameter  hFtpSession as long.
    define input parameter  lpszDirectory as long.
    define return parameter iRetCode as long.
END PROCEDURE.

PROCEDURE FtpOpenFileA EXTERNAL "wininet.dll" PERSISTENT:
    define input parameter  hFtpSession  as long.
    define input parameter  lpszFileName as long.
    define input parameter  dwAccess     as long.
    define input parameter  dwFlags      as long.
    define input parameter  dwContext    as long.
    define return parameter iRetCode as long.
END PROCEDURE.

PROCEDURE FtpPutFileA EXTERNAL "wininet.dll" PERSISTENT:
    define input parameter  hFtpSession       as long.
    define input parameter  lpszLocalFile     as long.
    define input parameter  lpszNewRemoteFile as long.
    define input parameter  dwFlags           as long.
    define input parameter  dwContext         as long.
    define return parameter iRetCode          as long.
END PROCEDURE.

PROCEDURE FtpGetFileA EXTERNAL "wininet.dll" PERSISTENT:
    define input parameter  hFtpSession          as long.
    define input parameter  lpszRemoteFile       as long.
    define input parameter  lpszNewFile          as long.
    define input parameter  fFailIfExists        as long.
    define input parameter  dwFlagsAndAttributes as long.
    define input parameter  dwFlags              as long.
    define input parameter  dwContext            as long.
    define return parameter iRetCode             as long.
END PROCEDURE.

PROCEDURE FtpDeleteFileA EXTERNAL "wininet.dll" PERSISTENT:
    define input parameter  hFtpSession          as long.
    define input parameter  lpszRemoteFile       as long.
    define return parameter iRetCode             as long.
END PROCEDURE.

PROCEDURE GetLastError external "kernel32.dll" :
  define return parameter dwMessageID as long. 
END PROCEDURE.

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

&IF DEFINED(EXCLUDE-consulta-ruc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consulta-ruc Procedure 
PROCEDURE consulta-ruc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pRUC AS CHAR.
DEFINE OUTPUT PARAMETER pBajaSunat AS LOG.
DEFINE OUTPUT PARAMETER pName AS CHAR.
DEFINE OUTPUT PARAMETER pAddress AS CHAR.
DEFINE OUTPUT PARAMETER pUbigeo AS CHAR.
DEFINE OUTPUT PARAMETER pInscripcion AS DATE.
DEFINE OUTPUT PARAMETER pError AS CHAR NO-UNDO.

DEFINE VAR x-url-captcha AS CHAR.
DEFINE VAR x-url-ruc AS CHAR.
DEFINE VAR x-msgs AS LOG INIT YES.
DEFINE VAR x-retval AS CHAR.
DEFINE VAR x-captcha AS CHAR.
DEFINE VAR x-no-existe AS CHAR.

DEFINE VAR x-html AS LONGCHAR.

x-ruc = pRUC.

x-url-captcha = "http://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/captcha?accion=random".

RUN Get-URL(INPUT x-url-captcha, INPUT x-msgs, OUTPUT x-retval).

IF NOT ( x-retval BEGINS "ERROR")  THEN DO:    
    x-captcha = TRIM(x-retval).
    
    x-url-ruc = "http://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias?accion=consPorRuc&nroRuc=" + pRUC + "&numRnd=" + x-captcha + "&tipdoc=".
  
    x-retval = "".
    x-msgs = NO.
    RUN Get-URL(INPUT x-url-ruc, INPUT x-msgs, OUTPUT x-retval).

    x-html = TRIM(STRING(x-retval)).
    
    IF NOT ( x-retval BEGINS "ERROR")  THEN DO:

        x-no-existe = "El número de RUC " + pRuc + " consultado no es válido. Debe verificar el número y volver a ingresar.".
        x-html = TRIM(STRING(x-retval)).

        IF INDEX(x-html,x-no-existe) > 0 THEN DO:
            pError = x-no-existe.
        END.
        ELSE DO:
            x-no-existe = "Surgieron problemas al procesar la consulta por número de ruc".
            IF INDEX(x-html,x-no-existe) > 0 THEN DO:
                pError = x-no-existe.
            END.
            ELSE DO:

                IF CAPS(USERID("DICTDB")) = "MASTER" THEN DO:
                    COPY-LOB x-html TO FILE "d:\tmp\" + pRuc + ".txt". 
                END.

                RUN datos-del-ruc(INPUT x-html,
                                  OUTPUT pBajaSunat,
                                  OUTPUT pName,
                                  OUTPUT pAddress,
                                  OUTPUT pUbigeo,
                                  OUTPUT pInscripcion
                                  ).
            END.            
        END.
    END.
    ELSE DO:
        pError = "Imposible conectarse a la WEB de SUNAT".
    END.

END.
ELSE DO:
    pError = "No se pudo ubicar el codigo CAPTCHA".
END.

END PROCEDURE.

/*
/* Status */
RUN ReturnValue ( "status", OUTPUT x-Status).
pBajaSunat = (IF x-Status = 'ACTIVO' THEN NO ELSE YES).
/* Nombre */
RUN ReturnValue ( "name", OUTPUT pName).
/* Direccion */
RUN ReturnValue ( "address", OUTPUT pAddress).
/* Ubigeo */
RUN ReturnValue ( "ubigeo", OUTPUT pUbigeo).
/* Armado de la dirección */
FIND TabDepto WHERE TabDepto.CodDepto = SUBSTRING(pUbigeo,1,2) NO-LOCK NO-ERROR.
FIND TabProvi WHERE TabProvi.CodDepto = SUBSTRING(pUbigeo,1,2) AND
    TabProvi.CodProvi = SUBSTRING(pUbigeo,3,2) NO-LOCK NO-ERROR.
FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2) AND
    TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2) AND
    TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2) NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto AND AVAILABLE TabProvi AND AVAILABLE TabDistr THEN DO:
    pAddress = TRIM(pAddress) + ' ' + 
                CAPS(TRIM(TabDepto.NomDepto)) + ' - ' +
                CAPS(TRIM(TabProvi.NomProvi)) + ' - ' +
                CAPS(TabDistr.NomDistr).
END.

pError = "".
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-datos-del-ruc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE datos-del-ruc Procedure 
PROCEDURE datos-del-ruc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTexto AS LONGCHAR.
DEFINE OUTPUT PARAMETER pBajaSunat AS LOG.
DEFINE OUTPUT PARAMETER pName AS CHAR.
DEFINE OUTPUT PARAMETER pAddress AS CHAR.
DEFINE OUTPUT PARAMETER pUbigeo AS CHAR.
DEFINE OUTPUT PARAMETER pInscripcion AS DATE.

DEFINE VAR x-msg AS CHAR.

DEFINE VAR x-distrito AS CHAR.
DEFINE VAR x-provincia AS CHAR.
DEFINE VAR x-departamento AS CHAR.
 
DEFINE VAR x-retval AS CHAR.
DEFINE VAR x-retval1 AS CHAR.
DEFINE VAR x-pos AS INT.

RUN get-dato-tag(INPUT pTexto,INPUT "Fecha de Inscripci&oacute;n: ",OUTPUT x-retval).

pInscripcion = DATE(INTEGER(ENTRY(2,x-retval,"/")),INTEGER(ENTRY(1,x-retval,"/")),INTEGER(ENTRY(3,x-retval,"/"))) NO-ERROR.

IF x-RUC BEGINS "20" THEN DO:
    RUN get-dato-tag(INPUT pTexto,INPUT "Nombre Comercial:",OUTPUT x-retval).  
    pName = TRIM(x-retval).    

    IF TRUE <> (pName > "") OR pName = "-" THEN DO:
        RUN get-dato-tag(INPUT pTexto,INPUT "RUC: </td>",OUTPUT x-retval).    
        pName = TRIM(SUBSTRING(x-retval,INDEX(x-retval,"-") + 1)).
    END.
END.
ELSE DO:
    /*RUN get-dato-tag(INPUT pTexto,INPUT "N&uacute;mero de RUC:",OUTPUT x-retval).*/
    RUN get-dato-tag(INPUT pTexto,INPUT "Tipo de Documento:",OUTPUT x-retval).    
    pName = TRIM(SUBSTRING(x-retval,INDEX(x-retval,"-") + 1)).
END.

RUN get-dato-tag(INPUT pTexto,INPUT "Estado:",OUTPUT x-retval).
pBajaSunat = (IF x-retval = 'ACTIVO' THEN NO ELSE YES).

RUN get-dato-tag(INPUT pTexto,INPUT "Domicilio Fiscal:",OUTPUT x-retval).

x-pos = R-INDEX(x-retval,"-").

x-distrito = TRIM(SUBSTRING(x-retval,x-pos + 1)).
x-retval1 = TRIM(SUBSTRING(x-retval,1,x-pos - 1)).

x-pos = R-INDEX(x-retval1,"-").
x-provincia = TRIM(SUBSTRING(x-retval1,x-pos + 1)).

x-retval1 = SUBSTRING(x-retval1,1,x-pos - 1).

pAddress = TRIM(x-retval1) + " - " + x-provincia + " - " + x-distrito.

/*pUbigeo = x-provincia + "-" + x-distrito.*/

/* */
FIND FIRST tabprovi WHERE tabprovi.nomprovi = x-provincia AND
                            tabprovi.coddepto <> "" AND 
                            tabprovi.codprovi <> "" NO-LOCK NO-ERROR.
                        
IF AVAILABLE tabprovi THEN DO:
    IF NOT AMBIGU tabprovi THEN DO:
        FIND FIRST tabdistr WHERE tabdistr.nomdistr = x-distrito AND
                                    tabdistr.coddepto <> "" AND 
                                    tabdistr.codprovi = tabprovi.codprovi AND
                                    tabdistr.coddistr <> ""
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE tabdistr THEN DO:
            pUbigeo = trim(tabdistr.coddepto) + trim(tabdistr.codprov) + trim(tabdistr.coddistr).
        END.        
    END.
    ELSE DO:
        /* Varios provincias con el mismo nombre  */
    END.
END.                       
              
END PROCEDURE.

/*
N&uacute;mero de RUC:
Tipo Contribuyente:
Nombre Comercial:
Fecha de Inscripci&oacute;n:
Fecha Inicio de Actividades:
Estado del Contribuyente:
Condici&oacute;n del Contribuyente:
Fecha de Inscripci&oacute;n: 
Direcci&oacute;n del Domicilio Fiscal:
*/

/*
DEFINE OUTPUT PARAMETER pBajaSunat AS LOG.
DEFINE OUTPUT PARAMETER pName AS CHAR.
DEFINE OUTPUT PARAMETER pAddress AS CHAR.
DEFINE OUTPUT PARAMETER pUbigeo AS CHAR.
DEFINE OUTPUT PARAMETER pError AS CHAR NO-UNDO.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-captcha) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-captcha Procedure 
PROCEDURE get-captcha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pCaptcha AS CHAR INIT "".

DEFINE VAR loXmlHttp AS COM-HANDLE NO-UNDO.
DEFINE VAR loXMLBody AS com-HANDLE NO-UNDO.

DEFINE VAR lEnvioXML AS LONGCHAR.
DEFINE VAR lloadXML AS LOG.
DEFINE VAR lUrl AS CHAR.
DEFINE VAR lRuc AS CHAR.

DEFINE VAR lPassSOL AS CHAR.
DEFINE VAR lTipoDocSunat AS CHAR.
DEFINE VAR lSerie AS CHAR.
DEFINE VAR lNroDoc AS CHAR.
DEFINE VAR lUserName AS CHAR.


CREATE "MSXML2.ServerXMLHTTP.6.0" loXmlHttp.
CREATE "MSXML2.DOMDocument.6.0" loXMLBody.

lURL    = 'http://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/captcha?accion=random'.

lEnvioXML = "".

lEnvioXML = "<soapenv:Envelope xmlns:ser='http://service.sunat.gob.pe'  
    xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/'
    xmlns:wsse='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'>
    <soapenv:Header>
    <wsse:Security>
    <wsse:UsernameToken>
    <wsse:Username>" + lUserName + "</wsse:Username>
    <wsse:Password>" + lPassSOL + "</wsse:Password>
    </wsse:UsernameToken>
    </wsse:Security>
    </soapenv:Header>
    <soapenv:Body>
    <ser:getStatus>
    <rucComprobante>" + lRuc + "</rucComprobante>
    <tipoComprobante>" + lTipoDocSunat + "</tipoComprobante>
    <serieComprobante>" + lSerie + "</serieComprobante>
    <numeroComprobante>" + lNroDoc + "</numeroComprobante>
    </ser:getStatus>
    </soapenv:Body>
    </soapenv:Envelope> ".


lloadXML = loXMLBody:loadXML( lEnvioXML ).

IF NOT lloadXML THEN DO:
    /*MESSAGE loXMLBody:parseError:reason.*/
    RELEASE OBJECT loXmlHttp NO-ERROR.
    RELEASE OBJECT loXMLBody NO-ERROR.
    RETURN.
END.

DEFINE VAR x-filer AS CHAR.

x-filer = loXmlHttp:OPEN( "POST", lURL, NO ) .

loXmlHttp:setRequestHeader( "Content-Type", "text/xml" ) .
loXmlHttp:setRequestHeader( "Content-Type", "text/xml;charset=ISO-8859-1" ) . 
loXmlHttp:setOption( 2, 13056 ) .  /*SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056*/
         
loXmlHttp:SEND(loXMLBody:documentElement:XML) .

IF loXmlHttp:status <> 200 THEN DO:
    /*MESSAGE loXmlHttp:responseText.*/
        RETURN .
END.

pCaptcha = TRIM(loXmlHttp:responseText).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-dato-tag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-dato-tag Procedure 
PROCEDURE get-dato-tag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTexto AS LONGCHAR.
DEFINE INPUT PARAMETER pDato_a_buscar AS CHAR.
DEFINE OUTPUT PARAMETER pValor AS CHAR.

DEFINE VAR x-pos AS INT.
DEFINE VAR x-pos2 AS INT.
DEFINE VAR x-texto AS LONGCHAR NO-UNDO.

pValor = "".
x-texto = pTexto.
x-pos = INDEX(x-Texto,pDato_a_buscar).
IF x-pos > 0 THEN DO:
    x-texto = SUBSTRING(x-Texto, x-pos + LENGTH(pDato_a_buscar) ).
    /**/
    x-pos = INDEX(x-texto,"class=").
    x-texto = SUBSTRING(x-texto, x-pos + LENGTH("class=")).
    /**/
    x-pos = INDEX(x-Texto,">").
    x-texto = SUBSTRING(x-texto, x-pos + 1).
    x-pos2 = INDEX(x-Texto,"</td>").
    x-texto = SUBSTRING(x-texto,1,x-pos2 - 1).
    pValor = x-texto.

END.

END PROCEDURE.

/*
          <tr>                    
            <td width="18%" colspan=1  class="bgn">N&uacute;mero de RUC: </td>
            <td  class="bg" colspan=3>20604143463 - GYO PIZZEROS S.A.C.</td>
          </tr>

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-url) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-url Procedure 
PROCEDURE get-url :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pURL AS LONGCHAR.
DEFINE INPUT PARAMETER pVerbose AS LOGICAL.
DEFINE OUTPUT PARAMETER pRetVal AS LONGCHAR.

DEFINE VAR nInetHnd AS INT INIT 0.
DEFINE VAR nUrlHnd AS INT INIT 0.
DEFINE VAR nInetClose AS INT.
DEFINE VAR x-null AS CHAR.

/* El contenido */
DEFINE VAR cURLData AS CHAR.
DEFINE VAR cBuffer AS CHAR.
DEFINE VAR xBuffer AS MEMPTR.
DEFINE VAR nBytesReceived AS INT.
DEFINE VAR nBufferSize AS INT.
DEFINE VAR nLenBuffer AS INT.
DEFINE VAR nRetCode AS INT INIT 0.


IF pVerbose = YES THEN DO:
    /* Msg Abriendo conexion a internet */
END.

RUN InternetOpenA(INPUT "GETURL", INPUT {&INTERNET_OPEN_TYPE_PRECONFIG}, INPUT "", INPUT "", INPUT 0, OUTPUT nInetHnd).
IF nInetHnd = 0 THEN DO:
    pRetVal = "ERROR : InternetOpenA".
    RETURN.
END.   

IF pVerbose = YES THEN DO:
    /* Msg Abriendo Conexion al URL */
END.

DEFINE VAR x-url-captcha AS CHAR.
DEFINE VAR x-url-ruc AS CHAR.
DEFINE VAR x-captcha AS CHAR.

x-url-captcha = "http://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/captcha?accion=random".

x-null = "".
RUN InternetOpenUrlA(INPUT nInetHnd, INPUT x-url-captcha, INPUT x-null, INPUT 0, INPUT 0, INPUT 0, OUTPUT nUrlHnd).
IF nUrlHnd = 0 THEN DO:
    RUN InternetCloseHandle( INPUT nInetHnd, OUTPUT nInetClose).
    pRetVal = "ERROR : InternetOpenUrlA".
    RETURN.
END.

cURLData = "".
cBuffer = "".
nBytesReceived = 0.
nBufferSize = 0.

REPEAT WHILE nRetCode = 0 :
    /* *-- Se inicializa el buffer de lectura (bloques de 2 Kb) */
    cBuffer = FILL(" ",2048).
    /* Leer el siguiente bloque */
    nLenBuffer = LENGTH(cBuffer).
    RUN InternetReadFile(INPUT nUrlHnd, OUTPUT cBuffer, INPUT nLenBuffer, OUTPUT nBufferSize, OUTPUT nRetCode).
    
    IF nBufferSize > 0 THEN DO:
        cURLData = cURLData + TRIM(SUBSTRING(cBuffer,1,nBufferSize)).
        nBytesReceived = nBytesReceived + nBufferSize.
        nRetCode = 0.
    END.
    ELSE nRetCode = -1.

END.

/*Se devuelve el contenido del URL*/
x-captcha = cURLData.

/* ---------------------------------------------------------------------- */
x-url-ruc = "http://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias?accion=consPorRuc&nroRuc=" + x-ruc + "&numRnd=" + x-captcha + "&tipdoc=".

/*MESSAGE x-url-ruc.*/

x-null = "".
RUN InternetOpenUrlA(INPUT nInetHnd, INPUT x-url-ruc, INPUT x-null, INPUT 0, INPUT 0, INPUT 0, OUTPUT nUrlHnd).
IF nUrlHnd = 0 THEN DO:
    RUN InternetCloseHandle( INPUT nInetHnd, OUTPUT nInetClose).
    pRetVal = "ERROR : InternetOpenUrlA".
    RETURN.
END.

cURLData = "".
cBuffer = "".
nBytesReceived = 0.
nBufferSize = 0.
nRetCode = 0.

REPEAT WHILE nRetCode = 0 :
    /* *-- Se inicializa el buffer de lectura (bloques de 2 Kb) */
    cBuffer = FILL(" ",2048).
    /* Leer el siguiente bloque */
    nLenBuffer = LENGTH(cBuffer).
    RUN InternetReadFile(INPUT nUrlHnd, OUTPUT cBuffer, INPUT nLenBuffer, OUTPUT nBufferSize, OUTPUT nRetCode).
    
    IF nBufferSize > 0 THEN DO:
        cURLData = cURLData + TRIM(SUBSTRING(cBuffer,1,nBufferSize)).
        nBytesReceived = nBytesReceived + nBufferSize.
        nRetCode = 0.        
    END.
    ELSE nRetCode = -1.

END.

/*Se devuelve el contenido del URL*/
pRetVal = cURLData.

/*Se cierra la conexión a Internet*/ 
RUN InternetCloseHandle( INPUT nInetHnd, OUTPUT nInetClose ).

/*MESSAGE "XX " + string(pRetVal).*/

END PROCEDURE.

/*
  define input  parameter  hFile            as  long.
  define output parameter  sBuffer          as  char.
  define input  parameter  lNumBytesToRead  as  long.
  define output parameter  lNumOfBytesRead  as  long.
  define return parameter  iResultCode      as  long.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

