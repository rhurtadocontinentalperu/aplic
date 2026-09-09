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
         HEIGHT             = 4.12
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  PUT STREAM REPORTE '^FO10,20'                     SKIP.   /* Coordenadas de origen */
  PUT STREAM REPORTE '^A0N,40,40'                   SKIP.   /* Coordenada de impresion */
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE SUBSTRING(cNomCli,1,30)        FORMAT 'x(40)' SKIP.   /* Descripcion */
  PUT STREAM REPORTE '^FS'                          SKIP.   /* Fin de Campo1 */
  PUT STREAM REPORTE '^FO150,70'                     SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,40,40'                   SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE SUBSTRING(cRucCli,1,12)        FORMAT 'x(26)' SKIP.
  PUT STREAM REPORTE '^FS'                          SKIP.   /* Fin de Campo2 */
  /* Los 300 primeros */
  /*
  IF gn-clie.libre_d01 >= 1000 AND gn-clie.libre_d01 <= 1300 
      THEN DO:
      PUT STREAM REPORTE '^FO650,50'                     SKIP.   /* Coordenadas de origen campo2 */
      PUT STREAM REPORTE '^A0N,25,25'                   SKIP.
      PUT STREAM REPORTE '^FD'.
      PUT STREAM REPORTE STRING((gn-clie.libre_d01), '>>>9') SKIP.
      PUT STREAM REPORTE '^FS'                          SKIP.   /* Fin de Campo2 */
  END.
  */
  /* Clientes Correlativo */

  /*IF gn-clie.libre_c02 <> ''  AND gn-clie.libre_c02 <> ? THEN DO:*/
  IF lNroCorre <> ''  AND lNroCorre <> ? THEN DO:
      PUT STREAM REPORTE '^FO650,50'                     SKIP.   /* Coordenadas de origen campo2 */
      PUT STREAM REPORTE '^A0N,25,25'                   SKIP.
      PUT STREAM REPORTE '^FD'.
      PUT STREAM REPORTE lNroCorre FORMAT 'x(6)' SKIP.
      PUT STREAM REPORTE '^FS'                          SKIP.   /* Fin de Campo2 */
  END.

/*   PUT STREAM REPORTE '^FO250,50'                    SKIP.   /* Coordenadas de origen campo2 */ */
/*   PUT STREAM REPORTE '^A0N,35,35'                   SKIP.                                      */
/*   PUT STREAM REPORTE '^FD'.                                                                    */
/*   PUT STREAM REPORTE STRING("** Expolibreria 2012 **")      FORMAT 'x(26)' SKIP.               */
/*   PUT STREAM REPORTE '^FS'                          SKIP.   /* Fin de Campo2 */                */

  PUT STREAM reporte '^FO10,110^BY3'                SKIP.  
  PUT STREAM reporte '^B3N,N,50,N,N'               SKIP.
  PUT STREAM reporte '^FD'.
  PUT STREAM reporte  STRING(cCodCli)               FORMAT "X(11)" SKIP.
  PUT STREAM reporte '^FS'                          SKIP.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


