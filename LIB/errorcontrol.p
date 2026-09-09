&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
  File:         ErrorControl.p
  Purpose:      Rutina genérica para el manejo centralizado de errores.
                Registra el error y opcionalmente lo muestra al usuario.
  Parameters:   pErrorObject (INPUT Progress.Lang.Error) - El objeto de error capturado.
                pAction      (INPUT CHARACTER)         - Acción a tomar ('LOG', 'DISPLAY', 'LOG_AND_DISPLAY').
  Returns:      VOID
  Notes:        Debe ser llamada desde un bloque CATCH.
                Para OpenEdge 10, considera que los objetos Progress.Lang.Error
                fueron introducidos en 10.1C.
--------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

    DEFINE INPUT PARAMETER pErrorObject AS Progress.Lang.Error NO-UNDO.
    DEFINE INPUT PARAMETER pAction      AS CHARACTER           NO-UNDO.

    DEFINE VARIABLE cErrorMessage AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iErrorNumber  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cErrorType    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cProcedureName AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iLineNumber   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cStack        AS CHARACTER NO-UNDO.

    /* Obtener información del error */
    cErrorMessage = pErrorObject:GetMessage(1).
    /*iErrorNumber  = pErrorObject:GetNumber(1).*/
    /*cErrorType    = pErrorObject:GetClass(). /* Nombre de la clase del error (ej. Progress.Lang.SysError) */*/
    /*cStack        = pErrorObject:GetStack().*/

    /* Intentar obtener información adicional de la pila de llamadas (puede variar la granularidad en OE10) */
    /* Para OE10, GetStack() te dará la pila completa. Parsearla puede ser complejo.
       Una alternativa es usar GetStack(1) o 2 para el primer o segundo elemento,
       pero para una solución genérica, la pila completa es más útil. */

    /* Extraer nombre de la rutina y línea donde ocurrió el error, si es posible.
       Esto es una simplificación, ya que GetStack() devuelve una cadena más compleja.
       Podrías necesitar una función auxiliar para parsear GetStack() de manera más robusta. */
    DO:
        DEFINE VARIABLE iFirstLineEnd AS INTEGER NO-UNDO.
        iFirstLineEnd = INDEX(cStack, "~n").
        IF iFirstLineEnd > 0 THEN
            cProcedureName = SUBSTRING(cStack, 1, iFirstLineEnd - 1).
        ELSE
            cProcedureName = cStack.
        /* Podrías usar un REGEX o más lógica para extraer el nombre del procedimiento y la línea exacta */
        /* Ejemplo muy simplificado: buscar " at " y números */
        /* Para OE10, esto puede ser complicado sin librerías adicionales. */
        /* Para este ejemplo, solo usaremos el inicio de la pila como referencia. */
    END.

    CASE pAction:
        WHEN "LOG" THEN RUN LogError.
        WHEN "DISPLAY" THEN RUN DisplayError.
        WHEN "LOG_AND_DISPLAY" THEN DO:
            RUN LogError.
            RUN DisplayError.
        END.
        OTHERWISE DO:
            /* Acción por defecto o error de configuración */
            MESSAGE "ErrorControl: Acción no reconocida ('" + pAction + "')" VIEW-AS ALERT-BOX ERROR.
            RUN LogError. /* Siempre loguear si hay un problema con la acción */
        END.
    END CASE.

    /* Opcional: Eliminar el objeto de error una vez procesado */
    /* DELETE OBJECT pErrorObject.  Ten precaución con esto si el error va a ser relanzado
       o si el AVM lo limpia automáticamente al salir del CATCH. */

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
         HEIGHT             = 6.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-DisplayError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayError Procedure 
PROCEDURE DisplayError :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        DEFINE VARIABLE cDisplayMsg AS CHARACTER NO-UNDO.

        /* Mensaje amigable para el usuario */
        cDisplayMsg = "Se ha producido un error inesperado. Por favor, contacte a soporte técnico." + "~n" +
                      "Detalles: " + cErrorMessage + " (Código: " + STRING(iErrorNumber) + ")".

        /* Solo mostrar detalles técnicos si el entorno lo permite o si es para depuración */
        /* IF SESSION:DEBUG-ENABLED THEN */
        /* cDisplayMsg = cDisplayMsg + "~n" + "Pila: " + cStack. */

        MESSAGE cDisplayMsg VIEW-AS ALERT-BOX ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LogError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LogError Procedure 
PROCEDURE LogError :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        DEFINE VARIABLE cLogLine AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cLogFile AS CHARACTER NO-UNDO.

        /* Define la ruta de tu archivo de log */
        cLogFile = "error.log". /* Puedes hacerlo configurable */

        OUTPUT TO VALUE(cLogFile) APPEND.

        /* Formatear la línea de log */
        cLogLine = STRING(TODAY, "99/99/99") + " " + STRING(TIME, "HH:MM:SS") +
                   "|Type:" + cErrorType +
                   "|Num:" + STRING(iErrorNumber) +
                   "|Msg:" + cErrorMessage +
                   "|Proc:" + cProcedureName +
                   "|Stack:" + cStack.

        PUT UNFORMATTED cLogLine SKIP.

        OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

