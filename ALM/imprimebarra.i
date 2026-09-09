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
         HEIGHT             = 4.5
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
  /*  
  PUT STREAM reporte '^FO120,25'                                   SKIP.  
  PUT STREAM reporte '^A0R,40,30'                                  SKIP.
  PUT STREAM reporte '^FD'.
  PUT STREAM reporte  cb-niveles .
  PUT STREAM reporte '^FS'                                         SKIP.

  PUT STREAM REPORTE '^FS'                                         SKIP.

  */
  
  PUT STREAM reporte '^FO250,20^BY2'                               SKIP.  
  PUT STREAM reporte '^B3N,N,100,Y,N'                               SKIP.
  PUT STREAM reporte '^FD'.
  PUT STREAM reporte  cVar.
  PUT STREAM reporte '^FS'                                         SKIP.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


