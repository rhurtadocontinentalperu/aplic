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

/*
    Ic - 24Feb2017
        Manejo de WebService (WS) de SENTINEL
*/

/* del WebService */
DEFINE VARIABLE hWebService     AS HANDLE NO-UNDO.
DEFINE VARIABLE hWS_INFCONPERSoapPort AS HANDLE NO-UNDO.
DEFINE VARIABLE pNombreWS AS CHAR.

pNombreWS = 'http://www2.sentinelperu.com/wsevo2qa/aws_infconper.aspx?wsdl'.

/* Datos de acceso al WS */
DEFINE VAR pServicio AS INT NO-UNDO.
DEFINE VAR pUsuario AS CHAR NO-UNDO.
DEFINE VAR pPassword AS CHAR NO-UNDO.

DEFINE VAR pXMLData AS LONGCHAR NO-UNDO.

pServicio   = 962.      /* Tipo de Servicio */
pUsuario    = "09929258".
pPassword   = "jcalderon".


pXMLData = "".

DEFINE SHARED VAR s-texto AS LONGCHAR.

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

&IF DEFINED(EXCLUDE-get-info-crediticia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-info-crediticia Procedure 
PROCEDURE get-info-crediticia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAM pTipoDoc AS CHAR.
DEFINE INPUT PARAM pNroDoc AS CHAR.
DEFINE INPUT PARAM pUsuario2 AS CHAR.
DEFINE INPUT PARAM pPassword2 AS CHAR.
DEFINE OUTPUT PARAM pMSGData AS CHAR.
DEFINE OUTPUT PARAM pCodigoWS AS CHAR.

DEFINE VARIABLE lsdtinfconper AS LONGCHAR NO-UNDO. 
DEFINE VARIABLE lCodigows  AS CHARACTER NO-UNDO.
DEFINE VAR lFileXML AS CHAR.

IF VALID-HANDLE(hWebService) THEN DO:
    IF hWebService:CONNECTED() THEN hWebService:DISCONNECT() NO-ERROR.
END.

DELETE OBJECT hWebService NO-ERROR.
DELETE OBJECT hWS_INFCONPERSoapPort NO-ERROR.

IF NOT (pUsuario2 = "" AND pPassword2 = "") THEN DO:
    pUsuario = pUsuario2.
    pPassword = pPassword2.
END.

/* El contenido del XML */
s-texto = "".

SESSION:SET-WAIT-STATE('GENERAL').
/* Conectarse al WS */
pMSGData = "No se pudo conectar al WS".
pCodigoWS = "-99".
CREATE SERVER hWebService.
hWebService:CONNECT("-WSDL '" + pNombreWS + "'").
IF NOT hWebService:CONNECTED() THEN DO:
    SESSION:SET-WAIT-STATE('').
    RETURN.
END.

/* Conectar al Port */
pCodigoWS = "-98".
RUN WS_INFCONPERSoapPort SET hWS_INFCONPERSoapPort ON hWebService.
IF NOT VALID-HANDLE(hWS_INFCONPERSoapPort) THEN DO:    
    pMSGData = "No se pudo entrar al Port del WS".
    SESSION:SET-WAIT-STATE('').
    RETURN.
END.

/* Invocar al funcion del WS */
RUN EXECUTE IN hWS_INFCONPERSoapPort(INPUT pServicio, INPUT pUsuario, 
                                                   INPUT pPassword, INPUT pTipoDoc,
                                                   INPUT pNroDoc, OUTPUT lsdtinfconper, 
                                                   OUTPUT lCodigows) NO-ERROR.
pMSGData = "OK".
IF ERROR-STATUS:ERROR THEN DO:
    pMSGData = "ERROR al INVOCAR la FUNCION del WS".
    lCodigoWS = "-97".
    DEFINE VARIABLE iCnt AS INTEGER NO-UNDO.
    DO iCnt = 1 TO ERROR-STATUS:NUM-MESSAGES:
        pMSGData = pMSGData + ERROR-STATUS:GET-MESSAGE(iCnt).
    END.

END.
ELSE DO:
    lsdtinfconper = TRIM(lsdtinfconper).
    lsdtinfconper = REPLACE(lsdtinfconper,"ñ","n").
    lsdtinfconper = REPLACE(lsdtinfconper,"Ñ","N").
    lsdtinfconper = REPLACE(lsdtinfconper,"ü","u").
    lsdtinfconper = REPLACE(lsdtinfconper,"á","a").
    lsdtinfconper = REPLACE(lsdtinfconper,"é","e").
    lsdtinfconper = REPLACE(lsdtinfconper,"í","i").
    lsdtinfconper = REPLACE(lsdtinfconper,"ó","o").
    lsdtinfconper = REPLACE(lsdtinfconper,"ú","u").
    lsdtinfconper = REPLACE(lsdtinfconper,"Á","A").
    lsdtinfconper = REPLACE(lsdtinfconper,"É","E").
    lsdtinfconper = REPLACE(lsdtinfconper,"Í","I").
    lsdtinfconper = REPLACE(lsdtinfconper,"Ó","O").
    lsdtinfconper = REPLACE(lsdtinfconper,"Ú","U").    
    lsdtinfconper = REPLACE(lsdtinfconper,"Ü","U").

    lFileXML = session:temp-directory + pNroDoc + ".xml".
    /*COPY-LOB lsdtinfconper TO FILE lFileXML.*/

    pMSGData = lFileXML.

END.
pCodigoWS = lCodigoWS.
pXMLData = TRIM(lsdtinfconper). /* ???? */
s-texto = TRIM(lsdtinfconper).

/* clean up: delete any proxies, then disconnect & delete the service object */
DELETE OBJECT hWS_INFCONPERSoapPort.
hWebService:DISCONNECT().
DELETE OBJECT hWebService.

SESSION:SET-WAIT-STATE('').


END PROCEDURE.
/*
    pCodigoWS = -99 : No se pudo conectar al WS.
                -98 : No se pudo conectar al Port del WS
                -97 : ERROR al INVOCAR la FUNCION del WS
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

