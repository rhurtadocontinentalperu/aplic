&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

    PUT '^FO155,00'                     SKIP.   /* Coordenadas de origen campo1 */
    PUT '^A0R,25,15'                    SKIP.
    PUT '^FD'.
    PUT SUBSTR(Desmat,1,40) FORMAT 'x(40)' SKIP.
    PUT '^FS'                           SKIP.   /* Fin de Campo1 */
    PUT '^FO130,00'                     SKIP.   /* Coordenadas de origen campo2 */
    PUT '^A0R,25,15'                    SKIP.
    PUT '^FD'.
    PUT SUBSTR(Desmar,1,26) FORMA 'x(26)' SKIP.
    PUT '^FS'                           SKIP.   /* Fin de Campo2 */
    PUT '^FO55,30'                      SKIP.   /* Coordenadas de origen barras */
    IF x-Tipo = 1 THEN DO:
        PUT '^BCR,80'                   SKIP.   /* Codigo 128 */
        PUT '^FD'.
        PUT Almmmatg.codmat FORMAT 'x(6)' SKIP.
    END.
    ELSE DO:
        PUT '^BER,80'                   SKIP.   /* Codigo 128 */
        PUT '^FD'.
        PUT Barras[x-Barras - 1]        SKIP.
    END.
    PUT '^FS'                           SKIP.   /* Fin de Campo2 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


