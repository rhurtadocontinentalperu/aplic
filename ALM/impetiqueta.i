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
    
  PUT STREAM reporte '^FO160,5'                                    SKIP.  
  /*PUT STREAM reporte '^AOR,25,15'                                  SKIP. 
  PUT STREAM reporte '^FDFabricado por:Continental S.A.C^FS'       SKIP.*/ 

  PUT STREAM reporte '^A0R,30,20'                                  SKIP.
  PUT STREAM reporte '^FDFabricado por:Continental S.A.C^FS' SKIP.

  PUT STREAM reporte '^FO135,25'                                   SKIP.  
  PUT STREAM reporte '^A0R,25,15'                                  SKIP.
  PUT STREAM reporte '^FDRenée Descartes Mz C. Lt 1 Urb. Santa^FS' SKIP.
  PUT STREAM reporte '^FO110,25'                                   SKIP.  
  PUT STREAM reporte '^A0R,25,15'                                  SKIP.
  PUT STREAM reporte '^FDRaquel II Etapa Ate Vitarte Lima-Perú^FS' SKIP.
  PUT STREAM reporte '^FO85,25'                                   SKIP.  
  PUT STREAM reporte '^A0R,25,15'                                  SKIP.  
  PUT STREAM reporte '^FDTélef: 715-8888   RUC:20100038146^FS'   SKIP.
  PUT STREAM reporte '^FO60,62'                                    SKIP.  
  PUT STREAM reporte '^A0R,25,15'                                  SKIP.  
  PUT STREAM reporte '^FDRPIN: 150104480159C^FS'               SKIP.
  PUT STREAM reporte '^FO35,78'                                    SKIP.  
  PUT STREAM reporte '^A0R,25,15'                                  SKIP.  
  PUT STREAM reporte '^FDHECHO EN PERU'                       SKIP.
  PUT STREAM REPORTE '^FS'                                         SKIP.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


