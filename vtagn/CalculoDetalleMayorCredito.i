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

/* ****************************************************************** */
/* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
/* RHC 04/05/2020 Nueva forma de calcular */
/* ****************************************************************** */
/* Ic - 28Set2018, si el flete debe considerarse, segun Karin Roden.... */
/* RUN gn/factor-porcentual-flete-v2(INPUT pCodDiv,                */
/*                                   INPUT {&Tabla}.codmat,        */
/*                                   INPUT-OUTPUT f-FleteUnitario, */
/*                                   INPUT s-TpoPed,               */
/*                                   INPUT f-factor,               */
/*                                   INPUT s-CodMon).              */
/* ASSIGN                                                          */
/*     {&Tabla}.Libre_d02 = f-FleteUnitario.                       */

/* CON FLETE */
IF {&Tabla}.Libre_d02 > 0 THEN DO:
    /* El flete afecta el monto final */
    IF {&Tabla}.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
        ASSIGN
            {&Tabla}.PreUni = ROUND({&Tabla}.PreUni + {&Tabla}.Libre_d02, s-NroDec)  /* Incrementamos el PreUni */
            {&Tabla}.ImpLin = {&Tabla}.CanPed * {&Tabla}.PreUni.
    END.
    ELSE DO:      /* CON descuento promocional o volumen */
        /* El flete afecta al precio unitario resultante */
        DEF VAR LocalPreUniFin LIKE Facdpedi.PreUni NO-UNDO.
        DEF VAR LocalPreUniTeo LIKE Facdpedi.PreUni NO-UNDO.
        LocalPreUniFin = {&Tabla}.ImpLin / {&Tabla}.CanPed.     /* Valor resultante */
        LocalPreUniFin = LocalPreUniFin + {&Tabla}.Libre_d02.    /* Unitario Afectado al Flete */
        LocalPreUniTeo = LocalPreUniFin / ( ( 1 - {&Tabla}.Por_Dsctos[1] / 100 ) * ( 1 - {&Tabla}.Por_Dsctos[2] / 100 ) * ( 1 - {&Tabla}.Por_Dsctos[3] / 100 ) ). 
        IF LocalPreUniTeo = ? THEN LocalPreUniTeo = 0.

        /* Comtemplar 100 dsctos que viene desde el pedido comercial - Susana Leon/Carla Tenazoa*/
        IF LocalPreUniTeo <= 0 AND ({&Tabla}.Por_Dsctos[1] + {&Tabla}.Por_Dsctos[2] + {&Tabla}.Por_Dsctos[3] ) >= 100 THEN LocalPreUniTeo = {&Tabla}.PreUni.

        /*MESSAGE {&Tabla}.ImpLin {&Tabla}.Libre_d02 LocalPreUniFin LocalPreUniTeo.*/
        ASSIGN
            {&Tabla}.PreUni = ROUND(LocalPreUniTeo, s-NroDec).
/*         ASSIGN                                                                                         */
/*             {&Tabla}.ImpLin = {&Tabla}.ImpLin + ({&Tabla}.CanPed * {&Tabla}.Libre_d02)                 */
/*             {&Tabla}.PreUni = ROUND( ({&Tabla}.ImpLin + {&Tabla}.ImpDto) / {&Tabla}.CanPed, s-NroDec). */
    END.
    ASSIGN
        {&Tabla}.ImpLin = ROUND ( {&Tabla}.CanPed * {&Tabla}.PreUni * 
                                  ( 1 - {&Tabla}.Por_Dsctos[1] / 100 ) *
                                  ( 1 - {&Tabla}.Por_Dsctos[2] / 100 ) *
                                  ( 1 - {&Tabla}.Por_Dsctos[3] / 100 ), 2 ).
    IF {&Tabla}.Por_Dsctos[1] = 0 AND {&Tabla}.Por_Dsctos[2] = 0 AND {&Tabla}.Por_Dsctos[3] = 0 
        THEN {&Tabla}.ImpDto = 0.
    ELSE {&Tabla}.ImpDto = ({&Tabla}.CanPed * {&Tabla}.PreUni) - {&Tabla}.ImpLin.

END.
/*MESSAGE f-prebas f-fleteunitario {&Tabla}.ImpDto LocalPreUniTeo.*/
/*/* ***************************************************************** */*/
ASSIGN
    {&Tabla}.ImpLin = ROUND({&Tabla}.ImpLin, 2)
    {&Tabla}.ImpDto = ROUND({&Tabla}.ImpDto, 2).
IF {&Tabla}.AftIsc 
    THEN {&Tabla}.ImpIsc = ROUND({&Tabla}.PreBas * {&Tabla}.CanPed * (Almmmatg.PorIsc / 100),4).
IF {&Tabla}.AftIgv 
    THEN {&Tabla}.ImpIgv = {&Tabla}.ImpLin - ROUND( {&Tabla}.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).

  /* ************************************ */
  /* RHC 07/11/2013 CALCULO DE PERCEPCION */
  /* ************************************ */
/*   DEF VAR s-PorPercepcion AS DEC INIT 0 NO-UNDO.                                           */
/*   ASSIGN                                                                                   */
/*       {&Tabla}.CanSol = 0                                                                  */
/*       {&Tabla}.CanApr = 0.                                                                 */
/*   FIND FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia                                     */
/*       AND Vtatabla.tabla = 'CLNOPER'                                                       */
/*       AND VtaTabla.Llave_c1 = s-CodCli                                                     */
/*       NO-LOCK NO-ERROR.                                                                    */
/*   IF NOT AVAILABLE Vtatabla THEN DO:                                                       */
/*       FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = s-codcli NO-LOCK. */
/*       IF gn-clie.Libre_L01 = YES AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 0.5.    */
/*       IF gn-clie.Libre_L01 = NO AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 2.       */
/*       /* Ic 04 Julio 2013                                                                  */
/*           gn-clie.Libre_L01   : PERCEPCTOR                                                 */
/*           gn-clie.RucOld      : RETENEDOR                                                  */
/*       */                                                                                   */
/*       IF s-Cmpbnte = "BOL" THEN s-Porpercepcion = 2.                                       */
/*       FIND Almsfami OF Almmmatg NO-LOCK NO-ERROR.                                          */
/*       IF AVAILABLE ALmsfami AND Almsfami.Libre_c05 = "SI" THEN                             */
/*           ASSIGN                                                                           */
/*           {&Tabla}.CanSol = s-PorPercepcion                                                */
/*           {&Tabla}.CanApr = ROUND({&Tabla}.implin * s-PorPercepcion / 100, 2).             */
/*   END.                                                                                     */
  /* ************************************ */

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


