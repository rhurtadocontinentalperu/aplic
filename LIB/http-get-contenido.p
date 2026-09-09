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


DEFINE INPUT PARAMETER pURL AS CHAR.
DEFINE OUTPUT PARAMETER pRESULT     AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRESPONSE   AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pContent    AS LONGCHAR NO-UNDO.

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

/*-----------------------------------------------------------------------*
  File........: http.p
  Version.....: 1.1
  Description : Makes a "Get" request from an HTTP server
--------------------------------------------------------------------------*/
&SCOPED-DEFINE HTTP-NEWLINE CHR(13) + CHR(10)
&SCOPED-DEFINE RESPONSE-TIMEOUT 45 

DEFINE VAR cHOST        AS CHAR NO-UNDO.
DEFINE VAR cPORT        AS CHAR NO-UNDO.
DEFINE VAR cURL         AS CHAR NO-UNDO.

DEFINE VARIABLE requestString       AS CHAR   NO-UNDO.
DEFINE VARIABLE vSocket             AS HANDLE NO-UNDO.   
DEFINE VARIABLE vBuffer             AS MEMPTR NO-UNDO.
DEFINE VARIABLE vloop               AS LOGICAL NO-UNDO.
DEFINE VARIABLE vPackets            AS INTEGER NO-UNDO.
DEFINE VARIABLE wStatus             AS LOGICAL NO-UNDO.


RUN UrlParser(INPUT pURL, OUTPUT cHOST, OUTPUT cPORT, OUTPUT cURL).

/*
Tenga en cuenta que cambiar cualquier cosa en requestString puede causar tiempos
 de espera. Pero es posible agregar un agente de usuario si necesita iniciar sesión 
 en su servidor web:
*/

DEFINE VAR path AS CHAR NO-UNDO.
DEFINE VAR host AS CHAR NO-UNDO.

ASSIGN 
    requestString = "GET " + Path + " HTTP/1.0" + {&HTTP-NEWLINE}
        + "Accept: */*" + {&HTTP-NEWLINE}
        + "User-Agent: " + "User Agent String" + {&HTTP-NEWLINE}
        + "Host: " + Host + {&HTTP-NEWLINE}
        + {&HTTP-NEWLINE}.

/* Asi es el original */
ASSIGN 
    requestString = "GET " + cURL + " HTTP/1.0" + {&HTTP-NEWLINE} +
        "Accept: */*" + {&HTTP-NEWLINE} + 
        "Host: " + chost + {&HTTP-NEWLINE} + 
        /*"Connection: Keep-Alive" + {&HTTP-NEWLINE} + */
        {&HTTP-NEWLINE}.


/*MESSAGE "requestString " requestString.*/

CREATE SOCKET vSocket.

vSocket:SET-READ-RESPONSE-PROCEDURE ("readHandler",THIS-PROCEDURE).

ASSIGN 
    wstatus = vSocket:CONNECT("-H " + chost + " -S " + cport) NO-ERROR.

/*Now make sure the socket is open*/
IF wstatus = NO THEN DO:
    pResult = "0:No Socket".
    DELETE OBJECT vSocket.
    RETURN.
END.

/* Got socket - Now make HTTP request */
SET-SIZE(vBuffer) = LENGTH(requestString) + 1.
PUT-STRING(vBuffer,1) = requestString.
vSocket:WRITE(vBuffer, 1, LENGTH(requestString)).
SET-SIZE(vBuffer) = 0.

/*Wait for a response*/
ASSIGN vloop = TRUE.  /*Turns off automatically when request is done*/
DEFINE VAR vstarttime AS INTEGER.
ASSIGN vstarttime = etime.

WAITLOOP: 
DO WHILE vloop:
    PROCESS EVENTS.
    PAUSE 0.    /* 1 */
    /* Build in timer in case sending is never set to NO 
       this will terminate the program after 60 seconds
       start-Etime will be reset by WriteData each time there
       is activity on the socket to allow for long transmissions */
    IF vstarttime + ({&RESPONSE-TIMEOUT} * 1000) < ETIME THEN DO:
        /*Se comento para propositos de los bacheros*/
        /*
        MESSAGE "timed out at " + string(etime - vstarttime) + " msec".
        */
        vSocket:DISCONNECT().
        ASSIGN pResult = "0:Failure".
        RETURN.
    END. /*No Response, or timed out*/
END.

/*At this point, pResponse should be populated with the result (up to 32K)*/

vSocket:DISCONNECT().

DELETE OBJECT vSocket.

/*MESSAGE "pResponse " string(pResponse).*/

/* Validamos la respuesta */
/*All Done!*/
ASSIGN 
    pContent = SUBSTRING(pResponse,INDEX(pResponse,{&HTTP-NEWLINE} + {&HTTP-NEWLINE}),-1) NO-ERROR.
ASSIGN
    pResponse = SUBSTRING(pResponse,1,INDEX(pResponse,{&HTTP-NEWLINE} + {&HTTP-NEWLINE})) NO-ERROR.

CASE TRUE:
    WHEN INDEX(pContent, "<error>Not Content</error>") > 0 THEN pResult = "0:Not Content".
    OTHERWISE pResult = "1:Success".
END CASE.
/*
MESSAGE 'fin:' skip
    'pResult == ' pResult SKIP(2)
    'pContent == ' STRING(pContent) SKIP(2)
    'pResponse ==' STRING(pResponse).
*/

RETURN.


/*
    Handle the response from the webserver
    Manejar la respuesta del servidor web
*/
PROCEDURE readHandler:
/* ****************** */
    
    DEFINE VARIABLE bytesAvail  AS INTEGER  NO-UNDO.
    DEFINE VARIABLE b           AS MEMPTR   NO-UNDO.
    DEFINE VARIABLE lastBytes   AS INTEGER  NO-UNDO.

    IF vSocket:connected() THEN ASSIGN bytesAvail = vSocket:GET-BYTES-AVAILABLE().

    IF bytesAvail = 0 THEN DO: /*Todo OK / All Done*/
      ASSIGN vloop = FALSE.
      RETURN.
    END.

    /*
        OK, there's something on the wire... Read it in
        OK, hay algo en el trama... leerlo
    */    
    SET-SIZE(b) = bytesAvail + 1.
    vSocket:READ(b, 1, bytesAvail, 1).
    ASSIGN pResponse = pResponse + GET-STRING(b,1).
    SET-SIZE(b) = 0.

    /*MESSAGE "pResponse XXX " string(pResponse).*/

END PROCEDURE. /*readHandler*/

PROCEDURE UrlParser:

    DEFINE INPUT PARAMETER purl AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER phost AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pport AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER ppath AS CHARACTER NO-UNDO.    
    DEFINE VARIABLE vStr AS CHARACTER NO-UNDO.    

    IF purl BEGINS "http://" OR purl BEGINS "https://" THEN DO:
        vStr = SUBSTRING(purl, 8).
        IF purl BEGINS "https://" THEN vStr = SUBSTRING(purl, 9).
        phost = ENTRY(1, vStr, "/").

        IF NUM-ENTRIES(vStr, "/") = 1 THEN vStr = vStr + "/".

        ppath = SUBSTRING(vStr, INDEX(vStr,"/")).
        IF NUM-ENTRIES(phost, ":") > 1 THEN DO:
            pport = ENTRY(2, phost, ":").
            phost = ENTRY(1, phost, ":").
        END.
        ELSE DO:
            pport = "80".
        END.
    END.
    ELSE DO:
        phost = "".
        pport = "".
        ppath = purl.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


