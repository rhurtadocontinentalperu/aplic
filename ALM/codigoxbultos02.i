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

/*   PUT STREAM REPORTE '^FO10,10'                         SKIP.   /* Coordenadas de origen campo2 */    */
/*   PUT STREAM REPORTE '^A0N,20,50'                       SKIP.                                         */
/*   PUT STREAM REPORTE '^FD'.                                                                           */
/*   PUT STREAM REPORTE '_____________________________'    FORMAT 'x(100)'   SKIP.                       */
/*   PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */                   */
/*                                                                                                       */
/*   PUT STREAM REPORTE '^FO10,30'                         SKIP.   /* Coordenadas de origen campo2 */    */
/*   PUT STREAM REPORTE '^A0R,30,30'                       SKIP.                                         */
/*   PUT STREAM REPORTE '^FD'.                                                                           */
/*   PUT STREAM REPORTE '___________________________'    FORMAT 'x(100)'   SKIP.                         */
/*   PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */                   */
/*   PUT STREAM REPORTE '^FO250,110'                         SKIP.   /* Coordenadas de origen campo2 */  */
/*   PUT STREAM REPORTE '^A0R,30,30'                       SKIP.                                         */
/*   PUT STREAM REPORTE '^FD'.                                                                           */
/*   PUT STREAM REPORTE '______________________'    FORMAT 'x(100)'   SKIP.                              */
/*   PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */                   */
/*                                                                                                       */
/*   PUT STREAM REPORTE '^FO730,30'                         SKIP.   /* Coordenadas de origen campo2 */   */
/*   PUT STREAM REPORTE '^A0R,30,30'                       SKIP.                                         */
/*   PUT STREAM REPORTE '^FD'.                                                                           */
/*   PUT STREAM REPORTE '___________________________'    FORMAT 'x(100)'   SKIP.                         */
/*   PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */                   */
 
  PUT STREAM REPORTE '^FO80,40'                         SKIP.   /* Coordenadas de origen */
  PUT STREAM REPORTE '^A0N,40,40'                       SKIP.   /* Coordenada de impresion */
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE 'No. O/C ' + x-nroord              SKIP.   /* Descripcion */
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo1 */

/*   PUT STREAM REPORTE '^FO10,90'                         SKIP.   /* Coordenadas de origen campo2 */ */
/*   PUT STREAM REPORTE '^A0N,20,50'                       SKIP.                                      */
/*   PUT STREAM REPORTE '^FD'.                                                                        */
/*   PUT STREAM REPORTE '_____________________________'    FORMAT 'x(100)'   SKIP.                    */
/*   PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */                */
  
  PUT STREAM REPORTE '^FO155,100'                       SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,30,30'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE 'DESCRIPCION DEL PRODUCTO'         FORMAT 'x(26)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */
  PUT STREAM REPORTE '^FO30,160'                        SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,35,35'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE STRING(almmmatg.desmat)            FORMAT 'x(40)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

/*   PUT STREAM REPORTE '^FO10,140'                         SKIP.   /* Coordenadas de origen campo2 */  */
/*   PUT STREAM REPORTE '^A0N,20,50'                       SKIP.                                        */
/*   PUT STREAM REPORTE '^FD'.                                                                          */
/*   PUT STREAM REPORTE '_____________________________'    FORMAT 'x(100)'   SKIP.                      */
/*   PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */                  */

  PUT STREAM REPORTE '^FO30,200'                        SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,25,25'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE 'NUMERO ARTICULO PROVEEDOR'        FORMAT 'x(35)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO400,200'                       SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,25,25'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE 'NUMERO DE UNIDADES EN BULTO'      FORMAT 'x(35)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO100,230'                        SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,50,50'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE STRING(x-codmat)                     FORMAT 'x(11)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO450,230'                       SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,60,60'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE STRING(x-undemp)                         FORMAT 'x(35)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */


  PUT STREAM REPORTE '^FO100,300'                        SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,30,30'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE 'CODIGO DE BARRAS'                  FORMAT 'x(35)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO450,300'                       SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,30,30'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE 'NUMERO DE BULTOS'                 FORMAT 'x(35)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  /*Codigo Ean 13*/
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */
  PUT STREAM REPORTE '^FO100,340'                        SKIP.   /* Coordenadas de origen barras */
  PUT STREAM REPORTE '^BEN,70'                          SKIP.   /* Codigo 128 */
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE Almmmatg.CodBrr FORMAT 'x(13)'     SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO450,350'                       SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,25,25'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE STRING('01/04')                    FORMAT 'x(35)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO45,420'                         SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0N,20,50'                       SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE '_________________'    FORMAT 'x(100)'   SKIP.
  PUT STREAM REPORTE '^FS'                              SKIP.   /* Fin de Campo2 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


