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


/*                                                                                                */
/*                                                                                                */
/*   PUT STREAM REPORTE '^FO155,00'                   SKIP.   /* Coordenadas de origen */         */
/*   PUT STREAM REPORTE '^A0R,25,15'                  SKIP.   /* Coordenada de impresion */       */
/*   PUT STREAM REPORTE '^FD'.                                                                    */
/*   PUT STREAM REPORTE SUBSTRING(Desmat,1,40) FORMAT 'x(40)' SKIP.   /* Descripcion */           */
/*   PUT STREAM REPORTE '^FS'                         SKIP.   /* Fin de Campo1 */                 */
/*   PUT STREAM REPORTE '^FO130,00'                   SKIP.   /* Coordenadas de origen campo2 */  */
/*   PUT STREAM REPORTE '^A0R,25,15'                  SKIP.                                       */
/*   PUT STREAM REPORTE '^FD'.                                                                    */
/*   PUT STREAM REPORTE SUBSTRING(Desmar,1,26) FORMAT 'x(26)' SKIP.                               */
/*   PUT STREAM REPORTE '^FS'                         SKIP.   /* Fin de Campo2 */                 */
/*   PUT STREAM REPORTE '^FO55,30'                    SKIP.   /* Coordenadas de origen barras */  */
/*   IF x-Tipo = 1 THEN DO:                                                                       */
/*     PUT STREAM REPORTE '^BCR,80'                     SKIP.   /* Codigo 128 */                  */
/*     PUT STREAM REPORTE '^FD'.                                                                  */
/*     PUT STREAM REPORTE Almmmatg.CodMat FORMAT 'x(6)' SKIP.                                     */
/*   END.                                                                                         */
/*   ELSE DO:                                                                                     */
/*     PUT STREAM REPORTE '^BER,80'                SKIP.   /* Codigo 128 */                       */
/*     PUT STREAM REPORTE '^FD'.                                                                  */
/*     PUT STREAM REPORTE Almmmatg.CodBrr FORMAT 'x(13)' SKIP.                                    */
/*   END.                                                                                         */
/*   PUT STREAM REPORTE '^FS'                         SKIP.   /* Fin de Campo2 */                 */
/*                                                                                                */
/*                                                                                                */



 
  PUT STREAM REPORTE '^FO155,00'                   SKIP.   /* Coordenadas de origen */
  PUT STREAM REPORTE '^A0R,25,15'                  SKIP.   /* Coordenada de impresion */
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE SUBSTRING(Desmat,1,40) FORMAT 'x(40)' SKIP.   /* Descripcion */
  PUT STREAM REPORTE '^FS'                         SKIP.   /* Fin de Campo1 */
  PUT STREAM REPORTE '^FO125,00'                   SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0R,25,15'                  SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE SUBSTRING(Desmar,1,26) FORMAT 'x(26)' SKIP.
  PUT STREAM REPORTE '^FS'                         SKIP.   /* Fin de Campo2 */
  PUT STREAM REPORTE '^FO50,30'                    SKIP.   /* Coordenadas de origen barras */
  IF x-Tipo = 1 THEN DO:
    PUT STREAM REPORTE '^BCR,70'                     SKIP.   /* Codigo 128 */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE Almmmatg.CodMat FORMAT 'x(6)' SKIP.
  END.
  ELSE DO:
    PUT STREAM REPORTE '^BER,70'                SKIP.   /* Codigo 128 */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE Almmmatg.CodBrr FORMAT 'x(13)' SKIP.
  END.
  PUT STREAM REPORTE '^FS'                         SKIP.   /* Fin de Campo2 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


