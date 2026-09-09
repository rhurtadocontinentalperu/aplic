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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  ASSIGN
      {&Tabla}.ImpLin = {&Tabla}.CanPed * {&Tabla}.PreUni * 
                    ( 1 - {&Tabla}.Por_Dsctos[1] / 100 ) *
                    ( 1 - {&Tabla}.Por_Dsctos[2] / 100 ) *
                    ( 1 - {&Tabla}.Por_Dsctos[3] / 100 )
      {&Tabla}.ImpDto2 = ROUND ( {&Tabla}.ImpLin * {&Tabla}.PorDto2 / 100, 2).
  IF {&Tabla}.Por_Dsctos[1] = 0 AND {&Tabla}.Por_Dsctos[2] = 0 AND {&Tabla}.Por_Dsctos[3] = 0 
      THEN {&Tabla}.ImpDto = 0.
      ELSE {&Tabla}.ImpDto = {&Tabla}.CanPed * {&Tabla}.PreUni - {&Tabla}.ImpLin.
  ASSIGN
      {&Tabla}.ImpLin = ROUND({&Tabla}.ImpLin, 2)
      {&Tabla}.ImpDto = ROUND({&Tabla}.ImpDto, 2).
  IF {&Tabla}.AftIsc 
  THEN {&Tabla}.ImpIsc = ROUND({&Tabla}.PreBas * {&Tabla}.CanPed * (Almmmatg.PorIsc / 100),4).
  IF {&Tabla}.AftIgv 
  THEN {&Tabla}.ImpIgv = {&Tabla}.ImpLin - ROUND( {&Tabla}.ImpLin  / ( 1 + (FacCfgGn.PorIgv / 100) ), 4 ).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


