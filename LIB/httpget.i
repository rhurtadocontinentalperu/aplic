&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

/* httpget.i */
/* Estas variables deben estar definidas en el programa que lo contiene */
/* DEFINE STREAM outfile.                        */
/* DEFINE VARIABLE vSocket AS HANDLE    NO-UNDO. */
/* DEFINE VARIABLE wstatus AS LOGICAL   NO-UNDO. */
/* DEFINE VARIABLE vStr    AS CHARACTER NO-UNDO. */
/* DEFINE VARIABLE vBuffer AS MEMPTR    NO-UNDO. */
/* DEFINE VARIABLE wloop   AS LOGICAL   NO-UNDO. */

PROCEDURE UrlParser:
    DEFINE INPUT PARAMETER purl AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER phost AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pport AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER ppath AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE vStr AS CHARACTER NO-UNDO.
    
    IF purl BEGINS "http://" THEN DO:
        vStr = SUBSTRING(purl, 8).
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

PROCEDURE HTTPGet-Content:
    DEFINE INPUT PARAMETER phost AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pport AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER ppath AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pfile AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcontent AS CHARACTER NO-UNDO.
    
    wloop = YES.
    CREATE SOCKET vSocket.
    vSocket:SET-READ-RESPONSE-PROCEDURE ("readHandler",THIS-PROCEDURE).
    wstatus = vSocket:CONNECT("-H " + phost + " -S " + pport) NO-ERROR.
    
    IF wstatus = NO THEN DO:
        MESSAGE "Connection to http server:" phost "port" pport "is unavailable".
        DELETE OBJECT vSocket.
        RETURN.
    END.
    
    vStr = "GET " + ppath + " HTTP/1.0" + "~n~n~n".
    SET-SIZE(vBuffer) = LENGTH(vStr) + 1.
    PUT-STRING(vBuffer,1) = vStr.
    vSocket:WRITE(vBuffer, 1, LENGTH(vStr)).
    SET-SIZE(vBuffer) = 0.
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
    vSocket:DISCONNECT().
    DELETE OBJECT vSocket.
    pcontent = vStr.
END PROCEDURE.

PROCEDURE HTTPGet:
    DEFINE INPUT PARAMETER phost AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pport AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER ppath AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pfile AS CHARACTER NO-UNDO.
    
    wloop = YES.
    CREATE SOCKET vSocket.
    vSocket:SET-READ-RESPONSE-PROCEDURE ("readHandler",THIS-PROCEDURE).
    wstatus = vSocket:CONNECT("-H " + phost + " -S " + pport) NO-ERROR.
    
    IF wstatus = NO THEN DO:
        MESSAGE "Connection to http server:" phost "port" pport "is unavailable".
        DELETE OBJECT vSocket.
        RETURN.
    END.
    
    OUTPUT STREAM outfile TO VALUE(pfile) BINARY NO-CONVERT.
    vStr = "GET " + ppath + " HTTP/1.0" + "~n~n~n".
    SET-SIZE(vBuffer) = LENGTH(vStr) + 1.
    PUT-STRING(vBuffer,1) = vStr.
    vSocket:WRITE(vBuffer, 1, LENGTH(vStr)).
    SET-SIZE(vBuffer) = 0.
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
    vSocket:DISCONNECT().
    DELETE OBJECT vSocket.
    OUTPUT STREAM outfile CLOSE.
END PROCEDURE.

PROCEDURE readHandler:
    DEFINE VARIABLE l AS INTEGER NO-UNDO.
    DEFINE VARIABLE str AS CHARACTER NO-UNDO.
    DEFINE VARIABLE b AS MEMPTR NO-UNDO.

    IF SELF:CONNECTED() = FALSE THEN DO:
        APPLY 'CLOSE' TO THIS-PROCEDURE.
        RETURN.
    END.
    l = vSocket:GET-BYTES-AVAILABLE().
    IF l > 0 THEN DO:
        SET-SIZE(b) = l + 1.
        vSocket:READ(b, 1, l, 1).
        str = GET-STRING(b,1).
        PUT STREAM outfile CONTROL str.
        SET-SIZE(b) = 0.
        wloop = YES.
    END.
    ELSE DO:
        wloop = NO.
        OUTPUT STREAM outfile CLOSE.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 4.35
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


