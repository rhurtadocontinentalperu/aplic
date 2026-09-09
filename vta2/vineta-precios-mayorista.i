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
         WIDTH              = 51.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
    /*PUT STREAM REPORTE '^F00,15'                       SKIP.   /* Coordenadas de origen campo1 */*/
    PUT STREAM REPORTE '^FO0,0'                             SKIP.   /* Coordenadas de origen campo1 */
    PUT STREAM REPORTE '^A0N,45,30'                         SKIP.
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-DesMat FORMAT 'x(40)'              SKIP.
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    /*RDP01 - Descripcion 01*/
    PUT STREAM REPORTE '^FO0,50'                            SKIP.   /* Coordenadas de origen campo1 */
    PUT STREAM REPORTE '^A0N,40,40'                         SKIP.
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-DesMar                             SKIP.
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    /*RDP01 - Descripcion 02*/
    /*
    PUT STREAM REPORTE '^FO350,50'                          SKIP.   /* Coordenadas de origen campo1 */
    PUT STREAM REPORTE '^A0N,30,30'                         SKIP.
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-DesMat2                            SKIP.
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    */

    PUT STREAM REPORTE '^FO20,90'                          SKIP.   /* Coordenadas de origen barras */
    IF Almmmatg.CodBrr <> '' THEN DO:
        PUT STREAM REPORTE '^BEN,35'                        SKIP.
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE Almmmatg.CodBrr FORMAT 'x(13)'   SKIP.
    END.
    ELSE DO:
        PUT STREAM REPORTE '^BCN,35,Y,N,N'                  SKIP.   /* Codigo 128 */   
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE Almmmatg.Codmat FORMAT 'x(6)'    SKIP.     
    END.
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    /*
    PUT STREAM REPORTE '^FO260,40'                         SKIP.   /* Coordenadas de origen */
    PUT STREAM REPORTE '^A0n,50,80'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-PreUni  FORMAT 'X(12)'             SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    
    PUT STREAM REPORTE '^FO575,50'                         SKIP.   /* Coordenadas de origen */ 
    PUT STREAM REPORTE '^A0n,30,30'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE lUnidadVenta_und  FORMAT 'X(12)'             SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    */

    
    /* Precio A */
    IF x-precio-1 <> "" THEN DO:
        PUT STREAM REPORTE '^FO255,100'                         SKIP.   /* Coordenadas de origen */
        PUT STREAM REPORTE '^A0n,25,20'                         SKIP.   /* Coordenada de impresion */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE x-precio-1  FORMAT 'X(40)'             SKIP.   /* Descripcion */
        PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    END.    
    /* Precio B */  
    IF x-precio-2 <> "" THEN DO:
        PUT STREAM REPORTE '^FO255,130'                         SKIP.   /* Coordenadas de origen */
        PUT STREAM REPORTE '^A0n,25,20'                         SKIP.   /* Coordenada de impresion */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE x-precio-2  FORMAT 'X(40)'             SKIP.   /* Descripcion */
        PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    END.
    /*
    /* Precio C */
    IF lUnidadVenta_undC <> "" THEN DO:
        PUT STREAM REPORTE '^FO255,160'                         SKIP.   /* Coordenadas de origen */
        PUT STREAM REPORTE '^A0n,25,20'                         SKIP.   /* Coordenada de impresion */
        PUT STREAM REPORTE '^FD'.
        PUT STREAM REPORTE lUnidadVenta_undC  FORMAT 'X(40)'             SKIP.   /* Descripcion */
        PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    END.
    */

    /*Fecha*/
    PUT STREAM REPORTE '^FO675,10'                          SKIP.   /* Coordenadas de origen barras */
    PUT STREAM REPORTE '^A0R,20,20'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE TODAY  FORMAT '99/99/9999'           SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    /*Impresion Codigo Interno*/
    PUT STREAM REPORTE '^FO675,125'                          SKIP.   /* Coordenadas de origen barras */
    PUT STREAM REPORTE '^A0R,20,20'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE almmmatg.codmat  FORMAT '999999'     SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

    /*Notita*/
/*     PUT STREAM REPORTE '^FO00,170'                          SKIP.   /* Coordenadas de origen barras */ */
/*     PUT STREAM REPORTE '^A0N,18,18'                         SKIP.   /* Coordenada de impresion */      */
/*     PUT STREAM REPORTE '^FD'.                                                                          */
/*     PUT STREAM REPORTE cNotita           FORMAT 'X(35)'           SKIP.   /* Descripcion */            */
/*     PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */                */

    /*
    /*Dscto x Vol 01*/
    PUT STREAM REPORTE '^FO00,150'                          SKIP.   /* Coordenadas de origen barras */
    PUT STREAM REPORTE '^A0n,40,40'                         SKIP.   /* Coordenada de impresion */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE x-Dtovol  FORMAT 'x(40)'           SKIP.   /* Descripcion */
    PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */
    */

    /*Dscto x Vol 02*/
/*     PUT STREAM REPORTE '^FO350,190'                          SKIP.   /* Coordenadas de origen barras */ */
/*     PUT STREAM REPORTE '^A0n,25,25'                         SKIP.   /* Coordenada de impresion */       */
/*     PUT STREAM REPORTE '^FD'.                                                                           */
/*     PUT STREAM REPORTE x-Dtovo2  FORMAT 'x(40)'            SKIP.   /* Descripcion */                    */
/*     PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */                 */

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


