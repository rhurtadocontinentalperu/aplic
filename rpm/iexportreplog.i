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

/* Insistir hasta 5 veces como máximo */
iErrores = 0.
i = 0.
FOR EACH {&pTabla} NO-LOCK WHERE {&pTabla}.{&pCampo} = NO 
    AND DATE({&pTabla}.LogDate) >= FILL-IN-Fecha-1
    AND DATE({&pTabla}.LogDate) <= FILL-IN-Fecha-2
    USE-INDEX {&pIndice} 
    ON STOP UNDO, RETRY:
    IF RETRY THEN iErrores = iErrores + 1.
    IF iErrores > 5 THEN LEAVE.
    /* Bloqueamos el buffer */
    FIND {&pBuffer} WHERE ROWID({&pBuffer}) = ROWID({&pTabla}) 
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE {&pBuffer} THEN UNDO, RETRY.
    /* Copiamos al temporal */
    CREATE {&pTemporal}.
    BUFFER-COPY {&pTabla} TO {&pTemporal}.
    /* Actualizamos campo de control */
    ASSIGN
        {&pBuffer}.{&pCampo} = YES.
    RELEASE {&pBuffer}.
    IF i > 1000 AND (i MODULO 1000) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Fecha : " + STRING(replog.LogDate)  +
        " Tabla: " + replog.TableName + 
        " Evento: " + replog.Event +
        " Llave: " + replog.KeyValue.
    iErrores = 1.
END.
IF iErrores > 5 THEN DO:
    MESSAGE 'NO se pudo Exportar la información' SKIP
        'Proceso Abortado' VIEW-AS ALERT-BOX WARNING.
    EMPTY TEMP-TABLE {&pTemporal}.
    UNDO, RETURN.
END.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


