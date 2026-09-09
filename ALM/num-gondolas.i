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
         HEIGHT             = 11.08
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
          PUT STREAM REPORTE '^FO60,15'                      SKIP.   /* Coordenadas de origen campo1 */
          PUT STREAM REPORTE '^A0N,25,15'                    SKIP.
          PUT STREAM REPORTE '^FD'.
          PUT STREAM REPORTE iNumero                         SKIP.
          PUT STREAM REPORTE '^FS'                           SKIP.   /* Fin de Campo1 */
          PUT STREAM REPORTE '^FO60,40'                      SKIP.   /* Coordenadas de origen barras */


          PUT STREAM REPORTE '^BY3^BCN,100,Y,N,N'        SKIP.   /* Codigo 128 */
          PUT STREAM REPORTE '^FD'.
          PUT STREAM REPORTE iNumero2  SKIP.

          PUT STREAM REPORTE '^FS'                       SKIP.   /* Fin de Campo2 */
          PUT STREAM REPORTE '^PQ' + TRIM(STRING(1)) SKIP.  /* Cantidad a imprimir */
          PUT STREAM REPORTE '^PR' + '6'                   SKIP.   /* Velocidad de impresion Pulg/seg */
          PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


