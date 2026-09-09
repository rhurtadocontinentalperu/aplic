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
         HEIGHT             = 3.54
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
    /* CORREGIMOS IMPORTES: El Precio Unitario ya está afectado con el FLETE */
    ASSIGN
        {&Detalle}.ImpLin = ROUND ( {&Detalle}.CanDes * {&Detalle}.PreUni * 
                                  ( 1 - {&Detalle}.Por_Dsctos[1] / 100 ) *
                                  ( 1 - {&Detalle}.Por_Dsctos[2] / 100 ) *
                                  ( 1 - {&Detalle}.Por_Dsctos[3] / 100 ), 2 ).
    IF {&Detalle}.Por_Dsctos[1] = 0 AND {&Detalle}.Por_Dsctos[2] = 0 AND {&Detalle}.Por_Dsctos[3] = 0 
        THEN {&Detalle}.ImpDto = 0.
    ELSE {&Detalle}.ImpDto = ( {&Detalle}.CanDes * {&Detalle}.PreUni ) - {&Detalle}.ImpLin.
    /* ****************************************** */
    /* OTROS DESCUENTOS: LOGISTICOS O FINANCIEROS */
    /* ****************************************** */
    IF {&Detalle}.Dcto_Otros_PV > 0 THEN DO:
        {&Detalle}.ImpLin = {&Detalle}.ImpLin - {&Detalle}.Dcto_Otros_PV.
        {&Detalle}.ImpDto = ( {&Detalle}.CanDes * {&Detalle}.PreUni ) - {&Detalle}.ImpLin.
    END.
    /* ****************************************** */
    /* ****************************************** */
    ASSIGN
        {&Detalle}.ImpLin = ROUND({&Detalle}.ImpLin, 2)
        {&Detalle}.ImpDto = ROUND({&Detalle}.ImpDto, 2).
    IF {&Detalle}.AftIsc 
        THEN {&Detalle}.ImpIsc = ROUND({&Detalle}.PreBas * {&Detalle}.CanDes * (Almmmatg.PorIsc / 100),4).
    ELSE {&Detalle}.ImpIsc = 0.
    IF {&Detalle}.AftIgv = YES
        THEN {&Detalle}.ImpIgv = {&Detalle}.ImpLin - ROUND( {&Detalle}.ImpLin  / ( 1 + ({&Cabecera}.PorIgv / 100) ), 4 ).
    ELSE {&Detalle}.ImpIgv = 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


