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
         HEIGHT             = 4.04
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  PUT STREAM REPORTE '^FO10,10'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,20,50'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE '_____________________________'    FORMAT 'x(100)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO10,30'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0R,30,30'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE '___________________________'    FORMAT 'x(100)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */
  PUT STREAM REPORTE '^FO250,110'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0R,30,30'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE '______________________'    FORMAT 'x(100)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO730,30'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0R,30,30'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE '___________________________'    FORMAT 'x(100)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */
 
  PUT STREAM REPORTE '^FO155,60'                        SKIP.   /* Coordenadas de origen */
  PUT STREAM REPORTE '^A0N,50,50'                       SKIP.   /* Coordenada de impresion */
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE 'CONTINENTAL SAC' FORMAT 'x(40)'   SKIP.   /* Descripcion */
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo1 */

  PUT STREAM REPORTE '^FO10,90'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,20,50'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE '_____________________________'    FORMAT 'x(100)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */
  
  PUT STREAM REPORTE '^FO30,120'                        SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,30,30'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE 'FORMATO'         FORMAT 'x(26)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */
  PUT STREAM REPORTE '^FO300,120'                       SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,40,40'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE STRING(x-nomcia)  FORMAT 'x(26)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO10,140'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,20,50'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE '_____________________________'    FORMAT 'x(100)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO30,170'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,30,30'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE 'CODIGO SAP'          FORMAT 'x(10)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */
  PUT STREAM REPORTE '^FO350,170'                        SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,35,35'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE STRING(x-codmat)  FORMAT 'x(6)'    SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO10,180'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,20,50'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE '_____________________________'    FORMAT 'x(100)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO30,220'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,30,30'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE 'DESCRIPCION'     FORMAT 'x(15)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */
  PUT STREAM REPORTE '^FO300,220'                        SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,35,25'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE STRING(x-desmat)  FORMAT 'x(40)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */
  PUT STREAM REPORTE '^FO300,260'                        SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,35,25'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE STRING(x-desma2)  FORMAT 'x(40)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO10,270'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,20,50'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE '_____________________________'    FORMAT 'x(100)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO30,300'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,30,30'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE 'UNIDAD X CAJA'   FORMAT 'x(15)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */
  PUT STREAM REPORTE '^FO300,300'                        SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,30,30'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE STRING(x-undemp)  FORMAT 'x(26)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO10,315'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,20,50'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE '_____________________________'    FORMAT 'x(100)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */


  PUT STREAM REPORTE '^FO30,340'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,30,30'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE 'EAN 13'          FORMAT 'x(15)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */
  /*Codigo Ean 13*/
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */
  PUT STREAM REPORTE '^FO350,340'                        SKIP.   /* Coordenadas de origen barras */
  PUT STREAM REPORTE '^BEN,70'                          SKIP.   /* Codigo 128 */
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE Almmmatg.CodBrr FORMAT 'x(13)'     SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO10,420'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,20,50'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE '_____________________________'    FORMAT 'x(100)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


