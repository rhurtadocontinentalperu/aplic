&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Trata de bloquear un registro en modo exclusivoen 5 intentos

    Syntax      : {lib/lock.i &Tabla="nomhbre-de-tabla" &Condicion="campos y valores"}

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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
         HEIGHT             = 4.12
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
/*
    RUTINA QUE TRATA DE BLOQUEAR EL REGISTRO CON MENSAJES DE ERROR
    SI ESTÁ USADO POR OTRO USUARIO REINTENTA HASTA 5 VECES
    SI ES UNA LLAVE DUPLICADA MUESTRA EL MENSAJE DE ERROR Y SALE CON UN ERROR
*/
DEF VAR LocalCounter AS INTEGER INITIAL 0 NO-UNDO.
DEF VAR cMsgs AS CHARACTER NO-UNDO.
DEF VAR ix AS INTEGER NO-UNDO.

GetLock:
REPEAT ON STOP UNDO GetLock, RETRY GetLock ON ERROR UNDO GetLock, LEAVE GetLock:
    IF RETRY THEN DO:
        LocalCounter = LocalCounter + 1.
        IF LocalCounter = 5 THEN LEAVE GetLock.    /* 5 intentos máximo */
    END.
    FIND {&Tabla} WHERE {&Condicion} EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE {&Tabla} THEN LEAVE.
    IF AMBIGUOUS {&Tabla} OR ERROR-STATUS:ERROR THEN DO:      /* Llave Duplicada o No existe*/
        IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
            cMsgs = ERROR-STATUS:GET-MESSAGE(1).
            DO ix = 2 TO ERROR-STATUS:NUM-MESSAGES:
                cMsgs = cMsgs + CHR(10) + ERROR-STATUS:GET-MESSAGE(ix).
            END.
            MESSAGE cMsgs VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        END.
        LEAVE GetLock.
    END.
END.
IF LocalCounter = 5 OR NOT AVAILABLE {&Tabla} THEN UNDO, RETURN "ADM-ERROR".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


