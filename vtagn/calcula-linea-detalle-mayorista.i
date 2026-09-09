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

ASSIGN
    {&Tabla}.ImpLin = {&Tabla}.CanPed * {&Tabla}.PreUni * 
                  ( 1 - {&Tabla}.Por_Dsctos[1] / 100 ) *
                  ( 1 - {&Tabla}.Por_Dsctos[2] / 100 ) *
                  ( 1 - {&Tabla}.Por_Dsctos[3] / 100 ).
IF {&Tabla}.Por_Dsctos[1] = 0 AND {&Tabla}.Por_Dsctos[2] = 0 AND {&Tabla}.Por_Dsctos[3] = 0 
THEN {&Tabla}.ImpDto = 0.
ELSE {&Tabla}.ImpDto = {&Tabla}.CanPed * {&Tabla}.PreUni - {&Tabla}.ImpLin.

/* RHC 04/08/2015 Si existe {&Tabla}.Libre_d02 se recalcula el Descuento */
IF {&Tabla}.Libre_d02 > 0 THEN DO:
    RUN gn/factor-porcentual-flete-v2(INPUT pCodDiv, 
                                      INPUT {&Tabla}.codmat, 
                                      INPUT-OUTPUT {&Tabla}.Libre_d02, 
                                      INPUT s-TpoPed, 
                                      INPUT {&Tabla}.Factor, 
                                      INPUT s-CodMon).

    ASSIGN 
        {&Tabla}.Libre_d02 = {&Tabla}.Libre_d02. 

    /* El flete afecta el monto final */
    IF {&Tabla}.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
        ASSIGN
            {&Tabla}.PreUni = ROUND({&Tabla}.PreUni + {&Tabla}.Libre_d02, s-NroDec)  /* Incrementamos el PreUni */
            {&Tabla}.ImpLin = {&Tabla}.CanPed * {&Tabla}.PreUni.
    END.
    ELSE DO:      /* CON descuento promocional o volumen */
        ASSIGN
            {&Tabla}.ImpLin = {&Tabla}.ImpLin + ({&Tabla}.CanPed * {&Tabla}.Libre_d02)
            {&Tabla}.PreUni = ROUND( ({&Tabla}.ImpLin + {&Tabla}.ImpDto) / {&Tabla}.CanPed, s-NroDec).
    END.
END.
/* ***************************************************************** */
ASSIGN
    {&Tabla}.ImpLin = ROUND({&Tabla}.ImpLin, 2)
    {&Tabla}.ImpDto = ROUND({&Tabla}.ImpDto, 2).
IF {&Tabla}.AftIsc 
    THEN {&Tabla}.ImpIsc = ROUND({&Tabla}.PreBas * {&Tabla}.CanPed * (Almmmatg.PorIsc / 100),4).
IF {&Tabla}.AftIgv 
    THEN {&Tabla}.ImpIgv = {&Tabla}.ImpLin - ROUND( {&Tabla}.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).

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
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


