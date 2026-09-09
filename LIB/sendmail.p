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

DEFINE VARIABLE vbuffer AS MEMPTR  NO-UNDO.
DEFINE VARIABLE hSocket AS HANDLE  NO-UNDO.
DEFINE VARIABLE vstatus AS LOGICAL NO-UNDO.
DEFINE VARIABLE vState  AS INTEGER NO-UNDO.

DEFINE VARIABLE vSmtpServer AS CHARACTER NO-UNDO 
                               FORMAT "X(50)"
                               LABEL "Smtp Server" 
                               INITIAL "smtp.company.com".

DEFINE VARIABLE vdebugmode  AS LOGICAL NO-UNDO
                               VIEW-AS TOGGLE-BOX.

DEFINE VARIABLE vFrom       AS CHARACTER NO-UNDO
                               FORMAT "X(50)"
                               LABEL "From" 
                               INITIAL "myaddress@mycompany.com".

DEFINE VARIABLE vTo         AS CHARACTER NO-UNDO
                               FORMAT "X(50)"
                               LABEL "To" 
                               INITIAL "toaddress@tocompany.com".

DEFINE VARIABLE vSubject    AS CHARACTER NO-UNDO
                               FORMAT "X(50)"
                               LABEL "Subject" 

                               INITIAL "test email using Progress 4GL sockets".

DEFINE VARIABLE vBody       AS CHARACTER NO-UNDO
                               VIEW-AS EDITOR INNER-LINES 20 INNER-CHARS 70
                               SCROLLBAR-VERTICAL INITIAL "test email".

/*
  Status:
        0 - No Connection to the server
        1 - Waiting for 220 connection to SMTP server
        2 - Waiting for 250 OK status to start sending email
        3 - Waiting for 250 OK status for sender
        4 - Waiting for 250 OK status for recipient
        5 - Waiting for 354 OK status to send data
        6 - Waiting for 250 OK status for message received
        7 - Quiting
*/

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

&IF DEFINED(EXCLUDE-Cleanup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cleanup Procedure 
PROCEDURE Cleanup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    hSocket:DISCONNECT() NO-ERROR.
    DELETE OBJECT hSocket NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-NewState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewState Procedure 
PROCEDURE NewState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER newState AS INTEGER.
    DEFINE INPUT PARAMETER pstring  AS CHARACTER.

    IF vdebugmode THEN 
        MESSAGE "newState: " newState " pstring: " pstring VIEW-AS ALERT-BOX.
        vState = newState.
        IF pstring = "" THEN 
            RETURN.
        SET-SIZE(vbuffer) = LENGTH(pstring) + 1.
        PUT-STRING(vbuffer,1) = pstring.
        hSocket:WRITE(vbuffer, 1, LENGTH(pstring)).
        SET-SIZE(vbuffer) = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ReadHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReadHandler Procedure 
PROCEDURE ReadHandler :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE vlength AS INTEGER NO-UNDO.
    DEFINE VARIABLE str AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v AS INTEGER NO-UNDO.

    vlength = hSocket:GET-BYTES-AVAILABLE().
    IF vlength > 0 THEN
        DO:
            SET-SIZE(vbuffer) = vlength + 1.
            hSocket:READ(vbuffer, 1, vlength, 1).
            str = GET-STRING(vbuffer,1).
            IF vdebugmode THEN 
                MESSAGE "server:" str VIEW-AS ALERT-BOX.
            SET-SIZE(vbuffer) = 0.
            v = INTEGER(ENTRY(1, str," ")).
            CASE vState:
                WHEN 1 THEN 
                    IF v = 220 THEN
                        RUN newState(2, "HELO your.fully.qualified.domain.name.goes.here~r~n").
                    ELSE 
                        vState = -1.
                WHEN 2 THEN 
                    IF v = 250 THEN
                        RUN newState(3, "MAIL From: " + vFrom + "~r~n").
                    ELSE 
                        vState = -1.
                WHEN 3 THEN 
                    IF v = 250 THEN
                        RUN newState(4, "RCPT TO: " + vTo + "~r~n").
                    ELSE 
                        vState = -1.
                WHEN 4 THEN 
                    IF v = 250 THEN
                        RUN newState(5, "DATA ~r~n").
                    ELSE 
                        vState = -1.
                WHEN 5 THEN 
                    IF v = 354 THEN
                        RUN newState(6, "From: " + vFrom + "~r~n" + 
                                    "To: " + vTo + " ~r~n" +
                              "Subject: " + vSubject + 
                               " ~r~n~r~n" + 
                               vBody + "~r~n" + 
                               ".~r~n").
                    ELSE 
                        vState = -1.

                WHEN 6 THEN 
                    IF v = 250 THEN
                        RUN newState(7,"QUIT~r~n").
                    ELSE 
                        vState = -1.
            END CASE.
        END.
        IF vState = 7 THEN 
            MESSAGE "Email has been accepted for delivery.".
        IF vState < 0 THEN 
            MESSAGE "Email has been aborted".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SendMail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SendMail Procedure 
PROCEDURE SendMail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    CREATE SOCKET hSocket.
    hSocket:SET-READ-RESPONSE-PROCEDURE("readHandler", THIS-PROCEDURE).
    vstatus = hSocket:CONNECT("-S 25 -H " + vSmtpServer) NO-ERROR.
    IF NOT vstatus THEN 
        DO:
            MESSAGE "Server is unavailable".
            RETURN.
        END.
    vstate = 1.
    REPEAT ON STOP UNDO, LEAVE ON QUIT UNDO, LEAVE:
        IF vstate < 0 OR vstate = 7 THEN 
            LEAVE.
        WAIT-FOR READ-RESPONSE OF hSocket.
    END.
    RUN cleanup.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

