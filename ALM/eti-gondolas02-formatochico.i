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
         WIDTH              = 69.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
    /*PUT STREAM REPORTE '^F00,15'                       SKIP.   /* Coordenadas de origen campo1 */*/
    PUT STREAM REPORTE '^FO0,0'                             SKIP.   /* Coordenadas de origen campo1 */
    PUT STREAM REPORTE '^A0N,35,30'                         SKIP.
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-DesMat                            SKIP.
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    PUT STREAM REPORTE '^FO0,30'                             SKIP.   /* Coordenadas de origen campo1 */
    PUT STREAM REPORTE '^A0N,35,30'                         SKIP.
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-DesMat2                            SKIP.
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    PUT STREAM REPORTE '^FO0,60'                            SKIP.   /* Coordenadas de origen campo1 */
    PUT STREAM REPORTE '^A0N,30,25'                         SKIP.
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-DesMar                             SKIP.
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    IF gn-divi.CanalVenta = "MIN" THEN DO:
        PUT STREAM REPORTE '^FO20,140'                          SKIP.   /* Coordenadas de origen barras */
        IF Almmmatg.CodBrr <> '' THEN DO:
            PUT STREAM REPORTE '^BEN,35'                        SKIP.
            PUT STREAM REPORTE '^FD'.
            PUT STREAM REPORTE x-cod-barra FORMAT 'x(13)'   SKIP.
        END.
        ELSE DO:
            PUT STREAM REPORTE '^BCN,35,Y,N,N'                  SKIP.   /* Codigo 128 */
            PUT STREAM REPORTE '^FD'.
            PUT STREAM REPORTE Almmmatg.Codmat FORMAT 'x(6)'    SKIP.
        END.
        PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    END.
    ELSE DO:
        PUT STREAM REPORTE '^FO20,155'                         SKIP.   /* Coordenadas de origen */
        PUT STREAM REPORTE '^A0n,50,70'                         SKIP.   /* Coordenada de impresion */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE Almmmatg.Codmat  FORMAT 'X(8)'       SKIP.   
        PUT STREAM REPORTE '^FS'                                SKIP.
    END.

    IF gn-divi.CanalVenta = "MIN" THEN DO:
        PUT STREAM REPORTE '^FO250,65'                         SKIP.   /* Coordenadas de origen */
        PUT STREAM REPORTE '^A0N,25,25'                         SKIP.   /* Coordenada de impresion */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE x-dsctopromo  FORMAT 'X(20)'             SKIP.   /* Descripcion */
        PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    END.

    PUT STREAM REPORTE '^FO140,90'                         SKIP.   /* Coordenadas de origen */
    PUT STREAM REPORTE '^A0n,70,80'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-PreUni  FORMAT 'X(12)'             SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo1 */
    
    IF gn-divi.CanalVenta = "MIN" THEN DO:
        /*Fecha*/
        PUT STREAM REPORTE '^FO450,40'                          SKIP.   /* Coordenadas de origen barras */
        PUT STREAM REPORTE '^A0R,20,20'                         SKIP.   /* Coordenada de impresion */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE x-mesyear FORMAT 'x(5)'           SKIP.   /* Descripcion */
        PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    
        /*Impresion Codigo Interno*/
        PUT STREAM REPORTE '^FO450,90'                          SKIP.   /* Coordenadas de origen barras */
        PUT STREAM REPORTE '^A0R,20,20'                         SKIP.   /* Coordenada de impresion */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE almmmatg.codmat  FORMAT '999999'     SKIP.   /* Descripcion */
        PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    
        /*Dscto x Vol 01*/
        PUT STREAM REPORTE '^FO230,150' FORMAT 'x(15)'   SKIP.   /* Coordenadas de origen */
        PUT STREAM REPORTE '^A0n,30,20'                         SKIP.   /* Coordenada de impresion */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE x-Dtovol  FORMAT 'X(40)'             SKIP.   /* Descripcion */
        PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    
        /*Dscto x Vol 01*/
        PUT STREAM REPORTE '^FO230,175' FORMAT 'x(15)'   SKIP.   /* Coordenadas de origen */
        PUT STREAM REPORTE '^A0n,30,20'                         SKIP.   /* Coordenada de impresion */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE x-Dtovo2  FORMAT 'X(40)'             SKIP.   /* Descripcion */
        PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


