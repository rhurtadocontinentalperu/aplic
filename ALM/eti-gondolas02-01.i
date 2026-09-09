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
    PUT STREAM REPORTE '^FO0,0'                             SKIP.   /* Coordenadas de origen campo1 */
    PUT STREAM REPORTE '^A0N,45,45'                         SKIP.
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-DesMat                             SKIP.
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    /*RDP01 - Descripcion 01*/
    PUT STREAM REPORTE '^FO0,50'                            SKIP.   /* Coordenadas de origen campo1 */
    PUT STREAM REPORTE '^A0N,40,40'                         SKIP.
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-DesMar                             SKIP.
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    PUT STREAM REPORTE '^FO20,90'                          SKIP.   /* Coordenadas de origen barras */
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

    PUT STREAM REPORTE '^FO260,40'                         SKIP.   /* Coordenadas de origen */
    PUT STREAM REPORTE '^A0n,60,60'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-PreUni  FORMAT 'X(12)'             SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    /*Fecha*/
    PUT STREAM REPORTE '^FO650,10'                          SKIP.   /* Coordenadas de origen barras */
    PUT STREAM REPORTE '^A0R,20,20'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE TODAY  FORMAT '99/99/9999'           SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    /*Impresion Codigo Interno*/
    PUT STREAM REPORTE '^FO650,125'                          SKIP.   /* Coordenadas de origen barras */
    PUT STREAM REPORTE '^A0R,20,20'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE almmmatg.codmat  FORMAT '999999'     SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    IF x-prec-ean14 = "" THEN DO:    
        x-fila1 = "90".     /*"110"*/
        x-fila2 = "130".    /*"140"*/
    END.
    ELSE DO:
        /* Precio Expcion x C. Huarac */
        PUT STREAM REPORTE '^FO280,115'                         SKIP.   /* Coordenadas de origen */
        PUT STREAM REPORTE '^A0n,25,20'                         SKIP.   /* Coordenada de impresion */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE x-prec-ean14  FORMAT 'X(40)'             SKIP.   /* Descripcion */
        PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
        x-fila1 = "150".
        x-fila2 = "180".
    END.
    /*
        /*Dscto x Vol 01*/
        PUT STREAM REPORTE '^FO255,110'                         SKIP.   /* Coordenadas de origen */
        PUT STREAM REPORTE '^A0n,25,20'                         SKIP.   /* Coordenada de impresion */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE x-Dtovol  FORMAT 'X(40)'             SKIP.   /* Descripcion */
        PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

        /*Dscto x Vol 01*/
        PUT STREAM REPORTE '^FO255,140'                         SKIP.   /* Coordenadas de origen */
        PUT STREAM REPORTE '^A0n,25,20'                         SKIP.   /* Coordenada de impresion */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE x-Dtovo2  FORMAT 'X(40)'             SKIP.   /* Descripcion */
        PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
     */

    /*Dscto x Vol 01*/
    PUT STREAM REPORTE '^FO255,' + x-fila1 FORMAT 'x(15)'   SKIP.   /* Coordenadas de origen */
    PUT STREAM REPORTE '^A0n,45,25'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-Dtovol  FORMAT 'X(40)'             SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    /*Dscto x Vol 01*/
    PUT STREAM REPORTE '^FO255,' + x-fila2 FORMAT 'x(15)'   SKIP.   /* Coordenadas de origen */
    PUT STREAM REPORTE '^A0n,45,25'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-Dtovo2  FORMAT 'X(40)'             SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */


/* ***************************  Main Block  *************************** 
    /*PUT STREAM REPORTE '^F00,15'                       SKIP.   /* Coordenadas de origen campo1 */*/
    PUT STREAM REPORTE '^FO0,0'                             SKIP.   /* Coordenadas de origen campo1 */
    PUT STREAM REPORTE '^A0N,45,45'                         SKIP.
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-DesMat                             SKIP.
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    /*RDP01 - Descripcion 01*/
    PUT STREAM REPORTE '^FO0,50'                            SKIP.   /* Coordenadas de origen campo1 */
    PUT STREAM REPORTE '^A0N,40,40'                         SKIP.
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-DesMar                             SKIP.
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    /*RDP01 - Descripcion 02*/
    PUT STREAM REPORTE '^FO350,60'                          SKIP.   /* Coordenadas de origen campo1 */
    PUT STREAM REPORTE '^A0N,30,30'                         SKIP.
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-DesMat2                            SKIP.
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */


    PUT STREAM REPORTE '^FO20,100'                          SKIP.   /* Coordenadas de origen barras */
    IF Almmmatg.CodBrr <> '' THEN DO:
        PUT STREAM REPORTE '^BEN,40'                        SKIP.
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE Almmmatg.CodBrr FORMAT 'x(13)'   SKIP.
    END.
    ELSE DO: 
        PUT STREAM REPORTE '^BCN,40,Y,N,N'                  SKIP.   /* Codigo 128 */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE Almmmatg.Codmat FORMAT 'x(6)'    SKIP.
    END.
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    PUT STREAM REPORTE '^FO300,110'                         SKIP.   /* Coordenadas de origen */
    PUT STREAM REPORTE '^A0n,85,85'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-PreUni  FORMAT 'X(12)'             SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    /*Fecha*/
    PUT STREAM REPORTE '^FO20,170'                          SKIP.   /* Coordenadas de origen barras */
    PUT STREAM REPORTE '^A0n,20,20'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE TODAY  FORMAT '99/99/9999'           SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    /*Impresion Codigo Interno*/
    PUT STREAM REPORTE '^FO120,170'                          SKIP.   /* Coordenadas de origen barras */
    PUT STREAM REPORTE '^A0n,20,20'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE almmmatg.codmat  FORMAT '999999'     SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

************Este es ****/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


