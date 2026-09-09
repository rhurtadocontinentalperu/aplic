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

    {&pCampo}:PASSWORD-FIELD = YES.
    ON ANY-PRINTABLE OF {&pCampo} IN FRAME {&FRAME-NAME}
    DO:
      {&pContadorCaracteres} = {&pContadorCaracteres} + 1.
      IF {&pContadorCaracteres} = 1 THEN {&pInicioDigitacion} = NOW.
    END.
    ON ENTRY OF {&pCampo} IN FRAME {&FRAME-NAME}
    DO:
      {&pContadorCaracteres} = 0.
      {&pValorScreenBuffer} = SELF:SCREEN-VALUE.
    END.
/*     ON LEAVE OF {&pCampo} IN FRAME {&FRAME-NAME}                                                       */
/*     DO:                                                                                                */
/*       {&pFinDigitacion} = NOW.                                                                         */
/*       /* Límite de 500 milisegundos */                                                                 */
/*       IF INTERVAL({&pFinDigitacion}, {&pInicioDigitacion}, 'milliseconds') > {&pTiempoLimite} THEN DO: */
/*           /* Retomamos el valor del buffer */                                                          */
/*           SELF:SCREEN-VALUE = {&pValorScreenBuffer}.                                                   */
/*       END.                                                                                             */
/*     END.                                                                                               */
    ON RETURN OF {&pCampo} IN FRAME {&FRAME-NAME}
    DO:
        APPLY 'TAB':U.
        RETURN NO-APPLY.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


