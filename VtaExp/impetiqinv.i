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
/*
DEF STREAM REPORTE.
DEF SHARED VAR s-codalm AS CHAR.

*/

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
         HEIGHT             = 9.12
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
    
  PUT STREAM reporte '^FO120,25'                                   SKIP.  
  PUT STREAM reporte '^A0R,40,30'                                  SKIP.
  PUT STREAM reporte '^FDINV. ABR-10^FS'                           SKIP.  

  PUT STREAM reporte '^FO80,25'                                    SKIP.  
  PUT STREAM reporte '^A0R,40,30'                                  SKIP.
  PUT STREAM reporte '^FDResp_______________^FS'                   SKIP.

  PUT STREAM reporte '^FO30,25'                                    SKIP.  
  PUT STREAM reporte '^A0R,40,30'                                  SKIP.
  PUT STREAM reporte '^FDALM  '.
  PUT STREAM reporte  s-codalm .
  PUT STREAM reporte '^FS'                                         SKIP.

  PUT STREAM REPORTE '^FS'                                         SKIP.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


