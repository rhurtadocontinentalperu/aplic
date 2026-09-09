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
  DEF VAR x-Familias-sin-Dsctos AS CHAR NO-UNDO.

  x-Familias-sin-Dsctos = "000,011,008".

  CASE s-FlgSit:
      WHEN "C" THEN DO:     /* CUPONES */
          FIND FIRST VtaListaMin OF Almmmatg WHERE VtaListaMin.CodDiv = "99999" 
              AND (TODAY >= 02/19/2011 AND TODAY <= 02/28/2011) NO-LOCK NO-ERROR.
          IF AVAILABLE VtaListaMin 
              THEN ASSIGN
                        {&Tabla}.Libre_c04 = "C"
                        {&Tabla}.Libre_c05 = "** PRECIO SUPEREBAJADO **".
      END.
      WHEN "T" THEN DO:
          /* RHC Promociones por Bancos */
          CASE s-CodBko:
              WHEN "WI" THEN DO:            /* Scotiabank */
                  IF TODAY <= 03/10/2011 THEN DO:
                      /* Definimos el mejor descuento */
                      IF MAXIMUM( {&Tabla}.Por_Dsctos[1], {&Tabla}.Por_Dsctos[2], {&Tabla}.Por_Dsctos[3] ) < 10 
                          /*AND LOOKUP(Almmmatg.codfam, '001,002,010,012,013,014') > 0*/
                          AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0
                      THEN ASSIGN
                                {&Tabla}.Por_Dsctos[1] = 0
                                {&Tabla}.Por_Dsctos[2] = 0
                                {&Tabla}.Por_Dsctos[3] = 0
                                {&Tabla}.Libre_c04 = "T,WI"
                                {&Tabla}.PorDto2 = 10.      /* 10% */
                      ELSE ASSIGN
                                {&Tabla}.PorDto2 = 0.
                  END.
              END.
              WHEN "CR" THEN DO:            /* Banco de Credito */
                  /* Solo Cuenta Sueldo */
                  IF s-Tarjeta = "05" AND TODAY <= 12/31/2011 THEN DO:
                      /* Definimos el mejor descuento */
                      IF MAXIMUM( {&Tabla}.Por_Dsctos[1], {&Tabla}.Por_Dsctos[2], {&Tabla}.Por_Dsctos[3] ) < 10 
                          /*AND LOOKUP(Almmmatg.codfam, '001,002,010,012,013,014') > 0*/
                          AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0
                      THEN ASSIGN
                                {&Tabla}.Por_Dsctos[1] = 0
                                {&Tabla}.Por_Dsctos[2] = 0
                                {&Tabla}.Por_Dsctos[3] = 0
                                {&Tabla}.Libre_c04 = "T,CR,05"
                                {&Tabla}.PorDto2 = 10.      /* 10% */
                      ELSE ASSIGN
                                {&Tabla}.PorDto2 = 0.
                  END.
              END.
          END CASE.
      END.
      WHEN "V" THEN DO:
          /* Definimos el mejor descuento */
          IF MAXIMUM( {&Tabla}.Por_Dsctos[1], {&Tabla}.Por_Dsctos[2], {&Tabla}.Por_Dsctos[3] ) < 10 
              /*AND LOOKUP(Almmmatg.codfam, '001,002,010,012,013,014') > 0*/
              AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0
          THEN ASSIGN
                    {&Tabla}.Por_Dsctos[1] = 0
                    {&Tabla}.Por_Dsctos[2] = 0
                    {&Tabla}.Por_Dsctos[3] = 0
                    {&Tabla}.Libre_c04 = "V"
                    {&Tabla}.PorDto2 = 10.      /* 10% */
          ELSE ASSIGN
                    {&Tabla}.PorDto2 = 0.
      END.
      WHEN "X" THEN DO:
          /* Definimos el mejor descuento */
          IF MAXIMUM( {&Tabla}.Por_Dsctos[1], {&Tabla}.Por_Dsctos[2], {&Tabla}.Por_Dsctos[3] ) < 15
              /*AND LOOKUP(Almmmatg.codfam, '001,002,010,012,013,014') > 0*/
              AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0
          THEN ASSIGN
                    {&Tabla}.Por_Dsctos[1] = 0
                    {&Tabla}.Por_Dsctos[2] = 0
                    {&Tabla}.Por_Dsctos[3] = 0
                    {&Tabla}.Libre_c04 = "X"
                    {&Tabla}.PorDto2 = 15.      /* 15% */
          ELSE ASSIGN
                    {&Tabla}.PorDto2 = 0.
      END.
  END CASE.

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


