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
/* Sintaxis
{lib/mensaje-de-error.i ~
    &CuentaError="pCuenta" ~    /* OPCIONAL */
    &MensajeError="pMensaje" ~
    }
*/
    /*DEFINE VARIABLE LocalCuentaError AS INTEGER NO-UNDO.*/
    &IF DEFINED(CuentaError) &THEN
    &ELSE
    DEFINE VARIABLE LocalCuentaError AS INTEGER NO-UNDO.
    &SCOPED-DEFINE CuentaError LocalCuentaError
    &ENDIF
    {&MensajeError} = ''.
    DO {&CuentaError} = 1 TO ERROR-STATUS:NUM-MESSAGES:
        {&MensajeError} = {&MensajeError} + 
                        (IF {&CuentaError} = 1 THEN '' ELSE CHR(10)) +
                        ERROR-STATUS:GET-MESSAGE({&CuentaError}).
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
         HEIGHT             = 3.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


