&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF TEMP-TABLE Cabecera
    FIELD NroControl    AS CHAR FORMAT 'x(12)'  LABEL 'Incidencia'
    FIELD CodDoc        AS CHAR FORMAT 'x(3)'   LABEL 'Ref'
    FIELD NroDoc        AS CHAR FORMAT 'x(12)'  LABEL 'Numero'
    FIELD Estado        AS CHAR FORMAT 'x(15)'  LABEL 'Estado'
    FIELD UsrReceptor   AS CHAR FORMAT 'x(80)'  LABEL 'Usuario Receptor Inc.'
    FIELD Fecha         AS DATE                 LABEL 'Fecha Emision Inc'
    FIELD Hora          AS CHAR FORMAT 'x(5)'   LABEL 'Hora Emision'
    FIELD FchReg        AS DATE                 LABEL 'Fecha de Regularizacion de Inc'
    FIELD AlmOri        AS CHAR FORMAT 'x(8)'   LABEL 'Alm. Origen'
    FIELD DesOri        AS CHAR FORMAT 'x(40)'  LABEL 'Descripcion Alm. Origen'
    FIELD AlmDes        AS CHAR FORMAT 'x(8)'   LABEL 'Alm. Destino'
    FIELD DesDes        AS CHAR FORMAT 'x(40)'  LABEL 'Descripcion Alm. Destino'
    FIELD Usuario       AS CHAR FORMAT 'x(12)'  LABEL 'Usuario Generacion'
    FIELD UsrEmisor     AS CHAR FORMAT 'x(80)'  LABEL 'Nombre usuario emisor indidencia'
    FIELD ChkAlmOri     AS CHAR FORMAT 'x(8)'   LABEL 'Cheq. Alm. Orig.'
    FIELD NomChkAlmOri  AS CHAR FORMAT 'x(40)'  LABEL 'Nom. Cheq. Alm. Orig.'
    FIELD ChkAlmDes     AS CHAR FORMAT 'x(8)'   LABEL 'Cheq. Alm. Des.'
    FIELD NomChkAlmDes  AS CHAR FORMAT 'x(40)'  LABEL 'Nom. Cheq. Alm. Des.'
    FIELD Motivo        AS CHAR FORMAT 'x(40)'  LABEL 'Motivo'
    FIELD Glosa         AS CHAR FORMAT 'x(100)' LABEL 'Glosa'
/*
    FIELD CodPro        AS CHAR FORMAT 'x(15)'  LABEL 'Transportista'
    FIELD NomPro        AS CHAR FORMAT 'x(60)'  LABEL 'Nombre del transportista'
    FIELD Conductor     AS CHAR FORMAT 'x(15)'  LABEL 'Conductor'
    FIELD NomConductor  AS CHAR FORMAT 'x(60)'  LABEL 'Nombre del conductor'
    FIELD Placa         AS CHAR FORMAT 'x(15)'  LABEL 'Placa'
    FIELD GuiaRem       AS CHAR FORMAT 'x(20)'  LABEL 'GR Transportista'
    FIELD HRuta         AS CHAR FORMAT 'x(15)'  LABEL 'Hoja de Ruta'
*/    
    .

DEF TEMP-TABLE Detalle LIKE Cabecera
    FIELD CodMat        AS CHAR FORMAT 'x(6)'   LABEL 'Codigo'
    FIELD DesMat        AS CHAR FORMAT 'x(80)'  LABEL 'Descripcion Item'
    FIELD DesMar        AS CHAR FORMAT 'x(20)'  LABEL 'Marca'
    FIELD UndVta        AS CHAR FORMAT 'x(8)'   LABEL 'Und'
    FIELD Indicencia    AS CHAR FORMAT 'x(20)'  LABEL 'Descripcion Incidencia'
    FIELD CanInc        AS DEC FORMAT '>,>>>,>>9.9999'  COLUMN-LABEL 'Cantidad Incidencia'
    FIELD NroRA         AS CHAR FORMAT 'x(12)'  LABEL 'R/A'
    FIELD NroOTR        AS CHAR FORMAT 'x(12)'  LABEL 'OTR'
    FIELD Salida        AS CHAR FORMAT 'x(12)'  LABEL 'Salida'
    FIELD Ingreso       AS CHAR FORMAT 'x(12)'  LABEL 'Ingreso'
    .

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


