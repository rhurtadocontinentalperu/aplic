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
         HEIGHT             = 3.92
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
/*
    RUTINA QUE TRATA DE BLOQUEAR EL REGISTRO SIN MENSAJES DE ERROR
    SI ESTÁ USADO POR OTRO USUARIO REINTENTA HASTA 5 VECES
    SI ES UNA LLAVE DUPLICADA SALE CON UN ERROR
    
    EL CONTROL DE ERRORES ESTA A CARGO DE LA RUTINA QUE LLAMA ESTA LIBRERIA
*/

DEF VAR LocalCounter AS INTEGER INITIAL 0 NO-UNDO.
GetLock:
REPEAT ON ERROR UNDO GetLock, LEAVE GetLock:
    FIND {&Tabla} WHERE {&Condicion} EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF AVAILABLE {&Tabla} THEN LEAVE.           /* Bloqeo Exitoso */
    IF AMBIGUOUS {&Tabla} THEN LEAVE GetLock.   /* Llave Duplicada */
    IF ERROR-STATUS:ERROR THEN LEAVE GetLock.   /* Registro no encontrado */
    LocalCounter = LocalCounter + 1.            /* Acumulamos Intentos */
    PAUSE 2 NO-MESSAGE.                         /* Dos segundos de espera */
    IF LocalCounter = 5 THEN LEAVE GetLock.    /* 5 intentos máximo */
END.
IF LocalCounter = 5 OR NOT AVAILABLE {&Tabla} THEN UNDO, RETURN "ADM-ERROR".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


