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
         HEIGHT             = 4.88
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
    /*PUT STREAM REPORTE '^F00,15'                       SKIP.   /* Coordenadas de origen campo1 */*/
    PUT STREAM REPORTE '^F00,15'                       SKIP.   /* Coordenadas de origen campo1 */
    PUT STREAM REPORTE '^A0N,50,40'                    SKIP.
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-DesMat                        SKIP.
    PUT STREAM REPORTE '^FS'                           SKIP.   /* Fin de Campo1 */
    PUT STREAM REPORTE '^F00,80'                       SKIP.   /* Coordenadas de origen barras */
    /*PUT STREAM REPORTE '^BY3^BCN,50,Y,N,N'        SKIP.   /* Codigo 128 */*/
    IF Almmmatg.CodBrr <> '' THEN DO:
        PUT STREAM REPORTE '^BEN,50'                       SKIP.
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE Almmmatg.CodBrr FORMAT 'x(13)'  SKIP.
    END.
    ELSE DO: 
        PUT STREAM REPORTE '^BCN,60,Y,N,N'                SKIP.   /* Codigo 128 */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE Almmmatg.Codmat FORMAT 'x(6)'   SKIP.
        /*
        PUT STREAM REPORTE Almmmatg.CodMat FORMAT 'x(6)'  SKIP.
        */
    END.

    PUT STREAM REPORTE '^FS'                           SKIP.   /* Fin de Campo1 */

    PUT STREAM REPORTE '^FO330,90'                     SKIP.   /* Coordenadas de origen */
    PUT STREAM REPORTE '^A0n,85,85'                    SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-PreUni  FORMAT 'X(12)'        SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                           SKIP.   /* Fin de Campo1 */

/*
              PUT STREAM REPORTE '^BCN,100,Y,N,N'            SKIP.   /* Codigo 128 */
              PUT STREAM REPORTE '^FD'.
              PUT STREAM REPORTE Almmmatg.Codmat FORMAT 'x(6)' SKIP.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


